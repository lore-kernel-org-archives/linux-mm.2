Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BCACD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 16:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A541F6B0005; Sat,  9 May 2026 12:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A040C6B0088; Sat,  9 May 2026 12:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919B26B008A; Sat,  9 May 2026 12:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 807716B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 12:02:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DD8C140158
	for <linux-mm@kvack.org>; Sat,  9 May 2026 16:02:35 +0000 (UTC)
X-FDA: 84748349070.13.084675B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6ED2E100002
	for <linux-mm@kvack.org>; Sat,  9 May 2026 16:02:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Nd0CPPQg;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778342553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Q6iAwhurAmWMooLpYPLKn6p5DNEYwrO+T6EQWcMDn8=;
	b=6q9cax5tZkgBi61M307RVPLLdyiK9fTLGClL51V4C26WK7CuHoQdQisJ5DTPnWaDJKSeaA
	SnzAFV+JMJNnRiatHobsapRxKUXwaxhZRtWIG37XB5uKeslg5vui1NFEBm4Qi2nDNMx9l+
	vd1CkyUehEzDw/CiN13gMnhJcvEVAms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778342553; a=rsa-sha256;
	cv=none;
	b=FTIwYlW16sp9n5a+fRanf7Zl3OwW7y7kPadeVEl46iqv0Nd9rlohuRTFzbPR8CJIiSIh7x
	AJMeWlPmtfP771RWHW4N17ID18H19yuJ5h9mN0fWSi+h9/SmiXNd+2FSZitGRORdh/r8je
	PGkhy6d0mYXx761IdGQqjrg/vdWRmJk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Nd0CPPQg;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1Q6iAwhurAmWMooLpYPLKn6p5DNEYwrO+T6EQWcMDn8=; b=Nd0CPPQgOXkEWD3KHSJI9bEIFz
	lWnJZnxFMVHlIERv7TtkeBQXmpt7mIzQpfQDaLDaD7PJ6uJxPlm4WKVoIkK3sIYxPPCa+SLN77+Z8
	o//+JpYDHHzLiOIS/8PT+BmpZvY4NhoMUxjRzBfkxW8IZFbK1KE7rr+pD4bLoPvCgkv9wVf+YKsgI
	E2/rb8ArjxnvaYJoV+FoMInpxHTZskxSAzyu3zUFYvZwkSGe7zlMMxBXPGBmEgozZ4duoorvm0LfV
	pahPUhLZ9eEe15cV0qCTCb2yWvt7zQyIz3MujrB2QRupUHAS/opJSZlAHHIMzrFRXTBdafoWAJ0TJ
	GsEA2kHg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLk8A-00000005iJY-0Pv8;
	Sat, 09 May 2026 16:02:18 +0000
Date: Sat, 9 May 2026 17:02:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: "D, Suneeth" <Suneeth.D@amd.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 26/30] maple_tree: Use maple copy node for
 mas_wr_split()
Message-ID: <af9aicT-tJqohpyA@casper.infradead.org>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
 <20260130205935.2559335-27-Liam.Howlett@oracle.com>
 <c4605bf2-9ac6-4d04-9f49-79643ee99178@amd.com>
 <wnvu7fwch7vbmmngd5s4pcypaoiuzq6atsdh47nhtfo4rccsxi@kbg53gd5en4o>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wnvu7fwch7vbmmngd5s4pcypaoiuzq6atsdh47nhtfo4rccsxi@kbg53gd5en4o>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6ED2E100002
