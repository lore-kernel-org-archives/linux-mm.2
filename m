Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B6F606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=d/eiow9r
Received: by kanga.kvack.org (Postfix)
	id 39C336B00EF; Sat, 21 Nov 2026 22:12:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FED46B05B1; Sat, 21 Nov 2026 22:12:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0096B05B7; Sat, 21 Nov 2026 22:12:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF39D6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:12:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E667C0650
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:12:02 +0000 (UTC)
X-FDA: 85461280884.23.1BD6D50
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B4F7C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:11:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="d/eiow9r";
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795317120;
	b=1GXafqsVkMvRhoY6TbWlhBQENO8TvAr80Zb0uBNFQTicGWXO+3qNXa/TO1qj309BNL6p1F
	b7OyrZl4vAAI8OsYp1Qg3/zhaC7DEqATo/YiUpQxSZ7GLstJhwplNYtWDfUJIpm1ffQQjs
	VoI2cS4uquwVmx6zXDxDmLsOj/1Bx88=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795317120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IpHMT1aKbS0JPzBe96t3VbdCaL72EU/yPMiajZoaSaQ=;
	b=NqPvCfaF4KF6iJ3f5McZw1QhB8HXNDqV/YTmwzGctXQOKx4y+ZXrJ1uI7qexQbwDvXnw5C
	XXyeh2XgXoq9BGEb3vH6sA26yEEx5Kx5lJ1ChtkOOw+XH7gIo1Dc1bzuxXm+vplFRmBtf9
	9ra5Mtc54+34w8XYqm2nsQCdziLB87I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="d/eiow9r";
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso834709a12.3
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795317118; x=1795921918; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IpHMT1aKbS0JPzBe96t3VbdCaL72EU/yPMiajZoaSaQ=;
        b=d/eiow9rLVfl8Bu6OXXv8arEj4fpctgcOD77TovgrfZ2UdAsc2u+fhxtNYxjby5rUS
         0fre6Gdjvz1btiOIQJOTSeEu6Q7qWQyABt7jPQuOPdwPF347QOBvnC0VZRRIf474YJJO
         EIEtkb/MQq2oaLhZK5X+7OHamQo5Of+nNpFeSTvqU56a7WPGJ5XO/mz57Jp8PawTp5kB
         gczMa+F3dyEsVSIbG9jyfKJhZHIWOE7SbKwEzGwHb56AZ03/PCMvBzToCN85vFvqWdk1
         wCqsqMvecQenZQj7a37IdGKa4uBagd2X9LVQy1u4RxzFgPqTx5W5aylRV+sOCzsVAxys
         bNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795317118; x=1795921918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IpHMT1aKbS0JPzBe96t3VbdCaL72EU/yPMiajZoaSaQ=;
        b=JrTFLaENHs/FEfkjdestzHDF5FhFEUzGFTjYkywGDtpjj8Y77U86kh0/DsDcLrIbcL
         /dpr4dyzxwlIG9Gz6LUsr6Ez1pLmEQ255zStAzzaZvgO+sXp/kmQEWGg1HvIXJdaknSK
         f1pliHxtyGEqPlDMuh3Cwm93rguKgv3fcMDRO8ozZxTVcmhP85CBH3mOZ9aZtFCODCsa
         i27mY+OCfZJBC4lXhE/6ipFvDyZaTxPQ71LpuU65+XwkDAqh1D4vxT4vKk8SwwnDYJbl
         duV10Z4ZWMhSDXrWPN4AKBmQarOsZWBix0LDjUnn2U6zE8reV2HcCzvjJGTY0PBUfLV5
         H9Ag==
X-Forwarded-Encrypted: i=1; AL+hErHCRwlCwVThocRz5y9SQxJo/y2eD3+oHwb3C42jkWhG18/s8UFbcJrSdzbeh8Ky833Wx1GssjsNDg==@kvack.org
X-Gm-Message-State: APuU4Z/V09FY0GgsrV++3MMkFDmTv7Ky5rVqUChN8xcyIwS/fOHVr1KT
	DmhmAu/ZPRnb7q0t2CfWgSuBsC/KfQ1cNsJGkWO7UPykcx6iA/pVPfZAjx8BeW6P6sE=
