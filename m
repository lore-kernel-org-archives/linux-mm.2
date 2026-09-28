Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A828C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40316B009D; Mon, 28 Sep 2026 06:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0CA6B009E; Mon, 28 Sep 2026 06:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9BD6B009F; Mon, 28 Sep 2026 06:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1A5F6B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0ED3780164
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:50 +0000 (UTC)
X-FDA: 85262742180.25.09DC3A4
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2716B14000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n u6FDMh";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=roxpvpzt;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=We1a1RJd3pTHnUgskesObo3/UU8pV3neGnph03OqD/s=;
	b=ZcxQpH1On/c2N+YI88qGGd6U/oHPL8a/wuxy6XIN2xeQOknGHalGjYkCDx26O/8NWQYgDV
	BYJeiPn7GYu53dHyCo3H9e7NElftaFL1vUXioUg/hkJNr1XtGjJLt6qPBTT0lgdnaM+clP
	ECP0BnOhJ1+o9F8/L0clhpEtf6cll10=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n u6FDMh";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=roxpvpzt;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590008;
	b=GYGPgQ48puQOch3LBasnMNhMUOK+T1ohvV8SRcClVOikRROm3IJlgkKg4qAN9WzMGgF8TH
	4gKZYxvGnoCM/Qyn14XI4Lgi9YCjDAVoPj25CufosdrF/i/vy8e4BpQV2K2lg4GZYmsCTX
	86dZkkD2XulFGHk9MuSX0GscurRj9UA=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id A8C11EC0102;
	Mon, 28 Sep 2026 06:06:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 28 Sep 2026 06:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590007; x=
	1790676407; bh=We1a1RJd3pTHnUgskesObo3/UU8pV3neGnph03OqD/s=; b=n
	u6FDMhC/Aev61iKDN2U7lEu1GUIWntJnP0TcYHrJE3AsHKStiZYzN1HYuZcXs706
	9fpNB0wZQY+q+vuegm6DbaaBSzAGCjSVi8+smtlczB0lRZ1QuSEGI2i6TIufVIs2
	gLJRKsFatVEk4OXVWGSZkeLJPYqK2gG3YCzsIdE82dLV52SMyAlokJ6263CKeOUr
	j3XBBAucpGv6FOenk/9Ud0eKM4Ye4IjHAPA011wNdRTZPe+FAabv03XxuO2B9Teq
	VxvqEsdavaAxeZEFifKwvujlbPnUbns2etyFWIWiFw/WdNLfw8ZyzwIRfD8GtRHs
	46VV5eIwb7jcrP853n/gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590007; x=1790676407; bh=W
	e1a1RJd3pTHnUgskesObo3/UU8pV3neGnph03OqD/s=; b=roxpvpztemd5mmLNM
	SBKU1Zp+oWU4wASZe8Bwmf/ie5YqiuLm7ul6MdWZkw8sE6C4R+3yQ5AS1U7OjskT
	ZmLAoDmjN7Ax6TOtDlsWMrIzwD1oba7m/emcZKu0sbX7EDgHI8xM+1C+MEiiv/0r
	W4Vsdh0jiuMfeSJroxjrlZqYq8UbdGTOPtmA4zJe1TNfErsgBBz1vkn/XtNVZ/Dt
	mOK5rD1D5o6l38Giibn+t6qBAjZvdROwFNmYgOpECkcMQ1wIW573zfnVSTKbaQ+P
	YjwMIUAKhd0RPqCBsLqlZQcpjOUw2HACWKK3S2EAB4s/H+PHEMEv4UDiAdsinO+D
	z4yrQ==
X-ME-Sender: <xms:Nzy6aqS3_3SldPu8yDPo0k5Q7-TslZfm9AvaFN46nkGEaBunZhcUrg>
    <xme:Nzy6artHU1z11h3OdcZ2OWq-9kusbymkTbhNDpBri9MDi8EeWvcT8TRM8GHz3Zx_7
    2DPL09l8s6XMyDwrk-p1SJ2JUClFWsH2dmZk5J7OWRDL5YrGQ9djmY>
X-ME-Received: <xmr:Nzy6at8oLS-OLoVWQe6f352ERwceme013KBHWK9Ki1_-6sNEvgUlLX5vzz8>
X-ME-Proxy-Cause: dmFkZTG4PJbO3UAUv73kvgZEv1qLl5z3Oxsi3Ojn/Cc1gjyQPAY4pttCRQI27MH3dZhDE1
    QOPy+mv452PPCSDsPFoXsadZBBemUC7OEPjfBcMnl1HRY+YTKUqrnPjkqBcWGUry80H8PC
    /K6WQA/dTtmOEop/aiwEwk7y/N5mXgzmzQwcpgiHqOtfdhP6k3WxKdxsMyJsyB6Hvye7b7
    y8KqhRd53u+yghVVISP0UmiTClCERv2XAI4oMribMzYWNytre02a5omAhHuTKchvkb64ds
    QZyxNlGi6Daf2p9KIHOOPKsvpCSjo6Or9ZEQkSNGQE8W6NOQ2qvEeUYlVLLdnIfc4NbbUP
    LcyZg+bNXnd9ILSeB6ijdfAszkrS8JFhV/ZxQZo5Bmtgg9U6DZB+dTeyvO3QZ6ouAZ+HCQ
    mYegzh0uWP3vtndDrCiL9oMhfgFnaCvcT/VFpol6Ml5nm5qqBNX8LV5mxQMfXEwY1Rhhge
    eZnz1VCUU+1CRYA5u3Hwnex4P8sBnbJJVfxPKtPwFH1auKd1Qb3p02JIJmUnO6oNwb9cfN
    okIu0ntVaKynVI8q2Ye7X3bliX2WapryX1XOBiXPHkSi8CD7p6APFNmr6CpfKJ63uSdeb7
    DOhQOY8W78NSLDIqh2bKc+6Y7z3ZjgsIiQe47qex4iQzwidVcpfCTZ7nNvlA
