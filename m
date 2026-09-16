Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91111C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E8B6B009F; Wed, 16 Sep 2026 09:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9166B6B00A0; Wed, 16 Sep 2026 09:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806266B00A1; Wed, 16 Sep 2026 09:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE726B009F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:36:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EE0FA0716
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:36:05 +0000 (UTC)
X-FDA: 85219723890.19.E288691
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A6F92160013
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:36:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=it8+Cdwk;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwyk+5gUmPQM5HlVeH3up+pJy3bi1L00FIGnnBnAiJY=;
	b=0JVDPquQTpzgZTuL1DsFszLPTUPkUd9sl9FHKaJdWdS4Ra9t7IhfL9mwVUon3tz4EsP1Rf
	AcBQmD+OlHtKulDlO9Cn3NgKEXP5ZnY44h07zHqaOEuHoMFrOwTwCfAyR6BCNWv7PFNwtW
	IhcxToUYl90a7Dd5YzrR/lAmiO1iUVM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=it8+Cdwk;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565763;
	b=fsP9QtvwP5mdO48YieEquGs9PxsEnV2knBapvNTDcOtg5UArHiuyDixP2TLKl5ScoOY/Ha
	BaUPd4pcvtXpZ5GPXSoZ1TCO5QCX6OA6cMKIIvynUtmI5MLCAhekKlzDDzWD8nJC8L3/zB
	NnYQL1kNOoZK6DH3UEuviPi7GyXWvEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C911740B46;
	Wed, 16 Sep 2026 13:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E7C1F000FF;
	Wed, 16 Sep 2026 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565762;
	bh=bwyk+5gUmPQM5HlVeH3up+pJy3bi1L00FIGnnBnAiJY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=it8+CdwkIuYEVwHgoARhILclAx9xQneyJikZNFw5FuiXfBQKZjuHAWEm1zRK0HBEZ
	 MBu8dds16gBsPre5OB1tdPNsQ7AjwC6eW7VT293sDASWfg9+7a48j7tkMR5WSTWBrR
	 MQ3ogNFN3BPDxIc2an8RVAS0fZ8ZLOBdLClqi18I0wbMhkJmcCXLWK111NF7U8OHz7
	 Qo9Nlk4gyT0emWDUu+ufaY+JkFfXl/FeYDomMFI+af5BkmAhJVhVY2w5tdRVIuXMr2
	 R4LMRQYCkHDCI7geEAOMv3M4ixqW1W/ccumk8vv55zTvPL9ytZ6NtixXG/NRqT+xD0
	 triSr+ZAmcSaw==
Message-ID: <1d2108bc-6b67-43ce-ab13-70ed241024e4@kernel.org>
Date: Wed, 16 Sep 2026 15:35:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/14] arm64/mm: Route all pgtable reads via
 ptval_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-3-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907035030.2839978-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6F92160013
X-Stat-Signature: cabo69whsumzfjm3u6zrjom6rrp877p1
X-Rspam-User: 
X-HE-Tag: 1789565763-304693
X-HE-Meta: U2FsdGVkX181Yknb8EO29jjQOo4jrMaKjVpR7tCfVPm2KXK/hp5bDr99KWFju7mljaECQAUgXhtYv5UwOx8wSdWetRjUxcDEmEEHUym0+3BCW2NHhq8/Ts6+JZeVSmqv/QdOrNScPow+wJr8YNrhM9x4L6Tlz3GqDu4l77E6jjFYV1GLgmh3a3WqaEFELxYfEA6upO140eORPqP+zSy+zhl/2cSMMIH6CxSwP83Xr831lvm6iHsQomwRBfml6rU3cs1wx8pju+tqDtalOf/QtLc4NAgBEd1aFFEMy2DXoNdceIDE7C8JkKdYfiI7x92Y8wRQgL6eX2PtAfs/oEOM/sDDWFg95hOu84Kf198FqycxJSTnkeRcNeAr4yNm7E9AF3xJzhpeJkV7hFilq/xNxjV6yeqGmlrtFiPmY1SNA8CaWIrl0WjSMQArUEvO5Mrwr3AXQkF8qBFnB1kXVNNOpp0AF9HeYoMlJLFwoFwOR2Mz1G7KeSHe3DEaMtHyXrJABb2mFNpw5zJnUv+lx0oeG10toOjn2SShPhfovAnwX9bk+XrhZOnG5vcwfoSvafyiQvsRXR8bgGHbgi7hI4e4lW1zSfKd9wdrGEkf05ZM3QcsDCzXA5Ag792s3+5P+bTTrGmMBL/BCh3gKYyjMlq4UdLH0tHZ0Lr47YVOxTVZ8rRp9W638jwR0YYgNMPENkFQwU87q5mR9njKpoaX1IQvjnV8xHFnshLEq89jzKHfH/4U3tbZui4nXum/rY0dL6KJmZ0TmA3erSFbVHGvyM8Gi6PjwaZZXCyXxFXknba/RNg8fdEhUtQRR5QYlFpIUa41lshVCMgllieGoej/2PsCB4FCgz9kMqmsNMUVBYKOzGzf7Pa2Wv//N+gqmH6C4Byv0eOvuznIAu28yQm56RHePOalEG+D4zBWRC6BpfP5KDij/3IaJC+rekvGO17I4u5rFPmZgoVOBoiXno93kr3
 WbJZvgZV
 zGpKBqpQoDndXHSvOAmtTn6DN/pAatdeDVZov2Qb9kYP7Bf5eQsAce5/euLkv1xAS2s91tpcyHFKsJwB2LYRlzxFEYRoXQl0NObnMR5RhDZSA0dyYfjHU+CTyUYpmtpS1a5F1mdQWwl/CyvDeADHnUrbinNy53oJcUHtjJ0jvdDrfYI5vJQzRfuc6l/L3sgy6v/zUcN0mU5/fdTJUD/ngfcnSUERqnXHOOatqu0tRXYe2xD8593d7YFcuTEP3KBzYGqX5npfT3whO2ko+XC5G3gWJ/xWBK9Wl/R7GvYVXArVkTfZvXb4rcH8aZT+pvWYjOHjiYhrrl+eVlSC2CrqVrXG515JRxDVAQl1adNO1x0XmKUUGrS/vC0xUqr/XeEAKe3Xqf6NeHoK3gA60U7+59Fti1/xh9a1cbeAxhzu+N1Dfpl9IyVEgf1H33Gn7wMfp51NM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 05:50, Anshuman Khandual wrote:
> Define arm64 platform specific implementations for new pxdp_get() helpers.
> These resolve into READ_ONCE(), thus ensuring required single copy atomic
> semantics for the page table entry reads.
> 
> In future this infrastructure can be used for D128 to maintain single copy
> atomicity semantics with inline asm blocks.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

