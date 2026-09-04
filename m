Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2B8BC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 13:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8884A6B008C; Fri,  4 Sep 2026 09:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FE96B0092; Fri,  4 Sep 2026 09:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776816B0095; Fri,  4 Sep 2026 09:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6D46B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:25:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EAC680924
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:25:15 +0000 (UTC)
X-FDA: 85176150990.07.F4D5A8B
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7C18340009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:25:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NiJXlX9p;
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788528313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2CeoIWg3k0WZbamELoe7oneAzQm7kp/EWq+eOPXTPc=;
	b=Pk/MI8O2OB9tK8bSGNJ5cFEAoVqcK+2gzyU89RdiGf7Vixf6bqVfWoLRmD+RXDB4yLF9Fe
	PzVdHORCp7tG94G7t/Jo6bC+C1tiuML+HDnMXvVd8eMRy1euGbVHTiKqsJM9IGo6n4lMJ9
	RokCCdB60O7v0ZSnvcSH8M4fq8SwdUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788528313;
	b=NgfdLm/lg5p3aet9JjNdgJ7LyScQcjO0MwZ2jEY4byG9jwgR4xvEI3vV+0lnaI0n+MSWH5
	qnxpkkz5EUKOY5cvRd8pvmgjGl95sK7RjWK96gaElZ/31zF5Bp8aUM9ME2Uli8BsnVlDXo
	OlY5vZytiiHAYDl1cuwl4jnuTCLPhwM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NiJXlX9p;
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-85590c5aeabso738792b3a.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 06:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788528312; x=1789133112; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u2CeoIWg3k0WZbamELoe7oneAzQm7kp/EWq+eOPXTPc=;
        b=NiJXlX9puhTVRNUbVgzSl+cL9KE+r9VdZ/31GGPOkPSvhI/KFR5ZpcQkbAt6dD52d1
         7Mrujb1qXTfIBw88rRaCUxScwOKOL0hHOhKBwHtCzNz4Jl+zLyaPQFIv0yMyCPUYfdEz
         qEfDQVZ1vq3CStV/DJtcaKNnjE8xkyT8Y0ETBjAU+PTLeldQDNhoa/RlRxvNZw90GLMU
         yciMEVRQQTjMp96Sc05jR8McvjXgzoS6eYKZBDhudoIyJKW58yJg+wJt5WK31dA6Agf6
         nJus5aqxGLmftYwllNn+9/S6IR9Y0MK2cHRESFSje0KEpM5TFqLoq/JCqeKjDNMkxtlX
         cSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528312; x=1789133112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u2CeoIWg3k0WZbamELoe7oneAzQm7kp/EWq+eOPXTPc=;
        b=JSG3n3KAjOZE/eiJ2/ZFvEdelfLxjMbPfIvQd8EiuMDKXkXnPPPx99dE+bBjTKcSKu
         0/20F6aedh0L9Ozzptiwx3TtM2m4hUA3/fHg+UvjSoRu6zjiuKr1tPDM2t/HRaTzX6uT
         w5wE/y+hslJZKjYOTJWggLxB/wHybkbxZ23fKysKIaZXnE+FvHpMwUZ315gkKOjnNZnr
         zHSlDqE+zMX2mWid7bPP+xl80VGP0Noicud4GQqeCOPHeRi46DvGezpOfW8/13fmO34e
         QlBHIKaRXIfSouTQWvi3E6LTxClGVHUShC7A9bc0kiTAs6LIUAMPvsNbvj7/TXHoowLV
         TGzg==
X-Forwarded-Encrypted: i=1; AKwUvBxupiVlIliZntIuk1dYFlnFhOMbtfiDRlJ98tky55Wamuzg913WPfiUxAAM9ZfWdWOjy4FzCut7OA==@kvack.org
X-Gm-Message-State: AFuF++mavqkjPtV8H5NTzw9L6g4k0vk9mKUXXtUWrfxfvAlBC6D64T7o
	bgEIu4W9XjN4ILZTRZ0Viuovc/5M36zmPnYbideifoRisi3/V6/E3zvd
