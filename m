Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9999FF506D1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C216B0292; Mon, 16 Mar 2026 09:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73AA6B0294; Mon, 16 Mar 2026 09:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85306B0295; Mon, 16 Mar 2026 09:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C698B6B0292
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:33:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A84E1A028D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:33:58 +0000 (UTC)
X-FDA: 84552019356.25.87C1A46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E263CC000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:33:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwaxByRQ;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773668036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pHD1nnSKhKYhq03XdGpvRRH98MkwW6UmLJqQGr4wWY=;
	b=fTUeZ8mESGAP4+V2kmmtjf3sZ4bz7U2GJN7peNeTHA3uWOWGe8H2yNC/EJD1LMksf/ryhS
	eAQhFZSOnXKinSId5T8x5RJyGttCH/xyTlBdELM1wqMB8fwLm3hgXr8MWuGKnWUvzmGQan
	LfzYoIywPL+oSI+IKOYUpYWX0nv0jws=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwaxByRQ;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773668036; a=rsa-sha256;
	cv=none;
	b=0F6ZFL12+cV+lJn8QeKZkahLvv4rykeftGpDlrTjRQdo6jCLv80cFgmucExdq9g9goQUu4
	z6MC9RP/9GBB1CIiYZg/nF0NatrjluUQnofie+olJq5sQFvcCpHGlNmOq25+AjY03igYUc
	VlorHcSiNE7STtD4ijiSSO+8K8g9fpY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47E0060018;
	Mon, 16 Mar 2026 13:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376EFC19421;
	Mon, 16 Mar 2026 13:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773668036;
	bh=LYoMYbkubw56J1IU4QmmSj6p+2qVdbBFc92Lq0WLyIk=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=bwaxByRQGj/YvaemSLfVHRUCMGiimGB/69S4PEpq5+xefFKADjoL7I3Ww/5/IbFG/
	 I2MRAo4AhlOmCCFoO5JpHAVShgWciywQwlzLi7ehDzS2fo3flmh8H1glREBxdiI/oV
	 OhGc/acsvcR+JnQJ+81Ix7bcip7bYpyMwLq1jU1shlkSG73COwfE76NkQ++oFJTVxr
	 gOM0RtlDUR/MmvrFufTb1uJ005b2LAEdzTfeE+rhkXptVJLFH6lqIeL67I41Ralc1O
	 wUhoHKroWAz/xD37TZ8UKKaH6XmlwJDtLCfXLI/oMHOfUwKHsI5Ybd6glHjlEOCkiP
	 gGKepnrp/Z6Rg==
Message-ID: <e8c824d2-2234-4a29-8dc2-5de9f638b114@kernel.org>
Date: Mon, 16 Mar 2026 14:33:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH 0/3] slab: support memoryless nodes with sheaves
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E263CC000E
X-Stat-Signature: 8xxdnx7wemqqsywx7thf76a8bdyh157w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773668036-86882
X-HE-Meta: U2FsdGVkX1/SYhmHuqEctaQF3z6Q21dwDoCZM7PK1CNJeU1n2sBIMijwjJHbAwn9290XxmBFlMwp6UYzOy5FAG6hpMEpCE6YTB7ZNSzVf/AQJITRfCZXjzdfhm3hlDSZhZqBZodPGhsUuAqkySdhpghjdwrUalm+1IsuCUJjp86qdYnW1IIUiyfumv8ZGF9sySCgulYVWoNKkGEyx0H4Rf0OOL+hCh7cuoUUqR9d0/0RJ63+XtoWRk+llT49KQcNwxcQBRwOG7PlxWYW0uQBJIMfjYX7qK1MKGglkliPg95yZIbnudrdjcBqm2aMDRaeCM3RCBg8Gx2P05+487GzAlZoF2kAwS+43yFyOzWGw5YCKN0E6ot6jKUGRbNQc0oMCdmj6jw7j476ukL4NKuttLoYIpZw2u9zKApponygvbvBbn3CH6B+qqaNW2vX0B5X5hZhMgHQngkalHFmMXzrxwQzPYsEIkgZmU8usan424MGtTQrpbl2FSPliUOIVty/wwOWmtClh7T0KxBmqdvbuby1bEacr8FsjTJ55n9UjHCQZRgfOXwQl3+zPpAHrV1nreP0KZW3S36Yj/TKXU7AUqgBK35lQoqCKZdJRJ8WrQc3vmyZkpBjr5YGxI0eAnAYtvAibqQgJFpY0eF46ZU3GnMDL2E3uMU3gqdqHyXrb0FdX0wrA5i2td4DbMh8KqBFrVGB/E58Tbnmz6Y6V0upk35W9XwXf60HE8pmFBhKVBOPO2msMxRiyI6W0ADPPXUIK4J7FTwh8OQfJ0yueL8wtC3XbL/0cyNJKm7YqwwuHigpLsWD1VhXAFm/YPWGsyRQi3RB+AYx08EmsVrQahVLrfbA/GdjzIs4potd+9rmaIIdY3psQZG0Dhlvc5znnzfyPToy5314vtrg9wA9ufKk+CZj90pVDb6/gxgkJlrbgCK5bKiD3YrnmPbJWhCpQ4Tl7QFq6Mp/YWCIxYxoYOU
 8TyxAWsd
 63BVPEGjuUvTPZnTn/Ke55TbYDxfjNI4KXzRMP9pXTxrJawLHNbFFCHY8LkGgWzZJ6gs1j0aB7XlHSzzEN7Q/c0lmL26t3rIGCNB9pF/Mnxal/NU/5LmCml7cZopuRYSSRtISxKDV/7mSCGUPpOzkFtIRqcfgnQDCNm1AWaIWiECc3LBwu3CB91zIgNf1C7hmZnQuGOywpCMpj5bCDPrKPl/6tXmsaIfHPh9sduoD7QnoQmkxNFeppqGN9vOpSvapNHeIonjxyR8S9IX/ckql89QGu+z883BmWtgy5B1dAVCtxutMixa8K7OZx5bjJ0ed6Fq8ftBIFLbLTrlQkpFZMRJcaGx+BrFsBXsj5fMy9JWS+hxMEvWgR/6bfa47+fesif2mGl2Wv7YZal3Kc4BnMshQVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 09:25, Vlastimil Babka (SUSE) wrote:
> This is the draft patch from [1] turned into a proper series with
> incremental changes. It's based on v7.0-rc3. It's too intrusive for a
> 7.0 hotfix, so we'll only be able to fix/reduce the regression in 7.1. I
> hope it's acceptable given it's a non-standard configuration, 7.0 is not
> a LTS, and it's a perf regression, not functionality.
> 
> Ming can you please retest this on top of v7.0-rc3, which already has
> fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not
> allowed"). Separate data point for v7.0-rc3 could be also useful.
> 
> [1] https://lore.kernel.org/all/c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org/
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Vlastimil Babka (SUSE) (3):
>       slab: decouple pointer to barn from kmem_cache_node
>       slab: create barns for online memoryless nodes
>       slab: free remote objects to sheaves on memoryless nodes
> 
>  mm/slab.h |   7 +-
>  mm/slub.c | 256 +++++++++++++++++++++++++++++++++++++++++++++-----------------
>  2 files changed, 191 insertions(+), 72 deletions(-)
> ---
> base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
> change-id: 20260311-b4-slab-memoryless-barns-fad64172ba05
> 
> Best regards,

Range-diff in slab/for-7.1/sheaves after applying Harry's feedback:

  2:  cc67056e94f1 ! 472:  b002755da434 slab: decouple pointer to barn from kmem_cache_node
    @@ Commit message
     
         Link: https://patch.msgid.link/20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org
         Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
    +    Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
     
      ## mm/slab.h ##
     @@ mm/slab.h: struct kmem_cache_order_objects {
    @@ mm/slub.c: struct kmem_cache_node {
      /*
     - * Get the barn of the current cpu's closest memory node. It may not exist on
     - * systems with memoryless nodes but without CONFIG_HAVE_MEMORYLESS_NODES
    -+ * Get the barn of the current cpu's memory node. It may be a memoryless node.
    ++ * Get the barn of the current cpu's NUMA node. It may be a memoryless node.
       */
      static inline struct node_barn *get_barn(struct kmem_cache *s)
      {
    @@ mm/slub.c: struct kmem_cache_node {
     -          return NULL;
     -
     -  return n->barn;
    -+  return get_barn_node(s, numa_node_id());
    ++  return get_barn_node(s, numa_mem_id());
      }
      
      /*
  3:  285bca63cf15 ! 473:  f811cc3d9f6e slab: create barns for online memoryless nodes
    @@ Commit message
         nodes, tracked in a new nodemask slab_barn_nodes. Also add a cpu hotplug
         callback as that's when a memoryless node can become online.
     
    -    Change rcu_sheaf->node assignment to numa_node_id() so it's returned to
    -    the barn of the local cpu's (potentially memoryless) node, and not to
    -    the nearest node with memory anymore.
    +    Change both get_barn() and rcu_sheaf->node assignment to numa_node_id()
    +    so it's returned to the barn of the local cpu's (potentially memoryless)
    +    node, and not to the nearest node with memory anymore.
    +
    +    On systems with CONFIG_HAVE_MEMORYLESS_NODES=y (which are not the main
    +    target of this change) barns did not exist on memoryless nodes, but
    +    get_barn() using numa_mem_id() meant a barn was returned from the
    +    nearest node with memory. This works, but the barn lock contention
    +    increases with every such memoryless node. With this change, barn will
    +    be allocated also on the memoryless node, reducing this contention in
    +    exchange for increased memory consumption.
     
         Reported-by: Ming Lei <ming.lei@redhat.com>
         Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/ [1]
         Link: https://patch.msgid.link/20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org
         Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
    +    Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
     
      ## mm/slub.c ##
    +@@ mm/slub.c: static inline struct node_barn *get_barn_node(struct kmem_cache *s, int node)
    +  */
    + static inline struct node_barn *get_barn(struct kmem_cache *s)
    + {
    +-  return get_barn_node(s, numa_mem_id());
    ++  return get_barn_node(s, numa_node_id());
    + }
    + 
    + /*
     @@ mm/slub.c: static inline struct node_barn *get_barn(struct kmem_cache *s)
       */
      static nodemask_t slab_nodes;
  4:  1fe49af3aa46 ! 474:  86e18f36844f slab: free remote objects to sheaves on memoryless nodes
    @@ Commit message
     
         Link: https://patch.msgid.link/20260311-b4-slab-memoryless-barns-v1-3-70ab850be4ce@kernel.org
         Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
    +    Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
     
      ## mm/slub.c ##
     @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)


