Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D25FCCD184
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C4E8E000A; Sun, 19 Oct 2025 23:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8153D8E0002; Sun, 19 Oct 2025 23:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD278E000A; Sun, 19 Oct 2025 23:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5964E8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:17:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4DB113B9CB
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:21 +0000 (UTC)
X-FDA: 84017031882.11.204CF90
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0C6204000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I6E4vvwY;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760930240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYdtRER+63D5fwP+dPFGkrD4tSBc+ZR0Nj1GwO3r8rs=;
	b=UJ89UL12kyokIRcxhQUJtGbzicDd7xTxwzuwJHUV77OM58cklAN0ByEm23PhAhdpVBUabY
	gSWfsC6sdeIQcB1g3InPBk05Wg67yXcDzm81oH8/Z7w0mcnJU8/EaLXsUVussdVGWOT2AG
	MczQe+OxD00IA/ruZZAllAM6u8TTeSo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I6E4vvwY;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760930240; a=rsa-sha256;
	cv=none;
	b=W/WUPcFVKRDPS6uv7E+6UJfyO0Sadq+dlevCdzeZklzJe+aWS6g8B+S4uJofvSCtZFc+ac
	zXpMfVh0lx4BEAJi2bdre+6P9QQQSZ00PW7G01IxISJcZled2B8UJX3QpOvPJMrND98OBj
	zI49QHTh+abGm0Xxkzyef0btTS7Ur90=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so52639525ad.2
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760930239; x=1761535039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kYdtRER+63D5fwP+dPFGkrD4tSBc+ZR0Nj1GwO3r8rs=;
        b=I6E4vvwYDGaQTlwKk/t9Rn5CAioWYcGL1zlipaKBzbwacfAh62GL15pVbxWXufWbVo
         Usv8lVm8TY9ihk/6aLMXeSHZkQ1Y9H3gDw6zBwiL22NwqNkUYOG8ba5QphOvrPkQD/W0
         2C6OQYh8/Sj0c3Xou9vjqGJ5jOiJE5n+X/v00QK1zbodOqyb9ovQ5JX9VT6D7ypvU9DQ
         lpkImr4Mh10a6Ml9boVeVCzhJBz5AhNtCiFquVnbEelkJLXszxAxMqIcVEbKHBd2GOp1
         /GljHTeegbje3XYX6hiQuWjJDo6m0AjTJRdbX8x0nmuRvXgtbNwhV3+KiauJtPU+9paE
         QLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760930239; x=1761535039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kYdtRER+63D5fwP+dPFGkrD4tSBc+ZR0Nj1GwO3r8rs=;
        b=jgXqbd4hcoX3cq2r1vJZAxeO3qAx12iRe19HZt5GAg9ZJUxPMHpSx0aePnXTQ7+vip
         Qo0yTE/ug5C6ZxjB7jXMDSf1GocGjO5ztg316DkzefaAbMAwN7Eqd6IdDZNGfJno+pCj
         /fW0Nl6xyH4mOm0zM4B6Lm1L+bo4rfUFk+Mt8BJJPC3I3PPoQfZzT5a2cgcjgDIXAzvB
         cwy+YWWmg1C1VhJ1GsWOwZHji+Of08FrffFR3tIpKD0EvboSHr83JafvU0I7NQf+Tnu4
         WDElNMON4Ks1z2ZmX0zibB9PMs+JxUre8rfGOf3tQjyO88HcqrOUqxeuXgjvi4f6zwc3
         b6pw==
X-Forwarded-Encrypted: i=1; AJvYcCUIyEzwNEqrR1K8J+b6Kt8dchPNsXWthLTG0D4P+YC3xXqDzdbZ9cUfDE/hJNnZweUfl4qtGVRe5Q==@kvack.org
X-Gm-Message-State: AOJu0YxKzqnktr8Yo9ePcf956Br5Z4A8sGorCn3LjUx/PblU+oV/o6LI
	G/wMVlhdiIOFuEVLb1da1vHGRPgPXZ26VnFsvbVnkwSSsadrAe06q8NU
