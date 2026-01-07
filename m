Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845B3CF6BF0
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF626B0092; Wed,  7 Jan 2026 02:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A6B6B0093; Wed,  7 Jan 2026 02:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0E06B0095; Wed,  7 Jan 2026 02:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64BD96B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:12:53 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CBDBB6684
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:12:53 +0000 (UTC)
X-FDA: 84304300626.27.CF78073
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 158C340003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:12:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CBXhy20k;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767769971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUbJDPxRAkFii6GIwUpaShmOF1DYpS3f+2ARv+nfV3E=;
	b=6hAT1bt0jXfBZDWUSQblWSWCCM/7yafHoWyculR0D9U0vxz2c4PJcKc0PzTtkN9WOXbi41
	O7rjrz7qD+/gLnb8lcUw++B5uBFXfhANMTT3BZdAWC38S+4uI9FI7/xXL7R4mVd8YdL223
	Db/iaxIq91XFTql6hNrA+D1FgGSKdu4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CBXhy20k;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767769971; a=rsa-sha256;
	cv=none;
	b=cCfWhL/NFYu4HtT7UTzQtzr1Xi9qLokg/88j5w39VTlIFu95KTRAbKGSlYk/77m4E0NC7T
	FFnUyV2vOFNVAXg/Linm9l/o95glUEQEGy9TrhQLOVrTSepJ3Uaz7P+oe0a8NCCN2r2ntx
	6y/pLOPHAe6IQ7Ah5ogkecLj7LGkZmU=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0bb2f093aso15119635ad.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 23:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767769970; x=1768374770; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PUbJDPxRAkFii6GIwUpaShmOF1DYpS3f+2ARv+nfV3E=;
        b=CBXhy20ktiIfOfXP9nAg/Si3LgCIww1GOCu38zlCOCJodwsKl3KRoViK6U0lG2SoCm
         qhZzIOaPu2hdWeOq5boN1K0EyObNUwusl/13VdxT7WkmwXcAE8pvFmtDJ10IKEQZGdMz
         pZ0Jcx9wdQUUGxv1e/6jurfaTk1o3zRRw6nOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767769970; x=1768374770;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUbJDPxRAkFii6GIwUpaShmOF1DYpS3f+2ARv+nfV3E=;
        b=oPbZ+B5moyZI00QUCI+uyF1W6lra1G7qhw02Dvx2d5QTYTY4YOzWkpcTv17l7rcz+y
         kJmHwzfmn8T/ZgguU+REC68odyAixVkzA6H5b6U0+zBd14GLnzKh6AVWP+ZV6rgi+ijO
         uPa642ElIYRdZT1RusgyA1jh4j/dQiBedQ+Kt22ghIqi5Is554zJK0uycKkcw8lBVA71
         bkifM3Dl1vR8wVLWwwFD11T4REbKrblqGmj64pNwcrTTuy1Ul+qPaqUV+vadN1HscUhy
         T4WRzM6c+8ZuAw0AyUaRlVvPgTgLQ4YQqHnIJ9FxO0e6iNeqKx2JRGQCrqNVMq9LGwrw
         hPCg==
X-Forwarded-Encrypted: i=1; AJvYcCW2iu3n3rJWTcx+EMBUf10XCXLKFrIW973PsqGRXbgBgErB1OkGLQuXOtJVUebJQWVDYwBde/Up+g==@kvack.org
X-Gm-Message-State: AOJu0YyBfkp+yMSCsW6k+4hj7fvhR3Nu2ZYGhNsHgszCJhJr2MRak7BX
	nimTbm52rRjFKqqoPLCEWdR8AlNLRVXxF7WDn7qCzi018tEWC3FJOuItokh2zMPHGA==
X-Gm-Gg: AY/fxX53jv1IR3DtgAmWyUJ49Yh/71Pg1pLZAenyH82+9h5WKhKyjYcywSe7ciCVUR3
	3/UEnkgaUfrDoP091tQrMbyZLSWB8mR2Bn96QkAbjGdnSQkOAs8vCs+UDqIJVCMczsEPpyGqLgn
	/fE5GEoYc37Xl1e+Oe5WwM4ssH4BXqlqyqYtBw6BBrrkTp5NLCO4qTBv13FVUP9nFulekGKbQDR
	2EGxy8APnwZc8ZczinhWsH6QqNcnKFP62B9HWkxBvW7td8rrWTk7MtHUDnFL2zxQq4Ibj5JgErE
	fK2JiSSrxdhNWCRc9vYw/raN75JpF77QnXuBK8nYw6n1CRYg4inf4z6D0YIk1SC5rUDdM1jH3mc
	u4kP1lz98G3gk2EwMHFZJiAw2kV+4cSl2AhTVdFnLLNLj4mncanoHc9sWQOkn+jsHASmzcV+tzw
	TsKzUB04ftiRsvAw4lX26mYaeXHvSxlJcCCmMNj8ilgpyLpMgdDYU=
