Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE7F4CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400CD8E00BF; Thu,  9 Oct 2025 21:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B17E8E0002; Thu,  9 Oct 2025 21:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7798E00BF; Thu,  9 Oct 2025 21:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF158E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:28:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD562116DB2
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:28:43 +0000 (UTC)
X-FDA: 83980470126.27.CCC4FCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 28D1C180006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:28:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t3A0HDOm;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHIPH7KB+CbaEpl8Up7DamnjF8oXOwJK4XV7xgU6y48=;
	b=lY8AW151nZuZg0xwdb+9U05lFI3xdjhJ2IrglhLwfj54t8Sps2k8K1Mj1GHOVhJTkwLaSj
	DCITQ0GGg2cVupVC3Y/fp3mFW0SgHpQYkH+YvPNXTHnbGGnJXq1mf6EwZrg2swIKZ4YJP0
	J1haR5aji8vHHOj9r6eaLmZXH9Xnltg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t3A0HDOm;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059722; a=rsa-sha256;
	cv=none;
	b=mZE6nI+yIJhKk8odMGchHBMZRQyO/1W8AkE7Ip39Ardn5Slo/WABM45dpAuDNB2KV74PhG
	jo+fUJrwTKo6ITtfM1R9J29zhAkipEgZrq5lGoBfrvXVFuojYab9Qsw9EJr04NJPc5gzfP
	FIxX54sjJjmLvN4559wMOyIpG5XQBok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B07B6247F;
	Fri, 10 Oct 2025 01:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CB4C4CEE7;
	Fri, 10 Oct 2025 01:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760059721;
	bh=oEjMCVyc6JsKlwJ6QcokZLr2FanKs2hp9ttMLxsDEgQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t3A0HDOmcwbSvCNrL1sgROlATHTpSY6hceyts9nzrEZ/w75c+D2MAacyO9Q01Uk5X
	 MOQCWfxJdyS9c6AwWzFWZrR1JtbKrIOE4YxLC1PehV910RlBnTknfuwXzi9f2IqZkl
	 b3W8l9Eua9AHl5Umlxu9vW+PKaSqZoM0w/Ng/eSE=
Date: Thu, 9 Oct 2025 18:28:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, chrisl@kernel.org, kasong@tencent.com,
 baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
Message-Id: <20251009182840.55426eb0548e7da1b721d4fc@linux-foundation.org>
In-Reply-To: <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv>
References: <20251001043436.41338-1-bhe@redhat.com>
	<20251001043436.41338-4-bhe@redhat.com>
	<20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
	<aOdoehPH1O2vJnqv@MiWiFi-R3L-srv>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qkzk5tudzjwstpztphd9xwobhm3isnzj
X-Rspamd-Queue-Id: 28D1C180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760059722-620047
X-HE-Meta: U2FsdGVkX1+aFlw1m5XPZ0YsM0BG5wJF5JwD48CGorg7smwy38D6K5TuqogOvLy58SyzvtyQ4JXZE6KvCJRbVfOh+iPng+2FhFUvUssYU3zkF5AVAcbayI8eUgy30IGcXSVZHs1IdYzzPBhzDP1edrxokpKZZdIvwvqyQjuSjnT4Z3Pq9sARWvZkBCI54SVg+SAWIZjqYDS0JGHVLVzWpGfEoxoty8ZKbXgVg2zzrzR+2+gIc98tGYJ75wYBd5CDTIM4aoQ51z07pC1wvq+ZrQEqWhxgJtHNCLKN3Aeddn5rfRglG3FV5VgWX08v5mkZ+tR5ZzX+psaOSHgqHNN0beckHHBExaAOz5mBtYKXGnYhaRcSr09ILN3uS30/zH6IVbwpHHeL2ycXcUT4GR+bRnYEKUUyIpjJJu8PCSwz546/inP/cyYX8p/sa6HGu6MegCtvJlI5JBKJDP5pPIIyAig+rKotnQz899I5EdbG9p3pv2m2/zzuR0OhQ+DmZjvjdd6tmWiT6wIVkBC+EZcQi+GBJgogBU8Mc86AJWDs6hSvbw8x9O2BgEUThYvzkxMTBd36DtSYL8J4xGLXixmB27havrm8hBf2mWanmY+Mf70KEcDxGU+fDj+MKaJmcEISjtbf1kPyGshXO5m8zKkFpi5C8oTYw9kmUz/RsIGZ7Ct161eP4ZhLgs44dqxUIIJu7O+m7OY8PtFN8fqos1toUNixhu5gkrcdmnqM2Ejsk4F+zci9OQBJkDmQ27695kDGnRVcEQEkBHG0S2toMO62GfP0V2QfQsIiHRv80Lhms/YFPD+S7a9+I1kfMlmFxFDovgAp80/Uv0bLEGen7uWo+3KM2GZih/ekXmh87f8p9pIAbsNKa+0FdHBx7kbX5A6CgS41WoOV9F/EQSHBuz3jUc26YVntuQBCCC0+5cWrA69bA5Cb0Sf+jy4/9P4A6CVSopFM6KfpnJPr5cRp1lf
 /kKlS+bZ
 /hJMGbmqvjsBM9m/MYrsQXEueQnl0scsOwSKnwqMdpRxtsQNTkXEbpsSoQBE4GoHLXcPNFNIa+xB8pgoc3506MwW9hB7nE2zZHHdRWwVq5eoeM5lQ11et1DB85/UeP3cI5Fu2U0B2paFoMgiraA5I3zsZnU+i6WcCOlU/oHTjns/by9em8bzDA4IIwAN4i5S4MOWXf8F5yYXfhfyLtSF3y4DvcbKlbJmIwq7vBkT9P8MmOwpg9qUqBb6/qsmXQv/lITaBrVLQ7GQrAFefjNLE2ZW5bUzV43mVm8O7sQfqh4Jkm/sc2dru7EJkpjdnESeRqgUs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Oct 2025 15:47:06 +0800 Baoquan He <bhe@redhat.com> wrote:

> On 10/08/25 at 08:26pm, Andrew Morton wrote:
> > On Wed,  1 Oct 2025 12:34:36 +0800 Baoquan He <bhe@redhat.com> wrote:
> > 
> > > There's no user of swap_active_head, remove it now.
> > > 
> > > ...
> > >
> > > @@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_info_struct *si)
> > >  
> > >  	assert_spin_locked(&swap_lock);
> > >  
> > > -	plist_add(&si->list, &swap_active_head);
> > > -
> > 
> > There's a large comment in _enable_swap_info() which needs to be
> > removed or updated?
> 
> This patchset depends on below patchset:
> [PATCH v3 0/2] mm/swapfile.c: select the swap device with default priority round robin

Oh, OK, sorry, missed that.

(When I'm working on the post-merge-window patch pile (700+ emails) I
go in reverse-time order, so highlighting dependencies like this helps!)

> By the way, Chris worried the plist swap_active_head could be reused by
> the ongoing swap-tier work and suggested to hold off this patchset till
> swap-tier work is clear. Now seems it won't impact swap-tier, I will
> send a v2 against mm-new.

OK.

Is Baoquan's "[PATCH v3 0/2] mm/swapfile.c: select the swap device with
default priority round robin" series still considered good to merge?

