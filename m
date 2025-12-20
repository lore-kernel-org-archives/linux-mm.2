Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC7CE668B1
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA026B008C; Fri, 19 Dec 2025 23:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026146B0092; Fri, 19 Dec 2025 23:13:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18066B0093; Fri, 19 Dec 2025 23:13:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5CFF6B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:13:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8548FC0744
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:20 +0000 (UTC)
X-FDA: 84238529760.25.0D73CB9
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id E69821A0003
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gKvEL66b;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766203999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lVuR6pchH6jgQ09wItDn6PsrwL4FoyScJ2gG8GX4fA=;
	b=BfJpIUAwny6yiEFo/Pa3Eu6b1+Wsr6Gme4HE1rtOBCmtAcBWcCKzOkUXavNECVcIfvOzJf
	04VlcHpUJrJ1WlOUaBNu4vTkcaq5QKOQNhEqKYXMEMOPqbVFH2AXN8SUUeLmiAfMTJzlQi
	S16d7oVpFIzr1Ti0sUzHJWgird/O6WQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gKvEL66b;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766203999; a=rsa-sha256;
	cv=none;
	b=LRaAyvLX5tEytyJk/HzCXfc7ZUuonsn7kEFqXmfzifxXv6bHt+2B9CVpEAjcfDV2UGwsfy
	iDq3X5Zwoo+hmX69Vx2DwQaZocND73BOibamPnn1iMiz1W+e7tavVkx8G2+zoGN95BHBA7
	qq5eA6MpsjCfNGrW8gIzcL7R7EwFcqM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766203997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lVuR6pchH6jgQ09wItDn6PsrwL4FoyScJ2gG8GX4fA=;
	b=gKvEL66bO+z7ttjD2KYiVENpRi3zKONK7yhd9JuzI2g+oZjmwihxs7aJ8zy+GjcaQsorjQ
	MX1CKTmzFk0hY+p8+U7H8JUqNp7fr2kYYOY7Zra6m6YZh5ImZjq8aYES1mnZX+YNu3CyGj
	l3bhS1a+4gZYizhA2A/fnDbB2iNuxEk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v2 3/7] mm: introduce bpf_get_root_mem_cgroup() BPF kfunc
Date: Fri, 19 Dec 2025 20:12:46 -0800
Message-ID: <20251220041250.372179-4-roman.gushchin@linux.dev>
In-Reply-To: <20251220041250.372179-1-roman.gushchin@linux.dev>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E69821A0003
X-Stat-Signature: 4q6k1i3mbqi65gq79niw1ufa4tbg65cj
X-HE-Tag: 1766203998-374517
X-HE-Meta: U2FsdGVkX1+fay8yKnPT8ARbu3RHY5VvcrAuD+38VjT79rrjD12dgvIPKfVgLE9/Jevbmg+uBNY8PyP6V2DU4pLmWpfoKW/yXH6pJySJHLSsYVP/h/nbWkxKehvCv2XCXbZsSS+r0Jp1DDE5G2aysxbo49QSyxFqC0n9ZXLqt5TyRef/Dkemrk7IUNWfAT7xGjpe7T3PsQ764HayG2NOIq3wJSsHc7Xy7e40ZNE35L28/QCRpclSyaVutvDDurOJQDX7F/CCyUAGiMgNlkLoPvkmyRBD/3qTCZtKswnElmPdDKJvYqLngEYLlM+hZPOWC1XtzMFh+CTCfWcMsgQOCkk6G7/V7j3tvlRbFewWkYDmO/j0E/T+PV5W6mjIU5kFhiGUqJHVYsxxF6ry1eQ0IQKaU60YVEVPuw7+7nREE0auu3ljVHsmunf5VODhGJGsBv2JjsRD0/LGzMic5cB1U3fjFYnnKBzLd0FweLl9rzFW8qodLZjp74wzVnhffRTCv2uPtFbEDS73Itkp9dg+COGH5T4f+mKVyXQnTj+6rxWNhe3o0fWZ5pVp8LrVMqPkhJBEYBumZJpGmxLPTcxMsv+3OQbr9UwiXeP2zEz6Bsxal1PouVxKtVHLK6mI2rEuMNpeFjOMVzLpc9tIMqrny3PNDYn8AbdtrTi21qMjTgvZ/3iEZkbRaWT1iXEhtYnHveFOygiZNvqJlw2jnySv4AU2MxHjW5VCb+bcX3M8PKQpsvosgSQD9zVyMr+G3d2dhiJ0uCt2joGTMWdKY4XCQRIKTKVFPpSTqnJiMBSw72tUybU0rkanhpkJAcNlTJRgiq7XUjdLP2m/zwmaAUFH7wN5xO4rz3Jn09uu0SoaOn4e+iKxUmhJJIfylAnxSLmSj5DqH6vwlhlRFLl1qRoGu3KPPr59BrhR40KKtAP7Fo8W2Z7H40jj4xj3hPREZQocVuPqwVEUCNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a BPF kfunc to get a trusted pointer to the root memory
cgroup. It's very handy to traverse the full memcg tree, e.g.
for handling a system-wide OOM.

It's possible to obtain this pointer by traversing the memcg tree
up from any known memcg, but it's sub-optimal and makes BPF programs
more complex and less efficient.

bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
however in reality it's not necessary to bump the corresponding
reference counter - root memory cgroup is immortal, reference counting
is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/bpf_memcontrol.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 03d435fc4f10..2d518ad2ad3f 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -10,6 +10,23 @@
 
 __bpf_kfunc_start_defs();
 
+/**
+ * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
+ *
+ * The function has KF_ACQUIRE semantics, even though the root memory
+ * cgroup is never destroyed after being created and doesn't require
+ * reference counting. And it's perfectly safe to pass it to
+ * bpf_put_mem_cgroup()
+ */
+__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
+{
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	/* css_get() is not needed */
+	return root_mem_cgroup;
+}
+
 /**
  * bpf_get_mem_cgroup - Get a reference to a memory cgroup
  * @css: pointer to the css structure
@@ -64,6 +81,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)
 
-- 
2.52.0


