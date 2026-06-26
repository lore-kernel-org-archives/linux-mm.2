Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5987CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482D86B0096; Thu, 25 Jun 2026 21:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CEA6B0098; Thu, 25 Jun 2026 21:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ACF76B0099; Thu, 25 Jun 2026 21:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F17C26B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:55:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A47F1C249C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:55:03 +0000 (UTC)
X-FDA: 84920395686.29.63BF033
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94FA8100007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:55:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Luco0wu2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782438901;
	b=hwL5Pvo7tzbwZpgj0Rvw+h0qVpZu/f+7fV5wc8AVsL2oEFrJWl3Aol+b18JGrL/OzTiNYm
	HN7e4a0hSS/WH6oqY7YE7rbOp/rCALwhX4qMPzlOFIdPtaPNGZivE3hG+maOpuhUTZ2/d4
	ePMmTLp/ObZ0sMx+alFO108vzZX8xAQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782438901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWEXl9NbMqdp+ftym+wH6sIIxuIUc2F8kWOiv8tYd1k=;
	b=eCI4oYYHdqooISFt8fbiXZwIO+A8v9kF9QEzkjup+GKUBYsPqil19jm11rYnRffWGQDW9O
	jU53cucZQ217NpnhZfZi+GybuRrR9sfga5SC11ICzRN/qgEH2AvLIK8MSqmx91bHBTI5EG
	gcMKWeajpOJCuI6dKHZlF1ptZyYC51A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Luco0wu2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c6fcfcdb2bso4456915ad.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782438900; x=1783043700; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWEXl9NbMqdp+ftym+wH6sIIxuIUc2F8kWOiv8tYd1k=;
        b=Luco0wu2DDmozUo2H8yofVoryNzun2Me7EaesR+vMD04iqeZQU7UlJc+t31Z4XGMWi
         tor08W9Ogh1hkUSmZ46AUZChfUMalvGqVGb/R0MfbhJsAEVbPbyQRimyytcTIOj6wVdU
         +CkskfaaAloS0srhFPd/eG0l5gFHR3nhpQ8Bd1t38rkQ12KZSKHvA2StMjYcUHUZteUb
         BBr99D41XgX6Jjy/yHGylyVTBsp+KM1ON7N+F37Xvp1pR79nHovPd4tB1vipnptEbobu
         e4aDmH5fGO31yMKFprpLZJ6EcNZUFvxZr6ABDwLUmInOhlD1Ll6oXjizUFJKNiP9zev5
         7+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782438900; x=1783043700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bWEXl9NbMqdp+ftym+wH6sIIxuIUc2F8kWOiv8tYd1k=;
        b=hwPiDUbmnaQJsj00RytA8P92Fl9XOEJHRQDK4HgJPn36Z3ui6ypsS34AvQh82t4ZVt
         0C81yxH+jqBDfHAtpemRM/D3L6LHEAdwb6ILIOd4CoUf7vDsZ16SKac+Y9WdjIdG6qlS
         lTNv/KUPQzrMQtejsN/iGcWol/CAglwfSxqNqFvOdrggF6KYgXB10CoxA7j1yq0PxnVT
         TDdD8sBb5JWBXRDu+zcygBhK675yd83jwwV80zLNhVKbA7dDJNuwuNtiHP4/5mWCgQfb
         w18KanD9LAU76NxEuSprY/7atB3ki3LsroyGfegasa+L+F5W2hW+4xkacVIXe6ghldxi
         I1ow==
X-Forwarded-Encrypted: i=1; AHgh+RoYJMICehIE6Hlwldyi6lM6kTXRSuc1VvHoG+NbqPqhg01kpTSDQNvGFD58QG5qK7zWrudLuknG/Q==@kvack.org
X-Gm-Message-State: AOJu0Yyu31k8FxIil/03EGLDmIimz+gb9HLmG/AQRntk8p/w2BSKB1KW
	c/Ua5BX21L41a3xAdfnZ+Y55NOuxYC73Bd45TtIBHUUAoudWlIXdvNzK
X-Gm-Gg: AfdE7cmal3wUmK5jgi9luIQpbnbwaWhmbBbJ3+N4Mj0/9MWm7E2r/kFn3nu2QjuvEgS
	jT2q58bdidZ+3tFlNQI7JT6bDwcVGPQzU4mVyp2J2aEUY8YLbWDd1U7+73E2FyO0Unvw+obgrek
	pbAmzo62MnGqx9Xb4Q+3DlXdPswvfK0haSIyumsfpxPYtO+vLVkiEWrf3a+OejL5/ohfIoGMlX5
	Zq1Dbz0np1olspRt9KXGmaJgRU5uqZvk8cFUU1NjCKue2Duzetjibp1r1K38e0hXtfXdLhTIx3k
	+/oTah4VP3hYptKfwrqSQsnADk2jDhRPbGtn6l27jc4w+KP1VgwVVWjMDpjZyG9zegI+sq4NTcY
	wcS7r9zbFzGnf3WNCAStsuvtiZd0Zegx37x6IC0Fws0DD9CyC6mh7g4AmY27VF3pugmAMpDXI+o
	Jd/n3ZBqaqOuvdCjwD86U0Eq4Lu8A8
X-Received: by 2002:a17:903:384f:b0:2c1:e426:70f4 with SMTP id d9443c01a7336-2c7fc76f62emr47054585ad.23.1782438900610;
        Thu, 25 Jun 2026 18:55:00 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63b2bd7sm29047005ad.48.2026.06.25.18.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 18:55:00 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v6 4/4] mm/zsmalloc: document free_zspage helper variants
