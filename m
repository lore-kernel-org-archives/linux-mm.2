Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866F3606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=WUo05cr+
Received: by kanga.kvack.org (Postfix)
	id 9DE6D6B05B1; Thu, 29 Oct 2026 08:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98EBC6B05B2; Thu, 29 Oct 2026 08:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CB96B05B3; Thu, 29 Oct 2026 08:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67BAC6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:09:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA1101C3A64
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:10 +0000 (UTC)
X-FDA: 85375543260.25.B07C139
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A5D51C000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=WUo05cr+;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793275749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RocjA1LFJ8nCgW+tO2y+Fh4wXXWjfdPFo024IhF5Wq8=;
	b=K9poo9O5moP7wxu+DcitY/XoL2SSmRle8yXhNU1KINgO91AnTO+CWfzRtMW5wkjmz6xiGQ
	uuYuQ12y2Yv9jQbLDGFGoFHMK96JK3OpsJ5EOep20euFdU0XofJ6ZKWbk9KI2h0jn0AwH1
	s0iVwovnUEx6HzHIWGGeCtaKK1h0YhA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=WUo05cr+;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793275749;
	b=3Qh5Dy+YcB2I7tmescNgdZSJrQtTyu2nrbdi+je6dUskAvnNJ3sbSjN54ai7RmqjV/2vry
	JgJFZ9+wMNa1pQdesKUSyX6dqOcrVEuk5LeNyr8bP01s71e0PCfqQcH6UsEfxfwsbPIoe8
	/uwt8ZRvx/Oy9rXFzHsAwuvrcAanYWA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793275747;
	bh=RocjA1LFJ8nCgW+tO2y+Fh4wXXWjfdPFo024IhF5Wq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WUo05cr+foO7RPlP7534YSiBgZ8CQPkwQY40XhGkYZY6+6/4j3XkS/IFDfGv+Pkoh
	 y9zJIn2BFoMmtdWooRjNBcjjjJtArbTwyJLsxt66JLoWE/gVCnnA7sNVi3UolL8xve
	 VDmnu4pCCOxy8JC/MQlwNqsBS6P1OvE3N85vIIf8=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 2E446101220;
	Thu, 29 Oct 2026 12:09:07 +0000 (UTC)
Date: Thu, 29 Oct 2026 12:09:03 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH 00/10] treewide: switch to __nonnull_args() macro
Message-ID: <auM3XwWPnMHcPptM@shell.ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
 <cce30180-c1c4-4b10-b681-8944057bc698@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce30180-c1c4-4b10-b681-8944057bc698@infradead.org>
