Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D3AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6269A6B00BF; Fri,  3 Jul 2026 00:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCA06B0138; Fri,  3 Jul 2026 00:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5129D6B013A; Fri,  3 Jul 2026 00:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 264DE6B00BF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:13:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 973881685C3
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:13:43 +0000 (UTC)
X-FDA: 84946146726.29.EEB88F7
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id EC574C0006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:13:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QGhlIeXK;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052021;
	b=up2aDJUOm25T/P9EuQf0MPaGOpvBA5mxzKX0jF2jTLfGsQVZJHxy1LIkESwU4RjHmhqk9b
	N4tlgSgtHrxWUIjIoS9DVGp50z0EymqYI2S/Jiea9DTmSC2tTKrN4RciVwyDVuVXnJFZ/3
	ailO0RaGwQG8RBMp9295YO1Q2jYvn/k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A6npnmvUqCM8/66CqqYCk/mzyWieSpjEbi8Gph9LP44=;
	b=wUboed/kz6ZyuneUgyXujjYlxW5po4chndPF6a9hQX7muOVX65QxnJnKzKCt4AhxmyNI0l
	Mtq1sHhY2wKXK9uGqqyzcZnnyPkGwKerrn9wlNVgoEncLsCX2dE8V4Zt4FEipLj83UHyrN
	ORtqQqZfn8D3d4dGEZGRyK4fTfsXbVs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QGhlIeXK;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so126320b3a.1
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052021; x=1783656821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A6npnmvUqCM8/66CqqYCk/mzyWieSpjEbi8Gph9LP44=;
        b=QGhlIeXKNCs3EMll60d86Sq/EghFLjQU/KqcO1qyHHBpSPOuPmPEKeEfTYIP3QnUn2
         A16iXMbkWUvBha9h7FWLIAoEjeH/vUm4cjp7Use/n+M9R4suSFccwx/kDImea3Y2ScEW
         F3GZdX/UFl3Nc/MV9mZEjjvQ971SkjkQX6Um3iwErcXWITogCRmN6w36JREtVpqevvvG
         SRypf1jFB0djg2UMp85b4Pcj3uK89nPrDNHDWOaPl9lddCm1IrFmaqkhu3B/lEbCOCo7
         AtseS6UjcqnGdoDMqhw+UBF6pqNdoP41htFs/mVH7ykvFm7RfkjOCwFNBCEFXpySJpz+
         JxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052021; x=1783656821;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A6npnmvUqCM8/66CqqYCk/mzyWieSpjEbi8Gph9LP44=;
        b=riZx/l1rhmPej2cEZ0epdvi0tFCezGV/g9fCVBZnNFTKxR1xfIBHOoBlVddy/ta8w+
         /1vg6exM22l1zjEQsE3SYjoCUAWmnIc87P0tAbkvxwxhMPqC2o8lsKKupPikN/ji55vd
         naFnrNrBcPaxx2yZGKwWxxznapRSgp4dRAXXA4G60WR6uX8lf5XyvKMuyDhdprhybPe1
         fWn5X1dNSn4OGhhQYAwrIKjqVyt+fK3WG5A/rZTY3HdTHwBxaJ0Hxb3JdqbU8xJ7bH6e
         GF1OfIomzTflUgKapWkC8D9PLc8B7+WHbYPjx9X/BhpgVl9PSnp7VPiJk05FJdO07bl2
         bRFQ==
X-Gm-Message-State: AOJu0YxHIn9YUsYz9ZOqgnbgrQSiyc/vcBJ+6iJ4KcAiZdfxRZnJXwZ0
	J6hyvzHRc89Y28khRn+krVsY3h+bnX+PmMKVvKajWH4Zprw69MkpAY9S
