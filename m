Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFDEFDEE39
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 00:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1634D6B0088; Thu, 23 Apr 2026 20:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1145F6B008A; Thu, 23 Apr 2026 20:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0512D6B008C; Thu, 23 Apr 2026 20:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7FBB6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:26:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BF7A160B52
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:26:37 +0000 (UTC)
X-FDA: 84691558434.19.70D84B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7B6FC4000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:26:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uYLMGkPr;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776990395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGPYW7JTY1VAvn+v4ifRtf1T15az2aBIX4SlZ0+Io20=;
	b=sTULGIyQ+U1aPrnfIWpzGgZ/exiDjeAvJCpkB6A4tFywBRluHwMowetnirfeU7u9hG6srw
	vmeUOC/G6+nFzGfq9LhcSgMaady0+AohTLBUac5Sj39gRW+dknnL7zxcWVU59zYMwWBrTU
	3wbiSmJIMchWQCKpnwmHZxN1pUVZi9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776990395; a=rsa-sha256;
	cv=none;
	b=ybjC6vJsdVpJCdZAdlm+kgix4HfKyKFwrlvHFSV8mrKotf7OGFlCyN9k9Lq+96geloQwJp
	Y4TSaOXHCVqm74Zjdl5Az/VI+qn50V1b/B7naIQvY3jo93zXodCnjxrKpyoZ+wvxmT9KwG
	X0zmioqegam8f3bndUmiQx86G5qTkjA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uYLMGkPr;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67EC643FAD;
	Fri, 24 Apr 2026 00:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E894C2BCAF;
	Fri, 24 Apr 2026 00:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776990394;
	bh=Wj7MBRLrssfpOdJSw3iPqXTN5nRgvGJm3FItsgv+Vek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYLMGkPr0oW877jQr7py4WfT5WNcb+zqX5VW9F0jPSCMZMSt0lCf5ALSrINIqmnVV
	 QHzk88X1JWZxm+UGrHtWamlGKFJkroxYKtbF/b4Sm9x4qdo1w0N7VcJ0mjzj5jojhe
	 U8HfOu9LA/tNbClE2Zn7i7SJ2Hy/R7Pz0fIFl8+8Us+yiNYUC19q1lhFxBZ7bUg/Os
	 RzyLOX9meKjztf+SxOH/spUDLPvmlptEc6ZiyERnVJgRu0RtuABlov0LF1IkeGu/0C
	 TPyYkmHDEnNcADg/RgN8rhUAU4Z26WaG9QN3I5b975Eg4YL+Pn3OP07NTQFp3huU/1
	 72uQgg7v+ZBlw==
