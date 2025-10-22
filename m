Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA48CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FD08E001A; Wed, 22 Oct 2025 14:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700CC8E0010; Wed, 22 Oct 2025 14:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7FE8E001A; Wed, 22 Oct 2025 14:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 466FB8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:39:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07141C092A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:53 +0000 (UTC)
X-FDA: 84026614266.21.B37F19E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D0A5120002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HCZuWPw1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158391; a=rsa-sha256;
	cv=none;
	b=PZ4Pn3pgaKqY469cjfIHHPePFmjJwAodLqCBglop7/isj3o8I0P9vDlOmgy/Oo4xF63WxU
	pmOB9fJsYtb//frHryLPcWskTv4vYkjSQ5jehEdEIsNYxgWSXYF8ilsw8SKdp07rgZWDzd
	AYaXxq8+4JhHHgbYtyR1WVt0JDG7ffM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HCZuWPw1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=miU7Ojt7TkpeyskilO64Jymx4rcz3OuCzt038y8TdXY=;
	b=1DVMxFzyn3Hz+0gLb39rTqKDXZnpp0WQmdQHUgkp+xpN03Hr2PxjywIWsJBAYD1U8TBPGZ
	Y9ntjH2alKfj4iCJDSfqy0gYN/2limQ04Zlyuay+PubF8CEJpzGgqdJDJHOq1tpZ+TpjLq
	gzcL6b3Sf5AgkkQKKbNFeNcvLrzJYLA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=miU7Ojt7TkpeyskilO64Jymx4rcz3OuCzt038y8TdXY=;
	b=HCZuWPw1bzaaCbZl+PQxE7UfvrIyTS9cjs+JbxmdvQRlDtfR+mWw6yiv70qntaUXYjtXU9
	2INVfEHBLHot+U+MXtl3MCTUlSwteYG+bmh0Z28ZHw8mEu7J7vkr/GXHkjsMgA4HwaEvEX
	5vEGchaEGaUmO1k1ADjYZBxXQbaWUCA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-8phah6BbMj-Acj2N5Jbo0A-1; Wed,
 22 Oct 2025 14:39:47 -0400
X-MC-Unique: 8phah6BbMj-Acj2N5Jbo0A-1
X-Mimecast-MFC-AGG-ID: 8phah6BbMj-Acj2N5Jbo0A_1761158382
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0609A1956089;
	Wed, 22 Oct 2025 18:39:42 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE46119560B6;
	Wed, 22 Oct 2025 18:39:29 +0000 (UTC)
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
Subject: [PATCH v12 mm-new 08/15] khugepaged: skip collapsing mTHP to smaller orders
Date: Wed, 22 Oct 2025 12:37:10 -0600
Message-ID: <20251022183717.70829-9-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D0A5120002
X-Stat-Signature: yaxjktbpjezisskxqs55645n9cyhn6g4
X-HE-Tag: 1761158391-332364
X-HE-Meta: U2FsdGVkX186w38E2n/LwZ+0ghUgzVoOESocnNmsJcfrrH1yhqhvPo3RxnL/H4voMottncf5yDIJwjVyHJqyfzt5nfgfSjFzpwEXvO4EOoUJrEOu4fRYBNNg/lwx5aHrSQcdb5JqmhEMr71VKFqoJYwFZijmlELGJ1SQtYOaEKNQwdVleErEaqKbd7PCleZaWvpzmeEHh+PYv4yhXGGNrkWYuvGANEHwr1v/8REU/giTimO4aZ4/yLpkfu51boegyODBICLXOWzVI0Z3t/3+xrofVKFIu1IT7rB2Xj9+X+ZzU/SwwJV6zoj0sewQXEQDc58ybfndoLGf+i+8d0kirqL7NzAnE7sBuopxIUWd92SqZSRI1DY1VQJTLpVj/jKgobPJpjuSMm5kSBBXTX5Z2sCJnhcC5t+Qgu3ilJRI8nMko898joWwPL9Dz8Sy7K0rpfU4VKVDiQBQx+aTkXPK+6K6vB3ndadUsR4XQ/FrVbef00deA7lfxJ/DbNufzTs0FAknxluG4ONNswadK2napX+QezpIYXq28PglRp7urRnlDRK6PHmnbI7oWLH+Wr3T8WkK2TBdOlWrgy1MAK5HEF8R0r6KpYHOG2ruSY80rBeE6MhYiBkO/d2etg3Htt6U0XiI2uDOzErRkWdNqabHvVNbzAJYo8gg7hocdl7bHCd5vuSUIsVs8SAGMO+RK0kO220Tapz8z4J9/C3447sBjqephFpIPSid2c90JaJMEb81JI1KehzR5/SkdtN51aiF60egoJgYu7y2VzISTAFSSEX2t/zOAyrpv81AD+mYp7zJhye5wfch19pjMN8TH6EYZqpZqfAJPdNskpGggUzDnmNLsTefX03BzY1NlBVIJoPOd5HaV299wZa4O0M91E4Kp67j4DU8OayEIa1hme4qV3oPRiJiMfn5Twg4bGf7VdkTnF242vZyScCieXM2q5XocRigURAlTuJ2r7ckGYf
 wAzYuKKX
 xbquzOJqARwGsaEB33te/1iCMQGqLYLp5WNCrFigFnHVk9f9+AISVNRxPAgZbHPBv5u8oOmdqq3wP9t5a8VGb70aLXYhwKs/8OnMXN8kUqXkM0VE6yNXtoQ1NcYssVDOBU9efASnKQOx+UDlokGg0rtFi3P5nxqIFdTwFvUgAfg/JSDy0bLDfBNx8HR0UOARCsvdd7U1i/2/q0SRFaIpkZdM+HC/SnOH587PTR9ZWVPdRp6GpbMc9XHNMY/8JV1QSnQq1qheZj8FY0FY42RB6vU6fa0uNChdtFPEjsuN3uovMPYHY5MSsAJWIcGFXsgIFNve/LdC283e+6CRQkkN9cOCawG7UVEQ+igYCdvFHknLGVAmJFXbdaZKwRF9+RA1ygH3KC7CSzB/xfxN5yPT6yD3t1ajwj/L38Vq3F6S0lZyjVRHK0sDJ2ewkyUGCDjTl7fQv/LiUVwdz/Xn2ow9barooM62phrI2dUDeJWvm+x2pXP94aP/kpn0lMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
some pages being unmapped. Skip these cases until we have a way to check
if its ok to collapse to a smaller mTHP size (like in the case of a
partially mapped folio).

This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].

[1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75e7ebdccc36..d741af15e18c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -629,6 +629,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				goto out;
 			}
 		}
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (order != HPAGE_PMD_ORDER && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
-- 
2.51.0


