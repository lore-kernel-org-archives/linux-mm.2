Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F190C606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PKvEfQ0c
Received: by kanga.kvack.org (Postfix)
	id 1E8A86B05B3; Wed, 18 Nov 2026 05:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198BE6B05B4; Wed, 18 Nov 2026 05:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0881F6B05B5; Wed, 18 Nov 2026 05:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDDF16B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:35:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CE881A06CE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:35:12 +0000 (UTC)
X-FDA: 85447882464.04.E4E9FBE
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id BE06840005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:35:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PKvEfQ0c;
	spf=pass (imf17.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794998110;
	b=TE7plsGLFz3PLwmy2ideZjsUvhK9XNmi9ZQ0XNOGs/hhtdSVvZeo0XWlRIWTkgFzSd/YZh
	wBOHCtTXcrSulhFwcM71qMMHmjmmZStcGJvUVOyKAFVfVNLioasW8JiV1G3dekPUOhaMEI
	oLGzbwAta/qb6j2ygcVhiryCKJZ6iJE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PKvEfQ0c;
	spf=pass (imf17.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794998110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ul29onCED1G/GzZehDklBOv4YKtGEiuVI0wtuD2b89k=;
	b=qnWe43xV5D9MLX/h48Rks/2wXHfsuiKP7+CoeC6g5ZOJk+p9THssAkHyFsGHRV7fwqPzCR
	ra54wJZ6uANEmY12MOs4rDeO5uNmED7TdTRJKGiGXHWO8KQ3r1Sdig7hR3iaViUXsw/v5f
	ThOmlIXM2FTqwYcfi+0yf4T5SCGLZ7U=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e987a2ba0cso5508385ad.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794998109; x=1795602909; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ul29onCED1G/GzZehDklBOv4YKtGEiuVI0wtuD2b89k=;
        b=PKvEfQ0ckXvhNdcFg6HgY2QleIBW7VykpHVIAfRehtPuPzxP1gHDOuGZ1uliBQN9WK
         dGSD3SC021y1xeg71bSr3s+iXldWZnIt4/tQoSu4e4z/uPQtagDtwx4N9Y2TKrO+49wB
         1I8RhFHEdA1YXGETA6O09Pg3G+QY9jEUEAhoUhegHrzuMjNGIL5dn3qcm9RUvlfIvF2y
         yH4JqIsa5AoYniMFzb1D54YjNhBEI97YeGJL5yC3srUiq+taS5iC0dox6Ey+DYFMUaUZ
         8m7FYo0swpHxTNccTB8LSx4NgfLhGXs3lfXwB9tiOsg5YQKN/Ub5/UE6QFFSBkjuesjh
         Qhsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794998109; x=1795602909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ul29onCED1G/GzZehDklBOv4YKtGEiuVI0wtuD2b89k=;
        b=t9Zeav8CGkGArzYGRfErZFjnSW8PBu5NrZfelKIOEaqB9zgZd5LaT4Pp95mIt60ycE
         FpTe4GRKr7d6iIcRsS/Bm/LLU36qhMjPWHlI5dHu3OA1NF7zKeyk6Td+GRpP7T9/g/nE
         YKrffzScG3HxFg1FcpGpGqG+Q+JcqvhbFp+wYD6HKd6/Y63s5PDxuC0Rgne+3uXOqc3d
         T+GOobs6AbV0kZkh9xy1nJvKdKXG57SUYsRa26denfGMQuZrUN1rItduU7N3XLUM/mjC
         7kfPsueyMWfv4k08KixOZiLL/DuT11HD81mD4CmXA5nVQZaVXrZ6SbAOA34an3wRulgM
         ZWIg==
X-Forwarded-Encrypted: i=1; AL+hErEjSpTdffMnTz7GjIZCXBq2ibRU5uvGepP1y6J1PNM8wJ9YsswiXqIoP34F7lHGjQerh7JVB9LKvQ==@kvack.org
X-Gm-Message-State: APuU4Z/UixoO7LE9WeSHDQqKWa40Pcr5en4a+ArFmuqeB7jcEuhus/LV
	NZChyBa0fPXoNt4q1kbNd9NansNLa8sZ/Ukxozm71rLxQ7TT6CXJHq2G
X-Gm-Gg: AZFdTZdc4VfA3/oMynsezqBO67h0+Twzwhv8FN87qYD04+jES2R1NJu323fSeTmBBgL
	YAT3eP8ywa3n9aFOWgwZLvFCDdlZT51heGxGiJgmOxkVjmee1alrGqHVydUzGccLOjv0VT0q2pu
	nKZ53PQWHlD07OC299uOwOICmFhdeSxICgimdSSUQe06XAWKHazRZDGeKlq2XrrGp8vdh0TkoED
	V2t35nXEb3oTBXZFb43P6Gz3nLdBPUf4Q4INSQ0SvPxWFf2UeWKuYyJEiqrF7lPaIzvP6CuD4zE
	lDATtoHrX56FE7tPXOcM5N9cKElk/dypr3ZGL4v0Ay2MtZjG8jlK8m65ugPczVUrkzR5JIEAGYq
	EEUwwFvEOcGRqhQaRprg5aMAMnXhp49ImmTaIKIoWJ2CF9FLPLPlSGkB1piEXdwFvejWgP7+rYv
	SsDHB61fPBU67394FDY1j5zTy2TSttJUuK4GKiiq/+jLlzriJkwWhcCtZgkyNWA36fWDbCWK+AC
	S52k9d2apK78y6vp1G/ajO+T6p0FQ3nx25v9D8Hy69F/BQ8RJJNV8diCUV2YPshfApDd+K9xqZF
	6WRAEqfI5adc8r0fbCMeWJG4XnqMvsa8UvxQFachIUlMHWdaQceRX00I6pjU31Zx+E2rdlWM+y+
	7zGhvo00mzzfVP4ohrEyqQbFVxDs74PuQCHzw2SclWIkj
X-Received: by 2002:a17:90b:39a8:b0:3b3:b0f4:1beb with SMTP id 98e67ed59e1d1-3b3d074d68emr2305361a91.16.1794998109533;
        Wed, 18 Nov 2026 02:35:09 -0800 (PST)
Received: from AHUANG12-3ZHH9X.lenovo.com (static-ip-4-78-56-61.rev.dyxnet.com. [61.56.78.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d1acd118sm3757904a91.12.2026.11.18.02.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 02:35:09 -0800 (PST)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH mm-unstable v2 1/1] fs/proc/task_mmu: avoid spurious seq_file warning on interrupted VMA lookup
Date: Wed, 18 Nov 2026 18:34:21 +0800
Message-Id: <20261118103421.776-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE06840005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: r7fqz3w3u9c1yi6gwwmmr3ydzcb1m6am
X-Rspam-User: 
X-HE-Tag: 1794998110-392530
X-HE-Meta: U2FsdGVkX1/VBwPU839FOfyXGXS6uxxIubcIZ2etUbav+GgYMRJJGRtX6cCsrRBfItpnud7Y/HC75Vb49JtDG8VQfztxYJ0/3WGOL/m2xVjTDUso8dUYhVS/QOicDphDrPBhUXo77eifO4ATapX9LKt6ZD+OXKKrrJ6VBelN8gNgRF5eMF7ZQuxWWFIgdbAwguiT0dHfDjE3UVMrZ1XFh7hRYuzC0FdWmO/gTsd0WwELJb5IjmoM9uioMk+YopnuQboS70ud+ACMVMi5J+Z9D3ANu7dVA654bXQEoY95Hgct8dE9FHcPMQPDdLjTIS698lRs4jMkfIy5vrh3JJ4Pg8ngrLSQJXH+HjdAvZNWK2UJQDEhNvZKKi7TNPMzJM13boN//IPRCzhvDvCSuobqmxsngA45IStwR1RWZoRD2MO/RUr590hhQRRIOKlqQJgL0SZvLzzB58A0dJ0lb5cc7o73ZgrnOORWmFNO3H3UERvSF0Qqb8ouAp5McJtF1xQPxpZwtTyhmNPv3MgJDDP9cx2f4nfqi4mhfd7onYVCimq3HvZvJqXo0HXZcUrgPKJTgiYJVQiSWs2anfBJuuWF2UGctWQ41v6TMHPgzFb/h8NsPC7yqo1SEWjhVweD53g8PuQcY1BYOUaUDcHCyiGXite8k6MMgyY6pgVgSu0WGq1yz/gpogwyAH1i9rGv9vtR/0a4pDFUvC6d34f5QevaUHOep/J/zWtZVIytwy5TK9f+4Ql43rCgd5fc8k9VyOHLY3T4pYGHiK42ZTzP29BB+drGyrsNEq0kPKat3QWQPG+O/WsYIaBzxW+7j7c9e0OM8CCfhAE7j2r1MoefKdaIrfkAvFm76aSsuHCsD5c+CA6OiNwGnuQSzxOh3AXnZIixD+BU4lxk8VzudIUej8juF1q5pGqIUPZ1VzUGffbHrKliYjK++IhjEZpgG3L27kScY6HQy/eL0+oLZlAHVgc
 nIU0gkno
 ZhODo7LMxK47xKlzcHh2i5RLac0ZcRF8Z9uEu8axilvuxukiUoIptF+32xY3aXwewZ2gYp1rwl2BQ0ZV8zjF06Y3Ek3iXqh3enSZ025OkQ2IHRjTbs96hzRt96n6g8f4eDh5Yx0dL1P44omUvFZA3tBEn+uv4TUZ3iOJHRlUTJA2FnQumDYx/sGiKir7xWnNAhlbnPQjodx1YRXsO1/M/8yDFGA5DzgIYIpKt1OdcoGTcgQUl30fuj3J6UTTliNHqugRwGlw/n93fJ2sU9ifxUkupUAEMGIar6FjQLKJEEk4jGN/bTt+/eIZY4tloo1rzsONwQWUKxbanYi36nvfNbcjLRTRpK6AaCfdjjX5NSCoOk9EZGzwvqEku1cq/yw5wHEwvVgOB53oX938BXTUpcimNfGqhE0dO8BfQGcSu8VJLd1J3NcKa48BNYG/cZ082uINHspmPBUIcSe6FTBL7I1s7IlHiFusbNJqQ1+yCWSRzuQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
per-vma lock") introduced the possibility of returning -EINTR from
proc_get_vma() when a fatal signal interrupts mmap_read_lock_killable().

The issue can be reproduced using stress-ng's VMA stressor, which reads
/proc/self/maps while concurrently modifying VMAs and periodically
terminates child processes with SIGKILL. The reproduced command is:

  # stress-ng --vma 0 -t 60

When the VMA lookup is interrupted, proc_get_vma() returns an error
pointer without advancing the position index. Consequently,
seq_read_iter() emits the following rate-limited informational message:

  seq_file: buggy .next function m_next did not update position index

Save the current position in priv->last_pos before checking the VMA
lookup result, allowing it to be reused by both successful and error
paths. Advance the position index when returning an error to avoid
the spurious warning, while preserving the original error handling.

Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
Changes since v1:
  - Simplify the error handling and comments as suggested by Lorenzo.
  - Clarify the fatal-signal trigger and the cosmetic nature of the warning.

 fs/proc/task_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d..564e52f7ddc6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -216,16 +216,17 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 
 retry:
 	vma = get_next_vma(priv, *ppos);
-	/* EINTR of EAGAIN is possible */
+	/* Store previous position to be able to restart if needed */
+	priv->last_pos = *ppos;
 	if (IS_ERR(vma)) {
 		if (PTR_ERR(vma) == -EAGAIN && fallback_to_mmap_lock(priv, *ppos))
 			goto retry;
 
+		/* Advance to avoid spurious buggy seq warning in dmesg */
+		(*ppos)++;
 		return vma;
 	}
 
-	/* Store previous position to be able to restart if needed */
-	priv->last_pos = *ppos;
 	if (vma) {
 		/*
 		 * Track the end of the reported vma to ensure position changes
-- 
2.43.0


