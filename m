Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E91BD2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557F66B0309; Mon, 19 Jan 2026 18:01:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F896B030A; Mon, 19 Jan 2026 18:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458C76B030B; Mon, 19 Jan 2026 18:01:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32F576B0309
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:01:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3FCB14030C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:01:44 +0000 (UTC)
X-FDA: 84350237328.03.8F2E248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2047AC0008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:01:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RftC9SBk;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t4IKtjKIPaTyUPeC+tbAFZ1mfWke80YUyMIQ3D+uxWg=;
	b=7px4xO2L1hrzJ2p9S/OukAnSLABlkz0MPOhm4Pm8wyGj/BTFz2RJBrwsWZSTjyW4XdWgS1
	iD8fvL0iZ9cvNgKM3qNVdmzdig6Sd6GnP8gR9ykM3WDkVYf4+C+6E2rUQO5ZMSyO5sFFq/
	7KIm0DxFw+km5ZMHDVN/lK6zfXKyXig=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RftC9SBk;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863703; a=rsa-sha256;
	cv=none;
	b=jQlaH9rqMNwZriCTiCEvVAP3CK+B0pC1mspOZKy8jrMfqIbLxi/cCZqv31LXCCLB1GDjQh
	SuMx8YMh2rhoDNh74uo7P0/qv1W/qJpW4dDMhU1knultjWvpe/cQVsH3QhE4qwzHWWopUd
	PDQoYjYU5NXGzoUIfq3OB0QCZyEsvzo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01FB4434EA;
	Mon, 19 Jan 2026 23:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742E9C116C6;
	Mon, 19 Jan 2026 23:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863701;
	bh=pkO47DmDTlCVZ4qWJyLDetbEa5q1OzobH5egyxMl/Xc=;
	h=From:To:Cc:Subject:Date:From;
	b=RftC9SBkj9jynEzKvEsWZNv24oX1nY1eTCTvgu0zWx5vcx/TAqUodDraVVJ6yyQlt
	 jFCksuPGdnY0aN7o82O4UUhCSnO7fRapHqehFETIxw94lG3xwNmxThkWvhVpjmrJVQ
	 wTYFG8cXS44T/p0hca8aNArdiOczaKjFXYDb7+rWepH1lGYeEdhZ1E/OjX5iUTgOhQ
	 X6p31FWDuqzbxFyOsxMyhIDYJ9K3ewTKBRlJjOozr+b46wTyLd6JlbJ/6VzIUE3iUN
	 wHQ68zwSdazzPYKx+CNSTQu7vHgT2W1vhN/JK3oCMTxZAiHP4SjR9kWBCQe2s3GmZA
	 CwfqDt2NtDkTg==
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
Subject: [PATCH v3 00/24] mm: balloon infrastructure cleanups
Date: Tue, 20 Jan 2026 00:01:08 +0100
Message-ID: <20260119230133.3551867-1-david@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2047AC0008
X-Stat-Signature: xqxicg8pp3drkcufdqqnsrdn7dxa9bon
X-HE-Tag: 1768863702-627229
X-HE-Meta: U2FsdGVkX192BWrnlEhtHrnROsFxDDQwNhRTjlD0+seIhftS+f39c9fTKOmmXkoSjVdS73LIfd9TL+1S7FDf8vc2jxtzpKntHtHxvsHxpdw3e2agHSriCGOEXVRh53f8uXxCWOp7vEcdCH8cAxqsWz8WAomLoFOW6xYHtCD8g7NmVT2o6AANTYTduahykwCEhXh2rMgaS8vaKl90LIsntqoAIBTnEGg9NmlolZqsIBY5gRQAo0Lyjgx96Y6jOlX0HMSsVVaVgVwp5793+Omp7Wm8G62HfZ3z8sDaZlUY2lVcRrL4fCrh5cZR3exyygvpfdLz48VZqxBDY3tADjxzBeRBOP350mbEStg0woKEqYKY4LKBDCBLWZPlrC2+WDxoPXp8ll4h2KE23A7cUN/A79dHkDRtq+A8Uc19QCFgC70K4WM52EOBSUz0V0nITY35jAFxGyHc2sTlCWkrdT32Mv54tg//2JEi1dPM6R33baSC5OX/iBIOasRXREjliShvASmHISUMcqsJfB0FiHjcDHttsYIro2ECmQoxh8YfE5QkTqNn27IqpWdWlmhRxFiVbc/6rRUx6Mip76boOF/Ua5KXUUWSjX/igu/iBHP64FYsHbcn1tubrvw8I16MxtxJgZieKFiqBma65eb+yryyW3AH6uotuHuOU+e9OljL10AFN76T7TjHlxUTrOMFsV/6m09nCYjEBN9Y06Aof0o3BCdcVOQ/PDU09B/fWa/+vl8rM9VFcb4BnhHQGRJRUQ544+kH4DAuJkY4YNhkZn78CG4pRMfOedA1FRoIoTtRUkeMxhiBlPBrkOnkdgsXrLqsYmLdJFY41os/yrZrldmvx93t61zZF8XQOmugWD93vGo0JvTgiTqIz2JTvGWZhRtJ5Sf35SjOPjcMnTfwqEjKVJGFnZlTASRrBTI9pMHJUBqyQ7vv3GNmTzYXTHS7mI0rpNipBLxmFi0+NGraxOv
 5JUL8m1t
 +f/0Mj5EYV54f0uRC8lo10SRHCEzo2TMep4RaLFnZIrEBQBEIAk8+Z8anDfs16Wer7hDaekFYKqokN51ggzhAjpij4hlwmu2QJXN9YavUEWsIu1l8qC/9VtRYd1Rl6F2KKIF9oFGM7d/5oXwUoGXds3uuliBBsI+SYQN5JseYVgURnK7hlQ28lxFtRDUVFejOhON387/Fxsw86GU2ZEz2c76BCQftxwFwpm5D8MMyNrjRB7OLlO+ivACxif26cEhz3aCRzAl6RL6AL4qxrg3pUaNdf7X/XwEiy6l8Rbj5Uexp3zJqPtzQ+nA+SugjI/EB2dejTxCUmkYyLdcQ3/ibAgm4J1G6hMMz6K7/wgadhOnzybx3aMSEibvAACa7Nt66AODk1RQoIaxnClifaeVsp8vJpGsgG2PrgfrWWr1M+kP9V4QKSSmDbZtDuAZl11lZjTOs2pc+Itd14vJK5LWqfSt/CDfEkleauHzMrLM78hxlCNgeHLwGqngKF9JFQIdmd1pp9XW4yJdKCq0d1ESdZfCw3LJ1Zu4MB+E1pW1+Ld8rQo995CUhEYZI4aC2Zbt1NBmuU0phgnhkgecDgZjEt2q4U7h5fv2OWxle/b0+VWaA7IxBEkw17VUgeeI+syqOnOd9szqcFr7fCux4kDalPz1VdUpmmkw9b83aQaxsJFBpeKp/AuYUKvED+U+pcyS00YMh9rm5GUJezZXvg1C39JNnT55PqAuAojqGc1/dlR/e4JKJYQZM9Iok5Q==
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

