Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3202AF589D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A166B0005; Thu, 23 Apr 2026 09:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CAB76B008A; Thu, 23 Apr 2026 09:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9CC6B008C; Thu, 23 Apr 2026 09:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF156B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:20:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1FA0A0120
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:20:44 +0000 (UTC)
X-FDA: 84689880408.28.D8EC82A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2D12B1A0014
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:20:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rf3IguUv;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776950443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bll4R4MQxkRa2QkfKPQVJtKI/5Qxk6+BeXET0dfc7BI=;
	b=6ylVhSL3cfzdtfs5UBdk9Fecnv3O31iWfdSY/SeRp0rG3f06KS5LigoiUsFHfcNtQS6Lou
	hWtW78S9kRGDZtcnV1NCV/5m6quXeXaNCh8eLvf8DkBc3U6nOunQn3oYfPkscg8r5GqlCF
	29+J5Vv5sWhV85QULvHIMD77uTAqk/c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rf3IguUv;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776950443; a=rsa-sha256;
	cv=none;
	b=289O6Np+Nnjb/UbQou/FKmI1kkmLK4W/ehyX3wfnoMnDGoqRQ2uQu32qVTtA4Paup+v4bm
	6AsXpDFDyRuSb0JejCta6ynVkazmYoziJKJlLsp0rIqpczWYii74hIgc+PZNhTH+6Srp/s
	MC9/xwbrqbnY1LdHomFZLAvLP4PttWs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F4A86014B;
	Thu, 23 Apr 2026 13:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E56C2BCAF;
	Thu, 23 Apr 2026 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776950441;
	bh=16ECb2n3N8O1lzUBHc3hwH0AF/GdPcdXENNsaw/xXEY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rf3IguUvF83mh9EAP0qqqFrTMbGEZaPXN3nBP7l2StStokf6JxVVAjLnhe2G1vrgj
	 VnTPQYS/66X0dHyu+gAF1ncVkBsOt5nO+Dwuochcah8cNceJukFShKN6tH5/6xAFRq
	 Qw9qbaI+dOGWipyl4dUCm5qay4Tmsh0dAT6b1Rwz2DbWvs/7NTelhSQ4BSRjweZ7j9
	 y9dAd9vMZ+UlZ+cTHDHWHKLFdfeSEtQVR5GvMPfpkyB4znpi3ecqoitiQbmIcSPd2J
	 SxPdOh4z8uVhH403ZoQh5Q6Q8ipLsbQ0b3+Jge/2cXh4HK0Ebjg3iSncOmQPcq64Ig
	 0KQbp9FYJk4hw==
Message-ID: <d3cc7e29-c84e-438f-8168-58544161d67f@kernel.org>
Date: Thu, 23 Apr 2026 15:20:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not
 supported"
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jigyq414167omur49nrjqtca1r8cdrpn
X-Rspamd-Queue-Id: 2D12B1A0014
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776950443-138594
X-HE-Meta: U2FsdGVkX1+PsMDC3aSHX73R4lQ943/Jy/JjLlcH7qBdt1nnsX45Ft5doDtThxHOp/X7lCdMzNJakjroS/fsoyJTt+5iXGQvUgRkGq4gMNOvK1mjGTESWPWRfvsBFuOoPKkR++UyAxKP3MYLIvMmy6w8iCYU0/4Ihv4qZmuYvJESuNDjny1lBRnEQByz8ptpU63nahhQbnJHp01PIOPzO4r50819lK7EtaNpFqsodgHw4yE+duUTZF3jMY0Ky376hrrZUgnR6Kj23Ndu56T1xPfFa75GSF0LujM6CILV4zWxDUrH2SVoNDdIpBHpeffC6EXqF7/fhtxcHZsX+6wn1TbqEGI7KfnITstrQY85WSPf34JVgEjlv24J8P5QVSE41vRgyGHhj8LP855s/v9b7t9R3onRHzyrAiL4PFnvaLeyLQpLBTgz5eWLVsADMA2ePN9slD9X5lQetxmIthmpmX6ITzKT/2cXUzph7bBRHslz5/LtMse37mGcSTu37TQ04olUWKBIUlsJbOlk+OGWyiLZoXPmzRR6mOzy5um1evuoueg81aDyeKsCvt9AcytPXMpSFXK8lfXTzAgi0nVemS7kDKijgEhjcXdGpCfidvWoCXw66hfQ0DfLcDsKZbcu/HWphcX9HTPlEix2KQkGk1sO9F9oMWTES9qXeiF5KFqIhwxyoDz+Jld9i28obNK4ZMDb6jcTxZC/eTPC3dMPLt0LntnTrRKnCAyeXX5mggFefDda4bStkBmuzh20mTD2K1iPigGZn1QiOY3tEK9qIiFs57uBu4sBquyS5luoKPQ9S1Y7MiAckuq5vwlfewbt9/yQbJEM+JfZJ7Acq3WRzuWNbt2wMCQDPeQQE9WUtKmNzVaNNeIM5wXzpuhnwQBogzLCmuc3BG15XLvLTma6gcx1Ib3qwlYCSPx8mclKLPpL/Xa3vuIvnfyY+I5dRWny1uz5z/M6SQ3w/Hapnf7
 LEkqPbgv
 5Z9w3+BdjfhFvjqBJ+W7/HeswhZytb12AXyf3VWKkiyedTl6DQsUcb3Xcun4I7BZTE5I7YHWq67TTAxdmr5K6ns5k2EpYM+1V0+ApN9i6wWBEt7DH7fHJ1ugfGw1AXpspdh2WnI3qXphLbDj4EmyI32l9nfWIQCohsl0Jn7awm7ov3InmRcRoqeEEfsfMbg6yZLRd3rMeSkJbkgIZMLJZgufrv6H3NzPqU1YkXHuSvoDzQmjg9HNHGDAXQG13ENzjxSZ+jNMR0GBG0cr1JtbT6soMKt5zvI2IayVs1e8NAjA3UbU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 03:41, Baolin Wang wrote:
> This reverts commit 5a90c155defa684f3a21f68c3f8e40c056e6114c.
> 
> Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
> determine whether the shmem mount supports large folios. However, for anonymous
> shmem, whether it supports large folios can be dynamically configured via sysfs
> interfaces, so setting or not setting mapping_set_large_folios() during initialization
> cannot accurately reflect whether anonymous shmem actually supports large folios,
> which has already caused some confusion[1].
> 
> Moreover, for tmpfs mounts, relying on 'sbinfo->huge' cannot keep the mapping_set_large_folios()
> setting consistent across all mappings in the entire tmpfs mount. In other words,
> under the same tmpfs mount, after remount, we might end up with some mappings
> supporting large folios (calling mapping_set_large_folios()) while others don't.
> 
> After some investigation, I found that the write performance regression addressed
> by commit 5a90c155defa has already been fixed by the following commit 665575cff098b
> ("filemap: move prefaulting out of hot write path"). See the following test data:
> 
> Base:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
> dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
> 
> Base + revert 5a90c155defa:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
> 
> The data is basically consistent with minor fluctuation noise. So we can now
> safely revert commit 5a90c155defa to set mapping_set_large_folios() for all
> shmem mounts unconditionally.
> 
> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Note: for more investigation and test data, see:
> https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/


Maybe add that as

Link: https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/

above?


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