X-Gm-Gg: AYBFou1CQq2UvqMaHXSzILvfX1NCwSoBBW1m2ty+EH8c9bysgYKGxY7aLuYIlFvu39X
	GV/8OYDYoY6qORnn1Yught6GVMfA7+aG7iOIQKlP+tJh+1S1TcZAvuVt5gEMK/QNZRcjFilqyLq
	4RTrl3aa270WTxZBscmXNBuINkLvEBRJnI3hQTkycac7IByPoSSAhmhQv0h4Y10IkooxaDGkc2i
	VT10xzsbkwmQEoTwvKjg0M2Jz/7i4jDbQtHU6YnqYeMAg8sHEtJzdlBX7R7x92lGNuWE8jorUKa
	y2zZbMyzwFF5X3CqA5skpCE0YBnuETZ7bJqcL6dJ9KsukV/iokqTuDX+94julJBoiuO25m59lAW
	pQJ3JP0Xh1P5ngjo7u9j1eWD5omzwmyKUjC+9thMK3xyLOlAslIh/gRXDiIBg8tffWkMAtQNEV5
	1pAjIgEXWNxK5s7Oiyov4MEA2uDDE+31HQSE6wbr8/iXstJlwz+F7NOTa+C2fd14wbgst1r3p8d
	ekFDb3RAhH6fdl5VOUNrM7FmqB7krnm0SMGuQ==
X-Received: by 2002:a05:6a00:2d1d:b0:857:7317:cff8 with SMTP id d2e1a72fcca58-8616b2718f4mr7870760b3a.25.1788528311735;
        Fri, 04 Sep 2026 06:25:11 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152c2a52asm1147302b3a.30.2026.09.04.06.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 06:25:11 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/3] mm/zswap: release retired pools via queue_rcu_work() instead of synchronize_rcu()
