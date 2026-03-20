Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 053E3109317B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 04:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A8F6B009D; Fri, 20 Mar 2026 00:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04176B009F; Fri, 20 Mar 2026 00:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8575C6B00A0; Fri, 20 Mar 2026 00:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7442B6B009D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:18:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A9598C578
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:18:28 +0000 (UTC)
X-FDA: 84565134696.01.D120A5A
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 148EDA000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:18:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZeGM1QxY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773980306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTHsB9Dlkndqa1DDajEGF99UifNdHJBqvNvzj+3NWYQ=;
	b=0MIZwOksuhFM+csAcZPMrXwPdSppRP22CHCxB6n0AlVAzK5T3+T5mmgvP+7LmUG9nqDB8B
	OS+l5JSnOcNzDlZTv5gb58DX/4kclow2AJmUX5nKR+xv9WVRNbT0qUewh0rG3XsnPxBu73
	J4bOG48LdZ1u+8xBHQKbuQ0K/7rG+to=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZeGM1QxY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773980306; a=rsa-sha256;
	cv=pass;
	b=lIgC9qyX8vsIHAy93W+6hPlF8hSaPnFcKjfugITBnyu+VwRAEs1nq45nC3FvhE0CtQMY8l
	QoFnF6Kg+movDMp1ss/MUAmgA6RMHDmUPvrDflMpwjw5s8TTJM3AE4VF5yO0EcXmvvtF2d
	rnfnJLxqMz24pIcrcNK32liUVg0zEyk=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50b30d61be6so342561cf.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:18:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773980305; cv=none;
        d=google.com; s=arc-20240605;
        b=kFr/Bo9UsRKfSFJ4NvOyvRQA5zQe49r4OYfa4gIHpCbog3bLv3TvzPqFEhTpBlbqpx
         dwGrGK6+lGvgNA0+PO3oCT3TXBIpZ2qas5mVKgE7DznF4VmI5KDQPUFlidnKPnKLyGoK
         g7HHJdKsVI5hc7LGwE9Ps4fbCtZH27HN0A9pqyFbQOgBvLeJQB3v+nzvYIWacq1ULA2r
         kcmZ2006vRSUpckVgkOV1JR5ClEigdy+xzsAk1mYTPfmwJ8q/ffa6C4Rbvnw+3Tikrqu
         o6m8cz9Pr1BDPQcaeqyIntHokblzG3/kJNkCDvJX90SF+db6mdjGAbpvkgm68NqmWQIG
         yCfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rTHsB9Dlkndqa1DDajEGF99UifNdHJBqvNvzj+3NWYQ=;
        fh=tC8EQPNnnCwioDba5x5rvEz/kVYkOQ+hNRrt36SbkEk=;
        b=etcTkwd4cFCm4KFGAxk/ODRcVqWaEMsAiD1gQkhTTjpYjQIrs0fP9n7yw7JTaTLP/l
         Rhlas7NkZq9Ikfiu9yD/5tFg3sLQh5GbjK/D5EPk5wXeWBQhmX0UjTtDAuFnzpbHgjnQ
         c5MnRkwJJfIv9LP2LuopQwYD7FiU8Ww06z4PVXwB0oI+U3pKhYb1GuYgK0iS8vGQm1Bp
         XfQqtIKJyFiRkRBcAlmXuE4xQ80g4Pn2c3prOWZ2Qo/0ml5S3jIUnWrKSeiexR32MU2M
         R9t+WK8Xu6s+KrNFL1dlG9VjAkESP1pb41dwJURN3smXMoo/M7EwE5UCExSPQH/dcN93
         kPHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773980305; x=1774585105; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rTHsB9Dlkndqa1DDajEGF99UifNdHJBqvNvzj+3NWYQ=;
        b=ZeGM1QxYPvmj2OOySCp9adQu4fsXbmpEPrE9FgFSWS2zryTKrfOw3qZJk9fZqSq6Eg
         WVv0xs0tHxFgqhJBYS8Q8UTpDwFAlcrCPRo2+f9vjpCZnyxh3ok2NxadqOJiDFGM68WX
         OFAwtI1mHIdd7XMT5lDkJUrtkjYR0czSkN3QNQYB359I6/Mx42DqtdQHDR1pWgBvAema
         9ZZPHJO0PeODEpQoQZwdXhOETR3kFL1xcuAM7zdJqSwfRziB7xInb7No376RRsWSPwfh
         UaN5B6fuLVUG8PaCWoLBytjU0JlMAm+Yi/drH2aDidg0EnFVA2ZUsLdBf/8iAbyvGhxq
         C8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773980305; x=1774585105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rTHsB9Dlkndqa1DDajEGF99UifNdHJBqvNvzj+3NWYQ=;
        b=Qzg5UA3nAQ7lIl3RdYJWJdMvwCHFjSa66XrBpaBI7lH5lZG2QVGChXSFlaXAyCcAjb
         0s32Z/LA0sgXH/O3sddXq3cfEZXeUyS31Lz0tfBiyvPdvErMWPjh4Cw2ped6hDoIoyYa
         7OrpvTxTtH7M/xvrERum10uOPG00ddMT2GAawKV5ul9TzZ/OQHeiat5KkJa7NHzsGEsS
         kZlF0nl+MVSy09DhXh4zEps5ehb7GNMA+mo8H8+pXTmOJQFRcGU0pM85jm4yJ6q+U7fx
         IWhj329vnCy2b05v0jOtc1uGgcpvh1e9QVwbngvEUNp1hCP/2Ob5vY3ad1YpiAIch0/j
         PDag==
