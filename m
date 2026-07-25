Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 641E0C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 13:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383286B007B; Sat, 25 Jul 2026 09:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CB86B0088; Sat, 25 Jul 2026 09:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A166B008C; Sat, 25 Jul 2026 09:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D47096B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 09:22:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 317F88031A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:22:30 +0000 (UTC)
X-FDA: 85027363260.06.1051447
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7E03920006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:22:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ky4QwzGc;
	spf=pass (imf03.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784985748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8V6nDAFq04ExKfk2MYmWny5A/bytyCIfag+WKXl4F4I=;
	b=o80Ii9yPtq4E5AzQAVST0AI78G4sNInY7l/cb54nhRNvuSwf1ABqBeFhnODs5FFWqVtOCV
	ltTQs3s2GBwKHlH90QSEWLc/+RjlrIQaaKl/mFUEUKLGQrDIJDTvaQz/ahXcraSucSpfwa
	05BV1L+iKf7/goKESvG8YCQXJCbHyoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784985748;
	b=eqJ1S8kbjcgcPwstAG6IJ+XpqYT0bvJx1CmriABiwdNn8jQ4rzJV7BcLRCeEar5Ev6wixy
	aGlV3/Z+URDiEM9r4+KdGiqyXuIy5lci4XnG4mGiR4scQ3B8ydIidWmJ8QnH+Pi7OL4ULm
	L7SoJnFvuTI1dziVQwAW0EkEDE0YJPA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ky4QwzGc;
	spf=pass (imf03.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-39b22d0e488so12425051fa.3
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784985747; x=1785590547; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8V6nDAFq04ExKfk2MYmWny5A/bytyCIfag+WKXl4F4I=;
        b=Ky4QwzGcwH47ntuFcTP5WuvVzNjRizu2L+/lGGSs3Y5sIrMCRXtjE3TY8lVmYb+thh
         a0zokbGR31CqV/llfZWChCYYfWdJKNjFaVtkIs+KRfqZUt/Acj9sLceokS5RviERzz44
         ApGNmtl+oOPsSte++noWLXftF5k19xMY31YFoeam2Jaf0ZCpw4ArcuzKMIIneA0XAp7D
         oHkIb1JGJTjYxlKDtvGaUUm6/bRwcP2jJ66glKyQO/EU2rCG5H+BmKlHMnlANPhshmdZ
         Mqlua3xW8MA/mWlwhK7TvTpj9225yMsk1DAhknNixoz+FONiyauNvnQ7jkBnnM9Hh6Me
         bPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784985747; x=1785590547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8V6nDAFq04ExKfk2MYmWny5A/bytyCIfag+WKXl4F4I=;
        b=hfLn6nDq9ZhTtuYlcAjE3vSdIoVeU80qmmKWh+Bs8tPS1Oe5h8QxR/QdgOXjOahDGp
         BxKn7Pt96VTJWIFgwCUdxCB0/xWc1JhjjI+gDHTU91Xfa8y5aATRkwb0FowJO8zqH/48
         xShbn72Rd9A2zSd+AxBH1SCpD41ATi6LMR40conRp4X2rlJTAtSEIv4/i/88I0GDLH/h
         lQY37drcjWoCiiUsoch07YGg4/7X/0vQdH7mNJduu2Gaf4ffgBvtADXl4r8VTo3x3rzw
         llpohdTdu9136EcSP4bSa3RMjDUFyypTT6qHfl6+4raKGaM1B2XsCeH35EZV9Xtdn1XS
         VNyw==
X-Gm-Message-State: AOJu0Yw/Ud75bCG90ouiD/F5E4b5cOuhJ5wDjutj4uBuGpCyokT2DSAV
	x5qUOtAPi3Nk9u03FJCevMBMfzJnzHCObdoMqjPlOxo9wm/2tYqkuum1GgIlP8tAGqs=
X-Gm-Gg: AR+sD10qj1LTqvmlOdxsaPCNKVhsS1Dar2kGYHPD/xdhNnnUf34zbW/RjjTdJtw9X6D
	TKAZznKe094ZpiGn2VtwP/Tnkg+Ebs5Vizatf6fOk610zjU0d+TBRtoo1eS+baNSdb7jDzGXUTD
	W7BqHJhA7Wz8pMub6cDlCW8ZOE9so1qnlEBwb5tq//BbqJI8ase6rfj9//OrLWyL06mM40txr90
	2kaNFo7bGzjwARSbtcMmQIlJTXNCEF5xPp7e/QA3WJCUMF1SM2Co6fyhyeZAT4W9brNnfL5OpQm
	qTvxAU1+sHNmSGDXl0bnRPh+UOpBLvgIC1zl8Xq1zloBw08kWWaAHHkgj6ZuvIUHo6GocHOR0uB
	K216KniCAmHL+TLQcIQBaht2x1npXSMQTCZXoJdyOdPBqH/0Bl3zJokbsdC2ecFx3YnkWeVar+O
	XyLF2vH7ajqhHkgmqVpPSRgke/Cnbvqh+Zu8Sp7pZ/bp+PibjgjchrTSdXE6kHStlksfyYKdQ=
X-Received: by 2002:a05:6512:31d4:b0:5b1:5e05:31df with SMTP id 2adb3069b0e04-5b2c1af7890mr413460e87.13.1784985746780;
        Sat, 25 Jul 2026 06:22:26 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2be1d8509sm417670e87.38.2026.07.25.06.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 06:22:26 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/vmalloc: fix 32-bit truncation in the vrealloc() grow-in-place check
Date: Sat, 25 Jul 2026 16:22:01 +0300
Message-ID: <20260725132201.88279-2-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7E03920006
X-Stat-Signature: hh64ruzm4cgmdt9xgeokhaceuy58zuyr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784985748-209416
X-HE-Meta: U2FsdGVkX180/NOAYvIMZIImWPSrdlzQU7E5dTo44U9JHljaBZztP8Uo6Ha82htPKi6nsBAWFFQF4gG2j6067u3RfSSp4nJDjfF0yM3pl3+gED3i1Io+bF/PNADip6IOxTTI0ySBNCsJ0jBaTNoBVG1r2xXB44QjRYI+GbjqR6vC+BiusfDVB2eqNYdScw6z7OGEX0yIO3FaRSHBr/mc20WYr3ctCz7yP6XVBTLIkB3yYTtATR3ze2F+kQjbvfSpKSqDq7bXTCUkFPIHKxVTOxeG9xcRRmQtAKSp+iM+/B2PbYkNCDLM80Q0DRywPoKuFnRbSUyx4EmU7FeKQVu8uGu184R5MHbu0ZWEjd8VViuq/qfJlGmZEsOYtK2863MORsRzqUePYghoaVVaCQSG1CaJtBxmgMulsJtX1oFljFXqO6JTDeV1P7+qPYFhmHreU5ccH6wRtujUdMLotbJTjFkp7gxcQI0y1ZeZoCWMf/y1r/L0a/6KCrx9cCKXEQiIA3F1DIcpCxZUP5+uIZwj1jo8dOmUIjOIeat9tkfCyy3rUjTdc0Bq+Xdnk8nqHFi6rVbK27lplMB9dI19r8wvtS5L4tBOcgcimG80xT6tnWywuPmZvXnD0FYmM9a3wf7Qgk6SXpzFJIGfhDhfZlBfdU/RopLacqR93BxmCyjSo9Oa7bxTWp2pMRUMMBy5dvG4e7tucMz98X+atan02mfV50DpUxU8QwDqYMKNKt1Ot0uLm3y+rYBcz1ld48mUYDpzbcoBWq3RS5jdOr2bmUEnXtqBb/P/BaE37OEzs1qh8J977jECDf+2V+OBrHjejOLW1x6zGsklVIum6cf01rB6y+EdMsBOQ21pgPkCSp8aolBOPbBD/DHY94GLmYttgS4bSZx26thacOSEJGhN+9gHtAOtaHq1f38KfS7V69Ti7W2CI+OJSTA08EJj+m3ungIkLVEKTqEaYdfT+RE/gPE
 KpVtRlhj
 Hd7079SawVDOlH14Q421fDo8JktNqS0E4rgi/ANnl5NyBuIP66fEgztnsD7iPLSE5Jat0z1jNeHyW2P+PFfwLO/b21B7SfvRdIrql0fIIlJ4eAqEXz0T9DGoFiwiWQsp+PsMY1edSTE9nE/9CzemMf+LUhamgI1PXJUDWgv/V8yyepXmPnxATN4OnX11KSmv/mHvg03E9trbmz6wHc1cvGhe1jnELHWXsBy6heRtMMvwzPnORP6bDT7LthpGrHbfqQHkgDr1x08h5qkjul0NsYzZCgW/wQOTk9+qj91Rs0wC/qx7F3ogn6FfJbObmVcFVvf7bc1w6Tk1vTI8R0G4KBI174PnCW9LWhov05Gx4Luue7nK7JTLhcTUuQKpPxoselS6iXHrI2CLDlv2KD7DkvjxeDgNjMg7v0aOdIPjEwwKyNslhKgSMb+hrG9/ceijctJdsnS8kZPY63z3qfdZZ35TU4cW9JX8Zmc4R9mR2jCPmMuzpU5ozzBx8Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d57ac904ffdc ("mm/vmalloc: use physical page count for vrealloc()
grow-in-place check") introduced

	if (size <= vm->nr_pages << PAGE_SHIFT) {

in place of a comparison against a size_t. As vm->nr_pages is an
unsigned int and a shift is evaluated in the type of its promoted left
operand, the right hand side is computed in 32-bit arithmetic and wraps
for areas of 4 GiB or more. Twelve lines above, in the same function,
four expressions cast for exactly this reason:

	kmemleak_free_part((void *)addr + ((unsigned long)new_nr_pages
					   << PAGE_SHIFT), ...);

The consequence here is benign. Truncation only ever makes the right
hand side smaller than the real capacity, so the test can only fail when
it should have succeeded: vrealloc() then falls through to need_realloc,
allocates a new area, copies min(size, old_size) bytes and frees the old
one. That is correct, only wasteful, and no in-tree caller currently
grows an allocation past 4 GiB, so this is a latent fix rather than a
user-visible one.

Widen the shift to match the surrounding code. Note that comparing page
counts instead, as in PAGE_ALIGN(size) >> PAGE_SHIFT <= vm->nr_pages,
would avoid the cast but introduce a real bug: PAGE_ALIGN() wraps to 0
for sizes within a page of ULONG_MAX and the test would then wrongly
succeed.

Fixes: d57ac904ffdc ("mm/vmalloc: use physical page count for vrealloc() grow-in-place check")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 44647e189f7d6..baf7e396e3fc7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4415,7 +4415,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= vm->nr_pages << PAGE_SHIFT) {
+	if (size <= (unsigned long)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
-- 
2.43.0


