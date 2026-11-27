Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB120606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fQbw9xb+
Received: by kanga.kvack.org (Postfix)
	id A8DA86B05B0; Fri, 27 Nov 2026 15:12:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3D416B05B1; Fri, 27 Nov 2026 15:12:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904816B05B2; Fri, 27 Nov 2026 15:12:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 698CE6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:12:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9753A76D9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:37 +0000 (UTC)
X-FDA: 85481996754.01.0852F40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4F4D720004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQbw9xb+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810356;
	b=CTWYoMEHToOFQ6iu1u4A/V3xVjWU3Pu9RSdKTJ29Dumv1BtaGIU/RbcKbAUdroyFgKVAZb
	d+DVSJAiQT7ZkKSZc2ZWVc9z04pneIwGzjcR5Fx+hydAUGdM6VrFWdKxMfV/wyUfb+wr1O
	hSikUJ+OXtHt8hRW50MkqJdHvIMoxkM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=owWnceecot/leeD8xyntjFXOFZg34asqokQMnfZ8Nmw=;
	b=ru2ilRTLOOV3Ej4xwoDUnImB60N3jByf9AfcVzgiQJlTcpw0Lid5mWWDg2ThQdm+XFeB9w
	u6CqkPNgdNNZ8u3Piz6aj/064cXuqNcU4ofFt7jKWd9XC/yK6mn/0O2TQlaNI7lS0sQIIh
	G7y/oILymcRYmJb6QzmSWHb8XK6XFe8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQbw9xb+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D62F41B3E;
	Fri, 27 Nov 2026 20:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9C71F00899;
	Fri, 27 Nov 2026 20:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795810355;
	bh=owWnceecot/leeD8xyntjFXOFZg34asqokQMnfZ8Nmw=;
	h=From:Subject:Date:To:Cc;
	b=fQbw9xb+H3tdLoEd1DWy69WaURUuMmezidR/1lE1/0x48NkmIDYusYvGv5LtXa4F8
	 jKlRspjdtlEK/VX91eccVbUFARsDzho2jUdpGous0/5yMRjrGlbBrfWrcp4kQioTVi
	 tHQlZpLzBrXtpbI+2pwfa8hWPI7r0Sx59HHmwfvg2a+8uAVLnI3Zud2Ls68mLWdExS
	 84kgx/4xq/8tMQkQu+korTw63b/K8PsF1bWHfEX1IPLJtFO2ASE/yGJz/K2ljKYKZ9
	 sQYA8G64zU0ncWu1hT4WDYlzQ42kxeiJAmVvocr3LFU5y5ZogRvV6ow/euJ3ivIT1Q
	 fEQrEG2pKfOMw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 0/4] slab AI fixes
Date: Fri, 27 Nov 2026 21:12:29 +0100
Message-Id: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC3kCWsC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQyNz3eKcxCTdxEzdtMyK1GLdRIMkA5MUczPzZMskJaCegqJUsARQS3Q
 shF9cmpSVmlwCMkSpthYAfc43anEAAAA=
