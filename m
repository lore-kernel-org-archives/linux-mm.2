Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EC6CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 12:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BECD86B008C; Tue,  6 Oct 2026 08:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3526B0092; Tue,  6 Oct 2026 08:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD97A6B0093; Tue,  6 Oct 2026 08:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B92E6B008C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:33:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2600E16018A
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 12:33:27 +0000 (UTC)
X-FDA: 85292142054.23.60B1942
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80C92A0003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 12:33:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h0Fk7FAb;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791290005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaBQXt6BAEwioRHAlv69sr1PP2qIDJgC8v1Jn1ojm/0=;
	b=BiXAbBMsBWONdmwFPnjLoV4QvnMw1OGH8zshcg9f5uTV3X2CQPaK8ZugEBXJydSF102ifz
	m5K3KDTH72t/PCxRR90+4oEDMWEUM3ZSbv9WfsowP6y0kzIzSv9zXUD4J3HxEOm2mxcRqi
	zy1DqH1JdIgn93h3V4yZwXVNlq9wh/I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791290005;
	b=j2p0DCETpLqPgNOMatF/pWSJUHGmpp/OztSuwhiR0HICt9kCfb09KOqMpi8jeYvL54XzOf
	zdb21IRcN9nvNomBag+79JrbLlF5eYkWijF1ec9oJxvQ/BBB/9a0UcdhIKMfmkR0ZKsWsq
	iD5JVxj/C9E932agOyLLfjyikKgi74w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h0Fk7FAb;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C67B6022C;
	Tue,  6 Oct 2026 12:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D9D1F000FF;
	Tue,  6 Oct 2026 12:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791290003;
	bh=WaBQXt6BAEwioRHAlv69sr1PP2qIDJgC8v1Jn1ojm/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0Fk7FAb6G2QU8TP5QP6Df4oU7KOmFNEPXnVkxGXn1ctfXOiKGH0dOOay6nYD+ZY3
	 sRYMUixtp15Xi+EtkAzidTbGMecS7m7P6+fWOHnWJztchDa3gcoUUW2WHlEg0Fb3xT
	 qV7yY7GxlVUqWa9X20gxwB/5qKiyV8PFyuRNv7MiQbaDC1MAZV6cIREacgP4T5V+f6
	 /KijtiWnRp0SzbcQ3ev5JarNjnzwscQmHlPyUXGqTk7slNKgbXvUBkkfS7KtY0suVl
	 9Uc726ShyDnmP0B01oIumZq8FE9OqRh6a+LI3OE8UvY4xCbXbJ4m0Sm9W4GM/D4GPb
	 oqE9FtO63i5Og==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ahuang12@lenovo.com
Subject: Re: [PATCH 1/1] mm/damon: fix typos in comments
Date: Tue,  6 Oct 2026 05:33:18 -0700
Message-ID: <20261006123319.45800-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c2c4279ac5948b1debbe597eea1210fd667801f6.camel@mailbox.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 80C92A0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ym7pqb8zdxsumu5hfwk84n5b9hhdiahf
X-HE-Tag: 1791290005-678630
X-HE-Meta: U2FsdGVkX1/tr9iqmZokp0+Oti+yoyrftQjIarTRru83edX5N40OGUfRpqL14tbKKzFQ4NC6fUjwn1OD/wxx5mo4JbD3NmhdZvXN7ejBmC6NpZTXMY8dJZtfRnmUsv8U0rVgTdQLGSk6J8cV+maInIOfgDewLLToafl/mETyPufifOz6bbsWlucJT+ZCHpXJGnGY+/Zy+Tjjy/o1ezYbk4NDRPiRSm1dVywAHWmTPGs+IRInoh8D77AR/BsLp9QTYflI5I0Q/VCHfG6G9bolkkNu3xTB9JXG/4v1Tbh6GH0yqBZ0DUS7H0gwDVZyWKs7p8iveCZcfuV2cwCprvpldk8kmIIZMj40UJAbRRrXcgixa4Lxp7UfEo8hKOot2+Mj4ptaX76zfjMR9b5St/DAgywW/5omnoRTHO7Ea5vKIeG3PNH6019vbvUVbRCwlABcCawRK6gSvConquYOOLT6w+xTkJ4ZJDW/C55aj0kGE0fU4e2FZLYBg7gjZeIOywBYqGYD5aB4slMByi+Un7F9mdFkP7F8n6qElpCY9lNWM7yYUcSKKk1BQQ79csi7UwUuRoVSV4kEWn3ljAOKeGD59byrkK/wrGuIxK3KpweUWyDEt1j65RW39NKSOt/2Qc6EntkAj3fUycvzqKB8WIefc8ESJA2W6EmmvnIt7AmQzx8dsSEdCr8vieja7qmeAX2TJeOqohIujBrfJ2+PwIoumxiP2ZGt/a6Ql3Yl5lvlyrF7KQEcUcgb6Af+m+dqNGSX0eov4pwnsu/Bp+uF0GZJIXO+HlqTJUPJY+CPISkRcktHO9+xWFjAHGqAxnbuLCGZRGyx/0d2XNPtTWIjNvJ3Qd+6DYToS4HLbolyQ2brBDQHU6hJDU66Y4bscY8YZXh4328EzN4Qylr213Cqbg9IxRI7XgGSItQbJP45LTokobbW8t10v/EDVmFMHF6OM041dC8mLF6GE5FytZpKpPj
 1jHsRHPj
 TPZgZoPVy5ZgYurqko6lbZO8p/x6/x0y0rYYoSD2myZWgvelRKgslFuvqDJWirYrGaBhSpkaVSmtKDcL7VL+5MR2/SLQAFHxK3pAxRiLnohczh1F9AIJK22aIibUIVRbAlprPahlpOSJ/tR4RaZXI+KW0k5ceUwTVCp85IRbDD3Lvanj6vztzJnffDMBobdPRrcg7+G3ZNwB2dWZNSxOyXtuV/hQvesZ37JbukVexNSjly8+ax6xa7j01XOXpmkxFSxCKlatHm8U/bXDXEdeulSIes68hAYAutSWuw66DcFnpr85de99ru0Wpzn2QFIkW93J6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Manuel,

On Tue, 06 Oct 2026 10:38:38 +0200 Manuel Ebner <manuelebner@mailbox.org> wrote:

> Hi Adrian, 
> 
> On Tue, 2026-09-15 at 18:27 +0800, Adrian Huang (Lenovo) wrote:
> > Correct spelling mistakes. No functional changes.
> > 
> > Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> > ---
> >  mm/damon/core.c     | 6 +++---
> >  mm/damon/lru_sort.c | 2 +-
> 
> could you add this changes in this file?
> 
> DAMON_RCLAIM -> DAMON_RECLAIM
> 'set as' -> 'set to'
> 
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 0c98f7e267d0..981a153619c0 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2447,7 +2447,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
> >   * This function checks if a given region should be skipped or not for the
> >   * reason.  If only the starting part of the region has previously charged,
> >   * this function splits the region into two so that the second one covers the
> > - * area that not charged in the previous charge widnow, and return true.  The
> > + * area that not charged in the previous charge window, and return true.  The
> 
> Please make it 'area that is not charged'

Would you mind posting those as another patch?


Thanks,
SJ

[...]

