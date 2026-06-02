Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3A2CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE306B00CA; Tue,  2 Jun 2026 06:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF106B00CB; Tue,  2 Jun 2026 06:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D496B00CD; Tue,  2 Jun 2026 06:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15B376B00CA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF525A0894
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:53 +0000 (UTC)
X-FDA: 84834556506.27.AEFB8C9
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 21C5E1C000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pirn9Boy;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePux0+p+Er7H/YD/Nlp/8ECZIcHxOs0LOb73zwAatVo=;
	b=vgLRvgDnR51+WhwObloSQTfRcIsdR38SaghXK183msG6MdykGXsRVZu3dvsvtTqq5xA0Rr
	Axmqpw3pabMpEdgyTAIPJ/w7UWWT1XqPaYo30gP4KXRMFgz1zkxVHYFeg2Kh/gHMim0kAt
	TOhqL/4/pFEtucK5NKVDQ7D38Vstb+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395112;
	b=afTd8Ep6TUr6yHy35a7ruLrjgehezcK7eWuAJMJq+CgwXM6pT0kSiUoFDxaj9ThO/VT77W
	9kVQXqq6/Cvw6HX3frMLidi9xpOHBihglB4kz/gUu9Ftv1MWPAtnCob0yaXxiewpNrIGW2
	bt3APUmknOataqWXAfCAyMDM3mu5Zzo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pirn9Boy;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84237c55ef9so1009409b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395111; x=1780999911; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePux0+p+Er7H/YD/Nlp/8ECZIcHxOs0LOb73zwAatVo=;
        b=Pirn9Boy3ss6nmpMlaUkRQn7Zw1QPR+kFu4FE33bIcGzlamklBCap/NXaNfXc0wYDt
         vFgHSPLmBJg4TPJdk/7ca8EWFJgEk71gHvFI9R2jvj0uzaOuQMHfZewpgWaaoBTZUeYa
         bRyXJsGq/3c/4pLzF9gxpscg0FLCtMNnt82Y1izvxDoeMnf3gurZemH6RGgR07uY4vNc
         WLT3aPQo94fic0HVWo35aYlTibkyxFZpKj/JGn0Rk1/qkyoTlREgRItImAITSePSpQP7
         qLMYKVBGq3S0YPPyGKSOKhS1IZ7k1RaPhXlEQyXwSn9AHfyZht3kceyDh+cW4OBeYcnG
         QwZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395111; x=1780999911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ePux0+p+Er7H/YD/Nlp/8ECZIcHxOs0LOb73zwAatVo=;
        b=HBBEV9kDk0F5fX+BG+8vuDVINOuOBuL1cMUyGxhKivM9Xe3us8kaB50X7/omZBy6c0
         ElE+8wdJTip3MMYZeio9dUdDcyxvKo3yEHJrifR+P5CqOPavSMwi0Gn0ytEr91Bci5mn
         S88W3lBzBNP6ijS2Ci6H+GX9/t9lTS7HKLog4lDfaTWEbasFucTOvzM59xQxH3j9QaqL
         I8nQGRf7tTc0rAy74Jb3QIQ5LiApJGb9tTSRBAahZ4hQ22BORNQUTCJ1tEhyWhI/P6T6
         FZwkJh0lPTU1kdr6uE0V0ulIFteH9q0pkuStnhzu6gPO/ylqTltXuEqGFK56Te0BImoU
         6MXA==
X-Forwarded-Encrypted: i=1; AFNElJ8083CbxA9V/p/LMlXWu+PF6rxsFO48bcwaJq5ibQCEcS1BsokG5EDwSN0byLGq7YnhrU7n9HGyfw==@kvack.org
X-Gm-Message-State: AOJu0YzlKtqj3+i6DjpZ5XYEh4tUcFqr+2icjDYKnyFrZ0w56n/ieSDU
	69w6l0Axn4MhDS9bh/tu5BrzdXg2WkQEiPzHcOpwEeqgN7l2xANSFh9WDc4JPmsB0p4=
X-Gm-Gg: Acq92OEgIXrNm2ivsIdVNKZAnaT3wvDg/MHVSaNTtKfSNaXEqNgbsOI2bJ34ILoiYvB
	xQtUgZfx7bPWgcsz9v09nF/CACgHGTN9SG3vk8zaCHUp0tY7T9l6k5AlAWanemvW4xJKtutuVVw
	4x5YIi+mix4J1ibv7/jQ8Y7gLRZCaztjQO8BLnI85ALktuc+pYGo+Htc1IWEtdhogOjbFba2Trv
	nKaPPZQPx6fjjfzQkxmXqA7wwrmAPcgsMddzcnz5E4z1VKsDjqxB1S9y36lIm+6WaG8Hm0UOyUe
	RfYv13uiN0mL8gyJr/KACAIKPtyoftijrCvuulwEoyfrgjpOb7IMGxtgKAVLGW4goQHR7xLfrre
	ZQoQBb9cI8ABub3cwA3MkdsoL3rKSfG2BkHEx98T3T9BrQi3ZnYbtOb0a0vs2v9oVk479WQ2TIF
	oSmjTUPrvPg10mTaeyJ8fGv0VEFgSCBKfGr/MWItDufMhvrazoah1jTeJ/ijF7GPI72g==
