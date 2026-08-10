Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B72C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5065E6B007B; Mon, 10 Aug 2026 12:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE496B0096; Mon, 10 Aug 2026 12:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE7E6B0098; Mon, 10 Aug 2026 12:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 134B86B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:02:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EE23801EC
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:02:45 +0000 (UTC)
X-FDA: 85085827890.29.7B0016C
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7A465140008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:02:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mVEyaR9O;
	spf=pass (imf09.hostedemail.com: domain of jannh@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786377763;
	b=ggv1ebw4oZnEYveu7e+6sgGCdg+UgnMAnQJDZCakG8WnTWV+ehBcg2UnLmGr+tPEqCyBI0
	GCZF/HFykU4Z2V0LtLLexvnb6U7qgg1ZBQUA8Cc+br6i7bvVMtL/2tYPm2D2g+vV7ojwBf
	zUIzaapbOC2jjlfSXmXN1prJ49IMGDk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mVEyaR9O;
	spf=pass (imf09.hostedemail.com: domain of jannh@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786377763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qhLgQ0D45SllBgldcORYJCsFM4ePRReZjhBNf0nbF4o=;
	b=LftLk27InZcbv+Kazku1+sXxw+CeP4Xhs5/nbMnqSZ1hMCjvMyK/uJV1NC2f83uYrhp4m7
	bYCybmAAw3MKfHh9xSF6ZqRxW7WD7iHAYwjGV4C8az9x7iZO6cDdT2IF2TmCwo9JPdhrqw
	JKsrCYB4UmWFynDyctJ10mtHq11MPIc=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-495509b08ebso75315e9.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786377762; x=1786982562; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qhLgQ0D45SllBgldcORYJCsFM4ePRReZjhBNf0nbF4o=;
        b=mVEyaR9OUX3Re9VL7JGbZqycW2+YFEMSmX59bTdwMZp2TBkt9RccVkCCoD0aOYaaoY
         3hDdsBpn46Gqy427KFa//jZVL2dOcxkaWDfZ/fSxqq/gsmaraz6dsBAwRiZY2QeFomc8
         /3o+v0HtTOUAF1jFF2yODn98xb75y7fbCq9z3P0SJlA/QUD9w4d4cvri17/zfejNxQz7
         jjFGVp4Yaqk4XX9lvJ5nJCHMlq32IwpSxNVFcZZt5HjpM/2QZkLVBhx1T7LRNLjgBsdu
         EnK5dSeTYb0DBZXwLWliyISIlNJb5GXLMdsJanwmvdzeb5wbtQ5UTl04FFRM6szXSgJt
         r0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786377762; x=1786982562;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qhLgQ0D45SllBgldcORYJCsFM4ePRReZjhBNf0nbF4o=;
        b=qaJt5ivJaJQsqiYDidh2ED8VpAimrGZKoyMIvbYubevX0KmraDjTOfsldzuFp6Mvpy
         UPDrECalIqfX4ictunEeleufF9rWkKy6U2OUaW3u7OH38kP8t9YimlqUi/wxH/FZo0JQ
         oJ0OBQpxq4ilEqfA4Njm3r4dBd/YK2ON71R2Ryy87wReOPpay2+cIh5AeLPCD4Tinhri
         /1R6t2vPVox+PbMqpMhkISHpbhAK29RUQVLBocgN94LAZhBc4bVu8u+whQq1ZUlwP7x3
         QTiwdxZ2ybyLP7y+xp3eFaRXuBHtI78AJxPsFkIT0R1AksvizHVneNZVY+Wpw6zRDUE/
         7gPQ==
X-Forwarded-Encrypted: i=1; AHgh+Rroj3JURGUzP/HDPCZu+CTjxMRmhwyS1WDnb8Z41yTNofn3u1+yEd5aPpYnsWkaHHQI5gBjNLONyQ==@kvack.org
X-Gm-Message-State: AOJu0YzppMhkjyEUQizZbkzdxHR/DtpWAtrZjglkozbw1rWjmegBhtJY
	eIad/VOwWFP4P5cYPLAgzSJtXfkhIhw71t3DysriYVLuo+bS+pHwtRbP8aJM4bxUOQ==
X-Gm-Gg: AR+sD12Q3G/KDh3tj9Xut1dnGCd0t8VX5w523669r9L7El0Pt/0Dxr+LWUJo8MeBVrm
	fEtvqYlLpnN/yNU5AafdQrY8LToTs4DqVUTs87Y+ntZDN0tpgJNndeuPx4icyo4lVHcWLViDhhH
	KCQ9vclcqiX3kPiCglHXR00HrRbH0zIvfvmWGIBYhvaaIHMonOu3bQHWLSoOQdbBuuInTzFyswv
	H+XQjy5XYlYw/o92nZlBFPMfJKvy8hyEr5S5h2C5pCGB4EXzjPiErwk9I/YTYxntyrPU+qm+lmA
	OFEd09OpT3PcLGHYEmlQFnitW6z73HhPJNJOdw9yFbJ49udLeSyRZ6VJmTARFzgi2UmjB+POprP
	Hd13R3JJRlZUFrxFEEkmArV2+RQ2WtyzUhSIfZqXUTN0H51nBwpS3xAphviuAt30GvBPSvfEcMG
	x8gVqNyW1K/PKVGCwG1O8g/hCNvtMyqHRM0uFKJMOEkHypQoNZbDnxT5AcMqF1UCaxEf5jJ8tOW
	behejmMU9XoFoX/+Cmx1OOqbk2hqNzAaee+F3vSgfTIVoE=
X-Received: by 2002:a05:600c:3104:b0:499:5ea5:e493 with SMTP id 5b1f17b1804b1-499624e760dmr5065455e9.6.1786377761425;
        Mon, 10 Aug 2026 09:02:41 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:5c4:b02b:cff6:9cc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997414694csm1912625e9.9.2026.08.10.09.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 09:02:40 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 10 Aug 2026 18:02:36 +0200
Subject: [PATCH] mm/page-writeback: document folio_mark_dirty() locking
 more explicitly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-set-page-dirty-warnings-v1-1-53cad4890808@google.com>
X-B4-Tracking: v=1; b=H4sIABv2eWoC/yXMyw6CQAyF4VchXdukw8Uor2JcDFCwLgbSjlxCe
 HdHWX4nOf8OxipsUGc7KM9iMoYEd8mgffkwMEqXDDnlV7o5QuOIk097Jxo3XLwGCYNhSUQ9kau
 KewnpPSn3sv7Lj+dp+zRvbuMvB8fxBT1K+Ht7AAAA
X-Change-ID: 20260810-set-page-dirty-warnings-4000f0015394
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786377759; l=2162;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=mY5dttTZkk9K2JmQQlLj1BdPvr/NSFG5E3voNNy9+fA=;
 b=9kn4rcVcxjseP/S4RDeNfmc1tWpkZOGT4r8SzeLd1xxvUvuCW2V+reGRw2JoOP3ojpaWIqMBK
 llt9D6UHcHNB8JFvkojIuFXwLbr7wlOPp8DG5xVzoqdEhYDm27GdKPL
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: 7A465140008
X-Stat-Signature: xfckhjccrymwitzjbzeaq1bjsegk5hna
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786377763-532929
X-HE-Meta: U2FsdGVkX1+dQAknxo39ILM+iITToMRTyrcYkEdn1GkL3a4cC8UYIVzwKqh6Y07obyEbSW/xELwHQtiIvWfSHp18ls4HuPxnh7p8d2VdzI/UyRgJidc91DbSpOnTPT5mx7qFgkS/RqwxvHIANcdBv7jIOv7sZXl8wUz++1hEk4r0SywuMHP4tbzCJuBHkBx6ig+9g27gBJGH2mOJOGfAwsxDwisjIHc50OJy9zqQAsUIC6fIR9m5szBcqG9YARTO4q8UU/gIUHCFsAIfXgIcUAgnP1mdXP+9q7L/pT2iqFZbPHNh+leJ10pCbWUYqu2A1OaWukwMU3cF1w98o701AeRHQvUBslzOEFu5InvKW8iUnO7GH04zRcEJI3G2ZYgA5pRaS5oGufaakgkabI+xkPxXgu+3G8I2FG+V1R8GGeRKsfoJ5g4uvOeVGCeG4DonBvtQ3KfXejIABZBSvFwBaDQKwiYHyKhYScLjmzwp7bxfLlkfmd6aAoU8rs2OrgVJd6uaWGhKjcgX2rn3Vl1rSLs2a++H/frMiT7wD6eoxrW8PqkirefSNShAzxI12WTNB39zQGzsORILSAPfhI5qjC/rMoyd1w2okf45ELktQM+jwRBX3HnnI2pjCnTBLpNKqhkNp4s+Wwq7O6ohfvELoWjh/NYKPP+rabKS0zdkDf7ab1oTiP2r+vYvr19/VoXrWLszvPp8rldHGeAzaVzipThE2XEkkxQRAtmxDIF1z7pf5l95AHmdlTsYnV2PHQKvO3fGa/udtWIIThmwffMlicWaBgGKSDoivaVGTe61aD9YuryPeN6lD9RNWqelu+OYpVO6GeqR1XH6x+VzH+JAp6ZvoJf2v/5kkdEdmVh9dIunAdvnQbqPeGKeD//sCIkfHIA2i831D3fnHKwuhS2mYLKP0jAF0y+fabY4p173ZChoVvDJXhhBNmBP25TqKwlgsnsYr56WBwhzivUduMc
 YMGn47zI
 Qah9PM/VXtYjj8IQXv5yP4Tz+yf3rTrOITAsQaTb9dPrieWgs/+e7KAr5L2CFBz7feUl67Df07kbSKHTq+bfZiDFNNfcazkeI3lmpD0I7tvHc1RbzJlrEpGkcyZNtqJfO5XxxYrMB/M3II6vgQHgaAHllNrxcYGuYG7OHw29HOsV7d55fsGdmd7RqdEJ4tgLhBw5CwZxU9QAXRAlH3q63eevQBmQrGq/UpN+uKtpkgbqLGcKUhv/tdL81K/u8ClgfXVULQvj1rw3FzeFoijZdul309xVRh2GUkp22dDIn688FXi0+V87zxP9vaEi7DD2hWJzZKF2o2WOTTf1IN3Ne3eIwcFkoPERhUj4t/ChXq7COOwVeDltzjcYHhWcK4/dMmPMbOlRSu3Ao2TT8XMKKN2zmJI3Y5eu6pSmHgp/EwevAKfVX8yKtFh7wO6LzYYYtzybA5U07V3SXjV5FMGM39LvMUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have found two out-of-tree driver bugs in the past where set_page_dirty()
was used on a page from GUP without appropriate locking, leading to UAF:

 - https://project-zero.issues.chromium.org/42450908 (in Qualcomm's Adreno
   GPU driver)
 - https://project-zero.issues.chromium.org/494546491 (in Google Pixel's
   GXP driver)

