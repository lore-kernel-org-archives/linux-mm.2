Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C67CCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116E46B00C9; Tue,  2 Jun 2026 06:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A08D6B00CA; Tue,  2 Jun 2026 06:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAB26B00CB; Tue,  2 Jun 2026 06:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6ACC6B00C9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3178162C2C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:47 +0000 (UTC)
X-FDA: 84834556254.25.2888664
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id D4F39A000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Eqyk4WrU;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRWl52YiNF8NqlpcvOldJSrMkxHitZpwQxluu3UebDE=;
	b=LTqEf8DiHXY5Ut6QDPzJdNQKrRLuvc74JMB1XEe5Jx4XdvFRUp8OJRaTunrhIv3z/HOwS+
	V+wtiD62R2sP0AOlOLG0T/cCoL3+6bpaTGNrPdVS1VyMP1tYdkJDCC+7U9d1ASIpJXJES/
	OPRZEpk7C+w8ESMD4cuQ2pQTBK8iA7Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Eqyk4WrU;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395105;
	b=SuaSrl7SI+YeotlMQQ3blkTvGXuKh8VhdzSyvk4PsiMHV9Qwom9IhahODnuqbhN/ihnCrL
	YKY+LXsbdRCO5yB56FmLUa2+tFzFFkEbiQYsVWhBDPsQ1BpAVJFhxlubQkrjWfW8qUM0TK
	FP6/nQx912Cummm/DxCKnjr3f1rt9us=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-841882f8f4bso3887763b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395105; x=1780999905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRWl52YiNF8NqlpcvOldJSrMkxHitZpwQxluu3UebDE=;
        b=Eqyk4WrUudUH8E3WWQ9KBqyaRQ/gwAoT8G1hLiZyDfKeUpgPyGqRX7gkztR3S/vXVo
         4Jp9CaLHhqpnfzfJXI2EOTT5+j3CkyCVbiXDmHjy2juFzFeqZldg+IwPnC2YrtiviKvZ
         KWqnJA9wzyayzaoRjZuFioQ+IgzJ+018uWXnpUs47UkLXwD/fLOxXsSUWNiHV24uTUIA
         KtXnuK7Db5jBC4tMCyx4jWyCIybb2GcMOqAzj1klWfVSWtYIR2J/OEQatLl2vUiOp5p2
         3WCOGOL+QXy4xx2yI/0kJt2IpG2wuHE5l16Rglt5AXFazRTMA+KIWZHv/6sl3Rsfhjnp
         fAZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395105; x=1780999905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lRWl52YiNF8NqlpcvOldJSrMkxHitZpwQxluu3UebDE=;
        b=VSbIIZvIpWtN5Ly+S9+BGPQyL3gCkg0ROoAz2v1MkXkC1RPD8iRn+nbCr4Cr1yRWJH
         wyLiNrgke1IrZraQFCEa3MJgGfycBc8ZX4FX6txfFYLq/zJweRb0HWh91hERg/xNAlJG
         llyooORs6YD/HPhXagTcR/6pfAdKeFG+1gvnDugw7wslncfVQUPbIcb7jJ+drHmmMhK1
         vgsbx6KcNa3iXTCZarDb+mRifDi3OYGaCn6FG5/hP9QraqJrbUj7mihAm94OmZz4419G
         5+OUcjcI53il4fGw1P7hr63bZfjnSVFzlcpgqK0oOx/dinjbbUj6PHCog3IBXf91yTke
         RuLg==
X-Forwarded-Encrypted: i=1; AFNElJ+oOjYHjbRhdvsvgLirggsJw/3HOKhDS0jsARurfWSayHzKuBqMkNBzkfjPLbWlgfy1wcxVR650lA==@kvack.org
X-Gm-Message-State: AOJu0YzUPLcnJgot1AaA2oBGYu7DW/d6yz3sfrKrwP/uSrDiIIbW1dER
	fZQjwGY4DrN427sAJuzUf43+TrqU1eldCM70OZlqTof0QzZS0igx4QoNao5sjeZhll4=
X-Gm-Gg: Acq92OEZgHfbeIr+KSyDbVze+tGaG5hKjHc5KfjyQJ4+Fzd/KIX1lKH1Zno9WBNCjID
	wpwaeNP+ioTGJAXq2cmYVSGOdt4xf8fnzkreU42CBX7IyGA5BNCteVlLsEmvsdxgEzR2THFx4Cg
	lI6V6Hata6Xy3Id4ypPFiZWhHYTfesiz8ShF5z1ri56XZmU78WbcIleCK4VD9aF2tdWwe0h9zfM
	UvXHysatbQ6xRBmAEoyLQhky9yuxASBu++XmRY1SOS8osVPvI1S9TCB11FMsmIqjBQkp34Bn2G9
	7aC8jEsKjBjnLoadwcSxgZQb/gP2+OnlQNUwW0pN+T+Q47Ap1QBaujalG7UiywnyTqKLqVi0gzW
	ZVeGVSSGLG4GY7tpWke+qVRMXc3TuLJ05/pZ/BrbYJkJ2WZ0AwWYZI+oM8OwNY1XkhImNFnBL4H
	9oMGkC5Ne7EDER232i/3/PWxs94pkJBM+xTkIYJ4yTNYtWI51DDvPyuDNmwbv+zo3mGA==
