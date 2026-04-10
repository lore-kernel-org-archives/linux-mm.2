Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78BBF44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0E56B00AF; Fri, 10 Apr 2026 08:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282696B00B1; Fri, 10 Apr 2026 08:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A346B00B2; Fri, 10 Apr 2026 08:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00E576B00AF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5A228BC57
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:37 +0000 (UTC)
X-FDA: 84642551994.20.BA5DD70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2EC9240014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kdLSbwwL;
	spf=pass (imf04.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823576; a=rsa-sha256;
	cv=none;
	b=yuOcR4q20Cz8DF0YVY6dXtM7+zrssHXpLo+BsL433JhBfVk2SOhEvKrYUpuW6j/sdUKbl0
	qER6jS2o0Lj9PdgIPfeNEYuSFnCgn3jKe6lVwZOJWaTVVyO9XGKGdOeArHpZ6yUw6a98FC
	0xgBezz/7YbufOvdFlZigH29AOkmKMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=nAtajafR3BGugPFTQaw0hsS1PwnKW5jZr3s/Jt7L67s=;
	b=jSzx4MgriA88GX88iQjbImkpjbno9VRMLlZPk8bbN57OfX1Bibu70IkOseWQ550NlipNm2
	oX9oDJHrGJS3v3FGkgodr9F0O00LJCm/rQKmcx5iEKHsWvki36uV+TcUAHEbpmF7k5zZDz
	wcfUqrnAEaM8HJn5pYpzPB7iRHouLAQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kdLSbwwL;
	spf=pass (imf04.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E85B4415B;
	Fri, 10 Apr 2026 12:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D535C19421;
	Fri, 10 Apr 2026 12:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823575;
	bh=GB9a/XQKSHIwV9FYvefMOZoOdepkVaVbWcUyHQeAJMw=;
	h=Date:From:To:Cc:Subject:References:From;
	b=kdLSbwwLxIuQWDxnaQ43x3JS9cXZHSMpULEhhU8ID9ECY5jS+n7m20CMk0YroM4U5
	 D4FjOptptOJeolxHIofJ3rTeQ/ALPjLpvnJ7Qi7NqzIwHDqURUXi9DJGGx8dZS+lLk
	 JCAzGIYvaKballV64My3qHcmSE8ptIN1eu7xnjzlOO9PgVdkDRLJV0RvV58tiiKr4i
	 bv+wJwmXD1eqFR2U5N9wMLLyoNfqxlEArSV4W94QZ6qgCudbzRKlUn/CHtSVarPoCX
	 xb06JWRkDGSiFGx6qUkcv+KUlCb5xHLy85m3KWHYpSlfnAmYw64l8Tsoi4lMULg/pB
	 WwpH4H0qB6HQQ==
Date: Fri, 10 Apr 2026 14:19:31 +0200
Message-ID: <20260410120318.454577282@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 13/38] crypto: tcrypt: Replace get_cycles() with ktime_get()
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2EC9240014
X-Stat-Signature: xhdy6pum67o1ag8mwi19w48bhkxafsdc
X-HE-Tag: 1775823576-14876
X-HE-Meta: U2FsdGVkX1/Bek/+/eLek85YbncZqV3AQz6wmm/QyYkgDmhNhFtsfi8AgYBKdVCD1h+qkouiCwEsln2ubCCvNSHgy+EfIwqbhpbJ0mVOZhby06oLCNYQDORVBQBLRh6KvbwlOX3sTIA7y4qo1z2ApZTa8+co3YszWBGueL1gqtgIu6eI+HPmcQ3PEQJkvVhe53tu/8XuxWe1dkRG/96qZEeY2ym6RQppygSswiR9WKbURuk+eA1f9+Du4G7IyYOG1kD26FLfKDCjXWeAkSwHASXwKi+HL9nhtCmILkrnoBQtjYwxsoCc+u9QqXrQbmgAMkUAJoJRzsJ0nupLj3DZ1WqQ7x5F5iOXyNj040ShY7pTJQlLCGFSIwnDBK70FpivjA0JY1xRtXyz27SXEg0O+DJMGUKeIcLesGM+s57+8U3pq7kvY0QpgxOdWxCAv39doyNuNSp9MlQdHD/YdrhKyHAe+KosQXkJcJv6UrMMKdadZRhl8ey/hShi1hL12m0OP/JrODC7tiAXth2dbH811EYgsFIRQZdyi5sNybB3D25PiCxUuggO82UCqgqWCAC0zPVkOT1Zor/9um36gtWjfwlcYhCWxqNJGtZzhO+6TYiIJAYjSlGNe/ZW+KUWe6//3nkkoiDpDjtlMVamIULlsnPToDlLOecf9+hTQEtXQB2K1RHy2c1aJs29xTWcpEg64UwwJe7J0YlhUUQ12X6r/P4npfMc0rAUVr3yd498SjuvZ0jweTHr5QII28pgUaa5B6OF8ED3M8YCzKKuFW6hY9hKTHWyVBeB6UZvINKnTRAz2B60ZnKe+wv31EB7yNGIND89wxNFkipVrWm7VQhwrcFF4U+h5Gmp7kHWzdtwzEqJRSR3HHDh3mkQ9VodCVnGaAJ3lyH2/eCsMK+pV9VqH7XJuW3JTGu3wlkptJhFBDb7zPK62wNDksBctL8qVHiR1q0d2DNjTiSMtMkChg5
 IrsUAwRm
 qlLFD0agL1c6y5YGYo3eei4AIwhc0hiNdB/5l6BC898eHM4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_cycles() is the historical access to a fine grained time source, but it
is a suboptimal choice for two reasons:

   - get_cycles() is not guaranteed to be supported and functional on all
     systems/platforms. If not supported or not functional it returns 0,
     which makes benchmarking moot.

   - get_cycles() returns the raw counter value of whatever the
     architecture platform provides. The original x86 Time Stamp Counter
     (TSC) was despite its name tied to the actual CPU core frequency.
     That's not longer the case. So the counter value is only meaningful
     when the CPU operates at the same frequency as the TSC or the value is
     adjusted to the actual CPU frequency. Other architectures and
     platforms provide similar disjunct counters via get_cycles(), so the
     result is operations per BOGO-cycles, which is not really meaningful.

Use ktime_get() instead which provides nanosecond timestamps with the
granularity of the underlying hardware counter, which is not different to
the variety of get_cycles() implementations.

This provides at least understandable metrics, i.e. operations/nanoseconds,
and is available on all platforms. As with get_cycles() the result might
have to be put into relation with the CPU operating frequency, but that's
not any different.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
 crypto/tcrypt.c |   84 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -202,7 +202,7 @@ static int test_mb_aead_jiffies(struct t
 static int test_mb_aead_cycles(struct test_mb_aead_data *data, int enc,
 			       int blen, u32 num_mb)
 {
-	unsigned long cycles = 0;
+	unsigned long nsecs = 0;
 	int ret = 0;
 	int i;
 	int *rc;
@@ -220,20 +220,20 @@ static int test_mb_aead_cycles(struct te
 
 	/* The real thing. */
 	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
+		ktime_t start, end;
 
-		start = get_cycles();
+		start = ktime_get();
 		ret = do_mult_aead_op(data, enc, num_mb, rc);
-		end = get_cycles();
+		end = ktime_get();
 
 		if (ret)
 			goto out;
 
-		cycles += end - start;
+		nsecs += (unsigned long)(end - start);
 	}
 
-	pr_cont("1 operation in %lu cycles (%d bytes)\n",
-		(cycles + 4) / (8 * num_mb), blen);
+	pr_cont("1 operation in %lu nsecs (%d bytes)\n",
+		nsecs / (8 * num_mb), blen);
 
 out:
 	kfree(rc);
@@ -475,7 +475,7 @@ static int test_aead_jiffies(struct aead
 
 static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 {
-	unsigned long cycles = 0;
+	unsigned long nsecs = 0;
 	int ret = 0;
 	int i;
 
@@ -492,25 +492,24 @@ static int test_aead_cycles(struct aead_
 
 	/* The real thing. */
 	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
+		ktime_t start, end;
 
-		start = get_cycles();
+		start = ktime_get();
 		if (enc)
 			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
 		else
 			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
-		end = get_cycles();
+		end = ktime_get();
 
 		if (ret)
 			goto out;
 
-		cycles += end - start;
+		nsecs += (unsigned long)(end - start);
 	}
 
 out:
 	if (ret == 0)
-		pr_cont("1 operation in %lu cycles (%d bytes)\n",
-			(cycles + 4) / 8, blen);
+		pr_cont("1 operation in %lu nsecs (%d bytes)\n", nsecs / 8, blen);
 
 	return ret;
 }
@@ -771,7 +770,7 @@ static int test_ahash_jiffies(struct aha
 static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
 				    char *out)
 {
-	unsigned long cycles = 0;
+	unsigned long nsecs = 0;
 	int ret, i;
 
 	/* Warm-up run. */
@@ -783,25 +782,25 @@ static int test_ahash_cycles_digest(stru
 
 	/* The real thing. */
 	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
+		ktime_t start, end;
 
-		start = get_cycles();
+		start = ktime_get();
 
 		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
 		if (ret)
 			goto out;
 
-		end = get_cycles();
+		end = ktime_get();
 
-		cycles += end - start;
+		nsecs += (unsigned long)(end - start);
 	}
 
 out:
 	if (ret)
 		return ret;
 
-	pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
-		cycles / 8, cycles / (8 * blen));
+	pr_cont("%6lu nsecs/operation, %4lu nsecs/byte\n",
+		nsecs / 8, nsecs / (8 * blen));
 
 	return 0;
 }
@@ -809,7 +808,7 @@ static int test_ahash_cycles_digest(stru
 static int test_ahash_cycles(struct ahash_request *req, int blen,
 			     int plen, char *out)
 {
-	unsigned long cycles = 0;
+	unsigned long nsecs = 0;
 	int i, pcount, ret;
 
 	if (plen == blen)
@@ -832,9 +831,9 @@ static int test_ahash_cycles(struct ahas
 
 	/* The real thing. */
 	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
+		ktime_t start, end;
 
-		start = get_cycles();
+		start = ktime_get();
 
 		ret = do_one_ahash_op(req, crypto_ahash_init(req));
 		if (ret)
@@ -848,17 +847,17 @@ static int test_ahash_cycles(struct ahas
 		if (ret)
 			goto out;
 
-		end = get_cycles();
+		end = ktime_get();
 
-		cycles += end - start;
+		nsecs += (unsigned long)(end - start);
 	}
 
 out:
 	if (ret)
 		return ret;
 
-	pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
-		cycles / 8, cycles / (8 * blen));
+	pr_cont("%6lu nsecs/operation, %4lu nsecs/byte\n",
+		nsecs / 8, nsecs / (8 * blen));
 
 	return 0;
 }
@@ -1019,7 +1018,7 @@ static int test_mb_acipher_jiffies(struc
 static int test_mb_acipher_cycles(struct test_mb_skcipher_data *data, int enc,
 			       int blen, u32 num_mb)
 {
-	unsigned long cycles = 0;
+	unsigned long nsecs = 0;
 	int ret = 0;
 	int i;
 	int *rc;
@@ -1037,20 +1036,20 @@ static int test_mb_acipher_cycles(struct
 
 	/* The real thing. */
 	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
+		ktime_t start, end;
 
-		start = get_cycles();
+		start = ktime_get();
 		ret = do_mult_acipher_op(data, enc, num_mb, rc);
-		end = get_cycles();
+		end = ktime_get();
 
 		if (ret)
 			goto out;
 
-		cycles += end - start;
+		nsecs += (unsigned long)(end - start);
 	}
 
-	pr_cont("1 operation in %lu cycles (%d bytes)\n",
-		(cycles + 4) / (8 * num_mb), blen);
+	pr_cont("1 operation in %lu nsecs (%d bytes)\n",
+		nsecs / (8 * num_mb), blen);
 
 out:
 	kfree(rc);
@@ -1246,7 +1245,7 @@ static int test_acipher_jiffies(struct s
 static int test_acipher_cycles(struct skcipher_request *req, int enc,
 			       int blen)
 {
-	unsigned long cycles = 0;
+	unsigned long nsecs = 0;
 	int ret = 0;
 	int i;
 
@@ -1265,27 +1264,28 @@ static int test_acipher_cycles(struct sk
 
 	/* The real thing. */
 	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
+		ktime_t start, end;
+
+		start = ktime_get();
 
-		start = get_cycles();
 		if (enc)
 			ret = do_one_acipher_op(req,
 						crypto_skcipher_encrypt(req));
 		else
 			ret = do_one_acipher_op(req,
 						crypto_skcipher_decrypt(req));
-		end = get_cycles();
+		end = ktime_get();
 
 		if (ret)
 			goto out;
 
-		cycles += end - start;
+		nsecs += (unsigned long)(end - start);
 	}
 
 out:
 	if (ret == 0)
-		pr_cont("1 operation in %lu cycles (%d bytes)\n",
-			(cycles + 4) / 8, blen);
+		pr_cont("1 operation in %lu nsecs (%d bytes)\n",
+			nsecs / 8, blen);
 
 	return ret;
 }


