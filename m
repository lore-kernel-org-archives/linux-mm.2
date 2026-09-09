Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B87C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F266B0092; Wed,  9 Sep 2026 05:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735EA6B0095; Wed,  9 Sep 2026 05:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E476B0098; Wed,  9 Sep 2026 05:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3846D6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:51:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76C828015C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:51:36 +0000 (UTC)
X-FDA: 85193756592.26.EA42962
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7DAE40008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:51:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZnLobcLE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mn+TRjSVVIAZoTaeIYbM//CzX6IvKNmptuaikzRYa5A=;
	b=ByJJ/HeH/PbNqzOYIAAwUINzV/M94ywK1NwkLbovdse6ZBLJI/C/WqkVHPvvXQniBBtIiO
	LPuIW+6gWOJnaoBb1189rPLG2moVaiUTWhqNN8HFEDI9wD6NPVeFExTPNEpT6yL26gxeuA
	JNUaNVx9wV7tGYz+RbzZ8SXEUJgs1p8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947494;
	b=gxsVs5kNFq2zRtRrIxzihhR3XeQfht/CuN7l8ccrABOb3yp6c5YH8fE9oW68maJFep4L4k
	J2AWlETyzKnurrzvalYxfBuejQsDWHf7Z5ZSSAQk97Y+E8MeWz5gjt7NAP7KalAwoaBPL3
	erh2FSANf05F1LzmWA1RrCdZ0wR9KDc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZnLobcLE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66f883abfdcso5258410d50.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788947494; x=1789552294; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mn+TRjSVVIAZoTaeIYbM//CzX6IvKNmptuaikzRYa5A=;
        b=ZnLobcLELfTfCwPwLyyupDTnTwg7zFv1u7kAw4vWjiuj7XlC5cc4fGm4reFi/HaWz7
         U99AVvbot+M3qbt4onFARWQArMgOxErNtbCx2zoQrfNcwIO6o4PiBdPNJZlUDj//LUK3
         L33slAee0m2q8i4mV4bbhpd/Jn4PbX/9uH7g/k+wETlB6vEbuVU+rNF0rru2VfHOVnDo
         3DJUqMgqV1Klbq8JUG2+KuWLUMqCMmBoM+x4MVDrp/IQMClC9yuPSRa/2WMMGcI/4XJL
         Ap9vHv+jclLuPt70whf2BcsEclTNoB6hESUYnif72uvtZ6byxb5A4yvpkoyEJsj457tF
         JLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947494; x=1789552294;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mn+TRjSVVIAZoTaeIYbM//CzX6IvKNmptuaikzRYa5A=;
        b=lqcb+E2SD5K9hIeSMEzGa4w1GGnql6BlMJl7rVxFtzGs/yMnnd0tFwGoNvziuFjWXd
         JY0mPwgd5Xy/ZpROWCFza4du6MXj7om99mNpmNirN5Vm0gc/HpbpYdzKEmw6G7jEhzE4
         DMrqxETziiSOmD3pGcYZwgSQvMjTOYzoSg3q1XSchaxpq8EXXwPv7eytDvbgX2fGZpZK
         Y3heHTLHgX1mqc3J5hG4O/XHltScBswKj6CNu1FvVz/wKOoRKoGg7vLd/05PfPdMyqU6
         OU6P4jEIlFbB4k+vsPFsvt+n9IdaDcdPaAW2b9GFlphEA3PTXgffDLqM1h1+lMSMUg7L
         ExgA==
X-Forwarded-Encrypted: i=1; AKwUvByRQvY29BRZPyCrwaM7pIuf7DBa+iIdZ7sHbLiL09gValMxmUSk6qQZUk8+Q9cUEYxknGT5RcUfCA==@kvack.org
X-Gm-Message-State: AFuF++kuZbUia+Qy0UWFd5KO0hHqtoSQ7ZMf9fdX55VtdFlApsZg+6cm
	/Fc9zhRpU6id+NzBfhmpEoS7a4nO9lTsYhPaqE0DRnk5j8GPSCXXMO0jRDwaaD76pA==
