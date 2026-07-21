Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304FDC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0700B6B007B; Tue, 21 Jul 2026 09:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021386B008A; Tue, 21 Jul 2026 09:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B9C6B008C; Tue, 21 Jul 2026 09:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF1C06B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:06:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFE461C009E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:06:42 +0000 (UTC)
X-FDA: 85012808244.11.826BBCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 94A814000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:06:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=TflpULBP;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784639201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAvC7NZ0aC43RFdOVjevlRnmxAEAMYI/EG3Kb+rwdd8=;
	b=2QLhfodwmIsJcv4Ln0fZzoi95w8ZdSoSIbTWqqSpN8EKbU6xpzdlZKjDyNwlvZd8Oe7AXu
	ABjAA6HhQtO4YcIA2RZkxjH9imRLYNwv8kxqqUS5g7Vd6NnCokSCIROX3H5blPGhX5sHAA
	iKCvzoy7DhKIZ9Q6cISuQ3rI9NN5bEM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=TflpULBP;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784639201;
	b=7GBEZXZ8/GEQpqCXkzYIiNWmnmBfc25lBpA8PO+CKkjGFJjYTalX9X9oN3U93jTxcy7v8w
	g9sHd4RVxYjbRVleQ5E9RH8F7MW7+XTOfGAH43e0i98Xz7L1/Ik46NnxTBH11eS4NRmkl9
	h+1E0alYZtY1ntxRCdl60yXTNyR9RKI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE5494150E;
	Tue, 21 Jul 2026 13:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BC41F000E9;
	Tue, 21 Jul 2026 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784639199;
	bh=gAvC7NZ0aC43RFdOVjevlRnmxAEAMYI/EG3Kb+rwdd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TflpULBPsUF9aflAlRjqyKq3bZoqXA2/SV7TZ8SpHM0qr532SxGo94jmG94f/8458
	 pmBaVGp1KUH9wdN+7AiMIEUWNhJFcN0SWo7CmJjMnenC/WRsOeSx2D3ONFlOfJws+X
	 C98g4DPooh9J2Ox2vubP94bX6CJqIetdqjvDeXhU=
Date: Tue, 21 Jul 2026 15:06:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qi Xi <xiqi2@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, sunnanyong@huawei.com,
	wangkefeng.wang@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH stable/linux-6.6.y] mm/memory-failure: fix missing
 ->mf_stats count when hugetlb folio already poisoned
Message-ID: <2026072112-lapping-turf-bf90@gregkh>
References: <20260706084118.1284271-1-xiqi2@huawei.com>
 <6a756801-f4a5-44a5-abfd-e9ae57432c56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a756801-f4a5-44a5-abfd-e9ae57432c56@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 94A814000D
