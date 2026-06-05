Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2835CD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AA56B00A1; Thu,  4 Jun 2026 23:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB786B00A2; Thu,  4 Jun 2026 23:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302606B00A3; Thu,  4 Jun 2026 23:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4F56B00A1
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:34:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC8021C11F8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:34:01 +0000 (UTC)
X-FDA: 84844440282.20.292E1FE
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3129220009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:34:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="KH/yOIwo";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYmKPVlEdqw9nJIpln28SQxgNWXUbITnOaKq2Dm+DFI=;
	b=AXx0SsWf9/u1wZtlLOYfj4LqhBq2IEAcnmYOLjs2/S++Q1tZjq8Sjq3KJVnmrfzzU4xAt7
	mA8ksq7z4xPLzlAqRwaTDdlTQi0Q5ZchOsvZHRgPOsbQj6JDRSrXtdmTdrNoMWBqhiSICp
	ZYcgZM8hkM94J6pRjrbk56KuTtZXdbw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="KH/yOIwo";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630440;
	b=xmjumA5Nx0scLIwcOxwpA7FalmIsIi0Neai4VhLzp2daVSl1aRh3D/BS9SL7RCHDCLZy8x
	BI95PiXWlyCjLkVUedF1s9EEJemizfoeEUIvAOam60JxTo0PbzAHRfvBKTY6WixJVLLnLY
	25KBXh5hEMrAgjppRYBidBvRHdDVBV0=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-915aa0a9293so52384385a.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630439; x=1781235239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jYmKPVlEdqw9nJIpln28SQxgNWXUbITnOaKq2Dm+DFI=;
        b=KH/yOIwoH0hO0jitISUXICkI7HCkynWoI99G3zCFl/EmdWnQ+Xmp0nZMDjWrfwFnKY
         KjjLdnIQo8lXURAGaxqd9cTYVdFCReDj8D0gpp7cxBgNi2JyfXYIiwlilycPyeIaL6UK
         T6E5xMAoOrb9jX1SXHs58oRBAVHy4SBPc4rRKY6q+nFR9n6XTF3NqR1h4U5gJeB0/N31
         0662LQxNSJ4NUjColQHS3BWyfcCW5v5OVg37dL9XlLwK0vt7cinVU911j05TMX5/UOeC
         KXeMmTO3uCfbE6R0bLUEPK+Q9uXuGBQpjOn4OF2cL6BhVIFAUm7ndanEV+L6Xry41lfG
         rKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630439; x=1781235239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jYmKPVlEdqw9nJIpln28SQxgNWXUbITnOaKq2Dm+DFI=;
        b=YsnZV7e1ehWKDxrvIBu8Rx8kI3S4TvGbxvID3ZICurNMwp3qRZxhLZN05mHcd1uHOP
         V0eaKfgK1ik7hqolVVxQWCFAns4VOSNQrZY5G7PHvHeVkIIL+fXYRnAIXL8IT1jX3Mwm
         7Y/20Vb5t8JX82C7nbURDGeSQNh2OELIauntj89FHemcXaN4VRtxzxwhaDUn983grMFQ
         Zz86JKwyV2s0E0P0dWpY41WhI5MAlVm9wr/1iRg8yIEpetg6gyHsCGtMQHSUtlDbZqgO
         cxoA2x9DYQ5A60NheyTqDwG60jF+Loz4MACS62YzD1VrKbjwYRaINLzMnhC5P+dyvWYE
         JH3Q==
X-Forwarded-Encrypted: i=1; AFNElJ+UDH7QbUHXn5DCBYVj9vgChMFdEM/+oDYbYmScBJMCOGfQKQKTThF2Fkmc7V80hMAGo0rlajo2Cg==@kvack.org
X-Gm-Message-State: AOJu0YzeuXO+xQN24CABtQEJSTg0MFEXGAiOrONzSZzWPvq2/c9VE/g+
	sVcWWvk0WHS+ndq7FgViWPgr4Ko+8MHASqy2jG5gw5kfBJhMruIVM984DJm/3nUBdzc=
