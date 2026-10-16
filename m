Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAED4CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 09:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881546B009B; Fri, 16 Oct 2026 05:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8328C6B009D; Fri, 16 Oct 2026 05:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749FC6B009E; Fri, 16 Oct 2026 05:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 581CF6B009B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:53:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA18C1A0343
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:53:43 +0000 (UTC)
X-FDA: 85328027526.24.25C3D37
Received: from mta0.migadu.com (out-230.mta0.migadu.com [91.218.175.230])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0188240008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:53:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h9ug+C9q;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.230 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792144421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdcwzOjotHxE19RLxZFm3OWWctumeLKS1NSG9llBa2k=;
	b=cnByLTnFvG+QrHpknFl+yeCSbhqkZl8Q1Fi+ADTrjlrK/xe/tzieaxxpY5HDX55YbmDuFe
	f4X37w3mAIg1PzLiz814sIj8JSDxFwQBUvyPlNntK49dQxuz7wZa1DPya/pN2u9TWeex3q
	1bLAnyUXzIBCtDgSlANZEiod+jueNFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792144421;
	b=dlmM24fBJoUiDv76SMB3j0FfIuCnlIknbG1JhvVSICV3KBfCiy80Fo72quRrb8dfG5Vf7R
	QWOq/8KLEHrNAOEWTgkGheqSW8n0RHneK1iUlgubF/+qPlrln31QIx77aZb/YHRaK7roTY
	r5mt+nQ6Qd8cCDSSFQPRLfiZEg3XEBc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h9ug+C9q;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.230 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AdcwzOjotHxE19RLxZFm3OWWctumeLKS1NSG9llBa2k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792144418; v=1; x=1792749218;
 b=h9ug+C9qaUfR5JSkmmWi910MYY9+pSkIEish8X2qfNLh6R2Wpgx182XL9Jp8qySJu7Dk48Ch
 9CPHaTAhJGKYSz+2PW6exFcFghXyfp80Su2BrTbdLACymOvtbiqVoIgL53WiWJE29O5+hztCC8Y
 W45eoDfaDMlSpb8PJdC1hp4w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 2c46a001e07853f7;
	Fri, 16 Oct 2026 09:53:38 +0000
X-Mizu-Trace-ID: 2c46a001e07853f7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 10/10] mm/mremap: fix calling fixup_hugetlb_reservations()
 on the wrong VMA
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261015-urgent_fixes-v1-10-42796911043b@kernel.org>
Date: Fri, 16 Oct 2026 17:53:20 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Adam Litke <agl@us.ibm.com>,
 Mel Gorman <mel@csn.ul.ie>,
 Rik van Riel <riel@surriel.com>,
 Peter Xu <peterx@redhat.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <73BE5C1E-5F2E-4F1D-BC8A-24CC8E9F9D34@linux.dev>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-10-42796911043b@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 0188240008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7asnyqo6hrsjkbht9acbd54asbun19tt
X-HE-Tag: 1792144419-71901
X-HE-Meta: U2FsdGVkX19LwQtVp1qaudrpHWFmBfj/6PRFvZqFRDe/k5/m3rNVJaH3IZkeOGlKqHdyOOnndQz7r/jhx+7lzfrTLufYVeYyxDLzVOqk0aU3ENd99eyucrS6/ZzbY1i+4HZDZgOAhtD3pCLriw9XjkgsK3CcQdFnapD0JKreeAcX55JEzg8Ly+5YfU1robWxJTUhY+1i8+ailtxgtThYEb8KyrFCEI7I69P50ErTuK7QCIYaDd4c4qBheGs8I8wDsaqtxIrykfbEu8PAGnux9HdSzD0yALNalotbH59yK83NlIY7ZI7xDZJxu3oTYhB7gblqExT1zl2MBUW8+8CXTeGqa792zlbcleWRt6tODXafwJ6RB70WGcLTWcUV8jJr5g/fvFvGHgjk1MNNgt2dzdsCPUYO9876J7R3Y6qqk34n9lVB3/hKFgUCCjDDytOixA1EHhmP+/OqmCrLE1IkM7PK38u99MuTBbHVFQfbD3L35sj/mGSEXyZZ6ckfJPZeGfeMyXdVl9WsCiiZU/lOozGVFGQcW8IW1E945vA6cWCBAgkHfBb9IaEepbiozQjZ+hlb52+2rkVuGmuMgmOuIRFSCjCUl0sTzHpaM0b+k+vnUL2oMSEjhUdwAwGsKcRgGTwG583VyX9QWS6HSpVuBuLwOSahOzwmes6DxPgm+TxYYy0FWmdhRwda+V9iPyqAtEiylL6fWz3S4uZ3Csa3vMs/R931r40RHLYbXdvI453NRPl9BkKdJWVQqFxmfI2JXBszc6S0NTAhzYmF2JAQVRzfYMgQk60saofAUZ/AHeGEmfQvJVwJAdRTLzzCvhdghxu5PNI8K76y6BuH+ayrE4Uex08zjPHu3zRDVXZlkLyGN3x7cBKGYxxfTqi/b3MeXW/LeFb6Cjt3sVNC222Ro3n/hiulkPTgSb6DwZL1TneFTninPXQe/r2fqAE6MNVRymfYBmORtGQXkrRBzIN
 msYIApuU
 H8bW/d9o9ihn3MwGhSp96MIAVb1PQvRaiVTDFU2VxU513zNUr/0Oo/Il28X3jZl91b51C4eMImRYIEhWfgqPnYtmhDFdPAIiWwlUJqumMAzYiXJ3e3Hv8nHFqsbsseZSBOrkpmJKXvp3YebDwZFp63IhoIG+z3xFEzb6Ly/d1eSmErlO5yozc8dWsMwde+i/1YqQuAzD+JWApBwMWKgDviFEkCMl6DQIBqXUqp1Tf7/1BTTpfa5erfPvUpDxTAVXU8pvSLfLjxYVeZCxZzZI+TtGLu0u6mfqb36bF8fgZY72JHD9yNt3/ROk4BAEvLrE9bHAypU+Hw5QQ7WZBCoIQAhSyg3zUsxpDRl1iZYCp8hFZkgIwhQ74SXauwN1bC29NKGhFJw7xPRmgidEFjzVb8Vp9DfPmn+o8SmSU71Uk6UNSuvWJW1B9tDFDStkxgQM+GcJ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 00:07, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> In case we fail to move the page tables, for example, because we fail
> to allocate a page table, we actually keep the old VMA.
>=20
> Calling fixup_hugetlb_reservations() on the old VMA is wrong. Fix it
> by just calling it on the VMA that will be removed.
>=20
> The user-visible impact is that the VMA loses its reservations, =
meaning
> that the existing reservations get stranded (leaked) and new hugetlb =
folios
> that are getting allocated in the VMA cannot make use of the
> reservations, failing these allocations.
>=20
> Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


