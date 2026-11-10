Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71B0606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yFWPS09P
Received: by kanga.kvack.org (Postfix)
	id CFD096B05B2; Tue, 10 Nov 2026 12:42:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACF96B05B4; Tue, 10 Nov 2026 12:42:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CF76B05B6; Tue, 10 Nov 2026 12:42:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9386B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:42:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42E8A160A02
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:42:35 +0000 (UTC)
X-FDA: 85419929070.05.9C004A1
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 40507C0008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:42:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yFWPS09P;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794332553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Km/1n1LHhDr02ASZV9qn8VhaPAsioBtH6JYVLmDFnWQ=;
	b=UuqvKqRL+9UjxzFKxq26CSL4tI9Z2SFYB8g2RcywQIO9zCU7bogch9sQnmJmyxBDgMO61H
	3/GpuuFquGu3F93yfqFTe/f6gQt1CjCq1mKPw1xTb9pjCoIN7Soofi2olyfGhmn4GtG09U
	xZ3hQkg0ijlgvGCSV2kvzekgJz9AvE8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794332553;
	b=N4EO4znbLmkSzdVnw1U8yVurGkguX3yA0rANcEWekMwmqGCILOWy5k+YuFBM8RVJ73pUYD
	IEnhV6dibgmMxEWY7DY1gG1MKvx3lL6BhpO3TGWiest+kLrtHRq81MFZgM3MBUPAuhoe7O
	mrGq0qYI53q3+Lwlul7JE/EG0xSfuGI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yFWPS09P;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3ac97e45a79so18518561fa.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:42:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794332551; cv=none;
        d=google.com; s=arc-20260327;
        b=bfRAfC3DYZkftM473tHhk2mQ6qnMhQHYzFLZELnDFiDfdupWzws+qKjQweIPxoySDn
         DaRi9ngCLjc6BP9qEtMGmxKB5wl0Se4LzYId8NxRHSg/DdbdQGOF3a1EDpKsyrjSZPcE
         9Q5hvWVN1Cf1O5or0ssAgWhwayiBH715w3tqqiDu7hgoBZ3gPmWv1q3r/Un4LyOg8a9N
         aynF9jenninLK2nQFkCUW0QZQbH1GO0EJPJONbnEcFofZcMl3mbqWQ3fhEjY0dO2eS18
         +hKNiH5J8QeHBVqzjB1/q8iyL75hVV+cDWs2m8gmJPFQ9TrTrH++fUtdjiSJ6R9UHrdj
         bC5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Km/1n1LHhDr02ASZV9qn8VhaPAsioBtH6JYVLmDFnWQ=;
        fh=KjaCmCTx+BhaXXIIBoyFFQAnGG1s8ENzMXBIuT1qH5A=;
        b=A5mgO5l9hrR87y9/Qp4KFsvZdn6TXB4ed6L00wrJ0zQXsPSgbKO894KVm3x1XHVDdV
         jHkrr7E1Udivc9d+b8HHoy1xMiqeXK7yjzZSi/ri6HTRVavCEUWyHgJeGLL+6ZOCzC7/
         zykALS9zutnzS77hQ6I+DADiW4Ymb3Nkn8HCEhH2wVYUHbxRY8YCCM8HdhKa6SeacdD8
         Sgmu9W4QwCIHNg+HbViTBJ8AWeF+fgjPIK3lFg/cnasV4kYkWFdtpTTgKm44Cf9UGodk
         iGwjWH0dTOty9F1ngqsJy5vKY4MrE8CyYblCE6a+4UnBY32YiSCNIOhyaJcrFUOFQWWX
         Ws7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794332551; x=1794937351; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Km/1n1LHhDr02ASZV9qn8VhaPAsioBtH6JYVLmDFnWQ=;
        b=yFWPS09PC9ARmlJcia0tcmzn6VY0IN7rNqHUKJVR3MmLlj647w6LCwCrGMopo4HmVM
         tFmZi+0Q72PSORugwpQ3fjB+YWqZWauYYJvCBR94LsKLyJZF6nz6XZyyLpnlkfzBDpv+
         9+LjrumDfakbL2rbca0035b3ynt1LN9/+GWg07H1rtlllOMp9HQ7+uNmOmCzq/3Uft4y
         iYFBvuoo6MrAKBn7Cfzfw2ygNcUv81K38TUgFpJNJz6M/k0QY4n86Bx29uZ0OM+PETff
         Yf/qnT3BeN2OeGHxSpaPVWJbXP57j+8L7wjLB+TotAjWHlF0G8WKPRbkLPxUZiinsVjl
         CnXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794332551; x=1794937351;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Km/1n1LHhDr02ASZV9qn8VhaPAsioBtH6JYVLmDFnWQ=;
        b=qj7mI8iyXZ96B/cTEX8AUX+m+TPOCvFhCmnYOWBSOcAyd6Gi1VAzjGGJQuwICvJrcY
         VMxO/UWIJlzDfAPfdi7yEgk2uHz7Ec9nfnTzQIaDIUbY9u1u7bpkWbU1kaT9FjdQr/Yv
         1j4/TqwntfN+ROz/SIRyLDJiuHbK5OysGjVd/MnprOfnVY+X2WA9XbkUVlqk61hfcp/6
         1aA9rubsYVEuh48+g244ejamoxFqkSv6hRuLZiGFoYhAOrhW63mX1r4I8jQr4vrdJiOG
         pdrEq4cENmyuwCPBYFXgcSzxMFEHINwgx4C4swpZSXLQvobFl4TADNvUtpMsCzLOuNTs
         yfwA==
