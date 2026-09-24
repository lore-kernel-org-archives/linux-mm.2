Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C854C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E9F6B009B; Thu, 24 Sep 2026 03:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEE96B009D; Thu, 24 Sep 2026 03:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90CF36B009E; Thu, 24 Sep 2026 03:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72C0F6B009B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:33:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10E1FC024B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:33:43 +0000 (UTC)
X-FDA: 85247841126.28.92FE14D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6F2F11A0007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:33:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fhn+7D+e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5Q3QsVfjPbwHPredQl/X4zsaUQV/JInoABBnQSnw6Q=;
	b=n+adYvq5EuUAhwuk+hFsf24BoZgPLfYtt18i6RV6N2JUTrLHuL+CFPh/aE2cr6+HxEo9uk
	5OAmhz0li0LnocG8Xvv1KF+fa6XD7Kj6gCiN+P6dY/oahqF6K6mbQ8IizzP3TqILvXK95K
	rvOXSgrPx/9CBIIwRs7YiCzUcSHiQwA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fhn+7D+e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235221;
	b=Le4x+OxsDd/Vi4HnHxxbEudgkxnEVrmfqUteoWj1natZewnU8t6Fkn/u6dpyagOEPGR5Q1
	0lfCBay831EZ36VMgXat5wz5fZJ0VUCKJYuFE4YLC/m1PVJv2w5mATpfmLPvQj/QydWMW/
	ZtuA3MbJCwtYVTGih6o3t0c5o1Iwt0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A2904152F;
	Thu, 24 Sep 2026 07:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536641F000FF;
	Thu, 24 Sep 2026 07:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235220;
	bh=H5Q3QsVfjPbwHPredQl/X4zsaUQV/JInoABBnQSnw6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fhn+7D+e67rHaXPDUh3AOVhf7mjueV2X8n8PyxcwU6Fv4wFT6wdhOGd/lU5omuykW
	 kTROp/SUjTAWT7Z2enCDG26KMlM8sVn3XkIk3DELRNUNSymlZTstHKGXcG52suoWP5
	 6WaYxmeRGb1+NKg5yUr7hZvMJW6iCjQkdEaJmQRwfNEBp+8GoR3aUbc1HB1iFNbMUE
	 ahKcDVy+pEcMj/ES2IqXrD5OPvrYPwinxceNF3Y2qyw7uP0U9SvEBdHa5Mh90gle+3
	 LEL84QuPuD032GGpvhalZOKIrt9mlmK1v12M3061d4YjSj5sDvtbC3ToV+yuz3uf6F
	 eUpAQ2ImpC2Rw==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: preserve the caller's quota in damon_new_scheme()
Date: Thu, 24 Sep 2026 00:33:36 -0700
Message-ID: <20260924073337.7440-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <arRHl5blMrrmvhkU@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1z7kyczbc4w9ymixah3xenyx3e6opctu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6F2F11A0007
X-HE-Tag: 1790235221-621984
X-HE-Meta: U2FsdGVkX18z7J+2UAqHGqS6gI8cRGC3MAKn7i0NwLUJYW0WnWNenw7eGD6iKiRswbsQxePKbX0Vh2esQGMt4P+gpjpN3WTlRXw8Mnx23U1+Ol9bEr4Mfw76wiRNAbl0CezSqeNBDlzlZD1WXtbyt41ky7x1cXOMfV1SLXMXxYZNjrwvVi10hiI3i+t1uxj/6uaEiQsrYzJ3H3yenOKZTOlpCSip2FRIvDe6DdBVvDb85DcQHr0LaROGl3io+Cs6OVLrWZ/CgW0Imb436wvoBtT+DAxrzNEhFosbfJg8NEkWLQe8kEaSE1CdU23GGFnSwEZ1FLeZE1JEQoGH7VnJaTvbT4faSUb7eCddlz6CuFFNpA2/JYV6faG+gpJh5eNuYtLuhnFQkx5GCUJwucAezf7rZOG2XB2k/E+//urpHp3ygvU6YwRrdebT6JwOZ9lrb+TKGJOdKXNgugXE46xh6YmWA343zuYtzoRTllE40RisImvgjPMoC44nUH6dw0jIQaCQTV5cqOah9gACC3KhUUuqcVzkExqgzArpLpoKoQDB/kg/PS4CqEb5RNswKTFIFJ9K16xurswbmhLztFY7DIo95xPixjDegXtx/PrwfbGv1p8QTNuL5GKym4T8INTcOAzlncbv68JsiR8hPltxjSwgQbIQbYooxpXTalbUq6XigmBJP3mLKmHRBBLmprNH9qbTzSd/f/i3upWM+n0KIMOPRiG0r39WcDlr3mNCEXHvH0QPterr3Y0UAz/BFuaDoDu+CO9D6i1sjD/5s0jvUXkb1+Sm3+0jIOK0cmvnnw3/Khz9cKkI64rMEFDG8n8w0x3tP6xzJzm9geGqtNjmpqgLXDO5l+Mf4qFKggfqOAp9jGuBUC6iiSX4Bh9u61d5wCP5Cj1TGnlZbqfa4mo40xtcyR5nfQIHX1r+X7u4E3H6HLctW+7sP5SH7aFmblL0ve6mZXT62T9XpW/f3d/
 grWnwQ1s
 k23IsGo4f9uUhPCnlVWBe+xOJXoMeywHmiGj57UO6tmI3icKJpFTyhOszrMSNDdoig51BDd600j5Ro0PbffPe6fftRxzLL3cf7mO7IWQ8o0nmg/u6iwyvvMY5r8frlTT5r9FnbwwtLWAks3DMl0rFvkfe1zcOWqGJl7bx2lTBrsiMjL0eoX2CJqlskT3a+wlvm3KJ6Jvis7bxM8z+EPmcqOQcj5Hc3+ZtgXsxemPq9vY4gppuaYEe+SmpC1ByTvIwJNDjwymfT9IryJI7zOiMgRVJQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 23:46:27 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> On Tue, Sep 22, 2026 at 05:08:44AM +0100, SJ Park wrote:
> > To calrify my opinion more, "caller's quota" feels unclear to me.  I hope it to
> > be more clear that it means "the quota that is passed as a parameter to the
> > function".
> 
> I've made it explicit that this means the quota passed as a parameter
> to damon_new_scheme().
> 
> > > > 
> > > > damon_commit_ctx() first copies the running context into a temporary
> > > > context for validating the proposed parameters.
> > 
> > I'd prefer using the term, 'commit' instead of 'copies' for clarity.
> 
> Changed to "commit" for the context operation.
> 
> > Now I understand you added the comment for commit 60bd24f272d0.  I think Fixes:
> > should also be 60bd24f272d0.
> 
> Agreed. I checked the diff and earlier callers. That commit first passes
> the running context as the source. v2 uses it with a plain Cc: stable.
> 
> The LLM suggested the wrong tag, and I didn't notice it when checking it.
> 
> v2 is rebased on mm-new and passes all 46 KUnit tests on x86-64 and
> i386. I'll send it soon.

Thank you Karl, looking forward to the next version!


Thanks,
SJ

[...]

