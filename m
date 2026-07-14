Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97BFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8196D6B009F; Tue, 14 Jul 2026 08:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA5C6B00A0; Tue, 14 Jul 2026 08:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B93F6B00A1; Tue, 14 Jul 2026 08:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 451566B009F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:23:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE9B216039E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:56 +0000 (UTC)
X-FDA: 84987298872.02.44D5B6E
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf03.hostedemail.com (Postfix) with ESMTP id C82B020013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="W LGNLuJ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="dxic3/Ka";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0a1QUYMOPMY+SvL6khttYjCLI43JqaOiKufnepwcnw=;
	b=BIqog4Q2DcQMdSTDci4cwWFgb6FpMVGwj/nBVg7wXWjpVkQqTnycmM9lWCFmZMTwTrp0in
	APWwdrQAmriKXBSxztEKhezcn/yFQMQ92aJy6QBleULhjzy18WQZVFl6A07YSzgvO+s+NO
	R9b33kWruHBVakcUPaK1XDOwGlvS+6A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="W LGNLuJ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="dxic3/Ka";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031834;
	b=viCVav2jjhqjaA7LjKtI/RsiqL32fmzHEwRX3kqaGuvoAlO54OGSWBSnpPwCY2opwyrEkB
	6yyDCpfbJX2Xv8YeZQVC2qfHTLibXbZtVI+qmBByDp/yUVHa88aPDRvASyVxS56eDdO2P2
	oTUyOYWgYW3n7ppW+T4NPK3k+4j+OEE=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B7E287A00D9;
	Tue, 14 Jul 2026 08:23:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 14 Jul 2026 08:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784031833; x=
	1784118233; bh=/0a1QUYMOPMY+SvL6khttYjCLI43JqaOiKufnepwcnw=; b=W
	LGNLuJFxBWrSHckB5wRVqupAOxNLygiRQyPEsUw7uASygYWzCxbrMGxNB2NIgoQ9
	EHffatN/GgCS7/ABt0RfMD5rKbJMY3nCMU3FTRYFoXEqyfIsPWdGA7V8XxgkgySR
	flZUbd3L3LTWZ7Q6DS+zopB+k2IVjaERRMCTOWNh/Y7nP487sxWxujjT7udFOVLB
	It2tOnYqj6fEgvYVIYpGMwbJepTDPC/346vIxQiEIm4pOrqkVPJ1vPOvwy/gNEtY
	toQLi/ulIsUq/vW5zLFryE2/Fr8obt8NEeXY0T/p9kTg/hx0IOhs9Y/+PoSK47wG
	v0Blh7m+6exfc+bqHFY8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1784031833; x=1784118233; bh=/
	0a1QUYMOPMY+SvL6khttYjCLI43JqaOiKufnepwcnw=; b=dxic3/KaZf89qck97
	vfe2mTSSOFkWLBxDBwepWT1gEWeXbf2QX9iW4Bmzfonw8WnKpVrHa/YuL0iy/hTe
	cyREDf73F2o4ehWyDa9wSt/XNdGD3uA8Na3/vyapWSKTnRFMNch1rHj4jjXpRdGs
	SQTkoClZNum0JjnryUM6vra9k2k10VWI2b3uM8Wu/bZP0yKfPXyXpqu4n8p8jTVt
	Br4QeRE1htq65UV4+DaGHbBXhiVLd4EWlbGNv39HLszzf+cjADAjdWIB9NwVn4bs
	xlNujrBpYB1AJxQFibUKmevJBAJMAkjiQkzEDhHmsx7DJR6nxuIxl82gPS7jYvHQ
	0/g8w==
X-ME-Sender: <xms:WSpWaggJkeJU3EmxeREr0QDSAyZRCAgnH9LG0vm_wrIfuwRi5-q7hw>
    <xme:WSpWauxQijxhvz6w9GIyWAzqo152DdT97r-0JlQiz9j0XT3ugFALQbJfSlMsNBomg
    IS6fo6zpBvP2J9vXYJ6n7nBUG1naWVJspXNnIa7zMZ3LJn7lOuMyHk>