X-Forwarded-Encrypted: i=1; AL+hErEh1P4nRBzhYsBMaJLUV3fxZSQtkgEPzaiNv76hWgg+uwHupU3z0cVqpMo09nP2J0gF2/m2UTaYJQ==@kvack.org
X-Gm-Message-State: APuU4Z/V8mZKMZoP6IP/7MQF8l6HNNAmO2k5XG5tlFABaXPZNXcUEDwb
	7af2BP7E4KBX6cUZRfieyUhnC5pjm4/XdqLfuGFSEkwF0D25a+jRtGGOgxEqUtYgYeQDTpUz5cI
	74yfG6h0moziSFQObCipY7QdxJ/YE2PQ=
X-Gm-Gg: AYBFou2+0g3nEMNi+3s2OBxyvi0OZYNF646zxxjqCX83vu8ujQWO5hWyTJtdUboDSGf
	7WZg9gg8L9zAsZdIB0Jr76oo+bmbKl/MasXBxQ0fMuiCh+ohAJg2MR6tRe5xRe8bYj4oG75sg87
	x2JQY8yJlX/d0ZkrIn4t3YbUAGXeiY5809Ct/49w9N4sAHHGzewhvXNw8s45NDgT2L5XrcaebIo
	QayvqhQhWdytC2qfFD9fSKPj8sE+h5oPdjJrQ0B+awcKzBwE75ymZRy87NiWPJRVyBbkqEciGUT
	bIhtLS6C+OBIGIZsu0dFsRuVF1+uQRagTHqkQRZeD1DXF2bcWL0qpz05A5FfW7BT1QMmelDjCr2
	h7Uloc70CL5S2Mj/iWv0ihmYTiZZMR+A+diBg96Y1prBcXV6MNui9IROa+YV5DdaO140FvuKA07
	wFADyIijbhNB9ZVxyy7AR6i0nqpPt6KxENG5dqlNmYhzYrZ4mce3+h
X-Received: by 2002:a2e:a5c8:0:b0:3ac:e4b6:b93d with SMTP id
 38308e7fff4ca-3ae0960e26amr7913321fa.8.1794332551177; Tue, 10 Nov 2026
 09:42:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110054836.1515030-1-senozhatsky@chromium.org> <20261110054836.1515030-8-senozhatsky@chromium.org>
