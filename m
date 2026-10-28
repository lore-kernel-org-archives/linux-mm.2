Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C1D606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PeoZYG9L
Received: by kanga.kvack.org (Postfix)
	id 5C91B6B05B3; Wed, 28 Oct 2026 05:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A02F6B05B4; Wed, 28 Oct 2026 05:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FF66B05B5; Wed, 28 Oct 2026 05:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2032A6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:48:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0CA0160C36
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:48:56 +0000 (UTC)
X-FDA: 85371561072.04.3C88D31
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id B506240005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:48:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PeoZYG9L;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793180934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcY0Gi4dcvyxZkHDA78yGLoz9GDb1HPFjbtFx6GpqEs=;
	b=AI5vPoLawEMOTw33yuQVAVI1u2jHRIlNORll7cr26dwWMbhnzl83QdjyJyJy8Mz1BOvOXJ
	PG7KuxEtVVl1nXg5SDKSJQW25XrXAKmVgafP/KWUYTyiZkd/AoaL0BF68tl2znDXxcGgi5
	xLIeQ70ion9wBBykhkEpmcusd1bVz9o=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PeoZYG9L;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793180934;
	b=inJWYgDDedP7MIu/AE+FCguEQu1XxcO+S+3XdMcoG7kwuhfuu52sLYIuN3IAQ6HpMWT1q4
	U60LZU4uvtDaen+Vvd8hVqirjk2JCM7rKCpV1TIyNg2nm+0lPlvG7QMFeaJ3mgoj9s9u4q
	/sjY8YEVEC5KG2A7giwESuC/W2T0IWI=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so1342379a12.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:48:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793180933; cv=none;
        d=google.com; s=arc-20260327;
        b=D4FI/GTuzhY08W18CSCuPtyWarrQtA/bURG2kTwnOofsuzfbYPQONMnM+bE08fbJci
         e0NDsIvT6SDadh0pkVu7ImgcgrcWqKVRM5JSv9PXjKxJHnAXMeoYrY5n7ipO4gCvNnfS
         CyPGtVola07p6ctQkjnfsYqvhxAtRnu9vvffyRECzgEzR/pLRsyf+x8nY87fnRkUyqkK
         5trhi5QqlcciXm5WmhiF5XZGaDYiGvyiYLDp4x/iZhCKub/CR4R1lYhByzek8unJ9QSS
         MKIyc/QxlOWyJEdmgGc60EgnDWvXpySzQRERjypp5Kk73CJULEDXmVgbKUZj3QfPEfQn
         ur0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dcY0Gi4dcvyxZkHDA78yGLoz9GDb1HPFjbtFx6GpqEs=;
        fh=TYRptob6hMq4P96j1FGoq90/XX4nNH+hplR2R0rzBJE=;
        b=lxON9ozIuPhGPgyTB701SaXwPRlq0h53QAnU8U+AmTF3gDLGKYWy7dHhkzSeD1o4Jn
         K48CAf/ZilrPKJ4jglY9Jge2ziTXT+tGH5Xo+Ts4aUo2iKdP0gb0RmX96DGdbrxM8jhF
         ak/OWjDPmUsFpBqYROIzZF0rlxqobDUGHvrHh0jCbZcIa9Md9K7I+596cSdpVJR/EtTa
         3VsRrg1af0JtuhHGIkqkyuiy+yCb3j6swqWIF9OBgY6Vu52GW7uhQfYCpnCtxrZcumPU
         SmluSmnSakpXONVtmAuwcdL49uJVJY5KXDq2m1O/rSTwIjByagFWG/Ch2QBDEwV8tzeH
         kj7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793180933; x=1793785733; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dcY0Gi4dcvyxZkHDA78yGLoz9GDb1HPFjbtFx6GpqEs=;
        b=PeoZYG9Ls9lCnXukipHMS1ejBBq4X4bemjBG/2Ht5iYCc7ic/3K+jE4XPmVdvrC9qw
         91m3oyK7LHfYUdgGO7BrxBUnb5+4wEvx2N/SKZlNows5+j6X0L7bzkcgeQNl13Maj0cp
         l+37yq6ZZ3Pqjb7H7/SgDndfiZXcyd2XCS6teU1qjoAIYhhkueB4tudMwLrsou3IP11q
         RKPVO6B5YcfQ9jkupoXGthaxGbKgrVWjwWGc4vCWqH0ryxejp2zEIN0tKGYXxHrk2OKu
         h9v2osfKwlcVmEO6NmYRaQY+wmXaSewAimhOTMVyAcbngrOMFDpTQm/XhVY1IoPy8EJ0
         z1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793180933; x=1793785733;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dcY0Gi4dcvyxZkHDA78yGLoz9GDb1HPFjbtFx6GpqEs=;
        b=0xvIGvIapnSvCW4yuksveeqVllwnqQqd7qJoLCyEcLMPjPMLjWzSdzMcKyDoq+O90m
         WyfQhe4Mvy9OY5z5lk0Zf8WTvxRhjuTBOBmiIupkzsaArMmaNagY3YxABjKLcexwk88R
         Z3EF+b4F/j2tt/56sq/pi/I1rJnvakuJERpzvlaZFerdf78tL8ZAZFBpgcLJSRnBTJQl
         8JA7eyxEiwdBHaFbAaEpzHmsanTHMAA9fXXUDudtKOFcFDS0BTbJCnfRGEOJ943O8e4S
         sPSa1XB6A50nXNqBwOBwfLiUZ9hRMbMYKP9+w3ybpm0Ry5JiEWYT/7pBDOt+B1qbfVr3
         H12Q==
