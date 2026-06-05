Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF066CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9B36B00AC; Fri,  5 Jun 2026 12:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A506B00AE; Fri,  5 Jun 2026 12:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362416B00AF; Fri,  5 Jun 2026 12:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20FD26B00AC
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:17:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC7641A01E3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:17:40 +0000 (UTC)
X-FDA: 84846364680.06.EA65582
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFAC0A000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:17:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=THQlvgDe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=duJTZJog/IvaQNcYHxOllCKMt0JMc5PBsQeEuw3a1uk=;
	b=MyeP3bRwqNt4R9bR69CHj7I6bOZIOPkwB90jgi9omXV3Xr5KpQRQ83cjB3EB4wr61cXhNg
	HmdpO/A5HUB7Uvpp9fw07/Pg5ZQ6iIA7iKZ0UvT8vwjPqooLtwdpV4yOiukKZ5taBS6gCc
	w0rcqOcMOyihXmkuLhGWTfNl08TgZH4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=THQlvgDe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676259;
	b=W8swe7tEHFKterbPc9YMUbFufdGD+P7M7/415X0bgPixEfQjRzH6eCBrp0+Dv9LB+vjm/E
	9GLAQCLeEM6oIaLq45WWVm/VmiFH5zcd92/sWW9fQ3+pHDxkO1BbFvEfugznbtFMx0SRJz
	e2MEMW9owtQMx6KMtrh24ued4p6iNoA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=duJTZJog/IvaQNcYHxOllCKMt0JMc5PBsQeEuw3a1uk=;
	b=THQlvgDe3y5D6VFbfsEtMof8zK86dlqaxTSbID3mV425aDYhWhgX8vlwvJf//ukat4osZY
	deyS+NAS3nQkMi5YBoIOp8vkzRZKJ826LLFqxsctMOvaCqdpvXfH2Vx6+SuJJ3w/ZueqP9
	+3+gm1zQz+o3Ms3DKv66Wlrj9oEdxNk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-30-r2y2APjoNHm0hIHVBdBPqw-1; Fri,
 05 Jun 2026 12:17:35 -0400
X-MC-Unique: r2y2APjoNHm0hIHVBdBPqw-1
X-Mimecast-MFC-AGG-ID: r2y2APjoNHm0hIHVBdBPqw_1780676250
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F40CA19560B6;
	Fri,  5 Jun 2026 16:17:29 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 36F2D1800351;
	Fri,  5 Jun 2026 16:17:11 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 12/14] mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Fri,  5 Jun 2026 10:14:19 -0600
Message-ID: <20260605161422.213817-13-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s9dzvN7u_i38OwUdEwoYAvvzPjMfjH-vK4-Nbq5Jg0s_1780676250
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFAC0A000C
X-Stat-Signature: gp85rksy5o8us51n4h8knb3p3fc9p6sr
X-HE-Tag: 1780676258-384962
X-HE-Meta: U2FsdGVkX18FouV14xAuNMsMwERHzPd68lMCh6I/O1Anckqn+FTufFOACXhbCCGH9XdOckg2HokxVtUICxVi//UmO8aP17eB0YHixquDhsvshH9Qxkthw+IgVaOsdgws/kTs74DPW+lQ+EmfC61cWJCRPia7TYf6HEvMq7Mcrax2lYuHLO1/7FhEothon8K3LdtXVgWAyCS+86zWQk9/R0QBz1KhCr7YBvXzAox50gPT2+YI0PUKnQ0qfKMPTij5RklWAUOnhHRV/10OnBjD9bktTZbaCDddhb3ncZ6aiRgAGwM2qneWFwc8CUBe4P5ailLH7vrSdElTyespj1Fk5kpZvcGx/KkYwtYj3BP00+qGBLlSTvbRksDuN/R40wkiZqpW6Hoxt3ku3gq7rsLaJbO2YIhKgemYS84073ofTiLr7HeG9aoGggi5bXp3hzaoq/dWwm/oc0VCX98yxAYgrR9tqY1YwciRduOk2S2MlhzujBWS24Xkg3U6k4jywxxrKA26KsNjXMGvcVAaaPAnLCawEvhn4qyJiu4pAKnZkQJwNbHE4NdygcsOvQI3tk9kFrH/N/CZ2jgL1zPBHVeWHyMgXY1vAo84BEYlJx4CMUeq+rrL8LurhyIZAMQruga9hwwBiVtdfO3XiANkXcWXBHIYCZVHMrIhxtsK3kAMummfCgw4IElsd6gdPhjdE8BhfgABz8fP3By1Zd73DINS+UTH86r9xwzYnMj9cnuo0IDEqnDSpiJXJEhrAQM2SxFfCSZryW/h0T80InQyYsNuC8IYuHWVCypgj59LIYDtD16e/wXbumtWWti4ZLqLnTmO6hG4PA62mOzjp0pAi125PuC+3cSUgINYP8XB21kzqvTBuV3dAxlUT+VrGyrQ38gIHxszzBJlJ9lMP8cCCjUGTc7RgFXD40H2Q1mfk7HfNnWbU7r9TuLlw9CZRzVVDFP1o9pxom9TperdNeRKavk
 S0UbhlNu
 S1XxdKKEhMCR4n0gzUt+6j8qM9lcUPus3fseZ2GSCEBP8cND2d/QS+I8iGzC4EeHkUUfrSWzTZN1uhIVzjZOFB2Ud5eRaXXXhAjIKT9RA16SFTIe8OQ3GofFu7UypHJuXdNWnldgCtvS2N7xQvqgqYBclbvnkqYTSEGwJSCRqb+4baBPUP6s9TIhqWXZuRZABHFcOF1iqAvLB6M3u9LWuSLltal9AeeRONIFdIyhYST9DmByfmyr8WHN2NSpxAHBaPOR5iwxvrBqCewbI/U21hbG8cHSsp9OMp26is7RXRKkU1rS/GPzeUgTQFPaf+xbONJlc2tm4Bd3YkItFx/lgEvjcuBpYJ/jT3F6tQj0djhFNVJqEzTYcz/BH5dbpyTIQvDXzCNjnd29OVu3hfWfLUGcnApx7TXuDgImZC3HknZNgfnw19KWrJhzIjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail. Avoid these collapse attempts by
bailing out early.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 430047316f43..7de92b28dd30 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1499,6 +1499,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, order);
+
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
 			case SCAN_SUCCEED:
@@ -1509,6 +1510,18 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 			/* Cases where lower orders might still succeed */
 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
 				alloc_failed = true;
+				fallthrough;
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_PAGE_LAZYFREE:
 				last_result = ret;
 				goto next_order;
 			/* Cases where no further collapse is possible */
-- 
2.54.0


