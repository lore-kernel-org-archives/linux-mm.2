Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBBBAEA7951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 01:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F566B0089; Wed,  4 Feb 2026 20:46:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF996B0092; Wed,  4 Feb 2026 20:46:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BBE6B0093; Wed,  4 Feb 2026 20:46:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB9456B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:46:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84857B855C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:46:55 +0000 (UTC)
X-FDA: 84408714390.29.FDCD5AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E74AA18000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:46:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1tNkiPC;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770256013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjhQLU9sdDS3CqgRf8NTnKdxuoQOaLu/aBy4k7WokUw=;
	b=mz15ixfHUeis2w8duuaEJ7Wx8IfwmzJ+fRtmzuHfJ6pALapeeub7FqQJGay2WMTRvpkof5
	8wV1f4U/ACE8BPqzfsXVxowBRvtw2EVN6cinHqUHVSLeorHNCgMyzSfAIXdzkhXhC3JF+/
	E9oSDtVfsbxVpZd1ynNZW2tWrVoFCXk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1tNkiPC;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770256013; a=rsa-sha256;
	cv=none;
	b=yJ8Qn6eCivyUVheBs0r30BRXGidv4pXWhosD8qyjlB2roanAIPrkaOKMtfUvHszPsiVP69
	a2lOXm74HcBKyQhtmlW0V5HwWz05G+7i75vWDV5FRSSrf/Yl0Kduv4YWM+wT9YE3wLOEgE
	1ebYw9Xc4EjJ07QvYlQ/19/zDE7ypUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AE016011F;
	Thu,  5 Feb 2026 01:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E44C4CEF7;
	Thu,  5 Feb 2026 01:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770256013;
	bh=Jn0tURUv7jVaHct64j4yyI4cl+8f0h00aFkyfr381rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1tNkiPCtcnzOAEHD7G1rOpMFdo+hzBR36UfK206yvuXM+o7G44X7pXOkzTkNTJC4
	 60cuh7Sq5aaiWkgjkakTVPwl5NDkMzbb+y1ZH3dwQWbHu0acpgDG3iXIF+FEGtw8sl
	 BQpXIRxmy5qnYYUL3/4ZYLCd3W9jctM4Ilo+AIwWExnDOS5HGrj4UgdqID7VZBT4J5
	 kKKEJQq18S0c1AQ1tZ6NMTr4OLUpnQ/u1HUFTqiIpSiHrbYMBIQnsZRhSua2jq+zNr
	 L71b6+tpZgxoHGmETx387yL2qybsnrxUuBKBTnFoDkNKFFFP1tF7m9mj0/7Qb/s1Zy
	 TXF1csywk6bug==
From: SeongJae Park <sj@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifiers: Use hlist_for_each_entry_srcu() for SRCU list traversal
Date: Wed,  4 Feb 2026 17:46:49 -0800
Message-ID: <20260205014650.68624-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260204080937.2472-1-lirongqing@baidu.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E74AA18000A
X-Stat-Signature: 6jr6jw1bxrdb5dgtcqqbhzz651k8h8dq
X-Rspam-User: 
X-HE-Tag: 1770256013-781669
X-HE-Meta: U2FsdGVkX1/raGyg1E25Gc3diD2Je7hAJuUdOWz+jEHYoN//+H7aLr4vP4gxSl8wNaSKKhkgDU16i9Eu97N0Ihpj81eyg2MIJ2/4iXDyHAovZBrGryGndAheKC2HWOrWZnFLpVDSFKDZUg1Hc0VkqHuMPwQdsY05w1jcqxrk5L2MNEFF3iIhV9aqbIT2SJTQ7J0zdvLEZs2elqLEIBMYHdLSO9JllXT44y9bihuJVv8+sq/RcCfZpfAXq1eWxJIQmPIVHjnHlKslVZhnHwVb99W4aV2+M0wVTfHeC96zMreH3e96mxQUI8GZ3Aa9tjJoCBEtDrEzmpe4Hg+ha7TKmQx5B9rJE9v/Ld9iq/WnCbNAf4/mNHemlN74kV3oU8h7cqPZoSvnS2HBIZ2Ah1p6RH3gneUr2mRiSAXFq/fsHB1weONtArAnuip6OZkQUGs+ipdm5Q+e+Y1Ntft8pqxe5fQBciFA1TWdDd9JYM5f5w04etWQwhq06pXP4iP3o38FWte5FFsPNLUH9QYw/15WkbPB1w+8ZRzXlGzE0rnLayZByW5kChWy7LRY6H486yvR2+IwXH9cPiuY1YjdzKy+CSJ0CJX5kfV8QncDk59Zp+I4m2xU62JhKfIR9wFw776yA12f6Qhumxb7kX8s7vssldAa/5XXH+TRlUr5ne43hL0vXi3oEpV1UfYG8N4xMVU98juALyNHFOEjaXqXzbMl5wegZXABQq0/5UX/zPDVG+C5BGzELg8tTRP2nmCxjQmkcPqpKjHE464vL8FJ23s37hV6iHg7xqbmOSz9U1TtRvF5fqzTNzg8tVdKIGGfL5IQDfEgvnfFS7swWioFivImIubr6NS4PWIBUrAXs4E2IHOqycL5nXlw0Q8Qng31W8AKHQB+HDdsDIef4N8pSsa+A/xtCsh0HEA409S1AbbVbVaDpgd5GQeh0wl1YmwTqG5iOqoO4Y0AG2NGH5G7Kft
 kMlnbb7z
 xXMGl8xCzBcjVs4nWtUcWOK961Jf5NpZgWUIIfYT1MFBhrcajkJenw6xWH2EG5BVlyT4h470KVAD4oeYKg5bLfRZZOT8hww3d2zShRxqrdVclcvhiCo4o1vAQApiuDztKZreCt4T0WIrJzOpmAgauqs01E5t+rXzJY8f6IhuxPOnCjon0p9j4bdIFA9FmGg+dNJIamt34P1EwGgNi5Bz0Qb4HsAoPco+kodoUjoBm8VhA1XTHzGiQIDtW/7J/B5IfSKkpWfWunLTkS94=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026 03:09:37 -0500 lirongqing <lirongqing@baidu.com> wrote:

> From: Li RongQing <lirongqing@baidu.com>
> 
> The mmu_notifier_subscriptions list is protected by SRCU. While the
> current code uses hlist_for_each_entry_rcu() with an explicit SRCU
> lockdep check, it is more appropriate to use the dedicated
> hlist_for_each_entry_srcu() macro.
> 
> This change aligns the code with the preferred kernel API for SRCU-protected
> lists, improving code clarity and ensuring that the synchronization
> method is explicitly documented by the iterator name itself.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