X-ME-Proxy: <xmx:Nzy6asaZLNu6lc0umJ7McNP24OQxMmD59VQVU5s29c6O5yjWaAGyMA>
    <xmx:Nzy6ahoQbedE28IaCAy7-kGEwI8LwilBb5vkMMkmPuXL4e2fVSFkMQ>
    <xmx:Nzy6asbSB4difzEM8WS2A5_fefd0nEV-dqRw6Svb9NiI77kQhFzpQQ>
    <xmx:Nzy6as7B2dIiI4lSSHFtjwtWLZXu1qUaEbUoUc7BPMeuiEL_0Vh6mg>
    <xmx:Nzy6anROsqO3zo14CdOAJeuWZ9LFzkrR_hlwKH9-ieYI7lbKMyPK9XSV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:46 -0400 (EDT)
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
Subject: [PATCH v4 07/13] mm/collapse: name the per-table scan reset for what it resets
Date: Mon, 28 Sep 2026 11:06:21 +0100
Message-ID: <20260928100630.21870-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gpjsuynrgdijkb6d6p88atytod7qmuu1
X-Rspamd-Queue-Id: 2716B14000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790590007-271762
X-HE-Meta: U2FsdGVkX1+s3OtXAMWUSL4Qk8hTrOx22S+nIMV0A6uf+/vY88uzenVwIY8OYogPmvsX4l5O/L1Qs2ItLfYMc+KEBqAvC2Cu3DD7ZTd51SLO895Xce4rcfpVxgdLxAeTteAL6g5GXrWSXgKCy2XDK6N2DFztynpZ1jsuSZD5GsF7Pkf0OIxQswDUnqRgt69nxvxZdJBnsMNyvT0nCoxzAcK1t11hJBXdAN41U5l9nHhqdosOnC+XFcxWGZmXJzzcZLfvh2lKH4WzBRjY2DLrn3NsIk3ThyL6nZoeK+L1nyGab9yZ3dO1FulgFvjeJYeZ887foTWwcEO51QEId/aVopXgX4VhamhyJfBhCbJ1tt7ubqVMIBo9InA+lqmyxSXRBUS/xBbJ2azZ3SFB7Ag4eykGwI/A/koyM8sVPbFFNWlUUwiK8pACq2kNl3sBpmcKlCsQ8jM22H+uDFqfjkHMZiKRiGwth08eU9RuEP1CLd8mVfIPooNZaQzc/ziBrujwLX5F+t8vwmqzMDaJwan2byqXkIsKwyYxg6dj5JQynIWJ2Vm0MiLinnprNUCBK7vr3xp38EpsCv2iJ8cMEbtyLVYv7AhB+pxpb2tjtr4UptGhyncfavzpNmW5afg64HIVISqnGjx5kl+ANaPS5yp/vonUkJ6du8BkrJiLTVvQW2IdRVSSzl31O+Gl+WzKvOIdv58urB1/O7+seQtQw2VRpmayDcgMjb0T9PlRynckfiU/61s8dKj9hMfwaCHw7rPu5I48iwKblCPZPTxE+Iawq7GZWNyjDrlj5kYQ8acE4sGOr4+d71ieHJ0DgFbm/IUhH3WwMus/Bx39B7lz5/Tj42CEndcvLlb0f6ye1cTRqOfsU9kGo+CCVYzHBjsxkhaNnN5yePsdbUuYe9ULE+k9SAirXJE+JG1Jp7/dtzWhG5eWrIm92uW0bLe+OAw1tRTmo+RNA2puZzUg+RgailG
 kK334nlP
 mWPBB/hI5S4VUNZ/0reRmc+aIYw7UpNUeBPvwXacfPxl0lJbRxggAVT+yi/n1AL0CBJ6vRZ6Ol7zhqEzdZ55dJuERIaU1/obJhWrkMh7vPnm/9EVMG4MzPFqgkfmAS4xba2yqvuXqNRSdkSWBQK/XZ/9v9pvUB03BTvHghos/eyAM4VcR8T4Zr23SA1LXbt4+kc6zL394+QCdJT7USj3idFhWlH2zuq7sr/cByymag4bOYHEuOJuuZENZ1hutwEZz97vK2bnWJkwKPWSg/WiVKOdIJ4RrY8u/VktK4/qRdpQBOoG2gldl+8M0zWd8VtPU1AM4ePgCfFiIUpGHh2aNszQ8q2Izs2HD7s+LbOIIh6CTEXHBhQS5IeTwcPV18GoZ0FLaWY40kxck29m+Vb8Ph8unWQqcqsWKUyYQ2wgIew1NK2CIje2ihY3KHENH/aVAcJEOFWA1AWQwGLZ5sQh/uKRB8DBWWIvNmuLXUtFKM2JyATxlFrbCc6eKng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init and release, run once each
for a whole series of scans.  Two names a word apart would then stand for
two different jobs.

No functional change.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cc69281c542f..60ec7e80d554 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -532,7 +532,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_scan_reset(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
@@ -1577,7 +1577,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2655,7 +2655,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
-- 
2.54.0


