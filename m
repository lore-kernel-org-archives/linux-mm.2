Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77A6606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=oa9j94Oo;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eyWwh8pz;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=oa9j94Oo;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eyWwh8pz
Received: by kanga.kvack.org (Postfix)
	id 083686B05B2; Thu, 29 Oct 2026 03:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05A986B05B3; Thu, 29 Oct 2026 03:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65206B05B4; Thu, 29 Oct 2026 03:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A382D6B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:32:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31F49A7C06
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:32:47 +0000 (UTC)
X-FDA: 85374846774.09.A0A1C8C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id EB44140002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:32:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oa9j94Oo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eyWwh8pz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oa9j94Oo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eyWwh8pz;
	spf=pass (imf07.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793259165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1JEiGypUZqrmUCmocO9jwLOxx5nBN2nK/xOgDHuNzs=;
	b=cbeLWuMPSX3JkZKYbrtfiePK9OZJ0shc88QwEs2eFysUEw1Gea8Y9S7ch5Kd7DLXLCoLY6
	9nQr91oAwT0Q8SIJRbvrojXBO6QPfUhawcAapeOLsltWCfanIYOqrdzrH4KiOBFIxUoFEb
	r+t/sv9kBZpoEnIIFZYXvXeJPUOT8ko=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oa9j94Oo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eyWwh8pz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oa9j94Oo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eyWwh8pz;
	spf=pass (imf07.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793259165;
	b=wY60tmkKwIuI6SYQOSrcLgPVTpzBucgKd38ady0nd6VkZyPoGC/lijGikbqwJHJFSpNiyR
	4914YrxeRU1zimLh/BGRmadXDBcktCfcv92HI/Xjr+q5dh2wsEs25xp56fUKZF7YKlSr5x
	TT8eeLijeQwLzQ4CY4vErZGUSkeUmvw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 44C9122124;
	Thu, 29 Oct 2026 07:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793259163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U1JEiGypUZqrmUCmocO9jwLOxx5nBN2nK/xOgDHuNzs=;
	b=oa9j94OoY2FodzXZwJXPTumJwaR5GxD1p3BmxUZJ2WDa3tjbj0j6NyJ+kQH3VDOhXdopl7
	nYpG5+qs5269DoHX+wRwChXPKZiYaxEdF4wz9dV1N8SEGMwZJz6bPdghp7tfZEJi7cVwHQ
	5WpmhbK0tl9xvUTJ4SfGI7jJPTpw1V4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793259163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U1JEiGypUZqrmUCmocO9jwLOxx5nBN2nK/xOgDHuNzs=;
	b=eyWwh8pzID12vO1dyJGt/ezwNlDUKwQtxJx4zxJ+5e4h8YO41r46Czm1Z5/6oKOET4y+At
	ar3Yduv0n1uuw1AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793259163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U1JEiGypUZqrmUCmocO9jwLOxx5nBN2nK/xOgDHuNzs=;
	b=oa9j94OoY2FodzXZwJXPTumJwaR5GxD1p3BmxUZJ2WDa3tjbj0j6NyJ+kQH3VDOhXdopl7
	nYpG5+qs5269DoHX+wRwChXPKZiYaxEdF4wz9dV1N8SEGMwZJz6bPdghp7tfZEJi7cVwHQ
	5WpmhbK0tl9xvUTJ4SfGI7jJPTpw1V4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793259163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U1JEiGypUZqrmUCmocO9jwLOxx5nBN2nK/xOgDHuNzs=;
	b=eyWwh8pzID12vO1dyJGt/ezwNlDUKwQtxJx4zxJ+5e4h8YO41r46Czm1Z5/6oKOET4y+At
	ar3Yduv0n1uuw1AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3724D13419;
	Thu, 29 Oct 2026 07:32:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id weEVNJn24morCgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 29 Oct 2026 07:32:42 +0000
Message-ID: <fb3b6a24-74ca-4da8-8593-352afd515313@suse.de>
Date: Thu, 29 Oct 2026 08:32:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] drm/gem: Switch to __nonnull_args() macro
To: Dmitry Ilvokhin <d@ilvokhin.com>, Alex Deucher
 <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Joel Stanley <joel@jms.id.au>,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai
 <billy_tsai@aspeedtech.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Kees Cook <kees@kernel.org>,
 Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft
 <apw@canonical.com>, Joe Perches <joe@perches.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
References: <cover.1793027261.git.d@ilvokhin.com>
 <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -11.79
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB44140002
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 8e9kgsk7tqq5x4rj83xxad7sakwmfrb3
X-HE-Tag: 1793259164-338539
X-HE-Meta: U2FsdGVkX196+TSYjKe2+ibj/nNXoXb5uyHV98FOzhSZdUaYxZupaAvZYz5w74pqQYCSza3cAvn9H8tNaoWuv6fzxnZH38D2BxHXs7rXevyFcYWxwV/dIP+/95ncBts/fCBVCJSz7KegNPLsdxl4ZH0BU/2gmGqrJkBm4khuTtabTemfz9RU75zOjHazWiCJwbjB2dfVL33M7ZStsc0NeofQsLdx3OokYuqjWHgkQww3PXoTUFfdzZCLTKPC6NFRmVWUcAhU4U+H8v2Bpm0P7eWJszuAzpcHK0cVnArQVbLMnb/iQuPTpGjhs9QhEjV1q3BK4utwB33SyfnXZv5g/XfaO1D/E/+RONcOeHFJCS8TG1doiPfHs/Agm8sOcCYunqMgpvR8MiPocwqOGesFeRMfR70nW/CUw3OWcCqRHXwis76sgMNDlKS5I6YCSBBUuyTbWcJzGN7WpZzdJjudT5edVxZ7cC8tMMXKwsrHgEpqhNpWk4Yu03sQRcU/15t8EMeJRV7ao38uTGBiKlAm9Gv51nvzwa4qNer+OkzsHNtylaSRdvOMK1f+V8LzhbLNK5v0KLb5b/hb5sZHKb0pRVBudIt7oDNEdZaP9ABtr/kDw53/3lUUsOJEKKXdNdFFmaRPRZtk5TMaT4uYGUjQW1CJDlGZRBUESCshh9E0e27dOXzhEcF8P0w6nf+3a9j+ElxdxxKeT50pzM2T6Lrp2VKNJA6lh2yMfNWOZdcUS7gV87HhiM3IGjpFkURKU4eciM+80eugvsVp2l7i/Se/CmYFZNOcJ6pWLIEL85pi8TC2SP2PxTDNRgmzsaV+wiPqnLJ3RaHuOk2M5vn73Kh0aAGwqMRSE/UEAXjyRibQm0Q/E0nce/4zO1mPEgDhroi7ELtxLGZpvOgKqaBQroIOchv8D0CMxbEVpURZgVZRBNrkBHpd+Xd3JtWlT1mONef2mUZpbZMJ8UAVP3nnIEE
 HHvPkT35
 z/Rss480y9U7kQz4oj8MzURS7tF0LxGxm6hxsY9doIdz0dT6VHVofqbJyQjJi87UWh/jpaTTfpJkHcNt0HsklvfGW5LO/ZD+/gBqlYI7ITvR/9QSQlGR52XGQvx8HLNbL1kxPxKmoFnyvoCKuLIqikVTKZTpRE4Yza3owTrbQbm59kdpjhYm6NuK5Nik74+RZtdg14NYil7ipCYetWjib382nHeUKEGNOLBy/DZfGWUrGdeJRT4cI9EBqJPHQkZnJSDGj4c5aWFmgq5revNGjZ6FkZNENzcpGIU8YY5vfxm34w5fQmDbauE0e457QnPnRRzDKCoujTDj/4vAa9QIZ9kFQAelByJmAdpUbqti6JosZXiTcYxrn9hKGQSH8JswaqDoseSuR5Ft1OVilBIzcmFidv8vQ6DjRlM8EeY0lM1BEyx57mqgi64+M8C97wG6fMeoHhxuQzUFTRd0SWFjP0udaSziH9da+TiVM4qMItVv9lxrLhncNyHaFbk4FQWFX/jQJsBUkYgaZueHLwr4xokBeOsGIy1PchNTtr4flHLLdnHY1L6CVt+n2YD9nphYuc5BwrJScPvdxvXmqQZ5EFbLpQ5iO0Fegti0R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi

Am 28.10.26 um 09:19 schrieb Dmitry Ilvokhin:
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

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

Should gem.h now include <linux/compiler_attributes.h> ?

Best regards
Thomas

> ---
>   include/drm/drm_gem.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index ed329408acbe..56dd15921c7a 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -566,7 +566,7 @@ static inline void drm_gem_object_get(struct drm_gem_object *obj)
>   	kref_get(&obj->refcount);
>   }
>   
> -__attribute__((nonnull))
> +__nonnull_args()
>   static inline void
>   __drm_gem_object_put(struct drm_gem_object *obj)
>   {

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)



