Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BE6606B7D2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 00:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p5YftAwJ
Received: by kanga.kvack.org (Postfix)
	id B15FB6B062D; Thu, 12 Nov 2026 19:44:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED9B6B062E; Thu, 12 Nov 2026 19:44:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03926B062F; Thu, 12 Nov 2026 19:44:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79B3C6B062D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:44:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED560421EC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:44:16 +0000 (UTC)
X-FDA: 85428249312.08.1AA3029
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 092D6180003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:44:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p5YftAwJ;
	spf=pass (imf16.hostedemail.com: domain of aleszlucero@gmail.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=aleszlucero@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794530655;
	b=EPJQfPmfYbR/yH3fZ9Wt+eLg6BPQlPGFaz2Kf/mLwgEIUBB5t0NpXUADEC/qPE9IINU4dU
	hHqIkURhqPL17sCqSFdaca5I6n3GMRH/CnobgnJsLvEeQ5AQiPvhmYWX1DnpYsJlhoTXWb
	zFVr5NWCyDrZC/MM24pcr8o+3v/fRZg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p5YftAwJ;
	spf=pass (imf16.hostedemail.com: domain of aleszlucero@gmail.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=aleszlucero@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794530655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s1YVk99TpLbLdCzUwvUqAo5yK2pRxoOy71wVRzZH/Js=;
	b=W9EpcHv8dmdlapDXkKFgnTj/Vd9jUtCUa6CUNEYRVRfHQStaLHmzf1u8AzuP1qh693Vwy2
	+wO6yB+uVKhTsGGmEs0NFmGIL9Qg2R2tOSkVjgH3uZY7oOvCjoihpyM9FpwQK8n0tHoBfr
	19T1jwwFE3+r4HsAzgMu6yDA3YoMtmc=
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5eaaa9b1591so702387e0c.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794530654; x=1795135454; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=s1YVk99TpLbLdCzUwvUqAo5yK2pRxoOy71wVRzZH/Js=;
        b=p5YftAwJg/UZJ3cZJsENVO+XTPwBSeurXv6/AFsS7+9nmTNbPaFLVOef8+tRnvowMk
         DsPC94yvyg4U/RRtY/EEplZ/rT8NdFWsw0I6U3tt4+4gcbXgzk7SWU1lyCHvQpSRms/U
         Xq3n6fsOiDJECcWaRy+ltFoRF7TQIbAwgEan8vVKrBGblJyCahgyr4O/EN6Ln5e1D9nz
         jLAlJX5UQYhyGPrDOhfTI6uTtqkmHuw4aVkDTmxyBg+oBXgauv74sJ9pl0ocs6LhDosr
         zaiwQPlnusn6KJFthR/FsoMuY9OrE7GHM6Q/SdwhFtsm5L1X9APTyS4VoYh/bqxE9bbH
         Je1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794530654; x=1795135454;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=s1YVk99TpLbLdCzUwvUqAo5yK2pRxoOy71wVRzZH/Js=;
        b=AeGxOnnhP/6KlZE5b7fbkQYY0JeBsIO/cOtcmW5DT8Vyai4VVmPs0qiO6rJQq3QRLg
         RWF3FAobfLJguORk3SNrfWeBJe2fIxcOkq14bUuCwd6cIFQQw70aC+RCzntPtJWFocsa
         0PwwF0125fFcD8OKAStJsY27zCbhQEti15uzwyHwt6oKBJc7rn4gNHP38dRBqqIN8f2/
         WMfHK3sYxTtE1c2rFEgoPTomvwmdCHekvjP5CLZaxk1UBGlywW4Y+aaNylh3CsbDR9Fk
         xpnyuIIKfTWnFpOmAJAIxeyggKg9fBaiCCynfu6Sxbj20Eo4uVIaVmIMOmodi5mv80mP
         RuUw==
X-Gm-Message-State: APuU4Z8fX0BJWhILrTzWHrJgyfTNxXlYTwUauvg81cKcCU0GU4XWQqrP
	/9fAv/F9A6fybqp5fVjrDHOYpBt/HAFXmQBHSTiwjw1npoe1492ayZRX
X-Gm-Gg: AYBFou0hWPPvYu3kSvs2rHQQjNnMXyW50Lvh5ECs9k4T+9YuoQ2dwX3Z3f40RNscA0w
	7t9j2NuNJpgNYQEdFqvazPFTNAI3lPQxADZ6dSIu/AVt/xO4jWvG0V+umeklzRJ4W/1GgS2rSQC
	4W8S/oyklfYZ/TyPh645kgMdUFqPEZojARfTeTzrxB7jGWku+kC/SxUYDsyTq3G1jSte+fa9yKv
	UTPTOdnXvdsgw3213mmvNmU0NmQAMtSEYIQitCztuwSZYQgep4ZRljBiyXj6+bKDZFjnYWPD1Kd
	epytuT7LQctC+zYCtgzHbp7KaCuF55mtR1lcTPY2108EV0lGpIH7jZOWI38NjOTwlTGK7h6wo+d
	jwTsaDqj15kAOAP2Cljb6EUvoGGTJFvqKvqdoTsFg3gdK0i3nFHp55KHKEqIPKK7aDcbeVXi85X
	fr93GNRv29Beku+foDExs1EdODeWMEz+9aJ9HoLDoSUPNTHTFHdKJAj9IvVndSr9a9PEQsxxscF
	d/2B/0yZhhsA6YWmF6va020wMz6qS6MGnuDZ8l7A4Vg3K9y50H2CoUfhz34TrIsAvabqejoPbwA
	d0i0iEmlPSPKTEEcjXT6m+FHwVM06yVPnK2BdupETw==
X-Received: by 2002:a05:6122:311c:b0:5ec:c186:d22b with SMTP id 71dfb90a1353d-5ee34aef024mr356354e0c.22.1794530654065;
        Thu, 12 Nov 2026 16:44:14 -0800 (PST)
Received: from [192.168.0.8] ([2a09:bac5:565c:323c::501:50])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee34eb9a0esm391085e0c.17.2026.11.12.16.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 16:44:12 -0800 (PST)
From: =?utf-8?q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>
Date: Thu, 12 Nov 2026 18:44:07 -0600
Subject: [PATCH] mm/pagewalk: document missing struct members
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0Mj3YLE9NTyxJxs3ZT8ZN0UkzSDlFTTZAPjZCMloJaCotS0zAqwcdG
 xtbUAf6DM0V4AAAA=
X-Change-ID: 20261112-pagewalk-doc-d4f0de5c03c2
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794530651; l=2229;
 i=aleszlucero@gmail.com; s=20261104; h=from:subject:message-id;
 bh=pJ9P7W0I0mabCui6yThr7RtPoOdOOdr/WWw8y3K4weU=;
 b=hZqPLMCN9HIdyzRPrexPxD5hxkRBBDo8KaVc6u0T36+0rfujFKA0gvnwyuFR3TDzS5/mf4F2Z
 uyV6aukmUS6CHj6em6Ww+8WbDzVk2GIzU7/nC3HtVodDt7MVDF5sHul
X-Developer-Key: i=aleszlucero@gmail.com; a=ed25519;
 pk=zRzEBMID7l1FXqr2CjfnlIn++3m3N05FuNYb5zPA3cw=
X-Stat-Signature: 5qq16buonxqjsrn8hef9bef7yyo6s71q
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 092D6180003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794530654-273611
X-HE-Meta: U2FsdGVkX1/G5Uc/LH7+N0fzvdX87M3pLg99rbpePoZ/9BMpR+k91SyO3psYVTxC53KFdlxyqg6BYhAzr4176lj5BHUfA/cEfs+kPhxXI+27mUQhqUNBpRzXf2F7uMPRMus4F+MR2hmjnhD6IbQ9JZYMERhKuHqMKWJvsIcvkkYMBhkhACKeeWcvUKuotLQQOn36hIJ2kiIWkZo96dMfqSG8NhNe2zFB7tCwjcmnC8oyc1LTIF5Ulp38KUUObUfqh7muFAnxPOMoGMrPC7U1zJ3E0ZABYZ8I1z95zrO8MhjoZsDPfz3K3R2cFn+0PjOCZmFyBWGhi5XX9hkhOe6SBCxRP8sqnZEUoMJGbud+G44d0PHLSIvgsm0c0Utte7c+qFTkLRg+32x2r/F++QHlUchWiGY131TIHLs/Y1XOgVyG7XRssws2UMT8b1osRpNwWNEeFG8He2YXcQUnV80C6gqatAnFa0Of3bEXuHkvXmHwxU4D8nOyEJfvS1fFpxIaLKjSwHfx8AwsdCKvLAGErendygXW50pIrmtfCdJdYvkMk+QWe+6tq3zoG0GOWmx5cg1nYtPWl5znEKOhJQgouhCnsqAdcsdA48evifXlhi72L8icdecOsqDWCgO1buJECU16uekwdO7WvSurvTuGXbXL3VNhBNOEZD+103fdZ9152oblKHXFPEQTmHSGrEJ8cCibBV1iHg2qAPLeqVuOkbxwQGSyUeQLHy9qNJlnrN+JCSgHdWxRhXZJ0thjX7AbmOjjHtmT2NAGPkS2naMauENsD3kRsOwUN7JGZhktk1ZGK750UHqJamS/KtBIRR6OuKK6buJUY4CNz697Iw1ugiJJNaRERt1I1ya5oiiVCDzPpIS2R1AWXAGs3f+qrbxiD3NioTWT8dlz5s7mKB2fKsYZ6miUNHF+ikHu4htmgEhYRxZzq1wqyPeP0Va/2G/K2XwdrY3QkO9+vMruphH
 K2xPCzuf
 cvuBMOdNQHO43KK1HzIqsk91RARBgaXAVk8aLIDv83M3m39PgEnaUI67V0SeKX4oQvRalJujkCh56Hpqi9KSlyskdazMsjW4slDY03sD4MQkGufesDphY/mu3IOJH09QaTGvS18v50RkRO9OXuzrMgRKyibLAetiRQcLs0htAL5XYwkY/+aJhM58xyjuQ9WswLzsnZCYpWLWUsucw/jlouS3pSyTO8y/8GyRs1uj5lNJrQFgJxsDkQY1F+5Zr5VZUQ140X5zDJyblkMMNQD2CkFZ0Dq98WPmXiTx0myagijMR/G+dqsJi1tFEvWPVcGxe1tDnsx644P+Zlx4V7RKIEZ94YU8il0oQ0PB/tqAJx9ciH8pxr7Iv/JT0mnbf3VPOGHuFwU730+seKY+eyxWq1zRmWyZiLp22eNAGXjX22SJ1Ze4lcw0Z3xEcHr1zRmhR52qmUSKEyzi9fayh/0jpYLyftrBXW2PsT3zLEhrVcKiFbE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add missing kernel-doc entries for @walk_lock in struct mm_walk_ops, and
for @ptep, @pudp, @pmdp, and @vma in struct folio_walk. Also fix @pte,
@pud, and @pmd descriptions to state they hold entry values, not pointers.

Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
---
 include/linux/pagewalk.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01b..978714d5e32f 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -63,6 +63,8 @@ enum page_walk_lock {
  *                      install. If allocations fail, the walk is aborted. This
  *                      operation is only available for userland memory. Not
  *                      usable for hugetlb ranges.
+ * @walk_lock:          locking requirement during the page walk (see
+ *                      enum page_walk_lock).
  *
  * p?d_entry callbacks are called even if those levels are folded on a
  * particular architecture/configuration.
@@ -161,10 +163,14 @@ enum folio_walk_level {
  * struct folio_walk - folio_walk_start() / folio_walk_end() data
  * @page:	exact folio page referenced (if applicable)
  * @level:	page table level identifying the entry type
- * @pte:	pointer to the page table entry (FW_LEVEL_PTE).
- * @pmd:	pointer to the page table entry (FW_LEVEL_PMD).
- * @pud:	pointer to the page table entry (FW_LEVEL_PUD).
- * @ptl:	pointer to the page table lock.
+ * @ptep:	pointer to the page table entry (FW_LEVEL_PTE).
+ * @pudp:	pointer to the page table entry (FW_LEVEL_PUD).
+ * @pmdp:	pointer to the page table entry (FW_LEVEL_PMD).
+ * @pte:	page table entry value (FW_LEVEL_PTE).
+ * @pud:	page table entry value (FW_LEVEL_PUD).
+ * @pmd:	page table entry value (FW_LEVEL_PMD).
+ * @vma:	pointer to the VMA (for internal use only).
+ * @ptl:	pointer to the page table lock (for internal use only).
  *
  * (see folio_walk_start() documentation for more details)
  */

---
base-commit: 9d66f26fefacebfeed15de31c1123451a17ff119
change-id: 20261112-pagewalk-doc-d4f0de5c03c2

Best regards,
-- 
Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>


