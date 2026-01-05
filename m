Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF74C2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 02:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE8F6B00BF; Sun,  4 Jan 2026 21:07:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86266B00C0; Sun,  4 Jan 2026 21:07:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB34E6B00C1; Sun,  4 Jan 2026 21:07:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 989436B00BF
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:07:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45CC3D66FD
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:07:13 +0000 (UTC)
X-FDA: 84296272746.02.C1C21B0
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4BF1EC0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:07:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HMdxQCaD;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767578831; a=rsa-sha256;
	cv=none;
	b=QVtbZkzsTIcDTJyf+MYVIXH991VHfwx3vfWKp4/9Ul/7XlXO49gvdhi7pBAgVISUPsflrt
	b6poXX3WigB/pB9kYlsPL4HNgR1BZGLTI3vX9SrnZrQ5ysR6l2hfo4C7lu2KjBWrj3Ez7s
	dYxuY8tts5D2klCFEKF4jbQTww3/z3g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HMdxQCaD;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767578831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxJlwAvTaSQdlvGiWEacWSUDeV4gt9sjOdRHDVli1FU=;
	b=C108248VJHf5VdhLGgDRSWqH8E9iToXIbWKkTBbQECg/W+lmK5jADjHJSaKUgpb2kAhT4u
	PhXRDLdT3Olq4pNL1fF79Be7teL2TXf6K1j2noFvIS53CwghaxcnR8LbSJpODi7iP2N/8Q
	+IxrIoONnq/GMea8vCo8It1aZ/i5hvQ=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37b99da107cso128904181fa.1
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 18:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767578829; x=1768183629; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxJlwAvTaSQdlvGiWEacWSUDeV4gt9sjOdRHDVli1FU=;
        b=HMdxQCaDoDjdbaF7TqN0egHvaIKqIatdZ/FeE7oWlnJwVP2GZxdptUmtknfpQtk1n2
         C/oa3ykGaZl8TPWFGYZ/GgZaO+kM/tgsfRKf71XJAI5VkpNZr/eTx+pDrcw0SAV06y+k
         ujMjBRUfpTvzxXOBnbCd+3x2/fKn8YmUDmheub2SHCUafZYERiIS/cYqyhi9jvH72SA0
         hQ8zpDH665tYUQsuoPp6Pf3oMEm+0Wj713qlYbGl4zoGmQt03/a47ykznWxglFowjZRo
         wh+PVH2zQX0FGG6u9SViYzi61wRtvi99zYv9JSiV1yUw485UWydfv19sxoSJv/YbUvgQ
         jmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767578829; x=1768183629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bxJlwAvTaSQdlvGiWEacWSUDeV4gt9sjOdRHDVli1FU=;
        b=OJcjgWD3Nujy2dbpoUhMcW/Uq3Z0GduGzMSNIyBQwmNtkRaXrSsBhHgCeVqg9R2212
         lbjxpiM5HnZpA9KRdBZdfRTih0xOsMgL/OuMfkeVoA1Om/1ayL52VQUUxFfSIJVrMJ62
         W2j+2/Gj4LqCEiY4WIJKwNZvQP1H5PE2cDlo4PP8nPtz8G0700PDHmOrtRx3l4te86Rl
         /YqbBzjn0ACWtMpyFDukL6rfj7PXKUQU6T7a3ui+vkwAnD1zE21IeYXXTVPOJbvK8MXv
         +s2FNBq6iCWgPl1qwJBKk2EdgDRm7S/BVUEdocgXCGGFd20MzyXAM/Aucc5KRD06Pwle
         ALBA==
X-Forwarded-Encrypted: i=1; AJvYcCX1TGnD5nrvUE5O+5Pb3YK8Rg4OythRsZje6BoLM2Bl5p92U8tBvTnJ0mH6IXWLtWJhlQ2KYJ219A==@kvack.org
X-Gm-Message-State: AOJu0YxHzeptlxB8NQeWlaTkuJZXlHTDjF6LLIl8G24RbLUqT//YEvwq
	w96+zLOwBwrTwh2eNJTqHa1RAZkh/oCpM8RvZ4WwRvNa/8B8tTnJ6c6iWwDIK/2LhL7T/bTHY3L
	GpVq6fDhuUO0zp1txM1DR0eOe/ko9Wko=
