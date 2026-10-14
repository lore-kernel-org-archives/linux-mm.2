Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EF6CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC246B0092; Wed, 14 Oct 2026 04:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D38F6B0098; Wed, 14 Oct 2026 04:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9112F6B0099; Wed, 14 Oct 2026 04:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68E3D6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:04:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72C26A7DDF
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:04:58 +0000 (UTC)
X-FDA: 85320495876.29.E487790
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA54B40002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:04:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=sYLTXX4j;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf01.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791965096;
	b=bWDiZnMLHcfqYm9FlDGwDwKLIYjmEvRDqEn6ceRIj6tYwHWItz/fHPZp3UW5vWaCMhy0ru
	vURYGSUiEaafe6hFV/Uss4bK6WbUX2tkXGleYX+MieSKXzrqkusAg0M8xjh8KYczLVv0l5
	g77UOoLS+wEubVkgHmArrhYiZfhxgFU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=sYLTXX4j;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf01.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791965096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUro6dOpqOZkLgIwXsmgcxwmdXRb9oPBkMDddypWdxI=;
	b=3QSdxEVoqv9YwnF2kFcF/k/r1OM6JD86tmLwm9+f8CJPpSRysaT0Hwu+CtQ7t6uf/u1yir
	RL1RrwUkBqlzCUzOw9aniIxUMox8qrbonoIgpVnc3xNOcPdb8Brob9u5jLbjGL/0+37MTm
	r0P3cwPYdsU/ke3gg7XAFJ/7EI4GrS0=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261014080453euoutp01c428e7ec73126aaf831afa48edb47598~eVsIcN_UP1298312983euoutp01b
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:04:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261014080453euoutp01c428e7ec73126aaf831afa48edb47598~eVsIcN_UP1298312983euoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791965093;
	bh=bUro6dOpqOZkLgIwXsmgcxwmdXRb9oPBkMDddypWdxI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=sYLTXX4jX0eYOunJVd7rJnsGiRdr/zInUJvJvtB7yc1gEsBQ1ynQSIKyUFV89jmFf
	 sVFhthw9dIdWYVU4hd7rNd/SA2RFvqQ25zBRPzrPpt/ieBN1HKnx0RocMHbtnPtOwU
	 4aRhWNg+R1wYx61CXgLOAGFSToXFE4S9/AjVYvHA=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261014080453eucas1p158cc49f0c63d9419059a2228a44c0a76~eVsIQsCC52533225332eucas1p1G;
	Wed, 14 Oct 2026 08:04:53 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261014080452eusmtip2b271c365d5fbcb7f579007b96b7e0073~eVsHlyttp2605826058eusmtip2i;
	Wed, 14 Oct 2026 08:04:52 +0000 (GMT)
Message-ID: <15f70a45-a754-488c-8ba3-9e63bb956033@samsung.com>
Date: Wed, 14 Oct 2026 10:04:52 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
To: Wandun <chenwandun1@gmail.com>, linux-mm@kvack.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana
	Kannan <saravanak@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <42cdc3f4-95f7-4efa-be23-b3fafae84109@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261014080453eucas1p158cc49f0c63d9419059a2228a44c0a76
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261008152450eucas1p1d5517eadc2c1d684ff6d4ddc010f6331
X-EPHeader: CA
X-CMS-RootMailID: 20261008152450eucas1p1d5517eadc2c1d684ff6d4ddc010f6331
References: <20261008152403.766439-1-m.szyprowski@samsung.com>
	<CGME20261008152450eucas1p1d5517eadc2c1d684ff6d4ddc010f6331@eucas1p1.samsung.com>
	<20261008152403.766439-3-m.szyprowski@samsung.com>
	<a8ac6daa-e721-4cba-bef3-3333643db23d@gmail.com>
	<81d6c6be-d03b-4fa8-be30-1425c4d1ad40@samsung.com>
	<42cdc3f4-95f7-4efa-be23-b3fafae84109@gmail.com>
