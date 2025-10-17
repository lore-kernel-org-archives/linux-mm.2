Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFD09CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577A98E0029; Fri, 17 Oct 2025 13:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F6D8E001F; Fri, 17 Oct 2025 13:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E178E0029; Fri, 17 Oct 2025 13:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF7C8E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:05:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBFAF1DF179
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:05:35 +0000 (UTC)
X-FDA: 84008232630.18.4705611
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id 23707C000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:05:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d4bqOC7R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760720734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xau/di8dHoV7rfStQMoXpw4yp7gRe6aUdJC4UQzxpuA=;
	b=Taqyr8AkXYXHr+uSE/i4X+1boWCslbNkH5erukCWlyCIg13VnGu81ABnUDWbvzlgIWCYpZ
	3YScLOUSn9cXcqz5hM/t9oF7fBWTDUQZmSYTWRztHloEj7jjCaQa6yA0qyNewYj7G93bP5
	zxVeq8nkotaDMHureaReCbtqmp+201g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d4bqOC7R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760720734; a=rsa-sha256;
	cv=none;
	b=AB6cI1iuEF9S9ezTNTmp2VYht/LVgeobtis/Ixtvivbps5l/S79tW+1AF+K7iWgjqun6/b
	vpw+PKwVEIxS3EHqMMAKin/sE42YG/+umKkz66yQjgfi/vXRw5jotI1Sbtz4fh6JNc5Q0T
	HduN8FOyhN8H0cd4qN+3VKrdZEHDb8M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760720732; x=1792256732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xau/di8dHoV7rfStQMoXpw4yp7gRe6aUdJC4UQzxpuA=;
  b=d4bqOC7RYafymhSU1vrWNM4B/A8RDIdwn6/OLP3GS3qLe97T3gmz0AAW
   nIbwwe2ZY49WZXTBVrIZQjQFSVPpw5ufYQwEl7TVO6UMcNsdKxLeRRhDZ
   zsaGW0IdmOgfXWaGiEU1BLEmzwq3Vwy8kLZiLHTr7tZjOLwfRtSNF5ZUI
   XPFc89oc503vSDr1J5Bivo4UyQXpu26QCSTFjd6VV9Z+UDIdpLjJ9BV/N
   ueAul+LwplIcvekT6obAEdRFd3z5KMkSzRrc1K/IWZd064fGLfziIpOdi
   53w9kq902pMJAEf/t3wCBPz/QoJD/yMHOBa7SR6/8V8RV8rf1k8AN92t8
   A==;
X-CSE-ConnectionGUID: FYH0mflxRK6K7dLS0+wHtA==
X-CSE-MsgGUID: iXdKk7C+TBGi4EuSw5TcjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11585"; a="88407053"
X-IronPort-AV: E=Sophos;i="6.19,237,1754982000"; 
   d="scan'208";a="88407053"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 10:05:31 -0700
X-CSE-ConnectionGUID: wv14bvpDRaysAp063ScWFg==
X-CSE-MsgGUID: 2JORsTsMRYCDyk5UOPg6Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,237,1754982000"; 
   d="scan'208";a="181970680"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.108.40]) ([10.125.108.40])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 10:05:28 -0700
Message-ID: <f170f6d5-a1f7-4dde-b966-6d6a5aa18f21@intel.com>
Date: Fri, 17 Oct 2025 10:05:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: Baolu Lu <baolu.lu@linux.intel.com>,
 syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 dave.hansen@linux.intel.com, david@redhat.com, iommu@lists.linux.dev,
 jannh@google.com, jean-philippe@linaro.org, jgg@nvidia.com, joro@8bytes.org,
 kevin.tian@intel.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org,
 mhocko@kernel.org, mingo@redhat.com, peterz@infradead.org,
 robin.murphy@arm.com, rppt@kernel.org, security@kernel.org,
 stable@vger.kernel.org, tglx@linutronix.de, urezki@gmail.com,
 vasant.hegde@amd.com, vbabka@suse.cz, will@kernel.org, willy@infradead.org,
 x86@kernel.org, yi1.lai@intel.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68eeb99e.050a0220.91a22.0220.GAE@google.com>
 <89146527-3f41-4f1e-8511-0d06e169c09e@intel.com>
 <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 23707C000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 33frnnk8kmto5e4m55op1dmofb4mh431
X-HE-Tag: 1760720732-345309
X-HE-Meta: U2FsdGVkX1+0EOO5xhF+wc9szjrGF9rP5XmUkoPqSA3k3rRuQaV4LgDZdOYGA4blIScGeCcTs309grHVQrD1+2ZNaskbAM91/xndL4N6oHKBLZf8OyX6QqiwlJULeopl1g6X/9dcRBbUb0hGKXqPl8S0bOogRzEvvs61gu1dgfEHnP/bpFfbT1CxG1kfjOFl58b7YAqeN4sNNsDb/8RonPhFGjgbcukXOTUZ+x7LBQwY4qWR+oLeW5ahbY5K2BhTNAhWraWbmffMrdX8d9+Y7sXBWd5luu9bB9euJyMEHkf0FQvZQPyBbqKGteE4B5/6OYa8SqqawLVCt1463pUTK99rFx/CRqcOhOW1ePJFvCEs7I22VYisGIzonOII/iUIBbd6pFilUU5MaUYpoLAjHk/p1bNjmqRcZwSGpuLB5vaa/oVlyyZEpNHHzRjtD2hODiurc2XxVQISXR5kTL/SB9GJ5EInzHHkhztyqmhBh5KRwAc15E/o2MoVwRxEaOvTDgxucEOge1mm57OuAR6xdjSswrmcPrzoYN9eAueEeZkwUJkMBA1JaWI5SL9Y+zc11oeW5KELWZ/66hR+KqBwks8aIBTNUv3iDbOIeDk1XqpHYn9mL12DZi0Ibt1pR1XRtrd8GRNGjlEzfec5629ceP/FEWlLstGbD0qtxiCKJSfEFuUMLk8yR2EMbJggVtQ2TL/dd1EVk/123Lnn5QLg6Hpx+tdYo465oNqMsvkeWbOMbT6sZZohziO/bDaXN/7A/IKFpxmir+aeWjn3DicuWfBjL3nnyATkZH5LgkEkEXewZB1SLZRj6345cz6WjwbcNcGVQeqWryNFnWHUXOdKU46uwSeZuvTf2dCloRyW7DViaMClRgAtqKLA/bqNDB9h/nUkFbs4uyon2d/TaU4lVmQIi8osUe4y6lAvLnb8splBUbdVN01Dr/hHo/0Mx77XPi0qI1Bc3Cwid2J5eYU
 n8ErQ+EV
 WT592
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/25 01:00, Baolu Lu wrote:
> while, in this patch, we need the page descriptor that a pmd entry
> points to. Perhaps we should roll back to the previous approach used in
> v5?

Yeah, we should roll back to what v5 did. pmd_ptdesc() is a bit deceiving.