From: SeongJae Park <sj@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest memory
Date: Thu, 23 Apr 2026 17:26:24 -0700
Message-ID: <20260424002625.89857-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aeprnnccJeyHB2rt@x1.local>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9gip3cctyythasuqnygsqosjzrkc47go
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B6FC4000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1776990395-323383
X-HE-Meta: U2FsdGVkX19Xfdh73D/r2z1irvawNyEV/tesTaOsu2XYOzjNq/IAKPQ8EpaRNjSVor4Bu185MhBwU2L9q7Wm9J4rjC0ND2mS2K1WrCewEtj9D4BYiwujY3I3FNF3h/x8POXGUxwHToe+VWj/Ncc8hcWGPydJ/zl7wGf0eMZ5L0l2esbToedlQhsgIIQR4GRhhIkSECI5iWqEsZZ3uP9JHinFXp7yzld3UBHiYkeNIObHyf1VaSU/AA4GVPqace4Oq8Bif9KqvMODFfXqix5jvp8MjziqIcCjdQoOdVsSx8DOQibcoQHc08aunYgUmfWn3y1VvkLz6og1SICvCrFmhXdweWeBgfQCd2Y60oyjQXSLdYLhnaoBe8GVPHFTb59/b+l6QHj7uNMq9h3NfYpA7SpfG0RTrVEJilvjFjpCXlSJZV/RWcuc+Wt2nEbJ/YBIfIBUdmH1j54b9EnEo9zk2f7wOhen1CmAb0kwIVPNLjKRKm8wj67dfSanY556dXB0aBcT6X7FvUoyDUOZyDXQufXzusHDgeKc+uoW/+KD/nFqcrZs0ESAoGmrEPvU8i1X2gnEF7wyMCeK9Rb/jSCvHGS/HGbI7SEJolitIbtIqAJ7FJ/nabUoz9/A/Eo6MF4Pt9jbrozMVL68d9/v8fUsxV9lchuf5xv6ANOA+icFUhOnrzdjKNwu/jkGTrXALqL8vvH6CmtIEVicvFmPxqk3H0H47rlktUrhyJfChnj3fQSZPn78mIihQGK0GfKxnVqzIKk94sUudLIJ5B0kXthjfb2Zb+/MLdIpkkRdsoip1WSQSL+hMZACNcMvtt3HGQrgdgkLlJCmE/8St19Hfz2S0xnQpZ7FoMn/Rowh4vWx3MTm9RuW38/FX/W4MJMzhU0JVlul91Df7AX0cXiIJR0pLXkquyjO77dzo33ioYgmc2bEmlm6YvEECC6aKF+uXudd0kQi5QCnWiybTdy1OuW
 4CM2E1t7
 yeQekVQTD7l5exFqHIm1WSb7JOWzb9w9af3se6QNuLjGgjOfGcdf6YKfqhKV9e1or9zyAl3kIev/1nynSIdM1X2+F8JNBVm91k3TWHTPm2FMrulWKGXZ5kbM1uby8ee/WAM2j085NK1wzoCEyx2Ym2PzgP7jHhW3/dnuQjqz3x3dCYbIX74hAIqyAXLh6O7eEXb0NR6gxo023ndpR8BLxJWPz3S/LijGzI86OFbfY8yGCRFQG4nqWBreJYHzPoPNwaSKPXEPnIVIsior8lzp1I2CXwwVhx5Eo08roYQUF+xOD2fjrMaru9hzJf5uD3rOqj1eiG/GiBGRoVWOuSNAqgcI0x8y69NPesa9Wn2IoDhVlKu6N9/MZ4ryUW2W0m25QV7rd7Pnq4er8vqMZBrITdQF8DzInn7nHCrf3B7nON2W4LOqeiLUXQGgWaxVcFbi1ZGKvx00InyTlbP0c4i7FBfRPxSOMtt0TC6Crid8l2P1RB41RxO17jVELwXP5LFb6eZ4dDgnk6hPlYVgM5wCAzTtgLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 14:57:34 -0400 Peter Xu <peterx@redhat.com> wrote:

> On Thu, Apr 23, 2026 at 07:08:00PM +0100, Kiryl Shutsemau wrote:
> > On Thu, Apr 23, 2026 at 10:50:06AM -0400, Peter Xu wrote:
[...] 
> > > - Whether we have explored other approaches on page hotness tracking
[...]
> > DAMON is built around sampling. It is good for working set estimation,
> > but I don't think it is directly useful for eviction decision. It can
> > miss hot pages. LRU rotation will also loose info.
> 
> Exactly.  If we need to collect ACCESS bit (or anything similar) for
> eviction accuracy pusrpose, IIUC we need per-page info, we can't estimate
> by sampling.

That's a fair argument.

Nonetheless, there are some companies who use DAMON [1] for a similar eviction
purpose on their products.

Also, page level accuracy issue was indeed concerns from many people.  DAMON
therefore provides page level DAMOS filter [2].  The idea is finding a large
region of cold pages in low overhead first, then do page level access recheck
on page of the region using the filter, just before doing the eviction.

DAMON-based memory tiering also uses it [3], to avoid wrongly
promoting/demoting cold/hot pages in DAMON-claimed hot/cold regions.  The
evaluation result was not very bad, and a few more users reported positive test
results.

Also, DAMON can be used for page level monitoring [5] and open to changes for
users.  Actually a work [6] for making DAMON-based page level monitoring more
lightweight is ongoing.

I understand no one fits all and the decision is up to each user :)
Nevertheless, I will be happy to help if you have any question or request for
DAMON.

[1] https://cdn.amazon.science/ee/a4/41ff11374f2f865e5e24de11bd17/resource-management-in-aurora-serverless.pdf
[2] https://origin.kernel.org/doc/html/latest/mm/damon/design.html#filters
[3] https://github.com/damonitor/damo/blob/next/scripts/mem_tier.sh#L40
[4] https://www.phoronix.com/news/DAMON-Self-Tuned-Memory-Tiering
[5] https://origin.kernel.org/doc/html/latest/mm/damon/faq.html#can-i-simply-monitor-page-granularity
[6] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com


Thanks,
SJ

[...]

