Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D98C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C877900075; Wed, 13 Aug 2025 09:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A63900044; Wed, 13 Aug 2025 09:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74105900075; Wed, 13 Aug 2025 09:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9BF900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:38:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22ACB1171E3
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:47 +0000 (UTC)
X-FDA: 83771839494.04.6537B90
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5E50F40007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VR+uueYi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092325; a=rsa-sha256;
	cv=none;
	b=rOF5JpUAAOv1KygpkchM5eJ7KJmhVR8BSkXOxBhF4yVgeXDK5Q11F6TjCV8TpamBXJGyvV
	pvE4TVBoLkSkRO/0eWL0rb4XrIOmHwIVXKnnoDuW9jh8YVsdiQi8wuY3WET5Y51bEn+ojJ
	Q8EE09t33eGYlRP6hwSzV2xnZPzRCUA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VR+uueYi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCmoTAq+24iKRI4CSHEBG8UaeJTBmRNFmOmZvFaISJE=;
	b=gre4Nkmk+T1yzdr+zmbhR6ICYlqyMqDsRCfYj3nFZquXHvrRiCS7A30S/4ef+QlKbPVTXG
	RqbDMigLOoejE6wrMrwXb5DCF9pTE83HdDAEI9jF9CtcoHPB1bulaHEkKrd7TIOp0dx2dC
	o8tf+3eOs+YyN+7WuGjh3TakoUy6yYo=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b8de6f7556so3759033f8f.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755092324; x=1755697124; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCmoTAq+24iKRI4CSHEBG8UaeJTBmRNFmOmZvFaISJE=;
        b=VR+uueYihfY9vwiYska13xjhhsCrFZrmtjXSyx6co9KU6QIZYa1+U/fuKSK+iEYsy3
         YtKNvno+j8R0e699WbgOVL6+mvV7qTbEGHm5dQQU4jlODyfL6KTdsC/tRkAGOIVt9ko9
         VD4JbOdHn/kPU5PKBrf2Yg8C7+Gnt4zpBW6KpZaaQXucGCIQCNiSC6WTAUkq4j3OhxTH
         Xti3o7eXyL11QCMGEdsn2F60W7qyNAGbSKg+9YQHjZTZdR4QuOE5kd2hBhVjvbGBH/ke
         3Mn6qAmTmz9yCsw/sAIywGwQI9ez3EYmfMLeZN4ATGIp6L3mHVmJ3JDwJZXINbjCbiM9
         jdmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092324; x=1755697124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WCmoTAq+24iKRI4CSHEBG8UaeJTBmRNFmOmZvFaISJE=;
        b=cI1FVOgHzzDh6B1OqM7xY43uiQTiD60Y+98nrrKi01mjCewbly9kO08gFLIiORWw8J
         TARDMTnb4Y5HCaIw+fsAzgZEPD01XggOyL/kEWbYO3hcM1HBD2PPVsFXyvv6DpcfMi4N
         23bGQGbBMe5Nss3w/Mh0OUSic9SQUeKWGVpjIkzkUC7Rla0tTgZKxt8Hs5JFESlPQDB2
         4E9MHOdhkYGr6Rjv+Qrt5LSU7ALebJVEWwHcYHCNaYnV7PO9yBfHjAJsK+nUvgTnjWMe
         d0XDkPq/wN9Tg3EoHs0IxpHzxWvefqsCAeO94gVc/ZVgrYciEvxqakhTm13UKJsF/VTx
         +eZg==
X-Forwarded-Encrypted: i=1; AJvYcCXXklZyDL6lAkgj0bVPPIL+nGLlHAyelCW91QhzCBMqNSneL4hHdavRoUOvx0zmKitd9Tff1ct1zw==@kvack.org
X-Gm-Message-State: AOJu0YzPXKpl0D9yK0aR7QPf/nwmb/nZJmgw1SFSVpm6Epxb8Cdjz6Hh
	wtCsUpuwhEyPR/NHhY4gqX8G3h7jBCy9rc1AtGIXFSb9oA5pNGbmDiK2bDeqy3dXcVyWng==
X-Gm-Gg: ASbGncvUSovTxcvckOrYH1AjuFt/KN4nKuAn4boMuu7XA+U+LSe0scDhn3bM6Hb0Dm1
	WM3lkirDNzNQYx6hd5oZdPqb7yHcYtLH1/NR5QV6ubToBf+qrCBXZWJRZlr3entAZ+bg6op/yts
	CrhnEzVz2qfPpfPgzPS+xR76gkSb4FHY9DPhL6WhOEE7gq0mpIAPrAsuIfIummbUOQqjQpZlw/h
	9quF7QlmtxKX8e+zHFi3AQZy7rDetxNQKcEl2uHEcXfHW3d99Na1HoJw//Mk49N2rMOwpvzUhAI
	hk5bgl+TnN8qlAWrPrHueOXOIzcf3RN+UFmKEHZ3byP8p3umNqZ4TyviGxOKi6lKE/uxnXAK3o+
	0eB+eEk8y1qdIhpGaAPvjYv7FyY635LN4+RFBYO/u0nApNxxsh2q0D7NS5CSyF47DWJy6JRm2Qk
	vvhgziTn5kq/+8AOOgRq6iRec4Tw==
X-Google-Smtp-Source: AGHT+IHW7Qd1SAbOSY879BbiErQpR32SX8ht+p3w2HKrir466M04lOt+huUQxcKj+6by6JWF/cRHzQ==
X-Received: by 2002:a05:6000:4308:b0:3b7:84fc:ef4c with SMTP id ffacd0b85a97d-3b917d2d303mr2420863f8f.6.1755092323832;
        Wed, 13 Aug 2025 06:38:43 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (87.220.76.34.bc.googleusercontent.com. [34.76.220.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm25677444f8f.69.2025.08.13.06.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:38:43 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Wed, 13 Aug 2025 13:38:12 +0000
Message-ID: <20250813133812.926145-7-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
In-Reply-To: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nzhou4gdddcci614eh7tja91drag3m41
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E50F40007
X-Rspamd-Server: rspam02
X-HE-Tag: 1755092325-546114
X-HE-Meta: U2FsdGVkX1/430rBZ9odVa0Y4ycJHziXP5JMClLLRIw10u8bMluZkOkXDlmGxnSup99Dev+mMpz6SCY32wwQKn0YKan2o0wUTfOiGW5U2fxkyL+tLcuiOLL+YI2gwyJYzme/sGwLwhmQsiTkUDBwKMgKi/CkPBsfxPg3DKwzXNhqoyg4mEWTr5JkawIHjyoaxjZFMcsarVs/X/Sv1WPoty486aDoyqBLSsy/ddJAzrxWcXj/wuxl8iSoVlz4RnPO3tlECCUlH+YQ9CoY8C63zIxsdWDs66PIsVsvd3V5HrRIDN0x1JsgSi/DiH1IhrA9gSY3s6oeGWsbU/Ks2lHVMSVoqxdAmeR3lwNPUdbXYtKYBc2Vjz3JQGkfWLCjLDIh8vfncTe1YuYhrXBI1q2FOhlYVypr76Jn4AVBb/jqzGuZHZjEcsiML69vHMvdKL0KCc8StfeFFbEoY+xSkDd68PgSxVcIxng3yurdoCrsfNFjlePxPkx0QJdOH3EUAKAuB2HRgsns/2zG+KF/Z3TvnuRFsMp6PxCKBG9yuYUmb8Ji7+/NgK5SJkRsoFHZq7xzgw682jX+bVDdv3MTI9uw26M/jOXL6bs/tXyjI639Eyj3J63QT3Tv1/LuyfhBcau/Nr5QXC/nVYxrNfzJoSwkWis28wEzlaRt2C4KtY9PXp2qmNEuk7ins2bahDF6SpjSf0C3tsS1iG+rZEbSxnSqMQAMOjWM5GfCUehSbmtLCYa/4DJUU4vp9uOWihDdLvot0xitRtEykMOk3y+OTC7QcmEfTe9xjXvIhiz8LPTBqPLZSrq+BRrDNSVOrQ9UP6otRAJNfNT3+cJZZ0LnNUf9pRIqljOpRJUhJ3Ozcsa5UHDzZVqaTJpSIvad2pGmaNL0Cjco1tBtr5D1p/oEIEjI6TzdrRgLpJ9bwZQETxcoqsRUipdD0HxExyUShIeUNtX0K2cm6Op4IaX0WsB/vaE
 eNR0Fxxc
 0tjGSPOtyhT5V7pT4ifies6cWebPsRUY6HxP9TLOiulKLtPhm9ODqpd7zEnM9/9xSdAIcJhShSQ7aGXM57vQSf3h91dCVtf/ljZyaBR84TJMElW6AoBazYz/2kCxgl5aQxSa3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
rsa_parse_priv_key to serve as real-world examples of how the framework is used.

These functions are ideal candidates for KFuzzTest as they perform complex
parsing of user-controlled data but are not directly exposed at the syscall
boundary. This makes them difficult to exercise with traditional fuzzing tools
and showcases the primary strength of the KFuzzTest framework: providing an
interface to fuzz internal, non-exported kernel functions.

The targets are defined directly within the source files of the functions they
test, demonstrating how to colocate fuzz tests with the code under test.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 15 ++++++++++++++
 crypto/rsa_helper.c                   | 29 +++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 423d13c47545..e8477f8b0eaf 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -13,6 +13,7 @@
 #include <linux/err.h>
 #include <linux/oid_registry.h>
 #include <crypto/public_key.h>
+#include <linux/kfuzztest.h>
 #include "pkcs7_parser.h"
 #include "pkcs7.asn1.h"
 
@@ -169,6 +170,20 @@ struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
 }
 EXPORT_SYMBOL_GPL(pkcs7_parse_message);
 
+struct pkcs7_parse_message_arg {
+	const void *data;
+	size_t datalen;
+};
+
+FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
+	KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
+	KFUZZTEST_EXPECT_LE(pkcs7_parse_message_arg, datalen, 16 * PAGE_SIZE);
+
+	pkcs7_parse_message(arg->data, arg->datalen);
+}
+
 /**
  * pkcs7_get_content_data - Get access to the PKCS#7 content
  * @pkcs7: The preparsed PKCS#7 message to access
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 94266f29049c..79b7ddc7c48d 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/fips.h>
+#include <linux/kfuzztest.h>
 #include <crypto/internal/rsa.h>
 #include "rsapubkey.asn1.h"
 #include "rsaprivkey.asn1.h"
@@ -166,6 +167,20 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
 }
 EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
 
+struct rsa_parse_pub_key_arg {
+	const void *key;
+	size_t key_len;
+};
+
+FUZZ_TEST(test_rsa_parse_pub_key, struct rsa_parse_pub_key_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_pub_key_arg, key);
+	KFUZZTEST_EXPECT_LE(rsa_parse_pub_key_arg, key_len, 16 * PAGE_SIZE);
+
+	struct rsa_key out;
+	rsa_parse_pub_key(&out, arg->key, arg->key_len);
+}
+
 /**
  * rsa_parse_priv_key() - decodes the BER encoded buffer and stores in the
  *                        provided struct rsa_key, pointers to the raw key
@@ -184,3 +199,17 @@ int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
 	return asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
 }
 EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
+
+struct rsa_parse_priv_key_arg {
+	const void *key;
+	size_t key_len;
+};
+
+FUZZ_TEST(test_rsa_parse_priv_key, struct rsa_parse_priv_key_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_priv_key_arg, key);
+	KFUZZTEST_EXPECT_LE(rsa_parse_priv_key_arg, key_len, 16 * PAGE_SIZE);
+
+	struct rsa_key out;
+	rsa_parse_priv_key(&out, arg->key, arg->key_len);
+}
-- 
2.51.0.rc0.205.g4a044479a3-goog