X-Gm-Gg: ASbGnctOQwO90AA0V27PsfAhAeTZ1QuUn9eC66ZifA3+bAbnUNOEdjzU2MGzMmdWob6
	yRFrtsusdzP33jIRHrEoPB9CpkN3ovrM30AO3wvvurzu/j0TlC+4k2eJ+BF+Uf3Y1ZJFngkwx2I
	GeU6JdQ7G8s/5RYwA4U2MTNCppaB58if/gKtrGZceZc6gIkLo4ddnySp7UDGIykk0VNpF5P3cLB
	lCHwEoSOXx5JugrMeJsHy7XkHlkNSg8n5VbzcCnGEh6rl4ym8ZxwoEiQuMHjGfJTYPV6VFVUSbu
	7FLQjP1FBFfQTc/mOAtP9eHW8J42IqMb9KIJhzaNtC8VEMcB6h6hHY4+jk2G1NVwFPJfxU9VU2w
	LRspdts0JQ48A0+sEDJPB8wrwQwajpUH3AIHUz3XGGATRHnMOv5wPP8l+7DMmXpk1GpdnHGfJHp
	002Ck9SwnT4CVgIVlYXKgMyi4jYhbDGUTULNpMSTd3Ht6KXg==
X-Google-Smtp-Source: AGHT+IGo/kUBmmZVSBiCCtDWJPQhX6W2PzXxnBQ3p+r5Rs/M8lNok3r/Ez1M0M2GbDWgxzLf0C8R3g==
X-Received: by 2002:a17:902:dac5:b0:267:6754:8fd9 with SMTP id d9443c01a7336-290ca216ad6mr166008035ad.39.1760930238858;
        Sun, 19 Oct 2025 20:17:18 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:3815:5989:6e28:9b6d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fddfesm66373435ad.88.2025.10.19.20.17.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:17:18 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
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
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v11 mm-new 06/10] mm: bpf-thp: add support for global mode
Date: Mon, 20 Oct 2025 11:16:51 +0800
Message-Id: <20251020031655.1093-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251020031655.1093-1-laoar.shao@gmail.com>
References: <20251020031655.1093-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C6204000B
X-Stat-Signature: nx5oijts1dyf37gbepamspjup8sps3dt
X-Rspam-User: 
X-HE-Tag: 1760930239-94024
X-HE-Meta: U2FsdGVkX1/cbi9r0NR6YmX49a8dgyaD+Cc6P+9AsqrgWNbWsHzTOditQ29t9VDyUQAxN57pyt6f15LO+0EBjRjTMgN5LooLX6YQUqYTDnQlxP2B4nqi30GH5lGnDb9yk+XuTEpIqsuEWlmARcNwq9YeH+3DBYBsToxvEdtJBgQ91zECyQ2lh7D5zvj23Ffp4hNOV6qB8TnhHgZ/iYi+RzI1UoypgGVK9lslgN6Z6nbH3gY9NNKBnUIzxqoNXfihH3ThRFe6xGpUQ+vJHRlsQVUzNqMryp5Ww+fIBi/aGbaaygyZybGz/pIUBQ1R1e3B6QdCaM2epenlJ4LEtvJdIqUdJ9wIiNn02Un+CGKg+Iyql5PN255Kaigr77mP5LxdJkVCAOLU+UuqwGFIGse+ogUXQ53rtjyEYcFPwNww9lwdCKdVHMcviP2SPdssZqosCdr/MCRxTHFj0xOmxZPg6KB18Z88qI74BHYGwBVhYIL/HGZMcEz+6KOtoJSNHB4fbjlOB6GnSHTRIpVdHEnczD3NZTQnIN4zddmHBRsu5JppeDd8RTI+iZr5s1v8P11iMyNvVbWKQ4tOBcdAMcRvx8wKDT2kZYKOpcIYfzYxWeHWrRk5LYQyTihqSa7sEeUBoOh32sx8r7TCntXlTudX2ht3ODZ6E5pwJ5xBim+75SLLot3tFN1UoAvvJfUtnH3ceOzYpGwuX4lhAF5nnYRu3fs2r/pOgzcrlF4r06hR59RGW8Jy4AsMN0YQ3BwWOsttHX5g7aa+X3bvyCZwn/trFdV43I6E+2haQxinL0KJNMtosbDvSnRfbW9mbTDVRtGhLyEzdpU6FM04QBoMU3EonA043fVQaxzsP9juOsYZFlNTjkEDQbeSezyZ8joyJr/87hde9LSqWoAfrPf6hfgOLXndZLsP++QLnUfExBFfkCfhMnzeUUUqKPMgvxoNmKPHYyxi4vTuOOEoM8WX512
 i/CR1hTv
 q5ZD3QCv81YLeHfbN7b6h1Hnox0jtfgEWh3iyzFM1OGyOi3NIgVWRltd3QTmrHrSd9E68vQH7f1b+XPikuEXkr3d28rviFiZ/f+yGckIJ0TACWI1rUk5dP/r7bX8+zvuxJjuI6B3yyPDym6Z7Lh9XKXxmOqfWbcH50Iq0PspSqTubnS7Kkkn3a8rHEWyJuTgm1SebwyO+wUuD39hSj087fUzD+kWk65lX4IMJW0MYTzJ0SvP+495Sgb56tDZwa2DVEAckBA295wx4nBX2PE8SNRea2pWslR2vry4xUaH7yHzkDGoEC2ZqoVpj6Lt1S8CQdPdCUpz8ktUfz2S3somm7T69lkSOQ35sPupS8DXvxOudc3VD0wGfqISshcEuPCdVH8spTBqXulm48n5NgazawG9AMFWSuoedVZXIQ40KwoighyY//EDvOlLy6G6gJHesU8Q89LbgHa/tU+90kunuLyP1QRrN42vlb2h+xsnzWNBpLyFjrdF6nA7efBlGgiaakqwl0mcfoB9ASzJbq23+dT/vq0fedPWig8SW1zpdb08l4or+pnoSqQBY4neBTgMThgjC2IzmT4Zz7dGlZNMDD+DiHe1fNfRV/QmT
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
 mm/huge_memory_bpf.c | 109 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
