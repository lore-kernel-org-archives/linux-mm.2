Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27026CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811F38E002C; Thu, 16 Oct 2025 16:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E16D8E0002; Thu, 16 Oct 2025 16:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F76F8E002C; Thu, 16 Oct 2025 16:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6032C8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:12:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AA28472ED
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:12:52 +0000 (UTC)
X-FDA: 84005075784.11.A9E3E52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 86B621A0007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:12:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ZdKC9d/b";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760645570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iG+zl3pcFQMc7+QNyBGyZqH1JofXijeR/RXeN0Dl/o=;
	b=dNhKCvQrqXFAB4z2s7Qvkci6k/LLoZrFtK0CTtaqjgvKzOJYe28FjEc3IZ6tplgHfLgLpk
	Y5zlI13P+62UzQouoHEHg4efKGxuvsus5k0Wgqv4begcVQvjEwrzUW43eIt0PuNc8NFQu2
	/MStaaIdFjHtcRsH3czG3iGMm2kFlyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760645570; a=rsa-sha256;
	cv=none;
	b=tnrgMuwgCy3l5zQmtq/mPmM/1Lj/ZQxy+of9lW/GEoqrLXJusr8Ho4uiYRMoAxezx1L4Rx
	np9MEzXSFievvEy6fvmFQY2BueM2jwgQor9CZtL69X15OsJGDk7I/Tg5ZNRnolpv5VSR8e
	A8UKgbvTwjYGVrtcAu5GB/2RiNoqTYY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ZdKC9d/b";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC28A6041F;
	Thu, 16 Oct 2025 20:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B59C4CEF1;
	Thu, 16 Oct 2025 20:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760645569;
	bh=hGHCpwHFjhYGBlIJ4lsr7K362zIchdafnBRS9eORujA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZdKC9d/btE1m0xZ61lYAg+wlDWdGL+D47uYKRg0/eTHT5+VKAzP8q/qz1g3o1swd5
	 FYAIYSVeAP7F8O1fF+PscAwDhRwuGjUMw/eGo+mUHD3i4wCIzAI1KxB4hvBEJUiapI
	 325YCNf2UGVQWbY9UxfDT+g8j4rFQ1yxEXUr4zNk=
Date: Thu, 16 Oct 2025 13:12:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <sj@kernel.org>, <damon@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: Re: [PATCH] mm/damon: add a min_sz_region parameter to
 damon_set_region_biggest_system_ram_default()
Message-Id: <20251016131248.f74041dd236ca33808a07ba4@linux-foundation.org>
In-Reply-To: <20251016104717.2194909-1-yanquanmin1@huawei.com>
References: <20251016104717.2194909-1-yanquanmin1@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 86B621A0007
X-Rspamd-Server: rspam02
X-Stat-Signature: a7bbhxj5k58k6st9ah1z89acw3swd6wd
X-HE-Tag: 1760645570-65587
X-HE-Meta: U2FsdGVkX1+Q3jrsSIkK/0Xm8bhthZzIhPgvc47w1FSlyDd908I8XniRN+knn+lt/xziebr0xF5t0Grylw2K3HGjVDBa3EDtgvEA74kHAlBkt6iFbWHrKykKcuEIOBEN7ExV1SPTHVJGYaptkTxB9T0r83ek9kAA/eD0Nf/FjRWmjVB9IaIQYJ5ieDCQMTwMRCX3k7asepdZxIjgFrZlXjZtJc1anRCV5+B8Nok0PrPlhGnjMk4SyVcE0Tn0YhvoCTc/KXHT6FGydpxiR4k3Urw6zxbSd/ga1pLQEvgsxafSGhyCbds+lrmP0WBsptI7K6KEYLYUOlXIbpLSghGDSiF/wsOE9vM9jpJkqKwndcgNil4hS9e5QZ0i+77QzeisZlbDw8aQ5WEre3Bc6XMpOwSaReMrktltuQ1dmY+msHgcZ/50d9Di/qbvbxBPggoPNvGSOl4CBnqOXO2fznNHHZKemHY2+/kqH04NkqujRucOUFxtvaak7tE3zPStmHZY1KYqxwsbtD3m1Ybj1c79p+1hlY/jdvOoz2DO3Bb2qBMqqv6T6oB1QrH05qZKHBoh6NF0u6CKShFiwCSINIDqF2Dtv3B4MT3DXBU32ePZ3vGnsz2P6b5VGaUeGVAEbj53TYaRgQ4Dgl6LFx6js724sTET6lQ6c9ph0oNIrrYN2aCGSDCC7dPCT7b/s5pdOIAWRQykzeFc/Y1PwXD3osWgkx/I3pNSd+MtPZ3OPBaRs81muQkXbjApSpFkzvTVOiy8RZuXCoPIaFhONTfl2ISmGuMFIoC3BB/G7HZVww+qyr+z4LAJrvoRKxiSUBgA7wDE+bPP1L2nK5hOQmiukQRHuLIgdUXbs1w5kYmNSzw0WpFb4KpRZnc5IX6d/ye61SmZVFmkO8rK5JFPqnyX1AV+zhPwcJZyZW1G/yVScvycVyPunDmM9exdzz2jOZYmeSeEIcaaSRizXxf+sTXQgIq
 PhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 18:47:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> After adding addr_unit support for DAMON_LRU_SORT and DAMON_RECLAIM,
> the related region setup now requires alignment based on min_sz_region.

Why?

Presumably the current code causes some sort of user-visible
misbehavior.  Please include a description of that misbehavior and of
how users might trigger it.

> Add min_sz_region to damon_set_region_biggest_system_ram_default()
> and use it when calling damon_set_regions(), replacing the previously
> hardcoded DAMON_MIN_REGION.
> 


