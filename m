Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2ECC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 03:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ADE96B007B; Sun,  9 Aug 2026 23:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35DD36B008A; Sun,  9 Aug 2026 23:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2761F6B008C; Sun,  9 Aug 2026 23:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F265A6B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 23:13:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44D8A140663
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:13:18 +0000 (UTC)
X-FDA: 85083888876.25.B14C942
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF22A40005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:13:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=skIQAoNe;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786331596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2a1dvpSkcRACkkHB2Cu1hgAbZL4dDEVOnuwm526Fne0=;
	b=PBW+ramOhTTgnPn7M7K+fdg5fYa4l+pKg3qSoRadiGaA3NiTOrKaig6rH/n5FJ6FmpEqw6
	i0bPiOBhFZY35Ha1qikfZzOCuBBB+fs5y2uvU3HvQ4Reec54QPJ8yI1oEUkJNV19VPYBxK
	P0taGpW24gidlZRn8z4Azv9HxjSBxcM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=skIQAoNe;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786331596;
	b=h34e0gLrR/QAH2gaVK14HONjUrdcvFttnox8suS/Ded6QsiFoQCmt+Q2ywHpdgqss2DJH4
	7ZNeZhxBNAf/sEXlSlcIttLZvWmkJDavQm5K6U+Hr5drjiH7sWHiWf7cvpJn0UciEjqE+r
	3iCN8hpn7N2H9zI2XXzhirFQzpKuue8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2a1dvpSkcRACkkHB2Cu1hgAbZL4dDEVOnuwm526Fne0=; b=skIQAoNe8lRYuzKoEm3eay3Z5V
	iSpC+Oa23X2H4Y8f7fhcOC61bk/biFrMd6Mn3SRkgekSN6U4puQUF8b+5HouSwG09LE+QbF/fKwAe
	Glm+zSCGreKBsYnoKoRK0yCc7kAtcjG+xQViZCFZDjQDLBtYf39YyPPEUXiLXwrwoVsLnm1AMZwv/
	prOHAaHMNswVsmgD7iaWZBlsHXt93DZ1Vtx6as78ol9Cblkn/P4+EclqWQrczH0H0hcRg003dmYWM
	BlLVaaHKn/drAuWYFvdvi++jgZXLmWeeKUtBBQ0fXuykt8+je4+i6IlC4Ie7zXVcZqQmjcCkf3tUj
	dDyznD5w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtGRs-0000000ABKb-1O40;
	Mon, 10 Aug 2026 03:13:12 +0000
Date: Mon, 10 Aug 2026 04:13:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ayhan Aydin <nsd.project.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache
 prefetcher
