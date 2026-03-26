Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D19310A88E5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0756B0093; Thu, 26 Mar 2026 12:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779356B0095; Thu, 26 Mar 2026 12:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA7B6B0096; Thu, 26 Mar 2026 12:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7A16B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:39:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DC91C3069
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:39:51 +0000 (UTC)
X-FDA: 84588775782.21.581EAAC
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3E7DAA000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:39:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CdYsQLFN;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774543189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHul+QGmCaYYH+cSj7r6hzl0Za0NZYfxsHk+JlDRO+k=;
	b=GVQqN5OPznc/5N6QSslZBYfwVyFkjNSqrRhs4pUkXQJIgSeF+MyXbXEOGpimo0fNDTwV73
	PxeTxfjcYqUZyjRHl0KA78kaU7GCYs3l0qSytvojmAAZrmFawefdjA1eGNawGRwiI+UDKC
	gvCm+bhv1WbGxTiQAKQFOY00+TznnwM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CdYsQLFN;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774543189; a=rsa-sha256;
	cv=none;
	b=CXSgvI88O2mNT3hImoMsbOA0m7F8WSZiN2QXJc3NF70+k+nO9LmD+qX88L676eTRPdwgES
	ZntxH7ZilIU/xUJAZBwzuPZ5qMc1g7Q9gjQv1LMMVTsN1qQHGFlq7F1cAr+eGdh1jT1X1q
	nrCqoz6BhSWxVE/BCLR8zZP8GZ6Ie5U=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50917e02472so13863671cf.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774543188; x=1775147988; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PHul+QGmCaYYH+cSj7r6hzl0Za0NZYfxsHk+JlDRO+k=;
        b=CdYsQLFNX5vcmWaLGCvAGtODwXrkduVT5hMUahRXqn7vyzQoh8qsxFzaiw9j87++DA
         hTBowG9ntZofYlS+qxyie5aaAL0JxCMakv4PmTlF3ZvP1XkyopK82cEt+8JDUQeDC4Pm
         fvpO1KQY57kAn9JWNvd19PE0yVrXVeLlFQ6BpWV2wknYAp8EY25+/j2py7QFfN585rPo
         RsjZ/gF1ZZwMDL0tPIpn+42zHOwO+RF9YmU3z4BDXx/HhoH5xWVfjewf+n9zklQGl/HC
         35wFQVbjexz/1T+3MKdud/Bsdj9/whtVHIHCco0YFlSe581XhV/2Xc1vYPh6SBCknxHH
         84lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774543188; x=1775147988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PHul+QGmCaYYH+cSj7r6hzl0Za0NZYfxsHk+JlDRO+k=;
        b=PgCHtIL5E4vHIwACWkcQl3hKIc3O6iOBKGbx0F7Fyy6uLErjP1kGn3zUYTsWQKaZth
         W1YeCl5vdn71k2SSxNTxZ8pK6iizjtigZ9eME38GLwYHJ5q+XFpC1ZrJDJTj00OiZKOm
         OcS4VNpKOcPnsIl1Uv/um3N7Ql99h/S8KjI70N7swmfRP+DYV6hUsZ6nIdLNTT0qf6+h
         yrsDGKTitFhTa3gQtfwf1FJEu4xaatuftOT8EhaxTbOhUOIkiK4ZOrc9R/s5ffykcfyC
         89tQ7S826UCt4jlYbJeaBEVFFgHQksLfgyBNmR5kJSVFJU9lR7oOyTsV8g7HSJA8721T
         0Q8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUN99oafVGByyNmhRkj+lQPwLOXHfxCWHNcB/wmFYASauGxI/8/Ejo6VOZBsLYpbSGA9HzPppFDcw==@kvack.org
X-Gm-Message-State: AOJu0Yzk00Y3ovwPQ7yQlWwTsQ/F5QhjfjXUD5jGjjsj7iwBV+osEBXy
	Rbed40rg5pQtJ4M5WQ+4P8HFb/OXv9iKWeRva/KfQwPYPq64QowXrxKFENu+fi6r9lE=
X-Gm-Gg: ATEYQzyPrZHiq5uUfrEvr7VC3gRIao8R6tkJBhcKZaqcWqxpVMZrCieZCDMF2nx32Nq
	1aiqbdXS75sKwUl07uh3edLkEMRbTkSzkKiU0l5h3OUuRx3dQ+PmvpINbYHTEUHP4Th4OjkwHuN
	8wJ3RDRmBYIi0OOQ12e+bWbOmnMMBe6uinHhoethIwe46fWs3RoYVfysmT64rHo1qhItasHL0hH
	3JqmFwFfgjAxbdcrj7COSchBj9dQbG/bPyTsQD1RUB38Bf7q76bQV8EeHxVuaN1EzvwAtHM1q46
	FL3vX/iDMpVaa6pgH4rvKUD8+g2oKo6lcnz2KPTCSrzMG6y5FyaAUbVOKrD20c1X8nEeJO5Wg5E
	xI4Ip44EdCwbwsFJuVgqKMN1SJOq9ciCMBky5U48kH70vBFF1FVllGyrte9CGSAra8+oN1VeAF6
	YgpTCNON73vDlFo04wMWKxWlHXl1njAM3aki4+7xjxsybvU3u6Fi80Cr6jpvKJijFHmg==
