Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691F4C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3C76B00A6; Wed,  1 Jul 2026 04:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B6A6B00A8; Wed,  1 Jul 2026 04:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B026B00A9; Wed,  1 Jul 2026 04:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 168046B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:30:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7FA92402A3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:30:36 +0000 (UTC)
X-FDA: 84939536472.21.FF27247
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 970DB80004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:30:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dorABrzt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782894634;
	b=TfYQLlUjFDUqLz84w0bkHfMHpmN3p4f3EN+m4Udr2Yfp59Fc2h/zQwlpy14sW+S56ZtiQ5
	lflF0U9CCNLIYuhKVUqjmte0S65/6oYl9dTzpA9NHx8CG9Q3csEMruaQKYKsa+5wWcPqTW
	fYj4a2CPUtTlLxdYm4SfKOCyz3rL8GA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782894634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVgvcCDMMPbid8Blsv/a2rnfaz/98kjFxJTQJx7CeGE=;
	b=TJ+J1oY3FYgQTfClxcddVGFJXT+EvTKdhQBtBpmJ1fpxBjFy585ZyxYvpOMOSGqOx7LtBH
	D4nvCUgokuZ2eeL6MLb3xGx7I1dPAwwz9n0dfFRmfLmIdNRq7UaiX/fkDj/zpGuJaqYgKC
	baAo6GImQYb4dMXjYWl5lgyishgu48w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dorABrzt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BBA2541407;
	Wed,  1 Jul 2026 08:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30651F000E9;
	Wed,  1 Jul 2026 08:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782894633;
	bh=lVgvcCDMMPbid8Blsv/a2rnfaz/98kjFxJTQJx7CeGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dorABrztRNSthAwQYoK/PLhlaW0BFqRCgzkL8AL86nRPys35uwyzT8qoP9uRzrtX+
	 OLLqUjarhIV1U82lkgjA6+lZwa4hPNrRW8VvY2V/NZ9cwqCuXdRRClkng9KWSdY4XS
	 0bMgfRxEew0j/XqATMnNh9NrTLY6VJvIVMgAVSipyxrQhnPwpslEbQ6lkdHJsIkx1f
	 fQODn4hfUMYAJzaTcDsDQMSnt8lTiOxi2ohh8WIeOzD2NvUZAPmw2J6oYTVemex3xk
	 87EyLMuc1gfH/h6V1Jyh/4Jq7NWsdP2RiiwVp6lPTcUM/nzZUyk/yxODBMSwbKefyd
	 nhtsx0yNohfaw==
Message-ID: <daaaef83-3536-4e2a-8246-d7c52807a1ae@kernel.org>
Date: Wed, 1 Jul 2026 10:30:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/16] mm: replace __GFP_NO_CODETAG with
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
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 970DB80004
X-Rspam-User: 
X-Stat-Signature: dousr54qc7egf3h53p1beg3ehiwusmn8
X-HE-Tag: 1782894634-293063
X-HE-Meta: U2FsdGVkX18wfTtZjkSFLK5l4a+Me0/svVLJjCevatdHwrWAGiaonBBlQNNGe9k8hWjkeMGL4mthAGVfpn0VbRU9KQngfWhXtt6HdZ2zJZeL4Bwma0bI6JpeCwJi+HBE4NL4ZcYJlsmYCeNP2UNDWGrPr7UZlZ1AKKSxMkIDD2EoTRjDxpGE+jefim/O2nfLguofpBGzcsnPdP4/7WsUtHku8qIlOJhUi9RzmMylocAuGD43BX2DAT7fbMsaSAg//kD//GQ3rQDzH59cpZF9XcMW4cRf2FctSDFVJXIjir/FhmDftYqQSInwfeo7pzofQ+/5mfP/luXY3WzzEsoejE+VlF3F8MQzdCz/OP5XZCO+zNium9gmy7zXN+vLkRikKBchxCR735xmZCftVj9ZKAkHQJ8yv9X03sPM1lgWFVjj3NMVDL7FwLcvdI+o4MyMpxEQwltuVkIdl4C7vRS/wYjgLolvhoctrlyrxz3BY9l6KvywfbSvxS2wzWFsQVeoMDEjpz//n4740UBFInhpvV3YlmxQQs5CicsVyireovWrfshMZjT7V7TFUEYY1Y1u2VWdqKQ0JRAt7zggaS8ecHADUIY9Hh5a1hq8B3YilJs1a7dTykjgdIE27dX6Tj08otEuGkeQZQ+1G2HryIjXbyLFZizqsRBWAVs8EDhje2jgzQbd513Z8omM2lUASRN9i9B9r2tg4Ks2D0IbjDTXhgYN2t8FK4RzdMbdhAkjfwMhY3DTzEhZsZwPloocrvO4+SLUTSA2m0w5jkMT90fPsLMilbD6c0OmEFXF41Y/8waQCMRa829vazyYyCSw7l66FaojHv3MwyqeSjSdIcC5PmrZmpjmGePqVye4XD4I0f919ORnlfQTr/2lBLGBL+uYzIbYBnDSbPG/Q/xq5+PDBwGfTtlvwBTWWioWBwWYT/nH8lxEim5dvL7tdtyu77T1F84jyAYXvVdDVCQVPu0
 8mkahhqK
 sjnet1UxV6QSft+93AeIJxxFzC4MbvwLjsULCdInbX6Di65hM4/5hYB2mjeFKDpwfPuaW+n8YTClNx51QD5zU0ZnqUNleLIXeNaUH7KVStpkxjdYB/2WZf8L+k4VwBPatMHkSNx4wiqpz7i/QF21uLrnZMpuYFL77HxgqqkSQZDd+onJWdHJmc+DufvapIMKV/3RQkZ7mZIu/i7lT82U8WSytLB5HWKkN2QVjk4CjM9RXhF/aLN2pTg3UY+fNLZqiyBjF5UrjMkRZzDPIuobhH4yiz/9Z5yPvs1T9QUEzW95TyVLl9DJFBj7Y2EaLyP4DUV1tu5f2m457S4G0qcJH2bbHBWeArkoGCOkjOkxgiiRw3R7a6+xoTsRsZKaSiu26wB/RDMmEJelUWYHbiPQEnv83Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:12, Brendan Jackman wrote:
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
> No functional change intended.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

broadly LGTM, will wait for the updated version due to Hao Ge's feedback.


