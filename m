Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579A1C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEF06B00A6; Wed, 16 Sep 2026 05:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0993B6B00A7; Wed, 16 Sep 2026 05:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B196B00A9; Wed, 16 Sep 2026 05:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C81BC6B00A6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6399412066B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:07 +0000 (UTC)
X-FDA: 85219109094.19.BA2041A
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf23.hostedemail.com (Postfix) with ESMTP id 604A5140003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m x2F1Lb";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=XmcWBwnG;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPMRtic/KA0rSWQIkttR+MrY+d6BRRufVKkb5veXeh0=;
	b=rhEw0tNWoVOCJVRd4N/mh6myJLAl4bZaegfLf1WTU72zuC2IVe/D8RCrbC+AFIRT3wfYi8
	9jzOjN3cJWFDksvCJ1T1hYplLWsUjCSweibvnmNJmx6PkZDPcGasLQ4/SUSHT74Uutr0DY
	8tMAuGz1dXJI68OYwvOAM7NnPXOGL38=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m x2F1Lb";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=XmcWBwnG;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551125;
	b=rcszjqdwe9Sp2O93/0dO8mMp3/fQfwK7ZcK21LhKAIjh+pMJgtNjd0nzoQ/AFzJHTz7rKb
	GUll8VcymQJbcwcvlnNrPaatQrLiwEJ7hTIC/xHUu32QE8SRXLc3odHcgIKc9zVjWy6Qzc
	AfjnyV2qI1Tbs4oKsIGwrF86Fn+aLhQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5BE697A0089;
	Wed, 16 Sep 2026 05:32:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 16 Sep 2026 05:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551124; x=
	1789637524; bh=zPMRtic/KA0rSWQIkttR+MrY+d6BRRufVKkb5veXeh0=; b=m
	x2F1LbVWRpmYR0FTgvLAxaNn2+T2bxQAAHG6aICs3QArEaVfo5GiLexoOBo62f/V
	7iifFU/Wlb3dqTDwTI4jB3k8zO2Bi4K0qTpZBJaleA/GFI/u2nTm/yJVhBnxB09+
	bwqEwsYRpZZFQjngVASQB3rt1XXtWQNK6FrFr1z7tnpLOKtGK9dGlrD0X+fUlbma
	MoYNxWj+odmyakcZGoVfJoEUb5Xl/KSSu9NOwgyLOrXJ+6gTM89AgLuxmD9F3XZ5
	x2UBwSyaQ9wXYL0YAnL/ZriuA/hx2GAdylI5wrXkkQaHkwQQxUE+1tQBXPhDpYuY
	2T+kxnqLBWFLJ7hed38pQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551124; x=1789637524; bh=z
	PMRtic/KA0rSWQIkttR+MrY+d6BRRufVKkb5veXeh0=; b=XmcWBwnGDwu1l7iHr
	WPdL3luoZRRXDxnJdTlw+a8DWUzav1l88PeG5L5VO/TSqMmntZ4kObtAtL7W2Q5v
	8J/llGpCwdyqYoGo3d/COV8fO5pV+jcAa6lh8j8CCvoCoveWglru3zW3LELtfng9
	XnOepXKQzG/p3mGTPAxrqYSUuWLT071ftZihjIAlIxx6cgszU5zmQw0qJY4UbDbx
	oR6AT4qBrEAQMr1jgQxlsQdKzPsGTIyE4EWKgAoGKiXlWV2WoMp5jsLJAqn3Tk0Y
	syJIDh4BD+zD9+bLZbWkI0DjhoqB5i7O/kq1s7IJPSvp7B1u0NGrcA6W4KrNWH/A
	g1sLA==
X-ME-Sender: <xms:FGKqaslmHM0jgX0bl7djxQhnqRooWNCL8OkZw9RFnHMUbjvzqr7J8A>
    <xme:FGKqanwYATLYV6gNkF_vqE1LiwWve5pUilPWd2ku3xXtq8nkb-gJpDPzpSvJPBOvc
    pBYvJ3YAkKTQWUNylWB8av-BAtHcrsr8PGVuqEcl9I14sFpiOzl30ss>
X-ME-Received: <xmr:FGKqagxxqCPKIu0YsKQjGeuWCDRPNZJQlAu5qjz0EPW9KhITFlv6E5DeRTs>
X-ME-Proxy-Cause: dmFkZTEOpyDQEfQMjLyldXBPAs1OiAaYjuycA/zprc2XA0sZE/gLY53LzRl6wisjmJsNcj
    shXh7L3amtO3W7Dj4gJ1brhV8efHSvbbvvisq8qNCVrU/hVVqWW2fJ8EDoeL9EfJt8J4fa
    r63UA+S0A+UN3c16swmwWrTj5sK0gOy7RYH1CN+xe4D6TTQ1ncSXBFkweWqSBfk0S52Say
    Dntsl8DI3TlZwS0igZd1iO+ltDo9n3qHIbwcYcvcbVUlu6Rxag/XK6s48+7ZTTYlI2aJe4
    hkL/jN/KxntOAh39VLdXeraBW39brB+PkStvfnz0wMlwqVlAhF3nsCCzTv21LQWeSF/idU
    l90nh564IAY/gtWrLk+kl+aUclafmy+2TTeoiPxsUwjQtvuB08Yj7GKIp/DEv79v7HQN2z
    4Oz0r6NYLbgfbR4716KqKJZYkbkDiTYm1lvYjbArOgZqUc/9QdfhHsq4iQ4GCbUKeFKvRZ
    6NVlkYGPjQqi0+SmjTazQrIoAQ+tAE4n9wxGKXs/bv5faKSlnIBkz/UryooHKvu2weMhM9
    KdWzoEYl57Ubj2Z2xRHcJZK9oMdIWueTYTTybq1xGHVkdw9j5PlfHhipBuv4iJM6EEzLZZ
    e+u2F3O9EPCJU+a0r3eoVM63sJU5MRxU3/TdAD63s/H2Bl0X2JFaeTNy/YkA
