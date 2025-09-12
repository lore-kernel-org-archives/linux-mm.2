Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E018CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80C28E001F; Fri, 12 Sep 2025 08:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58E48E0003; Fri, 12 Sep 2025 08:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D348E001F; Fri, 12 Sep 2025 08:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85D778E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:51:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 54D2D1DF8E5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:51:45 +0000 (UTC)
X-FDA: 83880584970.14.4E2B145
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id CD0D9140007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:51:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=CLwevAb3;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757681504; a=rsa-sha256;
	cv=none;
	b=b98ytBbT/arv9erf/CtYh3x7SxngITyghOgEVvnrEJUE2em19ekfkLCatsuqvUh2h2nEwa
	LrFlTjW1jewEaJXiNpbSAdQAoFkFM1Z4eutj9yNBGKX2Ob3U7EoVF/RMg9poUyx5CEOytr
	nQrIliz/EoyaiTH4QKcVlljq+pi6dVE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=CLwevAb3;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757681504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=H6d6KVvobvRf6h5qFx/slYq7JJ6pJNt8yO6v6nFVy1k=;
	b=J2BWgqiqRQOi+6VWBMUoBGazcx7TMyaiCJbpF34TH5HRZyMaHElvPXM+g3qHZxrOz4SWGa
	mjwBEloVWLolZCBeyWP7vKGGK7sRABYTT1Z3bd+j4TQYR9/M3BeGzQkUlYbUaCL7d7UpsA
	DPNjFlTiSCzfmJlvVxvfuX8H0HImJcc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1757681499;
	bh=2qOtmkngpDfQA1QjDe6RQo1pEYaj3+XYIoXwhftLLaA=;
	h=From:To:Cc:Subject:Date:From;
	b=CLwevAb3CWcyJim69XKJIdeuO297ATtaWgZcLKBdj0cxs8L6/lJleYP4V5c3ARgzZ
	 mvApCazawRn7ksRS8rRgw7+M5IioDk889yvihSyxEjD01Xjzwl7h4yjXJw8uM+8EME
	 q9Efd0AFpPJRRxC4p1h44uM7i7JE1KaFCsr1tEnW6Oc2lQqZsOGK+fIEkro0Z3z5hQ
	 pUj37vBazcoYk04C2qJ8h1ERSRzNu82gQ9cVr78+0PC0w47vAOACV+O8RxHuiIcJ2c
	 QE3T8uVrL7Toa5dwJBwx4YHO1S7HsSJKBtzW5gmIPcYgtwYmnv3Hnh4/Zv7058b2i2
	 j90us0yAg7dqg==
Received: from mt.tail9873f4.ts.net (unknown [144.48.130.189])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1EF4917E090D;
	Fri, 12 Sep 2025 14:51:33 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: [PATCH] selftests/mm: centralize the __always_unused macro
Date: Fri, 12 Sep 2025 17:51:01 +0500
Message-ID: <20250912125102.1309796-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD0D9140007
X-Stat-Signature: 9fczuaeipcbk53sc6jb8pzf8gstzpsx6
X-Rspam-User: 
X-HE-Tag: 1757681503-308181
X-HE-Meta: U2FsdGVkX19uV90h7pJryct7rKEbpGST55tDeq6ug5YLiFfDSRgoAJLI+yzyh0b174aZE1M+zizIrWFb+5WTjQJe7WKNBOQYRiilP3y1AWr9Y8whUf2NZILRhf/8rfM6bzkv8BDlC1iHxyBYBa89/lndhM0tZOQAgU9QYVqOjSIQA+zPpSzxyPr7km1v24uEv01VfCEhEj639LHBEafghClKu8WDsxCWA0di8Zk27+PDGKrWCHAMI/2xD/ePh2m3QyXguVCCvbr8zoeyqNd0wZBJYb1eiZE4iWGbBSdBlr8DADQojCpvxTVTXRYmJCOINIOtb9064tNoUgPCYkp4T9mBtkFfsp4exoKPQoP5Le9fCIVwlpofMJdUjbXdKJTO7TeRoQHAFzuXUE7x+3IpNe5+pI4SpaU64zCGHFCtYtQsZNXsS6iXUBM8EWOrr7ohcASrDfm6eJk4TZijo4QVSNViXHr8zoCbjhngXL0t/prdvwLATmIlxetZ6s17A8nSHR1A7Qo2dhbZ68JYv9Bl7lZbIipsCb2AttACX3B7wOXyhvAc7i9Znfd8HUHKwJVhQl+NDisfCGhEeSPbLhz7+6dZjp6Dcaz0EQdTrb6Je29CCCjPOfBp5mpYIxYgCDnlRFuGPmzlC6kfr2eQosIhAOLZ7SN8UZ/RENFlLnSwsvQbjHwA35gwEYP/k5DjjYJb/oNDM4N6MmoajHVWq5a9ddZsUXH+3Akq4UHAbh//1fdsVv74iXfgQdq9uxDUretooiOTpGjkrydsHfyM268lquLtcHz96TSw6p4njSrVucBxF7YESKDB+QiJFnZ2exceCKwtI+m8h5jQwPN1Gpfi6jqJss0ozXPN7IEWQixnpTS8IggiTKrG2MrLmag+rvW8c0GvTYwI9uh1xZ7eSGWcNknAdXOk8DG/8sA7SWW2Th2IdY8QU78MJ8Byb3UYvtmYq6hSY4Ic5zYLVjOT3PC
 F71KmRHW
 PfT1o++kPMDsM8mugKfcJOtQXyRa0koWizJz5wVPD9ckmaq0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This macro gets used in different tests. Add it to kselftest.h
which is central location and tests use this header. Then use this new
macro.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/kselftest.h          | 4 ++++
 tools/testing/selftests/mm/protection_keys.c | 2 +-
 tools/testing/selftests/net/ovpn/ovpn-cli.c  | 3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index 661d31c4b558c..274480e3573ab 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -92,6 +92,10 @@
 #endif
 #define __printf(a, b)   __attribute__((format(printf, a, b)))
 
+#ifndef __always_unused
+#define __always_unused __attribute__((__unused__))
+#endif
+
 #ifndef __maybe_unused
 #define __maybe_unused __attribute__((__unused__))
 #endif
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 6281d4c61b50e..2085982dba696 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -1302,7 +1302,7 @@ static void test_mprotect_with_pkey_0(int *ptr, u16 pkey)
 
 static void test_ptrace_of_child(int *ptr, u16 pkey)
 {
-	__attribute__((__unused__)) int peek_result;
+	__always_unused int peek_result;
 	pid_t child_pid;
 	void *ignored = 0;
 	long ret;
diff --git a/tools/testing/selftests/net/ovpn/ovpn-cli.c b/tools/testing/selftests/net/ovpn/ovpn-cli.c
index 9201f2905f2ce..688a5fa6fdacd 100644
--- a/tools/testing/selftests/net/ovpn/ovpn-cli.c
+++ b/tools/testing/selftests/net/ovpn/ovpn-cli.c
@@ -32,9 +32,10 @@
 
 #include <sys/socket.h>
 
+#include "../../kselftest.h"
+
 /* defines to make checkpatch happy */
 #define strscpy strncpy
-#define __always_unused __attribute__((__unused__))
 
 /* libnl < 3.5.0 does not set the NLA_F_NESTED on its own, therefore we
  * have to explicitly do it to prevent the kernel from failing upon
-- 
2.47.3


