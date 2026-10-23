Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4FF606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 20:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=uuoJVEn/
Received: by kanga.kvack.org (Postfix)
	id D8A316B0BEA; Fri, 23 Oct 2026 16:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62526B0BEC; Fri, 23 Oct 2026 16:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52926B0BED; Fri, 23 Oct 2026 16:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90CEF6B0BEA
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:04:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 239094020B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:04:36 +0000 (UTC)
X-FDA: 85354968552.13.BBFF697
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A25E18000D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:04:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="uuoJVEn/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 30L3bagsKCBkHJH33C2GzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--suseendranb.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=30L3bagsKCBkHJH33C2GzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--suseendranb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbUA7/dxhId/TZcdTXpzWvUZm71mXX0zstuxMncKARE=;
	b=u2dnXOTOZHJEdZg+I+T+nhvHIy6DGza21aqZwUdz+IarU/Sfpd4w/jRlYppM1upLQftAry
	U3vyXsZT24fByY5655shCgx90vnrOjSyUur8zr0cO/c2QIAuNV9wEakMCPJ0iB9cOpkqCR
	WGAlhFUoDlgH6kAz/3ujh2lOMjLwg0M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="uuoJVEn/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 30L3bagsKCBkHJH33C2GzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--suseendranb.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=30L3bagsKCBkHJH33C2GzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--suseendranb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785874;
	b=8aw/FUU5j8ff4u4sFjTdKdGONMJUQYQWAT6KSu2TYPjxBibDZHvAUI/305ah59OxB85ekz
	K54PQGoHO25nChUnJ+xNYjtyaZ4nCIwiwZDklJVnuFqm7ckKMHeDSxuV1fRrZeQ5XI+rH/
	DWj+TFgw+vUR3RsP7Y3GQqiVnr2Ij0Q=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a05c820ecbso1797359b3a.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792785873; x=1793390673; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RbUA7/dxhId/TZcdTXpzWvUZm71mXX0zstuxMncKARE=;
        b=uuoJVEn/UHXSKskt9cL80uPI/NmJO0Khr3qUNv1YerqeimuBSzA53++sTTR9WRXmQJ
         wagvGMb354JofhSzx1UAMWgJncdI02+A9DP8DfzkTBVGZu0pdIGcysPNgGdW7Jq/6GwV
         GDynOVtx5ApwGSyVTld7c3sUuKjTNNXM3DtzqqdckEYTCV4XCAhQUITYqMesqSroPkGb
         wKLSjsgGlh4ZFZqgIswMG8T1t8cHRg22QOMG7ph3xV6iLbgVtrsnnlJfAYF52Z65jZOx
         h7XViYhV671W7zpn1SWdS3DEZ9jO/iQig7xwlJEwatxlnHa2lBLdLX5udl/5qcMRLd31
         tEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785873; x=1793390673;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RbUA7/dxhId/TZcdTXpzWvUZm71mXX0zstuxMncKARE=;
        b=adblwqOhYOi2FaSayuzbXMXOnE3eEp752h1q7xG8ZXVXQM43OKBZB1FgvSHFzf4JdT
         3IaLNQsOiFJgV6d0npAq2cFlqpT7yAmho925nwtHo8QelCM3YZJHa2XFV5Ki+HZoA3qX
         Th2cmV3sk07oyMyC0JdUNjLENRUsWxu3WUXBtKTjbyPCgJ2bn36Wao7cydweIOxnVz/4
         602CX4sPF1QQnjnlK7fh69K6auXfRKdk+z0q98X/4cOcLaD7g9LDtdqMO0/OO3YdI+mG
         xP/1c7NqFJAOe9TGl0hJf5k2fMySZb5mHevhqt+JerpXpw4wRjv+cVY77pPTtUGbmzNQ
         8P8A==
