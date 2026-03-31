Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD12010F92F2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9796B0092; Tue, 31 Mar 2026 16:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082516B0095; Tue, 31 Mar 2026 16:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED93B6B0096; Tue, 31 Mar 2026 16:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DEC2F6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:05:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FC0114025C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:05:06 +0000 (UTC)
X-FDA: 84607437012.12.5F89493
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B85811A0009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:05:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R94YMlP/";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuQ8BtDl4ZQkNykwAeFNEZvgCMdSm+IXML499Mdao5Y=;
	b=bvBWHEod5Y39bB9UMsRStA7hrKeoJvoS2Y2f/pSrsesTW8xUoMIDWYZ4oWJntr7GsUoNFu
	WQbtVu1jAdPZGHkL8DdA5xo4p7STGp4MnucnWbp2ictjOHEKMrDbT+m5XvLZC8oTfxeyBI
	J4TJCcjN0kIOHhPX45q6aeNFr8UDzRE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774987504; a=rsa-sha256;
	cv=none;
	b=sfWVq6VKVhuvlbgMWwfg1xTO2qas02gnf1Y1Be280FdMhGb/sjhFxi7K6vIgGbFMNERTxd
	Ieh+VimYtTjuqk33801W5NS3YvdzfqTPZjpeiWDOXyLLlE5tFVaa5hmFb103SmX1f/5lDQ
	n/zxlE27wppfqm9qk4H9hXzqWoIPJmI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R94YMlP/";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 330B060128;
	Tue, 31 Mar 2026 20:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF79C19423;
	Tue, 31 Mar 2026 20:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774987503;
	bh=p4iHbgiMDPcx1vmH5nX95S1Qm7dNTZ6vVmQCUSuJfCk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R94YMlP/6+sA8K43jL2LcOK5OTgIssoC/au/el4KlnCmCHy26ih5mzqXN4myxpE85
	 c0nMCL2+p4iodkuzTmKEQv48Sgm8snhlUqo/oKekYWquLKA3cK+buVi5nGOzyIU3gL
	 mfbubDsCzeKAdhVcvv0jp5+nU5NyQC2YiI22hImCYgNTwClbKEeyQ5dTondOvsaG7H
	 PDawVk9eZVFpcw9TyG6r7nRnv5Jv3es69FrI7rsJ8Y6ktX3JBixIzkwQ+rQPjHeLHt
	 w3/pdSuvQjhwHF10Sql5sFUw/JBIploDMSGoMp5ClfPfmffK1N1T6ZjQFkZd2IRDg7
	 DmS4U6pFsw0xQ==
Message-ID: <29442561-9426-4635-9b7c-cdd138076127@kernel.org>
Date: Tue, 31 Mar 2026 22:04:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
To: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <songmuchun@bytedance.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <20260331125529.de4deb7b46239fb13e4be517@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260331125529.de4deb7b46239fb13e4be517@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: pqjm3x8f5twt4xecutmi7attyhqrwegn
X-Rspamd-Queue-Id: B85811A0009
X-Rspam-User: 
X-HE-Tag: 1774987504-484046
X-HE-Meta: U2FsdGVkX1+efqrnjVXN1e0HVQ8E7PgwL60b5HlG3VGNlgjfyNQuuXKbXbubEK32b/L1C+V8ph8QmRIEVdOu9r8nus37gwMVK+mp2eNiwXHkC94g11E4f2pyUfBx0GCuyFNY60DgKsxjCTVWxWgEd5tEcPmRD7OkEdl54H7d86PPsczKANtZpdJuIVLxpktqhpGMU3D8sZS6jcJzEEAfqq7fbste4NHklnHQn/Kiy7p2W2253+2NlRluXA6RjzwwXJzYslJAFyx8he+fPuKJeou9LVhjTlph73m8YJyq5Z0V4t1Md6w99yjVikPbntYiKA4Y8AOCMupIfFp1Eyg+kTJedMHCjJQMGRO5DXKKKBvHGMg8/76aScnoKLcpDhDhNEZoedVrSNP7MBH7XHpLH6uf2+PcPGLUMuMHrVvaaKbgsYWKhl9vNhP43viP4oeEc2qVR+bUmbrNKhy62Aw92DSWNjFl1trKwYD3ePAxtg/CCedBLjwRbA3ze8vq8Q5DsyzNNy76cZ825H5AAzSDB2jArBJkpnADqxpigy7j0MfQ9GHlTy0xlp4b1ByCyC5MLeAzwA4fEfAR2DR79BBvKbohhmOf5D3buwI3shloaGT0Ky5LIL3rCRcFzBxH2gIEpvPsCilvBr18rE+sh+w71ym8qPqEW3YNrsioN4yk/EYngmkUzVrG3gOTYubrBj3Eq6tuxtC2nDjJhRTTQH06gwsfuAD8SLqtEIv9e0h83Wlml2IcyWNqb1h6tby9OVLWp9rxXQh+LuSzZvjjJtY4IrJzsY+5I6eHv7+zp7EXXhAsdVN5oIu5FzExofjGIcGwnHWLHt0EpxQs6gkvq4VYqVCctrzjUzF+QpC37/Tvi3CGxrJEo5cu0pMmF7b0xMCf32gocTmi4R4yzuIHAuJLpNyiT+LgH+sfXkCkzzouXcSJ8D0+dPAbQJ9bF6EU0/9sUfAXAmK4X9bL/pbt56b
 7iPsPir3
 xhSQYLYSXEq7EKXyeiZo2O0Y24obd+UkF+kheRD3vsDDXtKsM2rkHge/VUWQ2WigOE1SjKHpyRI5CoA6y1gpDYhMDBQwPvB5rV9Dp3qn0JGSjHqt+TXfxGt1j8SPzyMTKB1cVJCKoZkd86hRAL+938EYbQiQMgYyUFOOMxtknf41UXVU5nlUQvGPeUz6m67Vm58TIxrvdSF5kCyTFjzni6Di105qDkZjLp9bhtDJBD3RDFLs4TdgI20aerK509ivdNAnnDIM1JirermSLdQxym2ByhinlxScYq9ALwwCTfKjcXigQNP27kDK3XUNfUmmGnlsmFFvtJjFxzek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 21:55, Andrew Morton wrote:
> On Tue, 31 Mar 2026 19:30:23 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
> 
>> The comment in mmzone.h states that the alignment requirement
>> is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
>> pointer arithmetic (mem_map - section_nr_to_pfn()) results in
>> a byte offset scaled by sizeof(struct page). Thus, the actual
>> alignment provided by the second term is PFN_SECTION_SHIFT +
>> __ffs(sizeof(struct page)).
>>
>> Update the compile-time check and the mmzone.h comment to
>> accurately reflect this mathematically guaranteed alignment by
>> taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
>> __ffs(sizeof(struct page)). This avoids the issue of the check
>> being overly restrictive on architectures like powerpc where
>> PFN_SECTION_SHIFT alone is very small (e.g., 6).
>>
>> Also, remove the exhaustive per-architecture bit-width list from the
>> comment; such details risk falling out of date over time and may
>> inadvertently be left un-updated, while the existing BUILD_BUG_ON
>> provides sufficient compile-time verification of the constraint.
>>
>> No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
>> the smaller limit on all existing architectures.
> 
> Thanks.  So this can fix the build on some arch/kconfig combinations?
> 
> Do you think we should fix older kernels?
> 
>> Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer")
> 
> Eight years ago so I'm going with "no".

IIUC, there is nothing broken. Could only be revealed by some new
architecture.

So no stable :)

-- 
Cheers,

David

