Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F7CEE4999
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 19:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786296B0088; Tue, 30 Dec 2025 14:54:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7346C6B0089; Tue, 30 Dec 2025 14:54:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A746B008A; Tue, 30 Dec 2025 14:54:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5213A6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:54:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AE02C1766
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:54:41 +0000 (UTC)
X-FDA: 84277189962.03.424460C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 795C214000A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:54:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HO+3Px2R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767124479; a=rsa-sha256;
	cv=none;
	b=YVAb5kM9kI2jl00vrRGhixAo5t46QEraG8gv6XuJKHaoJUODhFeufzihZc7//L/qxTShlw
	Q2DSmhrU4fvlmhjmJQeJSas8yMipvqne1mVdmUhiMYmV5CB5lJdy6ZdNgsi6Pk0lQe1j7Q
	mvKt2dUtssqBSLvoKuDx0S7cJawxRwM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HO+3Px2R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767124479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KXEZHAfIEv/h8eZhRtvFNUHCSaBdusqhSLf9TvIpztA=;
	b=HjNeiGFChbggyWFgDvitO9W7R2rr9e6crFMVAGKJLu831gewU74lReONSBsgXumHaq7i6d
	LRSkkXUv1JmbM6kmwfp5+Ws2JE3ls0cxjZGTWsRD/IqcmGiZsv+W+uAnbW1MLh6Z6UVyoV
	PLr86TEO7pGCjrlJ5s2BJcw4DTSlId4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FAEB60017;
	Tue, 30 Dec 2025 19:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AA9C4CEFB;
	Tue, 30 Dec 2025 19:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767124478;
	bh=mP5UTgwdP2k6KvELLsX/RxuLJoDdzwwydVxjz1Sy+Ag=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HO+3Px2RDeFfzJo25kvQ0u9KpB7y1cI4cxEb23zkcoNQCG4pJaCN8mIv9zLQUN1vZ
	 MaOL4V5Ck2h6GgWQp19R6oMoX4knrIdubIaAbjgzJyzcPT6sfYjU791IOk/clgJS0W
	 LR/NKfgjGBpr8vLYTr6EefWg9b6J6Hdz156g1HwqA7VqMh7j9zb3cDbVt4YlLIeU7G
	 LamKLrptxh6zo0fgEZf7RuyAL/DDM8sivmK1oJ+u05nP3Xizdd35zkO5LWWoMICnB5
	 L3kCzi+FtHQ2sDgG5twQi67qT/G9vg06jqQ2FB9xndp45foXiSl8FEv2GeD8XwesW/
	 DF2dV4mVojBdQ==
Message-ID: <084eee6b-6c9e-454b-a563-b2babb76b099@kernel.org>
Date: Tue, 30 Dec 2025 20:54:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when
 MADV_COLD/MADV_FREE
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-4-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251229055151.54887-4-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 795C214000A
X-Stat-Signature: xgzyp41m1xw9ufawacqokfgz7qicxa9k
X-Rspam-User: 
X-HE-Tag: 1767124479-494034
X-HE-Meta: U2FsdGVkX1+/7Pdq20a3em2sbHnhWG4phUx8gFvf03OwaAZYrxi4DvH0vZpfR3UX0c4KXf4NM8aFQ221pto6dDAh2I5UKgLqSpPf3o5StFd0od/waD6HI54jNupZJeRm8tfsUKKBg7WNVGiM9fiTgRvkRiz9INaMMVbwNGriWpcMbCMtHGaRM3qqm77yjzGiqb/b3Sg7APBFBLlt/IA33wDhivVh762QKJdnfbk5kZ11zrhMdnBix4EME1ZjK2US9kSAm6PBoCdlGnsMgmp1nGz4KoA+l9yoR/oGnpRgeHj2Bb+Sdqb9y2iP88Ku6DiXSS4+Y2R+UGk+pc8Io2VEIKGhoKNtGp6DCMC0DkF5/adDtwH6ccofXI/WC/RX665NVO9qyQ447TJ8hIuVh+Y6aWXYapdALgo+8SO5b+ikWGK7knP3svqoT9vT7AIPJFnb0lUReyMBdS5VlWkc/rjAq9O/jHDHQ2GZkriwMWNiQ1mv7SUs2SwXxerb1eSXpN7f+76PWJ7ZJz+dKADopOaw3GFGbW0DehRn/I2M7KfAAfW0ELUtgYlKSQL7nGQVXenkQgAXQf4cB3dueO5xs9cQP78G/6pwfsu0+QYYyrGstt9oHoAM7u+vXrspzw/t+TDVKGipktDjAfrHtWEqDaaaSH0c6s4tgh/r1XF7p+ZK31b+zRKNpAJ52pgIXkV8PW6YXRSkD47+sDM08tcqp5/+74ia9NjB+anTqYO7LG+WatlxF+9GIvqWFCKHLaQ2o3Ntd/m7GI0smk1Jh4gLLKh+lqJtZeWVv5vA5Mfnhnh3VGipbhZ4uEkonvqQ5oCU6FrZtjjpft6KtQgIoVZhU3UV+ROdgwKfDRcCS+DT+6A4CCY9D5YocKentdrpfFVyDn4wv2aU1aOZC4jcnGmHbP4xcsb8XPNza8rFDfxH5uWZE37ptPEmpOa13qjETYY9nNBpkKGO1KgZ63TaGVeRRqT
 754OgZJM
 uWwmij5YGLY4ufTW0nbGxqEHdGGifVR8Aqs04Xq8F8ngbfgjStqVi9rxOroC4kwOTio0L42CcJVMdvaTxYb4yUwB0vytgJ9xCBdaaenrp0njk9ip4YkEivGeImG0Nslorybgxo2RK5Sy9qRIdrRzIBF1YDCnXjIsRiTdI8nPkvjyUer6pO+dymwaoPDJD9SRyS4xPq7ZO7mJvEpBMvu86Fxt+qSYQHA27yexNc5r59Ww2MyYH7WDsHDkGp0QO5aZqxPXNilNZQ3oAfbSm8LJ9X/3+CzHpmBpNIY7vHWpdezNk02dohyrbfOq3GMdKH77J0YHtm14bEhwACsmsIIUmwYZ8CTKWKPph0KA5oktPDqgp1tz6A9g4yi9SzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/29/25 06:51, Vernon Yang wrote:
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
> 
> So if the user has explicitly informed us via MADV_COLD/FREE that this
> memory is cold or will be freed, it is appropriate for khugepaged to
> skip it only, thereby avoiding unnecessary scan and collapse operations
> to reducing CPU wastage.
> 
> Here are the performance test results:
> (Throughput bigger is better, other smaller is better)
> 
> Testing on x86_64 machine:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> | cycles per access   |  4.96         |  2.21         | -55.44% |
> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> 
> Testing on qemu-system-x86_64 -enable-kvm:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> | cycles per access   |  7.29         |  2.07         | -71.60% |
> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---

As raised in v1, this is not the way to go. Just because something was 
once indicated to be cold does not meant that it will stay like that 
forever.

Also,

(1) You are turning this into an operation that will perform VMA
     modifications and require the mmap lock in write mode, bad.

(2) You might now create many VMAs, possibly breaking user space, bad.

If user space knows that memory will stay cold, it can use madvise() to 
indicate that these regions are not a good fit for THPs.

But are they really not a good fit? What about smaller-order THPs?

Nobody knows, but changing the behavior like you suggest is definetly 
bad. :)

-- 
Cheers

David

