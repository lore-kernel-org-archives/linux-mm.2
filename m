Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FC5CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 08:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8554E6B0088; Wed, 24 Jun 2026 04:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DFE66B008A; Wed, 24 Jun 2026 04:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8BE6B008C; Wed, 24 Jun 2026 04:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E30A6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:24:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B71BD166D37
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:24:04 +0000 (UTC)
X-FDA: 84914118408.18.BB5FD0A
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 09A2480004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:24:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="igb1s/Ec";
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782289443;
	b=th8Z0lul6jDHI9bOfm3S2XYbeU8w+LTifce5x7MBPd//Lx5Zka4fO8Pc8urcUsCQsmVNFX
	MZIBhkjAX7tRYwovDm8PLBdEocpZsM8pizDxx0n58dqxCQ4fW4ulKlr0Fd9Dtlc1jNj4MR
	LvHEpSYYrjWqG0hPbruOeJzews/ysRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782289443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=tWP7IzCdIJU+lsKZms/Ifmnl0VbZlVFCYljzbfgyW+o=;
	b=iMwpVPyA/U7t9nZdG1E5MjNTUA1wKSsMPkrd1R3NyaaQZNw6+APMDo9dKLKjongZeCkSin
	zigbp5uP66sRlT2sKXGHDaWiQh2fnbhG5172+SBogn5jhfnnxxNlK3JLie2KYVA1am9Mgh
	ozI+NSrSDHxaZGXLVjSSHMcvpGZBLb0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="igb1s/Ec";
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bec49f7e35eso115842266b.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782289441; x=1782894241; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWP7IzCdIJU+lsKZms/Ifmnl0VbZlVFCYljzbfgyW+o=;
        b=igb1s/Ecdxalr3aDgCgDYT3MzHRMcpmMvZK8eg7wbmV54shS3uvpO+edmwWKh7S/Y/
         4qDhxGYY/tL0LZzAaq3kDwVIiXh5lQ17ewwvyCwSjg2ZAPu3017tG73csnAum57Jih+9
         vWez1eUUHBmnnDOl+n+q36qgIwq/HPLOD7kqCcmLsVWWersJok1nzHdT5L945oF4sM1/
         s0VwgEq8n644OKOGSZog6JolXnBfR+qGMruXtinI/NFkf7k8b8l1KCFg7xNh26JDAaWS
         HV6B+NUOvwFtIDLPBAiwT6jP89WRqf1ajx2AIk80RLRqkKKnWM2YTtAbBjkK+275l+TG
         Ir7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782289441; x=1782894241;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tWP7IzCdIJU+lsKZms/Ifmnl0VbZlVFCYljzbfgyW+o=;
        b=Q5WRYCq9fmsc8JHFoW6wo8dh43RRobWvwG1OQ/9oTnhr5cZIoSLVTLWt0NaiMBlzQi
         Ei/Qf62V5UyY8CqBfsDxn1Khh1HjfU7i0BCksuY4LJF4phC+S737pZlR5EwSRDvkm321
         nPKkHMDNwjQkDADzdM4J4sAZLI1bipL8PkhePw8CT0lOcrQzV81zGDyVzLOvIDb+TJ82
         ufri+hvtrV2ReooAPXYmtHrzVIdvBqJO1dDxw/I7tZrMc7AVp3uwyDrEkgj/7wl8GAfb
         l0AbuK576HiYH9B5bnL4CTSiR82sAt9XGP19VO/W5NsONcnih+B2+l7zOMyZ56gNdtWz
         BIQA==
X-Gm-Message-State: AOJu0YyRdZsFQy5zqB00IbBrF4SlQ2Mg1Mn5Wzi9Q6QuVu9p09gzalI9
	pXDdKE5FHmJ8vqPQVONS3Y7jl8KiUWhPa7VJ9+czuPhqXrAuTn59ziUD
X-Gm-Gg: AfdE7cnNIrwz8K2qvqkXpzd7wFW8119kpeS6UFtFOd3OQ5PxrU7YCjy6Ikmk7/hsJ2V
	OGpVAl/844/Dra9dr/Eg4eYAVmaLTHWZVcL8HY4kUaVc1ADUBxVOUE4XAJFES4RYk26YKjhREnF
	YBBrDmmI5DCY7zA4V6LFhzEp5dsnmT9h7tqml/NZ4a2YuM/NvVZqY8gi7FmJbeTb3pghwoo3Gwd
	KYosH/5Gi94Fx5O9n+C+jfjIrxiXjjxwgCMlpryRqgG60qsjJFzg/m0vdfX9rN3YKOjuqbyIJ0n
	wW3vXTnZfUzZX292pOMENcBDyTfD3NpnvHdtk+3uQUBSPk4PP10QhbikgHcUTeLO7+GLVQ4JERc
	9tZaaRM7I0tTPQTXJwPVT8JCqw8xBQJZe2HS7whsu19oT4/8O/4igy39DNrxXfEBhIqznYCUgMW
	P/dGdvjmtqm20=
X-Received: by 2002:a17:907:180d:b0:c0c:fb79:ef83 with SMTP id a640c23a62f3a-c119de55743mr107572266b.19.1782289441195;
        Wed, 24 Jun 2026 01:24:01 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c610e5280sm630392766b.53.2026.06.24.01.24.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2026 01:24:00 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	willy@infradead.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lance.yang@linux.dev,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/page_vma_mapped: guard check_pmd() with CONFIG_TRANSPARENT_HUGEPAGE
Date: Wed, 24 Jun 2026 08:23:59 +0000
Message-Id: <20260624082359.2869-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: ds3r6b5zu41rsn8tmd7q1i3paujcmue4
X-Rspam-User: 
X-Rspamd-Queue-Id: 09A2480004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782289442-863981
X-HE-Meta: U2FsdGVkX19+UN400LEl01ZphfkAB2/QynqTF9kj9SG+fmfaLnCP2gOD+nPca7E8R9h3brzLHng7tCQn1ol8YRo6MobPaK67cKZ+mhUfDTCUQAH2drqAbyypxB3rEXyBwSwhP3dNRffFjyLNKSz9WuTfT67ZzTZjS26CYMkTxaoWM81TsDVtBxz/ZQD0K9uaLUrAK+6U6fqc0+3rjKEQ4QdUASGoIv9MXtbR+FcErbp8krWlEh2hLMednzjdV4YGKVKsoswNQjpEdZhI20kxs0EVUy4W1rLoTr0zAuAJBTaXB6TOSr4rZKYRB9CzfxB/8/UYm8QXb1KkJcTxDW0fdW37sZral6Vrp9WIXV76BP81NXItmR6PY2K9LKo88EuE6uQrXzNYnEGBL154tE28Z/wVqoY1GhZJRLoZXjmNtxDExqtWVODmgfSSztVBCwjKIswl/srXqbJx8Y5By64z1+l3+nWad2Osvm7DjFBze3YbEMsJW5w+e2MJ80oCyriqJFMCxHPpATtS1BpTxESa7TKDTvFfPGX+uEGSrcFtUW7PFpeGJYNC+udZN2A42G7Zw7hj+5y2QJ4I/0QgjoUEmgK8SGok5GOCQwdZWY4TRxnuPtdG4+YUTo4EIiJdehC6Ui8/L868Wss7uPGvrbq0yDGrbwzuvb7EONBviCcpzeiLgd03iJjPFLg1r9e78j0SbQ73n5DURIfMkctZWOmNt/KcMMjZK72+G9C3zxNA8rTV032hEMBrulJVmkI66jFnN0RpQk41Y6nt3lmu6l4an3LE9QjOwXNZw2UZ2x8pyENXx0wijuItv9JXHcGwze9BUL3mWGalqMEo5CBFVR7j/7AgMFoLDv5CvBVNgQjAd+67e8bkDJygrrKXeXc60JXlKLNbc/+fkbcsbyBakrz4q1HpzTNHTGbMCX+o4M6N3I/ny2c0eviX5Fy7ddSoYvjXA/rFrC9ATXeXzlZmXKJ
 UStycvje
 zqyhMKQ89hUq0CoXN4tIN5AJiAB4vFmPWOvH9kIMQSKXpuulchjjSxC1tW2gmLtOZPQWoD7EfkrqhmmDK3Cp2X7O6gyy9i6Pz2r3cg+qt9WwMWMF8VDE7YbshOTwx0I4jozpw12yWDW7b2Zrdkt2f0PUvm9iXqKrhfsCPuadYogEKpHnULBgaT71xQ7mRKisWk5QFqcQhuXQalWyu9ohNJVIf87OvlFgBALGvgnug0lETn5R7BncmDyM9m4ayq+UWyybRugKP/kRypir2isH7KUctNkLRgTjziUATCtZQIbuqOw8jaCkpj+C+O/OiNRqYvSlz5e1fo0nVZgoEbCJK8kuWFnpFCIVcIGpkm6gEY+T4zMvW0uYRW1545c7sAPwNS77fDWlbQa6F3Byp6bDnXzn4KrxnX24VQ9Pz6TahVdvV+kMR/dPm6z7IDi2Qib16H3CohQ1qjlsmufL+vzPyMHb0q3moIII2AJ3Qhr3FhZ06SlCe0IvaD3CVz8dNU8p3ZIiTUUMYa9WneGOKFblqKAdXxiANxJx32E/H3kgvuWz7Twvc/wE6UohB08Zzuakl6Ow8gjC9qyWa68glqXVPINNGXq9KwtDGtd6Von0DXYPc6w64V1WJyaNBDNP6xo+YrhyrNhbKwJ4/Wz0L2hpAQ1mhgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel test robot reported a build failure on the parisc architecture
when expanding HPAGE_PMD_NR in check_pmd().

   mm/page_vma_mapped.c:142:13: note: in expansion of macro 'HPAGE_PMD_NR'
     if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
                ^~~~~~~~~~~~

The config [1] in report link shows neither TRANSPARENT_HUGEPAGE nor
HUGETLB_PAGE is defined. Then trigger the BUILD_BUG.

Fix it by define check_pmd() under CONFIG_TRANSPARENT_HUGEPAGE.

[1]: https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/config

Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
---
 mm/page_vma_mapped.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 17dff8aab9f9..4aac94d9e8a9 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -136,6 +136,7 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 	return true;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* Returns true if the two ranges overlap.  Careful to not overflow. */
 static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
 {
@@ -145,6 +146,12 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
 		return false;
 	return true;
 }
+#else
+static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
+{
+	return false;
+}
+#endif
 
 static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
 {
-- 
2.34.1