X-Gm-Gg: AfdE7ckRYrey35Yk421Bm6/Cb1Sqq+xOS8v1JMU6NTpIA+eZEO3rqnGwmaA7fWrq+3y
	oIAg4eJ/6j+OVGC+/3UPeQpn60/rrLtqIWhJyvoS1fo2+FDzQklVOTJlb18Z1FpqGQ6vOt1Kyly
	QVC7YxXPTINLVvjq3zYLwbiYb28OPAT8MEU6+H0NjPQC00lyIe6LK/zWEQyJuzEk238UVML26Ew
	X6eyqm4x1C/OiUqxuRFrgETAaMpuFx9locQGAfLWLsSOOegG9SQlokMg5CmaS8G3cB9QKsCao2O
	n/UORBzDg2SckOjiPAP3on2rOgSFU5JQBSFf/Jq7AByYOkA4MBYOcUtyVihdFB+II8parJnkBuw
	a1qyxMCdrV0wSIvxtu06m9F3lltJtLOfY89EQ7e83ACcadDp7vOXqbviPrZk2ug0wnCqZL7Iavz
	K0Rmym3at2MNZt6VvbeQ==
X-Received: by 2002:a05:6a00:244d:b0:842:63f5:d097 with SMTP id d2e1a72fcca58-847e17360d9mr2456212b3a.3.1783052020555;
        Thu, 02 Jul 2026 21:13:40 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:13:40 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	devicetree@vger.kernel.org,
	driver-core@lists.linux.dev,
	"H. Peter Anvin" <hpa@zytor.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Xuerui <kernel@xen0n.name>,
	x86@kernel.org
Subject: [PATCH v2 0/9] treewide, numa_memblks: remove redundant work during NUMA init
Date: Fri,  3 Jul 2026 13:13:20 +0900
Message-ID: <20260703041329.2797584-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: ribj7rdntgru773mgjuf98znm6npmoji
X-Rspamd-Queue-Id: EC574C0006
X-HE-Tag: 1783052021-13009
X-HE-Meta: U2FsdGVkX182/8L380G8EfG1m7EntdppiwyUcHPLdJjPnwIRuOXZouajPTF31tUsM79cpyhVXBoabu1WuwobBjqbyqhB0FTbDn6Ky4xDpyI9kEGTgtHUtx9AYPluTQ6n5zaOG6Uoas8l0DhykKW68CoWYG8OOfjbiQldG1SZqprqSjhyIxyKsmon4QPgTNHCAdpbQzfZ64PWNymW+0ZnS7IqPHBiqA6aClVEEkECHV8OLnC0Gi+Eoenoi3/OosQ5d742FnGz0nTkGni45tJa+IeTOLvdJph6RdbJCWqdLOYvjDYhvxrNQxRSxak6pq31Bjz5/kJzeMuHPfC8SE9IEbGpmaD7kjLxE7N+juGYVlsC6ajTP70/BrztxprIzMfVDgJ5+7YNeHcG5xcvXJR48Z0O1CJ9Ws8NHytrGHDdmvbWYTx71SgE3vojINuwhLFA9PeKX2Qobr81lRjBaEb5l1z1SDHKUVJEWcjMDMC2fz1TfMNH2m64tQtUFh1RtITxAtaLC+GctBcmAxwD5rD8G8DTEZ/N+a9Nx5GK98w4i0S6hD4+82v3rxAf0Vd0+mgqzNMBCqYec3DwORjVdU/el1e0RCR6tYsOegI9aVV3bgChaJf36E9ea/YNBrbky8/J3+3fZaBh3Xkn7+pCb99kJhTFNbrYYJbA3/WPznCCk7b/tI7NTN3xSBJeWKpOPk/7DaYpfRjoVjbglg/0DbVQ+YvCYHz59OdpAoFoRbFnj8XZRM5r+sHQ4dsfPPRdFT1ngtplW402T1/QUzd6/1HJyesIIEdauFhwUH3yuevCaffMv5nAWLtyE8f0jHE19MNCQYZI4blTccRTseLn2g5f/0Ui2kZBW0fwSNB257KZao7FFxrV9lPJlFSIhAqZ/Lr9cpoR/3DDR2xH//K7GWE5uMzivtjLOBA/7ucTaROSocmvXJX6VWMgV90mQthDnJnMGiMnMoWjxmcDy6u/6lm
 KDJkyzfC
 JFnvuonXsRLlymXhmmGHhRUhNawJM5t0rWutKLd8EKlbOLwHHtoh6n2hFOwjY79JKNzzX6lckIjZirRv2z+/Eee4sYJW3I/N1j8apMHKsyWpj7YUgcXcOM8jzAiJyO734UlQ+YqHJXNYfksdd2cQs86kj9l6Xv8wBL2WUwSALtihwbL8sBzt/BFXPv0b4pfXLqmRgdMF/CW5IMKISv5WvT0rlQBV4tqti8ZNJ2jk/qQr309GaDJh97ukGLrDM+CUJOdGsHUlldfp7EERkjSkP/gJsgr2ZENcb56nEpJAIitmVIz8Ei5LnYsojxF9s7mLN4FUsYNK0132V9LtLnJENc5SNf0FltyVokkWsZ598tESVhda/z9gyr6xo1dn10MMWqxdANyYvUOIDQ7ivzXLEAVeD3fx5cX84cLVcKI1RyVzKy9OwhswxPV8Qvfe2ykrFaPQVVwBqsZCGQNXcFzKSS6NEaJ8mik6qeKkE+MLZ0VG3siA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every existing numa_add_memblk() caller passes a valid node id and
