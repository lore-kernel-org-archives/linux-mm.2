Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A162FC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D6B6B008C; Wed, 23 Sep 2026 07:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D976B0093; Wed, 23 Sep 2026 07:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854416B0095; Wed, 23 Sep 2026 07:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61FFD6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:51:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC368140792
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:51:57 +0000 (UTC)
X-FDA: 85244863074.10.130FF0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04462120009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:51:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S6c30UQN;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AK+EEn9bX4oMv6rZ9/yrdLr2DnFZqRk1g2mFEkC53s=;
	b=RlUKhN4J4dmSIhUFpLN+ixB2mG3IjsuIZgmCV2q1Q5e30vTdvpKxWrVB6dLyjqqsQedwKz
	HRksw30eoAwI3NAB1ljNIE03k8aNZaE5Tj+F4BW3WwZER3TG1WNu+0xXIhdCRHPtzL4AEW
	uMtn6YXtvb7/O/qazXcxgu8L2xijs6o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S6c30UQN;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164316;
	b=adSYAAdaK7Zts/rf4ZMXE5Y9FY1juJKuy0AG/SdPP+Q9gwwU5nuuIjasLMe5E1rOgk2eT0
	y3J0TPFuGKBu1snaYGOMPsLOtxXV6XnDFR7sV4KCPjlymnVGDFNrOSIWV4DDA9ZQGwP41W
	XZmTUWOMH2WJ0B6g9NnaYTlyVf0jWBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47FB040833;
	Wed, 23 Sep 2026 11:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A491F00893;
	Wed, 23 Sep 2026 11:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164315;
	bh=1AK+EEn9bX4oMv6rZ9/yrdLr2DnFZqRk1g2mFEkC53s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S6c30UQNHik4FI50L1Fd4qwHOYLosq3dy1lWYiMyF3xr2GNx6pLl50+q0wMc4axI4
	 +r6YXcsQdlhYhp8A80Eav1Ryi9/35kLjVRx6n41G3FQyT2ZcPbmqBcnrw7zTJvPlFi
	 q6g2wwMWz9sXJNDlrmwiCZ1FuotwN3jwAIQgjFhdg/B3eFypZmva8QfHJ/wayywbxM
	 Q/cDO5tnUC1rtX4y3Qq3YXajuTknM11x7LFlWcQwMAA6NOEY+vDsJpXvD/B2i7f7N0
	 3pAJaLLnv4iJk37gMQ0+E9fu2pKZOoRKDaKz0DxbbO2IqLN6neEgKzs6IEFOBzOSdS
	 qFlC1JgTMJbtA==
Message-ID: <7d27f6dd-4f0d-4994-acb0-151bc7478187@kernel.org>
Date: Wed, 23 Sep 2026 13:51:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/12] mm/khugepaged: count collapses where khugepaged
 makes them
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-3-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04462120009
X-Stat-Signature: 3sy19r3spwpi531cd4uby5zdqbi9esr1
X-Rspam-User: 
X-HE-Tag: 1790164315-222440
X-HE-Meta: U2FsdGVkX18xk/Ipjra2pUwGWcsSafMi5WyAs/X3Ukyf84xgWj9NjmM0ENZ3haH9ney3c+4DUg3A/36MoJrJGJQIPq0AEuyUjPFLZ1g56o+Gg4pAoxa3qAN3wzjsSTHXT98E4ibGlFYiatBet6KBzyOSxV2WlSwIz8JKWVpZsLzc31PMXuX3XNaYsq4S1JkDNAWaPhLlA0//D/P0VWldSYe+2VIhE5di/VLoxWXn+PQFUXSV5q4vp8PSYRZBzaLYPMLEZrZYzS9ChY/OlOnpP6QCN3pTKAwUR9OLAiRtWLyLPe1cUNlh4UHCsDr4GB5I46mLLAQBj66yDEaFgkr174W6WQpk/c1AokHjZneigF/OevDInDSCEjdvKITzJajvnSD76SdEcZGDRLYEDQQ6G4tw61dN1FGg2EoD70RqmgSq0uFay/2yPirpqxtRNr/8wqNpcgIcwpAgBA8O1UFe5IsolOP5bUklgN4a/I3NwafSRImqIgZuYyniW1UGKWtJXdD1RIDR2mATQhbCg4wMvQJBFevSArGJ9/pHsuYYWH4eufcvuypMD9PT7iANa3KY3DKM6qSEI8i+8+7AW96o/r+N4tBCYXNgphmHCq89HBOkCv4AxAnzhESDevHcQydT4ht8o8Snhpyhrx/yHIdpJA6vo19+hjH9cLUtSurTpchndfzH1KKD1/qpTUNAm+0UcQ6DMxNhPzrVDW21iOGM6SxE1xlkkDS9ZyyKfVnAfooFkDN97mB2PcVZmeZh3utY/mxGmMn0+hs9V/Q/Qad/1aG48cY4PFSXc8yTGT/hZJ+tKlXnQRJStj00HVW6b5UujQCOCeF9jHIceiJlFk0Y79M0ISqYcIlPq3nsiGaZlbWvUFU8cisme1LyoGyKP8a7FojXxKApJPP+D4suO/AW6PDiv4rPyl878MoHQq279C2hQWCAu5/7tZ/LEnMs57g8P9L+0t87Lv/27zz7Nj7
 FvIDTU0m
 bscv+FGY7hrmrnBQ9Eg67JyqcIkgWMl2s8xp2g7LooT64J6Oc9fVBtRa3asCQ7oscDz59bJniAwEAGIApEF/hc8s2D6TqUt0qR8xGcHQ2LZ/6QZVS/kZk0JcFLg4ILj1NTfy7jpM1mVYDetW6STTXWAFJsgvsRHb6ngUKq8Udrr5zIVdq1m4LIneYD54PMH/HW1abEF6lVp9/ExGyz4INeMqmtKDA97Y8RecTvjqTVeyTo4QB7IVzLSK/owqDYRVdF1HF8ql08TUF4wHWr8ak8PnMHdf81kAbg363Ig4QPN25Ct1oasG5cSCpN/5eeZa68KFng4WKisfM7Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
> tests cc->is_khugepaged to know whether it should: the counter belongs to
> the daemon, and MADV_COLLAPSE must not touch it.
> 
> The daemon sees every result of every collapse it asks for, so it can keep
> its own counter without the shared path testing who called.
> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Much better

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

