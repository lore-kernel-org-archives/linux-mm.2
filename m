Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC99C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825276B00B1; Mon, 20 Jul 2026 10:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC126B00B4; Mon, 20 Jul 2026 10:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7142C6B00B5; Mon, 20 Jul 2026 10:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 486926B00B1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:39:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 432A8A017F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:37 +0000 (UTC)
X-FDA: 85009413594.12.AC86F34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9DB7F180007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjKt750g;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUSSGoClEIjzcszURqrS6Zg8fTue7uAoFYyLToW70HM=;
	b=xWvcA89NVLJHCYFC3EIWRWEfN+OsyK8zzMpeFgJQa2a7wWqSIWwlwtl3+B4VqhmfSSoa7q
	ta5HLqhDRdNynspprJFWi9MEg+HgmaVp2orqwzenKzrHEwlqtjG8olTvmgLGb0pzD4VVLI
	md/rAcU2nR0zczpCQzvaM8c/xeK6kMY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjKt750g;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558375;
	b=wbjtvuhU+u1dsDNgc2XEnprMET3g4ZuqoE05NPpJZXRu3eyYOIsEdOEGAD7oHHdbnuq3xP
	aPhggbv/5jtcNXFMBzU+dAlRbDUD3LzyRCj6v+xoh8R3rBiVu8o/5UdnT0MLIwsCxcUteG
	GIkO04k1mOmF7f3GTI48obRtdcK+0Z8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 351C760A80;
	Mon, 20 Jul 2026 14:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2961B1F00A3D;
	Mon, 20 Jul 2026 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558374;
	bh=ZUSSGoClEIjzcszURqrS6Zg8fTue7uAoFYyLToW70HM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JjKt750gGvIvvCCDyqfcfSAGPc+PHVGCokMeV+gct3LEnzNi8YMP35SlFxFCvwoVS
	 200vIGpklyJwjo+2AKMYK+NMUyKzimDKzJRlQaAsfb+COjSzW5fa1hx8UfYow8BB9x
	 20RN1OJuC5Z/3puB+t9keQvwyffX4jtDLJw8uDTS5+PrNEarNhGxNMM5hcB/uvQs/+
	 FGvVjSES1GX9XaAnHxsWnxSVfcqvetgKGS5oiXbJ1clYQ3y8seohCu2JbGxW7Iz6CM
	 1JWgI+l0guNQ61x5W7xwVzgKAt6vGi4Nl4nxBReNbxsfOZeQLGBz7lI+xDyDqDvAoN
	 2XNhX7E3fC5cw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:30 +0100
Subject: [PATCH v2 04/15] mm: update print_bad_page_map() to show virtual
 page index
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-4-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1716; i=ljs@kernel.org;
 h=from:subject:message-id; bh=T5Gj/piAc/UlxcCiA9iiJMiRS1jgA5HHtjYX3YWMzOQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN48/dRy6ZZy60xJlrufNP+JlJWECvE4Nc6WOV99p
 Dh3+QPpjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkfBkjw+Uj522mlyXYfYgx
 iN2xqcK6eMGEw31WqxN9Zp7drrVhdSAjw8UjtiUB7zv3fzr8ZvKqSUvnfHR9svap4cRrUznFCg9
 NeMsAAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DB7F180007
X-Rspamd-Server: rspam01
X-Stat-Signature: pbqh9179o5uxuogktnsiwh9tjshn5t84
X-HE-Tag: 1784558375-86557
X-HE-Meta: U2FsdGVkX1+LZwDaF9+wvwLUYScEDP7bnjpqcHmHV6K1HmqzJRygmMeGkboO3nQZqjvkkaBp5tAB9xBEbjasRlUCb0pPEKiC9TkdzntoAx13ZBbSWliUM0N9QbZtR41oz9ASTkCkpKWYALAuZA3rPK/Z9Lo7OcMBZ6LPFkftXVyHzGzM/H9ifIpOtvzkAZpGdl96Eg8+bJiTacBNR0wGmasZH+QbTFpCwRlL6byHcXF6ens4jThUzcirOKczEtxZcaJ2q57avpwpS/WG6VX9aM3U5qqCrfVjcVlg0TAbS+0vNgv9EoXzi7JNflK1o4rC1AXrF2OI3f+42VNlRqZKSTNfh7U1rdBx+KDtFg/sImG5JwLi0r/BBZTBneNCw8mqgLijU1iTeNolTgRK6BWiBz87Yn0LY9mWmGuSd3BFoP0+YXNPs7BdJ3NaxccyueuW01kYby/JA93p7uhjru3Bns7Q7Tz5qZGinH8b28eiiiqjBezUJYQ286HaCsu4BzqC/4uWPUU5pynmBq6XKe0FBwOKMQvwlVELUgyDBaAbUvA/a2OweRjWsPuAnE5s1c7SbKLlXjJ9qbJY9lTvRXTU8X1g0GBrnTYNMGHF5h+ZQEY/+UhfCDN7mg3HuMN/5vwdC+zTzNrQwkE/+gKHFsz0nDvL6V5aGUxZ57olnDQjFL7gXtXeKFqrZjMGCNRCHDXOv5ue8NLClzU0cEskmPy4iEHpAYHs4cHc7msYDEbkR/HmLzhgwstuil1d5Ggd30zrpQSuzDlGC6N6phNSRWhOSpZr4f1D7ApCHGqC3XG0s5OcI4rWlkpQMoeab+pv5ItPimxvz3sSST9V+PhOJAnX5KHE2Xg5TwbYpd/V5O8Hb9Yjh0W7RMxuFx2hKJgabWhOY43BRErUSqu9lLMfmZ2zNCGdI7QONgdjzCzak7anB8Bm55bShxbKJwO9f2g8jr4kiVwZK2pp7VeJWP8qaIi
 29PS/NDU
 R4F6UEa3sWgX36wNpsR0tafOom/bFNYCRuFGNdtUh8/mT1qGrHrYdoQZVvzyvTUpcIN9JGJkZB+BGoUgCbzVv6jJbDQwOcZtakUu+aI6zUabzYtwxqTeOSM9luAvL3rRSsQLaOrsZjyvBVZbAcQ1hkQCGV+QicezW50h+XKLwoGIuzn3Rtb3zEePoZITWSVG3ZMPAh1n2UYKW9KHCjnWsYM1gstF6bISt2Et/7DN1qKnV8UdVWqzx/wWUaNdkxVsMXljrcaCppT0BreVn11hsmQzw0BmUykhlxw8x3MwmBM/tO65xhWfjIoifaKrDLgZJ5wbQipKhOo99PM/vlhLw7XEu/UoF8cSC3qpdyOC9JtPH3Co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is potentially useful debugging information and matches the existing
page offset provided.

Use the raw __linear_virt_page_index() function so as to always output this
value regardless of whether the mapping is file-backed or not.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f692..56b244552f13 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -631,13 +631,14 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 {
 	struct address_space *mapping;
 	char entry_str[PTVAL_STR_MAX];
-	pgoff_t index;
+	pgoff_t index, virt_index;
 
 	if (is_bad_page_map_ratelimited())
 		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
+	virt_index = __linear_virt_page_index(vma, addr);
 
 	ptval_bytes_to_hex_str(entry_str, sizeof(entry_str), entry, entry_size);
 	pr_alert("BUG: Bad page map in process %s  %s:%s", current->comm,
@@ -645,8 +646,9 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
-	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
-		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
+	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx virt_index:%lx\n",
+		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index,
+		 virt_index);
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
 		 vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->fault : NULL,

-- 
2.55.0


