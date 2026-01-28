Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 462AAD2592A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1186B0096; Wed, 28 Jan 2026 08:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A994D6B0098; Wed, 28 Jan 2026 08:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9911D6B0099; Wed, 28 Jan 2026 08:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83A336B0096
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:55:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 530DFC23D2
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:51 +0000 (UTC)
X-FDA: 84381520902.01.59F2EC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 403F2100005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZOvBHJXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608549; a=rsa-sha256;
	cv=none;
	b=I+3wZfrszZGB03PdX6lmU0ea+ER1YZhhshmvgLpO8U/Rc6K/BX2YTyA3yvlW/FXZI+XCs3
	JSiEvW+CxGWHdKm7txoROFsli6kpK4Bh9A58IWSaUzP2D/782IsMXOg2UdcWjkSAD20Ws+
	0QVt9MjQ0q3U7tX6yXiaRuxkAnRZ2+k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZOvBHJXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKhigY+vVV16+GkeQJXcTpj4vizmnQQIlU3mIYyaz6E=;
	b=ieq06SPIMSqWhw49P9ll1exDega2afFd14vkU2eHcLDCtmxmXWr7nBid9lU9or5pIeDASM
	iuJUWkfsXI4Ms/MUZwWwIp/JyuDAa6xbXR2dzAQZcWQZ2q9cz+DQ6bTOGWbBjGqeFYP2iT
	t/BcpTnswwIlwnmyYx81yhIBvEwcZGo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 721A644481;
	Wed, 28 Jan 2026 13:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612D8C4CEF7;
	Wed, 28 Jan 2026 13:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608548;
	bh=4F/Szy/Cik4u0re8XChd+PvOlhHKvV3FFCqDor4py4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOvBHJXCBdEVSav7bVOSuhG08QTbWvvlM9vHrnJl5ke4zZXkKPaGxt5MvEPpy4P9e
	 QwzpK/Kr4Ua8TbKh5VKpP6sNpd+gmwJta6H/0RyVW9r2xreLLJa2vZBNKoFEjX7wV8
	 XAHIfrer1Mb0YgoLxTXS1pNWz2GQJ71g9FdzlaLMhJHvlFUrAeMA1Gy6Hgaam0seB/
	 Vn0m6dnSqwAUlkJa+9tojRlgioqXIC38CDAeknvH3XFWj/eVrnEC7h28SKuxzDW/b8
	 MbV6xOrpb5b/pO6wRE3AyBTPe07b3jUbhvWgO3R3c6n3Eo5J+G/m8E97omGPUJd5ed
	 YttuFOQuKJQ/Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 86550F4006A;
	Wed, 28 Jan 2026 08:55:46 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 28 Jan 2026 08:55:46 -0500
X-ME-Sender: <xms:YhV6aQXYXK4PTlTlsGsi-EXDgRriresz04zcDIqotuZmvsZtxfc6Rw>
    <xme:YhV6adyB6XEUNHcJ8K7DZOLxtSBEh36rgXKCwi9-RpGND-xRgTk2NiMsRJbMIWwIh
    nA0-rey9kH-zwWaKo85QcjpbuVpn2wu4XYje80DwncWzsGRLbOjLmSh>
X-ME-Received: <xmr:YhV6aejTlcdBm04B9Zb0ixADZ-pd27JuoZQYdmfPWkW6bKitM1aTngU2bzgCzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:YhV6aQP9MF5N76J4tglK2iXE7aytvFT2B8OFD2wMmvEQM6ISVZ-P7A>
    <xmx:YhV6aWhWq9u5KMXdTYtb8umMsbSReRRuuzZCbY3C8WNK4lOaheYJ4Q>
    <xmx:YhV6aQq-wMuxk9YdIal3rqi6WZ1EAwSdLvkzeETKdd9rlQEhRB4HMw>
    <xmx:YhV6aRhOa_W2y_xmndaioiM4BSpaB3NIJIRSWZirCBqugXLAfWoqpA>
    <xmx:YhV6aWKwASNwQ7mAJ75LFcnKUB3-Ek04FvMrOZy1jdgYEszqG0DUyZgv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:55:44 -0500 (EST)
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
Subject: [PATCHv5 05/17] riscv/mm: Align vmemmap to maximal folio size
Date: Wed, 28 Jan 2026 13:54:46 +0000
Message-ID: <20260128135500.22121-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 403F2100005
X-Stat-Signature: ewfseooqqptmsks8grjtc6kexabn4qyf
X-HE-Tag: 1769608549-656905
X-HE-Meta: U2FsdGVkX1+W/KksS4/D1ei4n3AnVHh+SYcSU/B5y2Qpyj79ku3pXN3UTuMiZnNRqsnuMYgixcVUN/49cIF/zdrUZaV0EtkgQpNzQe2bFikawLUi3GNIJbJyjy6hpVTkraf6N/rwmCYw/P30m+Tk6DudjcbejMYN1yZiqEjKa+6ogC3GT40ikIXGYuQGRMEzEG2mAaBEs1l72U45HIqf8ejTfhpxGjUcMBtCQNp8ILruobKlrecFzpSGtfopL23aDDUxLNNWldHTapPpzDfxCy0PP9BZECe2HPH++dU5/duGW9op34RolFTC8oQT9FFWBuEdaOcL0MrtSdAh9PyrYCvFlm1xCc/CvWdCYilyt7wMQo6q48TIk1P1pOSH0YDeIZVI/zQk5KUb9awaX+5Z70oT4ahiwlYAm1B3SA+W/Qn7UJ3Fv00VKTEEHuhYQBHIvQ0dgURpLy7ScqYTr8Dy55fPNdFsfOzerHvs0aqD4foMQXi/psCSOWBo+vJao2Yu6ak8iR+ZSJnQPQ9AtiRL5t4L5+H3FzsWxfpenhpMCaGqNsnpnkZb7mR4q+aUXKCASA2hmhfq1IvpqF9sYuW4/oJw15Jz29t/5w2zmQQjjkgS6c3IDexrkbEhWsPEsgZXHx41Rh2zlyk9UETRm5QVmOzFQren2lto1RUZGD5zw64jHR8gUP+VQimSF4AV+16ca56BpStGq2vOo+FDSGDS6MwUOSdLiYWaAoEsDqkP/MrO73hi/VPTN60Tyb+4HgTllcASK5aWpqy9HOMcPccfJszJ9Tphesps8GuFFsTRwz41QcIStSI8AY4/szYqMhTNZ/ZAk1llc4J//ftlwmpbOrG8GPU32+QKT77EJxoQXiQmCNDSQiuBAdAdyknA16vyjZYNujny6jwL3BtpFG/JuKDj6O8yen1D+wouhhyYxRR8Hv2eSNdWQy0IS9FJq9jEVPlIDpYX6fc7sarVo3v
 D2wj0EJ+
 neJv0IwiNwshUb5ryD/h1+QntYvKB0Me6umKuutazKVgN0boSZlc53meLI1zsSYNhJ9NUSlTIrZLxL4US3pIQYvj05cnXevzDxade6dadX36cY3R1AhGxkL1pnXpHzWX1UEznaa4XFFNs6C6Bf5BH3yfL+0ULORhcBrYi9gC8tZYhamOoPU7Hwq0qLF7Kpx0O05l0dRwrFPZTvSMpZeQM+5sM4LVpjsz41kIU2aMCCCG44ViajnUh69EBfOvzKNPu5K3n
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


