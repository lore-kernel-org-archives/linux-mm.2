Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAA7C982F3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 19:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221D66B0088; Fri, 16 Jan 2026 14:27:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0DC6B0089; Fri, 16 Jan 2026 14:27:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDFB6B008A; Fri, 16 Jan 2026 14:27:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F34566B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:27:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86014139E18
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:27:22 +0000 (UTC)
X-FDA: 84338810724.17.60F640F
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8AEAC0006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:27:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=grdbVDfo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768591640; a=rsa-sha256;
	cv=none;
	b=ho+orFyVs6LQhW4tUSCL3iGNkAKonzfHJGZblUti63di1BFOfL+y9yHX1I0Of/6PqZy+uP
	9zeER80iggKCaEvqroOZ/gwL9iJJ0d911dFfjlPLu4L0SDGYC/2Gn8ZmNKoqzApWwu7mkZ
	DhXWYtXl2a1Dj4QoT7w6NLn7st7OzVI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=grdbVDfo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768591640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOlQeIx1ss450mypUxbZbc6V89e6K7jSrfpMzB6xtko=;
	b=huk0ZE5/6a5WVpiPxaUA9pz9/8fQMgClN0zCU3DPQaSVz6fVTBb7ewG+5YXkB75/iSeJH8
	rbZNcITcX+3om0Twa6hVfovmfqRrbQBRzjRVBT6zTfvnnw7lw5UWD4vgxWpcXYsnyyFqQa
	xWpX7wZqccUSlfR/hFAxiRrtMeIl7gs=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78fba1a1b1eso38714337b3.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768591640; x=1769196440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOlQeIx1ss450mypUxbZbc6V89e6K7jSrfpMzB6xtko=;
        b=grdbVDfop5RLxcbFEKoGH0CsR+YHMxQWlp3viuF363rsw7mrPTbWBAbNi+uJewYJKM
         ldGja0IUA7GDDQWYP0cMetToAg4N4WcLhnLxPHAhNyq98rAa4wNNw4QDXjboDGewTGhw
         PFrdwZUNywWfEXUb2oxjLeHU/A/P515jYfI1CrCEC5u++f3DG4l00xGNfLxX76hCsycp
         OUDH5SsF3bDcbRhJBrAJ6rMVN9HI72mud6JL4iHiSBIe8D3Z45zcn4E65+gDu5h4wvIs
         dUzKfLaw+2DZVtxA7713RYcHjBrdmzoREMxeqKwdAGDz/MjWGpAcUQWbO1jKKnm4kNZy
         iVLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768591640; x=1769196440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bOlQeIx1ss450mypUxbZbc6V89e6K7jSrfpMzB6xtko=;
        b=DhXTDoqpoYlGv+uwgqMhAX3wh4Ur3KL2RpbPbtVBaQUJIt5NEEz4i+xR5kafZ/sPaT
         CWbNfTLRmedufUHuCCpenEruAOg49hjUvJuu7zbDtVksrpEOfCSxVr5nkcwD78z/hcHv
         9iYWX2IBYjBPTsOrh4/v+/KOQD0hQ43g46HDlMYmGhR0JAWYhrMzxmMmWt9dYSTKX3UV
         7F1365JnKq4wgirJ0+o5sGI0KaeUbtfSg1WIVjGNunRUQ9xfusG66U4+EQqiD1ptJgdg
         3z4/BLhRRnsJN9v1rDyVPU1ax8M/anygZqMtNJaRH2+rfXpMsLhJ+agtaVU6vY5xBbOr
         Jl4w==
X-Forwarded-Encrypted: i=1; AJvYcCUTjfxKBeS7YWqXPOIZxGAd3xZrL7N6B6oRtNW70FmQsaI+OYuQNU7KjZy1/tndTMj6CtysMPQpTw==@kvack.org
X-Gm-Message-State: AOJu0YwaFAb8e/dDURrmo6OgpiGEB3JM8MgRi39bPoQ7WTbrs+5tio4v
	S31/m5r+IZCBWf1F6VGqporn54lOx1VyvBVFjT8diRl55IPfPXMrow2Y
X-Gm-Gg: AY/fxX5rO/GVQ0eOdJrBQ64VR1Z6yvJjtBT1zKBgMNyRjoNmaTxjiFM5xbCaZGcNI2n
	fEfRysUKysNUhZ745OOXWGQJq/ksAtyiIrenr5ftCdWyO0339umQ5xs8LbML7z0lzRRYzja4pHJ
	ctnCIgsPS8xm9w+Li9uCZY/ITtkYnl3610zR0IE9GqnAbsRFVTEief0vOIqQuoeRBsGblNqjVmi
	AoyfJNiCl8HMAUWZh0+nWjhbfOun2aoKbhu4nndN74Y1y2HBARWYq1nDj4aU++Tz7ronWL/2W0f
	rrdlAI8O/i5k/nufiLU0D4FVGGnsrQ8ePxcLLKA1YPRAkG9mhx1WLJ/lvsZeb+FicePSpO0miy1
	ooNPUMG0rn/S7WV1ZRTjzBVmn30sevBRkByTupM1Gt+TmRCD5mFWWHuSgE1mRiZQxBy1OQtB8Lm
	GNh8Dx0TI8WzV1bh436LIk
