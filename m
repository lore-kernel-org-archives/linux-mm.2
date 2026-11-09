Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECC86606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qRXO6QLk
Received: by kanga.kvack.org (Postfix)
	id 0F9576B05B8; Mon,  9 Nov 2026 07:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA8B6B05B9; Mon,  9 Nov 2026 07:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBC86B05BA; Mon,  9 Nov 2026 07:59:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDB6A6B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:59:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 541441A0696
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:59:51 +0000 (UTC)
X-FDA: 85415587782.25.4CB6B7F
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 81BDD4000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:59:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qRXO6QLk;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794229189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bf66K50sN/ej0L8frki1RtqgPCwdRDaZn51n0bwU8VM=;
	b=wXF1JKLn8whib6CRLmAfRDdVlUaBtcXvyW+qqNhfBw11Fh1R5NdMOYdAK6qD4mIUOMrpq1
	cTghZsmr4c6M7XccbpwH78LwUU8RP6trcQyk6bsdvsoYTyjIlxfAZrLWL0kT1aWy7IskPJ
	8Pv4MkIYVJVfBVVB0lJjpdWDvWhDe84=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794229189;
	b=sfU3OQcXBpDaJFpTq/fJx+Py+wAVH75RNTeZHtu2GNI7TqztHsrBKXJtuzkXwXLcRQoYGv
	nDIpkzQOJ5+HVTmxUmr7giS7o/YFhX7h55pcxwaAlk/4CcLMJFmUopEvmyYrUCIysXwsX2
	sP0z9/CLcojD8hBQyrdjrxh9iAf48to=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qRXO6QLk;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3acb1224533so86687a91.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 04:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794229188; x=1794833988; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bf66K50sN/ej0L8frki1RtqgPCwdRDaZn51n0bwU8VM=;
        b=qRXO6QLk+deimaV476BJGHgk2nDIdVCo1p9bNvc5ZwjkssVL0oCjXPPKb8JlHix76L
         qrevbQ6BXUAs/mh5IEl30dVOswIPzAWQ521T45FtnV/QT5uV6iGuepnd7hcWSKyrh1KB
         aOIbcLRvE3ofqec0ZIjYAjYT+IcveX6GnFKRpLkxwJ1CFisWoY0TmhAbro/SHMACUPZY
         hEDwHUbB8Al905/4obd/eOs5yHV0L6r7Kc2Q+g26pbyjKI5cUl7mBIEb8nJ/tjEhA4Eb
         WZf6/+Sg0wmZPsUbCQzqgPD9IC21ajRTTQzz3kWt38oCbyCxScWwEo1furQbbi7ekDR1
         k49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794229188; x=1794833988;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bf66K50sN/ej0L8frki1RtqgPCwdRDaZn51n0bwU8VM=;
        b=zppTWajWj/zo8XgK67jaC140D0L6Zd2vlV2gveoXwByfghv+f1OT9/qifKFpLMFU3O
         enYmv2b2jlJGOspbfz5zi+JiWiBuDtS90M/yqqgEuPjT6soyXmmzo+c2Z3rScOm7/Bj0
         390ii2oY7Bwt3XSqBdEPLHwEUcszWMw2kHwu6oIo9m/fjTR0R1B/uhSA60p3ew6+f1mn
         rtVCwtcCqNfkf8xsInthyqppdqBV4+IlOd0xAGg+NfAmQzg2bWR5aa9l3a8ogvWsqBHQ
         BQ1XvInzA9Osqz1DVtbvEdrO4vHNTxE3/0i+kH2i6YZ2QtKa0ygSSWK5SH8ssv8VMpEp
         sfyA==
X-Forwarded-Encrypted: i=1; AL+hErGCfy/+MoEsxhECoj5EwRAjnQmE1XUaNI6/wTCjHrDpVZdNFal0QZKLWT2PwC1SG13X8qIxCdoGCw==@kvack.org
X-Gm-Message-State: APuU4Z8t1qoAg4qZsDmTKExbsBrFv3y08jBlYEsKYHNsma3hMiBrHpbE
	/bcg3ZVeC1UU6oI5eXa5El/0bGDWTCZ+5gdqLUfBgHvh98YbbrIrGcN0
