Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89901FEEF52
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD36B6B00A3; Tue,  7 Apr 2026 10:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7466B00A5; Tue,  7 Apr 2026 10:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE45F6B00A6; Tue,  7 Apr 2026 10:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD4E46B00A3
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:55:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F184C29CA
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:55:48 +0000 (UTC)
X-FDA: 84632059176.14.AF5086D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7789618000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:55:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NuKWF9om;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775573746;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zo5fz8kmoBqMPoqNdgCTbpwxnUovXI2Wz3cn3fpb6g8=;
	b=OHDSL8vJPk/2cXG4peo7j/f+Pd4ygTBdFDzYYIJR6zL3qfL1Cb8m1luKg9VGiTEIn48vQC
	pcMUnaN0o+K+Mh0XMAxzThGpQtC9JwN1X90a0xwvFoFD8bFrw0Oe4M1N2T3oTFGHvCCdUs
	fddd2C736KRW6q0iHGMKNX+xusvnoXs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775573746; a=rsa-sha256;
	cv=none;
	b=K/WuQguHasbDJ2178wnyrNBoqgSYF5PQwJ36uk0XtBlWgCONC+0cs/SHRzy1g8nEhTSm4u
	iL1mw2zREsr49J0b2bsZ+spAm/YyhIIXx3/oVG1xcmMRJIPxJ7Dezgz++ENY4o2sEpg0e3
	lNR1gsVW0KWifGit69xFCgHKL+A5rAs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NuKWF9om;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F01A860123;
	Tue,  7 Apr 2026 14:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B09FC116C6;
	Tue,  7 Apr 2026 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775573745;
	bh=ktiFYUkm17rtWG9ixEvpBIbYQmlh9KYi2e+f5EL5XCo=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=NuKWF9omdnJ/bEfLNjGfch+1eL25hNaS1FkAdfhjVmoIKIGQsNKQMkFLcYPDch7ux
	 gJqBwlgxHIhG7lF4+4hjPhm6JT99+VfGtt1m1MjCdxAxN9P6Qh6HrumepvTHgXaxn0
	 0lOGHlczXAY59ch/2fZBw3OBWwrKe9BMm2Bg0wpPSyJv0YValhgTedbv3DiKRNiu+7
	 DhmruK9l28zjYKbiQmoCZMC6K4tXw+YVuUUXms3rREaBTAfEA5IEp1VNSlM+2xhibJ
	 S2znC6naxkqHlf02+taUh1WnMD+1RAhTYT6CeWLqW7o9ijyASNv1FbCw15ZY88LqoV
	 kDeV5ZEoM7d4g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3D4FEEF52;
	Tue,  7 Apr 2026 14:55:45 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH RFC 0/2] mm, swap: fix swapin race that causes inaccurate
 memcg accounting
Date: Tue, 07 Apr 2026 22:55:41 +0800
Message-Id: <20260407-swap-memcg-fix-v1-0-a473ce2e5bb8@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEwNz3eLyxALd3NTc5HTdtMwKXcuUJIOk5GTjtERzMyWgpoKiVKAw2MB
 opSA3Z6VYiGBxaVJWanIJyCil2loA+uYQK3cAAAA=
X-Change-ID: 20260407-swap-memcg-fix-9db0bcc3fa76
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775573744; l=5405;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ktiFYUkm17rtWG9ixEvpBIbYQmlh9KYi2e+f5EL5XCo=;
 b=4buYa029bKRDja+FudcwHiadO4RPbc7haNQ9UhhSEB6duzxw3I44ZRV4k0i+0hQXiX0dnEc5j
 Gkfn3V+rOu8CBGklC4jLMUdhig4dBZdcjwMZoWpvGy1ZQEwwSOWBEM3
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Stat-Signature: 1y5qnqwijondmsx3iz1pn98qbow3ydfw
X-Rspamd-Queue-Id: 7789618000A
X-Rspam-User: 
X-HE-Tag: 1775573746-659524
X-HE-Meta: U2FsdGVkX19PifV978To2cVamlJo3bwG5MwrK4q5N+FzjJX+64e0fpnSAHnvllE6iAyxwqdg7MyjGZXkfzKw049PUAFGsHLTB1mnzXPJnkw0UGgqbJFbsdMXGiqYz0YSX4IK20gZaQOAPa7HVODUeKnc8D2/NEqdasIzdE2YG64fmngO08JmdkTm8AQM/Ss8BeW0DlkQkHPiP5qX5kMCmWU+RvGh9lZYmVUPZP5kMtG2zCwqLUkOgLQqAONo74vx2NGDoYw1DfNWEOH79m3rIFtQ4aYzfjMkDLpF0cDjdC+9hC1094HNzcZl1CXWOfY6vzccEfqc8g0sZ3Z9scb/T3xRD6hhRwVaGJvJI9VHJKBSaPrcHSJYI7Ekvd5MbY+xx/nQUFyCf+8+e4Gp8bzN94acQkKjdeE/afoRQp8sTUWJ7lOSqYT6exFd0Hh0cZhokmKXqD0DTLPCU5KD5kiWUrm1VQRIzQUDHbelZUrnm8XamEkAv4YJy+ptPJ5KEzryV0Mb3LYg53kDbPdPQx32grdbkwh35nWywJv1/8D3ntu2Q7qjOzNNAnYXEw933Rvs2fLZmR6BN0EIqaKdB04HPKEBU4o/+/YM9PwPoV6+1BYavlucN/ChccYZ6HaYlTdHPcIfLNsDnL2Z8Gol9ln7Utc7rz8XSGQ6q5Uh4kmItmtrfT8etTOJh/taJCC/Tf+ZM8BAHttZSkDOzpxv+S1E4fFffMBpyLaPScfBs7saWtHyzXA5voHmcwZWFq/51NZh087p4Elwt1Ml0nmhD6rAvAZ3emcOHQQulxQ+LH3B3SI7wpwM5LAHh2tbWiAfFRzpW9ZFtkF7yH9lUILVLyddwT4df5baxy3/8sVBRVq2JdYxTjOllrK4VYhRBGdfZfo2jjL5nW+yg8ep0ukmJjiLMjzQlmhUgqYUenwDUW1WpJvgTePBEwS/hzxj9B7bIhbgRmiFPYsdxs9y9Hu4AGX
 jVwfLnh+
 Oc3tEcr+k3TIPdn9LLiIJ4B2ZP759gNQIN/rs+7Zno9wJAejW9o4stYl1XA51o1e3IFkCdhkSnSRiK0oqQRXpeYB7ZW4OginRO+pfvm2JDHG1HahKiD0IFMC6Ck6zmqCRlNlmb6CPY3mg6UX+s3lit1Y/cmxGA0g3NAy4Wd8wQaD/Ng4RFHjIDbs838BHzw8QGsFnmR92Jl/olKTu37ylRzM16a8N2BtmTJFemt+nxzdvNmrEoFLNJZHP2aARKQjrY20Vd56mnTjRzOZJ6z9Rl+Qwk+frLtT8np/64rlhjBYy4l/J9ACvPpAgj3GPkAfTE9sakOecfhDxYvnyzh999Jo+2565tWHj/M7MymNVrSHDMuzdbAvoRz7jecfY/HppsUL6taXfLPmrMYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While doing code inspection, I noticed there is a long-existing issue
THP swapin may got charged into the wrong memcg since commit
242d12c981745 ("mm: support large folios swap-in for sync io devices").
And a recent fix made it a bit worse.

The error seem not serious. The worst that could happen is slightly
inaccurate memcg accounting as the charge will go to an unexpected but
somehow still relevant memcg. The chance is seems extremely low.
This issue will be fixed (and found during the rebase of) swap table P4
but may worth a separate fix. Sending as RFC first in case I'm missing
anything, or I'm overlooking the result, or overthinking about it.

And recent commit 9acbe135588e ("mm/swap: fix swap cache memcg
accounting") extended this issue for ordinary swap too (see patch 1 in
this series). The chance is still extremely low and doesn't seem to have
a significant negative result.

The problem occurs when swapin tries to allocate and charge a swapin
folio without holding any lock or pinning the swap slot first. It's
possible that the page table or mapping may change. Another thread may
swap in and free these memory, the swap slots are also freed. Then if
another mem cgroup faulted these memory again, thing get messy.

Usually, this is still fine since the user of the charged folio -
swapin, anon or shmem, will double check if the page table or mapping
is still the same and abort if not. But the PTE or mapping entry could
got swapped out again using the same swap entry. Now the page table or
mapping does look the same. But the swapout is done after the resource
is owned by another cgroup (e.g. by MADV & realloc), then, back to the
initial caller the start the swapin and charged the folio, it can keep
using the old charged folio, which means we chaged into a wrong cgroup.

The problem is similar to what we fixed with commit 13ddaf26be324
("mm/swap: fix race when skipping swapcache"). There is no data
corruption since IO is guarded by swap cache or the old HAS_CACHE
bit in commit 242d12c981745 ("mm: support large folios swap-in for sync
io devices").

The chance should be extremely low, it requires multiple cgroups to hit
a set of rare time windows in a row together, so far I haven't found a
good way to reproduce it, but in theory it is possible, and at least
looks risky:

CPU0 (memcg0 runnig)                | CPU1 (also memcg0 running)
                                    |
do_swap_page() of entry X           |
<direct swapin path>                |
<alloc folio A, charge into memcg0> |
... interrupted ...                 |
                                    | do_swap_page() of same entry X
                                    | <finish swapin>
                                    | set_pte_at() - a folio installed
                                    | <frees the folio with MADV_FREE>
                                    | <migrate to another *memcg1*>
                                    | <fault and install another folio>
                                    |   the folio belong to *memcg 1*
                                    | <swapout the using same entry X>
... continue ...                    |   now entry X belongs to *memcg 1*
pte_same() <- Check pass, PTE seems |
              unchanged, but now    |
              belong to memcg1.     |
set_pte_at() <- folio A installed,  |
                memcg0 is charged.  |

The folio got charged to memcg0, but it really should be charged to
memcg1 as the PTE / folio is owned by memcg1 before the last swapout.
Fortunately there is no leak, swap accounting will still be uncharging
memcg1. memcg0 is not completely irrelevant as it's true that it is now
memcg1 faulting this folio. Shmem may have similar issue.

Patch 1 fixes this issue for order 0 / non-SYNCHRONOUS_IO swapin, Patch
2 fixes this issue for SYNCHRONOUS_IO swapin.

If we consider this problem trivial, I suggest we fix it for order 0
swapin first since that's a more common and recent issue since a recent
commit.

SYNCHRONOUS_IO fix seems also good, but it changes the current fallback
logic. Instead of fallback to next order it will fallback to order 0
directly. That should be fine though. This issue can be fixed / cleaned
up in a better way with swap table P4 as demostrated previously by
allocating the folio in swap cache directly with proper fallback and a
more compat loop for error handling:

https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-4-104795d19815@tencent.com/

Having this series merged first should also be fine. In theory, this
series may also reduce memcg thrashing of large folios since duplicated
charging is avoided for raced swapin.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (2):
      mm, swap: fix potential race of charging into the wrong memcg
      mm, swap: fix race of charging into the wrong memcg for THP

 mm/memcontrol.c |  3 +--
 mm/memory.c     | 53 ++++++++++++++++++++-------------------------
 mm/shmem.c      | 15 ++++---------
 mm/swap.h       |  5 +++--
 mm/swap_state.c | 66 +++++++++++++++++++++++++++++++++++++++++----------------
 5 files changed, 79 insertions(+), 63 deletions(-)
---
base-commit: 96881c429af113d53414341d0609c47f3a0017c6
change-id: 20260407-swap-memcg-fix-9db0bcc3fa76

Best regards,
--  
Kairui Song <kasong@tencent.com>



