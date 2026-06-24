Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0018CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 12:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92BDE6B0088; Wed, 24 Jun 2026 08:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6566B008A; Wed, 24 Jun 2026 08:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F3E6B008C; Wed, 24 Jun 2026 08:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF656B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:04:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD80B1A02EB
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:04:30 +0000 (UTC)
X-FDA: 84914673900.01.16AF9A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DFF3DC000E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:04:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gHXfCHHe;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782302668;
	b=JklbrsVEgipDp2qW50W7kINiytw05Q4XUn/d5N6AwEwk/PegzRQm+rlQnbG3CDbeJw8Agc
	LPY2zRTVk9rrjs9K0utoAbslP8PQH0pyP+uaVorKjC5SrY8VA5vKMN5eBm9p50CafNneRJ
	yj2DUvE/bHvxQcnxgPd/G/yjPDi1Zrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782302668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPkGECt5a+DPxd1vxVeft1Ofd1Mb2QRWXAtXqKgxgFY=;
	b=w6Fx80yyGx2rrO/fZS0JC3dofxS6Gxb9Xsm0OGYYScwuGCmq1eQASbd//6jlkRhUmQvWhu
	1ehgqIH+51/M2be8bc9oktMb430CefoHuTC5/XvH7ciGIk7Dog6Hc68YWSnuWqeSXKUmHk
	zMQ34rILflxR3iiegLOIKkBMzojRhxc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gHXfCHHe;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DC66601FF;
	Wed, 24 Jun 2026 12:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABD41F00A3D;
	Wed, 24 Jun 2026 12:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782302668;
	bh=bPkGECt5a+DPxd1vxVeft1Ofd1Mb2QRWXAtXqKgxgFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gHXfCHHeLJJQ6PuTMJDedcKWduFNd1gEpDrfxC0cXvLr5RvXcWyZxrXoRoFE6lDe/
	 V8PbBKhX2UwYqRfOdXUoEvJIE7gEKC9DZbULo8NEV5jonhC6sOJEYt1FpkLAIziamJ
	 0MzEgrttDApoOUHyIkn8MwPlAg3nlzwsrudmeVI31yS1rBpRp7+X+5u/5T+z46XBQF
	 DzCVrbdtlk/JfAzoBJin4OB4j3Oft7evDuvB1Mfazk2ginEgsC1s6Zm6l3buOCILVE
	 WSyB8LMIZezRNmbwRyUKQw64dUUSRIQIDBK4r4hS2dFCi5FJoFOITjX1Lw2rsV34R+
	 V9dTANI9rvzEg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id B3F5BF4006F;
	Wed, 24 Jun 2026 08:04:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 24 Jun 2026 08:04:26 -0400
X-ME-Sender: <xms:ysc7arJrmQBKPZMF7NHZ9TlaUeRfC4PjdpOQS23Md4llYtcCmRRSIA>
    <xme:ysc7avSmNCpscXkif3EuUFt60cx2HdrgoSg3x5RyeEQlgt_jllZ7Iu5JP0ivRffkH
    ZaTLlwhchhcqT45vK4Eq-LNVZkKKrmAmi6c7Uw2gnS2M8Sdn8Db1YU>
