Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE04AFD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769C96B00CD; Fri, 27 Feb 2026 14:43:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A70E6B00CF; Fri, 27 Feb 2026 14:43:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCEE6B00D0; Fri, 27 Feb 2026 14:43:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27A9F6B00CD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBA991A06E1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:27 +0000 (UTC)
X-FDA: 84491260854.17.F081713
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B73F7140010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WsF21Cno;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psX1/RN4D7tc0hPQm6iUSxbTVKqJFYhFZ0jsRV8hStY=;
	b=Mnn1Nbq126jpuGdGwEcnoGfs6TOrexZ4w842KP8nMQH1H2YgsTnlY5HQv9fAQykRUmgTvl
	WyX4nI+okaGN2tXWVCKO6iruibSWkQMYHTIPMvUmcLO26y5TKrRn78rvDUKbF+3osnqLsk
	Irc1+xvvQsrBTa1QMmha1aUlbZplqc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221405; a=rsa-sha256;
	cv=none;
	b=U4RN1/78Mj1ptnoc/N6kDOM3K2c5otQy+dF5uHzX56Eq0WZwNmV8z7qpLuGEYqN4yRU3C2
	J996D0kOxuCZIEafXuSnfVtcjgX4EixQ5kfcLPYgwFe/fDFD1uCdpzk8KYwPhrXazmbKku
	qjLux/pF1dgbH/LZ5qva0lRuhjxJwv0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WsF21Cno;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED7A2441FB;
	Fri, 27 Feb 2026 19:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D40C2BCAF;
	Fri, 27 Feb 2026 19:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221404;
	bh=qL/9y03XAUyVqo5OQVqiOiCFnXGU+LUEF5AtRX0sSeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsF21CnoBKn/lu9boe37TDd991flEHr2mvygK8jdP/xwI8tdRmQVyjCZER9cJ77bd
	 a+xKo9EPLTjaUm02KQbN48MIsPjUB0Bqbwc0v+DXSO8dcdiUEazkFFCvOQf7XGoD9T
	 qwc5r9YRPYTdMSGLsROHXn4Ya/jVx/CMYC7MR1I2r8h26pOMTbx0dRysIp6ErSeTHp
	 PN9tBPIfquvjX4bVSXx3fiJRgHkZKGpc0qcfEoRNzy9TAxyu7yHtoT4AWqxZRAKRpT
	 0uFnRKPN+6Zl8QErCy47zLpFS5GtwgNb8Pob4rFxCkirfbypkjwvX/q+6qB1hQKlI8
	 HqVy0HE/zUghw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id D98C7F40068;
	Fri, 27 Feb 2026 14:43:22 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 14:43:22 -0500
X-ME-Sender: <xms:2vOhadyXya4yLvxIDvteB3YJYYeoMaYCq9g6E25uN0uh7yKbZoZuBQ>
    <xme:2vOhaegxw06N82H9lXQ43oKiaJudI9bL7m1bafOf5Z23YvIWdZngQwsuSrCcQb1x9
    HQHhsQZMt6JGQVDOBhsS2d-IEC418amrnc2eAhYKLCeS2WDtes8Cl4>
X-ME-Received: <xmr:2vOhaQMD9laGwgWVQMSP9q5ubihdvEbhHlXEE6v4dCIlZNnTSwq-N13i1l6pCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:2vOhaWjk8lIr33h1293jPn5y6LMc3miT2U3bnD367YgKMKLx7RkndQ>
    <xmx:2vOhaQo0zMbDHINM1yEBg-pnfKaI1Mb2MqjWOK6EjD2ObcuFzGVtIQ>
    <xmx:2vOhaRiMUO1exAmM-IDCvqOhvN83Oj8h2KxUo766kyL0izRu4wwRGg>
    <xmx:2vOhaWIWUc1NsaavpYvwG39l8_Q_GI0r6oI2iHag_LZH2QpiaoDLqg>
    <xmx:2vOhae7x0N6Zdq1yCXZsP0Dh-1T8GeChfX4W3ZJwOmL57Lnp3nY0yskN>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:22 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [PATCHv7 08/18] mm/sparse: Check memmap alignment for compound_info_has_mask()
