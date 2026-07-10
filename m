Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BA7C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026B96B0005; Fri, 10 Jul 2026 13:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1D56B0088; Fri, 10 Jul 2026 13:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9E16B008A; Fri, 10 Jul 2026 13:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B39F56B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:57:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 211A98F487
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:57:40 +0000 (UTC)
X-FDA: 84973624680.29.38E76F6
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3B30240005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:57:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H+ojKMou;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783706258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpNLQD9QPh1uuq2xE+qyI1tgyksp9nah9b0qPp0hKqI=;
	b=iznoETl7B1acwte0tSGXFpc33gw6ZiJXFf/yy/k97Ykk+K1a3xaI8j5gbBeFPNv4s1Iuqy
	Z4iVlcqF/XBw162CSdDMeuQjgn6cFF5xWiCQJdTiVmSd8BjfVAgrCXK8qnmbNE6pakVejn
	qxI8P7HxmRgbZHAASmFrTRJprRM9jnI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H+ojKMou;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783706258;
	b=NK7ryDAj1hIvMfclghFdKPAivCjLhsNpx26r9pxUxS4RTBbHrum7vDccy3/1WdZ4t3DqLT
	fkytEB8GmnRQVCG2stPKVPdfCv6fW1X5kQRR+h5HGQupioNGoheb2wKbRRAYRiCdqaisyj
	rxOGDIHsFmQ7mS8Wy+sUORK8As6oBCY=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47d70879764so810986f8f.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:57:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783706257; cv=none;
        d=google.com; s=arc-20260327;
        b=hKcfpbEf93RB+26wXHDGgws72AQn7KNxOd173by5/qmDzx3HhjSjqNrPxrhVqZX0Bf
         6d60WfbXxgTTCKGAUHuBRA3efhtFPV4Xtg5yvZ+T34NcioHcKijvhaqO390CbUzVxKHA
         +K1Mokx1xkyBZ/uTmRJkRp2igub9+H+3CYUvAyPxVfiHiiAkZbi1z943cf2VI3ZV+NHI
         ktfPBI6WN9I8P1dV9r8RHpowWLadsKxb5O98aBKdvuFF3ykHI+6v+DK4itDVdIBsMZG5
         ne2maSAre31XhEt5TgSmWwMTtIWVAKLLsPfHFjrqtv19NrAHFmwA1BaHBAN3D910Pdc0
         Xqiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xpNLQD9QPh1uuq2xE+qyI1tgyksp9nah9b0qPp0hKqI=;
        fh=RhhQdU7R1mITvCcgfKaa40DbztGNdJe6nsbK94GjCd8=;
        b=nL5imZK5ltnEtwSKNwLqXI2xN81c5R25CgQgxkhJGQ7Aity9XftwEdcQI6jhnMT9pc
         o7mQQnq7LyOk2XJcLrOn5d/stz28VpqL+85U+8VYZGXxazCCrCZS9M3qSRMkl+w79860
         pijbyYVQUSICIsbjHCwXd8giGrwIOWknGzJ96fR/OW6XvmHKFRt5Wb+8N8eyqIbiUdzR
         Nm9owdjUJCD0osTh8onCMBf32br6c6se7ht9NuNzCVKA5FCwv6e4js4A7kXuB0bNIt/K
         j6D/c4icMkXMw/lKgjbFnbr1843ad+j8KrOIYvuhxENmiG5eovzwgIuhaAaZwaJL5zpA
         uHdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783706257; x=1784311057; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xpNLQD9QPh1uuq2xE+qyI1tgyksp9nah9b0qPp0hKqI=;
        b=H+ojKMouG0ssFOmoYJk1fY15Bn1PthFNR1ayt7YcZOjZbuaHSHyeOmCnyTQnjEte24
         zIZVM9Oi+YYF+7u2uh2XSE5LhjoD5vviP4o/eIaFgtQUC29zI8ozADBZAYtLYYT6lbfs
         S5jc0n6sl+gjR+UZkdTApIBQEuBTrHLOuyCR3jQMHHKaiT/oLe/wtWDee+2LMcWs5QoS
         1GU2q5zWf70D/slXfMEYJRwUQyjsRydkr9pTAwTBxZqWqd54TvSyB6g3SnlkbKDB4Dnk
         hTAX2uRInKPlKyDchJNIcv1pr6wywbWlWNPm05I6qo/bEHJN7KPXcTKiQoCHGn9ra+iH
         ldMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783706257; x=1784311057;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xpNLQD9QPh1uuq2xE+qyI1tgyksp9nah9b0qPp0hKqI=;
        b=I45KndyHyTUonzHKzHQRgbZaQfn3XAK8X29KIcZNF1ahoWB9iwkTtgAnJL5MvpJefk
         wk5L9lf9D71iLT0aJk/8MYFRb96w64jabpA9+Q3tOOOmD/DHSVdoOBrSc21325WOf9Bg
         h4DbBi3xw03lmRMGTYhsfZcEVH+VNDZ1OgHAXwJ5v+9SQXohK1lfYqQVeqU18pGSJQnw
         zilob7CZatC6qIC14OJx5wmIK1wY7cH8WjKO+gsyEsi9O4jN/U1aVZjusSZNW3rr+zkO
         MM4Bg/PfPW66sJQMppH1d3UdbrCkJjG3vH4ZBvCxMKrE3zKq8qUpCZQ/FcXVXoXph5hz
         VP5w==
