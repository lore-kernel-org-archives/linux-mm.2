Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C28B0CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB486B0088; Mon, 12 Oct 2026 09:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2876B008A; Mon, 12 Oct 2026 09:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C918B6B009D; Mon, 12 Oct 2026 09:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3D666B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:28:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D052140DF9
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:28:59 +0000 (UTC)
X-FDA: 85314054798.07.563D5F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7CB2C40003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:28:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EC+clTKQ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJWJfJvFdRXU7A7CP8bKUhf5LvjKVS564TTBwWUrmqw=;
	b=wGmiv3qTeJr2DZwZgG3v+hJmojY9n+4O8kcSfzK1CrJVqrHdbMnq3y7lZ/pIxCDNUBZ9Hv
	Oxp0rM1jqcjK4Kdb6eki7LdvUUBmyTyaGMEzefKk9yXdkX6rzLNbNjEHrwmAzarV/fMIiB
	BpsaJB76qoE58PmWUq28KzCqG8Ab04Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EC+clTKQ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791811737;
	b=sGNN9N77oPWDSzx2Bc9E7kMnjTPqfsXYPGn01h4Ely5wTkkG8MTsPij7QkL1kMwVmMbH9V
	LTnwxX1+rYGPzoImzibzhBQUtsDpEQfyvB+I+pot26Mi86c4w3P5AwEGC7+LuqXNCC08bO
	dhStAtbYgo/hCMPR6xgsEYorrJ/VQdc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EB1A60AA2;
	Mon, 12 Oct 2026 13:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693491F0089C;
	Mon, 12 Oct 2026 13:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811736;
	bh=BJWJfJvFdRXU7A7CP8bKUhf5LvjKVS564TTBwWUrmqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EC+clTKQWYqPlYBodlVrok9It43/JtduTxKf6oq0WBqsXaEE/fWQ/aLbyuEOxBEBC
	 aj8VV62n48eANgEswgmLe+sz7d3kelzv7I1i9px8FE7JF6AnYtWr2e6QYjbXYTykrD
	 jmHx2nQTevuvQ2BHkjXO4V1TkXJmRZ3fM2oDk5HgpA0u95NXQ5jRnIg30lLZuxf63L
	 LNvVQWM1SN0RxxdCmS2ZYeiECdObn8P2scSsoxqgsYXgnwtoHyEN8DSL5tmogGXL29
	 PzDDBbn5fGwNRKsY8z0fNjE+OcHXLHepynF1hcpPn8nDR33NkOBgSv72w+94GIr6ZC
	 26j7dSBXEYR1w==
Message-ID: <01371835-cbc6-43f1-9d42-d22bec4ba0c2@kernel.org>
Date: Mon, 12 Oct 2026 15:28:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] riscv/mm: fix hotplug page-table destructor
 handling
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>, Dave Hansen <dave.hansen@intel.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-3-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261010112457.49485-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7CB2C40003
X-Rspam-User: 
X-Stat-Signature: fjj4dxy1u8jqdrsn79apxkinbwhtp7yn
X-HE-Tag: 1791811737-592799
X-HE-Meta: U2FsdGVkX19FNWtaeMu6eT7JEDOTvXga2nRhgH5t/RyVPDmI8MVqxWAWKymJn4PDMMkRXjJYTobzwI4r1APxoJ4WsGXxIzROqdScfwWiEsJFIygGtjVOKDSZtnuTHCNSWIIwRcWeP9XqzA7oYnNS7+NEU7ZTGbGnhlfWsrz+5ttRmRGBb7Zy2WThQnvGoxtzc9D9t7WoRzJxKPyEulMdz+hReAncKV2w7hq1H5ZDmpSvwqqWcu5xtBRf2fZaGJdoOhXGv1lRHBp3febncYD63x9GIzSGhtrh+zQiRciZK+v9gnd5iZJtIZL9OM11AAKWXhL0BfuGaYjld1Q6bYw2n5RLjd+RCseWbgeYeMu7L606DdQS29NvGMv21BiicgTQ1IObRa8V06b79lRJws5+bSgtSf7uRhDevenzQEtcoy9jLFiCBhE0Hgavpl7jKJ9ntLplhxOvMhg29NSLyqg6xMeER91DpBGn5Wlq4AnB5aTWmhbAXLk/Q/YNW2rzMgrDdx+RLInlpknhPWjQC+NQMy1V8xLYv0lolUjspF76W6xe+gbe4Gtb4Xz0Bjx1Vw14SYgc4g08Hjvy3YCcetiO2xwlaPWZQ7kLU8Dh//eBVhWSFNrPT23tJAGjt0MLaGD+8cTYuqyikzA0eIimyeDRyMSC3lWXjhTuN8j65NSAm7+zjOpKGEFkkJqcd91EICpA0NCzLlavRCFDnbbliFHt/B4pv2UIkfBmfdx2tah1L+s0WjwiWgAURHaF2VeXXOW1mfln1pFYz6EnWe5pm7avK0g+PtldDCvdn+4OzvxfC220TOQhrUffznPOd/hRKGOz8jWjx1FsqHwWWnrmr5HjwehykU6ijZJM0XOD7Jm9SOjtKgQAi/mMkZgI2H2VsvSWS4vPXjQUH1r7SwevKDgiGzhBNwveQJ4ubviFNoIBzPa7aeNmfKnqG9KnsLrGxVwycruO7J0+KWrY3WCY4X8
 3CfmtVBY
 cvQ4raILOl6HJbyNRZ5ejmzIvi8GfDYOmCAFhJkcDlqUYceD3DNJwgXhTmTUKhmnyh8UFVGBHK9cbWRcQkjtJGx7sSJohkKaliNfabaAnp4Ia89e7lrauVxFPbvkL1ETHbV1S3C7vw9kMzsbDvwFaWPUoTOSaYH7QrBDZgtKmZneQ3FV6ItpasgQpKd+xnSPJnAq979N9+IkTCn30hUwIep2ds7fYLgPe1TKaK1AipQamuaT4iEt7F1swIsoz6claeCnlAQGjS0WWVCsrEa46lfUaGbSrmksYD5DP+6H62Dg/u11yVkxu1jLlQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 13:24, Muchun Song wrote:
> RISC-V uses the same memory-hotplug teardown code for linear-map and
> vmemmap page tables. Late linear-map allocations run page-table
> constructors, while vmemmap and early allocations may not.
> 
> free_pte_table() unconditionally calls pagetable_dtor(), corrupting
> NR_PAGETABLE accounting for constructor-free tables. free_pmd_table()
> avoids that for vmemmap using is_vmemmap, but mapping type is not a
> reliable proxy for constructor state. In particular, it becomes invalid
> once runtime vmemmap tables use the normal pgalloc helpers.
> 
> Introduce free_pgtable_page() to select free_reserved_page() for reserved
> pages and pagetable_free() otherwise. The latter runs the destructor only
> when PageTable() is set, handling both constructor-backed and
> constructor-free tables.
> 
> Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

