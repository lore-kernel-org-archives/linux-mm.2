Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E319B606A333
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FkMpQ5Fd
Received: by kanga.kvack.org (Postfix)
	id C70BB6B062B; Thu, 19 Nov 2026 07:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48E16B062C; Thu, 19 Nov 2026 07:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B374D6B062D; Thu, 19 Nov 2026 07:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 893816B062B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:03:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16A85120A84
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:03:05 +0000 (UTC)
X-FDA: 85451732730.26.E5C9AB3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id A41C28000D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:03:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FkMpQ5Fd;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089782;
	b=OCCAKlnxsi3HODhFz2t0s97njf7ZVb74yDmfC+nEh+AOC8Fml1I3LJM8xa7mJCCYvmmh1d
	/oCLK8R/JehosCtFkx6MkeVoIS6QEPMy/QurpcG7DU/c4lVtzA/gXFKqbNlq88/DFrOD/I
	l8ri6l0RRWca+NwhJcBFejbrCbdhQKE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6K1VKlq2rUeTJU8oPRd92vsLkRSeWvDzIW6gRScpnDs=;
	b=oa3N0D27d11HRPkAsPPeoab/Ul8NNBFbE01HTuqJX4oRe0Lp3I07736ciHIss+8dixsski
	mmMboF088MB/giR/QCjWUwoPOng5ArJfAWtezkP5PQFBcQBhNquaI90MEcGXzUVZbr7Lwd
	itVkQhymxG0SqY2VWct4c61OO+Kb8GQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FkMpQ5Fd;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795089782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6K1VKlq2rUeTJU8oPRd92vsLkRSeWvDzIW6gRScpnDs=;
	b=FkMpQ5FdALzIbLfCqM3upw+0pap6AF/nx/msRJk/Q9YcYLBm5pzHPB3T065Cay2LogniaI
	dD9u1cGrAD4zPqAN99BuSRFY5wrasCUkB8VlZxcbHmuk5hxH1rDcl1G80P7LAKI54hENT5
	AJRyN+CJIb54ff2RByFiVBub1RvkaK8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-8hta12HbMjK6ennx1Is2NQ-1; Thu, 19 Nov 2026 07:02:58 -0500
X-MC-Unique: 8hta12HbMjK6ennx1Is2NQ-1
X-Mimecast-MFC-AGG-ID: 8hta12HbMjK6ennx1Is2NQ_1795089778
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c50713860c0so188814966b.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:02:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089777; x=1795694577;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6K1VKlq2rUeTJU8oPRd92vsLkRSeWvDzIW6gRScpnDs=;
        b=s+9aoL8IE5hpEOisU+lYcGlfl03/l0C3jlOZQs/SDp9bAaiLNIItYzuYtDj1wKR2Qp
         xibpi9mQx3x/AOYWdvv8cfxxTjFHy4rDw8uYbJJ0GNstqXRn0yISjl6XOO/rJSY5bDWM
         q6LPCvbeoFeEMtFv1p9THxSz/NPybuVkg/iSzt/FDcONtri3yN7QmJeUrIVSx0OM/ts9
         5vMJZTxnvtnjOnXMQSP/ybdzTe4tBS8EqpGvYbM0ZFDIKQHu/HHTiJsrYWBXmrTimyaX
         u6+AI0tMm3nGGUVvaxFWkQrEJsAAOFa2O9NNlKMM3vSTCBVCu0BbGjVb+3UakoajWQWE
         FITA==
X-Forwarded-Encrypted: i=1; AL+hErGmuEgOpUmZ1G6X2DKtC4W+/+XOpDIdi7oA6p2dUHdUkjImYHkyEdWaB9xo2Z+7DTXH+vuPkCxCHg==@kvack.org
X-Gm-Message-State: APuU4Z/G5E3RZRUlX0zbNWbPZCItf6MsT+9Py+J5u83/m0X0cGg148Di
	AMsjgtMwKldmFO3NCCkBCWy2FLHB+TS8CsE0twTVBARa0f1s++cCcVJayM8a8MRDxx2Tv8TtmlI
	qE41gnq81OuAjbciR9fEugDtSdj7bmUd8Wm6vwuekSjEdVx1FGVy2
X-Gm-Gg: AYBFou3Mgq0iUy+iVDe7N4uag57xlhbGeEgcwNukAwEUvWDfZq096VH5XI2AFN1Vq4w
	TnB9MrS26p6aRgO/4fLb/bWHlQFJTbqETb1dUHaknC1QLQ3br2Eb4uYITPExf7SMzDwhePXOwjB
	ZBh0ASVvGVk7jcOXl4yuHPSEhfLzbGcr1Jof4dQHLqYhWhuCBD8D4FSm3InSNy1mrmiAZ59ZzZH
	4Fs+yMGQZmK2+HzPr1F7OWy1s/hpacGYHqMTwSvZo593zijABuhlSsZAt6q/O1WYd2IwMII8L1u
	i/0oEdrp46WmPqETjyl8BFbiYV8wKoFdJmVswL426/vPZGeWtHE5mZZlrJGGJdzK5qcgMKStz7R
	8+tKjcqeV7AKl84yYWVP15fmZdU82Vx5kyYYtmDhqm7k=
X-Received: by 2002:a17:907:3f82:b0:c33:ae8b:817d with SMTP id a640c23a62f3a-c510e58fac3mr532074066b.46.1795089777339;
        Thu, 19 Nov 2026 04:02:57 -0800 (PST)
