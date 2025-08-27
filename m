Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F056CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 03:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1788E011F; Tue, 26 Aug 2025 23:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8AE8E0105; Tue, 26 Aug 2025 23:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5FC8E011F; Tue, 26 Aug 2025 23:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4947E8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:38:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED0931403F6
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:38:16 +0000 (UTC)
X-FDA: 83821129392.20.BEF7890
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3ECCFC0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:38:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UfApRqOU;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756265895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijAVdYAAjfYax5vf1FcRUz5FPs6TfbNVnkeslp+2fPA=;
	b=ms/MlbQojtE8E/dd8T9t1VbBDjAsijQ/zdcd1PHHRpezBDeSeYwyJkfAJUtBocpzK8xbn0
	jucmDUW1kAA1aaQe8TshYazrP0bHLug0qFQX3B17eTNM0V/KvkMGeARPRJeCxNFMAuqOqh
	DdZ95tlLgC5800+M+5oyC7f5WOGcqPc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UfApRqOU;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756265895; a=rsa-sha256;
	cv=none;
	b=SPfLWNFnqgTxmnLsmm/1SiEWPBdjvYZGTViVwGeB3KU4yS1BB7uQawI/ERKATTlyi7eVz4
	rqafuFKq0eOJwBtUrxM4WGFK5r+oVjGYOVHsjvoR5+r6ZTJnBdDliu/5edFjywt5iM8unx
	4sUIgR01pxGOuQ3kwRY1dvut3HGWPG4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13975419B4;
	Wed, 27 Aug 2025 03:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEC6C4CEF4;
	Wed, 27 Aug 2025 03:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756265893;
	bh=R04tb9OG4TL09Nj5gld7v76LS6CI1du2iW5ZQJMgkxU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UfApRqOU6xX2QdkOsMfBO9rPsCGbuyQLtHlMhihCKlyI6s9t5YGegVNME/RjUVMo6
	 baxAUQxQk2SGFmlEx66IbT8LdC7uO8oLu2YEaNuLEa6AKNUJtXmk0/eLsozqL4lJE9
	 e2VpIcR/TBt374M59ZOQCkpsPmEA5U3XcPAS/w1g=
Date: Tue, 26 Aug 2025 20:38:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 wangkefeng.wang@huawei.com, zuoze1@huawei.com, kernel-team@meta.com, kernel
 test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for
 DAMOS_PAGEOUT
Message-Id: <20250826203813.437025536948c01b9b307f62@linux-foundation.org>
In-Reply-To: <20250827024244.58979-1-sj@kernel.org>
References: <c8c3d0d5-e9e1-44de-8722-1e7d09786b51@huawei.com>
	<20250827024244.58979-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3ECCFC0006
X-Stat-Signature: cqf3itomdui3hm89yfezctdzgw13az1w
X-Rspam-User: 
X-HE-Tag: 1756265895-381164
X-HE-Meta: U2FsdGVkX1/hh2WSEFbD6DJDvnFq0FhcE+bm+z3iTUhfRjrOQSYNEyF2UVRMJNOaO0ki5Vi/Zs0xR5qZr8NvV1u1j8JTZabg7rmkMEbJ30fycQ1wHm+bEHfTJMbIrxQ9J3aq1VUiUGU7XgwSNmGSNS3/jqTPP/DbKQWbl4QuHL91hEgVWnIUpbpXEAnDcpYzOX3QZPyIj56ey+ZzcQBYyVWdik7I4ocKUnMenzWwSbtVJPzZ/Pqm881fO+Q/Iy0PgUUmX0IZp+DPAIClmibCTP4CdjDvCLwKKIUObDq1HlB+gTQCY24KRcH+Ekmb0ZdRwpLnE5K8qNlKvBZuwKQ/tdugTRPi2ju1WuWO0+IQtJOOvfmAVMKYeqAUWkQUfDeE89s11wiocpGvwbBiIDHRTWYZOxStM/jtR401tOX2z/jYaBYGea8wayGBZpDQMppGazNLeiQr+7SOYkFlFdo2aDhB287enfwk3xRy4qshRbsvHVrXAu31ZovqbMxLVez8A3BB0m2Mw3P4+Yl1akwCT1WEivuXjZMW6VDZAIOhvq5m3SV7XBo6jgq2BN9ZA/Tg4jHUMlkFfPKdTh8rlTPMKyB2q45WaEUhQdslFP3MKJiOQ39tbesSAiwwyYHlDiXokH417VHJMJ5Ndh0NSFSQe6+QwNUuTdZpEx8qdolqmUZL/cw+rnWDFfntSSb/G70A/WRuLip5GqMw9GJA66WMUk9ipLp5JNmEuNOIhVaCmsviG5PEDnTMzGn4ThRVEjpv484WHOSLW9wxjb26YoonMLvrOIoBFlXXQR83SjYeNnfL1Zwsy/Z/61u6h+gnoRbO8zCWxcHuAhECOTeaaFJe0r3c6cJ5hwaqgUKOppYJKDxFBMa518bH8X4wtsw6mM9BviwL42EECdnzeS5IYHFQ7ksHrZLiwDiEdD8kX6c5WgE4N/fo+Q+jOFU2uT7ntFvmEATt7QBQP1EgoR/S1iA
 AHduhBXO
 iCCoN3CxaI7JeSw3+jZr5RVIeLcVTqhE7quS79GIfvfcOh6BBplVm0xhQNMLrtRVS8Y5Oaw4DeIqPMZsdXGxdLKdwQq8QEEe/g5oskObAWxGs4AGB4znkog/1FQswSEs9II9ET5Ef7yxVUXQmh3SDyXSzrpv48F8eJ9Te5yf+Iyzwfr+VjPTWMw9slEGPksxJFiRpdDzamXFKVEoRyvC4V81xskBZug+La2U0r5PIc9QM7Sej6RW+xhUPq/Clk1WZK5qIoLCmxfNxBRceY+mI/tWz8XIiJ+XdwMw8D9kjwXELTiHj3ZUXnEfKpFJYwWVzGqjH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 19:42:44 -0700 SeongJae Park <sj@kernel.org> wrote:

> Andrew, could you please drop this patch series from mm tree for now? 

Gone.