X-Gm-Message-State: AOJu0YzXpT1SC1xb/xHM6oV7KiqvBfuK8p5K5lCBY4+Vczs+AxxT76OF
	U7rb4LuGWvL5iWUAn8rbpIC2Pvj63gesmmQCZq7Z5RKs2/V5b4gJNVLXLIHClXahSnyzeirKJUg
	gODwFtShhTHSvytvUoDc4s5dxoDVixwIjNIodmpzbJQ==
X-Gm-Gg: AfdE7cmHWQkqtOtc6JW5wEu4+J+IZA9jKLsOu8KJF6EAwoyWCgbV4qXsXcOZtfun+9X
	5Di4GdPPPapJYaRpE0S2l8BMFmZ+3uamwGyHE1FDaC3JC2kCkpjYS4zy4CizQTxupomd2fAwlG5
	VlQnobnnP2L/MkzGSwN9Ato7N9JZT5mVmkOQxn6/wDITZcpdlOOCNwYYLynes8C2WuZEXaMTSPW
	c7slhNf1ZaYyEIw+f9eN/izpAP8awREKO42B7O6wXO43zSDq1GT8E3XscTrX7AooNZMjY5xv+Je
	vGzCoOv+Sq415bg7pln1ZQe23Gi7
X-Received: by 2002:a05:6000:4916:b0:47f:2bc3:8cf7 with SMTP id
 ffacd0b85a97d-47f2bc3915emr1648990f8f.19.1783706256694; Fri, 10 Jul 2026
 10:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260710082822.583930-1-husong@kylinos.cn>
