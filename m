Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A032FCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068CD8E016A; Sun, 26 Oct 2025 06:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34688E0150; Sun, 26 Oct 2025 06:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25BE8E016A; Sun, 26 Oct 2025 06:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C85088E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:03:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F49B1A03A7
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:51 +0000 (UTC)
X-FDA: 84039829062.23.31E1F9B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id B7A98140009
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PCuZMQad;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761473029; a=rsa-sha256;
	cv=none;
	b=1ZzmuXtpEHI/3b1GBExbmrrxn2hnnIGocFI8/BwcQAH3vxJIBQLoRd1mQOfBVm/2AR5JTd
	qBLpSTIN+unUXT8lDMGcbNpo4G3/0d/luHnwpw1JNueS3G5OvI/gpBRwd+AWV3oJ/b2dvp
	8Q6114cB3xJM5qyBoLC0aq09KUq2rzQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PCuZMQad;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761473029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHI9VYRgU9NCjspHIFvlmxvN8Co/N4RqDwPEZAFmUys=;
	b=BFVVMzYAYYPSCCJxntpXNiNoNgz3lGH3GKYkF058I59kLxJ4GDH1ajAay6THQncHx5LtDY
	D6AUoTYiLtYqBIzTUXUzUscm/RGEHLYD2vi5twr+2EZa9MjYbSuQ+nSBJ5TFUOnBmRjcOb
	1ekDZxkcDzAWULHgxrbXSq5WaqUWALM=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-290ac2ef203so33281675ad.1
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761473028; x=1762077828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHI9VYRgU9NCjspHIFvlmxvN8Co/N4RqDwPEZAFmUys=;
        b=PCuZMQadM837n5f3KzdBX7jh5bGDXCqiNbqgp7a9sZlOw/BGOpcyDyoxbZ+heqf177
         oE5jdsVXSIWlsSTVtzvpClUkHPbIFh7mOx0pCweyIDgo6ycpLG1KKcDVkN28/fXKbnQV
         AaY/jWHMd++4VZjg77CcNjveCTc+jgWdezWcFjvet4d5TXcw46CgB+K69s1B0RR7XqF1
         59zaybP9N1u0r6AMMu0GXa6RcdTLoEvet9yyhpeHk3mE4SacfLRzaPrVk6Q1sZX86tx8
         Y9+JH6gGGG1UnC8tNghJXIlu58yfn69G//v61606QuxV5wWEoYeZJXmcjuMENSTF2JIe
         bx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761473029; x=1762077829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHI9VYRgU9NCjspHIFvlmxvN8Co/N4RqDwPEZAFmUys=;
        b=tbgYcdt+3T2l8djQVFxRzOfWQZkdtfHcze0exaSiXrxQhhVg0S3M59HgSu2BHw9bC0
         wM+O/d9QJSnWM3HdEKwjEdVaGyoeIAY5qqft3i51MA/TuG05L2K3njdKdEpOUPm2s6IO
         xx1tdwvuro7nJiNtN90Ri4ZNcBcv+P5erwLFXC4PwQM1MEqkqHfxOCKmW246JuHLeEGP
         Ba0RFkFx5pP3eoH34xPni/apzVRdfpNae3Ok8QJMqpd2jAJYLV5Cmy4uoQ9zRan7CiqV
         lIv5Ph2BOJXnwbJ4Dx0gueCPQwHnQQxPX/m9uMHcJlMYWVxy2N/VxkkSACf7o2oprUB1
         gV/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUN8NyuFO5zoH8r5MzY8UK5IEKZmb0KWxMud4WWHJgVAlEaT7ECnf2icoF2ZttmdJMhKyGIpGOZRA==@kvack.org
X-Gm-Message-State: AOJu0Ywd6tRR4nA87Gkh31buwmj2p55GKxPP7uW27A2Q9ezu+BEB7aQ2
	1+JrarHWrrt9QUQnq1o8o2iYeEsYoQ+DSFffPU+zFsmemwgIqHJGrNp0
X-Gm-Gg: ASbGncsLiXqD9VBldEeFWFsa4DCX1ke7dzCNowvfqGS/bE2F2AppQe1RsldNdaqgfw+
	iC6nZBdsM1RpacgGEl8wtTBKssmgKu0d/QgVAUTe8EHomuDFUbjiNhP2cvPcg31hrP7gnP0mZ1h
	cMwMI+6iCEk2rCsDUp6cjQvnZoMC88LJYG0HKukC2hy2dg0s5I3c/TqpiNR35MGp5P/xiOfH8mp
	1NwxPmqRvW8ZXMigPb4Jas8b60+/EEGdDF8uuVNWoXv/mRWFbHF3r3WbEZ/9syz28wyueFOZkbH
	JfG+H4/2fjf5sd6E+/v53xq6ZdV0yYa/rL5bf+EP4OpGR584+7iWbfxB76jH2FBS0EJPN7X7VyU
	9W98TvNcC7Ui6gEp2Ez2CG1Nyx0M7px58dyKzsxsYXCMYMOcDdAAt0wr8hZxacTg4XwQDz6wWHR
	jvEs4xX8SlTFu5pRTRJrWFMYnwWcRWD4tV3Dt1i808X3SSnQ==
X-Google-Smtp-Source: AGHT+IE746uda5El8eN5A7OHlfO9WdCrJanAJfzhfCx4DD9HhuvTkdOEUH3TpExhAIltJaJvINgbzg==
X-Received: by 2002:a17:902:f54c:b0:294:918e:d253 with SMTP id d9443c01a7336-294918ed61bmr77101135ad.12.1761473028610;
        Sun, 26 Oct 2025 03:03:48 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.03.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:03:48 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v12 mm-new 10/10] selftests/bpf: add test case for BPF-THP inheritance across fork
