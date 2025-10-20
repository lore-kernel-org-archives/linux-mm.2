Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7BBFCCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8248E0003; Sun, 19 Oct 2025 23:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A794A8E0002; Sun, 19 Oct 2025 23:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967B18E0003; Sun, 19 Oct 2025 23:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 858D18E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:11:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0228713B9AC
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:26 +0000 (UTC)
X-FDA: 84017017014.02.41D8C65
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0B7B040003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RG8OwEV3;
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760929885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xCr9rmj82Cu8SetbEs3MjC8j0VxQVzvBm9b5LJ96KeU=;
	b=o4Pp+PeIsf1ktW9cpMuU4L6bkvCoZv1Y4+L2P3jI8h87BhiXfvtQ9BOAtGrcTWJ7tE7uOB
	fiEhp3iilzC8bdh5+7eNn6k0Lu/G19R8lhzVl9cnRHQcq8VKT1hGA2RrxPlNZ6Y2GhHsmP
	nq4Ou61mSIDrk6WsRzxZ4mvyuxNUg3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760929885; a=rsa-sha256;
	cv=none;
	b=gowBZfroELmdZwlmkTynTwtTGzoydYv8qC+kjD89fQrL7O7ytSmQseTeb9fWGeYzQVLLio
	rBXqTKe/MYTRZBq5UWqVeTlAkHKFAuhnF/Hk+AX/0/FkJ65RXU51+XQfmRKCFtJqNlA+CQ
	DZRTlu4741S0xvKLaCSfyg5SxLaIOco=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RG8OwEV3;
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-26a0a694ea8so28404035ad.3
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760929884; x=1761534684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xCr9rmj82Cu8SetbEs3MjC8j0VxQVzvBm9b5LJ96KeU=;
        b=RG8OwEV3rWMDDFTJztqzdxyftDU6wUOJ/fsPknY29Og24obGgDGDaV6BTdkQEqfPhp
         2HH8bqg7q69pR9WB3EdKMLBVDE5lhm8h8YGEylyQVRzXECFWjfQVjIoNTOzEtk5qiyoa
         eQKWKSKiFjVyab4P6Zv2m8M2GcqaBjry8b3ZJXJPydGnpkp2txmYemYG99ZzRdlj385R
         KyIzDxwvX78s+G5jEZWsLwoHCpedn062EpHrr4Wd93zpKh4Yja3Nq8Hg7AUm0wdFMNsq
         7I+MWGpNZmOY4jC2DXyhMmVOCHvrndezKJlJVWikvYR1E8bkIh5pCqWFnLobUqOMKJcO
         ejdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760929884; x=1761534684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xCr9rmj82Cu8SetbEs3MjC8j0VxQVzvBm9b5LJ96KeU=;
        b=Go8sMASh7zTTza+xkIrCrnjd7aluHh4gxr+4STYC7LTRhsPrCqASTocaK2MlYu/yu/
         SDy7j8XF7+eSg/KOZcS8q2O5jwKLXR2vrWEi9duCvhuzcozB8CjMJNvDEqKGxwje4f79
         D5yZetCSar3ofUvz0hTboWVpWtcg3oTZk440bxRBxyIRXXj+VnI6Wb04A5DJ06KjK27h
         CnxAG9a1uKNAfo23mgU90wMUqpebP4Mni3g/+fIdNd7xHDTISyaty+wABL5VbIZ6z+vA
         UQ5fUXGHxQTSrbzX+wGwvy6QyzfRgaq0ucQzg+VpJWiZc+rQHt4luwwgk1nx6nG29dwB
         lcNw==
X-Forwarded-Encrypted: i=1; AJvYcCVcrlcwbe3t4W/bnWtbs3w+Vuzo+qczYRR5VuCouuPwgyORQK1KByBN6Q0mLPzZdqfxOw/gzV5MUw==@kvack.org
X-Gm-Message-State: AOJu0Yzkb12a8M/k3omKzr9je28exS3NtY+AdhHkO6fMJKjrtwTAKlp5
	URNPFkFuf+d2lJLJPl0vRS1khWLo28YDeGQDlEioNmenTYkGppQz4D90
