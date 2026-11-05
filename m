Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B71606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jYXXVyVG
Received: by kanga.kvack.org (Postfix)
	id 37E8F6B05B0; Wed,  4 Nov 2026 19:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F906B05B1; Wed,  4 Nov 2026 19:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F75D6B05B2; Wed,  4 Nov 2026 19:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9F626B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:56:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 517631C4295
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:56:21 +0000 (UTC)
X-FDA: 85399249362.07.2CE4F6F
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7A0A5C0009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:56:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jYXXVyVG;
	spf=pass (imf28.hostedemail.com: domain of demiobenour@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=demiobenour@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793840179;
	b=X8M+ssMrdXSbmCYXWLNjNzrkNlAfS8inr9fOTeLK73yukl8kGcbiZ7B6PB2ASegThGzLBv
	VM3YnvLs6LFeOuVCwR90ALjKvyeZ01buXSk4GYFftcCEgnyKCBowM2M7RLdi+V1aNmGVRD
	FTnHRhKpbNl/gzFseMtE7C31t4bthVQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jYXXVyVG;
	spf=pass (imf28.hostedemail.com: domain of demiobenour@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=demiobenour@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793840179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6eXXWi7komBSrov9nUxVTW0Dt48eZZgpagX6tasygeE=;
	b=rBCWl6lapce3OVQTxB5ZCm3FpgNwwsmNkYxCVFxqFPjtTe4LMyg439uLTGp4HgN0qaAzMi
	cBV3P/i+024L43mgNyIc/HiXW+o+w4nPfPXHIw3CZfV/tK4eJf8srJTwbe4gWU0EnpN0fP
	Adnv5LLxZlbnIJzE/vt6Eiu8/zbd1ZA=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b3299aed39so2826587b3.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 16:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793840178; x=1794444978; darn=kvack.org;
        h=content-type:cc:autocrypt:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6eXXWi7komBSrov9nUxVTW0Dt48eZZgpagX6tasygeE=;
        b=jYXXVyVGwTpIRsckt+bi/nmXvlahoIg5IvfPpYFtLv5XQ0AsfmLu9HKLLg8MM7dsTf
         K5jnlrOXti2sr6X4OuUoR2oUsw/8Yy191O6UiWgpG+urmMzTlftqBXJb5rwSfe6oKrOg
         csJWUOWBVSs24CcBaEKKxuAm+aYLyYkrZkahPKwDi3f9nMMSDAw1GzWmCad/9/2/h2Er
         PVUGH5twewW8vKdF4B00vKtCkFwgRBN0QqNIGKbnWwXjaltw+E9/7/cMxQGhevLvwiYW
         PN/u56QFJWJvTuO37y4o1x3Gq0NQI6tq5DHmHxQUXxnT/UIyLM6Mze0aJ91SRb9Vb6Cf
         oArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793840178; x=1794444978;
        h=content-type:cc:autocrypt:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6eXXWi7komBSrov9nUxVTW0Dt48eZZgpagX6tasygeE=;
        b=WsfrhN58DmlCt8yww5D0lkUbxnzwNVbjMp+CMppW23R0P4UgwML4RkWKx8wTfbHxaL
         LrB2Xbv6HqlSIW0iNnSsxiAe6lfJygFaM5gjeojQ9x1BTajgd9f7jUCkFG5OShvfK002
         Dm0rBEzQLMit6b+LMAt8Eqe3euwzomnIEJSnJExrfi8HlDqoAhZTsdjSWqkp0FGMYh8x
         XyJpDCAIUEdihGgpZ+/dbJMPHJSuNSLCBj3NM+4lzJsc2tvSLX/3ph1gYoZECwnzz/tH
         hZYYd2CoKk3uafKN8x207IEHsUe3awsYNdVueMaFsh0xIiKJ8nkPAExA3tTZ0h2lMIUR
         ONEg==
X-Forwarded-Encrypted: i=1; AKwUvBweZHSZYxgiq0fMwEjVKV0RJKt8tdolUCiADyqCuXtrhRSSK8BBkZnuSJUqFNU4IndIYGj5C+S/7Q==@kvack.org
X-Gm-Message-State: APuU4Z/MOfL1Y7ew2BOMMn6LV+Bj6ohNGVLwFrxetxlNw0eE6Z5YCBMZ
	7HbVTgTJhRJ+0CF1Eh/B46PudRaPDb7w5VvQZaN4y0Ysj+rwdSMivf7q
X-Gm-Gg: AYBFou18cPfkHR7B8EqE0HnP7RRStX7aGPeRJNlMww10mGIEWfPKld1GIY+aO2qMKFH
	BWn3AGchyRVoTv+obDMnla/e85rycgWmwh/kh0TAuHSIkl+MDwtaUU+woAX3tYllrTpMz/grbYL
	klXASxk+uYRTVjfopuH5LkZCJQ77LCDeve8HPZD9jLbksC5y2smqH/ltpGWNzX/CAzcoCl/PoaR
	jf0n9HXHVXZiASyChgmlSfTVBTTImoQ38Bm/zm2G+Yxdt9+hhdK1VPxGzTQx7BFOjVpWnPij5S0
	1KNOFwwkLajFE6qumWq/o92KqS4C00WVZj0lc/3uBPgwqN+opp1oTRm+yP9n4QO8qCfGB5YBY+4
	LAbuFZ6sa28+xFwEquJBGnTMp5rZraZ7uH9Lx0mP5sNZfBUOziULYSJCcezTwD3MpkRIgcriY+/
	oxcYDR1QDaFoK3aHSz/YyFw1SWMWVBzt6kISwjTSREHlO+m/xFa1svu/weZqQio4DSFoIcOUGvs
	dCdioApVpWu42wWPLZwWBl+c9wwaX3pHBaWMLxrF6d+Qs90qPSRtaG2/j0gQgQ3J+QV5tSLgEdl
	YGtxKbbPXsXimLgU3tEJ+VejqCRiG+f09Q==
X-Received: by 2002:a05:690c:c507:b0:873:5ddf:d872 with SMTP id 00721157ae682-8b2b6749779mr102401947b3.61.1793840178492;
        Wed, 04 Nov 2026 16:56:18 -0800 (PST)
Received: from [10.138.10.6] ([149.102.242.31])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b309932a24sm30029057b3.19.2026.11.04.16.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 16:56:17 -0800 (PST)
Message-ID: <8b45a161-101f-4f28-9b7a-c7c8b8a29f90@gmail.com>
Date: Wed, 4 Nov 2026 19:56:11 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: MAP_FIXED leaving holes on failure is very difficult to recover from
 and can even be a security hole
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49yB+l2nipd
 aq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYfbWpr/si88QKgyGSV
 Z7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/UorR+FaSuVwT7rqzGrTlscnT
 DlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7MMPCJwI8JpPlBedRpe9tfVyfu3euTPLPx
 wcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9Hzx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR
 6h3nBc3eyuZ+q62HS1pJ5EvUT1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl
 5FMWo8TCniHynNXsBtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2
 Bkg1b//r6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
 9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nSm9BBff0N
 m0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQABzTxEZW1pIE1hcmll
 IE9iZW5vdXIgKGxvdmVyIG9mIGNvZGluZykgPGRlbWlvYmVub3VyQGdtYWlsLmNvbT7CwXgE
 EwECACIFAlp+A0oCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJELKItV//nCLBhr8Q
 AK/xrb4wyi71xII2hkFBpT59ObLN+32FQT7R3lbZRjVFjc6yMUjOb1H/hJVxx+yo5gsSj5LS
 9AwggioUSrcUKldfA/PKKai2mzTlUDxTcF3vKx6iMXKA6AqwAw4B57ZEJoMM6egm57TV19kz
 PMc879NV2nc6+elaKl+/kbVeD3qvBuEwsTe2Do3HAAdrfUG/j9erwIk6gha/Hp9yZlCnPTX+
 VK+xifQqt8RtMqS5R/S8z0msJMI/ajNU03kFjOpqrYziv6OZLJ5cuKb3bZU5aoaRQRDzkFIR
 6aqtFLTohTo20QywXwRa39uFaOT/0YMpNyel0kdOszFOykTEGI2u+kja35g9TkH90kkBTG+a
 EWttIht0Hy6YFmwjcAxisSakBuHnHuMSOiyRQLu43ej2+mDWgItLZ48Mu0C3IG1seeQDjEYP
 tqvyZ6bGkf2Vj+L6wLoLLIhRZxQOedqArIk/Sb2SzQYuxN44IDRt+3ZcDqsPppoKcxSyd1Ny
 2tpvjYJXlfKmOYLhTWs8nwlAlSHX/c/jz/ywwf7eSvGknToo1Y0VpRtoxMaKW1nvH0OeCSVJ
 itfRP7YbiRVc2aNqWPCSgtqHAuVraBRbAFLKh9d2rKFB3BmynTUpc1BQLJP8+D5oNyb8Ts4x
 Xd3iV/uD8JLGJfYZIR7oGWFLP4uZ3tkneDfYzsFNBFp+A0oBEAC9ynZI9LU+uJkMeEJeJyQ/
 8VFkCJQPQZEsIGzOTlPnwvVna0AS86n2Z+rK7R/usYs5iJCZ55/JISWd8xD57ue0eB47bcJv
 VqGlObI2DEG8TwaW0O0duRhDgzMEL4t1KdRAepIESBEA/iPpI4gfUbVEIEQuqdqQyO4GAe+M
 kD0Hy5JH/0qgFmbaSegNTdQg5iqYjRZ3ttiswalql1/iSyv1WYeC1OAs+2BLOAT2NEggSiVO
 txEfgewsQtCWi8H1SoirakIfo45Hz0tk/Ad9ZWh2PvOGt97Ka85o4TLJxgJJqGEnqcFUZnJJ
 riwoaRIS8N2C8/nEM53jb1sH0gYddMU3QxY7dYNLIUrRKQeNkF30dK7V6JRH7pleRlf+wQcN
 fRAIUrNlatj9TxwivQrKnC9aIFFHEy/0mAgtrQShcMRmMgVlRoOA5B8RTulRLCmkafvwuhs6
 dCxN0GNAORIVVFxjx9Vn7OqYPgwiofZ6SbEl0hgPyWBQvE85klFLZLoj7p+joDY1XNQztmfA
 rnJ9x+YV4igjWImINAZSlmEcYtd+xy3Li/8oeYDAqrsnrOjb+WvGhCykJk4urBog2LNtcyCj
 kTs7F+WeXGUo0NDhbd3Z6AyFfqeF7uJ3D5hlpX2nI9no/ugPrrTVoVZAgrrnNz0iZG2DVx46
 x913pVKHl5mlYQARAQABwsFfBBgBAgAJBQJafgNKAhsMAAoJELKItV//nCLBwNIP/AiIHE8b
 oIqReFQyaMzxq6lE4YZCZNj65B/nkDOvodSiwfwjjVVE2V3iEzxMHbgyTCGA67+Bo/d5aQGj
 gn0TPtsGzelyQHipaUzEyrsceUGWYoKXYyVWKEfyh0cDfnd9diAm3VeNqchtcMpoehETH8fr
 RHnJdBcjf112PzQSdKC6kqU0Q196c4Vp5HDOQfNiDnTf7gZSj0BraHOByy9LEDCLhQiCmr+2
 E0rW4tBtDAn2HkT9uf32ZGqJCn1O+2uVfFhGu6vPE5qkqrbSE8TG+03H8ecU2q50zgHWPdHM
 OBvy3EhzfAh2VmOSTcRK+tSUe/u3wdLRDPwv/DTzGI36Kgky9MsDC5gpIwNbOJP2G/q1wT1o
 Gkw4IXfWv2ufWiXqJ+k7HEi2N1sree7Dy9KBCqb+ca1vFhYPDJfhP75I/VnzHVssZ/rYZ9+5
 1yDoUABoNdJNSGUYl+Yh9Pw9pE3Kt4EFzUlFZWbE4xKL/NPno+z4J9aWemLLszcYz/u3XnbO
 vUSQHSrmfOzX3cV4yfmjM5lewgSstoxGyTx2M8enslgdXhPthZlDnTnOT+C+OTsh8+m5tos8
 HQjaPM01MKBiAqdPgksm1wu2DrrwUi6ChRVTUBcj6+/9IJ81H2P2gJk3Ls3AVIxIffLoY34E
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
Cc: Bert Karwatzki <spasswolf@web.de>, Jeff Xu <jeffxu@chromium.org>,
 Jiri Olsa <olsajiri@gmail.com>, Kees Cook <kees@kernel.org>,
 Lorenzo Stoakes <lstoakes@gmail.com>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, "Paul E. McKenney"
 <paulmck@kernel.org>, Paul Moore <paul@paul-moore.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------xVK0XLy9X0vduJNb936CFAdr"
X-Stat-Signature: j81e6bqcyq8e1zy9kerro6s9oqchpomh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7A0A5C0009
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793840179-31799
X-HE-Meta: U2FsdGVkX18Q94i0it4g9I6jGbG80jo93O5sFoHyLc0lug+eNLkU1TbktvFhRnADlnzoPgkSZU0Mx7Zd5jHVvTrM6u1nocvfRwOBXjGlOx7WmIgM3Yz8mEVmT+WMKXWPMxDZRQI4JoYDvMM+lgmUQxgtMPXXuz0jrxbZGZ68ze9BWLtnYdXhrBF9w6IA+ks17PeqKm8UchfLxi+OzGiUwY+yLBe/+2xp6PZo/gCV4l2XddL112TXozIpL7pibDK/Vw3MidIEw/uwL5CPXup7WCpmU58xW6bU3DP2HyMoXUpB72Yzo3bQJfJwGkxaS6/+1tFVHwBEbCNTtvjR77DUsXPb/4EA6VRSb5jt/UXhY1KyZBYrFSGcPHjhzO+TLCfQM1zGRnWjKRVa9dPKp8aupHpT5iMad5OZzRDHUyVQxOej+w7uV9vdYJoChpB/D8KooK0ZE8OjFyqLPD4QpU5078u1jd+KFPg6HbYiCJOWhzYXkUloOODH/MiV/9wDcM+Oo3NmiNpJrYmbL7ZwZGWdedUGdpaUNghrU8Oc6WocN0oDd24MRY4SpnWZZtNcFHUtK2eMyxHBKIrUr0tY4kW3vS9VNb3JfIA1Nm58GFY8JJMXNcshf2tVs34yHxaMCAgOgzi4g/2sJ+gQ7/SK0MIZJl0O5gTwh7DYle09eVwFxsVTfHug2U9TFOajy+RhKcq3bCBQZAiUAwdkKa+8tnX14Fxx8c9/20c3uVYFisw7x8Ge8pw/qCd9oF2XVIpMIzxB8T5GEXnxuHX/sDKCRlKeoAGLK7j7PF2FLlZLm9ux5G+Hh13RT8cZ9qHGkM40Tkx0Wnyzyw3Cfd7aw+NSFrID+9wiIiGWkDHit5EOzWhnb2+2eKSxFmjfTefyBmAFP2rmVmVWtbSe+s0DwWb8ONGxpNS7hQPhnpM1HvgX82zltu6VXXYhgH1DXhjomUbmpxY2cGTAW6g6b/RZLSF75ya
 W8T4THSr
 A6IUWz7mkBGYVeDiu0r7+Tj9C5YUjf1SarIWO5fMmCp8EyQL1DK+Yk1M56XEJzA+e/NOghTzd5qAJK75kt4wJBuVHZHGVF28TMvu3NWbA6+YQK6Eyyl/fEw8cjG0EabQ0INPzVgylcAXVetTsaKZ3+lvF95JZOWWg+mt9h5NjtjGjKGlfaCdJYEd/fYqOnbjsnZaaS1tHMzRp/6IsqBJTFmFuV0pCvjvkMfUxu++WfnBVTrjKnS2/vyBh4g+9SWyWXo68z0XUTKZfE+RwI4TMsnmPd4787HR9ZZhvYIh+UgIg2Lzowt+AKfpED2QBM2vT0tmnQQp5q3Y/fGYbbdV7PP7gIbPM3yfri9c7vywMqD3NQ6asblT8a8oGPJDIGEZWFcCVP0m9OqPdnLgtSe7QCJYEE4PIunCKL9IBZs0i4JjtfzACnQZXu0XMT1sPtSD8f/NuUYAcpfHcgl+/Mk2GOsCk5D74WNAsx/Ao2zzh0XUz6PbIEce+azsDL9xye1NzkRptfjem223aY7/fF1J4M6eXB4Lo+DFDR4HlnyRGJsxjZr6KEfUGolyH//bB4GmdVbHRH8ZAbgOXInrjft/jO2wIq80qnWQBFo0jPgml3W5XeDT7E4VAXq8bMwefwlm2S/hxhfIvB7dSRAnI5k+f3/3lkA/K5bTNbOFJ84Zb1fvi6NEhjejdHcSCtef6kk1nfU1Uq1c9vGnlDVoKgJoTN0BQjHOhcevB4CE84tuquu0VGjccgBkwGsifF1M2hVAtSu8mZd2VZ3Ls2W7o3GK0exEGEz0yw5ZfOLcMv/Iv+DGUstHLSSdDhd6KnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------xVK0XLy9X0vduJNb936CFAdr
Content-Type: multipart/mixed; boundary="------------0BQDKKn9cP29OPNRK45Ha9VW";
 protected-headers="v1"; hp="clear"
Message-ID: <8b45a161-101f-4f28-9b7a-c7c8b8a29f90@gmail.com>
Date: Wed, 4 Nov 2026 19:56:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: MAP_FIXED leaving holes on failure is very difficult to recover from
 and can even be a security hole
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
Cc: Bert Karwatzki <spasswolf@web.de>, Jeff Xu <jeffxu@chromium.org>,
 Jiri Olsa <olsajiri@gmail.com>, Kees Cook <kees@kernel.org>,
 Lorenzo Stoakes <lstoakes@gmail.com>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, "Paul E. McKenney"
 <paulmck@kernel.org>, Paul Moore <paul@paul-moore.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>

--------------0BQDKKn9cP29OPNRK45Ha9VW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Right now, a failed MAP_FIXED mmap() can leave a hole in the address
space.  Another mmap() can then enter this hole.  This was fixed in
the past, but the fix was undone in
4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on fa=
ilure").

This is really nasty, and can create serious problems for userspace.
A simple example is MAP_FIXED over a part of a KVM memslot to expose
memory to a guest.  If that leaves a hole, the result is catastrophic:
Subsequent mmap()s (perhaps by malloc()) can get put into that address
range.  KVM will give the guest access to whatever happens to be put
there, and one must assume the guest can turn that into a VM escape.

Other situations don't result in immediate disaster, but are still
really hard to recover from.  One can use MAP_FIXED_NOREPLACE to
refill the hole if nobody else has filled it, but if someone has,
there's no hope of making the original mapping (that the MAP_FIXED had
clobbered) contiguous again.  One must either figure out how to handle
a non-contiguous mapping, rebuild the mapping elsewhere, or crash.

In my case, I can work around the problem by using a single memslot per
file descriptor, but I suspect there are other use-cases that aren't
so lucky.  Yet others may simply not have realized this was possible;
there's even a Stack Overflow answer [1] that claims that the map is
replaced atomically.  I only found out about it from Claude Opus 5.5.
I asked it to write a test suite, and it pointed out that a failed
MAP_FIXED mmap() can leave a hole.  If I hadn't asked, I would have
shipped a security vulnerability.

Should the behavior be changed again, so that mmap() with MAP_FIXED
is atomic?  That would provide a UAPI that actually makes sense and
can be used without horribly ugly workarounds.

[1]: https://stackoverflow.com/a/28576674
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)



