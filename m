Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB089C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C016B008C; Wed, 23 Sep 2026 12:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD4D6B0092; Wed, 23 Sep 2026 12:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE7F6B0093; Wed, 23 Sep 2026 12:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA4826B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:29:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C986807D0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:29:10 +0000 (UTC)
X-FDA: 85245561660.29.83B4CBC
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A44280003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:29:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=lk4iTPb2;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf30.hostedemail.com: domain of kameroncarr@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=kameroncarr@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790180948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRx/KbW622lc9oNGjU0HBG2ucuK06pk04r2BRU2Rs4k=;
	b=yHE2Wu0LiQljAxntRsmLJOh5mgHd818oCF3Kb7hSgIhzxWpbntMXri49HZapbM6jfiYvi0
	KKTqg+MIyaF6nQ1MJWGG1fdknN8164Mjh88Np4201WiVfkQSa5hzeG9jHy78YNl2UmtNl9
	wXeOf/+QiXBdeIpWUkz7S5nXFGUweOA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=lk4iTPb2;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf30.hostedemail.com: domain of kameroncarr@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=kameroncarr@linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790180948;
	b=I1cRqpjG6PiplghP+vZypg1Xv36YSTZ0swHjZzmCLupUrz3n2UFyBGtKRqdWYh9wO+nKBk
	7moAEfNDVuR/UxM8/chN6MPHj1AMr+uZSqNklyK1XCt7F/m0z4nkOuhuq/s3fMeobKW6E5
	7b5+5i++LDI3Hy0hEtoX7xbiTGl9SBM=
Received: from [10.4.158.9] (unknown [4.194.122.162])
	by linux.microsoft.com (Postfix) with ESMTPSA id C049D20B7167;
	Wed, 23 Sep 2026 09:28:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C049D20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790180898;
	bh=zRx/KbW622lc9oNGjU0HBG2ucuK06pk04r2BRU2Rs4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lk4iTPb2Y7uutncKN/+j8ht7tPnRTZ6o43sCv1igw+EdAbkap5LleY6qa51nPpFa6
	 oFrn4wb6BHxvCgReQsk80Yv5Gq+s/5rQRHwDalOdArIoH0GTefNuq6TyY2rgXsVOhS
	 gNMu/nMv3dX8EIbRcFZTUFCIb4A9JF6t3XJZs7Dw=
Message-ID: <5cbe0bde-47d8-41ca-b244-bc0329d0d066@linux.microsoft.com>
Date: Wed, 23 Sep 2026 09:28:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
To: Jason Gunthorpe <jgg@ziepe.ca>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, mhklinux@outlook.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-coco@lists.linux.dev,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, christian.koenig@amd.com,
 Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner
 <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org> <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org> <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org> <arOspFxWZ1DjgcAr@arm.com>
 <20260923130611.GF1540250@ziepe.ca> <yq5atsng10b2.fsf@kernel.org>
 <20260923152124.GG1540250@ziepe.ca>
