Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F1DE7DEFA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7A06B00FB; Mon,  2 Feb 2026 10:57:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472366B00FD; Mon,  2 Feb 2026 10:57:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3587B6B00FE; Mon,  2 Feb 2026 10:57:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27C6F6B00FB
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:57:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9B13B6D43
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:28 +0000 (UTC)
X-FDA: 84399971376.28.71EE63B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 00A6840002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QZGjfjok;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKhigY+vVV16+GkeQJXcTpj4vizmnQQIlU3mIYyaz6E=;
	b=xhLO+5f9HO85+tQ5DqFPZH7oC7ljElbu1HarS2LSceqy6n5awhvTDdFlfPxoX1eTvMK7rA
	PcnuvIrzGnaeTSxvp48XzjBGmdCW/SVMx5+8PR8s+6J/MHHLueVgKlKQwj/IhKUTzewaDc
	iCs8ETvJ0v2/sAHdNK13gmqWboMBVCI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QZGjfjok;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047847; a=rsa-sha256;
	cv=none;
	b=RsOYDOYVFtjGos24ZibaX1tPOQUhaNyEYVEhjmEDK7nRRKExEQocUFpMTDJTvA8uF9kOZE
	T2OapzLsrx1HyP1tnmwT8VDfGeZTyRqUv7ChTy3KaGCZvflOdgt7eorylFeJ4ySvZmLLKJ
	h+vLRNj2SGYvRn9rJiwYDg3LD/ZOdDA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B9C86012A;
	Mon,  2 Feb 2026 15:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699A7C19425;
	Mon,  2 Feb 2026 15:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047846;
	bh=4F/Szy/Cik4u0re8XChd+PvOlhHKvV3FFCqDor4py4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZGjfjokPDSHnlpjqwSQdtVHGGa61a3RZjUGN2GocdWA+Oe8hFb9IlHe13igYNXt5
	 as45sEuzodDB8j3uv727voExdfh1yDdL4EH8gJtlMNf+LzDtkCnAcXtxVKa2ADbl8d
	 xCgwh4GKiy6d9dpeuqSQ0Nm2AgFje01Aqxd/QcOmsVC52Anb93ChtzexC90UG9xTiV
	 CpFCGVELbyNKnrJHWkkPMvMR2Brow6+oLXAdPJpYG6BaqtlfQn4wc3BzlvjjIpC3wj
	 wC6qaUiJbMT+y7017wa/GjCQ5Fh3XL2fNpJhqA0WLzKJ+N1g4OCXcn3avVi53pUwIT
	 mrBnx1DMgdr5w==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 87AD9F40069;
	Mon,  2 Feb 2026 10:57:24 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 02 Feb 2026 10:57:24 -0500
X-ME-Sender: <xms:ZMmAae_3pbGsFF7v_MZEmDRgDY2f7GMkRejfgptjcQ21sK8zJTSYYQ>
    <xme:ZMmAaX5UcOLdks_v7i1vRWtO88mrYxHbW_-fJNidyFhLw5yrbfK5Lg3QklRof27o7
    sglVk5chSgpz4LC87bfKGEh_R-ZdQ-uVYtcrqU2yS7p7bE9BFsKmts>
X-ME-Received: <xmr:ZMmAaeIOk3utiWzPI8eF_K1lpuh-ER9c1IXPRqjS2R-Fq02N-UrDfq0bqwhcFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:ZMmAaXW1d65pS8ihA67wf_hRBqAR18KdW0Mev4RAVm5fV6tgKi7OgQ>
    <xmx:ZMmAafJKlnjoDTLfBd38lQaRXg0lCilqWOKaSvUULjJftWd4fIXF8A>
    <xmx:ZMmAaczYts7r83g26Mell3b26W_mF_v-eF1S_kNRLdn9JMEVbOCXUw>
    <xmx:ZMmAabL-FjuRVRpS65ikPOX_oDGGSrBR3c_HvDzbHaC_MiJXf78cNA>
    <xmx:ZMmAafQ9vmeZ028dJBC8OeVsAc-CW9C3OdCX0Mn9hsCgNbY_nmsxO_vs>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:57:22 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv6 05/17] riscv/mm: Align vmemmap to maximal folio size
