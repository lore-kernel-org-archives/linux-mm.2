Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA45CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8866B00B8; Fri, 29 May 2026 11:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40556B00BA; Fri, 29 May 2026 11:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08276B00B9; Fri, 29 May 2026 11:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CCDA6B00B7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FC73C076D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:22 +0000 (UTC)
X-FDA: 84820773324.03.4AA2A11
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id EFDAE100018
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=borVo+NB;
	spf=pass (imf14.hostedemail.com: domain of 3eqoZaggKCI0r8us+xzAx55x2v.t532z4BE-331Crt1.58x@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3eqoZaggKCI0r8us+xzAx55x2v.t532z4BE-331Crt1.58x@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADUQ++mlFIW7e7IV4zrfNK16oe25OrryHFNLylPLx9Q=;
	b=Lc1bs/p7SJekisI9ScaB5ltSvxDCYwt3y0qxs0QzIPcnYElUbOCVqolA9ew8yZk9sFyT/d
	7IMN6tepwSvHmKpgxE8ZnTHbJIOuW0vZl5hVNU9Yn2uytYI2eZiBEzk8KrzrbkCCXahAke
	JkVbGLdi2+czOHcnL9SGCveWCSSH+BI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=borVo+NB;
	spf=pass (imf14.hostedemail.com: domain of 3eqoZaggKCI0r8us+xzAx55x2v.t532z4BE-331Crt1.58x@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3eqoZaggKCI0r8us+xzAx55x2v.t532z4BE-331Crt1.58x@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066940; a=rsa-sha256;
	cv=none;
	b=Z7FdlJwLl3eNgbAPEchF2ViPGIhnouaNMFf6UfnthpRg0/GhIfJ8zV+ChRmDHfkgPMUKKI
	AxbNZXxDc5RbWQKF7R4RvSi9hgjbUEnUlPZUddW7DFr79HhoFky79ZDe/ktasJgXVFGSIo
	0xCk/CGuFvEvnxQvSztPVxa/vm4qq9A=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45ea38c03a1so7499573f8f.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066938; x=1780671738; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ADUQ++mlFIW7e7IV4zrfNK16oe25OrryHFNLylPLx9Q=;
        b=borVo+NBslsl14Cc1QWa+tAdXucSBjYkcsV9t6+RX3jDDLXT7xytdrDRKUqimrx6/G
         9Jsi5aIaYWoRQCKvtJP0gm3rRCm+tHMvc+hL3JIiW5vEBBvhDVyG/G4EmVSj4rJ36Ufu
         U3zU5n9oqiL/tXS49PlPFD1xx/sDXKW5RZgbmJlGp6ZctnnBUuXBxkT2AYbmpU4SAbDR
         jAXC2G0hiEh+vDdUexjQiIZNDbdTjpbQG/ly0FlPN8Xy9ma9iV6zCGB9utTvNzsWaopi
         Pj87TRglGOCjIgwnssjEy7jXyFf+QSuJBd06NyOJXWT1Nq/mC+PaBFlDqM8yyYWZsypZ
         EnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066938; x=1780671738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ADUQ++mlFIW7e7IV4zrfNK16oe25OrryHFNLylPLx9Q=;
        b=mocvtYcatevjKnmQlJeuPmpyCCPUMUYyfmRNn4lA7FcVpp2rqSMbY1B6/Sa2+xeSsk
         FHtxkHJODlhQEZTi9iXdjJetAqiULgKminx80esPbyyPsGD39ZJrToc7GV9xsOIvNW5A
         CNjD2PzeDXCbsVbW3WuNaUudzrNMKFVT1u6NqtMVSZFJA97bv4wCjYvTfvhwdMJKeZSG
         p0ezjh8lzBShwoalkkiHZH8ZBWw4PixJZBd6FukWSi22ejVxc60mwDUcNjG/+FfdIL29
         hfTE7ch8nv+CcBEr3GBqJx9Ly1F+QOcouEDJ9fitllapGABC904IwPZFdfHqXW5VHz2j
         TSFw==
X-Forwarded-Encrypted: i=1; AFNElJ962SW43BfLk3CzSCFXF6Ddxxx3UufbjFjzadwJMUKk9+G90e8wduTVoSWv73SLXFm/KwI3s50zFQ==@kvack.org
X-Gm-Message-State: AOJu0Yxak6ZDFA3iAIgH8/79NBfV/H8vIgTypBEP5H4lHidIxj5xnYTi
	LEd2ghbs9hd+0/0mUD5lKDkIU1LVvJU/0YhW0AXw4LIflGxGa+6AwhALjGPyY3X66cKXDJr6GA=
	=
X-Received: from wmco20.prod.google.com ([2002:a05:600c:a314:b0:48e:9137:b54d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4616:b0:490:8470:31f7
 with SMTP id 5b1f17b1804b1-4909c0b0175mr35812255e9.20.1780066938306; Fri, 29
 May 2026 08:02:18 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:52 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1021; i=ardb@kernel.org;
 h=from:subject; bh=xJBQ0hvsJWcxX3OF+aBCCahIM1cYmsTmsethYm+trqI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVcJX97Dz7W+MMlK2LNwkUx18YdWxeHbuRF3RixVzy
 2VZWh91lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIncsWH4K15aydfEzd4bZFBo
 IRJ1wOPhL4sFl+slZr0uKIyeuuzbIoZ/xqFpXiaXjdJOHT9lXb/2g8g/3TdHPNLmFe0v7lp74/s mHgA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-18-ardb+git@google.com>
Subject: [PATCH v7 01/15] arm64: mm: Remove bogus stop condition from
 map_mem() loop
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: zc3tbtzhmiew7dbdgpwf45u6gaijt1ko
X-Rspam-User: 
X-Rspamd-Queue-Id: EFDAE100018
X-HE-Tag: 1780066939-28103
X-HE-Meta: U2FsdGVkX1/AtzNiJnQBsbz3qC7MPt0tX64KtSNs2zfCaiFI3DNtYT86z8edAmZTHNcOKw7sDYf+PClL9W3AcDlrai5SFSeVRsAVCwOEU6yU5Ys6Mr7+0fzNLJXNe7O7UYl265QARfwQ7nlfTHZWiZoMZvjKRk0Kz9X+mgvFDGx5t99BPtB46+vThF3ujgT7tz3OjqEFpAAVFqMUSSjci5/KHf9nL8oJZ0WUo8q6kgWWq6qjp/jBTvwmG5In58bzxx9KxcrcLVMDYIsnbk8MQcb0Jao4Xn6DVQZor/92HvxprvejhHFy3nRiY9xSI7FeAboFdTQLn2BwKSkqm4xn+KgMLGaCEdJXRwX3I5KUl9h9GR1TEtv0S70DxJFkB0xTAvVe7X/bI+oDL3cymTnJG0paC0DsywCo5SENqqjvCRXAeTkV4mwZVlcnhvB4ZELwSeTXbx7WbkCw6MvcSHQ+MAcaoOE8ZIjh10h6XeruaGqllZkjnFVe9AUBzLjseCapBuE4GUB3yzOxX+WKA+ezRTxUyyugxqohQdkIqSYBu/wm4kvfIKIsemfnI2BlA6C9KoLY1Z6aTTNGs5DmvOJmB1pAtGZ5lMI+qfm6SbNTJ7IlGyn1PVLcCJXUsSTPTz5bejloP/HxyazmbFI5vFu0xNPQblFI+G8Xvtsy4/kkgXqGEFJ2pnDbbYj/sYxB1M9gjBQe3t0Tl0hIHKP3QhkD9NyX1LTdQm1/haIbS7zkUr2PAucmNM2P7j2Yj/CNHRAUZB6mUNs1Ihn7SLpZqssMUTBeS4JOlR/MQfqMTeIfC03QQsU8CMPP0Qkh56qMhA95t/e48fKZFt0Ffbj3MxRmhjYtAAd6YFwY2L3QWvhmiWcG2Mv2DNPO1Gi9jdwC7gq9uu2+TZ3oIBlTYdHwIDKCVEYc9vBmd/WhKezCoqI+6oO/2N4NdlqlyNXYs32VjV/GdF0iIQUfEecdR8ymggE
 HgknN9En
 jQk0EL12gRHQ4i0UzBPXmlX6AbS8tnOgCco2PR9xM7ecsyS3kFkCM5eFFmjyURdu+WSfK1Z0ae9Oem0/X05OfZ3AyZ7cmGKiXVbvLaj5fVSSx6H99IO6oUj2+cj3TBjHzSHwJMslfQUfVlMd0bjAAPsUo3O1uztZyiIBUmAB/Ptb2pvwWPUoNgDz0xpgV2+8MQlrRRwH5b4FZ26+surLAU73LlxS/lJWtVI92vBmFKHJhil3aPnI22DL5Q3ES18yZHokN5xn99XmqW52jPLh7T/aWTJ0wLMYW/4NFDLHVBBNUg6XySGkLHis83x+H3euAxDJ7SLlU4/D+ZVhMEOplStqTQQ9vmu5/EhEVb1kQJLaOf3is960DbMSEIg+/9AeF2C/ouIJT+eWFV4AcdmYqNF7KLixKcFTTBNG3n+jYgTyfQnMlIpZ1fsd0FtBKmaRTbnfVV6t6fwEpJgKo25hfnxcQqTvY1A1jSizi9zUc53/EoH8uqA88qDUr9tJ8Cc+nVjDDgn74PE1K69JyQb0OY3+I8oo81HS/xaZ6dx89GBBmxCoql7eRSQSGzT9zieyWV+LAm+iEGwn5xofP6JaUHf390hnxL5r0gZHwm+HWovp2QuhEcQxPkup4IeBM7TCv0eUN1Ly70h0eJ8tXmC2luo/xKtS4ZVff1f4fMjDuvJF9KnNDdOiDAIWJ+hQMVi+c7iRmJrlWuKH3FN0qHzyblW67gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The memblock API guarantees that start is not greater than or equal to
end, so there is no need to test it. And if it were, it is doubtful that
breaking out of the loop would be a reasonable course of action here
(rather than attempting to map the remaining regions)

So let's drop this check.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..112fa4a3b0eb 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1173,8 +1173,6 @@ static void __init map_mem(pgd_t *pgdp)
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
-		if (start >= end)
-			break;
 		/*
 		 * The linear map must allow allocation tags reading/writing
 		 * if MTE is present. Otherwise, it has the same attributes as
-- 
2.54.0.823.g6e5bcc1fc9-goog


