Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643B0CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F4C8E0024; Wed, 10 Sep 2025 11:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8C58E0005; Wed, 10 Sep 2025 11:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7858E0024; Wed, 10 Sep 2025 11:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8617D8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:39:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EB3F160112
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:39:27 +0000 (UTC)
X-FDA: 83873749974.24.D85AA26
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id B6614180006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:39:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kzR6a25V
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757518765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUutveEyfKqm5cx/LfUOapSR3j4/ulAO8at0Pp1NTFE=;
	b=O6ktca9cxSL9Ix8lw6z6yLeHaA+CB2tKFbTVkPA7NDVeNJG2qg30YIM6k6FeDpnjehFS+9
	yQEwhSL6FPVJXxqjiO6w55MDR8iYVg0j8GBQqpk+XYatKSWlzlj1RK6xtiEPoQEoCCI+Po
	61Rjm+1Cus0yey7NrvD/6Z4DYgrqS34=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kzR6a25V;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757518765; a=rsa-sha256;
	cv=none;
	b=P2Zu2/3WqZpDWJNIpss/VJB1haci4/3ryCFLj2OZCnmaOHF5x7931HXaUgYwx1YomHJY8R
	Fumbxvfa3Q6RLgxlEXl0nGjNtPNFWyIgFcPEmveMVlX6DxFUJZXmzBRQjjdoHWspiFeR7u
	9ifWjcHbzS//CpiBo5UMbkPK+bdhxZc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CUutveEyfKqm5cx/LfUOapSR3j4/ulAO8at0Pp1NTFE=; b=kzR6a25VrUvMlMmbSCZhp+Czc6
	Sak7r1ylr5JNvroWqy7LTUK8Gz4Xaw4CyeFBQsOpShvsb4P0kjH2FW4KxqyUfGPl6BLsL2lAzfL1Q
	OzyoFj9V/erJWmxACdvpYck0kfmymzPEJa72mnSJDxrUCJ7Bbfz59NA0qaptSDfCS6Yr67CRdByxF
	EUeCMdMmTx3dMwpsPGXVBiKLVM1PwTga2ZazfaS7vi4p+AQ5hCxT+xKv5MZ8o6pEYOOJ/eALxvSTc
	1DEjj5nw1CdGpy9U9SmKkQgS6oEpYh5L4PhWXQKirs3U0GtL+uea7X1+aY6ynLAaVVPf30+JvV37t
	GT7DQ4Wg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwMui-0000000BFcE-3PjP;
	Wed, 10 Sep 2025 15:39:16 +0000
Date: Wed, 10 Sep 2025 16:39:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	gourry@gourry.net, hannes@cmpxchg.org, mgorman@techsingularity.net,
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com,
	riel@surriel.com, rientjes@google.com, sj@kernel.org,
	weixugc@google.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
	dave@stgolabs.net, nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	yiannis@zptcorp.com, akpm@linux-foundation.org, david@redhat.com,
	byungchul@sk.com, kinseyho@google.com, joshua.hahnjy@gmail.com,
	yuanchu@google.com, balbirs@nvidia.com, alok.rathore@samsung.com
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aMGbpDJhOx7wHqpo@casper.infradead.org>
References: <20250910144653.212066-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910144653.212066-1-bharata@amd.com>
X-Stat-Signature: aeokcxsa3fdr68a1ekfkhosjd34hz6cd
X-Rspam-User: 
X-Rspamd-Queue-Id: B6614180006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757518765-994996
X-HE-Meta: U2FsdGVkX1/8sa3vfVDmCC55cukDkG15ux4Qiqd75N98N3zOlKy5pxr4lVRvAspR58Z8nzsNcmWLCs+PbKXlgGFodxrCIaoCewOgFHokRcI1lVgNrhZ7ZZImLmThb8mlVy2BiVz/icGYcUWdb8g932P8d3Mh6U4TXBbafZODtIgOMewoKS6N85C0epFU94xvPKb34vQXmvxPU1DY5WorMlF/clwelygH/U6j60KAYpi1vfnEjo5mjNoG2OvuX8aRHYC7gS+BDDfvxnL6JHojAUuYeM9OWHVvh+kNu/f1zz9GVbina8j/rgIcQ+7wLNKOd9SSbYwObmtLYLib8W49nFD4B2rWQiM6/oAGiKmsAYUaPhgeOrkrX+FBBiNJ+QV5EZ9MwTVq+LuR/IdEX4LA6CJx3lxSX0yuPZwV/W0hWaZwWIMvP4bIDx6nkwWaiY90ycdJ7EBQIdF6dP6k2aZnAgjbeTJClsennp/LCa6kUisaeF0lhSwGaoGZpnsrWBTCcnPE9hAtPKlxRpYhVWaBKTw3b+bx8FVD+Ivk6e9nMm/SNWG8dNwIa7w1j5xCwyVPxWE4jeMBWJcVT/xTKyvmF5vEYql2eyitHCL7BhpiRWDVJrtVjlMADgZU8v4Ffofc/8+JqrjiP9wE3R5Kc7V4syt9FM2qIEs8Oq9FGhYVT3pgPMnxBJiILYaW3GhpCwG8jZhKecyOrSnkQ7OYS80SOD+o6TVHa6WMXozFroPRQ2oaxAeyMPpfspSIRy+9SljZJgqCS9UE78BxuZfDSqXN3E/Jm21pKbNJucgOp9GgGr+NWBo4HT0N9e8PqYz9HIlW0daofEQu41vocAxH4bW6+MLbLOBnbMQHzxHk5uqmGFGL4jLGfDtanPALa//efnHT4bx6pQlTb02WJXGeBk7yGXds6UX3Nw9C+qa0R+fAuCj6dNpn48HX3pjAMeYqX8RnF1ZSM1sWZXTRudynlQy
 dwvuNUYb
 mB5wAhUoHbwkzSCDuTJXmG64X4xcnF8BvzxMcXjYiMM0myJCQ31lCUggp0SjLvkYasRSEJ6dxr7HNZZE5L9FG+CUG1iLmgHEtNNv+jmgvoQHtFHBAuLYVTm3cvbsCu+EtlueS8G4RSqbJ/mHe3h95V8EFL6g8io5sZP0zZkg19aSvsfZpREF7MxTfflXiNTpa1Xp8qHwr1kHpSXiM2Goa6+YsHbX2uDR3bEbC+2Ww0oYdGsmQlY9yMzOZZYCiGowK4ESwj4iFQZv69BZ00de8AZfBPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote:
> This patchset introduces a new subsystem for hot page tracking
> and promotion (pghot) that consolidates memory access information
> from various sources and enables centralized promotion of hot
> pages across memory tiers.

Just to be clear, I continue to believe this is a terrible idea and we
should not do this.  If systems will be built with CXL (and given the
horrendous performance, I cannot see why they would be), the kernel
should not be migrating memory around like this.

