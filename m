Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A35606B405
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=fn7StOrD
Received: by kanga.kvack.org (Postfix)
	id 87B046B05B9; Sat, 14 Nov 2026 02:10:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788786B05BB; Sat, 14 Nov 2026 02:10:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602F06B05BA; Sat, 14 Nov 2026 02:10:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38BD96B05B8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3AE712033F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:19 +0000 (UTC)
X-FDA: 85432850958.18.6035170
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id E5B54180007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fn7StOrD;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pld+EM/EXNXxfgZubwvob88FbJ3qDEqFg5eLGFwAxrw=;
	b=4ise0LVKHEI9g8jbNUFs6x3TuUdYQ0tr0q064ldyj/kPeLSiJH0MUPjXYkEZZxTbYyPQrS
	tIlq9DZViP9YKgSsTPui80XFv6r3JfPa1QGWWfnvtdxeI0BmAtjewFRCCOH0ilHAsVEa76
	D7gbOxOkE7VyyLsdTc5xPJwQ1yn/svk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640218;
	b=znJ5dHnPq3D0W7iVD1WflqivTP3FGpVvD8Rl0SBWFCpNpR0U1m4QMm3aVVJB144PLm0PGq
	5GmAh2loFXs4RD0d2AbHlF+V9txulcnalEC9cB9Yt2lK2eZ32oijf+lFw83/uPYXDLw1am
	uAJv1fbnutevrd6ZSVs0dt/k5NIM5LI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fn7StOrD;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91eb53957cbso45071026d6.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640217; x=1795245017; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pld+EM/EXNXxfgZubwvob88FbJ3qDEqFg5eLGFwAxrw=;
        b=fn7StOrDa3WqqH9sGzaJPtdK5VN9wxTfAasoJ7IBcULY7uw8FLCmtjgSh4jecUPHDb
         7kFaJI3AIf9+qT+0BR6Hc8qRI+OzA601q6wRqXQEHiD54KYWnS4829+ddQKzoNIuq+Wf
         f7lLXwQmQi+qzunj1zv261RrmFHIDSDyWuQwHdC32IVKroVQ1P84KgSCFxF6hNyzcO3V
         ozZJTjW12tDuDtdScxqZfFg9VhgFiGtIFnkNUEZqVUblEXJGu+SDpEn7ds0voPaDXf67
         1W3w1pLoKG2Vnza1exmbJx5eMsRHB+4rtuN480NHZSCNDOsyzxXP1oF4BXV4KRJO+qqq
         rCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640217; x=1795245017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pld+EM/EXNXxfgZubwvob88FbJ3qDEqFg5eLGFwAxrw=;
        b=Q11qD0fktonu7ja3cy8+Dwns1yh/PDTkUjy73eASNSHMgYtaPSYdPn5QC+ao6J8kCm
         +WZz96HG2hiA9T2arX7MSpJ+a1Vyhko5B2HzFdnqrButArQkDeUFhoGSEwqWf2G/uILJ
         LITxCDBSDOLrkSQvr4VL2HTtpBF5L+pgfg0b4s8w1jtVghgEWnlM7BRkJJjqmrtr8UXZ
         YqalX83iW88dExukdch+b8z3Xv1ZUk4WD1hPU1rKG8c3aT0BoNFPLo0gVibTSRhPCuyy
         SaYhNLOB2OPQ7CLuT+edf2ZQnwanOQm/kR0dcr5JzM9pmNySYYpwzATrXP5Vr8zdf1RM
         ltWQ==
X-Gm-Message-State: APuU4Z/DstFH2fFzAxpwNKyr8gygB5Pq3QRCHrna0zcORVxTgQezKda8
	32POoXqLR7x0pDMSnCovnyi7rve8nqTGMZY+NcEokst0kvpSV+GcQOVJpoSqG/TsAmRfEQUE47o
	2Tk6q
X-Gm-Gg: AYBFou2/g75owEQCax0nL3I0st7TKxrgiZASB1dTqnFTuV8p5rn0eXJuZIj11CWuq74
	3L+eFLB+yQ7mHdmmOb9UOmnHw2Tsx+in8ywOdqvgHFFp7Ftdiy1XjAKYPAg7O22Xbva9r/Xcs5Y
	Xh6pixOZmRcQywMUDak/+zafFoIfmgjr1mLPkDVEyjmlNfBK/g2W0lxIk0PtrfBPHvaCdK99FvJ
	LjLpT9MLM556bcgjox0lnNO2F4pEjrZX1hboSimjK/LAYXUqhjS1bjdMsTn5zDAFw9OjAtYpgg0
	eQvjG/MV/QbGPAG7BAmypxRzBjWRBgqZ9uoQx5VWgbQ+wkHDUSQbKrBqVD+BoIUS4pcaGZv3nds
	C4mDgHmNi37j1ZaLelTQIkc+5Qs+pOCmoQRpc7hexOg3yVxTqgfAGv1Qajal+80X+SG3w9eNoGp
	+q+1xUN4rYDviAVAqiTvYp7+vsxK5TRspyORosHiQ+xFaZEykqlARPpRgms13R2b1QCz6MR92Ry
	svdXNsuCTjjxNlE4Yp3Bh89VUGE0FIbz5OIBdBLQizOk2/u1mO44SYeLG2G+QOItEiY9fK2e31l
	sSgm5XHDFj8szpECpBJmDrUOnrGD4wfrUgCmZ2q67HHqp8ozLYqKUi/6DU1HTE+bzrvCONVIZjP
	Ee3+7yoOlUGiN31p10TFKJ5HuZ/iXa346Q5VV
