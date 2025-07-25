Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958F9C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC6B6B00A2; Fri, 25 Jul 2025 12:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5076B00A3; Fri, 25 Jul 2025 12:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EFE86B00A4; Fri, 25 Jul 2025 12:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1C36B00A2
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:23:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FA401A0882
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:11 +0000 (UTC)
X-FDA: 83703306582.03.30C6DFF
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id BD7F120013
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kdj+MFXu;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460588; a=rsa-sha256;
	cv=none;
	b=jtFK9QNxKI+6AOdKtJF7WfzIU/OvwwSMNda1oNtAyG5U8r/aEruv0Z4fZUv9RGhKpKPHWa
	gNM9twrtKIXdW2tcBG7eGGMeCq5Y+yB0RilRf1EIntD5f4rrgxIHzi+VzEP9EiN6zN3Tw8
	tYahL622tHEotIiu3A2wGhzuAXIFp5s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kdj+MFXu;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kg4daqcmOqhcR1CzrWxL0M/I6a0shgB30VgpkxJSydc=;
	b=I6ZyfKwbITV3tXL+OGkuz9cdlfGvq1+kqYQuGmVrgy7kmnHuxiJyVp0fBqCBEbZYThoSUz
	gbHtuEFW446XKtRmIxttN0wvQs2laUCbNMwonxQoXs9NjKkV0YW5dJ78KZj2x+3L25Rf1O
	Ar8iyvhj4G2j78G+8gqpvv7JjptDxSY=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6fadd3ad18eso19926976d6.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753460588; x=1754065388; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kg4daqcmOqhcR1CzrWxL0M/I6a0shgB30VgpkxJSydc=;
        b=Kdj+MFXutJf3RRUm1mJ20lYvechVDCz+FiuPux32YpchN/OyZtvQa7N3JDG6sE/wpb
         XmcMHluj/JBIeb9kqW0aNgY4tPYxE4Sh86Rbe6lCaAWdeQmQEn+QKIhhfnqnedrO44wY
         vEKjnz6vFdNxnnO9+sssujEU0kkJf3HJSrIvSKz2bFnrsQq7r8vRwnUJuY2I+oX3je4i
         EW5dWlLX8cRmC6fQ5kGlPoRsctcGsCdX25X8dcb+aYG8xVGRJnKGaOOXbLqmswN2DaZI
         GYXqwzvTzrblJvX8VbZpXm51D+awaSfc9y+/DDlkPakCmLJ9BLAyEPSFb6HM5YJ8Qfjo
         49RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460588; x=1754065388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kg4daqcmOqhcR1CzrWxL0M/I6a0shgB30VgpkxJSydc=;
        b=GWahZcrvvVIVi/NmQH+e9Wr5APXGR/ZK+pXOetEpnEKn6RFacl7L32QzIeZrXH0N5R
         +NFWZl8iClSY7duOLPXneZOSjC+DW+4I/l7U0JIoRgg2wa/elSDiiQ3sulupnRndNvvB
         KD3W8INyWcFxXXLzcjgqJxLNuDwwZR/OcYSoQBhRhgpyQzyS/M2f0qB+dhkrKMqDpc1p
         qmZRkpUkKC1bOoqs7LF6KAusphdO5tRnvQeUzv5qDGpqv/8hngJ63gTOoG+6ZLvNuxF/
         lk7rfvUBP3r+x5Dgcd5n3l52XbbJ6pKzN4wToyKJz9I9wv4jfRLyF3MusmsTdfGavloE
         GhIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAhqdJnqfiyac5Pqp2RB4R+XKS2japNM0Ncw6tSyuw+wm149N3dEnKIvjaEbj9guyRrLtM287O1Q==@kvack.org
X-Gm-Message-State: AOJu0YwtJQ1/zqYFtATLUBzv+oUAJnTfLaJylS6TbkXaY0yzADYvItJh
	Z1hDCNl+4WyGzHgKRgpTDIQYCIqLTvdqlRYeD9rqzMIl5Swl7Sujqh1D
