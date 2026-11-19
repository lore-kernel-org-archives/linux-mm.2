Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077D3606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IwTqf+a1
Received: by kanga.kvack.org (Postfix)
	id 19AE16B05C7; Thu, 19 Nov 2026 07:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173666B060B; Thu, 19 Nov 2026 07:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061826B0626; Thu, 19 Nov 2026 07:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D32B66B0623
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:02:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 710DAA88D0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:39 +0000 (UTC)
X-FDA: 85451731638.08.75A67E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12167A000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IwTqf+a1;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089757;
	b=T16jjXhOwOL6CLeBZBwCUa4Kx4TCd4t9xNDXpqFzQNiMDL3NRpvWrG4U0VfFS2FJ+npO7y
	w0DVyLPWuO56VtZXNYArcosTNUZ3Cu2JaYZLGgjRVvwG+e6pAZRv2FeXmiSxLyVe8WMwSL
	04F6bx0awdZhew+JSgQpJOekgpe03JU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8HieDkcA9JIiulz3WEd2PXLQt0iI0kOA0dL+f71dJzo=;
	b=kdOg8TMQ2eTusATXU3uw+ofJck1nXU2iybAJRm/7jGfDTPMjKe5ufq7axmZh/hSXRLrzsH
	/ZDPOt0rkWwwt/AYTDTt2sXsts31V8XWA8UhEi9iK6bDL0ItJ+luDsp6R0KFP6PEp716U0
	S6jyaeRBpSjI3w+RWmrx04fCbtlcoq0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IwTqf+a1;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795089756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=8HieDkcA9JIiulz3WEd2PXLQt0iI0kOA0dL+f71dJzo=;
	b=IwTqf+a1CPoAY49dSGVLucb4wOQSHRPdgkbZdvB6XF0SyR+Uh5TiV+UqepGSC5+LmC+2Ov
	dZLEdcPALeCrOpK6MKgPnU3sb8/vmrUoKl6W/ACu56zujwj442BGLu5UTVZ+GV7mnlkzii
	7NYkKM1fSuNM3vFutIuhYdKwRt23M+Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-22geQRpuNuuuzAmIXVhF8A-1; Thu, 19 Nov 2026 07:02:34 -0500
X-MC-Unique: 22geQRpuNuuuzAmIXVhF8A-1
X-Mimecast-MFC-AGG-ID: 22geQRpuNuuuzAmIXVhF8A_1795089753
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb68a5e792so5979545e9.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:02:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089753; x=1795694553;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8HieDkcA9JIiulz3WEd2PXLQt0iI0kOA0dL+f71dJzo=;
        b=Rvcg8deyG516OOCr//C4tAgmbYOTA0yQDsz2uvBuEBe/uBoKP7SPDl1BDF+YqcergZ
         Rusb/E2rF70UYo9WsIs4axi6DYqAxsxljOKuhxev5PG7iUhN2Xj9ZFK5JFPrjUNANRV8
         d28BBZ7lr5LSJWN/2OvRoHwDNtbhm33e1a7zTXXx0GzXpfHY9T3AI2RM4qsSYcLnxtrx
         LkLH9xMXZ966JGIaZpRw6jx4GkOwkDOYK56oRHloPQ+2evDVZ3TDwK6mumV2gOpW68Uf
         OcoAjxiu8CxaqZ0Ie5LMVrYq7gxkpPhzQF4HEa67wwQN0WZIy1Kqb8YrfTuF+5mbmu5K
         +glA==
X-Forwarded-Encrypted: i=1; AL+hErHMa3txTuSYfN4R9EWHe1fZ/GwDMv98yCSNgZjVnZcWBkI+8/zga9KYVeVrdA7yyJi4Or0Zx7jfAw==@kvack.org
X-Gm-Message-State: APuU4Z8Gmr8xVvwbMq0HH+67x4tNk5s3czck49gxUIlaL0CVUddksrWu
	HOgUTDAvn4qMobengC6EVpTKmSoOwoxFC2zTtzzNYW4eLsFb6fmYb90YzpcVOkE7HMZB+EmL54F
	tqr/3BTDpmIhW6PqEQlM0I+/kM0/9TD9jWAQEv4qkCD6KZqcRCTJT
