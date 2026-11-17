Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DED4606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=osew5eB9
Received: by kanga.kvack.org (Postfix)
	id 5DD276B05B4; Tue, 17 Nov 2026 16:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DAD6B05B6; Tue, 17 Nov 2026 16:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAD26B05B7; Tue, 17 Nov 2026 16:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 229C66B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:50:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5115A05E4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:50:35 +0000 (UTC)
X-FDA: 85445955630.07.D31A87C
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0178C1C000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:50:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=osew5eB9;
	spf=pass (imf20.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=evanfengff@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794952234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8PaA3W6212Dyis47Nq4cJe1H4XdQ8rUDPqkRzhbwtFg=;
	b=TxlsK1zBzfYviWcmMxgcLZNCrA1f1VZSw00WjlZacNw/0kpBIXgnT/R9v1bsj2MNVYoJ2K
	/AGK7tNjLDO1hVCT1iRPMIMtBaLeNRdJTT6Iik6UHbxghl96RVIlPf7FXV7N/J7WOIBjpb
	UBlIjpupXlGhA3igYAbJnLa/hOfZTns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794952234;
	b=h6EXSKh1bG/c8/nQJFMK098XQEojGuADdhzlbBhxINhoC/f0q5+MmnhIGjIv9BwUPy5CBG
	LttNpztpdP8P2biiqB+65mx4JgtWoBhpCi4sKx8X73Ilv0zFHyIr7jGILDMJx0HDT3vlmi
	fzd64koLX3EqwA7TGBnfTMv5uMUSmns=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=osew5eB9;
	spf=pass (imf20.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=evanfengff@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-4877837890fso157493fac.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794952233; x=1795557033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8PaA3W6212Dyis47Nq4cJe1H4XdQ8rUDPqkRzhbwtFg=;
        b=osew5eB9OVV+oiGekPWmYdIRnto+HylVzVe4sDWMaMKLhs1r9KFGTTRjmAsKmGLZAv
         +H3DiFz8uFnvdupCyodiscErm/9uwILTUtVtKEyjGha6sdU1uJTNkhpLi5RiP5UUQjiH
         yOpkUtwKwZjR5HVQ+Q3AgixshXTHVjILzIopi7hiqONFiUYjTeqRTSrck/503AirZO+J
         z697J171YoVkD31wb5kV6aFqV5W/qg3ljx8y9LAGgE7oIemEErWWYgFJZFiuasThN43e
         kUlNAfulJsAyhg8Wus8tbkOkHivDRytHOnRykau+kudBKSgHW9Qv1vaRv/+CeAfp28ZO
         5d0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794952233; x=1795557033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8PaA3W6212Dyis47Nq4cJe1H4XdQ8rUDPqkRzhbwtFg=;
        b=TtSGqugWHtRqJMCAv2sWshYeTJywWxz9dEa5ux4uoe3l69gkD9urc56CeE+buknOhI
         RSEiwttSKVGIYrrg1QWor8sdSzInQXejzXAn1goUNqz7bWgpqoggK1U0dslVpIigLLub
         6erdsqIgKudJEjRTDVU7A0llpy5QZeGNIhG2Vgh5VlpGo5FISy3Qe4sbyqyPQLFE8Nrc
         HnyAeC3awev7CEF/F/6V6+7wHpA6nbULIFIYvV8srBZEDyCcgkfv995l1GTgDhmQ+46a
         NQfiGwXetHcIoSGwjewFAlbQjh+dJQLrf9XsPO+GyjEDn+c8Q2GSnu1432cO5GZfyk2q
         S8ug==
X-Forwarded-Encrypted: i=1; AL+hErG5eOCRoPDoHaBn4UpmzBTew4W2NG1wAftRXH8id7Orvcko/9thFEjBd4LBXQeWzR4MyM/lx8j1aQ==@kvack.org
X-Gm-Message-State: APuU4Z8bLr8V85oTv28Wq++nxDyXgqPdwIlHT1gGZsN8DfQd2gaS2nEP
	b8E8d1t+PDTny7VjXbGxzw3+16jyI23evTobxmOp2BgOBto4YTUdcW9o
X-Gm-Gg: AYBFou02CBGSfvOzcHwf7Rk30EvqMSex1FZLGKgWT40cPctHlkQOs+LSDFKZv4LxF3c
	E5AneB9fEuG+6ASMNdzYSSIFVaqXsbbIdIToFLzk8jEhxnGiYiplRTdtjqS7HoBck6FVm/HHK80
	6omnNSqKN1sOt5lwNT5qvYYg2CMVghJGjEoW6Ske2dqu9mbtuvI5/wzpdUtwMibpu4/JMolKBm8
	O8HBOG6fsq2aEQ2G9LRE4rOGztyB7PpyamGM+Q6gahoyzvMeltvzmDj8CQdH69PHkwgJQDXCiQr
	dEMzYKn4uSBlwK9UiN+GHN083D/20TOu4OsjW98LVWAYgsKUAt3VDtCLVdgan2Qsnu38uRzxXcK
	rJtDM84caYxLAKtMghotUbJeciFvvDl2/rPzYRHY1JLyAynZUWiiDJf6cWdoDWHAJNpaYlxzqpL
	1RThLNInPn1Cu/qrdRJcnLos4SrFF9+gGFQCNXlAObAPGdbnklHKHSHiSnWR/j5+U6xi94QGuaZ
	ANymVBhSefbT15CcI9jwA9PvTOXNXuXTBPhLpg2skpN7OCV16eGMrmcT1x2wzJHRu9AaQq9xt6w
	6UlOOxARx5wazk8rdOSe8cZ15Ox3d98og7fFRy7D0i1+vk2G7v2w6Fus/tqFd1ginFOp1kd+aF+
	ua/6ZmWCCY6eUsN3GO75y0bapvOm7XgdEiK0jAQ==
X-Received: by 2002:a05:6870:2e96:b0:42c:49c7:a499 with SMTP id 586e51a60fabf-4b75754e3d4mr478558fac.3.1794952232865;
        Tue, 17 Nov 2026 13:50:32 -0800 (PST)
Received: from FKXX2DL94F.bytedance.net ([72.29.204.230])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4b744c1e070sm504943fac.14.2026.11.17.13.50.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 13:50:31 -0800 (PST)
From: Yifan Feng <evanfengff@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yifan Feng <evanfengff@gmail.com>
Subject: [PATCH] tools/mm/page_owner_sort: fix slab allocator labelling
Date: Tue, 17 Nov 2026 13:49:47 -0800
Message-Id: <20261117214947.13471-1-evanfengff@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 554fiyynkucdbyczzf6mzgwcewpf8r5u
X-Rspam-User: 
X-Rspamd-Queue-Id: 0178C1C000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794952233-635672
X-HE-Meta: U2FsdGVkX1/tLtKlCdMn1wvJLqBXqe35FLJ+N20KigetJIGRIzLFyFo7jOYwd30Yaw8jABOYOyy4wseZ//kdbVtztGUNbNTT6pxwNSVLCySZXs/9F8uv2nFaZquZ+gWOSjLkM3ipa3HtSVDWBp4x1jz6INnUdVkPyqck7/BZzJzsvDI/Vp0Lyu0kaC/alk1nQ3jNgr6eoER2U+07A/hMMk5Me9EsABbFts2raPc4QPqrL52gXQGdLp9fwbsWLDrtX6ludjiD63LUCaCvCQIrM/7WsAf54E6bhK/iK4cb9rt0tSaoLkI0838DRHzXJBi4sjUdkldfUFlnsDq6h2WunYTtKUCmmvGAPN1+FAEBEysNfBZFvxQAKMWwVEaYP4r8vgopk9AOXTl/iTxUfwXiP5k4YjKRjYcrjwMTHgQ6YwVk7Y+HMlL6o9Hiq+tu+tldpXfGf7fmRKWCHz+y6LoI666oxS/G9tacYv9zLc5YpvWq+1hcHoEh5qt7K5kB6zKE5W9CNqjq9JDcIqcs/ZVH06ErU+eRk4fowYfuttWNTzpltQAPDWDRZpt0NDRwheolt+7IHcBTvXh+M1+ApzPdq9wInwdclw1EDdYuonbmWIBkiS113mFrsLw3sfk3EETMLavMTBx7KElWYTyg6m0PWAoZ145C768qpF2bBSx8+I2DrtLttiFdQk9MNc+bVxXRYQbW2t1iOovbS1goZQPosTaw6vf+be7F2PGZVkUAqxuyyt5CAe/2k6DV1yRdqXOckR/zGx+Wx8aDrGpZBXwLDEkYhr38kHDk23UO4rU/xd0cYA16jeWT5ORVA22NBCmZhYypWyefzH4+047UGCgYfPT/MiSEsx49+pEjLEd5PQ4t0DEXttopBPc1PNsTcPPcUa0bzl1XQHeIoWTY1dH4koW51LMO9XQzweGh2Kf3rv1qCGP/nx12TaFvu4/8CG6ACbpJ/LzQuYt1vUR6lN5
 Nma2bfM3
 wNCw2TlvzyZ713TRLtIZImocwk5UgdbOCakM1mg4jIAnknG9JVBbBkq1TCpR0s6xCJcQC8gxw3/kk9fPdEBw77CohxGrMsHLxewmFf+SKVI0d5AhBQoOSjQBtj0voIaVlhgd3rqgaNWlqnSa+ZKQXiE+uNEhRgd5rQ06tM1TWp/WztGl92Mdt8knp6Ab34FQh+dC6sKqCgNHoHWPTdh1kBwa4xqoori4Mq9pyPwjdB94vSsgl76Y/EK+9v52Z16/PUfGzI0Zy2dcr3gDPHe7G0VzdHAZTEYSoiDq06qdqbeo/mv2UHoJFa86h2Uo9C/VXtcERDD0AgtxNSdPBZG7WMzH4MPAN1BHFBA8vQHh+FAv7t3sOyotgUZwOwDiEaRCDIEoldWFi0r1K7pSUWF8U+IXRUczz8fFL7Xe9bEF/TzQ9aTMlK6UUqQ0n/o8exOaasASOWgNhjPN2v+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_owner_sort labels a page as allocated by slab when the page flags
in the "PFN" line contain "slab". Since commit 46df8e73a4a3 ("mm: free
up PG_slab") slab is a page type and is not printed there any more, so
slab pages are reported as allocated by OTHERS.

Also look for the slab page allocation in the stack trace, as is done
for vmalloc. The frame is new_slab(), or allocate_slab() when new_slab()
is inlined, as in the example in Documentation/mm/page_owner.rst. Slab
pages allocated before page_owner is initialised have no stack trace
and are still not labelled.

Fixes: 46df8e73a4a3 ("mm: free up PG_slab")
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
---
Tested on v7.4-rc3 in QEMU: --cull=ator finds 1280 SLAB records, 0 before.
Found and written with the help of an AI coding assistant.

 tools/mm/page_owner_sort.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 6c2ac5d9dc4b..453da5ba85c5 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -489,7 +489,8 @@ static int get_allocator(const char *buf, const char *migrate_info)
 
 	if (strstr(migrate_info, "CMA"))
 		allocator |= ALLOCATOR_CMA;
-	if (strstr(migrate_info, "slab"))
+	if (strstr(migrate_info, "slab") || strstr(buf, "new_slab") ||
+	    strstr(buf, "allocate_slab"))
 		allocator |= ALLOCATOR_SLAB;
 	tmp = strstr(buf, "__vmalloc_node_range");
 	if (tmp) {

base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
-- 
2.39.3 (Apple Git-146)


