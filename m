Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F12FC10854DC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D4156B0156; Wed, 18 Mar 2026 05:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB626B0158; Wed, 18 Mar 2026 05:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1406B0159; Wed, 18 Mar 2026 05:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B28A6B0156
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:42:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A92FF1605E8
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:42:19 +0000 (UTC)
X-FDA: 84558693198.08.046EBCF
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD1164000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:42:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KyeGDZYu;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773826937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6gCldRA593oK/V7CJ8wzdqzw/ok81DziYzTxHj6iS0=;
	b=q98qeq0dpv+wHh42TwA4LKYBmDt3s2Z4ep0EZmatcF5MfkHQRBTQopS/TXyRxKyuqzmn4A
	06qyBTj0hBTvwuE2FJdax311RHRsNV3U1HLrpvgFdZDY8SZdztYyWwITKTJhrgWHQj3gxJ
	ZyxCnR79KBl+JRKrnvWLTJhWpofPGHo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KyeGDZYu;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773826937; a=rsa-sha256;
	cv=pass;
	b=4ReRW9msTI3nKY5oO8lbaiDritwgMI2EG1OXQsgi3uyLiF21mS0ZpmuF+e5L5JKkv/8pc2
	gW7cJScphfIRBIUxxkhzeJaAxgG2TmTKDyEbZ82ETGatexNuY/x+qxOUFAJ26gOpw7n1c5
	mwUNa3QqXkylOeW/rjDT0uPGXxEhwy4=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cd8d97aa2eso866203785a.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:42:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773826937; cv=none;
        d=google.com; s=arc-20240605;
        b=Wjs816wlFBntYqyv6VvonihVTvO0n4tYMW3Am9iJYZMincyyQB017Kpmibz2qyUJt7
         rQhOHa6Ka/32cE+oGiph/upU/TmsjM5amFltgM6/5yZdIQq6WdaRN7OfFoAzJ5Ws6wv8
         l/KSXNCmMoX+jb4wHQlbTJVdo9BLse6aMQxPrF1YDJpA8HpkCErCaumMhCyyrUR0fyGE
         gbjxBT70DY6hwlgAndOiNZptNzrL1aWmNeK354zg3JWaJSyL0O6MmjrQNepjpSsF7BoW
         gbBwssXm6ipQrhF6PVdmEUA1TR8mVkcgalEvQcvZYm/egbNVBLgGwJ2KhyI1jCOCKlLJ
         yQ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B6gCldRA593oK/V7CJ8wzdqzw/ok81DziYzTxHj6iS0=;
        fh=/JkQnwljR5A49aQg7Gv9c52PqVY75h6ML62R/ZWNr+I=;
        b=a5PGIyLA4Tn+SDEd3s+OfTxISiJDqcFLg/DZmNfRPVErtrUeIpNQevxlXHBTSuLv89
         moujJOAUCcDJ01JX9E7qiumQlTjv//xx0RoCv0O/YLFER+aUsfkVh33wGGpKuL0sXot7
         pD2FHuHhZBIV5o2ec57f+6ymUcJc8Vla4qbqqNDphaCqqqAdyq0txjYxfZ05784E1OAd
         HEYa5Oa4kr1QFb35oRcQDF71yuJkwHpUZ0qYI1WGbNtnNyjza2Ad+9H+8oGGByx1EH3P
         yfUxBlGSKxdrQ1ku8GV2SJdYcWgRSlzSbP43r7FHFcDAmQgrje476G9ZV0NwjNZ8cis9
         IMAg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773826937; x=1774431737; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6gCldRA593oK/V7CJ8wzdqzw/ok81DziYzTxHj6iS0=;
        b=KyeGDZYufoT8sg5+oETsVmki5u23I1VHxkBPXcOZ0/fFygTuJPoevz+VajPaHc/+zx
         eR11ksGgWnuAa7QxjCOT88Rshh/6Ape4zWByo65k+XNtQrf1hOoj24afHxZb31TO/iPV
         RFzGoATge+SzvFw+OhpX7KUhOOyOV5CMXtt3gkLyEpQujpf0nSdb+9MpKETXExanQbCh
         MupIzOTeNKQbsCll/SbJcXjI7OGa1K9t28Q+Jk9ljH5pB8pXWJgTGA2ljK6hNyPLgHtv
         dyaGmCEF9BqKKo9/vySYDTTsB3LaFkZBdvyBy1vIBFWhT+HM1AOGBaIUBPt0Kdsz1VvJ
         u22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773826937; x=1774431737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B6gCldRA593oK/V7CJ8wzdqzw/ok81DziYzTxHj6iS0=;
        b=apt4Id+WxApkj266euiPXC4uBCQ2OOosX5nJlNDyH13tUODM9ViZP2dFZ40DEB/wde
         Kj8OOdk08xkF6Jj7tHPhYHmkaanNM8c5PhPgfII7tTb33aXQIqeOujVXT2iH1fF3eloM
         D8BRv2N4IoAcBr8+Xp/R0iG+6Cw8+UcG5ZiitaJvF3t6IcvKTizcRPDVxnQ8WsbeEqqb
         YOsBwHBVDkZo6mvFH9wLXp5rmE6F3PQnNAd0UYvh4WX8cj2duYAW2LsxCvPviNX4W2X/
         xYwGAWkSqXj9rlX1iuWOOV6d2w8y1SuR03SmArPRXNUb8laf59SYa5kwaZvv7d70tvLU
         30Kw==
