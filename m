Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ECA606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vhor7iBS
Received: by kanga.kvack.org (Postfix)
	id 088836B05B9; Mon, 23 Nov 2026 09:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065B46B05D4; Mon, 23 Nov 2026 09:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7A36B05D5; Mon, 23 Nov 2026 09:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0E7D6B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:19:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CC90C08B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:49 +0000 (UTC)
X-FDA: 85466592498.06.5E89C9D
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 74A8D40003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vhor7iBS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443587;
	b=MXoYhmmJXaL16Fq3ygt1AiM2LqwBMc0t2od4ZIAqvfutPHrf4V6GGIzhd+UCAuV8bVawsA
	zP74KynC22jtibctEyip3jLoMupYZZB5qLceTA4DEDurvTiOdRPOLliv2Iv/y48i2wQ4yc
	mzg6OdlYCFEcBQVHpHBJaa9XQvbMWxA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkfpB6aPJNVrsOpvuqLtkcdraYbSYI467HC25kQ7nfA=;
	b=oT0HXPP+4d4tDJSjz1KU84A19U2TccojHlhlaAZLFfiN9eCTjFTQoguoTpPIYT+LbvqVCq
	5Uv4/K0ju6h7FTiHB1V3R+G5m1+AF3tLBK9cXFA9VSlRxh0/nLHpjhK6auWojp9i4Z3AyP
	TggjP00Wktasvm35ItgDUsi3yQiWSHk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vhor7iBS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-380b40312e2so8142454eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443586; x=1796048386; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QkfpB6aPJNVrsOpvuqLtkcdraYbSYI467HC25kQ7nfA=;
        b=vhor7iBSBW54ipNWuuqcCo7cdPBg2MJgJOHzradeZzybAGs1TNE91fKLi3wXfKGY+2
         2KbCnEHJ78SbBVFihUGvrNKzcqZ1MpS+4bacjF0y2QDnluczAIWZnP8YDoqyGxuveYLy
         DTc+PJYNO9w28ThrNqnB07QX83M6iDJBo9pCK4RSd6RWK4/bFJ3ayyimpCwlUaWLg/4r
         TOfArjfVTQWQ0tP7/iYppBH4gBx2MQWIIeyQ/eOVJkEKW7CA7gFtaiSyz+xtLWaLgtk0
         t0qc8ED7JXC5m2/LjfPKJr0IfOBZVVYqMiy4F/pqf3/XUfgHVryAhvjgpqTN6m7xjeky
         xRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443586; x=1796048386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QkfpB6aPJNVrsOpvuqLtkcdraYbSYI467HC25kQ7nfA=;
        b=Ke1/RlQW1Uxn6ezuA4J7o+M5lpCOshUIXORkUkJN3U1Ge+Ylqrw9c1gR5qw4PbtC4m
         iF49SxyJoke3QEaZxOWBaOmJiqaZyPBdpqEXh6MPAQXXkPpxJmHhBbO/9LHhXrz24LhG
         CM5wzuKIMILO9T7As/WSPhg1oFqXV+AEhzVAIb46gIMbYmFlDN4JgZyuzID4SrBjSra1
         ZT6i035VQ+jme9NdXu+x2mvPjp83KBYANTkT4W1S46krO6qyisKytjT6h7yydufTFi2A
         rQyIjymYrmMbJp9oTH+y5gX4qTqkc7qKow4joi71YUWmA5XfLxOnHi8+BHGIJrHX6gvv
         fzYQ==
X-Gm-Message-State: APuU4Z+KhBYGX0Ggn+A9LPn/V0DiggEb8VGlnNDMIa3xXnqoEbsW0cDV
	rXjys+rIGcs0oRn4U10G0T2jlrmBHddSuYrdMydAuJIBQcA5fjS5H4DxZrOOE4HM
X-Gm-Gg: AZFdTZcfg1ODolgO+6YYgiddliqR2N/Y3kf/JFxv8F1uoxTeWfwxtlNLCULbfVFVNCv
	hjwagQLM8jpiDcX1nGtZxs41xdMTn/NknRalZhYqkttFhE/USotIGqi2/irIX4LnULW0MDI9Rng
	CFWNQeF9mcfrbMGhZNKHozUzalkfyGkucVqZqHdoTQ0Q4UzB/TSrnpB+Z+FzXVSVRvNm6zZ1tAJ
	DjQ+th46sw9gxJ+ktDMjzmHrRiDAbsftfefd2OlhakSdr9ivoHlinxQ2OQRkpj/rdsvXZjJkgml
	GtZuCgM1IHg4Qlb59t9wJZSK/r5B+vbG5dtM7/PnZ3YoI56cZc/xudBBGqAnTAsuyYe8OjaQh0e
	TdK+CxjgZpqkldSLCNIqhYiGnhVD4tCRrL2bkhLpF979yNKE96vZktznbAn2B6su10q+QWpOJ8R
	meUp6MBcnUPVhIkgZK8h1jRQWdv1z57nip5Ag8dgRcpd5ESAGj6aZ3QI46gC+w6sLWXgv1C0vmn
	mGraeEW87lSpy79zvtdM8R2++b5CLPrcgyFLbsben73qa+9qoElzNmIGggjaMzRVaIEokNFjshj
	yFhv/nFXVOCie354ZtzA4rrhsxsYIhQMc3O3hM/dVgrWmOD9Cm/+Q52Ni1AjjmxINk8X
