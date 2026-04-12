Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45542E937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6F56B00B4; Sun, 12 Apr 2026 12:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A88A6B00B5; Sun, 12 Apr 2026 12:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897396B00B6; Sun, 12 Apr 2026 12:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75BE26B00B4
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D2C91B9225
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:57 +0000 (UTC)
X-FDA: 84650488314.05.7CEC89C
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6B72740003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UT0snF8F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012535; a=rsa-sha256;
	cv=none;
	b=wr6IhL/VM6sK0oRg/KqpYIYcWdxx1Tzc+GKutE/CC9saV427lh7iNr4kLkZcGr5+SBxPQv
	iAmmTo7/gajfh3p5ih4DFUkXe5NXkp3k8VmNlPlMYfZFvPKew8vYTtNHujNaRto887OsT1
	cu6DWyXtutikp3z9nMzBpPcOclrwXbM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UT0snF8F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YHiaz/8ldNfrzwL37cUwcT2x0wcZg/57Zc9ej7OYOPM=;
	b=C+b8kOvt07BTi/qB1QsU6JTpNUSqRey9wnyo0PkBQMXOjFfCh2tMlnHSdZkK3J2SlFDCho
	iJU+8qbfbe2Ml20ZHNtGUrt9xbH91bEMY/3abTMIiXSPfWidH0+TAeiHel0v4K2m82JuVf
	194V79vKHLSOCfUWug0cU4URXWGZL/Q=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d75312379so289501f8f.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 09:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776012534; x=1776617334; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YHiaz/8ldNfrzwL37cUwcT2x0wcZg/57Zc9ej7OYOPM=;
        b=UT0snF8F14GDtDsRVUnq9nUbbXv3njZ2O5VMmPVUHgWNyOr8ca1/8e+HT9nT2fxqy9
         26CCGppvH7ROaZlLnUV8ivcAuCO7MT94x/wPbTgsVVsUv/T68FBFXznSONjEvbFk4+4h
         5zcgQLfoa3J5TT1klCHDxxAz4yGlWnJPBak+EKwbY75XniylAluqT5rZp4Opllitgzl7
         NoKvdR+g3RGWtc0RXIFQyQRY4hfBTFRjNl/42pKnfKoDL4OBaR9r6L0zPZIOOxUetklV
         9SNLeGs4P2VNyx8c+xXWyPxRyr4g4hvSrAS2AY1sclP8rjp3eYiGiGvIhdc4cPXDMU7O
         xwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776012534; x=1776617334;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHiaz/8ldNfrzwL37cUwcT2x0wcZg/57Zc9ej7OYOPM=;
        b=DRECJJCNJFn1vgwZO6PHfiwJI6b8bxBwY+EfxLC32rVss/QXF4iXDJ/0QioQMvuEr+
         xL2DyZHR1a7np9A7zspX3yjJfw1nguayKeMphNRF/RKr//4PaH0B0ik8oO8pmpVKncSs
         AhYHzqOn9UuSoUexsZvU17f94Fg3oVYfKDGUA3WvtpeIZL/NOu/yvRmqMpL9e2daLd/J
         vQ5tZHq4eM7lqnGP7YAcSww2oixL25wZVRU+Jb4DOniHURzkXPbS0+i2vCZDs6LPU7+n
         KdCWCej2CgSpkO5dH0Uk8i293Cr+MWOIa1TZ9p4wPNNxbjD3v1NUSwNrwGUDRiz4AhO9
         1PdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Vk9sjaGdxizwEJf8zrCuFOGOVDlDpvD1eaCd7KpWU/9UAUQR2NvaxaEA7dVXLkisR6np5eLRqxg==@kvack.org
X-Gm-Message-State: AOJu0Yypf37EBJ/fAnUasbxsRNlahWOZUgyRMab6YfgsOhJ40DL5chVs
	G25SDDktOr3BMio1UbfAfhVukD4Mo8LmgfaQcbWkAXbl6PmvLzmwoIT+
X-Gm-Gg: AeBDievfuGEJDEKmITVHvGszEwvjVZbj6PZqqlg9ZpL1QtfpsOBuXuTL8j1XkvLUmTC
	Q7lb69juDcDhJTUFCFtQm4KCoegxKP4RVcYYcwPeX6GhktSIZYSfGlVovjdkPJDsyntKGkJb5El
	Mf4YCOW354i2K3nVeNWjLqwqeziDJJk48zHeu4J9/MqUYwrk3ywl5cIdByWpEL9GLo2T9c/XmEm
	6+MV2qlkkjoggylmDIQPf1z7LnW1UMaDC89gxA3e5DO2Wc3M1hZGCTrG7BRctFyro2evldu3uND
	p9Eel3x+Uu2AkjbQaPs2RdRXL5MY3XEDrw9d8DUpnFnnF1rbkrRPtrybzYFaZwL0PD++IPjddV4
	5vpepP83NQmTqRjjvp01INOWM6iIO3mkZyXv0zMx+KVECYehsrODmb+DlCA+VU6XaAdOFjEhLZ7
	qkc4zNtFAgql/0zBYKfXn8EUIGUWCSrgG3ewZ6t1OF0R2N3oEUge1UA807CvCBG/bLOD45uYbOB
	c3ArcVHWeo/
X-Received: by 2002:a05:6000:2d84:b0:43d:384a:9e96 with SMTP id ffacd0b85a97d-43d5955e893mr13042441f8f.4.1776012533365;
        Sun, 12 Apr 2026 09:48:53 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d6fc9d525sm8979201f8f.36.2026.04.12.09.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 09:48:52 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v6] mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
