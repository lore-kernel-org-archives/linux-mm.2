Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479D8CAC5A8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3522F8E0018; Fri, 19 Sep 2025 10:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302748E0016; Fri, 19 Sep 2025 10:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA8B8E0018; Fri, 19 Sep 2025 10:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0429C8E0016
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:58:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C364BBA52A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:08 +0000 (UTC)
X-FDA: 83906305056.14.C5FCC7D
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE21D40012
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iDcpbXi4;
	spf=pass (imf11.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758293886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wa5F8osjsxPwGqDjaoLyZTZuU1vO95PkOFG1IS0GKrs=;
	b=JW//ApLqwE+hiJAy2rmG+WYDSyPpqXIfEbHCh3aUXp48t3OaDqky0qut1biA3yEyjZqRkB
	PJdLv54db6W5oD3VYEY2nLAswwa79vkNInnHLxAeGU3IudX4VoBaNv8+DMIU/P74wrARb1
	QKDQP2VBvoYOZT7ROefiWQzIyuv9sRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758293886; a=rsa-sha256;
	cv=none;
	b=KGZ15KN2oJForhBenMMEFLgdBdPlB311uIAr664hmY+OopCbG+4Schh83WmQRyfkq3nCMX
	J6i7RoomQL/EdB0haHfUykXv1bXyII1wYFaeyEkxbtRCXnxsNW2YlJcMN+fYMISgGnMJ5m
	4XOwdK6as/+sp9Xpa+IhkuztcdbzHA0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iDcpbXi4;
	spf=pass (imf11.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-468973c184bso4285505e9.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293885; x=1758898685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wa5F8osjsxPwGqDjaoLyZTZuU1vO95PkOFG1IS0GKrs=;
        b=iDcpbXi4XQMNmjhZch2d3AHVLfGjGoi4X0uEyZebpLD9xzHbdrMWkBVw60sVz86Mdt
         HOz7yiSiBhGI64Nu/uDkBi8cHkr8znlrsBa09b7SGIxaUcAZ+r4GWLXeCUjIJPqfXy5N
         FqqOQsuchGRD14pVwBPE2/HtAlaaCaCDFgG7K2K426fvOspN1UtM2h/wbUzeWF5gQGQt
         5P9WLWJlCrdgUi+ZbtRQwOyKlEe2GwmALz/1SVkPE8JG5WBehNrYHi/uFXGtWf+5ut27
         n1f+cthCj1llQPKLWtmFFG+1aqhjgeKVhpZK0pI6gmpa+WvNt2X2T/cip3rRxRDSquiY
         HNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293885; x=1758898685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wa5F8osjsxPwGqDjaoLyZTZuU1vO95PkOFG1IS0GKrs=;
        b=id+MMnHNYp2MK0JdJL4dlafKjYCZiXJfDtyM8Pz64pfI2ZFYkXC5IHdmnFl4ZYw4+e
         ZYQ/THXQNI14lCLwUKy09C1aAIfjf3Gn0u/xFOHmo9PW/ZeT1trtfGLTCtmBdJ4Qn7aC
         D+FZuMe8i+KONcqINQjlbkdUhe19sy5TsS8U8tLEaAdPB5b4IIojbA2wsrx4IFQoi+3L
         qkFegs3zzg9+z4Cu8HZvwGBUeARcQRSmnmUFmDAUhT4rzaANlTkqrrNLAG8RH8ZFAFNt
         WiclcP56oV/LAfifvaz+5etrgdHyFyOHbPpnxdaoWVV6yEnSn2UA869S4paqQcJYC8nv
         tCOw==
X-Forwarded-Encrypted: i=1; AJvYcCWIlvxiGu+ed9/BuxWofLKazvxnP8DsTaMU4ihX2WvhB4Ytk8/kwJRDeiibszJkBbvVDIUhxlzUCA==@kvack.org
X-Gm-Message-State: AOJu0YxSbnPb7caC0cVEtapWEOsjEf2lpxPu0lK1IiWdpajEjUbsBlPP
	UVLOWKQ6oNLSlEax0+qnK7ke7hF6im61AAvAUYfgLmQmy4bxdWlT6QrC
X-Gm-Gg: ASbGncvjq2chkaCp4GPQ7lQ/Y/6VnP11357QaN8Cr13O1KosSIqafR2WlGhmPQWxrh0
	Pm+OfgNZTQQiep7F8Sxf4872+mTsZ9mp2eJrrcuKljMoaBXuEH3N16nj1bYgqR/HwfLtnxZwz/F
	yChj3fZsNLOcQELMy/nsa67H4EcPeMnth1UXw19Oh9+6Uw2I3Lr3wKF2SFB94oW7wJ8sxa7RBxA
	Urko8zwMm/hrCibDFPIALEIJWQoczs6ceeDbISg53w8F/xhbZqtqX1ahxqZtUsCKVazwSGdHmhJ
	J+WWVcaQ/0vLiCVjhn0F31fY4ysHEIVXjBiRM2JpHhomgaY87A28CB/bT5KDJUjY4GOckjdcFCM
	+xy19enQfyASKPWNG3zbWrH+Xg++32zsFueGrrQgkl3eQuW5RZ7gsMhwCAdRZIO0A9MB1wT3Qjy
	/qNJ8ZgRshNxdzSj0=
X-Google-Smtp-Source: AGHT+IHdJYIXqz3C4OR8m/GvaJucPOCvchvPgeW6LDDv3ZVv3CkV0oEsEwnK0vfoZjKlHtOSmNp5DQ==
X-Received: by 2002:a05:600c:4ecb:b0:45f:2bdd:c959 with SMTP id 5b1f17b1804b1-4684c13ec45mr31051625e9.8.1758293885086;
        Fri, 19 Sep 2025 07:58:05 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:58:04 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Date: Fri, 19 Sep 2025 14:57:48 +0000
Message-ID: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE21D40012
X-Stat-Signature: prcu33expzgdsdfgj7ary9dy5yd6m6sb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758293886-514842
X-HE-Meta: U2FsdGVkX1+fPxLdKpAyVX/e1HUFOMQ+sLgynKNy7de1hIEdO+N6sRxL+hl3cCPQMTIFIFTT5Z0Xjw5+nuJvvcEVXwjSq/zWrRTMOXttRaE7TaRCyrnWVawvyWjXRCIxMZooh30Fv/smd0jPBk2iicdHOWCQYce20OSKsaFg8EmNpP6cY+pep0T/9JJmkM8uPRlaQkOw9aNxkVrHQ0cEYH5vbo6NGqr03e7lTetzVopm43MTy+xlh1Ls84Vi8pKDtdEnaD6tDrgq0mNoyoNmxA1TTeGCWp3NplVKjkLevWzCgoP4KLpYxttkn80LyFEXqLkqVOY+X6MVGnhTglRrdeEN94TAmsXZ5K9c7Q2yLLec4OBAZrvnGd+PT3lfcILXIAe5brjGH7YGxaTwNjzPUleE5CGd91COGDLDCzz16QPKkrC/hU2qMYNObQo1H65nFxbomesjVHjuJrWvOFO0SrWHanH29VwVpxso7n0qutbWttUvR4u4+1ZlKK4eTQpduvuObzKbTHDMtmahctJYPnWaZeaGOp+xfHzzXTGt/d/qjSCRojmUgtL7YzQq02ZC1PzLoumtDMX2cjRsNQr3fM33KqiFxhOL4tQehtaONhtxOYl5LLhZBrSmEInfO750H0e+MvOM0pxIzs1zf/oqHPZ8jVJryDMkWxMpU6wLBDTJw0K65wYdiPX5I4CX00FjwLATBwkap59ck7Q5Idfcb69Q5vpWfkfBlVd+ERk1sKLktoaRGwuDb9BWCFEHWV8YMrRK9JpO6PNHMoBPKkOdEQb3uDGDdWMXlsDV0jvI5vGmlhZtU7bSx0MwMt4xsW9JwmNuf8HbLHsnWTh6GvVxQHz70AP9rWskI7mVw+AEi/+5QbffqOjzzLuHTXoKNwFIYChX63Jddg9S47INXJ24AQda45fK+zDTdcXKfWWX5jLqvM03R1mPsJ/t3Xxf7MgOkI2wCplx9iWGJQtCk1L
 Pu76zpRg
 RiBwMrPNhE9WF2NV1Bj4rBZN5ZksXaDUqyW5ai5o2O5TDcpKqCMXztgjWt2Bk1Ymg5xPhGiu4TDw98jemDi3roX841jMOUMNFV1saSV0jklypNiJhOkGcRVN7D1+nQsBvHOfswwhWBT9+2/wE2ydW1lFifyH9CkPu3u1NqweyZjNbnnHOXqOTYk5LXIRsAm7C0/Cy6iNb/KIRdq/Tu9QL8tT5TdmgGrIhO1+y0rfGhAJZPXaxWZZfMYwWjkMO21QJbSQqM9YBS9oIb7R4fpCuAWLUk/6fWGeLbkfGBkfAT+G7hlFyCPI0m8P/OtLewyWAUQ/CLTRllXjSzsm7j9r7QTmZGrhaIEKqvWnE9AjEMjsTxzjnk+i0XT3m4NzkyJl7nZXs6slZoZGQ4a2N2zCWQu5tCCsEKWXu/qA8phijkBB4XsgyjpFvfdQSvR3jJ7a7+/lts3nOZDc/JiM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
file under /drivers/auxdisplay/tests.

To validate the correctness and effectiveness of this KFuzzTest target,
a bug was injected into parse_xy() like so:

drivers/auxdisplay/charlcd.c:179
- s = p;
+ s = p + 1;

Although a simple off-by-one bug, it requires a specific input sequence
in order to trigger it, thus demonstrating the power of pairing
KFuzzTest with a coverage-guided fuzzer like syzkaller.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 drivers/auxdisplay/charlcd.c             |  8 ++++++++
 drivers/auxdisplay/tests/charlcd_kfuzz.c | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 09020bb8ad15..e079b5a9c93c 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
 
 MODULE_DESCRIPTION("Character LCD core support");
 MODULE_LICENSE("GPL");
+
+/*
+ * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
+ * that KFuzzTest targets are built.
+ */
+#ifdef CONFIG_KFUZZTEST
+#include "tests/charlcd_kfuzz.c"
+#endif /* CONFIG_KFUZZTEST */
diff --git a/drivers/auxdisplay/tests/charlcd_kfuzz.c b/drivers/auxdisplay/tests/charlcd_kfuzz.c
new file mode 100644
index 000000000000..28ce7069c65c
--- /dev/null
+++ b/drivers/auxdisplay/tests/charlcd_kfuzz.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * charlcd KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+
+struct parse_xy_arg {
+	const char *s;
+};
+
+FUZZ_TEST(test_parse_xy, struct parse_xy_arg)
+{
+	unsigned long x, y;
+
+	KFUZZTEST_EXPECT_NOT_NULL(parse_xy_arg, s);
+	KFUZZTEST_ANNOTATE_STRING(parse_xy_arg, s);
+	parse_xy(arg->s, &x, &y);
+}
-- 
2.51.0.470.ga7dc726c21-goog


