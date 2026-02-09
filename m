Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF3AE7E0C3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 11:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806866B0005; Mon,  9 Feb 2026 06:11:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4BA6B0088; Mon,  9 Feb 2026 06:11:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C3E6B0089; Mon,  9 Feb 2026 06:11:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53DE76B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1895140773
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:11:34 +0000 (UTC)
X-FDA: 84424652508.23.C51AB8E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F0A92000E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:11:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NyVcXt2o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9qYrvHqP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NyVcXt2o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9qYrvHqP;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770635492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8qLFZbNZpSrx4c68k5jQfZ+EN35t8S+8YIiD1pqagE=;
	b=zkmmv/ryqEhRyzCW7go0UyO9KX8f0ZOVh6dycf7znCrjm257tHn4JpUznUcYWUWH8YXWir
	q77hMDadyjRHizAOT2XGN2/ij3rm7ZIVUJwmNQ/lcQhcFXDdDPWPKcw1Dl+1c4r0E/3ztn
	E+aH1lEP/rT6vUJWvMw9T5FErncbfVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770635492; a=rsa-sha256;
	cv=none;
	b=maNV5LQetrFQVA4RaEjn83jP/pk+9ahb9yV0OTpHsrnuTiLsCefnJNs2Ab2bovWt/qr2KU
	NWChghkNxzk/6elAGPEp0zEG8nUHbe4EOBQpD9WyKQHFsesd3wfgKADrAlkEQ7Jl0aq3D1
	P1jqk2SpTLMv8H1sr81Yc0lj69PeQDY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NyVcXt2o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9qYrvHqP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NyVcXt2o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9qYrvHqP;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A19F43E6F2;
	Mon,  9 Feb 2026 11:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770635490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=t8qLFZbNZpSrx4c68k5jQfZ+EN35t8S+8YIiD1pqagE=;
	b=NyVcXt2ocC1CVQAT2MPh2t32BXjCv7vkaP3a0lu3iDhzxYu/z2h3IG7qianf+MrpON5MXE
	TcW8J5gfMgI1dkXFWaAXM7ZbY82FY3HXcAXm2p4UoAubsqjHUbTr7cFnewm5AECj9OGmoZ
	+xdWcEyC3sP2MMiBBp0IUeaWgoMKCf4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770635490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=t8qLFZbNZpSrx4c68k5jQfZ+EN35t8S+8YIiD1pqagE=;
	b=9qYrvHqPlk3lkMfiMYtY7WmM5BFDggncyDFM6w9yLq2+8cw2wAcFKFiPxFSp2ov8WpNjlE
	MO6BDDkcPrGDXYAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770635490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=t8qLFZbNZpSrx4c68k5jQfZ+EN35t8S+8YIiD1pqagE=;
	b=NyVcXt2ocC1CVQAT2MPh2t32BXjCv7vkaP3a0lu3iDhzxYu/z2h3IG7qianf+MrpON5MXE
	TcW8J5gfMgI1dkXFWaAXM7ZbY82FY3HXcAXm2p4UoAubsqjHUbTr7cFnewm5AECj9OGmoZ
	+xdWcEyC3sP2MMiBBp0IUeaWgoMKCf4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770635490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=t8qLFZbNZpSrx4c68k5jQfZ+EN35t8S+8YIiD1pqagE=;
	b=9qYrvHqPlk3lkMfiMYtY7WmM5BFDggncyDFM6w9yLq2+8cw2wAcFKFiPxFSp2ov8WpNjlE
	MO6BDDkcPrGDXYAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B7393EA63;
	Mon,  9 Feb 2026 11:11:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wlXuFOLAiWlPSgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 09 Feb 2026 11:11:30 +0000
Message-ID: <dc4c016c-90e7-4e60-a73a-a2515ad2f6e8@suse.cz>
Date: Mon, 9 Feb 2026 12:11:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: clear page->private in
 free_pages_prepare()
Content-Language: en-US
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
 hughd@google.com, ryncsn@gmail.com, ziy@nvidia.com, stable@vger.kernel.org
References: <17A126A7-BACA-49E5-8A89-F8E665981136@nvidia.com>
 <20260207153716.59302-1-mikhail.v.gavrilov@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <20260207153716.59302-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6F0A92000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4knnzpsi6agpddu8a764n16hetin4cis
