Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F616606A327
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=il82Uc+P
Received: by kanga.kvack.org (Postfix)
	id 65BF86B05B2; Thu, 29 Oct 2026 02:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C8F6B05B3; Thu, 29 Oct 2026 02:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524016B05B4; Thu, 29 Oct 2026 02:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31DB56B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:16:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A91191C343F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:16:29 +0000 (UTC)
X-FDA: 85374654498.13.0F1F1F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E9391C0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:16:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=il82Uc+P;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcrljsIymRV5+ffp+HQjRncEcwBUUlAXl9/IaAP6MUo=;
	b=PmUNazxrmqRZdjO6PfLa5KfxekYAjaThSgrI8euWMBcztjMr97aG4kVCu7jzIewgwpw4nW
	SNSBYuVbUpTUY9EVSGTgwR7IynXDoDR34zT3WaPeyBdS5TMIgQudZKmEhZiIWeSLQLdzDh
	NU8SEpzeTSith/4WYTLG4lb0/3TU7sU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=il82Uc+P;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254588;
	b=zu/j4FoDsxSBDX2DMeEoeNU656k0ggDRsTQBiNXIoryAnRE6+Eg7/6X32SHttycm3pChHp
	Hl9Da94ZNbW6R436UzJLfZRZfTc2ZQCDb+0OO+W3z9OH8UbEVifA4A+Yi883/MdUrztfDR
	Tq9zEEklQS/F53g3zPGjpj8nEAybnms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DB0E402C2;
	Thu, 29 Oct 2026 06:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3355C1F01825;
	Thu, 29 Oct 2026 06:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254586;
	bh=mcrljsIymRV5+ffp+HQjRncEcwBUUlAXl9/IaAP6MUo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=il82Uc+PYiujnvTAx8vOogC0gI21PjTlyoqALCkM4BKfou7PHEjfs5eXMVf6rQLmD
	 r7l0jWwU5dMM7C1QnjOOEd1RybLgmxLXiAi85uSi1QAkVaUa806EpdyEr5k/sSbrWD
	 lzOnoAH3WemowZUWDdb65jcZuha7B4Kgx0FVU36Y=
Date: Wed, 28 Oct 2026 23:16:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, Christian =?ISO-8859-1?Q?K?=
 =?ISO-8859-1?Q?=F6nig?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>, Pavel
 Machek <pavel@kernel.org>, Joel Stanley <joel@jms.id.au>, Andrew Jeffery
 <andrew@codeconstruct.com.au>, Ryan Chen <ryan_chen@aspeedtech.com>, Billy
 Tsai <billy_tsai@aspeedtech.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Kees Cook <kees@kernel.org>, Andy
 Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, Andy
 Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy
 Dunlap <rdunlap@infradead.org>, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-leds@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
 linux-hardening@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH 00/10] treewide: switch to __nonnull_args() macro
Message-Id: <20261028231624.ba38137c3ba142785c75de78@linux-foundation.org>
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9391C0002
X-Stat-Signature: kzewf6ckkb7rqi199ec1mgkbea43offx
X-Rspam-User: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793254587-645155
X-HE-Meta: U2FsdGVkX195eE1fIcJpZwYzaZosbCVC97j2EKIX5BuBPLCxtX36BQQzzxybWStxVduqZLXA3srp+s68UB1bhGymxA0GO7GZbBvZ+cVZFJfeWfatb3XVyKPdWld56MwJ2C7dzbQf54zMUA/071szy2WorNc8cnmx/EyWf4cmD0xepptvZdQmTT9bi6MTDYAZkznSPz/KjPBVN80Nl4EbZGLhW9KWWminrAbxpiZOaekJmwOgSrNpqzt2psU9leZD+IKsKIUVeQwaJpwmOBxFiOK0raBW1dtYJAM1rMo9kE/uit9QVj7EZXe/p7HzmBB8X/buqYTgpC8HNXMc3+nHBn2aPd6p5cGMgnDeisSjBvz2VdOQ0yjVnxcwbaqcSuNWUqRopmR+bqynHSYhUjTHMn2kFBqc16mBoZ/ep6iVwMQzdXpVKjdmJ3hSRuUQ8enQPKMbd1hGR2nBI9KegE/hPLIMJQEsbqaZ6eQeWYpSaaX4xPvoPc6fwuxXbPLfWDzat+wFAx6QrpKXIZvz6cm/dA0kUamJ7f8sf7LT+vd2xjEymj9BFhGWoDxxXil5jvnnLc0jSwrUVFIv4mlXwXDpCN4+9qSqpTS6cCKjtEqxtZ9Pcx2UEv79vrB95YX+99FbYL0mGUAHJyZENsv4KsJM27pv/DjrLslk0z/S9pV+Ko4mU0E8LYRyEr+y0g8C3wyqevj8kqfnS3N5Q/6zXsPU3w4TBcLY37ntfyz+CUbFZKEddkCLI9oTyYQ/w3JEVSp8vQ80VGmsOwglsSn6QRCA6pG6NHJa08PsLclZPcuDaijwErvF9F9d/GpK3/TgTKe/K8Czljne3bYDR2osZHYXtUy/4o/mRrU+785SyKFkMBkO5O3/5cqh2wZ8aC9sN4SWivM0ZnD+J3VYNxqtr85+tGgaZacNg9/vmc8OM2iAtrqc7r14KXomQH88gkVgZOV0aPPitAKsCFKCDfucq69
 F5tH2D73
 ksG5WQiXHgR4VDDLpsGC1xMTHUC2Nk198dl7B6ZHaBiP7LZwr3FCdTGTMiYmj2fJBs1/ZwfhbyxOkQJO33JR4bH/yJNP+0mqjnAkyyWAQRC7obbRDbzFwW0VCBhTyNf4N37PudYysaxVAAQnN8QhEwFKbLicGm/6DllfSHF1/9FkHgfcuShawfDBd9mgsZZiCk7lNQjdTfqjjHAeh1za4LBKCxBTGHJ9BTyr9H7GnxFCG+dH/9q8ye5zXN7tz9kfs7GvYI9lys9rjnaA9OLgyCJ+vJgQf+UtXYm9jZtB2eZlbOnLe0Q8my9dGkN+8nza4AHN3rmt9DMovu0fttm1fy7y4wGrjENCsGygjUueleOWIstdAbCe8X/tStTf4tCC9lkkULQfZRVItotSz6elwNPU8iRPOO+XBqDbYfxCrE28NqeCyMHH5PhQrZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 08:19:39 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the __nonnull_args() macro to wrap the raw compiler
> attribute, keeping the attribute's quirks in one place rather than
> open-coded at every call site.
> 
> This series replaces the remaining open-coded __attribute__((nonnull))
> users with __nonnull_args() to standardize nonnull attribute usage
> across the tree.
> 
> Each patch can be applied separately by the respective maintainers.

Thanks.

Standard routine: I'll grab everything.  If maintainers send along an
ack then I'll add it (thinks).  If some of these patches later pop up
in linux-next then Mark will inform us and I'll drop the mm.git copy.


