Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83B1606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SsQSQlHy
Received: by kanga.kvack.org (Postfix)
	id C393A6B05BE; Tue, 10 Nov 2026 10:39:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9666B05C4; Tue, 10 Nov 2026 10:39:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B007B6B05C7; Tue, 10 Nov 2026 10:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEBC6B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:39:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2AF08407B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:39:49 +0000 (UTC)
X-FDA: 85419619698.26.578F87E
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0669940007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:39:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SsQSQlHy;
	spf=pass (imf12.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794325187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Dc+JwsdmgyYxqvZQmyNcFdizNnWnNQRrjUAX8hzcoU=;
	b=yQF4Q7HZlNVqJ5Usx4QV0O+yTn20zv0ETPUmLP3Njq3U9qi6KK2QV3CmVP3XfHQ00lC7J7
	Gba0xOMpHqK0hZrdIUHE2zuMDbJ+1vHjNtCMMTSEcTYhrwdxfqrCl9AHehM2HLRH937Kr3
	7JznRJTNnJ0NL/Kfh/GoZRIX0JNW78E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794325187;
	b=uVGS1ZMwLAdF9+oA5AB5GXHiAy69/b7OpeOhTY7H9OdID4HEHVO9c/SeEkgr1mWhG6nEpk
	+/DWmeSvwr/znBwyE4FqTeYxcl2oBZundkOQtnFpYFzbHGTS3irZVeDgCSC3g8FJtklWfV
	kJV5xgGDSXFupTozoXhBob3RCHfsXMI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SsQSQlHy;
	spf=pass (imf12.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=U8k35pxEd0m+x8ZKDuQMkZMM3+/gIzGlGIc3CscMOqM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794325185; v=1; x=1794929985;
 b=SsQSQlHyp7V5Z0CCbhyiGrxvJPcWe9+dkoM1G2BZx1xIyZDJVnejZeMb1MALH+7xItNzDytf
 u6MYKWta7tzzj39/69e7aCn1s1eozEAGLBrWMUMof7KcaaGsU2MKtoOWyxFwM3nG5Xw1DiOl67M
 zyLFvGH+f39e5KhEBw8n8fu8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0bcc4bd1f1aaf32a;
	Tue, 10 Nov 2026 15:39:45 +0000
X-Mizu-Trace-ID: 0bcc4bd1f1aaf32a
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/compaction: stop repeating failed async compaction on every THP fault
Date: Tue, 10 Nov 2026 10:39:28 -0500
Message-ID: <20261110153928.4039653-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <0a850ec1-d45d-463e-829a-e782290ef864@kernel.org>
References: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com> <20261110135824.3264904-1-qiliang.yuan@linux.dev> <0a850ec1-d45d-463e-829a-e782290ef864@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p6zpdffhaiwgkyy7fjib8qdhdi1mt9bk
X-Rspamd-Queue-Id: 0669940007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794325186-717082
X-HE-Meta: U2FsdGVkX1+HIoZx8lKyoXKQYBVBj9hUEiybLPt+Dc2proZkxh+a1/6M2oXU9Y9P+yGSbUVpOXHUE2mJBBTEB1jx1cjztidr6GHPWpk1aNPGaAJlssaEwbs/Lhx0cOvU5nDPuqLVO7nVGZAvCd5OteTpOY24ZCnDGsU4dXuVeL3jsJMhn4fVwr8f6lXatnYOV03cpgG6NrL4Td5FsPhY5s9gTpM3Xcsck3CuZH+U3vb8oCCEK8qU8+7Q5bixPc4wRCMF3O3qSNqVlfrBlf/zzUB2zmAisvDUAKSrpjUcye+0ITZcfnqyHAz9F+hffJSpB+0hddfEI8PuH0DeknB3cPL0Lck/ZZm3jX5qU/GI8n8OXwUA88TBNptAJJ8s2E63huuv0Onh+8jHgPTcbVdanMnOkfqNHDnjk4NBBJvTwc0lXSeTyr7chQjitcSCARiykvDNuv8LC42x1+7+5w88PujlQlQr3M/UeUUAAXkQleZ5kkcq/6d+KxEwo4rrL5sXeTrhCubMMi28TUOz77r/4+MLnWNQFyNFJm9cT6J05W/c0UlgF1PQi0xZaPOxKeC8BgpXmj9IiHH8fi/0n4QMrF3084FcuPX1Mam6RDEkAaFN7LZTftbUR4lQpUaCX+cQkZoygvb80J6vwW4TxSfxae3ipDTPTUsPiKosuuXgoZoF1/4KLPdgH16d/2iQ6EpkBlc4VOwQKxWx7MGd2TrHgvg3TfbSPKKYlRufc94OqygELY8Qfiqtubgx6cAoiXxpc/ou4P6FeExbw3sATexUWr6eWZbzk10xjDtmDDBu3YqM/0C3q2gohpt6MWEgfIcgeIQaBtcuuSfb3zUYNJJHi/szbaBO876esxpJ86tyIRLvB0mIQGWlDxAykyyniJWuuUY6+NyoiqF1JQFsR+3aVOQLMhwxN9aABcXLpdztcbzATZe5Wm4YLR8EAcVF0VDLVdbqYQlLf4zK82Cs2B2
 KHnfB2gW
 4eAGX+3UsARvovkkFhJSpE82XopHNcfOGCP3cERr7LAaUV0jAcg3/Ju4oaPUZUu1Xlp4VAHNnd4+/DkTPMnD+Q113kJvi9amuDjEOovThjZcLfKwnrKy32uXqRVkLgNtBjuuhrhso7/ARaxC2waOrV2nFN0GJQ/HNfIw8RoB3x4u9cECOq4wAlRiQ3AkVkAEKWrX9/RXTxavtMF7ihdevN49wGMY6IfE/nWFr5bMLgSm++ZmFEx2ahXJmQMnxNvS7dCPJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 15:13, Vlastimil Babka wrote:
> The series was nacked twice by senior maintainers. Due to dealing with
> urgent issues [1] we might perhaps find time later to see if it reports a
> real issue, and in that case fix it ourselves. We have currently no time to
> help those who need AI assistance to contribute instead of having own knowledge.
>
> [1]
> https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/

I'm only spending time on this because it gets in the way of AI
training and inference, which long-term pin large buffers for RDMA.
Mooncake, the KV cache store used with vLLM and SGLang, hit it with
8 ranks x 190GB taking ~38 minutes to register. The stall and the
numbers are real, also measured on my own test setup.

Async failures have not been deferred since commit 66199712e9ee ("mm:
page allocator: do not call direct reclaim for THP allocations while
compaction is deferred"), which explained:

	/*
	 * As async compaction considers a subset of pageblocks, only
	 * defer if the failure was a sync compaction failure.
	 */

That still holds, so the series has no Fixes tag: it isn't a bug in
that commit. What the rule doesn't cover is long-term pinned memory,
much less common in 2012, where async fails the same way on every
fault and is never deferred. The series leaves sync deferral as it is
and gives async a state of its own. The analysis and a reproducer are
in [2].

If you look at it later, I'm happy to test whatever you come up with.

[2] https://lore.kernel.org/r/20261110144256.3841504-1-qiliang.yuan@linux.dev

Thanks,
Qiliang