Content-Language: en-US
From: Kameron Carr <kameroncarr@linux.microsoft.com>
In-Reply-To: <20260923152124.GG1540250@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7a679j8ytzn6geptfcum5zuxwzsekcgw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A44280003
X-HE-Tag: 1790180948-124352
X-HE-Meta: U2FsdGVkX1+lKQa0ScUV9TJqxPOFBfGmQ6CNAs9Hzaa1GR7YgtpBSmTVRNDSnoctWMMu9lIZX6HkQa+JobuWKRoD25jVwPlIZw90JkgVZCND7tvL9TpKzWjHOch6Zm8kna/QH90+ouDfmFfI7NJ/kSs94Vuor2lfUR6MzK7nU/LVy2OdrF0sSlN66ISrp+y4CcZEIPFgKna7FwtvyadwY8XVbweITtVVaXcg9khw3puTtNuGpI34qQo+MvLqZFIoHCfJpBR1cwJkzSbxhr4EKD7sQ8IiniewTtTTAUxoTTYLDMiZS8sOUT7+o2bldx6Vmd4r+4QptDhYadJH/OhP1lg1UK/XCTSnQfLRKkrrrYC+QIK1a5e1e7D1mwlgfaVhZd+Sy2lM0Rw9tKZ5LPb4LQ99BT3tBgqYUsvSlp2WTxSialtSPedUsCZSVk+4F8xtzqSwSyfBYyiTN04gNRt2YjaOsozTnlg3JBTcvAACHHHc4F9yf6dYPuJOF6k7YXs9SgPPT3sP4lfD50tzp2PBKXvc05hooNCdM2jzJUEvzUUTeaQCt5Yihg+YxjQISC9HHb7UkvtikZAoRQVlyd2QApS6v6nz9XcFF0Dwr6aBHhQZ1ZcZyFJi4kdi1YjPRuv8BDhW9Z41o6LXfebekH9SXKDRM16z4jkhvxM8bD9un0LdcH+HIrgR6hB+GQyVZg9WikyE2o7H1wStpmB5TTv7a+LV/0K6hIrHcsUbScCh2ekob1WN5x5AuDRekw1XwLoB0Zt7dB6v7UarBXuqsHWW1KQlxkBkcMXyc9qTMc2m6fCK5rtRhSW7uZ6KjMdLWHI3XNLjB2C9IuieVXPXV851dB2X4D7qtBUrov2apQ7v0lFvy9xNEaCJRFKZQ+Cw3ZjrcjZc1/Ac1/U67DKk0x2LDb7xvyOPvuyoNBF1k1hkavxvdnknmunP0GhewenSjyi2bwCq+mxfhFh4d4l7MUk
 w1Ob0pS6
 4z9lcLV9BQ39KjRdVjyldtQNKpPfWZ0DjEwhu80ij9nNnp9KLEwb4CX+scZy9tFpuyFkepA17ufWB8iAUOUdR0rUS9/RuB7uJ50x8UWkwd1sF8EOOyT2tSKpOxQTSa1aF3l6AQMpa+EFCfqOKlCZUy121dK8V+npYknv92BATivHApf9/vSVvm+NfA1oMvNyouX60pHl9UqJgowFj81M/Ie34s8E1qedNNBcaWp+ulnUs6p7aFh2GzWmLWkwKqL4qwXQXlnBFOadg73Eipxhxw9VnE6WuLKnk3Gln6z0b2UVnNRGaVKtZNxyfzcyag5oXhuIve2R3GK3U6ivp3WaZOEBi2PVRjlVwgKuhIZwlUxiwZmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/2026 8:21 AM, Jason Gunthorpe wrote:
> On Wed, Sep 23, 2026 at 08:28:57PM +0530, Aneesh Kumar K.V wrote:
> 
>> I'm also considering requiring the address passed to cc_make_shared() to
>> be in the linear map. This is currently required by both TDX and CCA,
>> while AMD SNP appears to support vmalloc addresses. The only user of
>> that vmalloc support is Hyper-V VMBus GPADL setup
>> (vmbus_establish_gpadl()). How should the generic CoCo shared-memory
>> allocator handle this?
> 
> vmbus_establish_gpadl() is the the same wrong abstraction as the arch
> code. Get rid of it and use vmbus_establish_gpadl_caller_decrypted():
> 
> 		pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);
> 		if (!pdata->recv_buf) {
> 			ret = -ENOMEM;
> 			goto fail_free_ring;
> 		}
> 
> 		ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
> 					    RECV_BUFFER_SIZE, &pdata->recv_gpadl);
> 
> 
> So you made an allocator that returns folios, now you just need to
> use that allocator to implement a kvzalloc wrapper. ARM can call vmap
> on decrypted memory with pgprot_decrypted(), right?
> 
> Or maybe this can use vmbus_alloc_buffer(), it already does it.

Michael Kelley recently proposed [1] moving all ring buffer allocations
to use vmbus_alloc_buffer(). If we move forward with this, it should
remove the dependency on vmalloc support.


[1] https://lore.kernel.org/all/SN6PR02MB4157B71CAC1433B04B92B700D4832@SN6PR02MB4157.namprd02.prod.outlook.com/

Kameron

