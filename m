Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CC9CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 19:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CEE6B0088; Wed,  7 Oct 2026 15:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83DCD6B008C; Wed,  7 Oct 2026 15:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CBA6B0092; Wed,  7 Oct 2026 15:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48EAE6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:47:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBCDB4034E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 19:47:20 +0000 (UTC)
X-FDA: 85296864240.10.9A14954
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF7AB1C0007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 19:47:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MCNvIFsd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of okerixx@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=okerixx@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791402438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2GHJQFkiFJ5mQWKvTUQeafsQByOk6PW986HTt8vXuo=;
	b=O4KwNdUWMe6MoJJzzNMr17Vd+ergYQxR9xngrV5z0VCvbBawrKbimdKMfPXSJmhTaNAbKN
	m/6DJ+4s975WX7UbTM/3NBLOHm3gHZarvPvKYKKdqzIgGQPGuxv4rRX3VlG7NtVB2ii6R6
	H7PQwTyqOmh0cGWGn92eD6lciiHYCsY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MCNvIFsd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of okerixx@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=okerixx@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791402438;
	b=sW7ahxarH2iwWE8B6PzKa/si+n7U2mGzLJZ5IltKpVXuv7RbzG1ZsEJLE8Krl8J/KW0OkE
	14IN2vOMqLPKBg4w0FP6RgbOb/BCnMtmKPmyBo+BCDv+aFra295WlOCrcAQs2OdF9rLnnR
	6KHRiuYzeb1blZKwa2H6ChUSjkcPkk8=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so14623865e9.2
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 12:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791402437; x=1792007237; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R2GHJQFkiFJ5mQWKvTUQeafsQByOk6PW986HTt8vXuo=;
        b=MCNvIFsdviUlAdY5/bMRR4+PN8+/Rit4DfpmKeiq8qcWd5BENN0XDInC9cKDLfmznX
         seKij2ER5daxEmo1Q591OAzmELxyO/R2/oE8K9dJuWd9uzapVa25Zq+uRse/yKr5DXde
         1opHTXDVdcD5+6KJzTvQwMyN/9SWi/XM1v/DHjFttMnAtJUyYhvXOqIh6AkbQ2PwY/oO
         7odxn+YVkxFepvIREHYxPOHVD86GZYCF181hLDZ6KOol/zBfWsS0oPuS92nCHTcKWtUs
         krHujN2FMgXTC1a0fObTgXMg1eZSEHakgqUtUARxR4NtQI8tlDEvc9sbuQWhMXl6Wlpa
         hJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791402437; x=1792007237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R2GHJQFkiFJ5mQWKvTUQeafsQByOk6PW986HTt8vXuo=;
        b=bYSQjZ4KqAz4lZpaKrhjKZhNb606q1ECFA4qnA+kpS7TNP0mt+Qk5sKYXZQhvAcMv6
         ghFeNIR5Awos/+ewJSVkF6B+6JXfTnQ4L23SZ1Ed8+HBWml8Wxe13HGrSThJYEW0PwyT
         PaDjQJj0PyMmWaYCmGMcNHIPpzI1Ljc+k+G9BAvHFywAyL+mYnEUhRsjyuwxaqNkwieH
         tUennPdDMqXZyZ51QTqFYH2o8zvs7BzCrM06H9NJEg+B7+03TeWArlasg18yQyoGWd9s
         Lw858Y5NTDpz05V+OAInCj7LlO1lVaHz+1CLlL12Qpqbn+49mIlAir0MG+g+d2bZg5o+
         JnBQ==
X-Forwarded-Encrypted: i=1; AKwUvBzTuHtpBeZr/jKhBnB7JD8GR7Nr5ulaAI2pJBQ5Ql4uqC/o55VSWV7/VHPykCRGrFt2vOOD4nNASw==@kvack.org
X-Gm-Message-State: AFuF++kq1uI7LX2tqNJNk10m1pl/BXp0blU2l7ikygCbUsYof5YOsACt
	KiAOEVmIABuoB8Mb0uTb+pSCV1BlE08OMGaSw0T8zuTmefswJUIVi5Tq
X-Gm-Gg: AYBFou0mcHbpWGZo++QTcOa828wNuzNCmrjaCagdLJ9ioz6hx5aYZYDsOOWySDJ7W5a
	Op5pG+Sidfg0UcPnJwOL62oeOUa+7dRkTb7epGFCyoM8SepD2gV3HhGCh5aN7ZgQivocCcB6tE/
	p26x8N1lNCxnyNzlDGG6niaoLo95htvbrLK5wf1ZguIerv7GCblsAVTF8KzqPxlY4LAYyABpZ+x
	vLVwv4BS/exuZoFZYb0uXeH+zxRxpGQloWxIfc7UGNuWkmwKNxJh85cpnT6dMYA0fLqcs5vcAeE
	6sw2J2AARBlLfepmXs1b6Rb7fpNsDNiKws5IUrojRnmo0qhnL81qEXCdAwMFvtEGP7pcLtWFa4X
	bFFZAcCn9WY3bvYF9WmPHGxQAbX23h0YIeortck3A23odTPeyayuizcVsVYz68sTctPL0a4o9i8
	rPaBDhJnd08ZO/leTCR4/vSPru2ej7yM6nAM2dlGCYQEstsIQ3s/n8igJ1XqNpjztYN+y1EoKTF
	w7Rbcb5tA==
X-Received: by 2002:a05:600c:548a:b0:49e:6c11:c4fc with SMTP id 5b1f17b1804b1-4a180313b7emr52167125e9.7.1791402437226;
        Wed, 07 Oct 2026 12:47:17 -0700 (PDT)
