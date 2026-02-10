Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93BD6EA3F22
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 08:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8686B0005; Tue, 10 Feb 2026 03:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9F36B0088; Tue, 10 Feb 2026 03:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E736B0089; Tue, 10 Feb 2026 03:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8817D6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:43:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3768313AF2D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:43:36 +0000 (UTC)
X-FDA: 84427908432.11.8FE123D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id C19E6140004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:43:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WsdSuhsw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YqyGLj6i;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WsdSuhsw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YqyGLj6i;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770713014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nr78CD/CF9qf2q0cPYiNQFS5ULlN37P08eR3eMWbfOU=;
	b=CBnd7nEUOQIaddHT8cSBSloS29EyT1Y2GdeyQvBXGKVijCC8SPlGvpDSG/SkYIOEo2dAtl
	WgVZDbTC6a6ZZNI6+gja0GCYnihUXoJvEIuuS5fM1OtI/mZUoPnwZMjH53fKTBpgV3Z5dV
	xqHL4d0Q6ssqXFzb3GfpoBQUEvanGig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770713014; a=rsa-sha256;
	cv=none;
	b=pbWr7JsL/JlPUxSwkppDmjlmp3R5yWJhDCFbvbXWQw3QNHgbpz1qqINMgTLeLW8GzlkQcF
	cPJyxdTrJbpXZ7f9yAJGYL6PbF4ZZa9lNf/pK8RddyM98FItVv98H6bYXfG/rUS/13viPu
	vPW2JfNF/diCL25chVDoxVyibzdhNoE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WsdSuhsw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YqyGLj6i;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WsdSuhsw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YqyGLj6i;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EBCAC3E713;
	Tue, 10 Feb 2026 08:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770713012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=nr78CD/CF9qf2q0cPYiNQFS5ULlN37P08eR3eMWbfOU=;
	b=WsdSuhswpX8LS0SWKKr4CF94FVcRqlFZTPasfowYV6bFHcVvydjewi3Eus8pJtYE2/TYPK
	ZnhyVId1d1rv1G5QVITigfNFEVG8ER/7UoQ3cwjbUDDd261oJxyaWcS0Z0vXH80UCo7dsL
	rwuBNbsltur8raX4aDhXPX0l2oPqUbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770713012;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=nr78CD/CF9qf2q0cPYiNQFS5ULlN37P08eR3eMWbfOU=;
	b=YqyGLj6is4cd3Q01gdY4dK5JMqsJHDk0+7BIC2gbQT2RWwq97RZ7gOd/yyvUhjwwxYo8ph
	9M7V4l63GBx4inDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770713012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=nr78CD/CF9qf2q0cPYiNQFS5ULlN37P08eR3eMWbfOU=;
	b=WsdSuhswpX8LS0SWKKr4CF94FVcRqlFZTPasfowYV6bFHcVvydjewi3Eus8pJtYE2/TYPK
	ZnhyVId1d1rv1G5QVITigfNFEVG8ER/7UoQ3cwjbUDDd261oJxyaWcS0Z0vXH80UCo7dsL
	rwuBNbsltur8raX4aDhXPX0l2oPqUbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770713012;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=nr78CD/CF9qf2q0cPYiNQFS5ULlN37P08eR3eMWbfOU=;
	b=YqyGLj6is4cd3Q01gdY4dK5JMqsJHDk0+7BIC2gbQT2RWwq97RZ7gOd/yyvUhjwwxYo8ph
	9M7V4l63GBx4inDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C04BE3EA62;
	Tue, 10 Feb 2026 08:43:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AEyFLrPvimmWZgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 08:43:31 +0000
