Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7125606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hrufulsy
Received: by kanga.kvack.org (Postfix)
	id A6A8E6B0667; Thu, 12 Nov 2026 23:07:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A425B6B0677; Thu, 12 Nov 2026 23:07:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9591D6B0678; Thu, 12 Nov 2026 23:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8A16B0667
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:07:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA50A16011F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:07:35 +0000 (UTC)
X-FDA: 85428761670.11.477861E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4B98240003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:07:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hrufulsy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794542854;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxMgW5huLouIld0ymXBP1UEYYdgHciKDLb0j7qBnKXc=;
	b=yAeicZqLQeFDP/W4oRqdk/6dF84O5dfMftJuOetIrcJPrw2JKz1ZTcmdPrNiMJReW5UXkd
	H7moidgjFohHzhfYI4pKu/dmtVsyUFcVAJr/TGErqv9kAfk4+KMj/ZKWyMnO5LqtEVA1EU
	6s/SYdfxPq/dvEFKiudN2fHQK7OIYzg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794542854;
	b=EpjTQZ3UQ4pQRZKC3UdfgNSNGIJCAUh34luy/IGvaQcFBwy53XuoCCYibHlKEiBc/uQ+3+
	hoFN0p1G9gIbFWl4QGsiK+eE1pNBxfL91zcT+RfJJl197kDnMwwQ5WEQ21XkJpFMP7byPO
	6R0HOEU6rOMgomxLsyN259kCuwNwV7c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hrufulsy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A76243365;
	Fri, 13 Nov 2026 04:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6B81F000C4;
	Fri, 13 Nov 2026 04:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794542853;
	bh=vxMgW5huLouIld0ymXBP1UEYYdgHciKDLb0j7qBnKXc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hrufulsy+Qti4urLhz2gh/gullHYCCSieIUqMuc7wLL5rouGsTc1Mo8pBYLgXBy7H
	 13rYXl2LwqWOO4I5vKAigG5y/DxniQ7/bK7EacOpxJClkXmLViMULJ9DOwUJt0DONp
	 0EZDIFbnb6lJTsVlElrnd1B2MzvG/P3182hvdFOPZUYH/crBTNe22K7lWsX159Afla
	 3Z1y64f0FPvzlLwq0419vFWnBoInHpajsm/xkuQ7sxff3D4TdC+h3CvsXId8n6FAEP
	 6jDJ8FsDXmeZCA207iE02E9S7BFHsM9ZnU1Ks57igjOJmfslWNANjmDHWl1JOvNV2C
	 7DS+i+M1T42dw==
Message-ID: <sashiko-outbox-212147@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/14] mm/hugetlb: optimize bootmem hugepage tail
 vmemmap init
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: "Li Zhe" <lizhe.67@bytedance.com>, "Andrew Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Muchun
 Song" <muchun.song@linux.dev>, "James Houghton" <jthoughton@google.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261113033442.62970-3-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 04:07:32 +0000
