Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFCBFF60C1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD4A6B008C; Tue, 31 Mar 2026 00:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957346B0095; Tue, 31 Mar 2026 00:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81EFD6B0096; Tue, 31 Mar 2026 00:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7436B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:02:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0269EE1167
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:02:15 +0000 (UTC)
X-FDA: 84605010672.04.8467C52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 23ADF1C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:02:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZRmJplnt;
	spf=pass (imf21.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774929734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3EbDAZyAv6jeWZmKthzK/4CcHQ9kPum7Wu48BPoSuVk=;
	b=qu5wWiNnO+e4eF6kC6eT8Qkp+aYrSTwtHHhPCP+FB+DEEC3dGnhl2E6z09ftNYw17x6s97
	XPsT2+ay+6vCRyHvnfJSl9MGyzjutSWgPO885r5iyRrzqWtcc+mS9QAK+/rfOXr8cjc0zq
	RbWjjagVS05cIdFlLGDlWFmgfLDYQC8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZRmJplnt;
	spf=pass (imf21.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774929734; a=rsa-sha256;
	cv=none;
	b=pCmc7Dituxm0gW5ODMr2D6p/lNaE6OC0z85RF6flpIcM7Xo2AEXGVDc956nPuLX64txwNd
	UEia1I+m4Zbxfv7GbgBJ0OWzTtGSrVd4bGW1zMGDBHLsAQioE71xgovT5dMcYdugy+g2VR
	69FChNeDAQO0N8s3l2pbMhHfvFR+fMI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774929733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3EbDAZyAv6jeWZmKthzK/4CcHQ9kPum7Wu48BPoSuVk=;
	b=ZRmJplntLPC8cqNqKsUyXgAOoWdoYHOlkZBIi/QWu3TgYAMQY7D9KUFJXXGwtaZnQEELM0
	PzGA0DUq2NwGdpH7/Jl9NJSTRsKWPOIJBWlCC3iBNop+3B+iaBnQdPy8adDKFaDfXvfO51
	TxQWo72ZJc4ia1eRjy4PpdWP9px7qL0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-hqGagfUEPRab7xyPRGlypA-1; Tue,
 31 Mar 2026 00:02:08 -0400
X-MC-Unique: hqGagfUEPRab7xyPRGlypA-1
X-Mimecast-MFC-AGG-ID: hqGagfUEPRab7xyPRGlypA_1774929727
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5A851800561;
	Tue, 31 Mar 2026 04:02:06 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.121])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF0D830002C3;
	Tue, 31 Mar 2026 04:02:00 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
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
Subject: [PATCH 1/4] selftests/mm: respect build verbosity settings for 32/64-bit targets
Date: Tue, 31 Mar 2026 12:01:53 +0800
Message-ID: <20260331040156.119158-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: KubUalEm22FWW5TbBQozLrMTqYZNEGMrZbvw0kZhpL4_1774929727
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 23ADF1C0005
X-Stat-Signature: 3c943i13q9f78p3jstocuc7w9q3unfjj
X-Rspamd-Server: rspam06
X-HE-Tag: 1774929733-221240
X-HE-Meta: U2FsdGVkX19QEUUqjhb1OGlulftncquy5I55ZZYhsVhj4Hx4W2JTww9XTfsjfZuIi7ZSVyOnRDeL5+zkUC4a7Zb9jqDTgH1zalhr1e2VzP0xGYo2ZQ5IRHq2qc6ls0CnLr2JMla6EK57kjJgS/y6TK0/Z1uK0G7o2xs5fduSJMSgfef5Om9QVu2w4EtvjeJesjOWhkN3Sqp3xxCr/Sa5DkxVcncCH7G9dnhux6OYUlHQL+HsngfDUn0XzRvY6VB1/QCTIUfsZcyBA0X1nIgCOEjj97eM/JiCaOrI9OGYKe5Hu5h6BEPHN2ZIkqXoQn+wuToSWaj27d0pgnCsuz0T8nW9hPRfYQVWduD8Cwlh/GRd5FUeObnKESplb4xHthP6OuGfFVgU545tlF21IkM7va54kZiWXHPHoEyxNnw7+iHEK1Jj6ABMxgCoQ7AA5IdSm2PMtP++L4Hco2waZtycFwKL1SIEYxI/0UubLWqtFMrWGsc9NUK4HxQdOqN8BXnmqWH+qaupyLUEUxO8hc+kHB+G1zSxUueRFZQOOSA5ml3NR2oXOoWUySe0kbwGsu2rcINuu4ACpGMq31x14oMcg4OG0mFKxOGnS6WbueleCdT9gT+pjop7rV/KTR5y70WOIOc1daj7ZFP9KNpkt3XX5szHPqbdmnlHl9tPyyi7f6799feiaZVRED8Cz5MH4tEzvICO+Q0b3Pmy5gJeIIa1JOsMTp2tGUTWFGUcz/rTGrmaNNX0Gpzytre/XqekKerX1mQm4qMsAlZJegP9aJXpKiogfWPx3WdQLAzrBV1Hv68WsWfUCYCbgANLhEO8Vip95diR0jqVRsIEJQSgmug3NLWwalf96AZBtHhrHTTbuMffBNpF1WnSFlHHm+E7gA/410rU43DFPWPjrMetx4m7dZKa6e1g0jx/Mi98UHAxBm1cSmtZ2V2ihPfmnjDuD78l7Lmvc0bUzDuun1Nbe7T
 IuM5sX19
 ctx9m+yogNE4wmORJS8cb87JjzsxG4xdEsgEOk8KSQ3yOE8fJdaYlpz/Gb7W9f/CR8n0ojKOmRyhlCK0hHBADPUQw4IpstNDdBZX/pXwTIXQwu3r5RfhlJofN4/oCeuTH3pdOwEBknrRRTAbIXDbg0DoFyw/ulW42/pgsqnG1Fygz9WfSlMDEr/ndNMY+ELCN3itxt21WinV36Z8as6O7pgvfdcLb0sXA2lm+tSGROUiF6VUqQp3ucxePpkBe0VxIS45mMpn9BOFAbGsoSQ+IXRd7Y/7Sqv0U7Fxpx3EZP+hLEItAo1kS1N4fICXRZXqr1CU4u3aFgeSxAewxVYovLsw4rSUh+DGhQuIsDDk9eEUFRSbjpe7ZHTYNTox2F613aiJUdyiuzVlksGjNwQGd1uo79A==
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


