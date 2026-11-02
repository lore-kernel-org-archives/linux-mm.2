Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFFD60A380B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YOWLPPUc
Received: by kanga.kvack.org (Postfix)
	id 70E306B05B4; Mon,  2 Nov 2026 10:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E57F6B05B8; Mon,  2 Nov 2026 10:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC0B6B05BC; Mon,  2 Nov 2026 10:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 402506B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:01:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D37FF8015B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:01:54 +0000 (UTC)
X-FDA: 85390493748.23.7575721
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E25CE20014
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:01:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YOWLPPUc;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631713;
	b=nVlWB8KJnnijl/2vAJLQNhI1aOnzgMsIEA5lVNlAA9Ltm7yBo3e3NiyFYACqFDDdwBH0vO
	keZvs3UtJHr9jnk2p0aRiQuV+RatSL4iOBakSr+DYo4lWAWseQWjFVGf+efXiv2oIBtnKV
	QUaN9UgBLpd1CJqGKdFmmWsKlQmrmFc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YOWLPPUc;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlEo6fn96mUnyTcuJ21lm8IttobnLYkUxU1xN1s9Clk=;
	b=sg0ITuAaG0NYR4VnhqwyzJSdKP6Sdk6j8chwNlHHXuJWCS72mMrd7W7/y0aahFjNK6qg6j
	VWDEbt7FUft5uyH9Vb9h8sdYdQbsRBV9FG1Gs4Aagyi4d20P9N04Ipx0GIVwhVExHBfQoq
	zxwgRHYeci5j15JOGXN6JOT/E7gOKMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3766C4338F;
	Mon,  2 Nov 2026 15:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E2A1F00A16;
	Mon,  2 Nov 2026 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631712;
	bh=MlEo6fn96mUnyTcuJ21lm8IttobnLYkUxU1xN1s9Clk=;
	h=From:Subject:Date:In-Reply-To:References:To:Cc;
	b=YOWLPPUcuUW7Xf6bkKIkwoKEYeMJXR0aKMhcpxZgGeRCmQIE8OTk0OOuLjBO+lTlZ
	 aCRJLJOxnFGi0EZVv5PQRHGWEf7GenLoXt5kcnXUTVcN2/CklJW71YNSttC24ogmBm
	 pv0aglNoFoXF6+OgIiZw7H1Mn4jH923BkJ4BHHUD8WNrtVpCSlrvO7VEg5Gh1FvPSo
	 a5Lb11YxDv2NNTwH+4aBkHJjUZRPGb2i4nKY4AYuJt6E9RuV0FPE595+A7dvq9GBSI
	 lmzMKuZ7n29wloi+mQikRoh43R97U0M+8peuFNqB3sNEugmFyLQaMGsSlK1afxQ72b
	 1tVYIAQwoMcLw==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 00/22] proc: convert the arch and platform entries
Date: Mon, 02 Nov 2026 16:01:27 +0100
Message-Id: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22OQW7CMBBFrxLNukaxY8I020ocgG3Fwh6PGxcR0
 3GglRB3b1wQqy7/1/w37wqFJXGBobmC8CWVlKcl6JcGaHTTB6sUlgymNb3WrVbfWQ7qJJliUU5
 oVBisC2zRc6dhmZ2EY/r5Q77DbvsG+3tZzv6Taa6weuZdYeXFTTTWqmJXd+yKsvCDJPx1XpzmB
 +6pNDT/CtWlwuiss9FqQ3G46OczysdjmoemX3uHsbNMiD3TxnhD7SYEQopdQL2mzmD/GmB/u/0
 CF2pWcCABAAA=
