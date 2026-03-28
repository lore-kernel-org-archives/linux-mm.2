Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B23E210F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2279E6B008C; Sat, 28 Mar 2026 13:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8586B0095; Sat, 28 Mar 2026 13:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1154C6B0096; Sat, 28 Mar 2026 13:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3F5B6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:44:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C1CF570BC
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:44:14 +0000 (UTC)
X-FDA: 84596195628.06.8914C07
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id AEFA11C0003
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:44:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fbU+1qai;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774719852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bf6/8DHJq7rfodeWx/m51AbxPYvL+rrJXvXUW3u7bJo=;
	b=59HMy8aIrAne/70Ej7rPsvZWsnE5IZNZ3VKAF4vvOjCvApyvsT/B76bkoueLMln4S8IsmL
	f+b653uat1aghSYVOTMVrV232WhD27RqO6ZVOxxYYmY4pm7SMhrzE8tlaS3oiHuwyjuzjg
	1sJyAXp59iTucujOo1gZ+SRajWCU0VM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774719852; a=rsa-sha256;
	cv=none;
	b=h0hzdx+3G9l3MYetkpWYM7VxcTby6WEgfPEnZcDN6vwOZ52RggssmO3Xs7Iy6c1e92HFnh
	eDbn8U4QNIDj5pI2mRHMS1JKUGoQqmjUcGg/8znlagzFqz2W6nFMof1p8uIPENK7J9+YB2
	rWUjreVn1lE/2Iihu5x/OUEzpsFeklk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fbU+1qai;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82c20b9fb15so1474043b3a.3
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 10:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774719851; x=1775324651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bf6/8DHJq7rfodeWx/m51AbxPYvL+rrJXvXUW3u7bJo=;
        b=fbU+1qaiWUubcdEyGcSPQpeSXVcMCIuyBgIHQEWkyplsYTycvalUr7Kd+lyL2cVWVI
         c3T0zg78HQ0C+9dHfG4puQtcEmYZ9CI+GkU9xeJx2FjbMw04jPgnBPWrntiH6XEtSSoq
         adUMhF0AEHCxOaKCQtrt5O6G+wGbD6TLASsa3iBkdyobO2cDhlJI05DKnWnS19CAM6qh
         o4CdWwMacgjFd8nmJEVnjwDRj9z2oE3r3PHoHAXVPtazP4tvFw9aDBqsr7/ne1oPBexa
         Vv+l/cjo41Uq4/uXVq1tqFoCKxtg30e006xWt/0avMZhhSQr3qN8ACq+pcIxhB35iYRH
         khCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774719851; x=1775324651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bf6/8DHJq7rfodeWx/m51AbxPYvL+rrJXvXUW3u7bJo=;
        b=OOD2UrOvUIwndQm2b+yEpbRMFAv6zchBugJQ5dyRAsTDaOROgyWgsWgSgp/Lo4Suwd
         1DuSMBwGFXVLaxNvtLfz++0n0gekfZgGLnK7BKoMkFxkao0mjDbXtRG9D1VGRX2QJxL4
         BpdQNAFoLRSHAICW+cazJsuzIOt02xWe74cEjszP04NvtOIMkUKBMQalKg5iW12Gl6ac
         9lFimIwU+9TM7xHZGlhT+z0OINX1TxGDW9avJsFOH6G3kOQ5DMFuRJdS4R78GKa0F1a6
         ZxdiCWzP50+EKURnx7Y6WftCoe+FPM7R/gWrmWi5CvdOBXVFaBpZwzm8jEPKpEUzELLi
         trqw==
X-Forwarded-Encrypted: i=1; AJvYcCULFbRNRHRfYY5wViP6vqlTflx7/NZJ2BQ+8GTiJeipyngaBklWecRu+AATwrUMeSBcgI3q41s3Yg==@kvack.org
X-Gm-Message-State: AOJu0YwHUbYq++MEkTGfSsK4GeZZWQLYU5+IPwkmEIxNcGVaVQlOx9rY
	hw5w4IlNFjKcK93jg51EQzNh/xgTYEE+SyMct9QxsZlQaLkJYzl4ACRc
