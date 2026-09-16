Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D7FC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6516B0088; Wed, 16 Sep 2026 18:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741CD6B008C; Wed, 16 Sep 2026 18:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607D06B0092; Wed, 16 Sep 2026 18:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6006B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:34:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A73DEA0193
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:34:30 +0000 (UTC)
X-FDA: 85221080700.14.1907BF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D7A8F40007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:34:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lYtE7NpR;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789598069;
	b=fdX+jRFEycUQJKA3yDhHYtZ+htgUoJ02lyKXw/dkm8vqS7NMo/DkVNN2ZFGJglnziX813D
	+YnHEKFWDwrB1SxvSkQ3gupzeEr9osvCBVEsfafuhKVKRnB+too6tpMdfJyJiJBq8Sn9vA
	uB9ISFrWj9A9EXMaJT7iwF89TmIPYuU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lYtE7NpR;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789598069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5HGV9rZHuGPaUvmcsvJ1HKNnHbuikTZmwdlniM6kvo=;
	b=rqiDX6PD4xRY6lqDU3L6MxDnSVXwScQ7d+QSGAq/dYB7hINmRG8kXtHzqPoo3lV9wKM7bX
	0wdZ0Uzb2IDHkaX0X+gzxuNc4um1G1KzbbcVmXpPkHppZmhhM9C3lRQbdcZMdYKBYwlzaN
	4BIyK1O5y2IvqQsBcyV/hQqW8ura5Zw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C9F641295;
	Wed, 16 Sep 2026 22:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8241F00898;
	Wed, 16 Sep 2026 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598067;
	bh=K5HGV9rZHuGPaUvmcsvJ1HKNnHbuikTZmwdlniM6kvo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lYtE7NpReDeqKVQNw/98ReJ6SxlDMOQ/EcHsikRsCshszDuVl14Mr6Dbg+F3d2Juh
	 PpAR/zm/AEq+CpbMqaoiVt0iwDCwGb4v7MTXNtEEpGiGCKtdWNqr0sImp6J93F747s
	 OhAMWvV3FlxawJoxTSRnhyW9yyLFsFcKYM3sMAlM=
Date: Wed, 16 Sep 2026 15:34:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Salvatore Dipietro
 <dipiets@amazon.it>, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
 david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
 djwong@kernel.org, hch@infradead.org, hch@lst.de,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
 ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
 surenb@google.com, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260916153426.3265e2e152cebb6a8d66373d@linux-foundation.org>
In-Reply-To: <aqq8pWI0u1IZNWHT@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
	<20260910114602.926944-1-dipiets@amazon.it>
	<aqQlUr-1h07G8JWM@cmpxchg.org>
	<8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
	<aqq8pWI0u1IZNWHT@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D7A8F40007
X-Rspam-User: 
X-Stat-Signature: rkifyefp4a1gxkwjft67q4uct8tboz9j
X-HE-Tag: 1789598068-842968
X-HE-Meta: U2FsdGVkX19MNPGbkdgN5nDy3GrunuOssfycnsRL25U/XAA3YPR+gr3/GINMODZWL/74ySEqZgeHJGC67SyMOBVe2tMHzat9IBdj+ZwLuS4+DNBjcSal4l8vokFFExaBtxeX05BmCRXEb5r1lN9+5iJ5WoCR0h8ducHBxtbF9H217kbPKMQrDnz0WU2IsCVX7ZnTX39odO2PfJ4U4itqkRm2QaCBQ0SdWiqDx14aC0VdjsfYKuUiIAOc9xeGySPKCSeTpe+cLjB2X/UHI48MRGOcphG+I/P9+HhU8qwQQRVPue7Niwp32FlonyaehPQtgoe4VCG4lqF/uWZnJoJx98e/ZVEXoC3Qb9/A+PaG+79Ku2giAHvCXGOM7rCIDUDsy66NWn9LvBdTvPh8OYMeVko+w1KppYx/39pw89pcp+28ZVrWk2baWHNaqIutObdHh+X/DtefvXZgPgH7tcWPz18XZLo9Sle08fQEwXn29lORH/2IIPIw2u5K61U6j6IwJ3KF7nYba3S5xoOqJ4RZc7IVB8R3R6UZ46szbb6E2+sMdfx/c+jk0p9R++tB0hHwsrZSvx6Ig3JPOUZ5fAUVRSqvk06ASRSiVPKIlLdQRjxsrrvfXcd6Ul7MvCfUbZlGDnkVQKgPPHdg5+CE2CFkVy82TW1VsgbTeJZOc8CGHYbU0B+7rbLJ+9rvgks07Q9/SVe2XOOMmBZHPSIcqOt2G5OLxceRkeZrZRElPA68DB0DE78u2zA8ncM+FrCCHNtThIyObjy26H33ocDgwW6eyYl9jsHSUoX9wF7C1Vzbb4eO2Qc+zZrqp/arKiJlleLY+iqiCGZkKU2Y8RH4hJF5ua54lv067rRtAvmTvMQiWWd5348X7IviYt1GdcFElboxTVQz7Amidau08b/AlPWSd/66OnC7pFRNtK70myKRqaM4xRpjzCV8XJnHEmtAeiGbukJ94xGI1Tvdv+A59o9
 9UryxPb8
 xbkN+UhI+9hvACDl4TIrE692NmBySxaspK9A2dp7XH9aJ84zhK9OWDxPeWsVyGkpEdTRKGauuhjcTLqTGFZY+vk0fIJLv8XPNthMMt4kEP2e2ooM5pP1NNJ7AxwYgnAa9vZKH3pavmEEw8cg8j7M/VHLO1m657xXV3NCqXNc6J5Q2FS1R2HOi0A4IIm5/eRXkg+9qYxxq2YgMmsruPQ25lSXHZEOWaEj3oY4uB/dZ8cp8KTLebeWQFznsPsyfRX12ILOKfDzU7v3968EpMMgO+zxNsT3y7dG8+OsxiONYQuxCkrTu1FEOwjBiXRWBfvwydEdutMeyCnJusalZTE2tzuszpMsIhx2u45cuQFtnsJBEQh6wOf3Efd9Z3b38Iv1nUBYSO0cg2V/7Kyb5EG5MKrSsioEpNpn/bCFb1a3DVUn/OwLNlrK7+7E9IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 11:58:29 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> > concerns can be dismissed and then indeed v4 is the better version.
> 
> It looks like a real issue to me, but one that already exists
> independent of Salvatore's change.

So I'm hearing that I should drop v5 and revert to v4?



