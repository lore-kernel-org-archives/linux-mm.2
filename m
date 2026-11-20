Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECA560A5BC6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dv/ZdNXh
Received: by kanga.kvack.org (Postfix)
	id BE8326B074E; Thu, 19 Nov 2026 23:19:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98BC6B074F; Thu, 19 Nov 2026 23:19:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60AE6B0750; Thu, 19 Nov 2026 23:19:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E35D6B074E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:19:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F3A6A0D4C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:22 +0000 (UTC)
X-FDA: 85454192964.07.F78FA17
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id BFB5C180006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Dv/ZdNXh";
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795148360;
	b=gzDDD51ZwKjDT8b1V6EuQtPpFHdUaCBz2qms3GoVauKSCzdsNGuRCL8aDzpbynZmCwFRRW
	izgB1cOh5OivhjVdpVNHhahBpAvC1kgrUiSQVudQ7PNxcrLTAzPVlEGn+VBBSniaSLG9iz
	krSBZB9GY9FR1hLLg/7oV1QDNwmpLxc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
	b=jE7/sWmeR4TXjQaVRD+K8I+h3Wecd1bxSWPp80oclRLGnJz7aAluRwPKQEx8hKX0/0lNp3
	16UEKBq0qrkjqitYknEbznlW0arZERcinosuJBgCMMTILUFF+8EPu3LdgUOc+3EfbM8mza
	hlAp6sJ2x6rTDVpK8fGIuA2U6qOJEhQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Dv/ZdNXh";
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a8cc11ac42so676972c88.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148359; x=1795753159; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=Dv/ZdNXhfHdvuoSMy3f5MWSF5r5alhzfdC1IfgTvsW8FBkOevIL/zI8TOQf9Xih+nN
         TWerOzlN6rUnE2EIVMIUHm0HaOL80I4hiKZlz9eDqs0Y+CYpGhyMx0jqlp1ZCFIEzj5S
         5MGKB6HzAbW6Xp9kDVL54qCiYmd/1jnsONR6TOlYFwVc7RsgTzvw+3suy+ah/eGdVXwh
         xwqghnxfdyy19hwGF5uo1RMa1ZbzMeSCoqvxP2pBa82tGRctClx+x3b1cf5GBCrWHZdv
         votdMXQUvBlI/f1gMM87pWp5DhXzWJty+T6WorpS/+G1jL7YnddzfekFLysI2xTAi/Mw
         K5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148359; x=1795753159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=dldM5AdYkmtN3YYbRhK9Tw/in74kHnTH7Vip2b506c8HMSNZFTI3mFaC2IfZlbTWH6
         3Inftde3mg1OQgw05yDXk/kcP+giGgVX6qYkBJ5/GeoiCy/r67fHvygO7C8lY500HDnr
         WkwiqDMfWcGTc8I78+RhFJAq+BwVYtT0QXcyqvPhdHn6V3vctXjR2nkEexzfk+Cr5XyG
         eqr4+KQ9qomaHEdEx73NMu4y3ZV9uABI3ESh5RxhhrS6lUHUyhqzitdzAL2M2GwLEJ4e
         Lz1fDOuB3GkbsSCE+hjBab8zrx8fv4QQLFQyyT5W7sMaEAgHFYxK6P1ycyH6leKcrAhX
         q1Bw==
X-Forwarded-Encrypted: i=1; AL+hErFP5q8WqqvCPPVOLKhepBNqijRDhFgbPiER4jNxz3uCzpNfNF9Jdz2Q0rfZNebjGrJskMXKBLEC3Q==@kvack.org
X-Gm-Message-State: APuU4Z+zyZ2CQA8W28Up7LlVlBrcr3SbF/V6cRZvARORc6vcNU2jecfG
	11jHuynRhZPfwXbDkx9gVQOlyzgSwzGpld2rnzgUfJzx5ItSacLrGJEp
X-Gm-Gg: AYBFou3LWkdfDPRbZ56MKIs6N1kta+aUzyN8xrBl40etMwwM2XvIyWnLG7WdPxAePGk
	Rcda/izrIWB2Afc+7KD7IXMLXGfCr8Gmni6QRRefWqeMRNfxQRAvLrTI7odvh/hIn+R94spbx8D
	HeHVcRIK7zbg1PZruofWY7+yyCTrIToNXP0zGvjr0WqP4d4hzoAsNLN4jBQVgcLFG7RxQhymncl
	LDhx9bgKkZcC9ueC5rek1sOeyx9PPIerZvu/HizicRJ1U/32gE7oQ14ClMwBaGr6I1kodUHxzJt
	XaZNZ+4rIJwAl8Zubdg/8BXFKRKWL5jQCYaB4Scq45JHbRJv1qdfVXxlmMhRbCIwMiyrQZUgFm8
	hUHY3BUbYhhiR4olfcaPCg8EL/Rep23YQzsYduCWgMMp+T+ZWw8qDEjg/N4HOAqMKS6LMfeYOK+
	kNHrQflusiQHJ67w2U4RyIk8JaInNvCcyklfv+6ljReCZVbdClRpNlFn654PTwGwvfkjqp7/4UX
	1eo/yBQJrPrKrJ5nMOdMD5Iv0IgKuaXJh//Cd8dr1FQKljW7lqB3ZL+JE62ZaHA1Xh0ZFTkoDWN
	tsmE1pAFnrF3XgC3QkCH4VUdJ0O+bxoegfQCAt48fg==
