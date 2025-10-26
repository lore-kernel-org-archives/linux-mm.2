Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06F6CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5DA8E0166; Sun, 26 Oct 2025 06:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065E98E0150; Sun, 26 Oct 2025 06:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E490B8E0166; Sun, 26 Oct 2025 06:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEC208E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:03:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CDB91A0369
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:15 +0000 (UTC)
X-FDA: 84039827550.17.F2336A5
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95C43120002
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L47X1aJh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761472993; a=rsa-sha256;
	cv=none;
	b=3AOqZYktZi3ZaAC+IBlvs7WJVHGgcpTveysdEC48Xv8cdNxeB6ePX8B7WNs8Qgy4Ip3igX
	r1Xn+X6WVpmIBKzxFAvW29IgWLAkbOn5wQ8sDAlpuWMi1BcpW8Io42aD0oB2gMCBVJY5gD
	kcF1Ptd3v/MRUuwyf3Pk1EX5uEh0PlU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L47X1aJh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761472993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51dh7knyJ2EI56Ln4OzlkkQ20tkXsHQX/EW7h1z6ees=;
	b=EjAQr7TdG1WG3PQPgVOpzqlI7MXUZTLDRl1OS/nOLbrxV+zBrd6u2SULgCcRtUMl2DKv6J
	h/0J45ZdpYf+3HWIjY4PSxFihspaZVumX1mNZpy5ujXqbfIK0m3wo+oaznbGDQcrUj3tEM
	o+JlOUttAhkAwX3ZrMpMwr7r/ZFLLnU=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33067909400so2696349a91.2
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761472992; x=1762077792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=51dh7knyJ2EI56Ln4OzlkkQ20tkXsHQX/EW7h1z6ees=;
        b=L47X1aJh+5czW7lCryEGB8iPgZUeMcVd1lxGgtXNEr3RLWnC/Xr+Dwdd3QB3Ka+DSv
         YL/VRuv9iAuHMkOvl+8cCpOkZ4fuJE/aQE8UD+tq27MVpCAjXIvwEPbl4jzxk6ygw3lo
         RhripwoKDid4JBej8b+l2zIIN3lWd+xCOtUmhdWaVrALiuoj8LwxZc05QlzSyReJ+Nr9
         DuiMKY1KPCHEbs0FVGR/D+Y7OQXG4un4BOjaBhT79gtOG0hu31mtaDPwCqOvJvwCnmTI
         0d7WASW4vt+X5IV3AuuoBdLgDHP/6Suu6/v59UnUwfXJ7XyXhcwAVz9tu+YFer9oIgJ1
         kumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761472992; x=1762077792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=51dh7knyJ2EI56Ln4OzlkkQ20tkXsHQX/EW7h1z6ees=;
        b=KjDvtCiuCdMgqRXyn4+HJVcPTSngrSHN7RrqhgNMqZzc0zCbY0X+juACqrjYTaV3oK
         RAbSpaRJgyT9DbCQXLavzr+Gsa2+M0UTMuiFTd0h/Kz7UDQHax9pkp39rhbfhfEW5MtE
         XQNPQthrjInXAolty3qTv9abvRoanSg2Z2rqrOoMg6guyhK+Xnmm5VdGhJxiP1w/sL22
         Exhl9xpDtfWxS6v6pNpdP6vl9x6FxQL5U7BAn4W+O1ocwFshGvrWTdjgJkoYZAp/B4NR
         WxRMb0PpcZrL9Eq8oEbfTwIoxCeIXgIdGc9bR4Nz/26zKdngypMCvalxAanmYCVtFHR/
         k9cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrxk/Kh/phYVFRBe9fG8yDmhn9BXdPZEuBAk4FPpeKc71kC6HdqsirJIJI7Il9nx5w9HPtphG0IA==@kvack.org
X-Gm-Message-State: AOJu0Yx21VZ1IswPXANyf1BGwF0v2LaHe4ky99DOyYMty/K+L9gbDv4X
	h0Wb1kOXQcHPsSp6oACAkGCmj+j5Vqy2FlYRScCky7LmZgx3DG6WuWnZ
