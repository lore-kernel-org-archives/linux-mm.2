Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2F6C5AD44
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 20:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440CE6B00D7; Sat,  8 Aug 2026 16:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0DC6B00D9; Sat,  8 Aug 2026 16:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8FC6B00DA; Sat,  8 Aug 2026 16:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6E546B00D7
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 16:04:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B26314041D
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:04:38 +0000 (UTC)
X-FDA: 85079179836.18.37BF4FD
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8221C18000D
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:04:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WN5qD+py;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786219476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FTWOCf3x+WMKSnT7DYKaYqLrpreFxQU4MBSEOLxHycI=;
	b=gXjS/dIMEh+0o3wAnM9/w1dq3uFXlkOLXgzAHLX0lkvZfmKh/N1Ihw0ihMvCjfz/QcaE1o
	32eboQ6I54dIw/QuebEkLmhapFhRJcr7PzEMz9UgxbouaBg2CtoV82fx94CO3c4gbZtZaN
	CbwA0y0e39bm1VZtxFTESncB3+kXeb0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786219476;
	b=o7MlyASeVbyU62YEnYUMvY1gSmfqJsECfgcjn5DD6QlcY69dW8giNlVnTjRvwzrJlMgGZL
	nILhoPQI2fKe8/SIEm8ljccQ3y3vQFm8w4GDPk6d8znNzwVuFJ6vy+Ph0d3s7D7FnjPYco
	A/YgdQAaPaIsaLgaQI/Cs76w2/PgPjE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WN5qD+py;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4957eefd361so3994605e9.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 13:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786219475; x=1786824275; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FTWOCf3x+WMKSnT7DYKaYqLrpreFxQU4MBSEOLxHycI=;
        b=WN5qD+pyvxgXeelQK0l6dS+8ypXvuWhg5odsW1vKGrbbdXA+abR1M35Mn5tow3atCR
         9f65/t+DrcIFWrnyoMOWco4BqbXnbvCTE4v/EY34HzG/4jUHB4FWBeZ3qiod95ZPbf1E
         /5L47Pig1Bn3Wj96OGed6dxOsIbil1lH8nnmdupqU2hJULX2BhscjjJOGtYJKYjGt5IF
         m3LmA6gp/nOZ6HzG2+ahh5ag7cLgBFXozvM+eDcnyzw74KMAkR7wAwTZNCB9NOWy7MsU
         FSgABEwRAKgLZB1fnP4xuBv56XCV+EBSSe1hLh4BQ6Il9GhsDW9IWLn3yDj0O4JEatNu
         3apg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786219475; x=1786824275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FTWOCf3x+WMKSnT7DYKaYqLrpreFxQU4MBSEOLxHycI=;
        b=E5fjVuYsA5mNAmH5WCfxAeYipejmYQlqlHFTI/S7ClmAqhGlzmM6Mkl/pOrYrh9slc
         +4pMxXDrCGf8k8FxAxBVWivbTXIRCGo7EJvMO0cXAYfBSdogdn+tY3t0kwJUnoLZQSn9
         IziGHtMf08Zbv+XNnWzps5gCuiGYiv81S7JkXwdgo14xExWPb67N4mbstggkjEmkXqKt
         NZb21xY0BXs+RaWrwUed+Al0Pc31Rf/+BUI8mXF046erlNWushnErbX27VuZ8m7E5EA7
         5ZoE34CdYag4gzrv72H46zQy18L9iXk6P066RRIyfGmopuuyQ9SGHmr6F/483l5vdFzj
         +S+w==
X-Forwarded-Encrypted: i=1; AHgh+Rr82ltFgm616IYIiRA5Mc0q+B8IyezSvy9QAycxw8S0yE189BtwHQFpZaiXS7HoZH677ImgRJfy0w==@kvack.org
X-Gm-Message-State: AOJu0YzFrIr/WeuSfn7qix82DFH6XC56dIpO6xNo+lho/wTcXTExBggO
	c39IREodUl88eas3kdi8PZLtZ94S52FYCh1yiMA05+GFIasLVHrjwX7l
X-Gm-Gg: AR+sD102A4rwubZVNBkHvkbM6eUxqkdipAHQDvt0RR4pT7+QQvVB1YPh2CfqzAb3TAC
	cTvg5I6mT0wLXdpO6DeEnoNrD6SNm8vmCS5GUZkSzLBvcwkZhEDvmah+aID/sNeClD47JHQ4ddi
	xOKBSmLjbWGPllJnnBkOcCb849tYIKQ+w3vGAGmNiynTwXrbqx4jwfu0rFnS/M5QgvEalILPb70
	iJlnpCUioiIm73JoPjDfgIugkL8yJ2qwrczi9lpA5tdfJYnmCZz9LfVqQizK/UTGiZcLLoUZl1N
	bajHn9NFdoZCJwWi8b6FpMtXTge1znkk5xEk3O5xPCcNKaQ2I0ZwD6P/CQj9Q+Cs6OjKM4eXUO/
	jnRgxQg7cxNtZLuKMpK8V0Q7lzT/gEThmXPqvRBoe0GxQwow7YH8xtPT66ruShQj80P5RTr0fuq
	bDEwgr5m4joknekSJktPDF7/Kivyc1xsAa21OfXUtakm/GR19l6Gbum0zxFWUr/9zXP2sEppEbC
	mRo25iBDUX5bgcHD0IQQPO0n+RyOID3J8g/1s/vemMIf5jolNrGnyLLr/RDxik5vfOf5x/BuZlX
	m+PF89WbIllESi8kEBaC
