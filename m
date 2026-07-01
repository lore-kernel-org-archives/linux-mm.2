Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCA8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD206B00A8; Wed,  1 Jul 2026 01:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E2E6B00A9; Wed,  1 Jul 2026 01:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44EAA6B00AB; Wed,  1 Jul 2026 01:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE086B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:45:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 891FDC1482
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:45:24 +0000 (UTC)
X-FDA: 84939120168.21.E5D115B
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id A923D80004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:45:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A3L+Kccs;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782884723;
	b=ZXFoIYADn8IPMR3rT1/kx+21vbJaqJIJzmm+4okJNy4rIhHZspMDOQieXb2yNS+UYVWw3F
	b2eszChv1PNcAW79jj2KGMmE+yoo/pladlzUUbFgKwW4dQqWKnoB/0aS2J1Wk2usE/T1fc
	twkSpwbVTizW2BBjMV8rnGPf2LDjAt4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782884723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eBy/cy5VU0ZqBJNyM4Ph2gzU/Wof+YpQ8uN8ahCb/c=;
	b=3dUejnWmWcJOHSrpO9N1gOiKwVY+86cpLSoInKtdiEAJRR/nuc2D+DB2rqlZCnO2ilFuur
	Z5U4l0TVkFqouBgmJvoB1VXaFUofvtl8XUCF7jzfmE/hXQriRZCeMguOGwLLY62TXXNv3S
	Us6ygMSKoDKRUkPbEC+qeIPm/Eo8Fg8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A3L+Kccs;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <8dce5685-c215-4876-93d9-3cec4dcb6173@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782884717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/eBy/cy5VU0ZqBJNyM4Ph2gzU/Wof+YpQ8uN8ahCb/c=;
	b=A3L+Kccsn/MNQIVglrZ4DBTnF5bN7TbI1Qf70InFJpoNesB515JIh1V2POmopZFmMmCQAe
	DgqN9Fmxc+maXIPRp3Pt0LSuTF3HvjOoIiQJ+01y7EY7wCP07R/yzQZRjDXRVW6dalFHZ2
	t79Txc3e/J7kMlnOHdFPXePV/U9nL/s=
Date: Wed, 1 Jul 2026 13:45:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/7] mm/page_owner: misc cleanups
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260701012239.315262-1-ye.liu@linux.dev>
 <20260630204130.175e9a2addae86058327918e@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260630204130.175e9a2addae86058327918e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A923D80004
X-Rspam-User: 
X-Stat-Signature: ww3uczouobnw97k4atggk5mk7kpw98m1
X-HE-Tag: 1782884719-142424
X-HE-Meta: U2FsdGVkX1+AZzsGBwhfBRCIm+Y0E76ZfQ24iJqT95p6AETSZtWcnLo3RSDIRzqYXN9yw2bnnm9DrLv6bySlM/7QmKeYejbKwOQ2zEnPmvKqzNMqaVAh9vZ6gmnsHO00bIMDLwWemNQUoVhAHdQzPy/tVQRvibUlY7stIuWMJDl+KhvmkiqioeDMafOVG5Tx1vJ4ixmw5KyXKs1cohxCnbUzNymvXXCVVj3pxGzItUV0qEmiXSAcmv0IW/KDZM7T+RIoXsUJtNQCSmYPPnNHgbKOms0FktJTjDhLW4qUuhAdp4M7l1o8roMQogEyyD6DpihdMMDB7Sw56bvPEfVwJ5MRfzdHTr4VwKonNG+5Kxe6T5jwI2eu8NBU4NfFzuYLrzOoC3zo5t9NdhFXqe0+egtem3oq010JfGX2qeWKtxis4SUWfWy/xCit09RocHh75ft8KP3ugCEBXxj/TtDKYbLPFO/bbCafJVnwsnEzP0zY62MH//4/N3qP3NYsOIuvpJXOCsFP+rSde4ADBRxmTuQKikyvgEzSndpYb6TsebJ0TV5rdX07MV6X/+Pszk0jtdbJ/LBUKv6FgNViY2B1W/jQCRpOnsIjtuSHfgjSvv3NKa6A5LqgWJrjRYq7Q6gpcvdq5Mpk/+/ZmDdPcQ251mBvuRsybmDwii+RRIuMihZbcp0iSc4IuPRozu9ZNmCQs50FyIkKPFFQ/DC9+p29J2bV83w6YoNeDU/vyKjosXmq+iNqJtxnepu2ppGNUNRBX9AhqL0XtMzTSewwEvhOP0LTRhISk5N/B7Br5Q5qDa9aZK+mpApSsE4FyzXbtriLSYlnCRxA3qzoJU79fMlOe8/nqvQ+fslQWz9v0pSfU0MILZ+EOEI+LFeL5+D3t2yJj/5e0jDFgj3mdNMlYsQ7YXm6tnA5r1nGFMejdlMGhd35koG7J47I34XSjgb1OECuJ5KudQqL2rIlYx+qGf4
 oxlWZ8Uo
 Vcd4sMJPXknZJ7zM3H8mDsf4Anf6vsIkGi9ZG/hL1Y3zpq69d/ga+G8aqACJz20AVmV5Nh9R2iU9yduVZddmYBdXO/JEkh32ZMJpIObiSVJ2pNBghzlKvDam2y4gkXB7NHPTiKtZdBCUpURxCP2QK2K+8vyLufwJ4/vj90RVlSUel56tinkeLY3sz6PddFYrd0G6QoHDrv3sl69mYqmXHoVUlbr2oh5Lzlmo1pH8JImK4PLnIzWNLNojsXS0jA23sHZ3oV7gBIRmzAGEZW3afMHCY39d9yuRFKyZ4f0NuWcnCqnotMN+yCQJ1z54akShNESLpvqW5ItiZ5Qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/1 11:41, Andrew Morton 写道:
> On Wed,  1 Jul 2026 09:22:26 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>> v4:
>>  - Patch 2: also update scripts/gdb/linux/page_owner.py to use MR_NEVER
>>    instead of the hardcoded -1.
>>  - https://lore.kernel.org/all/20260630015331.147174-1-ye.liu@linux.dev/
> 
> I'm seeing more changes than described here?
> 
> 
> Thanks, I updated mm.git to this version.
> 
> Here's how v4 altered mm.git:
> 
Patch[1] depends on this patch series and should be placed together with this part.
I will send V5 including both patches.                                             
                                                                                   
[1]:https://lore.kernel.org/all/20260625014708.87386-1-ye.liu@linux.dev/           

> 
>  mm/page_owner.c                 |   16 +++-------------
>  scripts/gdb/linux/page_owner.py |    4 +++-
>  2 files changed, 6 insertions(+), 14 deletions(-)
> 
> --- a/mm/page_owner.c~b
> +++ a/mm/page_owner.c
> @@ -428,12 +428,6 @@ void __folio_copy_owner(struct folio *ne
>   * to skip less than the full buddy block, but that is acceptable for page owner
>   * iteration purposes.
>   *
> - * The lockless read of buddy_order_unsafe() can also return a garbage order if
> - * the page is concurrently allocated and PageBuddy is cleared between the check
> - * and the read. Clamp the advance at the next MAX_ORDER_NR_PAGES boundary so
> - * that a bogus order cannot carry @pfn into an unvalidated memory section,
> - * which would break callers that rely on boundary-aligned pfn_valid() checks.
> - *
>   * Return: true if the page was skipped (caller should continue its loop),
>   *         false if the page is not a buddy page and should be processed normally.
>   */
> @@ -445,12 +439,8 @@ static inline bool skip_buddy_pages(unsi
>  		return false;
>  
>  	order = buddy_order_unsafe(page);
> -	if (order <= MAX_PAGE_ORDER) {
> -		unsigned long new_pfn = *pfn + (1UL << order);
> -		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
> -
> -		*pfn = min(new_pfn, boundary) - 1;
> -	}
> +	if (order <= MAX_PAGE_ORDER)
> +		*pfn += (1UL << order) - 1;
>  
>  	return true;
>  }
> @@ -561,7 +551,7 @@ static inline int print_page_owner_memcg
>  	cgroup_name(memcg->css.cgroup, name, sizeof(name));
>  	ret += scnprintf(kbuf + ret, count - ret,
>  			"Charged %sto %smemcg %s\n",
> -			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
> +			PageMemcgKmem(page) ? "(via objcg) " : "",
>  			online ? "" : "offline ",
>  			name);
>  out_unlock:
> --- a/scripts/gdb/linux/page_owner.py~b
> +++ a/scripts/gdb/linux/page_owner.py
> @@ -34,6 +34,7 @@ class DumpPageOwner(gdb.Command):
>      max_pfn = None
>      p_ops = None
>      migrate_reason_names = None
> +    mr_never = None
>  
>      def __init__(self):
>          super(DumpPageOwner, self).__init__("lx-dump-page-owner", gdb.COMMAND_SUPPORT)
> @@ -65,6 +66,7 @@ class DumpPageOwner(gdb.Command):
>          self.max_pfn = int(gdb.parse_and_eval("max_pfn"))
>          self.page_ext_size = int(gdb.parse_and_eval("page_ext_size"))
>          self.migrate_reason_names = gdb.parse_and_eval('migrate_reason_names')
> +        self.mr_never = int(gdb.parse_and_eval('MR_NEVER'))
>  
>      def page_ext_invalid(self, page_ext):
>          if page_ext == gdb.Value(0):
> @@ -138,7 +140,7 @@ class DumpPageOwner(gdb.Command):
>          else:
>              gdb.write('page last free stack trace:\n')
>              stackdepot.stack_depot_print(page_owner["free_handle"])
> -        if page_owner['last_migrate_reason'] != -1:
> +        if page_owner['last_migrate_reason'] != self.mr_never:
>              gdb.write('page has been migrated, last migrate reason: %s\n' % self.migrate_reason_names[page_owner['last_migrate_reason']])
>  
>      def read_page_owner(self):
> _
> 

-- 
Thanks,
Ye Liu


