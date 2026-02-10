Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22230EA8118
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC0B6B0005; Tue, 10 Feb 2026 08:53:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459EB6B0088; Tue, 10 Feb 2026 08:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366556B008C; Tue, 10 Feb 2026 08:53:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 251186B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:53:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE7E41C13A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:53:57 +0000 (UTC)
X-FDA: 84428690514.10.575D61A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1B117A0009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:53:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vDd/q0az";
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770731636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cx2qFC8zKSktmx2f3TdcwYh+PzGsWeNescQ9pa/hiL0=;
	b=tS68/oynpvfgg226S6HEEy8GJWvdSo1cEeZ2vLx7ksGEVNPdG9Avg82rDTbK4SCSlTGqQ6
	sSLvbRh7OMdtUNRtgUntr6szIrbHOI5xzofvb//TerHNgMTCiUYvk0DCvDwV9WtLToi3pz
	bNR8bPbLhJXuU+MVGr1GNV2FeH4s5kg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770731636; a=rsa-sha256;
	cv=none;
	b=JH5EgIqKyquSEc1YB5nIgTa8a+thOqw4CeqJEghdPX2GegkQL2EAOWZp5iakZubvYvCGW3
	6NQdl4vh9JwW8v8NDZStwAvM+4I5M4uyB0JVU0BeT7EoLAu+fsCumtP/pUqraOTKrEYgk0
	MxfJukaXVd9IpiiKNsK5h0NN938xlU8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vDd/q0az";
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 230A743C53;
	Tue, 10 Feb 2026 13:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FBAC2BC87;
	Tue, 10 Feb 2026 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770731634;
	bh=VjfuewZzYWww0CFJ55+XO3WsL/dZMjCPGMxVFhP69TA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=vDd/q0azdMtrp2hKtDQkpUaA9emXt02SSh7+uAg7CkpQJk1RE3gahzbaGsioInj1p
	 x7WJ1rPOuQyw1aQfAXLKw+brfi4W4qFZw6Y/xB5+DC66567PDhAYMiwJFiOGSMfV3n
	 d7QuxkkYNLvVmuk8EzCaEHAmNYk6YJiG1L1N4e/QG+NZkbBbWSpwtkZd5vImwdQJFx
	 QpOktu/gxks+TfF96NyQq/n2BihpMTOVQfaBpfUYSPHLJGegZHwCsdNWrypoaOSbnO
	 enWdJBd0Wn10LU/ZXuSRfbCPw0f8Ua2BygD1+kWCSc5WKthVKRxoqWdPd6/zS8EGU2
	 WO6dD/9RiQ3jA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Hugh Dickins <hughd@google.com>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Samiullah Khawaja <skhawaja@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: preserve file seals
In-Reply-To: <20260210131307.GD3076640@nvidia.com> (Jason Gunthorpe's message
	of "Tue, 10 Feb 2026 09:13:07 -0400")
References: <20260123095854.535058-1-pratyush@kernel.org>
	<20260123095854.535058-3-pratyush@kernel.org>
	<aXYGkb-QtYNaWYw4@kernel.org> <20260126183115.GU1134360@nvidia.com>
	<2vxzseb8u4kq.fsf@kernel.org> <20260210131307.GD3076640@nvidia.com>
