Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7219C9830E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 02:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6FA6B008A; Sun, 27 Sep 2026 22:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F296B008C; Sun, 27 Sep 2026 22:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7836B0092; Sun, 27 Sep 2026 22:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAC746B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:48:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E93F9A739C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:48:56 +0000 (UTC)
X-FDA: 85261638672.30.BF0670A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC891180003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:48:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O25pkvFH;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790563735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZXmNamni8YTdkgj3WsVi9gU+V406f6mQymnA8E88y0=;
	b=atON+GfX75nWZajgNNcJEGrdyWPb9gN8kUwipEgwui8oqL58b1fyQU1hIuxyDKjWygi9C+
	A+stZRKprAP49B9SThumPS0VuFWW2vS+xW04aHAV5aXA4beHcKYfOWaSXFYSWcC79ZSksl
	puLB6dL5uurT+BlsgtggfUPwj43v4AY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O25pkvFH;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790563735;
	b=OctLVed5DCDxz8baWYxvm5AR/Z8JzycP2x6NUs4I4vdPQl6af0+bM5TwJIOrHruXrzsXqh
	PdBsCrwZTNpt+59G+eu/BSV+8Vd8kmoO0XqJtZmQLbXK/y4tQRiKRSINMqqVZn6yTtxjqy
	wswlmwplJRUYcK7AECp7bH1iRgs1QiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7B10447BD
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7F91F00893
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790563733;
	bh=YZXmNamni8YTdkgj3WsVi9gU+V406f6mQymnA8E88y0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O25pkvFHPnrIrFqD4jTGb58pzeF/yYdz+xqlud6LvYLra40cEEfQW5YVOGDAi1+yq
	 WtTq52ls8MYgjOKyFspGXIbInelB+hKEBDO5TT0OWe6OZGinzQp6HhGD4F67v+hvqY
	 ppriEstVjVqnmzJeKR0y48f9O0JuR6ACyGsS0llxzK9xjAUnxKguffRUk1P4tc/dp/
	 wCimEJYqg5qIHscksIE7jZ3a1BOFofxmNWSzDrcFKKWrM7NJWA6eTM089/fvoaCIEX
	 Qp6vJhZJ97UA9xb1WCxQ+x8+nm2t4+LeXDylaENFl4AjkT438bc5izWWWaXpPHyYoQ
	 1/ewTcsMuEi6A==
Received: by mail-qk2-f39.google.com with SMTP id af79cd13be357-93c65d5e6f8so52703185a.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:48:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwzOn06fX6GNzzHpEHHi3hZ5dgA8iN8Ket0boLVUfZvGI81bCWtXwR2Stan+9lqMrf0qwkHVk0Pxg==@kvack.org
X-Gm-Message-State: AFuF++l82npAr3PZaype2HijjUUPSQlc61BLE5s3Kl/KlrSY1a1CiJOo
	Oe4/1LD4gilqNWRPQSPSt+RqRZvLCQTZwOSz7udOsF5MBJ+x8EcMXUY8qpbrJ3dCpxSSQqcJJkE
	qB9WqjcNj9Xt18z1tfUs5gRzcOSGn30U=
X-Received: by 2002:a05:620a:2614:b0:93a:2bdc:cd57 with SMTP id
 af79cd13be357-93c43b7f72amr1824335585a.2.1790563732750; Sun, 27 Sep 2026
 19:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin> <arF-E3Nsw9ZliH0t@casper.infradead.org>
 <arI_w2wTfA00Mgy9@gremlin> <armexcXDiG8ryZd6@casper.infradead.org>
In-Reply-To: <armexcXDiG8ryZd6@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 28 Sep 2026 10:48:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
X-Gm-Features: AclHuK-KBiQtm0KE630BoXAk92dmhRT-WqzJYFoYV9V1f9Qw5fyAD0u8MfblD04
Message-ID: <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
To: Matthew Wilcox <willy@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com, 
	david@kernel.org, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, zhaonanzhe@xiaomi.com, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, 
	chenhuacai@kernel.org, kernel@xen0n.name, loongarch@lists.linux.dev, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org, 
	hpa@zytor.com, Hongru Zhang <zhanghongru@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC891180003