Date: Sun, 12 Apr 2026 17:48:49 +0100
Message-ID: <20260412164849.106307-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B72740003
X-Stat-Signature: 44d3d6kzy5pfw7jaq7xyzn4qzoy7en39
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776012535-992539
X-HE-Meta: U2FsdGVkX1/jJQZpbL4xx/xPNV5YtyOBl1AnrTx1+SkV9Q6+swlIrNZiyDdRUAv2QQodp8krQETxehoeFUOYGCjVD3UBb7Nms7NIKq8YMIeXQuP2VASQ3fSTUSie08WAOba1kGhdts2FCdBftHxdwLBw37dS32q0W7fhisCpIAikLr+rib/WTWRC8JVqjRMX/C6CwMpJy5b64bsDMnfxaAzYmnYI8xVJimyxmhh1CeBNBPb2HmSb0uRpheKzOaDIfthm4yF64bIRnUaJB8WrvIxON7hdnF/bt0PrFQ+w1FbsxrVzpTHJ76IpwvWV3qoeicfcx6AgqZ5Pfrgrpg0zKle0TkW3HD8MwtNqKx618bcB1T56wN/4q986KmjCgWozwOEnsrU4FjFBI3/BEU1phllb5pObwNT16dff2IPqoPkRLu/EsPd2tItIXfk7HdZw2QOTbEFmQaorHgcKKA0CJ9sAQew6mm/9oLhi6YVyeTkTqeYNp8EeoA55n0fHUxAVvw/iXPcIVwe/NOBgskMXE602KCNaJf3re4fv5wQY9EtEdvEusE3/l5Q8w1ZaP4rrZGuAkH9G11gVBTzpcg1tDOQ2fUoPsso2n1k4GOIp70DWH5bwYfc1eTfAjp2HF3FIznbLYJ/MZjOb9+Afb79B0uNdapAWrNmu7SE8YgKzCeuwkihSnvBvgHiEYcNvl2fj9V6eRk/K6YFTMhKkwYtyCm1cQl2dTGg87KVkMWGwS6zoWUT8jmmpxO0C4Iv+NJkf9psKPE+tv2TLOVVLscT8RvsLhIzvcj9yJBfg+bAO4KAqEjefbcunaMNkL7qs3gsjf9P/wUATqHVnm8nrpvJjlWbVxOrFHb3/nG1OBpDbDum6tJlDog24kjS21+ddSOMInS9PT2LaO+dm0+HTJa38dWl8ZsmpkQcY5e+3VGVIF85B/X+5P7s34pifMjTEN92D5IPAgkmz6JSBQcaoSx6
 KpkkW12M
 xjGlO0wmANsKYDIPNtlh/UWRoSB6GxfaH8ZYRneRHWt6VXAstpFlV7nW4BZkqNxxMt7QpPoEuQElRL5s8ry/75lOAgCmkW4376JJkZojd3+og7lWZ0dZLm2QWSHmdHytVMYh0xx7Z6pHtkTVoVaDhZmLDuduzAd0//eKOApsstnngFkRsDshBKiaI41g+Qop/KW3bNNB2Q+dfyhss5JkTcjc8GlbTQ1sp3cluInIz7Anagnw48v2edYji3o7JcjwxdYV/VF/n7LldPsaqvgyQpzdfyeECvqYZstd26lz6HB5RYp/foiXji6mvPRP5Y64o4V+NjobsTez7dYdaO3I22OqSKhV61iKrEZjAMwSdbfvBoFtWCSKDHLYW70qegrEwdX5af79Nuc2zCUgZar7uBWFqFySgTlJjzDVxpjGTouPdMoz3OkBiAgxXMJpCJy62cig3TtO+xyPJsXSUs0s9m3lP6lbGW2YLv0wa2lTw9DMxNZlQ4YEUkTFUyn5chOk3OwlHaFiq/vkbXNdzike7km9n6/4izKtpWEsM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
During this window, the VMA can be replaced with a different type (e.g.
hugetlb), making the caller's ops pointer stale. Subsequent use of the
stale ops can lead to incorrect folio handling or a kernel crash.

Capture the VMA's ops via vma_uffd_ops() before dropping the lock and
compare against the current vma_uffd_ops() after re-acquiring it. Return
-EAGAIN if they differ so the operation can be retried. This avoids
comparing against the caller's ops which may have been overridden to
anon_uffd_ops for MAP_PRIVATE file-backed mappings.

Fixes: 59da5c32ffa3 ("userfaultfd: mfill_atomic(): remove retry logic")
Reported-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/userfaultfd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 481ec7eb4442..7fbe8eca3668 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -443,8 +443,10 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
-static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+static int mfill_copy_folio_retry(struct mfill_state *state,
+				  struct folio *folio)
 {
+	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
 	unsigned long src_addr = state->src_addr;
 	void *kaddr;
 	int err;
@@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
 	if (err)
 		return err;
 
+	/*
+	 * The VMA type may have changed while the lock was dropped
+	 * (e.g. replaced with a hugetlb mapping), making the caller's
+	 * ops pointer stale.
+	 */
+	if (vma_uffd_ops(state->vma) != orig_ops)
+		return -EAGAIN;
+
 	err = mfill_establish_pmd(state);
 	if (err)
 		return err;
-- 
2.53.0


