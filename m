Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC346CCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A1F6B00D7; Sun, 18 Oct 2026 21:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC496B00D8; Sun, 18 Oct 2026 21:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCC06B00D9; Sun, 18 Oct 2026 21:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2156D6B00D7
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:47:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6FF1405C0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:47:31 +0000 (UTC)
X-FDA: 85337688702.25.F47E2C9
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id EF9A080009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:47:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YL8ZJQgl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792374449;
	b=DJTAqf5XN3T5+OnV1h07CYKXb+3lyzE1ZdBxu6/mGgk9hLZ1Dlli86lKIYWTuu+VdwJJjs
	TBQILBKSw7WmMkuVWZnjOwfIM2eJhGcMolLdw3+FXalkccHxvtEk6ehnp/BCU63QNPfipe
	ocT9wsmqm6kkOosjKzduG1YMYejFQTk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YL8ZJQgl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792374449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2U3A+oKRxg8msKayVA1cpT2G7nqJxD+NG7rSiparHoY=;
	b=lBCaXb2hLv8V5YIsRuMrFl7pjoW7+eRJVoW/+xXXWXtrI2xf/0YfChUPjymidzi0wLRyGq
	mGaT/11Tx6VO0rofpGMcHovbWjLh8hw6uQACAc9UCdRm6hWNUIrYk/f+1FxwMiHpA2J2VI
	vb2C+EDFDWJVslWybKHvd5f1k7/FhNY=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5ba36cc21cdso1433765e87.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792374448; cv=none;
        d=google.com; s=arc-20260327;
        b=ARw9U4VuUsszaKVBXN13IfZz3iNZWLgmJhtNO/1saTlZ1SR7uARGd26xjCU373sZ87
         3HOLX0acE3QgxQKPIzo+uwSM8wEkE3JP6xpEv8DYO0GTXAl1Xb8OL0oKft3kLDRBcJ96
         /n/4tlTDLuXLowUN0qin5HvxSU9lMphqIbQ7C83mUPcy//BTmR9JYilaFj9s6a+4btDT
         SZTWup/iIub4xM/sz423nqePWps/2pdPC5z1M7ztjZDZNxneQquHQTtXElVtCapwqe6W
         2DmcEw5OigtnZWGHg8rKY2673acxGHkX8b/oMi6hPeA478AbZ92qdVkScaPqK1PNfj/s
         1D+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2U3A+oKRxg8msKayVA1cpT2G7nqJxD+NG7rSiparHoY=;
        fh=GiKMXP6xeP0LL8v2kdNySaE+VMTN4hP22Fya2KqtUxo=;
        b=PcwN6D1rAedKz1ZwegWvX6XSFNGl5DUndIxiDPKm7REKT7ZkDWqhKxCwPOzlH44OOX
         dT+4E/F8hrEO88cOeQ4rh3X7RpjpOwt4DkMWlxZMVdRTVL5+RrpF0BUT1uHkTG/4jvH2
         L690Eh41aR74suuYYrjPZOxsuxC9fHr+IC/1N5bDB6O3cch8IPaCbDxe4khMmRQGhydO
         ajm9VcQu1+8mTJFL951Xd89USwK6cVoy20Wt3QruPQWRhryxr823oYDb5Dh8/y3bLjJr
         A478OF2xts+twIaKEZyTPsv7kpXaG/ZJTaKgFeccy4zoM3qSYpfIZCw5WgP9ys6IigrW
         WU0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792374448; x=1792979248; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2U3A+oKRxg8msKayVA1cpT2G7nqJxD+NG7rSiparHoY=;
        b=YL8ZJQgloo9jfzDEcJQCfMi8ueOWI0NwCD6ITqJ0XtyWDfo5O1/9kd1aEJ4DtCFoZS
         9avBmMNroxLN8IPDvMc48bJSXBhbAmjKe4FpR9Y/uCtZX5u6jE87M2ew8RBsRrQ4l1hA
         6fT9I3aTlML15M1wGlWmrYv4n+NbdTACb0XTo8ApIFfoyCAa09GwYAHxvSkhsbHc90M7
         zNI96dVOjzK/J+kiUuAWRw/Me9NpzgCFIcBQXKHumDS3Vc6+C4yLkqQqZ85kA0IF6x8u
         NQP1h0kmsKCH7AwCehxYm+DdZpsvNm4eltvDKe6lE7Gj+Aw+KEJ6hndJBsA/bipQtnu9
         VYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792374448; x=1792979248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2U3A+oKRxg8msKayVA1cpT2G7nqJxD+NG7rSiparHoY=;
        b=piPwcTBHtyNHiVresSTuYBlb2xhQSl0k4EqFCLix3KBTEKVxHu4s0/hJLAUufM2Q0I
         ZRGKGDNvQEwcFuGDxZG5BbsyKCc/xd59xXiCmnJRnSYyoKnQ5T10NVRUpKzbbzoGLNFT
         LZs6klnf57qNp7Z5gt0zWDJ+b6eoFiUOpK9oH815Au/TYj8qANwZlR0syL1Ga0IBI+09
         lJtoDzyfbUU+JSStTUoerRYV16nya7OTXPt4HBuKqMw+r5SEW1S40m8MJxuvHO+RmgWD
         DAM83L5TvwDyJ+kKQDTdr7JA/g6/GihydwzlsozE3ywMoaaJQlJ3YUOOUXQebvyQgxMV
         C6bA==
