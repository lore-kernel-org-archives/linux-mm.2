Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170BD606A335
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UH2nQz+W
Received: by kanga.kvack.org (Postfix)
	id 3BB5C6B07D0; Wed, 21 Oct 2026 18:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364DC6B07D1; Wed, 21 Oct 2026 18:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252C26B07D2; Wed, 21 Oct 2026 18:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAE7D6B07D0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:00:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 754C8A03E1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:00:46 +0000 (UTC)
X-FDA: 85348003692.28.71E6950
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8DA97A0012
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:00:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UH2nQz+W;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792620044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SK1JHY4Qru2sKfE7pI5aCFA5cz9Q9hLtB1cww8qn0+k=;
	b=rZWfD/fOCVOwtHRyyAuJ/aRqPicvwZrcQxO4Dixa/Sg4XCAAFUAbB15ncvjS60Q+pwvTsT
	b7/mmk8cRVuRNgnQOOOOX2dkhZEy5cksgDeGkux2YeVDCyiRXZ487zNRJpyeW1zACXD3me
	akFyn3NbV7fH07T1DFKXeaNK0VOKoYQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UH2nQz+W;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792620044;
	b=pzli/I3Bs1eVqddGs9LmAJcIUuxBbn4qI/majDT2rDjTR2WRLkjfZCjdfFYNcfh28azr6B
	Z3yCeArA1peflJ9JdpEiqWuvftFF443KgGzVK2QEZThf3dItSZLwaQVm3OKIAd8yV8QQC5
	PO0e9i+Fmt/8/DaorLxqzaYJ/hm0J3c=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4b1f7e8f4so490468a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792620043; x=1793224843; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SK1JHY4Qru2sKfE7pI5aCFA5cz9Q9hLtB1cww8qn0+k=;
        b=UH2nQz+Ws24fZMEJaAiBCURTbsiHuTnyXfhwG6B91yxqYDH1h4mBotQcfL6UMuCFfB
         AKUMfFjDBqlhI2Kn9I9OxPnGJ/9HEAlqjaB7LmXjWVHN8v3RSizXIkp2NNGIxiITCf7r
         dVb9UtOy3/qhMNEqrD6VCi3WVHfXkkdP03bpVuZwo1gy/kLwRwgtSo3RbPJUkZDCOtiO
         vAsX1Lcehy0keGTbx4R9KOVVs9yOWOtsIjeDVOK3iQaEv4xFNPXpq9DagShP605aoqJk
         C9bLCPO+VzFY2Cr5M1uOcl78rSd7yUBSmW4EGGheNbqCNHQNNi7Se7zAeYyJwDMK3T/Z
         XuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792620043; x=1793224843;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SK1JHY4Qru2sKfE7pI5aCFA5cz9Q9hLtB1cww8qn0+k=;
        b=mByicbkjtaUamLnw20lEWQ5j4vIW137MXaS9OjFJv5rc4ZpDX/w6ZNxijUGJZMIerk
         D7hJsvFCtyJ5yz5debGarSff4bL9nwDYIEFJktfCpXvMxHK67UvMhRimXdXOKv6McBDt
         +lLojRIzDw6snjaTmrVSctr6xWk58smkJoVSFEh0AVgi17E9dXQhVTHSZpsbfYPx3LmH
         KGu5sYzZnkAB5xBEhXYjxErDgy1tosyMN9Ko//5y/TxUdj8pC6QYNqX1HMCAWfYLIB47
         JeFEwgV2QaXXSd5bfLxpTxl7yi0kf3CFXXET7l8SXKqA5odSb+v6EwNPANDSZIuXTMe6
         7S7Q==
X-Forwarded-Encrypted: i=1; AKwUvBycojtBThjv46dL+mhEFJb8ZuQ5FMhCpfKCCFybwuuV/UrsfTkAfwcmGYQwG++Z16UhE1Q2bY+OAw==@kvack.org
X-Gm-Message-State: AFq9FYJXGJdb4gd0XxdmZAERXMJJxNPMG2WyyCwIZ/1sOaaoeC2NXV+I
	4TCKxExOL1rAICy2muMzKhJu519Nc3F3DxCvQvn2HGurklwIuHVm7Kdh
