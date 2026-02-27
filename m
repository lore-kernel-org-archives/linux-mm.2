Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6DCFFEFB7C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB536B00AE; Fri, 27 Feb 2026 14:30:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BBED6B00AF; Fri, 27 Feb 2026 14:30:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA9A6B00B0; Fri, 27 Feb 2026 14:30:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75E546B00AE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EA24BBAAE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:54 +0000 (UTC)
X-FDA: 84491229228.02.37449BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34787A0016
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2PrcHfH;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXqbVsQhuJfiPKuBw4lZJzLl7Nq3hBwKbfHC9BhNVBo=;
	b=FnRk4r8VFdJ2fBb6NxY0W1i+HfTz1uj82iSU0tJ05J8srjvPM0Ug677DmM2xB14if1TLa/
	XkZFi8mLrYkU26kAOFPTvpCUc/33GaRwMdWmkBVp45n32wwrZc+8Mjd+ne/ha/NMTzwdLc
	x1gUCP13BQn2uDjk9jJ6cMw0ETH2Oj4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2PrcHfH;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220652; a=rsa-sha256;
	cv=none;
	b=hRLzBDIDqJHgameoxga+Tw37r1XL3rOKRI8ScmnTAas9PLJhnykqqkmOt8Lskuj/qDkOjA
	KAeA1bAfk3gJcNYz/7nAqCpHQBBuCvS5rAzoRZ35bG+s+SjBZD39RChxErn5aWjX1BSGOg
	GVrA1zl0O/m8jFO1scViz7vFJE/baxs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C09F060180;
	Fri, 27 Feb 2026 19:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B7EC4AF09;
	Fri, 27 Feb 2026 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220651;
	bh=gud3FwwIClhEmyWoGuFCwJEp0m9beXo/gim58y+k7v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2PrcHfHu81LLdvhF2D6BNjZNEN6oX7/vLb3AFtE0rdIBwPRr1cAJcisrxqldZWr4
	 AaskkHQKIklK3uoczNhujVHA8/8Eg8Itne8r8+dEOFSYtGjMiRBo0SCict04Jp2JGg
	 z5PIPpftkSm2PJg92fp3ksmB0ubET+yfph8E+urwz56P+unmkzEAT2dONlGmt9JLEs
	 KlABChkJcOVugXeM5CKPgPGfYiBdXhjTIQETz/7jlhtgu498MVYE5429fTUNVnVGE8
	 zS6sGTdNGYgQml/mRhSUTGro3ssGjwTAUEJcwpa8YFIKnETITxNIUK8aAYVNcXnKcV
	 mAjlfhI5OBg3Q==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id C9154F40068;
	Fri, 27 Feb 2026 14:30:49 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 14:30:49 -0500
X-ME-Sender: <xms:6fChabRUFQq3Ypr_PkCHaCbpZdRSKDiOWq8pszP4RvCyE5QxGfLLCw>
    <xme:6fChaV_Sz_JSjwhBgjw5BWEK7yiXz_eARxlJ0UyhoU3Kiko-5GBRc7fcR_GSajBz0
    sckZLrV1CuJja23j3X1bwcl8iKQM7__atfoFR4cmlGq0uxcvQIo_eBJ>
X-ME-Received: <xmr:6fChaa_Nv2g_2U2H1GMo861YVGU189Yy0Jrc8soePIfx7M-WKsHamNTVkcC6SA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:6fChab4g7Yje_eHZGXGNW-NZ-ZJGpPNZbUu5T0-OTRpfJwu9ZPHoPw>
    <xmx:6fChaQePRDBqGYrrhloEWgOn861tpvm-jb4BwZWFyN3symrjnjCRfA>
    <xmx:6fChab2zcI6nTV3cIF4uhIBjnrYqtsjnWNphABGtpHe08D3NDZDTYg>
    <xmx:6fChaU-9Gaz9eY2QGG-jf1vq6tXkJ6rp8wOzX23l5pt7XnEzZ7tgaQ>
    <xmx:6fChac105tt_OixP0u-CokecW25fJ7NhpZ18ZMUUm6P8p1zlbwlNmXsq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:49 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCHv7 11/18] x86/vdso: Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32
