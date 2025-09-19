Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D9BCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF8528003E; Fri, 19 Sep 2025 03:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60BB8E0022; Fri, 19 Sep 2025 03:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9004828003E; Fri, 19 Sep 2025 03:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 750138E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:13:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36AF2C059B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:13:00 +0000 (UTC)
X-FDA: 83905132920.09.1D0F9A9
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6A1EC180002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:12:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BJyD8ZYO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758265978; a=rsa-sha256;
	cv=none;
	b=rcSksO19/RHOhVB/N0+PaWo20yoKpgj2txYtBTlu0xEbQO1ejirLx3wl9xAjZIFC1Vt43a
	koYm0/Kh8wNzAuYwUKAu3sJt1topdIGBV7dinHsO9tEKEezHpWNPh62L5gW5JThitnovxx
	cBapu3Jk96vX37r0N5+w2fydarZVzHs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BJyD8ZYO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758265978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=SZjW+73j8njVLtMeNkLBEfq3Sa9Qpm9hYuOwKm7SCQM=;
	b=qjBQi/wTO8jqGI1I7Lfv0V/dJ9k8ihMfh5decDMYyJ/gm3I2GhijgMxUYeJI+WLZfrD/fC
	KvxUCEsVB71nbK1kXrokSRR2o/RmdHqABtVUYc2uCcPuMVKvTJkC9tvYNQSbqTCb8ENgLi
	oq9tpwYIUEvJlTQOWjL5EUfvASFQB9U=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62fa062a1abso2855881a12.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758265977; x=1758870777; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SZjW+73j8njVLtMeNkLBEfq3Sa9Qpm9hYuOwKm7SCQM=;
        b=BJyD8ZYO8cncwnLEP69DWFPy1CXTQIykY86PpE2Jg75/DZklJclOy+yVD4ts8VXYfT
         j+ikcwMOccEkD0LqBlnffZ44Bu4gNqzQoiWdo1pcX3/UeLrDS6JymRaW5ELM5D7RH56c
         RAQIp8ID3qQMhARICTSObEYiek/K+kR2o/Zr6LWj+f5PzBGmJNqFEoJhOt5d+oDRNv/g
         pIXTowIUbsc4D6MCd0u9mvx7H4nvCBtVtcQWoqI9zmrYAylQ4H2WHtGOdh5xY1duzP5J
         4Rfnb8IAQxB2f3ZcA9B5rgcPIhsspo0FMO2c5Gj0x6EPmzTdFFQzuazedrOzCz5HuUTO
         yqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758265977; x=1758870777;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SZjW+73j8njVLtMeNkLBEfq3Sa9Qpm9hYuOwKm7SCQM=;
        b=ep8J1no5Syy8u6PKjwT85Ac+bWWijjUuKPl2Dy4PrzNUwT1k+0ySJ5eaSvZwGnRV0e
         Gz9ixY+dP9TIRTdS4/AYooOQrMeXPytPNuYBZxh52BhRk8AIiWm3UBIMtNqGhF0dgZ3Z
         DdFf4LTqURH/uuoiQ/07HiNvstDMdkwyslOegzIOK5y1gV25WS4Du7bmYvSKcPpGbs3E
         Y6jJ8bqim6YflEaK5/u5P3m5mILrpL3pKUDCtqrT/v4cxM+V15BwXngWugKf9DjLSsnU
         k/04VomY16FX40PINjSj/sy8Pdj573UwCMX9HdUCyQgZV6CP2WacqatLOtvwxrhETr98
         I0XQ==
X-Gm-Message-State: AOJu0YwuVVFW98xIPGICarWro1wX9QqpZ+y+yCI5rTv9RbHtvDzW6kk+
	ARodlkJzPK3bcOQvilhw0LQKOA8okpBiqS7puUrJ4+Spy29MZces1K5y
X-Gm-Gg: ASbGncvOHuzL2BSlqVmcbocphIn7w7HwWjTXMb/HIBRc/bveGVE1mHs/Asfeqz1VdWz
	eM63X88EU2UHPJmKxxoh5gg44NkKIYEKwktw63QbY4x2poa45lCOMZpqgGiuGD2PGjI1ALEgoQ/
	xxqyy+5+VKfPfu8IhouvS/nN6CuOmJGyP11iFlvF3efE7DTUyc7O9lSqKDgFYBwiDy5nyqdlbNs
	4luEf4NGJTIibEvv+ezZOkcwprn0sNwoEeV23D6SaccpUls7rYxBm8UVg62ma1jCjRExewwzAMz
	0tJKX6pSDGF68ufqX9OYmCEZIfcNf1jNnirhVKtCAyIPvtWgExf24Xwrxy8L5jWGxgUTZ73WI1h
	6t/BXkCYLus0ix464UjnfWw==
