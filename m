Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA1BCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A726B00AA; Tue, 26 May 2026 09:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1BB6B00C1; Tue, 26 May 2026 09:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F206B00E1; Tue, 26 May 2026 09:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644EE6B00AA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:13:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CE1BA03F7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:13:16 +0000 (UTC)
X-FDA: 84809611992.16.1216C4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5FDD51A0004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:13:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M3/XZUzi";
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779801194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6FFUN0+s0JG/7DGCWy33kO8G+yPZh0UptGXR8oA9X8=;
	b=sambPuSoDldRhRcPLR63b83y5ZWNy89XNkYdKEabrbmtFhx+OlFQm6LfTQ54oSi9mCoO++
	Goe3gTA0n9VoMjfDbtMZYinz3SejxF91wrRrjV4XMbn7zU1apHd5NX3Mr2x1sxFPJb+xWG
	E3/fInD5pj8yNTUJwHl1AbqKtaRf9ME=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M3/XZUzi";
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779801194; a=rsa-sha256;
	cv=none;
	b=GZce6SQnEwEq4GzHqExRPZZZeIOUDqC9inzB3tE8M6G2dE/cdqPCJyXgVZ6muusGeUJ2EZ
	7+jZsHq6xeDBm24WNABj/Vnm1FYkg70aLl/drcZAG8K+c5m7QfXBGUHsVizkua6TBBf2lq
	bFSR7UZE9IsvODSKtnDQO5Z4jWR/qq4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB10C60236;
	Tue, 26 May 2026 13:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DBC1F000E9;
	Tue, 26 May 2026 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779801193;
	bh=Q6FFUN0+s0JG/7DGCWy33kO8G+yPZh0UptGXR8oA9X8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M3/XZUzitaumcj1/KnoWZmvdgSRdUerVUHWtOpQ7yjJ9shktx2IW88h69FXGVVjaY
	 8k4nIov1fxmbgMmfpel6aLZC0xLOjiRntKLQkMVPCcyhc+jMy1LDRY2abpSVJuueFB
	 7qZI65LexUAeY4fXm6dD0mntx9qy+3+10s8di10Y+JvfkOzGyEnZwqEtKDqrF2mmbt
	 IH2tPqS4izlT3qB33WP8/2V5B+eheGO37bHrEMgDnZQOW2KwDM7NmdB0cimK6rFlb8
	 sjtVMBMje1aPmGYR0ou1y07Sf9da7o8kSvc6C0/AqShXSg0cIoGSs1iPZUDN0knrns
	 KAf1FIO5ylFcw==
Message-ID: <2aedfd17-17e6-4dfe-8ae5-c7342ead708b@kernel.org>
Date: Tue, 26 May 2026 15:13:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260520122228.201550-1-d@ilvokhin.com>
 <20260521165910.e7dea6a4e591d66293d2bd47@linux-foundation.org>
 <ahBUoB15hHbIyZMr@shell.ilvokhin.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <ahBUoB15hHbIyZMr@shell.ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5FDD51A0004
