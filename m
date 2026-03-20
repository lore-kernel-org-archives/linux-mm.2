Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6868F1099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C486B00D2; Fri, 20 Mar 2026 18:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504496B00D6; Fri, 20 Mar 2026 18:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441306B00D7; Fri, 20 Mar 2026 18:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3378B6B00D2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:13:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC5FF1B771B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:13:46 +0000 (UTC)
X-FDA: 84567844452.23.36429A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 43A7A40007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:13:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=edSADuQC;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kHeX5+YEAAQ5ktdSsuMecwqZwetnx8PqmydD5c5G9Ig=;
	b=c9uKBwWfVZbCyuIPYKfHcXMUARsVRwCh8sckOgWRxpQtzYeGTQjr7BikGUaastZPNg6b6g
	nPirLtk+iQnzzKm3AGhjM8CWxxGqDkS2rGESB5WXOwmTIQ6Z8ypNrPGrLCMKEr8zNktazZ
	+0So9otAQzpRszkT3r1XzzXG9EUazzg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=edSADuQC;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044825; a=rsa-sha256;
	cv=none;
	b=ikxa70kgEU5qjcEnRrOS6gmoVdM6zhe6t9DsSeTMOtAetn6Wrl07qkf8Z1LLFzBnb0Bgri
	96skmEh+PD6i5TvxuKvJVyiVqT7FOSlxIFp0O2c3gLiWVyLexWU9EwxCT1apQyojPXFG+B
	Js+VxG1ZjIbrrAlGLUG6Mm/vz/qP14E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EF9160128;
	Fri, 20 Mar 2026 22:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B76C4CEF7;
	Fri, 20 Mar 2026 22:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044824;
	bh=37kqOOQ/gFodAPx12yyeumULM8pbIZCoL7z8zOpqXf0=;
	h=From:Subject:Date:To:Cc:From;
	b=edSADuQC1oEMW8dWWkRDylnwWgm554uxai5oA30QCHdfBcxx4gOYFfiqWlcULOlqU
	 ncAaN3x4odTUE7sqhieG30e+G5T5QVoPrf7LOtIJ7zwdc+jYAjo3uQVMqrNJJeh1LB
	 DefP7y/8KZQ3EQqwTivr2WJB8+ThJMSrvnvqxjBK48P30+vR6WyYgGnKflj4PDoN20
	 fc+1htlMz3x4PfxkDaXOgkjLuHxDzWNJrNrvLmOg4S39caX01QjKalCc28jgt4VjTQ
	 9M5CShjf0Cxm8//D6d5EnadKWZp4/rpCDYo+myXErcH2J+u377GWSp5NAWjvaKVldb
	 +dnQ/VfibsdLA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 00/15] mm: memory hot(un)plug and SPARSEMEM cleanups
