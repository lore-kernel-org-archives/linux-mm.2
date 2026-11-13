Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6932F606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 06:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=XSO8oQUa
Received: by kanga.kvack.org (Postfix)
	id 693AD6B0624; Fri, 13 Nov 2026 01:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B366B0625; Fri, 13 Nov 2026 01:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A2A6B0626; Fri, 13 Nov 2026 01:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3176A6B0624
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:04:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E99FA03FE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:04:50 +0000 (UTC)
X-FDA: 85429057140.26.04882C6
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7472FA0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:04:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XSO8oQUa;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794549888;
	b=wTKTSL/xfxRyoQWYPf0T0q7SZ74vAIjH7byxtY7tJK61y5lpTcvm0E2Fwjn7fPZz/O5j7M
	15mUq8p50Jq3G9vDrDc+BtoZxPvq3wjgmlW+2w/TSodqd00L0AqGXxmvf9NuhqYJf/nrtt
	HZqrIdtqJTZJ/WpC/GIgIqevMJCJqq0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XSO8oQUa;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794549888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xFaxwfpj5KbqoBFMnfOTbn14r38Tg3ox9XxMLJZOVU=;
	b=qUh14/Kcbm3lmIghx98uat6OhXxaWD/+kFkN8zDmipAN2RM7Lz1rZ2RuUuT/2KhtMFbWyC
	ZDDRxiqAlDEwSLj8zX2n2q2x22vJIF3fAYDb3k+XUdK+7Kmndcqb2gL/kKRuuY1rWmfQdg
	sEab1PUOJYTnVriRY83UmLv+j69gS3k=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91f0274f88cso9511796d6.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794549887; x=1795154687; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7xFaxwfpj5KbqoBFMnfOTbn14r38Tg3ox9XxMLJZOVU=;
        b=XSO8oQUa9aDd8Xoqx/JHB2l4HxnYirZNlODkbPQQzaciEHukIfFs9QuDGrNFu/Pcyv
         DE5UkAte08Z96u4UWHrDxojSvdqcEMGaylrzSBn7TnBINM/gnKlEgbtk3rAQiRr29fYO
         V/aftB0IiBSUt50+J0MwDNKQ6XnjOehkwmMJEGIY3CcsDNFNg+RersOey8S6u4Cbtcey
         iwawhAgS4qtl/TbcPIDxvXXHdSOYvm4bROKNGopzEI7GqPRP38hY021QtRxdjN8byz9p
         uibIfuGwchwSMaevRYEz7hsDWGOceE9TmAkpfXeB9YbqcEsevmZYFh5QcYjS8rpwNyUU
         a3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794549887; x=1795154687;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7xFaxwfpj5KbqoBFMnfOTbn14r38Tg3ox9XxMLJZOVU=;
        b=Kl6GKwoQ1nPlhrbSVy1XlRQF6PxDMZo3ypR7B113W6ec3JWfVB0S3nuZVCJ+k/Ik+Q
         MZN7xJnGbp/NcTW0wEnvo/wJDO7tIad2Ht7wDBqEDdJA7sovCgO7W+Mze3gLE0cfv3Gt
         TZrLrvtpMDSidnjVJ0u71Av/effWQfe+alW87HJfH2KvkaE6b5x2Efv5yWsFR07eTxjQ
         vei7rrLajyGzmDBAaeDPlTdSXmSVSHiygtHTn8lbRoOtz6JtKm3KZgIFYOW3s0h8/5Aw
         9TJO8kqekdJ2VHB2B/hzqW+HF5iW3tStP+uRT+rtGB/fusB/tdeEGlG6c9l8gDvZ55yD
         77qg==
X-Forwarded-Encrypted: i=1; AL+hErH7l/EJ7O1n7zN+j4B/HZNHnNTMLuJlSBfILwfQt8afExTyc1Edf0BPmQ7ViJncpksCt50jbpyExw==@kvack.org
X-Gm-Message-State: APuU4Z8hco9HVuj5RXv9ac/VZW1c8abeX4/6wu3kMW+0JkRSkRCLlLr/
	tO6eym+JHlds6k70UGmAGEkTumIqcpQOXAuonDKmI8fqan79OKqouJWZo4m+UE46H+w=