X-Received: by 2002:a05:693c:880b:20b0:386:b025:1e1e with SMTP id 5a478bee46e88-386b02522d2mr3390054eec.16.1795443586180;
        Mon, 23 Nov 2026 06:19:46 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386aa203267sm12602179eec.0.2026.11.23.06.19.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:19:45 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 16/19] mm/swap: reuse per-CPU queue readers across priority changes
Date: Mon, 23 Nov 2026 22:19:35 +0800
Message-ID: <227a1e9b7213652ee5eca947d2f1c3da88462dde.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 74A8D40003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 16gmf4agbten1e45kw3ttathicsbehay
X-HE-Tag: 1795443587-800651
X-HE-Meta: U2FsdGVkX1+LFHNUdn/rbOJc9iI/+MmvHv+LxaMWymgW5AzfauN6yNB7aZj2SJWwBI7J/JAFI2a/ICe/9pIXyuPHI3Pv6saCjYiXwAsL/2XYGiclDFNHcJtZr9F4Q2vAn8buyawXl0MO/v4jKg/kqCfKBZp23TPKk/nlVk9insr58WbMXWNyj86LQMn7NdmdEj+7Kbb2L6Xo4Qf1aMK9APdfiqJiVzbiK94dSR8Rc+RCF/pJj70VmkHj6XHNQpyF1bHHqlZwyoZSROWbQQApkEiEoTrLk5TRXZxJSzg46q1oJ/FocV0eIttzADxQJhxnNdgMAl3c6a7hjXFvkYVl718bIf7oHJxRhLckqy7hchQ/BR+ZTUq6zrS6MREza+Op89NyxpZAoiFxk5Bn53ck6OLdOYF4+Wgyzu7MzR9trg4Yef/G370eSaF204yaDv7wVUvgNG8QDgCqRbYxJevLMPhMDAMvTFPY8yy5yR9HwNGxm1Q+crjOogIQzeiBA7rliUjLLPmHyLbuG8VgfG8fOAQ57HsSjvb/5tHN2Q8KGZ3b1nr84HmXTaQbzWOQ4MnESbn7tocGbvtInK572VC4oBAqI1pxJkGSaL+ax/qbdepHlUa32qWfZc4ILtFybkHbqDAx10XzFGjzqh0t/YxzaJX0X+cVTiqLCImyGGM1ZmrSj4jib2X2uT4V/xSj2LBrsP+FKauzCo+gNAHatesQpGXiM0vduU4C/evFShDpSLruXJ7AYTwWbxMMl5LS0DJCHXhhVO+qrCKk4lYJwmBwCg+q437kADMBmxQnZNzTqvHbAzJrtIV2S4r7BzCQh+ZIHddXU21XvcMGj37XbSTH2zGLsba60lCR7TqPGItcH9NEJPLtaI+ALU82jyKtRd/cD79bNamnmnaCSNcLLe+966OxJDoBVN4CIAm5EQK/13s+8UIzkdzXkfOM0td/hb7aePXpmywFJrMhJHm68u6
 tjUoTm5z
 HFkONvyMZE0mqr7BT2M7IZVtqdVgJcZi6DUm/VmQfY+jNR5qpMHl0jRPN5HtCFeGjxdkJ5lOShMHznyDutV2DqW//5YP4Y97geRZBEBM3Il2/yUJwSrJh90iAgDtYD+mabVcxXkEpholdPONPDzTdm3P8pmJClflCpq2gQVWkKaYHxSMB3wJ/ByZSDghtga63AaLXqw4ptesQXx1s2WX0OWl7JsXZQsF732S583qIe82o9uoB0Vg2Nmuw/g2+Suq54+cXqQiEmDLzRmWfMfj5btIo3Q7rpBsXF1qC0r2ic0HH2ZDOefucpHArx8bVRsIUGHVr8TirZBSV50jwJsEpvQA8C9K/Z00Ou2IthEzPHXIim7Rl5WHaZ6/wvwKD6ltOHZhYyhxh98dnHQXIMq21HSbbyfvg4y4GR988h1d+937CTrWyVRv4z+AWCrP9LE7u0LFoB51oRw8T/oaMk33Q9uX7BtY03RW0awYxfAQ28lcGTniTjfl1rA96A/u3gTQFElDWh7LTOThE0T6QUId604S7e6IBE8zu07/uTuQNr8MEVP6V4a4dbzg3S6TJUOVkT0YtVxYMM3LEXUd8L4HvoYg2dkJu8d0f819A6V7F2D76y4BMAA4BxMCYz5OL2qxvlnewflgmkI1gWtMwGC5j/YhInM8Mk61PI6iM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Inserting a new priority allocates a replacement per-CPU reader array
