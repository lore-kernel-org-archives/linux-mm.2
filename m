Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA13CAC5BC
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 00:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA8B8E000C; Fri, 26 Sep 2025 20:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982F18E0001; Fri, 26 Sep 2025 20:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848BD8E000C; Fri, 26 Sep 2025 20:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 730E08E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:45:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3067E13B341
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:45:48 +0000 (UTC)
X-FDA: 83933187576.15.C42B962
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 646E44000F
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:45:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c0JE5mo9;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758933946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=/5FG41K89lO5oG83hm4CDr9+9moNc+nZhDoahezjEWM=;
	b=1dimMMsAlx2Fh87LfgKdTqG5msyIpDrUTDMW3BvfN9N8vN1ym+22NgTp1MEnPaqcuxTiL2
	zoL1+vr+MFhsqPneDAr+cgvIvGyFsG0ht4eNLpuflKGSYRNfRnfeFtEK6c+VWOHehF30g5
	O3zfaCbrYhDxmSSfC+dBK1/8GjkdSDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758933946; a=rsa-sha256;
	cv=none;
	b=Up792ij0F1/5HP2ADp39dmj9z8DUBGyX17KbzyrwGPU1MhwGtj/eY5waELnRn6+E++xJ2F
	wsZatRy291cal5+ZL+wYsNgLCDB9aK7nLd9OEeJjhv1c/MBxAKJNANDyHnXcceh1jfYv3X
	7baiQgpkzYZhX8orSW1gEryThRRbbfE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c0JE5mo9;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6318855a83fso5026064a12.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758933945; x=1759538745; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/5FG41K89lO5oG83hm4CDr9+9moNc+nZhDoahezjEWM=;
        b=c0JE5mo91h0izvFCkohyGuxadljaW1HhhC4fLKiWT5Bqwf2xKr6c1D8lupQ9JuzDQz
         TgRq648rujydypiltPO5no1z1Ehk8hE2AVEwOnLl+a0fWjar/keoyjP7AAngdahg5qQi
         8H/QqvI3LjxGDpsolf/LkJTNNcglEl0dNJUvPTjMc6hluQ1eoHomm2+bOZHE3Mtmzq2H
         2sEvCo4Am/Y6r8l6hqApDlnZ7gE6KCOrMXdpuBiXZ62z18udJJ7u4hYogrrmJeWpzrze
         ei8dypV6uDRtr0g2aMA+AWHBUVLIWZU3WSFt9y+QXFnS1KfAiEM89ZsfGdM0p2Fyp+It
         qGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758933945; x=1759538745;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/5FG41K89lO5oG83hm4CDr9+9moNc+nZhDoahezjEWM=;
        b=mu36Rs3K4L/LPRuL6eg2RROsgrfUSqgSnL51gzpAkuYECIAqxYgU8texPJEMjxSh+R
         tjI/eTTASCNCsE1owjwfLrjM+USmemvq2bVcgsm02afM8Q4fUFyqUD9shZEs2mXnZwyx
         RCs308EBOnohw8CBYoz1eSJnDLdNSauUrhJHv7hFO3rrrpx02jAdWdUFeIq6vhEIbMnT
         Rgd5cU48KFrL2kUaSmh3+Hs0oO4VsODFfnVpIBR1BLZbap4gAvC/6V1De2KIiT5efCYk
         h26QnDK44NzOsQpn9o61Cfji8GMx3S02bAhNSHpb3M2X+KXF2fbb7RHuU9q6j7jP24m4
         dZQg==
X-Gm-Message-State: AOJu0Yz9gxNtS27v8ASvfulLpALb56WZ/x6nuZwP28+Pi7k3NEXYQNRp
	LBpJ1o26stuE8jTUGeUMn1mWwSmFIZeI4o0B17n6VtuaUiw2YJluob8P