X-Gm-Gg: AYBFou1WxFB8D1z+zk6AzJuOUnXk4MFh8rLLysawLSQmB206vtM0hBf1qRZrHChCEFF
	QRy0zhaIuapKbJ6bltOUwicBAnvK13iaMWrTFJM+UBalYWvER0+TpJcbKBSEXkOuTW/RzcBHEFy
	+ysYnzhkgOtKWPZmgD5LA7QEBAyNWMZ7o9PDZlBXLgSWNQYoiSsPYQVfnaNTTA3uUAERy5Fz5hK
	G2OqlpuO+GtRJRrg7e/HRH1U4mN2OIfmy9z25kyqw3Xzw+mcaO6EhTrxDxwp/HVDc001Uui2Xxg
	YWRa93cJ+v0xthOWQwr+8rGPMDUV5V+31raTvLUtpCNP8CHwzDT6RfWPOpg7JvQZePk4bBDr57U
	11uchsv73/jTyW83DAjGXqjMH2wHSLUhLNuq+uuXrvf8=
X-Received: by 2002:a05:600c:37c4:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4bb8611ac9bmr19486985e9.13.1795089752541;
        Thu, 19 Nov 2026 04:02:32 -0800 (PST)
X-Received: by 2002:a05:600c:37c4:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4bb8611ac9bmr19486165e9.13.1795089751833;
        Thu, 19 Nov 2026 04:02:31 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm37547505e9.11.2026.11.19.04.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:02:31 -0800 (PST)
Date: Thu, 19 Nov 2026 07:02:28 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, virtualization@lists.linux.dev
Subject: [PATCH v11 0/7] mm/virtio: skip redundant zeroing of host-zeroed
 reported pages
Message-ID: <cover.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B_tShRW9Hc1eDfhql5BkWJRXsOBwM2Ru2w-DEezE2u4_1795089753
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12167A000C
X-Rspam-User:
X-Stat-Signature: yyys8to5dcygrpehasdbjearyhm59myc
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795089756-796058
X-HE-Meta: U2FsdGVkX18K4+1a7Zjf9u8tHbU9EB87l1j1t3n4tV4n8/MGZhgBA9a6vhHuYtD+XweOwbXzCwMu2yDZ6gb7NYxMezTr6BXkjKDI/jbymv13bIcJrfKanTMWRF/7Ex1OfnmUyVb7JQyPDv1c1JA8VfT9pt3d5yqDSt2mMbZMkzMX/NkrNhbvYUyqAdnH0zMCfUwFQgubbBXiCWG7qn21QMtxgsZcopkGcsCjujP4gOnddKu54axMoOmWuyZaCEF+YSIc6ANH1imbr7+eQNEP2ZNnDlI8HUp0Z72qMq74WjsL2xw0h4/bp2aqZU0YrnkUu22QgPf4PFlN42R7IYN+VG+fnzDHfpGhJbDppfOBVA34yWnH6piYdsJsKRJNNcQ8oE2bNNJY7wuDCs6jernH0bS+Uz2HfFJ+UmSawLPNHWtnxUN9miVXq/n035q9ISsF0qHHsU3JTlTE8Bcmh/b3rhSbdMMNfC/cSneLabu5DUwvmw4IaWT8sZHpL6yb/UnmtVkUP9PvsDFmJXFJbWk1IYdomfcLg6zggMXoTxWwn2UCtFanWlngN6QwdNoJXD3iqAPgTPFA692qsxARi0sjEpvv199o2M/2941uETQobexNNvo7n+msB4NGeLwH4j3sB7RuytVUgF8yGPHt3RrlG0UIsn3smwCtKGUZffCxxrJLm74aFqHgHIXz9ERZ+MYi+ZlqG9V9n3ELfOL/sAQqGhPPn7B5DDsPr3qfq8LHTk7NTaTYpD/oURUR6yTdsIIu34jIbnrFSQnffAK/vBSBmAJO/qLs2F2nvHC8XdmWZDL6gkRIbL2fzNejhGORHjPloQMUULdt/O/3cf3b5ZVBx21QWmyRvu9TvgXbIM08HGAbJL2CJHf3Q3aUWVwLdF3QfjMSIMw12yblVldAG3r8fEAjRBrVOlOveF1BlcMCa7fERk8jlvInhDeyoaS/MvxckJVm+9FCXWsWauGoQEY
 KMmqNT6j
 JPDbowcHpKOlHpEQtqQLItFSTLhA6Q+w5aYsNjmklNWGOQ8SmT012HqAMMjmHPihukC4w5SwnOsqDt7kY5N4iwNN2I+RBRNayQNp04ILGV0/skCd8MkKnLMy8NwfP/M90KZDf37HIhmTVX+tQ9GW/70frBEbGQ4uzDinJzwnH5nHNfRy34pgx4Xq9TQnwPx1V2i2WWHSXkKmbRPOcSLi61XqHJ5898biJBixucXxFT+qkiR9ONgVQR5b6cGrVtqnrWkGflUI9y6brQMktG4uzQft2g+Z4CKzHQNj2y+MuJejWmW8JCZOR1rBlGRJ8TF9gKPazkSXTNzH9DFzg3oDco8Ea/2JFN2CLEwBlZkmDhHIyd5tdq/FiX5mVl/K4XvULFJ7hXQfJmcrSmF+Wzu8OxtOrip+kJWG7pqC6+NZbE5+Ru0YznaxiH6r+CWX8tj26KgI4ubiCU0ggENsCva1YH894jBJ2EmXU/k0hUaxCgYHutnRFJpnKeUFakI1zAzHibXvnK+SV6XCTMSU8LjxQYNSUd4U8EDUnT19v+Lkvk2yVMUlEPzkNFSpk4fFnZqGt7gNSgMZ39Af3A8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Many hosts immediately discard each free page guest reports.
