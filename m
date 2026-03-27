Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 019C710BA430
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445336B0099; Fri, 27 Mar 2026 02:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C336B009E; Fri, 27 Mar 2026 02:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359ED6B00A9; Fri, 27 Mar 2026 02:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 223446B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:32:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C45B21A0C39
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:32:26 +0000 (UTC)
X-FDA: 84590873892.23.620D3E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0195C4000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:32:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oRXHaPXT;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774593145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyEDSVIyQw5y9GaalGpB85YJe3/Er5fMMmqjUd0rZOc=;
	b=jEDnr5qdCcZriB2cAw3Z5UaWMJVj+q4mUe0RJKoF/DWLRDYoI3cR6vSniqz16UepJsqTm4
	4dER6gCEzVQgrAw7vRunLNvmKDGK+yfsOWOWbpebk4VcR1Ti3zUaiU+mPcbaOw7S8J7ljZ
	w76mE8JndPQafIxQZeVhlI8v4CfAF0A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oRXHaPXT;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774593145; a=rsa-sha256;
	cv=none;
	b=t5RhzQ2VKkzwp+XOrBYFVILv3dLXHFXzWfAJvK39Akg2VR0l7cc9t9AXcSFpepGTU3lfEK
	JhxiH/8DiOQhwXeDhrZE9YXikc+ctKHAHCfpkDxJZJnl+8kRKVJUjdSNnq/fRlTz3rMO0o
	lOKAFp/GLNvMILykTNPjrqVkCYDLaRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA14143B09;
	Fri, 27 Mar 2026 06:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CC0C19423;
	Fri, 27 Mar 2026 06:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774593143;
	bh=21/vliRDRKtbFZz03Jxj2YlSHmox3eBSlnY147e2h5s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oRXHaPXTDhFLdjDKwU8xl/jVRjlXkD6B/nI5CfERmQmdJ7iU34b4+GNfnpB/TRqUf
	 7W1r+VCvm/7HVOjpblotFi886eXGEt4lhXE2E3y+xKiDMT0CkZhf20XYaX5yxHjvs2
	 TnehIRFVeIHAFF7AwUFKsntNDkE6ryI5kzxteKi0=
Date: Thu, 26 Mar 2026 23:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kexin Sun <kexinsun@smail.nju.edu.cn>
Cc: kees@kernel.org, tony.luck@intel.com, gpiccoli@igalia.com,
 urezki@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 julia.lawall@inria.fr, xutong.ma@inria.fr, yunbolyu@smu.edu.sg,
 ratnadiraw@smu.edu.sg
Subject: Re: [PATCH] mm: vmalloc: update outdated comment for renamed
 vread()
