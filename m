Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71734606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hxqMfnBt
Received: by kanga.kvack.org (Postfix)
	id 927AF6B05BA; Wed, 28 Oct 2026 05:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE686B05BB; Wed, 28 Oct 2026 05:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814666B05BC; Wed, 28 Oct 2026 05:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9046B05BA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:50:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6235CA895A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:50:22 +0000 (UTC)
X-FDA: 85371564684.29.D214899
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 808B020002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:50:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hxqMfnBt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OncitmhmKPxQRhu8FlY/GIP5U4Gt08ht3PeyL8T2LDg=;
	b=AMKrEeugahSbLoO23lauUisScj3fUMOS9W2Z+s0T930aDokPAhlmXRk9nnkwvHCeI3UjQa
	kY2v2QXBOB2UyG9s658vUsPo1et+RQYOe7AUnojN5v9Mn0ryRlaBe8cqsOdM7W/diRsEDP
	ghta/RwYnu0t9lO2GJUh3s6G/UYn3RA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hxqMfnBt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793181020;
	b=4l9hrW7TA3tpOj0RzDjRBxgfrAc2YMxgPHwOeQYI7Xlda4xdcsTYAgd67DkhX7HoZFRu5e
	gHZY2EfR2djVjmlAnuCxtLC3g+2ONvkYz44qYTKKZhiIrZeS2mftJ1VZxomZlODBky7QtS
	Gql6g57EAEPcq9HGu1OmH4L3Ng2N1Qw=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b1aa27963eso2865234a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:50:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793181019; cv=none;
        d=google.com; s=arc-20260327;
        b=ey8AcoLDGvJ93JMXd3FP6em/qanhlnNlrNM/FmWKfKapsMh/QBv9RFxkD0Npwan04J
         EFr1EOZFnOcTUHwK/sAQnnbEnBgtvzdqxFooKgCUnmHZxdakUwsAUsZ/CSVz9KpPjHWc
         4JCx8OsFwd7Nmu7s/U7L04DCqNey/5I74G4QC89SQossPZUdqDC8fULfgdlZUFvPCQOi
         WoBlSgYLhrb3i3C24IX8yJ5WdYrLV1ThWMJWl9gsRhn18xiCEmNzm+tj+pxczF8AEuzD
         LC7h/dBSJipsP0Q5zpWZVbuviea1XBhT7uj6R+yEP0+2gTq+IaDiS4qMDNHcVFbLeBh0
         U2+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OncitmhmKPxQRhu8FlY/GIP5U4Gt08ht3PeyL8T2LDg=;
        fh=GCfbPJFdW+DXKoQUP8hgg67a5Sf81iovATjF0Gva+jg=;
        b=aAgWNeNgy7EN+jbPGaEm8cdAU7uzyTnhXARAqi11L98xtORQSnPWsyL6n7Nj0w/OTA
         Xx5M+SbH3EDjj3utJ8Ptk5Y5RSAsNX+hsjgY3n/1oqCt6VUxmFJg5zM6ef5nK93vP819
         3n1hF/a6kTw3P3dC1C1qPtXtv4gIarXsmOdubGSEkYXtjyB4bMhjFvWc2nKz0XUsyB9S
         9Yfs2BHHP8RMJ7N/8rxdmaRaLSfjCSB3+ilePlH6r4o4AnwTL0gThPsI8xg1eUy3IMYG
         Ewt9Hj9SPpV7cXbZKt4itdvPt19/0dbBLSEVS4pOOKe3tdzXzpiNrYsbVbES65zC5yPq
         EnYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793181019; x=1793785819; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OncitmhmKPxQRhu8FlY/GIP5U4Gt08ht3PeyL8T2LDg=;
        b=hxqMfnBtcYacQo7xtLxeeMfsjW3/U7b+dT++WKE8BxRrYCkdXdo3HcOHFuFQxyEbO/
         OTjePJr/qMWjglIE1sWRm7sJ0xQ/FCz3iYOIYQc7WUsBW5oVp3TusOKpc20GhbhDVzQ2
         BTIpIMl8gjV28d+g3Z/8V0aEOTrnq3PE9n+G1RnfmI+Ie3JoJeZib5eGJE1AyZyetZN+
         8GJXDAUc576CfL8p2ES8gkCR3eO1LHnPpaT5kxhbJALH5igSBuswiOESl6ri8VJmN7c1
         zrhwOKNazwJ5nn6Um2/dnE6Rh1YWIxCec+/R62yOuYVbLZpxlUGnR67QLA6uf/oa5hsm
         1fBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793181019; x=1793785819;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OncitmhmKPxQRhu8FlY/GIP5U4Gt08ht3PeyL8T2LDg=;
        b=WX3kuFlaMxLqsrmIBjO+nOLP23dlmUwfAGUTHT0H99GN8Jug7RGdKjRPAT1hanKgH5
         XVsH5MeDNOSlu/x933W1NQtUkYuM8Q24BQbZPll1gV0MinVqvAwQ6BhqXGT7KpnNEBOw
         CQ4xRPROU4DNyb7shX/S1acEg+zDbhTAXTDM803uElGC5CnhVFM7D1n4E12xmR+Wecrq
         q6kYWH4Ix8sOzCDsbJxHM6ZaVmtHU4fPVjTCa+hseladIP0VvwKE6ev9xEFuAGncTLiN
         kZfnEY/bWm4IenXiweuL0YvJoXsSHchQJNKzCBFWh9qlDBuPUPAsOCxVd1CKXf1es9ne
         l6zw==
