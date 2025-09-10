Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454A5CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7378E001E; Tue,  9 Sep 2025 22:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7438E0016; Tue,  9 Sep 2025 22:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8964F8E001E; Tue,  9 Sep 2025 22:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77DEF8E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:46:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 284D91605E9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:29 +0000 (UTC)
X-FDA: 83871802098.29.690C0E6
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5D5264000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q0cSqE7B;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5izMNdfd73NjWTxfs35XyMLWkMq0RaZ+XCNp0b8x8Kw=;
	b=p+1+2cj5LNJIS4Yb5w2/GxPljzJ23pz70gNt2LuFdfDEqSEgF0lRd6K9uWvrOc1s5J5j57
	EOkg8CkrF0XY9MOxDGAl5SaQX5EdRULowbCov3bg5f+E4HR62Am/b76ql23o5ZcWreOuk7
	d6sXOuaE5oBuwcJUxhJzaGXqzv/gkxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472387; a=rsa-sha256;
	cv=none;
	b=yJw5H1LRB5bowbYTcu9yun4LcUY2Zdoua4O4MWeGD6epcoNgiQ6QgKJMk0Av6hvvrSk7sh
	qkR+7JWekhY4NP7ErAsoc3KCzrCm1++A3BFHxywqBn0L5u7UqgS9zGep+wn2QToiCzuqaJ
	sdFhXkqrf/ubm1fUN3EiMy+ohNJy9OI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q0cSqE7B;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32b6132e51dso4849133a91.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472386; x=1758077186; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5izMNdfd73NjWTxfs35XyMLWkMq0RaZ+XCNp0b8x8Kw=;
        b=Q0cSqE7BX/UN5qY6aaz9Y4WwWlCMeGY1JoWmp665mcKW/iQtaYOeyXDJAtmB6aGiBF
         ZBpg70GiXGvWiMV6qyjQPWzpHXwsfObn/JHjBL/u2eWwYFq7+fHqrtRwNOx0Ql22ZtpF
         vvZNKi9a8/rzviovZ5pqDLvwG3SzIjmFmBKiWtRa/gMzulOKQTeVF5DC8OKmWvrDNQ2N
         7bp+twnJMjqUtVdToLNJ9r29MjT6WwxkmmrTe0D7KOwD9PkG0Yw+Adyjp1g5XMHVBSwx
         59tNn5mTaYIpdfIMBdO7r0h2xRcNDx7T59GcDAKAgzdc9HDECKAWm/2ynZHvkEvkcr1S
         FrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472386; x=1758077186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5izMNdfd73NjWTxfs35XyMLWkMq0RaZ+XCNp0b8x8Kw=;
        b=B/0wgqOelAVsoZMWG+u4kVR4+T8/dEcLJ6PhSuXpaqK8gJWDef7fSszxaQvFcyowl1
         Ao2GSGmytb9XY89WPT0xodfd518NSetQ7H3lidyNQLmr7dRMN2Jq0Z3h+toH0RvXBtd1
         S32almuRXaWoFoP1d6HDhlWINyJF89XzjwL0knsGBFxLIKh+6xx0S3s79tTXEuoifpFK
         0bGHYOMiqEaR364MR51WCPiyxKEVz1/ypGva/0tvicd05t3JTw3ZBV4+t0ytNwKU+hxz
         13/FM4owemp3HZSZnIkOrlCuGqELHHXt3sjdQmb5MAT/mw+k/tXNG9/gKg919qd6GF9e
         aJTA==
X-Forwarded-Encrypted: i=1; AJvYcCUd7rtHouoWy8RYOpU7Vu9UBYsspQ+CuMFWVYMQGme6wz323aiPWBV03KngZlbFwROBTCVtFtLvbg==@kvack.org
X-Gm-Message-State: AOJu0YycODqbxzfXwvqcKi7+6mNLoiV3yl/ynMcBK9LbaaN/CUy8Wv7/
	OA9y9/gLpw1NRh6DdV2s6ES8nz/PoNZElnQ38kUZ+PElLFoUok1qqGTx
X-Gm-Gg: ASbGncs1DSP5qSYOKeuHJcp0rLfmA//MzP/vy1Q7DXRtcBcNv4OqMc2tTPqL7B9dQWM
	mRGNrm85zMg0DtZ9cNTM3gJv7WpIw0grmQadcYkrzlH5eVZqLFjd9N8U5vq5+OxQYCroPleu14o
	I/hCmwV4DxCAgl//bgpn6LthRmve+3zfFeZGo2dw9Ozjd1/lT5XkIFOCWG4VpMKrx2Nd5fe5NqI
	dJQTazonLq+4egoFyql8dKLQw+pPHwDQ+ZWggv5+3COze3OjgtE2LpHt1R9raVMlJPxTemjY1Jn
	t9VL3nD7Eh8esDq4ND2EP32mFrSLbwPsmZsT8oWnkO53LtwlZcti2Ng2mqaEIYwnfnYBcar5d/G
	xBRnodrfxsvFmunqSDfIxo8LDg54hE5/9Zky0Z6ublx+w6AK+flx8AgJvgBjY2lPv+udZizgX3i
	r+N18=
