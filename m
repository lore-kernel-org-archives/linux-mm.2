Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE62D1A623
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862836B0088; Fri,  9 Jan 2026 08:52:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80CDE6B008A; Fri,  9 Jan 2026 08:52:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F8A6B008C; Fri,  9 Jan 2026 08:52:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5C86B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:52:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26530BB716
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:52:55 +0000 (UTC)
X-FDA: 84312566310.13.605A658
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3FC0E180011
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:52:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qMxuWgOI;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767966773; a=rsa-sha256;
	cv=none;
	b=nVk1K+1yaBVjKtySBylxMbm9mu0pNmz9wEB+LM/cU1Bv00ytCI0zc3whX+AfDLPMG+9Jkf
	Hm9X8oeAcyKoeQhn98fHCTutRkT6oMANsW5I1n+e+GAlDStarRB9L//LMNRnOuCJMRGYks
	/OOspB0fp+RD336g4BcPDeK5FtpFXZk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qMxuWgOI;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767966773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moFShJ9itfhDP+qA/U5SBjPWvjTAJ3KcsA3bkPwBhOA=;
	b=GzKDo589MDnFMhaNIEeTsYE4orcOndCxnznSNYAS30zwfxL+KhfGC0OxnG9ly36/HLQViQ
	8AtZdw5AbRpNi0GRZYPmZ2s+Dy2QFn9iB9h2ccFUNU4B2ltgSPi3lWkRNh8Qioum/Hr8N3
	ieAulD3Z4p+61OcqA0Sp/Tgj0bf3w84=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4201A40539;
	Fri,  9 Jan 2026 13:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9728FC19422;
	Fri,  9 Jan 2026 13:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767966772;
	bh=JH9XjapIZO5yP9HHn9OGfo224MGZj1vCS/GPh0RYrTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qMxuWgOIm2vhTr8qnmo5KZOoSpasRO95DweFjWDgKtnG3xslMCqlfKAUOyT9HL54D
	 rOpg24kSi4XSYcLxjWtRn2siBuaf2lvP3i/Q2SL/80gu9scTh3AZTIqtsq0ZJ0jW/7
	 4SQPdPgWrfBKwR+TdfsqjUlMc66Kx9LsvRrFCWx4/3zWbDR2uESubfbi9ZgtmALkPU
	 Rl+PjUneSW+lQ7MxdMOUfRN92OMuFVsNztAsxsQichjoE60YkPLsa5MfDsX5zAUp1a
	 b+mvl0YAQq3GFPZBfRxRZqKQ2aLuZJvJ2hdyB/1GiXRLkNJHNZNYbCJ1MIIzJ9NiFO
	 MUHMKEolx27gQ==
Message-ID: <d9508cee-26ff-4e22-9ab8-a9b3812a15e2@kernel.org>
Date: Fri, 9 Jan 2026 14:52:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] migrate: Replace RMP_ flags with TTU_ flags
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org
References: <20260109041345.3863089-1-willy@infradead.org>
 <20260109041345.3863089-3-willy@infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260109041345.3863089-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p7r6i4nndpgrk8rzk7feo5otc1uyou7n
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3FC0E180011
X-Rspam-User: 
X-HE-Tag: 1767966773-337689
X-HE-Meta: U2FsdGVkX1/4XmO1VMX/GmjiRufOCejfGbBnLvQwXY4/tQhIonyXvwUYTXIUpn0+e4/sSa9tnM6Jt5aO4p9NAwLhbsvTUqucQKJJ9dYsjbpXFqCsgF5Y4kbQFhugKIj1S6IE28lyRrJvBlV1C99pTqIdwtUewYX4XiqdLNwWiIz7j0vE/byC3R1f0hjhuaDD47m3E6X++DDxkbXYCMCu4z6So/kkwVz0u8rxNl70RKwWtfe1OdpMCoXSWuqN6NnFJtd2yEWQc+cp40qc8h2f6hEYMKn1aLZP/wMQFr1+kugo5bY6erhBRRf3rRdYxxy+JuAr2dPTjP6l6qIYEVfwjMFV/R3QnpJFXEL3VcC6WQ60SDoJuLN9bvyr5Wr74JHYkuy26slwHGV6XdBvtiKTmotEBfO+OAnA56+/UhMymjSgOCJNwliCF1Yp955qrz1DqE4/9qY1bBJY9wwM7bWE9nJPw3+u9WrF/r+KXctGSFXhb1IFiR7GXnFWejAE+Hj8ZiSL4Z8SW7RZX5p0Cd7uZGNrG27nDDk6ioR3+U9lXxbjM5qtoMRZniC0+Oh2hNX1P/aDHt09Ud0Gad228W7KtJpZ3nFWw+i0eDzZgHj0Tap2cko2LBfiEICYHhvBRQoUWehWGNu0BvYyseepEwPWsl3MynjNlxtrIVUVA8eQo5ubxxf1PL3zXWcXhNb4vxuxtvie6vjxdfSoF44DRLX84SxLUyzepsFex/NesiKMGeEO8FH/OVMzzaf9v1G0A4fsuLgPy4fTWj0+o6+Cz7A5JggLpPgBvKVPDuejhZ+4LDVmXIK8WI0+0KzcJopa3cBMgZAQr0UJGgJ3UZnhxJ5iBRr7WYPF9qE9OyWeZ3ER53upymhAT0XIkuaOFoUwt8f1UJCiw+Xbp2DrmVIoRyhj0vKFSI9bb8Egu8rj6aQAOYKKIFxRWrPOrrLSPGKZFMOjJnv64dqQ6t/BgoMr7ic
 MlKusjv+
 +ZYdGuBxHHipQ3prlSWiLAMknmWjBAxh/hLzoi2WRttJhaZrzli9k3FbJFUuqf3dLLU87AV6W1Xq1KNCFIupxvMROZfbb9SC4/v3zF4tkP5qjeqWqLfW3xZ0PXAIhu1LPLeYTgUuUruJ3Y8DG4JMPwPZIPMaV8GfQir/2+/dA63LYmbKKh2DeVxTwX9C/LC7U/bOrumU6Z37AJflOSVm3jg0bnzGfSAOuuV1/Pb5GRGL1tvSUg5vHLf9Btk0aL3gj/Y7m8xdZ48qiQ4XzvuKlJLqIX0al1XvucfqICUS0m8nufmqgcwdqd4ig1zXAjPnacej8AP2Ypx1b+YQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 05:13, Matthew Wilcox (Oracle) wrote:
> Instead of translating between RMP_ and TTU_ flags, remove the RMP_
> flags and just use the TTU_ flag space; there's plenty available.
> 
> Possibly we should rename these to RMAP_ flags, and maybe even pass them
> in through rmap_walk_arg, but that can be done later.

Yes, the TTU prefix is a bit misleading.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

