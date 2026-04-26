Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4FCFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83426B009F; Sun, 26 Apr 2026 17:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B806B00A1; Sun, 26 Apr 2026 17:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5346B00A2; Sun, 26 Apr 2026 17:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3296B009F
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:47:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AA3A8C1B6
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:52 +0000 (UTC)
X-FDA: 84702044784.03.40E664E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 285CD16000C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UvKDtvnL;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dn5xupL5V4qF15edJs01tgV6QOrsZ1JWzK8CN9u8yrs=;
	b=oGBuTk+UR2MJ53i/gNxCq494yieXO+B5zpxefcSVMfAUveFjnwmZnaU1N+Oilkl7Slm7N4
	KnWAvb+InOHrdWrOeZShaqFX/PG1TDlttSkNzVFm5Q839iZT4PU9KyPJ5xRjYFxHnjc80s
	c21Q+M1tjHuHVM/7Y2X9Q/eLiBVwKUM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UvKDtvnL;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240070; a=rsa-sha256;
	cv=none;
	b=WUH4Lksj/R/r5PW8ig/vMd15XzIybu9HMLZeZQRUy25GXhlBjt08H092V/50Gir2kJTWvF
	pA/raX598aT95mnC/JrIzn3/pW8j0hqYZwVb+8/F1n8U7G64QD6yYWe/+9+GfNLr5732QG
	08IZUP64kXfB9IxeEWC0ngRS2XfRmBE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dn5xupL5V4qF15edJs01tgV6QOrsZ1JWzK8CN9u8yrs=;
	b=UvKDtvnL11JLzEMFQC6f0LRovIRu69QMmhq5he1lU410lFA9LUt0TquPfG1C+Cno8Mt6Ma
	d5SVTzXdP3ZnFbQBCHNlH3cid9FCLvhQdNwRBD/Bcc1EdxHzygftaOyT5VTyhLL5fPxTOk
	WSbp1t3sZ30nkC8EgNwIKJcjE46nmvQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-CfFvCR8dPE-pCPDyOJ-zOA-1; Sun, 26 Apr 2026 17:47:48 -0400
X-MC-Unique: CfFvCR8dPE-pCPDyOJ-zOA-1
X-Mimecast-MFC-AGG-ID: CfFvCR8dPE-pCPDyOJ-zOA_1777240067
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488ba2f4094so57571995e9.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240067; x=1777844867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dn5xupL5V4qF15edJs01tgV6QOrsZ1JWzK8CN9u8yrs=;
        b=ZIfgd9oawu3oRl724GpyvyEgkdJoVhJCtyekoDRFjs0YCjipQBZzROKhHiSbYE/8mX
         YXA4Kv4Qmt52XK2jJSEibTw0mXDpZ8o3Yzat7GsNTjx8jx/G21d4TYIPqh+taoqdVm1G
         PQRrx42n4H5sh1TI8vyX+srKyjdlMr+cMS7ikgClE4SBSbMJ7cHj0ta6X5ufTNvTGRqU
         bU7bfGTbmur2R50s3s05ejOL3ito0jn095tW8cwejPaq/AjI0fguBl+P/AJQ8koyTy9I
         VRFP/dn/d8r+4SCusCtnTYKERXtYCv+7Vd7jyWh6BCVz86djWAOzYBWEHJiOGDLonBt+
         Hm6w==
X-Forwarded-Encrypted: i=1; AFNElJ/jCpiZJx36TcECEMckH+XIHztfobMOxQxB6YzwSh74BpDfw9AfHzKWUXi5fTX79lk9KRXP2MT00A==@kvack.org
X-Gm-Message-State: AOJu0YxpZhN5uCZO99u8n8s7ASIiaJfuWnjJkCTAOrEwBOfPDqfmYxn2
	A9HCj+WFDAtlmcPeb3wPYjed9WsbhZMzN0GJeaBD7qP5Q2t1ECUG/pzJQ4J293ZJfnBlMu9pDjZ
	0b3/CZ4yxqaOLSwXL7QdeU9w2FJEzcqnn7ud23tajCo0J0430muNA
X-Gm-Gg: AeBDietrmUF4Nzgsd3a2AMjAPccwCzHwCNme9Aay5x3dERLzD0P+iyCCSyNj9bPHG9E
	ViXeKr03Dy3QQdeAkLw3qxGDJRKQaldAtDQe6KFuVoB8JZLWuPadfiiDC8Zcf2b8SRos8xo9c4x
	/MBS3kA1DAFxBNXz1ODVIDIvDSte/V9qAO7P8x6p7AeOZp9Xu8xDXWSDeVj8l6avYdId8xAN2WV
	hdnyhv9dXr9a3AIy3YLJST4tKAZ9v6czFrWNUd5WgQVqo/nwgmr1Z8Hm+r2bICIF7D5E4GBcCvR
	VUnuMfpKdmJGRmuKmDbM2IK1WjsB6G5gvzYLT3fDWm3rVNjKXQvOnybzNmAXbLEpzc20kas61Mb
	RindXJVvUd5UoJEYDztG21Qz0DmnKHE2pXAXC6OO/0ip8FEfWHTnBD5Au
