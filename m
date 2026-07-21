Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E2AC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DBA6B008A; Tue, 21 Jul 2026 14:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60ED36B008C; Tue, 21 Jul 2026 14:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524466B0092; Tue, 21 Jul 2026 14:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2A86B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:53:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A24FC80277
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:53:00 +0000 (UTC)
X-FDA: 85013680920.10.5FBBB69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0524E4000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:52:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MUFu4piH;
	spf=pass (imf27.hostedemail.com: domain of kwilczynski@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784659979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NN1+I3Y2Ia7vFPUpLF0faQvhg99ndfxvEeeB0XKXwdQ=;
	b=Pw5hm2DiapaTWEZKgsxhw2P1wPN5AYqXkGPp7nBlr9oElOXsO6HTAtWXqTlqgns9n3u7sG
	k8fxsF/nMTavEMzdOAFEZKi6LuS4Z5GdcVxoW0GvlR/6Sr9rWuDQIrijoa8vt6fRQ/Dbrn
	D4HAF0Ejga4LJMuitfjzDBwGNuE46LA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MUFu4piH;
	spf=pass (imf27.hostedemail.com: domain of kwilczynski@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784659979;
	b=sELTrnEjph+7MiHdO340ncuHJPXFcVfRanLe7KHtGwlvP/bFqjwftTRhBXE+L32NkelMwS
	inb2yUW/4WzyQ2qQdfO68ujVeGOm7GhtkaZhosnpSdcHiAWiCHZW0M44xZZFxquCnifrCm
	QzodS6UEeBwfMv3d84+Vlydg52oHRa4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29D6143E60;
	Tue, 21 Jul 2026 18:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798051F00ACA;
	Tue, 21 Jul 2026 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659978;
	bh=NN1+I3Y2Ia7vFPUpLF0faQvhg99ndfxvEeeB0XKXwdQ=;
	h=From:To:Cc:Subject:Date;
	b=MUFu4piHhUppkUXntiQYT6Fkobom+bPK7ctPPgNlmGV6RwghhCwpBxkgQU93ghRd6
	 K0GZljyCUehHMKI0o4laqm7BoZ9GDp5pdaGp5OxZHjbXApb9PVqiDP3UNy0EvTEKtM
	 yzBBIee22Eyyngf+lxofSq1FQwSk92yz+PZE4dFMYvGybQueunqGTD1JCicppKf0v5
	 hM57UYv41pUR2In7TdxvLNO7+q1oDTdcJM8mJ/WDaM0pxgG0GXo5nfC+MKW0etfm9u
	 7/qkZcW0PNvtN28vraAz28i2z7j1108o4i3upWDO2JFBPTs5FqvPeVtCbA66QnSFqE
	 ysnu69f2QxRcA==
From: =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev
Subject: [PATCH 0/2] mm,kernfs: Fix stale userspace mappings after sysfs file removal
Date: Tue, 21 Jul 2026 18:52:50 +0000
Message-ID: <20260721185252.1670958-1-kwilczynski@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0524E4000C
X-Rspamd-Server: rspam01
X-Stat-Signature: 8as1339t6jtn3gww5ak55m87jdu4qbew
X-HE-Tag: 1784659978-328191
X-HE-Meta: U2FsdGVkX1+bzH5wVUx1DsgEKzACHbq0hiob3Gg7e0Oxthr35AScOOSbDsBt4Hh5+I+yE6t4/m2Bb71rKtkmOGL7nTNumbF0IMUSFDyJcM5q8FI0jx78yT5Ojs/upp2UimSbktmLs6ZuJDuocOgmzUQTtpJx4UNU2yEgHMsM5dvh9zrCVcCj9bgJtpXxW/owElckxRmoo03adDEVbGAgJVTWvie+BXBx6F/quXHQOa36MY89aanXzOTwtpXhSxMLcmefqLyF2V6QyiH8VHzgw42oCcv8XXaMfJ/ECLseHOKo9KAlgZaya6AlG5TZRWwZ0iypIq7wmUwEWq8crymuCkQZZDOfj+vxJ7CbQIWAzX8BP/0UZENnyim5Szn/QYUKK9NaME6l3eMppny3r1+Rs12OvSGLPTRcUv3qdq4RSgUwz9VPX2aOkPDr9jyFS1QIO5APM0mMqRREKZoWK2A1VbugkLy0UhReQzM5xKfFfJPJMwjfV+CLaVWLY9m9HjNvGUP3EeePTNYR68MlPLO2L8s21LBrkj7+s8a/kjM53iWbt75B8VqAsN2Aef81cIyhhwnnBQ9Lty7LRTiNbH7tcyl+5MvKjquTTwxl1r+ZIoKWLsMJg9nttVQ1wD/gMQMygmErk3Sa+M2wkHTuqKvflmkTujPtLEVssd92H8yc3BPyJxprpncz8gufQHX/RLip82sJSp1OGOvgGNa8d+JvCWBJajDvKZNktpr/CJ3dC3EtlAqPALTML4M6Cvk+mMUqiooTNNnV/8/zRKKV2aL5Ncjuo9luX391nCIJeLrxGC319XQpYHpssgzMTvqStQ/WDVgkEx+nDRxunMroXnaZCNgKJNMpJYnyFf/b+m9bW/MAIrdHdDm/8imjL1EdZEJRHnDa3HuZtlBdg3pbCleMnhrTKIA5vcotCs74XnYiXcyaV6fCqdnRxNP3J+sxDziQf+xsBOWZyPbHGMW0cpt
 yzEIOeU7
 evJ8Ms8ZhTc6y4d0dHuhb2edB32WLrHgIQRa3F01xUrcuamlLdrZRMf6oOQb2LReVsL0PGlBp2FgR5S3FQ4pezndUH5NevWOqrpZwIUXXWBdeVYgWDLljiR76Nc40iknEZOIRXWYU+XFr+HadgUUiKfeSgR1rYBiJj+U4aWce86dKZTsaap2namjXEbStg0O07giTlMN+gvpCD7WFouT9f9HpYN8vCMZMqaI076bpSNMhGdlXOixkUEUsMCTBvlb4ChTUsCdncz5yF5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

PCI resource sysfs files swap their f_mapping to iomem_get_mapping() at
open time so that revoke_iomem() can hole-punch userspace mappings when
a driver claims the BAR (636b21b50152, "PCI: Revoke mappings like
devmem").  Their VMAs therefore live on the shared iomem address_space,
which kernfs_drain_open_files() does not walk, unmapping the sysfs
inode's own i_mapping instead.  Userspace thus keeps live mappings of
PCI BARs across device removal and resizable-BAR resize, with stale
PTEs into physical address space the kernel may have reassigned.

After the device is removed, a read from a resource0 mapping returns
the previous register value instead of faulting.

The first patch adds unmap_mapping_file(), which zaps VMAs selected by
the originating struct file rather than by address space window, with
a stub for !CONFIG_MMU builds.  The second uses it in the kernfs
drain for files with a swapped f_mapping, keeping the existing
unmap_mapping_range() path for everything else.

Before 636b21b50152 these VMAs were attached to the sysfs inode and the
drain did zap them, so this restores the earlier teardown semantics
while keeping the driver-claim revocation intact.  Files without an
f_mapping swap (p2pdma, cgroup, everything else) see no change.  The
same access now raises SIGBUS.

BAR resize is covered by the same path, since resize removes the
resource groups.  /dev/mem and /proc/bus/pci mappings of the same
BAR are unaffected.

Krzysztof Wilczyński (2):
  mm: Add unmap_mapping_file() helper
  kernfs: Unmap mmaps of removed files via file->f_mapping

 fs/kernfs/file.c   |  5 ++++-
 include/linux/mm.h |  2 ++
 mm/memory.c        | 26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

-- 
2.55.0


