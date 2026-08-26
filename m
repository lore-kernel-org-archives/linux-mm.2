Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EE0AC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 10:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB9F6B0088; Wed, 26 Aug 2026 06:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275386B008A; Wed, 26 Aug 2026 06:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D596B008C; Wed, 26 Aug 2026 06:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E36EA6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:24:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 583EE802F7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:24:07 +0000 (UTC)
X-FDA: 85143035334.08.3DE8829
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B41211C000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:24:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqHjDXD7;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787739845;
	b=euDV71VIHHoFY3+R9JKnkDrLMJ6pIyVmUDAgnCtxebvYFffRY4DZuD+X8fvNS05jfMjxmz
	+it9c39e/kWyuO8Ekun2biXEqF4qyoLtd0miM+b8XD2as9oJuetM++Y5eIAsU1SHeb8UlG
	yjhdB1T2GDXTUUCl4zseXqDTQtH2wXQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787739845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9S4uM5/2OnDKhq0w/zFoe2vmWNQFI37dZ+G7pGbH3SI=;
	b=1ylaEpDyX/k64Nmbk9TKLspsFFbJHapgpOoywGd+QF3lAr6/4CLZuuSUJhVzucyRwUGjI0
	nbrAZ7F8S2ITgF0Deoj/GqU1VlkoqbeLLLxNFM92cXY/tQbtl1B2o8iofuRNnxOzKjAtOL
	Sp+oclCd1H3zLYed6o6oqhNJcZC8fzo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqHjDXD7;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1DAD40491;
	Wed, 26 Aug 2026 10:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883351F000E9;
	Wed, 26 Aug 2026 10:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787739844;
	bh=9S4uM5/2OnDKhq0w/zFoe2vmWNQFI37dZ+G7pGbH3SI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aqHjDXD7hfE1JP8mWo/Mtl5pYKlkv/ovumqRsRRHPfaq0FcH043+4wBhlsnt25zZc
	 0oWrKDjib3TmH8Uk16DwML2AtSbPgdST8JA9i0aS04/nBqMM5uPnfl1LyAjTseUh4x
	 KXDD1AGGfvZ0KylX7ZlFcVlYP6n4aEagDNFy7lplENaYhIYr/oWA2P+5z4aGF5LWLU
	 AOa2pmkbDDuP+NaBF+ugsGYaCr31vBOqENk2drbPu31M3ZHjjOq6rHPe4QzoiEuCNZ
	 C9OVdI65HoG6eXOt6wftG+aHTO4PAwkvWlfnSythfI4tAjlJVKp80Prz+WhG+D240r
	 JWWlHXtaEzJFQ==
Date: Wed, 26 Aug 2026 11:23:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <ao69UWWf0awFqIXD@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <6293dc55-e69f-498c-8290-b85202db605e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6293dc55-e69f-498c-8290-b85202db605e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B41211C000A
X-Stat-Signature: otshugiqh16o3mpdgggee81ud8ge3kbo
X-HE-Tag: 1787739845-713875
X-HE-Meta: U2FsdGVkX18WZFgb/p8590Dxx/J2UyZxxoTrDVnDM3ygigy4kuqgV9RRP81rQlsdAebmoTVhqDD+PrOPPz5/BgrF11wuaKqKwRG0pHUMGcDab39KuT7q6ccOalqtbwGQJl99P8BhfZ+Gl1xZY86cr9n03Kx44MkEgwXjn7ShsG7dvX8exdKWm3A6btSN+izO1OTsVuS2vYlgxpBQwLBNZgEhYmCUDb6ozpV0/Kp0kY7IKLj7wInUVzPs0ecmf8od2IyEl/v2sO6FrjdVpQFukJyw1iIJuk/Pq+DR5gsI6KPUopv6R/Y+oF3CoZuOoUZ+WlpkLEe1M/b18JYP8r6vkowJvwQxWyjvqUQaBjNab4yfNJ3AF2XVrKPfJAQ6pW5tdjF+/EjApMT3di/dEAt1Wr4e2CykLtHaD2GTvtYf9qyKCnWvvB5hqZaDjqVXss833IfRDo6Z6KRni/xnoDx/DHw54k3NT1AnCjcRvi2KRzzP6DIPScm9xUJMFqw695nGe3fWAIROjf4TiL7YDT5r3PQG9MhuAljrjIj4Yp4xQUn0U2QZtdYiu6mDXunZ8v3lR4cZqZf1q2ceWu3MQgDQh1HKlY/PBK/AKsI/oT/sApGS0Ko4WGTINJxm6Q47ai2s+G0uS1WBbxv5XO++Q/qxcAk1rOJTZXUXPYERuJ3V8j9d7U0b807hSj/PefysLGrdtBU/4xTkNjHgDWgJamGA1ZgF2EFJdWf+AhqVns2xgqpa2jMtuUJyLcgmX6GG10DWmFX50g6wfybBNKjK8V0MD0fgj0zO0gUCuQgHIfqoBqa4Pbb4Lpgv2F154ur8uPI0u1Vs6JDGJQWuqXXi4PgZ7DrLAwHNj3YmeYMJVSZvdSBSJg8VzyleE24EzWucGBwodcso5fbvr9iURihgi30OV1sllQqvP2QrqTGCzDV41sZWBnKtM9ReHOI9RXPxZymKLTm8p93DTC30VGYt/Fd
 GH71pBSv
 AfsimaC9egMQXnxfFQflYZjbZE1wfs8Hbk6PfioNvuOl6+NWaa+XKODZJsyd3+B1UwzzUmnnotWiw6BwiB7Rs0EdQus6NWgDdDWCyFdgH9+qvwtRdyHD4kobtK+g4GRC+qb6WKmeTXV1EXSPkkY7B/osmCzWZR5ML3OyR4xT9wlavVozR3gc+Nn3vmWmFRLx/Lk1mhKWg18/Zli5jmmOiiq4mK8/PMZtKX3T1XAjZylelYTaPJYrB8FXOASvI+F5USm/O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 12:09:31PM +0200, David Hildenbrand (Arm) wrote:
> On 8/26/26 11:56, Lorenzo Stoakes (ARM) wrote:
> > Unfortunately my workload is such that I simply no longer have the time to
> > give THP the focus that it deserves.
>
> THP is, unfortunately, one of the busiest MM components, and also the ones where
> we have to deal with significant legacy code, many suboptimal past design
> decisions ... and plenty of ideas for improvements that require constant
> pushback to not make the situation even worse. The time spent on discussions
> alone is massive.

Yes indeed. It was a very difficult decision, but the sheer throughput and
attention required has reached a point where it's become infeasible for me
time-wise.

I do hate to leave you with all of that, but you can always ask me to pop
into a discussion or cc- me, so hopefully that'll help :)

And as you say, we have an amazing community of reviewers who all help
enormously.

>
> Fortunately we have a growing list of reviewers.

Absolutely and I've really loved seeing how people have developed - Lance
in particular has grown wonderfully, Zi is a star, and in general every
single person doing THP review - thank you for all of your contributions :)

>
> It's mostly thankless work, really; but I'd like to express my sincere gratitude
> for all the work you put into co-maintaing THP over (/me checks MAINTAINERS)
> more than 1 year!

Thank you that's very kind of you to say! :) Thanks for being a great
co-maintainer!

> >
> > So, at least temporarily, step down from the role.
> >
>
> I'm sorry but I can't let you go entirely ;) I'll make sure to CC you on patches
> that need your feedback!

Absolutely, feel free :)

>
> Thanks again, Lorenzo!

Thanks :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

