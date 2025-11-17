Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F331DCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC948E0028; Mon, 17 Nov 2025 06:46:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56DF18E0003; Mon, 17 Nov 2025 06:46:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA5F8E0028; Mon, 17 Nov 2025 06:46:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 38D528E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:46:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EADEC4E5A7
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:46:42 +0000 (UTC)
X-FDA: 84119921844.14.B1F8C0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 646708000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:46:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcATjcN+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763380001; a=rsa-sha256;
	cv=none;
	b=6QGDKwgPvrLn8EEz751j/RpotTiTAKIu8n8Ra4PcKQnFtmDtonIGXHKgMmZKCTXvNABJwV
	4z7wZUVP3YkxmOA3NGu5Quu0EkpsnQSUcf8SjcZuxVYBUEoY9vBVh+22y+XaEms4Y2E1TN
	oMoHsUQM2w3tbLF9Eh8DffhKn+KXOnU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcATjcN+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763380001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SZ4LfqJ8cbeym7LiGw7j0gblfh1Et28Z7cNvtLJVD/U=;
	b=7CMfHQenVvKymeGhbM1zBGSjPdSDDtFpLgsXNCeA+ATlrIZDdja7cG1Mw9/KUVwkLlmLWR
	HVbCII/3FjdyUwifzCokumd8KXsA52v/SuEH6IotcW3wKXJ3Qle9sWXpPH4lGV8UP0866X
	RYyefaVzsFmUYYegAPhLaDPko+Pz0h0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C14B2601D8;
	Mon, 17 Nov 2025 11:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA51C4CEF5;
	Mon, 17 Nov 2025 11:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763380000;
	bh=OK5ygqxzdiotqq5cLz9n/2U+IWjx65elS/OUqG7ov5g=;
	h=From:To:Cc:Subject:Date:From;
	b=rcATjcN+iuAISKl4OnTLnlAd5/bHbRBxnHEgJhCvLwjUEWn9lSdRTL8vTVIy5Q+77
	 4b90DdLwSGv5KWZ3um2LjzQo8SuRQ8x0bL0j44Rc+wadMo7fT5q3niEw6gjlaFD5wl
	 fAlbtcFN3Sk6jzrfsRbm6TH4WUAP0FAosPJgb1zn6jaeoQbsgffZIOIDSarPmT/8Pu
	 FWlR/ARZaxrvBLhHCBbkco9pw+oD3v74RG1KOqLtmAjOT2e6Hwcb9KoBn+TcScCHid
	 wDeaBHn7AueWPh8+zTkJZ+daPjt/kJXdkW1Cx1V+wvPf6t+r2+BKVnE/VQY4i2Nzfx
	 O+U3Hb2SFkIoA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 0/4] mm, kvm: add guest_memfd support for uffd minor faults
