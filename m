Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CEEC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FCF6B009E; Tue,  7 Jul 2026 14:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39006B009F; Tue,  7 Jul 2026 14:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D281A6B00A1; Tue,  7 Jul 2026 14:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91DC36B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:29:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DDB9C296D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:29:18 +0000 (UTC)
X-FDA: 84962817996.15.1ADDF73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 91CFA20006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:29:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hUUzZ3NR;
	spf=pass (imf13.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448956;
	b=2KocK2WZcJ2sqFTOuIRXoqFdT9n0h1vUvyBjbISQXzZkM4v8nvzXE9MTuO5gD4yicAXUQl
	JEmh1Z8Yr7n1+rZtmFluMX39dZHMMxOdRM/lMHRcXiczwy0AKNmS4dmCILj3kPqurjoAfm
	x9GUpkm9Vt7sbr1V9tCOIR+NI8zUU6Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hUUzZ3NR;
	spf=pass (imf13.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JQByjrZEnlfvBUgq55yU0uevWZpdlhSt/rPl0iueosA=;
	b=xBaoyrqAO4AxIXk2VC3THvAFOCUC/UiCkyjLDLqR/T0yYo6tQH9aoW1/u083sNDhX97pkC
	IC4Bd2Vu/BcOHCjbua+yT5Ldkkx2AfejdssJeerNxpQutpYU+k4/lhi6LU5UywfhKjWrdX
	QV6g78cu3z2qcpSmn91qboeeWUydSiI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783448955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JQByjrZEnlfvBUgq55yU0uevWZpdlhSt/rPl0iueosA=;
	b=hUUzZ3NRn+dEucSCt03sPm+2qyUHayDCl+aLZ3zAAmdCEo3IChSutB87dNlFzcRW6DhdIA
	9KmNrzqjmjPiOfSFwsODWiR521DDJq0Pvx3+MEor4OQA/cC6p2H6mjXIYs4EfGrnW3Ro/N
	7binp0aVZbIQ9+jRZNoXIutRNWw+SxI=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-pUGvDpomPsK43Ct2JnIg6w-1; Tue, 07 Jul 2026 14:29:13 -0400
X-MC-Unique: pUGvDpomPsK43Ct2JnIg6w-1
X-Mimecast-MFC-AGG-ID: pUGvDpomPsK43Ct2JnIg6w_1783448953
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-448d5182870so5348538fac.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 11:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783448953; x=1784053753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQByjrZEnlfvBUgq55yU0uevWZpdlhSt/rPl0iueosA=;
        b=K+cwkHNTNyb1qbyVSFB0UWqsZl+8JVEseN5o+LRvRqqXrBROSPQO5TuuOHnQfKPeNW
         z8JPvFQDsH3EMJ8qvAj+M8dYPv2kdh4xMmMB651SQgHfL7H4FdlsOEQXsEPSi0/p36/K
         ZfsXTwoIGUhIcnS0iS3yOJH9HlHlYxMMaHLSL8QsApBBFfVoMmgJsmJZKAk9CL+lilxA
         2J0NkRnAV8m4v/AYUVAeBJiE+Na9l8rhXjkNSKXzwdXizIjozoR6pvB4Hi+fOYuAGUIe
         vYPVqOI37qywQet8l25rOi/7yw/aWxKGWEVLoWMl9HNSknFQh8UI2L28uLw3/IcsWbnp
         XIGw==
X-Forwarded-Encrypted: i=1; AHgh+RoRvUfBfL8Lt4fn+JEAH1YyyjXIRs//QdomIdC9lX5blT7hncet9FTY+LA04COkAZtvFUQCzu+eLw==@kvack.org
X-Gm-Message-State: AOJu0YzcmpJ7EK+aJ528/icEBt147Xw5rEYuJZW3ijeICFupevQfCUJs
	tP7Rq2dfhruBAY2U8QRMUmEaCGJXv2gwaVZIOn/H+KIn8kgnXSa4HLrRzvUO1B8xUlVmSoj5N/B
	FRou3KoBlEouhIvgAhIACdyo062ukRexQAMLv+lARd3NHiIvgY53q
X-Gm-Gg: AfdE7cmKpw5N/UGV56GTxO63FS3FtefNEoFZzvLJjO4Pkk86L+DXsnbgva+XVGKx35e
	T/mlCi74tmzCnJl0ONNcCxmqyWmFEMm0XRcQd4wOQbGLtGsL7SvgRp8xl6jBSBEugOP4ucxHWaV
	hZt8qZjXxNvGj9vbif8bYCk3347IxLfrBSiQpiI+N0L5J+G9oAKpV+dRT/XE0C/1fgQKNyaB4jo
	JCpGD/vF0PT5NDrFDNe8kO8T74u3oFNPjf+VV9x+h/6nAlwav0qofNMv+DPitdAC+kIIJCXtenm
	oA2gex5xIGf+xjhDXMi3YEo0j9TaKVT8SXw7FDOsDK1sfZaaSvLDJL7It9NYvCXrZ2zIQhqxlyJ
	K33gafyzUp4sc9TUKlxU+kA4Eni7QpHHRMZXZX33AXgdo/rtLFICh4vJPeLs6iDz+ZuxCLsPbgi
	O5f6NOow==
X-Received: by 2002:a05:6870:9d1a:b0:43c:2d3f:95f8 with SMTP id 586e51a60fabf-451059528d0mr3915351fac.0.1783448952938;
        Tue, 07 Jul 2026 11:29:12 -0700 (PDT)
X-Received: by 2002:a05:6870:9d1a:b0:43c:2d3f:95f8 with SMTP id 586e51a60fabf-451059528d0mr3915329fac.0.1783448952487;
        Tue, 07 Jul 2026 11:29:12 -0700 (PDT)
Received: from chaithco-thinkpadp16vgen1.rmtusco.csb.cloud (184-96-191-56.hlrn.qwest.net. [184.96.191.56])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cfb55907dsm13550509fac.11.2026.07.07.11.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 11:29:11 -0700 (PDT)
From: Charles Haithcock <chaithco@redhat.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: Charles Haithcock <chaithco@redhat.com>,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	arozansk@redhat.com
Subject: [PATCH 0/2] mm/hugetlb Try to respect mempolicy when calculating surplus huge pages
Date: Tue,  7 Jul 2026 12:28:54 -0600
Message-ID: <20260707182900.483757-1-chaithco@redhat.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ADKcIXLovUmfTQoX0LR_qd7b_QJV-U594ZChkrNj8kU_1783448953
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91CFA20006
X-Stat-Signature: 1nchga83mhyyskpepnrjh7ft6ntezoni
X-HE-Tag: 1783448955-373600
X-HE-Meta: U2FsdGVkX1/ZtrI2YhRoGdq0JH5RkwPUskui8tiDWwX9yfAzO5VNxmqnaQfdgmB9hRVhzDlZvQjwRmaP6AdzeGt678nfuO4dLWngSnt2A4+KyIu0CxuB/0KNYu1rMMrV4PJTxaK7x/PRFiIde1zp0NiyfQF6P/CWJrNFEMbD475Fbl2r6+yUjwvyKnkra5swiUmgvReGZbtq5Fwn4yn5iHlWfpsbmFcTI+8Lww2PrYSEBk8yit/hlIsq5rb9n4FqA6mBEDflFWKWzVYNSpw2zHNgdeSPHL3gt6vpea6N+MbmloLm8swANAHZ2noBba3Pvpxy+RorgFeKQIkbG/s16xiKUbn5J+YCGhT+LvvFMHC4OSgpcTt39V+KQpZS6bGAguaE4FNorRgs9ZKhPEDrcdHNiKH4Uiiy38dg8hnyqkfKdg5bqnUkr01xBCgDbEVRQg5YiTVusiFwfIxNg7w8NkxPwZyJM5xsDZ7xxRL1w/MO0M4idrDnu2fstkNuX7c53Uj6+kBMsubPeVBi4zFxPHltzF0XP1HU+yADmdi/3N4oEyReEhQ4LC33V2dYtMMGepApfiUAc/dZlnPAT2eJDE2QdxIw9/BEN6OOds2HMsLhFZNSHnxfxSAQyG8GJd3LWvmfDiynP0zS4ME7wf+nkUSHSbBFb6vEDGxoOXKzsXbmWOJwuzSaqVhENL+yeCyoX5YFU60NajhcGKk+UY1XlpudfWsNvcwVxug3IuYsZCCxXmOE0i1rLfiWJ1DBjqmJiQ2x0S0r5qu1qXSq1Art2yjnSuv42t5avLf07exKYEzHVh6pWjhktw8JpBuqR/u5Z6fovbnC7Q1WsrzjG0UPTNwfXGBnb1roDk+O2HHdnk9zowWzLXedBoO29pe/PaEXjJCHe4FjPW7nObnLeR2X5Sdv3SRQ7xHbnnURnS9513KcnoDja8ILXhhq3XYR3VbpK8S0wAm0sBMrUGV6z8y
 h7VnX9Zx
 1f89EXnD87hligqqbayToDMJprGclhmyY0ARkNeffxnAorVD0tiw2UHYLfHfK71h8E8tY93dAhsdnPUBzEYh8CthyXvv+GZjEzG01vNmlszeeO/tfhBhEaif+7BAcYAZ/3pVw7WeN9iRvmqrxdnmRntuVd5Yo/CQTZMZhh0AzGI8C62B4rZjKzKb/zGBQObvOINoAlCMdB3F4GF2/7U9sWFgdpSYCjfPwZFnOZ5HMoXErMTky/MFWRnW2hPa+KouBVdbR03R2JVuU0C2f6q5mAMZtJoEhPFNHqtBV9C4kIpDaDd9q/4g+N8qTg4S6JLf31zlUDknB76MX+iQHNJrS3d6FSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Presently, when calculating how many huge pages are needed when
reserving surplus huge pages, the global count of free huge pages
is used. When reserving with a mempolicy, the global count of free huge
pages is used even if some/all of those free huge pages are on numa
nodes outside of the mempolicy.

Reserving surplus huge pages is ultimately best effort even without a
mempolicy. Restrictions from cpusets and mempolicies further complicate
calculating correct numbers of surplus huge pages to reserve and 
maintaining which nodes those reservations belong to (see the comment in
`hugetlb_acct_memory`).

However, we can do a little better when reserving surplus huge pages
with a mempolicy. This patch changes how to calculate the necessary
amount of surplus huge pages to reserve by considering the max of either
the amount of free huge pages on nodes in the mempolicy or the global
amount of free huge pages. We may still attempt to reserve huge pages
outside the mempolicy, however, we end up being more likely to reserve
from nodes in the mempolicy.

- v1: Modified `needed` calculation to use `allowed_mems_nr(h)` in order
  to consider free hugetlb pages in our mempolicy.
- v2: Folded in Joshua Hahn's recommendation [1] to further modify
  `needed` calculation to take the max of either the available hugetlb
  pages in the mempolicy or the globally available hugetlb pages. Allows
  allocations to prioritize nodes in the mempolicy but can still fall
  back to offnode allocations. Also added selftests to check only for 
  the edgecase which caused this to initially be reported and sanity
  checks.
- v3: Split the change and tests into separate patches and clean up code
  to better align with kernel style guidelines. Likewise, fold in Usama
  Arif's correction [2].

[1] https://lore.kernel.org/all/20260602152022.2673803-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/linux-mm/20260624144600.8159-1-usama.arif@linux.dev/

Charles Haithcock (2):
  mm/hugetlb: Prefer mempolicy nodes for calcuating surplus hugepage
    reservation
  selftests/mm: add surplus hugetlb mempolicy reservation tests

 mm/hugetlb.c                                  |  42 +-
 tools/testing/selftests/mm/Makefile           |   3 +
 .../selftests/mm/hugetlb_surplus_mempolicy.c  | 491 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   1 +
 4 files changed, 517 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c

-- 
2.55.0


