Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDA8606A331
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=bEWjZTa5
Received: by kanga.kvack.org (Postfix)
	id E5DE66B05B4; Fri, 20 Nov 2026 05:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35626B05B5; Fri, 20 Nov 2026 05:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD75B6B05B6; Fri, 20 Nov 2026 05:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A42C76B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:09:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20909C0E75
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:24 +0000 (UTC)
X-FDA: 85455075048.01.BA6A117
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8088F20008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bEWjZTa5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169362;
	b=Y2JmwWRgOElsF04wi2oU4mqfUPk+9dbxk2fvl1Yi5lrxSRr5I9ajvMQ3wxT2IzPmcXkhG5
	/9Qv/6TWyWl7oMs7AeZJvyxtanYlaOL5HVxVzPxt9ltz7113221pU9za4BRuJwDh+GKkez
	mAumJGckv6cCb/Cz+Jttqwwh8Mg8UEE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLxSkfYLhAc7bq+V5pE9s9/jugosIWK4kuSFM2AGReM=;
	b=jy0icJUGyAPatyoRvucpGRJYAqchp4RzFkZh8aCNmdBGIxHkEk/19vfJ70QfPSLfzCAtS+
	wojbC5Muh00PGDfQ0uhmgo/PGR/ZMnsnnXGEA+DvpM6gnAPl28yEiiMmiePscZcOryTZH1
	zMXHo8Zx+wIu0gbZFmMbTV73zEyrLcE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bEWjZTa5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cddc597d062so425644a12.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169359; x=1795774159; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TLxSkfYLhAc7bq+V5pE9s9/jugosIWK4kuSFM2AGReM=;
        b=bEWjZTa50p7hkayPaFLIhxax93GezxepEuexVoWI5W/rYCCKrUw6TwrFj/rGRrxxy5
         0opNO6a9YXB70dUh23nNgk35oUM4ChEHLuUPuqdLljA9NdG2s4TXespvU+KLnCMf5hDQ
         0o+f5Y42v/PT0ojOiMl6umO+BiETQRDmBN26nvgbyi6srZfIi71AHow/petpJy1Ixs56
         ppjeufqlR0c1CuNZnuwhf05s1whZUFbue3jC1CVXlb3uUg/TiofRQ0ypOSKD8/Pm1pJx
         el05dzJ4mlI5ND/cLzvykiiKxBvnXqTF8TpIu0KcYw6Spdppik88zHyWBO/d7jTDxDQJ
         8mmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169359; x=1795774159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TLxSkfYLhAc7bq+V5pE9s9/jugosIWK4kuSFM2AGReM=;
        b=1fsvkdrWXBPo5Ei7RkU2gExjzqaG6Y6DFsol+7vo1RO8FMgyqqHGBVVe1yU/mCrTwq
         p7QYjonXzjG6fJmNeywCq10Ts5lrBlxm2FvrIppADwa3mg7rR7pFpgJWijXUNVSTZqYI
         hxwk8+Uzp8mgs2Ovw9hABiKFU9Un7tk0yW92gg1Ijz2j2J3C4r7jUxNbPJy37Dw+F2Ly
         y4evrnIWg9DbrYulijLn1OnWufb6v3cC1CRIoSkE6b7ggzmjSRvyUj3F6Grlfs4grWwx
         vISNvL6YZK3p6WNj5UF3mUsMsD+DtxJ2AAkMvJLTIrxDz3IywLY9JBWgtxW6LtiDrvOD
         qH4A==
X-Forwarded-Encrypted: i=1; AL+hErHyYU1jwI6xexBNh8nGqwT2UV1WbL6NETs2Mn8qA2u6AoQmueW0sQvv3zn5jGc/aqYWl34v8RYmAA==@kvack.org
X-Gm-Message-State: APuU4Z83eLDUIApFseFFcogbwdGrmSx0iziHY54mVrHEF93vboh5Vana
	74gtFvBayKNw+MRmPibNMgGmWreq3XsZyVZMiDzNLqQQYdEvKOQY6nvkpkYCLfw4od8=
X-Gm-Gg: AZFdTZcWk6ZNw77fTNJtiCxR3ABap1sMSoxcGTg98yOuLjIiRsYbFYN/pn+SSQ2JDnL
	c0HVuUkAzMBWdpch5c1yf3uHnGS38ti+infETVtj8G7lcK9NosJp3WPYOUoZJBjvhFFRkFG83pe
	FUXMcCziXQT8k+wAELC5W3HjyD8FHTEQj+CLjG8mpSqMt17sW3lMNHjBZrSXdKPa3CNAYNTvNXN
	15lb5n7K9ehiqd0gPs0MmGIR6tpo8Fv7dTvqOwFHRe5v7UsdWWnwh/U2NST8fAofuFs7cfhNR4O
	tISLup0sZYAp7x4EJYjR8DlBiBUfn9khaNJ0JP1J+Xe2FNJ6nNsgB3JcKFBAtM6SOZZ9hS855J1
	yrrHGJNM7E6/7DdPuhbI1s0UZCZn/mwGhSyVMC+LjudhzK1B8beaRi7MkThZpT70VWHDhJxDwBj
	B6FpIhnXMB9PQsRIMyMN587NaHSkYLOzaL3zZ8naClcwDP4GGqfdoAKq6ZCmesz/b9Q3YZ22346
	0v+zU0QjBZKa1tpcB+nCZjRAVpxgiFv2CClMscuSIUT53MPqbLVFp99K0c6edMvkTO8EzvVpm7I
	Ef39glAms4ckbO+tlAnEAvYFJC2KLWItBkqMlFIffD7wstqIpfiSNxxLor7Jvt5HpJzh1Q==
