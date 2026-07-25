Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97188C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84ACD6B00B8; Sat, 25 Jul 2026 17:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA546B00BA; Sat, 25 Jul 2026 17:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECE36B00BB; Sat, 25 Jul 2026 17:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40D9D6B00B8
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:05:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAFB61403AE
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:05:56 +0000 (UTC)
X-FDA: 85028531112.06.E45632E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24563100005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:05:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+PVY6hu;
	spf=pass (imf14.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=weL9cSnhARyHvpxmIUUADdy3slllDboHT4zVVeCC/vc=;
	b=ju6hXqiRX6pU2azsOfoM4p4VqJ+Fd7akCjoHu1kGW6IIw10A78sdrDlvsnwV6yt2dXGkaI
	l31OQB+vNdpW+Nzf32fsru7dDlJOR5figlLv1m6xYmkr6mpCxyRSC5FbKadQ0UxsoBEMeb
	TXlmKgdWE2XYctBrGaz9MTG4S9eRsT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013555;
	b=JBQr0yuCv+9FSieSoqN6syBpXdU6aphajGiGBa66vaTHn9g0/fQ9b5EYtIPt98oQ2O078f
	cfHjrOS0l9VdUwo2VAdWoNSfmtOs812yS3anMO8S/0cWXoys8vT0eF9noC/kgFhwmfQeqV
	Ec4KuUiyPiMLffuWnvxRZN4Qxr+rrl8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+PVY6hu;
	spf=pass (imf14.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9676260A91;
	Sat, 25 Jul 2026 21:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DFD1F000E9;
	Sat, 25 Jul 2026 21:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013554;
	bh=weL9cSnhARyHvpxmIUUADdy3slllDboHT4zVVeCC/vc=;
	h=From:To:Cc:Subject:Date;
	b=K+PVY6huvhgrRDyHRLiBH5YfjTXWPqU7zNgPDzB+6HOP8qLHnTSzTpLRpNKOjW72O
	 shvXHJiDIQksFCwvmaFhltPQgCF2kypDPKJgQWoCzRdI/Tqjs0xOgOHePWHQqORcgi
	 rXdSCH3Kv3+59e8PsvzywdOmAN01CUNtTuGJIqzYc80lZZPQ79/uTnnpDYk4NysMAB
	 +wN7ypp7wLddsRr0UnTWbA9sEdf7fDboRFrFB6vQhJERwHwSHHqFVxCA7FIfIsjvXg
	 aVLZYmPt9/6lEheogyw7MyO9vs75RDIniiOBl49do2BhpN63tawc3KSMAPWSFe5Tsq
	 qFH83/xxD7srQ==
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
	Baoquan He <baoquan.he@linux.dev>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	kexec@lists.infradead.org,
	driver-core@lists.linux.dev
Subject: [PATCH v2 0/3] mm,kernfs,proc: Unmap mmaps of removed files via file->f_mapping
Date: Sat, 25 Jul 2026 21:05:46 +0000
Message-ID: <20260725210549.3716546-1-kwilczynski@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24563100005
X-Stat-Signature: usmbwnxfh75p3jfugog8uj4wbf1mrtcd
X-Rspam-User: 
X-HE-Tag: 1785013554-616813
X-HE-Meta: U2FsdGVkX1/NXjAYYVo4MCrMr09pjEaRLC4Oq4D+Wri981iURQ4pIN0VmOtye6xa5i9nPpwDUStnKme1fo2RVcfttZtbmwZ5pGeBkO+45OYn2Hl+w2h/ClEQIAsA8rRRXCxg77JnwJpHbd6rozRUC/f8EXYPGGmD2kF+iVsavycCgM9cSw3kkakvOQtYlRpdQGGNta757bURgyCmJtXhqHH8p9kGjTyXTPIEP7BtiRxIzuVi4bqKJMPAUXy+XUICTdF2QK975qtRE45gxFltddZPIo/uJnvcdbnGqAH49bQ/KGhMDawi4zQL31WGk9t91agBhK1orHNg0SGFT4vssdK/HxIpeDqLORq5zvt9Dl00w4HdEFGYpSf8OeYEvfLv1IqrrkBDBLIvm/8SCVVs/Pqpe/AkevS0PNVKgQ8lbzO9am521DHRUPOPRokQXpwMM69Ec7LYzkyfNotXZlZ7DRhxLGPtGHd7xzFiFaCvViPNEeclPuWEjBO3SFBMcdhMugetLwmnZk4rOI08CVWVA2x+D9NVcYWdpPrHhmEQGLj3RuKfkYRcKC6zsOcKU5MoDUhHpRG/iZA4mpl6l/H5josLyNSzsJaUdmE/eS1SNSuoaRpYyGopIQvoeXfHTxgULellPpzmVa1jydYJhsqDBkQzSXfH7A1C/XEE+JTN2w2zRPV25rgiyts+aPE2sjDxDvYLqmy6p9qAwE7s/O37d+Kcai45ikaQG0IIg8LpmDEd8PeCDEv5RFzv7gca3WRrbV7aanZEL3l0ErKHut6zhrvgF57ALn/62ca0XXlGDQmxsni2mjvVV1nFSdWsBnOcBCFdqQmUWvBOsAVwH8qxPgSnpX+I2ka1GCfx6GFDWQevzafu7Wuukm0UfXJpwe57zYZVb6n9GNjlgbVvjX5kA2wr9eu8WwXpkZl4p09GF04A2QZn7lsC05CAN2U9l72j+AdYCZhbyhHxTwSftge
 VXlwEpkX
 UtORUXHCDQynCzr9U0ccCvck13v2b3H+F3E6ham+dDsVBAlmb0RKGqyvoQrAglcKKZWQi46IRByG7SsguEVufc2pVkGyx3VM7GX8ySona6ADHJLm2L8KTNLOBc8f7fIixzzb2PGPn5PIpOtYCeKCbkPsmtqr+lTGSWI2C68/13kCcr/iullZBgNUj42OtoVmbnnKZ+p0Ksjz3crylSpUHgP20obW1qtYJsL6yI3GGqPILfXYfTCk6/eSH71mQzIUlNh2wuT4h8Eq+yYovqtaUtpWqMcFZipeXfuPJ91JFW0a/VvxR19XmB4O3TIuYPevuCbiX4eCsksfQiofU0FMrdRjm0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

The PCI resource files in sysfs and the /proc/bus/pci device files swap
their f_mapping to the shared iomem address space at open time, so that
revoke_iomem() can unmap userspace mappings when a driver claims a
region, see commit 636b21b50152 ("PCI: Revoke mappings like devmem").

Their VMAs are therefore attached to the shared address space, which
neither removal path reaches: kernfs_drain_open_files() unmaps the
sysfs inode's own mapping, which contains none of them, and
proc_entry_rundown() does not unmap anything at all.

As a result, userspace mappings of PCI BARs survive device removal,
and also survive a BAR resize on the sysfs side, keeping stale PTEs
into physical address space that the kernel may have reassigned since.
A mapping made before the device is removed still returns the previous
register value after the device has been released, through both
interfaces.

This series adds unmap_mapping_file(), which unmaps the pages of the
VMAs created through a given file, rather than a page offset window of
an address space, and then uses it in the kernfs drain and in the
procfs rundown.  Mappings of unrelated files on the shared address
space are left intact, and the claim-time revocation through
revoke_iomem() keeps working, as the VMAs stay on the shared address
space.

For kernfs this restores the behaviour these files had before
the f_mapping swap was introduced.  For procfs the unmapping is new
behaviour, which matches kernfs.  Besides /proc/bus/pci, only
/proc/vmcore, the ALSA information entries and /proc/powerpc/systemcfg
set a proc_mmap() hook.  Mappings of /proc/vmcore are now also removed
when the entry goes away, while the ALSA proc_mmap() hook calls a
per-entry callback that no entry implements, so these cannot be mapped.
The systemcfg entry has no proc_release() hook, so it is not tracked
and is not affected.

A BAR resize is covered by the same path on the sysfs side, as the
resize removes the resource groups and thus drains the open files.
Mappings of the same BAR made through /dev/mem are left alone, as
these are unmapped by physical range when a driver claims the region.

	Krzysztof

---
Changes in v2:
  https://lore.kernel.org/linux-pci/20260721185252.1670958-1-kwilczynski@kernel.org/

  - Moved the handling of files with and without a swapped f_mapping
    inside unmap_mapping_file(), so that callers no longer need to
    tell the two apart, as per David Hildenbrand's feedback.
  - Updated the kernel-doc for unmap_mapping_file() to describe
    unmapping folios within the VMAs, rather than unmapping the mmaps
    and VMAs themselves, as per David Hildenbrand's feedback.
  - Dropped the EXPORT_SYMBOL_GPL() for unmap_mapping_file(), as both
    callers are built-in and there is no modular user.
  - Added a should_zap_file_vma() helper to select the VMAs to zap,
    following the existing should_zap_cows() and should_zap_folio()
    convention.
  - Added a WARN_ON_ONCE() to skip HugeTLB VMAs, as zapping those
    takes i_mmap_rwsem for write in hugetlb_zap_begin() and would
    deadlock against the read lock held over the walk.
  - Added a cond_resched() to the walk, as the VMAs skipped by the
    filter do not reach the reschedule point in the zap path.
  - Added a new patch to unmap the mappings made through the
    /proc/bus/pci device files, as these also survive device removal,
    along with a new pde_is_removed() helper used to tell a rundown
    from a regular close().
  - Updated the commit logs across the series, so that each patch
    describes the f_mapping swap and its effect the same way.
  - Added the /proc/vmcore and ALSA maintainers to the list of
    recipients for visibility.

Krzysztof Wilczyński (3):
  mm: Add unmap_mapping_file() helper
  kernfs: Unmap mmaps of removed files via file->f_mapping
  proc: Unmap mmaps of removed files via file->f_mapping

 fs/kernfs/file.c   |  4 +---
 fs/proc/generic.c  |  4 ++--
 fs/proc/inode.c    |  2 ++
 fs/proc/internal.h |  5 +++++
 include/linux/mm.h |  2 ++
 mm/memory.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 60 insertions(+), 5 deletions(-)

-- 
2.55.0


