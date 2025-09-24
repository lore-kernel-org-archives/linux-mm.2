Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF79CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DAF8E0018; Wed, 24 Sep 2025 08:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45C08E0001; Wed, 24 Sep 2025 08:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82A88E0018; Wed, 24 Sep 2025 08:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF66A8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:56:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A14B160855
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:56:25 +0000 (UTC)
X-FDA: 83924142330.16.79AA2C3
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B971140007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:56:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ntp/hWrr";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758718583; a=rsa-sha256;
	cv=none;
	b=BbNO3kqp4vY9i/p3+/ofVOrhQU58HdHgFgeoFhmZX5dPm/XDUF+2Ka05h/0DgWxFVjKM9j
	m0zxeYiPh0M2QqNJLmUcq0rv+MbBjIQKxCJJlhGzoFpNVU5ouFQ4PHjUSCy9R0oaL5HC4Z
	mf+4PDQ3059aSPUQQm65oiWCdwiM/x4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ntp/hWrr";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758718583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HigbfdhjwD2UMz4gq5kN4d1TQ2vXtHCF+rIKePduGY=;
	b=VPek1yhb64SbP6b+Drs4pdM6YNLq8n9nqkjMJkwGSg0MAjw5AM0H7EDI3Mewez1uguljR0
	Gigtcn4Meo+CYOujeic0hJH15Oda4TU0g/WC8wVMm+daStWeIPKd0phy7VBb8vGPTZwwg4
	4NRfaPQyqNURNJ6CipYVaxt5PNKkFA4=
Message-ID: <87bc9c70-a464-4990-947a-faacd4959595@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758718581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1HigbfdhjwD2UMz4gq5kN4d1TQ2vXtHCF+rIKePduGY=;
	b=Ntp/hWrrKFsBbDV2r+8W5nmoNNCDxDHPUgfKBqzrHXJvbdDhASAGZkRvJjuvLw/MyMZrBg
	f14jn2QyB4KtB8LXtGNYUNpgyHfKf7umVHoBv/lbtqjESmXAbb2wjPnXijYaFqRXcCV2T8
	4KHr6uA7MfTwsFQW8R8GBt/DEV3D3+Q=
Date: Wed, 24 Sep 2025 20:55:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] arm64: mte: Do not flag the zero page as PG_mte_tagged
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 Gergely Kovacs <Gergely.Kovacs2@arm.com>, Will Deacon <will@kernel.org>
References: <20250924123528.1536835-1-catalin.marinas@arm.com>
 <c07073f2-96b7-4044-94e2-b41a2f8ca633@linux.dev>
 <8006c8c3-8e62-47c2-9d0d-9c7183dcdcf9@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <8006c8c3-8e62-47c2-9d0d-9c7183dcdcf9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B971140007
