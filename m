Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5A5CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614E38E0011; Mon,  6 Oct 2025 09:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59EB48E0002; Mon,  6 Oct 2025 09:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DAE68E0011; Mon,  6 Oct 2025 09:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA8E8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:25:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9F34BA347
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:25:33 +0000 (UTC)
X-FDA: 83967761346.18.CA1FEE5
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F2C740005
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:25:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kcncp2vt;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759757132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rN5PCrh7w5JveL97Y+GSyC7b8859L6HqEd7z3OmyMK8=;
	b=Rp2d9nKkB+H/ewO6oKObyhJ8m35Q003FfEWOf3rJLGb3MbvfT7oDKib1CXB/mWacuNPirV
	WY9w6qOp5QBOikuc88SbGlVKjJCMjO9fwOdkYyQFqrg2NrlrMQiHad0YvcIf+i0MhQNPwR
	0SEZrsZQbFISQ2Th+4Ht4Mi2H9GhRmg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kcncp2vt;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759757132; a=rsa-sha256;
	cv=none;
	b=CDqra5sLGHhFGmZ+qcHpibbygW67gsmp0H9ntL3OYMhdMMkDW6rnnUtqki3q63KOze1vmH
	Hf0wJMqXfnD1thPbRO4d1sOvcYo5UWExG/kuyQPnCp+IOshe6nYKjicuKv5yo1G/lYy6x5
	wow42NNZLG76aKJMo7uacPgju/A2bKE=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id DDDB192F0A;
	Mon, 06 Oct 2025 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1759757131;
	bh=rN5PCrh7w5JveL97Y+GSyC7b8859L6HqEd7z3OmyMK8=;
	h=Date:From:To:Cc:Subject;
	b=kcncp2vtH8IDwM8TCGkT2vXT5kgQCTkoz2DnDLQBil1IB9AhHY5KN8DXNv0X39cG3
	 TWRy1et5J7ePsr0WFR1pmQquvpXVLmxv4ROOOzHgCTXO890uD9E+hgqgqrXQss5qbn
	 079Sp4zBN0ZASjaJMdV4UwCeJwyBiXW7ZiUUXeXU=
Date: Mon, 6 Oct 2025 13:25:26 +0000
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
Subject: [PATCH v2] mm: skip folio_activate() for mlocked folios
Message-ID: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F2C740005
X-Stat-Signature: skksgxp88ewctsu45xn6p8y7kx7t8uqw
X-Rspam-User: 
X-HE-Tag: 1759757132-383766
X-HE-Meta: U2FsdGVkX18O4IlJRtPP0hJWqBWFuq7h8W2ejP9ptSGsyvxZOqeIq0SfvdIaK2IN/9iPNeWfzslPRrToRC/Kwp+QNP1efVtM+pr4+g/veaJrxY34X+YlX68jz82yg/m5di0don2Z3/rOsU7QQlxt1F3OpNNSn1NfSfXYlrcA0sF+t5zipNOVXiNyYefq1qd/UiEJBXVCOX+nORdGl+anJ9kl1l9u+SGuNT4LyILD4CNEUIIDmmO70F9G8f/z4TxnBErHXW4E+2RW/Xa0Vr9GooY4LABkYFuviv7d+se1KX35S7zFnSXdwyeYBSRtUTIBZFJtPcjTvDbuRocGN9ffvCFhOZ64ENGTat0sIKOh95adgXbZEIWH+MlsLpWNU6+8Zvno5VnaBRxPyBX/Ts/yhQYXPCcD5GtOe7f7cne18l3/NYqchnvveZ4i4gwyYV/Bt6vKgzF/04GGF6Nfz/XY7M7VrCLWSiIqSKe+kgMnJguFtF9XEftRpqbFylPVl1TS/WwIwG7crQ/zLgob+3nrQjQ6MQokvTRcy8c+A7hCWjKten4I9n2YzuitziL63jL0XytJjWLn70whNjSwgNQU5/ExCCjvANRbx05Kga/YZZ9P7+nfnlI8WBsKgglMZI6rQnGg2V7UvhCl0ZlyqLcNWwxn0uuCCyI4bw9+AC+2nQBN2VPkTID1L/2UtQzFKmJQxRox+/irBshuJgCn/l4Huj55eMLV4kqIlEiX8axj/6UmfqYxKOQkrGHGaxt8+V6RcT2l2Sax/dKN6eEhjRhxdQ+lSdeA21wWObHGXtvc3myAzSrU1Eyi8GLE5V8KkSRirCJPVYJ+bWE7tdxbw26R3O+I3UnHI1y9OA3C4EsRNpxpwOhL034EhGgNNnv2GvD77ntrnvjv3lzDz71lNG+QVf23uYb/fWF1PTTHROFJf9aFe0Pv0aS5L0Ks7vX0i1uKDqAf4NlcY6v4AjaxYRg
 /P3VC17Q
 E5khMIYBY49Ep1yquMM/ber/J8IciaWQBPRqnFn/6L3BUb7QPzmWdyrIDwJSlA49NGpToWYg0cGWDWveD18DX3U+IJd6fMTTMNyqFB5dmo8lrDM57kG23l00lNye2WKPA1/1ODj4hm4sMPtFYSTZ0cZ6H5t8qLgjLlci6KC3ONa5Lw+MN+pJlXIen5cLNeV+UGSmmhA+sE7Y5a1BVHm3p+0sSp3b+Ygadl03q/6fwD1SSnsQpLLHEeBM+C/WuGHv2Na3Ay1ANgZj0y+VYlVcE3rVdhyMfGQ9T0aVgvT+/33iipEV3EysiF+3PiLLgwfSnWeUaqaw74UHNsBD2ZiWdhHxDgkY2hcwCRxIzkL3heVskGBPnk83dfaIb6Ez4n7UzYyn3Hl2iw9pyNuUF/ng6fhMuo8N7WuDllXwH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__mlock_folio() does not move folio to unevicable LRU, when
folio_activate() removes folio from LRU.

To prevent this case also check for folio_test_mlocked() in
folio_mark_accessed(). If folio is not yet marked as unevictable, but
already marked as mlocked, then skip folio_activate() call to allow
__mlock_folio() to make all necessary updates. It should be safe to skip
folio_activate() here, because mlocked folio should end up in
unevictable LRU eventually anyway.

To observe the problem mmap() and mlock() big file and check Unevictable
and Mlocked values from /proc/meminfo. On freshly booted system without
any other mlocked memory we expect them to match or be quite close.

See below for more detailed reproduction steps. Source code of stat.c is
available at [1].

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
Acked-by: Usama Arif <usamaarif642@gmail.com>
---
Changes in v2:
  - Rephrase commit message: frame it in terms of unevicable LRU, not stat
    accounting.

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


