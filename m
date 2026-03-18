Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC5210854DF
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200796B0159; Wed, 18 Mar 2026 05:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1956B015A; Wed, 18 Mar 2026 05:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0FD6B015B; Wed, 18 Mar 2026 05:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB3ED6B0159
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:58:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9274413B4CF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:58:33 +0000 (UTC)
X-FDA: 84558734106.19.27AC9CA
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99481100011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:58:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mTdHhlTE;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773827911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrjo8McIGZyj4bCDZ8n00Q2/eY67u/iVg5iPEs0rOIk=;
	b=agWJVgZdQD/0xNkIa6vig5EazPcCA6dotTob0UymJd85fgIol9C4NAHVuGYpPpzoyi+dCP
	uvhbg9FqfNCP31J2sSOGZKg+JW//yXKDvZVtHhQ1UOfGom5fIAailivww7ZM1XIOIrS4Jd
	FNq+3mGQjc3BeRPeDw/PEoMOYvICyDo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773827911; a=rsa-sha256;
	cv=pass;
	b=yTHSLak7YsbC/cGXSbffJQDCcz5rBztWd69MtrO2iODLL+fIxYWn924sqph7y0Oh/b8EjE
	hcDwdGMNGQ0vYAD1DV1QNHxzD416mDb2ZbXCWAb6GIvTrqk3KKSVveHY9TM1weUK11jkiL
	nf+p6OxlF+KJYGxNNYrls/8HMfEbiQ4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mTdHhlTE;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6611e4aefdcso1041735a12.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:58:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773827910; cv=none;
        d=google.com; s=arc-20240605;
        b=Ck4r7sVvR0pWX5vsBGSPn1il/T3boMH6xZrvwNls+HD/kzJUFgUW/9h8uffVcWbjZh
         JQ+qLigvRDfloOjGsU6kPEmeF96GBV5j/Y2drCPnLAcLB5wdt+cFdmHVdpVtjVuGw4E5
         UuFQpA/yGeFJRWRnXW5/EQya3ZiAISKPBheeAE52jgizfATNY4xqeGExPJjnvDnDT47A
         kpS9NBafAdfVgdjAT2dYYNRgSOucM8RwhQ9QhTdR5WmGdL/IljP1hAzDCPqQbSEWdC78
         ny/OoZjo0URaeeZGxIsaG/QzSrJW6ZRj9kyj8/mnOa9HE6D8lvjRpCRphcvIOlo0TbJR
         OoTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lrjo8McIGZyj4bCDZ8n00Q2/eY67u/iVg5iPEs0rOIk=;
        fh=siEEN7CyKjbCfWhykzEkbRlhaV6FBzBeg3GMLrxr73I=;
        b=UtvIaM2hDRhanLty2+mpchys6WiqWenUc8XWBN6Y8CKQZGT2WD6UHCwV/Mc2066GFl
         Z8DAtBhVXhqD5hXZa29Ewk4NvcCyUYM+lQ+I2bQbPdkT2KLdaLVrbP0GI6veKuHoATjE
         yLxuLAucoQMeL6D/fH9pX1AwGq8jXCM9NowKTQg739aeB1NIGcAfIffh0esw12tPjKgJ
         8I3hoBQ6i4CTAblXLX0ZGDrWN+fZ5BehgBteeKWKuJ1jMDjzWIctwIF1RxE9+fBdbzXf
         ugS+x43kj7bQCL37F+UgbGNSxlvkyDQSnQz2tD9S49Q5khcZ4zQPjH5eDKHEmFuQIicX
         nKJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773827910; x=1774432710; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrjo8McIGZyj4bCDZ8n00Q2/eY67u/iVg5iPEs0rOIk=;
        b=mTdHhlTEIqrFlkZVYj1V/As2Qn6Dqym78PY+WYZTxxMN8Gzh5HyuhMxS8HGlvce2D3
         sPMw8ESflmX+/VrCSpJ67qIxUhH9mwNfjqQFLOCAakbxWop2QSAAzEJqjzUwmmUb3nXK
         jCY2pVPFXsgJP4xojoLL56sB/hEVfDyzl6kT98S5MN4rQoLxsIKrqH5kAZIjBBys8ibi
         8URX/5ruJBOb4kOJ0bX8XDXWO+QAsMQsQeWhUn8u149tAATIFHfQmpkw8qj2Xco2GPYD
         +ouUOqLpQUFN7Il+5Hjs5vgJdI3N7yTawxWAAsIkj99p7bl4Eo5Mkq5Xco7eQXg5Bvn1
         ft7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773827910; x=1774432710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrjo8McIGZyj4bCDZ8n00Q2/eY67u/iVg5iPEs0rOIk=;
        b=GsCf/tzss4A3qx1Kew442vN2pGaxTSc/o/nuIlTji02OwK4/G5kTaDj2JaADZ1FS0z
         UjbESKG/lP0DpZuVEK8Q+nYKzV9jp3SaHYD0DYralh2Qos5zbXjEPdzJ8wwz0rW6gRhy
         2JPST/QIGHsKZUmZN2tz/Bz81xjcJU1ngFOevxgQAJOIFHd0A3Cb1jV0YKBvVhnncH9e
         yOktcjBoXFfw+VZTZd5YFGvMaBENzHT7f2VdY+CxsjDeE87EFHzs+iOugdOI1B2cmKvM
         q+7akubSsDKH6zgeMIrXgudi42Byq0w0sV6kgHlmoMN9rMIgEkFj20u0m6zgK6PE+sTX
         Kulw==