Today I found another instance of this in mainline:
https://lore.kernel.org/r/20260810-x86-kvm-setpagedirty-v1-1-85f180892d4f@google.com

I think this shows that set_page_dirty() and folio_mark_dirty() at least
need more explicit documentation; so add a comment on top of
set_page_dirty() and make the comment above folio_mark_dirty() more
explicit.

Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/folio-compat.c   | 1 +
 mm/page-writeback.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index a02179a0bded..6212fdd6761a 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -41,6 +41,7 @@ void set_page_writeback(struct page *page)
 }
 EXPORT_SYMBOL(set_page_writeback);
 
+/* Read the comment above folio_mark_dirty() regarding required locks! */
 bool set_page_dirty(struct page *page)
 {
 	return folio_mark_dirty(page_folio(page));
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e98748112d1e..b0ab687c83be 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2773,6 +2773,11 @@ EXPORT_SYMBOL(folio_redirty_for_writepage);
  * in this folio.  Truncation will block on the page table lock as it
  * unmaps pages before removing the folio from its mapping.
  *
+ * .. DANGER::
+ *    Do not use this on a folio obtained from a function like
+ *    get_user_pages_fast() without holding appropriate locks; you might want to
+ *    use set_page_dirty_lock() or folio_mark_dirty_lock() instead.
+ *
  * Return: True if the folio was newly dirtied, false if it was already dirty.
  */
 bool folio_mark_dirty(struct folio *folio)

---
base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
change-id: 20260810-set-page-dirty-warnings-4000f0015394

Best regards,
--  
Jann Horn <jannh@google.com>