Date: Fri, 20 Mar 2026 23:13:32 +0100
Message-Id: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIzGvWkC/x3MQQqEMBAF0atIrycQekTBq8ggMflqg2ZCGkUQ7
 25w+RZVFymyQKmrLso4ROUfC/hTkV9cnGEkFBNbbuyXrdHksmLDNvgVLu5JjUcdwsi+bgOohCl
 jkvOd9r/7fgDwqvASZAAAAA==
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 43A7A40007
X-Stat-Signature: hersqus9mymxt9wn13d1157jjh37afux
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774044825-449946
X-HE-Meta: U2FsdGVkX1+WvB96egOh/ueycpkGfLo2GCPMwrRmgDcwwNtJKt+mYfQHhWCiIlIEbwwuQtQx/P110jzTpwusIk6uHhC/Kp2UKvViOnGU6hFHpXop2/TjiEKMAIxo2kp9CRel9leUXLRqP5LZYRxM+c0CFmpeon/JrTxx6LK4INCQV9821u7wR1BSP9LB/nyvm/vVTy/FnaFh1hQJFJwM+gyPo5Pz4FCvQg5N1z60SDAjquYVujwkm8rv2uG9rzDxz9OX0z2wQEnxgYmdziLLvRmf44kecJsNtisS3m93ReeY3xXE0rFzHKpvNmYjjXckfBcoXyMtmjpU2HDqBiDNdwBB+0guqrWWt2wHh8V1XbHKia0Y7pAUGbCcEnkwGlt4pC9md5oNjici9MQRu4bcj0gcuUpx3cpsHCdRrjPSdxxbxv75RtbU2IUTLnexoysGFQkqavnjXRoxH9n4j35PwmDltOC/TlYakAS4uSh9Pc7//SuSrwK5QZsHdXotzSZj5ddHZ0B+jlLpfWX8OfQIQCkRcAHFnfFySkJBpbkI3UeayZ8RcwgTdapamCV4ZTUGFuEMPdyuMvTjtEdVLv1wAyEbSewVqCP8p7gcL035q3h9KROo0CB/hFu2K0i+I+HxisdOBAPBWKLFY6cWou1ghcQPoiKzE0XhFMyUGRrad3CsDc9pY4N1Rec5/UCGd3f3m8VNzdPW7EVDx+ekAhKhfqdApHmUoVeuZ4NFXoA6RnD6pjXtEf6O/hMLFWnOVvHfdFv5lQL9AfdZ3N6YyMhBvjr0m5Cw/yOVhNsTFnDU2wzY5kcdsCqmiQPHZ3Xvr195fvlCOD3zMjwmRybjkvxw9aumFV3GGBjmIMYqA7JjXF+gaQA4tHTZGbBgU8R0IjWGgbfOCcuwkCon9pai+rfsqtA4xPkYteY6sIX4OZPvBrcYKloVrDd3s31ZQlnRDFvIraBZqtir4zll97MjulJ
 fqr3Q+WO
 LNzWq6D3fHQUmgACIrCD2N+wYjTeoHuIAx4Ru+eaKZpM2+QSgcr7JrzgZqPm1/lO9TNkpN/rAGHp0oPGa5WS216VHjV+hZMP+nheaUGI+fuuIO9c9jtNk6Tbh1+v8PJ6V/flWOdRNb2BKNiM22UY3tBnjjK7PW1GqqcRsTuZedYXA0W8p3P6iwE8PgrKlpdF9ZKQbP3dUEYO5cCTqkYCeNtXjMgHsr8HgMaZryENyBBxo6RT6vBL1+nZlUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some cleanups around memory hot(un)plug and SPARSEMEM. In essence,
we can limit CONFIG_MEMORY_HOTPLUG to CONFIG_SPARSEMEM_VMEMMAP,
remove some dead code, and move all the hotplug bits over to
mm/sparse-vmemmap.c.

Some further/related cleanups around other unnecessary code
(memory hole handling and complicated usemap allocation).

I have some further sparse.c cleanups lying around, and I'm planning
on getting rid of bootmem_info.c entirely.

Cross-compiled on a bunch of machines. Hot(un)plug tested with virtio-mem.

v1 -> v2:
* Added "mm/memory_hotplug: fix possible race in scan_movable_pages()"
* Update the comment above section_deactivate()
* Reordered the flags in sparse_init_one_section()
* Patch description improvements

---
David Hildenbrand (Arm) (15):
      mm/memory_hotplug: fix possible race in scan_movable_pages()
      mm/memory_hotplug: remove for_each_valid_pfn() usage
      mm/sparse: remove WARN_ONs from (online|offline)_mem_sections()
      mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
      mm/memory_hotplug: simplify check_pfn_span()
      mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG
      mm/bootmem_info: remove handling for !CONFIG_SPARSEMEM_VMEMMAP
      mm/bootmem_info: avoid using sparse_decode_mem_map()
      mm/sparse: remove sparse_decode_mem_map()
      mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific usemap allocation handling
      mm: prepare to move subsection_map_init() to mm/sparse-vmemmap.c
      mm/sparse: drop set_section_nid() from sparse_add_section()
      mm/sparse: move sparse_init_one_section() to internal.h
      mm/sparse: move __section_mark_present() to internal.h
      mm/sparse: move memory hotplug bits to sparse-vmemmap.c

 include/linux/memory_hotplug.h |   2 -
 include/linux/mmzone.h         |   6 +-
 mm/Kconfig                     |   2 +-
 mm/bootmem_info.c              |  46 +---
 mm/internal.h                  |  47 ++++
 mm/memory_hotplug.c            |  35 ++-
 mm/mm_init.c                   |   2 +-
 mm/sparse-vmemmap.c            | 304 +++++++++++++++++++++++
 mm/sparse.c                    | 539 +----------------------------------------
 9 files changed, 377 insertions(+), 606 deletions(-)
---
base-commit: 3f4f1faa33544d0bd724e32980b6f211c3a9bc7b
change-id: 20260320-sparsemem_cleanups-ce4ddb2c47de

Best regards,
-- 
David Hildenbrand (Arm) <david@kernel.org>


