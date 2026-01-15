Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B90DD41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6FA6B0088; Thu, 15 Jan 2026 04:20:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0666B0089; Thu, 15 Jan 2026 04:20:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5186B008A; Thu, 15 Jan 2026 04:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6837C6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:20:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DC01576A8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:27 +0000 (UTC)
X-FDA: 84333652494.29.41AE9D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A72CA180008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X1qu5Bgb;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ecus/ncCEZHXyn1xqjQ963qgwNIW3kv/fmuKYykm8F4=;
	b=REn6cud4WMN3oHeIGdcXFgqob+oSxHSlkejGf2cSbRexo73vi8K7vrT39PDrUAgEGbuKqZ
	IC4YftpJwExLq4/thuGZjS+vHCwUf6Z+4A+EgPLAkQaZwDehAdoODVNRs5Em2jwvC2T3ll
	rlQ23lEulEggxKpqPVUMcjDEggjQMJc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X1qu5Bgb;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468825; a=rsa-sha256;
	cv=none;
	b=yfFjvEC3cyzD3BuqwTODSsrcwEvua3f0DD00yIig+iddI2Vtc/4m/eTjKB9ASkbiTsc244
	FpmkprpKrdU95Cwlx48OAYWGvrYC6CMn8XLeaQBc/CEneD3MZAynPJH/R8EztZ0FdSR0zF
	gyGCgj0cnMGjSBSY4w2AnqWTJGHxDL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9876601B6;
	Thu, 15 Jan 2026 09:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D47EC116D0;
	Thu, 15 Jan 2026 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468824;
	bh=WaIWpwazcvVnbufInohMJecM5S3wznCXPsNAkuQTp/U=;
	h=From:To:Cc:Subject:Date:From;
	b=X1qu5BgbGnEpfWZBzrjXHqJoCKqJJRmiAWYdCNRbS02dD8STBEkI8kP41iFR9OUTg
	 K/Trml2L4kt5vWmNtX3Ntov92t836Zp8uLrL/cwjugequU9Ta2rD+L7KqUJfwBop9n
	 RuuiDwA5g4tV+m2z65ABjUeku3fknpLlsKcvdO+umd/7qq/uvR+IbCF6/pgGqqSwbo
	 uqfomfeiwRbe80r4ADbV+Pe9XyalGhQ6mLij5HXgCKPRn+dWudsqdsiTKxHTisCkeq
	 TKMFXjQL1jg0PMNJtIuDaWXAwPoDtsKrlqgz94Omgzbx+89d6WRhrmK+vImCBWHIQx
	 7QoPHPbH88SEQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 00/23] mm: balloon infrastructure cleanups
Date: Thu, 15 Jan 2026 10:19:50 +0100
Message-ID: <20260115092015.3928975-1-david@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wu6jzc6cqzq9jsfu31qrjqm3n3yg83r3
X-Rspamd-Queue-Id: A72CA180008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768468825-795884
X-HE-Meta: U2FsdGVkX1+3Xos+roCIzWhkC/VM/Tfp0ZLSlqQTxPty0dR+Y85E3FLGLiiTuQMzItieFtcX8iCfYd8M0PjrJLpPiUGO3QQg8hKnzNqT8ISMfQyTrNH1jiJRqV2zBM0AinKKmE5lLhYyAnmnn0abqRayAaZOZG9nDeFn8LN9tM0SRvaZHN197DwXXPSIpZBdJ/GKqNhTGqR2nD76BzC5V/IMmg5sGx0nfGc5Jjv9y6lqmgcTd6Y9ZH4fQpYZVa393yIllUMHKL+VQ7KxgAvSD7w2O+oGGH0QkTQNxzAQ58jJc50KKW2Ua0XjIs2S+R0Vd/Z9h08ApCawqmAkPkxZpVUI7a4nD/m3pbWRU21lhZ9MsOYBjElCa+uGj9R4gAa6r4l1f7QA+6GZUClC+mYcF3VZ3oibdGIFTM71oa/F/fF8ubehOChzn25gPOgNZl9730GQUQpN97xfJZuoCAhKHJUEPH6pUCt4AsuZKICw18L4gNRAkhe7/88ZbHa7XBaEAp1C3oz2AK8vL/6rq7VX+ASQA4L8SK1opQoARRxZDodVtOLDT8mbBQ+Xcl506JlDgXxW2yAPDm8geSOjEbBReRVz29XC/O3CL2hJYsEE696tbhWEQfbNQwl0zAANGk+asCHONBtd1DfVMWrlmZ4iU4VGc7RReczsTIM21eiSFoVSXpzSa34wjNFCQ20oDWBCxbTnqQ4hqSYUdfD0YVMW+mM9cV+/nvrXA49K2Aw6xp2bm/q3m2hQHNofcSRmxAWhSMY8nEh0+3KedUGSi7DyhyCGy+0YGS8jIwETGofK3fwbd5TirghAwR3zq5TNigvQwvHkTgNgNF6z3WOxAZdgyEbdqK6LwVDUm4nUAuDYTstvy2YOuiVHH+Kgs2QxTRV9OyiuRlTbIr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I started with wanting to remove the dependency of the balloon
infrastructure on the page lock, but ended up performing various other
cleanups, some of which I had on my todo list for years.