X-ME-Received: <xmr:ysc7ahisMMJgne3yhaqSpWOQ4ZNbxm8yl62DQeRPIf6o2pgVdcBWdavmetlbEQ>
X-ME-Proxy-Cause: dmFkZTE5F6I5b5uZvzSVxfQlILFYzxEnUbVGpGC0tlOAO1di1xZRoPj+aBYF3ihPNsV6UP
    AsQyKVi1xXuij4iiy8RU9hvvjU4ZhbyKXvWJNiNOEjkncWPlQrMyOpEMIbuMYzK1VCsIeX
    9eZQ3E2AsHkRloI8yXz+F1Qm18yX0pJokr8wZNZRv/PI6WIL3IrOdufGjVwdL92BvG070D
    HFdx6dkj+3BraPT3KjlB8VC957e/+oNNke/zhblgViiIKnDdvY0dmkJzjxY7OOZvLx871c
    qFoUJQNXHRvl7JVKuYZUpy3de409D0t6W5U1PXw+Wpf8CkWAQazEzW9mKFajAZXDTDgXgF
    ziYAfEMxaDqzsMOLfO8B0wK4U8VZ2Tgrf8Is76n9WT74HtuNp3l3YCfacvJhIAXn4exZCx
    mjw74zDmL9XDUxGh8z/7i3ZuV3c0EClGRQ56kwetkYSrOQzQFDQD7fekLoEhJiCGmEPGzH
    V6/hTquiL6rcojPoHWVT/bnoE+7It2Abm9QcozblpFEK0WKYbjBtcK3IjSlTy0u3dGzJ0N
    KWq2j6kUxy0mYBSOYltFVhqVIgmq8sN88iUzdsF51Xo+kX6f5Fh9a66uqIDvqn3xOMjghg
    WLAo8q6zCaLxyK9/P9dswjldKLuAoD0bxnW72YGG5Pt76IIPLaNfHQNmiIlA
X-ME-Proxy: <xmx:ysc7aooVbHNUJ-MsiwdYS3f7dWmYn035OELV-x5GozNcOjpOgpUACA>
    <xmx:ysc7agnWsCF1Ski3VuQJTTDgYhIbwTRfDOcBsNK6a0HHx06utPD8Jw>
    <xmx:ysc7ankraQY02ZSpJR7-e22Rz8ZgnOvEM7gyNZOfEbGyVvGUerNpAw>
    <xmx:ysc7atNe1BxOJlEwtiRCHC98iLie4dhu3n24xubz2GqtxvUnISMeZg>
    <xmx:ysc7am7ztHGF47Y0CQURacKtkYtjBjuw4irPf_R8CrP39zqnqgHGIIhY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Jun 2026 08:04:24 -0400 (EDT)
Date: Wed, 24 Jun 2026 13:04:19 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>, Ard Biesheuvel <ardb@kernel.org>
Cc: nao.horiguchi@gmail.com, linmiaohe@huawei.com, david@kernel.org, 
	lance.yang@linux.dev, akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, 
	pratyush@kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, rneu@meta.com, 
	riel@surriel.com, caggio@meta.com