X-Gm-Gg: ASbGnctbLOcdRLWbuhB+FMwv2HPR3dcjF3afYixhyijS7tqCNy3qwRi3oeLehQquBqK
	9btDVTgC3r9CuwS+SvU8In7yQAz9RePDfanm8h2Q0azFbfMzPSgy42LXlBF8w1w6KYnt3ZsHTFf
	J2YHgwPUcRr8pFIV8crn//YGg6jTHvW9sih7NE97v+4z0WhK68cFCb6pS4s/DV6wyzYpHdKElyr
	6gzjV83B5ux/tZxEzX7Idlm6g22/i+mfMFUo1eQPinGYX8sKUrINNi7vB4UmWrdmR8a9MXo7DcO
	g8NdlQGfd30jQlTUjbIDGb13MjGtQkcAa81U859LneBW2vHRxb5gaLVwmP0J7NwKEKJEderHRA9
	6kBrojwSWl8ACHU7mqSwxxL7GIw==
X-Google-Smtp-Source: AGHT+IG+A2jrDm4SeRfG9NugvqZeF2atCvx2NJE1pL+eFC3Ecetq29GQPPBv6lCP3hzY5S7VLAA70A==
X-Received: by 2002:a05:6402:3059:b0:62f:620a:6a17 with SMTP id 4fb4d7f45d1cf-6349fa87835mr7097427a12.26.1758933944813;
        Fri, 26 Sep 2025 17:45:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3b0595fsm3630833a12.52.2025.09.26.17.45.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Sep 2025 17:45:44 -0700 (PDT)
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
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [Patch v4 1/2] mm/ksm: don't call mm_slot_entry() when the slot is NULL
Date: Sat, 27 Sep 2025 00:45:38 +0000
Message-Id: <20250927004539.19308-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250927004539.19308-1-richard.weiyang@gmail.com>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 646E44000F
X-Stat-Signature: fjbpqonp6jcc74t9rkcq4fafa8ck36ay
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758933946-757244
X-HE-Meta: U2FsdGVkX18z7ygCGXR1Z/YS/dHROzuLrv3YZvJ2dYxscLz/WG5fQ2S67Xple5laDCQg7zo4zQ+nXyTZmoD3iEIY2qO0k5qmuITh0qW69GYrpwTDsjujdBKPbDnlQMINcLxYXz8Gz158yzQn3ETSyTK8ORccYhB79BY05ZTPYb2kEe/jSLuIyNMTkPjeScd+fZ5hjLoGT8M4cOPo6zwaTQ5MDLj1p9c0uCHPlDnMgiWDCEcPo86e4qNbry9B98VNHU31hizCyH6eNViMdgMw85cWNIZagmza4OSBGc0Oog07EKgWCbKtRzFzTdQe+oywrXGnCrcRc/P177kkAniOURDPShHLpxckhThV7lJD872GIymxsD1ItWNko2bqBfND5Icq+MKqdGgbdq9Om1yfPLUU8hH4h8sCUkr6PnJM5DBmbVKeyAXRcv/myK0Fjo8nup3Z7yKH3Vf8VVroL7wxWNEttV+ByXDDtCVj8s4OYlGCTTX+k0cOQaSeGYTTitOPaYLz83LEPhomLn4hDB2M7cxDJ90MsBdVLWBolFEPzQQh3pN0jeIgJqcaPyK1Z+bgBaOQ3jqH7I026BOlRhWbVAjT7k1fq82aA8ZtLlRRfclzJBHq9uriB1bZttS2o1QmF9NSPV5qBW9evN57ecevuuoK1KKGtiPcVgbH8cfpTA69QDf/FtTDxMSVbf8oU+ute87snCMXiEGIreg4krRNUwfzvB7ZTXUjlRxuxg7D4ivMk/71UH9E0LSyA4j4PkgC5GCGAxLa7pdqRmZh4PCRqkowQvG6kus8MAR/qdVWsB+p5ZdMj8Z3h+MQ41OmMY8YQtQVEA2N4vjHzUlm9kouSpfArxpBO/BooK5GT9tWau2ttww+pL+dbjZJE16VLoMs/gsr/5HcJE0jYMNq18xVw98vBfnX5C3tgm/KJ2qS0vk9V6I+MKHXV29o/kZXZFUANR3qYEVGOvju1Aw7cRx
 +lJTaxcK
 6I8o242Ff/S4LT95mWM4gP5y0VTHGGA7h4QUU6rVGWoHxC6LETehxJAKWkT7x+L6oQTLrdUzhNT/N/G8OAFnCNzY41HOPZCivcgm01fFzSyDvRh5hbmMolH1Pe9AQe5Hrp+mawA5Yi6WwEydMx1vp0vYE5oWBFBrDYbPRDhwjo5ksF+FC1Wpioi0rzDgl+YzXCMLdmpNyCJJyqxx1OK/790UBNQjGN6ZyPqvD4Dw6jStAjx2a2ulW7c65jsHo5Oxc99gXCRVsluF8Dda3DuzlX2lLDA6NJ9zS4yyEORkAA6DVEv4T+I8YvUgn19qneKNGlmyPajP0+Chu7GYE16lCL+PI05c04LliaiifJemYm/qIdLXslXgbNlGMpymdLckcEWjU/QFqSmxhYqjyWTK3qxkCFHfiFlk0EOX59xY90rnwAhFNMSoPv78CVy5WGo+dXmxaZr2rcIJ3kl9b44Ndxm9BjynSIm6DHllgSm8VsUyJLxxpXNo2Jk7zE/T+I+MUt5rok7xpbf93SJcg4tQk+7ZVd5ZjbV2A0Cj0rlp6YphJ4tAgxVFnyPU4yqt0Y/oTwA9LiWA6TEQ0H6C4tdML7lTmhAUYjelLFGNiVWIzqmjqMZoxL8GkCX4I23FO0UUJq62+N4ONBscU/+jqtO+K70fWqmBS/ZnCjeJ2XtECLRwLLSav3a+U3MV++yePNiYAB8w8fSu1Q5FzkFcV+MJoL3cRZumjSSC1RxlTl04NqGwPkDOuaaXGjAnGkc4Y5i2m3Eo89rgiCteZacKreNxnXtCP4vkxJ7KtO5HTqNt7XXhGPnV94tmTCXSmag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using mm_slot in ksm, there is code like:

     slot = mm_slot_lookup(mm_slots_hash, mm);
     mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
     if (mm_slot && ..) {
     }

