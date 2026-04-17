Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06705F99C6D
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 22:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BEA66B0155; Fri, 17 Apr 2026 18:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470166B0158; Fri, 17 Apr 2026 18:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CE86B0159; Fri, 17 Apr 2026 18:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11C8F6B0155
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 18:08:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1CE01A0331
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:08:44 +0000 (UTC)
X-FDA: 84669438168.09.FEC684B
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCBC1120007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:08:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CSsiFEkg;
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776463723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rthk+NSBRFXE+6mJljKG6U0ydJhpN840inxjjbjxMqs=;
	b=Noa/kSIOledQHlNMcuIVTSx83iLe0B4BCz4/BmWlqgFvipDMERzlbK0yfk2lAOJ7ymVcKI
	wGfcWD9KGy8pJOIKvW4V8oyT7wxWVDNZrkwFbdt8wGCr5Ma+uyiyaCD3WB7PEit/vTW7/e
	aQzY0sDJXTxWenefPOpAxcVL5vYVg1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776463723; a=rsa-sha256;
	cv=none;
	b=qNsa1u9Mj8I1HG3LasL9HOA2cUD49MvPNKeKfhrNYGq5XXDhbTyaW7aW3LCP3gqvQ0jK9C
	g8VdwvG/EHZ5o/jAzI4l71QwQjvO1a8YNL7Orrfsfnj8ufGG6gN+0McDaE+ktaIZ199Zkc
	jK+QqR00EGuSzjnRiU9ZM78zujsLfW8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CSsiFEkg;
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43fe3e22e33so739587f8f.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776463721; x=1777068521; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rthk+NSBRFXE+6mJljKG6U0ydJhpN840inxjjbjxMqs=;
        b=CSsiFEkgCNJKg+mSYlYI+0BuxHqYzzgjoEQMJEElbJ3Yn2a3bnP9MWTyd9Jaz18Btx
         VI++kc/fxFDFqctW+HIsvaJEd4e/EqkwWJph0BlokFc7MNtX8G78WkDltPlmILY9AfLT
         WoCJUtuSTcISR1Vko7XfTFMBRLxUJ1f0WX2SCcIWPX2KxNHRk2Cp71J2H0A+4IRfy+p9
         PmJ+s+NG4RTIcKzB2MAs5G83vnxeHdWZZrXkEuJUy+1YGoGC+4hj4YcQCBscNdY+6LWt
         uvNaHZwnKj/fj6Su0APQf88C7xSx1J0NhjEiOZixMkwaeFY1H6zhg8WdAiVZxkc20mSB
         wZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776463721; x=1777068521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rthk+NSBRFXE+6mJljKG6U0ydJhpN840inxjjbjxMqs=;
        b=DNLJAJZQgBQTfsYeumQQZSg5WZ3hUqSLu4cyKqC23MOyifEMh7OFlA3X6BtkmKNjsH
         3ZK6iCqDRuHL9XatfRfFfAzFh3xequIeSfzxyNSQggo81GzlWGQdicLxADatvO5ej7Jr
         Yo7QZRJNZ5JxlSJkL7N+Jx23dbuhKXeaktH8gY8jt6/XXb34PJJRP33b8f6K/T54MWxE
         vFtzXV88Guu2Hv/rG8yg1c/hBrBaUJt+Uc0dvbORiCEVWONFWDZYp4Fnq4zKzd8SsxX4
         dpsrySrS7HJIC9PQ6IxAFmQlOs0oPnoP9AEHPYq1y8RyxNwlzubCI3vHvFqM8iP1GAPm
         +zfA==
X-Gm-Message-State: AOJu0YyrqTZU01NMrb6Fd+k//NbsknCLOijrkhzW9O44V4qYsx9dz7oI
	GLpRM5W2/aKJvyAJnQ3bCCgO615udFuptaBuOqPLoMrlAiT1ajKIqGxJ
X-Gm-Gg: AeBDieuEFZJJcWjaQ6WWuYqp2Td9JPOsCo0+Szw7PwSnWgUZhAet5uvuqAWHyV0LwCG
	RvtSDgSGTUKJVfpDx4Z6STjZbjGGsP3OLHqrk0s7VWhyqoFAalRg3X3grCXUclatrMXODkHPS1O
	ADZq/kO11sgCvgrbjmKWG2of2aYFqzLAE5AibH3Ybg89IGAU/XMGgtX6qWNC7K1OpIzuDgIsbTL
	Fq3jlKc+1e3LEhAkvcl6EyO7R1xH7t1Cjqh0GnMmFCyub0vq7VWGRuiVR371gB/wLG/IIme0T3g
	EPWfsFQifHuwDP5FVrNRMCcM4jYgx/ZIflFCSNVRCdH8z1WnGDahADZMjANGHm1EbUrfhPA8LHs
	tuOfTfU5KfiyCSEAjH4ADl1Dm7pK5IvTXJabFDiOWxnAFPdAWgrOCL97XSl47BWwcgyZf0RYmPI
	6itRvAkfSW2ZGv7BAHMhCT86076Ms4wgZkjLA9n9E=
X-Received: by 2002:a05:6000:2dc6:b0:43f:dc54:9493 with SMTP id ffacd0b85a97d-43fe3ddcc21mr7224667f8f.21.1776463721326;
        Fri, 17 Apr 2026 15:08:41 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:9586:30a1:a0a6:f076])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4dc26a3sm8270944f8f.15.2026.04.17.15.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 15:08:40 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v5 4/4] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
Date: Fri, 17 Apr 2026 23:05:45 +0100
Message-ID: <20260417220831.1934945-4-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417220831.1934945-1-luca.boccassi@gmail.com>
References: <20260417220831.1934945-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tucnc7x16cqerebwpppn8mm9d6odqrup
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCBC1120007
X-Rspam-User: 
X-HE-Tag: 1776463722-336132
X-HE-Meta: U2FsdGVkX18ZD/6XMhoAnaSFX3c2SyiZCu3A1jnmdwV3X0x9Rzm0xW8evcPhpgHX8L2Wy8TXCX8BoHnMdkLNb3YpZBehoRE8BHOqrOnjW7RsKV6Icn6RNrkF+Ah5bNgBdWSChDlDvkd+6mezpVfRvWuxk74oA5EtrEuwjzrbT82iUHJI7pPUhB/B9Yyp8+sKmm3lU/O/ZMneKt6IxApKFzalHeztg0M/qPsCFuH1U/XgE2uFTVFamS3WDJDAXjgb4HJuRy85XLFrJJZN9FQYfR6WVWr2k5rLSWM8MTDx81TRk8Ew1NBrtd377/5BZIMyUX4u5Wy2q7/bPuMpLyzW+t3/oLPPHQrtqZ3FYxHMcl16czwayaR05qxWN+ytpBGlMoTLzymJLPDx2s8NK21DQRSq4zdsN0o/OpuzRowNDb5V4isiVzQIAAZyIoPfBD8VqkeaIz8OFxGnL6hoc0K86wbsDI79fm/GycJuPMBiah02777g4/nRn9p+W32goH5tId66bKocUddfdqEdkyMOwKhbvZZaEHDsiPyfz79tAg3ykRP/Hsnh+Bubl0o6ceBOX5cJVp1FZw3OAl52YdEXbiN7Tz2//K4Y3itQygTqoiWn/RPA0dHvIovw09TyAaQB41pI7lAOkQRUArGRUN0KKPHu/ePVYjQuoPHTd95LOqWoUZMLJsrIdGPjM017gn3XlSH1jGzHG1EAl+s1LpmEDqQU3o/TT8K7tfMUz3/GZW8/ky59hOMqnNB1uaY5qpvS1tQkEdYk/kpBuouZx7i0Yka7kRQVf9otiqbDow6zWA3vdDN8QmGC3yh++YHVdkyFtoj+8OZSfmWAPEgIGhCzmqfdGFuJJdqmbvdVydy3v95JAuIz57neza1xCt79Sq+QIbmmv/yRMJqoVlbdFTsWSUQ9ymOUoYI/7AahH925uDIVSAVpQu969HUwpfbT2fjBJ9pka8CEeNyBbrH82vY
 4LbKwsUq
 00RSYh3hllyw6+TvtKnGPtJ5+orzylMIqGVc6yWzJ46GEZF1xBdJBf+nUjMvrcTFk+6QoUD8vBKIaleFhJb7e1mhUqZllCs4XNARJ567kmx2oaUzVUoNHBKXqmERK3u92h8JPAzG1/UYXdGzA6D+1DVY1XJld0CBjPxyzF+PhEsItbsjv+mSZb+rnn4aL5Ke/V3Fc6pTo+LKgkJEbEirkEJlGJiOBHnPBwJ2v1kr8X+AjwtMhe6+F7gxzyrZCk73PjGAgnju2MAQuRCJR771DOXfNBzpIcZHy5e9ujc54AsWAbwBLm1vyGKPoEHtkYt8XCO9qiyF+kl+hvRt0O63v61ZehVqgVwbJrI3HubkhyPaEEAPjeSoNR43D38GIIeExINiTxyKHdV8YyiPT2pVMbm0vDtPNCzqH49kbqrN+pVJnEfr8svPM+ofhsqfnCkdk0fRuvgfnD16XhBl7kUrLdWpumPKhVhTZKXXDNSDTvd3s+O/XPKhONzfE3zhlXHLu0pqXV+qIe+7J4eOkiRllyCfyLmdWdg5aDaKqutyrFbJcuWiWJYFkaqaFOGA+Nd6vxXx3uFx36A8xy2Rg+h6yaUtUHAtSFlEEgnCi8aWimzmgHTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
