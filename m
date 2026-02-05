Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B4CECD9B5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 22:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C5B6B008A; Thu,  5 Feb 2026 17:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA066B0092; Thu,  5 Feb 2026 17:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBA76B0093; Thu,  5 Feb 2026 17:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9F86B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:58:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E36716071D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:58:47 +0000 (UTC)
X-FDA: 84411919494.12.EE2DCC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2598C1C000D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:58:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=c0aWC5+L;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770332325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Wzn9f4+pnPSCFp1OZqk0Q5RC+lHBbLdz9bMYvx/JyQ=;
	b=0QijnP5YEtNwLmwIXHyvgxcHmxzUCHZXnvsW0AFrI9mxkcgjsUkRlax5no0VWYQVyJM6YC
	A7KBYNS3mogRL3MAgf9Ot+zkLxP76TACXCQJs8SWtXOqHtB/HlvENHvxM/ZmfGMXmDhoeU
	2DuX67VyZsF1TNXT0cHQ5Us4Wb0iAu0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770332325; a=rsa-sha256;
	cv=none;
	b=GzmPVQwf2WJAhR/IKPP+1wuKaoqXE6OtiDvZW4as6sbtpNwYnu2aCmCJM65niF8AyJ1kLh
	1LSNUADrwk0kDtxV877IHoDhEemlBrJrV5acazqKlJ2yatNuwxMAMypO1n5JSV+iyWFVxP
	6cT+SBJTxe+ZuhgpRMIsqZzGYERLj5A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=c0aWC5+L;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E23CE4449D;
	Thu,  5 Feb 2026 22:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FF7C19423;
	Thu,  5 Feb 2026 22:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770332323;
	bh=YcdYFHMV89lA40rLxsDkCLWE5HLfI7sYULz4cHVw3dM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c0aWC5+L57nNvj/7wYjE3r/jAClMP5119gbGWg1Ud5StPtmLAOOLTjWAHdWxbdsOE
	 RNa2XJNFGH8kF7/FRvT6UgCrqvxJMPkvdaRW751gVIHroXiZyq9tt39NHxyKVaIuO2
	 ejuqUNvWvImkGDwb6SoRV8QG/6VyFD7VE9x5aLck=
Date: Thu, 5 Feb 2026 14:58:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: Gregory Price <gourry@gourry.net>, dan.j.williams@intel.com, Jonathan
 Cameron <Jonathan.Cameron@huawei.com>, Mike Rapoport <rppt@kernel.org>,
 Wang Yinfeng <wangyinfeng@phytium.com.cn>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-Id: <20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
In-Reply-To: <a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
	<20260106031042.1606729-2-cuichao1753@phytium.com.cn>
	<20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
	<9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
	<20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
	<696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
	<2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
	<aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
	<a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2598C1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mf6t8wquepn5ewmj4qc7gc38mg95mwxq
X-HE-Tag: 1770332324-889386
X-HE-Meta: U2FsdGVkX19NzbW9j6rP0oC+zflmEZBzYmOELe1HsBZkCHQbgMGfkafF7FKTKbP+osGVymtf0U1BiQopFhpqILJ/cRpXJqUo9/VHbEXesWaAPcr8VTclHJJZ60qdo3YeBrJBbK6zYBX43e86T+RR7HkqtY5uk5qoddqFKyvKz2tph3oA0E1GeDLerUdSLkA1Na8XVvEft8KdRZ76FkXPl6Z8m1z30+JPPXu+XDxCM1li6cDnzYFw64hbx/gvsdGmF0FB1HMsn6wXPCQO5L/avfXfJhq15SZO90OQwPNjlEfQInonB2Ej2V1uM26Bv+aQGpwnEqJLxMwMHxBbUXl85+i+jRppCk0s8il70IIYEH7W7qUdXBZeBftsdROy8SWVHbBj8FGi7yRHCzAq/2oVcQVih7na6+0wl7WBVRNDR05idH/Lla3X3Y2jqsnMwRsFw6SFlbt6EvXVL4c5fPlQGlV95Vyimoo4NjyXAmAn8uhmk5BOm/JDPDITobtXY16cg3aADkaPnrwaenxRHiEGkwNqgZoKwybPOPsjBzEDR+QdAvMlUZNUQKFXD791ITgXtUiFjFue4/QF31sURn03nCnxm2rh48SAgllolgzgiw0tbRTil0pGUiab489V29FpmiMG6oghLRq0doHKX+A0KFw7jzYCyYLHEDGuIFaZUdOgPSrX/TDc9xAcoZHqeU7QuAyhSJsIikgU3zJ3PGyZwrdhOMPpnzUPWy0h2b7AMXmmlygtkLFq1/stNLDCICQ8WRLY5Zy+W7EvHcQlDs6MQ1JIsJFObnkipJqs1qv7CtIfVgJ4E+35fL6TNkRvNStiL4YIisRY5NlFjxH8t95Zdy3xPb12sD5Er9PzOw1pmdltf9nJzpnZdh9Vkx7u0XZXWS7VrLx9uTl1tiRnZcq0x/9qVYD5yIhglBj33vgk9KbcIkQzlI+UbGfx7ePfqD/2LsJ3rk5htWQe2Z4caPM
 y3J08k7w
 CU1ENKs7QyWuZoxMD/udPjFqAt9JY0R5XMP+J3SJ71HwFbLUcwN0Teo6c4spOKgxEJ/ALcdy8cH05cf/acIpkjkhfjbDmM/pRSA6+9qMfFu7jX9Z1YS1QSVOJSqhAW71HE8yRnbHG0BkX5yIvxDKB+m/6p5+maPI4Os2RvMcXBuVXIah3k1gnj0L7vObqAmvXt2/Oe1yLmzh8R+d9UyjMrN2Ycb7LruamskBumzw48YxlSSAGzxeAudP1tbz7IRAiPpymOZL17C3q/q08Tx9WlypLXKZFomVUCIoiC4R9lL32BApAr3aE2LcH3xjXCcvGg8KRh6sPYZhG9Z36vhVXefPTfRC6j2XjOwMK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 17:06:52 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:

> > All that said, this does look harmless, and seems reasonable - but the
> > changelog should reflect what the hardware is doing above.
> This issue was discovered on the QEMU platform. I need to apologize for 
> my earlier imprecise statement (claiming it was hardware instead of 
> QEMU). My core point at the time was to emphasize that this is a problem 
> in the general code path when facing this scenario, not a QEMU-specific 
> emulation issue, and therefore it could theoretically affect real 
> hardware as well. I apologize for any confusion this may have caused.

This patch doesn't sounds very urgent.  Perhaps we should do a v3 with
updated changelog and handle that in the next -rc cycle?

