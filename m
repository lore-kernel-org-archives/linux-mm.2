Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7DD9E98FB5
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 06:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D631B6B0005; Thu,  9 Apr 2026 02:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13F36B0088; Thu,  9 Apr 2026 02:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29B76B008A; Thu,  9 Apr 2026 02:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC1896B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:05:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C22858CF9
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:05:11 +0000 (UTC)
X-FDA: 84637979622.27.418C84D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1B4CF1C000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:05:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AtKfG8SF;
	spf=none (imf21.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775714709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlV9liKL29iVcevggKbEsekSMq0e9B72XQq7jVOP77w=;
	b=ijBtjn6EfJP9sJs1z5wVuc1GJQEvx/CFZl/sVvO7JGsjaG8bgdxy9URYhBDR/Uq87mrBTY
	+Sg+JI3b1TqBrNfWrndXypMaaRr6lewBJAxe9W5Sv0+AGZlS1wfLuGhXe/0PwLTDNx+3MS
	gdwy6j5Sh1fejHgkpm/o9mE0ch2vZ5g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775714709; a=rsa-sha256;
	cv=none;
	b=2+/RvQWGfbSh4s+JrhGR1TSogrGDK5tZjrVkA0K0LtBxUcbi7kdqGQ53sQQbf3FLU3To48
	toyOzNmKZyrROUnAFic4JAzSU9NSNhkVZH8tpGHofqriSnmWad+LVgyN8hp50Qx4sQKvZm
	/avVkFgfog+wMtvpX32D0IucyW29NeA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AtKfG8SF;
	spf=none (imf21.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AlV9liKL29iVcevggKbEsekSMq0e9B72XQq7jVOP77w=; b=AtKfG8SF+GOpLQVks541I23xk8
	Jpw1TpCf+jyW9IuOTTRYwESlrdcriGzdqP/Je4yt9s/xW/Xe4TWRp2hA+He1BTrnaW9i9AiGAvt2o
	LdUC+04nNVFD8owoOn5OnBDJ/ApS///2c7nj5dOFMItqFSIBY0/MvWzf3XuHBWrRuBDp+kUP8AwJL
	HerB3KzfL3ffVOH9OGbGZal0MknBJGWj3DC/u+1tLRImR5USjaq9TRZapmbRmdaf9d/La2VjyIpVa
	3190R3KMqOVohQCkbfIxJAOebBKO/Bpgo5+dqCc0XtQ3Iu74heVJu0eBuBRWawZ4xjURboKUZbOwn
	x8AecBAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAiVk-00000009k06-27Kc;
	Thu, 09 Apr 2026 06:05:04 +0000
Date: Wed, 8 Apr 2026 23:05:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: improve write performance with RWF_DONTCACHE
Message-ID: <addBkBKySJUb8MB4@infradead.org>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 1B4CF1C000A
X-Stat-Signature: gxo4hkzsorzzbsnj9pgremt8ixtzwsh4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775714708-748433
X-HE-Meta: U2FsdGVkX1/ovZIIumz6ln+j9IARvhAbdDBhYtzXbSCNBQYfMLjQqd9sigjZrm9PcEJzoXRdVziiNzpsgjMJ1nn9kC1m0CAzSimend1IymW7A5oZGmx/QORmPkA8IHDJItL/hDzB8gx1zgfqglXHliQXwPOe5BHy7F/+A2fTQ0XAiQ7Lcz0vsUrygRjf4kG5eohalVweu7xJ6HVf3wzjn+KaJDms3qckR+/kosK6HdECzKTLHWqUKb+MiUzjnwPQTSGrWWoEVTy3La0Ip8V0PDmLupeSRkRGssVKUNjHUEqukiOeoZTgQJKX2RwzX4YVEGg30me0pxNQ1H71dPONKzuXZMhyMqRIMYdBrv5/r6nuHWLtqEKCn/9C9w6DIYzlJ0jJG/rGVK53hA49HNWNk5U2s9tklg9hU20SiPrngQz15fJ8vx/OKvTm8cMFq10Yss0mt6GE2UX3YzQXCTddyHwvHMeDnhBPreRBTaGcAiD9jXqSGyp2D+DXnafvInOa27tsQL5y4SC1uiJCvL22PRKBoB/Vut26qWOqQXijnU9iYLLfwTifTQtncfFmQmmUNr8DwuoAeVCEYPd+SEuVYyFiokKO8zPBhgsWB/G0IEDQRPK0W+jka1jCJPFZZGX1B6t5PzcDQR/5wvzWyA0drXkbkJZFgz9kXOX4/m2pzQVsbZ4jR5QZJkJipo8cTRBD0u3IWZFQOeYA0qWW/5oVGZgAK4AtxHbxxbSscIlpy0utr9KHEVnG/+TzzPB9iv751Z8nbVLRao/UeO7gZoi4UnL4uCa6yV9InCnlr2CWd7TTuxEImKYqtBPanKeCpYS6UgllAUBF8x8LvZUAv0ggvHx0+ynymSi0K8k7T+bAWGe+vC/GsA7c57EsG8EjEo4dwoPttsf7IMcdnk4AGUioO6qMIwpsVBwp/sm3zbvPT6Ly3ISFqo1S2N5CybdJuMCvb3ZkOPaODaNcGWagruu
 krE5OcJD
 2/GSCWpLzoHFlGedkdjSEjD8UbEoXulN9L/plaEl+XP2CGM/1QvhseVcDx2CNrYxkO308iP/AoNh3X1eSTJgzU6XSwml54ljvGZ0FXZqo0dMAMMoRn/zZJmnnI219aWnj1zqGrYtYkZkUnCWkNhky3GtE7MSRJ4Vt1GtsKFfGEgjaH3GCGGveSi6zaq5xVxuS59D1uBhqLGrSO7IQ6FarMss03uV88xYyrKhm3S6fdaKNoNs0+PnImU0u5BpshCa1GxK9wCbRwfdkrRni0OQIUqI7Wm30qTmIGbfpETwzeLlwWpmgvAkfVLjC1BD1/8VO1Xfa7g4tlpEP3NphDvtA4/i2zJSjbH3aMmzGpY1K7c0ipa9cNa7GMGr2IJra8RkFDRtx+2aiiv4Ftwq5ULyL9xsXZnf7zLc0bhlHDpbC5bhvA9FvwIqCoCubSny4n1cI4kTajnN27bYC3Ia7YtOffYoM4s7DTrdnsDEcRQFWdQzIlvN8GXl8dcjAG+PM1J2/mvfGUTsC/lydCZ3FDwPy8/EEDoX9LyrbUXhhU+WjYMQAenh9Xf5d9YtrHLuQiUt8m4GxWNvuzUV4wmX7Bt1LfgjARMPtFoZ2DWB/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 10:25:20AM -0400, Jeff Layton wrote:
> This version adopts Christoph's suggest to have generic_write_sync()
> kick the flusher thread for the superblock instead of initiating
> writeback directly. This seems to perform as well or better in most
> cases than doing the writeback directly.
> 
> Here are results on XFS, both local and exported via knfsd:
> 
>     nfsd: https://markdownpastebin.com/?id=1884b9487c404ff4b7094ed41cc48f05
>     xfs: https://markdownpastebin.com/?id=3c6b262182184b25b7d58fb211374475

Please add the results into the patch.  Besides having them in the patch
vs the cover letter, URLs to random hosting sites tend to get stale
very easily.

Comments on the XFS numbers / benchmark setup:

How does O_DIRECT manage to create almost the same peek dirty as
buffered?  Similarly even this patched doncache show be lower, which
feels odd.

(the editorializing in these results feels odd, not sure what tool
generates them, but maybe edit it for the commit log to look a bit more
serious).

Given that this patch does not change the read path, how do the pure read
numbers for patches vs unpatched dontcache manage to differ so much?

Comments on the NFSD numbers / benchmark setup:

I though you were testing using dontcache on the server, but the
comments seem to imply it is done on the client, what is the case
here? 

Again, the read changes between patches and unpatched look suspect.
Please drill down why they happen, the fact that patches is slower here
and faster in XFS makes me wonder if the results might just be very
volatile?


