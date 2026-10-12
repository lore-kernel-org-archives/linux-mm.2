Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730F7CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 06:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD456B0088; Mon, 12 Oct 2026 02:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85766B008A; Mon, 12 Oct 2026 02:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC22C6B008C; Mon, 12 Oct 2026 02:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAA856B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 02:14:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B3FDA08F8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:14:07 +0000 (UTC)
X-FDA: 85312958934.28.07D05BE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 06C9420009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:14:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SSJvN2bl;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791785645;
	b=n3lrxpvrOstD1UXqc1kYXmZvGcvKvM+h6LsxC7OWUEz96tF52uetlNw6tRjmmGgz3LAUGs
	Q7zf9ol1PvBgpiwgkUUD6RaQXw2ut9Hi0lVNX+3qngyZ3odUbDO+CJoXKPuIxgHrvjSr0G
	3+/ov1zJLz1gsQtjBz3uqBwhEATsYBg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SSJvN2bl;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791785645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6NJqwjldsBfRV7qVTD+qeSd/KlyXk12WbJUsvxMB9A=;
	b=1cRdk2iyUpumoyqgGDx94gab9V7Fe3QFGFvo0JqW1gLr7aTC2PL6hLZ7He2ri/QWUarTxC
	1irTguIL2MKnqMzxpkHQOaEywS4GgKtATt5yhu4dUii/znupVRfT5x+7W8BQMvyFJ+m9PS
	DJwjSN0di0GAx7E6a2rEwjuOiYbNDUY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94C1C1655;
	Sun, 11 Oct 2026 23:14:00 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C872E3F66F;
	Sun, 11 Oct 2026 23:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791785643; bh=uVnR4MPE16Rgbszkf4sDlKvI9WzIxticvq1LhqhOaX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SSJvN2blVpRzvYTZwQHl5g3Tcxsa0FG0knR65KyNLoDmt2rD7Y37wengoRMOfkped
	 oRs5yVYH3eH1c4HYDc2ioq/IMvzt7IRQBVOB+c/tl/PqHdbxtnHsgi+iXwI127ylAk
	 ZCjPk+4I8kZyX1SIVa+qYM/NVYLcN0lIxQ4XjUaY=
Message-ID: <bbdf1f71-6b86-4951-b5b7-e1fcbe672476@arm.com>
Date: Mon, 12 Oct 2026 11:43:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base
 page systems
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261011163527.95988-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b4uxmys85mmg3qdwx1weu74kngyka4jf
X-Rspamd-Queue-Id: 06C9420009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791785644-786973
X-HE-Meta: U2FsdGVkX1/7a8bH5KqqsOa5p807wBteg9JyvMSeIBGlfNFalCvdLU5m/ts+1GpoanIjLZkkhyVrBqNKQK4K+65dT1N87fCcw3Y543gE9/8WQZLUOyLOW1ZtLaf2lW0eJuc82ETeJCxAiuedMDlIwOBMJmXkLubgIDJHvCSzeywFJI6ShbT2bvIRtHw3XK10twOlFtNZRQl3C/2e1kxpVVZYokcEw6cNnt+T8jeY7csbEjY9CKhFprlEQVdhSicxx2LegzyNsMcMzuDc6KxJ+gfA2O6lfyA4X1ktxGJvAbBYPonVO4AyN4lQoFCY5Fr1XN6DXtuEEnHS1tKZ3y2NVFzH6NYtpP7ZCpVaCtqUo5J1cIxYWWWKV1IQEuDCMubNevNNoSfBNyzQ8SebG2ymKtYxbOhCecYiAOwO7JpSC6vP3IFRBWH5nqMknOg+A4ATF0yRf1tCjOSBcUR67ck+aZKbguhJxxLV026IuWHSyTYTOTXcSxFWqh6ptmeFoYLATiuMXFMC8oXxXgwZ/lLCYUwI3r/o9OUFAOG6svSpicvz+ohOXRyF42W7G/nO+ruLZW6Yx3ooUK7sQxCOG//inmg9gd4jGjvWiOskG1jX/KvW6ueEPOwIbRijHQXFLXDWEgOwmYWvZSbcTty4UbMemVk/aSUOFw17kDePNccKWz3RyArXwKDS2rjxeSvPp/xt47oniOrPszCHIj4m7rOA7Lg6p7DAj6elXeQ0a05FyO3xIev72jxUGm0DlNuTvEGiNy+RKe3EaZVMHoibkzfn1pimIlNPZKyvVISCbbQClgqv8JoS+2QEY3Gwz/LqYPIhjrB9LqbFbKdxaDXVfLHuKIwlWOL7KGFnXq/pG/M2DJOcxkR47fHYwH69ipl2x94y8Z7s+BF492mc0dUYZ7LEGLI7iu66uZgSDaQjRXhmiUHp6KqBxUWh+3bC48pD/lyBCNb19F7MWu5+LBw34Da
 +tYjg/FA
 C2g74q4piTCUr5H4bhJQcbcEi2AdcEILXyc9BI/Jz1MqnJdi7A/tiXwxvPMSHEInKUDDsjggr8aY2dwahzdhG4Ccgh655ztTCXdstEP7ZSZIPTvbUbNE3evJgtjnPrRXvojC3K52at//0NFK9yjbHCd9dciv2RDi6+htx7/Uhw/WlhxTe93rx9xSrcE1F4deVRZm3GJkS02laRtFBpFI5xNllzOQgXN4ZF2HIy5S9Rl+heVH900pUMeiQW5T2/Unoha+jNUQIIXYg5LAEayZmbGdbDpmtpxMoy42wNhGfr+4UjU2UnjrVIBIakSK5hpbqh3X2yQZf41n4yzl1jqTW9ObJUmZRozxcctrv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zenghui!

On 10/11/26 10:05 PM, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
> chunks of chunk_size and moves them one by one.  On arm64 with 64K base
> pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
> the whole 32MB (UFFD_TEST_MEM_SIZE) test area:
> 
>   step_count = nr_pages / (chunk_size / page_size) == 0
> 
> Because chunk_size > page_size, the test then aligns both areas up to
> 512MB, which points far outside of the 32MB mappings, and decrements
> step_count, which underflows to ULONG_MAX.  The verification loop then
> runs away and the first dereference of area_src faults with a SIGSEGV.
> 
> Skip the test when a single chunk cannot fit into the test area.
> 
> Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---

I run the test on a 64k kernel. Before the patch, a segmentation fault
occurred, which was fixed by the patch. So:

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

Though Sashiko has a few nits [1] you might take a look at.

[1]
https://sashiko.dev/#/patchset/20261011163527.95988-1-zenghui.yu%40linux.dev