X-Stat-Signature: mxrdnap5pkucaoare1wmh44eqoh6od5u
X-HE-Tag: 1790563734-548296
X-HE-Meta: U2FsdGVkX1+ezMj8mV2g1Ymgi7panzD7ZgmmItGdO27z5QwhyDVBfNAtEQr+b4iG7bOn3o10CdOcs97WAeAtw8qiTmfTOcHgoginw477Py/iQeBoz2rYwDSwK7NM4G8pAmaBLOCG1B3ym9aq+SruhMQVP3J3qN2aNhT/yb1q3QN/xjcS0J61BZUdymNVI/q+rp3g1nIJ8Z+0VDgm9T0fnhGVNb5MWK0rlmF8J2sXwRJc2iPSTtNfJ37OsV6/M+MLldjBjoYVeDfEidvYzwVh+3hV5k24QC5k0n0hTFY7zpyFk/MV8ZrjbNdOW4C4xD+4qjxEigcDM77FyfeX/VYppbrRFJPTt9DDBZWOyqMwmE3X03+RYbSQJHUjlrnS9G/94Vz92JTCDTE8ZAX0zVFULfmgCJJ4aWM+f08e9gUXd0fx4DzT1ymFRBaJOITcms3BtBh/aLRJmYRgE/bAK/727dURogig9UVR6ByqO6elJ8lJod5iVrOMyLASY5j/PYiaBprbSUTufCZm9p3t2AkU/sx1YTMLaBO0Jcekp6mxQXUm5/NbtwoFy9yJJV7NGAmTkMvKJBExgbu+QCBoc1xxIQVLLGI43v3MznHON2ZfegNyZWFTKNimkGED51yJhdCE9keWnqrKP6nC48DoF4W0TK3K5Xy6djli+buMHrsvz4tSpFrtQIpUHEZ1rIRzpIxIM91Q4xQkwfzXm4+GY1kJbjNgTWbsZhrqEumnBiGvhQfS+WYVZ9RzLuWJmMSXVDR1bRwLKEcTIjyZ7vyR9oaCtlYbnsuvwTLJZW5yoQ1LW3OBYpStXJPNMG/d3sw2m4JFgWwkK3i8t51NluyBnFjB+Uxr+85kzQ8dPCvByT0FikmrWl53t2p4hGSfs8kkmM7X/MsWXEqfRwqJr+OusztcQVVSz8P7xekw+/cxojQAYLJD6Yf4U2djaub1/vtopLkb3avE1nKCgW1adMVRPCd
 HM9+Tza8
 QDfhH0IllM7HS1FuShWjhA8fesNA+XnDeNDVj1/24cBZRG9eSi7rl2m90zUJ19zfA/KWzg8g1lxtBMcdYzzx8dyoUluApmiaSpD69t0TCocJH8vuw7qyjGr/tA17sznodT50Q08JmIWJlfgDuyyApSPcR/TSAdf2zt/BYtCoLbwldmsyqvC3UkSQ2sbO39F5F1QsUh3u89lw5zXSGI9LgvcZI4KPxPcLZIm6OjZfTtbU8SQ09XJ66XZHLSfGq7DUsNGSLPuLNhiM3Wv8HyvwqHNND53WD9H+VlAmhTxzjqnkG3PCeEyjEUfkyGN+Um4USA5GPG6KSlquMQffBITVlqq0a53+RcEXU0azkI0QnRMX1v+NaQ0WKbuKslIFyLnBFw9dc6PL8tHyZGdJ2HPoJP5pwxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 6:55=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Sep 22, 2026 at 09:55:23AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Sep 21, 2026 at 07:57:23PM +0100, Matthew Wilcox wrote:
> > > more to say on this in two weeks at Plumbers.
> >
> > I look forward to it :)
>
> So while doing my slides, I realised that what we need to avoid doing
> is (a) sleeping while holding the mmap_lock (b) returning RETRY while
> holding the VMA lock
>
> And that turns out to be as simple as this patch:
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..94ed2333f8d8 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -723,6 +723,8 @@ enum {
>   */
>  static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
>  {
> +       if (flags & FAULT_FLAG_VMA_LOCK)
> +               return false;
>         return (flags & FAULT_FLAG_ALLOW_RETRY) &&
>             (!(flags & FAULT_FLAG_TRIED));
>  }
>
> OK, this is a hack.  The function is spectacularly badly named, and
> needs to be renamed before a patch can go upstream.  But this should
> fix the contention on mmap_lock.

Thanks for your suggestion.
This is exactly what we did in Android Common Kernel before we had
Lorenzo's proposal (bypassing `fault_flag_allow_retry_first()`):

https://android.googlesource.com/kernel/common/+/1b9b045a586245cc1c29b2747c=
6586234c7f5bad%5E%21/#F2

At that time, we couldn't modify ACK with a GKI hook that introduced
a new flag. All previous versions of this patchset introduced new
flags, which would have broken the KMI.
So we had to choose between two evils:
1. mmap_lock contention
2. VMA lock contention
We chose the lesser evil =E2=80=94 no. 2 =E2=80=94 and sent the Android hoo=
k for
merging into ACK.

Now that we have Lorenzo's proposal, which doesn't require any new
flag, we are adding a new Android hook just to mimic what Lorenzo's
proposal already does:
https://android-review.googlesource.com/c/kernel/common/+/4307957/3/arch/ar=
m64/mm/fault.c

Note that Lorenzo's proposal avoids mmap_lock contention without
introducing any new VMA lock contention. It also doesn't require a new
flag that would break KMI. So this is clearly the preferred approach.

>
> Could somebody try it?  I've verified it boots and runs some userspace
> fine, but I don't have the workload to test the contention.

Both Nanzhe and Hongru tested it before and reported the fork issue.

Best Regards
Barry

