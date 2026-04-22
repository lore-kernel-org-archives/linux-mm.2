Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243D6F94CD9
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87A316B008A; Wed, 22 Apr 2026 03:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82AA26B008C; Wed, 22 Apr 2026 03:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718C56B0092; Wed, 22 Apr 2026 03:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C04E6B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:46:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 026245B900
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:46:44 +0000 (UTC)
X-FDA: 84685409970.03.86C80B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5346010000A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:46:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i3K9gL0d;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776844003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyDM5hrovaUhLZFCVLEPJkp3h3Oi83PXm7i8Sj2QLy8=;
	b=78pc0U4pdF86n2tc+ISFuw9yfvQTQmRefHvov4v9rERuFg8QedR0AxMcPtF6dA1FP456OL
	uWFwzG0V67bz60HZ/Ty54D5z8uNHUdOYa7BgOhvM6wJlJc9wW34g2WPDhEc1R6oH+ER1T9
	HAsdnWKeJA1Ca14Yuu0c9yxl0klMZWM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i3K9gL0d;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776844003; a=rsa-sha256;
	cv=none;
	b=zkev854k7Zo+LZiRYG61AS4B5+zjggKtdg4dXPP/7LG96USitczk5FTq6SA98d4P6j4UcP
	ruNYqmftFFViHTNRaDz7hQqg4nRj3zEInIjidZ8MHmWbIMm57B0ccdz96PjQRIfUZ6jSOA
	dmSWkkTQdLvn2nRYbYkvsudTPVJZ/uU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 598FF6001A;
	Wed, 22 Apr 2026 07:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BFCC19425;
	Wed, 22 Apr 2026 07:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776844002;
	bh=6+iF+US7RY2FOCvOtaRLI/TRxwTG2Y9e1SrHRsEakn0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i3K9gL0d0vGJgeW/4yq3DuB8Y0szAcLlky161nsJ0ZYQZ4jxaJKDA06P3e0aA5pjN
	 L9tIorPRZApR2PjBbeBhqpAHjI2bKF5ZCthuhUGuW0l205JYlAoZAOWyPGsSxaOa8Z
	 xc2F3fILAAeudO8d0ylQxlmpLLlTfrLjJwDTdHj/o47m+zFAU06I4W8y0wubZBNJXB
	 RWfWYX0i1SQ5XZr/JM7/BRbbgZoLEftD0K4FTTfevcBIdJfkNngNV5XsHLYxtkKD6Z
	 HiKL/hsFn0X9bW7EBHYYQYBge24GHD9aLLO2jh7Q9QPExaPpNsdFvV77+iHMzLESnU
	 vr/RdOYsRSFpg==
Message-ID: <2fef4fae-b7fd-4c27-9a76-994076e27b5f@kernel.org>
Date: Wed, 22 Apr 2026 09:46:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260421125508.2317429-1-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rnni8533s6an4g9xe7jrf4brut7yg1ob
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5346010000A
X-HE-Tag: 1776844003-735077
X-HE-Meta: U2FsdGVkX18zhASHQXhKgOkmTUhhkTan+8pzgqmkU+31FQJrI6PVFskf7XRS1xlPV+E2hcOy6LnLnlTh465sfJQ0qMwmeJ/WIkBBNMvdIJi8WhoCoa0f+gRiz2yNi2NA37YFvbkDc6XtUiFWc7o0BNzn5KUtvMcIgRigYEt4ux9jT+1rgRwUqJIX1JnOfGT6xEGHM4Z4giDVlpjXxyI3Jl9euKR+iV4L/cGhANMjuZyZgJLeqGIVRZ+md1JBeGva285g/VQOje1vLwyrW/zVq5b9RvT2DISgzY92vLQ1G6kIVR+Ie58dG43RmpBVvluzXBXyVdm1gRO56Iby53WIcjRteZ+IuxOo9rspiGwSFP8TE3+JXH6Pp0ubm6+nwsyONcT+Ep769HNpdulANYkdx1ZK80E91iVrOgF34VZzqNxQSAI9t9gcZpmEvdTYfMQnfCyB7baxP8kP/jvDnKAZzd6mgr3BX8vu4xvTa5OQ/rbplZ4GdXK9U49jH+9zRuaHZmSLpaPpUWpPc9Yrgp3n+xl+UU7dnLI2yIVubPruFPfocYwFKfmP9oYecfwPQc34y6WezX3WvhaFaFdydfTXDrdSc9m8zmWUYs2NPyJTK/MQYli4uS5Ti+2UdpSCmgLLRK/PsU8LdGkCV+9Qn3ZRMM2FvCztVVgbeeu8M5geIuF3P7itTHXauxWiAwMgbQaZz5rRjBU0zrk8m7O9G3HdR1qOW6yqCQifi7aBIbaVq7Xz83EHuY50AoJs4cTKyPBEA+faRgGt/paqKbe8dUUx5bw16SzwNTiZDvVGo3aP9UMlZRI5E5/3XQdebajgs13P6sMAsZCd3bBoDV0TEsXA5op8xwHyYPy5zIdmob9pkCdyECW9ekK0hEwHUqyh0PgcITzBt/eXSsp1SzkhALyvUEGAnR105iIOl/bmIy2I5R7fbN0fKMBsXxggKa6OT9T7yHE3sK7W+5l2QQlGog8
 IDzbjxrZ
 aQLVAruRx24eMiAn3uqb2E0DKA6sz5brnkmZdUCGRSFxUPEQ5P0LM/e9vdWok3osshGOmbnILrSrVL20v64WFopR3psBUca9T+2NruVYrtkBamxxgBxnUmHZMiGU1a0EXkHWHkDXOREJC+wT6IyUD1d4q603pexzzbfxodlcWekMGT8rEDtUR5KNCvnhg/hHVth1YLDGDmUspPOcsXS1aUmrgy/iCG4vxho4qgERZOFg0gr0lroe8SZsI5I/748cA8TbMGtUrD3BESGOG2iizTnAhSmSAXqLGmU25pN2vVyCBRvmpcl7oim2DCQ6wGhBteQp48bTpkXGoyHE1K1t2GSfmqxU7L7YT4NI5MK/FZ8wUnk9obx3rkTRyCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 14:55, Yuan Liu wrote:
> This series cleans up the overlap memory map init check and
> optimizes zone contiguous check when changing pfn range.
> 
> In addition to providing a significant improvement for VM hotplug
> (see the second patch for reference), it brings benefits for CXL
> hotplug as well. The link is as follows
> https://lore.kernel.org/all/20260409023552.GA2807@AE/
> 
> v3 link:
>     https://lore.kernel.org/all/20260408031615.1831922-1-yuan1.liu@intel.com/
> 
> v4 changes:
>     Add a new patch for clean up overlap memory map init check

Didn't you also wanted to add a patch to improve shrink_zone_span to check both
sides of the PAGES_PER_SUBSECTION block for fitting nid+zid?

-- 
Cheers,

David

