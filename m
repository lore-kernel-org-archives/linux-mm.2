Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 872CCC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851C36B00CA; Mon,  3 Aug 2026 09:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829916B00CB; Mon,  3 Aug 2026 09:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F1E6B00CC; Mon,  3 Aug 2026 09:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48EF46B00CA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:34:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CA2BC06BF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:06:56 +0000 (UTC)
X-FDA: 85059680832.14.EAF8E8A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88F041C000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:06:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vOthG177;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755214;
	b=4Ta3EsFoidONuwedT3TvcyYUeP012eWSIJm3ukkmjkcCxUg4nG0PwbH6I17Ueo4kQOkbhD
	HZUj1mSEW/giduJOL21Os3kBxvi5cHo4BWGMgahuv00xV1tBjRTqx1B/Ov7EbsL7iIFRY0
	Fn3itvGmRN1MVbwvQ+MtLo3GKcRzZHw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vOthG177;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81qwzNTYWMH57csnsJHDHsY+d3QIwovJXwJEW52W2EY=;
	b=T/H5ZXxaMKPEfG67e65y5xw/t+uNCoZv9xGcZlJ2mVt5LeW2a0fGBiWuux+IrEmE0rK9DH
	KcOt200YHkDZn5neJhMvUgbVJIwoYsuII2wiEFnHLwVySnTb48ZacK7Z0q2OOysNYsN/S/
	/eD3l3Y55ltYJZGeLItnLLJ9oCDNSIk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=81qwzNTYWMH57csnsJHDHsY+d3QIwovJXwJEW52W2EY=; b=vOthG177CP1M/oT1M6SJZjIpzy
	g0Y6kG7i9eIzJVHzoV+I/pdo9uGUQiMTu3YTCAFDea1lbOUkBQrzfcKWEfQdex5mH0BuKqlcwG9X3
	2KhPAvcAkFcZWpu5iQXaOa5dC2J+VbwxWtKUHYtNJN2OjUSdsH+x7RmsYwbveHj/TGJXXBaAzJX7i
	mDIoIJsde1UJmtLbG/OU7Uuez512H3sE44q8JC72i75AzEe0iNLui9lkP73ahxJIi9Cp3GDiuih8a
	pEgVO8L6hzGDR9qYafwlxXPL7iuVermx7D4nCTJVqujOvJgwO5OWmsl0Mg0/oU5So1WXMqfpcHu6c
	+8IKoh6Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wqqV7-00CJcO-15;
	Mon, 03 Aug 2026 11:06:33 +0000
Date: Mon, 3 Aug 2026 04:06:28 -0700
From: Breno Leitao <leitao@debian.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] tools/mm: add hwpoison-panic tool
Message-ID: <anB0-xHoQpQzp_dK@gmail.com>
References: <20260731-memory_failure_rewrite_test-v1-1-6aa8c6435693@debian.org>
 <20260801005822.85110-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801005822.85110-1-sj@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: x4kowmhup869ytminb8k4kg7s1eomqc5
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88F041C000E
X-Rspam-User: 
X-HE-Tag: 1785755214-279942
X-HE-Meta: U2FsdGVkX1+aHib0/Ulb9zdua3M0oGTZkvuiUcTMuZZ0TiTQIsCvH2q+Tb9waunJTo2FQORZjF8XA9oJmZZ2PWlgmzUpnGcVIbctAZG9ild//uMkLmbq5F+k9N5iGNkaIrtegzrRYbENPd8UqsMfci3LaY/XqFWmhcpKgAgIwRgXMW+FFtSqjPDz3Q2WunA+flh11Sd1eqYl7nrEvaJvYbMg492KG1W0IsdohhQ9UmQuW+Gbl6D26ZHU9C0YTMLz1IUdnUnxi7t3o4hq05NxeS/CtiBxov+UmFagEqU0oOd3u4ynNLr5kgB9dvyo8SUWRm69VWTe6Gwx08jRBjODPSC1RMTgAlka2bDpb0AJ5A6T8k1vn10u2WF9Aam/sZDfwpT0gLHqr7RbMR4E1fjSL0rCZMBtdHXMDeZ+4jit/WgmxJ1dD6yA1L8b4h230RMb4safkmUYBSUXhsQTJejSQgwogt2x8BH01u2MgSGhdSPUnQyWMA4iLkMT4xU5Jul9ERYnBG2xLwmzqk4rPp70IM801pd9NGO4XmrY5qlwvtBkx9sCWqVY5LJSLbxOvVgpDoHRQVjc8Bh+vf2w0fSiPI8sZ2zXQ0OW0owufRd5bMx0VwRIvyEfLWSW+JjaY7eZiVZQbKpjwu+PVPwQbo9TceyTqxB3H13Qu1gEJ8IxfG1TAv4ujESLw+V1kMGsHvEWcq2lWNvuTh9JWfhl/AcewWIr3kQKE2zA0nkOfDqlde5uAv8ZyyxI5jSkhNUq7CVo30UGRsRNHBSV0+e4JFKlLvtJiyGE4AUbzwoc2Jk0uPftnPwmFcXZH171FCkiMhIKSAOq0fyOXa9VgajvZ575GR9HNB/hgdoV60juhWoUAoOiG9hhYW9K+/DSy2NGCEjq2pscYv12fPSsh8jeWDjIaI9viZumyKi2WMwxvQOCAigsQP6il4Rw/4j0Je5hmV3Bql6+nNeOsaW8Hl9+/2N
 RQLyJQx2
 w/IfndtXtnB1aiJ6rXLNeC8QpkiI3fbt0o8EQ9Ne5PL0S1xj5Byy8BRFQ+Oi6uz/d0FaYH9Ie0pOg7SotMHuc9rXMvthADF/REETI8slST8C07l+tn5M9t3myJ3h/pn6B5yME1EmculPLOPrBdNVBvYTElTbHBNhb4uLm7ThJgG+zm3FyQigLx/MyJaEj2RtSJ5YLoAxcewSruZ8oeG0wz+FQac6OHnniD1g5jf1AjkkVvAcM/vkaWR3HWQgGbjrM86S0/HoE4e23qyyECannK1/XUl4l1DIrEf//6JT5VioVExjeGA/wbATth9E0oJcuKxouHMGO+RONGs+3Fn+aMbBuhtPwe+tRE1Km
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 05:58:22PM -0700, SJ Park wrote:
> > This lives in tools/mm rather than selftests/mm because every successful
> > run crashes the machine, which is not something to run from CI.
> 
> If the purpose of the new program is testing, would it make more sense to put
> it under tools/testing/ ?

Sorry, this was discussed here:

https://lore.kernel.org/all/f83d5b26-b369-489b-a305-1eb5ec6fccfb@kernel.org/

> Also, does this test really need to be end-to-end test that cause panic?  How
> about doing unit test of core functions, using tools like kunit?  Or,
> live-patching panic() to only print messages and return before running the
> test?

What I want covered is the wiring, not the individual functions:
get_any_page() classifying a kernel-owned page as -ENOTRECOVERABLE,
action_result() reaching panic_on_unrecoverable_mf(), and the box
actually going down. 

Under kunit I would have to fabricate the page and stub panic(), so the
parts that break would be the parts replaced by the harness.

Unit tests for the classification helpers would be worth having on their
own. They would not replace this one.
> >  BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
> > +BUILD_TARGETS+=memory-failure/hwpoison-panic
> 
> I was initially thought why not underscore but dash on the name?  But, I
> realize it is obviously too persoanl taste.

Dash matches page-types.c in the same directory, I am happy using
userscore if that is the rigth approach.
> >
> > diff --git a/tools/mm/memory-failure/hwpoison-panic.c b/tools/mm/memory-failure/hwpoison-panic.c
> > new file mode 100644
> > index 0000000000000..b8076d86da15b
> > --- /dev/null
> > +++ b/tools/mm/memory-failure/hwpoison-panic.c
> > @@ -0,0 +1,353 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * hwpoison-panic: verify vm.panic_on_unrecoverable_memory_failure by
> > + * injecting a hwpoison error on a kernel-owned page and confirming the
> > + * kernel panics.
> 
> While reading the above explanation, I was expecting this program will directly
> say me if the kernel panic-ed or not.  But this only says if it was not
> panic-ed iiuc?  How about saying, like, "Trigger intentional kernel panic by
> ..." ?

You read it correctly, the program can only ever report the absence of
a panic. I will reword the header along your suggestion for v2.

> > +	kind = parse_args(argc, argv, &force);
> > +	page_size = getpagesize();
> > +	check_prereqs(force);
> 
> Maybe check_prereqs() can be called before getpagesize()?

Yes, nothing in check_prereqs() needs page_size. Moving it up in v2.

Thanks for the review,
--breno


