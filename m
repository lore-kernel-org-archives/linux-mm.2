Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323D7606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GnyP3M+w;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ROvK8zHR;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ANlbcIDE;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TE5h7LM7
Received: by kanga.kvack.org (Postfix)
	id 421416B05C5; Thu, 29 Oct 2026 10:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA786B05C8; Thu, 29 Oct 2026 10:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0936B05C5; Thu, 29 Oct 2026 10:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F357A6B05C5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86BA116042E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:45 +0000 (UTC)
X-FDA: 85375935330.12.B5DB287
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5CF2516000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GnyP3M+w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ROvK8zHR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ANlbcIDE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TE5h7LM7;
	spf=pass (imf08.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793285083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ma02zVhR/wiqxtMf4JB5WMp1YLmgiNfWHzj9kC5VbP4=;
	b=DnaTlOkBXkG4FtjAcT1y9lp4zSMc3v0Kn1Bj6Cu/MMZ1qO1irYxukHxCwXrjghdPmUEgGc
	Pbdd93mj/OAeIjfWLJ1I9uSMUuQoGEqyQX/EC9NubZVVU8nioazkp5IWhfHj/QEovMBbF5
	lz9OIHIlBDqs0vY+XEjx4FI2u1AKQdE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GnyP3M+w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ROvK8zHR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ANlbcIDE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TE5h7LM7;
	spf=pass (imf08.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793285083;
	b=wkQWpD6iiwrfoENLpotJmVfueAmyhSYE/CT09X8PprGPLJG04xq14odWUA/zgovsHVy5Rl
	xX2BbtQMubl/VGVgyVoYP3zeSXGfDNWXAo3K3x9hjOozBzDHsx3J0xt65SO4DzGYGr4rM9
	AjY6VEXh5gVN0K6h56SDPKcEgIn4rPg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 12955220FF;
	Thu, 29 Oct 2026 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793285082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ma02zVhR/wiqxtMf4JB5WMp1YLmgiNfWHzj9kC5VbP4=;
	b=GnyP3M+wrwXhfJ/mt8bOmompb4hK95hgUZ/AVXEh5csJs5Ib/dgmCnuaPudHkUqdrXPhsI
	vyBNhxct2C3EFj/hIQGCB/q+ReLyCIqZGSAnaiWkj2iUNvPi61Ecgf9lZZBR8VCiVcUMDY
	eZk/LWvfT3jQirSJG7nSL/jcyqToZlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793285082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ma02zVhR/wiqxtMf4JB5WMp1YLmgiNfWHzj9kC5VbP4=;
	b=ROvK8zHR1ViPfnRb/wmNmOKvd8+ruKEHb/fsjoBtaEmA1ibnYHuMv2PjV6tP/Z2h8rqaH7
	NiuqW16IlbbtAtDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793285081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ma02zVhR/wiqxtMf4JB5WMp1YLmgiNfWHzj9kC5VbP4=;
	b=ANlbcIDEbB6Ur4cFIftmZkdDNofc1vc/RFGI8xElieroJEETE6m5QsP9p/Njs8SPd1BhAU
	OrOzudm0cx7TCWwaJGzU5BMwp25N95N5zklBKKyU8PQ/1CgPztIoIuIBbr1oSYDbP869cd
	GTTIOkA1T4ZhbivjJzjGM3IDUqC+r+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793285081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ma02zVhR/wiqxtMf4JB5WMp1YLmgiNfWHzj9kC5VbP4=;
	b=TE5h7LM72RerrFOljyHghrWN+OB5oGMt47TWKid72KLd5VvVanU/6NKTm6YLGwiBfS3VqK
	kZ0jQYdje30fHEBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 742A81339F;
	Thu, 29 Oct 2026 14:44:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iNqFENhb42qRUwAAD6G6ig
	(envelope-from <clopez@suse.de>); Thu, 29 Oct 2026 14:44:40 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: linux-s390@vger.kernel.org,
	imbrenda@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Subject: [RFC PATCH 0/4] KVM: x86/mmu: don't zap secondary MMU on permission upgrade
Date: Thu, 29 Oct 2026 15:33:33 +0100
Message-ID: <20261029143336.390231-3-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -12.30
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CF2516000C
X-Stat-Signature: rp57fwbw1iyq1nwx9ficoq5b6tnno3pf
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793285083-934955
X-HE-Meta: U2FsdGVkX18RIQbWtHEMmucStm3O7Rwy6f61ilnbXvX8LPs/zofn5dwKWY3Ib155e/kxwfnjO9T2m8sjFbeSpTX0tIWbAmWxHXp8nnG490wMIZ9amap5VATqSCk1xwabPPL+Pi/geXBoDO8GnboBLoqlIdAJLuJh2c3w8V7FDy4pqZioZJA7dwLOBzbA8V0llHC/LexUhmrBKiCV94bgQhpfc8ctoYrdhZ6BqBqKMY7i5ePg1ukXaxXkQKtW+49Fz25Pqxpn6oHs5ht+vTnEjt2E5Y1cHWS1uKzRAOnQGJAc+rkoPY8tmAf9/m6tPgPHY3+ge6QxxeS+3XjnFS4VxTyt6R+i7ltoc4RzLCEV8r3TlwshayQX72be67udOI5Z2C2bgjxM2TDGU5kNV/QFFZCk8Mr+ykzTgg6eJdP5Q8iim4bfjuBTrPBOP7vhEwrNlbrqokXUDAAsbctilItL/HWryJiCm25jTVlsLYaJw1vaXyvKRMRFCEfReCsV1YfhsWwUM9dRb0v8BYnw1tMjJKDXJeOUVYxwYadr9MXZKv7FU/H4NYKdxufTQzDQ+or3b5W9W8vwNi2GDiGr3/Xx2/OcN2FuS9z+lpQiHTWOhy7MrN8UxfwN5X2FtWX2R3YdVsjXeI5MJFf+EdERrqxSlIz9AsnChL3wXKV2NjwtDwJM0LqxVipFExt+g2sZqPVdp/Pb6PluumGuL0PuzCAdpefJCzsv5heBSztSXf4UQwt42sJUQvqdM77MXiHzlTV47a984JbWOSoVQS+2k4NHMMcG7C701Vwh+Gs4drF1IUnko8UylAUXsNFFgsHMxFdjOj96VgaW35I4EOEVdDlZB10q+uOXWld5wDpBQr0SkWgM+l62hRSvit2D1TM1hfMGDj1KtuR73P/+KKd4oAqHxeNahvmVkNpugjCl6FxsR7XcCneJFXsEC3JwaJLezc/Gc9JJxHFu7+y13SK2Y1P
 TEEZTWMJ
 qB2JAsrZvVDlgCzYGN9jiVkTOixpldtfKel7dUc5trOfYU3wYlwo8u4nWcKJU+2sOdQnMV5zen4XuYMC0zeLAd79X6FdasgmDIvZXjLpDWtykmziAFYy6Cl8zaOijwbrcp1KWrlD+rYBlC39YiVAUnAgu59dqteVV9iWR4QPBqiXz3R0h2vplT117iw+asPk9WLKeNzcb4jUkDYdC/gVM1VPE4vr0u67wQFeG3n43jFQszGpvjLYU0cTKq3/AE0N2GIFJ+sJncY+faBgDXPVE7uZhDKHViSkglakHACsAfrTEEyHSnxNJqxNHvXNGUlP6W4B/YC/eRreCSlUUt9gj935o0ABR/jbfdAvFQjKQvqs88M0GZxtRXEQSAiskiXlJNzNIpCSWRNKlugoxXRezPI03zwFYeRUjoKCrV1aLAjoS6dFc1WNrweJdqZP90U0FvGuQouQ5NzTEDTqWTgWCI0OqDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Prevent x86 KVM from over-zapping its secondary MMU on PTE permission
upgrades, which leave the PFNs unchanged and do not revoke access.
Permissions for SPTEs that KVM holds are updated on the next fault, so
dropping them early gains nothing.

Do this by adding a new MMU notifier flag to signal that a
MMU_NOTIFY_PROTECTION_VMA strictly upgrades (loosens) permissions on a
particular range.

See below for benchmark results.

Background
==========

change_protection() pairs every protection change with an
MMU_NOTIFY_PROTECTION_VMA invalidation, and KVM zaps its SPTEs in
response, as it cannot tell whether permissions widened or narrowed.
This is costly e.g. during a QEMU background snapshot, which relies on
uffd-wp to write-protect guest RAM and then restore permissions as each
page is saved. Without this series, the permission restore causes the
guest to re-fault read-only memory needlessly.

Note, the reverse situation is already handled for secondary MMUs
that reuse the CPU page tables (e.g. ARM SMMU, IOMMU/ATS). They cannot
refault, so they are notified of a permission upgrade on the CPU
TLB-flush path [1].

KVM, however, owns separate page tables and faults permissions on demand,
so it needs no such notification (as Sean noted when that signalling
was first proposed on the fault path [2]). This series applies the same
principle to the change_protection() path, signalling the permission
upgrade so KVM can avoid the unnecessary zap.

RFC Considerations
==================

1. Having the zap skip in KVM's arch-independent code does not seem
   obviously correct, as s390 caches additional translation state
   that may not be rebuilt by refaults. Maybe an expert can correct
   me. The skip could be extended to arm64 and RISC-V, but I have not
   benchmarked the benefits and I'd like to get feedback first. Hence,
   x86-only for now.

2. change_protection() could simply not emit the invalidation at all
   for a pure permission upgrade (shared-page-table MMUs invalidate
   on the CPU TLB-flush path, as noted above, so they do not need it).
   But again, the s390 case could be broken, and even then, that would
   seem too much intrusion for KVM's benefit.

3. The flag reaches KVM as a bool on struct kvm_gfn_range.
   Alternatively, KVM could forward the notifier event, as Claudio
   Imbrenda suggested at LPC [3] and others have proposed in the past
   for different purposes [4] [5]. That, along with the event flags,
   could serve the same purpose. I'd be happy to take that approach if
   there is agreement that other consumers would want it.

   (The LPC talk recording has some audio issues so I am not too sure
   on what the final agreement was)

Benchmarks
==========

AMD EPYC 9654 96-Core Processor host running a recent Linux kernel
(6b4b543fa187), with a 64GB, 64-vCPU guest running stress-ng --vm while
the host takes a QEMU background snapshot. All results are aggregated
over 5 runs, and compared between the stock kernel and one with this
patch series. Guest is rebooted across each individual run, and NUMA
balancing is disabled.

pf/s and tlb/s (per-second deltas of KVM's pf_taken and remote_tlb_flush
debugfs stats) clearly improve:

  guest pattern          baseline                    patched
  -----------------------------------------------------------------------
  read64   (read)        pf/s=950,015   tlb/s=1,440  pf/s=2,503 tlb/s=0.1
  rand-set (read+write)  pf/s=1,004,353 tlb/s=862    pf/s=4,073 tlb/s=0.3
  write64  (write)       pf/s=968,018   tlb/s=94     pf/s=2,292 tlb/s=0.3

Guest read latency was sampled with a paced probe thread in the
guest, reading one byte per page with an idle gap between reads, while
stress-ng ran with read64. Each figure is the median across 5 runs, with
the run-to-run min and max, in ns:

  metric           baseline             patched
  ------------------------------------------------------
  p50 (min max)      340     (270 380)   260   (250 260)
  p99 (min max)    19789 (16885 20200)  5207 (4076 5638)
  p99.9 (min max)  23445 (22845 24036)  6850 (6259 7110)

The median improves modestly and the refault cost shows in the tail,
where p99 drops ~3.8x.

A separate stress-ng run with write64 and --verify showed no data
corruption and no livelocks.

References
==========

[1] https://lore.kernel.org/linux-mm/cover.1eca029b8603ef4eebe5b41eae51facfc5920c41.1690292440.git-series.apopple@nvidia.com/
[2] https://lore.kernel.org/linux-mm/ZGu1vsbscdO48V6h@google.com/
[3] https://lpc.events/event/20/contributions/2552/
[4] https://lore.kernel.org/all/20240801183453.57199-1-seanjc@google.com
[5] https://lore.kernel.org/all/20231110003734.1014084-1-jackyli@google.com

Carlos López (4):
  mm/mprotect: add MM_CP_PERM_UPGRADE
  mm/mmu_notifier: add MMU_NOTIFIER_RANGE_PERM_UPGRADE
  KVM: plumb MMU_NOTIFIER_RANGE_PERM_UPGRADE into kvm_gfn_range
  KVM: x86/mmu: don't zap the secondary MMU on permission upgrade

 arch/x86/kvm/mmu/mmu.c       |  7 +++++++
 include/linux/kvm_host.h     |  1 +
 include/linux/mm.h           |  8 ++++++++
 include/linux/mmu_notifier.h |  5 +++++
 mm/hugetlb.c                 |  6 +++++-
 mm/mprotect.c                | 20 +++++++++++++++++++-
 virt/kvm/kvm_main.c          |  4 ++++
 7 files changed, 49 insertions(+), 2 deletions(-)

-- 
2.51.0