X-Received: by 2002:a05:600c:348d:b0:48a:674d:e756 with SMTP id 5b1f17b1804b1-48a677401c7mr138299655e9.20.1777240066828;
        Sun, 26 Apr 2026 14:47:46 -0700 (PDT)
X-Received: by 2002:a05:600c:348d:b0:48a:674d:e756 with SMTP id 5b1f17b1804b1-48a677401c7mr138299475e9.20.1777240066327;
        Sun, 26 Apr 2026 14:47:46 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc10019bsm765742785e9.4.2026.04.26.14.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:45 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:43 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v4 04/22] mm: add folio_zero_user stub for configs
 without THP/HUGETLBFS
Message-ID: <1c5deda275078ffb432af62ae293af1f696d29a7.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sP3quECOcdwa44c8yYUbMRTRAY7zSnroWkaCcbuq9JQ_1777240067
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ckycxwj6r7kj37ekz7yonksn5fjmythi
X-Rspamd-Queue-Id: 285CD16000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777240069-937028
X-HE-Meta: U2FsdGVkX18jh1iYNbtk76YrdaH6+bF76Kyeu+7wWcWAD56zBBQEuoGgVlM8JqzdQIjnvRKEEsmYkBmlOPn66cxN4+Kk/cz0eJf/Q6gqUypXR+v1CEtgPzPRBBkFyypTpIQR+clly55N2kqLLA05aEZJ68JGHjhB44hZnSMNLkLpNWb/QhyqslabW/zV8FcUlJvqJ7rre2EhqUqHnHpbJoSxmASn+uUlTQNKFnKL2GXjQkmnZbHk/0uZwSmE7aGsecSoHstWk7sLzy8e0tQUq5U/cLnRxG0E3PAKzjtn2rijcQj8YV2QNEVO+48LdTgptTcTDgJIanCR3fXcOI638yOvulRm+svGQ1VgWFJMaujSrlqIwhg3jJWi1/hI7gPTXphp5cmxNXIIKIUrf6r6qJtw3NZmziozoBIaz+hhV0ybMx3VlHi+vRu7p4LgUJs1w3mBv8a2pO89wnpAPp4FDDzFiPCtWrGLxmX3GKTIyV+CWHoEZrTH/KIZ1vRiDERL7XhuS0jMfX+5oJov4vXLkbJLQQkohN/SHFhk0RreDPUzVQCzNx5qlu6+6nB2d0akC2Sn+AXZLL/I+j87vNqVdCt9hssEVudYpbuRCINYFhcY53GUndlsF46MzI9NBmali1LmW0Y5k5dq7OxP4xSL77yf2SXJTePgf3IclYU1FYkNWQCVoZmnO3jwsjVQkEaVdLE0uy2n+C9MqTxcrS9qgpgg/NOAsDbUJUXL8dB1WLFCMFkDSWGwrX+8D3Pr+NgDQD4EtTOWYyfyAK2PxR2VVB0nOz6vx5Q+tN4UgySO+EGtVjzWFAf8KV4h+sVRDlCdSr+YnvxRpJDTwLQnwWiMaSK7SCb0ujV9SxbPN9jb+suMN0UjOeZ57QFiZWrfKp8DWfatzsujeRNqo9v7KcxELZ2PD38PL5hTFb+pB4+mCjxeBbUj8iBguoBh4wCf8QcSga3/RKoPk64hQ+CAl3f
 cYERsZ9o
 qoEakYbHs3VrnkZF6OkzlGPYaZKilSm3ndtNiSLD0c2jd1RDNauit/VwJnWkKHp2+MJ0srewXN4vRCGUmv4HmhEh3x95wYUeVxBByCgkoGO9LBqPYNq3C+VYIBCdsWcPjmH8klUWKCyODjlbYT3SzNsleMLPkT9xbkIH7V0HVWjy9RpjD46ezdB/hE1zXPBKkxA6dvqZZvq9dYOF0SWbUGFvzr1y7Er4q6c4Bj18kvMkvTriImpppwFaGMF9I0dL0sisyf80gffrO1JWcyMPSPz++dRXkze9g9XQj3PJwjRUDZ5D83ZmBvQMB/3taEk3iUZ/YKfw6zVbbET0Qz/pnRLqAGFap69thLk4hMUEAcTwXYHprG6E9Y9vKu3EW2MqNirzb2oWq/C2sGjz1KpJZ8a1Y2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() is defined in mm/memory.c under
CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS.  A subsequent patch
will call it from post_alloc_hook() for all user page zeroing, so
configs without THP or HUGETLBFS will need a stub.

Add a macro in the #else branch that falls back to
clear_user_highpages(), which handles cache aliasing correctly on
VIPT architectures and is always available via highmem.h.

Without THP/HUGETLBFS, only order-0 user pages are allocated, so
the locality optimization in the real folio_zero_user() (zero near
the faulting address last) is not needed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..541d36e5e420 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4718,6 +4718,9 @@ static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
 				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
 }
 
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE && !CONFIG_HUGETLBFS */
+#define folio_zero_user(folio, addr_hint) \
+	clear_user_highpages(&(folio)->page, (addr_hint), folio_nr_pages(folio))
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
-- 
MST


