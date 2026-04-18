Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 562B3F99C8C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E01B6B02CC; Sat, 18 Apr 2026 12:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B59E6B02CE; Sat, 18 Apr 2026 12:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832046B02CF; Sat, 18 Apr 2026 12:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68E946B02CC
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:34:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15D19E1ACC
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:14 +0000 (UTC)
X-FDA: 84672224028.23.B44144F
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 453D1C000E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="S/dtQ0BD";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776530052; a=rsa-sha256;
	cv=none;
	b=4CeeIYOHVXyR0PIcHE7i0lBTEY/5aSC6M3tbVHZ5KKLr+AwVjYqe7RCnGVGRnVS5iJFCNY
	lXmO7B6TfppTnt8ivRVRDhdQ7EGViCnSLEKWHa0yzeMJd+lU/Gqa2OzLBKzifnCUzcwpHn
	f3kC3jCUA9amrErngSyy03GvnLo+FQk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="S/dtQ0BD";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776530052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zt+aOMHTeqB+B7ZTmsYzA3/qbdPzt+krJWN0gXu7/9s=;
	b=eSTcqHxlwJCn7P4maQ6/to1TJZug54yt8bP7LDKSDl5bdZAhZxP5wpvE2LbCfjj4A/Czta
	tQyBZFN6TJeW4hMqsG3rImGRy5cVucBF0jfTX2yNjr+LtgYSNfrUMfmcgbC3SMW3UMj123
	tfXT2FIbw/SS4EjtAeYkL/WM4JgXdMI=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d73422431so1335065f8f.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776530050; x=1777134850; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zt+aOMHTeqB+B7ZTmsYzA3/qbdPzt+krJWN0gXu7/9s=;
        b=S/dtQ0BDKmMhucSPRnL+RhhowZZwvLtTiVTJCW7mE4k4CG2FeG1dKCH9UBYtSgYt7Y
         rR1JsXSD2vPLPYGqfmLDvHSq3T+l9c9evxR7ZLNj07ZY6ZAggQ93dAuwJ+v2SBj6c5JE
         vCWDZO3BCJ5RPlFBeBLrAfWnLFSA6Eph4q7HmQci1Pi7ceuE8RUEXv+9W1498sBFYyTu
         79/MbexGH2tIxyEXHoJJG2D61X9ykL86lsA8+ggTEmZBgcZuM1ME7uPyvCe3SdFbps4S
         K4AXGxKGEaJY3pQ0pn6IE3jj4UzAjjXkimLGdwK2PosumVmZKOrqNr7cAkkPM/s+F0KT
         I7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776530050; x=1777134850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zt+aOMHTeqB+B7ZTmsYzA3/qbdPzt+krJWN0gXu7/9s=;
        b=e1cUu7VbzvVEzzvofUya90Xwg9vR3IV8mn6hkise26HrVyhypeOBQvGvkfZApWJKMm
         ZwGvGTkiQaCxwhKyOi4f14EuaUpmYEArE2qh/vwSEIP73iTtCcgg4ml8JQ6Mme29v9tJ
         QkcdfMtrmGK5BgGjnFqn7Wv2iEWxMCW81twYLVmnlV5O1oBQz2Z7uI9UzGckb/kUwTe6
         y3ciS+x4aJMnCeTJT6DCcNIYRS6qGVZbzmoNlPhYRZ83JBQtjF2pdsQ47+niHefRGNYo
         /o2PZ5Mqo15rcTMQW2yXcF6NB+ZNudgN66QEGfDwgm2wYPx3MC6Z8SLNa7AS1qlRfiHL
         W6Lw==
X-Gm-Message-State: AOJu0Yz2j4XNoutGdkOo/GAj/dR7g5QKW0P8DdNRRya5ni6YIr4oqQoT
	SnQqBiQ6Jfid/ovRlddjT+x4G90LT4XHBo/gCtJZ1qR2/P6yYlJWLX7e
X-Gm-Gg: AeBDieueD+pUOGWJ0AA4UGiCkrssiSFOG2LsN6KA7JGYccyqvCzyjrKOtRsaW728zYF
	i77dI0oxN1uyFsf72wOnZLRJh/jDJX1r8k/5OCcmvgCHfwGpkNBUM37kMsRBLxW+iiabLMnaXfh
	ab7zBGk5GmkIeLO8Vmlc0HDli9FZbkVXmn9fSyARpzZoRzYZ6EwdIrBGOg+1vrP2rUjWy14lxwb
	82l8uYYHhdnpzzUR+qyQMqGUqxQ/F37bWKlT6DJg6RdityUOWkvmZLT7fgBdQBOwCKO2fyH3TM9
	t9IOcrfjfSGGpbuPx0DEhxcH9Nl1R/+ejigrDEoq7ubSO+tGBe3PFUDUTGz6b42aeQppmzDA7uD
	fR92+vBlwY24/wP3mGprkp4fqNKH2DsRin72LOPdiHsE9YFCmrDv3rSE//a2KdweifP1pkk3t5p
	9BOJNpJtfpG4uQCEZeoHg66BCo9A7TGnCxW4ztnm4=
