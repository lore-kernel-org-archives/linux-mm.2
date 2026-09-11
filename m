Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A8CBC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC426B0095; Fri, 11 Sep 2026 01:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436016B0098; Fri, 11 Sep 2026 01:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3740A6B0095; Fri, 11 Sep 2026 01:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B61F6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:03:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1AD61A074B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:44 +0000 (UTC)
X-FDA: 85200288768.22.AB4883C
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id C568B40006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ElCBc1SA;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ElCBc1SA;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103023;
	b=OiX/8wxcHpnLmaHBYkJcs6/na8A+GIplPo2bu18BhzIfiain32XmTnZCleG9Fc5q5GTuci
	NS0Jk9JJ+0LE0DladIE2lrWU6w0fdJqosTCXUtqCIDJ2wflzXsU6yLWbW0mtusp9gTPqDi
	GGsldbGmgDiA9GVLZXgWrxG1PNbyjdg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otJyn0+LhJb8oZRc2DA2ivaMEPoP7qIjxigOuUE5KLU=;
	b=HC2nuhJEgKzgx8hgktZrkyV40dQr7zyeSzpFmZ4saI5uoKFF+YiUY0z9ZkYAvQRItclrDg
	nY42RFSQsl4LKmpDITBqL+z4NeES5TqECmst8OJET1csIt2G7509AV0267kWUnZIclnrqs
	rnboiRcas1txi68SoWRIrul4v5uNmC4=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c96c92c0980so429856a12.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103021; x=1789707821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=otJyn0+LhJb8oZRc2DA2ivaMEPoP7qIjxigOuUE5KLU=;
        b=ElCBc1SAIbICPOnOx3B0t2OzZLuDGuZxtUdx8h+hhl9wG0BOs5Jo+9n12F+XFQBeMT
         qnqXIpahgg3ADT/Zj8km/jSDPhGYH97VRafSz8m3htOVVOkxw6aed7u48nV+NXkAVPSr
         v6V18sZTjPRf/KVfzuJFFR/QOVh/5afvlFy4l6yMmnGKB1HeP7dFGnRdnbWA5+MBfhLn
         cnG07EulfacotpLjz8qqfjS9tKhVn+P9movpZzgRw5Pv9kQAdQdFvldzpjWMsPJ5tZb4
         1sDO+AImsYRK5bpcyz2NjjE34Ldu81GS6lSleAWa4l0KmYU2dUdKOmEpn/6XHc114ykO
         FMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103021; x=1789707821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=otJyn0+LhJb8oZRc2DA2ivaMEPoP7qIjxigOuUE5KLU=;
        b=B2vyM7KnU4+5ZmnOoagyw2XBgapS0m2DhqecJo3iz7BQdOL/gbEp4qXgjdcR736PTe
         24iXwAwoBB/nLa9Qhpdhm5yrcjEh9WogErBwd4yG5zsptVVpTkYl2LPUot1K9fGUWkwz
         zn6QO3DAX3c9/c9lwl7necxCoQzcJjhM7iP9iMQqKf13jBNcYvH7NFap+N3I4WEWA4Gl
         OdlwGrBG58+EO45+tiS+brW3VUg/xmFxUgkBK8FMruS2585h37PsUgXZW27RM+IPCzCY
         sRxf8cF/t+aUIfibI39/OCIRVf1tuuPe+7D9E39rZ9DgU9hWnLxU7mdsABUrc1hMAQvd
         ljWg==
X-Gm-Message-State: AFuF++npV3bdcs7t5yFTvlpQlI0zitd5jkQTk14UeyDAHgWKUFhCc0TZ
	d6H6WcSLHlxCn4qkcpnQbUbb9eK5AHJ9v8TZKPwAZZypCqBsjYDj+1wYhcbr7t9xsaM=
X-Gm-Gg: AYBFou3mQK2EpKding/dAM1p3F2PoAiyY92AF1GDUe2PCdja8nT3AbdbbIyhirCa2Fk
	rht9VNMhfHeyD6MMR8Tl0y3F3cfwecoEAI3V3OVG129gMotU06jnpWpbb9dZQkyoV6Q33dkuxuf
	Jvay5RWIKSLUGM3h4Ix2ojf//+L0Blh+olR3kJ4/mWYuJ3vSmh97DqBdJ3guBRZWmODQFBu9fyV
	4uOmAoSDSx2gbWaei9a4jtYyzuzmdnAuoCJv0/ct865wVV3ucwaIf59WwoAlHFB59GAXr1EurrZ
	KaBPFCMzmVBXlQaHYo1ahYWT6lzYOhaleCPaZcvHOZNWu5pXIAuZ+Xm62H1gQMI/PZmJ/88D5jK
	V5BmBAUqKaHNtPHOZGNap87AYQgZ7H1mxFO/fNMn5KpcUsXdQNFGrBCvYMbIgosvS+mt7wt1Nct
	NsfM7PE+tKe5/xQ1fX6rEfj0x4mAg8L2U1TLlDlzKU9+GAOC9RfVrlGXsqDD8sG2fnw2uZA38ai
	zW7vIMBYcQBgV7ZoEoewe2xiR2iqrkBGH9ZCQ==
