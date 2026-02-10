Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49636EB26E9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9CF6B0005; Tue, 10 Feb 2026 11:42:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597D16B0089; Tue, 10 Feb 2026 11:42:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479746B008A; Tue, 10 Feb 2026 11:42:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3813B6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:42:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C62C91405FA
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:42:27 +0000 (UTC)
X-FDA: 84429115134.21.EB631CE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3662940009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:42:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MmwFjtpI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+H8pOSBx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MmwFjtpI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+H8pOSBx;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770741745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USoLikAerZRv3MReWwa4j20dP6GBkJFN1kwtKunN8SI=;
	b=NeREuZ8IG93YIo5iMZ+i+d6PphK09i6j+P2bDp+0iJTE5+Xh8P794E2EzgcYksN2Xg9nlt
	96cqWgV5WtjS62kL06+7YzuRKCKMt+7GXBeT0nYbWVU2vRQXQSLr5OcX/+Lb0yedkjcjD0
	O2Js5eslBqi9X5ZUVdfz7qlZiyVi774=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MmwFjtpI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+H8pOSBx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MmwFjtpI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+H8pOSBx;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770741745; a=rsa-sha256;
	cv=none;
	b=YT5F17nVua23Js/DSNtNxIBZ0PcRk5p8pZqiodHIFibLZSkWtxejVqwaGS0/pf9mnku+ci
	WD0nG+oJgxsfwDFAvfmGCubCjVo7/dtGPxwjLWA8g8DR+8rkmtUsU5Nev+j1ngfCybdp6L
	nctY3wKRJbmEw0MJ5yzHrM2/1JihuTo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F86B5BD6B;
	Tue, 10 Feb 2026 16:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770741743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=USoLikAerZRv3MReWwa4j20dP6GBkJFN1kwtKunN8SI=;
	b=MmwFjtpIPDEIl2vxov+/gYVl1xz901bss+y63s52uS9ZEiemSCpJyMnWXpj5g9VLNPMgtk
	ZEs3zirJHjWbzIpNfsXgO9OW/jBFJxXPRZFI+h25xTm6L7pd8BIrd9jtzKZPcNEcqTXjJe
	9ZgU4wobjoYtwJTMdvP/4Yu7aF3+DMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770741743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=USoLikAerZRv3MReWwa4j20dP6GBkJFN1kwtKunN8SI=;
	b=+H8pOSBxdHMKysWrhnAQxA76eY15Rl1pmx6/8SmrTh316iQS7Uag/YuGQkpJAbGfT1YW9f
	8oCPEBWI8bqyFcAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770741743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=USoLikAerZRv3MReWwa4j20dP6GBkJFN1kwtKunN8SI=;
	b=MmwFjtpIPDEIl2vxov+/gYVl1xz901bss+y63s52uS9ZEiemSCpJyMnWXpj5g9VLNPMgtk
	ZEs3zirJHjWbzIpNfsXgO9OW/jBFJxXPRZFI+h25xTm6L7pd8BIrd9jtzKZPcNEcqTXjJe
	9ZgU4wobjoYtwJTMdvP/4Yu7aF3+DMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770741743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=USoLikAerZRv3MReWwa4j20dP6GBkJFN1kwtKunN8SI=;
	b=+H8pOSBxdHMKysWrhnAQxA76eY15Rl1pmx6/8SmrTh316iQS7Uag/YuGQkpJAbGfT1YW9f
	8oCPEBWI8bqyFcAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9F393EA62;
	Tue, 10 Feb 2026 16:42:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g5F6M+5fi2k6XQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 16:42:22 +0000
Message-ID: <3a5ef8c7-3a75-4014-b565-540af09f7d06@suse.cz>
Date: Tue, 10 Feb 2026 17:42:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 15/17] mm: Remove the branch from compound_head()
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-16-kas@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260202155634.650837-16-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3662940009
X-Stat-Signature: dsbmsnnzwm6ik5u5jntiknrgnf57y4og
X-Rspam-User: 
X-HE-Tag: 1770741744-710272
X-HE-Meta: U2FsdGVkX18n3ZXZ70EUcYHK6Cy3auXTbmf2RwacN0MjCMf2PA68T8TyFv5bw1VTp9nk049eKWpDzfN6Reuh7slW4Rb468VHPURv9O++mrDIfNiOQidxZnYbvM0cSAWdkrBhw7BEh+LSorOibttA8vfQtFG6y8Fzs6RiE4lyEln8NjfDqPxfJLKbGl7Yt4iQZ6cRHLD7wz93p0UM+brTMieBlVggY2NJgzVOEDMwqT0LCxplFa1HbgrIjrV/0DmZGeIbuNmVk0zZGvULuql38+xpYa1Mb6woO4SDRQ/FCl7SrByyQrf2e3nA1kyZb9q32Gv4SUtC53qAI07n7Ar0J1o4pKR5ewSaWnu1AX6cVgtga8gT4MC9WjyLBUVaEUxbmW7gAQJjfkVq/IBtS2biYDfxjBVbuiV+Nr0OZ5l1gIcZMYLh41fuIuQFE2TJD1U/Hay5NHepm0ubWfnEqJrCDKA1pxAX7AcPS6vaea7KXr82ynhg5hnVvpwGFNAyl67Hd2GqfMdTv9xzNdnl+Yi8YcRSa2RwGh6z6U2nTrHeKUPxONXfSNBL08hz6/tgBFFqce0lQ7qOSzSNSaRtoeL83hZCrvOkmLfuTIjVifIicn1iBSXybhGK38BVX2Pu2r84JqxWn5sb6L2F3TJK1Vf1DPRk/WARb7duZJ7R8DXDIJOkRgBTjEqh8nyjLPZBXzzQdmLLvq2Op6zI7v+bQcxrM+dmYca5IsDawr+SmqKUqzlnF5pIRtNQ6fVEwkoyZWo8wU0bUFj8ihraWaxRr3Wx9Wf1L2B588SfsTwL67nNxbcyDQ+mzxhkjCkRT/XKWRULM74QgFu5Yoq0wP2Dt4teHb6K98Q+U5KG7q0IU2KkE11vh/2+odlv18eRR4/nQGSKLFwgP3oDUHYmscpdfTVNtYpA79dPKgolF95TUQz+GBhw4THsrsVTlfTe7CAFzVPvYouhf7v4F9yz61q3vsJ
 CY9LkmAH
 45OfcAEi4Nah3/P328GXTVl4Lk/6BAEsCE/Gq/urRMrb5JLfpOU0CRBlW4zPxMyFUCSeK+L2iHRklg2/F+eKIksSGo4h3NeILyskCu5nVNkyN1knNfUIX9FgqVd8MlQpJxwuWwAAPHpE/7GSAYaW4DM7XGZwu8AjMswk0y1cTP9MXOgT6qwj80aUT3nqXgPFjb+UIAwiWkZ9DVgtlUovcfHquggKTRNctm9zL/d8W0LZuQ8P44WGyzYRTfWQF908RAICb0K26q20a1lZxg14siHzv45JOH9JQ8mtK60E5RFuDpuCXOYNR8UIKwYH5y9evv9GZKDkFF5DWfLdpHwi+S/tUiXQOuR6CU8WV6YZP04HPbSX6XviSXH1lt5UTW1EVTC4C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> The compound_head() function is a hot path. For example, the zap path
> calls it for every leaf page table entry.
> 
> Rewrite the helper function in a branchless manner to eliminate the risk
> of CPU branch misprediction.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