Date: Fri, 27 Feb 2026 19:42:46 +0000
Message-ID: <20260227194302.274384-9-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B73F7140010
X-Stat-Signature: pe4dy9ijsq9c1mfrruygxhzwbn566wdw
X-Rspam-User: 
X-HE-Tag: 1772221405-355844
X-HE-Meta: U2FsdGVkX1+691QOMZq0j3t0EuCv6Y4wVb0qJXKD2cULIS6w+C2UdHyCEa7cUsBZEAHC4p9db9tSLFQdwc/uoaHDkvZdNy72QpkU3JwZY4cvPosbZ8FcGiLC+g4LUNbi2c1CujJAhIjNk8q8AdKRRLKvVEZ4Ymzn8BPudGXG9nSKSQA5R9eJe4gvpbLlOA98IwRHLZThtyv3Iz3m2UtfDq7rbkZFAVfy10CP7YBYfgsu9qE5kl5XSRABwJNpKMs/C6pbP3kSm//sYDBvcAcab4bxB0pNwF9Sv8OnhS5XLKKQj2JtR9rirbocI+PBbs5Ei+YNirShkFYh3Qe904bSq4q1/2QVoQecjYzeL8pmE0LFreY/cvv8foWH8UXtrXtLD78mw2e/WC4R7kTYbwpJgggL/FOihztD9PfUuiGuTjmMtyUH887l2iETeJF3EMxxxWFge9ok5WPsN5CeqR+0h3VMUfkEoBcCAfK38NBWZSUVTtpgsU9dJkhsDWy7BahTfzumWt/jQ+Kj6iISoGFjaZappn4rR4TRVMdKFyBs6pmwcHNoRuMJ1ct+TJgouHImlG28STv0NYn1ju98NWXdkCkqA+083Z9uBsj1urZdqZXwjYxiV6+AzxoGScW5wKVo/+eYZOy7HxWReJ4ifZ0XZ1lx71I+ZBPeI/jf29+EoTEfeXvuOk0NK7Xz4NX+rzzsoKJQL18fd5+77LRT+aljCm/Y1S4E3jNXSx7ifgjJMAlJlY7oaP9PVQxsRLWck6MKlHQnFA7cj2fQYET+EdKeLCwHgPnIYu2rEYQGmIwpH6UVApoZeRMp9MA1P/Ut8a3AxtvHdL0CtNPy/JGw6fSyFlqoz89wK9OsJByLD4Rnugc++SRkTdt6Ow4acwPUihpKsCEKFxMK8+klWxHPmVOWY1wjnOdhAQNPTjEiLIC0/KNOcciUql+sVuCmz0TIXZQw7QliWcZY+5v2XAYXi+q
 dUTLECRq
 sm1WSaVNZlhZzaFjwtM0VQdGNIb/pbUX8gdqHmInYng6J3JVxSkdd8ds/Ps7L6DWjpw8ZtUCBY1CgB1Yp0gkbFoUKRecd2Z+u+RTD2v2TJ6unOW0pfZ1vQ/cFGKCIh4L2gx+CBjlkEMP4KVWQ4ISaZ1Fw5dDcVNKm1qZnISD6rZarjpC/AFS4pFnIgLZGPBKfsjt4TpZxdRTIRIWpJVqb1XVVSoTfR0QK+ImS8j+BtVR7EEvla1KOijS2P8OfhK5UEUClhPx/sDVraBwI5XKr1VcLFPpSvceAVXxd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

If page->compound_info encodes a mask, it is expected that vmemmap to be
naturally aligned to the maximum folio size.

Add a VM_WARN_ON_ONCE() to check the alignment.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 mm/sparse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index b5b2b6f7041b..dfabe554adf8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -600,6 +600,11 @@ void __init sparse_init(void)
 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
+	if (compound_info_has_mask()) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
+				    MAX_FOLIO_VMEMMAP_ALIGN));
+	}
+
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-- 
2.51.2


