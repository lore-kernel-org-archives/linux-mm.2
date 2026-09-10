Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4640C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 01:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5C66B008A; Wed,  9 Sep 2026 21:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695246B008C; Wed,  9 Sep 2026 21:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABE56B0092; Wed,  9 Sep 2026 21:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3715D6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:46:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D1D5A3F77
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:46:00 +0000 (UTC)
X-FDA: 85196161680.19.43CD2D0
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id B7B2D1C0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:45:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789004758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c9D4/37StdW+/oBzY4eEwtKc1OugVeB5CDJ0FqRkHFY=;
	b=ryUWFCz2ZZGi0v/E/HBJ6uaUpKjO0bd9hwrbZZ//aKK5v5tWdP2EMQ3q3hLp+SRIOH4hbs
	utj4VxgGp35SnDiDXXMx+W4snDNGIbw+7WGx/4+OJ4JB5A3iw7mWuH/MyJKs9an9QbnlzC
	uK4dROEgbNAXWAAUV90yZk/N0kq2/tA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789004758;
	b=76T04HbVTc4WjUdjjq3swFnA80J8MoH6lB2vBWdSYiajHIeCOCCGO5op7zKwJPMOK2Iy38
	7bMBqHfFuPB+RJxD6LfP4V4hnUYoRrSnVSUI/DmDJ6QSPSVjDLSxUQ6SuYR6JIcrqY9ol9
	JX+9bhZJAF8PqzwqnDTe6m4O0cSXFGc=
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.52 with ESMTP; 10 Sep 2026 10:45:54 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.126 with ESMTP; 10 Sep 2026 10:45:54 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 10 Sep 2026 10:45:54 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, her0gyugyu@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-ID: <aqIL0nNT/RF67PIN@yjaykim-PowerEdge-T330>
References: <20260909161552.2335971-1-youngjun.park@lge.com>
 <20260909104939.5203c02695fcfd7a95f4b26c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909104939.5203c02695fcfd7a95f4b26c@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B7B2D1C0006
X-Stat-Signature: icechj7dmfm8t5qkcedqqca5y4qa4eec
X-Rspam-User: 
X-HE-Tag: 1789004757-665059
X-HE-Meta: U2FsdGVkX18OV6CsmXbbVLzNCIIJ/tPwHhVqLMwgwY25XPW21V4I89G1wjtha6GWONLV7eAuFhiSS/iIb52+zF6uGl/qATioClhW/PwUSV/23AsO5WKmm5T8XomGObM3j7dAcSt3h6854tpJhjxq+tBOssouiJYH5WohNEZWWRH9DJMh8YD0NsilCeqf0F5RS9N8T930GcX2utlq937blFcQQmwvoeFS3m7GYjrG+obz9Wq0ql2Xti19WZrKMZqNwVD8QHeWtZLOeG7x7jS2gNAsLuIODQHmgNiWB0Q1Ts6xJIAUdPUC+CjIqsEMdh7+GEPLc5/9R5s7ME/meEtFv1QoS1IzY4omLp9sYaQ47gjwW+pAajmA7F0+OhhdN3xK0CSRyIfwk2UejWZ27b6vFxL3qOzLNwGTws0iHGxyFSim6keBdqsYAEGR0qT+mTFS1NLfYHK1+CZ5YnBnLiXHTCNlhTQbIFcLha082aDx0FiW6h7noJX9eeIBIohFcW2fC05AmPHLMhrI6fO83u+p/g0QTRcbD6l11Sth5t6BL/33EtTUx+Gs9e6yMMVkvIX525k7J4qt/gXyLlByRzQLN38+vXf+1f9J5gu+gqvR3APWIJ6blnswjFGyhJJ93cweeKn2dq5yj4gTravnjRtVs6NDlWIIWH8TsEgnYuZJGRpROa1V8uJiUZKM3UDDr5YNLkcEHJlmwHOT+FoZnrtZmbsoeYAimAF0PAhFqCHESuhlcGhXtudipHa2VHlZ2foUq8/CZHrO/6cmBb5A03+Ej7wDLWOl/er+/33v3JL1d85BpAESq3p0h+k1IidJLzHlrezhP76LaTG9o3JaCJIcbPe4wSY7ByhWLjLVm3jX/BK+XfvK3MEBwwjmv2AEql58q3Lb8MLhEHv07z7gkt1a7qv1v0raIkLTwKW7MGdu7xyjOa2RV2iaOubz+2ZqmTolzyT5GppdZDIia3Ff3EJ
 I3/J44lA
 1mOnZmWNRElxqheTh3F/pEdxGSAAhm5HQK17E4vOSXH95iqw9RhbkHdfcDP2dtVwN/oGgscyDk/c09ICco0pxuWZk3PCkr4jZwMAae36Zj90IBjqoIysYNeJ4IQ6/UOhAGiV0iJNcqsjfhV6IGMHlUdGhQov6wHEKXdsr89sPV67klmnf+SRFAHC9SWbGyGA7f3YnxDNT8/LWXz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 10:49:39AM -0700, Andrew Morton wrote:
> On Thu, 10 Sep 2026 01:15:50 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > find_next_to_unuse() walks a swap device one offset at a time.  Slot
> > state now lives in a per cluster swap table, so patch 2 dismisses an
> > empty cluster with one counter read instead of SWAPFILE_CLUSTER table
> > reads.
> > 
> > Patch 1 is an unrelated one line comment fix noticed on the way.
> > 
> > A debug test confirmed the skip path runs, and swapoff completed
> > under load with no DEBUG_VM or lockdep splats.
> 
> Please let's try to make the [0/N] words provide a summary of the
> patchset's effects.  The above didn't even tell people that this is a
> swapoff optimization!

Hello Andrew.

I will keep in mind, Thank you for pointing it out.

> I asked an LLM for this summary and we came up with
> 
> :  Speed up swapoff and reduce scanning stalls on large, mostly empty
> :  swap devices by skipping empty clusters.  Reduce swapoff time on a 1
> :  TiB device from 158 ms to 94 ms after filling 128 GiB, and from 392
> :  ms to 73 ms after filling 512 GiB; expect little benefit when
> :  substantial swap data remains.
> 
> Does that sound OK?

Yes, sounds good. summary seems good enough!

Best regards,
Youngjun

