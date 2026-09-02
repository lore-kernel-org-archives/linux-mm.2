Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC66C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D319C6B0088; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1D36B0095; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7796B0096; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8A46B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05BBCC013E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:03 +0000 (UTC)
X-FDA: 85168353606.29.BECC8B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 070BB160002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DXd/CcMz";
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788342661;
	b=TzRDAhLf5uAwa2PF0AJfusiUaMN3JJ+v79JEyyQIIhKVwu0pOv6082gssmK24rVae1Pq0l
	UfyegPvhDiKGtgCztUqo0XW2KpSeUgBIzu17Kj+x8RvREGvov2zm7Uqmumok44sDIQQx8B
	jpZvCjT+mTK+Y0YYs85j91oYmGZTX94=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DXd/CcMz";
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788342661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uvE4J+Eyn115iGbPgwHnn1UchyrJDzc/387TROOfgoI=;
	b=ro7Al1r6QSHPg1ZzF5ZSAfna3ECQeLgmnKZNzZwnYds2SdqSL4TEJs8BKKojyv1HAn+wfg
	AJq+hacE/Pr+kNEPpvkLRlZVNgpSdOyffRZvZCdIkoUQ+5GIzZ6oR9SLzLaAWIxUDpTnMd
	IeMyP2U38v9vqXODPoczn5HvQcEIjVU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DEB5643428;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5900C2BCC7;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342659;
	bh=Og93/Iy3MDmWRZktAaxvbO0Wk7cI2PaKifHhoHZu0iw=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=DXd/CcMzhhpON1qvPbFKCgzs2wHdJC+87rkD1Qvy8UsxEasYI7DRtz9vLZCCaybBL
	 32zmGKieKXtZ6OBKZwvS08Ld+uZQGgPd4TUiS3ZEJENu5InE9eB+j+Uvf8qAujfqhD
	 1DKiaeyoau/xxMBO0okJzEg4cqmayo2txj495KSHKiIT1Z8UJ0Bsu6tYOQ9R/dfWPc
	 iE9iRktJwt6A4mYDSB4HMVjUkbaWuzb05wWw5kBt5jQWIRGCwNOhYnIZMFde0OoGdI
	 yYBJQ6+NGo7ETErxiib0KLcvSTMwtf0XGqP4WAkL4SUrHKNG40ttO5s3xDS6SNj9mU
	 Ya3pN7Mw82tHg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D96C61DD6;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v5 0/6] mm/mglru: clean up folio counters and flag usage
Date: Wed, 02 Sep 2026 17:50:53 +0800
Message-Id: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33PwW6DMAwG4Fepcl6mOCSU9rT3mHYItkMz0VAlg
 DZVvPtCd0Er2vGX7O+37yJzCpzF+XAXieeQwxBLsC8HgRcXO5aBShZa6Vo10Mhr16dJ+t51WWL
 PLk43iWhO6B3V1nhRNm+Jffh6qO8fvzlP7SfjuFLrxCXkcUjfj9oZ1rn/G2aQSjbUtuRQkW7wb
 eSIHMdXHK5i7Zj1RtFmX9FFUaAMVBrAOH5Wqq1S7ytVUejkAY/WlsebZ8VslAr2FVMUTWCJWNG
 R/9yyLMsPyrGtapwBAAA=