Message-ID: <34ac32fe-e082-485b-bead-4e6b9ae6a153@suse.cz>
Date: Tue, 10 Feb 2026 09:43:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab updates for 7.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C19E6140004
X-Stat-Signature: urry7eezzy7ns8dnztpx8ubpoc6sz83n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770713013-536894
X-HE-Meta: U2FsdGVkX18KOgo+8pduDjnSxyHHjlLxuJqNPoefQhDEaLcQWV/+2DoNiWj3go68e8qnufbbLng5T+VSDY+leCRmpUz1YygYW/kMrvdnBDMWwfnJx3d6K0ZzzBqOVPqEf66M/zs+WULiE5mDmi8CkPUNSP/2/WZxhq9OGQL1mP6rjh/N/pTOEv6parmFrUW3iXdhOx1jCZAyw5LtmLGKv/GiPDBfyebXiK4K6J9eeQOqg4A9hm4K7u0DFzD0cBBLl1z8iOSybi5DUNpqIVdGQzrV2jAnOsj0wVje4oPkfjxex7bVHY8Ntkr1tX5rE3yOKJ28f0EmuyNRDY0dV2qfNZVAHJf2QrctqSyuDIhi4jbvqC9Lb7rWwOaDdAT++tW/NBxp7skWTzS6HjiA6xuxUSRyzifv31bnSGIghuK9ezPN4+OlZujOAPBgLSDaANZh3DjjxfKjt6gYh5oRkSNkywNjMGArhmH7pgAqmvB7t9EsqfMvbIivCO1U09KuQpkw6p8PRcWMpmXbxVt8Z+X0Yl9HVOy3Lzb+90xYThzZfArDFFpNpxt2UCU9IQiPGPzwenOLVEzORqiu+afN5W1rpFmOS28Y1KpIOFswzqGGLKv8ZBhJmgQoP0Ytt9jfnCtbBhVLJPn1kwLZt0zEmcbcjTOoa1dhR+0xbd8WkrruI9xcgVTlg4gXtJZVuYVolZr2yVJWnBBWCu92mBS8ZVcX/I9o3MhwtNGjfuX+N7VwZwPTIe8ij9xk69p8PmchQW5L1gh/5a/l8SrkLr9/fQkRip3UnWNcTU7QtyOOrIkdYk7Da+yd7dWab8VPpeDEiau8pGvsAlgjCZNkIYemdV6orqzewS/jybpnWHGzm/g9riYVFkmmAXMDmIaHKdWkKJSwU6TEPWLw7YA65NOuAyO7rhX/l4sK4GTNVPZGx3ktuox6MEAxkXmaaLDrNjWyf8uy+TXuHu1fEa6x9Hl7UBc
 vzwQrwDa
 3XlAqPC02yf/stDmShLeU8WdOGZVTfijZRP5dizl9cL1JZnP9PsSKC1JVgRGA508hdSIJHAQrF63HNa7aYw/RET3JWsqD7iJyLX0XMOhJ1BuNv9DvMB5wumwkNOjT2Ub8z1+Yyj+GODuzI3BS8aIMTd6C1qyP+n48j8m4IvDueUPBvCKbK0emtEwkah+rcUSNY2IPSEjjFnOxveJIutjarCdaSYJpaXHRTNefEdR4Y6iGBwWCvVBVSopDTIQIv6dhP0LCqwOgXdZn/ATtYBhU2X/LWn0TlYzanHwoPhHZJpc3cT9t36QBtsyYJmwm9gYPq4ZiRWkRJtJ0pZgtd7Crbq8sYqpSRlEks1xl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0

Thanks,
Vlastimil

======================================

- The percpu sheaves caching layer was introduced as opt-in in 6.18 and now
  we enable it for all caches and remove the previous cpu (partial) slab
  caching mechanism. Besides the lower locking overhead and much more likely
  fastpath when freeing, this removes the rather complicated code related to
  the cpu slab lockless fastpaths (using this_cpu_try_cmpxchg128/64) and all
  its complications for PREEMPT_RT or kmalloc_nolock().
    
  The lockless slab freelist+counters update operation using
  try_cmpxchg128/64 remains and is crucial for freeing remote NUMA objects,
  and to allow flushing objects from sheaves to slabs mostly without the
  node list_lock. (Vlastimil Babka)

