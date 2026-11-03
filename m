Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86229606A7B3
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=eI17Fu2M
Received: by kanga.kvack.org (Postfix)
	id 94EA46B05C0; Tue,  3 Nov 2026 10:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926756B05C1; Tue,  3 Nov 2026 10:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D776B05C2; Tue,  3 Nov 2026 10:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 597926B05C0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8E1D1C2CC7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:00 +0000 (UTC)
X-FDA: 85394163120.24.7061638
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id C3EA980003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:17:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=eI17Fu2M;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbduBp3PV2PD6ZtgXv4ZkeG/rcdvbrKsRxBHo1Elyzk=;
	b=xGrX2CEytoACnx30F87JZvxA3Da/EemPMvTsBfXwLPE2aoP2x4YP9ysHKiME/3GdWxiOWL
	bav9l9Gmtp5BTX6N7bYXZ9pV0oImntGvTz5+rKV7fqdrk20WPUA7Ty2i7f7tbmWkIzywid
	Cu57uaekZ37CKjTsfilf7HY0d6vdLYQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=eI17Fu2M;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719078;
	b=mmuJGlBghLGzxFw8Ck64+3y9c2V61u0ePcsqjEJat1uSDv0uFYT/Tx2c78S90pnhZ/RIiJ
	yO1Qlb4jpSVeU3FcgHuqNzV0ZCvpCWikkwGDYTr3C2GreXi6zl4vLbce1XAQLTH9AnBytv
	XzE6dmU78He2WGl1GPqwGnCTL4R5RhE=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso2158203a91.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719078; x=1794323878; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bbduBp3PV2PD6ZtgXv4ZkeG/rcdvbrKsRxBHo1Elyzk=;
        b=eI17Fu2MEDo5Gmzr2nbwFbEm3uX9pTS0eYsaMaSDax7iIIzW9Q1ycOhSmTrB4fXAGw
         FM2tRzHcfy+HXlyhiBGxmAk7PAzptid3VZdQ9U4B/Qm4bj4KPL9Kx5F3OOKUzdCIFMpM
         NWnaVDLcNuWHnsl36TrE28FkDlwoe4eog90j0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719078; x=1794323878;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bbduBp3PV2PD6ZtgXv4ZkeG/rcdvbrKsRxBHo1Elyzk=;
        b=ivMWw6BFHqkegql/KuuTmN8YT1N/4uGBS5gCXwAPzNkEu3T81p9FwO9LifFh1sxN/G
         5tyPDE/A6GkHwFlJgnyIPXltVe0nvHseoqg55A8iaB2zEeLk+zg7i7D2An6JdqS4ERsq
         ZphEAjgu/szhXvxFHsH6UwxnvMXXCG6EJ6Sp+RFnft6chk7vTmRkkFBXGj5XlokcYyO4
         UjcOEAdp80GSkuJXPaKJ1XSLCq5nyf9PpgNofEpgPqjb9sP3Cp2FZfSpywtWBxme+SLM
         NqzHYO97/o3+I5pyB8aUnmVABUqkQJB8bSRaCntAyXqIYUVMRrJ7akFU0l0xFnlTV0S0
         v2yw==
X-Forwarded-Encrypted: i=1; AKwUvBy4nb//Te+eLkhYBAtxNN7ZKvHdGTb/8anOM8+HLgl8J3M9dG09NxmzXeKLXImRDXNhZHdknPMSJQ==@kvack.org
X-Gm-Message-State: APuU4Z+KwwgHBFvcF0do+azePDX2kMUpCIqcZMXjhuR1zP1SOceoq8jC
	1P/Yb/be4d3zODtojepGpab/5KLolPYvBCUl3Wp4U9E21KMP+yT+WKic5fucnLcWdB0=
X-Gm-Gg: AYBFou2oNPGmDTnebkoEQnfd7HQnTbAf7+58ZFQc0o3Tsz4UvWkh1TS1ziAJjidy/wS
	XTw57qm2hFM/u9DV2srm0B2Eoj1zIuZxPEgUk8unZDKcPyuPRXRWvLQda9lo5WsC08nBMHMDExb
	7payPyZ3oMl4fcHy/xtv4Rm1zepdeQ0Gne8Suo/ri6K4FfUyS06eYORsDcYM5c8noa8YHvzwTL4
	VRI13r9wragCvqpyYrG3p3uyBDYhxXuAUZeGx8IwUmz+LE7VE182J/WUZVsGY1JxBkW0ceZKwyI
	7S+OswhEEgfUlYqYsBcKPGH4bHwb4tSMguMHyyPeG6PIR7CzmfUdIwY9OzKKWce2j5XGxiHvsbj
	/9vbQP3SxjJCnDo2iYYkufc5EX0PzpSCLOn/gIQs/siBiiMwWEod8VowA5xRq0ER66n8Y0Gq/9t
	yWRNtPtQN5DMOL/XYzkfEZm7xiUmZIdlpepOkP+CXNcMF/VvWWW2StJqTwD5nAWfUCoCxmBC/22
	B5lPnk9OssYkSQ7JR8Grpv4EI47/6KeOKzsritbN3xq3W9JqmJhBbgAWYgv6I9oxHFAqIfHCoGK
	4hM1wry6pbakUgnlIajxNglEDb3fXmBWA+6fr2mzYAEqRgsB57Wpcr0d7hNRB5WBK6HRgvj9Xdz
	gblqRpS8Bk8U5/a7ZKfbPo9H6YqM6E+KWmYRKAfEsyTZaKbNDXmnS4eK/Jwo5ezUP9BkN1OcL