This series heavily cleans up and simplifies our balloon infrastructure,
including our balloon page migration functionality.

With this series, we no longer make use of the page lock for PageOffline
pages as part of the balloon infrastructure (preparing for memdescs
where PageOffline pages won't have any such lock), and simplifies
migration handling such that refcounting can more easily be adjusted
later (long-term focus is for PageOffline pages to not have a refcount
either).

Plenty of related cleanups.

Heavily compile-tested and heavily runtime-tested with virtio-balloon.
PPC CMM and the VMware balloon are untested and I'd appreciate a helping
hand from people that have suitable environments.

Not CCing maintainers for the vmscan.c and migrate.c change as they
are rather trivial and I don't want to patchbomb them.

--

This is based on mm/mm-unstable.

v1 -> v2:
* Rebased to latest mm/mm-unstable without any conflicts
* Minor patch description/subject and comment fixups
* Retested

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>

David Hildenbrand (Red Hat) (23):
  vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
  vmw_balloon: remove vmballoon_compaction_init()
  powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
  mm/balloon_compaction: centralize basic page migration handling
  mm/balloon_compaction: centralize adjust_managed_page_count() handling
  vmw_balloon: stop using the balloon_dev_info lock
  mm/balloon_compaction: use a device-independent balloon (list) lock
  mm/balloon_compaction: remove dependency on page lock
  mm/balloon_compaction: make balloon_mops static
  mm/balloon_compaction: drop fs.h include from balloon_compaction.h
  drivers/virtio/virtio_balloon: stop using balloon_page_push/pop()
  mm/balloon_compaction: remove balloon_page_push/pop()
  mm/balloon_compaction: fold balloon_mapping_gfp_mask() into
    balloon_page_alloc()
  mm/balloon_compaction: move internal helpers to balloon_compaction.c
  mm/balloon_compaction: assert that the balloon_pages_lock is held
  mm/balloon_compaction: mark remaining functions for having proper
    kerneldoc
  mm/balloon_compaction: remove "extern" from functions
  mm/vmscan: drop inclusion of balloon_compaction.h
  mm: rename balloon_compaction.(c|h) to balloon.(c|h)
  mm/kconfig: make BALLOON_COMPACTION depend on MIGRATION
  mm: rename CONFIG_BALLOON_COMPACTION to CONFIG_BALLOON_MIGRATION
  mm: rename CONFIG_MEMORY_BALLOON -> CONFIG_BALLOON
  MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT
    - BALLOON"

 .../admin-guide/mm/memory-hotplug.rst         |   8 +-
 Documentation/core-api/mm-api.rst             |   2 +-
 MAINTAINERS                                   |  12 +-
 arch/powerpc/platforms/pseries/Kconfig        |   2 +-
 arch/powerpc/platforms/pseries/cmm.c          |  53 +----
 drivers/misc/Kconfig                          |   2 +-
 drivers/misc/vmw_balloon.c                    | 105 +++-------
 drivers/virtio/Kconfig                        |   2 +-
 drivers/virtio/virtio_balloon.c               |  64 ++----
 include/linux/balloon.h                       |  77 +++++++
 include/linux/balloon_compaction.h            | 160 ---------------
 include/linux/vm_event_item.h                 |   8 +-
 mm/Kconfig                                    |  23 +--
 mm/Makefile                                   |   2 +-
 mm/{balloon_compaction.c => balloon.c}        | 194 +++++++++++++-----
 mm/memory_hotplug.c                           |   4 +-
 mm/migrate.c                                  |   2 +-
 mm/vmscan.c                                   |   1 -
 mm/vmstat.c                                   |   8 +-
 19 files changed, 314 insertions(+), 415 deletions(-)
 create mode 100644 include/linux/balloon.h
 delete mode 100644 include/linux/balloon_compaction.h
 rename mm/{balloon_compaction.c => balloon.c} (59%)


base-commit: f8ed52ac0cfbddff992bb9600941bfe51e1e385a
-- 
2.52.0


