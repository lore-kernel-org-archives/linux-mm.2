Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0D6D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47706B002C; Mon,  1 Dec 2025 12:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F216B002F; Mon,  1 Dec 2025 12:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934986B0030; Mon,  1 Dec 2025 12:39:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81D0E6B002C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:39:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3607E131DFC
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:39:38 +0000 (UTC)
X-FDA: 84171614436.11.993EA2B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5C42B14000C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:39:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cv7fKSdd;
	spf=pass (imf09.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764610776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzcNdmIwT7Vsu9cnMG8pd2nZYPA0esxbvkyxxOlhdgg=;
	b=BR01FT6MlDOJxl4NMe/pNtXvc8aOUoppEftTD7tSqrAsRFa/zOJw1r5m4VdO/By1iuqri3
	+uY6TETx5rSK+zwpTqAPpegi415JwdXuXIKlxsGdxcLCRMSqQx+PjYgD1cWCVamANCYPBz
	ed6VeftSLAl3okzvOqFYcV+GSsGw9/g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cv7fKSdd;
	spf=pass (imf09.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764610776; a=rsa-sha256;
	cv=none;
	b=P2s/7PZIhv+Yc8l8/RA+e70JQUdVmbwuzRirQvqZtYBlJP/+hlERojtWq3jrvomSc2dAvK
	qzJ7F18jg2slkvGctTm2rWCx/7HfbI9vStQgoT878F253PhCkT8aE8dpRyyAtAT7qvgcob
	Egoyyo0SPqSLDaz6xCZBInH0RybiRQQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764610776; x=1796146776;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q4Tne7+Z3cnF9CErHyNzETIaPtPF3wDSr+O1s+ZenOY=;
  b=cv7fKSddD9C1KXN3o26G1ZahAIRjSOZv9Rz7TgvVKe3lCeWUagk/naJb
   h1eB65NzGKj5AJpIdIxZTSvXigHP57+mBZ6IPGzIRVLP9KltRbj5wQQ9q
   WbcaEW+DdTaG83Dml/xw8C4AEXM4mBTfX4naY45PqiqbYYlzb70w8Y9cW
   IokAnFucKZ+x9E9aqSdnNx7ipm5MTeM/E9Hqd1mDkShNfcDfq2J0OLT8g
   602N7vIEae3j3gJ9JTk2LJrYgrvWpeAM7X+p6s5Hy5OcQOXWtpl9BHezt
   2i+/vjzLWsPF8gsdUyoS/meg981zRhy0L/6oePhSnNpYRgpE9afUO7muI
   A==;
X-CSE-ConnectionGUID: OvxgpYqxSdm8Dagy4B0VlQ==
X-CSE-MsgGUID: I1m5X6XNQ+yjyp6M4mUBzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66452794"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="66452794"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 09:39:34 -0800
X-CSE-ConnectionGUID: HWl2HESBTIygqrvRGVBfYA==
X-CSE-MsgGUID: HszrL6w+RcCQ+Ni0oXKbRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="231443296"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.111.117]) ([10.125.111.117])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 09:39:32 -0800
Message-ID: <2d4fb1ce-176c-404a-852f-987a9481046d@intel.com>
Date: Mon, 1 Dec 2025 09:39:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/kaslr: P2PDMA is one of a class of ZONE_DEVICE-KASLR
 collisions
To: Dan Williams <dan.j.williams@intel.com>, dave.hansen@linux.intel.com,
 peterz@infradead.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
 Balbir Singh <balbirs@nvidia.com>, Ingo Molnar <mingo@kernel.org>,
 Kees Cook <kees@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Andy Lutomirski <luto@kernel.org>, Logan Gunthorpe <logang@deltatee.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
