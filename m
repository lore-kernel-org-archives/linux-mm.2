Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C2AFCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6D48E00B5; Thu, 18 Sep 2025 01:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF408E0093; Thu, 18 Sep 2025 01:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4DB8E00B5; Thu, 18 Sep 2025 01:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05CFE8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:52:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8111F140783
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:52:20 +0000 (UTC)
X-FDA: 83901300840.11.38493A0
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8D6C4000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:52:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wfEio92s;
	spf=pass (imf04.hostedemail.com: domain of 3EZ7LaAsKCMgz2ys6vuwr5ou22uzs.q20zw18B-00y9oqy.25u@flex--lokeshgidra.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3EZ7LaAsKCMgz2ys6vuwr5ou22uzs.q20zw18B-00y9oqy.25u@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758174738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OrpQJriL4FmpAUbfKPWp2N95VS4dJzH5lWC3tT3JW/M=;
	b=59Se18yqZeQIupXuan0x9bVlZ0xcQyD8BRi9KxpBFHwhJjWkwnTylUXU3VdNpOWgy7vPRx
	fuDZVpDunv+J3DS0gNMcPhYx5ERP8uGJh/bA4T9NIqPLvlVbVQFfV0UP/CJjb0i+/gfJGo
	loyjJBsh3lQBYFo6miNN6VkGmZLrhzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758174738; a=rsa-sha256;
	cv=none;
	b=c6eitCplU6kqly8Ns2OQDlPJlLJgfUQKXvGQVzssSxtVXBmsfWEI/4cQrI1jSfokWF+u+T
	PbziJ8RHdq8WfYOJXRk6jGTQmC0G/iMnKZCy23R+jdhVCdf4HGglL+zZY4ZC3RIrmFBlvN
	gWm0yvTY88SM6q3nCl6aNzXFrpynO6s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wfEio92s;
	spf=pass (imf04.hostedemail.com: domain of 3EZ7LaAsKCMgz2ys6vuwr5ou22uzs.q20zw18B-00y9oqy.25u@flex--lokeshgidra.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3EZ7LaAsKCMgz2ys6vuwr5ou22uzs.q20zw18B-00y9oqy.25u@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2681642efd9so5274445ad.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758174737; x=1758779537; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OrpQJriL4FmpAUbfKPWp2N95VS4dJzH5lWC3tT3JW/M=;
        b=wfEio92sjMN/ahq6jdKQ/MKcqa6QLp47CpNYkimtuIvbpu+GkFXCs09GTcvaFojwI2
         eZG2qdK4KAB3NV73lVoCX+MsE3czLzD44qruAYRP2n//aGaw1b4ntBIVwPIHox82QdAo
         x2rOTCzprxgCxAd5BQMKlfSNOE/aCw8rkOqciLRPFHUukxuhdgjAmKt1CZE4260hg/FA
         hicreTlez8bmw/MhHjWQKuYbjSeHVWjgBdyZtvbNQk7VRpszvraCiFgW2uhQd8dKvre2
         nMjvCQAxQVmBKstTHIwgqIAurIQGd0IqpGoYPYRXJFZoxxmKtc37CAbd1ipXAFJHstZB
         f+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758174737; x=1758779537;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OrpQJriL4FmpAUbfKPWp2N95VS4dJzH5lWC3tT3JW/M=;
        b=Ufi1leJNkyhaEsvWOmLTXvnnecTiCpfs9sRuJkuNr7XuyecG9iHt8ITex08YZudZRN
         yqeFlSpkauhtiSZ2FTJFAMcEHd0mMRTixn2q6MElLf8j2PjatUYAmTPtV43NwDJ3jY5Y
         Ht2pH0wBghV7+DyQDz2Wffwz2Ytuz4imCTDnqd6OAxSDSY/6QsjC0R0NNZpCNNvuHLVg
         NS86OCYDj4e6XcHeR+L2LcNvcsUEbSFtWzBI4LKbwA3GpXeDKc8cH5yTfIPziW0aEAAv
         BfALzqZhha3m8K5Dki1R9pzqRPnackfIozRilsK5/8NzFVg414Z0X4/fbW9mC/9E0idO
         xZFQ==
X-Gm-Message-State: AOJu0YzL+/IQt946bBsJjbOnvvp8LEBMGlb3yyNBY9Sy5hAzzqwQjFGl
	zrnysE6GCvusCx+xWWU+ymjEEYXn/RXCpNw1R8vNMecK/xFViQoAzDKp6OFnvz/UwqYJpWTSDJu
	S10APelor6Lhtufmv+u+Ty1StTw==
X-Google-Smtp-Source: AGHT+IFE+8ETrwWWgWlvlg5hq9y0nqRrKyR7ndazOBg2j7ddVSfVDEvMSe4lTfKjz1MojZ4nb0cODExWdf2xKyUwqw==
X-Received: from plgi5.prod.google.com ([2002:a17:902:cf05:b0:267:e3c2:182d])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ecd1:b0:265:44ae:d24 with SMTP id d9443c01a7336-268139030d1mr64023535ad.43.1758174737520;
 Wed, 17 Sep 2025 22:52:17 -0700 (PDT)
Date: Wed, 17 Sep 2025 22:51:33 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918055135.2881413-1-lokeshgidra@google.com>
Subject: [PATCH 0/2] Improve UFFDIO_MOVE scalability by removing anon_vma lock
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	jannh@google.com, Lokesh Gidra <lokeshgidra@google.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8D6C4000A
X-Stat-Signature: udtqxudamsp4e9co9gh34kc36cfbs8t8
X-Rspam-User: 
X-HE-Tag: 1758174738-113739
X-HE-Meta: U2FsdGVkX1/q8MQGMEdib2iH5r45LNu67cSK/TWn2+2IfB29rqZ+ALtgSqMUFxSlbOLWR4aSkJ0W1AYwfJyDrlYyHIQle9XZ5XtxgqjtajFnLonLWOfuwyllCph7znvDzyhF0LW9gdSMGqnivM4fa4bOjuPCuVYd+OBEPwsLp2LWHoxDoglQg7sHwqdpm69LWgZj7bLYmy/yHMUWSbyqQNlYNUz4XB9yRZ8JXs3uztA46ayNHkgtTbOhkdj0MfpSSETdYMRsDGqYmzl010LMe8yegEfz0pFq8ao2r6fWxYGZSi+LYNnI2lofUtsOucZpfeyZHtLTd3VOkFGEK4k5wzQSKbTj6zA60KI/ZxmVhB6H504YjdtYw6eQnt4cZNlKFRUVUhBb8Ts6aZOmckp/m6wOVyTHSg0WmAv0Cn9af+fGHz1v+AE/+KFWTcUPyfA80EfrYsUyul2ToTQNtQJp51LgFDyS2m26xM4YiwWEvD7DXbbOL68T6FmtdCcQyH15SjaTcxNebTkN6KMb+lquKlll00EL+yh0rOe8OBI4SVxao4b4MIeRfk86eO2f0osPKrZotIByrZlgcRmGxZP2kKYgSrfImbTuH7FPuJ441P3hDaaxKbVlevLE9gDtYY5hrl3ZcmWdeECil9S6aSllHuxj/4eFt8bDMBioSoluZK/fbfSKcx5ZFUy0b9UlfMHvLArfHYSiPIjU1uCGSKpFzbGk5z1WtTDzUHoYu1qAtEKlcl0yokTdwhFU1/uEYdB7zJAkeWf2iIG5ZS9pSPvvWeEMDUvHotHBcu6cMhBc3vRw6CMqLtUnZwdwJR/owRzl2eEvXSyvBGcXSoCyLms3z8VQfXhoyST/gpFBKVFAKANt5Uh8upsQarBbqc5pjCz6JDjL5gDGKT+ET41FR0P2YZBSkgsGKLpEigawtTt0g0oog3bDRw1Q60F7PpHoTJJD1bZksSO4WHcbfSV2mUa
 enMbrAnN
 p7jEwIAx9i0CGRUHtDDfSYpNqB7IiS+qen0ZQ9q6ejE+tZqdaL2E3DmsnlEobGgEqmbwkpGNW4cdCg0fFWK8m8SYD4EjmLM/rXX7Qs6JbvgABc9Zs5VjaSJ0Rfw/SNs0mMwO7H7WUj/6wgmer9K2c/FK1pVF5EnLTNHz4Iut7HKmsJUu0IciMOTvFcx1OTmxdMDEJ6EAhOaYZZsb5Hgv7ikgCzfTXXXqfcF6B9S6GAa8RbiA6aOTOK3E+mS6ghvjHJivH/KXd+hN6X671uN5osMPxEnoCvM8ckv7SIba4zJ87N9v4/OgnVL1AT/vStsz807uRlPbnCcTJnyWVjO5DnHqibBvH3xkSF/OSD8nNkin6tNhtzgjys416SZyU6pN910swYRYlWx7DR/qOt2Z7NdBrQU/HO23bl8nn16O2F5vGeTgBoinJuEOM8E6aKT7Kr+uY5pFHVUfUVjfY4CgIuqOCqi+4Fi1SMGbJ9JnLHX2G0bBAFGv8qiZErfXQXLms09jokR7lHK6cy7vSFm/o//yAjVqH5qdfjHGiYIAV4Y4xnlJbLu1tFdTFiIviYZDloQIXdbtlmV4QMY9+jU3FJjJeSeunE/Z878E3EoLFL0Fjv4OHrU2Y7ct/9xdI+wqNqHjWFhFMIS6CfXgNnWIMxYypGRpyPjOsJwUmmpsMksJwP41EnHAhv3NJTW42gaQfsHfWpVp4s/nGdzsPx7YDPkqcExGmMeNzD7Z4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userfaultfd has a scalability issue in its UFFDIO_MOVE ioctl, which is
heavily used in Android as its java garbage collector uses it for
concurrent heap compaction.

The issue arises because UFFDIO_MOVE updates folio->mapping to an
anon_vma with a different root, in order to move the folio from a src
VMA to dst VMA. It performs the operation with the folio locked, but
this is insufficient, because rmap_walk() can be performed on non-KSM
anonymous folios without folio lock.

This means that UFFDIO_MOVE has to acquire the anon_vma write lock
of the root anon_vma belonging to the folio it wishes to move.

This causes scalability bottleneck when multiple threads perform
UFFDIO_MOVE simultanously on distinct pages of the same src VMA. In
field traces of arm64 android devices, we have observed janky user
interactions due to long (sometimes over ~50ms) uninterruptible
sleeps on main UI thread caused by anon_vma lock contention in
UFFDIO_MOVE. This is particularly severe during the beginning of
GC's compaction phase when it is likely to have multiple threads
involved.

This patch resolves the issue by removing the exception in rmap_walk()
for non-KSM anon folios by ensuring that all folios are locked during
rmap walk. This is less problematic than it might seem, as the only
major caller which utilises this mode is shrink_active_list().

To assess the impact of locking non-KSM anon folios in
shrink_active_list(), we performed an app cycle test on an arm64
android device. During the whole duration of the test there were over
140k invocations of the function, out of which over 29k had at least
one non-KSM anon folio on which folio_referenced() was called. In none
of these invocations folio_trylock() failed.

Of course, we now take a lock where we wouldn't previously have. In the
past it would have had a major impact in causing a CoW write fault to
copy a page in do_wp_page(), as commit 09854ba94c6a ("mm: do_wp_page()
simplification") caused a failure to obtain folio lock to result in a
page copy even if one wasn't necessary.

However, since commit 6c287605fd56 ("mm: remember exclusively mapped
anonymous pages with PG_anon_exclusive"), and the introduction of the
folio anon exclusive flag, this issue is significantly mitigated.

The only case remaining that we might worry about from this perspective
is that of read-only folios immediately after fork where the anon
exclusive bit will not have been set yet.

We note however in the case of read-only just-forked folios that
wp_can_reuse_anon_folio() will notice the raised reference count
established by shrink_active_list() via isolate_lru_folios() and refuse
to reuse in any case, so this will in fact have no impact - the folio
lock is ultimately immaterial here.

All-in-all it appears that there is little opportunity for meaningful
negative impact from this change.

As a result of changing our approach to locking, we can remove all
the code that took steps to acquire an anon_vma write lock instead
of a folio lock. This results in a significant simplification and
scalability improvement of the code (currently only in UFFDIO_MOVE).
Furthermore, as a side-effect, folio_lock_anon_vma_read() gets simpler
as we don't need to worry that folio->mapping may have changed under us.

Prior discussions on this can be found at [1, 2].

[1] https://lore.kernel.org/all/CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com/
[2] https://lore.kernel.org/all/20250908044950.311548-1-lokeshgidra@google.com/

Lokesh Gidra (2):
  mm: always call rmap_walk() on locked folios
  mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE

CC: David Hildenbrand <david@redhat.com>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Harry Yoo <harry.yoo@oracle.com>
CC: Peter Xu <peterx@redhat.com>
CC: Suren Baghdasaryan <surenb@google.com>
CC: Barry Song <baohua@kernel.org>
CC: SeongJae Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 16 +++--------
 mm/huge_memory.c      | 22 +--------------
 mm/memory-failure.c   |  3 +++
 mm/page_idle.c        |  8 ++----
 mm/rmap.c             | 42 +++++++++--------------------
 mm/userfaultfd.c      | 62 ++++++++-----------------------------------
 6 files changed, 33 insertions(+), 120 deletions(-)


base-commit: 27efecc552641210647138ad3936229e7dacdf42
-- 
2.51.0.384.g4c02a37b29-goog


