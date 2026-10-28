Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54544606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cIBWz7ft
Received: by kanga.kvack.org (Postfix)
	id 6FE406B00EF; Wed, 28 Oct 2026 16:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6882B6B05B1; Wed, 28 Oct 2026 16:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550316B05B2; Wed, 28 Oct 2026 16:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2742A6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:34:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9A12A0254
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:34:07 +0000 (UTC)
X-FDA: 85373186934.05.33A2BB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id B97BD20008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:34:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIBWz7ft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793219645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HMKZuJ5mzuvxrnS1ESvLr/009YKienGm5nWikk9ws4=;
	b=ND3LSyE3U0T8vPymUs3M25DnIKmQj8qZu6M0Z0FVFdEJUcBs8LKqlqKYzV6/BFYMsJ9CCu
	KtxDC9ytGMHI2QAo54LIsCOfV8ulSIuBzB5mt+L/MgJATkXxp5QOzau5M7PdP4H7hXPiv1
	8ResIizRHXTpl7E9xz9Fb9mKHHZjveo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIBWz7ft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793219645;
	b=S/1MYeq3MEI5Kgr3Xg9ul+8BneCd+f4DWZQea/VsZ0/3CwGGTz3JYMwXieYd7XhhxO5lHe
	9vFTKS9aOwMMgPALaYg83tj1933rg/WrWHbXChmwiNbS+hPVNrh2dmJanfCrNoiGGhStsU
	4DXJ0DjVdu/8UlEHTfTS/vdP/GaLw/I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73F8060202;
	Wed, 28 Oct 2026 20:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B341F01825;
	Wed, 28 Oct 2026 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793219645;
	bh=5HMKZuJ5mzuvxrnS1ESvLr/009YKienGm5nWikk9ws4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cIBWz7ftIdOwqDs027jvbsvqfjLC7DFt594wmqtGfW3hHL7XAk4RfMM3E/c6GxnLz
	 M+32Ms3Yplm33eju/AyD5QrKJ5c36zTKSdZQkNiXmI2OdbwRRx2vh22uQpoZ+tx6jy
	 cWYZ2hOiEp9gOPEnO6AcWWioGmfDctCgxK3BmgZx1V7JmLWNUjzT1quMRZT/yYUtt2
	 96aDlR58KXqhUwNUS+dsm/bVVTDrjnzrVIMXtpzG6+GIOnjPjIaMNNrPWRPkY/nDAT
	 8GXnNgRTSCneh9SNPYxBNwHikmsbbhB9CNuKUwtS9wxZzrt+rNAhhSofzl8N1IPKCZ
	 y44AKjUVHOC4g==
Message-ID: <44a5aa3e-173c-41fd-bbb5-92ae9d1cdc8f@kernel.org>
Date: Wed, 28 Oct 2026 21:34:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
 <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
 <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
 <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
 <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B97BD20008
