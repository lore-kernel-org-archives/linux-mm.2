Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D2D8CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5DF6B00A2; Wed, 13 May 2026 09:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD5D6B00A3; Wed, 13 May 2026 09:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3176B00A4; Wed, 13 May 2026 09:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87B426B00A2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56ACB1A08B3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:20 +0000 (UTC)
X-FDA: 84762425160.06.9AEEBD3
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 735614000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZzAgm+Z2;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYuPvzchRBegO13WUUAUtcrTx/HN+dPBsLEtJBVtJ7M=;
	b=FD15c9klDyCP/eYD/7uulVZ0vp7JPLun9MiWFILO4IQMYLDrv/fScvwlSAQEaBlj9KK73i
	lKhLeMVgx3A0zspVsGWjcTymjW6w0mRf2sh11Xlzqw/suQV8Ellr+v0IW6h5A13kpzZtbM
	x7vWZ0gAzT6ik9D+brJfewykY7gugR4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZzAgm+Z2;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677698; a=rsa-sha256;
	cv=none;
	b=qtq/5Pr29yZ0kUN7GWBN//Q6CByJ51nvzNgbp5KyZTlvLxynCcYZchinghzion+pzYiHgh
	j3KtPYeEBzDVW4liIMUAOltZ4nZ7scJv5NSreeeMsKw15xcXVBlyl1/DijAlA//tlPGZnP
	MnskkHqXHdTqKIG6w5DbmV+9Hfo7W1w=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso67439535ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677697; x=1779282497; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DYuPvzchRBegO13WUUAUtcrTx/HN+dPBsLEtJBVtJ7M=;
        b=ZzAgm+Z2YsvWYqRIFuDNJTV9+6s91IEQWc48xTG0GLmhI6m5KqpN+DUBmVowR5asea
         E7BkcCPMH1C2+VbRT9hdL97Lo/S+Z4EBRbSwZfCdR1XTioXVRETCvcVfQcr+POvfQZ7u
         JELwWHMtbaqxyGtVUGRhL99XtcsrQWyQIizYDDCsyhVJB/xR+y90f0aNtx6qfZDxeSCT
         Qc2Ju2J7xMalBRheMd1GgdJtvU5jOznUdRK9+CmvFcK25kLdEHffe6JUcnXmOlkUnrcr
         jJK5Xwt4fURZXkcA+LmeWSCpR+l1FSYzwAaLGI3jqm5aaogPVs2Xs2xylKl8x0IIDR9G
         Fr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677697; x=1779282497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DYuPvzchRBegO13WUUAUtcrTx/HN+dPBsLEtJBVtJ7M=;
        b=BXfigSrCdwunLv8octh1qS9RY6htnnKwXRGOJEKayKmW0DVXfkKtjvyF4uPJ83UjIJ
         42/Vt7DFO8OR9yH9Jrs8z9OwtTQXPGiO/QRxcVN2Pnxc9cQc3If7iBemCY90ltbS7Fzs
         qQMjWXmZQcZxzbQQpnep4fDGTxtfZ9qWs7goANwxSL8IgFTa9yh8G2wOyQqzEo/geMrf
         DXGbvmcVWBFSlcAUi6eq0Qe1p6HygKbJ+5PtVqpCGztnXzS5YNdWcJ+Eef07qMbUv7C3
         TGTwqhPTrqT9TPKwj7ivV/ZzSeBCC9XtdkQ6Ldhk9HuuzyWwC/m52qovd9V42qoU3HD+
         cgcQ==
X-Forwarded-Encrypted: i=1; AFNElJ8599n0aE7Is8NlgdvLvOiKRmqTYVStyldBM4kFs57uSl1NtGTRBQRS3RLMYGCZUjEUkOwThRng1w==@kvack.org
X-Gm-Message-State: AOJu0YwmhUAvYrBa/n6c6hHBVHqiB58ES3ICyeSfdEKwboOrep9zp6M6
	qH4S+PC4LM1962yp7oSQ512pr8UzMwPTMMnX2T54NPIWvOssCdTVzeI9Sw2nqMw5975qpsOz/1T
	RaYiqYwCFKw==
X-Gm-Gg: Acq92OHb8iyYjpSprVPA4CQYawI6T8P21EAwXC8UnaqVFqnBK13FT1RmzxtLAPw4O2I
	eBbKJYiArE7Fll2QZB+ksksOL2/k3CqL7U/9Yw8dUOT8jXlp/9sl8+qvn3yVwYDuavxAQ+Mwksa
	riOLR6lSm6eJvDOEiKwin9d6jY/rcdUy5vn5KAXFhfJaQKno/aMiov2y8X5ApMrxbV8Wt/dT51T
	u3XHaG79R8YR6xgqzzH/6v6uWucTjhMWLsWFCU1bW1Tdv471au8H7u+t2dHo9qi2Du82CMTB3Vs
	CxyFLFzspQ2ZNSIDT6wyw6oFshlwFMLL+4t5y4D/J2L3CwEa3QfG0metxhO8jjWf8WpbKaqKyXX
	O9WsUk1TWFS8HFVoVZkUVNTQaoBSiwC+w9YHAatdu3UthWDoqDVl/FUNZUDrSGlrYdivjoVv5/I
	LiPGw89Gjosw1JAbK48Jc//LcCaA1wk56Z7+VYb5o2r5+5byrG7OM45maeI7w=
