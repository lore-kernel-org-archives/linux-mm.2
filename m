Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303EBC61DF0
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 00:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26DE6B0088; Sat, 21 Feb 2026 19:45:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4A06B0089; Sat, 21 Feb 2026 19:45:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0506B008A; Sat, 21 Feb 2026 19:45:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9186B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:45:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11C2513B331
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:45:33 +0000 (UTC)
X-FDA: 84470249346.02.E840272
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A5B340003
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:45:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vhxgkp20;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771721131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=yYGTIc7SD018JpENXhjw0YCEQOJiW9k0ZXQAJAzD2ns=;
	b=Wc840KLSfuP40sKLRwUiiaHg9eGDZgsKm/HR0dil9HIfVmw/kSyawwlwiVisNTd9kP4lhQ
	Y0QcTTqfkiSLLovIF6MmCFEoIGK2Wr0jbCHvnwNjmt2CLJ1qtuZC6q3cbzKSTEoJoqbIKJ
	O/Vt5v5iRHKWybApy5WILXCh3XcEWck=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vhxgkp20;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771721131; a=rsa-sha256;
	cv=none;
	b=kEAmZcbxaKF2+Gr9A+9QxnjMbBZ7Nlzmtl8JBTuq2AcARqqMZPX+gP4tszUZ1ms8qq57bf
	UnTv+zytFLlKmzK4eLBdaBAvF7A9iIAuM53t22shR/CSZblPGvPjDHCEUTTf5SFLM+cXU7
	nAed+HfqH2C73+MWOBNTy8M6lqBRBcs=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8fbb24a9a9so611246066b.0
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 16:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771721130; x=1772325930; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYGTIc7SD018JpENXhjw0YCEQOJiW9k0ZXQAJAzD2ns=;
        b=Vhxgkp203cc3e1Jtd+xwAtzuZk18OPiJdZokjwhgFoUoy89ZFKmr3UPJp174eosg0M
         4mmgFGSXTMVb64NNbahyqyuzjN5+t63ZkbzPfiHkp+N9tUCe+Og3ljAH/VQEbIY7ySXu
         bKgMYBO4hYF1mmWcQksGm+xtbszwOlcddb+lx0wGIOErpQ9Xl7dtXUXBmSR271lOxcyP
         QB+ecbunak5UX2EJCC5yjNg4WxeYDXxFOQfARHPH1iJ9NRToN4w7XavYJQZYJaHlSBSf
         ldVEb70q7SiEZLyqDqnHiOEH3MHJq6qv94HAKo4F5HA8Qr7PG5LPN0Af86JBwnrg8bub
         VGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771721130; x=1772325930;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yYGTIc7SD018JpENXhjw0YCEQOJiW9k0ZXQAJAzD2ns=;
        b=nDmp/9MG49ZfYNTFVbb33qWBlvihyUojAa0w9EicCTo39VnJ5lYfZEQ1o7iCa7kwcp
         4FDqKj0krgdU8oPx+PwRJzxUWKhXzjBMlMC+eJ8um95t3uNRkD5ZPI774UCrVXW8+pd2
         N3oSj50M/907cWJkj8cl0E6xb+o/2rhxtysh4p9VjuN5EZ2HKiykdpMnCAihzevjuRQW
         V77mKQhBLf0QBnZ313wmnNBvgQOk4A/5hkCfV7bO9jgt4HFmhNo+oSkxo1iyPIodIbnV
         +YyaVV8DZCnNOIN9d5D1DQWH1J2Qx7Py1iPyf//kIYb41Sk1TRCvgp92RwvjIytVrrOT
         xOow==
X-Forwarded-Encrypted: i=1; AJvYcCWeFQnNE4OhMAagQ40o6I1978JXafQtiJNKCT+6JhoP9Cn42dVsaTZReUwIgDyZjGMDvLD12oUOdg==@kvack.org
X-Gm-Message-State: AOJu0Yypci4O96cQ4hGJ83tw6S8cluD3CArD5nuH/2vT0uxEyavkmhS1
	dPC353wzWGaeDWzN3Ha0ISa+POhb1rbDQA/9n9J/PYQrg7BeiGfpZZ/C
X-Gm-Gg: AZuq6aLvi0H9lal1wD5ip2ciovkPkVNwDaVEL73z23mtIwcEouqPMWhdlTYQN73qjUg
	HwSVHz21Ts+55T45+GG6sUNh6+cV3wksOkouzlw9FMiX+JFdzrAQQFuQlCEWRD0eJ1T8Lu3S/Fx
	v5nv1fIo7NoU5uNnbGLcMgpLNETmeucF2hCxH4sSdLu/N7J1QKkTCjpvdN/vxGrqMqHTVvZmZbL
	J0Deh1wzU4wVpmDVCzPQdJZQ2io/XLzs7IxMZEdNjozvkF7qvchyLPF406gD168GLAjSvVtk6QJ
	7a+L9dTeK+zU7ND8MlHVYB7ioEOPdvFyQB6qbebEXlz6zSrsf/9Oty5uQESJh8RGVZ/cH3JZJnp
	Y1BpE4vNZs6nxdCHGRMGXQitjFKXzmhAmAK1zK4RGE4k+hqKCkHSt8SeQviAFQRynqyCiWn+FBf
	86E7iT311lKaQKLZA2yP8OgQ==
X-Received: by 2002:a17:907:1ca2:b0:b8f:e992:3fc9 with SMTP id a640c23a62f3a-b905415c02bmr661118366b.6.1771721129445;
        Sat, 21 Feb 2026 16:45:29 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c824aesm157564466b.19.2026.02.21.16.45.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Feb 2026 16:45:28 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	akpm@linux-foundation.org,
	npiggin@gmail.com,
	peterz@infradead.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH] mm/mmu_gather: define RCU version tlb_remove_table_one() in CONFIG_MMU_GATHER_RCU_TABLE_FREE
Date: Sun, 22 Feb 2026 00:45:12 +0000
Message-Id: <20260222004512.839-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: ugho6ygwurrps55nyw815ohdo5g9e9nb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A5B340003
X-Rspamd-Server: rspam01
X-HE-Tag: 1771721131-397791
X-HE-Meta: U2FsdGVkX199URhRK0LHjumWIX1wsgzZAd+pWxwXM1szCenWOYUi+IbQ347dcdeuTlu7zenDfDoaMkVFPu53J8DsQSw1O2LrUZGLafquZBE77t8C5Bekfb+cFwKwBcaaP2OICKfMvqRkre9GvbBuHGdM575Mu9qso2tmbQp2ZEOem4btl6db0cPvWp42LW+rjehuMzRP1aOYcSC28BWkqUqEHqh4nOiWXGGohMIbVXZ9RH/15aOVsMyd0xaDmCNDDMHM0agEnYbqv8OWpYa+PLp/TsoEBXaFB5YVi+l4jPsk22g7i9o8VbhMSC3azccHqPodLGyaA/7XShuHXIlHQZdx1zjegcgPkbX6hh+qynaSGPNjd3hd0MRjeSF3gXqamR6evcEDz5FoAl+g0NmmWokBKPokzAKbNb8IYmFbvmefLIaPM53EK6LgtcUfWMNJSntFaCxuHlenRtDDX4t4KwbICUcfv7AL3u3tTKqd/2Blj6Je766GfAJOZ6KJo6sKy0TmckI9DIV8rVSDaTGr+69x3afCoe2YInJEjVhAO8j6Pvq+IO66iAticEQaaCbfA7DLBO02SwUKFFhc1vF1sWV/dVm0cE3yrD8CCz7HQjEIZML3RSZRpglb4CJWUA0+5jJfjMdLLi/nLc2iv9q4TDLngJNqpQTJbZ7qPmJVHa2CZZ+GhdEvn7vcq5F3iI4ouggGxyhyc2a3W4MES7GSNtybMLPCZ4e4jiyamTPhs0Dv6tJuR+y+6HuosIp4FnofEN3V2cRIKR3E+SM35V0U84stQmtT4JgE/4VVPV43aTFMJnyr6PXo9NNZQspVpYSlEcFFJDuBLgywyFWuQhRILoVVTMp5SAug1fBAxEn8eJ6+x2KWERf029a7e7CD6Y4tDbMYGGpDKON96d3AvPeD3pLSJU4g7IclGajabth55Lk4LqsUgt1DLvuDe8HxLPkTXK8qgJFo+eF7B+VZyyT
 Smg+IQ3V
 RtwahtKTkZFjyJDEPQwyGLdzpq2UFfe5uH/0n2TSenQyERgsggtALnyAkKi0JOUvXn0J+8B72v/rEsGzg9uu1leoa+ZeSzS/Ur/iTlEWh5HLNTWf5D8PXZPKuou8f2a3wj5d0s0bEW/IfRazQYvFopKR0/Xw4Kf/OINrI4TnrhCRJgExDacVvUKmENWamOrLiBcgp5eFzpPky00hOGLyDlZVYUqwq5x6rvttlMdiO/CB30+ijYkEq90llcPU8bSWnDwLVONSfHekOTzoweBj9sleIpF1cvujFJgWJUy+DpAY/CRsUVbl9bi8pQu6K7AX/MvwTom5YouknRuFLRREsS/lvt5xW0B7PSW/+9rXHMMKUgz8DHWX8KyIhMpyOidXzwC2xdnIP9HkVf5m4t2st03FMzDjNWUHOCKeX1i92cuSLqUvoncIhTkfpoOErGrWeWdvPFfIFUrJr3UmEZ46JnP5jBnbcn0IVJd63of9HIDWHnowikQfvVHXCnJsjCvXzr0cHmCvKnNcjayNgHRBlAcZM23MS+YyU3IXHXkm+aRrIvqMO5bwS0jtt580oBeOg3fDwG7sRCOrPue6cgNfz092kydlYY/3jU+FHDW42e9ZWKcGheY7MNbSDm5jv/0x0Mf3Cx2jK2iEDgpgQZoREV21H/tN2IafOym33+NY2+TBHoxH4OSTI6YyOwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before commit 718b13861d22 ("x86: mm: free page table pages by RCU
instead of semi RCU"), the page table pages will be freed by semi RCU,
that is:

  - batch table freeing: asynchronous free by RCU
  - single table freeing: IPI + synchronous free

This commit introduce a RCU version for single table freeing to support
PT_RECLAIM. While it is not necessary to limit the RCU version only in
CONFIG_PT_RECLAIM. It is reasonable to asynchronous free single table by
RCU if CONFIG_MMU_GATHER_RCU_TABLE_FREE.

This patch moves the definition of single table freeing in
CONFIG_MMU_GATHER_RCU_TABLE_FREE, so we have both RCU version
batch/single table freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
---
 mm/mmu_gather.c | 51 +++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index fe5b6a031717..6c1cbd9c717b 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -296,6 +296,22 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 	call_rcu(&batch->rcu, tlb_remove_table_rcu);
 }
 
+static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
+{
+	struct ptdesc *ptdesc;
+
+	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
+	__tlb_remove_table(ptdesc);
+}
+
+static inline void tlb_remove_table_one(void *table)
+{
+	struct ptdesc *ptdesc;
+
+	ptdesc = table;
+	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
+}
+
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
@@ -303,6 +319,12 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 	__tlb_remove_table_free(batch);
 }
 
+static inline void tlb_remove_table_one(void *table)
+{
+	tlb_remove_table_sync_one();
+	__tlb_remove_table(table);
+}
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 /*
@@ -320,35 +342,6 @@ static inline void tlb_table_invalidate(struct mmu_gather *tlb)
 	}
 }
 
-#ifdef CONFIG_PT_RECLAIM
-static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
-{
-	struct ptdesc *ptdesc;
-
-	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
-	__tlb_remove_table(ptdesc);
-}
-
-static inline void __tlb_remove_table_one(void *table)
-{
-	struct ptdesc *ptdesc;
-
-	ptdesc = table;
-	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
-}
-#else
-static inline void __tlb_remove_table_one(void *table)
-{
-	tlb_remove_table_sync_one();
-	__tlb_remove_table(table);
-}
-#endif /* CONFIG_PT_RECLAIM */
-
-static void tlb_remove_table_one(void *table)
-{
-	__tlb_remove_table_one(table);
-}
-
 static void tlb_table_flush(struct mmu_gather *tlb)
 {
 	struct mmu_table_batch **batch = &tlb->batch;
-- 
2.34.1