X-Forwarded-Encrypted: i=1; AKwUvBz83FWm7AOzNlCMVsmlrgOEAylpIH3xzTBV0MZTkHA6kqNfYfckMm5XkYZoZW4tKCsPFz650gOYwQ==@kvack.org
X-Gm-Message-State: AFq9FYI85P7nwdKxfgXaRKmmFI4OtqnxSf5GshIcGoKqLNUATx/q7feD
	kb855pyJwWvVujNGFyNXDjFjOiKhVwO4kruhksSjsQos6UHZlygNm3qj4SkePxG8U2HUG37lAav
	yOjBISoDurNW0mdUtEUpqt1uMZebB7k0=
X-Gm-Gg: AYBFou2lFFLyl8oay4NvTXA4RLeCIXNVsWpkLq/yyMaT7R7DRhry/koq+PQfn18xFef
	wSVUsM1uiz/ry0DNdjnz3H8mmeP2+t5uvWfetEiBHXsztm74YYhUtsu9JqbbiLFAOhKqeoPoa/p
	OptuH93nd/ewn6DwxC4je61sh1r/1rAk5bxVaNuYd23vF23KsRe5qRsoQWaQdODze/4WgKXTmBW
	VldpW1xdq/me+UDOgNhhdI876A40nYL+AEzmpEeCwBb4pTxH+KnIgUn2K8OH7XPD/r998fENVXT
	SADQcnCugYQphvLziuOgWz3c8lJqpBXl7apVYFob+mbwWJJKiCgknzR7aDCcfl/7R0bKmAsmtRB
	jVpmjzR49a5qKM8YyIWo8YwP+WQIgAmhJziKvoKVTEtuNYtmfNTWRtjVAIFZ8nCSX6iXDC8T+PE
	MRDhc9146vB9vVU7gI3kTdkdl+j21kssZ16aKd+BCXdq3R6S0WcbEq2olc0KQX58Ir0kiNOjKBq
	BRe0oM3oNl5irA8VrrC+mde1m/AN027mEQId2kdVb+1JaI=
X-Received: by 2002:a17:907:86a9:b0:c48:a838:c17e with SMTP id
 a640c23a62f3a-c49a739f8dfmr484567766b.14.1793181019107; Wed, 28 Oct 2026
 02:50:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1793027261.git.d@ilvokhin.com> <33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com>