X-Change-ID: 20261101-work-procfs-arch-8d4ade48be31
In-Reply-To: <20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner>
References: <20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Stat-Signature: uwnm8twa6hri1e7g6j6kx4dtpn9ky9kf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E25CE20014
X-Rspam-User: 
X-HE-Tag: 1793631712-133029
X-HE-Meta: U2FsdGVkX18gSI7U9ETq/+xmhQoRoy4pEk6W3XNDYhTUDmOwXWlKL/LrnxhHEQbpWfg4wWThnV3UIt6H+Z3Nl5kU5COGQ50GZaF/QbGy8N0ZndeMf15RG4UTeLFKaLT+aY0YFX+CLv1fep6sp+f4f9RVn0hIhxZitVHltNKCSDthQh5cLTVqUumiVwdVTGQCAhm0U8UQrHYKWL1dDRyqZNXOI/skljdCbvPIsQV5Lbuc1AAvzC+AdP8xjc8eLrqIUDnKE1CW7mB32bTdJRCfSMyWfDPY6ARdDbqObkeQY5jNEC450q/vQiIbSG4/5XAtE8qSx6mfaBmIUoteTqBqqAxWfKXrY9EcJSrIhz9AtM51cwObp548ddqvJsJUCOOCZrT8GbXlBC8p66jMRcmayRvKpOVKahYzfK8xQlumppnV4grX5y3pLOdyKp/X1pAVtAMzXrTUJGoAREzECLVcBcGRcLDfR1Tj/0SWtBZKG8Ljbn+ziYs/yJM9zIeRBAnfBPAUs9B5bkE5NREnJsu06tEHdVicf9rhM3TWFdMLJZf7fZEf03L76GyY2tl8fWbzt6WlqEsF+dIzbSp734uTKuvYq3W/91Vfe1cqcneP04LponTYcIByimLBN7trBBvyFUl4xr/aGGYV97se7MX4sNEiDGskD9fkKupuUUfSUFH25Hrse8Ppsjm6LVOUsn4k/mmUh7UzI+Bq6MeCq6kHHEjATMsCYY1nYJMHveI+c0Uj9XUGtZwMxAnguBg9cOcBY+6GZt3RpED8XwTrYE9WhrFHYKkPvYqqnsrZVAqZBakjNvtPstH/Z032ME0fzxpAmVHA01Q/gKuuGcp4VRTHXlDNeCNSIcJnF3BjHk/ke3/IpbLKkdnkD8L0qzrPXDZgdirx3eZXqWPsi5f2vewTsLoatpL2Y+hTDFxVdD+218lT2r2lPQZocuUWBmuiDkAMFm/9qsiEUo3YIhbcE6+
 P+OQN2wx
 Ew36tZercOiya/0ZzeOFa9FrJqWD9M4/ELawFpX/auXmZ3+TUh1wSh3YQpeF1vQUY37mU2O+js+dGs8ROp9lovoITPUKS1tFacfD1geJ/oFnqKXkrEcU51MpOJHmg8KZrXvihKuxFupY31/uJ9EW/06Lp77pEpfz/jR8GPERa4jByGosIkwPzqSO69eH62ndFZ37ynBblR1YaPP048NfXN8oya+GvyEFV9IY9yoj3TC1DEHyMxIurfoOPCn3foHK2Wda10L8TGUIlQG2swZ99jq8NcsrQ5VL76w7L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This converts the proc entries under arch/ and the ones of ACPI, the
platform drivers, via-pmu and PNP to what "proc: let procfs own the
data path" set up: procfs owns the seq_file, copies in writes, copies
out reads and copies ioctl arguments in and out, so the entries' code
only ever runs with the entry pinned and never touches userspace
memory.

One patch per subsystem and method, in the order seq_file, write, read,
ioctl. Most of them just stop copying in or out themselves, or switch
from kstrto*_from_user() to kstrto*() and from simple_read_from_buffer()
to memory_read_from_buffer(). Where a write that is larger than
anything the entry parses now fails with -EINVAL from procfs I've called
that out in the commit. The rtas flash files take their image in 4k
pieces and keep doing that with PROC_ENTRY_SHORT_WRITES, the rtas error
log is a stream and hands out a record before procfs copies it out, so
a reader that passes a bad buffer loses it. /proc/mtrr's ioctls are
table driven now, the native and the 32-bit commands share one table.

Build tested per commit on x86_64 and with W=1 on the touched objects on
alpha, arm, m68k, powerpc, sh, sparc, um, x86 and xtensa. The entries I
could get at in an x86 VM behave the same with and without the series.

