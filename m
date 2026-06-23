Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A846FCDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DF46B0088; Tue, 23 Jun 2026 10:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815C66B008A; Tue, 23 Jun 2026 10:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D436B008C; Tue, 23 Jun 2026 10:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8AE6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:29:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCF8B167158
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:29:06 +0000 (UTC)
X-FDA: 84911409492.09.8CD5E85
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F04E140007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:28:57 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782224937;
	b=Js8yTj6XlKzsyAP7fe76WXL8AV3kO68A4dYU/e17g+52d89F2E7JCcz5Iz/9HDwgLyfQgX
	LEtG00Ph1PluLPtg5YtWZ69x2JTRDO/tPdffXN8t9/byCwf6C278s37+OAl2zhYZIf1WtZ
	azWNeDcmZKFghV8UXdRtTOOldzQq8WI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782224937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ObquCP80+lkdtJP6r9f8mVVxeADf+5b1sqhk+da61Q=;
	b=4UqsNCGV6gnlYmZUK/o1Ftvfog8AWB3Z3qx5hp+4ZVb4hRvaPFhSp33zkh1+rzbqPkyLo6
	7zw5sfbnS3BP7Wef3cxh549nlZJa4SFJjbHpiVHoACSI39C9tppCEZd2OqK9cEGy3Qn5z1
	ZbF2fJp4I5FkVVUHB/iCgJqwKWDy704=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TqkDJBRh;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782224935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ObquCP80+lkdtJP6r9f8mVVxeADf+5b1sqhk+da61Q=;
	b=TqkDJBRhs/kMRfcVBEVfJ7OYZdofHudk9xL2+AwKmb9Ll8HlcnAtbf9jjnroatxk5I2vx/
	85/OK0Am8jPd8UOuMkt/s53dF1sBLdvBIYMcjz/4YRj2iklTzb6oL50+G01vHsdoXkun1a
	Tr4dQ0nrwAs/9wZnrxfd+OFwV1RoS4k=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	liam@infradead.org,
	ljs@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 1/2] mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
Date: Tue, 23 Jun 2026 22:28:33 +0800
Message-Id: <20260623142833.60115-1-lance.yang@linux.dev>
In-Reply-To: <20260623125723.2503832-2-dev.jain@arm.com>
References: <20260623125723.2503832-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-HE-Tag: 1782224937-52733
X-HE-Meta: U2FsdGVkX19sphTWo5Rso2bBb3Zx2MhbChrJkCIpOY/ZDOCFgmAiE3pDjBqm6KskUuXQI7qoi88uyzk4WE7mPbMue0htX6RcvgHeJJlaPGv00wdYLzVwsP61CpSe5Y7PAsip3D/24AYGvpVjjJJBzDrvQy/SP9OJ7zPRUpUsbFk8HBqq5qq1lboklBTf0vrn6nMue0OXTVGAmGbz3UA1M3Kqi1Y9BmHL803mWnCCISso6lxxIk69ZXYBHuYP//jh26K7JYuI3et1JTtg+pgBtrFqbENURvCxM0gnt/exKU8yb09nH524Yuzcb4R/RLRbTVLU43ijVDZpa4Jr70CBNI47eay6/9IuNKtcSDMqIpX/1dNakq4izPD+j7XGITCPct4xzYdQ5qOGlE7HeeM2AyYEYYcqngP1d2hpgJgTU+uTQ6+DSz4ZnbbM882bijFhpVysu+aQDIhdE7LOGKJiZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 23, 2026 at 12:57:21PM +0000, Dev Jain wrote:
>Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.
>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>---

Just rename cleanup. Didn't see anything off, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

