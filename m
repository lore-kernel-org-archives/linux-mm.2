Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 194C7D374B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C994F6B00AF; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A396B00B0; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11496B00B2; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 986256B00B0
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D0A6160360
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:44 +0000 (UTC)
X-FDA: 84186981648.22.D343EA4
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19D56100002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=DlnthX6y;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf05.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976662; a=rsa-sha256;
	cv=none;
	b=1nahYEkAIPYpYSwdO1Dy36AfTzdFoOXcUPSQKbzBa0KDJcRQAMTXZO+N+SiEGx3eVntriS
	at0aHq0iN0s0qeaNSC+mZ5zEqtGG1dmbnuaoUSjtq9bGnoZfmYeGl3MMsMRXAkMv+N7vAS
	qbs3SPo47/PbhabmVyui+ZnDKrbgvnw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=DlnthX6y;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf05.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7V8zRztr79VObCMoptEPLJbZbtmNllOgLuMS+604U+Y=;
	b=OwzS40kHs4Acf6CCZXAiLOq/xYEpysjM7FA8uz4M39Xkszf0MD+ZzlyAO4Tbdl55qWyjjh
	IOjLD0/Bv/DysdXg5294K+I0CD7HqlGTfNByHzWALI0AK0CZNY8gxFBH4cEObCwBFRQaHn
	+xSS6YAe3ELbtUc9kMJSDFF4tMjpw7w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7V8zRztr79VObCMoptEPLJbZbtmNllOgLuMS+604U+Y=; b=DlnthX6yrqH/po71lwl4df6RLL
	9LcaJDEzxn7KsxL5J/GHmp6EPweTB9P9PHYfMAQBiKmKmSoi1iTAqnpK7ZI9Z/oFrNZvzXZXhoSYW
	2B0e7+Qg1f8j/LgOEUhoi6rmEjvnkHD8ez4BenGPlXl1g9w9KSpvZuTBAnWj1S0pbYyxGv4ieIfQn
	mP2k0pR6aHiTR+qL3kuOnroMl8q/EwyXLgnXWDolUaCBIjvibXfmzu3mm5UUHREgf2AkTIg4pE4Vm
	u7MIe7uCXOoTYpKUUfxrjM2LAkxAaqv5809PfXb+b/TLEJdS1adCEKXOmj98sikKbATm4M2v5yKhk
	aHMj2rDg==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3H-009H1j-46; Sat, 06 Dec 2025 00:17:27 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH RFC 0/9] mm/page_owner: add support for pages in swap space
Date: Fri,  5 Dec 2025 20:17:12 -0300
Message-ID: <20251205231721.104505-1-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z4s7sf7x4juu5z6nt6k59wwwfcx3d8og
X-Rspam-User: 
X-Rspamd-Queue-Id: 19D56100002
X-Rspamd-Server: rspam01
X-HE-Tag: 1764976661-806405
X-HE-Meta: U2FsdGVkX1/kG03dc1ktIYNgyxyat4zr47DWA8u3CDzrNEv+U/0bo57WmjX3vyCcpY/NGU0pP1TbkB0LcYq2422120rAhyubpJs4H0l4ZXonpV73Rpnmc/PeibGjGW90LhX27JrcKVblswkTJcCO+wksVQFK13ER9oi3l8c0wqQtjFfxvZDahQbNkjQSh82ukDS1YrW/YaolLd0s1Q6xIhJ+HIqNOJUUuAR51SiQfH+3DoyTxdjBgABHL48keKxFWotGLuI5yexkFqrMMEtD5Qx4uG0JRIzfbvF4m12/Ex19EElAAcuACzYYvZma4pTZMAOljCA9og4voCFiUoy6xW/sBPBe/q+jizNjSLOrPv2Yo+PtaqNBB1z1OzbLuosp2TsyaqTlhWw3XpOr7VM7srrRHeib/WTiXNsNm7+MRt6KlcO7sSrTThYjyrptgdXQQ3WF9W4uHXsNPSzuwULlPfjIZjDt5oQYt8NwFZLMXCPwma2Fz3rH+FqqcPZDkEwe3hAqOgVBqyd1uaUKaLkB6LBnW6PbEdTLGcDPwjnyHDyyDtNoYfB8LoZgrOIJgWg/ybX3NbZ8nIqJjimRU1Rs7w3med4kLRdTzApjK1soRBJ1VwN6vr9oX/SnJa43GsW5e/PIjgZb5fzauCeG71LOnaAJQfVgLyABxKvw1XFEmZGpTxIK8oJZHLku9q9z6nUcDcxOBESgbIa5WVBNfsZOodytgKjEFK/qIu2DqiTG7G79ELh3DmltVd1X7uUR2rBpOZcQQy/UDubN5k5zvutDhIM50TUbZ0A48Drl8CH/UE5+M7tyR8o31pVK755rZmvikRZ/lOcgEkTtNvdvFU8QNTLFRwIRPVfQtMyP0iZm8lsJUpx2LxmyC5wSY5CgM4ffgv7HpWBGO8F9X6+1Dn21kH5Ic8RyMH20sYTuKQBcPW9eAdirihncutt/oiiF72rh9WIeQXG0Rq72Db1/0Mp
 XXZc8+ty
 5QBPRt2sA1ZuRYlvjlgCU4yNCh2wHmLKVdmvfOIVZxtla8o3sgr6x8U7Og5UZlvu4R2CHPBMVNBX1sjBhltv4FZHOvf00hXtz23CqsBkmoDEwWYjWJfqUMMEg3bCXHaW7iD9QBJnYxyOKaalkQOKDRaF7ZirIA5kw582GvZgHOwEH87+Rv2/MsT3chDctfSFOsEnjChafQW3KgLYu60x1PyFl0jdFwVh7gyd9n6XIpQwfMjAr7MI6yToKvEPzsRXxFet9abieE1rkeww=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series extends page_owner to track the allocation stack trace of
