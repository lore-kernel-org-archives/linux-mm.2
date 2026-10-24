Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4630606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 05:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=iGrmHk//
Received: by kanga.kvack.org (Postfix)
	id DB15C6B012D; Sat, 24 Oct 2026 01:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15756B0130; Sat, 24 Oct 2026 01:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6446B012E; Sat, 24 Oct 2026 01:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D48776B0733
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:48:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5640DA783F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 05:48:42 +0000 (UTC)
X-FDA: 85356440484.17.3749D05
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 70C88180007
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 05:48:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="iGrmHk//";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792820920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6D6lOz4P8rDJmxVCDMDICqLLJN650pwKHNbrX64l7+4=;
	b=e0JM1B7TVzpMH+0zeIaEG7APrKCVVCNALbNlDfVK0MUQLMQD96TS9xRwUktdmDsV1MS0qg
	jvOadafL3QiJ1LuxkQKDYnKWWer6DmIIM5rFgESGHjZtuDRbuVDARvMztW9z3YT3An4X45
	hNB1YTP8BmPAZDhfGNt/D14Q7tMcaF8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="iGrmHk//";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792820920;
	b=VY0vvvzsyKy2+M9fmPAEJPXWSHKt07vwVy+EToqChfv16Wp4CInOqwfvG2JbdZhfNXa4se
	AXXhgjZPVMjbm2/gnqlhstXIChPHEb2TOCRqG4JAT6BfOvlN4CtbC+bR3viH3elGYvJO4l
	8W7+2Ezkx6X52ld0JSDD3k+N6Jbfkmo=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-35b2c599f43so3586782eec.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792820919; x=1793425719; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6D6lOz4P8rDJmxVCDMDICqLLJN650pwKHNbrX64l7+4=;
        b=iGrmHk//nDhBuOPehcxcLCHwjf6f28XN7KrW6wZnUSHA1ke8r3KW9D2yeppsY35tMQ
         2JEJFNqicb7wkaWG/hpngpckdlVE6p0u2phBdskjXVpkdB5KiYeQgCFlAxmBoJRPxbz2
         tyEE2xyIEh8H52L6qwoFm5HD8wgslskZGPZNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792820919; x=1793425719;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6D6lOz4P8rDJmxVCDMDICqLLJN650pwKHNbrX64l7+4=;
        b=cfsAVYWljXHxW4qc2SLoV005v41KipNItwPmenZ4+WlxKBNjmgGpzaBLEQ6W9sR5Sn
         GGBJ0gMsi1qq/Xhxt2bnb/oscHQ+rozEWgmdabzA64ayBooy9DykXQHLIf7DOv5rLejb
         ppW9rzO4d6vhN9eN0lH1SlP9NtTeaRc7SbSbMhZtAhD4eRAfPZvql/OeokyhQPK/8FaN
         GRKtcnowi+LnvwgcgNA7uaSyiFCKIk2hpPUKCarmpwsUk9jVhuQYIImiFWzD4+JubeVF
         2oWYW5n3HHhjStyp6P3UbIFF4B8XhGKXfURGapd72LBpi7w0bsQCTGx9whGWLxBFb7o4
         CKhQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOgeld0joR5wgUsAH1bUeRN83JD2qMhd+0vGWU2HjjpYsq02edI0pY693UM8uPCmuwjQLKZDjdyw==@kvack.org
X-Gm-Message-State: AFq9FYIpDS0R636tYrhaOGq151xzc3mviSiZw1mk78MWYJs3bdD7go5A
	o9m42TGZDOo1LpEc1zZUuD+tZD5uGj33nO3xr/jbQkilhWjThH4JAMbUVVlicHFw1w==
