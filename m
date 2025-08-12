Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A0ECA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 18:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490258E0189; Tue, 12 Aug 2025 14:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D108E0151; Tue, 12 Aug 2025 14:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABDB8E0189; Tue, 12 Aug 2025 14:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26CAD8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:40:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C283B135914
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:40:32 +0000 (UTC)
X-FDA: 83768971104.08.05A4BAA
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf04.hostedemail.com (Postfix) with ESMTP id 17AD740009
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:40:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hkV3t6Gb;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755024031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgTethehP0Ak8EThua2+m4R8UxEEcbJRm2Ito+M/nv8=;
	b=FJghtaRDPdwVGFliRTpT/nJui1vwvCkak0vzdi92NewgVKjOxif7YlX7YHV3Ke+xx3atrn
	4t6JMOFKXS9PpSqTkg4a8ZLMYebqv1Ibedd0JX0S2fBvw7hWlBJytUkBz2qyTAtCje7GKV
	zAPYN+IL6emj7m0oNhO8pV5/qUufNiA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hkV3t6Gb;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755024031; a=rsa-sha256;
	cv=none;
	b=R23wtKQpPtGuQYsF21N8XcD3QxWLMZxH+v0Yg73lPRMZciTctyWvPzkUpWh1d2CQHN/gz7
	OmzD6TpdZjo4bzZCmVtcM6XMiwD+OBQ2N//YGDXqnpUrcIA3MUhM3gpt/awrGyo3N7+Qt+
	Sqg9QTnKsrNzsICEC1w4XmWE1Uo4KEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 6AA1FA578EF;
	Tue, 12 Aug 2025 18:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111ADC4CEFB;
	Tue, 12 Aug 2025 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755024030;
	bh=Ehdoi+tqwd7gasNT3+/xFAmwud9NS1gi6Msx+4xdnbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkV3t6GbOvkBq8Xi/VN7/NdNc5WB6bvnmNTY8vUCY9U64j0HBZbTaQzTv6ns6SH3w
	 8RqTBt0gFksB6BAGLIQTCkDRufQjSK1RLDWenTQvYSeMWRQSntynNE5vgIP+RzgEUb
	 +lnsN94W/oUmwJINmjhbedw4r4L5P5oFA1aXPbnGSN0F2A22qfdT5N2RiM3twVGbdM
	 NOvoB+T2Yajr5M+OTEk+Tt3Z8YpumMvZn8f+enDaY16GDjxvn24GNFaTmM2QXfK4bE
	 sFvCBucs+eVuUAfZ+FOtA5HXAMeIrS2nfOe3Nv/pHxCAZrvzvhP2Xe0nkYSkNLw6cu
	 CJsowISZocw/w==
From: SeongJae Park <sj@kernel.org>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] mm: remove redundant __GFP_NOWARN
Date: Tue, 12 Aug 2025 11:40:27 -0700
Message-Id: <20250812184027.57846-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250812135225.274316-1-rongqianfeng@vivo.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 17AD740009
X-Rspam-User: 
X-Stat-Signature: obdd3ay34i4pyqdw8aes3okpgsnpdiis
X-Rspamd-Server: rspam09
X-HE-Tag: 1755024030-793281
X-HE-Meta: U2FsdGVkX18XQA2bxIyaswxmvAwUUBzcX/ESnB3mVGAIkaoNmrfNajAAWdzVvojOHZl0xlcqc9zC1Xi46iowenYtu/aRZm1m2Lxbjh/Ef3Otnx6EmUG3Cp3cbWnu+0p+U/ir1l+OF0WKyTlMZeMH0CDOXJtjz8kmfX3HrRlrxJ/GNmyo4qkw5wDYPQdclVISs5IATjOP0w20x3J7EmBT0qUC/pda8mEzGZi3naZdXzArgDY1d/5/aHm9LznjTuqeB45O/UUgdjQlbB8caNjujScWhcFSfkKSM/a4+L7p8xAD0QGfZRKKuyyxZaMqzKfJgbYzIHvSHdXY+Ya+4uyk0i38XzIslxvJ3IFfpAArK6Ey146XvJ1vceiT9VFx3I31qsmygfPcWvzxI1Xb2NyShELjGRIolbvdTQc9VW/RXI8rWA3VK9kEEuOZP67zGZpTQk8VKBKo71QfPkR9JzhJCusyyKSr3G9F+0td6QgLe/geGFSaUtxA/CbKVvtmxc6ZPosnxQapnErUZi3Hm032h+wT0kNGmRO45YwX9B57W5cLrwKcIp1nF7371SlxF6mwpMo1PFNdKQeNXG5ofAsx+NGUJtimP5RYmjeDBusuFGhB+Q8y+ZrXrGD1JAbi9RZioB/qBiFYiZsVluk12YQ6ZQkXwoUG48daAUxdfb/1g5x0t7zi60FNIVM/tg59/voEc5o0y0gu9aCbxzhyDLFEuY6ULEz2e4ywymULA7DFK7MrOzzzJg+EGbFnZWK6FYHfzTIQSWU3EJJSH9Ce7O/4ya7hQUU2XbXvXXCTS0ZfFpaQLVCHuZ2263MJub4RYfrFM0yqNkO9MleO6JLbhLcCUcFjvS+wBd57jgn+Y9nEXrhtIfOFpjkFDXRKPMKNNwsGm88YtgUHezLNKxcUPsOIfI5pVkDQa8LWRMMydN2wOkEIJRA4zqYvEQOQOEXsdTl+Yes2MHPuzgDTMP3MwDy
 SArLkrzj
 nCpbQKQBnFFkwuECaPk53k195hON2ptGHqWxKl1+m8d5kO5cIyd51EYO8gPNxNd/8+IV+DO2/eiKS6NYDV2ONlRmPU1j1KaWDOYDlu2BMQH0CnH52bCa57WQNDewHArdHyRhhgJmfucpaJdoi7TkJDVRzRRdeW+U9b3WcA2ID/qTE4FwIEMcHZw05ITuU+c7V5fiPwSsHc401jeOC+QvObwlpCYHs7Wt3QvjjUbjRe/O83zJjAX3L2voHrXvyuGJnHUSrEfIjRj9ZPJ1cPh53i0LSpXWQqCnHoPtP7LhWljdhz2X/eLWf1Kj+737UFWj9DFNSq8FapfKangQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 21:52:25 +0800 Qianfeng Rong <rongqianfeng@vivo.com> wrote:

> Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
> GFP_NOWAIT implicitly include __GFP_NOWARN.
> 
> Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
> `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
> redundant flags across subsystems.
> 
> No functional changes.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

