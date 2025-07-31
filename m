Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6DDC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 13:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451C26B00A3; Thu, 31 Jul 2025 09:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409796B00A4; Thu, 31 Jul 2025 09:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F076B00A5; Thu, 31 Jul 2025 09:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 270646B00A3
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:23:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD3C4BAC99
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:23:20 +0000 (UTC)
X-FDA: 83724626160.16.8E4F37C
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0FDBDC0007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:23:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MOqcbjc3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753968197; a=rsa-sha256;
	cv=none;
	b=dBVM9TiFEmKJAuff7HDAmxgdr9TIy3w/cIh6BGV8pNccCKk/ASf0+d9mzqEHmaNsKN9pNW
	ABCQGF9oCin9rTRWNyDGeYIgqya+Q1/ithwPSFMNlAfpzjEtqXumo5N7jeShf2g6C47UZh
	vaR7EKzTa8FKxady5A2yq+G13UbZKsw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MOqcbjc3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753968197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZOGGdyHbZUhQyDNRYA2xz+A6y6GeRpSpoCEnGZFiNqY=;
	b=PfxRZQcqpfBpRGbX91YJJyHybBFZvvg8/2lavq6vpKleZ0FGyZibosrh5IsPpxHfKN+u8J
	qMOyZRhCuYF/lwSFEl29n83wCXkCb4tQuIQFq/FR5mEt2PDsvR89OV9+/Y6oKO5u/d8FGi
	WBdsVDCn6SlAeDtaogDuYKJXLT8PI4M=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b3bdab4bf19so762936a12.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753968196; x=1754572996; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOGGdyHbZUhQyDNRYA2xz+A6y6GeRpSpoCEnGZFiNqY=;
        b=MOqcbjc3zdL8ut/xE7yA6TrAoLwYoWsn9JSVAk/ED2LlEqPsDHRP57+TnQFdvItrTF
         T/TgQjbnCbYjQy1qRGxFL67bE2Fr04zYZ5PF7ZHPkBm3f5dH/Q5FUKG+IRylWRLdKh+P
         GhfOurL8ZCjUeChOzNo/ahxkHfM39cvCPqLx1XF2O27zS8piD+JQZ6KrsIu2DYy35Qcz
         7s2wacrbhCrALm8pMmKGrLlfEiTA6nb0Mi0d+D7bGsNTSIrWs9eSNsvFdI2NVcxO7hDI
         9gMJGQyoZCXBTUW5U6t/n2abrpsHLVg+5h4O7A/IgqnYvaVCGSeiI4OrZkPs8sbroh3k
         CeFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753968196; x=1754572996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZOGGdyHbZUhQyDNRYA2xz+A6y6GeRpSpoCEnGZFiNqY=;
        b=PO9E4O99zUP24qAksNFGguBy8jZNGrgyDOsqnHOvvzqan0BgQS5seqgfZE6Y1Tn2pq
         Se1MglW8u9sN7xzTX2PCmQ+SNXyV5lplV8wi8F9mlWk9JKghEYEXYnkZW4Gpn1vxIf7l
         KF85tYUzFA2wQezRFM9cf1CFUb+D+xb2/BDKYrqgg6gLc8O0KxSLzJrMf3oYdXGdw/Qn
         86ispiig3eNnsrjV8bZUEDDlEOxaIw7AzbItjBMTaIvbY8GYWeohM3KcVO6zXT5VxbJd
         NL8L1vGFvtAzwwX4az3OBLzZgoDUrcqO1L4RUL0kewwVPzggUj26rLNDS/n1Steam4y1
         Scsw==
X-Forwarded-Encrypted: i=1; AJvYcCXVb4zWtmrls9YyCcfERg4q8eRrkt+JjUiRE8Iwtp5Z6BPd0ujKtA6o/oanExDH0jkYbpG6mGbXbQ==@kvack.org
X-Gm-Message-State: AOJu0YxYLf+Q60G9Dbn13XubWNn3gGvehXx3dC8klC1EJFgf0n8Ho5nr
	NrQu++4GHfrKs82z4EC/VgOML5JZcu2gz6tkrrvBb9APCR1mhkzfxcwEn+CZAIgaIX9tFA==
X-Gm-Gg: ASbGncuzzPvEb/M5Grz971THgk3vGs1RxVJj5Dnbky6CArlMraRl0Dqg2foqCGY6Oo0
	3LZBi/ZYJ1FPENwUCAWHl74fAdoM9sK2qy4RyAlNqSc6yRJTDOr5wC8yN8ITxmP2srwdmCDD/FS
	OuGGXdhz0PigEBaWPX0LMeqpdRsHJZeJH5XDihR32uejcu3vJpIBgAKYp516lXakTiE/SoH4bMt
	wQYxNnLYh4xvUccIlOsuF1t6/8SGjO33mG7QXq7Xxwznly05eqrvgNf30tt7j47w7UXzUcrqYD5
	T8f9qGnRJ/jms0Va8XgRzJh8Zdo/lp6YReLqX4ALTtO5GB+0On/tauGI3LHkQNgliuzwC97a6w2
	zUTYjgPpCj0SqMqsZ
X-Google-Smtp-Source: AGHT+IFvwEIp3lXVD/L+5kD/sKYGKqGyXnBBKkOezPOOiveWNVfu4Kceqs4/WOMCqQtd6D8s7RdOsA==
X-Received: by 2002:a17:90b:3c07:b0:31f:20a:b54c with SMTP id 98e67ed59e1d1-31f5dca2727mr11106123a91.0.1753968195707;
        Thu, 31 Jul 2025 06:23:15 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3207eca6d3asm2002899a91.23.2025.07.31.06.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 06:23:15 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] mm/damon: update expired description of damos_action
