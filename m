Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCF7103E162
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB326B018B; Wed, 18 Mar 2026 07:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C216B018C; Wed, 18 Mar 2026 07:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6819D6B018D; Wed, 18 Mar 2026 07:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5792B6B018B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:32:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAE771606A5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:32:23 +0000 (UTC)
X-FDA: 84558970566.05.CC4884F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B60764000D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:32:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W5jM9K95;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773833541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R//hRNxAoqWyABoXCwcHk7g7S0ZjvnmQaJYFCwkVb3M=;
	b=eLVZoTIFrfgDpjlWgG1Yo2wXB3Ze1ZltdTQhNABSTMDbKXUW2/7/7HckNj3JQfNwbJDHK/
	HtD6tYZjDl4RCNrKXFy2wJhxuGaBj9N+nyMXFirehFu4FnfDex0qBA4BAg/jxRxoYkIy53
	SM/zfSLlwTqNp24guTvf2oDptCn5wyA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773833541; a=rsa-sha256;
	cv=none;
	b=oTMwfx+vo+I1ay+CMowf9JdkwlQph7+2G8uR6ehl4rgo+97Vg7QP7fVdrwXfEMD07MpMOJ
	2UesiStoc754LNV2Q424fZLPr8iyd/8740tkBIL3QbSh6tote3S3lrnQoIHaPv9lwZapUX
	uFGjJ+jykzb9mAP3DG2QwpmxPMR/WDQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W5jM9K95;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4843C44839;
	Wed, 18 Mar 2026 11:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B008C2BCB4;
	Wed, 18 Mar 2026 11:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773833537;
	bh=R//hRNxAoqWyABoXCwcHk7g7S0ZjvnmQaJYFCwkVb3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W5jM9K95/DWUgYu5hZ+3p6ju4Ia4B7o5b9j30H6XgD6UoSIvS/lTsTypNXXToZ6OF
	 wtYxJ1mqPlFEp3qPt6cnv1+m+TaYK80euQ7i7TB1WFDU5L0QUy1WJ96ydPXcCQGdHu
	 AID/65D6nRppq07Vr3DknUSXuGve8NHQK8m47isO5RudZObvJbqfae8VkMVLl4tUTg
	 vyUSYUR/IOjG7gV/uz9je96K2vXsBSGh46x1fBCWakynXRo/DP/dWVRHlwXtYXRNHF
	 BpJFsJafe0rDG/AHvUt2CzARvRGz9EaVQ42yasLMqKV7I0wnPeOhyxO99+QGoQkIEJ
	 RKnBrwEYsXg+w==
Date: Wed, 18 Mar 2026 11:32:10 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v3 0/5] selftests/mm: skip several tests when thp is not
 available
Message-ID: <893e70b9-1ed2-419b-9079-5b397b2cec54@lucifer.local>
References: <20260317094419.1429259-1-chuhu@redhat.com>
 <20260317113730.45d5cef4ba84be4df631677f@linux-foundation.org>
 <abpu4OMsy3Xl5QA0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abpu4OMsy3Xl5QA0@gmail.com>
X-Stat-Signature: c39ujoe7znkf86s7bpfxs5ktqrp7py6t
X-Rspam-User: 
X-Rspamd-Queue-Id: B60764000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1773833541-919672
X-HE-Meta: U2FsdGVkX19yHk6qOcR4COeElLK+KjRuVjJynCQTHyRlwk/a3HSPviEeoJQvqvfeIxXLCTITg/wdZ4UhNwG4kw2PFHH2xiI6hfhkgLXp+fOyojpfCf0Kmka1XdmZ+LhRBCcnRG6kJDoQYYKpiXP3gkLLgqsOTeH7ITO79oLwLfVd1Li86BXYBiah0NtNzLp9hTqhuSyP8pbpa4XUibKRsDB4liWla0s28UpjFIAwLmQ6MB+Qp29LSn7P87NHThtLwyW5bImsWVDlWYlYtSUdtIDojqqlrIlnBs32lf16jw/49dHQP47WRpt1QcC9psRWbx27XkTxPKeVAmSweQYmua105Y8C8HLfWS6spTwMx/GYkk37VMp40FC030aLwVhJapHIntb1HGqnz/6tmury/OVs5dtn7b+lHDiilx5256f2advo4IXbDb4ugS1Omlu93BZEYWUAyiivJImlhLFhR7tNYfgDUw9qlDXXFBXmq74tbIVsZlpby3Lh7/rkgf6w175R39FNrPo8Kz7b44P5HK5g1iANH92FqOYVsM7eUj+RB/lYI/i0C18uGnGFvHpgyf3RMbuA4CfvZ400L6zYryuaOofi5kwTkY2dOt5q9nk6OGIMtvjJigceX6Xj3bbrBiR1qkwGSyQM2Zy1ClCU7YSBsEhmRX4T3NASsNTALeyjmAxHxF39smkA39pDawT2ULapi+EDfkayNtwqtyhm0cttWsG7boAsSVMt366m5KMXCkC2wXEhKUa7YGIPuizXFOaklTxa9eixIF3UEqkAJ1TBSCfo1dO9KL1lCpujghfQjlVAPuqSRiUKikWMeYsy17ismoF8FIA6iUbxCGFh2NJpV+SPaaG2h0egiQCAqBxezSgirGgzWoC91DrDjl8WmpJFmVJAmTVHz+IVM5ggiWNLx6MNDytBIxFJPFYO5rm0vvKm2ue4M7XD53xiWUdXkv77krIAqJBEjhOSuq4
 k3QAvijO
 7zqkdnn1DLpdj+rnZHTRx9YU8Bw/wHwDEi1IAyCBa9oDYbkLn43KY1s1s9xzfrLd1PkfhWcy8CpA7U7+q1ijeNHkeXaR4kXes2bQ4WIfOWEKxXytnDi4yjL3qvmdT4dNXugngkPYY/7UiQ3lxh0Z4BzjkoPUWg6lCasikMxTUazqTJtcO+ntg8bVtbJwNTb9fnr3jxmSZnS83MK2spw8Fkph3kxz9V07sB5FXTCGY7DlkPLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 05:22:40PM +0800, Chunyu Hu wrote:
> For question one. In guard-region test, collapse tests are for checking
> collapse is denied when operating on guard region, not for checking
> madvise(MADV_COLLAPSE) will fail when thp is setup to 'never with sysfs,

No, if thp is set to never, madvise(MADV_COLLAPSE) still succeeds. This is a
source of confusion for many :)

> result is same, but it's a different test. Maybe we don't have strong
> interest to test when thp is set to 'never' in this collapse test.
> Do you perfer we let it run when thp is setup with 'never'?

Yes because it should still function then :)

Cheers, Lorenzo