In-Reply-To: <20261110054836.1515030-8-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 10:42:18 -0700
X-Gm-Features: AclHuK_zSUkyB2sjWErWCiaaONj2fSjizGjk85ueR6Sb_actx7ETkPPr0xK7p08
Message-ID: <CAKEwX=OtCcMak2gshXXDpiXiVK7v0H+gXQpQ-4D4BNvWSbvWHQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] zswap: do not free the entry if its pool is NULL
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rhjayjy1iyxn64f45pd13hm9mnwgat3q
X-Rspam-User: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 40507C0008
X-HE-Tag: 1794332553-973518
X-HE-Meta: U2FsdGVkX18jl96OOKHYBLQUlAYcTnFDkmMT7YEn040tFVnNqjaA92IchPp6byvjVMcsSMPH656f8TPk4tGYR93p2T5YxknV09wRAo1bzPkuSE20AdfYgM4Ld8U/ll0REH3blcIs08U0PFIqCe3wrZqHrY50AgtxT6AhLnJbS/Hy/WiLh1+r1xtwwOSpbFkYrBSYR1XHeZrbxZ0+GFvKXIz4fgX+K/U35UlLdhExFizOGTlbO+XwvpuMXhw33cgHLXGxm3hhBKYxu2HvBn/sCBMpa8fxyoojny8lLCKfw/H7bF1f01bV7zczcV83WhJrx8ZXQ3wsMOQa5uzKEb+YZaZA/bTCb+zyi44Nrwp+i16b8jYeQWF0hqxBv9e8R5KnzdVUZ34qd+P8uo5h4qvXJ69NXiYSPpGEVvMbGU5Gl4q1Ucd4OW2i2CgUb7wcv0XtFOpzh4k6Xfz1HUtAZ/PLKSTdwtspCeXL2WFJ6EHpqVSAUsBXcixuopSPEkLfDDWn/1iDwRsx0oWjrZY7EuxeTvAXoSrf7KV4mCpALweyCVt/LeXMGKFr8QDMC9JkaTMMJwE0CEHy+Sh7z5KCGdHuCGScVFuAYWnzwWQ5CUvlsimT7+zT6BBHGTh8veR+KmS7RWHI0izriOooXFIIblx2f/lMSLGsMiNkLcH+PcLcAohlDgCPrijfcURKU5cVVwWrISjGpSvYSFUrGdqMcrk0EOcwQcpIaewazxTryl/xloagin+OARu8Wsu2r6AYonKoawXYaufZ5X+3y0Si2QGdUnKrpp3TLMdjXYFJOPnhX90mDsgJKcxxwx8uSLmOCK+Fil6/JJ0n48wiMsp/Jm30GAYvyYlYkyKXSxOsjaaDKpz7+EaOSI0nvniLo77GDp0w/0PiO4xI9M+HDq5U4CRZR2Iq1Lf6MCZ2qeFniRjjP1m9ztQWNzVCtDVFqWJG8VZCBgxPIrlcXdp4RQCIfOH
 BpfnTjUb
 ZreMgcbGBoVXrG5kjQlJWmNCCUwmXI3KlEtCdPOCydTO1VNJO8ksSf5VA887pDSzsgfBGyjrvW4VFD3qpTWrXxQMNSCI6Ht033UPXLiOpB6sD7G5aDdWYxoqVIiytmya/VXf2ixaW6ZJubYphLZQx9jthQ4N7hHLlhUKR+OIXKpaNPvQYCpjCNGwS7Y7ZVXinvNeeFiwmYo2ebZrSppxI9Mvy4gm+ob4DlffzHR3TmqoXQh0DV5C87VOLZravttEmsrqQZ5sjAa0/pRIx4g9p21kJuimznZ+/tdKoWoXMNKNYc7fSaEAi1OdbO5MBJIktyc80bzgC6PE3Do9Hcn/lFcfhH42Hj2TQj8tybY7VeNA9Mlt3STtT9j9uhGDYhBS3jvXOG1b3K3eNevFwjr86NCHPn9ZsrYYrltZ3UsytOIKza/nmX/OCkfBLU5SJz963XKFbBpGKVz4jKe8ECneawQLyEXpxu0R0RtcSVLIKa6Ce7Nr0AJ2Qav9kVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 10:49=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> zswap_entry_free() warns if the entry has no pool (which should never
> happen), skips zs_free() and then frees the entry.  A subsequent patch
> embeds zsmalloc handle into zswap_entry, so zsmalloc object will point
> to the entry, and we cannot free the entry while the object is still
> there.
>
> Bail out early and leak the entry, its cgroup charge and stats instead.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

