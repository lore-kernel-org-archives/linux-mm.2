Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2B1CAC588
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575006B0027; Mon,  8 Sep 2025 10:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54CE46B0028; Mon,  8 Sep 2025 10:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489E16B0029; Mon,  8 Sep 2025 10:10:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 38DE16B0027
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:10:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 024F611847C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:10:37 +0000 (UTC)
X-FDA: 83866268556.22.72F7273
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5B061C0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:10:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mUSLOFHz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757340636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNRqPB7KdfOgvFdRA5vcOdjcm25++aV3+/H1vQCBoRc=;
	b=CdjksGGyc+Ao5yoyUITS/giDuaAaTUXqzSO9UT9kbQqHlgvAyYbPbLYii/XKWNaqVxMvha
	opUpROunkH2Zakx8cSe6JmPrzTWawN1GZBOCK3BQ8DzV0MuxnH5TtNP44dIzgVS4fp6cCH
	cwCcmf2WrWopRWccEOPMYQ4WpSRwKIU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mUSLOFHz;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757340636; a=rsa-sha256;
	cv=none;
	b=wQ51FuGcbcl1GkdHHbop+AbLaJZoHK2N6Qh0BjxlFoVvp/2ojqRbaRL+lJyzuIQrzlog6s
	s4fYHlTGD+SwfwBZlpzVj0mueN6w4U+AlIkulrDgaEVxej5wGRoFkwiT/XMwfMx50Cg1Pk
	RGhE8H3AqecZScM27EFvP8eys0cK3Mo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jNRqPB7KdfOgvFdRA5vcOdjcm25++aV3+/H1vQCBoRc=; b=mUSLOFHzjw2tflmcF/aj9xbc+6
	fxGUHe7DTTiHp3DptSeNuOgyq279YLs5LPMCHwJSRipuducFDZ7hwSDtBu8/vcoeNv+JBVQnOhbOh
	dM6tOzWLMLTnxBFItNs1maFSZL8OSwUrPnAb7WK8RNfeebN9zbTlvyXGjPGQ/QxZX0VReZ8iBWBbc
	0glvwg2EmCu4zS1M1fyo/yYcJVfM5NsBSSs4KQTvQF1Vo3k9BRYkbPhlJLYOjxJrkwc1Rf656b60p
	SzyFgue2NZtyEUh8F2wyN/T2c7O6AIJD+H4l981jOz+dqFZbv6T6e1mTKrHHJn9whHKRPORQBVwMx
	6KtIwxQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvcZW-0000000853C-1KUZ;
	Mon, 08 Sep 2025 14:10:18 +0000
Date: Mon, 8 Sep 2025 15:10:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, riel@surriel.com,
	harry.yoo@oracle.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] mm/rmap: make num_children and num_active_vmas
 update in internally
Message-ID: <aL7jyhlTjBrdbPBV@casper.infradead.org>
References: <20250908140505.26237-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908140505.26237-1-yajun.deng@linux.dev>
X-Rspamd-Queue-Id: C5B061C0006
X-Rspam-User: 
X-Stat-Signature: rcrdxfetgry1z8e6dp7wwttp7ed5aqs4
X-Rspamd-Server: rspam09
X-HE-Tag: 1757340635-46301
X-HE-Meta: U2FsdGVkX1/gQMamBgcbPp9PAqsWpMes3mK4kAm48BIyKnWJSbNH2iWBmusgbG9nYfPKvhTlrJsE7lqc68/723Z+UPqJnanH3zOP23Y2f3TMk9Ytu6cgMZ/HFbC5UuZQ5AM25IwQbg2HL2ZRlBAXaqHBRDqOoHkqBxHCAI/EiXSHzZb/HXAJCGxvQSBXUjjydr07CNI1VrB/fDRftD6++ZhmfOX4xb7O8pXBgY5uIRSITU4aYjS0W0pw0ANPco0fj8199maro6/hPRDlH7S99Lky2rte3GzSV6z78e3RJLEk9DkExa5MiZxmRETXaya6Q2VMm74TY3umt+ccAvvpvWNIpRj8r3/97Qbph3s1QhuBMj0ySF+HH2PfYziaNrp8RJtw3u1ifJGIb0U1FoO9AldrcoJ6iqPk/JFXekECfjl33w1pC8yk4G/qHz/ihBfxL/mv3WNyS0dwuXCI2j5shFHAiuVkDmWUl8bmJKmccrH//A41XzsHgflUlEXjwgahBxBaefOAqTjbEQQPy4QYAWb2rhi1gRZYOwVof7AWZV6ZdnukI/E7m60Az//Xos9fbLRoEyakAjERm/So36vl/xhoFFchCs7ClGAIfdvq2ZV1pXjUib8+ftuyfY0pkjnZsuBx+9KiDp1C7+snYggFv1fKjnPmt7TNuanrmBdFkOZ4+4Ldra51TaDvLCeVeWIX5gd7A5V1n8aIoL7AjsTdhYcn9FEjPLeZP+6ec09LA+A+vV/zaEeaCWggSUyZG0oYiuy1AcL7CGk+tcMWvk5Zu/oe4PuE1f+HRgvo2sKaKfMEcvLlsdGPjoEUjmkQPvfjJVzqzryTwcMq8J8Xs85PPPOEkJjpEQiJHUAgQNl8xyxXL4C6bur+JkOIfNxlp+sOGGett3hhoF9XIbj21OqlIgUgJM11GC6Onx5vsnGLbGQ3SdHKw1qqBOpzxa5fu88KSDvLw0v1QMpukVM30yT
 F62F4Vbj
 6HEQ0ElmzGttgwcivWxBBhflXqU6LLVCEP3Z1a0ZUVissRmnDgEvrtZH7aFJixYVwoSHdX5gbiHx7WMb5I74Cj9cI6asrI6ZRFrN8xznzN8ekk053osuDXsJ5BYPr89CA9HPVVbuwOk5CO/W8hY7ld2jsmTB/Z7fcWH4J9pE/REwDitPenjWZWXe0dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 02:05:04PM +0000, Yajun Deng wrote:
> If the anon_vma_alloc() is called, the num_children of the parent of
> the anon_vma will be updated. But this operation occurs outside of
> anon_vma_alloc(). There are two callers, one has itself as its parent,
> while another has a real parent. That means they have the same logic.

No, they don't.  This is terrible.  Please stop.

