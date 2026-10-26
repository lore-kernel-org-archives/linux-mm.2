Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9FA606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=IGCs/0uv
Received: by kanga.kvack.org (Postfix)
	id E56426B05B2; Mon, 26 Oct 2026 16:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2DCA6B05B3; Mon, 26 Oct 2026 16:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF77D6B05B4; Mon, 26 Oct 2026 16:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2526B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:08:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E66AF80863
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:08:39 +0000 (UTC)
X-FDA: 85365865158.15.451577D
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00ED840006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:08:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="IGCs/0uv";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793045318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vi1QzgyRBpyekiT07UU7dOAjSc1hZ564EveQywlmSYI=;
	b=Tx9wwEnQ16kMXKkQMBdM4B5wVoTp6MDvlRiuje1nravuV+YGxAuPtTSoXoOdzqTgeJaJn3
	dBTqQf0i7u3l82SbfHg58sY496liuXrAmgTkaFp3UDHhHgyt5oAReCdu7T3cOKbYM/PBEE
	dpyurK2L0LVkKswwEPwZiokp09E1hdQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="IGCs/0uv";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793045318;
	b=Z6DZyOPrTNXitWWItr8YbVC9+99zKzYY41ElumleNUG+UFBzbsOC2CYA5/CdGt3WJgvjzG
	CdRb6MaD3LP9bQmyOL3a85bu7J7GUv5HZIPq7WohUxW4VB3wFJi9vwM/6/g35ckyPS/9kI
	xoXzntLoYqOh3CU8uCiGMnCfQG1jAQk=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91b834592afso43565626d6.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793045317; x=1793650117; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vi1QzgyRBpyekiT07UU7dOAjSc1hZ564EveQywlmSYI=;
        b=IGCs/0uvMO+n+VJ/pGUw8Lmz5yHs2BkXRXeR2gt1xFjlipgBDn8tBsoyZhRETlq9d1
         87fRwcq8YX3abSS/VTBg78z+2WyWkMmZf+fYIG40OrhIaQi7WoLnbOSqDqmQ0sQTCiCW
         xRIKc+VSzWFlcOWi+NvISN4iUoQ+32Xs1WnMH/Njvv5HZe1PCqacVGya7HpSmjeicyk3
         RurjyfXm7b7adTStg3ggMxa/Yxo7eJ49yO5wv/kTvoCwGt1xwB/ZWDfdorWp4+D7SBL5
         LHfq6c2jXb74skAkwKSjrgbocQjd2lodvXBlIrnN/VZtYt2+SXMBILgiDgFvc6zScvof
         kxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793045317; x=1793650117;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vi1QzgyRBpyekiT07UU7dOAjSc1hZ564EveQywlmSYI=;
        b=yB2oMWaAoew3j8Y8KZYnctJ83Rl27YyigSE4pvKSt9dV3TDj5ujQrWddIuiugaWrEQ
         w7Jynx84GH3YseXaABc/CcWH51tH7GD9OrdxMrHNQCRYL8neazVIgHPwLxKs/vDw0elo
         C6H7rBi19xiEj1PWirJ4FnCs7htj8DQoHME3hYu0RSMRVOt/kl8hM6Fu9FkS1C6AgWVX
         rd6F+mrL9v0jVuI3hJhLskyu0f2+1NaRFDDRgHcidgAFEizDfMSKEJOXdupRNkVWzydM
         lavhWf5h/KlIqx1lZh4ss72vA1fHjk8Df2EheQmqg8PMHwQN/5zd/SWbvIqs4YD3Pg5e
         JX/A==
X-Forwarded-Encrypted: i=1; AKwUvBxBkcPuOahK0brcHLGYhf+efWuB+a2dObhsnLLQ7aUxcZjcYcmOjAfRMBrIvYt7+o/VzBR8GtAUbg==@kvack.org
X-Gm-Message-State: AFq9FYLiIbpUk8wSqqTR6emE533hbBLFYuziFqUx+PMTziQcXBakmKkz
	u1mXryb+QfaSMruy5hH0+Z+ZkyxO/zMnsU4NBSdZER1x3PC+6pj1zk9u/bSiH7FG5Z8=
X-Gm-Gg: AYBFou2jOhbTsWxumXhW8FEsQFOJ+aCoO1QcdqwCB9epLpI17k7zupnAOQlQpncuT3Y
	3Sv8mqkAYScHuATWE4ikfJUdmcTW52QrJFNbqCvS4lRJ/H4iwDp+ZTzlSqgxP6+sauZdMj9n0wf
	fQRbQs9iQL2eHWtDffkRPe4jMgjTZvkyQcQEWr2xElrS4TuVOcFn8tZ4tV1h/UOec/vPmHDhoUl
	pLdt9yjBZzKgRnFfcJthUEcpjktcu9KWUhS1E/Rq64WjK/vqLVpc9AJDw2wGpPoOcPr33tM47D2
	O+EdxaxpIFB5qJZCWQEgJ9tu4ksaPLPO8wV50aEuB2gav9bLLhaxyFCHZgopqVNBa2QJhK6qXkq
	ZOJUYg4jhA+ZlDv4GxxzJ66fvaZ3QKdIEELGtnlvnQgRlce4WgCO+/E+g82LkHtj0x6Cfc4AYm3
	01D3L5MhFm/NZrzyEZqSfXSmpuazusY3Q+Sy17J+RTPOx+M7A3Ts4do3L5hzrX6KkdfZ3+seMwN
	+icxJRsWqMKxJq6Hzq5kSgaoiDW0RSrTfeupVrk0YE9XgnmppNTurzGGPyg0F5h89+lLScaQGpW
	Y7US0cAgxYyB4lFFtQnrR9pCZXh01KwiXgt4