X-Gm-Message-State: AOJu0YwcSs+bV5yLhb+TKzjzYU5hlwzh435tV4jSjobaM4eEt8W4X4Ht
	gK9zYQCt9XqFsBCMCTulPfZZuixtETs0x+bRpVfXUdyFzceQ4fMSDJg143yP5wdNrEPZZB975Cm
	s6juQqTtaVIdjyLiH+2WLmbZ8GesjI3Y=
X-Gm-Gg: ATEYQzz3l6ksWbvIwqYdn4fd18gwBC7SiCEj2xtt/9pAf2CH4a2bnoheaPksEvHIAlK
	MQsMYiPj7te5y23ft2OF2XCjaK0BtdwJB6SjlSJNqvRmcKtS06vn808y2F/QyAv001BAiJK3jmd
	WujA/bhnUA1+dYvpP+/NpVp0Xq/knRMq4b0x4lW3/37BCrcXGiyEDb47QJlgJnh4rPdqyZuwdPe
	FBQJQAw8wT6W8NWDNHaabmQjvUnZCqxBk1i1h02itBO/yK62XsJL8/G1hoyym3IUhxW2mV1E8yg
	j3FvGg==
X-Received: by 2002:a05:620a:1994:b0:8cd:92c5:b3e5 with SMTP id
 af79cd13be357-8cfad201c8bmr368868885a.20.1773826936433; Wed, 18 Mar 2026
 02:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 18 Mar 2026 17:42:05 +0800