X-Received: by 2002:a05:690c:620e:b0:792:8604:f0ea with SMTP id 00721157ae682-793c58b231cmr31290047b3.18.1768591639714;
        Fri, 16 Jan 2026 11:27:19 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:43::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c66f66cbsm12374977b3.13.2026.01.16.11.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 11:27:19 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 2/2] mm/hugetlb: Enforce brace style
Date: Fri, 16 Jan 2026 14:27:16 -0500
Message-ID: <20260116192717.1600049-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116192717.1600049-1-joshua.hahnjy@gmail.com>
References: <20260116192717.1600049-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8AEAC0006
X-Stat-Signature: a54crkmjotw14dmrw74zucxnsa6giea4
X-Rspam-User: 
X-HE-Tag: 1768591640-870863
X-HE-Meta: U2FsdGVkX1+vsR5u0fGyvxTS6OXqz6lzT+zJf1cyZzSxhcfMfcHYtm5nDg1/dgBjeLoTVfbw2ueJQecGQ2gUY5Xoo0RjM8HCvLSlwkYvoBhO6kV2GVqkWCo/R4vqNvBaMEhIt0VqoDu/dpL4ZL1K1OI9WnDykdCXu7Ucmb/yJKvFJf9Cn2lYbRmysXqtGcGqVQLgnfLmao4KSeCuq/OUGD4eSw6nGI7/jC0ZDySHo1lJ6GRuVINPoFyguQWHsqYVOBzArOji3FTllfTgbAY+QGXaquOtebXGo/hxaxvJsHyTflu9RkmGhBDGX+b7AdQa3tDa9w5aZZsf5lifiSTFrd1ho/hEfvg4s1GeZByK6r91HlMvc9CHy0Hc0h8nQvoBwuOHI5lIQdv31sF0sugiBnZZ9ZNI45YTsNRI2JNrjra/ixxX9j3I4cdpSMovzqqFru8lk5WHYwDESpgpmvei71FxdX4oZ25v5hMKI0hpwAt2A0OMdWl4RbZcXPrj525gUSXJA2BW2tsKhWx4NqDf9x2erb3PbETdAZDEW3KgF5rLzA2JZpf4DudJ5baO98gcoPWq/EvrDOf3qWwza0Ew0bDtd8fKiY4FtmToW0YqNNxk4otdLoxcuUtDkBSmMbKmDDifrRfi+sxo2XYLcPv9hZl6vuOwhMFNM11k0QUclDFjkFT/Igq5M9uMHoHR+Mo3ycmwYClTItlfVRkfbWyzBVlRAYYJAJ3f7L87eA3U3dNi7rbggdqyB2neAQzBaZbl5oSD58Q/APY3NxeUo4UqdeoaAMK50O83o5sLLQOZiS6XlyIZ3XWLieubbBGBSXJnyg6JJAgGtoJ1gASs1Jmkr18a3ngXs33fTnhOR0pKRzrvivUdnlzCw7p94hXndcfPFg9LD9Xgw/+8irU4fUk3Ecu/n2JyLtE8murYvrwskdtwao8wd9JZEnpleJVq+EEZVJffmnN469dZ37DAOC1
 MFlzgB4B
 bp88QcBnHv5+y1Lew00p/CSOq363v6NEsZFjdc5pT0tcKxhr+EbhRjY94Uqaz27Hbnyegi/NK/3JePtRHMC824HGbHJ13geCc5SPBYrvLAHhBv1R0/lvqQwrTzeKeSMx9V7MwHfSqJmc3ysVX1gBqvpbcFAKEHnIjHJtVN0mOJnSwdt8UiTaASm+JFcBTCpkYugz6J72phbY+vXU1vMflqmKtvm1jRiSjxPZIT55Hh3XiBrfVjntIhJvYe+4BSewLv4f1MkgnXOuYvOyaE2pRYUj8o910uef8nhwdUUGn8WSJGilxoImtAIw4j/GPKlulN/jwoHvMnU/bZGL3meQSGcKN3HWW4cR7qDPzsjeiuOjKm2C+puq9oHQnVYhMhDtRMn/hywrn6NShazKMsJBo+38/POd3rcUqPI7N8pmg09gs0OZjGkynBtIb0HO0SfzoTFFrmCgAKtkTXh+upmCBei2nK+L3+rfCRjRM5TrKnD2CMBsf3pRMy2u7WdPGxPWzdmAfC+9nR25e5iI=
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

While add it, fix the indentation for vma_end_reservation.

No functional change intended.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2:
- Remove accidental newline, noted by Andrew and David.
- Fix vma_end_reservation's indentation while at it, as suggested by
  SeongJae.

 mm/hugetlb.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2e5592c5cbb2..120ebd448b42 100644
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
@@ -2672,11 +2675,12 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				 * be consumed on a subsequent allocation.
 				 */
 				folio_set_hugetlb_restore_reserve(folio);
-		} else
+		} else {
 			/*
 			 * No reservation present, do nothing
 			 */
-			 vma_end_reservation(h, vma, address);
+			vma_end_reservation(h, vma, address);
+		}
 	}
 }
 
@@ -4711,10 +4715,12 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
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

