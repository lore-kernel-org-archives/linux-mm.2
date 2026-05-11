Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83A3CD484C
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 17:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321A46B00A9; Mon, 11 May 2026 13:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FAB66B00AA; Mon, 11 May 2026 13:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238516B00AB; Mon, 11 May 2026 13:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 110426B00A9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:35:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCB651C00EB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:35:11 +0000 (UTC)
X-FDA: 84755840022.26.D56D082
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1E12A1C0010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:35:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="i/lRYKSA";
	spf=pass (imf20.hostedemail.com: domain of 3TBMCagcKCNECExG9x83BB381.zB985AHK-997Ixz7.BE3@flex--pratmal.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3TBMCagcKCNECExG9x83BB381.zB985AHK-997Ixz7.BE3@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778520910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXZTF46pWxFDLw2H92ISedrm06zB7QVPEnfycFkUHV0=;
	b=MIvq8ScEmTi7dmQqkMIH4+qaGS2MJIDb+Z5q1OifZZM07aAQ/Ft01ler5IQcUoPNxCmwDu
	osMr1M3TQ3/Sf8jl9zh2oC7scklNK84fPXMzR4BbsbzxtKiAaCGlqzIfHkcA6veQ63pqXj
	s2K9dohhGIhIEB20X2KGLrcUoEdNYEI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="i/lRYKSA";
	spf=pass (imf20.hostedemail.com: domain of 3TBMCagcKCNECExG9x83BB381.zB985AHK-997Ixz7.BE3@flex--pratmal.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3TBMCagcKCNECExG9x83BB381.zB985AHK-997Ixz7.BE3@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778520910; a=rsa-sha256;
	cv=none;
	b=ULDG3PGxmAmNKmydMDUmEX0Q1T4a+50nxOvKH02NijjcS8DrUZWQnDVUrw0piKrkkEOt/N
	HUoVVMJzhGFLs3291FUO7R/3nGpFZHsCjSX95JD60Im/j+t4Kb6lJB10lPzEZeUZTgD/Rr
	t2MqUyzLThka37OSUpmCxpFawKDdbhA=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-132a9b34697so5726090c88.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 10:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778520909; x=1779125709; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oXZTF46pWxFDLw2H92ISedrm06zB7QVPEnfycFkUHV0=;
        b=i/lRYKSANad+HJl28Ko9BiNQsRkjljpw50W99EfVK6+tyZDeQUMf3bN1IZM8fsA3Oq
         IEUiFtu/ZmnJyF23hyk9CFHZbu54/L5Pq6rm7e6alYHg0ay2zVQZZ6Cjq203+/NyLpUV
         0lCU9gfn5nJTDLA9ebxP/8fr45nGy4c/ZlH+vD0RiOwICGHnAsExUaLRiZB7BXxhfUBu
         MaCClwXdxHJU8c6XyzHXRXPNKij9zcke9yR1539NgVZycX1FAOvBknfjhsqpmIntyAmR
         TUmntMUaDbv6VKQPnwdIHhInry6Jzf6Q9Qx7uG6IWALtdF9YMK3eIfY2ryzuLlmMiw2D
         W8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778520909; x=1779125709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oXZTF46pWxFDLw2H92ISedrm06zB7QVPEnfycFkUHV0=;
        b=egM84JWYjctYIX7KHw8sqVrjMprE6MS0AhjywoKEEqebb4u1F/2milcZ4uTLNY1hXb
         dThZ6kAulv4RLFgzCRRByCiIdI0wDpBE0GX0dohaiReuiVkhhOu/i91C75n3bXLcC4GB
         KMV61tEx4UsbuyE7yLAVFxhehp+nVOFK4r+IgcMSgzdFgSTFqBv8ilBWaGSUccA519Gw
         PEv2FSbIBOlOz0Pe5/AwCwmUf78d5ESkhL9/C0WOonXWEfJS6cMlO/aNfIidtGwhZbmJ
         435V2gHbbXRvPebRzNwBA6Pp7ey9B4E48lcaifSA4D71lsU//YqAG2qcL5BTCBHVn7mL
         3KYg==
X-Forwarded-Encrypted: i=1; AFNElJ/4BK/eX3B5vtcSr+me8paDA0Ow60emjCgSiq+Ga1i6SGDcSam/3gt44oOgpmMA8ED8eRNeZWGEzA==@kvack.org
X-Gm-Message-State: AOJu0YyqLi71uTHaa7CPXF0cmq/Smjx2jAmZbjwsaS9XfJZ3nShIDJfV
	jvN34dOOYduqvWx03RFgbcjRST6i5H8eiBF6vdhSMetT8O5RYnyZ5EQvvqUrWIAO/5MB+rL1/e3
	pDc0K3Z5Hxw==
X-Received: from dlbtx10.prod.google.com ([2002:a05:7022:fc0a:b0:132:8d92:4d73])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:ec4:b0:12a:6902:ddb8
 with SMTP id a92af1059eb24-131965af2c5mr11922224c88.4.1778520908571; Mon, 11
 May 2026 10:35:08 -0700 (PDT)
Date: Mon, 11 May 2026 17:34:11 +0000
In-Reply-To: <20260511173411.267628-1-pratmal@google.com>
Mime-Version: 1.0
References: <20260511173411.267628-1-pratmal@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260511173411.267628-3-pratmal@google.com>
Subject: [PATCH v3 2/2] selftests/mm: rename local_config.h to local_config.h_gen
From: pratmal@google.com
To: akpm@linux-foundation.org, shuah@kernel.org
Cc: yosry@kernel.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E12A1C0010
X-Rspamd-Server: rspam06
X-Stat-Signature: qxk958q7ncd69uujefj66949xxa5oaho
X-HE-Tag: 1778520909-655104
X-HE-Meta: U2FsdGVkX19fCPrlVOB7Sf8I2thGs7DVayjmHubH/3RE7nSf1TElXLKODBb//RTUSZrq+26ludLrwCZR8zy05Fp4dfN20CvSwTHjGnYUJ8AGL9lge8uk/f0QsCWyEGoXK8bHScWH6IIrTaCIgNeSCnWLqIsJhx/qln0XJHU/8eGRNMOTZML02rRHBZplk38k+Qq/7iWtkymr/155ayMk+dltD1ynV10183luEkSzxsCKrVyhgO6Q6+0IBg6Fe+pHEkxfov/fCWJj+f2zT5Q2FNFzPjzQ1BobvpKKCfD1HELjIDV25AqpWFCnKTxH771n3CRbpZhhIybxCmr2fqobTClWX1K1oDeRkn4ye2b+z9xNdjOeqkSVLhnvLIzBhiVKKpgH0k3gqDIQrt08As8X5m1tAa/QMKhSYDWUuRB+hm7bYoIqhRetj6bVtombWyuYL88nDLjuUGch2iWMYO482XQl+9ldm0oKcs6ZZK9oHZNDzR/xOOXCsjl+s6LcUvCfvDvKuZNWbuX7Uh8el/mm3elmJH8wJTML8zMNjv/X6l4syvZHtDHY9/I7wvc5ZcPaXE9XwYEcn4qMclJQlugtaNLp43IXJcDAqPHOZ33S7jMnGbhLoMdGq8uSw+ZwpICudBwQCy6/IBOZyBUP50inG1xE3fB3UmMq3L1y3pYviLxmqFvCkKPITSX+x2b99O/CX91g+kMXso83EntTn5YtXcUinL465QQgRMIQPWekk9oTFzGWQZdN0XVASujvcXZR+ZFlFyl63Z1jzYPfa8UQQNESP7VcfsdEgrcud6o4205CAXkV92x40WU19tbvrVMiVrnDXapnWRuqBg0qTHZeOVJ86h9vsWJgs1//OXgOjiA0P+NKa/m+zWwE/3sKt/93/8x2PP8DrjPd4ZD/kAB/tLH0AJm3KLdfBV/nbxh+vk+QeJZiYsF/TuO0bRi/rIkMylTK1v8i5/AjGOswIq3
 2S4Seonz
 IFqCMZ8g384OJxxY1xbEMbyqMFMI2f8YNDBsCG8S+jmnEMhQfUs/R2GfK+WcZ09o4vVYjoojz6FFEp+BOccZx45vaVREE+wCv4mvBi+lsrVemg/ZzWWc4CDEUpS0SJv6e5HIWlAulqpdEND83UJYI6aR6GzUnq0QiANWTD3BvKSIlG11Cv+grcIkPA6FCxAIRZaBYARi9YnZi7cGmJlkY0jFnaqNctcFb96aZPHq7i1CJLdee2K8ZCR1UKb/yyInUpgXKpW/Kd71i/A+J8bp8fRp7+5WPm+JdZbunwMFVYxgg4MO+tP6AQRNtRwZmpAfvQTXOM335GdE3sBlL+c5s20AMMkpyhW286mkFJfRvL9ibsSsmJyVAYFjgcH7xV5ai5hKTPl3PiNm/4W2KuBgc4i/Wzmb24y9oczmb0PSgUQhfQeS5laJpBLQkvE8HxRyXq41pSgndoMbyAUGQCGCydFouLUy/WlmY46++FoSuYAtI9M2xUdm+9eVi4unL5h3Fyfxyzuqxng3T95gZ8mIUBPGszLjDS/Fj4lvyYIrRPKD4jh5VTh6S2PdWeKxto/mjGxn0C0DXNDRD1UEnXJ5vhCCgBpouYxg3lXi0QKsBrJ8NZ3Xyi02xiJi4/7mr+Iz1pLk4qjeEqZ9PH8Tztfh8VGwhlP4l1Cczgjj2Eu9vSrSrOUlKASIQjJGyMGyKOIHHChh5s26gb9dkqC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

Because local_config.h is a generated build artifact, un-ignoring all
.h files causes it to incorrectly show up as an untracked file in git
status.

Rename it to local_config.h_gen so it no longer matches the !*.h
inclusion rule.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
 tools/testing/selftests/mm/Makefile        | 6 +++---
 tools/testing/selftests/mm/check_config.sh | 2 +-
 tools/testing/selftests/mm/cow.c           | 2 +-
 tools/testing/selftests/mm/gup_longterm.c  | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7a5de4e9bf52..32f4b016b74f 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -5,7 +5,7 @@
 # script so kunit knows to run it, and add it to the list below.
 # If you do not YOUR TESTS WILL NOT RUN IN THE CI.
 
-LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/local_config.h_gen $(top_srcdir)/mm/gup_test.h
 LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
@@ -259,10 +259,10 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
-local_config.mk local_config.h: check_config.sh
+local_config.mk local_config.h_gen: check_config.sh
 	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
-EXTRA_CLEAN += local_config.mk local_config.h
+EXTRA_CLEAN += local_config.mk local_config.h_gen
 
 ifeq ($(IOURING_EXTRA_LIBS),)
 all: warn_missing_liburing
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
index b84c82bbf875..b46bf2d2e7f8 100755
--- a/tools/testing/selftests/mm/check_config.sh
+++ b/tools/testing/selftests/mm/check_config.sh
@@ -4,7 +4,7 @@
 # Probe for libraries and create header files to record the results. Both C
 # header files and Makefile include fragments are created.
 
-OUTPUT_H_FILE=local_config.h
+OUTPUT_H_FILE=local_config.h_gen
 OUTPUT_MKFILE=local_config.mk
 
 tmpname=$(mktemp)
diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index d9c69c04b67d..87710c5a2d3c 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -21,7 +21,7 @@
 #include <sys/wait.h>
 #include <linux/memfd.h>
 
-#include "local_config.h"
+#include "local_config.h_gen"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index f61150d28eb2..00ea0dd2f655 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -21,7 +21,7 @@
 #include <linux/magic.h>
 #include <linux/memfd.h>
 
-#include "local_config.h"
+#include "local_config.h_gen"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
-- 
2.54.0.563.g4f69b47b94-goog