X-Gm-Gg: AY/fxX4dtT6PazncYWBhc/N6AQE6hDwqof64SdHpCYy/MSIREj3D//EKyjG0OV53SgU
	0ZX3fYOwUF4kjUGy4wGSPeBg53nzM/1kTf47sSUWfw1JzbEj7aNfZ2v3ImNs/vDz4wCXXogwBOl
	3RAgTjV7s5UARQ4OmNzG3AD5guamhkrmAiDUMC5LfY6CSJ39hvVR2o/GfQ4AldRpZK03TLDhOt/
	5DpmeS6WuTr5+tKMvDHr8WZGp3x1YFQ5CkbhifhQTb8B4mqkI5YYazZf10WnOtDNROeddM=
X-Google-Smtp-Source: AGHT+IG6/Z/+SUEw8TzCehd+4+wcnpwfaw8zgDh+B1DV/aKa+CqZG2QmMTxcBrFBJDfGSxUums/9euBPzMpzOiOW0qw=
X-Received: by 2002:a05:651c:1507:b0:37f:aad0:4082 with SMTP id
 38308e7fff4ca-38121318ac9mr136240931fa.0.1767578829009; Sun, 04 Jan 2026
 18:07:09 -0800 (PST)
MIME-Version: 1.0
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-7-yanglincheng@kylinos.cn> <bfb6f8ca-fa17-4ce8-a2b5-09155c50cb22@linux.dev>
In-Reply-To: <bfb6f8ca-fa17-4ce8-a2b5-09155c50cb22@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Mon, 5 Jan 2026 10:06:57 +0800
X-Gm-Features: AQt7F2oSSJEOLzqjxvuxtXh6WcFZq9R_WYO_4tOMP5dn9NErFqa9LYvIxwHSn2U
Message-ID: <CACZaFFM4mk71KDu9g6Fb8qBL3+5cMuZOfVUzQ+eb36q9BeKn8g@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BF1EC0005
X-Rspamd-Server: rspam04
X-Stat-Signature: ix6xkwr5radtk67rbp3tzeh6s5ftztjs
X-HE-Tag: 1767578831-66977
X-HE-Meta: U2FsdGVkX18PRlLPfI2EBgjLrwT7NA98AKSMnnZrZkxHiB8SLavCzBhXtO+4Zahr97+XjYYwk5anfEwwKpH+74J1Y1Yn2pauiueNQEaLbNakYqUqPaewIoDDcqK3IeGbNytUCXeDX6XfSOxlqe+WChH1/kfuO9Pbe3cP1RtJPhJ5XekOYvz2U5vLv/x8M284nqhVqtn1amt0xlrZBhBqunw9vkyTH5x8wEqQjymS+1mvuLloE4KKb4Mf42mVlS4Fsc2Qa3LCePaTWDjYs4zTJcnhUqqw5s9RwDAuD6dZT0a3OHBhZI4Pp1a8HRC0q8LKcEehxtziGKkmpQpyuEc44aYXahmlSdPqmsP7IDOpEV9vQjeS9MAIVnK99xijOBtrw6kBybAP04vMweiuQ6vtqTYWyvAYuJ3s3uZK9SRUoXRq9foQOhDqFNyjyUqda5PHoqzO/Yj478USfLLHe6vPncD3hL+k959GDq3Wh+6r/G1B6Ow6t3RDnk7sO4IY3RC96MxiO3i3JhlTamcwSSecto+Pgw1vhUvUcx6+le4E6V2k8Xuof1yNn6l03miwE14ZD/O/V2qP7fH+5bKRGldwTdO8OhX7TQwozgBdXTNeM0ZVPkqTSfnZHKquQJJX2ixMhCWr4r9SdTdMZ3UKgL5XR22x30/s8yNutKOtKdy3NfltoGhMru8KKyCwuP0O/KsksrBAjVLhwLN4k+j5VZjOHu02AMRuV6DEMt+lRLrtyGLfPl9x6HNZCiFhX/h5hKCiTOZOqz7oSGjJZk/4WTWGphGBgKOZqx0lmBxYSUQ6dAtCho4UsRFPHYonUYqyFWN1ipk3WQEJped28qiEafRDTHwqz8lrj3vtauxlNM3Fg+wuHmzjIWGCwnvp532kGxSyq9OCk63DFWRB255IGeeUCKqKt7f89Zh2H9l1KeRZQqQI37XHbuXwq8jM4Es68Nnztf7vihAkdXui94GZY+w
 5no4uX/s
 pA9Dq3WPJdnY6nGZPzRlAF+6IYGQ62UGeD7PGeeM/pE3S2IGxQ8MPhvsPYwaFu5P8kLP4sOX4getQ4dLkWQHlxsOgtAjWWiIPt7DWA+QEyQHpQwP7Longh1Rw6kE7XZqFypXjMJYSg0tcj/zLbM4BePPIcOMj7X9Oh7dYzy+LLjCJWGBhKuV6PO5k2Ogu3VkERxkhlvVBAt0C3RTwWLIwJM1F/AAcDkOMws1M4VeLMq4fLaGlSLP6uy6M6NlSH0lSvMcTv9CrYfVGY/qjPmqtX94kbFJ3Urn2iKzd/3khXTnqHLVvw6R7/jOjZI2suCQ/paVUzheoo58ODpCVok+MvpxhDZxGBLLxBQgtmzfFX46DTpsIA6OnDYrLTn/nXOg4ZUbWQrNzfi4n0tIJNghzjVok35lDixkdnaJrcQogSnHo2dNYG/xUHGZKyT1gfnY5s9RHLhV4CVHufzerFea6JWGgwgTJgiDLs0Vxtfi6bRPPOXHEvsn4mIjntLzuixdE1LcaBKdZs7rquwo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 4, 2026 at 8:20=E2=80=AFPM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
