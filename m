Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C169ACCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 17:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3938E0011; Thu, 16 Oct 2025 13:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C358E0002; Thu, 16 Oct 2025 13:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0ABA8E0011; Thu, 16 Oct 2025 13:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB9E18E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:53:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E94F1403E9
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:53:15 +0000 (UTC)
X-FDA: 84004723950.03.15F9F64
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6145DC000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:53:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760637193; a=rsa-sha256;
	cv=none;
	b=iaPPxNxJqNH/r/QPGmlXqaqvBoHYWoAknnQOLOLtqyh+10U4Bulp34ImCAEo5TliiWCkWq
	UPyzQo3HmqbUXXrbcIu0W7VrcgHIBcp8nHygP2kiPd1MTUa+HNdmfmRSxn0U6N+fr3rrw6
	/aa9c9xXBHO49plKFGCcwOWS2DKtxzA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760637193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jAu83oS9gzp7sau+oXDcn142g+i1nN58RGSVbFFjb+g=;
	b=Bzps2xloX4caTWwa4AH5dqiimxvhDMRjdQpAUviT7yM8Se1Y1YmoBexQ8R+3cZD0zDI4i5
	TC5XzhHAjNSpGzJZJ+iPA/AlPpLCeMlx4S+tfojAU7JhCBfBI5CoehtRWDQ9C8FSXNwLow
	RuAL3y8lmzorl3eImh7fivETVDzxlXs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66CCD1596;
	Thu, 16 Oct 2025 10:53:04 -0700 (PDT)
Received: from [10.163.66.205] (unknown [10.163.66.205])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 612EB3F738;
	Thu, 16 Oct 2025 10:53:08 -0700 (PDT)
Message-ID: <fe84f148-9bfb-49f0-818c-071835cabac3@arm.com>
Date: Thu, 16 Oct 2025 23:23:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Liam.Howlett@oracle.com,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6145DC000B
X-Stat-Signature: 5wjrxbc1pos4seguxn3jnwpophxxj8hx
X-HE-Tag: 1760637193-925557
X-HE-Meta: U2FsdGVkX1/D8C40e/dWFG50k0NtyCysBN18YYHVRegQyrMzq4COfPrpiz6FMIRsX/VZYp7I3RnZ+yOJJmodn3QmqEJ0uJ8HAB1avjDclo/F0bOJYDmf4WhXBNRx5UTYeOK+8+c0bzrtv82oIZncWoKOUQZ4Z4pHs9xwKe/nFS02wY7BPydcib6PQWhTr4s6LlOkizL0JlgC3Q98IQjQwngyMaKXqNZjBOvdFByicggeUUeNPQaYEXNMSYMgjmhpn3OE0Ex1iUFg6Kv2zkloRA0MbEba6CaSYBAop6aAX9ibk5NHcoWvZsD74ND3bAQhWt1OXXet9a8buBg+w70fgbuID0KIys5JnjClX7qDAjWdKYVOW42iBe7nmGDHHjmpj3ediFcLFegYKJV7XDhaxU9/RLRF1VUo5B1jLFOnI/+VGyW5ZF8wB2/HN4ghSzK+lY9G7DtqEV4XKkjdIkB1vobJvFAwQLgy3yd8A0rYw8eMN1MX1ZOFDa7kDKs9RuMUMSqh1sGMVYS4FI4B73SffXDVR3CTzQsYukRTrC6x+UThoegAiMV+MJBSbD3TGWciELl7acNomrj6WoDJQgBLVxf9m5TdQQa6YVd3/z3zo9w7kv9HmcN6jpXT02Tq1ZErDKJOxPxncGLDAxi+fAPBtbmU10SS2pRzChNE8yS6HeMS+PJupap5j4QSGQTki8UXJ02f1K6sw407AoR8RTSAl8dKKyob2lM/S2LC18658hH7p/jOlATtwltLtqZ0eLzb16xgQu1grIXh8g9xTiKT1UobMKHVmJxHFdJlmQ9uI2J1edV3K4O+ZLibyPfEg4G745B1qaT1z3pJdv094eaG8XhatMEcbO+NV3gNvcVDoOwDONCjWY2snWByjQ/wURyC0MSuJdvPf8R5AwpsDm14L3SmbXGj+HADdAegUPPsSGKnVMptO0MGPUNOPUPEDVqr9IEeniVvHOQsQNCG0Mr
 /mEqP7sP
 9jzzqeWyR48qr4IEpXdcThHUyaBSRHt7ik3p1GePaSl0enqKXFYlgFSW7+n2EmXrDKDANjtpujozVzcJroX3L9m4xHgiccKnkoXjrI4q15Qveb1Fc1TD15RmAVdC7Pck5sAgITGTryADMfRrYZA1Olmr9EkbTiEC5d4T8qpnTBJQxPhVY35Ei9mfAcKnLHp5gIpUeZkeqJfmiERgPQU1wVmkUitWlMKGpECMIqOP+5A1MTwefjAUQ+SlWtmNmH6ungWwmS2OuhxsO+X9Cz4Vj+8Ec36MEqmmcBi85T9KdMKngFzxPTcbMFc4QRpQ0eerbQWvxdl7XvNs3VEuL4PNkIMV2ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/10/25 6:05 pm, Kefeng Wang wrote:
> If the folio(even not CoW folio) is dma pinned, it can't be
> migrated, so always skip pinned folio to avoid a waste of cycles
> when folios migration.
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