X-Stat-Signature: coyytacsqtpknnz7mtmcauyc7otxr1ya
X-Rspam-User: 
X-HE-Tag: 1778342552-594456
X-HE-Meta: U2FsdGVkX19G96JvXUru70LjacXyLDGXayNIoxiowS14WMOACuUM287B7UKiz+sli+3CEYNryQVOElnsHLiwo4MaEVv98Z0aJRkQaz9WvxjluLx8B1O5wLbjmxaKRT9FZP441uHb8Ly0ZtQDTubIUeBOtyj5H4CLn8ceQkWE60RqMqUNXWe9K7dO4oIm5RZrZSTCvfCSpuKp5iDJNKtUXKgHfvIDOJ4kdflco0jOI+6SEx8TYnkpmvZb0/7T+SvQq+FAbvn+00P5iGlkzIRwD6wGDDJAvqkESnM82x5NL+RNyM6xLvaKEYsLEEzBd4n7L+Jy4QdHUqu2DqOVz4Q+zZvpBlVYTscfgf3OYJGwaNMsJbU4sBBQN+GkfEKq9dgjS88ot8aYcBPL4pAgR+DnfvnViediHfF77i5emq72cHTjP5OLTHiuD2tqmDGiJXbbzQf7MnmTkjTMdUbJOFridP4ul0nUZofQQNXJGhZtvljPQsSZsWrYSZ3AhzS5UUu7YOE50ehUIMf4dz99HoqQ6z9jyRgzKPeNkdkPfAc8A7wiqBUaba8ilLwEKhxmsSVbvOl5H4HX/01qVLstlwXuV6uY01iMubmq+JJ4ktE33SwcHL6SQQ70bIgbeey2h0sWIU3JftUsMee3K34Cj/0GO2AAOXnWWqmd7cQ0wNRTcaDO9lufv2Z2+6Ail8+NS0tGYvet1+YGmfv40pHe82LkMBkJAmbCaTHx+1ks68pL7qO/5xLdUXp23YUS/qDwEMaEavLxYe+EZotR0VfjPazvqMDHgAVWkORNIsl7TzJlP8u3E1QHcYucA7QRErvP5suK3Ptgj06+LK1Ylbe8B8dlaTExyO83i37nn0ZBSLWY2kNbqfbH3ryKoK2DkDUT0QiJUsGyg5GJfQZgh3TXSwbhn0aEfcBUqR9LSuHD27SaSBo04hNaMZxKkEPyZSKC35yrGC/KxuFMiRl/b9aLC2h
 DgI6ds8J
 P5nDEKJnfsI0nOD2bTZA1doIyGWFzieaNS0TLovbfBSm0BPRWPopBmM7F9t/qGlsSVC3ESWBM8Sg5oZf4b6IbDBQDlWldWEugRZLr00jWeFJSJPIBnng+AuduDVPZLrSwgjS1SH+oYWq7kJofI8xQzgWQdFoqEI8KIjcEgTbdKa2dMJedPwyXyDv8KUJfqkSTtjY1hpM7bLSKQ82phkqP0efcfthYHsys3b3QViADgx3uOihptOYYukVVYTn+BOzguBPIRx0UVuPrqeFpkkR++FtVNVjW8iauHwnH772lg6OJ130=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 11:18:31PM +0200, Liam R. Howlett wrote:
> On 26/05/08 02:12PM, D, Suneeth wrote:
> > We run will-it-scale micro-benchmark as part of our weekly CI for Kernel
> > Performance Regression testing between a stable vs rc kernel. We
> > observed will-it-scale-thread-brk1 variant was regressing with
> > ~9% on an AMD's Turin machine between the kernels v7.0 and
> > v7.1-rc1. Bisecting further landed me onto this commit
> > 280b792cac62ddadca2935766ca870b438c86323 (maple_tree: Use maple copy node
> > for mas_wr_split()) as the first bad
> > commit.
> 
> Thank you for this report.
> 
> Considering this is brk1() in thread mode, I'm going to tell you that
> this test is seriously flawed and will not produce anything that looks
> reasonable.  The way it is written will race all over the place and thus
> is unreliable.

I think Liam's being too nice here.  You should understand *what the
test is measuring*.  That's literally your job as a performance engineer.

Go off and read the brk manpage.  Then think about a threaded program.
And under what circumstances two threads would call brk() at the same time.
And what might happen if they do.

"line goes up" or "line goes down" isn't necessarily uninteresting,
but it's much more useful if it's set in some kind of context.

