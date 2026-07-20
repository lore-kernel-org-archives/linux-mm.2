Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF171C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08426B009B; Mon, 20 Jul 2026 15:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7FB6B009D; Mon, 20 Jul 2026 15:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80286B009E; Mon, 20 Jul 2026 15:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A41966B009B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DE321602C3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:02 +0000 (UTC)
X-FDA: 85010158044.15.A80B107
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C229140008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W+StbK8R;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhj7NM8i+En2OSlvQTOlJiWxfz3FRJxBEkctJdapuZ0=;
	b=Vd7Eu1Wn1jf60gr8Y3tfRzhPBBiV0SnJVkYCoyABhPAlUZBykXc0Igt5TC8n9KqAQvUov1
	atpYT6AFF+EW2eEYUdihrfTn9tblTAQjOHpYt2ggada1M9V5CTat1M3boYsHWYE3mkjymn
	+0h0IL06BR4dmlhKsqhzMiVZtHUCUms=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W+StbK8R;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576100;
	b=wR4KLR+h3JPwzgLW01g1kDqUv/dtBT+aow+igSASb0BN8PgZXcvwblR1kLLWIzIWCwkSjT
	pGTJXRhzq4aryOViLHb/t/Whnz75fApdgg29cRadbAF5HtO5Q6DZP2GTq4i6BDVoSCH9th
	koyfF5bKdAttihh2ZiwvH1pyIr3PZ3w=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-920f33347f5so818343585a.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576099; x=1785180899; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nhj7NM8i+En2OSlvQTOlJiWxfz3FRJxBEkctJdapuZ0=;
        b=W+StbK8R80fpxvUjn+epHLDvjUbgds7puDloSIONdBxKFGh19/8SOk6clok7EaaCgm
         cpjx+dQebXJCCSfhctg/cEsG3R8Lwm6qWhzLMafdInSFITF4HJ5iWJyVuM1v/Qxc9P5F
         MyUb/uP4pkZB6iItmQ4uMN9EKMv9fCrr2QOeQl/wkNPUtLm+aD43FOk/k06lWjNcY9Ju
         7Y7JBfEHeDDBD7+00S7zk9YHXFr1pdDEURAOQBd7TbCVI9E4jxtj8MtJZ5GBM0/jket7
         ZzAijcyIpaNZaEoZaB0bmjsaWk754tKiwQixRvvDogmruuMfewjqoO9Mr3JccyZ57C8Q
         fwnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576099; x=1785180899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nhj7NM8i+En2OSlvQTOlJiWxfz3FRJxBEkctJdapuZ0=;
        b=HCBt6Ie69gSnSe2PpOWYv/1+7VhofUu45umrHtmIFbm+ADPzmbiuAqaFu5FUSXFeJs
         SPaXUzZ7GPpoHls+c+eY4CwEriOSkIwqxTPqJs5x2SRxfZLROucPVGOUESrVvBJaE1DG
         FnN85HuyDgVinH1/fss+ddp8zvVVn8OEd65yam0bTe0N5Xtowr9E2/+B1+Qtnc4hRq31
         pa2dWVCvVUQtzAgbl9bP1LQGjYf/R1/YIXwSiZ4ui1EysDhp1EFkErAN/nRQDithN12V
         jp+FUCxtp8eZd739b+PCA0h7TZkzCy9noNZ9f8amhyhvG6N/7RqOZQPtnVjtTrpUhIJM
         glWQ==
X-Gm-Message-State: AOJu0Yy6HhiMOCkcK+IyhLd8C4T5tJBQf1UApbLLvSFS/14JsMBnDv3u
	tZApM837zYwmIS45tpvLd7MMej/rQcnjTjXfhY0jwe4aywZOr3I8Y3C/nrtxxE+UFCDYkV5DqFm
	GUZqU
X-Gm-Gg: AfdE7clYnN+c0Ut6+5TP41anGJlHwGsv7BsjT+LSnOiaawLGMd1P82W48bX/ZiSkYFB
	auyReWVy23iwWawlJKb/rR8Nue9KgR0PIp9xFXj3DvL3epxWsEVCIX5KRVUznKznb83H8KZIxX5
	MD/Ijk/yoPiGdLf02ycwcQDyCFGYv3CJvZ+nMOzMq7uVFfv5FWkZxYwQFNo4+jHFoh3mjWgYhr3
	nrxfm8uZg1fq7oSbCZZJyKvzfPUVnnecW7SAdSj13vWFQqTNWpBO7pS6QU4ITSuOhaCrulyWmJX
	PVngeaj7IYQKVpiPWZiOT79pKeMVswbfm3xgwyETLyy4hFcjEzLlvVhFKB5oxi5yyRNQQyKhTDN
	39rM0ESNxreeGod0PCnrcCIandDb+UKgynVgo4Tt7nJtwgRCeJ+LfSUoLtgDk+vh8o5MNMp/hM9
	8r8Cc2+Ao5r0EZgc3w3JF8tmhT+EMeGkbvzAh4/CAtYJT8nlP9+5H3HJ2/EG+mwEY=
