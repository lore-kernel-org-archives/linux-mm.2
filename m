Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0142C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2986C6B0193; Thu,  2 Jul 2026 21:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271166B0194; Thu,  2 Jul 2026 21:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1868D6B0196; Thu,  2 Jul 2026 21:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E94CA6B0194
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:13:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9C0912015E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:44:32 +0000 (UTC)
X-FDA: 84944258784.23.C436982
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C82734000A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:44:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksutEY6W;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783007071;
	b=oLx8bpqcF2ay0s2Xv5XUNjbhi2yFU1jed/E1Gi6ZYUNloCNILx41qoY+dF9AwdG1ZSi1NB
	bL9pzj2KzkUxvBeUJcTOgzlI0pIu1anaegTd0vQTrvjMJYdKM3j3zlgSYx8t0HSLiFObZf
	2e/aAgF+8JP+lXNVrEiG0lCCMgRBpfo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783007071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NLPZaAxLlfVoo9TQds5zdC84AWDauDAYil69mJ6gMU=;
	b=Rvuj6L2cTyuNSVXJHQ9xP38gD3fqxhXl7cShPsyCutGROx29V0UvdmFJM597wKF+E9EzUZ
	gF24Kk1k9hYekaaD6bBO/vPfDWX0nf28yrIWaWgOOgTXMR04murZN7pwThsS1Rin7g9Y9L
	p8a0aMDlZsgjgqplvLq8bF0Xd6Z7FQw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksutEY6W;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E47CA43BA5;
	Thu,  2 Jul 2026 15:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58EA1F000E9;
	Thu,  2 Jul 2026 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007069;
	bh=+NLPZaAxLlfVoo9TQds5zdC84AWDauDAYil69mJ6gMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ksutEY6Wh40A6FNGBunfbtg1fjIF0LNXDbJ3mO8CXEDU9pmcOBdL1e/5v05soePHr
	 fj7g57nyLn/6TbxNbZCc7sDoxqwpTg/n39fFiWAzCxJ38dr3zBxoHH2U0/RHHT1+wo
	 VDVnIr90DU16mwTfqURsSknrMnLfVhKw4Qlpegd1Qm8BOb+YGybrKatKQ5QUk8ynMB
	 opam7cm2C4mTc1EGvul7UFk5PgcjCCMbscuOBRN9dp4VYGpYjM1HpEciKR+vYdhCOe
	 X1tnccg9j6y+B8TiwvHOyngDBNQjFo03tK5XPFDCOdzCwRDo5hW6hdXBiQsZm6OYk7
	 HOCsesTwJTz/A==
Message-ID: <e552da60-3d44-4812-9522-19df8470c495@kernel.org>
Date: Thu, 2 Jul 2026 17:44:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] mm/migrate: use huge_ptep_get() in
 remove_migration_pte()
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-5-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260702051341.126509-5-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C82734000A
X-Stat-Signature: qe65rfg4wq636fztwaqbpxekn3cqh49k
X-Rspam-User: 
X-HE-Tag: 1783007070-809049
X-HE-Meta: U2FsdGVkX1+E+qxcpNuXXWUuSp2Bg/ZvecSPeM7Ovfa/WQ2U+DNWouGzDpcB6EJunFz9UjbWbZgD/87ctaq6UjRmlSmX/9uQyh3FfHy+djbGA7vkTvGBb0X02VZwDHf3O8s3Qsrt9L7S/apPoc0ezkD8qKr7cYeT6vnE6j+Ev8QSkXqnh6eQlQtsKVqdvPgvP6/Zz6dIdPNsYj5FUtwJ/0VjZNUBQOHB+TnI4N90sm5qF6ptG2Uer8FsURyLDoHF/sk2oL/gVb92+UAPigki2xx81fZoRLqHrTD7LOogIUB+B5DR0qT3xKC15MbvHVgPhTBq/PycDehEYgAi2biEIuxsGA5uBXPUABBKOup735hYYgPw5esnvnvL/csGGAMVQIF9OEI6agsOXsOhWYlZoyhkauLXYbcWqwtWaVGi9ozyK9Ke6G3pkhTpKo7F96p+Pr04H7MR6RO6oCjmA7o4pBy9VX3oVUzvlvw+CL9Z7Y+NY5dSELTIbgraFFzPrt7C6tDHz9crQWOdztY7uXuHnnHdH0YiiQ6cSOO8v1GqOtGwjtWE73jgNs2aortLXyubYD/g9ariuvUtqy5iwUjhwVtqSK3w4RRxixQ/DKtwu+tV3FMZ55ZweWFm/Xoue35G1rTJSVkW0KynXjdvelt7//3bclXXfoFbfs/Zk1PHyL4cpp0s+gygj9K2Ta3HucZfG/ipbuFGcqYr707/XaCY3sa3k8Y3cAHHPaaJUpayOk0rO3FDoycqtZz42qh/RKBP/ZcdxTPmSNGW/vZM1znOY8MLofeI90WFXGwIjbkdpQbNkoSPQ2DDN7BxqNyaxkb2HZSnXeFWWOZSv39MLD6KSnpdWSGBtizdaVsNpQF2skvmMwdA/rp7wrmbY0ZObePSG9I95tZAGKCGSKpHrvSU34u44EJXq672On8BDLic8yF96jjkB4HDuetPVVRnT4C8GZ29uB1RIl4aanceXVL
 x/g5WTyr
 Le5sU3+a1IPHH7W+lLLnMs9e5SxJ/j4STh3Sf+JPRAQ86qZQXfMGA3NtKwcRRkP7qeJKOmdTLEQmQo7REqI8RctL9r31eixzkKTUA70zY/olqO5GJ+W+E/oNPxTu6vbYsJg45SZ/+LYHS9of7OYoD5ksmbgCzsdfYAqYMVA0Y8j/qUl95Dm2E3jVA38hK55B9CyRrAyQCXa5DbL+1awD+z7yxun41Fyr19uyjbZLdpIaVo0GRLa11Ld1gdlmB2R0eSS5BOutxMZNt2r7I3wIiJrYN7JAeKJXlF9ThZIAFb4fKa7R7Dk54Gm1v/6nnPdwZkvlW7Mr6274Bavu9r6MI+F3BNu7AZN7evY510iZX9SYYcaKFKMqa+Ab411oYtsGdqk+J5VMuGrwhL7CNh6ALaJARng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 07:13, Dev Jain wrote:
> remove_migration_pte() converts migration entries back to present PTEs
> after folio migration completes. For hugetlb folios,
> page_vma_mapped_walk() returns the pte pointer to the hugetlb folio in
> pvmw.pte, but the code reads it with ptep_get().
> 
> On arches which provide their own huge_ptep_get() to dereference a huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(),
> pte_present() etc to misbehave.
> 
> It is not clear whether this has a trivially visible effect to userspace.

Right, for non-present entries it's even weirder. Fortunately your patch #1 also
handles that.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

