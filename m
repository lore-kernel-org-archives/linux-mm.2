Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6D1606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=V/Zalpx3
Received: by kanga.kvack.org (Postfix)
	id 94A356B05BC; Sun, 22 Nov 2026 13:45:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D45F6B05BD; Sun, 22 Nov 2026 13:45:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C396B05BE; Sun, 22 Nov 2026 13:45:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8666B05BC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D020120720
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:10 +0000 (UTC)
X-FDA: 85463632380.30.C22C8DD
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf18.hostedemail.com (Postfix) with ESMTP id CC7831C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="V/Zalpx3";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3MzgDawoKCBAz9x4Awx943w44w1u.s421y3AD-220Bqs0.47w@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3MzgDawoKCBAz9x4Awx943w44w1u.s421y3AD-220Bqs0.47w@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373108;
	b=UzR4OQpiQoDphXC2vC8r06BDWteEtcMcg0gVtStzHGSCapOGgWtPe9Kloj0GypW49SxboJ
	4MVlZN720cXAMHoxTiHCPPGc9ttoziLFcGt5Y9gy99JyiaUGTWhks2yN4YbyeU0XK59lXr
	dbNeyndq0YiaExJK2uu1vqQUsZrMkl0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sy99F9v1h+ZocL+7gIZompqknwKF5VmSur7QJmb24aY=;
	b=n0nww1+RGbRRM/JoUyYj0vLuPvg51tTzQj0Ek5c/6jaAw6Xj8M/IK5eIAEv9xnX+T3XZTq
	+EvXl9sQNK/V9AN7DRgd9ZC4R/qyQB5DaOiXtv5mZQmvWMjF7eJmKXZTKG+st81l0ODc15
	qc7dEsJ869gTlQfiIiDy/D/6TY4lEXA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="V/Zalpx3";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3MzgDawoKCBAz9x4Awx943w44w1u.s421y3AD-220Bqs0.47w@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3MzgDawoKCBAz9x4Awx943w44w1u.s421y3AD-220Bqs0.47w@flex--jthoughton.bounces.google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b18165dc53so3084907a91.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373107; x=1795977907; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sy99F9v1h+ZocL+7gIZompqknwKF5VmSur7QJmb24aY=;
        b=V/Zalpx3UAYrmeZwmAX6fy/remyp0XZ7S8QULE7SfEIZz9PA7F759iUuLBGrs3UhDd
         V/rqja76ESRUkARdqkqLIJryVhwIq2YIKYP6HFdyb4dsmIsRuhDw5m13bYXSUXrPf9PA
         6rqwEBlXBCt08/eM1FifjGEvuLRkkKbshQZ0id3dzQqHvD5gk+GHmNBQQeOcFq/hwnB/
         mmyL0JVV2ohwMDO1VP7InQWRlkjxeQblN/JXIPo7alsJlLE2oZDg7sIOEOqLn4WGgtzg
         Az9EGIytJ2oQAZiCUihVwi7sLSTXdakJF4w2T/MVtsnSLmMyNsJmZgugKk2Jxuzv41VY
         2Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373107; x=1795977907;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sy99F9v1h+ZocL+7gIZompqknwKF5VmSur7QJmb24aY=;
        b=qVoWM5kK4ztgWC0cnWdq6orYKN0OHjjWylvBW/1B9apLCtFe5cggsRyojpCHUvcxYc
         ErQ7Gwj2bTxb0Gzis7E7fWNOzt6BB8fo4WJkOUsei4w3jm69BO9kvZDV/Kdg7gh6AjAx
         /r1z1VXE8rofKQBWVigvPJnWTIjqvhDQaYqZCsO2mVkV53qhYuKdUdwkiEORRkesDNTa
         thQdXAfHuIibTfzX4q9jzeCbswfva8jmz4SXsyO1q3XfxHBAG/wPy56k6zx8CzMicLOF
         Qvqwu0PijtqAYv4+6hGvrOD2B4Lwavr4GM54gE24zkpWJGzFVg5GoF5DyrjYNCGzomgm
         Gz6Q==