Date: Fri,  4 Sep 2026 21:24:54 +0800
Message-ID: <f9d47f077f55e68b18ab883c9cdcd166ee950671.1788528216.git.wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788528216.git.wujianyue000@gmail.com>
References: <20260830114731.8322-1-wujianyue000@gmail.com> <cover.1788528216.git.wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: shzjz3g1e1rbdimh5b161rafr1589f91
X-Rspamd-Queue-Id: 7C18340009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788528313-908337
X-HE-Meta: U2FsdGVkX18s73QYYbaGP4fFy9/kgWZVlSC75Vx7NTLeqLcLwyu0C5cOCyu8GVN3vpI+v6DURA9n+yQ9KWJXoe2fjVLLuJ+t5mq6xL1cjHiBLuP+sRFeQ7x8LPvOeO1q6lATwLEajuk4TMUk+VACYiLVMUAhCuImJUWUh90qS0OfJtyLLgAheZuMr6izzDkqiBrE8PBixA7dnO+3zcaqaQF71zrv9XJieNWGtGrbNIVD14h02RXs3I/LaC3riU7u7/KiTjCyHRxO2IRqhWh7ae7iG0gLZL0cMmvmvEv1VM8C+8gA8beRpqD2pUfTZEsYLywg5hE2mo86QzD0nLZX6Nhb6oq5VLb6i4EkHIv+VcPleapkD7T6tTCfxx1RkF37ab1feietDDyF5ZD7ZCQh0gUQpKSlmuC1vGBiw6brWABYJF1FPfUh6Kx9pyQqQpE9K5+iRJCeHnJ0T0fVHy4J7qhkqs1YF1tnU/2BrN5W0aToo7vhmaGKZHs7V0gd4MzOMkIbKCtHLDKRXwvzKkxD1GGSIVkJAayQBZvhyPGWrOJFiTQDmNgOiOjHPfW7sixD5t6kQrNeyK5Rit27iCYE5oBYN4VPfM5cj45//jZzb3SwJ6U7+4Cklv1pnCkO03wFKIPcB5xeD+CWggfIclPjme1t+udQVH7ftbe0nAaR5FntYxpk6vNUh2AgWUV/Ma2DgRj0jwYpPTkavLH+Y9fXpzLCtsysQLbuPU1Mb0eBpoLhIrvsnb/mYrJx/jTVI/UtiQRSbScIFGT1/1dJUu1qdTgEkOktcA29K5RaZN8meX2EQFW2yi61Cq5mRgO+Xw9sDi0Pxz1qX2vLfHvHxO4OWJpsHMj5W8ok8vbHk5O69XPZGJf5zQMqgtnBvkA5LDm+Pb0bzQ1aYMORK4OEX1KopnnxtpTfTLUg06HeuxgIZD4sJPEMgSdujSZUpRAH+uuvazpoIEm3fBfPU5DRIY+
 mKinQ+tw
 E0J1lNCrnT/EX6rDrL5ty97o7jSKg8n48FhHR2a2NPK7vmy56rdPy73iHxIquJuvF33lju70ZcSBVv1QJJxehA2PERV7ZVxrBlvSHlcxdXCfMb6OjvTJZQaniJq0MwnzNM7f3NNGSg0FQZwWCgy2UlgUoJk1UatwDLJ/UBOCYPc2sbKIWJpWYgi+l24lB+2akstm3fC1KEiahumAZD3se5PVa3YDMWVm1c309ZFoO/FZ/JxpE1jO+tojmjMrEFInbtbFIRwYMslmrTn2fw13iQcXrmLaTseoSP9bw0cnZNhLFvAgiYBWPObyjxruJ3xyaoulpZIQZMwLD2E3Yzk7dnA943nCtWhrb+8/H7sA6JfDIJmpFTFpvrtV0oMf4r6tqqbak4douwOxiX12hfXycbI0gRJca7VUXdqugpsyZMNvLWwZtxtqbXq3yIz5bbSuQ5o+FxI/Ynh0XdyYw8VKVj0ZRsIaBGnFS35Phw6a/QYs5Il2ysPUp23NnTc5Vxm2X3VMO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a pool's last reference is dropped, __zswap_pool_empty() removes it
from the pool list and schedules __zswap_pool_release(), which calls
synchronize_rcu() to wait for readers before tearing the pool down.

synchronize_rcu() is a synchronous, potentially long wait.  Replace it
with queue_rcu_work(): __zswap_pool_empty() hands the pool to
queue_rcu_work(), which waits for a grace period asynchronously and then
runs __zswap_pool_release() from a worker for the sleepable teardown
(__zswap_pool_empty() can run in atomic context and must not block).
The grace-period guarantee is unchanged; the retirement path just no
longer blocks on it.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---
 mm/zswap.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f3ae3c81e48e..e456e5080531 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -155,7 +155,7 @@ struct zswap_pool {
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
-	struct work_struct release_work;
+	struct rcu_work release_rwork;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
@@ -379,10 +379,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 
 static void __zswap_pool_release(struct work_struct *work)
 {
-	struct zswap_pool *pool = container_of(work, typeof(*pool),
-						release_work);
-
-	synchronize_rcu();
+	struct zswap_pool *pool = container_of(to_rcu_work(work),
+					       typeof(*pool), release_rwork);
 
 	/* nobody should have been able to get a ref... */
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
@@ -406,8 +404,8 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
 
 	list_del_rcu(&pool->list);
 
-	INIT_WORK(&pool->release_work, __zswap_pool_release);
-	schedule_work(&pool->release_work);
+	INIT_RCU_WORK(&pool->release_rwork, __zswap_pool_release);
+	queue_rcu_work(system_percpu_wq, &pool->release_rwork);
 
 	spin_unlock_bh(&zswap_pools_lock);
 }
-- 
2.43.0


