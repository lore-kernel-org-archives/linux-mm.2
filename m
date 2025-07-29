Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90351C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3423E8E0005; Tue, 29 Jul 2025 05:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2E38E0001; Tue, 29 Jul 2025 05:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208D48E0005; Tue, 29 Jul 2025 05:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1257E8E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:18:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6DF759737
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:18:47 +0000 (UTC)
X-FDA: 83716752294.26.417E64D
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id D63641A0004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:18:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lldr5Org;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753780725; a=rsa-sha256;
	cv=none;
	b=Z0h1ehaA8ALa6MWu8CcFQ94Ru6Z1Q+dWEcrbqb6IKI2tlK6z6lOMPtyZ6AbKanbyAJ31BH
	U8Nt2br+0mj5mbA2VSQLuse8Gh5O30PmA10e3qymyuxvFAuiliVSkSglbZuk3Ns02tpJEH
	sSDNjIr2AvDAa96HiYltoCNWeLOleyM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lldr5Org;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753780725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4wuSHp5MgGj5X4uVUc86dlTYO+Bq0AoM4t6bSoJim8=;
	b=7iYvVouvr5B1TvhopNeYKawoDOtZQRethpAmywq+CNq+uMbCtO8LoITXUEklz+X0sJk7cw
	p4X5WDBDzMBWkR27O259EzAIZZlX1qJ1ItfSVgviuc2F+rlWwnZh9yWGkP3jvKOmuzk2oN
	Dna7hCOApzADYI4VtgciAHjuQcnp9tY=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2401b855980so16935715ad.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753780725; x=1754385525; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4wuSHp5MgGj5X4uVUc86dlTYO+Bq0AoM4t6bSoJim8=;
        b=lldr5OrgXSbFGOML2FzIkExI3cZ3wP1H0vaaSWa/JFY0GWsDzhvRihsQtS3dgiNLwJ
         oNWPG05GdbclcezU8upBnqusJECpLwmVScDgpQA82LABO9rHAPgQ18qkFvS6Obz5D/kM
         AP4PuT+MtlHDfxKmGxmz7wY9j6vdP7UmJDQW7xB20j8nKEuR2EIEW28TInLNiEBnka0p
         lT97Ob5wLMbxYcJ4lMKgCyUrsFEMZOphfsOmDlMslCBYDIb9wfA5pIxl30kOpa+IA0sO
         AWSis3e9KyywnFz1s+jvJV7LVEvfvLezc3SZ40RiJ9Ra5SbumWzuuPR6zrSka9tSF2Xy
         QruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780725; x=1754385525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4wuSHp5MgGj5X4uVUc86dlTYO+Bq0AoM4t6bSoJim8=;
        b=jh4Vw+IkS+XLwcAoN82zFgaJIEgRduE9nyvOKocvkVUUFbuYz3w0wIUBX8G5/o4IPK
         27XGRjDMHt04+aEP/pn/er/3iIte9+72DfEKP2Jw9AA/CTPKnk8qX8LCwd5L62R/A1nt
         azNj8QIJNyx+jxRgeSHQFkIL3bvp16xPRElCnJ4hoeXc6DDumk0TXiEn0p/P5HVUeklp
         FLv4JJz2FDTPnb2BQaG/h3KIOlIc6wbSPtswJ+HStrcclffmK4YUsgxf1G6krabZeGUi
         k2JKpjD9P64o1+PR2y9de2GwiKcOuz0xcmuBN9cTdj7nyC0vOXDl1PpVHszTIDmn4Vy7
         Lk7w==
X-Forwarded-Encrypted: i=1; AJvYcCWaGSEvd99P4+sniMZB4KXVoScOMeNUTlfLBPBc2qljk2XU4o7YXgQpZYKvsb5lquyRE3WIbNHFLw==@kvack.org
X-Gm-Message-State: AOJu0YyfkI1iD6U9YIGS1ZFUyDFES0IVfm4G7UfJ+WIJm6rW5lU7TJsT
	WTs0Lukh7Lhw4wuPCQXPtgtof/XIOZ0uAUMqIZogbmBxvojaPYAfV7Jm
