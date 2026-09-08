Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28711C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A3D6B008A; Tue,  8 Sep 2026 02:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30976B008C; Tue,  8 Sep 2026 02:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E716B0092; Tue,  8 Sep 2026 02:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FCF86B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:06:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B0FE16036D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:06:36 +0000 (UTC)
X-FDA: 85189560792.04.2CC345F
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf05.hostedemail.com (Postfix) with ESMTP id 04461100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:06:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="yWIiD/Gd";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788847594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kezm3pPzdV4fcSPT4bPXK4sC51VDlMynJvYJEKLruRo=;
	b=HolrV4t3PBCCa6ogWhwfgHWIq+GolrwgnhDsHfh+FWgvCU++rRSnjeOJOonzX/24xdNMue
	SdCpIXWEmPPFLoL5tanW73hnpaBeG9XtXiCfZr5CDItIUD2u/WJbuuRfZtmwosqvsLzmWF
	MAiucZ/J5JuVk9Li6vR9AFxga7qJ4vo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="yWIiD/Gd";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788847594;
	b=IEgfT8ECK4qfVFkdfsX7vE6Hke6Z33o+8oQSbtCH2HoQBSAK1YNVwKJ7vlsda0FazkKSIl
	q9VNB5aAFM9V6jOBlrqlIEUP5cezIuMcLxMF6nOn8ZCV8n8/AmLwYqZ2VDtYnfYnjvf17w
	R/mEutTD/OnghKpx0+AJNuCjE+W9i6g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788847589; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kezm3pPzdV4fcSPT4bPXK4sC51VDlMynJvYJEKLruRo=;
	b=yWIiD/Gd7PJXgsyEIT5v8G2VGfiMKUvT+0PIAMNVvYe6YN7Mbth7ofuJgiGRbXqdmQ37AYy8L0A+n2oUIDoC+qKtF8gmeR0ewxngFBOA6opyldg9342sYR4xQMJ4d4jq9iuoJuoVS14Cqp/eQp+Cil5CZm+quzTgQjdK9TjEVNc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XAaTebm_1788847586;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAaTebm_1788847586 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 14:06:28 +0800
Message-ID: <4f39b888-5dc8-4cf9-b1c6-b02292abd710@linux.alibaba.com>
Date: Tue, 8 Sep 2026 14:06:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: add folio_reset_partially_mapped()
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ziy@nvidia.com, hannes@cmpxchg.org
Cc: ljs@kernel.org, usama.arif@linux.dev, lance.yang@linux.dev,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, kasong@tencent.com, hughd@google.com,
 balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260907183340.1446132-1-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260907183340.1446132-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wc3wcbbemz5gyjgrmbfyzrmxnhgyk7ef
X-Rspamd-Queue-Id: 04461100002
X-HE-Tag: 1788847592-621249
X-HE-Meta: U2FsdGVkX1/pBPHY9mTBsdnr8cwr43kV3dVPzHqcdSXRDcXgm8mmGipMursScbsygaLGR8lX7wcSFXsnjUxOQ9asDlaH4plZkMtWiPOnReAmsKr5fKynY9/x4v2RgQ8GkVrZ7djrvkGe8Y94OWF8OOfK+AqYp9PYmPo/qXGPzOBR4EiTzF6aDNf5UMlo5PDmBEREi2W4tiNyD3cKWub9faf1LpLvUeMqvDkDV2HruwW2fvC8pJecf3L1GqUexeOy875q/xtxY0detWwvciSS0SytBgWJNt+j73ppAUVBC0iJnNMX3mcP3mFCDT6zFvfNHesPYM2LRGsc7qXItpCSxN3NxCTHDfrctmPFb0JM2rcfnoxJccCilMqe40EZ87EZhySn5NaUYYKHDf4rhhhwsSeMtzJTRleNgAQr3M7PvkLpYjUuHZxvAW9zrKxfbDLRZ6VHR98vYnJrWCoIl5ezEbthda3LW0sY/j+rGdCTmY8HfvCFAYYyckzWbXFHk+3CP+8V0j8xi9hYdkcyrOBlFUGRD/8v2JVMFSjSdMHeSLyon1MxCtvTfReJstWayek2KBTB5gvcP9WWsworFoKhO9AZzqVCbwMDLgHLc5ioHuzK1IdmCiSOuZM37hsvv45ws8GGLM82BcwV2uH4kFK1NsjmxJcRqbHB+z1LOSlmgPuIW7LDRHgRppOZ7voM0I6LSVwCXMjPbrSR6yrk/OMiJxRrtVtrHl7kwDpuAqZXDx10Oh48g0Sldbz9JSPkyglOgiKzHaZFNL7/G6u5ix4Yyb3GRMIUvfpA8r1yckLooXq4GPwAQZyX0ALt8z5kfzvLz1q5CQvlBEAJ/UIQt3fNqMa+RO4rAYnfG0bO5K3F4jSMbayhYiayN2k+zBfsxWsvsf8KW/jPKdywyw/1lAIgYIp/4fXVwMxbDjJXflDkp4S5JQQt8MAduBmVfuGRisVcz/yx9igu0bVl6yeIe4b
 fh3P7Nis
 fJn6Rxku3o5YdN3iffq9VLUEK2adWSAEjwy01xQcruny8GE1kClwthyG8BWsGxIJxvMZP6y1tw97+8GWvM/qt3C+o+TZTImisOHzny7zPuWr6FxncQtUlSCG6Atg9DvQE4+VXHqrdBE7tY7Xdh7VkujOYy0rVhR/S9u0pXUyQHcF2KIm8wXWNi0HL7SHDDE96dfcLtOcsf1U6vTGFSO493UCzAMWjCqATmCiLeC0gsqxMJyfbqUmTqXrmcUnRh2fdqlMggeI5TEH2jrXFn8fZDMQiVt+Tf4wF49EhvLFS585DMZ03Lc8jz3iEN7c9raMJlABynpIgZFNj9Z9ROQW3jS56ubP0cTfz2AyKQdsM219mzKSWBR7ZrcT8gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 2:33 AM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_unqueue_deferred_split() and __folio_freeze_and_split_unmapped()
> both clear PG_partially_mapped and take the folio out of
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED with the same five lines.
> 
> Move the block into folio_reset_partially_mapped() and call it from both
> places.
> 
> The helper asserts what both callers rely on: the folio is frozen, so
> deferred_split_folio() cannot set the flag again under it, and the folio
> is already off the deferred split queue. The list check sits behind the
> flag test because order-1 folios have no _deferred_list.
> 
> folio_order() is safe to use at this point in the split process: it
> still shows the pre-split order.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Assisted-by: Claude-Code:claude-fable-5-1
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

