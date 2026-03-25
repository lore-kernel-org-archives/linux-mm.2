Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1981109C056
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE19D6B008A; Wed, 25 Mar 2026 14:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5256B008C; Wed, 25 Mar 2026 14:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBBED6B0092; Wed, 25 Mar 2026 14:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBD1D6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:20:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 820A6E0F16
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:20:34 +0000 (UTC)
X-FDA: 84585400788.13.B388CF1
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id A4D4D10000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:20:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AsPymY1z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774462832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHul+QGmCaYYH+cSj7r6hzl0Za0NZYfxsHk+JlDRO+k=;
	b=wbfUmHZZgocgLUlFgO0DtBpOaR5ursLG5Qdg87m3O5WJCH6GuogB9epyU1QWbzFjwSw4JB
	5+XLiDkOHVhvdxYjEm7fH59elmfuNlhZC1qkAWdMjoBAC928/CA2Yryn6PVcRMTx3LFfJS
	43lXZJnVPbqOnirrutKXxBVUT1Wqx8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774462832; a=rsa-sha256;
	cv=none;
	b=qVJnquEGwn2iDdp3lmGBqm6kxYTyhbO+h6BUnce6S0LeffBX2hfitKv353tKyCAlZiMX3p
	x0wuEZkNjWoosYSLDNpjQq+Ht8HQIyusko0xrhfPDbxuwVJ8PbVhm+tmz7wpZV5pI4QuiY
	6n7AjHB2z8RhZR6Qh5BV6aW7gY67usk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AsPymY1z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cfbbdbaf3cso8281985a.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774462832; x=1775067632; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PHul+QGmCaYYH+cSj7r6hzl0Za0NZYfxsHk+JlDRO+k=;
        b=AsPymY1zFTGMfDB1njbDT4dTr/GYl8qeQDcaaLkjzKppQed5/dTu51cGKDQ7d+WiHg
         J3vaWtSEv1H+7/73Vp4YiS5Qu7m/IRXMIdQtd9XPrgUsc+Be2rLqoujnO21QX6qSgUGC
         52s1vpcPJUn25Th4lFmHSZRoeUPrs5fszIW6CgKEUAuLCGnupMZsjfBuosTE5MqWTn8Y
         fTU6EiEuQCCRc5A2EolkLcE5UPQBFB6chwa1I2dFQ0Y4L5nyCFX8eqTmMva743qsTMc4
         5LIj7TWWqx/WpAf1I6Pi5yF0rE6BuRoFJygyBokfsALEhhz5vxA0M+kSkciU6MwNe/5h
         BAZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774462832; x=1775067632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PHul+QGmCaYYH+cSj7r6hzl0Za0NZYfxsHk+JlDRO+k=;
        b=KT1uZ7r31d87eZJpi7s774GZeaC6BXQO1UlKlVyxQn572B4wPA00CP3BL8zR4L01Kg
         qxlfhIH1d9rR4mSNqp3BGEGh4Omf1EH7nGF6byQwxpXu0Lt2GlhOaoZwJwz1CKw4y8vg
         AXn+OlAd6cw6UQpD7GpuOe9nNnS4Sex1Lakt8gSNMBom23DPgKCjnSk+iX3QQpAxdHE/
         x+gEtBAWqMU1kP6I6snTk51yOWJ/7+yypURFrGUvySXMTLQPbqsY/ooSa7dRNNTFdNTA
         OiPzl8+Bnw1tkec5H6blSD1huRb8AAtReGL4hqi4N9UpvZFHcLvI0TIbKAnfgBu11QtI
         UR2w==
X-Forwarded-Encrypted: i=1; AJvYcCWBRfA8EI0Ig/8a87yCr2CV4KMq+i/xLjv1uK67yfW+3D16zx5Os4h7BIqDC5/Q5O5Mh3mUhzyFNQ==@kvack.org
X-Gm-Message-State: AOJu0Yyszf51J5Xz/+tijff3U4SWA6cUL8TXppoTubXT1K/UnTzV1GR6
	JcwadIds0MW9r+Zjw8HC12cQCe/fR7Agn48B9g1tvPhCuEsR8jlnnSnfkZQ4xk+jydw=
X-Gm-Gg: ATEYQzyNVB5SMNx1q7SBxlT8z49wgSIh15OhPmMwyTcRhSkoD3FslU9QS1J5ip7qTWk
	EAcvhIUqU0k/FblBlMSCAkZrFoKKbOUrJXPfmyoWAKP/VvYsbaqvHOlwNXYOenmZgRwIlslVQ+h
	DWMViFHXQDk/SGwLyaXv9rM6Zw7FosKeEYg9w9Ba01Cg/RlJQX0xvdqZa7cMzJi4MWKOd2/c2+o
	50P/CiH50gE61FHyv2YkXMksQlHmVh544LvfEnRho4wpDw6OOB5CkcUuLq84M9fK3G0ojBUS+ll
	brZHeD2bSKXGm9C8l6TmJAcNm0SvyI1klrImgY60cdNfP3DPlzZBRjU1vKThQDDiW8pDt/+5JOT
	y01MuzzsLs1MVIFixygN2oVelHTwG47pOjmKg81iAtlHpAZX1akHSX7tWd4zNwTi8uPhUMwQsJe
	lYRkBpxIeRQSJbnS33punfkKN4XobOQRWww97WzdPgxGanCEqtFuaWI1VKqQYKocyRMvGikgwOt
	JN4