X-Received: by 2002:a05:6214:6347:10b0:91e:cf4d:f868 with SMTP id 6a1803df08f44-91f2420f9c3mr56246926d6.22.1794640216984;
        Fri, 13 Nov 2026 23:10:16 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:16 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 06/22] mm: base hash distribution on common memory nodes
Date: Sat, 14 Nov 2026 02:09:43 -0500
Message-ID: <20261114070959.3490008-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E5B54180007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 89uj9qe4csem578j7zbu63i5frbgyspe
X-Rspam-User: 
X-HE-Tag: 1794640217-945846
X-HE-Meta: U2FsdGVkX19nAYMb6R5Pe6fjfmTomvR+anjTmCTTjA/+WcwzsXvmYNZACouhHhmNLZxGTXDUk9WbruF5ISpiJN3aas2NFQJZsao8eryG4D/8LxU7q6dAiSa/usMtGMlomX/3ePgZMS3rz9coRKV3Ls64Pe+yV17LE3+DGvY0KMY7IzG4XTJNBmw4gfL4vdlWqWWHjtDi1OhRTMrzMcV2BKykKU0+idZxB7jqsphnvce3fuYPPPXCUbk1wguti144EWSshxCLdyLTVa5n+bhgECG5J41JC+6GWAbFjRDqyQRRkCUz3u4E7xItJ0eIDvFtbJB0PMlpO51lW2vO0ai+/ol6ka6QUpBWMC6TQ+M5fn2rYFHMq0dMyyhyJbHhP6aXKeHoBmLjChfPLgD7SO5gAAmBB0M3YGo3C3SsYnYqUa59BacGCfWnBTykCChGlEdtcGjUMFhQF4GluT7usIKRqgsCODgX7yhWOtIciLKltUKUYbo37dRuXXdE2LCccVA+OB0y7zb/iab4Jwt0Hccd+1p2MpJxJUHNzxwsSGldDKR1rbrFV9jrIFti9Y5/XC3xvYUeh+Qdmt4ERbsUu02HjpZSgD4gTrlr5GTozgGOhUJ56NClTeEm9teByR6xuBVJAe9y28HpQcqvwotWOuz1Y5updxtV2GOOuMghY+YV3dO+mhnoZ0KNvQN5JUBlFZWU9p5m/IU/ffaxLpzfd3qteyXxvLXczAyGVlqmHZWgDd4YJ6NIbSOT5EWOLEdGopSQSbCyEywYoUbud2v20jAN0qwh4Jc03qFWoC9dWWIpHsH6JzP6NjX11Y7nkNcmousPZ89Rw7Ytm2zL5KBtBz7ppjUoVLveOdbF+jPrkJYJjVGfP88hfBm2zh6Ic9NFS4GSUQpn1EtcIA5yI/IUeyuE8Q/CXdCVFKbRWHh2OLKTxdf3adHXgzVicNCD9spMZezghKvuhpbNzlQj8Cvc8Y8
 F1XOVN7V
 +pW2wSSYshPwg9uQYwBANFvGP2/8IytloZAtOKoze/dHxJIR0gqqrLGsZJPSrUQt84RpjJpCq2qAo/EXTXIE3/UrCuq1+z5HWQ0JHMrzy9o0xV8aV5euvGEEccLkBEejW+wbu4YWTedJShqqZVJE/+jLY4+0d9zfZLw/qP7SH9i0ULA/K+vgpU4QL8WULphoV9hBJWPjT8mAkRXmZusFWPmPbBfCR+tQeeBETq6f5BM6js6PILzTHEvtz1JiMY4yv5CoK/z7aY/9zx2jH724yLL+q4b0+uPqoTOmKQ1svU/wjluH3/3NpsxH/3ovfbzr0vdlNlm9CYcn0hsuoo9m98uJaRibTZStQR51EWd+47y18zUyIn11+tdrQ+Pt2dTu+Qoa7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hashdist is useful when large kernel hash tables can be allocated across
multiple NUMA nodes. The tables come from ordinary allocations, which
only N_MEMORY_COMMON nodes serve.

Count N_MEMORY_COMMON nodes when applying the single-node optimization.

All memory is common as of now, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index b4c4dba93652d..0c076bf5bf380 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -685,7 +685,7 @@ __setup("hashdist=", set_hashdist);
 
 static inline void fixup_hashdist(void)
 {
-	if (num_node_state(N_MEMORY) == 1)
+	if (num_node_state(N_MEMORY_COMMON) == 1)
 		hashdist = false;
 }
 #else
-- 
2.53.1-Meta