X-Received: by 2002:a05:6a00:22ca:b0:842:4469:9202 with SMTP id d2e1a72fcca58-84244699f1bmr9235454b3a.12.1780395104666;
        Tue, 02 Jun 2026 03:11:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:44 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 10/19] mm/mm_init: Remove set_pageblock_order() call from sparse_init()
Date: Tue,  2 Jun 2026 18:10:30 +0800
Message-ID: <20260602101039.1867613-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ey5ynyapigfwkxibzuya747rurf96x1x
X-Rspamd-Queue-Id: D4F39A000F
X-HE-Tag: 1780395105-522180
X-HE-Meta: U2FsdGVkX1+vv6qzXIQXOHtdhv8OogzGSLK7ESd6OoE7bTLFDHyIiryZQplbDZncEdX/Q+mpTfck0yBOGuGr9E4b+csJZtlVAY8h0fM0NxRlx2rAYYqfbzMCEAbuXBEbs1i950/fATiRtAl+N5k0NOfDwJbuN7DMStcy8XQ3SzoeIB6svV59ZRakPdM6MzyMQfJvcz+E+yaTYP9l6TvRdpDJs7nUfWGNcA4+tBGcaD/MpJ+svOdaDaafnprZcxEuNVw5+u7KTUSZhKU6Zn0e2E6ldaWOW+OJjSA9Qe5hA2RItz5CG34R14ywwoERgef3icp85ViLahCsLtwMGytRw9XTt6L/rQLBxIexxAnIQ6Oa5ca4DlqywFRnWDeouEfdtHBK+ZcHA0gvd9Eapn+hMEGG8VWHEhNnKbhDMcAs7yJhAzKIuJNSGQguuVZpujJbmUsiH3xEZWArr1a3qfYkt+PFHVxnKM/O5MQxRw/FHZ6QjAEoTgowEerHWyqVgKMMBamtLUvb838sZ5DPTmzj1iHcb8zMyhf3LU7aWoxj7IV1sPD0jtovbnBFhfi21q8iHEY/31HG8Bxob6hEKtCdXbgm+9atFEUBAT9EGkHRTDM5Hfu5ML53actG+qQ0UVt8ZnJNnpN8gWeJbUL9EoxQKgV+es9f7rAr1m6iIFHgA41ZpbPBmBvqwQzKCG4Rndz3RiOYsQDN+BvMVq2JVf3/OWOmICwFPJCprGaB3w3fBiXQuSqxMVE4xZPQRSJTnhpPXAnm1QuTtUYmMQxhRpttT9H6KFq8BaSmDaaP/pNvqsqsK3AN2lH/jaOl6m90f3Rngobo7U64IFyNe9QFz84lLefCV3eZAmhcF7BQPq3nnHz0n5h4ZSkQEY+BYuhi+QKtY0VlQ0zzikIAiPdHQ9dAIy0r1UolBX1NMhAm3wgSMBwQ0U55MLzMTyD2RklrPsB80IpuP94NI6LN7lOJ/TF
 ndLPYSgA
 YSePJK5nHeclZLmjwd9K15qydckcyrtWM+U7OzgUJfD3s81OyBRgsccMoeqNmseTRIxw5PFR2C0tnG/Pfj5ZsTnlnZvOdE010oUIZJt5XyXlDLUNqxuEFxG8Q9Dg04IIbRjU4KZvoBIj1i3pOgAGzWN7MRxVQlpoIy3eK6/lggnwvIG4E9rskmvK5hEYaNq4jIhSWg8IxljX1Y2jA7Q6s2lYjPBlnsrfnhxBeKFl9G7cUbYKNnVn5rRNVmJkzIwTvaTmjERTzhrFpEELp+J/L6yuQ/j98xVqPrSfOzpafEaEh1KwAWeW4DIRQ3tLfMJNTIfZD9067VllMlhq5loigtqF5nGvQN7nkNO2JV+FS4htAi39EH/DbzZaIQX9pppv3PVl15A79JcZUkqi/PnIfUlJfgEeMOBPVXVBqllKzDl3TzVQ5XYYP5sdelNiWAVVbLe+xO3KFgIlIhGVlEUFCjpCNhT5ROQ+YYyOsro553VF2c49aqmmhbSueUGefT586CVA2Xoj9QnQYllM5khRUrTPVEWsl+CpDC+Gy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_area_init() already sets pageblock_order before sparse_init() runs
for CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, so sparse_init() does not need to
call set_pageblock_order() again.

With that call removed, set_pageblock_order() is only used in mm/mm_init.c.
Make it static.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
---
v2->v3:
- collect Reviewed-by from Oscar Salvador
---
 mm/internal.h | 1 -
 mm/mm_init.c  | 4 ++--
 mm/sparse.c   | 3 ---
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e71ba519f7f2..004a3f1d5006 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1435,7 +1435,6 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
-extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4601e5d659eb..44512f3b3544 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1511,7 +1511,7 @@ static inline void setup_usemap(struct zone *zone) {}
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-void __init set_pageblock_order(void)
+static void __init set_pageblock_order(void)
 {
 	unsigned int order = PAGE_BLOCK_MAX_ORDER;
 
@@ -1537,7 +1537,7 @@ void __init set_pageblock_order(void)
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-void __init set_pageblock_order(void)
+static inline void __init set_pageblock_order(void)
 {
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 85557ef387c7..324213d8bdcb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -343,9 +343,6 @@ void __init sparse_init(void)
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
-	set_pageblock_order();
-
 	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
 		int nid = sparse_early_nid(__nr_to_section(pnum_end));
 
-- 
2.54.0