--------------0BQDKKn9cP29OPNRK45Ha9VW--

--------------xVK0XLy9X0vduJNb936CFAdr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmrr1CwACgkQszaHOrMp
8lOVcg//SKjfMVWdZ0NQUQB8SGUy1DUvasvgNKbECkMRVXoKID1J91XoXk0hW6a9
U7CFyJjrLcIkxHBXo3i+AHcz/9R7BD3M9XwnQAk3ZcN7XdpgzjGNXDixXftPcay1
lFuZfI3btf9V+AADMiP2EwrwseYFFciXKxaSvFlmV8it5+8xbffiCyyjbZ5RFZ/g
s8x1bJ/XzpZCPv9NZyn4lHWBcbJ2eN1N6bgblOaKHLLN7krBDF2fQWYlFXmOieWT
weTFXZxKnH/NpwVlJfL2jeCkYXUdkdDHOSWJm0taFbfV2Wct1mgXXewrjSrDTgyI
1G9iWh9zr6+Qu8jtz8/XPYltG3/akStk61ncQEo4PUGg7hkEG3haP+T+fOaepot/
mMGFdYID4j6FQHz1q9EiUclgd3B5u4CcWpbpsua/sFwbWlM9LG+vU+NcXnAArHiW
gxR7P+3FeKGua0MD6WMcpzg4NiN0OTCfdEZgzIpyhxpJy8p020Hpwr1GQ4lMHApX
mBmOfMVDq4jVzv539aFl/rxsgAIb99ylyRWHIBP7ARe8MoWq95W+Gh8FmWDPFK47
SRUDXhOU8IpnAUa8YD5r+32q5dXY4M7v3scqSBh4lxni9Em47+goQTcrP5lNXqXl
lBTECCyQP8qfytBERyiDVn+jPTlZQR8gBy8sezeTQ9CFah1jbww=
=n77z
-----END PGP SIGNATURE-----

--------------xVK0XLy9X0vduJNb936CFAdr--

