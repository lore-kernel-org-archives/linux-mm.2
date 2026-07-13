Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2145DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F916B0088; Mon, 13 Jul 2026 07:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1267F6B008A; Mon, 13 Jul 2026 07:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015586B0093; Mon, 13 Jul 2026 07:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D39276B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:50:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FAEDC024F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:50:58 +0000 (UTC)
X-FDA: 84983586996.07.E478071
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8326D100003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:50:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783943456;
	b=bbl5l5DfE5fAlINVgH00JHbTU7UoyL2GvnY1HQ6fUBYIofDH01UAHSuye6v1ZrMGLRaM+8
	IZCz02kK3zkwFKMJ/PGVK2zn2AopQjFkh0xVguCnoKhqCxw0USSlvQSRXRAJaQhjff91jd
	GbIpXc+SEkCvLNYYuh3nWyNzUrYRGUE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783943456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=9pUsRzMT2bcg3WK7LBrHMQK9LV2tMjfzgkZJ9jnuMIk=;
	b=w5w9p1YMrKGdYmX90i9P3vDRS5Oa107FB67o8dZ19R+EtO7hROFKpOUMazhPZdiipYbTpd
	HwagynZXyvjggB8tuep9KPKTavEtxX70P20qXMbJ0SLmYOYFz+SX+Oz6nFvpoxagNNDPBw
	0z5LSfK6YdCqvxgHM1CRL/dJbqs6MzA=
X-UUID: 14a764c67eb111f1aa26b74ffac11d73-20260713
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5e2ff409-49b6-4a6e-ad9b-29162985b8f9,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:5e2ff409-49b6-4a6e-ad9b-29162985b8f9,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:d130ebfbf25e73115cc0a35aa7111af6,BulkI
	D:260713195045ABOGV230,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|136
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 14a764c67eb111f1aa26b74ffac11d73-20260713
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 672932306; Mon, 13 Jul 2026 19:50:44 +0800
From: Song Hu <husong@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Wupeng Ma <mawupeng1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm/hugetlb: restore failed global reservations to subpool in alloc_hugetlb_folio
Date: Mon, 13 Jul 2026 19:50:08 +0800
Message-ID: <20260713115008.937175-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8326D100003
X-Rspam-User: 
X-Stat-Signature: 6bfbqaj44994ozsfdnfgag67spoi4aj8
X-Rspamd-Server: rspam03
X-HE-Tag: 1783943452-668776
X-HE-Meta: U2FsdGVkX1+OSvxR+mlsu0kGnztZ9nrvNv4181rO8VVmlOlx2K/G6c73Al6mEXC3EYwUrJTimm1/kudWTHO6QagAv+zkdfaDQGDmG0SMVZpTWP15HeygPBWb0IZ942FmvIeSCL7cr5SANjDRo7H76PStH7acI4ZYfOMqdfx90VOgsjO7JPjZvpM46OwwaEGl+cVJ7wjXUU1TY+U4g4mc8A66KYKzMZVDNjcT016tCMdt6L0sZp+8lU1I0Vo8A+rHJa73EMwYjWjWZhSglFQa0fkHBvD22Wx+AUjD88VdglkywnLAuaz/kdVxr7LNYOCLu3Smgo01xKMIbV8zHl4sZ4e0HY7b9xmDg8OAdPTDfosikAetGd3z0AxEfz4nWJ0vj8QIqS2c5b8+cqDUYpAc1a2S6HvXgywWDpNVXP46KBTqunFhfrwR7BB/DB2I+OK4bn/Gz6QSdwbrYv6QSSB/brT52gVXoXankheXEJ8fxlNNsgl307+NpNnWVYh8aHQtJ2MSp3kdsilGInZu/0wayrLZ4C+j23aS3eejqvrRqtNQPrY87Aa1aDKn0HG4of+CxjBmYOFNEosfnoJGw+NejJilA+pYPN6zz2acg/vzTIQUko6akawVpVtPQh5buR6NMvlB68E/5FfSGyBVaSD0/dtTMbjAw3xQbVF1UZ1fx31V1o8aPhyZCjamfHs9kHaNXg9G3AfbP3h0OeppbOeh43ktYJpquvof2hSnzlL2WyOxzHs9Gd8m8UPquQccIaUOigEfqLyCr+WaoL6TtEqRQr5BqTlXoPTBAuoK86S+WNs90OXGOgdABu+W5YqxyLf5CjZDpi5SA+381OKqhhOY//5Htc2o8FnSSiaNlnWEzIIqRLujIQOsx7d1h8ZPQK5GK5oRhMveUcbb6n6dzQJmkUmfGFcIp6r0nMioVWYm0YYrJbIYef/dUzdI8qS+z0GaAxi4JZUzATgQM2FdZn2
 GNuLPVWg
 rDBdgWB4nXPMEry37GNupQYt4L/IlXziHo5lRKHgpN9KRQUJvP8KZwXDYdKTB0jWJ1B+LV6JREa96StDAyqp5jH7PD5cGgCfTa9xsL+utzjKTJTVuK5bk4V0s5S54KUYU3yZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When hugetlb_alloc_folio() fails, alloc_hugetlb_folio() only rolls back
spool->used_hpages in the out_subpool_put path when gbl_chg == 0. For
gbl_chg > 0 (e.g. a size= hugetlbfs mount), hugepage_subpool_get_pages()
has already incremented used_hpages, but the error path skips the
rollback, so each failed fault permanently leaks one used_hpage until
the subpool is exhausted and hugepage_subpool_get_pages() itself fails.

Decrement used_hpages for the gbl_chg > 0 case too, mirroring the
hugetlb_reserve_pages() fix.

Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/hugetlb.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d6c812d1857b..8413ec92d836 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3073,6 +3073,19 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (map_chg && !gbl_chg) {
 		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -gbl_reserve);
+	} else if (map_chg && gbl_chg > 0 && spool) {
+		/*
+		 * Restore used_hpages for the globally-requested page that
+		 * hugepage_subpool_get_pages() counted against the subpool's
+		 * maximum, but which we failed to back from the global pool.
+		 * Mirrors the fix in hugetlb_reserve_pages() (1d3f9bb4c8af).
+		 */
+		unsigned long flags;
+
+		spin_lock_irqsave(&spool->lock, flags);
+		if (spool->max_hpages != -1)
+			spool->used_hpages -= gbl_chg;
+		unlock_or_release_subpool(spool, flags);
 	}
 
 out_end_reservation:
-- 
2.43.0


