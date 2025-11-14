Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA313CE8D4E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CDE28E000E; Fri, 14 Nov 2025 10:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5CD8E0029; Fri, 14 Nov 2025 10:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2E98E000E; Fri, 14 Nov 2025 10:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D53768E000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A77661403EB
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:11 +0000 (UTC)
X-FDA: 84109659102.27.D421A39
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id DB01940003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VhV3wnAu;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzmFAH3xmZJhmT0Rkc3uU+e9AsoR0HG7wEejoVF1lJ4=;
	b=YzTggIl3UtqfiwCoZ2BfEF0j53sIifsRMHARbWI4qkAqb2ZQKoJqDN5u0YgrRi4JetN8QU
	AJQuQevf4IKPgGuTGjreEYOpRSqLjLhT7bf7eKmGoJ0bafUTix4zq+brpfjyNTWh0ut0MD
	KERwru+j5AaSZpMs49Yuq3h/586jUH0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VhV3wnAu;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135649; a=rsa-sha256;
	cv=none;
	b=so0qbjxJYfkRFX7ec4DlrBUyVPwZzPXpB1oH1KG02dDqpT5ZQ7P8cVfr8+V7rYVFpoomzP
	hd/y35t4RocyjUMboKiZ7/DDeziVdGoo5lDkm3iBE5Xl05J/QY+q63HFrjCU8DsyhBUP5w
	tuQMjtPjOr3LX5cqYqViC3GY6jEY69s=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7866aca9ff4so22228607b3.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135649; x=1763740449; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qzmFAH3xmZJhmT0Rkc3uU+e9AsoR0HG7wEejoVF1lJ4=;
        b=VhV3wnAuacfFNrGBKNIC2EGt6loh8yU0C7SaCBvbG19GqjBH8jQLOcBp78YDo5e/un
         N1hlAOirNBSRvvCurY/qgr91KRgn3ybztoPMa7V5C0pE3JOVNhuPfNYT2XZt4Kx4phzI
         yyMD8w/nZb7VqVGA5vuFpIJqyivs2mVmo8PYudTv0WMlRA7DEKrLbkKeMTChU7Qirjpb
         IxhUQ5epa86mUbE5rdhn8UHE/IQXCcOS9fNh8dZSbGNTV33+ebOYHabAeHopGMV5YIwd
         Yl3o3/b379zgMj4lvS+ZuE3sJijxOJw+fMGUdm8Nz6BMqJOsqUIuHYB1p4hi+yavGSpM
         rUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135649; x=1763740449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qzmFAH3xmZJhmT0Rkc3uU+e9AsoR0HG7wEejoVF1lJ4=;
        b=p02OaYhN6tZsCF01rN1rm8Yz8GkCJ94H7jmXnUYOit3dEg39za3w1fYQBJRhtXMTqu
         AakAZBXqI6zNFM563EA8dbuTm9dhu3LjN5Wu4N/B2LGB0Uj9nPiFbp4rIdPh+PMyTBfH
         zZ4a0kBiWoMYxz8JXD+327H2rNRk8TQYq5XqRweyRci/rAvft8muxu3MNH+CvJPMK0ES
         q2+8oQBzsoTj2KqVGLR7dHh6Shi0N9LlJiqXQwud3gm9AApQOsX71pNfKpGLVFuiMLm7
         Dssf2WK97G+/fJ/OST1Y2aIJ3V/xgVHItG1EhxhP6XDCxRRzFf9I5YMCZwkcYDto+mG6
         r2TA==
X-Forwarded-Encrypted: i=1; AJvYcCW/GBRm98ATozyRVNoS2shRAtFzApOqgOAi+3G9jhFLwej5q1knNjxV+xLYU8fkGrdkXRWFP6oINQ==@kvack.org
X-Gm-Message-State: AOJu0Ywm/6X5TFwJGYQ4b2g5GQLt6OdDYF/7W5tDtgxA8NETgSrqMJqU
	XWnExp10FMaCCKGazB5lAW9kxZ8B0W+/LGSFKaGvI06GmjkfiEyMrALOYHAnZb4qIaU=