X-Gm-Gg: AYBFou3Zde7tbDHWivMS3FL3NbuGXq33KANF1NZuYaufhARmUFxBZmIyvk5ekwMnrP4
	2oK8zG4tvX3WsnAxx1iRufQhoKVvannDNLlOpsyS01UYAUaUelyuTvCmo3TfbWwVVdZDRWXyq9D
	GdM6KCGL4xErpFHxNPRGI7u5NQKI9XAE9jHnkXbYY7blnOGLUJs1G3k/wB72mpoFTeR+A+fpdio
	ofQGgmQIOc52w0GhLHl1ADIR2e6sA2dlD508sU0aLmeWTNGQELZsAeZ4sOZ+R0Q8Cpa3HiTkAGJ
	+BnagUSe1hlPykAXDs4EJYO1A0DLZGun/Y8JyFJlV64xtGaxe4YXV3nEO8DwA7WsscazdC8xBcu
	FIX8Gg6I29gSA0fxWExC0qiIpcdbb4VPDjQryOeXDHev1exkwZOfQTvZrv99/wY3dvaRu7H81jE
	jhWwQgcIFadH4OdwkJ08JtinAbzLUQWIjAFyCWbVcNKRNAJjLwJp6tlRaugJwOPjVaqwByw7WF6
	loAHW1SP/SUEkS4cEH9X0IKbCKJIiq8v7sJVCDugxOFgIK3FTEDmbcSucRp/beZfpolczW50c3a
	cuRXGnvYXtHffH5pLG4+VGyGmY05GFqsXOUsGrmTzQ==
X-Received: by 2002:a05:7301:2284:b0:369:1084:8ee3 with SMTP id 5a478bee46e88-369e848c506mr2557802eec.23.1792820918864;
        Fri, 23 Oct 2026 22:48:38 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:f7b9:fe46:772a:da49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d93663sm4221618eec.13.2026.10.23.22.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 22:48:37 -0700 (PDT)
Date: Sat, 24 Oct 2026 14:48:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hillf Danton <hdanton@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Barry Song <21cnbao@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Message-ID: <atxFgutP-N3UZex2@google.com>
References: <atrnvuQkeldgPqH5@google.com>
 <20261023114050.1011-1-hdanton@sina.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023114050.1011-1-hdanton@sina.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70C88180007
X-Stat-Signature: 3j7u4a3514mzz85nhihjhnipsdckoaxo
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792820920-761920
X-HE-Meta: U2FsdGVkX1/uPPmqRFfQZ10+JsnyWw8EVA/zH+x+BRS5yUmEZkdps8OGOzlFUXKHkgzDi+srOiDj20Z+YknZr2EmUddDmCO5bEF6vljRVr6PQER5ncUvC2KYQIZcRTa4Y127m+AxKN2jRlwQ8EvED8d3J7v2wDBCMWii/eY3vnBWnJjaTNL658Vnz6JbqjfPU86fPj/ojuKNtpXRpW00WYXS7ec3DqyIGqnUSis5xHdIfczZGxXIPz9qESaRDJsGHX9kpGRcv34GCCes8jTos+HfUXUh07HxydBFACleTLk5aemm84/dA73BYO4g6JMcaNOk5MJQZj/TOI09I6ZRJA/Q60SMFQCbsC/41dhQSQ6nC6n+OrO/zoC0VUdme8tSySy7QdXQXXWht31YYXB6s/iSbsxr9e+nyowmJ92/VOowXrKWZtambqgHp+5Jn8vq+NJpvHUgbLngXDwOS2Ej8vHIP9YWvESjqqvneFowLc/SSLJfzUtVPkOYO7tz0yEpS4WuKW6ndXs1T/M8HdoceqEdy8mqshwDggxHu5GMkCL+8ULT/E94z6QidfvpFmYY/f/mcYsK6ZfJU2rutllnrwz/XL73zvNhRYixSI9qYH7Kg0wbTgpLfb90ty+2/N52XTc091iv/tg9Zixh3AL2F7LKMezOehMiIkLNugof6c72q1FXkkaS9x9ErMEUyJaije2ArKa53sGCmOX0TRROJoaiVDHtst9KeDcRmyWXF5qLZ0H3KkehHonqf5AlHjZtaKpbrmpBSaIZEIGr9HouEWZZoLteMua8fKzk4dstdnJmqRCcok98t3mGYtAUSELuCBGLGwCiFUVuzlJClNe+/BYNpf8LV9EjjuHB/pNvSaHWCGzRciQDvMvdjFnub6UGhCYVXV8UyPEp/nWU6ovUwClV/Se+k1BU02VkeMNhCUgVItTZYLMHLEv7ERUF9zk1HhOwG6TEBQDz06bLkyy
 9nJu4o8n
 4oNOqo2vazcbLJgdV8SVOXZW82m2DjhxqY3L1kw3ToPmp2/Pl0XvENGfCsH2jh6zXnoQ+nsIbtHMldQ3CaA0KECQ8qLTa0ug2IXfVkQ0QjsYFZN/wqoQNS0lcPbFoDtU68bqr60d3TyQ4MPaN0MBDuaov1jELQwOwe9dR9OMEwgxOjJajxEiUOQktRSmyNMyCAFeSzHkmicRGww7rKrh2xQk1Mx/PQ/v2kO2rJpeSDfwoVUjsmrdOsw+P3CPOawiXeMtWO0p0oVBEJqXClhMKs8AkgtvMSda17YPWspAlMekFW1Me8oZVkNi12gKtQVAO+R2zJs/3y0m5vKrUSRwybg08yJeeEkaOFNEL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/23 19:40), Hillf Danton wrote:
[..]
> > writers vs readers 3 runs
> > 
> >     BASE+PE     IOPS 1,271k  avg 5.57us  sd 1,393us  p99.99 27.5us  max 1,581,800us
> >                 IOPS 1,461k  avg 3.43us  sd    78us  p99.99 23.9us  max   227,015us
> >                 IOPS 1,444k  avg 3.48us  sd   222us  p99.99 23.9us  max   592,628us
> >     PATCHED+PE  IOPS 1,457k  avg 3.32us  sd    18us  p99.99 27.5us  max     5,620us
> >                 IOPS 1,464k  avg 3.31us  sd    17us  p99.99 24.2us  max     5,621us
> >                 IOPS 1,475k  avg 3.29us  sd    16us  p99.99 26.5us  max     5,620us

BASE+PE looked noisy, so I sat down and tested properly (also tested
zstd and various compression levels).

(PE enabled for all tests)

######## zstd compression level 3 W-vs-R
    BASE     IOPS 1,154k  avg 7.84us  sd   444us  max   697,634us
             IOPS 881k  avg 14.16us  sd 2,242us  max 1,387,000us
             IOPS 704k  avg 20.43us  sd 3,499us  max 2,058,300us
             IOPS 563k  avg 29.02us  sd 3,910us  max 1,649,800us
             IOPS 626k  avg 24.79us  sd 4,013us  max 2,085,800us
             IOPS 976k  avg 11.54us  sd 1,518us  max 1,165,800us
             IOPS 1,178k  avg 7.44us  sd    22us  max     3,103us
             IOPS 1,120k  avg 7.39us  sd    21us  max     7,222us
             IOPS 522k  avg 32.51us  sd 4,311us  max 1,598,300us
             IOPS 581k  avg 27.54us  sd 3,626us  max 1,448,600us
             IOPS 1,160k  avg 7.69us  sd   352us  max   702,099us
             IOPS 1,169k  avg 7.52us  sd   129us  max   281,428us
             IOPS 954k  avg 12.06us  sd 1,705us  max 1,545,600us
             IOPS 1,029k  avg 10.24us  sd 1,156us  max   976,065us
             IOPS 1,169k  avg 7.48us  sd    24us  max     4,305us
             IOPS 1,177k  avg 7.45us  sd    53us  max   118,777us
             IOPS 579k  avg 27.43us  sd 3,661us  max 1,615,800us
             IOPS 1,169k  avg 7.52us  sd   115us  max   228,074us
             IOPS 1,110k  avg 8.59us  sd   985us  max 1,288,000us
             IOPS 1,177k  avg 7.45us  sd    29us  max    72,245us
             IOPS 580k  avg 27.74us  sd 3,755us  max 1,507,000us
    PATCHED  IOPS 1,179k  avg 7.40us  sd    23us  max     7,404us
             IOPS 1,179k  avg 7.41us  sd    22us  max     2,857us
             IOPS 1,176k  avg 7.40us  sd    22us  max     6,615us
             IOPS 1,175k  avg 7.44us  sd    23us  max     5,623us
             IOPS 1,176k  avg 7.42us  sd    24us  max     5,625us
             IOPS 1,173k  avg 7.42us  sd    24us  max     5,632us
             IOPS 1,172k  avg 7.41us  sd    23us  max     6,223us
             IOPS 1,173k  avg 7.40us  sd    25us  max     5,848us
             IOPS 1,173k  avg 7.40us  sd    24us  max     7,563us
             IOPS 1,172k  avg 7.42us  sd    24us  max     5,625us
             IOPS 1,175k  avg 7.42us  sd    23us  max     5,626us
             IOPS 1,177k  avg 7.42us  sd    23us  max     4,243us
             IOPS 1,170k  avg 7.46us  sd    25us  max     5,622us
             IOPS 1,178k  avg 7.40us  sd    22us  max     3,213us
             IOPS 1,167k  avg 7.43us  sd    25us  max     7,593us
             IOPS 1,174k  avg 7.44us  sd    23us  max     6,971us
             IOPS 1,179k  avg 7.38us  sd    23us  max     3,477us
             IOPS 1,180k  avg 7.39us  sd    23us  max     2,894us
             IOPS 1,145k  avg 7.37us  sd    21us  max     4,048us
             IOPS 1,177k  avg 7.38us  sd    22us  max     5,620us
             IOPS 1,177k  avg 7.40us  sd    23us  max     5,623us

    IOPS: BASE 932k (+-260k), PATCHED 1,174k (+-7k), 21 runs each.
          significant difference at 95% confidence: PATCHED is 241k (25.9%) higher; 95% CI [+136k, +353k], Welch's t-test p = 0.000
    max latency: BASE 3.1..2,085.8 ms, PATCHED 2.9..7.6 ms
          runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 11 of 21, PATCHED 0 of 21

