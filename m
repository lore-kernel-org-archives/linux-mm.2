Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF67CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D756B00B4; Sat, 30 May 2026 18:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E7B6B00B8; Sat, 30 May 2026 18:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1866B00B9; Sat, 30 May 2026 18:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1706B00B4
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:19:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00F6C1403FA
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:56 +0000 (UTC)
X-FDA: 84825504834.10.397875E
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32BDC180002
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aRWcom97;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WamWMdUBlghIACFozBjX6pZ6qu316jN4xzYIhWYXbwQ=;
	b=AFskcbzZNd4Nc+0Yla7C0e95f42DqglKpKSiinqV32o0QZKlRU5nBGdT6vU0kv+lWPG9kt
	y9D314shwQmvBLOJzrsmqCv3UCoeS0FXExn+0mJB55NoGwD1tr8R67hZ4E9PFtku1p5oWz
	w6ZuPj6TFTgltdVbswAGvo7PGXTGI5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179595; a=rsa-sha256;
	cv=none;
	b=vuxAzvVhd8iN1tA1eXpBqDrs22kk5t+8heKmMzXEN4C1nVHWxlmUfvgrnNtix5ct9AexEb
	QlLkqVCYq+SX8/ufU3YlIy1NXib4wlDt+BHIwM5c1XBIbPdrrPIhCMzDCi0M2D/MqSp5a9
	wc8yHmCQkjDYtzYxzVTBKnMvu62INCk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aRWcom97;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9154ca1aa1dso53043485a.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179594; x=1780784394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WamWMdUBlghIACFozBjX6pZ6qu316jN4xzYIhWYXbwQ=;
        b=aRWcom97PsWApO6g7sIXyN+EsQh7Q7Vl6eT8Vqg9AnpZbfBcgmjk86gwKcGB9Y2RmM
         jo10a8SVRKYQ2rQCF3b1drwjAIaiOif2/G0GNKz/8o/pNizjOrVj/Qd1bXlSEdvtFiLl
         IEfXkPOKwVs/oyUG8/3RGdpAOc56vs4Dg6JKFjBck7MmVDA9N57elH3ElPKEmilxoHZD
         GiQaWg/QJDRV74YoYdZ5CR/p/zeJxYo1ruQJLbpQkbZspxrBMmGLVfwEKmOlDGmTL/79
         +J+sICBRpOHl+c6a1ahP/0RKqCf1zaYChXn98//+USozQAUFxiUONw7deC4DvwQldFPl
         gH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179594; x=1780784394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WamWMdUBlghIACFozBjX6pZ6qu316jN4xzYIhWYXbwQ=;
        b=kNVz39HqB/2wU8cchFjWqCC8Hyv5NA3361hCg5IIzEB6SVPvj6TVzEXhHH1QFLQlaX
         +2od6sNfYbDsET6yxxBst8a32ygk2xa+zrdVcIbtGtm7Ig+1ASi2wk14mSXoOeWHKvWS
         IZr2aPkbebswMuu/yqCeP35RFfWxaFXjVALCCcz9rrUWzIa/UTElMG/AHnk6KgdbI7Iw
         ngPnto1v7NvsKXkZEOmnB7bl52BjyMPYbyVYfQVKnVO1uKQZb+j23FFciYuK+4MaTLK4
         plRf7rc73T6AB4rdCZKhY+1+WLMovji3zN2ekPm9rR/Q6zfn/f4GAJGusuw8JRWdLJuG
         reIw==
X-Forwarded-Encrypted: i=1; AFNElJ+XBcP7CHeyvdIVT/3HQad3Y4KVby7gK7MIFyPnD7yhIMAHXJa+CmKtHvCXJfZ/knM9ot/2bmh0ig==@kvack.org
X-Gm-Message-State: AOJu0Yw0upJYu/f7AZ+hkNcCeWE6d3zwes62aBPOlr6HyiJck+GCagXE
	2MtZoLBosxPfBfTtlBUCQ+v/G1VXZEnOrTWHTkjtVwRFzo8R5VZO8li0XJ846cqhtWU=
