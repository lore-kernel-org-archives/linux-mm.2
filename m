Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96226606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=LqouTKhw
Received: by kanga.kvack.org (Postfix)
	id 895D66B07B5; Wed, 21 Oct 2026 16:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C576B07B6; Wed, 21 Oct 2026 16:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C9C6B07B7; Wed, 21 Oct 2026 16:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44C326B07B5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:57:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B696A0694
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:57:22 +0000 (UTC)
X-FDA: 85347843924.26.3F40A8F
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf15.hostedemail.com (Postfix) with ESMTP id B12A4A000F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:57:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LqouTKhw;
	spf=pass (imf15.hostedemail.com: domain of 3LyfZagsKCEAuwuggpftcpdiqqing.eqonkpwz-oomxcem.qti@flex--suseendranb.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3LyfZagsKCEAuwuggpftcpdiqqing.eqonkpwz-oomxcem.qti@flex--suseendranb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792616240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svpaPlWQ3kiRUSxvrVjWiPIzFOlTHujdEaUrpizU6Tg=;
	b=lTRIc1/ld+bQ588rmIP+wX4fP2YllHLFhIODF2UpfqPqxniwyeVRLp6f6u09wUh+G+yx9E
	jABYn7vAPh1WHyNb6GSL7YZ6r0ZlQbY58KiWf9dm3sV60ctnuFi6i+YEaDcn0ETAYkWjI4
	Jh5bBP974hxigGqQg2Yebv8LdB3F1E8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792616240;
	b=Jt07tbZ1pb39gz824+/2UhOF8V4DBIO8du13kelgRbn8UH/q1va6kpTjP34yQhDrN/v8tP
	r1YBSyoR02oySrXBxVvq6v55225cOAnwVT1B3/k7/liFqco/LOfGb+ORJdRX6wsL24utyI
	6g2fqleHdEWD8YuDAa/Yh5zB4lRNkGg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LqouTKhw;
	spf=pass (imf15.hostedemail.com: domain of 3LyfZagsKCEAuwuggpftcpdiqqing.eqonkpwz-oomxcem.qti@flex--suseendranb.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3LyfZagsKCEAuwuggpftcpdiqqing.eqonkpwz-oomxcem.qti@flex--suseendranb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a0619b1fe5so792517b3a.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792616240; x=1793221040; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=svpaPlWQ3kiRUSxvrVjWiPIzFOlTHujdEaUrpizU6Tg=;
        b=LqouTKhwBt8VTYBOw3rFNhS60ubJ7SURGeM7CICJyJCmccI/SADlonVe2kgwo9N/Xr
         4pwcASmGC3TMIT3aBvKML9/n23Q+IOTKnqg2o8jh1ZXT2HsF2ZWZRaMHVBkq+Le6n318
         JT6z8s8mObEIn7Tud0CLfewX1hxblRnJWkw1SSgjtV9ATUS4GJ483AEPjGZ9+HKKuysn
         iUFMo6pVDvydLeqdIv5RxLxRqIKXHztRGgr8rjKA5aSXZH7ATCEV5CFmyy4yQk3LhiJO
         E6K/HRulrS0z09B8SUnktkabay3Gu5jSMUGeNd+FjEFsYWtMoTd9gWuZOF9oo5FKRy7s
         4Xtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792616240; x=1793221040;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=svpaPlWQ3kiRUSxvrVjWiPIzFOlTHujdEaUrpizU6Tg=;
        b=H6eADL1UPDCHgSUfZaO3DDYfNLFSd0qtd4FfeR1faLpiPXiO7QGUiHWsst0erLhieG
         P9wLVNPeZbRCi1OxcFzhvv/QqiQ5yVoHAGSqgmYawfMMt2HhK5uJ+PVw9zbFviyNQkEq
         Vl0dY7Bnott38sKsdHovYVyt/nHodnXndgRKPCjfhXYRdEiIPtEeMlBLj4IFmJosMZ1X
         39Hy8Bs/pWw+c2ErEyXqDxNLQvc5BkcYGwlLSK7/YrzCvgZtFkBI1keBQO+Xd4zcnt8c
         spXFCgdmsCq/jA20lTLzNzVoEhxg0MWN8hXeRbmu12D69/4hBtiaUAYE44W5dwhYS/CK
         t7cw==
X-Forwarded-Encrypted: i=1; AKwUvBylrRyat5yDf7Wql4NSlkBuzF1PQBV/+euqj72kHDU8eMPzWtYaOe2EJGgGGUvSWrZbeZMDCl/bjA==@kvack.org
X-Gm-Message-State: AFq9FYJVzuEC9CTF5L8UM/1jJiB2OgrEU2m3+7AjO5idF8884wSzgYEj
	SWGp2nXfBX6mJBDsE21IqJyvZxB/1Vkpv8+tKVQIZYS8HiJHQUo8KHZC1oy/eaBJF6T9kxS3+jW
	lqfqsmjEWKCWL4JtbX28vfg1FZw==
X-Received: from pffl12-n2.prod.google.com ([2002:a05:6a00:c34c:20b0:8a0:9000:c7a4])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e93:b0:8a0:3ed7:93a2 with SMTP id d2e1a72fcca58-8a089f8b366mr2376676b3a.52.1792616239453;
 Wed, 21 Oct 2026 13:57:19 -0700 (PDT)
Date: Wed, 21 Oct 2026 20:56:25 +0000
In-Reply-To: <20261021205626.3286270-1-suseendranb@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021205626.3286270-2-suseendranb@google.com>
Subject: [PATCH 1/2] crypto: return -ENOSPC on compression destination overflow
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suseendran Bhaskaran <suseendranb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B12A4A000F
X-Stat-Signature: wto67xcrs8x1xuyryi7kjj989f8uhhzh
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792616240-648782
X-HE-Meta: U2FsdGVkX1/pBRZmzHJXvUB+5xn1+UZmU3JDAMN/YZinmnwWGRolW0pri6ZbPyTuJ7TyIzm1GMPt4klkgNyNlLzlEZrZwDmXT+/e70gfFuvq7AeRHKOEUj9Uze/ecI0mp1hdni3OnyaCLXfBrJ94lIbqEeSTfVceh5xUn4mERFRcNZe78HP+/SoklyRvJanmJj4VmsKdHJA2bQcVhoSj351FWjNk3T2YFlYcderUr3PMTYTUe8F525azBb1lX6vYtnYfzFjTTamiP54YIjxgmFS1MJREQL1HLu+hP5hnkRU1g+b1wxHJ4qQu9sLF4HeA6fI2bnpmmW326ukXiDFlFQ8PKgCGMU+RML4sKBEn+rQyF6Opfz0+wX++/trqQ2jiGz9gkZwvu2lXtX4CAIOBrOOuyBIdbUn3VysFI5jWuo8eOwOlzZ/4o0KfW2Juy8Dt9kZ+DoLUBIK+JX7yziMOySArr3iU9m0pmAyntxtELogUQhh9AUx7r4LxznZKL0dPS4DVdc2U8sdFMnp+9Z2SJqWcBDvS3lbFMSUmskd48k8vEWZfyjTk0rP21IWHEHBeWgPJPN3h5xhe//IA50MWD2FcqTXZTsFYBEjJCfW6AdIMFXxlQf5t5JARXzf1hI1Jd25CvkMWdmpiKyyRpEU0bq859/fIXubh8rn5Eg4Kq0AGIRyFzzms2JeSyWoVyy+OyaqHUAkiXYo0mja24/zVHa9iF0xZc5VvhEQukM7ZskQwjlWEqGyEro8kEvaP5QCC1/uZ0lABlOG3q5+LpaqAz/au6P9791HdcGjsgDQacPDqjbm/5BFI0J3z/S8c3NtoVGsL4tZ8tFtX0TrSWsFGvFHc/gWR/Onu67Q1/F/NBkssL2zbT52JYQuBEZ2DDrN5un4QQs5eglx8d7a3JC9rySQzsGfOn9t4oGPXWNDny9mFh+1mkeEUnn4kXUyfkCcz0mkOntPN5zxzuLBXCi3
 bTCmWqsS
 8MSU5xWuTFjyiH4HnhuK7FinW7qrKRa602WxOziz1Fs4zexcdewxRkkhuy556Ne7VXjyhLWXO+EQSoNxlJ2yr6U3IiuDLlCsmvWUmaGEsJrMbUUvPPlWbyWx7WA1M6yvlGor/IEvJMqCpOwsel91IqkqRl8e2OJgWtPOjFPMd8OwUKm9tBXn8SDX3WwnEVAW88Ivc6mpLW3vOqF0nYfIriejI2sG8gxlCqQEFUVAqwrgiOGWxQxPeGOnJeAniM63d3zR44Y21YkxKuTsIv6hrewdRm+p5roGLwpZGrHEIDKRludS5rN+Y295Ws0TsyWS0obGdHZUXNYOeOmanY4K4v2j2Tg6IvCElqBjeKPY1otgDjHfbHfnLl9lbhOXRKMdk7RXQD0XdRwGGalRTXBRwG/ueo8UdytCVkjbCgHuwAfu4HBLtsq4zniFX83aQU1vNM568XczUcKRfpqPHlQRFAChcGgQavZyXykIfxVKoF1tWxYzApVRAcMCARuFSFDFqdtgBVwHb1jyyz/KpLzo8vjUKz2ItyK0QgGwVDrw+fibhxdgFlwwpW83+HH8BFQkQ2TYJ0mUcBj3a5l3gH7DMjms1yAikNcmK+6gE7v3KhXyY7WCzP3wqRh6x3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In the acomp/scomp compression interface, callers pass a bounded
destination buffer and rely on the return code to distinguish a
destination buffer overflow (incompressible input) from genuine
compressor failures (such as invalid parameters, uninitialized state, or
hardware errors).

While the multi-segment streaming path in zstd_compress(),
crypto/deflate.c, and lib/842/842_compress.c returns -ENOSPC when the
destination buffer runs out of space, the single-buffer path
zstd_compress_one() (taken when input and output are contiguous single
pages, such as in zswap) as well as lz4, lz4hc, lzo, and lzo-rle return
-EINVAL instead of -ENOSPC on destination buffer overflow.

For users such as zswap, which reduced its per-CPU compression buffer to
a single page in commit 0b1bf60c324a ("mm/zswap: reduce the size of the
compression buffer to a single page"), incompressible pages typically
overflow the PAGE_SIZE destination buffer due to compressor header/token
overhead. Because these compressors return -EINVAL rather than -ENOSPC,
zswap cannot distinguish a destination buffer overflow from a compressor
failure, causing broken debugfs error accounting (reject_compress_fail
vs. reject_compress_poor) or masking real compressor errors.

Update zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to return
-ENOSPC when the compressed output overflows the destination buffer,
matching the streaming path in zstd_compress(), deflate, and 842.

Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
---
 crypto/lz4.c     | 2 +-
 crypto/lz4hc.c   | 2 +-
 crypto/lzo-rle.c | 2 +-
 crypto/lzo.c     | 2 +-
 crypto/zstd.c    | 5 ++++-
 5 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 57b713516aef..c37e29afc831 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -35,7 +35,7 @@ static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
 		slen, *dlen, ctx);
 
 	if (!out_len)
-		return -EINVAL;
+		return -ENOSPC;
 
 	*dlen = out_len;
 	return 0;
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index bb84f8a68cb5..3098466eb72a 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -33,7 +33,7 @@ static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
 		*dlen, LZ4HC_DEFAULT_CLEVEL, ctx);
 
 	if (!out_len)
-		return -EINVAL;
+		return -ENOSPC;
 
 	*dlen = out_len;
 	return 0;
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index 794e7ec49536..483327873efd 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -34,7 +34,7 @@ static int __lzorle_compress(const u8 *src, unsigned int slen,
 	err = lzorle1x_1_compress_safe(src, slen, dst, &tmp_len, ctx);
 
 	if (err != LZO_E_OK)
-		return -EINVAL;
+		return err == LZO_E_OUTPUT_OVERRUN ? -ENOSPC : -EINVAL;
 
 	*dlen = tmp_len;
 	return 0;
diff --git a/crypto/lzo.c b/crypto/lzo.c
index d43242b24b4e..378b491b0cbd 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -34,7 +34,7 @@ static int __lzo_compress(const u8 *src, unsigned int slen,
 	err = lzo1x_1_compress_safe(src, slen, dst, &tmp_len, ctx);
 
 	if (err != LZO_E_OK)
-		return -EINVAL;
+		return err == LZO_E_OUTPUT_OVERRUN ? -ENOSPC : -EINVAL;
 
 	*dlen = tmp_len;
 	return 0;
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 556f5d2bdd5f..7fafbdc19fd9 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -86,8 +86,11 @@ static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 
 	out_len = zstd_compress_cctx(ctx->cctx, dst, req->dlen, src, req->slen,
 				     &ctx->params);
-	if (zstd_is_error(out_len))
+	if (zstd_is_error(out_len)) {
+		if (zstd_get_error_code(out_len) == ZSTD_error_dstSize_tooSmall)
+			return -ENOSPC;
 		return -EINVAL;
+	}
 
 	*dlen = out_len;
 
-- 
2.56.0.218.g1ec904b173-goog


