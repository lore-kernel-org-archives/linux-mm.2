Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFDDF506D3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812516B028F; Mon, 16 Mar 2026 09:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA796B0290; Mon, 16 Mar 2026 09:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720AC6B0291; Mon, 16 Mar 2026 09:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D93B6B028F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:19:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 064271A0248
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:19:23 +0000 (UTC)
X-FDA: 84551982606.08.529D3C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77AF9C0003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:19:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pIf2SEbz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773667161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kD4PgddPN+lFAJQH7LwodF1eqO7jJ1utWJZ1OAtHhJU=;
	b=k180eIRuPbzCiYqg29ix7ZbmV2nZ70VklQmVut6Dcik9Eetxw8do91qwnNj45wtE+bNddu
	CvAWNHETOU+J2GevAC57MGqSyNN3vMC6tgTV49lawWphxmorYWcyzBBxP+f728fm2eDkfd
	ubVG5T8Xdjv8LO0USi2cZ2egwfjRO7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773667161; a=rsa-sha256;
	cv=none;
	b=rX6bB8/v2IKMSdf7Lqv+h7rNhVfdifx7wWLhK0wEiqkx+cljp/fAuuuacKi31fCpYzLxJg
	Z4ZameZYWf1/ksybdnCFLjeiULZcQgPYufEvSpvga6LXEO7RChsrgKqfmXX67JakdBH+V/
	plgSBhYULimWDHwx7EkRT0Dl5TIBLeU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pIf2SEbz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB22360097;
	Mon, 16 Mar 2026 13:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CF7C19421;
	Mon, 16 Mar 2026 13:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773667160;
	bh=+akrXJ7NcRkZB3anvBaBKNDtpqIUvhYi+CUJ5U5SeJo=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=pIf2SEbz/mNFJt6nVnG6K3cTn1Sgk++2rlTnZfyRU4RFEZoUNcfa1Z9qLoD8up1d0
	 xn5f3GZUCBv15DrJNsUCU2qJ3Q+kMpsOSM+pv5r0v3IWlraaWTjNKkFb6R1NYwCC+j
	 pH/8t2kt6owcvjD8/ObU5a2+UMOkY4rVcvJRt+XZf3pJ6qVe9xKW1uRbcP3Pz4tNiW
	 8KecPG3X53ainVtCQUwvF4e1BVWgtSfPb6uRonqDshhsg4jX6prkM37IxP8Wd0WrfJ
	 5B/tajIcdGQyWsXv8qBqKV79NCLFx86hnS8WiX4SrUgDsfW16ZefwcvjVkpYh3q9sp
	 ahHxHqn8jSu9A==
Message-ID: <39cecc4a-608f-4129-a68f-fc23987c8591@kernel.org>
Date: Mon, 16 Mar 2026 14:19:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH 1/3] slab: decouple pointer to barn from kmem_cache_node
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
 <abPYaocgFylosUCf@hyeyoo> <94d89d84-c009-470e-a401-1ac75228cd92@kernel.org>
 <abP5dYLqkJrOYDQZ@hyeyoo>
