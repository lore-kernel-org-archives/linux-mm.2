Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC3A1C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01FA6B009E; Fri,  4 Sep 2026 06:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9E36B009F; Fri,  4 Sep 2026 06:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF08C6B00A0; Fri,  4 Sep 2026 06:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA046B009E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21615120812
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:35 +0000 (UTC)
X-FDA: 85175748630.17.0B5B285
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 47D1510000D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=isV2IgZu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvyd01m5FmUtu3q6l/t0/X1UQi3FbzSuZHwJCHFz3QM=;
	b=LRjLKYlA8OCqDL4uzdIfOGRydYki7JEJY4Ck/nOMVDevECj0zNvSiwseWZ7qF9gy/zDhXu
	xL85Eprpr3CvvRtFxuLftm0tEr2U0qhBSFmqfsio5AJnt/C4dHXlwicBuKysmxS1JD3Ge6
	/tpNy66GGlMNmrYH8enBfmqEhT0TloI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=isV2IgZu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518733;
	b=GAjWj+GktKWoDY08G7xlbGp65t+hugtskjeRc6POZut5ElQUmclsoKYexBT25gz4YXXPPU
	3wnAPfgmOWERiZ3zAUlAwRRZrTec36qnJ/yFuXSTLehHqYzMSxobHzxGVN7dwuii+0voSL
	Q2FY6wlDhIjCUqf7+6vko6lgnxvxdXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 949B043E5F;
	Fri,  4 Sep 2026 10:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACE11F00A3F;
	Fri,  4 Sep 2026 10:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518732;
	bh=tvyd01m5FmUtu3q6l/t0/X1UQi3FbzSuZHwJCHFz3QM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=isV2IgZuqaEj8L6w5TATquMIISnjgvRvBLrttVMb2J3/qELjt9chFPiUY34MdPhYP
	 U28wPbZT8ogHrGtyUr5RJLQSczYHZExyBqdqMTuDI4gEZeqEhLhF7nUfxbbgN5LSLg
	 WpGf0U5aqCH3nfFsuGuAY5TAdMaRGNYw4DPjF1ZLmFN3bIn6UXfe4cqWr+MNfTnNvu
	 S6KbiqTp0Jv0ibjBYHeuTnW7BAKozymnTvHSpJwEHw8uX/NLpZSTc44eFq0eoqawMc
	 D9BkZU83noFXqptzh6Me0L7ADkDCNvLNKqKkWO6JZ37eeSuyw+i+hWbz0qXVlN6AGu
	 3HNhAB4yeUGRQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:44:56 +0200
Subject: [PATCH v6 05/12] bitmap: Add bitmap_allocate() function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-5-79042cfa8de5@nvidia.com>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
In-Reply-To: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Russell King <linux@armlinux.org.uk>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
 Saravana Kannan <saravanak@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2300; i=treding@nvidia.com;
 h=from:subject:message-id; bh=wRtcGoPPtBVnuqzylzx/Ya02XdoWLRjgy09wPiiWfTU=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE6FB7y46zRAFj+W91sU31vLRZ9vxOWfwPV5
 Zl4kuw26HOJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOgAKCRDdI6zXfz6z
 oeAMEACJJndPxZkKMt6p/5hvrc40QBNDQZ+kF6WmhtnFd/6EVpvs0pjUb8O3if3mkq4TtTKowKz
 kIuYwA01ot+/ztJA5scT5H/tCqLx/Qds237aUUTv/IzEoq2K4YW/FlTvmXelPijG5HS9T+GeFXV
 RxODMakq1BUp1WBx0Fvx3tiI40Ukv9zyhQFgNYpIld1ACRlTawrq/ce0NYFwF5wGFaPKkbsEIO3
 SOwvT5W5s5BuxLJknJq4AaldPvitW5S1LIvagCvP3/wQcvXSXufgOm2MlU3JOi4viyWwRu/L2+C
 u50xLPvsNEVbWot1lKc75AvkNCcJCtowBhIl8x4HKN+ilKWv8A3go2jvHFSqTIOLCbJmV1DCO5F
 RTJIpj0JWZPUkl6xqHfiWzgFvJJTmV/So6PtCwG/dbYDI5ngKGDvuEB0RCu4aOfMpiQuiyRs18f
 SN4t3ERyRKbWzjXimIPHFupQdwDQVNb/5niYY7HikDSTPJCaZTf0B+qjNaNhchJg+AbXBtp+LWN
 P1a8VilssiEkbeQ8/uw8IMefrUeaSKo9DQyKqMeWYyGE7jWqGUaTQxkTCPSmW+oxhEOq+xpjKac
 +RjQa8xpetUONC0UCwaBtDLZywDwGF1t7Itd05IGfD+dCnNPAW/gg0w+Wz2AIRM2lKYSNKwYNJx
 MloyP4fy9QyiMYw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47D1510000D
