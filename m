Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605EB606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gpuPjbek
Received: by kanga.kvack.org (Postfix)
	id 87ED26B05B1; Mon, 23 Nov 2026 01:39:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807726B05B2; Mon, 23 Nov 2026 01:39:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEFF6B05B3; Mon, 23 Nov 2026 01:39:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCEC6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:39:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1E55160494
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:39:36 +0000 (UTC)
X-FDA: 85465432752.08.45AA193
Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	by imf28.hostedemail.com (Postfix) with ESMTP id 90889C0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:39:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gpuPjbek;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.36 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795415975;
	b=v84uXSv8b90BEnxu+J6KV9gZvvWNWjM/nfaujoWdoPQeWHu219wqbwuFvWNXcHy/zL6Zh8
	hhY+OPZBIjgZgpsuqNSNL6Ds1PsVSQ4yebr4wffNWUFlAxoMydev6MHd3c/9j5GmMTPNoX
	ljso6gqaq/2+LufJpUDyBpUZYjKmWac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795415975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1S+FjIq6iQ59JuCSrkDkJDXNBT3bARoAzrzzdcKK3hc=;
	b=raOtX6+O0Lu1I/Gs3KUfLjTmqnfiw9CDt9iD1vAOVAhG3ugxl/kkLoJMl+el2h1HsZQ1Cg
	eUNkS4OIKtpxx1EEmbrauF9L7qwwStUQJARfwrwUIPd+gYXUOgj9P7mfOkAxLSd8J6aTk/
	uAPhtcLkzjVhZfDV1FMVsr+IYvpLtBI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gpuPjbek;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.36 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EGI+hFYSI6qeyRcfjHp8n/r3RKOt4t3CJPzrN5D49Oc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795415973; v=1; x=1796020773;
 b=gpuPjbek126+k4ikzIEVnpzVvCcwh8lf7SHiElMR/xFmDyWR+AmS2CpWX++AkiwuZSCIHli+
 b7uYGDaqJNKoophIy6kfGgY4yH7CruzYv2JLoOb4Jxn83J6wInJAOBosabRtD4fMhPB9kRTAvuj
 JoxmP4rb5FpRe47vFhXHog3k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ebc62440839800c0;
	Mon, 23 Nov 2026 06:39:33 +0000
X-Mizu-Trace-ID: ebc62440839800c0
X-Migadu-Flow: FLOW_OUT
Message-ID: <240018e0-02c1-401a-a979-3f867526191d@linux.dev>
Date: Mon, 23 Nov 2026 14:39:22 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/11] mm/mm_init: verify zones for
 template-initialized pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-2-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4p6j1gk4jjtgi15j1yiz9x3w7baei8f8
X-Rspamd-Queue-Id: 90889C0004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795415974-34286
X-HE-Meta: U2FsdGVkX1+rIm1tGqSLkTYgD3nn0rJgU2Lshbu+RLtE+ewGPU4vP4L2mhU2OOGAeFBm/i9N12FeOphJKNUu5PpEeH9bwnMWpPg9XJgzCsIovqbAHsdo1+I395pwV8+muaxYL8Rk7yD5W3fwDqp3MDlMaQa0DtQmlkref+g2537KaH6y3Bp5u1qeIOKaKaFUQ+kDF5p4xpclic5UzIkpEe5WX/2ZF+oqU4Bl8GfoiFMy6JSqp2LYpaE+vZuU0DQnOoFUaZa6etgYCICF1DN6KJ/sWXElbkQk7n5+xO3i/hcRCSI4Qv6yFEDkXbnFPqSUJUkU8eFuPwSPVmowHtUGOBnUqXPJpvIdFik4fCT+IOzi2J5XO5bNSXsiM8n0DlA5SaWRb1VcVJYITpMvi2tSk3jHVAeJ7zoEg638WmTNkbbLUe6FNpjapQpJPVQ8OOG8bKJGbVo+83hYMJqdbeoG9k6FXEH06Re0lR4RfTlV9tVd06x7+gHh0e+W90VrqgySIxvk2lYjlz6G2eWTh7WQNTSIIIoMyQizZML6yj/X7IaqCsDAJJQgMElvkc17SZGAW1Q5510J8ooMBMFd/5HSeaKqSVFGVJ5MNR7ePhWjSmxp2oEvS0s29IW6C19gmy12UEsryACoZYi0FfyH59Puw9i+KzXxh+vpnAtmWee4MWKix9Lbz6tvPxv81J8pATR13lVv+lNMOG5vNBRsICAMX8UWfUKJVb1a57COuNAUQA7nOI1oIbFeDmolsgKYdEapxVM1997rgEhM+gVsD/YrlN3gQMYufa5cDChzuNl+2ipEZSwUN120KN5upgI4iIimPDxIXFp/tjdREV3m+C9vsX5mNhdQTyhipPDX9mO4u+ts5OM0NQawy5g9UNh8rmLRbIUsShW2zJGLkv6yoVeCNqdDMPT+sxIq9JVVNJ7CjhDfRsk8rtR54csXIclEmebmf6oxWiGyf8Yei11jR9x
 BOWxx/h7
 yO068WtmNQp2xeUVkm174tw+gqswghxDQi8v3gDA66WkWaHNqZ8l11i8yvwOkr4kPl9QfsG04pGuFEtJYREOd3AtU7c7Z8Brh4YKqBce1guRwjQYzY1WKDaBL58+rM1+yO1oXUWOCAP2YnccSo8iXffnXX5+/VUc/tEDCA8AvCgP85Qvl1fZlfNGG8pDHdUpARRT2GIOsMZTxBOV0dXKJwm2BCT2l5a+CaiB5rIKpx07ZM6kqCZLXWQMwi/9iiNXR1Q56x5ngYAbMrm2ZLpJpo3xowEyCwssIYLeRJh43H6j+skSCqWu4gQ/wtmBloQ/wG8dDSJqLVfKVP0YhgOTejyQSdXj9CjoA5XkdpBrNtWBTCXNn3pK+RfGkQrSqtgAl93J2y7zKbYaSc92IrFdNFYPVP6FosiVuDKRgmqAZ0vzQQ60X4Um97pcsrqrECSgP8zQ5gH8bj7dquEjW5lqg4Th6UYsKe8htL3j7/dtgxX5RoCJgO9ti81glF7jyhmSU4+RFPTQ1JSBMpUOZBKi7z+toIIKf8+zcTBUr8hgjZczKU3GvDddsEIOHV+kOnLyYHiPihArIQYdJZjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