X-Gm-Gg: AZFdTZe33Lw+FLgX8wzwXNIlNTQzxtFjLrNYgHZyKz4D2cNpLgJfAaopKkl33DGWMue
	ov+08Oo1kiENO4rV2kTD+IGLlkvsvxv8Hd5BGwFp0vzxTDQsF0GcSdvf2a7X0GQxUH+pSfIDghR
	lmRU6TJSXpZj0CrXx4g5HxtWDPQodyZCBJw/pm4M+tjpGbsh7GSl4w/ujSs12rhYJmBNg1Oleey
	pjwsyPxk4tjHgnTfqelyRVHe2MVZ8tZUFFS06CgXcevi9h0fDsj8OuKXyGMeQxX1I5BAAWfjhv2
	7TQvA2J3mdgOpgN1KP9K6fQs8X4IgGn6tj6lZ4LrhmNoeLIe1xT3qTWNUmCu2aTCAiwG8clPQb6
	h+C1fvrJwQGDb6BbNZo/awVRx+egRRGW3nwaTBk0xfRWfLFO0VdFnNt2nAZKRAaJaStwIu5xp7x
	bidvZXwkvZiSMao+Wp7Vb3rrvcc28SdjsMc8xILux86ROppqijhzOcfZwHvWQHP8THGxorw/N6a
	Rf09HXgsO/MLqGCxbmr9qHe0EEmQ8/xVlri5iylnjN5wW7QUv4ts5ZyOUCI2Vs4iVzK77Qed6ME
	lENEyRw+OWXB08hF+/cg/6G5RCEn6juxjOTMIwSQMxHVGyBZgbGA8oMYg5TzcXglA8rdEj8=
X-Received: by 2002:a17:90b:3e48:b0:3ac:a521:95e with SMTP id 98e67ed59e1d1-3b41c94ce48mr6842201a91.47.1795317117866;
        Sat, 21 Nov 2026 19:11:57 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ec698dsm13627149a91.14.2026.11.21.19.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 19:11:57 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] mm/list_lru: fix potential infinite loop on xa node allocation failure
