Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 676C3606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FhLoRdgv
Received: by kanga.kvack.org (Postfix)
	id 84B346B05B0; Wed,  4 Nov 2026 23:27:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822AB6B05B1; Wed,  4 Nov 2026 23:27:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F156B05B3; Wed,  4 Nov 2026 23:27:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B15C6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:27:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADAB080913
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:27:53 +0000 (UTC)
X-FDA: 85399782426.24.86A76E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E55E8A0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:27:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FhLoRdgv;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793852872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=u6F4KDCYBUQmf5Ux75AdWla2t2dBWZcV4odDQlEP7Vs=;
	b=U4g3sYEG7jRtxRH5okVUIG+3QZrWLX4/qPWf5v0ip43Rnm1rc8WOv/Cjm3vLmAFKTB5NPU
	p/2+NilAjWJnXMtk5/mhYMok4111roX+Uwja+IS6toNtzDF/OZuZx8YSy5llGkTgVfQydD
	tOZ/K4PbToCAEULwSX4HdyvH7BcEuSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793852872;
	b=EO4wpOoW/WxL+m0lojn0Mx/pu2ZSomfotPjKu9pKohkHztkMksNi16A6qBkNEqBEXG8yeW
	5XPwe5oecn3lBuxOeffd/j2W7PdSAJ/NxMemYHAbH5V9JuOlHmd4AVVfC0xnIYnJx9akW4
	e01Ytx6E/xUbSQ632r9DDA54fSAqCD8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FhLoRdgv;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14C5440B18;
	Thu,  5 Nov 2026 04:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD1C1F000C1;
	Thu,  5 Nov 2026 04:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793852871;
	bh=u6F4KDCYBUQmf5Ux75AdWla2t2dBWZcV4odDQlEP7Vs=;
	h=Date:From:To:Cc:Subject;
	b=FhLoRdgvhjhC76otaNKgvCnBlh7dz3VLrlFogfXeqxUzmIo8dzKfgv7TUuJgHfCuQ
	 yHBB4WIA1dCoWMDJSn1Yim2MmriTEV8tEPmmNiz2WJ8Plj+XcwpiMXA+FZFKZnJvAW
	 V1DGCzvuWmHm13mO+Jx4tyThJtjt/yPeXQ5XAFXk=
Date: Wed, 4 Nov 2026 20:27:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM hotfixes for 7.4-rc2
Message-Id: <20261104202749.a5b9ab39d3169f80b5089a14@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E55E8A0005
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: za95dppjbpkr9q8cuumxnjwoy3w6bofa
X-Rspam-User: 
X-HE-Tag: 1793852871-488303
X-HE-Meta: U2FsdGVkX1/6HbI3ZXV4pq2ZXDz8IS6S5CVjG8kgI3a6ENZRblc0ESWy8a5o2nhqeHyDDjJvAxANnijs9nPV7m7AMAcJQd42FUILkFkuoo8CJCd7fWp99ES2QgquyCCLTi20EeWzaolZZSK5tH5xTFGbhzfKJAOO1WebcrzlmSeghVUWy1Ixy6bDBjF0x0NAE4X51gND2omv+EtQjwsfHrIDAnEo45lZdYcw7i7rm113hxOt1cmEs40MMtxWkQ17GjlIDLFsk+d0IxrzWCm4Y3/hjbrv6+H/Vj6TYifp5gZzzDv1fvovSJqrAcA5rudmQgrC2wBfUxb328x1p0DDs4j5I3Sh0wIta9iq/E+l1iCrjgZhfO5rtbCPupQqBzethfUNkSHl+5rnNDtiXO0eGnA6aaIhSMo0cyhHEtY4KEM2rRd68iCA/a7d5RdFUuum9EeF8AOgeokszakbNz2IE/NmBp1UBTldNGZJqBGFEPSsc9r9N8BtAukXXnhFJ14yMw3aYBig62NQbyCwPLgMLHUBIbiYgE+8sG0X2hHyelDjhZn22c4JuB0JH5NJAtNxvSoBApJ7vKnu4qo4RbyNEg2XSps3Ohd5x4xOy26uM8eDBPmdGafqDQxR1UCe1Ca/EHEs2guslB359jmFHgKX5NhLiOBGQJewAOqH+uXxg9W6JLbOiIiR9PelVYVQkjsPhO3d+cx/dAjJf/HbnBwx3S+kvrLzL53b8h6kqAuG5HdA7HVojySqIQDpiyWaLGz3ZNzgtWQyEqIpHkBW1Wspp3heRbHdo4NrySIoFmCb6t7FXUdhaeKZk28WbSVpdyeLHmv4xkzHUPWx11qeAYguMk5GC1M4op/AB8b2FncDUFVyTATOBu6IVmx4fIBS6TLRl/bObyNkHd69SvJ0ClVreQ0ezBLBE7HMQYWMK+oEFglPwMS8Tuo7LDx/PxeWnKjiIxBWHCFDJNq0KInkgnu
 fxmV/M32
 3qifM9CH3NhGuQAzzRPexqr57FLdu9wKRt3Un/X2i+Xc1GjBrBc27ZAPYVcU50si5+G7Q0KCbYsWSmxMPBnGGffDnki1RtTtJLXgSLlGyCivfS21JQovM/yZB6qZQvOq387zlgCiSQwEdOWg2JdY6CBD6ftWAPqmNOoOFcEvdGwt3cFR8WdeDXjhPzIxugPT+t96mElfJ4KPCCDMSKL1kfUFOokROHkTf3WasQRlio9AIHPu6CyGL/C6ct3Pb9Y/APk1yLFwXpExtsjXGeeVaFGEXbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Linus, please merge this batch of others-than-MM hotfixes, thanks.


