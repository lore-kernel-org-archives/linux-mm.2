Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D67CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6CC6B009E; Mon,  8 Jun 2026 07:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E780A6B00A0; Mon,  8 Jun 2026 07:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66DF6B00A2; Mon,  8 Jun 2026 07:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C39E76B009E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:02:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B230120A6C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:02:24 +0000 (UTC)
X-FDA: 84856456608.26.0A1F5D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8BCDD4000E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:02:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fYlWsCjQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780916542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIzKi43TUjbg4FlHj6+GACVZtS3PHXRcToZL2CXLpRA=;
	b=q/EETfcJzQNiM/REWoYPsbrNMUVWMhoPjXr3X7/vGTmc8xHZht9knxGMyCtfYk1C/Pjia4
	jEJeEICffj+xIVX3kisK8ldthk8VQYt1+7Ny/vuABRG/BwFIwiv6KpOyS5WRsBpnYKZiYL
	6jPUncMc/kmzcGX4ZPZbB4lvAnlE20I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fYlWsCjQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780916542;
	b=P+VrBNB4Brt1UsQ1DO5jKegzVBYp+Lnp+RPCTBjoYkzgktW1QPohdn/m0+JsfARJDANcSd
	jH5l6hgXDAXIMPw95Jr2L/FKEr5OLXG1m5sw8j6KpL2SYzumju/HPxkPEzp5Is39SFlnx9
	jxPJlilRn4bs8tVhkAuDKUdn3arlEC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC0316001D;
	Mon,  8 Jun 2026 11:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1E11F00893;
	Mon,  8 Jun 2026 11:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780916541;
	bh=WIzKi43TUjbg4FlHj6+GACVZtS3PHXRcToZL2CXLpRA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fYlWsCjQkHszY4BsWoff89dRo8UoG4l7io46u64xTZJaoauh8wIhhZmkKb8vkJW5m
	 +syRkwdMi5lVMypKUr640KAhg3kOPazAdLI0pNefyxl5O9WZ0x1jQ+AWpKltqrCDgU
	 xIxBO+CO2AW+gPBZL9wBag9p0F1VrOIYDlzFPBtYrsq5mz7cRFnkDC6q/m6FrTu1dm
	 G9kPPGLWPl81hgx5lYVGf2tu2VjNMM72xCFCfNktUqkFsv8oFD2HvWIIV7IVxGggZg
	 2U0DXpUuWSdqYlcPNoi1mfTVzbeEY2Hj/9V0iEoMdOHAuz+MSSXxWiAusmZmANZzIs
	 Vu7R3lRsRswvA==
Message-ID: <8d5d2fa3-a60c-4d04-b3bf-7a8fe89cb1a0@kernel.org>
Date: Mon, 8 Jun 2026 13:02:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8BCDD4000E
X-Stat-Signature: baqba5sgd6pi1kbxhq6y775x7kebe5sr
X-HE-Tag: 1780916542-897650
X-HE-Meta: U2FsdGVkX1+uvAaYpAikKBmjYubPy/45fy8wbc01plzKsc3izA8NdMzruLeVQzfqNJsUAuTM8rgQPMUuaKhq1n+U+PEcJFA7L4ZMQgVYwFZ0e3U37XJM6WyRxQ6Y1Waa/zh3YO4tmynmDKWpJ4NWPG0yml36fdPbIBYsJ7avbluVfdyRCTcs96VpUOae+Pb29QzZRXuhIBT9t/8u63j8XKyorjsOD83ByihKTFzq/jXH/Sz2EPe5/11UKqNIrwMSy4sWwLkWT0fPtVhjHNth3dYHU41C/YsVFomit4c1U3pD6acbyLaTn2kVESH8B2IL7AcS+SrG86h1fi3fI/oLtaXbJMSmdFQkngsArsFhxydp0+OdHMDxR06ns6/cZuv2lEji4k7Lf0Bz79PH2wfi6yPib1JVo9AnsbY2YacF6A1fYTHpQKPxDiy1NspJdLmAZO4ux0GHS1XRU2rkV/NR6cp0V1eRDNsbphr8OjRvdFr4mweUikndFPpSaPkchst+obeAlTU13UJAvP5QL8oZC9vUxlTlF3CcMBqKbI2I6WV/7BmNfKPr5FD37IZdCPosORCUJBz//HYFo/Gk1g7Lrdfe4ylDQVCbce9tK05DDIzNmoB1iKYpd/bAdvrpo/7p1cD5tZjC4eTbTRzp3C8QPdE4tsFYMVd3d599vxxrMnRmUJITzmpLZDWXBtwwdvjjLYOk7KrQa6zHVn1MkW4/umCVOdhmNc3CKCOmsH1AIEQdUbsCiNe9ASwtha2iaOmlNPovn3u7Bm5bcZMgDYh0MF0wr7BGYXyTgWDLZ+NvztP2mm/UcbvmWWbw1pG2xNNV8YR0HU0iVJxr2JnerH18haQ9WQi5TBmCSbjgUQDq3bMQDQrEkVMjLN1uDIRcjUFQgpC09lTOLd5FDbb9swOx0A/OZk2xkPSwFkc3k26ccCF0teC2XdU9aAEpIS/7iJjPHXz49ukce3IXPjCAanc
 dEpvGV2z
 kodDV9jDq9pUuXGNsllRGZjqRA5JgBDr+3DoMtmKFU4IucXPvIdOzJ/7WmEYAJfjtpfmMwcjangW4yBZGGitWu1jppRmizfCTFcPRpXd/SBsrHPtCH2BQS6bzCRqiShXULeXgOpgludZ1VWCdV7Ze/oKDgy98IPIo84m8jf780SIRrEKj4sBJN+f2ywLJk/ThjQoogpHVvwf7fSGgP4ZrIFvlvNjuOE79YyXhcEDQXzMCmc/ZWSVlTQmswkvtWgLFdx3XWZDYWrkg3WhG/TNBhzvs91y3iDpVEDIgQpQT/Ab16VpPAfU0cNXbqqPS6gpax0MexfM8wEF9xlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 10:33, Michael S. Tsirkin wrote:
> Further, on architectures with aliasing caches, upstream with init_on_alloc

It seems those are niche architectures so we can ignore that part for perf
purposes; the other reason why user_alloc_needs_zeroing() would be true is
booting with init_on_alloc.

> double-zeros user pages: once via kernel_init_pages() in
> post_alloc_hook, and again via clear_user_highpage() at the
> callsite (because user_alloc_needs_zeroing() returns true).
> This series eliminates that double-zeroing by moving the zeroing
> into the post_alloc_hook + propagating the "host
> already zeroed this page" information through the buddy allocator.

I wonder if this whole thing would be much easier if those that would want
performance would enable only init_on_free and not init_on_alloc at the same
time. If you enable both you're paranoid and just eat the cost I guess. Then
you're maybe also paranoid so much that you wouldn't want to trust the host
zeroing anyway?

post_alloc_hook() already has logic that if init_on_free is enabled, there's
no init during alloc. So then I think you would only need to communicate
that host zeroed some pages when the guest adds them to the buddy allocator,
and that's it?

I.e. if we can just assume that everything in the buddy is zeroed, we don't
need all the PG_zero flag and whatnot complexity.

