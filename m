Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443B9606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 01:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=llDwBif2
Received: by kanga.kvack.org (Postfix)
	id 6B71D6B05B0; Fri,  6 Nov 2026 20:28:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668AC6B05B1; Fri,  6 Nov 2026 20:28:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530556B05B2; Fri,  6 Nov 2026 20:28:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 296026B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:28:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C64DC01E2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:28:19 +0000 (UTC)
X-FDA: 85406587518.26.40A7374
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id A80C0C0004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:28:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=llDwBif2;
	spf=pass (imf28.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794014897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2K0C4Y601dKboRibgXNYOXQyJ93jJc/YQsibXbCB9k=;
	b=8FZ5aXV5/tz34lQt8R+E3bDtRW29JXOeRZgpiB2Nc3iASv/OMVLiNLc7/KM0ghd03Kxqll
	x4rgiGzK8XJwwDBa/tefeJ9U3ZrgAP1/MlGaZFZ19Zx3BrF/EOaDGRnvoGg932ZShNvHnT
	WiN5g/C3PT3iYJfEuyS/rnsbgkqVhN4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794014897;
	b=ujXE5OTNlhQ489WtK3Hh8QEN4i/kmNWley3J357hfRF08tLRRW5Mp2DK+0OqYTwD+CQQRN
	mvHVxmV2TZnyjMmn+if/nP6ljpxxohIxK/hs5+yBbpl4WkxPguuEyyi1cOMO3HpmmI/Hrg
	7mCQXZEvx+pMhiesEwsL5rcoOno3Iwc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=llDwBif2;
	spf=pass (imf28.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3aca0bf7fd0so9393411fa.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 17:28:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794014896; cv=none;
        d=google.com; s=arc-20260327;
        b=szbKjidY3PjSX5fmUKlFbaJsyoFR/sD0KaX9dZ4arxXhHqOk6Sj1YCcKWNuLjQZS6/
         1HVLRDTeN6utuJnpOp2j4CMqlerEhSnjeLA0BSX2E3h9/p5+0Lf1JEirl72roju7Qsiv
         bWHKCqwZ2lHhdh0bHcVjo55B9SzjSvjZz+kkoJon0MBhuMfaprsaYeILfDQjdqnfB+gO
         liGTCQGj+6j42XoMGDYCiVN90R23BkXdRDmRskb8zGnzXI8uJewIhtTO1rx/ZIIciSH6
         12XUl59xLJzVeBZN7TQy7bHbsGL8BBgc+8vFPeWXYn/GfS1P16Fk+OLNrGc6cRUXcY0o
         xP9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A2K0C4Y601dKboRibgXNYOXQyJ93jJc/YQsibXbCB9k=;
        fh=RWn9KlYGYHsKPvqTK6ygGwAbJtGXaGebcV9W7fB416o=;
        b=kFKoqwXnPRaxhvYeuXnFIRRAN+BwKGsyGAho463XIsTwfhQTBMNU+qEzkRF68kxIEt
         +NOTIqBGlu9BPN2H9DbFVkid/QaFA1paIF0YZDQuzdYoCCbvhAQxbDO3IkT0XZrYN/tL
         NYPzRTs4U8vLR1ttYX9RI/zO77blveFn69VIel6tpFQK/ux7S0skfCBT/pOv2lCwGjG0
         O1Y91Tw0ObrRl382ZVo9gWrEIiU8SZNa2Ej1cBfJWBrUAlGsA1bWTV4Q599yTv5CSwlS
         CBHgdatVeP5nyUkfrHNhpr5GDs5LGkTG0WEJwC2CFlw63ZMfC+bvSZAS7etIOSni2bKL
         19fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794014896; x=1794619696; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A2K0C4Y601dKboRibgXNYOXQyJ93jJc/YQsibXbCB9k=;
        b=llDwBif2M8iODwqwfFoLVw2dyrMGg8HMaArGrzukz8hrK/fT63ACPOeV6+BR49ybbG
         XlRyFvPl0Iz5yOFmbUZhyZu/MoNa5EdquMZrGz0jxyUL+EpAnnf5xPDppaBrFUHM7WJW
         1g3Rf3FVImLhpCWyCbPUzUXjc/T+tr0f0JBvu7pIIVQy8JrykPvFAPMnRT3jSPtXjuVG
         qzIma4C/DihMApfjfOG4Khy+Kg6fNNpE/gh730KM6DFnttbMVgadfSYGir8ShoWOv/At
         0BK0Y/jlSmkMJKwO/x0RgaJgcUu943TMJqJrFTTMZ0qe82XwIE+PkRAMr0pfBCrvHeHJ
         Q+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794014896; x=1794619696;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A2K0C4Y601dKboRibgXNYOXQyJ93jJc/YQsibXbCB9k=;
        b=l7Fvd5ouZ7hkdrHYHzYM4gEdb9bL7qKlMyOoicG6msbF13EgRCB+BKiSaDwv5NCUqs
         Omwe4XjWF8dp6qdMSnh6P7ETHTXbe7kkrZTd+b18BREi95LaJ0IkEeo8A6SLVCDbnFjt
         stj/JgnS/APtm7yNlC3q4Ekpt8/gmQCrUZnpvlEJwrjVdcusyQOx0Apu1LS1XmMhsEIE
         zaPYFTt8zjvxFd84B1TVZ9j+Rqmn0SHi4VRM6Hzmw/KXnExuGC0q7PdePvOT6AGMjnHE
         jDT5ilbDXDdZCcwh9KY25xTkXuBA0va7E0ZS0ctGO0wqFlmTuhjTxVLkGd6nqG4ZaqPM
         fXCw==
X-Forwarded-Encrypted: i=1; AL+hErEevt/tgUuNsEUzQgRQWfJnCYemKmX9mlTv6eaZJwyYydYp/520FxMaTgsbJwJoFHuCdUKs3TKNAA==@kvack.org
X-Gm-Message-State: APuU4Z8aHG36O/iDnfQchZGnhf/KEXSMVp4C8tK0ZwROLy3paRa7seLQ
	2ql0vT1tngIGfWMGS8nLkhJTwQrF7EnA7ZMqgFgt1nivdDp9G8ltmgAcBFz2M5rIVMC0dJamntw
	l1BNTOPTDbSIxJv1PjXCW6qq2VsO2ZlY=
X-Gm-Gg: AYBFou34QuxLNNF797lMJqMZlxcCJEbhIO++07vpgVyjc+3xTRbnSQjIBTATXlKyHh5
	1H2jDbQJeZR9u/E7O+KyT4l8VBNfwuBze7efbjdOiiIC1ltiYjONPsC8EYriD9WVSrmNka6+Xdl
	XATN5mIujPt51HAFoPIqe8ehUdLQTIsetPZey4xKIKAYRFoYKGFdPSJlhVF458xxRMBYfrZ5d93
	Au1NeplzViwDNCClVftuGrS1QKWvrgHpigiZS854C8tX4W285hGgespPRgj5FBpfFgEtVGghgCk
	wJi66yADr+DNC+c4rU7w28/ksoO83GZx82MmuMMGB8NGEcB5hBRK++QyonbKTRiCr/t9chNeYqi
	QQq99V7T0kWvpS2U8/EClG30BcR/latZDFRd/
X-Received: by 2002:a05:651c:50b:b0:3ac:7ad6:2007 with SMTP id
 38308e7fff4ca-3acf3d2e1b2mr8306571fa.25.1794014895558; Fri, 06 Nov 2026
 17:28:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com> <au5l3KEjG_mri-br@google.com>
In-Reply-To: <au5l3KEjG_mri-br@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 6 Nov 2026 17:28:01 -0800
X-Gm-Features: AclHuK8dDkK5HTfWUegZtffyaMCinmRWFj4cc_dRxksYCqbkD4npiRB4j2h1mUA
Message-ID: <CACpmpoc3R8gwkMouwyFLw9PEqyDN1i6OcmPxsvZ1d0QOPSS_fQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] Batched zswap_store() framework with compression batching.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zxxcmqc1azw4wkfs3n3qbah5mp9porng
X-Rspamd-Queue-Id: A80C0C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794014897-254905
X-HE-Meta: U2FsdGVkX1/9veLk9S/Pg02FZFw3vcsiIJmhVsdZQIZCywG/he1JOPJh75oJEAXc9ZrOn/xWgcQ1nZMS6Nlt55Lk4le7RXLs1SC9/bZYJWXSScAccKzXaVlXAhzPcBgweixvZX1SrY68WVpZktmU1bTx37MOgkb0CcjjpB4IzTR9UbPwhcdEKIMjYrHAqjJCFBiSZnoLFy7IvNTWB24r/w+fQECf3lxvtqLTR1l/M1ORXT6LpAiCpeepQQNmo5cM6um+R6ZQEkiQjXVbmzgz3dcFglV4N9N00cUH/fDuqMQeB9jNhb8mYyQCaOaNl4EQmOYZqZLVsMEiYPz8uaQ2rfU6L1B7HaPuuaupITj1Xib2FaEcyFGBC99r09wvKYhZL8mwSL4ME5nqd0MilgAYCYzhmq2GXKhTv+YIy9PFtszN4xrhr/1SrLkUVZgdf9hl44zuTilP5cA27h3bBCVgHp2CB6WwG/bKXU/eKTFW4qtPsm0FdoiZX1pPduPV9+yizijwQibiU8pS8992TPscqbzSKSM49yuNeStTRPsaAjYWVT3GPY9vO99nsZ9Q0CivfPcqAZQGcVfmnrP0XzCo/O+6CGIC4UbnR5UHe2ht2eH04Ma26szdb9VNFcpfiw1m67PjApC0pTRSo7BVkjqGhiRt34Ey9/OwKLgZ6ak7S/EGJLUw7C8UTO5bFg2HWLrvmMveGhl51jknxnrdWPlF/rBtJYQuxKpH9bZPnHUv8ACbYggpiixHhFmzGHC+XkeQaLpZa2R337oBAMsbIYQcEk0BqVdIQkl23cgEGL0Hy5OYZku9B3BsKFXHGBf8GNMFielVUte6lCncbhJLlG5XqEBH9Dl/VHvINJqmaMDC7qt2Tz0z0Og/uVHWXzyUhc/KXdtA7lx73frycA/4DELfA3Q/NMoBQ5twPlIhxM59pjlAiNO8ilWOHGOnn7YS+X7GZ0kRAwnnP/FkE9fT0DC
 Io+l7T5k
 fP2lc9urBTprzrfq/jLky+hDQiPkNP7YIUJt6CpoXzjb6XT1goV5W10z68wR0sOelZM+f839fbcbh8uWT9Rt485C2ZxbdFu9qeHesnA4WdjVvRa6mF2AjsBOPDrfHkF6CwAg5dHwO+9tpEk4vJ1Wa0SXoB7tgfEnQAcgeV92gHICW9PcMMTdTckLDIpHTmfC3/C4CVM7Wk2p64IrUitoMaVmenHShs9z/ZakMYaUTxNcGUzTBVvuflLd8Rt3MGoYl8jzKJazrB7ORwNy72TLCTnYT2xCT4ow+XxFUKRlpk5Le3Z7JNX5Epr7Owrrled7d7uFcgYV1Bw0tdt6KUsM/xLYpRAAaLRqp6wBT03DV13blCVbKLIHNdwIXVz6iaVgNrToJUEn/7YEB6Nyb89h7wNABKhDjlLT+bY5Va/rLOMf+oXPOEJmfdBkKR0NkpCe/sjcuVDM/6HLNC75vdgFgXkWUc8ux60jsqt5F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 3:59=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Thu, Nov 05, 2026 at 11:24:04PM -0800, Kanchana P. Sridhar wrote:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >    usemem PMD THP BPFTRACE
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >            Baseline           zswap           zswap          Change    =
Change
> >         mm-unstable           store        compress            with    =
  with
> >          10-25-2026        batching        batching        compress  co=
mpress
> >                         (patch 6-7)       (patch 8)        batching  ba=
tching
> >                                                                (ns)    =
   %
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   zswap_store_order0_folio (ns):
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   p50        39,631          37,538          37,765          -1,866    =
-4.71%
> >   p95        53,088          49,690          49,349          -3,739    =
-7.04%
> >   p99        65,065          63,529          57,404          -7,661   -=
11.77%
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   zswap_store_higher_order_folio (ns):
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   p50    21,460,366      21,201,411      20,383,233      -1,077,133    =
-5.02%
> >   p95    25,975,341      27,558,253      25,045,350        -929,991    =
-3.58%
> >   p99    29,538,493      61,926,648      27,184,835      -2,353,658    =
-7.97%
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   zswap_single_compress_per_page (ns):
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   p50        37,545          39,320          37,218            -327    =
-0.87%
> >   p95        51,549          66,503          51,481             -68    =
-0.13%
> >   p99        89,866         134,854          87,091          -2,775    =
-3.09%
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   zswap_batch_compress_per_page (ns):
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   p50                                        40,493           2,948    =
 7.85%
> >   p95                                        56,944           5,395    =
10.47%
> >   p99                                        76,242         -13,624   -=
15.16%
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
> As with previous versions, I cannot reproduce these results. I tried
> with a QEMU VM on a Cascade Lake host. I saw marginal improvements with
> patch 6 and no significant gain with patches 7-8.
>
> I noticed that you omitted high-level metrics (e.g. throughput), I
> didn't see significant changes in throughput, and I also ran a kernel
> build and saw a small regression in some cases (probably with order-0
> folios) and no significant improvement otherwise. Even if latency for
> some functions does improve slightly, it doesn't matter if it doesn't
> show up on higher-level metrics.
>
> It could be the difference in setups, or the overhead of bpftrace hooks
> for zswap_compress() might affect measured zswap_store() latencies, as
> you will have fewer zswap_compress() calls with patch 8.
>
> As advised previously, I would trim down patch 6 to the bare minimum
> (without all the scaffolding and prep work for patches 7-8), and send it
> separately (with patch 5), and we can check if it's worth adding, I am
> still concerned it might be adding overhead for order-0 to be honest.
>
> I am questioning the benefit of batching here without HW batching, so
> far the results are more concerning than encouraging. I already spent
> too much time trying to reproduce the performance gains. Also, sending
> new versions without resolving discussions on previous ones is not
> really productive.

Thanks for taking the time to test and provide feedback, Yosry.

I omitted high-level metrics like throughput since you raised a
concern about variation. Hence, I decided to go with the "ultimate
truth" which is bpftrace latency measurements.

For performance validation, I only have access to a 16G Chromebook
with a Crostini VM to which 13G is allocated. I am setting aside 3G
for swap and 7G for QEMU. Within the QEMU VM, I am selecting 2 E-cores
to run the 2 usemem processes to minimize variation due to frequency
fluctuations. This setup has its own limitations such as being unable
to fix the frequency.

Despite all this, I have been able to consistently replicate the
bpftrace latency improvements with patch 8. My results show regression
with patch 6-7, and improvement only with patch 8. As noted in the
cover-letter, patch 8 adds significant latency improvement for order-0
folios. This is with ZSTD. FWIW, these are bpftrace latency
improvements in a significantly memory constrained environment and
this ought to be a useful data point. I have been posting general
vmstat "system health" metrics to prove that nothing unexpected is
going on.

My data shows that order-0 zswap_store() tail latency improves by 11%
over mm-unstable with patch 8, although p50 is roughly similar between
patches 6-7 and 8. PMD store latency is significantly better at p50
and p99 with patch 8.

Likewise, p99 latency of zswap_compress() alone improves by 3% with
patch 8, while it degrades with patch 6-7. p50 is almost the same with
patch 8, although patch 6-7 regresses. The page-normalized
batch_compress() p99 latency is better by 15%. All comparisons are wrt
mm-unstable.

Hence, I believe even in a memory-constrained setup such as mine,
batching significantly (7-15%) improves p99 in all cases, with 4-5%
gains in p50: for order-0 and PMD folios.

In addition to the latency benefits shown through my validation, I
would like to also emphasize the strategic benefit of moving zswap to
use batching, as noted under "Conclusions" in my cover letter. IOW,
batching within large folios to improve workload metrics can only do
so much (in proportion to the # of large folios reclaimed and
contribution of zswap_store() to the overall allocation-reclaim path).
What this patch series attempts to provide is a zswap batching
framework upon which additional improvements can be built, such as
reclaiming multiple folios as a batch. I believe that compress
batching is essential to support these next steps, which improve
workload throughput/latency metrics even more than simply batching
within folios. This is with ZSTD.

Due to the environmental constraints, I haven't been able to reliably
use kernel compilation for validation.

I have been doing my best to resolve previous discussions by
incorporating the calculate_high_delay() hack that you suggested to
reduce variation. The data posted in v3 comprehends this suggestion.

I would like to suggest/request the following, as next steps:

1) Can we reconcile our methodologies for usemem bpftrace
measurements: # of vCPU, usemem command line, reading Silesia, etc.
Also swap space and QEMU memory allocation, using linear lhists() in
bpftrace, etc. If you can share these details, it would be very
helpful. Thanks again for your time!

2) Does the kernel community offer servers for contributors to test
their optimizations at scale?

3) Can I please request the help of other zswap maintainers/reviewers
to validate this series with ZSTD on a server setup with usemem
running on 30+ cores, under high over-commit ratios; through bpftrace
and/or throughput metrics.

Thanks,
Kanchana

