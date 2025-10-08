Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336BACCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 18:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884638E001A; Wed,  8 Oct 2025 14:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BA68E0002; Wed,  8 Oct 2025 14:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A768E001A; Wed,  8 Oct 2025 14:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64D148E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:58:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB9611A0676
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 18:58:29 +0000 (UTC)
X-FDA: 83975857938.18.E74B05D
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id E247A140009
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 18:58:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LnrGRkOX;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759949908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgUP0/WmGKx+IVOsX9zNZJUjUIw/PkapcpGfi4V2VtU=;
	b=n9u7oNZogtytcaNVI7+9kBPI5lI/3ghC9cvivkdjJIAhqgwRPxZHUYR+JEQ9X9fFKv5HKA
	tl5AgkKGZu8AvasBg08e9QjOHwkeZVBcoi2/QfK6SDS0MWQRMZbvlLAllNdiy/lRG4sTWa
	WFdUAjYnld690c4Xgxtd17ZWKog6Mvc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LnrGRkOX;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759949908; a=rsa-sha256;
	cv=none;
	b=vvzFpDVf8rK+vA7mckffBedrhGNm400Qkh1rXHIk068ET+qKsnryS1CpcJr+E6AMTOYluh
	JeJONv6NC8/i+VoB14VkTHImz2PsFV6XEX688TXxFf9Uc292qCu53K51fRiApGcaLzGwJU
	xiYlYRlLjdxC1McWOYSbIsw1XWJmXKw=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4dfd1f48d4cso1066781cf.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 11:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759949907; x=1760554707; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CgUP0/WmGKx+IVOsX9zNZJUjUIw/PkapcpGfi4V2VtU=;
        b=LnrGRkOXpTRqD/Rpk+FGIs/g5Lv5mkWnPd+yRa8I30QiPvt8DrEYO21NIMtNLz+AlW
         U1whrX60W3CZ2ETRzJoGii2jMrXVvRikjmC4EEGecYFtpnynaeVUsXwC1C6bXZtl37AF
         dYwSNeywOYZL5MjHZR4sJobAwpgW5zw7jnP/O+rNLGhXhT15QsJuMtiZO4r3BPDobDiv
         ZggJO5NGEsWiBNv+CWE75wXHdSJV9nlbONcu169bMcBGZ5G9YOlP/lyA5ZNQJRs3x3MT
         MOImwngLugIlJkz6lFwnbwRyfdwS/HTiGDtV8sbMzYgnZLm2xJwOeYBhr4lvkvaQNCKq
         ovfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759949907; x=1760554707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgUP0/WmGKx+IVOsX9zNZJUjUIw/PkapcpGfi4V2VtU=;
        b=HdLzWwffY22l9LYMeuJcvoMa+8aDj3mDa3kv6SxWXxT4UI+UOE7JDxMXPDIOLdrsod
         JoRF08UtH+GGB0u0iZ/gZ5UQkyf+NNladk9sp4kzDLS0AiBpGszorDxIBD6qiUmQGh3P
         f/vOQxomO7p8aAuUalRHApNvBiAofyGv6qbAA/Fcrk7grQ9yj3sRTzxg+sipEDhpU1UF
         RJdEooSXIHsEU3fHdGMslzaDcYV7iUWo41vgiwXwz5g2GGOza+oOYhfsuJ+mRxwafxRa
         aMCp8U9UohthG4ziqwH5QnZoD8ulkxXZ0ermRPM14iDxWtfevTfoYum6/QWz1hXtqxyV
         HVdQ==
X-Gm-Message-State: AOJu0Yx7BjzaA+fypwY8coj5O5oDo4JTDXto9G5OORdk+acqZbq0ZNoC
	vj/MxXd18I49ju1AjSMU1yW91PwnAvTUr1A4Fsg7EvSY2ZNF4auQKzjtanWSYyek39s=
