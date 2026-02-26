Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FFBFD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100CF6B020F; Thu, 26 Feb 2026 16:12:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2AB6B0250; Thu, 26 Feb 2026 16:12:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26D06B0251; Thu, 26 Feb 2026 16:12:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF80D6B020F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:12:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A4301A01F6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:12:27 +0000 (UTC)
X-FDA: 84487856334.12.48446F5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id B2C3F8000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:12:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lgkspXoZ;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772140346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxjFK2I1rFqs+rF+S3xFy7UtO9xYKfa9VhNCsIXi0UM=;
	b=osS742REKnvfYmmn4SB+943uxRfHJ71d0m+6WTwt+VwD6gJEPM1/pPtvWUdTCQqPCZKvTL
	m74zasTXHpx4JzNsGbm+67WBoE5hId6qupkn8B/djBgnF3U26f/MrGaNeB4b1cHYeawusd
	kimGmAVUA3jnLTg8DLX/BGYsmolAXp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772140346; a=rsa-sha256;
	cv=none;
	b=hOXU61aSXsZwME0jPe4eccHKNPqPljzl+M/WrjdlE9hpQdG1dJ+yuB2DBxeU+cra1bU/MY
	1C/BrVkauIxaK+PffgyOrwk2xw0XXZ7eMqLvUmhnLJPsxnlQNwdGUy33Oa3iC5nrCvdCE3
	hCwGaR2eX42OZFiH1Y3hvGQgDJ0eMmA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lgkspXoZ;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cxjFK2I1rFqs+rF+S3xFy7UtO9xYKfa9VhNCsIXi0UM=; b=lgkspXoZtskd+nEFTO7IHEtKtY
	QTWQeCvLBoCUJsiEPlwCe6SWhlX4OpH4sfIcf973/D/KHKtxmL7cdhI6EVPhq+88YezeXjnYeF9/k
	lTBC4JUAHiw0PjPxqQDKyXesl0LB4Vk4iaFTKfzl2Tl3I2RHXTu5RqbQRomZRKajicLkxk1Zc3Cgl
	EA9AE9Aq8Dj+/BUR9USybQncuYrIbgeNeLca3LgZvkDQDBJlBeBiGdrYoUnF5XrvaNGooNpTfJR43
	oaTeNczWoFDSM88QQWW6khDtS0804E+RmfZTXk4WzycI+T/ry+ky6kMNEO4z3lOlB81Jk2mHVpBQg
	Mtjq8aOQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vviec-00000003Sxg-0gjd;
	Thu, 26 Feb 2026 21:12:14 +0000
Date: Thu, 26 Feb 2026 21:12:13 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tal Zussman <tz2294@columbia.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bob Copeland <me@bobcopeland.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
Message-ID: <aaC3LUFa1Jz2ahk3@casper.infradead.org>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
 <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
 <aZ-2G_6lDZePLSyx@casper.infradead.org>
 <44e3e9ea-350b-4357-ba50-726e506feab5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44e3e9ea-350b-4357-ba50-726e506feab5@kernel.dk>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2C3F8000B
