Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1170606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JIdg0hQl
Received: by kanga.kvack.org (Postfix)
	id 15FCF6B05D2; Thu, 29 Oct 2026 14:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111186B05D4; Thu, 29 Oct 2026 14:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026346B05D6; Thu, 29 Oct 2026 14:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0E856B05D2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:32:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39EBD1A04EC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:32:51 +0000 (UTC)
X-FDA: 85376510142.19.AD1D6A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1ED981C0010
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:32:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIdg0hQl;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793298769;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTW5L2TMn8pd/2NUrVoQf+CiJ7CtM3uYVCZgZ5kfQPM=;
	b=W5ZOPd/bo965Mxj6pHpRXbpY9t3+zS/IBX9ncUk3F/ojy0sEzhWnjG7HWOJCbB4rrO1sl6
	ORTt9PeOgrdH5Tcts8jFtplr39hpxJk3jO7M7LuUg900Eva7oqHNs/R5aRLPriEA3mY4rO
	smaw4s/7LTG2fJFKOIQPXFOq5TEeRMU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIdg0hQl;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793298769;
	b=T0UHCFJhRcOcDz+ADeK8gxir60TEzVn3KYrpA6Pxplc5ptx2a6KFK75APpjfCtg+SWuozU
	86wlBOZtKDCBqvx0KDu12X8781DpyJ9KFgUEAHIy2CquuM1k2Gk3GDreYX/RWWZffMNnNx
	5CikxqEBFjsrN3cfhHDBmqNPxd0QZl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87FF2600C8;
	Thu, 29 Oct 2026 18:32:48 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793298768;
	b=VCS+WX98sWbLDXjnowB3xwvbvg7BTJ2AYKGx7EJyfMuM3+Zq2HDAfVc8TmU6KCQ/TnQB
	 nqvuvExkfBUbW+sOh8gquC3asgid8w8ohzWzrzcVjYgpO2P5sDw0mz8K+5dZAfHfZhtl2
	 AuwzqNUtNTrtqwrNNn9t5pPINAe7+rtz52hXM8pREi/pQMQITUZPBVrEcw261F/2dIBS0
	 SBUJR6YkNM+Q29NGRddMlhjRmVAWe3wTa8jYRwSLW74zQUCjArgfqQpReWzQjmPL9YjNN
	 5Yxq4Lb1W4el4OYOby17CL2WAt7zWiauhU4epGZbY8OC6+hhzZa1v0fepZecpyED5tA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793298768;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=fTW5L2TMn8pd/2NUrVoQf+CiJ7CtM3uYVCZgZ5kfQPM=;
	b=zY5n2EvZ5AGk6TXqrBfYAqHlZkwWR2s3QfR2rqo4k60Ea0LM4PjAToQNI+2wkuUKG9Fb
	 F+7LksaFUi+GqgLhAJrA9rj+rUwXD72AwgpPFg4PYfV7ptaA3kiEkRe0xejyG8O3Kl279
	 1hHul4Gc/Ets1agFHgn0Iuqd1udCwcAnzZbb7YTllLVF/pPZ2aawL/JsaKuvqxaOgJ66L
	 QIJUOOeriEWhqZ+Z/z3Fh/wLTUJYh0tbMSvpjRWB9YBRs6WUZkBL9Az1tR1z4vaPfgWtt
	 axyETSbgbNirr410rcahd3LOl4GQwRSaijth7dfb+4cEYPtjXzSdkyxuhZleZjsWnmQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A18E61F01825;
	Thu, 29 Oct 2026 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793298768;
	bh=fTW5L2TMn8pd/2NUrVoQf+CiJ7CtM3uYVCZgZ5kfQPM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=JIdg0hQlOG9cDOLPeuvIUE4lGI2HJmiiwe9ThDjzRREsD+XV58FFKUvamsAM6A61e
	 vEce/IzKBgrIiUXLxdgAAsIoxUkwVUPhmCNvaWQ53l+6aaWc6/9mMStV9+LmK5rKs5
	 ru6y5FCyl2bbRZg0jZY7l8iiIJeAaXBrJ6sQ0QTzAok9TjSkVqL4LdwsgBfbrlyW9Z
	 nRnBE4fAFts4i4dwU3OhT/gTAHalQb+mtH7+gsvLG5RsBFYpedEQ0xICKzzsqzWq4+
	 Dyw1yfjAMn/vz1S6tpXSOEvv0zyEhIerBDPlWKBdTUCBoQNJoz9sxxJTmFJrzGdQGd
	 eFJuq4PgfQvLg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1A4274595C;
	Thu, 29 Oct 2026 18:32:47 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 30 Oct 2026 02:31:42 +0800
Subject: [PATCH 2/3] mm/swap: account synchronous swap reads as memory
 stall
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com>
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
In-Reply-To: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793298765; l=2231;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ETwDBqVe4SkLyOogHeVFo/cI0MLTr36Is6NOTSa3Wuc=;
 b=14e1RWmqqdS/oQ2hw2zRrMhcmuGgjIHInGUQZIpDIR/X+sjKFVpIO6DQLFbuQBcvUDrWFqXSW
 8OcAisTUl37AxasJwEbugtMClEcwe9Gl2by7v6I+nasCvAb37CiLrlT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1ED981C0010