X-Gm-Gg: AYBFou3NxywN+Sugr6ydAlGziqArcELf4nr2sAM/iVT+8gc+yswCq0gz1DJw+dBJK3V
	b4DEmYA99XOMFr7DI5H3F3YWFkywyJ2m4NiNitjKRonQPDyqs+Gg4xzLadouGpLQkgeOfn9BgZf
	7Gy4b7PYuJKeYWwrAcc2+Vb6tPkqToORs7qpNhLOVpwz0O8/6QOPZ4L29petaqOnAduEQ88T1Q8
	rZilXHYTS8kHTDlWeON91o7ZJC4k71NMv4WtKa/1krBMXDHlQkBt5ztKD6muQfGik3NVu1nZtn0
	b84B5Mj9Yd3798frqV7UBlxKKu+HU+EcvGjvpQvGucw+QpmheR/GEtz2TJkeYxsE6nTXxDk9NGa
	j6EZFPK6IQixLUSaIUycyKigJfyCKNHjBvdmTO1zoyXHK/g8heHsYxVUC7y7e9IyngXBP0nYbey
	H/H5Yk9EJpbdDPd5aRSO8xfwG0zihqrh7ZSqa3SYbHBWreZQ3/l8U4uN6XSOFaOsex64nVIzSKB
	dLRtQHR8Sg51D1i56ELO0NbQFsXPnbmIKFsjt6ABJM6M4cPh1unMfpPTncWSeohVeLtONH9XpLN
	yMalYJGjg4NNrtrpsqCZ2xV2Geh7iJ92LExo2anRo4MQqEirud9FyHV0h8TsKr/CnQUvD3IMBra
	0NnIBIw==
X-Received: by 2002:a17:90b:2ccb:b0:3ac:a11a:7c7f with SMTP id 98e67ed59e1d1-3ad86ec9be4mr2512032a91.23.1792620043175;
        Wed, 21 Oct 2026 15:00:43 -0700 (PDT)
Received: from localhost ([153.61.198.242])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48ed719sm1158289a91.5.2026.10.21.15.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 15:00:42 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 Oct 2026 22:00:41 +0000
Message-Id: <DMAURQCKK6CG.10CZ7MFXGJO3V@gmail.com>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] mm/page_owner: add bpf_iter and kfuncs
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Zhen Ni" <zhen.ni@easystack.cn>, <daniel@iogearbox.net>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <martin.lau@linux.dev>, <song@kernel.org>, <yonghong.song@linux.dev>,
 <jolsa@kernel.org>, <emil@etsalapatis.com>, <ihor.solodrai@linux.dev>,
 <akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
 <ziy@nvidia.com>, <shuah@kernel.org>
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8DA97A0012
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: d9jki55jyubidro73hxsiahd8oueugdn
X-HE-Tag: 1792620044-305600
X-HE-Meta: U2FsdGVkX18OWjZ64q5bsa7M3BO4YeU2bnoJlTZlztz90TRGkgyclLqwyx6F/pOPgbQgs3ljQnTM4M3Hjq6WIcptef7G/iCAyLrvXUYUTaJPsRFsmpw9HYb8clKQQWMTyfSvO0/bvkWBN7D4SgzLmIld1NI07TE/9dYK3XXfMLMh5H246C6WvSDCUowxXuQmlxzyN1QKV8wfT+z8F8YQsNtefnkWtL7DKUQxQDVjYfZW9FJQSPntexbGz9kJKfBEA2vi5Rfz9lNlojBq8nG7ErLdP2WijOCXUgU2D1gGY9yRF6HgRCz+Pq2XyEutKP2ysnpCEjNb6Ln9A57skYau3XdoBws4NV9s4I6w2mgcl8QqeGdd1IbKjVTBrzlt8vNDvETZfxmxJ9LhTnq4eFmCzIk6lHyZH6MAmuOcwEH5WsAAiDfcTnCe4BxbmX8l/kxOBEshN+GioN3q8XIsLHKEwYOXvHcUf51UrS5oqUJ+Owv4bTNiK6Eiprp1xcIHZOlzzNnDnv1g267fwyKNrGn8Uie9epo24Ycn536Pn3S7/I5SW/OQZK9j1CRKZmYvLqSN5WEklxOeQOTzbdKgPxb1a+0rd29401o9Mf0sNC3y/KVMb+22jGdRZmbZCFKI58eAvoNZEPw1ygMqgqQOW4lcChwSP4UqBIsUOXhLA7XpUMwqyTdQORNQr70Tarbo8odWq/jDsJAlWoIQ5xgZGitrqPBd1A/VfOYns++hxh1p2sFmEVAj4biyZBhsnw1Ji7RZGFBmWaq2KGSs1EcoK96qRJaOJUGJpwCg1SwloHIJ1KAZnGHcFuAE5Tr4mBeqAql0ZoZNV3G2wsp8887z9hisWVMFIL58zSCr+HhUfjgcT0TOu3b0sBZSD9805cqkuGb9ntFJ9cqpObqaQyRDZIvmorSETQBtn83WoJkS7GW0WwewHspDbxmG4YwzWHUokc+60tg2ChTQEUkaB4CMn92
 3Mcv35ej
 /0XemHrNArjDjUEGmulAs7DMQQbZ/C9EEgcdHjXWxpUIDlnrBxKTWJ36NcMJ8F4D+HnlN22078GEHG/ntbooi1VasQvTCmSG8bECpzYl1Yc0Ec9RWhLm9T3SUaE215tNECwHG5Da0DikEaiCV2BUVYAXotCX0Kcaqwrs8e63cX6o0B4I+Dw++AnH7byjsx26BOklyQz4VolMG4XQ1PNaoYZGNMMCz7JwYBci9KX50HVoU0iANLVwNjKTmmgiRFq1UEpCHMAOqWr/nearIpnqpHbt6RL4NpvGhCZK1F7pVa0c4MM6bQWbujNA9RTkcmvvGkSKAX3vlm80V2FT+OkbVOxY5vS+MKeH/ViLoyDu1g/WzEg5Pbj4/tGG36kYx3f/gOfOIMRWMwq+nn2tKqpiGiNZFE5Lpjl0rhBO56WQN3Pd/fRir/X2ec/ogYSUeEsW0eCB/YbaNLQMtI4netV1jhsUsFW+Edo1UOYMU42RVSAAra9fUOop4yFm4rkjLDKZI+nAj2p8yvB/0SD8hM/5nhZ10/2ZsF91HkwCqqcOX4ll0IdUThLU77cip0Rgp4XfO/5a4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 04:24 AM Zhen Ni <zhen.ni@easystack.cn> wrote:
> Exposing the same walk to eBPF lets a program filter and aggregate in
> the kernel and surface only the records it cares about. This series
> adds that access as a seq_file bpf_iter target and an open-coded
> iterator.

This is overkill. Two iterators, two kfuncs that print strings,
a rewrite of read_page_owner(), a new file and a new header.

All that the prog needs from the kernel is the page_owner record
of a pfn. That's one kfunc. The walk, the eligibility rules and
the filters belong in the bpf prog:

  bpf_for(i, 0, ctx->nr) {
          pfn = ctx->start + i;
          if (bpf_page_owner_read(pfn, &po) ||
              pfn & ((1ul << po.order) - 1))
                  continue;
          if (po.pid != pid || bpf_page_cgroup_ino(pfn) != cgrp)
                  continue;
          /* add 1 << po.order to a hash map keyed by po.handle */
  }


Something like this:

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c..3adb716 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -161,6 +161,20 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }

+/**
+ * bpf_page_cgroup_ino - Get the cgroup a page is charged to
+ * @pfn: the page
+ *
+ * Return: What /proc/kpagecgroup has for @pfn: the inode number of the closest
+ * online ancestor of the memory cgroup, 0 if the page is not charged.
+ */
+__bpf_kfunc u64 bpf_page_cgroup_ino(unsigned long pfn)
+{
+	struct page *page = pfn_to_online_page(pfn);
+
+	return page ? page_cgroup_ino(page) : 0;
+}
+
 /**
  * bpf_proactive_reclaim - proactively reclaim memory from a memory cgroup
  * @memcg: the target memory cgroup to reclaim from.
@@ -218,6 +232,7 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_page_cgroup_ino, KF_PERFMON)

 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7b..a26d7fe 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -12,6 +12,7 @@
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
+#include <linux/btf.h>

 #include "page_alloc.h"

@@ -1144,6 +1145,44 @@ static int threshold_set(void *data, u64 val)

 DEFINE_SIMPLE_ATTRIBUTE(threshold_fops, &threshold_get, &threshold_set, "%llu\n");

+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_page_owner_read - Copy the page_owner record of an allocated page
+ * @pfn: the page
+ * @po__uninit: where to copy the record to
+ *
+ * All pages of a high-order allocation have the same record.
+ *
+ * Return: 0 on success, -ENOENT if @pfn is not online or not allocated.
+ */
+__bpf_kfunc int bpf_page_owner_read(unsigned long pfn, struct page_owner *po__uninit)
+{
+	struct page *page = pfn_to_online_page(pfn);
+	struct page_ext *page_ext = page ? page_ext_get(page) : NULL;
+
+	if (!page_ext || !test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags)) {
+		page_ext_put(page_ext);
+		memset(po__uninit, 0, sizeof(*po__uninit));
+		return -ENOENT;
+	}
+
+	*po__uninit = *get_page_owner(page_ext);
+	page_ext_put(page_ext);
+	return 0;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(page_owner_kfuncs)
+BTF_ID_FLAGS(func, bpf_page_owner_read, KF_PERFMON)
+BTF_KFUNCS_END(page_owner_kfuncs)
+
+static const struct btf_kfunc_id_set page_owner_kfunc_set = {
+	.owner	= THIS_MODULE,
+	.set	= &page_owner_kfuncs,
+};
+
 static int __init pageowner_init(void)
 {
 	struct dentry *dir;
@@ -1169,6 +1208,6 @@ static int __init pageowner_init(void)
 			    &stack_fops);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &threshold_fops);
-	return 0;
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC, &page_owner_kfunc_set);
 }
 late_initcall(pageowner_init)

pw-bot: cr

