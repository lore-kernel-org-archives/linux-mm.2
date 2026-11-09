Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E9DE606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 06:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mTDmNLIg
Received: by kanga.kvack.org (Postfix)
	id 8A2216B00EF; Mon,  9 Nov 2026 01:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B0F6B05B0; Mon,  9 Nov 2026 01:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B74B6B05B2; Mon,  9 Nov 2026 01:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5691B6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:22:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D509AA80BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:22:45 +0000 (UTC)
X-FDA: 85414587090.14.DFA02E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 41489180002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:22:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTDmNLIg;
	spf=pass (imf06.hostedemail.com: domain of sumit.garg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794205364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZA63luVCcUm/rcUMYSE6kbch+b4UxpuSVxYdwx6UVuY=;
	b=DUcqrB3l0OZi+4YSXyxjYLWB63WaVuN+11TkWbdKqQgodXUxRmpij+7rPtFoUk1NngDoxB
	iRBc8UeOZfOWHjLp4sT+CT9/FL6kp1htcZ943YJouS1vr74ivwFG2onjOM+ePIXVvvrix2
	u90Q4gIl2XHvpBRUOkWoKlqj4wp1yo8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTDmNLIg;
	spf=pass (imf06.hostedemail.com: domain of sumit.garg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794205364;
	b=UXmex/kVXxj+uCdBgjKo3cwPD6p5lVSCZKsyIkG9g/IiEE5zteV8EPij4UGCSr1D0Y5Zk0
	+Y1niueggXGkbieELlZMLJI6HbAdPcw/ML6dZe8y8mYkOTUoB6PujENcOem4PV5Z2MDagF
	BJhBSUS+h6FxkveLrJ4YVWPXavGhBmU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 786F4618DC;
	Mon,  9 Nov 2026 06:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0B81F008A1;
	Mon,  9 Nov 2026 06:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794205363;
	bh=ZA63luVCcUm/rcUMYSE6kbch+b4UxpuSVxYdwx6UVuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mTDmNLIgFiFwQeKbp4CMfjVX+h4GlITRDvYMD8FO9glhG/g4prrJIRnsH/XA6mrqk
	 KZHT3JCdSldwDf+HAmkYhqyzNX7RIICj9z7FYzjFYp8Fuk/T7pkF0QeXLcG7AWIo9i
	 KgU8apAwsf8d7sKCxaPFkaNvCarJsW0jzSix1Pd0iao0MPfHPCmjyssAS/MB3ULpJQ
	 598v4SkCigLCevg13d7vrUze2LeVfCu9q4JUe230MOAe2131CzkMqCquO+EC35jHJw
	 bvKH9HXR2oRh463I4q+2R4nTIkUhSiLPzN98NzjIPb4tcVpYrgp+nUXVYIHhtubC95
	 40b+tagd1SqIg==
Date: Mon, 9 Nov 2026 11:52:33 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Sumit Garg <sumit.garg@kernel.org>, Will Deacon <will@kernel.org>,
	brendan.jackman@linux.dev, catalin.marinas@arm.com, rppt@kernel.org,
	akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, robh@kernel.org, mark.rutland@arm.com,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <avFmqak7gxqCW3UB@sumit-xelite>
References: <aruh86rd5FMv2i9G@willie-the-truck>
 <ar5TPvANFUoosxGW@sumit-xelite>
 <asOAYODGZa-7EIV1@google.com>
 <asOD31rTX6dNfD1o@google.com>
 <aszdnInyJxLhSQRp@sumit-xelite>
 <as3798SFCfKFirag@google.com>
 <as4ATqhp0bPI03PA@sumit-xelite>
 <auILvMVSXk9pZh6M@google.com>
 <auQ5hCdPFz0BmvDG@sumit-xelite>
 <au2vtZFyfUVWeils@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <au2vtZFyfUVWeils@google.com>
X-Stat-Signature: o65xm9u4hg8gpg4o91r3maefu6bikg7a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 41489180002
X-HE-Tag: 1794205364-19214
X-HE-Meta: U2FsdGVkX19D/eToMXttAag62BeB/GAidUBd1cMA0yUQr7U/j9ac+DlSha+SloVoqNjRDM9kyn6Q3IJQ513V0FL+kP285KkDKFPaM6+M/d3RRoeXRxYI6emYYseHXWgBolsmSKF7Pblygnlct8eE1k+ifBrGGYxyN1piB7vkbd/c1qcRdi3PC2nSmDt8p+RMbCftYdE7oGiS1TvLqqh3OmRcQA7i0PqM4PikFViriYXH1OwSUmtuipyNf5Fo9PfgO+HCf4tdvtJ0nXKqYlWPDCRj6rOdA9UHGXTRRtXG949aqbl0/9XWW6h8mF4nRwsr50ZVxh5U2gVwp3WSg+4a+SUq0LucsaptcroIw+bqTS3FOVm0Uitlr2O15q0E/WrtqXxfGkOSdpWXKxbPRQH6v9lfH7HzQCOhCueEUEaU7wIa30oQ54xGhPUmsZj/dce5WyuefnShHeTLVuL8lY5isDeSM7LOYNC/jfpPi9oTgl+c1FcQemrsIC7f4+uHgxgiDctlMRkIrkh3dcji0jyTHWl7grDHwU5uEF20fMCTj0f4Eww/CIsEZ9Do7LFDr8eD6DV9BSEj8CH2p9ZIGSIDUGEjn/sb8+F7M2m0hRQCcuPoMwLjENJzGBgWPq2djTn7m76nhQ2FIcOik8nw09PxSA6oDOhJP0Mv2IMpj7UxnsNO3j8OThzuG0rMV9V9kXja/tRW+G3MUe6kPeGpJdjgPZ+eXeEZyqKCcgjrRrEQhFaHMx1ruGNS/lqnGcjUL8t+jv4B/hklgi3QEZgycuorObqr9azolRm6v6ALGJjs08hcP5lsyLUtUhfF5LN2s9vPBkojMZQz0tpPe6qr1gwLo/1PtVe20hLd/AKSnZGsTBUoWjn02+AAW3I9SsuQBxwsogRjFoh2y73WX04irYcZ8srEM9FxiRPmlwUuZBdZn/nAFpl+pG1kjzR4tdmHjC1mqblQmPAlpPOiUEnpt0Q
 uPcoUq1F
 39ySAs+HiO78iPAfGlbO6Q0i9qi+9ekAB8AvvREeACV3d1Dho+l7FIfqDoDOsaCSXFbbKdrT1on1fRtWDjRzV1jGXTuklVHP+LGVkw28oI6JaqUN2WVw0xLEj6Sy9nUKVcLpomu2zqzaVS53m5D/JRB4SU9JerQ73Cmfjtgbss8QDYXJ1knnhh3G6yXzZLIlm3FOcZC+3FWya7XzPOhPSUEKH25oYknxJihriQBF27MNoLzJz1t3SmhZ4zQFtoiiPxpS1r/IYm+CVhuqZDfsetF0N/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 at 10:45:09 +0000, Vincent Donnefort wrote:
>[...]
>
>> > > Yeah I saw that constraint too, let's leave it for future extension
>> > > then although having this reordering dependency fixed will be ideal.
>> > >
>> > > >
>> > > > So the only case it would work would be when a reserved memory has set
>> > > > "linux,cma-default".
>> > > >
>> > >
>> > > Let's rather just turn DT based default CMA pool to support PTE-level
>> > > mapping and keep it configurable via Kconfig or cmdline or DT.
>> >
>> > If we need a DT declaration anyway, a Kconfig and a cmdline option aren't really
>> > necessary.
>>
>> Agree, it rather makes sense for DT independent generic CMA pool.
>>
>> >
>> > Also, Rob wasn't very keen on having a DT option for the reserved memory and
>> > suggested to have a compatible string instead [1]. So perhaps we could have a
>> > a separate driver that handles the unmapping.
>> >
>> > 	linux,cma {
>> > 		compatible = "shared-dma-pool", "unmap-on-alloc";
>> > 		reusable;
>> > 		linux,cma-default;
>> > 		...
>> > 	}
>> >
>> > That "unmap-on-alloc" driver sets the memblock flags and register some cma hooks
>> > (to be defined) for cma_alloc/cma_free where it unmaps/re-maps into the linear
>> > map.
>> >
>> > The nice property is optee won't need to be modified anymore. The downside is
>> > the entire pool is now mapped at PTE-level.
>>
>> Sounds reasonable to me. If folks are really worried about performance
>> with generic CMA PTE-level map then OP-TEE already supports no-map based
>> reserved carveouts for protected DMABufs too.
>>
>> -Sumit
>>
>> >
>> > [1] http://lore.kernel.org/all/20260902172436.GB1440252-robh@kernel.org/
>> >
>> > --
>> > Vincent
>
>I have just looked deeper into and cma_alloc can't unmap automatically the
>default pool. Callers expect a valid linear mapping right after the alocation.
>dma_direct_alloc() and dma_direct_alloc_pages() zero the allocated page,
>dma_direct_alloc_no_mapping() runs cache maintenance on it, and the userspace
>available heap /dev/dma_heap/linux,cma zeroes it.
>
>Also, it isn't possible to use two compatible strings for the reserved memory.
>The registration stops at the first matching compatible string. Layering drivers
>won't work either.
>
>So while the pool can still be generic and serve as linux,cma-default:
>
>  linux,cma {
>      compatible = "unmappable-dma-pool";
>      reusable;
>      linux,cma-default;
>  }
>
>We can't escape providing an additional API to unmap/remap in the linear map.
>

Yeah it's fine to invoke these additional APIs post the CMA allocation
for protected DMA buffers.

-Sumit