X-Gm-Message-State: AOJu0YwLhUCap2N2rY9lspp/8LvofmhBSZpRn4+oQOQ7M4bKJdw725c5
	LyrR/veFqSZxxJbuB3RqfuYZwmLmyVaydAAfYB0LU1rgH8f2r00fSOAwxQeZq/nXggTZ7c/kmDp
	5sWBwXtGCxuHjjdtY5KsxLWdCFMBGl+g=
X-Gm-Gg: ATEYQzyUtwgoPPM96iC164cBd9ZeyPwhgzyiiBTkt1wb5xPZ+Mqar9LxShH5tLnkGzp
	2srTOnO+2OIRUe4CgzR3VXxiAq93I2bdDfhqqNCt9wiTaSqiqf9hzwx1o0jLIh58LuS+VMxFlNq
	edyB9eB0rq9xJ4DTWCxqc/60LBD6uUcgWPRZbP2DGyQQjuGRuXnSpZUd+5txhb/uysTJekiW0GT
	3CjblR7xY/ZbKLWYtaCdNsvXidfdMo6LMBsEnoPGBUnEB7EyBlTXvcvLWxVJ3Ix8E98NsxnU0VX
	CEylu5vVilaJ0kClkh2TdRQBv0PGOYfz0yYCWmQ=
X-Received: by 2002:a05:6402:2343:b0:662:e097:6a0d with SMTP id
 4fb4d7f45d1cf-667b2ff79d4mr1849346a12.14.1773827909698; Wed, 18 Mar 2026
 02:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com> <CAGsJ_4yuSML42N-=X8TZdXuFTCEc1mdiGp2Jd-n+3Fpj1+L8Pw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yuSML42N-=X8TZdXuFTCEc1mdiGp2Jd-n+3Fpj1+L8Pw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 18 Mar 2026 17:57:52 +0800
X-Gm-Features: AaiRm53Yo35Z4y-fzw-bOdO33f0BhYRpe-mijZ99eU5zsIxVZElEKzjArVf6png
Message-ID: <CAMgjq7CpxLrq+LSV_KgOTSLrk_XTg2Nb-Nwc15WjE-pxb_5QoA@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/mglru: consolidate common code for retrieving
 evitable size
