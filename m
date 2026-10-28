Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E0E606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FC2F6B05B4; Wed, 28 Oct 2026 12:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4476B05B5; Wed, 28 Oct 2026 12:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7110F6B05B6; Wed, 28 Oct 2026 12:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 535226B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:11:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDA2480167
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:11:42 +0000 (UTC)
X-FDA: 85372525644.22.D2DFA77
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2CE3AC0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:11:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793203901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uxSAUdDO3MwPK+26JuHSTsq458DkeZfKh4h7kUJVnPI=;
	b=dr9f4eIQkZMRppPZpvlxS9FN4z0riZpSiGIZDF9Oi77AmNAEv9Gt0We4D46OS3GJNselEO
	EgtzrjhHpFHclNsAEvVxD63bzeozCQJDtmdKbcxP1jL7/6TRhm/eP7Leptg6tbCFLZX7BZ
	vczHU3JmspAZ1HNW0mxDFyDD5sjhZ70=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793203901;
	b=LiTT9XSvgQlhBtz8aKRt8pjW60T8sIrpshO/VV5WYwbM4ROKMdaFjfYdvkleIWkj63bOeY
	MwH+GkpoI3a/Y8BIQfZa9HnDiwk9W91O2nejldi7iEbx6TtQ8mDJdFABbec90x5kl0rmVK
	NU2Xle6R53LROPULqbMOG2ck98gDZVc=
Received: from omf08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9BA980162;
	Wed, 28 Oct 2026 16:11:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id A762B20029;
	Wed, 28 Oct 2026 16:11:26 +0000 (UTC)
Message-ID: <aacb76ee8a23f956eb2e778da7b125d86d164b25.camel@perches.com>
Subject: Re: [PATCH 10/10] checkpatch: suggest nonnull attribute conversion
From: Joe Perches <joe@perches.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>, Alex Deucher
 <alexander.deucher@amd.com>,  Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
	 <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas
 Lahtinen	 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>,  Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones
 <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, Joel Stanley	
 <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, Ryan Chen	
 <ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann	 <tzimmermann@suse.de>, Kees Cook
 <kees@kernel.org>, Andy Shevchenko	 <andy@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Andrew Morton	 <akpm@linux-foundation.org>, Andy
 Whitcroft <apw@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap	 <rdunlap@infradead.org>
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
	linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org,  Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 Oct 2026 09:11:25 -0700
In-Reply-To: <bc2cd702455e58feb777cdb230e3ba4f7e1db60f.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
	 <bc2cd702455e58feb777cdb230e3ba4f7e1db60f.1793027261.git.d@ilvokhin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18kHAE4RjXJ/BeJ9lSamcdiJOrG4xRY5jU=