X-Google-Smtp-Source: AGHT+IEHvlJOVhL8qFr5U0LROvEIW3vWv1cf35PTM79si5/i7f6QNY7vkC9QJnDyMlRS9ad05a59mQ==
X-Received: by 2002:a17:907:c14:b0:b10:ecc6:5da3 with SMTP id a640c23a62f3a-b24f596d46cmr232247066b.63.1758265976494;
        Fri, 19 Sep 2025 00:12:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fcfe88e79sm361800366b.55.2025.09.19.00.12.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Sep 2025 00:12:56 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: [Patch v2 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
Date: Fri, 19 Sep 2025 07:12:43 +0000
Message-Id: <20250919071244.17020-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250919071244.17020-1-richard.weiyang@gmail.com>
References: <20250919071244.17020-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A1EC180002
X-Stat-Signature: dn7gnggycr7zospet8w9cqzi51ueemmb
X-Rspam-User: 
X-HE-Tag: 1758265978-522152
X-HE-Meta: U2FsdGVkX18pxNbsgVUCUmazXWI1SpFAWsBFdDvBJoOJoKuIeHko4rXvc9EBPthdRPO02iDs4acbnKxSlfyoNbPVu7jZ8v8lSYogWCrkWch3YXWfH/lPqQsBsDSt5pmo+vk1Gr0W1AitSxXB5RN5a4X3MFueLj5M5TDLEUtm3iuGE7fDhhhhjhk2r/Fmz6R6+vnM5LDOEo+mIKmn1mrQeSzC6JavbzL4olae7U6oSqglfPYSc5rllwPnmK3k7jGK10UXRjkd+iBtT3w5htzTfP8gqQztywR20i5eVHL1tjjPasnK5q9FVfcOOgvIFwiWyWT1Rz5fIbh2k7YMRnm3ydCLpLDGDY/2w648tkr3eGT2c8rY3LuR+YRRRoZ0ypvPLR2YVTnDndBgTh/ELLwkYm2rWfEwdgn0TJKtv3VkKI6wns0Y6lGQlHOLn275j3alRWD0E7h5tymZl7lAXOA4F/SYig34ymEQa5Z9qiJNC1w3f8drfE0OKUS7YKmKc5/SsPn49Unbv4EnoNXJNFqyoorMZHEOquI23MHLBZRg/uLVrrL5ylQgBgb0CVS8rT5X6g994/q0Eoz6zfoE4h8G2vTNohET7qqcmpIUeG76KJH8vw1nIr2Jst4HyB+g1PgpjDVfOrxyOXwUfQbGMX3w6m/9sb3w7CJU6gcWeI/sibmibDcNqKk3kf16PW+zf9pPvfQX6pGFdRakOVXT+SlhYRRKCfG8FR7hIRf44XxwXe5+dD/aDE5TOhNjw47xbk0eeOGvKQq5nygfhFl8esMbQx9vhoZJfaJH8UDlZkxgAif9Q+BXKvy2iDz3nNFCk9/fPEFNacLB/R++Z7ZjQwoYZm40VN1JEQfLzIXWKZ3PEUEHJljE+5doalhoKgpBgDf/zMpZmGhYUYv8qxBT7LLwIEJjVlHxZaH0KPaVJymhHC0yVYCTPrBq0hrjA0bHzX2UYirx9NvJIxioJkN7/fJ
 I/wG+YHa
 mNP+3U/gujCyjPfngOG6w5n0ymXEmFQB7GMuQZou+OJXs7VZbIWmzBwXnhwfQaUkMqJ6TATzIClXOd05QEhbu3Ah7U/UevGyaAOBdZQ8Phcj5dvdra5CoI69aqmtolrWEZ0dry5peQydggQH60qBlatn6aDiBLEs/RmXZ15lsDLcA/tFooSSEy88COw4tdaQJJnHDt0rWqaI1SO8H1OkQXfEBQod4rpFHdV+yF1Ht23lKrrvKCQMqbEeY5s0zufWILS9lSykph6PTxXzXI9DhP11QH6YdYQgSB0jtgHkywKUduBU+K8d4PmyN4jqtd9gCtxdNqf4ZTl+d+4jyJeaTwlMZ5NbvhwN4zaLEbyYTAsJauiTuC/JUKafGSROhD8E9m/Si0+8kyIQDrOLnskA6fpVVvPNK704nVHHaL+zs7mqSamNYUhg2ItGjjgmJF839SIZw6iJTFEx7iHcVspS8l3PzlFZMf/cNvqsB+fz6LJ31q+6JP4cyt4wzuuDgcpa5UBbDNCl7QApfCX2FeBbN+yVOIJWRnAM6t5eg2D7GyYxEf8pscdxgm6iColjJDgPEcGYzeSdArJpt7wMGqDkLA45HtTMEK4pW60/vMSGyvkW9nkHpZKB6aMB5FMABmF7Jb2Hv09kozIiVcHZoQ8qPd4LL+Wmra0hdWRcIAZ+WHyeeplASNSMTVl1T8fvG4vSybZcg4ANqy6y9vzI9tui1JtA3n6p+V9tikiQWjxl5JSoHAHK2WTP5r0YJeG84hS8BiRL0az4htX4uwVApJNeD7dtJcBWF73jvjUKm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using mm_slot in ksm, there is code snip like:

     slot = mm_slot_lookup(mm_slots_hash, mm);
     mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
     if (mm_slot && ..) {
     }

The mm_slot_entry() won't return a valid value if slot is NULL
generally. But currently it works since slot is the first element of
struct ksm_mm_slot.

To reduce the ambiguity and make it robust, access mm_slot_entry() when
slot is !NULL.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu.xin16@zte.com.cn

---
v2:
  * check on slot before continue
---
 mm/ksm.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 2ef29802a49b..6ff7f840e50a 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2939,15 +2939,17 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
-		if (!mm_slot->rmap_list) {
-			hash_del(&slot->hash);
-			list_del(&slot->mm_node);
-			easy_to_free = 1;
-		} else {
-			list_move(&slot->mm_node,
-				  &ksm_scan.mm_slot->slot.mm_node);
+	if (slot) {
+		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		if (ksm_scan.mm_slot != mm_slot) {
+			if (!mm_slot->rmap_list) {
+				hash_del(&slot->hash);
+				list_del(&slot->mm_node);
+				easy_to_free = 1;
+			} else {
+				list_move(&slot->mm_node,
+					  &ksm_scan.mm_slot->slot.mm_node);
+			}
 		}
 	}
 	spin_unlock(&ksm_mmlist_lock);
-- 
2.34.1