X-Gm-Gg: ASbGncttqnVXKSvdsy4RYrCWsllP9s8c3fh7nU3KiFc6AGgK1Sq20Yda/qZior4qmez
	bxy4ctHyNx2YL559jmZj6N2hV9VTr/uI2cfMPLkl6+g7PxZMW1NRjh4N9f8bcErely/xhIuvOzP
	Ar9Wi2EOvA9Ce9glFFbJptAca46zIK+57qlhaKueBmuU5YZj5N9zayORRn7WTn0GHTOHGRW7QWG
	ayV+tLYlvt+qLvowtXbsXbWZsPa6lXwzQGdrLkRCs96O5ReYU16O1OFSHOSixTKAZkKAghjvZrV
	9foij5FgyaNIpiwiEdRR+rlK77895SQORUQpHvU7VChwNCrpoFIIlDIloVepaf4Dbt3uREKyrUz
	fqQosBxtPeC+81Q7G50F0U2XTKA96uh++I+6F320UClHT+epe8CKptu3bHPrenM5M3zFpqshHek
	PMKmlaKdskKdh2I2RZbt1aRX1UCf70ReqwTabm0CGKB3GHP1s6vqA=
X-Google-Smtp-Source: AGHT+IHHl05n3TLFtJj32my6sFzllN0uFcX2pILWiDZXhCfi29R2Qu7xexBOSzpQjSrdAjNQLV1WvA==
X-Received: by 2002:a17:903:1250:b0:290:dd1f:3d60 with SMTP id d9443c01a7336-290dd1f3fc8mr82869055ad.51.1760929883552;
        Sun, 19 Oct 2025 20:11:23 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:2120:6ebb:ce22:6a12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5794sm66007245ad.53.2025.10.19.20.11.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:11:22 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v11 mm-new 00/10] mm, bpf: BPF-MM, BPF-THP
