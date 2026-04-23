Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8498CFDEE53
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06DD6B008C; Thu, 23 Apr 2026 19:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6516B0092; Thu, 23 Apr 2026 19:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA61E6B0093; Thu, 23 Apr 2026 19:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 948316B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:49:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F65C160614
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:49:02 +0000 (UTC)
X-FDA: 84691463724.15.DA07139
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C8FFC000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:49:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bxeMVyK/";
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776988140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsfZ2qn7mJjDdFBLWj4T8+3T0/zctntZPaRw9g3HzKQ=;
	b=TZDpUVaXktUnG6CJn2gHEpV89hyITrgrLWguDM/hx+PyusWU8IUSXFyHFDXfBMqlm4Rm36
	Act0WWStnnnhqNeyV/seU7CeSc0grVAVkPIeOjZOoTQ53sx7E3rp9JnGqM52pVrJYOOwu+
	s76Xj8FB6hUgtqW8px91g64x0nALCwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776988140; a=rsa-sha256;
	cv=none;
	b=3N/k2Y7Ugnrd0QXledZjV28nG4LyJUp9a1ctVVNZt2wVphvcpNobBDTep+Josv+ROHxw4+
	UGrxBn/osa84sKpQkWhyS0ShfncIZo+NYegPQKVHsFkqoie+UKf6oBjJQ+lfkq3nQQ5i3w
	0cR7QV0j6mAF0G7HFeoMDPaO+SHNtWs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bxeMVyK/";
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so88813065e9.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776988139; x=1777592939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsfZ2qn7mJjDdFBLWj4T8+3T0/zctntZPaRw9g3HzKQ=;
        b=bxeMVyK/mvl1fdgfmWVpIJXtLDOoEGserKg4KnPTdRCAX4hKUO6hDgLZfbnUX4iSWz
         lBkex2yD73ruLzBNn/S7YN2HQeh8AKv2DVlTcgjQRMBG/DNyxBUZ/u6V4eQV64HpThik
         O31YPhd+cUoSc713JvksrKJCLlYK3HQunWqwgvpu+N2ffcEYmp+w+naoTxX4v8MbjcHD
         PETGF3AhXOB0w4Ww1c5Q2Jw5QEvnaENuW/0SKhtd7yw7FClNUGeTbcKUk5C/8P4BiAkG
         elo5x5wFdoNrKqvaZx/ebMRBJA+Y3NCGfGDPCFFbqUDWZfimBApOYp4lc0rLRsm0Htj7
         A/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776988139; x=1777592939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zsfZ2qn7mJjDdFBLWj4T8+3T0/zctntZPaRw9g3HzKQ=;
        b=Muy05AQ+JHx7Pjnev6ybSQ80BSz251P4gEx03XqpAtyXTtLbz9u9nsQk9HtSNyVNWu
         4hvJgj3PRLDaCtXekhC+vtjlHjTy4xEN+/ciR4PBaslrDeZodBLc/p+QKo+S6DLvR7Wx
         VFhQYjQJUcYw8cLuwDWGJtd1vfu+zQ8SPfYkaOcetUqh3vKvdKUtfLoI5we+N3LJJq1r
         iAGRMEqOVDCJq+wzmOV8+KNRpQjyD+t7chPp1hyRh8gIjOsFU1X0CucueXvxcqmC5prO
         Qup9iGFgjYIgPf9+edJlhTwvN2TdSgO7k4nb9RJxL0sxAGdDVNk38XCuAKq4D4gr/HTf
         pSng==
X-Gm-Message-State: AOJu0YxHZJMF4btMZKFM6okzkjH2OFpHI8ga5lJJfUopJHYsocDMASYj
	UKCFIPn+k2mNic8nSiura27fp5MYQUMLqYoImo69HU1aSyIiqm6RPu8I
X-Gm-Gg: AeBDieuOCnRT6WvAQJEFNSq723sqKU3MpXLj0oySPOm1hY0QRm+6qSxJijCjjfoqv+J
	IgejsoOcQLnBUhS7oQGU8D7N/M9k6liL1rALXgDJMjnSJmzDNXj/7veHmduZ2D/7ZQ/cOEDay29
	UKcJyOppFYVlFByVylaYAtXXIO/pkGgFGJH6yUNyHdSmsHqt6AzLbcylaUAAgtLFth4SKy/w5jV
	cDrHzZ5hsvrZHAIyt1iDBud+DMmet4YS2fDu7vSPCHaer7wpACG95TV2to6+jwxFkXVaWYHfqMY
	5r+xvVKNrcOIwZ3hygfqXIQU+Lq/cVnALyEY144yse9FsWI7wgFlImnVz7Nce+SSGLbvw4hhmjw
	hvtOaFm+E4v1Lx7lCDAAsoEvMGd/jV9BMlpWIjORcspwAL/tUCZY85+opHAvuKLzJImBjXxYicu
	XEwHkgkO2GbPO0sAcUzGJ/sOh/rvPp1SxguxvJcuQ=
X-Received: by 2002:a05:600c:c0cf:b0:489:1f3e:5f6f with SMTP id 5b1f17b1804b1-4891f3e62a7mr201443495e9.12.1776988138726;
        Thu, 23 Apr 2026 16:48:58 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e8d7:434e:1f34:2cb6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb72d365sm280596905e9.1.2026.04.23.16.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 16:48:58 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v10 2/4] selftests/liveupdate: add test cases for LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