In-Reply-To: <abP5dYLqkJrOYDQZ@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77AF9C0003
X-Stat-Signature: 36nbrw6enwdiofyd3x5t8pjokom7opba
X-Rspam-User: 
X-HE-Tag: 1773667161-675042
X-HE-Meta: U2FsdGVkX18zSCYT+4HKPI8Wo68euKBsRvIzx4TAEkTSH+ro9blSXrFU8sSB/pAhhln6pPUMj0UgZOHMZTEi0+U+qouRaED01XjQyONxNsOVroR+pjpK4X1rt6xwMseC/IWwuBL4/2G1JO+We+p87wO9ljCJWfm/905BvcoHJWhtVqtQOO5tcyUXWULQXmuSuYoIcfjprW56YhSJCiz78suvsq4EQ3iEiCBzVkE1rPNh8h27giaHQt/Po0VYI4oDZFVpjMTBeHhOZt4uxD2eA8fLsu387u0AdWygvy2HqsZSFjy3Yt+1yOUWKWtTD+6B/5UpgrV386JcnEwMexfyUudcv9QIQyVds4EZwMptAm04ZW+NgTDUj3XKCjaUTwzVOGj5hyKojADEq9QrcnfjyqUzOr8o7thXel4EgKNfVqyxYtDp5WrRlONyIhvxaqajGyiRLjniD1p4Okb7lpuRdN222Lzun/qk6gs5Hk1+Va/f8J5+CJeDUHPxHMUNoDaiSdVwmw3ZJA1nOuI7z1tRumITttaxxQ2KiTwdAo8K2cw/T1QTWhr8+4RKwMW/z1uiz+xb/1/asXF2TuEX8gMfAbOo2xUJUZjJxmxGdFNB/w0wVTuRMs1KJ0L2I5cY1WX41R1hjL95RPTkQBLdAhh5Lv/L+VQgPgl8+48u9weMhgazAfTlzmXsy+JrF8XWWSB+SxGKrRADuhnjnysT1M7hC1T20NJ5c57ffBSbsBC28i9l4jT7sadC2L/VHFDN0vMtv/mYICaNp7EzHRvrAQhdhYkfznXcA027uA5cPkS0RQ8AjVaEsaKx4zMydnp8mpxYiKP2eGaLFULXWaEhVQh00cwnBzCO2MdZy6D1dfNBBxMiOz0PiElJH1audI/cOFrNYgcagHrdL5Lp+/Y7K0GrsrT87YDuwEoxG49y/rxTZqi0fCnpn9J4TlyT/UaRj6LkORLAf8vg5u1wJ1BP8Xu
 Dc/4EsOd
 tY27Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/13/26 12:48, Harry Yoo wrote:
> On Fri, Mar 13, 2026 at 10:46:15AM +0100, Vlastimil Babka (SUSE) wrote:
>> On 3/13/26 10:27, Harry Yoo wrote:
>> > On Wed, Mar 11, 2026 at 09:25:55AM +0100, Vlastimil Babka (SUSE) wrote:
>> >> diff --git a/mm/slub.c b/mm/slub.c
>> >> index 20cb4f3b636d..609a183f8533 100644
>> >> --- a/mm/slub.c
>> >> +++ b/mm/slub.c
>> >> @@ -436,26 +436,24 @@ struct kmem_cache_node {
>> >>  /*
>> >> - * Get the barn of the current cpu's closest memory node. It may not exist on
>> >> - * systems with memoryless nodes but without CONFIG_HAVE_MEMORYLESS_NODES
>> >> + * Get the barn of the current cpu's memory node. It may be a memoryless node.
>> >>   */
>> >>  static inline struct node_barn *get_barn(struct kmem_cache *s)
>> >>  {
>> >> -	struct kmem_cache_node *n = get_node(s, numa_mem_id());
>> >> -
>> >> -	if (!n)
>> >> -		return NULL;
>> >> -
>> >> -	return n->barn;
>> >> +	return get_barn_node(s, numa_node_id());
>> >>  }
>> > 
>> > Previously, memoryless nodes on architectures w/ CONFIG_HAVE_MEMORYLESS_NODES
>> > shared the barn of the nearest NUMA node with memory.
>> > 
>> > But now memoryless nodes will have their own barns (after patch 2)
>> > regardless of CONFIG_HAVE_MEMORYLESS_NODES, and that's intentional, right?
>> 
>> Yeah it improves their caching capacity, but good point, will mention it in
>> the changelog.
> 
> Thanks! just wanted to check that it was intentional.

I wanted to update the changelog as promised. But realized that the change
from numa_node_id() to numa_node_id() in get_barn() should actually be done
only in patch 2, so I will move it there. In patch 1 that would mean no
barns with CONFIG_HAVE_MEMORYLESS_NODES and thus a performance bisection hazard.

> with that, please feel free to add:
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!


