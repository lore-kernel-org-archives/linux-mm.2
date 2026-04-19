Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB717EA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 19:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFFD6B00B1; Sun, 19 Apr 2026 15:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7DA6B00C8; Sun, 19 Apr 2026 15:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD826B0113; Sun, 19 Apr 2026 15:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7B26B00B1
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:00:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6580E5178
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:00:34 +0000 (UTC)
X-FDA: 84676221588.08.6C71F4B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0ADC180010
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:00:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I+KcFfge;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gbD4f/RO2mWPwJriUyvKl0G7J4huajbSVgy4DAT/PQ=;
	b=tM2AnfPNTZZEXpY6uDWg/gNswBPLVUaPR8Zs7t0or1mXuAJkVQLOXKqq7a9dccu5+VuV3R
	n38I9SqDDnNzl/ttK0oszVdwc5U64hfZ5jS2TblaK+vsZEQtvVpvAusN9KNPx+7sIdJAxb
	oikuCSk/gx6Sm9fxHqZVfsiVoR/wHqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625232; a=rsa-sha256;
	cv=none;
	b=j+9/9176tEshkKNmU9fSAItYsdJei/zUshH/v3D9WQjBiniCxewrZ/i23GrJZxnkwa4tHo
	8Hu5p8xny1cJipUyB+YPjP5q0mLzcfKXqeBbmbRXHAaMimBYGzFj+xg+EsQElmAR8vTQ7G
	s3A/oVZxVTBVakEdcLb2SjOvJ9gzzKY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I+KcFfge;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0gbD4f/RO2mWPwJriUyvKl0G7J4huajbSVgy4DAT/PQ=;
	b=I+KcFfgetOudcDZ+DKKekMe2yHaL1YBDtiNK3e9hVWMEZ9pk5328+G+VpWTwm9mbCQ8CPb
	OxWV3RNJJCr5OAVErSG+BpK2uzX8LRYRHdI2a5xXeXiZsIOdigFQbXgQ1NrbYfVpCz8Zjk
	W7kHKp97U0+0jFYoqnzKfItDW2GeWOQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-Obb5KE0ONWCtfDoqPE1u6Q-1; Sun,
 19 Apr 2026 15:00:30 -0400
X-MC-Unique: Obb5KE0ONWCtfDoqPE1u6Q-1
X-Mimecast-MFC-AGG-ID: Obb5KE0ONWCtfDoqPE1u6Q_1776625224
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6ED1F18003FC;
	Sun, 19 Apr 2026 19:00:24 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E2C5195608E;
	Sun, 19 Apr 2026 19:00:08 +0000 (UTC)
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
	Liam.Howlett@oracle.com,
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
	zokeefe@google.com
Subject: [PATCH 7.2 v16 06/13] mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Sun, 19 Apr 2026 12:57:43 -0600
Message-ID: <20260419185750.260784-7-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rQAW0W2hoyqIKQJ05NQyWrAQ4WZ4cYt_PDMjlg4zXvA_1776625224
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: B0ADC180010
X-Rspamd-Server: rspam07
X-Stat-Signature: jy8jicustpoegf7pa1r5yjg6jm3p5qwn
X-Rspam-User: 
X-HE-Tag: 1776625232-773154
X-HE-Meta: U2FsdGVkX19cU8Aidwf8AwHUOleiY5hswvn9kprJJzxYTNnF5bOYGqRKzvFDe3igim5HbuDVEeCH21dUDw4sezfliBVk1nQ7NgtfOCQ10OGVUh3jDX12W/FpLkAvQi6XyIphhoDPvhE9nnEJl585GkX/cUdLlNxx37iQbdAn1Eyjz35q5DLh7VYAJ2kkn9gKpAxaJaXB6RDJuSSyLUcYjzMrqOPszgJbaQ2azHSqxYDzPcTNz5yoCf6FyLrRkDOjnpT3snMjqrmWWaaOWDoI7KiHGdQ0IjVjgenqzHZ1zON7OHkK2JIuUiexQCsy9gxHblPs8Y/KeFi3YY4Vkzzfly6wYqwPTB1FmkRHqNFQHqbJXD5h+tZCgw/NrZFh2mZpZ/9RfkIZ4AoxeIX9J0dNxh1cjMlYe4LY3HJnWZ1v0zBoKoDKNFw8kaTM4myO/mSOjXSf57N6fhynlXljWMbTxZBySN/sG8V/C3VwXOQ+HMb+cBVwAD3XG1ZQ529DYoP5Aj9WOo6R3nEjLB1NsbfayZziK7D/BosOlmHkVojc/ZREboSE9gx1o+5h3qCCU9683TXPYlZvCcufCiy3n5gaR8gqTszLRHxg8Wp1tQ1hUfrTG/eJCUpEDYapm0wzBVR6oO0uR8yIyRIYFyRD1Y00c3Rkt81oMuvivrHGk9Wr/AZsCZk9C4oCUqhuhSWKVTcUErrN+qZ8MK8DIfzbKWWkfWLKBXryAjOs7DfbKKZ5EXnjxV3LgTCl28GIN0kBSbbg2cLC+GnGcMVZVRIPhiwS5Z4ujAf9rCngfddiXFH5jEil8tFyUz9+8hosCHeksaAms/SC2FAvivt+04+6SdHr7ddwvo89AIHO0rwbJYsyU9LZO2ogsJTeh6Ok0wKDeTQTJfNcajg+t6ZdEUySg6OKW3u7Vw0LMhCD8MkrSx/g/LOV5zG6gv92k+mF9QuAbaGGZBjEUQ8xDIEN7uIkpBd
 ubFBLIrH
 bElIbtkSTnaba+/Sm5bOVPkGZ1kcxYzyHTMfRVYCQHFa+HKxxApdBZ24JkuVRLwj1UhRqlKHMsNdOuR/LfbStGrNtCKNhf1acy9dK7MvrulRerPJlue3YUhYMYg197FM4ilxJFkYzPOJsp5gPYnouCPi52CZvksVmVZ4z3fqM+nGnufe7iKBjKmKosIm27FURZ+sGiUxRL112Uy1VW/0t8pECQgZeUfsUzgs/jEX4TDoiKjG9JoPSYrJyD5RWrBQy8JEFcRIq50qsksgoI7G6/3/u4g4xB+22E1T6osUaDxRce05HTne94qJWd5N1NgSyux9MobRZ/ToiOG7vADYhOpn+szlwbsUAdTHTiDjnQXRPLKGzc/aLwaGmY46uToUYPx80KcnoX8nIVZQ2bsNbEk8/opGGBYgT4p65XnFnuuGKeErHzrKBFq8QGjx1d74SpzOCY+N0rrazD+5W91N8bwCJ8WqAikWK41TgGpKaU3w6be7xLO0m51UhjNaQA/8o6ov5gQK2sxfrK6c=
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
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ff6f9f1883ed..8740d379882e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -686,6 +686,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
2.53.0


