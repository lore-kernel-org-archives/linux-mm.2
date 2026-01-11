Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C85E2D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 00:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E656B009B; Sat, 10 Jan 2026 19:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1E96B009D; Sat, 10 Jan 2026 19:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D626B009E; Sat, 10 Jan 2026 19:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF75F6B009B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 19:10:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B45F5867F
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 00:10:52 +0000 (UTC)
X-FDA: 84317752344.22.4991757
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 994EC140006
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 00:10:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mDD/LtFC";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768090250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ymw5At08fmTjl7XQDB/2Rtem6uIBgmb6zF8Lw7SnKIg=;
	b=rzvVL/mtQ+/7oovG0ofJ5l7CYTmBbM473KDp+kS8dNAn4C/K9s+wx1rCFLLU178Jvh65Kx
	gbgmwH7AVDH4dKQ1DrpwRhSe96ko/bcPcSJam2CVdwvZK3h2jdKBsQworf09f9Q65brznM
	VywpTUCPc/nPT2pBTLQB/xqA73d05ds=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mDD/LtFC";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768090250; a=rsa-sha256;
	cv=none;
	b=1FgnnfePa5kCVob1WFKFAo0f5GlaCUtLWdNKztdNV6n6+uyQ2EwTwxEjpF0obXAtcnT4YM
	S39dLeOjQzXuVRSH55riCMqagFN5xZi9diapbRVqS+cynSh7NSjk9+30Ro1NcDBodxTVqV
	qQhgZIcDlxa4dN0fVTK+smDtcvRYy8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BCE74394D;
	Sun, 11 Jan 2026 00:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3883AC4CEF1;
	Sun, 11 Jan 2026 00:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768090249;
	bh=+X7k0urrtvloUeDzhx+e+wj1OrtJld0n/M0L6ssw5uU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mDD/LtFCP7BwHFx8iqSO0ctIoObmagUS5/tOknktDPa1Xyj/H8vii2/vY8tykuuKv
	 pn4SHjkrGTrofwnL6S9STuZFh3s8R4ztaIH93Nd2mHphrEk3yjEZu0XVWaB5CP8x7+
	 FvNN7HlydnI3O7bSCyEauU1GSTKWMsU6sMpPWtMo=
Date: Sat, 10 Jan 2026 16:10:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in
 move_to_free_list()
Message-Id: <20260110161048.0aa9c7e32af3e690a671ef8d@linux-foundation.org>
In-Reply-To: <20260109105121.328780-1-yajun.deng@linux.dev>
References: <20260109105121.328780-1-yajun.deng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 994EC140006
X-Stat-Signature: 8bm18by6paribp89eceg6dph55h4rjr9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768090250-132142
X-HE-Meta: U2FsdGVkX18c9n6rWsaxKLkafGMmnIyCKX9g8itLulA/GxvVUd0eamapwEaLVlJj9iz22bBHhPYHVtzBp8mkuXRjHULh4VnrYNIRPg//zdiLtl+/NRQb8/75d4XsoJXkW65iijygPXzdMcrp99ccvKxHeEytIpLFyE8UEHvRZe1dIwnhCtVd4wgVjhCpBuhF/AoO8RIIjdEz/+zwuTxwjmzvLzeVK1r5fvwFpx87WYBmA39gKdPd5wk8WTJmUKVxe28ptkXbSt9JiA2H+AHv9139oL57xxbi12bp53FceEmU8FJ11aoeRgx4K5lI0DODuQGKxcbmXEsNkTVeUL7/TXTxBykSVX0/6U69qsr+pfOa2pa/UNXb69jlOv5XIpynWeL5lM5i3cCO+8CNaLCSJ4jwftWvwrP1xgbUo0T1RnK2WwGRi1pkBK6VRrJcuhG0gAVis6K1RCTCs6EpO8t52zcpoSr0KhiuAaiSASbA7v1962hsmTuy6lI0V4HibZovBu0SSiU8cMyVz1cR3CE/aHOso/bZITgF4XXyo6AkQETlEJe4xMvzSLFHz1vCIMGgig4eJj195dD4fsoL6Kmj470VApCKg8CgoJfRP12UlE//7RHSwtUotYTrH5yg0nQY29SmXZpNOnaKsnmdKnTVL97yvDLOL8czISLyRagFnjNyrrS+nYxiy0FnqccW0ivAMerYK2pMeeLXDCsN93deM7s5X041KYheL/IlSGDpGW+0ITiIItDwkCye3MCIl2YqrB1gCk2KRwPDT1sWWnHKjY5GpILqFr9XgTWZNiYJVwFoIOoVGmO6R6GNVrMnfCfK3a4hFk+9+iu8M3XL6+bVg6mr1dUKpJFxCuGWc5rgli8YeDbUUveUFp0UA4CJidxv7sBKd0voiX728E06p+FIJ+ieCi3JBcktrCYGQY7EZCgQSIV37fHKMyOO4tlJCAMSOEiIXlSvGnSdfN1ZVL5
 qpiFKMyk
 DElu13njOUZhF2shUWiot/TqIDZ2ZqEEPPGR7MGjS30JhWGHqnlyhr4+0N5jqY28J6dEBnCBMMXT8OGzcU5Px/GID034aBR2xAgbCS8XZ5QYE7IIQfe7mYsicqHcbJd64ZJAjwFPYw0Fu2oRqNDomFIT9une8ZXgyVDfdjezyz9a3Jzksa77KdweyY+KuVn6KXEAxtTct3ApV0N/+IscD3XqoZEcKIlOiqk5Z1vkvnt4CRvVUfAG3bqP8kIpyccUAiiMFai9/jHeJlfllU+uVyzT/XYBpeWIQszYSxG1ig1faa8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Jan 2026 18:51:21 +0800 Yajun Deng <yajun.deng@linux.dev> wrote:

> In move_to_free_list(), when a page block changes its migration type,
> we need to update free page counts for both the old and new types.
> Originally, this was done by two calls to account_freepages(), which
> updates NR_FREE_PAGES and also type-specific counters. However, this
> causes NR_FREE_PAGES to be updated twice, while the net change is zero
> in most cases.
> 
> This patch introduces a new function account_freepages_both() that
> updates the statistics for both old and new migration types in one go.
> It avoids the double update of NR_FREE_PAGES by computing the net change
> only when the isolation status changes.
> 
> The optimization avoid duplicate NR_FREE_PAGES updates in
> move_to_free_list().

Seems nice and LGTM.

> +static inline void account_freepages_both(struct zone *zone, int nr_pages,
> +					  int old_mt, int new_mt)
> +{
> +	lockdep_assert_held(&zone->lock);
> +
> +	bool old_isolated = is_migrate_isolate(old_mt);
> +	bool new_isolated = is_migrate_isolate(new_mt);

We do permit C99 definition ordering nowadays, but I do think our eyes
and brains prefer the old-school style.

So here I'd personally prefer

	bool old_isolated = is_migrate_isolate(old_mt);
	bool new_isolated = is_migrate_isolate(new_mt);

	lockdep_assert_held(&zone->lock);


Or simply remove the assertion - it doesn't look useful to me.  If we
aren't holding zone->lock here then the kernel is so screwed up we
should all just go home.




