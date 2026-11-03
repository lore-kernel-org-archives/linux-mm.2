Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45F36083605
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e498INol
Received: by kanga.kvack.org (Postfix)
	id B8B876B05B4; Tue,  3 Nov 2026 05:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63926B05B5; Tue,  3 Nov 2026 05:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52186B05B6; Tue,  3 Nov 2026 05:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD2D6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:28:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08D43A7BF6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:28:53 +0000 (UTC)
X-FDA: 85393434546.04.62E929E
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C05E40006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:28:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e498INol;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1bfQdtMJVeOry4zlZR5idJ3ioLg9CkbsmK6ATlbqUPI=;
	b=hA1fU2yVCJRucfpCA5fMsS0If7VuZdG9oBoSdIZD6E+wxIlrVp1zGd/4sZ7/FmP0pNEvKW
	CNsVRempsRQHbBcJ++HMwjTpdOZC1dl5+38cFkFwa8y7zSH1CSiD1LcCs41UvKRdRwTFOm
	/NY+xNM0w6apeS52Qs9febPjJo8mywo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701731;
	b=7+jZe9sbc09bCGbkQEGHvJKz9NJVKIGBJbUBO8j9pL22w2hBY/g7OntIzMEUpr8iEVTwX9
	OtKeSVwYN9wSjlhNjE+9/cdM3XUKizkXajv/Mv8bPS4VQYKq6YDJR6HWmrO4MaBk+7NJN3
	Jl5nYaE8+jjqfOKZOxkw8dPMnU94XAk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e498INol;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e0d1da913so413152f8f.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701730; x=1794306530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1bfQdtMJVeOry4zlZR5idJ3ioLg9CkbsmK6ATlbqUPI=;
        b=e498INolsCp/1ZqYQolo5OiN2k2r5UIziqzB5OvU52PkIEpeoiZNHt44M2fWh7Ts1h
         RrUS9wombmT2pd1tCCKkSbVxwjLXH6/oGQmv1iNRcDw6R2nWMPshXIX8J+/RDge83S5k
         qu45vpOlfpQ0Ke7dexxnUMRBTdcJGMg+YLtVkUW5kU9ci5zzh2nuM6smhKvAyQmGm4a3
         rj3yyj5S1hCZ1ewLgwo9lY9GIGmIBLs9RDy7i95fcznkjQeEvnct6DeCtK/AzoH5xnIT
         Tuxa81hIy4P8Xep0U3DDgM6OXT62pWCuC+NijbRrUJzsJTsY6aboFogi+AvO3cc1B75J
         ISdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701730; x=1794306530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1bfQdtMJVeOry4zlZR5idJ3ioLg9CkbsmK6ATlbqUPI=;
        b=HUYtzUukngR0Ji+LHMWA+W5frgGAUeUrLC+6sYpiBkd+wVftNkU/kA1wqNtA7Opn22
         KgIutfCvGX4n/r2+uGaNIBVNILpHrJ89+e5mMzGICImV1AXApCTOKf+u6dR58zBpzrUj
         m77YQrDSnBwlzlWR2BHw1o+IWPglzA8W+ZxhEbmvo5CApLhc58pMkVgD8zChqiBP092/
         4XyGt1pBIhQZW/oMHDsynW1MfwbSSpldbk0b0sZ3zSt+063tlnu+41x8ElmquFAnK6+z
         MIBlg4PbRg1e9Mo4IJZvFD0qyVt+iLu0lAZwQoasTrfQI60PYbnmGe/sROUOHnoWtHLN
         uHWQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXTMUnj0Cfiveeg+LOlFylqraa48quO1Dg4hVFcU8thvvD6+9CcpHFWpc/6n5nIfp8j3Rj7Q8vRg==@kvack.org
X-Gm-Message-State: APuU4Z+m5xsLk6AQVlnUiG3Lh8GCd6ahbKLTPcrEdKuhgW/xrwvH/YgV
	ltr9ILv1rBUWE16NB9EAAew9hrYtx/I261iJlMhhFaM2ZmfIp95rayMZ
X-Gm-Gg: AYBFou0H9XNpveD7vfp9VxUtV4fwbCIuYxNEJhM/LZnAMnFfIcgXRNR7KYwa8naGV6M
	AYzIJzxkQIS31dbpNsBQtDDjDCcFr/t6+ZyHHHq79pNErox5QcGxJjUamnExcqwX97hYFr3oVis
	jk1+JXLgY/u5c0wV96YuYwTriPats0ukPDyWX0qqpm6rw6kL65OQU1qIcWksHO+1x/AUUkz+Krv
	RcggeMTHTialhYxYuG7qRhDsRefW57Mp1kIFT+qH1FPXBIOhDtAEd6bkI1N1Ac3mXatN6j9Pv4M
	xebHITyosnxYfYttXSW1TquQXO+M+JTD59xDCmexhFY0xS1G1RfhgFwlygKm4jf5YkOmodczAt3
	cGylST/yUbEwk3wagMNbRDI45YgzSWM23L5jLdrnz16VRjuQTi9o8kGcQPjp+jEc7HP79h21Rqc
	V+bHcUpSRRlYbk0OsYeAddMKtBJfatmzgOKWD3+ClDh05d++ilVqhJy6XVg1nCuedIEKrJsychY
	S5plCZboJof+Hp+7DXE/bufBMcxVHHZCO0UlyHcYIxlBwfYpaGrrdshu6FAV/ro21W13qRM2hou
	yodfgTto+dfm/g==