Date: Tue, 10 Feb 2026 14:53:51 +0100
Message-ID: <2vxzikc4so0g.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 1B117A0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5k5zbnrhf3w1dh3amx5cgbp1et6x84un
X-HE-Tag: 1770731635-703308
X-HE-Meta: U2FsdGVkX195S9rTjEiRVwdIbkP5aiGNd+6giF/AS80bpWBh9C2NOnaYSc3lUpW8T5KK9H8f994K7IaKbPj/RX7RHcrsI8GOSsZGhNYS0j04PHmnuPDTnN0k4P5SlJ22GcV6MOiCsCwY5qxUqVOir+k76K5kXU28OeiNYe5lclo0fVln/B3KaPX84J8DtewJj2iQ+jxcpMWehq4ZXgaOiwprWt5PXYuWK1dfiirv8tub05h3+c4kJmoYHYt5+G27cgN5CVGlwKdXFRllb6Y1iWDY5aw2XyPhowiYE3yB+f9K5W3mv7nIn6MBM9C1/w6iDMwrIgMCdYRIfyzURm8sxDxdRcVdDxlAGcIJICDSSw7UzoiYFQdRpQSFEVLNl9d15JfGbD084EZ5oGgs6Udcl09kulCP3xmm6E9nuqgO5QlsLLW1xV+jm0X0rVobNxv2GXTIqtXvq8xdqNT/Qmud6UQq8CS8xWFm5fcJW4Q3v6bdoU9MC33QHD+LozUg17DzMxE6RiZJojcjv9h4MIBFV/WD/4ICi33NUX895wgw4cq/5mQQLAVfCTd8dWNsuYryx3H3b+H2VFTuhBBpGrRWSbWhXVlmRZLIqz69xHF5yaJwCHwuPh/GN+owyKZNk8a8kSOTGRYPa3OtLwQOTVU6DmVwu+xOSPOi7oiAzTkJPb2g1kRBbnsUBKb3bolKYRHWKrkYO6itRg9O/HQK9tKpRupq3lPmNA/Ph92/WTcceOGDrpfO0M2/7PY1taIFo4uGXJZesBY2aDlbd5Ixr1IqSs5ZNm3Xb6kcWVuj0Gk+dGpAGrhNeEPBjWOx+cAk8hPcr7hnpAKeL32HcFRt8j/1QJ/G7z9ROHt6yWVkx8Y87thMChI6ngZszJ90MUEBMA0MMIcdsOgMn1eh9ixr7sMgW5Cf/kc3B9ag0BwUl4cIGL26hB0FVoDmvIJYGlaPD/8ac7P8FBNK9CvPMCcrgw6
 j86orOFG
 NrQ8EixwzxFRKgUp3hCORhT7vRgL5+ygM6+d9S+EraQHLfrxnJKMmTg3ePEEzH+QKrdqG/Po+fJl5mbQjrNSzGL9AyBTfmoYhjdr59BSLTeN31so2HnU+ZFhN8glDA5Wrb3S8WjccGVn8FaKSgoDWbjgzCSEkKZGSjjS4f7wtmjDtkTnCI/mUFtcME9YTpYh+DKc8thai6GPWJabywnHfU3r2Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10 2026, Jason Gunthorpe wrote:

> On Tue, Feb 10, 2026 at 02:10:45PM +0100, Pratyush Yadav wrote:
>> Hi Jason,
>> 
>> On Mon, Jan 26 2026, Jason Gunthorpe wrote:
>> 
>> > On Sun, Jan 25, 2026 at 02:03:29PM +0200, Mike Rapoport wrote:
>> >> > @@ -67,11 +72,13 @@ struct memfd_luo_folio_ser {
>> >> >  struct memfd_luo_ser {
>> >> >  	u64 pos;
>> >> >  	u64 size;
>> >> > +	u64 seals:8;
>> >> 
>> >> Kernel uABI defines seals as unsigned int, I think we can spare u32 for
>> >> them and reserve a u32 flags for other memfd flags (MFD_CLOEXEC,
>> >> MFD_HUGETLB etc).
>> >
>> > It is a bit worse than that, the "v2" version is only going to support
>> > some set of seals (probably the set defined in v6.19) and if there are
>> > new seals down the road then this needs a version bump.
>> 
>> If we are running say kernel X, then X + 1 will always support a
>> superset of the seals, since the seals are UAPI. So it should be able to
>> handle all the seals that are given to it by X. This only becomes a
>> problem on rollbacks. Is this what you are worried about or am I missing
>> something?
>
> I think you need a check at some point only permitting seals that are
> defined right now.
>
> Eg some future v7.19 kernel has MEMFD_SEAL_XX it should not be allowed
> through luo until the API is bumped to v3

Makes sense. Will add.

-- 
Regards,
Pratyush Yadav