X-Received: by 2002:a05:620a:488d:b0:8cf:cc59:c0a0 with SMTP id af79cd13be357-8d0005ab522mr599385885a.27.1774462831645;
        Wed, 25 Mar 2026 11:20:31 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e250556sm64225385a.0.2026.03.25.11.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 11:20:31 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 2/2] selftests: liveupdate: add test for double preservation
Date: Wed, 25 Mar 2026 18:20:26 +0000
Message-ID: <20260325182026.467307-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325182026.467307-1-pasha.tatashin@soleen.com>
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A4D4D10000B
X-Stat-Signature: 1u57377sy9eewzahzogey6ickqigstm4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774462832-672399
X-HE-Meta: U2FsdGVkX1+d1GA5Z/wxq3YvPnX6iTAbWpy9k/fGCBeBQ3igcpBWsN4t7ynCs4NVjLel9LL9eczlKA2TGDvrbxINTkzsk1cfUH4q61b1MnSQv/oWDS+GtORedRiDWSE3A2XS4zFT2R+3Bx+muMzjP+Un2SFjVPFLEybobDDLkrlWAX26oC+hF1Im4Uvr+4s2njeYuNNHBNjaZBpm0noQ88eJl4jI5jH/bf1k5Uoa9p6NHwJsLWnexhe3A8aemLKRjc0GIWTepyHqYagdcL4BjwQYprKWOnOuoLbUMj7OKB7PX87iUht9v5FwZagngdhMXFJFu+a3Uw2Z1VpYXZ7Il7VrGTO600gX/9Sb8Kc5c1VGWY4nLrdZ3jQxxxy5FKJcpJXSnriPwLL0ek698hPOQSAHyMjyejLZweJAbdYmMlo8GSFyvdpABichb5oElkQAHcXdJXfsqq0SVLueae+edz8TVFKmFyKJDeZygaJ6ecxcefJT6Gd5NXUMFUfIEGwX6XUzVSQH3NDSC+j5cMLO4vn+scbr+ZJaW+jpTD7K1Pv2vu3aTv16zMFuFR+75zoBxTHBINpbySC0AncBLj5nASApWEOfBd9IhHBBDk7/5dhGI3Peo7jpFsAMfU/AdTrN2o8gCiXSuisttp+lQ84MY7QPuvWB0xjnLmZkyxbF5oNXmvRSuu9lfO/SBmBOw9pT2OwhroBb0zwztWgK2bhz/Y2J1UA2r5H4dY23nomofRTyTZGRK90mUAh1EJKFI1mf7DacMQOAZkK3Rqnz/vbVy5u1eLZ9m9NUDDYfPDqFfU4MNPfSeskJoCt9zkk+Ikst55i9qEoR1eJvZ5pi/0EFZFw9HRDXWeqoaVzbdKfp8qwggGvLh9uI+1IKmEgb8Wiwgv5qYYEIVx9kXGF5/CEwYUKs4YdtioQvWol5E0szT4+WPE2SZ3jGZ2L6ReQqdBhT+kHod/acPP9BDyzoKt/
 w1p09buA
 cavRNJXvQ+oGK9GLgiZFCkwHOclyXvIrSgm1NXPfHdoAyJuC4EqV/M4sLuSemBu4VE320aSrqqpVliWoQNP3ESlwquJsHetPOnUN7TGbvmaTVkztRmB+5ThjZZUKKa6q+6NKCVO/sfJzUWdqGHGu3DKgYrC0lcgJGdDvbWp/OygnDVLs6LrXcdIyENsWtC6Q0xRfyAswtgbmMbzNLrguflW2QGJGoXkZG+0BLwxAg0CeIDesBZsqmSrhrX21UsF2IcBTcdCQhFWOgKe8NJjY5ym2XK7R6mKfk9vdKLV97FOH+BYNU8avSgHB6O/BO5oTeDz1o+3BtR0ayzbjknRDQ5C13ZEf6Y9080tTMH5j2RPfgzo88ItRZPM+FgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that a file can only be preserved once across all active
sessions. Attempting to preserve it a second time, whether in the same
or a different session, should fail with EBUSY.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c2878e3d5ef9..37c808fbe1e9 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -345,4 +345,45 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Prevent Double Preservation
+ *
+ * Verifies that a file (memfd) can only be preserved once across all active
+ * sessions. Attempting to preserve it a second time, whether in the same or
+ * a different session, should fail with EBUSY.
+ */
+TEST_F(liveupdate_device, prevent_double_preservation)
+{
+	int session_fd1, session_fd2, mem_fd;
+	int ret;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "double-preserve-session-1");
+	ASSERT_GE(session_fd1, 0);
+	session_fd2 = create_session(self->fd1, "double-preserve-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	mem_fd = memfd_create("test-memfd", 0);
+	ASSERT_GE(mem_fd, 0);
+
+	/* First preservation should succeed */
+	ASSERT_EQ(preserve_fd(session_fd1, mem_fd, 0x1111), 0);
+
+	/* Second preservation in a different session should fail with EBUSY */
+	ret = preserve_fd(session_fd2, mem_fd, 0x2222);
+	EXPECT_EQ(ret, -EBUSY);
+
+	/* Second preservation in the same session (different token) should fail with EBUSY */
+	ret = preserve_fd(session_fd1, mem_fd, 0x3333);
+	EXPECT_EQ(ret, -EBUSY);
+
+	ASSERT_EQ(close(mem_fd), 0);
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.43.0