X-Received: by 2002:a05:6000:98b:b0:48e:3484:8af2 with SMTP id ffacd0b85a97d-48e64d10510mr37075329f8f.31.1793701729728;
        Tue, 03 Nov 2026 02:28:49 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b7815fsm24941003f8f.22.2026.11.03.02.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:28:48 -0800 (PST)
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
Subject: [PATCH v3 1/2] mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY retry
Date: Tue,  3 Nov 2026 11:28:35 +0100
Message-ID: <20261103102840.68903-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103102840.68903-1-azpijr@gmail.com>
References: <20261103102840.68903-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bag9b7n4bzxtkgisgcogmfi36f8eobca
X-Rspamd-Queue-Id: 3C05E40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793701731-668355
X-HE-Meta: U2FsdGVkX1+Q+t6zjKYEZqUZkhXyBN37fVPjfxSWpES2ifVdWb4a2E1KxmdMFhdJanYptv7rNgocol6LOKNr1vjQ/4Pq5gSyqr2CMEBNqKzkCQQG9Yv3hJbaXQRnVHt6yoQQeEReqYIFh6x3TcDd3Q2vGrKLUcdOdsLNiPlGYZw+1z9d8tng4UHMq4yURR1JRuB8DGxYaEYF8N5YK9CI4IG3/g7StOWmduIJ4Qvp1T/PkOcuSSjtFrXkOuPFKzbkDpPQ1o5PsX0IUgvFqbpz6sxoB30qAPY8mrhyRCdOti3gdTv6hm4EDKq7HVAEdp6sJXR4qpxckW4pAjpsSlXAZwj/pV1RbDgzxU/Y61tyNEjB0Y34XnbICJJhjAEqJ2n/6uhQJO0T6WTBP7C1sL4WQvVzSW7uVDw3X35HGpLrzmkakSCpIvYwFBeGv3unrr6eLWQ3emyMkEJvJPXVBg1nIMDo1dKPHOkXjL+AmCczf2ZMrzGVL6aAxLpeWXm4O9KONC8E69/67qXcLATkhZcBUQBECbIBfaIqIU0hRFOajVS5av/a5mEvZATxFsPAR46J0Sgn/z/Vfg0ExXoMZSKpRb0qpFKcA7jcn6s4i/Is0OX68WmvAI1zrzlgZje//Q91gafZioPXuVUfrJq8TZhFmhBdmxBhpmuv0BCb0TEitvuOEQvi8MT8MsBD526QlQNbGX1ZodB4CIAV9ny9gTSmg5ORbNPkkhI2pqZHYJt2jj89AE7CLgtnU1nphs1aAy0prXYHVe13yKRl8oZgHo3OwJ14Bix4E6SyESIys8vaKXHMMbHVzeYv2YV7HDKM9/gtkN3aTDi5Va9usjYYjYBq9lo6MwqSHikltiPepVajFCp9h4VgQcmIZ5kMd/L+WGU7N0gVKps/5i/nmhR2edzGHF912KftJh3i4iWFrO9axYqh1Ly6/7A9PDFiYLhy+Kix3NLnJ8l+iYYLJ2Kdei7
 Xl0jWstv
 NBJX17FIvQDmPfiJOzuTMXcXO25ukvQREwhXZb+Vrlvzp+UZz2sqge/fz64rKufh0qaMVtTwb6/fUUrTaUCxuoTlWGGEW51JvGw2gjOhXtkn2usV1XzY8bp4ZoRyQ7tCaU2oET2B80u5JFVOO3IeafUzJs7CKoDqyIME8jWr7ENeZIHcKBLXbaBtlx1Wq3NiP64WK+ZVVGcBqFerVNS1bLvRwLHUKMgBT83JLwCkRxgPOrGeGKAOIT5a3uU4A/KolBkaKcYRxjf8ZJUua2E58DXvwUnj4ykeNErcGzbhG7/Oxvkzznsh3SHBfkGHja7GBgfY+tqql+6NsOzd5VWxBM32r3georcvgt2DXCDsgnmxKII5svq0MWK9OyNdM8argx6o/HqFO486Fm8kU3QZKlXwW43oQZ6CT/cNI+lgJmsGZJ99YXfRNb0wRYBPYYh0xxcS93r6Mt36oqmlH30HO5PAid33DImoXsqxvS3aulPk3V+E=
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
PTE in a VMA without VM_UFFD_WP.

Recheck VM_UFFD_WP for UFFDIO_COPY_MODE_WP copies after looking the VMA
up again, and fail with -EINVAL if it is gone.

Fixes: 6041c6917903 ("mm/hugetlb: take care of UFFDIO_COPY_MODE_WP")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v3:
- none

Changes in v2:
- drop the leftover sentence and the non-hugetlb reference from the
  commit message
- add Mike's Reviewed-by

v2: https://lore.kernel.org/20261102081140.201987-2-azpijr@gmail.com
v1: https://lore.kernel.org/20261029221129.89068-2-azpijr@gmail.com

 mm/userfaultfd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index f33ccedfecd2..6321bb82c1ef 100644
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
2.56.0


