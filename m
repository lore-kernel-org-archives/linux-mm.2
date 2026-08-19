Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434EBC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FE626B00A0; Wed, 19 Aug 2026 19:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8BC6B00A1; Wed, 19 Aug 2026 19:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC156B00A2; Wed, 19 Aug 2026 19:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE156B00A0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D652DA04BF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:20 +0000 (UTC)
X-FDA: 85119564600.01.4234B24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 277A540006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6JWGD+W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivPc/dtcW/97whhIcc40lJlLMO/RUpWFUvsYkOmQdfY=;
	b=1B+Ihi6y3wcXg8Y8yWNMFD7u+ghdwHQR2hYa9vjt/mRaUO/2d3xexiEoZV0Sz4CMGX0xLB
	Ibd43apeCm3+togYFUXcCWMCUGhr1AsYXtDX0B78cNroVHRs1GSTs3OcgsV1IgP/oD1aKX
	YNToSwfbClb/0ZDlHaFtgBvR8kLqlzQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6JWGD+W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181019;
	b=rxhLfbbXgwPi320a9xjBed3J00eQoEVlErHkepJlwmuFfVfnXyZOR8Ha9gV1RJWd5TCeA1
	n7iAv5F1u3DtsLKH815cpZmwKsd9QQoIreKgYGkJmfw242vL1621VS8BmJtfnd6bihLXDI
	7j6s082+vSuEqh1B2tE04LVt5ukjpHM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BDA26187F;
	Wed, 19 Aug 2026 23:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEF71F000E9;
	Wed, 19 Aug 2026 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181018;
	bh=ivPc/dtcW/97whhIcc40lJlLMO/RUpWFUvsYkOmQdfY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K6JWGD+W555VcCnv/WfeQSB+QTrQbSBqmZ9f3ug7SqSUGzYbWr0dw66iiH8N56xB3
	 FVhtRLxW6JDZUa3YuUwlb9kGKhtvLUcxhU6d7R9+RD83f0WYxXybttNB3adLAvDfZx
	 cdl2qR5wwhP6/IQem4P/DhDavLdhnZfGQvoIXBDmhn2ucjkKPL8lVuji0h2Glg3S09
	 e/bA11p7IMAFLWhywPR4+fGjqwsZYLmbvb+kfG54EEBI9/GulE6lkFCq3hklGMCDgS
	 qrrz5HvMZLX0fyPeIhW1dc8zjIDKv+nb124YfIlTOyLZwA7auRxlmzONjbyM/Dkjwz
	 1ySXTCfRaRz8Q==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:21 +0200
Subject: [PATCH v2 04/22] selftests/coredump: discard the right amount
 after the coredump request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-4-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2069; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dsu3ug1yJTi0SPZbLicDCFNStcMxXGAWYCl1/1v264s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me+7pRe3+NMWjXSGn5lHmO/EKd9Leiq2r49pmuC9Z
 ynJFa9fdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkViYjw76XK//37H+/YW/U
 tHo7Lyn1ta89ou43Hp/Le/qinD/j4lhGhn9iWpqvbRasebPDKSth9Szdm0/0Mzj/7pdY5XOlfc4
 LHTYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 277A540006
