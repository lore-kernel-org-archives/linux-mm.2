Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE9F606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NMkuujTp
Received: by kanga.kvack.org (Postfix)
	id B6AD76B05F3; Wed, 18 Nov 2026 16:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1BE06B05F4; Wed, 18 Nov 2026 16:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC1F6B05F5; Wed, 18 Nov 2026 16:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65E6B6B05F3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:37:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE17E1A028B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:37:14 +0000 (UTC)
X-FDA: 85449550788.16.80FB95A
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D59E1A0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:37:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NMkuujTp;
	spf=pass (imf19.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795037833;
	b=DHjaJILAyU2vNcFTJfddSOEmO6XuzRZrmrG6/BWvTaZ1tx8WV56BO7A/NzrUgXK21x+dqw
	QLtp+6jcMeowFLHhKp1vqP95GtR9y0tXJFPWZ3BPUyIoemeMrtXEsYNMVj9pRP73S1UA+J
	GolRwjq8h5C6NIvMRowjYyVTZIO9df8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NMkuujTp;
	spf=pass (imf19.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnbJtG27pIY995fyqbhJH3BDZH2+CKUmjSvhuUbO5lA=;
	b=tw2hx4UC/XjErEvT/EJlJhN6gkVrvLDhD48O6JlDXl80jjSpyXbgXHj3lO00p2Y2iVaxww
	2zS2+cVMi2QmgvTOG7Ic16xuOAMwrOTCb9QGQL2HYqPWxb0z4maQKl5BCAVG8x8gjBah8m
	As+vfbKajtHs55NIoBZOh3SpQCF2TSI=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b30ff12f84so10315517b3.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795037832; x=1795642632; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vnbJtG27pIY995fyqbhJH3BDZH2+CKUmjSvhuUbO5lA=;
        b=NMkuujTpijexHCNf/rfYMHq4PBkdNmXLbbEFsSs+4M5UwAlmEMJB+onJ/k7EDYEyKg
         E8eNEXBY/r8HGlRgU3MFHmQHYpKzigXuK14rP3b0aQXNJKwxelmQU6fhyA6zRr0f7Dko
         C74Hp3v9R7EKUVbdkS0/gjMplKtoUYbAZON0AfyaiwVZyFse4egKLg/Z9EwroUREZa3m
         8SY42LYmP+g4/udwvtx0K3SePnksNH0FC6VAz8WOPOGt51xnJzPd65OIsuFL6BB1PnBD
         kT7DowDAaPqA79zQYr1BH0rmpfhNNW5RituXtqL0drA+1KKy0iuehYx7xM83v1PBoQh7
         U8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037832; x=1795642632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vnbJtG27pIY995fyqbhJH3BDZH2+CKUmjSvhuUbO5lA=;
        b=enFjJ2uC3klWoh1stX0EujBzAPZNtRZlcT/tDZ0AP/He9kVP/hqV6q/CjPnSXCx9cH
         A39ivHzhmlmyKGq3OMUxkNKTervCGAwIaMOj7efdIOQ7nmOg7i/b/yXLT0ntlWA+ZG8Y
         3CR7VaiAq2TVHOw6MFK8fvANg92st+uBJDqEWMnVRhPT/gh3ItzwSWKM8w3AFlJcReWg
         PRF91myEJF+2+gjU5VPayDf4b794s7KhrxY2+qLu946FOzAxHTb97o6IQV92eJX1SwCg
         f/kSEArb8IlqPgfHrR89fRXY58TjRXWRuRqjn04M5QHoLlL/1Rz34PLrur84iVazsXZG
         cV0w==
X-Gm-Message-State: APuU4Z9/pHW80RNC2vsxTlUkVPJ7kCrN/CZA5/jvy/hLmlW8WNB7NY7j
	kHNk/hAde4Gfh/l3DLtW20TU0GJGsFTjCAuVH6mjWSwHf9CXvc1l2Ili
X-Gm-Gg: AZFdTZfJFzMJC7KeqZYfoEm/ad/WWppWmwnnGrdnMG5Sc43QQ4FPBC+VFjl5nCSv23q
	0DhGYlzdSdB3Sgjw63Kb95Cnvu2Uep8MVKQcAdsAlkK9MlHt6qPl1ibDvCM2Bj8YGiBNiPFziS+
	YJ2i3NgZYIMb/V+zxJnvmegu9/7DzXgonVAFt4Lg4eXJeWBtjExw/xsd7DYhHdaQKKxXLb2m46D
	1nhp4toFCWeN+E4lgwNbN/k86HUo9aYv764zThxJ3OE7mrjrKn1aootKyv6HDa+NN3EH5GgbSPH
	sbX5BVgt8eAh583c4ct9pQz5NqUwRKxNuE22XOiSMBMxeff/IktyTR7cyG/8IYfuguRqL2c8sJn
	dK93cAujpIWfA3Lj8JniriqVXbXbIkxJGyTA+7o2iOe375K2KdPqQm5jSN/j8bH1jKwaVs90lK3
	IWf3deVrUSRFuR5R/6zm4SLzCeT/ZdPjB7GayJV4zsYh8Bx1t+FuCVqbkAZWQs79miBWCH6inuS
	XHxzMMJUULW/g2g9uT/m/nsdATA8ZWeFxeDgPlAf1+n6rduAx4KATyBuzwsgycrgc+Lcb1UjqJQ
	mxFUw6krnPbj1sfzUp297U+uGqEdvfYpLl2eSZ4r5rNt1i9MBSzEJKA=
X-Received: by 2002:a05:690c:7486:b0:8b0:c71d:2b2b with SMTP id 00721157ae682-8b4fedae487mr20653577b3.45.1795037832273;
        Wed, 18 Nov 2026 13:37:12 -0800 (PST)
Received: from 5163NRD-SPrabh2.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4fe030be2sm24565697b3.10.2026.11.18.13.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:37:11 -0800 (PST)
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	viro@zeniv.linux.org.uk
Cc: linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dave@stgolabs.net,
	riel@surriel.com,
	yeoreum.yun@arm.com,
	hch@lst.de,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [PATCH 5/5] iov_iter: extract bvecs of user-backed iters from folio ranges
Date: Wed, 18 Nov 2026 13:34:58 -0800
Message-ID: <20261118213458.377258-6-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118213458.377258-1-sw.prabhu6@gmail.com>
References: <20261118213458.377258-1-sw.prabhu6@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D59E1A0003
X-Stat-Signature: d3uz6b1ha74r8xgehyz9xqm1o3kbnwf6
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795037832-30683
X-HE-Meta: U2FsdGVkX18cSi937etxBOYsqZH1Urt6WBc00INCFVJhY7FfoMCTo/NMl6JkDEZ8Y2NGRc3r+adrgrtk8xH3Hq3DfWEotiTwdyeZFLaEGes8DyXsfPZj04arFIf1hN7VTnk4aW0jUWv1Ylr1xat9NYr/ZNdilvAWYBB3fHmbkSmC6X3nqSRO2j50fKJ50CZh6OI0sd93r9AlxdDSO14I/Qts3tl8I2q39o1h2XKb4pMV/ULoR8Bm3qsuJLC47KF1I2mrdjrKj7EmnPT6x0QGJn0s/6yeAdgXqkHaeqg6qlxsPdLCsqsse9PO3VxdTzQo+XHR+EEN4R75rSjYjaUvyDFiN5hk3Zzae5O14J+AbyOMRUQ3EWduPz7hVQ4+24TKszY1HfLIMZfKiX1cT0uxizgYm3P95snKMoldqSZyN+1xYCzu9YZ3seqB3Tw4ofY/8tsZLP/j1izLl9eafdpculix/Jv2/3QsLiEiYpJWh8OIv2NH+84DW0bVroINJ4CiGLTAEju+YOApy4kfN9sWlkZGwg+VyB4j7SGiApkIgLNScJHej45ZC/CGl8fsZHfxUByrTa75osCLmThWnfqdaCgn/vGwxb/yiKKM1U5apwOkinXsX+b0vN3Cm6IIFqm4EC4SDeUvfawo/vjdWfzas8H46Znzu00voLR1WJBoTJy4FZhpXH5yu9n7kFKU3eifC19SY8CFYAKPjPLryGxWTmyUgvgFImWQ6DzMqn7y7otiMN9KwViV5aGqA8SnmXR8OGLHb/yqOhb2Ix8baCmTtg6bJEzifpYt+EpodJqgM7BIH7rGMg9ebIfM2IIyp3GPGoEg9Xp6iwP7IaqXKUYSPyejha0tx9FOi2DiO63rs/Ak7IAhKPOMtXQM7ZcQyFE+z7ZBhTOOmUxyxljpjlq/xCZ7brGbjtsmhHbFVBFtzBq3OEj8WO0buA42m1pqwoZRJtzOJjDvC0oLA6p/r6z
 TlblZHoX
 KW8za6u+TKc173UkFBt0UgRvoTu5thZhvCowP6g4VskpddA2KX8amQgJzZ5XaAk/NV4CpPnLiilkb7gA+8ZFuM6c0qi2P9zmBXYiXkxZ8RwM84anpgR+g8CVK5DKqoFNVG3kw5KNfvPJIl2RpuS2gYRUVdmULaKltrkGllgCT5G33H//pLcc/3ct8LQ3BHs8GxnG2vzVSyGb1+hlsrt1IwELYJrDMM06XeBAfy7CxmJudYhE/7hEwSrDMkMKMotgDW5gDkEPXD2DCyi8SL4DE0yBrVTOv4es28omGfTlUSyOQCOhAGZNxmRpHdrcjk0D0I2Z2saycjbcfHn4b1Pzvs4UTGdHF+mTTxDV08mwPxOHHU7n7WP6essN52bYvGuV8+tx75X5Yh3c7nyN5wrKc6BZjYtjYVwfFmco1Ddeja59si5ILZkK0+tV0RgudzGKZ2BHHUgWNLmbPtFsLKcLt8+aPsNHTwNqbgqqo4DkIaO9VMldz3EMFxwpgqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Swarna Prabhu <s.prabhu@samsung.com>

iov_iter_extract_bvecs() pins a page array placed in the bvec array and
then walks it with get_contig_folio_len() to merge pages that turn out to
belong to the same folio back into one bvec.

For user-backed iterators, have GUP fill folio ranges straight into the
free part of the bvec array instead. A folio range has the same size as
a bvec and becomes exactly one bvec, so each range is converted in its own
slot and trimmed to the requested byte range on the way. This removes the
page array and the merging pass. Ranges that are not converted are still
folio ranges and are unpinned with their exact page count.

Since one range covers many pages, the number of pages pinned per call is
no longer limited to one page per bvec entry; it is bounded by the bvec
array, plus a cap on how many pages a single GUP-fast walk looks at.

Memory that is not backed by folios, such as pages a driver inserted
into a VM_MIXEDMAP vma, makes pin_user_folio_ranges_fast() fail with
-EOPNOTSUPP when no pages were pinned; such iterators fall back to the
page array path.

Each extraction requests at most 1024 pages, bounding the amount of work
performed by a single GUP call.

Block direct I/O picks this up through bio_iov_iter_get_pages() without
any change to the block layer.

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
---
 lib/iov_iter.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index fa4fe2e92383..457e226c0251 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1919,6 +1919,95 @@ static unsigned int get_contig_folio_len(struct page **pages,
 
 #define PAGE_PTRS_PER_BVEC     (sizeof(struct bio_vec) / sizeof(struct page *))
 
+/*
+ * Upper limit on the number of pages a single GUP-fast walk is asked to look
+ * at to cap spending too much time in the GUP-fast path.
+ */
+#define EXTRACT_MAX_PAGES	1024
+
+/*
+ * Extract bvecs from a user-backed iterator.  GUP fills folio ranges straight
+ * into the free part of the bvec array, one range per run of consecutive pages
+ * of a folio.  A folio range has the same size as a bvec and turns into
+ * exactly one bvec, so each range is converted in its own slot.
+ *
+ * Returns -EOPNOTSUPP, with @iter left untouched, if the memory at the start of
+ * @iter is not backed by folios, so the caller can extract it as pages instead.
+ */
+static ssize_t iov_iter_extract_user_bvecs(struct iov_iter *iter,
+		struct bio_vec *bv, size_t max_size, unsigned short *nr_vecs,
+		unsigned short max_vecs, iov_iter_extraction_t extraction_flags)
+{
+	unsigned short entries_left = max_vecs - *nr_vecs;
+	unsigned int gup_flags = 0, nr_frs = 0, i;
+	unsigned long addr, nr_pages;
+	struct folio_range *frs;
+	size_t offset, left, len;
+	long res;
+
+	max_size = min_t(size_t, min_t(size_t, max_size, iter->count),
+			 MAX_RW_COUNT);
+	if (unlikely(!max_size))
+		return -EFAULT;
+	if (WARN_ON_ONCE(!entries_left))
+		return -ENOMEM;
+
+	if (iter->data_source == ITER_DEST)
+		gup_flags |= FOLL_WRITE;
+	if (extraction_flags & ITER_ALLOW_P2PDMA)
+		gup_flags |= FOLL_PCI_P2PDMA;
+	if (iter->nofault)
+		gup_flags |= FOLL_NOFAULT;
+
+	addr = first_iovec_segment(iter, &max_size);
+	offset = addr % PAGE_SIZE;
+	addr &= PAGE_MASK;
+	nr_pages = min_t(unsigned long,
+			 DIV_ROUND_UP(max_size + offset, PAGE_SIZE),
+			 EXTRACT_MAX_PAGES);
+
+	/*
+	 * Range i is converted into slot *nr_vecs + i, which is the memory it
+	 * lives in, so converting cannot overwrite a range that has not been
+	 * converted yet.
+	 */
+	BUILD_BUG_ON(sizeof(struct folio_range) != sizeof(struct bio_vec));
+	frs = (struct folio_range *)(bv + *nr_vecs);
+
+	res = pin_user_folio_ranges_fast(addr, nr_pages, gup_flags, frs,
+					 entries_left, &nr_frs);
+	if (unlikely(res <= 0))
+		return res ? res : -EFAULT;
+
+	/* We may have pinned fewer pages than asked for. */
+	max_size = min_t(size_t, max_size, res * PAGE_SIZE - offset);
+	iov_iter_advance(iter, max_size);
+
+	for (i = 0, left = max_size; left && i < nr_frs; i++) {
+		/* Copy it out first: bv[*nr_vecs] is the same memory as frs[i]. */
+		struct folio_range fr = frs[i];
+		struct page *page = folio_range_page(&fr);
+
+		if (*nr_vecs > 0 &&
+		    !zone_device_pages_have_same_pgmap(bv[*nr_vecs - 1].bv_page,
+						       page))
+			break;
+
+		len = min(folio_range_size(&fr) - offset, left);
+		bvec_set_folio(&bv[(*nr_vecs)++], fr.folio, len,
+			       folio_range_offset(&fr) + offset);
+		left -= len;
+		offset = 0;
+	}
+
+	/* Not overwritten, so still folio ranges; no-op once i == nr_frs. */
+	if (unlikely(i < nr_frs))
+		unpin_user_folio_ranges(&frs[i], nr_frs - i);
+
+	iov_iter_revert(iter, left);
+	return max_size - left;
+}
+
 /**
  * iov_iter_extract_bvecs - Extract bvecs from an iterator
  * @iter:	the iterator to extract from
@@ -1966,6 +2055,17 @@ ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv,
 		return -EINVAL;
 	}
 
+	if (likely(user_backed_iter(iter))) {
+		size = iov_iter_extract_user_bvecs(iter, bv, max_size, nr_vecs,
+						   max_vecs, extraction_flags);
+		/*
+		 * Memory that is not backed by folios cannot be pinned as folio
+		 * ranges; fall back to pinning it as an array of pages.
+		 */
+		if (size != -EOPNOTSUPP)
+			return size;
+	}
+
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far as
 	 * possible so that we can start filling biovecs from the beginning
-- 
2.53.0


