Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB38D47CA4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 00:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF2A6B0088; Thu, 15 Jan 2026 19:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7591C6B0089; Thu, 15 Jan 2026 19:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6584A6B008A; Thu, 15 Jan 2026 19:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57B896B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:22:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE07E1ADBC8
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:22:55 +0000 (UTC)
X-FDA: 84335926710.03.98B3CFC
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 366D8180004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:22:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="foS/JBsN";
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768522974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DW/ITMg56jRAZJtQnAt5F58BDqK/01GQKI49GCbQ0F8=;
	b=FQEHdlVr1Mu3p6asMvXxAURHkHC/wa61tVpCYWj8ffN9Dtxs95PaCdjJJPmLlmohayMntc
	8a1rU6/bEhT1OPILbfYCJN5RC/2zaxGlhrUDBzXHN83hkRaD1nqmzFMaWL41fYViQAIDMY
	lmLKIhiSbmw0PRwCdD77fh7oj9PTj2E=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="foS/JBsN";
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768522974; a=rsa-sha256;
	cv=pass;
	b=OHxSxOQfxKyu1rezIPCGM+0ueW2vpLHrhsro2UCef/MUn3g4yjRxaw7S+O/0lvE1K9xhmH
	UUWTXSu+7Wbav7YdL15NSqpobbNKzL1dTC8rimg35BGNf3QerW7NTPFY+EiofCxMVF9cTL
	at2BMj2hllCTxdXpJckCoh+6dWDwsjc=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50299648ae9so103601cf.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:22:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768522973; cv=none;
        d=google.com; s=arc-20240605;
        b=hr1/kKk84AXlETvAwyHeY4dg4+voP1uZLuoE0gkdZdjXLoYC9LCHWPKevikRoVXQ1R
         XyZG7Jfjo/478gJMYJunZ2bwEJcBTV5ukpGHby4tRdotlu+vWMj+8F9BfcggNEFO5mZu
         MuLkGCyJC5wxO2jZbLxmhcdsotc2Ie3vFXocYqBPMmTvfQHTKF6rW+Ud4oPxaNNHKZsb
         CUn07GQ8I4yfh7aW6KezVUNRw5EcVYCcfYmzZqa3/rIT9Zcq+w/uBGAVCtzcYj5ZTtCj
         nOHYJryIRKaRzM2pUS0JmJrsYulY5INMCLo5V5kgNu447qdA5CNjeVjEbZrE/dj53Cwf
         NWTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DW/ITMg56jRAZJtQnAt5F58BDqK/01GQKI49GCbQ0F8=;
        fh=qibKyhaUG524Jn2jVuZem/+RzNLSl8Zmv/sISUmliUI=;
        b=l2h1MZDAeW77cH0vHnl2u6FzKoK96GUZhDNdWMT9OqRcEqp/QY40D05ok2s13JPM87
         vrqD+RaZhqURdmXZVLZ+jhBYmGYDvSZlwXHXwrpZQkYloCBPDZX2m9BMCdH1vYK3ORxA
         3Enp0FS4ue8ahUA1J0etxwSJewoW4Xurlu6BEjPokMqGXZ2YgB/zQwjTQfjiAgmYkt0H
         l+7l3wt6RyRPsMF+G0GQaDZi00HvTpfPeSCKFitmV7U1XDT9XB+rnbyWb71cNj0WMFm3
         JMY00b/HmwffxbeLEWV7arvwwKIDY7MtYU1xvB5IvASCd/0zUYDea/wruK4HE2A8ll6m
         VGqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768522973; x=1769127773; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DW/ITMg56jRAZJtQnAt5F58BDqK/01GQKI49GCbQ0F8=;
        b=foS/JBsNeMkpqH4sLKQSQD8ah6AWN4R8NgPwMii0Odfcy6aBhg0cTuMyX8J8jZ8/or
         20wccSld9oInvYNZTas2c5Adue+551C3QK6fu4POwMgGEbUT+rctkPsfZb+esn/7TpwK
         mg6/QCR0NjhrUzVdPh2uIzfYIFPUB4Xe7BC+ZzeCvOTA7Vb4EXmhaQ1lu4LyXviqxJnI
         QwJnkw6N9nISGE2QG0eu7imm1yFfq1Kvk1A10F4oXakXsM24B0rtB3YyzvzKgRPtkyZn
         MupqZ64325APmmoF39E0NcUPGqEb/I2MZHfDP2ZJMfGfcPu5DUzdlsuAhqXpGmljq7r9
         aeEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768522973; x=1769127773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DW/ITMg56jRAZJtQnAt5F58BDqK/01GQKI49GCbQ0F8=;
        b=SxwFUQPFyIOOTib4CfKrKWWCY9hy/5joZxlgjZobMdcxuXWvPvD1RTp+X2Md8v0NIq
         sgsrlANtnKk2WvViC/Jhrff0z7SUmomzNoLALq4pTGnBDtrfc8+DzeGyzL8WPGAuK+DP
         Dq/YfZ2eJCPIQ4iCf7nRen5dHXC6RZ/LOHtO8pxThjHnOdTWLronT2olWauNEyxgnBh6
         ZRNH81LUPfQEBVWlOAQO9RTjRi1xN+XOaYk+vSu0OxY+gNd022T91yNe5Q2XdU0878Ok
         CCcbw55y5tqkVCX/aBYIcbsO89VPn00l5VJY7a7BpCW2liGXddlCqb1aoc2BH8eNBXyQ
         2O+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXyr/hx3cU7nE4uqOP5H3m6HG3HJINRf/7AZhh/9B/d5H2TS0MZj8rqwVSeF1dXMPR5Cg0tTI0N4A==@kvack.org
