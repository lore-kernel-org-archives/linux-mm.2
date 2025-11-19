Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA4ECF3950
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730BB6B00C3; Wed, 19 Nov 2025 10:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9D76B00C4; Wed, 19 Nov 2025 10:45:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C3A6B00C5; Wed, 19 Nov 2025 10:45:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC266B00C3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1F4F59410
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:49 +0000 (UTC)
X-FDA: 84127782018.29.9215A4C
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01AD418001C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Z799A1FJ;
	spf=pass (imf16.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDp3sMBoTlmxBrCfHcN3bT849KzRdDNMVpiuychnTdo=;
	b=DVBKoqWEPYpS5+9BVUQEHlysPVVKT6PMoXelyOW7KVhV3hQ4iyeOoIQ0fdFs0vKQYIEaNG
	0v898PeQOHuBWhuFt8yA9U3qNxz0cistEA7rkz6aLWEOtCRRhN/SQGxmiuxMVGo3MM/f4o
	Cw/Jj/f5Y9FeD14wOTBGm2Tlwn2ORUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567148; a=rsa-sha256;
	cv=none;
	b=r7eDLtKAVWdEtBRt1AW1fBsfUUhNNfGpCUOTi7OYP0cLklKp13Fxd280uhdKiHA6nvyvJb
	jof0bfaR5hIl9xeistSUa/zd0DCKAMFTBRsz5Fbljbxdob0L8caRjBr410jZ5E03Lqq/UM
	k6S+UAVD84/a79to+RcR2MScDAZ7uWk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Z799A1FJ;
	spf=pass (imf16.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b32a5494dso4139007f8f.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567146; x=1764171946; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDp3sMBoTlmxBrCfHcN3bT849KzRdDNMVpiuychnTdo=;
        b=Z799A1FJH30EpTpOAtCnTcV9rlSQX0RExkMdEtyJMWpVBu4VtUqnjqazjxVuhEKiYt
         iDdhoPySiNq27Q9YVU6BmHCqLNTXY+JYNcE5lN0WpnBZXGhMgdleHl3P0rfnJEtbITLl
         k5AoyGpMc4MHGY0YruOjGkd8gYDAG8pFv5tj8PpHtJ5nqb6eMfWCO9rzeR7lGEAd0fJ/
         ZB6gjnehtx1/AoiHnxIuJBzNu4VXTc4oz/0WtwE20DvYy62qVEtJFWo49Td7oBL0hOyH
         5LznXyQkWwFysWCjXtzkRB3jo40Vf49KoDZ987/9DkEnB1RHNZoBk4ikVBrmQazLnaA1
         IBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567146; x=1764171946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cDp3sMBoTlmxBrCfHcN3bT849KzRdDNMVpiuychnTdo=;
        b=bdLDN3SOT2/xpZ3CjqtD5WnfSEYielOL3wEc4mN6qQ6gIiLAAszE10NUionApqQf7/
         UYlyWTvmikDG/LlNKEgBgVN7WfgxJyDiRv3cUvVq/4MvTJuv3X3/ojvwSjSiKSR5H6Kc
         huqF4xHHLloLv3YLx+hYYthxVVDizoJbP4dRk5/YOZdobQ6/MUDE23nsiS/uaetlO/MY
         OV2DR9y7+WVGD5hlsC4Uh7g5RG+mrvHCiCV/8C8azOVGb5yPQytEGtX0JzleRObDH318
         vt55Dj3uNZVeyo3BaPbTh9WIoFoAPOkSwDIn5zmD+2qeqZlyLErPchth1Yigb3CjNRaD
         dsog==
X-Forwarded-Encrypted: i=1; AJvYcCWSUuIOIh+hSQ1NGA6mzOOMElkhdgQD9nIHg/1QPX37CsjiSxsLVS56eztputt3/iiFMRF6BaWJ6g==@kvack.org
X-Gm-Message-State: AOJu0YyMFQB1OKCYqiYucKZAEJKwCq4cAl9SXBYXkId5OqDv3ETDGdqr
	OfLxZHabAjt174q7qGd9y0kr2NeE5hZwHU0mPbuwXqjYrAY0Q2kr6upxk9tc7moszp4=
X-Gm-Gg: ASbGnctck7vPhi4akqnA8T5KvNGWF62W+n1HL6lJ/jL5jF9yWpZ27GYRP7z+T+/zPbE
	pn9w/xuU7Y5AhAEMvcICJ1XNjzo8e8Zd2tLRYmCCA8AnryxL8BjW3UOSVLfo4RT77PTB+nnLBya
	zZF/OQ3ZabMr4dPAemfhPSnIpBfJIt4VMnDheGJ+zVAlvgpVti+HJ6B5QTWxyW2Gtlxzl/88Kxz
	AtP4xVhPiLrEYq229YOMNYJoeVgApYc80nJeQZPksbYsbZTzx3IIizL2WTNpLAowlyx7Jrn57ra
	gWmhSYWKS24gQnsBLuYypCzEDw6BO4kwt1lQEZ9CRSs4DG3vWLC0MYlJTH+XhNRT/e0wz5RMDgC
	bL7htygufvx/uM/HfRZ9HdKis+rYkVrov0JmOBBQDKCkHFcHnnWV0Vy9nIDrvxH9BlMzlxDjsNv
	iyIyQ0fsNJUDrAE9i/rPo=
X-Google-Smtp-Source: AGHT+IHSn97ivXqqEi+3+TEBhok4L0zKY5jBJq8AwBEmyjMgjDaigOLXet9t8Pqm4XTXHvlHGh5HZw==
X-Received: by 2002:a05:6000:2891:b0:42b:39d0:638d with SMTP id ffacd0b85a97d-42cb1f9e35bmr3506384f8f.28.1763567146421;
        Wed, 19 Nov 2025 07:45:46 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:46 -0800 (PST)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 17/26] sched/core: Annotate runqueues into meminspect
Date: Wed, 19 Nov 2025 17:44:18 +0200
Message-ID: <20251119154427.1033475-18-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 01AD418001C
X-Stat-Signature: 9xpz3dy15ffp1k3953caf1eo7e8ztxnz
X-HE-Tag: 1763567147-816552
X-HE-Meta: U2FsdGVkX18U4JisUn6xCbn4fGYGcNdRH44xZSWMMjcsvLtx5kDNUng3tfMElpjzrt/kna8CUk7fTK5+b9RZfIUrAOwY08cvAX4A70M/5d1XrmuqUnGpUbDQYowKKXwiZeb3TuUxe4/VkWhEnWLfBxfaIYaHUbfJK3UAW6P7LBFKk55NRgHuM8ENXRbhnTlzi9Asrebg5aiEvA6qR9LI2mtcWKAb7Xed7KM/PuujoMxG69WQ2a3BMkvYRgZ1fGGyuJ5ZQm1osmcAt+wDZ0nlcMMhtREuJRpoysSxNmrRh9tR/RvK4ouXnEWJr0pp5NbaD4BhCHhcrD5+fz3CZsPa8f5sGnSQQy1gKoS9/8moZOqfAMD0JiFxvOWLkuKS/7yK18YQYg56YvzNnHmnp3a1ZfQbIyjoDgXF5u21Ep88Xh1GstD/e/fKll4iFlPyGu9Y81+gFmbb+rv3gahBPqwcGio5ihYLPfKHJvzyDzF+0XO/eO8md2UugiyFsJjkcrmsupfn/2aEb30V5yWK6YHj432lZhnPLayRc4OPMSZixFfgCNI3K73zSLe5r559qnnMMtzK7Okt7h+DBdPCkrd3JL1ye/W58ZuOC+W8CdEjxD7231GXod2fdcwhnzRqh+A6BH/sw/wfpo5L2PVtMm5lp4TWMArkIgI1bTcOd7OHxNVELfQYLcrPo7k/7flcFHb/ZJwEk/C3uaqT5VJd/eClcpAEafmxlbee62KLYzKRQDGB9afAP+kFnjJgtNXLSlzYK/5Y66rXNda2lW3xulNRJ+eRrZzKmeiM88tdd6OC0clCKdNxw4vJGl+Fcon0L3shYStrBNPjeAw+BXhnDFTs7yXYzDvouJO4MobhBsIhx2BUw916eGLpjH8AEtGDZq6FjyORCRW2wh1tHazISeFFnxoYuk9z5vCcXMGQeL5fJq0Su+aRign4/GiFI9eBEmRSgGbilNGnLJqwm76PB6D
 qrPCWyrR
 kwuarw6TGWXZDK2Hd/j0WsbtY/1MVQ9VWWVyldGmnS5cLhTKotUADwlT7rOuYhsVqhkePMRkRJ+9ZCcwoc1PGCtZEBAAyRCXPQYVxtLnRBj3oEVNZe7rK0nWj0QCpphM1ZkgiEdx74kSp/P9TB7RMt95ovMg4NsHv/iAwg2h2UwNc/iIeAcSTP0J0qyNi621o/3nh8mxr+Qejniemqh9fci8oeSVCDZvLDe2zUzBdaqod0fIp+oI5jDBaBqF3oXVXk8zxaKH6Ei/1GezhB69R+/vELvJXvbUctEdwyngG4NO+YseYABzg5uIaG1aQGhkUW39es9lUdGrAz87xQlJ7QChD0qlqgb03YMbuHnueCbMH5MouWgpbqTV/1aYGxhv/H3axf39NZSwRyXpsPaGXxGiZcvFWKJVm+jnN96SyKneGmQ0JeW6KMHlhhJUgnwwWwuzfieMUAWeMljY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate runqueues into meminspect. Even if these are static, they
are defined percpu, and a later init call will instantiate them for each
cpu. Hence, we cannot annotate them in the usual way, but rather have
to call meminspect API at init time.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f1ebf67b48e2..a68367daddb4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -69,6 +69,7 @@
 #include <linux/wait_api.h>
 #include <linux/workqueue_api.h>
 #include <linux/livepatch_sched.h>
+#include <linux/meminspect.h>
 
 #ifdef CONFIG_PREEMPT_DYNAMIC
 # ifdef CONFIG_GENERIC_IRQ_ENTRY
@@ -8792,6 +8793,7 @@ void __init sched_init(void)
 		rq->core_cookie = 0UL;
 #endif
 		zalloc_cpumask_var_node(&rq->scratch_mask, GFP_KERNEL, cpu_to_node(i));
+		meminspect_lock_register_va(rq, sizeof(*rq));
 	}
 
 	set_load_weight(&init_task, false);
-- 
2.43.0