X-Stat-Signature: r4hstykc3he987wqntkpojg34c6yy6b5
X-HE-Tag: 1779801194-61189
X-HE-Meta: U2FsdGVkX18BQJrQGz5i029Ip08tbeyd17QckHCXNWznFXH2Vdbs2rwp+cULRSdIMFbD2y4J3I9BexsxRFBTL98h4cmmAD+8ulg3aaV3Fh0dLPaKgQofGRy9MluG9GNoVMRJFOArgcbfAZDkAOGs9rXXnpvfWrx4F2GsbuxTWWkAsM/w6UR0X43N8QjNyjdR/j/MpdHy9cFCvqawBWif7hrRc16qQyWGW5FtifMv4Jm5NxBBA2euGYcKKtlEUqooNk7uHQUu+q+BwPSreaCeeaAMyZ/yhTPbUYDAzVHWcIPyBkOXxncTirl2h6u09mNyNUSxIcmpt4rPhn7aC0nTbq3VGP/FfsO+7NPeGLqlJ29nI8PILSAEZIm84r+/yi4Batq/yzU4HE43U06s+sMxPUB7aqtaoIlQkB9W9o0y8pj6uLkL6Virl+Ri2NkAuXdj3HDe/G06b7A8UNiz8uQLjSEBXnNEdgPFOt0Ss5k1IKspewQDr2HE3xyIDGvQdWLpmRx6Lre/LfVyj1gUhilAZyBttJqyn57Wep/uPuagkpf6ltdcdNoUmyPnJaY9z3lJI2s9siwFNsfdxUMoRFRda8240FVYPSpKpjTcke9v1mRFIPipWoclOHIO+V1HtuUhcENvGDzP7IGEjxapFXlyD3znrtn4tLUzIz6CUlJt480mz4zvIx5EoSviS1IpwGFi1hLInk0pVuMNBLONLqUwCdxQWaddlr0OrMbTpZATjECmmpatmJZ+StyMlml4l5ULkFCLx/lZQrrF0Hnm3A79qkU1bYAwY0SS3423EogDtoMNpyk3hs/PvVmQTL5YrgaggklcZ+6sSlfuXHK2Ecp/FEiQLb+GMS81ZJ7TCfCCqwSkBTNQtoHO5o9aUvprRFcjpCMY00xv419ytDjVtducSDBktcJDxsds/1NeWO0ccmXhuyBkrypp1y9bzVAx5CIb5swXzA1GbIB6QYl5c2z
 unUaiFoE
 opdxEQc9WaFA28w18PfKVoAiIhzSYzGN12l1rlnCZYHYbnBGpvYkO0rVJiJB1De0BfHN+y5H2YNLO0+jjnuZfvAwGqBnIH86Cg9kqYIhjSQOU+M01rmBr/wjwl1YJJIoMCjjvPTfYKDwwRfGkEIlOIXceOg5D+SEfxBf6r0020mOaH1cPuSUp8XVuga2ulwp/Trd4gE3r3LwF1E3Okhcr6DybJA9OdUvEPJ04y6G+cqC5bePFwA6UAqWCfOov+k0xhsc3AtB4PSXj3zL9IJrkh1dC87b3xwtCntroOTgK/oQv6t9gvpNGdZOFQfEZ2TizEbq/azGvJjWlsfKirdAN4bIMWMmpCg5p2dAts0Yttb3u3tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 3:05 PM, Dmitry Ilvokhin wrote:
> On Thu, May 21, 2026 at 04:59:10PM -0700, Andrew Morton wrote:
>> On Wed, 20 May 2026 12:22:28 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
>>
>>> When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
>>> migratetype fallbacks and keep pageblocks clean. The allocator relies on
>>> reclaim and compaction to free pages of the correct type before allowing
>>> fallback as a last resort.
>>>
>>> However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
>>> direct reclaim or compaction. With defrag_mode=1, these allocations hit
>>> the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
>>> ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
>>>
>>> This causes a large number of SLUB allocation failures for
>>> skbuff_head_cache under network-heavy workloads, despite free memory
>>> being available in other migratetype freelists.
>>
>> That sounds painful.
>>
>>> Clear ALLOC_NOFRAGMENT and retry for allocations that request kswapd
>>> reclaim but cannot do direct reclaim themselves (GFP_ATOMIC).  Purely
>>> speculative allocations like GFP_TRANSHUGE_LIGHT that don't set
>>> __GFP_KSWAPD_RECLAIM are left to fail, since they have reasonable
>>> fallbacks and should not cause fragmentation.
>>
>> How serious is this to our users when running real-world workloads?
> 
> We observed it on a few of the Meta workloads that adopted
> defrag_mode=1.

Do you (or Johannes) have some observations to share about what
motivated those to adopt it, what kind of workloads benefit and how?
Because I have no idea who uses this mode and what are the expectations.

Thanks,
Vlastimil