In-Reply-To: <33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 28 Oct 2026 11:49:43 +0200
X-Gm-Features: AclHuK92we6zl1A1tCfKfYVeuXltUG4Bsfa-fRzr4orRkDVhJuYkTUAxt0MOtcM
Message-ID: <CAHp75VfR2i_PPZwSG2UPaxShU5L=FsSdEAT+0iUMDKAfugbRsQ@mail.gmail.com>
Subject: Re: [PATCH 05/10] drm/i915: switch to __nonnull_args() macro
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 808B020002
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: npshi49cdjmqixui7n6f4ymgb7deroco
X-HE-Tag: 1793181020-945990
X-HE-Meta: U2FsdGVkX19/4roN9iC5r9ZvQt+ZRS9teNUVS9++2GHAH7C9zxuYKM/maiSSxNu0XJ11h/EV5O8i1ElWVgPF6AKVtKSvrqeOtN1CIvWdehew8zLjPGVGRQVAxYGNPgr+4x9rK6ufFbClz8EzlHnesxzraaPdDox/45mReOYVTGkLZ8MF7/bKnWOTw0jzqZ8eq93+dMhFYavZ84+KBbjh5qiRvFwHIT4uxi17IkE9IYSY4TpN6vKAJDwKfM+w59D6J5BeOpMV2yw63RQcRLN99Q3MWzvmew2QSM1BFFmH7NGP159f8tksQ0rWoc35kV+PtXw0wlMKVPt24i/7h3g0ml3ZusVrEKJJ1R5pXJDSZT1u8S14CH+4V+4boHT5YE/mPoHnAp6g8lUOADWskqnVd9aNvfJ0Ux8Gm6fgawwr3paFfT/1zfwSPizyRJjrQHkqsjdFxbhn7zNPqkYNCiWwRlSoI6UXNA+Hv2N51jPwDApfGT9mjqvTHE7JzpiGe5fInMXzwDZ6m2fQUOn7FnJTwDiiMJ3XSt7xM3rYQPOuHyWmStpgSVHpmnZAL8NJrfKL9v6UlWkRjAG4iqLNEcsF0toLh6e6tnUOzqlwQA5+wh23XnOXwsNX2ptWFUdWioLMLn2XdOEa2HwglFYdYkQxuYGYbwO1ibUXuUS8Q1wv5ZQdvpTZ4zMZrEZ20g2r/1NZBs8evvVRQXsTWcWzYoUay1DifY2r4nrBXeFCYP/09i8KH+ANCbRE73oj9AAgP8gyh/FIvlWpaf/0TfdyvzUzrtbipx5n2DgWQ16schT7nnjzdy/3VGRfiNdrjVrDOnaspPW0rbWhXvlNRM1W0nJ76IaA/CpcarjkgJTtDovpV0TbitN7KCaE7fa/xWnR+GYx/oJgZ+3PWglEgSgTIVbiKox2+cMyHhJE2OKW2ZjB08Qy+JuvMp8eTcZgn0LSfxCdR114Zz+C7CuvogOUmB2
 I6GkSgKa
 UWn6eX2En1q0sdC7tDn1yr0tZ/EMvU55UPaK7xbMlRTD7/lcMV55kcX/jrLT2+3FqcR3xEmHo6lvF+8Urp5Wtlo6lJngdso8clQ/2ejVplxsnoyqxVBdRF02N93uwaqG8h8H0cCfXI6u9vXda2Is88OxWBuOaqTKydCYjk0at/rqXDZzJMmgTxZsmyaWZCO/4CiH1ZdNcesLzuI/98cQIqy2t9hioIURLnuaPZGyzsXGMf0GqIqVxEGPJVlsT+0829wUS8ceYPqjLMaB1ZoQJ0uSjwW1HXXrErJqANHjMz+XG2Ow4NRdQmDsYvAJNcMJz6qnomVnEdxExyq4Yiq/9dP9khwOVqrulPGTaswtVowsIiskE/j1+3+MBD0EsMYgJSmleVosQu6XlgQC5WbiK/YVfnDmjOYfUlPhDB8TZidVyZaHp0leoCH5EDX6DHId9uK1uqc5+FUpR1+UYUfnalY03JjvZVnFcnpxZBz9IZEYFrhGgNpyNHdzqob1dwIO9V17tXOooRmFXjY82X/AwxdXJkzmqePgQ42j0J8CQEs0p2mrT4d7QQx1TALQpmGnw7DYdTIVoqLMfT7s3vq9PDrX61E5HvY0N9Q0k
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
> Replace __attribute__((nonnull)) with __nonnull_args() to standardize
> nonnull attribute usage across the tree and keep the attribute's quirks
> in one place rather than open-coded at every call site.

Reviewed-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko

