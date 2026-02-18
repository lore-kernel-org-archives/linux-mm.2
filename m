Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA7EE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E596B008A; Wed, 18 Feb 2026 04:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019F56B008C; Wed, 18 Feb 2026 04:16:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E647E6B0092; Wed, 18 Feb 2026 04:16:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D549C6B008A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:16:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1892B9166
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:16:37 +0000 (UTC)
X-FDA: 84457022034.10.34B1565
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id DA021100002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:16:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4F3pUaw;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771406196; a=rsa-sha256;
	cv=none;
	b=K+UGtxlxWwOEtwllLbjW7SHsMldhPpF7WyW9RGJon8MRzMZqTHquMZuapc7KhpBXBO1VsX
	gbigAGmNNHJ/YEGBHbBH0lr/gM5yVKwgl9yo813Ll+StSha1Uuzk2/cVHeuOmrSDw2A8/N
	dzqJElHO4g/oC1C3GCZyDRXxZN45+BE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4F3pUaw;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771406196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMa2Gj1UPd3mPUFQuVTajWaMXAQ+g5AF5tMQtFB8HMQ=;
	b=yGLMZ2CekueOnQ9C93CI3CLAjvg1xkQnH7vF8k8jL4DYayy4VUoOS9MAgQY09ipeDvDxr3
	SKYQuvVlYHVn6A0YC6Arig0Jfy4XwUNjGleMIq6+185REN1e8dTLRG2nBeNhNfblBHZGQM
	o116FkB2zX/vfnHaqddsnau044DrmB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01E8E402DE;
	Wed, 18 Feb 2026 09:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69DEC19421;
	Wed, 18 Feb 2026 09:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771406194;
	bh=e8WYY+yB4gBM6QEuuxGtfDY9W75jDyWemTDP6aLwPMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4F3pUawmpiGq9E9uyfHi0Ms0qZd/hG6Dgv3jtw03Oia/Dfr1lcapoIq7Pn54ukZp
	 56Qfcw7wXdmZD8YWwkgy8IjbpLyizNdP90+6SgkXD6gtSU3HHjZIiiVSv4TzkAkWvA
	 Lc1xr9rum86d/MCVOs9Pd6yXasQi7mhCtbBfz4pQuUdNpqtMqX5PVL5Qq5FIZuifd/
	 ZUBNd48uSW6yGj5mc/TYCAjUnVrJkaVFcgoZXw+wyO5M9rpIZpBG37ZGRRi1irAjLS
	 T5dO1jTjFezKnMoR8gp2pvjRTlQth0MyUm/1UGUgX12pzmrISRM34vyJ6yAI6FGBsQ
	 dlPwwzQXBukSA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Lance Yang <lance.yang@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Liu Shixin <liushixin2@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1.y 2/4] mm/hugetlb: fix hugetlb_pmd_shared()
Date: Wed, 18 Feb 2026 10:16:05 +0100
Message-ID: <20260218091608.25726-3-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218091608.25726-1-david@kernel.org>
References: <2026012605-uncorrupt-yanking-4155@gregkh>
 <20260218091608.25726-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA021100002
