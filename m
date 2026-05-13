Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DF5CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481536B00F3; Wed, 13 May 2026 09:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459826B00F4; Wed, 13 May 2026 09:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346F36B00F5; Wed, 13 May 2026 09:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 215276B00F3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2C374011E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:01 +0000 (UTC)
X-FDA: 84762457122.29.A4F1985
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4342640006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:20:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N8Px1qWa;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8trDTW/nV8eHiIfDFU7p2YkBuzRrf5VwZ270y/B/pfU=;
	b=YoMNzlPJYV7cncx+c6ItlqDVxLg6iQsGjulT/vOYh+7d+VxTwfwE9poeliR1J5v3Yny9eb
	hAr8GzCt4HMtJOfs8UrgUP4gW4kALHWlAt8ZT71om+iEBYwTn27Svs8RpXwUUtS9LFSq7Y
	6olcU2C7fMtvDDfsTFAmoH8hkV/JLuI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N8Px1qWa;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678460; a=rsa-sha256;
	cv=none;
	b=rg/vs3ywKevl8sYKmls1Q5J5IFfubVnyO3+3/nMT8EchK0CJJ8jcVG0CkauyU+ainMFRue
	Hney/NIBPRaVeWTLxSlY7gP59ZWDraLJP2hgADeYamIC+V5j4TQa3XMN2GxVokTrWeXByd
	8HtA1nZ3H67f7rgk2HZP44G0+GMGllw=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c70e27e2b74so2768129a12.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678458; x=1779283258; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8trDTW/nV8eHiIfDFU7p2YkBuzRrf5VwZ270y/B/pfU=;
        b=N8Px1qWaZ9hwKaj0fnW5jYEI64ssXa1bP6YHH9SPnqKZt2YuqByx54kgkFa5LNuGUe
         rgHpiYbvSA/U4GruvnOivIbXKfcLAZfRVB5W3W3xFEs5Z1Bi4HqtihuxsuR1N5eDCZDY
         rpdPqX9xGg1/MPKuBHF1GVBQoyHdQrMmjhHw986fMmk4P7ltWSdq+njsPRv7qNSbGoUp
         ab3c8eoqfPu9Uzda5vt/zUdSIwmWCrKW/ahuiaqvWrto/9qcWk5l7dzrf/y9njYqctwU
         FFzWkFiJ0qCWTMl6QzkW2y6JumVHA+JATYWa/CoktHJgbocATJ2fenaps6NIR0NOnHgv
         enzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678458; x=1779283258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8trDTW/nV8eHiIfDFU7p2YkBuzRrf5VwZ270y/B/pfU=;
        b=ZX697ukBKiGcaTJmgdJZPjpYNDT8tPfSlAAFmk3X7z2n02ACc3FbgfyeJ/1G0Euy/y
         adDsOpG9RqRKz6+5TlTJUzdLaLsDJpgJHZEMnqv8DO1ibkxafexpc4W7HBafJYH5g6ag
         oAf/WrzzYFYmQdPR+CsaXMaO6zJErWbr4VxsZjoByV6qWnzz02MVEgeZ6CEPqjzG+10j
         EdJegQKxl7W78xFs/up606+sHd3VRl+eHax1hW8zr6v91zeCd8Q8PvNcbjTCX/uMEmTW
         g340C8anTFHqd3ZneOlYr2quSFr0AgGz8dfbAr+xN+sg9AIIGuRLGKd+SDZrUizJSJ2i
         SNgQ==
X-Forwarded-Encrypted: i=1; AFNElJ/zbs69nBVLUyAxtb0J7/j6pz11ARJLXZQoT+7dLvwbUkuaxZv98VEmsEeL94RShn6gdwUDKwzfaQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2cqSYbGvGEsLXijVUKCJoogPgHBLpdoYvPLcXtB9AiCkm0HVR
	DTnZmfgqY4ZXQob13KnkHY5MYXJHItGz/IWcZMrWUUoJ0YbcVlPcHtfQjZiVGp/P0Ho=
X-Gm-Gg: Acq92OEPooTs4+I+0c35dAHD4wj5e79Rd74l7j4vFVAo44u47NT9v79ZP0y2c91gC/C
	vELMqaAkj3SghvOoF0+ymgyQ9FKS8+nWQYOcfasMeLmkOJLp4kRQC1ovobkp2nPiERa0kAvB8ap
	co5/prWPd3ywxfd+55U7jvhflnE5jI6x36+P6Ul4joETSbRduuOTq1TNyXoPAudJzv6LnJadbEB
	Y4dSfbZPSS+qBFTjw2bqum5lte06XmTbOrc2abLN7EJu+h62BJ6fBMn9fWZhENreGUhdqfq5/yC
	waiil0VDWx90QZxTl6vIZ6J0ThOUjv4+Q/clIw37eUz9cmMEuqVYZKhMCNQpK5MrDH+cDoJAw9X
	t2KfyyTmRo2bY7n44EuWXF9NA4mBC5ya1HsZOg1VBUsCJfmFCJlolqc+f00K/Zh6UXfubfKo1Dc
	tVtRXT0mEGW9dD8PE440f8hgdZjckE7Ed6tYQhdX9yf1mDsSjA15DjxAdV53Fl
