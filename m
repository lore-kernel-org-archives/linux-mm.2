Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE41C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1786B0095; Thu, 10 Sep 2026 13:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683AB6B0099; Thu, 10 Sep 2026 13:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A146B0095; Thu, 10 Sep 2026 13:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 262C76B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC583A5023
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:37 +0000 (UTC)
X-FDA: 85198506834.20.A33F205
Received: from mail-yx2-f6.google.com (mail-yx2-f6.google.com [74.125.224.134])
	by imf21.hostedemail.com (Postfix) with ESMTP id E65B51C000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="qWXHGRu/";
	spf=pass (imf21.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.134 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060594;
	b=47d9sRvDwajUCAjESV98e/lE2PlMQU3H9BKrBRCPjA8H9VCSQm/HeltIZ6vjV0FHANDq7I
	odKJEHK36yMcZYX5TPG0K/YJ4UNq98qUmmOVS6MMTb8wgdHms26hQGAuQGc27JBT3pTjH9
	Nb/SGt6fuIPFZJ7UvoKK0wKdE2wwLTw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="qWXHGRu/";
	spf=pass (imf21.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.134 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/4KB/W5umJ2NwhZ9AnF6tdCnGIfxiKJfL3QRGzZeTE=;
	b=iUL8iT8dXyYCISmbehqvwzLwaRmzRs0pb4SM3jsAMmGD+hUJnV7jzVIJBNzV3rcxf6QahZ
	As5v5V1K1wbd3p+gziiizLrObBQBor1qTSUWGxQVJeg2Tk8WaJIZPGAbr53YcnEdKM7sJu
	3mb3flKLXz6FdxpOvT+CQiAIxQ5IzSc=
Received: by mail-yx2-f6.google.com with SMTP id 956f58d0204a3-66e623a0149so2331388d50.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060594; x=1789665394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G/4KB/W5umJ2NwhZ9AnF6tdCnGIfxiKJfL3QRGzZeTE=;
        b=qWXHGRu/FUF12UCmzm7h48DOWuTKcPGyX59hjHA9+34eROliT49fB5CAAhP+IM4LoP
         k/sKO2Vbp1mZkSzPO34H3ZM+TFC0tYms+MZMYu/SwinNLqPCQxXCmAlp7rpOy8Og1gPU
         L4DYqCkaVkJAg4juE5KtY9NhKG6QNH2+w3Mad4X8JPV+CcKK9zhJv/u/SsQqbLIMU3S0
         K4tQw6dsMHsNz58Qt8OG1X5ZXgs2OyU4DtIuZ17m5wd7utdpEWV7ReoPgnMiXH8cJFrI
         jujqVe8eom0YtRHyrlfxnOQKzRB0EW/oB/4CO3TiJyAjwxqKDQGM4WzRg24jydmJ1aiH
         Czjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060594; x=1789665394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G/4KB/W5umJ2NwhZ9AnF6tdCnGIfxiKJfL3QRGzZeTE=;
        b=EvEsA442x2v3xnpXcONnX4IBf8qcE+XDdwQGTWUzFxTcHRWBtnJQIDymRBNABj+B7o
         av/uojYcSWd1j8il55/YVKahXNlAuw/RsEEKBujFhKua/76w+Lbi2qM9hc0AsR5leTI7
         jMatVHZUt5haeslwJRz/BM0khcv3BjftkrWk5eIBUsVIQEff3KaM8Oc0zm31SJOaHtE6
         UPjsg7n2jHSr8IvQTTQyt9ykHpBXOGY+PwW81G69fDDNIPkhmnVl+ezlN1WsPaiZ/yWt
         UlNmAGqqRAJNmLawYV51ItwzSNMVyMhx+CmUi23BBvFpAiEYEPxrWj2pIDZYnHgLutCM
         kqZw==
X-Forwarded-Encrypted: i=1; AKwUvBw3hUklLmmPh3JL2UjbnSah4+RDSgijGuQSwWdIYVc4pnX1StzWEzxcy3rFoOwRkLVCwPEDwg20Mg==@kvack.org
X-Gm-Message-State: AFuF++l3EDKldc889ASiTKi2Z9cg5HyGM30S07aN+Fw/fdAYgSyIr3qM
	63oqWVFMpDoYgQuXTzSaP2IAbrjxpEGvs0PXQBL14Z6Ord75grWJ9pA=
X-Gm-Gg: AYBFou0dosenV4koAL8Ej4Smmh1ZHVDBcFpHIh0RpQj3zd0CXf6idRT9hTcSg8gX0Nt
	S1pThuO0f2lKZN9xWujpcvYn1VHcsfzc8+qIz1JeFvzTYFdekovGgbBSimhXRsTV8/pRIIMxayh
	rbARJzyd8pKaIWimENIPP3hJ2s96OZpc/D6LJLUx/+YmA/jWgckw+Rvm9rBlkqjg7RrUUbrlnJw
	jy/hcbT1qNVcL6Yp99VPwOPJPEHTQcoN3O093GqRIyYvoUEFxlBPilR7710Z1UO6x5AEqqMV/T3
	8FBmkMHTH98fimGgACRaIYLBUzRn1U675Pi+mAs7zUVgKefAs8iXpBzXRb5zs3ShPH9BHTnB6Fu
	sNIKpndKAawFbtV8VwwnM+t+GBkDpyXOlADhmfTL78p3c98hoD3l3XO20j4z7JwpjU9S0g+Wy3U
	Nj2OTMRThSeIbCzB06PkucZmVGfzZ7gfrA0iAulx6lWTIHXiTY7CjbYq2MZCLzG725Av0E2+4d6
	EQuOGMkXVCpn2OPaF+h6irzjxuBEHl2xOTSgwiIYAT902e2HJyrk8bj3jtU
X-Received: by 2002:a05:690e:4503:10b0:66f:c1be:84c6 with SMTP id 956f58d0204a3-6712473ff01mr113462d50.52.1789060593948;
        Thu, 10 Sep 2026 10:16:33 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb48f1646sm14291862d50.9.2026.09.10.10.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:33 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: [RFC PATCH v2 3/9] mm/damon/paddr: lock the folio for the page fault primitive rmap walk
Date: Thu, 10 Sep 2026 10:16:17 -0700
Message-ID: <20260910171623.6638-4-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E65B51C000B
X-Stat-Signature: prnsw87bo6rjg6rykwmd8cwawu1wgggh
X-Rspam-User: 
X-HE-Tag: 1789060594-643874
X-HE-Meta: U2FsdGVkX1/I9FSOY2LixQs+MlP/vNPJHHQN3pvIIKf/GfGIveRwK+75LCfGW8yZvvV0jplNXiP1Zh5wQJ+LH0/PNzAT5rbwa8p7kOhWxTXkOo1ZdU4JvXr82KqzLzKluLuKx5zRVbRXznVmgDl7KtDxt31GnM2keDlABh0GXTaixOx/JppiSa3iTPv7uZQEjav7LtfJeoDDWHPc8KtDX6WGWIdJ6niSd+IjuvcKN8weQZla9g3GJUL5Cuk9rEmbNRqdDzgSUacXEIVH6RXHlYQtyIHb5Q7tCQ5aW7QgNzbPO1QIhrmnzHxm9JJYIsd4yaluIY4vWBVtlbaFeQ9JKKowe5OyaWCafFKjrwYBzVG71wTG1EERZyMRjWDLR9Iv2evuES+RzzG6GkQl6QPb3hs9Vp9rSSXLQgnq5cafpacARitN9LdX8OUgip8pUJNXONXX+CkohTJcatOzyiPc/TOWWvnTfVFa4ff54LjRu/i3e+UGcY38RfDO4LnOThBhdL+49C3VK00nfFbuRYuYHKqmL+AapCatwFM4SpzVMcXk8H959inr+qKNxJyn0jUOi9i9L7u1ntGACkupSiRIfLEXap26cym2PVFOnuIA4rsasGF5daeqz+j/BbY/hOEF1Fv/ZmkRirkRay5Zw5Ubmh99pKNTlrm/NdMvzQYs4RWnBevn5BCXaM6I472695NexG+s61ZgqsbL9VeND7/aEDbuEKfS/pc0DYztDUvktMIFWASD1ukmiNZQDSPe4UbBwDw1jFPjIrwMdSUiG9xw6Ca5+N44MYo0FzMGQxNuIt+GRLTBkNIDxJxHL2N1gprmGaw9go0phh2ZiMhTodl2NuZBUQoZDhREIHYr0qwgE3fr8RoAH+aiMdDmvNEQYluCgFq1u7ycZm/e5k90k4s6jvexxNgL3tkWvQyAuSlZo2WdE4k2CDIsAFXC1RMS353WDBh40lz6fpdlyfNmkdA
 P5yj3QT4
 QoVo15cQvC1NHxo5mzv780dXWLv3RHHNOisIElnXicYSMFjLzjJS0tDvBBpQ4flmDENj40b6tw/x6bfiEheqqdWt/2CHk0ZRrJ7vnm8uQXNy043LuIG2o1jZx2fo2HzPi/vuKFAmhFedMDjOTMJyb9AsR8PSrvuZ/cwd1hh12uCjQ7nrdMYszauf4IK6syUp8vN/KHb0QPGcvoe29TP/7EHtxjO+MoJatBXIskSGVFQJjILZJPYjscFncHELdQBvF7Yb9DQWQn22sGA6zR6YRns70eIBLT23xRoCiQ4oYiIbC0q320rAznxFHKTyA2YZ32/XoucaBK2k2d3+COGUXIEhgoeF/OvGCcxGXcKXJSzoAnplpOY371YtVbfwq39KzNWpkipJUsgGSnMrXMjToYFYLD27YH21d+IKkruxU7cjzLFqOG7z/u7hrw4tEghmUngCyaoS90+jWs1CnV1Zk5wbQSrorMhEUntEZ7cIX5zMSaH1gTRqmI1bLUorWeUEVRlbkbKG6xnQINFSlf4gQ+wP5gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

rmap_walk() requires the folio to be locked for every mapping type it
walks, and the page fault access check primitive takes the lock only for
file-backed and KSM folios, so a plain anonymous folio reaches the walk
unlocked and the walk does not install the marker.

Take the lock unconditionally, as the other reverse mapping walks in DAMON
do, and release the folio reference the lookup took on every exit path.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/paddr.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index f4fa7c231e551..5fcef3005c536 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -91,21 +91,25 @@ static void damon_pa_change_protection(unsigned long paddr)
 		.rmap_one = damon_pa_change_protection_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
-	bool need_lock;
 
 	if (!folio)
 		return;
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
-		return;
+		goto put;
 
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
-		return;
+	/*
+	 * rmap_walk() requires a locked folio for every mapping type, so the
+	 * lock is taken unconditionally, as the other reverse mapping walks in
+	 * DAMON do.
+	 */
+	if (!folio_trylock(folio))
+		goto put;
 
 	rmap_walk(folio, &rwc);
 
-	if (need_lock)
-		folio_unlock(folio);
+	folio_unlock(folio);
+put:
+	folio_put(folio);
 }
 
 static void damon_pa_prepare_access_checks_faults(struct damon_ctx *ctx)
-- 
2.43.0