X-Gm-Gg: ASbGncs12ZutDD3q4H+QPEdy8g+FK46kkkOwCDWsitBbXabrwDvVzHT170JR/n74fwS
	Z1BQYhRgXpU3lchJyuaK02WZkFhs5i8epz2YkS/uTUyrLi9/H/BpxjBFiebUsHhQr/NvAlKiMOl
	muixKvmRBN1w+TfBedYIK8SdicWS3pvANCeLhHiencG1YObjMFLVkrHaGJ46PFWXWLgZCMJ0ise
	atFtYk/xC3Grwdjw+Yos/krhNA8SSDLdtxrQq4WOhSHdnAgLzCOkUxmFtzRHlGpzjmf4Cbyr9yt
	936Nze8txkzL8h2ssNi0tWM90abZ9MlrxxmI+OZKO0G6yykNYRUm08dcSbKH8FOQyiCOozYAxUL
	z3ndXw4seHNhL86XZB9w8+fKL3uejbQLxyMqlJ9u6f64WEDEsX19QfMfQeL8iMCrfru01yU6cqt
	rZkg4pbdF0VwSbLGIzLDsKKKygDiNJu7R9uTrzwG11JxfX7w==
X-Google-Smtp-Source: AGHT+IG7sgq1Xq92NeCyT7uFb5+71seRL/zYWyT7c5kIIXXvcEfrQgBKJ+civAjAk2csDkXdvTOUtQ==
X-Received: by 2002:a17:90b:1f89:b0:32e:3c57:8a9e with SMTP id 98e67ed59e1d1-33fafc8a0c9mr13862369a91.35.1761472992294;
        Sun, 26 Oct 2025 03:03:12 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.03.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:03:11 -0700 (PDT)
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
Subject: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
Date: Sun, 26 Oct 2025 18:01:55 +0800
Message-Id: <20251026100159.6103-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kq181ck6gqw1qwkca3u7sdycgehrc5ip
X-Rspamd-Queue-Id: 95C43120002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761472993-703087
X-HE-Meta: U2FsdGVkX1+NGT02L+uSNiGyO/mP2F9o3ZA7zJUgAZsc9NGzS3XclWYpVL6K6hhUbHuHwWtArZLtyd3j2HHsBQPOUY0YwbM4OPNqD2gK/zSn94aHZVLTIKYwzHQUavzRi8BFlPcOIwvQPsyKLSjUildS5Tu6nJNYHjH6eUDCxuut1oDTb8zHxVvcli5Yhv7Bj9OHh5hhe20wzaiY2z0w2j2y8r00yGFRHE5f8Q5z5pmbDhv1qvQjVUnPGFuKO5fKSR8hSyx++IQdUKe9+yzLiPeildxRsYckCa72zs+hBKnTFYNyxqOXWmxW3/EBZPWFpCGhKHv8f2Yg8MI3Bs+xyeFmQttPXMBsfWupYhuuwYuNP1eU6GOBsX+OrtKevXdXFRDjRZwSuDDRULWfoOHwLqAvF0ayO6TREzsY/84oMr6nlrDlR+uDnNzq60ShHcaOcTpH7W87ng3A7Z1vS2DJ6vESjEZGAdUccdB0aXy8IF3hN8fgdX7bLyzrY0P6frv1qni1T0d9/rNdjyn9sGmYEffKlpW3kjkt9UbQU2kCpONl5QGlp6TbeeVbnFAu0rwH38dyqDmh4PLQpnZL7iInYHKyCtLepTmc+adKw79DCh2o9EXPk+mTtH9QUU8YAUmO5Pm5SqJ6SkqLBI4U6c0YU508UITBVM4qkgOtwLSav1tXetaz3+3KvHeQZL3K9xPDtmp7BWU3k61NnwBADK9hm/7DRW1xUDFWFdtmab1ZNbAg74rEs2a4s+ZyKwOo0G0g9Q5NyKq84yPSsA6/sXAuM2PAyT75cxPRuu++kNEJUhpbqvcLkp8IF4rekFNhmhQDMOQTZqKtUI7PjP4us9O/BnqKyfqVPZU/KVz1Y1ZvOxIQRJvALzOCNH4jklp8pnTVcWpHOUJWJU4tz5k7rPyqQR+VEqCDWttLQUhpXeT1JyKBPTwHJONKm4oIzyCPdYKCVg1iBOMbwsnNnN54ahv
 6uTfsA2/
 URdBLzt6OEU0xxqgBSvcRHEy2uQkebX22P3PfCKTpdh+ZTEhhF0lMIaHMj10LQU+0UrbhVrvB9FG34TDU5d8DEPw7QhtQRFJjuyjYHkYms8XSZ4V9ymVnGJsGMFipyBRaQbjrCO+WYZd3zMy+cKbRhsyZPQbbJ7DkhqzggYiUK4K9BEwxjdH7qXp62dAixnVuqFNdioP3iN8Qny6HFOFMlvGcO9MN8bKQ0DGRs4I/B156b6ycEZqUB2+JPMH6SONU9+Gt8qZs6vrRNA0wtt7S581n+zn4D8S3v6A51qYJcsDvozMKaRrAn1oPFJwZ+RYY6l5h3DiJW7GYgwBgwQhxakcIAeA34vPJGpqe4U5OvQ9RufwbYO6Ee6aSp/40zNgQoUQJPOnVeiEJ/3iPyf0bLfjMzdZpAp3zkSi+ygH1cu5yIcFcYsZ5LxfoDyXSdVuDVx3bu8u4vtZX6/O+mRGzrPqO8qcBVuVBuFWAUJ5JQV91EODyl+4q1gvgjiLfPAosXEl4C/sJ+UDNzokoC9BXmP+pw32GVU94TInaNSKP9936/tdCHrzWRxjHN5ntCPjUiRKZ7/WmGG3K2qQzVC5G5VV/P+Hx3p3jF9RM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The per-process BPF-THP mode is unsuitable for managing shared resources
