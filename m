Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390CE606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CgUcfMEI
Received: by kanga.kvack.org (Postfix)
	id 503196B0AAB; Wed, 25 Nov 2026 14:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC3B6B0AAD; Wed, 25 Nov 2026 14:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1906B0AAE; Wed, 25 Nov 2026 14:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 181B76B0AAB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:30:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 891C8C1097
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:30:50 +0000 (UTC)
X-FDA: 85474633860.15.6F13518
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id CC3B6180005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:30:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CgUcfMEI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of takano32@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=takano32@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795635048;
	b=AklriJpoCHroj2s96AfTLwSJR19qR7IT2t9zTo4BUva6/+I+nK2Pq8TCrcd+cb/DISt+V/
	8eMKHzVBJSWB+GZNE9D90Ca0+fMUl8aUEv9iBlDZEpgmtvCdOSEcmX8YNDNxyC2kxyQvEn
	8ohSgCbkNYmC7kgOAuAUF7B+DzHEsFM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795635048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4c1FYCoWuV0D5AZnd9JhUkc3urYu3tiqyGnrAo0dVsQ=;
	b=yHqFtxxjz3V377NxJeiLqXb/0J2b+N9mlPr00k8Rpbw0yyUX+eVuff6SEVwqB1o6mDyZiF
	saJ3k9OcXrcCBCRBr3Pp5UqI+BogBbW88uSBr4EdgXMofnYw7xYhS9TxpZ6hhJvDodoJQo
	n9lefKl2xojoua2F+cO2xdl1jQEXbu0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CgUcfMEI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of takano32@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=takano32@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2f04e3bf46dso45740655ad.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795635047; x=1796239847; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4c1FYCoWuV0D5AZnd9JhUkc3urYu3tiqyGnrAo0dVsQ=;
        b=CgUcfMEIB80VLCdUYIEebsCv+ziaUvi4flnU0f+XKrRyJf4+DpR9UEEd/1QYWUapH8
         ruavSNlel+MviWXU9f90QVTxn3FKtrhHMh0CYOTzNx+eBJFF7wSJHDZHKh4LICLxcn6O
         xz0JcohbvxglWm2mDe0ICK83svkPPnwtj1jX0yxsfc+ZCbguZgr4Vm7Z7R/p+WbCBt/D
         WhelJIJzuCs3I19jKmABW/nXt0omzIFtsm/hjY5NEDR+QqBZ92b8wcMgCUkKj9LJMd+C
         Srmz3HSWklVdtGjamIgdhh3MRLj5nvsP9gg6wY3JQW7frr1vX0eSiy7rdlbutc/GX67w
         3jBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795635047; x=1796239847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4c1FYCoWuV0D5AZnd9JhUkc3urYu3tiqyGnrAo0dVsQ=;
        b=EDri9Kw9Sh5ncmMoxNhnFYl1jZntT62q3lTt6a65RqDu8jqkL0Ydz+naaZWZ1avERG
         ajTXLug0WP+zQ/T9zWG3XiixumZy8iNxjsQNInG83dkvXeIxl8NKkEsongg6xdc2O1yy
         UBwQHScPwFJycYH6bbofheyXOqzjUDEEJdxGIVrWzzcBH4LtCWeFYL3teGCH3xysGlEH
         +yd15x9Yw63Xqsijo1Q8QiHcP2bnBak+8pwk8prz52gIyNS0ZFc8ge4+aHwys7n+Xnd8
         DIZjptffceYI1RRgTHZRXFUCaDLlV3qEjz8Jvrm5xWbUknRWvHmoMMy3CHPbuA50sRxE
         OjBg==
X-Forwarded-Encrypted: i=1; AL+hErFBMS3tWRlXTzWMF9AhFAXqTdp7I9PenKE2B7LDga9AMRbMpr/JPb9OIUtqsa8c1iOP8WaB5YC2VA==@kvack.org
X-Gm-Message-State: APuU4Z/S9OA/7LwWEwImwsIkbGYQqKwBh6+rcBSkQdT9oitKF/4Z5cpj
	OAyPRSK/gUNMbeXjxRCUwyRrdNTqODi6CqibB2PptPalbL+U7/8px5y0
