Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F19E4E64006
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 05:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275066B0088; Mon,  6 Apr 2026 01:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B836B0089; Mon,  6 Apr 2026 01:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C056B008A; Mon,  6 Apr 2026 01:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 003EB6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:44:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8970413A264
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:44:47 +0000 (UTC)
X-FDA: 84627041814.03.E8AD4A8
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1A2D614000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:44:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ys78b5N4;
	spf=none (imf23.hostedemail.com: domain of BATV+e35ce2fa15ba15168fb2+8261+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e35ce2fa15ba15168fb2+8261+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775454285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5LxlInPJ7/UGCLgthuGl+ND/trl20UHwe3EP42gW3U=;
	b=I8KXCKnPQQnPDks8nQquy/5e1BqJEOWFm3TsDhEi/oeENsWCf7aXeQUudVf/8atysfUSqp
	Yz/vvmw7rLVLDG0DC6Z4sPi1BhT1JIjAwjPYuHKWcfU5shRDzl7j3sdywleO59y5bdBBRY
	goVJ+8KBJknYOOebth/qFAvgndvfkbs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ys78b5N4;
	spf=none (imf23.hostedemail.com: domain of BATV+e35ce2fa15ba15168fb2+8261+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e35ce2fa15ba15168fb2+8261+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775454285; a=rsa-sha256;
	cv=none;
	b=kN38wUlcls8bC/fz8HoNhi8L83lddgLGCSz7xdgZwOksdVcxJDY90LVd4IRhzqRMFKfDPA
	Wd8nWxLQ6X05/Lr4i9WTXbe59v9rJsSwA86YW93xYlKrGL/6SM7K0vd6yN7ETI2AG5fanH
	F4CGBDOtmK1oVv658YbO2nYdbEB7E1Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M5LxlInPJ7/UGCLgthuGl+ND/trl20UHwe3EP42gW3U=; b=ys78b5N4ODFhtd/VHJZKyPEIEZ
	CAcNY121v6nTNVo9GQQ+SlfrgslNKsqT2ERk4mnIwvtl7Bmx2Sl1mc5SK0TrcAEJoRBVwT/klowrG
	CFVwVrIhadbiNGNhHpGjTO8LuZ9Et76aN6pSvfxqM/eSUeFVn3llD/d7f9nUNEfykhyetHqnsVzDJ
	AE5MFa1K1MD1h6GcM2fxQDeP7Zj+RhV5rEdRbQHk+tSBNjW66F9azNPTorQCr6BzpJg/TQRa11kd4
	BPV3nVQuU7ybNBrZfv3NujPJp2MqsopoNsN9JOgGvx1z9vm5egOwOtaCC8gj++QdHNty6Plcdxesl
	DPS6KcZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9clL-00000004ozj-0Jpu;
	Mon, 06 Apr 2026 05:44:39 +0000
Date: Sun, 5 Apr 2026 22:44:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
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
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: fix IOCB_DONTCACHE write performance with
 rate-limited writeback
Message-ID: <adNIR8atJj38IL9p@infradead.org>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
 <20260401-dontcache-v1-1-1f5746fab47a@kernel.org>
 <ac385Il8l-krKEOQ@infradead.org>
 <01dd135adf38e35492d957a35e22c4ba5c2283d1.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01dd135adf38e35492d957a35e22c4ba5c2283d1.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A2D614000C
X-Stat-Signature: escet37bfx4q9wy813g6xh8obzk4bctw
X-Rspam-User: 
X-HE-Tag: 1775454284-581253
X-HE-Meta: U2FsdGVkX1+vEqJUoyWP+X7uYEijfgkCJoKWL8Tc9a6sfQ3tXI1QXH8JAnFPSjQnI7+6MGgiFSZubugXVejGD88VQDH6mw8/U56jDo+JsRH1uSfEU/8geYWqTXffYbn7mW7CH1zuaq2FQ/T+c7S+VRrN1CYka5xLu22eJ/QmSrv6Vilyb/LGtC/aGc+MyoEi7Ja+MM5vruLgQcyLV6inY1UwS81Wtq7bUk0vHzN9nMNv5ZTMlzDhR3PfxY/NUY3ZFHFFDEMMfercN5ZWwJkjyJnRomIg3YcvGrAydGnWaygIkrR3OqCQJbT6POlqAt3PfzU8gHemFwodblZCVQdNtuQm6MbdDz0Y0ZKN7yKqx67Y7d8sc0eooCa1dPMlTlrpfILq5oefm4tJo0mM1h/verzWdxZ1ywJebl7ZVhIodWQA+Q5+VX9LkT9tNEEHhZidV85QthZjdseMrQIAmUrQgjIv+ZuFx9cJDPQjgky29hZ6JZ4apRDinUbvJF2g6gqHGVHOwchLR9oTWEbWWA4LuRJoQdLjjDGFKA0x9xse9tLa7IC9QGG6QR96aQCjQ8dkdfMcDbTZPgxo4KQx8QZ5EOYJeg3xcIOdBni7ygzyytAAJmJJI/AA/aGU9EP/2PFg9hyJ+Fe7or7cfSxQxR79bb1H7zEK4Zq2SnAS7TN8irpUyVUj9DxNQOhmxViPQm0dQKlHSr661X6JzGk35sKCqJiUncKukzxS9QoqEcd2V2U7b1JSL5mpjdd5VlZXLYtF3vDV9nk5dpjXTBn/frxUMoP+i0ia8qFn9dJO6Z8eSsMnVzzMIIblPlWUamhoZeWSnB/qJ3jRCnNPMeZOV7c53HZJzEUSnR7djxqPt7uwYPA89uhBN9CjX+YPqZ7Jjd6o7/ViDE6oFwf5ZaEGrHKZLk6PeTx9Cgg02qXQ9GEN620ZeN29f5nXbed/nz9+8cPNsiAUGgJjiJOW6W0zFlF
 SYdJCo9W
 mfb3OlHXHaROMqrtsnco/HFGut0G3x2AldfhBagM1vNpN910fXsb1uiRViqO891P6B8xOx2YV4/bzFg2jFlo29nqbya6xmyTWmItgzEXgQvPHz+6XoDStmSAJUHH6OUjE9WYn8rPEeJm9K9Rqlkf4XQ6RjK5IF5Hm4Ko9OtNe4o6YTjjqwcc3yjpMx2t1HGtUHzXX+MsNQQnLIsVOZqLOvyjBC5NA+Ur5jV968BxnNvCwo9GdRxYP/ECON4CNhGgv9aG6xXV7w7x6nQU3e9FjUj6e/fSDkMocy/znyZYhv4rKarxzdCQ9oWIcyOZGMLVZuDfy/odqTuC2ECey/RcTi9XRXAr4Y9mYvLXc+3h9RPfUU9kxNWPlmZaH5BUwbWRQQtEoFHI27RioPh5sYUbh0/DL3MCSG7pZJKTMBs52GnU8HeVDHr8ag1Jc5nNYACbJUutvS0XlBVf/VLkyRSf6sVDlupjEbk/YXkDl+kXbT97MMMwN6lAumYDuX+0jjpMTvfLjnXj/hSGZDxl/GP8/mkCMp8pqDWJpS2hLew+0uyXhEVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 08:28:42AM -0400, Jeff Layton wrote:
> > On Wed, Apr 01, 2026 at 03:10:58PM -0400, Jeff Layton wrote:
> > > IOCB_DONTCACHE calls filemap_flush_range() with nr_to_write=LONG_MAX
> > > on every write, which flushes all dirty pages in the written range.
> > > 
> > > Under concurrent writers this creates severe serialization on the
> > > writeback submission path, causing throughput to collapse to ~47% of
> > > buffered I/O with multi-second tail latency.  Even single-client
> > > sequential writes suffer: on a 512GB file with 256GB RAM, the
> > > aggressive flushing triggers dirty throttling that limits throughput
> > > to 575 MB/s vs 1442 MB/s with rate-limited writeback.
> > 
> > I'm not sure the first how you think the first paragraph relate to
> > the second.
> > 
> 
> The belief is that under heavy parallel write workload on the same
> inode, the writers all end up stacking up on the mapping's xa_lock.
> However as Ritesh points out, I should probably confirm that with perf.

But nr_to_write should not change anything.  If .range_start and
.range_end are set in a writeback_iter() loop, writeback_iter will try to
get and writeback every page in the range.  Setting nr_to_write in
addition to that could only reduce the amount written if it was less than
the size of the range, which in your patch it isn't.

In fact we should probably have a debug check to never set both a range
and nr_to_write as that combination doesn't make sense.