On 11/20/26 6:08 PM, Muchun Song wrote:
> Template-based ZONE_DEVICE initialization bypasses
> __init_single_page(), which means copied struct pages do not run the
> vmemmap zone consistency check.
> 
> Verify each destination after copying the template so the fast path gets
> the same validation as regular page initialization.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> ---
> v3:
> - Retarget zone verification to
>    zone_device_page_init_from_template() after integrating the helper
>    series (suggested by Mike Rapoport)
> - Collect Reviewed-by from Lance Yang
> 
> v2:
> - Apply the zone verification in memmap_init_page_from_template().
> - Collect Reviewed-by from Mike Rapoport.
> ---
>   mm/mm_init.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index a9d848c92678..0129152b74d8 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1082,6 +1082,7 @@ static void zone_device_page_init_from_template(struct page *page,
>   		set_page_address(template, __va(pfn << PAGE_SHIFT));
>   #endif
>   	memcpy_nontemporal(page, template, sizeof(*page));
> +	vmemmap_optimization_verify_zone(page);

For PAGE_SIZE-aligned devdax, dev_dax_probe() leaves
pgmap->vmemmap_shift at zero. When section_activate() populates a full
section for this pgmap, it records compound_page_order = 0.

   memmap_init_zone_device() (pfns_per_compound == 1)
     -> zone_device_page_init_from_template() (each template copy)
       -> vmemmap_optimization_verify_zone()
         -> pfn_to_section_compound_order(page_to_pfn(page)) returns 0
         -> vmemmap_optimizable_order(0) returns false

With CONFIG_DEBUG_VM and CONFIG_VMEMMAP_OPTIMIZATION enabled, the
section-order lookup runs for each copy. The zero order makes the
condition short-circuit before either page_zone_id() call.

Once patch #4 splits out the base-page loop, could we put this check in
the compound tail-copy loop? Like the following:

diff --git a/mm/mm_init.c b/mm/mm_init.c
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -734,7 +734,6 @@ static void __meminit 
memmap_init_page_from_template(struct page *page,
  		memcpy_nontemporal(page, template, sizeof(*page));
  	else
  		memcpy(page, template, sizeof(*page));
-	vmemmap_optimization_verify_zone(page);
  }

  void __meminit memmap_init_compound_page(struct page *head, unsigned 
long pfn,
@@ -754,8 +753,10 @@ void __meminit memmap_init_compound_page(struct 
page *head, unsigned long pfn,
  	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
  		nr_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
  	/* Initialize the tail pages from PFN-independent template page. */
-	for (unsigned long i = 1; i < nr_pages; i++)
+	for (unsigned long i = 1; i < nr_pages; i++) {
  		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
+		vmemmap_optimization_verify_zone(head + i);
+	}
  	prep_compound_head(head, order);

  	pageblock_migratetype_init_range(pfn, 1UL << order, MIGRATE_MOVABLE,

Thanks,
Qi

>   }
>   
>   /*


