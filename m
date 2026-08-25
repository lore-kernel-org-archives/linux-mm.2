Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18F5C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF986B0088; Tue, 25 Aug 2026 12:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C805D6B008A; Tue, 25 Aug 2026 12:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47E46B008C; Tue, 25 Aug 2026 12:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DBA06B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:17:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA1F0A00EC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:17:42 +0000 (UTC)
X-FDA: 85140297564.08.5912988
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 29DCD140003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:17:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F5qFrBDx;
	spf=pass (imf09.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787674661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pnKpvcq+eFIIrOJcljhlMUuTfIvczUf3J7EXGDw1e2A=;
	b=wKjFPS7beccsFRJ8C9H6u2C4tdwAra13O9tppyYH0WFniLqOtczcH3c6Nx6uEANOXO+NCe
	bK37hcm0u+h271moTAzXCJ8bQxUfsShI/CHcfqlyX/xzoFHqQMXxjGry6l1hdzD3K6MvGh
	oOhnP1AxHAYxaxlEhB4zc8gfbjWauvo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787674661;
	b=ZZQ90FNQqOYKv9gYWBdeHXQZx6YLK5x3OcsVxfts+el5VFNnQcI3aXw6pcVJddOSGuUqTC
	oij38RO06WWRvcDrOlsGi+4516Gk0Freor+w1SI6O/3RsxPpJxRM+soqNr+QJMHSVsp8KZ
	niAElmv/km6OD+lap3Dz3YQudGlmoCU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F5qFrBDx;
	spf=pass (imf09.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d530328efbso610745ad.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787674660; x=1788279460; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pnKpvcq+eFIIrOJcljhlMUuTfIvczUf3J7EXGDw1e2A=;
        b=F5qFrBDxVEFX04yRufVajX2LiAE9q25bE3EYgP5w/Vi2KbktggZ3enKK0FfO5AhV+e
         P0dVtdUzBITK7RkRXV1pK+FxaSbB9exFTcXhG+RMJPtvBCmJrY5g+IP0aaLqyK1rkri2
         fdT+DTPCr7GfvP6UT0HiV+cRE/UdnQcfna/5tmbBQDDTtWMO+d+Go2keltNmbFttM2DQ
         TP9FxWfzxJhwjcxtU/hGiRdxljmRkK+3nQNeGXxiVP1S3Ty055bNRkHCFtCsovwVKN/c
         6m3uWZFypZUYSG3sFzQ3ni1rFLF72DBHNpzZL+bRzylPI7+qNIsF+l7XsYmk6SLrN1rJ
         aAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787674660; x=1788279460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pnKpvcq+eFIIrOJcljhlMUuTfIvczUf3J7EXGDw1e2A=;
        b=UIaEeNMoD02/HA97bKRJc1ctc407YRtBqcAIljG+NH8VZGvDJk6QsfvceGKPkQ9lxE
         Rda2HK2XpRS/t4O8HjMB9LFw0WEFiIAcvzIhkdO+w6UcnuME+RwAjgRgw4VbaicyKm6W
         3DGcEj9XHLl1fO6tXxnD3oBDpse0v0GL2JVc+Wohnb3BJTXv0DINktjrmuLHVmdO7Hl4
         WdOwlD99wNtKcY2yDkXey5nnlmjmr86ZCyUwWOh6Ou4gKq231Xlh1PJllrTd4PG8GjTp
         K3Qi3yoluForyJAwT1LdgcvpllRX2S7yNZ2440xhzmmZmDedDcKOS7kCjJJLd5D7h4wu
         t3Dg==
X-Forwarded-Encrypted: i=1; AHgh+Rqi32QjtsJhBWJgxLgl4LHAaH9ccs3u0FbIarXS6qu1Z0Oe1CxV9hXMcfidU+qsxRDNGkuGGpKD8g==@kvack.org
X-Gm-Message-State: AFuF++kjFD0jWPTVS7queSIj2STm+pDSxYQTXTc2BsSS+e0QlKOC1D/j
	I9LPX2utuHKxbz7S33KaSab4txEChY17stz9Jy/Mi/9Tb2N8uGEeCIpc
X-Gm-Gg: AR+sD13ROPd24dSl0+Hx/TvWZrWUKh1cVD+XRPa+FpLtmcMYmESC6DIEJxUc57LIru1
	Org5mZUOt3oYbCjrVuxWM1noKMv7zBcHtBGIdOF5LHknifGp30lGfu/xdAX0/xI5eBn7pMPLgcp
	QKE7kHPXdjlmiJcc0Ym7fkVDRX2OG4oS4WGQ1jgAIkRixesHPZroMNW0rXzl1fTE7b9Iey9arnT
	eRC7a3nG50s2sZDs1EkBQsUe/snOkZx+Llr+ssAGouZTpT/gBtaCQT+THSBdSj7IKz/S2zICCmP
	+L1gMQbXvvDx4mjBiQ5nIJP/cifGt6XeygB1hgsuMID3rCC8p81MYcpRdAEUgKRloAiQNMDqGRv
	HreMkVyGhgEfC0pfJD5/QLnTTuFksKAMNt3aUNZp8rCec7oKcOfz4DXBIPcs7DgcGRPO9ZRoshi
	YItk7Jk9b7vZZTBoZhzqn5IBGYmgF7Jpp8eA3MW+G910LqBcWISEsdxvSZqVfCTrvdK/ttOPPu0
	D8jhSrZONk=
X-Received: by 2002:a17:90b:5291:b0:38e:e9b:ffa4 with SMTP id 98e67ed59e1d1-3966d45a53dmr525079a91.6.1787674659810;
        Tue, 25 Aug 2026 09:17:39 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3282afb407bsm8786745eec.30.2026.08.25.09.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 09:17:39 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org
Cc: ljs@kernel.org,
	yury.khrustalev@arm.com,
	kevin.brodsky@arm.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Date: Tue, 25 Aug 2026 21:47:15 +0530
Message-ID: <20260825161715.2807297-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 29DCD140003
X-Stat-Signature: 98td3o8ai6d38s5r9mog8xkdk8mj81qw
X-HE-Tag: 1787674660-919594
X-HE-Meta: U2FsdGVkX18mPzMsgG3kPaUN9psCqAFYtU60A85qhVDm5gkLJ8TJXBlvr+gfLRiLBGdaDmdVbTYUn3VtD3Pvs+hjjPZHW12Fq/GT+YW22fXCCkXYHjgvCpHD+sS0CWuO6Avn7PLzy5LHtLpENMqDPXh1w/77WbaGyLi7jGVACeqOWl4ESc5DgaOirY5/c5zEgIjXUwe9f0oesoUcy6ZPYkI3bn/tSCrEeY4J7+Mr9+zz5GJ2UY2FfZureWXwHg2M5D8p2K5erOxThfUVTvjvpjOHUYO2yEAjx5AN4vtliOz4HpqT3LT/Q1ruEfU4L43q4HrFYYkslrpzvGVq7R1Ni5B1SfOOa3LWd6aHjkwIeJnCjQp7MhPG9lfHCuvcgzagtUj2J0Jw6KIpZN9DZGpUpgA5rdqmRkCl+gUwjfNAuCXsNRVWQCh+9mzhJdPDOFQS8tm2SaIBAZJ94w4k+fZKNnIjAuhakOtefMPNkEwkVRjol2jhNqdY2ZhbZI6c6iUhVw0MllmQ/T8/iR+UpWrIZUAsSQ6Bz+hvFqv1/JZ0yL7Kw5KhRoG5iHhCeqe3Wpt/6Tx8sDO5sFD33M99j0D9MyeayxOc3NyqZ/YlSlNfdYya6DnlKgyjsD5D31wMU0BO2ZgLRCNENWrD31VQNFy4WMqTPFbploJ0fHmB9m3AjJivQqVBygAi3PQ7rptTuqKnR2yj0tIuXaiEDLCGL+dzp1X5MFKZ4XcCilfyR5Y8DamJgFFJ1j4JD+GCGRFF7Bb3Hd8Gy0Ehg1nKn0a3pCUs4LuQua7Fzu58hD1UQDSmpVbEUNir98/mSTs/WaNC0KESmuWo4fh8lRhjzcWtxVZZmPQA1Tl7BRQKgg+AXHuPXYrUd2OsJMzhEK5Ioox+3NOFKi7cjfG8RZAH90gN52xNGwK8bKTOb+AezbqGCiqs1huq+d/jEAvFy0hDUBZx8sSeMrQTVBWTeiSDq/DEtyO
 2eNuPG2t
 A0Bh7Gqp4AQlQgput2xK1ok8+n0YAqGadsRS3PxkRTiGzR29V+7l9fLhlk/tCF/bbazAtpUgQw8qn+gmsCdVTAneaaOrDVBG4LLpwtFdEowR14qBVrwMZLvmpUmP55AzQ4yXEpYMS46eXB713YYpZIDbLVQB49X5xfTBqvhLzbyhxwMsfLMo1TIEqFftZmJXPXZlFNqD0/UbSVW/rGvUYAqXkS4x56lFrewuBuAidMNIvcqBOyTPEwiHSXH85j4fCZuXR+STc2C5w/uEeJIq1kSPxanVZAFiP2tebTNZ22BJ5JVpoDDpTPlP/EXgoVKmDdoSZeayMQp17UzjCbEqMzajOBKF9jlQ3+PyrMT7YOOKFVt8uImWcu/tnElgjh+fptCmTYP8rkRvHMqqt5/L8stLAigx3NeCpQzBv4u7m2adijyOYNzoeP1TJQ3vjMLfVVRUTPrhuRAryoO2xro4LQR4It1si5VsHM6J5jOTNeMOevsWEro5K5yzMpkcTL7SPB8OaTiTfEve0sJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
already known, a stopgap from when the generic definition was still
under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
Add PKEY_UNRESTRICTED macro"), so the guard is never taken and the FIXME
can be honoured.

The definition comes from tools/include/uapi/asm-generic/mman-common.h
via TOOLS_INCLUDES, which commit e076eaca5906 ("selftests: break the
dependency upon local header files") added so that the mm selftests
build without "make headers".  It is reached through the
<asm-generic/mman.h> that the system <asm/mman.h> includes.  Building
the pkey tests with KHDR_INCLUDES pointing at an empty directory
confirms that; emptying TOOLS_INCLUDES as well is what makes the macro
go missing.

No functional change intended.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Changes in v3:
 - Add the Assisted-by tag Lorenzo asked for; an AI assistant was used
   while tracing the include path and preparing the patch.  The builds
   and the cpp output quoted below were run and checked by me.
 - Pick up the acks from David and Lorenzo.
 - Sent as a new mail rather than in reply to v2, as both asked.

Changes in v2:
 - Drop the incorrect claim that the mm selftests are built against the
   headers of the kernel source and would fail without "make headers".
   They are not, as Lorenzo pointed out; describe where the definition
   really comes from instead.
 - Leave tools/testing/selftests/powerpc/include/pkeys.h alone, as
   discussed with David on v1.  Unlike the mm one it is an unconditional
   #undef/#define next to other powerpc specific overrides, and that
   header only includes <sys/mman.h>, which does not provide
   PKEY_UNRESTRICTED with or without TOOLS_INCLUDES, so its definition
   is load bearing.

The full include path, for reference:

  pkey-helpers.h
    -> <linux/mman.h>           tools/include/uapi/linux/mman.h
      -> <asm/mman.h>           /usr/include/asm/mman.h
                                (tools/include/uapi/asm/mman.h does not exist)
        -> <asm-generic/mman.h> tools/include/uapi/asm-generic/mman.h
                                (-isystem puts it ahead of the system one)
          -> <asm-generic/mman-common-tools.h>
            -> <asm-generic/mman-common.h>      PKEY_UNRESTRICTED

 tools/testing/selftests/mm/pkey-helpers.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index 2c377f4e9df1..626c2e1655dc 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
 #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
 #endif
 
-/*
- * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
- */
-#ifndef PKEY_UNRESTRICTED
-#define PKEY_UNRESTRICTED 0x0
-#endif
-
 #ifndef set_pkey_bits
 static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
 {
-- 
2.43.7


