Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD4DFD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E1A6B00D3; Fri, 27 Feb 2026 14:43:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6560F6B00D5; Fri, 27 Feb 2026 14:43:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F266B00D6; Fri, 27 Feb 2026 14:43:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6B06B00D3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E469E1B8222
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:31 +0000 (UTC)
X-FDA: 84491261022.09.6C10A97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D08A31A0011
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iPVMHXXh;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXqbVsQhuJfiPKuBw4lZJzLl7Nq3hBwKbfHC9BhNVBo=;
	b=sq/y9JRmmoUvi6jyZNldcEYYgLzkwQpE/lwFWuS+iIJUxcsLXL/RbK1l33XMoZBEHGF0Mc
	t4YRbdUSo8QZWSt2Fzl6Ucqm4AzR+9cZ1eYe5JuGq2MfYQVu8MJEJxKcUoGEAhhycIGif6
	N9nTNkMQSAHYymaA+mWBaoRDG3Qu1Ao=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iPVMHXXh;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221410; a=rsa-sha256;
	cv=none;
	b=yaXqKcDEyzvP+xt9x5w5lQnL3sTikUFaTY1kJtc8n4YZJURpvZV+nbhMlZ0eeolFyxsVlB
	cvXoVDVLW+fxQAdCH6OnaqhTayf9Jb6C6N2pnyJ7CtOhZoX/7Kb9k9zcdcqBMKNLXbCYKu
	N3KwMUI1yw9bk8bR2DjZkJ/e0PBXgYQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83004445A7;
	Fri, 27 Feb 2026 19:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E96CC2BC9E;
	Fri, 27 Feb 2026 19:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221409;
	bh=gud3FwwIClhEmyWoGuFCwJEp0m9beXo/gim58y+k7v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPVMHXXhYAi0AhUZq3bW+X6MD/K0c5MSJn+TsC8AOtTtbUFFz3ffyRMS0WviVcGni
	 62mT9OgURd3x7sv9fsxrJdolzd8si5WsvQEnHCXatGff/w2mfIPm56k+FiSk3tMIEx
	 CEyiWsjiEmW2J3Wh+7A+aIkbR1VAVxg68k2FmcxZALEpLRU3hLg0e6NHfNLuwcvyey
	 NEVR96YD+9liaOwCJT+40rJsnlUv4jAWNMgIFVrp8pymkDJ8sCDTP+uSzW//0vE0dU
	 UbN920BfT5alOYAzmv118aWwusSku8OQvk2Rya/EOE3wrXtpYPaR3F9sdfvr4+XMob
	 rG0F1Izfn9mWg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9B017F40069;
	Fri, 27 Feb 2026 14:43:27 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 27 Feb 2026 14:43:27 -0500
X-ME-Sender: <xms:3_OhabA1ohqHXNU5qyJNz3ayihbTvK3cA9c3NeIZ0xeM1MM9lSR44A>
    <xme:3_OhaasFPoEyIuUpNv0wUZw1T9AsYpGPB5jur1OagdNAAOFIcXX1o6UmejzHply7o
    JEos8QXdiJ4oJkKjwD55DpkuqErIqIWSxv7Y6t9b0j31TPHUpEvWJo>
X-ME-Received: <xmr:3_OhaQvt0UEdCKMeu209siQA0Vdm7tWGKBCe5XARr7O-MZNZ_FnsHw8613Kmpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
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
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:3_Ohaeoioe6Sa8G-eKF1PjQM_fcot6QQ33vWyXbkJpHqPYj2ARiGUA>
    <xmx:3_OhacMDbWD03RKTDgNiXsK3q3RADUxdVRA8AkVqkGTiT-ahMXTrJw>
    <xmx:3_OhaclP2w1F1T-XaqMUWS1tmoLoPcwYmLOvusoieMwy1eq--4aKDw>
    <xmx:3_OhaWv2wPdXpDysvWUxivqmsQUB-r_81ttU6zXN3TjjdRLKNtFNHA>
    <xmx:3_OhabntOD3aP2UuglbO6GtArK7Cb_eZZ84aMTLBBXwLLWMSJplqa7Q9>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:27 -0500 (EST)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCHv7 11/18] x86/vdso: Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32
Date: Fri, 27 Feb 2026 19:42:49 +0000
Message-ID: <20260227194302.274384-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D08A31A0011
X-Stat-Signature: bbaxzc3njdae1hpjyou3ih39eoqwhn4y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772221409-880706
X-HE-Meta: U2FsdGVkX18TvA/B9rxtvqtsiA+bVOnfJ2rgJZvNKY+7r5+j4LGQs2CyFo50sZ5s3kGdpnPO6MXwXgOckTVZb8QCEibgyAUxJ42vi2AOZ7nqIErbI28ntDmXENUvJQK6nPl/F4Nul70hyeK27RSReA1g0fBcZf8fY/Kh26j/HvUpXqOAhDe2KV3sjipOM0TQYR5xp+8jiFkmbrBMT5q9C79PXf7/7StnMQUSTnYVsx9LN1UHtc3sYaX00+JyUgZ3kewEkS28z/OhvTWLEMAkktEAPqNofQXueemPdXc9vBHWXy9aH+OQkZ0Yn6sqPQa5EdwJW405l+U0QDoBEGveft+M2oV6KPFStBL1Bv121ywL8BeftKnBBeY0aeg2klq3RjeJ0+x+CXvt7Uy5MaFzURZi9Udx5KWTQa7DZHRMjc0STj45tOrgHJWoA1jT4OwtBG3DeuDpHEZTvXOwJwmSu3BaSmn4hyF6ijnhzpddZyioWcikNICyoIakRHAxlvuGcTmnlv6SfbTwpE3C+iPMyWEtto71qDm7vyDb7JrvOGe5vy7EuNERHPNW76+OkMz30ZQlx1T3sL6FuN7e7Z4XE8Ifyae1VuFliGgva7RdS9owlddK45OlqVWCu6ggq/YkyKH5if/Om6EpHvdUYrIxeEkFUlLVBJLHxclVX1vri/WdZ9oX4s4JaqY+KnxUpVYdvDUqwIw7NwlEAhwXuhVeUOe2Y2uYfG2IGnqjHGg42bQ3HiYC8wEv+krs6K9P6F9YuN6PKJ+i79nIk/7lxLzobCbsCylXFiqNUD63EESVjyo8yiT6RSKy+XYkVwJjHO8YFT0En7NdUX5KPUGdsjBAFIf/geWWMQha/M/l6waaj+MpzQ7XiEIbID0KTF1IPXaSZRZ8y5hco+MpQjtf/OLntoq1cmNpmKR6xsGeOlDd5IeXBi8eudbKwNKDzqVEkzbUWD/9fPntf1/TdU59uxL
 79sOlLIn
 xefAQCnfuWKM7W+vZkCUDh6Aqoiafuzi1Utc7RlSiq2UsqCaqpfJJtoa1abaPlHSiSj9twj4AStCw0sOQO6cngNc543nN7sozQo/ciEfGX2mnH/EV37unjTLx0dOX2/+MxgwMhSpDNNR6aBoBLkzxnVPYbWWXPNqkSFhk/Jk69D9KINHPQviafg3vak9nhGHKZNcysKpunJJHXJGaNxcglUrI13/dAypPS6+GAZWehVsx/S8Qo143VXeWnGHjgTN61D5nXfYXv0JxkdD5mNo7kfJjcbl1gbQ2ntQ6oMu+JRxNHAMZabAC+ShIsg==
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


