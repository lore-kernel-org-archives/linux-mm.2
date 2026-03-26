Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610C9109E53D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 02:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCBA06B0088; Wed, 25 Mar 2026 22:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C746B0089; Wed, 25 Mar 2026 22:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B924D6B008C; Wed, 25 Mar 2026 22:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4BC16B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:44:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35DA3BBDF2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:44:19 +0000 (UTC)
X-FDA: 84586670238.10.5EB97B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8B43B1A0002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:44:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uA9xM8Tl;
	spf=pass (imf19.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774493057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M142TV5/pcvb+3JInf5fP0CHCG1jMozjA6zC+4eV00E=;
	b=OiDMjM0BjRNQASOg+e2ycGCam8P6gAdr6msQnxFT/6Gdj3L1Dnj+O6pHVN4BlN9hBF0kwj
	aODYll7BfnLQjmXIQ2nnDhl7M7OMQis8bF9UaSiFeGrSyeHWx23ssNaZA2G21fvv9JtW0P
	3zje8UnVc7sD4KWavahAF3w77AhJGqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774493057; a=rsa-sha256;
	cv=none;
	b=ufSkPytW/If75YxulOjFM4MGbEpOUPfzFIUflzateFKn95VvUI5HTRE4SJXXEFyL5cN+/5
	BYTO8jwOsnC+tGeLTel6m93yT18T9p9poHfnfZnz0H15jLQ+UxVctvQhVANNE2kXxjfFY7
	Y+9km74GCTT1G8qQoun3CA2YARQVXLs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uA9xM8Tl;
	spf=pass (imf19.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5633C4063D;
	Thu, 26 Mar 2026 02:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1330C4CEF7;
	Thu, 26 Mar 2026 02:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774493056;
	bh=LrDa74kusD0Qs5ckOdznuE3nf+2ULrBRJxIuPhAify8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uA9xM8TlDA8Ri8x9xtA0d+L2RRzbXKmjjjzhGNTc1Xmkp1rJJZvxU+MF5rSM4+e2V
	 LyjN8vd5EhgmoQU54pxXJs5H39ssW6qbiajuGgeXnKnQjVWx9hGcvOS+CI0010hwhy
	 RqcCkc2gFnywy+C38Md08UQ3eg1RgGoV+dyeC+S86RzrUYav/qJYTLzZZEE0ciByZa
	 RBN80Boij9Tox2W52kPQxb7EWFazDbYgc3I4R+JQHVL/7EMIgzXIf4TgeUkpys/6XE
	 Kqn1gOvDx87rM/a8YeY+Ka8fp83zg4DnvbrjWcvtKrztj+TPHLcp1Nw9hAFLWZPJ3s
	 SKICNvt3skN/w==
Date: Thu, 26 Mar 2026 13:44:03 +1100
From: Dave Chinner <dgc@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acSdcwclPGXLGwBx@dread>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <acRE8pp6HxjK7Z74@dread>
 <acRH-fWPKkFFXcLZ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acRH-fWPKkFFXcLZ@casper.infradead.org>
X-Rspamd-Queue-Id: 8B43B1A0002
X-Stat-Signature: 1fm5eeb7kj1eoxr5eeun76h6niux3qi4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774493057-333736
X-HE-Meta: U2FsdGVkX1/04rHILqZ0uhV2Lo5Ey1iCFcaOTHwlMPVFPX7ubAH4Zy/W5ujrSufzJvzUOaJWrnSw09bn8iyotkUDauXa3jj1pOwyrkv+HTWw54AUdUJuiKxoRP3FHeVj/3hSNSQ/Idygc8UUoQGaW9YkJEDoKj2IwQC8DNMVW6S5mGe+PuslDAMPEFSWrkjKgER40jQbWccrBX8PGTDoTbQHmu3afA5k415tgPMxHJno6ZHGlD7YT0uJZdtvMlBa/1AU63P4anWi8L4CDryCl3IPuLyRd8xsSVyEOLl+HCmJTUZYuUPxwS05b+ikC2ChUGNFye6juqFAep6+9jmA14rZs9O/rnHV5BT5BQOMm7ULHvn4Bwkc6FORGp1PQ5on+HefCiBSZvfhjhcEZrX9mnsWq1cqLfC0NoX3m/tOdGAKdI+OgfZPfx/ZdSDkBqdDDK4yRzfWlE48ib5dqvL+MSAvrlx3MCVlLtkEJuhxFQdvtI6MB+0O2pG4+zB/ZDKIpGs7DEMUWg4ImBteWGd4C6/z1+lKHKsmgqO32Lcxy0FjgXBPiX/E/jzsmb7Un5UCHhREcifvxTI2xg1RWZSSjWQahuZjfS5SnGr+PNbbF8UPo8W/qm2+xqZlCx9kiyT5G0BnKo+WtIG8PSR3WOm7pUR92AvIK5eYEinpqopKefrPuO9HSqxIyDkgsm3xrGVtqElLwx+2SSkQ2QOmajPSPqwSuXgBDplaJD30V2Z3Chm3j7UYhgZ0o74d2XKlU9WBMhBqludnVeiqHYUAIHcM1fHGn6UtIfeq4zFA4FHQkE7wzpxGeH1mycPOgsPvnv/Vgjn53xIU5ddUe0pcidbnUshLZPHGfNvIs5I6nNjTK7QXC7vJRhH1/qr7v8/UjmNV2BzOVRxqoVdvG/TDMKGm6/rjKRF4vPbNV67AN/IxwGudxNt50QJuQcJdeua3U+y1Cds/ZhK6HPr7/NfQV2n
 uzd8zlpP
 NSJZDbNl9ptMJTbH49mLHVy0eo3y3TTz3ZnJ5Ng4vCGU+f+l35TFPMJPkG5yjr3Ahr3prs/fUkyo/b8cjrVLrz4t9vgPEVLkZu4+JMuyK74EXBUzeAapkkpHXHKI2lcxWqjlVr6yBRGqx6VSg+OyESHWGnzFsKJJG7EySz0ghHjBG6ul6L13bbdIWivxRGHz+opwWHHNplUiJ+TArXGbytbGTffZEi0UEmLHriNW1Pryq1nRsbP7tDB9s23oKNK0MDJcxZaz7TyFnOPSbJMJLlOB6uKQinLoKwyJJ1wntobywbe7mg1ka0gb0xZVNxwy99kz/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 08:39:21PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 26, 2026 at 07:26:26AM +1100, Dave Chinner wrote:
> > > @@ -1988,6 +2060,16 @@ static int __init init_bio(void)
> > >  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
> > >  	}
> > >  
> > > +	for_each_possible_cpu(i) {
> > > +		struct bio_complete_batch *batch =
> > > +			per_cpu_ptr(&bio_complete_batch, i);
> > > +
> > > +		bio_list_init(&batch->list);
> > > +		INIT_WORK(&batch->work, bio_complete_work_fn);
> > > +	}
> > > +
> > > +	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
> > > +				NULL, bio_complete_batch_cpu_dead);
> > 
> > XFS inodegc tracks the CPUs with work queued via a cpumask and
> > iterates the CPU mask for "all CPU" iteration scans. This avoids the
> > need for CPU hotplug integration...
> 
> Can you elaborate a bit on how this would work in this context?

It may not even be relevant. I was just mentioning it because if
someone looks at the xfs_inodegc code (as I suggested) they might
wonder why there aren't hotplug hooks for a per-cpu queuing
algorithm and/or why it tracked CPUs with queued items via a CPU
mask...

-Dave.
-- 
Dave Chinner
dgc@kernel.org

