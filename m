Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58313606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SAWHU8ST
Received: by kanga.kvack.org (Postfix)
	id 1115F6B05B0; Fri, 27 Nov 2026 14:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1976B05B1; Fri, 27 Nov 2026 14:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1B56B05B2; Fri, 27 Nov 2026 14:02:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2D036B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:02:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FAD41604A5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:02:14 +0000 (UTC)
X-FDA: 85481819388.23.80F5030
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id BCB3218001E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:02:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SAWHU8ST;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of takano32@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=takano32@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795806132;
	b=YizQtPPN7/5jMDx1hPmY/2tXzVqW+FnbG6bKDhyp1C75DZz7E6LFgP5k+fXF2oX9mO1unj
	Lc9SzD6gFpRoyqUTXvbdtOxad610Hw9/FBxNii87dvywSY0nWKq0YTvSPRshjaWsD/ui7C
	v5n3uvNoI9ek6NEL55uw3a+gtbktfoA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795806132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkQBPyKgHhzReYEqUfH52eqklLDsrHQN3rdcMHP01SI=;
	b=W34KAZMjvJqcbEL90rOYwc3EYyqC2Q+hKh+GzvTWbNabw0lzWNVtoCLNynhtLHYkND3o8Q
	EkAiV0CF/8tHK5RJ2raoWBSRX1kHghrUIdBrOzn6fk2UAJbtCO+rkR7O1CVh90tglEO4Q/
	Cq9Lg8hKPw99rZzdgmBUYf6b2FMtTI0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SAWHU8ST;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of takano32@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=takano32@gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1aefd1bf74aso4777211c88.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 11:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795806131; x=1796410931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zkQBPyKgHhzReYEqUfH52eqklLDsrHQN3rdcMHP01SI=;
        b=SAWHU8STjUQsfAKRZxZD/ZWx344+hoQC1KJYr+paj8ugJlwM9Z4KKh9WeQox4oBgml
         X76qqYHAyTOY/XB+UNFK+h9S6J8bRJJTo91qpP46DSh2Ts8T6kKDHZoEClt4FLlKX4su
         moI8dpgJObihy1TK2q4/uf5W/SavqdmXNpTFnzm6Hi9Tu8q4r5Aqr9a0qXvtTVVS/AgW
         mfdZciWZKm+HfMygo74FukzynK497QXRuipDOMYNasphFYp4ogv/eReCD7TLQ901N+JQ
         JdnWohs7R+ffxaz+QeXuAfPrlgoiXazS1LoIdQs2XeUkaU0RqbzF6yexo1dfaov9fDWa
         x6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795806131; x=1796410931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zkQBPyKgHhzReYEqUfH52eqklLDsrHQN3rdcMHP01SI=;
        b=qp/s1X5YY4bTdNQKKkOj0zRYcaMnLJ4Bm7qG6PnyUsa0SS1M3YHQM+BsZFVWIqdjOC
         4b64TRdEqilfVKlfEDh2aqMKca0AmXi4y3YRoqlk7U4U7tU57UGOXK3DrGVO4W9C8F2p
         sz5Q/eXM3fbCrtZgTwFzW/JNre5RuKxhkDWC8REhbmwxKuJ5WqqIoC/B4SFZYcxnjaQ2
         Kc89KlrI1A8ZSR9xdGDGn3x0Rn0if4IV3rEFsdvkMiybrRWDTsQSSjQ/d3Zg5KaInlWu
         W5Sv4SM3OqBtlOBIQ0nBgyxlXLYTIofjEcc2aj7NCtwRmXTc3v0ovoRTGrsL8FDS4G5e
         zLGg==
X-Forwarded-Encrypted: i=1; AL+hErG3i9gwKky1L/Y1PvKYF0zfkZS+DHSviA1Kmdthk2p/Mo2IX079E0eRnw6VorRoDTNF3UOjBD8xXw==@kvack.org
X-Gm-Message-State: APuU4Z+LobIaoCizbkRZpoCPsmqqESJI6xoVSINa6ZDuvxNuaDb8BS2n
	4Mv/qMN9g+eq/3cNIjO7EN6KKyYRV9Z8QBaRLcC5SlzBSxLUeof3RCaB
