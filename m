Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C02FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 00:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8256B0088; Mon, 27 Apr 2026 20:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80436B008A; Mon, 27 Apr 2026 20:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BBD16B008C; Mon, 27 Apr 2026 20:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7826B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:39:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D3D816038D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:39:25 +0000 (UTC)
X-FDA: 84706105890.04.79E63C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84DD5A0004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:39:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JOzL7rJW;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777336763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zC7uqNXHvphg4Pvu2ADo8+9HUBEt/3129Ijd4e22vzM=;
	b=jQixwkJnU9HQ3KyNJNeOaZ+3WH4vsOHWO6ynYm+dbl3G960VFaMzPpWEE5sxALgY2hAV5Y
	o0UR9wUhFr5NOHcUL1sMHpMzTFj1F7MJzKqKASswYAFG336GKuEooh8B38du93JNhZEAB4
	u/HUanLNuZ2nEvUdbGEUEQ8BhmRh4Xw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777336763; a=rsa-sha256;
	cv=none;
	b=GyXFzRivwwBaAXdo/+sU9l4ONqyBrUjdSF1cCUxAWNlk5IntHuSbTY0t2DrpBmktsp6B9A
	Beydl2uW4XVXhd5LSYnH8TSQdtT9a02a2aSecNbXtj0mzrtXsgiW6eyMhytVPTYMq87Wdd
	ZcRlpH1OoFtmrY0zTA0ePAJOxlLlhpI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JOzL7rJW;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B9E740A52;
	Tue, 28 Apr 2026 00:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FADC19425;
	Tue, 28 Apr 2026 00:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777336762;
	bh=lRGNhb+u6wBJ03S0QzqJb4wpYWidPN3/P13uPg4Nhv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOzL7rJWl+2wyYZ09VlxfZyK/+M+21lzd9PIsBeoDZu0uOoEyOF0YAN1eicTp6fdw
	 9Gi44kbatTRAhZsN/3dUIQ8y6y/ygSVm6Uq8ivBw/RtCeznkTFoc4xd8tk1D3FdfAM
	 w2SywQ/jcRr8kFYC4xF6YaA8P9ouQNx7M4cyd674CMufhXzV8GtoJAnq8XG3kOvpSh
	 +hRfYk6Uky6dAfUyQy7rVrLi5xsQ0C/VBugQKTdOzbHOf8inS5wfnbWx02Oo/nYsvQ
	 c43bGHS0GQY4edI710wsdR5Dt/MS6OokYNOeyNMUY7QU4aDRSxERNG6cSzC7IM9dQC
	 cEm2mHrwGyhPQ==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 04/19] mm/damon/core: commit probes