X-Gm-Gg: ASbGncsyFluumApik8yNVcCjWkH+7D4nuyyiGEuFxni6zy+vO4xtj6oVBdqt/vtmtDP
	DWtGW9Vo82F0JIE0FaC5OmIXCTbGgNym74Nb1fq4FvpdVGo/pyGPvWm/EL+83ZGfgSSvqxj+8IJ
	XTVCYQLmcVyDBtyURDMl4LCxw4OLs+IS3Y9fyQctPrWScsTuKreMWriaFeT3HgPgDRE/kK8g2Pb
	3xhaymQqrfNFFzw4RCkrYpfa9t4zlCpBpsxMKRyO6oQJkTtnHrzQMKQiadPhqFWBifgJGXQjbEF
	70YSMqFF7Dp21ku6nypaj5+ZfrIFhXX5Ljd+qiZbpTzTr1u15BycbxILG+ZCzllwUoOM0V+TfYp
	v6eVJ57FmU0/3A0DnBtiW++FZqoY8DB01sMzRIZjik1/Y2q1Dw96xqlH9o5B7oht9vibJxaXwDQ
	u3HJ/722p3DIZcAlmE5I6Nm0n2lxPJ+EXkcgzQ//UkRoalXPOnlyAaXnLm0kLXZM8BY/1Q
X-Google-Smtp-Source: AGHT+IHTzr8yE3ggcwxtjOMXBuZ+AkCCbUZfzA+E1WP5d8Pf6HPSzrjQ6c3qDriXPIifvjJMeL/d/w==
X-Received: by 2002:a05:690c:5885:b0:787:f5c5:c630 with SMTP id 00721157ae682-78929ed6f0bmr24916857b3.41.1763135648927;
        Fri, 14 Nov 2025 07:54:08 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:08 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 06/13] kho: Simplify serialization and remove __kho_abort
Date: Fri, 14 Nov 2025 10:53:51 -0500
Message-ID: <20251114155358.2884014-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DB01940003
X-Stat-Signature: iqyq8hxfe8haq54q6kwyg5ypdgmqu8t9
X-Rspam-User: 
X-HE-Tag: 1763135649-394280
X-HE-Meta: U2FsdGVkX1/sIvgVmmXQFaVq0cMo5rLiTiDli4mkHo9i2Jflgrq4mcG+7gGWyPvp4ikidG/A4ARzFrFBKP/VWm/ZU81CBziXG2vuI3F22R4ip0xXuCn8iT0SHK4TNw8Ybxzm+AdWW6Tm+IsPP7iTAPLWB/b7o1pUIVYFcKrn43sRb5E4qzwQOBo79reCqDG2IF9plZUbM3IEtxUepFuMMCp0SDa8RVI3KJuKFQm0n1k6OtEGDCZDo/1G8v3SO/h5rU+jOZ3PrM6hwgLLfeHkYeiexX4itd0rCgYBPlFwd5/Bl9H+MxwHe0hIUWmDlGeNthjIvW+8uXkrUyOJgiQEtxtRt9cRANjSaSmVr5lojbK+iogfFACIuNRNjoYDggYqMk26aJLB9onWv6S+wZ19TunQXc4SX9SgUx1wjWyx8ym1H138yh3F9UkBvOiiaJo0AZ+QP5EDmH3aYLh+wKZi7/8LWKt8Y7KJj3Kubub2DCVwTdO/gWIqrVrb0IAZnqwOnilJU2EsJu2hHARgw7Khh8wa7wZiaYXZ+onUqueUgQ6pUvwShbokl9eaI2aOzr0RLGDI8vebUZaPHXhLDTl/G4OciBMp9FpfNuJY0ohumqd9pBoLARzGShtt8wjpMVubRqPefLrTFw19Hz1jtb58kmhkKPt9XE5n5Ab3HBANq3/sTlcxzZhpYV+JbfD57JYSc918BJTnVERCsPGVRnQJDlA8mZNtXRTMECFlamAJr7A+/tWi8Zp+wWZ1BczbtJIjzw2IUOqeL7GPiBTNz1LVgU/HAq8GVpvmL8l5D/+Z7VEsp2QtIjsPYJhVfvuRMnPyg6r7c71CekGjRCow8L/4+C+fzHqQEIiJkGIvsH5QBKuyE1nVG/AMdTL3VMLHakIIcIUPzuujjT60C0I9gyMINJ2MackUmpCYN42B5WAvgmnSbIxS0uDE9FS71LGrjBqXXtSTTH2J4fyk7qxvGsP
 P4uvWFbw
 KbfuM+tG12FKfj62QFquDaPXquJIyvEJ07WQ0BdJ2k1keJkS1XwIm1mTMaGu0K2CMYYgIEj3KjfoRGBydC1/hF3aaw4dmgEQOncNau6Lqb6rNDjYS8bfYxagEUXDAqBE/G8/uLoQyzAgq34K7ApHuijzZ2/ETUyRJIj/FMpP9a94Fly6hm9EWRiT3Be1oObKx5gklhZU+ep/m+miE7PyD9bUMh41hdjdY5sYNbqrh256i9sp0TBq37FahGjp8YGAYEyVxhSaGQlPKi114egq363Di400fWfE9cTLT1U9pLmCaTnlgFgqp9mEbqlhEGh0NsuMxqpnQRZ4ycaP3KQ28GqczYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, __kho_finalize() performs memory serialization in the middle
