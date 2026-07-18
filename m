Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F7BBC4450A
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 04:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6326A6B013A; Sat, 18 Jul 2026 00:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3896B013B; Sat, 18 Jul 2026 00:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA546B013C; Sat, 18 Jul 2026 00:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2216B013A
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:27:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94462A0923
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 04:27:46 +0000 (UTC)
X-FDA: 85000614132.06.98C1033
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id CBFAF100002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 04:27:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JSTyFnDf;
	spf=pass (imf14.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784348864;
	b=1apkFEPT8DcYVBa/YdbFUkGqgzS+zsF8kz3lnjFFEgoCSSQBRYcNuAf+hrYLaIK00foas1
	T9PcqV4m9D24e28l81lRECh7pVYMPLsiCxWyWKMe8LLiZekpUy3SvrkAvUoX0RZ0EbPqkN
	O8cd0I3i6rV8R1ip8f/cvJEK0EpwN/U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JSTyFnDf;
	spf=pass (imf14.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784348864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrQYQJ5EqpIfeY3rxJ+dX9xo0RtpBGHxlWI30nps5JQ=;
	b=LoPVmcMNx2Fn6DG62833GAUHYp32nfXR+ei5KTAZnXJrf+heYsq8W+3mFDghWStawqfStr
	/sDOPA3Xxz9y8xDLG5sfW9Q37cmiaFoZ9/FBTMU+NrUd2V7D+TyyswjLNrBA8gZPVf+rq+
	Q8S+HOfe2cXz6U0lt8lZgasjfVGOBNs=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ca80d708489so1651893a12.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784348863; x=1784953663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nrQYQJ5EqpIfeY3rxJ+dX9xo0RtpBGHxlWI30nps5JQ=;
        b=JSTyFnDfD9O14k/+HiR8yuI+qJCc52BQA068ciI5j6yqxn8uWbLxjUtnOQXU2SPd1X
         IzYa883GulpG/zQ+k0nsxJmP0nIl4LjgbBOTxjs48oW2uclmbr9DhTw9uN8ZKY9m+bGJ
         E1CTFKt7f+3ZwGlHOxj2qAqWoxevAc/hSasw+4/IG83rT8GPKTqsWrhYO9ZrhxPVC3Oe
         Z22A85mrfSdeRtMRX6Nc0zlWHr5zWiQ/+eNsCBzmYzgilP/vyM6WaY9Pifsllo5LI/sN
         DA6bkYi2m/CZruGQ/wyVm+9FpnD7z8gG/xPK+vv/ePIC95BsAAJuUF27pqQeqTAr9CIX
         HJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784348863; x=1784953663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nrQYQJ5EqpIfeY3rxJ+dX9xo0RtpBGHxlWI30nps5JQ=;
        b=bZ31HLFI5vIk9JFEkg7sTafQ40GmFnAJm1AV386tvQKnynUVhNKBVWROqfRrzZ1XKA
         raJhkhAi6Z/ugug9aKkni0d0FoXVeB08vzGMnCpUoeSyo2qzImN4T3ZTfQT1QlKiAu7b
         v9kMQAccZFTDRdDQ/HSa2DdBGqhbe3h0MzwMvRq491TqBG8VOmqYfBNIj/3JffimLkUR
         OldtJ7Ng5bL43WXtaGe3MsbZf+mpI5OmFLzw9qCH8W0kuuL/Ckwit0t+M4bIYE1kYltB
         z5ELzQX44i8NqCzDe9bjU1ADNSrZjgay8m6VYvLA7kBCCb+FfBBBszOybtyfuC2WkTA1
         kiaQ==
X-Gm-Message-State: AOJu0Yza5GMw01qLtCi+mjqXc+6/LgvFj/eNEAgwTxfmriYP8HW3xmuI
	Gz5iaaIfJBtBEKwSedO5jHvkTrFsQnCpHBRiBp+W/j4AOYdipT+DPy94z4xO12gj
X-Gm-Gg: AfdE7ckjr7MicsV6aLTsZlVWQE3429WNx4xXnR81UDWmWNqrfYA4c+JYca/VqU8qKYw
	vrJyrMnNTXgJ9qcfEDHtXDgDRmi2W6wmbSEevNuujbWPfFEp3ZejfgTxpZujXnNzER2ioZ0qra0
	+N0OjpH0FIkus0KExCIPelpYU9ELz3qPuDLRQIsVg6bYXzqG1mFUuK75n57/Y5DfdP6q/GRQ8+s
	y5JDzzJal8nB5k9MkTR3VLEMHdQrgcXlDhVkC44XuGVqMWYte1yrrVrnxVOtOuHDgaqLDO14I8k
	xbUfOcFe85mGQU93zrkWvBQi+7Wwlysf438ql0NWakJ/jKJTl/78mHLTsBTguVkBwOIFECLq4ff
	fqqlcVdOvkuAWTQrABnK2w2M7Kdjt5TAeSF+Aq+IRn43twMj4DrWjRsf0DHjJyo4k0hcvXr86Wx
	gXp1BUc9pP1PSh8TfVn7Xd
X-Received: by 2002:a05:6a20:729f:b0:3ba:d7b0:fcac with SMTP id adf61e73a8af0-3c38d8cffa8mr11795073637.5.1784348863390;
        Fri, 17 Jul 2026 21:27:43 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb517ba3222sm1627977a12.5.2026.07.17.21.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 21:27:42 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: pasha.tatashin@soleen.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	roxy520tt@gmail.com,
	enjou1224z@gmail.com
Subject: [PATCH 1/1] mm/page_table_check: widen map counters
Date: Sat, 18 Jul 2026 12:27:20 +0800
Message-ID: <b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1784337674.git.roxy520tt@gmail.com>
References: <cover.1784337674.git.roxy520tt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CBFAF100002
X-Stat-Signature: yefn9jfqszu5afepdxzwc51aho5hua81
X-HE-Tag: 1784348864-76949
X-HE-Meta: U2FsdGVkX1+AaKMXfzBu3WWpLPI7R9ZkeR9H7dml0mbSM+4j6lFUQXWLJAV3U7nnHCzzrx5Qt7DkU/C4pniNXaEVmcd09dlUkeZMhr0pWf3CQB9RCQRT9mAXNG+UModNkF4melm/+HOwP3Q028JH1g+MEWmLGJTc38RXxYUZh7N5WK1D+1xZr3zvmT9BRDCcecz2VtGaL6a57St4uZgWYedi3KrYRExhWYmhrOJx8JkJs5wOiRghDq0IfTpTJBPd22QNvuDNHtqKuu66zvJtn2lS1oqsWf6+HqpNGKwE/FDJazgmvNhF8/dVOGcgK8oUtMH4ymXMSevqaFnW9Vmqe0QHOTj1p/3qjktbfFWyz+9Artww4hie7gSKFULVfDrv2cyI6JIdtkBCwu+E/hSk0eggOf5QNTKTgCC6E9F/18YCkZsFatT0OITz1O/awkTHyjGJYyMuTRXBpqe/Z9cDpAz56ffl4HQ/a8QYFI95bg/3GEJL77VfZZz+Vxj6Cqyq40WBhP2yp42zhYtaWkVXua2j+cmKUuzCQV52MnMC2Li05WohWlkPm+UPiokUY+6GXWMIenEBVk1Wn75MXW5MkRTWI/WwUc0O7mThKrjQ5EQ1CErkSKJCSEmKnEqQuFdxNp5jIpLh14nsfvKYDj/szTtT/rJNZ1sKBbx5U3ZOTukKJIVet0+4WDZM1tGwbmUocDOBG9feGVYn3f7/CTpFGSxLhhZnCEVIzPqKq3ARaTnOSaSpbd+OF+8ZG3whDIARFWHCcb3cUm4S4fQ937NeWePMEu56teCW5elM7zF3gG1jfTnNN+d5Z6zbbZc+cEI0VU3v5f/MqISSWyUlx/6R4hx+QZcMwfHukW81KMsKOK2oOTydyh0w4gUEZBG9mBv+KFCMsDFv/ZzMxwQVJx5QIdoDNEC56gZM801Gr12JNs6WRGHbxWRKrSxiboXOP/tDstMa22aWytuZJULBQpl
 KPNys6QT
 dqZkSObVHDiebTO4zUWbvOinp4kNW9H5PFH8IoFqKmDUYpnuJ9yOfJY5dHyVOuBbad1La+3gsYMcaj1mJyCmVTiKR4HPMLNxgQbLXfMDarLZueRHrhfdQIYVcJqeRfNx9xvWiIEtzkj9k9vyRtkL8uoKP/UBzaXUmsoyGJWmBxIB5Tq973xb8DkYrSVoPdSZkglVi6fbE9F3QEj+m7b1hxlMIDbD1vS2lZA5yCLxJarDAzfg7SPaMUYn1Rp8Oc+z0p/a6dx3DVljL3gF/PS/Nw6iJqhKIpzKaULInrorH2ty01/aWa1CUIn1UNMBNQyeoR2UACB1bLNsQ1qUJOBLZ4Vi9e3OXnbXWTTAY/OVhJ8iEXmiwhIM0j/hiPZOh9IjHEHsOR3iFCnN4R0cnsVEw06oMpdLWzW/EZ6yNoTv6Knp9YRPdgWHI0WVk4e74I+V5uEix7mNPMPUiG9s4XVtjqBH2uJWOS4oIXCzTCqcKhZ8BAAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhiling Zou <roxy520tt@gmail.com>

page_table_check_set() and page_table_check_clear() store per-page
anonymous and file map counts in signed atomic_t counters. A page can
have more than INT_MAX read-only mappings while still being mapped
legally.

The global zero page is one example: repeated read faults on private
anonymous mappings install read-only PTEs that are accounted as file
mappings. Once file_map_count wraps, the next set or clear observes a
negative count and trips BUG_ON(), allowing an unprivileged user to panic
a kernel with CONFIG_PAGE_TABLE_CHECK enabled.

Use atomic64_t for both counters so page_table_check can keep the same
type-conflict checks without overflowing at INT_MAX mappings.

Fixes: df4e817b7108 ("mm: page table check")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
---
 mm/page_table_check.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 53a8997ec043..edd9d9edf6fc 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -14,8 +14,8 @@
 #define pr_fmt(fmt)	"page_table_check: " fmt
 
 struct page_table_check {
-	atomic_t anon_map_count;
-	atomic_t file_map_count;
+	atomic64_t anon_map_count;
+	atomic64_t file_map_count;
 };
 
 static bool __page_table_check_enabled __initdata =
@@ -79,11 +79,11 @@ static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 
 		if (anon) {
-			BUG_ON(atomic_read(&ptc->file_map_count));
-			BUG_ON(atomic_dec_return(&ptc->anon_map_count) < 0);
+			BUG_ON(atomic64_read(&ptc->file_map_count));
+			BUG_ON(atomic64_dec_return(&ptc->anon_map_count) < 0);
 		} else {
-			BUG_ON(atomic_read(&ptc->anon_map_count));
-			BUG_ON(atomic_dec_return(&ptc->file_map_count) < 0);
+			BUG_ON(atomic64_read(&ptc->anon_map_count));
+			BUG_ON(atomic64_dec_return(&ptc->file_map_count) < 0);
 		}
 	}
 	rcu_read_unlock();
@@ -114,11 +114,11 @@ static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 
 		if (anon) {
-			BUG_ON(atomic_read(&ptc->file_map_count));
-			BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);
+			BUG_ON(atomic64_read(&ptc->file_map_count));
+			BUG_ON(atomic64_inc_return(&ptc->anon_map_count) > 1 && rw);
 		} else {
-			BUG_ON(atomic_read(&ptc->anon_map_count));
-			BUG_ON(atomic_inc_return(&ptc->file_map_count) < 0);
+			BUG_ON(atomic64_read(&ptc->anon_map_count));
+			BUG_ON(atomic64_inc_return(&ptc->file_map_count) < 0);
 		}
 	}
 	rcu_read_unlock();
@@ -139,8 +139,8 @@ void __page_table_check_zero(struct page *page, unsigned int order)
 	for_each_page_ext(page, 1 << order, page_ext, iter) {
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 
-		BUG_ON(atomic_read(&ptc->anon_map_count));
-		BUG_ON(atomic_read(&ptc->file_map_count));
+		BUG_ON(atomic64_read(&ptc->anon_map_count));
+		BUG_ON(atomic64_read(&ptc->file_map_count));
 	}
 	rcu_read_unlock();
 }
-- 
2.43.0