X-Gm-Message-State: AOJu0YySMgUfQqw4/WDIYWaY327gLUzAkvB+Jv0Vmeg5TqPdzJKGbXoY
	njDNSt8RvtwZWsp5uUMHkA4BFDXvwNDtg8C//pzuN2dHroylkZhVG+TfGom2qHi0lnFoLstdQlo
	I85Rr6F1qeORvpvO/IsflG8ZARlR+A5HivR8K3Fr3
X-Gm-Gg: AY/fxX7rb+PEEjhtdcNet/ZeLwgKtzU7aShR1vwQf9RWkn4Tq9OnRnTiV/wYa9nikHu
	kGjWN336Eku9dO2WD0AWoBsGstXX/oCxNxTMd42cOs69uh6q+V9EH8gF30yW2ZmMZ3NWE49My+U
	xYXoQdMYRuZbESVc636ANEQQnk2OBhaX6OG4Rf0ktB1B/r6m9RNSSDHYKEqfO9UTusxUAwSX/mU
	xK6S8erdINjzpXMcIHLrX/diij6B0rmjVODafPlg94V9wE2i6oa0NoPWh86IoDMJt5SD1pSc1WB
	codXknM5vFFjXV4g15/LY0E=
X-Received: by 2002:ac8:7d0b:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-502a367742fmr2431351cf.1.1768522972940; Thu, 15 Jan 2026
 16:22:52 -0800 (PST)
