Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0A2C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1352E6B02C3; Thu, 13 Aug 2026 13:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEFC6B02C2; Thu, 13 Aug 2026 13:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA216B02C5; Thu, 13 Aug 2026 13:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD3026B02C2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:54:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81D6316025E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:34:47 +0000 (UTC)
X-FDA: 85096946214.25.FA7978B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C259040011
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:34:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UJHrHFR6;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Nmbnq0r/tdkn7LzRpvbEkYwmsG/p8Yg0FdX7/Lw0rs=;
	b=8nRiiG/NJ8PZb3dJHg3DfznblMwWvGzf0EO+RapjSZjBzDXwedOIJi5jipUfGtX1R+bSKx
	dpeKet1F7fA/3Db0t+Cpe2LxTg/DD1yDZWSVCL2xmqmTWX2CNhnyCWI04mALG9QebGsEld
	lBLV9riIefIot4CUcc/S+ASekJRIxvU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642485;
	b=zedZMcfIP9BAYNwPNt9uJ+W0szWm24LzoF4aCIdJAs18AwB6Q2nmSNdM+qPn3u/JpIX9uM
	zgIo3uWSkMPFXImW9MLCxzbQLJIWegp+O511dfsuWxbKdK/qdxi1vPDie8HTbmcJ8U1Zjl
	pNn8uQtHDplfWL5nl1sadpETMnYMA1c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UJHrHFR6;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52D22600B0;
	Thu, 13 Aug 2026 17:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FC91F00A3D;
	Thu, 13 Aug 2026 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642485;
	bh=7Nmbnq0r/tdkn7LzRpvbEkYwmsG/p8Yg0FdX7/Lw0rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UJHrHFR6u9p/SM5kX+G8cV/Zu8+jiCGjo+Jl8zwrOiYWKlhFQHjrMyRDRNsZdldmv
	 qJ0aMYRTHVmuUDG4AHUa3Bb3WaxwtrGHmulqnc8mlxF9KrA0vAEeVIomi2htKiZrgb
	 YZh0DG6jlBGdxPV3Wl2SHTPL3OqhwEuftXqsDqCpS9zoJ2i4s6yIUE03wCgiNiUFs0
	 jN3yqFoE+yZmmjdF8c/mz5tD1/heVisks35JsytpQPAcWSDW4QSWP8FZ7NsCznwGdk
	 ZVBLVAm+mEJLe3w7sFC0/d2PWfgR+77ptjHLg6PgEVZGVdeGk14zwD6i3v978rzzou
	 wJHNd1ySkH6JQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:22 +0100
Subject: [PATCH v5 05/16] mm: update print_bad_page_map() to show anon
 index if appropriate
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-5-c21581c0c3c8@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
In-Reply-To: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2529; i=ljs@kernel.org;
 h=from:subject:message-id; bh=n0kfl3sX7UAIKHIjCWNuf6tCoy4kVBTkNam6LpgmDSU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/69+Xib95eGvG37S4v815IoWPK0tbjuZt/u6LHdR6
 a6nEybHdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi84sYGa65SWk+CRW/1Sku
 LxRzNzi47kdjggp768q9Qnr9+XkalYwMh2PfPbxWn2G4NyWQ6VL1h9zHN831Z6yZwneohWMye2g
 uIwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: ry8i4her6rpy5ptr9c5t5m8ph9k99jn1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C259040011