X-Received: by 2002:a05:6214:4992:b0:91b:5d3a:4fc4 with SMTP id 6a1803df08f44-91c48eb281fmr130267166d6.49.1793045316617;
        Mon, 26 Oct 2026 13:08:36 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47cddda5sm82519096d6.41.2026.10.26.13.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:08:35 -0700 (PDT)
Date: Mon, 26 Oct 2026 16:08:28 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>, Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
Message-ID: <at-yaxmjeOXtA15M@gourry-fedora-PF4VCD3F>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
X-Rspamd-Queue-Id: 00ED840006
X-Rspam-User: 
X-Stat-Signature: uayw18u53c97tpjti9x4rj7n73wrgu7g
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793045317-789740
X-HE-Meta: U2FsdGVkX19iuYlr+9bfSGq9vPcG5MY+Zye5TW/sw7o5CY8PXNX0/F4ci91eMilBitZ0ryex50loYgoioiGobowHC7DdKz4MV/RZjvxKmnmXFKbVrMxaheQxGiP726ds8lFHlRUQVILijAuwQXaWKmWjVHxhlnjczyBMhcOVqU5uoE+Ewdg2sG+/FIC2VL2SWylm7azxBoH/3WXQyjWBSE0242jauLerZEsXwFJCii6TSFEn7385qQr4z73Is4UjQHyjvrI+v6OYBwgEH9Kn0TGtUtyjj/f0bbNtL2PXaWSrtMCxB8JtQ446YWV8JnA2k00OkCgMgwf6Tpl1BaFqIg/5vT3rkcMQMHiWfY3Jp/NkIfLG792xZke+eK8mLi5PmO+cDQFxHGNMznaLaYcihIln8jty+jHTXvAplBjf+JwJVZjRhmKJNuev9yDPDDzZNXUjWKeHI//Y9p1/tZpwhnfR0I5wmzs0kFPhAMqNk6Q9wYWZSE0WsBAxb1CTfpMtUeJICcDpHaEIClH1sgMoKFfhVxB8J5+kHyCJWQxGEHj68pL/XRUEk+mkLB18f2sWWAmqdqppYtAlPMqNp3b3zfoWmlSKeuymERiWIhnxHPBBu5rfkAUZ4vaegTJCuO7Iea7tQ3IVu2RGi1lVEcKyXZbUyUAvVQsMvnnWqJ+CrZsP6E1/ffbE0QqYmCCpBc5NbIebfALMNln/tanXYMYrkUXpON4w5LmG9s6d5lcQXsCpFB+Ie2dj6dJacy0XHMaGTLWRYGEbaan7knp4++pnQgsR6ZV0i2Mo9xCLlDKBpQwDgLf4EgTUs5G6Eq/FxNP6VUCy5FbTd3QgK2MszNSfh7OxkDr2hIkli/iLvB7OGNgjGgoLSvHJzNjbuXyDHlB4qQhNdPzTNVwuqkZQYL3r3kSgl2ClY+jH7ZiYzWC19LpdthnB79sODDstjFYGuQK9sMl6mzHdhYWXVm6Ew5n
 rlbzLqHM
 cUF7wBf6lkxfJQrEIlQZRVhh6FmAXbCVLX0kpj33ragb5pAxunelgWGLu+javqUxV+uAT0V2ccoB5Bnf81bXSpU+rGe1sVShq1Qwv21n5eQpK216FO9Wq4AANaJsx9lUGM9DhkhNZqwdKqiLALKG4BE+c23/CKGWRA3/68J6uTE69Ezbh/IfPIQfWxn3MnNngzuspwErMImmeOUUWpeuH8tbzH3GCw2V3R+GrUzMSWxoCHhqedLHdGZ5zJ7UzuHatBC75inQ0L5B45GTzDcf8WPUbDTA0uBVRM5Smvmslxk/xyIDUrAXHicW14TCKA8UezHEQgda8K03IoR6/YCiL0hN3+7l8jcdKS+3b1Bd1VmP15vrjX6TgbESdJdW/hq3d25s5pCA+YgsfuiDWf2roywSfTqXzkXDmTpQdsOS7eBfeQcdhNcVAkkJwHvJWik0An1sx5z5bVL1ruBx1XapkK3Wz00yr8w5wv1TfADId1bUwOg2cHvCubX+T87FPPibJlZKkfxoHJfkMVtbZ3zg7SWiz/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:33AM +0100, David Hildenbrand (Arm) wrote:
> I did my best trying to test these fixes. I was able to reproduce some
> of the things (including unkillable truncation hangs), and the fixes seemed
> to help.

Given the (urgent?) you're the unwilling recipient of my schlopp-testing
harness.  The good news is that the selftests (attached) all look
reasonable and reproduce quite easily.

Everything below is largely clanker-generated, but after a review I feel
comfortable with tagging this.

I was able to directly test:
  #1-#5
  #10
  #12-#16

so for those you can add:

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

feel free to take or leave the selftests.

~Gregory

---

Short version: I didn't find any issues introduced by the series, and
everything I could trigger reproduces on the base and is fixed with
the series applied.