X-Received: by 2002:a17:903:46c4:b0:2bd:2de3:51ad with SMTP id d9443c01a7336-2bd3043ca95mr32656455ad.34.1778677697132;
        Wed, 13 May 2026 06:08:17 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:16 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 08/69] mm/mm_init: Defer sparse_init() until after zone initialization
Date: Wed, 13 May 2026 21:04:36 +0800
Message-ID: <20260513130542.35604-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8pimfxb8ktktjj5bz9rdff55y154y3kj
X-Rspamd-Queue-Id: 735614000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778677698-810613
X-HE-Meta: U2FsdGVkX1/tO7nUn3zMcTVa7FYS3Ywfj2N9MuuKmyBxKJaZYNPZpnV7NQSo0Ogtgv89tIa+YTQEkam55MbSEAeKjqeK1Qvvojr39df3U0M/B6SRS5qWD3SBTPUk4wem2sYTkABJStXhC1dJE6ONmF6Nl8UM50zR6WeIznj0fKAQc7MYCPA4iaMBpa8uRSyC6k2fvB0qZNXVYgLLkc+nnyJ0XuUDtyCvYsJ7ML7Z1r0YalQmBmjOiFVP/lHT0cNHz7rVLLKYwoebb3W9bHEFttSwgTixwlvmvYh1clb1l+Bmlgs7d13o867W0N+v0Mu1D4uAWmcACVZCVkNiO0PUoWBR1LL0IecXXF9z/u/SvkEpod06jqH9f3Kiu/Db0phZWRuKNVqGkZ17WM4YlUkV/o90Bl4mKzt2rFpEVLHTV9xhM+oMDZPph06/v1BHTXsRpQ9vIHmP87yWFaDPf6PcOc2mSWaGtUoxasF/G6kKirZA0kOtLLnDJx8w1+lI0WUrwrxlzIF6EMB4sfLbukPpO6funBYw7brUkZSeeSfZVl0n+2cZzNm1F/wG+eh3qhdS8ZTBMrH+z3ojaS0IP7E8wi1iZicbOc4/0d0ebC6B3p8RYqZNRB6GWyS8ZbpoPKLyu9FjGgVOPeDxL+ADzt6f/bv3FZsIFD2C/QrekZOqFjHfw8ovW+Jx9grsT+jWxuMnaYTAI8go58cGijWd41WncGLa5CJlb6CMkTTApzNRwnZSG7mZnxwH4AA5efH8gT3d9tHkVqJ6i8jGDorCMftT3TWT4Dfe4+41G/Rc7DeY9KaqOyr3cIb+UpyOIP2kxZ3zb5frF4Dea3D3Yxh4RAMBZ4zE0Fq6mJEZ8JCu43U4QrOMtlS1TRPMyMNNUpy1ebw2oQih0M98/yysSNYktutQ7DdcWhF1nD9KSUViLqlNXJEbIGF5+8ywAj+GCau8VrVrIPEVS4skwi/aEk+ootk
 HYSs2YT5
 49UPdxoslvcnM+AFMoVl7jztKRibwolJllZca7rKnOvy9XOoCMBibg7ZIkOY0UAe0loxk0lyAwgz3n2bZFAGU6nFo3Y11NbBXDJ/Eyi5wTNyWKfohWWksO/pLiT0+g/LXPmqABg4xljwTNOdGGox1hWWXA5FrS/AuEo0o8uYtXq2BX98UBn4MSPqLaMRdJ54TAB+VRkP+VDYxqQ6e6cBL3nRzFx0S/tDucfrBl8cQSG1rFOwHhll3LQnZq887oqQAHe/6DsdHT7KOksbT2BiQArrf6JswQOsfEn7rrmYVjeBTlxRkzJ8i6amTQN2YeenbbuT8ab00M0qVAgTUaj5jdN9pbVfUZAsBedFkLuVzOJCjzbfKzgBjEHRelnVTfHGB+7jk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_area_init() is responsible for initializing pgdat and zone state.
Calling sparse_init() from there mixes in later vmemmap and struct page
setup, which makes the initialization flow less clear.

Defer sparse_init(), sparse_vmemmap_init_nid_late(), and memmap_init()
until after free_area_init() completes, when zone initialization is fully
done. This keeps free_area_init() focused on zone setup and ensures that
sparse_init() runs with the relevant zone state already available.

This is also a prerequisite for later hugetlb vmemmap changes that need
zone information during early sparse vmemmap setup.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v1->v2:
- Restore the set_pageblock_order() change suggested by Mike Rapoport
- Add Mike Rapoport's Reviewed-by
---
 mm/mm_init.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 12fe21c4e26c..c14491c2dad3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1826,7 +1826,6 @@ static void __init free_area_init(void)
 	bool descending;
 
 	arch_zone_limits_init(max_zone_pfn);
-	sparse_init();
 
 	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
@@ -1915,11 +1914,7 @@ static void __init free_area_init(void)
 		}
 	}
 
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
-
 	calc_nr_kernel_pages();
-	memmap_init();
 
 	/* disable hash distribution for systems with a single node */
 	fixup_hashdist();
@@ -2691,10 +2686,17 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	int nid;
+
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	free_area_init();
+
+	sparse_init();
+	for_each_node_state(nid, N_MEMORY)
+		sparse_vmemmap_init_nid_late(nid);
+	memmap_init();
 }
 
 /*
-- 
2.54.0


