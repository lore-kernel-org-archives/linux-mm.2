Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9508D3B7E5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407E86B0006; Sat,  6 Dec 2025 18:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF906B0008; Sat,  6 Dec 2025 18:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5E16B000A; Sat,  6 Dec 2025 18:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 203826B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:03:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C04D7160696
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:04 +0000 (UTC)
X-FDA: 84190573488.11.8B2CD88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1F6F61C000A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ml5Ukipu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062183; a=rsa-sha256;
	cv=none;
	b=wvr6jHc0tYk29K8MrUzT8A7GFRY1omx+vrGVb79Cc+UzKMPQTxD0FOp4RbWd+cu50utX8C
	swZ/YcIkKsJJd/l/JS8mLE9JX/MKic42D1/ppHj4s912jMolid+54HoEHZu2+eNgQjJuEI
	OeevqnQqgxyIbutd6QV0TKCkBuvmX2I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ml5Ukipu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fSuPodiX5EHH+jhfOMD50dY+Ip+73J2brCzGUDDF9k=;
	b=xsJtnQIAsKGdqG4TB8xV8BnzhqyNh5pSpTah5NWH+Y6ui0EbA9CDz+3/zCvT+OhANXnDBL
	qms2E9kyvRWF9rMdZ7d6Wdy6eOmRIqnfHKbfwAEywuSkGAJ1b8ZqOyxsJEayknKGqymXly
	oimvJmpett0rWb63S2mvkQXU3DL6lFI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3378E4411D;
	Sat,  6 Dec 2025 23:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EF5C4CEF5;
	Sat,  6 Dec 2025 23:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062182;
	bh=YZifJ1dvIIR+mXezMnWNnfK3KMOuY+73A/Qwip8J2FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ml5Ukipu2YIRmfC2zWNaddAoSeT997AL8NgvuFYBfAl+b37rS4w9nWuzGNZoxFgMe
	 tv2qDqnGU3eYwsHM7C3pccFIoU3CqoJQTdYQcYgpyp8FPYjc4wvmEAKLHuBxTFJzw1
	 6dukN6uux6gsGXX3mMqy0ZIcODl5PAQ6EjwK9nog6kkER5K4xx8XDvSLxw+yme8qsS
	 ZjO5k7OvTyEFPOY0dtt+cLzux+zmWbbwHZtIOkdOZ4z0Meb9uIPVNPuWkuAMLFNIDH
	 L4v65ddsy8Fcy3wovhmFFJNavsXA3rv+KXK1nJZGXWMTGbi8EAUNAeJMbYzL1K6e8G
	 HN4m4uDjC8/ag==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 01/10] kho: drop restriction on maximum page order
Date: Sun,  7 Dec 2025 00:02:11 +0100
Message-ID: <20251206230222.853493-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
References: <20251206230222.853493-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F6F61C000A
X-Stat-Signature: p78toupa9juame6k3tnq3c4pd5eo54y8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765062182-2628
X-HE-Meta: U2FsdGVkX19u8tHFSvablWwya5OorzyeEMbV7eNIe/30rHMesgJR8LpjxMVSbmQrcVi8KwnRyYhJd869wZLUoT7XuZmwmwbM+NT9VntswQuw6K8kK9V8mRDjiiKUqpKBymsU+1wtqeCTLV9tHYKs0IXwgt8/jM6uFOeuqL00UMyTKC9SwvDqiPgK+OdjP8jn83nj9IgVVRH1TcO0BScemAruBlav7dnPFU+VVfp4vCCunthoaOw64/p9IeIwMLn5cgNZwkQ1FnwkLF2BRmzaBABlhySVfY9/F5LtLkVB2QsTByoZKOEnf1a8tLqetKSYPl0lodPH0bYi28ywKOhYE7HbmqmmzR/+YSWF9DR2SxjvMhoFb+Db4RawIfvfrJbcriAM5SEiHMuyCBx1zDlFttA85boUNKD+WEQ8oSumF0M6EqWaLjF9qnQlI48cviTwYnUmp0d2IIiwNZpnWEuBBktt3iVSRAiMw5pIgrAMJmv6AM933BmxqFIdfQk5+r+esQw2rk7vFf266DbzQH8w0WSJ9g/jXYhgHgI89hNjIdpJjQfLiLAq24xHezRVO1YCRumWQJIgFxUPhLdx6UQl+vrYAStqj8uYFMpFYrlItGHzLspcWXq4jcD2H9gDUIvZtpUrMgBU2K3o2hUnwWguv4ZHXBt150LuytOFPM4Cc8Wi3VHc59y1qkXBnqwIoZx4+ov9cSNk6WfkbD+Ut5XV5iJs/9KrnsgQEOtytseuaMxumWymnWF2x6xWCa+X0vExCTYPlQFZnoFMYT3bwWP8lTiq0hQiSiwVLdhb86hC4U0KQoTZN3eFB04smyg5WTZ6nA/FE0tZwYud8HbRhvQXhKJMOaYlADETQ7m/Q0dlHzOyZ4iBbcdvLLhzp2c2XiWg1IneysLF/KpMTqBgOmGYqap1Q1HqM3r1iR+e1GsMZcPYKx//qbqE6b7QTPNOF/S8OwAAyks0Mk7KO7GZGbY
 ulY7kFyv
 LC8wpCesies3Nx6jkrlQqmId9UC9ADe3Ex2+V7zjgXCyaQoBBxBe75xi5joEayOqUY7sUM4Zw5ssbxgzRiAYSGSx/wdVeeacsX4SkxtWN85scSyvUDVaHcsa7+iGWXK/iMivsLC1GHS8IE7W09BOagHMp44hJdX3EAnrI5Iu9XM7qCtKd+jNsRtbXYzRz6VS1c4EpJD7X+74RwZVy6yKzyT+v4R4rZcpZke7odHwzAis03FYJO0dn9wahW5M7K+zvgHQM/N9kb0f6ap5CbQzdqmNzGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO currently restricts the maximum order of a restored page to the
maximum order supported by the buddy allocator. While this works fine
for much of the data passed across kexec, it is possible to have pages
larger than MAX_PAGE_ORDER.

For one, it is possible to get a larger order when using
kho_preserve_pages() if the number of pages is large enough, since it
tries to combine multiple aligned 0-order preservations into one higher
order preservation.

For another, upcoming support for hugepages can have gigantic hugepages
being preserved over KHO.

There is no real reason for this limit. The KHO preservation machinery
can handle any page order. Remove this artificial restriction on max
page order.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    This patch can be taken independent of hugetlb live update support.

 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..9aa128909ecf 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -234,7 +234,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	 * check also implicitly makes sure phys is order-aligned since for
 	 * non-order-aligned phys addresses, magic will never be set.
 	 */
-	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
+	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
 		return NULL;
 	nr_pages = (1 << info.order);
 
-- 
2.43.0