X-Received: by 2002:a05:6000:2089:b0:439:ccd7:cdb6 with SMTP id ffacd0b85a97d-43fe3dd4f9emr11664614f8f.14.1776530050384;
        Sat, 18 Apr 2026 09:34:10 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e054:93f2:97bf:84c6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4cc0d51sm13903755f8f.10.2026.04.18.09.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 09:34:09 -0700 (PDT)
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
Subject: [PATCH v8 2/6] selftests/liveupdate: add test cases for LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
Date: Sat, 18 Apr 2026 17:28:19 +0100
Message-ID: <20260418163358.2304490-3-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418163358.2304490-1-luca.boccassi@gmail.com>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 453D1C000E
X-Rspamd-Server: rspam12
X-Stat-Signature: utbu79w64opkeczrbmcdjajotox85hr3
X-Rspam-User: 
X-HE-Tag: 1776530051-787368
X-HE-Meta: U2FsdGVkX1+d38bRhu/Vj2wTGfisfmmECMlSU9ljnzcCfwYUom+QUVfgEyiwO56AwDLD1lo6+oeAFqXclriPTRX2XICdlvdPgkay5VavJX/6ftCnh8OsxCcxsRNoq5NgLbzo2OFCUhAbZX3dlCbG6VeNzpzkWZB2cHc87eUTxPn2WXYBDC+vCJEQe9yeVVEQZmtD130O3I0HwfeSaUgrSh9qguHsr2pc27iLqE/jkw3PjEeEu6cSTIM5Umw5S2mKsI5DlqKP3Xnj0S3kt6dCPFq21GY3wFw1y5MtLzYdz64bMeVsQbapZlFbohy0srE8N0aAJvfk2+8F3+JPBm3gBJ2RbCc6DAnOvP3OBDyNTaj2xg8bdTo2K/2y30JD6RbCKWabzCATy2rmQ0gp8cvmso0a9iUcKpIyjUsJe3TmFvJBE+fse5uv5Kd4TQ1pfXLHtljCw031nLu5UEwKOeX3VtthZRkgVGNICyjY9hBeq++aYnsowOJKspVEO9T93hKZ8CweoLcbhjOWU5xwnGoTgyIOJsiSFvIR4SiZP9ZFQjcqJ3LLClcjhQv3siASvXfnOw+hWKXZPEeKlHDvV6nWkBv2lJ0bwheouMlDoyQKFIcfdW5zML9j61dhFwj7nOi6q10Zy2y9efeS4c6fzfQ19yFvRlAsbj3CQIyZIrXjgrNesJHPx2uyxdBrEFG4JJ8LgvRYBFUItaz0v3vu1jrscW6onl77FbX+Cd3WxtRY5obKkZ9aG5RLvvyxF2QT/IEbRmhdhLJGQrCdunt2Srzd6WqY0BiOoVTKUM/7XKM0I4LO7wJhBEvAD2hfJw6zsGWL3jprGxHyEtiY8DYc8CzZCc8U83B2pII58pIgEcOoQuzNq6NzUGqBAu8SCbBcZadiZt4zieqe9bhb3oW1zeFYMGW7AgSJxnOeDvWaxaGDDzr2t8wMJJy2WX1gHYNirfyuGUooUn+KiZTC+3htJq9
 z3wPD4id
 23fxg2uTRqIMHVFT6J1mYQfwUNk0brPPB5/T4/EM49r6MBfHsS67IZKtZPtlhXk4zXa22CnpriAkge7GYGFYH9sJ47KvAAeevine2CY7CmbuAMFFPiTnDOdyxO+jZF14Vz5EFoAp4pk2JhFqVH9/Z/IXetZQyuMGwb3Z0uR0u2si86j8XddSnyBXDtts7j1yxUJxAUIbodVtDjX5Yw6gVwyLXMbOmApfh+CHAenb9uhXCkGqd18PiVV6upMRzeN9cBidS53hwoJzMAdnYNf/wGr6R3OQEz2JtolfmK+OKMFKbSsomOXzPrAa9NEhkFEWOP9KCdaXMZkmOMLRNefjgVx/BPYpymXT3bE2R3LM+5KSNHzrlIpsUnnsK5ux3XIhSqOTxdUTApJ5J3wg7m9KR86FP7mcSBzeDtG1qtcZn5IIHt4LIfV5ZLZGY9dnSp9TtolweubbU0iwZDeISFFo+oVDQQI2XSdeD8NaxeB2shFezvk1buE2EKFHCBzJ2t5KWDMbczpMd7Cg3G6r3IgEnvldSC5DUPTfccZ2S1Uryu2hANQqsot1RvzDI+3E55DrDnz0kJ34lT8kDBoDwr57o5rIoqjjBUOm0DjOA6XfMAYnJRNo=
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


