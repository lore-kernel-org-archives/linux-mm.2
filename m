Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4EEC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0728E0002; Tue,  5 Aug 2025 06:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C981F8E0001; Tue,  5 Aug 2025 06:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4C88E0002; Tue,  5 Aug 2025 06:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADC8E8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:20:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6772FB6258
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:20:04 +0000 (UTC)
X-FDA: 83742308328.12.1B54AE4
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf29.hostedemail.com (Postfix) with ESMTP id CCE9212000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:20:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oIQl1Zs0;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754389202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGu1g2GzCGqbXTPegvh6d17h0P/CvE42eBxGct+TDB4=;
	b=jMl5q/h9JsUh0khzlgQ7fLXipFCKY/dn4dXBHVhm2459ZMfKdrG6NE7Eqj1t3/dFN4UEZ2
	rLM1XpjcC6r6qyg4FgZ2hoQT6pRJbUKcJjUMniKCODB6lA2E2Kd5auDHhSgUc0nJQYX+OZ
	/kZexcE+jI9h/SDw76TkarVUY9pf40w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oIQl1Zs0;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754389202; a=rsa-sha256;
	cv=none;
	b=bXfffq2xzSrrlvn6SXdArnERDBVHJt1/wfOBuMm8F1h9Tq3X1tPnJ1KnJX7CUDhKH/4wxz
	tSjjdN2vPwc5/oLO1MUeV5omZQi8UH74lg2SkQKjOurIog0iEnnZ51t75E7aXHgENp8iOC
	jAi8zMAx6VzX2x/zk8/iYGJv2S7Tpok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 0AC72A560B7;
	Tue,  5 Aug 2025 10:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C66C4CEF0;
	Tue,  5 Aug 2025 10:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754389201;
	bh=mdNZYWbFwgA6wLySuufnXZ/JAGUhvzf+uMdGc+KNcdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oIQl1Zs0pphGzQ0D+uUStwqrKbP0YZ16uUALphH+BgUVJxBpBDD/jms0iHyHR3/4c
	 VBiG6syvDMsxCFiM/ra36yC4X41rXNG34op9JTHWewqtax9FMGuVbtGqDnWb0YBKI+
	 ZDQPX+200tPD+X09fpd+CGRmjFfj05gyHnfuvQRz8IpfmxME3tyMWrb3zwbJ7bnGZV
	 jGGg0VOw03cOD40VrrsUelw/S2tLepRWw2Bn+eqrwJ9xDjjl8LkVGmsG1iuva/X7yA
	 HKuixAgByb96cjaiT+nOQljFx33X4WlgUuoqYezLIsDVcXcjlmboUVzX8Ra3VSfejh
	 VEit4gDLeGixw==
Date: Tue, 5 Aug 2025 13:19:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: shiju.jose@huawei.com
Cc: rafael@kernel.org, bp@alien8.de, akpm@linux-foundation.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jonathan.cameron@huawei.com, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v10 1/3] mm: Add node_to_range lookup facility to
 numa_memblks
Message-ID: <aJHawm1zE62x1YH9@kernel.org>
References: <20250801172040.2175-1-shiju.jose@huawei.com>
 <20250801172040.2175-2-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801172040.2175-2-shiju.jose@huawei.com>
X-Stat-Signature: oitupz3heomd7dbho57zcmh7an4szqeu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCE9212000C
X-Rspam-User: 
X-HE-Tag: 1754389202-630995
X-HE-Meta: U2FsdGVkX187+tw7IHC19063ro+LCUJ7+yPKccPsv79pr8XYGOS+OZzrCfD0fL1gZ3aQ8MMdJb4gSKaMjACL5dNQCQly7kiZmeSDjSpfcMcH9uNoABZt9yjEQKMWy5PC/oUnzEEpCZpHoYScJb3f0Dx8zHvz1FONMUkV5BDp1hzXed/mG4qRuyl29JICJ7X3fWkv8rYc2zgm1gYicHKH3GqN0hX9ULKwp+rexRbtH8mLK/83ro4G+ihJ3mTrBMq5UwNXnyDSh5yZM6i5SKs7eSolvqwG7XoHFpOv2yWybAPrXv9nUOZo9+H+jJ39kUKk9+1QT1MugY0cMU9aqxYAXyFyViXR7Ghp1gqiTJwjp6LfJj9Z+I+N/yc2DNQ3HlOotKn5pN+Gh++vsXJznsJhEgwEw8zE77Zj2VMfMVZDoteILJ9tz+LthL6KVZgLx7up/+tU+qq5rW1w3kVtG00LZIdrBrQ5LtdvwfYE1mwnZ0jR+OAtlT4SNDU1NGYa4+YGyYV5N0SbkmaBZq1PU8kRyZqW5tQxvdY7L3QG4ZBHPH60h2I3oFzRWAV+pDfNxwKPPGCNJDt1aWya3oHhCvFeZ6YHf43AGe4Ta0DmFCingsPR5FOqpwVjUXU5Y8AKPUzGj7Ng2BwKe8/v/CukxfVZp9RR0SQfMgOeykSGhk2aHLDxgztJKkP7HoDHpBqRYtzAVkkhCwfd54XbS7JuqYSJanWDQNtiy8+8UuxFc6bQC+T29RFbTSnN5dsiavWjtbBCh+fGQfLJnLQWiPHOfAhaEToEqO7uxXMw67J+aJiASw2qSySwnK+khRMIJmKCYEm6fpW88YqHnl6A2tpuiHMacCP59kzuTQO1C4DueEv1Rt5ZU4MHfsbFISMjtU9OBEJyXf4oeXthgUdReu8g2E/tG3iWInbCLE8YiG5zrIGwZVFiVYM14K3W1rDeSNBb9VAVu7hcNwxw/Curv82WU9T
 xMUzv5n2
 OECzP5mBatLoBCWFcJjcoPb5z3ucf/W8aQTs2GS5nEj1R4Z6CEIIyVN+1E1F62MBk2cyKqicWEbdLLeyLrr5E1aPDV43fnBWuNASfIryIiVEXqZfwmBKgfqVqK9m0iIJofPRqqJVmxBumWQlR/EL8tQqC3voh/G5FAjUcWSU9YngVmWWBanXCQWg3RlI50j/quCMmZD14LRymyM+WAek3eZ7qLF3pJRShept8gNph8WvvaIZv64d+fDbYtfJUhUp5PzxtfqUeXqw/uPDDu7kFaZ/KFJwU1wo8rr74MuhHbmAHcDNBzX2R8wF0ls+K3TsP/n2e8MuV+4LSQduku7RWp264am/Ko2SXqTss8Z7cNV+ae3IOWZOnNiawRzpXc+biTpzWELJxvXfmTeqTldUHjxeX7FYc5wmGglnpUa5dn4vASuy+kdGuvTCPcZzT5KnLE8xj/5Tsnc/KPp4BKBkCRYgTxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 06:20:27PM +0100, shiju.jose@huawei.com wrote:
> From: Shiju Jose <shiju.jose@huawei.com>
> 
> Lookup facility to retrieve memory phys lowest continuous range for
> a NUMA node is required in the numa_memblks for the ACPI RAS2 memory
> scrub use case.

If the code that needs to find the lowest contiguous range in a node runs
before we discard .init you can just use

	unsigned long pfn = node_start_pfn(nid);
	unsigned long start_pfn, end_pfn;

	memblock_search_pfn_nid(pfn, &start_pfn, &end_pfn);
 
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
> ---
>  include/linux/numa.h         | 10 ++++++++++
>  include/linux/numa_memblks.h |  2 ++
>  mm/numa.c                    | 10 ++++++++++
>  mm/numa_memblks.c            | 23 +++++++++++++++++++++++
>  4 files changed, 45 insertions(+)
> 
> diff --git a/include/linux/numa.h b/include/linux/numa.h
> index e6baaf6051bc..d41e583a902d 100644
> --- a/include/linux/numa.h
> +++ b/include/linux/numa.h
> @@ -41,6 +41,10 @@ int memory_add_physaddr_to_nid(u64 start);
>  int phys_to_target_node(u64 start);
>  #endif
>  
> +#ifndef node_to_phys_lowest_continuous_range
> +int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end);
> +#endif
> +
>  int numa_fill_memblks(u64 start, u64 end);
>  
>  #else /* !CONFIG_NUMA */
> @@ -63,6 +67,12 @@ static inline int phys_to_target_node(u64 start)
>  	return 0;
>  }
>  
> +static inline int node_to_phys_lowest_continuous_range(int nid, u64 *start,
> +						       u64 *end)
> +{
> +	return 0;
> +}
> +
>  static inline void alloc_offline_node_data(int nid) {}
>  #endif
>  
> diff --git a/include/linux/numa_memblks.h b/include/linux/numa_memblks.h
> index 991076cba7c5..ccc53029de8b 100644
> --- a/include/linux/numa_memblks.h
> +++ b/include/linux/numa_memblks.h
> @@ -55,6 +55,8 @@ extern int phys_to_target_node(u64 start);
>  #define phys_to_target_node phys_to_target_node
>  extern int memory_add_physaddr_to_nid(u64 start);
>  #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
> +extern int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end);
> +#define node_to_phys_lowest_continuous_range node_to_phys_lowest_continuous_range
>  #endif /* CONFIG_NUMA_KEEP_MEMINFO */
>  
>  #endif /* CONFIG_NUMA_MEMBLKS */
> diff --git a/mm/numa.c b/mm/numa.c
> index 7d5e06fe5bd4..0affb56ef4f2 100644
> --- a/mm/numa.c
> +++ b/mm/numa.c
> @@ -59,3 +59,13 @@ int phys_to_target_node(u64 start)
>  }
>  EXPORT_SYMBOL_GPL(phys_to_target_node);
>  #endif
> +
> +#ifndef node_to_phys_lowest_continuous_range
> +int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end)
> +{
> +	pr_info_once("Unknown target phys addr range for node=%d\n", nid);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(node_to_phys_lowest_continuous_range);
> +#endif
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 541a99c4071a..9cbaa38cb92d 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -590,4 +590,27 @@ int memory_add_physaddr_to_nid(u64 start)
>  }
>  EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
>  
> +static int nid_to_meminfo(struct numa_meminfo *mi, int nid, u64 *start, u64 *end)
> +{
> +	int i;
> +
> +	if (!numa_valid_node(nid))
> +		return -EINVAL;
> +
> +	for (i = 0; i < mi->nr_blks; i++) {
> +		if (mi->blk[i].nid == nid) {
> +			*start = mi->blk[i].start;
> +			*end = mi->blk[i].end;
> +			return 0;
> +		}
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end)
> +{
> +	return nid_to_meminfo(&numa_meminfo, nid, start, end);
> +}
> +EXPORT_SYMBOL_GPL(node_to_phys_lowest_continuous_range);
>  #endif /* CONFIG_NUMA_KEEP_MEMINFO */
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

