Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981ACC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4CC6B0096; Tue, 15 Sep 2026 05:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186556B0098; Tue, 15 Sep 2026 05:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F8D6B0099; Tue, 15 Sep 2026 05:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D06096B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:04:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 446AE8035E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:04:43 +0000 (UTC)
X-FDA: 85215411246.24.105FE4D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9257320002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:04:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=lRl6heYd;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789463081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xj97Gm+bFVDZhjwESgxXGsr/TcYPbbFLUTQH8EasuOs=;
	b=yh8YfgqrthcYsZHf8mPYbLhllvQ1ImRikDA0nm5pNOL1+44xXVGD7b2K9zwPrbwRBg+mvy
	MO4h+axBtfztF7ZtM3Y+iyRz4zivr4yldfPCWo1W/dfDpHV6zrk7fDZrKpsC6fA3srp2Up
	6NiBqjNbB66DxrkBkZswhUy8bXmTVBM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=lRl6heYd;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789463081;
	b=1SrZLZr0au2dZo7pf37p9+DMukc/APmNfKtxUznxB18qIelIoxEYWIrtA/1pN/j6C1AaEo
	c173v0i8RQTnQPqJ5+4fH9tMAiNpSpvDSTMCXtpPEPseTvsJOFnxD4a2SKBo+6DCSCmXNp
	DcUjB86bywlkfhnf94r3efUOTbgIpVY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xj97Gm+bFVDZhjwESgxXGsr/TcYPbbFLUTQH8EasuOs=; b=lRl6heYdFmWobjqmP6MVFkL3cc
	hrfWmOjJy7y8JC4vaFY0trfhscwmnfFCx1TYA24UxzrPt41+U6Va+vFZDeo0p8FcrkDmBpzjqVsgk
	JPSe9jy/AB4dPNiYIpvuvQxdT30cSTNu7IIhDxsViLxrY5mk/yPbs+ARWqEFH2WX3MI9gNbnBwrqb
	ytBsRGkqSb7XmPuwpl/2f6Mr7KW5Uo2R/ImOZsT+mPaFhkFGTH2UfO/Dd+a9OIIJ30Hcc4lFqiRhc
	vl/N2nSH9zs66d5eQQM/R4y4PtD/9V0nDRpXZEkq7o/gZMcDF6vJOmqeMv6iu2rs80VEGFFXzMAsF
	oKG4ogTQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6P51-004HQC-0I;
	Tue, 15 Sep 2026 09:03:55 +0000
Date: Tue, 15 Sep 2026 02:03:48 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqkIdVhoG2wwVBtb@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqKhgPKzRf0e22s3@gmail.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: hn59iexq5zyma4yey8fdfdkn6xdizxd9
X-Rspamd-Queue-Id: 9257320002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789463081-780472
X-HE-Meta: U2FsdGVkX1/lNOs5OINwHdgrPCeXW/iO3n6W1HijbyDkMsn/andCh0A8hHz0kSlfyzS3VEaf+/XNv+gTrVEeLgguHsI5JhtVyVROLJR0AJrIQcgR3w0br6biDPNSyYaYAfkszhGUTiXeRSZ/IbOaehCOqfFbCf8rZ50GXpjeaEtHN7iJsTZTNecg68mSKWnDJVqpBAlLI6CW+g5QybaQtgb83vj9icJF2Rc5N0uvURqWRGJxqY3s0Vr4R7+0Ex29cbb00cPppyYgOjbHNN4sKdKk2UkHvUbmDGpcUzJLv+JvyywkZ5t4TBBumyFK4XJUAZr0kENMzhznsRR70GZvb/fF9xTs4w9zlUMuwnxeY7eHdQu8SPWSHR3IbzxO4V61TJHMtDs0bzLfwkjC1vLpy187n5uFM+n+PvMxulWeRQaVUUyCpenTImzgRZZcwva74i5Nx8JT92LzkS7OBVnfEFKOSpwJ++kY1sHenRzVLrd0rl+i/pBtxhyqVRys8uX2dJ/C3rCegzaGv/IfFlNoZ64Oh6Txqu1nmZE6AqB7+AD/4tNLp+3bHEwwThwuR2xc0PqGTwQEF9FywdGJV5+Ydkr4fUAhe5YL/s1iqRqzGNRhe6cgPB8W0yNRO0AQnGK9dztkL/JvgZl3h3ggLGVYACev4/jpYbTPPD9u98PPtEgjLCBBQiQrbMxde9MDdwhzH4rT/93//k5WZbXouLPuRzIfOnBgSbZ5N4I9fvd4BfmbxMdPGL4JrUbfTr/iqqhd1Tk7kp+p15D3YSftxujHqlENnN4O7oPmPtQyyy2AnzUfS2YzdFKDvFigPV9YvaPylTn1933csBgaJTEnpLYQJBwn5UlHpFZdarJElbyNrDi2O0XEthTuvedOhx+XRlQhx0ICQRnB+UHH3p9Uo0b4H5fgL/nmqFYGXcD5awt6+Q7o6E0z971miStJB0QY4V0/kam3xO6UBNrQ9gqAkI8
 Ru7j95+J
 zmNQFH/72Ggdae+Jo9im4oT3IDprlUUDhEuB7POLrXKTtBV6CLYxgB5Md6+r9gQLnt5umhAfuefRj6G9nu9f/OZDpb8rqvQ6TDGAiueIJnmdGUNkSl7RLRFVOFM6itp/lXnqlT9va+2P33UvXq7VeULlU9QDowxVyAg6IbSmnkfmvEtBk1PX9HGLiPu514zNtd6ImywU2sxB7rHX3/JHRUpLGLfMRVXqJXCzlWtBeBKlfdBaL4U1Pje6nyUxj1cQ4vFNAgqlbltR7GIxj7rCAAIWv52gfIU37/9hO+BBZAMWKrcS9d0AJTLkhg78wc1FlrtjRXdz9YvCVmA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 06:11:53AM -0700, Breno Leitao wrote:
> So I'd say we have two options:
>
> 1) Keep it similar to unaccepted memory, with 2M granularity.
>    - Pro : Similar mental model as unnacepted memory
>    - Cons: 2 MB might be a bit wasteful
>
> 2) Move to a linked list like the RFC, keeping it outside of the EFI
>    table.
>    - Pro: Reduce the memory granularities to page instead of 2M blocs.
>    - Cons: Another way of passing memory information between kexec
>      kernels.
>
> Any any other option or strong preference?

Since nobody voiced a strong preference, I will stick with option (1),
the bitmap, for these reasons:

1) It follows the same mental model as unaccepted memory, which people
   are already familiar with.

2) It is simpler to query at boot time, especially as the number of
   poisoned memory regions grows. Walking a bitmap is easier than
   walking a linked list when freeing memory back to the buddy
   allocator.

--breno