X-Gm-Gg: ASbGncsdcQ03vspoDE88EDBvxA37QUJqMNuazXgJrU7of2/Mv5MkHe4oOdG4ktjU46O
	5ujh3TocbS2/pr+AXjYyfnJyofXdkXanCo1smLl0r4koi7ynZeHCLeUybmuPDLcM4NxKyhz3jh7
	0o9TrkKTIMNYRQOycOjr3GA5asoGElWJQNV4MytmiafAfy+lDxRSJNsbhaseimVgUN8TCuC8tfP
	JaBLC4WswMNWVOQZIul4I+Iq/oFxCCjNNmMJl6sbdwT8WkZsdyD3MxBZ9ITHTXoH+vYTJ1pyfT9
	ROT7Xdi8ephek9MgdWThNRgH3XIRLbM7pxX3Lm8xDfsjocko9iPoGztthzAnyEVJqGZXQWl3Yn5
	FM3G7tbX2hhLA/n6a6roYi7nnJeaa90lwG0qfOAGGOqEFjcsN
X-Google-Smtp-Source: AGHT+IHImCx59GtUTMVH5evvVf6lAb6VeAEl4nWfKJH/fqFebPmYqu8OpPSeco+MQCs7mhFBgOKpmw==
X-Received: by 2002:a17:903:903:b0:237:e696:3d56 with SMTP id d9443c01a7336-23fb3126909mr242761875ad.32.1753780724700;
        Tue, 29 Jul 2025 02:18:44 -0700 (PDT)
