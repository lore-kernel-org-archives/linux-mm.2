Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6CDB606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUA9dup0
Received: by kanga.kvack.org (Postfix)
	id 0C3046B05B2; Mon, 16 Nov 2026 01:21:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074706B05B3; Mon, 16 Nov 2026 01:21:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5606B05B4; Mon, 16 Nov 2026 01:21:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7F556B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:21:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41CA4808BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:21:28 +0000 (UTC)
X-FDA: 85439985456.14.7AD91D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9E08020005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:21:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GUA9dup0;
	spf=pass (imf31.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794810086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGtf5qEhwHANt9S2IldNkWh18GQwYTwsu6dC3M4N+D0=;
	b=wZTh5eExTZH97TTLZrXI6YWXpj7qg8ldHsEGc8mBtwc/W9C1ssA40bdhSdaXMCsmtD+r9g
	Tqi7EqBBGvsKmE23s1Ux8UICsyKS6QPzrgAaLFjkDurbz80xJ8U95RGVa3kxvlEYH+1WNP
	HrnmkAFeB09NmZWn0esBE7PNqqvPYFY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GUA9dup0;
	spf=pass (imf31.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794810086;
	b=6Y7PL4M7lqMrtM186gnvscFGfV3OIDsiva/wvGZBO7RZvWKt7KppZtbkHnYEVpFZFWCxSQ
	u9W0rl1FP8C6ntIMcIEBnRMPi0ULRlmLBR6/vN0JW5i6GgpXZnA+UT3xZSELY8UkdseZPo
	sLAR+aiW8pV7UsReAcItncs92FMjHt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5367861CE0;
	Mon, 16 Nov 2026 06:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBD01F000C4;
	Mon, 16 Nov 2026 06:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810085;
	bh=ZGtf5qEhwHANt9S2IldNkWh18GQwYTwsu6dC3M4N+D0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=GUA9dup0fJoWa6DD08lCGejGIeihAF7ZTATO3ZR3GPC9cXgSEgzzlNqI3pfVyB+Hi
	 qgCm0/gPhdYZphvuSbKs+NCpccVb1MGhx1DwDVRPU4MBuP6cl5DOGzk0ZieQOKFUXx
	 HBIrWCyjk6fX/0OhKhYhW+ksoU8o+0btHpkKE1PIVjv1lAVmfS1vX0fOyWs6baK0nD
	 AtaKkLIVR99DkhAuobP0HpDKOgFbhS11Ma/wyrhb4BcdfV2PeCJwKwso2a3p5N7nGU
	 Y7QTRkaB25YaqZHggv2zPj0b/6uLh0Kl3D/sWZOvcPqGSpmLlm/YIThrsBaw7FT7Ly
	 gr4xBUww9w8ug==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
In-Reply-To: <87ld6x8zb7.wl-maz@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
 <86zevn1c9a.wl-maz@kernel.org> <yq5ah5huoteu.fsf@kernel.org>
 <87ld6x8zb7.wl-maz@kernel.org>
Date: Mon, 16 Nov 2026 11:51:04 +0530
Message-ID: <yq5apkw5xpnz.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: icewsiyg9wfeyfxmwnpqd1k5hr9om8g8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9E08020005
X-HE-Tag: 1794810086-381959
X-HE-Meta: U2FsdGVkX18VeJ3jvRBw9DekfyssvT58+TseY9FfjKqMrorlu7zx5mPkbSpduuZZ3SLklNoc0FlPXim/GjygOu4bAUyaforw1mTkQ3vFU/peVpXbKtplRL3gOKE3VfLhFBZ05B3Pa5Ao9GiqiBfZQ3e9sJGm386ttkHxU3G/27wf0XLUMHp0UdsvhCbqbLLlqiBGmyQD2m6sSkPPzKx/9FDXjkPlBZ6LPOk4rZIf2pX7GnNlfWe/4x8yfJaxuAyAHqNFlxy0F5X7naVbZEpL1QuM0kfvugq3Rud2/9kqL1Qp8ODKjHmrFXiIILD9ev5ibCqlNYhenZbWZq/fmvDMSleazKkJAv03PGZ7eqyDRj9JL7F7gjiUgU9IDMojlLU/tWUdFHgT7jrDlv42ARVHNUCtqH0eWgC5ffRomb+kvwkLRa1V4NUWkKTMerXDkqfD2jrbxTMH3X2yRX4bjHxq0HLAvsK2TBrJhjFY5NNAd62viUNrSC9QX0IQtgdtQf4VtsgbqW0dUl5w1nabv9lU1oOOBqhESCVjF9Hq2X39LZt7wF780mV63icVOUXoTJF+q7Rzzm3TMfNC+C5HTZAF+uka1cNVLZFnaFJ2PdP9dDG81flDSiwqRtmgfcY/crC2M7D37UuoNhu3Uhe7tJm/JvFV5wLnF+OWwUzptI0soo0OT4D2115M/lwuLbxIJ9+H2ERjGQk4SScwbURjzWPnoNWtn2njNgz+BbhOSrLywMSBpxskwIAW0K36eKaLOyXi6lfRmBFg13Ir9TYASrkI/7yMZH04EkCZ7o0/Jeir7/KBpni5RWfhEZZ/cSqDfohVM8k0o5Bb5AgLEHU4etqIYJwslwHyTRT2tDQO6bIuFyQttvDM6zLURFor86R9kRG3TAwEzog25G1wksP9oCxa1FuA7h+Z56SJkmauw3iXwgbeg4mA2MIMi6hRQytxoL1GpB5VZ8RNZTQNRTKYY3r
 O4Zonr+E
 DYXbgt8CYU5c/sdkCaPNsX356cWoxdlzIoUfNfzKLeMCqu87PfTya69TicyZY984FKKie5TIAEvqR4KF4UdZ5PJkjj1lbpRuNd9LN2R0syknbuW5veS2R+jrgLCeL4bfMVZb1DFFcPFSIzkxSZAdriFBzk3U9KUWtbr14lKtZ8lfgATPu1W1bQ/UQJLfwEnnoynjl7upyopviXAD4FbigMsmQVMz6/YditdwaZBCvlBIC87cvp/mq4Eobs7N+FTusMDuBPKxLn9WwRJtDu0vqNvB65C2hhrefE/NbrFwz/a239+F0inQ3+hyUl/jD30KRTd1A2EwKZX+Z6o+Sn8M+G+KW4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Marc Zyngier <maz@kernel.org> writes:

> On Fri, 06 Nov 2026 15:45:29 +0000,
> Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
>> 
>> Marc Zyngier <maz@kernel.org> writes:
>> 
>> > On Wed, 04 Nov 2026 16:45:55 +0000,
>> > "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>> >> 
>> >> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
>> >> not allowed.  Remove the page allocation from this atomic path.
>> >> 
>> >> Use a blocking allocation for the boot CPU and record the resulting table
>> >> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
>> >> stage for each secondary CPU.  Consume the preallocated page only when the CPU
>> >> cannot inherit an existing redistributor or ITS table.
>> >> 
>> >> Reclaim unused preallocations after the CPU reaches the online state, and from
>> >> the prepare-state teardown when CPU bring-up aborts.
>> >
>> > No. The way to do it is to move the ITS probing out of the
>> > non-sleepable CPU hotplug path.
>> >
>> > I proposed a potential hack at [1] (which I find far more palatable
>> > than this proposal), but the real fix is to probe the ITSs as
>> > devices.
>> >
>> 
>> Could you share a bit more detail on what you have in mind?
>> 
>> Are you suggesting that we create a platform device for each ITS and
>> initialize it through the driver's probe callback, while the rest of the
>> GIC initialization stays in the existing early boot path?
>> 
>> Would that mean the main GIC is operational during early boot, while
>> ITS-dependent features, such as MSI delivery and direct injection, become
>> available after the ITS devices probe?
>> 
>> Is that the split you have in mind?
>
> Yes. Then once this is done, all the tables become normal DMA
> allocations, for which there should already be adequate support.
>

Thanks for confirming. Can we handle the ITS platform-device conversion
and the switch to DMA allocations in a separate series?

The existing VPE L1 allocation path calls set_memory_decrypted() from
the non-sleepable CPU-starting callback, even though
set_memory_decrypted() can sleep. This issue predates the shared-granule
allocator changes.

Since fixing this properly needs a broader ITS rework, can we handle
that separately and drop the preallocation patch from this series?

-aneesh

