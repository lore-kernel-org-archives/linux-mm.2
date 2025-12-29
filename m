Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D4DE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 08:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13E46B0088; Mon, 29 Dec 2025 03:20:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1F26B0089; Mon, 29 Dec 2025 03:20:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3446B008A; Mon, 29 Dec 2025 03:20:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B37A6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:20:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A567BE47C
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:20:28 +0000 (UTC)
X-FDA: 84271811736.22.6C70B95
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5143E100004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:20:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KYqTMg1b;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766996426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exNPnYl0KPHTRNf+6UNJI7KmXNg+ybbckXnSTdyzhMk=;
	b=XDN2qkTvVp9oX3NwYsSB2Zf2Vok2EzMTfkD4pdG3wd6ccyzWif01/E2Ww5MoEgKIgHgoS/
	TX0/mWpqWJlYQM3MUtJ7tJaxioquqQvQZTmdYdE/IwyQUB+9KMjGypMOR09l4QxjseLuAc
	KTCnkKXdrthVcQX4oTPVpJ9cGVa5Uxo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KYqTMg1b;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766996426; a=rsa-sha256;
	cv=none;
	b=2onJTrxRCS3QVNDfRv78IjuU4BA3+Mo2OYdv+BJNRr4LZQFWILgnaVC5cVFb7/KvtzvvpQ
	lhGsSh2dU29ZG84ZA+2qFAM35Xp6Pz4gCvXYIZpsFUUb3w9BNsOGRZVnkKdLNUegWbI5+C
	2/TYzALEdqSZg0OQv089SYtO3GW+qYo=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8bb6a27d390so569755085a.3
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766996425; x=1767601225; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exNPnYl0KPHTRNf+6UNJI7KmXNg+ybbckXnSTdyzhMk=;
        b=KYqTMg1b9iWglvPtpGbVhMQlaiKvuYjmH4BGOIT2Rzdkl0Cyqyfp2b7AvINkuItvbv
         02ej2p25ovxtbbhWYi1GMuK0zu9X7Dl9nYb+Sz7sPe4qKJaaJ06cu9l2x6gIpRSW1CzC
         CyC66GyIYAAR9prpnLsvPDrWcFAKeqJGNUx93yJVS81Ku1cxbINTpJPsanQBYeFgAEOA
         hhOtn5cAhQEgQsZ56w0WhWrHsqzvNLd1V0sXxwm70UjSeJIPKgZpshCfwMuz/+AAuqGc
         aDu/SEB3oME0hRTdAYUbjPh2jB3PZKGETIzw/N162MN64EmFTGw4ZzFnUsm+08o2N1bv
         plug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766996425; x=1767601225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=exNPnYl0KPHTRNf+6UNJI7KmXNg+ybbckXnSTdyzhMk=;
        b=LaLmxnIX5GtkBkTOm/C0KOsslLTWmvfiZPTTuyIosSu/sxFnOMkzDp7k7JSEnCm09/
         hCbAkhL9ywvYpSwA4z3gKRwHb/uUllN1tEbEjdlbxJyh2YMPUtj8c4hIPt/i6r/gYCPx
         4DvCtAO5I10ZiH2x/rg2RPHQ6/Xm1BSKfJ1uSHtC5OIpq/TRuflMawxE8ZNspZFjldEj
         0a5mk5P1Vc5KooTQKvh3aDklAzmD+77b3E4MHPL6dWfgzUrbJzQ00fn5L9NG7bS2+I8c
         2XRivYEHn4RljSVHX43LTViZkjwfCaOBC0OMRnDDhhWYkSivfEb4aqIXf3sIFu0MSw12
         cMEA==
X-Forwarded-Encrypted: i=1; AJvYcCWtTEDvK7ZpIcpC9KzdQOycnnnbLiq2cCQ7kZFxPPS0ctte2kb/E9yCXGzhC/O5wXZnsqAkvVV2ZA==@kvack.org
X-Gm-Message-State: AOJu0YwolOodDtwrk2qFdk0f8fu3gxTfzSbxMwhZLEvttuVrOciS+0q7
	qBC2dZM3rqKsxRJ/Ha67cvZsNv/RWzqm65pp9j07tPUMkaWv9C1haZ8jZB7uVsh7sUeTvlQHiTE
	HlMCBz3SrMZCKqzqioU6JrTmVrhmTS+c=
