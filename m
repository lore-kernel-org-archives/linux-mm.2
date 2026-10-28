Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4A8606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JW4NmbXM
Received: by kanga.kvack.org (Postfix)
	id E21E56B05BF; Wed, 28 Oct 2026 07:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9296B05C0; Wed, 28 Oct 2026 07:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F7C6B05C1; Wed, 28 Oct 2026 07:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9E316B05BF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:44:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52FC5A0C8B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:44:55 +0000 (UTC)
X-FDA: 85371853350.02.386D48D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A287420002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:44:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JW4NmbXM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of andi.shyti@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzxsreGIazEGHNZ+Tlba7bzQuuS0/SXodByMLbgqMaI=;
	b=HPyNCneCD4pQDXXGMFArwsuFP8fiQRdC4nFMBWVYQS+vJ3omPEOEd+iD0niXI7kn9V1LO2
	+kzdblbNMs4MmAVS1DCoe3dPOOTcxvSfxAt0iJQQOJXJZ/nXK5b3O9EluEh6J+MdBhiYuX
	O2WF0AyxUMyZO5rNfhGZKdhnvRivJgQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JW4NmbXM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of andi.shyti@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187893;
	b=RCwf1YT/LbNR0bjtYyBJ12QkwU31YpSUN4auDG8W5YZBJGVLrFxo/Kc56dWJ8/hR4QD+5Y
	zVTzPMLx5X/dSzcY/LDUBV4MJUBDXrynaAsJpz3G9l3A1onYiHeQnGt1ecitrdcSDRix89
	2qFnpBerm7cRrOeh4bK3Aab7e6SRgrs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E10660120;
	Wed, 28 Oct 2026 11:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7167F1F01825;
	Wed, 28 Oct 2026 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793187892;
	bh=AzxsreGIazEGHNZ+Tlba7bzQuuS0/SXodByMLbgqMaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JW4NmbXMV9NgnBU1HlqkVlN+rre+4AqJtfnOYsCrZ1r+jx0JuneNnyHXtAgbJhcCm
	 oGoH7Sf0QLhsPHYJ4VS3tj9kTxIwtUgUtfQrlW3PBdn2exn76z9iW9PGXPGM7wzI9x
	 At4s0hoSb59+TSET152LixjqCST6NybH81zHXNXle6qHlbYtt+3P9F/grboN9LPDNx
	 xzflTm1Ec4mh4z9eI8VLirREUz5LLnYViE+P42WUDgoR0QejsFy2B/B+DLWbjrllQj
	 91G7GnwWDaZoA9reF7WmdaYzo1PUQd8JuF3UHtJOxu/4CYIjVpedfBJtBtUN0pf7S9
	 lIU5MaIshhDuA==
Date: Wed, 28 Oct 2026 12:44:48 +0100
From: Andi Shyti <andi.shyti@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH 07/10] drm/gem: Switch to __nonnull_args() macro
Message-ID: <auHgHcU4fYauP_eD@zenone.zhora.eu>
References: <cover.1793027261.git.d@ilvokhin.com>
 <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
X-Rspamd-Queue-Id: A287420002
X-Stat-Signature: ess837mqaja6icu9apj7yqz78qy8n5zp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793187893-610363
X-HE-Meta: U2FsdGVkX18jKmFysRgWyK7LgvwUfXzyLIEBYuJ1SzgRiexLw/OUukyzsJmwc3u6hJDTey/rqcyV1yWGE0HWh1e6jCMTY0Vr95nbyN+Wz40bO3M2i64UeIRyVF6efG7JxX7JmvGSbv/6WWPqNzetOoMc8Pk0Ei+ZT3AL+qOwMllCUcu8nkM7ifPUEBRvqCY/rVEKxKJUCVhAKsregFCCq/CwSAmoNC9FXXPVDH7GPuP1KB+GcTuBx0vJX7YDLBO3vxtyLlKsaWvR+5ZtuQV8EgGZkquyZoKXgLwmouUhiLG3Y32hhlF5fCztPAR2XGAYddlNnCdD5jhKNZNvwe6gEUV01IyORhmWh87Ry1j7CSM6qIZz07BiQb0PRZrrgqxv6ev5LhnFixqJZZaP3Ht4W+IA2jrnqIgDP6D/cUh4Suy0XSNGPbKRzyWLPOAhVbBB2oOJexUeuW5lVZNiKvtKdHNR4/0vM+laCACP6hAEHwOk6U2PoM0JmW+qwmi54pNYTJLP7SUl51c7BzsohwYpQZz/4TdHT38ckBNCwyh5zD7NhFOdY7Im1+gd539MbXpv+cdCGJfMdxmjAaIHKip3QDAY+rQTRzLJf05lMtISZsLrJiN3VK1J3B84Bx+O4XKWm+qzqvPLOPiqdKs1lG3vDMIcoAFgKaJwxXE4bzLvqUjByeG4aOHR7wreZrB1Q0gzCwL7/g+BpBbKGE3Bvdn10zoCO5EqH6Id68lSy2/ZfM+Q/4Omixk6c9aQ4h9aQUKZt2tyj/XWYz3vXAwmDh6Hxwsc9w/e9k72Ag2VhEDnfYOY1jbMW0jU7pefgR4phgSwG5VQ+ZWK8YF6ZjwxE6aNo23QaZGIgKwfCBHKCAqd5kTC85jDDRn/0NrJPwr+6dVYLu7tniipHYo2abRVUTeoSHASnV1onTywOaeDjJKWPfb5wfE/07A5GdaC8W52OVtGEClNh0qqhswcfgGfgEg
 l/Y87+c1
 AZLKeL4VspEWNQAuNUqxqXRtcqJza0b1vsfSbbEtOqD5R5DAldMVz5ztS/7by+o/ak9eENSKAP1PxRidD0hosj0qSUW7ZewF92nlFisdv3spnMwUZXXa3xumQ0T9J6ZnRbs3FwxxET4V2+VvjYoDHwDxleovCaAb+D6vxgQC+Lo2yElHS5pyDSlPYph1tU7UaCwOfyjiimIZBTZmNyc41Dzmug4tX6TQKQkpFGZ/pXvFMfjYHfgyUSp6FxY7eEq9nWDsXbSq2QLx7MH5Q2tNykun/kwOQ+lXZi3g2I8vWGOPoM42aLvdx4uiylyW6KdTIcRzwfj+EU/m8z1voMTuNKM4dgSW1loM8CwxW9hO1Y3t2yB1O/qxo/3seaUpGeKAgyozzZFp8Th0KYGodtLcKCDUqahNC26d2nym8eSbB6vwuLLwa58tl+hD+uoxhr2FMJNEQlwJLSoCn/yl3LnYApEcwDiKEmm3J5ANSBWloSOrjXwSfAORaIEL7CMFIthSeCS2jmvOtd0u5+DsPdnbYKKq3WGPECcWKns8ePvypw5v1y1hf7/PZEbBNfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dmitry,

On Wed, Oct 28, 2026 at 08:19:46AM +0000, Dmitry Ilvokhin wrote:
> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the macro __nonnull_args() to wrap raw compiler
> attribute.
> 
> Replace __attribute__((nonnull)) with __nonnull_args() to standardize
> nonnull attribute usage across the tree and keep the attribute's quirks
> in one place rather than open-coded at every call site.
> 
> Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Thanks,
Andi