######## zstd compression level 12 W-vs-R
    BASE     IOPS 690k  avg 21.53us  sd 3,088us  max 1,635,500us
             IOPS 478k  avg 36.51us  sd 4,385us  max 1,941,300us
             IOPS 822k  avg 16.13us  sd 2,865us  max 2,263,800us
             IOPS 1,161k  avg 7.73us  sd   114us  max   190,307us
             IOPS 780k  avg 17.56us  sd 2,717us  max 1,550,500us
             IOPS 1,166k  avg 7.66us  sd    40us  max    94,522us
             IOPS 585k  avg 27.51us  sd 3,847us  max 1,550,600us
             IOPS 1,147k  avg 7.97us  sd   344us  max   496,483us
             IOPS 1,166k  avg 7.64us  sd    49us  max   115,243us
             IOPS 1,163k  avg 7.66us  sd    23us  max     7,006us
             IOPS 1,071k  avg 9.42us  sd 1,489us  max 1,915,500us
             IOPS 962k  avg 11.88us  sd 2,168us  max 1,904,500us
             IOPS 607k  avg 26.05us  sd 3,538us  max 1,591,100us
             IOPS 1,167k  avg 7.63us  sd    23us  max     2,903us
             IOPS 1,157k  avg 7.78us  sd   198us  max   418,930us
             IOPS 1,163k  avg 7.66us  sd    40us  max   100,346us
             IOPS 1,162k  avg 7.70us  sd    32us  max    82,602us
             IOPS 488k  avg 35.43us  sd 4,340us  max 1,786,400us
             IOPS 563k  avg 28.85us  sd 3,989us  max 2,209,500us
             IOPS 843k  avg 15.43us  sd 2,490us  max 1,572,100us
             IOPS 604k  avg 26.30us  sd 3,560us  max 1,555,700us
    PATCHED  IOPS 1,166k  avg 7.60us  sd    23us  max     5,623us
             IOPS 1,169k  avg 7.58us  sd    23us  max     5,629us
             IOPS 1,157k  avg 7.67us  sd    27us  max     5,639us
             IOPS 1,166k  avg 7.61us  sd    24us  max     5,644us
             IOPS 1,160k  avg 7.64us  sd    26us  max     7,543us
             IOPS 1,167k  avg 7.60us  sd    24us  max     7,514us
             IOPS 1,160k  avg 7.61us  sd    25us  max     6,643us
             IOPS 1,162k  avg 7.65us  sd    25us  max     7,315us
             IOPS 1,161k  avg 7.66us  sd    24us  max     6,237us
             IOPS 1,158k  avg 7.62us  sd    27us  max     7,688us
             IOPS 1,167k  avg 7.58us  sd    24us  max     5,637us
             IOPS 1,165k  avg 7.59us  sd    24us  max     7,098us
             IOPS 948k  avg 7.58us  sd    23us  max     7,808us
             IOPS 1,166k  avg 7.60us  sd    24us  max     5,621us
             IOPS 1,166k  avg 7.58us  sd    24us  max     5,672us
             IOPS 1,162k  avg 7.65us  sd    25us  max     6,824us
             IOPS 1,165k  avg 7.59us  sd    24us  max     7,078us
             IOPS 1,168k  avg 7.58us  sd    23us  max     6,191us
             IOPS 1,170k  avg 7.56us  sd    22us  max     2,851us
             IOPS 1,171k  avg 7.55us  sd    22us  max     2,834us
             IOPS 1,166k  avg 7.59us  sd    24us  max     5,627us

    IOPS: BASE 902k (+-269k), PATCHED 1,154k (+-47k), 21 runs each.
          significant difference at 95% confidence: PATCHED is 252k (27.9%) higher; 95% CI [+142k, +367k], Welch's t-test p = 0.000
    max latency: BASE 2.9..2,263.8 ms, PATCHED 2.8..7.8 ms
          runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 12 of 21, PATCHED 0 of 21

