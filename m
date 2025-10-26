Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E913CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60388E0169; Sun, 26 Oct 2025 06:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11118E0150; Sun, 26 Oct 2025 06:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9808E0169; Sun, 26 Oct 2025 06:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A50108E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:03:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7321FB8BC6
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:42 +0000 (UTC)
X-FDA: 84039828684.26.9839936
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92165C0005
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mi6wTnVA;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761473020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4o89aqQquJfXg8DHNFFwhPZpHBrXkamiWZUkDvNw/U=;
	b=bpjuPnn4vJFypDH0PANe6BouALS8McO2QbT2RIy9dR7WVtD8yYkQVWMrQSoRqTxRndHhvs
	RBvwvOjW5+Il+WOyfJWZ+mAOT/SK+WW3+eFYs+jxO/Y3b/BwuC+wy3aPnSr+EfeTRD7KaT
	Wdq4GeurnvPNvAOZknWzv8wgaj5tWI4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mi6wTnVA;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761473020; a=rsa-sha256;
	cv=none;
	b=iv48JPkBGmuf/ZtKIx6Xe8CcS+vQ2JAher2B2S5JkOVg5UL1RM3s0gTK8U0ULcIW+mVqkN
	FUAKW5xLaOLPp/Cx4mBNBg1oBQGY0h6CFluB1oJDSAlfdgtTcDzksByryFQg7QRe1gtyRY
	qH6CLrMwpPEYtWkoGnONO2G5a7TQr10=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-33be037cf73so3825831a91.2
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761473019; x=1762077819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4o89aqQquJfXg8DHNFFwhPZpHBrXkamiWZUkDvNw/U=;
        b=Mi6wTnVAhbKcOMNV/Me0Wq+HFqls+aKsZ6ivCsqjyReuhNjHVeyvxYuMe8rWPlCBHs
         4BMT3OXAb/Jd1HXPbs+xzu/ZjWxqGrRcK6CblXds/dwsL2lIXjVh+CSXIQD02sBRRcTf
         //YjWAQS7/7ZkLBfC1MlOoEOSLahLw3QOr6kPxuAp/RVC81xWLQxRVbN6Z15vB2H4E1D
         qPlDKLGkidNQe25Nb6im2pf4l78hf7BaDj2LDYCtCSeJeRnTDiUE7iddArwm7L0befqp
         uU6Qxa7utHlqt9IbQpRDYJ8KSqR+gUAwo6vRkXPjqGadt337IqCInNhRcf7CwrE8h8u6
         7iZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761473019; x=1762077819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4o89aqQquJfXg8DHNFFwhPZpHBrXkamiWZUkDvNw/U=;
        b=fAObqRxuepRPxHnSff8nnKBVn0J3uRB3uecn0QwCZvKxOjOOfNfDjOrGfUjW/Y0qJm
         qeSfWEmCeR4n6t70he5wh3XMDLAcWVtq0zxjgM2JscCr9qKQSjQdpbzj+vs/LeTL+89h
         xYi8WcwqN0Af0GU20xOFg6hb5ZQQtZGmcWMEOYEYmUK3dBI/uTWckkD825GZRMA0p0KX
         O3VMPuGyKe/Z46YsdDow8LTWoV6z+UlTOPfJlZJGJiCQJlmVMtvi72WtfJPuYz7mlfUN
         ce6kgUirER+pkrCsA1DlooaGnl7Tv+fe/uKvEfSzwtgeE2oRhIzCQB2NXOlD7WA0j22U
         aGNg==
X-Forwarded-Encrypted: i=1; AJvYcCVgyi5Zi5/trp8zv3tZMnZnTueNS+QLYE4K/PaVoBfyVOM53RLrYnkUKa94SC6gXMFTfKXSqKtOAA==@kvack.org
X-Gm-Message-State: AOJu0YzHbkHa/jkScGhJ4QotnN9jUCo1OHy5aWWXIHq6IsDmT5Nrvaqc
	0yomQ5japXNuGTaQeD8+IEQSBW/tj0buVp0CW/drQAwEFK7AMHyNh4Zc
X-Gm-Gg: ASbGncuwbRkYy3JzU1NNbug2gnmOsw6aSluS3hL+neEpZw+WcjRqN04K9Y4L1ObhuP1
	TX6ObGsIu/yF8RK0acsjgf1PQ4R/o0tjJKsyvombHbjm8qlRVZplswSAmlUoH3t4D1HfxEenN3/
	87CkXgNYU+WfItw1Zi3Eo9f6rVL77UjJIEbb/KPgwQWq2MSHAsyPFXLANfF10ChPPpZMR7iTn3y
	pC/4AoC3H1+xmqEDDQKlpZZc0IznM66G0MPegvgfOSlZehZOL7M3jykgK44j9Yv9/XCMdHMY6B4
	qBd0IF+kZFkTibIXySQWPFxLxnU20FBnw/jgl8LquZd+QiEOab2IaOvpZuE3gauJt7PykOd3fsw
	XDmgOwqdPPydutehP+AxIy7ClgsaLYhK7N+CkhDE+p+jNgxNfqmaAk9bYHrDYJBAjfVjcC/Nrii
	qBIl43G2PYx0S2dnTrOJ5Lr960F89LJ6bE+1M=