Date: Fri, 26 Jun 2026 09:50:03 +0800
Message-Id: <20260626015003.2965881-5-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260626015003.2965881-1-haowenchao22@gmail.com>
References: <20260626015003.2965881-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 94FA8100007
X-Stat-Signature: pus4q9ng9brt81e8y8jpotmwyyoyiekt
X-HE-Tag: 1782438901-275370
X-HE-Meta: U2FsdGVkX1+Dev3nF7jqEIi1tJ6DKPdE6Mq9UwVc6CSs3/7RA/1iQTuI9oyql2kzpyYzqLm46/NSiVbwP0rfNOtt+ppVysrUvwSVtOK6PYtpVoXeObrgrtPSFPKkudS6Nm3borA1RCn76kvDUadiHN6BcR+1PZdFFpQWNtJCpqzGgzh3gs3gPV+34f2CO+S6ADxpGcpLGEUk6FDcgsmOgC2/j9diMBs03p2STszEaUgx/8PbteQZiIkuIPr2WjdZCA0vw/vjAS+xtuVYvuRDKty8gbSt/rmAcIcKGSQQNZ8hArMCxiFvR8KLx1+iAp3CvabfAXvllm/ECoWGMPdsBQkNI2HHYbyjsje5ZZk8w6nmjtFNqJcFhDen739X75yPr4BbX7NHtOvv+OPE273eyCSaROVGbR/wcTy9ihyKSKNu6f/bNjacGYK/MgzHsfBQBnWYsuj9ibdOOxsdh3pHMtpMdSw99Jx3TbgdeKbm5BUa5HHqPoAALlksoON+3conaEA8CuMlQgao6o+3My4fHaVp25bVny1ITx3AmFHAtbuAXs0daqpM85nz4biNWuJgk1lbY7lSp/mFkvF7jRd0Opr+aMLqOvg6yLu9MAZ27TZstJhZxQHy3lecihQy7xLGqQAefMQwuyzg1VbpBhdPBtLBAy1oGPpuZWQXZJHIau7tdelEpvdGoW7b9u4XuXxWibKsvfGxc3HuSup4TWPDLx69dC+GPmR9KLJ+T8Kns8NkjSjMa/G+Xeds2FGCz3y9a3aXfa2xkvP6FL6xQS7pzceSTwEBza4S0VmLP144SIyxmolTGONjuyF6kdBNrwHJcwvlV7FgdYtDKyJgeUaxD5leCeQKvp/8ziPXWQ38lg76cQWbzZqJl+PZAC2LCC8ttzdkUshEkTNh0CR/NqoKnwQmMP+LVgpuH2SD2eRNUsXrPwq+lDyJs3/S/RI6axae2Za69LAB8kFpIKSw/5l
 8aws7b1J
 4tXlcsLZ+qi+wf8Paz2oX0RR/wDV88YPRt+HhYtB4TZBVmuwSzfTmUT68HKrnx64YRgnEOAj+lrB9FHjZAUUChqIcPDabmRpAU7/ByfH/XnRvO28FkFa15altbLSbfeCf8LRO2Q1ccB0r0fADaWAat0kBY5O/F6X8tEJuw3rA5In7QFMouLk4hKJ7/6QI7netHBCfljdqFI+c+tQHacq9n27+S/kFVw9eH8AsGokIH05z0DtDkf0FOWLE0xODfMd5n+LAhwNxMIJm8zdG4eDAJU5nkhHUtG0sjH1evD63SWuJcZVqnIOuLw9k2OjMY9s2DDPwTg+6+/cTZI/ZHf4gboA4lnGFdHUdhRbdHq5Wbk78pEIY+gUw297DEQen/DG1kXohzytK1e69JHpdllI78T5wJYZaCMel3valiLIteMJ29rWJqreP+ydCu6tXBvM+zOOvrMbK/sQrL5BNB/d9WqAMqdVogfAVeXv6xEeNbOBkXxdJxNq44sPb/ingqwkFQbA8aLoDzBtH4as+fql7RG9e1U7BqbQ6QHdx9od5/UTot9sSUQxiQX+mFH/ax76t+70nRQvq6Rev9oM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

After splitting __free_zspage() into a lockless core and a wrapper that
does the class-stat bookkeeping, three similarly-named helpers coexist:
free_zspage / __free_zspage / __free_zspage_lockless.

Add a comment block above them describing what each does and where it
is used, so the names are not easy to confuse.

No functional change.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f3045345e3a8..bf74e695d977 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -884,6 +884,22 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
+/*
+ * Three free helpers, kept apart here:
+ *
+ * __free_zspage_lockless(): bare core; walks zpdescs and returns pages
+ *   to the buddy allocator.  Caller owns all zpdesc locks and has
+ *   removed the zspage from its class list.  Used by zs_free() outside
+ *   class->lock so the buddy-side work does not stall the class.
+ *
+ * __free_zspage(): __free_zspage_lockless() + per-class accounting,
+ *   under class->lock.  Used by async_free_zspage(), the worker for
+ *   zspages whose trylock_zspage() failed.
+ *
+ * free_zspage(): full wrapper - trylock zpdescs, remove from class
+ *   list, call __free_zspage(); kicks deferred free on contention.
+ *   Used by compaction.
+ */
 static inline void __free_zspage_lockless(struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
-- 
2.34.1