X-HE-Tag: 1786642485-312073
X-HE-Meta: U2FsdGVkX19z/2qI804MMEklOj2l9vOQeVr7KoidBF1dEpwJUwFmemy/ycFkrJrX38Hz9J1nwnYczXku5zthTzna3T4ci7ifKrD1kdq2chvKA8OsC5u1r37PTaXGDM7f9xks1Q6ZY30XWbiL1jWclwLueSvYOHsYjlPUCn51RGJkxRZfgX4LJB33ODfgVcLpsgNPTnZnwXLSaGRNtnv37TeXBYx4jcttjJ6KU7TWULDHOzmjoiWhbfpDNiDu3IWj8ExM6hKqlZQwp+vcDB4CZcBbzovuf8oXSVdInroBs/M8uWg5C14nQDO3FLcTy+42Mn6L6ZRHIvi5OgF/b+56+iqRFi0BpZdLs8GpkilY60bSZPXepUXD/vFX6no+DznhNKOeS6iGbS94dWzSz/MN2bmQnum1DonZVjyoiC9kXcz9g1wNbyRRPg3l35uHMekJA0McLRmJXtfHU9Z8ztzrEaFqdo+YafV6VyaJ0p3jdzSLFICGp2/6uPeB4uLDfTa390o+swY6DUwej5QdE2SCo7vc7i/ZkQM2X/JghWWD3SURDvx7n9VsA/1gjROrYxYJfAGyFeK1Ry140Ewvt2/B7ZA7B3tjFzwYXAuYh28QMGWhped8hMo0od9WXcxiWryDuakTTYHIYXLzOBprxP6/w1Nh7NfXUoJcgK7A5YB0FyEhzwGGyDDmllTRWyXOmWYWF+/qpuGpU2ZXlrtqQb6K8qPZrKOERAEAG/Pnm2cxoxR/mrt84wn4v71mEa+9bI35BmJnEw8HBN0eo9Fd8ZjeoAeQWoK7Z5R3ejwEvmt+N2waQr1UkyuVDfQfUE+v7y/yvjw2hZFQcYpNFPVufsb5iVEWMOWoynEkl1VUp3KqUaO9xczVQty/lKAdLZjHO17Qm0lbfDU/BIEMy8DTVq6YYh4CW9GhS0nNr1sVwmYzkdM/uGMnCsQL+PKDbxY9LEGD6tOPBbK4gKcCvrl50Zu
 dY13yDtm
 UaXeastUzxjO7zbV3oTUrKs4Lje0gJzgtDfFS8ZUQ9I/1vLAm3otGH8zkZ6wNvIU3gy2rLcdkXFQRPwpLNfksuTi00J5+6nVBy5oO+oXVpaDm4ymGgLdq5tofwcUfF4iztpEWeDz6Wled1jbomftCvnarZHFHm7w09x7oWUKyNuMhM5bB9fIjSYC7thorUYXCVk5ALoVmYVPYLNsDnkzK41fRd1JRIS2ZHYVj592tu7Fsaeh3GY9QBWtmtnAKhbtHvui3avq0L8ehf+jfmGSi1Yfcyugz8QK44g20MscWsNKyO2CrTa3NRJPqgSJGCSx37BIlarq3bVvz8m60SHy+UcX+SGEmMBQO3xeeIEJ/JKXZkzY9VFpIfnuD/Hl/BtrIgfYDD7Tvg401OagWhFS+nUYme5QfvKoAo6CpaNpWPfwoIKibZAVFFYcVxqzbA6BhJ0GJsasQVhDBWNPjLOKVOH0vcKNpmI0UHgAw9gPbSN13vlXy8QDVhAMb6P00wi4KkwfKr0AqiDOxw6t7FafHW261Ie69XGSVSNajgOozihYKADc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the VMA is a CoW mapping page offset may differ from anon page offset,
indicating different positions in the relevant rmap trees.

Update print_bad_page_map() to reflect that - if the mapping is non-CoW or
the indexes match, then output only one index as before, otherwise output
both with (file) or (anon) suffixes to reflect which is which.

It's not possible to give only one index as there is no folio available to
perform folio_test_anon() upon (the page table entry is bad so this is
unavailable).

This is potentially useful debugging information and matches the existing
page offset provided.

Use the raw __linear_anon_page_index() function so as to always output this
value regardless of whether the mapping is file-backed or not and to avoid
asserts that shouldn't apply here.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e1349e18f046..3bd3616b27d2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -631,13 +631,14 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 {
 	struct address_space *mapping;
 	char entry_str[PTVAL_STR_MAX];
-	pgoff_t index;
+	pgoff_t index, anon_index;
 
 	if (is_bad_page_map_ratelimited())
 		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
+	anon_index = __linear_anon_page_index(vma, addr);
 
 	ptval_bytes_to_hex_str(entry_str, sizeof(entry_str), entry, entry_size);
 	pr_alert("BUG: Bad page map in process %s  %s:%s", current->comm,
@@ -645,8 +646,14 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
-	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
-		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
+	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px",
+		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping);
+	if (!vma_is_cow_mapping(vma) || index == anon_index) {
+		pr_cont(" index:%lx\n", index);
+	} else {
+		pr_cont(" index:%lx (file) %lx (anon)\n", index, anon_index);
+	}
+
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
 		 vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->fault : NULL,

-- 
2.55.0


