Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41477C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9604F6B0088; Tue,  1 Sep 2026 22:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910ED6B008A; Tue,  1 Sep 2026 22:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827C76B008C; Tue,  1 Sep 2026 22:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49E366B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:57:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AECF11406E2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:06 +0000 (UTC)
X-FDA: 85167310452.20.D991606
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id C54D2140003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=SReZFiJX;
	spf=pass (imf09.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.210.182 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788317825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wx9bliagn1IBSjTmGC+tUrKPBAFTwTk7ga02r1H6dmk=;
	b=7ulU1zSV8LH2ZAm+2ZUlJ9+sXsvwf5hLQhet7tsLbmngrAej9xHYp6mJ21XIb9dTCHLHCL
	hHdEXMs7IvfmO8/PqwxCWG+vAXnt1w8IoQXaXgI70dJhNK7E/jWoR0k91Vi9vq7Od1dl8c
	HuIMsjTuHUjUC4gbQ1Ng8tpCIYI0qjQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788317825;
	b=BngPsBSIec7i8eo4ZhGLgi0vPQEVAvAiQSXCwHowqyqjI3ipKomoS6dfdm8QwYJoHbaAVK
	kahDR7ZAwaXuNXWjg/WqXh5nc+jEHZX3Ix/rxOJSRo1AcmSZgoyAxL9lq0oFo1gcdByk9Y
	SBr39VQ18GNAy1Z1tcGr8Q7yiHUO7zc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=SReZFiJX;
	spf=pass (imf09.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.210.182 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso447222b3a.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 19:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788317823; x=1788922623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wx9bliagn1IBSjTmGC+tUrKPBAFTwTk7ga02r1H6dmk=;
        b=SReZFiJXllypdEN6lGvEa1oUA+APiHa1OfHV5eeXqwpSHyUaCIulALGT9iuZYgwgdL
         w6dUbejmXACQjApTnCZxOVgtVX/RcUBTW5gFWy1zQ+y64cv0NcMIfQLe9XSJsoSQalZK
         ia3QBL1Ar9y4hq/mFtxZ1+fSBz/BMt+3jKEazph00bLfxvOq9tu1YxSzAv8PnWduCp+t
         8YM4NBagIYGZF7m9FkAq6y3U1feC3FQ55izz6V/Z4q1GiXm0WADHwCTdlXH19fd03wmD
         eQs30MDPGe7BWvZEYh7ry89cOuVvX8H7FScKn0BSyTyQvxZSKwLvxrTPeUSY7gf9JmSD
         F5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788317823; x=1788922623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wx9bliagn1IBSjTmGC+tUrKPBAFTwTk7ga02r1H6dmk=;
        b=PKovZMWXKlMCXi6Wnsre/4+M6HB6pgskZrMqSxIQ9feuL9/YHm7h9/GOTbq+HI0vvK
         u52hLm3DRvaLu+fTwLt2J/lTndHVL/wrSP8k07K8Jz8QamAgX/YfAdgV4IM5FMrUzFrL
         QQ+h8qEdkuisM2PTFmumJMqDASzZt+leRWOKfFva+K11X0uO69Zo2aQT9szi/jIS/pPx
         lwyyoEgwSMl82478Zp6DkfjCZaAGX5Jr5vLku4mqXYsrOBlZ1IsWA+Dm+BXpY0NbYNQP
         yRsfO+qcvhufOGvNgpb1z4B7vbVJn+oyTFyG/L9ig9lVUzq5T+6iWHX17OZVaSy6tPw1
         hitw==
X-Forwarded-Encrypted: i=1; AHgh+Ro1x6EgAM22bx3MycZJviFXnuUzLzQDNw/3clacNz9U5DBJeq1ZA9PewXIdYKdk6osZoTxEQikr6Q==@kvack.org
X-Gm-Message-State: AFuF++ntawLU7lfncUevG7Axw/Kg62PcrF33X7992+DZ8W8hKSviQQU1
	61tXbfm2M4QalQz28uttLJ2ssXYNeoW0ADAcOWajdiMlcgbdfleKsvWnEeGgx9P4hFc=
X-Gm-Gg: AR+sD12rwDG5QF2PBWLobj3Ox+rvqLTAOw5MFTIfySmvFQdOyXl0RpwdsTyskq6ou4P
	sN7DigDxpWoz2oPReVa5/CIOTebFJ+Eo9QXf4tpqxZHkGa73STnwGUwL2aW6hWN22JKzKkF6wet
	8JFd+cXm6raka8Phez9Y8aSzydb52hlLe9t1qCzftlxXgxTS21WhP3CW/BTBi0aGlAqbzU7JLPQ
	9d9mHjiByEDZYb52TGP7rAN2Z4NnXMdlm8N46BpRdJkMMxeQlBg8jI8FMPGXO+dSCPPaS4gx0q/
	qFIyr0EdAlg8+wfnLYJ10ZUG3lnBrO7W6vbV0+fJ5/JouAVcwg0lHd6LqQe7qfUwPJChz48jIAQ
	fiD6uH/AdHPEWUURoVwBww6b4Cc/Ib92Qg4zjY8Hvpijqzd90ItQ8bDqmHskwr+PDRfnlswHdPr
	gHgikRf74qdiefNopb28K6RYKyVE0R8cJPRyHWmawSLkMJGP5Bn1kP8vD8ICqS2pmhE1R7rMGU7
	6bxrjFREpeAvyjFmi7PT0+KPMnhk25coRLS
X-Received: by 2002:a05:6a21:3995:b0:3c4:2b8b:e88f with SMTP id adf61e73a8af0-3d9ad570683mr3116323637.5.1788317823327;
        Tue, 01 Sep 2026 19:57:03 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:a1c2:77c:7ab7:f9a0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07bde5bfsm2066469eec.27.2026.09.01.19.57.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 19:57:02 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] mm/damon: support access monitoring of hugetlb-backed memory
Date: Tue,  1 Sep 2026 19:56:57 -0700
Message-ID: <20260902025700.17975-1-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C54D2140003
X-Stat-Signature: uxf4pedcad55k86t7dbjs83p6cz5fc11
X-HE-Tag: 1788317824-104404
X-HE-Meta: U2FsdGVkX1/bZvYS/5ge0nl3sEHW/Wl2EKHv7EHrwS6es2mxZJX88+/IalJgDCkTqtG2tD6IIUBL9VLin1eR2IxhkCCzLAU571wudbfyE51+uQcib/YjsHvtaCausF5h97fN2Z6lrmTneb+0k5+2vvDe9coYDKIP1OArVOp27h91GYs94p0Dj2EqDKzMzl3pmhaCox3ugHueIoZr3wXeWwyaKMSz0/iZ+wZnnkRY4A2gnMu3Dk46U5Mn55IFArjh586ARwacuo1gpQ8qEDtRpC/k+LjlynF84b9iFIBFTh+g/6p+KfjKWOjBnuhPPaap0LK4DbsCjGwihA3L/hfKRmyyqUyWfgti+LK5O4OYwOY01PNRNKRnMcew/T8cbkxfff87ykxOxy9ug0+xg6Z58Zqzm2TtbQRBcRtTVA6/27o1j10ruqHqAYEwm/TG81H8/o6XCwyfyK4p/+is5m6wg+fmnS93gBnLINlmLlSHoRTWHioOFzzUyhfbp0gyff2jxkSXAALBgpSsQPABGlzjyehUkdMreVAQF2vX6w9NEgSaW/9mn0PU0XXWzCIjTy5YdUbn0SGBaET8CuYPYvDTFXWcE+D1xOPJZfFoxQAaPkxe+tP/zabgxNvgjo+l6Bo1rh8n8hbgJX13d9MuaKmQtlCw4n3admP46rNsEEjTG4a+GWDBkrJSCAME1EdRnOaRNIyVQT0EjSv2uFBoyrjf7Ed54gHAghGADlORuKJOYfr3bSzCUoW9mg+EIMkxcTVHZn9UHPmj4RxeZXZdiPeoiHR08Ord+vXcLDk864X4sYrCmk+8WRtDrTPFhDKN0dOnx5QPxAiQIhtx3WKxi+b07kuOUbH5FjCAVVCqq1kEvKQWHQ3SVCDMxwMz7PGWLtBPO24nU7CTAycANJsOs/5eQr07Km0Y4k5u2DE515648eaAybz2/3WgE6H/TQsCS3MTAfy0w68XZ2DhzStiCBc
 my/AfvuW
 mOWoBxSDV25bfkwjn4IbqfTquqgeL5N12u9sCODgcYuK21ad4hXMiEy5gre6U1YNqaKr4rCWln/5HZ+0+tuhdmHGdxZTk8iHA+TJigi8ja0XyK3flcZT898op1Xnb9yzM3Sr6tHiuzHn/zNfnKcoYuC2/wgGGxgC0JJA+l3zY2SllSb1wi4oUI8BxifCk6aYMip1BexUm+QmSgis5nBvm8M8BXFxot9p3fiwjmnDV5LmCwUhYu4Ee2b4lgVCmRXEL6cEmu2s2a4nAklkG3U1N4LK68jv6OY7Vhq6xBofjTxcTaG8QsGXwaXi6rnCX3eDDgM42O427TU61WNIoQan2kkPPJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On virtualization hosts, most system memory is often backed by
hugetlbfs.  On our production hosts, for example, ~95% of RAM is 1 GiB
hugetlb pages backing guest memory.  DAMON's physical address space
monitoring is blind to such memory: every access check starts at
damon_get_folio(), which rejects folios that are not on the LRU lists,
and hugetlb folios are managed outside of the LRU by design.  As a
result, all hugetlb-backed memory is silently reported as never
accessed.  In testing on a 1 TiB host, an hour of 4-thread random
access over 842 GiB inside a guest was statistically indistinguishable
from an idle host.

The first patch moves damon_hugetlb_mkold() from vaddr to ops-common
as a preparation.  The second patch teaches the folio mkold/young rmap
walkers to handle hugetlb folios, aging the huge PTE and notifying
secondary MMUs across the whole huge page size; the secondary MMU
notification is what surfaces guest-side (e.g., KVM/EPT) accessed
bits.  The third patch adds damon_get_monitor_folio() and uses it from
the paddr monitoring primitives only.  DAMOS action appliers such as
DAMON_RECLAIM and DAMON_LRU_SORT keep the LRU-only lookup and are
behaviorally unchanged.

This series is the first half of an earlier six-patch series [1],
split out as SJ suggested [2].  The second half (the 'aging_flush'
TLB-flush-assisted aging) is deferred: we will gather more
quantitative data on the gap it addresses, including the workload-side
impact of the flushes and the working set measurement details SJ asked
about, and post it separately once the data is in hand, aligned with
the ongoing monitoring preparation actions work.

Per Documentation/process/generated-content.rst, this series was
developed with the assistance of an AI coding assistant (Anthropic
Claude, via Claude Code).  The assistant helped draft the code and
changelogs, and applied the v1 review feedback.  All changes were
reviewed by the human submitter, who takes full responsibility for the
contribution.

The series as posted here was regression-tested on its base commit
with a full x86_64 kernel build (no W=1 warnings in mm/damon), the
DAMON kunit suite (41/41 passing) and the DAMON selftests (15/15
passing) on a kernel booted with virtme-ng.

Changes from v1
(https://lore.kernel.org/20260830051407.50008-1-kiyer@crusoe.ai)
- Split the first three patches out as their own series, deferring the
  aging_flush patches (old patches 4-6) until more quantitative data
  is gathered (SJ Park)
- Drop too verbose comments on the hugetlb branches of the rmap
  walkers (SJ Park)
- Factor the non-hugetlb PTE young check out into damon_pte_young()
  to reduce indentation (SJ Park)
- Rename damon_get_folio_incl_hugetlb() to damon_get_monitor_folio()
  and damon_folio_observable(folio, incl_hugetlb) to
  damon_folio_acceptable(folio, monitor) (SJ Park)
- Drop 'kernel' from the host-side monitoring example in the patch 3
  changelog, since kernel memory is not LRU-managed and hence not
  monitorable regardless (SJ Park)
- Add SJ's Reviewed-by to patch 1

[1] https://lore.kernel.org/20260830051407.50008-1-kiyer@crusoe.ai
[2] https://lore.kernel.org/20260830180411.103772-1-sj@kernel.org

Krishna Iyer (3):
  mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
  mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap
    walkers
  mm/damon/paddr: support hugetlb folios in access monitoring

 mm/damon/ops-common.c | 122 +++++++++++++++++++++++++++++++++++-------
 mm/damon/ops-common.h |  10 ++++
 mm/damon/paddr.c      |   4 +-
 mm/damon/vaddr.c      |  27 ----------
 4 files changed, 116 insertions(+), 47 deletions(-)


base-commit: d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563
-- 
2.54.0


