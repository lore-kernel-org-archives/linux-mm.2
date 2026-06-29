Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A5BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34F36B00EE; Mon, 29 Jun 2026 09:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE106B00F0; Mon, 29 Jun 2026 09:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37CE6B00F1; Mon, 29 Jun 2026 09:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 829D16B00EE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC81F140694
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:29 +0000 (UTC)
X-FDA: 84932989218.26.2A6F070
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2C8FC120004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yy37fHQX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3OW9CaggKCHohYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OW9CaggKCHohYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738748;
	b=rDGsDgKIX8tQi3d88v6fmPrkQVTY0IVGkiytY663LfaU2DT4gw8eHkMwTn0At/UFjnk+Oo
	LUBuAk4veP+A87t21kTQYggM5VfIHiJCP9gcbXQaZ7H6armAjEB3tAUVMmtDo/xy0VRcWj
	+lQuVrtdPq2qb+nbTLrTANJJ1IXFJkc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVcvWpPvpGh0KKDm0kFg3LoFKQtlNo0e/vWFcO+Gc5k=;
	b=aRTW7xEf0OyUOwm9/9bLQ3evfRXYhwYXehlXygD5sdb2GHtORBYg6JCP1tPyii8SNsS8Lm
	anfx5uQmVoKgXTsdWgiT7Vn8ZbLOOTxSDxn0Hkrm5cNCxOtbKhf7yhquxaOduKOiZ/tUk+
	GSPk3WcR4pol70Qzi2FXfUDZDmIyVmE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yy37fHQX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3OW9CaggKCHohYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OW9CaggKCHohYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493a6fe9ebdso8096465e9.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738747; x=1783343547; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NVcvWpPvpGh0KKDm0kFg3LoFKQtlNo0e/vWFcO+Gc5k=;
        b=Yy37fHQXBuJsdgZrFa6raUbEvuUrNBfmG/5400gaR3phZmmWmHtZ3wAL9oJ4FIK1mF
         PlcC/z95B9A0YARggX8FbQmeFANOQjNfeng9eslT3wv3V3xrcs92SIkfLgyWoNwo8pc6
         n/neuwnEsML9tpHIjg68eVwfCTcuStYn26KWhP/LOQuBmv8bYjMPoqCXsQpvm7VC73UK
         Wvjs3CxclEA2iXt3GUxahWm67ZMlIP+mAHD1Lhlb9CR0efSqcCKxiJxJc/UMYxV7JnQi
         K8aeJct0JggTVint/Kv8wNLHinxPL6N0wEFGfy32fx6/oCL3al5ww0dHPzVRaEtZMM/6
         8nPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738747; x=1783343547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVcvWpPvpGh0KKDm0kFg3LoFKQtlNo0e/vWFcO+Gc5k=;
        b=X9+K0VfKcCXQgNqTW6lASKj/h2a9bRe4zf5BnQsla3OxAGPMOZdLkn5hZZYTltOyLA
         c4sLayMRTniVa66UuEV34NAunyhboa7W4T489UX6UUQLFNr2ZZUR7Ydy1FUwTFUpKqKS
         aZ61WEXDsJHSLDfK+/rC+m9oETMvgaQEptVXcq/vQZuZk9aPbL02QOr4Qmc36iW9ZvNP
         hE3NiopgCEnWISSdkBvCCPoX85IMB2dJNC73BdpgNs7FroNXtzO3/tLXhY+HIiaJ0uO3
         wDYuBaw2Cy/i4CVOq5RP4ZB2cFGWVaWWVUUIJpBOl5mhQrrOoWi9E/bc5a74r9y4RIhi
         YxgA==
X-Forwarded-Encrypted: i=1; AFNElJ9L8M6YRFffo3vZWAp8OA8cfYvxJnmZRrOQ4iejjAXiaXe142kaZd8NclI9OX8dna1GvL9eF2fpmw==@kvack.org
X-Gm-Message-State: AOJu0YxQIJFFicMvfpPr87pVnO9dDBkhnXUrilOglVuN7qjFS4Mo9yTn
	KJyzexGI4F/DCABbAiTG0YDLdr245ZzZKYPdP1pQOncuCKT7FiziKeL3xpURgDFmU43zeGnge5o
	Z/3oaY8zDjNMaHQ==
X-Received: from wmhn2.prod.google.com ([2002:a05:600c:3042:b0:493:ab17:3e61])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f18:b0:492:6efc:7c60 with SMTP id 5b1f17b1804b1-4926fc919c3mr156189865e9.28.1782738745900;
 Mon, 29 Jun 2026 06:12:25 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:57 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-8-57bef0eadbc2@google.com>