X-Gm-Gg: AYBFou2q4IJIOr0jGsDMLoAmlVwGwdxLZINrK3Bh42grmajVr65fpcBRcLDgqbQSRw5
	hdvs/uWvGaE6wEZxAv5PxfmZ9CNJhD86X85mKRlIe2JVMYIsHNr9ttf4T/QHwfqUv4ts0ZWQ9tH
	RH2TSpk0svs/6pxFGkM+QONVLhxMq3V4EdkBFChn6nVtcHTa1txMLIDweLc4CbIvMCdFVSiJLTV
	Z7DR/fR5BGojhpph9VSXPXd7n5xJylY/q8aEN2DGuYGqG3dc24vKlKYKg5wEgqNuykse8GOb/Mo
	6NxHnL7yPBt4OHbb36gk7vx1gb9LaRaDyLOeEF47zf2102c0WmPUBw8ngHGWJ9Z5fBRQYdzoA3i
	TSJLA0zdzkq+GOGUzniYux0CyDAQEToJzW/ZABhjC4YatYy1NDl9a5mZjzL72+cRcKFOtRVVB0p
	ecm1yLiVK0a6oABrNuYmBEfN/udspRdhj3tbHWSGhsKdrcKoTieBYztoxpkskH4FAxBhuKQ31FR
	aUBEFroH307nVbaB1hfheOadDUflxi83Ulzp4wtVYZFsz70qhHdkxaQvdgHQh8hmHQr7B/vZ8q/
	9wR0099ANNN3DB5sXYvUbjc5oWfIQ9RsF3ECTjqbu838x+fRA75RY8kL00gv+dxxrSv4
X-Received: by 2002:a17:90b:3912:b0:3b0:9a3e:bf8b with SMTP id 98e67ed59e1d1-3b12d4c5f3cmr6392997a91.6.1794229188323;
        Mon, 09 Nov 2026 04:59:48 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb969694aasm1534153a12.25.2026.11.09.04.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 04:59:47 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 09 Nov 2026 20:59:29 +0800
Subject: [PATCH v2 1/3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-zsmalloc_stat-v2-1-caee41684aba@gmail.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
In-Reply-To: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: gas9a19gkuygskkki4dx9n3si9ymodkt
X-Rspamd-Queue-Id: 81BDD4000B
X-Rspam-User: 
X-HE-Tag: 1794229189-210279
X-HE-Meta: U2FsdGVkX199nvXt7r+tGcAjyLqVqfjSndoxs6JJFim7AOTbTLDjMDgwWWD6uDSkRdi91NKBgVZ6L96rmFoK0J5IlcKnqBG5W+RIgz8FxOUuMKig3Q/8KERndRpAIU3DF3XHqo2sw0kZzbIcUshznIz492Pj3VIb8pvlYMtml6y+kiP3NtSU6nGuPsLDmUIRBHpLavhtrCwE88HXmCyuquTmkY0oio1QjLGFszp/tp+P8uTJZwVk7ESGstWLzvkfGK465jXwmsXgbRVn1HfVWPraFySwyDym1/TPSDo+Izt2hfeMqJmxn6DbjT9GXCui7GtZwmk7/6Naf8APL3XctQx1Zaq4lptaD/CQEOmUd5awahrmZdjCJpY526Y1rrgZ+jTBKDpy2ArSWgGbOq1kh3OnKK4U0wlKwxLLeWI0O3Y966x/cB2SJRkoLGSQmVP+fGwKYdsQSZ7wPjAoh9PW3/9OmeL0qwnSFIYz+GsXD/VvxjvN7IDY+8DiU0xDsNrPpChTmZex/BsPekjpOsEQIz6yoJdgIcH77vHSNWJSzzuSNZDDSHQPNeu7HVLtQEt6C8crCHa/pGxFl5VqaVuWKuvUi4ftcPThpH7X9VMLkohSv0JWUUiIoXQSmqV+0fi7nU2ZsLoBUID5UsUIB2dcJLzXGMb+8h4SGuiqSQln+0TFMOy6d3uN83b4OKlvc4SWgyPOtVdoF1V7qrsIo+uuOZfLE3Pl8Ew+Y+F+M2pZvrRmr+vefCgFsmYn5JtvdXRUIlGGlSzQw0vEIr36+q7De5uCgyWc1ZdEiy3UzdihDsmZTfRF8WwXDsgat9D3Hkgo8lMnhg0fqF8u4qWTbR/oET3a0b6ICPDdjKW9TtzFy81qU53GfFmohLTn4oqt84va+ahCppvNkhPCXUNH8bduXu+T7Je9rHomraNH8Up0Av7kv9ezzTSUuoM30AMmO07sgfEoeNDHxLf9K7uOwUu
 IZ7tXH7n
 qPom2IdcRH0l4whJFAAeXyJxB9aHd/vwXWoIAcdXWRT9sEXr+diDZ8O/W5cGysf6NTzPd+ES8pgTitT+uZ774aBacTn9ceFHNvhuOMLRgCOpe1Z1OE1YPUDnrTDlOqO5ceXk8K5qwA75dnMZlUi4q6wbNUZJmh6bEzt43TQgx30fVEFFJQ1qJT2/oUcKgs7ol7JWigfTFEvmhVkcj7NYsUTAeCEXq0w+BEq+hR1LlIRPA3YxZW2b9gassfUqccFh+i+QZHPITnKiWt5xLFb4jHfxbaz8hyF/ERXCnq72Swr1W0lKx42yTl/L8LMgm/LpuRJ1Cj8KvtiKKBKipPuG10s7KgWaa5FXyT3d+P4HQLCFDziX64jbIeujIpyNXZsFbc1q01FE5so1F8p+ULaMdbFX07NptV13eFH8UtiZ8Ibe7aJQBPBKkvQwigi5dCCTY4sIVwFLFDoLHnJMWHuZzddDXAH3TUZQx5tOE8BZ9j1XKdGq6pJvy4IYEjYuKqZwwVdBqOxC2op92sakX4ayhB2zRD7PZ1nUQxsNUV6QjdkAyV/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
counters are updated regardless of this option.

Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
debugfs is unavailable.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/zsmalloc.c | 33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..104ccf3aa170 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -222,9 +222,7 @@ struct zs_size_stat {
 	unsigned long objs[NR_CLASS_STAT_TYPES];
 };
 
-#ifdef CONFIG_ZSMALLOC_STAT
 static struct dentry *zs_stat_root;
-#endif
 
 static size_t huge_class_size;
 
@@ -279,9 +277,7 @@ struct zs_pool {
 	/* Compact classes */
 	struct shrinker *shrinker;
 
-#ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
-#endif
 #ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
 #endif
@@ -565,14 +561,10 @@ static inline unsigned long class_stat_read(struct size_class *class, int type)
 	return class->stats.objs[type];
 }
 
-#ifdef CONFIG_ZSMALLOC_STAT
-
 static void __init zs_stat_init(void)
 {
-	if (!debugfs_initialized()) {
-		pr_warn("debugfs not available, stat dir not created\n");
+	if (!debugfs_initialized())
 		return;
-	}
 
 	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
 }
@@ -650,10 +642,8 @@ DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
 
 static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
-	if (!zs_stat_root) {
-		pr_warn("no root stat dir, not creating <%s> stat dir\n", name);
+	if (IS_ERR_OR_NULL(zs_stat_root))
 		return;
-	}
 
 	pool->stat_dentry = debugfs_create_dir(name, zs_stat_root);
 
@@ -666,25 +656,6 @@ static void zs_pool_stat_destroy(struct zs_pool *pool)
 	debugfs_remove_recursive(pool->stat_dentry);
 }
 
-#else /* CONFIG_ZSMALLOC_STAT */
-static void __init zs_stat_init(void)
-{
-}
-
-static void __exit zs_stat_exit(void)
-{
-}
-
-static inline void zs_pool_stat_create(struct zs_pool *pool, const char *name)
-{
-}
-
-static inline void zs_pool_stat_destroy(struct zs_pool *pool)
-{
-}
-#endif
-
-
 /*
  * For each size class, zspages are divided into different groups
  * depending on their usage ratio. This function returns fullness

-- 
2.47.3


