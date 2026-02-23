Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FD4E98DEE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1C16B0088; Mon, 23 Feb 2026 02:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F136B0089; Mon, 23 Feb 2026 02:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5311B6B008A; Mon, 23 Feb 2026 02:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3F46B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:04:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B7C48C61C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:53 +0000 (UTC)
X-FDA: 84474834066.21.FE9A598
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id D3816100009
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3hlwkAOI;
	spf=pass (imf05.hostedemail.com: domain of 3EvybaQsKCM0tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3EvybaQsKCM0tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830291; a=rsa-sha256;
	cv=none;
	b=XxpMp9b2vSXxKvBHqQdJpq6VpgixC/V7Naio5CjunzEFtGqilT/6/Ajf/xugzbk7TI9np+
	p4XLAtabP5artgGRmfenEhMRY4kf8MOa489lsGj89Yoy6SJY7IM3CLt728yhUeCrL+j88y
	mlSC2ku0ETEjlx8O2D16Yg0MeuGVPSw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3hlwkAOI;
	spf=pass (imf05.hostedemail.com: domain of 3EvybaQsKCM0tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3EvybaQsKCM0tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4ACR+5opE2f1Qb7L32b78WaUJ2hKK306WtP3f4Mrpeg=;
	b=66m7A3IzUTQ9TmPzcnRKml5BJahfRO1af6vKJRlx9rGwEwV7Dvci/h/PBmd6KI2Bao8bHV
	VLMdQnVAhZMXcg938GIZhLo0FOqlUm/sl33rennz6MPsmbKc49WW32+weeOl1vDwaO11eT
	7nx7BUgjKyiU8zUD5qZ/m2jl+QJTTKY=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-824ae2cac9dso1806902b3a.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830291; x=1772435091; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4ACR+5opE2f1Qb7L32b78WaUJ2hKK306WtP3f4Mrpeg=;
        b=3hlwkAOIU6g6Q7YK7yaTWi0nLZW1o+BbRaYNUMCsVypxBkh1rqNsrDd/L9RyB7TGkw
         gEE/oAyDPV4GRILriW9KTtUWIA+DaIcU8olwvhc8IjRJ1Wfz3cNc20SHkhNS3HPYHmjV
         Z9w9Dz6WFwDX1o/q7PNKxKReH7t4MPVyD5ehw5MIDXLSpk7t+vjdqUD2DIaCepBFXsMn
         yd3rG0WKYChU256ES6uiJVF3p3eLeM/UZvFBRjB0vwgLomcwM6G5FZr6w1KwGdzzx/9F
         +FE4uABjFUJIlP/PV0xKhvL8NRcheFEWK+WM/4ByMj66d+3pJzlMWI6AfewRS/T2waj6
         ItkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830291; x=1772435091;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ACR+5opE2f1Qb7L32b78WaUJ2hKK306WtP3f4Mrpeg=;
        b=XNDULDHIfdjVOD/1vVhJekKrybQrLI8+v9qWVjz+cZOw3Ev8rNkQkqd5knbBU2goqD
         l0cQl13u2PuBAOjWX9NuOMSoZZYP5fezbFkmZdLWC9XqmEY763tglfq9fdG7BwVmjOtJ
         noyxXnw0BNyQKGfzP5Kd8Luj1Tc0JqfCl8HA1UAV2Z3CjTA3OdMCfWOBuerht1YE7ioe
         xZs9M2PVZPtFlVezkfRP4jX/BHaSw00aTKBr/iPqzK1BWUaHfKWRreeEnZTZwCLzrPi5
         SB3g9HqFIAbMVT00dX0LC/pwXMvkTWzCiq9TPkDvgx2RWZ2T49QK80b6ffRiNyWStZYv
         m8Qg==
X-Gm-Message-State: AOJu0Ywlh9/lmmwmqnrd7f4iyJeQSlrza/gJqA6WnQFITfdgzGrQruM2
	s+4dqUwVWAd2TpxT7azm/zd0kqUcZDnUUuWfSPwoXmv9MRIgnQxKYliY9pFbGuUnj5a2IpEb3pD
	D3okfwJQkM6rTi0tjUY9minnJq1WF5BIKu3bbykCYep1Sx1fIcLPh6UHPw1hP3d0jcqGr4ZMn1w
	pworSXjXIktXaKfYm6QQM/4VhvNGPI8BGhFRgVDLhD100gf417Ml3phSG76A==
X-Received: from pfbgr10.prod.google.com ([2002:a05:6a00:4d0a:b0:7b8:ac8f:27c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2ea8:b0:823:f04:e89b with SMTP id d2e1a72fcca58-826daa5de1cmr5219573b3a.48.1771830290192;
 Sun, 22 Feb 2026 23:04:50 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <cover.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory allocated on inode
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D3816100009
X-Stat-Signature: 8ictyimyfjanxtkc6yt4yw5iok1hot7r
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771830291-500313
X-HE-Meta: U2FsdGVkX18KV3JIyLWI4XDt0JqoHWs7Q1RREXuF3cYcKI+gBNacTIrdZRKaknW+n/MYQadB6YnE8Z6GXuqS835rwUs1fX8RDkUlXfaVj6vrlr9GESsxXQNKXztPgszs82c5nysFGGdPRmkUt8spdPJPWvHjJzE02T+NIVgahRvwT9qSWzchnqxqP2rZLN0Lg8rgcG/61EqcntDumgS7gO+riqaG8+cUnbou2kWnMrpH9NqIJAES6ZzddJZycThCgc3DXhJFXtsCp5b5OxXQwgvsayboTaNf9ZoB2rWo3xRMfjtBaEiCPsCAQfx++HqTA8W8ibr9bDKWb4f33RU66XOtRyrK6ZHH8E8Ia1pRpiZ2+VpBG59Q9AZ7KImOfsx2q52kWmcndrpYgTKOksvu7SXS2oeKRRWrVJMB4EcUdpv2SMd3DMQfHqWsAY6XSe4UT2qQdNylE8WEptfwp1l2HX50aXRa/y/m5de7JLiS6NYyduwtPFNb+F/0jec3P3dAUil8Xm58zRuFu8wT7Pj3CPt1Mt/CS+aYXummMpXKEJN0hgpwgIo+QyBbNKVnKxNxjIcK5WmEQrahXia9OWh4y9RK+8KTaewa7kbYmX1ak1NwvUpDw56cOKETKx0+acG5WX+5i0H60sao8kGKH9hMFi+avqWzwH508JZ4Od8w7e3Kvsz8xxIqCP0S/Xsvspv/Rlziu8n/IHmv7lJiyghDPadYmyqKx9eng/p8gMXXQ+7nxEq34f8QmvchuzbfgKWDxtnaXHsckrs2P/ROolhZHEj2ieItgOLj9bkCN8qD6/FFQGiO9wnVtDKF1S6a3nXnnhsop+8nSJ6LYH2b8J8SRQv5NWqOWm77zBn/4BCESp3mAubh3yJVHuXjC48vZ2vxzybqTBtzfQ6PYTb/T8ZxfmZeJnZGUr6Kk0hPhHuvvyykNHz/8XocZC7WqFkxKF1nvMKBqryLO4hK9te3ERR
 HMLebGOx
 AaICGC7CvMSLj9vO1OSLStLygFLq1KreZPf4yOvHPSLJ49xXsXBEybaOxaCjbBmQegGxh/AblPYXbxC0XOcNMsh1GynKdtURNnEWXUe95KXNUzBhk1cojuwMyaSwyB5+RDOuhgm8QlBMsv69zIO/hqGijlwtoDpcdcW/z8YDKsVKNQnE7sn9oE+ceqSMmFBnhG6HQ84ZDASs8CrbiHnHBe7G5T8GZi0ArweRdCEbLc3rjd/evJ6NcVwaeaEQdiUByxOLzREp/qEyOPWzV+CtuU4D8LhzkqcC+7dEYmU08U9gpfDdCyD7LrJwwg4YC7sGcVkVl1Bl0vddM/F2ITdeQOBgfffFLqk8oNX494UpGlEeq+kpG1vp5mFLn22FmA39s6KXiH2UN1oEyINs6kUQiCeCLojV3JRLE/s3bD3CtZVeYu+JKsmbL+17blFAHo81RBbWkaIigoUXQI127kRfKuSa0a9F8jtNNd/YEZ0eji9Ly4/KZQmhDo/mN0p34ImV5Bm5H1ZzUP0HJyGtxSLQHOv0Ia/lVJdkCc2SZ1sKw61ZFB8Zk7KknvynfrVOIlSJGsOu2GjjQfvGpeO1TqjwyjZQEgt6Q7qMJ2oSTGCOhxmdm2C5FrO6zHolEWEQ9dFsjOlX/cvPNJluhqDhzh/B/ztep69jAdzZwubS07vRvncyLqXjBZtDfGOEYm7PhnvZDb2jOkZjsm1B39JoPgsLRXGuf0+XgupzA8in7atZ6VU8pidk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Currently, guest_memfd doesn't update inode's i_blocks or i_bytes at
all. Hence, st_blocks in the struct populated by a userspace fstat()
call on a guest_memfd will always be 0. This patch series makes
guest_memfd track the amount of memory allocated on an inode, which
allows fstat() to accurately report that on requests from userspace.

The inode's i_blocks and i_bytes fields are updated when the folio is
associated or disassociated from the guest_memfd inode, which are at
allocation and truncation times respectively.

To update inode fields at truncation time, this series implements a
custom truncation function for guest_memfd. An alternative would be to
update truncate_inode_pages_range() to return the number of bytes
truncated or add/use some hook.

Implementing a custom truncation function was chosen to provide
flexibility for handling truncations in future when guest_memfd
supports sources of pages other than the buddy allocator. This
approach of a custom truncation function also aligns with shmem, which
has a custom shmem_truncate_range().

To update inode fields at allocation time, kvm_gmem_get_folio() is
simply augmented such that when a folio is added to the filemap, the
size of the folio is updated into inode fields.

The second patch, to use filemap_alloc_folio() during allocation of
guest_memfd folios, was written as a debugging step to resolve a bug
found by syzbot [1], but turned out to not be the fix. I include it
here because it cleans up the allocation process and provides a nice
foundation for updating inode fields during allocations.

The first patch was separately submitted [2], and provided here since
it is a prerequisite simplication before application of the second
patch.

[1] https://lore.kernel.org/all/29c347bde68ec027259654e8e85371307edf7058.1770148108.git.ackerleytng@google.com/
[2] https://lore.kernel.org/all/20260129172646.2361462-1-ackerleytng@google.com/

Ackerley Tng (10):
  KVM: guest_memfd: Don't set FGP_ACCESSED when getting folios
  KVM: guest_memfd: Directly allocate folios with filemap_alloc_folio()
  mm: truncate: Expose preparation steps for
    truncate_inode_pages_final()
  KVM: guest_memfd: Implement evict_inode for guest_memfd
  mm: Export unmap_mapping_folio() for KVM
  mm: filemap: Export filemap_remove_folio()
  KVM: guest_memfd: Implement custom truncation function
  KVM: guest_memfd: Track amount of memory allocated on inode
  KVM: selftests: Wrap fstat() to assert success
  KVM: selftests: Test that st_blocks is updated on allocation

 include/linux/mm.h                            |   3 +
 mm/filemap.c                                  |   2 +
 mm/internal.h                                 |   2 -
 mm/memory.c                                   |   2 +
 mm/truncate.c                                 |  21 +++-
 .../testing/selftests/kvm/guest_memfd_test.c  |  32 +++--
 .../selftests/kvm/include/kvm_syscalls.h      |   2 +
 virt/kvm/guest_memfd.c                        | 116 +++++++++++++++---
 8 files changed, 149 insertions(+), 31 deletions(-)


base-commit: b1195183ed42f1522fae3fe44ebee3af437aa000
--
2.53.0.345.g96ddfc5eaa-goog