Date: Thu, 31 Jul 2025 22:22:30 +0900
Message-ID: <20250731132230.80046-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1c9m7iydref6pketzdt6xit6k3bog93t
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FDBDC0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753968196-116107
X-HE-Meta: U2FsdGVkX1/WAY/6v8+4V8T3OLaAhhHEik6YHm+qDFG8K894mz08sAn/QWXxceqPCnBTTj4Fn+5bivOPveAGF+bV5lJUXRKkRwZZsegV11WlEz0oIqpITxCQWjOreGniwK3VpA9tr4496sp6/civLEybuUGACo8dIX7CVgTpt1tsNiubsUp5NaqDivB8e3JaMOYpnTbdftyQ/Pdkl1otl6RpzeH/EunYcFfCxJugnDUsP92Nt+k29OG7Z529gn6I5ff55HAVK3Uwqlw/tP1hjht9IHNz/uiAU/mfP+V1e4SQNYmY1xfgZca8eD9ifXz5QMFTjV+l/vJdHCPYjkQnvoYi73AupgJ1Yd9ElwS+WiHklWgctTkZe4oqPFJmuFlgVdxhVEeqyW3EVeD7Wtkgj7r9VdwRQoIpo2eAHdlvj7vV4GrZBidwL1vkYdN8sNZJ/6d2ntylp/fa188s7kQgnIbG2uHkuUUcwZCiXmOy9gSTroRaA76gO/dE1uzJw6qstlv/clEB7kN+gxLamSvGwPG3mbkZ1Csu7B1vfvmLbIQ81fs1nLP0Q3paz6NnC7WXw4fmtnhocsx8WTXTZwjZpbcN3KZaw16KCRTnpaVQHLQ/DsT/REQDoYHmEFfJZ7c71hT4DNaphostNY+Bibr6NFzkz+ZCzMABuFUnAP0qj/i/JLlUsqgIgcfvIYDG3TSDyHfJDFZ3e7MvGyVg9D2MEA3eR1ABlRcyt3FudYeyDFOnDuhTCOC8AcfbfLx4N0zbPcmL5FBOLt3yyZHeXpGgkrkjJyMY2a9faA+OEdhRda6BVk/pSI0FaXNoDYXVfXqqVMrywMkIg+0RUA8lYXFeVjjFOdJBrkUo/fjjcNOx+4Kfl1xEz3k7SoZDdYISMMrsZhFE6XW2l0fvyY4CI/8nqKPqQcqz92c3xjCxRGoc4syYQqPyGXVm16cPRHG5BGr/6lJBWhhlmzX0lsf/svC
 RdegKCHC
 mZ0t+M6+vymhn0pfBOJH6elW4oKhECDUC7XDrqe0UQr6p3o7+QwR8q0TDOkhoAGa+WtLZTj/gMSFZgDrr90hBCMjT9QEbkFzIan+nIhd430MrW9vs+LiGBIAj6lq8OtYpf/a+42FQuM+Y2i86N51/fT0fp26yUM5fjFBor6FcqrtJyeFhrWJe5/JDjCmvpb6PZDOxjfp9grDHTb54xk1qHlyIo0xO9xSWK4R93dOrJTP3X3pp2drvnXSQYOYd9jyCs+L/zMbxGEGZ5M6unZl3pwj79bvd5cReFmmH0IcNe5C8FqpTHR7FBAR7F41TR9D/kP0fd0wIFACTs+Wo4LwOHPGFrgpCTcx3XTevWrsinbnasnV6zGuvAwvKIUAkCF68as0dj3jcc8TVgw0jNmFjDjJnU27pMoyHmJRXPrN4RI1bIrq7S/mr0LKMSWwmeCh7GBIC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000010, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nowadays, damos operation actions support more various operation set.
But comments(also, generated documentation) doesn't updated.
So, fix the comments with current support status.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
I also found below patch(https://lore.kernel.org/damon/20250730200239.60984-1-sj@kernel.org/T/#t)
So, Is it means that DAMOS_STAT is only supported by paddr now?
If my understanding is correct, then we need to fix Design documentation
and comments both.

However, since it will be fixed soon. Keeping current status is also
affordable. So could you check this point as well? 

---

 include/linux/damon.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cddf82eaac4e..0870e9f48b0f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -128,7 +128,7 @@ struct damon_access_report {
  *
  * @DAMOS_WILLNEED:	Call ``madvise()`` for the region with MADV_WILLNEED.
  * @DAMOS_COLD:		Call ``madvise()`` for the region with MADV_COLD.
- * @DAMOS_PAGEOUT:	Call ``madvise()`` for the region with MADV_PAGEOUT.
+ * @DAMOS_PAGEOUT:	Reclaim the region.
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
@@ -146,8 +146,8 @@ struct damon_access_report {
  * The support of each action is up to running &struct damon_operations.
  * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
  * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
- * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
- * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
+ * supports all actions except &enum DAMOS_WILLNEED, &enum DAMOS_COLD,
+ * &enum DAMOS_HUGEPAGE, &enum DAMOS_NOHUGEPAGE.
  */
 enum damos_action {
 	DAMOS_WILLNEED,
-- 
2.43.0