X-Received: by 2002:a17:90b:588d:b0:399:1f8b:d255 with SMTP id 98e67ed59e1d1-39d9bbc823fmr4102685a91.5.1789103021399;
        Thu, 10 Sep 2026 22:03:41 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.03.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:03:41 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 03/11] mm/sparse-vmemmap: open-code init_compound_tail()
Date: Fri, 11 Sep 2026 13:02:20 +0800
Message-ID: <20260911050228.58884-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C568B40006
X-Stat-Signature: tm1e7y8w1eiayp18jhcoegrw79icxkn9
X-Rspamd-Server: rspam01
X-HE-Tag: 1789103022-920603
X-HE-Meta: U2FsdGVkX1/v0ta/1TcxmxSfUFbgqeMxNK/SDk6XDBUiL2wyGThvsCt5cauEN9odxoSGfVlDmDiWhDesLO5ztVnKk9w3keqTvbzFSPPlV/EDMEW+fmV8GoBSzZlIZUdVIAb4GVNGTLl0GCZ+Jag0m2qHskncDUrxfZRV/gWzxvub4QMv4ieSecZ6WETp4jXTLqSiKy4aFMtI2yl9BPtQhCQvtLoidnUKly9dBbgO8vx2f7UDEf9K7SoZJ+sZEsvvLlPVvFKtysuVug3MCA1N9MV8qoquF9dF6GZ7wZisARin6gMyKA6nxsQe+moirsnpKti/0AgxFYnR4gKVeLS6Ns7kl3GvilBbzC2LHsh0WvIsltvBA5wZJVGGYsIbSAMbS5gqbVZqxMjY7OjamxNIerkDicfdntStWsS9iRzYzqjkN9JRjNJMEu6cWYATbZfEKfMMJkyP3CEEbjludDGRTjhW8loIiNl5g2P4c5+2cD6JFieT6leU8eEz+WAXlzuk4KFKHvMjry8wNXU/Sh96Vdya/EXPcS8LK1oMS2u8G0dj9zZwv83GW48xmPU5jT22a58P1YIJq0dQg173vtEojMq7FnbkTnfK4E2/Uw4oTsYkSJqn9+Mze0ev7MPOWDcVaiXvy+O5m0mBmNVO//XWI87qbd2Vt6espm8FUJ/Tt2/GzoKwTTu6kFfp2bny3LQKiEVqFEQ1iSxMAtSoUfWzCLNNexoPh23XQI0tRw1EdqH5EEp7wt1LLsDJ6Bt4lDKeaIsZBwELiYU7UqUGsSPSDpcD8Fde2a0J2iaXWqgX7qUYJTQD+5kqf1II8qZIDXRWuK3r1BeC7CVhPr/hVf7TIvbO3OfSLn2n28RaECf0Vh4TlYYv20TsY/MAU4Mh9BtM66nuljFVVzdpyej2EELodvJCYnQ+uFjkVqA3yMiRNdO4LRjfIreWhJTSrfSyKRG31EiiIyGQ4P3DVhTDoUF
 sjXW/l+q
 ynWuXThKtBA46K9zBe7BMqnRTFbCHssKYA46z2650c9/Gw8O5vkkNJgH6na1N2I8EmYLz8xUxmY20svthJe+8CRmkO7V1lBmVFFXHHgQGuBho1fpxqelC42CcL0nmxPDxPbmaPbZ8TaznzZX57fXT6LBVCBtOkEMnUGqkcS55s7Dx2BCNFcmY9Z2UJ8gfI1BikjOO7zsfkPr3IB3mmgIVYf261WZeAp8KUGbkxTeIkFFb4INF0AuqHLeOzf2pzCOOhsfvhEp4LzU7hD6UwJS3DSxwDRD6gVIiT+a74WkLtWS40/4uOlnvy3GqOdJaeGdLHUXj5XU0Y51GAcIAXY/WM6XiAxm4oKwXoV54l8BLSM6coTjcmc9aEoIMrVl+60yzyCUb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

init_compound_tail() is only used by vmemmap_shared_tail_page(), where
the shared tail page setup intentionally passes NULL as the compound head.

Keeping this helper in mm/internal.h exposes that special case to the rest
of the MM code and can make the NULL head argument look generally valid.
Open-code the initialization at the only call site so the special-case use
stays local to sparse vmemmap optimization.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v3:
- Collect Acked-by from David Hildenbrand

v2:
- Collect Acked-by from Qi Zheng
---
 mm/internal.h       | 9 ---------
 mm/sparse-vmemmap.c | 5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..0dca33db068f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -786,15 +786,6 @@ static inline void prep_compound_tail(struct page *tail,
 	VM_WARN_ON_ONCE(tail->private);
 }
 
-static inline void init_compound_tail(struct page *tail,
-		const struct page *head, unsigned int order, struct zone *zone)
-{
-	atomic_set(&tail->_mapcount, -1);
-	set_page_node(tail, zone_to_nid(zone));
-	set_page_zone(tail, zone_idx(zone));
-	prep_compound_tail(tail, head, order);
-}
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 7388a5b5cce3..861e09b2b096 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -189,7 +189,10 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
 		mm_zero_struct_page(page);
-		init_compound_tail(page, NULL, order, zone);
+		atomic_set(&page->_mapcount, -1);
+		set_page_node(page, zone_to_nid(zone));
+		set_page_zone(page, zone_idx(zone));
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
-- 
2.54.0