X-Gm-Gg: AY/fxX7zUZ3lPT2QZepO7yEHo2EjgOFShP9TRDulyC2fzn9X+pFrnFF+OTp5tqNwJgh
	g2XO/U/AcGWoU1ffW90KTvAa3zyzzeJ+OH6jbJOrgMfftoRaIAj1dpx1EUxqsNtSqOYkk+FTbLb
	inRLDRV3KfrWJjuwqR+M8vvdIXrGX+hSqKbkfcpGigdT9/YDZIib8A0wqiDgyiQ52zJFtToQeqU
	ne9cR9CWZLos6DjoungrfOt8ELf0CvmXywVTNEENbMNEG/KD5aoybilhynkyR+3tXI2Pw==
X-Google-Smtp-Source: AGHT+IFq6EGDmv8SA+c628R92wFxw7VLISaJzwL9jC/dCitTGElOFEmCtRXKBBhmAeGYtAJEz6P0da/QWsT4rsG8Kio=
X-Received: by 2002:a05:620a:4590:b0:89f:7884:4c66 with SMTP id
 af79cd13be357-8c08fbe0f8bmr4375853985a.25.1766996425190; Mon, 29 Dec 2025
 00:20:25 -0800 (PST)
MIME-Version: 1.0
References: <20251229055151.54887-1-yanglincheng@kylinos.cn> <20251229055151.54887-4-yanglincheng@kylinos.cn>
In-Reply-To: <20251229055151.54887-4-yanglincheng@kylinos.cn>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 29 Dec 2025 21:20:12 +1300
X-Gm-Features: AQt7F2q_FJ9eCKtxsmT-to_PjRHpGm8k99DDIo0gUCxGDkP4P8FXcNwOkC_tEXc
Message-ID: <CAGsJ_4yLocY3c0oi022b=2Eq2CoxttQMn-XeWuSrjbKPmt5QPA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when MADV_COLD/MADV_FREE
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, 
	richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: onwbfkfgqrafyuzrokd3yhry37wnbgyp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5143E100004
X-HE-Tag: 1766996426-753157
X-HE-Meta: U2FsdGVkX1/LyxkF2BHYA1g0ff+ZyB3ybdxQcKU2gg8VI1a/uQis+hNz02/oe1ckc7Kr3rdFtf0hBA0MaVsVBSbnz6mI5kcgm/Xu4Du3g3+UM60HkK7Ylc0zy8p82B04z3dgoZ9KeEadl5xe6moNSqHqFIwiIEpkwuOXgCLGKK191/Z4Yhcsha/ZIPZ6DNjDnijVmUSIVsOLysqlGMuHthNEQBmzOCnYA0T+UiopfacS3HaYWuTS2Q10iI3kSQhREy0Xm5cMev1KPI95AJ4jjlq19uJgsUmDP6Futh5GAqBupy06bJyeaSfSzrV3l9S0TK7zSLbIxbbJeoFF2DmYrAbnf1hjImdt5IByLu0ZUHX12oSq5/fskz7yjhPgzaDKyGm1rvhsnGG7koHBFiYfJle9ie7zJGUTi2g9IyiZXINleiLEA5atgR3zX04d4kbFpBtFcgqb+U3pV3/rh0Wfz+hgyAfcVqgfylzu0VoEKaMsV2TSGSttkzCWzm2GMDh0mp73rm+jP1LEZ7lLxam551a6waf6Ej25EahDybZznY/zib29zuGCQnoj0z69I/xGg217+BIHxTrgYSn+eCfZ+A0ScSxH4DZNcCP1IdquZtO+lYyIbh15R6LCANYYRUWEA+EwJGm8LjkCxCwYiS0ZOd1VPz7Eh2ZLLnSf2BGYjzhdETC4HrtPtQhDaIY5igQz4aO441Tm5FwMTfEPgInvehabI1q1SkWtXkc62Mtjn2H8VFLzhrBQ1LeEcNAWqL9MNTRami4O2Ev/IslWvMBbN1XxfganijTsYdw07I5JBxjgGsyh0+am57QNePVif5nld+xk8EqiQhI6cuUnb8PDt+wX2H2UNcYQKqspbb/40YeNp1vwsSmPItsxuqT30NZV6UZMUUFKfvlWTAZDHqP6BdCOa20R7gn4Hacdq7+8tKYzRS2VaAP+qHf685gsxfzKws+/kQVadNcO4NK23jF
 X5Sqt8W8
 2OUaVtkN9h+qwwBdQy1yFmrYsQvZ0HOCQ0r3R1ZS7j+2blB27n0tCDKECcCuCNbbPbeX3RYFwTRVbRDp3u0Vr3GTLzFtoqI2daaVkEaYrRF3VEe89YMsPYrjCiXNDTHWD6lIfdLrjqQLVpc4Z5poW/2FwfEIdCHUSeIhz+XP4KehY0x5oSYb5vQ1A1V6XxWKLTXRctdHqcCM2QXgk9aR/CIMp2xuyww7dcgRbqfG43g3167mARI+o4OafFQisU6kUshp0S8wDYxH9Lj/rPgdNvlHbeczrVlktdE25iGVOeX1Wo/0JBe/nn+9B5pjqejvhqwLHNfpWox37n0Ftvn9eFvt08phT6KT55xlJlpa3Y+91im4zHK8R4IlkhFZD1SvJUWF4u/VHTe5jh4AYnDQWG/XSSfG4V5s2ujwS/xlXtT6KDuG7mms+NrhjERbMogTkLb+Z+Zhw+SuAc5LuJeWAbuvk3BhB9wFf9QOT+D12StPq98/JwXKXDhBiNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 6:52=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
