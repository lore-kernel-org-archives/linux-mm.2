Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD3FCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE236B00D9; Thu, 25 Jun 2026 03:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91116B00DD; Thu, 25 Jun 2026 03:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5F66B00DF; Thu, 25 Jun 2026 03:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3D166B00D9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:31:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2125740610
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:21 +0000 (UTC)
X-FDA: 84917614362.20.57889B7
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B93180004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IL7eZQIC;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782372679;
	b=6ihNwCPZZaaDwHAzYzWoQu5FVvO6TVh7rofAS1zsPV6hHXij6bTGFo6MHJyviwsYhRgPoz
	qLB4XfeCW3PEHGyNCzA6/7d/8zMtuEB+8WOxOY1MTyedcCYI9f6GmfO3JEEfX19II6fFmW
	NxY15mzqgjfRazKICNG/OalGIn1RH9U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782372679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvh0Wb4xP4939Azsdl9T8pOph9hjui7X40GYWt+KMwA=;
	b=jORTYViZnZBnTTVjuO1UZR2f4xn+xlzJCtrjpUVAO6WMZSl7LTsRYDo7FmLWnoZNKbORhx
	dUldl5QDaE72EJEp17QnkBQWbGMJRcmnSxkkITWLx5BsQocq5UxXmprX5fYLqy3Jqs/33S
	jxDwAqBgOS0ACvn9TrEgOd75l+ZVGOA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IL7eZQIC;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <43a99a8b-3c27-40a1-bcc1-77112eee6c15@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782372677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fvh0Wb4xP4939Azsdl9T8pOph9hjui7X40GYWt+KMwA=;
	b=IL7eZQIC4VN/2Yt6PE5Nj8gq7ldVeLLqG5ZiNOhiYqhOaYuPwZDIt4aaqe+5EybhQPXPUh
	RG7cLPj5ScvRblDdrJPJAMDAEzA3d/AHUmIwuCTw3ja2UC9VQ/tpwzX116IPkKMxY+PM6y
	+IFwYgXafQr5QQwBLahECz/gYHkPgrA=
Date: Thu, 25 Jun 2026 15:31:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] mm/page_owner: extract skip_buddy_pages() helper to
 unify buddy page skipping
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260623065234.31866-1-ye.liu@linux.dev>
 <20260623065234.31866-2-ye.liu@linux.dev>
 <20260624172025.3087e8d574285bfa8d6772e3@linux-foundation.org>
 <b2e7646d-346b-4eb8-aecc-d70fad3a28f7@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <b2e7646d-346b-4eb8-aecc-d70fad3a28f7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B93180004
X-Stat-Signature: fexzbt7usc4dm7z4of4eajc5q7jg8a8m
X-HE-Tag: 1782372679-781908
X-HE-Meta: U2FsdGVkX1+AP4sK6EgGvBZY7telsvnVoL52j/FHrMdQ2hniofvzrAOcx/7P51TcI3vHqAsGB0kQoH/dsRom/RRlfC9ywQ0vq2LT0Gnx+qUHzSwjrhPKsP2uPyqp3vm/EEPK7s61UgGfD+kJblC+QM3cP3B4Yh6VDadrkjteoqVbi8ReiGPuAvyjwA6cPtVsHCsqIu5fVs2enrzJzD1o/efqGeNisO5pem0TWEoepzYMvKamfFkMk/aRCQpdSRmkjyjqxg7GdOhs9kLVJ4pdllH6x5RJ7me0wlQBvIOVmxm/Fx4W0xiiDIUNxFLlKD0FHFnkpEyMRv79J/3xtP4CondzFr+gs551ocn+DG/eGwpKpYhYWEJCesU5mmcFvgzHq79RrYc7pZRNqDn122Y9Flo/3zuFK1iGnZ3vuoom0eaaLp8dFD6zwgviFSv1MeGpyVvQJxToePZSabI/EpzoQ0vVsBoSLFtS0G5Yruzs/aBDXY0YoUU2igxxwAjuoIolCsyqBvKu6H6VShGkNjUe6RSPTP0whFVdgZhhLScAiIlmKNNl+LE23VgFJa1XsA2aIYl3msuMoqHh+HeLQqpSdijRYEoHohCndwn0sULk/9pNw+4EMFHCIdmkrQUiAFO2w8VL5PN0rP59b5o+9yZS4j23j+VIThJtNh6LtxwlypKNV8NugLkvwqnqRWcrp5Xzl/EARGh1A9UZhjwon5Gjqjkaut1LpG1EsEBlIdswRehTv3tU75Ocn+Spa7ryt+l7NGo1uy4Z/Y/Lw1HJ7Zk42M6KeYt2FM3XhiwPKZiZPg+rtwZFSWMhu41ue3VzVqRQaCs11yY5y6LhH4T5vWM+frHYEJ/K3OSX7+3JcKVeoD3eZZuVFGIP+rabO77N4Q7kQkp02dGIVyVglMen9WRHGNs0L+bSHvCMgrR+qzjQIcNiLXzJu1sIO4TiYNmfMxNwhVWSWu7SRuyijGBjyS/
 bYWo66q1
 nuIibJzbBOrypMibkT6PMaN9FM1wyXrES+nCaJIUjFp6cTF5P6pn8eH+ZW4ioVuofRaNiBUV9E+YfAKKzbtwFixGMZgquNEsQVGQOuS/Izl0F1Ca9qm82SlpIQudhLqHsFTQh6dUPMBHpv0LJqqRFHGPzj130eVWNT2X89fbOcIexwhH06WwD+2s77wBet1i5fROpWQw4FPd714bGJTpD7gmwQrjY/2QL6XMzNarHe0kN+lw6AaqzURDMTtZ/VH5bhif70gJ4C3tCaz6uRePGRBIcZGEARloAMlDFXdpgqsgeN98nq+78JAzg3xB89spVQZF/0+Vb9hL0KbJhWZm2TZ+h6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/25 15:13, Vlastimil Babka (SUSE) 写道:
> On 6/25/26 02:20, Andrew Morton wrote:
>> On Tue, 23 Jun 2026 14:52:26 +0800 Ye Liu <ye.liu@linux.dev> wrote:
>>
>>> Three places in page_owner.c duplicate the same pattern: check if a
>>> page is PageBuddy, read its order via buddy_order_unsafe(), advance
>>> the pfn past the buddy block if the order is valid, and continue.
>>>
>>> Consolidate them into a single inline helper skip_buddy_pages().
>>> The function returns true (skip) for any buddy page and advances
>>> @pfn past the block when the order is valid; returns false if the
>>> page is not a buddy page and should be processed normally.
>>>
>>> The old init_pages_in_zone() variant used "order > 0" as an extra
>>> guard before advancing pfn, but the continue was unconditional and
>>> (1UL << 0) - 1 == 0, so the behaviour is identical.  The comment
>>> about zone->lock is preserved in the helper's kernel-doc.
>>
>> All looks nice, thanks.
> 
> I got a bunch of "added to mm-hotfixes-unstable branch" mails, but this
> seems like cleanups and nothing urgent? Was that intended?
> 
>> A [0/N] cover letter is nice to have.
> 
> Seems like it exists, but wasn't delivered. Lore shows its message id, but
> as missing.


Apologies, I accidentally sent the cover letter only to my own address.
I'll ensure it goes to the mailing list in future submissions.         
Thanks for pointing it out.                                            


Subject: [PATCH 0/6] mm/page_owner: misc cleanups                      
                                                                       
Hi,                                                                    
                                                                       
This series collects a few cleanups for mm/page_owner.c that have been 
accumulated while reading through the file.  There is no functional    
change -- the goal is to make the code easier to read and maintain.    
                                                                       
Patch 1 consolidates three identical PageBuddy skip blocks into a      
single skip_buddy_pages() helper, eliminating the duplication and      
keeping the lockless-read comment in one place.                        
                                                                       
Patch 2 replaces the -1 magic number used for "never migrated" with    
a local MIGRATE_REASON_NONE define, making the intent explicit at      
every use site.                                                        
                                                                       
Patch 3 hoists the CONFIG_MEMCG guard out of print_page_owner_memcg()'s
body so that the real implementation and the empty stub are two clearly
separate definitions, the common kernel idiom.                         
                                                                       
Patch 4 adds a missing \n to the count_threshold debugfs attribute     
format string so that cat(1) output is properly terminated.            
                                                                       
Patch 5 moves free_ts_nsec from the allocation summary line to the     
free section in __dump_page_owner(), grouping it with free_pid and     
free_tgid where it logically belongs.  This also makes the dump        
output consistent with print_page_owner().                             
                                                                       
Patch 6 drops the redundant page_owner_ prefix from file-scoped static 
symbols (stack_fops, threshold_fops, etc.).  Since they cannot collide 
across translation units, the prefix carries no information.           
                                                                       
The series is based on v6.17-rc1 and has been compile-tested with and  
without CONFIG_MEMCG.                                                  
                                                                       
Ye Liu (6):                                                            
  mm/page_owner: extract skip_buddy_pages() helper to unify buddy page 
    skipping                                                           
  mm/page_owner: use MIGRATE_REASON_NONE instead of -1 for             
    last_migrate_reason                                                
  mm/page_owner: hoist CONFIG_MEMCG to function level for              
    print_page_owner_memcg()                                           
  mm/page_owner: add missing newline to count_threshold format string  
  mm/page_owner: move free_ts_nsec output to free section in           
    __dump_page_owner()                                                
  mm/page_owner: drop redundant page_owner prefix from static symbols  
                                                                       
 mm/page_owner.c | 121 +++++++++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 54 deletions(-)                     


> 
>> AI review identified a few possible pre-existing issues, if you're
>> interested:
>> 	https://sashiko.dev/#/patchset/20260623065234.31866-2-ye.liu@linux.dev
>>
> 

-- 
Thanks,
Ye Liu


