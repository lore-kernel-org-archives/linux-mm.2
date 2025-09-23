Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91BE8CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 06:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D228F8E000A; Tue, 23 Sep 2025 02:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD32E8E0001; Tue, 23 Sep 2025 02:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11448E000A; Tue, 23 Sep 2025 02:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFB998E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:59:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 403EF119C2A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:59:49 +0000 (UTC)
X-FDA: 83919614898.16.2C9C66D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 79DE8C0002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:59:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758610787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJV5ac6cESiciIBOSEsVCjKID3KMT5S2hqTO0fDTI4U=;
	b=RoUicq7SEyygBgAGc7v25DYOtnd2hdOqi6FtIKReVxRXBB+E6NYdluR0gGXqc/S5Y+hlnf
	OAtKShY1JDm0aEZjOYK3jv0lK5GCRfL8HePVQwgXnS5IgZ59N1cxxB+2xh5Kb+hNqUyTSG
	UKPIL8gwaWNCBtmzGd2BvRkAxol0ryk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758610787; a=rsa-sha256;
	cv=none;
	b=XumuxknaprgcHYfmRukaCIxmykIgqIEfi4GVSsDEVDY4kN7m7GBgeUQoC/ddGmIXN1ZfyM
	w+MpfFhLh+E8yAcwZUVkm7Zetv+OKhA1esl3HtQSIoeSSO+l1MWPIr4bQaR9sob1tn7h7z
	cRWPOxECgctPblXY2KgYGOsiIK5zS2M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B4D5497;
	Mon, 22 Sep 2025 23:59:38 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96F133F66E;
	Mon, 22 Sep 2025 23:59:43 -0700 (PDT)
Message-ID: <549fba84-72a0-47bc-a712-e9510c353551@arm.com>
Date: Tue, 23 Sep 2025 12:29:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/khugepaged: use start_addr/addr for better reading
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20250922140938.27343-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250922140938.27343-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 79DE8C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: z5tfju711mmannjqidkpfax1k368d7w7
X-HE-Tag: 1758610787-138731
X-HE-Meta: U2FsdGVkX1/ZEGNXFBux2VrwAhOm1wRW5qISKW38IxvrO3vqypij7TzToqxUEls5ysy2m/VyD0wF3OJIpj3E2Qj5l1062ySBIyWt80CCjGS61+Ixx68j5YoyseFCMxAFDlYn06DRZ31I2F15xbZxAVHRh8iLurnmWfCz/r+lUf6N6hJquhWbsNhVO5YLStInCH+VQrBPJkzY+PtwxL+Br/svD6Qyief/P35RMNq+RPS7+OhTqoBs9ZR0SNriji/nEBH2edyDZ/0UuLQkqbnr36aauDc/ENo2hl2QrLVm85LswfravvJV675vYp64mVKtelfAOSNsSb0qk4YDigAItLSbeDQsUnoT2G+S3w5vUFS5W6BX/g4usJ2wBCyDB+2dEw2x6aBtK2/ort2UdehJ2lOC/cDdkKNvk8BywKWvIuiInsVTXjpSZzEHjjoli4KAqb8826M1QzMAZKINzp+SlvCCfo2sJbvYJcJOk0V3xRTi4fePLVRjh1dMLRHQThDapRLBItlhGamW5VrEbTupavHhEK3NqTiZn39k8W4WPczv48nhbRftjiUap/ZUI54vFN51SrtvZk7hSgNuMnP9PU7zRydL0BY3/TheGqXne33dsNvsmTXpUXKiyyX5RdJzITTKJzOosL8ajnONJ+mHhGbv4YourLX3RQ3ZqwU3YjoyuF3C5Kkhm4L9BibM7BCp9+77gicVHXFBNluWXvyMik5xEYm9l8Aj4TL+S2iIA6WTeJLpV2XwfLbcERB4bjY9FjdtB+4qRp4DRiQptikFA8AAfomnSaQs8iR4Qt71EUPB7KhHP+JgbESb/RGW0mgvgAIlbIyUy2ajLbfKT+EWFBvzAZ88i/aDiAR8UVw4/vYlz/AmMNSod3x+4LkhXs0+FPSo+rZujwhOAxBg0IOnITQinujDz++dh4eLd+sAqSy4QGRUIp/GtmUYwvLbI1O1QeX2UtHd6s98W1R46Hn
 V/r1vEcZ
 2R4ytZzfiyXxYDuUoP/b5qtdyybE6Y754Gy2yP6mf5Z3CeElplmae2WGJ3Ye2J2umnlnfUEXOMsTB/3CiDxV2CofWkUJToZoXMB0H6w7lbKfdZk3oCNvGSPd/dacLGBWhixRhIzY6TfSkxkHuqRpOBWek/4JbUVrS7ZpYcSKbdtPadaiUlvAuCag1/wuo0hSWPyAVQ1LkZSwPpCH7UFPg5M/FINVuSnoKm1PfWVgxPbNRR0tMwBmYv97Um6rufq1YQuV9Jal2aDduKo9DamrXXbL/AnBRIGct9lvnxbiCFwCRl9HIOUYpzhvDEqXl557fPzYThXZEE68+qBfxbzaCK+0fLy6wRP99kCTiysob85ywW72+L+msfCYzLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/09/25 7:39 pm, Wei Yang wrote:
> When collapse a pmd, there are two address in use:
>
>    * address points to the start of pmd
>    * address points to each individual page
>
> Current naming is not easy to distinguish these two and error prone.
>
> Considering the plan to collapse mTHP, name the first one to start_addr
> and second one to addr for better reading and consistency.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


