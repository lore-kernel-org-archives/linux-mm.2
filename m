Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B7DCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 14:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3B68E0007; Fri,  3 Oct 2025 10:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBAFC8E0006; Fri,  3 Oct 2025 10:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7FF8E0007; Fri,  3 Oct 2025 10:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDE28E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:20:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35FF387EC0
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:20:04 +0000 (UTC)
X-FDA: 83957012328.02.75CA3B7
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf30.hostedemail.com (Postfix) with ESMTP id A537380018
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:20:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="h/MOC4mU";
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759501202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3EHrOqxHMA/OJP3NNhvuJX0wv/GyYjMAhMppOzWpnfE=;
	b=gsbSX5fXJgUr8I0kMEmO46CKyjAbgzVGUKqnBqEYJ7RHLacuPumlsnEQxDaLfik0GCayOI
	5lUaMMmdi5SjpBuGU6tzZLZzwf5W+H8p0mndESLiAROG99j8CJVPq6Cj9fwDnIZsDEqS/C
	7Dmpx4cl6FdgXkDaOoudhX37Kj5Bb+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759501203; a=rsa-sha256;
	cv=none;
	b=5A88vTzs+cYBsD7NrAhDir+OxYYsPP+55Y8WggLWzzmEnEbBSHvkxkDTTkrIuUho1MGxLr
	EvxPJG6FfIDnHhrFKpPz4L/xzuQzobS3DMyWL4hCb2+LW6KA4MYt4f5+PRtWRIp/A3976P
	pmsfbbUuDrmiF028ZiWHwGyaqd9PSBs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="h/MOC4mU";
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E77E292E10;
	Fri, 03 Oct 2025 14:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1759501201;
	bh=3EHrOqxHMA/OJP3NNhvuJX0wv/GyYjMAhMppOzWpnfE=;
	h=Date:From:To:Cc:Subject;
	b=h/MOC4mU/LBiGmYndVUUIEI6qUURQx4JD6oTAeRqHmV60pbBj3RWyTPNsiGjpUeud
	 AjJRjynWyAjupScJG+Zfc3wDDPNc0VfBeXH5MJF1XUIbZp5j/JNCmI7GY0ohpeSZgI
	 7bnIgtb4+1xoMmm/a5b51seuc3m94HjC+jsvbCyY=
Date: Fri, 3 Oct 2025 14:19:55 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm: skip folio_activate() for mlocked folios
Message-ID: <aN_bix3wDpwYPoVp@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: kisb8gqpu4sezw9kwa7hwfysnfo984zg
X-Rspamd-Queue-Id: A537380018
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759501202-799370
X-HE-Meta: U2FsdGVkX1+8htThrt5gHhKo4wyo3pQhG+Izejh+B5Y6f9fVSCgFRL4oTDF3bEo9/AQFiD5Cp4STB/Ws9PPWWo1m4LYTrBOLSiN8d62bSQpxedqLsbGdLbVqgeI+gEfkIAFKgn8IRrD/y8Tk88RgQI+laGqzrIZ2GuxiI8AcQMaH0KaYwMKKfX5gssDO3nyZRvYoROv9A3OTN6xx5/R83f52JUbxrF6mUGJ+qGHc5k7GqxUlNLhOHp705pkxOz/4C+WlAyLkh2KdEWPsEuBEAzPpbTB1PRQs9cU9RPMPysgd6XGz8QVQZM1i30wpBO5+4oniQ3QQUgaAV7kN4B++7sIe6rkySNXPC2SR0dzGwQppG7WbSxnbYqq493SgIt5vdT43kbyoqGAQdMNalwtFlZ3SCUO6FswZpmzcn3CAR5QaWHNaBqlOb06u1CIRgLct0v9jLJKQL+9GJwlgWozXM0TbLfhbpFDxaWh24Bu+GFOqqTemPgDMXRv9xzuUzfNJn3kakz1ItCJLnwo8f7yLuPHHF2eOKuN3wktX2/JdQsGMwFg1rWCUQeCpTS4ASmt49+EEMKf8fZ4zfwqcotjrwzm2LfHBuRf1O9KjCdla/9romtnsekykAoUZBkZWuMULLFkXMYVM6yKOGKAqJ9N6fTD4pvw+rOrUE90QSRvin9PmTQj9vlwOKdJyxd6isH2ItTG/jb1iIfyuMMOT98EwxvY9/qTO/iygm0RxS9tg8uHnAeiwv4eq4xk2tHXH6UjLY7eGWKJWeHs5JK0hGKqFTvVwvcdVDKlpyML2HsNCJttK/NMoujFHqy+FbDCmAOJdmb0I3TeTmb01XTDtJob9QnQoQcchCCW7hdSu4DHpJaGGl+M+UBPi5oDOxsMWiD8klDN+UTN0OJaStDdWI2O0e8KOCkICpRjDNonBk/hP4CiUV9C7OhP4T6zBkmJw3du0oC9souTCx7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__mlock_folio() should update stats, when lruvec_add_folio() is called,
but if folio_test_clear_lru() check failed, then __mlock_folio() gives
up early. From the other hand, folio_mark_accessed() calls
folio_activate() which also calls folio_test_clear_lru() down the line.
When folio_activate() successfully removed folio from LRU,
__mlock_folio() will not update any stats, which will lead to inaccurate
values in /proc/meminfo as well as cgroup memory.stat.

To prevent this case from happening also check for folio_test_mlocked()
in folio_mark_accessed(). If folio is not yet marked as unevictable, but
already marked as mlocked, then skip folio_activate() call to allow
__mlock_folio() to make all necessary updates.

To observe the problem mmap() and mlock() big file and check Unevictable
and Mlocked values from /proc/meminfo. On freshly booted system without
any other mlocked memory we expect them to match or be quite close.

See below for more detailed reproduction steps. Source code of stat.c
is available at [1].

  $ head -c 8G < /dev/urandom > /tmp/random.bin

  $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
  $ /tmp/stat
  Unevictable:     8389668 kB
  Mlocked:         8389700 kB

  Need to run binary twice. Problem does not reproduce on the first run,
  but always reproduces on the second run.

  $ /tmp/stat
  Unevictable:     5374676 kB
  Mlocked:         8389332 kB

[1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd

Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/swap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/swap.c b/mm/swap.c
index 2260dcd2775e..f682f070160b 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *folio)
 		 * this list is never rotated or maintained, so marking an
 		 * unevictable page accessed has no effect.
 		 */
+	} else if (folio_test_mlocked(folio)) {
+		/*
+		 * Pages that are mlocked, but not yet on unevictable LRU.
+		 * They might be still in mlock_fbatch waiting to be processed
+		 * and activating it here might interfere with
+		 * mlock_folio_batch(). __mlock_folio() will fail
+		 * folio_test_clear_lru() check and give up. It happens because
+		 * __folio_batch_add_and_move() clears LRU flag, when adding
+		 * folio to activate batch.
+		 */
 	} else if (!folio_test_active(folio)) {
 		/*
 		 * If the folio is on the LRU, queue it for activation via
-- 
2.47.3


