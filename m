Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD92CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 09:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8A26B00B5; Fri,  8 May 2026 05:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1333C6B012B; Fri,  8 May 2026 05:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7D96B00B5; Fri,  8 May 2026 05:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1F7F6B0129
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:19:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FAC8120775
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:19:35 +0000 (UTC)
X-FDA: 84743704710.25.DB409F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B08311C0005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:19:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UlA/nWgm";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778231973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwKihek3Y2ButSwXw+rXdETfjWbd1+EFS+XDT3na4sk=;
	b=NXkFDipW0oc05t53L3DdXTuVaMb1k17AkyIiFiFrJp0VNCuBt5dqvQj/LNwucjz8ouA56V
	e2kOFzpcX2o+7E7iEsukFOkxNitZkGEXR2o8oJKPML/HZObC0DVBavOQsXVYysj71m8nCL
	Q6lerGvF9Z49b/MXQDyYqd58mF0TDIk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UlA/nWgm";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778231973; a=rsa-sha256;
	cv=none;
	b=PDSNAx8T11NjJCu9vK/25y2hsndAmEiXbdzsqz9/xJ5C5xgfAxTEoEiQDFGt7qA4wZTOjr
	bPuv1AQP+lRGfzFt5iXsSR6Tq9yFy8oGjCc2/bnWx9rv9xFWXTEmp0t0/yPhu+8bgkiPVS
	2thvISqOk82er6pBfk2RKFNlMunYc5o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 02E6C6024D;
	Fri,  8 May 2026 09:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50CAC2BCB8;
	Fri,  8 May 2026 09:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778231972;
	bh=HD10/OvHWGQtC/Ir+btRDVcHCRlbVLq9mOL3Hy+dZs0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UlA/nWgmR2XUw7Y1FQNiSbT1feaYVtmhqQH4cZ/ECetiuYCB/yWVJuCad0hzO5Z2Q
	 XPyTUTVNvYcOMwauxNTARZP35wTfelAk+hj7Xs5a5L3BaP6tf9zJ2hO3FJe4soyvl9
	 oGnUtNoQ4R9Ghz8JF8X/cc9wmPHrHAhIxyifmEI3fucSEGI7mwf8t6NNbvBnrmDyF7
	 FDNWqe8rtQ+PFzAZ3QP7nS+ofXLX/I1S6Bsa+LdoA3tUssaPR433rIlzoyZmTxVPjN
	 VoUETNZJzKvyXhIiL+pBwUBwk/SxULGkDb9nJfPeZ1Xm38kphytkn8t+fUhubvRvL3
	 grG5EHaZo4jtg==
Message-ID: <0c20d1e6-1a39-42c5-8c94-9bd2222fb6b3@kernel.org>
Date: Fri, 8 May 2026 11:19:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
To: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B08311C0005
X-Rspam-User: 
X-Stat-Signature: zx6nerya4i6ffhf5kpxcd914jqbq3gz3
X-HE-Tag: 1778231973-8673
X-HE-Meta: U2FsdGVkX18WECxg0PquoJwesXjcCqyagMcY1w1wlifwEhxC5bXIFi+ovs7qtjKJ407pD8dwca42y6VcZ6XhMVGWbHtBI7W09rVTFoyn4mOdgbshal98KkbxqEsF1ms28n/zqMu3xtnkH0xuvPuYpCi//QJjD1WRLUqpoPMY01JneGd24IXrRNH/6mc3Sak0VnQY2Dd75Qe4nFwX4DmdlaBniwoQcf+J+5bmuHxHJruMlGaSoRnkt5SK5jbvBOZMh3KQy7l9DPjJhtr1BKl7pWO4e01Ja9/inszIiuOEz8r69Pxm6p2sE2vkGI5SeFbbjL6thv0b7VQHj35bIdxwaqv9TG9/UTJlb82xHFQtwj/5U2spmPKX8fT5xC0Z8FDWJo/n7ZyNIE4ZaryCxIVW8cPllMMgQlkV42OPei1M47mF8vHlY7eL0i+DuPZ8tVxdNJoGAIB4izYuEXj8R/BkJJ8PbJStcD2AaoWhIqg1qNESfv7kyeJ/PoGb2BvW1Txlg8985WGrsfWrurGBeiaOzMaA2PSTuaZ2KqkyypswMJ74JSvsdocpYxiQ6L9GA1JQ1iUsDlKjJW223FuxeZJ9kCVvATswhRyuU5DM4Gf8xA9XdPrWOzPHwJcdqy2I5+2S8pqhgCh8FL4uAb42vr9dtiudEzDJ29oKBay/9b+0KAOlMkYr/PfVIKE5eM/5Iv75M+iBhNCbPp4tP08zzyyUwM9NcKqsQ8y9BKXcmmMJ7jvY3sPeUOHRp7CC2kK7bF3duhtnK5e9d7MqhYnBkjS9gZdxvX/Vg4J/rPSos9eiZx8uIWdpbAlx4u/QMryJW03ADiGvNNqpb4nhNSx4Uh7NZlRXbc6SCsKBbl5rmVaZMtlxLaEjHOoX5tr+0ZEjG1bKzBDfB3hbVSEZKLztdApCyqYCwI4vxdjBKbRQcSUVIOqcXfwlnrExzvs+AO4ebu+o9sTRGv4BZtS0XGXknb3
 k2TCd0lV
 +gDhFVNmiV3XbzZYmQI8fTCdMkXz5GyLpJA0ixL6sxOt/ak6G1QWQTLUr907FJfDUN36A4JNL298dIG2HCgx9dOri1zfivrvnNF2T6j9RUdcXnaYT2nD4zzj9SnFipi0nb3WvtvyD1+O7Zbv+lUoAqQK0Wqu0vif4xqHuNtFuimF8x8JG0F4ny5TxfukMsVU/ZTMOre2NWBsjBrCpjR7DjXCFmF3ecLUTZ25cJeeChUjwq8YVIorvLqvZ6DDe8dHAilr8BGrlq1az7ljNmUMGt3RIDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 12:49, David Hildenbrand (Arm) wrote:
> In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
> from freeing non-boot page tables through __free_pages() to
> pagetable_free().
> 
> However, the function is also called to free vmemmap pages.
> 
> Given that vmemmap pages are not page tables, already the page_ptdesc(page)
> is wrong. But worse, pagetable_free() calls
> 
> 	__free_pages(page, compound_order(page));
> 
> As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
> except for HVO, which doesn't apply here -- we will only free the first
> page when freeing a PMD-sized vmemmap page, leaking the other ones.
> 
> Fix it by properly decoupling pagetable and vmemmap freeing.
> free_pagetable() no longer has to mess with SECTION_INFO, as only the
> vmemmap is marked like that in register_page_bootmem_memmap().
> 
> The indentation in remove_pmd_table() is messed up, let's fix that
> while touching it.
> 
> Note that we'll try to get rid of that bootmem info handling soon. For
> now, we'll handle it similar to free_pagetable(), just avoiding the
> ifdef.
> 
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Reproduced and tested with a simple VM with a virtio-mem device,
> repeatedly adding and removing memory.
> 
> Found by code inspection while working on bootmem_info removal.
> ---

@x86 maintainers, do you want to take this through your tree or should we merge
this through the MM tree?

I have another MM series coming up that will touch this code (no fixes, though).

-- 
Cheers,

David

