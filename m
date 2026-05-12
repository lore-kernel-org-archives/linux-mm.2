Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A24CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4C96B009E; Tue, 12 May 2026 17:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BA86B009F; Tue, 12 May 2026 17:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3356B00A0; Tue, 12 May 2026 17:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 891E96B009E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A21F1A05D9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:58 +0000 (UTC)
X-FDA: 84759999996.01.8F2E024
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id CF079C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P1RNgWGU;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
	b=xsDahik5UkYy5vhlrH7/MXYhIfdrHbZfOq00zhc3GEGFVmlcnUKVwnB517kb7p6tZ1ccQN
	yTacoW+Nc3MjyxczjEXZyTEaRVybiMXTR0IyLb9tWbC1xSRxpwNtgsy3qqeZn4mVT4FYSW
	QaULq8v96Xxtn0GTtsjHUZHnlxIWSFc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619955; a=rsa-sha256;
	cv=none;
	b=5SIZK2gQPx899bFl5mk3+tfMngkauAv2CLweZVBqWNzAWJrhnPy3uGRWkH1zJgVclM/DPf
	Ye9MLXeNX1IXwarZADR7GqKcgUieKl7i+taFiuHc9utrMGrnq5DisWmGpzi9BImAhiVs8a
	i8bcN8CgfaQErFZt4U/6KTqKNOXak3k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P1RNgWGU;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
	b=P1RNgWGUwmNaMtpCA/FT+FYDY8iXtBMGzCdbQVuYEb7xNopccnkF2ZNEUfX9+jgN7mwmJZ
	4zqN/bJRbIV4108qsfFf7nojhv8whMxVvCF7bb75I9GhaweamVS7m0+LwgxmHQlCDXO10Y
	7JJ0b5Tgcrr7xrQ5qkiLjyvTL1O59To=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-5hGeDWPRMnuxySk3m9mvfQ-1; Tue, 12 May 2026 17:05:50 -0400
X-MC-Unique: 5hGeDWPRMnuxySk3m9mvfQ-1
X-Mimecast-MFC-AGG-ID: 5hGeDWPRMnuxySk3m9mvfQ_1778619950
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4411a36715dso4307877f8f.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619949; x=1779224749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
        b=TyU/33lom0c95t7t/VG+la/yMwdy+7fIiM0oc8O7yP2WysuKFTXw9q5YM468hBTY24
         6t88mrsuzxGMnbpkV2mFyXf1uJfZhkzIN8bwOK/bBALZYNn6YRCGyPBZNvo7RKs46n2D
         Sli4Y8keFsXJ3MGkwrON330WBqpCMSbajzOmIbJDzBRz4XTTJBnahHKlakB2thxi+WNa
         DJaC5pRp8rNf8wns8pxSuJVY3xczIxbKAfaAMNG67pZhHtMqkhdyCgbHx8N1ObeRDR6R
         E0ggNJIYK4jgLe6zIAqc0Q0X6Ebjn75nh7wXzCedyO+3m3zCXb+Xn8S/yQnKFWX8LEeY
         IKAA==
X-Forwarded-Encrypted: i=1; AFNElJ+KYvCPx1rTyT7qIip4eRK8EY4kJ+I1+HJh69CZ3V+oUZmCIM57DZl6/iLC9YZf13wEy7H1CifJfQ==@kvack.org
X-Gm-Message-State: AOJu0Yyf1Mb7ilVnoK3t0K6U165zf4TvfTZ2kWrrD+G/5m518kyF365W
	Zs0Ip9nHbOL0zlJrhp6uhSKA0OngAZZY4rief5Iq+co56mCBMUYINXhMSSIe4mBPjpLGWEqevth
	nyscEUD3b86P2luxDiGb54IZXnjBuQ3n0wmaZKQ2MrUDeUE0REEi5
X-Gm-Gg: Acq92OHJhUIV1MbQLFkVlRUPVnlemAEZCspxnFJBmH0MFmn/sjKf+2gwXLXBBN3qCW+
	1f8EGp6hBMdE00voViF6GlvVDk7cOw+ICBFJ/f728Rmeb24ryhrcylLStWlVtWT35tK7WleFgkV
	3dM7dTVmh/IwkBzgQ7dOvwuppli0pP4RAmEkz02xmkSr+dmByHeQ+3cohj9ul5bz7rrb9o3XmSR
	i31VO/I9SUtHSwJx3kLY3CMkdS2rxPBkNsngf0Tk0Uqn/y5Yl+Hhnfwp5ybDAykxHqTiC3S1sIX
	G5GGHJEgGAigS/UGZSxJ4M9EhEwRsY/XYE7JvYdhd4DOXJ5omhEOxbj19cDNim8EDnSwTgVvhUV
	6O8bR1FgZWQ2J/4KOzSzK2zUYqj9rW/DH8ASa+Uwf
X-Received: by 2002:a05:600c:859c:b0:48a:53ea:1408 with SMTP id 5b1f17b1804b1-48fc9a09e36mr4382085e9.8.1778619949434;
        Tue, 12 May 2026 14:05:49 -0700 (PDT)