- Eliminate slabobj_ext metadata overhead when possible. Instead of using
  kmalloc() to allocate the array for memcg and/or allocation profiling tag
  pointers, use leftover space in a slab or per-object padding due to
  alignment. (Harry Yoo)

- Various followup improvements to the above. (Hao Li)

----------------------------------------------------------------
The following changes since commit 99a3e3a1cfc93b8fe318c0a3a5cfb01f1d4ad53c:

  slab: fix kmalloc_nolock() context check for PREEMPT_RT (2026-01-21 11:34:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0

for you to fetch changes up to 815c8e35511d0b9a214e9f644983fe477af9d5cb:

  Merge branch 'slab/for-7.0/sheaves' into slab/for-next (2026-02-10 09:10:00 +0100)

----------------------------------------------------------------
slab updates for 7.0

----------------------------------------------------------------
Hao Li (3):
      slub: keep empty main sheaf as spare in __pcs_replace_empty_main()
      slub: clarify object field layout comments
      slub: let need_slab_obj_exts() return false if SLAB_NO_OBJ_EXT is set

Harry Yoo (13):
      mm/slab: fix false lockdep warning in __kfree_rcu_sheaf()
      mm/slab: factor out slab_args_unmergeable()
      mm/slab: avoid allocating slabobj_ext array from its own slab
      mm/slab: use unsigned long for orig_size to ensure proper metadata align
      mm/slab: allow specifying free pointer offset when using constructor
      ext4: specify the free pointer offset for ext4_inode_cache
      mm/slab: abstract slabobj_ext access via new slab_obj_ext() helper
      mm/slab: use stride to access slabobj_ext
      mm/memcontrol,alloc_tag: handle slabobj_ext access under KASAN poison
      mm/slab: save memory by allocating slabobj_ext array from leftover
      mm/slab: move [__]ksize and slab_ksize() to mm/slub.c
      mm/slab: place slabobj_ext metadata in unused space within s->size
      mm/slab: only allow SLAB_OBJ_EXT_IN_OBJ for unmergeable caches

Vlastimil Babka (24):
      slab: replace cache_from_obj() with inline checks
      mm/slab: add rcu_barrier() to kvfree_rcu_barrier_on_cache()
      slab: add SLAB_CONSISTENCY_CHECKS to SLAB_NEVER_MERGE
      mm/slab: move and refactor __kmem_cache_alias()
      mm/slab: make caches with sheaves mergeable
      slab: add sheaves to most caches
      slab: introduce percpu sheaves bootstrap
      slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
      slab: handle kmalloc sheaves bootstrap
      slab: add optimized sheaf refill from partial list
      slab: remove cpu (partial) slabs usage from allocation paths
      slab: remove SLUB_CPU_PARTIAL
      slab: remove the do_slab_free() fastpath
      slab: remove defer_deactivate_slab()
      slab: simplify kmalloc_nolock()
      slab: remove struct kmem_cache_cpu
      slab: remove unused PREEMPT_RT specific macros
      slab: refill sheaves from all nodes
      slab: update overview comments
      slab: remove frozen slab checks from __slab_free()
      mm/slub: remove DEACTIVATE_TO_* stat items
      mm/slub: cleanup and repurpose some stat items
      slub: avoid list_lock contention from __refill_objects_any()
      Merge branch 'slab/for-7.0/sheaves' into slab/for-next

 fs/ext4/super.c      |   19 +-
 include/linux/slab.h |   40 +-
 mm/Kconfig           |   11 -
 mm/internal.h        |    1 +
 mm/memcontrol.c      |   31 +-
 mm/page_alloc.c      |    5 +
 mm/slab.h            |  213 ++--
 mm/slab_common.c     |  153 ++-
 mm/slub.c            | 3215 ++++++++++++++++++++++----------------------------
 9 files changed, 1691 insertions(+), 1997 deletions(-)

