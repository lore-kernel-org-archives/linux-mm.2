Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27156CFD348
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847826B0032; Mon, 24 Nov 2025 14:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F9E6B0062; Mon, 24 Nov 2025 14:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735346B007B; Mon, 24 Nov 2025 14:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 630426B0032
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 187D7C0527
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:10 +0000 (UTC)
X-FDA: 84146456100.01.3AB6846
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 154B6C0013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LFWze7eo;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3/znPoavjBgqqjpUZfnq7wwOL79gjtKqNHBOh+8lvo=;
	b=Upqr3KmRd5BNsyBGM8ZnYJ5O2dgqVcNgvn2IBaS51oc9fSMEuP6pDVTnWLSY//84ZL1B2D
	JyJykA0o4gjh9VJLDIbCvcGa9gwq79L+ppKQGgrjSGaDsK6CSdkeVJLSHfEv2Gns4iuEqK
	6axbompqF3ETbgCqpacjK0RXvFxCn5o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LFWze7eo;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011768; a=rsa-sha256;
	cv=none;
	b=K9SqRSOg6/r7nCjFw4pAY9duKxBFWxs9yxc6HdAZJuteU7zFncfxVRBPEItyt8JjPzX7Jp
	RXhxxlmzDdjKE4duttSqGawXDv3HSg6V+eb07Rymuq1xVOhhjxvrIGhh3z2m00d35+AtDf
	swTDVOVjb6/yq1T7oUnmjy8c1iBgYMs=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a9c64dfa8aso3580181b3a.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011767; x=1764616567; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3/znPoavjBgqqjpUZfnq7wwOL79gjtKqNHBOh+8lvo=;
        b=LFWze7eo9+EW0WlDte4gt0vz+rFK08LQQ6iRtIoURFZhQblxoSYusreAFAkl/d6Jqp
         wWy9HJjlQUpr4WB2HAfVbeiO51Rou0dyWRnMTLUOuVwU+f2+gj43lpzmRMQipja7tIVL
         gtigAmAf3vyFcXm9e2CvP/gxbeqaJwsGvOkmVvhAnYK6L1n5VoXE0MXxpDxdrKD6oLKo
         +WsddssybnCgSiBH+p0G3Kv/jJtYmsn4spx61uIFEGoQjG9HL/t+//QzXYEuZJ4c4AO4
         PXUQdj4hMmry9NCQnkmEN088tJ8ZdoGkW7Rmr4oG/KBPGkA2ny8gQgq3VZLQUhI0vCV2
         JGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011767; x=1764616567;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m3/znPoavjBgqqjpUZfnq7wwOL79gjtKqNHBOh+8lvo=;
        b=s+CagfEpTJSGEKjOgS1utw5sWeiIUnGhtp/OMcsa1PIech6Gv6Xw5zPBNS/7xIFsjp
         K3rPci2FmrLk2rmL+2O0SU/Y7VYU2Ad64Jy6mOPj0INJcplNTfDygm2ECtZPRx9wwlhW
         Y9KAhVUbz5Cip4F0Aj2/5iI+be6+LrhBF4seUzau/yKvgdTmCaJ3uBJXlJ2Pmua2LgqV
         0rPmdzCYDRmonzfvqqUW7m3syahXr8wZhNpB89W/wXiBiUURWuCmwyR1MZYlX6b4Cou+
         BrMLJyyqvgnGBQDKPUgPu/8+lJsKqUAu5bO578BwgZMOFnYQOgHfzIkapIbenEjiyn5w
         8JMQ==
X-Gm-Message-State: AOJu0YwYLoZJ/3ThDqvWnOQm4nZ0kRQjPQho5dkQrQEUrG4aCx1WmgTY
	aM6Gd8sAK0j5SZeg2Fy5ime0cC4uHR9HmmC8kAmgoByyhZ1extvb2vbB
X-Gm-Gg: ASbGncuy1WzSJL8c7n1k6l9Cznl+HZQjBusyVRR6aRfAxTUgidNPLo7vMyQo87HBjWX
	Lm0gaHjK8E5tqkEguO81YGcaWhrsh8dPLv8bEhjfrxbT8m0bwdpxoVI4udLmaM7dNjFKjX9HTFe
	DLUNvP8GZpHATWr0cJxuApNLrLrX3mfrbeL7mDyR3rr3vuRZkC4wrEP4VqmbtG/kGZlst5bgls9
	rbzA1BUspqZ8zu4f0KSPznzEfoZNXC3AxotQvWfRIXjwfk8j81Fmdsg9ZDrLoEf53jz8oc6lHER
	iXbeGRv2Plb/OHiezPVkDyW+0n0na9fEx/9fA0x2KYCFpsYJ4UwhiRP8LMY9uwOxXTzQ4B20hQ1
	YE03Ft2B+z5ffWSa9v6bNdjslU86q1XsRG8O7/rLxlxEb/DG+kBgL8GEQs965QNOOsa9vftP6ym
	e0jUqXYjxYd4rwaAMqttNVgXzacsq4+D2bhiApW5cd0ACtNzASheSQTr+/ylc=
X-Google-Smtp-Source: AGHT+IEdNvv63j9gRZ+PlWPsm6yqUdrO7ifaRQFcoPAtjFV84g74FKwIZFNPZKCySdCzjMYIl0hjdQ==
X-Received: by 2002:a05:6a21:6d89:b0:352:3695:fa64 with SMTP id adf61e73a8af0-3614eddecf9mr14535414637.37.1764011766767;
        Mon, 24 Nov 2025 11:16:06 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:06 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:49 +0800