X-Stat-Signature: ueiipbyrb58sjfjnpukye5k1tgy93ke1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771406195-350104
X-HE-Meta: U2FsdGVkX1/rR7LyTeIbRcSF5ngEJMokPIRWrQ9nw0wS31CBBq8BNLst8sbSFzhuIqgE62af1Rf8Tz3s0MGrX4NKgEhquWpA/a98AyXhh9AxbEcbIKSzkNePWluMJw6J0Nj/yZniS2IcfK5xMJoUyPBGELAtz3+6m971I9nV+nBTWUJWpIztmqX5Jg6ETsiYfBQ9BTg2gPmKuhCUfYOVoRpIcLOLSAQATzu5aqvVTtV1iTOScogxBZdUoGza7bKKSbpuj202u18CxKhTDoAiMN+FDsHSuOUZqZtHzNjpWE6Joy2f//Oesz3lc4d3itgnwKUvRuIkFq2RLFeo/RC2r7lHoldtJ0z95p6jRyfeSfpzfU9grHns0hAZ8cD3btjsKf9jMoTX+4eu5eF+hhD9dez6T6JR2gHv7QMScpYU79XUsmD/SS2nKskYBbwPNdG6EOvMvnT/CY7/yuDoQNfyPQlFMHJs20aoDv+NT5ahXdT8z1h5c/nsk9mrmxVmv0uXBNLzGDo3ap7NAaFD0DW7EOZ/mQZ4UdNnjR1SxkjkJCsmZAvHX0AfYNpVNalH+ZNBukqzjKZ3B2DjmMIH+Tcw32OU3QMhHJcueLiHoI+6UDXa3iorYROE+CM/81UWYHoe9Q8QtG8tHOLyxaUufb0aWw25S5K2ohgAWEO65igDXaw3XdJIax+47DVpcu24HOBtaQr1+ELRue6sAJe6Qw0nMu/stiLX8QnA4kAl5ypYqEzohIma6i14RP5+x2lvsNn8w/ZMXl/YwTmyjxSxIQxN0vvD0fAZBVYPWgmuzNfeEKx57/cqUHDhrM5rJrVywIK+trIrX745UU+hUKP+tbewyhMWyJC/2b53qHBEsfDuQXd+R7dZlICKON2fBq3bJ8MnfCB683KjUZh1PHl3ReXbLdM9zzvImMISmgScc2UWPgCr4YkkH8vYYch0smfHL0ulg3RkE6Zv4c6glf6ihpY
 0HI+SaeP
 xIkU6uGSj/A9p32rMeFztD8jXRxuRuOxGO165dc1bQLKqxrGDXJr3If4jv45i/zME94zczFH1sV9Emao42qLf5RRYO2dnQpQmW4uphNyKZn5DExvYwSJrWRXUYAKkVS4VvmXOgIGiOS5m4sT/sK295R/WX29EV1WDIM+fAfDov06h/xVkMfbQ42pSdA8ZiViwDuYLFM0RayrBIb9LmiIFUbHpIuMjL1uLnz/y/xjL/B9wTRgwJu5GjvAKrrOBIAgkzJMj91V6TbWwtDvPucrFdyw6FqNIQsES4B3kUzYUSJ018ndIOoPn22EuqYAJ0GK6vVncq1CrJpYeI+W6CuEFGNwEJkucF0ADiMBzz8E1FylCRyyxMlYmkkqxdUnLSr9nGRLmLfCeRTlQZqLxWIe/QN6vOmzd0fDkedfoD0Z+DpGR7C82Gi1dl1h3Th3CXtif4Eblz6GUp/IVeP9zOXrJdLDK/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

Patch series "mm/hugetlb: fixes for PMD table sharing (incl.  using
mmu_gather)", v3.

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point.
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily. At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.
Read: complicated

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86. But that's all out of scope for this series.

Runtime tested, with a focus on fixing the performance regression using
the original reproducer [2] on x86.

This patch (of 4):

We switched from (wrongly) using the page count to an independent shared
count.  Now, shared page tables have a refcount of 1 (excluding
speculative references) and instead use ptdesc->pt_share_count to identify
sharing.

We didn't convert hugetlb_pmd_shared(), so right now, we would never
detect a shared PMD table as such, because sharing/unsharing no longer
touches the refcount of a PMD table.

Page migration, like mbind() or migrate_pages() would allow for migrating
folios mapped into such shared PMD tables, even though the folios are not
exclusive.  In smaps we would account them as "private" although they are
"shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
pagemap interface.

Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().

Link: https://lkml.kernel.org/r/20251223214037.580860-1-david@kernel.org
Link: https://lkml.kernel.org/r/20251223214037.580860-2-david@kernel.org
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [1]
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [2]
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit ca1a47cd3f5f4c46ca188b1c9a27af87d1ab2216)
[ David: We don't have ptdesc and the wrappers, so work directly on
  page->pt_share_count. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 1ddc2b1f96d5..2266c34bcbc0 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1241,7 +1241,7 @@ static inline __init void hugetlb_cma_reserve(int order)
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
-	return page_count(virt_to_page(pte)) > 1;
+	return atomic_read(&virt_to_page(pte)->pt_share_count);
 }
 #else
 static inline bool hugetlb_pmd_shared(pte_t *pte)
-- 
2.43.0