X-Stat-Signature: auzsj3r5xhf7ea5479c887zzkjj3yp43
X-Rspam-User: 
X-HE-Tag: 1772140344-111855
X-HE-Meta: U2FsdGVkX19bOmSBbAK8Izjw8n/OjwEvwhDjJFPZWs/X3eFasaLG/0CbNlyyw3eQe99G0I51Oc5Q5aMlcAZIkdFDER4PNjx57th+kiMJnFFqJj/2+3olfOUh6FjspFJLb8nIr9aSDMxzJCy4XhspkCoNdTVLVBj/Azosrqj4pS4EN0IpJcfkknbyIroQWLKpWXaUMzGjoV7hvfRRyMA1CPezmUPMuhThbrFzFrFzZPcvFHlR2dJ95s6nP9tH93uI6JWayV/NoXhn6pnLLOO4lzRxSQOs1t+VM6D9HYkEv5Bg7UkqeaNKH0iE/CeFZ/9Eed/TuZb2yg9OIGHelMvWR5kWASsbjTM22uYp1w/Ycu4RPCGKgyp+LTHPEZUPchFbGKlMAsM8Ul77aV5foly/Y8oDgcRsw12C+58JrkByktiyPDXToTeU9V7B4ZsYZRuV1QbFmAx0q/QhlILiJohFcfMl5OA+nRDC+N0Qboj4Yp7nkRI6PSt+Do+KzdKk5NK6FyWsPb8r7f8RJ1DG/Qg3ciKbN7AsiLGw0YAStyKDOYdVtp3b3uyI2i3KHeCidM0TOOA8Tq3AXi04D7/IfZ7eJKGevrfco9lnNersYokUwg7bOoLdwYgRBitjf4SHp/VC+t5XTB+NtysTV61nrif+rSW2R5pAjI1vs2H2WgGHzvUUQQRbNtHmfXqccapR3eLK1HlQG13VSdCvDzVknHw+16X7mPnRrhf4hJdjvqPOKiUnCQLGpvfqYSOQyxzBbuOtC3Am3V+Kph4mmLGUuWsoDDCFhWt8PATw2889+PtkOrX0xT9mQ/JxpZNTM8P5eyRJdVcWpWXWFdu8jSGl0u8vos8xLQ4g9IxmR8GlzD7nAFXZfsrO7ygnzowtwxnEBgp9dEoN0vxH1yUD8oTuyoMvr4JOpTjTvcu199ouPHBA+OSRXNAkUN5dqmaIJgKHUlwHFxNF03HXgHnOUODgoWv
 Fyo6NEWq
 eQQo4y7Vd3I7t6KSpeddLkgE2OFL/hLmV6+9de7aW6QuriZEJpiyvr+PCkAQ/Dp1P0Ha7bO55jDFuRXJcFrIzJER5A7tA4axv50i/a5W6jYOk4oy1TOjNk7DcQ49sOZRfPpjrxQuOjEsPTeNB8bsX943hFp6yuBkLGnOQtnoLckFlW0aTJ82Q1R6ozDc+BWutsvs24RXGBDwSBBQpPR/rVc6U7+c6csvyRgvmc27Q0JHxzVmaRI3s7ni5xVN1CDtOrjcRb27iCpKVw54/BXSV4wqVADRbjXn9Lci5mR56vFZkEehWJuaPbX5nWrENyX/7mytF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:15:28PM -0700, Jens Axboe wrote:
> On 2/25/26 7:55 PM, Matthew Wilcox wrote:
> > I recently saw something (possibly XFS?) promoting this idea again.
> > And now there's this.  Perhaps the time has come to process all
> > write-completions in task context, rather than everyone coming up with
> > their own workqueues to solve their little piece of the problem?
> 
> Perhaps, even though the punting tends to suck... One idea I toyed with
> but had to abandon due to fs freezeing was letting callers that process
> completions in task context anyway just do the necessary work at that
> time. There's literally nothing worse than having part of a completion
> happen in IRQ, then punt parts of that to a worker, and need to wait for
> the worker to finish whatever it needs to do - only to then wake the
> target task. We can trivially do this in io_uring, as the actual
> completion is posted from the task itself anyway. We just need to have
> the task do the bottom half of the completion as well, rather than some
> unrelated kthread worker.
> 
> I'd be worried a generic solution would be the worst of all worlds, as
> it prevents optimizations that happen in eg iomap and other spots, where
> only completions that absolutely need to happen in task context get
> punted. There's a big difference between handling a completion inline vs
> needing a round-trip to some worker to do it.

I spoke a little hastily when I said "all write completions".  What I
really meant was something like:

+++ b/block/bio.c
@@ -1788,7 +1788,9 @@ void bio_endio(struct bio *bio)
        }
 #endif

-       if (bio->bi_end_io)
+       if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK_CONTEXT))
+               bio_queue_completion(bio);
+       else if (bio->bi_end_io)
                bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);

and then the submitter (ie writeback) would choose to set
BIO_COMPLETE_IN_TASK_CONTEXT.  And maybe others (eg fscrypt) would
want to do the same.

