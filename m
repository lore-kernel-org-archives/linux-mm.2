Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB00606A325
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N6p3S1zK
Received: by kanga.kvack.org (Postfix)
	id F15BE6B05B1; Wed, 28 Oct 2026 05:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7456B05B2; Wed, 28 Oct 2026 05:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5926B05B3; Wed, 28 Oct 2026 05:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B586D6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:48:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1683140317
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:48:04 +0000 (UTC)
X-FDA: 85371558888.26.DE9726F
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id BFADB80004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:48:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N6p3S1zK;
	spf=pass (imf02.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793180882;
	b=ovA5Rf2iVIfdMFLZqbVIw6iHmpT6SSXiZMS/ZlkxCzkH8/MZQ1yFEU51SHTSkSZK9smtdJ
	zc69Ntu6GJCMrb6zwJewWPk4RNh53rHytmMNnwmcmW8pY/dplnqINL8W3wvcKkS+nwpEWJ
	7di9G/DOPYjDI72w4WHd1D6f46mbILM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N6p3S1zK;
	spf=pass (imf02.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793180882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gl/4Yc6JnTMakWEbHOettwInvSk+aSwCfPGu2bGV6uw=;
	b=mT+F4Ix2D5k0zNZv8eD4zFwUWp3o5WguKKNpuAgkGt/o7dUra1q8n2f+BlulCTn9+jcqwD
	NkOfDnp8VAmkYz15WgU6+owagSbNiT6zvdhqUCOVQuCackRYg+WiqxDnOyxXgM2rJOZxbd
	B9MAOpbKZyxe1LPIVJGaSgaNY/woqsE=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c46bd7a7345so131530366b.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:48:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793180881; cv=none;
        d=google.com; s=arc-20260327;
        b=PMP+i5nOEMTWzm10PoZ2xEATWCJfUKvIfMA7GgzU5TTqKIK3og42oLATOz5JjQ2yDl
         hRj/SMmLNPPzNdh5ExqqP1FVKddcAE6gu2G0ngKBSTme7tOpuuwEI38xi2U6kwfTGDMX
         rw2OjYOuNggvopaeJwPhd/4HCFEidQAERMVC5uQ0DmdL8UGOs34Er/hXQ+KEwnEtNy1e
         2KQE9iDoFrObshXw8FrfJ/Hsr/RZe3r4KouioqwdHVnvOB+C8gU64PonLJnacktZOy+i
         VofAkTVuGQriw4fkP3Mc0kacgzyW2m5LzlIUNWiDHqNg/+6PDNoNRVo0bkpbHiGHqJ7H
         LWvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gl/4Yc6JnTMakWEbHOettwInvSk+aSwCfPGu2bGV6uw=;
        fh=biu9i4kUJGAjek/h+VGiGcRjfLSmV+gQyk3jit2F1vY=;
        b=AyWgiJlQcAm7iS/Y0Ccz9nL9VTSz0WIW3uB/5cTQaMwvMVFuxq3DSOi9/TxbOsw2yY
         JP7eO2xNOEGaoqDIYSuhG0mCpUwjWJxm6MGfLjZFPO7MaK2IHyedBcYfvtlTRA6AACsi
         cGOQhm8mqbWi32yAGYh7CvfDoIV4aR03mVgCFbgi6i7On/86bizR6A9MzR6UOwAxJKGL
         H0qg1fZhNTM9xxaiY9CvNmCiKph/TjPD/0Nl0dnkjqXSDE4OrwkHkxiXIp8nqhnRZdDy
         oT5DTFrhAli4RIMqGyn4evRp06tNSEwiVLAn9bNZG4jQmHMN+hjgI7P78Tn10zle8/Dg
         nB2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793180881; x=1793785681; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gl/4Yc6JnTMakWEbHOettwInvSk+aSwCfPGu2bGV6uw=;
        b=N6p3S1zKWEpXXy9m2Ib6WFhllC9GEIKqq0Zc2gHX6EZetGWdRl2sNhVKDSdeVZHaZm
         yAWS5LLf6cUaDmI9WJtwgtFMmNwky0JTpwThIn2fyMjSz1NCqdQOgkNjwQTS3A9e0Gd9
         RCWnp/It0QCDCxTXAaDB/5Cw3rM/dDXvEMEdj5uumyg3mcOrznXWsf82cuSur7cvcwYd
         vwBdDGErcXEQkTgqHQmbllaKm9uDzJZw9RWg0r436MT3avkh/LkgSfjZABmk6h2lqdSq
         sSyvv/y5g9wbIvA6zhkf9mp7NuRBG1h51feCrESTYox0MaQG02mpDxdjjaUzOzbtrqOe
         3Iig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793180881; x=1793785681;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gl/4Yc6JnTMakWEbHOettwInvSk+aSwCfPGu2bGV6uw=;
        b=O0uujCC/e2gIbwL/plsVMPspWYNVtMhYEGSVKVHdANEiEr9NEz5zSUYw6LDie6OEem
         4MYp84Wpe9I6OPwbGbj4E0asLXLhfvkRXSwOy0dj2eyY+FjZVLpnkucywcOc4TQborRd
         3rr2F+bxK99XaCn4tEDm6SG/HAleZeBZdwJoV0BbQErFLIdk09WMQ6X1EiIRtJd9adix
         XGA1YwWf+LHVOYU9wTCKleY2HxL9YGMWTMMN1Gw9dIHlOdUv/p+UiPrqSMAFCLi4hvun
         MnqtOIfVe6211ZYmls/cucbMnuvH6qbEgz+0KvIjYrYRup3poLAiIof5DY3D4Wwtn4Cs
         lSzA==
X-Forwarded-Encrypted: i=1; AKwUvBxAhm8cDAkL17ouQIYzHcK+Icf/nORfrdhJ+pZoAl6/25ZYx+ZjK4wJtgnjnyV5dRDH3PngC+giEA==@kvack.org
X-Gm-Message-State: AFq9FYLTNCHZTeZKr/c5aO5gJYDwwAYA9HTHX+PRs2gthncX6ocA2v5Z
	FbxrN8z9aH8qWuG9ftwvjAldca/O4qXJbjGZJ30BwVMGtNWRBpHIH3nLloV0XaX4OixCZAlAWhR
	/wLUVGU5prZvUzsNQgawD3RPl8PIyMTY=
X-Gm-Gg: AYBFou1xF1pFgpH8pB9WmzOs5XsoZ2ismhS4amvvheA2w6n3u0rKGZ/3BFh8nkMPYCa
	X4Qqgd+OGiohZsRVr8lV8N8WNsZ5U6YoqN0e5w45/74veMg00pJc01IhxS5Q6nwSssvncA+R145
	hOWLQVewm9IV6H7veKrhvPBHso84l4GBV+AGR0XQ+4XwGoXVvngR4zwCIcCxKQyfr2H8k97g+Jh
	03wdYGDKIjWbptUp+TGNfj/rh02Uf3uxk6CIp9JUKqxbH9mj+YYhDzdWqRuKQUKQ1NT1bjE0/3p
	rydEkRx8gbUYTMDDT9Hi4OBENh0nBkrvOlNwBWxmaTqWJNM2PN1CB3bPCJCY/w3ix0Gaele77vA
	ckofzG19J190UQDKD0Z2mfC6X0wID007p3r0kcgRfYryNiG8WOdWGo7VxumOUCyuYXtCa7nFnNo
	obQuLuHNW1gFqNnuuF6VNzD2KdX8VW/oyPqrrHEME6+gGpe1yNhEnthltwq7eUVaExNN+jRg3j0
	20o4i2eSbohEO+EeaAKNS0+hg==
X-Received: by 2002:a17:907:86a5:b0:c25:f7db:4bec with SMTP id
 a640c23a62f3a-c49c6357d34mr69949566b.18.1793180881026; Wed, 28 Oct 2026
 02:48:01 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1793027261.git.d@ilvokhin.com> <580fdfbe2eb6694438cbd8f5337bd2f1edac564b.1793027261.git.d@ilvokhin.com>
In-Reply-To: <580fdfbe2eb6694438cbd8f5337bd2f1edac564b.1793027261.git.d@ilvokhin.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 28 Oct 2026 11:47:24 +0200
X-Gm-Features: AclHuK-8N84O0Y9k-BLOPVpeywTja7886uZe3ugxN4eM-96m__IvC7bzZgS0MkU
Message-ID: <CAHp75Vedr5J1WJMrAkBjRSLKA_zf1kt3GD6UhjzLcy9vowxnaA@mail.gmail.com>
Subject: Re: [PATCH 03/10] lib/list_sort: Switch to __nonnull_args() macro
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
	linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BFADB80004
X-Stat-Signature: 9md98ejtg6hfuzb4qsdgj61k96p31gp9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793180882-765212
X-HE-Meta: U2FsdGVkX1+W2DSIQsPSA85DE6J8p/31C70nLkS+pUZPz3eaGFEgyspqRQ1Y/nkpOurJq9Rnyphu1fD9V5S9DQSY9HfDEVshofWGkNjz80KnRIBoh1TZyl7rMqUGvHuTJvxsBwIRVXnXQlALM2OFYI/4dg4YUSEEd2tYid4BJnmveEQk3B4JgoUSoe+z8FoYjb4ZKAoLy4qDt7YajS2YDq5ebdJeQOCC45QPfVPCw+bGuZfVLfllX5AK0rcuUUYKHLvNCRjU96fvXyWR7GxFc1UIIpLuH7FhEuz5FJ9gFrq3usbMf4gysDgkLz9STG0y0GjzicD5Ff0km78dFnEeRK1eNAaZ/rFXeM8A86xJii8BbM2T7QFp2IZ1HUdfeLnMgOkVhm4vcpYL2EKpsBrgYtXgdgWwFQswNLpIKYAEhSIHasMHSHaxc8WPvJZfypNwPy5ILscPj5QUBr4RlgEtLLj8RA8tAY4QRW0LZC2XIQb3iRX7tvoyXQ8evCPZEQGqYgQebuRHGCfOjGq9akHVxMwurSPG+V/SC3Pk5bezruxqi0MuYvDoB05PkRFIYdwTPE+2oBUmuCLX9LouFR5Ueyd/UNM0yu8M3jULOpxNgyLPz7NohZPwaXUT/MVtw+iG0fnDNng/OYMu+ahzM2oQgRpKl20l1ixw0VEC4tVdZryZr4UgDXan1Kntep8oI7CdKhoGfkScHZsg9TNgK1SC3CEsQEfLJNwOCgOYtykyrZ5bo0bca+hlRXy4FBro9dbRAHIRtxkCgxmIPdnO5Prn2VGkWSvnf6d3DUUTkxZUY9n3WFmBtvuk1HtG9Yfv2YRhS+tVyWbF1Pdt2QM15I62EcdfnGcSSLaknzwKYxkrxSaPR5tAGnkZCoiE5f2vmV4W3aMjGTmuZYP4wCsM/iCj5Fyj+Gk6OE+sQZ8KCbDrh4gnVdG3b9SKtYFfP7zvLTw8obqEZrEyduZnR3LaYZS
 7rnEsw3n
 To5GhuKbwgnzZkr8+u3pJ9swG+ehEmna/fqFYPyWXFCpPy+Fwac4WsV7PkGzJBWCy6rCdIA8Eb47o5QaIP4OsG7IS5zQG2osvGWklGGr/gYWQdotH0u50Dh7DlrUL07tBAZZ3tSfO/qVzuuDYizr46kpA3/0TM1+zQaPqbTEMW9j5l6AosGBRqYATFAbuH+nYmYP1sQzyqQdf6+OScOIbIpYQ09ueLgHk9ECEv0ppSbMNFNJbDZ48Ds7JH3pOwWf51ftdNBHw3is4w+/hB1gmz28mHbjRvbfOUF9NOfrh368mhwxnPiP2TEyv4+NalcVJYmo6BQItuaKFYcUxvFAL5Q5uy+lqQMzq8z4FunRtuf0CEEU8ycUztNCKuYol7Y2/XTQi3Ryy9Co/YHMtcdiD+iuavAS0DYt/tQ31n1Z7p7TrKWp3c4Slt7PHleKuEap02Z2UXxfltYtyfa1GB+0baoHYkuXfBgOI4i3j/mRYnrXejZ/2qQG+eXeEK+oLoY72bKGGnHHdDvSH68urhpi0vHCnOayAxyLUGiFjCwj8+8OWnLNvJqPGZEv4tlUN857VftASG/VNnPP5O/hCrs7VWpLjwgJEwxwlU/G7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:20=E2=80=AFAM Dmitry Ilvokhin <d@ilvokhin.com> w=
rote:
>
> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the macro __nonnull_args() to wrap raw compiler
> attribute.
>
> Replace __attribute__((nonnull)) with __nonnull_args() to
> standardize nonnull attribute usage across the tree and keep the
> attribute's quirks in one place rather than open-coded at every call
> site.
>
> Add spaces after the commas in the __nonnull_args() argument list to
> follow the usual coding style (according to checkpatch).

Reviewed-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko

