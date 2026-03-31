Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E52CAFF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1806B0099; Tue, 31 Mar 2026 05:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8C36B009E; Tue, 31 Mar 2026 05:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF3A6B009F; Tue, 31 Mar 2026 05:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB4D6B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:44:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E476C1A0980
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:44:28 +0000 (UTC)
X-FDA: 84605873016.01.807FD85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 122DC100002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:44:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=faIpoM07;
	spf=pass (imf05.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62QxktDCjvLNB+7zU7T9t0KDFlRYYB3ZQ/FbFPCsVjA=;
	b=mL3ab2RzQkV/V638HSMsC5pURCG/FXxaJ3et5DCegvS0kJ9C3F+xHWSl/MN7goQbHoRXzn
	KpZLLxzU0BiVEZljVuUPjF4Wy39zF/gebuRBuuM49pz0dTNvZ2V/3EvRffDLs0Mn+LTpZ1
	AFvvyLNUwW8DrmolEDWn6eDKBQoTOpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950267; a=rsa-sha256;
	cv=none;
	b=4ixz9kzryUfyPgfy2qNbwZqHDkCZIYYen3r3hKZzosnqAbUT7oTGd/T+mtJwiXsr8R7JOb
	/xdT8K+ubF/d9RjfS6Xtly2Xp4S/xQ2iLxGvZO2UDZLvqj6YH0vvxGMLHYkE2W/Gjhy39N
	hVRKLHNwDw3+h/1HLVXHLIwJX0hONxU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=faIpoM07;
	spf=pass (imf05.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774950266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=62QxktDCjvLNB+7zU7T9t0KDFlRYYB3ZQ/FbFPCsVjA=;
	b=faIpoM07r1eOAkqK3c+KD+dHLQ8O+llH2u54V5sDcCLaHayJv8FzCwAhI2Ez+2c/+Mpuat
	ak6Tq9Y4YKYH0vg11beQGrT2ybUqEUABdib7atOH1/wNfsqYIFHEqg+m5yeT9fyzmqwQ7j
	bM1FxeKFfjmrtWw6PPz8ISM/oTs7hvQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-FnlVuaCkOiKoGKM9c8FI2w-1; Tue,
 31 Mar 2026 05:44:22 -0400
X-MC-Unique: FnlVuaCkOiKoGKM9c8FI2w-1
X-Mimecast-MFC-AGG-ID: FnlVuaCkOiKoGKM9c8FI2w_1774950260
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E013B1800345;
	Tue, 31 Mar 2026 09:44:19 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.121])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B27B630001A1;
	Tue, 31 Mar 2026 09:44:13 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: nathan@kernel.org,
	nsc@kernel.org,
	akpm@linux-foundation.org,
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
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: [PATCH v2 1/2] selftests/mm: respect build verbosity settings for 32/64-bit targets
Date: Tue, 31 Mar 2026 17:44:01 +0800
Message-ID: <20260331094402.144131-2-liwang@redhat.com>
In-Reply-To: <20260331094402.144131-1-liwang@redhat.com>
References: <20260331094402.144131-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: V8pDFSwFukiFexkd9AOuEkGoX8PNYY0s5F5P2T-M9C8_1774950260
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 122DC100002
X-Stat-Signature: irchb5xf17p3zcp7rqr6wjps5xrup13a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774950266-350885
X-HE-Meta: U2FsdGVkX19uRbE34oZf/8vTPo+yNpGFau23VcEmrCJjzzagTv8xTLttjUZFVRO+0IvRxIAd+dDR2UwL6+f88RJLP/MK9TUK7UggJLDvl7Pz87BfxjTCkGzUG/MvgNBUfwDd06jixncbViownjzcX7K0QdCUR/Le6WIc526n519k+/bezken5wQXpE8cTlM3Ig4+HRtLwvS4UGJ7fWb7YMbpgySDlSgr2/zP1B0QrZqLZF9m+J+Shg3W8+jrMCShzKUldOrkTE7XWuaIX89axYDNt52LCCa3Y+djT3gFSzU0QfjF9d2Iol/bdg6G4KXRlW00qAaUTDbOzpkblTCAGuiadY0cpySfqO+IFSIJwVbMbQ3tz4xpXnB4aNyTjQyM9Vdo9RyWGfY8UvGPhRfBYw37kLv9W9b+JTWiAHLQKUaUyBU5TKPh6c7uTmGtOBoHpKpVPnMUu1UTg+mhf+XjaK6jUhVqVPM/rtxtj3BKTL8V9XPtul3BTfTfytc1sBk4ytBhBeXlVhHyQ1irN4nnmp38+SRhjUx6ffuSdOLG+dGY8Mrm9QPYD9pbusm2qfJwt2A/yl7yIrvcIazIKTzCzjCDvpDydHs1GN2tyNd4ho/XLWKIs/MtD4AdPevnIpdIojGosSoVazF725ZFarVJxjICj6MHHddHxKmW54ANl2cP4jRbh8pqW4ElZDKGUUMGslDNqw9GSDkBsz3rh7AlfHfVfBft3Raer4kGlWpI5Eofo/Zp2BtgNdObTyJeoejAPVl63MbXeGwif8cdyFiJca0hgbhcCe6F1QF2k1ZFN4uovqgl1gyUxFeUWrxa2HHLnmL4no2PPMSUXW16diRGshccOtLZrd7G3REnqrsykZG9xZmWhMkHDsnOoFzzsEfG4yHGyPBrdD5GWN2kexNqGc/3tbRIg9PEYRTf7dCVkcjIy8WxwqqCeB/snuanmkLqo9j+zhkJbUpAdZW3qfp
 3qnY1VgU
 myYIX1J8c5xXeqOsAKV5cD46EtvELT2+AP7Ks9XHQOSHEsm20qusrBJuPYi7KVSg6d5J70mQ7awbKdX9ggBtE77I225JiJz/IrMQem0haOTTYoLu833n7rEtRLLpmb0yh8rwWARMbbPw7/Yu/4ppsziNNeYTEReHhrAPgW06nqmQQbyuXET2bHfX+He4JyM1vad8NMXNn3dDKLuemGkjM0B28Pn6IhhXRiYuhXf3zNzbuJ58IDQ2cb9ku/iw2HpZuHRd9AIZ1tbn2lOrSYQ5omqzXefqIzTwJQWm0jC/4wHzMur2tpj1e3Kq8iOwRKScbdogTw1FgcMPY9imUZTxxWT9p6BYVMferwaUchgIVVB0yndsKz5FSIHHmwJ8RquKOk6wKwusvsSZOIBAXpKH8BJaRaA==
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
Signed-off-by: Li Wang <liwang@redhat.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
 tools/testing/selftests/mm/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7a5de4e9bf52..3b222cd6a048 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -215,7 +215,8 @@ ifeq ($(CAN_BUILD_I386),1)
 $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
-	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
@@ -223,7 +224,8 @@ ifeq ($(CAN_BUILD_X86_64),1)
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