What I ran:
  an x86_64 kernel with KASAN and lockdep, in a virtme-ng VM,
  base vs. series, with a reproducer per issue.

Large swap entries came from a 2M huge=always tmpfs file whose PMD
folio was paged out whole to zram (MADV_PAGEOUT).

Swap-in allocation failures were forced by setting memory.max=0 on
the memcg that owns the swap entries.

Swapin-error markers came from a brd swap device with fail_make_request
enabled for the read.

For the swap patches I also built the series patch by patch and checked
that each one fixes its own case: #12 through #16.

---

Base -> series:

  #1  mbind: 400k calls succeed uncharged in an 8M memcg -> memcg OOM
      after ~58k
  #2  quota soft limits of an unused id lost -> kept
  #3  disabled quota limits reset to mount defaults -> kept
  #4  ACL makes an F_SEAL_EXEC memfd 0766 -> EPERM
  #5  fchmod makes an F_SEAL_EXEC hugetlb memfd 0777 -> EPERM
  #10 failed fallocate leaves a page allocated -> fully rolled back
  #12 ftruncate inside a large swap entry hangs (unkillable) -> completes
  #13 read with failing swap-in charge spins (unkillable) -> ENOMEM
  #14 ftruncate with failing boundary swap-in hangs -> completes
  #15 swapped count underflows, swapoff loops forever -> correct
  #16 file of only swapin-error markers reads EIO after truncate+grow
      -> zeroes

#6: I could not reproduce the UAF.

A stress run:
  - zswap
  - memory.zswap.writeback=0
  - incompressible data
  - memory.reclaim racing unlink+close
  - with CPU hogs

did ~700k reactivations racing eviction and produced nothing on base, and
no hangs in the new eviction wait with the series.

#7, #8, #9 and #11 need a fault racing between boundary handling
and the final scan.

These were reviewed but not reproduced.

Review notes, none blocking:

4) #1: with SLAB_ACCOUNT, mpol_shared_policy_init() can now fail under
   memcg pressure. It ignores the failure, so a new file on an mpol=
   mount can silently end up without the mount policy. Minor; maybe
   mention it next to "mbind() can now fail".

6) #4: the check only compares mode bits. A named-user ACL entry can
   still grant execute to another user on a memfd that is already
   group-executable and sealed. That doesn't weaken memfd_noexec (a
   noexec memfd needs mask::x, which flips g+x), so this is just a note.

3) #6: correct, but the reasoning is subtle. No new writeout can start
   once truncation is done, because truncation waits on the folio lock.
   And the swap_cache_del_folio()/folio_mark_dirty() after
   shmem_allow_eviction() are only safe because folio->mapping is NULL
   if the re-add failed. Both would be worth a comment.

2) #11: "folio->mapping set means it was split" is correct today, but
   only implicitly: the !large early return in
   truncate_inode_partial_folio() can't be reached from that call site,
   and __folio_split() never drops the head. +1 to Kiryl's idea of
   returning the split state explicitly in a follow-up.

5) #12/#13: the -EEXIST retry loops, including the new one in
   shmem_get_partial_folio(), still have no fatal_signal_pending()
   check. Any future persistent -EEXIST would hang a task unkillably
   again. Hardening follow-up material.

1) #14: after a failed boundary swap-in, truncation now completes but
   leaves the large swap entry that crosses EOF. If the file is grown
   again, the old data reads back instead of zeroes (1M of it in my
   test). The commit says zeroing is missing, but maybe spell out this
   user-visible effect. It's the file's own data, so no cross-user leak.

Below is a kselftest covering #1-#5, #10 and #12-#16.

All 11 tests pass with the series and all 11 fail on the base (the
three large swap entry tests by hanging).

The swap tests skip unless suitable swap is set up:
  zram for the large-entry tests
  a single swap device with fail_make_request for the marker tests

---
Add regression tests for the "mm/shmem: various (urgent?) fixes" series:

 - mbind() of single pages of an empty memfd from a 4M memcg must hit
   the memcg limit (shared policy nodes are charged);
 - tmpfs quota soft limits and explicitly disabled limits of an id that
   owns no file survive the release of its dquot;
 - F_SEAL_EXEC cannot be bypassed by setting a POSIX access ACL on a
   memfd, nor by fchmod() on a hugetlbfs memfd;
 - a fallocate() that fails with ENOSPC on a huge=always tmpfs frees the
   PMD folio it allocated in front of the requested range;
 - ftruncate() to a page-aligned size inside a PMD-sized swap entry
   terminates and keeps the data below EOF, also when the boundary
   swap-in fails; a read of a non-head page of the entry whose swap-in
   charge fails returns ENOMEM instead of looping;
 - a swapin-error marker is not subtracted from the swapped count twice,
   and a file consisting only of such markers is really truncated.

The swap tests need root and suitable swap (zram for the large swap entry
tests; a single brd-like device with fail_make_request for the
swapin-error tests) and skip otherwise. On unfixed kernels several of
them hit unkillable loops in the kernel: they report failure after a
timeout and leave the stuck task behind.
---
 tools/testing/selftests/mm/Makefile        |   1 +
 tools/testing/selftests/mm/shmem_regress.c | 714 +++++++++++++++++++++
 2 files changed, 715 insertions(+)
 create mode 100644 tools/testing/selftests/mm/shmem_regress.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -98,6 +98,7 @@ TEST_GEN_FILES += ksm_tests
 TEST_GEN_FILES += ksm_functional_tests
 TEST_GEN_FILES += mdwe_test
 TEST_GEN_FILES += hugetlb_fault_after_madv