---
v5: merge with LUO_SESSION_MAGIC series as they both change the same
    unit test file, to avoid merge conflicts
    split into separate patch

 .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index d132b4685f767..f81201b363cc1 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -105,6 +105,22 @@ static int create_session(int lu_fd, const char *name)
 	return args.fd;
 }
 
+/* Helper function to get a session name via ioctl. */
+static int get_session_name(int session_fd, char *name, size_t name_len)
+{
+	struct liveupdate_session_get_name args = {};
+
+	args.size = sizeof(args);
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_GET_NAME, &args))
+		return -errno;
+
+	strncpy(name, (char *)args.name, name_len - 1);
+	name[name_len - 1] = '\0';
+
+	return 0;
+}
+
 /*
  * Test Case: Create Duplicate Session
  *
@@ -385,4 +401,59 @@ TEST_F(liveupdate_device, session_fstat)
 	ASSERT_EQ(close(session_fd2), 0);
 }
 
+/*
+ * Test Case: Get Session Name
+ *
+ * Verifies that the full session name can be retrieved from a session file
+ * descriptor via ioctl.
+ */
+TEST_F(liveupdate_device, get_session_name)
+{
+	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
+	const char *session_name = "get-name-test-session";
+	int session_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, session_name);
+	ASSERT_GE(session_fd, 0);
+
+	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
+	ASSERT_STREQ(name_buf, session_name);
+
+	ASSERT_EQ(close(session_fd), 0);
+}
+
+/*
+ * Test Case: Get Session Name at Maximum Length
+ *
+ * Verifies that a session name using the full LIVEUPDATE_SESSION_NAME_LENGTH
+ * (minus the null terminator) can be correctly retrieved.
+ */
+TEST_F(liveupdate_device, get_session_name_max_length)
+{
+	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
+	char long_name[LIVEUPDATE_SESSION_NAME_LENGTH];
+	int session_fd;
+
+	memset(long_name, 'A', sizeof(long_name) - 1);
+	long_name[sizeof(long_name) - 1] = '\0';
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, long_name);
+	ASSERT_GE(session_fd, 0);
+
+	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
+	ASSERT_STREQ(name_buf, long_name);
+
+	ASSERT_EQ(close(session_fd), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