X-Rspamd-Queue-Id: 3A5D51C000A
X-Rspam-User: 
X-Stat-Signature: 8jo5ykotnr5zjpbqguk3qwt8n7yzhzio
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793275749-802
X-HE-Meta: U2FsdGVkX1/3H1xw6bYlKnpNbPn2+sQvzxX0I80bfYksKyyThW2UnfZrgu6hzAmy9q/i1Hverqc6LWxNhE6L0Oa/k/6LhS02jRHu7WcDlLrd8IrRZz4HPkQk39DqiQNKjjRilVx7Z0uWf8OkQTjTul0OVbSYTsFtjBwHtdKw3b97g0+fUbJx8EKxdKyDAfgnp1/flchgXXoBPmtq35joC4v06rMZ2or4B28IiLmHbUY0o6Odtn4OJg4M4hM4/aFLNBRww2RWEi1d6oZaqylCmnn56S+yT9XXxDLgcG0Qa5JwkHKG2Q/uYjsPOc5MREnWOpMtLbUgEC1dshNWgZdSOQ+IEN3jhP0D2F/fYrKoVlPbVWo5NdWT/uTGeHQqPK8OSbf5P+Q+TOCAuxBnRF11vaSgkXawExY7uCUhwCAEchgdnXwgKLLWjagCFu+uq1QWCnhjHLs7BLtVCgfl+4oa1CsC34Fq6ElkB8uLUIBS7Y5k1Ole8zXKaIcjq/+XA588VC9/WABlvuFMUKgQkDbz2GVsnMrUfvMZqS82HgpNt7dD7l5QCjMKFOKSRoOBVsJh41sLqy7SIDtU5sBaDtoqgs3BXAvOTVbZ/c7tHVJ5frHR8QRSabtlXNeeZNPExCGImwXbeBGmX1Y4VqS2yQCcFyXTOgDT+istFbML2N2TrKCEf6SFhr4Ih9qyltR2wIN/kO0cbzDEXZKyRAc4bVtPjlRjdW8gSeAC/QjLYeeM9af4+SCLTzxj6Fo9TUb/5s+K40PA+APQgFRK19JyN0lnxS1cKvVmUb+KfUZZveJ9l8YS33B109A5QhiTbNIyruZg84ooKtLbB6O+Pg9ePoX6zVr0kJzwTLvZ5fSt9hP8imsKsMrCaaRB14W2Q+dZPEyAaeK5cV60be97P5NiJQ5kKwtnXnMc1MlZHh1tN+aSvUw9uv1ZNPYjrFxXGprE8OSIVVZY+m70mx1n6BRb7Yy
 5x/CEmxC
 SCUrrS6LeEBT7A7J2GcCXcVmMoPcPAH6ddj95SWMbybgiqpPIXA2cFjs1TNYUZmQi+sQSkQLGu9DzqCd/7HcRSZRGb4PIJVOzzO3l02myPAdXPiTTeb9rXN0TUsUufZjYoVMbv9NT5Y04qJ0e+F3ePb9FqXq43kzsdNzg1XCB128jMy/9HM6ornUnNSJ2bUT4S4u79dVWelks6M6wvIKdgXpxyePUgzVOhh2MhY7bKPh4RLRtfznl2SThgHOEbsncTCf+39eIDm5UhzOnsb3Jfr01TFa83T5FNLHikYHO/PrBRRgccoj9y6eoyi//i7MVOREup9uI0bO5oGKvok6A6hn5jV0R1u6WqaAwt52o+lHDD+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 01:44:59PM -0700, Randy Dunlap wrote:
> 
> 
> On 10/28/26 1:19 AM, Dmitry Ilvokhin wrote:
> > Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> > nonnull") added the __nonnull_args() macro to wrap the raw compiler
> > attribute, keeping the attribute's quirks in one place rather than
> > open-coded at every call site.
> > 
> > This series replaces the remaining open-coded __attribute__((nonnull))
> > users with __nonnull_args() to standardize nonnull attribute usage
> > across the tree.
> > 
> > Each patch can be applied separately by the respective maintainers. The
> > only dependency is kernel-doc: the string and lib/list_sort patches need
> > patch 1 ("docs: xforms_lists: support __nonnull_args()") in the same
> > release, otherwise strends() and list_sort() drop out of the generated
> > documentation.
> > 
> > Latest Sparse release could not properly parse __nonnull_args() without
> > arguments. Fix was proposed [1] and merged, but until updated version of
> > Sparse will reach wide masses it might trip on __nonnull_args() without
> > arguments.
> > 
> > There are few more instances of __attribute__((nonnull)) usages left in
> > the tools subdirectory, they are perf related copied files and can
> > (should?) be updated separately after this patchset lands.
> > 
> > Build-tested allmodconfig with GCC 11.5.0 and clang 22.1.8.
> 
> What ARCH(es)?

Fair point, I should have mentioned that I run this on x86_64 and
aarch64.

> 
> Did you mean to use such an "old" version of GCC?

There is no grand plan behind that to be honest, I used it, because this
is a version of GCC that comes with CentOS Stream 9 on the box I tested
the change.

To be on the safe side, I checked patchset still builds on GCC 16.2.1 on
allmodconfig x86_64.