v2 -> v3:
* "mm/balloon_compaction: centralize basic page migration handling"
  -> Remove newline
  -> Talk about "page" instead of "old page"
  -> avoid the switch statement
* "mm/balloon_compaction: move internal helpers to balloon_compaction.c"
  -> No need to carry over the "inline"
* "fixup mm: rename CONFIG_BALLOON_COMPACTION to CONFIG_BALLOON_MIGRATION
  -> Remove some more "balloon page compaction" thingies
*  "MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT -
    BALLOON"
   -> CC the virt list and use the proper mail address
* "mm/balloon_compaction: improve comments for WARN_ON_ONCE(!b_dev_info)
   -> Added

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

David Hildenbrand (Red Hat) (24):
  vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
  vmw_balloon: remove vmballoon_compaction_init()
  powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
  mm/balloon_compaction: improve comments for WARN_ON_ONCE(!b_dev_info)
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
 MAINTAINERS                                   |  13 +-
 arch/powerpc/platforms/pseries/Kconfig        |   2 +-
 arch/powerpc/platforms/pseries/cmm.c          |  53 +----
 drivers/misc/Kconfig                          |   2 +-
 drivers/misc/vmw_balloon.c                    | 105 +++------
 drivers/virtio/Kconfig                        |   2 +-
 drivers/virtio/virtio_balloon.c               |  64 ++----
 include/linux/balloon.h                       |  77 +++++++
 include/linux/balloon_compaction.h            | 160 --------------
 include/linux/vm_event_item.h                 |   8 +-
 mm/Kconfig                                    |  23 +-
 mm/Makefile                                   |   2 +-
 mm/{balloon_compaction.c => balloon.c}        | 200 ++++++++++++------
 mm/memory_hotplug.c                           |   4 +-
 mm/migrate.c                                  |   2 +-
 mm/vmscan.c                                   |   1 -
 mm/vmstat.c                                   |   8 +-
 19 files changed, 319 insertions(+), 417 deletions(-)
 create mode 100644 include/linux/balloon.h
 delete mode 100644 include/linux/balloon_compaction.h
 rename mm/{balloon_compaction.c => balloon.c} (58%)


base-commit: f8ed52ac0cfbddff992bb9600941bfe51e1e385a
-- 
2.52.0


