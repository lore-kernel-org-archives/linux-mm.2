Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443FCC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD2B8E0061; Mon, 11 Aug 2025 10:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E918E005F; Mon, 11 Aug 2025 10:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CDD8E0061; Mon, 11 Aug 2025 10:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661868E005F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:40:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43C51B6FDB
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:40:02 +0000 (UTC)
X-FDA: 83764736244.07.A4C2A0B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0FC7B180011
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:39:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=erEHF1K1;
	spf=pass (imf24.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754923200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xm0iYFfBOfajjEoxheRfcdwl0u9A+taNg4Dew7papsc=;
	b=AJEGMqYTplxBB54cZ1yfWQCoXFBKd7BK+DaOnqRAQFidKWC7MUj+O5AtxuFAN0+dPVnrnx
	SkMvPdZkBI0wQRkAeWBMLLE2J6Zrs6bSM/zz/k7HHgUu6dOWga77vIAAMqthHfLSpE7gpm
	fFfuuQ2bZjRsvu6lY7zVIeoPcBIjDTs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=erEHF1K1;
	spf=pass (imf24.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754923200; a=rsa-sha256;
	cv=none;
	b=ZBwE7QgYiVVwZVJLju4aBLjaj2jFNVuv22safJCzSW9GvE+WDMprdB7O8yfKjYuub+ni/I
	GSwCy3xa3xZ8JLuFl1Hd2N4GxSv5OVcewKzmNtcJaXS3VoTqzKkRQAiPx9zdTKiIMqPl+b
	tTQYsvZQqTEej1UzjWLRaXw6qJIu654=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754923199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xm0iYFfBOfajjEoxheRfcdwl0u9A+taNg4Dew7papsc=;
	b=erEHF1K1mdr1tBJT7JOPny6sV65GjdVs3OgJ/YWmnlhJUOVEvBoPRnQUkwgblFJL2kdC91
	Y9ANUSv+O8fyEUATk4WWMlqhtGQwPynCiqDLiUrRFBscIo+teAFW8OzARO9oEdL4udExPo
	StuZSpAu0SzmYCCRstOJd3zau9++ujY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-KvIbvI34MbOOpo4bgvWSIw-1; Mon, 11 Aug 2025 10:39:56 -0400
X-MC-Unique: KvIbvI34MbOOpo4bgvWSIw-1
X-Mimecast-MFC-AGG-ID: KvIbvI34MbOOpo4bgvWSIw_1754923195
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d5f50a07so25883455e9.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:39:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754923195; x=1755527995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xm0iYFfBOfajjEoxheRfcdwl0u9A+taNg4Dew7papsc=;
        b=XeeTWYYg0+BJP05W8x8nbp/0x8pDsxTyRQFLSc9q6/s1lDFE176FZQUgiqEI4QoIzb
         yobQ/ZRgjjJZd6vMa4WFznyuzQ/ZcstlND3epXo05z5fZXwAIHABc1La5CVilODkHKox
         RB5vWMWOMzUYvFttNY1AuiN0qM9FZu58jzSHXms8jHEWC2gIQ/PaP58gQkKUS54+5cTo
         Tw5Ghbl7VmCeFbzUj2yhg7aGODTsaUW1NRwJDWVwWO20DJ/KUXcbMEA1emAtG1Vssgdy
         87hFLXDXkfDWw39isl2lynHWWLBRK7Z44QCSM9hp6ygciJvBgXLWVlopw2UrlBlsYcxq
         xA1A==
X-Gm-Message-State: AOJu0YwZIdCKaq9B7Q/B8Lh6i+lwMvLQNqS4xAgrjOPNSygUbo2lHBO7
	B7+a082vXs2mJKXVIq1YbV0o/kROtFAypyNkJ/SwuQLe9H0tqiQiOQy9Vb/YmH2H1BWxly82sqM
	CNaMRO4vZfU0hCDdeY/Pew/VBjucm4ECdvUTKo+9hfCqpEUQqgtIz
X-Gm-Gg: ASbGncuOloEB7OPhhe4oSShBGTP7d148fEDTau+NqbzT1A9uLtK0V1jDTwKGVqniS9K
	SJLXhRVg1c8v9dq3TgbFlaR2suGg9zygHzyaOHluOopBBxC2FZFpXcoeSG4z3Cz+7FB7ck1l4LK
	LBNOm/AqsiZr7CdzEG0ZrIOuhoiLnUx338QoAWQ0Zj0eqVQWXwInftiNKBegA6dZ8ZhPZALwDkS
	aXtufpk879hyhmbgHohBzjrg353ldmQN02R02wJQ6/OV/GgxE3XafncZ4aMAWp21DQSZLKL43s4
	f7sWocdwfjZJHhq2VHcFEzslpMWFXdeQqECRMrT8tOCGkpvXa7Mr713JYt3a7O/5tbBe3+S+093
	6JNzvQpn3AjrQyon+MiGG1V6Z
X-Received: by 2002:a05:600c:1d01:b0:458:be62:dcd3 with SMTP id 5b1f17b1804b1-459f4f9bd34mr130468575e9.17.1754923195018;
        Mon, 11 Aug 2025 07:39:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiigg+0PNvGEb3wRzSSq9JM70VE9hLMIH2EVbNkuJbtlZWW3Ch7GW5N/kbNcHDKqZhLgst/w==
X-Received: by 2002:a05:600c:1d01:b0:458:be62:dcd3 with SMTP id 5b1f17b1804b1-459f4f9bd34mr130467845e9.17.1754923194477;
        Mon, 11 Aug 2025 07:39:54 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459fb43b491sm120611835e9.3.2025.08.11.07.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 07:39:54 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org,
	linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v1 1/2] mm/migrate: remove MIGRATEPAGE_UNMAP
Date: Mon, 11 Aug 2025 16:39:47 +0200
Message-ID: <20250811143949.1117439-2-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811143949.1117439-1-david@redhat.com>
References: <20250811143949.1117439-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bvDab3GkuJoJAgknlLgTGlZAZW7c-ASLCsKdMV3_Xsc_1754923195
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 1peczaxkmsrxaesppmcp5qqh9xgymcio
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FC7B180011
X-Rspamd-Server: rspam01
X-HE-Tag: 1754923199-213240
X-HE-Meta: U2FsdGVkX18xmfuzUta7UUH6jrlAvW48iNnfIQrUAp5+cyZ6R/rR3g3P0Wv2oXtGVjpI53z1/hI22vD4C8hNo2wmjQlSFa0YBpBUVgVogYf2I7zk7IBXLNN6j8mKxaMunNszBboYnULIeOQsKRyBJMe1Vc2aUS3cXKbNOi5cIdfQz5kcSDTAQTQOHrypJ4LeMl+yCsNLGvcBXf+KREG2RAzrfo/NedzjcFsWfRaDjnzSlHb6ILi/IElQ9Z1bGnDXNHDoRdXdvofMrDBsKSUWHnQTOcibXljc+mUPaYvAIkO3j6KkEgReEIBSARlay3INI8ojGTcM7cC6l2mou3lIcoHoSIXcGYQeOJMbKBS9C6cPd7w3zYoPlb2QBl4sdfiMYl7qqTvCxKPyLXzBYSU9ZqdaAf/Y1URtqigoDkSyb4ePPNeAKp3QJqnYOjZJO7lFqFOh2QPQzKjAnMLGAWHrjMfO2vmS4oezsGMj8VS/mzeEnFU+kDjy4yPQ5NN+zp05o/08Yem8r73vh1WpV0C8Trhyb3xFdZ17TFrQzVLHiDr2puVaD6tUiKta2XNS/yxIRupvxNQvxS+/hOToQFaGaHEFTbHvoSkf5NTjB/sZm8pifD4982ektvyOLfyZWlbCWRfYu36VaVpnI077Y4FTZxrybq6udwQpNcYecA/HNs+Gvzw81dRNfoTpMdCyCidkeTxYWWKneMBi6pNy2W2v6AHDIqPc4soG+qROpLFHBvxNkS8Vg7WVJRWdsl5N/n0qDs8DpqRSNPfnB5ThXOz1q3k0M6OcTZ91vZO1LUpAir7mEQH1Pc5GZKF6c0yNnEe6uSs2oCdOXY6li+oVEkWe4RKMLTsDrb5HTc7CihbCbZVdS3Pd0dF3+Y1uT9YbJDygAHdOG2GoZj0R3AgpE47iJfQzWRChSuQVTdVxBP8rdTCsx+IuD03NTuqdCE7dNNkFk5yU3lcONQPB94ey+RP
 cytZC8EC
 eZdQJJyqwTFn5NGejMe+rWmau7LlTu3WQMIiGlJcq5Dbg0FthNptUyvwcHrKaVmWtH9nKnVdm1XxFdce6K+SJrvGgxQVBs7IwIpawYDzdE5vwiq9BNK1vNFGmo5/+b6aSzOvT2JQwFsybtVzJD+FRht//aYsEBt//Zeehhh/BpuOkRWQuayanuaoX3OdjjqNW++aDvo4g+QHqaGXNhiwu4JARcF8bE+xqxcaTrBHDm+GgDGwVFblYgP76MmtJ85vFTLolqKLDUcZUOrBiROUIFH1LOilSjwZwrU/0HnivbuANejwbSpY8e+aZ9Xy2JhbsQ209ryHywc6ziov7aLq9Zkawpbn0PMcRyjniE++Gilf5kQ2ViAyD2vrJMe53wMkfHQEe9UKxWJs2yEFuiaLPzCkJHPNq2d+mu9sBT++JPet1SQvI2uf55AX5nRC7WP3A7YAPWYlDyO5LJdVJYazpl6TT2DOkzXKKqcTNxK0SNlKHX/C03V9VJCgFQG+zVVtM5NyVbboQxrR/MQ5azjpMVv0O2gNkP+VbWzhcwLjYPHqnQ7UzO1+6XCvGBlvLPTJpThb01t8KJhl9LhwLU+WLZoG9ND1ZiaShdsiazE7FYtjWh9nndP50E+Ppnwgup2Hke+1M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_folio_unmap() is the only user of MIGRATEPAGE_UNMAP. We want to
remove MIGRATEPAGE_* completely.

It's rather weird to have a generic MIGRATEPAGE_UNMAP, documented to be
returned from address-space callbacks, when it's only used for an
internal helper.

Let's start by having only a single "success" return value for
migrate_folio_unmap() -- 0 -- by moving the "folio was already freed"
check into the single caller.

There is a remaining comment for PG_isolated, which we renamed to
PG_movable_ops_isolated recently and forgot to update.

While we might still run into that case with zsmalloc, it's something we
want to get rid of soon. So let's just focus that optimization on real
folios only for now by excluding movable_ops pages. Note that concurrent
freeing can happen at any time and this "already freed" check is not
relevant for correctness.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/migrate.h |  1 -
 mm/migrate.c            | 40 ++++++++++++++++++++--------------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index acadd41e0b5cf..40f2b5a37efbb 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -18,7 +18,6 @@ struct migration_target_control;
  * - zero on page migration success;
  */
 #define MIGRATEPAGE_SUCCESS		0
-#define MIGRATEPAGE_UNMAP		1
 
 /**
  * struct movable_operations - Driver page migration
diff --git a/mm/migrate.c b/mm/migrate.c
index 425401b2d4e14..e9dacf1028dc7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1176,16 +1176,6 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	bool locked = false;
 	bool dst_locked = false;
 
-	if (folio_ref_count(src) == 1) {
-		/* Folio was freed from under us. So we are done. */
-		folio_clear_active(src);
-		folio_clear_unevictable(src);
-		/* free_pages_prepare() will clear PG_isolated. */
-		list_del(&src->lru);
-		migrate_folio_done(src, reason);
-		return MIGRATEPAGE_SUCCESS;
-	}
-
 	dst = get_new_folio(src, private);
 	if (!dst)
 		return -ENOMEM;
