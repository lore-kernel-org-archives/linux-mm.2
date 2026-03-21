Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55C01094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300E86B0103; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0466B00FA; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8536B0103; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D112A6B0100
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A5E9140633
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:56 +0000 (UTC)
X-FDA: 84570848712.25.A695D42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9246580010
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VHvRtlHi;
	spf=pass (imf02.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVRyu+UEt5WdqsU9uTPN0yHTsLg8//CtIF18tXpeGYg=;
	b=ZVjff4AFZLx67yOtxDAm8rIhGzXr+kSY8JyjMDODYPGlMZZoxup/cWJEihwQk6lqCFXxje
	e1xogV232p86P5MkPCvLEEjovh7J9WwcFoHewSMwdNiVRK+9YtURLlR+O2RCPzVg4ESm09
	sreJ4pfKOiiEuxjoQQEO52sVcNGk4Aw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VHvRtlHi;
	spf=pass (imf02.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116354; a=rsa-sha256;
	cv=none;
	b=DGILqjOMnyl6hiPqKcAE4m0d/3UV+yVU5xj6cdh6mBrGkSbKudiFiqp796S2Ne6g3w7muG
	5aQbUNxTeAoW1GKH4xvYBfkSvUMbu7h2NbglSISwBVKsOPGwVaWPqvuqPPGyO2CAYa+t3T
	O7n5jgOLTJUUIZ2VL5GqmlRQe/ta6Yk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CCE8442DE;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77D59C2BCB3;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116353;
	bh=mH1bbzg1toElM+aYhUOHKFjoyynXL2nUy0Bs26YrHAk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VHvRtlHi/oByD79fv48x6iNOcazJsOSFTHHkzO4noHSGPOpUtzvjwx2WkqpKLfrM/
	 NxGxGM5BMJ1psArZpsfahO1N3UkoAQ4f+Sd1Jq0D76Gl2x9cxiBElYIb1psAvW1uH0
	 Tr+WrnoUO+pZCxWaK5j2eEJINYlNtKSKJmHaaaQO2uHhN0iHfsBi41vAAtvpCr0I6E
	 XPiN498BXqJBP3Ju8/h/ZHJjQ6QGmIT2fmnv53CW8AfR/P6C+6+G/+xphlL/pZyc5X
	 NoALVJ8owxqvX/pplQYFkyPbaQ0acZsRBroV4HJ3NuEBYYz6lg32aM0Emba3UQkBg7
	 n/7Z9Y7q10cdQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3D3109446F;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 21 Mar 2026 23:35:48 +0530
Subject: [PATCH v6 3/6] mm/vmalloc: zero newly exposed memory on vrealloc()
 grow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260321-vmalloc-shrink-v6-3-062ca7b7ceb2@zohomail.in>
References: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
In-Reply-To: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774116351; l=1805;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=uKz24R3I3ek2aPMpo8mT2jA7mZwUk/0kKs44mZjEWwY=;
 b=SbEulE6vIyO33qNSsTDaNxkXiPh02FBirztOinNJUvoERwLlk3BZOWFs/TSe/RbqSHokKF19L
 hkAhCqBBgK7DPZC6cRSoEnAdkjU3g8wmoC8brnpz5Q6Dahv1SOjUhu3
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 9246580010
X-Stat-Signature: w4b7purwz4tooxqdjhrrzfrsd7js9jau
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774116354-326709
X-HE-Meta: U2FsdGVkX18Z59BBGzU3ik7DvlTPp/EO0AwKZieG8iy0qZlPUiNTNCPukmuycOX5/fEeGZQNX8dI0y9m/vGGOrpsAJiA1iKb9lypd1gFPNwLpzikaVAFnq8zRNfPbM4TUbkRH/UqTwdsFh6EhFd+kJo+9U7pecFJ7jAhkloXm+O4AborTdRJuzSqUPy462BQnb4bsv1gmiT9KvwiIBomXwfEeRIvfsNI2XuB0GxdrQAF68mzNuejhGa+KbgRDDUmJ6/7Hs/ZY5KcV/mToftcqAnFErfTN9zLa3Aihk11FM9UMUXtwl/1a+IHFEJ5WSM0RAMeGvnoc4S07Xb/qRB3d+8hjD9lG/Cscby+MvNWS26a6pib7CjcHmkVU1DGTS8DrHagCwGeGne04T0N5CzzEEmUzAoPRTNDor+x6+0ieSQJjniq9m9sGWpGvEPMi2u8CEeMpvc48mUdtYZBhP8eJ3lVj/NIUiISlS630iLvAF85kOGFrAFuFPSHUoATkmqzLsdV5DeJZ8escAgbUGxdMMaxfsbprDuBMph32OORAOSe70nRt6VN6c/NflXIiXHRzdJB7iyuRA4Lv404jXLtbggEjFyxVWozP6uorLPkGrT+jRRPKbcu9yTYcavQ18NAVQ6KrmLybMQiRcnN3YCrdLenfUn3UoQa+jS8dneEd75W6zpgVv/mSZuVm9TLSc/Tb6APXleW95tICCQMWNJGSAUeQn3YaN7G2hQ3Ap2l1CBTJsQIjhxwwCkslwY9CIAraESOg9RkXzUbje0f8Aai++NNFYXju0aZjJ5C+fLUDQTxmH0gooRMs8AC3OKK38urlJ0WpEFwPMih5RQRZIhKNnjvz0NH3tohw8scxlvdUT5i2SGkXCthcdyXRdkdRe5RcyctpHAyI42cfNjlK7snM/zBSxtBPLuHIi2r83WY3vRhiSnqk/o5h4iMfo9s9Yj+2givW/xMtn9vwKmJiX0
 p1Mo+8Tf
 aVl6NPAIfKRLEiW8lcE+bdgclhvBxKLYvcl99HLF33TtJvPGriLhILkg9rt8N9CRqLUFxkCNeugHR13LOMBu0Jp3Hiq6D+3hMg/mXLEU3KnKEnok/hMabN9BSJz8Rp6BWgPTB9mgc5hg0VICGGOql29BPDeWF6eptgMX7mP5u0T8MKiBBVmvkNFuZKpno67NoktHwh3GhebBt9rPIoGDEPhmZ9keWGSUwNJv07/TNOKE1djEHMOvTHDbuhtkbeMAkTNZayS3lnUEjR46fI0TTlarWr5qZqgDZydYg70n9dziMzuQ3Z92e4m/lVMIxAv50wjWZwTmRq0B82VOCHE/FfNDxAU+3aQXxpsKR7MR0uooei6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

When growing an existing vmalloc allocation in-place, zero the newly
exposed memory region [old_size, size) if the caller requested it via
__GFP_ZERO (checked via want_init_on_alloc(flags)).

Previously, the code assumed that the unused capacity in the vm_struct
was already zeroed either at initial allocation time or during a prior
shrink. However, if an intermediate shrink operation occurred without
__GFP_ZERO and without init_on_free enabled, the "freed" portion of the
allocation would retain its old data.

If a subsequent grow-in-place operation then explicitly requests
__GFP_ZERO, failing to zero the memory here would violate the allocation
flags and leak the previously discarded, potentially sensitive data.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7bc7a6892c1a..64f5d1088281 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4362,13 +4362,16 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	 * We already have the bytes available in the allocation; use them.
 	 */
 	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
-		/*
-		 * No need to zero memory here, as unused memory will have
-		 * already been zeroed at initial allocation time or during
-		 * realloc shrink time.
-		 */
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
+
+		/*
+		 * Zero the newly exposed bytes if requested.
+		 * The region [old_size, size) may contain stale data from
+		 * a previous shrink that did not use __GFP_ZERO.
+		 */
+		if (want_init_on_alloc(flags))
+			memset((void *)p + old_size, 0, size - old_size);
 		return (void *)p;
 	}
 

-- 
2.43.0