X-Received: by 2002:a05:7023:a8b:b0:1b0:430d:d81c with SMTP id a92af1059eb24-1b5568feb77mr1636832c88.25.1795148359482;
        Thu, 19 Nov 2026 20:19:19 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:18 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v4 2/8] crypto: acomp - Add bit to indicate segmentation support.
Date: Thu, 19 Nov 2026 20:19:00 -0800
Message-Id: <20261120041906.5785-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BFB5C180006
X-Rspam-User:
X-Stat-Signature: dz8px1s6brn96zntse1rg5t74hgaer1n
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795148360-860827
X-HE-Meta: U2FsdGVkX18odZpRhso0dfZoZXox46+LPj5UV4f9MJVwcOHxE+1An/L57OWO8z/FJcz1tHCCq8dIbCWyJQa4vp4Otb7enoLTQip6sF/2G8ZmquhrpvBvNbnSCB5wTil4UpwZ4gzdPht9bFDnv1LHNvI8dLJ3fvyoi3p9x3iMlwS9GAe37/KUbYtb/OBIriMLfpnXVFrHyzKShUxbaIiw0GPdyHaEB/8gM8QQxEN/S+xgcWnDLdlmwgmx/6Tjoec6msL+PTDJmp0p8Qoe827dRzpxgDguHJUMcOdCixK0uZCklrI0pkNITk96/nbSj3VPB6V8I+yUfTUY+/KLgBcEVAXyv7m1h4dRcQZpS1xP5LWniEt8kTfUlSQ/fPsRdNqIAQenV6G8g3nKS6YXNNhjYChYodaf4NfMmtdtSVWwZ4dQkLGOK9vCuX7RwE1oRMKHiO8rxtIDKhBO9I5+fxzkde76fg1U5Kpfd6ro4JZ4viIzImj6AjqqOC66WfkCg4vpz8csu2dtEVV5cZbQIy4Ae+8EvfNBWx7aDmNRPdigsoCXPBHCVMi+4xPOwI6G+oW79wvg1S/W7tzQ+gMH03lebfiPTjpgINhy65kgwS/qFC7OWRyl4Jm/uU/WXQszNbvffbQaYerMnbkFZIwFlrFiHWK2QCnLogYSBoBJU0A1kNXEiJaNO2UEePfF287P7OFxQW3hfPd+TOM9Dxo8E41St363w46kUUg8xnwa4nv95a5cTwuSOkb9mVf9ZEpqqz+7NFIMixhUTEtVRgZLMJzdnXGtWbFEAVlHlGY40XWn1vmORlWI1lpnXgnzRKysE6xaKIkt2fBphkLZOHm+OvkSxGM/RW8XeCjjgoYzIh9axDYKPEFoOdevLfK+GXAdGVzZbvChf3g7F7cTPfmOVfkWvXt1J1xdsPlUHK0Lm1D+nAYaJUPUe98pFCd8VhyTW0NYZT0xhY37uEfx+4c3Eo6
 dM30UO6x
 /eFBzpOdKpd1KUMRQ73hdYl8LFLODVesIZfCKnTB7T0KPJy7PZLnEOTXbQ8A83Ur8cfK9Lj6TIfI7Orlrs8fd7eY7GicKXyvfGocn6MObk0AEOWHlZJH/AT5or2jOqLp5W1LsT/3CLhj3k4O7OZ2M08olMsG+Z/w0yy7kiBXlqtnn4hDliRn8qFOsaGfRghpWLrTBc+JEOZGraHNpVh7O0luWTTMtCuiLjliupKiNMI/0TloVXtAtwJW6FWnvH6RdfX+xoTmpccbPtAc5oBuWK336X3CHI2q9r6h9mNUcwfr8enthXCREpPYlmMYRPUlDp73ZoBNrstHKloBorBxzxC5cfhjpj7NLCv+HEbWs/3WBLs+gojS112o/W+dlpJPfjTV9rVltW7ZSEFD9vTLe4frvVSZtfptfDJRQsMr8o6Me2PLLPQ04sp5bspsDoq8i+XPIv3DJDkPGtGbOv8Tire0I2KJCqvQcfDmh769sKw056f5tyAC7m6deXFm0ZmyEI4qhe+G7djspSjW7WQEwbP+XP0GmbnjWq3jVewWbVjLU8r8HPz5axcasLjaGzZMtvGq0cKBc7uYfuGul7xCEzfNHMcAvq1r0mtxrrvVr3CDPwX+pUJEpFQQy4gPZPGc30YDHMJ1GqhU0QesxGJ905m6w55y8T6WxICSuPsPWrLk3YgH9hQmR44NFJR814W+AACvwsvJ/I3k+08s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This patch adds segmentation support for compression.

Add a bit to the crypto_alg flags to indicate support for segmentation.
Also add a helper for acomp to test whether a given tfm supports
segmentation.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/crypto/algapi.h             | 5 +++++
 include/crypto/internal/acompress.h | 5 +++++
 include/linux/crypto.h              | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 05deea9dac5e..7d406cfe5751 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -280,6 +280,11 @@ static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
+static inline bool crypto_tfm_req_seg(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_SEG;
+}
+
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
 {
 	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 9cd37df32dc4..93ae59623f13 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -189,6 +189,11 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
+static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b7c97f1c47c9..78c699ac3f82 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -139,6 +139,9 @@
 /* Set if the algorithm cannot have a fallback (e.g., phmac). */
 #define CRYPTO_ALG_NO_FALLBACK		0x00080000
 
+/* Set if the algorithm supports segmentation. */
+#define CRYPTO_ALG_REQ_SEG		0x00100000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.39.5