pages in swap space as well (not just pages in memory), and maintain it
over swap-out and swap-in (no longer lost/overriden at swap-out/swap-in).

It stores a copy of the allocation stack trace (plus some other fields)
at swap-out and loads it back at swap-in, with an xarray by swp_entry_t
and the swap hooks used for CONFIG_ARM64_MTE (memory tagging extension).

The refcounts of the allocation stack traces (i.e., number of base pages)
for the initial allocation and the allocation at swap-in are fixed-up at
swap-out and swap-in, to maintain the refcount on the initial allocation
(for 'nr_base_pages' in '/sys/kernel/debug/page_owner_stacks/show_*').

The series is split into more, small patches on purpose, just for review
(some patches fail to build with '-Werror=unused-function').
- Patches 1-4 add infrastructure.
- Patch 5 adds the key functionality.
- Patches 6-7 add reporting.
- Patches 8-9 add hooks for this.

It is basically tested (below); hopefully sufficient for an RFC in order
to get comments on the idea, approach, design, problems and suggestions.

For future revisions: add pr_debug() and more error messages, and write
Documentation; maybe rename functions with 'spo' prefix (swap page_owner).
(I'll check a FIXME on the refcount fix-up due to an occasional WARN+OOPS
mostly on shutdown; but that is just for 'nr_base_pages', without impact
to the key functionality, and can be just commented out.)

Thanks,
Mauricio

# Testing

## Configuration

- next-20251205
- x86_64_defconfig
- CONFIG_PAGE_OWNER=n / CONFIG_SWAP_PAGE_OWNER=n (build-only)
- CONFIG_PAGE_OWNER=y / CONFIG_SWAP_PAGE_OWNER=n (build-only)
- CONFIG_PAGE_OWNER=y / CONFIG_SWAP_PAGE_OWNER=y (build/tests)

## Format

- Existing file (page_owner)

	# cat /sys/kernel/debug/page_owner
	...
	Page allocated via order 0, mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 231, tgid 231 (dd), ts 13255570102 ns
	PFN 0xa35b type Movable Block 81 type Movable Flags 0x10000000002003c(referenced|uptodate|dirty|lru|swapbacked|node=0|zone=1)
	 get_page_from_freelist+0x13b9/0x1530
	 ...
	 entry_SYSCALL_64_after_hwframe+0x77/0x7f
	Charged to memcg session-1.scope
	
	...
	
- New file (swap_page_owner)

	# cat /sys/kernel/debug/swap_page_owner # new
	...
	Page allocated via pid 231, tgid 231 (dd), ts 13255313898 ns
	SWP entry 0x2e
	 get_page_from_freelist+0x13b9/0x1530
	 ...
	 entry_SYSCALL_64_after_hwframe+0x77/0x7f
	
	...
	
- Existing file (page_owner), when modified with '(swapped)$'

	# cat /sys/kernel/debug/page_owner
	...
	Page allocated via order 0, mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 231, tgid 231 (dd), ts 13255427451 ns (swapped)

## Environment:

	# uname -r
	6.18.0-next-20251205-00009-g8042ea636379

	# mount | grep /tmpfs
	none on /tmpfs type tmpfs (rw,relatime,size=1048576k)
	none on /tmpfs-noswap type tmpfs (rw,relatime,size=1048576k,noswap)