X-HE-Meta: U2FsdGVkX1+vO3ZouaggYmakzKiEViVwEjIkayqsOUxRh4Y+D03W9OsYvhntgdSUdjdTBgNAGM07O+W/OBkN7qiawu9kPLoFiAUred/Z/Bvw2Ynv8IG7qnAPxQ8uaps63yUCxrPyn7HCEVo07x5i6NYNvKDhGCJh54qqNDafUAiSXShW2FGTVwwUUFc93x1OQO9f/LKoTfr2/KbcvJm3wJYFIWxls5MSV6vUbxfQ1CWIN5fZL2IoMApFvaTjDQjqQiBboJBwZoq4pSCGSqpTDJvfdjT4vabv8HAYbaFYZefsnth8dvgSgzQtAJujUJ5T/R386onDul4BmhyfIQ2SbKwU1ePW8+59QlMTPdteTFyX32nsSOnI504//g+rZB3j
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2CE3AC0005
X-HE-Tag-Orig: 1793203886-334294
X-Stat-Signature: 5m56y4bjcqjn15doddn3439d63u3xrtz
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793203900-406251
X-HE-Meta: U2FsdGVkX1+oPk3CRx3udf/wuCn5N4kNNf3Krg2QDFMKzgbpTKKJ459wHSY1GdBAEpPWrl+vm7g//V5uOpp3N+W7lqHV250wGH8s9eunVnXRVY3Hr/3ZTBEdDf0a2EqkrQF0VMa9TQRaWAxKtUau8/zu8A3EOvbY5dhZUUtT8gMzEf+OLQRN09IoDG613oaHmj2S4M5RnceYNsa27dNbMe9GA7ec6qkid5/szBo2iDh0/RzKGIgXU0DQogxwgq9CBAdmR7SLXfsHEIEAt1Ta8lW9sD5/srztUU1YgsCbXchqmNeTiFWy9oyY5z/ld/r/yVgG0BW2kQBxSAqG+zozt4eJ/sWL+gZv2FqwWWj0vbU0KgPqzoymf7ejUCY5ijEl8ZR9Rrqf4Gh2jm3SoWml0/3CNt6oYC/Jmif5UKiusdi1uJrj/Ou8Bqtb+dXVk30MvuEcqRRn6yR90CSl4QnIUF8H7I82sTRH59BSzLGCIw9lgpn8aFPD5dMR8efMZKC/vd2CXyxrLAdKxZVh3M1ZxgLnwGKoBjyiIYl9/GXfKgi0zoLgz8tAM8Sso7pKVY6K4o+b4Rgkq6BrGLT2nkHo/KId7VoNB+QwEKU2Hq1C+6q4+duiTt86ww13KWkNYXM7MHz8VNkPLJ/WfUcd2YoQI+OwejuITVNfT984NqVr3L3rl8M3o9ekTspPb9Xz2RO9nMSPSiqLIwTwafLsvWGJ/P4MpKqbxdZjkpGNEVySRicVkG5JcT6bOf66VbjpACLqepVmT4Mnuz7YxVYf6rdw/1h/LVpWapd5y+yWNFkQ+4VkD0nOs86QyjyHPiI8y3pzRpyBgvUcmIXSYoO787srqdJ/gBhwfBYYNjPMq4RNL7RkmXuVOYLaoPjHdTfYTWfjC8dRY1ShKudFjI+xGfkwm007JfOp7jb8qlH2BvsvFX/qspYVAtJ6hRDBf1GbYaHmn3HpCB5emi7DK1ASMEN
 hIdWCLiJ
 QG7Rx+WejFCPx0R6WuFa3N5Fs6YCBr6QjHO4h8kS01KbFHTqMG0OB5YKBpW59Lv6WEBPVCilBx8Mejhp0xfLA9SlA1VYks/qTL47xn0YAv1SCDkUlxm7cFZ9YW5YHmlgvgJh2wiBQ53k1BUjQAH4YMffAZ5gkhshE3ModNWADh/gC/rLxNInIpDSqg0snL0AF9e+iTGhrpXI7RzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 2026-10-28 at 08:19 +0000, Dmitry Ilvokhin wrote:
> The kernel provides the __nonnull_args() macro as the preferred form for
> marking pointer arguments as non-NULL. Add a check suggesting the macro
> over the raw __attribute__((nonnull)) spelling, consistent with the
> existing attribute conversion suggestions.
>=20
> Examples:
>=20
>   WARNING: Prefer __nonnull_args(1, 2) over __attribute__((nonnull(1, 2))=
)
>   #11: FILE: drivers/soc/aspeed/aspeed-lpc-snoop.c:230:
>   +__attribute__((nonnull(1, 2)))
>=20
>   WARNING: Prefer __nonnull_args() over __attribute__((nonnull))
>   #11: FILE: drivers/soc/aspeed/aspeed-lpc-snoop.c:283:
>   +__attribute__((nonnull))
>=20
> Signed-off-by: Dmitry Ilvokhin <[d@ilvokhin.com](mailto:d@ilvokhin.com)>

Seems sensible, thanks.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -6856,6 +6856,7 @@ sub process {
>  				"no_caller_saved_registers"	=3D> "__no_caller_saved_registers",
>  				"noclone"			=3D> "__noclone",
>  				"noinline"			=3D> "noinline",
> +				"nonnull"			=3D> "__nonnull_args",
>  				"nonstring"			=3D> "__nonstring",
>  				"noreturn"			=3D> "__noreturn",
>  				"packed"			=3D> "__packed",
> @@ -6876,6 +6877,8 @@ sub process {
>  					if ($curr_attr eq "format" && $params) {
>  						$params =3D~ /^\s*\(\s*(\w+)\s*,\s*(.*)/;
>  						$new =3D "__$1\($2";
> +					} elsif ($curr_attr eq "nonnull" && $params eq "") {
> +						$new =3D "$new()";
>  					} else {
>  						$new =3D "$new$params";
>  					}
>=20