X-Received: by 2002:a05:6a00:22c5:b0:842:7d47:28bb with SMTP id d2e1a72fcca58-8427d473274mr311986b3a.47.1780395110901;
        Tue, 02 Jun 2026 03:11:50 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:50 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [PATCH v3 11/19] mm/sparse: Move sparse_vmemmap_init_nid_late() into sparse_init_nid()
Date: Tue,  2 Jun 2026 18:10:31 +0800
Message-ID: <20260602101039.1867613-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21C5E1C000A
X-Rspam-User: 
X-Stat-Signature: 7qyexwdw7xxwz5rtpfx6b8ycyipzzii6
X-Rspamd-Server: rspam08
X-HE-Tag: 1780395111-651559
X-HE-Meta: U2FsdGVkX182y9uDwUPJXc7NjnOp6FBqjNEIKe23hf2Fle7RWIfD3Lj1jZPh/rnL9NHxZ68dZskycH3/ouheBD3q2yS9/fpsvmT4yvSSk1F2MbfTh3lilArBFcfKYrbDcifr8ImYGi3yzdMWbiWX5i5cNoEbzep1Y4T6JNrEdylPObj7W9RicGArlkJwlUFoUvsGL882V4QOLmIGj/pMDVxMbO4YmZQt9wMl7WlEfQwwsn8jvdExiaOweeHptsIFDe3bdHIsJP83OVj+MzyDJthl96czsBWK1gSG+9PU6elsz0noxiAZJoCumzXG0TA3sVIzn+WqkFp3Xu47vCp826U+6L752QaUkLGn2QMMNKf2xyW8jLR7SV3oDpgRU4pwAy1sTjowBni5Gb4PFTGZPvCnZ95PnHDM5VRGTxjybG1V1bzauvbWcB4XmiBYlODL3GyVnU0ucIAmhRwvmX5zbjzFFMc/a8waZN5+Sh5ftaVDgvJY3fQvRa4L2RFl/aC49/uvtbox/FydEjym6Zoj9dNH1dbg6P/tQ+XuNzkjAU9F/p2C8WxVP9nY6wNW3wXFqqKfKheyZXVb0jp82C2HsEFDUjUGEcjwNFvqhrtHfs5htmEVVo/VWojGmRxiYGksihcPLdGX5gXzE8oPrOStMCsTDj2LRjGKf/z9kLOXxNRZbK/J5pge/nF9KaHJpgtbpMkEFu0KUc6NOv6Llun9MB4pwwafXgAyFXvvEQky9MKdtmcOPbFHjqntFaURBTaGVoUrg+26hGzwCotlrhx+vaxCTvPyXaqv6MSOQhgbWLO+1fT6/fIBCLCS1wqYze+jTj6KLa5JfytGiZ53tUC0SaKRQuo+quk7gGqamLZlwB7b4m32fOHU9zH4Hzwb+MlHR35WC8obuHQVvelNy2/z/i+ahB6Rumn0NLWqm/8prLk5LAGjRk0BVdUwIStwKlzqS0bN9c0kDZooWHtzIJa
 pMRA/tBL
 gqA7pBK1IkPS77METPL41GYsBJs4E9dqayMqoOkhbcqpDxdESqrhCZWRHHUDWlFdh2+9ZTXNlmRUpbS7M/cw2L3soSfGDQ3x9ZyC1U0xlUJ5Ar4yqJQgb+QHyB6f3rcK7fVN0QtRmoXAlIHFgSbFvMLWDbpqsECcdbDQ2RS1KdiA2SvMfzywdgZcUDC7Ultv2rU5CfzHBu5x0s/xjhS4gYcunmMpAc5tsAyTKTezq/zAKsMI0F0lDrTT13V25JE6c+INDAm6Z+THCDX3m4bsGvetbsxccM5kLKeCNlmbjHzVwsCTC/c0Lyq35TQtWFiZO8h8wEnEOnNn8U9EOCvOJE3H49swkBe7Ar20k3AscNagJtZ8w8hmnLhegND9jbJq9ymoBdyVURrk0VM7Ukymh+wIkGCV/AMTbUbYxM4zym+UELSA83uqHRC/xUs57jPF/L7dNBn341JdLIzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sparse_vmemmap_init_nid_late() is still called separately from
mm_core_init_early(), away from the rest of the sparse initialization
path.

Now that sparse_init() runs after zone initialization, call
sparse_vmemmap_init_nid_late() from sparse_init_nid() instead. This
keeps both sparse_vmemmap_init_nid_early() and
sparse_vmemmap_init_nid_late() in the sparse setup path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
---
v2->v3:
- collect Reviewed-by from Oscar Salvador
---
 mm/mm_init.c | 4 ----
 mm/sparse.c  | 1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 44512f3b3544..41b83dd18c01 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2689,16 +2689,12 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
-	int nid;
-
 	free_area_init();
 
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	sparse_init();
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
 	memmap_init();
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 324213d8bdcb..3917a47153d8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -320,6 +320,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		}
 	}
 	sparse_usage_fini();
+	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
-- 
2.54.0


