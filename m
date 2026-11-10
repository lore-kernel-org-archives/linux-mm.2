Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42412606A9CB
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8UyGd/R
Received: by kanga.kvack.org (Postfix)
	id 6B1B46B05B5; Tue, 10 Nov 2026 11:57:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663E26B05B6; Tue, 10 Nov 2026 11:57:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551FF6B05B7; Tue, 10 Nov 2026 11:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3087B6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:57:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E088C0995
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:57:57 +0000 (UTC)
X-FDA: 85419816594.05.EB5AD1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6BA01C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:57:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y8UyGd/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/rX53MCK+F8+8pu8v3hRh+esRHjUU6DuquJwjMhAJg=;
	b=pu5nRkjIJMHPHWyqJGnPNXaDGUV/0yxAnPEB59ZCTKfuYn63nmedCUe3D3n8LqOs/1Ewih
	zGOINPBSSxFWAWlKkuVNvJEvJIkSwGiwTGZLppI+Eu8PmG8ZGnfnSGoqR+iJIErXm2cdSw
	zrz9mfx2IfsP4qTRq2IK+BRW69XmJzs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329875;
	b=ofDIJicgVTZMv1NDBA089MalKdZCUy3mTpwQtfIqyJxOM+qSTATHr0v+sD9vNXnGxCwF4I
	AtLLzCrlNLWrpCbnLWMaTRGkKGTqbB/YbT8pLGSArKCaWFGA4PS1whXBJGsDrqAaVexfk7
	zAkYrnIcPLGeB+XWCP0hCuowVMMfrPc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y8UyGd/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A104B471F0;
	Tue, 10 Nov 2026 16:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606831F008A2;
	Tue, 10 Nov 2026 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329874;
	bh=t/rX53MCK+F8+8pu8v3hRh+esRHjUU6DuquJwjMhAJg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y8UyGd/RTtTu5gM1mnagjLUP0I72SAKepXsCoEMeT94G0dJnrd0OWgdg34KVjNs+q
	 R5DDn/Oij8+gq7+RktimQ79fuvMP0Kn2CoBkLW8olGlVzk5zEhdGVr9K9WmwfUer5h
	 W9h9ONcrKEB/xPKLuLZh6PqjIqvcvZHrsUyFLkxLYGo64uHKmNxVeks9WeDdFwMsq4
	 LLBlOhOLGAHBMiVlIjGC6vxBqu086+SVY1bkwTCVS2jdKOtn/ugf6zO2I6CQZuMCa6
	 w2fpOZp+qM/Exhqh7nYO8i1oKtixt22KYgrn5TCOM7gKmDO3ZGZcErlC4UGCnf2EB2
	 qq/trWYbHdvcg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 16:57:43 +0000
