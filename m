Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82F8D4660A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C896B00BF; Thu, 15 Jan 2026 13:14:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71ABB6B00C0; Thu, 15 Jan 2026 13:14:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C6B6B00C1; Thu, 15 Jan 2026 13:14:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42F4B6B00BF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:14:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 093551402DD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:14:47 +0000 (UTC)
X-FDA: 84334999014.09.79F4264
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 30884100005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:14:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MH9lMkEf;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768500885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q65R1O5X853GTQScX78GsAxTu5/S4jS/8Wdy7LtJyC0=;
	b=SdPVAFuHiQPeWu8WQeoecNwWVCFsMoV+qa36rxozv2//cgvsKK014LXm+AbT4gsegi56Ya
	KWChjOS5PZkC1a9OOypsR7ddxIrunWJ/+YSUHVWQhVabfbdbkAkizJrD0xSC96oK1xuMhJ
	vEzYVo9GlD0TvfhwChYgPTlQqJ9Iuow=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MH9lMkEf;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768500885; a=rsa-sha256;
	cv=none;
	b=HwWr0qocP7B47o+x7zx/zOo299ygjF0KwrB9YJ5LYuetgIs3H1G3HpcBp0JS7Buu2HH31s
	Y/ds6K9q2YuyHTHubJ7jvCH/CaEp4w2EpApM+ndj6mIcxAvRK+qvlOaRBh/oxxmJw3Y46f
	nax2MztSJwLzkvGowH6hqaIynQqV3bQ=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7927b3e5253so10879717b3.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768500884; x=1769105684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q65R1O5X853GTQScX78GsAxTu5/S4jS/8Wdy7LtJyC0=;
        b=MH9lMkEfF0P6qgxJuTJVwbN721i2ALYXFNgfeJc0NxpDW5OBcHCZN5HFWToF6Vzba2
         5x1Cis++idm0McPKTaqJNB2fceAF4wPoe6N/k6DuMq67zcdGED7r2tpAbCNcG+97K8Kn
         f9mtWbQ31AsmaDcLfOpEiuke/COuggigJZWoaxxsf2oHrruUzXrALHr8pXZ7AWrVWdyK
         anOcJjZd9t2s4QQbZh0llijbaYn+0vlediKQIvAWFMG+RN9S6BfRPQPjzv5LWP2d/LK4
         fZaEyNddlb8dy1oZZ4r0oLupklaaq9bHHRQN/RbIBCoykfsnLBlNo+mVYzTqPE7u4NdU
         cn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500884; x=1769105684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q65R1O5X853GTQScX78GsAxTu5/S4jS/8Wdy7LtJyC0=;
        b=S/ofQRlNGbL5NvrVNcgky2OO54tD0LbBf1EAor8tDZYEt1DovP/SXVyQ4IW/5dGecl
         jqh1pH3D9tm+djHXKxGwpRfCeXgecPKrpEjpvZquehEIQsJnuDetly4BqL/tz3xOiHVw
         pALUSIvR9wV/sxthNSGrgG3F/13NXwIayyplgEMHf/uMSPmrEU385UuU73gWoEwmyEfw
         h8hThbl68RsYdeibj5JkzK6lgAuyGbsrq7VSOXSnTAgyX5vLu+sXDNAs2LPzBZ8j8YWd
         IemdKqgdv2XaPpr93Oz1reybWLwO4bflPiXfYRE7d6OQ6MiYd4wEnEuf5ehLbCWJAOFw
         58Dw==
X-Forwarded-Encrypted: i=1; AJvYcCWp36GW5sxzn32o13Nnn/sc0gtxv0Et14rgcapIDpkGHw8xx8Oqgki1SzCKBRGE+hEcetpnosldqw==@kvack.org
X-Gm-Message-State: AOJu0YyhlvzO2EXPrdJpO+yStATP680DKeRkePGfLdq1BhTpPkYjDP+7
	vawWQiEJNLrqBshkqUFRgGoBiC+c9aE5shfUdelOk5JCwh1z/hSxYhW7LzT2Dw==
X-Gm-Gg: AY/fxX5MTX9PxgxIIaY+FZTn39HGB6yxhklM1nlQunDF55yo6TicyYqgSMeLZV9z2Qu
	p2sS7E1s5vNwjw2J7TJt0FzXkCCmJaNF4fLSfMeX/Jemc8fVDTxqLW5Wc1exIYxb9DrM9cSiyPx
	hkbwJ4y4N0rBpcYbdmqVFk2dtrglxLOQSuzc1Qy5t/QlWdQpLHvPhBRBoFBlHmY0hHZLiJWCpz5
	fD2o8O3miOQBhSvOEEI0cMbvpV3f381ZJJiE3B9mo7WyiGqJeJLPTgfN+yPjfV2cfeC4KSQT8ZX
	leSJiglT7NltfFsnPA7xlo28c2RQ48T7+J5DQ88cE+faX0Z0i88qjTp+d9C4kfaWGniYYCfU8aY
	1OIFFvZjiqopmmxBMCh4p+CeVTgShWGq9NTKubrGxJDQfhutbKEbbWIlnFUhxj4iFIG4XNmK3ks
	75TGZvwB6nlx0gqMoPnNU=
X-Received: by 2002:a05:690c:fc5:b0:787:f341:6b06 with SMTP id 00721157ae682-793c52b19a6mr5628617b3.24.1768500884230;
        Thu, 15 Jan 2026 10:14:44 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:2::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c671a9d7sm174197b3.25.2026.01.15.10.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 10:14:43 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm/hugetlb: Enforce brace style
