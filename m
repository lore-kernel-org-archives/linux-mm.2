Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6DC2CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 20:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B0F6B008C; Sat,  3 Oct 2026 16:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71636B0092; Sat,  3 Oct 2026 16:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960146B0093; Sat,  3 Oct 2026 16:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACF46B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:27:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC10A1C3CE8
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 20:27:33 +0000 (UTC)
X-FDA: 85282450386.28.49A63E8
Received: from mail-yx2-f8.google.com (mail-yx2-f8.google.com [74.125.224.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1904720006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 20:27:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ICPuN2J6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791059252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wdO1qiLDUurZfNdh4Bo7wDLkgu1IWEB9hS1GOH9sv2Y=;
	b=Z1WVyfNmTak5czbQ3pCgd3vqmCoD918LM6PZW7FTPcy1pyLxbHtaIUPitrGjsunBesDQsD
	V202HjDKogtOjx7vhca1+GmNK3RRD8b9nNtLbJMkMUmVFR5Dk1noPNvsYb1EOUKmlDFEa/
	GokLswJiwGAJ688t38PeJzffnogdSb0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ICPuN2J6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791059252;
	b=2MFTFFK2KsedAu1ZWMkOHCYItQjcZO5alxIo7Iuz85X2ROaW8Ze/RmloLTP3poR8DvEwMg
	Y4tq8oPCJAl3VN/hCKegE8aBnpJUHF7ORz4K8bXwVeWTI3ju2FYI+yv5zQ8aHSzM46qtbK
	PdsWbNq0eYcu7DefEI0UkUDhXNkCJao=
Received: by mail-yx2-f8.google.com with SMTP id 00721157ae682-8949fcc5ea0so797947b3.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 13:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791059251; x=1791664051; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wdO1qiLDUurZfNdh4Bo7wDLkgu1IWEB9hS1GOH9sv2Y=;
        b=ICPuN2J6WnW8F1dKmwXaBr5RPyRoCJp+4fAuSSAx00ZTU3sPpGadlYA048hTM2/X/7
         dGQkI/rD7VKc/ouK4aFKf9tB97XfD1wzqWCCx5Sk8SzOMcymVd/BqpQijtm/lzR5yS3o
         u4WDq2FlJWxckMCyJidguu8TH6saUkUDr30rsffrSX6w0QFq3zXw+UdGBIB7P+tt9IRf
         QNhGQndyOZ98Zycst317lXt431aE/om+rIxSnCXY7Z5Vvg6Q66c6dDWw5Nob4UOvT7RM
         EiOcV00IkyIkprAEuJBgtOdqIAGwK9Lo2rUuWz4PpcxynggjND/tUsYPQVPbPQYdBCV7
         6YyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791059251; x=1791664051;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wdO1qiLDUurZfNdh4Bo7wDLkgu1IWEB9hS1GOH9sv2Y=;
        b=m+3+ByGoDkceV9kSpHIbUcbHU2BOvzfF53rjigfwbxRPL9P63ntTaxIbh0Qn54VsbS
         KqUWhmkvSAR88nd/lE3AzRWB4cLIWiY329+RMv/EN8mykeQCwSqsGuMG2otQvPuJ0DsK
         ffAUSLopB/PtfyVR+cHRGO4fDBPvkKU+/N0S+8rtRUogO9CzOdITyU1QuXlwx0+O5JZJ
         7yn2Xn6j7gSEX+It1idVUMFL6hD+NUk2xbnJxSywCluNPjijc2ufrEbSr4JZgpsMU0Bf
         xBr6fvlWPJpCYRhZiL4ba1Ujriqt9c21+h06YDielJVeuWxp84I8GJL5DZGgR10kjVje
         ya7A==
X-Forwarded-Encrypted: i=1; AKwUvBxpmJ3zMrPq/mlbtqXzScybKmRZqikhOTblQLgqCsrp3NIbLk2Bmp0mZtn+UT15O7N4rsTnhunT6w==@kvack.org
X-Gm-Message-State: AFq9FYIlnmDF47ZvF+gF2F0BnMoDzkN5iEiJIeQO3JAk9xXEhV9ncCHr
	cEC7J7ZpSyjqLRAMSsmEetoT1d7RI0UciAelvs582Gw5eITMwjyaCKM=
X-Gm-Gg: AYBFou3ZokxeQxYFoNZTWo29RqX29d3R8gf/z3CpXFVFGueb44fQgKM555Tl8/4sZB/
	P7LIqRFRhIL/fR53a5kLcWPMACT1WKUkxWtiGpEqRHU5oQzfDPkEyU8V4Q2xdD8bKop0kWP1i6A
	D2Y5VIxY3mzBvjDKRloZaVOAV+pnvXwNCA3rq8lFoltOvJeQRXiH73OaFH7dRvY+Lll/NLBwcQp
	QVXOtdE892n6zaa6fDjS1rIJZPoAhLnhwPwZpcbcLYztV9IDoLMk4ho6XcLt7Sr84v+57m0loeD
	XIxoD7koY5e/1qem807BLDkHxAstfTrLBzNumxfteJHonhVroxSl8UQkLQL2Af5urwtzDCwsr4L
	/EUEeHXawyL0cuYhNsRh7qh3cYBSJBIMT57qaNuot3hdMKhTrMZUXthE5kwl27Z/5Q9aol/Zicl
	b4bGPb0LtRnPrcqxIOTNBJiQULR66iwVITfS6Fy5J4Yx5iqF5YdhBoTo7TLLg4s3Hp8suuZ474W
	32M4RvGbC8zy1XKD3H7GO7CZ079y2XmdZ/LjLhNPg==
X-Received: by 2002:a05:690c:ec4:b0:8a8:93e9:3824 with SMTP id 00721157ae682-8ae95ad61e8mr14431447b3.62.1791059251099;
        Sat, 03 Oct 2026 13:27:31 -0700 (PDT)
Received: from localhost.localdomain ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8ae33fe81fdsm23389887b3.47.2026.10.03.13.27.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 03 Oct 2026 13:27:30 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	SJ Park <sj@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [PATCH] mm/damon: add damos_node_eligible_mem_bp tracepoint
Date: Sat,  3 Oct 2026 13:27:27 -0700
Message-ID: <20261003202727.3673-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 11c9dz1nyff6y5ct9r6qn5wco3dj95cr
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1904720006
X-HE-Tag: 1791059251-280817
X-HE-Meta: U2FsdGVkX18C5fVrGN+6UNq1zhSYavXVDsfrtH339aWawmLLybutT5p15IXGk3Ui8iE/Qv88WM/VUi+8qGJJV8dEnzhUfWkNCr4PipFFTpF1z7w3IqA/3U3JWJOJQS1SaH1NL3VTYN1UZ42W5Yn2VqlwHAfmPOPPfKT8ITe/azm2zZWNud9HI36ef/aQqXzENBtXH/29udO7uNEmU78t70MF0r+cnh/y9UliTJ0TyLuuGGLF1ifC7pTFSDhFv53hHg3HlVuLL2nXmTFOtV9cH2nllnrJaDZDJgl28FqMlkWfc7zjnho+X3boqBrjQLM+g0R+82sUcoR5ZjyhFittj+ggTGgKFTXnLchADQYluTkpp24AXICiktAXWqmEt0NXeO9Cyz/A71cBXy5TTRh2srI8oj+5k2/IPcRSFZLI3kB615jcRuUlCD/7dRWL1qpkHoGXwPqrZrkYgUstiNYbh7vOb60w5vXt0vIoBLQQ8lYGRu1eO82cGX5SH+TMJ+azSGDTN6zCPOip2JrBM++8YRfs45kDCfuVktusWyxGzfA17w/5IVcNSviwkRWAhMwP+eormY4qf9hCAC0janZGbMyGBJf4MyD8zssTUbJpIIbKI+5jA6vfYT+BemRP/qYQuxH+0cWbFAEtattvK0BOIPpa+yH04Y004KbBnfd64OJAZHwh++X94J4wJB7sBt7BF/Uw7IAA/3v5BfmnmZoRqNZHpSAE/5rqjFcuacienxpZWETkg8teXdDxaukUjQfnrUy/TJSkuYyDoFcx5OAabAhnGF6fvkkblh8TxAo5dwMK5mFv5JULK6kc9oodXoUadJpEV2vjSbNU+SWtBgsP7aarCBjkqznovV/xoatj+PRIXHyMNWEDPcBlqggVer3+gX4o8yfwaD6vRcyTASIaZq/QqKf4heySPV9Rt/5Ir0SZqiuWOlWsyH70o8XymDde1cjzlI45tKBa1gPVBP/
 BtWTCsgT
 a26hDBAzdUwoROS3i+5xBKM1USXk/k8EVOa6FpczndtoD+GhfB5xzGExLiWuuGRVjgBkGS0SbglIt33Y5eMCCrMQheQGqxNL+6uk5I7x8uLSY9LMNsw3rCyX9mslSfL67EOfqyt1hX6YU8tknx+uYrjY2qGvIyPtDd3zzEOK0zBrfI7Yo/M8HW7v/L750bRO0AoelpJY+2SDl+SLg4ZOx2fayGIDHW0ee5Zjbu+QIGCakBPf0S0cxrAqYX+aCoN5/Kw+N1OtpcFTdNtoQFjIEjyi9UhISUJfLflvOFEPpxGTV9myL1a2mAzmMQ1G8uB1TIb1KEuoouCe2+IanVlT1Lfq67+IwzSSVZeI4BVoLbNmdzzYtZKzdnH9tNR3REdtDCtaCXI8bJOcbhhieUlnB8evrQ8lSFhp4xdPjSPhOMTLXA2cYfdeYlGx1JllGuXAqBHju2987HRbtTMMOUuz8hbR8Bhrmbg8agGdXHG5GWDU5JV0LY6H2xuqrTXSD7hPXyyMOe8yTaamz9GKJcNDxKnvN5EA4PVF31rZtGOFnTnD+XFom4LmOyetGlfLyYw4ld2+5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a tracepoint for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP quota goal
evaluation.  The tracepoint fires once per quota-score computation when
the goal metric is DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP, exposing
context_idx, scheme_idx, nid, target_value, and current_value.
current_value is reported as the quota tuning sees it, after the goal's
complement setting is applied.

The DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric expresses node memory
occupancy as basis points of eligible bytes.  This information is not
exposed through any existing external interface (perf stat, /proc, or
sysfs), so the tracepoint is the only way for userspace to observe the
target and current eligible-memory basis point values at quota-scoring
time.

Link: https://lore.kernel.org/linux-mm/20260428030520.701-1-ravis.opensrc@gmail.com/
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/trace/events/damon.h | 31 +++++++++++++++++++++++++++++++
 mm/damon/core.c              | 16 ++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 8851727ae162..2c7249cc7c88 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -74,6 +74,37 @@ TRACE_EVENT(damos_esz,
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
+	TP_printk("ctx_idx=%u scheme_idx=%u nid=%d target_value=%lu current_value=%lu",
+			__entry->context_idx, __entry->scheme_idx,
+			__entry->nid,
+			__entry->target_value, __entry->current_value)
+);
+
 TRACE_EVENT_CONDITION(damos_before_apply,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index b63e60ef8990..6ddd15dc4f55 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3294,6 +3294,22 @@ static unsigned long damos_quota_score(struct damon_ctx *c, struct damos *s)
 		highest_score = max(highest_score,
 				mult_frac(goal->current_value, 10000,
 					goal->target_value));
+
+		if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP &&
+		    trace_damos_node_eligible_mem_bp_enabled()) {
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

base-commit: 763ad0211c7b587344f03bc4d1299810aeb736f4
-- 
2.54.0 (Apple Git-157)


