Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D082BC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 20:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BF76B008C; Thu, 20 Aug 2026 16:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED006B0092; Thu, 20 Aug 2026 16:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629856B0095; Thu, 20 Aug 2026 16:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 366DF6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:50:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95ACD1A02C9
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:50:47 +0000 (UTC)
X-FDA: 85122841734.02.A668C83
Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6E85F20006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:50:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JzHmwZBI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787259045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+ApmsN49r7CnTdDt803rEDqNaxSGgA+seyZRy09FII=;
	b=rOPDa2ryfG0Bk2JmR/n6HfRGSzKNHua5/NZoqmk2ejonJfYwiMVSWTp+phBFbc2k/SR/Bj
	xOWY0DZwLTZs/nNRSjy5fyOgsiBogLbqYh0/DQbqsc6vxbhdNlYhuTXpAu5trDn/YY7IW6
	iWtLWE6N83lGXQabUSIx5gjNu2obgwo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JzHmwZBI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787259045;
	b=Q8bftLIO+puapLonO0+8GfPJs1G8Yze0nvsgDEKTsbzBDk8Tsi8VAPEPEGr9x4HrhMTuDE
	NYt/5WNeoRGrKvhMPGH2cIMhCFSAaWKlWkSlnoCnv2Gzb7OsYDhSTLB8oOTPVPdg9SNISs
	VdrQ55LovGbTpEapS0f7820e6fJav0I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bgao8UUlLwR3L2Hf0JMzgYCzD6M4KAHzBdfc4Ha5bi4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787259043; v=1; x=1787863843;
 b=JzHmwZBIj+Um868gpWn8rpP9UNELl5zx/TekvBNIa5f6jEmz68v9yHiiH1OC9N5qFCvz3vJR
 oWIb+XHKiNs2qpXNhVa52GTt+YUzBmX1bcotfTRHkoj68CkvgD9suaCucPVGKiFX2ZfizK6svZ9
 VZ3NC2tNqkcQLuGzpJVcm9lY=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:11::)
	by smtp.migadu.com with ESMTPS id b2b6769d35497dae;
	Thu, 20 Aug 2026 20:50:33 +0000
X-Mizu-Trace-ID: b2b6769d35497dae
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 13:50:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aodk640QxaSa0gVK@linux.dev>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
 <aoanalsTiGmL69LN@tiehlicka>
 <aoclMssJAyYw2aCn@linux.dev>
 <aodLEmCg76oRHY2j@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aodLEmCg76oRHY2j@tiehlicka>