Message-Id: <20260326233222.a74ea3c13fce2acfa1d37e37@linux-foundation.org>
In-Reply-To: <20260321105820.7134-1-kexinsun@smail.nju.edu.cn>
References: <20260321105820.7134-1-kexinsun@smail.nju.edu.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1kdummc7468aik4kwebe53dmtngae4fd
X-Rspamd-Queue-Id: 0195C4000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1774593144-347093
X-HE-Meta: U2FsdGVkX1/1OdG+Q0xLugJxo+1Sv368XVatB7uBDl4B6+ZE5i1/LFDjoGfLz0ZrYhWv2hJnBznui1dGEkoEZSmC/md5Evo+otLXO8DFbyvULQeDFb7GhXFOZwMI4OIVnJzs9Q999n5X7UBELkb9NqItic/vwcSzkDHfmukkPOWGj9bBW9OFVcLWdEmGOKOju/fX3y/r0IeEE21N5oj76x6TEtswSznb8jD/wNfhCLpPjKBYAtU6wOveIBu7AZP2/brnon6V6LtIEzm/dB5IHVDqMV5xBk9phrTIVzRbDYtFWLqgsn5UftoTEokSK3SD6fR/cBfDQmZHyu2HkHvkVUACsbJjkMAHIvOCUoJp2IUmyqewjC5rYAKK3E3u4Ua0eDnWu2MkHwl5Niu9ce9cmZRsxTk/GX5Sg5t2X/ArDQ2c51qegQV4I6MzWl7CkPU8Nil1X8D7rQFifv6xUssk2ghmOn8QEp4ecfj4cB4zIiM5qiq0J4qhJHz8usrq/hjlFHm/tebQ4rFrj0+VBWcq9ZSU+WPJivAZjp92/GzcXMp/NKT10Yb+yolEfiSwaD8Ir8NgOUh4fj8PtgiUN0EwzmpvEEOxYmqdlxrvCmBQPTo94O+ENYEtM1f7xnwgNRm7nvVR4ZOGqduysrGBjM6skDkn9hYHOOwB50cQ6Q4CYbMdNyw2ezMExlt+TdhOgO+o0+4cTDegZyPvXa9SMcQZuQiAzo+XuDi7y7BXd+xJBfdsSHx3ilErTujn2wVevt2kRKFkCHpDG44V6+y+UosGKl+wrE52RtMcoE7oVMwmfKUN3HMMeYHxY4jNJmB8YIKWAKMhOkwJIKES5l2mEko1Tj54W8RR5LUeTwQXdTzST3x2AFMrJOUrjPNw8HjFLQAN71Myx7fquGH66kjVSB0Bn6VWnSEQ0QXhp5GxGcYeycCw/KJRF73BDYEEDVKjJ41WG5OPStVmU4+iRfdeI6g
 Hx7ZdrQt
 FP+Q3P8Fg+E9OWt2gp35Pj/F9QliQcz1Wt587ZRCrztwNP2iijVWlKSelALctVzkrvMVNmmKAujHmZzuWPjMj+EqBQwj1KP7utJrxo6/fxytXE5QD7UzjVB2BU167SYxqBRy1o57ZYqMnNHkS9Bv28Gnl3R6ncBoN5+90/G0WvRJNQvojKGRzVRLjUB73ydmr7gAwJXuqgWtKRY1n7L9aQ7OVuy2dxeXczOJ3Jwg5ZTCVkjxKJhNozRKVMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 18:58:20 +0800 Kexin Sun <kexinsun@smail.nju.edu.cn> wrote:

> The function vread() was renamed to vread_iter() in commit
> 4c91c07c93bb ("mm: vmalloc: convert vread() to vread_iter()"),
> converting from a buffer-based to an iterator-based interface.
> 
> Update the kdoc of vread_iter() to reflect the new interface:
> replace references to @buf with @iter, drop the stale "kernel's
> buffer" requirement, and update the self-reference from vread()
> to vread_iter().
> 
> Also update the stale vread() reference in pstore's ram_core.c.
> 

LGTM, thanks.

> 
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index ed97494abf60..738283a85ea2 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -450,7 +450,7 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size,
>  		pages[i] = pfn_to_page(addr >> PAGE_SHIFT);
>  	}
>  	/*
> -	 * VM_IOREMAP used here to bypass this region during vread()
> +	 * VM_IOREMAP used here to bypass this region during vread_iter()
>  	 * and kmap_atomic() (i.e. kcore) to avoid __va() failures.
>  	 */
>  	vaddr = vmap(pages, page_count, VM_MAP | VM_IOREMAP, prot);
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..9ee256884f78 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4575,20 +4575,20 @@ static size_t vmap_ram_vread_iter(struct iov_iter *iter, const char *addr,
>   * @count:        number of bytes to be read.
>   *
>   * This function checks that addr is a valid vmalloc'ed area, and
> - * copy data from that area to a given buffer. If the given memory range
> + * copy data from that area to a given iterator. If the given memory range

I'll sneak-edit this to read "copies data".

>   * of [addr...addr+count) includes some valid address, data is copied to
> - * proper area of @buf. If there are memory holes, they'll be zero-filled.
> + * proper area of @iter. If there are memory holes, they'll be zero-filled.
>   * IOREMAP area is treated as memory hole and no copy is done.
>   *
>   * If [addr...addr+count) doesn't includes any intersects with alive
> - * vm_struct area, returns 0. @buf should be kernel's buffer.
> + * vm_struct area, returns 0.
>   *
> - * Note: In usual ops, vread() is never necessary because the caller
> + * Note: In usual ops, vread_iter() is never necessary because the caller
>   * should know vmalloc() area is valid and can use memcpy().
>   * This is for routines which have to access vmalloc area without
>   * any information, as /proc/kcore.
>   *
> - * Return: number of bytes for which addr and buf should be increased
> + * Return: number of bytes for which addr and iter should be advanced
>   * (same number as @count) or %0 if [addr...addr+count) doesn't
>   * include any intersection with valid vmalloc area
>   */

Things like `addr' and `count' should be `@addr' and `@count', but
that's a differnt patch.  And we probably make this mistake in a
zillion other places.