X-Forwarded-Encrypted: i=1; AKwUvBxk3B9bj8l5+z78kVzKxlBLLR6fKUVlVBXH5wctAcIhlWbLqSS7Jan0tQlJgLVpsyYc4tdEPubLDQ==@kvack.org
X-Gm-Message-State: AFq9FYKXq4JdhdoNWQxiev/JvBgyx+SQwFW5MWfAUyxTTGML50h59XbM
	F1KXuNlssvJoNESQCLKXL+4Ejk6rnBYLjGpbCrVG898F4wDbZM0jxxnMs2fJ6iq1nW0OEn/17WL
	Om/lgXOPQegEQ5mhSx86Me2OmPSVDc9o=
X-Gm-Gg: AYBFou2GdA96VnK9Qed94wwY3ftqmRTMdb4xport970/NnYGeAPecCklGg1uGhLKtQK
	qCGSZHMEuhN9im7Aa8Q0ZB0bmcaSzVW7yN+dwT2GQOHKHiLg2bZOUHC3ySpRTkysydDoYlxL2Qs
	dRDgnJ6A8fAimEteoCfPYyRfztQOLj/RRtJIbwX0pCstReK9RvzpLcZzKZMjw+1shxu+59y9oFW
	PHaTVtLXzp59LeKo8J3hS1215SKfIiO6ahdKiidZROScFjvUnzRh9dEVP/0dqLPAe+xQ0VNkYfA
	M7YWgj/pXZ9YHVkx9HU7gjSFiNHbqeURmy9IhJTRMLCuqy1HJqBE6Lw=
X-Received: by 2002:a05:6512:2248:b0:5b7:f75a:ea68 with SMTP id
 2adb3069b0e04-5be50a4c8cdmr2008174e87.35.1792374448102; Sun, 18 Oct 2026
 18:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au> <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au> <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
 <atV0l54Q43b1KSHF@gondor.apana.org.au>