X-Gm-Gg: Acq92OHzCKUOFhCGpd5esqd2eD+4qziqrsDZ0UM/GroKHW1WAqOTAK5pbyYRBpwnhAs
	DJUY1GSIf+9VFcVzj/p+snlLKWaAixF7o9FBmFHi19uqeA8L+7Ix07jUYYaK5GQYea2pXBR5oaG
	o7cGjEOl8BoKBPQHhoWfeqrXvd7iKoV5uSzsf0bgm7TNHVbPG0j3b+/ZfCIBG7rxQkcyLnm16od
	zIzo7dmFWWPqjBJwVk5SMI6c/Wb6dlEwJbY0QErtzUGAIcFwBd7mKplB7FVQKDE0Zh12Vp77mO2
	8nTif0jCUb/KzoBZ99MgaZMGk1OqDL1n5zox1tZ/b+3MOLiIYc1MYFgFqBb2NwQqDolqbtQuvup
	xZmgDircGGyNIG6UW1L0iaBfY81VN4CNlveqqmllnyw+g7dX7C5aPKxeu7MiuHWE2+Z02fOu5hI
	jtiIZjUEYj06G4eriUk8efH9iW7ndwW/qxi+TCFQOBqXhYDwyef6D8vdC3BAux1Q==
X-Received: by 2002:a05:620a:450c:b0:8cd:d688:7aef with SMTP id af79cd13be357-915ad197c8dmr107318585a.19.1780630439344;
        Thu, 04 Jun 2026 20:33:59 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91589ea0bcfsm780607085a.0.2026.06.04.20.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:33:59 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 7/9] kho: decouple radix tree compatibility from global KHO version
Date: Fri,  5 Jun 2026 03:32:33 +0000
Message-ID: <20260605033235.717351-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kgi3e1qbg4rigiena1kdphjoq6xze8na
X-Rspamd-Queue-Id: 3129220009
X-HE-Tag: 1780630440-706972
X-HE-Meta: U2FsdGVkX1+l8nGuYU9HBFP+V0h/N5jz0pcrqbIns/SgjvuuanNxhYkFf75g0Dms3QSMj8ZoK+zD4K3ySjYz5/uaOD4yDX4XRXgyYPsKP159gsdawoC5q3aVYr1RRbY7ThyrR/BvlSfpTo7zBFB1E5vFvgJXSuITQcoSrxv9WF6n6IWe10RowNbWAT71qcomA2iGmqR/YV4/teYgPhsYwBzSetj9IpKRc/tzdcD1enHynufcz7sXXxALWfe2TpV4KE5mJVHZY5rSu4wgpYp2EIrmFPBo/BK6IqtoNcb56omrEuWV+KSWxEXOWUbxfMOoygXHZboeXa6wuG4l4HuhziyW2zU35JUP9tt0X3kQZKFXz4wrqFirBrRJfJSJC+rnMoVr+XQ5mf/MH43dAmx1wDjUfpsxHjtpM8fs6HZpaMq6GLKPlLk4y2jfFwwFSCI7gwLn/+dZ23RsnaXudTMdLYfuwcfXPoI+krCRz3dUjPJETNkUgD5CwuboKSooQOv82x34am2PB3YvGHnAMR7nmoI4SpbwBvrHko6Ud0CjL1jQsfY0yFiR00DU2AAhEUgW5ltOPful7iahxC2vjn35kPua+hN/rw2WltL3ZIxP8Gtrq5qYal6cHEcdskO9zQov7Z03LQ29aJjtUzxpVYdVJX7AKZhiytyMOg80wV/XrbYtiiR6k9EH6XBwFinpJU7sRFR+M0nCC4ElRfk6qCYYYZ79L8ooPQ+tu8XHzKud75JgQrfxXqnRvH1q1n5EOMV7nNjEZlkh4QWnBT9uW6VF/CDoYfJoOa7+HQGM3+SW5/z+VMP690jJeqMe3ADpUr4oYI1Rl8WhHOtfYmr6qRsvZk6Gde/8mgl+IueJsUkYB9I4EMEKytOXGJkcQPSS1/KzAw2FJahyAciUMT7nJV+vF6qT+LLehWqHkAeJQxsgc+RMpG7Wvy1AIQZ774D0oUN0TO3hLe1VKHWORTeRUr3
 j+DzCbt7
 TtVyEe0RRSmiX/b2YSygKxNAGtEZVTO7myZiRVffAHw+Gz22Q47kpmUCmbbLm3w7BsPmoJ1m1gT1HUIbK2fCuRLL7cpwGjHd/wgQ5VImllMt8h0oXm2z7ZD+q2RaPnvB8Xi1dfnQBwt2nxPSNIVXt1PW0h36ILsvQtnbYjk0vKiTGZuTQ+798AYbqYeyTCj9JaNflF5EsvSmspj5Hu9NTekO8RtMF2jaR5NbHxQ1hrOdZTmTAcy8Oo8lNHOwN4ni1+SMmAIPkPGu5gLCRQUvDBDY5zEMwTwZxS8FOIK0B72e/j5VJsfYBf5ZVhGH0tpTGVzdy/8P6qdm7Ymx9B5giBAb2Pz6sqWw6Yay/kndjL4LN8AaCFykPgsTfig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Decouple the kho radix tree compatibility version from the global
