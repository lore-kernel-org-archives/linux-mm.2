Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83860CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5E56B00B6; Tue, 26 May 2026 08:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD886B00B8; Tue, 26 May 2026 08:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3196B00B9; Tue, 26 May 2026 08:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFA56B00B6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:31:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 549F8A040A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:31:09 +0000 (UTC)
X-FDA: 84809505858.09.E83DD78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6571F100009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:31:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FN9HaspC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779798667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMSIxvChsdu1V/cdy6UaokWB5ztGbjE2wCafo6jTDRU=;
	b=kEEL0OeIcq1naUCyHRYZW0RF3osMTHQ2ZWRFRhPyn32jD543S5FwkjgA6Xhw8liwDZLBho
	AS429tKTTzqC3jL8iGO3d+mfyPc0mA3tnNsPx5piD4jq3yp5ioMbZ5g7Rz7UqmBgYGCevw
	YWPhmtRNhr+R+HyVR4lH5ZW9SMuBQw4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FN9HaspC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779798667; a=rsa-sha256;
	cv=none;
	b=nPaDRLTgV0OWleffFt3Ea/Wdk7UQGaw046R14mH0l+x4YNYcJVX27wrahBGh0diA9QWueF
	n1Z3+nfWaUA4srSW5V598zMb601pZNo6brPpwzLmivjlYwruHHuapM6310MA8KTdVMWzu6
	ObLwrC0uFk6ospLPpnr5a+P5H5bUlyk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6279E43D03;
	Tue, 26 May 2026 12:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AAA1F000E9;
	Tue, 26 May 2026 12:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779798666;
	bh=CMSIxvChsdu1V/cdy6UaokWB5ztGbjE2wCafo6jTDRU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FN9HaspCvpo45qFUkCrH02hplPk1gBW2uGeTih14XCaOD8sfCm/g869W4yziDNgt3
	 YKudIUanXvtWU68PiPCDbtCPimZtF1DnjV06TYb0gnjB285yALRZoOGAxV1awxMUxm
	 BfFkFYSLOacWK5oLz8FoT72P6eBS3q2QYdBwhQPZZLXvt1b1edkO/3Fw8KDYeIh/DG
	 IooDTEi8jvk4wioMvL+w8hB0ahsCVoDFZ1ZRZe/Y6uvWR7168SzrtbK2m5Ju1sQsn5
	 zW4Sy/JmAyiUVXhn/vnX19K/fWrUWfEUrUb7Iy2kn+XlJ6nA6P4WkRJY45064oKHj9
	 WukAgd3mtnxaA==
Message-ID: <1be38262-53de-4a27-9841-393e12fc1475@kernel.org>
Date: Tue, 26 May 2026 14:31:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Vishal Moola <vishal.moola@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com> <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b8tyjy3xayzfbfx6k89yjf8fbdenxqgf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6571F100009
X-Rspam-User: 
X-HE-Tag: 1779798667-603009
X-HE-Meta: U2FsdGVkX19S0FRRj7bS6rl4WbkmszUcges7jQ+Kn7EdO/k79rKePjILjiJ2AYc++xVbiE9n61xtKNqAxJeC/vnbyn9PZXqgBbjt99NlP3Rg/haRQtgoQQbTrjvxSedgLnGzHNiLClY5HvmF7WUUhYVFYA+DAjhWyvlCy+87+S3GRHfDiuV6CATDcf4neCj0uQnqqL0dT42f/bGM2gOWYNkvf7VSy+wy+WxuHV6X/D/HWRnA+23bvmyDLxvFDgQ8QLEx9wyWfUI/30yJlncEMcCa4arod0tIFzXDtV7dFJLluXQUHrk2JXHdgI8KJeKCXNA1QHWh2F/1yPiHMu06+6PgGyrpXszR8DM9Qh1/Oahn4KvYO/Coy9F6ORtLHIvCHQXbdslTRSQAgafEqGi0ziMYCv6LX0A5+mxmg0OEKK4mstcOOypwQhbs+E/y8+IMFYrt+oeJxHs/Jv+oYDsE3BRtize6pjIz/q6Mc7PDgPvRRspmOrfXbqWzJ+NYndxpCltOMbtJSqDXwpz5sfSE/EPm4vYPA17qMAdK8vDefFFLcuK/LkQaSixBaZbpc+BD+cVz+5nbfqtZ0Ze66ZCP6Ql2LLaii/xyhllq3oXfWsaKmpTemoTo8E1eOJvMW0tiHtMSzooAuyvczOUOPQXkcTnDkhAjN5xU6Qd11H+J72+0gDzM04+/wZ9ymCXplBZLu1fIHo3a2D+VICpXEry48jt5LGUMxax+51cxcYVZEIQDqDMZaB876VSjrE9PlMm5xC6izEAv+WPOthVVAjHAajWgWudlBvBmhPhqlZckT/aeyQ9S61hbdfTWuNlM4tAHqqLw6OEbiiAaqgyEf/O5rmR6xWuWlQmC3ElwiBR6LMxmMnUwiCNcuX/8Hy54/DTX2U3htBWHGINQKIG43xVWD6R3AOZN4KFJ/zFEXf3sn70tn1tYoUbTlfOGV5BjT6nKe8sioYz7JQtttqfLgmx
 INbEYrDJ
 k8HQgRBQ+zzjUPz5+IKipWW9eF2Q6ZDYUUmH2gucPN72LxjJfnzC+4dIq12R2JMe21mb94oU1aiys/VO5OTK4kjM/Ns9kefU9qmBU6Su08jZmSygfOGMgtdE070lvBRi2oYFsZmMCci9Dxcu79Zi0SXbhhACmXX7YwEc8UfOyC8LxO5CJZDds9L4uxSg4OBbxqOjJv6ulxtwfTXAfNxe/3YUZiNPkeQrp2P8GIOaJNvAreqGLaj/nNEqC2lXvZVILukovTl4Dcd5Y5OSgn1GX6r3qNwgKrxEdEHjPwdh3kRHW9Z6j+44GVZ5kv5qrnYX4UisuctKQcNoEXGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 13:54, Kevin Brodsky wrote:
> On 22/05/2026 11:36, Vishal Moola wrote:
>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>> index 4c8959153ac4..9d42cbddce27 100644
>>> --- a/arch/arm64/mm/mmu.c
>>> +++ b/arch/arm64/mm/mmu.c
>>> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>>>  
>>>  static void free_hotplug_pgtable_page(struct page *page)
>>>  {
>>> +	if (folio_test_pgtable(page_folio(page)))
>> This should work.
>>
>>> +		pagetable_dtor(page_ptdesc(page));
>>> +
>>>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
>> In the case we presumably have a page table page (ptdesc) at this
>> point, we should really be freeing it with pagetable_free() as well.
> 
> Agreed, I think this is the right thing to do, something like:
> 
> if (folio_test_pgtable(page_folio(page)))
> pagetable_dtor_free(page_ptdesc(page)); else
> free_hotplug_page_range(page, PAGE_SIZE, NULL);

That code pattern is wrong.

folio_test_pgtable() shouldn't exist.

In the future, something is either a pgtable or a folio, not both.

So check the type against the page, not the folio.

-- 
Cheers,

David