X-Received: by 2002:a17:90b:4e8f:b0:3ac:4e18:238c with SMTP id 98e67ed59e1d1-3ae89806287mr10222361a91.49.1793719077568;
        Tue, 03 Nov 2026 07:17:57 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f69605sm10791677a91.2.2026.11.03.07.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:17:56 -0800 (PST)
Date: Tue, 3 Nov 2026 23:17:54 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>, David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Shuah Khan <shuah@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 1/8] selftests/mm: Move sysmap_is_sealed into mm
Message-ID: <1e2cfbe24810f976ee6e176346598900295adc73.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: 5kmzqyq55j3eyjnbs31z6mtsw6sf13fg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: C3EA980003
X-HE-Tag: 1793719078-567912
X-HE-Meta: U2FsdGVkX1/kyzUVwWU7qzqZHtLx3U7dzXlUHW7HMUbVrG3fWg3m/JYyu2WSrR5kLi7SdIU6k11D8J1Si+qhUukJ3WADiKvRe6mMqELd6Qmz3OHzc8WT0sMC3b9NQ6Rny8ldSyYxUQA4Uqoi7tMweac6Nc1QnsMtMnsX97oc+fw13X8+x+HGTQMZTjk4OEU9BwBVVNf4sItmBGqV5eCGTng3S55DW/M+zHefhgJdOl/nk3tEvGYvRbnnWnu9y9YIJae4uvrVVfnSgob4fKcAZf7/3bT81OGVVTF5ZnR4BcYKmvh4Zn+KKK9//lYK3pPqL/GyiBnnuU95h1CvcO4RLnkQ8j34ef0t8eOlGL3vomXOxnHVL2AxY5KntcUsyipEZIWj4BqEObKoLkVV7wLVzqBCqfHRIWNmUEYilEhdIaOs6AV0nXNT1U1f7GikpeXbk3RsaEimNQct3JvGSrwOahL5PC0kaONgHO5yf31u0ODgwcO10IdyUBoaFcvvd6RfT8Zj1aI3O3mQqQDCXnL2DNCwHx90rDVotYB8bDS7E+LdpD2b+NE70Vo9zXS9xAuyUhlH3axcU7EgZCg8CFHbc8HoVZCOUXR4HprhjvEYZlf9yJKpgqzox8dmz621uCzvy/zMeVwbb+KtwdkMqzdo2fPTZzDV+XhXAd8d2XXj6ihmRuEyuprMMNJFyF6l+5zLLUSQzkJwnmzo0ExvZHmgNEp1wBM6rDz64JegYELxJB6ocOniTFUkeGMFnLvVFGj4PszJAt7yacAl5ftk72jQ1pu/BuNBwuGPqe9jWGSI7osylrIjHy3Y8doAy9F2ofAsXfnFLh3Ctxb5hLNCOWgFbFP/NbeWAu/gqLF9KX9oVb29QDy0IIX/ZL0KV5RsSDzTIcx5B/wpNzsrRJItTaB6b34mJjWdfsakAlfeb5KUjtDXBtzGWx0yvPZZwi9qcnUvF2HSrNWqO82PFCeqVip
 l3k+ft+K
 d7YVnNNf5xSYUpQpH8soTj0ZeIXtxpIXIOMipTk/KIM/oiITYtpfK4SZyoxn1LXxSuljP7JvPaoAOsXBoGZEktHkh2QsCt+QYvVr2T3uLqpGK+QfWKfSAwFwy6Mo/KReI5i6Ou/kLd0r8NKOTLgFjnNDcmef6za8hU8h+dqYCqvPibeV4XmGK7rOR9PIIXcwxxZLHpH9eVhFwHOCWNA6awNOhqk5A4r5mgV5MW2iMroSeW2tM6uju2mRqPJeNhmlIsVzr7RyNj0saQPVZYGJsy6EF/yWDJURwO1AzASdMqxX4fyhedlLMcw1BTLhzaOYovdNrAH5eTUKja7aILSMmZQAuEwkfUnHLF/NBWVf+4rNOKlTOTVuYrFirNPqrWmGzKC13nfr/RjA7XlrwaQ266uLwt7sUqlUYNMHejQbJWJ/O5mK+ZJIpe/mS4UkfW+pMy97A9GKwXM31lBsQzTKjQTc8oX8XOZUjC+Fkr6hYCjqAGw8E0lksa+S6s3k5zTBLGY8QlQZxInRYsLby5/iQWPZOUR4La5BLaCWO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

