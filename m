Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CA2C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F9C6B0092; Thu, 10 Sep 2026 04:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FF26B0093; Thu, 10 Sep 2026 04:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8EB6B009D; Thu, 10 Sep 2026 04:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E79B46B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:16:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 517311C23AD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:16:52 +0000 (UTC)
X-FDA: 85197146664.19.4D9D481
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 785EE100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:16:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVY1XiJC;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789028210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftFZUSVOyS9bfvsQojvatJ10rlyhpu64QQLvznjHmdU=;
	b=tJatjw4XSeiopyld1VZ4j8HTd7hhaIK9fE+hkZHVDCvQ3rOoGrpjWu01taBgquTaR8pQx+
	rxHdvYUduYtmG622f5lUsTMSAx0iMybqzdn4I4D7XOFR+eLFVGkPG4v9iUS7YOYNgx+Tmf
	vE2lRwja9N+uI2seTkMTovwsr0+PZzA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVY1XiJC;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789028210;
	b=CzeGaTSUTrtdqvDoocmnQwssGUSethaTepgzkPctG+vYeP3xVEPDHXfaIiwgU/PRTzm7Mw
	1t+fXTGuC7bMtyI23nfXA7b6zarhk9xmk9NgDLL/SCB5W03AEQxP70S/iOtAItyHL/JCjj
	6Hq8KICy+bv1BEr//xNuFHp0Sc+rsoA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAC4640276;
	Thu, 10 Sep 2026 08:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F2F1F000FF;
	Thu, 10 Sep 2026 08:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789028209;
	bh=ftFZUSVOyS9bfvsQojvatJ10rlyhpu64QQLvznjHmdU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fVY1XiJC4Vf5g8jFDmB0ti3FWZ4F99IgchLrZtSH409dEUffRwgmLvXwI7b2csASg
	 09bJ6DGCH1f7mv2Sy/PZoc60O+YtGZSwsT5AMbTLKSwnQHWetxRf+G1peI3P+WKRkX
	 UqaDP793FuN5d8rp88SEawiQ9QUL2QjptcOmf8h3p5ORacS/vmtMJJYUbXNWjQCjL1
	 hfwDdMcDxfDfMLdfGjtpQNuZGcTWcDwhtFUtNgBeXzaCLitfNDxCYDKD29H/L/HYas
	 VgrXZE4aGenFr4+BqS2lZyQCLelCVCrvU+60/Ewq0WliMIrkpK/5TShV9X943/7MXL
	 fGVUwPYPWOWBg==
Message-ID: <06c15d6b-444f-46f2-9341-84d8afc1afc0@kernel.org>
Date: Thu, 10 Sep 2026 10:16:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] mm/memory: constrain generic_access_phys() to page
 boundary
To: Ren Wei <weir@nebusec.ai>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 notasas@gmail.com, vega@nebusec.ai, rakukuip@gmail.com
References: <cover.1788842306.git.rakukuip@gmail.com>
 <e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: u5wexcwps37cmwmqq5ycxga4i6hug35q
X-Rspamd-Queue-Id: 785EE100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789028210-415004
X-HE-Meta: U2FsdGVkX180JTfNHhHZz40fIDjCNNVXmeTkxfO/ZOuqDMg498VXHPwgYdjzFxwYjoFUpUibMHVJxbw2RycYQBfQraHymat/t9gtAqdzZWsRVXpkbjqFbr0ATnSbCuNVcuebzlNpiN63YM1cnSLAuYMMNxT0DSbxUwNC1pQxs4E8G1YdsL3CeX+bol1wkYLky3M1SklBnxCKN8DwoDM5zPT3bxjQoUPRrcc8vDKzLmsH9Cn/h4iqcwL0KpFMwnKclLhs6ipjDkh0wiL5H/CugzQno8mCAlvYk5JKs37YFfE/GAm8OMahQ+f5D1Tn40Ygr+KynEdds4lWBLSisL2cXrgNeXRWJmuBEQCJAxL+1P39TPcB3EiV28ucYFrDTnwyEP49vaVWlS5NGt9nygPON0PhKqNHxCD/EguhgAv7p0RiRUINI1d5PG2VgnaCtY4mKO9yNZq9TkjLmJxpoICXfI56KViYV388XqOzCt65ITxQ0schZP6WaaKQlBv9kvJKLDC4AItUkluBFyX+o+ZYy0P4GOcnLFBdTDUlLTLpVQ4I308OSDwS3TE/JGIxcWNXnTilIJ9Bh+HxAwQE/COS52TILDrG9e9HlChPJ+y+6E6fISxOka7aM4tGNugQ0LxLV/Fg3/PAODK6DOT5cxmRP/Kfm4cv1IRDyKBJ23Ui20huvwsij8t2OZVBiIPvOKUaRYrUtA3RM+ESu+PQlIfJtg1Swl3vpifckIWG2GO/fiYFLVeTegGLgFeqcOB25+mvyr8j6RP6+Kh+m8lVJI1FWkUqdT9LtYmJJqB1/KLRRNUHj0rxl5AmeN2oJIWq80v0Up0x2zQZ/cmb8yY1UZaFCBojQUfj8rcmuzm3UTAC3XAxm4vn3A5xhqRgckYgyTDZuxdpnKBDYaNTZyU0GmcdkFjThgTEvQHPccvGEIbcyngqNLh2f8z2krJ3KNr6HkO9ymvuW/fQIugqxNLUbRW
 32+QgD2o
 FxKdV6kBLQji1UryJLz/86oXpZOzZzas6mmWRTEec9i5Ep5zOl0//oaHhq85fwEy8rysszecWNkZ/Y17fjfO4/opJ3BnlU4/T9pGjUM6ZJu2MNtMcMMjTiGOqPLpCcjdVmNPnUMiZ3nMetQSg4/yqXAF2CZQ4RbFGiF0WY8KgwRxwyobjJ0RAAiev2u1AIfVxtPYjNlPyQmvHJY/msiiQOcz2es5sUgvSAGzTquHtfHcfHd0BZSigaCJBxj1FRRjK/5/543XB3Tar/vdags4hUkFlYKV29L7wUQVzx2GidadAQr+6tCpdn34XHMzQFA9Mk5jwsweCjZVJF/Wle8tOpsw/3fIQSk9LoMsM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 05:42, Ren Wei wrote:
> From: Luxiao Xu <rakukuip@gmail.com>
> 
> generic_access_phys() improperly validates the memory access range: it
> only validates the start address using follow_pfnmap_start() and passes
> PAGE_ALIGN(len + offset) to ioremap_prot().
> 
> This poses two problems:
> 1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
>    physically contiguous, and individual PTEs may have different access
>    permissions or writability.
> 2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.
> 
> Constrain the access in generic_access_phys() to at most the current page
> boundary (PAGE_SIZE - offset) and map only a single PAGE_SIZE via
> ioremap_prot(). Since the caller __access_remote_vm() already loops over
> the requested length and handles partial transfers, it will naturally
> iterate over the remaining pages.
> 
> Also add a missing (resource_size_t) cast during PFN re-validation to avoid
> truncation on 32-bit PAE systems.
> 
> Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: LLM
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
> Signed-off-by: Ren Wei <weir@nebusec.ai>
> ---

Yes, LGTM!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

