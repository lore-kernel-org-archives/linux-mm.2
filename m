Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F38C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA5D6B00B4; Fri,  3 Jul 2026 05:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73FE6B00B5; Fri,  3 Jul 2026 05:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914056B00B6; Fri,  3 Jul 2026 05:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4A76B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:25:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63E991C79DC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:25:11 +0000 (UTC)
X-FDA: 84946931622.11.832A292
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AEE3540006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:25:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCH8nDd2;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783070709;
	b=8I+fMcp6sO3PAA4PH1Sv8kWYBezxw2kAQP5TITtPbjfqklKUNjHPVOKcObqWUopYE7x3zL
	X23mFwELzKC6LS9CK9GGcIimduIznvUgMEdCrbpvH9Qtv8fppMToCh++3F3tzlEyS0Nv3d
	kXDUrDhyOsx903/tStPywSb3UPxuSIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783070709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCuwDlwY7oRReL1bXNqw+6ZO3vg1FwmghbNEepjgOEk=;
	b=4nL+zWMFm1ex74gzwItD0Oh0B15jIjQoyL6wJkG3zH1fpE0HC1DEmglHP5NMOXt+21uL9N
	71dNB5RMZbVkLrpIlCPiPiwEAyhl/EjOcrQ1OhEFVF4BG+4yVdlnlvqjIx38Ows8DIe1EZ
	aY7wPz+1Puu6zFxaCbhFL4j/S61KEgY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCH8nDd2;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 446AB60051;
	Fri,  3 Jul 2026 09:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8281F000E9;
	Fri,  3 Jul 2026 09:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783070709;
	bh=DCuwDlwY7oRReL1bXNqw+6ZO3vg1FwmghbNEepjgOEk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OCH8nDd2tnmMmI1cH5nPnDDX14IPIpnaFdVLzFaxKToQQ6XIz+mSxC2b+WtY2DRVw
	 KmwNWaDP/2smgDCAA8uXdyfPGhfcf1u7WC/cNw5r7Ql2gFMo7jvmFC8WO+Aejqsho5
	 CM8QSrPfYmJ9JTpd4hmv4L/8Pm+us7fIaCBOC8gP5k6rlyih8HkK/v1syXl4dpy07f
	 1dc1V2EPsKP9iq6b2Ma4Wq3fABGeIfnz4AX+/X0vuNg7xWtF9QJDIhyAeYmquHw8Nv
	 0UGXWwnnD+bdgeREdZoyczkiUsFJkBp3yszLUlUcdmx6X77uKBrHALnKPvH5NwtJ/h
	 oXKu31sZweSyA==
Message-ID: <49667ba9-a1f7-4857-aaf1-826a737c3d2c@kernel.org>
Date: Fri, 3 Jul 2026 11:24:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/18] mm: replace __GFP_NO_CODETAG with
 ALLOC_NO_CODETAG
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>
References: <20260702-alloc-trylock-v4-0-0af8ff387e80@google.com>
 <20260702-alloc-trylock-v4-15-0af8ff387e80@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260702-alloc-trylock-v4-15-0af8ff387e80@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qzbpxn7wik3rw6hu7ynzf17w8jk6dt7r
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AEE3540006
X-HE-Tag: 1783070709-296967
X-HE-Meta: U2FsdGVkX18Ir8GHg09nELM4JBLH5r5VFrATd5qR1X328TAhKYFpOm9vrybG7GK81ynSbEh18624SYhvO/IRSI1FUbN6aQwaQ0XIa+1/2a9bZYBcCzWX6xYki/Vpc8Is2OLsRfoNff8H5s8Zc5nFlR6suznL6eMNHllstQLpIxuL4AiK43ZmWiOk9nKFjDjYctxBoRvO7unRiqiSpsdeFE1VVWhZJzHc/G7ShliwVMJdtsSFJMxuFM4NkVxLmXTQNEwmlOEy+dYhzkHHfTvi1zaxXmWiwzC3l0gfzm/Ftmkkd4MbZGtjY5H6V4LHo5bd5Rkq5canZMtQ0VEaZsUyfPHCLeGv2KtJC/OmsxDUksL39u9DDE+5fha5lIxasmDeE6a9jVJrbZ5UP5Lvks19CxY0FkDHf1kCuvU/0RY3Kcz2U//WbuPBsSmfP+tmvdS6fwoS2cRlLTc34/aFBuPPNHlnww7EKI8+48MXyrNx+0Xk/4bKXx18fO/5pd1+21dnjTnBCDPH86E/xV9KwEmH85gr4bcU4r5jn75+it2WCUgfbn4QdOAe2srBrBGobw50lVZ9HyghubCUbpN/ozCJl2J1yuIxBrAydi/stTYAK/lSPQLtqOviQvjW1hJw5OzVwHI337Y3TG5KLVW1l5fakHijojM92cfEVor+fkIGENTP8Ib0lDoOzlPMTtxhhkL4TaY0UL9rZC1yn37kfc/GkDh20KucbiwrGi/Qz0DGLdxfaFV2QddCUO3rJBghJu4NLI6p768zgQFux1w350SNH9l0C55m3DJZixdU7j3DX8hgLp+imhvrrFHrcZ88ryLNOmzQBZZ8gzn8Q+lqcE2Ko/+uDdcMGCFTU4A7lt6ITaKubooyMpoEPKoYIGdjTq4fuoU7xhAp96Xr8sjNuku6g4liQc5QBGVrqlWVwVcPA01eaye3fdNSQdlrEuMNEIXFEvBuc2cLHGTZSNKujo4
 fFmY+mTE
 0sNFo7V6C8ixsCSqH8nBOkNfLrNFk/2aZAzypfIa+tpiLyt5gy2XrPJuVuyBd05Z+4YXOQq+89zP8KDZYsgVLkAOXkBjAA6as/Iap1/U0KorEHw+6BFugUt/uhNqRY9voV5sjnEhDHYUWCwBDtEfpYAKTbF6O51z5murZDzI0puIpRKj7dpk9dNZI9bO/rGuspSN/RyJqOviIRUhMMJnUyH8bKMGiCd+oXjRTz3LWA2zkX+11cW5VFdtS04oqxdxD5B4sQ2UG3AQhNHX0815HJV2N9GLfFKm3KB8KVAcQJ7gs6JCeoyMy1tR/2VnAHu8GGD8by5hb9BDQ8lXuLf7O11Cnbj/ydosn8RMPgc8IadvrFZFISXdd4/mQjYclJnXZLHINzSMP1xaw3yoPFhih0wM83BXAIOeWUHuQnBp+2+HRA6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 11:49, Brendan Jackman wrote:
> Now that alloc_pages has an entrypoint that allows passing alloc_flags,
> we can take advantage of this to start removing GFP flags that are only
> used for mm-internal stuff.
> 
> This requires also plumbing the alloc_flags into some more of the
> allocator code, in particular __alloc_pages[_noprof]() gets an
> alloc_flags arg to go along with its callees, and we now need to pass
> those flags deeper into the allocator so they can reach the alloc_tag
> code.
> 
> While moving the flag definition into page_alloc.h, also update the
> comment per Hao's suggestion.
> 
> No functional change intended.
> 
> Link: https://lore.kernel.org/all/b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


