Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A41C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066B26B0088; Fri, 10 Jul 2026 02:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017516B008C; Fri, 10 Jul 2026 02:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F006B0093; Fri, 10 Jul 2026 02:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6C9B6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:51:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C6C8140392
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:51:34 +0000 (UTC)
X-FDA: 84971946108.27.74312A2
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 69C10180003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:51:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nivqoX0M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783666292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+EOd49UJOd0Hs2rJAZdYLRfuniqnHdpSf3dvb6ZXso=;
	b=ZCulgBNoLszOZRK5Wv42jI90smFuw9yXDWPhq7eAxw6bwPGKUVXo3nFPvJPnSGtqcRD9jo
	3GlQschpkE6jpm6HsViTSixuc3TwTJ/93i9le4t8FeeT4CjN66B1xKB35y351W2DF3ZvU7
	eBd/5HWOLKUNGJnOdXsbQyt8EnXSfeA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nivqoX0M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783666292;
	b=7oOh13QBEGFe/xGnmoyfVYm9L87cwmJb3/Opv50OQUFlqmnUv89PFvAzawMpW3Lwti3cs1
	s+BjuA6b+BMz8SBr5ROOVA5ZU0Jg+VxjbDOrwqhgu6vtOo6i9B2JAXlv11HRw25RTU2uha
	2Rpu1IUoiR1ocmvNn7pKj/oVlDeTcXE=
Message-ID: <4d8e0125-0630-4070-95cd-acec3d626329@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783666290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+EOd49UJOd0Hs2rJAZdYLRfuniqnHdpSf3dvb6ZXso=;
	b=nivqoX0MCv2W6gMLb6RZcwdDAmRwpMKJJwxNzTU4O8nRQJWfkA3q/hfildPz5E+//ji5oz
	9H3wNOmjwHpyu4rslf5Ynxrla3pvDiE7qeQghvjQDPLNE8fT/k3LKDsECgz/iAM8Kn1XmR
	Yb/rTzZTugw4Xlb3vdZ+1c/cUe+YMfs=
Date: Fri, 10 Jul 2026 14:51:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] mm/page_owner: use memcg_data snapshot instead of
 PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
To: Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701061101.344679-10-ye.liu@linux.dev>
 <0E890CCC-818A-47DE-9D1C-9EEF98CC758D@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <0E890CCC-818A-47DE-9D1C-9EEF98CC758D@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 69C10180003
X-Stat-Signature: 4g945u3m15ojj4c9n4th5wpb5fhi85c5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783666292-24527
X-HE-Meta: U2FsdGVkX1+fp5DWvPxqJxsRXIv5r1F4UEbCa2g4rG94EWruNHgY7HPxliRohHp/3iMqmzWlKWHE7lbx+kKRGwwu+oTj0DIQ2KZIM+8ylqufbHLru1c0rgWOIdNTIxJwfg9pVogo9YJ2t7C44BxSCKQZNerbEXmAGfeVQPsJ+7rCYoCU4ef0MOv+dOrKQMmpSx9X1TtawCONWxIkZBZxtHQ6amU81X/WBWlptWJRmj+uml1CSnfjTjnNZ8NipwzxWqM/0YDLSXMasacXQvY/pzu7PoRIsTn+lMhe5gfQo6A0T6wpOpfY9SRcIZV4axgYC3l8IR8dh0Ww/DGPYyWVTJv+rKUmgdYz2T4UXfJDP7TbN6cRDpj253svL817v/SOYjQTvpyDhCaAW0rHZHY+6Jwtfa4HPp4B+n0/IXOX8xYKizIDpM65slEi1yBtuuzexy8shW8oLhZje42Y6aGZDS0AL8JTazPWGZObU8fxSxQrLOW4BQJJUNrmEzhKVNO6LTyVF54Y2Q9IvXdR6pI4RYPRlaGSktFesK7QQjveOfSuz00qR83evwyMWu8TcSjgbEWLpRU6Cx8PHz15334NJcQLsxrGTbeqHjebL/j+F9YTwqw+IfQsa9kp/9zO1+mdI0L/4hHe4YDrwKTtGnuQDaZehTpC5kq5xkBOpRNn32+5oWCV6+4zhTs1TXca5IE+nuc8YpAQTuPqVWbykyXMFA0/dT9tAqiXkvZIc/bkAFIgXPP/447iR5zfX2n3GhMp5wFb3jiWK6TYyaKiZxcNrsfEhIPjy4LkAF3vl0JtJ30x8FgJ9NJbQD8ly2sNevX4qR/56/5JTBtd2U7eBJyKEoPqXDkcCXo1x9Yc1BA/DUlq+j3nI+SHix8J72rO6M4yTRKIIHGe2iCt4VFB0ZmNsZavOg06SgwV/3t3q1VEzpveXVh3LSs02c+U8Y0f9BXQYaSJE/xcFTuxqk+iITD
 hfsnYWWz
 docheMxZNFz1uDyasly2GVXtofz6IxMlCg1j65Wc2q7pwX92pl6yjbBVQ6BPFGS0DXwUaCz/HBdDMC3S9w9pcCDSAyaAikU4ef1kZohUOmoX4t9NgEbdLHwSoCdsWw7afO7113uhbzFoEOU0FW5615J28AGR++Sp47Sv0DJ1Mv+lu+CSKbTblh2xXphFCejj7w9bROdls42/Hxp5rFHYB1GPTI6I4lY7Coualg1SG0ZdW+IFXb1lfz37+MRKgMkAcZNqj2rT35knQ1dT4gbnwjcyVfNSdr78HIWbFdI5Q2EpIyYAXafuUF5mdN6HTh2JJETcWifHnWjpPgLKvi4WnYQj3n3uxMzScb6siy4mn/HwRhrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/2 10:02, Zi Yan 写道:
> On 1 Jul 2026, at 2:10, Ye Liu wrote:
> 
>> print_page_owner_memcg() takes a snapshot of page->memcg_data via
>> READ_ONCE at the top of the function and guards against tail pages
>> and NULL memcg_data.  However, at the end it calls PageMemcgKmem(page)
>> which internally calls folio_memcg_kmem() — and that function re-reads
>> folio->memcg_data and page->compound_head locklessly, wrapping both
>> in VM_BUG_ON assertions:
>>
>>     VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>>     VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
>>
>> If the page is concurrently freed and reallocated as a THP tail page
>> or a slab page between the initial guards and this final call, the
>> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
>> causing a kernel panic.
>>
>> Fix by reusing the memcg_data snapshot already taken at function entry
>> instead of calling PageMemcgKmem(), which is semantically equivalent:
>> PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KMEM.
>> This avoids both the TOCTOU window and the assertions entirely.
>>
>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>> ---
>>  mm/page_owner.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
> LGTM.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>Hi,Zi,Vlastimil                                                                                  
                                                                                                 
This patch still has warnings (see sashiko link[1]).                                             
I've made the following modifications, or do you have any better suggestions?
                  
[1]:https://sashiko.dev/#/patchset/20260701061101.344679-1-ye.liu@linux.dev                      
                                                                                                 
diff --git a/mm/page_owner.c b/mm/page_owner.c                                                   
index 2e3880053a34..e18512a49e38 100644                                                          
--- a/mm/page_owner.c                                                                            
+++ b/mm/page_owner.c                                                                            
@@ -540,6 +540,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,  
                                         struct page *page)                                      
 {                                                                                               
        unsigned long memcg_data;                                                                
+       struct obj_cgroup *objcg;                                                                
        struct mem_cgroup *memcg;                                                                
        bool online;                                                                             
        char name[80];                                                                           
@@ -549,11 +550,14 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
        if (!memcg_data || PageTail(page))                                                       
                goto out_unlock;                                                                 
                                                                                                 
-       if (memcg_data & MEMCG_DATA_OBJEXTS)                                                     
+       if (memcg_data & MEMCG_DATA_OBJEXTS) {                                                   
                ret += scnprintf(kbuf + ret, count - ret,                                        
                                "Slab cache page\n");                                            
+               goto out_unlock;                                                                 
+       }                                                                                        
                                                                                                 
-       memcg = page_memcg_check(page);                                                          
+       objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);                                      
+       memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;                                          
        if (!memcg)                                                                              
                goto out_unlock;                                                                 
                                                                                                 
@@ -561,7 +565,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,  
        cgroup_name(memcg->css.cgroup, name, sizeof(name));                                      
        ret += scnprintf(kbuf + ret, count - ret,                                                
                        "Charged %sto %smemcg %s\n",                                             
-                       PageMemcgKmem(page) ? "(via objcg) " : "",                               
+                       (memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",                    
                        online ? "" : "offline ",                                                
                        name);                                                                   
 out_unlock:                                                                                     

> 
> Best Regards,
> Yan, Zi

-- 
Thanks,
Ye Liu