X-Stat-Signature: 86iw3acns469anifud39h7c4itoajemx
X-Rspam-User: 
X-HE-Tag: 1758718583-495581
X-HE-Meta: U2FsdGVkX18IKDeCoCHtb0wYQdKY8LR5dI8WXE71edxGPOzN0CLs9pibxIMbcC2OmNK/ZtTp9+mfxy2hceoHoEyuk7K0leRsrmrdMvJE4ydFkd7dvKrqstBqx4fqVRvlscT2IEKZaBiqoWDFi30kmMWXV4F7r5Y1sm2IMFlWQAiQyeFV57J/9jsQUtjSLMTghM3LcX+ncFQVR6qDWfKgexc1NzQsad4rC6/kXxhuscO0/Lkf8BfW46B3mp1tGwqDzYiQnYgG4DYKv66OjA+PILbLog5fIJL33Eq3mHYXKupQlfUZzABiDRJLayx1DwkrZ7h/u8JcDdoVOVBVg2QbuNoIQpR8lM+2OMkWpdbGV/9/3I8fEor0KHS86a7ew06HOtHInJRIkHGX0QaoH/jANtwcGRoZLTfMCsImimDyhZBupqzpAFVQcj9JcwDHTinAc6Rqn2u3iq7Y+Tq3t/F8L52Wj+qHd6M5uj6wQym2pnxg5fUUxzdm9omveeteNMQJ78KdW5QNZh1/IbrXe0LJTdMhe0cE+NigGtg2jWmThjqLYy+rAeSWF6Wg8XakGupSkuuZ+9QZJKAHalP0aSnnNQ5UPanKYPEG7L8+5J4ipuiYZMmL3W8gnwU3uJZypw6qWwitu5tVsGHZfr7U6iLKN59GM5335/obtYQAXvKECpUl7mwWhG4vYsOCr8KVwEbijyS+FgpPYqDxFM4Th8cxZItLZFFnU1F0B0sStOE09Xeq7ivw7sDAUKwawUEnR12wcJLvriEGofscFc+ZsuGi1ubmE1x5hQNubx7aTf6KrXSrNx8AQxEH+fjJ8nHgwcYWQ8r7JEOdesqkgEyKewyHa+PJ1K6FKrn9+MhebZdJIeOTJ+Qpg5vOVHjPJExvHO9KJek1jxa8mXFP4xnVfqledeItDjZzJymklqXIIjxPdck+WbnP3vaSYHBVAqYCLJlUbgMlNFrKf3rpsd29Akx
 NRgccZ+d
 zCAF+xC84f8/24XylCgMeljEIwKg10E6x1jIyjIzLpdERVe+YKoKsNWnEd2RS5FwqAo+nf0d58A9fD7k2faSrH5iV3CKfBBLCRu3oycq9SBEN+snfiGSEM/yOYGryjWw8l82/YK8RLk2d6SDdNyVPdDOSf1HwOsi6bo1S79606ahiMsbPU850dO2RZQs+TXQvkTp1yuCmIxQ4Lq0MPzjxtkd2/x8PkoLMAXk3QCE9mKIWUfeg66YACs81DBk+SrJfBlgoIJSvC7DScdOR9DBWeQouiSFFuYoOd2VpJfLOJE8XeJ6jDkPSt09jlClJqaFWVrmandbXowa65/ZZlarSandV3PfEdiu7QjDzFsgtFQR6mv8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/24 20:49, David Hildenbrand wrote:
> On 24.09.25 14:48, Lance Yang wrote:
>>
>>
>> On 2025/9/24 20:31, Catalin Marinas wrote:
>>> Commit 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the
>>> zero page") attempted to fix ptrace() reading of tags from the zero page
>>> by marking it as PG_mte_tagged during cpu_enable_mte(). The same commit
>>> also changed the ptrace() tag access permission check to the VM_MTE vma
>>> flag while turning the page flag test into a WARN_ON_ONCE().
>>>
>>> Attempting to set the PG_mte_tagged flag early with
>>> CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled may either hang (after commit
>>> d77e59a8fccd "arm64: mte: Lock a page for MTE tag initialisation") or
>>> have the flags cleared later during page_alloc_init_late(). In addition,
>>> pages_identical() -> memcmp_pages() will reject any comparison with the
>>> zero page as it is marked as tagged.
>>>
>>> Partially revert the above commit to avoid setting PG_mte_tagged on the
>>> zero page. Update the __access_remote_tags() warning on untagged pages
>>> to ignore the zero page since it is known to have the tags initialised.
>>>
>>> Note that all user mapping of the zero page are marked as pte_special().
>>> The arm64 set_pte_at() will not call mte_sync_tags() on such pages, so
>>> PG_mte_tagged will remain cleared.
>>>
>>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Fixes: 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to 
>>> the zero page")
>>> Reported-by: Gergely Kovacs <Gergely.Kovacs2@arm.com>
>>> Cc: <stable@vger.kernel.org> # 5.10.x
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>
>>> For reference, discussion on page merging here:
>>>
>>> https://lore.kernel.org/r/aNKJ5glToE4hMhWA@arm.com
>>
>> Cool. LGTM.
>> Acked-by: Lance Yang <lance.yang@linux.dev>
> 
> 
> Likely you can provide even a Tested-by? Just saying :)

Right, so:
Tested-by: Lance Yang <lance.yang@linux.dev>

