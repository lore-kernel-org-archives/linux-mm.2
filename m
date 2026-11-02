Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31E3606BA7F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qPfGZsKv
Received: by kanga.kvack.org (Postfix)
	id B71B86B064E; Mon,  2 Nov 2026 10:37:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B223F6B0650; Mon,  2 Nov 2026 10:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9626B0651; Mon,  2 Nov 2026 10:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 777746B064E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14E1080156
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:20 +0000 (UTC)
X-FDA: 85390583040.14.AE67E28
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5DE53180006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=qPfGZsKv;
	spf=pass (imf24.hostedemail.com: domain of 3LK7oagcKCIk8v2v05ut11tyr.p1zyv07A-zzx8npx.14t@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3LK7oagcKCIk8v2v05ut11tyr.p1zyv07A-zzx8npx.14t@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633838;
	b=xurvQINdlQXWjWN0lmZ9Ew+1sW3dMcW6xK9dOGeE8ZcCLvrUdR/iJxFTd4h8AiC0T8rHaX
	weOmBf3kfDkCHF3tHOwYs0RcHtC9t1uz0/TwP16DudLqtFDLhbQpXyO3dFCKM5YE/TCcOJ
	8EZLKYe6Smt6TYDI84wbYk4t4p3Xg4Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=qPfGZsKv;
	spf=pass (imf24.hostedemail.com: domain of 3LK7oagcKCIk8v2v05ut11tyr.p1zyv07A-zzx8npx.14t@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3LK7oagcKCIk8v2v05ut11tyr.p1zyv07A-zzx8npx.14t@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ms8itCh4PfqJV6uxhFhSbZGdhGd+gOvwo6FEHxIUACI=;
	b=ZoT7awoY5Wr/zFrqocYYVJNmGH/As5XOmob4EylmcB8gAc+veLAPi//4fAJ0NSzw9PmnTM
	4A0Vfmqp+aQ9XcRGl3tlZUCT8wles2km9P7Nx+9n5NNXOUq4qI5Wlg9Q3sdKs39t+W0Dny
	s2lLIwky6DvY5iUaPFA9nR/DYRyYLcY=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e93e2f72bfso53692895ad.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633837; x=1794238637; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ms8itCh4PfqJV6uxhFhSbZGdhGd+gOvwo6FEHxIUACI=;
        b=qPfGZsKvKZS5vSKobt7lvkx7Ts+uH/H8eQFypXlc8T1fyxarwmgL4poCAr7dXqfy3r
         jaaNq1RyZdFPzU6CrNzl9AuocO86X6qPXxhQ6DYbZl0D2aF/6WdGnlDQ0TjSvVLyDEUy
         s5QfR51hJc+k/9M5dyQXbVt+e9o+pKv0yOPIddNQ6a8SMpNImN3kqZZz+rEbDB/EPL6y
         aLJfjvtseLk4HaKO5Z/sxRs17gYcOkZ3FCjIET/biADtXgz54La9JU5dEGvrFM4jpf2+
         Q6HkIDgLslYWhADeHF5bWjiSEA2+uMZnTdMYWO7jGsZPNqkwf0XZ9ORJ/WsSe55H5Q10
         copw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633837; x=1794238637;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ms8itCh4PfqJV6uxhFhSbZGdhGd+gOvwo6FEHxIUACI=;
        b=kBG+JwwuW8Bp/asAecZ++OurnnDQ+sZosDEqrjmYEcHZaV3VHycpxZ0Y6O/wCH4s57
         WNPKloF1NMk8AHuDM3T0bN+R6scysSVO6S0dY+MflNG9lZZWBatqZSkAd/PknWg5+4qn
         yPSSKlKyZPac6Ze6b0JcRKm+wcDWw8zmIY3jM93zjsYIDNe2LqZMMLzz9JQZ4J8/aUFJ
         JXc77myhLuaQ96k2LIZq0a44ylP9sXflXdylxpERdEL1cFfa1WEUT8ge4fsNRJH/9x35
         SGXk9B5N6t4tuO3LSC/3kiLYYDMrYtGyRF9e97EkUg8ECgs50fOpDLk0gII33v/2ajmX
         ezng==
X-Forwarded-Encrypted: i=1; AKwUvBx01GPTLMxpKPUhUwA9top0PKnDLxIaX0mAPhCiUE1hfdpcJ1xvZEsRej1CZiAR0sWdgqu11i0ObA==@kvack.org
X-Gm-Message-State: APuU4Z/oCfQwaJtUgudDEpCDO5xhjCg8n69UwUD/UtpTlFIUAeczRqZY
	7u1KLjf4XsRY0CYyeOFvoosJHkvZUhY9MCfEpCSXuZmoTeD+wsjeq+nmNZv1bu/1DcoGkrebySZ
	LhvjxBnfyGw==
X-Received: from plhs10.prod.google.com ([2002:a17:903:320a:b0:2e9:6b18:1067])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b23:b0:2e5:db61:e5d4
 with SMTP id d9443c01a7336-2eb3653906emr104135025ad.62.1793633836956; Mon, 02
 Nov 2026 07:37:16 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:45 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-17-vipinsh@google.com>
Subject: [PATCH v6 16/27] vfio: selftests: Build liveupdate library in VFIO selftests
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DE53180006
X-Stat-Signature: 9ds784jfue8eoe4mzrfftdpr6n4kxm46
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633838-864445
X-HE-Meta: U2FsdGVkX18nZbMsfOI2jBXUIxMuihK5lkLdpsI52TmQt5Ji9zTlJV1GFIFYEiyFmhX9ntqww0p954e2OPmWGRGBnOcTKBFpVBMnsGXs0lNM8KxdDou7pXwd4kV3gxnh440vrqBU8xT9eJQd3mwu4xMOjWXMqxTE0Ds63b5GEqWg5AjySy1Cx7vqfhKI0xjEnTvTfXgzI5vkllyH35Ek9Sx0N11bBo64TzqkVMZjy6TEY2ae7w4HY6V/gBps3t3c/szpvR6RCdrQuqnNiQWwiUaPWkeSi7toK+jDHPa0z4DNcGnm6i18pH4aESFUGRI2HRfZb8x5pqqz93SwDUnjs9AhyULkHO2XafkzkcmjVl9rFYOieHWuAowfvaptwAUfkUWmpL7r925Qz6A/BXCmKeGSxHGsJfSwINnLyBJ+1GEBPsbecbVKoHH09phSr5d1nKMPfVzk9D3SUgw+x0AhT8LfXzAT1CBXwmHaO6nBtCac5602S9N4oDBjlGo630AIYtHUUwH0sGJ2OBBE9awb/V461m/+pZOxF5VfZrEXcd+/Ea68lRmlsxZg0RGoD2N+Cf5idR0Y+CMdBNLAnB9vaTyOVIQy6PRuhv9Y1j7Mv/+UPA6R0c96pjyc58zmzK4GnkCpZ4Zm47mrgR+Zl1ikf3WDEcdrfOrGD9t+MMViUwFej56H7lMZG/HCEK27UQXVDyhYvbdJSrlmFvmcnXzfDVgSPDak/g6RA0FtpxhVK9IfrnQxPEfPhwTJJu/g/EUQtXB9PNrmDE72KdM+NMZdJwWWWaK2wmtW4ydXCf9Udg9voDB+N3aS/qyllPdnl7vZ/QsPOycW0OWRtFvyebbS4C9HkeN6B2AYud22efId9BJkJMLc5yNSfrgh7nR5v/2GUAsAcI+PMgn7f0rErwuaJBKz3oztrHfmzrthMfvRUgI+3G2AahHrTmLZDww2sZ1tWqTTh9uS6t2LNTjIiFT
 6IlVzd/s
 f7jLFZuCqIrHt9HhI/eahAk1CXnRlKk3yWCwy6mdiNPB8E98HAFNUF/A1bBbhrW5Ua46DZ8q5sd7eg+iFznP8m1lL5KxBMNXDEK7+FJIzV/ZmLvxwIX6Kbhjh2U3d0+uGrzCaUFqbQHyR5WuAKiq8DqcC0XMeRb1nG0OQ5/tEEcGCtSpYEtlwjuICFEulfhsN643LNeXqKmHd6aWBt4PaNHmSDQm6R/kdObbcxdXYhy46uQp23xUsmPLUQtcLhp8uk6BUu3B7oUV94vpQfuLGEutoIUUQJ81JfUUQGLX1GMYz7LtfQE2+COp6pqvKwqSr0kn33jpjyHBBtOZz8SiLfCgQ1XbvZ7+FB0pgMlPDdSb75RE/yImOkd8lGToJRAIB+2pXjzKbzQDHWoT/40L7VXP2M7p666nf0ZWB5D1jlAf/RtV+L3742659nJShSCRDAC7PEJEpkK2lUzQlUtQ8N9ZvCXXm0AMwkChbVh2DhUmHVkGuk+acZpNdsO/bz8Rj1st90RDANkqAotmLI6xqXovgeMUBVfptEYe1Ocro4f3YIM0vMB7EGUZ07ivLg7mJesJYFVDcnwIgJdSeKzvd3nlb+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Import and build liveupdate selftest library in VFIO selftests.

It allows using liveupdate ioctls in VFIO selftests

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 2c32c48db509..55e1e1843090 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -21,6 +21,7 @@ TEST_FILES += scripts/setup.sh
 
 include ../lib.mk
 include lib/libvfio.mk
+include ../liveupdate/lib/libliveupdate.mk
 
 CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
@@ -29,14 +30,17 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
-$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBVFIO_O)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
+LIBS_O := $(LIBVFIO_O)
+LIBS_O += $(LIBLIVEUPDATE_O)
+
+$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBS_O)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBS_O) $(LDLIBS) -o $@
 
 TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
 $(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
+TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBS_O))
 -include $(TEST_DEP_FILES)
 
 EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
-- 
2.56.0.317.g454f8302e1-goog