of FDT construction. If FDT construction fails later, the function must
manually clean up the serialized memory via __kho_abort().

Refactor __kho_finalize() to perform kho_mem_serialize() only after the
FDT has been successfully constructed and finished. This reordering has
two benefits:
1. It avoids expensive serialization work if FDT generation fails.
2. It removes the need for cleanup in the FDT error path.

As a result, the internal helper __kho_abort() is no longer needed for
internal error handling. Inline its remaining logic (cleanup of the
preserved memory map) directly into kho_abort() and remove the helper.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 41 +++++++++++++-----------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cd8641725343..aea58e5a6b49 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1127,14 +1127,6 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-static void __kho_abort(void)
-{
-	if (kho_out.preserved_mem_map) {
-		kho_mem_ser_free(kho_out.preserved_mem_map);
-		kho_out.preserved_mem_map = NULL;
-	}
-}
-
 int kho_abort(void)
 {
 	if (!kho_enable)
@@ -1144,7 +1136,8 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	__kho_abort();
+	kho_mem_ser_free(kho_out.preserved_mem_map);
+	kho_out.preserved_mem_map = NULL;
 	kho_out.finalized = false;
 
 	return 0;
@@ -1152,12 +1145,12 @@ int kho_abort(void)
 
 static int __kho_finalize(void)
 {
-	int err = 0;
-	u64 *preserved_mem_map;
 	void *root = kho_out.fdt;
 	struct kho_sub_fdt *fdt;
+	u64 *preserved_mem_map;
+	int err;
 
-	err |= fdt_create(root, PAGE_SIZE);
+	err = fdt_create(root, PAGE_SIZE);
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
@@ -1170,13 +1163,7 @@ static int __kho_finalize(void)
 					sizeof(*preserved_mem_map),
 					(void **)&preserved_mem_map);
 	if (err)
-		goto abort;
-
-	err = kho_mem_serialize(&kho_out);
-	if (err)
-		goto abort;
-
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
+		goto err_exit;
 
 	mutex_lock(&kho_out.fdts_lock);
 	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
@@ -1190,13 +1177,19 @@ static int __kho_finalize(void)
 
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
+	if (err)
+		goto err_exit;
 
-abort:
-	if (err) {
-		pr_err("Failed to convert KHO state tree: %d\n", err);
-		__kho_abort();
-	}
+	err = kho_mem_serialize(&kho_out);
+	if (err)
+		goto err_exit;
+
+	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
+
+	return 0;
 
+err_exit:
+	pr_err("Failed to convert KHO state tree: %d\n", err);
 	return err;
 }
 
-- 
2.52.0.rc1.455.g30608eb744-goog


