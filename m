Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80514C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8486C6B0088; Mon, 31 Aug 2026 13:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9BA6B0092; Mon, 31 Aug 2026 13:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70EE36B0095; Mon, 31 Aug 2026 13:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F31A6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:52:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB6501201D1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:52:48 +0000 (UTC)
X-FDA: 85162310016.26.A9C2B58
Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id A712320002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:52:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r0PtDBGA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788198767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7edVTSW3UCTFPu10SXPL1y//qiGlGvLdNQwP/gCCjW8=;
	b=Cguud1H/WMueuByK95eWlcM3FQTgA4qPKLVWUHwk/R2wF7cnwXx1Utv2jfc6syanrS3J1w
	Cb3Wonu26prN1so8jgbelmjo0eLpLUsABgnsn0oJNMSheCBX57QtneHdyrW3tIefM5JxQv
	kxts/4Yghxo7OGwqlD56WsPaLl+Dvu8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r0PtDBGA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788198767;
	b=JU50Z3OTj6KtAak+X1DN5aX960YO7Fsu8FqZi7s0YZ3RWKafBJnmn6VQ2cv6jKmibB6xGN
	cmyFjo9qPsubsG4Bn8H4rGuimk1fNC78bXkYUqKuowJg6b4BNk/WMmendA2jzbMMva3Z1j
	r+VkDP7nqsawu5Tij4Q8CQD8t+MsRbA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BsIgtLWDoXUh0LcK2P6/hUTeOlcXonOAihqw77WsqZc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788198765; v=1; x=1788803565;
 b=r0PtDBGAj5IPiBeH2SDudqKC2RXht5AJf1i3TPIM/ShKr5UjrEIGzrrxlSrd7WLEKYlzWB16
 8ZFqnJNkT8PXguO8dx98psj1ayqOCFBGVAA2noX3QcTfBj44bjJjTPBWRHbWtRupMXyjD9gc1fW
 rsl4nnMe6fS1JxEiL9wo2eOk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d7054335f12e2924;
	Mon, 31 Aug 2026 17:52:35 +0000
X-Mizu-Trace-ID: d7054335f12e2924
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 10:52:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joe Damato <joe@dama.to>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	stable@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcontrol: raise MEMCG_MAX for charges that fail
 without reclaiming
Message-ID: <apW_N1urVjfCLmbZ@linux.dev>
References: <20260831174836.3102406-1-joe@dama.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831174836.3102406-1-joe@dama.to>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dwpseuqyk9yf8qwr4rsongekyfq1gosk
X-Rspamd-Queue-Id: A712320002
X-HE-Tag: 1788198766-680310
X-HE-Meta: U2FsdGVkX19P2bxlEG5dh+EGUMS7B6vn2yoDaZK5/Qo27X6F1Kf6Ek/GlXOnWXPpGTpu6dhLzRwnp7/hEzeGeWOQqf/vi+sBxvb36LfAsVG9/2q3O8HXeUwFakc7Sqnyw7VC7kiV1HefNjwacZ3GY8kegrMsMrCPatTujH6pajJ7dew3YqkqNTkLq45taUqFSTi5qcgBAOjw03hvzWS7Mucd3+ar4LCI+w9n7K8zQ6/qfoTcvkQnXDGcS26ABCIzK53Nh5AoZs/u/ALeAXRmE0zT4jNJqWdWJIKX8BpG1SKh/0Ga5KW5i/6bO9z0uzheshRWTgTlUf+L8C453Iaux9195yLa+p0WF/Hgd/SETSnqhcyMmX6V2Kb4u01OgIY3wZvvdP2TcHHcJzrhyOpZBpiNGvU/8fdPj00g6eF3rMljHI9ptQJEb54K0qbK1sWS0FFw3D/h3ZIDaWJryRikauH0phhVI9k5TcPQXT088WlHnIOir7lI9EExWPf/XEx99UGuJLPkgz3LmU/ctN5IWHbq2RA0QpVTQtoW6CszHBifCMlcdr7AxzWmdVcr+r025BuZ3iG3JBJAVm5q+HngNpSoGzNtOM/XCQHBNvAeCERbuanH575adsEw9I++Cz1sjn7ll+TRbE5rT2GnWMmoe/SF6YboVEmJNFNh9jp9uO+zb3JB+idP3qwqdOvSoaQOHCKfkIT/b8sMMhiO+Ur0RmBPhwO5nxlPb/FhyPtH4LwJgExWMFCvLEv7DTxBRRQlJ0KEqYHoFmF96RRruTPgU39raapiYcOx/ghXVvMMNzhOU/NCxWCvGarpbSj6VZjWiUSe98VjGCneUxMG791N0d1ilZVOC56tCoN+OKlAHP++hjV+JuqlIK1iKYIp5DE+BNbpBn/2lolbsqprEhB5OR8I0ycy/M6TOXSLlQnnjRmBEp9KCuypmj9lEDRhFPbACeh3WA49Bpw2rs0kXPa
 9K4NyUKs
 s0Tcc9vwG47b6W0VOKRkvWwWI6kTQffls5SXu4uri/IGYN61CWTaaxyIQp/pqfqr1XZbBwlm279xdihTXdeRyn3mKFl7ujF4y4vyzgLbA7IwuS8MWATfecJc8pvvAQsWDDq6r1DiJIbd1osti+2K+NMApJjnRzx0pulldxSPHwl6WMb0rll8zsqLEvDChbR/09C+VaxQbiHca2euFX7M8MKbG+cVGtsWdSao4FOh/qIE00S/rFbqcPNlY8D2NjD4X4OgNl/vEWNhfmJqOg0q9PMOdnRlVfZvHYuLFTL/Fv89NeRduoLSBWi0w14eHvWQ/wvFJLqqjhAxGsuocz3bWXxs8ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 10:48:35AM -0700, Joe Damato wrote:
> Charges that exceed memory.max and return through the nomem label can
> raise no event and simply return -ENOMEM.
> 
> A non-blocking charge can hit the limit, get rejected, but is not
> visible in memory.events.
> 
> This was noticed in a production setting where bpf_mem_alloc() attempted
> to refill its per-cpu freelists, which triggered a non-blocking charge
> while at the limit.
> 
> Commit d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for
> enforced allocations") added raised_max_event to cover charges that are
> force charged without ever reaching reclaim, but charges that are
> rejected outright were left out. Getting an allocation failure without
> the corresponding MEMCG_MAX event is unexpected and makes debugging and
> monitoring harder.
> 
> Raise the event on the way out for rejected charges as well, by routing
> the -ENOMEM return through the same exit path that already covers forced
> charges. The existing behavior of raising a MEMCG_MAX event on every
> charge/reclaim/retry iteration is left unchanged.
> 
> Tested with a module that performs accounted GFP_NOWAIT page allocations
> from a task in a cgroup at its memory.max, and measures the resulting
> memory.events:max delta. Without this patch the rejected charges raise
> no event at all; with it the delta matches the number of rejected charges
> exactly. A GFP_KERNEL|__GFP_NORETRY control, which reaches reclaim, raises
> the same two events per failed charge before and after, confirming the
> existing charge/reclaim/retry accounting is unchanged.
> 
> Fixes: d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations")
> Cc: stable@vger.kernel.org
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joe Damato <joe@dama.to>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


