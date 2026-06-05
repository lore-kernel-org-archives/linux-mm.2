Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EFFCCD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC006B0088; Fri,  5 Jun 2026 05:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C976B008A; Fri,  5 Jun 2026 05:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B046B008C; Fri,  5 Jun 2026 05:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 130726B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:16:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA3751A0535
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:16:50 +0000 (UTC)
X-FDA: 84845304180.13.872B800
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CF670180002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:16:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HCupAZ+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780651009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUq+nIhSFr8gp3CQgUCBWu4jGQTgkDryqqH+bXHUaMI=;
	b=OjIBXesMs6JbFvMVvtZHDNM//kdQdudMD2+pNKbdweQc/v2AYawGF0lN3QFdnJij1ISUqO
	MZSaMCjneztq6AaY6verFhGFs1YLhFNgaSoKsHw1Bc7TDJIBvOIUy0hLgrvbp9KagQc5jN
	chLjbg7EebAji3uRcqLyyp9V8yj7HuI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HCupAZ+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780651009;
	b=skScXEC9O7MaHBjfK7SdOAZtE1gUmss2pzPPeaau5ZAsQzpMpKzcjmdmgnuV1Oal/ufrvX
	NdgrMAJTUyQtxtE7/qHi5fCDN6vhtAguAjTpcNLYpyFfLlR/31iuZ79XnpHXOWAwki8KqC
	EznmWpYvwwzKs5E9SJVFAlcrR5Mp1JI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA06A4342C;
	Fri,  5 Jun 2026 09:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A24B1F00893;
	Fri,  5 Jun 2026 09:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780651007;
	bh=PUq+nIhSFr8gp3CQgUCBWu4jGQTgkDryqqH+bXHUaMI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HCupAZ+BROQAVbG7NDmnlZh+v1BYp9SStVVgGalXCY1haekBfxqpoEwnrlKwKff3l
	 rmlRlvpGdRTroGt0YRbzY/vD5gKqKdW3SJ1A+aksP6uMOwKu70KxyDo4fVbB57oOCU
	 BDwufvMgPGiRPCrDEO+po9ZjLOrrK2S0IJeAW6qji/2E0TyDPE0rYrZOArM3jRR6eP
	 KTzYYwZt40yPcyLNYvVNp5nVF/DG1s+Y2iEmtJN6znNoHTYDFMe+BrtDx3yNfzCXz4
	 cg5EFI1+m7Solvz719PlWKdqZSaKFB/l+hznlmH74ySS6xQKVpyw0NWyXUWl2ZxBQd
	 gjyBqL6Rhwvaw==
Message-ID: <da19ffcf-8042-4f96-9c2d-649468dc6a0a@kernel.org>
Date: Fri, 5 Jun 2026 11:16:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
To: Vivian Wang <wangruikang@iscas.ac.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6tz54dzpegjcp9jog3muz9j3wk98gsuo
X-Rspamd-Queue-Id: CF670180002
X-HE-Tag: 1780651008-974864
X-HE-Meta: U2FsdGVkX1/LXMO5HRschMKnYsd6TVKInFcxaNQesMJkrKdAUMbSth3rKeIHUsghC+fqwvifydem3IMadI6TnHW45k2yTdFTFsb+CXxWI/oMLjUiM2oQletf16d3p1IEm+HgNlu4NmQ0Sz1pxMJCGNmaCc6M7gqYmIg1C/NaTlRvZVI4yPl9RbEUKhLD9O2nVwe2whYzgELv2+hWEO5dU9aql0s8/5aku3LSTzj6yf52vF/BcRAoihHCMWkwFelR0kXHWza01MZsyViBgDDyi5Z0QhY0Bl9w08ZmLpU4sLAvGS3yH6gMaxdLEEND7Fdd5EaHpuMl1oL9jeeH9gNhe9LxcS/RN2NWo9RfDYfb7grEbcLI9vlMla9Q6kCRlteqFrGZNkLBXBaIWMIE9pUezWFlsht+o6AnlJqFwefYSNjEoFJDbQDm74/2T5ZIrGkQlHWzzp5s/giR1UyyTnid3JoeSrlCoGjvKeJAemxTLew5QpIms6Rv4g+jQVn7xcQEPAF/N9Yz6G2fZhI64pnJxMi/OBvtlj/zcSJxrxo37bNOoXoIR5L0bV3fN6DjRsSc0wv7DuHQN/2Qg0M3yZxFS/ex6Pp0Eod7WDpAdRexD54O38az1mrMBLE1MEnTTRY5Zu4/g1xUZlT3N+QEcB9PqBL5QWnMIv329xVXhdKH9mFhczuMAUaXJ+QK/L5KOllU7YihZ0YRQUqtyMYPTUEe/8X1RUT75/i9aSheXjsJWUC2x3Y734F8reshnOUioOzYmvG9MA7bh1J6YpGLsxZElYouYWZ4fEK5uKxPrqwEdvjiE3SomQH6tj0kTXeDFp/XQnPThW5MJShQd1v9C88QsKEY91yJUYOeYELYHFlZ0qrcl85BHMi7eFBetdouiRRF6NyYNcGz4tPOnAgr7cJrKSm4YnzG+dCVpmCMr1/QPX5ovTEH0cu290PLmnfIi61x461HKeZMCFh2BYV6Ceb
 FGjuW/vH
 vOyWdZPWtpDCHeqG2EFOewrbvektI5BtPYsXzp537KizGQ08i/6lhbJsOJ49801ZzzijkRtCCckwB+6TfOL/mcJmlOXsy1IQbEEUOhlchiCfdOZZAtSBa7mjj2r1L88t2wfH4XehYaYNy5JxRxjXdobnNoePuJDWratCNwHOHZcBQC/aaTxpfqGbKMJx9yKPJSmQiknHmjqZbysVBdfibvID1PnZVIKI8yNotZ+Wd6P8pp3WKV8vkbsq0vBgdpHiObsevqdKQS6WkAocLg9M3L/JIAH8uRqMrwJlLiaYdMnEcZZa1fz+DfFS2gHcG1EZMEXZcQEpYJjkRfaMu8T9vbU3qF6U2b/BhK7cxffNySq8ElqWvRZyhcqqkjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 07:23, Vivian Wang wrote:
> section_activate() does not flush TLB after populating new vmemmap
> pages. On most architectures, this is okay. However it is a problem on
> RISC-V since there the TLB caching non-present entries is permitted,
> which causes spurious faults on some hardwares.
> 
> This seems to be most easily reproduced with DEBUG_VM=y and
> PAGE_POISONING=y, which causes these newly mapped struct pages to be
> poisoned i.e. written to immediately after mapping.
> 
> Add a hook vmemmap_populate_finalize() in __populate_section_memmap()
> after population, to allow architectures to handle such situations as
> needed. Then implement it on RISC-V to arrange for the existing
> exception handler code to deal with these faults if they happen.
> 
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> ---
> Depends on my earlier kfence fixes for mark_new_valid_map() [1].
> 
> Found while testing AMD_HSA/ZONE_DEVICE on SpacemiT K3. Using
> ZONE_DEVICE requires another fix [2].
> 
> [1]: https://lore.kernel.org/linux-riscv/20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn
> [2]: https://lore.kernel.org/linux-riscv/20260309-riscv-sparsemem-vmemmap-limits-v1-2-f40efe18e3cd@iscas.ac.cn
> ---
> Changes in v3:
> - Merged back into one patch (Mike)
> - (No code changes otherwise.)
> - Link to v2: https://patch.msgid.link/20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn
> 
> Changes in v2:
> - Split patch in two, hook point and riscv hook 
> - Explain hook necessity in patch 1 message (Mike)
> - Make hook #define based (Mike)
> - Call finalize hook only on populate success
> - Link to v1: https://patch.msgid.link/20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn
> ---
>  arch/riscv/include/asm/pgtable.h | 4 ++++
>  arch/riscv/mm/init.c             | 6 ++++++
>  mm/sparse-vmemmap.c              | 8 ++++++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index a1a7c6520a09..aa0f50e3d534 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -1243,6 +1243,10 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>  #define TASK_SIZE	FIXADDR_START
>  #endif
>  
> +/* Needed on SPARSEMEM_VMEMMAP */
> +#define vmemmap_populate_finalize vmemmap_populate_finalize
> +void __meminit vmemmap_populate_finalize(void);
> +
>  #else /* CONFIG_MMU */
>  
>  #define PAGE_SHARED		__pgprot(0)
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 706f43523935..cf9ae4099f82 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -1360,6 +1360,12 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  	 */
>  	return vmemmap_populate_hugepages(start, end, node, altmap);
>  }
> +
> +void __meminit vmemmap_populate_finalize(void)
> +{
> +	/* Avoid faults on cached non-present TLB entries. */
> +	mark_new_valid_map();
> +}
>  #endif

How does mark_new_valid_map() handle concurrent access?

There is some comment in there, but I am not sure if that actually implies that
mark_new_valid_map() can be called concurrently from arbitrary context?


-- 
Cheers,

David

