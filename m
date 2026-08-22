Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD15C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9DC6B00A0; Sat, 22 Aug 2026 09:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0693A6B00A1; Sat, 22 Aug 2026 09:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99636B00A2; Sat, 22 Aug 2026 09:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEE106B00A0
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 275BEA0173
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:11 +0000 (UTC)
X-FDA: 85129049502.25.1C20669
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id 607AF120003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N39mj8yp;
	spf=pass (imf29.hostedemail.com: domain of 3_6mJaggKCNQ0H31+68J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ardb.bounces.google.com designates 209.85.221.71 as permitted sender) smtp.mailfrom=3_6mJaggKCNQ0H31+68J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406849;
	b=uH1v34HUjZ9nFmz0KQGy+xlruLKV6OTaR+LJneaxADjq+hrhyKx0F8S+HvNjw+WZWd8RcI
	uAJi1aTrLBBmeeNUuZUAV8FwPdpMB7r8FRq4mvkZ8ScMa3qqxm2T2AoAsFy3TAIDUbaff+
	CcDHtQmPNHRvm5nQft0xY078Parfnpw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N39mj8yp;
	spf=pass (imf29.hostedemail.com: domain of 3_6mJaggKCNQ0H31+68J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ardb.bounces.google.com designates 209.85.221.71 as permitted sender) smtp.mailfrom=3_6mJaggKCNQ0H31+68J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3C1MhcgCYBzARL/+z1ptrjz40O26zol1QO0uE2euMIU=;
	b=6JZzmk6tZEU39yhLm7TUR9wU6JKhFoX9yhoGOKp09TVKCCIMkTSjrlWtr5shy27571ZpPP
	3v5N8V0cLJCzwO7IFNpgOFJzwglmxHOWqsGUPv6w7ZCml8N65E7rTe94ZhmtJ3kTmYTLgZ
	eewXSkj9v5fl5PizPyhPKnttI5SVouw=
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f83416551so1536550f8f.3
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406848; x=1788011648; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3C1MhcgCYBzARL/+z1ptrjz40O26zol1QO0uE2euMIU=;
        b=N39mj8ypDjcxV+5cQITgKmtBaPY3FSxdTeXtNnGwnjvN4dsdVYLDihQtZCO0RKluf4
         fjbKBn+lvjUhGgaqcaDb3lZ9MK8a6M3UKIMHFI81WRHswGX56VqoSpS0nBZXsy0BdjoK
         ePg8H2RJxYfwDf2aCgvtagVblXd2J2kurcRqzWxXxNt95SVOgLxFB8odE+KTZTmSStSR
         sxezw9uPZ1Wnj2vRYyXwoqWFntvpyr6mvgBqPu01Y7Ui92g+6cP/gFTvdGfsEOKQ0Jkq
         /F1XAMvuJ/+tcWsF7PjjkUI6SXTqCguMUhHq7JMv8pHtPTf0dXyJ6aGn2+ngBbMWt0Nl
         NDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406848; x=1788011648;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3C1MhcgCYBzARL/+z1ptrjz40O26zol1QO0uE2euMIU=;
        b=kTU/cliADGIHjUbWzSQ6OUyDshPzllbu7rjtT94Z5NdxDV9iqNptR90BskCi6B2i5T
         DDsJlqKLFU9oU7PRiEnZn8f/99+vPnbCzu6YphG5F07DvZjsey5IUe5CKv9Hqmt2+oUB
         H7eKKsRHojBgfhHavT5SKSI8cFCx9eNxxui+ckFqDkrmoHAAqTyhg35XMfoUgeDmYMTU
         pLIZt7hqd/T32PFYCDu42Twft6sR0WlTGhNkwx97H+3g8RGvBM9LKBwHs1oNJpbsABdv
         ody4d8DxSdGl8voTMDq+vr+O6YTuflhrw1+h0OgAMIJuPdGzF7mo2z1PGhdJXnlfRciN
         Z3qQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr3fTW1e3vc4E/ozhcckVDtSD7jYAnaeSVSxJz2biGfMbwUJzIk8szszot3hS84bkVEIYyijUVpbA==@kvack.org
