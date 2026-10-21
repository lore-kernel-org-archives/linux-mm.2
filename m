Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F1D1606A326
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=b5Er+Ofl
Received: by kanga.kvack.org (Postfix)
	id 205536B070B; Wed, 21 Oct 2026 09:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC1F6B070C; Wed, 21 Oct 2026 09:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B906B070D; Wed, 21 Oct 2026 09:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D098A6B070B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:24:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2E95A80C4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:24:51 +0000 (UTC)
X-FDA: 85346703582.09.445B178
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id D140FC0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:24:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b5Er+Ofl;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792589089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSlKv0ToGAeQ53lsfFOtI0+sE635JWib0pSuSvkBPtk=;
	b=WUrtoNAgkCVon53lYOD0Gqul3ybSABats1llEc3gvmQHYNZzeOv05YP1BwS8L9DkrijCgs
	T7Yf2Neabe4AOoCI+3QKaVwoYPwixIIGzsU9J8e95L14o3K59bmYqJQPDcjMgd/q4OV/rs
	fUHVsSBWUF706/yfNsVrdthObeT+Wok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792589089;
	b=PsROj8S+vgH/rPrV+adPQEIsNCsWS5Jcw7NaDvCGhHgsM4yznzoZM0NfbCGlCrr+0OtzlH
	E9dbgxDdqNDSNp4xfHmR4xIAulkr9zy/LIoQRBPHO6G7erTMEvgNV4p7NFaOVu7sG48Tfz
	6v4+A3f6qCDe8nhCBTcFESpja8OlpCc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b5Er+Ofl;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93e4c00d71aso80280585a.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792589089; x=1793193889; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gSlKv0ToGAeQ53lsfFOtI0+sE635JWib0pSuSvkBPtk=;
        b=b5Er+Oflt7D9A4kgg2aNT90Rj3IeoKwsapaAhZpRGHCn/vfkDbnyu01CIjV+F4rVC6
         MJZK1/96DOY1p+AzwPLELG32Fji6ZChjpF5zMUEzB6uxIXYGksH2iJbbQfP1nfAKJcez
         GzDAimjQn1fi/uxX6ALX7+6Xc9O2Ch2rYMD4Uw5upxF0AzPGNqHmG1u1m1fAITlY5HCe
         QsDGm2ZRXzVFPObWpDUiFcOis+cr/9ZYfWqwADOMewyIvACirRp4Lh/l8x4CmjP4xME/
         cqsnimHo68i3juwjuei40JQZwdHXS6GROlbnYnKJH+QtFTIxm1LCD0WxGNFSI1uOq1Nv
         z/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792589089; x=1793193889;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gSlKv0ToGAeQ53lsfFOtI0+sE635JWib0pSuSvkBPtk=;
        b=nrKaeA5o4EkA4AidUViiZZbokZ8RB/cegl3asNcDx3f5VjFYqJVg+DINAD7kY89Fsu
         hdNYqaVvlmuREqE8gKXnlvgGxsfK+c5rXfQCWaqThaiV4L0vuYklAIGWB8uWpW2vW2HE
         bniWdG/vNUO6c1i6LwSKG+VBW8XQBGUGrsd8LXXKTl6AJxVUw/huehm9nqG/JKWf/5I3
         MuhaHFjfgD/+Y7j/MjxCoU/MPmS55uQ9/rozMeXwP/B3/DG4TUD3t1GWXjw8F6EEtikc
         pTLX5ohS+Mo9WUnLifVsra/G4vkYP8ahKWs/shUaKLJl8sApQDjrSNV2QhlTkM0Wd2uj
         L/nw==
X-Forwarded-Encrypted: i=1; AKwUvBx3o9Bbk9407Em8QvWg5Z5eavZnVDIPOSUiYONvZfk4coD8P9r42RhQCT5BS/EN81u0lZI1L/87BA==@kvack.org
X-Gm-Message-State: AFq9FYJotuEvmr1pncSg3+hgS3YSVpka+L/4+iN1PlRv0XXOJKPQdDMY
	3SwHnEfo9k35QYHKJFdLWEAFnrIcd71GnWtTxx+NLr3HxoEgalXoWANdtMmt936nFaU=
X-Gm-Gg: AYBFou1q09iyeW1X4kQgOu+hQJKl1wGSEOIgv30xVsdTbcdj+9y4aVGRrbQ0ws7hsYk
	AwkOM8i2dFJ1jHgQh2LCS42TXEw+rv3JfpM4bvsxICU3ENAN99WMatmDWfe/Z4+SE5GHBiVSFGM
	+rU66JLW0TRAlKtHBHNgOCm7Nhs6fEC3jjqYhV1qw/w4vTJ49fCT5wz8xJfOAinYLaeZkEZyvWl
	qDuJvd5cTPytV9ziMx6v3l30I/Huxejl2boE+aB8xgjqEGf0t9cb8YC1aGkTNhXJsSYgxgKrLFF
	IbCc2bw3+9WcSLqkVMJw0rMWAvewMQSVcTkzun/kBlr6fkMn8FbL+CtjrJvDnnQAFm07pAaENya
	A5l48+V9Uywn8y1omNIEqaU21pSo5HxCsmBjWU4cixCJmPZrhGgc07paDKAxVOezYzLGcRNVbc4
	DR2Uh4FQ1FY0ywN3MUCmMqrHF5aV67/3GZkHty8lLW2cVpkfkSAyNLqJDSbnmSsA3CcizG6IWuD
	h/jRocDwRCGj3ppJV76y1QE1ZbDbQeC313q5ZnHNIYM/lO0DphAQhSYDj3QIm2g52mClREb2dvt
	NEOnLWG0a4GZx++brB13UCmLXm73S7x+PhM93lObsv3nEC1G
