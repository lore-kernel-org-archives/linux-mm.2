Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF9DCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6578E0021; Tue, 30 Sep 2025 01:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ADD08E0002; Tue, 30 Sep 2025 01:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3F88E0021; Tue, 30 Sep 2025 01:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD838E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:59:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3FDA51605DC
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:48 +0000 (UTC)
X-FDA: 83944865256.06.D7C6FFB
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8BB2320008
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PR7nYSpI;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
	b=eN+YxXaAavPvb5bgCrsM1Rx71uD/7PKbmZoeEiZmA9YkzsqGqPW6KK4gU6WsSAeuGxyohk
	1StnilU3lyYolwiU7Upqcssuebxk0q7rf14MdhfesMA9MKI/TRqufwhnnsNPTHZONZ5miE
	QN/pbw1JLS7myNTSIBsxa8Lc42t6m0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211986; a=rsa-sha256;
	cv=none;
	b=ibMSsN0nuaFNQTVoBpja9VfOsEgAP3i7OadQF+u4boZWXWSf7Pub7qAg7jiAdFiQ8+zG4r
	MZHbqdn7cDP3Qb/WxhQw+6PO2pvsDMBWAzCF6+PB05yBNPB4d9YKSAaHYejxzE/HdHZG97
	QYZpQSnNQQF4CeGvV6w1PFdkVXirBhI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PR7nYSpI;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-271d1305ad7so71976725ad.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759211985; x=1759816785; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
        b=PR7nYSpIF+IQSdgOjMsDuaAi5j/7iMFx+MF5OWqGJyB35zOUcQkXgpJK47jrvDcPGp
         VS9E7PTTKNybclBApMo/Hl8Xivw0wK7iB6JcW3Xy53Oxtz6ZaWo3dijau1eE4+i3oW0k
         kZluQ5OiXAxYC2fAp+BpI+VNLHXaHdeWakHKdiW21EnVpSEqYSUbegfwGo5rxVHWu/Iy
         CMupnOxaLWDgy1PvWDWkgiylRh7zSlOEKvKyzVyBC3XT5RQcoX+yKFzipu2NjyUKCG3k
         OOdhOP0x3010TuyKFppyf/O+MnJfr/rUEBmIm00aVcAt7PS/xnNBEEyT6SMMR8sUHifK
         sujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759211985; x=1759816785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
        b=xHZ6mtjrTFRdB509SHML2Y0G4xPSA6Kws4RJIBmuApE8/l6Nbugq6t3NNfcGU1QOb3
         F3yyTBdPTzqfla7mf1XjV8730SszrKQ0Ydo0eOlTQ2hBRUocPzk+hD1ICZ+kGoXg1bJu
         RWFWykVVESCeRh5pHTCRf2g4UhiQKe9R5L5jQFd5hcY8+GwgoET0WaXdqoaNcD+Bi1OE
         v/Y0QNFudrJuw8qGBurpWvBzejN3rLZc6BImPZEtgG17ujNuOs4QfTcqFNY2nEWDbKhV
         Y7fsQDbKqb82z7UrzBYPJTiQuNN2slf/ES1EhvkSdDSO+TYwpUr69SwmqG3yz71x/noW
         26jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXrUnIIrRZcScB+s4goc5Ic/ruf3zbChZGR/n0Vjx+rip7vDM5+OiSwl7wBpr6rkrZwvhqvHtOYQ==@kvack.org
X-Gm-Message-State: AOJu0YwyDwwOVgjwRedc3qGFWWwtO7T6Y9Hp7jm8GKadJNQtWkJ18Tui
	ghAmeAe9HAZCQihfss90Zm1Vy4LFbNRtYHtmHooSSrYvUt3aMmd9v0tY
X-Gm-Gg: ASbGncsFdsM3+UhU3cIEOVAkoFJWqzyJo0c7TNx8gEjmAPsTjgru3HYUsC0rr/JIGfU
	8ctRFhiy0gVN3LRjdRCj5VfZIxbMvlTabJv5V7IC2Q/J5klVZubxbI+rM50OGm8IqccGISIipEO
	oiHGliw+/iOu3YRLsH7HtzWdA8fFRrkZIK9BlC80lfv6ltv8r8qpJh6an+auNhif+7/mpMck3Zy
	JWxI4A+6HVmJyUKnGXV5E5n3+/k2xqjtEW+GQJZyztUyQUsDeH237iQc1mlYYTaTf2wXx/nmpu4
	L46CNI2KdvBLj+iW5ejKCHWSbFgkKiyb9SEJ3ElZVVnJgurZT8N8eXm+aBXYAoP7snAHKvuBx/V
	2ReZqib3IDnm07mJf/IwgDjV9hhAMTAnY+7Fg0lEXgwDEr9R6ag2zuwQxm73u2orsLBfEy7LFFF
	pdeT6ZKjp5hcaYyt6XoyRYQCMQw6tRTIkMQmO9fA==