such as shmem THP and file-backed THP. This aligns with known cgroup
limitations for similar scenarios [0].

Introduce a global BPF-THP mode to address this gap. When registered:
- All existing per-process instances are disabled
- New per-process registrations are blocked
- Existing per-process instances remain registered (no forced unregistration)

The global mode takes precedence over per-process instances. Updates are
type-isolated: global instances can only be updated by new global
instances, and per-process instances by new per-process instances.

Link: https://lore.kernel.org/linux-mm/YwNold0GMOappUxc@slm.duckdns.org/ [0]

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 mm/huge_memory_bpf.c | 111 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
index f69c5851ea61..f8383c2a299f 100644
--- a/mm/huge_memory_bpf.c
+++ b/mm/huge_memory_bpf.c
@@ -35,6 +35,30 @@ struct bpf_thp_ops {
 };
 
 static DEFINE_SPINLOCK(thp_ops_lock);
+static struct bpf_thp_ops __rcu *bpf_thp_global; /* global mode */
+
+static unsigned long
+bpf_hook_thp_get_orders_global(struct vm_area_struct *vma,
+			       enum tva_type type,
+			       unsigned long orders)
+{
+	static struct bpf_thp_ops *bpf_thp;
+	int bpf_order;
+
+	rcu_read_lock();
+	bpf_thp = rcu_dereference(bpf_thp_global);
+	if (!bpf_thp || !bpf_thp->thp_get_order)
+		goto out;
+
+	bpf_order = bpf_thp->thp_get_order(vma, type, orders);
+	if (bpf_order < 0)
+		goto out;
+	orders &= BIT(bpf_order);
+
+out:
+	rcu_read_unlock();
+	return orders;
+}
 
 unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
 				      enum tva_type type,
@@ -47,6 +71,10 @@ unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
 	if (!mm)
 		return orders;
 
+	/* Global BPF-THP takes precedence over per-process BPF-THP. */
+	if (rcu_access_pointer(bpf_thp_global))
+		return bpf_hook_thp_get_orders_global(vma, type, orders);
+
 	rcu_read_lock();
 	bpf_thp = rcu_dereference(mm->bpf_mm.bpf_thp);
 	if (!bpf_thp || !bpf_thp->thp_get_order)
@@ -181,6 +209,23 @@ static int bpf_thp_init_member(const struct btf_type *t,
 	return 0;
 }
 