X-Forwarded-Encrypted: i=1; AKwUvBxsgxjrXO7rUY5pwQnc4ofDt8dSepD9+2EU9uI+3YMKtOOLZnGN3q30koJKUbnoOvvcu7SAyEH62g==@kvack.org
X-Gm-Message-State: AFq9FYJufos57D7KyYctQyYiv4BEbOKqIiP9RK3Tdnz8NxB2uhlVFYs6
	+cIyG27aDWHlTZpdrFHabru/spLysJec8w5pA6qDoNCIdEfiOII2rP1hUS6N3jeMvZpOg9Fb6AR
	KXC48Ph0YbQEuJh56NTtV6fjasw==
X-Received: from pgbm2-n1.prod.google.com ([2002:a05:6a02:6182:10b0:cc7:52da:b682])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9d4c:b0:3e2:252c:3738 with SMTP id adf61e73a8af0-3e7bfa44be2mr77837637.16.1792785872956;
 Fri, 23 Oct 2026 13:04:32 -0700 (PDT)
Date: Fri, 23 Oct 2026 20:04:26 +0000
In-Reply-To: <20261023102607.7635885be12b0b6e7a5971aa@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022232734.496064-1-suseendranb@google.com> <20261023102607.7635885be12b0b6e7a5971aa@linux-foundation.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261023200426.3865221-1-suseendranb@google.com>
Subject: Re: [PATCH] mm/zswap: validate dlen and normalize comp_ret on
 compression success
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A25E18000D
X-Stat-Signature: 5m9zmdat5bnyzmugd48k3aim9msjnem8
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792785874-531810
X-HE-Meta: U2FsdGVkX18+tfzLkLRvo5+uJJLgwtMIfoqKYPRK2Rf1ii6/DO6Cx+imZUeGoi/ePvycdBgwDFMCBfHEGN22QKk+kBzZ6Kvq7Kxrnt5Hfj5c3gaE9VaiOObWwPfU+OGcRNGhqeNyvGlMTc65bkQeHvz5XE5rCjPjuNL8QzRGu/Uq6hXqEcfY/CP/Eud1HBr2Q4RExIn6YFxAXpb80KShLTpVNkF5BbNE7YQ1qbTYj4g1ylbaAyLTrQZEfP6/ZUbpoyoVXZExkOt+HQD9kupiLa5Fr10giDx8KZPJE25FDVDliG7UIuDdkuu/eXG+mIkQpuziRM6Xx6G4jGFGf/bGC1ucf/MX9cdbB9rEwEK083OmrKzjl+weZ+GPIdUBdyXdr1Ln0jlKC9YwtKlFhjc/PqCVwHquSPP83+kO87RnemDTz9W+Jcf1A021gGuCHtqOioToR0/TqeBsUKXV9HxD1nhgs5NrM+FyW5Eui41vcIRXdCm4b4BM/r0zL43GgytSDtmrnecjJqV9EQQbIfGNfI2XvFqFJbxTbC9HTfqzqFnsGhG+NGZPe2iuJZ4CJ4jxQ6Psl4njt0imax2/beJi3s4aq18q2urlAQJVDYeS6K1di8IPf9yhoJeC2Q8114xIT8jgOHebnKoVJh/hO1DyrEOKa7K/wZa0fPsyK9BFWWJhAD/mrryMpfkrHBgt/nzHsWJiM/0BjLWHXD2WsZyfO37E5ey7u7f44cokFfU5ojjQFE2j4Vux6yFnZz36vTo6SfndJVDuguXtMUPrCM+gVq1UKGrdXK4uAFb27Fx03VSlds9MfDYQsdmz1N0L8LuHIpLhleYhuElMwfkaysUCECEFNelxbc+zAR991xpOqEQNlTPThyfA0oJJ/yKhPFYwBsdtYCuAiT1oaLDnIH3y1aR9EkniP5dnOd1RTyMST4i12BZNcrhmj3QGMCrgo5vF7MfJzj/8SWK6ZQBamQl
 kHEw4+5s
 rAS85V2EXsdStFa7lgjQw0iGo/b/lBVJ4tSnBf2FKGNT5G6YeDMpkF2qC6J8UX4dQSPaCIPAxIh+854Dit9kxH1KhrxN0ZQ+qTgFx+WDkm2zy6R61NEht0wZmZUU6mrhVq/MbZEqA65kAuCgwHD1EDVlTIoU5ri4szJYfBMT0ntWmOGwraMcUeZLVE42cn7s8oc7FTqWNy+gy9EaA8T3PZWyJ97md+X577CcjLSqRKTCkFMdZNuoqNdpmhxkdZILK54DTUtstJZDvi0T2ZdCNaY0wdNDWYQClhDJ23eBO1Tm3gONjT7Q/Je2xyB+fZpSKTEWvfHyOCWKC+9JrMNaOup8PGFYLl2zeDEdhoS+RLQDPDsfGNvuaBycCudwqKjzG/iOmwc7nTKQI2KYGg4mEBhzKSsQkqD2r9I8CNIlZpR1f+UfIAA8rusjWXc/cbgnNdqdQpHum7S9Tk2nbD4f25U0feokc8RpdiJPXz4heuUi9Ll/zePwgspqLS/12jHRreKIgYN7GAhqCzLPzaQ5+glKiA5JYCW1aLsrZfnYf3ryknkcsw+nz1HxJ00zHk0TZ0m1AkBipj4+lVHVw5+cXzEv/bwRSF42HeS7DdrvITzt9ugIbeWWLbASgA61g8T/8gDlHacDIi20Wac6mcWxHprHv3EKOsRoqYfc193CFanppC9NsOqgLSGls+AwmxETvZIR5Ap3nrGRSCemc7bh9UJR0lF//KHQFgJXXDxANK3k98NuKZOYHCPcoEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 10:26:07 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 22 Oct 2026 23:27:33 +0000 Suseendran Bhaskaran <suseendranb@google.com> wrote:
>
> > In zswap_compress(), dlen is only meaningful when compression succeeds
> > (!comp_ret), as compressors do not consistently set req->dlen on error
> > (e.g. zstd, 842, and qat set dlen = 0; lz4, lz4hc, lzo, lzo-rle,
> > deflate, and iaa leave dlen at PAGE_SIZE; hisi_zip sets dlen to the
> > hardware-reported produced bytes).
> >
> > When !comp_ret and dlen == PAGE_SIZE with zswap writeback disabled,
> > zswap_compress() sets comp_ret to -EINVAL instead of -ENOSPC,
> > miscounting the page under reject_compress_fail instead of
> > reject_compress_poor.
> >
> > When !comp_ret, set comp_ret = -ENOSPC if dlen == PAGE_SIZE, or
> > comp_ret = -EINVAL if WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE). This
> > allows simplifying the failure check to 'if (comp_ret)' and dropping
> > the ternary assignment in the writeback-disabled path.
>
> Sounds like we're complexicating core code in order to accommodate
> inconsistent compressor behavior.  Would it be better to
>
> a) design the compressor interface(!)
> b) document it
> c) ensure that all compressors comply with it?
>
> Maintainers may choose to go ahead with this as a backportable
> quickfix, but it all seems to be a bit of a mess in there.

Thank you very much for the review and feedback, Andrew.

I completely agree that clearly defining, documenting, and enforcing a
consistent compressor interface across all implementations is the right
long-term approach. I sent a separate patch that standardizes return
codes on destination buffer overflows [1], but having a well-defined
compressor interface would tighten all gaps.

[1] https://lore.kernel.org/all/20261021205626.3286270-2-suseendranb@google.com/