X-Forwarded-Encrypted: i=1; AKwUvBwVeSoo7wRfi0FB0XsAz9xqFhzxzOASW1rOjgmOlbcHj59LpSobcPoJRi7f7Hf+wdKEzRS9V5FuOw==@kvack.org
X-Gm-Message-State: AFq9FYIgrO/N8A+Oc9kTL1MOidkklifwRUlUlGuWC27usqBfRb+8Cbkx
	njYZRqDjAJ0gYZkOyjTKmgq5ftemEr/oJSlEOBYRpkjMJQ3YtJkVLpSHAsd7jo3t12VYVYzUd9s
	KlBDLXi+deq7aif4wEgVycM/yE8ChXv0=
X-Gm-Gg: AYBFou2x9PTuOFPsD+cXh/CmtQY6KfO9vMGcY2blusyiBEtgpP5CQuFdL6xYpn5GgPm
	m8qmUNCy93WPQ0GKb4hHi6qlPsyV3hJTlQgHrfEe63rBu9s/JBaK7SCfAD1Z0icGNxKZIRtYM4N
	sROQVapKOGpqrYoRE0Xwr0/ooKiJbfAIlVZJyBK+tFMi2JV5tHTHHO+2SlpdrM+YEfDsjZXF8qp
	li2tbg9qe3Sx2H3e4n2RaKVo+KOPU7ZOOXu7L/O6y1xRNIyohk9BkranVagZkqCtDzsR/QL9blH
	7Qq5rcILpyKfVEirvb5JOsSd3zqBk87O9OqjrY3+01D5eCLb9igGfBGvL/cqMup60GfhyvBHSTK
	mLQVei5ctFwcvp4cjGmgLLhcKEe3ZDZAFJ1FrGqqRVQ8J0tiXy7yi9z5ZX4n6MeV5IFrUmCIhqa
	B1hs1NWBtSWGrOt6DfIPtxcrnHwoVreps9720qX2YOw/W55lgMRoJLwJlQ2pAROF9Ptfb+KIXt+
	ktbynuJxI7H/Ca2StaJu51B/w==
X-Received: by 2002:a17:907:a893:b0:c46:8b51:c17c with SMTP id
 a640c23a62f3a-c49bdf394e6mr156034066b.17.1793180933042; Wed, 28 Oct 2026
 02:48:53 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1793027261.git.d@ilvokhin.com> <f0d7b2f0dce916f4cde3dd466a5b51a4b88fbdd8.1793027261.git.d@ilvokhin.com>