X-Forwarded-Encrypted: i=1; AL+hErGS49vuHzAihkBSQ7X8D1WhAVNvrAEzogghSe5a4aN5VTAtfL/krZ9cc3zg098BqdBnjh8BczYZpw==@kvack.org
X-Gm-Message-State: APuU4Z+iQaYQcqamYSqjvDjHh2vmR4nCmxvqLuFQZe/AriLZMv1cybx0
	5bTYhoxBUiuTiSQlUMwEB+W2EigA0zEHeOT9AByxt9Hr2VSLZe3Umgsyuwf5Ib5HkpRk+3NivPg
	FVSRRQoin0LFyhUX8ZRugHw==
X-Received: from pgbx7-n1.prod.google.com ([2002:a05:6a02:63c7:10b0:cdc:b85b:3d46])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:57cc:b0:3a8:185:cf40 with SMTP id 98e67ed59e1d1-3b41c9b2d2emr9616562a91.10.1795373107406;
 Sun, 22 Nov 2026 10:45:07 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:42 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-9-jthoughton@google.com>
Subject: [PATCH v3 08/19] hugetlb_vmemmap: Expose whether HVO is enabled to
 architecture code
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC7831C0005
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: tsqwf1mo5nuzp5nxh56sqoounztfb5eo
X-Rspam-User:
X-HE-Tag: 1795373108-777926
X-HE-Meta: U2FsdGVkX19L58/5xScyHIjyZROnXpFgFayzRGcRRuqdrZMakaofiTBdWEBDTkh0qZansZXyHSCERHvCFxD3s4psR6PSjQYnKtLHwa4gkIOEmjmLEBN83KM4DJ4dkeD/3RT1oP9HPt2QTB5IBOvVOVr3nuIkFtpZF2B5U/XOXOyXTf3sl1/bJTxkXSqaLCh1QWuXtYdWrmi6tY/vIfVvLbYlzxBEuam0if5zoxapgsfYFyKIvT3+vwLlromJvN0iIl+VuqYkfUPUNiR5So3TNa3egBRshpGAy2Rg4V5sUcWWDyexiBPfCEOTbwutiHBUQ8KXyeaeqRoM6R37PLUquxERuJz/anDpeKJB1ueZlrJsXZcit8jWs6cyicZPhmFGWES9WnqHqZ4xYS6G7WzqsswNkSb/iqlhY8lV8b4HeuRrk+lpNxLMExrGpVoTRt3RFg96Lw2CeM3WbEvMsOjVCHORRqtgz07PtwcPdONK0X5wBBkR4ET3DPmvbVO2i2zMHqWK4QG8WJ7O81iLQzxxS5/QyzakRlv0ML+TKelISoBsoLy19qzkaTJlDaRIohhR8kYo/jbKthxgZCCaqevaiAjvyyiB/8qnypy4g7IsYp9rQ8hSqHa4rcfMf+hzf3lU8gU1JJyuzid9Q/1deIF0c+lOSMedAUip5CMcSkvMzZmQNGZtBolsaZdS8nZxaN14YRBZdXjAOC9Eelo3i+l0hB19rwF2VMt5aEteGe9Dss7er2S/5KGyB5/k1dsAN+uce5xflG4+1qW5hoqGvmaLrUWq9HPogCOMXeU2wNdwIXOcbqxOME/mflq15NfiLhtsYsk2P7P7w4hwmje0hWM0hSHXnWzRGkbnsyxpBF7GeSdS5m9l0hTpJEAfwcwl3pA1wgZECbNMLY0I/xes5vt6Rp1V9+PiJirB3zDTnVNXmbaAyk3SvlybRYYCBOIYCODebaCQaY4urfvROa8VGQ9
 85h+zzvn
 umGekomBljlObljPRvMGsQWcaEezzgOYOk+g9Hz50qdpjkkz/DeuWzVqLoA/QRdjg1vmj2bhqFbZs7iBC6HTLzZtmDAbw6odTh9kqYUfdB433HebMAJ9C9Iy6wvrTCUORit0hx400TG5U5zKDsTa6Rp6fWfzfvMR7avS1tkz/m4NCcENNjEkpcJbDIR3+E6V+WlITDVa8By6OdAmgAss43SPWSWuMvCLZMmRUHt0Jvrqz4lXJAVQqlpzlTS1tPKAqTwt77na1iCaoez9sqX061GAcjCYI9g+xwEjet0rmXM3feESq5+zZu1jwyOMY/ctLQHYHleT56XT0wvH/WHqVqTOjYpTG5JaCzvV045Rw5FFZpuwB7S6OVenAAAFt0y/x1E5AsvDspRIVQn6BzWkRUzqrvVLWNj7tfQDf1G8hCTLsb5rQS5JCTt8n+u+3McDe4zXh0aqqCI3ao0Rc0aMfUUMqxSKmqI4quttVZu1UiBlS+K1ULq8z5Pp3fPQutUPb8fyXznRJPpA7+Dr1CuL3wmjHKsuZLAGbHHqdIrbBGTMpe2vo9WEh7CSYlo/jWs1/rtTx0ATxHpnx+wi7WuSP/xN0fFCaohgT3fLWolRq1Ea5T9jZdPzUazAS2aRQ6KB9L/mChEVonWNY7vjGeiWL3ftV9rSW6qu9mC/TmsJySoWEPnSHWXdZxaEnhjA8usGs2TwqwL8rUxlrZgqe3QDW2KzIhkAgk7GBAYA0ocnVkyA8/oe81FKjUDqekmpP3bX8HKGc5yDdwQV9yuL9kM3uqDWoudSXC+UuPkpbTOeIS6TBCLNsFXg/djmKmbC0VS5R9+rUzM+3p3lpaGge01BUXAh0KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Architectures that select
CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO may configure the
system at boot depending on whether HVO is enabled, e.g. arm64 may
require all CPUs to support hardware access flag updates only if HVO is
enabled.

Add hugetlb_vmemmap_optimize_enabled() so that they can check. It is
declared before <asm/hugetlb.h> is included, so that it can also be used
from inline helpers there.

It only reflects the hugetlb_free_vmemmap= kernel command line parameter
(and the sysctl, when writable), not whether the architecture supports
HVO.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/hugetlb.h |  9 +++++++++
 mm/hugetlb_vmemmap.c    | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0d5414392d87..b2a6441bcd84 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -22,6 +22,15 @@ struct node;
 
 void free_huge_folio(struct folio *folio);
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+bool hugetlb_vmemmap_optimize_enabled(void);
+#else
+static inline bool hugetlb_vmemmap_optimize_enabled(void)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/pagemap.h>
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 142f2975846b..fb6da64bd80d 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -452,6 +452,24 @@ static int __init hugetlb_vmemmap_optimize_param(char *buf)
 }
 early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_optimize_param);
 
+/**
+ * hugetlb_vmemmap_optimize_enabled - whether HVO is enabled
+ *
+ * This only reflects the hugetlb_free_vmemmap= kernel command line parameter
+ * and the vm.hugetlb_optimize_vmemmap sysctl, not whether the architecture
+ * supports HVO (see arch_support_vmemmap_remap()).
+ *
+ * The value is final once early parameters have been parsed only if the
+ * architecture selects CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO;
+ * otherwise it may change at any time through the sysctl.
+ *
+ * Return: true if HVO is enabled.
+ */
+bool hugetlb_vmemmap_optimize_enabled(void)
+{
+	return READ_ONCE(vmemmap_optimize_enabled);
+}
+
 static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
-- 
2.56.1.809.ga0b61035b5-goog