X-Gm-Gg: Acq92OFzKort5D4zWNkLNYr2rpT1EAcG5R1gbwYsXJdbSL/PHY/Nz8xD/ApMHtFoarc
	X7iO41Ij/NzRAA+gOc2008xmYXSrKjVKgjhiiMhRTyg20VAH5cG/ElDWLT4TYwEIkaopgrFQ2O7
	X7RED/y9IDqB8XkV/rMQWw+Ilig+NXLxLevVESSBDQeFw4EhCZkTxaYoaMEH6kMbiGVVHWMsr1u
	2/cw6IymN944qi4uu9l+Fle9EvCtqqCW/dHLzY1EYR+LUwoj94GjP64+/oZW9s/b/H7O+gimixM
	3+Ho/TbdfsmrnE0xsudGtP+zW5A1Q2SPwpjUjdg6JPNPEL33SV5nqM8rHEUyCHpHnyx9ztTXGlo
	CwdcHzEwhc34NGWiU/7paXWc3TwdEPpkPiMuZFLx4FYheb3wB8nbKiBVxAsQ+/eJPr0tKzEX8io
	RjZjCoVsvkAoINEgoHEQIv6PogDCnEsDhGdfu7Od8BlRsEDrjshKJqY/hobHXcXA==
X-Received: by 2002:a05:620a:198e:b0:8d6:6db0:88de with SMTP id af79cd13be357-9152fa4cdfdmr980466785a.44.1780179594396;
        Sat, 30 May 2026 15:19:54 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:19:53 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v4 06/13] liveupdate: Extract luo_session_deserialize_one helper
Date: Sat, 30 May 2026 22:19:31 +0000
Message-ID: <20260530221938.115978-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: nesgp7yz4gk8p8pf4tyzzei4fxncseft
X-Rspamd-Queue-Id: 32BDC180002
X-Rspam-User: 
X-HE-Tag: 1780179595-556485
X-HE-Meta: U2FsdGVkX19/+66z52Z5rBBd6jggbqSUTVWeMSLgdYUaUddm0KaPcTVDUlZU0TlAMfnh/49/m3VQNk0u4odc5dY0Z9X9R3lUBZc7XsV3y9caBpSSCCHcrTGE4QMlvliDn0+DbBHkKxZby5h7oPmeD/LLXqg9/+t8/1sTLcufupLAmQqk5fonltBY+XJgdBiaW+dkrx/jKfvKsegY/1c9NITC4fJfgpQS4sFnFugiRQaZNsT8K3Q829sBWqYPIRPnGrdSrE/UeCdQdjnTmEm6W/UIWKP8c7/dgXsn4CR7H8ZZfAZB8kO4RHKxFUy6bzk9gYr22H8SorNpC40OsY7EPCjdccTv0fZRXn1Fv2RJnp+LPbbuEfTmwnIG8Z8yc41sH355taxUdF4lNuE2w+J1N+1SCSHYDa8au/+uBYIa/w6eJgEW6Q2x5CCe07CmH3VfTQ49v5Qh8E1CU4exltavPWczrtIlPl12lSjtPNSqw9oKyLNyCY/ty3S5D7ImWeqaUkhgcTGpebpuS69ZfIXwiqdCV4kKCY8kCoqoHzZia1JtnRW6WtR3jWuWfE7FIKYL+gQT/wG1aQLb3pbUn/4iVrjFDU87H921kNv67DHn3BJ6mR3pAZAOXj/1d8LMiSo9oeC+uyEWBdcsQY3oAeI7h8qCcHLwp/H28g0aeQT1cDXOzioT5YEP/agj+jjtkIhH6tvT4d3CL5oYI1svvgd882jQii+DNfzsQJ0nTFNJIS53JdHNn00s0k+xK3o2Z9PbxDZmMsj+ZEAkbE5zyAIeEx5dg6OpEopInkOYvmxjWXv/T1fbSNt8HoyHCTHAHjiI8A0Ld+mPwxX1W0jk/S181oj45bS64vu5mfNk/wAtO2s4rsQ7L0JaKyN6G6EEhxhDPnRAzgplxotxN6jKQl/beASnVU/WRnXjQgJEnUowiO5PjamUlLQLSkMPZ69fIwGN/PuKWvDzwQbuCuoNhfY
 ZFuOK6v6
 cLpiPXG8mm6wHT997nTt1I0bmFHKn/wNvIkn/ZSbuxlk9yWnsB7X6QwRR/FlWN4/qJJh8w9jUCuypAw7acmRAFmXrLRh94eVEZ1CGz9g6cVx+IT4eWiko/P+7Tccfzn41p15UBd+nC9CJpum/S2RNNEGgj21iy2Bh9GXrO12SwZyiq7CflAI4K/W+Wq96UXyOG8ZKidbBo5K7h3eus7J0bBffxEjRPr2/xSER3Oo5UfnOfqWN34XROiXi+kSlbF5saTZaEu3oeCOUyN+wpvd/TmXBJbIV4UdREJk2At7gFxIJbmT7me/r4Z756INbNsx95tJk0mrQCrosvyWLzxDSda0z2lWfQ6869lZwL8+RhiTkO2Fb6GOINdUaVFshtFLoGFD9g+xrYXl6TcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the logic for deserializing single entries for sessions into