KHO compatibility version KHO_FDT_COMPATIBLE.

Define the independent compatibility version "radix-v1" for the radix
tree KHO_RADIX_COMPATIBLE in radix_tree.h.

Integrate KHO_RADIX_COMPATIBLE into the composite root compatibility
string KHO_FDT_COMPATIBLE.

Additionally, document the new KHO Compatibility ABI under the
Documentation/core-api/kho/abi.rst section.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/kho/abi.rst     |  5 +++++
 include/linux/kho/abi/kexec_handover.h | 10 ++++++----
 include/linux/kho/abi/radix_tree.h     |  4 +++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/core-api/kho/abi.rst b/Documentation/core-api/kho/abi.rst
index b61363679829..6acdb7c85239 100644
--- a/Documentation/core-api/kho/abi.rst
+++ b/Documentation/core-api/kho/abi.rst
@@ -10,6 +10,11 @@ Core Kexec Handover ABI
 .. kernel-doc:: include/linux/kho/abi/kexec_handover.h
    :doc: Kexec Handover ABI
 
+KHO Compatibility ABI
+=====================
+
+.. kernel-doc:: include/linux/kho/abi/compat.h
+
 vmalloc preservation ABI
 ========================
 
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index c893b5045078..49ac4b47cc3d 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -8,9 +8,8 @@
 
 #ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
-#include <linux/types.h>
-
-#include <asm/page.h>
+#include <linux/kho/abi/compat.h>
+#include <linux/kho/abi/radix_tree.h>
 
 /**
  * DOC: Kexec Handover ABI
@@ -85,7 +84,10 @@
  */
 
 /* The compatible string for the KHO FDT root node. */
-#define KHO_FDT_COMPATIBLE "kho-v4"
+#define KHO_FDT_COMPAT_BASE "kho-v4"
+#define KHO_FDT_COMPATIBLE						\
+	KHO_FDT_COMPAT_BASE						\
+	KHO_SUB_COMPAT(KHO_RADIX_COMPATIBLE)
 
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
diff --git a/include/linux/kho/abi/radix_tree.h b/include/linux/kho/abi/radix_tree.h
index f4cc5c02f37a..89cd7eb4a91d 100644
--- a/include/linux/kho/abi/radix_tree.h
+++ b/include/linux/kho/abi/radix_tree.h
@@ -20,7 +20,7 @@
  * This interface is a contract. Any modification to the structure fields,
  * compatible strings, or the layout of the serialization structures defined
  * here constitutes a breaking change. Such changes require incrementing the
- * version number in the `KHO_FDT_COMPATIBLE` string to prevent a new kernel
+ * version number in the `KHO_RADIX_COMPATIBLE` string to prevent a new kernel
  * from misinterpreting data from an old kernel.
  *
  * Changes are allowed provided the compatibility version is incremented;
@@ -94,6 +94,8 @@
  * 4KB.
  */
 
+#define KHO_RADIX_COMPATIBLE "radix-v1"
+
 /*
  * Defines constants for the KHO radix tree structure, used to track preserved
  * memory. These constants govern the indexing, sizing, and depth of the tree.
-- 
2.53.0


