Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E64C606A69A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a8yjAvyJ
Received: by kanga.kvack.org (Postfix)
	id 41BB96B05BB; Thu, 26 Nov 2026 09:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2FE6B05BC; Thu, 26 Nov 2026 09:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330B76B05BD; Thu, 26 Nov 2026 09:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 135816B05BB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:53:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF683804F6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:53:28 +0000 (UTC)
X-FDA: 85477563696.24.C6C72A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0E8CF2000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:53:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8yjAvyJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795704807;
	b=QJ5OOmpW37FMgr6lcFmBv9fuEngj3xowaVuDV0tseoH3jwvWlJ4PBXERCpc+fasn0dKio7
	RM74oTqJXUsxqXmf+kTgmrTEvrH2SpSI/RnRFn2nwnA0fbkuDKkMMrv3foHkpSh4lg1tDN
	FDvc7n0Bz/I7W1EbVEZ0/tCiex5eXd8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795704807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzyV0xjGyvvJ5LCXTUDu5o5yCWbzYIetg+blgKsF51k=;
	b=wLRpOPvqwvcP7Xumva3RsUL4ukaxzlTuvNcwnj9yLttrXMOGmYa9Y9ns9ZNa9gV5fG/beB
	rsM+zrv5meuGwX/hsuP6iU+EyLuT1z1W6qj4bSBDfVtEQOqJAA8n+5TPpv+jtC7UHX2gkm
	RR0NlDM6n7nB+WSaNZo5f1qF6xuMv5E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8yjAvyJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99784635D6;
	Thu, 26 Nov 2026 14:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777E61F000C4;
	Thu, 26 Nov 2026 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795704806;
	bh=yzyV0xjGyvvJ5LCXTUDu5o5yCWbzYIetg+blgKsF51k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a8yjAvyJ81cYXKQH+R4/qspw0DgExByVl00F6SoJd+otkZI/E3CZ4V390Yc4CLBp8
	 3GT72LYL9Id2gjZtfsdbWCQFuAdE3631OT8joZqMWyuBt4y3ume4z/fmjO1Mp8aGDK
	 kJ2f7fDYwGa0sFGeE0/vVMz9KC+fMJmYbxiv+4Vk2XTc9sdr9g3tXcEsEVzPU6nXzK
	 he5z5i4buVl9Dfbe8eQACENCw/z1MWnO3N/LuuV4HVThSv1UQ2ZkYBUeE/05zS8xSR
	 OCP5jcaYpyE1zMcfF7GwbkqMKXNWFbowUIXeJt6MoJmhiR9/UZn0C/F4ImgECdYKTz
	 R1hdRnL7nDRyQ==
Date: Thu, 26 Nov 2026 14:53:23 +0000
From: Harry Yoo <harry@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/slab: document that local node allocations can
 use sheaves
Message-ID: <awhHvp7HD2BuaTPM@thinkstation>
References: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
 <20261125-sheaf-doc-update-v1-3-4a579abaf0b8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-sheaf-doc-update-v1-3-4a579abaf0b8@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E8CF2000A
X-Stat-Signature: ni619ppoetijhddmjzk99spbkq4z3pxe
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795704806-688799
X-HE-Meta: U2FsdGVkX18Z5jwsTTRwhU7g7xAV13wTWSOylPISXvFl8zKM3LHNYZxHL6R4Q/YuDj3ZO4DoawEdNl+kHe3C33FUnyBejDvn2Vc2pSuzfiDUoQFGbgpVr3ksRjXhNRTGNC/ngNfjjykMmqdA+vLa5ONtjR3ij4Hu4ZJPXhB4Q+PjTeKJgLj58XVC69/LDX5UuQzXPGR970DFTHc3c/AZTYXUko9yZZf/NnJ4NuqZMAOKLxUZx/Kw6q/9cKq5nXYuISvh/Fg4wjxpMJQCwzbQHOnKT0CpyNUr8qKNV0ozUNVmy2UjguNQ5qNWjfy0Sdivbh8MQ1NAdOJpy3nBZtPR0Ou77PhHsWGbBMPeHeIX00De2hOkp0EBryW1YPbctW766VxBdF0euzvmV+KrOz2zERbokLNvg5R3OTUhXVivK1KwIU5Sd/Q8K+HuLokTxlKjY4v/CmP1a2L55ZWlWlrmdQ3Dj2V7lwueklJQRYS7Epfel0FlXnS+Bt69qEst43M4gDvysZgeIH98QlJAPkmbxYHqFfXfhlm4mu7MOd3AG0144NynuHRJmqXAfQGJOz0tFE1msoO2bM8F53GdGYN6EztqTxeaAyimpnJ+PNTSuXhvP7gIXSuxrxF4OelkadPZJIgEnVjS2Wxem6z3ZFe9lllv/t87o3vYSpm2UQ7ibl//dSC6KBzpU2v/gEDgsYuusCgojI+B5cyi1JQ0aXsrBZEjnNe8wszxIhWSFO56Skc5J9koJl3QjLNLmwBq8DatQSZQQmxVZMQrfqIUFrkdSRh7xMYg94A1wneKSVs4V3nVvZykSdogsEuLTRyFTiQ/DKeTffBFfLNdXcLFiIWR4I9/xWlMV1DaTgmpDB4WDWHy8tBceifGOs8fMQok2BiSklExb5t5va+rYiz+4EZ0+BaMWcrPcCrUBY8gG2xXY5eY+C+2p85MpYxWKlA8ceOyTXv8GrH01OdegVqpGas
 WWaUbOyP
 H37nVvNQY0oah8cmuhVaOHMpS4dngQBCED808Y+XDHcNmGMVseriZ7iu0BKOemqLwfrL/hHctHr40h8/r8rdwPlTHBbkxQ9a2ut9oGVt4y+VULIFZ0cQOBuFMOlOkuGyottzLC84w4vwX0QyBjhpc/faFJWjnFs1hnXuXFL1UsoPnpNPei7eXRkZvwgPXFCUKjuo3Tkys9zg8aslUGZmytBSvRevD7zTWpVn2nb/9fQWI9el/IdZhtLUlFZSxfzzrQycXQjOmaAl1JmYJ0YbGFbTcVkuwltosnP5DiijZvth5Ygbo+80RwDq3QGS/twqgHjRtgtS54YccDWO3Mm9Fry7wwJ6Q0+Z8tDRR+T2yU1KerpvF4YzpXCPzMoRRdYfzBIAV0WkgebzsYFbP82dhnvYxJz+osS4jr1SUok0ySN0G/VwMBp1hzSx3u/uuNbl1IKZnBKa1pTZ3IOvYG7qKVf2NyezUZ+X9nm+vvYE/LZe+m3YQiZvw9gRcbxL6pPq3xVRIghrJlL5k9mQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 08:35:14PM +0100, Andreas Hindborg wrote:
> The documentation of the sheaf_capacity member of struct kmem_cache_args
> states that allocations via kmem_cache_alloc_node() with a node specified
> other than NUMA_NO_NODE bypass the sheaves.
> 
> This has not been the case since commit 4ec1a08d2031 ("slab: allow NUMA
> restricted allocations to use percpu sheaves"). alloc_from_pcs() only
> bypasses the sheaves when the requested node is not the local node. A
> request for the local node is served from the sheaves if the object found
> there is from that node.
> 
> Update the documentation to match.
> 
> Fixes: 4ec1a08d2031 ("slab: allow NUMA restricted allocations to use percpu sheaves")
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