+TEST_GEN_FILES += shmem_regress
 TEST_GEN_FILES += hugetlb_madv_vs_map
 TEST_GEN_FILES += hugetlb_dio
 TEST_GEN_FILES += droppable
diff --git a/tools/testing/selftests/mm/shmem_regress.c b/tools/testing/selftests/mm/shmem_regress.c
new file mode 100644
--- /dev/null
+++ b/tools/testing/selftests/mm/shmem_regress.c
@@ -0,0 +1,714 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Regression tests for shmem/tmpfs fixes:
+ *
+ *  - mbind() shared policy nodes are charged to the memcg
+ *  - tmpfs quota limits of unused ids survive dquot release
+ *  - F_SEAL_EXEC cannot be bypassed with a POSIX ACL or on hugetlbfs
+ *  - a failed fallocate() frees whole new large folios
+ *  - truncation inside a large swap entry terminates, with and without
+ *    swap-in failures, and swap-in allocation failures return -ENOMEM
+ *  - swapin-error markers are accounted correctly and truncated
+ *
+ * Most tests need root. The swap tests need active swap: a non-rotational
+ * device that takes PMD THPs whole (e.g. zram) for the large-entry tests, and
+ * a single swap device with fail_make_request support (e.g. brd) for the
+ * swapin-error tests. Tests skip when their setup is not available.
+ *
+ * On unfixed kernels several tests trigger unkillable loops in the kernel:
+ * they report failure after a timeout and leave the stuck task behind.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/falloc.h>
+#include <linux/memfd.h>
+#include <linux/mempolicy.h>
+#include <linux/quota.h>
+#include <sys/mman.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <sys/xattr.h>
+
+#include "kselftest_harness.h"
+
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
+#ifndef MFD_NOEXEC_SEAL
+#define MFD_NOEXEC_SEAL 0x0008U
+#endif
+#ifndef F_SEAL_EXEC
+#define F_SEAL_EXEC 0x0020
+#endif
+#ifndef __NR_quotactl_fd
+#define __NR_quotactl_fd 443
+#endif
+
+#define PG		4096UL
+#define THP_SZ		(2UL << 20)
+#define CGROOT		"/sys/fs/cgroup"
+#define FAILDBG		"/sys/kernel/debug/fail_make_request"
+
+/* ------------------------------------------------------------------ */
+/* helpers */
+
+static int write_file(const char *path, const char *val)
+{
+	int fd = open(path, O_WRONLY);
+	ssize_t r;
+
+	if (fd < 0)
+		return -errno;
+	r = write(fd, val, strlen(val));
+	close(fd);
+	return r < 0 ? -errno : 0;
+}
+
+static long read_long(const char *path)
+{
+	char buf[64] = {};
+	int fd = open(path, O_RDONLY);
+
+	if (fd < 0)
+		return -1;
+	if (read(fd, buf, sizeof(buf) - 1) < 0)
+		buf[0] = 0;
+	close(fd);
+	return strtol(buf, NULL, 0);
+}
+
+static long proc_key(const char *path, const char *key)
+{
+	size_t kl = strlen(key);
+	char line[256];
+	long v = -1;
+	FILE *f = fopen(path, "r");
+
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f)) {
+		if (!strncmp(line, key, kl) &&
+		    (line[kl] == ' ' || line[kl] == ':')) {
+			v = strtol(line + kl + 1, NULL, 10);
+			break;
+		}
+	}
+	fclose(f);
+	return v;
+}
+
+/* smaps "Swap:" (kB) of the VMA containing addr. */
+static long smaps_swap_kb(void *addr)
+{
+	unsigned long a = (unsigned long)addr, s, e;
+	char line[512];
+	int in = 0;
+	long v = -1;
+	FILE *f = fopen("/proc/self/smaps", "r");
+
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f)) {
+		if (sscanf(line, "%lx-%lx ", &s, &e) == 2) {
+			in = a >= s && a < e;
+			continue;
+		}
+		if (in && !strncmp(line, "Swap:", 5)) {
+			v = strtol(line + 5, NULL, 10);
+			break;
+		}
+	}
+	fclose(f);
+	return v;
+}
+
+/*
+ * Run fn(arg) in a child, wait up to secs. Returns the exit code, 128+sig if
+ * killed, or -1 if the child is stuck (left behind: possibly unkillable).
+ */
+static int run_with_timeout(int (*fn)(void *), void *arg, int secs)
+{
+	pid_t pid = fork();
+	int status, i;
+
+	if (pid < 0)
+		return -2;
+	if (!pid)
+		_exit(fn(arg));
+	for (i = 0; i < secs * 10; i++) {
+		if (waitpid(pid, &status, WNOHANG) == pid)
+			return WIFEXITED(status) ? WEXITSTATUS(status) :
+				128 + WTERMSIG(status);
+		usleep(100000);
+	}
+	kill(pid, SIGKILL);
+	usleep(500000);
+	if (waitpid(pid, &status, WNOHANG) == pid)
+		return 128 + SIGKILL;
+	return -1;
+}
+
+static void fill_pattern(char *buf, size_t len, int seed)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++)
+		buf[i] = (char)((((i / PG) * 31) + seed) | 1);
+}
+
+static int join_cgroup(const char *cg)
+{
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%d", getpid());
+	return write_file(cg, buf);
+}
+
+/* Create CGROOT/<name> with the memory controller; returns 0 on success. */
+static int make_memcg(const char *dir)
+{
+	if (access(CGROOT "/cgroup.controllers", F_OK))
+		return -1;
+	write_file(CGROOT "/cgroup.subtree_control", "+memory");
+	rmdir(dir);
+	if (mkdir(dir, 0755) && errno != EEXIST)
+		return -1;
+	return 0;
+}
+
+static int mount_tmpfs(char *dir, const char *opts)
+{
+	strcpy(dir, "/tmp/shmem_regress.XXXXXX");
+	if (!mkdtemp(dir))
+		return -1;
+	if (mount("tmpfs", dir, "tmpfs", 0, opts)) {
+		rmdir(dir);
+		return -1;
+	}
+	return 0;
+}
+
+static void umount_tmpfs(char *dir)
+{
+	umount2(dir, MNT_DETACH);
+	rmdir(dir);
+}
+
+FIXTURE(shmem) {
+	int dummy;
+};
+
+FIXTURE_SETUP(shmem)
+{
+}
+
+FIXTURE_TEARDOWN(shmem)
+{
+}
+
+/* ------------------------------------------------------------------ */
+/* mm/mempolicy: charge shared policy nodes */
+
+#define MBIND_CG CGROOT "/shmem_regress_mbind"
+static volatile long *mbind_done;
+
+static int mbind_child(void *arg)
+{
+	unsigned long nodemask = 1;
+	long i;
+	int fd;
+
+	if (join_cgroup(MBIND_CG "/cgroup.procs"))
+		return 2;
+	fd = memfd_create("mbind", 0);		/* stays empty */
+	if (fd < 0)
+		return 2;
+	for (i = 0; i < 200000; i++) {
+		void *p = mmap(NULL, PG, PROT_READ, MAP_SHARED, fd, i * PG);
+
+		if (p == MAP_FAILED)
+			return 3;
+		if (syscall(__NR_mbind, p, PG, (i & 1) ? MPOL_BIND :
+			    MPOL_INTERLEAVE, &nodemask, 64, 0)) {
+			munmap(p, PG);
+			return errno == ENOMEM ? 0 : 3;
+		}
+		munmap(p, PG);
+		*mbind_done = i + 1;
+	}
+	return 1;	/* never hit the limit */
+}
+
+TEST_F_TIMEOUT(shmem, mbind_shared_policy_charged, 300)
+{
+	int rc;
+
+	if (make_memcg(MBIND_CG))
+		SKIP(return, "no cgroup2 memory controller");
+	if (write_file(MBIND_CG "/memory.max", "4M"))
+		SKIP(return, "cannot set memory.max");
+	write_file(MBIND_CG "/memory.swap.max", "0");
+	mbind_done = mmap(NULL, PG, PROT_READ | PROT_WRITE,
+			  MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mbind_done, MAP_FAILED);
+
+	rc = run_with_timeout(mbind_child, NULL, 240);
+	TH_LOG("mbind calls=%ld rc=%d oom_kill=%ld peak=%ld", *mbind_done, rc,
+	       proc_key(MBIND_CG "/memory.events", "oom_kill"),
+	       read_long(MBIND_CG "/memory.peak"));
+	rmdir(MBIND_CG);
+	if (rc == 2 || rc == 3 || rc == -2)
+		SKIP(return, "setup failed (rc=%d)", rc);
+	/* Either mbind() failed with ENOMEM or the memcg OOM killer fired. */
+	EXPECT_TRUE(rc == 0 || rc == 128 + SIGKILL);
+}
+
+/* ------------------------------------------------------------------ */
+/* tmpfs quota limits of unused ids */
+
+static int quota_set(int qfd, unsigned int id, unsigned long long bh,
+		     unsigned long long bs, unsigned long long ih,
+		     unsigned long long is)
+{
+	struct if_dqblk d = {
+		.dqb_bhardlimit = bh, .dqb_bsoftlimit = bs,
+		.dqb_ihardlimit = ih, .dqb_isoftlimit = is,
+		.dqb_valid = QIF_LIMITS,
+	};
+
+	return syscall(__NR_quotactl_fd, qfd, QCMD(Q_SETQUOTA, USRQUOTA), id, &d);
+}
+
+static int quota_get(int qfd, unsigned int id, struct if_dqblk *d)
+{
+	memset(d, 0, sizeof(*d));
+	return syscall(__NR_quotactl_fd, qfd, QCMD(Q_GETQUOTA, USRQUOTA), id, d);
+}
+
+static int quota_mount(char *dir)
+{
+	return mount_tmpfs(dir, "usrquota,usrquota_block_hardlimit=1M,"
+				"usrquota_inode_hardlimit=100");
+}
+
+TEST_F(shmem, quota_soft_limits_of_unused_id)
+{
+	struct if_dqblk d;
+	char dir[64];
+	int qfd;
+
+	if (quota_mount(dir))
+		SKIP(return, "tmpfs quota not available");
+	qfd = open(dir, O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(qfd, 0);
+	/* Only soft limits differ from the mount defaults. */
+	if (quota_set(qfd, 54321, 1024, 512, 100, 50)) {
+		close(qfd);
+		umount_tmpfs(dir);
+		SKIP(return, "Q_SETQUOTA: %s", strerror(errno));
+	}
+	sleep(2);	/* quota_release_work releases the unused dquot */
+	ASSERT_EQ(quota_get(qfd, 54321, &d), 0);
+	EXPECT_EQ(d.dqb_bsoftlimit, 512);
+	EXPECT_EQ(d.dqb_isoftlimit, 50);
+	close(qfd);
+	umount_tmpfs(dir);
+}
+
+TEST_F(shmem, quota_disabled_limits_of_unused_id)
+{
+	struct if_dqblk d;
+	char dir[64];
+	int qfd;
+
+	if (quota_mount(dir))
+		SKIP(return, "tmpfs quota not available");
+	qfd = open(dir, O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(qfd, 0);
+	if (quota_set(qfd, 54322, 0, 0, 0, 0)) {
+		close(qfd);
+		umount_tmpfs(dir);
+		SKIP(return, "Q_SETQUOTA: %s", strerror(errno));
+	}
+	sleep(2);
+	ASSERT_EQ(quota_get(qfd, 54322, &d), 0);
+	EXPECT_EQ(d.dqb_bhardlimit, 0);
+	EXPECT_EQ(d.dqb_ihardlimit, 0);
+	close(qfd);
+	umount_tmpfs(dir);
+}
+
+/* ------------------------------------------------------------------ */
+/* F_SEAL_EXEC */
+
+TEST_F(shmem, memfd_seal_exec_acl)
+{
+	/* u::rwx g::rw- o::rw- (version 2 xattr), equivalent to mode 0766 */
+	struct { unsigned int v; struct { unsigned short tag, perm;
+		 unsigned int id; } e[3]; } acl = { 2, {
+		{ 0x01, 7, ~0U }, { 0x04, 6, ~0U }, { 0x20, 6, ~0U } } };
+	struct stat st;
+	int fd, r;
+
+	fd = memfd_create("seal_exec_acl", MFD_NOEXEC_SEAL);
+	if (fd < 0)
+		SKIP(return, "MFD_NOEXEC_SEAL not supported");
+	ASSERT_EQ(fcntl(fd, F_GET_SEALS) & F_SEAL_EXEC, F_SEAL_EXEC);
+	r = fsetxattr(fd, "system.posix_acl_access", &acl, sizeof(acl), 0);
+	if (r && errno == EOPNOTSUPP) {
+		close(fd);
+		SKIP(return, "no tmpfs POSIX ACLs");
+	}
+	ASSERT_EQ(fstat(fd, &st), 0);
+	EXPECT_EQ(st.st_mode & 0111, 0);
+	EXPECT_EQ(r, -1);
+	EXPECT_EQ(errno, EPERM);
+	close(fd);
+}
+
+TEST_F(shmem, hugetlb_memfd_seal_exec_fchmod)
+{
+	struct stat st;
+	int fd, r;
+
+	fd = memfd_create("seal_exec_huge", MFD_HUGETLB | MFD_NOEXEC_SEAL);
+	if (fd < 0)
+		SKIP(return, "hugetlb memfd not available");
+	r = fchmod(fd, 0777);
+	ASSERT_EQ(fstat(fd, &st), 0);
+	EXPECT_EQ(st.st_mode & 0111, 0);
+	EXPECT_EQ(r, -1);
+	EXPECT_EQ(errno, EPERM);
+	close(fd);
+}
+
+/* ------------------------------------------------------------------ */
+/* fallocate rollback of new large folios */
+
+TEST_F(shmem, falloc_rollback_frees_large_folio)
+{
+	char dir[64], path[96];
+	struct stat st;
+	int fd, r;
+
+	if (mount_tmpfs(dir, "size=4M,huge=always"))
+		SKIP(return, "cannot mount huge=always tmpfs");
+	/* Another file takes some space, so the fallocate below runs out. */
+	snprintf(path, sizeof(path), "%s/other", dir);
+	fd = open(path, O_RDWR | O_CREAT, 0644);
+	ASSERT_EQ(pwrite(fd, "x", 1, 0), 1);
+	close(fd);
+
+	snprintf(path, sizeof(path), "%s/f", dir);
+	fd = open(path, O_RDWR | O_CREAT, 0644);
+	ASSERT_GE(fd, 0);
+	/* Index 1 allocates a PMD folio at index 0, then ENOSPC. */
+	r = fallocate(fd, 0, PG, (4UL << 20) - PG);
+	ASSERT_EQ(fstat(fd, &st), 0);
+	close(fd);
+	umount_tmpfs(dir);
+	if (!r)
+		SKIP(return, "fallocate did not fail");
+	EXPECT_EQ(st.st_blocks, 0) {
+		TH_LOG("failed fallocate left %lld sectors allocated",
+		       (long long)st.st_blocks);
+	}
+}
+
+/* ------------------------------------------------------------------ */
+/* large swap entries */
+
+#define LSWAP_CG CGROOT "/shmem_regress_lswap"
+static char lswap_path[128];
+static char *lswap_pattern;
+
+static int lswap_make(void *in_memcg)
+{
+	long swp0, swp1;
+	char *p, *map;
+	size_t i;
+	int fd;
+
+	if (in_memcg && join_cgroup(LSWAP_CG "/cgroup.procs"))
+		return 10;
+	fd = open(lswap_path, O_RDWR | O_CREAT | O_TRUNC, 0644);
+	if (fd < 0 || pwrite(fd, lswap_pattern, THP_SZ, 0) != (ssize_t)THP_SZ)
+		return 11;
+	p = mmap(NULL, 2 * THP_SZ, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	map = (char *)(((unsigned long)p + THP_SZ - 1) & ~(THP_SZ - 1));
+	map = mmap(map, THP_SZ, PROT_READ, MAP_SHARED | MAP_FIXED, fd, 0);
+	if (map == MAP_FAILED)
+		return 12;
+	for (i = 0; i < THP_SZ; i += PG)
+		(void)*(volatile char *)(map + i);
+	swp0 = proc_key("/proc/vmstat", "thp_swpout");
+	if (madvise(map, THP_SZ, MADV_PAGEOUT))
+		return 13;
+	swp1 = proc_key("/proc/vmstat", "thp_swpout");
+	/* Need one PMD-sized swap entry covering the whole file. */
+	if (swp1 == swp0 || smaps_swap_kb(map) != THP_SZ / 1024)
+		return 14;
+	return 0;
+}
+
+static int lswap_truncate(void *arg)
+{
+	int fd = open(lswap_path, O_RDWR);
+
+	return fd < 0 || ftruncate(fd, THP_SZ / 2) ? 1 : 0;
+}
+
+static int lswap_read_page1(void *arg)
+{
+	char buf[PG];
+	int fd = open(lswap_path, O_RDONLY);
+	ssize_t r = pread(fd, buf, PG, PG);
+
+	if (r < 0)
+		return errno == ENOMEM ? 0 : 1;
+	return 5;	/* swap-in did not fail */
+}
+
+static int lswap_setup(struct __test_metadata *_metadata, char *dir,
+		       bool memcg)
+{
+	int rc;
+
+	if (read_long("/proc/sys/vm/swappiness") < 0 ||
+	    proc_key("/proc/meminfo", "SwapFree") <= 4096)
+		return -1;
+	if (memcg && make_memcg(LSWAP_CG))
+		return -1;
+	if (mount_tmpfs(dir, "huge=always"))
+		return -1;
+	snprintf(lswap_path, sizeof(lswap_path), "%s/f", dir);
+	lswap_pattern = malloc(THP_SZ);
+	fill_pattern(lswap_pattern, THP_SZ, 7);
+	rc = run_with_timeout(lswap_make, memcg ? (void *)1 : NULL, 60);
+	if (rc) {
+		TH_LOG("could not create a PMD-sized swap entry (rc=%d)", rc);
+		umount_tmpfs(dir);
+		return -1;
+	}
+	return 0;
+}
+
+/* Data below the new EOF intact; returns stale non-zero bytes past it. */
+static long lswap_check(struct __test_metadata *_metadata)
+{
+	char *buf = malloc(THP_SZ);
+	int fd = open(lswap_path, O_RDWR);
+	struct stat st;
+	long i, nz = 0;
+
+	ASSERT_EQ(fstat(fd, &st), 0);
+	EXPECT_EQ(st.st_size, THP_SZ / 2);
+	ASSERT_EQ(ftruncate(fd, THP_SZ), 0);
+	ASSERT_EQ(pread(fd, buf, THP_SZ, 0), THP_SZ);
+	EXPECT_EQ(memcmp(buf, lswap_pattern, THP_SZ / 2), 0);
+	for (i = THP_SZ / 2; i < THP_SZ; i++)
+		nz += buf[i] != 0;
+	close(fd);
+	free(buf);
+	return nz;
+}
+
+TEST_F_TIMEOUT(shmem, truncate_inside_large_swap_entry, 180)
+{
+	char dir[64];
+	int rc;
+
+	if (lswap_setup(_metadata, dir, false))
+		SKIP(return, "no swap that takes PMD THPs whole");
+	rc = run_with_timeout(lswap_truncate, NULL, 30);
+	ASSERT_NE(rc, -1) {
+		TH_LOG("ftruncate() inside a large swap entry hangs");
+	}
+	ASSERT_EQ(rc, 0);
+	EXPECT_EQ(lswap_check(_metadata), 0);
+	umount_tmpfs(dir);
+}
+
+TEST_F_TIMEOUT(shmem, swapin_enomem_inside_large_swap_entry, 180)
+{
+	char dir[64];
+	int rc;
+
+	if (lswap_setup(_metadata, dir, true))
+		SKIP(return, "no memcg or no swap that takes PMD THPs whole");
+	/* The swap-in charge goes to the swap owner: make it fail. */
+	ASSERT_EQ(write_file(LSWAP_CG "/memory.max", "0"), 0);
+	rc = run_with_timeout(lswap_read_page1, NULL, 30);
+	write_file(LSWAP_CG "/memory.max", "max");
+	ASSERT_NE(rc, -1) {
+		TH_LOG("read with failing swap-in charge spins in the kernel");
+	}
+	if (rc == 5) {
+		umount_tmpfs(dir);
+		SKIP(return, "swap-in charge did not fail");
+	}
+	EXPECT_EQ(rc, 0);
+	umount_tmpfs(dir);
+	rmdir(LSWAP_CG);
+}
+
+TEST_F_TIMEOUT(shmem, truncate_inside_large_swap_entry_swapin_fails, 180)
+{
+	char dir[64];
+	long stale;
+	int rc;
+
+	if (lswap_setup(_metadata, dir, true))
+		SKIP(return, "no memcg or no swap that takes PMD THPs whole");
+	ASSERT_EQ(write_file(LSWAP_CG "/memory.max", "0"), 0);
+	rc = run_with_timeout(lswap_truncate, NULL, 30);
+	write_file(LSWAP_CG "/memory.max", "max");
+	ASSERT_NE(rc, -1) {
+		TH_LOG("ftruncate() with failing boundary swap-in hangs");
+	}
+	ASSERT_EQ(rc, 0);
+	stale = lswap_check(_metadata);
+	/* Known limitation: no zeroing when the boundary swap-in fails. */
+	if (stale)
+		TH_LOG("%ld stale bytes visible past the old EOF", stale);
+	umount_tmpfs(dir);
+	rmdir(LSWAP_CG);
+}
+
+/* ------------------------------------------------------------------ */
+/* swapin-error markers */
+
+static char failknob[128];
+
+/* The only active swap device must support fail_make_request. */
+static int swapfail_setup(void)
+{
+	char line[256], dev[128] = "", *base;
+	int n = 0;
+	FILE *f = fopen("/proc/swaps", "r");
+
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f))
+		if (line[0] == '/' && sscanf(line, "%127s", dev) == 1)
+			n++;
+	fclose(f);
+	if (n != 1)
+		return -1;
+	base = strrchr(dev, '/') + 1;
+	snprintf(failknob, sizeof(failknob), "/sys/block/%s/make-it-fail", base);
+	if (access(failknob, W_OK) || access(FAILDBG "/probability", W_OK))
+		return -1;
+	write_file(FAILDBG "/probability", "100");
+	write_file(FAILDBG "/interval", "1");
+	write_file(FAILDBG "/times", "-1");
+	write_file(FAILDBG "/verbose", "0");
+	write_file("/proc/sys/vm/page-cluster", "0");
+	return 0;
+}
+
+/* Swap out npages of a new file; returns the mapping (PTEs are gone). */
+static char *swapped_file(const char *path, int npages, int *fdp)
+{
+	char *buf = malloc(npages * PG), *map;
+	int fd, i;
+
+	fill_pattern(buf, npages * PG, 3);
+	fd = open(path, O_RDWR | O_CREAT | O_TRUNC, 0644);
+	if (fd < 0 || pwrite(fd, buf, npages * PG, 0) != (ssize_t)(npages * PG))
+		return MAP_FAILED;
+	free(buf);
+	map = mmap(NULL, npages * PG, PROT_READ, MAP_SHARED, fd, 0);
+	if (map == MAP_FAILED)
+		return map;
+	for (i = 0; i < npages; i++)
+		(void)*(volatile char *)(map + i * PG);
+	madvise(map, npages * PG, MADV_PAGEOUT);
+	*fdp = fd;
+	return map;
+}
+
+/* Read page idx with I/O errors injected: installs a swapin-error marker. */
+static ssize_t read_with_ioerr(int fd, long idx)
+{
+	char buf[PG];
+	ssize_t r;
+
+	write_file(failknob, "1");
+	r = pread(fd, buf, PG, idx * PG);
+	write_file(failknob, "0");
+	return r;
+}
+
+TEST_F(shmem, swapin_error_marker_accounting)
+{
+	char dir[64], path[96], *map;
+	int fd;
+
+	if (swapfail_setup())
+		SKIP(return, "need a single swap device with fail_make_request");
+	if (mount_tmpfs(dir, "huge=never"))
+		SKIP(return, "cannot mount tmpfs");
+	snprintf(path, sizeof(path), "%s/f", dir);
+	map = swapped_file(path, 2, &fd);
+	ASSERT_NE(map, MAP_FAILED);
+	if (smaps_swap_kb(map) != 8) {
+		umount_tmpfs(dir);
+		SKIP(return, "pages were not swapped out");
+	}
+	ASSERT_EQ(read_with_ioerr(fd, 0), -1);
+	ASSERT_EQ(errno, EIO);
+	EXPECT_EQ(smaps_swap_kb(map), 4);
+	/* Removing the marker must not touch info->swapped again. */
+	ASSERT_EQ(fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			    0, PG), 0);
+	EXPECT_EQ(smaps_swap_kb(map), 4) {
+		TH_LOG("page 1 is still on swap but info->swapped dropped");
+	}
+	munmap(map, 2 * PG);
+	close(fd);
+	umount_tmpfs(dir);
+}
+
+TEST_F(shmem, truncate_file_of_swapin_error_markers)
+{
+	char dir[64], path[96], buf[PG], *map;
+	int fd, i, nz = 0;
+
+	if (swapfail_setup())
+		SKIP(return, "need a single swap device with fail_make_request");
+	if (mount_tmpfs(dir, "huge=never"))
+		SKIP(return, "cannot mount tmpfs");
+	snprintf(path, sizeof(path), "%s/f", dir);
+	map = swapped_file(path, 1, &fd);
+	ASSERT_NE(map, MAP_FAILED);
+	if (smaps_swap_kb(map) != 4) {
+		umount_tmpfs(dir);
+		SKIP(return, "page was not swapped out");
+	}
+	munmap(map, PG);
+	ASSERT_EQ(read_with_ioerr(fd, 0), -1);
+	ASSERT_EQ(ftruncate(fd, 0), 0);
+	ASSERT_EQ(ftruncate(fd, PG), 0);
+	memset(buf, 0x55, sizeof(buf));
+	ASSERT_EQ(pread(fd, buf, PG, 0), PG) {
+		TH_LOG("truncate to 0 left the swapin-error marker: %s",
+		       strerror(errno));
+	}
+	for (i = 0; i < PG; i++)
+		nz += buf[i] != 0;
+	EXPECT_EQ(nz, 0);
+	close(fd);
+	umount_tmpfs(dir);
+}
+
+TEST_HARNESS_MAIN


