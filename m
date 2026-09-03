Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1589C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F6E6B00C4; Thu,  3 Sep 2026 05:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5CC6B00C5; Thu,  3 Sep 2026 05:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6716B00C7; Thu,  3 Sep 2026 05:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7CED6B00C4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:25:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 220E41601C5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:25:34 +0000 (UTC)
X-FDA: 85171918188.07.EB6E449
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6E205180002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:25:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h+LISNtM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XYwBU5ZHVueM1YfQFwjzrz4zbhTksf0+irRokmEvL88=;
	b=ORjVPIKURSh5gPzDGblMFRPxrzMEDmNSaMtYMm8Xgp0GM+Q9DomeLjAjKYCREwcfE4z1HR
	qpnZSfct6TuRhTOcDoHA4vBgGKL2UaKJ18EURBzvo733+7TAiPL+uEsCd//tuqHUcVKiBB
	RuGj5WP4oJH2i9Mi4fr1YHwxFBgFT7k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h+LISNtM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427532;
	b=paWvBvAhLtj53GiNEZTtANx4ozV0CD9nJuVXV15plRdCNGzAbRRxF8nhS96EsLGudAPqv9
	yjQsC0UZcpSizsM/EIMlMh38SI3wiEsGaAUnlsMBMly1x4bu701zYmYv0fpxMcEuUsVCNP
	atG0Gt3e1MSuNsElhs1dAqhOzv7QVdo=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-484374f54d0so1312614f8f.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 02:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788427531; x=1789032331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XYwBU5ZHVueM1YfQFwjzrz4zbhTksf0+irRokmEvL88=;
        b=h+LISNtMbo8qJgVmzAjpQmo730/l7u+dqKhzNd4Mgo2yQF2T2z2kCRi66eHw+zrbzf
         vHOFMeX3+l30w45Ot3MmgCqtpoBUR/9loEgK5nII2tN54cMzyLMKKxkAStk4y9U4asHa
         Gr2UzP5P1sNeUSxzP6AeBT6Po8IKc7v8uUVrW+xGt0hviTIBb7Ia5WEw4HtaSLbcp5tV
         O+tr/I7jSejNq/g8+vfMRGbAHhlB0zIXp9M6TXA9tsy1UQ9k+o6gmTH57ouAj0a109BP
         LilqOTm7aPCSwMHoA5Pvc0nvZ9VuX4TGoM7i79Jl0fTQqrsntGG/7QQIhYJ3GiRMDBUi
         9QtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788427531; x=1789032331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XYwBU5ZHVueM1YfQFwjzrz4zbhTksf0+irRokmEvL88=;
        b=oSVtatSZxUdJirw9hLElj3/9JBblFvks0RVZR+4ovqrEDfCd6LwO7GepSU/0nFdSgY
         DKsLhrdxkMkOIohJaZCdZXTXZwZPmNgs5HFa//laGNNk43Bs+xLZd5RkIf3PFJm/wdgX
         yDKZb+j1WV4JoB2b+O989Amq1h8NbgDtOyHXb+VQVNRAQWK1T/SfADRsUymwB3p2HK7I
         dmINODmyG8skT2sOkBLI/I3hx6SoMDzLyy5XK+MJq4tICFWBUIvUfzwhp8QoR/P4EsuR
         37ADbXfk1+89gM5y0jq2oMQ5RNYA+Lu14HQhoxHVkqMoAEQNjAcjrBBu9tRA6+DCgHZM
         HmfA==
X-Forwarded-Encrypted: i=1; AKwUvBzQF/7AwVNan4wbMuHv6BeYHAv6jxmWwKXEd58KmtXNkX5cXHRr1Ev24dHogA+RrMlTakn1LIh69A==@kvack.org
X-Gm-Message-State: AFuF++koC/EsvzUB+egmJrOaL0yW+HhgDqxW+aEEprwTgNNZJgNEvz3y
	1YihOUH0iBVU/w4FPyJv+PeUATLPFvSgOhGNG+gWsda13ZCEqS/EuOsp
X-Gm-Gg: AYBFou3GywQmhVqiCzsSqVbZyGyUZxz4h/kFSxqrMiVmN2qJhdPf7loWXKdbppzdMtr
	y40KFAzYjZtBIv+meKrm5t6XideguCvVFCssw4fP8F+7470OZXo6ze6kkVFAZWzMHh8f3rB6EX1
	dSjXQ2/d1gJ4zfpFuxk9KOhyeg5yn/3nI6fbyzqssT44QQcJ80EEvyiT0N0bx6xewPqxsL8oYWC
	eXxDybO4CCofbwGE86WvoN1lzUVA4Jsd+5VP55jUsRICX6x08fv2CO4S4JsKMoRwx9sM+4pJULI
	Mjs1yvD+EgjOdPwf6wYCEMQJ2PcquDeSJu6HkxweAlvBgL3Bxsrb0RnHcc+nFBzpZFllFZ2/5MA
	bDsTd6RI2mw+u8+H8TJnAXNNRbgKSTQ9TELw8yzEUyiQELrOO4Qx7zoiyttNG+/1xJnTjHZiJy8
	spYRtCAt/9KJwC/Mhma1kmseLHzSy8+sNGwdlEQEawLXfCdwIlWhnb9pDOo+6MAn18BL3OFZGQZ
	n4Qk5SCmLrsip3LiWHasgIUxDIH+QFPKdwo/Jih
X-Received: by 2002:a05:6000:25fb:b0:485:8354:d82d with SMTP id ffacd0b85a97d-4858354de3dmr4041188f8f.23.1788427530909;
        Thu, 03 Sep 2026 02:25:30 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:647f:bebe:643a:40cb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448ed37c4sm10748511f8f.21.2026.09.03.02.25.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 02:25:30 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH] mm/huge_memory: fix various coding style warnings
Date: Thu,  3 Sep 2026 12:22:00 +0300
Message-ID: <20260903092200.88910-1-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6E205180002
X-Stat-Signature: p3pam5fkh9tq5bohd7ucpooyxuy49c5r
X-Rspam-User: 
X-HE-Tag: 1788427532-472527
X-HE-Meta: U2FsdGVkX1+CL1x1EmdWqGWrQtyEV4BJssE6YmlilWQSCVYbZXoJ+/mAIQCBvwtMDx7rACQPtnFnYlKhimmziQZwWzczaIDwv2gsN+mEEJ2juoFkEjx+J126LgZjME1zdZ7WfTlpCaMkaxiIhL0e0dAv0acqh/5DNB5fmqmyLJc+3+GU/jZnwWdH80+25p9cnN0ym/2lJPRc981kgb5TrqqXljtKAdvPyo2abfAxLMFqAMJk1DwxjNne6y8z8ibfs0Br1ra4DoJW4j5nRt1TGSkAQp7Ul6NOsxhdKZK1xV+urvvyw+e+0FRRLppp0oYx5a4iVxG5WHQNgEVAfdExFFnvBf5XMaeGNxR1fFBvxiuPteKbNjepYBYtHr4IBxHEPQSrQZ9g5xcDFfM9aIgs2FsbMWeArGy/GLK6a1juBg+dhtuBXBJb80/kdRsVAbcxqFegKg53CC+mnOA8pcNXJ/q2vKTAwAphjGTJGVhUd7gbFXcEi03Rv02KdXQ+Fx/Qmd0eCsNfLd+OhWXG+aCMzCPh8kwcT8RMaPL5bTXkJaZJgiObYVeahBzDDKqmO5hoCp5q6FE6vBuyi21QR8iqNILpw+cRq2Bogq+qiKAFOMLdNOotGoo12XTDbms7J4zgR9QFzYAzO134Rf7rNW5Xu9rzgMHE5oA9LXEhlV/d1c0vzSk1bB/UiB5yT3vopfmrfAsI+edO5yIY6mlPd6f+mCB05AFslBQxJjD69au4cdDZirrh5uIJSaanwctz/vV1yXFTMALwf+sFI79xhR96lCE4AA9Lv0g8sMxXdKsB6UE+eQikvzxBUg2KCu68JhNS6pgcVdNtXR8OJosle1uv22PE/ui4ZuDBdaH9Vr429mwwMFzZxlVeCNhVQyg6l68g9LoeCmkCPJm5O3q1R6QXehuxgmXgMaxoVKNUmB3vrlgadSgbDm2ugzN15MSR3f1P+2ceznyqP/ieDeNmLTc
 NxqoH9wh
 LA3J0dMeDzblpZIXhiodALJCfeWBbPpWh6vc3eGJBe7rVDz9YJ6Smf3DY8zKlRsHx0YMCN0Uq01r3wH1d39gvFywPy4j7lFscFiAN9TKoMsF3hhFynbsE/Ime9LkFHSeU5J1Yn5T8mdtcGtZt+ZYwGO6rcWuzpctBoLa91TxQ95ZKDFeXcR1avRukV+oIxFxcmL/T0GpwpcrOP4IyDeoTk2so0xdhrcp6sxf7EbjLvIMLp6KUkFNf/jQNlj/HsWjVclbfnAY+Yc2qxFUmK6TloXg1FwUJyjATnf2KCa5Pow2+iMODgINIXTVzcXAT7SFgSEIitSL17lnr+5UYDpv7ag3aPi8Bg47PJZRC1RToe/ZWyKiEiwYQ95C/W7LUjnuoKC3iGVQy7kO1kBkBOLdYMX7Et8+hHyKNBbyCAdjmWw9uP9GL9vMu30HaWYEtqsMpzpc6NBtAOIJ5RrcplRJGMg5YcRhbisyYX9WmW1sd/toNLTs8BMsrvIebozfA7Fb8KIaQSckpUl5PxoJ0bQRMjNRL7lQPVJMEdcnK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve coding style issues flagged by checkpatch.pl Specifically:
- Add missing blank lines after variable declarations.
- Remove unnecessary braces {} for a single statement block.

No functional changes are introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/huge_memory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..371ee8d38c45 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1104,6 +1104,7 @@ subsys_initcall(hugepage_init);
 static int __init setup_transparent_hugepage(char *str)
 {
 	int ret = 0;
+
 	if (!str)
 		goto out;
 	if (!strcmp(str, "always")) {
@@ -1510,6 +1511,7 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
 		struct folio *zero_folio)
 {
 	pmd_t entry;
+
 	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
 	entry = pmd_mkspecial(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
@@ -2613,6 +2615,7 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 
 		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
 			pgtable_t pgtable;
+
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
@@ -3901,9 +3904,8 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
 		return -EINVAL;
-	}
 
 	if (is_huge_zero_folio(folio))
 		return -EINVAL;
-- 
2.55.0


