Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4100CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4666B0005; Tue, 12 May 2026 22:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E6B6B008A; Tue, 12 May 2026 22:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05466B008C; Tue, 12 May 2026 22:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABAEF6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:11:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A4E04069F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:11:18 +0000 (UTC)
X-FDA: 84760769436.01.BE45DB2
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53F9F4000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:11:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wqU8qVBO;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778638276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iq7jnY+N0UwU1xXxCmM5jCZ1Y+zQ9eUrIz+WkKBogEQ=;
	b=MhHnbT9EpL26MQ/QX8a2TeU35ycH+/EqHomEhUZ/UQH7Jy2mYNAR5hGDDmERVn7aV09/rZ
	MNZivGx8NwQxmduqEN4VzKX1ph/FC0e0O5EVSxanUEOB0H4tFeAlwYv1bHrFjA7qK/6T0c
	2pECHx0poo3tiSoLvxvvpnJkSoeE7nk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wqU8qVBO;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778638276; a=rsa-sha256;
	cv=none;
	b=U2wlkHNpuf+uWXjNXGfbV/OXrHNxtYZPO78zj3zn2kGVT7BblA4yi6GzsLKt7nGmAuoU6j
	vXaG7e9r0bHZkEMPrJy52D5uvjHlbLCYXr2oYOg6NOUxiuCLCmQi0cqCy1ljr5QcBhoeBN
	mL/ENM8yuif/GDxvN+xyF0/g7r1fdAM=
Message-ID: <0e1b8994-944d-4dda-8966-3cd43661796d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778638273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iq7jnY+N0UwU1xXxCmM5jCZ1Y+zQ9eUrIz+WkKBogEQ=;
	b=wqU8qVBOB6nPI8tTv2ruSJGtw0S5kRmu9mGb+a0X62ASIwBhuC7sNYjp1hEHRGS3fv0Jke
	/+WG6c1jYbL7dgRhevSmu4bdBQDFFOeMTTgqN5ZN6GRhpq6xKym1chF7TeMNfq3QClKzpJ
	vwBwUHJpWeAQoQn7wwGJ/t8kSeSRdOE=
Date: Wed, 13 May 2026 10:10:34 +0800
MIME-Version: 1.0
Subject: Re: [linus:master] [mm] 01b9da291c: stress-ng.switch.ops_per_sec
 67.7% regression
To: Shakeel Butt <shakeel.butt@linux.dev>,
 kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, David Carlier
 <devnexen@gmail.com>, Allen Pais <apais@linux.microsoft.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Baoquan He <bhe@redhat.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Chen Ridong <chenridong@huawei.com>, David Hildenbrand <david@kernel.org>,
 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 Imran Khan <imran.f.khan@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Kamalesh Babulal <kamalesh.babulal@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Liam Howlett <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Muchun Song <songmuchun@bytedance.com>, Nhat Pham <nphamcs@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usamaarif642@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
 Yosry Ahmed <yosry@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
 Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <202605121641.b6a60cb0-lkp@intel.com> <agNO8G8tPnPuVrGq@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <agNO8G8tPnPuVrGq@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: a5qd3cth5r6gaaqh8jrcnwgmxpg8wk1a
X-Rspamd-Queue-Id: 53F9F4000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778638276-797663
X-HE-Meta: U2FsdGVkX1/x2SSZU8nQoAGS0R4hmDUXbiMUe7PEP4WY88pHvzfqj601FGXLHcC5oPGOZTNKzowRRpBQ+rxR4YhtoLcDBzvypgOCPXpXYIrFyE4+xpRdPnLZDxXGigdjPHPoAweJmzu7fiCPUbcrOFNPemWhsBjOrk7OeNHUSNQvrn6vtFG8akCZh/+YNcxGwRQK6wqwYAjTIK2J6P189YpXCNgoTsDkFUUcheIkXRwHBnyA7KyPCzqIfrMDp6qnxoe27R7SxIEsMZnm5r/hJFSZSTMgopsCK+4QXHEutezPvy3Lj37u7tk1KXUQgXDIRUOXt9rSAWXndxMUDOoH6tUUXZflhLR3ZM3wVPqn4AV3Q7IeNsSxgbVYB8MVPjwth0r2u1V3zgvbFG20JZPDta/9ihaShfLw/bgY8u3yZbDKcz/4SP1Mi1RD1pJZd6oF1VjW2tsc+ZXo/h86yvxKy/w7v6Bu61CtT9aicA4Yd2hTQ3ULb3ea8G8uBPioJXYxFKH1bFDbtsrIIyrtpON4mwW8VWHP9pGj6APiJDzET7LkpozBzL5x4hf7ZuaoghymN1hRtbt0/0wuXgt8Z+XfL6CXmbD8GTGkdVeskD6MWhlxy1cJzObBTSxlPvy1401kYhNOH+FuuIOx0M8e68lDJyq9fg4a+ozxuLNf52w0dh4qUonWG1O0PDJqMXTxWHPvpIuGCWEZ2iov7tuvFbyusOdAtVyZgmf5NKushXKUYpYc7IkxZuoNSnznasaXp9PR7ik1txfp6zS6Yjz1LwfobCCaBaG96oe+5a7czt+x+vPI2glMGnlHCLOBR2SdMkswIM3pMMId2EsoYf66gBKmNMgHCd9mas1z6ho6oq50RlqRJ1PAODjLfTeyVauwQAQO8j+mTWh45o+0MSWY4D4RYzK8VitBuBPgvaTOF1WWWdWK8SX9gkNdjl16I5jJNOBEKuhGpVMUNlAuGhXUHIe
 mkPOIB9l
 XqpwzRe7vapTfKDpG4RutDI0orj7Cwq0b1wb2QVShE7k1t6TnMdPkDEwhAyOAm+VUXbJwdwKu/ZK1joPJEZvgziodeUuAzhQN3GN0sD7aMVK4G9MzuMrLDcDHM06+w5Ta2PhAumDkn9oc7aY/MM+hsVoX3ZfaZof42J9PJthWS+sNL+3Qyqy//24XPZoMcpHsHL5mvlMvi66g1KXpxPHZTO4wqtfwC1m+kuOjE1aG3D99VzL9a7RnwdZ4SDCLu+Tv8G5RNhszl02gUbtYHvNo2Tt1bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/13/26 12:03 AM, Shakeel Butt wrote:
> On Tue, May 12, 2026 at 08:56:52PM +0800, kernel test robot wrote:
>>
>>
>> Hello,
>>
>> kernel test robot noticed a 67.7% regression of stress-ng.switch.ops_per_sec on:
>>
>>
>> commit: 01b9da291c4969354807b52956f4aae1f41b4924 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> This is most probably due to shuffling of struct mem_cgroup and struct
> mem_cgroup_per_node members.

Another possibility is that after objcg was split into per-node, the
slab accounting fast path is still designed assuming only one current
objcg per CPU:

struct obj_stock_pcp {
     struct obj_cgroup *cached_objcg;
};

So it's may cause the following thrashing:

  CPU stock cached = memcg/node0 objcg
  free object tagged = memcg/node1 objcg
  => __refill_obj_stock --> objcg mismatch
      => drain_obj_stock()
      => cache switches to node1 objcg

  next local allocation tagged = node0 objcg
  => mismatch again
      => drain_obj_stock()


> 
> I will try to reproduce and will followup on this.

Thanks! I'll also try to reproduce it locally and work on a fix.