System mapping sealing is an mm feature, but its test has its own
directory under tools/testing/selftests rather than living with the
other mm tests.

Let's move it into tools/testing/selftests/mm and run it with the mmap
tests. Its config now comes from mm's config fragment. The test itself
is unchanged.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 tools/testing/selftests/Makefile                            | 1 -
 tools/testing/selftests/mm/Makefile                         | 1 +
 tools/testing/selftests/mm/config                           | 1 +
 tools/testing/selftests/mm/run_vmtests.sh                   | 1 +
 .../{mseal_system_mappings => mm}/sysmap_is_sealed.c        | 0
 tools/testing/selftests/mseal_system_mappings/.gitignore    | 2 --
 tools/testing/selftests/mseal_system_mappings/Makefile      | 6 ------
 tools/testing/selftests/mseal_system_mappings/config        | 1 -
 8 files changed, 3 insertions(+), 10 deletions(-)
 rename tools/testing/selftests/{mseal_system_mappings => mm}/sysmap_is_sealed.c (100%)
 delete mode 100644 tools/testing/selftests/mseal_system_mappings/.gitignore
 delete mode 100644 tools/testing/selftests/mseal_system_mappings/Makefile
 delete mode 100644 tools/testing/selftests/mseal_system_mappings/config

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 07c3719f8b04..94276b1310de 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -84,7 +84,6 @@ TARGETS += mount
 TARGETS += mount_setattr
 TARGETS += move_mount_set_group
 TARGETS += mqueue
-TARGETS += mseal_system_mappings
 TARGETS += nci
 TARGETS += net
 TARGETS += net/af_unix
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 675ec57d47de..94e305643c8d 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -110,6 +110,7 @@ TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += khugepaged_sync_check
 TEST_GEN_FILES += khugepaged_race
 TEST_GEN_FILES += soft-dirty
+TEST_GEN_FILES += sysmap_is_sealed
 
 ifeq ($(ARCH),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
index 06f78bd232e2..b93b49cd675f 100644
--- a/tools/testing/selftests/mm/config
+++ b/tools/testing/selftests/mm/config
@@ -14,3 +14,4 @@ CONFIG_UPROBES=y
 CONFIG_MEMORY_FAILURE=y
 CONFIG_HWPOISON_INJECT=m
 CONFIG_PROC_MEM_ALWAYS_FORCE=y
+CONFIG_MSEAL_SYSTEM_MAPPINGS=y
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 973cb715b326..573da5006268 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -307,6 +307,7 @@ fi
 
 CATEGORY="mmap" run_test ./map_populate
 CATEGORY="mmap" run_test ./droppable
+CATEGORY="mmap" run_test ./sysmap_is_sealed
 
 CATEGORY="mlock" run_test ./mlock-random-test
 
diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c b/tools/testing/selftests/mm/sysmap_is_sealed.c
similarity index 100%
rename from tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
rename to tools/testing/selftests/mm/sysmap_is_sealed.c
diff --git a/tools/testing/selftests/mseal_system_mappings/.gitignore b/tools/testing/selftests/mseal_system_mappings/.gitignore
deleted file mode 100644
index 319c497a595e..000000000000
--- a/tools/testing/selftests/mseal_system_mappings/.gitignore
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-sysmap_is_sealed
diff --git a/tools/testing/selftests/mseal_system_mappings/Makefile b/tools/testing/selftests/mseal_system_mappings/Makefile
deleted file mode 100644
index 2b4504e2f52f..000000000000
--- a/tools/testing/selftests/mseal_system_mappings/Makefile
+++ /dev/null
@@ -1,6 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -std=c99 -pthread -Wall $(KHDR_INCLUDES)
-
-TEST_GEN_PROGS := sysmap_is_sealed
-
-include ../lib.mk
diff --git a/tools/testing/selftests/mseal_system_mappings/config b/tools/testing/selftests/mseal_system_mappings/config
deleted file mode 100644
index 675cb9f37b86..000000000000
--- a/tools/testing/selftests/mseal_system_mappings/config
+++ /dev/null
@@ -1 +0,0 @@
-CONFIG_MSEAL_SYSTEM_MAPPINGS=y
-- 
2.54.0