X-Forwarded-Encrypted: i=1; AJvYcCWFogigIrtv+j8EV3IPrSYv99ass9DLy27ffGI+v+gvJDveN8F6MzRZqVLuubH9CGvfXcqD2MjfVA==@kvack.org
X-Gm-Message-State: AOJu0YytDKAAyq6y1geHC55nYP2KUQiQMZ6IiiRMpSM1xYCuiA8CUWdW
	OohsZl9wsll0eBciIQ6lrAtpiuooYi+WKPrTjPJcmNt8+Eg6artyUFXW8CAjucRN8AIWRB8Wh7u
	siLu3EWR3MBnHPXRCgvBoiUsjHCUWY/Zq2Ec2B1yT
X-Gm-Gg: ATEYQzyqActujezLqAeG6SfrJRLu7oRi3WdWdNCrYuipoWUPvdQLxRoQOKoUkSt9ZSu
	8xRDdAHbJhKIfvgUda9wx5vwL8k8pE5XgjaLQRKShBDuCxNheQwmCKqOl/HdzAGbsUqIlRxa7Zw
	9EssM/zrGfoCSdzQUpm+b0TSXp9Nv5wHuVSaBvJG44KtN2x7biY7JJq3xQKvYF8R3jRL9T2gYlq
	rP32Fl21jwkhk941r2U57SU5kPjuJwncFUuiZCGjvd1Wvg1OmxC/J6GemU2b9qaMTU93Tb3Jp4L
	AxjJ/w==
X-Received: by 2002:a05:622a:551a:b0:509:25c5:42b4 with SMTP id
 d75a77b69052e-50b38792a4fmr5871501cf.13.1773980304474; Thu, 19 Mar 2026
 21:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260319083153.2488005-1-hao.ge@linux.dev> <20260319201434.b51833a0fea2801a2b220ee5@linux-foundation.org>