In-Reply-To: <atV0l54Q43b1KSHF@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sun, 18 Oct 2026 18:47:14 -0700
X-Gm-Features: AclHuK9zofrLvrOfaweJmPnIqy3kdR5flhLh-TJweVyGHE59eBCRksy4vGcxn2c
Message-ID: <CACpmpoemfbQHjXJ5DeP44WESSJA_A6mQYUEtZMNAHW4qtiT0vg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: EF9A080009
X-Stat-Signature: 7oziw4afzpj4h1yrxwgactsaykfpck7c
X-HE-Tag: 1792374449-352498
X-HE-Meta: U2FsdGVkX1+X5LJlJN2GwpqWZBy0Ua8w8CF45tOmyaz2xMUsXVlHxYuGiL+T8fZLV+KomcLZI8us65A0aXYaXXHIvmEzeJU1r8trTW8L5ugwjryjWPifYmNhEYptYooGS1iN8z2AjmvNi5DKAXG9bJ+VmL7FNEHa/EUx8Y9RsiPFonUO1kFjhqzZeksVkO+UKLazry+ZW2lLWGKReb+R5Bm58xipEVaaamQCensHt4KkxH7oNND7RoZ/4DpscsycLM46j5jRVU2WoVqgZvNDWE0HQGQPZxgvIecEfinBFSHPgbQ8+eRpOERaCnqgdormb/SavqIcgns1TQz02iwtsAnygxeDYYBeRSjncGWKbBasvdxUb1qp9yLrK/+CAnlmzlfBRvqMBk1A/ne74JqniGLWmiz3ozQsXorpRpUVhlRZP2bRoG6RfwWr6TMBRdtVv16SUQH/LsmM967WZNn2qu7OIihr8irFutzsD2QoLSA0Pf3ft2pQL19n700NWwoAckoAbkEU2wHEvfXKBxqMRry6Ma65wKiJsjGM5AQVleTi8EeWU2Vdg0fLAHd9ACquR4kXFlH3qDEEU7rpzgIhOzEUalYAiCuKZV9vF3tXKzMv3ghDWmm7dVZCO+Wh8qF8HVcTFuixemSMOm+C+zj8HVGEnX9oznkRekIgriq5uTJhVkggOEPU9nmTkgsV1VemFjpfXBM0a05WuHv40+cyBgdHhiunDROmCt4ep/VJSpVDnqixCQX0qvsrsmxElk9Si8lL+ZG31DibaZhNRT8IqNwrO+tsmHl03G+qRWXvC8nAabMdasua69GGTk9D7MHqgGDRQ7JAASw73wuct0909nAx8xnFgiHifL1apQaYMjdH8cZ/mEB2e6C5WRn0bLQH7J+5SCSqcm7px5U5AtvF0RlUckQ8ernveXjir2KO+5TLilH3plb0BlLPQVl0psg4D/5btdsDn8u2D/TZ29k
 pZhE+0Ok
 kINUtybOgSaD10IH6nA3Z/rtDbJc+FVWnYK1RGURn28n1DkvmrLTAY8PuYl+S4MoR/xpSH1GnEbGoac8wHnNBxLDnGtcOUdDhI/yurhtaFYLu+DTb+EAMM9+ezyZUR2PlaCAOoYDZ/sVb24apAYA/uGunelweJkLGcZyfHYnZVpHQn77RC+ZMHXSXu1YqzcWWnaJcNxboV1ETq6SyhrUYvXO0smnnnASfrmR84gZP0I2w1i/E9TAYcpdpso845oYNlAfKu9UWn+tADSp3CDEqczYACQuwr62YtL/V3G2lPmrIa+kU9VGFZKdA3bMz/fKdiynP5QZ767a95/hBCA6bErL+MRBsZPMyGlEF9jqwnjmhnQKCoHjIKjLElEe1xtZeM64eRz1pfsZnSQpvWpRa4FpDjWWEwK6O3wwbNxP/Ak6MmjWtckI7M2aqUYDEbfEOZsbNUTqRJ1SVXV6UP2qVbQCSlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 18, 2026 at 6:39=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Sun, Oct 18, 2026 at 06:35:01PM -0700, Kanchana P. Sridhar wrote:
> >
> > Please let me know if [2] looks good and I can include this in v2, than=
ks!
> >
> > [2]:
> >
> > int crypto_acomp_compress(struct acomp_req *req)
> > {
> > struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> >
> > if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
> > return -EAGAIN;
> >
> > if (likely(req->unit_size && acomp_request_issg(req))) {
> > if (likely(!crypto_acomp_req_seg(tfm))) {
> > if (likely(req->unit_size =3D=3D req->slen)) {
> > int err =3D tfm->compress(req);
> >
> > req->dst->length =3D unlikely(err) ? err : req->dlen;
> > return err;
> > } else {
> > return acomp_do_req_chain(req, true);
> > }
> > }
> >
> > return tfm->compress(req);
> > }
> >
> > if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> > return tfm->compress(req);
> >
> > return acomp_do_req_chain(req, true);
> > }
>
> This looks good to me.
>

Amazing! Many thanks, Herbert.

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