@@ -1275,7 +1265,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
 		__migrate_folio_record(dst, old_page_state, anon_vma);
-		return MIGRATEPAGE_UNMAP;
+		return 0;
 	}
 
 	/*
@@ -1305,7 +1295,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 
 	if (!folio_mapped(src)) {
 		__migrate_folio_record(dst, old_page_state, anon_vma);
-		return MIGRATEPAGE_UNMAP;
+		return 0;
 	}
 
 out:
@@ -1848,14 +1838,28 @@ static int migrate_pages_batch(struct list_head *from,
 				continue;
 			}
 
+			/*
+			 * If we are holding the last folio reference, the folio
+			 * was freed from under us, so just drop our reference.
+			 */
+			if (likely(!page_has_movable_ops(&folio->page)) &&
+			    folio_ref_count(folio) == 1) {
+				folio_clear_active(folio);
+				folio_clear_unevictable(folio);
+				list_del(&folio->lru);
+				migrate_folio_done(folio, reason);
+				stats->nr_succeeded += nr_pages;
+				stats->nr_thp_succeeded += is_thp;
+				continue;
+			}
+
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
 					private, folio, &dst, mode, reason,
 					ret_folios);
 			/*
 			 * The rules are:
-			 *	Success: folio will be freed
-			 *	Unmap: folio will be put on unmap_folios list,
-			 *	       dst folio put on dst_folios list
+			 *	0: folio will be put on unmap_folios list,
+			 *	   dst folio put on dst_folios list
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	Other errno: put on ret_folios list
@@ -1905,11 +1909,7 @@ static int migrate_pages_batch(struct list_head *from,
 				thp_retry += is_thp;
 				nr_retry_pages += nr_pages;
 				break;
-			case MIGRATEPAGE_SUCCESS:
-				stats->nr_succeeded += nr_pages;
-				stats->nr_thp_succeeded += is_thp;
-				break;
-			case MIGRATEPAGE_UNMAP:
+			case 0:
 				list_move_tail(&folio->lru, &unmap_folios);
 				list_add_tail(&dst->lru, &dst_folios);
 				break;
-- 
2.50.1