This is on top of "proc: let procfs own the data path". The other three
conversion series don't depend on it and it doesn't depend on them.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (22):
      alpha: srm_env: let procfs copy in writes
      ARM: alignment: let procfs copy in writes
      ARM: atags: let procfs copy out reads of /proc/atags
      m68k/bootinfo: let procfs copy out reads of /proc/bootinfo
      powerpc/rtas: let procfs copy in writes
      powerpc/rtas: let procfs copy out reads
      powerpc/pseries: let procfs copy in writes
      powerpc/procfs: let procfs copy out reads of /proc/powerpc/systemcfg
      sh: alignment: let procfs copy in writes
      sparc: led: let procfs copy in writes
      um: let procfs copy in writes
      x86/mtrr: let procfs own the seq_file of /proc/mtrr
      x86/mtrr: let procfs copy in writes to /proc/mtrr
      x86/mtrr: let procfs copy the ioctl arguments of /proc/mtrr
      xtensa: simdisk: let procfs copy in writes
      xtensa: simdisk: let procfs copy out reads
      ACPI: proc: let procfs copy in writes to /proc/acpi/wakeup
      macintosh/via-pmu: let procfs copy in writes to the options file
      platform/x86: thinkpad_acpi: let procfs copy in writes
      platform/x86: toshiba_acpi: let procfs copy in writes
      PNP: pnpbios: let procfs copy in writes
      PNP: isapnp: let procfs copy out reads

 arch/alpha/kernel/srm_env.c                 | 12 +---
 arch/arm/kernel/atags_proc.c                |  6 +-
 arch/arm/mm/alignment.c                     |  7 +--
 arch/m68k/kernel/bootinfo_proc.c            |  6 +-
 arch/powerpc/kernel/proc_powerpc.c          |  6 +-
 arch/powerpc/kernel/rtas-proc.c             | 40 ++++++------
 arch/powerpc/kernel/rtas_flash.c            | 62 +++++++++----------
 arch/powerpc/kernel/rtasd.c                 | 19 ++----
 arch/powerpc/platforms/pseries/lpar.c       | 14 ++---
 arch/powerpc/platforms/pseries/lparcfg.c    |  7 +--
 arch/powerpc/platforms/pseries/reconfig.c   | 22 +++----
 arch/sh/mm/alignment.c                      |  7 +--
 arch/sparc/kernel/led.c                     | 13 +---
 arch/um/drivers/mconsole_kern.c             | 11 +---
 arch/um/kernel/exitcode.c                   | 14 ++---
 arch/x86/kernel/cpu/mtrr/if.c               | 95 ++++++++++++++++-------------
 arch/xtensa/platforms/iss/simdisk.c         | 32 ++++------
 drivers/acpi/proc.c                         |  7 +--
 drivers/macintosh/via-pmu.c                 |  7 +--
 drivers/platform/x86/lenovo/thinkpad_acpi.c | 14 +----
 drivers/platform/x86/toshiba_acpi.c         | 36 ++++-------
 drivers/pnp/isapnp/proc.c                   | 20 +++---
 drivers/pnp/pnpbios/proc.c                  |  9 +--
 23 files changed, 193 insertions(+), 273 deletions(-)