X-Change-ID: 20260818-mglru-flags-cleanup-cc49cfad654f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=3388;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Og93/Iy3MDmWRZktAaxvbO0Wk7cI2PaKifHhoHZu0iw=;
 b=9Ic0Xmc+ROewYfhXwzx380eiPLauaLVXfEAvcMEqhvcWjsHkHCJ6mulshuiQBnxWEwrfXhX8J
 TSoiwsaFUrXDxWkdFCM8O8NhzIW0JmIAqJGWqAfjACWz+qHjE5dblyw
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: r5aqfwubhd49m64xak5b346qji7m9zbi
X-Rspamd-Queue-Id: 070BB160002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788342660-446826
X-HE-Meta: U2FsdGVkX1/G9RzMpxoYHhI02sMz5uoFD7mundYEfSCJ90L8W/83L1ux3EEwihuJcIBr0+3CPqsuEaGSm2pORvp3iZ7rmlximrk2xQ2EhykMwhx88v5gKjeJcT7oQpesSfJ/vqQzwSY0GLRi0AZ0dzreNT/DLoHQjKElubw3fx+GQWVrWXF2VT3DRISlWqAvv/WGvTKUu7qq6PgqLwWS56HXlxRTVUB7gsZC14nwu4EygZ2qaXazLIKjvfhLmT6w9itM3JIwDy6FEiUfCAuxIW5nIJirDYhxjOvbH4o5FM9E5wSZuPl64IYuk+lIHWDaSK6oFvP3ARBzt+sQYnjxTaxlK9r8NrVXSV3DMi4rKD3YVbTIo0zGfEwOlsbM49AcMbMWyw4jJZAslHGLlIqKwW9P3ZT/INqizCCm1meuESIUMo9cgl9VZysOnUjiL32Z/0eNqYKailvJwjZPA43cpygEZ7mcJYr95UadxPiiuA7407sU5NmwuaRc7mNaPv62OOhwUm+qd6WYRz6dl012jQSn/thx192fe6w3y72fJokO1TaPuz9buocAyTSyXQ2WJS0YvzGhgWf6EOXASA+QrXpHl5NAxlWfLCoR59xk7lG2kZVN/qp/+CKNmVA8LvnTLW5vHPK/04tgcD85UF5wgcRmvjveVoMJhqaJdRv89gNGKu2fmpx29gKZmXMHb2ErEHoYEpvq8nVn4kKToFyvgnUPalbldJVwOiLHaTH2IC8OD2XrEifvFiAz2wmTAzAlYifjL6VPASlvVh2S4xDPylI/xQz18yzoE2uS7R0AYhyF4oy31mP5MfZTF42AgOXqGVy1Iq74j5xs7fTYFjfQ8oHXao6uIIVfsKs1OEeqdPGKTP6jH2+6q6JprM/B9zPFRLVH4l271acGAhgLzEMIu0t0tkVEwMRl29heOGVXZX2+DPm1t6M4t13ACrxMJNspIJEbq2R+F+ieNcHZpxn
 2x4KP/T/
 D6ciGCSMsKvsxum/nJ3MPJPzJ4CkYXU4pG53NICM4vaf3jXYpasBUabmFPpjkUOSL/e94qsrsGwhgd0tnJXUyPAGw+LspxW/S2O255c/bA9lmwiUEjbKBnKN05+1oR2jUTeJisK2yKdDYSQET10TSCRjSTwClBFgIm4EzcQbONz0NMtgGXoGy/ZEmPidge8axIgT/cxLs6BQtMnLjlo4rbaD9f2eyxLIjVmSe93cBgLEHxtIp4NB/JXTR8hr1W5lIl+9BbXOjKYSik1woTX2zrpMLo0VZOQRidqgBDx5xTjH755AQrWh1OfqTrDTs+KnfmTr86a7GTsVQWbYv1/Oih1bPQD1j1BWpz2QH0JxPJW60tlQ0Kio/CuDyQJq9+hiGnRGyvoGTTSIaZhVCT23lcUVXDgQZAftQRrysZ+lIdj4dgpW4qwDMnH/rfUrqju/07oloo0miZndclcc0JU3ZApjf84oDG01U8B9uCpgAh1IyhHSfGD7dWGnEBdveg+6VdZBDiGpuITEWRuL9PcJHjy1fcEpNQystEaT14knrkI58NHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a cleanup series separated out from the MGLRU-FG series [1]. As
that series is getting too long in following updates, seperate out the
clean up part for easier review and merge.

No feature change is intended, except one bugfix. It mostly replaces
the open-coded bit operations scattered throughout the MGLRU code with
new helpers, with proper kdocs, sanity debug checks, and hardens a few
MGLRU functions.

A subtle generation counter leak is also found during the refactoring
and the fix is included.

Also collected review feedbacks on the cleanup part from the posted
series.

Link: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v5:
- Change atomic long to plain long in patch 1, and adjust commit message.
- Rename is_file to type, and avoid touching folio_is_file_lru in patch 7/7.
- Link to v4: https://patch.msgid.link/20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com

Changes in v4:
- Rename lru_gen_set_flags/lru_gen_from_flags to
  lru_set_gen_flags/lru_get_gen_flags, similiar with lru refs helpers,
  as suggested by [ Barry Song ].
- Added some comments to cover concerned raised by [ Barry Song ] and [
  Baolin Wang ].
- A little code shuffling and better sanity check for concerns raised by 
  [ Ridong Chen ].
- Collect tags.
- Link to v3: https://patch.msgid.link/20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com

Changes in v3:
- Set PG_workingset before setting LRU refs bit to avoid any potential
  under report of folio tier.
- Migrate folio's referenced status before PG_update so lockless readers
  won't set stale referenced status.
- Link to v2: https://patch.msgid.link/20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com

Changes in v2:
- Dropped the redundant LRU_GEN_MAX macro.
- Renamed folio_migrate_refs() to folio_migrate_lru_refs() and reworded
  its commit message to describe the referenced state being transferred.
- Rewrote patch 6's commit message with a detailed analysis of the
  anon/file accounting race.
- Dropped patch 7, it doesn't really fix anything, and might be in
  conflict with other updating series.
- Collected Reviewed-by tags.
- Link to v1: https://patch.msgid.link/20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com

---
Kairui Song (6):
      mm/memcontrol: move the lru_zone_size sanity check to the reader side
      mm/mglru: introduce helpers for manipulating gen and refs flags
      mm/migrate: copy all referenced state via folio_migrate_lru_refs
      mm/mglru: move max_seq read into walk_update_folio
      mm/mglru: use explicit tier range in read_ctrl_pos()
      mm/mglru: fix potential generation folio number leak

 include/linux/memcontrol.h |   9 +++-
 include/linux/mm_inline.h  | 115 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/mmzone.h     |   3 ++
 mm/folio.c                 |  19 ++++----
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   6 +--
 mm/vmscan.c                | 117 +++++++++++++++++++++++----------------------
 7 files changed, 188 insertions(+), 99 deletions(-)
---
base-commit: 893f78beb0477671991ccaae87df75acc484162f
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>



