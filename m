Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1138C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9881C6B008A; Fri, 10 Jul 2026 14:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938AF6B008C; Fri, 10 Jul 2026 14:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E8C6B0092; Fri, 10 Jul 2026 14:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 647296B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:40:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9583A0525
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:40:56 +0000 (UTC)
X-FDA: 84973733712.06.BC6FE31
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 18932C0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:40:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="q7ler7i/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783708855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gYMQJJbAjdzrXWNM0IUL9noTtFdb19UiMl7JAvvG10=;
	b=LDR1MF8H0iY2hJfoihzOGX3QXFSrteiGe8MU+nYwg96VsBOUj1i67165eQeYaH4XR7Q827
	a6+b6GDKxly0GWGOMnQRe3iCU7DDcKQPQznNVrbUNcpHiWLB6KNJTZWWLz59CzU8AsHKXA
	H6NRyYz6gBpdNPZcOlEaF7SMI8kRzTU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="q7ler7i/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783708855;
	b=TJfE1grN19ETHV04NZa8TOrVoJw5ivrhVzQr98Mv8dGGhwPKzH/pEt0MPfMxmKUg1O0SZ2
	2o4Fy7AoLuh54ONL5CPTFLrvMrCaHTf1+nbfNYYJCNWCvA2oiXnhi5MA6BXHDzaqp5N5+e
	JjyunyaGN+R1piIc/n33HFbGKHbIDVg=
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-44aeefa1c00so1059022fac.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783708854; x=1784313654; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/gYMQJJbAjdzrXWNM0IUL9noTtFdb19UiMl7JAvvG10=;
        b=q7ler7i/SY/2AnBPBhD3T/U6MTb32ukU1lSqXhDeN5vy18IteLuFrDH2F41uR0tp7Q
         Uf3+QYT92NbtLa2NIOhpOuIPY4rzc0aWp5jpRJBTWdy1umIoAt+WR7K8IhGpwj19c7M6
         rOjcFPNBG7ZNSDTQaI37Adn1n+YlvM3EZbZ/hu2Unnr9cHYG+egWAhW1pbFJLnfsaOZ9
         5np53tHxVm0mLY9rkwb+TgjhKcTCl6g+ieH9cdf8UQXSDtQod7ss4OVaf+VbAGjceg04
         Q8z7H00ttodWgMk1yfy4TydM199TzP38wQTwttQCWIKRrYwlH0c8S6axENVA2/Pcp2tc
         lzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783708854; x=1784313654;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/gYMQJJbAjdzrXWNM0IUL9noTtFdb19UiMl7JAvvG10=;
        b=s86sSQLFdscQW8nC9aQk9q+sQPtH9t6g/MrAWH7dun1BljbXNjzvag2OAmci+7veSp
         4VjQJUv14yKU2OR8Mbo20GrmCKqyBUZxGaEWRgKwMa186zxE//kpt4aUerPpa2j4R/uX
         c7rKFYR6+weptOE5nZsaLjm10hQfntHIH5OFqztaBZAHPdY5eBFtBzfMOjv5CKOgSE6b
         2apU6CwWPxATb63EhoTH3dwRZkkhOj4EBnZQYwS6TEvWfJo8sWBTUHWBK62LN7dA9b7z
         YwOiMIRcqvBaW1JsAoCZXWSCfvcbL3M8i8axGM6A+TkjAkYSy/xix7TAFVqmledrkuiB
         KWQg==
X-Forwarded-Encrypted: i=1; AFNElJ/AGoY46qQNsQGFqaVNwUlelOewIUjruLHXSVdv2akDVP2AA5wzkFEbkoPpamjlWcSFQ2PVqUvi8A==@kvack.org
X-Gm-Message-State: AOJu0YyDOMlLBGuSXyzL+Y4iSCSVtrMl90k+aWr/1dBNezQ9wCYg2ify
	s3V1IXQAdwGW83mmkOaGCzT2o4BwVOTm3xRzKJh0eenSl0KLFRgokR8p
X-Gm-Gg: AfdE7cn7m5Pr5lwahE+muhVXA7fl0EcCnN/PhgdUSMYWaEtq2aAp8j7bvkmOxhDua4J
	g6k4U/Rqhu6ZEG/32B2CCZqXyA3FyJ1kHOhJeORNfaAeLkMu4ACDqh7xeBzJlReQKCqyVMeKSbd
	QefTm468IBC7e1qE5SF3bKrKdUqR+CK0cAAgcvoKNoZn83hBEfX6uzcpGXvXSrLK6AUgXSc9DdK
	EfZ3C6dy7+b080MzxvosVGAEl39yCSGUoO6vZo+e8Gce8e6B/RIcvwRznkrMopF3sm/gaHudXJJ
	03zE+Wa20WVJAMThVkkHwLCkE0g8NWHyrjg+rJxnZIDrkw8BqY/oIfY3Qpr5kHQ8iK1pkgk0+84
	VpbyOGmi2C+bgWSIL+eoYkwzvQikFu/AzYwmf5gylxQt1VPTdAqGfAqmy0Onk2HJtWy3aiRRwDX
	5/1ev2XDHUsUj9S9HlhNwceK31JVhxMknyzLzR/gbKjS4iIL+/2T9q3w==
X-Received: by 2002:a05:6870:96a4:b0:448:aa9e:b051 with SMTP id 586e51a60fabf-451bb02c525mr2471609fac.14.1783708854079;
        Fri, 10 Jul 2026 11:40:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4519134dff2sm5444218fac.8.2026.07.10.11.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:40:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Song Hu <husong@kylinos.cn>,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: flush dcache in the compressed decompression path