Date: Mon, 17 Nov 2025 13:46:27 +0200
Message-ID: <20251117114631.2029447-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 646708000D
X-Stat-Signature: 5tna9oymfx3msop4dcfjsbyaqaey4ein
X-HE-Tag: 1763380001-665400
X-HE-Meta: U2FsdGVkX1/XgDVZ9tbjh1W0D0sQkqwF5UrrK7tFz59BuRa+HI6J1NvHKQ8SDM4I0n7jXxS2sK6s3HcQkYT5UY2mlBBWEBOV1wSAIrOmMZ6uxVY55k2HFxa0N9qjvhHTiyNdOLnVCVViw7AfIjJPUGh4ZxqZKwjMs+oplC3N7BIQIXGGnDQZvWhInZs+ENz80/1qNHtuJdzi4tmXXVnmGLynH3OqIsMgh3uwTY1/agiK92B7SREjwq4QoYakhYPoMgsAn04lIpiMoqMCHhedEDogWHrAD4mBg9tgvxCNEO1UxVMJ4KhUwi5sXpVQC8Tevpv1/SFFEL91UuS7+BKpM6xrLqMAcB/tvuK7uXW+GDIz4JpRuJrtG16YmUufgaQx15nQ39TZsbbwYrT/BqgROiOPnk0StmyX4iOvH8UpZfM3JI68RWiC6jMPec2MAxK9hwvikGoPkx5XYcfTW15F00UNkKOotw1zkEZR7polHjPlV+uevxrQFOnrFVw0LjE46UBkLBTgDlDthSQ1lzoHE2FgUa40I2PmetlfkZohVxXPe1PalnRBJ3q9JpcMDAamES+KfKYC5z9U4IRQ111DH6QIe06cMuFxpVV58fQvfv6Epjv8I61IiNM2RyTIV6q9YmnEaBI7ayWnD11iN1mF0wNG6w4OMCdKTulKj9ElkjG/iP4OaBLYvRTGEk9GwsDXgwzn1pjmU3xw7oCDg+FbJm49LvczsKzGMXm3iQXNGCjVYmOogIgWLVTuCXE2D30Q/3HnEj+nl0zI4L0f4ITtS2UVLmR1cB2kny4bcUjIXB+f+FbU9R4OVBtvasMcf2z+LWE3r2/nUmqkBx0XfwguO8tNJLWNKGAcWvbg9WXL+Sm+pknLO4TYpwWluyAbVuJJnCdIiQlyimXmw6QwMl+jOuZuiGilv4qnvGGIVYfopaJ4J9cf/E1zRuJISq/mjdmTM9/THhQHV//1XIJwWUQ
 R7D8FFiM
 Ugrmq59X2gR/hmDSuOLp+SqH5L9KFQ7ls/1lNEGabc2QE+4fNEbTZAXk/zpCHFRCKkC4qIh2KNgI8v76GbFNMju+hSRkwP5r+RTLncf5Rzi6/sxiNCRCBi2ZfRFE1S/ihXwFgXcmfzmARSYUu96RY8UaiPyFqEEMSVnNuGgu6NCv5AiyIW55EaoAQcSKi0QoRXsXOYzOgy/RPzKFaFvxgqI2CUarI7EmZQNlAZgIyCJ7Iv5yN/jZb8ruid6/MYz7YwguVbzjDLxsx8AjTSjscB0AaVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches allow guest_memfd to notify userspace about minor page
faults using userfaultfd and let userspace to resolve these page faults
using UFFDIO_CONTINUE.

To allow UFFDIO_CONTINUE outside of the core mm I added a
get_pagecache_folio() callback to vm_ops that allows an address space
backing a VMA to return a folio that exists in it's page cache (patch 2)

In order for guest_memfd to notify userspace about page faults, it has to
call handle_userfault() and since guest_memfd may be a part of kvm module,
handle_userfault() is exported for kvm module (patch 3).

Note that patch 3 changelog does not provide motivation for enabling uffd
in guest_memfd, mainly because I can't say I understand why is that
required :)
Would be great to hear from KVM folks about it.

This series is the minimal change I've been able to come up with to allow
integration of guest_memfd with uffd and while refactoring uffd and making
mfill_atomic() flow more linear would have been a nice improvement, it's
way out of the scope of enabling uffd with guest_memfd.

Mike Rapoport (Microsoft) (3):
  userfaultfd: move vma_can_userfault out of line
  userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
  userfaultfd, guest_memfd: support userfault minor mode in guest_memfd

Nikita Kalyazin (1):
  KVM: selftests: test userfaultfd minor for guest_memfd

 fs/userfaultfd.c                              |   4 +-
 include/linux/mm.h                            |   9 ++
 include/linux/userfaultfd_k.h                 |  36 +-----
 include/uapi/linux/userfaultfd.h              |   8 +-
 mm/shmem.c                                    |  20 ++++
 mm/userfaultfd.c                              |  88 ++++++++++++---
 .../testing/selftests/kvm/guest_memfd_test.c  | 103 ++++++++++++++++++
 virt/kvm/guest_memfd.c                        |  30 +++++
 8 files changed, 245 insertions(+), 53 deletions(-)


base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.50.1