The mm_slot_entry() won't return a valid value if slot is NULL generally.
But currently it works since slot is the first element of struct
ksm_mm_slot.

To reduce the ambiguity and make it robust, only call mm_slot_entry()
when we have a valid slot.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>

---
v3:
  * adjust subject and changelog based on David's comment
  * use invert style for coding suggested by Kiryl
  * drop RB and Ack-by
v2:
  * fix uninitialized mm_slot
---
 mm/ksm.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 2dbe92e3dd52..7bc726b50b2f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
 
 void __ksm_exit(struct mm_struct *mm)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *mm_slot = NULL;
 	struct mm_slot *slot;
 	int easy_to_free = 0;
 
@@ -2936,17 +2936,20 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
+	if (!slot)
+		goto unlock;
 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
-		if (!mm_slot->rmap_list) {
-			hash_del(&slot->hash);
-			list_del(&slot->mm_node);
-			easy_to_free = 1;
-		} else {
-			list_move(&slot->mm_node,
-				  &ksm_scan.mm_slot->slot.mm_node);
-		}
+	if (ksm_scan.mm_slot == mm_slot)
+		goto unlock;
+	if (!mm_slot->rmap_list) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		easy_to_free = 1;
+	} else {
+		list_move(&slot->mm_node,
+			  &ksm_scan.mm_slot->slot.mm_node);
 	}
+unlock:
 	spin_unlock(&ksm_mmlist_lock);
 
 	if (easy_to_free) {
-- 
2.34.1