index e8894c10d1d9..cad1ca6f59a4 100644
--- a/mm/huge_memory_bpf.c
+++ b/mm/huge_memory_bpf.c
@@ -33,6 +33,28 @@ struct bpf_thp_ops {
 };
 
 static DEFINE_SPINLOCK(thp_ops_lock);
+static struct bpf_thp_ops __rcu *bpf_thp_global; /* global mode */
+
+static unsigned long
+bpf_hook_thp_get_orders_global(struct vm_area_struct *vma,
+			       enum tva_type type,
+			       unsigned long orders)
+{
+	thp_order_fn_t *bpf_hook_thp_get_order;
+	int bpf_order;
+
+	rcu_read_lock();
+	bpf_hook_thp_get_order = rcu_dereference(bpf_thp_global->thp_get_order);
+	if (!bpf_hook_thp_get_order)
+		goto out;
+
+	bpf_order = bpf_hook_thp_get_order(vma, type, orders);
+	orders &= BIT(bpf_order);
+
+out:
+	rcu_read_unlock();
+	return orders;
+}
 
 unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
 				      enum tva_type type,
@@ -45,6 +67,10 @@ unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
 	if (!mm)
 		return orders;
 
+	/* Global BPF-THP takes precedence over per-process BPF-THP. */
+	if (rcu_access_pointer(bpf_thp_global))
+		return bpf_hook_thp_get_orders_global(vma, type, orders);
+
 	rcu_read_lock();
 	bpf_thp = rcu_dereference(mm->bpf_mm.bpf_thp);
 	if (!bpf_thp || !bpf_thp->thp_get_order)
@@ -177,6 +203,23 @@ static int bpf_thp_init_member(const struct btf_type *t,
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
@@ -187,6 +230,11 @@ static int bpf_thp_reg(void *kdata, struct bpf_link *link)
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
@@ -207,8 +255,10 @@ static int bpf_thp_reg(void *kdata, struct bpf_link *link)
 	 * might register this task simultaneously.
 	 */
 	spin_lock(&thp_ops_lock);
-	/* Each process is exclusively managed by a single BPF-THP. */
-	if (rcu_access_pointer(mm->bpf_mm.bpf_thp))
+	/* Each process is exclusively managed by a single BPF-THP.
+	 * Global mode disables per-process instances.
+	 */
+	if (rcu_access_pointer(mm->bpf_mm.bpf_thp) || rcu_access_pointer(bpf_thp_global))
 		goto out_lock;
 	err = 0;
 	rcu_assign_pointer(mm->bpf_mm.bpf_thp, bpf_thp);
@@ -224,12 +274,33 @@ static int bpf_thp_reg(void *kdata, struct bpf_link *link)
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
@@ -242,6 +313,31 @@ static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
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
@@ -249,6 +345,15 @@ static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
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


