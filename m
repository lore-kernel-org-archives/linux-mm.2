Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D6EEE0213
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 15:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E514A6B0088; Tue, 30 Dec 2025 10:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4F26B0089; Tue, 30 Dec 2025 10:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6D46B008A; Tue, 30 Dec 2025 10:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6B416B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:46:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3960CB6AC1
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:46:17 +0000 (UTC)
X-FDA: 84276563994.24.226A88B
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5CC1740004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:46:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ThdWDx2r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767109575; a=rsa-sha256;
	cv=none;
	b=eVxNi5Pivlzn3aVjtCkStlTdloIsRxfY67Ktjvln5crP0zezJSaKVfD/F0vvCC3Tr3iKo/
	biqwlc8xHCcb3YS2AFc6kzDOyKp9wT9un4ETPZH3eM9NNQ8jUBgm0e6ZzDoNwY7KkmBW0/
	AlSm59SOoZDzdvhw27fzjjeRTrJm46k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ThdWDx2r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767109575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqxBDt7Dexa/f91SnFZHCCAKsItAhEd6c3MAV08hdGc=;
	b=z/UZxQ3AJul9mfjKcwphlCK1tpaDS8QMnyeht3sCXoHzSPg7IRHRu+VhkdxfLpKKLEXq68
	avH3X3IAC6LS7k8oSrgJUclOOyFHu1zQ7mWvvuLJRrGaziYSiFPE2VvIATa+GjDBhKMeFM
	vCbuq2nWeL1QuaCknQyq5xSy8gUfuRE=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37e6dd536b0so95693151fa.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767109573; x=1767714373; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqxBDt7Dexa/f91SnFZHCCAKsItAhEd6c3MAV08hdGc=;
        b=ThdWDx2r5CtBJIx3hThyIg3ERlwHgbu/51qaOLwwt4Xq9HYHhxrs9DTHU8F16C/Sch
         fVGpG7BoXlZGeB86ZkgPA7okfkjT8ARFMj1Er8dxoQ7SB9tbxVz/3pyerXYxISrD2sm3
         ekVM8zjchsXFGpUFW7E5NyELyx9lT84g61mXY4Eko7D9q/Zy21gSbcyRcmNseOPMFWGH
         L6oR4rWwSmtDMeQbmOLRMxyjgyKBYWurP4zSkOUO6b3sreJgEmW1cUkzkIwtjEAXRvZl
         5vCx1+lo8G3ZfQJCcfj0TkfypO291Jraw9xrceQpFwozpQAXwUPbOAIqgfYLIcXSHgK0
         mxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767109573; x=1767714373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iqxBDt7Dexa/f91SnFZHCCAKsItAhEd6c3MAV08hdGc=;
        b=m+IYJDNUBFQfT5hK9SC6JMhI0NzTRVLeoninFlZUWufGvNxjk+OS0Yp+vSOQCMzXS9
         T/G1KXK8H88DtQtTiFMFdyQtfaCKysntCqPgzgjGIs0Y+SNAXbfEd0GiXe3we9Qw02im
         oR4oCxuiO1wClhD+9KY/oYQKVcCNLI882iedhI/WXI8tQ5gcDvmV538SC0yB/QtuSO5l
         G3H1CSSNivXj/B1XEYCIqEPgpKwfztvRpYEPj3QD8f4E7+TT3/PO8uK+DtmEj+y1SFI1
         ASkjcR6Hg4OKDznNN9HfDs/KfeMUhV1PYzht0ZzqIJbQHnawdV46Rjgok6senDpZDQqH
         ZxVg==
X-Forwarded-Encrypted: i=1; AJvYcCW7+9mS0RQFGzjxNdvqUPFOgdxy91PuawVZsnoLPsXUP9ErtGl47I/skN+3f0+5GsV5HX+tCYNJyQ==@kvack.org
X-Gm-Message-State: AOJu0YxQtKukyUgehfUQlcHO9Rgi2sOUYSAYmAtVtTtG8Btgboqo87l7
	57eQb3lTVnXySNQidRHLCVFfBl8ipawQihlWR7i3neEeuHkFAUKzQzoo6HMLIuvLql8OG2Enj3f
	amaMUPKAQMSe62S6y62woTM6Yc1jt9Us=
X-Gm-Gg: AY/fxX5SppQa17eO3+WcD8NKnJz8qfuCXgdQ1wpgETAFR7AWFFaRQF+vc1pZCyPYeNH
	31KISyuPmn0A8nla9iuqqRSWgOmYmq2R1NehdqQKacDlFlyuPM1dr/NORuzTbjCXyl6/IZ8J96h
	Ok7YaJxF3+rv3xqtc/YHI6i7FD7uO20dnmQ4g4bs/X17qQOpnNClksnWVbojJhgB1NwOtjQqz7e
	6yxSmAZDFgj5eKtEp2b8J24qODq7BPuPJCMBHsL/Zu53xE5LqpzKwt6Ts0qhIwy0QMzNSkj
X-Google-Smtp-Source: AGHT+IFgVUApWZ4qJja73xsLVm2gogtp5JMU4fCD+DmRwA4foXvvhwNH0l2LJAcAWcUT8aRUI978yAeOpwbGgro3O2I=
X-Received: by 2002:a05:651c:549:b0:380:989:f602 with SMTP id
 38308e7fff4ca-38121568d0amr92136991fa.5.1767109573084; Tue, 30 Dec 2025
 07:46:13 -0800 (PST)