Date: Sun, 26 Oct 2025 18:01:59 +0800
Message-Id: <20251026100159.6103-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7A98140009
X-Stat-Signature: j9quuujhnos1df3myiazqmznds4qcu48
X-HE-Tag: 1761473029-261059
X-HE-Meta: U2FsdGVkX19EoGqwarwIAVIW6xJJ1PhJ7PpmdL7NZ7P6V0ofVJdfCBjxnbP7Vh/hy9Pq6aXmMtswwEE+iNaax0KZvyGAbXUvEVPH8sylWWhnBui6WvLbigqFHKDHoDD3nIksm565zVP4mepw/Vnf0NxwYKohnv05IwfExLlbGopuIxZGlKt9mvBQ1hoV9h33tYSzZN6rw6ihBjlb949uMelEa+aHEeGyappLHxWXtS9M1oVhKGnYICRcodxAoqgyjhny5XYUCyrn5TVdz65vsqEaBTNtKQT/w3dR61lOVF8HKDwrLny2CYB8eNI5v81B0ehKtfdGWcO5UQWS62JYIlPbEHdlkbdOFCpSRn2bfPI8equwDpevrt/ueox9RNYp4EIGSuQcTnNJdPTWJq2wMrX+rQgePHD1GngnSrgX0yVZVjhYhiMr/DlfOtKFopnBTLfLdL4PtEMUJKbALtNFqgIKRpnN/GksAlaMzFNYPGaH3GC2f0oIJUhNvCWGSwlmjNlXx+D3VhG30rDMzTjT0nyGNT5qsHnOwz6Zc0rSBhtuaZVLXAeNlWv8qLSk1AVkSdhlbFpo1DJ4okz4Vpla0HJMvDnrEYnHWNLu1//6ePrzxMzd+DpNbFA/Broc+G6owvBn4cec76iebpfLLXd1rrqoZvVhHVocLJyPGesBZ56f0qBdidJ1SkY9VKaw5cu82iKREblOEJYe0WYFgHWCcOXNpAVQnIvm5yCCwHVgtgxvok/DLc340lxzMvxOqA5QbEUjWa8j9wvlpBmg4lFAn8B8UAAlEb5nzBpzBF1+QKVBCT7v24S0zDcSNXBO74GxwEi5QmW9snxpJXdSexNKlodAeOMLU0yM3uPuexO1OUJipj8Hh2X/GvCQ4Hk1mskjh2RtHMVM+s7ks8DIGkaJpXMEB+lCtfP76KVQaU44eL90QwuMHR894rrpYornTvON6YpMIH9Pbu7YXHUSUHb
 FDCd769K
 Qv1cnk3X1WnQKFW6+WautL2ArlcNLVw+buwxMB5/EAI0Hq8PDGL90Cvlpyhy/vRVUdE2Zz47J+Ey/X/Gn8PE54wcX/YxIpCWmweDd/Y4cPQ0+BRw0MnrC6JLI81aAqbGr0YprJ5uHfeBgcpJP1f0ibhwAVp0x39KW5yfc3FoXS08jYjdokxVpcGQfXT63xBlqNnZU+tuJIN8ADcruC2rmqv0sL/Nm1dJeCy7A9wlMmsmfQxT/tytf02JMzCe8GdK4QnnIE6ZFv80+ypXbduU60XS1+gsYAqE/fIlE632Y5xdoucEjpfUcQuTPAGA+eyI3oFG9irEvSrMLRMp2R8BBVTIrJzuSd6p2wOj4HonrVKKSbtR/cnDjY7YW7ixVCHlLrZHitcXd99UDRTYTsCHHY2/EvFHZN9Qtj6FDxWzvgyGvsFKnncVEoBs47Bsb+oVVbT4yaiA0xd6GL5h3rQQtEZTUlZhr+snjt4ow8M1Dac8w7ANBLaTMVBF7p3MLvMoKsJBQqk158inVyzc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that child processes correctly inherit BPF-THP policy from their
parent during fork() operations.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index 0d570cee9006..f585e60882e8 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -267,6 +267,37 @@ static void subtest_thp_global_policy(void)
 	bpf_link__destroy(global_link);
 }
 
+static void subtest_thp_fork(void)
+{
+	int elighble, child, pid, status;
+	struct bpf_link *ops_link;
+	char *ptr;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		return;
+
+	child = fork();
+	if (!ASSERT_GE(child, 0, "fork"))
+		goto destroy;
+
+	if (child == 0) {
+		ptr = thp_alloc();
+		elighble = get_thp_eligible(getpid(), (unsigned long)ptr);
+		ASSERT_EQ(elighble, 0, "THPeligible");
+		thp_free(ptr);
+
+		exit(EXIT_SUCCESS);
+	}
+
+	pid = waitpid(child, &status, 0);
+	ASSERT_EQ(pid, child, "waitpid");
+
+destroy:
+	bpf_link__destroy(ops_link);
+
+}
+
 static int thp_adjust_setup(void)
 {
 	int err = -1, pmd_order;
@@ -319,6 +350,8 @@ void test_thp_adjust(void)
 		subtest_thp_policy_update();
 	if (test__start_subtest("global_policy"))
 		subtest_thp_global_policy();
+	if (test__start_subtest("thp_fork"))
+		subtest_thp_fork();
 
 	thp_adjust_destroy();
 }
-- 
2.47.3


