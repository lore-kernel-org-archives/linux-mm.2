Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8904ACD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F036B00AD; Fri, 22 May 2026 11:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5F16B00AF; Fri, 22 May 2026 11:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BDD6B00B0; Fri, 22 May 2026 11:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFB346B00AD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:02:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E02092D72
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:21 +0000 (UTC)
X-FDA: 84795371682.18.93EC670
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8106840019
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UZSaguG5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXpkzFJPVwu6ZwMUb9lwa/5anK7BLreCEKOt0QZiysg=;
	b=YAEVSczRdIZoDnT1mXeQpTEvglA6hUDqjoJzyarJB43qSBXkYooF/R7z+w5WTwjwF0vGoS
	Yd2jRO031JaZm31ScQqwi76O0v/UzsgpqYT1kr0i2BjEA7ukGqTJj9b8zs0DyjxTNcI1aV
	N4ePWhxinAbKi2CZriX/VX+Fr9LE/fk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UZSaguG5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462139; a=rsa-sha256;
	cv=none;
	b=S19z/RfxX9PUNBsXA6rz5jJB3ePFfwamXxTWk/Frar6yfsY50c+sNP8o/P7WwJ2iQVbihl
	X2hfdG29YEJsNcyr8/sgrLuasnBYpwVbSGYUVJw/iQ6SOtdwS/TlhGSQIgh4h4bzWLsQhX
	8jRh1UCrPR/RCJKFjc9oV/RAcr226+I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bXpkzFJPVwu6ZwMUb9lwa/5anK7BLreCEKOt0QZiysg=;
	b=UZSaguG5BT1LEtWmX05KltvIelrDhKkL9pZbTwco1tUA3KsDTpsWt2iVwrOhJ+sHVwkIiU
	LR8RGOa5lbxEkefDCb9nsVdvWkqiVchKy27p+8D6n2AOf1PgHp4JevbHW/To8IS3Bno8/3
	aCdiNUbYUPtnK32bTDFxJeqkrTLWk1Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-onhu5v7FMKq8Di_1WfDacA-1; Fri,
 22 May 2026 11:02:14 -0400
X-MC-Unique: onhu5v7FMKq8Di_1WfDacA-1
X-Mimecast-MFC-AGG-ID: onhu5v7FMKq8Di_1WfDacA_1779462129
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BF981956096;
	Fri, 22 May 2026 15:02:08 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5062E1800591;
	Fri, 22 May 2026 15:01:49 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v18 07/14] mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Fri, 22 May 2026 09:00:02 -0600
Message-ID: <20260522150009.121603-8-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p_mIp268hsjCv2tV3EueJLyUD63bf0ny5GU_Lx_8ecc_1779462129
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8106840019
X-Stat-Signature: jiqjdkyrt5wnd3exm1ac8n5yjwp1jtsd
X-Rspam-User: 
X-HE-Tag: 1779462139-405830
X-HE-Meta: U2FsdGVkX1/i1adZmsPW4yATAB0X1y5/2EyJ14dZ27MBo0h0+qXVvddt1M6mORu/RrYOVtP/Ygem9DCJL1W/VVzrFlTzaN3REzGTx8kya801Ls6gv8yt7BjbtNiIwwyhv/4irzEQhKCP3zYKrTrMd8U9nXGKlN1CPgoNabLF4CoytA6VFZRl49ZgpcLsifhJitz2b5rQ4qDBDm9Hx5fYYpUdm0xoTNSq3vkTevL1jatCd4+oHg7K4HD1xRm5X/RyH1g+b/BCpMEl1DZdf2jE9hZPO00VG5nFLQtqT9BMizvEHHFu3OFFhfSY3wOEbTggnBafDe1OhHiEaZHOsVjKGER7qzQPY7OMbF/+xyhKJHXNSo6W1/QvxMAkWadeSlyjIE+GWOxMEnDDcaDncv8DUcoL3SKuN6XibdG0q25i3ECJJJkN97aMY6cZibvAAMgfd/KGJx0mmtxO+LVFRnegYKjPViVt5CERTm/d9LQCQ1Zbo1SgGTqXoGzAm1FcX5zCFXhm0iK6AB9nKH3F3TQcmBr6SB5swi3CdUzI818E7/LpPwcS6Ko9c+l2bom9t6Fl3BrQY3qhg+ayQUFKhi9puQl/96ZVcfyW5sVEq2nl5hFwhki3D/5zAcMibF7LPiGD5TMwJMzOCZUrCRxAzzP26CLmFZav+twZXrgvUFhyyCUjTXUj2WdgD0uZQLlag/5+XQuH05hdcux1bAinnBpKqMjQ+DF/4ZUe0N+lk5CXD8yFfKfoNKYIig9RFmK/eAihYh3b0ZSx9tyyPvOgSwaUf6kqHCvQnraBXFxnCVnNsi67aWB4VrJGho4fDyhGIZP7cA05KzWdcthOZPigGzURF58d/R4c3HcOC2nQT+OTSET5OwzmM7kXZj8px2397EYxCZV0mz6zUDRwpVJ4VQibgjobD4EScf4tz65NPjLFxvbMkV6Y1PEVB39HxItcWoIbdZwqSwXst8k6YN5tQR7
 TFdL6YPE
 kgyi3ckE1HzzBhDVKMRHoJH7qcpOH9p/Y2d85zWxgBkkIHZPtC71fOd8JMDhjTuTvAYUoj3YiC8nIlvSX1SeA0/YEnxeG+ZbdqFb6WYx0pZB/anke7cyM7fXM+xO06akysii7aOPQdVYGXw+0stYm6+oyWqfFy2lweaz/prhMiNxq5ky51PSCNeQYZqPWnNQk1OhiWrLVfW9ocWcp55zfCI5RuMe0A070sNBpSOErQUKdtU1qK6mZ2PePx7Ubf605OuMzxwlrM5FhcDCdzbZkMGlg45OOYHnfd80P5YJjvVY2b2ASxIk/BcjInVTs0yVQ7P4+gKlCONgg5D8AiOlqBE95CudycogL0Yj8sS2C19cJcuxkIb5uR2QFB9ik6brvLuGPtNuwfviIJtnx1cCWKRHVJ7tROZ2FHIsx9h7ZQgFr04GKuWqlUyG1xpbR8GcsvaZFmRfOX5gF/R5fszpaebENV3gn1PocN4RJdARc2Hd+h0xN0MzfhMSW3E7plrrH9XVJslZb/3LULis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
some pages being unmapped. Skip these cases until we have a way to check
if its ok to collapse to a smaller mTHP size (like in the case of a
partially mapped folio). This check is also not done during the scan phase
as the current collapse order is unknown at that time.

This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].

[1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d64f42f66236..928e32a0d4d7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -689,6 +689,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				goto out;
 			}
 		}
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (!is_pmd_order(order) && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
-- 
2.54.0


