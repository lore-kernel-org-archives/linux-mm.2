Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A17FACD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E139A6B00C8; Mon, 11 May 2026 16:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEAA16B00C9; Mon, 11 May 2026 16:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28636B00CA; Mon, 11 May 2026 16:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C09286B00C8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:27:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A4991A0256
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:27:15 +0000 (UTC)
X-FDA: 84756273630.29.3D63731
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id B80A5100008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:27:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778531233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0hEFeSV+oEkVsR0+xXDDd9MkvTojg1Qfgv31AYq3BrM=;
	b=d70TKTrpYOOGYtTzb+q7hx/UurQpUXl8JlRM7fs4IHf0nHgwrBCqPV4s26+xNZq9L8YcRe
	lUYp+YHFpIQMnER+5JwxjpZctNWOugzRjAoqKM1hVNKE6aQp9D85HOrvKG4i3UCZpQdam9
	iGojTaMpxYEYr4u5CXEIwDMHJmNfCiQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778531233; a=rsa-sha256;
	cv=none;
	b=IIS3de1S7MvS6bEsLE+xdMWKZAkTtZFq7oOt2Z3ixTE+aN4H6ondvjEL+wjp2vQ9OCVdUy
	3/Y+ngKuJYVLsYcSOGj6rWrNAcZA6ZCwpwhVCbJMFje2fDD2PyJYBdghYdABa2lbPZQYKw
	mM0+EdgpclIFAW4X63XzOfBYn7tZhy4=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8A2613EC9F;
	Mon, 11 May 2026 20:27:07 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 5/8] mm: memcontrol: per-node kmem accounting for page charges
Date: Mon, 11 May 2026 22:20:40 +0200
Message-ID: <20260511202136.330358-6-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511202136.330358-1-alex@ghiti.fr>
References: <20260511202136.330358-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGZq0GkJau6RWVth2AkA6mXp5hevURRivnwJLaOUMsROukueZFeGriViT3+cCjdcQdQP0MXVJyz1fLtz5XFi7fYpUSG4G6HGJNwB7Iq+AffJ+iN70qPoWx4sPkTvS8S8edtNse4haP6xRwCWHJvcVy7zsnDElyg9ELyVKHPrzVc71knPq23qOqkwc4KIrg5BHucIt4/5JbUi95cV8eeMKs6lPZKscraThdxjN0ea9JVj3y6puOv/mj1bfUb5Bpth59ONuYJuZ08jwh3vLgdvYEWkwTPa3c1OOv3+xRvJspVD1HTOqkt57ReSG7Uxn9/R/VsgPJlS+GPzNYXtlpAG3mkYTAIM1ioE4A72moamTmDwfzMr293yA/XjueFmhG3Guvd1oXp42UY5s/EBvQlo8IklfJP7ZXgmBBHv0fuaxc5ZSR11W7sTucYe2ULX7DeyKejwLOWYWayEEbOR3QT1ndfJRC1QuZHm68xLVJfc3l1JzkqD75sInVtm6Ifr94ZC9m4m6NPREPzANNw/ZS5Ij0E23LBlB7sFal0c55SCgPUiHxPQWsvBvsA/jSKcq6ujg4d2NpSwuWRiJ+nzKI1wev02q9clqLO1A/AHyW09CrVi+89fOO3uSRKaEcMXp6kHM+LAcs10Whs9m8Q5VqbA8QeXSLwg1J+iFPI8jU33HH2jA
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B80A5100008
X-Stat-Signature: yjruswx9eo1hctnu7ontdk37bjqogkpm
X-HE-Tag: 1778531233-888498
X-HE-Meta: U2FsdGVkX1/rTlLurw91AngdEormPJeNsKQrHQUsx1lkywM3gsjt4HQroju7CFVlnNi0Oac9wRsu+h5qPoaJK0dFFU6ZuyI81plHOfd7ZvG/qH35sEpFVvAvgaYiM8utqKHi2cz7JVYvVUODajOcjnI3gXbQjFIiArRPrSgKgE2+PEQOe3aVJIiCMGtKxird5grvhxBqSy5jnE58qeqqVCtGQEwBkQOtmPWylOXsX27OtgdyhCmTO1trbz8lZiSPIR8jqvh4p8PIh2Z85PDFVUpJStmmwRifJ7jKUMP1PPHaBIvTeZYyNcvINC5OzK2jbhJFxnYuHQFrAJv+WvpbwCK1EkflyqswfJNzuygjtX75l8B3+4Wp2ZJFQcjJ5qfUmhmV1p+SBU9vO2+7DOO4f15L0sdachhjnA4Sow6oSrEIaCd9SHXOCdMnWs+emyxuuxC1imKBlezN0ADyIibUgxVRSzFo9J2f5C2PWYH5Qera1v8fE4rNylm/J58HNrBcdzoV2zXS0iIiEolosdnPMK/OqQ1R80IS6HexjTas9qp5TMQs+QetFuQSE42GvZV8tnGiqM/uupe6uwwAuZGg3wvk13Uc6Fe8iz6jWnJOZft4pk5fC3Ds0XXDzxD/IO+PNer9UtAhfmzFjIbyRN3kjpshoSzp0BTiqQxz3bHg/D9KwaDvycGzhV4H+3TYtlJ9DBhiswzRQ1ouRrVtTSJKBUaE9yemD/uYkHA24W1y/KIlAKbppb7suQu9j0mAc8nn5h7DJ3kQUO3hXj1avEhb4eF5um7LjzsyegqRw4jhxFpeOdJuy31mE+qu8myYee1G7wC1pRITjmkPXeVo3H2ihCHMoFfvhMy+02rkDfAFH6WxqRkLM7WXYUN+esnmyGUKkPQ0fuDZK9vYYKY5Eya8XmG8vYuJwGpvHoQaV6BUcppCooZXc8xleoYg/Z7UD7ErsPFRVxq0qxCL+nfDJts
 Ip3JtqT+
 87SV3jccpzO/e6EceeVeLB727dFe7mAwu9aiKdGADR5o73FZyPaoMpl9OzWRAEaqelQikYozkwEjDdgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update __memcg_kmem_charge_page() to use per-node obj_cgroup for
correct NUMA attribution of NR_KMEM.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/memcontrol.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 979a847e542a..66d2beb1c974 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3105,17 +3105,19 @@ static void page_set_objcg(struct page *page, const struct obj_cgroup *objcg)
  */
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 {
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg, *nid_objcg;
+	int nid = page_to_nid(page);
 	int ret = 0;
 
 	objcg = current_obj_cgroup();
 	if (objcg && !obj_cgroup_is_root(objcg)) {
-		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
-		if (!ret) {
-			obj_cgroup_get(objcg);
-			page_set_objcg(page, objcg);
-			return 0;
-		}
+		nid_objcg = obj_cgroup_get_nid(objcg, nid);
+		ret = obj_cgroup_charge_pages(nid_objcg, gfp, 1 << order);
+		if (ret)
+			return ret;
+		obj_cgroup_get(nid_objcg);
+		page_set_objcg(page, nid_objcg);
+		return 0;
 	}
 	return ret;
 }
-- 
2.54.0