X-Google-Smtp-Source: AGHT+IFFA0J2u8h5eHEE1sSFtoBvIFpNlDK+fp3zE2M7+Wt2ZAEF90FvfrIig1YTqzYNg1uq2BvfSw==
X-Received: by 2002:a17:90b:2688:b0:30a:4874:5397 with SMTP id 98e67ed59e1d1-32d43eff94fmr16672053a91.9.1757472386262;
        Tue, 09 Sep 2025 19:46:26 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.46.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:46:25 -0700 (PDT)
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
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 08/10] selftests/bpf: add test case to update THP policy
Date: Wed, 10 Sep 2025 10:44:45 +0800
Message-Id: <20250910024447.64788-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D5264000E
X-Stat-Signature: nce3411ytjcdqzx84b9r9dp9s1sdtchj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757472387-890689
X-HE-Meta: U2FsdGVkX1+mP+Q2hfjbbYH4irwTb9YwiOevwu6t/hprNRU4ByaHIPdF3WMx8tOjWEMloebgRcfpfPZLlAbGSwsmRYWbslFJCdxQokp/iauW2wX2EmOkwXmwaFdTJENh5YIMkC3TQKshw3umUxh03vEIzEblzKRc/MuE/TBTQezLV3ubkb+3tqLhNjV2Xf0z+jRQ/9sMdPWggwVlwQj1hE/2yJ9LGAzZTbp33I7Y2TLPnE2GCsSwMYUgJ7RfjYFwWi6y8syFfW+vVUyTXTlD8l0NpODKoRcEysOGtBHJ2BDseL1oXU+OsKZ4XbGm3l6GGl5HTZ/wu0h0R1kWGbA4S7SO68S1H+Z8WlN9ysWTw5jl3ytaXdEH4UYpIi7L/LdNxdpVlfALGJJcOf0n/jugYXHwDkKW8AeXB01iP/ziUZ147LabNklYIYx8lEy/qhSYo8fyKhsRM33AYM6gFXObA+1eXo8T83f10+6ZEq7LrOdeSKoYzI/zgMCwEcdlgIhugIgtn0kotCSG/cHVikM4quHSIv2HebbhliR5JBd+KNgVpqS96L5S8E9QtFubOAOO4uoYLOu7izgNXYpMF85XcgrhxCkmRPpr1tGJBEkj7mkCRekkdyA1brMw3EqGxXwrosM6Mnr9teRbUaqLkW4LjaF9iqlmV1r7BL0rpno1064onlK18VUZdmYAc6qwCVH5XMbbkjDPrNCvNCRKDFpim0rYcmjUr79yc+2/f4IedsraLhV3/CKs2zlLGaLrFtGrr93+XeLsnrhHjoqhtNzjCkv4UXQGiOB6+tfnmgbuZuPrVu0B5XaOAkTInSguRQ1N9Z7LTNpSKmhlmdWztB8tXTCJ+MY9kD3Kw1pX4nU6LOc4nBN52ujtCu1Iz2Icm1AJY9sdHq59ntQxTiI4CTYsS8dO3qSUgmtgGGAKyMlQIKsGACAXE5MnqKo6fXVW2FAdZyuOD3e0/MhJxjmvVwY
 2//THTwd
 pUli24oAD4zZBqj42NjuwM5aeQ9FjPfchR566f7AZgRdBHuV2Sp0T4tt8MJtTenNYiDRcFhmj4ZC7daBXmoExqfmqulyzZYsfSQZTJDnRRXIurq9gSJmEfpT/H0eTEePLTYXQ+fObOs2TFPppJULdaAOsfx5rqherWzE73f4EzS31CJ59zcxcXPPJJwUTQnloiXHGSomjj8DLea5pKqe6/rFISbQVgwSdB0MvZxM1WNCsrQ2qse4CCDhAt5V2vIwJDV/861MSmgyf24bobEa1bksMHB71XlvXwQw24kU/wghamsxxQfvXnLFhB8NO5SMv+kOkpsZ7z2UF0Bs7XdyWqlzDBwd6wrmzs2bOet4Hw46RTPeUZzTGQmHWGfEBhgADhcWWORbRFRD24XSlSp2kjda8te/pzGbxEc3etl8ZHitpIoNXkxWY5KIfNgCGtFtG78r+wAgEAgnZQAgZaZxaVJKevK485Rvq0KRMiJvAewyHSDwsDGTSIw4VYpErUqu7hjU4S0uY4s+GL9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

EBUSY is returned when attempting to install a new BPF program while one is
already running, though updates to existing programs are permitted.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 23 +++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     | 14 +++++++++++
 2 files changed, 37 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index a4a34ee28301..30172f2ee5d5 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -170,6 +170,27 @@ static void subtest_thp_policy(void)
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
+	new_link = bpf_map__attach_struct_ops(skel->maps.khugepaged_ops);
+	if (!ASSERT_NULL(new_link, "attach_new_link"))
+		goto destory_old;
+	ASSERT_EQ(errno, EBUSY, "attach_new_link");
+
+	err = bpf_link__update_map(old_link, skel->maps.khugepaged_ops);
+	ASSERT_EQ(err, 0, "update_old_link");
+
+destory_old:
+	bpf_link__destroy(old_link);
+}
+
 static int thp_adjust_setup(void)
 {
 	int err, cgrp_fd, cgrp_id, pmd_order;
@@ -249,6 +270,8 @@ void test_thp_adjust(void)
 
 	if (test__start_subtest("alloc_in_khugepaged"))
 		subtest_thp_policy();
+	if (test__start_subtest("policy_update"))
+		subtest_thp_policy_update();
 
 	thp_adjust_destroy();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
index 93c7927e827a..175e65c5899f 100644
--- a/tools/testing/selftests/bpf/progs/test_thp_adjust.c
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -98,3 +98,17 @@ SEC(".struct_ops.link")
 struct bpf_thp_ops khugepaged_ops = {
 	.thp_get_order = (void *)alloc_in_khugepaged,
 };
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(alloc_not_in_swap, struct vm_area_struct *vma, enum bpf_thp_vma_type vma_type,
+	     enum tva_type tva_type, unsigned long orders)
+{
+	if (tva_type == TVA_SWAP)
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


