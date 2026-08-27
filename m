Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5FAC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393776B0088; Thu, 27 Aug 2026 08:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344AE6B008A; Thu, 27 Aug 2026 08:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B326B008C; Thu, 27 Aug 2026 08:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 025B56B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:54:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04048A0226
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:54:10 +0000 (UTC)
X-FDA: 85147042302.04.54C8F48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6687C40006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:54:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oGMl4N5k;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787835249;
	b=cxe9BT/noR1jKCBcu+WGNsB3PXQ8dtlgZ3Zrumvx1p5xRYkrTiaCV0RReIiF7D9wshaGnv
	n0CMWSxIV+jJIsboEK7yBFyo3oFBzH3juZ6o6RLcqaSN0GbsQIeqVXKxZfdVdkoly5YHYu
	Ktqnxsts0iJrb0IZi8336rhCWQ/3Lpo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oGMl4N5k;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787835249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIg5zZ6JbkUL9eFTbcsNK+W1dAOW66BzRH+VRLbvREg=;
	b=e0cB6Uxtya42L9MPlCBQKXz2Rr96Vg+0p/u0JxMiJaRN52PC1cQNkve02F+rF71Fm9DVb0
	QxaWBAs3lnIa7HlBxyNsd5xU+0uvLt8D0AEFuR2wiKNoYQ9+vo86yu/T1G8tIgHtD5JOxz
	nQWceoLHzXX6rOUR8+rX7Yp5Wt8dEQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87AE7601EF;
	Thu, 27 Aug 2026 12:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA7F1F00A3A;
	Thu, 27 Aug 2026 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787835248;
	bh=QIg5zZ6JbkUL9eFTbcsNK+W1dAOW66BzRH+VRLbvREg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oGMl4N5knaBxQYzcV5hV8JqGOLHJsX+4mrivGNvXRPfNnLTmdZK0vUS501dgYx1Vg
	 zTyOV1I6DUgkteLYdvJn4/3r+CjgY2tfHFm9KPK/xwTmdxFZ5hvhgIQlk2aEe96Me4
	 x7CCAEsSL3Cstz09IvD1eSrcoeg+mw0GHgd2Q8llQBwJdFkcLoAs0gspto9GqfJktw
	 V6fmHcHZk8jLHVjW2k2gZKoZ8++rJfcS+Bm99R4qTAhQLwOVswUMPENOucSRjKQ3QG
	 7k+sqXfOuusHJt7B+bRKeDMVkMS2O5BqMN/LHV1Wj9c3zrdqb+a6Kly2b4QgBdVvUs
	 KEF2Kz3Sle87A==
Date: Thu, 27 Aug 2026 13:54:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <apAzXyJhWfiBpIVV@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7Nr_FALfP7cTY5@gremlin>
 <25baffdb-fd65-489b-ac9b-94e1ad676eaa@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25baffdb-fd65-489b-ac9b-94e1ad676eaa@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6687C40006
X-Stat-Signature: ghqhqsa7grhc6fp79de6fyy193c8699m
X-HE-Tag: 1787835249-613584
X-HE-Meta: U2FsdGVkX1+OR60dHz1N7EJHsPjZgivksoPmaVo1Q8je9fTM6Mf6b+A2OnjIlUsmYjIdbmQpWAz05XtqNOBNTJWRv8CHe0JBOuTmVnGykyoD3J+4ttMFbCVyUtpJF7daDfB7pf0nBWIVeiHVd4RWjSlKo+bp6rO9X6dH1Sh0qxzkAxfai87qDItr1bL/BaCyjJDH+qAOhN4LZkvouifgusFB9dgV3ftoXHieC7BXLSe1DRvAfQG5dpecrebu7Uq32/bet3tGT12eLuN4GI49I4UyS30nPHxz/Gr/ExQDxw1wngpvUlm57vi10HmoYGf6l/tG5oKcAaDRh/l0UNhttNpt3RmuuAcXcXkOZ/hZ0N/hd+Npd3AAYGqk8+54XGM0p0n3PXkAn2NcYSQMh7ImEi34Q9uH4EHc+POEBTBGPXzvKeZJsDFasV4u6LAjiG6hGxd6hnCVNePDJeIVU43D97u4pDZ6peRF9SLAzB1uKqbKjAmg5k1PSZTY5xOLE5MPZa4epReuJfirzng0vcnCWcLM9X1mobBnoPkibza+FuN0FW8Hmiz/liShsRrO8LS6cvgNxo7pK6lY4BKTxWYFVWV8R9bAGkoruCvvP8O6+cYUvAcDp67IpZOsj1yofVivBCpXzymPNJSRKpW1wYGehCabUnss38rNkebI2kKHLa+PoiInHrZf9eUsoxA38U1fS6ovNYWIY1aT5hlC4bgZOD/DorPzXMHh7zYoAfKz9a5mEutfAWF00r8WmWsSQaGVUAEew74pA7CuftLCcONraOgsx9Oa0tQ5IKURmOtBe+ZkDtEV0IOGfMM3BpzuqQyXEbzme0Twmc/aZFvJlyKVNJxXg+4Rdg8KTljwbfCtjTZyld0W4mmovA2JJA2+PgOv0LhxDwNgHOJfgVUK6ED0CwpHfWRHLqb/D+o7PmDGPZAYZWuWyLEnmqC7ckAtH08A58rmVAlAvt61yEnQO3I
 wrrozkOY
 QLF3q4W3d9RHP97W7Kw8L+3s6VH2MW+tvmKKcT8k7/05vMP+5Pifch2uM7wSczBn6Cbv05yzoxRY5h22EcKBtB8aaPZPYO8UernesBzblkVsYkVQYVVdv1pc5zB5qc+tM4IplDupzdh5rAKdml8PW1QWKyZF4sV0APvZsrUtNjMLNBTcosV+M78BDvizQ0GikOlT8hOpyTujquLelucF6JigH0IIeaOl0Tvp9Ob/Ard77em+nGreCHkGYo+1w5ZSnsrJOCmxhhulCEXLUCcyG3ZLcZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:38:12PM +0800, Baolin Wang wrote:
>
>
> On 8/26/26 7:31 PM, Lorenzo Stoakes (ARM) wrote:
> > Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
> >
> > 	~107,000 words of review across 948 emails (in 279 distinct
> > 	threads), counting only prose you actually wrote — quoted text,
> > 	signatures and attribution lines stripped. That's a full novel's
> > 	worth of review commentary.
> >
> > 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> > 	and your longest single review was 2,404 words (mTHP collapse
> > 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> > 	of your top-10 longest reviews).
> >
> > 	Estimated review time: roughly 300–500 hours, centred around ~400
> > 	(i.e. ~7 hours/week for 14 months).
> >
> > 	1,615 THP-related emails in the window: 948 reviews of others'
> > 	work, 278 replies on your own THP-touching series threads (~31k
> > 	more words responding to review), 382 patch emails, and a handful
> > 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> > 	emails), June 2026 (113), August 2026 (111); quietest was December
> > 	2025 (5).
> >
> > Think I can be happy with that!
>
> Hi Lorenzo,
>
> Thanks for your great work as THP co-maintainer (we all know THP is one of
> the busiest subsystems in the MM :)). I am glad to work with you and very
> much appreciate your review comments and suggestions.

Thanks much appreciate :)

--
Cheers, Lorenzo

