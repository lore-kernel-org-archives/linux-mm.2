Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D74D172AE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27086B0099; Sun,  1 Feb 2026 19:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E120D6B009B; Sun,  1 Feb 2026 19:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08B46B009D; Sun,  1 Feb 2026 19:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ACBF36B0099
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67B6FC3068
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:40 +0000 (UTC)
X-FDA: 84397698840.22.8BA0355
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A1F118000F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rc6MbYDC;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqkhJdlpK1W1XSQ5YW44EIDdLoQmf+hCCGZAHvEFwYM=;
	b=7GgtvRLQEIbpzS/iepO22Z54Y0ofR4KMx9gq7KcMnpJsgJxt+QrVlMVydEd6qF6t67zGbW
	u6rCI1VkZ0YlXxcO1HXYiV3q4HEeLU+pW/tYCjZTPKmxOm41UE8YHaq1sN/Af8NQKPESBS
	62FrNREVyi/sFb5+BFbs89dq7Dvpamg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rc6MbYDC;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993738; a=rsa-sha256;
	cv=none;
	b=DGi+20nnjWeHQkRZ0mnBuoQ5ZTvqamR3XE0vljTHLe5I3vnZix2vzJYCfdR/eGCzcISUTG
	n9dPGCb//lqOjpzH3v6jjytIk/oWU5bL6OsX222+ViITqgKSz+KTvANYJSEb0yc78804vX
	pvQgCtdeLZQukhvv7dMPlPhBpDLIdRM=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d196a2334fso3445592a34.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993737; x=1770598537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hqkhJdlpK1W1XSQ5YW44EIDdLoQmf+hCCGZAHvEFwYM=;
        b=Rc6MbYDCvuVIF3TX3LzBv62bi+p9U2Gd1nYA36W2ue5wd2b1j+fVEeajkMFYWQU5TQ
         udvb+aMDYQsxvTyIdkT2NyOUQZyNxqu4MY2jCXHl38hmitklN9Y73y3AjUOkRHaHVEaB
         RY4WgpuTaVVMrpgGoP/k/epgHysLHErXDGhYpIvZ8qADKmiFkFz/BGKK3jVWTxYVCxYi
         VuCKbtVSzV8+KYZQmm2X36pUwoaJbZu+s24VMwpkOW335RgZQXiCcjYeXox0LBa6Tr7r
         z3xoCW9yzZBSjr+DFJJDoQOl8repWVGvxzBNqxopUMtzvcLCHlqLF5aRElW9fPi/AFeB
         HddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993737; x=1770598537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hqkhJdlpK1W1XSQ5YW44EIDdLoQmf+hCCGZAHvEFwYM=;
        b=RFlqIsHeJAoxy2u9ao+B1skCIokhPMd08N5zf9oW/+A5901aQwUplcTDFgyEKbjtmE
         m27lUlft2GJMGpkxDA5Na1tS24fJ7UjzwB1znztSdmm1suIWbNWkkM/g04EV1EepZgYQ
         mvA0L7noTjjAFf50lBMokd/hPSg1mE1e1431hafzeUeP8blRN24adoNnJMVEuttZmDeT
         APQzdFJhUcuT75TGnDUDUhkVVgUfd9HUo85hD+AhHOG6vkcQSjAxWFGzLTMCavI+CTrZ
         lDZifdce2kIkh3y3bKqd2Ne8tPmCQ7jv6QELjGGx9HecsrKeClXn/jc4liZOFDW+QHKm
         w/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVef+y35Ufhf1D4KmeHVoJmZIYSOYWOMzjAz5COzjeHd7aMAYCtdb3nnotre5vdPodVojMN78n0sg==@kvack.org
X-Gm-Message-State: AOJu0Yy2aJpBTU/GMBsRMACPKePcfeQAW18FSlsPXaO8FrOz3yzo1PYz
	qBqsLwqFNGaVRO/mgLZBT5uEEY9qNu4oc4D873nGa6Yoblcm5zdv/yDe
X-Gm-Gg: AZuq6aJ26dhP+th5u8p3ehjgVRGHrcPbxLOyNx1B+7gxDLa/gmpDv4S3yf29W3kAEzP
	fyxDeg82L0HOLEXmAXoM0gCTYw7t5yqMTIrzlxF12BF5iKzsuY8grF1JoHmEEos/MxRJp1uX2uW
	sNkh2klGVy9eKsU9i/9T7nYq5kAu7ro800OeGPiqxmqeB+YjYbG92SnKR4/fW1MZNM6Sn3gu2/y
	7Dl+6fy600jABQlDKxCqjBGOyvcWBV+xXxZIQ7K5tQ/aBS9hqOz4poe5MOWDUMv4t2r/BJ6ltQp
	mGijMNbb6qhi+Emm18aJKnx4747dBZAbweNi1lMJgkMmk02rhy1B09MDcb6wwxVIGdqRLZp1DRH
	PFhBXRdhyOi2WSaAAg2NtaBu6daAaSRqEgpcaZMmVmNK/90ige0p+fMer6tZxYG6XdCfNc6K9MX
	UDgA5XoJVC
X-Received: by 2002:a05:6830:6aef:b0:7cf:d2d4:8013 with SMTP id 46e09a7af769-7d197077d08mr7671450a34.5.1769993737664;
        Sun, 01 Feb 2026 16:55:37 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c825bfdsm9605006a34.29.2026.02.01.16.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:37 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 08/12] selftests/mm: add PUD THP fork COW test