References: <20251108023215.2984031-1-dan.j.williams@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251108023215.2984031-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5C42B14000C
X-Stat-Signature: hox89j4kh5r8rcomrmyc7t49mugs9hfu
X-Rspam-User: 
X-HE-Tag: 1764610775-834397
X-HE-Meta: U2FsdGVkX1+HoUhNbqSQX1EA7cHXSnL95RU3CYo5c5KoNLWvtelYtEnAasWcCCp9xH26GJVWFtuAl2fEGla31QY08l4kgWWxQYOC+nGBuCzMeq9qXAIofewVJciXiHt2OPPysT23ItT4F7aqPcohr3gKDct8KfYNSOUR3FdoFnln0qAvnzI4aX1mcQdshmSQyG0vt9qJff/SdbkNviXYfKbHa6Bk/oceTPReBgqP6aSx9TcXFXzfdTsnZg/g79I4KZUF+pvK/M+nd0u2Kq5xhxWIerUl4xBb79Gx4Y5UC6/Ddmzz6lq4W22nRRsd8a/1w6CckuWOVeDYbAvOieWQqMMXOvrOvZNvZ5ADAAMariFZke+m9wJvU5Q9eNked1Eeid9TEoq2TIW1ZXp/enFTx3jglDLaSzGorItkhmykYNBUGBwOb38XZNYyxoiUzUuEBdgUhxdeqgvUnfzkp1V4ad0FGYusb8a9uGfsx42PiKky666sp5iex7HKzyWGNBbt6KAydL7oPL0jNfrizMFNA/1FXf59nTZdSUV2DajAgHpTXS2zMhrcus56vAqS+/ISxzAowQfA3oBH3EBohwpygyhPgp/q8d5SYDO/DeI3u37hfb79g0nOpXKIQK7P/E5CSjFazHWLORsu+daVaETdV/8teraf0YGXOtdo3PyD1QuIrAItdNNLsT7whEgc3dw+0iDigEo3Lg7eRn713CH2N+dWdaPcOVFLx2hQE7bgqgJAOXaOotmZ0zlUL23j4tmsIuVc/UClxYgMzneRJhvXLTq0ZJNWOP9XvkF9H89VtDVMEhOACPnwV6YVvvImuBjDVlXdZ+B5AC3buSmFFFguHkrA3NZgb+ougZXw8BN5LlvMO83ZnngMdU86zkpp25hdME6Pl2WtZ3kP4eSymbdXoGX7sBTZumpqhg0xljZvbVFzz2pb55VE2Fw9Slbabdley66XUY2MpzL6bQCP6Hs
 uUyyKVml
 rRVaPqGpslGr08/bNb6I8EGn8Ham3DzUT4hFfRZWYKUwLDtpr0N6VsJyUusdCIfITFPpz9sjdLcKK7hXPxeaG7YRxySa3Th5VWGGd/iVluJ+L9/ZbbklVbe2V3qwEaTln5ZPt7+NhmS3Hohm4aJZVUbhZfGOLQ+XiTBUJA90JMz0hglXIX1np7Fur2xp0C4GMf49bJJJYs/6hTSzbUB5NyEy8VgHJ4zM9M97GiUma+CR/ayqs1rfJvcjAa+8WAShxHUpXDoQwAN/b2r7YdM731+//GlLQO7mnofOSrkIRbR5jx7k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The subject probably wants to be something along the lines of:

	x86/kaslr: Recognize all ZONE_DEVICE users as physaddr consumers

On 11/7/25 18:32, Dan Williams wrote:
> Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> is too narrow. ZONE_DEVICE, in general, lets any physical address be added
> to the direct-map. I.e. not only ACPI hotplug ranges, CXL Memory Windows,
> or EFI Specific Purpose Memory, but also any PCI MMIO range for the
> CONFIG_DEVICE_PRIVATE and CONFIG_PCI_P2PDMA cases.

This should probably also mention the fact that:

	config PCI_P2PDMA
		depends on ZONE_DEVICE

It would also be nice to point out how the "too narrow" check had an
impact on real ZONE_DEVICE but !PCI_P2PDMA users. This isn't just a
theoretical problem, right?

> A potential path to recover entropy would be to walk ACPI and determine the
> limits for hotplug and PCI MMIO before kernel_randomize_memory(). On
> smaller systems that could yield some KASLR address bits. This needs
> additional investigation to determine if some limited ACPI table scanning
> can happen this early without an open coded solution like
> arch/x86/boot/compressed/acpi.c needs to deploy.

Yeah, a more flexible runtime solution would be highly preferred over
the existing solution built around config options. But this is really
orthogonal to the bug fix here.

With the changelog fixes above:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Oh, and does this need to be cc:stable@?

