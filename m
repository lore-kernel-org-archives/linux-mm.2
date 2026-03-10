Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0588EB1055
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8007C6B00B5; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67AB36B00B6; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3818D6B00AE; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF2176B00B4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4784137FF9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
X-FDA: 84529998546.05.FBB0D0F
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf06.hostedemail.com (Postfix) with ESMTP id AA42F180015
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=vC8qGYtm;
	spf=pass (imf06.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7yqvKgRQlPCuPxWpeGgWE7MFZhfk9JfcC1gFXD6dw4=;
	b=BCHOO1MrlBQ+VQ4lRaKRtshFwD+/5QcRblMqEYis63XxEnLGJ3gn/yvYllMekRmnp2EdQb
	5n5K6JTLNC5rp80whikZnQadzIGnj1Y5lFxRGfB4w93vpfRYOg907lMslm1GRAFZFOl6ji
	Phvmu3oL9k23+Q4H7EjLZjrNceGHtoE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143732; a=rsa-sha256;
	cv=none;
	b=vpu3wdQ8uy8esIG5uFdnsHBOH6POcW9+EIdlHTzaOYhtAHhCNsnGXUj6PDckJflGF2zvpM
	j9gGCdOHnZOCAvJ2iwL6yp92GJiSZcT2ZcuMtzCSrVx/TP9vcaQuvQ7FEhNPAUmk896MxQ
	hfLB0gKmJHlYng8xr9pmFNHmRzTEa1o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=vC8qGYtm;
	spf=pass (imf06.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=Axff4FnAHPNmyZXZ2vgEuavJkfKhCKJPqZGqnoou9Q8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vC8qGYtmoTTFtKG57rlNoXWnybB42U6r7mF3yDjZNK169i+LPPc6FbsKjJViJXz0P
	 z0SkvHe3S8CzlbyDQgjnVKCfReu3jwjo1Tnr6q9iIPykZjcNCRLdwFjqB3/YTiencA
	 upketXPZTZxW0W7lPSDpgLsiq82FnKI8pFh7qlSE=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ae-2367-7f0000032729-7f000001c97e-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:26 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:26 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:59 +0100
Subject: [PATCH 33/61] mm: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-33-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=3181; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=Axff4FnAHPNmyZXZ2vgEuavJkfKhCKJPqZGqnoou9Q8=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZGGzCaztqu0lpdWvBpBbRCmO+WdPRS9iZCq
 y8ebihz4r+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGRgAKCRA0LQZT0ays
 21/8B/wPP7xI3S+6VTDXKISgyNvBqi0UZCbrYypvYfajV0SZbWCEuGKdkXjsEnnFt9YRKxoHeyi
 XmpmbA47CMrp+VNl6him9YVO8BEPZHU4T3m6BB2+Ps31+3rQDfYs7d+nPEStYiJ7CseLk0vc9Xu
 aMyI8bSdyPpcRveFxPuH/uy4iV8zrSXLAoi0Ddm83MyR2aRNl2iCZfPRsvcbR2T8dPBVJjhKzKb
 5v+Zz66IZ/QArfKSmSkUD+nw+Micr3w6XFCa9e1WMrdcQ/Zh9MZx0TWZwcRgOAgfEwQG/fxgX8/
 bLP83oq+8G1pw01czFBtKoe7eUKh6J8z9KOOUPoqLrMipRXq
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143726-05CBBE1F-4CFCA352/0/0
X-purgate-type: clean
X-purgate-size: 3183
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: paamm13ssyo6o9ce7wra5kz1qocbae7d
X-Rspamd-Queue-Id: AA42F180015
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143731-134268
X-HE-Meta: U2FsdGVkX19gWHonhlRdtP89RFRCD3GFwZPYxbAnx3A0ROq0gaaE3gezkv9cq3TJsSYfLDQyhvgNq7Ok8DNgwft5OusiuJ028lI9OyIjj+adtY1FQi5BP9OZcd+xCxydCjqdlI6bt5mYjqKppMaFrPaDObK3ZPt/hjvkUKE63VOr5IY3ESUJsFw16F7qaC9mtUe1ndOtNB6BKZQLNMnDTsRYoxsFC026ZtrrIkw5bkWTqHTe3c8exqW40APAgD9w3VnzFACCjqUxWmcIv4wjKCxfJyxth3pdA3p4M2sDrdVLzq0dFVoGofSsK994oqBXmJnuowApVCDf543BAXPOApoajR3/rouB//d1VzQobJfyv3728gbRLsjtXGVQzJrrL1qK7l84an/NKALRYjqMQzsWJLg++AmHT8smI6NTFhewV/sn5qxuhhIQlIwbtIsnucF09qqZVNgUkxve4FnROKw0rSZCe3VQsxKysLKNQWCeZlY8nNFVy/mRviRmw+Fb4k9lCM3yMxg5qxHwDErTn8Ov6+La6cyEk09Dm76W3tRcPf1mL+mkRl6QPVvI4zpmuR9choeDCaxwKzfl/PC+lNYzhuBfUgR9a8LUhQ/+Enfo+7OWEziw18MR9oKznro7t0hrzz5uk/R3kcGrhl6m7t1/y/Ms/S4bhXIsw4DWZTIR6/AEoZR3B7zmeMPoJ43v6lFSZmE0XmZSWKlUvkV9pqm+CSG1I0f3zz0Y6Gy0Mw/i2/e5VDEKY9dz6TAH/SjIb9dR5l0cAj3zKUzTKKknhwbcs6UBL/1UHm6aTFP6EW4mWv2I4DzALMbRd34sDohz/T/h4/oCieBXTqrHvS+TFDA2qOH5L4V7KTSIPDHiIYkj8dIAuC7SBkzFYz8f6o6mDzsTABzNWQWF0g54LNhwc39w+/kimR1qYG4w2/XPrZ0RcERYkKF2vqnxCIWum7xloE0pDEHSCf7fWOXwN+j
 XwYO3XU9
 u8QK0yc3YXF9PvpilTwP9cxdo41vzhAyS3O9O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle and adapted by hand.

To: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 mm/kmemleak.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d79acf5c51006c3ed42fd88a2246ca148e401999..91136be23a84d825698e98b4f2d0e666429dd593 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1092,7 +1092,7 @@ void __ref kmemleak_alloc(const void *ptr, size_t size, int min_count,
 {
 	pr_debug("%s(0x%px, %zu, %d)\n", __func__, ptr, size, min_count);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		create_object((unsigned long)ptr, size, min_count, gfp);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc);
@@ -1152,7 +1152,7 @@ void __ref kmemleak_free(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_free_enabled && !IS_ERR_OR_NULL(ptr))
 		delete_object_full((unsigned long)ptr, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free);
@@ -1170,7 +1170,7 @@ void __ref kmemleak_free_part(const void *ptr, size_t size)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		delete_object_part((unsigned long)ptr, size, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_part);
@@ -1238,7 +1238,7 @@ void __ref kmemleak_not_leak(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		make_gray_object((unsigned long)ptr);
 }
 EXPORT_SYMBOL(kmemleak_not_leak);
@@ -1255,7 +1255,7 @@ void __ref kmemleak_transient_leak(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		reset_checksum((unsigned long)ptr);
 }
 EXPORT_SYMBOL(kmemleak_transient_leak);
@@ -1287,7 +1287,7 @@ void __ref kmemleak_ignore(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		make_black_object((unsigned long)ptr, 0);
 }
 EXPORT_SYMBOL(kmemleak_ignore);
@@ -1307,7 +1307,7 @@ void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && size && !IS_ERR(ptr))
+	if (kmemleak_enabled && size && !IS_ERR_OR_NULL(ptr))
 		add_scan_area((unsigned long)ptr, size, gfp);
 }
 EXPORT_SYMBOL(kmemleak_scan_area);
@@ -1325,7 +1325,7 @@ void __ref kmemleak_no_scan(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		object_no_scan((unsigned long)ptr);
 }
 EXPORT_SYMBOL(kmemleak_no_scan);

-- 
2.43.0