X-Stat-Signature: 93bce4ggjo3uqa7sm36poxipkcnsddux
X-Rspam-User: 
X-HE-Tag: 1788518733-741817
X-HE-Meta: U2FsdGVkX19ngmVItfzwicFEhucjAEJw+8uq4tkq2vpjGsFoRGFFaZ1/nt4cvH8cBOceZqg1qsNWx3h9xhvCKEVw5Ghaeve6RH3c/jDf5YqwQhSZH922NgtW67DdcIpPUxUfuwYtgIYHYEvbFYK1XYQNCIgwyOBbicr/kM3APKgPhuPNCOzJDzxuxF/Bp2BN3Xz5Z5XrgPZUEBCAFwbm1pHBP8UWYexvxkZQpX06+mC7rEhBaFTayNzDHgCNYDHA+m7ZdR0GI1Ko8wQNqWi0mEg0GqgO7OKVAjILBuPEkJosGmB9O8Kbb8e8/36YrneitmLOEAjJ3FIGdzzPi5nkz+QGEAEyEA30j+rBhuhWiz04tVXUlJxFeqUKvJ1xYYmX6bjk+hRHjwVrN6JW4q9j7hw6kMLRb40WM6gyw+aCdnPQmhRMimsrKoVJ4azi6t4MmEtgsEAsh69DlF5k2mxUdNu2d7FdQIaQXVLYAAsNxN0F6NrGtYl+FfYNknGujygxdg4MK6mqCmbeea6WTYoLx5eoZ1dDaHb+BHJf8yklPq9G6l0g4cQHYqNB+tYkm7TjMEpDHUMptiC0hf9y52qs9GHTfT3f6gS7Et0m6POZsi760qD3q0ofuTPaQ8QgbRTRiPJbry9w9TNkY57gfrQs0RgdzmP9d4rOKhLMPtsBs7wPVakmrTUhtpLfTtUni3Mw26K1ReJ6OQqxqX6JihZXmU0pY7+j0XmN/2US/r6dtWxsAUZLbxqIYDRs0iML62WujWzmpAa/0lwov6UXrzxvC2Yz8k7MXuGTq2kNJoKGClcZ/YwxJmeucY7YTn9nr48rbe/ie/oD5AcYjvOLHAdJ2yXcxYaEI8E61DPL4cEwqrsth5E/1GfInWKWEbcKBOCQc6vPtZGSUTrojOc0acTHshkYYRkEoKxhvqmU76n3K8VmfKCngrqCrzB1xLeu+eL6aSf5UTiOKuTZtfmLiIm
 4Zw+PUhb
 pJy1i3wHr7sDZ5ViMrAB091qYK7cwzREH1+H5q5wrddFxb9vwxC/ejV2pOUF0ZtMpzIJpoLMgdlzrZJN1N1ci6EmGEpJN/C1/yIRptphnJ8oU64NlgA07ksipnMc0zKio+H7AuYsLmDuR4QDd3WzHvpceKfPDTJtRHPPb+MUeATWXhN4MVAG/yU67I/r0eIPfMpgRd5hwo18SHGtEKC5OV2xSymaPK8+Gipv8xcCnymllVOMmATHyREcb0e7QNT0xReZ7Oj1+KkNYD76rCSqLnYp7OTUhCHwctwtXOPEyMt4W1826PuglKk9E4CeAeITOewtpWz5TmQhFJXEr0qJBZH1CIz2NoR0+fiQzyLRt3YWF+Nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

This is similar to bitmap_allocate_region() but allows allocation of
non-power of two pages/bits.

While at it, reimplement bitmap_allocate_region() in terms of this new
helper to remove a sliver of code duplication.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/bitmap.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7df1573a409c..c2ab02985b5f 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -716,10 +716,10 @@ void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
 }
 
 /**
- * bitmap_allocate_region - allocate bitmap region
+ * bitmap_allocate - allocate bitmap region
  *	@bitmap: array of unsigned longs corresponding to the bitmap
  *	@pos: beginning of bit region to allocate
- *	@order: region size (log base 2 of number of bits) to allocate
+ *	@len: number of bits to allocate
  *
  * Allocate (set bits in) a specified region of a bitmap.
  *
@@ -727,16 +727,31 @@ void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
  * free (not all bits were zero).
  */
 static __always_inline
-int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
+int bitmap_allocate(unsigned long *bitmap, unsigned int pos, unsigned int len)
 {
-	unsigned int len = BIT(order);
-
 	if (find_next_bit(bitmap, pos + len, pos) < pos + len)
 		return -EBUSY;
 	bitmap_set(bitmap, pos, len);
 	return 0;
 }
 
+/**
+ * bitmap_allocate_region - allocate bitmap region
+ *	@bitmap: array of unsigned longs corresponding to the bitmap
+ *	@pos: beginning of bit region to allocate
+ *	@order: region size (log base 2 of number of bits) to allocate
+ *
+ * Allocate (set bits in) a specified region of a bitmap.
+ *
+ * Returns: 0 on success, or %-EBUSY if specified region wasn't
+ * free (not all bits were zero).
+ */
+static __always_inline
+int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
+{
+	return bitmap_allocate(bitmap, pos, BIT(order));
+}
+
 /**
  * bitmap_find_free_region - find a contiguous aligned mem region
  *	@bitmap: array of unsigned longs corresponding to the bitmap

-- 
2.55.0


