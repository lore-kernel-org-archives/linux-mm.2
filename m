Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E170C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 10:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182676B0088; Sat, 12 Sep 2026 06:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133856B008C; Sat, 12 Sep 2026 06:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022BB6B0092; Sat, 12 Sep 2026 06:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBEB16B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 06:35:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B719A04AD
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 10:35:13 +0000 (UTC)
X-FDA: 85204752906.04.0F61534
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6525314000A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 10:35:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qSdaSBdt;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789209311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TpM6eT1qzg3MP+tpnO3cMXPs7X9oqBa+IzWYgCHuf2Q=;
	b=xnL1poRUob5lkzOEkc+WH7ibHKPzI27suQc7W3X6f5u1CELqgVBYnJ2MHGNy7iZbNOP8dM
	a1lZwOHFoq8TjmTQuMOHmSb8W+rDMsChOjsRRCdO4YFl9DfO+CLf9bG5ZN1Yi5HJzDjVeM
	G9emCeBmY2RMaJc0SN3zeBCKLg/YWJM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789209311;
	b=G6iSNoc4vY3OAGmXDfcU4Nerfc7UekUz+Dw8r4lkHjbfy+XfKtoffUlj7dA88tHfeXeLTH
	IM7u2Z0RVrf1honoH7rhRIBxOIljdBj3Heq9a0fs8mdc+a6bW5rkDSM69wNsES9+3wbRyi
	2EFJJtI4zTPEt+YH6YGBkDDZb8PitE8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qSdaSBdt;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9121fe38733so3571156d6.2
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789209310; x=1789814110; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TpM6eT1qzg3MP+tpnO3cMXPs7X9oqBa+IzWYgCHuf2Q=;
        b=qSdaSBdtKpCyOsw0KKpvDApK4yxm4Un152WrpSR5XcsiAtGTdKIn9jw9x3UVeBcE2p
         bbIfkoF1isR6YTkgOW3b67yk8jEUVyd6WNzTW3UeqhWKZXJWx9J4Nm1jUTBqdPQYoChW
         /XI2BN/a9zcizUy0wtq7isLsz+W4eQ/pC4UckXpanIF/sbC6d9NT0sM2JNtXmaPXHuK2
         kRr+kXEfkxi4SrcI9pnAtJ9+fO+AArV6cvHZrXr8hboGbFbvisQf/CVUHqKfMN5su/Fu
         UJ2CeXj/lvFVPqv6qU+/nJHOlTsmc/a8VBIpilUOzkjCiqs1hNBDfigEgGgxEqVShCbn
         8QrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789209310; x=1789814110;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TpM6eT1qzg3MP+tpnO3cMXPs7X9oqBa+IzWYgCHuf2Q=;
        b=tXTK3zihxu3QTVWsI0WUON0b4/aCwGI1ZD1gmbGcGY4vkjVGxe299AAfQoAed1vCk7
         etcCJFO4Ok8KgzBBhPxPXKC6G9K2KgVvmfp8JcJBZScbU9TN07SxdQwFUvvrVQTUB6ci
         JuYtbl574n50UXcwiUO6mlz8gQ1WHon+zFkF3YJoCuGozjzZDue/3wDiVBq9AxmrAkZt
         7XEv8Q2GUT4Sw+RA7d4oe/oYiHkiyASXuApwLyp8HLtSjd9Ip1JmrAui/A7gekWscNfH
         Yh7tdPN+uEp/GjU+l3g1M7u3+bUBqEl+NIRLKY7Iw3XMrUgKYlp6Pm3pY+iyvNKdwYSa
         faKw==
X-Gm-Message-State: AFuF++mwDUEtVkcJ0h79d/3y+WWK8d0TEKN4sd9feMCXZYUagYj1QgXV
	3if+FGeZjGjQmw8n/kuLF2wPhVdKT0J6kGhRPQK9OS9GXnSCnqKxGVFlFs1pY3rTJDo=
X-Gm-Gg: AYBFou3e5kvBditURMGplFS7LT1plgTGzGVt/g8sE3Kmf7ySFJ6JWQnfc5PMcfRpob3
	+5vk2I0/7+mqsu4UbCy/e3+ckkJ1ZiNhhuuAWDRa7Q6FfzSxsT9SpETB/CseleWqxdxzLTLHeHb
	B7euEBp1hQfCo1xsksWAb2epSDozkLvJvDVnp4m/92ixp1ShnZQkCyd8CKlKTPkmR/wVwkIjnJq
	NyZCqV79O539UyRAj5SBtehfMtrDuIususUDfTa/yovsvvFS5BTNXr3fyXYzW32BFFHzxZCl4EV
	KVcIxrJJdRJO5WtO1BHmxi3HTzsF+5Ox6zy+3gxWPVupCmwkbv+Dm2Z5TDP/q6+U/l6PbFy3S9k
	C/rbgomX9hc7epGmflHLq4Anxew6k77xNusS6b3WE2JLvH0iJ4ibUKD7Aevj9lW9ls5WNlwAfsN
	uFO86w/ZWH7K1RiSfk8hxXnsar4b6RZGOUyDOMvXxXDzdZtVBAd3ZzTJA7ih7NXlHqx5xWbaCD0
	sGVGGOzMgr8c0Lev1JiJLN4UAK9SkcufOYSuqx1EjQu68qsOGxZWjYBrwJQb7kNxA==
