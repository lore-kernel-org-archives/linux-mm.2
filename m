Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D19C624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4ED6B00C4; Thu,  3 Sep 2026 06:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCA66B00C7; Thu,  3 Sep 2026 06:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1F06B00C8; Thu,  3 Sep 2026 06:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 766C26B00C4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:31:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0021416046E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:36 +0000 (UTC)
X-FDA: 85172084592.14.3D22E35
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5814C40004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sXvoBVq6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJel3C5KD51LzIWy+6HaTDQ/DgOUcPGP8bybdW38tWk=;
	b=mnOlxhYYFx5ny1CjQHUqmOBeUP50n5O4HNd1uq+OXIXgTof4vkYYTIdUlGiDjT0N4ORU7x
	zVTxperHkQuwlHY5jWEd4pDMPk9pnVCNK9m5bQGFzqu/TGXQPJHX7Nrc7S4w+AjHewrtSU
	Mrazp4m61HUFumQAsESePx2FMnsHEr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431495;
	b=H0IUPCnzxt65zgFIB/9Nux2FD/WCR8s/4m5ZLz0L/J240CqjfzSQSoIlwIKjdcKLd2/azd
	yV4PJYLxAFK0Tt6T43/eMWT2vTDGul98ra3r9fM6CxA7b7TYMZQ3rS9BQzYE/zLJ5UHgNO
	g6PukIYAB2EVCu0F7mXGAkMkGFFrsOw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sXvoBVq6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6C8A1F37;
	Thu,  3 Sep 2026 03:31:30 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 75F4A3F673;
	Thu,  3 Sep 2026 03:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788431494; bh=8uqvVZKecvI6tof0d601k1uUFNGK7TSPrxBJrkWSFMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXvoBVq6thF4MC66REFWIycWWSSZel6llh2rEnxk29YVxzxeqTuvKzkLPQExpL5vP
	 VIAxdYcA409XP5txGxWv7JlB54zBOpxe/Awbpe8nex8QVvSi/N1WKiqaShe9lPoTL+
	 u61Zttng6oGMuIVLrzcTlmYO3afTqLY+B5XmFwf0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 5/8] mm: convert PTE table entry to pte
Date: Thu,  3 Sep 2026 11:29:57 +0100
Message-ID: <20260903103002.1091859-6-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5814C40004
X-Stat-Signature: 9rncgjm1oukehquz1yufrt9ree7fdx4m
X-Rspam-User: 
X-HE-Tag: 1788431495-689778
X-HE-Meta: U2FsdGVkX1/sAz5Zdb0OpCE7s8MeNndAyHqszEWzLaHECK6cZ6lDhaowaogHQDwrGUZ5waeM3LKSdIWqAWrD7IBe9W3qMaQJpE1Vmz/ZiPJKraijLkJLIKb5/2cM9z3zRPKYtMmyEbhtQVGcriTJThShn0aLsUcD501I4UILO5kVBYm3J0jkKYpQbwIDn/yZ6IB8cu2W3uNtpVSUTqV8nNNY0PCPJVUxsa2CfRMBGPdm8aJ4wICyOw3cjRc8HmjOWHsLBNBMnO34q98v3kzWM2gASJ2wHDxjGa91rIc40kKJn0yuV+mHTaoXwX74eodrNAH/XbHCAwSzTckDYJGoGA1BMU49lY2frLF0AK02D/WS4L6BGn0L7nuooAChTV+goZcAIUROlaLFe31X2BY0cNg+Xl9z7wTVisKHKZ6d+fJPIohFnAB3Hmu1fUe3+ZycmSCGZkTS9yvaUnzN/frqaBlL+JwIUydnjNCKEBvZ6MxQem4fHwgmnqVggEQRIIzKa2kXhtNcoe6kyUMKOkKysWACf3B1uTJlSwNIacBlXHXYBbkd27Mw75elKsF/E7OhApYcvvCLgkgKZivGCs2Bbc5aCH35k1JDPtN9MYCb7krh9o1GVihcK0ohJn1aD6gLgdchpqtmIWBItoi1mMp0Z3Dg4Xu6DMkNSM8+nHh3A/scFSEpg5OSY6rIgfmyrWw7aKQQYOF+oiCURVZ6hLgDj4yBm9gBkmABTNqD7kfDlSCXnScybsHqXP0Oq8pbDxcirpRjsdXBOUASqYYIb7WJ27vx/XHrT55NSpKiDVOLuxalK5YvCNJjwoPszyNHEprnEtxXQ64vUNpwSxGHJd/820nZtTpMlxB5xYdH9Tz8at0yo0EEmNbiTUBS7gPGHHhiK8Ru2Y5TakkHIn079VWLXDZPbp+uYtka8JhI8OOW1ITfmWpztRh8tCzfPCNfzIuRvtjwxQ8jsiQvqginjNO
 I5khiKcc
 44Ysn2dbw4yAX5+czkJOJOlrkXgvVX2dcT0g5ShoKgBbgAOyfJ/b9JSUwnaDvWy+E6ZLW/2qvA/rbYzJC7mGpbUyfql0EthixjdRAaTVxNYHwh5pzW5M3CwWDQDRfSeyGRNxyC9dqDyszdrpJ5rrLXrkBoQeu+a++9FdjMXgNv7dorvXwhs3ncN49JUxmGmqAbeOWo/K/f7zLG2pojibPyDfJ1INRiDpOjO7ffC4gr9YTPYSuUy0HqwdIgXshIFiDVtlHevARv3UpKWHKbqITzrS0rq93LXExERL/ig8+ERtDUQ7MCXjPTE57gkgwS8OuJBNm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The non-MMU stub receives hw_pte_t but returns a software PTE value. It
has no attached PTE that requires ptep_get(), so convert only the stored
entry through __pte_from_hw().

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Explain why the NOMMU stub does not use ptep_get().
- Use software PTE value terminology.
---
 include/linux/hugetlb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0d2101facaa50..637fc863d3687 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1278,7 +1278,8 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 #ifdef CONFIG_MMU
 	return ptep_get(ptep);
 #else
-	return *ptep;
+	/* No attached PTE that requires ptep_get(). */
+	return __pte_from_hw(*ptep);
 #endif
 }
 
-- 
2.47.3