X-Stat-Signature: fhqj6yoseyy3h8oe8p53bxgso8pca931
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CA54B40002
X-HE-Tag: 1791965095-432258
X-HE-Meta: U2FsdGVkX19sXNh5d87mFvqFKFtVEkEHERSEM4H0U8clegSbIy7pPhek6S521onzj5GC2D85l4IZyc49jk57u/uuTqGbD77cJAPI2SjxNdoG8d8K3lWg9QHGvy17RKv3q/BdqC/ZOy7t6tYdZfggzQonc3LRVTXhTVv7iuEBP24q9uL34S4rgfmtAjPWe6wtZS0KMELOIQDRzu2L8Xgt2PidqVSY+SbyDYzGYVSM1Z68qT1S4duHnMhh1avDwame/2jnLXV/rrdXkq5g9OAfbqhXrDUXXfVJ9ldjjVLPGkSCCZBXif5J/x/tsOpNRD0dBP5E2FyvERg0N8w32XIqxyfV7izJl35j6cI4usUj9e480S37bgCA0rEQDJFt95EpY8phkVYtJebnm4/XdEA5+F2ETAL9wqfoDvJNTDoa+A+d++wXdzN4t5oqs5gbZfeE4zJVMf5cQFC34XOQsAc7pr0LytiLKeVC8iEUISDBQbHetVgu2iC7ipwYyKKsMZYWtCZz8AVccSO0tVV4vkXUufUo/8xB7iwDOUkDt8ROrXnqjvYVVr8+/7eQ0G1B3tBkULExiY2D8e5KJwzMroszWFPCXfjuVwB96H0/YsVE/Rvxr40ZHHZc0tWfEc7polwoKJY0I/8VggBzaKgzDqUfciuhV9oWEnr1czPBdKHgi9iPmrS/0NZGNe1bc9PTgaWd5r7QzCb38ocbD3oXSlkmrsF39QSFfnlBTG+emM9EtnFnwi5aICn2WopgIqQSheix8z2O7+bK2GU0DdkGIkW5oeM1ZSfpc6SxOUmDgw63TJwpjdERN3qtoAySN97/49tOBPOdH4/ZJBRC+Nh0B92iKehtJNhvkci6eC5ali1PacR6xUR67zNK23aeP3ABsOHUGN9lKzA/JSJxwBkAnckfjPbkdiyXSVM6d18Y6nso/tQ0/6cGkNRuH+nimy29EXK4vzUm61t0trbI1TBotRo
 yViV41tD
 zxsWB299zYjqpXYU+4tCFb4vNIuyFD2c/WCjhsxTsVyDHAD7NynIv+fSOA7LYIyPcNMDlOHveO/chacqGEX89fcjN/seBtwAQIN1SJeCGKbCG6Yt1Xgj9AXdbmnn6mt+cYEi7/f1SmcQOV6JSw0qwyWE+WXxbqnop+mElCSdM9s3m4nM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.10.2026 08:40, Wandun wrote:
> On 10/9/26 19:27, Marek Szyprowski wrote:
>> On 09.10.2026 04:16, Wandun wrote:
>>> On 10/8/26 23:24, Marek Szyprowski wrote:
>>>> Get rid of the static, limited-size reserved_mem array and replace it
>>>> with array allocated by memblock_alloc_raw() and accessed through a
>>>> temporary early_memremap() mapping. Such mapping is needed for some
>>>> architectures (like ARM64), where linear map is not yet available during
>>>> early boot scan. Having a single, writeable array with all reserved
>>>> regions removes the need to perform two step initialization introduced
>>>> by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
>>>> memory regions are processed"), so all regions can be processed
>>>> directly during the early scan again.
>>> One concern about the ordering here: the new memblock_alloc_raw() for the
>>> reserved_mem array runs *before* the static ("reg") regions are reserved,
>>> so the array can be allocated from inside one of them which makes the
>>> subsequent static region reservation fail.
>> Well, that's what Sashiko already reported. It will be trivial to process
>> 'static' regions before doing the reserved_mem allocation, but this in turn
>> returns us to the point of not being able to handle their reservation
>> failures. I wonder what's worse...
> Indeed, every option has its pros and cons.
>
> Could we reconsider the approach from my v2 series [1]:
> record the nodes whose early reservation failed in an reserve_failed_nodes
> array, and have the late scan skip them.
>
> As I understand it, this handles the vast majority of cases. And if
> the number of failed nodes exceeds the reserve_failed_nodes array size,
> the system is already misbehaving and the DTS configuration itself
> needs to be revisited; even in that case, the v2 approach behaves exactly
> the same as the current code, so nothing gets worse.
Frankly speaking I would only keep the information if any of the early reservation
failed or not and just print information that "Early reservation of some memory
regions failed - system might be unstable, please fix Your device-tree". I see no
point over-engineering this more for no visible benefit.

I will send v3 of this patchset with such assumption.
> Also, IIUC, setting a memblock flag may split memblock regions, and since
> memblock cannot resize before paging_init(), that would increase the chance
> of a panic.
The memblock flags are already set for each reserved region, so adding one more
flags probably won't increase significantly the number of memblock entries.
Adjacent regions with same flags are already being merged by the memblock layer,
so many adjacent reserved regions might be covered by a single memblock entry.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


