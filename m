Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D88CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97FE6B0088; Mon, 12 Oct 2026 06:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20F76B0098; Mon, 12 Oct 2026 06:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11C96B009B; Mon, 12 Oct 2026 06:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8696E6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:24:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05BFA1A0B13
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:24:29 +0000 (UTC)
X-FDA: 85313589858.04.812D144
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 23797C0007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:24:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RZqv1ZEV;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791800667;
	b=KmPtGuYulb6/p5mVN1tXRsn6Iaf7zKZ4Wj5DNyq2XjOpVqsRjliHSib/2qKpqYf8zeSYTh
	6HDyKrGOsZTW7Xk+muKxkE8qsxsMJyFE6+bybb1tl3c6kFTcgD+o1D5cfBOw2rOiFLBZ3Q
	Pr91h+vmBTPCvzT2lkUyuv9BKSPQ4yM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RZqv1ZEV;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791800667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4r6VZ3b4FSsOVOlj0ppWkL6kQLQSiLIlN5z+tYgn5io=;
	b=UYu/8wnNg0eQ05Adz5m0nBvVy+0CBt1NQAVHMzR5YRA7Mr4DNScl2iNtmyg294wnGjoFXH
	fBUlLiLljHEZ8o28bH3i5mc4eFFKVNUjqTDqYEMnrJR0jJ4umfX1IIPrqvmvcT57z4HAWY
	NQfixaMrvUWraOdu56OBRWaNcK+uFOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80261600C8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383631F0089C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800666;
	bh=4r6VZ3b4FSsOVOlj0ppWkL6kQLQSiLIlN5z+tYgn5io=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RZqv1ZEVb2QX0FREo0iFH8nF2wAAQeOQotH5UxHzcbI+LHZBwLJf+e2d9W7HzbbdB
	 mBPciGE3aIPJYeQbLozQxHqInJl/rds6vFasN8l2i/mNf0DOIt0W6YFEZrcMSnSSyD
	 jzarYnKRAUTrqNmzODMlwNiEsq6Jc2Tv9K/Q8ClzY6LeT1FoShbM8soZGVJgLctMkH
	 zwhrS6SXSxgOK7diB1irlHW9wvwheQvbyIzq6WUsZyOfP6eMWgbhLe4BOD+HuFZfBy
	 ogZpi6YA3j7rwq6hnVqk3ER8++gWaQccNuVR1W5LBqm7jgVQRrXh4mE8m4Tl4v0Ucm
	 rPsEdeszZkQvw==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-919abb3335fso23201746d6.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:24:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwRPXuRljXB7duTAoO3/bZyFrTFBvuOxFxW7ApQy3Z5JlkuGDY/YUzzia00Tlgjky9J/djB6WgmwQ==@kvack.org
X-Gm-Message-State: AFq9FYICLXvqCaif0OLXEr9DwYVj6y5DnWrr2kQDA7/eNwxQq3XLPs2G
	btfLT4jwy5uZfE5EF7oHNWpCCiBD+AM4m9YY4edh/j7YHCjoksDFUXtHs3LQCqUWvzAbx/jcdSU
	7HEozr9tLww9A5W9EXzctVhlY/FRSuas=
X-Received: by 2002:a05:620a:372b:b0:93a:13aa:1b9 with SMTP id
 af79cd13be357-93ebd21e6damr1470423485a.30.1791800665600; Mon, 12 Oct 2026
 03:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <20261010141057.599595-1-liuxiang.277@bytedance.com>
 <CAGsJ_4xxawPzb7MpmdNm9u-fgge3w49n-Cu026BpKYAUZZf=pA@mail.gmail.com> <20261012082545.2926113-1-liuxiang.277@bytedance.com>
In-Reply-To: <20261012082545.2926113-1-liuxiang.277@bytedance.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 12 Oct 2026 18:24:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zesVPzt7YeHLhVDfQ5THwcyTVZJaHNybw6APQ1BS86pQ@mail.gmail.com>
X-Gm-Features: AclHuK_ns7gZJU9FbF8TPhoIZ1hQJVBLC0lvK8ekIaJ5Q1cCPiKWDvK2CYGo1Jw
Message-ID: <CAGsJ_4zesVPzt7YeHLhVDfQ5THwcyTVZJaHNybw6APQ1BS86pQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with low
 swapcache in MGLRU
To: Xiang Liu <liuxiang.277@bytedance.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, mhocko@kernel.org, 
	hannes@cmpxchg.org, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bd5tofy458ko5gpn4a9owyg3p9pgx75p
