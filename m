Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A02C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C478E000A; Tue,  5 Aug 2025 14:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED208E0001; Tue,  5 Aug 2025 14:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603078E000A; Tue,  5 Aug 2025 14:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3FE8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:43:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C28C157021
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:43:16 +0000 (UTC)
X-FDA: 83743576392.23.BF303A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E6E39140006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:43:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M76ruS2O;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754419395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CI1xf02zu37CPcjKbIQQdKhjP+sGaMbMBjxQCE40THA=;
	b=zqy+Fcic9V4FuwgojAbpUb3jUX663R0uIVMFpRFtAwi6RL1lgJOfG6A64XUw2204xdfJRr
	mk7elERwZHwvfC1Kg2IBaUS9wE18Zm0nlEqsIfoKMrWfPE4vggD1+n8f6+x1RnaThpuCiN
	Hrcnpi+mhT6mj7BRi8CrzohSQoRjo9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754419395; a=rsa-sha256;
	cv=none;
	b=xYPW9+xDKaEOfZlPJQ7yzBrKEZ/6sG/9f/hFH9l3kxkL5vydfD2nWQfwDeCRS0yUsPkkwh
	taRH1COYvkXx0apXQNQ7RCxsx9zL5F5+Q3lTTfW8zh0ts5RMleC9nm8bVrmK8Y85s2DUTI
	BA9LkOPOeGQ8kRxTmPdpSjMWXsFa4B0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M76ruS2O;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9655C45983;
	Tue,  5 Aug 2025 18:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51286C4CEF0;
	Tue,  5 Aug 2025 18:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754419393;
	bh=H1l3heHwC3FXt6so5O1wZBz9sD1wO//8EEGy+nE6jPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M76ruS2Oj3LMc4bbOQkTKXvcMRXIr4wEKI1Ifm0OkbrwecmOPiiVEt/6Fpvq1+/St
	 J4jaggh9guKOMyoHXW2qnpe7EBrV0zZdU8Fm7SrZEnAH+CH1JAU7dTzum7OsPlO7Y4
	 UJHXqWANO5lSfjARnlCC3yFS9qcvbUUo5QpHpyCoyfcqWzO4Cir77L868aC978rGdg
	 zCuxHe1rvAxjNFzMAOUNtOA37mVQ3lUM/A4vCnegwNfMe9l0ggX2RX3hfQDEkeWuQi
	 hVWw52P7lfLWKJgVjvqEVz0PBMTghMW+aNP5w9LqOZ822t0PaWkW+StjQ3ZF6XdPhN
	 h8jSguoFsyY7w==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Tue,  5 Aug 2025 11:43:11 -0700
Message-Id: <20250805184311.8563-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6E39140006
X-Stat-Signature: gtmcjngisr653fc69m3ui1krtwenyaph
X-Rspam-User: 
X-HE-Tag: 1754419394-200723
X-HE-Meta: U2FsdGVkX1822++7f0W0vsczuza0xewGUhREVeqXr1t24WEYKPoaKqBcECbW91e31aOjNQjKdxchLiVuBwrP6z0awJMNut07rDqiV22vy09Qd1fpRG/hUcxgE4Gr/y8e2GVwJIFq+Z39raK1PRYt/FBQxn/Rrikk/YoD8t8VX/BhrI6jBdkxW0gIX1a0aAo5CpMueqA4JFg5By0DajR1AyYv+HZ40wAl7U1ZZXnNbPlLE+ozoFgg2ZEZIirY6n4rMhiSAj+UYCkBr6XHLZyiEutXGAaDU1sPBrllxgdfVc/I/5Y+5ZyGUTtxyvJehUks+vELvWck6mOjN3JXIzTvyX/o3D/FelZ39eXaw0xwYuALXAOKHGOjIyUC9zQPC/LYOcf4AgaSbWZ25A0C9jpq7vkBMR03WiqkDO3vvV9TQnAFFyAPuiFRMTjze8GOA1vjx2MS4KoQFI5oD4N+DB1avnZJ0bAFvtjjx1eK9S+zSR4LtjkfxDksDfgamAtY/lU0hD0Rn/zYlBtr4y5UHHdKdOPfhCeMDoeR4RrW58eXUErLX0M7FnvaVhKVtfX1BRd+drBJJT/vlMagG3MrjCUXdsXhXM8dgfjzW/PBSnSvN/FYgyexfhysBWXmPRx/R0w8vdXf2/qe3Otd3Z8E7APILjyLDFo8ghaWG7X9SGqDS0kFT3VG5kx4g2G7IEA1xqcKh41as1u3PvMK/rRBBQPIXSR8bC/Fr54ho0eb5UGSEKgFpwbJFfky79Ec49Gfmtx0SlrpQ5zhJqcSymGScntficA/9SZJNL/tsEshrxBaIvv/seW4PiLTOMYALYoTY4HSmtUnsB2iqTZxvDmqDDgvDViPxJX/jFHWUXJLHN8exyJGXNVvDD4urUMxt4qCMuUdDtvWcSkpEvv46CjZf13iv1wrVRm88tVOp7OZfkH2Agwj9+KTEKog6Fd5S1Tx4RttouzCKu8zKJ5zbZsfoaH
 poEPeNvy
 pye5Omwt7RmzBFypwyQ854s9pFy9Ue3xkmj7xWba7CIOte0pheMPiDiaWPTZ0tvtv/iYLcyU92kzqZdDSivBTr3m6ty1/klOo1EzqGMGPm+TeikEVvrmNeJ18cI554QK6UpFxN+evf/cP3WrDL136Uvy0uMnHStuZoflGVVULymvCX4dfg8GaC3qQ3P32bsbaQnpq2UOblLPsPTsdHq6ubCCZ49IuTQwqmxudJZeXX8N5u4Bhtk3wqc4Pf24QZNIcvPRCzBwGG4W3G1U5VJUlvQPSlHEOY8JCt3ug6UEZz8WzfCrhZf/qyk0J7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 5 Aug 2025 12:47:36 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 05.08.25 02:29, SeongJae Park wrote:
> > When zswap writeback is enabled and it fails compressing a given page,
> > the page is swapped out to the backing swap device.  This behavior
> > breaks the zswap's writeback LRU order, and hence users can experience
> > unexpected latency spikes.  If the page is compressed without failure,
> > but results in a size of PAGE_SIZE, the LRU order is kept, but the
> > decompression overhead for loading the page back on the later access is
> > unnecessary.
> > 
> > Keep the LRU order and optimize unnecessary decompression overheads in
> > the cases, by storing the original content in zpool as-is.
> 
> Does this have any effect on the movability of the given page? IOW, does 
> page migration etc. still work when we store an ordinary page of an 
> shmem/anon folio here?

Thank you for good question.  As Nhat also replied, there is no effect on the
movability.

In more detail, the handling of the given (incompressible) page is nearly same
to compressible pages.  Zswap asks zpool to allocate memory, copy the content
of the page into new newly allocated memory, and let the page be marked as
zswapped out and hence be freed.  Only difference of incompressible pages
handling is that the content is copied into the zpool memory without
compression.  All other properties including movability are same to the case of
compressible pages, so this patch doesn't introduce movability difference.

In the previous version of this patch, I was manually allocating memory without
zpool's help, and hence other people including Nhat kindly enlightened me that
it can introduce migratability difference.  Hence this version uses zpool.

[1] https://lore.kernel.org/761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com


Thanks,
SJ

[...]

