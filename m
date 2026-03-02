Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990F8E9B34D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB656B0005; Mon,  2 Mar 2026 04:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC186B0089; Mon,  2 Mar 2026 04:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1B06B008A; Mon,  2 Mar 2026 04:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB9A76B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:56:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 581531D0C0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:56:51 +0000 (UTC)
X-FDA: 84500669022.07.BD298CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89C9B160002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:56:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QD+qQUgg;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772445409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dFoN1M3NErd2JxuXg1CqwNVpTE+/sqYUQetKIfOUDc=;
	b=8Nt2c4JSDvWx6SshkSd1HpgxnsM4ZkbXMAQ77IKAGiZDsZGCIcAorsUQn+/97jYrwEa97k
	4CyF7C8jLOsnT15BaMDGQj4g+u04TcKQM71QN4uldGk2jAVbojYG+IiFiWEFvsGkGkmk4c
	IwWJfqxNxkEAGne0i8V9HdI2CGjn0Pg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772445409; a=rsa-sha256;
	cv=none;
	b=GQWaXS7MAQ6jkJQI9vOKE4aQWwAXNn+eXVhkA4dNnVL626w5dLhxaf1YF69lIUS8Ja+h2l
	4Iswupjz65KkQwohjGcWzkU88WoR/N6SsM+X1Pl7jDXcUyhGFlldbj4CnPyCKSMSeV9p7r
	ByB7irASGmO9GJe0mGiIlYi6e1ByEXM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QD+qQUgg;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1897C41A76;
	Mon,  2 Mar 2026 09:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34860C19423;
	Mon,  2 Mar 2026 09:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772445408;
	bh=ymifcMsF7YD25E9NmfzPHaiii49VQhEvKOqAxzRSraw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=QD+qQUggdg16qUF+ThiK9SpceGs9NVztqTP4NH3rCuuNPvfJq58NExO1KA9LN0U7R
	 1leTG5x2NmvdwumDAbUvg3E34UadqLdtGmfiebpMOsR+mS0n4isgk1KeASKkixNJe8
	 tNpOA+eTCN5kKhCaYGsSL2PzlW1DfD+V67qnsVs6OYA1w4umVWMNAr/nT3YPfsT2Lq
	 OoDRNy+QdLzO67cgPoXplUVqAuKPVqegw6OtDzKKuPkE7NDXZJ2AWSgZqPiu8WffC7
	 hEijgtuowbB/ShOHcbezze8656WSU1XMMW0N0XBL8oI6oe7bdbO1lKSjbhF2ANOq9p
	 J+MmKdwsdjvbw==
Message-ID: <3016b42c-643b-4e65-a6aa-67a91676d3f7@kernel.org>
Date: Mon, 2 Mar 2026 10:56:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: distinguish lock and trylock for sheaf_flush_main()
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Marcelo Tosatti <mtosatti@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
 <c6e94e2a-34ac-4515-b4df-222f2c08c992@kernel.org>
In-Reply-To: <c6e94e2a-34ac-4515-b4df-222f2c08c992@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tbm3ig96nwkuds3atbptf3cmozzf6ucg
X-Rspam-User: 
X-Rspamd-Queue-Id: 89C9B160002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772445409-439963
X-HE-Meta: U2FsdGVkX18fH6C5kY/4Ns6Im1/R8CyMmXmmv0ppbt2RGgrEu+ZeNsngqL5d39SDYURav7iiaEbrXfb8KP6IiYiEje1uAPoszBqCoGJTmvog3Vmjsv796pMAO6za5b0ipaOLpAy/KnpDzL+2mcQNtyX8abKLzTTFlnvAcxkwZ0n5MhGNpfeiZ57Kxk+jqKRlO3Aer0h7uHBL0tSVT6HbR4YdQLqerddGSHz7xDAhTLYuwhUyI+TeUZWfBpMYN9sj/wwshpqd4eG4T5mz2pkNVOZsXV/hjdypbk75eKpF21E45CJY6YUEBGTEBkC9pEYkQEhrf1DBxU37drVkj3xFr1/nos9WsbOmFCHLDVXw9dZf12P4rNnmVIW3AZ4gquwvXDRkVSIFlwzAFPu6pmh2XX/meqctntAmerNy7LqiDWSoK6ue9i+VioD7TYjsjaC2SzzzPwZ/JLKV2KVzzztGo08oRVWTpbDXcLWR3eiVJlIrkGXOCAn6bo160Ldt8ESgUo5EYAWHeEYBrurr5qzRmbZ97fZT9+k25Jk183ex2+1Uw0NzaKcjFNLXH+2Njh5Hp+RAsZMKq4njttvtFcCp5iF/tOKKUx5zJ+A69uPRbDLPFUe7ZVtFnCCvXDt8a7PV11p58FeImM3gsau7xYuXCMpwng0sE5j1MochuUyI8iTNCgtdTs393RS/XZi0xqi0tCf2KLpDFog55cIXT8sMcW53OUV/gCwaM2d4pgIJHZ3ELF5+uWI3CgxCfcy/nS4kYs0pNCSkMDUhB7E0vFSYQiFHu7FU8BiiJhs4h15aGTXllqQ402/yWW9rFHRdBpXWOgdLbpOneT7RzXeN7J1i/q4AZBTc848M7sRZ7KpU1fFkfkUKO8bzPa0MSU9KECYmcMxq3afQ4HGaI98CN7KTIUphsUoSJarSyDPzwE+WCH50rhylBbzVAXA4vYABJtJbEbTVut4PxpV3ebbahvu
 cIvuu/EG
 NFC6U1NbstSqaZ+YR4JTzpdB6DSE3ISFd6xWBnUJFZe3rh27yBBVbL3ipOTXYnd2hECWsWgcYjL+1QgmSmEHvoqpCLUR6TuMoYv5ks4bKSMU3YBKNHQ7nY2zFApUgfNoFW2RI1+sw/VhuCOmvciDgCO+9z36xLkep/ep0ypF1lSH/ZkVvQ6pTtEdKBQe6fhsK09R4Yqa5DgE0U+0fCMkVlLFc0McK5mEjpLp3vmhFl7XiEvfrJxItPEcLe6bVqXdj+366eo4OQKq8vS9Nh3W0BnGkN3jCLkLgsNdOPimb4RXiRNH1NLCV5qpDUU6TFczrFaMrCS4T7lIFoj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 15:50, Vlastimil Babka (SUSE) wrote:
> On 2/11/26 10:42, Vlastimil Babka wrote:
>> sheaf_flush_main() can be called from __pcs_replace_full_main() where
>> the trylock can in theory fail, and pcs_flush_all() where it's not
>> expected to and it would be actually a problem if it failed and left the
>> main sheaf not flushed.
> 
> Thinking about this more, I now think it's not a theoretical issue because
> on PREEMPT_RT I think pcs_flush_all() can preempt someone holding the lock
> (on PREEMPT_RT it doesn't have to be an irq handler preempting a holder),
> and then fail to flush the main sheaf silently.
> 
> The impact is probably limited though - if this failure to flush happens in
> __kmem_cache_shutdown(), it means someone was destroying a cache while using
> it, so that was already buggy. slab_mem_going_offline_callback() could be
> where this matters although it's unlikely someone would do memory hotplug
> together with PREEMPT_RT.
> 
> But maybe still worth tagging this as Fixes: 2d517aa09bbc ("slab: add opt-in
> caching layer of percpu sheaves") and Cc stable and sending it as a hotfix.

Added to slab/for-next-fixes with adjusted changelog:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/commit/?h=slab/for-next-fixes&id=48647d3f9a644d1e81af6558102d43cdb260597b



