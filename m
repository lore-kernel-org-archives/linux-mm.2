Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 254FFC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E21F6B00AD; Fri, 21 Aug 2026 14:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848166B00AE; Fri, 21 Aug 2026 14:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736416B00AF; Fri, 21 Aug 2026 14:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43DCB6B00AD
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE6A7C0224
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:17 +0000 (UTC)
X-FDA: 85126187034.15.584D5C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 83B8F20008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fgMUOJM/";
	spf=pass (imf31.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338695;
	b=Srjsvf2Sk9geIy71FkdycPAPi0Z0RrxSKqhmoLhsHlFCKy7w0bUkYq6U1oU0JmFhWCZKxl
	yHWwRZZP4ToZJ2NWaRzJq3oWU+52xYbZwyDz8TjDlxoBvGKM3oEc0uadjYb+9E8Spm78DO
	1owu8NYus+VwDAIdIOVUIwqW7XNw4Cw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fgMUOJM/";
	spf=pass (imf31.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7KnOp/dzi6YYMtNTCErSrAxbzUuBVlszjrt1QEKyR0=;
	b=edPl4J6Z7dwe3FDVwGgl+Ro8ejpXLxORAsnm9fVMk5unlp2PHl+mb5P4kLybSc5ZMhe/No
	AU8EyZx00T3n359bigHAV5ccTzrGWAETEg0H9qhHbX+XMvo7HjBEOCNzNYbeVjpTz0WTmg
	bk6MjLkWxSqwCM0V87Vi008fS1zkblk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W7KnOp/dzi6YYMtNTCErSrAxbzUuBVlszjrt1QEKyR0=;
	b=fgMUOJM/DHQsZaZvfXedGquA/u+mMQk1I436f2jyl5wufdZFdgZMbip+cL8Zq5NzyMNzzJ
	dChokqA51nzRv44uTSpbpBM2DY939+Nm+bVsxiqKna+L8j8moaCIKGimodeVck/5V05FUy
	K/KRiZ1uUMrc0+SXkGbJHTOyIXw78wM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-Zpoif1kQPcaRSi_Hgbje5Q-1; Fri, 21 Aug 2026 14:58:05 -0400
X-MC-Unique: Zpoif1kQPcaRSi_Hgbje5Q-1
X-Mimecast-MFC-AGG-ID: Zpoif1kQPcaRSi_Hgbje5Q_1787338685
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93494527488so218329085a.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338685; x=1787943485;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W7KnOp/dzi6YYMtNTCErSrAxbzUuBVlszjrt1QEKyR0=;
        b=fFZKnVyJLZ5+Bj2KAs8zORAJfpQT+iKBl0gpPkUt34tA9QE2q2vRpMyh3mooxYs5Yj
         6RJUqvegfXBj2WfglAXs0cII9gYLk+mC1o8M1w71fKq9XWYxhaMCCoK7dZM+p6mp5aS/
         asDOUDgXk7ujIiIR1dyiTQ71CFt2Tjb8AcV1jh5fSQAyHErVMhyABoRI0hEDMg6Yie5l
         y7ax/2X69Qqkckf9nHh1rA6ykSaFHYZmbDsWiJTEGd3fSPK/pOQhaFoWjqoHo2O/jpKK
         mTnsDrYbbf+jKJOX0YrmVTY8V996sDt66FWZSZCJlzR3EExrU8PdgMCVDKYVURSN9mCy
         g2qA==
X-Gm-Message-State: AFuF++nxC4IHicFEobKI5676scqO19K0PuLOoLMeWNaoVyM4xqZu9oIY
	ghlEjscUOteYVsSOBxoGcYaMo1fUXTDYXqqNmMwd/+hlD8OEYPrYlCkWElnqI255Mi4arm3qdRx
	8P4ozCjS1KO/aDcya/zZYQi4xSnMLm//CuMBKemM8xQbn07rKzDPP
X-Gm-Gg: AR+sD11cW7UShFi7Q2V4IPly+ir+pDFqF70G2tRDQIOL07yJdfcBEDkGXRY+C1vVUz2
	pHgxNu5aA1+J3AsrxU2DC7Ap+bCY8xO6S3qi2vaV0oDQsIfXskiy8cundzOlD16PiB4cibuQ+XM
	WfNZqXQ4hPqWH7bGjArO2tes46sX0N183n0rm7UCO7ea8d0XaPKV+QeKIkEIbXxmZKCkDcvCj/D
	ZUpiZ/JjEqoKAzdRhM+GW7IJiLYJaYibW/ukUPuCHHidGotvr51Me+agH45RHGnUpKHGwFIevSw
	GxkoPW/rqhNsveijeGwRJOsfYXjUjmwvb3eWwIlA3DWjCOHVD+VJ2b79rH58G08m6wdqr2Pfy0c
	KoqEb4tNlqgZycuZ/Vl62mdUj2SmQtAGGeJTB9v6YYA0a
X-Received: by 2002:a05:620a:601b:b0:930:a26a:fb2a with SMTP id af79cd13be357-937394324demr865130185a.2.1787338684947;
        Fri, 21 Aug 2026 11:58:04 -0700 (PDT)
X-Received: by 2002:a05:620a:601b:b0:930:a26a:fb2a with SMTP id af79cd13be357-937394324demr865124585a.2.1787338684435;
        Fri, 21 Aug 2026 11:58:04 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9372fdf59f3sm385976385a.10.2026.08.21.11.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:03 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:58 -0400
Subject: [PATCH 06/11] memcg: register per-area usage counters in cgroupfs
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-6-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CYLul-VP2b-rdTmpBeK5W07LCBR_3_kA7Wxp3Qr2dEI_1787338685
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 83B8F20008
X-Rspam-User: 
X-Stat-Signature: zykkjx6bpzg6y87qh7mxr9tgx83j7o81
X-Rspamd-Server: rspam06
X-HE-Tag: 1787338695-447950
X-HE-Meta: U2FsdGVkX1+D8W22w5TpjQRB3hcCOqWvtFdTI60cKS6ZaOIPfGryI8RL+UPM/3ZhCJqcKq97SGHojR7xafLaLde1PGTrF208k59mcCfaKG5+v9LVRpPMvQSwUV+a4wEJ18F3yARh8wWgTNiyPjm6I2AO7I4IcCYTVgZOYPor+HfIcdndARte/sVC1rb4igIT6EWGn1kOKbXNq+U3siIR64wwHTta6TQKbcM+x0zCGmqv1RIFSiWFUGTbfLRe9svOHXBbsMnj6rTF66tgKPfDQ/1WN3woglpsYkT+eRq8fzunng0lE1MxYvpF7n28PSsx3D/EsQU26/bow4oTZ+B7FhS9YBYczEIVKPVCG85FthTrAk1ktrRo6L+9WYyPknvTyR8F1fpnOqVO4QawuBwPAzBoILs5Dx5FJ8FjCsb7VFnQnm4xOvSsUE7OQJRDUnJZSZUXYjfjOSg8y1tXMbD5O/DOaTdKe5mNB/kIpK3tVQ31VaSAO0HC14nAwVOcYbe8qCR/jPjaxbbrgUpPHFVca1FdvhoVo8ZLrAZ6pJx/0fhgFvLg/Mxm3fKKimqlspeshpDNqgxDz8Sm4qNV9/+B65G1qW9kfyRwW1SFjXDAlqCFSPAt5hPUBSLoYbvp/BzJ0FlE41FggGxEuYtewY19wMQnRkIDNCxmW6A6uiMaPU/66HGcBlw4qXuuvy/wTQ5tn+AqPhgjSiEt4HUEdEA8JemBnHVVgi7MkZ5fqaMWqTHZCapwrICaSygOt2NBLBXC/soN6iTIgiM4EuPrPtn2LZcHCgi8hhrNwK/v4vCEm1XOD/dQddiawnl6BsYxsBcnrJB4zVH8dpiaA9i1KA2lXmzyfThDLxHyo0orbsVNnOiAV+oZ3g7S9sqh0yqzUDt8FeaKNkDcXW+OYcIBWNN9d+5HVkk7dHXn5oYlbDZBkdHTTK6YDPfJOPdwv+L75xLHrO1M8VtP1ytRo+PEqPG
 a7gNgiza
 0twA75mbT2gh4D9+UDWW0IGPQeD/c8yPHC21bqoWEAjlblPE8pVbWpaGZCHvWzngOi86Y+pYKzYdAz7gsbXmDq+FZhqpEacvch6Dg5uVsWXYjwfsTkrw5HV48SkG2sKQNGNWrDJ3yunpmdo2+NoLR0VEE7NjRHsCpFeqQ9vUKpXXicupJy1NF+zqXkDtwllYtWhx3MjO7eVel5evOeA7hvVMHxmfgEyUE8FXvGGL7KcTYziBmsmPUJADCAayhzNWPnvtm47CbSYDTG7H+66dmB4jdwOT09PDsyRjcV9g2+LcufZkPOchDyCbQ9dUMhYhPGvYSJYL+U+hT0NB3A4u2acdmX0638M95oyJ46++gkS3Bx13UBbqXILUT/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose memory.cma.<area>.{current,max} files under each non-root cgroup
when cgroupfs memory_cma_accounting option is enabled.

memory.cma.<area>.current reports the cgroup's CMA usage for that area.
memory.cma.<area>.max is a read-write limit (default: max).

Each CMA area gets a cftype template with its name set from the CMA
area's name.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 15 ++++++
 mm/memcontrol.c                         | 89 +++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 3dfc13f31a0c..39871a7a08a8 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1928,6 +1928,21 @@ The following nested keys are defined.
 	This setting has no effect if zswap is disabled, and swapping
 	is allowed unless memory.swap.max is set to 0.
 
+  memory.cma.<area>.current
+        A read-only single value file which exists on non-root cgroups. <area>
+        is the CMA area name (e.g. "reserved" for the default DMA CMA area).
+
+        The total amount of CMA memory currently charged to the cgroup for the
+        given CMA area. Only accounted when memory_cma_accounting is enabled.
+
+  memory.cma.<area>.max
+        A read-write single value file which exists on non-root cgroups. The
+        default is "max".
+
+        CMA usage hard limit for the given area. If a cgroup's CMA usage for
+        this area exceeds this limit, the allocation will fail. Only enforced
+        when memory_cma_accounting is enabled.
+
   memory.pressure
 	A read-only nested-keyed file.
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8eca00d30fc5..f28d610a59ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6182,3 +6182,92 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 		K(atomic_long_read(&memcg->memory.children_min_usage)),
 		K(atomic_long_read(&memcg->memory.children_low_usage)));
 }
