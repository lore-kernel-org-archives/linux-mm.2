Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D850F588E1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA9A6B0089; Mon, 20 Apr 2026 10:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578CC6B008A; Mon, 20 Apr 2026 10:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B846B008C; Mon, 20 Apr 2026 10:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3093E6B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:17:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBE401A0956
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:50 +0000 (UTC)
X-FDA: 84679137900.20.EAFE4C3
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16E9C18000A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZwNzhG3k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2+fqkbJq3L5Dr2igTq44CcXT0ZR7odi5lkKx2bdprE=;
	b=jBx5wH+ezSsP+Uirsi22sCUWw2Idq04AQNBZrUCwRTHGS52QIJLD7+8Lt939FFi3D0Ew2H
	KUxqa52J8ZI0jzz0eTI36HRK8ZVCFpNBHm/6gX+XeeuhlXl7xuZQ5jBNT8TRcygEuCfd6Y
	KuHksKqzfF92WbOrZavWLjo3sfA6rMg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZwNzhG3k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694669; a=rsa-sha256;
	cv=none;
	b=cANSHw0d0fLzM9BmR75THJOcaiySuH9i1I8gYNRTztgO60Wd02xFbGDXdcng/6S1SH4ocE
	/n585nnRMng+iiJNEZ6vG03T/beaxlkV3Ti9Mv02Q+8OxYtLjgvEQwOIPg1Ya44rhs5ohU
	JWRILofp9snPAxqGRFu2iLTOY182j3E=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43cf8d550bdso2821312f8f.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776694668; x=1777299468; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2+fqkbJq3L5Dr2igTq44CcXT0ZR7odi5lkKx2bdprE=;
        b=ZwNzhG3kVJwlqEtByzglOgkNzDT9dlfgz3ySYIYF235IoHl8FWueVUT5HcA6MuHxyM
         2g4cShReH5r17Ua66C+XiKnxtQUsFhMkOUiumI51CMz5VGYDB0nh24ktd9djKSniG3mc
         uBzGAyUOkX5t20UuO/MsvBemGhr9koDijxQVotcGZnqLvMbcxg/SMDCwueCUWlDuJ9Xa
         lkgy5eArzhlzGs3YPZQXc3lJmvT8+KN+GA2w/3mbrlR6a/odJt5l15hjPzTUq/slZqcK
         OSgi9DqfQHFd0bcMCT+Vq/I5o+q8D1B0AUJ0wZjTMIoxXFFrDIeuFyy42+/UhyJTJjPp
         O0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694668; x=1777299468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f2+fqkbJq3L5Dr2igTq44CcXT0ZR7odi5lkKx2bdprE=;
        b=F+O0hNIL5iG0FOcoSV0Ih+YxCYvkteKi/Mn5aAb06WbaepCTcT/cpSJJVYmEXczYMX
         p7DHtfa3L6x/i21JID6XFYlrnmhwp2hVbxRJKpS23byDhQluYNjBavzaXZ4JAZUO+B/l
         t8w6k/KBj5iCGSdvKs8dmC5NnzNOBRFHWI3zZtM3RqA8y/YgqtzD1gWQz1W5abXT4IWJ
         4VcAG4DEZhUor6mvg6eejmTmqvLo9eRo7ywmW+jjkBdY9g3UfdkP7+52avLYJbnmIjWb
         kqZjL7FDgm9nSEpTZf+Yr3zZmFKxNP2oLftnMs+/8Gl3zuSTM4IL/QuQV/ILr3YzaTZN
         qezA==
X-Gm-Message-State: AOJu0Yxqa+jhbTaBSOIQ6IlQ9FK4VAf12uROKulj+hnVASory/M4YK07
	GHII+yNrLzHpjgIlrsNVrmKaUnX3fJ68IFbdZtP59hSqVDRtKDTLrSO4
X-Gm-Gg: AeBDiesbVKYe129YWW30JqsKYqDSnsItQcT06Uny6DEBt7qozCc/HBi98KbokCDTiBn
	tBq8z5iYxpM+PVjQSO5hXGvKS4BN2vwMi5/fBQwBtNsSGQr8dpDRo++no62ne/PjAGpVXN2nGWX
	3Xz2t93iBf2Vxjtobk6W4hwVciofOAqwrKwfCkdWFZmvLP43NVSHf5jZXxWxOygwhu72mqKiZia
	QhPUeE5MJFBm+gQIPi5CdShNV6jDWSDSL+qgMShugY59fCzOWfVuK2GHdLV81VEmEzpAu4Ofxce
	yD78emY0Y112thDVXFf+LSYUy6OXTJMMSGHfmDdqySFliYorOZN3PS7n7elE9mRvpZYyh/QDydy
	l+uRWL/xr/5Sbfw78pZzL25OUsjPQdS6z976rPUi6kQVpbANPWPxqI3E2tjVjvl9Dm8HKluSSgT
	X8HElKM26Oy9iwGXi1o2HZNDso+M6q74KNNWgvi6o=