X-Rspam-User: 
X-Stat-Signature: 7gcihs19a4wenroo7p7asntazjnrkiq1
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793219646-936403
X-HE-Meta: U2FsdGVkX19UnzRvnwS7N/mldP7IM46WA4X2OhXLfSKjUIGhUveTFWZBys7BQPXdGsUeBQGZtk7ZZTKMaAK9xSpizDdPRtJdxKA+V4qkGk5T01KBnmVREi9rU6lOZSuf9riObz7ju549/1A0ymyCOxFDzIFIddLiNl2Rq41Y0qzsmRyMlkppGrBO0zPBr0yq0BkyS4vKTYH17ZH7F42uZ3Z1Xji+aA+p8NSkSLPJJCQ/2MFi56QFYfbKHHSNNf8LixdEKe8/03QdofZx8tfSzE/pa2guzB50zH2CVs2W9i0T9Joy4keDMDt9bTkCU5iPH7phXc7rvuMrDdxENhAzYjHY+qTjEcAs3WfB0ID10dv8JBEVRJTsqa7gjHorR8o11ZjggLk7kX7E6q5qWWwwjL5byyvacmI60XcQp1RB+ErPyp2kyRYcYYjyA0eBB51HuH03aLEbGwTNQLwVkg9jYAsEk94Qr9hbEdg4av1FUfXOJrvy+6WULY3+oTS9yHu8APbOAVuLtF4I4sQLRkk4iFgHiSagwolJYoCqKf4Ww5/yJDUZj7j8RfBgaCxF8nArnS7gL7ztFVgjOrMLzkZ7XLG6CJP0ydasr4VqZ6eQItSFMrwl4Unt8lKh8RGaG1lvJxng1XeG2kwQ4AL9g2Q99QhztDkQAMwjsozeb5+ldqAfW+JnotQdJgdpU8D7P4gJVXuQQJh+Dvv5shEucWP6IyLXjzzSwk/QfGl3nxwpb2nJkNp8DwnhP1MhPsH/d8CdAurWONLju7y+9OwBtFH/d6qiPFinK1KOdTe81XIufwajW3qD7dQNvJaqkf2ktIpmeWylQSmDRuC7w5TGtv1WpOCk5o4k8d6VA7UQd/1h4UXLbdu5AltMzvJkNgxzt7KqxGmstCkiQ47KFoHNBxEkRNM5aRsnSWSASfNpWXimEMEcmwgujpn51zEUJ7PRfYblyE292hY7lRNz+JJCfxj
 2TjtLs0V
 nAjjZPoHRk7j9V0h8AiYKSinh9foXMGSPmQvTB07c6oRPamtNkYOKPJm8jG5C05KI5mqrnjOU3c2hDMEIU/Q/LMkDZIbbK1yCEeZfHmFXbspaY16mMqLw9OvVeDjjWo9ykvic4OMXaUkxADIExUNfBcxioIWnw5zl7C0vNg+pdoZH9bTTO3cU1EH3JlECntT5B6bzyU350nwLTEjOHM3/uWwx3mfCBx1GREMmpHXh6/84liKLbicWMfA2Q7TVvl2DX6xI2UM/UETckZiZoL70KEqZLI6Wc0+jzAmcv0Jxhqn+XshQWtD+x/Eu/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 18:49, Zi Yan wrote:
> On 28 Oct 2026, at 4:43, David Hildenbrand (Arm) wrote:
> 
>>>
>>> For writable path, a new vmf_insert_pfn_mkwrite() is needed, so it was
>>> not fixed. I can fix that part as well.
>>
>> We should do that; returning kernel allocations from this function in ->fault is
>> bad.
>>
>> How urgent is this fix here? (can it actually be triggered?Specific hardware?)
>>
> 
> Not urgent. Like Jason said in another email, RDMA only runs on arch
> with special PTE, so refcount, mapcount, rss are balanced. With DEBUG_VM,
> zero_page checks in rmap will fire on the returned zero_page.
> 
>>>
>>> The read-only zero page part might need more attention, since
>>> we just prevented vmf_insert_pfn_prot() from using zero_page. Do we want
>>> to add the support for rdma_umap_fault()?
>>
>> We just have to make sure that we cannot install it writable etc. But that's not
>> a concern.
>>
>> Just have to be careful :)
> 
> There is one wrinkle, it does not work on
> s390 + mm_forbids_zeropage() == true, where zero page is not present,
> and a private zero page is needed.

Yes, see vm_mixed_zeropage_allowed() I added.

In a VM_PFNMAP it doesn't matter. It's only a problem if we can GUP involved
IIRC, and VM_PFNMAP just disallows it entirely.

Similar for s390, it doesn't support any form of memory deduplication (incl.
shared zeropage) for some KVM use cases. IIRC, PFNMAP does not really apply there.

(have to make sure that gup-fast doesn't try pinning the shared zeropage)

(of course, the shared zeropage must never get mapped writable)

-- 
Cheers,

David