To: Barry Song <21cnbao@gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: yoa5mzhwca5xchaqjjjmy75je7k145i4
X-Rspamd-Queue-Id: 99481100011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773827911-964745
X-HE-Meta: U2FsdGVkX188nCVqDKFDx6yjt2BdYVPKSiRuWQggOnw8M1LdNdANeuy98wBEJSmiEc8VAxpPMTLJpZnTr6nQxnyt9zH3siwl5LgSTRpkvxHMNR+FXDVZNNvaEnYaErh/KsCtac/3MOcR0BDhKxRzQLm4NvTFF1KZVCx4cHdV6LTUexxVwF6cddYm1bFdthuFGANA0IIWxGNPaPiw/LcWbZG3n4pyTSs6Rz3RfxTG6fQ2eAiI0uo1hOYb7Plnx/HVE6UvfRIJNQUh/l9Z6oO7wxJU/fPkIgvJbyM3omAGf1flaJjkGIr+CbSUbD7c0RV8hFSsp/x5htp5CmHxZ/QpUB+aGy/VYhvtpckFDIJQbEPIVq8xC86z9XfAq/LaEBUoB8mUMQvM9F3vuZUA/Bw19actcND1buBR/2wPm8SljVB8UXCImGuU+DVA2baE10AQgx7hrj6rqiG0rjwYOg4RUy+JCT+Wbpk7IA2ocNSwoHyUkmJbWTM9AJHQejnostkAH1tWFjYnHa294aqj7tdPKCdSa7+LmF44POUUI8uD36kMBKYkcIK+8kJu8ICgiJHvOP2pHn31o3Qg0kmTtACN9eRJeJoFJ0vCwRXzCbiU+jCJ0RqaWJkfraW/INlKfUNDNVPgh8tzxe8noRf/f+347zYqkIT6Z40lFowJo2XjYqv24nW+jYcWB0tvDYal8u/Ueo7clvVPlcyQKXcyD4DM2SoBw3KVNXLCKoFgxI/IhQ1jHHsoyOHs90PU4rzWY7V7eLJmhQjntqMqFikr4umnKo54igK/unABrmr5sqyV0zBJ5Ez++7/DQoijN7mlw6Ye22b0/ckQ49nM6Y/J0f7A2osiDJlwfqaWA7tEBPzFY5nMFuwL/TsG98SbwJ0C6oX58LdESJEZVvNHdVx9x55gE8dN4aTp7BsvnO+gcCqWN7AnYoZ2DZ25mat1bRbM6qxzClRPKL/vsu+oXYk45vM
 /SYQI1W5
 fbpjrpqs89Al7Mnd/zAxXuS/Q60wd6EmylGysqoBjri8oxb6WtrRdrtbMIgsE5Psjhm8RGG162TNc4lvtX7BA+U+9FGO/WDymOQ23Ki4rRl7cjlgIzGOa3kX7Pzkhje/loBUlOOkq0g9vGW675s2Xat61XEpqaqpGyFrpoL3TjA6QKoMW6uLYqG+yMhUfV/eellgaAId1uAGejOL5zpe1DNSrwmA+jqaBQK7TAnFlTNoFnECI3PmtVNAFRQV6kwWxMnwIry1Jfuv5KXkh4nsG2k+6x847oOQ6C2rOlL6lDy3ZvgoUcJB0RK5j5TQvO/i3ka6SL04pE3zGYTJZYSv05AITqkBmAMHxUh/eL/MbLFmeOVV2R5NrrWzR2HgkReW41EH+RqJkhr36Lxwanz6mhimVaZQQrFBpa6xkrXirsc+diAnI2C7Bzxi6qeZYAxrlZU+I9XoYHYyEhKLYJevWubYwOHj0x04mthLGVkH99uy2WV6jnKr2ENnAK2Bt0SziIpOuB7wukOuofz5yL56UblGGQM98SwSk48PC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 5:47=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Wed, Mar 18, 2026 at 3:11=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Merge commonly used code for counting evictable folios in a lruvec.
> >
> > No behavior change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Reviewed-by: Barry Song <baohua@kernel.org>
>

Hi Barry,

Thanks for the review.

> [...]
> >  static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control =
*sc, int swappiness)
> >  {
> > -       bool success;
> > +       bool need_aging;
>
> Nice! Many times, I=E2=80=99ve been in the process of submitting a patch
> to rename this `success`, as its current name is completely
> unreadable and unclear in meaning.
>
> Another `success`also needs some cleanup.
> I mean this one:

Good suggestion. Perhaps I better split it into a standalone patch
with your suggested-by, will include such a patch in V2.