In-Reply-To: <20260710082822.583930-1-husong@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 10 Jul 2026 10:57:25 -0700
X-Gm-Features: AUfX_myPK7mrX_f9oTrhWbvuzJ2KO3aGGJsy_IFRZcwS55D8grNT6u5BcEimEPo
Message-ID: <CAKEwX=MPc_uozBea2uHyp2WabJB91o3-Jp85M_3Bv55TimY8bw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: flush dcache in the compressed decompression path
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, ljs@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B30240005
X-Stat-Signature: qka7e3mqepaddak117ob3gdz1mambbxy
X-Rspam-User: 
X-HE-Tag: 1783706258-637568
X-HE-Meta: U2FsdGVkX19UJE6Kn1CJwuYndhsqw9JgFNtT/tE0/qhpI4xNYIpXF8kvJ+DVk7IAQi6HajGnnQ/fxeOGh4ieW0AalAPQatZ82ktn/J9lT3mp2FJcLZCsyK9ACYA1dQcsnlfWYUwnA6Dgj7GxwRftD3nQJ51TwWncEY924f23gOwtTvWL5Gwh9ZtYInMR6b7UQIUEcPwgPkmBDGd2YJ2Huv6+n4g4mXdx+i+iDr7s9TX/XGFYELTo9egRaFBoN/dsVyI8PlKpS6HUZSSrx7ohSi7fZzRaUBnk2ywj54RHFbGkNlIQSHM1SPl93gSiPSCfBQYpb1ZIIUrvB1H474bu4y72x03HzbaSG8JplNp8LbBr3uK8EOJbPE4/4Pn3xAUUN7NKOoRxq1XbXheQKcrL78egNEtJ3MfuuBIpfTCK2wekYpns05Z8JrAcBtpNXFu/iOBfbrh7GjIPjjk3gF3Rrs9uRW0UX2vGj+wmdnWmZ9BwYJFtmZeZkeD3b6XGcr+0mT8/FGNjybxsrfhUekF5KMq6UECc9hJg/LA2ap6MOBy02ASXIKxTNoepuVXF1COMt/akTI9wz5w0BOAzurr84b3/ZtfHnD/h8/OESRcmNhU8Mld/YS5BckmcTUBs+1ukWOYS/Gg4CzynJCn8JyAZA9IaDu4JN/St8GuVGh6GmFbtTe2aX5vFmDqcvv7S6cHXyYjh2cOuzWha36qR3sH3sYGjFdwEtePlHkkhDypiqnEtLeWh1v22dvQvp0YilfH1ycueY0NBQE8meTh6Es2Dc/ZsSh8QLUZGP8S4bckdw0WYEYs/a7YkakYnyTJUWozpIbIYwqE+wNuIz/lEp5yk4M54vU1fdikmYZJlgA2VERfZzWViBLskxnrBti+etxXqGSCg6NDBZdPOb472cX5cWB1I5ag3WOgVZJPvp32k7DwORoBa0z+anQ1/tEeqtyhlcWaPJC9zFXawVnI3uvF
 Wt1oHIYo
 uxmKhzdncPvE8zgJr5ukBwgusi/8nqOlUIDekcN14ieenE2zrzyaUGMoCvfwzYYoWRvHZmF7fj4q71ibDx5cdeTeI4Fp+cVl7qCdhL676gQqa+Hz4rrjUkRXDnquMsVgUOwcUQxa7O18vzDSmSM+/p5KQn8WsPaSE3o0fcRGnnHVIF0MNDh0Rwwu3wfa+hJQkyYEHH81oPJCk1ojSlo8ZUiMcyd1p1gHOH2y51NUKblhWF84Rko4jSyCmi63YRzeOwvcewpkPm+DQ9JSfXzGY0FZMnCz+JjPxdtrb7LLEcYkTdiaRSb/KVOhN47JEsIn80Xs+S+/g0EgQ89K5cNpk/zPDiJO1hYNJwT6yYMyswDlcxjnzCY0xkJmytmUsrCD2ovWUeDdB/58WP9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 1:28=E2=80=AFAM Song Hu <husong@kylinos.cn> wrote:
>
> Both branches of zswap_decompress() write the destination folio through a
> kernel mapping: the incompressible branch via kmap_local_folio() and the
> compressed branch via the crypto scatterwalk. Yet only the incompressible
> branch calls flush_dcache_folio(); the compressed branch was missed. On
> aliasing D-cache architectures this can leave stale cache lines visible t=
o
> userland after a zswap load.
>
> zram flushes in the same situation (zram_bio_read()). Hoist a single
> flush_dcache_folio() out of the incompressible branch so both paths are
> covered.
>
> Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsma=
lloc")

I'll leave other maintainers take a closer look at this in terms of correct=
ness.

I'll just ask one question: was the bug (if real) introduced by this
patch, or has it been problematic before this?

Seems like this patch changes the input end of decompression, but does
not actually touch the output (folio) end?

I managed to trace this all the way to 1ec3b5f ("mm/zswap: move to use
crypto_acomp API for hardware acceleration" +Barry), which introduces
the SG/crypto API, but not entirely sure if it was broken here
already? Or maybe even before this?

Yosry and Barry, WDYT?

