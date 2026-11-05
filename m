Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8488606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=g/iSxAqa
Received: by kanga.kvack.org (Postfix)
	id B4AE86B05B5; Thu,  5 Nov 2026 00:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23006B05B6; Thu,  5 Nov 2026 00:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A397D6B05B7; Thu,  5 Nov 2026 00:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 817276B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:23:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4AC5A8660
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:23:51 +0000 (UTC)
X-FDA: 85399923462.10.C761D98
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id C89FA1C0007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:23:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="g/iSxAqa";
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793856229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsGE+zCIXfvkQmpr977qsb3iEFIBRg95jemFmU7wQ5Y=;
	b=78Rz5v0y2C0C7IKz99y8ARnF3DaKaeCktw56GiEBikNPzsiy7XBaKF9vyD7WduvwMzFcEd
	lJPSZWEqsksIMm5sa+I8kFuAbqlalCK7oyH9SBUcTYRSyLMwPY8IAV5LCy8oiMrI+QNeqv
	reU2IRK5hKzaDYHwDiQP/MOKtw5kCfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793856229;
	b=7rW6x1VPsz3vnwss1N7uccdId3tGpvkLY37EatC28tu9DSVd25tFRiH+o4aVNULfmx/uQa
	WInawfSEVBv7k7VOtZDKcrboa6qCWL4Dop5QVf4/e+HHGW7dj5AS+TjEy71X2eCSEgQnU4
	+PVIwRvMImqpHF+DuA7ge8633lYsnig=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="g/iSxAqa";
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-15ea896ddc8so2554173c88.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793856229; x=1794461029; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qsGE+zCIXfvkQmpr977qsb3iEFIBRg95jemFmU7wQ5Y=;
        b=g/iSxAqamorSAZVryhCt+SSSW7ww1G9+KnEza+Yk0gAgKV1newOWj/4pP+z3AaU7lp
         9fbfNk1PYMgsOD+CauawUUKj22OW9AgVIzmdDUnt2YCBn5XIT1uMb7Z7VteX30b09UKl
         1dHEs5UV6/htw0gXo3mcmf8GkvDc3+1YUsykA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793856229; x=1794461029;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qsGE+zCIXfvkQmpr977qsb3iEFIBRg95jemFmU7wQ5Y=;
        b=sW7rpLDf0bpMJmSfqhQkF3Py/l0OUSn6fcO9P+HMtEupAp0NECx/noHc9qjcGP4j6I
         Ej69I2/v1cNsOUNFIOedIHCqudPeniN6M+WZWim+wnQ4dzlDwfoGt82XV7eCKX2ql21T
         /zqg3/CmUUrljnJQReJXt2w/nHZo9dEG6ATCtc3OEC0yPZkwLnwPYBC70d6F2MX/t4fq
         gYAwdL+KM8OQD7453or9hNqA61pwBJnzHweB9Pih6IjfSJipXNSibUeOxb/EF9sCF+gt
         6vT9Te9BakWvmOqJJkAo18+03ih9F5bUOV37/KB/slz7KZAZRe4ZlQKobpYNR+UifEe9
         1xlA==
X-Forwarded-Encrypted: i=1; AKwUvByISJ1k1fNPu4mFZqLndpn8EQdlwFZK5GYFCOAz1O9kd1W7G4Xnf2u6r9CqNZmJgSiuPOKEaWwwXA==@kvack.org
X-Gm-Message-State: APuU4Z954TI61G2x+AUKdFIFaYi/lJ7vXFsEBlqlg6etHnrYJRkb3yQp
	rHfGc2s+4srQpNLlA+KySo1ly3h/djpdJ9P6JHyoRIdvhOx+4KJIodCXVyJt8L5fKA==
X-Gm-Gg: AYBFou1uKdja4oSKwyxMmt67VCA3OuWqRI/AQ7wG6wsYTz59lu8dK/pF8h0zsN+DTfQ
	R+2daX0LDb6gvWSiY6wjAwQ6nSlQ6XgdMC6tHfpXlAlXUiHtlIh5soJ7+4QzfhH9rROnsCzcRzt
	dIqaC2Bm4RTd+9Za/bYdfOWUJ64nV0qf3/aSODLVev5SgYB0Wh4qznTDroJdx2oGu8eTWC/LomB
	rORsx+AQEZYAxKo3XXu/mzwG5nDspYWPtCZCCoF9r1v9ME4pTwsU1iTpCA5HohhRjgMUyUvIN17
	bEwHwWQJ1VTVaj+xtTDOaGptyNvb8+7wwd4aMbiHYLezNwoUVMVcjJ0qKi45aKva6h36361q30g
	cl2s5yOuQn5Wu3mp5Ly4oCaq178Q+B+9AxS+OBvZma7/t6o/joDiiWVqgSBTl3wxB+WKVK8o99Q
	2zFKPp5rVlLcLGVDAH+yaeCs0UCtEsiRfsz5L+ZJwT0dhdJE3v3bRUFVPNxKKVnGYtP35ql3I+Q
	UlLlDiPfoVFhY7yEw1vS0zh0EnxyEk3BHGdVgYeDxGrpe66sdHflqEjJsi8v7p1s7HyFxEo8mtS
	vQ+h/LSQlx30TpfaNPLk4FhSl3+1EKT3XX+97AFbI5/SfeBJB83g6fCgVHOSbplpLrwH
