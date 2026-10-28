Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F195606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VmSj8+N2
Received: by kanga.kvack.org (Postfix)
	id 3F4966B05B9; Wed, 28 Oct 2026 16:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D826B05BA; Wed, 28 Oct 2026 16:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F066B05BB; Wed, 28 Oct 2026 16:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EED996B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7915614015A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:28 +0000 (UTC)
X-FDA: 85373137416.16.C73077C
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6B086100005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6GqamuA001HPemkjnOqUKBb2WcS9teBrRtjEmx99fA=;
	b=MJI460wIAL/40kgQ/mf5QtXka1hEOwLSEh7Ro7HG7mLWx/IQpdsCCO67QcTMPVj13DwEGN
	9LJzOgk6ZxaDzsgbxgldlVlAJk0MKwWutopCTNGdA99tl6I4FDIrpq6HLs7BvhCRNURYM7
	58GTLfiMOUrdI41s6A6jOhj27qrHRxQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793218466;
	b=d6YSFosR+YR18dtt7qhhXEIDNdtI9NRRCRwsd/fKAhH5uhhmTeWDpc7eTS7iKqcRvHVvSQ
	6qUy5PIUHVBznLaBg/E3h37poizHE7lFf0Z/T+DMewORK45jGJDEcqL1qyMtCu1QIicBwc
	oAzy3oNIAi9qBShnJXz4ksYSEJTF4Zs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 035C9801E3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:25 +0000 (UTC)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6CD3140290
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:25 +0000 (UTC)
X-FDA: 85373137290.29.2F4C684
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18CED1A000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:23 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6GqamuA001HPemkjnOqUKBb2WcS9teBrRtjEmx99fA=;
	b=8nIrJxQQkwpOZcqovQtWu2RkarSO1/nUp/xVLW5RIBhAXMewj02FOkr4GfEvjQfb5DkLgH
	RPY95lZ2aX9Pm07a5IMa1Gr19zFI23L/GMV3aWsDLlmSANUK2h2Ur12gDTYfCmbEbjYnth
	/LDIgzWRQVMgTQ4MtkHtoTybTdb3E/s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmSj8+N2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218464;
	b=HnFpNJetk8rWFTGOzpVVw93rb33aP2aiu7KzhWBpY2W98UHqdmEVxBrOEegXwge2EJvrfj
	lbMRTt44o8d3rX5qoyZnD/oJjZGvRFVd80Lgk5HbHvGhX9MjW9uTIVzen+Nig+1PiIpJlT
	DYf6lXUDv2CkNOQLzZuSoY9fqtBg+L8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A425B6022B;
	Wed, 28 Oct 2026 20:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477271F031E3;
	Wed, 28 Oct 2026 20:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218463;
	bh=h6GqamuA001HPemkjnOqUKBb2WcS9teBrRtjEmx99fA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VmSj8+N2GzA0MbyYqBFCd1q6TYu1wwu2CeQnYCY5NJMrnwzn9omLMG6o8jgBSmll4
	 igFnOw111D4kzU5USzz+fQqulM7UVW2WVUrpKxUg4Dx3ZhL0i+82q053jOaO4pOhnH
	 NQSTg94doN4gEENEUDmEkwCcjOGPwVZ443UxxiKO/e1Wj2XuHBNxmFJfp2Oee9xrHx
	 3qNqIDpQZB7HlC7KnAACf4/1fJ4UpTvEwx9EAvHjGpkPgNp1iVLmxUrZm4jh8VtNeG
	 D0Iwv6FZ0BaKeJxJW6UTIjr1is3S9ENjSOTRd4cIXTh43um9ft8vrt2PCM1VIjNnEM
	 0vMa5Tdlrk2kA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:31 +0100
Subject: [PATCH 03/15] mm/hugetlb: preserve reservations when shrinking on
 HIGHMEM
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-3-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2561; i=david@kernel.org;
 h=from:subject:message-id; bh=fOag8m9aWaD8O5/vp5VjcGR+Ra7oerb0CGoQ+KJ8h0k=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZeG/by512hynePr08whB7ziv9zbXvip7y3nD7UDE
 VeUl//t6yhlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAic1oYGZ4ufiQux71z0xLZ
 pD8vZ3UwOj09OGuz0BxGRpciyXRdtacM/wtuzX9WWfrozIRFO0566Zs5qt54JsqZeXz916mzFpo
 +2s8PAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-HE-Meta: U2FsdGVkX1/cOceTNlBWH8s+mHAEN065iZ+drN8FBnBfzyW6pj9667O/XnYzwDdvt3kHXRGTAldJ9EoiOGlwgzeYSa/8pnfMPycD2KQx7D/Trm/I0GZbjglDq68c118Zd+mqeCFycuSOoWW8PcfYT8lQlUCF/9/+mClQSK7CaIhaouvq6nkUTseUYdwnjDARxDotvetbWRT3DsCkhve89vED0KBFW44MS6bi0KVJhjw5saght9prLQFR34//7llCPk+mZPkBkCgLUzwg/C0MvWwN/TWBzAHo/T70YL8O1qkaRp4aGO4oepyvYMUTFSiiaCH5rJq2IaStV+7pwEje8i5dnoQFOxyWdLSRLKvP7umyy4nFhEVxyoacJSMqkMH/qzL3q8XRDkgLLk50PJ7k1E2FcoUvvHazm0b0PmH6iyP1OHjOudSj6EgE496tTNFiAJ8twid5YVotrytNX9e4Gbb+IYyoDnZVHz2ptCxcbZbtVYM4QoLA24GBmqX/Mpk1GrgIfnOrP8qDdDDOqy3+n7pVlSPT/4ExPNSCsTpYdc6rmYuXy7OQ+vSwrvHKni0MlgH15oAJ+hP5eAR4fQhw8iNcsC0jzO2LCr2Fri71NYyuAjlSLz5useKnhyVkdQHlG1bkdbdnQUN8AfzQ3U4LIDlrSZVpTSbmxpSfkEzdRodNzTZ/KXwXbAgbuZ+3yl7uZNVbSl9WBh4JBtOt3rHIlgdjjIhxD/4lo3RvoGJrqQqFwIBe9cs0r86vx/PsLissHkAp8cursszYk7fNCDAttFrqVMlALyoJkKyQwEO48/ro4V1nHbOuIJ1p4F9p18kLEs5XhcYUGsu4wEnLKWKb6069Y7JQ1kY15TM1uNg8uuEnxprOrHEI3N0p3E/OQFj8BUR5qYsam3q2n1V7ijKAbuKRBXggqor89RrMl+IjC7nX7OqQyxxKE/i+1HfYl0XCVubsqf2MuScMmzsy+zp
 tbacS+IW
 eBm5hCW5dBwpTCxjscLbOBbpcAuQq3RwVyZpiySwQd+LFKvH/f2ioH5QtvQ8NbwKQ30LWe1FSdSnIbrMwc2Kh37j5NE89j4Dd37dgzCWapKeTMAoeB/GXT+/GBAMCkU9NuRTYCd8LTVNnkC3pDkcEfz2OoKDvXyvlGXmFclenpu0KyV0RONI6wgKi1Kd+3Iiag/wVTacagLsfwT+pCf43oRo0AN5I9YbUG8RofHqGkfRDtjypHC0zw1qhwgFnLKUL6QYMU6Oh7pFz0UdjFmwj0n0Dn2mAZVLO7US9yuokVJpW62pmJTbs+2pUuAmSkVLcuKDf
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B086100005
X-HE-Tag-Orig: 1793218463-577543
X-Stat-Signature: z461yo5kdmj9szxrufm9447t4ft4d9sx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793218466-984970
X-HE-Meta: U2FsdGVkX1+wwtrEjOkOHj4IYUzKK3qYTikRh2C1ZRkEE8hpMAEYK09M3hoIw1TcC6slZ0d+zEF6193YaPFSdK3vMV5KxfIi6G5MwskIbRp59/6RPGDlhtjnLbVl8NWPRVBzeytGg1QOCrqulm5itIXUOCaQtn4z61zu3RNcaQ5qy89+KX26rEgEbnk/Xf2kBFQGu3UaS74WW1DVIDDabSlkYmjntXKq1qhfR54cchy8RFjZlhJ5HkaTakerYUt67WuPFOX85hcbYbRFjw0FrsI0/XE+6CtxmykLSQ6KpTySfs+c1SYcugB32wbNLhuSh2aksrksr+gHiwfF+6h8m3bTUVjMtJQp3bsP0NXD7gPsUEi1J0zyjjJXsXZANShcEXvRx8owWiADfPAj4ufpeFI1CyqjoDTWwr+eDqnd95SKHlf20/NjEclzwIBeAPpnWZmHhAxVN8AV5V0eRORRuAc3RTmIG5j8KxEcr7D+LFJNi95PVwAyxnYTREVuC23aMa+DYLs7Hq5TZSuepXlP4qlQPx6XQ69ya3p5/7oNdoaQS/IZwfXbg1cswpkEh3ixsADd6Kk81yO5UIdHuttMgQ3QPMF6nkpfLz+H4Xjm+Cg01VmdJY8jco88CBN1iBj1cM2ORt46mOxsMxAYJ+JTCR0OdpBEfZ4evtIPa1DKWxZQ4LbJS/EJO7ONK+CN9JoJb+VEJAYveqh17e/zoUQAPSraMyFVPBGkxYmsecH9C78h94NcOdwQ8BGrP1qW2IHkehrFXd/Kq6fwrju+iM40ylcwsn0Bvoc7MeoPy6Yiyn8YWbow44230xkfFIs7ue5SJ1SLmnnvaVPZi6QE03/VKaVrypZHZsqFxjq4HpKADu+MmcC5T16AvLosCnSabfyvIYT+9WUekfL/9MNJt5rvh0dyjjnR9N9uHPxs0052itTr7I8ZOxuSsVtKhtaI/1DKFnwi5wWgsguJ6lebj1O
 MmI9gvcO
 WGt545dvit26AC8pMDU+vq76XWcaoRZ5kPAZSdZISGclVjpGDAXtrOlilxfk0c/VIMS8S7/qtsdnibcVErxZSl0DNiMLTQ2OdJNpUDkIIrXcb8BpmE9NKi6zNnnZBdpCqLwrvaGj/b5JLg4/eVt05QEmxR2ZloxKRJW7GoDJXKl/x00Xo9EhO/VRK3ESjwSj7RsIQwOJArHyDXgFnDKMnVMMAAaRT1M7Ccw2VYVE46uAAgZX92VRiTnQjo9hOjiw6ayub/7P7IGn315rmaRZncCqWQppi3lYSe0khJo/aTX33bH+1kut2VLJ73DXzzZ8egAcKBcfuhn1PKiku+YqZ5babn6Dp7yMMjc/c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_to_free_low() drops the hugetlb_lock while freeing lowmem folios.