separately marks that node in numa_nodes_parsed with node_set(). In
addition, numa_nodemask_from_meminfo() recomputes the same "nodes that own
memory" set from numa_meminfo, which numa_nodes_parsed already contains.

This redundancy implicitly depends on the callers' node_set(). So, before
removing the redundancy, make numa_add_memblk() set the node in
numa_nodes_parsed explicitly. Then remove the per-caller node_set() and
numa_nodemask_from_meminfo().

Also, since the generic numa_register_meminfo() already sets
node_possible_map to numa_nodes_parsed, remove the duplicate assignment in
arch_numa's numa_register_nodes().

Patch 1 adds the node_set() to numa_add_memblk() itself, so every memblk's
node is set in numa_nodes_parsed on add.

Patches 2-6 depend on patch 1 and remove the redundant per-caller node_set()
from all callers.

Patch 7 removes both numa_nodemask_from_meminfo() call sites and the unused
function itself.

Patch 8 removes the duplicate node_possible_map assignment in arch_numa.

Patch 9 is a minor cleanup, using the existing numa_add_reserved_memblk()
wrapper in numa_cleanup_meminfo().

No functional change.

---
Changes from v1 [1]
- remove warning in numa_add_memblk_to() when start == end
- add Acked-by tag
- rebased onto latest mm-new

[1] https://lore.kernel.org/all/20260628135828.1393120-1-ekffu200098@gmail.com/
--- 

Sang-Heon Jeon (9):
  mm: numa_memblks: set numa_nodes_parsed in numa_add_memblk()
  ACPI: NUMA: remove redundant numa_nodes_parsed node_set()
  of/numa: remove redundant numa_nodes_parsed node_set()
  x86/numa: remove redundant numa_nodes_parsed node_set()
  arch_numa: remove redundant numa_nodes_parsed node_set()
  LoongArch: remove redundant numa_nodes_parsed node_set()
  mm: numa_memblks: remove redundant numa_nodemask_from_meminfo()
  arch_numa: remove redundant node_possible_map assignment
  mm: numa_memblks: use numa_add_reserved_memblk() in
    numa_cleanup_meminfo()

 arch/loongarch/kernel/numa.c |  1 -
 arch/x86/mm/amdtopology.c    |  1 -
 arch/x86/mm/numa.c           |  1 -
 drivers/acpi/numa/srat.c     |  2 --
 drivers/base/arch_numa.c     |  4 ----
 drivers/of/of_numa.c         |  5 +----
 mm/numa_memblks.c            | 39 +++++++++++++++++-------------------
 7 files changed, 19 insertions(+), 34 deletions(-)

-- 
2.43.0


