Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066B8CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 13:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3DB8E0009; Mon, 17 Nov 2025 08:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B648E0002; Mon, 17 Nov 2025 08:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8CB8E0009; Mon, 17 Nov 2025 08:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17B908E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:01:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EF735D5D2
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:01:48 +0000 (UTC)
X-FDA: 84120111096.22.48C54A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DF9F42000C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:01:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hvxskFR0;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763384506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ndcx/cUF2vAWpUhjTAiwa2BDvbvFoUno3rYlPID0Srg=;
	b=a5skLGrvsw/rlQ3odQSwoDRZWVYkKgEpVsT3my0FZQIUMt8LqowxGaZU2MjI97B2iZH321
	Hqli4ZzxxTiOl47/WSIOyWRujF3vCWK9wxmfc1ppbjvq/aEobMhm6Le0p3mpv0kMlXBvQS
	1OQlgHe8xG9V4sKErP00oR6RMeN6+SI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763384506; a=rsa-sha256;
	cv=none;
	b=bwJJky3J1wNB4jFqUfSztXXM7HEb+1qhDHI2rOA+rueXwkVkOfhPh/WNzl0fJ6QGYwHSHV
	v6XO4o7HjicgzsY8Adnf4N4XoGX1VqqFxmBPFtxRkV0DzgCi0DqeR1PqtJxTvBL1mCGx0X
	0EkwRNCbBZ5uJx8z2gZyxYW135eCjK0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hvxskFR0;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55A7760143;
	Mon, 17 Nov 2025 13:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4B1C2BC86;
	Mon, 17 Nov 2025 13:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763384506;
	bh=amY5A1MHjQ5DB1R9kBa+KNUTxrZTkL8fLkB067sXIpo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hvxskFR0Olndl96YcM/fnsoWPxCeOzLsTLCTG9nE4r2WJlmPRyNBEjrW4rv8MF+CW
	 SpbAkJyliL//jX9jgCYCMtQUFbhN7WBXcVf7UDS5xch6nt/i5+ki91q+HwB6QkEYHJ
	 O9Lm+sFiHn/dpF46I6a1rWOzP+y8Nj9fof64cKmkrSUh1BtorHrVtS7+JLnAX5YG2q
	 +S7YV6rM/ADE37JjSvwUgaBesPuNGfLBsuRhcQwFt8MCBSJR5gsbIawUeDi3ifQm98
	 loCt1Bd81JuXCSYvxfUmSfA2ijkVCySYbjbrDq7/hwL7JTENWQ+LFAylfi2yXP9g4X
	 30AO0YtSSAp8A==
Message-ID: <b4182bfe-4081-468b-86d3-f1ac04ca4f5d@kernel.org>
Date: Mon, 17 Nov 2025 14:01:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fixup: gpu/drm/nouveau: enable THP support for GPU
 memory migration
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: kernel test robot <lkp@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251115003333.3516870-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251115003333.3516870-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF9F42000C
X-Stat-Signature: 91t94cazocoryt5hsmh5auoesxk4xyo8
X-Rspam-User: 
X-HE-Tag: 1763384506-223539
X-HE-Meta: U2FsdGVkX19UZbJ7YxxdFFb7vQa/E8dBlNd+8r2AKD6oYJAt2qM04Y1X6lHwhWvvbmxbPjH5jKLcp6J4ElCJDBjJkZGo5yJiyXMRzPvNVWSVjWfdNaK0RkcIJMnjLccIiH84plrLWHPedEggs5eza2L9rBF+nxCTFAJcCftsMRWGYKlW0Lfn5mfbfROfPRkKX4imv7wsKd1/4j9c13KaJobVVU8HrstDB/tOTffJtC8cbFEEA6FaaD24Op1d2y/jzCoihS353PZU7SV0mQz75f9jWHY/TgAhPy7USYqMMWaWvN7zQzQGIoAGNI8x6oBdeHI+t+PVs4T85uDByARv9/d/DgCawg5owt3SD1qm8BwFc1u8C5GngiGZvx3zQZE6+7YheYndMq7QbPoLQ1CfDGY/iP28AcN9j/81oS3jn7HGJCfORTUYt1WjvIYH5PzwjEhdoYvsO+rCVqyDYmxkbXD0vlLEN9mfNsRISCQuIdQ0wURo5BW04qc9nWkEd4LnzhshpqnMtRSUa5/whx9jHkriGlWN44UD4c/SKZia7nF9CXw0BSDkULbq0nykWkofc883KG5wmsW6N2jqtxd1jRtdcozvVj9KNSuNa4lyDXeqo7Xq7UPV54XeGEuRsYSd/JSGTGeZq+m7yR4EBiSSn1VNmtVz5+RLLqUgI71jrWik37ZcMBv/bWZ5ta13gZAtaiC17qh/1L8HS4cnhu3cGq3Jyct0jW1qn1dvxt16GkfZx7l/GkWskjkKzUfy7hEIdVFAQ+BDJo2hWff8W8JlsBmuCDC4uHTRagr3wxLLN0ZFO2nhVQEaDE+iYoxGPkSQATTPXKxcN06QGry3Oc+Lv0XQOTBdHOyBqJytiH5TdKwiNguhu+ZA5UTpMseKQJbLLYgrru8whxQ9wAvrwZb5fdpQWrnP6kmP3LLZWu1mg3X6+1s2sXS7DXNv0+UaVlggQf6WIrDMsapNqs2keW0
 QrdNhJpy
 T4wfgbTiEklbEqKTEXEYC9gN7FRAO5hjZMq64lo/IpPaN9a4MXbk60w2CFLKFQFFekatVxM0oPksxRvh1cYouTKC7sdVxsm8ear2BQ+JThyyRlmXxixCUqTy3f6xFFwSJ89sGRvYNqbmH7do05xANEDWh5k+mmjPborqXuR+gnab6YJuD0UvcDOpwwcW6zo/5PCyYaKi3isJayTq4uyNZSPWnHIUKLsMSklAbW69JQC26vMH7rzel1/UOQlI8kCXdLGrW1nIf7EQgbIovGoWfN9YFjJgIMHNQbpoTyzoAt/BuL3YEYGVAP0WXLA21VWeRmhJxe9zpfmIVqoMZ7eGEa4lKadYDMv6RW32CgWnWc0QeGz+CMJr0sDSWrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.11.25 01:33, Balbir Singh wrote:
> Kernel test robot, reported a sparse error with the patch
> 
> The sparse report states:
> 
>>> drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got int @@
>     drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
>     drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse:     got int
> 

I would have simplified that to (and avoided the long line)

"The kernel test robot reports a sparse warning "expected restricted 
vm_fault_t [assigned] [usertype] ret ... got int."

Whoever applies that can massage it I am sure.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

