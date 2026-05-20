Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C6D2CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8586B0005; Wed, 20 May 2026 08:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9788A6B0088; Wed, 20 May 2026 08:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867726B008C; Wed, 20 May 2026 08:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8296B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:15:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3761A1C0F01
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:15:25 +0000 (UTC)
X-FDA: 84787693410.21.5AE19EF
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 506F920018
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:15:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CxR4mGr/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779279323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lpVD7PvJ3yLAhhJddRj1iqDdwuhUY+Ubp+n7mSO2yuo=;
	b=GlMMTGxbFQRh7AzNDNqha85j8Wu2AK3dsxATZM5V1R81oM7Qj42IrNj+8nwaOttr6crHRx
	WxGdiHryHFI+NlM4f5NJmkWmyoVxfHi4w+QNSA7v8gA3cEkVeG32vOGevcsEUYyyQiaL77
	KoP/0YvTlvB3FPKH7tBisLBivuDIAGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779279323; a=rsa-sha256;
	cv=none;
	b=G1vIsJ9+/OLFJcttGpd9CX5JHolEV2egIwSd5D9Ost8cFzFobO+koqBH0HNvCjMK9OVzLm
	ECZhXZMkAfauAaSq11v5bTinm7VZ0oM1nID0tmqmiZYkat2XO/QO5EJScHHyY06U57zQd8
	zpD0awA6UfOBIGElhnn7pyC6Kh+FvyU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CxR4mGr/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779279320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lpVD7PvJ3yLAhhJddRj1iqDdwuhUY+Ubp+n7mSO2yuo=;
	b=CxR4mGr/kbCFb8VOKtUL9MJeH5OxsnTYvxgXmVOSe0Z9v82ZfRdNB3x4IjDWyCRj/mcar0
	2MlOZFVwz6UAb24nlbVSQvG8zVgEBTUcHXyjchJ9+S+e3On01dfRhOwahPNI2CzLOC+eU2
	2RM45/OVYi7NgcXDE3Ms3iA9ru4uu3M=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: osalvador@suse.de,
	davem@davemloft.net,
	andreas@gaisler.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 4/8] mm/bootmem_info: remove call to kmemleak_free_part_phys()
Date: Wed, 20 May 2026 20:15:05 +0800
Message-Id: <20260520121505.60854-1-lance.yang@linux.dev>
In-Reply-To: <b2a8e918-7ed2-46b4-bf59-e65dc9359310@kernel.org>
References: <b2a8e918-7ed2-46b4-bf59-e65dc9359310@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 506F920018
X-Rspamd-Server: rspam04
X-Stat-Signature: muos7hdciymscj8bgmfsj765wqrtyi1b
X-HE-Tag: 1779279323-206287
X-HE-Meta: U2FsdGVkX1+JLAYicoXAgb34RI+TTKuwSPzgL3XHzwQjEG99x7hKipNZ/0t3Ksj4YamEQyM8ziqEO226qEV//rf7QoC176zAGsnSCM286QqHAr8eVoVdlalEXec2SnmgKAfZ3sa4jznsDZC3gaPJY7r8Wiuy1GbS0TDzN618VAnCOqQhOHwuQU88xvobwxe9MygHxbkIaMaWKz4L0iNf/nW4/oi3EWNiPTHNuCP4B3GIfJhdLUAWNeGl1uRo/QyWqtitmrCwCkmfQWP1i9jnXsc9XOnr4K1BlDULiv/YFyPU3Ug1zfw9dKN3JVT4FhRSJMfSElzf/UMAgPvm1WmHw35ZKRCzyGeFaw43BeqHLw4bzKui3atLsoPLp21i9QMclO/Cet/O8yUrCkDWthRybsQg76DaxgE65OM6Hn6/rTN29qy24PFitJyUgX2aAneUsIloJ3mE0AnjLV4tL9JodXFboVxzgQnjbmYxeCNnRqXqUP9yt3oQWi7NDNLAdsy+LS3j3ElVvv+4URB6yJOPHsH1aEG3Yc4qxFQ/rlizMjUUByEm4xGK53Jq7dYAXI991YUisi8/H4Apiy/dMbgkxU/5jbvt40KkUPhCEa/t2gKFc49C/z3f/ALO2d0tF9QtZaOg1QsLMNZuVvt9ujihK1dkOPU+n45diYYQq4hAluG7GCr60/RqiBr14Rfb52eWxGzzp49PfegH+2CisnVBZ6aSlXAd7UaSrL3IVmW0844Yq1NgLgB1r2/DAKbtMjCacnMYplYQ82XWaJus0m1A6kxAWmukIWpfxdhUllBnyKGRJELAzNetLU2+piJA1vHZc3whb1sPeGnkxYHDIz+LbCLEukWqlvvsh+34jh49BCDrMqe5qOTErU2kBcXST1KqXh5EyhNFCrbObaRlHsOgJiFB/K3FwIhZiswaKbmVM9eRe3JwRfO1sfzd6uoaAvR9VlVvm7MOvDIpYXru0v1
 3h2KHOBU
 qrEVn3sr+R9dT2oDAbB6f0dwdW4llpaSGKqOwYF8DhQu+kl2qLajpwAcbSrCZ8tz518h3CVgLmzANFIbkUmTHtrh/o0bNZZR2xAlQFpR/BTSsWb+yZzzT0pkvDhtYzgiDpGAEdgE+5XFG2J/ARTwrVpqTesFg73kxMwAb2bKLkEDJwedBqNxa+fWkqKKAIB+ocpKEDw0xgn79VVKTe0awwVEhbjBXfAGALltpnU9WJyoHdUmTaPWKQ4p2Ts0hFP/e4NwK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, May 12, 2026 at 10:45:03AM +0200, David Hildenbrand (Arm) wrote:
>On 5/12/26 10:34, Oscar Salvador wrote:
[...]
>>> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
>>> index 6e2aaab3dca9..74c1116626c8 100644
>>> --- a/mm/bootmem_info.c
>>> +++ b/mm/bootmem_info.c
>>> @@ -32,7 +32,6 @@ void put_page_bootmem(struct page *page)
>>>  
>>>  	if (page_ref_dec_return(page) == 1) {
>>>  		set_page_private(page, 0);
>>> -		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
>> 
>> A bit odd that kmemleak_free_part_phys() did not complain if we never
>> did kmemleak_alloc_phys() for these pages?
>
>delete_object_part() calls __find_and_remove_object() and essentially just skips
>if it didn't find anything.
>
>Maybe the kmemleak_warn() would trigger, but it's guarded by "#ifdef DEBUG" ...

Right! With kmemleak DEBUG enabled, kmemleak_free_part_phys() does warns
whenever delete_object_part() cannot find the corresponding physical
object ...

Before this patch, booting with:

"kmemleak=on hugetlb_free_vmemmap=on default_hugepagesz=2M hugepagesz=2M hugepages=512"

I got a lot of warnings, something like:

[   44.481883] kmemleak: Partially freeing unknown object at 0x2acc59000 (size 4096)
[   44.482754] CPU: 2 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.1.0-rc3 #206 PREEMPT(full)
[   44.482758] Hardware name: Red Hat KVM, BIOS 1.11.0-2.el7 04/01/2014
[   44.482760] Call Trace:
[   44.482762]  <TASK>
[   44.482764]  dump_stack_lvl+0x60/0x90
[   44.482769]  dump_stack+0x14/0x1a
[   44.482774]  delete_object_part.cold+0x28/0x2d
[   44.482779]  kmemleak_free_part_phys+0x67/0x80
[   44.482783]  put_page_bootmem+0xc0/0x100
[   44.482787]  free_vmemmap_page_list+0x13e/0x230
[   44.482791]  __hugetlb_vmemmap_optimize_folios+0x351/0x430
[...]

So, yeah, looks like these calls are trying to free physical kmemleak
objects that are no longer tracked after memmap_alloc() started using
MEMBLOCK_ALLOC_NOLEAKTRACE :)

With this patch applied, those stale calls are gone, and so are the
warnings :P

Tested-by: Lance Yang <lance.yang@linux.dev>