X-ME-Received: <xmr:WSpWamLLKynTz4ovFQl-6IECigvxenA0mWJq4C-50EqtMJwIy33gNM1gHDqSlA>
X-ME-Proxy-Cause: dmFkZTE/UbLJkgjt0BoqHglwrJX1f5PHEA/FB0nSUDVtYKpndNAtdUl6JHnSUpXWMgfs4c
    d4J6LwvZCUX0a5T+QyiumtaKrodT7U+OJWhjSGjWu2F5DfddgHzIfut/BYthc7Sto1/3uk
    EHEI9Uu/OGSx6QViQOKP9KqikD2m/IBo47muElgTZEunn3coMc/3CzhGZk75H75+Vz2euG
    I8nkEmlGh0wryQWBMqDENy1O90ym5jZd3bfa9OkWP8p+lMnB48rVCs57F+52UpkmpKSDTQ
    pvWo96Nduo4s64x50svctFa77x9730BnaPHuEEzPQXyZFSJzjFCAKNnirj3a4e+5JuRctf
    3AjwX4rDrPBcraK/o3UwdKh0iaxSX+j0q99V36cWJJo35qVybt7yo+jUA//DL74jZfDjav
    UwpHaX/LCOA8zLyCvjnSWcAJJdWonIZKQH5EkfB86gIoxmJbdDA/+gkzlAz8tI6pHf3a4Q
    hY2OEtBhBzJ8T2pcXDcts6nWcgon4DmboC3fGXnInCtwRiZ5EkfXNB6ZNhCRLIAIk6nzUy
    qDkB38vSo+lJme+ZkJwsNqpUM/STROBDHByw9QDBKHESUSqRTs4phsjtAFbf+MiBfVmkDn
    dJIe+pmHbjx71Zo+FTWJjNbMq9SQZvTIoOvz1lSpZenE7wQBJ8EqCdZmaqSw
X-ME-Proxy: <xmx:WSpWar2Ly2Mn8j2HySrdEQDCWGUjJwgI2NaQMJZdjISRKA9QtelBzQ>
    <xmx:WSpWaoc35WgD7yVf8WLqSNjT1muC7YbV0RmMDNTNRB3lQzfBAyNw0Q>
    <xmx:WSpWan6nW1fLWAySpnerCtA0fjiVS0nG8BXuMQs03d1WK3HK7DOcOQ>
    <xmx:WSpWaj8bBfe0BI5s3730ulC-f88KW26Z5OYpQseWknYuSVYBDNhsBw>
    <xmx:WSpWardi_astK4Fc_m8S94wRNrXdXD_6Ehli5WeV5kRQcZCZE1c6Z0lI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 08:23:52 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	Hao Zhang <hao_zhang_kdev@163.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/5] mm/huge_memory: refuse to split a file folio when the anchor is beyond EOF