X-Gm-Gg: ASbGncvjwFu9JNd7bJ4Ai7B1UbER3m714BWSLYZ/r5hlaf0bjPz7Fw5ubZbnXCAohaY
	jxSL/tKOrcBV3SBeqjCKwJiWreN6cmgEFADSfHGSlEYTo73nTGohCjtXRLZDLTIhKRGdtavZacl
	DQqeCzVy/WiQyC3EFJVv7YKo0TlWJyZkVg81Q7Y6qZWrb0EnFDgACgUgpFPbR84/RXzRTSHNx5p
	AHi9R45N2mq1G7xZVs6DMdn24m9Lzl6pT4OGHo80xbZeo7tQbLO3chItyirIaz8wQdLfwBZU0P5
	AUpwi8Nj6jtKqw5K42ysVGtKaWHnBhyAq2akb18duQFfSdWUO1T4UEMKtlLMWv0vwsume514bdD
	ee+t2x3UmaQwnMe5c4dgbvsPaZ1TQ0Z4=
X-Google-Smtp-Source: AGHT+IGixZFGbIYWOPP1umgQcO8kd0SNYDAa2j8sTfscN1UGv/O9HXscnBrOMp7xCbnGJ+kgRCQEXg==
X-Received: by 2002:a05:6214:250a:b0:707:15c3:e4f8 with SMTP id 6a1803df08f44-707205e9b59mr32272166d6.38.1753460587555;
        Fri, 25 Jul 2025 09:23:07 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:71::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70729c4de30sm1873286d6.72.2025.07.25.09.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:23:06 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH 5/5] selftests: prctl: introduce tests for disabling THPs except for madvise
Date: Fri, 25 Jul 2025 17:22:44 +0100
Message-ID: <20250725162258.1043176-6-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250725162258.1043176-1-usamaarif642@gmail.com>
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD7F120013
X-Stat-Signature: 6xnsqguq8mi6r7et7fnbyoodfkuhuh46
X-HE-Tag: 1753460588-419338
X-HE-Meta: U2FsdGVkX1/9u6Gz7MjxiuFcgzaMBElKlOYGyy1dCuCwUQowLxPjeuAKaVjUzZlYmV4f87eQPhdhGFCX2rjvQy9BAsqKeZQY/r82VkuqbDo+f3L01mcwBGbEJl6DrEwBlQwtmVvisLQ/VaTHuwpe6n+TRA3EwAwU/ZcATNFR3rBGRzbpbKpMwEu0xRqb8LzSZA0vXc7QCf4zRIppwCvgl2CD3KvmZidVk0PPjsxcBSZw6YenU/T2Cg15xg7JcSUFbR+gE0jkAcgHU+dI80uOW3Kt6rC1LgDFxMMfvDwM8zLUqtpxxh5j+XXEacfkI2s7GF6OdcGuJMNZDMzNzSNNW0fsV71ih3KNLijaE7V4rvBo2PEaMYs5NXhLbJBTwNHWEmoB+v6CIKEpSZuFNSVWKD1sSmGHQV/F6DAfB8Brprm/EtmEHj2IK3qXYodWE7E8uK/D81mDvp0ZqmmJosyl43DLZSTYLjPmj79PUJ/K9Etm/75Tz60SpBnFfDlLhR40xy54Me10ZCmDHw6JuN6mMa9PPbHdPDVaH/iaZOYT84KWxULZFsUNWl8x2DlSa+k1lbmb7HwimFeMIRWe656HQ5dXtE+F5LYO4K0mboKYqRzE18AFQYp8RElxjw6ouI3ILbrI9UlrutjOBYyxJ/1a52S9avEW25Jmk6b49upBSSSQgeob+GHm1jbMoZpGyDQ/ZoLShEXmSxjr71kF5KdwCJ2iV28SLZ8xaF9LiZRzTsF3zRjsVAMwXAOljmYbyK0xutJNefqtEY4DRApY5ZRdxMOCWMlqJ/ryEp1pSbid9R/FCvWlBYtklcTcZ9B0O4ipyZAmq3ux601gStav2tDKP1utNsRwlIYafkddDSnUXTI0GtoFDAver/tFJ8vWwE/TnDAweES5xKIaR/FivhMSCLtRY1CBeOlkffidSIjCeEOgPvNEXYTeaC37ZoRlqV4jfcMHNRIezn5s8JolQLR
 LehMvg+f
 qrqGnaloFvpUpOOJPuGhKaPLo3u8yAi4xVmiqJVrLsht7ArBp1YfbeRaWmk/E6bKDuMF9HZMX8byoTXclOUHVWfkdiAh+MkNscWJcw0gHVI5alBWvEpjSw/hj67ic0A8V7pce1RvHwFF8sijh+FTpyVu6fg/RvZcNuFX10aeg0Wh6lko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test will set the global system THP setting to always and
