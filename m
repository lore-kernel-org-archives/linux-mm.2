Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C02C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82EC98E0002; Fri, 25 Jul 2025 12:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF9D8E0001; Fri, 25 Jul 2025 12:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDF68E0002; Fri, 25 Jul 2025 12:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 579568E0001
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:31:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08EB51DBF8A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:31:18 +0000 (UTC)
X-FDA: 83703327036.22.D123E90
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDE14140015
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:31:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b="QwPbWJ/O";
	dmarc=pass (policy=quarantine) header.from=deltatee.com;
	spf=pass (imf09.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753461076; a=rsa-sha256;
	cv=none;
	b=xagim45gUL8lRY5ZpQy6kUNmXM3tG0xbjMtrGMpo0UK165HBscF7FaTxVOHjFkoiUClylP
	6XeW3C3y1e74Z0lr99UKAp+SgUDB77Q+o2dK3kF84wkJHUlV2QIQ6VNXfJVO4+PzEVyyHr
	0jR55Rc6XTC72NML6CQ930WJ/unZj60=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b="QwPbWJ/O";
	dmarc=pass (policy=quarantine) header.from=deltatee.com;
	spf=pass (imf09.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753461076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f47Ky90dFPkL1Ya+qWKSgUqpFHN5ODLjpNudWVSb5u8=;
	b=IH+qi3S9E6ZjEX/toK1kgUJigA8H9Wrh15ZBoUjPyNynAsZAWzoiRgjy7fq3273+HlLfR2
	+xQ+xuyf0DWDXlJj0vi2tGH9VfYQqG7QkdSgq2nZdhyn2lYsgZJKakXBdNp2t4dd1rQggB
	Kw54YpOv2TW2ecUIVUZrTNwyZgex9dw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=f47Ky90dFPkL1Ya+qWKSgUqpFHN5ODLjpNudWVSb5u8=; b=QwPbWJ/OWzQX8Q226ojxfza0WS
	hTwTo6/vPF246VLRi+47uocSVLkOn0eD6rbMZRZD07tT3AUM6z95tZTUeAEDALmOKRCr9SwWCtSWo
	Vl40IAQDTTCjPykxMQJzgZjUrWmcuoWHdCN8wv2e2ot8dxaFvJW7K4bmnXuC/9eazXKfZuuVimmSg
	tGZI0VE8yThg0M2uXVwtlJ46NYkhpaiehvoG18/F/CMQ0pf9gs/S0p4bVOocrwE1PtjveEbBVRg1u
	Kb4oYtEyAdpejHSKoYmOlKpt55+jX9YkR+phKZwkr98AAn+Xl4RiugB4uevi4n7lK1TZ6DnW/l4Ya
	BaSNp5Dg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1ufLJz-006C5W-2Q;
	Fri, 25 Jul 2025 10:31:00 -0600
Message-ID: <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
Date: Fri, 25 Jul 2025 10:30:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de> <20250724081321.GT402218@unreal>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20250724081321.GT402218@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, hch@lst.de, alex.williamson@redhat.com, jgg@nvidia.com, akpm@linux-foundation.org, bhelgaas@google.com, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, axboe@kernel.dk, jglisse@redhat.com, joro@8bytes.org, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, m.szyprowski@samsung.com, robin.murphy@arm.com, sumit.semwal@linaro.org, vivek.kasireddy@intel.com, will@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspamd-Queue-Id: CDE14140015
X-Stat-Signature: qn8519kekj71yapoe74tep6w1tnsimuy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753461075-395094
X-HE-Meta: U2FsdGVkX18Su+ZGMI2MM+2vC72KjGlR4y39ZYgfGmQ58kqojTehmF8obR05uw1hH4sKfMxRY3BsLD7AifGUGA5Tx4Y1gnpZqxWpH7cOxvDlLVcDTmxG6BqgC5Tv4HwSpeSuV6TlIolO3DdUlip58tuJXWq0g6NEMKBTrcTqy84gbrzs6OGr/DhPOYaYKoV3xD3SDEvjKYRpJwdblgQepMsUqJaJawyaGI9HiRJVGQkdqw4kShIc8MGgLpZMccVahmGMJWsybVDNiukukvFXteBAxABG+r7UUHoG7j+iq6RSv1EsSkIMRfmTcnH7Xnkb1eY4y3+cNvBmu9q0MuW+/gtkT42+RSHaMmNksB+R53pXvHbVLXYljIHS0LPnDIrAJ3tyOXbU2XOTRgl2BceHrhzTASeuecwloHcDBCVgoRt+SFJq8DNjlkXVLqMOauDpuO0g0Qihi4bVB7HN5gtW/yj/FZTJARd+ML+pGRWyEAzIVXDbYPplUhepB8KrS+p9W1w3UwfxYSRDQdv3rvGsI9Oqzv/i9iov0+g8ZS7dDd9HM012O/jpANp0Ri61vuwvDXxs3Oo44xzY4kv1q/KdjCmmD8a8O1hrzfIZawZegcze1WS+I0u3bDSM3saqlCBkrVRH4CB1N2KkuTNUbJIUOTumN4Ox6PcciYI0bNlmAX9dg3K+KJoPj18ZKX+ojPcoV0pSPPPakfD5uWqUE1OdKNLg3iWY2L7Uj5VRwEn411NPtxHVEtdTIUJKnDSjCGa6UKjvKm58JaYzQny3Ip/oP2JoxmpzctK3rK3KBSIA/Z6pGpg+0nsp4kA6SN81uYGwgmn4x5ftioSHnOWCxAr5iVSi/MbNiY/fVv5z0OtQ8Ck/6LM7sA+CfxFGZeDBbUOu+ypeCow3Cj3kmSzbswu8m2YpG4x26wvOGcgZNYriGcveSLHBAezYLRbTk7jdabVeb2MD9w1uDI51Gnj6O+H
 IBSxXOjc
 jKpIwrR5UjVywlEcWAXSEJsS/Ki95lVG7iw51bRjX52/CMozVWSxdq/Wa+svOcC3TENzvcdzoM8lSHMmhlCxgrVRy8pEDDgWd4hdee1GETp2ks9soVfm+VjPjfRVUq3hh8fCBMXvcVDrOknlcO5IfsVGm72Itz58OepgB+VeC8TnZRXqUlh/zoPbT1BgdoKFHw8am+oBzZhHeR9sTSL52pupJjyBau+p3SEebWwnPKR3krdEoZgduCBx5hVRZqM1IvTpCnile/RtHbLhScxRhXqafoknEEEpaDeBfnJj8KI2EQGbj1rWRAgNvVwXsG6t5R5S+8YXTrLoGIny6EEUZTf0L9kc2plrzmc2AWMaMXIJFEOlWIUFf/sYhsc7elRuZXWcNaKqPaakPphQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025-07-24 02:13, Leon Romanovsky wrote:
> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
>> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>
>>> Export the pci_p2pdma_map_type() function to allow external modules
>>> and subsystems to determine the appropriate mapping type for P2PDMA
>>> transfers between a provider and target device.
>>
>> External modules have no business doing this.
> 
> VFIO PCI code is built as module. There is no way to access PCI p2p code
> without exporting functions in it.

The solution that would make more sense to me would be for either
dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
P2PDMA case. dma-iommu.c already uses those same interfaces and thus
there would be no need to export the low level helpers from the p2pdma code.

Logan