X-Rspamd-Queue-Id: 23797C0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791800666-442897
X-HE-Meta: U2FsdGVkX19Winw/LLbC0vM0Orkw1Ngy7l36NHVocgICARPIGbTxf3dCBmGgRjfa0Ht2Req7K+lgRi4H8AYVbtZOhpKghzOgBSJRFOcpygLjfFL/iEzHrSy06EEEdVUVdZnRFOfOVvUD0kIN/yMiOLOfm0IROKl2Kn1L9T2+mWPLr/cjcAHanuoaRRSK/QyYdEeBs2FF5Od/okLbb60qiJlIRG4UHXD7jAFhvPSZSvA09nzO8uksS3+RZu0vruuvbSIP2gScnjUiWo5RTJTi+1abnlZ2eeC7q3eu2QesP81IL+5jAblWDlxlH1bxPNsA8IZcdXAf8M64hlIZvNYHaoeG/W9ZjyO0HO8MmZ6Ojxv2Xt3mVtuUwfLZtOx1dmGyorKr93JFmEsW0p8Sa6v/qdW+Ei3wc78IQAu6HMsOpojOG1llULJZ1elMxq0y2TRcsLwZivPlt2Ps4DUznglIR9R5CV5BX8EyxYaKMdOaVXug9j9F1R6B4OFMH0z8PxyqAN1V44/KDbaht1h3Yw2FtC9/68E1rgfYgCz2BlTe1ebLWoj/4AdbNBgsl+bWrxZf9Rrqg5nn7blofTrSfZjJMP2VqmI1LWSnA+/ninxe0iBGUp30TfdOsUZ5ADFywzQHJLEmJON2i8Z8t0HR9kZdi8KHjvgk4U2lksiODIzF21/vRkQVXW6KQIRWmXIg1fHDPfw6FE0VfM6A3EtOHhPSZp7938Tf6Kbv0hiKC6PUd0IGleSUtjYWL1+riKYgi1S6+6g74RPTtEUxyDDYcJwpcl5YNEZENXN9XbS6x0MMFhxTgsbJ9PEqRPR5zsLW68EsMvBLcTz/vbdt3o4GBHenjJxY6no+/8v+g7Hn9hqucVglt+cty6j+234Yw++VDjItrvAby0+JNHDoGrseqsaY9hdP9c/vAApf4eqzVN12ItuO8OjkxnJvfrsMDnrcNy5WZDJrhorUTbBoIevgeT2
 YJB5MqkF
 IALX/X30WTZk+5oobwdNJGDbm5+L4UPXXmJagES3Y72MWhbn2R9pU2wUppiAvLjS3m+vxTYVH+adsRTio4qGgSbKuT0ICvsSwO07sI7zgbhkJpaTQ7zviEaMidSmfaZ1ijrqat1QAC1CUh8m1pR9vGEvSLUlIV/Z+LdPYjDG6Sc9Jfuxv+TVDoCfdZqcee9Ko3HNazjBzAyX8KIaB6alrSbucGT23trmiU5lgHCAsoX6/+PHJ+42SStB9yqkqu2gml0kESWCbsIegfbTIE960oppI3dBiJJUuZqEHzTlyUiOKQkrW9iEN3fFwIewCUZIj/AY4HyQ/CrY8XENpS5ygTbxbGM8Fkcax2lUZTqlH0S79mIMO8rGs7A5CJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 4:26=E2=80=AFPM Xiang Liu <liuxiang.277@bytedance.c=
om> wrote:
>
> Hi Barry,
>
> Thanks for reviewing.
>
> > I'm not a fan of this fix, as setting
> > scan_swappiness =3D MIN_SWAPPINESS will force a cold/hot
> > inversion for anonymous folios.
>
> The patch description outlines the tradeoff:
>
> > The tradeoff is synchronous aging. With four anon generations and two
> > file generations, advancing max_seq can require moving the oldest anon
> > folios to the next generation. This patch accepts that cost to avoid
> > low-yield anonymous scanning. It keeps the original swappiness in
> > try_to_inc_max_seq(), avoiding additional use of the inc_min_seq()
> > single-type shortcut that advances min_seq without processing the
> > oldest folios and can cause cold/hot inversions.
>
> To evaluate this tradeoff, we varied the oldest anon population and
> compared synchronous aging with baseline evict_folios() time under
> GFP_NOIO with very little swapcache. In the cases reported in the patch,
> aging was substantially cheaper than low-yield anon eviction, and
> allocation and reclaim times decreased. This motivated retaining the
> synchronous cost while avoiding additional use of the existing
> cold/hot-inversion shortcut.
>
> The diff uses scan_swappiness to decide whether aging is needed, and
> passes the original swappiness to try_to_inc_max_seq():
>
>     if (should_run_aging(lruvec, max_seq, sc, scan_swappiness)) {
>         if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
>             need_rotate =3D true;
>         should_age =3D true;
>     }
>
> inc_min_seq() receives the original swappiness through inc_max_seq().
> With a nonzero original value, the anon shortcut is bypassed. When anon
> has four generations, its oldest folios are processed before max_seq
> advances, retaining the synchronous cost described above.
>
> Am I missing another path where this change would trigger the shortcut?

Interesting. I missed that eviction uses the modified swappiness
while aging still uses the original swappiness. IMHO, this seems
to work, but we need a big comment here to explain the rationale.

Also, it feels really strange that we have to hack two places:
one in `lruvec_is_sizable()` and the other in
`try_to_shrink_lruvec()`.

so we could make it a helper? BTW, we have already handled
return 0 in

static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
                           struct mem_cgroup *memcg, int swappiness)
{
        unsigned long nr_to_scan, evictable;
        struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);

        /*
         * Proactive reclaim initiated by userspace for anonymous memory on=
ly.
         * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, =
so
         * warn if it shows up elsewhere. When anon cannot be reclaimed (e.=
g.
         * no swap), return 0 to skip the scan entirely, avoiding useless s=
can
         * work when there is nothing eligible to reclaim.
         */
        if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
                WARN_ON_ONCE(!sc->proactive);
                if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
                        return 0;
        }
        ...
}

do we really need to handle it again in lruvec_is_sizable()?

Kairui has a patch which hasn't been sent out yet:

mm/mglru: reclaim from the oldest populated gen

https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/commit/?id=
=3Db15a053bc

which would allow shrinking MIN_NR_GENS generations and better support
the GFP_NOIO case.

For now, let's clean up the code, add comments, and introduce a helper
for your approach so that we can see if it can be made easier to follow
by a RFC v2.

Best Regards
Barry