Date: Sun, 22 Nov 2026 11:11:43 +0800
Message-ID: <20261122031143.3639941-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 9B4F7C0005
X-Stat-Signature: ia5y8kxpyftn3a7x4cnj7ek1ocpkcx7z
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795317119-755654
X-HE-Meta: U2FsdGVkX1//u2Jqe9c9VoNUlCOwAqfZfenQnDhYlJ9LSiwxxqrF2FyYCzV5jSgViRpEvCa9cWSBBUPIc7W22JYz4nRDAnBGyj+IJChvYt0aaDrl2jNiLpd55GYBW1c2PC4wLo6n4k2sV6TxJVxD/g3iBhF2U7Ie2Sj3iND1hY23Ky/QUhviW5Zgu4SqUz9TSuTUgEeRxG9QzesZ7yNENr/o9sy1kx5hZow39p8UXyWk49ZzHj5cqTB3c9q8a+VxUL1/66WV71Hh8WNrc12CpxtcZU3et7De2DCslwY4eMkgZasifeh9XvJNPDl4D24ITX6FACvaUC8KaL09yGWInNHXcb1NGXG51buXi3H3wUjLNNTekNLx90t1iaXb0cReRngJR/sGcr69GNPCrVcG7cFFusEhOowhjXqS/IDnc4NtJxdXkvj6fdg2pAHmpO8aBcOwTRkFmkWADXGY1fKxSEZKrUBlJy+llsyxxbihzXTHt1QbB0TsKr3cMvfepv3vSDlo2JM2E0qFORhgvzfkltFMwpyBLVFyhwjImlBXKE4B5YeYjwPJPPa7YLr8YS9s/Cd1vWImYU2EtMXi2tPmPabwO9T5wA9Cb+ROJWUsob8GC41UR8U0TDhP67PBtov/Y4hPWlVHr4SUIu3koaCuybYaXrsCC9iWNXRSdxOrlejC8EYk65NY/sHjbm1q4GEMIuALK+BFTKqErJOCpOqnrPPSkIAbIYcb3KHnpkv6wOzyCHwf0kxRPWIeQsApm5JD/0fk4T97ONaA/8RbxxhTuC+hnmmfBja1TeJyw0rH64GAbohd0IIo9YKh6YEGtrMJGLNkULZTGri8vekOlXGGx4eCHhyRolsu8tUYR8ViMmnGJk6OtAVkHGx02wf8vJmuP1BM5wNI7C+ZryZRvD8gYlxTfP9MO0ujEwLGKCRHuT/vf3lmueRFV2ziBsuE+DwXfKlZMcrCbURXH9PCwTm
 KL7XhVig
 z/Pu3V5NQD2PCzBDPYbNDVJbc5CHblaVR1igTUiraxHebl9PZHSmOU1oIjP3xv5JZltiuWgSq8o/ThDE5JD+AdyD7VK67K3tKmOInuqKPu5XLCpKdf93xRuZQRgttIRqT6FQzLfmlFgO9kdOpFMJqZDKnKlX7COPxo1+ya3r/oz1ivL+q4dzEIGvZcgqcABVjlvSMmPHGejGsroc+JfWS6GMepva2P3kailkgzO66aF2xr35mEIJsm1nxy2aHtoXkPvzbxDqTxDTUV/BUm1QFwQDg7dcG/sKxW/YAfIMz34h/gwyYJiwEKXPjssf5qj4OTJ4pG5LB7hi+9RcMjj44ZbkDZPWG51/a2tG3luUh6yD2hIQMb+XLDXeWsetm54XNousa8n6Gol5wLzjBJqbtUUS9cTKq2gi/mp2Moq4hAQnSJRNHAguueJvLFh4l3kj+BpINFiBSULv+4IYMd4ZUuIdk6K848L/8Uz7CAIfEmbwifwX16Ed0rbXGt+jvHfMZVDUjaLQKavWAo95DDKiRuYkvj7UigT52ccWtmUyXN0xaQQzIeScBMaWjQRYMu+cgtc6XNS2mtJizqcntiSqI5LboWJwVCfvyOg0Wz2UJ+SOAnTvaQCbbFCOQ2tWyhK6ni0UGFIuRXjxZXIs8GU5sAEXjANRgpUlWp7eD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__memcg_list_lru_alloc() populates missing list_lru_memcg entries
top-down, from the farthest unpopulated ancestor down to @memcg.  When
storing the entry for an ancestor (pos != memcg) needs a new xa_node,
xas_store() sets XA_ERROR(-ENOMEM) and leaves @pos unpopulated.  If the
following xas_nomem() also fails to allocate, the inner loop exits with
the error still set, but the outer loop ignores it and reruns on the same
unpopulated ancestor: xas_set() then resets the state to XAS_RESTART and
retries the store.  A one-off failure is recovered on that retry, but as
long as the allocation keeps failing, e.g. under sustained memory
pressure, the loop makes no progress and, with no schedule point, becomes
an RCU stall / hard lockup when the caller holds mapping->i_pages.xa_lock
with IRQs disabled.

Stop the outer walk when xas_error() is set so the existing cleanup frees
@mlru and the error is propagated to the caller.

Fixes: 28e98022b31e ("mm/list_lru: simplify reparenting and initial allocation")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-21c1dba9-8d6f-4368-b38b-9a57cacb056f
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/list_lru.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 651983d0bf8b..1e0ea7975acb 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -626,7 +626,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			}
 			xas_unlock_irqrestore(&xas, flags);
 		} while (xas_nomem(&xas, gfp));
-	} while (pos != memcg && !css_is_dying(&pos->css));
+	} while (pos != memcg && !css_is_dying(&pos->css) && !xas_error(&xas));
 
 	if (unlikely(mlru))
 		kfree(mlru);

base-commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27
-- 
2.54.0


