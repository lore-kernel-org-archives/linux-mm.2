Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED3CF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 12:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835E46B008A; Mon, 13 Apr 2026 08:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D6F6B0092; Mon, 13 Apr 2026 08:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A5B6B0093; Mon, 13 Apr 2026 08:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 665A36B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:08:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBB6755D16
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:08:05 +0000 (UTC)
X-FDA: 84653409330.24.775B818
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 13F7240011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:08:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJOkfgOT;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776082084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Is2KXjxOlWlFMdiKgVP+mDitijxmzGG2jEtm60EOepM=;
	b=zwt80vYgBHjRMBEB57SLYIwjJPBnjzSsqAFIxgJ65GSWKVInDorDnRlWRM9cYQK0yzvNyf
	DLZ+10lKeEXlLkOyp0Hglc1mjCztx9ZuxnZuG6DScyMvqj6JS8dVxsHFuXmjqa3ZirXzvm
	cN7hydwujga7heZBpeUf9HD2zHV8LU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776082084; a=rsa-sha256;
	cv=none;
	b=MLWrhlq3Ro2A+I+CsXedTWYMR5c373RlDa1VScFkZZYS+VD4X0yYCFgGJPPlizlT/i7EKf
	q5qRu4qE8kl33p364TKRKBde/Z6mpnp5knHruzddqJ/so8nP63lZubQUto6q1s7ZPghys3
	spb8/lpALnmfm7Hj/D9anid1+Xa4On0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJOkfgOT;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 704C460172;
	Mon, 13 Apr 2026 12:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FA4C116C6;
	Mon, 13 Apr 2026 12:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776082083;
	bh=CzuqnndQaPPPqjUDcHDOFEdKl+Mhkbc3sMJIr2VoIz4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LJOkfgOTVXrByY/YCoNU6lu20MscwD0d2ytYtsb2/Bx8O3lglxw9ocp+MCjOUI8SA
	 aNET5mN7fRkzdWMeMtQ8XNNRzw86YA117Zh2sNgDQqjsYxVWwag/+ZTLcs0CaXBP9+
	 royIUr8We6OGDaiHGedLn8kpKo7cY+MBFSad0NRPh584IBJoVDCqBVmhz2TAW4urLp
	 xTqIV+Psi5JFa2+MbdOh6qHfTkk8nMJ0pS2pcLOV8JV7IFy/VEBWOsN+b2L2Kny255
	 WpRbus1Rh+UnC9UePIJRzB+HcOlS/VAxE+Q5sfi4jzhI5l88JecKsT9VgkVGm9Gzn+
	 f1yEVSquZdx1A==
Message-ID: <80db81dc-99a5-487c-99d8-3ff5a687714a@kernel.org>
Date: Mon, 13 Apr 2026 14:07:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] slab: decouple pointer to barn from kmem_cache_node
Content-Language: en-US
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
 <f29c0348-0250-b34b-59df-9dd59e4985ee@gentwo.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <f29c0348-0250-b34b-59df-9dd59e4985ee@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 13F7240011