X-Stat-Signature: cmw9driz6r344or67wmn3c8jy3d5jdwe
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B98240003
X-HE-Tag: 1794542854-882323
X-HE-Meta: U2FsdGVkX1/SthBAR0RqUR2mKoJDanCFlXCDsnyA3GPX8RvrRkiUa+8S8ljTr3LBVZWSgbRdknPeUx6TRDdp78zLwb5SkVlLFcBRxcaG4GN/ViDH77cADkUEI3W4jxIamGXwKulZ2zgil+91pOBvwfN8kIS05o1CIyAja4x/5IbrSx4P5ye+PXhHbti7brucjqPbcU7/Dk/7/FTg+6ZUPMMQjVQBkVoFcW7kYaHMuGGz8cH9bBoPJOUIyCZSw++681LY15ZDZPmOpIQ0IldPjzE51IQFwYHQwyhDbshmrE7LCQeBNf3EteX4DIqAQhWlo6OiceN1nDXZV8zD9LUXN5eXaKinu2Z2YVyzQItRVFK5G+JvtLqkdnrlQcy8YKIZHVtr1zFyWAt1BRXSLnMPtANVhwLdr0Ei+czLdKiNOyz9/CAKLzmr3Pkwmztus+5PIgKsnAsMO0+kjUmvVMv3u68N7OVa0S654i098Eo1B8fMcNS2bez0vYOrRAWYtBSeICBMT807PsuWfgGEDeRRlT2K7pJfb4PhGQYIRF41YytYVapPAjNiseVysnytpIy6hGYXa4aIIjfRY/JW86nRsYLCf80/qMm2MhZNs9B4nXnqfOe2IRLtmPtDV1zsCxBam7QzYMx5ehJ3Sm7C+fJJyxKsJ9l6834U4JbrLK4x3N9ye9b5Ni7Hh9ok2Sen2mPmzqyPLnTiXM9OTG2fjR23oR1IagB2q55FHA3sn0stKcLHUBfToI9b0BGqEFZLcH1VD+ellEgVDYEwNhwfTYYMuuRTcF28HcEmTdfWOVnYSTTo81Dd8YoDksuy6chWmvyuB3poJA/S/a49sLobGdOwL38UZ+jQ8fs0/Lf9JTbnqWD0oy2SN1GesnIgQOcffYjWfdSEA5E2yHlTzyNccT4nebk8iMRaPFia+LZI5kI0lf1P2gQK66aiN6RUjnEAoSPbZ0Zgu5/LFwX/xq0t3Aw
 Vdx027mf
 BqMl43ywC4pPRWpcTVi6rNV+H+m/+sDU4tvxu+D/w0xpEOMJFdEUEQPm7GJ0GXqO7vlMWs1tvM8VoHPY+dIgTg56YYAB4IvisQjwM6NjA57KhiPul0w2E8MaH0xkGAbtkiVvxI5x++ddFHaz7zsCFQpYkG96Q/h3qw7daIi4AMcVMmgIlM+APxl+jfXhYTMYrwsF4ReikbORxTPH2YKExj426IiNWT80vdv4qHgQAIx4VqdLzKMiSd+JXg62m8oUX0Zz6nzBb0DATmnSm/gVS1u27YhUaVKxY7+VlgOMI57BkYNqgiLYdvdadYuHoIMQay5HwZKCJltxC0/TZcgXmJ8THfTLmeAhzATIUUI/AvD4sut4OkaU/v19ZdlRUP88a+V0Xkl/DU+8mblGTYKND+VK1S+DzWLVQ5tZtGyhR9nsqnunJm6D8qcS+/gGzrUO7xPJ1mVjcqIHSxZMCDc7J40kE3lM//slXexwqjBTeTsWdtTSIdXnytiCPRpT8jmuYFaeyHOZ01prVebWmd08zYzR5Kw6G83IhWB+fE51uIRVXFd8h3IhSKt0u05doEhmGAUKWyZaQl/QxhoYvr257mXg3/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/hugetlb: commit message mismatches
  memmap_init_page_from_template()
--

commit 7cc97c08b2296fc2518d9ae6da5950cb731c48eb
Author: Li Zhe <lizhe.67@bytedance.com>

mm/hugetlb: optimize bootmem hugepage tail vmemmap init

This commit speeds up boot-time HugeTLB tail page vmemmap initialization
by seeding a template from the first tail page and initializing the
remaining tail pages with memmap_init_page_from_template().

> Initialize the first tail page normally, then initialize the remaining
> tails with hugetlb_init_tail_page().  This copies the already
> initialized first tail page with memcpy() and refreshes only the
> PFN-dependent fields in the destination page, while avoiding the full
> __init_single_page() and prep_compound_tail() sequence for state that is
> identical across tail pages in the same huge page.

[Severity: Low]
This isn't a bug, but the commit message appears to describe an earlier
version of the patch.  hugetlb_folio_init_tail_vmemmap() copies the first
tail page into a stack template and calls memmap_init_page_from_template()
(which refreshes the template before copying) rather than a
hugetlb_init_tail_page() helper.  The commit message also omits the change
in memmap_init_page_from_template() that restricts memcpy_nontemporal() to
ZONE_DEVICE pages and uses memcpy() for other zones.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113033442.6297=
0-1-songmuchun@bytedance.com?part=3D2

