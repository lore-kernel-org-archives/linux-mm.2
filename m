Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39B2BCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4528F6B008A; Fri, 16 Oct 2026 10:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406456B008C; Fri, 16 Oct 2026 10:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343486B0092; Fri, 16 Oct 2026 10:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1932D6B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:55:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88177160527
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:55:43 +0000 (UTC)
X-FDA: 85328788566.24.278E4FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EEC0C40006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:55:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XkSh6Q45;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792162542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLeQksrkUZZ+B8sSmI4fp0bRW5ub3nkmSkvKdHG+Nrk=;
	b=ztiJdFyZ0CMamhwEb6B2qkDqPmHFOHi9y6AEiaTR8pevwDHqsciiqdAbpP5cU2rzTb8kel
	cS4lYJb/Oh0RDn0WVhReGhj9ZZjSLINO2mu44lUQtJTD19pBVVKHhSePFbh3ir062dc2dn
	1Zs8i312+R0e2TWKb7TJ2tXj4RctNsw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XkSh6Q45;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792162542;
	b=QdsxBfPoyzfyGMK4jHLPvBieeglwppMr6Qe9MMNOpa73yGVuQUe3snfSL+JEQWjYJOi+IT
	vGepIw4kRcsq50zo5o41Z1jS6Cj8psuXDCN1n/uIYw9w3vLH42mZ1z4KCdjKrZQOjwJqcy
	nKpF/8aobrpyvvNlveY48N0FcaT88Ig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47076601FF;
	Fri, 16 Oct 2026 14:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC601F000C4;
	Fri, 16 Oct 2026 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792162541;
	bh=iLeQksrkUZZ+B8sSmI4fp0bRW5ub3nkmSkvKdHG+Nrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XkSh6Q45CXdKP4f/MlT06gpZoQtRFOEr1GPIl1D+oKexhnlPzCOvISsD3+KFc1DKb
	 gQKjYGZPFT3ghwdBY3EXfZNZHJR5CfURYFKUwfPN9XmxPNmQSN4fkvRCRma1x0UmTN
	 NKQDoFg9MBSTzOFeiFng365VCs4WOi0OLN0/2ZuOpmc8lT6YJrSzwp61OrYoigbYdg
	 y7aeiTaaL0dwdlTk/v0Im3RIsfw9fgF5mdmKvj+4ax6ti1uWxH8bTitLWlsDr7qW4V
	 Ol6ez1VGT5bHelyfkLv9wsqeEFODJpiEs/cUN2WFiFUMdxIAd7cD9IIylWaTFwXv58
	 HwI15cQGOkSxw==
Date: Fri, 16 Oct 2026 15:55:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <atI6TVqoOhv0XMQ9@gremlin>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EEC0C40006
X-Rspam-User: 
X-Stat-Signature: oxcyne8j6bmkif133bi3wrtxsrjyyowu
X-HE-Tag: 1792162541-61456
X-HE-Meta: U2FsdGVkX1/FWthdzG5MWYwvBplYEMg2UzKVTUP7/NrLII2SXpUQ60ECaxUxB187dnMllu1bnv5BkrGIu4kZ5xalMaGsoqhx1XUeZXsELH4jo5izMS7zZJ1REvG1EUFvmyNHEbqTgpmX2VvKZES8ulAyBCRRdgC1DJHeN52oBTtr/KXBkvVaCCsMeeifrNc5oeu35IVMvU8zigjLYSvRRgbAch5N3JABSI1wLHzTqqPw1gKH4EPKvUPR2tHWiir9cs+rRAdC/XiyGqbKKM4SGk8ja3VuPFlUX58jvqcs3Bdmre0gH7kqBRpryhlk/Bvxb+kX8LB3pqhY4Ro353XpDcL/siSHQPJWFyLl4U3hTr6IJQKqLqrMWmHxVPh4D1W/9FEfzkYFfjpRRe8SFHObq82GtmEy6Esr9m4tu9wKuRvGH4ru4skIlXdCQkfW726LY09xey3o8wGhneZw3W9m4ZCNfojkZ43SnDC5kHayP0Nk5gTv/k2mm25HfETtiJO4bUS0YHu4jXzJQgw2c45qRwKwNkhSQiaHiXwI5vSjDioptt6FI3itQknczdOPvqzRF0A/uEln2gzyoRRkRv6FEPctgLc+NFJUo6+HeWN1+EQydxfdqF1cmBVM6Nez3b0pQcejC/z3Mwc9qgd8c+N2SzXJQZeWYEdDyeGtLXtXPaRPUQrCk8YpARuHIOnBSOQVNivjXDjCFpOdNf1tnUAo4W7uaRNrY5OnKpYy5Ks+5aJZcxHeiFzt79NqF9MlKosxO+J1PVgIghBJCF9CO3tMCopX/ZJSPZ9Lo5smWxCNB/EXflUmb376gkWE+KwfRH8dIMYgWFhEMf8JVbqpxkMNSDp5HbiqSkoYSezjLHJrey8G8H9vdikfAEyxuLZrUD5mudT0WuXNQWeoWvqIbpaZWcmXNT9JHRytiePbOYpLytnfmmNJxw69KqBiJb7wZdU14VjrrBGaeW7XOh2gHaI
 LQPoYqL9
 deakI+Y/DI3xFLOyNdnC5En+PT7tzyoo9+cPAT8mNOUr7SqF0eeOnNzWHPkwbtEGWvoRMX6aKjp8bt4pVqzw+F8YcKQdDy0u/oj6BqvwT8KAmJYLYDhMw+y9uYIY4oAiDBggrXYq+pjoPOih+9rh6NppPRC1Xa2WPng9mn4d+vWOzXw91dcJLeW/CzFB8NK3ruuX33Crd+5+xE6sIfmZ5cXBvuutEeriKjHtMmb3FyfM9ZlnP19ASFuQIwPZyVBhVxTP9vcDCDkb7IIlwRFygLYIsBsMAevcs5s8fVt7oxY3QxkReDtXFoSuBXgVoDWrqE47H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 12:34:33PM +0100, Lorenzo Stoakes (ARM) wrote:

> Care must be taken, as resetting the sequence count at overflow means
> changing the seqcount of VMAs which are already attached and observable.

For the record, Liam pointed out the overflow as an issue on more than one
occasion in the past, and I (and I think others?) wrongly dismissed it at
the time, so full credit to Liam for raising it, and mea cupla to me for
not seeing it :P

That saying about assumptions etc. etc.

--
Cheers, Lorenzo

