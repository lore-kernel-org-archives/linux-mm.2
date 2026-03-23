Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA39EC01AF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32106B0005; Mon, 23 Mar 2026 05:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2D56B0088; Mon, 23 Mar 2026 05:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAAB16B0089; Mon, 23 Mar 2026 05:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB3596B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:29:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B21EC31CB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:29:50 +0000 (UTC)
X-FDA: 84576805740.16.B659AC3
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89A4A100002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:29:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g0xO7brs;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774258188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FDl7NWjENZ1t9QVlVJvW3GrxggXGGi4wt42t7kIc9bE=;
	b=ip/xwoOSMmk74O+4IoUVhbEKmSypzcWO60w0BYbki/nOnwjVPu2uLmvjHpb2Ctn/TQLPqm
	yY3mQZJgvSLu4Kf8/W3sCSm3Nt8Ixt0ApT/tVsnmhZP4kEr3ePnugxH/+V9+vsQmeYtuz0
	81uO6KQu/yOC0n9vHTkoP99p2gpVRfY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g0xO7brs;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774258188; a=rsa-sha256;
	cv=none;
	b=5dsc0wQ51ZfG8vyTZwFMPTr/R2cpg1Df1aej7Ak2z0AQ1I1fhgEUVxv8McEe6uiGHReOHC
	aGmPJWXO2/UtcMYVJr7/BPWQQNYkLBj8I9cjmVVNcUyYHrjrxwz0TuFFJsw85t1h8uAXpG
	RvEFqSLRqqD8YbwauyDGklCOQKnZ+ow=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7986fb839f5so38654927b3.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774258187; x=1774862987; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FDl7NWjENZ1t9QVlVJvW3GrxggXGGi4wt42t7kIc9bE=;
        b=g0xO7brsi75yBTdgWXnnSaCgSs5tK4MHFsGVJAmr6L3zxri6ETquo4UhLOML73M6/l
         W+g77XGzRjOFpXtMgPfLSYK7T8ZcW1uUqy1qaWNQvj1sVllJ5w3fI8bfTSKzxBeMmyUI
         9GZjAHhFUo8Id90yefk0oXXMm1hOQ4taXvVHBlWMs6DBtWl+tKrqqozA6nhAxlbhuMz9
         78j5hwM8ZP4zcDLX7EukjGNyulvhjNSf8SSUQdywV2eQZ4g4qg3BnLZvmKpkUzmI7Ffd
         3o4engCZIZdao0LRdBnXs/sgeQ/3tALwh3C3f7oiMJ4InEL5vkEP7Ls2cUt6jgRdf7lg
         Rwag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774258187; x=1774862987;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDl7NWjENZ1t9QVlVJvW3GrxggXGGi4wt42t7kIc9bE=;
        b=eYWiiZr6ZeK2jeqgMY67qkm0HDjeKtQXjmpqT/LNnJtoY1W7qK4ewsayGzHMrFFi8X
         BUSSlWEiuNSnAVrtuLg/iicFdoV6i76ZWLvTRlW3w2TO3jShluyvLkVvp44J52uaDbrM
         k8cQHyHexYFc0PKeJdJoGZNe6f2aYQgRzsRanOxyDKzPxJXYFcnrYlDCRkzwdXh/ptye
         EKnybfKV2jxmp6ix5BsbINVcOi8V1p1ss/V4CCrCIXV6C+RlVNxoLuva8CdXp/mKUFnb
         iALM0MOBAgog8P8gY1syqcHEbzcfKV1ot0iDAU/QVawJSgaJeznOq6XWh+Y7N54oo4nc
         YLPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlejmhhjyqMUwgU+zZipERy4Rf8yJr1wrFDivAvYLl3w4dSDOZ5jZWtDc2PidB/qMaqXsU0HCNwA==@kvack.org
X-Gm-Message-State: AOJu0YxTTBt6Fa4zzjBcZO6ZPtq+Nm4OGQxV3ViGCb5/nMdjFJkwRO2i
	WfZ77vkGYpnertWz6Eb/V6X42J0K60i+EMWFKzUWx9n18CTNgVR910SKJMkMOQtG3A==
X-Gm-Gg: ATEYQzy/7ndZzIDFVl4/mgcnT2PDJ4S7l3g3tboaB1MrZUjAFo40MmKmPyHidLJ3NY+
	ytxKYrQa+Gv2fmS7CDULUBwCRX9zeaw8i/PYt/vs+olx0IWeg4tDpYCE7wH4Xq+VOeLUxbHogiy
	MXg9j/d3VR4OZob+y3i+XmUXBbW1pRUL7AoWfRWWcGD58rqvovfLeDPU1l+96BPC8Ji8dgcazg3
	iqNO8mpl+kv+n3NW6+POhxNvk4zwchkhIZf7laFpNU7Nz/wXyIboU7Qgk0zcqLpR3yaKvwb/RTo
	XHejiw6O+gnnCMyZEdf7JbHiqM3T0dm5+/vw7wIViEh0jI+cpaWfyD/UGDnZV+32Tv/wSRPZqqO
	yWDNSGSy0JKMeNKtHEgmN+iXz6xKaR2NI7hpt3WjP/AUJaU/tMbgi71uT2LO0v09gTEOXXoNqWq
	ueS2WtuE9hzTtf52/0p4VrUn/cCF7yxfDTM7pVT1vHlbYS+K2E7/Y5CdskSR8iR60LE3N+6OoA1
	ZdzUemtg74=