X-Stat-Signature: xh48c76phkjkmee61qz1bk4eoanertte
X-HE-Tag: 1784639200-241626
X-HE-Meta: U2FsdGVkX1/MbeAEgSr9WuuO+vMdgGRl5CZSuD+CBJJxDicaMSnwhJMvmxLjIzIq/P/g9V06Vd1wWD1zXu4D+SGIAQKW16D5nWZG9vGw9umUNxeYKCUVsab23s2zsVK5/ZGbEIPwVfoV1LKSLHmpy3f6y8t0MbXE2wlnHx6BiGF1t7PYw6D2xld575TaTUYf4ggZlITRit1+wmUU0ByU9mxFF7QzmOW87LCgyb3ef75gd9krGKNRMG6ttFBtIxenaFTrEXRFeODC9EbRzC8xocrwX14sD64XRy/qzgyvoqx9NWr7CgxvVtMuwzAWJWiOQ6Hi7nOsRLjTZfyPfF5k/U8E78r/auw+zqDk95CQdjP3rFD6y9SA77pJtAzfdK11mhfT9ATSz70U5DxsXUSFNJGWQ8WQ81PJ0g9ywqkeQzU5YB+8l8IDFbt5B0Xle2PAW8s/U/1ujyyprQTtv4XjxjCmXcgnncPG/QT318V18NGXA77sxsKFfFhWMTZ/6jrwZpcWxFUqot6QqUykgZmN0Nx9GdILDz4VMaG6u4R1DRi9Pcannc7kH0d8W33VflPT5KnAIimliCYUqT3AMZwTIbxGq7naYvHd0/vzF+sMlQfZKqkygfJazEiF8jCVQ9Qtn6g6SB4s0LOmG6f5sP6dvtNeKiU53mzhyn6mwO9wH1gunywMg2ztU9lhpqtUPJ3TR9qLafWmmh2xseZ62U2y7Hc+xG4Vnc/aPJK086A3FFlIV34r3wvNrv6X2gelRhccJ80A6Is6rCoO8z9lxshtvJi6nYVsT5T95i89lljqDmdGOg8q0hjmEWqYxy4kt2T3ILKELRYV/VgP6JQrFeSFFuQXqexaiK8a4bnReAST3tiyQi3nVSuxZghUdmNN342ARvwqd2CGurAdzDz0TFfIzf9653TpWxT//GsjJzABpCeHj7wRIOL8z4loV3p+i5qHHTaH6W724z8QeIxeMtp
 /g6ApPI2
 0ZOp3N+sfo4ingCoILT8t1PxFURfUCezqPhMZghwwR+3BbFw2tPXgD0zcoRsG4DWArGPIbtbq8oSnzUc0849/4omDvkUM4x2V7oxx19ffOTcTIYAssIHus5xvQcBStdn9H5+Jg3vbpK/lQctgD5KdV500RaVwD4lIbhVminipxHa97kvQMlGw1xWJRbe3XoxkbQZLjRJXC06VmJ+8xotwQ0Vwc0FJxjYXPSLVTPjKqqs0UvfWEjz0VWdN0vMmToyxLjISyxnIhSV2Ae/XRU2Q+yTrHxp1pfaDe7m6aFtagetHOWUgxTHN1jU9RJDwOHIHQUDf1w+sY32jNNGv1CtBLIdcH+jscerCp1bciIS57UvwFemKlRhCn41CcY0jufI44Nl/GWvdylpANuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 09:45:03AM +0800, Qi Xi wrote:
> Add stable@ to Cc.
> 
> On 06/07/2026 16:41, Qi Xi wrote:
> > When a new subpage is poisoned on a hugetlb folio that has already been
> > marked hwpoison (MF_HUGETLB_FOLIO_PRE_POISONED), hugetlb_update_hwpoison()
> > increments num_poisoned_pages directly, but the per-node ->mf_stats is
> > not updated because this path bypasses action_result(). This leaves the
> > two accounting counters inconsistent within the hardware memory-failure
> > path: a new poison event is counted in num_poisoned_pages but not reflected
> > in the per-node mf_stats.
> > 
> > In mainline, commit a148a2040191 ("mm/memory-failure: fix missing
> > ->mf_stats count in hugetlb poison") fixed this by removing the direct
> > num_poisoned_pages_inc() from the helper and adding action_result() calls
> > in try_memory_failure_hugetlb() for the already-poisoned cases. The
> > backport to linux-6.6.y as commit 252bb328b36f ("mm/memory-failure: fix
> > missing ->mf_stats count in hugetlb poison") applied the refactoring
> > (naming, constants, switch-case) but omitted the core counting fix,
> > leaving the inconsistency in place.
> > 
> > Fix this by adding a matching update_per_node_mf_stats() call alongside
> > the existing num_poisoned_pages_inc() in the same block, so both counters
> > stay consistent without restructuring the error path.
> > 
> > Fixes: 252bb328b36f ("mm/memory-failure: fix missing ->mf_stats count in hugetlb poison")
> > Signed-off-by: Qi Xi <xiqi2@huawei.com>

We need acks/reviews by the relevant maintainers before we can accept
something like this.

thanks,

greg k-h