Received: from localhost.localdomain ([94.252.75.178])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4a1843b5a2esm13117835e9.11.2026.10.07.12.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 12:47:16 -0700 (PDT)
From: Oleg Keri <okerixx@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Oleg Keri <okerixx@gmail.com>
Subject: [PATCH v2] mm/vma: keep the unlinked VMA off the file across unmap on mmap hook failure
Date: Wed,  7 Oct 2026 21:47:08 +0200
Message-ID: <20261007194708.2009-1-okerixx@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
References: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r76eyewi4aa8ni318smd5chpmqmtxdte
X-Rspam-User: 
X-Rspamd-Queue-Id: DF7AB1C0007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791402438-660784
X-HE-Meta: U2FsdGVkX18Khqw3YIn7sX3aoqaOwstCZ+fk02cBobD5UszZhwIgVX92XzAQhmczANEsow2VwL69tNcPJTQMkxTksHdbowrnp2IiYVPxJ3SJQutssGU5thUZKA5G8G+PQb0RMBcoJglA8RkAwuCAeKP2RgIttmEIb4hJmK0urIR+hF1uODvlVWXlxZgWdQIu1GTP5yI3QiNA5RmqOzLogzVfQeIXh7un8w/fEOl4yKkO751c3fVPZJIVUOzm2qK9AT6k2GL/OEFYlb+DxmFaHjJhAp4h340pSHXr2c2XQrXEPX2xUfGiWvBCGCXle1DCpVaYMcPVCl4ELhQ36wD3bmVDEkb2uyE0vXnUoTrsutwQ22yyEQdf+IbzeCJvQYeVUL1jcP25c2CQ8D+lZlCZJJBYAfKvNBAt0P/DmU+dJZ/oVcHhx90Ji4/mQZqiw0141uBGCmHzpyUi586BTMZyr23R8EZ6hfJYHSe2uhdrsQphMHB4j0aX0FZV0RaNYdFJB1fuLSQY5HTz0y/Vv8iPKrsdYrXzqDFN9ghnW/XoqF71WcWXz1R35o92Swe+G5E42CKh1k+qPDtIHOh+dFE9pOHs+QTUQnA49iIPmBrAdS+tjNqeQRN+O1rpZanZSF5GUcRzdg16cWE6FEyBQakge1XyF7n6e8bYIvnMOV1/iMwlBGxr5ap6rSTtfb4K+8Rkp/HIcCGHmZ9HMM1pvi+qi1PU2Mmc9SzXq3uH4+srskYBksXfcXlpxV6DHDeDWgaFS/YtXnw7a9zUX4vzhOBPCp3qcqf6smolmgsfMbJvCUfwuBwxSq1MaL0PLXFniYpQ140RQFdyBH4MN6yNpslKlzsDqt3bOW8cA9jRJQpm22ugpdOiXs7L3ywZ7wosBLhOEY7FxQ48oXNP3C8Em//fIyv1MvsVXAj2Mu7PWgCWUGP6aU8f219qMF8CGw9Y9JDPdKoakz/6AtFlVjo0vPY
 GMM2IES5
 tN5jnfPqCDRzKuG+cclwD+EtXaSgBkJZCau5hLNRH0wZ+mD8Vr2MDF7BTwKA0yTCbFa5z2RfKS6qBm+yW8gaVT3DC6fbmTFd4DIoodgtjbQlqc36Y6FLN5wjbcDaUNfRf9OqWMMOs0UnsnscZsHv7VhWERs8TP/Bhe82m9qv9IK8luDvgqtnAeohiod2n0mlwtWxcFSOc/6buLvnioajZSkiHrSS5iNpjpEs7gJpgqmnJ6n/USA+AdCUWKvNue94HW9Qa/vL7uYDcePdY075LF4Vl1UnvfiNXhTjKctttSvsCDGgZEXbBj6NQNYCEOezSE1XmolOIuVN64+NlbkE2DOh2B1cyzqy5czDhJOlLAbNWRvZwACNx1kMBkExQbSPqrfEsrEBPl2Bq0XsVR1MVxtwFF1mEU5YzTWRS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 2ceb21171dd9 ("mm: consistently validate VMA state after
mmap[_prepare] hooks"), the mmap error path clears vma->vm_file only
after unmap_region(), so free_pgtables() unlinks the never-linked VMA
and drops i_mmap_writable. Once it goes negative, every later shared
writable mmap of that file fails with -EPERM until reboot.

Clear vm_file across unmap_region() only, so that free_pgtables() does
not unlink a VMA that was never linked to the file, and restore it for
vma_close(): when the hook succeeded and the validation failed, the
driver's close() still runs and may use vma->vm_file.

Fixes: 2ceb21171dd9 ("mm: consistently validate VMA state after mmap[_prepare] hooks")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
---
v2: keep vm_file for vma_close(): with the hook succeeded and the
validation failed the driver's close() still runs. Reported by Sashiko
via Andrew.

Seen on next-20261006: one refused PCM mmap probe from alsa-lib left the
device unmappable, so PipeWire could not play anything.

 mm/vma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index dfa45c64222c..531e4f53fdd7 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2616,12 +2616,15 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	map->vm_file = vma->vm_file;
 
 	if (error) {
+		struct file *file = vma->vm_file;
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
+		vma->vm_file = file;
 		/* Only safe once unmapped. */
 		vma_close(vma);
 
-- 
2.55.0


