Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0AB606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=GPCuF8AE
Received: by kanga.kvack.org (Postfix)
	id 55B966B05B6; Mon,  2 Nov 2026 07:53:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532916B05B7; Mon,  2 Nov 2026 07:53:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EFE6B05B8; Mon,  2 Nov 2026 07:53:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26AAC6B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:53:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7072140A5B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:53:33 +0000 (UTC)
X-FDA: 85390170306.29.86A9D53
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf04.hostedemail.com (Postfix) with ESMTP id 09CBC40004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:53:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=GPCuF8AE;
	spf=pass (imf04.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793624012;
	b=7PsMg5WT8gCl5Cz13eBM/LTa8btcWjct1zvoIHMcWlkrP10xOUEA0soXRUAT8jFhyGf8eV
	62mrj2i1l1kn4o7DDP2fdchMZAVlPaDMTfvCBrO0BFy+RTcIRZPTdIrgwFKdLlyqG8DD/8
	ncV/tud+jqsYUAPSAQz0WrauR//Pt7Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=GPCuF8AE;
	spf=pass (imf04.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793624012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DN6nJAak3G5hg32C+AP78Whr8rhMiUJeU/VUd9QqpQ=;
	b=kirEhrTCjRPjhaAkw3sB+Os4bh5gOF8VZYjVn2t54R4DOefZ2IIT+TBvBQeXM5dxCN3IiQ
	vOEBvSAQsIlDUlj4vgsuABBNdGLtD3eT3ZjftQv+DIiU4BPx733r4N56Zv4vg4GjJadHaB
	1YX30oABuHWZYl8hViyOUyKHO11316M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793624010;
	bh=2DN6nJAak3G5hg32C+AP78Whr8rhMiUJeU/VUd9QqpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GPCuF8AEDEyGDk9usc/SqRzvSdkMdf/x9PCHiX0/g9sRFSEZrMupzvJjkvCbYLygZ
	 De0e4+QZ48f8q7wcj9lffFZkofDQ8p2hGnuP6ZG/SaOv9Yexmt68VXXrI+yavaTI73
	 sNaTN1X5Ok5uWgMEnqI9S5gjVeN28o78kGXCLAYs=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 51BF4101462;
	Mon, 02 Nov 2026 12:53:30 +0000 (UTC)
Date: Mon, 2 Nov 2026 12:53:26 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "Artem S. Tashkinov" <aros@gmx.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org
Subject: Re: mm: tmpfs: huge=always Kconfig help understates severe space
 amplification
Message-ID: <auiHxos_Dr1PXEB_@shell.ilvokhin.com>
References: <b42192af-d9b6-4820-bff3-e3b6c6ce9bf2@gmx.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b42192af-d9b6-4820-bff3-e3b6c6ce9bf2@gmx.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 09CBC40004
X-Stat-Signature: d6pyqm9obyoicm3sojdm1cwmmg8w5r4m
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793624011-197626
X-HE-Meta: U2FsdGVkX1+hWYcKGXO72+OH/gPIT3KoiloKiUb3d2UbgwN3VGa+3xqncO0MuX9CuVSOWd5I3MVAu9i29CzdmI+BRVZ0SW9IRFccQajPLQZRKKzFc1/G+rrPHCVp511HVyJf0WfKskKdZLbATIrPrtTBqN5PQfJrl0/TTp6r1C91nY9zIILbSY/4ET2wOmjcsz6sCtsNK7Xfrr6qvpxeCyvhdXfUyG3pK8qMPgQl/32E9A8MbQNEtEDGLpW62v5sptu2K6ATjYBqKQFzFId1cgFZKYYEEEViYydN7nT592KnuQzbxKRl6pq/mLZ6OEPeDmaZz4A0cskPylVELz8swD4gw8HHFpYmRjEN/q8k5vrLRN0FCX1m8rH/fRwKvaH75OmXbWvGnTdrKBiBBQiG4+XJPc0/M7C0W4wLFFqQERT248khqDIDqGoU9BCAaHwcA7wZCvsRDCtAXxcYnnbs2w+vsO5oZ83ajvrbZyMABrxt/HFL3q7Xup5JuuhXrnA+Ff7/Smz35GiJVPeve3WgBqS8IBeNtuAzuL1oa1NMjqllD233hPpU6hv0731ZBTHbW/QglYWO3XXHMjbxGA7YRPMAnfxGZBXSroOthCVYKna5qoodOmBaUrofmqV+Kvv6GaevngBZ3VVP+wUM85jkMLnJ8HngaEDt+ol8ZP3TOn4FjsavEDYF2itYTfgYtPZnP3dQ3o8bAqp3KEwSq1ArNHgxZU/JAGHm/a4ZGLTzM6Z5Fwt/vAtRXfrF6/+k7AGwaxCe9x8hg6AJTTs3IXiv3srV0QzEqSElTMcHtuB1KcWn46APgVeEHaEHT1cxTmIH2mMS+NuBhpj0+8Ffbu61fAiUqyFdJqFYHp2NaLVfvNXttmd52WhNHbaZyLtX9+Bt2HeVUFHB0l1YNllTXh3FtQe+jjBJtx/6TCWlPvNBtPLrvl+XjrEZ0IpWTPiqFYzHwI+WBiINQsUch4nezJV
 CQDLdIHx
 6E95I/wb6pCNZTVq9FQkwANZ4+YApJ15e39ERSnB1dU1AdPugG4w0LPsxvpFWDiQm9ocDRvEw+esO5a/yOHZ9KxjjgTklsaF3ti+qdK+xQZr24Avo5o6iXPBlhO9aCcbh6yJWZxKGNwIc/YxiDj2raS8KJcpU61GbDB1igsGaza0CyAEC10+1a4GY+pB4RZ760qrOGiahJ4z5ANAaijy0PPvE97b6XLYWQj2ff2DFBE5QN5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 03:19:08PM +0000, Artem S. Tashkinov wrote:
> Hi Dmitry,
> 
> I'd like to raise a documentation issue with the Kconfig option introduced
> by your patch:
> 
>     mm: shmem/tmpfs hugepage defaults config choice
> 
> Specifically, CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS.
> 
> The help text currently says:
> 
>     Always attempt to allocate hugepage for tmpfs mount, can
>     increase the memory footprint of applications without a
>     guaranteed benefit but it will work automatically for all
>     applications.
> 
> I believe this substantially understates the potential consequences of
> selecting this option, particularly on general-purpose systems where /tmp is
> mounted as tmpfs.
> 
> I recently encountered the following situation while extracting a Fedora
> filesystem tree under /tmp on an x86-64 system running Linux 7.3.
> 
> The tmpfs mount had huge=always enabled.
> 
>     $ df -hT /tmp/Fedora
>     Filesystem  Type   Size  Used  Avail  Use%
>     tmpfs       tmpfs   48G   47G   925M   99%
> 
>     $ du -sh /tmp/Fedora/usr
>     45G     /tmp/Fedora/usr
> 
>     $ du -sh --apparent-size /tmp/Fedora/usr
>     1.4G    /tmp/Fedora/usr
> 
> Even more strikingly:
> 
>     $ du -sh /tmp/Fedora/usr/share/man/man3
>     7.5G    /tmp/Fedora/usr/share/man/man3
> 
>     $ du -sh --apparent-size /tmp/Fedora/usr/share/man/man3
>     7.8M    /tmp/Fedora/usr/share/man/man3
> 
> Thus, a directory containing just 7.8 MiB of apparent file data occupied
> approximately 7.5 GiB of allocated space.
> 
> The overall tree occupied approximately 45 GiB despite containing only 1.4
> GiB of apparent file data.
> 
> This is consistent with severe allocation amplification caused by
> transparent huge pages, although I have not yet established the exact
> breakdown of huge-page allocations and other tmpfs overhead.

Yeah, I think one can expect up to 512 amplification on x86 in the
absolutely worst case, based on the ratio of pages sizes:
2 MiB to 4 KiB.

I suspect the magnitude can be even bigger on aarch64.

[...]

> 
> For example, the help might say:
> 
>     Always attempt hugepage allocation for tmpfs mounts.
> 
>     WARNING: This policy can substantially increase memory and
>     tmpfs space consumption, particularly for workloads creating
>     large numbers of small files. Allocated space may greatly
>     exceed apparent file sizes, potentially exhausting tmpfs
>     capacity even when relatively little file data is stored.

I would probably drop "WARNING", since there nothing to warn about yet.
Also, second sentence communicating the same idea as the first one, but
with different words.

Probably, something like this will be enough: "This policy can
substantially increase memory and tmpfs space consumption, particularly
for workloads creating large numbers of small files."

> 
>     This setting does not guarantee improved performance and
>     should only be selected when its memory overhead is
>     understood and acceptable for the intended workload.

This part is already mentioned in the current wording: "increase the
memory footprint of applications without a guaranteed benefit".

Anyway, I think documentation edits are always welcome, please, submit a
patch :)

