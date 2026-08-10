Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0EF1C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76EAA6B0095; Mon, 10 Aug 2026 07:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FDF6B0096; Mon, 10 Aug 2026 07:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C8A6B0098; Mon, 10 Aug 2026 07:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44CD96B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:23:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE8FA160124
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:23:05 +0000 (UTC)
X-FDA: 85085123130.05.2EA651B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 231F61C0009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:23:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DRwt30jt;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786360983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eesWqef+s8ssBuhLiDAIXIO1iqDPsSJGwT8bTKksJuY=;
	b=hytt891YpdMd+M5i3EfPSfIX5qsDrb6KiVpncTPqPSRL3KWQzzN1ruGeik4nPDmIDB5gh6
	JQrP35BRYIYWScl1k8AF7K8Yas1WBvg39G7Lk+ZXWZsJwWA2ladhLLjwMtaC9Mnn4NHAFd
	5rb/h3nJqdIQ+oqBvl+nzDRKJuP0Zb8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DRwt30jt;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786360983;
	b=WWFU98dWQ/+0KgwVCOpXH9MPnKHNuM72oGnsPEGClUoA8CH9B2V42HpZxH4TVtdB+fCQsS
	TaW5R9hBoqxwywshhOQgyAg0qCfx3BkFrIXU/RitSdhO8rBDDO1K8wmFFUfOqHXka/ike/
	bdHLV3t8BQwWieb3iAPH4YR/zPsxSR4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9FBE600B1;
	Mon, 10 Aug 2026 11:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3941F000E9;
	Mon, 10 Aug 2026 11:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786360982;
	bh=eesWqef+s8ssBuhLiDAIXIO1iqDPsSJGwT8bTKksJuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DRwt30jtwAkajLVWCwdOBKb12YYFw8pu2d2GnIsZg9cXJ6hJGeFXnQN3yRWBO0BFp
	 U5W2Bs3KwF2sSJgDLe583LTl4Xz8YVMZ//eGB4ci6yQvdmz8rMuLS4HXaTxPnIj1PX
	 wA1TrFSOi7E6w/9Vnv3hd5BeDXh3peJQZY670//SXB2x2jExtizL3AycLxadDz0U0q
	 wmL+9GsU2DGlPm0FgS1lZvlO+h1ICn7ov6ctnS4amJgl20eNTLTpMnauV8EBmY2o1F
	 HaLGXAWkS+5ymxHDEOMadxsy8F3QF4wx2ezvy0MVx8ldZv8Ij74Bo+Qi/Bod+6h3nX
	 ABuJh67+3DksQ==
Date: Mon, 10 Aug 2026 12:22:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xiang Gao <gxxa03070307@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Gao <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] tracing: report buffer memory in /proc/meminfo
Message-ID: <anm0SMuVpBz7wLac@lucifer>
References: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
 <69df3080-a719-4131-a247-62bf47bda8a6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69df3080-a719-4131-a247-62bf47bda8a6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 231F61C0009
X-Stat-Signature: x7qazy63dmsgfxm4fssrszszh74zx66n
X-HE-Tag: 1786360982-304961
X-HE-Meta: U2FsdGVkX1+Y6VqEhGfBSgeNQPP2K6cQVKTlmw6iSqNk7mr0wfDt9tV4aWPzvs9fpyRpJRu1aDTni1p32tYw8DEN9YIkLVl/YZ7Cfx4l0BBNDjE/6csX8674lKgQZ8Ji2Y6XYsY+BNikpFAHUEVKEVzyv9RkJChYNlLrSO5711UvFErvH3787F4YBBDQiYxg89CUfifRmbG07TMbqOaRVgi7v67XRI5RrMbb2tiZza8QQ71Nt+ZXbbW9iDpg06uHuNUqUkHjfZ4gTBZqpI4ubnZFXBF81D3zAcg5T4Zuvi0kGk8YseAxIvVfJcU/qsGnITlJ/UOfKO5ZQ2E8HchgFwDk9gGgRVo00UGnG15OSthlcO2jPKnrPPayJV2Hm7/7MLNwGZez3p0pbtYFZvjtVg8XIfCqyjbA1bkQgjw8LTxGCslL+j1bETG4VAN1aFd6j+JDsUeyrqda5c95Ly+XLu8zrRVHpmzd5GHQ8k+AX8vGq55v7+px0MY30qBGDU0Nic88Oh8N3MEFHaWyPBA47nwQKfKcE5ungKMiAH0nCcLZSUBXkkj4nSBvNXaj6WTgTNaFxwWzB3QrU6O248x6gboasuTJhQLFicHU12dR+D8uHIgmc8Kwr/+2fg4TIEu/ma/CbObiot5TT4jMVpDeXRz9vJsp+KtDuk6+3+ucfIxPHZ2SZsw11VPBMkSQYP8D82JxsFi0LLLhHTl3jQGBVMs82K2NhXrChBJBWDkm6CuzrlN5RuQx0tRfhmsE861UHcswIK1NaGbyJTXEDAXi3ObBZSakHvtGimSU3AY+BBM3fZWSaBWHWT4nDKxuqJQdcssFtHw8aJPbig2Mkbw3U3MRHeaG7s5Z387PPfuHcRhY3bf/MKS4w73TOZHekDkkH51qmUuJ+EMEl+Jy8pnPs15lYQTCOxGHQ0omNXosMYHN8iOjo7m8Ol1HzVSYpSeF3YPhpNwhQkB3VTL5ON8
 VjqXm57q
 jM/HWS/4GwVwluhq9zEjW2OlXuQov5/hAaBpkim2RLMdE3fcbnsLP1T10CpSmCUCvr6mhvs4esRzl58PmdaN+g3E68Hg2+kdUgqTyF84seC/hRMYMx2CdFQGb6ALtGP1RSqkDO1ScsKnZzI+35pNgYk9FcXWiUiCAKlS+OTw1u7DbePHdpqbftDX8BMZ4fFrP22Zbk1B+ePUcM1+YxHES1p2LdM4lN5Hy52q79ooxYByjwkMvgc9ErMsPXkEYd83Dgx8z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 12:52:38PM +0200, David Hildenbrand (Arm) wrote:
> On 8/10/26 11:40, Xiang Gao wrote:
> > Report the data capacity of all ftrace ring buffers through a new Ftrace
> > field in /proc/meminfo. Include the main and snapshot buffers of the
> > global trace array and all tracing instances, while leaving ring-buffer
> > metadata accounted for by Slab.
>
> why? :)
>
> To report a handful of KiB as in your example below? Doesn't sound super helpful
> TBH.

Yeah I think we need to stop with all the proposed additions to /proc/meminfo :)

Also something like this where you are making a change in output that it is just
your opinion that it is useful should be an RFC to see what the community thinks
first.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

