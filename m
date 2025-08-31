Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3037CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5F06B000D; Sun, 31 Aug 2025 05:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E806B000E; Sun, 31 Aug 2025 05:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB206B0010; Sun, 31 Aug 2025 05:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A52496B000D
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:06:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CD1D1194F1
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:06:03 +0000 (UTC)
X-FDA: 83836470606.13.0C104CE
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 57E0E80006
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:06:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r7kcLSU0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756631161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cewv29th9nlXePhk/EOfBMtGSb2YntDYMH/m1gOAqlw=;
	b=RJAR5vqMm/ZY1jHs1p/WgXQdNUvMxJ1uuJeXNWID5s/6yaye/ctpS6aH1B+8GP4BJjfgG9
	9HuDyA9C/89TBnaxbWeb+quh7iQj5BZZtWN3LdpwRvLM20TCxTN80CmcVZZ3Z4pl+RIKtq
	KA6jziW7TuNUbu0XyL/tG0FJeLv2Deg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r7kcLSU0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756631161; a=rsa-sha256;
	cv=none;
	b=jbt7lurETrYwEjKVBlBJWFvcwItgA6tG4HiFUbuua5XPcSIsKQ0w3Uy2D4VDhZ+6+s8IFv
	94lBB4iQ5FMh2S32QSV7iN9qekDEYi6woAWp5h4kKQ8O08zAVZs+I1L/M2gkQQckX0gObQ
	DMZLKQtUhr/nXleOz3IXhRONvDoUpUg=
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e96dc26dfa2so2851790276.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756631160; x=1757235960; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cewv29th9nlXePhk/EOfBMtGSb2YntDYMH/m1gOAqlw=;
        b=r7kcLSU0vobzWK9Ku3ejoFl/a0ne8BdxYtIBzZp1LQDTq1SHxd9j2NVE3f+ILEgmQK
         ifmuPm/KOHNfr8tY3gr35RzA1ALI4DpPIcJY6+dTlwTxJ/6vbkASZ1Fgdkw2+jfTJIqc
         prlRuyet0D4X6UHVcOQIfU0OrUGWpzi3DvEaonGBYTw/hatZXg+WPldmbBm4rF6JPPwq
         02YUP8D7eQ+Lfwo8tzIgiuLUSSMgrox91DYH14MacQhff8wsp7f7XSVT9Cn4c0W7ACbc
         2vR+GLKhBj8EnWo3HGc0ezOqkcZxKrcFh+6BL33eJIAEVHthqV3Tj3Q4Lqb/8kFdz+9w
         4W5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756631160; x=1757235960;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cewv29th9nlXePhk/EOfBMtGSb2YntDYMH/m1gOAqlw=;
        b=JQJ1jA9g/uF10vp8mzCzVqJ3icE7gZu/Msc0sXTgWW+0O+NY/vU6/L+TRv0aLW2faO
         LFmXXYwgGaCuHlvOVKIzAnMWTRyRB6NXr++l8p1qoaOOE89xW47+DjUa9b0p7gx6x4Td
         yEWNYKf8++Q9bvNwd//Pno2inwlSJl+Tzc4FewUwPs+BCftRlbx6TgnK4hGZmSjyGl7Q
         qIG1Ect+Uz7IVJWmYK3O1luFlOsML+NFsXdYlq/pD3HHxgJuw/VBzRyPJaFL9nbpnef6
         gCqyjENYXPXFJYefI6tcTnhtmg674hXytf6SE5q8wgzVySweqJxKYl5Yam/uuELGJTzW
         FizA==
X-Forwarded-Encrypted: i=1; AJvYcCU0C4+O//oYfZo9ZdMfnU19aXkEC0ByAXXh3ZkwCMJQi8Zc8c5Cd9byoA+MVPmzMxlaK1JIYNKvhQ==@kvack.org
X-Gm-Message-State: AOJu0YwdTxuD4fKF0wG7BFb2IrFiDMgBsxHbwo6mwTS2Z/w2eyayuz9O
	kH/XUBMhQJfszKqDHxYx5V4ajJCqsPnl9xvQsmvEVnhAe7aJGj44XnuBHWLkBR7Mtg==
