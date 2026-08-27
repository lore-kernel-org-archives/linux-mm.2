Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BACC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88486B008A; Thu, 27 Aug 2026 09:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A120B6B008C; Thu, 27 Aug 2026 09:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8CD6B0098; Thu, 27 Aug 2026 09:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4216B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:06:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE1C9120442
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:06:58 +0000 (UTC)
X-FDA: 85147074516.13.ADC82E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 20FA12000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:06:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lfne+dj1;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787836017;
	b=3C7W0YuRkawus5TaELTAN19ijiMaNoFMcRpD0gR8kuxMzyNExoxI0xScWO7VxjZGEkOzrW
	8CEqXblnAcJfuCcvjb5hT3R6/3o52d/LXdJ07HxTusNfiCWh5Tqkcj2sBwq0VpIYKSfbyo
	BOsqFwY47rhmrWgYPJRn4GbI9+lxBGQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787836017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSuTZwdeaDVo8ilObKv1yNCokL2S+sutd5WfT+a22kU=;
	b=My49/7LIk92G1HhRk6Q0TjBsUyJF+iNNPE2qgybVerCgfsK0cEgMt0Z74MXsjVTSEdGyAc
	WXFFTzMWg1DUxQHqkMCYqUQ7SZSn4pX4BvUjRBTyULQgoFOHFpOkhemautTspbO59bnQd+
	f+jCPvWduOMzqm9yD7P1LyWuIX8nLWo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lfne+dj1;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DE1642A61;
	Thu, 27 Aug 2026 13:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9951F000E9;
	Thu, 27 Aug 2026 13:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787836015;
	bh=ZSuTZwdeaDVo8ilObKv1yNCokL2S+sutd5WfT+a22kU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lfne+dj1c3eOzsZQQYORIe2wqZ8Hd+nnFmlXRR9bizxkA+mm4PhiSkK5JctbFRHGz
	 qgV8h6Wc0gV0ZMxA6x+hSPrSm3ygBn0HrueK7XlRZb0iNKWW+8FGnTj8q+f2biCu+4
	 Q9cSAqrKCLhK+c/U70mG8ugw5cyQpbyozWw+Cj/P3JXRfnTpWNe0OYlLR1zgldPcjO
	 FtA9ORbeowfPJFxXkZhf225GQXYsT4V7MqyFWcevVPYKDfx8LKp1bDsXfmtIWmlq6f
	 arXv9VxGH+aF1hWSC4X+N52gAZlC2aQ11S0n1JhbViwPKu7JCs0XpI1G0HzUsfNo3X
	 bZ3Xv5Ul1Qsiw==
Date: Thu, 27 Aug 2026 14:06:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <apA1Bm2BwpqPc86v@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7Nr_FALfP7cTY5@gremlin>
 <20260827082352.26769-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260827082352.26769-1-lianux.mm@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20FA12000E
X-Stat-Signature: mfa44ebwff3yw13ohfjfyata4khcb6g4
X-HE-Tag: 1787836016-552250
X-HE-Meta: U2FsdGVkX1+F4C7UXo2GY6B2J+Tj8nv6W9EmYCi8o2GypQZYo9L9tgaU7fvAA6ktBmP1xr5c2n6e52dsfc7js9N8qwuTvb5x6uCiHJ/82o0zkJ6/gUcJPg3JHpZE3q3HBJ9iHbm1zQmTLqcO7juyc4T0EAn+1RjMvlTSdTXze1P7L15tZcO7AkmIW9JFSVOqApDqqffwSTiUX6neRSarMtC8Qpll7Hnw/flyxt6EGdPI58YsikYAYMvZLMIWXGFppDPHXHIgBCwy7o1+yjKm2rJs3fqeMYQfFxunRQ5ctYxSL3q1yzTyHntEw0TDTmJlNGwde9iRkYDhxzixDGBdv2vPxBg7yybWN5O+3L5VVzI2eh6TtuDRV6O2CbjhAFIaaMU+jk/QEwmeN/pU+59TMOyFUceCqGF5UeOT6WLX0l3gpcOGoDtLPq9QpTqUCKB1iwZgNNXqOG1E5l2jlPweHFzyi+5jGzaBr+7JU+f9A9+6DlAw8CIo9QRrRaJSr7OG+5vWWhVtu69jw55IFaEo5YBl1IYicUGYECZzNbSuCnlvQU4b8QseWbUGqx/CxBAs7QD1qTyvcBg8fpfRk1O+skw7sMS8xn/Xtpo4LW3wQ64tk8wnSHib2LCDztbtDOsvkThYaUymSVeKcE+wTwYadcxascrTuO5jFDvfIolbRM9xC4x9GnrLTmnIL+YBc2DYuf31ybe5sY8apDQZ08+WGDTBCK65VijHDP3d/xuyJtIFKTc2ILCNHdhaJj7+wxaO5xUUpHzDFDQJE+CRD5TTQlPpRisORLVfeqjBCIb3db/yiPLEo31ORorKkJlSlbq2DVTpQst0XwhCVLkziUv90rsMpqfJoEyOollbFsNGKyyVnbCG2eCoJW8NcqNdOUci/Q3vI+H0FUH0vXAUVmA9R+R7ISA6CnN3R3ErSIPh75NQ+4xkJ//R3gc6y8pT7hQ/2EDVe5VbRRlkguLP1Wm
 QK1bRTN5
 B9q+aTb9tH9THUnt4i7llVxHcIAK1xazu9I1QL/T6IwwNmXjwqgHLFZx0HWPLHHiYw/+bVB0t51n6H1eWHQm1ROgWjOohztqPIkycFRVCoFh4YQsVJSDFqOt4caQ54MYcDUNtHOqB/fd8g8RQoRJn85dNtGjhhKeGBiIj9PDp8pcRiat/51Ks7KLr6DqukR46PSI40NVsp63y2xDkHHREMUvs/2oONEjvUNTRiVAxfM1Zd1zs2cSTKDleh84Z8Phb5EaLsVlJ8nIh+Jz43Z7RBZvkKe1nQYZvZwunx7T4MYwmyC16ovVL52TypdDDMtHcWRtUi+6/SYWlz7VHJT/8FsGgdvHBcNDh/lVJiGL2uw86qcQ4ts7mnvTOmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:23:27PM +0800, Lian Wang (ProcessMission) wrote:
> On Wed, 26 Aug 2026 12:31:09 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
> >
> > 	~107,000 words of review across 948 emails (in 279 distinct
> > 	threads), counting only prose you actually wrote — quoted text,
> > 	signatures and attribution lines stripped. That's a full novel's
> > 	worth of review commentary.
> >
> > 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> > 	and your longest single review was 2,404 words (mTHP collapse
> > 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> > 	of your top-10 longest reviews).
> >
> > 	Estimated review time: roughly 300–500 hours, centred around ~400
> > 	(i.e. ~7 hours/week for 14 months).
> >
> > 	1,615 THP-related emails in the window: 948 reviews of others'
> > 	work, 278 replies on your own THP-touching series threads (~31k
> > 	more words responding to review), 382 patch emails, and a handful
> > 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> > 	emails), June 2026 (113), August 2026 (111); quietest was December
> > 	2025 (5).
> >
> > Think I can be happy with that!
> >
> > --
> > Cheers, Lorenzo
>
> You certainly can.  Thank you very much for everything you have done for
> THP and for all the people whose work you have reviewed.
Thanks :)

>
> You and David were among the first people to review the first patch I
> sent.  Later, SJ, Zi Yan, Mark Brown, and many others also began helping
> me.  Although I kept making mistakes, I genuinely wanted to learn enough
> to share some of the review and maintenance load that you have been
> carrying.

I'm glad I was able to help :) and mistakes are just part of being human, I
make the dumbest mistakes _constantly_ :>) so the key is really trying to
always find ways to quickly fix things up and improve.

>
> I still have a great deal to learn, but I have started to slow down, think
> more carefully, and improve both the technical quality of my work and the
> way I submit it.  The help I have received from the community means a lot
> to me, and your patience and reviews were an important part of that.

I really think going over and thinking carefully about the code and the
approach is really helpful.

Also review really helps with getting perspective on what other people are
doing and how things fit together so is super helpful for improving too
(part of why I do a lot of it!).

Am very glad the feedback has helped :) I know that sometimes I am not
quite as patient as I could be but I do try to do my best, and felt I've
developed over time as a reviewer, albeit never quite being perfect on that
front :)

>
> I know none of this changes the workload that led you to step down, but
> reading this made me realize again how much time and care you gave to all
> of us.  I will be at LPC this year, and I hope I can thank you in person.

Thanks, feel free to come say hi :)

>
> I will also be more disciplined about patch preparation, testing evidence,
> email formatting, revision history, and the overall submission and review
> workflow.  I hope that, over time, I can take on a useful share of the work
> rather than add to it.

Amazing, yeah I think the key thing to realise is that while feedback can
be painful (for me too!), everybody is aiming at the same thing - trying to
make things better and improve the kernel for everybody.

>
> Thank you again, Lorenzo.  I will miss having you as a THP co-maintainer,
> though I am very glad that you will still be around.

Thanks again for your kind words! :)

>
> Thanks,
> Lian

--
Cheers, Lorenzo