X-Received: by 2002:a05:690c:6d81:b0:798:7ab2:eb6f with SMTP id 00721157ae682-79a90a8a954mr118996327b3.11.1774258186967;
        Mon, 23 Mar 2026 02:29:46 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a903fd41esm55901987b3.19.2026.03.23.02.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:29:45 -0700 (PDT)
Date: Mon, 23 Mar 2026 02:29:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
    Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
    David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, 
    Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>, 
    Hugh Dickins <hughd@google.com>, Kairui Song <kasong@tencent.com>, 
    Kemeng Shi <shikemeng@huaweicloud.com>, Lance Yang <lance.yang@linux.dev>, 
    Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, 
    linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH 6.12.y 0/4] mm/shmem, swap: overdue shmem_swapin_folio()
 fixes
Message-ID: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 89A4A100002
X-Stat-Signature: wk3iwoj4n3fp1opozepr7b44ydx56nop
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774258188-451237
X-HE-Meta: U2FsdGVkX1+YabU6dLeBO3aakpIa5sT2BNe/xSxIh8Zs6EihvV9mnqbumm5f7H+1Uqo8+QgPRUoz4ZnP82VyELYrr2X46VXfKDpIOj+wTYM5HfAnshngy8qGYWq514cuZ50Q89R1T5KV1XLaqQXr9sGzCuWCjI4aV3MzIDCT700iI4ihmmxh6wO2m9e2Bq0l4VxcP4RQ51rOOA+xbn+SOxQjFJr8ENXFzzq2KWlKb5O315QJz2l5X3J+qC7/cC2+clMpnC94gCLxQWHN6ezgY9hlCTp2OBc0FKwZ3X/BvI8zv63RUBdhLpk+iiYN9QDFf2a/hvBczKFwkvucNQ+jdoJq9wsX/WFcWJhK5dQwT8o4asvfM4aB6ejKOPhfNCxE8l2E4CydP22tOnDoazwUCiXZNFJbGexWfJxJuAtffboj+EiJdEfVO/kMPpipFpq63rYlKaiRc5A8fn0v8VdDzr78iQDRk2a/x11Ub/sYDX2kmr9NgJkHGIyT46cH16VM8fddR3ufs6eF5ieRdaDOWYGF7wfqdfQfPInAss1p0olrMaWy3EBT/Vr3JD/BCVINBjAFHjmuQm6/3qZdi4eqbO5AWGmbsfnatkwQVf/jIwlVRGySQiBVmuYm8NDQSNqZW6V4yuMFWqEghxlK3kSwJxpjKEywxeENOtePsjFlsxIEkLtMhxum4v68OVLd7V9kXGaWKUDfDJMeggYl2jCSCWSkuLykRy0JXlZGlPTJu274Zh2+uKj7/VX4n0rs1sNYx9lU1T4sfyJ1EgaFqbpDcF/Pm52OcU8qaO3rbFHbdmPv4OkM/ECcazVtSAJa1IfaOhkjMt2IEX1WUHB+w6LPlx2U441IFBaZrm1F8WnAOHkMGNIHozheJ8C2Le9frl5avisNVXXuJyPpvGs19CjQBQ9/b86UzVX03CeY0pUddmi8nrTNDDIvQBoaq2Ozb5eUx8EDnXtYJEt+jKUlKYz
 6Oq/rwKo
 X3IHBpS7Fwkn+QzNUlSTrKTE/vge8eMVo+iiTGA2X8ATijrvtUbS/OGblRkikAhM+ihJTlatx4AQaVAu/T6bF+V5k/vX1TFh3UJXE1lGvG+C8vmbDSuHdZTF69iTlZKlOHau6PQo/XWzlvoHLUerJ2vyOyh7FajXMw0v2/dOseIUgTgrcyLQzbJZTQwAKyIRgoaV0A1Dasdw2iFgOrPbVTKpkT/ePlN+Bcwg8JEE5/pJCHYW689jZhwCAcIOqhkgg9mpagmDdBMSBczAEcLU5VNUajlpvDops8DH4rskFSQXUvcA8lA1pt2ugvJah/OM3jIxxs7luP3jTGrBVNqcLP8tgM2sreBo5cIQe2Wy3jLvWmHP7psE0IyPFsEyGzKsWzxhpFLJ23DauYgdK/nhKAIV9MJO6BxaDeRAE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Greg Thelen (assisted by Gemini) has observed that 6.12.69 commit
a99f9a4669a0 ("mm/shmem, swap: fix race of truncate and swap entry split")
and its followup
dfc3ab6bd648 ("mm, shmem: prevent infinite loop on truncate race")
both rely on shmem_confirm_swap() to be returning int order or -1,
whereas in the 6.12.78-rc tree it is still returning bool 0 or 1.

Quite what the effect of that is, I've not tried to work out: luckily,
it's on an unlikely path which most of us find difficult to reproduce;
but better be fixed!

And applying the Stable-dep which made that change from bool to int order
reminds me of two "Cc stable" fixes from last year (and a followup fix to
one of them), which never got applied to the 6.12.y shmem_swapin_folio()
because of intervening mods.  Aside from minimizing the rejects, there
is little point in holding that "truncate and swap entry split" fix
without the more basic shmem swap order fixes found much earlier.

My own poor testing hit none of these issues: I hope others can verify.

1/4 mm: shmem: fix potential data corruption during shmem swapin
2/4 mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()
3/4 mm/shmem, swap: improve cached mTHP handling and fix potential hang
4/4 mm/shmem, swap: avoid redundant Xarray lookup during swapin

 mm/shmem.c | 97 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 80 insertions(+), 17 deletions(-)

Thanks,
Hugh

