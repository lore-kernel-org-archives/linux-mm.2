Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A02606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=DH43oW4G
Received: by kanga.kvack.org (Postfix)
	id E61A26B05B6; Mon, 26 Oct 2026 16:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12736B05B7; Mon, 26 Oct 2026 16:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27F86B05B8; Mon, 26 Oct 2026 16:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A39566B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:56:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 063F11608C4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:56:05 +0000 (UTC)
X-FDA: 85365984690.04.E344996
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43465120004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:56:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DH43oW4G;
	spf=pass (imf29.hostedemail.com: domain of 3Yb7faggKCLoxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Yb7faggKCLoxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793048163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3B44qYC1y1oMWzUzev4ii49MY2PIUQMP+MPnvqlHD0k=;
	b=jZ6jLY564f7zgcWKqly2VNkQXGhee/rFHHBqFNVYdCe1YMviWn/QxLuU7m7TmHoLcx1+nn
	/5Cso2TbNCv4AbyylmKlPM8fvdqY7nW54k2VtYr/WsTYb4V4T9tlqzMHzv28YTwVjBCKTT
	4xFtzX+r72PVYZywS6XU0F82JX8HRvk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793048163;
	b=U1FXaN69+zC8N9VBXEFmm3gXuWYP8ql1lY9ecHNfLzdT+MtVSMhAJMVg2Urn5529L4xaSX
	qf7l8+DLNBVo5JUtviC9rY7cBoSaiK8QzD+b2RlD6nr9Cxt8obKUEAv94VQQNcMnPdMYHl
	+M1Qe5CfIu6hd/DFQICAeOT2joEw5BQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DH43oW4G;
	spf=pass (imf29.hostedemail.com: domain of 3Yb7faggKCLoxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Yb7faggKCLoxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e9d52f684fso34105135ad.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793048162; x=1793652962; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3B44qYC1y1oMWzUzev4ii49MY2PIUQMP+MPnvqlHD0k=;
        b=DH43oW4GaDAXJRuKPO1GDnxla3vMOoz2qAM4lr5YN4SQ3r5EBPgTlq/OFknB9h9+eb
         /WjPwfMZQjOdJN1Uywy4ZjtSY0ajL6c9CkaJVOMNQDH5ECZ93AX/43KZVusu3jdAiD9Z
         6zlQ7sJcwhVvniL6PGdHwgbhJ9ZyeUZznyn4tfOpFZayPADTbD3KehbrpXzQ5LKIijzi
         jm9tmk+dcNRiIT9jSWykq5arialq5E+sXyaTQdr6IiG3H1cclmPkQIaYG98sur6or6jt
         lcOXvWJsOZgsJKjzgcj0Y+TEDlXLIND6xY1M7UXALnHIEkR/aqBAgfEk3Iv4nS6SeZuC
         RCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793048162; x=1793652962;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3B44qYC1y1oMWzUzev4ii49MY2PIUQMP+MPnvqlHD0k=;
        b=mx7F5yJeIwWYdz4hq7EKmnaePwTtqSIax4jj9Yjv72e9AZeHtIGmZn7NE8cNwCiUCM
         wSeeEQHp++AX4TwHvbU2Yc0T+lZQBqSKtF4AW5VR17KEe/xTYOC8KdbWFxS1evfmfqGa
         RCK3AFRHknOw8poayj7CNT5IKJSNsh+LrmxMktYddQYRnthKC5xvjNEp5G8JHowsdG+D
         dKVY9MatR70MxSaOAN57Bb8gfPUAPVoYuEiOBGu7UG09sN+gA5G93t4OoDrMyZXOKT/V
         sSdILhg3UMUHPpxMJlXmjXt8YD2JLD3C3iHQ6/osQs169LoIACYZaol1pMV7jdeScniW
         D1og==
X-Forwarded-Encrypted: i=1; AKwUvBwk6u7un0n+MMF0wbiu7QK3P4fztD/NqywHy1BfMK6FHy61B8e5Uaa1tD6wp060WTE0oLK9ZU5zAg==@kvack.org
X-Gm-Message-State: AFq9FYJQ7PuwLSHN6nerAB8r2kgUW69R7vtZnOBqsgcIg4vEquStN9oJ
	+5Q+M8giyK/pkgCjUICXQ1CLJIwnzYjNu8ddaYjh5DNS9hvyfekRGoLw53YOgvKAttnNqJbZsu2
	QDhUFWh8RmOLtkg==
X-Received: from plot20.prod.google.com ([2002:a17:902:8c94:b0:2e9:6468:1ffe])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3806:b0:2e9:5175:2eb with SMTP id d9443c01a7336-2ea9c0f388fmr65823665ad.1.1793048161845;
 Mon, 26 Oct 2026 13:56:01 -0700 (PDT)
Date: Mon, 26 Oct 2026 20:55:55 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026205555.2918396-1-skhawaja@google.com>
Subject: [PATCH] hugetlbfs: enforce F_SEAL_EXEC on chmod
From: Samiullah Khawaja <skhawaja@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>, Jeff Xu <jeffxu@google.com>, 
	Daniel Verkamp <dverkamp@chromium.org>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43465120004
X-Stat-Signature: r8q53kyr3fsuyaux4okgezjb4zd65rnu
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793048163-11334
X-HE-Meta: U2FsdGVkX19AV412cf6H3C21aSw7HQg2XA76KLIWF3pipYI8RuNxGppCHXfKE89X//uLx5HQTM3w1aoQqZNJoHdNItgBtGSzo82j1KrGwUQ0jxx00IuDJ4OSb4b6DWBV1mdFvmPuNYOg2GiX66BFUFHqbCmNp336hbjPWiVw3UN6FhAxcQAv+vzQlwrbZZruL3F7/RZD4a3okXofF3w+I/KnvJeZZPWHmd7YpU1JnuPTXV8GKp2SiWK8jV6oOYwL2ByzqeLqacYsPvi85bZr+/RevvOk/aF6bGtiEOCWfMVTSaFJ2v6u2N7XK9D9zqmKuhxaGZiE4mg/QvGGdcmhEbWBEatRCYyNar2otc9+teNEMwzEKojfMk9RtslOC1jpHweMk1xcR0lN6G+nVm/8jXNF4riEl+QwqszoGJrkDvfiZy8ftm7bqz1sYR5M2yAaKtmPVIeCM3ZEdt1XDMTXN30YcAzFgi6dZ1xeNx1P4TtR12nsC4QPrJ+3ZL3WUSXLWM2nlzOHoTkPZgkm7A2Pehx1opAmXcPdmJ4k5emKUXwLEAbpyJr1/S9QnxsgCU5ZIap5gWPQED7pIfNsCL1ae91YLtq3hOOKb/+5I77dF8IMwCxGk96kstnhIlk+IIMNYo6OhXD/7MrBxZUtqGZBOjKkGMm1QVSYnoC5dYbrgp4Y2iFswIDFAoiOBguLB3rh7HWZK2CVMS4x40ZQD2f+2ceU2dWRxIEeEK/ezWavkyKHdtgBZn3GRg0L3XPeVJ4YndVL++WJAMoG4ZJpFPt+5E+PG1xAHf5p0hPAkyRKnzrS9UMr4isEEZeQVS6EYkZ6RB6OpUKTBIbWsFnINpF2YOMhW9tqP7FqJhVUAeToKAO1kFQTZzevQ0idNaIx69OJ+gfBIigTIF0QjR78vJbO3Hz6dSCqfmVePLBf/ojwIgs9e7gz8hCa8Ck+suY2GsyFYjLW2Rls5uzM+ryeYu7
 xe9JmiaW
 IN9buMn5EfUATX+9H0DeF9yUd/ku8lCBysysVfL65WjJlx2M7YxzO1Mu3n91VyA4eEuSaMSUaD2lBOQofRBkuHP+wRdHFPZCrNQgwtk3OkttNXqsCsQ0zjo5nIO5A2RHsobGNa8dEhezS1JFLuyicmunsfQu0lSylFGh4W0ZfbCYf+/fH3Sq28F0gib8hXLWeV/r4fkPq4xe7Xx6UGaTMt6UB/sfwHvECbXL6D42lw/qouuptj8LOgIhqEya4Oil9zsx4quoV7Z965pKJWkBer1W49dcEk8RkKS7I1zEcm9OKdANOc0A2Clrgf/0j33tPjyzV7iuqWMFBh8ZwqQ2M8dh/qJ4KAuku8FQV4swbyMeUMv64xC6MuEdrE+SQ7UlMc2oFcPIOrCJ/xKz+hWpWwYp3tJPoHJUnicmM8S4pU3YSMdi+k5u/A/PWcWXkF1Hs9OiXdef6qH3u0JYTNveNSx2wXfgOpBcWK1pyeyJpBPMpKsW/1DkMkJdPm84XjWRU9YFYjHKkfO+EogrffFbFZH8o06J/WLWgM3/8EqmPxVREvdJtc1U+9C+SMwOinFr8vYnGtAvneL3GIInZxWwoGGsejDkjvImGD7okV8NmSv3fYh/RF9TwHM5dF4GY3cKt/K4KboAPFqiEgUj2M9qk35odg4wkx7l9bd49
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

F_SEAL_EXEC prevents the exec bits of a memfd from being changed once
the seal has been set. F_SEAL_EXEC is included in F_ALL_SEALS, so
userspace can set it with F_ADD_SEALS on hugetlbfs memfds just like on
shmem memfds, and F_GET_SEALS then reports it as set. However, the check
that rejects the mode change was only added to shmem_setattr().
hugetlbfs_setattr() never looks at the seal, so the owner of a sealed
hugetlbfs memfd can still make it executable with chmod(). For the same
reason, MFD_NOEXEC_SEAL provides no guarantee when it is combined with
MFD_HUGETLB.

The memfd selftest already covers this, but only the shmem run passes.
When run as "memfd_test hugetlbfs", the test aborts in SEAL-EXEC because
fchmod() succeeds on a sealed file, and none of the remaining tests are
executed.

Add the same check to hugetlbfs_setattr() that shmem_setattr() has, so
that a mode change touching the exec bits fails with -EPERM while
F_SEAL_EXEC is set.

Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
Cc: stable@vger.kernel.org
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 fs/hugetlbfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 01c4d6f44ebe..56e0588d295d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -842,6 +842,10 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
 
 	trace_hugetlbfs_setattr(inode, dentry, attr);
 
+	if ((info->seals & F_SEAL_EXEC) && (ia_valid & ATTR_MODE) &&
+	    ((inode->i_mode ^ attr->ia_mode) & 0111))
+		return -EPERM;
+
 	if (ia_valid & ATTR_SIZE) {
 		loff_t oldsize = inode->i_size;
 		loff_t newsize = attr->ia_size;

base-commit: f1ac44c32cba88ad65dcecd4a279661d14e93651
-- 
2.56.0.307.g5fe7bd680c-goog