X-Gm-Gg: AYBFou3xE1Mj1WjdMwukRTCvGnw+6Mr+szGOYz6xUP4/2XeZ/5jdOCpkfSWTxGlosaw
	/SeZkaxOA25F/9fDxqbq6QysCN3SwNIZW2uisxICR1GZ+A61hf9dQs2UgxL+kVEz50MWlQUrKgp
	4U0nLSSMHo5L4In/PFHOpz5BJwevY74jhunZNc2yjaGzmDNgA1DOUFJRHafetI1m7ZnKTduxglK
	04dxBiAOvkjLIzm1C9caFygYkgXSkc+FxZkysWBLv55qecSj+8JOfzopNyQc95IqTmknVnHeDWl
	ktMzIikjPQ4o7lY0HKU+Nrdi/TSCvPHrYVzAgSje3/wqvCWaPo84o7O1KG4BYnaKj1Ta53ZtpRh
	WtzcGNyQ4TgOxrS5zxB8+195Ju4boVC32p59BGLGzfT4yNATvgfVf48JvrYuEw/ENRZO+pf6kFQ
	AALf77sNbBiqyeVrwIgrq0UuA+clAj62QX9MnbRaez+mQH4eXcivxSujapTUddw1UYMTzkyvgDG
	GwgRvzttgHqfnikpQRZR3J1DSiLg6yvbQRL3LXR+Ve5HRpKOhN5ZbnJD2s=
X-Received: by 2002:a05:690e:b8d:b0:66f:c774:5b4 with SMTP id 956f58d0204a3-66fc77411b8mr7040210d50.78.1788947493066;
        Wed, 09 Sep 2026 02:51:33 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8749af79c56sm78820707b3.22.2026.09.09.02.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:51:32 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:51:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 05/26] mm/fbatch: lru_add_del_folio()+folio_add_lru()
 after clear_lru()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <b2e312f3-6909-5496-195f-ab71b45970ac@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B7DAE40008
X-Stat-Signature: eqhtghjo1q68e8qqwbm8wb87k7factgm
X-HE-Tag: 1788947494-149914
X-HE-Meta: U2FsdGVkX19vibn/h0D1s6AbbR8SXD8cupBT9jTH1v8j6R6w83xZRvJaENWt9/1Bi4wmMnAIEwTXwxrVyvmPHVUBIqJdLQy3yzPVf7C/78Qzssde4LmqMdFjSBL2aOgMyOfGYgGQm2iLhdD5YFi6cwolQkttp+YrBrywYvDR3iHAuF3KXY/lscASiAosRNGJEi6csX/9oOkKKQxgoXXjaD5DNjkgehRgvcZjrjws1m1hwOujHEGiXbw1CRupiVFoWKFUY8Zslp0ayE5wCKhAEKoqBxTjE03/BqtMslV/9EVSNxAptDNunBFHjun6bmzUU5sG4dSteYd642Dmjnf9j6diM9+0ii4aiAKRJIVon8QsDwk94ZqaXBx0mwlZiOMyZKNZkJm+yQRkfFa2IO4z1NKfJKh8Abr6mSV8QOCGa6Wj9DulIhNbONiGA8haqPqyaD522+u4CZFmujr23CWB/F74XydwEmY4D+7K75EpHWryq6Ww2lKmWirbpXytz4LW73QfQgl8CD7UgteF74mM9EtMUajib2TKv9yphnyBrloXwdM+awuXeyzVBQotW028SZhu4YIvMk4ZOINKcXnnxP8qSTlQPZGPanXeP9mQz8OiylPL5HP7ug90qlYddxZNW1WiQWhH7nynBRfXshDxaDSYJ5kDKCgtRH7lzib1OA1MRTT9ZF7u0pf2hqQgiVuAuqoVuemtGcOJhV45zHKEaC6yGijel9WLMEfl5QLeGgeTqJXuIiScbFVQ78oxPljPYuBaDlH7p8H0lmt5uv/Wo3s4nfJ9oLNHg4PINUhSIVdn4Nu+2w3y9kDMg8LBRAybzxNt32RgrKgEXY1ZDTdCpmaLRKmieS7EVR7rA7Q+BmtuTvR8Lbrx1DQPj7ZzLQaNaoSjgqAq2geqZcFGB1vE8igfzm9nPhDKiJ8Zmh0z+Rj9XGwLrUrXYS5xRtq2tmVAS9T2R91gNUMnuI6IoQS
 HroUtsvx
 whEv9gxEQ+x0sA7CTPPgtpg8RwEbywVh8YrdO03sFAMnl+6qLxj6884fbb/iiv8AQ/4h3EjFN8Kn/rUqjDcKRIRttfSKS//plQgY8P3KL32s6pNZWQIHkTQrDQtTqtTHcvvcnFTwE5/JH1ckRGtSlArHPFVs7+p4jiy5bURNX5fUrMTanlCZWzNWP3XfM2f1kSdJs/fSPt5cWUhsek8zNqcyX9TNsccMXJx2ZMY++HoExj2ZOFrUHqCXrc07IGaLTOiuqaMT+0vfIb1ADREmZxqCRzwS7l/GYJ8+ojTulUC7gWcZvpMtHbQl9nrzWkSZWXSCJom9F4+MWrOBFE4/udj66O0/m72nDlcTQFLdDWDxnUxTFRsAuAY4jMOW+pC3xDqRmCuJlp5rlVFXJaa9ZaA7e53Ju2tLwpJYgSzvoeHukDY/IrK0/fJ94dJfteWY/r+xHhbXhRgs1U/u9WPKjO/c5Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Most callers of folio_test_clear_lru() then proceed to remove the folio