X-Received: by 2002:a05:7022:fc03:b0:1b2:46ee:4cc1 with SMTP id a92af1059eb24-1b246ee5347mr4936175c88.43.1793856228364;
        Wed, 04 Nov 2026 21:23:48 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c463e9sm13218160c88.14.2026.11.04.21.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:23:47 -0800 (PST)
Date: Thu, 5 Nov 2026 14:23:43 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Jenhao Chen <jenhaochen@google.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, minchan@google.com, liumartin@google.com, 
	benwei@google.com
Subject: Re: [PATCH] mm/zsmalloc: inline obj_malloc() and obj_free()
Message-ID: <auwR7gnuLsF0lpmG@google.com>
References: <20261030121700.260975-1-jenhaochen@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030121700.260975-1-jenhaochen@google.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: buwjiypbndmnqaj6een86nihgpyzndat
X-Rspamd-Queue-Id: C89FA1C0007
X-Rspam-User: 
X-HE-Tag: 1793856229-239581
X-HE-Meta: U2FsdGVkX1+cdx0sX5Rufk9wVOG5lRCRGFYSp9LGmypw2MoDR3Ku8+Z5vTvtwzBvfNTkC3GbDdUiz+l0DXufo7H+CJjhZPI+/2PHIfy8wougxAMaikOFNsWt04wquI3zpVgvW3ZiqcRnrIEGmfTa4QR8qwH99glR9SkG0ZeBcAZYWHEGF+lI8MsFHTnOC9plgyAmA+Zky1Fc708PZOfjEne8KrPLFv0QGVvMu1Pjeams3Mgp1fphaLAl44Orx8PkntNAwb5cvyYsieFNJ1iXok030dgmHWcZgAbFoOSAiyvLNARRfW/UP+Q67zs5t+IexY0bzAeP2CSNO1lMo+kewTtb9husq79B7Su78MQuIfLCrdMW6rrFouUvvZ3BUxf1pSXCi8gAznj2YFLejOci63odo4XBRdC1gYHTqNaNQp4i12dB2iVGWldIh/smCeG9lv/TXbl37yIDRG2xIBZSKwiVsOJPCfwIHNGsfMaJ4ZptjBnrcRWQgjwCr/ca8ruYdCffgR7ENAvjJBODtuu2ZWyUCty9u12SSvxxI7+kDSKhmR2TmdHoaASp9VmbuWwX/6CT3rN/P9+5vDFK9CitXCMjKq3JAz8nouXyO7BCqxFPp+aX1cWcRuTzZKb5vSi+xjXKgS5zbq7SjKExHlgK7qitE0JUhueLQfLFdw7vpPx2MCLGo3Pf6htKw7p9wUXU46blM86FTVRguxw1qbaTRi3oGfejpbX8b0nRsm3aSKhJ8zivVeNprTYWC3p5FLuZFI5Qz4pUt6NrmO1xigHuO5GWRCK5y2/HSZyx7pjbokR+SQuA4TnF50nHwsrLA5S4V1oFvUh8fNOMLUhXVRqC7yn6nQg4KE6SXw42kKMYMSigWGRRoc43c+lCtwEgqohUwxpdeorTsXvKIIBLRu/R6eB5F/qDgGK5hQeUyNRydzrYWFw71rO368GSCe5q5EF1XmUswoD4XSAmK8pS5WD
 W/hsHS0k
 tSEjWDGI4+/b0T8s9aS64s0PCBj/9pbWCRProCCdOdeHnct8N0P9SmMxaSBWSdNssV5Jy/7ioX5dkHsKFI3n2bIPUaDIfHip06za9CZA7X0YxfEmBSpB+R5kDMKOMIHa8hcmEKsGt/881bWiptJcQk8FykFhUzwxlArPObK+2Il3kiTtreWVlXDY1jziVXBt2NrvRoZRvtwHvU0ragfWVkgs/RhiZW0EYzAXVoqmYVpnd+OmjLbBnRg6X8yXYbdNy5OnJu2lPOzCdvSsuOrTyZ65IupXrGaPZdhG6kW+gu8MI2OT+7nwxUjJpm7iypmetMjV8HqDZIP4HsHME1Hkxrmni2hehkciPAaNme+Di360Yh5Kt5mYjgidy3+jmNuSLSs4pELkMeOPpwe8HZK7iazKQfmRdjMkz5t1FRTO4IbDHovsX0dOjyiROPQBF14QeOafU0MIw16g+0Fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/30 12:17), Jenhao Chen wrote:
> In zs_malloc(), the fast path (if (likely(zspage))) allocates from an
> existing zspage via obj_malloc(), while the slow path allocates a new
> zspage via alloc_zspage().
> 
> Because obj_malloc() has three call sites across zs_malloc() and
> migrate_zspage(), Clang at -O2 leaves obj_malloc() out-of-line, adding a
> function call on every fast-path allocation. Conversely, because the
> 362-instruction slow-path alloc_zspage() is static with a single caller,
> single-caller inlining under CONFIG_AUTOFDO_CLANG (e.g. with
> CONFIG_ZSMALLOC=m) inlines alloc_zspage() into zs_malloc(), growing it
> from 254 to 691 instructions.
> 
> Mark obj_malloc() and obj_free() __always_inline and mark alloc_zspage()
> noinline to keep the fast path inline and the slow-path page allocation
> out-of-line.

I suppose there is performance benefit?

I guess I don't mind in principle, one thing to note is that this conflicts
with [1].

[1] https://lore.kernel.org/linux-kernel/20261105044752.1997895-1-senozhatsky@chromium.org