X-HE-Tag: 1770635492-551487
X-HE-Meta: U2FsdGVkX1/jMsY70D+del3MkwOmIucrj6VH6jfCroFP/f57+3n2JWEJGhj/sRfyyMi1PVwUo0LpktnbkftKte1fAm6/KxOkn+pg1swvReIjwJ8rMWUuUq9p9BeIiOGfs5EZvIsbfUBcddBOcecQp/1BnO4JCMPv7DcFVc2Jy1ZsmwvXI0aRa3dzuZQv84nVv8pIK7nEXQ+eTh8ruNLKS28ZWlblk33SWtrZOGfTjHDJnaGikZ8RtK2ZjXW/gvO4GqYU0nBbDNjSXZA92CegeCqsFGKB76p7fzKAj7zDp6H2of7TJ7vgSaLFUULkT7xM9rHqKXL3cuJqgk2uOqGr3oYrcSBSOokf5B7P1a5DGEhsLUY0PeKy4owplXtBcl2aVMjgviCYUqNmJyKVN7Iow2AcU90BCx1VHeZ60pcYF3oQUdfTz4uBN4DhExoexZ+b3V1BQfXyNdYTJS/HqWLciOQtsdHL6Yx7CHG/5tufFHdQAFgtJqmMXkpmD50zKK8YFQCQmeOM7ZSIajOQ+M2cTuzYsI8wekypV+SwSlSlaM8paEWfuINNsXtuTubtNBHRGr2BfjLmv5NbSDMOLv/TO7eSw7Loc8AB5xh0rNfT7lslUdRrgz/HMgQxuTDMnXh1OAz+CSxhPf4DFIONYXNJuL4ClbQhQypCgE4OIWf8U2+MwrPR6lutlil0QAzXf/ZidoEASwUdTpctiRDDMnc7h8qyBin2mgaxwD4QLj5AGyRJKGuAGCCRY8fvwQK4pro1YHeQrNKNuG8w9Z06NcQ5sawY3Teeyhk649LD2jZ78+g2wfGIcyeTKUKiajGY73ZkmCxNSA5jc5i8dKa6G9HBszdP/OgifeJQ8i4iC2XsB7cTQ3sck1UL7GE+s/D07E404UmS+8GhAo290XSbwDty1sljcgfBFRC9yqz+k+jNC7mN0zJtEmbiHxrggb287E3srXio2JiSiv2plq0bPbu
 G/tmHRH5
 ndcLWlTWTPi/aEITUpHjb+c7yp42qhTD8iI3puE0c27PHH8gpsFJXq2lHJNFCNpWB3idWYD5XDZu/Ht23DnZgTp3tV6Er1afzUmLxx+Peg4rzQtZCOQV/HNN9vrVcF28q6zRt+vq4YMQ/M06gAuzbWHDzmj3tzFT5Rg6wfVOT3pjm0vkR3wwiILiunJT/DyGH7+y2PJyH38WAO5Pe9aq7W503tXZH9wBQwJF+FpTeWio5KCj25LB0nRr9EZDZtsnfahmkbpkfA4nZumMLOULz4mnppN+lbQQkA0MNH8p+QKRl8EVqeSap02qRb2Vhr7aNlC6Yx3+rJCvgA6jx5nVQXSSVRfy9d9NP8smnxA3PfDC4O5Av5pmKRmueNRkul3HYs9Tzyeo4YslJ8omgHJWrlSlQI3KS5Zujj51IT2SV6EHsF1tA4pEiQFbfG+0H1s278LknS4p+8MnfXkilXq8bBXHmaqEGvKdwFV9a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/7/26 16:37, Mikhail Gavrilov wrote:
> Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
> clear it before freeing pages. When these pages are later allocated as
> high-order pages and split via split_page(), tail pages retain stale
> page->private values.
> 
> This causes a use-after-free in the swap subsystem. The swap code uses
> page->private to track swap count continuations, assuming freshly
> allocated pages have page->private == 0. When stale values are present,
> swap_count_continued() incorrectly assumes the continuation list is valid
> and iterates over uninitialized page->lru containing LIST_POISON values,
> causing a crash:
> 
>   KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
>   RIP: 0010:__do_sys_swapoff+0x1151/0x1860
> 
> Fix this by clearing page->private in free_pages_prepare(), ensuring all
> freed pages have clean state regardless of previous use.
> 
> Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
> Cc: stable@vger.kernel.org
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

Seems cheap enough and robust to just do it. Could be different for tail
pages (although we do modify them too anyway).

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cbf758e27aa2..24ac34199f95 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1430,6 +1430,7 @@ __always_inline bool free_pages_prepare(struct page *page,
>  
>  	page_cpupid_reset_last(page);
>  	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +	page->private = 0;
>  	reset_page_owner(page, order);
>  	page_table_check_free(page, order);
>  	pgalloc_tag_sub(page, 1 << order);


