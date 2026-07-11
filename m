Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96BDBC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9226B0005; Fri, 10 Jul 2026 20:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A536B0088; Fri, 10 Jul 2026 20:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7800E6B008A; Fri, 10 Jul 2026 20:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58C286B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:39:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCD83405E6
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:39:54 +0000 (UTC)
X-FDA: 84974638308.21.D092D51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5E38C0003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:39:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bl2l1g03;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783730393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqJr7yUpkIPQV2kdt+vlH1KgFs6WG1ulCiswcCMvBZU=;
	b=fdCVN+sxJEF5DjKNhmSGgR1n1r63qVdxiYH1jqoXtaWosk9DNXzn7I+ZhweOXK5BbJDDyW
	DylcMm70clWJy6OF9IasyylhQQGvAQVbk28Wyx9EshkztwRPh7kUTDDbrHZZxeHHuJPviK
	7G6CEvOWOESmPWlcHCpcE2/ZqUAMU5g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bl2l1g03;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783730393;
	b=rVNHDB12pk+z+AukZRCqiqTGaBXDBWsVQP8l3EYoOirS5Ip7qr5trB3wh2noTr852HsFlA
	d107h67xdWSCrt5ofwfiD+1jrVOWcjcTH9i42fwgn8jDsKCRBp9JyiDjkufUwIT/yz/+fP
	koymde9eHsls8cPDFhqHCKgdivKHwew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F675423D7;
	Sat, 11 Jul 2026 00:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC921F00A3A;
	Sat, 11 Jul 2026 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783730391;
	bh=GqJr7yUpkIPQV2kdt+vlH1KgFs6WG1ulCiswcCMvBZU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bl2l1g03sHnPglMFtsXroyHuhGQfWxq4H3TZ2lhDMJnkym6Hb5v/atJgAFDdXaZno
	 wx8045d3zTj2VuxcC5HkRszRmiL+e4S5XsQReSSTD/cUontA3kENoPMsoqmoCy7hLK
	 8z6JsX5TsoplWFsOTh+ACoq7GqW1DlVOV+s/RT8I=
Date: Fri, 10 Jul 2026 17:39:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Altan Hacigumus <ahacigu.linux@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jiayuan Chen
 <jiayuan.chen@shopee.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: clear hopeless kswapd when global direct
 reclaim makes progress
Message-Id: <20260710173950.cc42b1b9c8d25fb02b29cf00@linux-foundation.org>
In-Reply-To: <CALjTKDkqCnT=AYS3VQPYE7SEqRHDHZvUt=8upRnRQDOpnjbfyA@mail.gmail.com>
References: <20260710024429.70923-1-ahacigu.linux@gmail.com>
	<20260709202247.8cf6d7ab840f3a45c7eac409@linux-foundation.org>
	<CALjTKDkqCnT=AYS3VQPYE7SEqRHDHZvUt=8upRnRQDOpnjbfyA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5E38C0003
X-Stat-Signature: uh5qq9aqzic559cync9g317zfa6x34nq
X-HE-Tag: 1783730392-904939
X-HE-Meta: U2FsdGVkX1+dyf6Ymx+C1vUPANHjq+FJAnkV/d0rlSV3rsHAVDTOBXJgsEG5GzJvLa0Xpq57aFFdxrIqXv4MDQSVJd0fei7l01g4JqK41/iOs6pLz/BxNPsKoWJQLD6srIXdsOeusPK0yf8YBIf/tV60E+XtzzoBc19TO78m2wNgP5QTr9QKQ6yd+aQ4PwYhgDhg/zVEz+7LJd5gA1kwU06Aci/5BpDJ0HllXyofBczfeNm6hBy+ck098qVD2FtnGfDEBkuQJah28bd/hqpMLHlVjuY8syDGfEZG6LZdxyXhsdbGIU08K6aFDqIpnkW6pdaT/pThVPkNDZRoe56VuKXaoH+jD5Th3hrhQWz1y89gZ3iYmYXtWYoInIosq6lK/sUppp5M3SmuQ0mzi5YISPIEmcRhpnfX6EAh0CZ6Aq3s+sqW/rd3rNN+Gos6mOqacBofVUuct0uBpGUW2JLwdoqJKmLkjiHijbnKtnHtLYH0J/QB09w8hxBYyKn220LjNUVTTlNdTWBuuUEN/hQ08p9yBiT3VQjrwND59j3TxbGmFTDf0XfCzFjOAM1KSLc4WN/+K4ylqOJwKhtg9lRjUtAMfAXuhnzX7HXr7LNrVC5xwoPlSNlSUaSXikwu7cxhK4J+DMMYinpTLh7y03VygBClGdi/rkjVw4NQJdkQTVQzcyt306sW2pOHCqM9AqhE0B657D1xDAyWsj0T5RCKUiAOg30yOxTJ7MEHIN6H1U0O92RaeUeVakRLxzyoMapsXvinH49M9h+npLDyV10UZrIs549f695oE/ZpwfuEXql1pzq40gVhL447G0CHomFnx7HgYmUXZNRWEFe9U8EqE89PNvH/PkFcYjAwwtepS7ZOI6Z3YBgOY/3BXCvglvj3qGlR4iFSp43ecW5ZJB2U+drDEAB2f0JOnVGJz5EIlwcWKyMfFX+PcRdpMBHRW1zvsioOXr5NcbNyv/7wvD0
 s6ieZyCs
 rBY0zOzqQB+GMhf9bf1d7t4XMacQ9cxv9FKEBrwjnMDGwXJsR8le/N9gPsTirbzEWoW6bbjEpSZeBJnTa4wt0RRlJD+nOAsZNjtid18CMjFQlNHtm1waOPFd2TBtGx5RoRo5++nbyF/h8afuuTI9ljQsEzOmlLfxKJv/e62sR3gSHYq63U5GE0gKKkvL6+4niFUamAoDk02bon7HOl8xWJQ1ZVFjdqtWKJUE23nyQSCSlN1V8mDYgp5JT/v84vog8zTyUsm3IQ8UNPv/v/XLw5hs+1PJsnx0SUiGssjyi1TZlQyOKsbaioSVx2fMa8nhc9erko+YpCBNWdVKick8g8QfsU+D/UxXTKQBv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026 21:04:20 -0700 Altan Hacigumus <ahacigu.linux@gmail.com> wrote:

> > Does this change have any user-visible effect?  If so, please describe
> > in elaborate detail.
> >
> 
> Yes, the effect is visible on systems where a db workload mlocks 80%+
> of memory and the remaining memory is under continuous pressure:
> allocations stall long enough that ordinary tasks (e.g. ssh) become
> slow or unresponsive.
> 
> > If not then that's OK - we make such changes all the time, but they're
> > less fun.
> >
> This was introduced by commit dc9fe9b7056a; for long before it, any
> reclaim progress revived kswapd. Now only a balanced node clears the
> hopeless state, which is too restrictive for global direct reclaim.

Great, thanks.  Please get this info into the changelog and maintain it!

I'll park the patch for a week or so, give reviewers time to catch up.


