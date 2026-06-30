Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7764EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 08:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CFD06B00B3; Tue, 30 Jun 2026 04:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680696B00B4; Tue, 30 Jun 2026 04:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595D86B00B5; Tue, 30 Jun 2026 04:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 167F06B00B3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:09:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F6E58D595
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:09:18 +0000 (UTC)
X-FDA: 84935853996.24.300D8F8
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9402120009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:09:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=e9Nwa2Gy;
	spf=pass (imf03.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.171 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782806956;
	b=oBC8r9YfY76sdVj9l6pjCcPD3LIcrzLIcA8kuo81KxGnmUOQWlkFl3sZjAXdQPHT96705V
	UFvZZa0TmuJZ1tCFwZLr1QjXQP8nI0sl7SJtMC79H++GmBV3j1nkfaZHXn/BMQ1v7DPiVv
	6jNNTy2QFTbkHYLEOZuvT/0AxH1aMXY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782806956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMfxs/lV3gs7hZOuAvr99QHZT5L0EyUo7IHm9UkfFF4=;
	b=oKJGPV7WlSmzSve4JXdFmuD+OZzyQn8DYtQe8kvBpdkITxnYPFBH2697IyxoZT2GEtTTvp
	CvZnGyBUwXf2y/N6qa2uT7dREZbKXZGWZ+eyywA5csHDQiI0nal36Ri0pI4IHspXQAyPeN
	p7B0AYedCbzWULH/zbCRjHNbNp5/kUw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=e9Nwa2Gy;
	spf=pass (imf03.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.171 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8478a25f268so1100228b3a.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:09:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782806955; cv=none;
        d=google.com; s=arc-20260327;
        b=Zyt+hMV31mtBFJgtSRYj+ucZcryExncXX8sb1RzwOxqhqKJhwar3d+LkRjFKPFDjA0
         cmR3QwdFlfxTmu3u1J4/nCRBXiZYG2diyJ/gs96EBm1pYRDxEhdkm97REGRidOiIFJ2d
         fPkjJ4b79IByVDiTL2e9jKeZA9/dfnhIkHhy/DdiNYmKpmofKXy5a104DKL4uLjdE2nK
         1SgYjRLmfOjS8b/lv3uDICckFGNg8r2woSq3queaukoREY9X06TRqWVaDzbSKxgg+Y9W
         WjmYlBGmKA+NKqwrxj+1cpBFyydTJ7qdDfPBL1pHLQDp+FV7e/BF76fzi3BXMyNKs07e
         sn7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QMfxs/lV3gs7hZOuAvr99QHZT5L0EyUo7IHm9UkfFF4=;
        fh=qW2nQPNc78710P+q9kXB85pcl7QbgvvTKba6D/BXFnI=;
        b=IJg40A2PNFoawNCJzHsxzfMnOawb7qohCoBzVU4zhzDJXBxQr4+U9V+lNnYZiseNaV
         /5d+RWxuazoKSi2SeDvEAOmtPxDd5U+SUSsHzAD2NFrsH928dF5P3XkGGCcxJREHMdpi
         1rN7e2OSWwYqmlNOCzvtDYyKXOocDBWlg9mqTsfNFRs4C4CrheVLwAUhPBkOCCvW5L7e
         bBXJJ11ocw1ZSfjm17CA0azA6XxGYTpXGbHUv5AuUf3UA3qoTNKS4OBel21se0VWpRS8
         1/YxkYTB3B3qWtOMOnexUyHoX14qv5ueuOhK+qhfZmou6WJmxyxBU+pKqxRwtNWVQOyD
         DTjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782806955; x=1783411755; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMfxs/lV3gs7hZOuAvr99QHZT5L0EyUo7IHm9UkfFF4=;
        b=e9Nwa2GyZf3GEGH8BFEcmS7OLwZkul5HAjIcgajz/ZhCyAxh/WnxjangRjHnPn3biG
         cCnmMlgOOunAEl+ItOJusgsWyvSrqZVDMMAFsFfrHdPZk+1w3j4VaXM9Z8u2pitwxJ7M
         s/2ceq+AWltUVWlvy2x9QSRpJqicTim++Xipbahpst0qSarWmT4uN4Yg5hOh9OjM42zB
         ajoAql9WcwemEvUzWluovwurCCoHdhrPvvk0Lp4gupLS0K1Na9AO7hzNUIfasbaP7M9t
         YNzxCQ2Nz+UKLLCAJVKabCYQMMFMkOfsjdi2PgSORV0SpszDgrVwL69+tysW6wqiBw4P
         tnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782806955; x=1783411755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QMfxs/lV3gs7hZOuAvr99QHZT5L0EyUo7IHm9UkfFF4=;
        b=aAdPYYZzEfTOa60gJw7ZgVWQDy60ic9zd4h5XnhmshThetwViZhv0RRfmhZlCgrn+M
         JqLq1cTt9m9cfNLhGbRiYXx/QKiK3u+kNI0UBF7p7sAjZ+vPH/A1Xsci/U4F9YxN0oKu
         I++v55LxP7pr3LO5XKm7i6kmx5c0ar0c3sJ23DUp5DhdOhkx4ni7yHV6FiVXvIXKdaK+
         RwMzZrwoO7OkgxQjXGCEvSlGdTSW0aT9uBoCEJdVJNGWff2GtXWSATII23Q75qfEDJk1
         plt780B6fNpH2UwF+r4TzgQfHS6wu94scHs/1jKxE7QhaPE4KDoG9eJ7rkPVM+upr3fj
         cIug==
X-Forwarded-Encrypted: i=1; AHgh+Rq2rIzb8DL0BS9KJhAFMnz4VlJsvdS8qGYX0qCL1g49Yyj0cipHUywfP49w8TQ7IqYXeT1V7aGkFA==@kvack.org
X-Gm-Message-State: AOJu0YwlEL3q556i3yy0pyWK57ombbi1wDeFPgNKRHKkqRqDJEYkR5nQ
	waCKFjxd2nuDC/My9e3AuUjavdnFCN1XHAXIkPaBM3la9zx21iMrOkbuB60/gjXYCqJ/5OrOsy6
	Nt+p5CTao7KXRUaeXljd391a+hLDJvVLNpCQjuxRv
X-Gm-Gg: AfdE7cl4+/qt+PJOlZTNi4Vn9WIkdFFbs8Qe9iYznHeG+MozNGRxQ6QkQ+zVBaI2iY4
	ORVxl37TZSYgmWMnudGOt6uLIoKI3w9EXlIQXWH5TbzeReAntCRc5fZ7Zim4IrrmIlWfCF9TXvK
	J07xQ9qlgJp1xD2a4R2gdU+RVZzdMF0nCsUFWjo6vyFpg3LgbCAMANGaGdgEoWxG7brtr/4fdh/
	a4IZYKFowIiz/sfNQVcHk8f4A0BQlkKfh/hViN8/23BrXA6xLpq78FxOByFKYLcAu6ttuXfRpcY
	Ts1Pr/P0RYt5ruCE0FBonDiYvLPdSQ==
X-Received: by 2002:a05:6a00:bd0b:b0:845:e8b5:8c49 with SMTP id
 d2e1a72fcca58-8479ee9a9a9mr2040137b3a.10.1782806955524; Tue, 30 Jun 2026
 01:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260626173444.2252041-1-xmei5@asu.edu> <yu6l7zo4dmqcnho7thkf7sk42lt6xkz6uxxwxmg73x23vihlnp@pe7vdut4o2jc>
 <CAPpSM+Qwmv_wsNFnEjtk3GbLdZB_JtH5vW0v-Cj-CyiE8M_UEw@mail.gmail.com> <20260630071257.GQ1181229@noisy.programming.kicks-ass.net>
In-Reply-To: <20260630071257.GQ1181229@noisy.programming.kicks-ass.net>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 30 Jun 2026 01:09:04 -0700
X-Gm-Features: AVVi8CdBvYa65GaG_aiHMGG_wGQ7SXzFa_rmBeFZe4-w9ahKm8Oy_NU9CMHCKu0
Message-ID: <CAPpSM+Q3nZTULXxRM8_6QzfF0BBDLEWOcLF16cciuFzS1aodCQ@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, 
	Ruoyu Wang <fishw@asu.edu>, Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, 
	Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: mok5cok7ukhb5xaj994qabqgywzhq8qr
X-Rspamd-Queue-Id: 9402120009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782806956-521148
X-HE-Meta: U2FsdGVkX1/F7wTVGtBUJbmisagTmZUvveMqzIjwlH2ZcmNCHO/4Dnf/vAdylvhA0As9TVnWcFKUo3bjYCdpSTH4dBvr+jizcV/3mWLOMOJOL36/bQr++RPATxBHSxE4f3zLWmk1QRoJYx+ulN3CI9rJXD5Y7ebAeOHEobm8u3nZa8HQvQhb8Ebo3dDFy14XYKcX/iWvUKi9iSmh72JWY0E1dsV/iUGwur1ObOq8vQ66wovyYkc8UEZXyZi8lHXbO7wtKvcAcFwBmTjjTCSLASv6SLS2YsCq6d4tFZFW8euEmG3OnYhKu+hxLPsYRdcAb/kwZyHFDJntLKFvWpILI+Xb50IZUxBVm008dENUoNl8KdJVUw5d1tK5qHOa3vopykZcwkL9mX7ZF3t/jWhw2bArGJB64g43QgKCyupSKxteXdu2BfmKJW1U75mbpS1/XSga2YKaJI785604pBuERKS4EiVH4pqqyD/H/dRtPcuA/zMyIWcqC1S1WuHrRWz6vCWazwasz1tmSJFRUp/YnVjeMjsckS36oWW25If8beWGIG+DGI9rZPNA/elKfuqsCIbz+kaStHtKNDPTWklV9sMNrak9susQs+r4mqj+f0z1m+QgxpHrDeNiDfBH96P++gLNzvM15iM7il2twMsEIpNY73CqojK9rdDO4NPzJya8ZOhFpe2McC4tNX/IqXMEVKddJugo9R/tulwfZ4qK9Mh7WTtIqPzYXziOZE8ELU6J63OcRCN0X4eT0DyhjtYdNrAAd5adBvXKraRWRHpsizpJ8WifMF81hNkJ5NfHcMLnKh/7HiOzvDNdYBvpBdWHoaMvc+fvyeOU9oVKQ2cIw5ruzKCziP5VlGogbZOG82GuUQ6/G3N6sMPKqgJl9ac4/KlVwLfW6pM7t8oQKX80EEtoq/CKuRjebv0IPdQxgEUTitDdJPzoFH52U4jDTEsV3FNVz4+4hNY5uPKpGPS
 jHsgIb2q
 TrDXZ+rFJvSWVfr0KXNWX5SUHGLKRlafGa2Oxj9oPqWUBHhuKr46MrYaeKujZEn/99nE7xBbJ+NWIG3u951Vm8llBh1YgyCtKBtCjQUJxvdCE4MFMy++JnPJYzoNRSFpDdVuy160HmBgn+JP+skT1FZ0Ia4yWpXEgPuLR8KyPBewNesEmy5heXKF3UXV+Fz7H16wDz3ryefzyLTfGVG1zdR8llrdYPLp/EHfoAF9f2jiAfKHATDGlsUmrMd9KTvMybbKn7YKkB/1J62GgBRs5azra2eMIf10MKyUIj6rAfNqzSYBjoYtMkOxjiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 12:13=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
>
> On Fri, Jun 26, 2026 at 10:48:46AM -0700, Xiang Mei wrote:
>
> > >   - The displacement is attacker-chosen (via the immediates) up to 0x=
100ff,
> > >     so the pivot can clear any guard narrower than that in one step.
> > >   - ENTER is reachable as a gadget, so a pivot of this size is availa=
ble
> > >     without depending on register state at the hijack site.
> > >   - The pivot happens after the control transfer, so it is not constr=
ained
> > >     by forward-edge CFI (kCFI / FineIBT).
>
> > Please ignore this line; it is not related since we assume we already
> > have a CFH primitive. Sorry for the confusion.
>
> So I am still confused by all this. CFI does remove a ton of CFH
> primitives. Until we have Shadow Stacks sorted, ROP will obviously be
> the main alternative, but I'm really struggling to justify adding 16
> guard pages rather than going after any actual control flow hijacking
> primitives.

Sorry for my wrong information. This is not related to CFI. I'll remove it.

We assume we have a CFHP (control flow hijacking primitive), and ENTER
gadgets escalate the CFHP to ROP execution.

>
> I mean, if you have a reliable CFH, we should be fixing that. But
> somehow I'm thinking that if you do have one, ENTER isn't going to be
> the worst of it.
>
> Or am I missing something here?

You are totally correct. ENTER only works when we have CFH. It works
as a stable one-gadget primitive escalation (from CFH to Arbitrary
Code Execution), and we propose this patch as a hardening feature.
Sorry for the misunderstanding because of my mistake.

Xiang