The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfi=
xes-stable-2026-11-04-20-26

for you to fetch changes up to 5b4696e0bfc358619adaeab25ad35b4979af8331:

  ocfs2: cache the mount context for dentry lock callbacks (2026-11-02 19:1=
8:59 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-hotfixes-stable

Everything:

Total patches:       22
Fixes: tags:         19
cc:stable patches:   17
Reviews/patch:       0.77
Reviewed rate:       68%

22 patches. 17 are cc:stable.

Most are OCFS2 fixes. These address extended-attribute corruption,
missing attributes and kernel BUGs, along with crashes during cluster
configuration, lock migration, recovery and unmount. Extent movement
is also fixed to validate its range against a stable file size.

Three FAT changes prevent a failed-write/FIBMAP race from spuriously
making the filesystem read-only, correct directory link counts after
rename, and speed up file expansion. The reported QEMU benchmarks show
particularly large improvements on synchronous mounts.

A taint-string fix prevents an out-of-bounds read which can expose slab
contents in the kernel log. There are also build fixes for OpenRISC
modules on CPUs without hardware multiply and for Clang 24.

----------------------------------------------------------------
Andrew Morton (2):
      openrisc: export __mulsi3 for modules
      MAINTAINERS: add an IPC entry

Cen Zhang (7):
      ocfs2: validate move extents against a stable EOF
      ocfs2: keep locking_state within the cluster connection lifetime
      ocfs2/dlm: serialize migration MLE cleanup on failure
      ocfs2: stop recovery before shutting down local allocators
      ocfs2/cluster: unlink socket containers before releasing resources
      ocfs2: wait for filecheck kobject release after a failed add
      ocfs2: cache the mount context for dentry lock callbacks

Cl=E9ment L=E9ger (1):
      MAINTAINERS: mailmap: use Cl=E9ment L=E9ger's linux.dev mail address

Eklavya Singh (1):
      ocfs2/heartbeat: serialize concurrent writes to a region's dev attrib=
ute

Hungyu Lin (1):
      fat: fix parent link count when replacing a sibling directory

Joseph Qi (6):
      ocfs2: read the xattr entry hash before defragmenting the bucket
      ocfs2: find the xattr entry again after defragmenting a bucket
      ocfs2: find the xattr entry again after converting a block to a bucket
      ocfs2: do not read the entry array of an empty xattr bucket
      ocfs2: do not index before the entry array when dividing an empty buc=
ket
      ocfs2: do not read the entry array of an empty xattr block

Matheus Alves de Almeida (2):
      fat: preallocate space before expanding in fat_cont_expand()
      fat: hold truncate_lock in fat_write_failed()

Nathan Chancellor (1):
      lib/base64: silence clang-24 -Wconstant-conversion with diag pragmas

Nickolai Zeldovich (1):
      panic: zero the dynamically allocated taint buffer

 .mailmap                          |   4 ++
 MAINTAINERS                       |  14 +++-
 arch/openrisc/kernel/or32_ksyms.c |   1 +
 fs/fat/dir.c                      |  10 +++
 fs/fat/fat.h                      |   1 +
 fs/fat/file.c                     |  70 +++++++++++++-----
 fs/fat/inode.c                    |   2 +
 fs/fat/namei_msdos.c              |   9 +--
 fs/fat/namei_vfat.c               |   9 +--
 fs/ocfs2/cluster/heartbeat.c      |  40 +++++++++--
 fs/ocfs2/cluster/tcp.c            |   5 +-
 fs/ocfs2/dcache.h                 |   5 +-
 fs/ocfs2/dlm/dlmmaster.c          |  70 +++++++++++++++---
 fs/ocfs2/dlmglue.c                |  34 ++++-----
 fs/ocfs2/filecheck.c              |   2 +
 fs/ocfs2/journal.c                |  15 +++-
 fs/ocfs2/journal.h                |   1 +
 fs/ocfs2/move_extents.c           |  70 ++++++++++--------
 fs/ocfs2/super.c                  |   3 +
 fs/ocfs2/xattr.c                  | 146 ++++++++++++++++++++++++++++++++--=
----
 kernel/panic.c                    |   2 +-
 lib/base64.c                      |   3 +
 22 files changed, 388 insertions(+), 128 deletions(-)


