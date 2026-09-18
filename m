Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6202CC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496636B008A; Thu, 17 Sep 2026 20:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FAC6B008C; Thu, 17 Sep 2026 20:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EAE6B0092; Thu, 17 Sep 2026 20:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF8BC6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:53:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79E52A04EB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:53:53 +0000 (UTC)
X-FDA: 85225060746.11.2F10C82
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96C28A0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:53:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Cr+HAKIG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789692831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pChmIbk5dvBz2x+ATGHEFGjZSAwLQf4D4OxFleYq/PI=;
	b=Ctc4ub5Q2fUMlBFxuD0DzxUbpGlqeltF5TVXSabbCiKFpB11ksoRRVuD7JrbpQQ1wIMmQv
	Y+0mlFUv0v4tPn2anY4m/pvQXNF+emNIi4yGY6jmdKdkl8YV6lCv+9vnscbc9a99WAA2tP
	KtkAg2kAOxXjZ4VgBKR88H8j21zAtOA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789692831;
	b=yczxa4AA6dsY8guhtyO6yxWp+J/TI+82bZbiA7RCfG768hnGx4YUhxsxDhMtGQjZ1nsGom
	X733PdtyTfSrQxyZqHn6Q37MvRvQwRP/2KijSGuSI47j3jqdmiVTJSC8sHptz9Ux9AfbO0
	D3tA64TokUwD8uxS3XDWS+hXx6BrdRM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Cr+HAKIG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-530f6bcc301so70201cf.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:53:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789692831; cv=none;
        d=google.com; s=arc-20260327;
        b=b6mifgjPEnZhYoR2B2KUuVTLaN93PrWwlt17qX61qbJ45qkCt3KDRFk2VQRnFfWKYc
         ygpXuaR27iYeBgoHq6bWJUehPEc13fRTAimq/2WCcwmBMUu6iKW8YNtpEo9GpWSCTUbB
         r46eu6+RY8cLnZDbJCKr6xHcMJtBAQWM2zbvwbyT/bdgyo1iBUeTaSVDSVg2lELcMjk2
         1/I/OdoPorXAALr2bl95VXuhOb8Yps3bW0J+aRm+DMcBEIxZ6hCSZ6ILXADH3IXujh/2
         FQHF5DMS34bQeeeCwaXtcmRNPlDmRD7zFQovPdeB0mXSojQ/zyypW+GK6eH74uV3k1bZ
         l3tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pChmIbk5dvBz2x+ATGHEFGjZSAwLQf4D4OxFleYq/PI=;
        fh=SgstSbx32hG6Zoc5/NsxhPiXGziw1Kqvyg8mJjLrIxk=;
        b=O8juYTsDJ+nddcSq/iRnJsKvBGilDsQkqXTuhdNNr44JEbPQtUHUF26DbU/z7Rvntl
         uUq49JneRcCxcCbcctYhXYOSBygQmWx43thcjhAg77AOCR2K0SUURlRehvbNuaHmrubI
         oMTFxPleSei2FAbewSL+Cp9hBv4/FLg/kG4ltTB+pwAaxaZZQzXxq985P48wK98rux60
         NDEp6+MuehloRVm7AirKCK5kMsgiSMLAeFTbBrqVvIFroz2xQUvuy27Xida5QNGVVLcc
         dCCQKWHtJCjRcrSgSzb+ss4FhdRg8mioDPdpBuH2lCofn73U5+g4U0f7MJQuTQYIFVzm
         FhKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789692831; x=1790297631; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pChmIbk5dvBz2x+ATGHEFGjZSAwLQf4D4OxFleYq/PI=;
        b=Cr+HAKIGcCRXsMD1hN1Gzk0vxsKOtxYOE1Qp+0PIZYJ8Ktfj0UeikqD43ZtSyQoao9
         sVagOIHxcj6Q1ceea9xe9js64G8CgN7VCeNRTi0/512WBTaFpVSog8dc0k457kQcf+MW
         pDl5SeGZDzU/4sCelhmkBlVOSHaq1tDzh1F5PeEp6w+hIk7KxWDvH2wwPXLrkHsz7x5O
         g6yBczFTjUDiY1tpp6jmvo0xjrzyW/scvxP73P+nSQMphixglToZJNzd2UskyRcByPZr
         Bk6iYyuH10nUxOQ6ySXrD9JDyQlZLct6BaJphfp8uq1iNfj9C8Ac+iqxk0FpT13Axkfz
         ML4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789692831; x=1790297631;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pChmIbk5dvBz2x+ATGHEFGjZSAwLQf4D4OxFleYq/PI=;
        b=gVMlWFZbOMGlUV6oA/TpEsF/EaXfBgAis5aHfWc5hYU6p2mVJJFyIir3m7CmDf89Fw
         9XOBM0IZdPwf8MLUbW3XTaWLsHlyxCRv/dH7dRRsdU2LxCqjbtfs8cqF/4qGg3YgY6tt
         9FvtxhxN2kZq8fnxfBddLWnG63FIY7oQSJoOkawpfukJ1nLqS4h0xpDFSG+CNmhHqDxE
         4h+mOaDhsU6LJtMrAD0qiLZCXFhbxkDcHAvopjYhdJIKGlndriRDSoV1IALHDTBpcUX7
         VCRbKvM2XA3NSkFpD9bz9oR/wjcMEmeSH2SOLF4Oi1xgKS8AYKcnz4YnqQP9V+Ek7OMg
         t6yw==
