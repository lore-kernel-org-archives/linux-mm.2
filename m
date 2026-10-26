Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE7CA606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAokXhrI
Received: by kanga.kvack.org (Postfix)
	id 1FB606B05BF; Mon, 26 Oct 2026 06:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2B96B05C0; Mon, 26 Oct 2026 06:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C29C6B05C1; Mon, 26 Oct 2026 06:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E024E6B05BF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:38:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76475120770
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:38:52 +0000 (UTC)
X-FDA: 85364429304.04.85908A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9CD0F2000C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:38:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAokXhrI;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793011130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BLhE6A843KDT8+y0mtaljR3lPY00tdB/4nQapDfY8E=;
	b=i8D9ahzNs51HHlxOQqLOgg+QzhmWsw+ja0W4m53Nw27HEuZuuRKVU3EnxNxL8Ihk9Ab6p6
	lwe52IgfbWYkYmLrBzPlMbKrtPNKzK89ihL2rnwyFhenHuNuOKSL3dkCuZb4AHQnf0T2H/
	oBcXcnj2JX8kHXfLlKQjsln44bANu38=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAokXhrI;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793011130;
	b=zdQLRaox21KV1mfNWRlJm284Yaaj35rEqiG/rYXeQpFOcg3dhbwEZKKD8YuEUb78OWurEW
	fSXDfEY/Drl/EFrI9n3ll8JeLbxjHxLhWCALgr3bY2vo1Pj0zMwiMQgVbdM6TDVJRPd9g9
	CU1EJGeJs6q8nfYF52xJIaC+cmqaPAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBCEA43E6E;
	Mon, 26 Oct 2026 10:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431F41F01825;
	Mon, 26 Oct 2026 10:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793011129;
	bh=/BLhE6A843KDT8+y0mtaljR3lPY00tdB/4nQapDfY8E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DAokXhrI31jxzYuScbo35XEhEcxr79cZ8kAnkbToxT9/ue8/BqmP4QcZTyIgwFr4s
	 WrQDTnU4Z7PLHHPOo7V1mQ9uEoB0nciISo4EFJJ5JwATLvAz8R+NJCvNCfvC07PDBK
	 Row6ghd03Z7AzOD7m5dxYks0nXQoMHfyZL5kIGiP4JtbjhQMcMmgHLMAEOFv0w2VQ2
	 pPcjKjSp7tIivkSDIrkJG8v1k3EurLoxIGf2HGUR4RdOMB2QPDN+XQ3T4jdZifymE2
	 SKGIZPqarIgIR9sUUWwS9qu2oz3PnM/GKk3Ufmwg/dbFuX2cftxjpQh2XPrlUlhZZD
	 oksob1U8ckOHw==
Message-ID: <103481d2-f75a-4982-b9a1-3592cda8267a@kernel.org>
Date: Mon, 26 Oct 2026 11:38:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: generalize PUD page table allocation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Arnd Bergmann <arnd@arndb.de>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-mm@kvack.org,
 linux-arch@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261014035910.687847-1-songmuchun@bytedance.com>
 <20261014035910.687847-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261014035910.687847-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CD0F2000C
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: go3rij8p6ns4agwuhrb7thxj8fopwbhp
X-HE-Tag: 1793011130-229445
X-HE-Meta: U2FsdGVkX1+9Lcc+LiFkn1Rbs5Lz5i1+iDESBTRpvaG6yPI3GaiGhPl7yqtY9VnUnDLd1dM+fiBlHmXXRKWnIukKoz0NVJOpbuWTgXtMGseyJOKicziCHELZ0fAyERABAgXb+MTO2bvlKGcad24A6a8F7eu8qMpyBrrGKH23qVm37A2PsazFb9zQBnKEqkPF1jqHRc/HAIwFd8XV5B1O2/wULpraYl5WZDUojlrl9a+tqrNrT+loRXJ1zlnhMG8dPM9fY9kvUCe+CjGyDMseT4WC30iVUPPUa1tgVW4ts8EnZ+fNatykDvp1HwelqmqyPVTRj7uj8FWNPF8fWkXzKhstfnF7psUzJ/jXi+acN3o2OVAMcKpeBqJVQGlkqYGWIRnp3hrHbIphdaaNGOmj5KjgB2h4IBA653lgJfCmD4UrlAMUwIKcEhvHGDJcgv1r4yfNM31Ew0sRwqA778lhCdXT1PnTfRbMOJol56cMNewmPSQ+0TO+2m1yPKmNLOS9FoR45dpXweWACsQ/LH0bLEHw7wglJdom42dwQP0Xdxm1QMI3f76dgMKiVLqcKk2r2YLeF7wqQeeM+8foDW/vQ6mX/I0ohKa1gnixt+DOlvTRYFRrUap5QZ3ZdeyMO1xZdtvxft2e7F/xwTf0dAqR3ejNeNxUcLC2PsDjtHVsA1jps305+sdCRxXKGQAEsJXSuzin1JLZpVBvIWvAga2xMt+03crj4AyVIbk6HyTZYl26a2lDhBPU8RyazXWUsoEwHcYYUhK/8tTLGxSP4j+vOooG4/IZoLU3fFzUFCxbbqu61XDxTqjiP4CIqf/I2/mv2hN11689Ac6UoWWoBngIC2Jcu64pcDBAHvQhpEZF3wStG3142+6TpoTINgeW08hZBnRwYrmPq0aJ1w7oSF6dRKMSGqnHHA28JyJXImYjTT3TheGuEW1RQXG26I+m//v7eMMiV0zAw2PMh87RsEV
 qaKfi1xI
 KpSbna74gy7FXI6+7AKDYVrYfeGdGeaEj+8EkLn0pBaV6/T7mIhvk2iTFlzbaxZ/oM6fYrq2UXZ8K79gWIYUcPwd0k5+d8A2E5QaFLZza4eAFZw8f/v+imoE+bzBHAuLf81CIbUtcKDpMJPlBXURpBkYLGQmJ0qlIAMaxdyeHdvyIF1bujY8sGENtAb/8fvrTP/hyxuO5T358BIgtnhoPa00F7nByCoSbmTd+6EPTVpTh9QsWTGbgTH6RzXv95RcTRkQTIf08CZiIyBSgAZvDY55NLSDFsb0jxRkG2IHbow27miOXACq74x688j8BjW6LHj6zC3647T+m3jgqFYSZCWO/zwQPZDyVCEbGJrNOEiCDAjuEh/gbm4X+2atpd30URLqL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/14/26 05:59, Muchun Song wrote:
> The generic PUD allocator assumes order-0 page tables and zero-valued empty
> entries. MIPS and LoongArch need pud_init() to install their invalid
> entries. MIPS also uses PUD_TABLE_ORDER to describe the allocation size.
> 
> Default PUD_TABLE_ORDER to zero, honor architecture overrides, and invoke
> pud_init() from the generic allocator. MIPS and LoongArch can then drop
> their duplicate helpers and use the generic constructor handling and kernel
> ptdesc marking.
> 
> This also switches their user PUD allocations from GFP_KERNEL to
> GFP_PGTABLE_USER, so they are accounted to the active memory cgroup
> context. Allocations for init_mm continue to use GFP_PGTABLE_KERNEL.
> 
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