Received: from localhost.localdomain ([101.82.174.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe30be01sm74337015ad.39.2025.07.29.02.18.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Jul 2025 02:18:44 -0700 (PDT)
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
	ameryhung@gmail.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v4 2/4] mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
Date: Tue, 29 Jul 2025 17:18:05 +0800
Message-Id: <20250729091807.84310-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250729091807.84310-1-laoar.shao@gmail.com>
References: <20250729091807.84310-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D63641A0004
X-Stat-Signature: 6f4mwg9eja3w5d53rqcu94h4igqxihos
X-HE-Tag: 1753780725-377351
X-HE-Meta: U2FsdGVkX18AwJ6Xqz0MJEmFgvnDnGDHbaEByb/LqLYmP9f6AUR/vSjbKiyejMTW+y7zVNeKNz6DEGp45YVd4MlPBZkdKMWHgRNnvLqWc7MxxuHYhl0c9l6aoDzl4OZx1t3+RFMR3wo60O+5WbK0bFbEXPrjh9xDDBU+fzUvVtSKcjlFJMVn8D6hzlm+y5n4v1iJ1LiulAVk2CPIVaYNfDoa+Aj1G7a8/rcGvGHikXbh+Ouhg/hAb1RqRpYRyTTsDmPFDD3ycMEeNgyAcQ7/YyUe5EQ1pTrdN5v+q8rWJ4ag1e9RoFKZy8YXtE2J2mypRzXeNfvlrAJ7gspOTHtKqZUwcte5bqw0m3waRvBvXUgTym570RboN9CuZ5A8TsV6oroIMma/hGmPRA6Kk+E7OZYvl73MaCAg8oGctLRoNgQbAeDZBEO/a7tYLAXV6aA2czvYwICaUlJH7snhDzum3ngBARjwMRJMBqPWzpdvaYLyDadMkqj1qn8C9ElERvzEidpujeyNqIw5QuepFEDwa1r7+LJlZMsRbXfiyx4Mt2qMCdPjsyKhw0JuL4oVGoTpnLadtc+pS+zn+beNW8Gb+sAIhkLpz5GyJyCvzykxyjhGf8+NCUBxg1h5ZHZcM9hvRnSov3gJtRjrtEARjBvkW7GrkErHo7IBv3pqwQsj+IFNbXOXyAlpGMU1d2sJvyXHC0zSayDEoHnBpNTm3hyhkqiQm5bz9hcpuvtOizHCa8Z88UgK9Gvvf+lbEQwxCpMrdxmnjbhDbT2G+IwahldB651+x7/d9/RJeNB3Hhmf7bPZOAUbtqqh4iX7ETmHmLyTL6U3mGRe6IxMIQc58hHB1lQzqeQNTKogYpZ3/OMcxeV7X9T1jZqMnSRGw9Jb2yIKMDEPoTVhRYcK4YWH6dnhGkgarr8qUY39OH118z7BS4+4hcvIy917uq/8BIpSrVfuqfXhGEE+waeYmkbvmWm
 ZqbEvMp+
 PPPO4iWp6gaTY/7us6WM0AYEn2WADzz0Tmf+/yE7CIvHpgAOQ9/VRDgENx6aHiQAVeSUaD+yNJLNP9QIZGutmUXtfi9chw92geExq4zw/iuePWn52jjte38878G4tXFK18EbFRmS5HUaGRKpZxlUGBNWBm1JuWx2CAdVdadZBHWd0aC/HuEhHoKbZTrUp/idTPJj/Cmy5MzlFKGhioUDgpRBqsUn4sQ2HmaN1hiw5TQ7k6sS2z5EQVywybtj8f60u5jGMzTSOgE8X3MbVXqRmFgF4JDsFraF8QcMR0NORT3Xb/9OrE0SpTUCi2DFUO6jkOEQkokynXDi4VI2kXnSZMRyvKsw8cI22XoIiD1Z9ID5qxIbOJEwv3PrgfWykCRnViPbnHhWFTjfaS6srfDEqxFBVdYSYNEjlrIerAIRBsuxhYuxmOMKqAJrxNLWAmWuCxBNTeBPzBXECxMTbdNYSiVaw9gxtoukDEGxbKuqhYHT8v8HyT6/uL0ta0hUbVQ51mT97K0ND1ZcPYjWD31S7QXNAjANIjJaXr/o4Gr7uToPh7kg1YbUFmBzOmRwis1iMLB5CD9ZLKSWNurjjhtLKisUqUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will utilize this new kfunc bpf_mm_get_mem_cgroup() to retrieve the
associated mem_cgroup from the given @mm. The obtained mem_cgroup must
be released by calling bpf_put_mem_cgroup() as a paired operation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 mm/bpf_thp.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
index 10b486dd8bc4..040f988dbdbd 100644
--- a/mm/bpf_thp.c
+++ b/mm/bpf_thp.c
@@ -161,10 +161,59 @@ static struct bpf_struct_ops bpf_bpf_thp_ops = {
 	.name = "bpf_thp_ops",
 };
 
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_mm_get_mem_cgroup - Get the memory cgroup associated with a mm_struct.
+ * @mm: The mm_struct to query
+ *
+ * The obtained mem_cgroup must be released by calling bpf_put_mem_cgroup().
+ *
+ * Return: The associated mem_cgroup on success, or NULL on failure. Note that
+ * this function depends on CONFIG_MEMCG being enabled - it will always return
+ * NULL if CONFIG_MEMCG is not configured.
+ */
+__bpf_kfunc struct mem_cgroup *bpf_mm_get_mem_cgroup(struct mm_struct *mm)
+{
+	return get_mem_cgroup_from_mm(mm);
+}
+
+/**
+ * bpf_put_mem_cgroup - Release a memory cgroup obtained from bpf_mm_get_mem_cgroup()
+ * @memcg: The memory cgroup to release
+ */
+__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG
+	if (!memcg)
+		return;
+	css_put(&memcg->css);
+#endif
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bpf_thp_ids)
+BTF_ID_FLAGS(func, bpf_mm_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
+BTF_KFUNCS_END(bpf_thp_ids)
+
+static const struct btf_kfunc_id_set bpf_thp_set = {
+	.owner = THIS_MODULE,
+	.set = &bpf_thp_ids,
+};
+
 static int __init bpf_thp_ops_init(void)
 {
-	int err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
+	int err;
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &bpf_thp_set);
+	if (err) {
+		pr_err("bpf_thp: Failed to register kfunc sets (%d)\n", err);
+		return err;
+	}
 
+	err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
 	if (err)
 		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
 	return err;
-- 
2.43.5


