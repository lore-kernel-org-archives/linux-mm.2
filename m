Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947D8F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE4F36B0089; Mon,  9 Mar 2026 11:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA58E6B008A; Mon,  9 Mar 2026 11:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC966B008C; Mon,  9 Mar 2026 11:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C127D6B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:35:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F9331401F1
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:35:02 +0000 (UTC)
X-FDA: 84526922844.20.1F71073
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id A3C21180002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:35:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZdPFtEUU;
	spf=pass (imf24.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773070500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GyPGkVOEzuOj++oEdOrxAUPo+L6IspicUK5SJ/430lI=;
	b=M+tn4NUH/nhW3dEjlCaTq3nZ7ti8k28ecjVscdK4ckkQRPXJm5YdJrWfFEaInO00M+11nh
	5Q25JmHo2WZ1wM28Y2Bc7DuclTQG5Do1SzadnQVdClxvCilvst15YGpFt088s2LhBSocPC
	KSh8ebXFccDynEpdhok2bw09RrmeHas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773070500; a=rsa-sha256;
	cv=none;
	b=HeSSIVuYkGYQshZHHythy8U1/gry11+xz+SVFXOoaT/EMFOxoO1lFH/TimdyUJXkivnTGe
	jnjs+38YFbmdDLPkQWVNUDuZ7rIZXpzGlZWRVBNBJGjsAQ9PMLPlXRwve0PU7SQP+XJrXb
	pwe3bx9CovMhGYgfPtlwhHj0U6eesAg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZdPFtEUU;
	spf=pass (imf24.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2aae4816912so77820195ad.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773070499; x=1773675299; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GyPGkVOEzuOj++oEdOrxAUPo+L6IspicUK5SJ/430lI=;
        b=ZdPFtEUUbQhAL5/O0ah1MtfUtrjVAzwvCFazUN4T1ginPyzDApMUqJcCf5jfwy5C6c
         fQ41m9uYE52qxYDWn4G+5jwqdNNe08ee/QTR/9tpkQyF9cguSVfWXhcx3yvuOC9evdSY
         57Os8Q3ElNQvEM+o67SFtmV0onyK9GjzCaEjDndu7IhuZMArgE7SfRmfcruw4AWyfn2I
         nijZwa6FUHflAw+gRG9GkVkRxep/Mq3mCXyFeBODxxik8BTupA+FmDbfOooe3rdUfMZT
         YQ53MtMsNOqD6ekkX96Ad20822qcQL4MJqxvIJhzHA0afBz7nQU1sci1ez2Y20pJnQUD
         21cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773070499; x=1773675299;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyPGkVOEzuOj++oEdOrxAUPo+L6IspicUK5SJ/430lI=;
        b=Pzn1hKrSyHXF96fUiftqc56sbSsS89qCjA0cdcnz4LfDs/up6U41m3UYZ7hLi9jXfK
         A+27MItWtzDwPftIjQp+I3qm8kgHhNeDjMKDHpsxMCSjQcTQlujCszIVTIOMAexN1eIl
         f9KpQcKKGagAcKdxKc9X6VhrO+keKz6dCn9mhP+/7Uy3fFuyg3GV3Mr7ObJ4yHBvhy/6
         IizV2oYx4aUoFIdqDiyKzsyTaRBTISEgCj9Yug6s19zll/DWTVkLOciFmeJkSnob+Wvc
         elhIIFyjDvmzCvd8+Lpv7z0RiyK/QztA8vGBLt67pMbb2yYfuCPmHo2/hK3mHgKMAUgm
         /0lg==
X-Gm-Message-State: AOJu0YzUN2HnHjc0XMzu0EaJFcz5baVrpxB1JETZZQkzvMqotk07xWME
	KfLUTsrxOUyD6FRbZ64ijkg59CcLBHm/mzh8WizVI1tRHqZXQuY9OpqGzfJJaZh7
X-Gm-Gg: ATEYQzx7JDgnPqPrhFO9jNu9hLNALlo0LcrPG3qfBJhH2Va0Ay4PdokpLRiCgKQ0loX
	xyS1jkyB1LqgjkZUFajripviNensv/bWZGgoIN/rt4YwUfIg7dITHBirootXjfqbRIuzz/sdO5X
	dwk3Zf7yuazqTlLh4hSEGng6tInY5yshVs7gMnWXGENQ9EMzqsYI1hqDnOCSwjSxZ9r4sM3ripk
	4YFXUe/1uR3LaVOr0rivE95bGUYByUrFM1JiCVmzV4gyFP/UTn3wSWhX7mTQcMnHaGsOk6pGjyz
	ngx6rC+X16DBBfKUe6TxHQOWn04+aP1Ys+VfvF2F80715IFWdE7zrS1GIYPIdRyvbLlqigOdtum
	pX2wKbTkUHoHMJ3pl3suxxcX2wIZ3WvprsBioUG0rJBcwoQMYNi8pl/Jhdx5F+tBqDszMbRcNlY
	EzFrudb1fJgSLRvjC8ORKgT9dIHIil/3Y+DiUph1OIb7g=
X-Received: by 2002:a17:903:198c:b0:2ae:683d:12b8 with SMTP id d9443c01a7336-2ae82443b5amr113592925ad.29.1773070499404;
        Mon, 09 Mar 2026 08:34:59 -0700 (PDT)
Received: from DESKTOP-3LEPQG8.localdomain ([119.28.20.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae840be379sm118342985ad.87.2026.03.09.08.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 08:34:58 -0700 (PDT)
From: Xie Yuanbin <qq570070308@gmail.com>
To: rppt@kernel.org,
	david.laight.linux@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Xie Yuanbin <qq570070308@gmail.com>
Subject: [PATCH] mm/debug: optimize once judgment with clang
Date: Mon,  9 Mar 2026 23:34:05 +0800
Message-ID: <20260309153405.20130-1-qq570070308@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: prmj11xteku3gyon18kojboeg9imcri6
X-Rspam-User: 
X-Rspamd-Queue-Id: A3C21180002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773070500-450327
X-HE-Meta: U2FsdGVkX188TGTNBcOvU10kn7gbjw7Y7FFf1Tuk9gEF1LX8x9OXZvxhM3wBoVpYJOPrx4VmC1E7e/+oHqTy7XApB0lY8OmOk3+FF3REOUqxQD3KCjC+7aqUBj9Xg8fAgpTKt1fon9bNxPKkX/2flQigA7o90UkV96UOajNzCuaGfMw5q9pWTRsJhlym8R1OG7vZ/jJM9sIp6zpiuF/6xBf6cD/gYxLph2MHUBZzb34dhJImvSEi8/6ShDIBq1cq9b1ykFJsjI/BpII4khElsqA9nQ42qE9bJjKUugv9jXdaVjAGqvvG+bGYAGL0ZEThOR31IzkUgy0NraYHgoUhFd6h4FA6KD2gnvYMW5sGruugmwB5NGc0da+wTzrLDslcN5mg+l8FmMXdZASfhoESjKqrqzL+f4ihcUSeBCRQw3lU5TIeIA3FvUp3WQR9VOvCWPUpzQV4tMOxJYE7h80Brm5Qsx19U1HABlIcM/yyQKUqgmo2yUrE4IzjF+RNV/Caco4kPpZ49r93rUsz92JshguGuhO1B59RRf+uBX3Eq7PLCe8gjTz4N8CUQWntp7j/uuN00aRetuF7kMZ2M9Ud6WbXKrCVygdXGN/MqeTGeeAif34gA9dkGSA/PwkveQgsxWJ/DjnRTO1qwyyaD9Le6mb1WlMWkxXytQaQHQzu4C5sssZn6oxhebFopo2L5gAjk8YZvdgZQ69oAbT8tmOmAs8fFupMpl4o563jx5Z75hGgqPZqO9cdd9l84tJzNGVOytH7TftK9vMSM4S49dRGQ9FRMwEoxfgPJvNhe3i0qYeIYIT+nPBpVhMZeNUszYXvC94T0BarsG2Z4rSPH1Eo1bd1t/3TFQc+lwd69Cj4Ysy4+bg+vEpaQvnIPvivMnICvTR9zXDWcILItxehklwLxHmuhza6SLbkXQcPiUcKC8p+eh8CgU30Ckn5LswSOW2Kz3ujBfcwGAbvp1U5Pgs
 KiA4LlGP
 35Gv8MuK6gGCJ3+RCwgy//RuWK6gqoqTi0Qdqa5kOSqxpCDvyLEiXklLvbYBfgVTD9/DgZ3MUEU5c/ZKBvVbuXlVEUMkeHkaKgSIsO0hU1D/AobG8Y65j3xREDw4r/ueH8Vio52QilNYnNMoCG95WrnVszD+MgYVJ4DnRrVvzisUSQQZme8hpbBPK7h4crrE/7fE+BfTX7kIwYzWa/TlQWcAkyD+yWyGUyErpxbD1QeLjYsxY6Ofz0BvEcVEqA/fHrAwBtEbl6d5h2P6Ke18aIB1f20c3BulvQbRMpX7AqZNHEvKytL/NO7p3bvnQJ6ed2wf3PoZIrGcjQkDacgB8mVgZLJZevqLlRvdM7L5ovywPPh96R11BQWiOVQuKeZO6Q6IPxLi3eoCSMXNScbOl81BGygcSGZelcycywGD3Z3ylzJFIknlCpwRHGP+CcRIuebLNiW/o6fU7Z4ukHtIF+7oTelrBW8P7Q8+ZeiEpjHKGAB44e2a0nCKHnsLVb7vCuZ2+dPTuTftzTxFh6wTfynHZBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
WARN_ONCE with clang") helps optimize performance and size under the
clang compiler, but the modification is not complete.

Port the modification to VM_WARN_ON_ONCE_PAGE(), VM_WARN_ON_ONCE_FOLIO(),
VM_WARN_ON_ONCE_MM() and VM_WARN_ON_ONCE_VMA().

Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
---
 include/linux/mmdebug.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index ab60ffba08f5..a167c5aa525e 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -60,7 +60,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -80,7 +80,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_page(&folio->page, "VM_WARN_ON_ONCE_FOLIO(" __stringify(cond)")");\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -91,7 +91,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_mm(mm);						\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -102,7 +102,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_vma(vma);						\
 		__warned = true;					\
 		WARN_ON(1);						\
-- 
2.53.0


