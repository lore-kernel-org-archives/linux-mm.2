Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF82DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40386B0005; Tue, 14 Jul 2026 18:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17E76B0088; Tue, 14 Jul 2026 18:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9310D6B008C; Tue, 14 Jul 2026 18:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 706656B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:54:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9A111404BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:54:57 +0000 (UTC)
X-FDA: 84988889034.15.E9D69DE
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id D6D4D40004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:54:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SwvzaJ0e;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784069696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zex7fDtrxgjxYmJUwLrkUDR7R6DM3+vGl+Fsw51hImE=;
	b=rVLqwj19J7HbNaQ1APXjsDUI/YdjWQlt4EMx+BlrvJUPb7LCiEe/iIbU3yYdmq15GsdbwX
	oBYpqY2O7QQzGgHY0+6whFuJjyTjbBz8J4wUdM7ykaBHxSTIMwgdQoUrPsTPXsladjs0zb
	iPSJctm3blh4Ndxbd4/4xGNtH7Hq5hw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SwvzaJ0e;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784069696;
	b=uv1Q37LdicA6rDfRgVwIn/0UwoZ7AE4AuJZcTvyrRed6I9pi3eB8tfnibZwA84KKDu/+XG
	rZwyUNk6YsxzH43JipvYyae9aJRhuBeXPx5q0oEA8kSbFB/6ON9yley6qz5EBB1i2KOSJ5
	/dtZf9C6PCIbg0dzdpAwV/d9P0SOEKI=
Date: Tue, 14 Jul 2026 15:54:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784069693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zex7fDtrxgjxYmJUwLrkUDR7R6DM3+vGl+Fsw51hImE=;
	b=SwvzaJ0e32GKnb/IHDdbJGWcQMPFtprKZ5M7WJPOChLZno05mzZGYITi5vokDQfCvVKL9H
	eXnB8MS4Iwszhr0srjYTlYi9B3f60SyohAGHTF+qeacRYU6NebMWPXqoykvRpPQpmCtcT9
	VrpwxW5FXHRxHVx0Xm13USBckm+pZjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dave Chinner <dgc@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, brauner@kernel.org, 
	qi.zheng@linux.dev, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
Message-ID: <ala6pd9jmPccGjgC@linux.dev>
References: <20260714101454.1202449-1-usama.arif@linux.dev>
 <ala2rDHrFDjql3Qg@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ala2rDHrFDjql3Qg@dread>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7wrykfcujawoponh7f4s9xatcrbaebc8
X-Rspamd-Queue-Id: D6D4D40004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784069695-104973
X-HE-Meta: U2FsdGVkX1/QPius40wo3puwnNm1BXFnc3WVCkAYqVSrgNSSqaY6WtK16tMxWrL9wj7vs7yzU4lDIOJLIWmZDwQnV/XGZz4lWjDmjXJpHZ3tZRqvQfshXInf9vmxUMYBYh3FH/40cMmHuNTcdMBClAJXW7VNAcXE0SSdWyH/fpy/XsqHoWVp1H9V/2AdpDkIhesCXVF1/XYqZWBzwnv0YCy4fvSA9Pm230lQrCnjJxAscJseeS3hhZsbyfpJxaYqoHvCn5zwe6pq7EjDHlEv5iaBg9YH9XcUoS3GZ1dFQACjVVlLCwGny+iUmpju0cg/4TuhEwEV/GjdnsXQwoxJnFUEzJeDHBw2heOiZIEcYW8p67RNiMuUvj4WCojMerosy1A3lEjPLV+Qs8ulscZxlVmxQMHr5iWiV8X8zJ0oQfqfEJ5Y5oAktvENWKAIdScQt/o0B9cDd7fIQGa+Yv7benUOf+yaYKBm5r2YjjBgNDZNtJVFx4NznwI3KhLt7wrLNW2ldA/Fit+SoOe4u9Fgssn9P/pjubV2Odhe+24iVZLLb8p11DH6csfNaFZFpXuoRP54jkcKtLZCSk5OD0ZdYESYvGUM9vwQXdK5UPHiREGafU8TdGTM5xtVWLDFKlzz7zRsUlqOJgMHXs/QsD/kP0AkE5NKjfQ2Hk1J3HRzBjXfUdj329/2nnzl4hMdA0lbqmDlkeZ8vAGVAkEtFZTmvwFR7g90xVmV03DguS8oz0LgBjuz4wvf53emjYAycg6KdKrNQuRXj412Q2Hq88d8IWwYjf2rjSMEzACciReFtdABAobnNgZxg94WTa47Hb4V0RkIv9GOTBswouEvLs3lOX6uTpDWP5gjmh9aqMRaMvYxfTcTc06HwqvZp/xf7MyN8F856ROClbkykMctlMuE9PxzsBsbOy+g0jGnmj/G9s0uc+SYlkHpXKYDYOB0q3N6JgwsTjAOxHtUTwSKsa6
 PNSG0m0B
 68P2zPN79PxYXi3j5kop+SFPtjKLR+dKaAZLnHrZ9pGF7YqXt6MPWslULrCvGMUAhG6muHzmBWoMm0WEX0D41QXzSm64Y+A1K0Z1W3eNQN6SxkfVTrPV/oqvCM69O90nhKxofyWXVstYBej6Itxj4qLV1i443g5r0IiVj2jV71ErAFCsuPgdfl0NvNnDXV9lbGPmtG0f9gNbEpFat/EVYwqYPhx8b2ubDKEH8iVo56Oe/gnbA662PrWIEXk5r05Sm5D48qgwSlUgsyTwR9z64qlSPug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 08:22:36AM +1000, Dave Chinner wrote:
> On Tue, Jul 14, 2026 at 03:14:54AM -0700, Usama Arif wrote:
> > Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> > in memcg slab shrink") added a check in fs/super.c that skips the
> > ->nr_cached_objects() hook whenever the shrinker is invoked for a
> > non-root memcg, because none of the current implementations (btrfs,
> > xfs, shmem huge) honour sc->memcg.
> 
> I don't see that commit in an upstream tree. I'm guessing I wasn't
> cc'd on it, either, because I don't recall seeing that as a patch,
> either.

https://lore.kernel.org/all/20260609123047.1948242-1-usama.arif@linux.dev/