X-Gm-Features: AaiRm53Aw8aU-YM9OaZMoRGs2P2JyUtqjO_yMbHk3xO5ci1DU7fGHktapY4taqo
Message-ID: <CAGsJ_4yuSML42N-=X8TZdXuFTCEc1mdiGp2Jd-n+3Fpj1+L8Pw@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/mglru: consolidate common code for retrieving
 evitable size
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD1164000C
X-Stat-Signature: t9iak3ddddy4fgb3o5e4b8hoy4xq6jmn
X-Rspam-User: 
X-HE-Tag: 1773826937-195900
X-HE-Meta: U2FsdGVkX18TenFNVZPSR2IOg1Jul2g/nf6SoxYi8gmt8bkJLPFnGirfHr5k5NzwKcJaHGjUMV6WFWki8df0GOaxPtZL7SEqpSIIV0i8A5VCzeJlC4yU5OHCYRvDZGItbrSA1kqK/j65f5mGGECU1jiuqw3q56/WLUHlLhDmwKv4XnG5UzFTpEz42oNTIrwjaJhGndijC1d2IyB1P1BPBoaUtqlKjD8mYUZzlTxf7ACiavpGR0yQzzxkWYL5Yk1W1olslkC0aDrOpxL9ZOSvLk/MWBETBAunHVjr9yBp+oeT+7dMUEStzOWTi25Z/jUXE+n+ibcSWgHyN4UGaJM0dXfU8XIMZxw7dUtef6HJpq4BN864Ffqz14233cUia1uVbh8BEcn1TrzOz/gJMmAf83IgH1Qt+C1Uh2nN1Xs3Voz6bxNgLi7jCYet6J09xkC3D+/1f8o0+dC938sHqcmXAvAhCAFsb6kkWlfVuYDFXivHKm09CePMuIoz8SumC3eTXpPpJXCvDkG7XEjEC8smX0WFKqKbqudtgkzmnR62GbPyFSzQr18CefeZwQw4eTWSVa4wdmYKwiCjVu6wbaxtXNQ7m8Tupj+UpW3as4VTW8Zc6BZb8qlaWC1CfNqBMk+xBzpqlCOngEMGha6Yf3zBDVxpXek+zhBg0CmVZfEUgsECYze9GbDEdjYJM8eaOTIQSrfnVkZrSC2kyxsbegbfDN0D6BQLfA/JYBju3bS5C+5OkKyCrkLafqyndJQfNeBTbbm1k1tMIyZQlvKJMxya44+PGrao8JdpmqeIaDdssVC3JwA7ZS66AKwtZ5xlHGWqTqiUD0x91+HrNwiaE5yaOfr/J2BtIROJ/t/dmIUiNDc7eWODqObKpycvfxjBMX818OlKkIPnXte0y/+gROqjqwshlzEOQeV1ktSUkafHOK6ICvHGfK0SEl+d+oe2BhmiCLKxgEE8cXW/dDPeQZZ
 GfPDD1n1
 2pKmpXdkkkdd+3jQt47z6slz0DZB5L5OHBjLAOVklV8mvBsgz4Vncnvff39qnPltDbYzP+f5Z3dOZSltX98HGKSIr0JjE1AXr9kueB8gfqNTThn63ifqIakv9Mc+6/Fyr+AZnSjNax69x6COj27GIMQJybwoGYPuPFMbZqj/zqAVK86b+qytUcN5PWebf1ef4M3H2U32sMKRgQE9eV5Rf+6hm8TtMtnQPGTVrU8jpdz99jez2/AbLCwGbcd6ASpT3qE6NEFyFPS4BiycAfICXo8hfrY5AZtLygwGvvKp4Lvf1Q/HIoYCUXBAj0ZibEkofqGTfyaKz8enKwjGD3lvYiCPq30udqPiG1MCEccRq7PoeGjabp7UySjGVw6wdWKf540L8LtdR1D7JF0FD4AR+Pqvn2IHmsGRJLvsEwsqshOG9voN2JZj817u0cwwkpOz601+zmDPeSHbPbaBfJOBjJd5lTw2Q7L6d6y6qoBNJJxZGjRQk7qhiDuUwrUCePcTzzxsRaA3a+u1vJec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 3:11=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Merge commonly used code for counting evictable folios in a lruvec.
>
> No behavior change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

[...]
>  static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c, int swappiness)
>  {
> -       bool success;
> +       bool need_aging;

Nice! Many times, I=E2=80=99ve been in the process of submitting a patch
to rename this `success`, as its current name is completely
unreadable and unclear in meaning.

Another `success`also needs some cleanup.
I mean this one:

static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
{
        bool success;
         ...
         success =3D try_to_shrink_lruvec(lruvec, sc);
}

yet:

static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control=
 *sc)
{
        ...
        /* whether this lruvec should be rotated */
        return nr_to_scan < 0;
}

I really can't see the connection between "should be rotated"
and "success".

>         unsigned long nr_to_scan;
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         DEFINE_MAX_SEQ(lruvec);
> @@ -4962,7 +4954,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, s=
truct scan_control *sc, int s
>         if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
>                 return -1;
>
> -       success =3D should_run_aging(lruvec, max_seq, swappiness, &nr_to_=
scan);
> +       need_aging =3D should_run_aging(lruvec, max_seq, swappiness, &nr_=
to_scan);
>
>         /* try to scrape all its memory if this memcg was deleted */
>         if (nr_to_scan && !mem_cgroup_online(memcg))
> @@ -4971,7 +4963,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, s=
truct scan_control *sc, int s
>         nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_sca=
n);
>
>         /* try to get away with not aging at the default priority */
> -       if (!success || sc->priority =3D=3D DEF_PRIORITY)
> +       if (!need_aging || sc->priority =3D=3D DEF_PRIORITY)
>                 return nr_to_scan >> sc->priority;
>
>         /* stop scanning this lruvec as it's low on cold folios */
>
Thanks
Barry

