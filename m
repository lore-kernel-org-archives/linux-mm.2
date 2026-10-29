Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E17606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 22:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mSZC6ou7
Received: by kanga.kvack.org (Postfix)
	id 9AA946B05B1; Thu, 29 Oct 2026 18:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B006B05B4; Thu, 29 Oct 2026 18:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897D46B05B5; Thu, 29 Oct 2026 18:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 468FB6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:11:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A1E8160558
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:11:41 +0000 (UTC)
X-FDA: 85377061602.11.9A5951E
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id C196340002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:11:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mSZC6ou7;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793311899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jNtZbHxCXS7Amya3dC3EE3s6XNWDFBG2KE54hDksKQ=;
	b=y3j9p46VCJeLLti4zRPcfcV3J0Rl2cL8KFeN7XjcfpOS4WtQ96fKMu+OSKqb5ZaThlNGzc
	elnYNo+wfpLuyAbAzT+Fmj65YzZfuPplC/6wd4PtVgJThk9yvyYKfvYr/PumQHouuLC2ic
	qV8AYMzsscB96LT9hg+w3n1l+cC0xvI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793311899;
	b=buVOi3TNo+n+s8kBXT6FYV5BMJWGV7NbK2iIs3illxjTzj1JXdES47GwWhLfOkV0ct6Jlu
	2EKvGafN+Bql73aR8rUJRglkGH9+Z2xFOsx2BQarHBDAxD3WoSa0VPd0xIbpyejacMg+Az
	TiSXv+5EFMRTVYgonK9vv94ukF9VjiY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mSZC6ou7;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso438375e9.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793311898; x=1793916698; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5jNtZbHxCXS7Amya3dC3EE3s6XNWDFBG2KE54hDksKQ=;
        b=mSZC6ou7UyP6MiXgJmEKUinqJDPvxKYn2vnJJVL86fYPC2IMTaX7QQzGr5XZtbgf0H
         /QULO2C4yd8IUmjkekDSRgHurBN1EGUNJKfZFX7ZkrfAZIrbdFu/vYxanQlLWjoJ6F+Q
         80bSO99dHlXv3xxCqfWg6trbjZNNhRoiLtuPBxr+a885hQOEF25gEvjykXbSVp9cx0n2
         l0hBIYmH8pJliEcvfAOEIIfrt+6Cv9d29XHUvCHAZdjjCxWh3DmPe0GbeWDS5okPsN3s
         VXnr73IBzQXcWGB1+uOOhoqqeoCBmKg5nnXAf1CJnDsqlTwxGjLo6MmMrshNfP5ulXIW
         j4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793311898; x=1793916698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5jNtZbHxCXS7Amya3dC3EE3s6XNWDFBG2KE54hDksKQ=;
        b=QmaM2M/ggBEz0MwbGt/67jYsmFf3Mo4kphe1ZyFoI6BjTm5mmBm2l3H+psJ8zb4QQv
         qRj/RfSOFburRbv9H5jPWbbYX51jA4x2e8yl6RtD7MZy0PURsJw8w8wV3dQmJ52Dh0SJ
         dViueZGY6mAp0zFQdm6pcdbtnWLAxRbtiK5+AdRuSIFdTP6QNRQe+qhzkUR+ikji70Ai
         31JfgW2hA2LM4C2s1adXkmS3vYg3dJ8QUJHOAU6KvsNxL9eAwdGK5X1zZG72OPqbdQPM
         bGBy3agAaye4s/WZReL65meJ8kH0ZG1raPHQ0bW2Etqu7FH0GowrE4KOti23fM4oFqgM
         Aomg==
X-Forwarded-Encrypted: i=1; AKwUvByf/4dANDGNuCxc/WSrwMLJ1B3U+xd5AMSo6IR9b3/6arTISw9OGH8ZK0gwgIpVoZLp+xQ4hPKTzQ==@kvack.org
X-Gm-Message-State: AFq9FYJK8u3ki4xlAvr7+AHyIZjHrJBrBK5A7hWqvpcSCPEm9diA+NNZ
	89BeWOtGuRdCEctJpkb64H+gIb5dEHz6/K6rqbUsXsHYQIZaflWX7U7D
X-Gm-Gg: AYBFou1Me7smrxBIpa/19BCW02uLrNQL3srlZo7tOGZUCB2JZUJK2ySmDjYz1B2UFMM
	PBnu936LoA2kn1sOFQFl9AszzXdkzoRg+eRvdyqaQGd1mtO0alqQ2vn+xdB3XQxtF072+MoBWPy
	IFVzgQbp78mJFimbCI7uEjTokHWZ5KR/ypVXvOEoARuEJX8OX77cWL46EA03OuyrLMVcdT7gq7i
	YUpDyXsjXql9DJvlLGZLzKy4tJQUym+WtjTVsFBCHiKT8g2oW8KM4nV7Rlr3D/PDG5q4B5hHJLk
	tH5p6JSEIoddH/Juwe3SDj4naEPZizzBH6FM6FABcrJ7Qn9BDgwIrMlMAYg18XpKBhaa6rsufea
	vLQfbd1raO1I3CAu1Wqwo8r4241jMUR/G38LZL0ZuQ7LuiDOnkngl4ZRY/TGC50Bim/H5pSVkLa
	OloL+Zl8VRf7QPYwhV6gwT0mh8eSIr0XNgUUagLfkZAk8IpUp3uFCLqsY+vVQQ4PhZVFnYm21Gr
	MzQjFXvHh6KSak6KFJChSUzpS4rJUnchF3uVxPts+zfh2SccBJV3goTakl0g1M5SXdIC+hODUQo
	kD9qkQ5CfB3QQg==
X-Received: by 2002:a05:600c:46ce:b0:4a6:7d6:821f with SMTP id 5b1f17b1804b1-4ac189928e9mr7162435e9.29.1793311898530;
        Thu, 29 Oct 2026 15:11:38 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81a896fesm104011305e9.10.2026.10.29.15.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:11:38 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY retry
Date: Thu, 29 Oct 2026 23:11:01 +0100
Message-ID: <20261029221129.89068-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261029221129.89068-1-azpijr@gmail.com>
References: <20261029221129.89068-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C196340002
X-Stat-Signature: 74nwmo1y4tcxw5x58pntabe5q9rwqs5i
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793311899-475785
X-HE-Meta: U2FsdGVkX1+gHLKeS0KDwRQ9CEVsY9mCWJZzrMCRRACQPZavGTkvlnAuUpxda9ztA3/m2cCnpgbi7Su4cfNSnbn1XeyUkXdft8quUoKg1jI/cTP3sOQa0NOwKEMtJ6kwGq/c4E19h9Zd8X/agvwzz6d5lhmQT+E3SiOgvYt8vyNxTNnZjpCwbDbt7eBawqPDDvWJxZ1gomPW3BMLfP5EqZe1pVoaueEICRkRcn7fUgpJdGwMhv0PvBpPjiJeYAETq9aXfY+dpgAM/IbO3ELJXoCfYWz/N2ko1uKJpif5AsY5LbDgsPmw/EacIjOBjzf+YXfruQK+1XT/zqXR/txk83AkUCBQCw0AlxZVXS5i5aR3KSN6xRcOT5to17y6V+jaHCQ5cEzxtRmWdhKIbBOw0kM60wjepnRcNyYUZpSay31AVhO7kgygQfM9bVyGwlJO8jQ6+Ys690kJAUYILOhJBUxX+7cQvPwdkT6oFNypfEvBiXyxwVIhE285mkUOyUCm+Tg9iLrOqmwfegjWpeZalMHwIF4fUofqdi3fL9MMyKVIKgTBhF4MX/zhbeT5EDnE9DH8Olsb5iLv6cO7hPoHJLwMvHOQhYYhPvMn2TYqauBdyS0boF0sXGfkR7ErCRuEPZGjj3JYwuSOLQB5SJ6U7sPTixbY/wqraaS0sZYYbBRvgR2Hmq2zFaqan9iMtXKYcvM3mBltJseYwPr47XDQj+m3g4jWDUP16w0h50rTdFJ5U+Krjzpud56GDLpkgaf5AOULExKXu6sW7HB0U2iDBQR3DT1z/sYSBe3GtdTq7HWhvWjgQW9DU8aa8VAuMMMdUT29blhxhwYLZL7PRcF6OFTjGkVpmJDmVW+kI62EEsEbfdKguGmiPvDpm5yEvoaoVwsSF8h7Ci+udCd5os2BoKA03WmHllfqsgaFZxVJo5Pp9zuhDg9J7s0Q7n6P5Ccao1X9ymMI/DgT2kYjC9R
 Ewdffe2I
 HgpO5tX72yf+/hrnRhY8IpJ5zQVx33SC/QmZUVgOeRe1qpGh1CGXeq43q3Q9CuxaxrMAt3xhO/OorZehTRcEmR27pYOv7kEauwSRwBnAPvcFdmr6OtCubrLNkaq2mXP9pTA/4zHAGHI2M5/xOTGYQm2gjLfSE1CElXdxmEvc4rRRo+2JqEVNILrjJY6RKKOJfuFGC1sWZ11mgm3H7JXuu2MePnkKUj2t7tZ5FBoYBvlCQod3kNEre+NlLdxVRvzdGtDrC2/XPJpUlEnku3bi1n64hUVzfUMO5Y6u4sI/44qg7zyUNp1MpR/8bQ56PuW2gq4Ukekq79Df6RgoINb/9JnwAn8r3LbV/QGvx5ohuOu84fJM3+U8fk8NyUoHmdpmqanNUierqH1pGg5qcxRQi9hVMSZb4eZEBtXTrTjTTGrOjWmb5qhuuTrnWfbC4xitFhLsUnLWEoinPknwsktMQSVlt2QUviPweCHaVgABAEOW0YHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mfill_atomic_hugetlb() drops its locks to copy the source page with page
faults enabled and then looks the VMA up again. The retry doesn't check
that the VMA is still registered for WP, so if the range is re-registered
without WP in that window, a UFFDIO_COPY_MODE_WP copy installs a uffd-wp
PTE in a VMA without VM_UFFD_WP. That is one of the leftover uffd bits
hugetlb_fault() has to tolerate.

The non-hugetlb retry goes through mfill_get_vma() again and fails with
-EINVAL. Do the same check in the hugetlb retry.

Fixes: 6041c6917903 ("mm/hugetlb: take care of UFFDIO_COPY_MODE_WP")
Cc: stable@vger.kernel.org
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/userfaultfd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3b71712edab4..a70ecfc8a998 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -810,6 +810,10 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
 			goto out_unlock_vma;
 
+		/* The range may have been re-registered without WP meanwhile. */
+		if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
+			goto out_unlock_vma;
+
 		/*
 		 * If memory mappings are changing because of non-cooperative
 		 * operation (e.g. mremap) running in parallel, bail out and
-- 
2.55.0


