Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A375D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B586B0031; Mon,  1 Dec 2025 12:48:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C6F6B0093; Mon,  1 Dec 2025 12:48:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B0A6B0095; Mon,  1 Dec 2025 12:48:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51B676B0031
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:48:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1624714035A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:28 +0000 (UTC)
X-FDA: 84171636696.01.1A51791
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8803A40005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fesx/DG6";
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcFeC5ga18zDW/y4c+8+LptEu5ewghzUAe0iXgNeSNw=;
	b=Dz1jvKGZH+Gxi+QNW48s5apA4VBaXxl+X4qxrbqoUFzgcRe3qis7lbyYby70JT5UJaBLqh
	eBHFRFGacNIJfKGI4MrWnvO9jVYuRDFUjixY5fp4pP/VttQFsVI5sBy5BVBeRvYHWELJ9D
	Nj5k3uQsCthOetwcAT/NK6Srz8KyAGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611306; a=rsa-sha256;
	cv=none;
	b=VL05nvA8T3EVepnspHvEfP7/+KDlCjOGmzp1I6xS+Jpb3mCLw1eFc67BBm0dQThAedLx7f
	qgn/D2U2xQVEMTO7cVhJ7OM81DLRXpSXLTpl5g7m6iSoPpmIXPTy93dmg44eJppLMjs55m
	60nePokEfewkYBMzPvmsC+kBvMyKxS0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fesx/DG6";
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KcFeC5ga18zDW/y4c+8+LptEu5ewghzUAe0iXgNeSNw=;
	b=fesx/DG6AVEzC6zltDhCD/3Y/J8e/grHJMIyVVX0pfdeqwBDlZhlhxnuKQw0l5lIZ3iIJf
	iQU2YESt+GbR8MV/9jKEukiP4ub+0LVJLe1u8tdVoB+Tg4YlMU12N0nv4SCGqB9r5ENLiU
	PnTyIQ/dQ6ZFAhc+iuqe2Wbp4g2b7lM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-428-LPOO6yvWMW63oEqcofsNxw-1; Mon,
 01 Dec 2025 12:48:22 -0500
X-MC-Unique: LPOO6yvWMW63oEqcofsNxw-1
X-Mimecast-MFC-AGG-ID: LPOO6yvWMW63oEqcofsNxw_1764611297
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9071180122B;
	Mon,  1 Dec 2025 17:48:14 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 21AB1180047F;
	Mon,  1 Dec 2025 17:48:04 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v13 mm-new 05/16] khugepaged: introduce is_mthp_order helper
Date: Mon,  1 Dec 2025 10:46:16 -0700
Message-ID: <20251201174627.23295-6-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8803A40005
X-Stat-Signature: dryx5i9ye3gmdc1mugq1ceymwywjpugn
X-HE-Tag: 1764611306-562036
X-HE-Meta: U2FsdGVkX19XVjRKuv4CosoJ4K2GTtDW/25IBXq5u/nMUZiyMT4HLv5y+amNiyti39XrdgqFxjchLKcUvdn5ThMV0825p36WSipbGPdM+GY9nZAmqPwqRwYhO7vycNHOwZek5lqxTKWHOvXrhf115cSzJVwRDGozmt+ULFpDIjXw7+76Nb69ozKz9G9lEzYR9jIaEFAXHFPQjInhabNNMwgP58EDvQ0cENtJTRmdn40h2rnUwEovBWhzOR3qe+d/aojT78CBMvGv0ehwDXsvg1DxI7bbzkgUa5avkp9ClyJFMRrFGZT9+7fn0TqMww1qyBGLah+l90HLJ8PRpiiie9+NCzBI2Ue3FoMmLxS/zXsgCtoS6kexiAcVtVYFrowyBD5Y1Q8eY3eH4pPpmMwkfnTuv3l/iRusU6B9FDHc6dQxniPWnCrbs6sjgaAY+l//E4graKLsb25N9+4R6zHPZjRpd4eSvMyKbA0PUxKW0jtUOTKiSup8u5UbUc349ZgFnJssb6bVijS3ennojTIF1JP4aZVI65tjQojNZP3zD0Czazfxow46z8x056ZpgFrdIW/M4G9Yei5NYNLicg7thvrlCGZKnHDMC/zaDSuXwl2YxVjm4qrSebPI2vAW9iPFg5x/MsuSbskji5OeOIcgkbX8Cgkl2noRKqr3/WX4E3e8jt/EoJ8ui/Y943WzQtYJ7FCD4lTiVwXRzKSv2MOB81pmYH1PsRn5Xbq243f9IYMbfdqucEfZ1KJOGM+oHoTXNvbn6reQA08yrsgeyK5j0xgiIEXRst3vp66HyxZBIAMowntYYm7v+6F3G1Ag0ui11eWg1drtsBvd2y+QehqYV+U/rUIZN64Os+4vzLNnPmdpkkhUALSO1WguZalut1yuf9TywY9HrrbHIwa1KuHdG/Kb6jViky3ba+zfN6k/HvaYQrSCRe+jzRZQdzu9AM5Yr+20vQVRug+/Vv1o6zk
 vJPHbRXJ
 JRW//DEQ8l5yn2T1yQFp/rSnI9qSYQV1if6KZx7jUG9f7hAoKienlidpoHWHCV92losrOg16fDDWcn7LuSJPZ3UpY3lT5arDwjkWkzPpYRw+RrsM3ughiciuEF1FugIA2I4D/k4WyhpgBdAcox77iVy0ugWxp4O6ur30aXa8+cQrQMLaMBk451VS4YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to add mTHP support, we will often be checking if a given order
is a mTHP or PMD order. Lets create a simple helper function to keep the
code clean and readable.

Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8599c7fa112e..9c041141b2e3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -338,6 +338,11 @@ static bool pte_none_or_zero(pte_t pte)
 	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
 }
 
+static bool is_mthp_order(unsigned int order)
+{
+	return order != HPAGE_PMD_ORDER;
+}
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     vm_flags_t *vm_flags, int advice)
 {
@@ -1071,13 +1076,13 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
 	if (!folio) {
 		*foliop = NULL;
-		if (order == HPAGE_PMD_ORDER)
+		if (!is_mthp_order(order))
 			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
-	if (order == HPAGE_PMD_ORDER)
+	if (!is_mthp_order(order))
 		count_vm_event(THP_COLLAPSE_ALLOC);
 	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
 
-- 
2.51.1


