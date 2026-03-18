Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DA6E107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC436B0316; Wed, 18 Mar 2026 16:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692B26B0318; Wed, 18 Mar 2026 16:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581146B0319; Wed, 18 Mar 2026 16:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 444CA6B0316
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:26:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E49B0C075D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:26:53 +0000 (UTC)
X-FDA: 84560317506.30.4B80833
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A22E180011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:26:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjqhWUjo;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773865612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omCcHdWRdOm+fTURf5ga/RaE/DEpsT+QV5gLfRlUUgM=;
	b=5TCoWxDojPzCU6T8Y1YTrne+o/Ixhaz4m0vzOtq/Lws7KC4uuSSsIx5WCK2Y2Doe+n7v4q
	lK24DgH8qJVPAN/ZhVwwQhMaI1p6+QihtnX3oIkoHrCyNqM5MZs8NWk0ddh0up8ya+WrSk
	oQtVcvCsvxmWPA/RbPVGWw2dm+0yIQ0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjqhWUjo;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773865612; a=rsa-sha256;
	cv=none;
	b=jKha1EUA1azJx/syNMbFy+oF6UkaUmS0sBa+krfxROpBjFznd3kxP4xYqiEcsUs4OboyKH
	OQI0UOGVUGlEMj2UlNBVwAq9F9g9VZdtOKIqUwVabi1FQ4p5iECENmHAvUCYlERTmW0w/K
	R2/NJgaJC2ZAfzYA7dSlNdugjIjVPO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9551C60103;
	Wed, 18 Mar 2026 20:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCB1C19421;
	Wed, 18 Mar 2026 20:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773865611;
	bh=XBUlp6yu/XzavvGDQ2oaardMxGyBi9eSjX+6zu8ibzk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cjqhWUjoO7OVNBr8eT0cH2ultC3uPUsJAnHb8/H4br0yZ9sWzUcECe0zjtCjW29PI
	 vDJe/W9iX1vJGagrsL1tf/X9+o0lq7LLAvT2V4MJD8c5kUkLXZSlIrLliteopaYypg
	 1CoBPYGqvTRioCVH01ASzNw6hGcvTf/0rsk16f7Ai8ALjOfA7jKXpfUVntNEIGkGRf
	 5p84O5j6snHUYnoU/xJwn9joQlHjLOWpwYzrM+QF+AGgpaZMJceeX8qRNzSjniP0yf
	 ADyblZ8OHYi3MKAprQkcynEYQ+9QX2fMCO5QpDzfp0C0SBMo+QNppC+d73PfkehLZv
	 oAqO+nhHSyUjQ==
Message-ID: <fb40be0f-7a75-4116-8d96-c025b811cd6c@kernel.org>
Date: Wed, 18 Mar 2026 21:26:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260318200352.1039011-8-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3A22E180011
X-Stat-Signature: 4x9uhpibsrxrr4374iddexh7h9j7at4o
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773865612-187410
X-HE-Meta: U2FsdGVkX1/LfSJPFVpmjTaBuDOMqQJZuuW4GXdhfmK5CnJyU0IhENtGAD+9D8ck/tE2vHSbWEaRdid1O2CfWuBBC4YiIsS92asoxOoJ4+TevXTU5KVPhi5tHj6r816lrwjgwshGVF6U+XFh3QKQpaBnG6gA/YM4ndptVeD4wW0vllIBTXth31P8MF2gfoqU2SCbmWQWMjn54+rfm0AlG770W8t6+nGB+C1+lNeezvykKdqMW1iDibrhozO/+pcNwkeds1zqknb9UIoBw+Hrhab1Mj1nlp3/uMWT+76DSkmYTtpQmZM+P1cm/x2eYtOkouKreRy1cJlbMgtxNGHzCW3iYpHKYET+Kzg5KTpTYQho6jPXzjZbJgBqp4+gQdAGiM0Yw877ZmTdo0wValodtaoxxHhakiPpjn2C2G/ZLdJO8rOcSuzml+zH+0PYLxESKFTEm4pcu2K0/92M1n4pm9+VXEvnCaRDqnaHfrOkqgOgScQVO9v1tdKnH1xhPJbpJWQ10WG4obrwfWFHIijodfKJJJUCmUTYOrmnYX7O6m5dXjjL5FTIEt4+pCkqJrfDd6l5FFU5xWh8mvTQvB5LXBeZS7/6onPCrZ7AkNpTQD47oTCz2UqGIi7wPI+8QjCU8B00aJz64Un/I5uFklqjZtP97oZBhvZdbjZthIPoWusJ+iMLdBcEvl1d+fQ5noO2rDOq9VeZ3NP/owEYGCY90r3DpdBsV2lV2QUGFUFUgDQ926MrHk1WSGIH8nD6O8oO+u5haNUNAtoljgfF68UzUVz5RYJuMlY9IC/8f6p97uzeljSZ21tQ5Ibovim+pH84O0rqv2nmvRhgY7raE2tvZw9JNvfWVec/4pxZ0FhGirXnxa37unWaht78mGtYLERE2cWMImY2C9hwxREw9sMa2hC6bWVGDWyC58Oa3gXJ5I++Mu7eW3ypgPaEemJfbASnAQW/Tg4bgBC667d071o
 DtvX0pov
 1+3PUEdnuuDlVoHdPOosj1J5rNUEyOzWvpIWSHOojf3GT5wXXtGm2nMRLQ4fqFTdhF1h5HmXvwKqz+/yXr4BDCmEBosYutS5+24av179NxTrTnPU/mzr4Y6FJDRonZGPkwccYo/c5yTWvGK1WGJGHevVoGbKoHHcauOJjWRy18Wj9kV6n18P0LEtBtiQgbMR1hbvIC7A5GayNsODcSbuDRRj9QtnnTKeikYxzyx7eeW4oUCdnxJT7Gv250+UOAsnVYFHHtjv0Foqj7c2mxLcMoFiPtK16RnTV9Gti/R0Pyk2kD2WAuiq8KhVCbF/Y7up0r+xlRr4DzoTqnzPNlgJhK/mGNPYhZEVw5T69NhGtEBncpmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 20:53, Johannes Weiner wrote:
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
> 
> 	alloc/unmap
> 	  deferred_split_folio()
> 	    list_add_tail(memcg->split_queue)
> 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
> 	for_each_zone_zonelist_nodemask(restricted_nodes)
> 	  mem_cgroup_iter()
> 	    shrink_slab(node, memcg)
> 	      shrink_slab_memcg(node, memcg)
> 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> 	          deferred_split_scan()
> 	            walks memcg->split_queue
> 
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
> 
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
> 
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> folio_memcg_list_lru_alloc(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
> 
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

Was just hitting sent on a reply on v2 when I spotted this in my inbox.

-- 
Cheers,

David

