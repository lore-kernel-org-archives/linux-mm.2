Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C7301125857
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5563E6B0005; Wed, 11 Mar 2026 13:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503AC6B0089; Wed, 11 Mar 2026 13:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FDB6B008A; Wed, 11 Mar 2026 13:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3155D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:06:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF7AD160299
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:06:50 +0000 (UTC)
X-FDA: 84534411780.06.B214048
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF1834000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:06:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AoStovJ4;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773248809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hE25WlnOxQU0cBaWomirABIDR684TjKmZbtgEL2N6cI=;
	b=VlJ+GGJA32t13AbJQRjrG3atiUUHlgc37o3ekibnhDrnJQDBE53YIk5drIbnxEEiZ3kMCq
	VZ/XwL8CEvEC79XlV7fsMwa7nkXc6h659zT3OkH1IEBTKwJB7feCUsLKkm9WDOLLumm7yA
	3AKEtfGiJXmhPSLBgpOHQfI2ERFTfso=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AoStovJ4;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773248809; a=rsa-sha256;
	cv=none;
	b=ySM+1dJ6ipDeJ1LXIINsEXd2IwgvBQmP3hT4h2G5sz35X8BXIsqXzqkPq1xvmrdWDc6o2B
	o7fJfxVfC8hTlws06DQmY8FAOCciy5nc4NHlMlHrXCTPx2jy94qqmk/EGfbM4WSTdkISUt
	0WJv7m6F3TwpKNmJIwm5wuk1DGyFzhY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E71B7442B6;
	Wed, 11 Mar 2026 17:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B7DC4CEF7;
	Wed, 11 Mar 2026 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773248807;
	bh=hE25WlnOxQU0cBaWomirABIDR684TjKmZbtgEL2N6cI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AoStovJ4cknTH9yf8FlPd44wCfgOrCKQtmFMEE4onuK4oRTUFWr8GrtMyQ73KdzR2
	 mk3N4PL/RhY8478yGUAJhBf5Xs8yReJMjtQOnmwL4Snre+Nlrre4BozPBHMnNC10+A
	 73/wiNs2fJsliWTx77SIUXaMKOrgPJkSo+U9qf0M=
Date: Wed, 11 Mar 2026 10:06:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: alexghiti@kernel.org, kernel-team@meta.com, akinobu.mita@gmail.com,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
 joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Bing Jiao <bingjiao@google.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 3/4] mm: Fix demotion gfp by clearing GFP_RECLAIM after
 setting GFP_TRANSHUGE
Message-Id: <20260311100646.81819c0f02eec5d3f1dcaa70@linux-foundation.org>
In-Reply-To: <20260311110314.237315-4-alex@ghiti.fr>
References: <20260311110314.237315-1-alex@ghiti.fr>
	<20260311110314.237315-4-alex@ghiti.fr>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DF1834000F
X-Stat-Signature: qrhbgnfgxpyh4g6kiyqu1sbhjs8u6o8e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773248808-447143
X-HE-Meta: U2FsdGVkX1+G7BvHSdRaR2jijhc+et1GxCU3l5ead70lNtZEcBRvAgCR5tMq2HxLjolG0SkIR1++bvGihlv7cwjiTZkN2NSS0hUJhWgJCLzRrWgSsPenLNm1bsDhDVpdmQEt2P1Wf1c3rHQgHtoGeDaKzD/as2/E+/kkrm69Qz//n1Nsb1VLWG6Ke1CEvY3L1xpS/sz2m/aXm2V6OHdwuzYG44LtX7j0bHEzpUpbsBXePA7B8Cd9wDCFOj7eMGI0zEj2xFg2s2OdKsO3tDPy7vH5ZSGS5OjrPV8TkzpXFj04h5ydkKBBSzPw26WcbWkZDmHneYLG+Xnl05b3FWr1z8whvQ7dxbgQyRxKavVjFJz6qzvC6TWFJST6JHSztEenfneqAvIZmZ/aV/s8YQMLCZahB9h1YkwX//4YRxMI+pH1UwIIYmXPmE76LiBbUXy5eqycjZKkXdzDQZL+F2QdywT+PZl+sXJ5x8SIhq3N1m8aI0JOnLC7FWfD5emIG9M2Lx0NX2C7kUCBRqdPzML2vRn1ahfXHpHwvMXIJgyqEftFX7NaREnmTOJ5kXUC5+WxnRBbolxmbYwGEPHPQC4ohvNSuDJze4Gr+cIbZK7K8EB3xydQjGCgOkfYGLhBETMYNvloxfj5KZ33MtLNZJP7cEpHJlZFXnMG4WBApZgEdk+tbvIhv6yRCHhDbM79ruk6qOp8e7Av6ShuVqijV1jTy+3NUgRwNvTUnIPifR2TlF9tKKHMzHxisbfDIEjG2bLnvMFcuN9KsYwM5ocZEsCCL1ugRMjEYzgmKyiT7uRBANGghCrvCbwfNlkODtHHmydR52HSW1dtnwImdiTLJrDWT0d75Fr1wGjRCiWag+qkJRoCy6dUZRTNAEvQ9uvhOwWi3+SWS0zm+K/X2mKjFWKadzmP8LGCFbiDQZUKV0JaAxurAWDKbV1Tv+i+kJjLYcnbU/bqOKlYAZ/US9cx2ID
 C9PJGpsA
 pZwuzYpEkWEVoo3lfVrb+SudLx1OgPeIPu40ropJMhhVJGNtuRB7pMLtnHJqfDowGO+ujwW3bIEJn2mDbSIf+S5zQw2egNKioFVf0W/KAJ5CKZHn0m3kTmiLRnKFlH/YP63iZWqbm9RXQvw2MItCxQtYAoX0mu0IvjwUco0S9u3/4prBk8X6YoGH2t+DxrtjCMR9yXohJjytnjqs5rTeO6x0h0duvM+iyEd0E1QuFhvsI661aBnqKINEqW6IvdME/XrIm6oHpGhGGiOP0aqDhF4FIzl5Hsf7JIs13wi89OAwl9J2DSviZN2gfmK4OMzzBL7ibwEbigvUm6u/Ne8GdVgdJ6Z1/0cX+WrNW41tRbr51MfK8CVZlLtar2ABb8qmUc1mhsdPrIy+MCuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 12:02:42 +0100 Alexandre Ghiti <alex@ghiti.fr> wrote:

> Fixes: 9933a0c8a539 ("mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations")
> Cc: stable@vger.kernel.org

Please let's have the cc:stable fixes separated out from the cleanups,
and prepared against current -linus mainline.

Also, when proposing backportable fixes please ensure that the
changelogs carefully describe the userspace-visible runtime effects of
the bug.

Thanks.

