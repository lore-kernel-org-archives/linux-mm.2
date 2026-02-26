Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA68FD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB5E6B009F; Wed, 25 Feb 2026 22:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0456B00A0; Wed, 25 Feb 2026 22:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AEBE6B00A1; Wed, 25 Feb 2026 22:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED0576B009F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:26:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DC5B1CAAE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:26:56 +0000 (UTC)
X-FDA: 84485171232.18.EE34895
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B329180007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:26:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OgEA3j36;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRNhIj3khK8Eq5Pf2FybxlrtWBkMrkCw8A4IePI94rs=;
	b=lXIHuTyt/gW3FZ/y9oeDeHcsDFB2QxkNIBxkdIyRS/8gMgnrK4XsdAztiAK0dI52BtF/mG
	v3ikvajguJXitx9yShaWBzbDJuvWv0+Lax7nMh0WcRjxAtAp9RpRIbURvCWpHmAZ21LOJt
	74EQg7TPDRl3kn2FEN/DZKxWbWaq0m0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076414; a=rsa-sha256;
	cv=none;
	b=h9j2S+MGz2WyTIVGPbNh4RGo/FePrASLw/RtW1kUO1Q2VpIwdOSfMQ3RcQMkRA1Y8PnyQL
	31bZJ1tlq2lsm74Z28/I5HwkhsV102qwlKKT91suFaL3l5r+l3ZczOaNRuCTsYtWXu3q0I
	YM9MMSQd6VdtEFe6rOXuLKQ/+0AUlRk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OgEA3j36;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aRNhIj3khK8Eq5Pf2FybxlrtWBkMrkCw8A4IePI94rs=;
	b=OgEA3j36HNq5+TmZBngvcIJtFxDrJeGiZbqI4vfbZ3pob6h4hLNO41oxKj/efAOQeZEk6b
	RzlNgvM28Ipmo2zIX79a1+lhy1ORXRsSzQwWNyXaee/Vl5yKupHz5/yBQDoWfESLQ3ee9B
	gp3+04S6JzPVTXK9+4gayAxBAYGf7q8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-iIZIvBozMqWPlXR_3P2wYA-1; Wed,
 25 Feb 2026 22:26:49 -0500
X-MC-Unique: iIZIvBozMqWPlXR_3P2wYA-1
X-Mimecast-MFC-AGG-ID: iIZIvBozMqWPlXR_3P2wYA_1772076404
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2ACF1800342;
	Thu, 26 Feb 2026 03:26:43 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8105B19560B6;
	Thu, 26 Feb 2026 03:26:34 +0000 (UTC)
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
	lorenzo.stoakes@oracle.com,
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
Subject: [PATCH mm-unstable v15 11/13] mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Wed, 25 Feb 2026 20:26:31 -0700
Message-ID: <20260226032631.234234-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j8GvNSYa4ExzfcwTenoaZTxMXGjby0ndBu4o6iizeEg_1772076404
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 9B329180007
X-Stat-Signature: 1e7fkodmoe184k5nfoo3e197tg6qoehq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772076414-917340
X-HE-Meta: U2FsdGVkX18xvyVNlJboAhZGIOtJUM/QQOeKrqFDVlDrj7gXFr2RuM+s35Xjs72sMfBhdSl3LT7a9p6jsuT0WJDXYs0o+Jk0LUr2yjDztcYX3J2gF6X3wdajwPgaRseGj9MzPFF6svtVtTKsa8d2865jQoMqSDNjms1o5TLnLwaz4R8eQAY0h4UC0VyaDIcxYYfI+q3YxWA14WO/psoKa6riVLHvlWhXEUYyPmhV4NMr9FetuLY5UG/6/X4ePfO/9Dz88wCmUptIE/azoy7Y0sw1hLLBzLlQtWhvmbNS8M6/Ycci9C/PjNZoghVcoB5AbHTpin1FY/Age+jtpRdFbq2zISXEXGyx363msSTA4XA37775+JMj4WUd6Ec/AukdvOv7jRwQBPLini+U8P2IuhM4LLEBfLf+vKd9aX2xbn5tsY/MlDFLNisW8MbDqGFBGKrCl6APiMzGSmc82dtujD0icH2yYBSp/bceyXSsR+abpuqwPUbw5DqJ5jfxQmfjUmjLZIJlC6gXpaL6hDh4JSai2iWcjT5M0FPXyl9oTrya69tWvyivLgV4sbrt5Oug9VHniLdGwdYRmOPdCdY0vq4BIRpgZD3mawUE85hn/agD138YbZw3/L4VGhYSom1Phfw3rBIGs4NPvPuBr8R2t1G1gXFZFxr87lPv1w1+hl6EucScGqtCfVizgzeuDotZOoFKPg++B9WtdK9PohzUL7/5whEIrX45u7mwdrEo1eISQu0lZRmaZ+uPX55Xwm31ENd/AIkwID8LtdDtsd8RUrWCqKOq1Gwvz9XRmJhWM2i/xBDDlVt5Ol5vBS1EMrJUPL4qiOYl352awDE6vHedVhenXo/bAgOzK2d3aqWtKv0PqwqduQypVLzjLT5IB759dm+WTvksE+826VT9sBsL2ZcmSwr3M3LOLK4AtBoKbdSSGK/rVoUKFMGr+jqesTpS6fI6M1K0p/9So2DSgGk
 YB4uC/4M
 RWBY+R8uZSyxB4KAgZn60hc97Yn0XIPkd+8qetdXDnb6juxI05dsdmh0O//9zNDBmxFTMsgAWt7UNRcQBzgqyUezWjWnw0TxCVFzIvEJfsuwR8HhTjqgWjUzRFo2j/jpmwgsjqGLg56IhcRuBWKJO6gSLsh6vW0llayTPcwJ4zYS8bFlZEfBfFInhnlDdtDJlwAVWsypFwIyS68GTnoduLQ/4/IsymQ4AOU3oeeKNHW1OzAETvtGROZUiCPjcgXx+lUoUHJgEJj4N1tWDQyDb67Q2XwFpLikJCk03auFTlVyddZNWKvvPb1Lb3Tb62TIZ6rjL/Ni9+W90ZaOpUrRqy9FW0sG7LAAmPRWMUSko6t+r7pGSYhXMx91BNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail. Avoid these collapse attempts by
bailing out early.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1c3711ed4513..388d3f2537e2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1492,9 +1492,42 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, mmap_locked,
 						 order);
-			if (ret == SCAN_SUCCEED) {
+
+			switch (ret) {
+			/* Cases were we continue to next collapse candidate */
+			case SCAN_SUCCEED:
 				collapsed += nr_pte_entries;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases were lower orders might still succeed */
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_LRU:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+				goto next_order;
+			/* Cases were no further collapse is possible */
+			case SCAN_CGROUP_CHARGE_FAIL:
+			case SCAN_COPY_MC:
+			case SCAN_ADDRESS_RANGE:
+			case SCAN_NO_PTE_TABLE:
+			case SCAN_ANY_PROCESS:
+			case SCAN_VMA_NULL:
+			case SCAN_VMA_CHECK:
+			case SCAN_SCAN_ABORT:
+			case SCAN_PAGE_ANON:
+			case SCAN_PMD_MAPPED:
+			case SCAN_FAIL:
+			default:
+				return collapsed;
 			}
 		}
 
-- 
2.53.0


