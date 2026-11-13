Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59777606A333
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=aAzolQjT
Received: by kanga.kvack.org (Postfix)
	id 60EC06B05B0; Thu, 12 Nov 2026 22:35:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BEE06B05ED; Thu, 12 Nov 2026 22:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AEDA6B05F1; Thu, 12 Nov 2026 22:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5DF6B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06D6A12059C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:21 +0000 (UTC)
X-FDA: 85428680442.22.8D842BC
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9A1FA0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aAzolQjT;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mrv4Fj3Nih9i0dF+SR2v9n/Jjgg1ueiHuwDw4uU10mY=;
	b=kN+IjELW+fduYyOudiGOlABCFmbnQ7et6ggv7ppoMx9bgFbopRw9sPDYLiqRVNGeaJjKv9
	YmKTib1LWRR8frWgWgOz6blKZe6uODA7ri/RylH49q77xir54hW9GSeYw4JHw5SGvVvz5F
	ORBCD2sCaG02wxS3zqR+FFfv6GVhPBE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540919;
	b=fNdort28mPH1cq2rAy41EG77PP16hzberiY/1T2uu50Iucj3JjkaLrp1chDzPCmzkTkIuF
	xH7Lx8hg2q2FoECqk9rWLfBaH/UQ5/UIAugTzRe9ieUgNoVxdEytd26CVe05/TUbB+NazJ
	GfGaUDg+9f22VurJMVjIrPzNZJE4EEM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aAzolQjT;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso1346690eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540916; x=1795145716; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mrv4Fj3Nih9i0dF+SR2v9n/Jjgg1ueiHuwDw4uU10mY=;
        b=aAzolQjToROyIWLDAbXcYbS/1AYHDPQg73c9aw38IwniOciIIM8iX7xvOvdkXuqgqa
         7LLg4JMhOV/Sd32kMamDk+yHBH+DOP4nBfCh6J8rjayc/Tu9SnRUip9Iz2PuAH9AjHBq
         cd7CowZNlrsL/oEBAP+yuUm2M5pz26Pqv5aKKz+sKUUPmJT3Bq0YUeUZ8KQkPO+h/9YT
         VFcNzd6s8kfCXPhgMa/eabxAxC/T7vP9CFXWAosI3COOOPPbANxpZTsWwzHi0b+FjwkX
         j623CqXDyIFhlAsQi2fza2qmR3xqochEsqkep3zTgZYfQtdh4vSsm/jxvHxWmcDE/++l
         2jcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540916; x=1795145716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mrv4Fj3Nih9i0dF+SR2v9n/Jjgg1ueiHuwDw4uU10mY=;
        b=ALUNwAnQihqeIEUiriCm1X8hAsYjB7JdLkkQqnqcpS4NQiZcPl/Ks5X4by7l8632J7
         PDfGbVDeNif9+tDTH00EUJuc42uJ+d1m+YhNJlFntxnIJ05AJogBmRCi3bLkSlJQLeYC
         ymj7cS/Vo8PPYxPgZa5Wcl0sVpN2gYqUyghMS6jQJuQ3VE36UxGqoQzArlkb1rGAj7eZ
         Km7bkS3K1cgEDAZh2Fnoht98pumtPaReYG49wbopP0kAlHCkv2j55/5BpAwfnbC4Ylr2
         JZhFv+7Z3SveIzClRZnRt0E6XKmBorMTTVUiZSMz5Q0y732wR0kZUvQqbV+wkH7nDsTU
         9o3w==
X-Forwarded-Encrypted: i=1; AL+hErFEqJ4NHj806fn4axuZhg2NU/J3WeQmIYOD6VZs0LPbbWgXpn/nPID2KczIGyzA/Fnh5+a9yvWujQ==@kvack.org
X-Gm-Message-State: APuU4Z+888QI918+ZcAPrgIMehNQigWccczGHxxMKfzug8MPgI/Z7FB2
	Xqwt1g3TpLokt9vgC7sbjU/n/v+lRcsGR048BFNr2bJ71tRQWVeRScqZzUa/DU0cgdQ=