## Before (page_owner without swap support)

	# grep -o 'page_owner=.*' /proc/cmdline
	page_owner=on

  - Mem/Swap usage per page_owner (swap is not reported)
 
	# free -m
		       total        used        free      shared  buff/cache   available
	Mem:             458          68         367           0          33         389
	Swap:           1023           0        1023

	# echo $((458-367)) # total - free
	91

	# cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	91.2578 MiB

	# cat /sys/kernel/debug/swap_page_owner | awk -F '[ ,]' '/^Page allocated/ { PAGES+=1 } END { print PAGES*4096/1024^2 " MiB" }'
	cat: /sys/kernel/debug/swap_page_owner: Invalid argument
	0 MiB

  - Use 256 MiB of pages allocated by 'dd' (compare with pages allocated by 'cat')

	# dd if=/dev/zero of=/tmpfs/file status=none bs=1M count=256

	# COMM=dd; cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated .* \('${COMM}'\)/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	256.559 MiB

	# COMM=cat; cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated .* \('${COMM}'\)/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	0.464844 MiB

  - Move that 256 MiB of pages from memory to swap (use 'DD' to differentiate from 'dd's memory)

	# ln -sf $(which dd) ./DD
	# ./DD if=/dev/zero of=/tmpfs-noswap/file status=none bs=1M count=384

	# free -m
		       total        used        free      shared  buff/cache   available
	Mem:             458         445           6         388         405          12
	Swap:           1023         264         759

  - Mem/Swap usage per page_owner (swap is not reported)

	# echo $((458-6)) # total - free
	452

	# cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	450.445 MiB

	# cat /sys/kernel/debug/swap_page_owner | awk -F '[ ,]' '/^Page allocated/ { PAGES+=1 } END { print PAGES*4096/1024^2 " MiB" }'
	cat: /sys/kernel/debug/swap_page_owner: Invalid argument
	0 MiB

  - Move that 256 MiB of pages back from swap to memory

	# rm /tmpfs-noswap/file
	# cat /tmpfs/file >/dev/null

  - The 256 MiB of pages is _now_ allocated by 'cat' (instead of 'dd')

	# COMM=dd; cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated .* \('${COMM}'\)/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	1.66016 MiB

	# COMM=cat; cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated .* \('${COMM}'\)/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	258.309 MiB

## After (page_owner with swap support)

	# grep -o 'page_owner=.*' /proc/cmdline
	page_owner=on,swap

  - Mem/Swap usage per page_owner (swap is reported now)

	# free -m
		       total        used        free      shared  buff/cache   available
	Mem:             458          68         360           0          40         389
	Swap:           1023           0        1023

	# echo $((458-360)) # total - free
	98

	# cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	97 MiB

	# cat /sys/kernel/debug/swap_page_owner | awk -F '[ ,]' '/^Page allocated/ { PAGES+=1 } END { print PAGES*4096/1024^2 " MiB" }'
	0 MiB

  - Use 256 MiB of pages allocated by 'dd' (compare with pages allocated by 'cat')
  
	# dd if=/dev/zero of=/tmpfs/file status=none bs=1M count=256

	# COMM=dd; cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated .* \('${COMM}'\)/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	256.504 MiB

	# COMM=cat; cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated .* \('${COMM}'\)/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	0.175781 MiB

  - Move that 256 MiB of pages from memory to swap (use 'DD' to differentiate from 'dd's memory)
  
	# ln -sf $(which dd) ./DD
	# ./DD if=/dev/zero of=/tmpfs-noswap/file status=none bs=1M count=384

  - Mem/Swap usage per page_owner (swap is reported now)
  
	# free -m
		       total        used        free      shared  buff/cache   available
	Mem:             458         435           6         384         412          22
	Swap:           1023         278         745

	# echo $((458-6)) # total - free
	452

	# cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	449.258 MiB

	# cat /sys/kernel/debug/swap_page_owner | awk -F '[ ,]' '/^Page allocated/ { PAGES+=1 } END { print PAGES*4096/1024^2 " MiB" }'
	278.793 MiB

  - Move that 256 MiB of pages back from swap to memory
	  
	# rm /tmpfs-noswap/file
	# cat /tmpfs/file >/dev/null

  - The 256 MiB of pages is _still_ allocated by 'dd' (instead of 'cat' as above)
  
	# COMM=dd; cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated .* \('${COMM}'\)/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	256.445 MiB

	# COMM=cat; cat /sys/kernel/debug/page_owner | awk -F '[ ,]' '/^Page allocated .* \('${COMM}'\)/ { PAGES+=2^$5 } END { print PAGES*4096/1024^2 " MiB" }'
	7.80859 MiB

Mauricio Faria de Oliveira (9):
  mm: add config option SWAP_PAGE_OWNER
  mm/page_owner: add parameter option 'page_owner=on,swap'
  mm/page_owner: add 'struct swap_page_owner' and helpers
  mm/page_owner: add 'xarray swap_page_owners' and helpers
  mm/page_owner: add swap hooks
  mm/page_owner: report '(swapped)' pages in debugfs file 'page_owner'
  mm/page_owner: add debugfs file 'swap_page_owner'
  mm: call arch-specific swap hooks from generic swap hooks
  mm: call page_owner swap hooks from generic swap hooks

 include/linux/page_owner.h |  50 ++++++
 include/linux/pgtable.h    |  30 ++++
 mm/Kconfig.debug           |   9 +
 mm/memory.c                |   2 +-
 mm/page_io.c               |   2 +-
 mm/page_owner.c            | 338 ++++++++++++++++++++++++++++++++++++-
 mm/shmem.c                 |   2 +-
 mm/swapfile.c              |   6 +-
 8 files changed, 427 insertions(+), 12 deletions(-)

-- 
2.51.0


