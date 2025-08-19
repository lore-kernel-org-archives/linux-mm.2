Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B945CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B23D8E0046; Tue, 19 Aug 2025 09:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062A38E0007; Tue, 19 Aug 2025 09:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94628E0046; Tue, 19 Aug 2025 09:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D623D8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:45:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A659ABB25D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:45:22 +0000 (UTC)
X-FDA: 83793628884.29.392BAAC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id CEE0618000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:45:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D7DvX1RW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QiOibDnmxU0r/BF2aR9AwgLrcohp+xyaMN8bjnYCcI=;
	b=yaw8nzAkdH2NT0TCxadk7Tjrz8r+yfRJxa9y7px6Th2A8NKOIkqR995AEc8pSQAnwyj/GI
	0/poeA7e6b0IPJ+o9iBFLa0oUNu7WueBS49TiZ3P3Hpi3Fhk7LdJ3hg4rpgIg8gCij7Wkd
	9HVXLGoA4uXwheiPt67ave3TU+JFy38=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D7DvX1RW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611120; a=rsa-sha256;
	cv=none;
	b=nkxp0Jdhug1XkePJXd0HyEKtuW16RNACHI7gNIsxsYOaJ21MXhyp6Wxe4F4nUCkfQXr5rL
	DYe78fIhBDO/noad2PpovvvBfY3jv4CW0NrWK70XA59thfuWvzXMG164gg6nWllei8kuUc
	v0+yTaQiZxQ5MED9JHTz9fBM26zYV8U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9QiOibDnmxU0r/BF2aR9AwgLrcohp+xyaMN8bjnYCcI=;
	b=D7DvX1RWhrivVsDId9TcIDOG+1U1I7eA98yRbxmkhLDTVxaBZNPnM/b6u4EJfGpBfL2JKL
	wvuQn8RgCCIk1BmrWCQN7G6nGgWd55PiryzoXq3HpzbYl8eqnlw10rkm4NBv39KQjy01XD
	qMA/QnzofVrv3f/S7NECJbTb1G8XMDk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-JMbLXzPAN8e6Zz9iKHx7DA-1; Tue,
 19 Aug 2025 09:45:16 -0400
X-MC-Unique: JMbLXzPAN8e6Zz9iKHx7DA-1
X-Mimecast-MFC-AGG-ID: JMbLXzPAN8e6Zz9iKHx7DA_1755611109
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6015D180034A;
	Tue, 19 Aug 2025 13:45:08 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF37F19560AB;
	Tue, 19 Aug 2025 13:44:50 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
	kirill.shutemov@linux.intel.com,
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
	hughd@google.com
Subject: [PATCH v10 07/13] khugepaged: skip collapsing mTHP to smaller orders
Date: Tue, 19 Aug 2025 07:41:59 -0600
Message-ID: <20250819134205.622806-8-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CEE0618000A
X-Stat-Signature: u5qbm5hqoydsj913tg5xci8hoqfiuzos
X-Rspam-User: 
X-HE-Tag: 1755611120-684181
X-HE-Meta: U2FsdGVkX18Q6gx7UCPE6Ga1PBBu/Rh7KHWxumWauTheO9B+/3qnRo+c13gJpACjlsNFC3MhDQRLZTX3FVcICvw/XUN1SHyT3uIOGJ8uajYkPJ9A9l84WtIoPKqfxqUwOMI0REtk/EhyoZjHbQFtFb/FFXc6SwQG3Cewv8fheKOPw2XgI7Hg8mo8Mz7LtGUjLMDnqxxYlaQvFEiBNExrtFJ1id/QDStOP+EfoZkObA+f/9G3WXE1sNlIc8Aettxx4JuX1s5ZMLdD4FllrlNwX+6jMBQQXLQfSvDX6NVUZBY2uEJQdzjlhIbwsk4pqDorRxFEVgJKi961f101Aq76tPSKW8W4yrCtzuRWxIsXTvD4g5G6rGDRtFrm+vYqc1L2fsHNsob5flv7gkrXH0KNJbKL4zq1r1yD33s1vVZNBz4hX6erUqxs8vpkFi1J23swl5F7d5clgDdTT92rfGeyXJORo5/OzvaTnm67o2BSuNYiKj0Ip81fmKUo2L/0oDene7lVeUBvNoi3rD/a0mB1ZymOXzUbUWdxbAK+YixItSOeAmgm1n4EZU93zSxZ+dm6G2f5i3d/IXpW1mzT1PLc4t1NJnKsUtWUbx6F9ihtzUAa6fnczzHh6pvDzasKe1EMLRniuOYVQY1NYPWm920lgO/NNS3DiVVeqaE3Ar5gDJDV/LV1UqZihkpszVb/uX0bngCNTSvibrtgMDcOafnuR1wAkWou0M6HvzMs4YWwgTHBlxLxTCy2C6LmVp23Qobr0Rz/VAQtWT+SQishHgHJQqb4u97TftNKcEFIfE9xcn64CPqbqasJhbzTDcKB4B+WZvwAJiB5DmPgWG3sQpgeQZv5pkPISReMfAVCKQThgZIgrcerkWYC7ttxss4LxRCjkT/hI/DkY9aR3Ejdwn3bQQCjd6VonMUumOKlGovp4CIXX7+93gH+guJjvv+6aLozbQYZ85GLZK5LqjYEavy
 dilTTs7Q
 IlaSyvU/3TDidmCnstfHBDQCr5OoEY5clOpqLRVWOLj+Geyv7dWp5BiDFsI7XFRdWNeEJk+dwqRRLDz5H9urjOOZgYdhnn09/U7aqodCZZg/6YFLjvzODvv8w5JX4RfDgw8hLRcAv7Fg6z893DTEAKj/9FsT6aSwx4Jjez02U18JSn7KxRN44ap34JMD/XBebjtYJkka1tBP8veb8Bk6WnqfIEHcFp1Fv+xE53/DS7YBQJSuTiknjpb24Dlpv23L15/CoHJPKWLpXX+gaLK0DcyQT0uplowVRdrkZEIRUgBGDnwZ6ctWXQ2yGvXt4Lxaxpme0+EKTlknV/LcXBrpI5P0Rdzq5Er4gngOPQCnSvBKbb64XKbqSrBUiFWZY1eTGOQyx12ta0zwPa5eqz6q2HiaQPTHw6JQnmKyuOhTFsWyAbmnqjC8h85Vno5U9/9BKSEE/1xFEeDAtQFlal6Or702DxgdwSL4PhpHP1BkVQV8PFqpSyeMQTiNck2JFegpQ9/Su
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

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1ad7e00d3fd6..6a4cf7e4a7cc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -611,6 +611,15 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (order != HPAGE_PMD_ORDER && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
+
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
-- 
2.50.1


