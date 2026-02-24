Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B29AEFB7E1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39FB6B0093; Mon, 23 Feb 2026 21:16:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4486B0098; Mon, 23 Feb 2026 21:16:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11306B0099; Mon, 23 Feb 2026 21:16:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A070B6B0093
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:16:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AD011C35A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:16:01 +0000 (UTC)
X-FDA: 84477734922.24.580F2DB
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2773740003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:15:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771899359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/avfrtrNRMuwzZnsvZIF+DvIG1+FnWuDGxgHz4gNlok=;
	b=feNoUIOPS2wF+iH8/5qUyvKob0Sd9pRgYN9IDwjb+pnRSqrr7Z/LnRhemPiHAI2X5iLovb
	jiX2z0JwGhfA7Jx5slKdIrBxL3bSAWBmmP7iTYxBhFRf66z87I3Mp4p/AWJnT3pnj3DV5K
	ocI9+9GqNxjtZu2DzOxRwpHCAzOuzzg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771899359; a=rsa-sha256;
	cv=none;
	b=5r/aE9qee7R2GduZH8ET2Jaue0zLaN349eRdFOmug3738nR7YIkL0Fuopfbg/J8B/xd1hJ
	okwFaWmXGxvwGU3MyDyYKJvFBRNgg1XdhxMgRpuOTaWWWzU9TSRfhVPLd5VfwU++9ZAqJj
	RxTfKIaOsN+pj2b5hswJNR0CMgJJtX4=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 24 Feb 2026 11:15:56 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 24 Feb 2026 11:15:56 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	taejoon.song@lge.com
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
Message-ID: <aZ0J3KBNOr3xnTja@yjaykim-PowerEdge-T330>
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
X-Stat-Signature: d53d73gis777fpkxzxzqnthqwkiz7r1a
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 2773740003
X-HE-Tag: 1771899358-395652
X-HE-Meta: U2FsdGVkX1/wM6UQeR3dyM1zE8HIELKX6SDW44zq7Vkjs3k3XhIpqmScbmD7vpl6+Rv3a+Xv9+nbgipIENo9I3O97CIyk33ATl7OdNRWM5kzkVHrRUm5E2vbIAotyt5LVEplM6MkFbIMEetAtCKk9ernF6mwNBRBeGpOTbDddKP+id5Tz7edx+EXHQjFnvCxppM3S8trNAxgJiPvT9cEXRD2mTtzkKOc33AKmuamgDCM373i8KQPclcpt/ySoRFCoXhYFy2XOLM/gC0JsMAw5+TFg5kR+zKuu53SCT6HoCkMJBzwpiPl9MBo9oyadvyIe6JANLdHgaMCPMYG2Lzk/Sjv/i9Gmy+w0RX3MMHApDL06VvnswIUU2ccoFjT1kLVjyH2Qh3YManrkRkT7Ob/KXahnWnugo2acegvwz2bsugakU1dKx7qve+LrAdfgpuh9XSbdQgyrt0jK40cHNJhqkDJd78OGeeHuEJCjO5hvAdrcHyGgaTiToQZ8Z2I7c56amWQ7feapF5TMhMB/iDubJooKT/GmLzT/2mSfNQW4wRXG9xHL3pO/xwyvN+hqsf7xYIxjJ2i/0hD6FmvB212x0Qezn/C/IH7L1NBNl7miR1tGYEezz1vAEiojFcEjT5eI7nCh6gyy4EfUvnmkcWeOskrDx+bqxwoqKFcy/20nmjYE4o1zZysGS/8XH0eWn/4Sicok2GUqiIqUgaCx80jeNVGRxv4rEjrkkAPNQN0XFuIH8155SZn5J9v0k2zQKca7YXJfn6H4EUcMeUdN/NqAIcMSBn5Vp8xPkvER36exUsju3GiK5FtEprhIIyqfv4ae3p70TS738Eyp02/5PG0XchLyJLpNUWbZbn/fjQfzjd7TqqVVR63hw==
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
> 
> I think if we gain insight into the FTL GC behavior, we can design
> swap to be more friendly to flash. That is why it is great to have the
> flash storage vendor provide some inputs. Some of the optimization
> might be vendor specific as well.

+CC taejoon.song@lge.com

That is correct. Eventually, holes appear as clusters are freed, and if we
write sequentially, the clusters will be exhausted. Therefore, compaction is
inevitable. There may be various factors to consider, such as FTL GC behavior,
to optimize this process.

> > optimizations in the MM based on that.  I'm pretty sure YoungJun can
> > explain all what they did.
> >
> > >
> > > > would do the right thing.  So please no conditional version that need
> > >
> > > I agree. There is another LSF/MM topic related to this, the plug-able
> > > swap ops backends. I hope that the flash friendly swap layout can
> > > implement the swap ops framework without conditional versioning nor
> > > stack block drivers.
> > >
> > > https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/
> >
> > And it should just be the default block device (and maybe file backed)
> > swap.
> 
> Let me repeat what you are saying just to make sure I get it right.
> You want the flash-friendly swap to be the default block device swap.
> How about zswap and zram swap? The FTL shouldn't play a major role in
> selecting the swap location. I am not sure it will be the right
> default for them.

I would also like to hear more about this.

Best Regards
Youngjun Park

