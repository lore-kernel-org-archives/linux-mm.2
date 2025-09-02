Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01768CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453C58E0009; Tue,  2 Sep 2025 13:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4045B8E0001; Tue,  2 Sep 2025 13:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F36D8E0009; Tue,  2 Sep 2025 13:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4AA8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:59:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B81981DD577
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:59:37 +0000 (UTC)
X-FDA: 83845072794.03.4822D07
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 27BB720005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:59:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fdFx/0oB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756835976; a=rsa-sha256;
	cv=none;
	b=AJZfR5BAGxbkAhcGt/nUdNg7Gefu8THUj47ZW8ky4Kbzmyke8Ya5pok+Nlzg8Uz92y+Aam
	EmJCUGdieRXel6glonMCoJBIlEaQHkLkifZ7wMlKuuuffRpxigMGkBdOe6XDErhWaixUYj
	rJDUwsd8UIyccIaw56Wy4cfx+cOp4Zc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fdFx/0oB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756835976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xAH4RbURzzHRpIvpNMqt11PG9TMIAwCZWf6ncjCc04w=;
	b=kCGFGRlpiPFRUvU1aSzCpRSfmsRlSvubekfeQaAiYqsySKprFiiHF2dW/s80O5JeYvt1s3
	mYB1N3Ua0gY8KMHMIsSks8gE/9G17eZCr1pmDvOUC04ovyx++v/iNJgJNTKIDolp/uGqfr
	Pn6xxdovjkRb5rKkbE/DKzcf4IheZqc=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-248df8d82e2so47418105ad.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 10:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756835974; x=1757440774; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xAH4RbURzzHRpIvpNMqt11PG9TMIAwCZWf6ncjCc04w=;
        b=fdFx/0oBzDDmqRqmuM2t3BRL/GhujCCODyk4PNCGa9d9BODgDug7YiEJ4nDwJ3WAgL
         wBra3Z0GVkX81zwkGTsCZNGnfXaB5U1d/JkdKfGDutIJVFW4jaVCFBi3JxdOkVY/uP2C
         ijLM6djrCiejJoqkPCpj4vKa6SLOmoPdi47cQa6tthOXfd00ID1d4H3eqCQTZ6EPTF9b
         9/RMo60o97SG50U65ovi4Na26TRbUtzF0mtt8DPT6DBk8tO7JfftEvca3iY082wZul5u
         gDMxQzFGpgVzbkyap581jaZfWWU1eKyKogVNcONJFnTo3B5tUBPHX/zeAAYBql/t/Kud
         j1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756835974; x=1757440774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xAH4RbURzzHRpIvpNMqt11PG9TMIAwCZWf6ncjCc04w=;
        b=IXVpDSuTMIE40T7d+1YgVYSWMekFnIt6Qj/hPhIy20qxsx2NBCuf7ecXG1vu4egoo4
         vHZwpRGQGEfbomGGlBlzESJGqGcsJb5y0X5xok4GNQTjbGq9vrn5to8Och3Q1aLnAfl9
         uC/+sutYhy3SL1mvUfIWp4qut1LwNIo300GkUgtHjvfnwd+gD3pszXWEWP8+BFdOZnum
         lwEQho7aWLtKFcOSaqYEUdTM9xPh9W8nvWF0JilIcz8Ef1P2CkQzdJ9mxQXTCyGGMnWu
         TSx4zqEJchRAzzJxy1NtIUQo7YH2xlFhq7SZg4fjHB9ydfY/923/ln3tn3BCNL1TNJNh
         yH3w==
X-Gm-Message-State: AOJu0YwKxvEoDaAKpI8W3Se+8/+zE3jnBzTRh8bS25c1SOU5e8unMxCc
	odKFzShol5ucJqrbowmXBB9SnPgob4Dk7lWwMcbsi3RkTzssaHT5aQ+425Uv5Q==
X-Gm-Gg: ASbGncsVCfMllxeYkmGkeeSE/AENOj5tz0PJbD9Qy72xpyfSf3JJ0BkJOmljnED4rIO
	8YBPOu02wGNLoOvRw2H+J0xFMAJVFw3BXbVXAw/pNpgN8QYt//hDrchkt+T3V5GWwWfxL9QAKmg
	wldTMReCV3ufC8ijMaZIr5rChYOgjGAi5rsOQiWWJqQEOmvgVGeAArDs1BF7V3UCOr/kkd6eLyL
	SAEEfiXeqQnw0U9/hiKPNYADfJxnocdByGnz8F/EY1Rmh+S1r6dmea47Z0FUyWFbiMr7m+PZvdO
	ysfFpCOD1yyCP3ZMGGwm60OkEoYmbvxPPz/se1bbP469vEBttSiI1TwGrst7RzbFNiMd4BYhCTZ
	Xdz1ZzHoqS2NdqUMMj8w0c4juLwP+eX8UC1b2pXqaKun69qXgl60qHwKIrgGkV30G
