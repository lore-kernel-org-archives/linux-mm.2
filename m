Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ED79606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a8K7STZD
Received: by kanga.kvack.org (Postfix)
	id 6FB976B05BF; Sun,  1 Nov 2026 12:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC7C6B05C0; Sun,  1 Nov 2026 12:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BEC6B05C1; Sun,  1 Nov 2026 12:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2BE6B05BF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:11:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9178EA0A72
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:11:30 +0000 (UTC)
X-FDA: 85387191540.15.ADB893B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E8F6F20002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:11:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8K7STZD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAh3bSv7u3LMOUIxSn2imLDtJLVr1ST8Nu4wB45AsEY=;
	b=MpnuEvLgrwrDiqgUTgMf3CvjbyPEa200pkPDqVny9yg+kqLK2bJhltEYoPaEiPU+hf9O6m
	MKddxRvgH4fWhnhxcdVMEBS38uekGEpdcuwVjQ1f52J9BaO63Dhz/RiorPpvAEdgA0bQmz
	HzjOxgrZXdVpG9a1vuaLmUZfpAWTm/I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8K7STZD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553089;
	b=H5sN3q2VkCrenD2jpr0ORM8AD/kbC8swhJggKck6Nyks7HuPV+quwCgWdxpkpDNPGc87Dq
	SxoF2DFCnQuRq2kHF+2RUBx1xWLS8kGrMuVDZTX6A7UYgtJKHn/fFxH1OoRvRwLDUtrl8h
	oZpsUDVeNMatZ2iqCe9DU/Jq0haMLqo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E0B241834;
	Sun,  1 Nov 2026 17:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D681F000C1;
	Sun,  1 Nov 2026 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553088;
	bh=OAh3bSv7u3LMOUIxSn2imLDtJLVr1ST8Nu4wB45AsEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a8K7STZDnDa6mE0nR6n9AkERHliVp3c33Rev6eagR57gXJzu8hsiiy99MzzPNjCka
	 KhVl5q9nLlLcOq5eLBtvMpWVpMBgVNwrhw4J+PYjxnvi4eX4IqxbuCf3i7Dv9qVuZt
	 Yc6pbWe6DDMvUrImKxCcW5KqZvWPg0ydFHEvq7McLGsbMJ2dE4JYtzQoP9cLV+/AFM
	 9Ji2j0IMq+fhBKX15/mASDdqANUXhrNxgMoIPZP4ldBZSCSSapXuVxmANPf6C8N7OD
	 jgxvF8PlFUMLdbioT+PlrganVE0wyWDd+82hWmBe42oUwuOeeI2eFwZlrl7XNbC/yG
	 EHdBO4MFILNhw==
Date: Sun, 1 Nov 2026 17:11:26 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] MAINTAINERS: mention for-next branch in MEMORY
 MANAGEMENT - MEMORY MAP
Message-ID: <audyrBPhYRZvkJVl@minisforum>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-1-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-1-97278f8a5f54@kernel.org>
X-Rspamd-Queue-Id: E8F6F20002
X-Stat-Signature: 47egjjuayqraqsr31r8uhsr7mw9t7ekh
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793553088-808561
X-HE-Meta: U2FsdGVkX1/rEtWnoqqX77d+nwSamJnSbOEE+WBTb+4JhpY7kbxoW292+aulsHfYUgxDBRLRtdnrVBUH45ySr+k+6kQyy8VX+aHGjugkgYtshEEtjxTOq+nb9buyC1MyCyTzjvttDfOGaPu8ad17KQ54LA+HknYphLH9R0XOZKox175wvoGwbrD5Q+8vukToY4Hm2wI3ortcelk9LpIhPNoqJDqxMw8IjB4zgt4uBH/glEFGWENrcEeccWGC/s56aceTGb7HO19vVGOGIr7982oToEwbe71fXRskXg1zQOUOJxME0IebGQ+8oJk8R4GMoff0v+UKBiXuisF1bLF7UfjWuPqiWgGh2hFOsTyWoPEDnxRRPWPBwoMwysz01yzZVzaYckggoamAJCQovdLPY5Qaus+tV7xt9oHrEDJEZhVfakaowjzilOwQf5oCgmkjXYwBXKSLJFfo1AJXUwdICorA3bUNAXoiF2v3Xk9ng1zKUS8pu95ybr3YP4xOznLsvrdI9TuNICR/cQuCBj48qGf/1EeYJkeVo6VVjA8fNpUacggcmKmX0sgtO2H2XZtckCDD7L+GSxgBNKOG1piN5fnneb4soujfiLGY2IpkfHIMe1PqVO8BEyhKORFFHFbjZMcO7jJ712OaV6jjcBlfUjIiko20plk+tTo/q8DEV9WWHyVFmkuTqIkj+u+K6OnmiKMSYYYF2mp+KC7dy6qRFxXz1qCZj0Mkx5Z3oFQC59RKX5VZsmDulu+1yh4/2CwOAz+2DjN2neSTB8KwUGkJBjpJ89/9g4EOwkqXhVHf9Y2hkaMPGeK7rs3D1MqVKdX9ZkJW2yjns2LdZUy+DfjD7P4bsdYfVYI7vRcmtE1RVvrVXjAJ7pNHhtKKH/h4h+8+lbjGZ0wH01+FIcGonEPYdzXmqRWInaU7uRWdb90Or9EnR8A818AXtbwCmOVmuRihX6adpsVzY8+NT9Sbs2z
 RCzme6jz
 P7iaqEiVc6fzgJdha7eOFeFR+OC/AtMM1JR28kfTWIdYNWZxvecouZaOWEHvz/yoKRFF0W81WrAXfyIFZpvbDz5mqy3HBnoUYKZ92DgjLj688Bzcqvd20d/GfDMAKraNhGJQjsrYEn6jKK8wHP83X4M4EiNrYBIQWpKZnZkqM9rMETHAN8RfIYIiLRpApQmrt5N3f0TCNRFN+44MVoEUoQnNN8WYfxk+6xop8aWWU6PuCMESy/q4Oh6bmSLn6ceJKM7Dn44Xk8Mw2KAheaHF8lQXhemPsJGW3OUoAS1fLNtQfvOcDk7KR7R8Ja2Al0wZZ8hRoNq8CtAG6W1ZYLlBXMJmHaD8tQIKHkEH4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:25PM +0100, David Hildenbrand (Arm) wrote:
> "memmap" will be used as a prefix for branches, but not as a branch
> itself. "for-next" is the integration for all these things against which
> people should ideally send patches.
> 
> Not mentioning a branch makes them assume "master", which is wrong.
> 
> So just mention the right thing, which is "for-next"
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

