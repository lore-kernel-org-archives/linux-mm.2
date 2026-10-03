Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054B6CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1A36B009B; Sat,  3 Oct 2026 17:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7634A6B009D; Sat,  3 Oct 2026 17:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651176B009E; Sat,  3 Oct 2026 17:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38FD96B009B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:08:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3600C0A3A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:39 +0000 (UTC)
X-FDA: 85282553958.11.DDA8EEA
Received: from mail-yx2-f9.google.com (mail-yx2-f9.google.com [74.125.224.137])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7C06A0006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aZZ45NyM;
	spf=pass (imf15.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791061717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oz95vRs5vqLfyYxEe+xBnRvqmwtB91PGg+pYDCLuw98=;
	b=znBuVZQXM3oTHTP+BK7OD6FndBe7+Xk8VtKJlEz9Lpf5o7NgtE7xz80bDocF6QsQF6DNhy
	FUtp7zlIdQCxFtRLSSEyy0meBH9/58IfEpYjUeq+Yrsqlt+HC4XM422fzJ7M6N3xHdU4e4
	anmH1XSoqpYH7hpYZamu8ZxDCJ4jwpQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aZZ45NyM;
	spf=pass (imf15.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791061717;
	b=KVQFMq77oJ/HWzK4rBeSbEvDI4RaMExXsJnFLrtEkj1nlnN+9gjYJT5/STQL9ttLXrVwd0
	8ATpCvWvjXAfC26SfObFe9NXuA4/3cAjD2JmA5SREKAK/2MGQuM0QlRXrpvjSwz45VtV0Q
	MZCnZ5idXwVr8dEPs3QivWgfkNnxNVE=
Received: by mail-yx2-f9.google.com with SMTP id 00721157ae682-8a242f44e2eso973947b3.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791061717; x=1791666517; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oz95vRs5vqLfyYxEe+xBnRvqmwtB91PGg+pYDCLuw98=;
        b=aZZ45NyMlh2yYcc6nNC3YRrgI3hQqEgaIHt+t5jfQxZQRe3PijZQ36VPfyfUq+bjFv
         0BNeiJb67tDhoL3yRJZckp+C2mUnwxiSfT24R+9FXJv3Ydz+T9k8qYnDaCIDtI/aGQ5i
         /LPw2aqK/DwWTVjQenEl3K8yR6cIcKYrn8fsOVWRvNZMIBika6Ac8Qluy9PmOdfhlr9w
         4hXepVWPuwemYy+KoPNqNzSlImi0WuhOSLOn5XSRVTyYnP+mmO6kRYko6WJAGilcweyC
         zqdzwccPPT35G6mP5oW3PnAFDO7VycFL+GRf3vamhSGUT1DIq6hHqPtfW+Z/KT24l4yH
         KyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791061717; x=1791666517;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oz95vRs5vqLfyYxEe+xBnRvqmwtB91PGg+pYDCLuw98=;
        b=Pt3UQZtO8lgVygRLxSnsJLn8kDKHuu6LzyKN3rsCGeQQ7Igpd0AYe6uiNC/Jh6Haxd
         bgEciZQerqiSF5EF8sbtxRIO7WMiicV9YqgCkxcCxdv2tJ9ecwsFYUV7V5Bn9TtvUSoP
         kqi2ba6of2rYUWPN7jLfZNF33H5x7kTiYA9LjJGgVaXUhkTi4YeSsvJnuGJ8Q8+twLrM
         MSxWYd9mWF2hb5ib0te9m6ymhA2HIjjvFI0f9T/PbGsfZQgJS3jYzqy9BWctfzOPJp3b
         PCc3xhDNXfNx7DFN4CT1WN0WlrxE6o/bpRpoM+vcI+9sN4C+b0k/FSJYguapRPNN7THN
         TKXA==
X-Forwarded-Encrypted: i=1; AKwUvBxQqkP/2TWETXXltaZ0nw772XNMQfAb+TRcfsJCu2+18tKP+WdN45g4FbohZAlWripgsvlNuSlREQ==@kvack.org
X-Gm-Message-State: AFq9FYLc64COB1E0VSSX2V7jlH855v4crnkoTGsQWOCO4vNf0I/cXFvb
	0ovkWHSC3Ao5FoGy1YQ3BYofnFxpMgngK2eOAQB1VTYBoNKWQKHR6pGKcoEQMvPO6g==
X-Gm-Gg: AYBFou0vdXDmAbTR0++jGQwXB83ynbDB9cVIggf0dA5dAnzYHgByVnUJSO9wWHpk9Za
	0ACB4B9UDQV5o51CRByjZUy5iVM2vwrVGTwrz7mB9tnOi4Q7CWZ7I2CMxVCHFQpZpeHIdG17nNB
	TGhcaWFgQG7YGtSsZE8pysYopFqsX70W+g54fqB3O7OubaetUjjoFxv+NvuNrUy1LElLvTIN98z
	Ow03JFZcGpc0IhGC+xMdujtnSQU5dM1SKjii9lBt11aFQXKdrmVRB5WAi1cieMdgN8rjJFN2QPb
	JZ8oAqE2W3lDMLrERZDuS7wyL+F+owxPPu1TeYwcakRHHfXtIj7ru/UmC1iXHW479Wfe/eZeKdS
	RPD34IfJ5htU12WA5zErfDMZC0cfqwgHkXTg1NtGnWpZiW7c2c/sp1kGDMtcNXv0mdAefUp0FSz
	RTDSuQzAYeOP6/ODG4BG5ZU/p9emVgfU9S6b0hh8LlEDXXHCSSFwCX8KOiVK/1LepiDONK1yz+f
	87uC707y8FLuAeXhWcRYDZNUX94GbW+vtvZzucv7RpMLtzGncjyqH2viJ4Qvaedz/k6oNEvRdLI
	Fsgyw/Ub17PPm/I1LH5UlN14kwbWDBCjoA==
X-Received: by 2002:a05:690c:e68e:b0:8a9:693a:324 with SMTP id 00721157ae682-8ae95ad6211mr7290727b3.109.1791061716860;
        Sat, 03 Oct 2026 14:08:36 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af0d179d3bsm743537b3.40.2026.10.03.14.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:08:36 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sat, 03 Oct 2026 14:07:59 -0700
Subject: [RFC PATCH v3 6/9] mm/damon/sysfs: expose perf_event prep
 attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-6-0f00417b41bc@gmail.com>
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: uz6tx9w9g45cgkqgikri6bpnktfou5rs
X-Rspamd-Queue-Id: D7C06A0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791061717-521486
X-HE-Meta: U2FsdGVkX19W6H2szmqzr7Rignw+9bpnU7oRHTcXT8avOfZtPsB0M/OE3HWmTXs+rA6sHSw7H/5WuFbnaMFkvvzEI9IPJXmTMnzLInQVjbllpNYA7vYqs78Ov/YQhAcVqtDZfiT81hRs7UYCn8n0sUgjTezEocE+i6cWxk5UVucAnSbMZF/8tZNq8Ap5YTLIws+DIq3S9MViJC+IKNjVOYEu1rSHZgvw/FMbRtzcK8U2p9osxujpsK+4eQPN/qaMVlc8Qu6HrZyoRCChJlb19W1SrsJWOsNuOOBsXSmlmZtA51i0ZPGWoREaJPagW6M0r43/QCIvlPJtLh2v1Sf47LkijEfJ6wjTHxzAeTxXmcS7rEodnGIoSdNPpD7+SKxuaKE0hJYbV1eHxY8A/Excr4rlNCLMwxopM75N2+U0iJmm3MxHtlbGu2roMcRbDPiuEVTAbREmh3jacKKn31QTK5O7N/ogYwDc3Ap83bg4gCTLKaOYv14sfSpNV3n6eedwiqE86LHBaqPmh8JiwB4m8514bYtCd8kfEfJwBR8s5Sb06LyVWroNMGLu8XuRMJ8fETzgaip72WtnsBU4jNCL8IjDfpBr8uhu2XKw+C9eflONXNxjLWAgLLCtTFU69a4GaOTehkHuMndoruiHXOOj7cOWh9MLvYDcrL5EHc8qMvm5mcRntJsgNyZ4sm3lKxzt+uA0nMj3UagodU/4mOPfZ6GG5iHrI5yQkFNVZ2RAZrm9kAIeCN2rqMgU2zrVX7KhE6RoCOu4An4/a2xRinNH47gnMLNA7hDzrooynO/aJW6zaN6tIcD8D2c63OY/LlPnZHSDsE1mzKzGOpio/MCDLo/mlVBsdlkkU7P7oazU6mxHtv4pRHOUiD6yBGgVz5FMhgMvxA4kmN2BlPHph+jyZmMa0mHmytQHzZ2ZV62hiewijClXIvaPFmHgHHRv8+1Hidgs0rAfumomoxoOqR5
 ik1zsulX
 ZDidUTLHz+ADe7ICeWxuEXZS9FVxO2oCpRrKkCMPcK6CQj6Gxp3Ak+vkGDKOU4MF4AJiQd5M8Ey9n6MuFvbntzOr9I87TBnYXAttEDYdiRyAtTCvYhS1ptBbjGlqsWci2xptnwh/ci8lgX0qS9mLUcJqBiGNIdHMY4vi8ZLyIs2RzIszQ8iEkx2rQW3vdgJ9/31VN69WQB7bX2FoNSAs/LoA56AZdXSuuIy8bWgtyxWQ1EumLs2wvv0HcHQMzhMFrvYBlUjXr3c5Iq5yDuyx2Akx106DZ+9BaUVHU2WOTYy7sHWqc2EXncBwfVKym8MR64YaBYjimDP9ICy0/Q9QJHY2dXrEwgCQJwaSTYuO+9kFjXUXgRWqQnJl4b1GBsCJwH6+nmYnk6QmE9tu2t+CPGI4/ZRAWjqe5ObRUR/AaPYMZkm3eK1RjdhN5nD8yNBBCf1fWS49Bu4ET9RCzlQ4z/KOZV7yrF9Ir/XPoNMQt5LyaFSmMnLOGQtU6MGdgafJYIFU9BH+8AGKSi/xA6RDdpAoT7WVVuT5XywVVWmyjt9K7594=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wire the DAMON_PREP_PERF_EVENT prep type added to core.c and
perf_source.h into sysfs, so user space can configure a PMU hotness
probe entirely through the preps/N/ directory: type, config, config1,
config2, sample_period, sample_freq, wakeup_events, precise_ip,
sample_phys_addr, sample_weight_struct, exclude_kernel, exclude_hv.

For example:

  echo perf_event > .../probes/0/preps/0/prep_action
  echo 8          > .../probes/0/preps/0/type
  echo 0x100      > .../probes/0/preps/0/sample_period
  echo 1          > .../probes/0/preps/0/sample_phys_addr

damon_sysfs_set_perf_probe() builds the damon_perf_probe_event from the
prep's stored attributes and, when arming, calls
damon_perf_probe_setup() to open the PMU counter(s) immediately;
deferred (non-arming) builds carry the attributes for a later commit to
arm, per the commit_live distinction in the previous commit.

damon_sysfs_set_preps() validates a DAMON_PREP_PERF_EVENT prep before it
can reach the PMU: sample_period and sample_freq are mutually exclusive
sampling modes, so setting both or setting neither is rejected;
precise_ip is a 2-bit bitfield in perf_event_attr, so a value above 3 is
rejected; and a second DAMON_PREP_PERF_EVENT prep on the same probe is
rejected outright rather than silently ignored, since a probe can only
ever be backed by one PMU counter.

Co-developed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/sysfs.c | 283 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 269 insertions(+), 14 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 80e6fc8004e5..36bccf948025 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 
 #include "sysfs-common.h"
+#include "perf_source.h"
 
 /*
  * init region directory
@@ -756,6 +757,21 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 struct damon_sysfs_prep {
 	struct kobject kobj;
 	enum damon_prep_action action;
+	/* perf_event_attr subset; valid when action == DAMON_PREP_PERF_EVENT */
+	u32 perf_type;
+	u64 config;
+	u64 config1;
+	u64 config2;
+	u64 sample_period;
+	u64 sample_freq;
+	u32 wakeup_events;
+	u32 precise_ip;
+	bool sample_phys_addr;
+	bool sample_weight_struct;
+	bool exclude_kernel;
+	bool exclude_hv;
+	bool freq;
+	bool single_instance;
 };
 
 static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
@@ -780,6 +796,10 @@ damon_sysfs_prep_action_names[] = {
 		.action = DAMON_PREP_SET_PGIDLE,
 		.name = "set_pgidle",
 	},
+	{
+		.action = DAMON_PREP_PERF_EVENT,
+		.name = "perf_event",
+	},
 };
 
 static ssize_t prep_action_show(struct kobject *kobj,
@@ -834,8 +854,122 @@ static void damon_sysfs_prep_release(struct kobject *kobj)
 static struct kobj_attribute damon_sysfs_prep_prep_action_attr =
 		__ATTR_RW_MODE(prep_action, 0600);
 
+/*
+ * perf_event configuration attributes.  These mirror a subset of
+ * perf_event_attr and are only meaningful when prep_action is "perf_event".
+ * They select the PMU (via type/config) and its sampling parameters, and are
+ * copied into the perf-event probe when the kdamond is turned on.
+ *
+ * The sysfs file names stay bare (type, config, ...) while the backing C
+ * symbols are prefixed to avoid clashing with identically named attributes
+ * elsewhere in this file.
+ */
+#define DAMON_SYSFS_PREP_PERF_U32(name, field)				\
+static ssize_t damon_sysfs_prep_##name##_show(struct kobject *kobj,	\
+		struct kobj_attribute *attr, char *buf)			\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	return sysfs_emit(buf, "%u\n", prep->field);			\
+}									\
+static ssize_t damon_sysfs_prep_##name##_store(struct kobject *kobj,	\
+		struct kobj_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	u32 v;								\
+	int err = kstrtou32(buf, 0, &v);				\
+	if (err)							\
+		return err;						\
+	prep->field = v;						\
+	return count;							\
+}									\
+static struct kobj_attribute damon_sysfs_prep_##name##_attr = __ATTR(name, \
+		0600, damon_sysfs_prep_##name##_show,			\
+		damon_sysfs_prep_##name##_store)
+
+#define DAMON_SYSFS_PREP_PERF_U64(name, field)				\
+static ssize_t damon_sysfs_prep_##name##_show(struct kobject *kobj,	\
+		struct kobj_attribute *attr, char *buf)			\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	return sysfs_emit(buf, "%llu\n", prep->field);			\
+}									\
+static ssize_t damon_sysfs_prep_##name##_store(struct kobject *kobj,	\
+		struct kobj_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	u64 v;								\
+	int err = kstrtou64(buf, 0, &v);				\
+	if (err)							\
+		return err;						\
+	prep->field = v;						\
+	return count;							\
+}									\
+static struct kobj_attribute damon_sysfs_prep_##name##_attr = __ATTR(name, \
+		0600, damon_sysfs_prep_##name##_show,			\
+		damon_sysfs_prep_##name##_store)
+
+#define DAMON_SYSFS_PREP_PERF_BOOL(name, field)				\
+static ssize_t damon_sysfs_prep_##name##_show(struct kobject *kobj,	\
+		struct kobj_attribute *attr, char *buf)			\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	return sysfs_emit(buf, "%u\n", prep->field);			\
+}									\
+static ssize_t damon_sysfs_prep_##name##_store(struct kobject *kobj,	\
+		struct kobj_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	bool v;								\
+	int err = kstrtobool(buf, &v);					\
+	if (err)							\
+		return err;						\
+	prep->field = v;						\
+	return count;							\
+}									\
+static struct kobj_attribute damon_sysfs_prep_##name##_attr = __ATTR(name, \
+		0600, damon_sysfs_prep_##name##_show,			\
+		damon_sysfs_prep_##name##_store)
+
+DAMON_SYSFS_PREP_PERF_U32(type, perf_type);
+DAMON_SYSFS_PREP_PERF_U64(config, config);
+DAMON_SYSFS_PREP_PERF_U64(config1, config1);
+DAMON_SYSFS_PREP_PERF_U64(config2, config2);
+DAMON_SYSFS_PREP_PERF_U64(sample_period, sample_period);
+DAMON_SYSFS_PREP_PERF_U64(sample_freq, sample_freq);
+DAMON_SYSFS_PREP_PERF_U32(wakeup_events, wakeup_events);
+DAMON_SYSFS_PREP_PERF_U32(precise_ip, precise_ip);
+DAMON_SYSFS_PREP_PERF_BOOL(sample_phys_addr, sample_phys_addr);
+DAMON_SYSFS_PREP_PERF_BOOL(sample_weight_struct, sample_weight_struct);
+DAMON_SYSFS_PREP_PERF_BOOL(exclude_kernel, exclude_kernel);
+DAMON_SYSFS_PREP_PERF_BOOL(exclude_hv, exclude_hv);
+DAMON_SYSFS_PREP_PERF_BOOL(freq, freq);
+DAMON_SYSFS_PREP_PERF_BOOL(single_instance, single_instance);
+
 static struct attribute *damon_sysfs_prep_attrs[] = {
 	&damon_sysfs_prep_prep_action_attr.attr,
+	&damon_sysfs_prep_type_attr.attr,
+	&damon_sysfs_prep_config_attr.attr,
+	&damon_sysfs_prep_config1_attr.attr,
+	&damon_sysfs_prep_config2_attr.attr,
+	&damon_sysfs_prep_sample_period_attr.attr,
+	&damon_sysfs_prep_sample_freq_attr.attr,
+	&damon_sysfs_prep_wakeup_events_attr.attr,
+	&damon_sysfs_prep_precise_ip_attr.attr,
+	&damon_sysfs_prep_sample_phys_addr_attr.attr,
+	&damon_sysfs_prep_sample_weight_struct_attr.attr,
+	&damon_sysfs_prep_exclude_kernel_attr.attr,
+	&damon_sysfs_prep_exclude_hv_attr.attr,
+	&damon_sysfs_prep_freq_attr.attr,
+	&damon_sysfs_prep_single_instance_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_prep);
@@ -2261,14 +2395,62 @@ static int damon_sysfs_set_preps(struct damon_probe *probe,
 		struct damon_sysfs_preps *sys_preps)
 {
 	int i;
+	bool seen_perf_prep = false;
 
 	for (i = 0; i < sys_preps->nr; i++) {
 		struct damon_sysfs_prep *sys_prep = sys_preps->preps_arr[i];
 		struct damon_prep *prep;
 
+		/*
+		 * period and freq are mutually exclusive perf sampling modes;
+		 * reject a config that sets both before it can arm a counter.
+		 */
+		if (sys_prep->action == DAMON_PREP_PERF_EVENT &&
+		    sys_prep->sample_period && sys_prep->sample_freq)
+			return -EINVAL;
+		/*
+		 * ...and setting neither leaves the counter with no sampling
+		 * mode at all; reject that too rather than arming garbage.
+		 */
+		if (sys_prep->action == DAMON_PREP_PERF_EVENT &&
+		    !sys_prep->sample_period && !sys_prep->sample_freq)
+			return -EINVAL;
+		/* precise_ip is a 2-bit bitfield in perf_event_attr */
+		if (sys_prep->action == DAMON_PREP_PERF_EVENT &&
+		    sys_prep->precise_ip > 3)
+			return -EINVAL;
+		/* At most one perf-event prep per probe. */
+		if (sys_prep->action == DAMON_PREP_PERF_EVENT && seen_perf_prep)
+			return -EINVAL;
+		if (sys_prep->action == DAMON_PREP_PERF_EVENT)
+			seen_perf_prep = true;
+
 		prep = damon_new_prep(sys_prep->action);
 		if (!prep)
 			return -ENOMEM;
+		if (sys_prep->action == DAMON_PREP_PERF_EVENT) {
+			/*
+			 * damon_new_prep() does not zero prep->perf; clear it
+			 * so any field not assigned below starts from a known
+			 * zero rather than kmalloc garbage.
+			 */
+			memset(&prep->perf, 0, sizeof(prep->perf));
+			prep->perf.type = sys_prep->perf_type;
+			prep->perf.config = sys_prep->config;
+			prep->perf.config1 = sys_prep->config1;
+			prep->perf.config2 = sys_prep->config2;
+			prep->perf.sample_period = sys_prep->sample_period;
+			prep->perf.sample_freq = sys_prep->sample_freq;
+			prep->perf.wakeup_events = sys_prep->wakeup_events;
+			prep->perf.precise_ip = sys_prep->precise_ip;
+			prep->perf.sample_phys_addr = sys_prep->sample_phys_addr;
+			prep->perf.sample_weight_struct =
+				sys_prep->sample_weight_struct;
+			prep->perf.exclude_kernel = sys_prep->exclude_kernel;
+			prep->perf.exclude_hv = sys_prep->exclude_hv;
+			prep->perf.freq = sys_prep->freq;
+			prep->perf.single_instance = sys_prep->single_instance;
+		}
 		damon_add_prep(probe, prep);
 	}
 	return 0;
@@ -2308,8 +2490,71 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
 	return 0;
 }
 
