Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 216DCD711CA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858976B008A; Fri, 19 Dec 2025 01:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806576B008C; Fri, 19 Dec 2025 01:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712AA6B0092; Fri, 19 Dec 2025 01:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7466B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:14:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F18A1140424
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:14:03 +0000 (UTC)
X-FDA: 84235205166.22.E59C066
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F2C11A0015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:14:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EVzl6xJH;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124842; a=rsa-sha256;
	cv=none;
	b=M5nN8il3Xi2IHH0HC+TwwXvpN8B20m/m0hOCn+FxS/Kg5RoF0aSqWoG1UPOT/6+IdRlA4T
	IWdRl0djqA8Aa2bqRb28P8bGpwbwQEUxlppU8693Ol0PvHV4j1eTIkEnRfbYJT8TXCzzFe
	J6prF84D96AtKlnFdjzM1x2CA9pBYrA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EVzl6xJH;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lDYRq4aDpjv7MYq51BzCPF2waWfuIU7cpDb6tEwiAM=;
	b=jhfiGx+4oRTV7GomLDYFkALi5rKAORuSqmII4pGyzkTd++ET4ZHEmdPo4RkDXcFZZG/hhB
	5XNYX79RlxcZbP3eC3IaMXrFZ1G2buSEPxn9YtV5wUfVOcWjpOOxOoMB+EGw/nAToNGP3c
	14Z0hQvbF6Ys7te2LB9Sb5ir6phPDiw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABCD860008;
	Fri, 19 Dec 2025 06:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00031C4CEF1;
	Fri, 19 Dec 2025 06:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766124841;
	bh=fpp+RqGdOfeNhoOl4yFFqEiGPr5KLb+tEsiopJhtJ8Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EVzl6xJHootXl5U66WYKjPigWhllML8t2eFx7gR1rzs163UBU9syfQBGmZSjw7c8i
	 z4QRSnTO7UTMa0f4OOvFAWHboC7GzOxSVkJrjH5VF0vnghM5Snl+QXNNXAS5b2mBPg
	 FzAMkkTUJq4WuNkhOMU3L6Pu4qN27vWTzJNaJcZs6y2mXcY0C52bYFUip9sYx7NE0h
	 vGBshnjTyYWtRCF5aGo3z1NwEbxrj0qN98ay/pnuCBOicyHCq3H2qQXyTTBBm5DSn6
	 G3ceP4nqOOqGUpVi1gKbgaTiLqI2gcYpaHWZq6ZyhJOTjPCDbka3UUMquhnkcVCjIB
	 ro5B91Op54COg==
Message-ID: <64a9ca24-2968-4532-ac04-594c340ec2a2@kernel.org>
Date: Fri, 19 Dec 2025 07:13:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: Sourabh Jain <sourabhjain@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov
 <bp@alien8.de>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, x86@kernel.org, linux-arm64@lists.infradead.org,
 linux-riscv@lists.infradead.org
References: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
 <83920c44-47f5-4a46-bfa7-76713197d7e4@kernel.org>
 <1fddcf72-26f7-4fb4-84b8-1328e486d58e@linux.ibm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <1fddcf72-26f7-4fb4-84b8-1328e486d58e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F2C11A0015
X-Rspamd-Server: rspam04
X-Stat-Signature: 4x9dc3fxc8squrbebnr1sytzsw3efxse
X-HE-Tag: 1766124842-819967
X-HE-Meta: U2FsdGVkX1+G7pIx7wlGRTiLdsoGwyBdlh7u5s/GEkoR5uRtiMdqWnq+bOd98tXhdmR/65+61zAs33Is5uu8daUH++LDaZFcHrObdcu+nCC1dLz4eGt0+ikfHpkJwPvSn7tceHxt8F248WXh6g62uZN8Oe2P9NNogLrz7KkO2wQ4RuMJSqxvyChDjaxRjrslQhkXJh4PznLcXLTOZra96UbXzXFCd1ogah+vEJaJppfqNfXdjpD9N0Cu/2+zQSQJYMxjRHAqIOsLvm6P9/EAx7SqW9s15t0HPXRiVC/MwOuN7/VNI0Q3iwqJJJlg8rdT1Hqdob4XxIGKCQk38ZLKbNv4vK0hvY2ksYAReIm9psGz682iFHu6pxNyFNVglnS0gt8F1/c4IfWP330gK1RncYCYMz/Ziz98/QQAQw0BcEMHpL7PIFkrOEZS42XhdmtVVORR75kvKL4QVNZjv76xqBlUr3G5AJyhpkXnpDSzcCFGnXq+hU8/ruVHJBoy94GQt+aI0ayJa9ikyz0mVfq9ogn4Bvz567WiYUJXimaZi9P96BW2v8R4To92HKW763MmBKXPWt6bPS8CM+SxByGQGtd06ZUXKlsi69FMPSFrmwPUIaivmkKP6x7bBqt6tnk9l5CsasyyEn8x+cxqDD8czGEYZkXqfnAnZNI8L+/2lQ2Srjzc80Cw/jxl2Dbe1pnP19NILHElT0FOW247+Nh8u1+o2QmfIMCBmUHlxIuKAv6A8JFD0BxKvoZg1o1O4qrCv3ELwZpx2GdLBlqdlpAfYBrbL2kS0paTTlSic76XYbNpH0i/rfXh/T9QqnyVyN6tD4N80wnacS/Ye163onnXGFoWKd8dRucDBfG6CKxPzrCM9UHoLnvQDdDCZQpUy+21OiNG8DrQXoAyrUWD3cGREQy1PxATFxkBqcjaqbFGKW647mG2wSr89gnXkpzSn514SxjeDs4wsFe63aiY/Qc
 gY322mOd
 K9dV9oRq+FuyLbhv55VmPyhA7vwJXgw58Q2v4iHncvmeSkdfq7OtRP0ILmYi3g0EoEN01tKOdKauxVnEaNV+6GbP6vldC+ipWgquE94HCG8IxOw2+r97wpqUyIZmwae2mi9aVrhwwzElHt7kKWBTS5NC1R16MjsX4mkTUwJZV1NCB+FOktPrc4nsepgRjaCYvn5XVDfmVYatPRSRUu7EqDJ4NScip11rr/Y22kU72eMTVYS7SbVEcJ7Ki8y1uT4eD/zypAm6OjNmxLr1zJwrBzUeOx3/SGvLoFzpI0hKIxDBWyXx3qfBMfcBuK+SOehKWdSo+epLr3kcGhemQyqH7WujgzNYMcsw+eEwk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 14:06, Sourabh Jain wrote:
> 
> 
> On 18/12/25 17:32, David Hildenbrand (Red Hat) wrote:
>> On 12/18/25 12:41, Sourabh Jain wrote:
>>> Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
>>> default_hugepagesz) when hugepages are not supported by the
>>> architecture.
>>>
>>> Some architectures may need to disable hugepages based on conditions
>>> discovered during kernel boot. The hugepages_supported() helper allows
>>> architecture code to advertise whether hugepages are supported.
>>>
>>> Currently, normal hugepage allocation is guarded by
>>> hugepages_supported(), but gigantic hugepages are allocated regardless
>>> of this check. This causes problems on powerpc for fadump (firmware-
>>> assisted dump).
>>>
>>> In the fadump (firmware-assisted dump) scenario, a production kernel
>>> crash causes the system to boot into a special kernel whose sole
>>> purpose is to collect the memory dump and reboot. Features such as
>>> hugepages are not required in this environment and should be
>>> disabled.
>>>
>>> For example, fadump kernel booting with the kernel arguments
>>> default_hugepagesz=1GB hugepagesz=1GB hugepages=200 prints the
>>> following logs:
>>>
>>> HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated
>>> 58 hugepages.
>>> HugeTLB support is disabled!
>>> HugeTLB: huge pages not supported, ignoring associated command-line
>>> parameters
>>> hugetlbfs: disabling because there are no supported hugepage sizes
>>>
>>> Even though the logs say that hugetlb support is disabled, gigantic
>>> hugepages are still getting allocated, which causes the fadump kernel
>>> to run out of memory during boot.
>>
>> Yeah, that's suboptimal.
>>
>>>
>>> To fix this, the gigantic hugepage allocation should come under
>>> hugepages_supported().
>>>
>>> To bring gigantic hugepage allocation under hugepages_supported(), two
>>> approaches were previously proposed:
>>> [1] Check hugepages_supported() in the generic code before allocating
>>> gigantic hugepages.
>>> [2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes.
>>>
>>> Approach [2] has two minor issues:
>>> 1. It prints misleading logs about invalid hugepage sizes
>>> 2. The kernel still processes hugepage kernel arguments unnecessarily
>>>
>>> To control gigantic hugepage allocation, it is proposed to skip
>>> processing the hugepage kernel arguments (hugepagesz, hugepages, and
>>> default_hugepagesz) when hugepages_support() returns false.
>>
>> You could briefly mention the new output here, so one has a
>> before-after comparison.
> 
> Here is the fadump kernel boot logs after this patch applied:
> kernel command had: default_hugepagesz=1GB hugepagesz=1GB hugepages=200
> 
> HugeTLB: hugepages unsupported, ignoring default_hugepagesz=1GB cmdline
> HugeTLB: hugepages unsupported, ignoring hugepagesz=1GB cmdline
> HugeTLB: hugepages unsupported, ignoring hugepages=200 cmdline
> HugeTLB support is disabled!
> hugetlbfs: disabling because there are no supported hugepage sizes
> 
> I will wait for a day or two before sending v2 with the above logs
> included in
> the commit message.
> 
>>
>> Curious, should we at least add a Fixes: tag? Allocating memory when
>> it's completely unusable sounds wrong.
> 
> Not sure which commit I should use for Fixes. This issue has
> been present for a long time, possibly since the beginning.

I don't know the full history, but I would assume that support for 
gigantic pages was added later?

It would be great if you could dig a bit so we could add a Fixes:.

> 
> I also noticed an interesting issue related to excessive memory
> allocation, where the production/first kernel failed to boot.
> While testing this patch, I configured a very high hugepages (hugepagesz=2M)
> count, and the first kernel failed to boot as a result. I will report
> this issue separately.

I'd say that's rather expected: if you steal too much memory from the 
kernel it will not be able to function. It's the same when using the 
mem= parameter I would assume.

-- 
Cheers

David

