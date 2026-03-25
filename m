Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 095D9109C05D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592C06B0089; Wed, 25 Mar 2026 16:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543D66B008A; Wed, 25 Mar 2026 16:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480BA6B008C; Wed, 25 Mar 2026 16:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 390B66B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:35:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8BC013BFB1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:34:59 +0000 (UTC)
X-FDA: 84585739518.26.482F59B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4AA0F140003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:34:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bbYBhCbS;
	spf=pass (imf23.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774470898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPXlDI1QcmZ+5Fe+XHVTnW0r2MT0sKRg8V1Lk71k1Zk=;
	b=zvJo9XKb3g/MM0tt4nqiAE7no9P70lPWAIRzW7oo4sHhFqdP2Aj2Gw2qbhif3BYAlqMhqN
	y0aRtU4nUENClGjyVk2x0RciklbvV21GtNBPCkMMSZnoC/CQd0pB+ZWF0IoTNxCcztOlgW
	txP22vfgWYJkGsrvgBkseWpHsNR9bY8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bbYBhCbS;
	spf=pass (imf23.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774470898; a=rsa-sha256;
	cv=none;
	b=39CCv/W2m/BFafp4tgw+ryRnZ3Iz0IriE5vaLizeEjvc5spSHIzdQCMTj84Qg6rTZkgsnY
	ZtsGOy6wC3mT7K3hEXlr4FSJitxyn2iOyGfOZEkLFx9+ukH9+PGdB833P3T56F1KVPeq1b
	KrHve6iHrh+FUr/NLgGWnKyDbDLHRsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B790260053;
	Wed, 25 Mar 2026 20:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9764DC4CEF7;
	Wed, 25 Mar 2026 20:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774470897;
	bh=hY080uvPl+LEJJt54gSEYsldkDiD0CJld2/4td8A6aI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bbYBhCbSSQyOTk2rJFqHAHyFkKsd73IqUwcFy1AxQRkoLCwLLPF6umiKPs2LeSj7H
	 Hb2Y1u24jgh3bjfi6QzV4qDUu44EkKemZiprOOLgNgmHHUayATDX8gnaSXKhoYUck0
	 oaxE1niv2eRDUu2vHcH/hKX7Tbh4hCPoz0Y/MIbst2XgsBzoS8Ttync+PNpOfwa3bH
	 5IVdXJnMAQ6hoLZ/Amx7/4E0zDBlAaMvXFa03NeGgd1xTLyLS8gVLGk4rAzXdR/mU+
	 6xueRiigw4BkQhn+wkJqXsBN1gQeiEN02uf1TnMkhR3uvyRnMWgxgs0oifdlPY5Cca
	 fgS5DepuxPWMA==
Date: Thu, 26 Mar 2026 07:34:45 +1100
From: Dave Chinner <dgc@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acRG5f9QjdEKg2JB@dread>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
X-Rspamd-Queue-Id: 4AA0F140003
X-Stat-Signature: noiigkf9i9ofhussri6d5cphrwrnqad9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774470898-849524
X-HE-Meta: U2FsdGVkX1+g40/hJVA8bb2ELHgJs2CkAhfJbZZbAhewxgGou1QubRapCpUuHtkOezhYnUf+p2TNFBDUZHz6bmXT7ARWVm2hOhEHoPbvBxpGirHQkrzJcZvgrwlGRjZ8+8ykmFpc3nvNSTHvARaI206I515QpoDTSMpYjGNFy6VgKbEI+XMF2ePsPoj0pVBaMDMIyH4kSxKpqsvqMQ+dnCUJCflIz6gxBnezrpGOPAQfkFE5EmskLQHmT84LpWcEwynh0NR30m/L9dhIJaDqkeNA7H03M3ZytbFRNySh2LpvQ6+Me8h1kx1psYc11+u4kY7JmrEJQ8YBFU+pHD1LNAqGPYhcZcqW0bYD/wUwhqaHz0VpRGJX6W8qjTmfBBRlsxFpdqKWi/jNf5Hy3PNExjalirvuKcFCJ63o+N3UtnKEzlbShkBXcO8yIkBpk+8az++0bjfeuiQejrRNzSidlhM7NQce2MWZc/OsHzF75b1qSjtu47HP5iWEm4PGRBIrePkSubjWxHIbLVZi5X1mhx/T039DBVDp5w7WIgWpqsmjTHOxwEw7SVj6Jel5M0OLLbF3/WvcViMp0gUaWGrMR2lV2bI7sauczdlJUClwndYVXd3UUODMM2x6IXfUk7hj2Vuvr+OBWxKxM0EkH7kzHeDKjOUoPTyPvZJgGLKomU8d9A0/GGwN34MRkwL9T608gKa/paMEmh1nYynDtVqkvO+3sl64dnt0IVtgNXX8yb0bBAuwm9b6+XD+yw27EmAIDwWLZAo4liBpIa/k7OCUwd4YpUGlT22Y1hwIBXrNed/ELXUpPVzet4AMz1kfS2QB+hoWzPHx38QI32wcneHg33gQmsTDfJw6abtTKpLLTT/a60ECYzY4xyXnyAqHKOzjvd6RKs/pgWagjc0saRS9cnsPExm5wZwzS91jT1b3SNv5ubJ2zb/neTDyUcqzXsiQlWSrq3C4z+jCYskl/JU
 VEyo2VGk
 AQGdmO2L3NbOd8dHYY8vayQ0LoOCbiwTc7kWyDFeEq83h6hgOv9lPiimIkQbBN91E4O0RFktkoljTkptY75+8I5JkxCF8ayZVVl4ugsnjxR4DZBFN/7BZXAb/FmfO4XX4H3qwm5GGMiQBhJFfnmkRAMfGFx9PXrCHjGkO9zDNJgnrLg960GS7GPykYJPF4bO041JabZQFa00AcP17/FKqKC09GTWMQta43NtsV5pq4usqopYaV2BZcAWOt3UovC/Qen0B35Avwj6aEYYw0WbBN4Hd0kbMQTgxJ3a+duEoUhcV7y9l5siVc90vYztlyIX3xiJS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
> context, where folio_end_dropbehind() can safely invalidate folios.
> 
> With the bio layer now handling task-context deferral generically, XFS
> no longer needs to route DONTCACHE ioends through its completion
> workqueue for page cache invalidation. Remove the DONTCACHE check from
> xfs_ioend_needs_wq_completion().
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/iomap/ioend.c  | 2 ++
>  fs/xfs/xfs_aops.c | 4 ----
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index e4d57cb969f1..6b8375d11cc0 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>  			       GFP_NOFS, &iomap_ioend_bioset);
>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>  	bio->bi_write_hint = wpc->inode->i_write_hint;
> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  	wbc_init_bio(wpc->wbc, bio);
>  	wpc->nr_folios = 0;
>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 76678814f46f..0d469b91377d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -510,10 +510,6 @@ xfs_ioend_needs_wq_completion(
>  	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
>  		return true;
>  
> -	/* Page cache invalidation cannot be done in irq context. */
> -	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
> -		return true;
> -
>  	return false;
>  }

Ok, so higher layers can set it.

At this point, I'd suggest that we should not be making random
one-off changes to the iomap and filesystem layers like this just
for one operation that needs deferred IO completion work. This needs
to considered from the overall perspective of how we defer
completion work -  there are lots of different paths through
filesystems and/or iomap that require/use task deferal for IO
completion. We want them all to use the same mechanism - splitting
deferal between multiple layers depending on IO type is not a
particularly nice thing to be doing...

-Dave.
-- 
Dave Chinner
dgc@kernel.org

