Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13609CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486388E0007; Mon,  6 Oct 2025 02:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436C48E0002; Mon,  6 Oct 2025 02:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3738E8E0007; Mon,  6 Oct 2025 02:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 230D38E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:28:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4B3B140470
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:28:27 +0000 (UTC)
X-FDA: 83966710254.28.6E1BA0A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id DC6D940005
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:28:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759732106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rut9gNioGVBEpl/OANFf8C5yLkZGCL7QXNNPU8ZJ+FA=;
	b=szSFE/zTtCtAzmmfsXvNffFvwiBJxPMowFOfhpgIXigW4aYPCOslGmuUOoflkvQcgvEj3c
	jU2l0av7ML2EwZ1F/lXsX21Xpo12R98sR4yvKhR3JKDJMU3xoBSGWi0BNQ/iRswU8urNt7
	rDyzzyXXtW+m9zUSUtR1lUEgX7IKLVk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759732106; a=rsa-sha256;
	cv=none;
	b=Jgp0IZLKYBQi461oKkBtUExDgBtOTtl52HG8Op4AZisK8aOeyXXSS1F1NuUvWQYnFy9+W1
	xN12JpqwtF+3u9WvLdQPFL9D5RKnUjNwEuhj7imng/VIOqlwUPqZatnOkjDZVPmMyGr+DR
	+JaIqzBSioyO8/c9EfZThMLEFjjY9DA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B93451515;
	Sun,  5 Oct 2025 23:28:16 -0700 (PDT)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F8013F59E;
	Sun,  5 Oct 2025 23:28:22 -0700 (PDT)
Message-ID: <1c948262-e201-4473-b156-8b90fedc9ce7@arm.com>
Date: Mon, 6 Oct 2025 11:58:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/dirty: Replace READ_ONCE() with pudp_get()
To: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
References: <20251006055214.1845342-1-anshuman.khandual@arm.com>
 <4b513d32-7795-4998-98df-d398c3d5462a@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <4b513d32-7795-4998-98df-d398c3d5462a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC6D940005
X-Stat-Signature: ngh13jxzn89p7da6e8mr5mzkqfh3yiju
X-HE-Tag: 1759732105-898929
X-HE-Meta: U2FsdGVkX1+7n94AG1/Ny6UphKz31N4qe+FrYWqI7KRcSGX2M1CNLJyQPx+z0HigE/3BRmStFHiehlE97TaqtOHmFJWwCXFDRPwvXJ/CiLoP+LUnIUPt0nQwi5SAdgfySCzlrOLyRKPy8WbDm6sBQg+BPyw0gUBg+3FBGaMGa6UqHzWLnfmvGT6QO4ZVSqiZcSguM6ef0FyNbKyooI4xCiJF4BT9hvy33FW0CEQMmjYZvRNlyU9tzBrukmnJyzuyAXH/mZEnlqNXr2hHL38P89HPiOSe0trRYjo3BDGSfwbJ5LHxtNxKlcrklgjGhd2HNQGCsCr9etIi3Nt+2DyB5wedQKa+2t3Qwejn5iEqig1+tq07PjbYOlr/WwiG8/qfeDIKHetB67BGvgpDQUhff+xpi+T4j1Isa8crGm+ktsBD4cdh0xj/PpRYC6hRJ8eipsJA1mGBVsD5lyS1vE4lJSHU8SS8Fz0ujHcFBPoDRDTVBQt8D/wDtiq3FLn6ztuu4z9Nn55Tjcy83WnsdJ+5XOOni5GRaSHvlZvvF+T8KzBXLG7CaTouOkpq1fE7sd1XZ0vIbZr/kzHGNvOX+JMrOeyZ+eU0fOcdUD/P698CIs2mvLJbENuNvseLJ+yzjyb8/Ty4maAmA2aWcsz8o2MmrtYQM8kHnaUzgeSf5IEkjz54vROfB2aZss+7tx2dK4oZmPGrnvTpOhcxchsODaeMjHoayPtW4aMmy/ehz/WcEabUQTs3kBfcj4Va8I81n8F267+KV7ntuydbRymu8+Vu0u8/ePK87VK3XKyjcnajr+a9dZfez+e0QNCSwNj9ZwEqs0rEC2C9iXdlUZY0k1JS/S3RI2GOiPYu6DpiT4fV5WUlxQs8D87ozoA8uXqn4yfiCBH5BrXjboEtRc0xWrm70Epc6KbEBWUkthm0IWuQNlB5WqzuuPXK/M+UvQMRpT4h9tPMcmzRstd9h/VSiec
 AYGOmi1A
 bBM++sm1U4ceKUT2PpWehcw7xZ58kM8nxBvfXo7+z1j1o52pe2Xjiab80RRaz1LQXpM2eIG2Sg+u3cpwHe6q4BOX+Z8A+BanY87MLaGxUWUSFkLanRnYNwiETa7DZ8umes3hlqSI3tnPBmWoRZrWtBi1OkqkgJvCmkX5WZ1KIkAZyMkiUbog9HN5CsZVjq7ls6Gg2vD/cs5OT4P+Ix4LdzWg7YbZP6fVKBscepmS4vdvZwuV6VK4RvJJQoG5h0F3QmaNk6emmL+PK1HLDr4iDqQ74sDpqVwjrfIOXgWiTls2u0OAyhDBcmgsn3qP+imATDPuT0dviy/EFguq4poJEjBt0Cm1t5cF2f9EnICnHYBf0a+f+9hL6k9f+mjYouRS/ENVu/tERD0h6Kq8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/10/25 11:37 AM, Dev Jain wrote:
> 
> On 06/10/25 11:22 am, Anshuman Khandual wrote:
>> Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
>> anyways defaults into READ_ONCE() in cases where platform does not override
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>   mm/mapping_dirty_helpers.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
>> index c193de6cb23a..737c407f4081 100644
>> --- a/mm/mapping_dirty_helpers.c
>> +++ b/mm/mapping_dirty_helpers.c
>> @@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud, unsigned long addr, unsigned long end,
>>                     struct mm_walk *walk)
>>   {
>>   #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> -    pud_t pudval = READ_ONCE(*pud);
>> +    pud_t pudval = pudp_get(pud);
>>         /* Do not split a huge pud */
>>       if (pud_trans_huge(pudval)) {
> 
> Talking about mm, why not also make changes for these READ_ONCE accesses
> in gup, hmm, memory, mprotect, sparse-vmemmap?
> 

Right, could replace all mm/ READ_ONCE() for pxdp pointers with the pgtable helpers
but that will create too much code churn in a single patch. Thought of doing these
replacements per file will be much more contained which is easy both for review and
testing.