MIME-Version: 1.0
References: <20251229055151.54887-1-yanglincheng@kylinos.cn> <20251229055151.54887-3-yanglincheng@kylinos.cn>
In-Reply-To: <20251229055151.54887-3-yanglincheng@kylinos.cn>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Tue, 30 Dec 2025 23:46:01 +0800
X-Gm-Features: AQt7F2qXvpcFGhtSN-W7I-RJuxKdBeELxuoJ8E40niLIFlDs0rXVTSCaCaVHJWM
Message-ID: <CACZaFFMb_HY3-FwbFZQ6QvSSN72FYggeP-DOyCX4QU4gAFPBmg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: khugepaged: just skip when the memory has been collapsed
To: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5CC1740004
X-Rspamd-Server: rspam03
X-Stat-Signature: 6qtwzjpw8ddptncrtb4ecm413j3pd4uk
X-Rspam-User: 
X-HE-Tag: 1767109575-867353
X-HE-Meta: U2FsdGVkX1+NfaAgY2m/Y8RQkn/Yg5/1NQjevjV2bnp6An1f61/iM/CiK1ZSxLwFdNgd2KUP/Pssq2HovvpJDgSPoU4I4H9pdfFuCUvJujRXWq20WiBPmTJC1xo465DKvAINnrkzubqMJjMCQO3hOABw5WT1hx40RqjT4XryRBmqtbg6ooiPMh3qpp4wQZbqlju7ibQwDUO1OVMKvaPDPtikcelu/6KoN+QWXQynmu4IJ9QJiA+ETOV+leFw/Am73uFzG7+rci4O+DD9zZhw3z/BDO7eEqzkql3wvQxP0kXjDC7kI2M1YAcBPTyOLoyt3geq9gfE/5zo9Q0HYkoQVcpveTIDQNV52HAHUPITlWrL7qpUxmJrjcVJprpBDA/jYHxuVrWfg7kXG52j5Ix76x7JfJO3wC1x9B77Uwurmfs1/MV/2jHTZomTgYWflRR6X1M5dwjhFtU+NKeCOQRsWirwuWCHfeM03OTU9/XLviIEgAu54CDimVZ+OvjJtyT+IvEEY6HAGltEbdd+r94qicc4/ORkGasg9NsqAnm4jYjqbybTOG8054kGzEV3ZBMdxwNjEtNuFvXjdaGsd2FlR9JWaWJfXK5Mm1GRREC038t6ZZ+rspqXlPmp5AQCmiJQ5YaTY+F3dKKXtvCBPm04nz6JWpYiIlCB2Pc3Tb9jUb9+d5U+dS3nHRx2cxyIKTsAHTadTn9CcgvnxmIvLB4bOQeHSafRnzDtPQfL4rVE67Fj07nEPKzRJofsBiVLrxbx6kgSDt9aCA9ugafQ34pTL6jAZ46edKUM+/sQKtOGTMX/97/sMjmCCfNEZ+510rvSboFKSzWJGSb86P2c6SFziNVIWQ00CF4ulRGxPl4DyXhKCx455ghmK7dFx8ziY+WfZgfC7wIDLt+CoIOOELK3R8zd7cJue4aCBkldbLoxXJhDDJQY/0TaCDsgtJgU4Tgk7s4AwF6cavaf14IL0G7
 ZEKAb+pA
 vwWDkI3omLMUTSIyAxU6R+HP/PJSTBvaGmksKY9+URCB3CLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 1:52=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> The following data is traced by bpftrace on a desktop system. After
> the system has been left idle for 10 minutes upon booting, a lot of
> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> by khugepaged.
>
> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
> total progress size: 674 MB
> Total time         : 419 seconds ## include khugepaged_scan_sleep_millise=
cs
>
> The khugepaged_scan list save all task that support collapse into hugepag=
e,
> as long as the task is not destroyed, khugepaged will not remove it from
> the khugepaged_scan list. This exist a phenomenon where task has already
> collapsed all memory regions into hugepage, but khugepaged continues to
> scan it, which wastes CPU time and invalid, and due to
> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> scanning a large number of invalid task, so scanning really valid task
> is later.
>
> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> SCAN_NO_PTE_TABLE, just skip it, as follow:
>
> @scan_pmd_status[6]: 2
> @scan_pmd_status[3]: 147
> @scan_pmd_status[2]: 173
> total progress size: 45 MB
> Total time         : 20 seconds
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  mm/khugepaged.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9f99f61689f8..2b3685b195f5 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -66,7 +66,10 @@ enum scan_result {
>  static struct task_struct *khugepaged_thread __read_mostly;
>  static DEFINE_MUTEX(khugepaged_mutex);
>
> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> +/*
> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> + * every 10 second.
> + */
>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>  static unsigned int khugepaged_pages_collapsed;
>  static unsigned int khugepaged_full_scans;
> @@ -2487,12 +2490,22 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
>                                         khugepaged_scan.address, &mmap_lo=
cked, cc);
>                         }
>
> -                       if (*result =3D=3D SCAN_SUCCEED)
> -                               ++khugepaged_pages_collapsed;
> -
>                         /* move to next address */
>                         khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> -                       progress +=3D HPAGE_PMD_NR;
> +
> +                       switch (*result) {
> +                       case SCAN_NO_PTE_TABLE:
> +                       case SCAN_PMD_MAPPED:
> +                       case SCAN_PTE_MAPPED_HUGEPAGE:
> +                               progress++;
> +                               break;
> +                       case SCAN_SUCCEED:
> +                               ++khugepaged_pages_collapsed;
> +                               fallthrough;
> +                       default:
> +                               progress +=3D HPAGE_PMD_NR;
> +                       }
> +
>                         if (!mmap_locked)
>                                 /*
>                                  * We released mmap_lock so break loop.  =
Note
> --
> 2.51.0
>

Sorry, this coding has warnings at SCAN_PTE_MAPPED_HUGEPAGE, and the code
will be refactored in the next version. But the core idea is unchanged.

