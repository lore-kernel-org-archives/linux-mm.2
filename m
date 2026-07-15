Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0ABC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8A86B00AB; Tue, 14 Jul 2026 23:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4126B00AD; Tue, 14 Jul 2026 23:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7616B00AE; Tue, 14 Jul 2026 23:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 871A86B00AB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:19:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D834CC0539
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:01:20 +0000 (UTC)
X-FDA: 84989509920.25.5521CC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id E4AF8180003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:01:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F+9QDEO0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784084479;
	b=wfRZZnpiNDDWXMSFOSH7hlkmQfY781iTCpg+SgIZOHrsyTZtkel99LaALSiBPU5EBYqeAK
	Bhds8R2+7sdPeWWAuntQdpR5TJbMowFnW5KmpZyXzYw0m9deg/cLY67QYB8V2qX2WzfI+b
	C0XEh3h15gE+5HGoof7UnwXc/AZmbk8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F+9QDEO0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784084479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkmNJj3p+KyDaYOMlbC6g4u6+fH9bsqVff+cIbv9v0Q=;
	b=LzsN0l4pAs9ItQB6cWWycLBeKyw5B+Jyx1CvM58C3oocM0GgXNCxsaPRaklbFLwdMIXndH
	2PEEDywaZSQ6HxanILJDdbFNYtyZG+0E6HyTSYDCYv7X5+5Yyy0b527CRIvzRL53VqZQBr
	F4M/Acg4N6MHUKr8dsHZ67Q1VipAmEU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784084478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rkmNJj3p+KyDaYOMlbC6g4u6+fH9bsqVff+cIbv9v0Q=;
	b=F+9QDEO0j6T6gkWRpq8cAJukdGbIkUD66UsfYLhTl5C10ZZWhUMbZ2A0ltpndcZuSfsNXS
	whvtSxmYRZ/OwCoRrshwgyO0Dq2TeqRH6+cCKC2zFU9R3Jyc01hHbcZFU7yQxHSBBSuKI1
	At2Lw/HNe6K3xB4PtDf4Tlww+Og3gXo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-Bshq_oCoPjeSmfnmViBaSw-1; Tue,
 14 Jul 2026 23:01:12 -0400
X-MC-Unique: Bshq_oCoPjeSmfnmViBaSw-1
X-Mimecast-MFC-AGG-ID: Bshq_oCoPjeSmfnmViBaSw_1784084469
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B6BC195606B;
	Wed, 15 Jul 2026 03:01:09 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 96D481800677;
	Wed, 15 Jul 2026 03:01:01 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2 6/7] mm/khugepaged: unmap pte before releasing vma write lock
Date: Tue, 14 Jul 2026 20:59:35 -0600
Message-ID: <20260715025941.1571316-7-npache@redhat.com>
In-Reply-To: <20260715025941.1571316-1-npache@redhat.com>
References: <20260715025941.1571316-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: dnInRDNJ3GTx1SxDVvfK8cUK0gx5RNokDiAtUI0y8Ro_1784084469
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: E4AF8180003
X-Rspam-User: 
X-Stat-Signature: 5ubqopn3t5gjo6wq6ihkout8jgtkw7of
X-Rspamd-Server: rspam03
X-HE-Tag: 1784084478-575501
X-HE-Meta: U2FsdGVkX18E/D9o2wIEcnubl2ZQwGzjXBkCY9NaUUVvvRR8bbtACmfpVaw+5XFDaQGJ7WbQTyff29QqyWGMq/jYFnFDz6AaZlal2sWC+Fk2Cyi2DPFvbd+CPkLa1Mwp6kFS8TswHgqYGCrFubys6NGLQsLRlwn3JXoeiQRQV3KnoZkFpUbV8Ec/3qht99gcA+usIqdfl6+ofK4Wg1nNe5QsQ71PloUWR+2kqG9mjTKxdkCcZWOravBYxKVTpsxZ8KiwDCDXvQ6HzBj4xwURVQ33BHGNzKLJTHR1MS8yU+g6NOxR7OIIkzjRHoHuieHpbOjj2LPn53kyr4TO6ZjacgC765PurYJd4g7ZdCE44PD+L5GqMZA0LBQHokSK0/Di8k+B0DhIwGdCUAcyjl0uGOKa+RGGNwcE8C7nOBxaGO/ksVVN2ICP+LwLEf6vfl9JqIuiXEPfCHXjW/Uq7TwW9h8dsM0aQD1HVt2RKZu74+ZaXJ0LBDNySMCIHGWNajTDBscA0Jjpp795ni77jAJrAs2YjWggEMTjB3hmsq9RV9GmGgPCrZZdk04SRiEQg2gzvK3Gr+fjwOKAsqAbK52n3KCtMyHWRMvgD4oYudypWvdaeB//tA+uxuawiFXZE9rfg0YgQMDzq8TvQACGOK7Ba5aMn0W8fwW76KmOucAZY+tzLqxV+6Mwyi6vcc2+XPb8L/q/vn9i3jxdHWb7JVkgVGMXGNIzE0/u2d/oeJXTtdJJsmXeBucBJmI38ppt1IpVmP0WOI5BThtw41ezU8cYFmz1A280am2BtFrGA4Vf9P9l94EOiIT3dzAAclcdARB+f3NRqpxV8EYufeExoqE5Y/ujsWOJ7SP/R5krSitsbNI6LjZO1xtug7NCZwACVklhdBunAuOrB5/RkGSES+gQyuE3IB1zJY1sOiM8BcVpAkRbdwLrOhFST4lyOzTdN2tN/FdN9B4TSbpxk7CuvIt
 wxDrpz/e
 p1+hs/vGJk7qG7VsWlP3iDxEJHTkXZkAYIlmD75413sNTiAE9/CO7y1dWPwi0u2HhUB4IvKwaY7AoBeVtgScnTidMWsscn/NXwS0c0H61ItljaunZGDBCbEWxy5Tk/quLYpqv9p65S3/O55RC1CFgvNv2cYe60OTjU87mFIsoYAQD+ZoUUqlssVQYLZna3Y4421EnfReFsCnEy7GEP+P6y/MrCPQ5lr5B7twY+1FoiJv053cdR1KAr5a99iBkAit0tKJkH6jXfNrmi/e/EUSGXw16qGOxK9LVSrQ5DP402z4/uWLHRMz4pwWtXEkgbgOKiLrmGsFkM5dT5nkSwiXcJXmhv4OUBrj9KbAGhseSUb8RZtE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are currently dropping the anon_vma write lock before unmapping the
PTE. Although this is safe, due to us still holding the mmap_write_lock,
its safer and less confusing to switch the order of these two operations.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 655dbc90535a..40125dcb4de9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1546,10 +1546,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 
 	result = SCAN_SUCCEED;
 out_up_write:
-	if (anon_vma_locked)
-		anon_vma_unlock_write(vma->anon_vma);
 	if (pte)
 		pte_unmap(pte);
+	if (anon_vma_locked)
+		anon_vma_unlock_write(vma->anon_vma);
 	mmap_write_unlock(mm);
 out_nolock:
 	if (folio)
-- 
2.54.0


