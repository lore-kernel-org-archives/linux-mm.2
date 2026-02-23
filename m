Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273A1EC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B586B0005; Mon, 23 Feb 2026 13:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4190E6B0089; Mon, 23 Feb 2026 13:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED666B008A; Mon, 23 Feb 2026 13:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16D116B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:53:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1A0057946
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:53:18 +0000 (UTC)
X-FDA: 84476619276.15.A098894
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 57FE11C0012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:53:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L+w5Kce1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9EOx8Pr+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L+w5Kce1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9EOx8Pr+;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771872796; a=rsa-sha256;
	cv=none;
	b=jkKG0HjhW2aNEpJQGtRKCeU3s3gCTee6nej1suwnZ+BrgewlGB1/NeIyFpBfaf+Qbr0Gai
	IuHnEb51/IqT1YnmlABLEBpP3Z/+/iPqNXNJ7Zk87QwvYzrTfsBtdE0q68dyM2zkfzLN3p
	4laAVhwKVR4Mlqkbnnzmq7p/7lKhMzE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L+w5Kce1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9EOx8Pr+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L+w5Kce1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9EOx8Pr+;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771872796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5IKO/z1H8Y7JnYsBwyBZT2Ey2CvL7xnIixrsqqWxhA=;
	b=NaxFUM0cACAjiTZ1vuy/7qQHSRXoJgpLaN82EqxfUPxRyCZcO6oOY3fGT7WDrWQHtE+uwB
	exEDn8PdrOAcH7VOPjof2bG7UaA8wFd06sjNAG5j9nRgTyWM8/h6P4NJKK6SRemnY4b2Vm
	UYtiY2WdxRpMdPooC6Cn7MKWrsxC/dQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8FD2A5BD27;
	Mon, 23 Feb 2026 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771872794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5IKO/z1H8Y7JnYsBwyBZT2Ey2CvL7xnIixrsqqWxhA=;
	b=L+w5Kce1AzQA4e75QekwbZKTG9XVtsdJjtOG3wHEn93OeZlxUpsY/FsRfKMokJilnJ77PG
	59roE1lcPpC3hAO5YhcTvGeTQYjYHvDVkIOhCk/kEPqMdpyPfRPKwSa7Kn5F7ZtIxN8Sdg
	TrTPGgW/egq+XiDCgjEpRDhTkGxQHs4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771872794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5IKO/z1H8Y7JnYsBwyBZT2Ey2CvL7xnIixrsqqWxhA=;
	b=9EOx8Pr+Rs6qgrD5NYATs35vIZFfN3eo7z+yMGBk+IVJuepaet6tbA/7meP7KvbYSrd8pZ
	gfTHLO2kMuEFlXAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771872794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5IKO/z1H8Y7JnYsBwyBZT2Ey2CvL7xnIixrsqqWxhA=;
	b=L+w5Kce1AzQA4e75QekwbZKTG9XVtsdJjtOG3wHEn93OeZlxUpsY/FsRfKMokJilnJ77PG
	59roE1lcPpC3hAO5YhcTvGeTQYjYHvDVkIOhCk/kEPqMdpyPfRPKwSa7Kn5F7ZtIxN8Sdg
	TrTPGgW/egq+XiDCgjEpRDhTkGxQHs4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771872794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5IKO/z1H8Y7JnYsBwyBZT2Ey2CvL7xnIixrsqqWxhA=;
	b=9EOx8Pr+Rs6qgrD5NYATs35vIZFfN3eo7z+yMGBk+IVJuepaet6tbA/7meP7KvbYSrd8pZ
	gfTHLO2kMuEFlXAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F85F3EA68;
	Mon, 23 Feb 2026 18:53:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rEQrBBqinGk4CwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 23 Feb 2026 18:53:14 +0000
Date: Mon, 23 Feb 2026 18:53:12 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	YoungJun Park <youngjun.park@lge.com>, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
Message-ID: <jvbthrkxombekk4bbmdqrwvik2qnd5btafb6q7guimxnioaqom@7kjexmbfuzxx>
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
 <aZiKQwT7KjWDLspH@infradead.org>
 <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com>
 <aZxUtFaVaJbkAM8Z@infradead.org>
 <CACePvbWkGk5Z+QueOBNCdrr1mzGxQZbRbfeskOrLsmWEvF5ToA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbWkGk5Z+QueOBNCdrr1mzGxQZbRbfeskOrLsmWEvF5ToA@mail.gmail.com>
