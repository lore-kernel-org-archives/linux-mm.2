Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5DB0C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13A06B0005; Tue, 14 Jul 2026 23:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC45D6B0099; Tue, 14 Jul 2026 23:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB896B00A7; Tue, 14 Jul 2026 23:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63F226B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:19:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CC8CA06E2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:10 +0000 (UTC)
X-FDA: 84989506980.24.E893859
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 958DCA0012
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FPNRPMO0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784084408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xm5WBsv9zplLnVKOn6KyW6wbP0F9XLs9d5K3XcjD3NQ=;
	b=TqWY9ZNQ7DTaKrqsOGaMadt1tTdsdmamuAVhBhl7VksewH8SmtmLTFCv+AhkqFFyDT+tyw
	9AVMe8eoh6meZKGyROE+Xrhlja/pMu/txJZFPu8Ynhob7jyQEwZpTIW5kYZSfQVIJJ+rZ3
	W77RhkCAO+12vH0KPYfaB/jMZs5VSpM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FPNRPMO0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784084408;
	b=VZ8uL45CG09ITKEuRR+zFwboph1lUdPGZYvfQTpnQhRJxF+CIJvgJml2pM+1+dpsaFNG6q
	lJtACDBVpcZadnThoC4lItJ6QMFoVqkafCiwK9w0+hw6SvC7ySdNdL97RUe0BjGljSclLq
	vghuxFDj3p4KSTE8dMwadPc+s/ibKnY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784084408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xm5WBsv9zplLnVKOn6KyW6wbP0F9XLs9d5K3XcjD3NQ=;
	b=FPNRPMO0OLfmJWRZgfn8v0L9MY6WJuPmo8Ve2yhxKQH4Z85aHTTbEIVBPidzJnNR6Ei6go
	sMvcaH1wkrHHnEGJmOw/l63AftcZ5dNcpVL3+ObToIOMs9oZUDq9BsjjYircFEL7aV0uxu
	wyDskDmYARTo0UU7pLJDg5W8oJz1kFo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-eE6C1Xc-M6iPLWuGZ7uBig-1; Tue,
 14 Jul 2026 23:00:04 -0400
X-MC-Unique: eE6C1Xc-M6iPLWuGZ7uBig-1
X-Mimecast-MFC-AGG-ID: eE6C1Xc-M6iPLWuGZ7uBig_1784084401
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16F561800D9A;
	Wed, 15 Jul 2026 03:00:00 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A15B0180028B;
	Wed, 15 Jul 2026 02:59:46 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [PATCH v2 0/7] mm/khugepaged: several cleanups
Date: Tue, 14 Jul 2026 20:59:29 -0600
Message-ID: <20260715025941.1571316-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 3ERbnU4vE2FMTyeeGkWrkRfKnn6wfS_njHbhCYHtvx0_1784084401
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: m5yjc3pks3tzcm9zipcgcagxp1p1muy3
X-Rspamd-Queue-Id: 958DCA0012
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784084408-297677
X-HE-Meta: U2FsdGVkX18v8HLmER46FFAVBIExx+DSLR7SoSHzhVcwSeH5FHwabwTvPLFsKlnvc8wH4ES+dAPPqppidYgyaBFo/7Iiw/YNv34bI0HCp0vk3qjlMFk1feX/g9PRGMzpXuzy5xHi7/y2/TC7TmwtArwQuDXF23wqkFeZoZCtxHu/QF5MNvQQtJmJtAdtk43p/ku9fGn7SF7XWHT9U4huJdeZRq6A1KqoVsWEj728al5To0XcOCK2QoXx2R1kNvUqrCeFStGI6sWtNWqGW1pZlXREL2ZG7tA7kaS9lNvWweCu5in7LjUAqI351uw94jS35eWFvPMnv3fvP6fSzkwdHhlRJpDX/yNV74MiZDaRl7KwECdbLP+AgKDBAlql17T2MtlFEWoN3FjnGCg74LU/vuzw7ohX09HxoG6/g8Q2e0ZphZsWQRbuL57uzRCd6KEpaTs/L+T+t3ggYnSgQTcN3XR3RHUqKjvQ0GOmJhxNTTWpFQ4NjNUbx6vFmmpijoxAiU8/6TUezhZcYGCZKrDss8bDdBtBF6Evv/FaLbVEcoXdUpqGn376J8VPAsO/7WZKtWqQPxWr+SbGNiTd9G7XC0BDcLoC0GWBcmxXFegF1UJqZt/lZ/JoqGCu1RzvGj/VMWeEQYdc7qSZM9ilKbC1lsHRX9ZUJFD0VdWAT6hdZ7kvbtg0tlx8czdI6Mcb0K0i/cg196Of5slsNSXZVFGaDI+QAHdS7GGoRn59AuA7FRJz2CfBsxO6L1okksRqagKxLsk0qZmY8ik+9s9YFWUcNeTZohEmtqv/0c29xiu/BhQIBOgjvpmRfYm89FTcrb7eA3yGZsiCk5+/Jz9Zjg1xN1sQhUiF/jjPiiYW26l3S0ajQTqWPCCPwJ6Xha2u6cS/KI8kub6Rj+My+hVx03XPcHnRjNxVU8hukbvEdkPsicVenkeUogQ3eKy07w4a+eCjWu/GqoEY+aJ4NRiU4C7
 fO5VEUS3
 /w99eEK3FcbcdLxOGessjFIxqRCKjaTC3eCKJa2W02ZYM6CUOXDEQwR/EhCDmybiuOdnPr63DhADJuJBk9GwjbEJPPDXoaxaMjBu/8hh5CCjskNNhqVrn+7CDuXCYVL84ihcTsubIwD2kyFj7UAX7z+uF1buDk0KqK03A9MDtSqIbV+nNjbMYobpGbYAeS3YHiXAj1/EwNwhsIZUz2GfAVDUUgMG0hc7FSQeDxP8HVJvg9GTR0FPLrQxdkDr3HbXehTrkg201SrG6W+tMc5oJ+3lyMDCez9uMkJHANnvSeeI5RCcituhjNX3rw+TTyUFA6LsGvXSQMfsUsvEoiotzhq/jrADGmf4TrRiJvkzZpTridww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following changes stem from a number of reviews during my khugepaged
mTHP support series [1]. Some of these are minor code cleanups, issues or
reviews that we decided to deferred to a followup series, or in the case
of the more major patch of the series, changes [2] Lance Yang attempted
while my series was in-flight and we decided to wait till later to try.

The first 3 patches introduce helper functions to increase code reuse and
readability. This includes a per-scan state clearing function, extracting
the young page check into a helper, and a count_collapse_event() function
to reduce a repetative pattern used across mTHP collapse.

The 4th patch was the byproduct of me throwing Claude at all the
comments in khugepaged verifying and looking for any outdated info.

The 5th patch is based on Lance Yang's commit series [2] trying to extract
the PTE state checking into a helper function. This required a bit of
rewriting due to differences after mTHP collapse was introduced. I also
took into account the changes requested during his patches review cycle.

The remaining 2 patches were review points during my mTHP series that we
agreed can be deferred to a later series.

Thank you to those whos reviews and work I leveraged to achieve these
cleanups.

V2 Changes:
 - Add Acks/RB tags
 - rename collapse_is_young() to collapse_is_referenced()
 - delete unncessary comment for collapse_control_init_scan()
 - merge fixup from V1 (fixes stale folio reference) into patch 5
 - keep original ordering for checks in patch 5
 - merge patch 7 into patch 4
 - conflict resolution from uffd_rwp changes 

V1: https://lore.kernel.org/all/20260706154500.39178-1-npache@redhat.com/

[1] - https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com/
[2] - https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux.dev/

Nico Pache (7):
  mm/khugepaged: refactor per-scan state clearing into
    collapse_control_init_scan()
  mm/khugepaged: extract young page check into collapse_is_referenced()
    helper
  mm/khugepaged: introduce a count_collapse_event() helper
  mm/khugepaged: fix outdated comments
  mm/khugepaged: Refactor the PTE state checks into a helper
  mm/khugepaged: unmap pte before releasing vma write lock
  mm: Documentation: clarify where the mTHP stats live

 Documentation/admin-guide/mm/transhuge.rst |   6 +-
 mm/khugepaged.c                            | 399 +++++++++++----------
 2 files changed, 214 insertions(+), 191 deletions(-)


base-commit: bdc38bfc1262e3d1432afadd2aa2ffd83d139dbb
-- 
2.54.0