X-Received: by 2002:a17:90b:278c:b0:3b3:b0e5:57ee with SMTP id 98e67ed59e1d1-3b41c97ac48mr2625681a91.54.1795169359317;
        Fri, 20 Nov 2026 02:09:19 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.09.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:09:18 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 01/11] mm/mm_init: verify zones for template-initialized pages
Date: Fri, 20 Nov 2026 18:08:46 +0800
Message-ID: <20261120100856.16929-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8088F20008
X-Stat-Signature: noyoky5spb4ticsac5mopjek945watbi
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795169360-323010
X-HE-Meta: U2FsdGVkX1/l06gTKe9Hna5TY3BNWMgQXMXRKneQ17UnW5srYDh5p2ldo7pidHsuJl6DQBjqVum4suSJ7G+v+OcE75H+7qqfki1L4xPTvh9be/XQ4i5KorwBp50J6zlhCFbam8IUR5jiZ8Z2Ye+1WPubfLr859wbFGkb8Qzz9H7+YoxZqyAnylrTxVTWzKrFbNL+gD5KB/50b5CcehjQRxPAax8vdZhiEdf0fB0VllwM4PoL50B1qtbfyD4rha87OL5vCFCCOPDLlDC06rYD62IUZ5xHq4GQRjD9S6HbSfwonkV+e4I9OCc1KiBAYwkd3AuqhGLwSGakhcvtHfodXifJVasGTpz170RfAizcjAjZBvjjnj0rRoRmHb8+tButHYXG3bZBCRZw5u7jcqSw+6mm5VBtsiyAwawqo/AFhOkI2MPxhHHd6Z+NHgfcPWw4eP9uiLf+kwP4mI1HUSpSRzYgWnpaQV4RIF44uMshJkiNIKNoA/GrGR3B3la8Io+SgZ2ELvZbqiXcH3rdpsz7iuHOp0PJSmjibjN/6YP2SHT4FP7cooNPzjUOwtRxdMVxmR9udsq0rMiy0ai/1z4ezUwjkM938eGHimYbiw3X7F5ipWFxTHd1q5BPQHdjSNnc0ndTVpX5fhPt1YgmdaEUCBEzIuX/WRnZ3Jt0GJ90sibrkwAzZnzUt3lNBDNdD4F3FOIRd7OxnTPRifnlgHSMgZQ8aLBHyNOx7fA8GJsOt7blFXzmlG9EYe9zbF603YlWVFGCuzp3TV95j10I9di6l3c6OtVskSOjoBJnaFIHshgxp0yevEXjgl3uxvd6egYVhQwXPxdoykBUBBpBFDcKxnkS5jGGC8K76ftNwbuft2FLvtIaXkuBOL4vqeOurZUgEBJ+lAVVr8fx+vwAeavk5oMfmXSMoS+TVdnpODrflrakke84BW+blU6CRQAtznds3GPzoolLGzFWxxiP40W
 V3KS3xR4
 DKaKKK+1JzETBy6yU2h629FcrF1HDcd4UanXMSUnPjAEVJW8LODaBovy9H1vLOFDHHgAI9BAtK2Cjhawdu+PydeD+KlIHYc61Jkcm+d7dIZZDFe1c6tn/yeeSc8Af/mzM3LbXu0JV/+bm4hRU7T9L1AMZ7h5JrRrk9dechMk5n+ToomvCytjJD+kecWhAfzaBDSJryAbJsEy30wJLAt8T+JIhuYB8mcvsDWovlZx7JJWNLLpQ+g5xt1UppjRx1FYGyqw01Ohi+A7xviCdB6itLKNSfM0MUStrzqf+Pjq+HiEwTNF1ohtmn7w8kFFJHNjSkgx/YdNFX3Wh4HG1Bodl1cLiEJe5NIRxi7Nz9+uh7BwQ7XJS/wEjndv8h9z7eWYY1LHSrFasDeG58NTUSWGAFYW1TWF0H+PwDri1KWv8b48B7Bb9ajeRP2H9wBqFB1Y3OQXWFKc8fyMNEItcOuFZ7Qo/B5qoeCm58KTlXHIm4ogS/qJ8FQ0aw5ygIQsr0tTMT7+EZfq4nze2uwXWmPXkaK+O3rdzs7LXaZ0SiUoHZGUySXGbo1B3aKeXEiM/GovAHT4lx2I1p428rdz2KgFHPqdreB56U3k5PH/2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Template-based ZONE_DEVICE initialization bypasses
__init_single_page(), which means copied struct pages do not run the
vmemmap zone consistency check.

Verify each destination after copying the template so the fast path gets
the same validation as regular page initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
v3:
- Retarget zone verification to
  zone_device_page_init_from_template() after integrating the helper
  series (suggested by Mike Rapoport)
- Collect Reviewed-by from Lance Yang

v2:
- Apply the zone verification in memmap_init_page_from_template().
- Collect Reviewed-by from Mike Rapoport.
---
 mm/mm_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index a9d848c92678..0129152b74d8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1082,6 +1082,7 @@ static void zone_device_page_init_from_template(struct page *page,
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
 	memcpy_nontemporal(page, template, sizeof(*page));
+	vmemmap_optimization_verify_zone(page);
 }
 
 /*
-- 
2.54.0


