Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E8BCFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 04:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCD76B000D; Mon, 24 Nov 2025 23:15:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3E06B000E; Mon, 24 Nov 2025 23:15:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF11B6B0026; Mon, 24 Nov 2025 23:15:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B00846B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:15:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23C391404C2
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:15:12 +0000 (UTC)
X-FDA: 84147814464.16.3CD33F3
Received: from out28-98.mail.aliyun.com (out28-98.mail.aliyun.com [115.124.28.98])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0841940013
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:15:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=NpeZo1kK;
	dmarc=pass (policy=quarantine) header.from=antgroup.com;
	spf=pass (imf04.hostedemail.com: domain of junchuan.tzh@antgroup.com designates 115.124.28.98 as permitted sender) smtp.mailfrom=junchuan.tzh@antgroup.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764044110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRtiZanmwtKqwkfVAA9TfIIn2fu+x2IS/UDDE5SSgjE=;
	b=wELFPwYg1FjScb9vRYQR8R0azTak/MWz7WqLQ2GqkU56ovF3BTNLMM+Zo7u7hBAZhT0Fzm
	TkKGnFHodF9DduBLSxEL3uoaf7jZ7FD3RZDyJ4IlWagQREadGaCQMr7Es/WdSmmLHKUuP+
	5iQrXSbzrZm4bO8CRA9D3TW5nbc3Fyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764044110; a=rsa-sha256;
	cv=none;
	b=OWS0Z/IZBYy1SXUePJPpOBcQmHTggWi2WgA1eOXVtY6I6s7NVzoBWMogo6ohNxo3ES4Qzl
	byRLw3oR4QM0thSZOQrWDfXRzqfm0/VvN11daTaIjniEWwS5q/Ne9A+jFdUOrIixjJz/2P
	WTnga9orgpp3xaOQbnxLIe0SEDM1YWc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=NpeZo1kK;
	dmarc=pass (policy=quarantine) header.from=antgroup.com;
	spf=pass (imf04.hostedemail.com: domain of junchuan.tzh@antgroup.com designates 115.124.28.98 as permitted sender) smtp.mailfrom=junchuan.tzh@antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1764044105; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=fRtiZanmwtKqwkfVAA9TfIIn2fu+x2IS/UDDE5SSgjE=;
	b=NpeZo1kKENTcxjw2iqgN7hETWQev3qnxYwoxJhSyoK6IjUmvzWeSMdzNfFXIHUuJEgqP6l1GdKmAk/7+DBainBZPHyPCCVL6x53pyn/IoMdLvAM8O2RoyTk/ucMEywvahRWYGAr6yJ28pejeHeY6urnEuyaQ+z1nR0/H9KZqbhA=
