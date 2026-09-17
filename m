Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBBFC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32566B008C; Thu, 17 Sep 2026 06:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D846B009D; Thu, 17 Sep 2026 06:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EB76B008C; Thu, 17 Sep 2026 06:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCC896B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:05:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52994802CD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:05:29 +0000 (UTC)
X-FDA: 85222821978.03.A1B6654
Received: from mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
	by imf11.hostedemail.com (Postfix) with ESMTP id 55B714000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:05:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1JarKV7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.209 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1JarKV7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.209 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789639527;
	b=Je9WNUy4jIiaBapSmztN4S1u2tZjtKU/BggajIfhuBRcSQflk8au/VG3Db3uFC5W87OYZV
	5TKjqGAILbLDruKNssr+Dfpyy95jC3GaAboC/Q2Y3+Be6rC5wdX2I/KoEE6CbCBN5YkzN4
	B3CZ9Bk/ivftRnYVP9TgsI1zRGgahBE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789639527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hy5qF7E6/OGFnGn3QJpj712E+skXs7QyWTazkT10GjA=;
	b=2thCTFG58Z1EqLYLzIVhouzU804LLthHpdM8pISWksv+kht6VmP6QNSlE9nQVv59J6aVTx
	6i5CjgUasjpEXCQ8SB5tfnZpJTLeRH1weRrX/pO7MloKzUJ7QWofS3ZwH6AeczYetIRhxg
	2u2mICe6JT2SgJToIbbp9TWNaYaz2Tk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/tZHzVllun6wYA77y8xQTAiwknDz8pgNlCRFsI3jAaQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789639526; v=1; x=1790244326;
 b=m1JarKV7M95Mq42QKfMDdZaYwWiEr3ICR8J+aYSD7riHxtlODHAgN9uzF+QcgoVqiHMwP7/Y
 81CWhGMdJSxkSmnRJMby9JV1Gc69nF371FEAFPR5oNdCRE1bspChElQr4IIhLQepSVUwhia/1s2
 SZTlDEjDNhZP7fCyENJxZsEI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5049fdc33711d8e9;
	Thu, 17 Sep 2026 10:05:06 +0000
X-Mizu-Trace-ID: 5049fdc33711d8e9
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 18:04:57 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, Baoquan He <hebaoquan@kylinos.cn>,
	kunwu.chan@gmail.com
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Message-ID: <aqu7Sep9nHUS2DmR@fedora>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 55B714000E
X-Stat-Signature: 65xcy5gc5s96ou6ab6zbpqrms9i6q16o
X-Rspamd-Server: rspam01
X-HE-Tag: 1789639527-597339
X-HE-Meta: U2FsdGVkX1+K1vAPmhi6KUvFg8UhKBxgaLrVKSq3RxOsXuHv59KjmxrMkXyf4S6PRzOL61aB+vYoUpOXJ43B50TAYfRaoaQRGmWdIiSJaZLll/l3FQU5Ow4UVMpQhoPWkjZzAmeDvgUxh9Y0AiEvsOHDv8EDqZRSLR0GpaFHaRCJVDKU/XAiMOSm0FxCpU18l/1j9ipN3zN+Kl60dG2L4kgOnYoE00ydC7/NTRiMciBmyBWuYCY0mo+fBGjIXXLOVoo7XFJjLCOtzfjQ+jwPDboHbo+eSQkxB1qYSu6dmLtsHOMAahuK26q1HnP6VSBYHl/ihk5y69GGud+8rjH1Upp5EJIxF3/LC+mHi1Xw9V5C2+Ur3toDjief89Da8U7KpwfgyjxEyhRtIRtrglJ/o11Y0dLdGLAG6v6UjOpQ0yuTAGW0ZsMStNsCfQo31kuW8OJTXVXR8Ng4u3N1EJTGEAd/wekfK+3KWzaqOL0kDA8tO3waPxKOgWS7HkHJkrnpnA1E8ZctuB7o0LZWLrU6sGim4kK4IyaK1FEqRVXPnvUgYs1IsjwFDs6tYaBo0RdGw9xm1Mr8rWDqI/Zsv2Wu6lRSMQGS2L77NZQqQ40ZqvOhzpcODb9kN69ZpWdLjavYcXw7aEa2tM8XPni+2Orf07KIb0gJwPoYjIGxj/MimR+QsJSfPQ2iiGcyFEHvieLqe4aF5dPxPLITSQDf40zi8pF6afvY1ly8K3LFHLajeSFGgZNlmi7K2oVnOCU1wgwmpvqDFjUsQnNTn62suB/YHqxioXx/USSvajLM9R4WKcLPXeBkf1nrBgcAgQWnSAs7Lm4a3N1lSNzCBARag6meeuIW4y0jsz8ybLdbgA2LF6FFoLlqYify2G6oPjGt4El0g1hYljoenqlNaF0dfA8yxeKozx4JxwHvSQKX6y8Clt+mrV/8R7zf+GCgM5XK60+FicYLgWrzdHVneVRgGxb
 ALI2Bd00
 utTE357LDTMpPnUwqeOWvJdw8tD239vtrHXwwKGSqovNZPKo9fQVXHjixMoLP0a80jORjcnYk74Y0I1aItwipfNnFM/eS8Zpi7eaIwIc7aOrqL4JFP7K8XOMXuCVE0QQH1ORhpTTzDRTZPYIp5qLyKLc0UdEQRi2HaR4upvAz7MaxoYULcHCvfph1v9COrso1HNS7iWy7Gt1SFNtsOSksf9bXxPLr/iF1pLbB/915bDB/mtKn/f7Ljq4JkRIaeC7DCyRgD3KMX1zbqo7KFNR4K4h/gnKRvQAB6W1tNAAPnpBTTJKWkBPtvZGshfQc57WKuDv3gaZ+GU+NkXlBqCcjdcjf0VgyJjvbw6WXufT+D6aH+wOT73jqtyz1Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/16/26 at 06:19pm, Baoquan He wrote:

For Sashiko complaints: 

============================================================                                            
Subject: Re: [PATCH v3 01/14] mm: xswap support for zswap                                               
                                                                                                        
│ xswap entries are added to the zswap writeback LRU but                                                
│ zswap_writeback_entry() rejects them with -EINVAL, so shrink_memcg_cb()                               
│ retries and zswap_reject_reclaim_fail keeps climbing.                                                 

Right. An xswap entry has no backing store, so it should not be a
writeback candidate. v4 no longer adds it to the zswap writeback LRU;
zswap_lru_del() tolerates that (__list_lru_del() checks list_empty()
first, and entry->lru is initialized before free). The shrinker then
neither scans nor counts these entries. 

│ swap_vma_readahead() does not skip xswap, unlike swap_cluster_readahead().
                                                                                                        
Right, I only added the check to the cluster path. v4 adds the same                                    
SWP_XSWAP check to swap_vma_readahead().                                                                
                                                                                                        
============================================================                                            
Subject: Re: [PATCH v3 04/14] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc                    
                                                                                                        
│ Returning -EBUSY from vm_area_map_pages() skips vm_area_unmap_pages(),                                
│ then the pages are freed while their PTEs are still populated.                                        
                                                                                                        
This path is unreachable. vmap_pages_pte_range() does return -EBUSY, but                               
vmap_pages_pmd_range() and vmap_pages_pud_range() normalize the return to                               
-ENOMEM, so vm_area_map_pages() never returns -EBUSY. A collision takes                                
the -ENOMEM path, which calls vm_area_unmap_pages() before freeing the                                  
pages, so no freed page is left mapped.                                                                 
                                                                                                        
============================================================                                            
Subject: Re: [PATCH v3 05/14] mm, swap: add sysfs create interface for xswap                            
                                                                                                        
│ maxpages smaller than SWAPFILE_CLUSTER skips the rounddown(), leaving                                 
│ si->max unaligned.                                                                                    
                                                                                                        
That needs 2 * RAM < SWAPFILE_CLUSTER, i.e. RAM below about 1MB. Not                                   
reachable in practice.                                                                                  
                                                                                                        
│ sysfs_create_group() failure leaks xswap_kobj.                                                        
                                                                                                        
Fixed in v4: kobject_put(xswap_kobj) and clear the pointer on that path.                                
                                                                                                        
│ pr_info() after enable_swap_info() races with swapoff reading si.                                     
                                                                                                        
Fixed in v4: the message is printed while swapon_mutex is still held.                                   
                                                                                                        
============================================================                                            
Subject: Re: [PATCH v3 06/14] mm, swap: add xswap grow trigger on cluster allocation                    
                                                                                                        
│ free_clusters can be populated concurrently after the scans, so the grow                              
│ block is skipped and the allocation fails.                                                            
│ -EAGAIN from xswap_map_clusters() (another grower won) is not retried.                                
                                                                                                        
Fixed in v4: retry alloc_swap_scan_list(free_clusters) once after the grow                              
attempt, which covers both cases.                                                                       
                                                                                                        
│ backing pages are leaked on swapoff.                                                                  
                                                                                                        
That is fixed by the patch that follows ("mm, swap: free backing pages in                               
xswap_unmap_clusters"); patch 06 has no unmap path yet.                                                 
                                                                                                        
============================================================                                            
Subject: Re: [PATCH v3 08/14] mm, swap: free backing pages in xswap_unmap_clusters                      
                                                                                                        
│ The teardown callers retry the unmap in an unbounded while loop.                                      
│ kmalloc_array() under memalloc_noreclaim_save() is a high-order,                                      
│ non-reclaimable allocation that can fail under fragmentation.                                         
                                                                                                        
Both fixed in v4. The array is now allocated with kvmalloc_array() and                                
GFP_KERNEL. It can fall back to vmalloc and it can reclaim, and the                                   
unmap always runs in process context, so this is fine. If it still                                    
fails, we unmap in small batches using a stack array. So teardown                                     
always makes progress, and no page is lost. The function cannot fail                                  
now, so we removed the while() loops and the shrink rollback. The                                     
counters are unsigned long now, and an overflow gives a warning.
                                                                                                        
============================================================                                            
Subject: Re: [PATCH v3 10/14] mm, swap: refactor swapoff and add xswap_destroy                          
                                                                                                        
│ sysfs_create_group() failure leaks xswap_kobj.                                                        
                                                                                                        
Same as patch 05; fixed in v4 in xswap_sysfs_init().                                                    
                                                                                                        
│ sys_swapoff() mixes goto-based cleanup with scope-based cleanup.                                      
                                                                                                        
This is pre-existing upstream style in sys_swapoff(): CLASS(filename,                                   
pathname) and out_dput/filp_close(victim) are already there before this                                 
series; the patch only moved them while extracting __swapoff(). Both
pathname and victim are released on every path.  I left it unchanged to                                 
avoid unrelated churn, and there is no standard CLASS for a struct file *                               
from file_open_name() anyway.                                                                           
                                                                                                        
============================================================                                            
Subject: Re: [PATCH v3 11/14] mm, swap: require zswap for xswap devices                                 
                                                                                                        
│ The fix only checks zswap at create time; runtime disabling of zswap and                              
│ runtime zswap_store() failures are not handled.                                                       

Yes, this is a known issue. The create-time check cannot cover (a) zswap                              
being disabled after creation, or (b) zswap_store() failing at runtime                                
(pool full, allocation failure). In both cases swap_writeout() cannot                                 
write the folio out, so it stays in the swap cache until it is faulted                                
back in.                                                                                              
                                                                                                      
So this is a temporary state. The writeback series on top adds the                                    
fallback (write to disk when zswap refuses an xswap page), and then this                              
case becomes the normal swap IO error path that every swap device has.
                                                                                                        
============================================================                                            
Subject: Re: [PATCH v3 13/14] mm, swap: add sysfs per-device size limit for xswap                       
                                                                                                        
│ del_from_avail_list()/add_to_avail_list() use try_cmpxchg() without a                                 
│ retry loop.                                                                                           
                                                                                                        
That is the pre-existing pattern in these functions (they already used                                  
atomic_long_try_cmpxchg() and skipped on failure before this series); this                              
patch does not change it.                                                                               
                                                                                                        
│ DIV_ROUND_UP(val, SWAPFILE_CLUSTER) overflows for a huge val.                                         
                                                                                                        
Fixed in v4: clamp against (unsigned long)nr_clusters_max * SWAPFILE_CLUSTER                            
before dividing.                                                                                        
                                                                                                        
│ a limit write that makes the device full leaves it on swap_avail_head.                                
                                                                                                        
Fixed in v4: after updating si->pages, call del_from_avail_list() when the                              
device is full, add_to_avail_list() otherwise.                                                          
                                                                                                        
============================================================                                            
Subject: Re: [PATCH v3 14/14] mm, swap: shrink xswap to the ceiling when it drops                       
                                                                                                        
│ the hardcoded excess can include an in-use cluster, and the whole shrink                              
│ aborts.                                                                                               
                                                                                                        
The limit write clamps the new ceiling up to the clusters covering the                                  
pages in use, so [ceiling, mapped) is free and the validation loop passes.                              
The only remaining window is an allocation racing the shrink, which just                                
defers the shrink to the next trigger.                                                                  
                                                                                                        
============================================================ 

