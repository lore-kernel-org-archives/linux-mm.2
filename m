Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68783FDEE31
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936166B0088; Thu, 23 Apr 2026 13:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6CD6B008A; Thu, 23 Apr 2026 13:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCCA6B008C; Thu, 23 Apr 2026 13:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2F16B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:36:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 048C98B766
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:36:57 +0000 (UTC)
X-FDA: 84690526116.08.7C3C378
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 51ACC180010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:36:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0b1tYMt/";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776965816; a=rsa-sha256;
	cv=none;
	b=SPpcIRd+wTagoMcuFiwUutLRub4qKTbWT6rTRE5iuyulhChBRhdVUcEUg4XPn3ePbM+NK8
	RLxQwgViVx/t3IyhdShbA1jNTlqxKq35UlFbN9bZnZLKj58aRJJo8voSiOoxJ6iVQzLzaj
	7b3eKMVZqG3zD1p1l7J7g9BYUgZP6+I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0b1tYMt/";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776965816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1C2l+OcmYfnneeXpsJ2TY1+6owz0akX/v1aqf8NZ2rM=;
	b=OotExA8AeU/e5jVt3aF0locUDf9xKgGEgXAUFtKmVVOHiKJCnIINdKKUBD86f9IsJGpJX9
	s6xu8FM2XfnXRh+MstwVG/Nhe/K1QesB0SRmyAteS0rcdN/8e8Bm3KEFV8hXDlWFori44p
	TTZ5tvxEY4+eIJwI92isfTHiVKcqLsI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C3EF60181;
	Thu, 23 Apr 2026 17:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CECC2BCB2;
	Thu, 23 Apr 2026 17:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776965815;
	bh=aq2g+jZWsNZTJkO5FPtIHFH3eDsNeBvnwajJo5P/d58=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0b1tYMt/GK8QB4PkPymnjth2zN8Z7LqgiIWyLc+uhtf6zscCH+7qdas+u7xRLSNCf
	 vCitMdwlb8AKylRSZa00dVMdJxe8a/X4LLoqatsw9zJ3Lkchtcjitllj5U+VsdRLWH
	 o8p2v1PfaSn++f/kpFXY7c6WdQvHT8beO/NLVDTM=
Date: Thu, 23 Apr 2026 10:36:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shivamkalra98@zohomail.in
Cc: Shivam Kalra via B4 Relay
 <devnull+shivamkalra98.zohomail.in@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alice
 Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v11 1/5] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
Message-Id: <20260423103654.2b50501df33f9fd03d48eb34@linux-foundation.org>
In-Reply-To: <20260420-vmalloc-shrink-v11-1-cad80b00853a@zohomail.in>
References: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
	<20260420-vmalloc-shrink-v11-1-cad80b00853a@zohomail.in>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 51ACC180010
X-Stat-Signature: 3uaj5ufpj7yb977umjdoytgji1rs17h9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776965816-899278
X-HE-Meta: U2FsdGVkX18DMSqB8pU7bxR2vzYw2UvPCqJ6fMlSd0o8Jc5etXS23R1moIh/QUhWBzFJNrh8/ifJnUeUN4WxEJZDc3DkEoMU6wgYQz6QZlL+5RAM5k5h/5aIKbsrLCqE+u4r5O0lYOTRGcuatLBps6kQ2Q7LkegTw4uLNv9mpiaBxBWDaAAOpzJ6IA7jsU9t5mqlahm1ZGCr00sp2qCJzl72jFwk37rcGXTDQWWUkyFLg2bT0pBx6LdSiR/z35+ttiXSTRtcTywsPcgERPqpuHkuXnQh09vZofkcg3fVng2HQbuA7p6cHr66OcgboimqSxKn9AAWC7IYsjrhdQ0HXjBYSZc7T31FDg/OycDBoxILZj/U8RPpcq6HraawV3WxtCf/izwCKpvNYCbacbGmFZ6fUnXlheQ0BZEn6Xu5YnlSp56F0oKwLQMqpUJTBJR568rVsH+kQrvCdmDsutHGFG7HaIbfT6xs0GBX+bKzzMLTmnTjra5NCUzprCwVvz6xMVHX1Slb+Bs5h7e17JmZSw4VzLpYaiwDPwB6+OxlR9/tUysG5IKBEinIXEn2ReISQFOXHPBh6sWXtteGVeThaJ2JzwX+e5/Qi/CxOMgUQPm6e4L4n7po2Yj7BXFxuCnMykDPCnfOMxE9LD+HtLxJ9PKr+ebNyDmz4fBl+446VDE0QYz+fvDon927PyKjnwmubRSuoPmW4Z0cyL/JQnscxs5nfSNue/choqoTpunjn0sMeS7J/d+arkA6ZilOqQG5GLtDipBEoi8VmWz0KEFTHFHfRXzht73TPiP1kKos30hkl70/lZaAjanmrO1TKZpoUPmX9AEs96OFp7jpOtogEFuiPDfi9n3I+HKaAvILx20RFEiQAcgbHfRcuWjWScoxiJfxKU68KqNqtZDQMLz3wKadaC+a6w1a4KiuPBL5TWqMD01MchMuIsVR2rczmhiWpAcVTVSPtAg0HhzWk/i
 flm53tjn
 q8aJY60wk36ZfL7Z43tZPReWsHenxbbuQqTEoykC2wTE/xa2C6OeQdbGxTeyRIDtZ1F4Ea/GuFkWbvtbxu9IRllIwa7Ldc0gQy7+1CiqB86B5D/i4zzJTlxFXTOn18JtH+2aXG6PWMpqxycd88680zQwA9wHSfl95eig4vnnbyNwhRQu67c00PgJPgCbCXUCj9c65G3gRWbWnhgeV4EmmqRapdmHHWhBJcBCSxu1pLewvWr/uHjh5Wpfjsay0Os0nOVXZCNEqIKwSsXjNPTGL6qWe1vaaI6pReJKjEc3/PUWf64zko2kbicSP0T5yUV7s7aCC7d2SB7xV7qP56fEM7PRPCZvSeCSgcXOaJvicyRkbU4mnpLukxcX4cMMvigpmsiLuQg/zI0kyvbJ5dQPInNN6BMfsI2fvKthqBZTcAzmAPerWstyL7FQz7QvPGCJg4BPHwQndzNM0GI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 22:27:09 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:

> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Extract the page-freeing loop and NR_VMALLOC stat accounting from
> vfree() into a reusable vm_area_free_pages() helper. The helper operates
> on a range [start_idx, end_idx) of pages from a vm_struct, making it
> suitable for both full free (vfree) and partial free (upcoming vrealloc
> shrink).
> 
> Freed page pointers in vm->pages[] are set to NULL to prevent stale
> references when the vm_struct outlives the free (as in vrealloc shrink).
> 
> ...
>
>   * vfree - Release memory allocated by vmalloc()
>   * @addr:  Memory base address
> @@ -3436,7 +3468,6 @@ void vfree_atomic(const void *addr)
>  void vfree(const void *addr)
>  {
>  	struct vm_struct *vm;
> -	int i;
>  
>  	if (unlikely(in_interrupt())) {
>  		vfree_atomic(addr);
> @@ -3459,19 +3490,7 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	for (i = 0; i < vm->nr_pages; i++) {
> -		struct page *page = vm->pages[i];
> -
> -		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> -		__free_page(page);
> -		cond_resched();
> -	}
> +	vm_area_free_pages(vm, 0, vm->nr_pages);
>  	kvfree(vm->pages);
>  	kfree(vm);

Ryan's "vmalloc: optimize vfree with free_pages_bulk()" just altered
all of this.

Can you please redo this series against mm.git's mm-new branch?  I'll
be pushing that out later today.

Thanks.