X-Gm-Gg: ASbGncsjKqjxO0bicYCXdoWArxx9lJcNwObQ8pglSGBz0OTGUKOb+Sco00d6ynWfO9b
	vvz+SDJp+q0EA7/afnB048K8+SmFqdnkB1PXkpFGTJNL13D/dG+jn3GQVFWnhr4KFlTpyBiXL+s
	BY8Nzq4Tc5Ls3UvW4Nu7i5G17xODPeUeupK6NlfKobjCfqxoy0pI74oY5Zk82mCWHuXQu2ZjzF/
	q7ZbQLlUDy1xgewok5FormizrTc4Lxb8DGzM5f2Mk4fcpl6VtEUW/Msqvlt8MxqO2oGz4sqm3XB
	8YeMTOoNaUSSNhCI9pg30ZRD3rbL3i5fOCbeaNfqmm2B/uNoK5Ciz/d1C3VrfQ2LbKldeTd6xKF
	vKsQrWenRymqPg+OwJYgP4yIEVZ59o6SFIGcqwObIxhxYpAe8soxYoNecScvROi05TQQiGwSs9Y
	0ejtO+5ueL8D/c8yHmwoBpVNQU
X-Google-Smtp-Source: AGHT+IHZuc+H+mCEQgTcTD59v7WFBtA0Muo5YsHOfJFQ+r6CmvOZ6yRPYLQ9LbxJpAeGrP/U6wGvXQ==
X-Received: by 2002:a05:6902:2490:b0:e96:efc6:8392 with SMTP id 3f1490d57ef6-e98a5851c2amr4633775276.43.1756631160112;
        Sun, 31 Aug 2025 02:06:00 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e98ac41ffa1sm982501276.3.2025.08.31.02.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:05:59 -0700 (PDT)
Date: Sun, 31 Aug 2025 02:05:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, 
    Shivank Garg <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: [PATCH 2/7] mm/gup: check ref_count instead of lru before
 migration
In-Reply-To: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
Message-ID: <47c51c9a-140f-1ea1-b692-c4bae5d1fa58@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 57E0E80006
X-Stat-Signature: 5emhu6xrbthnhq5pr93p1drqnx8jihqx
X-Rspam-User: 
X-HE-Tag: 1756631161-413017
X-HE-Meta: U2FsdGVkX19fdXio2ngGigRhfGMOtqMPf3XPEqaCBch0QNFunS7AYix+3qP2EZcmTog/h+DwzeQ8xwj1jF0XisRkIxKBSYwaWL0bWPPcB/kdlDYKvl7OUAhbvi17Su4yzKrPcz2X+qCL8pztgvsJGpFxGPpXFNhTZE0rDICs/7/h/10cETUpXnk+rfT8pujzpXG7Nn+MTqxLNhn4QQlKj+HP/8HH8MsQUFQj4o2jlUwVs57DEhPPeGVf98R/vlFu//wk0s5lXUQLBK92NEye365YE6VZ6HSkdYuX3KI69pY3YnCD8My+yVbhFy+ClBVo6vEq9IvZXX7WWAVlNCfuiVK7npVyKb3BXsILyOZq66zh2p4H4YXUZ1p7SY3naeWEAMLtBZ7rhxIufpX1gYUcwE9KNyIV/uUQSpbPbPbHiJOwfiAwGL0ReXu0mEcuZ7gA9ALkJkayI5c/FSceDIZyEvh8rkB6hAu1EGW6BvJoMrhVxje1IOtReoS9ncjRNmsui4Y6voHVHEPeWDlsLuCgzKe3pKGjdKMzs4qzlz3EdNnrOWwmmoHpYtnux2nCdrnoV6AGI4l+VXC4gZowbJMWy9cyqZlzqVejaW83HiVbzM/ChFKs6DbI8Wt2HiuOh+4x+832CYY8GvYvxko1PfR9BIXEHpUvJ9XndUgkaGSsyDe53vXaN0Fcij18/v9zPx91owX6tUfzrCstmf54uKE0WB+frOHw735/IS6e9mmMflsYkDquEyzM17wIkIPIJwyzf6Gre4/3L3VBGGKTcYSyBx5uFFAB0vzkIlfCfVBWxrH0vPce5HpcSYkjW6BBw1oZcDJhYMz65pY1RbsrylVgnYrqm5pKFHv+zaGFGMwbB7MEZmF83+gLZ+56N1iUMOE99EB+QZtu2F6FSintosNBz91HdAVlZsyTYRClkKE52qBuN5srI76mDCd26LJAFlD3+qhczZoUGqIZHhZWXHY
 6IB1YBkP
 IsfatfooLXQiZdlPCvh+5irTFG7M8LqViXK7XpvJHJLdZ9UC7nAB2wyUpMf+LZ5J+585II0oREtGGMmKI99MgyyvEggxkJ8JB+XyGZ2RC5hBm6FJBRjtYUNode/rPmybw8pqJIKGHwR6RSgs1EhUHnka41HAq1HcjPKihYYG3h7D1dJwbKN99iuTV4yGS5qoz+pV3hBC3U5D8GoXn01LoWUpdSAghF6MrQqmtM5IYj7NyHYOl46svmwj2JDgwbv4W8o97N9geXDg5cMrTKu9yjT/2JOuSX3qO5Z5TDDN6WA22OyzFvLmJ4eF0kS5SHwXSBFyWsWk7P8j3GRrRYMBl20pUl0gFiEfU4XGlGZ9D14ouRN9ln/za1/hERm8bcUIqDsGNF2TM3y8H9t1DbLmwN9flA9rrG6AfWMCK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Will Deacon reports:-

