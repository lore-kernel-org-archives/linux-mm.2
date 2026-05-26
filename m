Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF35CCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245D46B00B8; Tue, 26 May 2026 13:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D01F6B00BB; Tue, 26 May 2026 13:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070D36B00BC; Tue, 26 May 2026 13:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAA2F6B00B8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20E381C19DB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:41 +0000 (UTC)
X-FDA: 84810333762.05.241E0C5
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 31F4840013
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aRoO8OeG;
	spf=pass (imf01.hostedemail.com: domain of 3id8VaggKCPYYpbZ+egremmejc.amkjglsv-kkitYai.mpe@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3id8VaggKCPYYpbZ+egremmejc.amkjglsv-kkitYai.mpe@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjw03D6SHFyZLBNhPne++YEq9ou7VA2sQlGz9HbrowM=;
	b=d605iY76m2/2D5VpqwS3BUJauRmZF9n/6DP7VznVoWWSMngryHFQ8iX8TSltDjJMvESErM
	EWhOAuCOJYGAUlKQeTHUI2+Jyo8ghXJI0+r9mG07JGx/eer71QWeJ5a2EYzvTcsQKSI07l
	cMeWqNHs2WC3Hhcc3hMPIssBx0rD8pU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818379; a=rsa-sha256;
	cv=none;
	b=R+l/XtRnGoHQEspLqesGM1PvZT/Yx5HGwTQ2hitIjhbLPsySD4XT/Km6Sq1Gt6vfCE0kEL
	E+hNtr3wcGcJnTBpw4n5OzcA0cuqDBxjkWAFD5gS88CKSGLGeKj+i6sO7GKfZpYqBzsdZG
	opOLdrdQhxqiOqXV0bCTxD8w13xQMZM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aRoO8OeG;
	spf=pass (imf01.hostedemail.com: domain of 3id8VaggKCPYYpbZ+egremmejc.amkjglsv-kkitYai.mpe@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3id8VaggKCPYYpbZ+egremmejc.amkjglsv-kkitYai.mpe@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-44ffa15dc8cso6705159f8f.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818378; x=1780423178; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pjw03D6SHFyZLBNhPne++YEq9ou7VA2sQlGz9HbrowM=;
        b=aRoO8OeG0ETjPNIRJFgPsepD4y2f7CvHAk0hIBbajWBQpMNIo/WrW5qqR+5pJwrj59
         gE66vkRqWqxZ/SvdYWyAYL/QYTFgD9EdIj14hX/mTNLl/xotRusrFDJ+BU2QkFtLWyH1
         siVs7BoRH7hAqYwTTewWQPz0Su2FEJ6quxr9rG8ZJ7NoD5oUxrFY6aZfIXuX75A+b+tL
         O6WTEmwFuLkFy4Q1F73ZvljhuOcCn8xk9HxYtBGrc+KQNh/lX0boHPT7g9NKzs02/q0E
         BMl2vq5HP/XVQnrK3VA4yvdPj3F/eAyKQHUt+kcB9ikTtCGunOSNjSp2FJC9GYeN6Rou
         S/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818378; x=1780423178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pjw03D6SHFyZLBNhPne++YEq9ou7VA2sQlGz9HbrowM=;
        b=rpCNvHOUFEcgqzTxxmWbG0r7YfA69WEtUjMqc8SNmov0krrMoTss4c8KSSUVNAv8U2
         Mc3/g/82uNMtWV1n2AoXFQ2fqB4+21bIdmAHVmwFQz1tQz78cki6MGEOrNpAbGd/Ar3q
         GuvJGhKYA/0gUaXpvi7Yb7a5oYyOPDRMzsNU4yRDkGd/Xkw+cNmFf+PK5dn4KP8SOeaF
         1L+ce2O9a2OBqocarnqmQ8u9QnDyAW/i9Mg8BIYMvdCEv1WH4aDw2GRRSQ3AV9PAhCDY
         ve2+8DJSkDuYuBOeXMT3yJwIQcUtpNC1qg0bWw47hjFSAMXQhQiDYWAop1HJA3nObOO2
         JVmw==
X-Forwarded-Encrypted: i=1; AFNElJ9JadBLUjJBrzgTRCbaZgqtI+qa1ahzLOmaYFZYk1yzcCTqK5aTsJ84ODud9RbxSu/Sy7itUfAgBg==@kvack.org
X-Gm-Message-State: AOJu0Ywepi61d0E8ZHP7T453YKJQuInhqJ+o1uG+JKkCTurj6Lbtwc/X
	/CB2pzsYvX26t+JIMVLnGW7MNelR53FIAjZO05gGJPKIHNbUYY/FvS3PqF7B8I4+TT2siJeqZQ=
	=
X-Received: from wmog11.prod.google.com ([2002:a05:600c:310b:b0:488:7f73:f59f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f88:b0:490:50eb:b777
 with SMTP id 5b1f17b1804b1-49050ebb9e0mr289239055e9.5.1779818377750; Tue, 26
 May 2026 10:59:37 -0700 (PDT)
Date: Tue, 26 May 2026 19:59:00 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1330; i=ardb@kernel.org;
 h=from:subject; bh=P6+9rEICJJwtkUC1X6hejRp2Q1Pr3xumYehGC6YytMU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fobew29CRUaVxU/ZtLw+1lwTWmzi/Jj1qSv70V6Hy
 z8YV03qKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNpOcfI8HBnlRjjxeVTqlfn
 ZXLs3ZJ7bJOj+aZIhVt/dgfO0n5tlsrwz8LsvO1Fp6MbfH7/PnJz9VaPp6kP950W7qm/NTevLfh YHjcA
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-30-ardb+git@google.com>
Subject: [PATCH v6 13/15] sh: cast away constness from the zero page when
 flushing it from the cache
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: so7cjhbmgfbdp87ctz6qz8ruaycwsdwo
X-Rspamd-Queue-Id: 31F4840013
X-Rspam-User: 
X-HE-Tag: 1779818378-334701
X-HE-Meta: U2FsdGVkX18bAyfIzrJnYhgK7/EZ01VT+aDhbe14herWflRKkLgiBMf2jey+XCYHLazHJ5V5/qUatkgnLst3wxCuM4KWDAQmuP/bvB6RFW8QsUJv/WYsnLWOAUh78xN/sQyBN7qNldMVtazNGF4twvTVDyxyXCXf92VTulfkDSJoi0GgS1zWjIXSvSdUvSfULz2rpLu0++A1MeToCLzk9RSgbBmATNFBXsfwxHqR2RB8siBlj3hOho33Cxx34zgCUiKNfnAPhsdWm0nPOCKMzNzHcGfdBou9WIFznCtPEwtjzvl13GqemMbMLyP+1H0TiL8A8LRm5Z4MUla755ZH98aBxFG9S0BHtCK0Ig/7t9FA8rPxNXkeD4KPs9CPXAvZDb3XpwAsBq/CoKVpuSWWN6KSH8pPnODiF+flh9W1dDWej475H7w8XHDtx9Q1c50s/rxyNZlC4bYGekIjz+PevWUvkuNMHO7xcN9lCPzLpuK5pb63C2Gv66zkjmKNSLmlgL0yGCfgBfY+xxs2eJQO64rIaW+/RqEeoo2AXBP5Rqt8mZHWkFifZj5iZxB7AQtWcw9z4sYu+FSqAjGbPKZTFvgv2rhJXXGWh8woJGOx0lk/w3bBD7N0QnfcVvipZDKzjgsP3Pyq4qVwDjGL5Q7AofdQh4gK1CNh2whPZ40DIYra7HcplAf9XGuYlfvLeW5oABWZbEQP56Iw+fgy3TbQzMAc5bsuCW9Jm8RFd1n62u4nvBj7dBYXld8Zo9f9uMRNZsOUqmlRZ4pRHTY34siShenQVZ9zPYCo8oqfZFKQLsdBqqlbG5+/vEovvmwk+vQVVKFvSrGrVeTC/poi6bQPBUJzPVW44qUX2RYNsXoHv0rCudd78tVL8v+QXXXwtVW+qCcYRMk2CuI4CFJBQRyVvSTRtZXrP0DbI/iU9L3S8LuTRfoijuzwgGW29Zhgkd/3UqkaGLaDSfGcobSuS//
 wuozM331
 p0lEpGeytDOswF9tqXqWdHWp0pO2Kl2/pxtDTF4bCmqH+xjUZSRHd4xJP7XWFQmQhJzPUQps7K3jGze0iQnYg4Tg1lptlL0CyvIQsWVZAyLClFx1w7r+LsXRw6T0jL/6DMCLRevju98VoCtnPuKF8tWaNq2gRkC75dtx6vtDH+IUom3MX0jyCTkYQp/IurnO3Dx06AcXFS8xjkIKSCCqU1iwIbjLWbUYeGKuhJr9W+1QsQjS9Nq1FEXNOXlT8D4ySkkjdO0DrxB+yn0VHvWMW4YAPsbg9xY0AQxbC0GFNKlk6ymZGPaaDY9pgsezdMoqu/DtDQ6prbzvZHh4OY00AKuLiEEfIUZoFRNiPbp4osxOsxqp6fyasgMYc6an+xqlPINMYmyDZHG2MO4h4NtNABL2B82bDBmQ+F+4s35aYE6+63OBAgL1riRk8oaxnZ5twngKUFVrWtWcLW3vlcqNShlv3+nihcjrHwUbcrlb6v5DdQdvg2w2mw++EdclvJVKxmlLMxCTGnlPKQK3DkbsfatI6MdWTGzAaSca6XYNa72A9f2xebQ+jh86Z2Ikn644Ijq+cHoKmLpuNG3lDe4MNXyJiEsbL4eJ4GbtfhAJjVGGOXBz97uJs0HL1hnjPEgaj47VX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

SH performs cache maintenance on the zero page during boot, presumably
to ensure that any clearing of BSS that has occurred at startup is
visible to other CPUs and DMA devices.

The __flush_wback_region() function takes a void* argument, which is
conceptually sound, but given that empty_zero_page[] must never be
modified, it is being repainted as const, making it incompatible with a
void* formal parameter.

Given the above, and the fact that __flush_wback_region() is in fact a
function pointer variable with multiple implementations, take the easy
way out, and cast away the constness in this particular invocation.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/sh/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 4e40d5e96be9..acbb481cdbfe 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -332,7 +332,7 @@ void __init mem_init(void)
 	cpu_cache_init();
 
 	/* clear the zero-page */
-	__flush_wback_region(empty_zero_page, PAGE_SIZE);
+	__flush_wback_region((void *)empty_zero_page, PAGE_SIZE);
 
 	vsyscall_init();
 
-- 
2.54.0.794.g4f17f83d09-goog


