Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D64BC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0B86B00DF; Mon, 17 Aug 2026 10:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4917E6B00E0; Mon, 17 Aug 2026 10:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7AB6B00E1; Mon, 17 Aug 2026 10:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 139556B00DF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:07:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9493D407B3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:07:45 +0000 (UTC)
X-FDA: 85110939690.16.B751CD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E8290180006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:07:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLOvm30R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786975664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPV0snyvdnGubekf6I4pL7WA2SUpgj+H9hK78RZnmSU=;
	b=JEr4AmGg/TwJLreprC0TlHZIGK6TxfwjQXYxzg1GdgmCue1cvYKt7nap5uaY6afsXhoH6W
	xB17FVYV3oIrJXovvLl8U7iP5SdZVvsZs4qyJLxu5+zJgU+CmaNyHABr2Ik9v1zU03x/LY
	bRQ/LSzkqaQG8ayzRUQWCVJPQp26L84=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLOvm30R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786975664;
	b=hFDJ1Qs+dnuo+IOh3Akb+V85lcqq/GUnECucLJIfnEZ651kSwxSDYbBy1/CG5Beo1yFsTr
	HYLMi/gw8a0wE6HzUfas908glZbAHibje89val4w1dlRC1A7mLvYVaHwjR/cpeg06ldHpQ
	6XNYq2eE3SOpsK6l6fRxxqM+gzxMDvg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01C3140AA3;
	Mon, 17 Aug 2026 14:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42471F00A3A;
	Mon, 17 Aug 2026 14:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786975662;
	bh=BPV0snyvdnGubekf6I4pL7WA2SUpgj+H9hK78RZnmSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLOvm30R9NwwazdLONwpTMCWBNqGUNUz8swvK7TmqtEVQGGFgzfnZaGl4uIxdWGKD
	 msxm/a/ZLLuzPqGGBFRrG2tprOsW7BqwGO/Xq5DrHPBqkV7dg4CHehvTnxNomSSwPk
	 iU9uC09K121NbhHFFb2XRsSzEzyR+cQQhFcBtqE92Y1Vu0081dh6MvvatBXbro/ERa
	 NHf153tjwpJAMfKB+FH4TEt557UyO4qksP8rvIKl1jozYXM8Y/8peT7wqpe74j8o5h
	 OcC9hhnwVXVpy/mbjev0rX3iw3wYiqeA9jA5EAtKb6REEJo5e3pKlwORmZLvKl+LNk
	 4JEHHyh0SUVVg==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/core: introduce damon_set_target_pid()
Date: Mon, 17 Aug 2026 07:07:40 -0700
Message-ID: <20260817140740.78251-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817125319.888994-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E8290180006
X-Rspamd-Server: rspam07
X-Stat-Signature: exzj4p6ksikaapykmpwdq4jrxzejiou3
X-HE-Tag: 1786975663-732360
X-HE-Meta: U2FsdGVkX18IKau968vBGLP67XciEHaFSd11KEw+mstNGqXj60qGyBU1zZRbfcuZaCUzfV7N+mETYEmb7YiZi9LPOrUv0h97YX+QtbfEehUkUYdLnyEvJ3nrMTqT1FOrrNIKggEODtrIP6gLMeQGSmUA7Hfkgn5DFfjEA+z/1jZfUVKp/POCikTtz3eGiWyndaqB/bbw1r8N3EYUSAljMRgyyYmArUFT210DvRWC8JyGJgHGUfpm9Eh1voEAGegE2BIJTMKrpg1RhMrNzvX/Bt1AObkd8LuoKrnb6AO3lrBU0XPorChWsw5GV4MqHoiyc/jyudc7m7zOl3CmqIS+FWTr6ng2nqeTzYYQahL9aiNAkcGWWs7Y8e8jCQqhLMK/cyWp54gAyEikH9Xfb6yhlTZncw7tpWuGnb+mk6d4BAi3CQ5EeZjL6/FZNKkTiuTWMkMX5DPfTqnmf3ZTqPWXcw2Wo0g2YNUZ5AkB5QsEw+OlEoNlNkAXFReejSn2fxBbGCRl2ITQ3SYVf+HQvvNFmYylmzRUMLQDdsJHiDa/0+KUt6XTLEZf6r3XsC9bDNUrjW6YRS/l/rSsRHxQTsDvKeZtcHDW6ar73J4ZcWK0DpCTyMYikSP1O9DEjO+5R6TVjt5G3W9XkRmKY68MkJixKtZHYN04zuEAsZb+X9B7kcZecK9n0SX5GwILi88dsHVvJWUhW+sgea4Va4ikO7HmktG33uorstLucFeJFxRy/R653/JCuou7Uhx82AXi+V4pB3g+K3lCJDnzEglzo8GeQau5dbjXPWuPcbqFoTJQ/XnzOq1KTfZVtFxZbHtUFIJcc4Tja/m/nJNwjkjqml1G8OFT1VqI9WKTQG5crbDvVHgIZ3eKqicu9bhVbq2Nbfd88ShbxvKlDY7PXEoky3JpX8RLOZP8/FI7oDe+7QgoOJRlXS9+1Rf5AlG0Xllg3yfBjXknsVJMm5Eey0M1sdt
 cvwkNdkb
 rrx4p6OwG3mG5+9B4bYa8//U/FSXiEOI4e+TpZch3lnIcD1OIX+zg/HJZNvd8dsL0Stv16mgMUWabXV13a5aflLvn23tWRrNwJr+mbhGcrsZYkXYmOnaDJUB2WmWGru+ZqEH6JN6XTCA8BQGpO/UWjq8b6YEh60wL8PwQbKntkvl18WXDeAiNU+1L5WYdFHE3yZiEF/G5ftovkTay+H+e+pEB/utmlc4Q3sG7fwNEePKvmnSEqqm3Po7AMfEqYFGj5IcRUjXRGtr7QdVp7bQ4NoAaMeXpPMkMWTGFQ9el9BmTi9PkFuoRNgqvLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 20:53:19 +0800 Enze Li <lienze@kylinos.cn> wrote:

> The logic that finds the struct pid for a given pid number and assigns
> it to a damon_target is duplicated in multiple places.  Including
> damon_sysfs_add_target() of mm/damon/sysfs.c and the start functions
> of the two sample modules, samples/damon/wsse.c and
> samples/damon/prcl.c.  Add a function that does the work, and replace
> the duplicated code in the places with calls to the function.

Looks good to me, thank you!

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term, I will ask mm.git maintainer (Andrew Morton) to pick
this.  Note that we are in the middle of the merge window.  The action would be
made only after the end of the window.  So, no action from your side is needed
for now.  If it seems I also forgot doing that or you cannot wait for my
action, please feel free to directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