Subject: [PATCH v3 08/16] perf/x86/intel: Use higher-level allocator API
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Brendan Jackman <jackmanb@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C8FC120004
X-Rspam-User: 
X-Stat-Signature: 1i5co36nz4ap9ff9wfx6syxzqmz1z751
X-HE-Tag: 1782738748-798845
X-HE-Meta: U2FsdGVkX1/CrNk9GiPCqtlK9P8EPSJbxiMTxHE6D17/SNujl66BSGXl2fPAyblK4FvBfDiYg7mZDkvaws5Epm3gz0ONl/OWUffLyqkS15smkiCETqzRxtxV94n7jv4TTXlT8xTR8D3nUlvDRPgLhfvy+RzRMSgOIagiEjMBWTtpw11hoIFsR0Y9ONz725K9LZzT47uha+UhTX/arbl5iVLp0s/zujuF1Rk6eOYZ4jKxTvzP1p0kvYK0XAqDO19MZab2p/uoeYKt4GMOGAgJs6to3iuAB87xALe0o4ouORs/CA2C+fNtkt4xORaXxDpu3ovrleCvizTFMqLQtzaFi/eEXGzN6VraatbgP8LnMpwV4SnmzOcMLvucpwpOM2N5N9gcjkMd4JNMu245uFUN07ZvUbqvg/D6fAD8ZmYfTuKjfsxrotFelzDDp+F82B8n6bLu2b76aKZmOi44WFm/v5A/FXDBZFRtb9K6PFHC+82jIklPgJx7IVc5Lf1eLkv/HtD1MhTALB4LI5fSMQvCTI+Cgq4em8wB1szaPlTNU8RxGfpOl7CWoolRZpRj9Zz8RVdIGdkq7VA7Iw+KSYebjVejtJO9aLYEIy69+geDxVnGEijLXRV2djqS3q3Cc2q8riBwRkPdnBvq6UxApMd4Jyw+XKhXwS6+mLecewayZVSOTBqj4bbBnVGZbq8A+RoB966Fi8Zy4Ijy86QPD0/0NnD+5GDimMU7EhSHnUlhTJqyf5+SbCrrB9jK6b5BmK6DUrTvYSSMI+9fSp5t0/4LMTwkQg53v7BCNu1xxaHg2btDQnCjUNyZbyAAxS0F+UfqilLYlyR2+5bGUylsbFKLvva8X8E+KYUxEBVx3tcAahGOd3TUTJtEDtNJqO0IvPVoSfdwZXjAWAAgzarFIpZoVCGEvWRBeUPaapfriHLKkdLR62y9z3wA3QbIo9d3H8Ni6O5GQM1zbJD0dYYemYv
 8S0Whpst
 /DCOTX5o9ibkYOE7sjxhdrKKnZLDnGkGPNjsnFuWsJyBOcViZjwTsIwI0fYgc6f/hftS+NboWYfjketpYxcZMPw3olhdEMwu/sy1eo2pvIpnWcs06ZkpI3c/Myr0Xs4XTijFV0jP39M70wrpdTPRZGGNB5YpecPz0ZtwR0pf1TxiNcuDTN4yicLpC9lLhqEs/COCmRa47290OhNiPqtow7q9JWnpiX5eiecL2tEOjAmGnzKjMVahSu4JU+ih9IZg/41rbZFkJE7u1vuzyZnFI8vjifH1djwhKZ/FudTmbYcfJBI+IyaIP8W5kirMyXPYfR4EgZQH2AFmnQ179yhAng5it48xjLLTd8eGg/V8yIoNY3lrB6zGoQq0kVwaubi/LrWSCJ3lzyixBfuynKz2naancit3GIzXjfr4UUGxEWStY7BnpbizA4PvC9ck/0aLH6tMbQ+ljPh3qu5u7K714+SX/QYV1UE+mQMHhyBGGs1o4zI1U42v5IczlOc82QzFDxfi6ss2Ggd5rImbQteEuL1a95H5M4WSpJ83UMz0nLrKikPuobLquNbtiPDhGR9J9CXPM2RYY0voZcXbqxdvMZo3Z7SZdikJZ5oClyiutgS0WrsefgJSGvVGee9h8mdCC0LwPIyCqnTNpFr+f+UKxe6SOrMyOc+oiXg7a44Quqhux7fMLyLf7DnGVe/fzO/tmmV8V/2aSWeKb8IwyBxfim5UaoNYg8N3kzgh0xpyu1dgRIGzwqTAvdh2wACvYSCuAgd+CtReivpOvln7lSJMU29uXHuix/hctO1qGD1c9xAF4ae7cRa8sjARq2FHO9WKqZ31v1to+GX4ulUEzKHWjsPvcDGv4ngOkfGkzW/Flhx+tP7Vv59uGyxHMnWbvpCZCpmdY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Assisted-by: Gemini:unknown-version
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/events/intel/ds.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 91a093d8cf2e7..70be80211d823 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -832,7 +832,7 @@ static void *dsalloc_pages(size_t size, gfp_t flags, int cpu)
 	int node = cpu_to_node(cpu);
 	struct page *page;
 
-	page = __alloc_pages_node(node, flags | __GFP_ZERO, order);
+	page = alloc_pages_node(node, flags | __GFP_ZERO, order);
 	return page ? page_address(page) : NULL;
 }
 
@@ -1088,9 +1088,9 @@ void init_arch_pebs_on_cpu(int cpu)
 
 	/*
 	 * 4KB-aligned pointer of the output buffer
-	 * (__alloc_pages_node() return page aligned address)
+	 * (alloc_pages_node() returns page aligned address)
 	 * Buffer Size = 4KB * 2^SIZE
-	 * contiguous physical buffer (__alloc_pages_node() with order)
+	 * contiguous physical buffer (alloc_pages_node() with order)
 	 */
 	arch_pebs_base = virt_to_phys(cpuc->pebs_vaddr) | PEBS_BUFFER_SHIFT;
 	wrmsrq_on_cpu(cpu, MSR_IA32_PEBS_BASE, arch_pebs_base);

-- 
2.54.0