Received: from i85a15111.eu95sqa(mailfrom:junchuan.tzh@antgroup.com fp:SMTPD_---.fVDsBl._1764044103 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 25 Nov 2025 12:15:04 +0800
Date: Tue, 25 Nov 2025 12:15:03 +0800
From: Zhiheng Tao <junchuan.tzh@antgroup.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, shy828301@gmail.com,
	zokeefe@google.com, peterx@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: Fix skipping of alloc sleep after second
 failure
Message-ID: <20251125041503.GA113135@i85a15111.eu95sqa>
References: <1763965157-58413-1-git-send-email-junchuan.tzh@antgroup.com>
 <dfe192a8-4a88-407a-83c2-976d953a2227@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfe192a8-4a88-407a-83c2-976d953a2227@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Stat-Signature: rsmy9jfi7w9rwfb5wfnfpcwnon34c7jn
X-Rspam-User: 
X-Rspamd-Queue-Id: 0841940013
X-Rspamd-Server: rspam10
X-HE-Tag: 1764044108-28512
X-HE-Meta: U2FsdGVkX1/yx8X3YRgK74IDyJMB8aAGV1HXXkDriowvcozmEpBsSlowFxrfTCWX+DNE9GJ4M+XQuTyoK7/YJoRpeEIXrmqcVo50MBkGmGYqoVuDRFhBdbds0FNTaOHWp/H6dkDNd6VXHb/dJFLOWJY3rd5Msha7I33VjhBQc4BR7JGcZPZRTdPAyk8QIe4laacWxPJO8ej+p6+5yym9YB8Gjz9hoS1Hni+nD5xLmiH48IB60mOdel5GScoggWC47SIPuupnIvTNfF4NKm/aaMsXxtaNDC5RffyT53fYXU8ZxKhkmE8/5vE8wqpuAraqxeD1rqFpaXBGukDCSNQDse/XLXVay7fvXVZ+jeenRBYHVWwCGGWlxTVTL3b2gVkd3dk8MFFF6c70zXapAd77yZe/qtijPlHqWzetnVSavFXONS2fE0PeYBw3JNX3FXjgDicwOZgfsY1nqq+6X4L06P7KHBejOCCFDnQvlR36Tf0DNwh0NlzY1DoH9nMJQg1qstNAE87nCY1/GZfaRbNwGsJCQneTH/eMOa+SFOkN3gV84fh6eK86J5czrwA5f8t5shxkBZf3q71HIr+ELegFa6CPRW+EPbPpt4Q5RVjZMdXRi7aRG4ELmLq+YBjpmsfOqTC19FSq3IhjIMHjjE/qmFtvkYP6defnve+dH0pSWEMCtPKhdgn6eTez031opKLJ3jU206ft1qYEVlYgjRdCfhhNrbO2EoSv9fqWHuA8e39jGbRotVnYBiCf9/tYagARy1mplQK/YsqUdWtwesRvOq8he47RoADrMVO+NojoKt7mrW9ymomMBSw7ZJaV8JlRHl9BWQ8UgCh3Vk9jySSo5VThMGntSCI7pfE0Jhti+jPbeFfo0AaqchMbIt71+vPp6A0TCLOUEmSqRnN2zrDrLdhDxODBuviYpxFvTv9DM/oATqUPO1Y5YDsSt776NzognvY4XDjx3vvWh4UyFdz
 vucyRzDc
 bgMKYhDkuOzGnJGdt9zwOqGn4zqbESUfD9M68VZy8kqSkjPw8neX94CnFFIW5ReK3+WuLQIuS1rdbih8Vuv5EjEwbjl/KDHxTjSnnyFyKRTmqqbAE2uehm4WV0eiQUthFLRMpQZy7jh57exdV6ODpg9WIBf00UiPc76J+HFM2mcjrlJCEXd+CYFVcs/AinWsoIJ8H//EdwSm0DqVFxLy8Ubdaeard1uyfZ1oRoYVpZG+8QJJtRrOKNY1b6KzcUDOBYHX7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 10:14:20AM +0100, David Hildenbrand (Red Hat) wrote:
> On 11/24/25 07:19, Zhiheng Tao wrote:
> >In khugepaged_do_scan(), two consecutive allocation failures cause
> >the logic to skip the dedicated 60s throttling sleep
> >(khugepaged_alloc_sleep_millisecs), forcing a fallback to the
> >shorter 10s scanning interval via the outer loop
> >
> >Since fragmentation is unlikely to resolve in 10s, this results in
> >wasted CPU cycles on immediate retries.
> 
> Why shouldn't memory comapction be able to compact a single THP in 10s?
> 
> Why should it resolve in 60s?
> 
It may resolve in 10s or 60s. The problem is that the sleep controlled
by khugepaged_alloc_sleep_millisecs should not be skipped if allocation
fails.
> >
> >Reorder the failure logic to ensure khugepaged_alloc_sleep() is
> >always called on each allocation failure.
> >
> >Fixes: c6a7f445a272 ("mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA")
> 
> What are we fixing here? This sounds like a change that might be
> better on some systems, but worse on others?
> 
> We really need more information on when/how an issue was hit, and
> how this patch here really moves the needle in any way.
> 
It works better. The missing of khugepaged_alloc_sleep() is not
introduced by this change. Maybe I should remove "Fix".
> -- 
> Cheers
> 
> David