separate helper functions. In preparation to a linked-block
serialization for sessions.

This is a pure code movement, no other changes intended.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 62 +++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 3b760fefa7b9..b728fd9e3ed2 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -525,6 +525,40 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
 	return 0;
 }
 
+static int luo_session_deserialize_one(struct luo_session_header *sh,
+				       struct luo_session_ser *ser)
+{
+	struct luo_session *session;
+	int err;
+
+	session = luo_session_alloc(ser->name);
+	if (IS_ERR(session)) {
+		pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
+			(int)sizeof(ser->name), ser->name, session);
+		return PTR_ERR(session);
+	}
+
+	err = luo_session_insert(sh, session);
+	if (err) {
+		pr_warn("Failed to insert session [%s] %pe\n",
+			session->name, ERR_PTR(err));
+		luo_session_free(session);
+		return err;
+	}
+
+	scoped_guard(mutex, &session->mutex) {
+		err = luo_file_deserialize(&session->file_set,
+					   &ser->file_set_ser);
+	}
+	if (err) {
+		pr_warn("Failed to deserialize files for session [%s] %pe\n",
+			session->name, ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
 int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
@@ -555,33 +589,9 @@ int luo_session_deserialize(void)
 	 * reliably reset devices and reclaim memory.
 	 */
 	for (int i = 0; i < sh->header_ser->count; i++) {
-		struct luo_session *session;
-
-		session = luo_session_alloc(sh->ser[i].name);
-		if (IS_ERR(session)) {
-			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
-				(int)sizeof(sh->ser[i].name),
-				sh->ser[i].name, session);
-			return PTR_ERR(session);
-		}
-
-		err = luo_session_insert(sh, session);
-		if (err) {
-			pr_warn("Failed to insert session [%s] %pe\n",
-				session->name, ERR_PTR(err));
-			luo_session_free(session);
-			return err;
-		}
-
-		scoped_guard(mutex, &session->mutex) {
-			err = luo_file_deserialize(&session->file_set,
-						   &sh->ser[i].file_set_ser);
-		}
-		if (err) {
-			pr_warn("Failed to deserialize files for session [%s] %pe\n",
-				session->name, ERR_PTR(err));
+		err = luo_session_deserialize_one(sh, &sh->ser[i]);
+		if (err)
 			return err;
-		}
 	}
 
 	kho_restore_free(sh->header_ser);
-- 
2.53.0


