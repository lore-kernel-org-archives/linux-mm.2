Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B8DF94CDF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89E56B008A; Wed, 22 Apr 2026 04:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60F36B008C; Wed, 22 Apr 2026 04:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76B26B0092; Wed, 22 Apr 2026 04:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C8D546B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:05:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EB68E6468
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:05:05 +0000 (UTC)
X-FDA: 84685456170.20.042C560
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id AF96D40005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:05:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WxQrHWxH;
	spf=pass (imf07.hostedemail.com: domain of wangli.ahau@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=wangli.ahau@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7P3WPkfA1Saa+jmrVSo3FMd6D9WCAJMGXoYkKyQ3YxY=;
	b=IwnoOlcMEhkCh1rj8ikJOXF6mcVTKCe7PK1ho10sZe6btqsPUTeg4grZ7hh8w0RcLhzOJN
	tMJEnT3yRIJOXzDKFrixx2wxgoiUcClGJVGCRh8e2sv7g8x4zzIJMRBsmvzwf1XhjfWg80
	A01MxH5otUyKKq419+KfVn4M4S3BFDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845103; a=rsa-sha256;
	cv=none;
	b=M+m7owr2MjgREwO/fNJ/gmZN6NTnzFG2H12uffEvm3SIrtzGKA03fTRtW2pEEUn5Li/Xsz
	+Ew/e8/Gv0fldLHF+Vdm+W8Ei0SIMJ06BAyX8erhsHEXwzZhgYeDzy2nS3cndelAisJSGX
	qQ/Rb8Un4tPJJw85J63Oypl+F2aPixg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WxQrHWxH;
	spf=pass (imf07.hostedemail.com: domain of wangli.ahau@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=wangli.ahau@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35d971fb6f1so4033282a91.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776845102; x=1777449902; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7P3WPkfA1Saa+jmrVSo3FMd6D9WCAJMGXoYkKyQ3YxY=;
        b=WxQrHWxHrvf3qCmNTVYJhU+z2Wbi1MbNhBSuL/v/ctFNYglfvNzJOZUJ7F9Xi/Ol7/
         LLFIV01k7PX0MJKG3/3Q6Aki5VCFQbF+iPrZFOTGjvMjqAoR5SpvOlZCCnwIuS+Pgbf8
         MwAsjnsU9UIgTrKfYp39LiT2nVLgHvSwn3bV8lzY4wQpEH1gcEoMsWlHbB3Olw4FN3RV
         rCtFNfYlVR3rvf30PshDs+44xHVM15R7qPwy0GsMIj9pqH2nbcGpRGeU7RKbx+T+ICVk
         8joVvJLPgW57SrrFD9jCW27YSbsUW7TwhuYg8AEKtJhXE2SvP8xgYy8daq6fmd3k9WEm
         xDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845102; x=1777449902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7P3WPkfA1Saa+jmrVSo3FMd6D9WCAJMGXoYkKyQ3YxY=;
        b=QxDs60BVP/1ahbVBqDB3u0FyeqJ8nGBVHqQC9cuLqDZZEKLtJIIWoglZTwr5jIVHeH
         fQEziiGqYc3p/+/6XKy4HfoddFBHXbglJsYrVoPCOkgT1SRDI3WZv5CBVaOXZhOA6zyb
         YZVYvfRgz3IIcqBu1j1Xnvy2y5zWiDZSetqQp7jaDV+v/WVeY4dv9FXSqkrqi/KutDn0
         FbvXPmnj1W0q0snY5Am8/fOmX3rpuLaK9ojj0/PojZSu+xt2vYWhNF0pbiQOeFUGm9YE
         2nuNvytSubbByY+YPj6Tuq6ASs/bx8hIrB72Ca33IsMZlBCoLvm52Ho1uG8KtqOvL44s
         zzKQ==
X-Gm-Message-State: AOJu0YzaRdnXrzO8hQSVljkJ/mXH+2onBuCUPCsGCxmrq+8CFK929H1o
	InhOI+VyGw1UE9s3rd78iai6NqD1pjnfck/R0zMmQYy6O0K/zgCxiPE=
X-Gm-Gg: AeBDietRfnDpQvnr/36lm1raXc41bMfGG8Mujf2zQjDmyOWL2ihgsdkkZZLRWIklNdV
	ER7HD8bKk99jqKLsYxUeto2fyUc4mS24WCtqWcEzEV0fVJYisdoqPOt15VxjykBA7oz7+sGu/i1
	4IR1+mIxOheb2w16hQPQHLZTiq8KcKDyU3642MQOrrwWSSAUTO1YU2RGubyx3k3gvnSlkB1yd00
	7bn4kduuV4DLYpNZffskHd5Vyv4pL5IvqvDXReZIM9JW19gCfQ+qs0rIvcQK4ZEGOrLISFs273s
	YDE+lWJSiTOHwA7RlcDFZMzKyehip4frwBdwbr76mImJbjfd0suKDf/IA7zrrd+srZIB9ati3u8
	XXILZkGY5lkxggNzy1Sl9HSPsfsvurn5K5FGreQVHMNnjrChhl/Ks7maPNYB/JBlMy1wG/dnXA8
	SEmxKTIToxKbmzX1MWw6SYfptz6adv+Jl4
X-Received: by 2002:a17:90b:4b44:b0:361:3224:2f65 with SMTP id 98e67ed59e1d1-361403bdd07mr21489530a91.3.1776845102478;
        Wed, 22 Apr 2026 01:05:02 -0700 (PDT)
Received: from thoundrobot ([43.154.64.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fb9b121sm8508494a91.5.2026.04.22.01.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:05:02 -0700 (PDT)
From: Li Wang <wangli.ahau@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] selftests/mm: respect build verbosity settings for 32/64-bit targets
Date: Wed, 22 Apr 2026 16:04:45 +0800
Message-ID: <20260422080446.26020-2-wangli.ahau@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260422080446.26020-1-wangli.ahau@gmail.com>
References: <20260422080446.26020-1-wangli.ahau@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF96D40005
X-Rspamd-Server: rspam07
X-Stat-Signature: ax41snzohgcehg1ika84r615g3ewz9yx
X-Rspam-User: 
X-HE-Tag: 1776845103-357201
X-HE-Meta: U2FsdGVkX1/8Xe/LxEHROBiagTxH6ckXV58L2wDxUmYwtP3iFsYG3F/kBCFEqMX8HpxXihK9KXFg+yGnIxzie1cE79xYIhlOMMTl+utYrbKYy9/LmIEd4BPAhnhW5vee4BQ5JWHlRKMtUyQeod23RQ4hD2idU0e+c/vEdIezCedZ4JtTGB5qCNVzcb9xNwuqzoKhzn1ybwtsNiHXJxdbFVgvOWcs+eO5Z5i6NWFNv88RPwk8ehT7yssF1LIMbB2X7yTBVkd6y3/sYruQ2S25Y9Aaip4f6kn3r/nA4yenyS3A/Y9+8XY0ucakB1kJxn0+VKHn5tADaNiThBS+DGcEjF4PugvbyAnCzYkkGy3NZ4liBi5FwIpCi67gn9/+gBIY/uTlxOcVduQwpltirvvHBkYNc2tZAa+NmBRnrAok4/Q5mdiEUCJCOcFijy0Dd+j3nDGMn1Wg619VndO72sEL0JJWTu6MRGVccUjMSKfWCBHatTIgeVGJgyPI5Qox1zkNi0Vba3PU+N9zz58vKmYKYWZBov7ZHdWEahUsPpVOZ5OAIbDqLtoJ0TD3prFMlLiRfFiw47qziMhkPSkDxk1UodfHLb9uJ0mqoxaoo2G0XNzzkJQUU513ydg8JNsUJtjvyJyC+oXoFQMqNgfs0+AVpuKQiEuwkoK0855dMR0Yl1rbYR40c1DXozri3F+cwMMoxERvbVL7IwEkWxf61mVVwTRSk+Bx6hoUzaUPVCrV3tgS2scrZalCExzGSB5oijdLb/IUGQaOCmKIEw3KsOTFfXLJnjR3xhX4NYaDVKznF4efTIiUsKVigpZYDRk/v/rg7JxPdCJhJvSnE2E+myxnYV2c2Cgm/Z1teqXT02xX49e3XL5wd3A/7oPYei6mQYgavQhbxlckms8rQP4KLyA3Xn8E9fVMqF4lAh2GbXBFLYbr5kRelymtZqFZB72A+1xHBo3/qHic+8QbHluNAfo
 l6jXoXT7
 PWOGmPov4EL/h17LPAjTXzQfKfMuoJx6+wNXo3KjyR/UdVgw9yPIviAI6ANipoXhvLo28g50xW/SQPin20j7VBVoZDSkBZ+fLo2FKQgWaZQtjeebtlITAry3PIMDezTofzjxLAnWHv9Jy41CLpyrDoNPPHfA7g63UKNbcnqEmnQ1nSa0OJ4YgqJkIi5rwxjjiAvhaff04nrTy2hayknnSwWSnCbo4J6jLo0Sv2C6gYlPGDmIkJaN3LhtUNT/p2xwJ//bdQAzjcafyXLTngBPprM2UGJ8VAdh92N8xKJEM60MDgs9RVnQdd3KuQcu/3bsD7ZRcarDC5BqYQgyNWHU6aO5dk2o95nVbkZZB03Xu8J8xu3f/Qdb5twEgJJu/aTmxQRDSofNCg/HKrneep12tl/pMduP2SWQyvOmW7oVl+A+56V7r7KFKZnc2g4he0+QDEkBJgQwx4eHJmvNnQoQ068+5hgfiz4eTRlXL42slPaAgiWX7RZdEqHIn7UBodK2aq3vC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 32-bit and 64-bit compilation rules invoke $(CC) directly, bypassing
the $(Q) quiet prefix and $(call msg,...) helper used by the rest of the
selftests build system. This causes these rules to always print the full
compiler command line, even when V=0 (the default).

Wrap the commands with $(Q) and $(call msg,CC,,$@) to match the
convention used by lib.mk, so that quiet and verbose builds behave
consistently across all targets.

==== Build logs ====
  ...
  CC       merge
  CC       rmap
  CC       soft-dirty
  gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
                -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
                -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
                -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
                -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
                -m32 -mxsave  protection_keys.c vm_util.c thp_settings.c pkey_util.c
                -lrt -lpthread -lm -lrt -ldl -lm
                -o /usr/src/25/tools/testing/selftests/mm/protection_keys_32
  gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
                -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
                -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
                -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
                -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
                -m32 -mxsave  pkey_sighandler_tests.c vm_util.c thp_settings.c pkey_util.c
                -lrt -lpthread -lm -lrt -ldl -lm
                -o /usr/src/25/tools/testing/selftests/mm/pkey_sighandler_tests_32
  ...

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Li Wang <wangli.ahau@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
 tools/testing/selftests/mm/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd2..6195770eba6 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -216,7 +216,8 @@ ifeq ($(CAN_BUILD_I386),1)
 $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
-	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
@@ -224,7 +225,8 @@ ifeq ($(CAN_BUILD_X86_64),1)
 $(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
-	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
 
-- 
2.53.0


