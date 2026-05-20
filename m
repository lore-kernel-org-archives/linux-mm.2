Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A5ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 04:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9936B0005; Wed, 20 May 2026 00:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A926B0088; Wed, 20 May 2026 00:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAB46B008A; Wed, 20 May 2026 00:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB7466B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:49:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34ACFC03FE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:49:20 +0000 (UTC)
X-FDA: 84786569280.10.3D7FA04
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 29D4F40006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:49:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qzLVUnTk;
	spf=pass (imf17.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779252558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57hoFoACkrjHC435/bCa26l7dMtPP1jCMndjVz0up2g=;
	b=CZ/c+bETbhN6sGUZs7O5fTRxgv/SZH+QJC58JaCNi922ISDHEg/AV9MMwlBVzZDcZTmkWr
	eZTgSITXvdP8yri4FuZvtwZN6d1XVunb1onZ3oVA/GLxitW6BT64foH46IgRSOXlxookEb
	sqgJgdpY1hSLLlsZNhZmuzVMzqJiwz0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qzLVUnTk;
	spf=pass (imf17.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779252558; a=rsa-sha256;
	cv=none;
	b=uBobDJCr6aZukI6cW+ADEXEYuHABlu9F57YNPVL3RhXfsFXxstQpyw6Wkwd29O5qlN8OSl
	z3dtilTiYWR5rPh/k4IdaEv9FQp1zGWmDAZQN6N2eN3jyYCWCf1M9jI/oZfWWxmrjfDESF
	MwpoNdykRAbPgOMAepaX66+9H1eZftI=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso43114395e9.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 21:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779252556; x=1779857356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=57hoFoACkrjHC435/bCa26l7dMtPP1jCMndjVz0up2g=;
        b=qzLVUnTkF3r/4X/URwSzeVcHBVfxkV8SQI1pDoZAO3VTj11MWtAjtvHV0vC99AewhQ
         B1DrcNNfRh5D28qJNy7fK/Guxt1nY2WvIqJWhy2kT0y1G5BzsPVHfJwWw064wX3ibvJA
         9wqYGF6FxxXuko+JXCp96zYDzzSQwj8I50uuz4E2jdA2QvfC2nXcz9+23riEN6jk+wUG
         tAjce9ApF/5QyX1cyqg8PskcOKyQlIibl1Xj+brhOfbJZqkznsVnqujoiDjaegsJsmaZ
         jcGJq/GCGP7/ZT+FhslM9JmnKAxYB5KitlcYyJZpg6gfFeJEtFEMpU/MvIuFik9MlfJ1
         77xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779252556; x=1779857356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=57hoFoACkrjHC435/bCa26l7dMtPP1jCMndjVz0up2g=;
        b=qHgL91cw0eqkswgKCW1eBJTKxWHfjGOCXfyx0nuiot/IxOPp3UNsWFCd4lx9flHFCm
         kanf+262hXYBDKfNEEAvmTg7hQ3sGXCo5V0b05ipjZvYnukXGG5F/9o5Aosagl5M/RQY
         HtegLkhJGuQ/0wM4UBqz0MbZxhqCg/xCp33w0ji6JCTMXTbNYKvI9MgaPSoF2ucuF++J
         AVlniW2ydBv6E6tgv5MMgJdH8Te16Amd6CgskmpN5vnBCaYbhEk4adID2ipxW7ZW/H7u
         7G0roebRo5/Pst1XwyKapLwrB8HyP8CnvtRYOdIe3Hij+iFLfkPtFgLToBzE/SZn6xdY
         BmKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8/eQ8f2m9z0lvLKtYV0Tii/2bqQjEAelYOpkEftZTS9Td2wfoPfcsO74+dMyLRw0sFvc6K8UVF/g==@kvack.org
X-Gm-Message-State: AOJu0YySRgGO0/hckA2Row7qID1Zn8/pIBfr9YTfZ2wuudcjyUsjCO8z
	ay/W+GSeoIafvuyGG9oOJLvrT5rSQ2AWGsE13gs/lARYZDKMIrhV/bdM
X-Gm-Gg: Acq92OGeR0lypg8IKXdUIxtvW+9TIlqgnV17ulS7OzQwmElZzETVM427LPjky5JI+e8
	8aJndQMU5BKRtMTJuAt70NjK6xSettLLglgsdf9nvTkNX9JJtGDIEWuUaT8Du4OfR8q+O9BBqil
	eJaW/kEM0hsDsqDbqh2U4VekT2EpQo+onJ6Wzec0LZVoccG09LKRZgSESmSCjnjetCflwnDDUzH
	p6YCWIzxBR2EB0g+hmevhnbIqo40zcsroRzI0AOJulVsrNrbgDEIktQOuOspSYWBEFQnX75k6H/
	onDzRU0aB5jREKL3ocU+6hyR2AQPibJ3IlAxq0tHN1i9jcvTTisuVxt1D7WLn8g3jBmlz1oF65D
	qdsVKfXvmq2OgfdgRG1WWKghRMtSfYU3vcfzLlxA3h1LwvemcBFeOS1pLjazYw9yqlvfOPEVzcz
	Ru6ifSep9l12FEJU1G6dDAK+ZuYEbl2GYp6gNs4FOvV1XhWeDxLeg7dU5ZHuIX3+5iu3llSWbFg
	7CF5RdflMM=
X-Received: by 2002:a05:600c:1f94:b0:489:1d23:4524 with SMTP id 5b1f17b1804b1-48fe60de736mr327397805e9.5.1779252556299;
        Tue, 19 May 2026 21:49:16 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fea52a0bfsm189071125e9.0.2026.05.19.21.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 21:49:15 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org
Cc: muchun.song@linux.dev,
	david@kernel.org,
	almasrymina@google.com,
	osalvador@suse.de,
	yuehaibing@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v3] mm/hugetlb: restore reservation on error in hugetlb folio copy paths
Date: Wed, 20 May 2026 05:49:12 +0100
Message-ID: <20260520044912.6751-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519230503.121293-1-devnexen@gmail.com>
References: <20260519230503.121293-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29D4F40006
X-Stat-Signature: 7jxemizsodgp1xh4xer6wgdbeno7szzw
X-HE-Tag: 1779252557-801371
X-HE-Meta: U2FsdGVkX19nCWOKZCbHzwhGOMcuxizMLQv+mKLOETpP10iAu7IrQAdHe8sz/G2qpabujS9yZA2Q9RDdOp+qitOGRygvxvxOF29DwBze7q/vOE8FS+zJzbrJ0/OuyLOt2o03kplKcuXXIzZZJnh4/22ndmAm+O5tr+xkvR2+IlfZEfML9//bv1ZvIluwMBqWLzgasfO/eHqzvbdQ81X6cmdNZfWih2oALNOo0XiyAq60xiZDHTG4ns6sS7x3F3ipaGb/vZR1ECIKfAMBUqhCKUK8iIfVa/Aeq9E2ViY4Y2tYJFAzBQiGBSYPlM9DLPsizAU6tEvm9wARPS+C4YHb7NLE7hPwjAR5cy2/MZSVGhoIJB1EYsE82XDZxPUceSwLrVOsr3mFVHnWfj7vbMnGNgVGoaOiPn6bcoZuUIU5yGu8kAnHh45quWgsXSH4En/MTI8C0KW25RdI/a2wpK6Tlaeae/EEWjyLN4mvhFlESqkgxGZLcgbPYkf/UiXM5YpzeoQURcA+WzjF5bWADKvCYiHqkttlKNuNrL3NVMrxLfC4oWMmtg616Jxz5aRHc7dDJJdhXi+P6yj6pTcQrk3pZo9+A0Sfls5SaYb3D2f1neczQsE67wOnmBQfISFdpBjzJSAX178zBdADM4pVu3ijzLrBg0P9ot/E9NrIMwt8Vbs1ewMwXA7TYnVzIOngYKUUjlNXSfKpiqFTZHaD6AV3ElikrnRwC53IKthM5YkFIRY5tHeXtVz0uiFfY9J/nSlL8n8XbHunL6LdsTrY/doeBtV71/mBCqoKxBHdD8CKvZc7GxKJdKy2uPD7v6BIoXPDZRFaoTQCipZvUiMuAztQs/lvixG8qzwU2kj+5FUgFz7lRwC/hji+DqNAL/Go32ZYucLlxzpwZKZVtnXr5/EGPdSeBl0978dC0CCcxIj95SwzTKKCvUB0ZenemTQbbEDBrprs9ZfUPQow4Ut3juU
 iV2tS1tW
 sK2HV90jggo+B1zkoUyoIGblpTaoxFJSrWnCO8E8thYel9Ew7KMfHNgg0cjwBOtn3nHrM16XByv8ldszUjh7kWeXx8uXwKAO3zSV/k97loE3M77+Zdx4LZdPglLffZTYE1KYI+tNnSeNya54CH+9bF5lnh0gkcAGvn7ZrapmxjmXkaUvyMU+8NW8DqV8naB3xkufKsaxxgVbG+Cbmnx8vphhVQdSj9TvjaTGH1Nt1GxYI14u37BbI3MRVDDkARhWFD43RD+eWnboKPBU+ftC6LeF1v+jxHNL403X6iyKRlPtPcaxYkyfC7ejuvMcrKFyZYwc00MHuZnwyJuXegrHIcG3FR9O0I654C4lY4Ibp1maxoFGQDTKV9JGIb3YYjuHdA3+J5cYuL0rBTxcBZPtPu1hl9UNTVctp0OSNP9P+moIDwvTjJZNOy/ung6HCtz6WqtqaEMHfocZMz0FIe+hV3D0zkekDs0jIIJ9Vs2BUUC0vzP0L1ZcjWtsWcWevm78aTMKQFQq6uA29az2zRm1LU2pP5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two sites in mm/hugetlb.c allocate a hugetlb folio via
alloc_hugetlb_folio() (consuming a VMA reservation) and then call
copy_user_large_folio(), which became int-returning in commit
1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage
copy-on-write faults") and can now fail (e.g. -EHWPOISON on a
hwpoisoned source page). On the failure path, folio_put() restores
the global hugetlb pool count through free_huge_folio(), but the
per-VMA reservation map entry is left marked consumed:

  - hugetlb_mfill_atomic_pte() resubmission path (UFFDIO_COPY)
  - copy_hugetlb_page_range() fork-time CoW path when
    hugetlb_try_dup_anon_rmap() fails (rare: pinned hugetlb anon
    folio under fork)

