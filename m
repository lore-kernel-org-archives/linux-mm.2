Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 556D4D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04036B009F; Mon,  1 Dec 2025 13:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3D96B00A1; Mon,  1 Dec 2025 13:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3526B00A4; Mon,  1 Dec 2025 13:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 836BC6B009F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:32:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAF24130646
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:32:47 +0000 (UTC)
X-FDA: 84171748374.05.D649310
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 04781140015
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:32:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bdEAf+gF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764613966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Lz7LcxHyIqMANvfwO6gmNGEqEyrQp6i16FlSTgY1DA=;
	b=cEiFWEh03Mm7E5sns1pVSZZ2kEyqJjrWhLUspl43wSQWlqPlltPSJGBRZlHnDZ36MvLkpN
	UNqUfXSfaBjGZ4GLKaard+bpqFpKqwJCDsICUwemsYfnbpfT0/DSE7gK22YD1X6Me/FS5q
	zK+HeQnN9hrHX1bd2PAGks0euIESMvU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bdEAf+gF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764613966; a=rsa-sha256;
	cv=none;
	b=CRObsCaRo+xdUf3cKS1CI5DXoyxZSaP/9hyjetE6wgSGZ1jxJ0jXKODo3FiENj9ADXZv5L
	KyIMOgPcrtGgNuEXuAF6BneRLG4HEqIT1wSodDR5b3mMuWZAbJFO8IPyTRyeMzS3u+5SOH
	DXEn8aB3mum2kH1w1S3K/gseZqY0IeA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C3D860159;
	Mon,  1 Dec 2025 18:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95955C4CEF1;
	Mon,  1 Dec 2025 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764613964;
	bh=2IfzNXSfzN92nTYZTzGsXr1fBjpjDfpWrXwW0YZPKmg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bdEAf+gFID+PrIxA1/+WE4DYDfDJBXtzv1cVw+nJIpuZeM4V7UDOI6jNrBiUD+JiU
	 Do/ziqGJ20sAbyjbWPOYm7gpCJsOOaoO0oOY3Q/c/n2u2g3F3WkpuCK+tGySIpJ7/a
	 4bHtVR3xPkyARb5tRlMwGubNri7MqXAER1PYHxOrlxfT978nc0ysn8YYAyDp0R2UJa
	 ylvgL0h8z4rxROQi+p/OmfAf/EI5TUidCbLe8wG4JDv0gCn34+s5WqaQzw9lbi9t+0
	 YB+7uvR+JnDYAJVwUa/iKVshebyq9AUbnu27D3pI2QqNfHXVsrtP4EF6cRnIBRZw1w
	 svVlqTs6UAx3g==
Message-ID: <052d7f47-edb6-4978-bc9a-c7eae469720f@kernel.org>
Date: Mon, 1 Dec 2025 19:32:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: Borislav Petkov <bp@alien8.de>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>,
 linux-mm@kvack.org, linux-coco@lists.linux.dev, linux-efi@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
 <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
 <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 04781140015