Date: Mon, 20 Oct 2025 11:10:50 +0800
Message-Id: <20251020031100.49917-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: tx9gmmyxopj95ojw7ydw5mkxods737u8
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B7B040003
X-HE-Tag: 1760929884-447436
X-HE-Meta: U2FsdGVkX1/MhKpvKo9dnC9w+12wXZVqgBr1Pb9+/IWWsq4DfC2zIcLan6Sf0jbF1cvX88V+3V34IfIHjdfWV3tnHk88YzVw9roBQLJFBfWTLlRSpK7wNGzHM9V9qRyl+d5iHRNfhMnE+aROZoXBZTr30VXTBBNj90j3YY22cG5JrrIIdioIWe7UsU2w4O3V8lrGRy4SGZnXSRD+8P/uZ0J3BMetlBj6k0fiVu2VKNVu7DpcTGyWDxFEIXEs086o4+p/GOTntd6aWVH5vutWU0btZOcl/y+yZ/vzXCvQJwIHMq+omhJqcdpaBUm+bswda0QDXQTJl0xNyZh1fZeAQByjbBcLinrKbEE1VrIZD/eqcnoSo/0Czo8FRPYEOxXeAqRz+w+7xY2xa67OPdAkVGBBfbMsE5D1KwlzaU8cASCbAUf/NzuXIvb5hxFWV3J5VlvmdkLgLDF4Uu3TxhxfKiu5NK5GiEn9tbrU0HRbPFv/TojCnQT2xcT3QIhusVSMxE6yLAV78oTQqZa4tPrK3+M8mTg/D83Mkmg3j5ngPg3UU57I24/s+67nuQXXrySb10eXR4SVmOEM1EJZJgNGX1x94XUxi8vcmb39uF+1zuPCYrx8q4bbjVIAVtpCRONMJTMyiGDtDjcyV+fjkYUgHNV5Mn3o3a7jWQv+vNS2jDzkYLiAX1OrfaO4b4OBk24SpOYX+yIG0YJUt2UC5djZkC5UDuqIZQ7D5ngpfi9tkDOyDdYDYR/QTiEhaWqEsZuhNzYceCD1js6wrtTLtW7UYW9XvpGgRaA4ixripz7uLPSU0xPuuZDm0EaWFCmrrCiim01ky7i9Xud2/FWaSw2EUBpGYZogQb/4IypmlmekLV99h75XPuCu5oFfdzAyGrjVuv2L2Nu7lxHlTEe7HlpT+ML1Z2iO5sdNmZWspyw3rlWKdjlmX3ch/i6afE2yMcUPwkgyQq05G8ZnYDA0eX3
 X0DHJZWN
 0mGkas9DGxj04EjVR/KJ6Wggz3aFsdluoa15/uHrWSmNOdL8IFjCirACK8+UdsefwFDmRZNH0GnB7GFB2S0KqL6p4pQpKUTzYRluj6CUG9wq7aZDTIh/OQDZu95Byo9NUuBr0W8Sg7tjH83lt4R5LMsdTjD75csLyb7YbQh3wpAOYAV6Yd+rw7vQVBT+0ZfAf9+OD2Jm5s7eTz0Z0KfWQERGVdLes34bTLlnFuL2HKEWbQw6ygYV3vlYB+UJtX0PlpaRrV6E5QVn1E07K8Q4OtAJ6xL6G/2fwZQLTFmffkB00PfrUd/FKfK8EvOjCb0XFQ9LE2YpEjFxCpmdFb4GxYriIQolklE4Hog/PaBQa8/iXEbEUwWbaa9Elb5QGnAdUu/htMFbT3+mSb7QTVowIZiV4IXP0R/bOfjrmkPzSGzDRinQpFSKTgUYQrNy+6mNrl8Tudw2GJzJFUGnmiQJ4zXCuVN++J/4ayKz05meHKErCYZ9RvRUwiCUvYj1CzEf6ijABWdj5PRhqqLHuN8MCz+sjdMnAL/Wi9XfTkABEw4SNiIuhYlSO6QyfJE8P2RgytkpjEJDrkWxwknDksWfJfsXo0QbAsi2LNlSuUn0Bcnm7UQCq36nP5cGhX2qrxbEbbNoONXPax7kbldWPcA4IxyFHPZvbEQofHaUPSJIQtpwk9tNrpq7YIuGJbDFcS9ByUg/ORWB4NhQPGT6WxzRjndcAe7+2/vhfcn9TfgwA6KsCUWoSci8wDsdRuXF88jlAnqW7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

History
=======

RFC v1: fmod_ret based BPF-THP hook
        https://lore.kernel.org/linux-mm/20250429024139.34365-1-laoar.shao@gmail.com/

RFC v2: struct_ops based BPF-THP hook
        https://lore.kernel.org/linux-mm/20250520060504.20251-1-laoar.shao@gmail.com/

RFC v4: Get THP order with interface get_suggested_order()
        https://lore.kernel.org/linux-mm/20250729091807.84310-1-laoar.shao@gmail.com/

v4->v9: Simplify the interface to:

        int thp_get_order(struct vm_area_struct *vma, enum tva_type type,
                          unsigned long orders);

        https://lore.kernel.org/linux-mm/20250930055826.9810-1-laoar.shao@gmail.com/

v9->RFC v10: Scope BPF-THP to individual processes

RFC v10->v11: Remove the RFC tag

The Design
==========

Scoping BPF-THP to cgroup is rejected
-------------------------------------

As explained by Gutierrez:

1. It breaks the cgroup hierarchy when 2 siblings have different THP policies
2. Cgroup was designed for resource management not for grouping processes and
   tune those processes
3. We set a precedent for other people adding new flags to cgroup and
   potentially polluting cgroups. We may end up with cgroups having tens of
   different flags, making sysadmin's job more complex

The related links are:

  https://lore.kernel.org/linux-mm/1940d681-94a6-48fb-b889-cd8f0b91b330@huawei-partners.com/
  https://lore.kernel.org/linux-mm/20241030150851.GB706616@cmpxchg.org/

So we has to scope it to process.

Scoping BPF-THP to process
--------------------------

To eliminate potential conflicts among competing BPF-THP instances, we
enforce that each process is exclusively managed by a single BPF-THP. This
approach has received agreement from David. For context, see:

  https://lore.kernel.org/linux-mm/3577f7fd-429a-49c5-973b-38174a67be15@redhat.com/

When registering a BPF-THP, we specify the PID of a target task. The
BPF-THP is then installed in the task's `mm_struct`

  struct mm_struct {
      struct bpf_thp_ops __rcu *thp_thp;
  };

Inheritance Behavior:

- Existing child processes are unaffected
- Newly forked children inherit the BPF-THP from their parent
- The BPF-THP persists across execve() calls

A new linked list tracks all tasks managed by each BPF-THP instance:

- Newly managed tasks are added to the list
- Exiting tasks are automatically removed from the list
- During BPF-THP unregistration (e.g., when the BPF link is removed), all
  managed tasks have their bpf_thp pointer set to NULL
- BPF-THP instances can be dynamically updated, with all tracked tasks
  automatically migrating to the new version.

This design simplifies BPF-THP management in production environments by
providing clear lifecycle management and preventing conflicts between
multiple BPF-THP instances.

Global Mode
-----------

The per-process BPF-THP mode is unsuitable for managing shared resources
such as shmem THP and file-backed THP. This aligns with known cgroup
limitations for similar scenarios:

  https://lore.kernel.org/linux-mm/YwNold0GMOappUxc@slm.duckdns.org/ 

Introduce a global BPF-THP mode to address this gap. When registered:
- All existing per-process instances are disabled
- New per-process registrations are blocked
- Existing per-process instances remain registered (no forced unregistration)

The global mode takes precedence over per-process instances. Updates are
type-isolated: global instances can only be updated by new global
instances, and per-process instances by new per-process instances.

Yafang Shao (10):
  mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
  mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
  mm: thp: add support for BPF based THP order selection
  mm: thp: decouple THP allocation between swap and page fault paths
  mm: thp: enable THP allocation exclusively through khugepaged
  mm: bpf-thp: add support for global mode
  Documentation: add BPF THP
  selftests/bpf: add a simple BPF based THP policy
  selftests/bpf: add test case to update THP policy
  selftests/bpf: add test case for BPF-THP inheritance across fork

 Documentation/admin-guide/mm/transhuge.rst    | 113 +++++
 MAINTAINERS                                   |   3 +
 fs/exec.c                                     |   1 +
 fs/proc/task_mmu.c                            |   3 +-
 include/linux/huge_mm.h                       |  59 ++-
 include/linux/khugepaged.h                    |  10 +-
 include/linux/mm_types.h                      |  17 +
 kernel/fork.c                                 |   1 +
 mm/Kconfig                                    |  22 +
 mm/Makefile                                   |   1 +
 mm/huge_memory.c                              |   7 +-
 mm/huge_memory_bpf.c                          | 419 ++++++++++++++++++
 mm/khugepaged.c                               |  35 +-
 mm/madvise.c                                  |   7 +
 mm/memory.c                                   |  22 +-
 mm/mmap.c                                     |   1 +
 mm/shmem.c                                    |   2 +-
 mm/vma.c                                      |   6 +-
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 357 +++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  53 +++
 21 files changed, 1092 insertions(+), 50 deletions(-)
 create mode 100644 mm/huge_memory_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c

-- 
2.47.3