X-Received: by 2002:a05:600c:859c:b0:48a:53ea:1408 with SMTP id 5b1f17b1804b1-48fc9a09e36mr4381535e9.8.1778619948841;
        Tue, 12 May 2026 14:05:48 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f4247fasm36415055e9.9.2026.05.12.14.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:47 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v7 07/31] mm: add folio_zero_user stub for configs without
 THP/HUGETLBFS
Message-ID: <08b9139bf2329eb7fbc2b2af02d9537219282cec.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KWW0GMJhTAN7K6txPzrMZGQQxnfO4zUCh2bqNpmjlAU_1778619950
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CF079C0007
X-Rspam-User: 
X-Stat-Signature: yhdddo7n1jxepidzan791ex6c6snw3az
X-HE-Tag: 1778619955-676234
X-HE-Meta: U2FsdGVkX18z7RD0lBmPbNEVr/8Cl31PLUSHEnu3f31ax38xyzbW/VH6F9CTqDpHNOZH5La7HtIFUf8Qhht8q8WQPFh/DoI1ToDI+dll8m9vVX5FZIUGOramzFUCz1BcArY6tAMUMujNh9kPMj9P0NtlJ9sUreCMxTxHzXVCPosIvTlqYpEqj8kolLqG10IfslOl1a1BtXvTs4omTTdRnx9trXPc9WHtyieR2uKzmmoQjZdMaJ1Zla7D5sG4itLTSDKgmIytowVrwYex7RLBB7DhSVH74jkGwQt76jnnS2N9cvyIHW40TBQApD53HHli5jn223UO+EU9L8M03QMC992ytX8DljLKfCjLHJ0DK/HXrNY4Z2MV8wd3duPocuHs/LpDRtYKuaSuwnEEB73JetASwi4QX4tbl9gGP84bc/yoyUJ0j7GzT7Ri59nUGuGpmymnR3FbJXKIsn94gvs5h44QH73XX7FFJhmOnNokZ/SA8WzIjdjlNHyb1ipYFxP/NzUmeztC7dEkIDxZ7BNOthX+Ca2hd1W/YDmC9S16+vM8xVS6+VWoXtui2ip6SKNa/rH74lgY+ftoq9XEmL812ts+7e7VNd/ouiQ+3M8KGpNLNFtixHfjGad+QANfE81o6H+ejHrv31nmg1u3S4dEXhmkjklUPlzil8WqjGzWnVGnh55g/bIdJtRf5qx2mxtRypYZBauBo0WdnxuyWN6he4MSFkIBPLk6n6lDR2CJhTzF7WTj+lBfKlIr0WqmQHKhJLAT8LOkSa0RN2SCyVCTD+0KYpUMSUbApDBvngNBN/n0Ymp7jy6aMFKaRZI2H+BTzGYT3R+Y/ZT4XXSbSzjjT7lhla40yvV+tqZ9/Fbfj0WVrJ8qdUoQgnLkWivtclmQ7n2baBVjGFoZtNslYQHGBbwmpgIAttG42GBeU+p9xXuz3vXb6jiulhq+axvgqU7zwexLeqA5iCa6Zo51RGr
 Utrrczhe
 kx+e2o34vJ4RE1QbmxvQAIbL8pOWwUjhbHBnocDwvHRxQlt7HmYgfmVRqUhA54XQZYuYk4n9LD4TUtYlaFGZiEp3z48VWptbWbHi1uSIFVFhproBjRzdcPBQ5Z7NoFXkq4mgaqtawvzZQLIryxtjE6TTHuVbeu1Whqb3FBi7iterdtCg73ktxlbWdB+tc6qWtCpTv33TtlF6voFbhWlXT/Xz5tL4MEJqVSGr+usScZZ2xP8blvtLc2uL+9Qh2oSZTEjQqIa6CtVyFWB9CsntAxhQTTbJ4tuucKN8a8MbVX60ACfGdENfgfWQx7zJDBx46nT0ME0edc3RCFPlLZ6pdeugIdVVZ8VEwVcoCYQKax3I/lJ25rKNYRm0CMNyBeCQy3/kpogZHEOe/YMOCNmi7pFmaLUPgI2TNDGrfkzfIWIrLfWrkkrzjMkytHlYuwAmbqpooZBuD1IIoJPSGXpAvgw5H7f5SGJNPwsX8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() is defined in mm/memory.c under
CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS.  A subsequent patch
will call it from post_alloc_hook() for all user page zeroing, so
configs without THP or HUGETLBFS will need a stub.

Add a macro in the #else branch that falls back to
clear_user_highpages(), which handles cache aliasing correctly on
VIPT architectures and is always available via highmem.h.

Without THP/HUGETLBFS, only order-0 user pages are allocated, so
the locality optimization in the real folio_zero_user() (zero near
the faulting address last) is not needed.
This also matches what vma_alloc_zeroed_movable_folio currently does.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..3b1ca90fd435 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5070,6 +5070,9 @@ long copy_folio_from_user(struct folio *dst_folio,
 			   const void __user *usr_src,
 			   bool allow_pagefault);
 
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE && !CONFIG_HUGETLBFS */
+#define folio_zero_user(folio, addr_hint) \
+	clear_user_highpages(&(folio)->page, (addr_hint), folio_nr_pages(folio))
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
-- 
MST