from its lru, and add it back at the end when they're done (if still in
use). But isolate_migratepages_block() and check_move_unevictable_pages()
sometimes decide against, and release immediately with a folio_set_lru().

Which usually works fine: but there's now a small chance that while they
held the folio with lru bit cleared, an lru_add fbatch drain came along,
and had to skip that folio because its lru bit was transiently cleared
(previously, the lru_add fbatch drain relied on finding lru bit never yet
set). This risks leaving that folio off lru, unreclaimable until freed.

Fix such cases by trying lru_add_del_folio() (which only takes action and
returns true if the folio was on an lru_add fbatch), then folio_add_lru()
if it succeeded: invalidating the old fbatch slot, appending in a new one.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/compaction.c | 13 +++++++++++--
 mm/vmscan.c     | 16 +++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..9e045a90ba21 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1204,7 +1204,13 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				     !cc->alloc_contig)) {
 				low_pfn += folio_nr_pages(folio) - 1;
 				nr_scanned += folio_nr_pages(folio) - 1;
-				folio_set_lru(folio);
+				if (lru_add_del_folio(folio)) {
+					lruvec_unlock_irqrestore(locked, flags);
+					folio_add_lru(folio);
+					locked = NULL;
+				} else {
+					folio_set_lru(folio);
+				}
 				goto isolate_fail_put;
 			}
 		}
@@ -1293,7 +1299,10 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	if (locked)
 		lruvec_unlock_irqrestore(locked, flags);
 	if (folio) {
-		folio_set_lru(folio);
+		if (lru_add_del_folio(folio))
+			folio_add_lru(folio);
+		else
+			folio_set_lru(folio);
 		folio_put(folio);
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..4e8d5cc34f07 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -8093,17 +8093,19 @@ void check_move_unevictable_folios(struct folio_batch *fbatch)
 			folio_clear_unevictable(folio);
 			lruvec_add_folio(lruvec, folio);
 			pgrescued += nr_pages;
+		} else if (lru_add_del_folio(folio)) {
+			lruvec_unlock_irq(lruvec);
+			folio_add_lru(folio);
+			lruvec = NULL;
 		}
-		folio_set_lru(folio);
+		if (lruvec)
+			folio_set_lru(folio);
 	}
 
-	if (lruvec) {
-		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
-		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
+	if (lruvec)
 		lruvec_unlock_irq(lruvec);
-	} else if (pgscanned) {
-		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-	}
+	count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
+	count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 }
 EXPORT_SYMBOL_GPL(check_move_unevictable_folios);
 
-- 
2.51.0