This means that re-zeroing them in the guest after allocation
is redundant.

This series lets a page reporting device advertise that its completed
reports guarantee zero contents. It tracks that state through the buddy
allocator and uses it to skip clearing freshly allocated user folios.

The series is based on Linux 7.4-rc3, commit 666539eecdf4d.

This is the first part of the project. Further hugepage support, along with
the init_on_free and FPI_ZEROED additions suggested by Matthew Wilcox,
is left for follow-up work if this series is merged.

Patches 1-2 add PG_zeroed tracking and the page reporting device's zeroing
guarantee.

Patches 3-5 skip redundant zeroing in the PMD THP, order-0 (including
x86), and mTHP anonymous allocation paths.

Patch 6 adds VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED to negotiate this
with host.

Patch 7 adds a flush parameter with an approximate reporting budget for
deterministic testing.

For a 512 MiB anonymous allocation using MADV_POPULATE_WRITE in a 2 GiB,
one-vCPU KVM guest, ten samples per mode gave:

  task-clock              feature off          feature on
  PMD THP                 229.0 +/- 20.0 ms     74.7 +/- 35.8 ms
  order-0                 336.1 +/-  6.5 ms     99.2 +/- 19.3 ms

Assisted-by: LLM

Changes since v10:
- Rewritten along the lines suggested by Matthew Wilcox [1].

[1] https://lore.kernel.org/all/aiePVsiV-w-IZ8A4@casper.infradead.org/

Michael S. Tsirkin (7):
  mm: add PG_zeroed page flag and buddy merge tracking
  mm: page_reporting: support host-zeroed reported pages
  mm: skip zeroing in vma_alloc_anon_folio_pmd for pre-zeroed pages
  mm: skip zeroing of pre-zeroed order-0 user pages
  mm: skip zeroing in alloc_anon_folio for pre-zeroed pages
  virtio_balloon: add DEVICE_INIT_REPORTED feature
  mm: page_reporting: add flush parameter with page budget

 drivers/virtio/virtio_balloon.c     | 33 ++++++++++++++++++++--
 include/linux/highmem.h             | 29 +++++++++++++++++--
 include/linux/mm.h                  | 32 +++++++++++++++++----
 include/linux/page-flags.h          | 15 +++++++++-
 include/linux/page_reporting.h      |  8 ++++++
 include/uapi/linux/virtio_balloon.h |  1 +
 mm/huge_memory.c                    | 11 ++------
 mm/memory.c                         | 10 +------
 mm/page_alloc.c                     | 43 ++++++++++++++++++++++++-----
 mm/page_reporting.c                 | 43 +++++++++++++++++++++++++++++
 10 files changed, 189 insertions(+), 36 deletions(-)


base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
-- 
MST