In-Reply-To: <f0d7b2f0dce916f4cde3dd466a5b51a4b88fbdd8.1793027261.git.d@ilvokhin.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 28 Oct 2026 11:48:16 +0200
X-Gm-Features: AclHuK9bqVSr5ebQZT2ja4gGk1wmv0GUJ0T7y7aJfJNVsg1OI_1bv2lVUKDS3Hk
Message-ID: <CAHp75VfJ-L5ELAttN+Fz_Co2E1KHumwLZAEMXFMhRubzgVLqug@mail.gmail.com>
Subject: Re: [PATCH 02/10] string: Switch to __nonnull_args() macro
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
X-Rspamd-Queue-Id: B506240005
X-Stat-Signature: 3sa9775u18owoow314i1xpt3rjti8n9s
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793180934-178169
X-HE-Meta: U2FsdGVkX199d000vsHTAUjj09zA7H750xToRp+OLGGSGrgsQqA0VDXZwSSr7kFvPofjcEcYr1W+PPyi4Un2PlgRNxKal0Xl93dLSIZRY7TS89A5DiFufJaPSX+pzDUjJnD1+K5xTivHyHt0pCevVtSSnqZ/LrUhRRd5hThlfEYoB8Oolp2Suj9IR++FFu+h9/faf3RsKbJ+OpzoKrtQsdOhhOfdB62CdsxdVGkhAPhhvWc1cLvEKccL/yehw+sM502v+J/jfJq1fC0R4MhbAuf/Mp/WFODHU1ombSgvtHjicaQPVTBy3TGzxdRf62lhwgog53aARSthUgi7+6Yxt5o31cJcV7bVzo9YUmEg/tcgJGjciFYCEvAzCo1KiR1JrwKzWsaS6x8ApBldF1FaTaSNwHqI209YAR9mm4CSgs4WpDGJnVXzusVWI5MkxQZ/A0foFB8BVLc0tIIDoAu+2mx5co6FbtYtD0MYlQ0qmeFoTflItF87Bu4q8uiSt00b4kk8GJuHsl5161XCJ+Na8hQWl6NVp6TcehjgqlrF3O4k8WFUTO2/LLfesQpF8LbMRyYJfuPPJWB3jKWDIzQ4QOOodYPnDls2VukEVVGHLHtcwCs/CwPVeJXfNC3e3hBeuAqMmKV4Q+AJzyIbun2tMOaf8TtCu2nl2xP7EZvf/Poyw5Ll9GTu6S+gqNFYlNvO/E9nWx+GqnTBVib0+uZoTf9GfaDzew/SzJPvELz2AbVRl+5u3HObt8adYWSLnxuuLs+4QR2ypNzvBNT2f8fvBq2j0335kwHn5cKLcTX9AgHrfDd0SMffjdwQ/ruJErFo2NMrPtSHzfPULuj0HbiUjvxYPxZlkplS9hcfr6l/hYb+Ww/oKxd51yNvD7WKZz6vLjiBr+sqgrSdQeUS+ztVDkZBz0+xjw5eQe5Auec0hKm1ezAzxa47o247DqQpWRKvcPu0f+6hxGWdffPO6wE
 MNJtDHko
 qRdi9MEH2noP2II4kvUgphzxRT1k1Nz1R9BPDcTbEzd5tmdZiJ3Diws8khHCl2WCNU8zZArzo0K/tb/NqZ4O+VHcOAjL8Wo/0F7FRN7HhBVOrAOfLlCP+HLCP/7ZKmesJvHV2W1C99FQWwMqrDnZtOUzhI0NOX+qM3NghYbg0QJ+xqexzAIQcMri0NSFZLsZ+M9BJP6zWp820PwnK/jf+ORsDiCq7hUTie2GMCyPXAF4vz6ZIbZEYZd6TGIOWvpIo8zz41OtICOt7ExaxZWecdcwy24+1N+1XaL3lsuxHVtQCUQmUmh6ZWBqlfCrSmyMQoP7VXyQwEV/KrzNz97HzK5B6VatgEF9STS5OPwhWldcOBihXuLgGjwK11eAUhE49LGr9C5XcHEg2NOcibLcK5hpmze1wlbzlZoCN11zplJCli3dI6bBRY2m+rXl8VuSCfEQ2kNg/Pv54zHLovq1oTvZxEkqZVEFdL/01HYJ2b4+aMkU73HgNLOyCv88h8rWL+2lBLtqdfDbCOkbLNf0kZpg/K+PuJjc9MTIZ+oppvt2Hsvk15SEVN/Jv2IxhhU9lhhgtqZv/HUL6ICdHb30VesYIFR8ens8aqOl3
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

Reviewed-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko

