Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB96F34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 12:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925D86B0089; Mon, 13 Apr 2026 08:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD3B6B008A; Mon, 13 Apr 2026 08:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83AC36B0092; Mon, 13 Apr 2026 08:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74D096B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:12:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EFB1C05B8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:12:00 +0000 (UTC)
X-FDA: 84653419200.22.4AA608C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 47A6440003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:11:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0yAr08U;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776082318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEEQkaH/BtSN7lthjV2TiLZ+ApswIvgniCPlOrEcRM4=;
	b=tefEVYCykNdfrJ6hOoMCC5wFBqrCOwno/SuEXmvAD8gwOjj74IQjDJHxmBi8YRQPPpvAWr
	P7RqR0OA4Gc1TGgRyy8VBT7/G91+IbmyRkcX1ENJEYQ4+tbJgLG1mBcWLSevv3enWlCl3j
	SyNBVP5VUIkrbxJWA/YvmhLmBou67CA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0yAr08U;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776082318; a=rsa-sha256;
	cv=none;
	b=DIF6Dz3YsrDZ7mTWMUgRSr/UtDzZa92W8AEfomLGy0k83gMalO+fK7jNqbDJB8Jl6sKluI
	v+uRiTynWGBiJ+1L+YCJVq8j3zT8bw7XdjWe+e40XRzAt6dsruVXrr6oFA9W1I0XH2xPhW
	yhRAcANUgB4lbbzPOYD3wXExNEMKqig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0428740863;
	Mon, 13 Apr 2026 12:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43CDC116C6;
	Mon, 13 Apr 2026 12:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776082316;
	bh=cPdjbkwgMbN+VgL2rPaXpYq7s7kGzAbIz9UpEqUzzOo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S0yAr08UViSRm2TYvimSu0pT2PUTswB7jZHWxAVTH2aGoZKOA5MLddB2to0FjYK7h
	 UeV7+4VuvgrXi2LXqIQeT45FD7WpLHBP7tyOxUJUxBBvMHo8jqR9P+GvkeK5AKUCxJ
	 ts/eDEpSuy/TdvX+a7BxJL53TjlShuDPj7v/pyjXe4I9MCn3jUzvO5zMpXadsSYe0g
	 c/UZKQ5GicYWhNI6MdCiEeg6m/o00+tZQgdvIwXf5kFY5vZZTnA81d8CwBSRbj7C58
	 0crIq7DUnL0fdgfNy7Id3/27v6B/7Oi3Elx7EAkbxnARbTnNcSWry6fyrPeU3ZbM/x
	 4rpucJ+0EA62w==
Message-ID: <918239a4-a759-409e-a9c7-1d8d11912f56@kernel.org>
Date: Mon, 13 Apr 2026 14:11:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] slab: support memoryless nodes with sheaves
Content-Language: en-US
To: Jon Hunter <jonathanh@nvidia.com>, Ming Lei <ming.lei@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <abE6uqdzMUv8k0mU@fedora> <8ab58ecb-1fc1-42a1-b67a-c3107de2ece4@kernel.org>
 <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 47A6440003
X-Stat-Signature: wk6qm9c5xq61hz45rn5j6bw8uc1cpkcr
X-Rspamd-Server: rspam06
X-HE-Tag: 1776082318-707960
X-HE-Meta: U2FsdGVkX1/wB8yGEQ9htNXNV87ulpga4lyXLNVag5bsviogHvWh6OcPoKIXtDtrHICwdHHccDEwDgKvJ2iOtaevn6+vojrHRoy598o4QEDMn7HGGvXot+sQoxoMZaqkWXJSlP1kKicbI1ZzDELN77nPEUEdyv4K1Md/6UC1JvxRPfqLl8EhSkrNfBzRL7zS6ZOoF0hX8EW9n73rIvXaXwbkQZKbaB3swQLhaslYAdwarO4Zq24S7MG4F/Dioad0/bp6sjtRR9nGLx2gahwf/51LhWzDC9zjwK0+++8PsqynixJKhHRrAnIU+eLtQVClAKfj9dZ8EXyBlyRcIGrmkCxg5at2ytfzQdpWNcpSBXiFe0GWwZn+QEXp/MBuhTScV7ZLCgNAaL0EYiFvT0U8lAHi1Ny4evKg4P+BjteqUuVR012nizWTmvQac1BDo6rur68QH45rK5wyD5IZ9wqRW/naY1QIMBO81Db9RHJcu+EKqUW7Pl77HwBNuBr7NP8Hdf57aUF5MAlZStjCMqsqPatGYt6XsPeV5AmRSUyimI+NTifn4ipAjachAf/zJgxWp7SdQ/GtK/qUbLF4SxgYMQzFMOY4A7OQWijv9eGgoIyfmd5vuKUlrgh1QnfaiQAJF7TRXxndUKbs5Mz7vHiZmG1qalpyqA5I+uHY3v9ijSYXlxdEYpQCxNJilj/kyyrOOdaK/AthsBUKljshDWqHguRChgJ+/7pR6ziEHBrF2Vz1K/f84Uy8XF0lHoir6DInn7lwgjm0fRtPy/XUSCH0RmaZRB2cQixWJb8Mf34zAiUgqRry9JCbb3cm8oc995ILNCLoVln2G9OnnG7YcMDJXig7utE/nrohhqd9gmD4UfYafvkLBdzsT3YYdKNksF1UPGpvAhuBJ8Bbo5OA4+sq1zKXl/vDUgleySpsBbmPxUMzYHWaGrvef1n/Jb1YV99yA6foxl7xuk54uEQ7EMX
 1LYy85fS
 ix7ZEs81HyeRZEBGdoBF5A1cpGQBeFIvvWfpzmsbzWNsH4Y7ChzxZPZKezuolbsEzut7/pv0Z6A5phzt3YnuyYJCmnAeZZqN3IRi/xzeGz3Ezc5k77/MnWWharyHGacwBJP5MU2lP0ZHVuBFnIN40vGvFpTokWryCcGLMVuuz63fjm5QrNfDkyuNhp5SBoJbveIZSLzu0DaAyw2VFsABTaljT/P1Yrsoj0FsGwvLPUDvIrg0sRazAKgwzT1apruTJGYOeOENmsGgIjUO/2fgiLQCfNvGLx7G9ktsQTNVP4v2ro6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 15:04, Jon Hunter wrote:
> Hi Vlastimil,
> 
> On 11/03/2026 17:22, Vlastimil Babka (SUSE) wrote:
> 
> 
> I have also observed a performance regresssion for Linux v7.0-rc for 
> some graphics related tests we run. I bisected to ...
> 
> # first bad commit: [e47c897a29491ade20b27612fdd3107c39a07357] slab: add 
> sheaves to most caches
> 
> I came across Ming's report and hence, found this series. I have also 
> tested the 3 patches in this series and it did appear to help with one 
> test, but overall I am still seeing a ~25% performance regression (the 

Hm with the numactl output you posted, such configuration shouldn't be
affected by this series at all, so wonder if it's just noise.

> tests are taking about 25% longer to run). I am not the owner or author 
> of these specific tests and I have not dived into see exactly what is 
> taking longer, but I just know they are taking longer to run.

Are the tests available somewhere you can point us to?

Thanks,
Vlastimil

> Anyway, I have not seen any recent updates on this, and so I am not sure 
> if there are any other updates or what the current status of this is?
> 
> If there are any more patches available I will be happy to test.
> 
> Thanks!
> Jon
> 