Message-ID: <anlByPDZmvEhWeXI@casper.infradead.org>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
X-Stat-Signature: 744k9jjddqt87dx1da6xmka1w67yby63
X-Rspamd-Queue-Id: BF22A40005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786331594-444978
X-HE-Meta: U2FsdGVkX1/KyJnatLkVVQoFHKXYjb/vZV2s681lyv6CgXon1MXnPvSDBXzYILpXo9RgURpuZnXWzxmuZr4IyEVDGnKeZlmP4NUN8pNaGsLaaaQVr0kRbj17VSHEm8cNg8NpO7wIGgyRSlDlzSxj8q3bdO0aO73LLWHlsYw8Ha6Ea83s1m7iIttQG7yId7tAakHu2OkmSVBWH5Gi2xpKnH3wFvJPzWvVrauLl5brl6UVCTWUsP/fRLhYpS8qKWTmLlZ8EYVREGt/Mnf547CHdOvfFlYK0REJKEu+XEGuQpbVhOQYWJObSKy7N3YMt36feu028cSTaoXvzZwVvf/zTwIzyiF3vCaskgE0hYfbHONmnnzSezQyh5CXuch0xZVB3XCbFDhICISEy2VRceeRFyTEkw0C8VZyIg57kJclh9tIZMaojxc3xAt1bznxixAHh2ku1S1vpENy1pLk9IYBa+wGcOkFvjh0+0HlRx0I2IXI8/5lX5U9V7I4lYasr2+mhR6FntaMfyeT3X0WXgN/RYM6TzGHp1auK5uEJAn7UCvxTg5EavRvNf8KVtACNq04tWvdG8NRZa++5XkxaJPKSlwV4sLvefBOqQqd4KzaLmzbU5JeLgpBdU+VCW9/ls2wT5pOmcfZhPzjlgxjsxvPKEYY4JD0a0zv43o4U+6GlLH+nPOY1jo7rqx1jLQbjmmqhmFDeAMRKblcAteDKTfcG4BCNl38LzPK8XI6ujP4LMet2WcZvwJyv59ae8cbuU/EJDzk264gJdD3FiPHqw5n0LAonOBcwPx0qpSBEXDP337wbs8SFzXeh+0RbrIc8XyQe4mLDZMD1sOvRKdvu1fknYieUU9J7HGiSugMRaT7F2SygfmNdoEm/Y9dbDqR2Qfi78YlD9rjONKS4hIA56IgDpfV/XQlh65t6qYSxm6jrSRyvFu6/f7r1zR64YuZP9JMfciqJ01eqmbZogTw2px
 2dSZiCcM
 y1udx3LL0EVCDbz/pIj90p9mC+QgyokaKi1w/8yyTddsFV+/JdQUka74AjXIkQ/VdeqwksPm1Vn5cEsYNqzsLrvhBnkJz6d0g84f1ERB2Unrb42hADiU0Q9gTGLAXrDyvAJwmH4hG+Ts22aOXXEbMJBsNa35vk3sLpebvbf2AHnQTbsMQcHdgxh1v93eleT4K+1uS+C6Glps1+viqJ+AyLNiYryg+qYzbSC78MwIh507kSZSkXAuajin0+3Rt0zVRhimO9s5ylqGbSKWapfGNeSm8o4aAMOJ2eeJrezOxJ8yOKTQnLVQLDDXiPoEsJHEMq6uw848i26zDG5MfkotDcI3kxotJrsBAAjo4IpzYJRllOBPK3PH+Vy4iWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 05:10:42PM -0400, Ayhan Aydin wrote:
> Following up on this RFC submitted on 20260725. I understand
> maintainer bandwidth is limited, so no urgency implied - just
> making sure this didn't fall through the cracks.

It absolutely did.  It would probably help to cc the page cache
maintainers (Jan added) and the fsdevel people.  You can find
this information in the MAINTAINERS file.

> For reference, the series adds an optional observation hook
> (CONFIG_NSD, default off, see PATCH 1/3) that does not bypass
> the existing ra_state / file_ra_struct machinery. All actual
> page insertion is still delegated to page_cache_sync_readahead().
> Benchmarks (interleaved ON/OFF methodology, i.e. same-machine A/B
> with repeated runs, SQLite full-table scans and buffered
> sequential I/O) showed an 18-19% wall-time reduction and
> +22.6% throughput improvement respectively.
> 
> Happy to rework the approach, shrink the footprint, or
> re-parameterize the predictor if that would make review easier -
> just let me know what would help.
> 
> Full series and docs:
> https://github.com/nsdprojectdev/NSD/tree/upstream-prep-v1

Let's call this a good proof of concept rather than a merge request ;-)

Architecturally, we're only hooking into the read path and ignoring the
page fault path.  Was that a deliberate choice?

I haven't spent the time to do any detailed analysis of your code,
but it feels to me like we should be doing something more invasive
and integrated.  It would be nice to replace the existing mechanism of
marking folios with PG_readahead, if that's possible.  It'd be nice to be
able to detect backward access patterns as well as forward access patterns.

Let's have a conversation about what you're trying to do, and see where
we go next.

