Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A249DCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A17F6B009D; Mon, 11 May 2026 04:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178C26B009E; Mon, 11 May 2026 04:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EE06B009F; Mon, 11 May 2026 04:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF7846B009D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFCDFA05EF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:31 +0000 (UTC)
X-FDA: 84754525422.15.5E6A9C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 97AAD1C000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UprOrXiK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489609; a=rsa-sha256;
	cv=none;
	b=5Rwd85wwWXNv3k+J1B/p7OM9paAXT57MlpLOrXnXO78WMm1MqqbQ7pxLUpjePQ1MgAhOyB
	tiPAXsSEata5K8+6yFRgE//qu1fm9SfPwD04XvZQho4PyzwOSiwJh4U45pAFmNeBafMCdm
	pZnCPFHwmZhG+mpFb7VaJvsRwFcCoMw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UprOrXiK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=Tue5Q9ZvLsh2sm58eOLZIIDRlrdfdIcaDMRCdSMpgj0dbQx0zZxRL96Zr6jSWY8pqcD5WK
	31RJB3Fhp4SKCY8IGriQY9NqlxvnbVw2qtsN37ZJpPAqdEOiR1N2RqFBEDvPzXMj1T1br3
	jwrs2tT8l2TZTMt2rvvHRemKiLriAt4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=UprOrXiKTAdWzhZsW5KhWh9QxYslihy6U6SZVMez6RcPuTLOTVRO10h0BW8HD1UrFKe+Qo
	iavE4x2fEiQdzdTHHg0NV5Nni2I9dXVP8r7PCm02pbvcpYsFS0AkR2P/cytOShyMjRcl2i
	8Kk420WzbwnOxzeBb3Zy9KL4FxNPiug=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-XGh07c_HMPq_A4z26fxcUA-1; Mon, 11 May 2026 04:53:25 -0400
X-MC-Unique: XGh07c_HMPq_A4z26fxcUA-1
X-Mimecast-MFC-AGG-ID: XGh07c_HMPq_A4z26fxcUA_1778489604
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43fe791a398so3717673f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489604; x=1779094404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
        b=mtXTPULmNyPiggl0wZ4u2qkhkJQpjfOCHr/eqFIjVQrb5iK10/xKCcqxuH52PKBN97
         ttysntG5m5RLTEq3iCq9f3RV2ax6gaxiHNLMQ1QTh5HTfJOzUFzgl4ASVZCAS0Oub+UI
         P4f7muP/Tf++LyJRzObp43zXPJxBgYFCf9CxrXom5f/SH99rOo4Xyyt/3FLvK8HP5hU6
         sndHOOI4gR5+Xcc4/cYhy1uSeNNOPmzksVWrrL4LR93nvyAFKDR/WYyiFTKZJ9ZYZ5sd
         xOOh1+/LYUy1LdiR/YtaL+/TNcBJEkkAg6txDOV06HCeJ4LPZMYvFeeQZSCPWYyumfiB
         dczA==
X-Forwarded-Encrypted: i=1; AFNElJ/9O/ygX0xvKCVQeVouNMSL/v1abXZEDsW0uL70iojBgTe/Ku2kLWkLliAXo2g7nKEhQu5JM3+uWg==@kvack.org
X-Gm-Message-State: AOJu0YwS26p1J+RGYGww0QvpEUsqetnqPHmToh0J+Surq31WNuN/HYlw
	DhJJkt0DH0j1sOUiaUvWOx4KioqEgW78m5Xpiq0BpGnJU0HnA6CJRbfPhSLskPbdLatxHtZtBVG
	K+aGDmYxHSVMFSEYU1xnFaJlUX8cqf9DyVjWO2UI3tvnjcmqXDjE1
X-Gm-Gg: Acq92OGq2JyzoHdmdLJF7O/mICDzHkytCRj2Wfv+FjdV+qcZfbi4He6lpxfsjJVqQta
	+8UFzvO9TeJEpOTphFddyYEByx81LimAUSmbf7Dhwd6svsRr2CKDAVp5QUWwV9LThAg+iGrO405
	h5fLFs/0cTZ8ZKipIjDYtYOzvzOLtTWLDizaOnNT+0eJTHxgEpraEw4EoXqRu4FzSaqEK+Ji/Nh
	HSxnmwlpnG4RzQxGPnVs4h9dhNf2rM4Hjleb5HXRl9L9ORmij+gxTq5q+19vxzGkAEEYjj3uqBI
	+cu1McZKJjcztWypZewT7TS/iTnqkdDn/W9kjlwSMlRvw10E3M3K7ztNXMnifJ8kdnue/7APCr5
	S2cw3x/SkRhyKEwQVbNJcU+kyYQTZrmtW7xyZGy7j
