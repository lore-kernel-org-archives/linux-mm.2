Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B7BECAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626DF8E0014; Fri, 26 Sep 2025 05:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1808E0001; Fri, 26 Sep 2025 05:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F148E0014; Fri, 26 Sep 2025 05:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35CAA8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:35:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0049E11A864
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:35:12 +0000 (UTC)
X-FDA: 83930892906.26.C77A54F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 24743C0002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:35:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gO9+9JKa;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rw7WNnQLHMUa0Yn2DLPfVIa+t6BCCpmxXRHnFLCbq0M=;
	b=qy7vBLexqZWuF6v/R/Cv3bHnxPftJjn4j6yD33gA6aSdHyEbaye87y3GuhAr8qAVasEj+i
	N6gRcEx3IT5w/V+n0GICNjASru/7wegg8LFau21ZX1qYCh6N5QCnAzviRBn+b+1ncBFYld
	BXxlOzWr3xVA1vI8Uw2AEycyhHl4Qu0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gO9+9JKa;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879311; a=rsa-sha256;
	cv=none;
	b=tk2aY3HrNKwGJ0SYwdBRehjdVfvu60Zk0AxVr8Jy42RHNaf2bqW5cFiSskzsCV9+tTrlI8
	OSCKja1lU1NcuZIikZ5AnRk2am3MhQF4NcaIUyRGKGd0laIRcZj35vrDuj2+27Wfwmu3by
	ympO8dr5luQ1WvIQltsyphvOrom1+eg=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27edcbcd158so16193755ad.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879310; x=1759484110; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rw7WNnQLHMUa0Yn2DLPfVIa+t6BCCpmxXRHnFLCbq0M=;
        b=gO9+9JKaSa0WorLRKqqADG2YtiudFWByxkE8wG0VuX92XDNYsGTRNgLBX+y58dWczW
         rgU6gsPyyiQWImOOm+wqlwLTfPmmKsNk6x+MS24LFEcHgDDPwUO/IHisF9LtMcSSuXKb
         OX2fliRBE0wQIo9WPo69YfVmY9cuqpn3PQzs7yuUlvdQoLS5NJtPY1NYP51c9B6hSTSM
         1ikMQgiXoNv5fLzv0JPvCMc5RwDJ5C7gCFBjyGujNX3ht/QbRNQTWlCx62WYPxMR/wVw
         4abVWjUis8Xhdu2VIcuLtKc9z0f1IqFB5oiC/Mn9fYvLd08iTieYzJLE9UZqgt802KKd
         6xMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879310; x=1759484110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rw7WNnQLHMUa0Yn2DLPfVIa+t6BCCpmxXRHnFLCbq0M=;
        b=eWQp4QrCYXyP4t+xGMV9G09yJ8XRlE4tHWTLZI4M5bETmBCML6mQLn595cqxnLpmYn
         RmocHMIe2a62KFuVOSDkoFEdyI2bo9SfM+jGHT5LNmfyZ1rhMQdg9Bf0DnpIj2RrT63m
         nYs8i2pIT6XcpAwZ+fzzAFe9cFkWBzT5Krkk7I9OeET71Dm8qgjAQ/hZXiezJYQluU3A
         BJQh+l1YUNmSFxYmHlNtHNJtonKBWO051PoasFMLPjXQxiJWSOZkmMGJvOamLux+BTij
         UmPRTtmh2SmIeHYdIYFzbLtK5qj7UfHrvMwJiGN9sj904urbiWi4owX+m7SM8NpSS6my
         4K1A==
X-Forwarded-Encrypted: i=1; AJvYcCVXGXgv7V3HOj+sbEGEEAWukaYTVxmlcCRIaHAKzOMifaDSVhVBDHrrk1gqqssFKD0IK0678dTRfg==@kvack.org
X-Gm-Message-State: AOJu0YwYTiOlRy+TOS+BX4ujCpXLKahXgzNaVHzotAxY9o90SOOn5FpR
	rDHKI88r8fMzSZlxrnwgbsWe2z67cI06AxwaaUfsDABQ3Nrd9pmBzrpi
