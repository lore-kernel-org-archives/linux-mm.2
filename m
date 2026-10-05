Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF89CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51506B0092; Mon,  5 Oct 2026 04:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29206B0093; Mon,  5 Oct 2026 04:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65B66B0095; Mon,  5 Oct 2026 04:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86C2F6B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:26:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E802E140197
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:26:33 +0000 (UTC)
X-FDA: 85287891066.15.C2C17BF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 251F5140005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:26:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QTJb6Nwu;
	spf=none (imf26.hostedemail.com: domain of BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791188792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RHPXjYw3ot+kYnaznQEYzuJhqEHSABJV8Imhq+QkwU=;
	b=4ceE06FpLO0aV2kOyDxEZ+3dJo5wnOQlJi9ftaC0UK/+iNcZGyNpUsRC4nCkvroMKqHcmB
	p4DMdZ3uOs0AgzBeitSzWwAPzGeL0PynmOL4KWdzVVO8nMI3bf1QTlsSLv6q0A/C6a22rF
	BtkyT7dCRZv8Og6yd11Q0bQIcejpjYo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QTJb6Nwu;
	spf=none (imf26.hostedemail.com: domain of BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791188792;
	b=CQO57xC/YT1u8okmRAP/cZVWiprekYVw5gA6ZpcBZc4dlzwaE6mMsHHwxFhsQ/ErDx3uQU
	YkQ9cRdllrn1rMlxA5cDkJRO3wCS59nDHufS7IyFKHgirhx0xKYZWEr7N1XI7Zk2LAgzhk
	6elsU/7jUI5HDMEkWLgxsjSgp6O5HUk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3RHPXjYw3ot+kYnaznQEYzuJhqEHSABJV8Imhq+QkwU=; b=QTJb6Nwuc9cCF83e6++BCnLJ/O
	32Jmf38rHZ7y1JBBHO27weAbf2HJfpJCib9VKdvB5ekAa8Q7O1ASRUVSZy9z3PxJpP48UDUpWIX8v
	ooZh9QP7yPkpW6VtTSTFYNrn81DUoZCOsdC6t101dbCfhygWZmDPzxW7TDYb/cikn0gwwRmInSzb6
	+B4ARmnsiAxFCgfQN4nktfpZtS30XGhjpoE410dLrC54nxYWrtsVmJlCVc0O5EQWBjdsDAlVlyw62
	GezjOVUCR9D5Sjl8pprZGvQge5NWpr4DYaSybJozybo07yGnP2J8ZWOLIzODk7sToSXvz6kRUo7E+
	tfv53fyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDe1k-0000000Fsd9-0Jg4;
	Mon, 05 Oct 2026 08:26:28 +0000
Date: Mon, 5 Oct 2026 01:26:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
	akpm@linux-foundation.org, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <asNfNHd-kcsI4B1S@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 251F5140005
X-Rspam-User: 
X-Stat-Signature: qtefeom4r31yc6od8bzx6tr1ikh5tmc7
X-HE-Tag: 1791188792-633565
X-HE-Meta: U2FsdGVkX18W34rugNkEoMDJFhsf8ZkgBeoQi42FxFEYo6MRthhtbbVJt9cAkEkt21A3rTJ7zq16R9tf3r0CHLx2tXKLsm8VurpNI6CczP8IoYV9tNLrmMGhCDWBDJm/ochj3cH67iXNw6Hrl+cX9X4mgeGHZdxXJrmwk+aktC2Wy6Xr2+b2YIh/ObiuYcTaN/k8mHIS4RCNZ821KOEcMbIziDf8S2yNOLn3N4z8W2tZiM6PoS+U3EPGXi0tIje8eajiXBmxOx4n6/mFQIP6QJFL9MBTE8Z3l2xMXC7x3sJNG3ePsJeMx9yvXOhUxyyd3v6DiAM+rbYvhb/3Jf2XHJZ62/+dXZg6glZ4gK0M1oFURGPfb5LGwmQl7iEUzIIIUrTEmCaqlOMP/Q/PtvUrEQijj+FDgFPH6a8+ds7j9C6qNAXxT2JIy+2AKr93FbSy1oNeT8TNqBelVNTCTUlJ1WeN+tam29y21G5uO5B2Z0A1Tu36t9VwCtRataXrFPxyGZ9dLzA7yOIsZFiNuLHBkqeegCZNtOlWP47541IbN+oy44NeUFYFpR12QsIh68On/NSB+YCtcHbawxYCxnyQgB8KJz3aLBbJjGZWEu9whHRW6aJjU2U+ZYMI0CwD3pnqQWkXYFt85AtpuFXIgxLMF3EUtB1o4omy5AgKuDU6Qly9FzZOrid90lekgGSBAmf+0OW5bydYAKv904mJWUpS8Wxj6QJEOJSZVeq/mrvbVEgzSub4L+/JHiBNhWHogESdjKyFcZXi33r1bnYBzh2lQvkwK0IiN8tyD93TdN1g8HniQ1COAdqDs911Mxk9meQx8U9xxD2euiv8WZxEMLI2m8c9osi7wWi2GbustY0dcFSDUCKrmiX+ww7nA4OX/+kxCrDkPzeSqJnDHAeuU4markPWA2s6ARbCB9xH74Hv/IASd92noUQZdM3ywRB7uhYgEuo2Jbe1TemDxdhlZMG
 +7am4gr6
 vOa/I4PZGSFEJB9jP//IfC9VLVmbaU2x6dg/cBCKyfMqWhI6RCS32AGKVtsStKdWvWoOGRme11MApbMkQGRHtxTLMH4Aevfd3yDtP9EhE+kDLUsgkA/wg2ahbg4WSamEsXmOyaqKJj6IYMBSzhDRvzIdkCvWAGnqgoBpuUJbv0Wwnk4FjVVxLtxVR7a67Yjb48baLbTdUGY+1kz22BYyrcS29jyBdJsk/GnzFz8/0KFDQ7gcoJT1tjOobA1+YLlQFMTXxoJMLjulq/Moo1oL4fpk/CzblDTSDMn8JdL1ZuGQs25WkYAiLPS5bXnrNli7F9g9fFuJQHnH7qViub93qEjTlZs6PYNNZulo7I7WnkBGc5Wk8d50ZgPJ4ZWQMe6AazB5bFmMt61we2FNM+8SDwPOZBm4VNRHd4J/UzNLEwMd7st/XDRqSYlMravMm2IwW+Tq7Nh7S+JpUOIKhIfxj2ENHCxYrlSEujQ0spfmYr1AGP7gZkCU0VoeMnMGCjqLXh1qsGfQe136z9Pnqmjj4T6Li1br3SZAYVekULy55AVTrsJYqyQrktSpGeNgJRNcgCi9bZlhjuftc/9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 01:10:42PM +0200, Jan Kara wrote:
> FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
> for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
> for bdev mappings will cause issues because some users may be using bdevs
> directly for their workloads and they could still expect proper memcg
> accounting to work in that case.

Agreed that it should not set unconditionally.

> We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
> it when releasing bdev) but that would have to make sure there are no
> folios in the bdev mapping when changing the flag as otherwise the
> accounting would go wrong. Looks it might be doable but getting all the
> cornercases right will be hairy and overall not very appealing to me...

I'd rather not support special case writeback code just for this legacy
fs abuses bdev buffer cache case.  And we basically need to tear
down pagecache at unmount anyway, as i_blkbits can change, so while
we do need to be careful, I don't think it really is a major issue.

We might be able to restrict to setting it when
CONFIG_BLK_DEV_WRITE_MOUNTED is disabled to avoid the problem of non-fs
shared mmap writers, as anyone using a modern kernel and cgroups really
should have that disabled.


