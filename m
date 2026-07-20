Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE86C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B32F6B0095; Mon, 20 Jul 2026 04:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B466B0096; Mon, 20 Jul 2026 04:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1536B0098; Mon, 20 Jul 2026 04:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFE3B6B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:20:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BF2C1A078E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:20:21 +0000 (UTC)
X-FDA: 85008457842.01.E9BF8A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4C33180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:20:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwhdPR1s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784535619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzbgMbb/C78JO4vjePFx+V+5HdD6Ov2TmuXxqHSNuU4=;
	b=YTenWBwuG1+nAoa3+/YPCm1/AHjaA6YN4R0h8UPurYEy3Qz2agxdBtn4Z+WsDALlVD+2rP
	JEfIVW8oFysEHXFz8QW+g/ZMfoZmDbkTkxe1CK7vaLI1QLWcvYlAcLyCDQ3dJ/UIOrCCiV
	CJv9p7rHvWcqlSHsiyQjRvo4GrALjq4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwhdPR1s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784535619;
	b=vu5VzsC9VDVyDOGNTRxRhIBvO0VG7htBfrk08L36MnwINj9fWGTqycIgcgGXfj37mVK8nc
	TUsls1nFQk+5FauUgh8EVaQ0K0hoLiK5D9pK427upBP2w+P+ov47jiKmIXXPe0eljgwnkc
	sdLiMVdHYFk0xrQniGO0oyH8HySfWFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B35A41A42;
	Mon, 20 Jul 2026 08:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F02C1F00A3A;
	Mon, 20 Jul 2026 08:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784535618;
	bh=tzbgMbb/C78JO4vjePFx+V+5HdD6Ov2TmuXxqHSNuU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NwhdPR1sQ3ZoUnZlrIxUVrKB75sTS+u5BMLJYzTiw8DHZLnHa149ZeMmIPmpVxslx
	 d0Glgm3v9q1C2jpHLfQcgOht5t39wgfNIE9OLdWSzM38uFv6jcgqpEK7IlT971atxk
	 H5x3YcxK8pPCbJe51ZHiK4uUZSuvD/qoMvz+tZwdFCg/bCjVwamuT4kw8AF+qu3Twz
	 dQqmpu2r4wbENxBUI0pQSUYaVSVefcYvjVQehOjuzNHVMgpYD2vn2iOUU/e7hA+BGT
	 2W/hIf7OK7MdyBSc8oveB5qyRAwEW0oWQWU7Ag5VD6TXeinGZfZianBCBhdJ7XvFNs
	 l9ZAuUKP4cHCQ==
Message-ID: <5dbd012e-52cd-40cf-b9af-59787e2832b8@kernel.org>
Date: Mon, 20 Jul 2026 09:20:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/memory: batch set uffd-wp markers during
 zapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org
Cc: kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, riel@surriel.com, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260720065508.2695106-1-dev.jain@arm.com>
 <20260720065508.2695106-3-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260720065508.2695106-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B4C33180003
X-Stat-Signature: 1uxe5uqhanymdq3ck3aocfoid3b7ooen
X-Rspam-User: 
X-HE-Tag: 1784535619-323978
X-HE-Meta: U2FsdGVkX1+6WZg+W25feljQx6cq64yi16jLmLj3eVZAc9CyZfQB4b4DwIe6fZvPtOC05IQYCB8lQN0b0the9mgK7McmUiLCnPeYNem6T64HUf4wfxp32Ne1DMXcWC3e3DIsapvdctL/XEaD5kkjcK1nrDH0GW4fyLQ6Y9o04itngI5avB43RB0ttRIvZBgBCjOSP40U2ljYooHeB/VMgS8Cb9aOmzaO6jU6+H8fy55gQsMfY8T9msJl1XMmoVmjCnctV6JoEJySzLvZaGQgJNelH63mL/2yhXFLKwkj4ISPV7coUIZ+cd89esu5h43JeqCyzTVCHOe6MQrTVusFcV6rCve/W5HR9P6SQEH6mF+DhaOP2z/5Cg9ilDMkj//tJKphwxB6NgnENdfeSF/duGuho4hEGV8TLlAR15wPnTfgWMmezwC2M/Mi1d4sOlh4viBHHZBbFSmIy66zsrFVqzTayEA0LKy0zeb+IDyiPJJ/668B77l5YSjS/i7mb/41BxTl1Rg6qE8Fq5qWORqZLU37s8TPot8OkiSH+TTVsVqbRBQ/S7a1Yy5sYy9gW2JbnocEq/KWECgt9Q4g2flm5G1P5b1qz68uZHLU7/VOSRASrbVX//Ee01aI5XM0vtu2bT7IypfM/OuOWFF7W0SG+E2Eq3RXtgHxzXnu/BCTgcBpRRnkbuyr9WuyNsbU0WWnXn0aUeiGvF23Tit3AFq2E+vNicm13j94s9CmfV/jaOjVmUCh4rAzs152gsGi0wLsfXFjHnZkysdyiGX503czmowRdP58hRWiE07hbRbFxqQjHHxPMnoFkdO+OvpBs+V2yrU6SLQ1mRx0uhc9wx77wKZaRwemly5KPhCnpjHFXdJ08hXVRJwkAswjdG2FezBk9o/GplE2R0Y4Bc0AvvmGwdw5P64OlSx934UV1ZDGA71R3EixPG3RTfVGWeviscbJSTjmfQ9vE7YxvuZBFlE
 oVaASBoL
 GgoDgP1qezIdT7pJSt5RSRz//rAAh0Zk997WEHs5xcCrI5WV89JhtW0Y2mK+/BSjGXUoCNFk65iDILrc9iUlDLRKtmCsKRGM5UMVVzqi3xZPEW5Z5Y1cGAscDpilU5SVUzCqu5/7oLiRNCt+KMVfLmsnp4hG4xm4V75Q47geO4uJJz+XeZZRO1r2HE8C42Bzk0wKPz7d86NtXmEimAsYAx/rpa7baardALq5YDGDCP+BkTr3rsziywFLuwVRmHaN+Fhh827KNE7nj9r0mp+2myEIC/hD+IZmpKZRnoohw+Zx56ZnZT9ACLqj473Yq8prL7U9BrSi6CHvRE4xUEAlThdfqbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 07:55, Dev Jain wrote:
> Enable batch setting of uffd-wp PTE markers.
> 
> The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
> that nr through either folio_pte_batch() or swap_pte_batch(), therefore
> batching is correct:
> 
> 1) All PTEs belong to the same type of VMA: anonymous or non-anonymous,
>    wp-armed or non-wp-armed.
> 
> 2) All PTEs are either marked with uffd-wp or not marked with uffd-wp;
>    the same applies to the pte_swp_uffd_any() check.
> 
> 3) uffd_supports_wp_marker() is independent of the function parameters.
> 
> Use set_pte_at() in a loop instead of set_ptes(), because set_ptes()
> cannot handle nonpresent to nonpresent conversion for nr_pages > 1.
> 
> Rename the helper to cond_install_uffd_wp_ptes().
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