X-Gm-Gg: AZFdTZcrBOa+0BEtWTI+J+ysnzCsQ43HR4Bq1FF8Z3CaVlnGq9ZyMShDVbnsci5O/4B
	2XljRo4zBYYUulDygfzjQhgPVj9QpBnrz6xAn6yJAwXRqepTcgjoSrDB2BBYbts45InN6xYGT5g
	zhAZ8+kNZIVYZIwZKx82eex1cLgQGwIm5LaPULSWS5eePGNPcMmOVDVcXvCk1H2iUG+9mEkDD5g
	1Pfqs+Xsvv5L81jlUS8rkordu6aCQoK1DmL966BlumLaSklJxYfJE7mMw8flcEGA717XsnooTVm
	4obb4LfbdlMJHLahaw9rpOE1ugBjmww+N66vB1fFaYWjM+8Brl8aFY7L/IwFhGuOz88B/k0TRVW
	espV4GzJvrmZoDRxXhdHjcEf1NPzS+LNDGqFS1wgLr/4eoBgd1mH/nloSyEWP8q0xd/WVWEI48/
	0MxM80xCuKqDbdcJT7muy5NoWWmah4UKMqnHzQt9Ezfaiy3gQi2rVu7oPQpPLUmxJ0f2Yxjf1a+
	U9Y93kkaydD4t6GEuA2VCgahUrvbdcTntyHxX15+b8rOVWaoGxBihbfD1ikcIA+bPdVVUXMu1pT
	KHQSBooyqnMl4g244fMa
X-Received: by 2002:a17:903:19cb:b0:2e9:3dd0:c8d with SMTP id d9443c01a7336-2f03f1cf44emr208593395ad.14.1795635047369;
        Wed, 25 Nov 2026 11:30:47 -0800 (PST)
