Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F1B3F54ACF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DEE6B0095; Tue, 24 Mar 2026 11:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DEB76B0098; Tue, 24 Mar 2026 11:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5586B0095; Tue, 24 Mar 2026 11:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E70C6B0093
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:54:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 073AF1A02C7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:54:34 +0000 (UTC)
X-FDA: 84581404068.10.7D4DFD1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8C57B1C0003;
	Tue, 24 Mar 2026 15:54:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SFRR2AU2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OJwGIwkcTDehRPnixVOyfTvqxydByh7rJFCM6sQA7s=;
	b=Cqj34JOLGnx5uTiLS1kEC6HuUsFxqAY3KW6W9Mca7B6X/JZJIfX9qCh0E8YBd62GhR6tuJ
	9u3CZDfU9Ek9PGy0NZ3fp0OlNyGhqEzUs/xPBxm/bJJ7FiipSP//bvwBBdHV2awLg3noh6
	hMAgEgzHm0GuYSDAcxH/yMX53AIaDe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774367672; a=rsa-sha256;
	cv=none;
	b=bLzA4ZRvi/FTIT46SDUADVRSb2MTZ1d/oBXwnZM+V2pm65mnqE6VYM9YFuQMrkFAP7ERjH
	yluXeGIJirLViSZ0Gb6JcY8F4ivEN1EiPJYDatmg3pfhoEsumUDj2N5eCRPEmIAurYF04R
	1soLsOAb/tjicSTHL54emv4bXOCgrCo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SFRR2AU2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0OJwGIwkcTDehRPnixVOyfTvqxydByh7rJFCM6sQA7s=; b=SFRR2AU25aXwGVjJvwFLF3gDgO
	CbdZeKb/9jBMzKy//cI8sVP8V51izbKH4hpRVvaHwZbOh82i7nQikRYyuBXjMYeYC967m3zMLJHy8
	6fVM0TP4GYzJpa7ESSVcTUm9ozOeEK03eAAsAy5Fzb13DOlWRhyOPfJK2gPJInrQKVW0Zs0SGpQ5m
	gGQrFqYn0+XosNl5gdgE/zUCzR3PuGtomDL14UimKDey4wIeHnhBuYZxW2hKBf0HwS2XZam2L1NpT
	d9+5W8CgiiDjPzRCvAGIiKiyJIp81T9jngiiv21p8l/Uld1yt1cl/xmOYjyoqD1TE5xWtWSAZTI3y
	bZNRjwVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w545G-00000001nIU-1AG0;
	Tue, 24 Mar 2026 15:54:22 +0000
Date: Tue, 24 Mar 2026 08:54:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <acKzrqjnKFNK0xmh@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
 <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
 <acKO3NRw852FdGUO@infradead.org>
 <rsftk7gdlamfryksv63vhmewdi6etvvfyi6as5m2zs75ctvzkq@fnoiwumyfdsv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rsftk7gdlamfryksv63vhmewdi6etvvfyi6as5m2zs75ctvzkq@fnoiwumyfdsv>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 8C57B1C0003
X-Stat-Signature: 5fs73647d3dseiesx1qusg1c68sx71ka
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774367670-998163
X-HE-Meta: U2FsdGVkX18nNHLC+gwkLRcALiEdUxNpF3NxA1UadRc7tiaulwuoSPLX0ch1o+Xlc84vd+a3yWov3lbDkn/6kP4kdk/i94sTmbtRdWI+zVy+UWWYMfIjx8CIij9T5kz1qCsnkdp5/+uL+SLoy1BqDIM802FBHLCREXrGf5uRyuc7/+5VyzF0NcfnXSRKswa8w1kz8QxmuAruhU5t3VoNhbPDmgJnBSnV0FoKAnAH2JWIdYd2v56tGSW8ulYdrE4Al1NPomp8We4onqnkH/KpdqFlfaaMawMhklRE1YWlI23iq2M6l72divfQ2E3rFuYbCmDncxyeDz7pTvFPWgNRHjo4j+9dnKoNFFwhwdk8sEg6whA30BT+SwvbTqYokjK6xYZGxlFOHISJ/D+IDzVEqAPzZM+KQxrLtRA94Zr0ewOv1yBTWC9i70UxeuGkZmgKoMJgsPR85oK5uh2fgztIYHkUvjvgy/gsptd0q5rr0QhZkiDYlweYIna1sQUH4PIErf6p2RKR6hU25NILk6P10Ka26lTkTsnZsx3o3sGQhMrOtIqlNacIJIwkknqC6qT+KYcSOoGwAz1vS90C39ft/2Q75u/2/6mawnWFvSO/7YyQcOqvA50q+186sfetNUXRQ9pDhGDscIfyk3sgUm7KJo193x7Zy1IJRpsm9glpTO9GfdPu3hPD2S4hB0708bOQaCue1qszKBPGTRrJyoGK5QDtafEI9NgIZ3wyvg4WqpHvHvAfOP7t+16WyiwYsqpYuX9up9/vrjcg3QE1Fo9SeBGHndzGTAwUtaQgZ1RHuYS75kmb7z0qDtQzZEJHM6K069+oKCghAL78jxvo3mzSntSS3y9fiY37+HlKtMKckvWWr+qVZB5ChjdSY/yw00GbaMSblqwy6fSTLyMMLbARnizzFoqkrxpGSrMRJO0ah+b3ze4Rx85wD7jygmgNpafrONKf8illPDXG66dxfQz
 OQ15Jh0A
 1rMcUKXXizPN9P08vp9OpOfJYZnb3xfptnUlDe9YhWi8COfONNm1HGsQggArR8CXWUMxAA0ntzcv9F9tavAvEgpUcmAIPgMZevrNtjrmTkaqrq5nOvn4950wCCyu0nXDFAEpU9PgxcKDqKEzTa5R9MSOEHv+WfU6WOe7Kv1WOHAQ0FfH5xqDbJFXpIjTwwBwhqEMCMgTZZ/bnCNGKPZgBkIY++U2iZYg+M4D8BZi571kLDHFrWeVz55lSfQsOGVt2Qxw4VAct0UXjS4xlOzvhONlaqp7ybunjBTyjdcxXGWChsUCK3bw0d/estVT7Ms27zKDIJj+OTbHlE/CXZXSb9T61UMrhQ+NWHSJCInq6KqmDNAkMy47clg+Pbo03V27tpD0CO8neBGOYa5iI2YkfH47jiUzf5gDdfBi/mOs36QYuK1aS0g6Ukt7BgdL8i1rubvoUd+DY3MHvmFRgBPdLvU3nVyCYJScRsfDG+KH9s032K/lu+GWouZlG0mz8jaORLZAmTcqcAbfOyz7e6vK9gLCpE2XzTN6auovj6JBiKySwY+VH9HC2fs2E/ucLmUL3fUX7w+eFY+9cEpfcp3Dowx5nPaYiNHSa5aSeVahRwB2oDvCB8F3byR6gCYVGrHNWYxzoUhZgVkZBNtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 02:36:53PM +0100, Jan Kara wrote:
> Leaving the two implementations separate certainly works for me as well
> (that's why I've put that patch to the end because I've expected some
> discussions around it :)). Just the amount of common trivial calls you need
> to do (fdatawrite(), sync_inode_metadata(),
> file_check_and_advance_wb_err(), blkdev_issue_flush()) looked high enough
> to me to be worth merging the implementations. But I don't feel strongly
> either way.

I don't really feel either way, and I really should not micro-manage
the series either.  So go for what you think works best.  The important
part is to have the fsync changes early and to avoid hardcoding
buffer_head knowledge into libfs.c.


