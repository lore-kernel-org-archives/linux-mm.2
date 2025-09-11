Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E446BCA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 01:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EFB38E0009; Wed, 10 Sep 2025 21:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7418E0001; Wed, 10 Sep 2025 21:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD238E0009; Wed, 10 Sep 2025 21:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA9098E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:25:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 924531DDD04
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:25:27 +0000 (UTC)
X-FDA: 83875226694.16.19C5C05
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id BDA8640009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:25:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B2PWpRTF;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757553925;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IBWw+7TFkrpbrXc8qs0EKB07x7xflQGNP5arLhvKP4=;
	b=IkG5WpEx+FzY5JHc51mDcGf2Zc3O7QKAgBkr32FaBLNIO2/TV58eCgsLUalLGdsTzObMzI
	ug4g1ROS59MzXRNTaQDUNga1jijaG5x3UdoJWLJKun2ZU7MsWbNcnD55Us2LLwAgHsx/sH
	r3tyjFctAGTuGj4dP27CMNj1mkXd7h4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B2PWpRTF;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757553925; a=rsa-sha256;
	cv=none;
	b=wvaxiEsvtclgziKWwp0+yCHlS3BjcQ99lKMprQCK2yWsygOHRM+3aM/Exitstm2IRl5VVh
	Tp0s2zKma+FZ63rMiqLH2ROBW6yENXq5hchnZX/PvkEDAm6jjXldBtfDOXwU972xg08yiE
	q9V3yX0ajsn1IXuWf1plW90UKqacEtA=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-62733e779bbso254929a12.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757553924; x=1758158724; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2IBWw+7TFkrpbrXc8qs0EKB07x7xflQGNP5arLhvKP4=;
        b=B2PWpRTFX2ybOOwnJtR6xJpyG9tYZaA8VXJhz4/yqms5aL+PEFzle+8/4eHQdBj+YS
         G7BvEBtb6xSbhqBAIGUdI0/2nXb95fmmD3RpruV8olYky+SXInlp1N7ROv/FDHbSNdsD
         NxOR5PnvGCeTXN6e93abzjxu/U0IHxVW9QH056mYsViYiN8upuJ6wpVh9x1Qb05BzPtW
         k1aMd+N57fXj8FTjD3vtBo+fBH/JRhsaBGfIuIce/kKr/4lySwUCPUt70BPuxRe0MFFU
         XSijg9scOWPAxnJ6sY0JQgJMa3KGG3f6bvdD5uyoKy0zbVPDRu9peuIIAzb3spf4g3pM
         T1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757553924; x=1758158724;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2IBWw+7TFkrpbrXc8qs0EKB07x7xflQGNP5arLhvKP4=;
        b=DOgU+rgzwB0OGWjvhS8gC/oZYxLbtZgehKa4VEFQofnNTf6XVXpYypM1k8JUK5vZ0w
         gdUijUd9011tUr8O+yCXF82KhWiMUkOX+ziS9d32kfM+7UMTqMxHKt6GlUHrOa8Ks2Qv
         kxY1ONlgjrZ5sJxr0AO+5xw272HVNuWMmTqqpCAYE2O6b1XWgPXDIN68WAsthzsw8ONV
         wvQvZAf3JwkRTpGgWoCxugCz15vI64ED36789zVW0rBvYybsjlJ0/wOcq7AQkG+5KQhN
         tPm26OHJG6wa4qjSHwZ4tNZL5ALL3jpRik7PqCFytfsOZx9LzlXHPLZczglfWDwGJrXY
         kg7A==
X-Forwarded-Encrypted: i=1; AJvYcCV+JlSiOIMDLAbxrcqoDNxSrt3GsBiDBMeE+zId6Oca/2bPa5CL6QGAPJ82kYkhpMkHIhfbH9C4Og==@kvack.org
X-Gm-Message-State: AOJu0YybWRr27EyV6DG2qQCRgQpCIy4Vdn1raEu1crsIczjn/r6Ce+wO
	9gve5bQAYjVFNVI6+UHxdScr1x/mKqUYHZtYbplUfeThEG731Xmq7273
X-Gm-Gg: ASbGncsAmjT25QQGw6xBkmLxfddJyJnQidHL7kl8ZG7Eb1mgsKNHZ7O8wVxt9y6gQX7
	ta6dlqF8xNAvSg95M81MWyCbOHSm83qlNaxzDV0ndfdzOe6TIpWA1Kg9YHy8Mg7/Ep+uaVmnMCF
	jH/Oq+ndhXross1yJ8CTYY87PYkRRp4VYYBu4NTb/FoYcT/+91ORzSia7yKCiorpCQ+n9vPrOkj
	kMWF4QYHS/UmEXeY6YZlJ2jTb2jKancY8VJ6H9i56Lv/Oe9D4SwaPdLuSCeBeR8yy2Wf/T3JdxB
	ZFir2O5ztdz7tjckkVOIQcX8jXFuKwDGGiDv5S9JHHlSi6Bg90ep7A7LhLActp1wJDjfsajdn3w
	UZrSxAKSXVC+dzOc5gul5f6QH0r9IRVPrDLOm