X-Google-Smtp-Source: AGHT+IE69QSW4qvs9ks5N2BD/7L6YYxrDKxFR+dkOnLAl+rVNC07mTwlZHlby7K2v2qk1lnap3nZ0A==
X-Received: by 2002:a17:903:2412:b0:249:c2ee:af2a with SMTP id d9443c01a7336-249c2eeb25fmr158523805ad.11.1756835974450;
        Tue, 02 Sep 2025 10:59:34 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-24a92f89809sm98463435ad.2.2025.09.02.10.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 10:59:33 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kees Cook <kees@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] mm: Fix kernel stack tagging for certain configs
Date: Tue,  2 Sep 2025 10:59:03 -0700
Message-ID: <20250902175903.1124555-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27BB720005
X-Stat-Signature: thdaw54tz5k4r5uh93zts5nz31t39p5s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756835975-226637
X-HE-Meta: U2FsdGVkX1+7T+TaGBKnhe5nOu7xJwuUjZPOS0Vd76XxKYiaiRPDh1dOsBDLIoixfBt2sfm2Yk8c0CWH1OghoRib8DPVrPPXuvTvvJY6Gfamw3FvMROZNQqtPS/PPvPHPLL/13dChQ9wUdzxYshIz6ysW5ICI7tTIyaih8g0E0gDtMgR2hNrKMYM9KYwTIUoaFw795n8UIcNr7SQfMKgZ5oKJLiHDSOEiLB62DPTv9tTYQ7reN3GjAp4gmB8o92CZ/w5yI/HAlqU7hQGpEHR9BE/PVsc5KTUyI7H6JBGooo3RCZR93PrsN7uVwe6kXTaxZuq7AZYEpiwvIJT1+TjGf50EO6ZlrZSymNc2RGZu7cOPENp3zQ4s90r33Wl3lnoy9BmrJBsjhxPOx6n+Wne8KHbM+xKNt+nzAsqcbREcTlL86z/usIP1RLIYK3xpHbTs86CAhzISKsqCG1QMtZQJyl1kSmbSA90So47Qayqsmdv8Pje8agMMPxZMgbYBR99OJTkRZWu2P2TPt62N39VWk4Sw+n2BL0eF4FYNhpyf9Z3hs7b8WRdZOq9cCmoHLpgFeOgn/yN1lkGIAx9tjNxYAG2rCPECGXyKR3q8yeGUjl9CkEb1LMqiG4ts6efjT4N8VjtTZc/0Eb19XCIEbW5YRRThOTP7fgcNayoOwWCf0SLFAihlrElIbxEHeG05LBNA81kj25wRxe1MnRYsHm7an3D1HewkcolVFHDCOqxzxhdBH2wKnnFLsC3Xd2nYzNa/nmyINOvpnOsYGAspg3I2Jr3x8/DU3hO18b0APxOeip8wbc06DsX95RizCyqdb8yOGEyhQgtMmN/KBptza5r9KrRrKDsWttyygIjy7YM+VQzVjIq9kWykBdzB/wY0ocNSLTa7Rk0BrqFgoVtrUpAtVQ8lAIVKAk4xQagjeHG9oz1TNP7wzyKtZAHTf3ar1RqHaMfPHnpRabY04xGUMM
 6TD9FQuA
 d0XAYba+JYg9CuQE7njKz9HfsaOowUzsNc6eVUWDnlyrSSVWz1Y35zqz+DYWNBOHA+YtUcRTXEfNmBJZ9xM9q6K1KbGTrg4P/fXEYWOJoV4eCE/3aYpyl2qm/FdrLWMsr7NiQH0zRPQPUVHJsfoGyO1uGEsSA7CizW1qtFF/Tdak5dfcaNk/pRg4J7joJlBAlJDak
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4ef905bda61f ("mm: tag kernel stack pages") began marking pages
that were being used for the kernel stack.

There are 3 cases where kernel pages are allocated for kernel stacks:
CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
respectively.

In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
than 0, and pages are tagged as expected. In the third case,
THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
This meant that in those configs, the stack tagging was a no-op, and led
to smatch build warnings.

We definitely have at least 1 page we want tagged at this point, so fix
it by using a do {} while loop instead of a for loop.

Fixes: 4ef905bda61f ("mm: tag kernel stack pages")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202508300929.TrRovUMu-lkp@intel.com/
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 kernel/fork.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1b394426ab4a..9b13cb83e1c6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -448,14 +448,15 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 	} else {
 		void *stack = task_stack_page(tsk);
 		struct page *page = virt_to_head_page(stack);
-		int i;
+		int i = 0;
 
 		/* All stack pages are in the same node. */
 		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
 				      account * (THREAD_SIZE / 1024));
 
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
-			__SetPageStack(page);
+		do {
+			__SetPageStack(page++);
+		} while (++i < THREAD_SIZE / PAGE_SIZE);
 	}
 }
 
@@ -474,10 +475,11 @@ void exit_task_stack_account(struct task_struct *tsk)
 		}
 	} else {
 		struct page *page = virt_to_head_page(task_stack_page(tsk));
-		int i;
+		int i = 0;
 
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
-			__ClearPageStack(page);
+		do {
+			__ClearPageStack(page++);
+		} while (++i < THREAD_SIZE / PAGE_SIZE);
 	}
 }
 
-- 
2.51.0