X-Received: by 2002:a05:6000:186c:b0:43e:a703:3665 with SMTP id ffacd0b85a97d-43fe3e0c6femr21089126f8f.25.1776694667476;
        Mon, 20 Apr 2026 07:17:47 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:355d:3be4:308b:c943])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4cc375dsm26832847f8f.14.2026.04.20.07.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:17:46 -0700 (PDT)
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
Subject: [PATCH v9 2/6] selftests/liveupdate: add test cases for LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
Date: Mon, 20 Apr 2026 15:15:10 +0100
Message-ID: <20260420141741.2688371-3-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420141741.2688371-1-luca.boccassi@gmail.com>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16E9C18000A
X-Stat-Signature: 7sxn9brwkzq9suqswooz59i6pqgnbcde
X-HE-Tag: 1776694668-699658
X-HE-Meta: U2FsdGVkX18YG2ySoOEd/K9HvvsN5wGBxmOZ6AAoj3bm+LTjoiYIlIR6i2j785rA7XXsmLwSEGTJzk0CfpkIH2+JzR4FsVDdC/nnsLO+AOikx0sKkrW5HbR+sPYnHG/0zKgPcRYE5ULfHYklzC8T4lEH/dpiNYNAt/0UbG/bvZBIzNeQAnR2oYuMY46pyDUuxY6N56tcWSG5QXdKOsyKHOiTb5QqeSKlyXV8yfDnLmyOVrM3WzOFhTziA/iyhzbCuIU2bvmwy0BhTuKcw6WiLne5oiUk8hSXW/5+X1B3oJvV5yHXthbLovGMfqj91GaeX68PYrPYQgmu9EDmItUTzV7gQ+UUt+i1zpQUO6jIu0cU9p9M6VNncl6b4w6mpwEjbbE03MAuA0xfcU2jZVE0qJ5oGFqZxKF5EQuMalYkteLFlF5rkC5DJJ6n9+qangbJiJJylVxNZ+mwEFRVA+T7kLQKIQYNl64IU00CsOJRTXA6esmNrJEtgu9cRMAIpPNWlQPdS+tVE+gr2vukkMB3dlB0VVIxLlBUPCLw+L9hE0JC05NmZBHy9+83owTNXJXQR7vYZu+Q1QRwKrVdtH8mYSZIaNMQwyaK4lcGWVpFOxYmuVJe78KNrWBVFLlJAioX58EXQu6ExkCcURpcaoh/RJVDln6/t17QVB3XgxXKYKLrqUMpqQOqyiTKThtH3ByhptHn3X5Ll/A9QJaxH6mBI+noFW7kGNGAORwBGKD4hM8bxqu+bQOEENGdFmeDaVxLPEWl4tnhlALF5sIZFOu/2j7a9LrnNd565rETMZbg2uOhAF7U5DyuDBHxtjbbP/fjdr81UfKJXzPQ5DuxRZSS6xMWO8/2xzYxIIgUOX7Q5NmkyV/BO+vrOp9AAzm8DTs/oX6tByzFShKeA9rcx3CzriUX8Y3+ru3qSXOs39TEpVzoEgy2YWiuz3lJqNEB1lm2pqYYJ0a/K3wqYaFOqx7
 DgWDkiYq
 W0ep5K4zQcJT8/MpdUlsK2S98PAfbjWv//VDEi4JY7v03XaVYOtNmIyfF7ijAJDZo4g1x44p/KwzkxbFYQg3JFsfWRRZwfadMLGgVlLvt+DTNJfXn+GHzeHTvcnZHl8xY8MlsB45aXjCPvrJSfET8WopdUn66DCiLVvP3pl7rSKn5fv3A24hC1eEsj0GdQ/Qcx9uXQKlr8F9Xv1jiiZJSjDeLteWmAgK/smsON2BLOfEOCOsziFiHbtj3sHpz8Sarw7IzmJryz+STJkhAPzSucg2aaw2TMdJlX2ISqL3+o3zGB8VVfJ4zDeM/GLnh5QoDhSmv97mpNd1qTF3szIF/KSnCpwZgmD3pj8DwlWCoGTqVcDCaAEt4bT8QnHKtGaJU/zDrn6cetKw1se92fwhmYz2xCCI383DRJsJjWqAXGjcDaSdZtJQ8HDjnxQ9qhvBQzdHiOl2tV3doWNGXjTKhJpxOGhSjrIjsjmBAtz1wreI1WCdMM+beEjlWC4+aEnqelYILYiIpPRqdQ18oUavE8VE50fyucJdwWVoh+g2PUeUX4rZWeTGtQxqZdLsFUr9HB+kowiA+JDJDEQ/tXoSZu8K/Zkumdm/GCUdgkqdiuTwTD2YXhT8sRBsnarMhC4WFrTbO
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