X-Received: by 2002:a17:907:3f82:b0:c33:ae8b:817d with SMTP id a640c23a62f3a-c510e58fac3mr532065466b.46.1795089776668;
        Thu, 19 Nov 2026 04:02:56 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a6560961cfsm10496541f8f.39.2026.11.19.04.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:02:55 -0800 (PST)
Date: Thu, 19 Nov 2026 07:02:52 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, virtualization@lists.linux.dev,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH v11 5/7] mm: skip zeroing in alloc_anon_folio for pre-zeroed
 pages
Message-ID: <0e8d142ec28ccfb548797652e1d39783046bddda.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1795089715.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5cl1-VJetYJdGklKkkrbfHLYmMbDHrVXjyEXSDV1UjI_1795089778
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ipzfqajk779pdj6ygmyhzodrfao3wfqs
X-Rspamd-Queue-Id: A41C28000D
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795089782-158343
X-HE-Meta: U2FsdGVkX1+O78NJSrlHt2dEEEhq/bYg61bnAatuUbL4Lj2KNOGypiAuj6GGKJKuzs3auQtrHvy9t3J8we0SXiQmDDLq7ngR54UNjsx0iwkF32xaLU+Ga0B6LV6GEi/tjgW9sHMZISvegCXG3ROF+FVB8Q5YMTUPswsTVQBMb9jmhqHf6k5TD4lT0khrQ9XxUc4EfgVzHL5WCf6FB20XZZnOAT0JW+vinVkOaJU+siTqvgXKFRi6T5X+rFHOkfZJ75eVzWgm+Kts3qQ5WKb7i+Kp5UbhUUZAKsWuR6K8Nh415/+kd9yG6v1zjrPidYZXgiiiYayojGwcJl7Fiqr7Xn1p1NOIJeOjdpdIAk2T4xXb25tNep4cd3e8gfEM4vWODobQLXl8C6IDuGl6c9ZojJEH1D6TmfWsW+8bv+ElbTpzNSkc7xwWzBnxY0KozHZTee+a0UalptlnZupOxqb6K+sHsdijyQZ4WgpWYJke3zw3VWSI2tylbtN26ngmRz+Hlpipy16oFQkIXWTIbZxZ+z5Oijce6gbrdqRDbKNUpIyo8M7ORVq113MeEupcu1ZptRZhoIDslO2ykyGQV8kLc/6isiB1tU6DCx11rWER4DN+KgoAs7y3rwjFEXrQEe8iMQQv+pBSP3j0o6nkYTnrfIBlfTFSCtHLBEMVm7ZUXNWQzhXIdLFQ550OVuC33EdEH82Y1PQXpo9a+3sWadoTBGN1BhO363NIhVNQgV0n1VBrn26DDXXrfM6S+XwyOsf6bD7yGToMXCnJp0QGmsCDg3Gv0DtjmVnh6YdQ/Y3S3uFfcRJpLWD9wvrJUcATxSoqRoQLySIoT2rqhrYROsv1reC7MpPrXAd85DRRP2rLHGZF1F+0Ms0yx5nOhfcmNBW2i1Mx/jhXw3NKM+xlvRBNSdbAj/8Asuq2FUdD8dCClgahC5ujibf1oxGCGawi3ao6T+8QK5Z/3C7vrbGm6kL
 zaqh/zAN
 PAmyz3CXAZpz1pwPpvms5+UiZoo94e3WHMV2lk0wlXGPGQmWMbOCV4cqAjCySIiGOf8oGEf4s44bOikhCGKDFaQ4v2mSAHeJzSlmTNzlYYgoxoqNl6IH2rNXRzTtPvUShsFvsBBuRZMENbGfA+0nhQCXHU2FbEL5yGpWy+NlQhZ+gt1u+u2XvEybZ9Kfhy8cSj1HkRuvsEXKLfaAmK5RIDWw0n89ByecNW5cMqrlM43t7A14MkPU67TzRSlhKyvy6cDUT986ayqmNKgXaETZePLAtgyXOswZ0Dw8//l9LCkq7xtggxUsdDEgEZa9jwBL+fKaUCg7D4QpghLLH90HoXS9PjUleWg0GIQvmEF7fHTS1sZYb/E0X2R0zyl7DvsekMNWpk5gmgMWIVhbDwzReFQDvjiieT4cnngBUO7PCpvwvhso5XrStM+EiTTr9GO7eCc43QXsUwaWxARuUfi4xajdHBfPWCgcoYUBLhzeCNoUUZk65DdIY0MvHMVEGmeH+iiTS/6SXz1jgz1uaIu+Ag+l7NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize newly allocated anonymous multi-size THP folios through
folio_init_user().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
---
 mm/memory.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee2..020ae881b226e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5479,15 +5479,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 			goto fallback;
 		}
 		folio_throttle_swaprate(folio, gfp);
-		/*
-		 * When a folio is not zeroed during allocation
-		 * (__GFP_ZERO not used) or user folios require special
-		 * handling, folio_zero_user() is used to make sure
-		 * that the page corresponding to the faulting address
-		 * will be hot in the cache after zeroing.
-		 */
-		if (user_alloc_needs_zeroing())
-			folio_zero_user(folio, vmf->address);
+		folio_init_user(folio, vmf->address);
 		return folio;
 next:
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
-- 
MST


