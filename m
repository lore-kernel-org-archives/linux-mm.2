Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35625CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F13F6B009F; Mon,  8 Jun 2026 07:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7DC6B00A0; Mon,  8 Jun 2026 07:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704646B00A2; Mon,  8 Jun 2026 07:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EBB66B009F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:06:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 107251C29D2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:06:51 +0000 (UTC)
X-FDA: 84856467822.05.270DC58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 719B5180009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:06:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEMzA+zx;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780916809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Z6ITjW+9ib3T9oaP6VQ0ImjtuaXiSytRRMaM1yP95c=;
	b=jbx377BOV0MC2dpEzYus+pBJDNX37VVwxbdGhnTzTxJExQQIcfoetCNa4QtCFVmVX0oNQS
	bfmwk3NgUU29qh2+lC41djCkQt50NG9h2/+WLOiHtdDTEu9hngeRqpLoUgEwBMmxTqU0+b
	HORwBqwBRG1CQm6RBzzdCv43a+aR8Mo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEMzA+zx;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780916809;
	b=kkjxUNWNhuONGbyUwy0SF27fXSuRgHOhPJSRWHbZL/VNdZHD0i/o3iRS58+0O77nkp37bE
	YXm5jKV7KVhFrWfuOYn7f1rTc3t1NQBZhcanr0/WQ9ZQyyrPw3rwk4CQLtE/sdtRuNAWzy
	rnTidoLOo0fDL4R1ChLZx6xmovnOoNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E25B2601D8;
	Mon,  8 Jun 2026 11:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977C71F00893;
	Mon,  8 Jun 2026 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780916808;
	bh=9Z6ITjW+9ib3T9oaP6VQ0ImjtuaXiSytRRMaM1yP95c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FEMzA+zxJl5fL2o40m9U4BwWUrHPiIcEF97nnqiTlztYyn1DoUl9ddn7aNoqLBAoy
	 H+OUCjkZRnolnNh5+UYHDPGU4dl2p9xvSbMmpQEg4lufiZ98AbWi7KWe7EX8WrtWO5
	 9PCRCGezNw3jaINWRud6uRSJD9w0NujKmqjjKaKtxajnC1HYmhhmB4SjnB8AfUKd2t
	 RsYua3+g5qUujXN5+b5SQ1Go52nDgoXOAWh8i+Jl1NG12Fugaz22qDQzclB2RfYtmw
	 5BafYyB5QWqqVP3BLH6y3WnL1UyZVMeYnEriW3ollVQi3MR8HC3BOYlOnkX+QG0yPP
	 Y9FbcY/maJHpA==
Date: Mon, 8 Jun 2026 12:06:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aiagMc9Ng_AE_adh@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiaUDTeHDA45ZXFS@lucifer>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 719B5180009
X-Stat-Signature: 4zmt7tci41cjbfcgz7zid4dt5wsjsgny
X-Rspam-User: 
X-HE-Tag: 1780916809-646985
X-HE-Meta: U2FsdGVkX1+A3rWSChAm2zmmvpwBKKk2f7Mf7xs4zvLH3cil5rhNvSv1iS/fuKWSrF3GGtK6vknR88WqzuawU75Qh76CcE2zyZYHpYm9E8GNADj+plnqTqlX+cQWseVGfyPSd1Qmz8Zx4r0GEhacHtJ3OsvL2InIPcMvp5ih6BjynwebEh8YCV7X3Jkd3fifSnn1E6fieZLXCcM6EdiQkBE7xkxTNNE77BB8gRE6oers+w/7U/kemYZpb94zvolHAMIvwkmX67ciGln1ztu6fP6oYHFPm38taIs9fOvs3FeEqlNEqwlVVb9FdryrtiIYErkUyqAQu+vaIELtDCuQA8gcpsNAsNCli+vyTdHofApdBHA+TFPnxnDWhKsBWdk8+Nh3bIJvQponqszhrEDhXGfeAKq/KypJApYWK6pj/X1Udu5p49ML/8sRdrNRiM4fEpClglrvS9c+SKva/HO/mhE5zOs2wBeHIa3/NJmxZn9sde/i0wHAGuuxvM4wPJsf4teMpfNhnzpvnLmJ1OQktQsB5Ta3aLiFgwYPsNX1fXqWJz5uV5C/KM0DggpCGGY1Zpn1k6vQRGXd3CJ5Ej5+xq8cSAonsyQVltPMv7EoTaWLdOreAUviqlXo3TYKjiLAYqW8S52DvTI62lOROIZytI4ENoANmSJarVD6XZ+UY4WaPY72himjslgKbX6JrPiIfQbs+YkpPt/I6+kj5YwnnoicTfcFEylttbUHLC4Ve2X5T+59Ly1cl2HYBqic7OyVEywP3hqzUnN+8Jcs0HhWPV5glYoHNewtfkvM9RSSRp9RRIds/27xFiGWy8m++6Fb07n03SMDwvWhzUR0l+cPJV3Q198zJ4s32YJEH16MpyxPxjv/eUThmUNM8H657lDNgdf3EEZ0x+ih39EAfrnjqd8sBWu9/zxvwSj+orm8toulG6he2b/TU2L3QGMEiBQGfF4si2YLK3CJc+Z438E
 tfNJfxpj
 xDPjxRaFuAkSUsWumN6qtIZz77fhef3Cn9FIDmnD6frE5CEz/OBdM48KJSGM/um/v+TC9605ajVq+f7JXNfT0KJg4fC2Z4/lEqjcMxKyUnjAMGuzWlhp+WzEOqNQPhb9l6tXZoRFvn3PLvRliF1Od0hegOXPkXdE4kYW6P8RYH+mIdUkjvgn5B9vgWO4p0N21tdy2qcnc8DVbWy+kBw8nbFnI7sc/celNNSqCEgh8ZSmis7DmVOiPcuMcvWD/BGbWmolGXvJSofdU0O4Me3UTwTUwTQI2w76XOiXU0uW9lK96hujRi/E+VPPyh4u5Y4ZZUjVHlRqiRfIGNQSw8BIaFLj5XnuRHE7Q5SoCuLj1UC4PodplTPytwgEUQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In terms of an alternative, I feel that we should:

1. Continue to not change external APIs (correct to not do so)

2. Avoid adding this to any code paths that don't strictly need it

3. Refactor the existing code to make it harder to get wrong. Don't have an
   easily confused sentinel, rather have some kind of context state that is
   passed through.

I mean we already have alloc_context and you're already updating it :)

But instead of overloading user_addr to indicate all kinds of things, instead
make life easier by actually breaking things out.

Like:

enum alloc_context_type {
	KERNEL_ALLOCATION,
	USER_MAPPED_ALLOCATION,
	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
	/* Perhaps some other states we want to encode? */
};

struct alloc_context {
	...

	enum alloc_context_type type;
	unsigned long user_addr; // Only set if type == USER_ALLOCATION

	// Maybe something suggesting context or whether we init before in some
	// cases?
};

And thread that through?

That way we can also add further context later if required rather than this
awkward easily misunderstood parameter.

It might means some further prepatory patches but it avoids the confusion of not
knowing what to set this to, and could perhaps be set further up the stack?

Then look to completely eliminate cases where we zero other than with
__GFP_ZERO.

Perhaps others have ideas too, but this kind of approach seems more appropriate?

It also seems right to send this work as a entirely separate series. 'Always
zero user memory using __GFP_ZERO' seems like a totally valid independent
series.

Thanks, Lorenzo

