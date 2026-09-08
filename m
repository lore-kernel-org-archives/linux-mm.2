Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86AC5C79FAF
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8D76B009E; Tue,  8 Sep 2026 11:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832856B009F; Tue,  8 Sep 2026 11:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721376B00A0; Tue,  8 Sep 2026 11:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49D566B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C09EA16068F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:12 +0000 (UTC)
X-FDA: 85191049104.17.005A6B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2CD3410000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJKdL4ri;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883031;
	b=7Br77dWGHVM1VSEZTu3IDUd6RoMuOWmxPailx6+ZWPNOTeSQu0xNkjaEkcfH/ZipRcnjtM
	uFicsIKQQb+4unQ9GeEgke4C+i3xWKlFm9vzYbEyttrPUJM4sNuPPtDNBk7RiQDAcOdDYe
	lFVbRpA8WJFnjMQTxF0MIIRXMTU2qgc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJKdL4ri;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Xk5g9hhke4NmnhJKxFuptmSPt0Ay2UA09dJINvaSs4=;
	b=7aOjzIQiZbVfPD1Zei8bMxdqylAG2a2p/xlmwFv4FoSGWfK/SQrsNKbdSOBluXApNhl4jR
	UZ395od6ga7m3FXbfB9v77/px9pKDj/phTN23GKbkKeBR3JKM4j9yCFbFKEBF4x9duSGbh
	dtR1Fmih8s5tBZwagUbonWt1h5EL5hs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B404260232;
	Tue,  8 Sep 2026 15:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5121F00A3A;
	Tue,  8 Sep 2026 15:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788883030;
	bh=+Xk5g9hhke4NmnhJKxFuptmSPt0Ay2UA09dJINvaSs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJKdL4riRsnh3DhO2GkvZ/ogoKy4cKyEmOvTJglm7Ip96uP51Mz6B+llNdwnkey88
	 LZjxDsVk+bxYDC3x0yZrX+z9K5M8WjQXBHz2A9ZSDLpBDcggVMYJ+W9OeRvRrL9S5Y
	 7O+ISDfA90VfnmJu98usOYjZzwB2elVtj2fC9KDpoG8tgUEdXQyBu0CWNrUuSSpuHU
	 kPym+dsZ2ZJALMPqLE6/XBd+DwP8PhFxyjGkUgYyW7VVCTAAQKmnTorAKqKeWDjEEV
	 yHI92h3lTYDHxB+8tzNmqQsHc0q1ey9cBKFP8p8hpvhYnhWdZpkAUStQjHdaT0XUj4
	 dSX4btIS8Uatw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH v2 4/4] kho: rename kho_scratch= commandline parameter to kho_bootmem=
Date: Tue,  8 Sep 2026 17:56:38 +0200
Message-ID: <20260908155639.2496551-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
In-Reply-To: <20260908155639.2496551-1-pratyush@kernel.org>
References: <20260908155639.2496551-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2CD3410000B
X-Stat-Signature: sim9r18514cd5hkra4oy7e6xctw5wfm8
X-HE-Tag: 1788883030-62997
X-HE-Meta: U2FsdGVkX1+27un1Baj6ZoyUhqUvFV9tKVtfEXAQ/5SS8xXFrSwPOxYHb+w9syWtOsxypV9eNCGh8kh6clyaz9VYeMGzasHOvcShLBi+MF39hJazMKysq1zs9iLO3FLWkxPz3mNsVbeVjObV2Q3MWGoJxGeYoObvJoFjjQsBQzBkUsfpwfc2SfHq0BcuZokS1kyYJHg0/aig/Xzl7xiXdVz9OOsx2aYi9GlwNyUIqWbjKdUK0Gf6yov1kQe0OiFX4gvXugc0lcdA56aSfmexsbksmIs5mX/QrnH0W8bXshqvJRMzZRa865yh3wvQGGnxSdZ8RmYWKb0Y4VWvvcNYsrup2HGWXc3tafkP3Mpflv0dEOcjW607AS0pg5lmQkTvWQrCe/6z80ImDJ+AHOzsexs8te+X7FhST8ZChP394fBXG6otmqqS07RHtwpRc17o4BaaUEHs81TVZkMuil3Tqd+g1xGmfjQ/C6ktA6AQu7E05aOmuCIx2RfIAHZPlc9bwiMuUMUuH9ztx5GsnvVfMJKFzn1LdXPN4qkLLmTVxcEtGEg9cbrFVH6Y05vMxHZUwY3/o2Dx45phA3i+oJ7uxOXTcMllctlsEjorZwkGLnkdMjQTyBqn28dStJXb0oGVpqkwik+v/T+p11i7oWok78DT+q/Kicp42JjYtuL8aNSLS1pOjoU3jnP0qb+GKNKamE4glEluksiHvPkc+t1NdNWyl7Y/PZyvb8r1QPFWlrM+MiUuZF5s1OOUI1tomuEWNs9gMqOh187fp7OAvK/jJSwJWJQhfO9458GW6Sz4kOcFQY48CNeqdzhWBTxAJ+Nr7TQurxZJkW5oxt1EmpMKro8p9Ni7K157DRegxdzjZaSAomnFRDKoO2pUFvqpruOlRN3iOlF5hDHsqzrn054xAbSH5y64k1jDvJ6Dw6wR7rCiFnx+Q1BObferns2lc0yaijAM4CfYzSqLAoWBeYO
 3xNjAGUC
 AqSpTQyYZUa7n0vJj2/1TnDSACEVfmWLcs/29VRAvJq/ruBq2RgjOv7vVfoCmD/SztFfoYtx/WZVcGYZACbQH81o3K0L0QAh18VFm13BkjoSCijIEKBaul0wpphcncLKGR+XNac62p8oeAV5mARDro+yNA/Y4oEgyrMiJTxkjriEILDy1nRRCpHvpYnJID/LJ7yVLbfbUDZ15/M1DQxwChduoG4HJG1Ri5FDZVOglloY8PVtPaCQeRSdN0slrqCXWDETDJZjsm93eMkk07oGk/5jggGxB8zIt8mYD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

KHO now no longer uses "scratch" to describe the memory areas passed by
previous kernel. Instead, it calls them boot memory, or bootmem in
short. Rename the kho_scratch= commandline parameter to reflect this
terminology change.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 Documentation/admin-guide/mm/kho.rst            | 4 ++--
 kernel/liveupdate/kexec_handover.c              | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6132fa73382a..8a42a924f133 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3031,7 +3031,7 @@ Kernel parameters
 			"0" | "off" | "n" - kexec handover is disabled
 			"1" | "on" | "y" - kexec handover is enabled
 
-	kho_scratch=	[KEXEC,EARLY]
+	kho_bootmem=	[KEXEC,EARLY]
 			Format: ll[KMG],mm[KMG],nn[KMG] | nn%
 
 			Defines the size of the KHO boot memory region. The
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 4fae09096038..f14c8d9ad6a4 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -20,8 +20,8 @@ need to enable if you would like to preserve their respective state across
 kexec.
 
 To use KHO, please boot the kernel with the ``kho=on`` command line
-parameter. You may use ``kho_scratch`` parameter to define size of the
-boot memory regions. For example ``kho_scratch=16M,512M,256M`` will reserve a
+parameter. You may use ``kho_bootmem`` parameter to define size of the
+boot memory regions. For example ``kho_bootmem=16M,512M,256M`` will reserve a
 16 MiB low memory bootmem area, a 512 MiB global bootmem region, and 256 MiB
 per NUMA node bootmem regions on boot.
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index fe4b76ff5a2c..7018e25e4eda 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -671,12 +671,12 @@ unsigned int kho_bootmem_cnt;
  * The bootmem areas are scaled by default as percent of memory allocated from
  * memblock. A user can override the scale with command line parameter:
  *
- * kho_scratch=N%
+ * kho_bootmem=N%
  *
  * It is also possible to explicitly define size for a lowmem, a global and
  * per-node bootmem areas:
  *
- * kho_scratch=l[KMG],n[KMG],m[KMG]
+ * kho_bootmem=l[KMG],n[KMG],m[KMG]
  *
  * The explicit size definition takes precedence over scale definition.
  */
@@ -751,7 +751,7 @@ static int __init kho_parse_bootmem_size(char *p)
 
 	return 0;
 }
-early_param("kho_scratch", kho_parse_bootmem_size);
+early_param("kho_bootmem", kho_parse_bootmem_size);
 
 static void __init bootmem_size_update(void)
 {
-- 
2.55.0.979.g7e5102b832-goog


