Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97FFF483FF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8D16B008A; Mon, 23 Mar 2026 16:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3901C6B008C; Mon, 23 Mar 2026 16:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD236B0092; Mon, 23 Mar 2026 16:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1DF6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:44:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C36A31A0D06
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:44:18 +0000 (UTC)
X-FDA: 84578505396.25.BBC058A
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id E432D100005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:44:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IOTkNDNG;
	spf=pass (imf14.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774298657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4noW3+Hqv98gL/95V6fTB2a+kJKQFh5AF7H7JodbRI=;
	b=MB0yxEbk+z4PzARTOO58gyVqux9PwqdbaUyKaPHJiZXwp9T3ws6HLgpxzzdv3fA51NxrGe
	CGBiIW2RRY8Jm/RIW0GgfjfkOw1jriKn7y18itLFfHMbXoEylENq6cBVDEo5EIcQR7/zDf
	fdsG7OAilQ65WoltvU37JMA2g4igdEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774298657; a=rsa-sha256;
	cv=none;
	b=I+gVFH5mvd5G5fqfR9xEh9jQpJoJUS+z6OtCAltzOYWyHNhKMOw21MKOxEP7J3a0GmJnHo
	kx4rWqWdlwUrNdt0Q7RCcbqLUoWpKZbYZWjpbH1TblG1QKP3EMKcuByM4QokyB8knKPRfp
	BxqPaxy3ZL9furcZ1B4+sjhQTnQPqSY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IOTkNDNG;
	spf=pass (imf14.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aeab6ff148so7615ad.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774298656; x=1774903456; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+4noW3+Hqv98gL/95V6fTB2a+kJKQFh5AF7H7JodbRI=;
        b=IOTkNDNGuWZV4+tyv4PjyPdhPfBYppZY0X7lMjuJXxfsdEcYNrgzt2ViE1rVySXIh5
         V6It61RfMFnf6bPtqy6r2nOa7VJOtd/hGNVQL077XrqyizlFiDoGll+CdKXQr53YgRQx
         dNajg/THAj21yT8inHWcSac6ckIlYLnLc8dKxKuFvG1GLr2BqreB0VL3cDlFjG3VRlUd
         uRsCLXY8B/5xJalUS513pA06IgW7ZvCxcYM+DRzHkXOlxSjT9uCFtR48m3AD1eVsEggE
         +nIl0OI+yMTXXq6MqZB0MAGCcs/HB0nfM/FPlBfpyK/PS9xJQVp1to6xRIYZ+BDH/Akg
         4QHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774298656; x=1774903456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4noW3+Hqv98gL/95V6fTB2a+kJKQFh5AF7H7JodbRI=;
        b=tOoZqvA7PifydboYRFlLA1aS2rHkQRzZV3+tdzWjNP9q3woVX27+GeAUeVVdQ5hy8T
         9XAqw78OEcLCXqpg3tpkww+SonoKFrotGKGee2xk1da4kK29FCJ7af3yBw8RUnmRWdu5
         H/AsHdU1dPz08Ve8aUE4RsbjBGBbtYus2kAFfTrGFTVl8LKFiWFIwPTV0G2ALoenzRWR
         dNafkhls6xVh0lJsIh7DcUegRiPMZhbRCj+DuGtpCnvaNALIQjAc1OEx4fFmXBfuEUp9
         /ktop89XFhayAs0G06uMO0RDKVbXX1jzRBUZUo1QTo1k/53zn2E40AGtUhctkuszJk+1
         Ycog==
X-Forwarded-Encrypted: i=1; AJvYcCVO90ENsq+B/PWRgHHopI61guk6N4qiUe9M+RYx+YSNdohRD8k0r3n1hOkdvJMPP5ywydH55ax7eA==@kvack.org
X-Gm-Message-State: AOJu0Yx562PqHktW4ibq6IOQ7v6hhfYfgEibcHpXA2yax1UeeS5XiPZh
	RtrQQXQY9qonZHDDyxf6Kr3IjYOPho1YtFX9OVHo4xg+2akKbU+Iq0f/nCmXaXFCHw==
X-Gm-Gg: ATEYQzyU4S3idE9SaTlupsOj170SIR/leasp9n7T0LWnFY26+/Y+pEk0oBEaLUrJfHv
	ZwDfk+ukYnIzohHMP2EdegS2yQ0UN9Z1jL13UR7kDUlv0hYOBfAk6J76RXT4iOm4CNeCucG2mXS
	PzkwPWQgIXdxEtnze3zPgxkf1vhmIp7I82pvmw+DfdWgYqjHuRurKa9bVS2BDyt9xF/qaZC4H/C
	yKOXrBAMqkJU0EyWGwms4R/Qqbz/1U7/arwgimzKmY5fJZu8I318ey831tFxFgyPEWZBfNt3BNf
	Kib7ScrLMayVpJT8yCfXUYnGYme+ldwb4TK4N1wm02qSbdXtBhT9yw24/fAvuQkXXoImRJagsAs
	nq6eq9wZwlMQQlG4/GpNmN2ab7iQN16t4vL7KupoLGsFvhhlCL0TEX81+pkyYhd7gJhqHgWgmUT
	blRjusga5JGOVsw3q6SNq/KaTW4lqGl4jEsMQ4/vyfPlOulA0gKbMXjgH49jOwrg==
X-Received: by 2002:a17:903:2290:b0:2a9:5ef5:399b with SMTP id d9443c01a7336-2b0a67336damr205655ad.19.1774298655161;
        Mon, 23 Mar 2026 13:44:15 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03aa79a8sm12398938b3a.2.2026.03.23.13.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 13:44:14 -0700 (PDT)
Date: Mon, 23 Mar 2026 20:44:10 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, pratyush@kernel.org
Subject: Re: [PATCH v2 2/2] selftests: liveupdate: add test for double
 preservation
Message-ID: <acGmFN56v0LS12VO@google.com>
References: <20260323203145.148057-1-pasha.tatashin@soleen.com>
 <20260323203145.148057-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260323203145.148057-3-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: ga1ycunhmrx8kza9hadqinwwsds3181m
X-Rspamd-Queue-Id: E432D100005
X-Rspam-User: 
X-HE-Tag: 1774298656-938646
X-HE-Meta: U2FsdGVkX1+H6V1w5COuNBlssUlDeW8WJJ5sKtKPMwBG3wLFwGFm/1PVWwhiXXiil1ZenYWN88nr8risIJC9eRGo7roEqAwnlm2UX+OY8SGhtIs7N4E80yiaP1tktNHBguC9g9SVofm69M7HDmRFkJMefRx+ZhXOIoOvF4KDoYFMupLIwk4K8dSXOnO1CT1+BEWBx7AgUt+b+3vU+ybRQbqoXM32neT1pNM4HQcafiA/k0bnXQ/8wLKKmdovQW1baeD/gEFATbHNEDbQP6nmDLCZVltwQLoOxLG1K/gbpnQNlFhdcHIVMwsMC8+d7ZKJPS5VSAqrYh/SyMrevaZWBkO6XODOy00Aj9QRSCYEAL/x5ouRT6qTBXpqvRK+vzdkHQUjKcQpLwwKBDNLuuedWz6KjLokDsEMqIM0Tub43nqaURXZ+G5yen+wmDKusFDRS3zyt58l8n49SEmKosajszNPcGhaLHwPJeB+qyPE7TypAjp0HDKH3cPWGBXYRZqDc9wZOeuO/IpwFkS4PiYPg8DmaKT63/5vTpkydfC/sDPU9rPGioaMoa5WkzKNY0b655fNO1v1V2xQpfJyuBMA5FGekDTOkiJzxmkO1WtXCc4rwjf+iipSmWPllaZpL6ty01Hn6wcIthV73wcUWosyhRYor0x9wIKdkTS5ywcKsW6tgrf3GPipOUhQVd7aagHcWz9I/yk29ThQjoZydXs3VMZZRjrgYaCMoC+M5d++spRKsPZ6ZDld3yWgJKGNxeEB7jJ+kwVrmyY6hVyq2NB1FGY9ajUFQJLZGNilXQRfUL99kVDgdGN0XG+Vc7wiu+SyKJtlW6tZSwl0mrAK6DHZRy8fnncMDwOb40DxgSkQppzzZVeODp0Hc5Q2DB7GpTDXtHgYuM9AasZEGHc8bkGkKq23LFUj74cfnVQocYvlFiOEAh/D9n+JrWdnb6EtYhX7DmcXTpCmu0YD6G87QfB
 9vWqz5za
 gHKb9rpy8dBQvj16rg253cbPHPckY92jJNJV89pAE7SfoiucrAnvF5z//kDMBXX9Aob7knEy2BUtzyJR4XgLz09Y/7ycUoY/qckKh0v8ix5ldhKF8fX6/LbyY83bRyNB/fTv9Uk01Pt4FlNaeePQMiuXa31nAy7D8n17GH48QAifd4ZRWwIWPOiezFOjP2lKHBeKJPGy5iCuu6OBFONNmaGAPOUFYBplsc0Qa4lH9Zgc2suFWDgUOUvGY5/AbcH15Xh4DIIzguiILbzGLKa3CCX4iGemcjndtEmcGHjKmubDz03BO8dSzEpN4rCUiQxXhCdAhzgbOnSYN/MkD+KQtLYmkLBJBAIPfJjFA9BOPm7HwYNb12ToGsntTxfimX4+WDwyNYcjJt6JJxi70Bg9Lue+OWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 08:31:45PM +0000, Pasha Tatashin wrote:
>Verify that a file can only be preserved once across all active
>sessions. Attempting to preserve it a second time, whether in the same
>or a different session, should fail with EBUSY.
>
>Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>---
> .../testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++
> 1 file changed, 41 insertions(+)
>
>diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
>index c2878e3d5ef9..37c808fbe1e9 100644
>--- a/tools/testing/selftests/liveupdate/liveupdate.c
>+++ b/tools/testing/selftests/liveupdate/liveupdate.c
>@@ -345,4 +345,45 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
> 	ASSERT_EQ(close(session_fd), 0);
> }
>
>+/*
>+ * Test Case: Prevent Double Preservation
>+ *
>+ * Verifies that a file (memfd) can only be preserved once across all active
>+ * sessions. Attempting to preserve it a second time, whether in the same or
>+ * a different session, should fail with EBUSY.
>+ */
>+TEST_F(liveupdate_device, prevent_double_preservation)
>+{
>+	int session_fd1, session_fd2, mem_fd;
>+	int ret;
>+
>+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
>+	if (self->fd1 < 0 && errno == ENOENT)
>+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
>+	ASSERT_GE(self->fd1, 0);
>+
>+	session_fd1 = create_session(self->fd1, "double-preserve-session-1");
>+	ASSERT_GE(session_fd1, 0);
>+	session_fd2 = create_session(self->fd1, "double-preserve-session-2");
>+	ASSERT_GE(session_fd2, 0);
>+
>+	mem_fd = memfd_create("test-memfd", 0);
>+	ASSERT_GE(mem_fd, 0);
>+
>+	/* First preservation should succeed */
>+	ASSERT_EQ(preserve_fd(session_fd1, mem_fd, 0x1111), 0);
>+
>+	/* Second preservation in a different session should fail with EBUSY */
>+	ret = preserve_fd(session_fd2, mem_fd, 0x2222);
>+	EXPECT_EQ(ret, -EBUSY);
>+
>+	/* Second preservation in the same session (different token) should fail with EBUSY */
>+	ret = preserve_fd(session_fd1, mem_fd, 0x3333);
>+	EXPECT_EQ(ret, -EBUSY);
>+
>+	ASSERT_EQ(close(mem_fd), 0);
>+	ASSERT_EQ(close(session_fd1), 0);
>+	ASSERT_EQ(close(session_fd2), 0);
>+}
>+
> TEST_HARNESS_MAIN
>-- 
>2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

