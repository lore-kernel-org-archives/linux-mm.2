Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DF2C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F7F8E0031; Mon, 11 Aug 2025 06:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B93F8E000A; Mon, 11 Aug 2025 06:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F116D8E0031; Mon, 11 Aug 2025 06:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0DF38E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:12:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 457D711737D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:12:36 +0000 (UTC)
X-FDA: 83764062312.01.7AFF625
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6880C180005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:12:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Y2hVlJpE;
	spf=pass (imf06.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754907154; a=rsa-sha256;
	cv=none;
	b=3Sp7X4D28jdMmMMkF2tKKzcbfL5BdTVxnk1CLxNh98HcOIjsylHz6QYkxmn96+f/dr3nND
	aEjtwaZn6j9S+8qLlRR0Fc9yIZsqZ9Yn/YcmZ7dxMzK6NatP4+0/UNk6slv81r8wWe4a/f
	LPF607OtzfUlUObA/HUMVWScBsvhN1Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Y2hVlJpE;
	spf=pass (imf06.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754907154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEU5zlVFOVULGraJtitB5FtnZomkqZexV4SmnkieOa0=;
	b=vxvPjcijhJxIE9c2LmgkiJwCm7n9rifxWE5HeNb29LW+n87GPqdUjfo0DYoimlAkdGO7Rp
	5sfNfpxg+HZfakeC4f8+P679rWRayS7rwCmKcu0Uyp308Fq9qD8RsWOl2+YVNY9bvR3erd
	jQKdn3ZpxbOz6t9K1JU8LiyIkzlCZ5Y=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4c0r6Q0v60z9t2j;
	Mon, 11 Aug 2025 12:12:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754907149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XEU5zlVFOVULGraJtitB5FtnZomkqZexV4SmnkieOa0=;
	b=Y2hVlJpEkip1xRP6cjvm3KEyu9xfpB5LyAnFfPUDO9YN3d4wx7R59RgB315TY4nDull6CQ
	O9go5945zO2EXd1pZ/LWjT5XP3VgxUFaM4WXa45JYp4i5nUn7muyfZr4c+iXIZTxy89AvX
	UDctIjxoZ7w/70EoHL5/imE7zLwaLg/kwdR3XoyN9KNObeD/LiCpeXsbVQXY3bcQRz2sYd
	ND4PO8br2rm6uEehnXjQk9Kuo1vMa0cZqcRMavbI9fmpPRhsDO40AsC8Plp31Ng1KDM6Pn
	cYmwQ7b9aNTn4bami5Y7yUwJJnHHOEjXO4/o/0NCY8Y4gaOwoFyZF+bY/LX36w==
Date: Mon, 11 Aug 2025 12:12:20 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, 
	Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
Message-ID: <hp2wzpu3bgwqyw6almor2x6exgx7t76kch4uec5fbh3xw6sy5w@p6bvhcdhpyea>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6880C180005
X-Stat-Signature: 3b5i1pkyaa1b73red9fe8y4y4dxdigei
X-HE-Tag: 1754907154-54268
X-HE-Meta: U2FsdGVkX18We/8yFhu1oZWj6cpfAQUPBsb1DgHeptBAJh/CyUX9mAKwCRWarFWK1OoUDaPq6tZEdjxc1KgkIiIxgpSfBSupb4zIVZA7zJjnm5Fd8ziwDis1MbljCcXVr5VYF7xL7J6yvD6Oi0sLIdoXp/g434ebywsIbufUEhAXv9msi9wU0PB0wsmDGJBBR/2E0fufY6tE5AcfloH/L4KpfOqEgp/JlsbTvrhSDgnvYewO2c8vCuAqZzBG6yFvuVQiM5KkKX1meKzDKVVffWtGfRk0XwODM9Mq9sGYQttUMa3w8mjDGZ9LVkPTAiWBtzzERD8n+qf3gRNAGIqbXvpAp40JpbRQ8QnWFAhx+8ZbKRrztLFmcoolUqgdSity8rK/itpvSQiM8o8jfDqiWqPriknfcoP4Z4UMspvJy9zcWdI3PRloYquBMJKoERyziAsgQScU6Q1rofyz4D26SapWI+ySfGyeKTk8HB8899t5p4khnHjr80+BOeM+nx3vj+dySmEoaFNTWZrBQY7Fnf1fcsUghjjbcWcY5NYqUvomrLxjpiPbJWsGkQ7DXVNcb6BipxF+ZtRFB9PRwHWJZWHyQx2oquYBnabm9QmhZw81ZdXATzQ9NJcMKW2dOxAgzFi/Bfd7yIt34p2Hcz7zPsgup4uqAYqcqWKqwwiU5drof0YPztMvI24+PkKH9v2H0ZFMPqgKki4HiUfZ+ITTdaxjqOWIpKc6/4b6lZtmiiRmHLV2tPxAvNac29+6Q25HDWfpJWUP7NkssrYyPhGpGL5enyMBcVOFzX7s575juMqQdzGK6Fwx/0G8c6+M5yXpi+M8dxWv3O2vs7CRjUi8ZvEbaxsNlIWM3CP3q9/g+fPy+vBEod/WPdoekyGgb3+bulP/AHuQluiSHGrfdLlePciUq3MmkP3bJo4FZKqWfYldfD6oRo1F7poUh3R9kqSyopdaa0ajYmrbAj00VCN
 ZRCgCJz1
 26/npi8Ni7yYsQ1z2dVlk4KqybTrKFCYNU6fcGhNNYLODv+hhrgxg5XwIhYGf1oSPbPn7ZxN31Q0DcZPvZyXZlRWw+KWBN/jjT3GA5Sj6os59N0WLoNRrPYFEeyd/oOFaYmO9S+mxCMSs3HzMWKk+IXRoTiHEIuh+RwK7QgXghDksNOYNkRnblRmgsmRl2tlS34WFBUkSYsXVUhg7Q0r8Mr9Uo26zLJxwm44trLjGxVHeT5tSWlQ2MD5Fm76oHqwIYzeL+Hwi4lKR4GdksTqSPCRTJd1CHi8ilSjhCvQAgYjuFIzlPff/88VYsOZPLIavKT8/SH6pqysgqQu7gGseDS6vxM9UPWw6gKrqLtr+ix4Bzrx+dYI8gF7OVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will always allocate
> > > > the huge_zero_folio, and disable the shrinker so that huge_zero_folio is
> > > > never freed.
> > > > This makes using the huge_zero_folio without having to pass any mm struct and does
> > > > not tie the lifetime of the zero folio to anything, making it a drop-in
> > > > replacement for ZERO_PAGE.
> > > > 
> > > > I have converted blkdev_issue_zero_pages() as an example as a part of
> > > > this series. I also noticed close to 4% performance improvement just by
> > > > replacing ZERO_PAGE with persistent huge_zero_folio.
> > > > 
> > > > I will send patches to individual subsystems using the huge_zero_folio
> > > > once this gets upstreamed.
> > > > 
> > > > Looking forward to some feedback.
> > > 
> > > Why does it need to be compile-time? Maybe whoever needs huge zero page
> > > would just call get_huge_zero_page()/folio() on initialization to get it
> > > pinned?
> > 
> > That's what v2 did, and this way here is cleaner.
> 
> Sorry, RFC v2 I think. It got a bit confusing with series names/versions.
> 

Another reason we made it a compile time config is because not all
machines would want a PMD sized folio just for zeroing. For example,
Dave Hansen told in one of the early revisions that a small x86 VM would
not want this.

So it is a default N, and it will be an opt-in.

--
Pankaj