X-ME-Proxy: <xmx:FGKqau_C_kUNAldv3wUdin_PzWBbywSdQKIYpgxnccycbcKFAaAPug>
    <xmx:FGKqao9sr7M8lyflJHSd5zh973DwCuxJilHvtyJdaYY7RtKP2t757w>
    <xmx:FGKqapdONtDX79aAV5mv4ZTKDz_osshX7GR-xVzHUE8POzpqCyqipg>
    <xmx:FGKqass_jiHiQ0wSCB2KJEyAZMXdzf92253YXnInDwZIV-oyP9vk5w>
    <xmx:FGKqannvFIPVgJq6e0IsolLrc9SlZCLFl3YHmAyn7VHFzKPEPiXI2CvF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:32:03 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 06/12] mm/collapse: drop the collapse_possible() wrapper
Date: Wed, 16 Sep 2026 10:31:33 +0100
Message-ID: <20260916093145.4022188-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 604A5140003
X-Stat-Signature: 4hmtkiokt9cbzbj689x8dpgr7tqq5m7y
X-Rspam-User: 
X-HE-Tag: 1789551125-847297
X-HE-Meta: U2FsdGVkX196tNVISXts5zFBRY4K7qlVPOf0D9tIYxEOHtx3VXCw/cYYo62yTaVnIX3iHywEPzSklTJIDk/RRCqdMWAgYgFTQzO/ERJmaxN6DcOLsnKYRptO0fVLc7DIblzjUuOtaY/KgBesBn/eG3DHpKDeHX6Gr9j+AhHKY6Te5lFb19Y2JydoGMK4z8fMQ4LwbzuRN4wDdw/RcvBpzv5y+PEs/aMKE4HPkhZT2s1OXrd9WphjQLwoqb1wHVuUgtXZeox9Ss8z6yVIxMhBxfurFBPqqtbcZYU74RbpTywJDjRRy3pcTWR6jUM3gDX8ik/IJRaf2I8ORqo/a1QRd+btwAugCyAzfPU3r0eRaNqJZ466QJ/rZc7k3t02epdg1EARVmnGk6gRGw5YUaUixnUYL8MSRARHmHtLkIU4dt7LPTNSIv+ma8a0iPAsmnuFCjeqWrNuTb1uFi1GawfvHACJGhoNcguclSRjDOhRSUW2YlyLIoxfMwltU+ginZqv5cs4CVwjybpAbjf0ooipT9J0h6CpcBrezm+/pgxymVnsgz5iU3WTlEA5wMKhuZZ7JcbAgkKtLxq5d8PSdnVynlQaivJ+X+/ui0nbLau++6wEU4lMS09rKNSUx9rJJcc0PKXBZ+ryNATCakEKXNikSv5qdPDfaghLf05VgjXio0ZqfT8qOe7spJZdOLY3g8nkOnqwvVssJw4BlnGTKZJM7y8FrsKtNdBnCPSdCF15QXR5fE/CSIIHEjb5oMyrlPNPt26gu8nVvj5o2i9fAzX/fzsL7ESzJaDsNeY0WZer0AxJHwYBVx0MPWhI4xqK/5BbkITtsNnoJPnyXLwKvTLAA3fQnD01rG+ktEikcJw58awYddCSoj8c6QgZQTo+YVITEStUlV8+ohJTu1Z6MznssPPgpXMFt7UGLEDIuoMe6WKOR48MGBlgeLhSf2AB4vnvWj27WjyN+bx+G5TSH6c
 b6S/OxGi
 xoUkWy/5HOok8VuqThgfYyWpvGaDcU+Ok1soHKQWSExjbxEjRJ+Ksqb2MDNBkQ4yERegIeyeDiydoGBa3tMSCaFwkx7DXP24idpCqZM5bZmklC92uR0xAolTBTG5icAkf6hbmu39mE6txhpZdrjDPzBE6J3PLn6LDwSyvRWULyQNTTn7B4s70cYI3kBJwR/YQkpwFEexR5o2opkA7RNNvUSjEnE1OU0II1l/bazla1qY/aB44hF5/MGiz+Dx4j1lzgi14LP4DUX9Qn0bDVVvN818LSZ7azDYvd5VSHYtCYMBnAs3hIP6nhxJECPx6X7ZixEnHPJZt2+5kj1fhyVSDBwb+0NKWFvV0Boq6ANussxwGHTsi9TkTJlrR5oE6GfWziUqtnJacErHdHxKxWXn/kaw28O5Ob+Iae4crKcsdDmtXmlkHBaIdTIc2nrVepEJhmbHSOBb3kCDo/FcBaCaVoXdDjgpHVUuyBrxyHq3tND5nwfgONml225Qif32iwaeotg4nVimpitzByqYb6ZJGW9GbqpJ5IDF/upiG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cb08789b2d38..62bafe509bb7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -512,17 +512,11 @@ static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
-static bool collapse_possible(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, enum tva_type tva_flags)
-{
-	return collapse_possible_orders(vma, vm_flags, tva_flags);
-}
-
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
-	    && collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled() &&
+	    collapse_possible_orders(vma, vm_flags, TVA_KHUGEPAGED))
 		__khugepaged_enter(vma->vm_mm);
 }
 
@@ -2857,7 +2851,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags,
+					      TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3170,7 +3165,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-- 
2.54.0


