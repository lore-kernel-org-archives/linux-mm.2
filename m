Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B27606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Y+ST6Y8g
Received: by kanga.kvack.org (Postfix)
	id B15296B05B3; Wed, 28 Oct 2026 22:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC7C6B05B4; Wed, 28 Oct 2026 22:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE4C6B05B5; Wed, 28 Oct 2026 22:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E95F6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:26:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2FFAC029A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:26:09 +0000 (UTC)
X-FDA: 85374074058.05.9D8DB32
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id F2A0520005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:26:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Y+ST6Y8g;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240768;
	b=nUA1NDCjtCLFIcSqeY/dmR30WV+6M9rFvpd4ZaKM1miivasplLNxB3qun2yUi1KABWEDkb
	ioHpK6XsU8s5P/F1M9b/BZ7h3eoe1D4veEgyDGeb6sQ3djWv8pNFsTKM8e0x1fw9fmgUmT
	TSIfV0lNq850s1mi4CunhKZrQ/HAieY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Y+ST6Y8g;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pvfj7EdS2QFUg439b/Ol1E/yvGVDEmD0zO/yL8SbzK0=;
	b=1O8aN3qH6S5ks2YhMgtiRw+iOFmb8l9ng994E7F8Gf+zXwlpOetlnT7wzoMZi/sgyPNYy1
	VNx8kC/Dzx9oBCuV2qIZ8n4Q6bmB9HQOYHEOzG9At81u0ETeBbp4X/uoYs/DoL/plPOCoX
	R6Rz/gKgzh0qM9bwzPDSOiMmYPUGQJE=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3282db206d3so213922eec.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793240767; x=1793845567; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pvfj7EdS2QFUg439b/Ol1E/yvGVDEmD0zO/yL8SbzK0=;
        b=Y+ST6Y8guhuouglxBh9hvtqaa+Q6wEixuaE1VUNNBCSPB+5w7rB1WLeBu9DAvnMBBl
         Ev+7Cjieh4JSeXK++mFxJp78NEfOS/JjO/nzdvaSKvdXe6LAQV9sySs2VTIlROVCSl59
         2qE3rpbqVWc64oAULFuRuD/3ZA8YqkxdFWiK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793240767; x=1793845567;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pvfj7EdS2QFUg439b/Ol1E/yvGVDEmD0zO/yL8SbzK0=;
        b=oq7r2q/m64d2OUtWC/pBsXcilmlXPOcapXGHmTUWCs49zVUGqHGckX+fzxwdxxkWji
         5xwv4o2vFjr3Vx18u0NGRcsKLhgOr98G72w7dy6v1w8Jw0I003STalJw0GAFpP2cg9AG
         YXAk/7SbiLFVxFxdYrVvsm6vR4kwtJLYsQukb7NMFo6ccJxagNNkbkm1y5/icyTDHTCr
         pNJg6cLSBAdl66HL/qCRG5K34H7sK0db5ocERbRviSBKNY+ptQquyJQJfdDFp9Mu5HyS
         japV7pwHpjISqsB9o/zSe3WXpHedu8YpS0IUTktWGZROH1doHax2TDAqrUiqmyN/nUBY
         hw6A==
X-Forwarded-Encrypted: i=1; AKwUvBzyLC2Np3WYkdu2070kCYxY3Hvi8miXQdS2bdRZUbgJWQ3Usx+VTTZcZQhU8DGbGV06nvDwt0Lu2A==@kvack.org
X-Gm-Message-State: AFq9FYJoMQuYsFWIvswlqI5H/7nU6yARBJ9pIwBhj+c5bSIXode+kmd+
	HF9Pn5q26cg4IgSMv9rscdh0JrXWsgEGEg3/Au1bQmZr2reicGQoPwvMAInj4q8P1xuTNw++mKI
	LR4s=
X-Gm-Gg: AYBFou2TP+hUVMcaioJ11tHkKPuVc43C9OPcrD/Dt6AqaA1p+jNXxXjsEt0LiUhusW3
	jbqd4It1OWKBMpV2IfdaM5XV4IUArFxBJXzqOCSH39gpYhaz2i7/PcvZYm0ktUi9sNnvDie4YRB
	FnB1l14m5tpuOQJ/rzVZDuvM7mfDNLZcxs2JBz5G54cmSassSr595GK4TKs73FLblA59sua05iO
	84wjAYZwT3awLmGdF7pNeXs4szjJ6W5CKdiGqYrfaThgguawgRvffeSxm/r7PneW7iC7O/SDyTT
	1NGCD9HhSak0zaXheJKKkrAxyTspHDsgF+x45lPWu0rr/Hx+KA4mAsjxS5bAM5dHgLRkCE+g0Eg
	hNI1GN1quEI2h/RRs71rVCeOq53lbe2G17wAuFjF7oS9M+Hf1d6ksnV3HnUfqls9zb6DKjq+Q4X
	YL+vAgUYIv2r0owQCepvjcb0rrhb/YZf75DkYgXEMH7mPabZHgGx9UTI6FWhs8ITt8LNOOG0aPd
	LyUw5HYzWNF46xIvClTrnHpvgu6rTIi3hFQEZDQRX2JQX+nyf0tRYDXaYQgcPh5WuHhmG/6QAxX
	EIoKmp/r1SoJPQHj83RiZqtlnk2D56uvj00R3BGEtQhBi90upmMk0zzEDPjq5cPDeHNNELQ4I79
	ZjUZ8M9k+DtU9Evs=
X-Received: by 2002:a05:7301:1622:b0:360:db68:3264 with SMTP id 5a478bee46e88-36a203ad867mr6567630eec.6.1793240766517;
        Wed, 28 Oct 2026 19:26:06 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:f72e:e03e:c64e:b5b3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a239338e2sm13387055eec.18.2026.10.28.19.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 19:26:06 -0700 (PDT)
Date: Thu, 29 Oct 2026 11:26:01 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <auKqt6b4AxCLziIH@google.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: F2A0520005
X-Stat-Signature: 5ttexjc5yg6t69s4tjohbkjnfahhr6gb
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793240767-997818
X-HE-Meta: U2FsdGVkX1/8V5C5QKxEuEFP0zpmjseU0xPi5JME4+LoMJseHaSZJ0r3vUKW+uu5CDeK1SpfbvWhMjoBIoGl3fi+gya+MOkKnpABR5lgfpP+2B1Qx93ANSym9UVkatDZopRzXtD6aOKQnjK79CL66vhlDtqyzygWvDR3KyHNRYe9cF3Y4IQjXaN8PemH897712uL8DJz6XfKBctwqgXmn0x8/n430D2YEwB61cINlWqMBYn9F+zv7W6WJl36sK8xdNDUlAoMJcCVdu6W+g6o2bsmz/sYF9ID5YzX1UoYeJV5zkGxYeMYFxuhomQJqeng21RkBxdvn1NP5KGjdXovt9laqXBfFPNqxuCbE6B/upsJKXDxI6qHAb6yOR60NeiYXb/4pfnrqIxiz38QvGL4A4NpKJrkLV2GmA0O8tOpt4c/NxaLRvHFLQSLAtvo63BPF+eKWp5yTpgVP64gXrvzT/CDeWYWzv+u0lHrMl3M6DqG66JaaxMdCMtLkgaqtH8P5smFGApyfFxGjpwwdGP457Q22H/qUaqKitzPUV7HRvtD2dCpmqmYqBupjoM5zjUFZNPBX8lFZssejBrJrEqYsMEyUSr+Ya77F53KYfBGRcVQz0vmftJc7bmq1sAN/0666cEL7JjZ71i/Zam8iGV5JkqQYgBRCpNEmVMTIXEJknEn2su5HRH358e9L+Kbu/xoLN2bfHtm6g7bWk/tOFpu1yro46gXHriuvoZR34eJQjmhdc6LZ7lXCSes70GYn3vznFoT+oUyamgrj/vSD4DKk2kA98huS+tqwG487yn9XGstt51EU98rEgQPQcqx5gUt+Sk/4f0HomtjqN95+hItpDN2fJ6LACDCMS0fTzQLKL2gVSofecf87koW71TwMadWJyBRmrZsqq8s4g8YAPpGKz++Bq717M9KtFWkT3gDUeW2sYQE633ZxHirALPcJpipo8Y9fMxXStICvhEXNn8
 1cDEN2w1
 qjY5y0qPfrOUCydQJsfX0ezokVG+jPEVrmywAABg5SCfgv8Cp3V8BKRC42AbEG/QClFl61rA/ydRX/gIScc7ze31yi0LLhowU2s0n0o2X4IguWjm6HLNgtc5uMMKYPEsIy0bJUSDGhP7we25XnedQ0VYYV96RBCIpHDPFyLrpnSWyzStkSVK6gdbYSG0sHByf4nSEd7H2paqZXC1C/cryHsVDZ6cs3NTdaWO6jhVr6CEXvYwMaU5NB8AnMmgzzzVspRLXUucrSz6yOmxej30r3WXjQBfE8+v956/hfCBwKYR1Xdck2KsunA2fUBSvL7eFShwsJIkpDXrXkaBm7gbETMH009yNUKQgQyL1KkYIDDxGK8/9I5Dd+X5OBqwjD1Clsnvr0PD4Uh2mNDV/vbGEZiIqAMSwDaIrKOu5ezEYoO+vSWglhPoOdWDnLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/08/07 09:25), Nhat Pham wrote:
> Hmm we'd need to collect more data in our workloads to determine, but
> if we can compute compactable ratio (freeable_pages / total_pages) on
> a per size class basis, can we just skip the size class whose ratio is
> too bad? Would that at least cut down on the vast majority of
> fruitless memcpys and lock acquisitions etc?

To calculate those we need to tool pool/class locks.  But technically
possible.  Not sure, how would be determine the threshold tho.

On the other alternative is quite simple.  We can make it
"default ZSWAP", for example.

---

diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..72542946bc53 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -157,6 +157,17 @@ config ZSMALLOC_CHAIN_SIZE
 
 	  For more information, see zsmalloc documentation.
 
+config ZSMALLOC_SHRINKER
+	bool "Enable zsmalloc pool shrinker"
+	default y
+	help
+	  This option enables the zsmalloc pool shrinker, which allows
+	  the zsmalloc pool to be shrunk when the system is under memory
+	  pressure. The shrinker will attempt to free up memory by
+	  compacting zspages and releasing empty zspages back to the system.
+
+	  If unsure, say N.
+
 endmenu
 
 menu "Slab allocator options"
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..e0d7ab9142bb 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -276,8 +276,10 @@ struct zs_pool {
 
 	struct zs_pool_stats stats;
 
+#ifdef CONFIG_ZSMALLOC_SHRINKER
 	/* Compact classes */
 	struct shrinker *shrinker;
+#endif
 
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
@@ -2050,8 +2052,9 @@ void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats)
 }
 EXPORT_SYMBOL_GPL(zs_pool_stats);
 
+#ifdef CONFIG_ZSMALLOC_SHRINKER
 static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
-		struct shrink_control *sc)
+				      struct shrink_control *sc)
 {
 	unsigned long pages_freed;
 	struct zs_pool *pool = shrinker->private_data;
@@ -2067,7 +2070,7 @@ static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
 }
 
 static unsigned long zs_shrinker_count(struct shrinker *shrinker,
-		struct shrink_control *sc)
+				       struct shrink_control *sc)
 {
 	int i;
 	struct size_class *class;
@@ -2105,6 +2108,10 @@ static int zs_register_shrinker(struct zs_pool *pool)
 
 	return 0;
 }
+#else
+static void zs_unregister_shrinker(struct zs_pool *pool) { }
+static int zs_register_shrinker(struct zs_pool *pool) { return 0; }
+#endif
 
 static int calculate_zspage_chain_size(int class_size)
 {

