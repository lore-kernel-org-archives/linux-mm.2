Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F68606A22A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p9z0FdU6
Received: by kanga.kvack.org (Postfix)
	id 1D7686B05B2; Thu, 12 Nov 2026 12:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188366B05B8; Thu, 12 Nov 2026 12:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076D86B05C4; Thu, 12 Nov 2026 12:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD3CB6B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:41:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 258421A06D4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:41:07 +0000 (UTC)
X-FDA: 85427182974.10.3068094
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5420440005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:41:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p9z0FdU6;
	spf=pass (imf07.hostedemail.com: domain of matthewsalsamendi@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=matthewsalsamendi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794505265;
	b=7DjoGfxS/5HjTz0tbY3IzydrJ6gQ4mcgnDr8oEZjOw6CNQSdLjB4Sw6fNI+kvTo/WPRogu
	YMFABA+CG5OV0PXRJAHDnqOPbifAeC5V+swFxAhhQrDI5fNkvt5Ybhp69QIvycjZgf9cmX
	7BHWBKaoFlHSHnv2xZsFIz8+CcmDDhw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p9z0FdU6;
	spf=pass (imf07.hostedemail.com: domain of matthewsalsamendi@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=matthewsalsamendi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794505265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gulIbZCmS0C3qCKYVEzdG6nvB054k2W20/UwIzcuJw8=;
	b=dfDYs3KkHBFRpCZ3TVS9WRo0dQAHtjJDpeRfegEGklLpDfY9m5bFfn4WWvnZaWx7EB5maJ
	SgP4EImMJe+TYh7omuPoLcznQNRqwLmibPB05zYwCd6BHSPVKawVY2ptmV72dZg5DRdxB5
	L1FFlb9GbaXDLhxDiA1DTKJSOYhsaB8=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b7bffb5b8fso73678a12.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:41:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794505264; cv=none;
        d=google.com; s=arc-20260327;
        b=GrkbkLVUlM7Pn1PyBMUsYoQjejSsv+z+ktNhvw1Y7yAZ9YxUyR2vMVV5lK2mBuILMy
         7jdaGmlfhUx1kuQMeA/7lnW6uyTPLfK1gwKHeF8oUGgXKBcMFQoJEM8p9IkeXVdeJJCW
         j/XhjYdMMeQ4Msx0G/DL93HD0O14MrEIjhAWwavJ2nby36boSAp1GX6nFV72aIW0/8vf
         QJVQCW7AY2a04b8jq3iQ5uB9uhj9Fb0cJe11PycMcc4MxLQGrJgboHor2tFLmPqDqusc
         /schabdixkdSHOCukKBXSpir44eBywLZEOLur8qwi5a4YRuVtfJ0Wd0NYX9WGSd92b9h
         sM7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=gulIbZCmS0C3qCKYVEzdG6nvB054k2W20/UwIzcuJw8=;
        fh=HUg2oiE7HJvYTwbSYF8+WFwVb0b7dgM0KifjWgeIgkw=;
        b=jwqWTx9qSDvac82WEZOs7BpDECmbgYjRQZJCRGtiejLiUhrL3OV1X+Epl7o55uUIuJ
         uIWHoMnarPdGb/jsg10JsUGaSPfveiHubOVvzDBhU4dO+xsSHuDYsYEK1vpe/AsOR6iG
         j3cXqxwvriPEzBkUQG6DUw3v2wtVBf+kiDshJr/IiHPGHFWREjOBydrjy+4TedwCmwZe
         a4FKrtcBzdWqz8KcDiwwZvYJ2hlFIBs2vwC23Uk3GGNYX35gz8bAsVK4jIjROYsyUGS0
         7QX5IuoelBmsnxMbeZQChjOxOIAIzD4lMB2upTzXDk0fyGu3NMDFuwGgyQn3rP4Jbwl5
         frAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794505264; x=1795110064; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gulIbZCmS0C3qCKYVEzdG6nvB054k2W20/UwIzcuJw8=;
        b=p9z0FdU6q04GsDggb0Jz9kpcGkGS3pyfeuqAJDbWkahdGku6E7CJlvqtConJGHjpMq
         4+pvuAI/igWiFGFwif6Fhrlc2vkLM9TI9Rb1vq1AT1xtft9x9AiqC1Fd1IrsURC7ODz7
         I3hQi2rmw1zQMtMpUzcSsDJ0L1Y42kxOBh9F1/y/eXgkVzWEmY15E+XXvW85LGDiRxsV
         A2T/vWs3S/GfR53hCklD6iw7KD5KtAy1xZ4uc7txFe/evIDqCRVm2yle+jGnPt9lwfXi
         29SmS6m+hzZX9a2LcqD/oVXKmJV7Jt8mGuVoWSkr33qCh0KSl/igbaX+gSaflQ4vaAKq
         ZgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794505264; x=1795110064;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gulIbZCmS0C3qCKYVEzdG6nvB054k2W20/UwIzcuJw8=;
        b=SyUSRSnrF2FGMKdASwhkSZz4T47c8tHpkcjIjnQ+PGJ9/Rj0MODRy5g+W3R82My9+T
         IfUCCjMRL60BYWIRuE4Zd0j99a7mx2IijQxVqOMjhfcRCHb9rX95eQB2SAEH5sfVpRMd
         aJFk0FNZgXF42Hwl684XFBUsLOdTCcqyUvW3rJY0yV0GkzsWMzOwtXB/l4AFn8l30o7K
         HBICGSzDv/lcx9SXkPjf25H8y/uRJpmmFjHMlLq3tSGyh56uOu9x0Z064uHbXMF+isCM
         UVqnTnxOSrrI9bQpr1yG1TnaQVAJV95GGZViv2le7IJ6NDzYBj6nH3Gn83ux5apmYJcd
         GTeA==
X-Forwarded-Encrypted: i=1; AL+hErF6BxNE11MvI5UvYQXkBUr+fgGZNH91Zx3IbglQ+hE4kpMvis+GZk9/CgmUgnShA1gr0JoQOKafTQ==@kvack.org
X-Gm-Message-State: APuU4Z8m8Vz30iXn7RwM9OEPO5DFVfo1YL+8A3n/jkiYNlgz384cv/on
	NDZGS+48yedZXTnJ4WOIfWpqhah10BNzyeb5gKCVSLc9HLOFt/Ict5RfklSSEkL4UGZY5z4yrjm
	AsysscZlZOQmtw4Vd/aaLYiDfUWgk+gg=
X-Gm-Gg: AYBFou0qEYqdaAqDdwKJZEdSyEceEjbJuRGmpvcbYsFEDsoyEAnwUC1wC5YZGDDwNPZ
	9B0ke7CmYeDm0KCwc+bw4819AdX4Ovm8L9fYfUBbG0oIwULzX+CIvYDeSA+Ds7ki612Tskbmqqd
	LYSE+MkmSERaUu8G/RlR/gflblcwuZ7PanE8T43YgLeExh3C08/afTf04WYwJJ29wasjzgcuHDs
	NZWWA8y9oZFdgjhGlsbBcHMOO8Ag4sd0h8fY0FqeAGYxF1IVbCHar/6JhXqbGtm1rYw853wUESq
	R25Z6+EpmCiD1ks4BbWcQ9flwZfKRYFWoyswD32995MKn+Mrh4za1x6qLmQ4S7pdbr28gEA/Da+
	5nV62ff6mbRFwmgHvRDLP8VdUeaVAuMKX7fG1pDBUagF9O2qQiPokgVsmTA2Hdds/LkRMp9ztjq
	/u7feZynOCww==
X-Received: by 2002:aa7:cb59:0:b0:6b5:767e:f030 with SMTP id
 4fb4d7f45d1cf-6b7c088f8b8mr247576a12.2.1794505263516; Thu, 12 Nov 2026
 09:41:03 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 12 Nov 2026 12:41:02 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Matt Salsamendi <matthewsalsamendi@gmail.com>
Date: Thu, 12 Nov 2026 12:41:02 -0500
X-Gm-Features: AclHuK-rzhfZstrK9oYTveQMuv2rKMtHi1eKCo_ucxE8NDs7sn-o7nsC2VQ7AeE
Message-ID: <CAMPWk9NE_epOdOCbs1PGh8OQP4wjTObvjU-1Wopmu7SSNAMXhw@mail.gmail.com>
Subject: [PATCH] fs/proc/task_mmu: fix stale walk_end after a completed scan
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5420440005
X-Stat-Signature: 3qy7h5riagrkhzbk1dnpnrtbwo4yq7ds
X-Rspam-User: 
X-HE-Tag: 1794505265-706251
X-HE-Meta: U2FsdGVkX1/m7YrO/Fn8LVrX9zcfm4CXoNfwgeUfbx8ql/o/NWWbOwZtIkcc9zA6/K72qHdt61wUJ1s+wP11/h7v4uEo/wBtF4JD7S6GJ6R9ajWkM9sEh9Y1b8fDhgjF5oUBdwOxiTkXjX2QIaawaeFSBE7dUZVq2a37lL+T8koZAcaYTDXxCq8jJecIRCwRcYGPpRGIZrYELsfE922VpH/799wNX1EwX03wT5/aNiCw0IXR/YxxPvSTeEqw58QaWKuGXgdXAPgfR/19MH4KBB/eDHIg1Nd8sLUX38DkDJGmYZCWeYJ5kbKCj3kaMHZMNSiKzdTssKIwxJfCMdWGKpVcFS4rlkwsQaM5dLnuuXB0R4eJN0JbjGeYLo8qtlPGZ6yBdXDopE04Vnv0/T+6HF2mynzgT1nBYH5ekmXtkqEmPUO17c//awHoINXk2vfygNgMZF7z9kwMu4jUYgPqPAQQU9iVBSaFMOLPd001xy4nkE80mLqmjckH0CK5akXKTSUTKxsUPq0eujKEJZSYoj/MrrvlwacPBcFXKRmkLafavOlry2kNteAcMSAZ1liNWYXTyo9BSrKlXj8QeJwZrf8gw80flelJ2dP7x0JRHXcqe9QyqlVSgdrK9UsqBrgQSr6iP0OTBW5ZIcjjhA4XiM5yRmi6r9rPnUIbEm48dtzrNlA0FrQZXeggxK/a4aoTyr9HCnVU8GIoYl3HG5E5xbcPhF/vsVZFsiraHNfrRNIXnz2prEMHZ0iHXKbvz8EKqaUbCD/FkDr8CJhmELAm565Lsy23OykbTOXGTTTHEqWV40QwyqIRmBQ/8il2l3SrgTnXYeBlYcmVm+Nah5lrrrIv4NuT5yrbop7s5zcQj8FKS57hs8RUE2US0dfAswUNHqYLWp8gVOZjV1Jf2W5+HuZ4y+OPL3yXo8VKUzdZ7HRFNeaOLt0fXBp+jekp6ezc1tIZ8gdGWu13GYilt2W
 lTgJEhOR
 1jb+To37FiDM8P/NOroIiV+2FSPbNCqkeKGlWw+CRKlnXfDhZDfGN9xXJ+NRqfVAP+Q6Ob6MkqWHdaJdoJE6gCvtN5ekSXA/KLjL9Eyge1azccgG2PteTKqCINHATOo5ZR6aBHVfcWaIZe9+FXMmJitDzj8vE39UhrwyPYqM6TmTBtXbYsesOHCIdJGeO7+BBVFLs8WXXO+P8PABLxuc9hLqwBz9kAgKrc13GxJWxrGEBdIN30gVkR2u/NwXum83+JbkCj8I5bCDGrUNzbEkDENqp8aAFg4HYXjmUiC7PSurT5sWy8bIJKiOTc4UL0T9MoEeLbww0329TlMH7OgTH4yaeN420/uTnl1xKF1GmZUkKzUSU5VX1Lb+V14+Kn7JyUQRqfsbAWC4Dd4649zfWKm83pCP798Nb1jTbXs/NLgPjdRNv6PzyJ0g+CCU+mG67fmf13L6O45P3nHQmGzA5UmuJjjw/gN2m7BDYdlVOg5M3WkjOEoRbG5+gq+BPtVTXb66WRZCvvA8aFwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matthew Salsamendi <matthewsalsamendi@gmail.com>

After PAGEMAP_SCAN fills its internal buffer, a successful final walk can
leave walk_end at the earlier stopping point. On x86-64, 513 disjoint
written pages return 513 ranges with the last range beyond walk_end.
This trips a bounds assertion in a userspace dirty-page tracker.

Update walk_end on successful completion before replacing ret with the
range count. Preserve the stopping address for partial scans.

Codex assisted with diagnosis, code, validation and this message.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and
optionally clear info about PTEs")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Salsamendi <matthewsalsamendi@gmail.com>
---
Validated on x86-64 v7.4-rc2 in KVM: all 12 scan cases and all 119
pagemap_ioctl selftests pass. The unpatched kernel reproduces the bug.

 fs/proc/task_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b87d3e864..14996d0ba 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3176,13 +3176,14 @@ static long do_pagemap_scan(struct mm_struct
*mm, unsigned long uarg)
 			break;
 	}

+	/* A completed walk may follow an earlier full bounce buffer. */
+	if (!ret || !p.arg.walk_end)
+		p.arg.walk_end = p.arg.end;
+
 	/* ENOSPC signifies early stop (buffer full) from the walk. */
 	if (!ret || ret == -ENOSPC)
 		ret = n_ranges_out;

-	/* The walk_end isn't set when ret is zero */
-	if (!p.arg.walk_end)
-		p.arg.walk_end = p.arg.end;
 	if (pagemap_scan_writeback_args(&p.arg, uarg))
 		ret = -EFAULT;


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb

