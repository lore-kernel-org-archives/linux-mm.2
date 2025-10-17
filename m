Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A87CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D7D8E0035; Thu, 16 Oct 2025 21:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82CE68E0002; Thu, 16 Oct 2025 21:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7427D8E0035; Thu, 16 Oct 2025 21:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 620D28E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:46:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A44916049E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:46:04 +0000 (UTC)
X-FDA: 84005915448.27.DBE2DDA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2BA2C0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:46:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IBZqdZMI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760665562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAKLfnCjWpLz6SBHg7ZJemM91nvEm2nAdUCxZzhPE+s=;
	b=AuYNjslIEqglX99YDYr/NUwvYylHK2SZTTvEcH44AutfgfRjuQNQ+/Tfg2d/ZthZniHZF4
	dU13hfxuoS2cPCSCJrSwajodWy4YxNf6vvbQwFdEkpy+MQaQ6Zh/8qYRwyh7POqAUV7r2k
	LvDdMFwfXjPpofrXngMhYzi7sUUmADs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760665562; a=rsa-sha256;
	cv=none;
	b=ob3ZOyLs/tuQdqTEwCZdnrGjcVka55gerCvFzItDP3Skg8eGbrqpAALOOafXkcUGMF69kC
	zVO4R01DwrbH1DFflGb6Nw+y9iRm9BnGkTNZ3vHeKjOAA6DqGS4ItvTa4dYFnhmrWTGCEQ
	QjC5HCHuWc24/+FEfqTvj/jxjw2Ce/c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IBZqdZMI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760665562; x=1792201562;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=STs8Y+GLuT3+amxLmUST+PZ8gj8KTQE9Glui5npCtTo=;
  b=IBZqdZMIR6JyI3/Ne/QY7hujicEiWg23kfoNXplmGu9MrmNX12V1LtP5
   rOpH3p4SqfX7XUcAlkTKG7x17cHJL4DJzarKo36leaOt3IGJ6OlkJ2Y4S
   2UrUaO3E28V45ZvyRgSyx/PWjk4/PfLRqaJfnku+KWyg1P4u036yF7iHN
   3Rs1n8RP5f6/0HFyP4xHc0NAunpyEAWucEHNpw8R6a1erQ1Tmem3HZyeb
   yvqyjERcxdTLDaCHXm333ouOqvyQj4RUxwApdfOi8dg3ctrHwHxIN4Qe3
   02S9FGIilpquLrGxRC6k50AP2ZE2dYe56HGnPJpBv9W2f/0J+NtMldgPk
   Q==;
X-CSE-ConnectionGUID: Ap3cbfwmQf+9OV77C3XEkQ==
X-CSE-MsgGUID: bBiHj9LVS9aMsQl2CcEzPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62082046"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62082046"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 18:46:00 -0700
X-CSE-ConnectionGUID: VLbXrEyqS+mO5QoMlH6F3Q==
X-CSE-MsgGUID: YKaojFyXR1qwVxffdSsIwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="181744500"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 18:45:54 -0700
Message-ID: <11cad2be-9402-4d45-8d2b-c92d8962edfc@linux.intel.com>
Date: Fri, 17 Oct 2025 09:42:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
To: Dave Hansen <dave.hansen@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jann Horn <jannh@google.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014174339.c7b7d2cfb9f60d225e4fe5ec@linux-foundation.org>
 <6b187b20-6017-4f85-93ac-529d5df33aa2@linux.intel.com>
 <ecee3200-c8e2-47ec-a219-c88e8e905b32@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ecee3200-c8e2-47ec-a219-c88e8e905b32@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C2BA2C0002
X-Rspamd-Server: rspam02
X-Stat-Signature: 8byosmqmobofh47geooah5k7ekczwhm7
X-HE-Tag: 1760665561-449956
X-HE-Meta: U2FsdGVkX1/IALCuEHDeoZRlIkMBBBYLB8aT29SfQl5mPr3QWndW8uzbZk69GdYqH/uGKAq/nz6ojBzkibtFxHIICFHTz+mVYh3uCWFeXwgGz9lJSoKhwdk6fFZ4v/WO6RdfEqDSC+01GBAuGfuwOpmiHssW5+OgOmPU4A0YrsunmPUNqOM0wTSL92+fG1+CchAAGG0wQXFbQUzkWSK89OVuibENU4f11XbK7+gwbZzO+EuzmapZDYKe39ZmVYZGTfYwmOr4iv/Z4mNR8BMnemCBebdeHjXUTrSmsO9MEIlzzgLVCn83gt4pLYLWE2Gdkwt3PTi2DaaaDGkxC6h0a4r5OdtduE973YUnJJH28GUAMJ0Gi5F3H+WEdsaA7u+OiJPv2OlUGdN1hVtuniDZe/Dsg7LhCFAOOotCTpvUIc9sAOi45WM2Co+nlPpMW32kGWHqB4K4sTFGDK/V5apqfKmg7aeTZ12TiXF9kFzNi+JnpTKrhBRMVIa9yIwf+2VLoKslq2pxfho08AwzGdv6FVjx2qKiMtx11nJpUPid2+SWoh8uPkKXJVmy1yv2zi7fJAGhPs/7GUtUUCd8sA9ZIBYzjf6aBDVJdCT3wf1uPVeBsLS8oUd9gWfAeAixPngerzilykz2j1VxWHoH4vwhicWdpgmuaceL4UnvKVEOV8CrOTtYAteknGUlJM4ZDLYJ2c9sxsbFsVFGFu630Ev/oUacFvxSyk7he2fsz6kuMnMgMRboh72gga4k1RERMAzQPtQpSJ6C2schpTUuoZ0bByFx3fQltiUNn1Wj5e+p8tao6YAHNu0ki38cE7pH9XbNXGcCHEjr1QYaPm9ovpFVylEWlfxHKPXjCYiu0XcxTSp8H0BdXrv9e+kYZuPtaPWnJuwR/jDiGx9PoVp4XiCE6HfKCRTO2bKN0qvi8/+xR/zPMYarF0xg4tfkb0+aTQDiqsnn3ZaCHmaHE71azeJ
 J0DKqNq1
 +g77few5MFKeAuo04dUsjgGZjzIomaA+ue3j5p9nF1f53Mbt5U6s/u1VeCoXVahwulsQO2+LI1lsiKqff0hQuZkO/7eC7HbqKrn92CzTnorjq/yefz2Bh/qN8qULdziJV9dIdhSlqXyJWSjzmGtiAk1jsWWuKftVo/9EkkLKafi90eLxrzPcXn/R0epbd5veCcpxjl+mAnm1nISZPIVBq2InBQ6lGzhr7RtlB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 23:55, Dave Hansen wrote:
>>> Only [7/7] has acc:stable, even though that patch is not at all
>>> backportable.  Please give some thought and suggestions regarding
>>> whether you think we should backport this into earlier kernels.
>> Yes. We should backport this series to stable kernels.
>>
>>> If "yes" then the size and scope of the series looks problematic.  Is
>>> it possible to put together something simple and expedient just to plug
>>> the hole in older kernels?
>> Squashing some patches is one way. But would it be workable to backport
>> this series manually? Say, could we send a pull request to the stable
>> mailing list after this series has landed?
> I honestly think we should just disable SVA in old kernels at compile
> time, or at least default it to be disabled at runtime. That's the
> simplest thing.
> 
> The other alternative is to have arch_vmap_pmd_supported() return false
> when SVA is active, or maybe when it's supported on the platform.
> 
> Either of those are 10-ish lines of code and easy to backport.

Hi iommu folks, any insights on this?

Thanks,
baolu