X-Change-ID: 20261127-slab-ai-fixes-a0b04d767c9b
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 stable@vger.kernel.orG
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F4D720004
X-Stat-Signature: hpry56hz19cerxgdnrdb431i857wo8yk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795810356-287848
X-HE-Meta: U2FsdGVkX1+4zGzbF+IIntYK6I9DmGi5l+vL61MxbjMcvO7j0wts/7S6+nAKfunE0RkwzJd+qnnp3gSDm6B9FgYOzpJZCDEGatJv/jaDrAMdX2Y/CxpzKFEJogPTluihB6iM8iXf1gOdViq48/bpfO8Ii2EUBwDfn84GtG6YEfge10BtgXWMts2UVOFQ2PBbnpWpR+UL0cQvKh1Ql9oS9fTS/gr+w2lOh7sPtRKauTcS1wz7718tSeWYGT1w6xqmM5XFNqCdv5Tcie5tCwQHwDqDoOjbUbRecgR8zZF0bYyAJjnX9CAAchKisWWpQcKl5CPlglfvxpzSWNaf5qMcuc6JwoGpanN367uprMdoUHBkAkS3CCKMNdnBRVJhD6X/nZWWznALqto5ZEiURV9rB9FCYKantbH3daZ+/wT7VRBG+gYyXRVobC41Hg9pK+oQ+JvERF2UhExqP6iQp9j9BDJdxlJQahnuJCtVDisC22kHjZsRhtN30H1uJiKB0lVKw1vwTtWzzR9WaWzJxGuxPEiecxvZWhv930IKqEWVdp/WsYSImteIoIzf8UH/rkIB0yLDaUcs0H9aOiHkj/htDHwPeilHdMPKFDfF6cfHiQv0459NFjBmofzTyRPhxsNPxYHHlBPR8McKFkd19w5WCRR0FceiEqj6pqRm/F227M6t3xP7IfpWOEDElEPwY4+Bi/BpZWF548LKZZ6Foy5u0e+N5XWqaeyjwAFyPUx50mJNaTGSxvmzkv0D0OVgr5cfGo2j9jowb2rdzvo+kplMTblc9Nn0XdmldQ7TWUlFGN1xYmgGneOFWa3dzWeYdJv2EELTKTvF5A3g4rDs0pmcKBwCtCA8uGCjNI0aiALMP2dkssStbkzzfZMCGKoH9Bq9afNbY/SmSECvNJHVou+0KM0HmPmbjNJ9gR65XzWaAKlMS0b/Wc/4+xP1xjzCMaeyni0RYMGzb/IfeALbsyU
 lQn3MeLX
 z2gI5mBSXKR6oxmuIE7H+rgpWSnbgztTP77ASxsiMSYdV7871yy654s2IjIJO4TfFByCH8O2bxixFLh2tANJCXTTX0Jkja4U4Bp34s1hi1qS/136MdheYm4sqPHNtZFao7jMNM5w7oVVBaLOdFjztLmptv5yqCmnMuS08qY7JsveFsd2kicvE7gziual7JgKZcXGCHOrhhStHrHX8SvLeeHmu3aD3CylO8Br1qhi788Kh0Cw4CboCd58tBJdaBaz8hKHPy2+Ot052zykwH5tIPIrXGGA4dRXN++nV4gW/dKqIZJ3wsHMHeMzTW6x6gbWufxQtJzNHtvMrzEvCvH260EMnd8CwisdW8MtyxOvE251Ja56gnxguLAmfMGnhqDFRl9S33BQu1ty37AOyw9IULQWLMEBCOmrUcimxPH4wMzE+MTRBbmmcDfiTa7Y2iGff0imtbt9OwRwOXNU7MuUH1KZFCkT8IG5gefDR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A bunch of fixes that are marked for stable but not really urgent, based
on patches from Chris Mason, dispatched to slab maintainers by David.

This batch is based on (and intended for) slab/for-7.5/misc

Two fixes for sheaf refill with __GFP_NOFAIL allocations and sheaf
preallocation. Those I've rewritten completely compared to the original
proposals. May improve slab behavior a bit under low memory conditions.

Two fixes related to the rather obscure slub_debug=O boot option, which
can in theory negatively suprise someone trying to use that mode.

Nothing of this should be an exploitable vulnerability, really.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Chris Mason (2):
      mm/slab: keep caches that drop debug flags unmergeable
      mm/slab: clear stale layout values in calculate_sizes()

Vlastimil Babka (SUSE) (2):
      mm/slab: drop __GFP_NOFAIL when refilling sheaves
      mm/slab: handle __GFP_NOFAIL better with prefilled sheaves

 mm/slub.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)
---
base-commit: 152bb61a6134d1d2b736cead67f653ce57ba559b
change-id: 20261127-slab-ai-fixes-a0b04d767c9b


