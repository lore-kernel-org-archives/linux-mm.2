Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52538C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B83A6B0098; Thu, 10 Sep 2026 13:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9428F6B0099; Thu, 10 Sep 2026 13:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831756B009B; Thu, 10 Sep 2026 13:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBB06B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5EF38055D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:38 +0000 (UTC)
X-FDA: 85198506876.28.BD1A100
Received: from mail-yx2-f3.google.com (mail-yx2-f3.google.com [74.125.224.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id CEA51C000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HsBGIk/Z";
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.131 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060596;
	b=eNNEdmXWz5bQoYxfTZrodm4lN/Aj+ynl2x3TyfDWxo1iT+dTsCajhbyephk6f3F6QlokJW
	otMgvvzx1fZdlPzx1+npy0HhGOeZQXssTuym0mPMAZDJ6mqdN/IHMr3/LD6bu7/P0Unu7w
	VPBbX1gp5wMS0Ole9LP5j38CF6s2lc8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HsBGIk/Z";
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.131 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCG1VvuHQ6SCJdLVUga8vZowwN0KJmpgx8fDOpUOTA0=;
	b=KxeZUxLxob/gW6D5ZWC70H6ctC05EVyVMaT2FozPnTHbPC8iqRpWDg10di5CLALOAnhpD7
	ctXDbRyhIP3Nk5IeB5ky1sb++vvUM4oRaQZRpvem8+h/78WivC4MjdwLMekDT8tPm8QnSy
	itLH78mMFxu/4l5vEDVHflnc9Mg42A4=
Received: by mail-yx2-f3.google.com with SMTP id 956f58d0204a3-66fd0af9eb0so2123119d50.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060596; x=1789665396; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zCG1VvuHQ6SCJdLVUga8vZowwN0KJmpgx8fDOpUOTA0=;
        b=HsBGIk/ZfIsjksnjIGLvkS/04fhYzyGTqZQ3yyLqYk9GLtxtnZLGGDbl2ycycoVYcr
         aQzBQ+CDHQePKJ1pMg/t9YdBAP2MA6F6mPuelJcFORVo4mST/jlejbBVc7gfLJ7hLJhX
         Td9LXcRCgeh/aNgP1cO3odgmfCCkfTXvUILQ4+Yq2UbxmcwCWHm3oa3ELptKNKmFA2/r
         hWRIKzraJuqHRVR0Qhlf3PUqCKPGj6y4Upxg8WhobDkoyvZatbx7XqUI4NkkhKHl0uu8
         EAZvC+6+6uzm8hRMYAarM6igg3xSBbdAY2NB2EroY9C8pUnDHRZpKqmgAiS/Ldj42YiZ
         zsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060596; x=1789665396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zCG1VvuHQ6SCJdLVUga8vZowwN0KJmpgx8fDOpUOTA0=;
        b=WTCQhtAZj5BgQjmY85cYiytws+pZ59COVaAH1T9YPtJC+uJbC5U0ec9uD5MqDNot4+
         CNi8W8GZIJGEKAVI7kCoXs+g9uX8mKZdoqya87eSBr2b2IgJ6SeRP4jruKdBCuPIwy5O
         MJmnxpL9Pkj+JV0pvVPD91q6giqd0kCW3RiFuHoO2KxBndJ9BIJD9uo8I2fg+GE7pprp
         ngjUjN23MGIcXYXJbSQYqoEO9ctCS9IhmnIlhq8MYuAlfRvfnhJXPnlqQCYWA3wSy1Op
         NwDzK/Nmxs1rqYsxR7WLqCZd6u+V0DCzbICGorkAqPRyX4JxDhWft/VTAtB3gsAsU7Cc
         C24Q==
X-Forwarded-Encrypted: i=1; AKwUvBw2srJuGUx5+35xt0XGLDJI4JbGgTnYw2Jac5Sy47kTlcCMBBt+ekM3PqY4vi+6JqGkrbTyG7uTkA==@kvack.org
X-Gm-Message-State: AFuF++l3RbaZ13DELQFvBs3dLNSoKD4pcMcLDo42isxAMqxOcBkOtlyp
	AtdUGQjoefnZYEJxWCcqgZ6oQic05hp90zMM9NfFOUGYX2e3d+eaALM=
X-Gm-Gg: AYBFou3buNSVx8Rzp9BBRx2z3dPr6Tzw0ybiNWAZI8isAWInNUOZAGn4PvkDnhxmU+n
	KyFZ0pymGIOhQ86GowkcEkU30s9MozprrdM1m702sy4YTG3VjL9wIFQp0Wfr5YGyofqOaRlrGng
	RC8UcazQL+a3RnogpXxWuRXF5s0b9fz8lTq4pysV8qEfvKjbfCACoFvynY8XOf3XCBJlr1o1PoB
	zqcMA4VXpjwTsDFD2w6aP6rrYP9lsKQ8lwz+qfVjP13r+TeIT5YJj2fNTlYJRWQkYT/xKIayJVe
	LW8RFST76aF2dD8GEOhyArn8NlNbnw6XTxObfbO1oszg175oigcu299gXvFJ1CZfHGnFunSpRrK
	bvANv4lMvtesEGQCxxOB5aUawGdjKgErr1mySqf9zBwJscf8EmbCsq6ebeCiGfJpib2qENiI2jV
	y75KpVJKCH+jJteUv2V0FwWrPgVT+6HNtIFXvMEm7VhIqm665PnnTMjrarYj4PI9zX3bhs5MjFz
	VrK+T0F9EMmOQpGrlSX5Cn1HW42VWje4Q6hLvXxox6IuPaG5FbjAQT7lX0J
X-Received: by 2002:a05:690e:12c2:b0:66f:ca93:eae4 with SMTP id 956f58d0204a3-67124722b0dmr151051d50.92.1789060595769;
        Thu, 10 Sep 2026 10:16:35 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb47a8b8fsm14316278d50.2.2026.09.10.10.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:35 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: [RFC PATCH v2 4/9] mm/damon: add damos_node_eligible_mem_bp tracepoint
Date: Thu, 10 Sep 2026 10:16:18 -0700
Message-ID: <20260910171623.6638-5-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CEA51C000C
X-Stat-Signature: 866iimfoceemhw9ky946ib1cdbkyuyud
X-HE-Tag: 1789060596-113624
X-HE-Meta: U2FsdGVkX19XpCRvuMmrNH+0XWwTBEuDwofzyk6034txHYf9yyWFN2K0Q7uOjXLa0eZLUlm6UhONazoIfT99113N+UPZL9oj1Zj2iMhg97/A0BCnDr6A89/ZAyk3uxibzXFcRb1eQzQhW4u9Wr/BH8lLPCS3D/uFBeyqqGsDvx3mJUCh6GbbRCHbmhSJMxy6uD1mTuT8/QhktEKHSg5uBEjn82p0MhEHCFcxZlSbmtpsdwNDgvQehP195C1bN/yDTCVaAN+KJ+O7Q6FcRPUJhdgA8xKiQ4Tt3jNVxQ15+QJx+UcKZhyA8GGTpfqJKyZDe55QXrgRQ4ueR+Prs7rG657p+dZp9lwD2Fr0p+SpGexBJp2gZV3EcwjIeMUxV/x310j3xY+ka+jtKyrOpEE+8mHPqX83Wc6TBovxMdGuuwUMMvmniqw12KnB8HBhOa3SdprL2/g0J2CqxaATMLF+S/EUUDgzJZzBvWIZ8/UvizE2KvfjREzex4SN6zuZr1O3rdKThl9A9pUV8nHMhL4IpZJvfcFqsKEIHo7XsdpgTt3e8qJGQLU7+Ocv5U+YKO4U3wYLNvLFYnVFnqAAsW7nSmCFCa542FgF9ziw8J4oMVFydmkdc5ojULQRn1o7VC6d8s1+osNbwYFV+Y87mw381gVgcee1eGrdWLrQCXnOSCl2ZaEkDP1TiEuk3ivh3u2Rg1CXHUn7eJ8tky20l44l3B4Z1x2vQXts2155KW3zmEV7UB9k6HvlH0grcSUcBZSYSBp46MMY5NxG6PpieZTfHXRT1RydktKcJ6tSQ/QCQT9hXhJIDwNnKW3YreZShRiIXO/+RXi34FzbJ0mY95m25m/PS719GlX2mYm104RIYXy2hOPLEy4zNlvwzfR+dQVNPAZs9gCZKpnpdf8n1nMm0UmIzRbKmJw9rWX8/XmMlSyHzL1uCQSZqmcVwYHjA52g1dBL+BozdHogUeRNO/C
 KGNnd4zZ
 xJf1lhRSk+jMPlqCU2VkdhnGJfI1aLE2jMNqdyunFklVY1AOZbeOMti+7WxHpJ6JsgJPF+oZc3q+WPtkXwZEnhDuS3jJOVKGR84m/8EvqnhfX3su8H/VldBVrNIvTNTyXIQOnFE+GiJSwSaJKzvbfHboooZV8WmYGTMm4tPZPMPcKL6qI/lrsero9jz23dfTUpO0XP5DJUxgY6wxuR4A421zcqwbZiMde5p9M6+I8BDZRTshlggLQEajpW2l7P7T2Et8mVKfWVy8WPmcTEs+ItjfsZ8OiF1WyFNSbkTQx9lhDIQXjTL3zekjIiteDdqJXxlWyLILpu1vwWflo55jPnsZVFVEpiB9akd5+QyXzoofU0A6vrqTJa+OfTEDcUBMmJaZmJHF0t0q8tfk3dRBRDbX9wZnWngg2fzNPBdpdelU9gfeHbT1HFVC2J+JuyXk2IEorUXj6oVcKiMcRnsHvoRL+6fCe3v/nSN0i4jFmnP0/+xkAoRSYhkOGR8YfPRIiDsyhUHALDvdMojSUicxAetn54x42nFHSIYeXkNhrl2Bq/+NGezIeBVZQCLyteQ5YnX9CEC2H0b/WvaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-tick tracepoint for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP goal
evaluation, exposing the goal target/current values for observability of
the node-eligible-memory bandwidth quota loop.  Bandwidth-feedback tiering
loops read this goal metric to detect convergence.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/trace/events/damon.h | 32 ++++++++++++++++++++++++++++++++
 mm/damon/core.c              | 28 ++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 4dfc9467ea4b5..b2a472eb45d95 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -74,6 +74,38 @@ TRACE_EVENT(damos_esz,
 			__entry->esz)
 );
 
+/* Per-tick DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP goal evaluation. */
+TRACE_EVENT(damos_node_eligible_mem_bp,
+
+	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
+		int nid,
+		unsigned long target_value, unsigned long current_value),
+
+	TP_ARGS(context_idx, scheme_idx, nid, target_value, current_value),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, context_idx)
+		__field(unsigned int, scheme_idx)
+		__field(int, nid)
+		__field(unsigned long, target_value)
+		__field(unsigned long, current_value)
+	),
+
+	TP_fast_assign(
+		__entry->context_idx = context_idx;
+		__entry->scheme_idx = scheme_idx;
+		__entry->nid = nid;
+		__entry->target_value = target_value;
+		__entry->current_value = current_value;
+	),
+
+	TP_printk("ctx_idx=%u scheme_idx=%u nid=%d "
+			"target_value=%lu current_value=%lu",
+			__entry->context_idx, __entry->scheme_idx,
+			__entry->nid,
+			__entry->target_value, __entry->current_value)
+);
+
 TRACE_EVENT_CONDITION(damos_before_apply,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 991ddb9a09414..6b56a3e961c4e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3461,6 +3461,34 @@ static unsigned long damos_quota_score(struct damon_ctx *c, struct damos *s)
 		highest_score = max(highest_score,
 				mult_frac(goal->current_value, 10000,
 					goal->target_value));
+
+		/*
+		 * Per-tick visibility of NODE_ELIGIBLE_MEM_BP goal evaluation
+		 * for userspace convergence-detection.
+		 */
+		if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP &&
+		    trace_damos_node_eligible_mem_bp_enabled()) {
+			/*
+			 * cidx is hardcoded 0 because DAMON sysfs currently
+			 * supports a single context per kdamond.  Other DAMOS
+			 * tracepoints (damos_before_apply, damos_esz,
+			 * damos_stat_after_apply_interval) follow the same
+			 * convention; once multi-ctx-per-kdamond lands the
+			 * field becomes meaningful.
+			 */
+			unsigned int cidx = 0, sidx = 0;
+			struct damos *siter;
+
+			damon_for_each_scheme(siter, c) {
+				if (siter == s)
+					break;
+				sidx++;
+			}
+			trace_damos_node_eligible_mem_bp(cidx, sidx,
+					goal->nid,
+					goal->target_value,
+					goal->current_value);
+		}
 	}
 
 	return highest_score;
-- 
2.43.0


