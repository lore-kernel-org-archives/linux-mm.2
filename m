Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03808C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAC36B0093; Tue, 21 Jul 2026 10:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A8D6B0098; Tue, 21 Jul 2026 10:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0BB6B0099; Tue, 21 Jul 2026 10:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5E8C6B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 603A240186
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:36 +0000 (UTC)
X-FDA: 85012979352.09.6880E80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B2841C0004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3rXtkLV;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643274;
	b=6/pdLV4q9ofp2WwoUTY/DP8/UAUJqaWps3a3PBkElfL2XMUVmjrOHaix8u3vigTnVFTU3b
	ynxZinzLMMktDylQsdDjKsPyOXVm4dP2Ki86ate2Qmt/Yf8SiQgQyzTFcTueDqAhqSIyLc
	JB8YAtrGoTL5QOTku0pXbtQqEGFXmnU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3rXtkLV;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IySjUe+fekqEUyus3KN/ReQzmr0jzl1UX4v+5RczmKM=;
	b=v+pX/kt+ZP5Ch5R4E47VvoAWLxqFl/2GoU3pHLsFTBReNQqT8z9djhPUo9GiYp7SzKV1Ec
	EWw9Q7RaPqflw9tVX3EV5PGN/VxI458HHsNdRTwBRCsazHmv5rHkhNKMNECvXD6kAOFp4q
	zVKbVFfWpkRB3rFGtkY8GLcG8kcuUvc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AED7600DA;
	Tue, 21 Jul 2026 14:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B621F00A3D;
	Tue, 21 Jul 2026 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643273;
	bh=IySjUe+fekqEUyus3KN/ReQzmr0jzl1UX4v+5RczmKM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k3rXtkLVUYH+tX0EsEcvwjEF14GVctfc1m6YTs77MSVGa0JF/YACJkHEXM83v8MGj
	 o1M3j8M01rePmmJmj0UjyN0Aq57Lp9BLSjV4DAL2WkaENCsPiPoSiBYjdPJPINXAWc
	 AuaPPcZdgj0m0p2qenKaYdrS5NkvxX4SVZFrJZU7XLnmUVrUZ6o648UYUUZJLbuUWf
	 d4s2I6QJAwN3pmwpbHr/eY23QtRg3Lh7Wr76uJ6YA2QG9aNCKvTpLIvh3DHaj3nYsi
	 oDjZrzf4S57TvlV7ascEoskjwcGqhNKYKWRHEHZY85xBIbrUN2JRmmqqE+1vK3rIUP
	 9QLuMGfuNEG3w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:44 +0200
Subject: [PATCH v2 02/21] docs, binfmt_misc: keep general usage out of the
 handler sections
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-2-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4962; i=brauner@kernel.org;
 h=from:subject:message-id; bh=pnQ2H4ThUkWl2NY2YaCVOKuFwWPtz/Wy/4Hat7E6A2U=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1+3/6Kh4dh/H9i1bA+N/C8jF2C77IG2Y8C7ZsSZ0r
 7a3KcP+jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImk7WX4X3tx+zE2piV6AQc3
 Wx256dV0lCVg1QQdfpflPMsK8lbfus/wV1yzraKoeI/OVdNlHJ7Hzh7SZzXV9ZfeqvlaYtHy3RY
 3mAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 786je843gahccxh4fqwxs6fureu37bu7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B2841C0004
X-Rspam-User: 
X-HE-Tag: 1784643274-608161
X-HE-Meta: U2FsdGVkX1+beJG73dtamT4RQ9GMS+yvt4DLpsPU4YTf82jgHSLuq7Mk3fFSxHp2e20gJbxgFOtIz5+N5Z9nSjQMLexEJ03Psb22f8amVZneM/TbmY/iksnJLZqKG2dxuEndUH3vutxUkEcsEMFhqLkhtLXnKsQeGpxGIZvV2httq+DgM72kDhf2TTwDc2tGsyjKRhVLDRDHM4Ir5tkerWiKm/aWltsHTF6XiWTDKsicM4dI7FY+yxYvoFl26/JtD0791G1YklIJXsMzfZ+ffM3nfjTAjqfjI7bzYHJVDfH8K/ziVMNiClYaoyghvTn7guho8v2NU1WZUlvGqKyeb2/r18w1UwsXrAtVnVrJ1lcMPPWrHAxDU4EX6OtTIJ5bOZ6uQdRrOcipt01HR0tuAGu2wskobjWmdvGzHO4jwmP0ZooV0ulYypTHxWC4XMiumVHacKjK3rZxTHZbFStfezLdk0bJRGzViilEfw61SxJLS9Sy96ccapeu3zxXW3QdaxpE/nCrdGRFv8SMhtulgIaoeyj+6Xag3sGrLJaVjL6oYdsFJRWYiuSQVSeaF6R24AoVl8xYJ43MiRRoo5cJ6EWgfy1LLoQSa7/bG58Di4wpPYvkCSMHlNQn7c+z11XydunvnCOFUr67pL4tfGO0y0q8ucTCXIUVWT1pZ2RHYNV/POJtmDFYOckTfPxPVZCoIRIGmqdL1fOuiZVtHy7Lx8hKpSK/o5XCyDE/Z6nggeiZ9O5/jqHymcK3Sbkbb3ije+kVaPuUqqmsKIxFda8LB7eJHMd9/xAPM79NQlcuDol3F8qQjhFuGhI61umHsN7gBNq8GPSg6PLEn/ZxGHz5J742M1F7iGjhwB91KqufD/hlh+jfDBCiCD7BmsiLZcpUsTadFyhVjR6RIuP7dAJU21+AcTxkH5jyGy1JmWX9B1xTBSuLKs/oJqEUcBdpEMhkCctf+bVl2mllxN8vZIg
 Tnm6NfBi
 6Q6AHzduOWf3/RWVBS6OQntwOp+arokUDdn24PhIphXeEfJc8kZ824LuZ+y+1qBQ8OuD2Fy6v8zVM5vSi3ppleSxVwH8/EFnqWkYTCc1BqfN7OMDsNYXiNqAqBnjJhbX+Uq9VSDPmzwuDcW/hYt/ZlXmCWuC53YSOm13k9Iy1r3cIVbmIXIIXIjhS54IzFdTY4EnRgUJC2CtN1mGzgNl1iRry9H0OC7Js5a/GYABakciKVM4HQ9GS7IC6NFagygCBfQCdJmeEbsAAsAlXx8xFEcwYZRAd8ZmcfF1SBN3SJOAX74SVr2lLG3kAXajB8vOPpbbXACkVJBLWDMKn7HfoqyXCBs3L8t9DuMoCbShLPa/KWU8fIwo/dHQC4g==
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
index ce94c8c36534..d689f21858b2 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -104,6 +104,46 @@ There are some restrictions:
    the binary
 
 
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
 
@@ -161,45 +201,6 @@ registered in, falling back to ancestor namespaces, mirroring how
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