-static int damon_sysfs_set_probe(struct damon_probe *probe,
-		struct damon_sysfs_probe *sys_probe)
+#ifdef CONFIG_DAMON_PERF_SOURCE
+/*
+ * Build a perf-event probe descriptor from the probe's DAMON_PREP_PERF_EVENT
+ * prep and attach it to @probe.  The descriptor is always carried (so the ring
+ * drain and the commit hand-off recognise the probe as event-driven), but the
+ * PMU counters are only armed when @arm is set.
+ *
+ * @arm is true when building the context that will actually run (turn-on
+ * path); it is false when building a param_ctx for a commit, which is
+ * discarded after validation.  Arming a param_ctx would collide with the
+ * running context's perf-probe ownership and return -EBUSY, so the commit path
+ * defers arming to damon_commit_perf_probe().
+ */
+static int damon_sysfs_set_perf_probe(struct damon_ctx *ctx,
+		struct damon_probe *probe, bool arm)
+{
+	struct damon_prep *prep;
+
+	damon_for_each_prep(prep, probe) {
+		struct damon_perf_probe_event *event;
+		int err;
+
+		if (prep->action != DAMON_PREP_PERF_EVENT)
+			continue;
+
+		event = kzalloc_obj(*event, GFP_KERNEL);
+		if (!event)
+			return -ENOMEM;
+		event->attr.type = prep->perf.type;
+		event->attr.config = prep->perf.config;
+		event->attr.config1 = prep->perf.config1;
+		event->attr.config2 = prep->perf.config2;
+		event->attr.sample_period = prep->perf.sample_period;
+		event->attr.sample_freq = prep->perf.sample_freq;
+		event->attr.wakeup_events = prep->perf.wakeup_events;
+		event->attr.precise_ip = prep->perf.precise_ip;
+		event->attr.sample_phys_addr = prep->perf.sample_phys_addr;
+		event->attr.sample_weight_struct =
+			prep->perf.sample_weight_struct;
+		event->attr.exclude_kernel = prep->perf.exclude_kernel;
+		event->attr.exclude_hv = prep->perf.exclude_hv;
+		event->attr.freq = prep->perf.freq;
+		event->attr.single_instance = prep->perf.single_instance;
+
+		probe->perf_priv = event;
+		probe->event_driven = true;
+		if (arm) {
+			err = damon_perf_probe_setup(ctx, probe, event);
+			if (err) {
+				probe->perf_priv = NULL;
+				probe->event_driven = false;
+				kfree(event);
+				return err;
+			}
+		}
+		/* At most one perf-event prep per probe. */
+		break;
+	}
+	return 0;
+}
+#endif /* CONFIG_DAMON_PERF_SOURCE */
+
+static int damon_sysfs_set_probe(struct damon_ctx *ctx,
+		struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe, bool arm)
 {
 	struct damon_sysfs_filters *sys_filters;
 	struct damon_sysfs_preps *sys_preps;
@@ -2322,13 +2567,21 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 			return err;
 	}
 	sys_filters = sys_probe->filters;
