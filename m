Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AE4C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0D86B0096; Mon, 27 Jul 2026 09:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C80B6B00A7; Mon, 27 Jul 2026 09:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7E76B00AC; Mon, 27 Jul 2026 09:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 639B26B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:59:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC52F120736
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:59:13 +0000 (UTC)
X-FDA: 85034713386.21.46CDA8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3224414000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:59:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M9XJbpFC;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785160752;
	b=Ot4XoIWNE/2pBzHJtKggtdxD4rFF3Byt9x91igBcBkqwGOJtTdXbxtoqw3EFNClsXEFU1L
	HxVLtgJggHquNK7WJTAkt4x2+4C7gmVijoMFWNOi+irwJj7BX+dWxw/JTaD40jcOLan3z7
	+wnBiQspgCLw7gC77yWeyTxPfY2AUPs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M9XJbpFC;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785160752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlBgQOsYY3Xxvvlq49+FiktWgQqJ7DTK8k5w3thdHts=;
	b=ATw/Hgpm2z8wQQk8pdlj/ewZb8LFnikurzVrqwPF9V9u/8GCHyOCRrZlE3Z89FFYdYvcKZ
	NStwpkfivc7zuIpYVHwIDRxSJuB4xvLsw1nWFwRpsmHV0d7CS9la9ou8oWb8/TDhY4Hto+
	/pXbhvC8Cnny4spIy0k4z0z00qRheXo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01CB042A48;
	Mon, 27 Jul 2026 13:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B267B1F000E9;
	Mon, 27 Jul 2026 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785160750;
	bh=JlBgQOsYY3Xxvvlq49+FiktWgQqJ7DTK8k5w3thdHts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M9XJbpFCcrxvKse9y3y2Y1ZZfpoc+CfLvrENY7nJExy3diE04HwsOFe7YjjtERAyM
	 LYWdJRn/NH5sE9nvB1DVLYjJvBAtc+PiZDM0agroCQM5TkSpKlrvmof4LynhSy3xb8
	 QQKSP2QojAXo0JzkpNcGJUZTQ4KhCeKooQU+fUqRmgwGkoKCEAQmIAsIAnw/7OX++c
	 3wubRc6iKFxuTuYr/7XjX+hVgyFPpb6wHVWjpyCp0eqdgURgUW1V3Zm1FMAbTA17hv
	 gVt1es+9l6UtxbVFYO/9bifwKsts3nWs2lRoQhA1g4GgNSPRzmUU9ZwJn8Pk1h7CCj
	 Dh4C/lawW9LNQ==
Date: Mon, 27 Jul 2026 14:58:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org, 
	liam@infradead.org, lihongfu@kylinos.cn, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org
Subject: Re: [PATCH v2 2/2] mm: Extract non-swap page handling to
 do_non_swap_page()
Message-ID: <amdi9l29BkppMIit@lucifer>
References: <10c60511-c841-4bd8-aa5f-0d826b676533@kernel.org>
 <20260727121047.4140-1-hongfu.li@linux.dev>
 <cd6652a3-547a-47b9-8907-e98a582a238e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd6652a3-547a-47b9-8907-e98a582a238e@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3224414000A
