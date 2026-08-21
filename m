Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B108C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548316B008C; Fri, 21 Aug 2026 13:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8CA6B0095; Fri, 21 Aug 2026 13:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40ECF6B009B; Fri, 21 Aug 2026 13:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAA26B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:19:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1775C1C0A65
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:19:03 +0000 (UTC)
X-FDA: 85125936966.13.BF65D2C
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 70CB62000E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:19:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=bPX7Txm+;
	dmarc=pass (policy=quarantine) header.from=manguebit.org;
	spf=pass (imf13.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787332741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGFEiYEVjkcCzgDW1sDcNJoasexjmVTJtd81q0MQQhI=;
	b=Lxyi/cvAhLgK7RamiZQFHVGBECgAw1xZ3mufvrXs+nErsVx1qeV7wXybFU0R5q7E4brG9v
	OfTLqJXytqiC6XR0EMIPTNufITsNTh7FVfzsMuvQ5azKrSzk0nFDN4mOfjPFLvnO02kVUY
	MVqWr28Kl120tWtGWXOfKnztnRQy4e4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=bPX7Txm+;
	dmarc=pass (policy=quarantine) header.from=manguebit.org;
	spf=pass (imf13.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787332741;
	b=VZJnajrBfh0RjY+hz0fsurOTtpV40vsJ8N4z4usmNABnvuXkC070xiMhomRigrFqoZCTV3
	Wf2b1y4G2RoePoT+U8evQ+9Nk9J4k45iVYtbolL1C125uNuNFOKqxm94ghSSqcBTDwVCCb
	i+xtP9Rh7frQEdRoDoPG+DOuIZ79fJw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eGFEiYEVjkcCzgDW1sDcNJoasexjmVTJtd81q0MQQhI=; b=bPX7Txm+aEXVSbJoZKzjQba2XG
	9YS/Y0rDUhBbcKT7T1doyGbOzeyI+iecGVyiKU3KGh094SRLP6IdW/bVIUZi+zvAg92pm6zhyv0GP
	P3HBhks11I2VpufWiGMErvvmSU2Tl27dQ2DOPHsmsXlrMilNdKUZA4MZPdiOW//gSzZqcZ6dXXapw
	g5PuxS92tOYKAvQ+Eel4gCBYp8VA8nQu47TjLyI3TiB1IqTt9oJ0/OtjQR+m38BKbE4RvuL1ZyEv2
	QkJdM7SLmJ+l80Vb1t1xIXTzQWGiyQspYdOe/Aq7Ki18+5JtYSdnkrCiwEFbowhIk/9oN7uh47FkL
	pH3bTrdw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxStJ-00000000PlG-3uIC;
	Fri, 21 Aug 2026 14:18:53 -0300
Message-ID: <6e9aa19ba351b8c7f4df2992342a75da@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Steve French
 <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-mm@kvack.org, "Christian Brauner
 (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 4/4] smb: prevent TIF_NOTIFY_SIGNAL from interrupting
In-Reply-To: <20260818-work-tif_notify_signal-v1-4-1ee1fcc5b3ff@kernel.org>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
 <20260818-work-tif_notify_signal-v1-4-1ee1fcc5b3ff@kernel.org>
Date: Fri, 21 Aug 2026 14:18:53 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: xzquea1awyx3bsfawked1xsstqntyukf
X-Rspamd-Queue-Id: 70CB62000E
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787332741-712806
X-HE-Meta: U2FsdGVkX1+ACvlQ/jC17AxaEWP2BMPuhg0KAATEg2NxkIOKd1v5MYhBchfkKnzw/jJnl5jHSWrPi/V0sWHCbegoLuhxRZUujy8u6xXC2Bqq3zU/nP3H0hpJz8zt+ngNe5P0DMFsSOvy4rj65grUzGYlbdaMO+azYUszG8UvRwCtkUo/znyBImOh/ZN0MjiqeALNL3LBOVg9OAoqeY5qhF6PG6+gY4EaqMtgNiys8kvqjOCbmr5P304eZMQhmBcsGr9+pRsV2glAUT2NXyrg+F7iHQNANbj1ylpBc07Ir9AvxOHMymGX8HIu2aU/gIV81Og0uMhVCkvlFRKW8dLgQYapfSABcK4lVpnrl9Mh+LykZsU5G85Obr6E/1zhV2wbcDb7rh2cIIZOZi/0UnvfNyCSXd2OgS/+3Z/7JGdvZsGz6phpHAZbNMaIu24Z5Yh9NeG/h0XCMm7yAxzEq4s86+xEpr0ZCNxGILI1ZmqIinwvL+JXTHY5wkQm/2Dwkl9kDjd02IzBBuXQvVvCjVlgbJVgpVc+jxndccbLxCwqJtAIB0RiGZ6A69tvd3tOzkYFGnpCEcof19oiGKACVorOAcO6U8Qy7wN5c8FL0Eydp5VHC13iQObz0MKjzIXTyJuXDt19hm0/kuJt5ACFlrU2V7pYi1ARWz2QZy/f5XfdYGgEcfaD0aIRAiHdh+An88OxVlb2x2Bbas0LlEvbdBjITPO/DuywFQFOrIRrMcf9KbwNll2+pqXM96lFvqSwutKcwh8XHwxQYFlLs7INJezfI8EwARFCL7GdTLGy7vpeIXflnXbvxgi0FUGd5267oPAO1kKtuq7I33IuRPwtdIdOVjeQMTfuhGKhVktPb0Srxg2qJJK5Wo1M3xBZjPFBaH3NnrwVXQqh5D8+Ul44C9Ge44SWdXcyzQFMnhsomzeBfxdA4kRH0rbziBZiHGu43zOLLCynudoRL9Z5uDeouAn
 f+sde1XK
 CLoGXqorv6CepX92tcVO8jrsHnx3+HcaVVUysvyI8JUHWmj4Wg9ryWnnbj0h4uBwTMFmfcS7CostremWEpbFh3+uRSX7uKvDeAE6sTNovOwjizFJBz6Pj7Ee//XKbNMaDMl/DBH/pCqde8hUaFeuqsSqb7o2NluxZ4dnMDHagSUvXsx/ojpBhtlEohMur88Nf9M3Ad+NxAxBxyG69w4ua5g7IJ+lYrIDimtn4/Da4oyFdrirnSDs9BWWPxh5kxN/BRRkJ4jXX6hmuzv2khNSj4NuQS4d9G3W8POtbon2nwtlI6XSP8mwlsOcyziprc29w+6DHUkWEmH73WeZBdDx+TqjSaoVpVTdsIuY/Uqw4F6uZTakk8ecNTrclYjoOhWjrQ5mbQFASdCtaKZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Christian Brauner <brauner@kernel.org> writes:

> smb_send_kvec() blocks every signal during a send:
>
> 	sigfillset(&mask);
> 	sigprocmask(SIG_BLOCK, &mask, &oldmask);
>
> An incomplete or partial sent would cause the connection to become out
> of sync. That in turn would cause the session to be torn down and
> reconnected.
>
> In 00be6f26a2a7 ("smb: client: transport: avoid reconnects triggered
> by pending task work") smb hand-rolled its own solution. Have it use the
> new no_notify_signal_save() critical section instead.
>
> This stops io_uring from cancelling a send in flight but that's just
> like it is today and it is bounded by sk_sndtimeo at around 15s.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Paulo Alcantara <pc@manguebit.org>