######## lz4 W-vs-R
    BASE     IOPS 1,422k  avg 3.84us  sd   418us  max   619,495us
             IOPS 1,450k  avg 3.57us  sd   326us  max   609,723us
             IOPS 1,414k  avg 3.92us  sd   543us  max   879,815us
             IOPS 1,451k  avg 3.56us  sd   253us  max   503,428us
             IOPS 1,460k  avg 3.40us  sd    68us  max   135,825us
             IOPS 1,413k  avg 3.31us  sd    44us  max   188,450us
             IOPS 1,432k  avg 3.73us  sd   503us  max   844,228us
             IOPS 1,387k  avg 4.20us  sd   719us  max   961,827us
             IOPS 1,464k  avg 3.38us  sd    44us  max   133,675us
             IOPS 1,469k  avg 3.38us  sd    22us  max    65,812us
             IOPS 1,465k  avg 3.40us  sd    49us  max   111,788us
             IOPS 1,465k  avg 3.39us  sd    64us  max   174,040us
             IOPS 1,467k  avg 3.38us  sd    36us  max    97,821us
             IOPS 1,445k  avg 3.63us  sd   343us  max   671,026us
             IOPS 1,472k  avg 3.35us  sd    27us  max    86,795us
             IOPS 1,473k  avg 3.33us  sd    44us  max   138,096us
             IOPS 1,439k  avg 3.71us  sd   353us  max   619,815us
             IOPS 1,398k  avg 3.36us  sd    54us  max   206,815us
             IOPS 1,471k  avg 3.36us  sd    15us  max     2,832us
             IOPS 1,407k  avg 4.02us  sd   629us  max 1,074,800us
             IOPS 1,465k  avg 3.40us  sd    63us  max   158,779us
    PATCHED  IOPS 1,471k  avg 3.30us  sd    15us  max     6,946us
             IOPS 1,473k  avg 3.29us  sd    16us  max     5,618us
             IOPS 1,474k  avg 3.29us  sd    15us  max     5,615us
             IOPS 1,473k  avg 3.29us  sd    15us  max     5,625us
             IOPS 1,440k  avg 3.26us  sd    13us  max     2,829us
             IOPS 1,456k  avg 3.30us  sd    15us  max     5,623us
             IOPS 1,476k  avg 3.29us  sd    15us  max     2,835us
             IOPS 1,464k  avg 3.28us  sd    16us  max     6,063us
             IOPS 1,468k  avg 3.32us  sd    19us  max     6,692us
             IOPS 1,465k  avg 3.30us  sd    17us  max     6,834us
             IOPS 1,468k  avg 3.28us  sd    16us  max     7,268us
             IOPS 1,463k  avg 3.31us  sd    17us  max     6,480us
             IOPS 1,454k  avg 3.33us  sd    20us  max     8,418us
             IOPS 1,452k  avg 3.32us  sd    19us  max     5,621us
             IOPS 1,477k  avg 3.27us  sd    14us  max     2,834us
             IOPS 1,468k  avg 3.30us  sd    16us  max     5,617us
             IOPS 1,475k  avg 3.30us  sd    16us  max     3,884us
             IOPS 1,475k  avg 3.30us  sd    16us  max     5,692us
             IOPS 1,471k  avg 3.30us  sd    15us  max     5,616us
             IOPS 1,473k  avg 3.28us  sd    16us  max     7,014us
             IOPS 1,475k  avg 3.28us  sd    15us  max     5,616us

    IOPS: BASE 1,444k (+-27k), PATCHED 1,467k (+-10k), 21 runs each.
          significant difference at 95% confidence: PATCHED is 23k (1.6%) higher; 95% CI [+11k, +35k], Welch's t-test p = 0.001
    max latency: BASE 2.8..1,074.8 ms, PATCHED 2.8..8.4 ms
          runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 1 of 21, PATCHED 0 of 21