Subject: Re: mm/hwpoison: persist poisoned PFN list across kexec via KHO [RFC]
Message-ID: <aju5_WjBtagTOSJw@thinkstation>
References: <ajut_LDQGYCShApx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajut_LDQGYCShApx@gmail.com>
X-Rspam-User: 
X-Stat-Signature: rp3zzanpbprd1ijo73omupws7ibz3j9j
X-Rspamd-Queue-Id: DFF3DC000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782302668-97726
X-HE-Meta: U2FsdGVkX19nnJBrh2jgKAU1R50JdY/s1bix/g9OxzgYnzdimM7c3QL82drzUGQy7zPQC3OSguhJJJaFjlDjxyjFMU0c95HmEIGy/PFPz4IudFBOGwfLws+1llYDf6S37XirWFb0d/nleRvp50EBuKkv8hPGDp7jyJEyhvsEdZ8DxsBRB6oQtN/3M9JL3xxwKw6LB6IsjOOfms7sIDkTYKs8fOMJAg7TpFMQvqbvV401UxfSserq+iWj17PzXh0s2hMuZHbYlpVEpGl/z6ziDEmaOMogHMaIMqjbtcBLDIYTG74PppmYJx2I/fCYZdpeJvUwTbLTNBOi9wPD/n5+LaEcVVFyYTOmzAUi27kHUyoccrXQ5J3Nk6wknaV5PQd/N+wn3la1FijRNbOWxXcpwazeEaQDuHy9tdu55N1rPHJhFX68+9Mdau8TDmHBbI9it49LkvMpkGXBGwIScb4MzJH3CW7xZmy9CIQ200sLom88/vRkHG30klGim2jn/r1WU8QRqCeEkg2YH8OFlhWy6qFakmXEVC/yJC5Icz/0TL6TgQM8WvlWQGGYswXetTvhd4UvJag4aSagXEe9TPZ9AmwYVLhfowUJSZl6hI80HOIcH1KtxUSCVYAiXc+poPxGdv23UVXHwXWtsQApPmGEiAbBJf2uwSbcCBIlS+IS3dWO+Im3Qq3oTjhV+ijWZaJAk2EHKUkWCQ5iO+cZmeonDaQJuoJSr3OyT8i+v/dk1mWrRKhQBicxljirYjsLY5ZdrTdM4awWUvrbwe0qcNnThoq3W4eTc825SbyAQqMOPD0YAE6OwGwQgittYvli66vNaN9n0FQTNu2z88AaHfyMz4hk7oeiVuw9YNKCZHB2yLYMWLgckzyfjrbCk98ae83IhP26e+atX2CLSD3+4E4fDVGbaDAUVS9jiTzldGRI5bzIw9RpEerKRLfgQHhF1Tsf00v2CxTRbap9GeO58dl
 H8pV5lTM
 zLaeMOGZ1wQpM29kyVRVuHbVDDyFHg7txW55BdQZ4Hw2RsGIqdz+dlHJJa10/D0/VxXlKElXulh+WOYnSBpzcKqogpE+/KZvszxzkhupJnEPKkmgaTy7mV4EusAbHoNXIqEIegz7vMMyvZ80J3vYD7HNWVBYH5LfPNk3/wCWfOt2EOzuQ7AHGJkRsLWjSFgJZReMLOdOPLtlh/dkhnFr3h6OhoTZdPolmZVatlkLOpU2HinoH0duhO6AAskeR57x0Cz7vfrfc1AQkxTCanbuoMEgaZLHyG4jQVBUa2G1Z9aVi/y/0os8ZW1LsCk5zOmfalUQIitk7Q2+hq3ppgqXwXriSv0Pjs41UShCO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 03:39:38AM -0700, Breno Leitao wrote:
>   * Consumer: early in the next boot (fs_initcall_sync, before the
>     buddy allocator has handed anything out) it restores that array
>     and re-runs memory_failure() on each PFN, re-offlining the frame
>     and rebuilding the full hwpoison state (PG_hwpoison, counters,
>     HardwareCorrupted).

fs_initcall_sync is not before buddy hands anything out - buddy has been
live since memblock_free_all() in start_kernel(), and every initcall before
this one has allocated freely. So this is recovery, not prevention: you may
be running memory_failure() against a frame already in use, possibly by a
kernel allocation.

Two windows are missed entirely:

  - memblock allocations between setup_arch() and memblock_free_all()
    (page tables, mem_map[], percpu) can land on the bad frame.

  - The kernel image itself: KASLR picks its location in the
    decompressor/stub, long before any initcall. The next kernel can end
    up running *on* the bad frame.

So I don't think this should be a memory_failure() replay. The frames need
to leave the next kernel's view at the memory-map level, before memblock
and KASLR.

> Possible solutions
> ==================
...
> 
> 2. e820 / EFI memory map (E820_TYPE_UNUSABLE). Tempting because the
>    frame would simply never become RAM (no allocator race at all).
>    But: it is x86-only (no arm64 equivalent in the same mechanism;
>    this series is tested on arm64);

(+Ard. I might get some details around EFI wrong.)

This isn't accurate, and I think it's the right direction for EFI
platforms. EFI_UNUSABLE_MEMORY is honored on both arches today, no new
consumer code:

  - arm64: reserve_regions() marks non-usable memory nomap.
  - x86: do_add_efi_memmap() maps it to E820_TYPE_UNUSABLE.

And it closes the KASLR window for free, because the image is only placed in
EFI_CONVENTIONAL_MEMORY on both (x86 process_efi_entries(), arm64
randomalloc.c). So the bad frame is invisible to both the allocator and
KASLR, which is exactly what fs_initcall_sync can't give you.

There's also LINUX_EFI_MEMRESERVE (efi_mem_reserve_persistent()) -
cross-arch, reserved pre-buddy in efi_init() - and looks otherwise fine, but
it's parsed too late to keep KASLR off the frame.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