X-Gm-Gg: ATEYQzzvweTEfoCMeWDSKEdTXfJdBeU7c+DmhIg67ZrzRocpThBBVFcSfd5paK14K4l
	3Q1njkN0UZLi1nOB3bXy0bkGvvahwYmYARqQmmmc62ogXw3KIfPIeTQ8fBJ8ya4+zp4YjhgP5Iq
	BWq7NgGUYXgXBFyrIcRNsc1OFF5Z9yCpfwPpViDeC/uP1lRbYaRdbWEkk1poDkE0B1iEWDk/NnU
	+Th7L/kTXNfxr+N4FELP12ddUx59iVDELEDp6NV8f8iHequ3W0LgEgIyKnSs7D4IVpisIFrG25v
	/Jx6gZHMSs6OSU0RAditfGOekkwb73a4Sty3xAYjZo8DT9GK9ZsHpgqVUNSUWVex5ypVgQsrQ1P
	uZ+sLKhvxTC8kr4VKlISBfYOxCzbhXjr5GV7Eb4G9vAUNIjD6fFk6wjMwyFd65YfxOf4jVGN+7S
	mcs5Mk12wYrGMSnZJ+TSNKaE01Bee98zs4T8o0kfJ1C/VHGPDGpdE=
X-Received: by 2002:a05:6a00:21cb:b0:82c:651f:3385 with SMTP id d2e1a72fcca58-82c9605d217mr6721194b3a.34.1774719851366;
        Sat, 28 Mar 2026 10:44:11 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca8464b75sm2726877b3a.16.2026.03.28.10.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 10:44:11 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sun, 29 Mar 2026 01:44:09 +0800
Message-ID: <20260328174409.6786-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328141323.10540-1-sj@kernel.org>
References: <20260328141323.10540-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AEFA11C0003
X-Stat-Signature: w9gctqmdkmjozsx45cjakt4pftgsx54q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774719852-59014
X-HE-Meta: U2FsdGVkX195aYwSFmh3+xwYb3HpI+DjO21o/f4OTdVfemsZE46anAXb11+WuQizfaBJAlnySqAwAzvFNuZ1NVmS2wF0gyjr5D3bZ/ExXkK6/Amd+kR/GIdHI7mzM38KQ2OSAAOqYpDtgNJzz9RQb7z581qRzHr7S4Fdrko/TmL/Iq8FThXg+q360iFfE2Tm0twkCCgHo6QAXNQ881OHCVmM37sR5u5+QpDlhmiHHYVRtAeSAOvH1pRu4yoCmrm5lKhZSLjkPhkpaLuH7bztoWsA5q8sXAhzS7hUzUh4hzPGcPLk9eivlbjX0I0eGpQa1kmhGmhTaVduKSN2lRuOj2mJQjxlTp/PoWgq5VVE15pcZRdQCdEAeBTbe+sIS5KjitCaO9W6a4aGeOqR8mK57m7stoOBi7KlW8YNWbmz1govJjI76PnO85gRhcRK/PoYfC8F0rKACTXJWK/l7cd+Xe61LKDm7LvDTbCMLFguQxBo7Gd/rPpBREs12kJCF80Hf59He5Y52ypo4v+V8+37owZmBFscGrmlecZtqTHMfu9jGVRyLo7O3Ery6eepCJr3JmPfYxFh2pCAG2GYJ0k4gqigUpwMjWQrtFssX2Xw389RJO2SwEEm8jMTVZlwkEbgZ8syG0x40qrO5zS++K5hbmbsnj8yhVJ9MR9et+z3AzpUnsouCM4IsyGRXX3aeVS/HHb4x481JwiBsSFcYH3fYeCjy0mCP0XU9pqykfEU9xFASruWx7oHN0xmTxGWN9XCh+mAA237uFFzneVCT+2Q2mnCOdY91LKCn3+NUjRuxMRVdLXG0fNIXNWeWrUt5dctREHcY3QdzQzUuuP/v6ZQehxIPu6DNk1vzlDcORAAApzN5EhNnT4P9iRkcR7W5ZHeTPCWXjhHJ92jTlPcCXnLFS3UxrecWIaDJQ4k4V/p3ZIeGYE5NfzSax2Q90b/AUoNp9/B1B/IbmBMwXzZ6yC
 LjZIV0aW
 xtfiHBZNUsCgFbSkpkbZYcgnpmawVATTGT45Ds1u8mn4Q70S1fZRN4Vno3iTipDYw6JV1KN1v19KnLZkDLDfi216x0gUjr5nBd9s9gg/nxJvjxwddPcOl7umHVvrTjMcGz5JPgm01tqRW4cKBH0FuHWW+PTYOj06RLNxCTv01KhfCKSfSyFp3+cvk5MDVOnD8kXEysK16TbrJ+6u10MwwaidRFLFKRyKyzSlHqAeaGGLZgHpHrNsypLh5AxEWmuRr7SRlnJQsufT/RyY9qhqAvl++neehJACCX3pn4PvNS7t/xEuKk/t3DIOELvgsUdis5h27V+56GwXAKx7yVsFXvu+hRkuSPBKSse7kZqimDbEbfboA59NqtY/eFxZnVDKPcpSKp8Zem2Q36EqqhKaBlxAk6+5bbxPYfjL1zWqreFIrbx5sdMr6qNU2O4CJkEYiOzd9oZ/Aa1rIdDhiaOQeFPBlQapg3KVMDcORXJ3lZC0SK6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 07:13:23 -0700 SeongJae Park <sj@kernel.org> wrote:

> > On Sat, 28 Mar 2026 10:26:51 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> >
> > > [...]
> > > - Would a lightweight fix be acceptable? For example, performing
> > >   validation at the very beginning of damon_commit_ctx(), and returning
> > >   -EINVAL before setting 'maybe_corrupted' to true. Since no
> > >   modifications to 'dst' would have occurred, kdamond could safely
> > >   continue with its old configuration.
> > 
> > I suggested you to try something similar to what DAMON_SYSFS is doing.  But I
> > didn't get your response to the idea yet.  Could you please let me know what do
> > you think about the approach?
> 
> I was thinking this one more time.  So you want to ensure DAMON_RECLAIM and
> DAMON_LRU_SORT not passing wrong addr_unit to damon_commit_ctx(), right?  And
> that's required because exisitng inputs validations of DAMON_RECLAIM and
> DAMON_LRU_SORT are not checking that.  Why don't you add the just one more
> check there?

Apologize for the confusion in my previous explanation. To clarify, my
proposal was indeed focused on implementing a lightweight fix directly
within damon_commit_ctx(), rather than adding separate checks in
DAMON_RECLAIM and DAMON_LRU_SORT.

The goal is to safely handle the context state transition. Specifically,
I want to validate inputs before marking the context as potentially
corrupted. Here are two approaches to achieve this:

Option 1 - Using a label for cleanup:

    damon_commit_ctx(...)
    {
        err = 0;

        dst->maybe_corrupted = true;
        if (...) {
            err = -EINVAL;
            goto out_reset;
        }

        ... other code ...

    out_reset:
        dst->maybe_corrupted = false;
        return err;
    }

Option 2 - Deferring the 'maybe_corrupted' assignment:

    damon_commit_ctx(...)
    {
        err = 0;

        if (...)
            return -EINVAL;

        /*
         * Only mark as pontentially corrupted once
         * we start modifying dst.
         */
        dst->maybe_corrupted = true;

        ... other code ...
    }

I think Option 2 is cleaner as it avoids unnecessary state flipping.

> 
> I remember I was saying this kind of change would be a kind of whack-a-mole and
> therefore prefer DAMON_SYSFS type damon_commit_ctx() based checking.  But
> that's not a small change.  Just adding yet another simple check on existing
> validation logic should be fine and small.
>
> [...]

Best regards,
Rui Yan