X-Stat-Signature: n1uf1ix5ic7nrf4584try4hqg51oxkhe
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787181018-682984
X-HE-Meta: U2FsdGVkX18tIel/kwYWXQCL4P0Ulok2A0ZowbkJ7YF3/8PmGgLz7YHqKnU7OLG+PUjKbDYSVI19E8EbNjEB7aQMkiYVYOfP3VqUdQHwHUF68ki8/FrHILezRTBWu6mhaL4Me4URKWFPJ5yxCBHxlLf46rHspeiDp8sqp16GovEFD1mFsJRRgC5jMIzfXWCiDpBSrT6nKz2efwpqB6ftUNcMB5s0fMy9YijQeF6ogo21E9peBGuumFaoPHJyREhslz91pob4FuVRPC2+q22r8kbc1yiaJepTxwTMRdhlZ1Vy8bOwJugAGjWqbCgApUGbNQfQ1+WQFImg8pFjijdZV9qgknCbF6UavUNjyWACwbJhnEXDg2+WYchLgfQ+D7P/29/4DpqwTARCAsIA62JbJOEP0bpKuot/ex/dXDJ6AC03QrSSf/sZ5NsvUpS3jEmGdJQ0RZOHaOxvnEXiL1+3/0SRXDichHVhfW1diLN31hq9NkbafnQN/ElwTt0wpHFDwQAtgI7wLTvdBYzqNEB3CWLKVRWowZWOXMWC63kIZhnDqijoXV54Ajc3osL//EjnKBfkvgbl6pHKMnFu6URAX81T1mQVCe5xC3LUyhpnrKVQvLYpDmsy5XxJkoH0b9tzkv5rgWh1W4zc3t6ffTFDW/kajU6r1+7Fck4NvGeW017j7jhXeXGu441XhopkldOmFRTdtn0DnkKguHNgyxooUbg781G6t0TXQBlHO3VfqZhjZvbOnStxV3ah9B7VqDUEVUx7qT+ObXVFqELevhQN6IY3QkmCepLYl20HFHQNUVwjEKH4V+TJHCj2j2FakuD8OtGj4UTHH2qI/NQvFHS8i/o90iRTjTUvtVC0F1YnwU2adZ7RdbV4cATluCL+lhdarWMFZlFA5Ou3LklsYiUl7gykSqm6vc4W1+8/KsvWYozAWBrWhSOvXChMQ9Ji2gVRVI4/FpXoIvMrnX1wmwc
 /031HC4W
 ePrQjbhD57vv0IcJ5UQPexMc2VHEKbISQgY+afx7OwtSwDDbRvpXb6tUu9WrwHcYq57ZX4Oxn/pxRGNTfQZac/aXrSl/DyFUcSBcC2Hq1AWf/gsK+bxM9iIdsHi12ALKqn/+GQqODsmX9atc/3l721BaI2gwFPimZMGZXIg/RBaKmfkhCeLGFdQcgo0Nth5i8DTcUDbVw2Zoz2YyZMakUMSGEK1KGH8fD0EjUCawfvPQ9PBVHkSQAOGZLQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

read_coredump_req() gets the leftover wrong twice.

It takes the absolute difference of the two sizes, so a test binary that
knows a larger struct coredump_req than the kernel sends tries to discard
bytes that were never sent. And it hands recv() sizeof(buffer) instead of
the number of bytes it wants. So MSG_WAITALL waits for a whole page.
Either one blocks until the kernel closes the socket. Which it won't
because it is waiting for the coredump ack...

It's benign today because struct coredump_req hasn't grown. But let's fix
it for the future. Compute the leftover as what the kernel sent beyond
what was consumed.

Fixes: 59cd658eaf40 ("selftests/coredump: add coredump server selftests")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/coredump/coredump_test_helpers.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 2a20faf9cb0a..524fa5370593 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -235,10 +235,10 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	fprintf(stderr, "Read coredump request with size %u and mask 0x%llx\n",
 		req->size, (unsigned long long)req->mask);
 
-	if (user_size > kernel_size)
-		remaining_size = user_size - kernel_size;
-	else
+	if (kernel_size > user_size)
 		remaining_size = kernel_size - user_size;
+	else
+		remaining_size = 0;
 
 	if (PAGE_SIZE <= remaining_size)
 		return false;
@@ -250,7 +250,7 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	if (remaining_size) {
 		char buffer[PAGE_SIZE];
 
-		ret = recv(fd, buffer, sizeof(buffer), MSG_WAITALL);
+		ret = recv(fd, buffer, remaining_size, MSG_WAITALL);
 		if (ret != remaining_size)
 			return false;
 		fprintf(stderr, "Discarded %zu bytes of data after coredump request\n", remaining_size);

-- 
2.53.0