Received: from a1-free ([2603:c021:8021:f000:0:1865:8c38:18fc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84425sm93698535ad.6.2026.11.25.11.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 11:30:46 -0800 (PST)
From: TAKANO Mitsuhiro <takano32@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	TAKANO Mitsuhiro <takano32@gmail.com>
Subject: [PATCH] docs: Fix the name of the memory hotplug online type configs
Date: Wed, 25 Nov 2026 19:30:39 +0000
Message-ID: <20261125193039.2437025-1-takano32@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC3B6180005
X-Rspam-User:
X-Stat-Signature: en7wp5k5nb8wtiaymww7nw6nqmtn58c9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795635048-358165
X-HE-Meta: U2FsdGVkX183qvIKVaQLD0xjle3PigYPnyb/EmGNXFYzKqUC216yqngG+C+kY5TulkGYL7P3voUA3ugEukr0bEs/3n3DzNH9IZJiLIONo0hNkf/O+38uxYtiu6D2wfiraI9GDXgyCHpD+J55+EZaWlZG4O4cyvFFpB2bCTRLqx94CQ0qBjjrH0b/cu6deXobnYq+egr98n7TBiLICnEkYkA5L5X0PtQwrR/25uheMAJ+fw5C5Sho9+FuNpK8VwbSZHEB6gmD2GQ7owDw53ZGXMfcsbLHjxNlILVnr4zvgpiHZpn0hLqRI3WnaUuj1GTPfKwfK76iwFS2dhegP8vAEoWi+x84ZZsX+dvJg9vqq+ocRs09wumcFcwsQkRhM6ZvEbv8ZweflqOnt2OzsbS//VLnlYKywzWXKOZ/F4hpxtZ8evoyIblKjVrxg5uWvpaWHDCOoIG2ywTphhmxafeknzqEIjvvs908XfmuoRp/1pe9QmzubVe0hVg8JbsG87SWz56wLLTiCOVWfIy0pTTt/rqqJPlI6aMzw7NqiQHd5jZQkGWjE5kUFiBpwytTCp1noAxmvtMX/CPZHSsaMCAoF+ABtj//Lm9wk94dF1Dli4sy9JldPTW4QZvel62lf4+sUspAhjqq7nx+ETB7LJMUZj7CSoKHHzVh6d/GCdycH10EHiSdLIZYLHSK9syuIDVr5qGfB02o6k+xzaSJITFueGu4bfTxLHIMALKt8nMVxLHhDJZYIIMw/daVx0KVaj9iKboEbvZRTl+4nav7PMmmELWnagcStyhz3hsSxFTA1fXy1u/AcVZsN/nTBR3yWV+gHslwSqknlXfcx+1xphT3aYV6xA0O+yKeQMv8gyewyvNKMHv1pI9KEAYA9SZ+u8zSC1yVKDw/90aLYWwbiiJHFj6DqdiYWDWgncT7u/PZE3IENKEnw70T53YSuNdx8eGose2gB7RxGh3/fwCASR8
 3Vt9R32Y
 UVj/6ix8HO7NLURaxCEkD2BPiJkuY7hpkQnb0ZabiDGvFrJnDLP7p2kFNyw6Pupe75KVjx9LxcfUE/QzGtKxOQBVytoqAOAfN2Lva9jz6wfSvh6louWqWryHXjKjBHa7pFjq8InnC5IPm3t0Ys6IzcxR6zyVUyq/u28IbtPiGN1bR5sp4z2bMTZNjARoqQPmtlx/yTxGTyazr/y7Nosl9AtlsJg4UKAZQr/pjsFKnqqZHICdxHUpoitg6T5R9ENAiIGobmKO9kv1rQYLVaE7ypMjHI/u/KRncahoby1wkdMKysO3/jynzKaDfKmBrtcMt56TLCRVXNNrhveNx445/26Wm4wZM7oI2j/JDZMbB1bhDHkYTvQ/fmt92VpUaFtiYReOnLJB8vTofyvGmImsS/czzhlauiXB7ASRWc26z03tIw55Ds66T0StfCfOdArAaeeYOhx8Gth/8dmvj7g9ETjcReyYX5JfYwLSDVrb/RzNG3k/AGp5J3EW4xKb4a+6k6VsRo/LQt7vDigVfDpSr7E0ECjg13UUlJrLR4gkoOzxDU+LJ6i87D12ifZaJ18U5T3eSwqa3oQA1lUPO2Aaw8YsN0JHZ7gBevbQp1Eh36yXLP55GiIyAQizu8dI9ueL/Oyirm0vocGiuLGZ+rWapJqTTlzOlZVO08ZQTL/bYfessoF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The default online type is a Kconfig choice, so the symbols it defines
are CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE, _ONLINE_AUTO,
_ONLINE_KERNEL and _ONLINE_MOVABLE.  There is no
CONFIG_MHP_DEFAULT_ONLINE_TYPE symbol, but five files name one:

  Documentation/admin-guide/kernel-parameters.txt
  Documentation/admin-guide/mm/memory-hotplug.rst
  Documentation/driver-api/cxl/linux/early-boot.rst
  Documentation/driver-api/cxl/linux/memory-hotplug.rst
  Documentation/driver-api/cxl/linux/overview.rst

Spell the family with a trailing _* so that a reader looking the symbol
up in a .config finds one that exists.

early-boot.rst also gives the zone choices as _NORMAL and _MOVABLE.
The symbols are _ONLINE_KERNEL and _ONLINE_MOVABLE, so write those.

Verification: a build of the tree defines
CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE and no bare
CONFIG_MHP_DEFAULT_ONLINE_TYPE in include/generated/autoconf.h, and
grep finds no reference to the bare symbol under Documentation/ after
the change.

Signed-off-by: TAKANO Mitsuhiro <takano32@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.txt       | 2 +-
 Documentation/admin-guide/mm/memory-hotplug.rst       | 2 +-
 Documentation/driver-api/cxl/linux/early-boot.rst     | 4 ++--
 Documentation/driver-api/cxl/linux/memory-hotplug.rst | 2 +-
 Documentation/driver-api/cxl/linux/overview.rst       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 176648941aec..8580099b98c1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3948,7 +3948,7 @@ Kernel parameters
 			[KNL] Set the initial state for the memory hotplug
 			onlining policy. If not specified, the default value is
 			set according to the
-			CONFIG_MHP_DEFAULT_ONLINE_TYPE kernel config
+			CONFIG_MHP_DEFAULT_ONLINE_TYPE_* kernel config
 			options.
 			See Documentation/admin-guide/mm/memory-hotplug.rst.
 
diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index 0207f8725142..c7de458a962f 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -280,7 +280,7 @@ The following files are currently defined:
 		       blocks; configure auto-onlining.
 
 		       The default value depends on the
-		       CONFIG_MHP_DEFAULT_ONLINE_TYPE kernel configuration
+		       CONFIG_MHP_DEFAULT_ONLINE_TYPE_* kernel configuration
 		       options.
 
 		       See the ``state`` property of memory blocks for details.
diff --git a/Documentation/driver-api/cxl/linux/early-boot.rst b/Documentation/driver-api/cxl/linux/early-boot.rst
index 414481f33819..be9d5e510f99 100644
--- a/Documentation/driver-api/cxl/linux/early-boot.rst
+++ b/Documentation/driver-api/cxl/linux/early-boot.rst
@@ -34,7 +34,7 @@ which dictate how memory will be managed by Linux during early boot.
   * Linux Build config option that dictates whether the kernel supports
     Specific Purpose memory.
 
-* CONFIG_MHP_DEFAULT_ONLINE_TYPE
+* CONFIG_MHP_DEFAULT_ONLINE_TYPE_*
 
   * Linux Build config that dictates whether and how Specific Purpose memory
     converted to a dax device should be managed (left as DAX or onlined as
@@ -61,7 +61,7 @@ SystemRAM.  This will expose the memory to the kernel page allocator in
 If `Specific Purpose` is set and supported, :code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_*`
 dictates whether the memory is onlined by default (:code:`_OFFLINE` or
 :code:`_ONLINE_*`), and if online which zone to online this memory to by default
-(:code:`_NORMAL` or :code:`_MOVABLE`).
+(:code:`_ONLINE_KERNEL` or :code:`_ONLINE_MOVABLE`).
 
 If placed in :code:`ZONE_MOVABLE`, the memory will not be available for most
 kernel allocations (such as :code:`struct page` or page tables).  This may
diff --git a/Documentation/driver-api/cxl/linux/memory-hotplug.rst b/Documentation/driver-api/cxl/linux/memory-hotplug.rst
index af368c2bc9cf..df27520b193f 100644
--- a/Documentation/driver-api/cxl/linux/memory-hotplug.rst
+++ b/Documentation/driver-api/cxl/linux/memory-hotplug.rst
@@ -19,7 +19,7 @@ Default Online Behavior
 The default-online behavior of hotplug memory is dictated by the following,
 in order of precedence:
 
-- :code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE` Build Configuration
+- :code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_*` Build Configuration
 - :code:`memhp_default_state` Boot parameter
 - :code:`/sys/devices/system/memory/auto_online_blocks` value
 
diff --git a/Documentation/driver-api/cxl/linux/overview.rst b/Documentation/driver-api/cxl/linux/overview.rst
index 648beb2c8c83..d567353e1dab 100644
--- a/Documentation/driver-api/cxl/linux/overview.rst
+++ b/Documentation/driver-api/cxl/linux/overview.rst
@@ -17,7 +17,7 @@ are generated.
 
     i) EFI_MEMORY_SP
     ii) CONFIG_EFI_SOFT_RESERVE
-    iii) CONFIG_MHP_DEFAULT_ONLINE_TYPE
+    iii) CONFIG_MHP_DEFAULT_ONLINE_TYPE_*
     iv) nosoftreserve
 
   b) Memory Map Creation

base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.53.0