X-Received: by 2002:a17:90b:380e:b0:368:b01c:85a0 with SMTP id 98e67ed59e1d1-368f3e680d1mr3685120a91.14.1778678457609;
        Wed, 13 May 2026 06:20:57 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.20.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:20:56 -0700 (PDT)
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
Subject: [PATCH v2 47/69] powerpc/mm: Map shared vmemmap tail pages read-only
Date: Wed, 13 May 2026 21:20:12 +0800
Message-ID: <20260513132044.41690-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ujhg7tjautgd3xb9dcttzabpowisfkc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4342640006
X-Rspam-User: 
X-HE-Tag: 1778678458-739668
X-HE-Meta: U2FsdGVkX19kUHVXKxAC8+FokM8ebY2LHxDsfwtyLbxRB0K1CGNjTJr5kDmCdNHEnNzADffONrIXcqlbepOuaqCYNk1FhwPddAWiH9UBV48zvP3Le0MYK4q/2EEpy5o3u83liPi46zutgOhIAvAFCjMX0PT8tweKasSf2gWxQ6p83gOb0KyFY7jCTY591Wh7e5jnbC3alzAynK3lUt7TPPfMyCFAntOvJT8oFG1WL2mgn9SRRsFlEjSJeoR2YynLZHPRedcABDrDPJUq1sHeoUixIlqfESIOcoBdbG3/swOxey1JURxk27Iju6X7f2Gk4rAt3QXkWjNwhrc1kjfrS47V+dml5o34BRzXaRkgSOoDMTb2qZOIMgAwKZEkGFHEdSsU8o7BmezbICseXN6Mu6dC8I1PgF78kFiQfCugP+YJSHDBaiEQiZoA7ipeBE29PDrJSyh2iyulnUwGhrTOo+xEy/2D2ynBDEpE0Ywk+8h9RC1cidh03hhRvYp5LHDm4VmUKafhAsaAdLu1p/xInAuvMfGXeY3hCzIfeqerY/DZqAGaCmYEU5rZtENZVphwx35Ce1Dqarir4PNR7vxYh4K/yZvOcPczAStju/iTIL9VZNR9lndO/SaBNlmZlo6lIzCPdEgqHfQa8zEiqkCEtiyaZuan+OdBQOGQRCfiyHHBS7UuG0C4GvRmAX9R+lf2kIryzKAf4YQAnE0EcGMFqOR5FeGZQQNwuCkjxjRNbZB5K1FMA3LJtZswjdul9u+L/jBLGrGi+JOHGwCoS4nj9djMMJiS9VzHU7Gi40zkGM4r6l0sdkg1ifOQmqncilBIcpS3uAh1jO+Ac8+wWfcro96DVWREkVqIKUlrH4YFhlX4Wp2mBKX4+eO8BJJ9xxqqJue+2Q5b0wY0d5E1Z0jHnZFId8FTtflEfHmegPq0NaOCgTdBA06i8cvOP4cDio2ZM1m3xKA/30yNt7ZIgT6
 PzbpJINv
 cD+lEOW5VFZLwgLySmFJ5pf6O/no9RNRbjvkgjRgFQOUOVKCJtaxNyXf6lM2tNdo7Y5lXf5org9QDS0McamJ8zYKJ01lOWITYvvDxdZolbYu0fDgjRUzkXcLXN1QWQeJscgC7MCsbd1u9BjCL9rh3pLB/wX/0tNAhLNQcWvjupMK5aSidI2K28p315Q6BDtq8et06fD032dVDXogBQ6XCASTrJRWkxm0gZFq3BkxGjTXAUu/GKbJr10sy2GyIrg8Hsxc13gHky7kRsVuZVx2Sn5fehWaXtvhaFcN+dOIChgUeBDMzBKJ3HTh0+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shared vmemmap tail pages can also be installed through the powerpc
radix vmemmap populate path.

Map reused tail pages with PAGE_KERNEL_RO so writes to shared tail
vmemmap entries fault immediately instead of silently corrupting shared
metadata.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 18b24bb891b7..4c3d027c823c 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1053,7 +1053,8 @@ static pte_t * __meminit radix__vmemmap_pte_populate(pmd_t *pmdp, unsigned long
 		}
 
 		VM_BUG_ON(!PAGE_ALIGNED(addr));
-		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+		entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
+				reuse ? PAGE_KERNEL_RO : PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 		asm volatile("ptesync": : :"memory");
 	}
-- 
2.54.0