X-Received: by 2002:a05:622a:251a:b0:508:faa5:4512 with SMTP id d75a77b69052e-50b80e5418dmr113877081cf.50.1774543188330;
        Thu, 26 Mar 2026 09:39:48 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b920f77cfsm28238251cf.6.2026.03.26.09.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 09:39:47 -0700 (PDT)
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
Subject: [PATCH v4 3/3] selftests: liveupdate: add test for double preservation
Date: Thu, 26 Mar 2026 16:39:43 +0000
Message-ID: <20260326163943.574070-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260326163943.574070-1-pasha.tatashin@soleen.com>
References: <20260326163943.574070-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E7DAA000E
X-Stat-Signature: k9gqgzc7zu6ii33aui7unh8hr7ih913k
X-Rspam-User: 
X-HE-Tag: 1774543189-397960
X-HE-Meta: U2FsdGVkX1/OKOpfwuf+GA0FRfs+rCyVCJb2GBnWIoFExAp8Mcj9l+xrqU4J2W0sVTnd3zXKhqRhi9KbQJ4cyLgG87c2tPdvGfyoeelxYNA6W0HiIa7Anq9dp4SraxMtOWmdx1OG7qp0GtOtJI5Ma7fxnHAiWYeIQcRjC7AIicjgeqo47n7/9OVT3fnUCJni98af1SZ1JVWl0JJ9N4y7kDxBoFFPUIoVUj6oBDl/PdRaYSORVLezO3yxGHTS3kWEHRyrWkamr13CmTNGVDh5kFgvmVW49Nm8F/RmjvpgxrnOdK4037DK4vp+plZ+2Mk5Boe5/VldksA7FdUuSGZwFyJCVIuPby6NChzmQW8mwSH/NFBzAl4ZXiXs5FxvTK0bajKj5me9xOQx9/MS9ooAx6Kq3L2TuiIeRLMsC1MfcD20UQrzDQTGmSyhdfsqVNftvklrhPSuaakZQhG18CXS/FHZiKhTjI2QkWjRJgwR3esDDsmf2TEMvyK7CUl5MYAMQnGLZ7FtB9xfBY7MF7L/VyIDTwSpzg3pESttkF96gE1gVQAIV0orByeHAn38pUBL6tuLGxZkUlsGxJ7eWckQ/Z+H7p51NKgmrc0K1EC8zut3ZFDk5+r9O9fAAthYq/XX1IX6wP0p2PJNcqsJS5OeO4In+e1K2w0gztQgUn5AWodMMT/ag8Vk9Eay7ckPKPZm0ucDerrhGjaCEZi4SEYtaOQZJ7ONSk/kUPZKtp2EWi4mScOSygGdJ23q83d6dq2qEpwGTHHjyTK++zDRwMTXX3+Yh9umVFEXOWCkPFsmyqhlSo8PiDiF9YZqrIKZmk9XAtxVCeq+5IrwhyP7SOovMkvfrQ0P9GBGRe/RtTWhNht2ENn9RYd5vejepVZbthKfhh7EzfCr2wQTSaNLhwh28mtfoqkk4QjbXk/QN6WYPNdN4o2m8wk2XCKvTGXDLlBZLDFhxzyC5UhHZTcRTR9
 3mKeiBsy
 SU/MEWoSDRO2fNXqrngFK47eeXGdprkxskyH+FWMWhcMnxc7fExBIx/ndak9dkh+u28wdwkcGDUKlOJq4wP+vqjkXgV8jJIHdSCAbIwmxOJDA74Sa/JNIAi+o7SNeFalEjDUAwtBHSYqLVSgr0h+qps2InS48U5mXFJEMwWHulQmvoKj5Pn796wLBsb5G3KJOsBOcdOOLM8rD83tIABwaD1KnUM1OCnCIadM+nuf5O6LKyJDCoMP7MsguGkKq39nLDI/7wl4eiwMF74mOlibG6XW3hCkVQGN+jUutE0DUM9eEXhNrZFIAPPwVr6bza1RlFjYahquet473KOQ6ymkgd0h2w5GtiM+F1Y+4yLKkF10Ii55xWb6IWnFvIQ==
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