X-Received: by 2002:a05:600c:6612:b0:495:4811:7998 with SMTP id 5b1f17b1804b1-4995e0ebf84mr186829685e9.17.1786219474873;
        Sat, 08 Aug 2026 13:04:34 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-004-134.77.7.pool.telefonica.de. [77.7.4.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995919df87sm196278975e9.6.2026.08.08.13.04.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Aug 2026 13:04:34 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC
Date: Sat,  8 Aug 2026 22:03:12 +0200
Message-Id: <20260808200312.6326-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8221C18000D
X-Stat-Signature: 1aygnwzxwjphoyj96spuhw9msasnuq5k
X-HE-Tag: 1786219476-99639
X-HE-Meta: U2FsdGVkX1/fTgRD9o9kjZclg+ynXHGmn/FgCX+7VuN9ESxg9AXE7MAhw00U+Z1C8vtgu4zS4L9mDrSqJk10N3DYvma7RNwyX6dMIFU8Oo9IdX3B8Rzj3brFGvDIAEn4MdMocA0R5AXEkyNGPEKSg6Mcs6zcFdBENzWhNeXENL5Qeu+a7nvfJhxNx36vLJ+xFEcSdyxhQP7pXmsdgKP4/uTkBHuZqU/4Z8y2+HI/rSq1B8L+/7D/yWJp8t8SRkKL3EcHMm3PJETO5NWA2l7CFw1u5EJADDnHDvDFKrebNujNTrlahH0FjypX8jgt6hcX63WVVybU7qZwrMJuFA7dLKb6g1GCi724nOKtHI6+0mPLUYvy4cy79zaK/1AIgURHOcCMWD/y74JdsAk24t5hd5MM0CQL9dH9tn19sAOyM6XXiFz1aJhfkP26Tw+zdOq8Cc154+szlBUIzkuN7ABtcL2E8o5HJlIEJboj1sxLmURyTEXPDxvRbJR3Adh1qb0tw8jy7urCqZZh396B2xo7CvEytYjoCFpov188PBfSPxL9z3P/meXbQ4IP9aDyAitFYtd+Z0fzg7YqHj9uQhMlHwqJ2lP8K8KO3GH0dKnX7YUIg2C+wJAWpTMtfTeH8juRZCMo3P0plXaco4RkjiZ1F298ezzDatZkxF52PzgyNm7VyI0vWsY9xSGA20ToDjeWgdYsXzykLgjEQjHgGalab9axoOFQZMTr6oC3a3PohExb8VG2+weLj0Q2+K9kGGUkf6rZ9+UUJt8nez8bWTVSD+pb+Hg9n5fQoD9JSjOPfpq7IBoydmKGXcpMXoHiD6ung9O03QrBT/kc2eev8Fk5HkzCsGQ/6lvok6I+Vd0zaAC2w6dgU2r3g50LufaT2f5bR3PUxAIo5VC56SiDJSW5uhmbDsxJ9iTrnbCZ61Xp00fqwl5aihmzggo2qi1CHrj2jo/WR0HBxkxqbdVQrRF
 PUZ+g1SS
 KzzuziaFlntoHdnUGs8KB+SDKxjHz9+ZHDMT/94jAwfPlqZdanmHztJtKGje/dSJgD43C82V9JH2H8qPGymxyfZiLISw4Y4Pdv20Q/WQ3B6/ZdP4Zv9pol1TT4YyjVpxI8+vsiWtCENJ9u88CMyN34ZZMBtQ8meVKSCJEe0+0zlbK76K/JZy0hAHPWATcAyQ/aIXwQCijajiY2uc+4fRXHCLLVBJhCVJTRBQVyLxgj6H6g14Kp4o5vfmLCSLVNf0d232814HPocf7AdKQWDoRGKyBlKRvCT0FofEfY55f+a5dcLaBuuv8s3kq9w+UGms2hlQ4uUyP5lki/dUC1BLaLCmyiWkbRlgOqdtkkAG+4JTm/bSjhjIbISx3EQe7UQoaViBUpXBzTR0SHAaWPsNzqxPnjb1Kc9q/KAl2PU13hb7KjxGapJ8ekdABPHW2SD+oL3bEjueQ9VOCb0y53UzTx2XcigjWXJCushtHj997AeuaM0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_maps_tearing_from_split times out when READ_IMPLIES_EXEC is set.
This happens by default on pre-ARMv6 CPUs, which lack no-execute support.

split_vma() re-maps the first page with mod_info->prot | PROT_EXEC to
make it differ from its neighbours.  With READ_IMPLIES_EXEC the original
mapping is already executable, so no split occurs and the test hangs
waiting for the modifier child.

Use PROT_NONE for the split mapping, which always differs from its
readable neighbours.

Fixes: beb69e817246 ("selftests/proc: add /proc/pid/maps tearing from vma split test")
Assisted-by: Codex:gpt-5.6-terra
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Tested on:
- QEMU versatilepb/ARM926EJ-S: maps and smaps fail before, pass after
- QEMU realview-eb-mpcore/ARM11MPCore: maps and smaps pass before and after

Changes since v1:
- v1 went out without any recipients in To: and received no reply in 19 days.
- No functional change. reworked the commit message.

v1: https://lore.kernel.org/all/20260720061835.6290-1-kmehltretter@gmail.com/

 tools/testing/selftests/proc/proc-maps-race.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index 1026d8c400e1..415eccb70468 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -490,7 +490,8 @@ static bool query_addr_at(int maps_fd, void *addr,
 
 static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
 {
-	return mmap(self->mod_info->addr, self->page_size, self->mod_info->prot | PROT_EXEC,
+	/* PROT_NONE differs from both readable neighbors. */
+	return mmap(self->mod_info->addr, self->page_size, PROT_NONE,
 		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0) != MAP_FAILED;
 }
 
-- 
2.53.0