X-Forwarded-Encrypted: i=1; AKwUvBwHsvSF4Q3q4+V+N22luKp1gnDRSuYI3QGMvn03Yl9waGX5WOZlrX48auI2Td6VUKlTXLecNYNqbw==@kvack.org
X-Gm-Message-State: AFuF++nXz3AhQnBVCnaosWKwtDfCxEsc/yNfggYnsFbFMs/CDXwqk26b
	sH3a6HxeTZD3tygLaNJqpn8gExWw7jxurn0d+pHsLn6rXTNUbTwfmHgrFT5mQF8pSwzrVKKYGz8
	tU6Qry3n4vXLczgzuvAWfHmBW23aP/jnHiJ/hqKo8
X-Gm-Gg: AYBFou3BDatXaFDtFpICRG7b9vVwDl67MXR+tROASNzbvMoBpiKXWOxA+uznAurI4+e
	ryrAXJnTdR+CsQ69t94idrHRXmlkN0jX14+VllPWBdwCuJ/y3TDmUuRmJnwZOLrdDcFvRF670CR
	bqoVgWefI2HTyHASipT4hr4RqCu1gg3B0Ab6+WPnAKOMEz3M5lC7A8y+3j+7uezyg8bRyOep+O1
	ZEMggLkaZIc9838qcJL2SsJBghE+uFM82wP9axDkXnsVKkt+8rB6ku9p75J5eiqQ01kfZFH4wwA
	7ILXNwPPM18s+43Qt0gVjEIPuBmCVtaAzpOIBLE8SyobuI/2UGd04WrbRe0ELxiq
X-Received: by 2002:a05:622a:649:b0:52f:9ed4:8d74 with SMTP id
 d75a77b69052e-5329d7ebce3mr7543761cf.14.1789692830152; Thu, 17 Sep 2026
 17:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-6-hao.ge@linux.dev>
In-Reply-To: <20260915070001.113559-6-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 17 Sep 2026 17:53:39 -0700
X-Gm-Features: AcwNN1VY0P1eKa2RzQfSlte4wi4uAKsbNqye2Ulhzad_L0NMHnJfbc2fVWd5zEE
Message-ID: <CAJuCfpFKGxOy9W+ZY9KasU5YaDVG4kbGsV6AYb2NNRyW4gT0mw@mail.gmail.com>
Subject: Re: [PATCH v10 5/6] alloc_tag: skip percpu counter allocation when
 profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 96C28A0005
X-Stat-Signature: z6ysuz6tsh3zdpxuu8t5aqo8r1nsahdg
X-HE-Tag: 1789692831-312223
X-HE-Meta: U2FsdGVkX1+lpgRzLvIFvyUsht0c+0F4yWESCQXdx6E0leJ+Wo/Gzkc/tvDkdzQxfTdzYW7KJVdluKdNN0ffWN1Ecf20iybGd956cUj7Mlh6XGmV6sCocSA+xit5tta5Dl1PPF7KfwilqZE7roREWaa1Rnf+nsVxzT8Z1LOAK9xtge3ENZGBqFQdlpa8gXSIPhuaAqyzQ0nO6Pm8czuMRr/zbkeezeBJdXd1rXzvhutG2yGUx8Z0Bpc9Y8acI3ZZRiYNRi+sTNLXeYHWfXbSRklFftVTBM89jX2qyng2gmiVqjeEOIea7Gx9/kthKZflxlnzJow9dCtN4ri+wbIs0pEkroBqgX4Qo0x7rfiBQ8OsIKsoxjIEj/VlGZbi92rtPlTy792sQcUg8X57K+k6TMkVfWjFwr0IPDQkWeZEQLbpu0oKVvD6oifOSD1wOv9D86pyZDgYImWPjG5T4b9lMJIXFvCB6XoMLDdYtza5H1CtR2QkjBiYHs3LTfdXOswR4a6mQYAphelwgu34aUpI5y201oRYHvzkdUCfuWpEXnydIJLBbRlmQavT+6IKAwImqPkxJ0PUVZHy7gHJP2EzHjqVd3hv4dBSz3dzzU1jFCwbbWs3O7v4WxoQT88kK9yVTxr7uRYIIquqguuDc1WzDvNn3D9CLZ6fw/fvsVr2fJTqGCYNaa2SXsqvuEJRYB0bOTFu+WR2/y+TbHleFWIMh4eT8YIz0Zbf0Q+7HAvLiWEVo88hNXQSZaRXIhzT5X3zy7/YhaKyGWwSMF6vUXO5kPI4IQhCU4KHTgtlRqIAGo4LMWgxDbBfRU74wEvl9ucL3Nkiza5EK7QxnCV8LieOIyT6ucWSBnIZFE6wCuKkg+fH40nVhs/J3+vVup9Gy2QOCqKZE/JRjvXS0gyw1z0j0GZTOTG4FKt1kdYqQSPGg4m7FlmHMWYrI0a+W4ikE1j4JtSVnZ3X1KHayCoQ1ap
 iNbL+JWF
 tF97WiX3RbXhl0PTt+5RWFynqsuvIA1UWEfUHvNNof91O82xs0DPa7nge/Q4D3t5nd9XvBu6EzVkR5AD77CdpNlQXP/cQA5MbNp4MYdPmSuq/weuq0DkByjXr2+ufbEIc59VZZNROPg5FgKK5o7LeVGWkXGQDNWAefQ4ULiYW5IpZ1iiQB2eltuoYZAPTHhWt5DfXI86IRe4SWcBX89VJZgGAQlQOuCVsIXZxLVzp8mq0gwoh+ze4lO1W7CSiaghDTucPrONgiwQPgAXBiFOHt3N/HgHaLgppPH1nyzblIrDMxmVv6cXwzxTCjl9xyhiQQIqNx/cowLflx+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> After shutdown_mem_profiling() clears mem_profiling_support,
> needs_section_mem() returns false, so later modules have their codetag
> section placed as regular data and never enter the alloc_tag maple tree.
> codetag_load_module() still called load_module(), which allocated a percp=
u
> counter for every tag; release_module_tags() could not find these modules
> on unload, so the counters leaked.
>
> Return -EOPNOTSUPP from load_module() when profiling is off:
> codetag_module_init() drops the module's cmod, no counters are allocated
> and the module loads without its tags. codetag_unload_module() now always
> calls free_section_mem(), since a module whose module_load() returned
> -EOPNOTSUPP is not in the idr but may still hold a reserved section.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Suren Baghdasaryan <surenb@google.com>

Yeah, I guess I didn't think about alternatives...

When mem_profiling_support=3Dfalse, why can't load_module() skip
allocating percpu counters, zero out the whole area between start_tag
and stop_tag and return 0 as success (mem_profiling_support is not
enabled, so we acted accordingly)?
Module will be added into maple tree and later codetag_unload_module()
will find the module, call release_module_tags() (which is a NOOP
because tag->counter=3D=3DNULL) and finally call free_section_mem(). This
seems more natural than special-casing with EOPNOTSUPP. WDYT?

> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  lib/codetag.c  | 10 ++++++++--
>  mm/alloc_tag.c |  4 ++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/lib/codetag.c b/lib/codetag.c
> index a9cda4c962a3..a0b600720afc 100644
> --- a/lib/codetag.c
> +++ b/lib/codetag.c
> @@ -240,7 +240,9 @@ static int codetag_module_init(struct codetag_type *c=
ttype, struct module *mod)
>
>         if (err < 0) {
>                 kfree(cmod);
> -               return err;
> +               /* -EOPNOTSUPP means we can load the module without its t=
ag. */
> +               if (err !=3D -EOPNOTSUPP)
> +                       return err;
>         }
>
>         return 0;
> @@ -388,7 +390,11 @@ void codetag_unload_module(struct module *mod)
>                         ++cttype->content_id;
>                 }
>                 up_write(&cttype->mod_lock);
> -               if (found && cttype->desc.free_section_mem)
> +               /*
> +                * A module whose module_load() returned -EOPNOTSUPP is n=
ot
> +                * in the idr but may still hold reserved section memory.
> +                */
> +               if (cttype->desc.free_section_mem)
>                         cttype->desc.free_section_mem(mod, true);
>         }
>         mutex_unlock(&codetag_lock);
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 5836803898ad..1ca0409b492b 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -988,6 +988,10 @@ static int load_module(struct module *mod, struct co=
detag *start, struct codetag
>         struct alloc_tag *stop_tag;
>         struct alloc_tag *tag;
>
> +       /* Profiling disabled: load the module without its tags. */
> +       if (!mem_profiling_support)
> +               return -EOPNOTSUPP;
> +
>         /* percpu counters for core allocations are already statically al=
located */
>         if (!mod)
>                 return 0;
> --
> 2.25.1
>