> On 2026/1/4 13:41, Vernon Yang wrote:
> > When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> > scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> > reduce redundant operation.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   mm/khugepaged.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 1ca034a5f653..d4ed0f397335 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2541,7 +2541,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
> >        * Release the current mm_slot if this mm is about to die, or
> >        * if we scanned all vmas of this mm.
> >        */
> > -     if (hpage_collapse_test_exit(mm) || !vma) {
> > +     if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
> >               /*
> >                * Make sure that if mm_users is reaching zero while
> >                * khugepaged runs here, khugepaged_exit will find
>
>
> Let's convert hpage_collapse_test_exit() in collect_mm_slot() as well,
> otherwise the mm_slot would not be freed and will be scanned again ...
>
> static void collect_mm_slot(struct mm_slot *slot)
> {
>         struct mm_struct *mm =3D slot->mm;
>
>         lockdep_assert_held(&khugepaged_mm_lock);
>
>         if (hpage_collapse_test_exit(mm)) { <-
>
>                 hash_del(&slot->hash);
>                 list_del(&slot->mm_node);
>
>                 mm_slot_free(mm_slot_cache, slot);
>                 mmdrop(mm);
>         }
> }

This patch just reduces redundant operation, For a detailed
discussion[1].

You already commit 5dad604809c5 ("mm/khugepaged: keep mm in mm_slot
without MMF_DISABLE_THP check"), I assume there is some problem here,
e.g. not can readd? data-race? etc. Can you explain the root cause? Thanks!

[1] https://lore.kernel.org/linux-mm/CACZaFFOvDad09MUopairAoAjZG6X5gffMaQbn=
fy0sCHGz8xSfg@mail.gmail.com

--
Thanks,
Vernon

