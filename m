Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACC9CF8579
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC6C6B009E; Thu, 20 Nov 2025 04:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3741A6B00A3; Thu, 20 Nov 2025 04:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289DE6B009E; Thu, 20 Nov 2025 04:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1719C6B0095
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:32:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD60089B8F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:32:47 +0000 (UTC)
X-FDA: 84130470774.29.1AB6BEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00A96C000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:32:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tEbsCNT7;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763631166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmorG3aXu+HgfxDjXlDL6dLzU2W3dixWyf740A/idfY=;
	b=IrPDGzExFhqa2HOtzTfCijsF8Bnej9l/aZTB+0Bd8Bdw9FMnA+QtnZCaEy4ukqGs+Utu5V
	CYrfN/FtpQ/TNfNZ2/xtPILIgPO75NFEoxSFTgidRbebULzC5/iwOjuKZsmc6oiTFpeAcA
	GapUXz+i1LY55hJkS3C9+708KuxDFO0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tEbsCNT7;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763631166; a=rsa-sha256;
	cv=none;
	b=XEZ526ytxz0Q40zGdLmW+yETltnocZCiCGQ273FB7xF4WOn2EiRbZnNmeX/k7YxFikIAQw
	WPqx0eW+hCuD1K/0cvCUqZ1EQVlCM+1T+5LQSUDm2CBIYqjoDbwAxJyQGNwnEkFmkUCW8n
	Ki0JtcwEWn9FmT4tWYAXNNZEHmQpLGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 033BA40934;
	Thu, 20 Nov 2025 09:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0D2C4CEF1;
	Thu, 20 Nov 2025 09:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763631164;
	bh=+3Av/NkAd4SGgUEuqhxitG7xEjFBYKfNAJ67LMoIu0Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tEbsCNT7/6gD+1ivDvWJzbRfMK0JF5Hn708L0V1QUzk0H0SKcuWsKEvBto7xeStWX
	 xQEicYSvZaFivvw4nXZoP4VfjRSB+JTztJHOg1jVyqjkXUx/TLaU+6HgiQtK3HoLHS
	 RFBZwemGeYUdzS0Rs5O7hExIJpZN3Ny2ZysqYbpSjMczVP0Fkb+ytHmfl4G6suRVG2
	 iYInV3CcixdMMsKQRIXBWB0DfcXByqKz79hT/ZpaCLZcnGmX2om4OE3CBKPcIfOh2q
	 Gif6vpp3d+1NcoUe2FCOZdU5MZJMuboA6MhZYQs0+fyws6TndBtE8mKPFiBHMnRkpP
	 WH9Q7zLR238Ag==
Message-ID: <3c332dea-ea60-4939-9843-ac7d3068c7c8@kernel.org>
Date: Thu, 20 Nov 2025 10:32:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fixup: mm/huge_memory.c: introduce folio_split_unmapped
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251120030709.2933665-1-balbirs@nvidia.com>
 <4b87bd52-5582-4599-8a97-38843e27d0a7@kernel.org>
 <875a9449-fcdd-4aef-9d77-1703dd02edf0@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <875a9449-fcdd-4aef-9d77-1703dd02edf0@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 00A96C000B