Date: Fri, 27 Feb 2026 19:30:12 +0000
Message-ID: <20260227193030.272078-11-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34787A0016
X-Stat-Signature: bbaxzc3njdae1hpjyou3ih39eoqwhn4y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772220652-515278
X-HE-Meta: U2FsdGVkX19L6b9EDZP3nW0mUBUpB3oUaZ0BjU8VP+esr3C4tUs802xcQdUxIVvjJa7OhsL1dgOzLHP0J+MY/9GPsJmmN5AbI8je4nT/XRawz9Gpr1e47G0+6kkO2yR0hKxTm9NP9O0bHJP7KT1HHjyrvO9P4sy4gSl611q0IjnPZZBcw6fhqQarahD4f1uBy0ypdjNMnf66/CKD6OF06Pm/VI4eOEPzmbvI7VPjT4b+FdIH3zSwwgXNJZMm/e9PVoH4dd17mGuYuZp4jLfwI5gpUMEDyYJsOryys3oBfr9Tk/eC7Jlh5yJSdl4bmXN0ie14RPbUUobxj73k03/huDX1ZLClOzJxeAorXmqJABozdcR3qDCBihJkiSGhiXasTvCcaxiZR0bjGHMLoGfQjMU7EgahxdTVHtWBwz70ADKXDvpR2s59jMj7FF3BN9EgOC7/ihD6OmwqTzIGFUte854nqROQa/OCTb5Ng09cmhp8iF8gdDX+Gf1jEpTnhy5rsElwbQNn4vVJXY+05T3g0TkcM+akdc/iDdrWWCDpNBSjz/jJfB7GBK/SQJaUM+mDIljoSPu8amTFpLTZfQr2aePHVd0tAWvzfgfGGjBXoAI1QPPwubmi/azNgBBowf1HrbJtpMdGWtLY/ZJL+SiwnctulB/xysPly8j2QRJYJcTYoiZ08eFlS2tfxflQJGyKK1jjBSOiMyq/dbSX1CesKcsdTgO4COdgs0VjiPmalbIpOSUMsZtlqZxCcEOveOBA1AxworXdZcZ2McGliQCSkkzWlzWz2MWHxfFmx9cwU2JS27ef+SwjsaPvDB9NYQ5Hyx5wvX1Hp7Sx4hiq+Jgn6/+I7s8h9OIGPABXH44urG6brBi1hUQZLx32P/pB2vKLVg0I6X5trG0GDzuZE2Eb2M6RXPzSEkG7EruWUW26BQmJw8eDf+opoECxOJQ6T7GLZUNBrrTl7Dq2xT5a56x
 l3Tnus8g
 WEwlPw/dHAz7GS1PoP5fJR4DIsVZJmTmLjtEhb8wdU3IV3xLFImrHgy71avdcxd8gDLTtGHsRYtcM6nKB33PR2t0yp2QYLoUEEF4wH/4OslzQLnDbFXtYBf/1+RHglN2qzke5rhMyEqsJ5Mj+dTj1vKO0zWE1lUD+dzaQnzL07vGTzxzjMnHK36eq8Uj8f97UM7mv708K6F8yr1pUvCo+YBqJsAcg/bxZZbGX8XJ0fPzPI2lfLD/sVMrZjW+sUrSYXTr+kvVrv7W9stXeHG+RLQNNjqP34ZQbacPKBKmglGfQSewextvR3wGm7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 32-bit VDSO build on x86_64 uses fake_32bit_build.h to undefine
various kernel configuration options that are not suitable for the
VDSO context or may cause build issues when including kernel headers.

Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP in fake_32bit_build.h to
prepare for change in  HugeTLB Vmemmap Optimization.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
index db1b15f686e3..bc3e549795c3 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,6 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
+#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
-- 
2.51.2


