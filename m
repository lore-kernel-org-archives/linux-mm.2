Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9647BC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F1E6B00CB; Tue,  4 Aug 2026 17:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7405A6B00CE; Tue,  4 Aug 2026 17:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656006B00CF; Tue,  4 Aug 2026 17:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D64F6B00CB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:27:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3505402DF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:27:12 +0000 (UTC)
X-FDA: 85064872704.24.C33FD88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B0A1D40004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:27:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=njuvaOw0;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785878831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jc8DztnvJAtNJ0O48g/cNmZXd6zTWCvVblHZX5gxwbI=;
	b=aPEO/uq8bXkuScPQsW12eGYpFjBuQF07RCTzZLy4yWncvjpXN4P+BJkJkQKZHaxCFQ8r+j
	3IOhOzlLQS8oZ11g5rfln2dxrrsxNMvjWbrb/0dQQZDQxsHZvTlBq+05lTdFEOEXh3kjgT
	PNRy4IeCeDr/BSaSOsda30J7lhy0V30=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=njuvaOw0;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785878831;
	b=Azl6OoQYh60qAJtyocTrnLBpWFDDvcguLkgYz34tI9OwqtV55eyshazS3jy5zw4NKAtgwU
	iWcYWbYnq8SfjzTjjxelNLz4yr/uWKD3uJKC8TjeizpCsmT7S+JXbXzO81t67aJ/bZOR6u
	qSKEE7U5YsGAY4IQXu9ryQmVcWbM1UQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB1F143D56;
	Tue,  4 Aug 2026 21:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9781F000E9;
	Tue,  4 Aug 2026 21:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785878829;
	bh=Jc8DztnvJAtNJ0O48g/cNmZXd6zTWCvVblHZX5gxwbI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=njuvaOw0C0aJ4woC1WNHQV44+ODTPuQfNGE3Yw7zQ9VrkO147HTJJPDmnN77mCLCb
	 Vc+qpei6tQrhdhnFr7IRv0CtzUsDSvkVvoAxTAakELvPu2WhaISGJGv4xl0uFdziP5
	 Adx/5fBcD0m9JbgSDHYbK6wcSYkqeSlQXCJFUJ38=
Date: Tue, 4 Aug 2026 14:27:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, William Kucharski
 <william.kucharski@oracle.com>, David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
Message-Id: <20260804142708.f002cf20a34420874b8dbb21@linux-foundation.org>
In-Reply-To: <anJP-FXqH3iNjTJ_@cmpxchg.org>
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
	<20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
	<am28pV2PEfHsi4p-@lucifer>
	<DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
	<anJP-FXqH3iNjTJ_@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B0A1D40004
X-Stat-Signature: nyhq5b3g3key63ctk1qt6zzf8s9qw4f1
X-Rspam-User: 
X-HE-Tag: 1785878830-85455
X-HE-Meta: U2FsdGVkX1/ykOGIJm9TAkZlueeMoXrfQkwHti8eNciGjzI2+Nh2eXJMnOPNhvZk7S0uhUK/n2vI08L5sNnVnl2flDgQZpAHcnS8GupHvS1nHeK1dsWuFJsW6Qr8R/m0kVALzXTRu8jQpXxUXxl1eWO9vy4XFpIxLGcA7dluqy4LetjP3cIZkxkbN8+rdhqOw0HRimRkLHcHxgLQQIdhul1ZfTMZL8HZZXXam+u7nwJE9U1uI6XbKjUOP/p6nLlJ23XmjaBJiBdTQEBhiLu4E83vlowtpjEwBr1fzZ6wIvn8PFn0bTYe8Pm0OMsO/eQoPMe0J0TVGg2mpPF8TXYZnLSQ0lWlDeBU0w9gjsJ4Bq1pks0bo0qt+aGQh/mr8aIYHoQznpMFRkFPGxfsd7IH/gnssLFHgV1EyE30r9CwpwMO7CX+biII7shxCFg9B7ajGhutp5Cg7a1juMliO6CboE0ogrewgzWJlUU2yeRJTOZ+6BqWK0/5s4MQHzLGte1hHg/bXrJypM/L1IMrKSxFoEObS0cj4f9Apz/WhSOu0n6vATgJxqUo5OZdnlgrLBZ6At0oPBAmt9/wIn+DatxYTKUkIlmmtLsZ5TUkDPBX87qxmGIYIqMgaWsehuklTVjVC7VZ5zNzKbq7kY/aZnKnL6fjQ1bp3zUhcXD4YAUlGOH2lJezzPb1AoE2kUwiNNKq0XSMv2/FVST4q+IXQrZim9OgDaCrlef75uEdpAYmcW85Csed7GzYfixdDLqjK9VJTwMz791wRSd9YGlDWa1Zi7YN14HV71SkYooZdkcscNgkKBnh1iaFFSlCLTsU9nM4X+bKaEjKhp37lWb3XVty4ucID0ogYtrEL+d7l69dufED7nh90dxitGiXl9jzEtbNamnJIjJehc9rJ639a15IZCRixNaQwjSjStHueUFWJwVm7O4WgGzUOzSBbHFfPcDP6Xl8zXr5Qj3MohBRA0B
 eNLwYnYt
 omB/mQg2rkRYvKTSzo4tCXLeyX3kQHDVBDYJb0q+bnaO0KKddNHmi2RuY3E7cpfSGLXySGFi9kMpTGul3F0EjrMZpzx4SurgN2NGr1UvxAXZoLQJXtxNesKmz/CSNl3+B8JGz/jnzImDtc8dIXrTmtFAggETDLwPRKWhCFHoKcwIedD59NtG37TnFQViuhYSfAojlZlvKHdwXlSJdI9e8DcCmzJqyQoeDMWFnvjjEDxbmqsRgxJDvlL+RC/GK8qmpWTgmWsi5gm0xWVTMyXaVQCKO47NA9OWDjdDITgXM7g6GsYST3QWdNCodkNO+YLkAt9jy/dtJcFgAuh/DtVWzinmOR5pnXcptQG9QgA3Xsqr3i61W4yAsyrnEAVvIju46/vmcxzu8Wj+dFL7f0h/GMYZMIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 16:47:52 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Like you said above, only xas_split_alloc() is affected. And we have not
> > seen related workingset regression report (like what Johannes reported
> > in commit 7b785645e8f13 ("mm: fix page cache convergence regression")).
> > It might be OK to not backport.
> > 
> > Johannes, what is your take on this?
> 
> Yeah, let's Cc stable.
> 
> It would be a bear to debug if you ran into this at scale. Which I
> think you could with certain workloads.
> 
> The patches are straight-forward enough. It favors a backport.

I've added cc:stable to both and updated the [2/2] changelog as
suggested in
https://lore.kernel.org/all/DKFELWPHSJNO.3GGVW270HENEG@nvidia.com// So
afaik this series is good-to-go, thanks.