X-Gm-Gg: ASbGncvnrPfwu4N9tjuXHcROlnKfNcLqd/BLiMehu1dvaUpeuGnRtMcZ2Ow2VW80i3i
	MC6ihd2bXtsD2D1peYqq2NYPTInwXmJkTxX+sla9ms5t7jvgcRIvfZzJnvly3//Ybns3MIwQ7xS
	tVqB6+Nsztb81bqAuoL061hbG2JLSU/6uCJQPv/DGEzPu2FtUGBH6xdRy4gXxOueHmdgDjIUHCt
	C03Tty3E2qR4bsc7XhLgulmo0dN+QOFeUFBDktbBsNnzWMc4sWXYfl+n5rgQ3+D+z3Dn17KwKVN
	u9HUE93MJ+hrhAQMmNkVrDxpjMfItSD92YGQDty7QW4l992YPC8ih3HmXZeZ3zQ0jughbtPuTm3
	qBD3kLpObMP6jC2fj35rDB9b3Q67H6PCGF9TCPCIWvzl5Ty4lU9BMhlQKXNxdKNjSOZziqF3xem
	X+4oZJ2US/pE/9wXblvOO9jd+I6vXe02psCQ8jsCc/
X-Google-Smtp-Source: AGHT+IH5XZl1zP5WV2H5vB1vEumTSPp138/9F+4pHEKVvEJpneB5APkZUlKul8CuzBvyHU3k2KlKsQ==
X-Received: by 2002:a05:622a:4c18:b0:4d9:f929:1531 with SMTP id d75a77b69052e-4e6eace963bmr71897761cf.23.1759949906731;
        Wed, 08 Oct 2025 11:58:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bb53d91fsm166731966d6.23.2025.10.08.11.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 11:58:26 -0700 (PDT)
Date: Wed, 8 Oct 2025 14:58:24 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
	laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
	joel.granados@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOa0UPnxJVGvqc8S@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZyt-7sf5PFCdpb@gourry-fedora-PF4VCD3F>
 <f4d0e176-b1d4-47f0-be76-4bff3dd7339a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4d0e176-b1d4-47f0-be76-4bff3dd7339a@redhat.com>
X-Stat-Signature: 5dds754i8hcnotzht4cd8oyws4q415uh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E247A140009
X-HE-Tag: 1759949907-46491
X-HE-Meta: U2FsdGVkX1+OvoaMRxygBFtBYSTZJszNB1yIDlHvq7rK4JIfpLgikpq62E2az4+0rdu1sF0WAEtjfe5vOSoXckrGxY2XYJR32FITMNRVOp6C7V1xHmIsylumqlkeGTUOibuUypeN/7LHx42UGEJhw/eLpxLWyOoUsFAYdAQ47tCuwlftygGYzUFNG1rcICUuhjtsfu2pT9hZr64p46pDlSjgWJduaX9QaOiAatuIvPkqmNg9VKBR+cPy0ze7jSownKjU9pzMRUG/EyLUjwKdcaMZlYXNZspv0j+DnEahxG2PGtv5zf/vmwOxZow91iozKeMllrq7uHhxLPKDebXEoljojqNQRE89Zx1rHoXcTQ/Qxoa8aqRxW2J8f/Hs52bwCORyVJsqLcOot9VpmBlF+PKvz6ocAegxT8tiBPsJZHXj9oKHKaiPUyxLf49idsqesv/lwh7dNekOAHkdVDIUKu/qu9z9Efa8CHS4iXd5dtVfNPMoXkX05rcD/4qzL0dHe9Jzhh9ufQE3OQRbRBQ6yEdbdy+ZqyDNjjXNa9UWHgALjZVBw6Exk6bCqbGiQl0+7GLCqD8PgKHTIE432s8ysZaPSANIvkUs7icfkUJKjr5x7qnuL66T2KRWQ4K2v85yhK3SrnHXI+zf+5N/ZkIDkgfja6ut+AvMep9ZDVV5ohTt+uBfEEhkfW5Yz5us/FMtY90r7XH7eeirgsDhqEqlxCR/YwMBS3t7amPwM7oMHmE4eRC/WwKjSE2valww0LnXE1Nzu4PbLWfZcCLVLj5ffKqAlMuLzDm9slZWc1EP5UI2B7rIq4olOuEtCkm+5+P/mfkdw9tLeZMUHanVNM1kSNk0zq/YSrwAggRnYdZaweLxBxzJSyIFdldJJr0piBE0/2oHHS24HcLM/udvRT7nXQQHRlFCSDnbB712q9tIH4xHVQEPccctZgpwl914H+NPSgvsK3cDbJJX3mFxU1i
 Ot5dpcII
 /STDXBnqNmKfh50LsiSnCsX69eiryVxtaP0PUQCUSA5e9Ojv+ey70qUx4esr3ebTrBdMAn2WK+tQFr1P/iS0LE5ma0W0pWo0zvsAvyFOkE+gcn0a/jldI+GPimoPNxZiQyfQV3qfgjbezhV1gJTEJbrKBz6SumuRne3uomUfjekKOUg5xMlwhKR5F0P1u5oZmUlgBSr1VHL5EhUokYCEybjrL2993LpE5W6cf2ySTMwVXNwknNN4uyvPg1PWCO0Cr0qF5zH2okgc5FUAovMllKTtB3eNY6DhYyqb2yiY0TymYrrf1WFMi0YSvL/fiwXsMBJnPTuI0zIu204SwGuZ+ojnk1cQLYmtL8gVvnC/MdaOu/UJKD1CayPpaA56DPLsZJ+ERbFOtwCTF2FdmGQYO2RoyoSK1YEh6agUtbwOPab+cUflDHten1CO/tCqDkP8PlpSKP9fNkPDT7ScUIXudlxyUtPDaFMr6fvnUanqXh2z9qhN9PNgYzoIlWEfNhLnigF9E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 04:44:22PM +0200, David Hildenbrand wrote:
> On 08.10.25 16:18, Gregory Price wrote:
> > On Wed, Oct 08, 2025 at 10:58:23AM +0200, David Hildenbrand wrote:
> > > On 07.10.25 23:44, Gregory Price wrote:
> > > I mean, this is as ugly as it gets.
> > > 
> > > Can't we just let that old approach RIP where it belongs? :)
> > > 
> > 
> > Definitely - just found this previously existed and wanted to probe for
> > how offensive reintroducing it would be. Seems the answer is essentially
> > "lets do it a little differently".
> > 
> > > Something I could sympathize is is treaing gigantic pages that are actually
> > > migratable as movable.
> > > 
> > ...
> > > -       gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> > > +       gfp |= hugepage_migration_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> > > 
> > > Assume you want to offline part of the ZONE_MOVABLE there might still be sufficient
> > > space to possibly allocate a 1 GiB area elsewhere and actually move the gigantic page.
> > > 
> > > IIRC, we do the same for memory offlining already.
> > > 
> > 
> > This is generally true of other page sizes as well, though, isn't it?
> > If the system is truly so pressured that it can't successfully move a
> > 2MB page - offline may still fail.  So allowing 1GB pages is only a risk
> > in the sense that they're harder to allocate new targets.
> 
> Right, but memory defragmentation works on pageblock level, so 2 MiB is much
> MUCH more reliable :)
> 

fwiw this works cleanly.  Just dropping this here, but should continue
the zone conversation.  I need to check, but does this actually allow
pinnable allocations?  I thought pinning kicked off migration.

================== test =======================

# echo 1 > /proc/sys/vm/movable_gigantic_pages
# echo 1 > /sys/devices/system/node/node0/hugepages/hugepages-1048576kB/nr_hugepages
# echo 1 > /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
# ./huge
Allocating 1GB hugepage
Binding hugepage to NUMA node 1
Faulting page in
Resetting mbind policy to MPOL_DEFAULT (local policy)
Migrating
Migrated pages from node 1 to node 0, pages not moved: 0

================== patch  =======================

commit 395988dc319771db980dab3f95ed9ec8f0b74945
Author: Gregory Price <gourry@gourry.net>
Date:   Tue Oct 7 10:11:51 2025 -0700

    mm, hugetlb: introduce movable_gigantic_pages

    Signed-off-by: Gregory Price <gourry@gourry.net>

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 9bef46151d53..1535c9a964dc 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -54,6 +54,7 @@ Currently, these files are in /proc/sys/vm:
 - mmap_min_addr
 - mmap_rnd_bits
 - mmap_rnd_compat_bits
+- movable_gigantic_pages
 - nr_hugepages
 - nr_hugepages_mempolicy
 - nr_overcommit_hugepages
@@ -624,6 +625,22 @@ This value can be changed after boot using the
 /proc/sys/vm/mmap_rnd_compat_bits tunable