X-Gm-Gg: AYBFou3G0F5E+Sa1n3lXfnwc8h7d2lU6XpBIsOAa3kPBF5hEOd5zGB/rQIngc8WXO4e
	PRCZ6bXGJOJSiBZa55IoB+P/h+hsZg+ZM0KVMrV3l3kgsI9xpDzIhP6iYWjaPKheH+IbjbeR/+9
	BlYY8XaA5d1A/vI24OFklevSxxMo8qOZNGtYSZEMxU6B5igXKLix6m7dz9POHxGdi2kw5MTGUQD
	7PFD80gusoPlAoP7QncPLiiZBLXXbBTvxabmb2QgJ4B6rivSv4mfJrHCSi2Mf0/p1fz8+Yinhps
	wIp7IgteU6XDPeK4vu5AR05y5nrbQMTXMUojCRAbNN6oIHohAhdjEnlUGiHxHyCjA28woywU8EB
	baIs/rTlHp9hVjdoetp4aDXQHavTQXdRYUPiqAt0skZ8z9oG1jEbRseFTNUF19wrE2iN+UM69y9
	Xs6CHMZMf6E4qBaTS/s8H04+Qw7ajsJjp7tPImGTwCTBAG/rBvvd6clwYYcGCytZG9Elcbin86Y
	KQGj+GkCxfee5t/A+wuLFKnOyhJGLe6ODXNVKS4qVM6qIMFmJ8ZpOFHWYh6aUKTyBlAwbgTegnT
	JOJKVt5oY3L1ZanT3c8URQrn4boljBuVtsUOE48MdV/VulN+iDWStoc8DR+KCg==
X-Received: by 2002:a05:7301:db11:b0:369:fe4c:b48f with SMTP id 5a478bee46e88-3796047be6bmr1056859eec.0.1794540916137;
        Thu, 12 Nov 2026 19:35:16 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:15 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 00/14] mm: Unify memmap initialization for compound pages
Date: Fri, 13 Nov 2026 11:34:28 +0800
Message-ID: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qz93et1o7b1qirqmrq44mgc4fc9hb1cy
X-Rspamd-Queue-Id: E9A1FA0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794540917-903357
X-HE-Meta: U2FsdGVkX1+rym3lH7PUyj7FrNP2UWrrtcDb27QtBYj+TzxDFNqOFA+KwyQxKtAmnuJ7jTgBdJcuHvH+UaJo7Is/foENg/3TbpFtyl+f+aDkXY0zmCYRkysVoXB6RrGEpO6QNDXum2lvsGuhJZM7dGbIkGlup/gsHzOO08bHEd882QkH4eEV9UC6j37UCLmdhp6ZAJiCat8lUNxGJKw02UD/X8cnhxvejG/KTvEKckefhi9NjAeNBhgI0RSlcutwq1Z+4eFwI5tXXGX51SN1ur1Cqq++gtnPmXLd0uArYfkqOJksUodiIZQHXHVG0PLTJb9Lp+XHsSDS9xEdOVm+98mWT0j9YFKHUWkC8Urq/ScEi4Ybifzde7NEz0i1waGrt3mErmnLYnR3iFG3zUgrC31PXnGAzujrFXew4SfnA1/13xLv+IpIJIUwpjZVem8Ke817vKTC30sGNxC4OlfAj6fB83dTkGfVDM7cDC72weMusXEbe2n8qqdfjlN1k92X2mbGkfA6vE2fcV+HSTiin3fOQx10XfrShY5EmXfF0dMIz0G32K1ifEQqhWRkWzzAyH9/qMB8MHx+XNK/6Ksgn7riByAFmvGq3PCZwTHAGY7xeXqJTDlP43y19ZwJ1chYhaJXdzQ1oc/H7Dou1kTOGFDHBjZX6u1ZW3BVCSadblzweZ4fWESJZWeQ9S0hWxU/H6BGGVwXWbsfEXLrTNj/YDxIe/g4yEVuKBZ8CCGOqha9OHgpQIF88e0n9v2HBYRAbBfRSJm7OL8zehkVg8MH1B1zCEW5TqKfEh4DVEPO+39bBx1cLryd02FkkLMiLhSGZqG5QeUMDO5r+RyVZQ3YXxJi4C24thmtZkpiYVWCUnNiDHfkL14aZZ//1gkJBci2zxKgvZ9JRrbzt4mlSR5ENq0GgfNQqiAVHW4P2g4LMuy05ZjG2JLid2UJnkEkBrzZCFadeyT7q3F4ZWzPGcV
 kefIo6ii
 azq4iy/Zfj6iwes76kjvRkoc0uDttWcq231BpjmzrqQAXn3rYZMhBVQbdT33JqRgy7TNUcZs4nGTfkfNoRb9065Eo9rP978grMhtpd2vaOf/DUltg1U27PD8LYWmSKCeeuDmmWq1S6ktz3uQXnCwo5WBCfoDNSuuQJV74A9hk/uCUFJBqVZx8PPa0nBdIP4npx+jN6jWTigvpFCMWi1wNleq2MwiomlxeQ7CglQAup5wv4TVTmYrtg9di/kA6moArFSI/NfxYjhGeOJBS6GJhfjAahu9NdiBoZew1WwXTZVhmYOiBT1ERDFz3/7dfamKV9V2FxL9D0LCC0Qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This v2 is based on the mm-new branch at commit daed51c91051.

