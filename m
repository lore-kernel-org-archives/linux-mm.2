Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED3FF54ABA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C2C6B0005; Tue, 24 Mar 2026 10:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0EB56B0088; Tue, 24 Mar 2026 10:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24116B0089; Tue, 24 Mar 2026 10:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC3E6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:12:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 334AA93A12
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:12:16 +0000 (UTC)
X-FDA: 84581146272.14.FBB885B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 469A6100012
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:12:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kIQoAm2j;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774361534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKNKZO1PbDIycc63ngbj8ytXMIyj96P0J6kd55apnPc=;
	b=04CZ74LE+gfrcziXpg14BoxCSmZCEzBEzL1pWCLn+01Ialk1R5zjamRnY2sLzFfUVpC8Jo
	isGH89Zq1WdJ513hhRLvZpeMnRweAsENiKaiYouMrWfZa4u9vrFAuHhJomwkK6sPcnkZr0
	96ZiBphuqoobmMa9cfcoxlq1bqXKMVU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kIQoAm2j;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774361534; a=rsa-sha256;
	cv=none;
	b=XsqgbAlfJb+EPKKVnJIncDhB3onOh+szQrOI2oQHnACKJBx27zQEsAoOVtvZZdvQW+JFhn
	nyoCZcNfTwzyML97HfDxErjgcqyDQ2lNSECd6Ae/lCC0419XNxjApQ+06GVr2mz2YVnYTt
	7OPUhl8Vq/W1yERe3KEFAO+JwlWLeSY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RKNKZO1PbDIycc63ngbj8ytXMIyj96P0J6kd55apnPc=; b=kIQoAm2jaL+V9pTcaMnaKYeDuJ
	bGm1wxYkTbQEUfD7aggvjhnMlMDdM66UO6ERcgyRtV8494+Au6FVCzvNp1XHW8K7Bs+a/qXwMhHTb
	fQVS3CsgcD5v/ura4Wm7HoCpvOTtJS8hfjNw3+tYLb4kIP6RLi/6GtpBuPkG2DW9XmjuK09DTsonN
	tRvEk0VvGxZbs2vMsb/qfUzjy0gDU/r4hLFXUtA2Sh0yZFbjcJLAgRVwLIq6mZ8SmNCrrBGx7HSt4
	gA/6jgfjHqAYSKRBE5pO8uUvdc//7sGBCe9GoEYdKeh3hDn8mNGdnE4kqK8vhge+RivgnjE7QYg9W
	L6sBl7og==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w52UC-0000000E8K6-16qW;
	Tue, 24 Mar 2026 14:12:00 +0000
Date: Tue, 24 Mar 2026 14:12:00 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
	usamaarif642@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 2/3] mm: memcontrol: correct the parameter type of
 __mod_memcg{_lruvec}_state()
Message-ID: <acKbsF__VQjtgnKz@casper.infradead.org>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
 <98dfab09-f3c5-4503-94e4-c3f097539afd@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98dfab09-f3c5-4503-94e4-c3f097539afd@lucifer.local>
X-Rspamd-Queue-Id: 469A6100012
X-Stat-Signature: x7ko6dizzgz8euzbkwy4eaty4nwm4tjb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774361533-566127
X-HE-Meta: U2FsdGVkX19KQVCuomw+X0qELfjjG0Eppwk8RUasyvnf5x3RFWMQNqEUuNnEjhekYqg91tOwDUqiFp7j+/aiIlaDriT/3v5kVZO9KhZvFTasB2AeWfxZzSWKuWnYzkDe+kOrfSIVO85OSegQ9SnE0hxD9zRy6GyfSd34cZIpmrx7qkaIOWYEmUcBg6OmenKtTEkWlvIpwTwn/71MUdo8URCQuZZHj7xxf1ruQdRohYjOkcVcaSsHGxSiqWEIPGLkkC8D+gdefMYlv3XNYVpNETqbJkOUEvu3hlJ3kW5o5m1bz//3D2kCaxZswzGu5A4b5wB2eaHI6/OfNpZUkb6hk8skmqz9HnbfVn+iEK1cTQSFEn+4xs5082MOvd/uO1mi9oTynfddj0FVUEpy5g488+rqT0/SOMfX1mRe7TQpH6wIzGQ4wFGq2zaUbeNMltkcs83zYmLsQrBmQO8Qe1xQGILnD8VGUn5QKEIS/V1EVokDUDzToElsQs726azT0iZJ2WWTSq8hsOBU278ntdMQBIMjufnL3uIqfbD/rlD90WvuU3oK1kGNncJdI9wKaLYHh92tHLJmDt/dVQcAEF4XdNMIsb2DXOuZDK5SorY+TQPO5+ww2SwqUChXJEhEcdUIe8QmEhbLq6AL7Nkq55wnwWzOQI9+KHtYxUPhZS4VuUavJ8rO8UUVT/G4q2NTdxyLSpBSFVg/8eD2tUrufmyz6DOUBXWmOe1pu2+fuJCRyAajLU3W5d8X2GjPOEBECIdncZ2fgmEfV1UkIaSbUAbHCGn1O73tv7pIwMYndFre/zqie2d4nwmwKEX+IdIatZv/f01WsgNnJuVuHLYwGKcFH87i8yl0FGBkENEJo8XZvdAEDZhPHgicduzEl1iu/l0aQ58Z2PBCQlzCSZBoCHDsv2e9fZoQFFz1V1qd1I9BSXuLVNYFbex+jDfRKcEB7n0Tu5os3SpOFBhRauLo5nS
 aw88lB9p
 KAVSpGFgqWuSZQkZZqz0tgX2K90swO2PrKRqgxeEcgveP2U/m9Bt2EqQqRhYPDKeshRpvNtK5r4gPQKQgS6VJNxfDssXTF5SLM5xPhk1evcnAgNClxR4iBl/rtVgAOX6zrSX7fCyUhaIQOGyRd3LJvv8gcBQQkqX+nPvADPCi77jQl0sRTVVAXYzrrNZc9b7V8h99U/6xdK8YBQTKuj5R70vHyP5zPyo/u7EZTJOneT+irwUY7cOoAOEk3utgweKL4sFe7qSpXL99+/94OtVuKrABAK/FJz9UHId8DkcuKPu7dcFv5sRgT+y+mZJg0eRLPX22
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 12:21:06PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
> > From: Qi Zheng <zhengqi.arch@bytedance.com>
> >
> > The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
> > reparent non-hierarchical stats, the values passed to them might exceed
> > the upper limit of the type int, so correct the val parameter type of them
> 
> Why might they? What precipitated this change?
> 
> > to long.
> 
> Why is it a signed value?

Because 'mod' can both increase and decrease this counter.  It must be
signed.

