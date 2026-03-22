Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78BB4FC72AA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 05:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81C26B0089; Sun, 22 Mar 2026 01:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31EA6B008A; Sun, 22 Mar 2026 01:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F9F6B008C; Sun, 22 Mar 2026 01:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0CB56B0089
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:43:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 551AB5A4BE
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:43:18 +0000 (UTC)
X-FDA: 84572606076.29.C0CC336
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8009280003
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:43:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V64t4svL;
	spf=pass (imf30.hostedemail.com: domain of 3coG_aQYKCMc574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3coG_aQYKCMc574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774158196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCLfYASgT0jKid/tJ2FF95GlZkyQeWGLzgzFGOQGNX4=;
	b=t7b7d2/BNFaj9Wii/KbYel2En8TgMlAhDasjQ9139cQDaRH9H8itluH5Ars2N5OJam9iXi
	YVtisRnNzrrk8xRmefpzZbdJfKSc6pFANCV5O3Hcd3E4ChEjRSKFvY/5jFTIdW/kKvKqCu
	M+lr1uSaZjb5adKl5VlL7psy4c6ces4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774158196; a=rsa-sha256;
	cv=none;
	b=49QOxSPhbUbZV7fZkPWk9lAaUopEOHKZRjTWkQPiWdpSiiZYWPrpYOpaU4tzq1LZ1v4qMU
	0fov0dPJj6muq4fq2BDIT3gEiCICgsu5SSvsoXau0Z8ccKbtzHlPJ1X8j3Orog4jWXhPBg
	vsjHpcPm0eBzJFYHWe77wTqy1WSMjSo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V64t4svL;
	spf=pass (imf30.hostedemail.com: domain of 3coG_aQYKCMc574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3coG_aQYKCMc574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c73a4983fc0so2237585a12.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 22:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774158195; x=1774762995; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NCLfYASgT0jKid/tJ2FF95GlZkyQeWGLzgzFGOQGNX4=;
        b=V64t4svL/FgwiSDeUwF25Xht369dNRatijXKthT+u5IjMHXtTW4YEDq0WjUW5IKEtP
         3KJYNlvCG+m7i9REXhYSyS04uWfrGlB0XgapeoPa4hR5UsEDugzBrbAEaLkj4/fAau3r
         EfMRp6jeP4s7FgrBvsX6axh//AW9RLnbh6IIUzVFEFdfq2cx6nvANAhO0v6Hbz3DADXT
         sZRNtbyj/jqwDSdZY6WjWyFE6gqQoXZmhNwfhripWyuSDlCRX4nl058iaek7HBDg7fDa
         1G8p3/uDniTJmyaPUZpmpl/RWfI74vVAFigji1B1urgVJE8rTJnzx+7YcQuImu+l1bkA
         inLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774158195; x=1774762995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NCLfYASgT0jKid/tJ2FF95GlZkyQeWGLzgzFGOQGNX4=;
        b=i7Qr8sRp5Q5+Qg5cgxITt8tOUUnDIRrW+I7MnPSkv6kWlVlhqaksGm7RnscnmXJGeD
         BExIfBdoKt2wpzJuCbtdNoBC85zwZfC5Qvf7x4sViomiWyh2HXsvEXjUjnK5zVbUFV6t
         8jQ9ErI1LcKr1jKk77N5FVjjT/z0yf2aKRk5dFNv4+KBMfPMB3tV0acWx62AImUcm4+n
         u5JUdeBNNWVL9N/loVSTwukB9WnRIZuySk1wMpBGbZpSm+qMc3KkU/mbU9CpYQ+mJ0UZ
         /J1fwIuDexlEKWfLKs12XGOyWV/cuKDIFiiOXyY+dy+3oXhMZiOrFzUSzMXvz7I7ckwa
         7YEg==
X-Forwarded-Encrypted: i=1; AJvYcCVttKKyY9OtIPMuCj3ISs3m/A32R7x+bteC9sRIgMcqkWS8TQzcQa1CV6OGefaaQauTPXM8c7ZWtw==@kvack.org
X-Gm-Message-State: AOJu0YwmI5rwrHMyanLZXeJk9KkHdTwDKgP58RJLac4+WmpZ12f5loSy
	6Sx3AmJMtpQPXBiQt66xperqinoACLmpG8k0pkWQlaJAl/IQvOb2UbhNTLjKjMcjAQ7ENdkFAn3
	as90qiA==
X-Received: from pfbfb12.prod.google.com ([2002:a05:6a00:2d8c:b0:829:769a:a81])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4191:b0:829:809e:8977
 with SMTP id d2e1a72fcca58-82a8c346979mr6884137b3a.49.1774158194950; Sat, 21
 Mar 2026 22:43:14 -0700 (PDT)
Date: Sat, 21 Mar 2026 22:43:05 -0700
In-Reply-To: <20260322054309.898214-1-surenb@google.com>
Mime-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260322054309.898214-2-surenb@google.com>
Subject: [PATCH v4 1/4] mm/vma: cleanup error handling path in vma_expand()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8009280003
X-Stat-Signature: ysg7ew3ccfx6rqjdm93xnx3umbmfoa71
X-Rspam-User: 
X-HE-Tag: 1774158196-302301
X-HE-Meta: U2FsdGVkX19slOe7ZOZ4VyAnGL8ccQyJLsyZqRUlm7BeOzlL7B60/GtrpVWzas+ksex5RbTcJpGJlT7GOL0Tj7JN5DQO7TesTw4NoKhEHFPLLYIawWLcmLPeu8lIhoQo9U2v8f92dmO3kuFduxjkPRMa5eIdelOQIeRe9lAqxgLkFAdEB6T4NHoWwZjG2YywHVI+PK+JHsgxjP12hG/ThVYeMD+ZKX4IyW3EyXeWMSIjR1ynF/0BXTxv4NN9AWBNmuzzzCgfrejunLC76Aj/q29Fbog7yatwfm0n4pnw60PcCoB9+lbJGFxXRuJKZ/v53hh3qjZO4kUHvT2rlCrsvdb1fNxcIOV1XNO36PKkkoRCqHPIwHSA14y910RgNPknoOF+dwds1KfHgX/jFxQtlN25FqBfvic8S/iaRIiDanetzUt133dDetT/a+EQMvE2+ZlOOqdktKtL8XaZhY/Rv4jU+7/o/91Gar2klHgErhJ/n7tGC59Zf0Y66635pCgcLfqwibKC1THsw8WyExYC3nwC8qv/jExCZFgcDqQybVjSv4fsHRi9TCWnRnGkIH9gCDf4zBDf6sUbjPVGLuTrxsDgF9blxtfMvAZbsod/T8eYqNbV5VDKu9Me2I7FmwXoGKykXSDJO9BskMm1Tl52mMI1lOEREVVr2ExRiwyumb7i8y1pwigAICI/6Y6rwzGSOgYqP+M8wyTkxOJiLDHLXVMyHqbqQJw6In3w4R2nec4dfWukqoJDhXLsrf6BaPX0jwTheaCLC1QylROKmy6Zn7386lDQ9TtdoolyJJU9FAksdR+PaTAMFoOQAXKMr30ZZ3Fd4qCOabHuXgJLWWpmEOaZT/utgMwhRDv/C0mNYMLtA6NOkhcHP8JehN88WaTTUo2YhmCFRlDqeOuBtIoYsfdTVOkC4uqP7t8Wq8kRX0QHoMizNkguDQQl0NOljEk7nLAj/wQrnmXqSfr+Zmu
 o8QhhlXY
 x8LyVKlFGu4KJlCCnjr1XF3nWVhccKUBFPH3sdDBVfN/6VQc0NzmRjVRzjn64+y8CA8xdsGGphH8G+GMohtLHURxEdim1PC12tLSZwmJArSqKTTesucuXOhQICaJxEfeAaUV37YVomNTeVhidiLPcLYMOt9S1GP2dgdIyFV3FizoONSTHjc67oNoorcbKpxchfrduKvpLBGrFI7TpUY3pVhQ3GNSSm023B50gBhMojALLWJKnNpU8nF5rUfKekNQGsAx1dml7Y99oKZXbrfxg6DQNe1RWX682RNDoVUZ0Tz2R52fkJe1IKJft63tGp+glmSovBfKAhvzW1yrzOFTQKRs3h8uiYbAj9Z7fb5oyEXS5l10Z2BuH6OyPH7CFHCr0U7kjfQtTwYq2RRMxOdbl5y/U4//LKGCIkqpqVDGidsW1lMnsCoOGhnShvCXuYyumg6vTQbpTKy/6+CLwCEdEBPEeQIh2Ih+Hj0maMsWvDWuzctmY6SbIw/DNkBpSZUGtfHY3iWq0aqIp7t/prYDZMSnSPjiaKRhTnAwIKrcVDknFAiTnCev9A41VU2sUkLkwOW+rDlF4H1jBXgRhHqcWp2ggxwWrUu+zY+GiZbAsvU4/TSlABNfYFansGf6tgeiSLsB2daf4os6xRbkLoFcKPOa2OMkuG8nfqbF6kjL7k28ZLEEO0aO7kvuHAED/nLgxR3Jy/8/yRFW8Kvyx86XTRwmRLhEydl/L7vSZQaHrUlGr40HSYXJYN643WKZJ9KE4GSAoTiuZIamSRbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_expand() error handling is a bit confusing with "if (ret) return ret;"
mixed with "if (!ret && ...) ret = ...;". Simplify the code to check
for errors and return immediately after an operation that might fail.
This also makes later changes to this function more readable.
Change variable name for storing the error code from "ret" to "err".

No functional change intended.

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/vma.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index a43f3c5d4b3d..ba78ab1f397a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1170,7 +1170,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 	vma_flags_t sticky_flags =
 		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
 	vma_flags_t target_sticky;
-	int ret = 0;
+	int err = 0;
 
 	mmap_assert_write_locked(vmg->mm);
 	vma_start_write(target);
@@ -1200,12 +1200,16 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * Note that, by convention, callers ignore OOM for this case, so
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
-	if (remove_next)
-		ret = dup_anon_vma(target, next, &anon_dup);
-	if (!ret && vmg->copied_from)
-		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
-	if (ret)
-		return ret;
+	if (remove_next) {
+		err = dup_anon_vma(target, next, &anon_dup);
+		if (err)
+			return err;
+	}
+	if (vmg->copied_from) {
+		err = dup_anon_vma(target, vmg->copied_from, &anon_dup);
+		if (err)
+			return err;
+	}
 
 	if (remove_next) {
 		vma_flags_t next_sticky;
-- 
2.53.0.1018.g2bb0e51243-goog


