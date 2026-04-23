Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0054FF589AE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684356B008A; Thu, 23 Apr 2026 08:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CD86B0092; Thu, 23 Apr 2026 08:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599DE6B0093; Thu, 23 Apr 2026 08:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8236B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:32:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DD4140171
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:32:41 +0000 (UTC)
X-FDA: 84689759322.02.8624296
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5351F160003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:32:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1tmWKztb;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Sm1+HBnujx7eaCDOZfyNeyN8WHlWDXXHQPnbPCVZFY=;
	b=7O8hfocDXSWngUK9lzXHn6GTOzoVI9e9m2pvKeNkn21ZxRVUEisXiysRxI2FLLKvoGif7N
	IL+7zXpQz4YpS8+KTdGV9XZHQ4DA5jgqZjesQj6YHMd6t7tU/4A2aQ7S8SfC7r433fZnyX
	2QwHL537dZ5XXMwq94xXExo81asBnlk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1tmWKztb;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947559; a=rsa-sha256;
	cv=none;
	b=Mu5tjN0FxVkUuQSdCP7xZ0xwJivSzEHX55W8RKQt/0kcokiqFGo+PLayVp5G8lxV2gZI45
	e3oXv1EnHZplqyE0pE6qh3D1MQfMHvkxP7jf49Y9wx9OIPQ+bGzdWhWBd14f70zCACUtEt
	6sYedv04UHGCCCpEJvWL3BFpM7TjCrc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD58860123;
	Thu, 23 Apr 2026 12:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94F9C2BCAF;
	Thu, 23 Apr 2026 12:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776947558;
	bh=mLO1y63KeITgQnUtuuXUB7kwisFayIJWJCkn+Pp4dzQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1tmWKztbTYs2a2lnZ2W3wKk0ddFcrR5tPBvRW6LZjbenwsnC6sxbXDaVDkLHtFIK2
	 Q2FcV7i7E/VourF3CDjnZlCSvecYn6y/hnNfmlw1JVnSBIE+iCAcKf6mXAWx9SbzO5
	 DaBWiDwSdF6pPLaoxg5Hkf04poOAtzQymmkk++/I=
Date: Thu, 23 Apr 2026 05:32:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Muchun Song
 <songmuchun@bytedance.com>, Oscar Salvador <osalvador@suse.de>, Michael
 Ellerman <mpe@ellerman.id.au>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Christophe
 Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 v5 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting
 with optimization
Message-Id: <20260423053237.a44b68034673bb35a1e042cd@linux-foundation.org>
In-Reply-To: <1ADE7CE5-F02D-42B2-B7AC-FE0D6E86042D@linux.dev>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
	<20260423071911.1962859-5-songmuchun@bytedance.com>
	<1cbae635-a115-4270-bae2-64145d16f936@kernel.org>
	<1ADE7CE5-F02D-42B2-B7AC-FE0D6E86042D@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5351F160003
X-Stat-Signature: r4zpj9j6pn5adpexi776ffodf6f6fqqy
X-Rspam-User: 
X-HE-Tag: 1776947559-842341
X-HE-Meta: U2FsdGVkX18K7B4WRr35yGmm8hV4nk3EzBEFjba7gY2wSbAVsYlJ5rhjTRq1QYJaAAq29tGRZbhpC1dhypWiaH5laEiHyINl660hZtI4Lk6ux06wWsX6n455Hp+6ZfjYukPShS5DSPI64FBLDWayx9q2inCsWks6A5XZuYLghle4J7YjhubxLaLr9qWk7/US+XgsXakSJqC9I3hTQI5CWjelVQjVqpnyyGesQxt48OmOEkWTxooWSf2XIiJErUMBzV/fZDipXYZ24GWXkM0+zMP8A4eVHaJKMw8bGwaFd/o0RdiXGsxYuvHr3k7dyM0bktdbrtGq2P1+AKsnPEm1/0nyBOH2hRqclFrXHHoOhbeLNeaEU92SLVtxQHgh45u7ptZ3kAGLiwxhY6EX3vODqQDfIhCwp6uABRkFWa4idOChRM1JDPU3fsST0Xul2vxNvOWtSTOTBxLnSZkIzY+MNXLZImGE89ee4ehVJL7OQ3L0iCn3f3dzlvEJ75hHgF+xlxJXLpaDLAwgTi4icCWK3nMQQsJeuyGXUnMtv8KK6z5ZS3jfXSLtN6UqZ61F6nGGXafoyzPa9sCgtcYthg952Hf2hTlijiNxqzmUnWP/lM4YMedI1NND9dgUrHXLtS9MBBVPgN0n9s1ZWfqUe+NOkWVyVQClcCWVoRJpbAx/q/pAA7QOa/3Z4H8DkM05T3P4E/SneyJ22HBC4EhdePPDqYVT4CcrbhL+miOVrAPbH0bAb7BezEeszRGYEwjJ/L7m7biRgVDd5YIZAOCNXkTwQ37Aovt3AIOTUPcD/0BxO3t18XAsRusIP27panrl5bSJPlNtqsK+mAQoT+pOTcW+U/Q/WZjEBIePiRqP8ekolg7QsmQQ69z6inSO5yjFaFjXfEfq5W6oY1WS/Sbo7GcpCh1RgDZK7RIb/wGqrfj9sQRi1CHhHmxBSMHg9zJPH17PosoKfB6WJ2w6FAErXSB
 CmBe3SjJ
 hS8aUYl0DMTBbwl1gr5IxcIFvdCLZhtu0SDdE8ovAyZDC9iETByPHGUqPn2eLhZNlRYZ6rMwE1+T4YJV/Opn222K8bpYuskrYIfVX5EZmDaLYh/q291bZhpfY3jaMWxHwFJm+KGxN+/q4JF/531H5atwv5IZSZ+AhBx3wflo6znP3DOUhuNV4c/a5wm3PIwtyL1H5AEYbwV0JDNzMWvTILI8NoNJ4OTM8AJ7BN7mpuOT0jkEOd1S/PriuD4V/icrE5UdY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 20:04:21 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> Ah, looks like I need to update the patch to fix this.

OK.  Please have a think about which patches we should backport into
-stable.  Possibly all 6!  And the timing of this backport.

Ideally, split the series up into one series for 7.1-rcX+stable, another
series for 7.2.rc1.