When taking a longterm GUP pin via pin_user_pages(),
__gup_longterm_locked() tries to migrate target folios that should not
be longterm pinned, for example because they reside in a CMA region or
movable zone. This is done by first pinning all of the target folios
anyway, collecting all of the longterm-unpinnable target folios into a
list, dropping the pins that were just taken and finally handing the
list off to migrate_pages() for the actual migration.

It is critically important that no unexpected references are held on the
folios being migrated, otherwise the migration will fail and
pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
relatively easy to observe migration failures when running pKVM (which
uses pin_user_pages() on crosvm's virtual address space to resolve
stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
this results in the VM terminating prematurely.

In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
mapping of guest memory prior to the pinning. Subsequently, when
pin_user_pages() walks the page-table, the relevant 'pte' is not
present and so the faulting logic allocates a new folio, mlocks it
with mlock_folio() and maps it in the page-table.

Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
batch by pagevec"), mlock/munlock operations on a folio (formerly page),
are deferred. For example, mlock_folio() takes an additional reference
on the target folio before placing it into a per-cpu 'folio_batch' for
later processing by mlock_folio_batch(), which drops the refcount once
the operation is complete. Processing of the batches is coupled with
the LRU batch logic and can be forcefully drained with
lru_add_drain_all() but as long as a folio remains unprocessed on the
batch, its refcount will be elevated.

This deferred batching therefore interacts poorly with the pKVM pinning
scenario as we can find ourselves in a situation where the migration
code fails to migrate a folio due to the elevated refcount from the
pending mlock operation.

Hugh Dickins adds:-

!folio_test_lru() has never been a very reliable way to tell if an
lru_add_drain_all() is worth calling, to remove LRU cache references
to make the folio migratable: the LRU flag may be set even while the
folio is held with an extra reference in a per-CPU LRU cache.

5.18 commit 2fbb0c10d1e8 may have made it more unreliable.  Then 6.11
commit 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding
to LRU batch") tried to make it reliable, by moving LRU flag clearing;
but missed the mlock/munlock batches, so still unreliable as reported.

And it turns out to be difficult to extend 33dfe9204f29's LRU flag
clearing to the mlock/munlock batches: if they do benefit from batching,
mlock/munlock cannot be so effective when easily suppressed while !LRU.

Instead, switch to an expected ref_count check, which was more reliable
all along: some more false positives (unhelpful drains) than before, and
never a guarantee that the folio will prove migratable, but better.

Note for stable backports: requires 6.16 commit 86ebd50224c0 ("mm:
add folio_expected_ref_count() for reference count calculation") and
6.17 commit ("mm: fix folio_expected_ref_count() when PG_private_2").

Reported-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/linux-mm/20250815101858.24352-1-will@kernel.org/
Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---
 mm/gup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index adffe663594d..82aec6443c0a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (!folio_test_lru(folio) && drain_allow) {
+		if (drain_allow && folio_ref_count(folio) !=
+				   folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
 			drain_allow = false;
 		}
-- 
2.51.0