X-Received: by 2002:a05:620a:4551:b0:92e:be48:80c with SMTP id af79cd13be357-930b41c232dmr1527846385a.57.1784576099368;
        Mon, 20 Jul 2026 12:34:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:59 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 08/36] mm/mempolicy: skip private node folios when queueing for migration
Date: Mon, 20 Jul 2026 15:34:02 -0400
Message-ID: <20260720193431.3841992-9-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C229140008
X-Stat-Signature: aqnr9hsm3pbjp3x4qrty4de4gr1nxisx
X-HE-Tag: 1784576100-49463
X-HE-Meta: U2FsdGVkX18mtl+n1ClzKM9sv+xBKYvv2eFKOC4zfyAM/E9TQvTOxaRbjAf/iyszh3dk+phpyjjlQzmg3Bfw29nrL6eqfQC/+OyabNh+msBck1C9dsPYUt7xNQoB5f7slLZ0lXUyoDRlvBCYLUk5K/vAo5HrxWcqfsgtethI1Q/uKdDNAU452V+xDL+KWS4TXXEkpXqEUlqw+J+w83J5NG6sjLQi0Ed+D4nJFXy2e9gwIRNGO3rcjJCJB6xodWFA+m4TLf5ulADy9WkLbTKJvZOQ7vbDNydPa+LDHunFcBGCAZpzSSgFyDKk8RF5ValukioVnLlgm+kyGu/BBJonxb7dlSM+Rg6yFwRP7FVIXe5FqJe25ipSkuycHrxhRbhG7KqwsCdrGNQ/GVNRP5+MlshjMAszeasN4dFiR012D5SYaPfNb+Sd5AsV9hNJtkupsbmX+hwZ5Hnx2B7E7STfYy3eEf5TkAnixqMHNZU4pIGX46FJXg4B6CK3ed7Nq9/rS/1k6mFxXfoi4tOuakaEUKQvzSAySRHCY9blmG4K9wVlAfDdFl18K0eJ8px3wIMXZdApSor6ReEiSrUn4yoQJ2WTYNfGJYXLoJNWm0FPsZnYn0JVRDaFPgW0yDG4rwWzOn+iVk/MLaNKXFzu4QRiXDErthc8VaTwBILlRr0y1EegRxKEr+Bh1D+3yoHiJKa3cPOa1QkrLbx0IgfMQD6tRDRcRNqPjfG/w6g0SPziGKEtRr2LMRtccXL6K/XTmZX+HRN5T0CGgwURsZvPkkjCg94Gadu544bG73oWAaKQLKouduw5DeoXLP+O+RFYlqySSUCSEC40spmZ0cveiycu3tGLkKSbSLOROqlBhIKyHzYuM1JW5ky9cGeGa7MrkcrVtpWiF9FRTk8tG8KdWH+GnrS2MCbmzrN4ftZxbgJ7px1ymbACQEnf7ohMsos/UFd1MhB0uFbVM9OkRPzGjnF
 NXyLgcoS
 DvBdK7Sye70wA76F0JEcGBwUxDg+v56qsR8z4+dNSI0sLgWdPB37U5chxE916TSYNMVi0WDGjUEXUvtIbiie9RzW80zFgj1k38wu/AJ9P3vZCNt08wiZGVzvSAqXzGT9lyhYLtG/UPIaBE++nwll5UHkhBzhZx0eXWT5Qp1/HmI6GG1OPT99ZUNwmuFP/rk6FN/G4rSfIqrqt9tx3RbFDLp9DhZ7Gt/rnV499XM5vvpMlYubxIWq4rjJCN/xU2NM4mhNNjRqM56gojvvV930qHq5ne8rZjTMZGEPvTd0j87+5Yls3K0gRrcf8snfuE+7Rgz9JW5mixx2pRSutn/8H6aEecc6FT4CaRab2SKXcjl1FE5mlo/TORm5hTMjCsuLZnQcp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private nodes are already kept out of policy nodemasks (only N_MEMORY
nodes are allowed), but an mbind(MPOL_MF_MOVE) walk can still encounter a
private-node folio in the range.  Skip such folios so mempolicy-driven
migration never moves private-node memory.

We already do this for ZONE_DEVICE folios - use the same filter points
for ZONE_DEVICE (with an additional point for large pages).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5720f7f54d942..8e8763f6e5f5b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -111,6 +111,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/printk.h>
 #include <linux/leafops.h>
+#include <linux/node_private.h>
 #include <linux/gcd.h>
 
 #include <asm/tlbflush.h>
@@ -668,6 +669,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 	}
 	if (!queue_folio_required(folio, qp))
 		return;
+	if (folio_is_private_node(folio))
+		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma) ||
 	    !migrate_folio_add(folio, qp->pagelist, qp->flags))
@@ -722,7 +725,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 		}
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || folio_is_private_managed(folio))
 			continue;
 		if (folio_test_large(folio) && max_nr != 1)
 			nr = folio_pte_batch(folio, pte, ptent, max_nr);
@@ -797,6 +800,8 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 	folio = pfn_folio(pte_pfn(ptep));
 	if (!queue_folio_required(folio, qp))
 		goto unlock;
+	if (folio_is_private_node(folio))
+		goto unlock;
 	if (!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma)) {
 		qp->nr_failed++;
-- 
2.53.0-Meta


