Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9323CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B229B6B009F; Tue, 29 Sep 2026 17:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAA26B00A0; Tue, 29 Sep 2026 17:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12B16B00A1; Tue, 29 Sep 2026 17:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C06D6B009F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 077A140645
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:34 +0000 (UTC)
X-FDA: 85268151948.11.8851756
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf12.hostedemail.com (Postfix) with ESMTP id 382F24000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aoNAB+87;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3WjO8agoKCA82x0pDApx7wv33v0t.r310x29C-11zAprz.36v@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3WjO8agoKCA82x0pDApx7wv33v0t.r310x29C-11zAprz.36v@flex--nilayvaish.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718812;
	b=iB4GQT6ZGmQBfJE4PqT6w1O+JJowvUHkgVvOoQ2CwX2wdJMPw1K+Q2gvpjH9Kd8sfxOBL6
	wrya3W6yTdSnQrTuWx2Df3ItmQTUcxvLopATNt4Ul72lTk4MJ2yfOEYj/E+BVi5XtNR4Hz
	KbJwub83PrN1Q5B+pdzjas+owFavWqQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aoNAB+87;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3WjO8agoKCA82x0pDApx7wv33v0t.r310x29C-11zAprz.36v@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3WjO8agoKCA82x0pDApx7wv33v0t.r310x29C-11zAprz.36v@flex--nilayvaish.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nuLNuJ1Z55MoJniNmyjLk+CRKY+iECn17Vw6UvtIrSs=;
	b=8gzl15WLw+YuS6t+FHf3xS3+PHYV+rZyGDfN6BzTTzDnmmX1spTkPHtQetn2fqm9HnNUL8
	u1RWRLNmHL9GD64aBj4auJbxEbS8k8BZui4iretxEdjf0oR3uiDRLGYWhgdX7w9jriu8tA
	Uc8NbabkVzWqRHT3bj4lK/85tJXFBU4=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33713e5e6daso6925154eec.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718811; x=1791323611; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nuLNuJ1Z55MoJniNmyjLk+CRKY+iECn17Vw6UvtIrSs=;
        b=aoNAB+87usv21B3g6C5k33ibcjV8Xc1vCDkm+DLFQ9kfYJuN1Fk4wiap+QIsp8pv9+
         itUEikjp2qI4/gGBVufK25OLWjM7603F2+/qq2nxInIT3Xyyw7AJdyA/Bs0ZS+iWBLRf
         yjCWIpuxyAqeFYWxOdgNC3t8vTEu3ebdzg0jHoPlPanmclVqBo8RC/07fZd08g0QRW1f
         Hxb9KuET/wih2GMTIwdz30D1YOxvlowAH+PslTXKEgTliGvQy2y9Z0NpXFHS7ozATvEc
         /D9/P+sXgGzp+BZXHPpcYnDGDJy6F9D8sKk1aU+zTZZidhme4HnMDjAvbXlSX61uDSQs
         6xvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718811; x=1791323611;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nuLNuJ1Z55MoJniNmyjLk+CRKY+iECn17Vw6UvtIrSs=;
        b=QHT/tBF+/qFVhLTbS4NMkz5MDtpHcwzHUUyZaiDzg9fQNqdfKeb7S7ctt4vEmbQVhF
         y9SdENGd/3B4aC1nVSiqVqY0KxYg3n2oqUmpmXgrqtCZjVJMh/C62nsbuZDlHC5X2Z5T
         gy8uoQOtpUnPfUHJAAHLm3Rg1hmQWS6x/ZjcfsxmbmcgQJgB6924e9TuJ8xemNlNju+H
         mIb6oJKkjVjaMspiN+A5Rxe9brj1msMdY0M+lWvfTjM6TuEmYnT8ps/7Hr0Y7kBGuPGS
         mQMz1pqHZ5Ski4NyiyFgXmhxUfBMWrKPUjAQeKeUPM999VJSQKQX/UUE6gcTS8oK1Ocg
         uY0Q==
X-Forwarded-Encrypted: i=1; AKwUvBywFBrb88S/3qKcD7XZgHjvjV3iIYqI/Ii8jfyd0sOhmsONnYC392Q0luvOURxNb+3K8eFgszj/Og==@kvack.org
X-Gm-Message-State: AFuF++kJm7yPED28S1MZyFE8qD3X9acdZdf7cUmAjbD+L+yKpofNBp/S
	2j9eXhUW7VkS1+pMj3rZvqj6PyyDV2GNNx5IGB28HogqHVV+mBc0+xWwzQUNLegyNz+R+6wMsMx
	Hw2lX7RJL08BryHmFD5VnOA==
X-Received: from dlbui24.prod.google.com ([2002:a05:7022:3d18:b0:149:cd53:8931])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:f693:b0:149:cad3:302b with SMTP id a92af1059eb24-14c9feb75f3mr759810c88.34.1790718810620;
 Tue, 29 Sep 2026 14:53:30 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:52:01 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-11-nilayvaish@google.com>
Subject: [PATCH 10/15] mm/memory: use folio_page() in fault and CoW paths
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: qs5hr57gtyk3c6ofdq8fqxncwegz7arq
X-Rspam-User: 
X-Rspamd-Queue-Id: 382F24000A
X-HE-Tag: 1790718812-760391
X-HE-Meta: U2FsdGVkX1+UyUEZ8zm3wxCTW2zX0qVOn/Q4nGMRwdsm5j6H3ApwUhZU9brmgfiDIpF9y56RQ8pCxxe5NhYF8QUhAXqcJ6N/ddHtSYXkPfclFAqs+W+M1QoOlVCVYrjKH5i1wD++Hqfi1Fx0XD0M0fRo1K3RoOMhw5x9ukNyngOXKj41O1xl94++pPPPsDb6e1UPWfD6btnkhJEjRiiSITOQSmCbmfdNa3+p2PFBmJI0msQ0YomGxtxLTLAyN0UHJDxMZB28ZkFcvWipTty4G0clDzQMgZtxcyzNcvs8ubpjzvU2FstxvdNykst2Z0oy6hm/Q7nHit6aht9RYU8fWBMnXP5Yga0DCl4iGH92SmWEHaP49ziI/QEFuZ0TncUvbOG6DFZXQ0ScHxSUTwo5/SLqVpVNx/5KXDMsKXYjarKsDzHVp9FPrEkepOZj+btBbRE9hOapaWqhbQXTjZjvriGMOSE07qViUwXpeQh663UZZi+JXhDHAiAbThGdkGxWNVBUedrkKc1HpfBkB/8ZlgQBWi+eCjK8pLdd+dnfvsCFGsXXfyCKPIoYYTwGDNOB3ENMyQZ2ShAcTbLOJnli6auLDXdQbBxUa6aQyshvZUSox1ct0tPsVsp5yPq8JC3IbFIkqAiZ2frcXF7VqWo/JMThcks4R6tS7DE4kfB4j26dxartj2wQRI5b1g+HNTPw3UMJxEB7FFOCHOD/ZCrK6yHvm7wX27uJ5A4f1AjJ/HbeHKLSRNxKT4reChAW+lrOunpAf6bAnVdEIDD2rIsRt9gP98YS4pticqvB/Lxz3Lk1I/bQvUk3LZhXDXAMzEpA0ZNmDCy5/soDE3wQq4q9T2+e7cZKVEoTpxRvD55+0mSB4swCs7W56SW+sb/06447aRISFjnVgftnQiRi9sdHkFblgI+yaWsBAqE/XDND+1br0vrVIlcp70puf3rFkhqzlVGfEauCyy/2CQdnkcn
 IHkGOjjM
 TRgBqqKhrJ7++RjA4L5IEK5MNDo6vzjPxUGvaQ4JLrkgFBjiwKYqCzbeHoupnU3Zy4Idf/l5jC+EIg56hermBo1aOwuCZ7rvKj0BmgKfOgizM0em1/JHqOnHz6vN3ioS8003SoQbPWIYVfSiGGJ/D5ZjzUUPdWOetyLbj/1uglZ+ccXYAhnf2zW+g4zo70wtBaFvYaf0Eq3n9dugA0WLl4tOAOwpdbamSuswsv5FTcF6mLKBEDCX421fC6IIQh6kPClmn/LBo+rii8J0s0QC7kz0dJLb2sDygCXMnEpbaXtG2a/CKYbY0aoYTgWU4WJa2tf/PIT89IW/Akb/KgPLkqHBXJlC2efd6JPguOnVkNh/98wyPHD7jFudfIDGE5KtH1IWMbPiWPR+AdFFTyP4nyZrc1IXypkaZmps1dRzTXvqlHbS2J2y8onNWNnrHDo/q10avLCN2F/6QBD1CzyRzwtL7pDBYDvZ9QHZ0Q0HEVpNdrKjHU6+VcRlUJJN7rE0UuDeOnI0ykv1bAOLZMzNs3Tz2nmdPinh7Vl2jWEZbqzzyV/L3wstjYWfRFZrXXu8Lb5J5SoJ+ab2SqVIM90mrPl9SPtDFiIVyQRzvww6W0Y7GVvfaQQ+bJUVUGcgxnYBHEmLaT6pjhxKjcS72PI6D0B97vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace direct &folio->page and &new_folio->page uses with
folio_page(..., 0) across copy_present_page(), wp_page_copy(),
do_swap_page(), do_set_pmd(), finish_fault(), and do_cow_fault().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/memory.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 330cde31bf8b..9252ba338112 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1098,7 +1098,8 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	 * over and copy the page & arm it.
 	 */
 
-	if (copy_mc_user_highpage(&new_folio->page, page, addr, src_vma))
+	if (copy_mc_user_highpage(folio_page(new_folio, 0), page, addr,
+				  src_vma))
 		return -EHWPOISON;
 
 	*prealloc = NULL;
@@ -4073,7 +4074,8 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	if (!pfn_is_zero) {
 		int err;
 
-		err = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
+		err = __wp_page_copy_user(folio_page(new_folio, 0), vmf->page,
+					  vmf);
 		if (err) {
 			/*
 			 * COW failed, if the fault was solved by other,
@@ -4089,7 +4091,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 			delayacct_wpcopy_end();
 			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
-		kmsan_copy_page_meta(&new_folio->page, vmf->page);
+		kmsan_copy_page_meta(folio_page(new_folio, 0), vmf->page);
 	}
 
 	__folio_mark_uptodate(new_folio);
@@ -5143,7 +5145,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		ptep = folio_ptep;
 		nr_pages = nr;
 		entry = folio->swap;
-		page = &folio->page;
+		page = folio_page(folio, 0);
 	}
 
 check_folio:
@@ -5697,7 +5699,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 
 	if (!is_pmd_order(folio_order(folio)))
 		return ret;
-	page = &folio->page;
+	page = folio_page(folio, 0);
 
 	/*
 	 * Just backoff if any subpage of a THP is corrupted otherwise
@@ -5908,7 +5910,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 		} else {
 			/* Now we can set mappings for the whole large folio. */
 			addr = vmf->address - idx * PAGE_SIZE;
-			page = &folio->page;
+			page = folio_page(folio, 0);
 		}
 	}
 
@@ -6093,7 +6095,7 @@ static vm_fault_t do_cow_fault(struct vm_fault *vmf)
 	if (!folio)
 		return VM_FAULT_OOM;
 
-	vmf->cow_page = &folio->page;
+	vmf->cow_page = folio_page(folio, 0);
 
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