+static int bpf_thp_reg_gloabl(void *kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *ops = kdata;
+
+	/* Protect the global pointer bpf_thp_global from concurrent writes. */
+	spin_lock(&thp_ops_lock);
+	/* Only one instance is allowed. */
+	if (rcu_access_pointer(bpf_thp_global)) {
+		spin_unlock(&thp_ops_lock);
+		return -EBUSY;
+	}
+
+	rcu_assign_pointer(bpf_thp_global, ops);
+	spin_unlock(&thp_ops_lock);
+	return 0;
+}
+
 static int bpf_thp_reg(void *kdata, struct bpf_link *link)
 {
 	struct bpf_thp_ops *bpf_thp = kdata;
@@ -191,6 +236,11 @@ static int bpf_thp_reg(void *kdata, struct bpf_link *link)
 	pid_t pid;
 
 	pid = bpf_thp->pid;
+
+	/* Fallback to global mode if pid is not set. */
+	if (!pid)
+		return bpf_thp_reg_gloabl(kdata, link);
+
 	p = find_get_task_by_vpid(pid);
 	if (!p)
 		return -ESRCH;
@@ -209,8 +259,10 @@ static int bpf_thp_reg(void *kdata, struct bpf_link *link)
 	 * might register this task simultaneously.
 	 */
 	spin_lock(&thp_ops_lock);
-	/* Each process is exclusively managed by a single BPF-THP. */
-	if (rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
+	/* Each process is exclusively managed by a single BPF-THP.
+	 * Global mode disables per-process instances.
+	 */
+	if (rcu_access_pointer(mm->bpf_mm.bpf_thp) || rcu_access_pointer(bpf_thp_global)) {
 		err = -EBUSY;
 		goto out;
 	}
@@ -226,12 +278,33 @@ static int bpf_thp_reg(void *kdata, struct bpf_link *link)
 	return err;
 }
 
+static void bpf_thp_unreg_global(void *kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *bpf_thp;
+
+	spin_lock(&thp_ops_lock);
+	if (!rcu_access_pointer(bpf_thp_global)) {
+		spin_unlock(&thp_ops_lock);
+		return;
+	}
+
+	bpf_thp = rcu_replace_pointer(bpf_thp_global, NULL,
+				      lockdep_is_held(&thp_ops_lock));
+	WARN_ON_ONCE(!bpf_thp);
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+}
+
 static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
 {
 	struct bpf_thp_ops *bpf_thp = kdata;
 	struct bpf_mm_ops *bpf_mm;
 	struct list_head *pos, *n;
 
+	if (!bpf_thp->pid)
+		return bpf_thp_unreg_global(kdata, link);
+
 	spin_lock(&thp_ops_lock);
 	list_for_each_safe(pos, n, &bpf_thp->mm_list) {
 		bpf_mm = list_entry(pos, struct bpf_mm_ops, bpf_thp_list);
@@ -244,6 +317,31 @@ static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
 	synchronize_rcu();
 }
 
+static int bpf_thp_update_global(void *kdata, void *old_kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *old_bpf_thp = old_kdata;
+	struct bpf_thp_ops *bpf_thp = kdata;
+	struct bpf_thp_ops *old_global;
+
+	if (!old_bpf_thp || !bpf_thp)
+		return -EINVAL;
+
+	spin_lock(&thp_ops_lock);
+	/* BPF-THP global instance has already been removed. */
+	if (!rcu_access_pointer(bpf_thp_global)) {
+		spin_unlock(&thp_ops_lock);
+		return -ENOENT;
+	}
+
+	old_global = rcu_replace_pointer(bpf_thp_global, bpf_thp,
+					 lockdep_is_held(&thp_ops_lock));
+	WARN_ON_ONCE(!old_global);
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+	return 0;
+}
+
 static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
 {
 	struct bpf_thp_ops *old_bpf_thp = old_kdata;
@@ -251,6 +349,15 @@ static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
 	struct bpf_mm_ops *bpf_mm;
 	struct list_head *pos, *n;
 
+	/* Updates are confined to instances of the same scope:
+	 * global to global, process-local to process-local.
+	 */
+	if (!!old_bpf_thp->pid != !!bpf_thp->pid)
+		return -EINVAL;
+
+	if (!old_bpf_thp->pid)
+		return bpf_thp_update_global(kdata, old_kdata, link);
+
 	INIT_LIST_HEAD(&bpf_thp->mm_list);
 
 	/* Could be optimized to a per-instance lock if this lock becomes a bottleneck. */
-- 
2.47.3


