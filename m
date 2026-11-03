Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCDA606A33E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DQ+szY2l
Received: by kanga.kvack.org (Postfix)
	id 2CD796B05B1; Mon,  2 Nov 2026 20:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D846B05B3; Mon,  2 Nov 2026 20:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8116B05B4; Mon,  2 Nov 2026 20:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF1D06B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:26:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AB6B1202AC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:26:55 +0000 (UTC)
X-FDA: 85392068790.17.08DD33D
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf31.hostedemail.com (Postfix) with ESMTP id E00B320002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:26:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DQ+szY2l;
	spf=pass (imf31.hostedemail.com: domain of 3WzjpaggKCM4v27032u808805y.w86527EH-664Fuw4.8B0@flex--bingjiao.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3WzjpaggKCM4v27032u808805y.w86527EH-664Fuw4.8B0@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793669213;
	b=S0yusuQIRRo5yrwEMsfg6GXM0W1DkyLDF04ZarvV5YN2o95vP1IYy3Kk3vkdTj6ItF0NMY
	N64COabvYkWg3ojlMV308lEEnpPp4Qfq8s2bLGpneUyn1Ti5fILjtJSikDrB/Q20rT+XlX
	W1Olq6j7hAdWMnjTOfX+25YlCVK7l5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793669213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEG5AZYobzy2BJMnua8HLclVLE5Vb8k6t/Lh9yPR9Is=;
	b=jcVPL4bFW/uGbxHEY7qN6aBuy8W7hYHCDPOHmxbp4i8eCF0XMo8riN7X5996oKpOr3ZktO
	5XmXd7QODs4kA8JtuTJiGyXjoDBljiyYf7mOHgJQXb8n2rnY5jEBDDXJALgbtfKsLSebjO
	g/jDf1ZnRnb17tf4/L9/xNI+wboS8X4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DQ+szY2l;
	spf=pass (imf31.hostedemail.com: domain of 3WzjpaggKCM4v27032u808805y.w86527EH-664Fuw4.8B0@flex--bingjiao.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3WzjpaggKCM4v27032u808805y.w86527EH-664Fuw4.8B0@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33713e5e6daso4394624eec.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793669212; x=1794274012; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tEG5AZYobzy2BJMnua8HLclVLE5Vb8k6t/Lh9yPR9Is=;
        b=DQ+szY2lRrCu7uMyay4kaskgP4dfRyPlg8G9LUGP9B/+UzIrGiiWrrM/UOTcRxvdSn
         8jurgLuNRVirGYdnDZZCPzxOD9wmj3e5yrY75k45rSx7XFXwLMwhnwjffgV6pj4pvjRO
         hOs1us/IGQOuoivOTJbkYcWLt9Hy7GKu/XuH1isAU05IrjYra97vZ6WptDOE54fOBLW9
         7RBm5qHRtoraRBOzKjKfz0WEcrQcsLWQ5NXwoXBJTPIHY+EzLp85I6rWmtXLo+8/8fEA
         2Gyo1ep+P/U6bKo3wqrYSgGRzUVbAE2vVICGshTbPQZoAwPdL6+I/1p9SjXdSffmP+uI
         wiZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793669213; x=1794274013;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tEG5AZYobzy2BJMnua8HLclVLE5Vb8k6t/Lh9yPR9Is=;
        b=EXDeL0wjL/wTIpiHSy+0p6qBNB1Z/HWUcbCtqmiDD0QjcP3BhxakzB/7JTsDFBXosR
         uRTuTbUXUjq82MyCW2n2S7NgSwINGBHUb8Wwo4nOrt8DdE7WB9sytX7FcNUanbm2h0oY
         asNkgz6A99Pf7F5P08g+5e7NLTaUIq9hx1HeEmgBq/eBASJEQ5dovKPCXt7WOV0cOREJ
         lq2rjCrDIwkmoAVZWxRs/DToElahZ7BictZ++8bL4T1S2SnKh7EQtu3y1HCp4/xuoD4l
         RmeQz+Y4yaUJ76zJl8sPPeG+gi+zu7ZDwweBrpTeENftxzM+XLamqz+oHAomVBMuosfq
         UzNA==
X-Forwarded-Encrypted: i=1; AKwUvBy07CbTGGiXxQN/5rl4+v+H+RSFQAp7RSe8FKKqa+WiM7tWZDdcCxBcKEQE7TNRjp6tVmEd26Z7Fw==@kvack.org
X-Gm-Message-State: AFq9FYKh1hK/ZtOnrRt8uWXaml0/NCdoeFzVGM2Mn2TSldww6Ya4Ox8i
	YvB0Cbg9wGTtXtY5pTvBXPnNP3VGw3Umnv5ajlx8lY7h175FeMuf8PyMCDhXRjIFYLwcb6Br2L1
	pSgh/QSEbTcVNiQ==
X-Received: from dybb24.prod.google.com ([2002:a05:693c:6098:b0:369:45ee:40a7])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:65d3:b0:36a:a10:ab95 with SMTP id 5a478bee46e88-36a423cd4admr19365623eec.29.1793669211866;
 Mon, 02 Nov 2026 17:26:51 -0800 (PST)
Date: Tue,  3 Nov 2026 01:26:25 +0000
In-Reply-To: <20261103012626.2699661-1-bingjiao@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103012626.2699661-1-bingjiao@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103012626.2699661-2-bingjiao@google.com>
Subject: [RFC PATCH 1/2] x86/mm/tlb: Skip batch->cpumask updates when
 X86_FEATURE_INVLPGB is enabled
From: Bing Jiao <bingjiao@google.com>
To: x86@kernel.org, linux-mm@kvack.org, 
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Bing Jiao <bingjiao@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@surriel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Huang Ying <ying.huang@linux.alibaba.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Chuyi Zhou <zhouchuyi@bytedance.com>, 
	Xie Yuanbin <qq570070308@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: ppfdq8yf1x3up5t1phtbgyynqhm4rcr5
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E00B320002
X-HE-Tag: 1793669214-443816
X-HE-Meta: U2FsdGVkX19GwSqMKhA8K3eLW4xD09V/dAjnlPX0da4A+RuFbeBczPuipOvlZJ+LxFlwQ6Xh+GP+BtAXQAFfZNRijJLehHEjv84tAzW1vA47HTTTOYAUG43jF47OJivxGGzI9UcJfyeBKUDx7xqUnLp6FnG3ZjCO+yigaQBvNk4JIRE7Vk8+iYR1i3mAARdO1pAyIsSDrkdRVnnKT92k6XnrKBkz1TfNG79UMLaPhdNfbkefgSSyejslVEQccenrPhIMzVoZYnURgXSv1d2IiOoxQ3iwMLU/4O5S9BhlDwbVlWzW9A2VVWXWperXq+vZxDjj9fdm+bv7YgACU2htemXwkrS0RUOJxZY41rq0KVUhuKlK3NhzTzMjCkZNCnEKbJpYeS/VfflQ7XP3S+r3vSTBUXsUM0Y44IvA99UrYwjYmVmGw1M8rCtp5Zg16TAGqmS2wNGLLRN9XxRkgFa2Xq/a9232t5/Q4uxevdDfqOhfdkbkE2+ABoOEkD2qYlvvJh/mt0hbsrIyVZfl3im6PQBRDPWyQjEtnWkHlMLc/h2xjFK2+Ge7qZIzBC6dx0rEZHqrOszzgEOeZ/UTOkkCh1vJY6DNrf5ivXWBHjVNrzRMb9ewLbfdiV4vkV3ZPzq3E115GEHM5WBaY0oHaJGZX3zCVPby0cJ4ZnLOJOBSnB1HEOW7zqVW3bkjBm95mwpgM/zxDeXWLqGwKjQ7ywZdm+0uwafiE7mp7oKOxUUh3I9Def3hMLObijhowzB1VRZKjsg/ed5EVFfR7O848gAKTvGgR6lZIz+LxE97BHeQUmBEJjSrcy4DICTys/16ueuR554KhexFKWsRX/4VysP02a6Rxfm6nONTVfsjdXiLT6FYqmObFZXdAqsp4KEibx8pzFAc6YHxisZMGLdp5eJp717RqointT2HeRq7I+EZ2aaqxrTDrWHH7P069Jt38x12sLS5FsMx1FszE6/UiTx
 0BqPeEbT
 ZvdUx5+haYYB55/j9JxGbHe3D57AWQpXd4VehuPfm5nVVoH1X47LgO9qoCJ32UUZ22qRr0kdQ7ffo9RuvzPFaisBHLJDQCh44UG+WSApNn1znWapzP3pyWoZlzUzry/NHNtwDy/CNKapb3ytDsXLiPyF6CAkX60B2saEeyDW8dnTrMcKSUzAVeKIvugsjZ2IVHg7X0Ok8JBqX+WovYyuYauS9zM3ZPJcjLOdZ0IMT4jKZuSTMeSwDy41VfKZgopXIFTrV/a4tfKLx/4C9a/v/uSjCQI6yoDj/11GyrUgiubE8aXwrJhGJ/d8c3KUryHLW79wGVsOeG4SiERIy2UT2Lnk9OhZopUK6pytz7epwQ40BNlRGy/Wnob/kjGMOHgi1GiG/kmbw7Uq/JvYmE+JL9MRgVG/wCqtEqPANv0ecTnPpE8CDjO2X1YeU/IL+L3MNoTkXbPcHMgBdXZGfK2iXLSnByneThsjdIVO8ooZevnmKVi1AqunhJ6TJjQ9R15DGdns0y5HkqFnNuYiBJfX3iTKJ1fYRc4yVGhM38HxI+pIz6fFfaQ76kfh1ipB07gjYO7v23pk9Gq/O01qoc1QCvBQszAHlVgyKWTskIbn9GxrBxDn/oeuRc7eG1yMfnh+99IktYLSPUuLV4cTAugejmu/bYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 72a920eacd8a ("x86/mm: Use broadcast TLB flushing in page reclaim")
and commit 0b7eb55cb706 ("x86/mm: Only do broadcast flush from reclaim if
pages were unmapped") changed arch_tlbbatch_flush() to flush all
non-global TLB entries via invlpgb_flush_all_nonglobals() when
X86_FEATURE_INVLPGB is enabled.

However, arch_tlbbatch_add_pending() still unconditionally ORs
mm_cpumask(mm) into batch->cpumask on every unmapped page even when
X86_FEATURE_INVLPGB is enabled.

Guard the batch->cpumask update in arch_tlbbatch_add_pending() with
!cpu_feature_enabled(X86_FEATURE_INVLPGB) to avoid unnecessary bitmap
operations on every unmapped page.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 arch/x86/include/asm/tlbflush.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 70098d448e99..4ec71ea0943f 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -379,7 +379,8 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
 		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	inc_mm_tlb_gen(mm);
-	cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
 	batch->unmapped_pages = true;
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
-- 
2.56.0.385.gac671c819a-goog