X-Rspamd-Server: rspam11
X-Stat-Signature: sq51jj5ptd1gkij4kj14naezkj657jyc
X-HE-Tag: 1764613965-513083
X-HE-Meta: U2FsdGVkX18b2Pgc1zB9T+pv+8OArTyq7jTf0BGy+VeVcsqRUiE6b6p1hPBs6YmN/BUTASOfCZIk4HnP1tAGuV628pHUogCL89VtR7esKr6RYHEAEwLIRtkXUfH+xQfGA8I6qsW2FbmZLsZzmvtnh0RNqE4O3y4jjQ4525+bPCvBuMZO9rumlcWyy3Fa03KkkqK7qeFnxgpKaUxp4AHYHDAywWepctAS6hwxasWBto4VcDe3UkuFUe4243TYYPOWyjILCd2IY1VQPm1e33GHaJZx2Ngw8V1EndAFs6TjzNb4X4Rbxw2DmmoCVzsu7x7EJTFizmaD+e/ab75Ql8UArPeBEJsyqe99CsG+sh/Xwh3zyEHxBXp6L00CXYIo7Wg36lOb7/qaCw2joXPwI93P3ag1aa6ieCD/Bjt4lAN5x87HkAOPWnbuMbMKLA6u7JLPg4+e4L9js0sj2GPr4qNxcbSM6fm2ThdbkNDlgVNx7lK5q7I93XoJ9eiPzBnFPm2oWplL0aXnOadPEmxU0BU/iiUI1b16znt9OZmeVvV56gWYptwW2YDRqpK1Nrqj8VutS9l7zTB78mKq9ECD6O4XV+lAKhQ7AIpaceA5ccNaZAOt3K6UmNIjfoEWyvm3dvYm6j8Rlfc7SoBI9AT5LPN3HO3bEIwQ2daZP5ctjJp9vYMrJLXlIB66QWnmwESdK2TJETIoTA7aSRZHgyFgjADf6f6Y3lJr7aIYmooqifLQj+haUNJ/8N9nTnBp5fKhiWyJdGCintRABNCVLrWof2RxPavhhCCviPxayH6nXx75oD3oVFfSEcefU6IraS63hR1LElB3MyvHf512kRhsZ/9qPYeqLMz/xs/g+230jUe2Czzrs2CR/PQ63ByNH9YlmwduIj/yhEYsNdTZc5uMbUq7SedodSzvTK7q6jkbYo2SGT+5YMIy33+RBQVET+dEZ0horv9GAa21HlTrI2AW25K
 dbxCK4q7
 Qt97v9rmLmANsynRQbgRH8T0BiMMAs0mnogJmhErNeNPy3FL7WRHipvSr0s+wIvhVKv9Qhi9U2GO/Guur9D/3ht3mf/AiHTSfjdprMHnKjTAOG/YFPslAC1Zz2EO7eQH83AOrNG8UfQZYyMu5rzNbZqCmzK6xLJTpuyTIb3zu7kXNgNQ7VtJ/AoEGG+JIFeq56WPGjAohVeLeTqu+fo2M0IrasuUDZ0e9rkDL8lDqeW2UWCeP1KzxIr07PMMvk0mqBtro
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 12:12, Borislav Petkov wrote:
> On Mon, Dec 01, 2025 at 10:18:37AM +0100, David Hildenbrand (Red Hat) wrote:
>> Makes sense to me, especially for confidential VMs where we pass such
>> kernel-managed data from the old to the new kernel.
> 
> It shouldn't matter, right?
> 
> I think the question is whether the kernel should agree to the software
> contract (/eyeroll) to keep the kernel ABI compatible wrt kexec.
> 
> And I don't think we have agreed to that AFAIK.

I think we are in agreement: from what I recall, this software contract used to be
rather simple and stable.

Looking into the details, I guess it's all about

$ grep "define LINUX_EFI_" include/linux/efi.h
#define LINUX_EFI_CRASH_GUID                    EFI_GUID(0xcfc8fc79, 0xbe2e, 0x4ddc,  0x97, 0xf0, 0x9f, 0x98, 0xbf, 0xe2, 0x98, 0xa0)
#define LINUX_EFI_SCREEN_INFO_TABLE_GUID        EFI_GUID(0xe03fc20a, 0x85dc, 0x406e,  0xb9, 0x0e, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
#define LINUX_EFI_ARM_CPU_STATE_TABLE_GUID      EFI_GUID(0xef79e4aa, 0x3c3d, 0x4989,  0xb9, 0x02, 0x07, 0xa9, 0x43, 0xe5, 0x50, 0xd2)
#define LINUX_EFI_LOADER_ENTRY_GUID             EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
#define LINUX_EFI_RANDOM_SEED_TABLE_GUID        EFI_GUID(0x1ce1e5bc, 0x7ceb, 0x42f2,  0x81, 0xe5, 0x8a, 0xad, 0xf1, 0x80, 0xf5, 0x7b)
#define LINUX_EFI_TPM_EVENT_LOG_GUID            EFI_GUID(0xb7799cb0, 0xeca2, 0x4943,  0x96, 0x67, 0x1f, 0xae, 0x07, 0xb7, 0x47, 0xfa)
#define LINUX_EFI_MEMRESERVE_TABLE_GUID         EFI_GUID(0x888eb0c6, 0x8ede, 0x4ff5,  0xa8, 0xf0, 0x9a, 0xee, 0x5c, 0xb9, 0x77, 0xc2)
#define LINUX_EFI_INITRD_MEDIA_GUID             EFI_GUID(0x5568e427, 0x68fc, 0x4f3d,  0xac, 0x74, 0xca, 0x55, 0x52, 0x31, 0xcc, 0x68)
#define LINUX_EFI_MOK_VARIABLE_TABLE_GUID       EFI_GUID(0xc451ed2b, 0x9694, 0x45d3,  0xba, 0xba, 0xed, 0x9f, 0x89, 0x88, 0xa3, 0x89)
#define LINUX_EFI_COCO_SECRET_AREA_GUID         EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
#define LINUX_EFI_BOOT_MEMMAP_GUID              EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
#define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID     EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
#define LINUX_EFI_LOADED_IMAGE_FIXED_GUID       EFI_GUID(0xf5a37b6d, 0x3344, 0x42a5,  0xb6, 0xbb, 0x97, 0x86, 0x48, 0xc1, 0x89, 0x0a)

Likely the format of these section stayed unchanged over the years.

-- 
Cheers

David