X-Google-Smtp-Source: AGHT+IFr8ZGDsbQ1jjecT4MCwgkorPy4QBHxmEF/lAQfxbGOn7UZnmZA8iyf4tXFUkYAv1yGGE2V0w==
X-Received: by 2002:a17:90b:264a:b0:341:3ea2:b625 with SMTP id 98e67ed59e1d1-34f68b661eamr1796572a91.12.1767769969863;
        Tue, 06 Jan 2026 23:12:49 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fa93ee7sm4057780a91.7.2026.01.06.23.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 23:12:49 -0800 (PST)
Date: Wed, 7 Jan 2026 16:12:44 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <p3xtt4xygqo235c6yuecneot66isu3nvwbnh3oqz4smvzv6wvb@vgvauzche5bn>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
 <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
 <tzppylvpaq7lk4re33h4niofgfwiziibp3jdoos2ofeepxx5yh@sh2doyzze25z>
 <u6dy6oa6ztghy7ozficimubhb2mwppcq6gosupepnn63uu6oq7@qyph3nyq7las>
 <zpbzxfmxy2eflg6hfsfcn273h5bjgyxbpnlem555ln2kab3nga@ucutuf2ywwv6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zpbzxfmxy2eflg6hfsfcn273h5bjgyxbpnlem555ln2kab3nga@ucutuf2ywwv6>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 158C340003
X-Stat-Signature: zw3cyf86eaqwg4t7tn8h5e9jdusre8re
X-Rspam-User: 
X-HE-Tag: 1767769970-804942
X-HE-Meta: U2FsdGVkX19HaMpjbSuI3gNueqk7X/3IR4yfcq4vUN3HXeej1nHSADBX3vX/Bhw7UD21jc0q4irqL5OOFnSn6fxl8hyMcBSDciXkD2dYo6uLzGNOH8qLGjHyxG5BUc3Y7Shsgl+z6vTq72FGceYwnWQ6wQvEy+VsVek8NgjIf6EaA4FNSUCUELLqzqnXiOCpz4qMgXJlGzbysCbbbuMsesTIalHrQB3GolZbm2cfkAAar/lcCNFFdfhnWHRjfuRe7VZf8H3e9nv9a3SmHaNwXRPWbKaxAG1seinF94Xb9F5qXUpZOO2IZKPed0Gmw9RvAyrszQCUBeC8X6CUj/fyiZZf4KyHliYf95OiJkOYACrdEtXxJQ3rodD6Z7LMrqDCS59j9M3xKuJxwY7Khllnp+efAn0TxYRR0HSkhpDqxt/nNypvdMHhQdwDSx/NHJO/wj2eS7AORXTlk8vB4y+4W+wkZOF9CHd/5ZXfZNLLgSjw2fJdap0UzZQ0dg0HBdtm8g8846maS59jgK0F9TLeKpds2sW3QllKYYycVdLq6uhvq12jt5yLCHR248Dzj7WGZOzA/9cWoXsMG3eSEpEh2tCCm5YLovpXHwzfi0DIyYX4RoAF35IYOht1RSEN50W+GtvlDbVMlOjROKBwiAl/ZQdlIg8WQgcM5h/Bk1/szUPf5oZn2ErB4L/HvLm2C0fEhxVdEpuf2mkKqFSShkbmDbn/a8oUU8mexQqC7wik3uJZeznjeduL7k5zofkvxc2Wg+wGgFs6WIQW+Rh1YJwdCDvPLUiQxQtffKbMEbUZ6Eogr5/pnTPcD5+nps2vXGF63D9DFO15QvpOiCHL0Mz133QONR05Bt04gDnPFy0gPUZimHcQjPd8WBdsABs9FTgXtWh2woeg8F2i+g6Ij9Ntq46bDv5UwuJxwx70TVHpSfcmZ19st3wmqas2UlAfLShycJAnjL4hkPaX264HnMk
 Kn5d5Fkc
 eICLmBQ8hhJux0jMINH9fQc9xP5R3igGGwJIyMj/OUuRd2NcR/bnnBkJ1cLUp2Mr5vffN2Q1ygnH+2za4C+tLTW2fhW99/45xY5q/mXbNb436We2UQq4KT8DPm3qpZaOZAanhOI0NXXEgY7Z9xH/Nlqi1q9C9WUnRf4O/guMvV51m+pIhYs9QnL9qVhiT7uVrndHt1pM3C/Ykdc+9QnYJbMtLHYAFAlurjjIyHCEt22XH04QPT5zDtVYbTt0CBH/xYFDsCTzdytvf3zeCQuRIrzRBeBgAR83ixn3KiK0H63ehgSnAA6NlDsCoTN+A+YaC31oJM/2/V7F02EuOGanoS9JfdbaUBAm2AIR5QE4zg47rle8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A correction:

On (26/01/07 14:30), Sergey Senozhatsky wrote:
> > We increase the offset by 8 bytes (ZS_HANDLE_SIZE), but we still copy 48
> > bytes, even though 48 bytes includes both the object and ZS_HANDLE_SIZE.
> > So we end up copying 8 bytes beyond the end of the object, which puts us
> > in the next page which we should not be copying.
> 
> Correct.  We increased it twice: off +8 and mem_len +8.
                                              ^^ class->size (implicit +8)

I tested your patch as is, w/o applying mine.