X-Gm-Message-State: AFuF++ly+xIqzsPveeYPO+ZcRgW4QRtGexo5kf3xVY+N5wx3dPBNaHa3
	hhChCqIaBYC+3q9wW0Kt84Fy7RM6zoYKGHqi0ypVmwzcHu1zcPhObkiocfPDAOr1Rrvgftq+Sw=
	=
X-Received: from wrnk3.prod.google.com ([2002:adf:e8c3:0:b0:481:5a0f:19b5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:310f:b0:47f:7129:e30
 with SMTP id ffacd0b85a97d-482c0b976f1mr17563678f8f.11.1787406847588; Sat, 22
 Aug 2026 06:54:07 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:26 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2204; i=ardb@kernel.org;
 h=from:subject; bh=2CJ7XIW20mRvuSe13JPdhhevFvLjPgwtnqW6fGhR0pc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5c1bi+7sDNh4oOHy8XMHks1ZWx/c9LM5qpAednXj/
 pol76fv6ChlYRDjYpAVU2QRmP333c7TE6VqnWfJwsxhZQIZwsDFKQAT0dVjZGjsanuobS/bwOzn
 INDJt9ssjUtyEdfbFTGrcj54/RWdJsTw31v4rEPQ3sLVG+ati7dtnpxtEvm4wabQeZJex247NZX 3/AA=
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-15-ardb+git@google.com>
Subject: [RFC PATCH 4/9] module: Allocate MOD_INIT_TEXT from the MOD_TEXT ROX allocation
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 607AF120003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xpkp85tqyh1or7oinqqirr9iirrzzi8x
X-HE-Tag: 1787406849-465353
X-HE-Meta: U2FsdGVkX18Yp0AHk+/1hEdB/SvYllAsaMlgjltvAdiW5/qNxhqnphk9YZAUE68MuXDeUwyUmPueHWGejjk6nMRVtY1WbPowg0WY5qNIQ7dG6L6yvamkfNszibU7l96Q1KNnjpMf9AGFc/0y7pUKSXWOwcb9CwAdBV4tRn+2Zzq4xw0tBtiSXw2Bo3oDS0l1S2/ATCas7gwW86+YnEWSxMX8g2XHV4aQWKvcOyQdwSgfCklTn70mxpMNgICya5ifn9Q3AWmgDcx1HrwsX3slVdmAAvX7HfTGh86nwebmdnAts11f0mhap9qDQ83gl5AITOU1sdIFAv/RJiFGrEQNBrUIHDs7C8EzfDH4o6p1pAacDaQMGbcg6jlZDppugy9hyRZYEmjZ11329uu3Rew6GbN2q5CP46tGq7RBE+uPe8TRn95uhYBuUHSpGQxsmNe5RlHqSca3+f0hp6TGSV6F+yTcid17tucS9m6pGjQQ0+X3x9Dss/QX06hu5Lj9mRuna+xNHEz7BDwyiVpbMTALyF6RFnE3Wu7wTRcFGpGAhGJj+V0EzLbAUdM6v72xL4a/NuWHyd6BbxeX+92kUVuoXgUcjrkUD9fewNKVo5RF3ZAHwtWXab8qOjL2bY54uVU3UInQj+PoRa2IT6ZVEnRlGzdtXXwLOjHtXHG9irID1/X9YhV/hlrOJTTwyQV+VNWab4wyUi6WoJ1GFpCLCuzGcQsQhicd6fvOGQfNZ/XMNdmaDTSxcZzWz8OV9Dpdln+RLtsX/9j8q7jUlm28d5Ci1+7qgdFEodXFvCxCgQhm5K+ZXu9+jd72rfZ8CyANrnECHt3OkFF/SUOYN9mvYJ1BATJhcMOKXgLnMrc9TEoYloY/eOLFvp7gxnVf+s9/kC2RqMBdiwq7IEioa8rhTmWUmYENXfnJiAdyzHtX3WjVDw7rgyMrHS8KLq5gABk4r6uIN0YttTqjx2yhjGXrq/T
 sZerdoBf
 DpRTm+bcD4ijQ9RZONtS75NEO4Egim9s8uk+Hzl4MISuxps9G80Enge5+yBnWpdQF2WU55bssURV5G/R1HZO8VOuHZbmEduGQAsEwdOuTkdz+5Pf+Z0TVhhuZ8/yNmEBu8wg+/mSePAQOVftcbaU5U6fuk280ZQEWxnPAgDhMaf8OmQ9oJSNdRy5a6U26jy4hhyw5iN9RS5sdNCQs76SbbPJENWpmQ7kl7GBfmOlkhRvBjcY0AWsJ+XBNNLQD0K1q3Npd7r/BKovzfN10G69TTZPOb2rbk+x8nAIClikw49ABCj73KJhbLjmXngw3TQHBT8B8HQtNdIF/RisA0X9oEfKdm3ITy6WmfWRj0l9ruXgSOCwaxMi7dvvA6x4iVGH7KegU6uI4KDpl7IoQyIS0PjMfAA4s3tZeqAMFH4A76cLvHavpKjQRvldb9otoAroz2ra6f1vKagM8huR028t7rOY/kp79rrzWBaPRRfDJ6frDk8FZwmEwyG8OIdnJ1Gmwibm1Dz1CCeFJZCvdjnpmkurrakejDsUWsopNpLT+TD1BLURm5Ln3O/BYVDsHWMRIegkCG3Rd3LKo4sIdlql6964Ae/0B5GHxBcWsqh/nh++Lv02F+949bWWlkbEeRpUQ4iQcDHbHM3SYM6uVIg6jzjsM4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

When execmem ROX caches are used for module text and inittext, place
them adjacently in memory, by allocating space for both initially, and
splitting off the space for MOD_INIT_TEXT as needed.

This avoids the corner case on arm64, where .init.text being placed far
from .text results in a lot of complexity wrt indirect branches and PLTs
that we'd prefer to avoid.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 kernel/module/main.c | 22 ++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 46dd8d25a605..2d6213496359 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1342,7 +1342,7 @@ static int module_memory_alloc(struct module *mod, enum mod_mem_type type)
 {
 	unsigned int size = PAGE_ALIGN(mod->mem[type].size);
 	enum execmem_type execmem_type;
-	void *ptr;
+	void *ptr = NULL;
 
 	mod->mem[type].size = size;
 
@@ -1351,11 +1351,25 @@ static int module_memory_alloc(struct module *mod, enum mod_mem_type type)
 	else
 		execmem_type = EXECMEM_MODULE_TEXT;
 
-	ptr = execmem_alloc_rw(execmem_type, size);
+	bool is_rox = execmem_is_rox(execmem_type);
+	if (is_rox) {
+		/*
+		 * Special case for MOD_TEXT / MOD_INIT_TEXT: allocate the
+		 * latter by splitting off required space from the former
+		 * so that they are always placed close together.
+		 */
+		if (type == MOD_TEXT)
+			size += PAGE_ALIGN(mod->mem[MOD_INIT_TEXT].size);
+		else if (type == MOD_INIT_TEXT)
+			ptr = execmem_split(mod->mem[MOD_TEXT].base, size);
+	}
+
+	if (!ptr)
+		ptr = execmem_alloc_rw(execmem_type, size);
 	if (!ptr)
 		return -ENOMEM;
 
-	mod->mem[type].is_rox = execmem_is_rox(execmem_type);
+	mod->mem[type].is_rox = is_rox;
 
 	/*
 	 * The pointer to these blocks of memory are stored on the module
@@ -1368,7 +1382,7 @@ static int module_memory_alloc(struct module *mod, enum mod_mem_type type)
 	 * *do* eventually get freed, but let's just keep things simple
 	 * and avoid *any* false positives.
 	 */
-	if (!mod->mem[type].is_rox)
+	if (!is_rox)
 		kmemleak_not_leak(ptr);
 
 	memset(ptr, 0, size);
-- 
2.55.0.860.g4b6b3295ed-goog