X-Stat-Signature: u4e5onwcbrt3timzgian5tmt8ri77q4t
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793298768-195802
X-HE-Meta: U2FsdGVkX18ud1AgJxNkaMHlKcfgjH8Jp+3jvKKa53P//M3N4yjKcR71TCplwPf6CcS0QfsLNNB6HMYopzqlAcm2s00d3R7dd25jr6P8ZHTLV5jy+H59OL+TYOL8dvEdOI0+WSj/B7zRB2svIfApsi8R/5Q3qaMd7iSaGqD7FNv06bDTfCkzRbAbSdIttaDE6ZkSAWQmktm9FcPyAWIMt198Tcsirr3JZp/hKRdn/PDqNIQT1zfXuKdjgMRBe7/LwH0VczD0rRtVfQ1f9chvrVg+wO/WkUnZ+oOWf8QOS7+EPLwJIUHfk6/nl4eAitblMfLMe9NY2ArfxxPB0C9d5XXHhMy4hmn6EZ+6fVze3yPc+LE5jzKpuS47pxNj7/fQGG2zd3rHYp6cuWRTWwh9uxDGfyRceXbfUdTodVBJyGhF1wTd3su+eINqgYdeaaUuMBMbZzRZusISQx+MDrNX5v6gQ5sg/kn4+DryRvR5VhkvptLRx3uS6kuiMk9ddfifOpD9JUxVV7eBmcIunsMuXnFIt4fuzYVaxOH1Klkt3gybOKMQpiYhGkMvYiZE8Nil3r3hFSp1LAZ3QhureCg/oD0o83SXvIMPxwlxLKSUq8CFeXCgoqpWK8R8bUgWR9kYRJphEL391CTddhj5JsukPcnAUZCs2Z1E9LPs+7vE3VUsVHZKsDzH2M16aF9e1ZegOshO6lVUU2pJa+2athWZfoiZ2gMVZY/mMs/Qw10StvhIBxkYmS/09QmlCk3tQhuKXCdVz/SS5YG/MlEhcTASFQlQspqse3uAKHnZGN6aYTDY51STBxvX/jNIIbfV5csI2uQaYF/sHqkQ/9BUA6WUTnKuxX4/zTD68NpeAMubWBg21OEG3KrdVaes4mZB01JacsLsImExZWhpODRqVuMy4GwbDT4hkSFULXNSCFWGChbsof1D4yfyPy+gulGieQpo8B3niGUYHek8mRVrTJk
 2fJz4NmC
 UT7R1XCTVRBAF1S4bEfo4qCfQ/SkGzooYmrgFpz5G3bFYj5Y2aZssYEcuNvmK5lSil95U5dW4CnloPOXH6RhgqDOIbTpLh5jc2uU7ns9QGafewZOS2CIIBHPaJBzMWUAgZGF6tdWBucFMbJBuzln4IpavORUzlbhTY6Ey8/ChPFdrEQHI2wEeix3lg9hfsUQYteKWFvABsRieOtw2TuXcaMub20f1184nzOJQD5H6q7HsOQD6ug/R/NbmUSKsf3m4v63AB2hAZVhjc0xYST0PUv2BviGQv0+lxzDtpYNu+NEih/YJdeD+d8HPnOqw7sR+KXdBRSsMBF1V4Cq9bMeF4xKxv70zC3ChzgER9d1Zpmx+vXkZun9AuDe+h/yx+gLmqBPkFtvWbxxYUHwKkXaKNm8ybTqgcjwfadwp46RaVmR91ipDYIMReXQMyGnv9DF7UHF8RDZRqwAQnBm/lK0T2ASvgE1Eju28SwjVlEFtFV94M0J//OloCnl3OosZmMXzcTQwSb8GDh6X8ge/uStzff57LC4LoEj/DVhN7Dlu1ysFYfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
counted in PSI memory pressure or in the swapin and thrashing delays of
delay accounting.  Refaults of the workingset from zram, the main input
to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
become invisible in /proc/pressure/memory.

swap_read_folio() opens the accounting window with
psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
means to count the submission time.  For synchronous devices the
submission is the entire read: swap_bdev_submit_read() does
submit_bio_wait() and completes the folio.  Since reads are batched in
a swap_iocb, swap_read_folio() only queues the folio with
swap_add_folio(), and the bio is submitted later by swap_read_submit()
in the caller, e.g. swapin_sync(), after the window has been closed.
By then the folio is uptodate and unlocked, so the fault does not wait
on the folio lock either and the read time is not counted anywhere.

Found by code inspection; not reproduced.

Fix by submitting synchronous reads from within swap_read_folio(), as
was done before the batching, rather than from the caller.  This gives
up batching of readahead for synchronous devices, which do their I/O
inline anyway, in exchange for keeping the accounting simple and in one
place.

Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/page_io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index 65681eed9c80..83ed0246ebfc 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -500,6 +500,13 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
 
+	/*
+	 * Synchronous devices do the whole read at submission time, submit
+	 * it here so that it is accounted as memory stall and delay.
+	 */
+	if (synchronous)
+		swap_read_submit(ctx);
+
 finish:
 	if (workingset) {
 		delayacct_thrashing_end(&in_thrashing);

-- 
2.56.0