X-Received: by 2002:a05:620a:4496:b0:93e:5861:34df with SMTP id af79cd13be357-93f57feafa5mr395621285a.47.1792589088891;
        Wed, 21 Oct 2026 06:24:48 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e221fcsm250054885a.40.2026.10.21.06.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:24:48 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 0/8] mm: fix allocator races with memory hotplug
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, kernel-team@meta.com, 
 akpm@linux-foundation.org, mhocko@suse.com, rientjes@google.com, 
 shakeel.butt@linux.dev, rostedt@goodmis.org, mhiramat@kernel.org, 
 mathieu.desnoyers@efficios.com, muchun.song@linux.dev, osalvador@suse.de, 
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, 
 ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org, 
 mgorman@techsingularity.net, anshuman.khandual@arm.com, 
 Bessel.Wang@huawei.com, jiang.liu@huawei.com
In-Reply-To: <63521469-3829-4895-a7d9-a0f7806c58a1@kernel.org>
References: <20261021023940.1940971-1-gourry@gourry.net>
 <63521469-3829-4895-a7d9-a0f7806c58a1@kernel.org>
Date: Wed, 21 Oct 2026 09:24:45 -0400
Message-Id: <179258908579.2324641.832287495252342628.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D140FC0003
X-Stat-Signature: rb8mqqr7rtxyz8shrdoq9u5mf1aod7pt
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792589089-60740
X-HE-Meta: U2FsdGVkX19lJ4MzwUYCVUJXUQSupP719opgALG7mqgJT7ezqOOEy5QD6AI1E449gP8uwfEl1RVLbKaNEczmEk/+HH6Tqop/Qd9f5o64G609BLgfF5TspvtndUKNlVmWLm+VepDwyOWfDzUQEJYiQn62WfQ+WcNa0YT8Sf/UqezICzTNb5kwJYAwcbm7mkBAmVzvTqzLFxMN5RS9ivMIGSagbHtvFhq3N5Ldd7SSLnk4asoYtwXeMJ8srkUAW+oYjfPPoV0RcOI6+qcWyK9sCUsLR1l3j/GyyZ7kgfsLTUui3mMjy/Tux2luRZKhlavSFdU7Ll/xgMdaNgf9rYblp+z5yOsB5NDu1WiDfUBIZg7ldxeYH+BWGytULPvpGGRkBkeHq6MtX9jreO3GzgiylACp7EnRUsTnmx+OrgeQpVW3UsED3Xnmq06PuTKNNOpiPb2lVRsLi1SESC9FxbikrGbrLn7VajA8IzOd7oD0ccvBuuBZZJbw2AZ9ukVAb+wXnw0T+UcEWEM21Ecz4DSIcMSphtn7NMXvNzCbfDcdwbXqY02h/Xugr9xYniuP8s7AjnXJt7K+5qmK1+HJkX/acn71LxbfvwDoWQ62dY/67/NWqR5oisz0R005LD7XEX5Q+Z/ihdfTPHoMeL8C65pPyrkSEGpvktc9KDf8gKkdBBL77Ai9irAW4Nyg43P5oUJerjvtqMkxNkwtGfczz/JCNIhazSWkFwUMz74Ecbm/u6O64LfWGMiJT1rAMVAzIwVSKjdRqQgEj46ZzWsgcDDE1h4nUbX9CIkBZUrc5jUB6S0mPFLGe5SCdPVJDMzPbUiqVPonzhwaU6qprgn/YHoCdhFYaYmCXx892tBvY60zlGf5N/DYD3CsuiRDlLSunRJBzK6fcUdJmVBGGGLz0UP5Vd27k8PyQrQBAw3C0dc+ztwSKYvz68WWORh7cX3fqacN5yRjxKC10+3t/mtqzaE
 xjXeBTDW
 bRtYvg9z6v+vpasXNcpkiRh12mzp5lifgzyAevURP6FMjYfDecsLNc72q1VQdL4HldUKTymWlxm4uAqh4Hh/FxaydFS2n7KtCXz1X9IUu3BVwuFfKTRFjg8A9vzvHaFA5gofVSLJ+9mqKSsNEAwvILnm+npIVkNxURHSXDLDN+breGgZ+Ivvn/ZQofaXU5yD4L7NCuOqpUZGJB08EjImXQv/8geOVnf0xA1xvbdQpsCm7k5K+gNIYqAw61EMPoFn6ziOomKGAMIhnrtrCjOvsap+qYksEk/r4d7lk1pkbBcvKgkDr+f8MdUKlb1P2qCXCHBWw43BdcZB/b+GejTsFh7J+6jYY5tomwckymUzExJmpGoVGBKPkmdgRXPXDzCt9fBUu8sp3iD1WrA2YYFfXqSdbI2Xt81VhwF7e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-21 10:24 +0200, David Hildenbrand (Arm) wrote:
> On 10/21/26 04:39, Gregory Price (Meta) wrote:
> 
> Usual reminder to slow down a bit :)
> 
> We have
> 
> 	Documentation/process/submitting-patches.rst
> 
> Saying
> 
> 	"Wait for a minimum of one week before resubmitting or pinging reviewers
> 	 - possibly longer during busy times like merge windows.
> 
> A lot of this here was broken forever, so there is no need to rush.
> 
> (thanks for the fixes ;) )
>

felt prudent to get the adjustment Vlastimil recommended out to avoid
time wasted on v1 since it was somewhat significant - but ack.

~_~ found a 9th instance of the same bug. Will send next week.

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>

