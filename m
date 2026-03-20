Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E63109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50EDD6B041A; Thu, 19 Mar 2026 23:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF786B0420; Thu, 19 Mar 2026 23:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5106B0422; Thu, 19 Mar 2026 23:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CC946B041A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:13:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF1BF1A07C9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:13:10 +0000 (UTC)
X-FDA: 84564970140.16.D6EA906
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 282DA1A0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:13:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kXIiy4cQ;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJFZKa+pF2ylCYQpQiiwKo/eRNo7IURPsF1lFHG6wvo=;
	b=SFgwS/xoYx8qCoNcwh3LrMIuKyCVBpD/TZQgGdkN8bM2vLEjwG2un5vP7nk6iulexDs/cT
	YKJ/HXFaJFEbfFf2kKMymutkpiE5BZp4hmCH6h32mhNpRfZQDb5LNuqTBG+nOtWNtHScdF
	BBpq4xEjyK6qCfo8650AxxWW7pI0ln0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kXIiy4cQ;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976389; a=rsa-sha256;
	cv=none;
	b=EKbZKyRaOFYXk/cnSp+d5mu0hbl82gxMrL4SejtOvZHI6IrPyTCvJJB6gN32n3QsPl2gu8
	oi8VlPyf/zD4Sv2Qyv92il0dxlXfQWo21X6OdulinvnuZR+duqy7ORPwxhkyn/c70an7/P
	2S3hjJqB1yDZFCyDe8zR3qBAK9wr/Is=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 631E960097;
	Fri, 20 Mar 2026 03:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A385C19424;
	Fri, 20 Mar 2026 03:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773976388;
	bh=hSRlLdh6fNLbDWhBflQxUS6/kj7upsBYBNPCIVlnL0A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kXIiy4cQtJZzc4lD9BdXL/n0a1g+am0DgjtGgvNg1lD6RST5L3W25MAPBSLwM9RNv
	 POPNgzX+gPz3QofT8xly854/Yq/CkSODtg1s5b+GhDuvvXHc4p66fWvgwbzvlz7wME
	 StKb3zZDbPhsHKYfMt/SEp+CKj7F3Zd5rQa5Thhc=
Date: Thu, 19 Mar 2026 20:13:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, linux-mm@kvack.org, Yong Hu
 <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Tim Chen
 <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
 <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Tianyou Li
 <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-Id: <20260319201307.da2257e27949adace34460cf@linux-foundation.org>
In-Reply-To: <20260319095622.1130380-1-yuan1.liu@intel.com>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: keinzy9t5pophwgguqc5wjf3n48y189s
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 282DA1A0002
X-HE-Tag: 1773976389-374693
X-HE-Meta: U2FsdGVkX1/torDQshP2VTygwo8IgSrkHsaEPoJlwX1xw2fvhXoeLcOcjkO9majp62c6VtGZ61dPP7kXZslsN0fiSAULFWKZ79bYLNNzhnz4dj16ZJC8MSvp2d6YPiZSkXEele3+Fp4GfeKR3618oiV7gv8UeGItiNCHVRrIQpy5EATod7yQjEtx9peo5x4yjqju1zpjTDF+trokfouDhPH6PReV7xlF7rl7igCgHj0gSIeiLbKQqC04ZpWJjPwPvkmp6/r/GstUn05qoHzgWfCtfPAgqkh66+BzaZpstkM+mHP10qs/D+DLHfPxLzimylTmw9pXzzP/BHgqyBm/XrFY4C9zTzmFCZldYxsfBFMn0woAvEsxQlxOpPipD4FIGY7OZvJNxahAcvbqeay316wo96FAZrSX5CkboUFHA7fMiWHg/i2427s1uuOG14sowczXmMkTYGGkKAH6rfqyeOxnYYZMibUXDEgLd0KFn7o8OgOTJaEAn7tQ4Fho+3YTzRfRXsCnhUi2ocgcyeBHCajqv/PyRooRaRYwMOkieyyVAwmOYrHPakmxMb+OZeMMU4/pFmu8bomEPbrdOHRVpGvBl9W3qwUfqG8yhqsj5GAHDPrcbC80pt5YRgoVnpOa0y1q6vCsZE1KzOPVyzMFpYShVdbmK04krPlwW9b3bP+6bIbv/RYoyrulrCA7bjb3XO5jqcAq8awHwOh/sByUnPu94BF3tYNzHtR7avqj5hHOFWfTKHJSBL8PDT1u1R5sfIwfo7ZvB+GMkX6+/+TgGTcfyUqEICy0PQ1vKtjRyFCNXlPltnga+V8lpzZgTSH84Xa3ffnnjArOGRwCec8QyzYaWxknnDIGkVd2cHp5Zp3b3CVNJihYdkgwP3XLcF/TW6UmPlwMf3N3SkWcl6B2v4OO9byzx96nzQx2RFVYwpq/AxNuAyiu6pM+Qp1WEtnMesfOIP8/tAAweCEVYiR
 bLCuQTXK
 Rciq6d9q4gQuPAOJIR/yZ+DTrLKIgYPUKY1NjTcdV3vWPOw9l2WHFrLNxEQDbGlxI1Hbhd0513NShY3GuKvhvC3tTG4rZ2ZwYuVY2QO4VnrC9VljGGu6mEeAzdlWd1cR6dxg+7WMK+2euyyZv7/DAH8atS3gs1lkKThfv9p9RzZVri/70mqa2iiqs2jQk0S0hwxSiWy+Blkv2AZnuy78lN6I2pZBDGhQcoQYBMNCM88CM/YW1bv0FxqOWaj+nEEAO30grOnZDengAc8OHFrDH4fYPZvPBS4u/8G3NoRVd+3fcdzYaV9droY6UhKTT8F50/YVCY/KrZOE4EzAJhscvePIEh/G3PhinyfY0wd9C0tIkonm4u+q5Xil5ubC8javsz7k6Qd0hbg4s6AjTl+lKUe1RazJVAj24O3DzvY0GtRAgtFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 05:56:22 -0400 Yuan Liu <yuan1.liu@intel.com> wrote:

> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> update the zone->contiguous by checking the new zone's pfn range from the
> beginning to the end, regardless the previous state of the old zone. When
> the zone's pfn range is large, the cost of traversing the pfn range to
> update the zone->contiguous could be significant.
> 
> Add a new zone's pages_with_memmap member, it is pages within the zone that
> have an online memmap. It includes present pages and memory holes that have
> a memmap. When spanned_pages == pages_with_online_memmap, pfn_to_page() can
> be performed without further checks on any pfn within the zone span.

AI review asks questions:
	https://sashiko.dev/#/patchset/20260319095622.1130380-1-yuan1.liu%40intel.com

