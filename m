Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0D5CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 15:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA866B008A; Sat,  9 May 2026 11:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D19D6B008C; Sat,  9 May 2026 11:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E666B0092; Sat,  9 May 2026 11:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3209C6B008A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 11:38:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB6A8A015C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 15:38:31 +0000 (UTC)
X-FDA: 84748288422.29.A7FDF7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 226A0100003
	for <linux-mm@kvack.org>; Sat,  9 May 2026 15:38:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BV0JRQJ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778341110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCfh8neDU94PlI0JgatR3Ag8hjVp39Yz49+YQCjqgt4=;
	b=iPNTX2FvDC3paBenIvYwv0XFfS2VX0k9e1jR5xw/Vh8PHiZITAkHryN5Af3+c/UkR7G7g/
	vGgkLCwC/vq3qbDhy373xMIamH1KDkBHbBPOF/wum+afhAb/v7+4Dy+ohQ1BMPy1HOWXWx
	ObpK5VdV5AC/NNdfUdBVWTlQZgyq45U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778341110; a=rsa-sha256;
	cv=none;
	b=e2KeIWvXvj8t+nk+bKJLas/Yy9VCs6fsfCgWgm7jHGeos8uukj7DveWRs/jfpCWK+DiTXu
	t/fwvrvZ7B1Gna3IG7Zpuk1C5Zbb1ivkRDyLEtK2pCiTRXyDYhd+CUEhc4+QYFdyf8ZYGm
	gCS9GPSyRQhq5wDd23QEUPSJBw4/ra8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BV0JRQJ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75BCD60120;
	Sat,  9 May 2026 15:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA10C2BCB2;
	Sat,  9 May 2026 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778341109;
	bh=Vufti4SPwTu2U4ZbGiKAO5NDlhFAodQgLsDR3b5I+S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BV0JRQJ+BDS2BvkoNrSeLTwkRED/1WEndvrgXXQ0Xh7BCG/ZyEp61dxbIwgHOtshm
	 oEiAcXoPKD/cX0HOfGkDEujHZz23M6oKwf8/tTSGIW+HGiI+wDGKwwfbB1XcGVQoJc
	 3NHqdQLlbQR9GkhqiaxqzXv06yQ6TrAi6yxhX7fh71Dk+8XVO2nvHrlqvNYp/D7sPN
	 El5W5fVTC0KQRJl7k42F5D3LnCDgJLMdsodjIdgcJOOroHxaYuXKw/L+JuQr8ocNgY
	 aXlAO2UVLMd6BnO6Vxu223chnV5/5s03Ga8nHQBHcFcUQD1EsG4BMMC2/aIvl7rk1c
	 kQ7FCJ2JOZBKw==
From: SeongJae Park <sj@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] maple_tree: document that "last" in mtree_insert_range() is inclusive
Date: Sat,  9 May 2026 08:38:21 -0700
Message-ID: <20260509153821.90161-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <af7w0Zly7Se5my_c@casper.infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 226A0100003
X-Stat-Signature: 9kdojfpo4iwiyk8r1k7m8s5i5wjjxqth
X-Rspam-User: 
X-HE-Tag: 1778341109-10528
X-HE-Meta: U2FsdGVkX19hu0Wi7O9k2ujfo8EdSjL5rPvrX7Y0xakHRHv4uTP9+5mjTba+ItY7xU2zv+L8aTG+V0nB4mOpKiAlpvI91QqF7BtBZXuL4uJ9Jw5TyQnD8SwnZDIKApPDRVVTLepvFUNvL3cnFWZiOXCRw3YC5UiMaPrSPP7WL5wncpFC37nkltntAP6iR8cvcHJU5l4gm2RAaoUHV0oGbuq+U0BXgKKL2xnMGQi7cgQwR2bu5un0HbOtOjB5AzqNSL3IylmHS3j7H8Ra83C+zkCZeNr0uxNPDmhz16cMGpVj0kWoZACukA8opaCXhsp0pOMLvWcEkBsBkTh5xPPZtelh37NR5awJ+hcKaA1gAoIxkUevgxPpFTIanym4td9h4VkdisXOSD5hd+rfPnDsmoEygpI2nxlzN2MH+yFRGmLyhlS3Zn2NR4K7gGE/tveWJ8MJO6BlvVPKFJwXkoJHHGNTllevfhJLtE/aB68adXbLSiA4OvKwQkrkWtqEEss5ov/3AAu7XC17tqk70ZKTzDSK7hEy48bdgZqW8Qh0DiRsKiBxB4/kkNaAFxy0C5t7VJHkIPMVj0tiLenhxtcW8tdammv3xzEUEK26iD4sV5BLh8wgCTs+uIjfF/+LxMhuPb4vo9VrCdOgqF63jEahVlScqwrPf/kRjKAfe0qGJpCme8AkgI/s4PpX92TmjMM6pPAe2ijREBvaBRyICfl3VSH+p6ytHcZBUG0qUDrykUwcIBDVKnzHwbB0pzUsNPhA4VyWv++zy3h44hh9MEMkvJkBnsW49NNt5WLC2O1CWa8jqWf6xPrtxHSvTLzcemcSV7EF6jgXx0RVySWEzd2WEN3v34oWweUNkbtAiJgca53tviKtKrDFtdUWdP1twUiLM78Jqob2X+yyuU5eExKXDaB0Rd6XZDkpkVhHF7xb7m+M6PQb8qJ5/vvCnPEvS+gDQJND8E1GqLcoLeJ2f2o
 AvLv+Fcy
 djcjyCoYG8l+/hYybeA97YDNUkG4nTUIoSvNHAi5SoM3i8dqbpyEZfsunANcX7IGDbIXr6Gb6OqZgJKbbxnU+tW7UbSeOo65tvkKJpJxvZBBYU0AyEaJ1IFjAMCBN5Y4XWPYs9NDkSqsCetnqVOKmwvFBgcboYdK8t+85QS969yF4tEb1SRauM8UrEu85rp2XQoiQuykcSW6g+dAlBLzilcEP6O4VXpvf9FfmCAZMtsRl1HnEQ0kJiijJnSBtmvWaFs7Npw++SGXClVf0RgqqaDpT3uemt91UamPfwbx/QlUyO7rvy3ywWjzCaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 9 May 2026 09:31:13 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, May 08, 2026 at 05:59:46PM -0700, SeongJae Park wrote:
> > > > * @first: The start of the range
> > > > * @last: The end of the range (inclusive)
> > > 
> > > 
> > > I like this.
> > 
> > +1.  I'm also wondering if it make sense to add '(inclusive)' for 'first', too.
> 
> I can't think of a situation in computing where we use an
> exclusive-first.  Pure mathematics, yes, we might want to express a
> range as (1,2) to exclude both 1 and 2 but include 1+epsilon for all
> epsilon > 0.  Maybe I don't work with floating point numbers enough,
> but I've never seen a kernel programmer make an off-by-one with the
> start of a range.  End-of-the-range is all too common.

Makes sense, thank you for sharing your thought for my silly question!


Thanks,
SJ