Date: Tue, 14 Jul 2026 13:23:41 +0100
Message-ID: <20260714122344.351895-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714122344.351895-1-kirill@shutemov.name>
References: <20260714122344.351895-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C82B020013
X-Stat-Signature: 8zs3f89itdh7y5sgaq676s9nr91797hk
X-HE-Tag: 1784031834-93487
X-HE-Meta: U2FsdGVkX1+yjXjdxBDJ2FpyJKSwlJQlxe0qnbcKlvZH9l7Q6h09ciB+oFUVUbeuFlD+3ihU01mrADqGOlfPlr5J1IPUWShFKilLmGGMci255hnpVJvKkg2vvKL4ie35EuHNLEPPVbUjm2OvEnkWjouyRdGoNlGT7wj6yPqauvOS8rCOdmQTCAi4SagnDyQgRFeHCmLJFw2tNUNHMSDbshWUPBdyW8UiWLKKIgYs2B1XdQYLzfGImi/SBNjsIz9JbCE1Nl65RH4Mfn0fss6YqdHaWindh2ZaAbwav/8c6KChyGeaWdiC+kzKuRVNd5DcFNtMopy5KVPGF3s87d2zNNC+KKRKHns5QBzpI0zv+12FxTdS9whZF0Qqjf66kD0YpL9O3eDSKq6YdMDpd+kmyNCpa9Cw8mH8zP1l7SUE7MLgiOrHg5F9v/Or+XzcwP2fNwLZ846XUFgB+oOuJd1pANW64BAdgF4t04+qLpRoNVi4ybC0fuq0UxtBxHorGrnlF5dD1TnP2LcQ3vn54sIEP/S65ggJM2RGDpPe+sPbMM3CtZ2ZPKQpu3vPsrSgGVy4wj0FRo/pSAcHPFqHRP9ZxWAOJhM1FC8vtQBE00oICcLK13Ivm0eBRBObb4BnF/E5MqkqGZFsAEELy/wbVUV8xJH3UiG6QzHP13oKCI2W0sJ1jU3H5xW9XNP9nknaObVmPjd0qXuouHzcJM12k9XK8kGFKqiy8Zv1tE3x1NU9icQE1qV5xVEPJZT/HsOvCBb+c1SxN2xLDFhZXhlEBBLNI/C1pdRdiRxiO7xwuJzIEO2K0lpa5/gt7N6O7sQ59/JkLfrpP9wicy7udXJREjpdqvHDWS/aDzZr1tNSQOruJ5zTtIikj279dveJIMkVfjBdNMNuPxAIwVabFrS30mGpUe5W1YPfIB544e5taDTYaEOnMeOYFpWcUaGW/FwQUl3xDZ4CE9AV5bn6+0Pc/1w
 eqpxAsLD
 gqlo+fGYHCpdm3jPLMS7c9/r7HQwpaI+/4rl3ndHc4rrqBioKvxB0QTdlI/ZundAAKrTRAa+SqMd09L+72kj1x8OwlDYenYsnd/bQ98fcFK09MPhNtX/Ai6qlhXQRqh/h2wpD5IJ6AbgLALfpf8HxPG5Vf75xRIN3iN/+zgeZWGKiwrESkKxSnXge5IpZOoF8mry1rW12HbagjageRO1b9xLLdZcfOIQrv3O9rcz/eBnaVC/5+DkWL2QpMtSIjq0MDiH234Oww+Ggx94quuFAQdJ7C20OZXx3/6UbBXxkbEppqRYh23NpRdHRf40OzqNLusmvJpQB6ZZJItQUiAtBPmjWojNvHtWZdEClV1AOzJXsxlyac4ItOEjYSV8FndB13Rnjoc3phRGtgQIYoU89G1Ejg1vP6PRw5ocN3SnkbnAyYRNMOdyaVvRmIMMk88DlME9v4hTLVO/Q6dUuOs+tBpLsfQbt2Z9f2dD1ctLerC61VB+NLWXn/WL+NHmZ38XBwrhAPMjYr/zg0RO27o9yKXEBY46fG2bSTiTGogBe72477Rwf1ZjKFV03J/tx1n9yErtqMaZfjJeYWWT2lpEZU0JRSNmSFzjUclT3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

__folio_split() dereferences the mapping after the split completes:
shmem_uncharge(mapping->host) for folios dropped beyond EOF and
i_mmap_unlock_read(mapping) on the way out.  Nothing holds an inode
reference for that duration; the split relies on the caller's locked
@lock_at folio, while it is locked and present in the page cache, to keep
the inode alive through eviction's truncate_inode_pages_final().

If @lock_at lies beyond EOF, __folio_freeze_and_split_unmapped() removes
it from the page cache while keeping it locked for the caller.  That drops
the pin and lets a concurrent final iput() evict and free the inode under
the still-running split.  On the anon side __folio_split() already pins
its anchor explicitly (folio_get_anon_vma()); the file side's anchor was
always the locked in-cache folio, just never enforced.

The only in-tree caller that passed a beyond-EOF @lock_at was
memory_failure(), fixed in the previous patch to anchor on the head.  Make
the requirement explicit so it cannot be reintroduced: refuse the split
with -EBUSY when @lock_at is at or beyond the sampled EOF.  Such a folio
is racing truncation, so there is nothing useful to split; -EBUSY is
already handled by every caller.

The check uses the same @end sampled under the folio lock that the drop
loop uses, so it does not race the trimming it guards against.

Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/huge_memory.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..0e3ca7178d8c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4065,6 +4065,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
 		if (shmem_mapping(mapping))
 			end = shmem_fallocend(mapping->host, end);
+
+		/*
+		 * @lock_at is returned locked to the caller, and while it is
+		 * locked and present in the page cache it is what keeps the
+		 * inode alive: the mapping is still dereferenced after the split
+		 * (shmem_uncharge(), i_mmap_unlock_read()).  If it lies beyond
+		 * EOF the split would drop it from the page cache while handing
+		 * it back locked, removing that pin.  Such a folio is racing
+		 * truncation and there is nothing useful to split; bail out.
+		 */
+		if (folio->index + folio_page_idx(folio, lock_at) >= end) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
 	}
 
 	/*
-- 
2.54.0


