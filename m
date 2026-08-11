Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA14C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537886B00A2; Tue, 11 Aug 2026 11:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F9D6B00A3; Tue, 11 Aug 2026 11:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424EA6B00A4; Tue, 11 Aug 2026 11:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4476B00A2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:28:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA0FA1604E0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:59 +0000 (UTC)
X-FDA: 85089369078.22.B051C8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E8F974000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jePYbKst;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wC90oFJa7Ier1ZIhf5weT54crOnc3p7uwLYcRogSj00=;
	b=L1pyxFm+8eXdQCtj/dMp0oQs+oMqwlm2isGFs4nlUpq5otUkMV88SOVrnUvV4pKQhKDptI
	uaJalKv41eopQLueLLd6MsP65vyZLfww4YaOte2pMN8Lqe96o+8AQPgETdL87clHBtG0RK
	O5WI0OPRUTGmM1OlhnPSkzDOS5UcHMs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jePYbKst;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462078;
	b=47yZy3YyGCAcwXQMEQr2h2p9CaGA3Jy0cZu47yMKOfA1V9wqT4hUdYkvZjb7Hdqmof5Cf8
	qV3MngkiDw5FkjNwVlTc7Gbh83BTr+QHHVapHcfjNNDuHBSjQio/uhKQrE6yNyjqn3zUjm
	Qw7DGxTB7VElB+YTiL6M8YdJJPd/tHg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D38C4050A;
	Tue, 11 Aug 2026 15:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01F91F00A3D;
	Tue, 11 Aug 2026 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462077;
	bh=wC90oFJa7Ier1ZIhf5weT54crOnc3p7uwLYcRogSj00=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jePYbKstnrnoDIjieNdlMvUl5SIrd0wrHkgAuTO3eaOIgdr7AFT4TKPO1sJIRxYin
	 TdSEGeMgruFr2uzZMrInAsZf9k89iH3drJCAnciUoAlKTFyGGyjkAzdy2dwvkfEylg
	 34xPZP/lsSRvTh3SgDH0B9nNEkYVkGN/3/iKEwC8WvX+4pFlLO7uZvaMwDaM8CYFZH
	 AtUdwbBKc4Y/5PRUTymt9mEOZpL8nl40HMdflIIq9AufEZ9p4YW0q09j0ETb+aMMca
	 aPYNbi3Y+rslqxcoKgcukBCTvhREbcu+IMUvI0wi0yI8JLhRjo2Ipexv6cRSgB/HkD
	 89Kz7qrNZtclw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:26 +0200
Subject: [PATCH 05/11] coredump: deduplicate the to_skip flush
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-5-cd3e8b1e356d@kernel.org>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1458; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eVMaTke3Zp4rPM/gpT2jPr6BY6R4nqbkomTRcFn86hM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2yecezmdOV++aOm/PzzVsc3bOO+z3+3x2j/NxrDwm
 52aZODMjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlk5jEybFbY9nK5xe7db/95
 HLnn+nh+v9jxeXf8VBRd7oTk/hJ2ZGRkOPP64DMLb48I+4n3d7LprE+21v4swH47QGiPXfgLIYY
 GHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8F974000E
X-Stat-Signature: jbam4566kxja1y8awhoaxrbrubtzjtr4
X-HE-Tag: 1786462077-293712
X-HE-Meta: U2FsdGVkX18GtSw37dAv8CWlSV4QF3uPQsjicB1Mxdf0Cew5VXwxnR3HYKqyIW2LGi/PoFCew06lSQswbY7+g7UM/7vHgGyjX4EUg/40djfGQuxzNY0mvvmRHRxQznRDE90+gl35jIYyZMB1CS6e52VmsJDX5e9IKLg11caFEnFMXbJWnb1NFe3u4O9kxiP6m3zbPcJcmqn7ND3Caece1YmtFKS0gwUxnmoKPImpe1ukGzMp5mXjZ6r9jTUPl9tL/OGqJlKkdinjo0dP5wEr/2VPcj1wasG3dmvWeypobDlEKMazRSwVtbqJOAdWVpLWrCiqFD9WdkeA8UZYURupHpzZiwz7LN45wTJSix+Ddpew4toz8gJNsITv+JAjc4uZ5nTQ6mByVt5hRp72qX7aV/Y63/le2AI5nWeiGXMP9diRZ0mJNfSUiomcZmD/Cfmm6NvXU5Z18D6hiSwYc04PMGvkR+SVQPuhEhUEia8RBcRX4cAkvAtw7eu3sJ/X7e0t5h+38y9gaVHmsKeYynZMFoBwKmCIfd2DU4EgSHsoUbA87PdO8FZEzzoBbxWzZqhV0puzG4bUuwlxW5deWJLZ7LOJSv7dU1U8i4pjmoFfV1zdMeqyQnUQsTPEtGn6hkaP5e84AElD5v/RterwMIQqRXq7k60DfqJsWz7kBQxFwaDHzHrxc2gWhQVdzmVDh5DpJUCzZdb2UkI0ihruW/OMqWS8D9Z8nlT3g6ZH8iY1uwV02TiVSc790koFSThI8VHdH6ytBAtWUVaC+A1e02HMNUyVGUHJBVahv36T6p0UoL5ibbkH91k7o1wNfOH9MRwwZT0BXQqFZVmKIJ4GE5VqSab8Nz2aKwwdbTjOjzQdREGJ+kibqpkQzBUK0W6g/8eNR3pvGv0PRF1gMUNdPTj3tQngyD8+8WAf9GU0wv3ulY4cuFITKvwnkt3Ajs7W55dbg+JLs1tCp6aHy/ywtFU
 +nVjsMU4
 fOe7goOEyiQIJUg9DGwlRw5RBtS97tJCzrJHER/mEwkS4uwLwG2Rvo7kKZZny53xZTFQZOdSlsxzIfCIVWFwKVRMRjtmeAee0XCilg2KqzAuLSdZq+7JX5mXrkrr4GaGW5nOtjq1pw1yk5J+JWLEWrcI/1KfusnfkScUS8YHAR8mI9Xpy7FpD2J1ebAljMEgf3LN/RMDDSPvd5ULsKS6QuAftBmQ/KXcm2TfV0GBIRDRIaOrMiub47oX8xx8caxh8S4ace9r/wzF9AAXYipAg3PXgsQRIVbtcUkqR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dump_emit() and dump_emit_page() open-code the same flush of the
accumulated cprm->to_skip. Move it into a helper.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index e5463e3b3f4b..6de18bc49925 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1249,13 +1249,21 @@ static int __dump_skip(struct coredump_params *cprm, size_t nr)
 	return __dump_emit(cprm, zeroes, nr);
 }
 
-int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+/* Flush the accumulated hole before writing data. */
+static int dump_flush(struct coredump_params *cprm)
 {
 	if (cprm->to_skip) {
 		if (!__dump_skip(cprm, cprm->to_skip))
 			return 0;
 		cprm->to_skip = 0;
 	}
+	return 1;
+}
+
+int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+{
+	if (!dump_flush(cprm))
+		return 0;
 	return __dump_emit(cprm, addr, nr);
 }
 EXPORT_SYMBOL(dump_emit);
@@ -1284,11 +1292,8 @@ static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 	if (!page)
 		return 0;
 
-	if (cprm->to_skip) {
-		if (!__dump_skip(cprm, cprm->to_skip))
-			return 0;
-		cprm->to_skip = 0;
-	}
+	if (!dump_flush(cprm))
+		return 0;
 	if (cprm->written + PAGE_SIZE > cprm->limit)
 		return 0;
 	if (dump_interrupted())

-- 
2.53.0