X-Gm-Gg: ASbGncsHfGKiy4IqB45m2fMfIaD9ZuKeLu583KT4bW9AI1DxaCN0cOtiFLIS+SkujH4
	1v2L4NFtHZuswNoxT0HI8EVvFOIz5k8HBUXFTwxoADyHEWSNds9BOExMvz6hjd/QdnreucnOxj/
	t/yfVZaCCFmf86Ga/EzMDh1FuHPdYD7+QGPW4r5u7pDRecGegFhOYKkVxT5lNCAJKuBHS6sYc/T
	7L39zHOvkgnPqq6w6DDKEIvBJL2sQ2vZtyqlmn4lcUSwWICnzD7YAsOaEOkbAz3APv6nq/fC0zE
	sgfam5xaofG2h0FeO0tosHZXlk6PUODiSwTmFqO50tqkl6WInPqc4W1DYAdATFna/EAIlVcIbkX
	h41bQC/EsJXG2SvLAlTur0vj8wBJmMtft78SyM08xX+NOCJLJheqgI+XvZjIzk8xebnoVJGBrse
	wJKtosL0spTjwq
X-Google-Smtp-Source: AGHT+IEEuMzIy4jcfzpCO06+83GzrwWygKfi3d1uaHoYRS3Fbpuh2MpzvVbrFawoF8VwJAU/udjvNw==
X-Received: by 2002:a17:903:37ce:b0:278:f46b:d496 with SMTP id d9443c01a7336-27ed4a6085amr60657335ad.55.1758879310067;
        Fri, 26 Sep 2025 02:35:10 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.35.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:35:09 -0700 (PDT)
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
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 10/12] selftests/bpf: add test case to update THP policy
Date: Fri, 26 Sep 2025 17:33:41 +0800
Message-Id: <20250926093343.1000-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 24743C0002
X-Stat-Signature: j8asyd6o69idppt98h39xtsdcdwcdgnq
X-HE-Tag: 1758879310-289435
X-HE-Meta: U2FsdGVkX1/vieulslKaQac4qms4e+fQSf3nnPwW6j0v6rnMf0b7p6dBZkLMVH2C2HrPqqYJ0JqXaP3ATZEjcUDqjW+8z0Z1CJeiotSZfp+8LR+4dEFz58a8cDMvpXql/h1/nLg2y+jfand2is69EBDO4D4JE5aPRxjq+G20MZ0QkvXqnXq84YsdEchEZNhOnz2vi0mW5GTSYZEloeEkzLJtKYGziXNWdc7xTMVAdupibuOn/W3g6/L1b/JspZEwsjqygaGvu/zdxud4dABEr1Hse9Dzyfew14npRn9YK/YdxC+BE2TJTllKWcAlPv8daNOLOAonPppLEPLEoKZJQuaAqyD5JQyBH3DjoBkP5fYAhR9QZTnMNKs4ILhexWHxOHt1EFZKmpGB7JqWAYwiSVxjtn77X5OJ5bFL4q5cZnhtMUle+VYQcUs4qdzOHRyQjC3rzqweQhdUvNwSk61Y5NMxVG0PMMB0087tMymR4vrr8spxfZ4I02pQxFmtZo7Vnoho9HtEPLnDFLYpKSR81ijPoNNNVqh3g72e+nKlO1CoWPEHvcjSwZBRGWOM8YGmt4zn3nFhncdY8KLbPzPJBPI3rwjCai8mUMwW+ZqPQ+0Es/kDRjdlevuwGqdD1wiD+SiA86G8EUeSu1GnQ/MqGlvUCtFaJ8GjnupgRr/1WQJIUizXmtZkoiU8ZvJPx4Su2/7xug5XdWX5S7SRMNkQ8NlxGY07i1W1Q7Ujg++Zc24eT+deeDQK6j201sGAuHXB1zM7Awr2y0AvZ85Fh7kSmmsHGKoz54qTxZWTcFE4yO4qDpi7MCzRTL6g+E++eH3n1BxOFf02BQ7/PSXEmzEt0VxbCflwxJybTayuPmK/PfF/XUOGwcPDl9uCZsFX7lFyn/FtnPt7pq80o4uIiiqFwPVx+xWqN6rSseBgV3lMIRbo0J9PM1/7CpNgTAlFF620t8pELRYC+ghFCHtvT4A
 VHVrMB6S
 4lbtj5tYW2VmKfvNLNSnnjDqtgMYJC02sD8gcbAqip7ooUb+PaFYVM+9KcggcV8V9tJIw1o1L/oGMpdZu3O2SyvmEZ+Wi8N0Zi/mXwq6ytxvEZR/jnKtiAN+pEGlWOELyfX4Y6OIMfahNvrRdI1YZisqyy5uiGciVC59pSQyb+6LRiv2tdF8Xw7RHU/moZH/6hYCJzeVLJ9lGtpv2rV5ybuFrsUztXALweX6lOgU6uxYhiOnD2LBUb8Do5qNn+ByJuVm0xL2zmPMjaqAKd5LXN1ZLp+j5EFkMgaPXYWoAIyoBKYH/1bgGg3wI5fZau36THLAqC4GK8CFlOWgXmRdO31Q86I1Ni1CBHybPbc7Kwa8XFA8VTptZ7qC4/r7OGgXrBuSF6q/3UmT/qJ84/aQyGIDnD4e1eXF7ed10LJFc1E1BeB/HH0f4oQf7XtRY+RN6NtI33WrqlbFFVjC/1brq1e7Dz5Kqf1cG4E4alxSBVGjsW4T+CuiawbLdYjwwpPcNcD3UoIhnvgHFhj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case exercises the BPF THP update mechanism by modifying an