-	if (!sys_filters)
-		return 0;
-	return damon_sysfs_set_filters(probe, sys_filters);
+	if (sys_filters) {
+		err = damon_sysfs_set_filters(probe, sys_filters);
+		if (err)
+			return err;
+	}
+#ifdef CONFIG_DAMON_PERF_SOURCE
+	err = damon_sysfs_set_perf_probe(ctx, probe, arm);
+	if (err)
+		return err;
+#endif
+	return 0;
 }
 
 static int damon_sysfs_set_probes(struct damon_ctx *ctx,
-		struct damon_sysfs_probes *sys_probes)
+		struct damon_sysfs_probes *sys_probes, bool arm)
 {
 	int i, err;
 
@@ -2342,9 +2595,10 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 		damon_add_probe(ctx, p);
 		sys_probe = sys_probes->probes_arr[i];
 		p->weight = sys_probe->weight;
-		err = damon_sysfs_set_probe(p, sys_probe);
+		err = damon_sysfs_set_probe(ctx, p, sys_probe, arm);
 		if (err)
 			return err;
+
 	}
 	return 0;
 }
@@ -2443,7 +2697,7 @@ static inline bool damon_sysfs_kdamond_running(
 }
 
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
-		struct damon_sysfs_context *sys_ctx)
+		struct damon_sysfs_context *sys_ctx, bool arm)
 {
 	enum damon_ops_id ops_id;
 	int err;
@@ -2461,7 +2715,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes, arm);
 	if (err)
 		return err;
 	err = damon_sysfs_set_sample_control(&ctx->sample_control,
@@ -2475,7 +2729,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 }
 
 static struct damon_ctx *damon_sysfs_build_ctx(
-		struct damon_sysfs_context *sys_ctx);
+		struct damon_sysfs_context *sys_ctx, bool arm);
 
 /*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
@@ -2495,7 +2749,8 @@ static int damon_sysfs_commit_input(void *data)
 	if (kdamond->contexts->nr != 1)
 		return -EINVAL;
 
-	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
+	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0],
+			false);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
@@ -2553,7 +2808,7 @@ static int damon_sysfs_upd_tuned_intervals(void *data)
 }
 
 static struct damon_ctx *damon_sysfs_build_ctx(
-		struct damon_sysfs_context *sys_ctx)
+		struct damon_sysfs_context *sys_ctx, bool arm)
 {
 	struct damon_ctx *ctx = damon_new_ctx();
 	int err;
@@ -2561,7 +2816,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
+	err = damon_sysfs_apply_inputs(ctx, sys_ctx, arm);
 	if (err) {
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
@@ -2613,7 +2868,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	if (!repeat_call_control)
 		return -ENOMEM;
 
-	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
+	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0], true);
 	if (IS_ERR(ctx)) {
 		kfree(repeat_call_control);
 		return PTR_ERR(ctx);

-- 
Git-157)


