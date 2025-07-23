Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22892C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B206A6B0089; Wed, 23 Jul 2025 04:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8456B008A; Wed, 23 Jul 2025 04:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E146B0093; Wed, 23 Jul 2025 04:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8856B0089
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:44:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 112CB11307D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:44:20 +0000 (UTC)
X-FDA: 83694892680.10.645FF41
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8128E2000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:44:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/jQIqzd";
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753260258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nR2553CR9vXMEL5p+7oB6+PFesmCw/0aqEAD4pA2j+A=;
	b=jKslIxfN3G+EKJng5iE8L6qzjEPgH9XMJUBHmzwUshK0InLAxbrP6foouzdzfdAU1GN6kp
	S9RjQCL3zZrpGbaqPzOBXf/vGHTAzMsXHarmmx4S1WotvuoP09IcU8aPCa/He4MCkm7Gkj
	8aB2HNjRdLrKWb+zLpcjq+WKb3le/Go=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753260258; a=rsa-sha256;
	cv=none;
	b=xns4qCpIw4YNqolS2Yujx5Tb60HpRY39D/WVwNWnLyEaPIMhlyf8wec3shhi73tHIq9CW2
	qiD+DVw5kXoLNdOV2mtF4xMUlnDgLYof67uE6W1mdR/N1Y2+RC7TgJkQhtVrGJDtPDonqf
	qe7QgR854eZXbyy9Wm2Vx76dCsLyge8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/jQIqzd";
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id E4377A4B4B4;
	Wed, 23 Jul 2025 08:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077C7C4CEF4;
	Wed, 23 Jul 2025 08:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753260257;
	bh=Cj91CGuGavrB/ilqOlKndjatFWOMgTxiTvWRwwSAyXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M/jQIqzdz82x0nWSTcq4f0buV83Pk0LJSgQODn5pjrmjpwv5oy9a1d8mvYOCYdVOH
	 bdXSPn4PgwRtO9dST3nKHT5TYXR4D0lbuq0VYMy2LK2WQ8tGkqd62MiFZw3E5YA1+V
	 APES5GMOW46WRZWXbPOt0PFGaEfxcmpX5ZU7O9INHYCZGqFw/ylFGGERRmyWD2Q5u+
	 C0riJKs1eAlwPzfqs69FDmjTezmgWk9NwcQbHqxK4y8D01b28cCc7w3FT3bMoQXkso
	 mDdwnRJk7eIzRHR57iMNUzD9DuAxsqerjLb5vvC3jhbdTL1pfEkFX8w1K57J9Sc/r3
	 j+tg72bbOJh1Q==
Date: Wed, 23 Jul 2025 11:44:13 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yonatan Maman <ymaman@nvidia.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alistair Popple <apopple@nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] *** GPU Direct RDMA (P2P DMA) for Device Private
 Pages ***
Message-ID: <20250723084413.GO402218@unreal>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250720103003.GH402218@unreal>
 <35ff6080-9cb8-43cf-b77a-9ef3afd2ae59@nvidia.com>
 <20250721064904.GK402218@unreal>
 <aIBfIxVBR/3ig/O/@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIBfIxVBR/3ig/O/@ziepe.ca>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8128E2000D
X-Stat-Signature: yuqhkypmenk8d6msw8ae51p3tcctm3ji
X-Rspam-User: 
X-HE-Tag: 1753260258-984276
X-HE-Meta: U2FsdGVkX1+8+0Qv8LTA5bXgeM4Dukl8ujir3lKDxlz1GsBaWHCov2eCf5HXmqrytGOgLbnofByTIUnzYmd4vklKs3Iuw7IckEr8mgvxXbbDGUuF5o9zOTA1pk3Nj88xJqoCLtojUnT3iyE23LSr8OBzfpni2cwI8hA0gCJZ4A1Dbn8V00lc/7VhlCVkwsfhZU2VmMX8BEG8TtmEPqQcdLNhrLIpAEVhdEJUtr406kvafApGLW77XPqRh14Mp4kOehxp7mZ17tr+xWZohZhq7AL9Z9BLMu8yKrctccoP8VCGV0gZEYCUjDUK3DUdLxT4DKKaW2WjSqeQYQw81uMaN71PMNW5xY+6JGZggz2Pe0ZpW2KMZWxx9BJikvsxHrgq0jp1XvuWS0+h150B/7Z2fPoifHWfBsL/zYCYiu7OpnE8WsX6itd4B1T08caJDjjBOlc0GRK4Vii7RvHVR4nYYzk1PMKfcF51sMchDQqb3i8U49iFXRFtsn3zgRFLnRVXTTcQq/g6HHUZr7ftllElXEUVLPgMx90CZqwQoGfUmBr01JuwewjMF1culZMkO+vzZKzVt2FFaxnN7LPW1F7E3yWmalumNqLDMh3oiF4iXeEx5cZounaS2P0RmX0mWxHZfWnXdvw2nU036gUznXBsKSpDrgZYR4PB530f5iXO0UZqIfAZrpPVdFVH6UTFgVboNQA9JfVaB90C+Rzh0ZiDjK22AtO4gHTqn/WK47JBNvWVXI19H5qraqnAuJJ8kPLbIYA8QCd75kEMtmE/jneh83iCHfI5dkgLUfuFRTS0o2//rrXXmbdSo9xOVQ+KA3orVXZn3qn2UAcwI6dgZgsYjmiuECfnwyU6d99/lQXwY6lb+673TL46rMH19jj20pRibS8CX70GY+Tpwd3htzgxEB1IQKI68+a6GkCCidbfMXOzX7Ye4GGEwZdfW/nhvusu7pdD0ksAR/NVKIm6vPw
 Y5hjWRYm
 VVCm6RgJdqmQ0BlGAilaavOovKyEmPe9+jT6s3QdWoK/54jnw6NVlTwudhNl2kL8bdSrnkLuK4yoi7NKe+WOD1JBRW4QYYOccWK+v5aaS6jFD93dLaFXj9ZtEIENNc05gltzZc9m62hLLuw8qYRVdGwS0xENGFGB2+lHmKg6B8yXK1ASYgXTMby7tmTaycM9pJmx/N+6xW5En5zeHezV4Q/F/L7sOCu+NC4F9C5EWkXdwh3FRz1dABLziEKq+hlpAeji8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 01:03:47AM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 21, 2025 at 09:49:04AM +0300, Leon Romanovsky wrote:
> > > In fact, hmm_range_fault doesn't have information about the destination
> > > device that will perform the DMA mapping.
> > 
> > So probably you need to teach HMM to perform page_faults on specific device.
> 
> That isn't how the HMM side is supposed to work, this API is just
> giving the one and only P2P page that is backing the device private.

I know, but somehow you need to say: "please give me p2p pages for
specific device and not random device in the system as it is now".
This is what is missing from my PoV.

Thanks

