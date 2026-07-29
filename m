Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BAB9C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17AA16B0098; Wed, 29 Jul 2026 12:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151E36B0099; Wed, 29 Jul 2026 12:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068776B009B; Wed, 29 Jul 2026 12:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D37126B0098
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:49:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59870160737
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:46 +0000 (UTC)
X-FDA: 85042400772.08.D9BE272
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1C16AC0007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VgCpuxR+;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDKDN8+NyCbFBf9xntqxHi5cksOPKTX5TLeSSDFnRdE=;
	b=HlfEqFPtjEbuD+YXTx+IZeqBeZxsZb+Ir3GTpVWBIzWRogHPfxZYiTC1kCVyVsFWD8Jygo
	f7JDfk9opQSVy4XmkFJ82RstYXLGPfK7QpsyVwTEzfkfIXCY6qOiLuHVRsg0E5DvysFugw
	dMqCHqSh1qZpAAR5Kdhfj8O0yigLxh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343784;
	b=w8oY1iiwyKFtEk2LKzoMWdAAJAGwF9JN42hqlMtSp8HYHVbEqe3aoIeukayYWoFqV07xXM
	iBo5BuJR4pRvbXlTtvbxk0nUZhjd2qd+pwqyBhGnMXmrS1MszTQXQDFL9RRfdt+6JS/Q7v
	x/yoKJwyL57JjWor5eyWoLVJe0n2zfU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VgCpuxR+;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4334600B0;
	Wed, 29 Jul 2026 16:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227EF1F00A3E;
	Wed, 29 Jul 2026 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343783;
	bh=WDKDN8+NyCbFBf9xntqxHi5cksOPKTX5TLeSSDFnRdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VgCpuxR+86B5/XgT/kIgifDvsQYtOa0PPteYon2COxBzS5V0Hd1zXaDOHNIxDjvn9
	 oVWwwqr0x4zCqJFEqrF2azA3vrRQemSnrdy+zUT8jszN3o7QceMexe3m4KkXdiIccf
	 +/Gp9SZl4Ezyn5+AX6+OnsQWkWGN5GzUjNtazG/t/9ElDRmnZHOI2DnCwVIjmV5tgU
	 5VrMSNalVPKH0IBMHRmHfctqk7hzbEVWpaq6RHDbzapMof04cfvxShlPcIa3Ynv/YD
	 wPYeM1LQwdpqaRFzC9FF9I38Roo3My1eDwWRvOGHOvv0y6kqylsY+YBHPCPKKAW8SX
	 qvgNSp/1CEGHw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:39 +0100
Subject: [PATCH v3 04/15] mm: update print_bad_page_map() to show anonymous
 page index
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
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
 h=from:subject:message-id; bh=022bLd1rMmlNyvelJecXqv+89KISK1vz6wvXeWBW9xM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H5Y303/Hv0nV8MhvGxxhtrk+yoCFVvfX66dm7yGX
 d5moYp9RykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYydz8jw+r1til3nDadqiuu
 mr63QbpJzzltnYa8wVvey+duuX8Pnsjw388+4PgSwQi//su/2KWiU6dNbvi5favLx+xPk5rOsbE
 msgAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C16AC0007
X-Stat-Signature: uxa6gjs3ie1ac1xpc7ookp4rq1zfzxg1
X-HE-Tag: 1785343783-278289
X-HE-Meta: U2FsdGVkX1/ovCcaqjksApgGtOuyILbjoMK7PLusCwkbfnBJrhbKtNIiJ9QLxf4iYjhXXrUr7u0yPYkxNY+csgQ9xBhNh/bV7q3wY+bf/VEmO1zRa9BpNXs4RkRudVRjZTXaCQpTXQfrJgwbYv9IUnt2gFxK/EsnoE4MxDZ+aQ907NSHfeYUdgVX2qDJGIEavPo9GLmjeMzeAGm30zsExFlTexMgVUeDMfWGHf7/TaDqy4aW7uXT2F44x6OGgwO3BakyMDVxWxEX8zguzBOMrVumRN5ouqGGxLw+VeZGWtMUSohcbmi5PqAtppmlx3qdmesv+yQPMbhyrJidTg5M31FSgj2Miz3Ud03CokchFmKOA3UoiM+s26lKFFajKzwodVi7NFHUs4L1eRy4yfSB1hxEOPOC4zoNJjuwXoerTEXTlI+9zTnHdZWCY3Wd7Pyjily1ZLEpKT4hutRQbHb1i3eJRO+d2EWol0CMaIBzytw4zssNb4krUlfWJwuE4FUavtbF5bGtcEXavmub3uRvZl5XFc49UfBxedfgwmcs7FzDo6r+g/pCRKX5pAjw607qys1c46AmTrG3hoq5WCjg0c/JABUOcpC8ZG3gTXapk77u3EZh2BobmyZwJfTbjQFq9zpOtuhKwa7IBa0lI9OW2Ifz67UH737P77es3eHQ3V9KD5S3fIO8vA5DD8U2Plb8KetU4eh73o44vnD2Qeq2w3B6iOxJXFGCM/MF+QEYgwn4JWQBkGIGf51jNLabjJILGChYH1CIpm2Fh1Y/2yFdZq7Ty/C7M1vL2/uYNDZ0YXVn73xX8hluA116zuCkW3M1RNh4X40sIUKxsZH0Bs+i11l6GN6AsrSZy0TFQLz53vLtNJEyLtblhxG1PP+UdOVwWmBLW0vAQD+ZG0fd4Ne8FbrLO+ZjZHm2D9mwaztgyAqpiw2ZDRDSbh3+xu5Vd7iqPPmlUUELZh+tBDKj72i
 JwMTOhbs
 qVG6SEnwLCbt4lJlMQZ/upfUEQ4jNd7oRXgjgUxflhZz9d1UtZ5e4peFMRskTKfGrFDty7DFStMsc6LoZArRLJ0cPWb0oH8UDZJWgYUNas1BpisMwaT7jO5jLXy6KiairFSWmkAqxp584sGadMIig3RWRzLOHIX0jAtmI3EJm7IIFP78HQcwTxVEfk6mq4vu5G8JhVEYeoGajSzSknpGxlYLvp+KxnAuRcr+xRh/RwFpcQQT1KMy+y4zmKArpjR4Nu5Mv6C/plXhcrWZxyvjSDsXLT5TtNSIgndUEK9BjLYULc/g0HfTfCpnN8wr9C9LkSbTsyMDSCU1jOqJxEhpi1LNS8Atkyn4TrOOGyP41w2h+lUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is potentially useful debugging information and matches the existing
page offset provided.

Use the raw __linear_anon_page_index() function so as to always output this
value regardless of whether the mapping is file-backed or not.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f692..8658f7c75d39 100644
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
@@ -645,8 +646,9 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
-	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
-		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
+	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx anon_index:%lx\n",
+		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index,
+		 anon_index);
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
 		 vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->fault : NULL,

-- 
2.55.0