This series is split out from the earlier, larger series
"mm: Generalize HVO for HugeTLB and device DAX" [1]. That series
generalized vmemmap optimization across HugeTLB and device DAX. One
remaining piece is the separate compound struct page initialization used
by boot-time gigantic HugeTLB pages and compound ZONE_DEVICE ranges.

This v2 also folds in Li Zhe's two-patch series, using that series' v2
as the integration point [2]. Those patches add
memmap_init_page_from_template() and use it to reduce bootmem HugeTLB
tail struct page initialization overhead. The surrounding patches in
this queue are adjusted to build on that helper directly, so the merged
series keeps one template-copy helper and then shares frozen compound
page initialization between ZONE_DEVICE and HugeTLB.

The first two patches are the merged prerequisite series. The next four
patches make the generic memmap initialization code suitable for
sharing. They add zone-consistency verification to template copies,
factor the PFN-independent page state, simplify the ZONE_DEVICE template
setup, and introduce a helper for initializing frozen compound pages.

The HugeTLB patches then make boot-time gigantic HugeTLB initialization
rely on the common frozen compound-page helper. The following small
cleanups make now-local helpers static. The final three patches move
early-reserved CMA pageblock setup into cma_activate_area() and then move
MIGRATE_MOVABLE pageblock initialization into the shared memmap helpers.

After this series, boot-time HugeTLB and compound ZONE_DEVICE ranges,
including device DAX, use the same helpers for frozen compound-page and
pageblock initialization.

[1] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/
[2] https://lore.kernel.org/20261112112816.55095-1-lizhe.67@bytedance.com/

v2:
- Fold in Li Zhe's memmap template helper series, based on its v2 [2].
- Remove __meminit from memmap_init_page_common().
- Add a cleanup to make memmap_init_page_from_template() static.
- Collect Reviewed-by from Mike Rapoport.
- Fix the helper name in the final commit message.

v1: https://lore.kernel.org/20261109095807.41547-1-songmuchun@bytedance.com/

Li Zhe (2):
  mm/mm_init: factor out memmap_init_page_from_template()
  mm/hugetlb: optimize bootmem hugepage tail vmemmap init

Muchun Song (12):
  mm/mm_init: verify zones for template-initialized pages
  mm/mm_init: factor out common struct page initialization
  mm/mm_init: simplify zone device page initialization
  mm/mm_init: factor out frozen compound page initialization
  mm/hugetlb: drop boot-time HVO handling for gigantic folios
  mm/hugetlb: initialize all struct pages for bootmem hugepages
  mm/hugetlb: use common compound page initialization helper
  mm/mm_init: make __init_single_page() static
  mm/mm_init: make memmap_init_page_from_template() static
  mm/cma: centralize CMA pageblock initialization
  mm/cma: localize init_cma_pageblock() to cma.c
  mm/mm_init: move pageblock migratetype init to memmap helpers

 include/linux/mm.h   |   8 --
 mm/cma.c             |  24 +++--
 mm/hugetlb.c         | 111 ++-----------------
 mm/hugetlb_vmemmap.c |  17 +--
 mm/mm_init.c         | 247 +++++++++++++++++--------------------------
 mm/mm_init.h         |  13 +--
 mm/sparse-vmemmap.c  |   7 +-
 7 files changed, 129 insertions(+), 298 deletions(-)


base-commit: daed51c9105158768a3949395135aa6e0a04bb7e
-- 
2.54.0