the 2M setting to inherit before it starts (and reset to original
at teardown)

This tests if the process can:
- successfully set and get the policy to disable THPs expect for madvise.
- get hugepages only on MADV_HUGE and MADV_COLLAPSE after policy is set.
- successfully reset the policy of the process.
- get hugepages always after reset.
- repeat the above tests in a forked process to make sure  the policy is
  carried across forks.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 .../testing/selftests/mm/prctl_thp_disable.c  | 95 +++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 52f7e6659b1f..288d5ad6ffbb 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -65,6 +65,101 @@ static int test_mmap_thp(enum madvise_buffer madvise_buf, size_t pmdsize)
 	munmap(buffer, buf_size);
 	return ret;
 }
+
+FIXTURE(prctl_thp_disable_except_madvise)
+{
+	struct thp_settings settings;
+	size_t pmdsize;
+};
+
+FIXTURE_SETUP(prctl_thp_disable_except_madvise)
+{
+	if (!thp_is_enabled())
+		SKIP(return, "Transparent Hugepages not available\n");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size\n");
+
+	thp_read_settings(&self->settings);
+	self->settings.thp_enabled = THP_ALWAYS;
+	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
+	thp_save_settings();
+	thp_push_settings(&self->settings);
+
+}
+
+FIXTURE_TEARDOWN(prctl_thp_disable_except_madvise)
+{
+	thp_restore_settings();
+}
+
+/* prctl_thp_disable_except_madvise fixture sets system THP setting to always */
+static void prctl_thp_disable_except_madvise(struct __test_metadata *const _metadata,
+					     size_t pmdsize)
+{
+	int res = 0;
+
+	res = prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL);
+	ASSERT_EQ(res, 3);
+
+	/* global = always, process = madvise, we shouldn't get HPs without madvise */
+	res = test_mmap_thp(NONE, pmdsize);
+	ASSERT_EQ(res, 0);
+
+	res = test_mmap_thp(HUGE, pmdsize);
+	ASSERT_EQ(res, 1);
+
+	res = test_mmap_thp(COLLAPSE, pmdsize);
+	ASSERT_EQ(res, 1);
+
+	/* Reset to system policy */
+	res =  prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL);
+	ASSERT_EQ(res, 0);
+
+	/* global = always, hence we should get HPs without madvise */
+	res = test_mmap_thp(NONE, pmdsize);
+	ASSERT_EQ(res, 1);
+
+	res = test_mmap_thp(HUGE, pmdsize);
+	ASSERT_EQ(res, 1);
+
+	res = test_mmap_thp(COLLAPSE, pmdsize);
+	ASSERT_EQ(res, 1);
+}
+
+TEST_F(prctl_thp_disable_except_madvise, nofork)
+{
+	int res = 0;
+
+	res = prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL);
+	ASSERT_EQ(res, 0);
+	prctl_thp_disable_except_madvise(_metadata, self->pmdsize);
+}
+
+TEST_F(prctl_thp_disable_except_madvise, fork)
+{
+	int res = 0, ret = 0;
+	pid_t pid;
+
+	res = prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL);
+	ASSERT_EQ(res, 0);
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_except_madvise(_metadata, self->pmdsize);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+	ASSERT_EQ(ret, 0);
+}
+
 FIXTURE(prctl_thp_disable_completely)
 {
 	struct thp_settings settings;
-- 
2.47.3