X-Rspam-User: 
X-Stat-Signature: 7kedkqjfc4fih1jujpks5ktfrywnh1ui
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E85F20006
X-HE-Tag: 1787259045-829577
X-HE-Meta: U2FsdGVkX19y+JdHGjxatjhHRMxTm6NbJSjvi+s4LtBOFV0Q8Yr8SMr9Pvfy6BKjVCc22h0/awxLKROS/hoctMKRKigqIimMR7aktRPMJweUDM9FAzmHz5/DBqhoiiXgi39SFUMpBjVVenwcZaiRGl/Lh3rt9PE2/vhd4pC3FROqJvxq6CSPXIlvziVA3WWh7qU6c28AuDYOthDNxf7QJY/jo0Uck5k4uBmblNY6FFKrgzW7PdaVb57+EuP+UMRpJ2eHl4DylpvbulrmFgj9Ge9/4hMqNsMBmYZ8iCsj8SQSkenNjBenuEHE8C8b2sCi8G/c4pTV+RTf7FgLr7wM/DSpBw8+Sbo3N+daJ9XoEde9JPrE15DpweQagiF4y5fTURBtsyhsQuCrH9uWfhHAuvNMFA8Ah5MR5SSF6cAZC8E4EoiWgMg8J4VBTa496Ku13oYxc38vc8ap/lvuh+y8X4m1bmud3hy55wcm4DLbL3yZHAHiVbZEmXQI46WSXzJQupQ7zOuQ75BFncx9isVoHgJomHqDMchXOBnxeeoZls21fInITjTZzY/Jt6BWcn9k4VAzlIYiUjm97XGaYZ+RJQgapJ4c5N7uV+xDng5qkKh1z5kNxFb8zLX5djvz+zhjRlakIHULPPpeoKWnDKZBfbTk/FeWo3oLNx0pSVdIGt44iY0qGBL4AdtDmeFmNLVsL2+vFWXLYzIaM6PfNJ+i8sYYxjq0sW01w2br0vZmy8DCCPKjlZKj9oEAP6mulQ9F5VboWlq8n8p/6v21AWMFP76tg9E0CbdKXiY7E4nvtHm8Gi+sX1qapXvCEZ1IZVa77L/AicyWnKwElQLkH0pgnZ6BqZks7va85spQuyCaKi2oVQfVkdRoQddDQdVHnxvChtrPaowIT0POxrQilgCxQKgsEZfCIyCNkvSk4E0pfPTy6RTaZQjjmJyFMSHdO+CLo4frPFAZ6xNbHnmgwjQ
 fxjpaVDM
 UpIKYpCLUD4a3u8a4Uem5tEtanwb3KvksQHJm/O872Z9wR6fTSugCPyHynDuhuhGPRFxLLnNBVAMrROUMicQhI9dXFpKg1XW8n+EIfzN8M33oaZvOX3TRGaP2fpy1EbQW/CUl92C1XDZn1dzjEiCeaI8nSfjNHxqDCkgpqMUM+tfx7hWsEctlU01bKPmLxUfygMbyVm4KvMGoSdZlMTRZWE6WYHfu3+qlk4uWE85iExsKmeLYWgg9vDqs6+z/4i1urR9eyAU1oexrJ5F6IFWIjXSHQyaldj+OL5uKifkZVNIyXhTO4Vl6gGMQoFnk87zEKGfP5FK3kxw73j2dK2cwjMrlojqTrv6S5mJGhrsBEvufb3p54ZhETNqsXj/KalbotMsYptDnrrs3n+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 08:44:34PM +0200, Michal Hocko wrote:
> On Thu 20-08-26 09:06:29, Shakeel Butt wrote:
> > On Thu, Aug 20, 2026 at 09:06:18AM +0200, Michal Hocko wrote:
> > > On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> > > > @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > >  			empty_slot = i;
> > > >  		if (memcg == READ_ONCE(stock->cached[i])) {
> > > >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > > > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > > > +				memcg_uncharge(memcg,
> > > > +					       stock_pages - MEMCG_STOCK_LOW);
> > > > +				stock_pages = MEMCG_STOCK_LOW;
> > > 
> > > I would find it easier to read to keep the update in sync with
> > > memcg_uncharge, i.e.
> > > 				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)
> > 
> > Sorry I am not sure I understand your suggestion. The WRITE_ONCE() is throwing
> > me off.
> 
> Sorry, brainfarth on my end. I meant to say that stock_pages should be
> updated by the uncharged decrement rather than capping it at MEMCG_STOCK_LOW.
> So in fact I meant this
> 				stock_pages = stock_pages - MEMCG_STOCK_LOW;
> but then shortcuted it to a nonsense.

To fully understand your suggestion, let me walkthrough the code:

Let's suppose stock_pages = 65

	// Original code does
	memcg_uncharge(memcg, stock_pages-MEMCG_STOCK_LOW); // uncharge 33 pages
	stock_pages = MEMCG_STOCK_LOW;			    // stock 32 pages

-----
	// You want instead
	memcg_uncharge(memcg, MEMCG_STOCK_LOW); 	// uncharge 32 pages
	stock_pages = stock_pages-MEMCG_STOCK_LOW	// stock 33 pages
	

Am I understanding you correctly?