> Wht you forgot to tell us (please never forget this) is the
> userspace-visible runtime effects of the bug.  Autobot says:
>
> : The userspace-visible effects are limited to corrected zswap
> : statistics and a new warning for invalid compressor results.
> :
> : When compression succeeds but produces exactly PAGE_SIZE bytes, and
> : zswap writeback is disabled, the page is rejected as before. However,
> : reject_compress_poor now increments instead of reject_compress_fail.
> : This makes the debugfs statistics distinguish incompressible pages
> : from actual compressor failures more accurately.
> :
> : A compressor which reports success with a zero or oversized output
> : length will now trigger WARN_ON_ONCE(). Previously, zswap handled
> : these results without a warning. On systems with panic_on_warn
> : enabled, this could cause a kernel panic.
> :
> : There is no intended change to which pages zswap accepts, rejects
> : or stores uncompressed, nor to normal application behavior.
> :
> : I think these runtime effects should be described more prominently
> : in the changelog, particularly the new warning.

Apologies for missing the userspace-visible runtime impact in the commit
description. I will make sure to always include this going forward.
Autobot is spot-on here. I would be happy to send a v2 with an updated
commit message that clearly documents these runtime effects and
behavioral changes.

> My autobot is all worried about the HiSilicon ZIP compressor.
>
> : I think the zswap-side fix is reasonable. On success, dlen should
> : contain the actual output length, and zswap should validate it. On
> : failure, dlen isn't necessarily meaningful, so we should rely on the
> : compressor's error code.
> :
> : Separately, I think we should make the compressors consistently return
> : -ENOSPC when the output buffer is too small. Some currently return
> : -EINVAL, which means reject_compress_fail versus reject_compress_poor
> : will remain inaccurate even with this patch.
> :
> : A compressor which successfully produces exactly PAGE_SIZE bytes
> : should still report success. Deciding that the result isn't worth
> : storing belongs in zswap.
> :
> : One thing worth checking is HiSilicon ZIP's negative-compression
> : status. It is treated as success, with dlen taken from the hardware.
> : Could that produce zero or more than PAGE_SIZE bytes? If so, the new
> : WARN_ON_ONCE() might trigger on ordinary incompressible data.
> :
> : I'd take this fix independently of the compressor cleanup, assuming
> : that last case is safe.

I checked drivers/crypto/hisilicon/zip/zip_crypto.c and the HiSilicon
ZIP hardware status definitions (in Linaro UADK drv/hisi_comp.c), and
this case is safe:

1. In hisi_zip_fill_buf_size(), sqe->input_data_length = a_req->slen and
   sqe->dest_avail_out = a_req->dlen (both PAGE_SIZE in zswap_compress()).

2. When an incompressible page overflows dest_avail_out (PAGE_SIZE), the
   hardware aborts at dest_avail_out and reports status 0x0e
   (ERR_DSTLEN_OUT, insufficient dest_avail_out), not 0x0d (HZIP_NC_ERR).
   In hisi_zip_acomp_cb(), 'status != 0 && status != HZIP_NC_ERR' sets
   err = -EIO (comp_ret != 0), so the !comp_ret branch is not entered.

3. HZIP_NC_ERR (0x0d, negative compression) only occurs when the output
   fits within dest_avail_out (0 < sqe->produced <= dest_avail_out) while
   exceeding input_data_length (i.e. when a caller passes dlen > slen).
   Even if HZIP_NC_ERR occurred with sqe->produced == PAGE_SIZE,
   'if (dlen == PAGE_SIZE)' handles it (comp_ret = -ENOSPC) before the
   'else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))' check.

4. When ctx->fallback is enabled (hisi_zip_fallback_do_work()), it
   delegates to the software deflate/lz4 backend and only updates dlen on
   ret == 0 (0 < dlen <= PAGE_SIZE).

So hisi_zip will not return !comp_ret with dlen == 0 or dlen > PAGE_SIZE
on incompressible pages, and WARN_ON_ONCE() will not trigger on normal
incompressible data.

Please let me know if you would like me to send a v2 with the updated
commit message including the userspace-visible runtime impact.