Date: Sun,  1 Feb 2026 16:50:25 -0800
Message-ID: <20260202005451.774496-9-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A1F118000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 5k91q41351tq779jcq64x4gatef9aub8
X-HE-Tag: 1769993738-114023
X-HE-Meta: U2FsdGVkX19CtvxQs6R26Y6O6U89eGn1o6gPSdmRBXyjBo0yAAcLvIlyGWRem/OA/rXDnsYPGzLF0sL/iYVQvjYcgskUtRgv3P/2wprfkGt1kPfnUe4vATx7amVxhVjwL5GPAtfd5H3g8/MmsmdQaNU35lf+M8AZEvUQGvoJ1APVoPsg++wY7bbpgVbATVPhtmNvTsoHMsycnmKQAe04WtFz2HXKmk2eJVNA9ZdMw6KZB5WmPaCqeUYQ+GSm/KVAizqjvLJRr7HrigG1pKvYw+0bRQnN+4OxnyGGNa1+EtI1a2rLSKiya6AtDcMlMcvtXNKiFBvJ+YyC4KBDQ6lLT027A0tOYUOuuulZRjVWnDDa6DWtBjZRb8paqUGR5giOmDJa0wxeuLe+klk8vq1a5kDgchDMTmizMDS+mnBgwae5CamcRTSqmDjfdL7FVTcDcM8B+xbV4bzkXQRadswwMjGxuugK/rzbPxqD+KPeHsCKHIBTcptf3+iXASISEc5NtOZDDHWkf92tI4RBmSRB/M83CyNfQ1TtIkpmXUKtn7ja2h5hPsjabeFxDqAL3zILZ7vNn/HTqBXCiBJjpRv0mQq9WshdzKB6ZMqXZy7qqrLqNHSTda/asIVqnD1eN+Qy/DBIOSY6+myfEmCDu8QrWOPKyB+Q5bAavukPSUF2Rhr6liNlCubLjDRSfyKCgeG9v/NDVL491DFXKZe8iQC2aVQESpB0idMwk/kD5t3uKpxP2RqAXBcmgRUSOmPS4Pt9J+/w6vWiI7b7vIydlP8Re6PkFJHDKL/DKGurdHQCA8NDuU+9jduVGMYoM4vrqBoVothSe/3sfLgFT0d23HiOHxLTWZTkgDYLMrmVwKEs+Ion492cWSpWwG2/o5abjYDQrY2C83+zvnENsjLlrulhQ9Y46lVsluBsJgXJzB3Dx272BiO9gaAvCJQ8eNKVKqr2ZaqBefI73ZWkaywJ9HV
 7PMgYocR
 o1zxdu5dO9hy3K2IflOWRXUu8tjq69HDAityq4Y6OcsxYiD5omi9r33FAL/zOgSI9VZ+ToNq67o/2T1rTJknlqVMe9MyPW1zYofrhotdvfDjt0gNLwNfrq0gB99jQ2ffd2xIqvZguWUg+zqTQcO/hAwLtpmadLfuQecJjQA4Kg5vr+qvtms10RvqbolvKKm3zUvE1PwLnG/WYCkQkRPYnfirpBXtYjlQDWaxqqxmadVtPBXeqwCIGLXBXNrFqSZhP+0dnIX80KWX0fXFYm0pmjbyA/0NfHt7GshLM9Cx4dqokrkgXdEXA4RtmxG245rzVCwViAFfCSDGxwMxsUCDK6GGC/LiX+1Mi+G9XIPV4GuHl5Xf4XaPNc6woFnXvB5LuENRllD13Atz6LNadYTj9LTRcUb5+/kFEJDIS4Gqk1qHh7J6Zdyv3fZOWzGsGPWir/qieOA/TDQZZXFm62X5/IBdwptLMLQ5ncKP+L5krqcFcO1+qqx7Dn8TC0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that allocates a PUD THP, forks a child process, and has
the child write to the shared memory. This triggers the copy-on-write
path which must split the PUD THP. The test verifies that both parent
and child see correct data after the split.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/pud_thp_test.c | 44 +++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/mm/pud_thp_test.c b/tools/testing/selftests/mm/pud_thp_test.c
index 7a1f0b0f81468..27a509cd477d5 100644
--- a/tools/testing/selftests/mm/pud_thp_test.c
+++ b/tools/testing/selftests/mm/pud_thp_test.c
@@ -181,4 +181,48 @@ TEST_F(pud_thp, read_write_access)
 	ASSERT_EQ(errors, 0);
 }
 
+/*
+ * Test: Fork and copy-on-write
+ * Verifies that COW correctly splits the PUD THP and isolates parent/child
+ */
+TEST_F(pud_thp, fork_cow)
+{
+	unsigned long *ptr = (unsigned long *)self->aligned;
+	unsigned char *bytes = (unsigned char *)self->aligned;
+	pid_t pid;
+	int status;
+	unsigned long split_after;
+
+	/* Initialize memory with known pattern */
+	memset(self->aligned, 0xCC, PUD_SIZE);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		/* Child: write to trigger COW */
+		ptr[0] = 0x12345678UL;
+
+		/* Verify write succeeded and rest of memory unchanged */
+		if (ptr[0] != 0x12345678UL)
+			_exit(1);
+		if (bytes[PAGE_SIZE] != 0xCC)
+			_exit(2);
+
+		_exit(0);
+	}
+
+	/* Parent: wait for child */
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+
+	/* Verify parent memory unchanged (COW should have given child a copy) */
+	ASSERT_EQ(bytes[0], 0xCC);
+
+	split_after = read_vmstat("thp_split_pud");
+	TH_LOG("Fork COW completed (thp_split_pud: %lu -> %lu)",
+	       self->split_before, split_after);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