Date: Mon,  2 Feb 2026 15:56:21 +0000
Message-ID: <20260202155634.650837-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 00A6840002
X-Rspamd-Server: rspam07
X-Stat-Signature: e45tkiq7edk8m8pjmfwpmu4ktzmuztxq
X-HE-Tag: 1770047846-907166
X-HE-Meta: U2FsdGVkX18D310ww2rTKQzkyPXYV1bSK9l+KkiM4FvABR1/b4fKowtTEEneEAoUUHpn0g0KPyS/WXnG7eTcwLlnRxtsNKIymgctLfS4QKDmJxeUKQ2NU6G07ar2WShx8gNtb+d6e+XL4KLXKbxI+Kj3v7+6c32yZve38094cFdnuVQJiNzkDgJry+wiwRh4h6W1LnJaUqnRvfgXwVJaIpu81dYGtNJD/3ahE7+AUbYdggC1w/1yaX3pmJqPkhUZjdz+aBGr3cP4aUQFV91ytvwHeovl0Vo2c2HHbQmdLs3lHODsWv0ONFhtf0LUDUaaTo+gN5ULhLfB+i8+iHl/Zd7nBYLOjpYtXoCHwvc78SMuRVi66D8aqRgX1TxiIW67vTwSZ2apUsH5yZj2lAZKT1ZfdVY1KEcqqdHG4Qi0EGJZBlM4cGaYI8qHSgc5tblGN0XnXPSvE9DMl6o+xX6lJtp+rQHiPzWfju6y5DzWzVNABwZqjvZZCqhVwlCmKzuvxDNCNV1ufJLqRaNgYreghXlqNGXQQRLyHm3GDEqLOH3Bck6lGapbazwnhEagHNf5fz4xt/BxWma16N3JxyE0x1qF7W3fCXiht7PvBUzLyO0ouU8oPCjNkEYTtk6iXEsk4GDKGdo2zF4/XmZEm/ss+fscTOUPw2MrsYFoMYak462sASf7dJDoHJa7jvAt0yhwAg7zgkIbrGMnEqbM9rP71R1XsuEEhZ8MGS6KNF20djCM1NYdd1ZMD3F6Wz/HHQJQiQOl5G1ZHe3vpFhfMievWIqrPTSyZU+w/UUjBuDr0jSSLHRwjLv4DqNG0x/hdN7tbnLyxt91DOJovUnxMHt+L64jLFjuumbIoks63/MAcmPJcsXF43EzHMXMo9jzHYBCjUCSjI9dE1Q+h9JYWzxpqtNUshDCj3ukeH6EBf7+FfS+nTpsoP8rVeebV8Lw2z84rRgBIPVgtDbqC+ldtRE
 Qb+s//kQ
 RdPeIGxlzSMb9JdoGEh1DDxmiYYCqOJZMyZsiS1kMYvqMBHRq7GhPGAAqXvmF/VwOIo5ZzlQdAjNbQHxdcl/bOBazLIcVJnAPD0zb/09IP2bGoFsUpoAqvBCcN8DMyEJPp5blHoevgafmZoim+HHaE1lguQ1ga6Ho7jOHjv0b67KdFgS48aBUaZyucx3zame+f9HkWAEi8+X4w8dGV2k2Vjg/uzDbDcSFa951t86cAfj0lkjXUvVygolBhJbYwPYZk3ra
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
struct pages of the head page to be naturally aligned with regard to the
folio size.

Align vmemmap to MAX_FOLIO_NR_PAGES.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 arch/riscv/mm/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 21d534824624..c555b9a4fdce 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -63,7 +63,8 @@ phys_addr_t phys_ram_base __ro_after_init;
 EXPORT_SYMBOL(phys_ram_base);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#define VMEMMAP_ADDR_ALIGN	(1ULL << SECTION_SIZE_BITS)
+#define VMEMMAP_ADDR_ALIGN	max(1ULL << SECTION_SIZE_BITS, \
+				    MAX_FOLIO_NR_PAGES * sizeof(struct page))
 
 unsigned long vmemmap_start_pfn __ro_after_init;
 EXPORT_SYMBOL(vmemmap_start_pfn);
-- 
2.51.2


