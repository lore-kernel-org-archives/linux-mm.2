Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A68AC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE3E6B00C1; Mon, 20 Jul 2026 05:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF196B00C3; Mon, 20 Jul 2026 05:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC52B6B00C4; Mon, 20 Jul 2026 05:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99B9B6B00C1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1012FA07B5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:08 +0000 (UTC)
X-FDA: 85008643776.18.44BCC96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C9991C000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oRoTrgBZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4itZKWQME8jwhlzgHXdE8ELH+XUCzY/UCLuUE5rOx8=;
	b=YVQUTgnlc5ujeeQwMcYs8pmngOX9gO99oAkc2fHhWCUUid2DxP3u6zmu5g40XNMArD6XEx
	GmjBc9ueH9jBnw1znYwKXQadHPIhfpGYTNN+hOx9MW12ikxGPLqRjYtyf116VsnGU23H2e
	b1tOWEMgqvjyOfveQF/YzDIG+xsuo4g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oRoTrgBZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540046;
	b=j0QgGPIHooUp2MjDaopgna0I3EgGTeYC8Ai4gTV1VadYPspA6smd1ZUexB8GPWxyz0PVch
	EW7qB5jNvP4+7m/xUor7CmPHB6OBAM8lf+yIb8lM6m7plLON7v529SwcdFrPQJfVyD6zlE
	7rOaaA53blfTym9hmOHsx9g+u+Bk1Mk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6B3D60103;
	Mon, 20 Jul 2026 09:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF711F000E9;
	Mon, 20 Jul 2026 09:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540045;
	bh=F4itZKWQME8jwhlzgHXdE8ELH+XUCzY/UCLuUE5rOx8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oRoTrgBZPFtsB54X1XUeaOOhvGJlOE1ogUwA52KlsK/cRgu5W9tXkCYkheS9qW888
	 1EnZWIGAq4NvQgMRVkvct5/3yrt3ls0u4qcAEqpCxFrfgPEr2MQlHfPvhz1cVBDr8S
	 gQ3HOHrFcagVkOsgphdD7clxfADYmyKCVBQzv1g9NJ7wZFhzQPdFsW/F1O37PwYTeM
	 w3imUNEhUN+m35QKkrAq5air73Lb4rNSE+PDDIXLEHDANrYOkRxgCGdFGj3yX17kxa
	 KZ9GwBcunDbc66c23nUU7IT8FizNVIiUwdY76P5xE4SOc27RUK47emzFVLVxRIJ3bM
	 eHwcp1p1IfLXw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:25 +0200
Subject: [PATCH 02/21] docs, binfmt_misc: keep general usage out of the
 handler sections
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-2-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5004; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2Dmgft1OiugYUN2xyA/RXN0gIP7maCn/2G4x9cjoFwg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm40X7L1b1+9ybPj7y9eOdV5KMBbZeKCHDZOxiC+6
 RztHgv2dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk0pPhf7zbA81D/brTWXdw
 PNxpm9yt72jpntofcUH2x/e9X2WXWzAy3CyJ+TA/4GC1xoPmxDNFM55/fbF6tsBMFYcVAv06tlI
 5DAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5C9991C000A
X-Stat-Signature: 75wws6sggxqz8inhsk93e4sp6rk3euod
X-Rspam-User: 
X-HE-Tag: 1784540046-358633
X-HE-Meta: U2FsdGVkX189vSuIc7HMVrrAspo8hA5EFSlJO3mQtP+msWPxTa/FuBrgXyedLbG1X3Ub1lVpwQkF/wt4yPGOmZNqm+4UrHyqIAovAjKtSa4t8UEswTEoizN25klgzM6MaJodfFmATsGpBBIknYZ6R2KCz9WcyUl7EEpknQJFCUdHgVzEbROVm21V8QeMycZuay6WA9hZQnhWik5m0zSTyK4NX8o5u6qMr3rlL+X12Jcggq2iuLCFGuSMYFNrXyFnmlocZ6RTQA1NGgsa6C23UtG/NsbI3a2okbyBr7FFlXQinCvl84N3NiE4jMJnB7s7xKNRo3Od7sQppLr4mwLIQY1nIVQKoRpMuG1Fmni3qNEBMMSa5t5PLh33jJvwnRoG5/he+wYTK843mpbWlZ9xmQiH0zeTb3+JQb5dLKAYJNe6DAB/rSACEtFnQisbSJSwxKoU9D7o0BM9uOBQ6prfPRLyUVj0+gLfOA+LiLTTjkPwU3Wr1B2KbHZcaNA11fPWKagCetvGxCUmJQzAsMkqlSH0ZYNj/GRWtWCdbyJoMCDYeSUhYBtMBYcOX8Ivzs6BDNC5pK5YKIdU6WFEr6n2Bk6bGpifcEEmsYnOaE4EfDCmJ8AVWv561arcf177rpstbZQGVRBgkXrKnobKJ4RFbe/S0Fub7SXMBYgE2QQEEfIuIGN+A9jh0iF/6O8WZjKswNIhVw3Gm8TrLDg6EKbMy6xlpSLFd9QG9ieJ5jdYwjh0e2h9DU8mqOeCdRsEKJSjqu2sWFsIQoag3v/0VlTNPwSAqrv5fY2AVLClHxdkTZWxmvOAVk6uSlUAJtTTDrUbkKxoM91cG3dkXYMxSSoqAW5gmftSESJSr5rgAMDiFb6sRseuKDpCvtBM4rh/Fuhwvnf7LA1NJZuZEhRf19m/aBw+Hq3U1aY9w8mzhIFHttDCctmjfxAzLecdGY6TDz0L/4LoatWC1eXNk/FQUCt
 n0sq75I+
 hFBfDV8JbatkVNV+tg7Vj9kFLLa4Wt7/UkQ45LTiLLCw9bm7uhFlzgGNV14OyOXlD0kLl2n6MKIZ5t4s8HVnl9F2Z/XTUnZ5xh3qkGjkUHUuGReSegIp9oue1V6NKz9OdfLuwTh1DqA2M03w7O7p15W9LyGU4woZepkSJEukY7hVBkJO6QxxHHJE+638wMy7aaU06sA4Rn5D55l0qVg/hOLjFBNoRTUk3UzmVc2AGj5MrwFL3R9OZJe62YUSNg6OW7pbIfL1Q8ftzw64MLzGfPUTx5pJEPDPFepj/WhjJAZXXlF1pXZjoEsGV+c6u7EJyxvVXLy6mwG267l7y2I3NjaDCcqsH+u6ps1RiBe8JeF/8Ra8Wq4NovNV1Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The general usage trails the bpf-backed handlers section and therefore