+movable_gigantic_pages
+======================
+
+This parameter controls whether gigantic pages may be allocated from
+ZONE_MOVABLE. If set to non-zero, gigantic hugepages can be allocated
+from ZONE_MOVABLE. ZONE_MOVABLE memory may be created via the kernel
+boot parameter `kernelcore` or via memory hotplug as discussed in
+Documentation/admin-guide/mm/memory-hotplug.rst.
+
+Support may depend on specific architecture.
+
+Note that using ZONE_MOVABLE gigantic pages may make features like
+memory hotremove more unreliable, as migrating gigantic pages is more
+difficult due to needing larger amounts of phyiscally contiguous memory.
+
+
 nr_hugepages
 ============

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 42f374e828a2..834061eb2ddd 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -172,6 +172,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,

 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);

+extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];

@@ -924,7 +925,7 @@ static inline bool hugepage_movable_supported(struct hstate *h)
        if (!hugepage_migration_supported(h))
                return false;

-       if (hstate_is_gigantic(h))
+       if (hstate_is_gigantic(h) && !movable_gigantic_pages)
                return false;
        return true;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a0d285d20992..3f8f3d6f2d60 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -54,6 +54,8 @@
 #include "hugetlb_cma.h"
 #include <linux/page-isolation.h>

+int movable_gigantic_pages;
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -5199,6 +5201,13 @@ static const struct ctl_table hugetlb_table[] = {
                .mode           = 0644,
                .proc_handler   = hugetlb_overcommit_handler,
        },
+       {
+               .procname       = "movable_gigantic_pages",
+               .data           = &movable_gigantic_pages,
+               .maxlen         = sizeof(int),
+               .mode           = 0644,
+               .proc_handler   = proc_dointvec,
+       },
 };

 static void __init hugetlb_sysctl_init(void)


================== huge.c =======================
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>
#include <errno.h>
#include <sys/syscall.h>
#include <linux/mempolicy.h>
#include <stdint.h>
#include <time.h>

#ifndef MAP_HUGE_SHIFT
#define MAP_HUGE_SHIFT 26
#endif

#ifndef MAP_HUGE_1GB
#define MAP_HUGE_1GB (30 << MAP_HUGE_SHIFT)
#endif

static long mbind_syscall(void *addr, unsigned long len, int mode,
                          const unsigned long *nodemask, unsigned long maxnode, unsigned flags) {
    return syscall(__NR_mbind, addr, len, mode, nodemask, maxnode, flags);
}

static long migrate_pages_syscall(pid_t pid, unsigned long maxnode,
                                  const unsigned long *from, const unsigned long *to) {
    return syscall(__NR_migrate_pages, pid, maxnode, from, to);
}

int main() {
    size_t size = 1UL << 30; // 1GB
    int node_from = 1;
    int node_to = 0;

    printf("Allocating 1GB hugepage\n");
    void *addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
                      MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB, -1, 0);
    if (addr == MAP_FAILED) {
        perror("mmap hugepage");
        return 1;
    }
    printf("Binding hugepage to NUMA node %d\n", node_from);
    unsigned long nodemask = 1UL << node_from;
    if (mbind_syscall(addr, size, MPOL_BIND, &nodemask, sizeof(nodemask) * 8, 0) != 0) {
        perror("mbind");
        munmap(addr, size);
        return 1;
    }
    printf("Faulting page in\n");
    ((volatile char *)addr)[0] = 0;
    printf("Resetting mbind policy to MPOL_DEFAULT (local policy)\n");
    if (mbind_syscall(addr, size, MPOL_DEFAULT, NULL, 0, 0) != 0) {
        perror("mbind failed to reset");
        munmap(addr, size);
        return 1;
    }
    printf("Migrating\n");
    unsigned long from_mask = 1UL << node_from;
    unsigned long to_mask = 1UL << node_to;
    long ret = migrate_pages_syscall(0, sizeof(unsigned long) * 8, &from_mask, &to_mask);
    if (ret < 0) {
        perror("migrate_pages");
        munmap(addr, size);
        return 1;
    }
    printf("Migrated pages from node %d to node %d, pages not moved: %ld\n", node_from, node_to, ret);
    munmap(addr, size);
    return 0;
}