User-visible effect: on UFFDIO_COPY into a private hugetlb VMA where
the resubmission copy fails, the reservation for that address is
leaked from the VMA's reserve map. A subsequent fault at the same
address takes the no-reservation path, and under hugetlb pool
pressure the task is SIGBUSed at an address it had previously
reserved. The fork-time CoW path leaks the same way in the child
VMA's reserve map, though it requires the much rarer combination
of pinned hugetlb anon page + hwpoisoned source.

Add the missing restore_reserve_on_error() call before folio_put()
on both error paths.

Fixes: 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
v3:
  - Fold the copy_hugetlb_page_range() sibling fix into this patch
    (per Muchun) -- same Fixes commit, same fix pattern, single
    backport unit for stable.
  - Reworded changelog to cover both sites.

v2: https://lore.kernel.org/all/20260519230503.121293-1-devnexen@gmail.com/
v1: https://lore.kernel.org/all/20260322052120.14021-1-devnexen@gmail.com/

 mm/hugetlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4b80b167cc9c..ba7c3ed96835 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4974,6 +4974,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 							    addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
+					restore_reserve_on_error(h, dst_vma, addr, new_folio);
 					folio_put(new_folio);
 					break;
 				}
@@ -6270,6 +6271,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}
-- 
2.53.0


