Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD20D10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48556B0012; Wed, 26 Nov 2025 10:40:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1FE06B0030; Wed, 26 Nov 2025 10:40:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35DB6B0031; Wed, 26 Nov 2025 10:40:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9D41D6B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:40:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45F3C13B814
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:40:50 +0000 (UTC)
X-FDA: 84153171060.16.476483D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8414620007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:40:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rtokxXzs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764171648; a=rsa-sha256;
	cv=none;
	b=hpKZM7Jq5Fpv4iJPTFm0zF2ki/LkqRHQJ4kn9g2QYbms7ECGU2vurKTsl46GxgnC0aaUQZ
	YYZlOMH+QmZjSHt7nRX5qFiR3Ofed/SFtpPK8vkPmhRKTE5qFl36TphybO0m95YwAFjJHe
	H/LnlODrv4cz5Y9H5Bt67uP+xHvfB+s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rtokxXzs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764171648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzOF3tvR7o3R3IAAXkAJcJBuFT2H7QQH4LkP1o4BoiA=;
	b=RQV4dB5ABzeGvQLrnvFlIzJJTdRPUhfSjJQtwsSDruGGY7O34mngRUeh9I0kJHC0zJZQcm
	XRo990cTF3C/yoNAv/nC7ipuoMYnFI6sfcrzKQfnvmoxjc1130t6jWuFBvYuuHhF4w/U+6
	/aQygMhKZ5XRL6OXe939WkLmhjLvRas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E28E41AEB;
	Wed, 26 Nov 2025 15:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9550DC4CEF7;
	Wed, 26 Nov 2025 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764171647;
	bh=U3CDHUxKiNPdkrp06riE1Ud7PWKu//nHZU4THiPNmDo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rtokxXzs+3GkijwTkI31NZ8qULKTsdF1sEnmAlo1/YkZPiBhxtjy/OoAtGxAJYHbC
	 g8BJB1d9Vz2iPvwvV+9IZas4F86j4Oe76lSj35puhPm8NBLjFfkmhhHfPPNA2rBb+X
	 ohdYK7ot5RXjCMVQEQpY8pt59bBFY8s5OqMW5H8UQ5kScAhEzGF1c3EZIhqB+yq5J/
	 C/OJZqstWtL9PLWWontvzh+Jq963cH068mf9FRDhYYv/U0VQG0Mpq0mgDTC3/IQlYO
	 MRQUpVLBr9u6iBpeqsDKy2xnqCM9C3LDwyz3P7F9vs6RF5nqB396YkmlrGTgUnspUz
	 P0975f0G6/GSg==
Message-ID: <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org>
Date: Wed, 26 Nov 2025 16:40:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20251021100606.148294-1-david@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251021100606.148294-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8414620007
X-Stat-Signature: no739nm9uem75jkcq5ip8wx5fzdx4p94
X-Rspam-User: 
X-HE-Tag: 1764171648-259290
X-HE-Meta: U2FsdGVkX18f/isjRTnRHAS1BqdpDQFVrx0lNGEobHaTh2kgEnOoF7Gf3y6+N7vmd3x7VTZfoEo+qN+2wZ+gNM+DP21CfZFIxAztA3blqCGljkqVD3GAxpKUzgUV9jA3EmHiZwTfYj+j2aoF0mNocLboZpOqIx3pOOnPEcXTo8TR8GX2D6CUKliQo6AweK4qd2HHkIe3R5rTV3v034cLZn/f0vaj4mWILN/NGGMqs2I3X9DrKgepTcUZwWgvC4ZTBohNsdukrmt0C0GPn7D4LHmK4lq8wadO4kBmL+H7JXXjol5630oKP1pnlMQklSmKhlAdaKpqVc7zxwDUVyAcc1oLzP5GHhJJSDNsmib0IBC8RdXROIBSc1E2yz/YJu4aPOffv/lMtHWoaoxLr8QN3/nRi1xdfQCPXjhajl1/Qca8u7r4JT+GahDMZQd7ADwQs7xX/zDtNIka+s8iS+7daZaILOHOg0rS/pciJbi6X/Zgo9j/3hSgMNPb7BfPOF2fElUWHVFeOoTeS/L8CAbE5d6PSncRdX+RyMuSmHAmPVuy6Cmk7G6Fb7FtPZGaItI5eQw4HO5j7cWeuWpZcOjYimz8dqhyyiATefcd9q82sIDj9FY+ILYVXZT0qyJwflT29/21chhUToSDoUNuvctyCxuVdRM7FI9EomdlvA0wExqSfp0vvyDWgVsZ6Jq3AKAkrSKvD3P/Gwcao0UFEZqXwJa6ylZ9TYxORGXQOcCKHViumeVXeXYo0w/kV3FQ8pUv/0BJFp6+68/fVqFri8/B4wpEpaLrcVIawYfpmQX5kkOtFDWFdbxaCvfzaH4T1Do6mfmP98jwUHExZQHXn6ETvdcOTjWWRIQUDPRELl8ApwaOarVgbNQfrUUtRogd2WOBfw7kafkxm9NGU5yeJ1xhQATAke8KhLpXlOqOnFszPv/f1bgZ/ihUi8j/zrfPsPgAlro2vdBnWaOaEcXNYC+
 FEgDhv9J
 1D+MrKnXPCWMFggOgPgEXZF30bySfNATFaGRfOBgpinyGpC2z4tvGfa984DCkGjx1UKDQs4TsBvAICGYqYCkPRQzfMnnH5S3cxZoaLZZigjqMkJ6Mj8qbRAnmIvL9VQVKSI6IJnptI51oWztdammCScmcnDGpPrS+e0ulhvTz6rqTWri7bXrGblwRb3qvbYOIk80qLjfgwQghErfWrIEgLiDlPkKTG/9ni4U5AUNTEbKO4w2eUfBhAdTWBgvVLyWLq/Z3x1Z4ofHFDPpAlURAc7KmOQaF2+5I9GOa/eC1BsryD5Bp7DmvqKQIUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/25 12:06, David Hildenbrand wrote:
> Two smaller fixes identified while doing a bigger rework.
> 
> Compile-tested only as I don't have an easy way to test right now.
> 
> I would prefer for these patches to go through the MM tree as I will
> be sending out a bigger version soon that is based on this series --
> I split of the fixes from the other stuff.
> 

Ping,

I tried to get CMM running again (using the simulation mode I introduced 
a while back), but so far my attempts to get a reasonable powernv VM 
booted in QEMU failed :(

(e.g., Fedora qcow2 images use xfs, but the open powernv loader is based 
on a 5.10 kernel without some mystical XFS feature ...)

-- 
Cheers

David

