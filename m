Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8263606A335
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H56/iq94
Received: by kanga.kvack.org (Postfix)
	id C775E6B05B1; Wed, 18 Nov 2026 10:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28A66B05BA; Wed, 18 Nov 2026 10:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B657E6B05BB; Wed, 18 Nov 2026 10:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5BF6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:06:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28B58807C5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:06:55 +0000 (UTC)
X-FDA: 85448567190.12.B5EC886
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 70BD01C0017
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:06:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H56/iq94";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795014413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICrunj3Ngc2NClItFMUlkn+/M4je8+5gRXnfuJMD5Hw=;
	b=Oi80W/9wK6JcsmmC20oanmb/xaRAb5U1NPRXMnukX3Ya6n/U1hT13OhzZNp2Gs4DvD3/nF
	uJ17fQk7PGPPQPjMa8ux9yhnGEjo4fqQoPs0G3LdfUmhmb0uwVxkWt20szN5NNlhLbdrNB
	Tn1HSRJdGEUVGEcwncyvQCKOvlRyjEo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H56/iq94";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795014413;
	b=WzEsizPBl/7pBgiBomOzu8KGwNOvP0W8o5isgd0BI/QRuPvv6PblDZetq+zt5Mt4far/Vb
	Bhs17wMNqQXBOQeuzHeWLIwuxieCfZ9oSyalK4g/sLJLX2j+yT6/YDw5Vo0xqTl6EfMri0
	NhMlWMk6RV4xi0rgL+6YECLjm4yV8W0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 964DE413F9;
	Wed, 18 Nov 2026 15:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9551F000C4;
	Wed, 18 Nov 2026 15:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795014412;
	bh=ICrunj3Ngc2NClItFMUlkn+/M4je8+5gRXnfuJMD5Hw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=H56/iq94EwN5PNZbdnTaCXk3B5rwPOty6YgQj0FciySMfq8YkxJhwSLziGyg6NkpK
	 qGelqxCSG08605O4QiwgXJ3Y+lwH/aN+cXPK9UHLyNz9dXv0hJREkGnIuC+wvweUTg
	 qLtuNZhAuyO1np5G9wY+VOc2o3eQqmBCFEIGTqw1pRUTFUkHtwZj4ODh9MfB1wTTds
	 1YELUOBvvmGQ9+ZntGyAKt+sKx60MI/RMgG7NCmUVspkAuXgnk5FW3fVsbBEocAzwS
	 sKBU9p0LbH9sXaDQy4zwU/cEcmVut/DNbtd31NdUfTvAfUX0C6FCunAUt5kgqnqyPd
	 amephCbCc8xQg==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, 
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
In-Reply-To: <20261002160535.661399-1-ekffu200098@gmail.com>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
Subject: Re: [PATCH v2 0/3] mm/memory: remove unused
 vmf_insert_mixed_mkwrite()
Message-Id: <179501440852.7660.18348444744304711431.b4-ty@b4>
Date: Wed, 18 Nov 2026 16:06:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: x6qub1qca315mnha7umadu31imkh9n96
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 70BD01C0017
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795014413-324777
X-HE-Meta: U2FsdGVkX1/zAh4xR6BE8A4FvMXAhFQzCWYe55Wclz2HtNw5M6oWCf2sQIzGMtztIO5v2pUlSyjZu0P/O6EpMrP6Lk3eb2k19PTDQbfayVUhTmExYfppG/ZPWSWqN/LPoV7P+ku1f/XxpHWbiheHu+UpNMQuMr9vRIO6jdY5Or2WSeV0/V8AGPrtGuEUHepYfoyEEh6mgb/XSty4YIaqdPD3tvLL1YHhe6OnBVqmbL7P6//ikyGHVslK/HXvqNLWSq7ghd5MyxDt+ukjiKvEqLwHf8Ak4NrFV4o+bYKIqXJmm9cUivoF0r+HLgdIx5OgTyttfDFbUGpgpgHp0c/VKGLVXcdTlFYJ/S9090FGn97FI1ssJcHzTCTYT7Eh6urSlTlRKLwiWcuAEnheO6daZoE4n8COOKw9gcgkGABwan+MZRgu3Uswpfcj0A0c9y9xPccLfYz/5C8Z0K8TsMYNZdkuw72hi7qqy2p9mU+t28sozNZa5VMdLoecU6CrlHEfZ050RwYuPp5fyhd43EIw+PjQj60nwl21MPComT5qESbSU+JhBx+rZt6iZU2SiMFrEL+2Mu/t9VI2wffE5gZ2waMjZM/Z/6rDctLJdOo54v8fqsleTAYxtgX532G3P9ErWx2HVaVTRPHnTxLOS5DFdTflF0/roR9o43OwzJPrTQDM+TXxg6+W2qN8Qjf3fBRTIulxbbXjOxzC/2+6LnUtgs+0NFo6MeYoNGGc9qMJpLY15+TBiQt6JYzXM8QRa8wScLcVyYiZyj1vhV2UbFQ3Df6r1uPD5xGQiw44qg0V6h4GQLUj6A7iKsDG89ucKgtfxF9jIUZW+0zWt2JvInptyD5EPlRHfct3wV4UYsWb56a29jHMdRWZmNJsGGmXBV6AMzXcIqXMXCAhbFZqwrVeZ2SiXiZZQFLoMG6xooCU8luToQLGVqZGiDltyoot+6zM6drQCBAPIHj31hzxxVg
 pW2nZrRE
 VC1WYhQ1cmFc+2FLwnsZTuTTtK7/6RhyyKzw83xWyHX2rHSHv3+VfTp8XujAJ77D0B544WhM/PGkX1ui2KGZw3ZGfMfZJL/zAWeRyFmfPE5rZMwq/aSlPiugPJo0qOgiuwjiTwPYmK9VNqViJVSr5AwG7FuoHJEcI5vGYjgcj0JpcuXi+7ku0cjDLJ079WZx7FYezJzmfxrScfyPXPWKuvbW6aGedoHWPTwXQcOEOcRghcrcOGIoRS2PH30dDRVBH0zeaLTrrAZivRhlG5dYf+f9dDuKw9gFFTBVg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 03 Oct 2026 01:05:31 +0900, Sang-Heon Jeon wrote:
> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers. This series removes it and
> the mkwrite handling that only it used.
> 
> Patch 1 removes the function.
> 
> Patch 2 removes the mkwrite argument, which is then always false. It
> also removes the unreachable code in insert_pfn().
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/3] mm/memory: remove unused vmf_insert_mixed_mkwrite()
      https://git.kernel.org/mm/core/c/fedea7ae
[2/3] mm/memory: remove the mkwrite argument from __vm_insert_mixed()
      https://git.kernel.org/mm/core/c/a3405fa5
[3/3] mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()
      https://git.kernel.org/mm/core/c/ac2fd084

-- 
Cheers,

David


