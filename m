Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23E9606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZXH+MRud
Received: by kanga.kvack.org (Postfix)
	id BFA7D6B05BA; Tue, 27 Oct 2026 00:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD23F6B05BB; Tue, 27 Oct 2026 00:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC17D6B05C1; Tue, 27 Oct 2026 00:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE586B05BA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:34:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01ABBC06BB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:34:53 +0000 (UTC)
X-FDA: 85367140908.18.046BD17
Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	by imf25.hostedemail.com (Postfix) with ESMTP id A96F0A0008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:34:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZXH+MRud;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793075692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bPDXwOSDS16plg0sE4B84SdEhQiLrfepkoN/xaCOWc=;
	b=dC/MZ78aZTjDxrhJd/LlXd3U9HAK4MVD++g/p1+sIwJ2BNw2zCpNr+mVbjBrcvU1IeFiBT
	eC1IxmJ6yE09n8VkqYiSi/AlxgOIksYzgNEDd9lg/QexOzKXkOVynIGXVV7NOnbIW8F9yg
	mRray6NDidTlSPr2Ic/IX5B31sT6Z0E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZXH+MRud;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793075692;
	b=fCgguQPClrYhu38XKdl23Gps9hNFoVZbalYJSWlvLPNjypxpZ/z/xDdi5lTUIcH878o54W
	8l8RW/3zIlM/tfwG4ABp5WmpITPVwYbyjOoQbNjlQJ72KsP5ahb0eGznoPqdQESvQR6udQ
	06z0+JFFojSgq8xKEEr3lTPvrJTrYUk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nzg0KAy4r17iWdtc1/Guk/G16m3PL2GLFdlHcOEPTm8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793075690; v=1; x=1793680490;
 b=ZXH+MRud0A9N6N3RBKQRDno4784HvX4suabk/vTqyGni5R0GEvknRJ3hwC8RY6qdYzpS8w8z
 ub8AU3OOyuVar2e0Mq0CWSPKhgysvo7ByyynhxlXatGUGxMQZ/FqnUgFmwNjvZ2w2SHmORsjzUp
 PiG4OK58ecf0OGzLDj+76xL4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7c7d843a2b7f921b;
	Tue, 27 Oct 2026 04:34:50 +0000
X-Mizu-Trace-ID: 7c7d843a2b7f921b
X-Migadu-Flow: FLOW_OUT
Message-ID: <1267a0a3-d3fa-49ee-a791-294e62c29bb6@linux.dev>
Date: Tue, 27 Oct 2026 12:34:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: move NR_FILE_THPS on cross-node migration
To: "Garg, Shivank" <shivankg@amd.com>, "david@kernel.org"
 <david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "chenridong@xiaomi.com" <chenridong@xiaomi.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>, "ziy@nvidia.com"
 <ziy@nvidia.com>, "gourry@gourry.net" <gourry@gourry.net>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "byungchul@sk.com" <byungchul@sk.com>,
 "willy@infradead.org" <willy@infradead.org>
References: <20261025110209.4105994-1-ridong.chen@linux.dev>
 <c021e641-f415-48bc-badd-d340d70dd850@kernel.org>
 <6372d92c7b0ec9c3fef4e803e39e54a36f3aa918.camel@amd.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <6372d92c7b0ec9c3fef4e803e39e54a36f3aa918.camel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A96F0A0008
X-Stat-Signature: 6c7tydkik97yn5fnycrpocykunxk5w1t
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793075691-485111
X-HE-Meta: U2FsdGVkX1+Tjao3kXdQw5ACFrr9nmLsmF3Gh4qf90S686EAcoKl6sgTAxQZhv0HZAtG7KpHoUcAqAe+uxVmghzU3q1cZQhWLWpDfLWnqQivK/JZ5k6241nbrAxCVPFeP4H43UqAavD29O/imKljneFJZxicDWeFNBi2JeNKKaZfAnMHBozy41s/s08cRQnZwkZ11NIULV88Q015tViQy9LDvMWpeVl8ocZrlrMQ+Pnioq8NvJU7K5JItZns68Elc3DRR84J9fyVgAIMyrPn3yOrXJOUQVtD7ftu6ZT8dQAgV4DaxmAtctACyADnTohh9fLpprLvQ7EgCoyaw3YDWMz8Ym94Pg7vAmWo2rZ/gI7nd3R2TvmNJde5P6YxaZmhDQG2i8liIpM+Bc86cvKvwAp/ynD2mmJSnCxW81zucVgbDERHIA/deHPqB9t6zvplb9m5kvmeXuwq9ClUDZVwZ5n3vWZwXR4AM9vxg5LKTvla5xbCQrB/KY1Ep7106Qz0I/r1gal6+2WzQ4mnUHYFv5TgcNsvQQLaeEZcQzK/tYNLlHh8XSy4I+QMHVEGFL6OrIjBXe84yPFHO4njwAzBfEsOP7DgZKJovu79L/cEnoYgCktzFKtYPRskWajzY1lkRB4eylVNL1uy25xnmn+XmE79lOrVGkoMVkEK70k972L0uTmfPqRPuMEaCDytrLSECG/h8FJnC5RA1nrSS5nidNQC5tW9y6kI6kWYnxplbVYbl3DJ1NNTMxYL/DPfFo7wiFHv+brN6/3jq9qIzV5BU1OCaAuJBn8sHfQLECR8ahUDclkRIxGRWybBRuKyVGPrui3Xkz5dEgU8oiwI6RvCin2+RzextIXjjeDDs88QgN+xEgds/VxDQWv12OgaD5XCDnFXV0Pv6nM2F8tTwMjhjUT/auE/PcGEHFztYklh9BQDeT+uZosps2VWp7QjYPnXOsMsf9+57Jrr2hq0ptl
 YJwwvxYU
 XhSCOemb+MA+eKSn1tek8Dl5qYIOO9jBo/uga2osu76uujEW32medPFSvom6KsNFBROtyr9MxJB9cltWKVqR6UgDO9VdYManl68XWVJJn9E/hEoAWum8tEs5Y/AmolEEfofvomT+/WCTeJJ/f6lilMrqu0fRfH62bQYwmGD2phTlcBrJwkCvWdYB64s6LsLXY3l1pP8NRdeM0FELDS4+1R2JyS6TtyIN+yljsyEGHCZFTLch6RXGxZgaXD8sibGpSxSg0+aa37ouQ7EaijDlqDZu91YT2bFZFq6fsKO1OT+W2fe4CiwSVfxClRAfdlEG+DmNpmvEX3UhqL2vl4FT6GFrTLFfub+Ub7jgStrHJrdhzYs8L0KSsftoTpRQUEimzK+3G5bXuo6Fxb0Rk6A3txwX7URXI1QEj4Q3hkRkunCtpilbKeVgYoJbLsEfa5gBoSOJtxhYOD7KM+uINLeYL572hsL0t670X3aIJ3aBCxp5NJ+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/2026 8:51 PM, Garg, Shivank wrote:
> On Mon, 2026-10-26 at 11:59 +0100, David Hildenbrand (Arm) wrote:
>> On 10/25/26 12:02, Ridong Chen wrote:
>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>
>>> When a page cache folio is migrated to another node,
>>> __folio_migrate_mapping() moves the per-node and per-memcg counters
>>> that are keyed off the folio's node: NR_FILE_PAGES, NR_SHMEM,
>>> NR_SHMEM_THPS, NR_SWAPCACHE and NR_FILE_DIRTY.  NR_FILE_THPS is not
>>> moved, although __filemap_add_folio() charges it to the source node and
>>> filemap_unaccount_folio() takes it off whatever node the folio lives on
>>> when it is removed.
>>>
>>> Commit 0b52c420350e ("mm: fix shmem THP counters on migration") added
>>> the NR_SHMEM_THPS case but not its file-backed counterpart.  Now that
>>> ext4, xfs, btrfs and erofs can all have PMD-sized page cache folios,
>>> migrating them via NUMA balancing, mbind(), migratepages, demotion or
>>> memory offlining leaks FileHugePages on the source node and underflows
>>> it on the destination, in both /sys/devices/system/node/nodeN/meminfo
>>> and memory.numa_stat.  The global value is unaffected, which is why this
>>> went unnoticed.
>>>
>>> Reproducer, on a 2-node QEMU guest with THP set to "always":
>>>
>>>    1. read a 256M ext4 file through a MADV_HUGEPAGE mapping while bound
>>>       to node 0, so its page cache is 128 PMD-sized folios on node 0;
>>>    2. move the mapping to node 1 with mbind(MPOL_MF_MOVE);
>>>    3. unmap the file and drop its page cache.
>>>
>>> nr_file_hugepages in /sys/devices/system/node/nodeN/vmstat after each
>>> step (in units of PMD-sized folios):
>>>
>>>                      without this patch     with this patch
>>>                       node0     node1       node0     node1
>>>    1. cached           128         0         128         0
>>>    2. migrated         128         0           0       128
>>>    3. dropped          128         0 (*)       0         0
>>>
>>>    (*) the counter has underflowed to -128; negative values read as 0.
>>>
>>> Without the patch the 128 folios stay accounted to node 0 forever, and
>>> every further round adds another 128.  The same happens to the per-memcg
>>> per-node counter: after step 3, memory.stat of the cgroup shows
>>> "file_thp 0", while memory.numa_stat still shows
>>> "file_thp N0=268435456 N1=0".  With the patch both are 0.
>>>
>>> Move NR_FILE_THPS together with NR_FILE_PAGES, using the same condition
>>> filemap_unaccount_folio() uses to take it off, so that THPs in the swap
>>> cache are left alone.
>>>
>>> Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the page cache")
>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>> ---
>>> Note: prepared with help from an LLM-based assistant (Kiro, claude-opus-5.5).
>>>
>>>   mm/migrate.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 7bdcdb57652f..d55f576a2579 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -700,6 +700,10 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>>>   				mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
>>>   				mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
>>>   			}
>>> +		} else if (!folio_test_swapbacked(folio) &&
>>> +			   folio_test_pmd_mappable(folio)) {
>>> +			mod_lruvec_state(old_lruvec, NR_FILE_THPS, -nr);
>>> +			mod_lruvec_state(new_lruvec, NR_FILE_THPS, nr);
>>>   		}
>>
>> Looking at filemap_unaccount_folio(), I was (once again) surprise about the
>> different handling.
>>
>> Key is that we might be migration aonymous folios in the swapcache.
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
> 
> filemap_unaccount_folio() also checks for AS_KERNEL_FILE, but
> __folio_migrate_mapping() does not.
> 
> Should add this as well?
> 
Good catch, thanks. NR_KERNEL_FILE_PAGES has the same problem, and I
could reproduce it by demoting btrfs btree folios to a CPU-less memory
tier. Since it was introduced separately by e3a9ac4e866e ("mm: add
vmstat for kernel_file pages") and is a node-only counter, I sent it
as a separate patch on top of this one:

https://lore.kernel.org/20261027043214.2248986-1-ridong.chen@linux.dev

-- 
Best regards
Ridong