X-Google-Smtp-Source: AGHT+IHaVympRvUhy+mNwqzkCqg8GQH0WHYHPq1npnx2or9ONNHwBhPtVzKfVWrGEP9ED65uKj4qEQ==
X-Received: by 2002:a17:903:b83:b0:265:47:a7bd with SMTP id d9443c01a7336-27ed49b802bmr208932635ad.4.1759211985356;
        Mon, 29 Sep 2025 22:59:45 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.59.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 22:59:44 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v9 mm-new 06/11] bpf: mark mm->owner as __safe_rcu_or_null
Date: Tue, 30 Sep 2025 13:58:21 +0800
Message-Id: <20250930055826.9810-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8BB2320008
X-Stat-Signature: no5mjtdwxyjwk4ypbktqhyngq9kts53s
X-Rspam-User: 
X-HE-Tag: 1759211986-276169
X-HE-Meta: U2FsdGVkX18UiZZpt4mNoQtkYWltwlNB0O3ZrFM0O39PhnAJ3SiTElpE13iEBizKgTDbMC601EtEkJiZcSZGe122bqx/2JUvuiPjBl/bW3+DtyKlpqlMN92bnwdxldSB5jywI9zqYwwZstC8DoZbfyibsaTg0Gb4NYZnEpqQEjGGof3tKUdcID0qSwQDezs3FtqQFb97FcUedQLvZPMkebNMrWtswaVWZJNJi+l6Aq29GEc1QFb0ZG7rjjFoM+s7vhHW7vB0eXVV5VA+K4G3hdxNv0MDEBB9cNRsjTxK2gx2r7EZioj8iG/gFlLd0h/FRXF5+CpBoZ7c4fdWf1t7N7+EDsRESmoTHZGOTl/yD2IjGmwnzSqJhp7bWMZ4s1tluZnsHl4DxG+RCJzccoaplBtTbG9O+uRVMoBTMv7eeZt0j6+rEX1ktprJjgSNkJ6X4bh0W9YLJM/rO7tMLyqylUvyR+iO+dTe1u/nUW069E8NK1hMdFsKdamz9iRYMsGk56bw+rEHhMFfjBFStVd+vIJjvFBl3irV59onHMV2ePszkkulIxnefsh3+x0+ph7sadsXugzI3UJNNhVwbh/qcKwZgLnf5/bOGgQq6EQLSs+4fLTMIZwHui4UkBqciCCM0xrPSuzqBb1irIoCUXOWqz3J6cYCX7Oj0qA9n4g1uI5z7wkpDutk3xH80Mg618UmfDmG1/fH4U8yOvK24qVxMn1gHllgrZsYAO/oHmxoIjXDCIgjoqmp6XdEE/tBtttuOsiNQl81EeZ5H4uchzM72JLtRV43KUjkvqNnzaxBDogCwUept6nrkRoHFuOrYhrFYkyK/4T33nzt6LvYvSp4qnnKfHBMKZJw9bMmY4lExPSTv8fsYKelMpxohA+50jps8LtUi2vDF78TbbrBuU15oACC+Q62+9ayGSGGhzi4+yHrrcBRDNLrxZGYIm57ZJSXdLyJw4REJ8+ZLRtD/iV
 DdRe0wWi
 BKe8ptPKkxr9HjQ6EL7QQQ76Ahi89AJCZysNXxCudgdlIZOOE/T8puMiWZnahJNGi7j7VVKgjFp6HwQsZ7zWnYBwbOT6NVjM9m04jkZ4CUWfM8pvP9d7bHN+JK2H5HHYoD3LFZE+GP41y812fiyKzvukkIU+pPDOyMr+Ouv0pvq2otjgFdR5RttlrP4587Qrh69u6zKtI4LeXxys4vv+lUolFj2cuJs4FsAv7DH2S0OVFDm8JhtQthNf75A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_MEMCG is enabled, we can access mm->owner under RCU. The
owner can be NULL. With this change, BPF helpers can safely access
mm->owner to retrieve the associated task from the mm. We can then make
policy decision based on the task attribute.

The typical use case is as follows,

  bpf_rcu_read_lock(); // rcu lock must be held for rcu trusted field
  @owner = @mm->owner; // mm_struct::owner is rcu trusted or null
  if (!@owner)
      goto out;

  /* Do something based on the task attribute */

out:
  bpf_rcu_read_unlock();

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c4f69a9e9af6..d400e18ee31e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7123,6 +7123,9 @@ BTF_TYPE_SAFE_RCU(struct cgroup_subsys_state) {
 /* RCU trusted: these fields are trusted in RCU CS and can be NULL */
 BTF_TYPE_SAFE_RCU_OR_NULL(struct mm_struct) {
 	struct file __rcu *exe_file;
+#ifdef CONFIG_MEMCG
+	struct task_struct __rcu *owner;
+#endif
 };
 
 /* skb->sk, req->sk are not RCU protected, but we mark them as such
-- 
2.47.3


