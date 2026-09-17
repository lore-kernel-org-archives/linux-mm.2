Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CDBEC982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB76A6B008C; Thu, 17 Sep 2026 09:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90336B0092; Thu, 17 Sep 2026 09:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5326B0093; Thu, 17 Sep 2026 09:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A79D66B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:56:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E5C81C1FFF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:56:04 +0000 (UTC)
X-FDA: 85223403048.02.FBF4105
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F2FCFC0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:56:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0o1NCLo;
	spf=pass (imf28.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789653363;
	b=FUNMbjdHTRt+2fSot1D24R7o0EGLXJ7v160+EZ+xKgrcajp1qeFXe7BRMXlBhjuCWEKZOI
	TU2jHmYoqGqnZbzCd8VGxIZDYgteSM6Dsp0Brl+ppPFIY/11uvCZORxB1yBaLGmNKfmtt5
	jDMX8jpwTp9a8J06zSDUaQ0Sl7lVuw0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0o1NCLo;
	spf=pass (imf28.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789653363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AU8CGgy6Pa5vfZgK02vvr6pONCCFzHgT9ly82BtluUM=;
	b=fUCXsDNXfUNGDTI29u1gOMpmbfcQNoV+ZnyGXJjovJkZE3EKmsWqXGEpov489yYNYeuV7P
	AViLQhNJKVnQHzosunDhaIgyTcBtKO6Nfz5NHP4wdZ3KI1hnzF/VPC9mXRA7fiMYrmIL08
	aZ8af9emJsU8yWLXZVoQ9UTcWNxx7/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84CA760052;
	Thu, 17 Sep 2026 13:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB311F000FF;
	Thu, 17 Sep 2026 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789653362;
	bh=AU8CGgy6Pa5vfZgK02vvr6pONCCFzHgT9ly82BtluUM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=f0o1NCLoIaKYvHe6FBZBBPQIdVjNHSj17+boe4ixXC3+KOmFDflYlsRC5fnT5VKxe
	 HiRy4SVb68ngiM7azj5+u6m0xyNju5V08cQfHJi2NV7PnWKPKN0HohbudLio9W316d
	 /edQAOX6ErcG27FlD7aI7nIlFvgogzkRyJF2d47a43MYtpOIbd3z+9IDQOratubN4N
	 ZuFV4D+qsmLiDJtiANyhBpkxPnBMa9HwkwVS+ElI9GOaUk8mXNshPSlsKTwpKcv5iZ
	 W69f14zdA0DevKSl2Y8ooTN16Hqf4yJJ0lXRIWagnyzIQCBiYdtgcfS7LhiSuDGGLp
	 iwWBqDVpHt2jw==
Message-ID: <c92a1202-1fa6-4cd8-9d82-b46a1b5d8f56@kernel.org>
Date: Thu, 17 Sep 2026 15:55:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 baohua@kernel.org, david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com,
 leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <493ef264-eab3-4be3-a80e-357f01ae1b37@kernel.org>
Content-Language: fr-FR
In-Reply-To: <493ef264-eab3-4be3-a80e-357f01ae1b37@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F2FCFC0006
X-Stat-Signature: 7mu7f6g16gyrzixibxzzxyjzom6nf3wz
X-HE-Tag: 1789653362-556419
X-HE-Meta: U2FsdGVkX1/hmfyUNwyEcY+jgqRkZHmwU7bX+eAuAUgOpVGtXMhA+H5rO5Z8GzWCol1L907MMWZzkNTjvoBw3zFDmIrimfkMjoXComUV8gRSdnu5YpHy7+rP4FuFkoUKfE65d8cGNNboSWNu2yjEA1jgmOc4cgWM4Y8rqckTYKNMhYE92mMFst/CSmlU5WjqzhdD9qcm+Mgb+qD/YNPlPl1LO3T4pffp6rZYo6u41ZQ6VGSIPEzgDTwCggHtr3UHJlTZ0eUTJLLZBlaEpk0c8X8IORPcOAY26ugVn1WUVu8pfQTXrCrgTKUSTj7UJEHrIW1+Xn8xPzOJGpMA39cKTHzUyG9RhpLlnidHneh2dSchuSVFEIcPi/MNrjB8BDqmgEfG58ktlaHMHafKiyt/ckmtVazOjB36+2kJlSXDPqv181Y8VO5pJoIX0nWxvIwhWFdWVOCDk0UeHtLNsm21qMFL7SIKaBubXIKy7OeDuKuR2bSDWzpRqikYQ6js6PmNwmXE/H4v4A7NR+AcX3seULzWMWvAemohn8ZDd7WqEVt+zK3/xrwLq9ZiDm0bOUsoBd+PBGlpQz1YhJS1hSBsp4HAli2wqH8a+RFRZG87cwZyGiH4HXeJoi66Se1+E8qn6qbnuLLHd/kB8DcaC4FB0IhAVViihOYpS3LyjWE+YPx5OJ2cZz7rFRXydj4SdKxbxj7oo+9sJCoI/wv/g5WRfm2GrvnjgDUa8oLCaBIadzOc7yvmG9wx7c/yBWQnJTcJtsb4MkJ6AiIKAQfHtmXhFjIfiBLQexOrrG5ouHm4UDSvGGUkKZ4y5p/O5q5s3N1Dfmk7qsd5eAk7ZQlZWgWuYHW1vcEiP0+pTVl5eDwECKWujjM9M0fE3/ApjEgDX8JHfl9gLkggHe08Vv0EemDF7x/e7U7YaD0bdDr22TSVHxn3/beOmLwo/dclN7GKc744NjZ6OfXJyDAgqePHN4N
 tz9t6in8
 VzBd2nPvjc039uamdDAkq8IscgLCaIahRTlfQOWVCZljKUUL3LNBAfIh8LpWXYbKi1tuLGrtuSUswJO2d+bN8ZZjoHf9Zfq7zk7aeECta1K4A7vm9iGQZn40q4FyVQxSJtkWZw5dEY9Fafm1srfQRlwQaN+2Jhswi0E/D92G7cD24CVgA2p+a0igQWlCBf7xa7lmvCW3nfIc6HGdL1whPbCY5B1AR6S3X8zq80fB/73U727qpEZfUcEsN9uqIHT1Is2ocNhMmCFqudmbMzdd4AuhHrx1kTreg8wcG8Irm6SuGu/vUy7mLVkQ4ncK8S3oAI7yKsu+Ny29SgdyG6zeLVAn3sXqlHmIl6auNj+KVlWL8BAbL+qDcDiz/olYeF1NT5UD/Ks642KYkJAn4McfglhuF+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 17/09/2026 à 14:17, Christophe Leroy (CS GROUP) a écrit :
> Hi,
> 
> Le 17/09/2026 à 07:29, Wen Jiang a écrit :
>> From: Wen Jiang <jiangwen6@xiaomi.com>
>>
>> This patchset accelerates ioremap, vmalloc, and vmap when the memory is
>> physically fully or partially contiguous. Two techniques are used:
>>
>> 1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
>>     segments
>> 2. Use batched mappings wherever possible in both vmalloc and ARM64
>>     layers
>>
>> Besides accelerating the mapping path, this also enables large
>> mappings (PMD and cont-PTE) for vmap, which are currently not
>> supported.
> 
> This series doesn't apply. I tried to apply it on top of v7.2, v7.3-rc3 
> and next-20260916
> 
> Can you tell how to apply it ?


Finaly I was able to apply it on top of v7.1

Christophe