even when earlier ring removal left enough storage. An unnecessary
allocation can add swapon work or fail despite sufficient capacity.

Track the installed reader capacity and retain its high-water mark
until the queue becomes empty. Reuse existing storage when the new ring
fits, initializing every valid ring index for the new topology. Prepare
larger storage outside the writer only when growth is required and
recheck capacity under the writer before publishing.

Preserve the existing prepare/install ownership and failure rollback
protocol. Device removal continues to avoid per-CPU shrinking allocation
under the writer.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7d932035c961..0c4452fa53ae 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -201,6 +201,8 @@ struct swap_queue_cursor {
 };
 
 static __percpu struct swap_queue_reader *swap_queue_readers;
+/* Keep the high-water capacity until the last priority ring is removed. */
+static unsigned int swap_queue_readers_capacity;
 
 static inline bool swap_device_masked(struct swap_info_struct *si)
 {
@@ -240,7 +242,7 @@ static bool swap_queue_needs_readers(int prio)
 			return false;
 	}
 
-	return true;
+	return swap_queue_len >= swap_queue_readers_capacity;
 }
 
 /*
@@ -288,13 +290,15 @@ static void swap_queue_reset_readers(void)
 	}
 }
 
-static void swap_queue_install_readers(struct swap_queue_reader __percpu *readers)
+static void swap_queue_install_readers(struct swap_queue_reader __percpu *readers,
+				       unsigned int capacity)
 {
 	int cpu;
 
 	lockdep_assert_held_write(&swapon_rwsem);
 	free_percpu(swap_queue_readers);
 	swap_queue_readers = readers;
+	swap_queue_readers_capacity = capacity;
 	if (!readers)
 		return;
 
@@ -430,7 +434,8 @@ static int swap_queue_add(struct swap_info_struct *si,
 	}
 
 	/* No ring at this priority: insert a new one at pos. */
-	if (!*readers || nr_readers <= swap_queue_len)
+	if (swap_queue_len >= swap_queue_readers_capacity &&
+	    (!*readers || nr_readers <= swap_queue_len))
 		goto failed;
 	new_queue = kmalloc_array(swap_queue_len + 1, sizeof(*swap_queue), gfp);
 	if (!new_queue)
@@ -458,8 +463,12 @@ static int swap_queue_add(struct swap_info_struct *si,
 	memalloc_noreclaim_restore(noreclaim_flag);
 	kfree(old_queue);
 
-	swap_queue_install_readers(*readers);
-	*readers = NULL;
+	if (swap_queue_len > swap_queue_readers_capacity) {
+		swap_queue_install_readers(*readers, nr_readers);
+		*readers = NULL;
+	} else {
+		swap_queue_reset_readers();
+	}
 	return 0;
 
 add_to_ring:
@@ -502,10 +511,9 @@ static void swap_queue_del(struct swap_info_struct *si)
 	}
 
 	/*
-	 * Shrinking the small topology arrays is optional. Keep reader storage
-	 * until a new priority is inserted or the queue is empty: per-CPU
-	 * allocation must not run under this writer's noreclaim scope, which
-	 * can grant backing pages reserve access.
+	 * Shrinking the small topology arrays is optional. Keep reader capacity
+	 * until the queue is empty: per-CPU allocation must not run under this
+	 * writer's noreclaim scope, which can grant backing pages reserve access.
 	 */
 	gfp = GFP_NOIO | __GFP_HIGH | __GFP_NOMEMALLOC;
 	noreclaim_flag = memalloc_noreclaim_save();
@@ -548,7 +556,7 @@ static void swap_queue_del(struct swap_info_struct *si)
 			swap_queue = NULL;
 		}
 		if (!swap_queue_len)
-			swap_queue_install_readers(NULL);
+			swap_queue_install_readers(NULL, 0);
 	}
 	spin_unlock(&swap_queue_update_lock);
 