X-Stat-Signature: ifexdgaf7abupwecmjbu1n5i6c8tyznx
X-Rspam-User: 
X-HE-Tag: 1785160751-110030
X-HE-Meta: U2FsdGVkX18IL4/J6MzHj9UVKxu6kmSUrzchKpEgEZov7b3oV7URXgouS5/JTsXyrssrPuJ//NAnCaUV91Rqbdo3/BGdbt1ZByA8kuZlPi1S3sUw7qXUjxHy9gxD8cRWntYqh4Q9Wgd6VuQy2qZaQOygaWfeeV8YGdLXgb/sVDW9toMSiOGdcWe6jL1L8tRmUZxJ0M6HH9Kz2zWRvsa/ftqicysBL/shY29GlfH0SuKlwYL57otTNuWo08m+v4GpHTZrT3Hq2gkqGKL4YMs7kvh827wwTYhTV5VkS5T1/p9RsXScDq6Hl2VABUPqm4ogWjNB0cHcrLrUgbR+cdB2tpeByryW+UKEXmzXfm9gV1ecTfRcyc/prY4brOmcrdV/7F6Ei0wiWby5juL8R2c0myrhTbQitHAYDA0Xlx/LzHc5PULgqIAG95/A21EuaZapECXWEE9bIEk9RNg3OVOzjonaVETnrN72vEMUA7bNRaf38Zaq5ogtm/VvcOLjWIBOo2BBUJWIDdrZ3UnNhCKJSSg8KZk9q/SXRDHAWY3ui9vTx0PK7P39zPUIc3qP74WTlY8UlAaZfeVFtHLYpXfFi2frb0i1DnzI0iZIWWnH8bvcwD5XH8YbHZ1IGOkMDdA1TZNuMOEbj4g5w5tUn7EMLOeN5Kp/VCIP311HsbGZLpdCMNO67vV7mDCE44vCvGltw8wtj0MtSUuElKue1LERaTDtLwWI99YroSCx+CpBphmo+8ZVrtMCGsoyPJN3Rz7bcxHN+8iatD3D1wT1YmhnfVl+DsKymRmzvXw0LBzYkj4/7shTkaHIVrFqD6PzcamoMsuXDlgBX6ihY5J0BtNnpELP6MGaOH9Jr5Xh9JpREQFx0qoE834AFD5XHamzF2i632q4z/vxiFaXSxdkz5gxmMMdyRbVtBAmUeGKAYRhPICSI5QKM8vmuq06GZk8nxsDItQtWVQbZWx5IyRANmE
 H5mTJpvs
 2teuhnbL+Cyr2HVF2K4/P7SqfFfVr4kLByzlo1h8wfhIcBrfWC+auD6EOdqB5iSUumduKnHkrqdT9AxXO0YkcjSPGe48U1i9wUaXgKx87U2pOJcWsh0oeAvSdq2+dbWGPPlrx00OBnxMaL0fARzKuQKxgATV+vgd/MRIaY3tdCreSZHNyJge2GNuvuC0lqbihc+sZ6isft9HGOi8B8aEdieReMWnGfddlHu+bHDeBebs1d2ZRVeUSeZnvFwoUHqFFI46oq9OTn48M/LSFIUPAL+eXecs+PUOtoyNjhndvi08ISts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:16:40PM +0200, David Hildenbrand (Arm) wrote:
> On 7/27/26 14:10, Hongfu Li wrote:
> >>>  mm/memory.c | 120 ++++++++++++++++++++++++++++++----------------------
> >>>  1 file changed, 69 insertions(+), 51 deletions(-)
> >>>
> >>> diff --git a/mm/memory.c b/mm/memory.c
> >>> index ae521baa8c84..50d8e92aef91 100644
> >>> --- a/mm/memory.c
> >>> +++ b/mm/memory.c
> >>> @@ -4815,6 +4815,74 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
> >>>  	} while (--nr_pages);
> >>>  }
> >>>
> >>> +static vm_fault_t do_non_swap_page(struct vm_fault *vmf)
> >>
> >> We're handling softleaf entries that are not swap entries.
> >>
> >> do_nonswap_softleaf() or sth like that would be better than talking about "page"
> >> if there is not even a page.
> >>
> >> But actually it should be the other way around:
> >>
> >> do_softleaf_entry() [currently do_swap_page]
> >>    ... non-swap entries
> >>    do_swap_entry()
> >>
> >> Or sth like that. Then, maybe in the future, we can just move do_swap_entry()
> >> out of memory.c
> >>
> >> So we're factoring the wrong thing out in this patch.
> >
> > Thank you very much for the detailed review, your analysis makes perfect sense to me.
> >
> > I'm glad to send out v3 shortly for your further review, with
> > do_non_swap_page renamed to do_nonswap_softleaf.
>
> Read again, that's not what I meant.

Yeah please do NOT introduce 'nonswap' we already had fun with the nonswap swap
entry before :)

Quoting David:

	do_softleaf_entry() [currently do_swap_page]
		... non-swap entries
		do_swap_entry()

Also, swap entries _are_ softleaf entries.

The whole point of the softleaf change/renaming was to differentiate page
table entries that are purely there for mapping stuff from the hardware's
point of view (non-present because nothing is mapped there, present if
mapping something) vs. something non-present because the entry is
software-defined (hence SOFT-leaf).

Swap entries are software-defined and thus fall into category.

You can see all of the softleaf types trivially in include/linux/leafops.h
in enum softleaf_type:

enum softleaf_type {
	/* Fundamental types. */
	SOFTLEAF_NONE,
	SOFTLEAF_SWAP,
	/* Migration types. */
	SOFTLEAF_MIGRATION_READ,
	SOFTLEAF_MIGRATION_READ_EXCLUSIVE,
	SOFTLEAF_MIGRATION_WRITE,
	/* Device types. */
	SOFTLEAF_DEVICE_PRIVATE_READ,
	SOFTLEAF_DEVICE_PRIVATE_WRITE,
	SOFTLEAF_DEVICE_EXCLUSIVE,
	/* H/W posion types. */
	SOFTLEAF_HWPOISON,
	/* Marker types. */
	SOFTLEAF_MARKER,
};

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

P.S. I do remember suggesting that you _slow down_ :) we are into the quiet
period now so let's maybe reduce the pace of series + respins, thanks.