Date: Fri, 10 Jul 2026 11:40:50 -0700
Message-ID: <20260710184052.3614560-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAO9r8zN4ig_GGP4a=NLZ9PUW+jFmSfY1yBLrkPA9azvDCrGSvQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18932C0006
X-Stat-Signature: w5aon1r8s9isu4ak16mt98d7bkdihs75
X-HE-Tag: 1783708854-732067
X-HE-Meta: U2FsdGVkX1+IOx94hryAHhpEj5W8spTYESoi6hcpUESYUUlqBlxg4ukMaYws3O/f7ooe85uPBxk26Qyz95RGM2vFn9QcM0pnWMesmBf57+Byr2a+XIWleKJSFaEdacRBi60yMbCWUauL2AzrjsVFy4IsqydxtqE+Dlq8d6Y1Hy//H4UBhWdKjTrcyq2ntAHh0sMd0Mi7Y46gjs9Mpf3Gcoo37mzCDSPHJoc4/f7hL/9vABUs5O7P1vLWWwPdMULZ92aLK4k1mUhFAM/opz5aOg+I+zHJM8ZDjnQOSQw5DvgbxfxI8y4GBVtgJo0ZDZYkwrW0tRrognM7n/FNg58ZW/EfpXEEnOHHcuZUMs12cPBcVEBpGCbbxbIBxC8Bos2mnIi5NjMs69V8h3L0lx8MEDxMJ8mB55Buq81BleBkAh+faYaeufRG5rbL8jZLpVEzIUj+j9WCuCxcXH8dCVEpF0VqOhRBx544A/wFypVJylybQaJoLlNMKbih1Zp1PVYvX9h/4oWk2QR0IAoHNP60S2XnzPCvpAvWR9eCC7MJRVNJD9GL+wfxKkpsbWX/v/sbYTRmP0We2CWW8IafOpLtsS0gkY4jXUqGNDeKmociQrFQhF2j8nT8oN/qtFQuvixbFbM/pdkGe7vs6jGhlpkbB98+aRQmyKrIR9PTzPawAm1dbaMSF+IA59apb4eFdBKGksD1jaH7/nbkflLsz5p0XPL1Ds8WcDTIlmebqx5TcaoXGWbfS0KSwtzVZkFWOxKXMWjN73BQsbySHE5rkBj+jmFmcyICiWAzrVylPH3R6P8xT+mJXXA0HdfWTvzeEM1TuM44oqI712O9KFcSRCp7AZMO72HMER42gFC+eTGilq2UYu7hlq96/vlvSFvzoFobXZMXMg4DawB7uuw+a50Ji2Scm3V9uPpoEWD2xIX0KcyXqKPl1TqUG/URxU0xWBCjjIiI26S/5DEmFEyHlXP
 k7zFjhOF
 5Nzn4eliCxBUuq/gZnZv9RpdYvR30CX++VGcqdTp1eBisifBjn0lYwKNLmIDSiEcmKKmV5pSCEfJQpDMQN0a6TsigLpOdjV8P/hG+7HFh5Ul0opeuBTSwSWc5A/r//UgwGnroK311O7OMzB/Kk+ZWeTXuGs7Ujy3oj6roLMaRSlj64Mb1/8rdehTq9bqdBQohN0fJB64M/i6yCoCUdGORAQjkqqudAHAHnXG4C+6KHzZiehS1al6W4X/WiFZ8VlrvB4rsNfjF48bPCaR6Md44bQju42iOY3Gy3UHj+R+uCGlwDZrWXa6iwEBvjLFXS3NtwaYjgZkap6p2xfPKZ8rqkmUTBfZxLMbPx0AvaE/pHyg5+X+4z92APer+B6T5CUnSjtu15LXCX68v/gLhfhicoZifYVmzViBGdfqSFZV2hu70H/euci6Kfh2mvmd2z1kgKGvHHLT0e+gVIndPu0fsDG9c9dFkM0PZJ9HqZlsAjHuuj07eSoasT2UCx9qajv+tQ1YCzi8nZz2j3bFsT1UI7JP9wIx9b7Kqf+ltbraLMQHt+tQMvV2wnuURlDV0tX63llY4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 11:22:43 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Fri, Jul 10, 2026 at 1:28 AM Song Hu <husong@kylinos.cn> wrote:
> >
> > Both branches of zswap_decompress() write the destination folio through a
> > kernel mapping: the incompressible branch via kmap_local_folio() and the
> > compressed branch via the crypto scatterwalk. Yet only the incompressible
> > branch calls flush_dcache_folio(); the compressed branch was missed. On
> > aliasing D-cache architectures this can leave stale cache lines visible to
> > userland after a zswap load.
> 
> Adding Herbert here.
> 
> Doesn't the Crypto API take care of this for the decompression path?
> Maybe in scomp_acomp_comp_decomp()?

This is what I think too. Actually if you use something like
zstd_decompress() as well, it ends up calling:
acomp_walk_done_dst() --> scatterwalk_done_dst()
		      --> __scatterwalk_flush_dcache_pages()
		      --> flush_dcache_page()
over all the pages in the loop.

Maybe I'm missing a path here that would require us to manually flush
from zswap? But even still, I think that should be handled by the
path that is repsonsible for doing the actual decompression, not
zswap.

What do you think?
Joshua

