Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41454E7E36C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 12:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80A2B6B0005; Fri,  3 Apr 2026 08:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1F86B0089; Fri,  3 Apr 2026 08:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71ECA6B008A; Fri,  3 Apr 2026 08:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63DAD6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:02:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 082C0C2453
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 12:02:27 +0000 (UTC)
X-FDA: 84617107134.17.8CD34AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4009420015
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 12:02:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ul3iLkil;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775217745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsx1GuxijVxW+bBqj2lr+ewqYcPYLj2e+o4huqXxtD0=;
	b=Y4BNlZJGhC+4GEFBnRe4dNUunhuapb2WK3R/9YcePMuZ3LaVWcSpHU/vPWcK7tPA8j/unD
	BKgUErKINtlu63OGy65JtrWdBRzLk5Gl1bd0ny4RZKYTx9nrLs2vLGWAunjf121Lop6zft
	7wTKi9PCtGyPO2a1IB3SzMniXPKCyls=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ul3iLkil;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775217745; a=rsa-sha256;
	cv=none;
	b=G8mkK38cpCToJZ8NAUiaITZglfOTBEE1HC+aU7zk51iBEQeIX/0Hsr3X3raPzj0b2OK4c9
	ExMbIud5/gKdyFfWHD7QWEMMf8ivUUGAh825paG/0L4UKI7BZXxwa3RbO9AAAx97YbX7IY
	f3gdPd6LtBHsafJ/pYthMPGoCUtdBCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92E1260125;
	Fri,  3 Apr 2026 12:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A190C4CEF7;
	Fri,  3 Apr 2026 12:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775217744;
	bh=VmzjbV92+0hYtn6qtVAWC6sPODyuGXfidretO/w7HaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ul3iLkilKYa6CqF52Uxgm/E7xbB+YQGSCpMxX3q7K52q4NPOuhWWm9NYssRVlxWA3
	 vg+RQIN8ItHom+SqyEde78040apH7Y9sKL1xWgKmsSiX3s/hj0btv7wt3Nhf8D9vbg
	 o+C916r6YtFFBTfcptc1A5LDKralPmFD8ELuZfCt5SVJCtLU9+jeqpOLauxT64Gbzn
	 q6PwvKXoEB0pnYHBpTnkNdAPWW2Pl2tsrNyNmtmWkj28GBOGYQol31PBCWYZPceJNW
	 1lGnouwNf9nuP2KRsV2xw3g4eEG8IIwgE8ynE0w0okPCor55B+KZ7ydgwhM1kT64kR
	 MJLhYnNX+VjDg==
Date: Fri, 3 Apr 2026 21:02:22 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: use N_NORMAL_MEMORY in can_free_to_pcs to handle
 remote frees
Message-ID: <ac-qJ7tYQ-ybegOw@hyeyoo>
References: <20260403073958.8722-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403073958.8722-1-hao.li@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4009420015
X-Stat-Signature: i61jq7gamfc6jdcwu17umjjd3bgtxgsq
X-Rspam-User: 
X-HE-Tag: 1775217745-683899
X-HE-Meta: U2FsdGVkX1+G8zL281NBYlrnejnXFstig8hc7DTFuBoQGAR96C5FZaPNXhRgzO/CZQFtlqoGrAzq8uqQhRhmqRKGDgq+BXv6IuYoSN8zSGgGEFni2Nd3vDbiddIwNOPLJXgYP3EGTLvqUPtufS3GxefUHs2Y/P+nCn3NRTSrh+NLM41ha3PZrupFl0vcJcNJlUJWgiu517zb9/0ke9cXHuvj0n+574OXWzu3e+/WsftR9OfP7W6HdM70FeN8Nc+kUoCqa4kJmSMky3Xle6G8pJNs82P5nHhP1JqWHQMX+wbRO5Gow01DUcdt7MpAukIn1/XyNNRiReZdhPKN7T6YuCj47wWvIvM4PMtB301on0gramJDLh7ag1qMbHh3cVWlfvwFkA9Sjz5SDPPxkPM7uSEaCT1V3o0P1L8EyzMRjadwH8sqsHgAYdjVaWfruXdWPpEUbqHBycro0rVgfpw0ERryNH+Y8KaIhUbyK6uk8CeTOv7+Fit9O1J54Hvy11Vkk0i8lFFgRQ2QqU9MNXVC3l+baLPz7+6LVqzjTxN3gPb9NUUt5bafMSMK588KLSORgVj+9FemAN+wCrsEc/HBbtxs7XF3qpKGQqk2qioqBF+Zf1yfF4OmuAhcgPCUZiOFurOaaDXxK54eC48f1bbJCpePHzHadrTiMkYrOhOkJ87ORuQmqZifpuBDyI+xAfXKWavgINk4BXoXfFtMYTRSuOqAM7aSXRdocvdB2eyuQVMFLkqcgrXJq6cg8IO+3QdjAECHBI+kLduK+mmCFNWVJDzM1ly1+N2hsa8NU5GeS1KtvlIQNoUzxHUiesPPDe2dAzkXJDs7LrFVhagMIngi1km8oe0b9OhPRoOcaMLikAWR1PizHjEFAyzEHtmA79Xzz0Jn+0HbnGaO/mmgzJsmgnf+f/O86jW1hs+4iqHnpcrZtokLH7kLRF3hTrW+OJfiWxVackd/p2Z3iIGxe8k
 try/n2FO
 IJZcAEWxde5Yrf2g61mgSWUbxKSY+cnq/2I87IlOqBWve0UxYiMcCTQAn1fl3To44+SVhsmD8SkQDKgwPMbptdWPpoWTKUY+CXlLWt7VV0hu8IpnG7y+rDx5OwAl3j6+xc2IAWjSmSth0JIdjjIHAoU4NYcDAsud62We9vxMXRtJ+3UtMfoDg8/Hijfgzh8YIe/MDQaiT/j42B+I36eC3XW7+BwuRC+bPlPPzJvRRoDr+uQjoaLhJeBpJ7+KPsdxi7ch26tTLgbKIxAGD964udh8K1q+nJrqB7DPzlvD8Al63CyIJL+uS9a0M+xrK6qQBtcj1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 03:37:36PM +0800, Hao Li wrote:
> Memory hotplug now keeps N_NORMAL_MEMORY up to date correctly, so make
> can_free_to_pcs() use it.
> 
> As a result, when freeing objects on memoryless nodes, or on nodes that
> have memory but only in ZONE_MOVABLE, the objects can be freed to the
> sheaf instead of going through the slow path.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

> Hi Vlastimil, this patch depends on a prerequisite patch[1] from a few days
> ago. I'm not sure how this should be handled.

> I wonder if Andrew might put them in the same tree.

But it also depends on the patch series
"[PATCH 0/3] slab: support memoryless nodes with sheaves".

So perhaps better send it to Linus after 7.1-rc1?

Thanks!

> [1] https://lore.kernel.org/linux-mm/20260330035941.518186-1-hao.li@linux.dev/

-- 
Cheers,
Harry / Hyeonggon