Subject: [PATCH v3 06/19] mm, swap: free the swap cache after folio is
 mapped
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-6-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=2699;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7ANx1B1sM45AeElSDuuzzNPN1Tv7606509lOkJkHgRE=;
 b=1GahXSVrzSIb69EYYrLaQ5o8p7Eq2dNT0v+CUr1H6Miwk462u5EDamd0NV7lZ8C8w3T5qDMEE
 /6bdy6IuS0kAgr7/KGczPaDcuKfPjZUGRdmiZxAdD6BLnyVFLNeLqup
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 154B6C0013
X-Stat-Signature: doe7w415pksg8acp7ggo9ucceuwksxo6
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1764011767-661397
X-HE-Meta: U2FsdGVkX18uZVUTOrf8k83/J+KYFMwq/UoDf0PfuePzrS7e1efWCsMgquTQI8aDF/SmSKHlpIkvvPFw20KTQrNSTHY9cwXKCdTRJC9UBSGBR5ejp5RTtsgjyxRzrpel8bka1WYd57xPtWgDtnIwODd9ocvfAiYMMbnTymxMuO1BQVsGiq3oIrbq5J4HbHFTp84hb74OX3RR1lk/wmZ4fQvBmVywZzou2qHFeKvTOk/hF5BnC3HJsxlRKWo/s85xqy1b3vUpApgpw/CjChfEwinQvXHUdo5G8a9QIuSudu9TjPvnlqPuD/N3c9lPmB2gSOk0UAu29Vcwuiww4t+YZ5eS9yLdcIVwXByZ6MFKTTdg/2+iSgFhOOD2utkGDQnAx1nlUbB7Y9/KJ4v+GzrrYSv9gAYYp+rcgmzY8t9f6KGNNIhjE3bh+nl0Mfx+xVbFMF3DkN5H3ydiEaYyX6iGL6NyOpGsYEQxSDcYgVxvxkPqA2s7O6QpLM93z1uZ4Mns8UyVYzOcNtpvoW8hDe6+ChaSazdi+f7BDJs2PFy/QVEN1qEnfnk/ebYip6Qn1+J0ZdK+4nAIYOjX9ytrCBHJKx14FyRlD07LaYh7+Qd38gKDG8tWXfnlEteR4RufyhtiOADlhOfOJAsyFub6MX38+jz0UJU9XJHCqcOMyWufIt+NmyB6MAWp8s0DC0XcdmRsU3wmxqUaf9K+sefoAxtx3uO9mW7qH/5C5sevj9yooCc7z1pIm74svtH3OI/DuZa3R6GhZmsnfLURFIGaE3MCojdEl6Bck4Pli/fYl/JCJA/6mC/oCeMuGx+9zKVMfhrrX4Qqfn9UNFbA57/Cnmu9ylXYNNajBq7WDvVcIbF8WT6Y5u2el37pBW+Ef1DKbxeYevbZmkU1AgN7B4wgzFIFLl7ko580MnlzFQD152eM3FGqosB84WqcqTBpzBxvWRcmItfLXkXZRmOhX6nMbrC
 JPAHgOxq
 HyR6qhVZG9DZoNPId9r2iPjBroQ/4tqGFKq/+/hABfOBlYBXNYkJMY5CN8dSIeWnIY1onNyLOk5jOh4HIvZhDg+DlQyEV6qU858iBaaqTuhtSQjqGxWMrwFV6u1GZFUUiGlpS3PJFgRDL2lorFeNtUjoNxLCpIEJZI/Hlq6kXEm6cSmQBT8Rn+72LDwaKZLHCoLZIndmlqo/wTUeefvqIlSGJ6QABoEtBTL9OZW53cTQdnVV9Odrx30JlFs6tOWqArobnWnqx3b/lzcgIMPDynFPpCDvEOJIF2/YLPz80jvsW1jmXhJUCIssykeNYfSTGNHl2S4cT2tihUR4oNa1HICTs9BSnU8roDpxW6FM1ZZegtYxv58/ciZqPuBN1vKPwHWrwfHzeOixvnfwFWNZUv66aHEcex/EhqvZTF4U4jcuIuSpq+/4tJIclscBKDuJpsOvAfE8mvcFzqDFkSnm2XJ7zEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To reduce repeated faults due to parallel swapins of the same PTE,
remove the folio from the swap cache after it is mapped. So new faults
from the swap PTE will be much more likely to see the folio in the swap
cache and wait on it. This does not eliminate all swapin races: an
ongoing swapin fault may still see an empty swap cache. That's harmless,
as the PTE is changed before the swap cache is cleared, so it will just
return and not trigger any repeated faults.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3f707275d540..ce9f56f77ae5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4362,6 +4362,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 					   struct folio *folio,
 					   struct vm_area_struct *vma,
+					   unsigned int extra_refs,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
@@ -4384,7 +4385,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * reference only in case it's likely that we'll be the exclusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
+		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -4936,15 +4937,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 */
 	arch_swap_restore(folio_swap(entry, folio), folio);
 
-	/*
-	 * Remove the swap entry and conditionally try to free up the swapcache.
-	 * We're already holding a reference on the page but haven't mapped it
-	 * yet.
-	 */
-	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
-		folio_free_swap(folio);
-
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
@@ -4998,6 +4990,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	arch_do_swap_page_nr(vma->vm_mm, vma, address,
 			pte, pte, nr_pages);
 
+	/*
+	 * Remove the swap entry and conditionally try to free up the swapcache.
+	 * Do it after mapping, so raced page faults will likely see the folio
+	 * in swap cache and wait on the folio lock.
+	 */
+	swap_free_nr(entry, nr_pages);
+	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+		folio_free_swap(folio);
+
 	folio_unlock(folio);
 	if (unlikely(folio != swapcache)) {
 		/*

-- 
2.52.0


