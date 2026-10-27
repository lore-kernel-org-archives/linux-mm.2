Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB02606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IhwJd0HH
Received: by kanga.kvack.org (Postfix)
	id DA4F46B05B3; Mon, 26 Oct 2026 20:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56256B05B4; Mon, 26 Oct 2026 20:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B8A6B05B5; Mon, 26 Oct 2026 20:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0A366B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:49:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E03AA85A2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:49:26 +0000 (UTC)
X-FDA: 85366572732.06.4E9DD98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95E2F100008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:49:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhwJd0HH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793062164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/kZUclGYQP8NN34Z8XfBgy8oKvHfBFdfanXD9OlfAM=;
	b=7+7WjLcpfyaBmTVkbYx2u/hY8H+Y3TH3VoK24qsEr84hRS45I0OLaPlEGPi5qkA6GzZGmU
	tVquHGgQLb7RPastlL3XANaM/jxv34LcsDrWijLqI4FTYKxviOuB6iKgdw6Z1+aT4sB1mp
	Fw7U5sBhylA/9sF7wx/BRVnKKZ81lEk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhwJd0HH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793062164;
	b=R9nCDFzeXBIfRQk5HW+4ttfaHiLSEV45Xo5/u4Lx9k4TGkll8Chw8vsEXo2JtgUbUWz2xm
	BdyzssCenWxH1Cw8LON/qsd5CQ+fKud+40Mzwuz9Qdq2T9TTo4WMZfvnTtxbCWuQ6WFzUM
	nV4mQ0TCR1FBHsgwc6LD3ZNMpNPGLys=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F005A600CB;
	Tue, 27 Oct 2026 00:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533701F01825;
	Tue, 27 Oct 2026 00:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793062163;
	bh=7/kZUclGYQP8NN34Z8XfBgy8oKvHfBFdfanXD9OlfAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IhwJd0HH7ml97hUAhy4mM+LxrQ2bHSAnxXT5bcTTqCYrKorbjVOfa6aQK448DPZUZ
	 I0UbDVCSy2hHLW5PW4h032ayX/+bDm61VYux5U+fOZd7u5iOR44XnnAQq0KNDlAhUq
	 jHUdbLzFXl4HCeqTogfS6QXU4nSqG7WsHqALzTeQcaDypFzXJjdhjSDGSpkntipz4i
	 UI97FyUNZraeWVxoio6pYIeHastvNhvR7snqnMmzqVCnUvGEO0vnbj6cr3GER0BFD4
	 n1EoM7UhMef2S2pPI2Qw/maUpE2zwjOXsiIqMNgYEkNmbL8RdxlO3rp/V4bemheEIM
	 r0fMOuo2qCurg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Docs: damon: fix grammar and typos
Date: Mon, 26 Oct 2026 17:49:15 -0700
Message-ID: <20261027004916.160854-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95E2F100008
X-Stat-Signature: sho44xa8eq99d8fp86hu44xceyo8k141
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793062164-704503
X-HE-Meta: U2FsdGVkX18oFv2qgz+A5HC0M3QcXUHhW6EhKPzlaZYPh02BXQJrIflOMd1LhTqJAifm7TWtSiIUY4iCv/XVj2TAwBhbA4cb4sqEGeSu4jD3OmczSv7cSFV/nRZ0TGfZUhzrISBKkCdOg971PWDGCoEfnDe8HUsTXgOBwBZtfnUbiJMUqeWFWQapc1AZoR18zLFg2syDHV7HiSO7siRVkfxsghcuWAFSSkp0of8PQLVmnBDkFm/FPGVh2SjTy6baNPciZUsk8OLXiSTDsIodaeZInQoo55wNYXsrUWqnHDDyFoh+OTcGplx3IEo0KM13d3ZP8oOuKokWPmUZa4TQ+BoiMcGq6EIvhxj6OdIPaVAnNPbUrEAtGkHzDqIoEpZs9R5dLVCJYH+jLvXXOXIpmSklAaun95rnqE1MsMvxtRRuWwVpSJBHmjJc12pVok+IV/T9HHIOXthX4Gsap3GQ1yBR5FZlu90rs/fDDXcafzMzIGNDuyn/OeoAtyiJEb4USC81U+EZn7ScHoIAXWKsAHEeyXvdskFo4KQYzVzwrOVeUQ9RtFTEMSO1Jfxi7u1bule6RV/OHVCsOhl5leHlRDnasvHPDKxG31mtK1FgK+Xb7H36bgzRGeBdAVtUNupKRMykSQl4x5wvhGvhPARfyDcaF/qI2dSddH8G3w5coR3RIeiTT4aCty84ZQ4FV/AXZty41leGME4xunyY3rNJO3fBmiNHd6Bv1zMk1Z0mSHF0R5ypIZ3OC7YeD7IfQdPGHHpEbkSSXPKH3z+0qx4d7ppb+p9PR6BsehM+Gve0Hp1fBA8XolZAyVjzTDR5vzq3L8QlgrTjye/mdY0VLHiomZZlsAR5E8FnDGv3cFM0vROceeDiG6vuvtHnRdYr2WX9b7Vp+ok/6hdxcdGVWCA1dni9GlxGxWVeEEV7WZQ7ler8wjlWgOKMfPzqqmiKvfxnH7WCnHeUqS6jSdbOiSH
 O2a6lXi7
 lxETt49X5jRcRbXnJ/zCY4DGfivWvIPceKoziEa+Uol3bt96AvM6pMcSA5WvVZqgFdUyBrZeUriF1YuzsLwjR0+AMwf7lcrdgiTkDF6+U7GNHgx+uMoP9c1JmB7xv8XFzZ3/WHM8W3TBcHU/aPA5zfDkDQltwdtSC+IzDFmM2rzE+quzhTYhIAGutd7Fo8EFFjc3IM9jB6pI1pC8priQoDSUEnLTmsxDcwkP/DqiEupKd21fQPIZa+pFKe7u2qRTiD5ss+ZxZf7HTC918uJa5Yon1Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Aveline,

On Mon, 26 Oct 2026 22:14:32 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> I was reading the DAMON docs and kept running into small grammar
> mistakes and typos, so here is a series that tries to clean them up.
> There is one patch per document, and nothing beyond grammar was
> changed :)
> 
> Some fixes pushed lines over 80 columns, so those paragraphs are
> rewrapped.  Patch 4 picks up what I think was left in lru_sort.rst
> after Manuel's recent fix.

Thank you for these fixes.  All look good to me.

I applied  this series to damon/next [1] tree, together with Manuel's
suggestion patches.  Manuel's suggestion patches will be squashed into your
original patches while adding 'Suggested-by:' tag for Manuel.  I will repost
the resulting version after next -rc1 to request merging of it into the mm.git.
So, no action from your side is needed for now.  If anything is wrong or the
plan doesn't work for you, please feel free to let me know.

> 
> Based on damon/next at 9d301805e3f6.

Thank you for clarifying the baseline.  I guess this was because your patch
depend on Manuel's early lru_sort.rst fix?  Clarifying the dependencies would
also be helpful from the next time.

By the way, I found your patches don't have the usual git version signature.
That helped me finding a bug in hkml.  I fixed the bug, so no problem.

Nonetheless, I'm just curious.  I might be able to make DAMON development
process more easy for contributors if I better understand contributors' work
setup.  Are you intentionally removing those suffix, using 'git format-patch
--no-signature' like feature?  If so, any reason to do so?  This might just
don't matter, though.  Please feel free to do not answer if you find no worthy
to answer or just feel uncomfortable.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