---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261101-work-procfs-arch-8d4ade48be31
prerequisite-change-id: 20261101-work-procfs-core-8fa4a4f412cf:v1
prerequisite-patch-id: 0474af12959624910718795bf86684383664c685
prerequisite-patch-id: 540aa9ea28adcbc54d8264f66314e29e3b8c9d49
prerequisite-patch-id: 2f7139d1c972c4439dccca610caa5f1288987a3d
prerequisite-patch-id: b0031a7c4855b7ec38259c59f30f65101a8fc4b5
prerequisite-patch-id: 0b7f226abf2b9ff41873a1aa55cf97747647d56b
prerequisite-patch-id: f63e345f897619af54813958046617c655fb7daf
prerequisite-patch-id: c0e21e762a2960e3324c5ab04634a7035e515fa6
prerequisite-patch-id: fd59c71eadd8f39c58b3baea93567bc093bc9b0e
prerequisite-patch-id: 5d52cc8a5c73e4c5ba16b8e24f51408c17583bf9
prerequisite-patch-id: 1f9179284e2f3314d4b46ac5e989089a21c7576c
prerequisite-patch-id: 10397bbf696bee16dc71eb79fff6c5e73842bcbc
prerequisite-patch-id: 9b44279dcf08912238d2f6438a3328a778a79a0c
prerequisite-patch-id: 16854b621a3a71dfc365aaf7abaa7f65adfe9f7e
prerequisite-patch-id: ca42eea21fae1fd1cd3518ab057c74b61ffd68fe
prerequisite-patch-id: 23255dc2be76b0479c083dbd4c897bfbb533aed5
prerequisite-patch-id: 82129c687ebf0a41b369893b92f2c038420ab801
prerequisite-patch-id: 56ad57a99a5bda075a9f4e844368974296744934
prerequisite-patch-id: 288b3cbaa11e01a778cc3d7beb6c0549aacf59f2
prerequisite-patch-id: a163b1549608652bfa5bd9ff93efa55b541010c4
prerequisite-patch-id: 78f067c343177e52d49ddfe9ee2992e602549869
prerequisite-patch-id: 19c12bc6e3fbed35acc1f657196b1a997f48cdfe
prerequisite-patch-id: 5800c3076694bad719954b2ad4d7448c6e013bfd
prerequisite-patch-id: 2a2f63d8843b159594b9eee6ddea028ce76a6270
prerequisite-patch-id: 40a1951d57906c4a1b98a4bd96a814b80339b9c5
prerequisite-patch-id: e2141077e69f20a2b27fab69c8d61d0686682f53
prerequisite-patch-id: c4d6018c26c40dc549d88330d23ce48f872c2b7f
prerequisite-patch-id: 6de8ec17746031bc6d1d9ac262c5be0f905fcd79
prerequisite-patch-id: b87bcb167884605bff1fd0f2ed8a88942d07efd5
prerequisite-patch-id: cfa9a8b4c67e20cfd22d77035bfd21ee96ab3298
prerequisite-patch-id: abf3482ed2399b7b2e1ee72e937af05bb9200667
prerequisite-patch-id: 02c175b2dee565a85b3308ecf2ec8e3c9a029e0f
prerequisite-patch-id: 4ed6b3d3d45de49d4967e88ba4e7f03372775f55
prerequisite-patch-id: dbe02fe3f784776fda5e7ae99f077bef0cd4b48d
prerequisite-patch-id: 53edc9a95afff57c4acba40095a8054924261ea2
prerequisite-patch-id: cf9ce0099005fd3bc31a1e15131d48e315ac3bee
prerequisite-patch-id: 16a657a5d0046068dbace29e7ea046ac1441f46f
prerequisite-patch-id: efeb2d6f7df71d5dede2c1d12fe999a28e38aab9
prerequisite-patch-id: e6ffe2a5c3ee5645f56c8366b568fbc9f140848c
prerequisite-patch-id: 117db27dcdef433de7c6be5e95973cac1e373927
prerequisite-patch-id: a0844aa26ffb65ccb362b88ef6c2f4758e15edbf
prerequisite-patch-id: 143fb91bddf33068b6ee11e205818c4c2815e23d
prerequisite-patch-id: 6490e4da1cb2f543683bd164bc9a5a1c943057e7
prerequisite-patch-id: cdefca57d3c552fb6f6b928699edd85f33be25fd
prerequisite-patch-id: 2f0fdb970ddd760d85ff5d2caad0b96348270182
prerequisite-patch-id: f2aa468ff5cbb1cabab3f70e1b8eeee0286cfb4a
prerequisite-patch-id: 037030d95eeb7c49b1e43f638ec954f2cebbcfb1
prerequisite-patch-id: 487141c49e2548310bfb6c2a0964a78f08b285a9
prerequisite-patch-id: c3d3008819fa5629a18142ec9ba6d7024ade7fdb
prerequisite-patch-id: ba15e7c86b60ccc2f0f7ee4c9bc99073068757bc
prerequisite-patch-id: 9423f410b99853693db06c29f12f1c08278b050d
prerequisite-patch-id: 4e7966978e4b11c4d843831f312cdcd5b848f00c
prerequisite-patch-id: 3d24be1897a624d519ef144801f76d152c7528a9
prerequisite-patch-id: 3b4d9fe7b26f6b7b9b3f7725ea333df357107c44
prerequisite-patch-id: 7d9dd345428baeb88c862ef902612f7160dc1d8c


