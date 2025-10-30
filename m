Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BB9CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BB028001E; Thu, 30 Oct 2025 12:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED21280003; Thu, 30 Oct 2025 12:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB9E28001E; Thu, 30 Oct 2025 12:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3E42280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:47:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6173E129A92
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:47:09 +0000 (UTC)
X-FDA: 84055360578.18.D61CFF6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 60E381C0010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:47:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iDvd0NtZ;
	spf=pass (imf18.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761842827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U5ipyqPqU8AH7OqF5G0PYcq2r4ulOrCpwpzrAqHVwAU=;
	b=2QpUEJkto6wnOcBBVVPULQlYTzumh5A6YNkQFciklZvkclkSjw/toI1igKx5AdOBOO9Ua7
	cOB1YcjDRDvWuB/C9DvzmS/bbTgMuNNMHiOWWKbDiGf7l4B2rVeRYRHNt74BGZCkwI1PtW
	6EzGq/Ca3cHkSPt1gAwFCxwVDc705tU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iDvd0NtZ;
	spf=pass (imf18.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761842827; a=rsa-sha256;
	cv=none;
	b=3VtnebkFPjDrradCBFleAgKv4rIbAsL9JXGc8H3Hl9oeFF6cZoJJDgwg9eMCD398pzCo0h
	YPohQL6mxwLpL+Crn00Z8c4v+xM9kzpu6Mds5BOdo+PnCKUzonjgCjGpcAf72VyX0mepR2
	L4tAyt9rFUuujjObGIWniJpPnrbwhFo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761842826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U5ipyqPqU8AH7OqF5G0PYcq2r4ulOrCpwpzrAqHVwAU=;
	b=iDvd0NtZSDQciq9d5CWkE1kuL3H/mDUGjbyAWpUN6HxXY8YMNbCTBKyw8N7B9jvdFLKonG
	46YaOOucX67XHJLGH++bAvg+L6mK9lylQUj61tJt3JqJfftko0yEMor8vSDpFFcxKD//SO
	UaYjUlnvlNQfAfF9mKkO+AfFHrqmjJQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-M1MacybcM_uD1mNgVSpKGQ-1; Thu,
 30 Oct 2025 12:47:05 -0400
X-MC-Unique: M1MacybcM_uD1mNgVSpKGQ-1
X-Mimecast-MFC-AGG-ID: M1MacybcM_uD1mNgVSpKGQ_1761842824
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02625195606D;
	Thu, 30 Oct 2025 16:47:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.105])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E5CE19560B6;
	Thu, 30 Oct 2025 16:47:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	William Kucharski <william.kucharski@oracle.com>
Subject: [PATCH RFC] shmem: don't trim whole folio loop boundaries on partial truncate
Date: Thu, 30 Oct 2025 12:51:21 -0400
Message-ID: <20251030165121.1131002-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Kyf46e-VFRVBE77KXNifZ7sbjcXRIYS30WbmhyCOKuc_1761842824
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pbxwzufaadoct6t3nrpbifa3gwu83sgj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60E381C0010
X-HE-Tag: 1761842827-736443
X-HE-Meta: U2FsdGVkX1+CfgrqaPyCVRadUQU8gDIgdeP8JzueT0vED9kz9/HBKW2ur+kZpHqvwOdCqn6pd1iT+iqec+/mwXRriHdbKq6c0xsVJMrFGKewfqARbMZKTffCFSGjK9OXYHE2i2I9qn0rRa8z/aFjLNH7t2x5DvTV83kH88yJCAstwzYwSLYm2zQmjd6RQO4BsEqcRiPDIece0edncfTJGBUTusratOP+hYZlsJu8C+QApudv5qzpzmJiiPYfJriAbDMkrFKKPj1oqlghxvytmsf18iagBaaUrdA/EhxklrKeL2JDVclRlrJUOGBkJxEODkVafq33et68EdDPA9ZgquGwCcc+JOp85BhEIiATyrJzn4ZCs3YkYm+YT7ddskMtG21+HCeD9NVU+hdoiuTKB3L0aMmaoct2arywCvnzWI23yafE5Se0lOz5KLxBjkdCb0Lgt3uTDqF6rxT5H6LdT+brEea8qmIbvBDQGcnRGNemMmiQsZf0XWlT5CjhnDYemyErh6FJALdeUXhwbRcRGqPaZf+SQHl0arCMoH40PLaI/nUkd3t708SaPXPUadOVaVEpuu8bsz1bu/+jn1Woe/PckqlAIjpobh4QTfEaPRs21qzHN1beceAykrYFwol4T4Em6ejUEBoO65JqJBShpA88yl+Q9w0eDUko8Uppe9VmQ7XGAQ3ALIykrnDs2FeX3DBVyMENASTqNOEhqhu6HACPqF0Isyjwa16OVn9kpQiEO5iLvuwUOwqR8slJFk0/3cI7JgoVKtpiM7RKNev4tHYyK6GZXatE8lzGMhD44KSf5mAYk9I3JfSyqprARlkTsvqYFLIq6nC0VkJn5w+hbVJkyiWQL12L6IJlYQfQbo2BUaBJjm7DqSzpAgiKF4RAlYeGX1hfw+4BFVTmQ8aANpcwe7+DW3eyCFvAmhxt7RArpilTFCJKrx6OBI5GCa5JbGHcEcv/SMnH2z8XR5y
 iiDIlNiY
 2vkDmrHRswvAUJf/ptqtn0qrTR1L16scampENSJ8lCAdGByHWu8/8JkCGBQNWyXVxpLM/NHfekgjKa1+xZl8HIGtVd0w9SF1CsHSqwDlsGjcNoZ6B7rDIDEFXsoguXPymhB4Gh7BLSoulINzZAodfkOF6xRetoGE87WNs357j12btU1bTL7AoaCLh7qtk2KxwErP30kInHyWp+01dGgUpZjTCWC7KboJsLB0teyGs7HOWc9t7er94Uxcmh7/0XTKPtHbFwQ3iR+78MWKJrlEMz2rrlWZKflq+Tef9gCNg7AJetDx2K/+IUvxcY/MxPsHxwNC/HyyTdVAGAkJy34qKsfbE/2tdtOYQ4LcOFyl5YUEK106I+PEGDzQeqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An fstests fsx test run in a low memory cgroup environment on a
huge=always tmpfs mount occasionally reproduces a livelock in
shmem_undo_range() (via a truncate operation). The process ends up
spinning indefinitely in the whole_folios loop.

The root cause of this appears to be that earlier in the function, a
large folio is handled at the start boundary of the truncate. The
truncate_inode_partial_folio() splits the large folio such that the
currently referenced folio now ends before the range of whole folios
to truncate in the second loop. The start index is pushed back and
the second loop finds/splits some folios in this range.

Ultimately what appears to happen is that we settle in a sequence
where a large and dirty folio sits at the updated start index, the
truncate returns false and doesn't actually toss the folio because
it's not fully within the logical offset boundaries, and hence the
loop restarts indefinitely because the index had moved forward since
the previous batch lookup.

To avoid this problem and simplify the code, remove the start/end
boundary updates in the partial folio handling at range boundaries.
My understanding is that there is potentially some overlap and
duplicate work here, but that this is relatively harmless and safer
than the alternative. Also since the folio size can change as a
result of the partial truncate, update the same_folio value based on
the post-truncate folio.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

So I've been (finally) getting back to my tmpfs zeroing fixes and
running some testing and hit this issue. The test is fsx running in a
10MB memory.max cgroup against a 4MB file on a tmpfs mount with
huge=always. Note that I first tried to bisect this since I don't recall
hitting it before and that landed on 69e0a3b49003 ("mm: shmem: fix the
strategy for the tmpfs 'huge=' options"). I take this as a behavior
change to something that precedes my initial testing and not a root
cause, so I moved away from that in favor of throwing in some tracing to
characterize behavior.

I'm sending this as an RFC because even though it seems to resolve the
issue in my (limited so far) testing, I'm not familiar enough with all
the complexities around large folio management and whatnot to be totally
sure it's the right fix. For example, I'm not quite sure if the test
constraints here are circumstantial or something more. FWIW, I started
with a more simple fix to just prevent start from moving backwards. That
prevents the issue as well, but this seemed a little more explicit on
further thought.

I notice the same boundary tweaking logic in
truncate_inode_pages_range() (via the same commit [1]), though it looks
like that path is not susceptible to a livelock as it will just toss
folios. Again, I'm not totally sure if there are outside circumstances
that make this less relevant there than for tmpfs, so this is at worst a
starting point for discussion.. Thanks.

Brian

[1] b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")

 mm/shmem.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b9081b817d28..133a7d8213c5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1133,13 +1133,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
 	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
 	if (folio) {
-		same_folio = lend < folio_pos(folio) + folio_size(folio);
 		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
-			start = folio_next_index(folio);
-			if (same_folio)
-				end = folio->index;
-		}
+		truncate_inode_partial_folio(folio, lstart, lend);
+		same_folio = lend < folio_pos(folio) + folio_size(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 		folio = NULL;
@@ -1149,8 +1145,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
 	if (folio) {
 		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend))
-			end = folio->index;
+		truncate_inode_partial_folio(folio, lstart, lend);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
-- 
2.51.0


