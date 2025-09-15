Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0088CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C1D8E0006; Mon, 15 Sep 2025 14:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBF28E0001; Mon, 15 Sep 2025 14:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAE48E0006; Mon, 15 Sep 2025 14:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE81E8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:06:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98127C05B2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:06:08 +0000 (UTC)
X-FDA: 83892263616.27.299A7E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DFE55100013
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:06:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNOOGc5+;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757959566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/pZF+5lXwJGkwdXB+oEJzWHqIQeBMb7/sMmmJPXlewM=;
	b=RYAyYgHKsYkVZouEC/qVBv0+wLxPKpk7cMzoXmHAhdoKDJhFJWwdMzCf5uS3f3xEUDyuNF
	IWEFSbUyzwqcyApMqY+/eFbTxLkbJFlwtlx1ZNj676Yueqlj8nbYtb70vQNvCDv3uTVS0G
	05Zk2ZoB9h1WUrRajc+EgsfSdUZgkl0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNOOGc5+;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757959566; a=rsa-sha256;
	cv=none;
	b=qZH+D/Z19GYUhATaweDAs8DoaBUC3FNw1Ul2+u3s/VZY8nonBR0aIrig+QnESXGa5eLzHC
	CLJMKMvZckdPC6DlGYQu0gCY3O09fJ7Zu2D9BUleHyP0HD0JgemGEnCHDx7vTGxTkdFFc7
	EP+MoXXpXW+KJB9UNqX8cGKqy3ibRjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4766E60202;
	Mon, 15 Sep 2025 18:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF298C4CEF1;
	Mon, 15 Sep 2025 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757959565;
	bh=R3K4Y/dSLmEWyD8ymG6km0XDDMmddNGUWTI1tUqPvlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNOOGc5+WpUFS+sVqB6MYWVbIYSAtkpW//y6DplI9q2tBqaUiAlCeCpZ8l1VKNjZI
	 6yEat5zqx6RVXZz9RSb3YEHO0moWzs0cZMpVPf8GBCeLVG3tNjHHaQhvsZU52cttfT
	 cgCZP67AKz1wOTtsy3hxhaULVL7KuE3IdwYofIqDTHjfSyE0z0jmsOBwtyzYflZoNe
	 gDNp4Xpktrb9EWPORQf+6ecHnDF2PQMDEz8NGAozxLp8QLSnzmCX6ZHlkx9udhiLh0
	 FAs6FOOIieu59NalkqA05QfmQkoONC3RepxqOOCjKqBc6yXzRdCm6jkO6Ud9oUbwQ2
	 o5DgjskJMFldQ==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/6] mm/damon: misc fixups and improvements for 6.18
Date: Mon, 15 Sep 2025 11:06:02 -0700
Message-Id: <20250915180602.109892-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915152823.1605591-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DFE55100013
X-Stat-Signature: pg65fhd9m5oh6pwyet5dnskpu3but1y5
X-HE-Tag: 1757959566-128600
X-HE-Meta: U2FsdGVkX1+xDt9lhz0oBuKC7ltLx9SXZrzZV0EWrYdBA5IxfzR737rX/udyI51Blo9nWWt+yNUmlOvgVXKQicTODTLr5W3zfraV19f8DE+5kEWS4nN6qJ8y/DeFjxb52zVBjXtavgrOiK7FL8Gg7+V5td6GAumcOc/U9zdoRNMvkKs1f6qqZMngyqRKF4FXNIzjG5VyzpmAnFbPFRRAeUPxHuncusC7Nq5IGeaeqA1DzTSYAHEZ356oU1pmUPxwo5xwbjpeFCZTygWrdFqILBWIiHFU+ylerpalufbS4KnAsV98Gu4vqw0AmyfVQyTco/k2giDzgtFEdrWa5PCmqrK3+V9nPGMcpHeGt5hKk80phCxBe79BYba9dktlEkV8k1QNHWGAt/m2J8qNTn03lVZn+h0U/wq/yYIW/8AakaO/xs4jwzM4c890IXP5YI1mtL44TFbucavl7EKbaApqbn7Pnrksp2j5aD+JW/6yK45U3AaV8mvzL24yycH7b29U6zgJQV/XbT/PewRvSAvd+KIWE4CNpGOauE82rfhD0xiL0gccwXR9DiZ3Ufv0ZayT0j1VeOyY/Qh3pnXiGLp8G2Lz5ih4y9aPKPshhlHhebvf19evQuWAhWTt5NJWg58BKf5rNFoP8nxJ7XQf0SsN3AwRYm2qTD/nhaaDCVdimDdKP0Pf7Gfd/u6p+gm7xIHYtG2o6iC0EFoyB1nwSygE2fTLj0m1viUzoUOvecmYfrtMt4tck+WUzHvCd3CtJwTTDYHl22ffQDZ0TKcaQgW5Y9MV7lNt1GfNbkTjKoWzbIvN1QoIbuxbqR1t0TXXpbOPodyh9nrhemDfWR/8RD1JKF7ppFLgmxLOnL4gcdJFKXU8TcrDuM2VWQvCvxvbfuf4zppXUVOnTIWnKry18rnSdStthr68IVzqq9O1eVW/3GIYdNZaeg7f15yepTssIy64J3nOOMA2CAMQekOWJMv
 J6ETP3Vj
 e9lcEIbkhH48Hm3jpkvGt5Mx/+zVZ6tIeReu20pJ5pZTS8XWFfoQ8jMI9hElmFFs3JImuu+qy6G1zI0r3JrNaZucoS2UmG7OttbI6PYjx4MSBlMr+WHeGRuaTBMO7dV7L7uhCv1mfcx83grNqSzLg8UQGhGGiJtaMd5U3KoKGlnnZbQvWRqs+GFy1HYj92NE3uU3ObgLpGGQZfvPfRxVo7l4MtyMmSojlYbEMt3P9VdrID43FLkJKIUcwgvXnGt0mVlqssT1UOBBipHk+qQzb34VOawnFxvYN7u+IdHIDmTz4S4JAcFu5yDDPkiawbzw0Vb/Tj4qiCJ08hJIKJ2wasTJuRX7bW5HZ71Bqj+DKE1ZSbo8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 08:28:18 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Mon, 15 Sep 2025 08:25:40 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:
> 
> > On Mon, Sep 15, 2025 at 8:08 AM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > >
> > > On Sun, 14 Sep 2025 18:58:01 -0700 SeongJae Park <sj@kernel.org> wrote:
[...]
> > > > Finally, the sixth patch updates MAINTAINERS section name for DAMON to
> > > > just DAMON.
> > >
> > > Hi SJ,
> > >
> > > I was unable to find this sixth patch on the mailing list. Maybe it got dropped
> > > somewhere? : -)
> > 
> > I'm seeing it show up for me, this is the link I'm looking at
> > https://lore.kernel.org/all/20250915015807.101505-7-sj@kernel.org/
> 
> Hi Joanne,
> 
> Thanks, it seems like linux-mm wasn't CCed on the 6th patch.

Thanks for sharing these findings, Joshua and Joanne!  I was using
'get_maintainer.pl' via 'hkml patch format' to fill in the recipients field,
and it warned me with recipients review step, but I missed this.  I will ensure
linux-mm@ is Cc-ed from the next version.

> I should have
> checked in /all!

FYI, if you use hkml, you can list all mails of a thread of a mail using 't'
key on list screen, or 'm' key on the list screen -> '2: list complete thread'
item on the menu screen, instead of '/all'.  It should work for cases like
this.

> Have a great day!

You too!


Thanks,
SJ

[...]

