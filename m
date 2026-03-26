Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461AF106F2F4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763B16B0088; Thu, 26 Mar 2026 04:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BB76B0096; Thu, 26 Mar 2026 04:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602856B0088; Thu, 26 Mar 2026 04:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD406B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:08:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED257140BA3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:50 +0000 (UTC)
X-FDA: 84587488020.23.DC90047
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 20EE54000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=n5UalRm3;
	spf=pass (imf07.hostedemail.com: domain of 3j-nEaQYKCMo8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3j-nEaQYKCMo8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0m3laKqVZc6BVbp9FlOKUOANtvuTeySm/ZmFaYOMpk=;
	b=XDqhQ7DzRnsiqRT+9c7x+WlPUZzX4kWVa1iYodrHsibMaLShDCWWVs6BVqS+2PlGVwXga0
	Njx9ake3mVGzWdjtjRF5ffFbHo6XvudQO2afvDDiL2/2F4g+sr5OuP9WivONyT/NPl/vOC
	NqssBisI/AI9g8BlSnUBljOAM+3Gk1A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=n5UalRm3;
	spf=pass (imf07.hostedemail.com: domain of 3j-nEaQYKCMo8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3j-nEaQYKCMo8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512529; a=rsa-sha256;
	cv=none;
	b=f+sr0U9V1D42j2/vS2CBDzcSAxQhrHmL8cKdEGNu5dthEloggc3HKmkcpQhpZnZ0OskDzZ
	kisrCncB4zETXdI0dQljR6MKzsB/79R8S/KoU3/zmv6PBaH1449Qvx5BvNh9QlwRbcE0iZ
	hOv04wJZPQ3CYDCMlLpsUglmmRw4sCM=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2bda35eab74so476612eec.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774512528; x=1775117328; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f0m3laKqVZc6BVbp9FlOKUOANtvuTeySm/ZmFaYOMpk=;
        b=n5UalRm3DzsC/0my+xb5k9I1R9PZyEpCbTDNC1bx5YrZtEtKO5q+/KbK6Znrp/U0Ey
         zqZjNvs8rlHp+nHzsQm7Q8OWlKvyUulpzHWyxDMjmQqw2pW6fisg9OJCOAg3sibUls/T
         evPZ3SV1aBPGUnW8Gy3f7HIoXBHOQMdK4Ay5+Xq9YxVzFkbpnTLpUKp8KqVz7m8xepZN
         jTIwxhXA0zOaxMS94O4/nrd9y0oZQRR6Olr3TFj87hM0vaaM+x7BBnU+wysbvQeX86pI
         lOJJnRUGuq/hsJqczrzyhN6ZQhGcK/2g5OF3Hlw82emCxNRq+XPwdKWak6tI/Ctgbn9R
         Xkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774512528; x=1775117328;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f0m3laKqVZc6BVbp9FlOKUOANtvuTeySm/ZmFaYOMpk=;
        b=c+pUVq1yrViEOMr+zrIJrKgbDhw9OlU15V6e83eXfe9jeXuG0rD+XcAI7pQ0jAaCn+
         pEevHhQm9ZU4SshbhiJmzquZr8iAjxiDiOc715CRZI2LDTE56Z5nJn0djnEY2E81lqxz
         IsGGA2sq2TUX+WxI8aszPbFlF5+qv3w4mkuAZr2VEc89pGWXGGoJqAxHHD/dbfkIdyFI
         WThVOH9Uj+9CviVGcpP4xanbn8CW1/pT1dw5S5/iDPSSvCsTCdb9c0OmjDWcjTrRj5Yq
         hI4blqmsdR49akslgwXecEDyNy3qgOyyWgxPOikg1ZXqSR/FtezB+aim00ls0KEY7m8i
         ngKw==
X-Forwarded-Encrypted: i=1; AJvYcCUhGRkYBeU8P7fssPhhd+8Hvf++ysEiirHHJviTnxZZ1YBuo7IzKVSIrL0B3C23n1Y//IGiLKRVyA==@kvack.org
X-Gm-Message-State: AOJu0YzNU3oqjOjTAd610ECfQHUGC8Q4rCH1Ods4/uk1YTsguA9E7xiA
	86a68+v3WY1wSZhV77uFi4lTcCq8C01RBEwIPRETx/nWT2xrV9/olD65epX6fZ4g2aBCWKTYR3T
	hJteqMw==
X-Received: from dybvq8.prod.google.com ([2002:a05:7301:77c8:b0:2c1:da8:eab3])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:724c:b0:2ba:6f16:10cf
 with SMTP id 5a478bee46e88-2c17726234cmr295020eec.14.1774512527594; Thu, 26
 Mar 2026 01:08:47 -0700 (PDT)
Date: Thu, 26 Mar 2026 01:08:33 -0700
In-Reply-To: <20260326080836.695207-1-surenb@google.com>
Mime-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326080836.695207-4-surenb@google.com>
Subject: [PATCH v5 3/6] mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 20EE54000F
X-Stat-Signature: ucgpghyaukpzx6sqg5ghmsb3zyq3pap7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774512528-726211
X-HE-Meta: U2FsdGVkX19iP38JZA0hh470eO1c2EGuEvMbwDCZOSeQsRTJmpmfKPy7o4xnsYRtZyUwIr8CvSDOCKUfiZfXxdwR5vmVg7yDRH2AJSfwC6Idr0/Nj3b1cSwjvVs8jrVIkb4zTopmH6dLeWIYpy6z02c8TKp5wpKFbs2BIdyvPh7c0G0qXrLSxPrCVIUvIYrqQfpXDw9MW1Af1t7qF/OaopvCFkkM84l4Kj0bvZIlzAXakrGpCXnvPjpsn2NO8nXOCdH4aoA7nGU6NKvOuuxE5q8aw7DSryw3hDJWGT3vvxtu86UWgiVtNGB7xos+SVTtf4lbux89Qeq+3jMYmIC7WlmDtH5ejBbXQne/yBxD+SfUl7drUAFnv4xYArRFG5EQccdyKe9NVYmNq14on+Up2ObXIPgzoTtMOiE1CkOQDEi2Z7MOMowO6wKS6u3lLuVY40etSgnng/cia/Ixg+fzguKuMtlGZbXan6FpeF3MD2ttFqbya4h2Q6OSpMjB4exh9GQP4Nm+6yZnCczfSY5ptzH0rwLnePQaQHm15SdsvZ9MtoprqNWZq6w46VKGi9J4SegMBjFQgsusNN62WXFcoPP/f6Ke47aWVoMlFRMvbWrQqCC+lI+YwcbSuHiEF12cAaPZ7UxVVRJbrMBT02V8/tykRwp+r1xaxtQl9zCU4TOm2jnhMr6fIfwzaVb+UD/HQf42x79Rayx7Ghl9Xr2N94WPxcXm8MxAa464YPSy6HOSax+9Inice7WDiDgdBkRiVvSyFiM3qmlCDq7uONSL2vNuSH4AVpAgHvVrPNSF3NwBfY1qAa4AUbREjXUJvTHk8WwmVqK67C+D4lgFIIj6aI4v9l1JvGpBz2gX8kfP2vofo7zNpwNXdIrMlpdXwMBLb3CSkZujPF4/uekN2bMEd5DmsPRQy9O9azQA3e6VQCSx6SRwWav7IGuTTmTNd96kuP2u1fojXP4tHbtfmHQ
 RCQbCi0y
 iM0ceAFYSi1fg7LWkCv28IzzmMg/M8TNzmXhCDGhvcB6uRYX7j1gs0alkLvGJ8O9E5rfg7kzKFKg+NDDGhBxG0Zsijz67vLuVDOVkVGaGx0O/jCSYKpBM7Sz/9BM6L/EqVJc9mzZxIhiW11WEHfyDcj+MIL0GNTkgXhd6NWip//k79+W5aWrPuYUQd5bMKuPMLnYVdrKfw+/iQ0rTc/pDg5AEeN+80KZ7hB+P79F9rfCvDljXQRQP0B4GHLhmvSUsOoZEpmwoIwC5pBNpJM/bG0RIzsbTxbsI4uyJ+dBy+cPUDEWcnrCo+YOi4gtcF16O9DKAWJdqOai3PBgtokUHx5Qbyi0r77pOmf5nw3EfZKvQFkqTnRyg8ohdxT05QDP6rHkn6BqmtNynAuj7e71FwagzUG9bZJ6Ayl6xsUtF5znQUEK0TDH4/W35wy55GMmA7No5MWf20SOVg018dIqrLIgM+4jz6YgNtvRyjv97X0IYcIUdz7zogosfvWx/i7SZfT/ciMMx+5PBnbBPQ9CcmS7z16ZiaTf0WNbBywfmC0ilLDk/zj+hOnERkd9OaVJ6WNcbepgboJl0jpl7eDiDO25qOqHWhQSWaXp85C4lvp951cO9JqvI40AIFgiFtIGkfYDQoaPLLwJRjdqSgzxe7HUFzCYTQtfFg/eHD+2lIwUYA4vsuFnTerM2OfyC5HmlgiUVa5MYkVbjo0amde7fiKSH67WDJorIwSX67f+//P5Lz6tXNCCZHY9P//qj78sym1BrCijQS1hKgrmPBTCPWZ1qyrIZgJC04m0j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.
Replace vma_start_write() in collapse_huge_page().

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/khugepaged.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d06d84219e1b..a1825a4dec8b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1166,7 +1166,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		result = SCAN_FAIL;
+		goto out_up_write;
+	}
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
-- 
2.53.0.1018.g2bb0e51243-goog


