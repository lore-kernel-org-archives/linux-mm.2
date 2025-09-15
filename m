Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68736CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4A78E0002; Mon, 15 Sep 2025 19:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBB58E0001; Mon, 15 Sep 2025 19:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8F38E0002; Mon, 15 Sep 2025 19:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F90E8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:02:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36C565B35E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:02:31 +0000 (UTC)
X-FDA: 83893010502.05.FC8480E
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6E68140019
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:02:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LKmG2od8;
	spf=pass (imf27.hostedemail.com: domain of 3BJvIaAYKCKkbdaNWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3BJvIaAYKCKkbdaNWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757977349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jlHw7peG2S0Qi11j14sbZpDivsG7e2/czsSbkXojmRs=;
	b=A2f8Mh7SHya+vG2+tn65YJh8BeSNKoKacYFwUWyCMmwt21TTR/HpNcHKqlzFGa+z7JDAWZ
	GKBEjKQVFeJLKea/OG9vxCCyLCskzW6U/6QxSeWLtuCztM60m8KXWTjPqeSMoIXR35Wzhu
	+VJ89HHVSkqOuQopWblAIt9j4xzrM2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757977349; a=rsa-sha256;
	cv=none;
	b=733mWwUcEzIyvMcRuTJYYO7+O1mJVkjaf+r8QTYpjFkurYMJkIIpxDZ52E/qS53hyP0hAt
	/6zDFibe2DSkcyfgRxZDZasj56DBKLQOhjAIif2FUs37vxKWSMJx5hpz88Pqw1V+nVisXb
	oVRHn9FRKf3wAiH0LC1LnvNxpgKiHKY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LKmG2od8;
	spf=pass (imf27.hostedemail.com: domain of 3BJvIaAYKCKkbdaNWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3BJvIaAYKCKkbdaNWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-26776d064e7so12572855ad.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757977348; x=1758582148; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jlHw7peG2S0Qi11j14sbZpDivsG7e2/czsSbkXojmRs=;
        b=LKmG2od8cYhzsmyEllrP+SbsM0+UhyfijQunfml3aElOQhMDscfkn33EJCOIfyh4+7
         X/5Sx5dASW/thIvttEHLx3Dry3VfJBstWHUikIAhgTVHOzTCVgGcLjfVpQ4uGmrcHRQC
         D0v7G0ARzgW8PvasXW2P2kBCpaDnCCyuu31fmhsf/1y4Asl7GvVjrCKbqgSh+mKUv5bj
         P3xHLz5jCGH8J13J+o/4NM9PTNI/WTmbSEbWl9TtFdnmRqx/jfe2vtp5bLky4lpYS/xL
         okPRgpwQLtOwnJsih1pP4T0c6kBPaDEbMlUedyY6/FW+nAwaSy1G2crqnxsHGqFBkxxX
         QkLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757977348; x=1758582148;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jlHw7peG2S0Qi11j14sbZpDivsG7e2/czsSbkXojmRs=;
        b=PweaNymgFL5rWp4xQ7/DkRf3N672xOOYvXRPILP6LdquwO0qHttbBCV4lvrXsLm6Yh
         MtO1Cgj7t1iEqMU/taz/N1Yma3RFYkof+b0iPTZyg3wcQWsJiwJFI6DXhtVmkZZ+8b6b
         MMzqnriNEzM3MEtt4J7wzfO+Zfow3RcmNK6t0SM+KU3ikZjSW+bgjjuOx8B+VjFMjfcP
         qjYQp5vPleKd4X5nc3+cck7svfQYPjdVc4ECGOeX2d72Kygs+ye+6XENOi2bUlI88Vuq
         c8+86m1oqE/1TcBgrwVdh24hGoFCbtu+ha6lPfAh6FRMHdjVhQcWZ59Ltejv3B84UuLU
         8Etw==
X-Forwarded-Encrypted: i=1; AJvYcCX4hl857Q6QwQGkE93oiN7jZVp1FraT2ND8isGyknC8+vgal6AmOprH00x4NwphaHB6TBerpGB3sg==@kvack.org
X-Gm-Message-State: AOJu0YxB6xK+R4x+fJ9BGse8f8XrT4wjVNSUkhCaPt520C9phkeUP01V
	SIr+23QBerl/R6j7E77s6ElCBiKMKkktHvRzDNdfjJgNICUpfa67COqzDXlI2wUCyGIcn9pZYu5
	PyLH1YA==
X-Google-Smtp-Source: AGHT+IEa1X3jMZjRLKCtcr+A3H7RIfpidT0aOh+QBF0f2k8RzePHSyK+dGRZKFa2h4fT/nJO233GwItZfIQ=
X-Received: from plii18.prod.google.com ([2002:a17:902:eb52:b0:25d:510:6240])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f0f:b0:24b:1589:5054
 with SMTP id d9443c01a7336-25d250961b0mr172831595ad.23.1757977348111; Mon, 15
 Sep 2025 16:02:28 -0700 (PDT)
Date: Mon, 15 Sep 2025 16:02:24 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915230224.4115531-1-surenb@google.com>
Subject: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	surenb@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E68140019
X-Stat-Signature: qhw6utcanzyh1iigkyouo7tqo97xw1ki
X-Rspam-User: 
X-HE-Tag: 1757977349-526381
X-HE-Meta: U2FsdGVkX19WXw77L1vYm3bWsYghVObI4PS+8q5m1MgTbHxy8BK6K796nYcHsyVZpRcnE0ZS2996f2SiITr2LPF9PtKhM9jKMsyY/ADkgzodLIiEh+zXo3Q6dkkiFkdngNQ1aURHKuyUXOoHq/rqTRBTSGLvYVL8NOLB9YEIIV8ONuaBPSJ1sd3e480Gp7DNGXdzhKIbWM6fJBZIutCMdWNLiaIlCzECkvIKhSw1FnJpvISvldZ2+FKTmR6DSbkxZ/ahTWDmhE1ZD4c0WTjO4808ySc7+hCKHZYQpmeU8yDDhdSJJp6XTGFBbpDwDWYJaizfWUZK1sf53jignJp3fboqqnAYCa6sAFGWyUarAXNrvmVSQRONd4UxegvaO3vxQLmPW41j3GUlCGoRY7/NqboXyFImxubtMn+8zgUnx7YufdUYVmQxVBttBpviKegToRCuQOSnCP+EB1wPUQu6jqFp3589ZAA/BVInhdhAiwop+46fYarhZysx46JX2LvAls0xVyUW8s/pgTn9+Bjbp1d7WeXSbDPSEcWY/DNIkXE0VcWH3PRFBr92qurn76VAlcK/B1Jza/SFe0gyLo6q1Yfa3v5ybaNfdz3iZhZVnyLNOaGbFqLUPLDQSCQ9IuF1ua2gQgF4GDKoadX9x7apfHZDeBfSheGoj+4fi3YWsSV4RzCOelRSoMbg1XL+9avyj9S0QDweDL3FFuvOcJIItG1DFdeHWQZ8AWbbCzR3cQunv8Z08DeB43xDSIU8G49A19dXMWlwQq/1Xe8vE+v6hoo7lyava68kpJOk546ztSKjHf7ULdmSN036w8y+cU2dCoXCfy400fegYT+i1zRevaCvBN2CWt5olqYBOmEoM4FfpTctjx+IKQuwYJuqP5D0qorGbXi78etFxH1aEF6gA1Zk61yzHcpOzGvNDLaZ0ihPEfIeLop6giyv9pO7QRQU8eVSAO3D2Lc+9ir21W1
 wS/KLSGx
 iGXvyVUGbtd1tDZm9ryJNEwA2aHLBPajWK2vPFUuYpZrBKDe9b6Jr0CJ9Da/xU7gHiAyc5akkYYRFS4Uedx9DRl05wNSSGl7SHfcJ8Q0M49zEczb85TFCBna/9jsB+f1EjegABOTe40uhpEhoyIf6prZgwbxgow+rl1vL7lbezkEa/ylfjJLufDxzf3cfgW4KzbhEBI+0DevRPYMykrQWb5lksS59GoBOLh+FbajlsGrqNWmBL06EDetPqJM3PhjK/xk/r3tRD01FTr4wDwxem3hmQAuDb7U6NLyKHm8Mv/pSSkRq4dFCvgDKwvUXC2MxA/9iBlj4cwJM/yj8sOzt9fWXBpA+7ZH6W2nCux+uAc+qphGVZEiV6k2/oOBZFfkb8yz7rubIKGQ+G0lX2Ak5MZZcQpyDB0LHVIYR9I/c6ABL5mnVVB4K+OBT9akQwxfgRZl4/G3fWIqwppRmdtlGdx3zYC3wsD7zxJoSrANWEMTRAfgj7iV5v3M6hJjy+V5lZfopA9JPhct2SXPvot6lCngWiiCH8QrQs/xo8Dx3wtWiQqWy/zi9zTJAKauaA5uPZfXGxpkTGbrcpP5hHxmOx2G5OJQhMdlNsftjFxPidGuboF+DGV2lekkcmmZsUX8w54CUFJ+5Q2/UUwtSL7OPTFMsbo5W9iyUig0cBY3UQL5bZyzYk28Szl0j4hHgB9mX5iIA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While rare, memory allocation profiling can contain inaccurate counters
if slab object extension vector allocation fails. That allocation might
succeed later but prior to that, slab allocations that would have used
that object extension vector will not be accounted for. To indicate
incorrect counters, "accurate:no" marker is appended to the call site
line in the /proc/allocinfo output.
Bump up /proc/allocinfo version to reflect the change in the file format
and update documentation.

Example output with invalid counters:
allocinfo - version: 2.0
           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
           0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
           0        0 arch/x86/kernel/alternative.c:127 func:__its_alloc accurate:no
           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
       49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create accurate:no
       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
Changes since v1[1]:
- Changed the marker from asterisk to accurate:no pair, per Andrew Morton
- Documented /proc/allocinfo v2 format
- Update the changelog
- Added Acked-by from v2 since the functionality is the same,
per Shakeel Butt, Usama Arif and Johannes Weiner

[1] https://lore.kernel.org/all/20250909234942.1104356-1-surenb@google.com/

 Documentation/filesystems/proc.rst |  4 ++++
 include/linux/alloc_tag.h          | 12 ++++++++++++
 include/linux/codetag.h            |  5 ++++-
 lib/alloc_tag.c                    |  4 +++-
 mm/slub.c                          |  2 ++
 5 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 915a3e44bc12..1776a06571c2 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1009,6 +1009,10 @@ number, module (if originates from a loadable module) and the function calling
 the allocation. The number of bytes allocated and number of calls at each
 location are reported. The first line indicates the version of the file, the
 second line is the header listing fields in the file.
+If file version is 2.0 or higher then each line may contain additional
+<key>:<value> pairs representing extra information about the call site.
+For example if the counters are not accurate, the line will be appended with
+"accurate:no" pair.
 
 Example output.
 
diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 9ef2633e2c08..d40ac39bfbe8 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 	ref->ct = NULL;
 }
 
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
+{
+	tag->ct.flags |= CODETAG_FLAG_INACCURATE;
+}
+
+static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
+{
+	return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
+}
+
 #define alloc_tag_record(p)	((p) = current->alloc_tag)
 
 #else /* CONFIG_MEM_ALLOC_PROFILING */
@@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_enabled(void) { return false; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
+static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
 #define alloc_tag_record(p)	do {} while (0)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index 457ed8fd3214..8ea2a5f7c98a 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -16,13 +16,16 @@ struct module;
 #define CODETAG_SECTION_START_PREFIX	"__start_"
 #define CODETAG_SECTION_STOP_PREFIX	"__stop_"
 
+/* codetag flags */
+#define CODETAG_FLAG_INACCURATE	(1 << 0)
+
 /*
  * An instance of this structure is created in a special ELF section at every
  * code location being tagged.  At runtime, the special section is treated as
  * an array of these.
  */
 struct codetag {
-	unsigned int flags; /* used in later patches */
+	unsigned int flags;
 	unsigned int lineno;
 	const char *modname;
 	const char *function;
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 79891528e7b6..12ff80bbbd22 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_file *m, void *arg)
 static void print_allocinfo_header(struct seq_buf *buf)
 {
 	/* Output format version, so we can change it. */
-	seq_buf_printf(buf, "allocinfo - version: 1.0\n");
+	seq_buf_printf(buf, "allocinfo - version: 2.0\n");
 	seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
 }
 
@@ -92,6 +92,8 @@ static void alloc_tag_to_text(struct seq_buf *out, struct codetag *ct)
 
 	seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
 	codetag_to_text(out, ct);
+	if (unlikely(alloc_tag_is_inaccurate(tag)))
+		seq_buf_printf(out, " accurate:no");
 	seq_buf_putc(out, ' ');
 	seq_buf_putc(out, '\n');
 }
diff --git a/mm/slub.c b/mm/slub.c
index af343ca570b5..9c04f29ee8de 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 	 */
 	if (likely(obj_exts))
 		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
+	else
+		alloc_tag_set_inaccurate(current->alloc_tag);
 }
 
 static inline void
-- 
2.51.0.384.g4c02a37b29-goog