Date: Fri, 24 Apr 2026 00:44:21 +0100
Message-ID: <20260423234753.3873095-3-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423234753.3873095-1-luca.boccassi@gmail.com>
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zboxybza45ayij3c6w9qnai833mdfq8o
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C8FFC000C
X-Rspam-User: 
X-HE-Tag: 1776988140-941158
X-HE-Meta: U2FsdGVkX18vkucNVDqy8beRIUZyg69NC67vGOJG/kVJaiqYOUawdGqLD2SJx1fPP3cvrFPxCPMASK1O8qaRtRUEw4ZMCl1zPjnvMaszHPa0IqCmyy/I1FN/hDKMETCzmjae8kex2YDebNvznfmfsbMOvf0aM02tYgbj1sAJ3BLqW8+EvM94HBAvLbo/4rjLhZ1rg8LZvYIURtGSXPdYzcuBt0ppJY/+lTt6LdQAZ/fCDnZf3zl8OqziJV375x8P2RHZvR2c4cvgIav7QEaw871OxEjF2oUyJzTJBsEt0agE8Nvhbo9sjHBSgkDdg3O5wEav4Yghv0mHRcyXdHtUVy2LnLRi/L5OMBCsNGk8D9/D24m79aJLVsm9bFp2q6oJnCQHYB2qd3UJVdiQoT26W1UAUgelWleeLANytXqwyawBcdshwARv2gRosjVEV8LIpbUHtQBjzmLyFFRBHR1Km+oTdJ6dJxRLTL05hvMnrPk++Arm5VHvivNKzx90BqyIneS7P92MQ5STkkUidTyC/yoa2KQkXK3Th5l/IMuKuyZhVMvOuBuLUn1FypP/eFLDqD8VAGxupJw04nl1ZtWtLDMshjAptYAnqByOtJZO6H4O8PpNL7kgasZxKC1eihGY9iiAFC065zpdP+xtmf4P3fiCi2Si7BxbQ0BCWCP2Dt8rhFqEzFJDcK++cIeAEFE5ryYxrSYqlfRlzZaESSiTNr5YdhYm3Y5nb2YnlWsBT/MDu2+b2Z8gngxXhB5wu7jnJzcp7KK+DpGZl7H0BNidH7T4ZOXC7IMzD8w9HBn4SmIhIJGaOIlC+JmGcaJ4uLClS3mxNVzbQekO9H5FJ2ei49nUQJ3yihDO1HoEh7NE8DQMrEfkRGPUcrUnxiffRphXCySvRZQUPVBCegQySEvk32IgXTm1uPoG9+HvQ81KI1/OZqvdmoVCw5S5bmJ5N3imGO3dJ85820nFrcl84Cg
 jGoLuWvD
 zyiE5CwITEJ/d1Eots2h/Of8u+3PkOYLiATQVbXkQ+SZkPCsq+BGrBdSF3xJXRbl7DSroARYtZ9UDLm/mQaf8UyKwl4zCt3phi1BL/DgahhBy9FwvLhamL/vZZEvmi+EZKtn+4ZmuyREN6jlwEQrWdxKCAFi5nnyskWESR80YGwr5lsRzvTGL14UCehoyOVWSK1ZZzo7QbDgJWTecvnVvhAcqebRp2WYscx7Dz5rg12NgVZ0S6vlwX1MeGImib/E19OP0oWxEDy3VpmHVUwucwGy1fYSYwYNVFuFxss9vnEuiBhI9Nhbxp+jpX41vVwTDB3vqd987ny+g0dI8OaSqPSVs7xrDQdg3n5jYg0KNsFHVwwEFPDAr4OeVwHzLUnyOOqYHI7xeBxFdj5hHfvq5/rElCGtat3Cv9sOQa/m7dycSfgq/ofgaBIwMANoYUTodnarfjCa7lB4pFn2pR/F154+CrBN+m6hYvcEyKO3kj6oPU/vIy90EDA+CS6zo1OSlh4THTwKnqN5WJrI8j27QO+i9CT76oDXndCBQdfUNT6TQe2ny2bliSn0yXQi+/wpW6pATbuwqiUmhKphfjlXgMJj6SoboiQposCDD5YH+tXvY+CvqgkAfLxgqp3S1Wl/IcNkCMPYRlSyVGJuqIWIvsHKdvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

Verify that LIVEUPDATE_IOCTL_CREATE_SESSION ioctl which provide a name
that is an empty string or too long are not allowed.

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/liveupdate/liveupdate.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c2878e3d5ef9..f0a8e600c154 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -345,4 +345,46 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Create Session with No Null Termination
+ *
+ * Verifies that filling the entire 64-byte name field with non-null characters
+ * (no '\0' terminator) is rejected by the kernel with EINVAL.
+ */
+TEST_F(liveupdate_device, create_session_no_null_termination)
+{
+	struct liveupdate_ioctl_create_session args = {};
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	/* Fill entire name field with 'X', no null terminator */
+	args.size = sizeof(args);
+	memset(args.name, 'X', sizeof(args.name));
+
+	EXPECT_LT(ioctl(self->fd1, LIVEUPDATE_IOCTL_CREATE_SESSION, &args), 0);
+	EXPECT_EQ(errno, EINVAL);
+}
+
+/*
+ * Test Case: Create Session with Empty Name
+ *
+ * Verifies that creating a session with an empty string name fails
+ * with EINVAL.
+ */
+TEST_F(liveupdate_device, create_session_empty_name)
+{
+	int session_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "");
+	EXPECT_EQ(session_fd, -EINVAL);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


