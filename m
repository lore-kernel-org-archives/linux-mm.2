Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843E2CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2A36B008C; Wed, 30 Sep 2026 11:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA6F6B0092; Wed, 30 Sep 2026 11:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599826B0093; Wed, 30 Sep 2026 11:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35A086B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:08:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC8D6140813
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:08:10 +0000 (UTC)
X-FDA: 85270759140.12.DE9ABE3
Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	by imf02.hostedemail.com (Postfix) with ESMTP id E719680009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:08:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kw+NA6ir;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.167 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790780889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIHsTwyZ43cnCG3HcUOwIRG07ClCz/sTU0nge1LJvus=;
	b=Ebkm9G+zm0fS8UOH7l/GmaZKrZHgocZ0dus/4SYYSNfRM7Q41YZ2flhkkRLHup92rnOGtH
	UjYia66n0sONFRYS/TSAcWUu3+Oh1l7okO7bZu08gzOWHxO0LiV1BOoW6ZWUZF/Vhv4L3D
	vXfNkWvXq8ixLBaapmW29eufdtAubxk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kw+NA6ir;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.167 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790780889;
	b=x9RFNXN/0iXN37H08boolFxyoiTpTurfaJMprvHmeBh5OstNYPmT3gf8tR6vZSPPzMOjYP
	+0CiZreYHbKeqhGTdeaGylDCt7qoBbcNrr4bsjzcmpLU+DEzMKQr9DuYk/as/VW+tvXl9Y
	DKWGCt1490O69Et5eua3r0FbU95HRO0=
Received: by mail-pj2-f39.google.com with SMTP id d9443c01a7336-2e2d42b972bso10970465ad.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790780886; x=1791385686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BIHsTwyZ43cnCG3HcUOwIRG07ClCz/sTU0nge1LJvus=;
        b=kw+NA6ir4gowh504P24wxyVGQZIS0K6lPWPzLPLKDutOwKWRLdXStxOCYN3SIuLFqT
         oGw8XwxzpbxTemzHEotyV2n5DkOvCwxRHQo9v6NZgKLPbPCtre8GyL8fGWdaqMtp2BSl
         iCBmNWP8AkpMct+wnLUqGxnfqKpDEVvX3BRyNfdJKP8QmZTtDkDdYr/Og8PfwbrIogQL
         kqou+JNIxy3uloTQXSzYgO5tFYJhl+kqwsaoRIoRtrFtAhBL1/fmU6GT+jXSonkI/kJc
         PwHGPr+x3YgW1Sb35s2PyqFp5Lrjn+4XT9tQMn+cYcQ0p/BHpNKZyfB+X6CLsVurWCUK
         ppJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790780886; x=1791385686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BIHsTwyZ43cnCG3HcUOwIRG07ClCz/sTU0nge1LJvus=;
        b=pkVRQjx1gXAi2oSBX9frF8ijfyTK80w80GO39+hvGD7048m8mUdvQtJalv+xMPNTTE
         4JBpReGr1WxWKfGZkFcIj97Rxr39I6frEeQPe4ZJD+BrGsUgvOudmdEIq2s0wLq+cYW1
         Q2+qGwcTjGGzHDE9rGJQ0XrzfHsJ5v+w07Pox4OJWyTj7Q2EeoALenyCVrFr7Eyxi2uN
         TKtcYnxxjI2WArEgEfe9XKmEaITvN0lV8MeQZ7dgYsf7+q/oR/T/bC3xjnRqQKfouXBI
         br3YAEwUrG/15mEVMRMfETbo5oFbCGNWOFrSGqTEy6fDf0sbPKPYrn+P+NJeDSw9yLQT
         +sRA==
X-Gm-Message-State: AFq9FYIv8Gf+2OfNOhc3jT0xbOktnUfBcswt2n7fIZyiwLrvSww1yd9X
	nNlpEjdY94Q8gNrtKojW/mf1P424rYTDIxfQ0ros57udjlxbxWahQ/FxSOEDJIm5t2s=
X-Gm-Gg: AYBFou1o/4nIRu7B7HExd/Npdq1qnfw29wMurI/11H8smzjhOYq6pXCBANcdxPmuKYD
	T2dAbS3g06iZK0Nt6vemqc1XmTQVrNfQWShe9W19AY1Oeq6mSh8G0sTKEloe/bR+gvRFuSUf3VL
	tU0HhdFawLByIJrvwSacMFilxz+4uEoP1iOVgy28RA74eAdl5RPV+2DQ7LQEoowvlD0Lw1Btnh4
	gHFlmCIZ7c8GzM4Wj0PoKMteaDGniwAjV1GJRg8HfjJ+pYUOxbHTgb/4nYkIwK/+3KoaQJbKtVu
	b4KBm/1zMxs3kRwyKDiWuh8F1CLqcw7g+KDDN0MDtKRvKMbW1sY7FD/3OmiGMBCxoohZB7e4yw4
	tbcALYhXMBKLBQBfK9foFow3DUeuPngBuQwX33bFN9ophIN7d067SHll5AYp/vu4Tf8fxDSbQt0
	8UTAA/jlBKcYKJMJtcG3dqhOFOp/P1pzcvtmPHLnGLKpDTfYr6Hcql8sVoTv/C38YFPN4q4t2ad
	ZVld2ZRJITuv6jNiHA=
X-Received: by 2002:a17:903:8c6:b0:2d9:26b3:547 with SMTP id d9443c01a7336-2e2e49f746cmr14145765ad.20.1790780885353;
        Wed, 30 Sep 2026 08:08:05 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e2e587f71bsm9426885ad.2.2026.09.30.08.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 08:08:03 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH] fixup! mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Wed, 30 Sep 2026 23:07:48 +0800
Message-ID: <20260930150748.1134516-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-8-songmuchun@bytedance.com>
References: <20260930140627.57431-8-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m3xbgz3a8px8y5qokgidb1mam6smcwon
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E719680009
X-HE-Tag: 1790780886-833371
X-HE-Meta: U2FsdGVkX18vlf0HpNi/zn4JdyiXz5KhhanMs/VItpMUdBPNqugsYJZJY2e9xNp8GjBZOAju3g9TpcVkBBb8ceT/96U2vnOS61Ic5RGbw34XvkveYP8tJTqgp1NmEE/SfWVsvZFYkb9RcE0JG5xZQfXb4mz1mK2q/3oXWA5d+Ep47gG8uwYPC+sclBR514/KeQBo59cV38qLXZRTWaxpiSTiLHg8ycml8wUmtvITcq0nQiRaoBHvJgaH+fTb3o0zDZ1puEEuhiDwZNS9tTOV1QLrSE5g73xZC/i6Am8m2Rz4ZmMYyy/4hxSPRo22dMf0QLnPvxFrT/KlALmrxW2qSvFIUunptPofpYIWQ/NI2scRrMeyIo5XU/p1NfNKfSpIJ7QnVIpJ7JbHPXCBmh5Toyz9ZpzgSJ/OEq3IK56lGyUPbYIAPtHc/veUG5ghULQj8+Pgul79fX4oqCUgra8XCxtionH1KzT4t6eL4ZKS9Hj1rD1FqrMGS+NHLZKSg8555BFu8QIoUsAH0YQqNkBymGp2q2RKeUeTkcm5F5T/uQELdO3abJmZ7+ZMM1FndFJTXP7vkYK5tvjrYSG2BzL0Fc/+80igDiBBqYzLl89iyWdIvJjCSn2TOEIo5/IhSG3JT+eCk7YC7uNjVAkILAxLozxAG9MpiOeYQn78wnnWelgOIJT89XoI0AWezd5goXYKhM82JJDRRlti8HFLh6EK1eilBQnJaWoswVLZOU1HtNnxvF11INfDRlseDZgTnyYjVuVuQ/hd6X3urAs+clap8aDPYPO0Pp+yn05XsjKqWyrJzcvFFCf8IsosmDK9UYuQ/EhMkOQzF1cM/JsAgfWredhw80FafJi/+vPmc8Zx7fZuwrRXszinepL56g40CQUgc/DDN+N04UdwywZ/35NnlDPgrims/wZpIkeKKscFiq6PiJ6F7e3h4PziPCj631Pr/sj1MPuHtm7PEqISwy5
 R7D/fOP2
 OK311hF73+J3z9fJO2IZ6+wVW8thRy1GCqy9y/89zqrLxg5a2x5fXrPruC+DWq59tCDk8fzV5oy6rS+l1EXA3a88t4oIlQHQ7v7rGjfqkES4h7hYdguvbgKiTeuuthc0/VB08n96L10jJYxS6/X9+Q6VjhKYriWNcZHyoyQj1GCG2HxB2tRL6HiY+/tD8Vfl5vjqic2bHHgbkk8GEVE8aPOzLDu2bEWDMRvsBtKPRADxAOwsNPcY4jZGt2C+0/dfLds0U2VAhdkQfgZcFpbzW+Xzhxhhcw0ObwI7f/IaKLcDUih+PtbIg+zxQ1i5dY5kahDpLz9M1gH8BoVwPFgkn4tTGwz9xy1FOZAWVwHuW6a/fGoa8yHeF3suyxGs2Lq+dtJKYgVRzMH4RNIue1Ck8Cv69Se+w5n7mKg+dsgVpOPDYjUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

prep_compound_tail() makes PageCompound() true. Calling
__SetPageReserved() afterwards violates the PF_NO_COMPOUND policy and
triggers VM_BUG_ON_PGFLAGS() when CONFIG_DEBUG_VM_PGFLAGS is enabled.

Set PG_reserved before preparing the compound tail.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 4be85e194c78..23b31bc4bf94 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -222,9 +222,9 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 		atomic_set(&page->_mapcount, -1);
 		set_page_node(page, zone_to_nid(zone));
 		set_page_zone(page, zone_idx(zone));
-		prep_compound_tail(page, NULL, order);
 		if (zone_is_zone_device(zone))
 			__SetPageReserved(page);
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
-- 
2.54.0