>
> So if the user has explicitly informed us via MADV_COLD/FREE that this
> memory is cold or will be freed, it is appropriate for khugepaged to
> skip it only, thereby avoiding unnecessary scan and collapse operations
> to reducing CPU wastage.
>
> Here are the performance test results:
> (Throughput bigger is better, other smaller is better)
>
> Testing on x86_64 machine:
>
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> | cycles per access   |  4.96         |  2.21         | -55.44% |
> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>
> Testing on qemu-system-x86_64 -enable-kvm:
>
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> | cycles per access   |  7.29         |  2.07         | -71.60% |
> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  mm/madvise.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index b617b1be0f53..3a48d725a3fc 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1360,11 +1360,8 @@ static int madvise_vma_behavior(struct madvise_beh=
avior *madv_behavior)
>                 return madvise_remove(madv_behavior);
>         case MADV_WILLNEED:
>                 return madvise_willneed(madv_behavior);
> -       case MADV_COLD:
> -               return madvise_cold(madv_behavior);
>         case MADV_PAGEOUT:
>                 return madvise_pageout(madv_behavior);
> -       case MADV_FREE:
>         case MADV_DONTNEED:
>         case MADV_DONTNEED_LOCKED:
>                 return madvise_dontneed_free(madv_behavior);
> @@ -1378,6 +1375,18 @@ static int madvise_vma_behavior(struct madvise_beh=
avior *madv_behavior)
>
>         /* The below behaviours update VMAs via madvise_update_vma(). */
>
> +       case MADV_COLD:
> +               error =3D madvise_cold(madv_behavior);
> +               if (error)
> +                       goto out;
> +               new_flags =3D (new_flags & ~VM_HUGEPAGE) | VM_NOHUGEPAGE;
> +               break;
> +       case MADV_FREE:
> +               error =3D madvise_dontneed_free(madv_behavior);
> +               if (error)
> +                       goto out;
> +               new_flags =3D (new_flags & ~VM_HUGEPAGE) | VM_NOHUGEPAGE;
> +               break;

I am not convinced this is the right patch for MADV_FREE. Userspace
heaps may call MADV_FREE on free(), which does not mean they no longer
want huge pages; it only indicates that the old contents are no longer
needed. New allocations may still occur in the same region.

The same concern applies to MADV_COLD. MADV_COLD may only indicate
that the VMA is cold at the moment and for the near future, but it
can become hot again. For example, MADV_COLD may be issued when an
app moves to the background, but the memory can become hot again
once the app returns to the foreground.

In short, MADV_FREE and MADV_COLD only indicate that the memory is cold
or may be freed for a period of time; they are not permanent states.
Changing the VMA flags implies that the VMA is permanently free or
cold, which is not true in either case.

Your patch also prevents potential per-VMA lock optimizations.

However, if the intent is to treat folios hinted by MADV_FREE or
MADV_COLD as candidates not to be collapsed, I agree that this makes sense.

For MADV_FREE, could we simply skip the lazy-free folios instead?
For MADV_COLD, I am not sure how we can determine which folios
have actually been madvised as cold.

Thanks
Barry