X-Gm-Gg: AZFdTZdYkd/p4dxIWAWpR5LFouqKbd6nM430oIhfiIKV9v6s4ZmHfk0qFW42xESJd4t
	M4al2hyHaMmvRv3s5K7qqF0ic3EgbAKVeXoWxyuM0lwRNffbsgNYXnAgUvf/wVDB7ppGkVppcqU
	NED8GXw24mKjfcsR4fkwUD+xz4CScztCPSTjosfqW6lxbxEs+o/sfvWYojqJv9huxhQnAuVUMRu
	Esdnhtq4w2gg11IdZZRze/qL1cI53Ipife4brvtQcGUSibEzVlZrufYXZzSgPYPsY2EgbdyeMTv
	oKyEy6KtPfA0y3QQfXNVSrJJ2XYJufLiD4JkkOT7cSyy42D6HLtNKghygczbhtcy3UFw1+oFLyp
	t7jbzrLScRS8MHZ5UVNvE0a3oAJtbkhLUMpAuJszhXBfxOxqveJ3Olk+JHb0PPv5j/GvwTVz4/l
	YA2/HJvvoXKzqv0w/vKhoJTnkZMAv6iF8dgz603oRUSK34ciQ5KZXvyKvDBhxwL15CC5DXqyolV
	xKyvqws5M+4rES4hi4XxcnX/6kRybHwFPclPOgGf5xxWRkYPC0pgj7vHi84fQgkyOhoWfNK8wv+
	QUEmeRbReK4xMBibCPs2
X-Received: by 2002:a05:7023:a41:b0:1b2:67f9:43cb with SMTP id a92af1059eb24-1b5525e786cmr25527192c88.17.1795806130946;
        Fri, 27 Nov 2026 11:02:10 -0800 (PST)
Received: from a1-free ([2603:c021:8021:f000:0:1865:8c38:18fc])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5566c3052sm58116574c88.1.2026.11.27.11.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 11:02:10 -0800 (PST)
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
Subject: [PATCH v2] docs: Name the memory hotplug online type configs that exist
Date: Fri, 27 Nov 2026 19:02:07 +0000
Message-ID: <20261127190207.245175-1-takano32@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125193039.2437025-1-takano32@gmail.com>
References: <20261125193039.2437025-1-takano32@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCB3218001E
X-Stat-Signature: bafrd68iakcdf3u8wojdcokphgac89jj
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795806132-289768
X-HE-Meta: U2FsdGVkX19pWNT6JH94jkFUXO2WufdOO/kqfecXnXiaDYAxC83v4qZviCzdD1w16FT5ZeWZictpkdxFl4+LMz/OSiQEZB+pAVThO6VcHpRxbOgrUTSVVKFzQxGrJ91FR6j2PBqkxvfBgFYfcxHx0t+pKUa84mLDBnxaCHoBynCZ14M8ZSdCYFQuXcLRd0X7RhZJ7cDwW0kZ8zvpIUjiMtFx0ulwnWUfxLqziZw8CGo3vbEwGP2EK8VT2nIrmoAjjdUHkKDWb3EatwnSDjpjhG+KYlm1yf2eNVWot0NaQjCuUsgDiUEUmVGPhEFRWgpujBpu5y5nzhEEwWdM4zCVOqFaSVQZZ6o2/rrDVyr20ypPk/B5sTJAT1gmuB1izv1krPyT90Jvi6JSoEhgQAdcrvv0g8Fcik6Kv2aC2aQlfpJyAd/rWqefCFzadQ+A+LAcWYRbpQncX2zdr601ZenxPF+MlGcMCUbZsgv7B8EgK62gJ7G8Nic+Ky3Di5Ih/2+3Yon5GYoFD9dj8sFZhncHAyw5CVbLLNeBriVAHAjPZnLJO55Q9sQYb+FLNxQjaNFUs/DFVLZZhcrcyq3gHL2yfaU7ZeghJ0rbk78GNyCCXaW74uFuOX2R1xlN64dukuwySw+fr8qtG3AVLerc0Sohb+EI5tf8mf+PF2NEm4Bfj7H0tWbtJmjqipye3tirMt70qpC9coEoZLmK4yof5dEfFVBhTdn/dnIDri84LOdM77MFcBZSVK8v0DzEH5Dz//6pjr9rsJgvZ9Bx/7S1oKsfxaZf1hyqfRRtS8c5U0DFHK14KA7nF4mB1kXWBz9qpwzMcpmSagzJNHe5vvrdmjSFF5kCu7yYNbFfDZA0zEC+GpdVrceuq2vrgylfFIzHZQdFR2gVQqDxkYU80lJiXSip5YChJsBH9Xl1tl4wcuFucj8mzdwi/E1BQMc6cuLhy7yCTPg8SxwRPw9Rq1BC3Ph
 uyj1R/64
 WgVL1twVtTGIZkKfQX7Z9eSRazZ7iJPfVBVbc91rjzBTR7bEBzaxykjoaTbUS7JyszpUR7wygjK5RXj9qo6NiwrHy1HjflsjL4+S5R4soP/jkcqiXSxfoKcO1QcbU26c/BTgBdqgEKhSGkx+ovqG3PFbX5iw5hF2/iQ+iVVYUhdtXbdRwZQlySDGrhq6Yp0Lepem3Jh5z/WN7YbBBdE12xdTxewSv0eHAgeyUqwMYdqpXxiB8biy3xMDwgQBgW851+l8nLKCnnktB8sdta9fkU5WJaZuNTadM/cE19BMRrm8bVcVJTe1/0a+6V3eIUpHyNWOkV4MNtS7UlHLp6kub8T6mKhrNdzxoZbUjVj/8ChMIBulJIa3clbLofgVtkq+1pjkC08x5/Gre5HTNAzzNZ8rl6kgHaDTt4Fr3hE4FsAQHurDm7uJofk1smEHj/U9GX2HlMDzBZsYU8JB54do1pT7zPq4b6++uGijFIYXbcHtziWJkCDXsHKAIMKpKTInOFE8sDHFn5BNR8MIJi0WvVXjjqxKZVRHJBguLLwwZPz1ua2v/ZT11H/mJGN9UpVXYTT/pfC3QqRroCstvM/44q/mLnGNiSc8WcnzWbb1h0VklXXPyNur0mi7qxx2q3I+v20UI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The default online type is a Kconfig choice, so the symbols it defines are
CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE, _ONLINE_AUTO, _ONLINE_KERNEL and
_ONLINE_MOVABLE.  There is no CONFIG_MHP_DEFAULT_ONLINE_TYPE symbol, but
five files name one.

Where a file lists the config, name the family with a trailing _*.  Where
it names a choice value, spell the whole symbol out: early-boot.rst gave
the zone choices as _NORMAL and _MOVABLE, which are not suffixes.

Verification: a build of the tree defines
CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE and no bare
CONFIG_MHP_DEFAULT_ONLINE_TYPE in include/generated/autoconf.h, and grep
finds no reference to the bare symbol under Documentation/ afterwards.

Signed-off-by: TAKANO Mitsuhiro <takano32@gmail.com>
---
v2: Spell the full config names in early-boot.rst.  David Hildenbrand pointed
    out that CONFIG_MHP_DEFAULT_ONLINE_TYPE_* with _ONLINE_KERNEL appended
    does not parse.  The other four files keep the _* form because they list
    the config, not one of its values.

    Written with Hermes Agent, an LLM assistant; the author reviewed the
    wording and the diff.

 Documentation/admin-guide/kernel-parameters.txt      |  2 +-
 Documentation/admin-guide/mm/memory-hotplug.rst      |  2 +-
 Documentation/driver-api/cxl/linux/early-boot.rst    | 12 +++++++-----
 .../driver-api/cxl/linux/memory-hotplug.rst          |  2 +-
 Documentation/driver-api/cxl/linux/overview.rst      |  2 +-
 5 files changed, 11 insertions(+), 9 deletions(-)

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
index 414481f33819..c3a3def3b3c6 100644
--- a/Documentation/driver-api/cxl/linux/early-boot.rst
+++ b/Documentation/driver-api/cxl/linux/early-boot.rst
@@ -34,7 +34,7 @@ which dictate how memory will be managed by Linux during early boot.
   * Linux Build config option that dictates whether the kernel supports
     Specific Purpose memory.
 
-* CONFIG_MHP_DEFAULT_ONLINE_TYPE
+* CONFIG_MHP_DEFAULT_ONLINE_TYPE_*
 
   * Linux Build config that dictates whether and how Specific Purpose memory
     converted to a dax device should be managed (left as DAX or onlined as
@@ -58,10 +58,12 @@ SystemRAM.  This will expose the memory to the kernel page allocator in
 :code:`ZONE_NORMAL`, making it available for use for most allocations (including
 :code:`struct page` and page tables).
 
-If `Specific Purpose` is set and supported, :code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_*`
-dictates whether the memory is onlined by default (:code:`_OFFLINE` or
-:code:`_ONLINE_*`), and if online which zone to online this memory to by default
-(:code:`_NORMAL` or :code:`_MOVABLE`).
+If `Specific Purpose` is set and supported,
+:code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE` leaves the memory offline,
+:code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL` onlines it by default to
+:code:`ZONE_NORMAL`, and
+:code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE` onlines it by default to
+:code:`ZONE_MOVABLE`.
 
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