X-Received: by 2002:a05:6000:24ca:b0:441:1e41:19c with SMTP id ffacd0b85a97d-4515ce1c372mr35489661f8f.20.1778489604250;
        Mon, 11 May 2026 01:53:24 -0700 (PDT)
X-Received: by 2002:a05:6000:24ca:b0:441:1e41:19c with SMTP id ffacd0b85a97d-4515ce1c372mr35489577f8f.20.1778489603627;
        Mon, 11 May 2026 01:53:23 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491f8d4c3sm23522307f8f.34.2026.05.11.01.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:23 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:18 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH v6 07/30] mm: use __GFP_ZERO in vma_alloc_zeroed_movable_folio
Message-ID: <c9448249c53681297f44d18c3396a3329b50d7eb.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GAp5T8SmJE1STfHTcxDky7erDK2CsRGHGuKtPN7rktY_1778489604
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 9ebrjnfs3tj6rqajswbc4p74c19mqmum
X-Rspam-User: 
X-Rspamd-Queue-Id: 97AAD1C000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778489609-727519
X-HE-Meta: U2FsdGVkX1/I1rb2Of6is4OmMEITIcfjzVzcmuB9XLQNUDWmg5YJZejgoKf96O2HPByrNNklXNNSObGIKMH9Gjp7Oh8kT6UoXCz57nMoSFb7kNO7+Q1vsUl8ucBugU5S+bzBAAJnpGI1PVJ9OOyumkdL+r0uEEx0bQ1WHPsqcygVVVKXP6cK/tHdXcyahk+w0yI7NnMBfEZsbcg7NmSvQ7FQCQhSZSpHkZAYTOMj6PXxKo4LEUQiXNI4Zh1s8M4htS8Cmrw4i+eKG9EYycBoDHqZty3Uj+9djR4pkpr9U2R7iB266ysQ0wU4q7h1F9gGGTir22w2lJrjw5wfSIQZhYajUBkGMOGhpEMUdO+TGzIggdFJLJ96+aV+zncX+ImkQ0YxKmHKA6vxKL/Sgr/yBHrA/Y6VsoOlK0c3qI2Vj+q0uNT0q8WM/zAAYqbAxWpVJcA46TqkT6ZbB7Dw02evZfU7/hLscRywqN6a8biVI+3uyGMlJWZk0YDZQuwjTIyiXrYSbU4tPimDxTRZ76zLFXmPfGas5JvQiIwNw3y9CBjLwLOvYIfIEbNWWew4ZJsWDNjSuafK/6/3E88q4waeL/IWhgamHMSmAXrvYPquv9macpG/Ah0jMIXqikSn1IUNCxKYXS/13bICiCMn5ouN3QDvPZvT8gg1gIyvMw85cKbmu4I9fY/N0WURHB/3MEvFXmqkprpIskaJOfMCkfTVIw4nfvphZQ0LkLooFvkE0QygJjlkyNQwFOl3Yo7G/K4CCdqlolIa16gvGts0I2v0pvBdF61+ySFsmdMCEj+yNoaBz9DFnx5f/rK6H8HYJqJAsK+NFpaKDwq35Elfd1kpQrOvWDX1e1ZxYcMogcM1ml6eAIldbSrKVTI2DEgJ0eI25kffyAaCludGYPExzKfNZW6q/Nwyk6HBatZarCjul5E//MqPGlFHdKgGHvQU+AuiHIEuoPr7CtpKDhc1OXX
 NnsL+NZi
 HNnRmjgJ1R2HF9u65JnY1iS8Sl0+b4EkFn8Y5ThlaRg8t2wsMALmNgN8Ubm9BOirvQcRI7c1ST6qsk7rtxd31u1Ckugeyx2uVnsGeWm7tQdCyq4qD58sVqJQYdER885HD8QgJGXij3jS3PUmy9j8Aa43H6PqQrJn7iI6dOiAynTKN22m3OgfPfrRixHaj6s3q1ngfIPBoWoREzPuthzJLyQC5kVF1O08pVkpK33DI4qoiNStt95W61/qckJUWkVRL4h0KQ0U16E/epJkLmode4TZQ/30xvM6zARuLiDyYYhv+285qEz2lHoBB6S4h9RGDoVY7feu6gPXn1nDwlG87fQ7bGeUOjPqhf62I9Nui4X4skdOwWmdDYqG+vtjLdYBgxvlK8Jd+LmG6K+C8yObWFFRSGIaTcjl0Os+e3YJWMzbBCClngOgWc3ZQ/tf/6MXxxl6+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that post_alloc_hook() handles cache-friendly user page
zeroing via folio_zero_user(), convert vma_alloc_zeroed_movable_folio()
to pass __GFP_ZERO instead of zeroing at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/highmem.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..ffa683f64f1d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -320,13 +320,8 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
+			      0, vma, vaddr);
 }
 #endif
 
-- 
MST