In-Reply-To: <20260319201434.b51833a0fea2801a2b220ee5@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Mar 2026 21:18:13 -0700
X-Gm-Features: AaiRm50ZUmad4VXJ0gptwsX2l_5J4eTSK8Lt-T3-4-tHMqhfCmgVPqJ52mDARDs
Message-ID: <CAJuCfpFJ+krn2DWWa6AMRhHcFPtG9X0JLESd+1JdLkau0uWJeA@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>, Kent Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 148EDA000E
X-Stat-Signature: thnegjo5dpydqzxukfmj3nfastb6t1hr
X-Rspam-User: 
X-HE-Tag: 1773980305-543896
X-HE-Meta: U2FsdGVkX1/zbTnSjtKYiDcbYLoKOb77Zr86fuE7T6vi36KohSIGA/innKAoFJRba7i7pfccd0eSzevFbQQ4Rx+DYg9VDDZZna3j+3Oi04yshJyUMEDjHq4ZAW/10z21G9uJ7MvDKtePcwUOCtHnRtmPowGUFNKQzdeuOulVuGPwGKgbuirsLMPu3ri6+cjduHYfsltvCACK/y4DHTTRIEX5FERU2SurNwuChD6K5g/wNB83/xfD471ZcO0PuBkUqo1ad9jthMIOcAfURrvs+sXZXAs2KhX/8Sfl70wuOIx4QOv6kl1AWtLfzDnIXfDHpCb7F8/CDjETxv49PSpMXI9VFran+SiWgJ7VFiYqSrY2UqlKI/s6RIionXWpTil3wWb/P1cBs96YyLcqKkPe+tplmSuUd9OuX81nzQOZ9p40k8ZQVZT/a4uNQg6XV81crCwyvoAvf5FG2JRHQMqbalk0CS8m4mTDH8NRxXhWtcC+ZfF2KhKhB5ugCFa1urBR2FgZZZjoVl4nt2060sWo9LSx/sM9NG0F2h0r8qUTJVvZTmb82WO2LlDvI7DbDreT8lERESXNrLEyrw0AF9AnLR2E5bYcHdtVq1bRDXwjia+t3R6m1iXmYRcn0Q++P1/hQWXmAv9vsB60N/9+4l2e4M6nZzku/dxdCncNiXMH79+s3MdF1PRErt4aJsn5c1cnpp4j1JPDqydJO7i3zicSqlUt8UTAf7/Wy3qozFQxDudZCsNdiINUHx/3jy7V+oBIz3gEwwNO7OkhK0Vfg67oaQ8J5QfzosVqnxbrsRvQSnZVfaoDJ7IlgPXcvlOFXthK7vZaJqhqUpHgPRueGIUsNC1e3HSKM1WNP/si1BmkyiNu/MlfHMIwsx15i3ZsuphRd+vW2t+FleEDZCgBJlLuyPKBvzNkVY3c3r5TKfXBwTqE62K1IjTooqH4N5uekYIbsJ9XcLn37JKggs2cKrA
 II7gPRC8
 LL/oCoWJsk7pXj+CMP35I+JHkBmxfnzx7IaEytRCkcohfXGhiZHUYtHih6M7INcwfpO1DtuArcJ/ACMGaUlvJ1O47EtW6268biPWCXfa3DGN2XBww1nCYH+T2KKgUkdNvV33Rz3f0LSKWmPCo7PiUgGwY1LI81Kdu/4pRSJ6oLT9uohd8O8GGR5t5klIWYib+9MNbT+B1xOHBoSxEOLt+8iMIXBcs7R8hHEZuQm7y5893liqhQKG8I66d1Ldcot2FARLbcxHW7HbfJ7ncIUxId49jS7nGTULjpkumY/iK6JlkzU9SNdepsB66z7MIxgr1TDooiWLtEkcwClyfjO9QWx7dO78AhG7BPFh5U5N/3FppOjtYzzmDHBuPDtup/GUcXofUxFR3KAlhxpeePz6AsUOWdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 8:14=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>
> > Due to initialization ordering, page_ext is allocated and initialized
> > relatively late during boot. Some pages have already been allocated
> > and freed before page_ext becomes available, leaving their codetag
> > uninitialized.
> >
> > A clear example is in init_section_page_ext(): alloc_page_ext() calls
> > kmemleak_alloc(). If the slab cache has no free objects, it falls back
> > to the buddy allocator to allocate memory. However, at this point page_=
ext
> > is not yet fully initialized, so these newly allocated pages have no
> > codetag set. These pages may later be reclaimed by KASAN,which causes
> > the warning to trigger when they are freed because their codetag ref is
> > still empty.
> >
> > Use a global array to track pages allocated before page_ext is fully
> > initialized, similar to how kmemleak tracks early allocations.
> > When page_ext initialization completes, set their codetag
> > to empty to avoid warnings when they are freed later.
>
> AI review asks questions:
>         https://sashiko.dev/#/patchset/20260319083153.2488005-1-hao.ge%40=
linux.dev

Impressive!