MIME-Version: 1.0
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz> <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 16 Jan 2026 00:22:42 +0000
X-Gm-Features: AZwV_Qi0xiGM2d4FuoLFqXrZf077B4nd0NZeqj4924Qs7epHRHPkVirBgIQQHEM
Message-ID: <CAJuCfpHowLbqn7ex1COBTZBchhWFy=C3sgD0Uo=J-nKX+NYBvA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 03/20] mm/slab: make caches with sheaves mergeable
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 366D8180004
X-Stat-Signature: dmiam899hrhrwwi8ne596oduiiaipe65
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768522974-47495
X-HE-Meta: U2FsdGVkX1+ko822TpggvXDl/2q8hQ4h/guQHb2TujebLkVMwwLaNlQde4VzkZv8JZ5YSTyjz991Bm6ABTOa+4b/82qF9CcoF8gv8s6+6AtBWY0cKN3cBKMwclFlr0TUT8mwOcAHX/skF76SXfcE/d6pTV3SzJj1C4w7g+a1+6uT0CuBpFI5F2EM48qx1k0X94PoVm1Rt9pEJcCeg6AIlv5BqAUS88YFVj6HPWcKsmNRoV8mRAZ7cNVI0envqhL5zdIYyUpZB76oGMH13VI73iGPV02KXie50KiZ+JDo5TwFjWZc3PEi8NRreITrQFvZO3hFE6zoGCvTpEz3k3RwYLa7mcVN9epy9/Li/y7M/tFH7BNXoV9mEmMbpnnANCefjjxqvC7GIS85EPvTgrx9baVa6lkAY4xJR/FrsJSGjKRnI4NxrxKcoOZBgfyo5uhgBmHCg36j+hZnzpfBWq6H04GiBfumRCcjmaHkAPUW8b/bTA28TV4FPNOrnQC6guhtMcKHt4k6Qa+W/UzJwl8J/rZF9A715MtfxvPxC5aNv/rhZctzIplwBWdyxnG18Q6amr6cEnTH9a2ufAzJiRrvrIq+MgvYf8UrGH19Njm4nuc7A2ruQ2+SmE31drlljUp7X/s3hgPQ/HjYC4SCwP4ohNYcrNdG+owBHz5g74uFF5seizHJpJ/PVcdt3CIqXUvyzR4owdBSRMt1ReoG2o0njGvgls3aigE0kax7p6lxrJwHlsc8hhUc/24RmR1BlrPmC9aUZwcexYRWTqH2qnpSoOW9aEGm3GHYjlSokVBP3bnxwJkSX4Y8Ouog8NXPYXb7/DAUEsizRZuWVl+ygCE1sXRK6gbOCmw3ZKr2jLdbMltQ0Z8LSVspjflVqURx7wmzF7bGQrfheuCMA/ttd/d/jjMKCNIsuWH5GayYBpBL3cZ/7r8sV2BdcPEZWiNQGtaEBmYqXVymHbI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 3:17=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Before enabling sheaves for all caches (with automatically determined
> capacity), their enablement should no longer prevent merging of caches.
> Limit this merge prevention only to caches that were created with a
> specific sheaf capacity, by adding the SLAB_NO_MERGE flag to them.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab_common.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 52591d9c04f3..54c17dc6d5ec 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -163,9 +163,6 @@ int slab_unmergeable(struct kmem_cache *s)
>                 return 1;
>  #endif
>
> -       if (s->cpu_sheaves)
> -               return 1;
> -
>         /*
>          * We may have set a slab to be unmergeable during bootstrap.
>          */
> @@ -190,9 +187,6 @@ static struct kmem_cache *find_mergeable(unsigned int=
 size, slab_flags_t flags,
>         if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
>                 return NULL;
>
> -       if (args->sheaf_capacity)
> -               return NULL;
> -
>         flags =3D kmem_cache_flags(flags, name);
>
>         if (flags & SLAB_NEVER_MERGE)
> @@ -337,6 +331,13 @@ struct kmem_cache *__kmem_cache_create_args(const ch=
ar *name,
>         flags &=3D ~SLAB_DEBUG_FLAGS;
>  #endif
>
> +       /*
> +        * Caches with specific capacity are special enough. It's simpler=
 to
> +        * make them unmergeable.
> +        */
> +       if (args->sheaf_capacity)
> +               flags |=3D SLAB_NO_MERGE;

So, this is very subtle and maybe not that important but the comment
for kmem_cache_args.sheaf_capacity claims "When slub_debug is enabled
for the cache, the sheaf_capacity argument is ignored.". With this
change this argument is not completely ignored anymore... It sets
SLAB_NO_MERGE even if slub_debug is enabled, doesn't it?

> +
>         mutex_lock(&slab_mutex);
>
>         err =3D kmem_cache_sanity_check(name, object_size);
>
> --
> 2.52.0
>

