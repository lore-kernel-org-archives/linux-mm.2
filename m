Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF82CEFB7E4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D24B6B0095; Mon, 23 Feb 2026 21:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CAD6B0096; Mon, 23 Feb 2026 21:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0CF6B0098; Mon, 23 Feb 2026 21:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBA2F6B0095
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:08:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA7D3C1AC6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:08:43 +0000 (UTC)
X-FDA: 84477716526.04.518BD4A
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86CD78000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:08:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zqlw1BFobQUAibvQ6LlwS+cvqPFQgskVd9csJFxsbWo=;
	b=q3YcEmKu5qNBR92uPEn5/pjBcUfSn9fWGmKSqN2nd8t/CjhHqNa0TOzAnm/Dqn7bRm5NLH
	Ab9uFAbLkgG83551C1tyFJ5Weqq3e64qhCrS2aSu4lTiyFGxw1DZSAxQtyHtfX1dvIPHuT
	0HPnIeoDlMKM80suR+YRivNllGzrSFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898922; a=rsa-sha256;
	cv=none;
	b=cHRs5HVa9gJXdC8m0PDJRV0ukh8noHyl2n2Xd1DYH8+q3ztLrrlRkOzYoh/oP7FLevDLRf
	Ik80krFmIH5gYViHtIDkKZ5hlPxTQSdEbS5DVqACSfZ8mLRnvYI5acZSmfQGSet1vIitjF
	N2tLtVhVwpN9CXQOpdm2md2BKP//ap8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 24 Feb 2026 11:08:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 24 Feb 2026 11:08:36 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Li <chrisl@kernel.org>, lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org, taejoon.song@lge.com
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
Message-ID: <aZ0IJOYwWHkjE5s9@yjaykim-PowerEdge-T330>
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
 <aZiKQwT7KjWDLspH@infradead.org>
 <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com>
 <aZxUtFaVaJbkAM8Z@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZxUtFaVaJbkAM8Z@infradead.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: zigwhu6ph34ugfj63anjnhnd8z8trrzz
X-Rspamd-Queue-Id: 86CD78000A
X-Rspam-User: 
X-HE-Tag: 1771898920-453946
X-HE-Meta: U2FsdGVkX180rw07YWjN+YylWSGoKrEPeONAkt0Sa5JLgA59MdGcOUhQaBA/Sn8EnItSBvI0ewn6lc/dgwa097YwQEH1D00khI62AqJjs49cofdTDFqhcBEl9RpT//Il3Vl7VPqSH+YjBiabW7dVQWkkbirk0Z1pEVrM2PgLk3akXuByIRlN6eQrKNP12BWWnRS34/dS2ro0p4DBXFb/+v/9LS4mpBh7i6kiR730wr1EcZiaWoO3McMz5lVdr/jN2lwhsKEYeXar6PSoKzmP64PCRy5fKQUCdHHCfM0f6hrag8pXhPMJxC8GXwQuXJ42FQxq1hTDCflJ7MjrZqSIOhd+vY6/y3FrWXhF4q7WOEO6hV0ESzn3yFS0faz99wqRKGVxNQkgqZcNXNhQcnHzYnrEyp0IsGs54QvoyxHsYl7AFIbOeffNSAMtmM1ENSfMnJOBLgrP4vIxNYY/gnluvoq4nan0HIrks2Vl3uun/6Sa2yS6i69DpJhltaJXvXK58sF75gmB5HEVDS+ftzZ4O4ZE2vwWm2mCW8eUPgLakXOqN2XFKlaUq6z3kVfHhZVLzLBbeW8z2SLX4qvFv5rfFAZ2lTsbdpdEwKBUBdEaZpY8bJLJGXgINtV+R4/+Z7A+ID+9eoKKkdaAjoeEH8wCgwMm0SGRSCHt8YaJirJ68qgp7ZvoEv7z2I3XaoQu9MkM2SfzicqcTkhFHPIkU0Ub73sbyfHky2Ok+Gxy1aOinyOtqBLdDMfSk6wuui0N1RszzVmQFhUsojWiPo8gaUs9gcq3d1jL6rlW7u+TQylRYu5a6sz5s9W4wfE/i2e2RqWZ/yXdalqYr9qpW19+voJ4xngWFy5F467/W3WyTR51FEi7ffd2OxH/ypQrbghF8s1XyZwxI3y4n6Y+I6i2XMkN9C1veSwTt/mpyfgovjWyG9G1OxEOMiK/s5llJdsGkwNbOC+q2FfgUyIiShvi7dA
 L1cK+68a
 lxTCMmZzwYaCfnK/Ot0x1G1wQGOiqAMbNrb6EORtm9/7iyBEjaifEd8obgInlItu1orkNh48ISHDaqCzs7G8yhsTAch08wHAwJ+a8yRdpl6qYsPSUochdmh93QCZ7SX5L1xk/BQU5ob8WAukhrFKkwMP6u8QoQFYnvqhX747ZJgCOIhwrPMXxTNbehkE4ngH/MPXU53EdAKgJgGdJjJu3lTOAc44VokKXtAd1sNBd6gvc/JpkxyF05AVVbp7i+iOF7BrExbVFIPE7CeRKm20EIXLFdMUNVg1HRmD5vYEYR7cTCWdjvsT8lC93x3LTOCAkJpdt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000073, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 05:23:00AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 20, 2026 at 03:47:18PM -0800, Chris Li wrote:
> > Hi Christoph,
> > 
> > On Fri, Feb 20, 2026 at 8:22 AM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > Honestly, I think always writing sequentially when swapping and
> > > reclaiming in lumps (I'd call them "zones" :)) is probably the best
> > > idea.  Even for the these days unlikely case of swapping to HDD it
> > 
> > For the flash device with FTL, the location of the data written is
> > most likely logical anyway.  The flash devices tend to group the new
> > data internally to the same erase block together even when they are
> > discontinuous from the block device point of view.
> 
> Yes, but that's not the point..
> 
> > It is easy to write
> > out sequentially when the swap device is mostly empty. That is how the
> > cluster allocator does currently any way. However, the tricky part is
> > what when some random 4K blocks get swapped in, that will create holes
> > on both the swap device and internal write out data. Very quickly the
> > free cluster on swap devices will get all used up and that you will
> > not be able to write out sequentially any more. The FTL layer
> > internally wants to GC those holes to create a large empty erase
> > block. I do see where to pick up the next write location can have a
> > huge impact on the flash internal GC behavior and write amplification
> > factor.
> 
> And that is the point.  The FTL will always do a bad job with these work
> loads.  You should not do overwrites, and can do much better
> optimizations in the MM based on that.  I'm pretty sure YoungJun can
> explain all what they did.

+CC taejoon.song@lge.com

Yes, relying solely on Random I/O handled by the FTL does not optimize for
the device's lifespan.

Sequential writes at the OS layer are what create the optimization for
lifespan.

However, if lifespan is indeed a critical factor, deduplication is needed
to reduce the write amount itself. This is another key aspect of the
proposal.

Regarding Chris's mention that overwrites are inevitable, I will address
that part in a separate reply to Chris's email.

Best regards
Youngjun Park