X-Rspamd-Queue-Id: 57FE11C0012
X-Stat-Signature: gzi7hytz1i6ycbut5p8wun5q7ehb5x3f
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771872796-232576
X-HE-Meta: U2FsdGVkX1/44O4LHJjZbqF4xgLEFwPRNQvwHbHi8dhcL9Nvp8RRwjmmFzpmhw0GaP7b5M8u5ckA33z0/MJaxZOWa7d7R6tUQJCtKscHpIwewxfmO04TmBGWwzIINk8880S9pJzpg7Ig7okBn1a1DNtiLMri0ji5U6TWu8bCRg+abcGOou+kR2BTR1QexLs3IWHAxV/Zs4gwYFiEQ9jq9Luz6zNuv2nCk3iDLL1uTdMw/LjNq3gTnOX7cKg50PjUJISMCQcRf/XmXVTLmsV+PStcSQMfJVJ4JU4FdEqrE3MJs8Xz1uPu3ooU3yzJdRyT0Zgi0GRFcXg+0yydtR9tvrDnvbl0xLArannEkDttUwYWxCDrqkpss+4jdliD7YJjyPC+XX46MvzCTJW10/wAjcC+VuOXD3Z5+ZJJ2deecYV/s+2rQgs9OD3jB+Dp1rn/AZ2e/zAvipywVCrpW/SLGrUwe7Z+7ZjViEj2x6Zc1uZNto4tnlL8D6DsvmAaUzeu286dufTT6cyQm7LjffM9RKwm7CVz0CH7ALvFSiaI1phbCWVP8Dh1rSpJEdHOUMhOZwmusHqmnnRny/T8C23tB09hBWy+Y2KdiDw6G50fO+rGn+ghCwuwRkk7xwSlXiPAwxfxbn6YYo19cTUTTUMKAupx3YQrhYJPav4kpzPtW/0EWGASuVHcSldaUC01N1IcysB1eRHZieOC36+5VBSFVO7SBgMJz7xblCEJR6Jse84uKSZrCTUEPejBPwmYrPhWK3jOm4ZBvIAZNew/qxmL3iIGd2XCY5n6EIMH+E1MYwJ8H6Pi7y0w4/jJwBc5ntkpM2lhm5jAwjyxWnML82Hw4BW3/NBM+Bo0iPHe6nYCtHjdMUfrBkfrPpAle8oqrcc+YUBoWhbtPQGTTAkYfVh75aH9HZeiunbTLH83fyAFdBU+F6+Y1wlRNpJ3JqFucTsCr+ry4vax2dt2guvIXuj
 CSFrV+C6
 pSe2IHsyPv3psCQP4QhMrs2dE2pDTcS5f/FVk9xxflB7AAHvebfu/hqbNpiFI/9jPYT39W9v73E9hmL6JLTa7344cq9j7tBiylDlDjzAXcXVtEh0A3K6LtSDkd2KieIYDCr5VQlGHHCB9cOBJpLNVzT9dRjUHzU+yZTkJFCmS/X1SJEw4UkUASiEKIhxNSJxEbiH81ddESmY+QTxhi/DGnsl7p524v7dYftHztV75O+dGGWAptN6IwcAZnmiul4GOKKCf2ioWvIevKg7B2UuDoHRyp6PUN1ZzovZhCJ8QaeV4ZDaWXvE+x3scW7/y0msP4W7MvW0rOa1x+S38D88+KVhnahUvDzW6V2wdi+w1glkfkKdvjFW0GsT3pn98Ssej9KrW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:15:14AM -0800, Chris Li wrote:
> On Mon, Feb 23, 2026 at 5:23 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Fri, Feb 20, 2026 at 03:47:18PM -0800, Chris Li wrote:
> > > Hi Christoph,
> > >
> > > On Fri, Feb 20, 2026 at 8:22 AM Christoph Hellwig <hch@infradead.org> wrote:
> > > >
> > > > Honestly, I think always writing sequentially when swapping and
> > > > reclaiming in lumps (I'd call them "zones" :)) is probably the best
> > > > idea.  Even for the these days unlikely case of swapping to HDD it
> > >
> > > For the flash device with FTL, the location of the data written is
> > > most likely logical anyway.  The flash devices tend to group the new
> > > data internally to the same erase block together even when they are
> > > discontinuous from the block device point of view.
> >
> > Yes, but that's not the point..
> >
> > > It is easy to write
> > > out sequentially when the swap device is mostly empty. That is how the
> > > cluster allocator does currently any way. However, the tricky part is
> > > what when some random 4K blocks get swapped in, that will create holes
> > > on both the swap device and internal write out data. Very quickly the
> > > free cluster on swap devices will get all used up and that you will
> > > not be able to write out sequentially any more. The FTL layer
> > > internally wants to GC those holes to create a large empty erase
> > > block. I do see where to pick up the next write location can have a
> > > huge impact on the flash internal GC behavior and write amplification
> > > factor.
> >
> > And that is the point.  The FTL will always do a bad job with these work
> > loads.  You should not do overwrites, and can do much better
> 
> I am not sure I understand "You should not do overwrites". Can you
> help clarify it for me? Let say we always prefer to the write to new
> clusters while some swap entries has been free. What happen we run out
> of new cluster to write? Wouldn't we be forced to overwrite the
> previous free swap location? It seems to me the "overwrite" is
> un-avoidable if you keep swapping in and out. That is the part I am
> missing.

See log-structured fileystems. I suspect that's close to what we want for flash
storage swap.

Also, FWIW: the cloud vendors have fake SSDs that while have negligible seek
latency, have extremely low IOPS values (e.g AWS gp2 can do 100 IOPS on its
base setting, and scales up to 16K IOPS. gp3 can do 3000 up to 80K on the
maximum size). I suspect swapping on these is a huge slog, and we would also
like to write out as much sequentially as we can here (though I hope no one
is *actually* swapping on these things). Also mechanical drives. Log-structured
filesystems were originally invented for these too :)

-- 
Pedro

