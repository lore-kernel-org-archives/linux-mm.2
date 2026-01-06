Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B45C47BC6
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 08:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21ACD6B008A; Tue,  6 Jan 2026 03:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F21C6B0093; Tue,  6 Jan 2026 03:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128D66B0095; Tue,  6 Jan 2026 03:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F211D6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:10:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69FC458D5C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:10:03 +0000 (UTC)
X-FDA: 84300815886.17.66CA7DC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 361BA100003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:10:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jrAqGo6B;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of BATV+478378d1af6c37b4ea59+8171+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+478378d1af6c37b4ea59+8171+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767687001; a=rsa-sha256;
	cv=none;
	b=EiFAYfCNQGk3h03/HJZnCs0+NMDi3Lqt6TGS+iTsAiEMMT1wT8kMrEfVW5NjzqIY1vpTql
	44ji6yQdx1oaoQMQwh87NaPrkWIitHc5pvctyJgJd2FAjdPilW7ifgtz7P57DcIw1MuBlp
	HjQQkmBPctiu0a55VM87csXN+WOpFwo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jrAqGo6B;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of BATV+478378d1af6c37b4ea59+8171+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+478378d1af6c37b4ea59+8171+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767687001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GFmCwTRyuNGfoeKqTxv2S16L2bC/ZXZoyaSCbbMVf8=;
	b=QsBJ/sKmU7s+7i5409wlN2CIRR6ps7shtyMy/URWuFSLaQyIa1XjLm4fcnv4wv6gjrnvM/
	l5BzCnw2F8XSSpaFK9fPJiiFaGc7QwW+MV6nnEYA9O+ri6qQw8S/ozuNS4flqz0eDLZQtY
	7UqWPIPIvqR3ER+kawTeE2X50zc/TrY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3GFmCwTRyuNGfoeKqTxv2S16L2bC/ZXZoyaSCbbMVf8=; b=jrAqGo6BXbL26Rq8wf1ArDtOYI
	0GULJB+MztL7y1RH1nY75B9tItbToSpBZd6CLtLSkmCQ2us51Y+EqAcsJu4EsxQSp143Zasb1S6V9
	H032aUonzRfaIueG44Uexf5uGW3bmbYUTCP40ZJaTUQe//XFd5rkpBIx1gO5rWSwq7ISmd7BsXCDT
	O+EKDbteemJE8KXI3iSRpjz9PXXEjX5H9QO6fJi+YKbiWif6G2JdT8F+lPa/dM5skYiGOJuG9H9BA
	nMF60vWv/dPEvWEtFRcJNVcv9fIJj1InnkZJtQh/ALWmAL/A/04IvGaSb5oWDAOmeDWQAWEfzg2Nf
	z/izbmsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd28d-0000000Casm-2q9v;
	Tue, 06 Jan 2026 08:09:59 +0000
Date: Tue, 6 Jan 2026 00:09:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, klourencodev@gmail.com,
	linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/mempool.c: set @elems slots to NULL once freed
Message-ID: <aVzDVxhLp4tfAkKk@infradead.org>
References: <20251223231054.16061-1-klourencodev@gmail.com>
 <07c4f991-ae41-456d-8e7f-287bf8676c9e@suse.cz>
 <aVyqPfnVtdAM4HYY@infradead.org>
 <e1f271a2-6215-4d16-b17b-45ff8548f8b3@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1f271a2-6215-4d16-b17b-45ff8548f8b3@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 361BA100003
X-Rspamd-Server: rspam10
X-Stat-Signature: udo3pqkeg3ugt96w64rxq9384tszictr
X-HE-Tag: 1767687001-968849
X-HE-Meta: U2FsdGVkX19eygnNVyvvhGqE/0VBme0slYl31hvAA7JkTkpGWrFlchZe0mAhOcjSjGyXJL03vPjycDL9By/qlY8U/XV8Nc3sJlfOg7WXtZIwrE9beAgNFqNyy5xwro1bOdivehfpwdnPIZAefMEJP8ecj2C5qwFrLyrbvSXmQ87D/kHL12xhNfPP3O6pj1iJN/tBg2+hefRy71/3LuI+vLORBkZnKBDNfg+N1XEODzrHtZadtnX9sMzssMwgFNlYP+TimQkj63ilMLb/SZx7XwK0gwm5WfbbsqWf0yLnrEMjhKV8yh33dxJMyz437rxU8oDbQgK4fKRM2lnnnsvIwhbjvlKnLr5dIfpN/MqcGEqIsiTwylGyMSnDR2L5G4A3BLJiGehN5al2F9yoP8TR1txmHvhtNuEtjWFLV5P+i5mBxMZ2THnEL+CKppJzt+XwmRQ7pz+wchP74GtGrEmlCPvdEJ9FTWZHpH5017tVxGsgFYUOT7uyJNF4Ycrhz4faUYcTeXh1LMgBuE1+O9IKdqsr6chAfa6pjfgQasL0DE/1WO+AWaMs1JJ/d4V+34yRWprysanDuwo+i0h97vR210osK5OsoUX+pYrm+wBvFDd3LFcjj3ukj+mgo62TZkAQ+SPXDQUGB68BvoXhVEenjyv8ZeXS+FV4aLJoMrZ3CUBiWy1o3bo8EUu2KreDyagLJYhNLjKtpMQLELbfZarkEvpHBJqr8bBc+eUuYI+GxohZjFkz8671lsAvketF4oBiwM6iFe5qXj7r1MX7+r1E0JFaowODDq0jnpdntFBnR94CFzI1OWcAOtScd11ioAxtM2XgYkhF99onYpi1OvLS9bJys+ccgMyXiqu4i6UffoBH/Hj0vsvNVvi4FoAqIJ5wabXFRVotSazj658EaViIiy/edm4ONph+N1JENUtRBDIXhJ51aWt1duZDOSPvSLlQkphsGld6szUZTq9gDaw
 Aeqw7SiM
 XUMorOOhB09CMxvrZg/iCU9LDEuQ6uM3KEwe4Uyr1sGtVHm6w5BDlHW/DLQAOX5AiS0jGVko0ntbJJjZqK9RQR3C0b56mNLnEZ5SCe828T3vD2Vo6Ck/BNn8NOw0fH49OJ8E6fzy1g6nvFU3ovTS9gvwT6BdAGndVwAUs6jard3GXjfxaO4R99S4NKrqJ2OInqTO8LMvbnVC6WL3O/U93+9+4e7GvRux4PUnOd3jsjaaGBFGPvPchUVXst3JBHGg3uRMH84igq2IWOqKrGfJFqmQ7t4bF2dkUtWVglMfHy+y8V9XUxVik+AYz6YWXDBf+jCBzzMa2s4EN4T7RySZfydVK39JL5TygMTs5AT62teRmSPQE2Ru8YRci3c+oTC3fLtjxOst4EVwe9NSjcKegVBG4VOO9bEanVNEpHiqxMB4n2TTU5UgpR/8gXyKIW0jSmkYZyRYW3jIvs4xOvin4dw6SRjDK8tG1HamTBjRBQE8mJPcysUZNbFgV7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 09:00:21AM +0100, Vlastimil Babka wrote:
> > Not sure. I hate the magic null skipping behavior in
> > __alloc_pages_bulk()/release_pages(), but given that we try to stay
> > compatible it might be best to do this.
> 
> Well but release_pages() is null skipping but not NULL creating?

True.  Let me think about this a bit more.