X-Google-Smtp-Source: AGHT+IHWOSXmwSCzpHQhPNANhYq1hmYyjY5oy51ES93vJl+RjeBZ5pglbMYMT3WEdFRAICEOT7DFeg==
X-Received: by 2002:a05:6402:3512:b0:61c:9193:a51 with SMTP id 4fb4d7f45d1cf-623801ea22emr15452016a12.33.1757553923905;
        Wed, 10 Sep 2025 18:25:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ec3400c76sm86322a12.35.2025.09.10.18.25.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Sep 2025 18:25:22 -0700 (PDT)
Date: Thu, 11 Sep 2025 01:25:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <20250911012521.4p7kmxv46kwz5fz5@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910092240.3981-1-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: BDA8640009
X-Rspamd-Server: rspam05
X-Stat-Signature: xj6hxwwzqw8si7smxmbzff7zizxobz6g
X-Rspam-User: 
X-HE-Tag: 1757553925-242214
X-HE-Meta: U2FsdGVkX19Ga6ZwAI+wuhYZD85Qx6oBgWHSJ+2FuBLokIsFFNmTe7vEkDUe1wCpIme0V0RwIIKaV0nPQLZMaBuEI240Ly/Fw+gw/e8mEr/o7SketdPEaAjKyrA7+XbjJtXxsQ8hJcFrMiaiqiPTrQKK1PbOYFec12wVBgutXqBPo9n3mJHnk+JhlnZlI1H9PLyb2dDsSNqyGpFdnWOCLKVu/7/vpShqU+CnRwnCKtP3Q+kMRnvF8e54tMKqHjCG0aeE0yUMgMb/Shj5qJ0T0dNW2MS8DR+mQtncFHRRzYPHG39XOIWZo72bh/J+2XrGHyVjZovOHMx5MjJxsVitjmygDrYaKpkAAlqDwS3IxTFnck9k+Z6oD0rkaQoofDreu54HT+005YbDdJAOv81LHuulZjGnKaM7lQuwFbZU2tgHHYeMqq0UuHTasuQ6fljZDCxLfyVmYOSQ9sg/0wJY2LXIaWjC706cd8uXYTsLi4gaq7VKSDutUH/m2wK/3uMLHQ213zwUiK1aFjOb32Me1iO9jmdZyxxft8S/kawxAAfwIW2wNCaqVNxk9OaJXXD8+jXuuagkNKVS0WEFkCciOLQAHqksjty2xlBlcHValJUDYi04gncjcRbtarpkxmbitpP5NfSOAduC7fF6lf4vkx6Awx68xS0R7GTp+hqyyS9ucLbf+I/DGpDeI6xZtpOiJXZpSCrrmdOpGYRwzfkHICVZdEM/ge4ZwpzExtsGNvCPGPRePEH4ZT/xBmxL+akzFMxpBhDIuV3a4tVE3GWOtFkDByxCakgDdA2tWsRO8zBrwB33O1p7h7iWNbbQY9uxkpvo/BxMJePdg/a6GjG2KqdC/zQXVoFRoIRfVN4cOjJEsc/mvVKGeydOpzMsD+ksOBR7skhrZZrm2mnRxbxfdXeXf0ceAbHYylJLBxkyIjVSI3No3mTaMk8rtu5C9kssP/zLBmiNX2KPtU5Yl4F
 KywLGMqA
 cCOsDnC/kx865CyYY951HpQXsADtxokig88nyLEWeHsEkf9vg0boakrkRcjYvt5fvezcv1HhH7iZ+TJjqxGj8VCbKcAt1DfkxGv38d3wg9IjRnERDODBP7MDFX6zQ+iJE71ulOaqzcr262mI8LPMrY618wVKazIt8GQ4Cglp6bph29nsE31U4CqTXbc7uPMl3pFwmanp1VAuKonaVCwpyxCkw4MfJAnEBk8vj/4EPP9Uhr8zWL6+yPpduGBbJD0XMm/am/COEGpH67oJkARdvMPGdKQcj8lf/51u7JM+3GnafhrDpvkIFALYLd6N+fRshgok9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>isolate_migratepages_block()") converts api from page to folio. But the
>low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
>to head page.
>
>Originally, if page is a hugetlb tail page, compound_nr() return 1,
>which means low_pfn only advance one in next iteration. After the
>change, low_pfn would advance more than the hugetlb range, since
>folio_nr_pages() always return total number of the large page. This
>results in skipping some range to isolate and then to migrate.
>
>The worst case for alloc_contig is it does all the isolation and
>migration, but finally find some range is still not isolated. And then
>undo all the work and try a new range.
>
>Advance low_pfn to the end of hugetlb.
>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
>Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>Cc: Oscar Salvador <osalvador@suse.de>

Forgot to cc stable.

Cc: <stable@vger.kernel.org>

>---
> mm/compaction.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/mm/compaction.c b/mm/compaction.c
>index bf021b31c7ec..1e8f8eca318c 100644
>--- a/mm/compaction.c
>+++ b/mm/compaction.c
>@@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
> 				 * Hugepage was successfully isolated and placed
> 				 * on the cc->migratepages list.
> 				 */
>-				low_pfn += folio_nr_pages(folio) - 1;
>+				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;

One question is why we advance compound_nr() in original version. 

Yes, there are several places advancing compound_nr(), but it seems to iterate
on the same large page and do the same thing and advance 1 again.

Not sure which part story I missed.

> 				goto isolate_success_no_list;
> 			}
> 
>-- 
>2.34.1

-- 
Wei Yang
Help you, Help me