X-Gm-Gg: AYBFou21Mx5GdyAtbYgoJ0i3/JsBF2AXVb63dLfTBNgchlaNCPqVaMtDhJPNnuNO+Dc
	h7Hw24Ww92lsjRmXGm8gSPaejfqBhGccyr0b13+jBeZPNnrqf/TXMM+d3vsExyvzjGsCXSjvks8
	/FTti7OxVQYHl1IQ953Fe/EiZVMsuRWgLpK+79YQkrdwDHKuE4+0rVnN5YZiyQlmxG8DuxS837d
	5MnljG/3PiS7e9BW/vxarSO7zBqDm1ObPgAGVGo+WKWf0Evaev74XmKPIGml2gGMS5V1wZKb7RW
	oIp4ueLHR4Z3g9cfoOCOKKojsL8p4hyKTysDG9Gr+x8SMelqoXdhriMMmS/yr7XMW+MbVtMFl48
	MmcEo2ElcrMEjZA86sQiAeUX5vIcfStlu0lxXIVM8oIKf/ggxESrfc+S9z2Hiao3GAFdbpl2Ye1
	BUgzw2nUnO5MVLA/MhTU27xXfFOPzMsmopVWEgKsbbTwynshF3U6Oay+i3OiwMWAdBg5DJxbOup
	R0eFNorQr5+mjVXrUIAcVxyTGhuqzUjlMnBoUp/mIwE9BgLhAW6NSyUrjNHyu2Z+celW/mmt0ii
	g+HHgt0NSk469yoD71Q3JGvqXQ85qqiErpXLgm2OLxKaA4a5ZlqFvm54t3vNvQgYLfyYPqglvrM
	j/vQqZI0=
X-Received: by 2002:a05:6214:3f81:b0:91c:6d83:60ed with SMTP id 6a1803df08f44-91f2424ace7mr21809446d6.55.1794549887409;
        Thu, 12 Nov 2026 22:04:47 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23c9ade7sm13257376d6.5.2026.11.12.22.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 22:04:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 08/12] mm/migrate_device: do not migrate a
 uffd-protected zero page
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Arnd Bergmann <arnd@arndb.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20261111-uffd-state-fixes-v1-8-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-8-00713d368976@columbia.edu>
Date: Fri, 13 Nov 2026 01:04:45 -0500
Message-Id: <179454988585.482102.2051616940227067987.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: e6yc6w4ggpkcjzhgn64rjuf6xynwdsg4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7472FA0003
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794549888-282645
X-HE-Meta: U2FsdGVkX18Ls59Ag5zHm4npbDBIbw3TLPrwsMsPyePaTV2uqLxYx8dwSW50brhJiUxO6p1GW5bMNJmhW8DPzqiVkzzb1278Et0BchfbkH6f/z5ALSbVIeqppe8PS0gtTRR3mHEhuI1E8ewWNr+SFoY0A2JzOjB1CzWlc5p1Pos4LPTsKXNmjnXwn4xhrdi0yapqOLYy+Vt2gNnTIdWMQT3Uo80AZ5xgtFac/rGSXkAiq/x7bDZd1HR+6/R4SGDOHPxhV69vo2jyAjbQM8aEqrEiXYIiNOa/7MV/BBMG9jS0H8JpJM3Ydy/dELZuF3oZKHkD9TscVHq710pu3oIWMu3E2rVBpCynR9pJ1XpySs6EbvhideZoleKZ90dsVk+2eXsYqy5StAeGsuCbDpItlfUe+VrW3qLjgnuj7PUnosIVpKPuBvjS6tQO1YtCCtfaGQCSG7uIr2jlS3gmKhEIcipkHi4RFLdoxqCCmh2CAvGBIOKejitEPSwAuYMD/X9uHk4YgaMRiZbWY3amBY+cq94YZMjlRoYVyUCP4KMWm7X1FXuTK8yqv+jxMvSG4ue1DBYM+ni71EbD41AFTjJJX12TI7Y+bdySPEsi0QXYa21xdHEARywDJQ7dp97c4zJk44notg/xx0jx74WsKQAbnHmbn/G91jdNAcV0gYLu9loi76f8u4/RtYwINZmufT1VPWffZS1Oe7ZZKxfBe5grfIRhvb6hrhoASnNNY4xK7bBPm6ja7lt+q7n0FhIwBH0PudQo4AoOwEzQ3B82nwmM/pQDJXMdbGi/tiMs7dgVPG2qo+cV6b3uven+vem307nni7ZJhhqob4Fb1wMPGRZZ5tgKN9OIsJNvrj2jjS9DIYnEJAtq2UyR14BEUdFleWmgLbYNGZzXu+5I0xwwn2N+OhlaxNoykCsGCXOyT7xTVaDyXII9tTI4Na6bCDNdaeAJ8JK5s5gjNHAPbHfE8dn
 ouLDt5Jx
 iEdrtvT8rkUqr4HroZOd6x3FsLwKuJmCGNr1+1xC2d5x29saUQf8JKepFxpSqE9EnTv94kIg1eU2XUGDQa3F4DbuhQ2bUmX7ggfKci81JkGFb4BJB/5O+EvlekdzKTzfFst+2mhWgR81ZzS0Cm6MjiP4NS25wq4UqEULtRhFJfkvUMYzLLwerqpyl+EvkKhRi7wWwJIYgFBlTqIfG3CgDNU3xmjlknkGvkL9xdu62znVEP8Xzk2hq5krYGSgjtsLKE02sK49wQCW5DAiOUPsMiIWbyCFytKA5lpQdgRoD3/6d4ztxgh7gHKWvrqpAvEYwD/7+mANE3stXcJGaAiNj8/7LVvmQNhvtas9kQkzPr/m3WJRCTxcw/8V5+NWkIjMlQtXH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 12:55 -0500, Tal Zussman wrote:
> migrate_vma_setup() installs a migration entry for each page it
> collects, which carries the uffd bit over to the new PTE. However, a PTE
> that maps the zero page is left in place without a migration entry.
> migrate_vma_insert_page() later overwrites it with a new PTE that is
> built only from the VMA flags, so the uffd-wp bit or the RWP PAGE_NONE
> protection of the old PTE is lost. The same applies to the huge zero
> PMD.
> 
> Once a driver has migrated such a zero page, writes and accesses to it
> no longer fault into userfaultfd, so the manager misses them. With async
> tracking, PAGEMAP_SCAN unconditionally reports the page as written or
> accessed.
> 
> This requires a driver that migrates memory to a device.
> 
> To fix it, do not mark a zero page for migration if its entry has the
> uffd bit set in a VMA registered for WP or RWP. The driver sees an
> address that was not migrated, which drivers already have to deal with.
> 
> The uffd bit can also be set after the zero page was collected, as
> write-protecting only takes the mmap lock for read. So check again under
> the page table lock in migrate_vma_insert_page() and
> migrate_vma_insert_huge_pmd_page().
> 

Similar to last patch, this changelog could be improved.  My best
attempt at summarizing:

"""
Device migration replaces a zero-page mapping with a fresh entry,
losing its userfaultfd WP or RWP protection.

Don't migrate the uffd-protected zero pages.

Skip protected zero pages during collection. Check again under the
page-table lock before insertion, because another thread can apply
protection after collection finishes.

The alternative ...
"""

I have concerns with this:

> The alternative would be to carry the uffd state over in
> migrate_vma_insert_page() and migrate_vma_insert_huge_pmd_page(). Not
> migrating the zero page is simpler, and a zero page that is protected by
> userfaultfd in a range that a driver migrates should be rare.

This basically force-fails a migration of a uffd protected zero page.

Wouldn't we expect this to cause drivers to fail to make progress if
they require that page to be resident on the device?  Not sure we want
to force drivers to try to handle this special case (if they even can).

We'll need some input from the migrate_device/GPU folks.

-- 
~Gregory


