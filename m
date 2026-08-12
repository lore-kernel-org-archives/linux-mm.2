Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E81C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A1B6B0095; Tue, 11 Aug 2026 21:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB3D6B0099; Tue, 11 Aug 2026 21:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F12D6B009B; Tue, 11 Aug 2026 21:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 517476B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:29:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5D411A02A8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:29:18 +0000 (UTC)
X-FDA: 85090884396.21.4274593
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C2CAA20004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:29:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lebhn8hK;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786498157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DyvY/YHLOg9UQpM7rEyMdWQpm6s3uUpeaxg5jZbaQQ=;
	b=cYvp6rHSvHOFloOpUk4f/n23p7ipazRx1ZrzkbkpAf6XRo8rFheeWGBgrVXdOxnJsY5P87
	E+pjwEb5skB6CWRq7xo4vBwFMqORNjm/7bLJHmL2TpVFysXV2GKNnWIsOpjTCufbiOnxxg
	eV3oSi/upILkoKY5xjIi7Z94OA1Ygz4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786498157;
	b=YJQwBuyJuXkhSI5KddgXcS0/aMZOhQp1qxwxImDJGzBtQFKEbQPiE8aLRas+wFY+hfzBeK
	wz2vHQT8UuPOCRGpmKZO50dJzKBKV2cOssu47G2hHVx6syONLNVrpUDSw6QZvYZn9Ub1PN
	tiTBOtm5JOIyze4Yc+WSFZKo3l4ykBs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lebhn8hK;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3FDA43ED2;
	Wed, 12 Aug 2026 01:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4969F1F000E9;
	Wed, 12 Aug 2026 01:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786498155;
	bh=7DyvY/YHLOg9UQpM7rEyMdWQpm6s3uUpeaxg5jZbaQQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lebhn8hKMRA0/WLMRMGCHsbQDXYJUTUh6x4EEOCp8ZbdPu5C+3wGbUZs3aqSwK6aR
	 QNOIh+f7uT2EPwzP7ZZxXzGMaICmg8NPBF+SAHItFMZsvePpfigP6015XfzemRck2a
	 MxDT9cAkA8TeqydlMsV0Gc4kBNStS12VQ311adG0=
Date: Tue, 11 Aug 2026 18:29:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Su <sh_def@163.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Sashiko
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH] kasan: fix quarantine_size accounting during cache
 removal
Message-Id: <20260811182914.ed2cba4ef1a8a88335b9edab@linux-foundation.org>
In-Reply-To: <20260811073332.1351893-1-sh_def@163.com>
References: <20260811073332.1351893-1-sh_def@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: cu1uz14o8ah6mzd8xsgc5499xkk5rbpd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2CAA20004
X-HE-Tag: 1786498156-177964
X-HE-Meta: U2FsdGVkX19tdneJJfbczoEqIKnM5Ebr1saiYxqf84l4OolSxMJKdwdZGIaED3LgzYFShy7PxhPSQYr8bJDIBtOKoauDNHrTW874OOVkNxp4GkjRIlrXt2S2LOhH7vldn34jG261Lx/3AjNhdmPxbD23G9kNebVR1b37E8jn3IvrRxLndPc68tesc8Sz+Kd8NFADxcDeAdje8+N81JQortwmWp5GaNm/Es+Y2kjcSzNr25hsKG4JVU7cJyZP/ARn8UhX44CoSsq8tuWme09UsACOuZQGAKeVO9IO0DC2kyHxQVTF86uLy/QCXulbQhkNl/EjuQEeFEmz0FoyDGqFSWdIayR3lFwnx7uVpMBMJiJSkzW7TjwVQz+m1HCaaTO6Rs5+JpKLUnIFcqMw1NoVWQwfja9LBNkDamvUPXhl0b71SNcYHNFFsFU3F+bcU9fcJ2vsLITTRLfIx4aPWFh4oWep3xrF3olIGDsNWrcXHlTdKpv3I9YID3YmatRwuInQ8PElWEmt2n6KMctpWpEV31/7SNHUXVE2Rec27AQ0rS+q4xkQykeb7USSItdTwP7+8WXtGf8qZR8Rln3O2PpbB4RQTdDZhnyW/HU10uPHDp4WmdLQZK3E7XAmoXMab32dV31XqH1+oabQgDe5qqg8XzKtqChxk57PcqNtd5JwUg6bnyKRBbFyxdZU/k5Qys1rY1raJE2RozQao2uynh0jhNtOukBpMa1T5wWbQt1VrY7T4SminqdVggWUJ8grgaaPBxarHGsgbez9MImx4pyeu7530HXRcWToayEUwPF4VpFsUPaiPswy7mQ3P4xBuI/qiVlvmj/GfdpUsn3tE/WFbhTg/6WqNJB1NQIqBqEU3S5TT1QUfWqrEv+CkoNYwfMN8WcMlt8lYDWIpUr3mmmubnvG9olxdf1O8TeePpZ/88SCSlg7Tk2CBFPQt7wTu0T/DvqbtPPAfPJZVfpLxAX
 ysY38TZz
 5cULChoy42a3o0NiqDf0uXLosW770RiR2QKhxMoORvBkOVmCI85W7vMkmsZiDSee35F7LXw8Zhmpa17uDT9a3H3dIdUvZCM+b4TTDprpaG7r+Lch6R9qv/UGrKfpNwBICNX6dTnjvx5f9L+mhn1kYS4ATYXUpbsOuGcJ871pjI6Gh1ezXnNy6E/sCJoqOYNqUyNv0RheJRNoko9wjKFliwCS7qmiqSq2fhipZ3poeKNJCMHZEyqQ0VH54yyjLHvvvIQ2c/rs2QfhbM+kw9gP8VfR08E5DzsHSaFIJfBRkEkr5bQS/5BUh5uz1XzA/Cdq2+ekJJm78FyerLvftM+tlRCz98B1hPCBaFXZB0lUq7hp/5T1Rryq/uhesVjbgipKSD8B79LGVG9inT87ULZq+MoazoGODwRnsS0HcmFq+YBgwC/hD3ycg2W37MjuNcKFwtSyRxcptuLtnNXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 15:33:32 +0800 Hui Su <sh_def@163.com> wrote:

> quarantine_size tracks the total number of bytes stored in
> global_quarantine[]. It is incremented when per-CPU quarantine objects
> are moved into the global quarantine and decremented when a global
> batch is evicted by kasan_quarantine_reduce().
> 
> kasan_quarantine_remove_cache() also removes objects from the global
> quarantine. qlist_move_cache() rebuilds the source batch and updates
> its .bytes field, but quarantine_size is not adjusted accordingly.
> 
> As a result, quarantine_size remains over-counted by the size of the
> removed objects. The stale accounting accumulates across cache removals.
> Once the inflated value exceeds quarantine_max_size,
> kasan_quarantine_reduce() can evict a batch even though the actual
> number of bytes in global_quarantine[] is still below
> quarantine_max_size, shortening the quarantine window.
> 
> Fix the accounting by recording each batch's size before
> qlist_move_cache() and subtracting the number of bytes actually removed
> from quarantine_size while holding quarantine_lock.
> 
> A KUnit reproducer used during testing observed the over-count grow by
> 4698864 bytes after one kasan_quarantine_remove_cache() call with the
> fix reverted. With this change applied, the over-count did not grow.
> 

Thanks.

> @@ -365,9 +365,14 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)

Sashiko might have found an unrelated pre-existing bug in here.

	https://sashiko.dev/#/patchset/20260811073332.1351893-1-sh_def@163.com