X-Received: by 2002:a05:6214:6283:b0:912:12cc:33d with SMTP id 6a1803df08f44-91212cc038emr101201246d6.23.1789209310586;
        Sat, 12 Sep 2026 03:35:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f203320sm43584706d6.1.2026.09.12.03.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 03:35:10 -0700 (PDT)
Date: Sat, 12 Sep 2026 06:35:08 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, peterx@redhat.com, jgg@ziepe.ca, 
	sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 0/2] mm: stop calling pmd_folio() on special PMDs
Message-ID: <aqUqefve3AEiJiPq@gourry-fedora-PF4VCD3F>
References: <20260912034833.2952750-1-gourry@gourry.net>
 <20260911212503.bcf8461db17ebbf51233826a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911212503.bcf8461db17ebbf51233826a@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6525314000A
X-Stat-Signature: 4rxedkceucoaxffaowx4g18uqtknh77k
X-Rspam-User: 
X-HE-Tag: 1789209311-976894
X-HE-Meta: U2FsdGVkX1+NnMB52yU+k+BldTh2lAKZkmQJP50PI0daHXksLmaknfJiYZnDhONtr+tCTXCDAsu6Ve7t3iTrVuEz4e0KzKkjZAYmN281DYetIAZHrFMMQXAzIVtFgDlSNx+R/5wsBJjbqtQc9Y37gNiKES2UfCUml1ua3SrrsaATWf6PLRyMVUhF76cnucfSgTeM/a1xKT/paIcNXO17ZC3YmxhnxnuLiKWNmCoZUrH1SbH1iyY+cohaMi1n+N172fkeKaaA1Ew+5Fn8KT2RPAlbl0s7SBWZbUIq7Ft7A0UjcVn8zPsZe2HgBW0tYSw03/wN+LfYMG/GlucCIMmTvHtdBBMpr+qtgXPSoThS+UmBvJ1TQtvfUXzaqh3BpcQ6cHIZNwVtjVpVlNo8HKCL4vW2DROPRzQkbXzgZCxb2PBFolKN0ijt5rrf2S45HHv0XIwpLtr42JKnJnZiM76gch/PV7+1hQSa+h8p7P9AZWBY1vt7DgISUNCL78jdLEhihzQLFeN/JuW/zjOkYueS52V2thrDNrWy0fFrg4F63o1hfC6O3dpd/JMStpbqgNqEjQe2uX0tdC3UM8g1YWjzcnBfTiarrXGTkkx6CMgcTOQJ9/UVCQCXJzY+Y+7GMovtw8nffmBM6aUZsa7PzOmp8yH0WnXOeNWvudrk//r2a1Bxp9oWYBu+PFIHK/Boj4WBHzYTJ8Y9TWYeWxgb/jLAc3JU6TMB7qfOMA3XtpGtQpUzBjJiD9fE5LVIyaomkjkMUhMOdKbdTeolLbQhrvDjE+VuZhSnrKpp9qwsIV+qyoOXGXf/1hVqxL6RG6Hcz5ToZ0ewUgGQWJ64xMFfIb9qQQMpeG1yn7S1/csKnTX2UUEtbtsRKoqu5unVicPZxZyFPtpUhn16sDimwJywbJGV1Ns8Gc7oBE/j/WGJ/uVGdiA5tRJ80LrK20O0r799zO6mq567IZc1dRZ4DNdJnMx
 tqKzAEu4
 YksSj11jqtBzw3u48/9ehH6pK8ufSG2y2apst8j4LkIfStomemv1cGGBlneI5xaekvu9SfmUmJh9pAdBDflSJyw614TswpCMFldhqHR/dHQZSLTposlEtxT8VXXEaVvlXQy1h6DL5e4HHZD6P4Dv94ccIpNWQzag+009f2r4XdbNtQUZnIqZ8qVT/u8Ip1WWYiOEe/+i0I1vGGor7fN/3eRuA4X8W8Hjwav7G8rPdqIWpOnS9HBfDQcUpMLG6A4Vi8JibeoKzuPHfTCyuX5L0Q+mZ5G7g3XzvVmiWvn8PVfCqGCkMqzn8MM6f/8kYuWMk69Ho6Lq2FKDc7h0xEAXAxOyjVJatsN8/K99WZ5EJHQnJpHnGLQjxmWoMoGIM7C89LkWKnR59jnpFuK3RttnjMz1XI7u6EAadJ/VS/666DHC022Uzia7d9MHORSAXH+ngD0go0hJj5maDrZe3cxe/PZwQ5Dppe29LumHSVPSTC5C5NSLSox3y/QxUO51nA0r0isNi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 09:25:03PM -0700, Andrew Morton wrote:
> On Fri, 11 Sep 2026 23:48:31 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > Reproducer
> > ==========
> > 
> > No hardware needed.  An out of tree module stands in for the drivers above:
> > three misc devices, each with a ->huge_fault calling vmf_insert_pfn_pmd(),
> > plus VM_HUGEPAGE so the fault path takes the PMD branch.
> 
> I take it there's no known way of triggering this in current mainline?

As far as I can tell there are no in-tree modules that reach this state,
at least not obviously.  

~Gregory