X-Stat-Signature: d8p3xh414h33i73wxtpz983ny3ukxdug
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776082083-96596
X-HE-Meta: U2FsdGVkX1+gq3iZmRGxDdMZUERVgLLPG4yhVkaC96w26h68MWsJiVh0Ow03sN+RxjU+6S7OH24BvWhunPXD9rKQrzUL2k1lveYSLi+zulFtYFRGk3ZAKzoiEJhua4TJ55R5s7Oye4/0yrC/0X7AWSxMtRMmeLWaeHzXZ8BXSpwiw+jSZA8AdE1iQU5jJani9I2L4TkOCOxuyPPdALgBfZbCU8bzRJROy+WkVdbK1jpMeTe3EOD/e7jzY/BVAVkkUkGTDA3/W3PYKitdgk/HL0P7Dh0v6Tj7SJmqWH+ItbTQiQjEr0xS99J+2DhFYDUuCX4AcPE3ns1XkSRHFQdJJi8sEwMASsMIIVfzLuNh8rXaGI7apKfXT3E6AQ6SXdfZuega5VM5Jc6ySe/6Lpex8x5A5qhjBPXlVeXPcK3CkjqbEjgJNkDkL3OjYAtR9Y4aTq8FYbphAPBZScijbl6mUbfpRLG2RpTZw1At77jGtob6yYQTbAMVyHMVWd8uMdNt419FfU2eTICDmoU67kstbhrSpX8gfFQ9I/kyu/4Up3exRmn/GHAy1u/nGdO9twvRzvIEk/2p1e/wT7t8ilVof1sY1YQK/U5K+mpwhMDvVpw4S1g1GdhfNZ+Jigyt9CcX42zV2jfPVwrw599CyFxL4jbqBHYVtfWXO+v8Mb5nVQt2IHi29rm9T0Jemh55PZHhriTAb5ZBdfIKTxq06apbO9AA0FK9qUoVFgBT+47ky4tn1UHYFcuKaWSjyaokFMXBjtGPOR9sth4NSRZgyB3CmgQd4cjRKSVPJVVewtuOdoJ3x8oYJd1qvoEtmOJV9NC4Gp4rktyQPAkMr7+5FhHNGrpeJhmHYzsI0S0BK9UF8XMRlq+i47fbJY6lkFnR0Z1ksz4eJgzEZ8i+Mtp3uinIeXoo+ZQZ9SARh7NIz3QNpIhv5+sP6+R/sPIUImE+nhrl8swJ+fRdWwBAsRTIJZd
 3PR5MEqN
 5Tqs/Trjjzs5v4PfiglSpcZ7m+BOq+GQ4OYbLLZt+x0Unt80SgjXEVrVFfULlWIBxK0kbnKAafwkZsrzzCSkTI7MzE7EJHSs636vrUnjfY7T5NoGsf8qVH6PFVNuI2dVT5Fz1Z+abK7xQuCMBPSV7oc2+x7ka+30Xi5U7ZX2JRnBYfpYn9plCbRwoDE2WeklkWOnXkhGGdBLJ0GRisjI1WleQuXxDf0+Lup6fCgWWJVVq72nRIa2fEciOI7VfbiiAeN/FNpzTrnjmad33vyHyKuok4419jXbybtghmMsf30Itc1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 12:12, Christoph Lameter (Ampere) wrote:
> On Wed, 11 Mar 2026, Vlastimil Babka (SUSE) wrote:
> 
>> The pointer to barn currently exists in struct kmem_cache_node. That
>> struct is instantiated for every NUMA node with memory, but we want to
>> have a barn for every online node (including memoryless).
> 
> Is this breaking the 1-1 association of kmem_cache to numa
> nodes?

Assuming you mean association of kmem_cache_node to NUMA non-memoryless nodes?

Indeed if we didn't separate pointer to barn from kmem_cache_node and
started instantiating kmem_cache_node on memoryless NUMA nodes, it would
break this 1-1 association. But with the separation, it shouldn't.

> I would think you needd local per cpu queues on a memoryless node
> for performance but not fake node structures.

"barn" is only for handling per cpu queues (sheaves), not the other per-node
structures. On memoryless node the sheaves will hold remote objects (as
there are no local objects) so it's fine that there's also barn for sheaves
with remote objects (and empty sheaves).

> Per node access is already
> serialized via locks and therefore slow.
> 
> If you break the association of per cpu queues to cpu and kmem_cache_node
> to numa_nodes then the code may get complicated.
The sheaves "empty on alloc"/"full on free" handling code would be more
complicated if the barns didn't exist for memoryless nodes, so it's better
if it does. The kmem_cache_node with partial (and other) slab lists keeps
not existing on memoryless nodes.