Date: Mon, 27 Apr 2026 17:39:13 -0700
Message-ID: <20260428003914.113299-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c09f7c82-88d3-4870-9805-f22394b08583@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84DD5A0004
X-Stat-Signature: 5iuufcf9dxxsdzi5y5hbwcrq6awh5q4g
X-Rspam-User: 
X-HE-Tag: 1777336763-842877
X-HE-Meta: U2FsdGVkX18sezLt+imM7slpLLWmoC2D7NXYcu4tJdGE3F8ghvU7jqh8RIGeIS4wNHw7zmCIue8g5Ijleq1z+RjTqurdJALbKtEeGoVmTBEsOZs3+GYNtSeFzDuYKJRAJiepMElWY2ZbGxkRfHFZrsL+Ty440MH2zshTYqfxPpwVI9l+yKaBI6X+Ge7S9pqwRKZyCsGQOH4u1HIfvo899iP5tZ0SXTyj45Q/FJ3NwSEevViCFzP7gyU23ZDksKwDIXWUCgVAIAYl5KAhC3+hCM5S5vv34ypGH1paBydFYvJR0Nbs96TrZ8dshiX+5yZcwy/i2Ix3V26YVt2Mwv00gzfeudPUVQ94vzblb3+arC/6vlHZTSfWpffE1Sd0UuBdALsZg87eHg06DevtFIJWzTOuG4PHsdXSdoC3FIwSRLjm6pyGdoTiNzwTY2VUab2UyzRwyHJekZ+/xIFKJT2bJi1G42sgO/gro2D79ERW1vS8nPwRE1LVERsGrhyzysY/NGOrQtwBEgZFOcD1KCwgaBq2MtuqRYifsE+iPyFbRMC8ft/Ftl3gBUHajCLUJVm3oEyKXWLkA0m8pdcTKjJvwp81tPDXWHJHTJAB5uUZ3ALU08/awXXUqdlTmIYXZD3bBJohuhtXA8e3K5hbOweoYfEsMWkr1HeSYNR7+QgJ4OV+jxP3P14xp5CY9097aCnXBbJnDLNBj1D4G492umWPIcsdRq86MENFsuimdU9BJ473fW9hm7l5ZCy2CMGBqrnDMYVcY4x5VxBQb1oDhfYfLYbyyVhPpcF6JzeJmBcFZ5Ds2qnXq5LJUI3X9sfeHQ3OjB41pJITrCXezwKdPfmnepkAFECfwiLIT3xIRh/C5EOtYPj4e09/foyJ33zUF6gPOhyCyDUpGxDhoavQQxDJ8A0AYghpFW6SSbPgOzNPo4vJqb2yfdsHB6zVt9OyqeI6dvIbLdR93gO7diuO6oR
 j3E2vu0E
 Uwvzx3RH1ACybisFj5L1SRp31oX5wOSsEMOVFvLZ5NlrUHVZo4T53okgnW+eFo+A57ZLfBCNV03sFDbHn5fNhPvGRxCvL641wxcEstmGiAh8rgGbFnUAcfl73Gc8odxa1rM0CdV/18SUWQd6KZnTcEYT8BH3Z9GcKLoJSEEu0uSBu6PEHL6TDZmeK73L5lykYTw1ya590E3gc+xqUc5yuOPrkQjPG88yH0+vZq8sin1hZwhUadreEtJmvzQ/NKSYVWb5Tb+Er7R2WbBn/CsyiXhL9NNerpXB+fHV4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for reviewing, Asier!

On Mon, 27 Apr 2026 16:21:19 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 4/26/2026 11:52 PM, SeongJae Park wrote:
> > Update damon_commit_ctx() to commit installed data probes, too.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
[...]
> > +static int damon_commit_filters(struct damon_probe *dst,
> > +		struct damon_probe *src)
> > +{
> > +	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
> > +	int i = 0, j = 0;
> > +
> > +	damon_for_each_filter_safe(dst_filter, next, dst) {
> > +		src_filter = damon_nth_filter(i++, src);
> > +		if (src_filter)
> > +			damon_commit_filter(dst_filter, src_filter);
> > +		else
> > +			damon_destroy_filter(dst_filter);
> > +	}
> > +
> > +	damon_for_each_filter_safe(src_filter, next, src) {
> > +		if (j++ < i)
> > +			continue;
> > +
> > +		new_filter = damon_new_filter(src_filter->type,
> > +				src_filter->matching, src_filter->allow);
> > +		if (!new_filter)
> > +			return -ENOMEM;
> We should bail out here. If we return an error, we have already
> committed some of the filters already. If there is an error, we
> should remove any fill that was already added.

The cleanup will be done by the caller.  That is, damon_commit_ctx() caller
should destroy the ctx when the return value is imposing a commit failure.

> > +		damon_add_filter(dst, new_filter);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
> > +{
> > +	struct damon_probe *dst_probe, *next, *src_probe, *new_probe;
> > +	int i = 0, j = 0, err;
> > +
> > +	damon_for_each_probe_safe(dst_probe, next, dst) {
> > +		src_probe = damon_nth_probe(i++, src);
> > +		if (src_probe) {
> > +			err = damon_commit_filters(dst_probe, src_probe);
> > +			if (err)
> > +				return err;
> > +		} else {
> > +			damon_destroy_probe(dst_probe);
> > +		}
> > +	}
> > +
> > +	damon_for_each_probe_safe(src_probe, next, src) {
> > +		if (j++ < i)
> > +			continue;
> > +
> > +		new_probe = damon_new_probe();
> > +		if (!new_probe)
> > +			return -ENOMEM;
> The same as before, we should bail out.

Ditto.


Thanks,
SJ

[...]