reads as part of it. It predates that section and applies to binfmt_misc
as a whole.

Move it back up so the handler section ends where the file does.
Upcoming sections describing the transparent and loader dispatch modes
append after it without swallowing the general prose again.

Pure text move, no content changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 79 ++++++++++++++++---------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 7f42abf9cfba..c76381a4bcad 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -100,6 +100,46 @@ There are some restrictions:
  - the interpreter string may not exceed 127 characters
 
 
+To use binfmt_misc you have to mount it first. You can mount it with
+``mount -t binfmt_misc none /proc/sys/fs/binfmt_misc`` command, or you can add
+a line ``none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0`` to your
+``/etc/fstab`` so it auto mounts on boot.
+
+You may want to add the binary formats in one of your ``/etc/rc`` scripts during
+boot-up. Read the manual of your init program to figure out how to do this
+right.
+
+Think about the order of adding entries! Later added entries are matched first!
+
+
+A few examples (assumed you are in ``/proc/sys/fs/binfmt_misc``):
+
+- enable support for em86 (like binfmt_em86, for Alpha AXP only)::
+
+    echo ':i386:M::\x7fELF\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfb\xff\xff:/bin/em86:' > register
+    echo ':i486:M::\x7fELF\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfb\xff\xff:/bin/em86:' > register
+
+- enable support for packed DOS applications (pre-configured dosemu hdimages)::
+
+    echo ':DEXE:M::\x0eDEX::/usr/bin/dosexec:' > register
+
+- enable support for Windows executables using wine::
+
+    echo ':DOSWin:M::MZ::/usr/local/bin/wine:' > register
+
+For java support see Documentation/admin-guide/java.rst
+
+
+You can enable/disable binfmt_misc or one binary type by echoing 0 (to disable)
+or 1 (to enable) to ``/proc/sys/fs/binfmt_misc/status`` or
+``/proc/.../the_name``.
+Catting the file tells you the current status of ``binfmt_misc/the_entry``.
+
+You can remove one entry or all entries by echoing -1 to ``/proc/.../the_name``
+or ``/proc/sys/fs/binfmt_misc/status``. A single entry can also be removed
+by simply unlinking (``rm``) ``/proc/.../the_name``.
+
+
 bpf-backed handlers
 -------------------
 
@@ -157,45 +197,6 @@ registered in, falling back to ancestor namespaces, mirroring how
 binfmt_misc instances themselves are looked up. The entry keeps the handler
 alive; deleting the struct_ops map only prevents new activations.
 
-To use binfmt_misc you have to mount it first. You can mount it with
-``mount -t binfmt_misc none /proc/sys/fs/binfmt_misc`` command, or you can add
-a line ``none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0`` to your
-``/etc/fstab`` so it auto mounts on boot.
-
-You may want to add the binary formats in one of your ``/etc/rc`` scripts during
-boot-up. Read the manual of your init program to figure out how to do this
-right.
-
-Think about the order of adding entries! Later added entries are matched first!
-
-
-A few examples (assumed you are in ``/proc/sys/fs/binfmt_misc``):
-
-- enable support for em86 (like binfmt_em86, for Alpha AXP only)::
-
-    echo ':i386:M::\x7fELF\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfb\xff\xff:/bin/em86:' > register
-    echo ':i486:M::\x7fELF\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfb\xff\xff:/bin/em86:' > register
-
-- enable support for packed DOS applications (pre-configured dosemu hdimages)::
-
-    echo ':DEXE:M::\x0eDEX::/usr/bin/dosexec:' > register
-
-- enable support for Windows executables using wine::
-
-    echo ':DOSWin:M::MZ::/usr/local/bin/wine:' > register
-
-For java support see Documentation/admin-guide/java.rst
-
-
-You can enable/disable binfmt_misc or one binary type by echoing 0 (to disable)
-or 1 (to enable) to ``/proc/sys/fs/binfmt_misc/status`` or
-``/proc/.../the_name``.
-Catting the file tells you the current status of ``binfmt_misc/the_entry``.
-
-You can remove one entry or all entries by echoing -1 to ``/proc/.../the_name``
-or ``/proc/sys/fs/binfmt_misc/status``. A single entry can also be removed
-by simply unlinking (``rm``) ``/proc/.../the_name``.
-
 
 Hints
 -----

-- 
2.53.0