+
+#ifdef CONFIG_CMA
+static int memory_cma_current_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	int idx = seq_cft(m)->private;
+	unsigned long cur = page_counter_read(&memcg->cma_counters[idx]);
+
+	seq_printf(m, "%lu\n", cur * PAGE_SIZE);
+
+	return 0;
+}
+
+static int memory_cma_max_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	int idx = seq_cft(m)->private;
+	unsigned long max = READ_ONCE(memcg->cma_counters[idx].max);
+
+	return seq_puts_memcg_tunable(m, max);
+}
+
+static ssize_t memory_cma_max_write(struct kernfs_open_file *of, char *buf,
+				    size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int idx = of_cft(of)->private;
+	unsigned long max;
+	int rc;
+
+	buf = strstrip(buf);
+	rc = page_counter_memparse(buf, "max", &max);
+	if (rc)
+		return rc;
+
+	xchg(&memcg->cma_counters[idx].max, max);
+
+	return nbytes;
+}
+
+static struct cftype cma_dfl_tmpl[] = {
+	{
+		.name = "current",
+		.seq_show = memory_cma_current_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "max",
+		.seq_show = memory_cma_max_show,
+		.write = memory_cma_max_write,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{ }
+};
+#define CMA_DFL_TMPL_SIZE	(ARRAY_SIZE(cma_dfl_tmpl) - 1)
+
+static struct cftype *cma_dfl_files;
+
+static int __init mem_cgroup_cma_init(void)
+{
+	struct cftype *cft;
+	unsigned int i, j;
+	int count;
+
+	if (mem_cgroup_disabled() || !cma_area_count)
+		return 0;
+
+	count = cma_area_count * CMA_DFL_TMPL_SIZE;
+	cma_dfl_files = kcalloc(count + 1, sizeof(*cma_dfl_tmpl), GFP_KERNEL);
+	if (!cma_dfl_files)
+		return -ENOMEM;
+
+	for (i = 0; i < cma_area_count; ++i)
+		for (j = 0; j < CMA_DFL_TMPL_SIZE; ++j) {
+			cft = &cma_dfl_files[i * CMA_DFL_TMPL_SIZE + j];
+			*cft = cma_dfl_tmpl[j];
+			snprintf(cft->name, MAX_CFTYPE_NAME, "cma.%s.%s",
+				 cma_get_name(&cma_areas[i]),
+				 cma_dfl_tmpl[j].name);
+			cft->private = i; /* cma area index for counters in callbacks. */
+			lockdep_register_key(&cft->lockdep_key);
+		}
+
+	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, cma_dfl_files));
+
+	return 0;
+}
+subsys_initcall(mem_cgroup_cma_init);
+#endif /* CONFIG_CMA */

-- 
2.53.0


