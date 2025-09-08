Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8D8CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54FD78E000D; Mon,  8 Sep 2025 18:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5003E8E0001; Mon,  8 Sep 2025 18:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEEC8E000D; Mon,  8 Sep 2025 18:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2878A8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:15:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B83B085689
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:15:11 +0000 (UTC)
X-FDA: 83867489622.11.6B24ABD
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9767E160016
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:15:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xb+GUazA;
	spf=pass (imf08.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757369709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SrxgkmQx2uFEvUPpHlLnP4q7YK8zbZeKcxHv1gRtTw=;
	b=aym19P+BX12lQhJQeRdgEVKv3lVMquZJMtcAYPasWAPfkqNDmszyPoe/OyS1OtZFz2R3y+
	Sw+no26IaPnY6BID1LBKJr6JM4f5MkqlUY1priNZo+h5gqPecSbXLlfVIii1Ej9RB81PQ9
	BzdfeoB0oBtZS4Y+aHH8f+83cz53swU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xb+GUazA;
	spf=pass (imf08.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757369709; a=rsa-sha256;
	cv=none;
	b=wAmxKypCl8LNymfrhart97YhBqV258SntBY0PXSOTiZigvJBPnpyvw+43GokXvQliRHsoN
	e/h6f4pW9IogGN9SdUASwZ4XyQAfkLN4fyHlhcQn9UytOYdoTHoMgqE8Xmg3Xhgvt8j8P0
	FQ7xjzRFeh4N/ctBBYOqFtC1xEo/uaw=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-723ad237d1eso44555357b3.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757369708; x=1757974508; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5SrxgkmQx2uFEvUPpHlLnP4q7YK8zbZeKcxHv1gRtTw=;
        b=xb+GUazASD/iOnhVBAAw1D7s5jmCGzVGk3bne5tx7UtT19eOVtA641LJlXiPwa991K
         Tlj1hC52FrvXkCNJj11ip3jT6MaqjWxbK34crF4o2ajlyVn0x6zMIub8btC5qDoOPX60
         VcnSclg96FpwzTPDuy5/hoG84E977l8TaBghzVHLZckhQoHyEMJErNRdNtQKtkATCluh
         x4UZug3aR/RElYAiwJ82I2U49piw3OnLO6inWfUoEABFqmKKgMDRKPiLBTCgLkj664T6
         oSdz75JamdLImIDIYyf5nS5r/kdijyEGRWuu+Ydf9czuYWK5xslI5O14pa9oadYY6AJ1
         5A0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757369708; x=1757974508;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5SrxgkmQx2uFEvUPpHlLnP4q7YK8zbZeKcxHv1gRtTw=;
        b=feLAPQy9kuvj8qshofSFpaY3aSFza/HlFljjSwDJSMVbSgBJjAL61DHx+LSraApTI8
         Zr4ZyyIy7yGn1VCYAkdmG3k3V7junNIWb24pzds6wJz3Uplt6uiiHajOdoiMCB8v3Zbp
         nR8rRbosrWtn7O65Vw7qNWnFC1I/WrmwUTdl688QXtNCcIrRqPteOrxGaXbssJic9Bt5
         37m0QCW2dxSpiTH2c54qxhuQHvAWigHQaxEGN4mVHHAIKsFrsWITUEdoBcTkQYRB51RN
         yul8ndwWy4nAgxBiwGzu6d5b7RPeuy4ql0y18O+9/9EsfRt5gMGwQDhUekxxRTpNz5bA
         /7UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSnUMWx+046kIqUlkoc9Vt6h0/TR1w1chUlAojzCl8KGUczgayuCHBm6nvH3cZMyTVJhVDTu8i4Q==@kvack.org
X-Gm-Message-State: AOJu0YzO9ohdAhVNC1A53G6AhC99AWAKms5BWkaVda5dXOE6PkjOy0eW
	kxskdzw4vlYCBqDQ7lKIcl9xVCf1nB2ghRTJvMxF5idbPoYo2QJ9zcUgbjP/3XiZ2Q==
X-Gm-Gg: ASbGnctzqniUJQcv7hgExyhvMem2f3wZYgNO/2+PtBwwYMNPjDDzRbBAku4CdiHcQdI
	pVBn1Orov675fLF4bHksIDEGSyZcXyVBTUPgx9pMOgRMoQKk3H7EK7kL0FcMyAkQbOmhbCWRsJ+
	sVwnE/faBPxEoCngkkma8ZVCRJP/nxQyzHb8Q400v5LIbo7Od6CNDzCrWrEfI2nTusuC5AjDpEX
	9twofZ/ZpygMd2pBNfL+TuJuaVbs0Ywnvck+fjaaIe8OxBlfkkYL2AxHwmJppIkzw8Uy/N+05fS
	xfkCwo586GFu8dYRbu8xW51U12dceU+oOxsrP03iTPnHkaBhvrxRb0XpGemy34aA/eLcfrie+Hd
	ZzCCDTre/jnT3hLilrMydm8I3H6X9cSBpGvoJ6u0Qk5PBZbk+MWsWXgMSHpExQcSfnjAiTk+L3z
	8hpNNUlC6sgt6UkIIQVr9S6dWl
X-Google-Smtp-Source: AGHT+IHbbZGCqX2bqrWu/ZbM1jf8n4KzCYSp45mow2B50HtcCCoCtNXlIXNvC9OOHQGNTdFk/Lk4rw==
X-Received: by 2002:a05:690c:6d0a:b0:720:4ec:3f7a with SMTP id 00721157ae682-727f4d6233fmr76683737b3.31.1757369708132;
        Mon, 08 Sep 2025 15:15:08 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-724c8ba45b2sm36513917b3.53.2025.09.08.15.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 15:15:07 -0700 (PDT)
Date: Mon, 8 Sep 2025 15:15:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexander Krabler <Alexander.Krabler@kuka.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>, 
    Christoph Hellwig <hch@infradead.org>, 
    David Hildenbrand <david@redhat.com>, Frederick Mayle <fmayle@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
    Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>, 
    Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 1/6] mm/gup: check ref_count instead of lru before
 migration
In-Reply-To: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
Message-ID: <bd1f314a-fca1-8f19-cac0-b936c9614557@google.com>
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9767E160016
X-Stat-Signature: qnf16ahtz58w6yfqyp36ybym9c35dts5
X-HE-Tag: 1757369709-520001
X-HE-Meta: U2FsdGVkX1+yc45+8mwEy1Iy4HHzRNJnZMChx391VwpR6s2e5ZApXNfqrMMLvJk22CxDyy6AzD/WwnwniWhBojV/S/7YrncvHyakwU9pTMSgsoNWf/TNAHNFIKVcv/a31DV9ieZNNRsWAckJj638/U94m4WC16iJYtxgZeY2UOi24X9WKGoCXCQVNH1ElObqOEeShjwckP9CtP4tD4SIhOOvDiAP7MD1D38yKk5Kb2gBTnSYCuGADtoFxnjHMoGWtRAAtdSzOf2ZViKzIg1+uHC3NocmeXX+92P5l0yEKa7A7u9/UTV63sjJbDJZRcBbLv5BanZKapGP2PYtNiczomi82gvJL8/jyrjSu5Vf+5pQGlTWfKCniclymV07LiJVs+oxBZC4CnDnc1nABLyjNPePQyouEtkFanZOgQwnXa7lqlNzN3ZjDGKQl2WklYhCbUeCo31YoN8tqve8xqbMKRK82gLhR/R7cGgcEhqcu13ALR/reabDuGaMyhGP+ogh5/1SOxk/cTuONbhxpqOSQWyXzUoXkIIFF7iF5WAsZEg9UuQH1kTfiVqZX6FdXBLGipYpXxwLYZekfzYSp2P1JpkH4Krmkss9I1YDnatoeQeISxL90DywkDXDdEV6XvrtuAlJFGYbR75Smkcpep+l9UJYJgXbClg/FSCPooU9YP6FGfarAHk84yFu31BtWDl3+XoeNph+3+nA2eJP2L9gvgnwPL3tUzz3MJrgq7jcZ1AiJMq9i7t1V5y9zKTo3jAu4tgNQJph9RIupppLTbRYhvgl1wZ1v1D84FxzBRY9iW3tyXLTwop8rbuW8NYnxcnnX52ncV8793AzFuj+WcYgR0x6ObAsti9t7AlvIi7N8+hUiiBV0npuVlS3OF9jCsEKSDRzma9QLddy6eeY8/B354sxxwqyf2Ip+zYUm/n8z4HhjQEOWqNm2CwTIYIg+eDzmPDrTxGX7WPOhNXAHvy
 BNK10d/E
 mXugjylaMbg1cmIwQxKNKJQea0uCzNaXPHfUnzfO/artvQvso5t3iQuCejx6Ij9zCh9ZbO93znK5s/ffJ0UQ39gwIkX7OwZHfRxECLIS7BGT7wb4C3JoON5wdhBCaIJprYZo070N0ml2vo9Kh7q5avzmuXvQivspTv3ELrvd0aSkq78RsUEDQo0EUMHi8lvOrChHUpOjZz/EpFpQC0aiRWzl+O0aHzMv06/PrWZKZT3utaWaWfr2wTAAgf7dlf2xoqybCBOheWoTrUGVDhGHVxDngLe5sJ6V+kytLIvThUJMN/refc8OSt0NlIBemgR4OtURl0pW8mAPc3y6f/NVUSiQPGonz1quF+2ojfKXJWxiDMwcn7zNSwdzQNZqbuYveONqOVGQPHcbewxc7nijz5ytGb28HJnFkmAN2m+FTVNYbdmE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Will Deacon reports:-

When taking a longterm GUP pin via pin_user_pages(),
__gup_longterm_locked() tries to migrate target folios that should not
be longterm pinned, for example because they reside in a CMA region or
movable zone. This is done by first pinning all of the target folios
anyway, collecting all of the longterm-unpinnable target folios into a
list, dropping the pins that were just taken and finally handing the
list off to migrate_pages() for the actual migration.

It is critically important that no unexpected references are held on the
folios being migrated, otherwise the migration will fail and
pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
relatively easy to observe migration failures when running pKVM (which
uses pin_user_pages() on crosvm's virtual address space to resolve
stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
this results in the VM terminating prematurely.

In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
mapping of guest memory prior to the pinning. Subsequently, when
pin_user_pages() walks the page-table, the relevant 'pte' is not
present and so the faulting logic allocates a new folio, mlocks it
with mlock_folio() and maps it in the page-table.

Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
batch by pagevec"), mlock/munlock operations on a folio (formerly page),
are deferred. For example, mlock_folio() takes an additional reference
on the target folio before placing it into a per-cpu 'folio_batch' for
later processing by mlock_folio_batch(), which drops the refcount once
the operation is complete. Processing of the batches is coupled with
the LRU batch logic and can be forcefully drained with
lru_add_drain_all() but as long as a folio remains unprocessed on the
batch, its refcount will be elevated.

This deferred batching therefore interacts poorly with the pKVM pinning
scenario as we can find ourselves in a situation where the migration
code fails to migrate a folio due to the elevated refcount from the
pending mlock operation.

Hugh Dickins adds:-

!folio_test_lru() has never been a very reliable way to tell if an
lru_add_drain_all() is worth calling, to remove LRU cache references
to make the folio migratable: the LRU flag may be set even while the
folio is held with an extra reference in a per-CPU LRU cache.

5.18 commit 2fbb0c10d1e8 may have made it more unreliable.  Then 6.11
commit 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding
to LRU batch") tried to make it reliable, by moving LRU flag clearing;
but missed the mlock/munlock batches, so still unreliable as reported.

And it turns out to be difficult to extend 33dfe9204f29's LRU flag
clearing to the mlock/munlock batches: if they do benefit from batching,
mlock/munlock cannot be so effective when easily suppressed while !LRU.

Instead, switch to an expected ref_count check, which was more reliable
all along: some more false positives (unhelpful drains) than before, and
never a guarantee that the folio will prove migratable, but better.

Note on PG_private_2: ceph and nfs are still using the deprecated
PG_private_2 flag, with the aid of netfs and filemap support functions.
Although it is consistently matched by an increment of folio ref_count,
folio_expected_ref_count() intentionally does not recognize it, and ceph
folio migration currently depends on that for PG_private_2 folios to be
rejected.  New references to the deprecated flag are discouraged, so do
not add it into the collect_longterm_unpinnable_folios() calculation:
but longterm pinning of transiently PG_private_2 ceph and nfs folios
(an uncommon case) may invoke a redundant lru_add_drain_all().  And
this makes easy the backport to earlier releases: up to and including
6.12, btrfs also used PG_private_2, but without a ref_count increment.

Note for stable backports: requires 6.16 commit 86ebd50224c0 ("mm:
add folio_expected_ref_count() for reference count calculation").

Reported-by: Will Deacon <will@kernel.org>
Closes: https://lore.kernel.org/linux-mm/20250815101858.24352-1-will@kernel.org/
Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---
 mm/gup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index adffe663594d..82aec6443c0a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (!folio_test_lru(folio) && drain_allow) {
+		if (drain_allow && folio_ref_count(folio) !=
+				   folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
 			drain_allow = false;
 		}
-- 
2.51.0