set_max_huge_pages() then resumes freeing folios using the
min_count computed before that unlock. Reservations created in between
can consequently lose their backing.

Collect lowmem folios on the caller's existing page_list instead. Keep
the hugetlb_lock held through both selection passes, and free the combined
list at the caller's existing unlock point.

Likely not stable-worthy.

Fixes: 1121828a0c21 ("hugetlb: call update_and_free_page without hugetlb_lock")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3a94ea1c9457..a78b2487c20c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3708,39 +3708,31 @@ static void __init report_hugepages(void)
 
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count,
-						nodemask_t *nodes_allowed)
+		nodemask_t *nodes_allowed, struct list_head *page_list)
 {
 	int i;
-	LIST_HEAD(page_list);
 
 	lockdep_assert_held(&hugetlb_lock);
 	if (hstate_is_gigantic(h))
 		return;
 
-	/*
-	 * Collect pages to be freed on a list, and free after dropping lock
-	 */
+	/* Collect lowmem pages to free after dropping the lock. */
 	for_each_node_mask(i, *nodes_allowed) {
 		struct folio *folio, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(folio, next, freel, lru) {
 			if (count >= persistent_huge_pages(h))
-				goto out;
+				return;
 			if (folio_test_highmem(folio))
 				continue;
 			remove_hugetlb_folio(h, folio, false);
-			list_add(&folio->lru, &page_list);
+			list_add(&folio->lru, page_list);
 		}
 	}
-
-out:
-	spin_unlock_irq(&hugetlb_lock);
-	update_and_free_pages_bulk(h, &page_list);
-	spin_lock_irq(&hugetlb_lock);
 }
 #else
 static inline void try_to_free_low(struct hstate *h, unsigned long count,
-						nodemask_t *nodes_allowed)
+		nodemask_t *nodes_allowed, struct list_head *page_list)
 {
 }
 #endif
@@ -3935,7 +3927,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	}
 	min_count = h->resv_huge_pages + persistent_huge_pages(h) - persistent_free_count;
 	min_count = max(count, min_count);
-	try_to_free_low(h, min_count, nodes_allowed);
+	try_to_free_low(h, min_count, nodes_allowed, &page_list);
 
 	/*
 	 * Collect pages to be removed on list without dropping lock

-- 
2.43.0



