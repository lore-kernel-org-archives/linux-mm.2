Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDE2F44868
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33976B00B0; Fri, 10 Apr 2026 09:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1D66B00B1; Fri, 10 Apr 2026 09:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CABB26B00B2; Fri, 10 Apr 2026 09:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB0FF6B00B0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:26:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47C39C1D93
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:26:50 +0000 (UTC)
X-FDA: 84642721380.20.FC3D146
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 55E64C000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:26:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=V6MO+8Nf;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775827608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTNJ1JSJOuyCEAD0SD81iIKvib8YxJR83tAvZlBQ/uQ=;
	b=739XKfiG7ntu+gSsjcdtFJNwpxOFurWGMZ6qFBcs1F6bPATuDgYZESpkIq46kHe8b75S57
	QXvrKWPJAVucl/RpnlvY1kDzNQFYuWtVkZqR6eRX4ebgdI4fRfaZZ3dbJT/FfXfYrBQC8J
	dgbfRUViNHBTFlm0aWGAPORAeK/9uag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775827608; a=rsa-sha256;
	cv=none;
	b=y/HzGRArQsFlLoFQNCrUzTUb3q/sV40h1vr5u5JPUwJu6upZ5tQSlDYNwTyccltenhAswQ
	swH9O2qHNhiYJKqvqbujFRiLmLbnzUAge3pU1C+qY1sXq6xEujUnovM7bAbV4ZS3TS7KKT
	k9g82k0UlcBCn6bUtGMgt9HCTcf++mE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=V6MO+8Nf;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aTNJ1JSJOuyCEAD0SD81iIKvib8YxJR83tAvZlBQ/uQ=; b=V6MO+8NfY8Abp6Hg1tgXrze9Js
	djsU6gl19LWY3cKwYuDRL35dFJFmJT00E7aioJXLRKJ+Vy7zVBUdKO4B1T1M+4QO8T8yEQdcyx6yg
	e1nNGy3islw97egX0w+n0PQmoNwltLokKPWWwDbPT+myLcEH459x8o/ERgq1oS5MLg9lMuRUvOK9u
	HcMIUIsE6DgQRuB+6WBq3A8CZ11kORzn7u9oep2BwVrBWDYRo8koUx+1jhqWlEd8TAp6aNCDOrcnf
	CCy/8MPjnsZf9z+9ln7hzd2oZbUKuY81A3sPJXr2agjtxb//c6lCxRWGQ0WlSNlTMDkgA2NNErjYh
	kvCCO6uA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wBBsY-00000009QcX-1BPO;
	Fri, 10 Apr 2026 13:26:34 +0000
Date: Fri, 10 Apr 2026 14:26:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <adj6iibxNot-yc9X@casper.infradead.org>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-5-hch@lst.de>
 <adgJqiA0vivaW7NA@casper.infradead.org>
 <20260410061725.GA24667@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410061725.GA24667@lst.de>
X-Rspamd-Server: rspam12
X-Stat-Signature: awrxz7asigxqjmurhnifcnjeoyd49m5n
X-Rspamd-Queue-Id: 55E64C000A
X-Rspam-User: 
X-HE-Tag: 1775827607-993892
X-HE-Meta: U2FsdGVkX18/DBByMhhYHTJk1t34z6iMwwNOLTEQHLTaeTTv8rP1HQa57+OE4qV+jy2q8p7zriNjkR72CyliiRjGDeqUD1E6ruguoceQwltuUj4bN6jrPdaq9TOr9sJtt+15uH1+OlK+PjhLor82rZDbEcGsrd2QFXrdk8hQxYiWd9zsmiPqsJUwRF92IYgHW2ipnbwtXElAeb8vY52bBOZap+5RRDHi17t9aLhf4EjygfHJbaFw1fjS08ak2XDzQXVlyQ6Y33teRW9kwSp52sL64lWGG/ygVk0FWjVk8OQN5fQ7j6V4p+Iw+ttGTuHhgpvy4YlCG7BfvOjl/AiRZJTBKPnvC7DQWLlLmboQ9gIBquHSy2d1BYVTofcZs2jVltBDquWeQOixoLWY5EEO+PhSyAo01EAn20su4ceEsv19te4v/ets184ZruM9glwqzR6V9eFLJh/9CYm6dYc2Nt98TB+SrCee0cS1Tdx3t6BWni+DQfodPL2YxMQGvN9aou9W/sqB5sNLxR6CYWsCPVyV2YxLoFrKNTt2SrcrXGrzF8wYDpHEkBnkqEtAAbvxb0K3VjOfQy1OKGzY8oPGz/MzcXLAKkXnDjEsSDXzU142ZWRs0+WiHAxO/1dyQt1dEKh3QSTQvXBUH/3gA+jaXeabnccbAp7J1mbjySFFWv8OKTBdUTooSwbZ5aZjw8sAOls67lxvWQM/PegfHdhswk85gnaGlKSggD+w8/JfmE7c0gH/CCTgyeNXgmc9bhY9K6XrESP3q0M44+qmcJo21euvxcYwaRJfQJQayKjX0BvGfD1zxOJhCP4MNLjqglFgw/joCipOt3pjSM7H5pQjYccGIvWtLHw8Asd3tgdEUzjrIU+KAqwgYDBfIZkED82WnWbeUnp5xRmJHkd7HGl6/n8Drj6QmY01pBKKpM/SA4V5dC48FOLTwkyhI0ryyVDYE480OgvPKwwZzY9Do/V
 mgp4fFiK
 d9ETKRzZdrTkg602sxfaXaMQRCompWO3H6EmfTNHEHskiMz0/lhzO4GetyWfgsmI95pmSzD7wLfDrkOOwsvkcsq3ciwzjyqJSGntY3erJf6eeyjaTA17GU+lANzVfI/VoKSFPoiYzFETxTpgC89ESv0l2UUoW9aGZbNEx3Ao7B6My5n8sgUpPQBxvzWShNprmGhd6wRaaR+zf5B4Vo0gkLRFVAwrq4pa2f3VkdC3kH9bo9n4Ei5MKfAWMvgIOf+JTlE2r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 08:17:25AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 09, 2026 at 09:18:50PM +0100, Matthew Wilcox wrote:
> > On Thu, Apr 09, 2026 at 06:02:17PM +0200, Christoph Hellwig wrote:
> > > @@ -1836,9 +1837,7 @@ void bio_endio(struct bio *bio)
> > >  	}
> > >  #endif
> > >  
> > > -	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> > > -		bio_queue_completion(bio);
> > > -	else if (bio->bi_end_io)
> > > +	if (bio->bi_end_io)
> > >  		bio->bi_end_io(bio);
> > 
> > What I liked about this before is that we had one central place that
> > needed to be changed.  This change means that every bi_end_io now needs
> > to check whether the BIO can be completed in its context.
> 
> Yes.  On the other hand we can actually use it when we don't know if
> we need to offload beforehand, which enabls the two later conversions
> and probably more.

I don't understand why we need to remove _this_ way to defer completions
to take context in order to _add_ the ability to defer completions
inside the bi_end_io handler.