Subject: [PATCH 1/3] mm: only assert mmap locks if CONFIG_DEBUG_VM or
 lockdep is set
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-tame-vma-asserts-v1-1-be293ff499a7@kernel.org>
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
In-Reply-To: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1695; i=ljs@kernel.org;
 h=from:subject:message-id; bh=vjPP3edYWn/6OBXj1HiySy0Qa49t43GUAeNl0TkpuQc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI++/JwFS9umXOT5wFPuuEHteqQcKdkFb/0PHGDeq5O3
 pS6N5kdpSwMYlwMsmKKLM+/iO8PEgmb13nB3w1mDisTyBAGLk4BmMjVTob/EcL2Vi+m7isUm/nl
 8T7to3dbrqe7rJjcOqtFpLV99mJhHYZ/er1rnub/3f/tsu+8vM2n1yZdOvBOyGblnbd+Yjk6HN0
 ufAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: p4jetjdfcfjr4dx6qmdjr5amnru4k53h
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6BA01C0004
X-HE-Tag: 1794329875-47986
X-HE-Meta: U2FsdGVkX1/y0GsYf3zEp0oJJgbODsuQXBYdIFquNyMiyxkTYcvmnKIRmR9P1EOCzXp+48KNEMWFVd68v2D3RhzHUNHu3n6acsNAxpZYvdMj+RjmNYNkGpp9TwynBdoprQsIgB1jjnjKJIGU0yVVaYZsLvtijFTyVnUiS3V3mP5jIX2Ddvc0TjRSCk2+Yy3fy0kzbBsvVgS6vQdVotePfgWjdY7P1Xvk7+se/nrmndmvTAyBxgWSNpW8aAU7LSZB5lMPglbKEXIl6bgqljk+A0CJJ6yiQ5AsWzi6GsGy5VJf1d9OZQ46nthFFpOPMl823+MlPtkItC1tL8izw4pCx7NOzyKY9tX/iVmph8n+lRL/weQMwNAjdbTuS73QhjOcwyR1bLHC+PZILGwc9nn2g/356okZ+goznCTw3Fv4o76NjUGNeZqZlPsH16eDvpEouGn1HSwoKzbNg0uDxbu9lYQRsxHKeHGTSJBWwsbWk1Q/yE5PZk+TSDLElRzM9ZitdiO8sBi35tkjYtvLMQBtnx1DDzTVxtDJuOKGDcIcEvSKvluVGhXZeStQKYyq5B09rVv2h2tA3Ewl9qKP67CCMNt9a+de0V4CPdl0zhlVrlRv2VcEl27O5RB4MUyYo8M+N/sl8IX6aBlbVirHuhVhIIrDze8l4TaeX2Mz4ME5YFwE01nTIOwPcdPdq2t4+F3HSsoFQ/DCRc82CBsJt2mydUpAd3OHJEejQGpNAuZeBbWbop3dYTUUvvw8wiLo8xLUuPUmT1ubARUO8q/wxsrwGqhDFCBlZsx0Ue4bj+nO/GmRw86CSgurBsNwdB4ibsh7wvqSeMy+UXDOXtzUW/Oyv8yMn60dHheKD7IYGdI9gE2HaaEl4p12p6PVUL3xZMkpqFo+M8gynrhjkdCLmCkCWuRZO7qPEEBCKnUIPD0/4GFgHp/xKejBO+/re6LgsfbaFRQUU1+Hn4ydKHXiuj+
 oFtD55dF
 WL9+kAbZJ1ospjknC4vh/gq6x+aPsIqvr0CrsMzrQRart37TwyeqGxvVBMSWIclztxxmqIP7XsN5NH0fEfbsCEe/crq/un98D6TVpJfYQQavr03fUaWXss1287Ce5tQ1F3QSc9YAiwAVk91T4whHeA1zOrIyqLB4m7sRkPNJinE/rHqyMWvAqWQhh0kPKR30yhplnZHve5Q3mRthrlwIcmqT4jGOWYew5imnfpemyaQKeAvHKNpHG0AwzKWrLgFUv2kk8ERo9Gd+iVDkvmEgI91yQeA32m6P/47CE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For a long while we have asserted the mmap lock being held regardless of
whether or not the kernel is a debug build or not.

In general, given that these have been added as programmatic asserts that
nobody did something stupid, production kernels are simply wasting their
time checking for this.

It also means there is a two tier system - where some programmatic
asserts (e.g. VM_WARN_ON_ONCE()-checked conditions) are only checked for if
CONFIG_DEBUG_VM is enabled, whereas others are checked unconditionally.

If we genuinely want to unconditionally check for the mmap lock being held
at runtime, then that should be made clear in the code doing it.

Regardless, if CONFIG_LOCKDEP is enabled, ensure that the lockdep
assertions are performed.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mmap_lock.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 9c3a9c6525c1..9367430ee53c 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -75,12 +75,14 @@ static inline void __mmap_lock_trace_released(struct mm_struct *mm, bool write)
 
 static inline void mmap_assert_locked(const struct mm_struct *mm)
 {
-	rwsem_assert_held(&mm->mmap_lock);
+	if (IS_ENABLED(CONFIG_DEBUG_VM) || IS_ENABLED(CONFIG_LOCKDEP))
+		rwsem_assert_held(&mm->mmap_lock);
 }
 
 static inline void mmap_assert_write_locked(const struct mm_struct *mm)
 {
-	rwsem_assert_held_write(&mm->mmap_lock);
+	if (IS_ENABLED(CONFIG_DEBUG_VM) || IS_ENABLED(CONFIG_LOCKDEP))
+		rwsem_assert_held_write(&mm->mmap_lock);
 }
 
 #ifdef CONFIG_LOCKDEP

-- 
2.56.0