existing policy. The behavior confirms that:
- EBUSY error occurs when attempting to install a new BPF program while
  another is active
- Updates to currently running programs are successfully processed

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 23 +++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     | 14 +++++++++++
 2 files changed, 37 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index b14f57040654..72b2ec31025a 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -208,6 +208,27 @@ static void subtest_thp_eligible(void)
 	bpf_link__destroy(ops_link);
 }
 
+static void subtest_thp_policy_update(void)
+{
+	struct bpf_link *old_link, *new_link;
+	int err;
+
+	old_link = bpf_map__attach_struct_ops(skel->maps.swap_ops);
+	if (!ASSERT_OK_PTR(old_link, "attach_old_link"))
+		return;
+
+	new_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_NULL(new_link, "attach_new_link"))
+		goto destory_old;
+	ASSERT_EQ(errno, EBUSY, "attach_new_link");
+
+	err = bpf_link__update_map(old_link, skel->maps.thp_eligible_ops);
+	ASSERT_EQ(err, 0, "update_old_link");
+
+destory_old:
+	bpf_link__destroy(old_link);
+}
+
 static int thp_adjust_setup(void)
 {
 	int err = -1, pmd_order;
@@ -253,6 +274,8 @@ void test_thp_adjust(void)
 
 	if (test__start_subtest("thp_eligible"))
 		subtest_thp_eligible();
+	if (test__start_subtest("policy_update"))
+		subtest_thp_policy_update();
 
 	thp_adjust_destroy();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
index ed8c510693a0..8f3bc4768edc 100644
--- a/tools/testing/selftests/bpf/progs/test_thp_adjust.c
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -39,3 +39,17 @@ SEC(".struct_ops.link")
 struct bpf_thp_ops thp_eligible_ops = {
 	.thp_get_order = (void *)thp_eligible,
 };
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(alloc_not_in_swap, struct vm_area_struct *vma, enum tva_type tva_type,
+	     unsigned long orders)
+{
+	if (tva_type == TVA_SWAP_PAGEFAULT)
+		return 0;
+	return -1;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops swap_ops = {
+	.thp_get_order = (void *)alloc_not_in_swap,
+};
-- 
2.47.3


