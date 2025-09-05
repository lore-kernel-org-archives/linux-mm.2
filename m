Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995B3CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018558E0019; Fri,  5 Sep 2025 15:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AEE8E0001; Fri,  5 Sep 2025 15:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2828E0019; Fri,  5 Sep 2025 15:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C878B8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7364C1DD10D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:29 +0000 (UTC)
X-FDA: 83856147858.30.996B56A
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8268180008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W6YDsqiA;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099667;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/6xkjxZiS4WkuxSj7iGXQCi48pk2b1g9CeSbkf+6vY=;
	b=FbALqpQA2Alwi7Y0B50Q/sCY+xnhwg7D4phHWzIsLQ3KqrLrIGof/dWu8m+QoENPB7s0r1
	zNHh1PzbBwiMeKtIUNmDTGdly+ORrSCRq4U0yKeNr2fzRNC1Knu1CdFEPI/HiM6F6pDrPI
	lY1wr4Kv+BTbg9CjJuFS9NLz3g1EWIc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W6YDsqiA;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099667; a=rsa-sha256;
	cv=none;
	b=cGGXCvPqYoz+b+fzCePhgoqBuu1rhpahF/YY0IhV2Gv1p0VP2YB8QPFlCS6raV9dEWnifb
	B53zEImrcGy6scERyBjWfQT9IhtFWCqAnYRXIihYEBfnEYY0KQQXVOXdVQhDL923uQJI/J
	FUsgxK8uMNayT+EPLxB4IO+dP9kMdHE=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32c54c31ed9so500528a91.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099666; x=1757704466; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V/6xkjxZiS4WkuxSj7iGXQCi48pk2b1g9CeSbkf+6vY=;
        b=W6YDsqiAIg4ahVK1H9Kg6CWbz4z5JqKkHnDw48xUzy20f8fqhxIjNmVRi3qlMp+/Ov
         q6a1uDh+UCL6wMLhWy3iciuYKPVa2vhGgz2t3aUvMoiCdY+3JWbRanKCjQ9C7eJz57YP
         ScUF97bLhb+j6oaAbQ70Wik6ERPCN8l8yAQ7iOvFxA/4AzMTnJEBb3TUzXbcaMvBQpHI
         Zqce/WNsFg4JDCnAwdOtw0WnInk24Iee/EjqMKH7WpvDWrNK9BOPxddk38VE2YWyEzAF
         xRUaRJODkgUjscyHN0Vc8xUmAabrFsTeVk0iUp34VRZ+DRgozpQbhX5EMO9OVSwZ7DDI
         k6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099666; x=1757704466;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V/6xkjxZiS4WkuxSj7iGXQCi48pk2b1g9CeSbkf+6vY=;
        b=dQcGZvyoJMR0NtVA1vUTMqwQwSf5lDI5CpuHpZivNBRqYdjTC3oaUrohRyFw5qnXbM
         M5JrRxae1qJsN4O5rW6KS+L1DNpDfeYwDTD6wtEcdEVgWgCze/AbujUdJq6pQei8pDsD
         wusoYx+JoMliIPpjY//0SGt0D5m9Pr7yl1WMCRG7lpkQhAx1GhW8jJqPkJmhvrpCFxv1
         xx1gIBB2H6WrXx72beDR8B4+q6Wa7pSFOGQnQtY8JxQo4poq26Vqe/0KdhsCvk4Rj0hA
         uVlect7IH+bvu3ZDxIE/yO64/uiCirePHlqmRCnj764Nj1tfRUVmA45jiLcL/x6kUzfs
         5Tgw==
X-Gm-Message-State: AOJu0Yxc9uwRY6tqa1iKZ9XYkW6cLauShAw4xiksT4WfZ+I3uuuC8pjY
	iXhD+rVBoVyySZAuthnK6FLgAIutEXNaKUrBfh74U4Gio20bu4a1tSC0aEGJXklnj3U=
X-Gm-Gg: ASbGnct3bQNjzdzy1hvjUbiYPQMTa+5c8nV8iVHFLR4DTQldrDy63c3X6YpkJgIdWcL
	fapoPlU3Q8Hzo7mp0P/PTrBl+vETH6eo1wUWooK6r7tqT+zDFYL899ZAQA/vF8xYW7wwUh5TVKW
	YCZ8OFRnh+jEgYVQTlre+KihEQDXQ9Wtc9G611ymYTrLfYFSXpFd/PqHQv+ufjBts4UeGD1TIbB
	IBtPsuevGL1OkwgFsvp1qtmHRMmazu4wlQgpSh/w84ODs3irYik8iIaAe3Nzi5LBUXrznxlOawa
	R6h5bMdJdNIR1AKiGR3DC0nQBcx5vsfg1VDAuo2hh4gFSaF3e02l/ikvVj8tpzjXzG79VUfB/UX
	rCOqij80IDib4thcdAx75HIcKn2atk83BgRvBZU8mOm8PS/A=
X-Google-Smtp-Source: AGHT+IGAxCtVPjTCtyLUbjnAoA/ve5psp8+Ku1jl/RRWXT1povQsWgKxWs9snjl6Uh0QMXzMKbPaaA==
X-Received: by 2002:a17:90b:380e:b0:329:d50e:2f24 with SMTP id 98e67ed59e1d1-329d51d757fmr22448731a91.24.1757099665908;
        Fri, 05 Sep 2025 12:14:25 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:25 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 03/15] mm, swap: fix swap cahe index error when retrying reclaim
Date: Sat,  6 Sep 2025 03:13:45 +0800
Message-ID: <20250905191357.78298-4-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8268180008
X-Rspam-User: 
X-Stat-Signature: 47rnzob3fddi1yz4ttjd5f3k7eutdk3p
X-Rspamd-Server: rspam09
X-HE-Tag: 1757099667-464918
X-HE-Meta: U2FsdGVkX1+HXwHtG0EqHDGQAStzlhoTtfm+v4MpUUfLfg74N7VR1N3jQaJvoa96BqVf+xi6PegV5RQhb2SfY2iXAIf8eTVgSDfbCEfsl7pQCuyICm3QFnNmKFViAW/xhL3igaOI0zHTHPexqrjWQ0kr+qQyBCJlGte/pL7ERZIn/NhMO3NRj/l2nOIoIrh3kDVFWMj1mdz1g0EsP3I5M1ESvfmFHOBZSThvE0VZUzwRST+ZwsBBMdNcKUS7B6uFJfRJALOT4Mgi5NkSEWkSEccFPYrbK6HErSLeen66hQhP6m4WQYH7tGZtAVau79I7V4gqRZSm7E4gdemTD9Q2N9qWEV+MyV3Ddz1DtIlLbbUJc9LoTmx6Re4nojzPaXAMTtSaVq/EK77emKml9cT2xY9em4Swlev8vO4Yj0PNk1N1G1+IaqqG3XEqlq9ryS4jrDK7OksBx3V4YvdwB5xXAPBL0hjvsK3QhulyJbf1vi3P8MWG/NVczqiUAUJ7ycG2zf7LBG3Kr9LF3qYKlqiDvkaufg68qCODARf/TA6e6vTDtRXHydqexJyyEx3HPdhS+KqHxS1PLGqyoC0jzVP8oBsvBn8Dw8OYRwOqREa7cghU7WYQDJP9f448sdap1aw4EM3lNe7uQQglxNjr974rcXpnOsw/G2lYd8WHwN1kV0IZP+Xwjy0AtRW+8NdCxEretLb7QO0GaL4gf4mBEpT5dUVMnX56QP5kocuugmvf9IXyEHOPL0Ic3d3fj0VFAInk05P8XmO9G4AiQyGwsEJpWBArQbFVO3voeo5ytFx0BiKF3+2i5tVGwC8nFhu00zb5erIKJ35NAhh0A2MY2COe34QHmxqiXtIueMPZ+nIL+3PPEeT++Y50vdAIzPAp/0dXCsuvIGaKo7g6IOxZFr6LoPSv6mtBLOsS/P1hPlPtGkjksXJT/aOPqZyn/ZSOWiL35SBcfO5dJ4m0Zxd1/0y
 5OxPc94Y
 tcs/uSWjykF2R4j0tMsttQTpvYl5juliMvx+AGS+XsfYfCjxxXRs9UUUDbXw50LuVS8Y+c7r8YDfXNruU3VNCY9NaFXNIoH/OQLPTubSD0qKX6uM5oqi+HCo1vRcORXIsxf0FWcbINA7wp+6g5mDbX+N9Ghc3Wijmm1lMyp/jNmz83GAnTi2T1ZFhdZ1hf/R2JP/a9bRU3/XIIPkMcG23DswX+4aiFulmiNNKblBVhu2eAQLGWpvjJ2jhh784qGC78wSKyjWSgComIJRoPpyHgzk7dMSqp1UDzYQBkTNOg93z1UXhjq+m5fookYdp10tEkpH2nNLJ3G+EyuDqQeRpREBL3bwRRzUirxdFd7pBJtNAnAvIJ46Gefo24NoqzowoDYR9kaEJbh91Q8YN56Glgx+I9wSQrgGoq7mfDIIkzWS2XyTk5tcep1AEAxXugJ9Ah7fs9QbHpdy96WeQdq3J7NWBBXrKKPHo9UAbsKlXCQdrcRsSnAgQHchJpRRkXXT09WgZcOqY7QJlaWw0UYL9jD0L971fu/w0Vqhx7TiqKxFspd2QAQIztvJ7AhyI63V4YBlM2Oxs/R1/2boDa0a5vpOHZ5FMWD+r8PpMtGL8OQ2Ocapat+Iz7woOlrv/K+NSvNlt2+ovWYMfdZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The allocator will reclaim cached slots while scanning. Currently, it
will try again if the reclaim found a folio that is already removed from
the swap cache due to a race. But the following lookup will be using the
wrong index. It won't cause any OOB issue since the swap cache index is
truncated upon lookup, but it may lead to reclaiming of an irrelevant
folio.

This should not cause a measurable issue, but we should fix it.

Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4b8ab2cb49ca..4c63fc62f4cb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -240,13 +240,13 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	entry = folio->swap;
-	if (offset < swp_offset(entry) || offset >= swp_offset(entry) + nr_pages) {
+	if (offset < swp_offset(folio->swap) ||
+	    offset >= swp_offset(folio->swap) + nr_pages) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
 	}
-	offset = swp_offset(entry);
+	offset = swp_offset(folio->swap);
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
-- 
2.51.0


