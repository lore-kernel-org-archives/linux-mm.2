Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9682BC79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968646B008A; Wed,  9 Sep 2026 13:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9196B6B0099; Wed,  9 Sep 2026 13:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3966B009B; Wed,  9 Sep 2026 13:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 456ED6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:37:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C1571202B0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:37:28 +0000 (UTC)
X-FDA: 85194930576.18.661A73F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B96FE10000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:37:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sqka9HTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sqka9HTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788975446;
	b=6lmRH52GMtuLfh6DUO4LHA8bCOHJXFDgFBIfa0M+uNN0+WY9r0xoKhtJ0+3J7gk5fx+pVt
	pmcjfEZ+RYGTdWI5sOsq8blavMmToSib6fhFzs2Z13eTCXpsFXe9WlOoSSmLFP6G//dBl0
	wedxvrZraCgfxJEoUYbSdikvxcjoWUs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788975446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9PNa4R+t3+/Q7YIzxrT0Zr/+QGFCn5UkrA5qrH8aF8=;
	b=jUJvTuHFgq4rC3vBiJ72bbf6mf5OmcIgG1hGsJDYjCmFY7ypwBnw+yq736x2PtdY75Alch
	xmYfec+7UFojdLJgnEFz4Rq3T6GEAwpYo0PlKyFTJwSChXvLhva1wSiPKSFLQhkVTUfduN
	1hy75krZ+1duVTAzfLaqCWt44jS+LMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14C7760202;
	Wed,  9 Sep 2026 17:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCD81F000FF;
	Wed,  9 Sep 2026 17:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788975445;
	bh=Y9PNa4R+t3+/Q7YIzxrT0Zr/+QGFCn5UkrA5qrH8aF8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Sqka9HTF7GJC4vOfF3KWaYMenTpODIY9wDI512cXSbBIpPVGNCT1grZtVk5zSX0TS
	 FPqZj0A2ktwmp2Qib6MnZy+dKt3t/O+VqOCRlzYaHKOvxUh1RXByVilM+nR3bstHeX
	 mW9X4XxRCOe8swBToNqij3+Y4QuZQkLzcFKcdGxwEr41Eg2viEcY9mgUbkj530viU/
	 lQRLAoxYE3V7RIN6m/3trUpyDnqBcqk9h/ISIexhtE6fxtIanqZRbZtE6DxyJptl+L
	 H4DzXPQxNewGji7xjlEjGDbIdABDKkC/GzziaT1hRM3a+wjrl64sVW+iOl9piEJNcD
	 pEH93teGJ5Asw==
Message-ID: <a10eeac8-be7b-4eca-8b6a-91a608d3faa6@kernel.org>
Date: Wed, 9 Sep 2026 19:37:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/17] mm/huge_memory: rename remap_page() to
 remap_folio()
To: Kiryl Shutsemau <kas@kernel.org>, kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-9-b532a3f20e71@tencent.com>
 <aqAmezgS34JdeTVX@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqAmezgS34JdeTVX@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B96FE10000A
X-Stat-Signature: uwp1rwmjj8s594zjw4tn1edgui76j51g
X-Rspamd-Server: rspam01
X-HE-Tag: 1788975446-511943
X-HE-Meta: U2FsdGVkX1+EDu1qWqYB4CnsfIbP+94pB3uuhUnzaYHuUaFk2j4ifzUYAMYfLms+UqTxuskvyRkOUsTn8JXxxJdMuUR8zf+8RzPQyKYtr2j5KpVKghWKA6S1c6D5ckYY+oZ7Jxg6psfx2A2VGV5K3Jfc6VRZWcJ9JBUvzDOkUGXcr9XY0vAEcKYdLsDCHQjKRfOzEW9CDeg2qLmRqe5JZWw9cmI8CjE0hXeSE6fhA3jcJ10sfYhCCfEKId20y0p7MjZUdkO3wJ7xEQ6R2fSZun9xyoDX8gV7ll1X/Al0RArT6ss4eyG1/c4AhktoPSL3hN+Cm5DrPNXEzYMNvMdn24nk8YU6cR3/gXVUS9Tr+pSMhFB06or9pbilKgXL2Ij78c8b8+zCbFVfDmZMKg+QKCxjOg9XI+HTK4jJgqsqjYNCYnHh6Ny1v++qh+PC8Sm/lfLpbhRM/ttf/Cefb03viamNLKutN4CSLoMhc0uPOkrVYwKg7gbsNUsv9hZnm+4m/Fot7xK4zXK5mPAlMk0VKwGsZjnUik/aiQz0aEtxzP2174/wSDCJkQXb0r0RzJ1tmWHOEiJp87MTiYYLhMqVL/uDcxbXfb/S5/KjU8Rh7UH8vHfNx5XlDYyytSZQ8yUMUqasbP5b8FYFy26njHp+fpsiIBY/YVWOy8A4XTwfrHOdKPv4U/wgUOTGXmI+pqgDr0FV3GkaCiCfc6yy/2SIgxhEZ3y8q8n03hnWYKZV65JJxlAu0IqLVEMC1G4vTeomWtdpfbWfwC55IqXJlrVxC9kd9ORGe0aZlLitQHuE0I2Lc4lhDmuCUmhIfMEQ8KctMvfVfzRQgXRg5OPMMeQF2yk4Cqs2uSoUUljS51L4z3tJ4vahOCWG3DCRGfFfeHnAmKjkvh6WsjCROMNJSpCKOfMep7Eu8y2+9wYcFZm68aeZ2sUvz28JLBLBQGkNJK0i67Knpv6rOTziJxQ1ani
 cHoTzIIe
 9pOQyZpbuegIeqhDDuPdu2gjH0GAvl2hWRNrmx7Txy6rbY39BnS18qCaD7pYCk10x4FeLdZqgR4dHmcmVOXyaiUk1nFrSxT1mEJ0oBPsYM+0uYEFv/vtd/xY/eTqEf8iTFdfA7Z1G1bjQNNtxE6nzul9zCWo7ISEwduMTgFFHW2f4jv1dBkCdDKYvWG6pGbqiAaT5NS721q+i9DY6uEIwfvO2pfLdmArbeC+X0Kl94neb734TP6cn1S4o5gyoNYa+TbA0TDqnVLkJ8R1hW1dCoM8YfUSLYmcQ7UNTRDQCbKBCIDqh8wx02A+29Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 17:17, Kiryl Shutsemau wrote:
> On Tue, Sep 08, 2026 at 02:12:13AM +0800, Kairui Song via B4 Relay wrote:
>> @@ -3636,10 +3636,17 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>  	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>>  }
>>  
>> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>> +static void remap_folio(struct folio *folio, unsigned long nr, int flags)
> 
> You opted out of indicating that the function target anon pages as David
> suggested? remap_anon_folio() seems to be fitting better.

Yeah, let's use that unless there is a good reason not to.

-- 
Cheers,

David