Date: Thu, 15 Jan 2026 13:14:37 -0500
Message-ID: <20260115181438.223620-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
References: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 46msa6wftbwzq8a5fekobm5a8j1ouprf
X-Rspamd-Queue-Id: 30884100005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768500885-808376
X-HE-Meta: U2FsdGVkX19z9Sd1D562otAo7rLa2V5d6aaVdPEGH6yKgr03ZnIBlcBNRasQc4tdlBHFkj+Ff+d99M4qSw+l+yv9dzQWavJlAnMFmjubNSTFawMpj1fhE3B2NtLjnnKrUZaot1NpQeFA3Cqar1TsFTu+g38I/n+0amCFEvwp7BOW+cvtSiVZMHgHoK5Xa8gwW3lTvjZWIotQxEL8ZAkypu+hqzY6O2EnDdMtB4siXoVuHoyM+a1DHSQGdV2Z/Gg+8oxfwHPlQc7c/LwL2SDBW17a3lmYwUvnDriuWN9Cmz68F8rxtlWBHbc0dII1VBmAFWLng48nMgh4Vt02caOq7UAXrPuHy4515+E+Vm6/mJCocuahhQVfqBL96e/39fLSA8wkFGLK4QitaJl+rglzMduja1TGmP5eMTBoRipM57oq9yGEcrmoUmI8/zkyc2bPUA7jUvr/njo9jpl8td4D51wJAqraHDdNar2Sa+9S1BmZhKGIW4v7eiybwLpLZS7GVlHTVND08gE+y4t5XNwxrQQ0Q2B31Yf4Dakq27JVAtAVAsHU9zZJXMpQjxC2iPVfGa8uYfh8MqkzfxKupqC9cJycnLAWIehc8P+qN5M4wghrI8auPFhCdIxyjyieXmf+4sRvmeUkyn3WRrCsi0v1wbKM7tyAk0xBsENJQZcSQesKJpGziOTZCBcjhv+J3ozGpbhGKiRlSgiOPNljZ/QhWdIFWFciEcLCrOe0JHgEqv+MhvBJXbFsC1p+kt9ZBGUFAVkQEwjS47MQkyyzAzQe71oBw7RWHFnBb23ewqxYaO3SAJWPOW6bjKXM7FaDczmw6/MXdY8ddoJYU+6+Hci7xzj1wCOV+n7epqgiAWAOhwlTsD91bg0jqHlSVncWNwN1io/Q1L9W2GlXXR76yTZzXsBcmHR/o4y/uq7aDmFHRlJ5kViCNtWlTo2I39986u3rrudDFGRhJsxFiXL8TpJ
 Z6JYkWkS
 rQcznLkSlm8BIHI4JqcjQEwIzh3nCljFb54UGrFMMeg8Img/T7ApjPkqeTWb8mrbLlQwf1Glyre49JSameFBLYScYIbXdMSfoazcEa5AIyzyDNUqLBixL8LxdxRKn1dXWPvHIMZPEqAFOu93DvgA3wbL5bJniseSMZhErF/hpND4Bn7G+IZd2d75TxmUFqLb4yu14QNUMrBijpy/i9lX8KZHMDHbltGn2zDvK1jIcfFuXM2lYzTcTcLm4IbgSld7aoQaovEG9iMloa48ZhyJKtKSt1W4v/8PWVn7ZAh8qBpE2ikU50olfcat1A+QShIXSZfE8mF2PXnechrl7M47ouuaYphDzx5tdM20wM0eFh+slDmTNiJPo128hJcO0/B9x9aIWhWJNQOw6kAifiwjTKEBqTu3LvU1U4m9acqYpY+bu8ZRt1RKzPVqXauASI1rgAkqyZEyzrX8AegBW7HCR0JO5RAtv/CHOZ/VH1hwCJtgU5D0Ih9qZgMJmXH8xqHhm0JNh9ATFas2tsfGjyHnvrQSZOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Documentation/process/coding-style.rst explicitly notes that if only one
branch of a conditional statement is a single statement, braces should
be used in both branches. Enforce this in mm/hugetlb.c.

No functional change intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/hugetlb.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 432a5054ca1d..75f002f18365 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -578,8 +578,9 @@ hugetlb_resv_map_add(struct resv_map *map, struct list_head *rg, long from,
 		record_hugetlb_cgroup_uncharge_info(cg, h, map, nrg);
 		list_add(&nrg->link, rg);
 		coalesce_file_region(map, nrg);
-	} else
+	} else {
 		*regions_needed += 1;
+	}
 
 	return to - from;
 }
@@ -1247,8 +1248,9 @@ void hugetlb_dup_vma_private(struct vm_area_struct *vma)
 
 		if (vma_lock && vma_lock->vma != vma)
 			vma->vm_private_data = NULL;
-	} else
+	} else {
 		vma->vm_private_data = NULL;
+	}
 }
 
 /*
@@ -2076,8 +2078,9 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 				h->max_huge_pages++;
 				goto out;
 			}
-		} else
+		} else {
 			rc = 0;
+		}
 
 		update_and_free_hugetlb_folio(h, folio, false);
 		return rc;
@@ -2672,11 +2675,13 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				 * be consumed on a subsequent allocation.
 				 */
 				folio_set_hugetlb_restore_reserve(folio);
-		} else
+		} else {
 			/*
 			 * No reservation present, do nothing
 			 */
 			 vma_end_reservation(h, vma, address);
+
+		}
 	}
 }
 
@@ -4703,10 +4708,12 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 			if (vma_lock->vma != vma) {
 				vma->vm_private_data = NULL;
 				hugetlb_vma_lock_alloc(vma);
-			} else
+			} else {
 				pr_warn("HugeTLB: vma_lock already exists in %s.\n", __func__);
-		} else
+			}
+		} else {
 			hugetlb_vma_lock_alloc(vma);
+		}
 	}
 }
 
-- 
2.47.3

