Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E51F606A327
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jRmzhIrh
Received: by kanga.kvack.org (Postfix)
	id C4BBA6B05B2; Wed, 28 Oct 2026 07:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23BE6B05BE; Wed, 28 Oct 2026 07:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A5F6B05BF; Wed, 28 Oct 2026 07:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93BE86B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:44:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31E03140C27
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:44:25 +0000 (UTC)
X-FDA: 85371852090.12.1E51056
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 97849A0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:44:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRmzhIrh;
	spf=pass (imf25.hostedemail.com: domain of andi.shyti@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfqZSZZirg02/y7+Hu6+biXxEuviwtSJMX1/tfCGZ1E=;
	b=h0BPoT9vh804T+7suQYR1K6k7eeJZZ5dfO7VALtEJzcMWLg5S3EIOa+7xdSbv8TxQ4fEVs
	8FEqdqMTVoDpnZsyDlUvsUGMDkSS9Eig6u1fkUJYx5V8oYgzUJL7Ar/EdLVdsR82tOj9na
	MXTLLwz4etJFBiWXBpEackBowiCnoTo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187863;
	b=2iXMV6l613OqlYwzuZIdEX2LMOWBdMT4EEdy2XUy7h9DfX1N/h5X4wmKewQOGzUJr0m06b
	bIYue7oYtFzxH9Nk1g/cxiYnLMyXIYPThD4vkboPX2cSkim2i1PXvN5NZCh7j6x/3Qim1D
	EY1XAIexihLtuIDYBwP5yJjXSFhydJc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRmzhIrh;
	spf=pass (imf25.hostedemail.com: domain of andi.shyti@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AA51601F8;
	Wed, 28 Oct 2026 11:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8767F1F01825;
	Wed, 28 Oct 2026 11:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793187862;
	bh=DfqZSZZirg02/y7+Hu6+biXxEuviwtSJMX1/tfCGZ1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jRmzhIrhvjBYvVLWvF2JxCm33XYPEY+B4MrjzqXXXvADrFnSkcbsTJSj1MGwIIrNw
	 kWnTLeNPwAIyLJtJ9+tdjv+78v1kDot8qmeI/jSFN574FYwb0mRlc5drmbrKuPcITI
	 6FEhIHn8LraufNE/4d0Z/2AXNjo9H839co+kG/5xv740bKnWioo+cV4BJVLb2j3VTR
	 QyAxwrfZ8T8k1/xE4OmhivZaTmo2IG6MCOaltdGwsIaTczyLlCF7xdElyanabRWrN9
	 fzrY4h44LuGfWoyKWEoK4nCqnl3RBFNXiOdi+7T9W3f9T3De3jThVozlgpURldPRMR
	 pvVdbwZCrX23Q==
Date: Wed, 28 Oct 2026 12:44:18 +0100
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
Subject: Re: [PATCH 05/10] drm/i915: switch to __nonnull_args() macro
Message-ID: <auHf-pdvGkPibgTp@zenone.zhora.eu>
References: <cover.1793027261.git.d@ilvokhin.com>
 <33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 97849A0005
X-Stat-Signature: h7tymb6upr98ed66iidtm14qc1qfyffj
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793187863-167064
X-HE-Meta: U2FsdGVkX1/p0t3FyqcADz7ebVMxgCe00Wg9VgC6kfezUQW1HWLLT5b0A9QQ01+hbs+7iihP1T+TT0kPY9SLpYhwXtHGDbDQwPBB0NpbGzkeFZ1zcV57aN1U4SuKjdNfKeKaVHBTVVpwsOdN23usciV3Go7dxeyRpXl8qYjaDGJ+ZtAYyqCIyGB1J+z0mAAPJCYBa0UWNlPV89nHYbaL/AZbw513p/XY5oaVsh7D/u/oqc0m3uQh9QEYxHcXGUT78YXb7utz/nOAc9eeVR/1/ybnvBCyTR0bAgm7TuKcn/+mArliclZLqejLWXC5GheEP24SmnkyXcJthZTx8KoM1hJ9+ILJZzrkFJrp8ZvrNqkFWKMssp4yRM1XrasjQhkDWuHzBkQ3v5OKLm/ISs4yIgTJrIM7ewhjU1/f5gzfxGvXg0eDT5NUHGcMSZXSZZDjZvn8ppWJg0g0htEBHXs4TUtR2dhkRlfLyCBY+zAMyz9ZeFVeMJ+fbiy0CGyEvIClwJ6YNPD/ILGtM9ua/fu6uTfGqyJRArKQUfLW2Bu/RL6d44abV4bfh17cl4UrN+SdbJ6N3QJLplg3uv7axFruJJarcChTvRWIL9XF4ziGpRjEHPFKYHuidHwsXaCUbm3DEZ7lI5IhXBWI6tkuqLyCON0LM+9EXj94rJ3qr8eWAX2vle3Rh3FIZ1aX6CMp9qaiAb3EIQeKOdLptVe3LsaxgV8xESoOGuYIP0zWZSZ6MecLEsq4OCzep3fQ0OXje9EFOoOLeHdW8vrlxexkGds6Ek27xHKN9yJP9D62pvqBlqB+WPudzZRP7pmV6taLGpjbAutS9gmD7D58tP7DQ0woJceSL66y9bB76GjT8NBP0z2Pvn8ay6jJ5UFpFl5QlA97Jf1rjGXPINC2uJ59us06WDAoij7W2H88KJabAGEWHfycYX+7y2VSRV+00pOxa+jrX1ObA8Bozs7kX49iRGV
 MJ+I1Nsd
 h76i4eN0HGclItHrUvHOPE16sfbWPpJeCvsXmczLfj+mFsaDg+2hQftcJVOzRJZp+Oma0hRneSPIVUGXpGgxP09Eizs90ZeVaQDnPx+arNJ+6GS/D+LAS/OU+PP0jFTw2g8fVomdCxitNbiFxugQj/Lh3Y5ssSTChwV0I71cvX2VYdG2LnlYwPbXOq4IIRDiKAU6SnvPPOkNYdR/UBuGWJ7lHvfiTgPXdDEPu8C5JCu1k395oobqss/cqraGmkyujRc2UW3J0gBHMZ1lW8/YzwjsGOZF13bA3wEVjt7eY9LhQ5XwhYr8COv/mbhIDlg7mn21oVM/CUH6bCWWriF+KwMWcb4hjYAlZTHv6nYI9Bxdb2BXDI00QW8iii5Jm/CbtcrHjsYKbca8fIvOMy+R359+tpE6PA/fIxjhs2U/PLLxfOoJn73OirPp0C5TyFN3opF/r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dmitry,

On Wed, Oct 28, 2026 at 08:19:44AM +0000, Dmitry Ilvokhin wrote:
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

