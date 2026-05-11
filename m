Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA84CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422986B00B7; Mon, 11 May 2026 08:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3476B00C9; Mon, 11 May 2026 08:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9BF6B00CA; Mon, 11 May 2026 08:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 200026B00B7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:06:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8886A06E4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:06:28 +0000 (UTC)
X-FDA: 84755011656.16.16F9314
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 25FAD4000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:06:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q84m+u7F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778501187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YHTA1Y1yfstf1VS88i/WxtTnRtrqsXvhH2dMssxuMI=;
	b=CG4Kk203YLFb7FCPbNqZJLBcUk/UEysRMm8CNY/yzA9t89FaFF69+r3Fq/pR7LIQ2tMlsQ
	HF8ohZ8LkU+Itnu4s4i5oUdyRO+Hr4PT+mtab7yJ8y68/Rb/Em0sdsmiUwZKebfMs/zi+b
	S9pyB9mI9JIKpArz4k3wvc1x/KlMFs4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778501187; a=rsa-sha256;
	cv=none;
	b=QRtJQOmo+Vr86lPN3FmAVPYld/emQTIXfle0V4ZX9dLdc0800GY1MN35WCG1+wHmVEpn7C
	eXG1o7q5uBYa5dwypNVR6av837CKnFneud13JE3n2dKusjo5O9ptmZ+EbWiPcWxK/PiIin
	pnthJGhYwwBFLb9Sid8mQjVgnf7Uis0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q84m+u7F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 98C466001A;
	Mon, 11 May 2026 12:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79730C2BCB0;
	Mon, 11 May 2026 12:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778501186;
	bh=lngDUFP4KgpPffCrIS4q+IK7DqwfawlMa55S7VcjFes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q84m+u7F9OyKhYoEEUc4C9Ew/QoiuZLPTbqwk/qnqW5tIwrU6Gj2+VRJqRsGG3v9F
	 6vpaYhZ6wGUUdvrcyV4OpvHA5bLUIyECCVmBHkf0xAOqIi+h+dDd0Bvzd90GIAXl5O
	 IxZtDm0koUYaX0s/DkAmB2a1ObH5N/SrJFkEmv2Zvqw+hogYE/j+h2DXi7kyqCv7+H
	 SnasqQphKIfPMvHfBDsFnSlnbAcahFpOBSI5VYphM0BINXwR/s3otJJYtE+1zuZSbk
	 DXajYNIEnH9qTZWgpE4jhnefZ1sFeiHhbA9mFRCqMRej4rsQ1JpsrRLem/PYnU7ztu
	 RaxM+cl65AfcQ==
Date: Mon, 11 May 2026 15:06:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
Message-ID: <agHGOxSnP_VraH1M@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-10-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-10-pratyush@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 25FAD4000B
X-Stat-Signature: wzsmdbjdxgsdzysda5g1bze4nc48fa6c
X-Rspam-User: 
X-HE-Tag: 1778501186-434353
X-HE-Meta: U2FsdGVkX1+uYBho2396r3+T8pPeR8GC7OMU4n9Flosx+faA8AgtwL3E9ByxXTyVW5Tu6vXvoINqwy48L1vupyRg9FXKTqYot1UCq9kc54PMd1K+fmG36UG9RKIibq6K1hIw+VPI4ruSQmHB8mSocQTI4VEyiH7I5lkpVhpdPo+6G41UfDfZ8geACULQ6gkOzUxBWRw3QaET3mrnU06O9Du34ZTD8H8Kkf33nf1CWKAsGVsRQUbsJmsyxVRShu0vhwN7nZIMyKmVK22SQIDafV9ZnnruNVEPyVUroSw+dwHGVYv7SXaOUzzoyfmPFYTvpGZXXgXDARSNLIBlmMwA/wCI5rGJUEif0wYq/vpiKNSxEqLeG6vS9/mnk4mf1nc57k/wFPha7wsSY4clvAAbO1mHyQHP3nNwWZW/OSfbLwKrxCA9BPHztUrYi00Blj5eXETqbSHMBaN1abN3t6ewE8KncC5EFtuFiZ88hXirNfF03yQnVB5IirHqQCrt/nZvSnPcXFh7HvoyMaxRjHIQFtvKiwxPlqd2J2qeEIqo4GnUzylYRVJqOb5inGLy6unr931dPDxN0P0guxIqPsteSlSFs2faPXiA99H2Xd5v9w0mviIFu5o8LWpaAzg/aIvR2/N0VoITNrurxvfNPCq4yPtYUMI9j79SuO31871W2SUYk8gbwRnhis6vMEdPtzGnZ3Q4cZInn80IH1tZiMzJCr93N2NbzAh0UcNVg3RNx8qyqd0Mh0eqaSPQ7ZPaK6RXWLQVg5Nsj5LvZ/qvQ7GBy/jH4VCccY1TqOtPuJCe/JmBCqB5IpR3mLgxF839RiOnLbDS91m9qcfiq2MWXdxo0UDeyXLGkcrDp3xZtZAIKnGGneJRMG+n+5PEAG4ZkzcB3TzTrsRc8zuWESYJXVaxdjm4IC/9ItTJVTrJl8Zc7nPs1S/S1F+3vIMSygSAL+AUtMy4UHVhUvZW44V0Rgs
 gsmWXa47
 e78vvON3v6KWARGXMZcQZOHTtHgrK+XXU6DTB2toZI6TIqh7ucrEcFhhYPCJ6Cjz+KPdgCH8Qfv1SxS/+ElNJWgUC5ATuUDsQXAAiwrxpKzDWhjNPQKDoR89qJ34HuwluFDaO0HaDV14ZC5dBAt8WNFqq75l4+9qVWU2jbLJqbeevbxQfAzsgAPfXYFHriv6IZbab+C68JzKArVk1I6/44szwNWQjnI8gk45Mpgef0y5mqT1z1GkjVBuFIITy6WGMrhE03q4PSO/A4RWS44cT8zkAmFePrlekQE6l1qp+2kmKmVzH4w8VZ6o3A8HgBZvHKIwI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:11PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> In the upcoming commits, the KHO will learn how to discover free blocks
> of memory by walking the KHO radix tree. It will then mark those regions
> as scratch to allow memory allocation in case scratch runs low.
> 
> To differentiate the extended scratch areas from the main scratch areas,
> introduce MEMBLOCK_KHO_SCRATCH_EXT. Use it when choosing memblock flags
> for allocations during scratch-only. Teach should_skip_region() to check
> for both flags before deciding if the region should be skipped.

Why there's a need to differentiate SCRATCH and SCRATCH_EXT?
SCRATCH (I still hate the name) means "memory memblock can safely use for
the allocations". Initially this memory comes from the reservations in the
first kernel, but if the second kernel can find more memory to extend it,
why that additional memory should be treated differently? 

> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
> 
> Notes:
>     Checkpatch complains about no space after MEMBLOCK_KHO_SCRATCH_EXT in
>     the declaration, but doing so makes it nicely align with all the other
>     numbers. Mike, if you'd like I can add some whitespace.
> 
>  include/linux/memblock.h | 10 ++++++++++
>  mm/memblock.c            | 41 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 45 insertions(+), 6 deletions(-)
 
-- 
Sincerely yours,
Mike.