X-Stat-Signature: 6tywwiyggj5g8ebgzqskoi639t9ytzmw
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763631165-625304
X-HE-Meta: U2FsdGVkX19NFBBi7MCq3FlyX+f1OP8Hrj6vgxYNak0N4wNGfEX5pDKIvNrlK04wdnQENfgBqG0vyVm6/X87B/Bg1eksZ1FYraapnAalgyfBLJVlVJhhSrl5iwhuIYPCrWbB3SlGpASwJ6P4UlvH7ioxAk5OaqkuQL1cw6v1UyIKUcJBz4STe0dvDvBiI+cdFTnI+e8YZpkSeeRRnyZn3iRSWvu/j2o4oNcMN8ywRpFKOMFTxooiiBcC/zo45J7iZTingX6OeyKcMIAdR+oI8CnA01BOhCMz/LOU7klvkj5CDanPKHGta39AW6aXIneVENrt7nhdr/I5/ywMaGVTj8HF3RiWagcvqvfrDW3890eZP4lfVKqcasHYkxxRiCTSi4HEYESgaPNP7nh5nyTnasA88LQqmCF4UhQxUxohzPLMkf/m9S6BYS3psMEfRToNWxwIjJXkmA+ZV8Dn0ILiAFN98/5i8WlNIMY00AryFHGJ0BDRTmRlqbQhfi+hhazfADRDycR7OpOCkvLT3EnYMDlu1qXvKEO6zPMdToAKHyRAr4SlrcIPfkF5WfP17+qM0zHgxyi9pbpdST5NizfahaFCN0QlboWbo8e2D5uRcL5+ZYDwy42vEX/dNSusO5pOtW4cJ16MhecP9v8rMnsZ8wuDALbiYEtC7Ez4zy/9f0Sgtg8kfLI4ID+nkZiqlhNa3qBea2PFGbxSttfSKWhXEjlFEJ45s6sFjvqb61UvwlybV/nWQIprA0J6GsfKO/Gae51X2CG63cH/N3UoxMAOaJeWXTaMM2qHbRBsBAANat6mhq96r3nkFF1Z2NHO8sd6Nce+rJUwxiQ/gQcaOn4ucy25EnKDVbuFkvcBt3b+MyC+FuOA/sMiekcmQtxd3RYkKmoCKOLwlTX8HKcu71x0oYGYlUvh1+jvuzETHBwd/1HaxvAHZQtTL0yBVG8E2y84tikwq5u7lFfu7qsX+5c
 g+LTuXMu
 p1AZBUQmHR3KMPP7xpKxgpL6PBVHkztRskcBpB9LKhGGhcsrI5NiGVHHLP09yPiGio2shD7mgUk61sPquBji44oj/v5z+lWDeObprYeJfsn8Ch9dDDIHCGQcDc62RD5FqYlaXCp68fjRb95pU8kEskBun0K+MPGMxzeIlspzCwklf2yo7L0oOPIywvJn1XF0FNHsHTwCDg1zGXsS5vjj2TFBD0S4xdWmEnzDGBF85PjWNd5bKTjvNOg2xu29mrm43/dY3BFbN70w3rcPcSXpqVMnzJy6pXL5Ljmc0bSt+8DAly0UrnotFYY4DaLAFRt81VwxAwOVOW/FVkiXbv0F85s2XjHFVigOt11gebwy2JaqvLWXSQuV1oYaOHee6iMLCSYEsKcndlUk1guGxg+tDNFD7NleYGjZrkNSsocJuhUY6WM86qsh7MForL+1BexRxp5IQywPREMvHfzqX08iGg+RPQVdhPZO8W4mNSe27XLNMz6VQ4z3lsWvK+uKmckrEuRIdLOnmZc/n7nCeannv1Jl7nEUOHybaHmyNCcOK3FcdphKzvgKiz09+v4YO4LhppAXUCLQpB84DDWImquOgj+593+lsdFTRiVY/cAMwAt9T1+PJlNe38nVOQuKlDl/eqed4ocwnYE8o/M1EUoQwy7liu+hKI/K7HZVny1l0XkfIzoJU4PsvDUcM2VCHTRrzox+o2y+VCtG5uRHT2/PwLnX7rwg61uVuFplRsOzmvTOB2tqBfu+dWtfpIJchZHNRdn8SdUWMQKaQ0jGIfnyPtQZpm41jb28MRPzDz37QRR/DTRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 10:25, Balbir Singh wrote:
> On 11/20/25 20:09, David Hildenbrand (Red Hat) wrote:
>> On 11/20/25 04:07, Balbir Singh wrote:
>>> Code refactoring of __folio_split() via helper
>>> __folio_freeze_and_split_unmapped() caused a regression with clang-20
>>> with CONFIG_SHMEM=n, the compiler was not able to optimize away the
>>> call to shmem_uncharge() due to changes in nr_shmem_dropped.
>>> Fix this by checking for shmem_mapping() prior to calling
>>> shmem_uncharge(), shmem_mapping() returns false when CONFIG_SHMEM=n.
>>>
>>> smatch also complained about parameter end being used without
>>> initialization, which is a false positive, but keep the tool happy
>>> by sending in initialized parameters. end is initialized to 0.
>>>
>>> Add detailed documentation comments for folio_split_unmapped()
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>> Cc: Byungchul Park <byungchul@sk.com>
>>> Cc: Gregory Price <gourry@gourry.net>
>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>> Cc: Alistair Popple <apopple@nvidia.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Nico Pache <npache@redhat.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>> Cc: David Airlie <airlied@gmail.com>
>>> Cc: Simona Vetter <simona@ffwll.ch>
>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>
>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>> ---
>>>    mm/huge_memory.c | 32 ++++++++++++++++++++++----------
>>>    1 file changed, 22 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 78a31a476ad3..c4267a0f74df 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3751,6 +3751,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>>>        int ret = 0;
>>>        struct deferred_split *ds_queue;
>>>    +    VM_WARN_ON_ONCE(!mapping && end != 0);
>>
>> You could drop the "!= 0"
> 
> Ack
> 
> VM_WARN_ONE(!mapping && end);
> 
>>
>>>        /* Prevent deferred_split_scan() touching ->_refcount */
>>>        ds_queue = folio_split_queue_lock(folio);
>>>        if (folio_ref_freeze(folio, 1 + extra_pins)) {
>>> @@ -3919,7 +3920,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>        int nr_shmem_dropped = 0;
>>>        int remap_flags = 0;
>>>        int extra_pins, ret;
>>> -    pgoff_t end;
>>> +    pgoff_t end = 0;
>>>        bool is_hzp;
>>>          VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>>> @@ -4049,7 +4050,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>          local_irq_enable();
>>>    -    if (nr_shmem_dropped)
>>> +    if (mapping && shmem_mapping(mapping) && nr_shmem_dropped)
>>>            shmem_uncharge(mapping->host, nr_shmem_dropped);
>>
>> That looks questionable. We shouldn't add runtime check to handle buildtime things.
>>
>> Likely what you want is instead
>>
>> if (IS_ENABLED(CONFIG_SHMEM) && nr_shmem_dropped)
>>      shmem_uncharge()
>>
> 
> shmem_mapping() returns false for CONFIG_SHMEM=n and shmem_mapping() checks that the mapping
> is indeed for shmem ops before uncharging. Happy to change it if you like,
> your version is more readable
Good point, but the questionable thing is that it looks like nr_shmem_dropped
could be set for non-shmem mappings, when it's really just a compiler thing.

What about handling it through a proper stub so we can keep this calling code simple?

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 5b368f9549d67..e38cb01031200 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -136,11 +136,15 @@ static inline bool shmem_hpage_pmd_enabled(void)
  
  #ifdef CONFIG_SHMEM
  extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
+extern void shmem_uncharge(struct inode *inode, long pages);
  #else
  static inline unsigned long shmem_swap_usage(struct vm_area_struct *vma)
  {
         return 0;
  }
+static inline void shmem_uncharge(struct inode *inode, long pages)
+{
+}
  #endif
  extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
                                                 pgoff_t start, pgoff_t end);
@@ -194,7 +198,6 @@ static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
  }
  
  extern bool shmem_charge(struct inode *inode, long pages);
-extern void shmem_uncharge(struct inode *inode, long pages);
  
  #ifdef CONFIG_USERFAULTFD
  #ifdef CONFIG_SHMEM


-- 
Cheers

David

