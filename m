Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43A0C44502
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940496B00C9; Mon, 29 Jun 2026 08:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917B46B00CB; Mon, 29 Jun 2026 08:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806EF6B00CC; Mon, 29 Jun 2026 08:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 558886B00C9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC33B1404B5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:57 +0000 (UTC)
X-FDA: 84932869434.20.7EFBEDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 380E3C0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ImB78Xm5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735896;
	b=L6hgRNtImWjETYRVJjtLowtQ/or2BNZajJ9G86jCD1pfZye8TijqSTiUoekDkQsjo15uZv
	LI75yKsfrSm4kjLxho60VERuOvh8OefyWxztF5UphhXZAlR+JMNHxKUsI6aj2BnrQE8hHD
	m4GR/RFZadRtDaQW42Yul1Jw8WrVE6w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/zmrg1aZZtj5Tmn6K9F810cSj24cLspebCxVYr6+vM=;
	b=jIYVG9RvrdlKscMZDrcqtiVrfs7geKXXPbfCghFY7Hj9Rd9TxhIkF63xSz+6cY5smHQRge
	hw0taG278gnpV0ex1ghxATUvKa/pYBnj/fPAF3qvkoyoK/Kvypm4a2Ag2KdzKewKr+nPxG
	O4uvj+N5RKd488pysjXhpx3hXQSi9bU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ImB78Xm5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DB9143E8E;
	Mon, 29 Jun 2026 12:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819851F000E9;
	Mon, 29 Jun 2026 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735895;
	bh=q/zmrg1aZZtj5Tmn6K9F810cSj24cLspebCxVYr6+vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImB78Xm5cq6RrDbmQ3J6tzrC3HLEzs7wzd0LC9qXAFx7cd4y0IcRNHPEQjaCD2kCv
	 t7/cUJE9y3I1sPoHMYrCyG34SjvURuw2nRDZurNb2jCyVmORwYVTl6EDHnREKFXwhb
	 Mbf3AenyI1/h0SqiWNCY23Z13tJZjuXnBQ9SfIzuKiUPMbB3m3+TLCnoGKijqfR3NC
	 1tp2JiV+gIsscH67BC9LhRi/4QlmripqWzergkvG/ngTTNDMnQd/mgZN6SNyqqbauP
	 IGwwhnbxNqzXNkjYdSC9Q47btcLisY0PN7QS+5n8ONjQMKE+Ptl6DATcGPdaGI14cl
	 pHvsw1KC9+rOQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 20/30] mm/vma: introduce vma_assert_can_modify()
Date: Mon, 29 Jun 2026 13:23:31 +0100
Message-ID: <23c7602c58cacc23ef22618a27af9a2d54addf58.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 380E3C0004
X-Rspam-User: 
X-Stat-Signature: 3np39wosojgkcqmstdcftiki8jk3z3cw
X-HE-Tag: 1782735896-288441
X-HE-Meta: U2FsdGVkX19s7WUwQnc8X9XR6fXt7/bUzIPmruVp0mYUA5T6Fot7ubuLV9pAjC4A9vn4qAcUGDSC2kkg3NcH2pYsqHLZ/rCdLt1fOwxNz4k0k/FBvrsGhoyGPuSQ6J3fPAvV99DoNJK/lfGq4C3rl1fru69fZAKTDRyCs3wAchgHzqM8mgETfrLZ58RmLPDB+skTDVCLta7lZbNBcei3xseOBD88fgrJpDUAnLdpjJHMHWisbdvJ+gciUSZZCpk9lhD3vvXyqdB4t+o7jqWZP2mz9Djx3qrIK2or/7msbksBdCew1jgLV6cnH2TqdJ8D4ScPp3B76BIhunWI+ARtY6B56UrOP3UwjXxwrwr095/r1oDuA0UN1AirLMYSYZLp9Rv47EX9iZxn0ycsIvnGWqNRtOezI4cC1aOQNuvty58vY3uWyiSp4DD8rXIACpIv/04cMrh5GcCTsC1n7a7XKE2dx2prCTuw5fVJX10cCQ/4Tjcl0YA6oUJIETdOiH7sBV9WtYdBhu4cWzsJ+gg3wisqg4jrq0sHNTSdAX35CBTZZxv/VKfneZRo6BNj2y7Ucq9LZm4+tFSAm0IHcP+5KHUPl+aMzB32lAOLh20mOalPVFHyvgpXPvB6t7WBOIPUhi93gzybBCSexa5F02uq8esAQVH0CjL0P2qNTc1X1L0RmV5JTBphmNnIbZzZPdonyfZUbZJwvS1pECyXfat4/oPUUTk+JcZiketJ3TzLNobdfHjYSfdPrVdFxn067O87LeUnABJMEtTK5cdIfrErOhxUfYZDE0XgywoucDvRi0TiqYn8X7xc95MmhZQ5QPo08wvAHbM7DofRUUYn9pU+FzpUT86j+8cxtr7nV1M/dTT8wNeFMlE0MCmEhVVvIPApn4oxtGOAvZyldUwMO97M205pc1Xk3G3bgZm5TThzEn5NYsvRR9yMOWYIIJ12ddGmpuVqgPGR285ohjdvY3t
 0D3tzlg+
 vAJfCIXfnWzWOjiI+gagO7ZcKO4/t5VEbB8goj2MZq02MPCpszd3iSQGxp405IaJFvYPUsyPbnzFzcHNDHltMwc0/OJQH1rYJJbLWRQ4A7MEfKfCAKDmBJo2/5qjrfNgXbJjq3ZvxFfCIifp4pX26BUDrueyFhdgTP6jwOj9JSjLQbikBi/rPnrcqOegF2Z5iTDjTYG+B8VKYsiNab6vftMuwgDsFnmxjN9qy5ujK0zTMvzteCkSJskU1OS6UqBR7moSVIq0VA57l7oQzWT2dbnYZN+lmZ4NbieT9B1SmbFRbdmoHmu16OoMGF/jWqIcGWEeX/kDJ4NO50RYEhN4o13Lrqbd5U+i1GNzC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_assert_write_locked() and vma_assert_attached() are useful for their
own purposes, however VMA code absolutely does allow the modification of
non-write locked VMAs if they are at that point detached (i.e. unreachable
from anywhere).

It's therefore useful to be able to assert that a VMA is either
detached (modification doesn't matter) or write locked (you're explicitly
locked for modification).

Therefore introduce vma_assert_can_modify() for this purpose.

While we're here, make vma_is_attached() available generally - if
!CONFIG_PER_VMA_LOCKS, then there's no sense in which a VMA is
detached (vma_mark_detached() is a noop), so have this default to true in
this case.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mmap_lock.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 04b8f61ece5d..d513286d8160 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -506,6 +506,8 @@ static inline __must_check
 int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+		{ return true; }
 static inline void vma_assert_attached(struct vm_area_struct *vma) {}
 static inline void vma_assert_detached(struct vm_area_struct *vma) {}
 static inline void vma_mark_attached(struct vm_area_struct *vma) {}
@@ -530,6 +532,12 @@ static inline void vma_assert_stabilised(struct vm_area_struct *vma)
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
+}
+
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
-- 
2.54.0


