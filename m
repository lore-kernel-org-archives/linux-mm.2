Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9157ACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EACA38E0023; Tue, 21 Oct 2025 08:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DA08E0002; Tue, 21 Oct 2025 08:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24EA8E0023; Tue, 21 Oct 2025 08:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B75318E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57873B9AAB
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:39 +0000 (UTC)
X-FDA: 84022128078.02.17A46EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 48487A000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aG9ukBQj;
	spf=pass (imf25.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=omAB84zm1ZJJGkhLo0LBcnP4dZPVDNNrUkrD6enlyeI=;
	b=c854G3Euv3i7lNeIoS8fT7wRAsZCY5Kc7BwOaUg7XS6Fo46bSuEzRHZdcPzqeLRBHeyySw
	KaVj9Fr0b1tsNMgJVokgieiNDZDLTcq9QYCWHoEU5GBpzGGVQZtYe6ulIxTbl6k60wuw6w
	V8DVo6Va42bGxhHYjt4/vnpZCK35Kws=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aG9ukBQj;
	spf=pass (imf25.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051576; a=rsa-sha256;
	cv=none;
	b=xe5rfkiIOAy2qPo/h5UpciaWny1i8G/Ajh0+aCb8tx1t2fRZxpFc9pZE6qkbWjr+kMfWBF
	S6Kr7jVd4Z0yzXRfxYZJfCbQrl8HN5ZjtbKOdcg59TJtsnVqsP8zHaHOzWysfYV4vq3y+K
	ipSS7m7wn3MmIJgThXlbhcASWIajKGM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=omAB84zm1ZJJGkhLo0LBcnP4dZPVDNNrUkrD6enlyeI=;
	b=aG9ukBQjBk5GKfZEJ5+4xJWqUb4xddeh+AAm/v8I1t3d+n3EzI7AuyDL3CCZkXxB5VpF67
	eyR/ZgKVxiUYe8h+bhmMCZENyhmJKoHxiikL08QUN2wCJLKYayYH1Xa0M4E6P77a80xhD2
	e6X3C/Wc2QUa1HKuVnHAqzTmIdQ6HCg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-x1gQEQuwMZea_gnvaqLYhA-1; Tue, 21 Oct 2025 08:59:34 -0400
X-MC-Unique: x1gQEQuwMZea_gnvaqLYhA-1
X-Mimecast-MFC-AGG-ID: x1gQEQuwMZea_gnvaqLYhA_1761051573
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e39567579so33467815e9.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051573; x=1761656373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omAB84zm1ZJJGkhLo0LBcnP4dZPVDNNrUkrD6enlyeI=;
        b=H1mMpH5rNN1HZMl8ezOxuX5C3MJ6YwmUZVgxWUFHhGBd71dU3u36hE9N/iSreIQDCa
         3wEgsfDFXP7nJX9XH1c34aVduc95iTEazo7/WsnwhwiN8ElsTZp6IJFgeXUbT9YDAGdb
         7BYiQRmbceeHOT5xNrHbg9xwvETIa4GpFBACbS8FoJOpZsIOanmHn25feV5X4HSZWPOF
         S0P2eCcfrkfESNjMMII8yxsdsMTKTut+igAncmGh3y08tDSD2wtcgleFL6Tr5dR5J6Yr
         MU3eX0OaRzVptSv7fP/wCC+k5XiOB64UR527wgwlkuJ4DWsf6667mxoDKnKIbefsqocq
         QmdQ==
X-Gm-Message-State: AOJu0Yw1vP+Tr+/ciwrRWFZgbYLyWWVN/mA/K97i0dY5w1oc2BEon4ci
	3komDiDrxe23TqtNwoNswDHXprG5tItOEmXBKCOH+AQmy8imJeUjmwuxCWptSiHm479POLjkaXD
	uXdLgChgLqm0SJ1/ZfjjT26BtvhRMV8D137h3HFOELqLopqVRVLks
X-Gm-Gg: ASbGnctvYKmutYc0dl77fohnjkx31E5HIS/6q85zSAkgsC9Ox1WwGNO6pcpbn0ph0Al
	QpHgavYckpZd5J7v4cS8M3NVQb1iQ3+2tCsOh8byZtJ9ClZ+LcZ11wtAO0X411vgm0DY0WSEB5g
	1HTEXIFH+ETvdsJIDXLE5gnNjCJl2ECnfTitekUA78Oq0/Vd00cDdEmadwuerZAB+zBYxS/Yr4X
	2S4MnM2Jb3d8oj7oYScKO3ND1P3TNAypsi4pa2UFlTYJIXT+5YoOn1Ljramo2jlho6PJjWkr8Xk
	iW2LuP0qbe6MKuwCR/4eFtWK0V6bJrfEMgYGsmTLNPhFfZMGFRLsyazUnynAjmfju+DXSdnsMF2
	166vrjI41Hgh++pM3Yt84Hx3IDBbmD5XMfBd6S1guVVUUfZTLLXzmnpGwTiIU
X-Received: by 2002:a05:600c:3b03:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-471178a3ff6mr120309765e9.18.1761051572782;
        Tue, 21 Oct 2025 05:59:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGN1EuUZZ8R3FSSnr8qb9y2RESEr9jR6C/rPmGSz5JIIAcste2ucC0iMZFWCPlNIaKu6Wi9QA==
X-Received: by 2002:a05:600c:3b03:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-471178a3ff6mr120309195e9.18.1761051572222;
        Tue, 21 Oct 2025 05:59:32 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427ea5b3dabsm21210821f8f.16.2025.10.21.05.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:31 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v1 00/23] mm: balloon infrastructure cleanups
Date: Tue, 21 Oct 2025 14:59:05 +0200
Message-ID: <20251021125929.377194-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5BdEornjLwxJjMfJ5kH86weFFUNpPXkPk3B6GduPN-s_1761051573
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o6p5rryxu5cz39b73ioxndgpty439zx9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48487A000A
X-HE-Tag: 1761051576-543091
X-HE-Meta: U2FsdGVkX19VXoWJNAEszzAkRgxsf1eo19fqQ/dXfMpJwj2m7cN67T11syzgOVWV8l+dNi8l+Nug8eT9D773xTdvseEQzqj88cp6NLmgZ1lEM0IXO18UxiBb0BSZrK9+bR+Gd2XcNK1+0AcDNlUGYeMJmrPEcH1ug/aTIdJjDSQy2crPlAeKfjCUOJcwyRypIYC0JmyN/RXPVkcHbAPOH6lhU7djuvX3yY20fkWjn297BXbBu0WyJOtcc6M3aVvC16OpNOTB39Qm/m6oOAnAh206i8R3BqgmcLb7u+MVbDXSvWc6Imligm/i969kr1/kuFxfstVTnSuwu/pV0PFYc/D8T9FzJCsoW+DqHFKBfDmzj4qacRIdKHSGC8sqYciY6VSkYnsOQ+FPe7nILa3qrIo2akzXMTxz+85kYqXNn5vjvWrgB+bwt7Co0PQKifQ9gX19MFutk3Y7mPpacDMBuLB7zgGYPJe7dj1z3r8k1zVLFqy43ppwwtB5h1Mfq25Z441fV2TtpkOTpP2XuAYJJuS5Jf79hMEEo1MbuQh0e61oLt44O6+NyEJqC3r0nRgGGuFxJGKoeZNDrVFUQUahaIzw4AP0cJYdTgGGQf5C1tujfbk4mL9FgW6jWn5EYZwLsYZS3SAMT434ylqUaMEDq6Y5NPD7yv/ebq7zmOWHizF6029dssH9mvdeSWPW9O+HzfCVKZHGb1YL8zdSuuwEy2g52GyXH4/gjjnY2MaytvOeUDDmE4tB8eLasS7qXdq3aZEgZImrua/kgmEcQ28/aBANjoYZ/0DrXpTNKya8lxmsAlpLlYA7+9esC70tFfYllve244KytKTwdlN0Ejxw88dPx+N4Eklo2VEVvswiiOPPZJbo9Bt3iaro4a7m7P5hYPHkZj8BMY1618/Ss3lnrfuhoYDcWD6p+rUOL0XNtsKmPDxJYKWeH2fmEprxJX0fm0P1XOKnc1ZHUXLf1G+
 /F1acZao
 JiNCMucGo1Pe9/UTT/SrsoINHCCUp3vaV4znHWI6AnD3mHhFPLRBWF2AuM3WiqQ+pIPTIOo7tyerTzW+//CM9Wbnr9wG81AfxgztyXLaa+C2pjH8S14SKh6iTH17ymiBE/tmiBTXRAbvci/0yaf1ShNjWtfaQNKeM/QLCtr43j+9IShxZc8DjV5b/q32WLRLHdV4oeKibgx/R1yZkAZ91hXZBUa9PU1GREhEyOnXYW7XhVNfVD4rRdsECcOsaIaY/Teqy3II8Fe/vC3XlF6cbBRnaBDo3jqD8XCY5huD0IA8oImqpQS95d19qfT3hnaSVGAGt+HvmBRIEg1D9PiyqwNJts+5MhOYT006avbRLBhtjNRoD25/N1evT1B7o4OKTMoJFz6zc+P+//o09rTC1jeW/MUf1/X4/nkwHMg6g+jDDbNvIJKu+UQB/1wURlmtFRX/ACxOldqYNME6XDR3pTlG426X1g3i/Liv0NHe+tHI76Uql6Ry9R9ugCzLZc5FSw3Xtk0Nx6JomYg3M/kwWgZjsHRfkIIUpT3Wo9MGe16d5SpUPaFOJgAhKrW/U0QzXpTbtqfRgo1oY5niLlJUp42/8UZW7/adqduIWfVwa3+k5x94rc5H9P7wK0M58TgJLCr9wDGCPuWEUL8w/oob/qy6xTDDTQZRZfl7o2JBShE+jk55V/UNqTa6QdZJMq8Al0DBek+PO9FSrUMX48/WEzC3nPniWjkrw5kuD+Q9/BR0TqGiQnxorwJ42od8wSSqC7BfKBONQi0fztveT22+AmNTWNRzlRqW92nmdGzNQi7dxlyeS7aBK/K1H1uMlQkLfwIyY+au+hiToauw0zOPW2U7xnoguZKycsJu5qu4NsJXf37uvwARyDvophdaWnrIN3pyz/agjKyRt+eBuqzo4E7oz1afRCtfr2FlT679thPrOiXOFBlBqb/v10/UzoFA/STQJ/0j/ytQwbYcdtdFrpDMj6iIj
 rFODikqj
 qeJtll0+SWSTs08Ffq+pJdGuCULv3VS/NK4XowOBHG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is based on mm/mm-unstable with two PPC CMM fixes I sent out
separately earlier today [1] applied first.

[1] https://lkml.kernel.org/r/20251021100606.148294-1-david@redhat.com

---

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

David Hildenbrand (23):
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
  mm/balloon_compaction: move internal helpers to memory_compaction.c
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

-- 
2.51.0