X-Google-Smtp-Source: AGHT+IEWDnNXiVyz/gd1nQI/808f4jzNUVCrA10jfGdkE98h3Ersd56GF+aeFpUTYUxm6IHK2gsQ7A==
X-Received: by 2002:a17:90a:e7d0:b0:32e:5d87:8abc with SMTP id 98e67ed59e1d1-33bcf9146e9mr41622228a91.36.1761473019447;
        Sun, 26 Oct 2025 03:03:39 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.03.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:03:39 -0700 (PDT)
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
Subject: [PATCH v12 mm-new 09/10] selftests/bpf: add test case to update THP policy
Date: Sun, 26 Oct 2025 18:01:58 +0800
Message-Id: <20251026100159.6103-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7kg5g56yuy8w8ek8gsbhi74ibs1rnb8b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 92165C0005
X-HE-Tag: 1761473020-507824
X-HE-Meta: U2FsdGVkX1/nCH1wNNXFRifYhDe1p65eM0+OISbv02+YXRC1uvKq9eWTyYfFuckg0Qza6F/G0f61eDa1wpFrqvXo6k0Z2nD1upwym0dUiJaOvs58e6TEdjFEgDdqD4EgXfUk2HXdLNmsnZnGtHKRj5+0bSq5brwtRRxSofX3IluyfbtA7ZxXqqdQL7XdI3owIPCM1DkeE/j+tpghquRvagMrSiXt8vWB51eEpxu5xsNByTjOM0+wVp5VibrEzRyXwniZr7r4+DagOooY2I88o+eOXng826XsytvdjKYpTRjZ4kLa0RkvPVLQk5H8uJMHZ6Lu/1gblfJgsLvE1mNGPov/EimLSK8IbaPuFV1zJrGfjegugNmaKyaS0ih9oTy5NyHLIn5gNyLDEkyJ2zmi7T8gGGOELujWmHodByudB5PYhS+npFvoP0JalL4COZXiJhotU6cxjoagnYYzD4WnvRgMr3pi9Lp71Zi+LgANhGcvJLdABlusG/cwYLQZiZrLJQWmciyvrO816tABuTdtQ4tUn4Ncb1SOr7E1kryhacTLrPBUE1MJo4BX+8LUMn4vz9QWykBH+CdUrjO+EupBnSj8aBsngTs/g82Dcy63EbPjfqAlmTMoWs+e+PvaydcKOxv63lyfvgb7CWys+nAOamg8wW1RxWuBNZ1dQGKRLvLly1KHhO7RryG9coxgkNoXNW0CQOI8AzskDLCoidTCQy9hfP/VQe+hLab8ZbjqT3KmLVS6sjfphdUZcAgy+63hfNvRGe9XBxL7YSZkOZUkBXFhyOdArXObWEBrDnxxLYnrprRCDOqDVGz0yYD5IxYNGUYdElrgPXKR+0v/WSQWd0lH9xCL4sgT+FRutemEYbXqHmnDXTyM/Tr6ir3fNO1fKF3vsrYBkDXakoy93gyQkdl01AP/pYwcpq6luLAHg1zuczrImVFcYMlk+tRNb16yOM7oqgUzmFH63RfusDX
 r1TkedWK
 zqNHIOtMu91TWRW6m2Ebta1a+5DkaCgALrRDTVff3lFCaVshUFeIyzEinuBGkBaFlocTt1sDrC7ZQROI9zGFn3RBw2n74FQbGV22BpePVSM2Gu1/Wr/w+brVIfDWV3iWINnrldl6AugL7SZQK8CUXk1Z632OdzAjunbYZoQ+UIb9eDS3KCFES2F+wnMrccXr39mycC4C31S6jffue8cOJcdyEEbC306/DDJpPa7fVbZZR3mQhu/reiE6he1qQk1JVxOxYKupSVRA94isGL/n88muKdB5NMuhu3Luu/DUkcFlIPknBQEkcNlm7MMBkjKnDgJUzCs7O9v2HR7BUU2TQl88j22Yxs7X/suaAZl6x2E9A/lX6xV6rfdKybr4WCLAHVkcgPO62tWpLFNS6RfbIRoIIIoiZFDyE+u3KGm2mAFdEABv+rIa5uwH1nuuaQNC2czh/FOX2Zt3QyYgfv7bYjm4eO4mJ+dPcr7yG/46BFaBlXxgwISh376DZqPyWyNFoDsYZGaGNHjQbk40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case exercises the BPF THP update mechanism by modifying an
existing policy. The behavior confirms that:
- EBUSY error occurs when attempting to install a BPF program on a process
  that already has an active BPF program
- Updates to currently running programs are successfully processed
- Local prog can't be updated by a global prog
- Global prog can't be updated by a local prog
- Global prog can be attached even if there's a local prog
- Local prog can't be attached if there's a global prog

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 79 +++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     | 29 +++++++
 2 files changed, 108 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index 2b23e2d08092..0d570cee9006 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -194,6 +194,79 @@ static void subtest_thp_eligible(void)
 	bpf_link__destroy(ops_link);
 }
 
+static void subtest_thp_policy_update(void)
+{
+	struct bpf_link *old_link, *new_link;
+	int elighble, err, pid;
+	char *ptr;
+
+	pid = getpid();
+	ptr = thp_alloc();
+
+	old_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(old_link, "attach_old_link"))
+		goto free;
+
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THPeligible");
+
+	/* Attach multi BPF-THP to a single process is rejected. */
+	new_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops2);
+	if (!ASSERT_NULL(new_link, "attach_new_link"))
+		goto destory_old;
+	ASSERT_EQ(errno, EBUSY, "attach_new_link");
+
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THPeligible");
+
+	err = bpf_link__update_map(old_link, skel->maps.thp_eligible_ops2);
+	ASSERT_EQ(err, 0, "update_old_link");
+
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 1, "THPeligible");
+
+	/* Per process prog can't be update by a global prog */
+	err = bpf_link__update_map(old_link, skel->maps.swap_ops);
+	ASSERT_EQ(err, -EINVAL, "update_old_link");
+
+destory_old:
+	bpf_link__destroy(old_link);
+free:
+	thp_free(ptr);
+}
+
+static void subtest_thp_global_policy(void)
+{
+	struct bpf_link *local_link, *global_link;
+	int err;
+
+	local_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(local_link, "attach_local_link"))
+		return;
+
+	/* global prog can be attached even if there is a local prog */
+	global_link = bpf_map__attach_struct_ops(skel->maps.swap_ops);
+	if (!ASSERT_OK_PTR(global_link, "attach_global_link")) {
+		bpf_link__destroy(local_link);
+		return;
+	}
+
+	bpf_link__destroy(local_link);
+
+	/* local prog can't be attaached if there is a global prog */
+	local_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_NULL(local_link, "attach_new_link"))
+		goto destory_global;
+	ASSERT_EQ(errno, EBUSY, "attach_new_link");
+
+	/* global prog can't be updated by a local prog */
+	err = bpf_link__update_map(global_link, skel->maps.thp_eligible_ops);
+	ASSERT_EQ(err, -EINVAL, "update_old_link");
+
+destory_global:
+	bpf_link__destroy(global_link);
+}
+
 static int thp_adjust_setup(void)
 {
 	int err = -1, pmd_order;
@@ -214,6 +287,8 @@ static int thp_adjust_setup(void)
 
 	skel->bss->pmd_order = pmd_order;
 	skel->struct_ops.thp_eligible_ops->pid = getpid();
+	skel->struct_ops.thp_eligible_ops2->pid = getpid();
+	/* swap_ops is a global prog since its pid is not set. */
 
 	err = test_thp_adjust__load(skel);
 	if (!ASSERT_OK(err, "load"))
@@ -240,6 +315,10 @@ void test_thp_adjust(void)
 
 	if (test__start_subtest("thp_eligible"))
 		subtest_thp_eligible();
+	if (test__start_subtest("policy_update"))
+		subtest_thp_policy_update();
+	if (test__start_subtest("global_policy"))
+		subtest_thp_global_policy();
 
 	thp_adjust_destroy();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
index b180a7f9b923..44648326819a 100644
--- a/tools/testing/selftests/bpf/progs/test_thp_adjust.c
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -22,3 +22,32 @@ SEC(".struct_ops.link")
 struct bpf_thp_ops thp_eligible_ops = {
 	.thp_get_order = (void *)thp_not_eligible,
 };
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(thp_eligible, struct vm_area_struct *vma, enum tva_type type,
+	     unsigned long orders)
+{
+	/* THPeligible in /proc/pid/smaps is 1 */
+	if (type == TVA_SMAPS)
+		return pmd_order;
+	return pmd_order;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_eligible_ops2 = {
+	.thp_get_order = (void *)thp_eligible,
+};
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(alloc_not_in_swap, struct vm_area_struct *vma, enum tva_type type,
+	     unsigned long orders)
+{
+	if (type == TVA_SWAP_PAGEFAULT)
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


