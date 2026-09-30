Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11863CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7516B008C; Wed, 30 Sep 2026 08:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57856B0093; Wed, 30 Sep 2026 08:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DA86B0095; Wed, 30 Sep 2026 08:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFF56B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:14:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E07FA074E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:14:14 +0000 (UTC)
X-FDA: 85270320828.29.D0C314A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 84F3A180012
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:14:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XzvkGeU7;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790770452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHgbHRNzEnFUlP31YxzqtwDqio/CYy4seWxnYnXWxyg=;
	b=sG2xdu+bgIKUccZlUYQYrRK/ONKvvwQH1hGl1lk4aq7CYIJoPBwKF4Tjdr6jiRhJClBOBe
	zt38KniZN11mXlT6wGV2u4Q3jltRUBwv2wNQXEow9eiivI7MUGOBrozdUA62zvwc9/Jksc
	Jbl4ghJQjTPpZUHbjZbjz8d9gko+Oco=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XzvkGeU7;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790770452;
	b=PSlF+POHbzoRvclh/0HaPnVM04kYVd5ST7TN6qudAY7Cs0Siw0/v6qFs8POxuD3m0tjNgs
	JwgBMDL+2Hmtstj8IuPwXmggfhwk9NbgpVIsMeRCWK1BKGoGqO9Mk/rdrMw0wQVpJetAcQ
	rptozaqBDYQzzxHgk4LPWmE7HZTanFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01BAD60008;
	Wed, 30 Sep 2026 12:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5C51F000FF;
	Wed, 30 Sep 2026 12:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790770451;
	bh=fHgbHRNzEnFUlP31YxzqtwDqio/CYy4seWxnYnXWxyg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XzvkGeU7bV2t80zI5BtErxLjoC/e8vILDiqkw8Flj+ezG9Q21+NZBsQkqrinoZ1yp
	 8VOcHtRDdIbf62K49d7u+5/nCP0ccE5cDJQP9pgqt9aHMa97N5myDpkxNYplH9Vc+C
	 exckcUyF2GPf/3q7toZa46E4CZV7U8PbYKxd+rTOW1PRR+PgRihvg2TDQDsEoGk+Bs
	 hTT/g3Yj2Q+S9lGPSk5TFMCb3O7H0so3NTWCn+ltm3rY4oLiZKK7FkWwUKc5gTzwV7
	 uKQrMweHSQa4O57IV+LeTuy2f3Ih6S6BzFO5r5cXXna2U9EGnXTTVowg4C+JNPLcal
	 bYXTHZGzAuoqw==
Date: Wed, 30 Sep 2026 13:14:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: =?utf-8?B?67CV7YOc7ISgL+y7tO2TqO2EsMK3QUntlZnrtoA=?= <ts930@dgu.ac.kr>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
Message-ID: <arz82IHw4MqGTb6l@gremlin>
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
 <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org>
 <art6x0XpWcT2aUyy@gremlin>
 <CAFPGN2jPGhcWVqa3k16RWMaMR3TwKyhFbYYF4D3L6L85T8E96g@mail.gmail.com>
 <7d120555-0c31-474f-893b-e5ee3466ead4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d120555-0c31-474f-893b-e5ee3466ead4@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 84F3A180012
X-Stat-Signature: 41ti364zxsikitfikw7n14b47njtmw4f
X-HE-Tag: 1790770452-350153
X-HE-Meta: U2FsdGVkX18plI1YRHz1Le5G34DLVuZ2tp4qauzVs/maeaRiNCzlFe6xcEQ8mIUsHgrBTH7rmYm+aWwsOARoajYOsF11L9Sz8vip9XmPaf48kS1L419uMieXuz7R37ZMvbGxRXyjBzPsYezB5DayaI4JrC8eYmu7kuQ9b6k2c+WPmpjkSQ+IhKS6HXnQRmXbFkKkgZGtWgQrrg6OFYj/RHbUcM1Jd6ZctSjC9N3Fx9Sq/KxZtHHK6wca1N3j/5OY8xf+SeNLtn4Q4tov80sIeRPN4jEAb9otpAHeOcsJpj4oAvZn/hZPR5oH1AP+miFCvmZq8YcHs1NNcueeZAid9L6z+kvylI/s5CKI+HxUoV136471+kP0GdlpWkxGTWl58pyfGTPdaeFlmFs3IApwTzksiPn4P0ZYztxNYdU/bXJKZDKs9LU31cnuIoSnc+T5ZQDy3ADHlYy6h7qweEnZ1ZW4VORqUVb25j29ddlLq5f4hQjMScSX69hWRmkFzB/fIBkQnHtFeKpOlG2cInw+k1IgViwUBMF142XTWfpseA2ffOhEU+sokj8yG11GZTIe7/O778kBKE2xv0l2eao/M8J4zd4pkSNQ7uxSmik6UeSNstMHJ9f/jBLyLQVZ2Y+duk+icF/7yJv/UsS7TNz+7k7GLND8FYM+xZrNwAPCkncF6z5d8rxl8HIl7W3rTiyVjTOtVvGkgrcct0aK8RX61M1iRTTYw03YkBKT8we7W0NyEcLUK9igyloMini1mVuf95RLAtpjNFIJ3MEmNFHGD0AWWPBvJmCxjk1bPkCWLIwukr+Oj3mCiVGzUzKuX0KPRpQ6QW5sDtzXPr9QC3WMWFduWR/g3u6KX9Fg3MeWYxThRTOoMhl5rqZ9cj39KKGi+2hMlybWMsYRvnBeNUukGsI+TZR1kFsVEzewTwZQQ+BCHLjZk4sSIpn9rezy7rn2bR84nEKcqZ7ySY8jR2Z
 JHcr0QuR
 vatvRIP7Ut27OOfQ4Chd5RWppGyzEU5/TQt4Z6bBCvv9OqFm57BmYvnoU69LEuuoI/XFLRJFMhdYcOTHzzcNq+7FR8iZwI7qViZWQu3Tn+Da0h4d6snXCYxlo4xMrPAp8s2XpH5Vij/4VdT861dkZ9Tj6/9ZYtudKWGgi8U57uZ6KfADncPa0op2jz3FvNoce1easFMlPJwCbubyDyIM/C5Qb5Lo8RuWLRhhiw3ulSBbFYZGdsdMfsQsZ0e7F/KkfWZmy64coVixgMF//8sJZatBCjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 01:43:05PM +0200, David Hildenbrand (Arm) wrote:
> On 9/29/26 11:39, 박태선/컴퓨터·AI학부 wrote:
> > Understood, and thank you for the feedback.
> >
> > I sincerely apologize for the poor code quality and flawed helper
> > design. I will be much more careful with commenting and ensure future
> > contributions strictly adhere to kernel guidelines.
> >
> > I will drop this patch.

...

> The CI seems to complain about test failures:
...
>
> So is this patch doing more harm than good?

As above, I think the submitter has decided to drop this patch?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

