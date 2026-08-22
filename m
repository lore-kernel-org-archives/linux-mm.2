Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253C1C5DF9C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF2B6B009F; Sat, 22 Aug 2026 09:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C536B00A0; Sat, 22 Aug 2026 09:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF326B00A1; Sat, 22 Aug 2026 09:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3F486B009F
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01B8F80146
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:09 +0000 (UTC)
X-FDA: 85129049460.11.20A6100
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3728680002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=W1Ogbq1K;
	spf=pass (imf02.hostedemail.com: domain of 3_qmJaggKCNMzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3_qmJaggKCNMzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ei9aAhCyyRq9nczFsrb/oQ6US+9hvk5Rs5Wuqs8mBgQ=;
	b=Zcjpfz5EKddvbbrC/suG7fwxIdIeu4TFPkpT7HFKPeOvVD1kwU7cFRRb3nIieXIXksBQc6
	4+jo9YbWRzdyHkwrszwVC/rxfe1wJh5+XuZkTYk8DV2Zb9S2bvrJ8ZTc/G8VGMiwyt3ReI
	2/39ZX92Hmnmc8gGIf+Hfdnd/hIx8SY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406848;
	b=8M82mhjqUSzINc9BfmjOdml92i1OKeBIzTLZj2fEzo3bits2Irt0l6+UK260LAvzisU6qv
	9b8cWVA4fiLHHVuii0/BlTVfRjlEDTYzQWM9nn4EqqRCTRrpfkkeQJEUM+zqDe09RgbGrq
	/WVXtW0yy5clUB3t/KZH9u9PG9WjUHc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=W1Ogbq1K;
	spf=pass (imf02.hostedemail.com: domain of 3_qmJaggKCNMzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3_qmJaggKCNMzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4955843c6cdso15912065e9.1
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406847; x=1788011647; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ei9aAhCyyRq9nczFsrb/oQ6US+9hvk5Rs5Wuqs8mBgQ=;
        b=W1Ogbq1KWo4V5ZOoaAxZjd+iUBcOPuf8LnX1haG4JtSovIq666yEhVIEtrIGqRPfES
         kFCX5fVlJ8YOI7XF1HMCCBGoE1hMg3vPU5lALb+oNWmB50miBlC3YmQCGoDxrT21Pl9q
         hsPupGW/nmIc6VrXkFfbgyhsNgal/IRLqG9fbRgfcklokLXwpHhW6C1ePj/YXU1zkHSK
         xqDyhizXZC+ei7yvbzTaEjuKgJE23xyvoCxizRXrtwZXfrbI/YmKVR4+eD9k5XRAjtwR
         IyvHERAc0SQmtjVC5AoWDxtXJjuF2OwuBSTAk/Ew+GaAiWw5d3bNx8ko/e9+S1TI+93m
         76hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406847; x=1788011647;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ei9aAhCyyRq9nczFsrb/oQ6US+9hvk5Rs5Wuqs8mBgQ=;
        b=DAqiGJtc2FNXJLumZ2vLznNirBNEnXMVXHTv630B2HHAZj7tPe3vH1jn1rLVMuZ9jt
         ciftTBjv2ZHiix95HmT9x4y9StmhhYMZ/fl/gh7jP2vCcggJlnHf6xR94j9qbLgYRDop
         F+x3pSKnOCKo0b9MT26HlojIJZks1HGAJQvjGItJctz7XvWD1bewNuN4C3sHBbzHygMg
         RZomm2E6+odeKEr7KSMdqMjkvznDsh/4XXiYnq/b0RvXDUk0ZgTKJvQMgXGOYGsC9K5G
         5tS5DjokbPUIKoVkAGsbUV6rciba/uw8EieS2PdlM0hKO2UEa4QWjeSgQJS0Bxu62sXs
         3xfA==
X-Forwarded-Encrypted: i=1; AHgh+RoSyUpd4LVcTnjEddgedgZMo/YW8bXCuLdqyCXUM7ppGcggcjQfzFmmez5ShSwP3CFHoF264WEHVg==@kvack.org
X-Gm-Message-State: AFuF++l9sOjwKs/aLF/9ckMoNjzUH06K5sEB0RUuuLh2b+ebekiHiQDd
	2m2mjkHDNESBAbgnlb1q2/1CttKqLUp5Y+YmypdU7GxCDO2OBszkL8c2K9Pgpy57NBi5e5ayOQ=
	=
X-Received: from wmcu3.prod.google.com ([2002:a7b:c043:0:b0:499:8f0d:36d6])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b77:b0:499:48bb:417e
 with SMTP id 5b1f17b1804b1-499b82f4163mr187118595e9.2.1787406846628; Sat, 22
 Aug 2026 06:54:06 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:25 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1141; i=ardb@kernel.org;
 h=from:subject; bh=LLSSaN9rhZ2F3aT4P4AsB5UNc3JBgAb9PUajizskM3Y=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5Y0AZ4svS9ISbTaf6Vvbffb640AuEdFH514lyFxeu
 vB339++jlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCREiuG3+xHy5/ozft6vo39
 a++HnWc27J26lnlODVv1x/cTz/MfferGyHBrod6fpd6OR87MNvD91aMtcLL+0Su90/UXLE4ohsc 1yXMBAA==
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-14-ardb+git@google.com>
Subject: [RFC PATCH 3/9] module: Place MOD_TEXT before MOD_INIT_TEXT in enumeration
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
X-Rspam-User: 
X-Stat-Signature: 3b1x38kf53kondoo4ou67xh41rqcnb78
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3728680002
X-HE-Tag: 1787406848-372659
X-HE-Meta: U2FsdGVkX18sPsymVE1jExJ4kwRUVk8SVE7lhGhupUxbhL4IDyrKmJtiN84lbdONd4IR+TqFyix2CJGPH21HDAVfQ125G8xJHdLHz5oAAcOYohKtrfFOOSx4RAvN1kNGYXUCLfQp+IlINFTtiXu8tpSoGP5L+g0iSkIEFHBiPrdf4JFwx95g2ewh2nY/Wry8kgTHgBnEG73SMe3vRI59cpQro6AqbDPBHy2HyYI8gvpwjY7eal77X+vnNrwbXF0awq/s8um3Frie5RXe0IliaT62bJQwPYaXxMpCTujAfzeZuh3a0bRAqlhO5mrMZ/dJQjBHGydyt8Wt3+zXeept34r7ncTC1/QsEL1oTPOoPUStlcd6zmve7T5/SJnVK6qUMP7S60SMRhe8DlmUG3HC5XRKxHbcuMYtEnGeHZRVq0ws3nI7GbNy2RRbPoUUJy1Ku9rH2mu/nWhE7idUYPeLYC2GeBT8jwbRQ49ZJ4WJT8iDp21XJ98LQ1eqltxIN17FvaVGx8RqnFgbWEOgnT7gGlyrKDXib/3FJTb3qFXhBxg+6k8ABy/x64V46HsA9R9cLdU8Tbh//5qtomA/0Rl1hofI+8zInH+3ElbADLePZkQRm1ur4Qk5y8tqCQ0oMPIbF6imwCVqxyu3BqEQUvxoFjCzMVbLbf8tHB0MC5qkoDDXpllVPmKv/aOqmc+VQz9cAA5Zuopr4IP/TuGIumIn/7wu26Ful6xiNUVZQvSzTj+LVW+tVqp7IGkohIucl5tukK6MTL63W/fjqxNX4lbnHsN6lXpeuEMN6smBIvMfeTMgAComRqzs0ahefb9a8WgK0og+zjgMAe0pekHmbsJ3oRxL6K8jZR6j1/0Jfr1ZFEM1ahtUJdSui0agyH/oz2xB7VPyK4jPU66iqZwyObkml6m86KU/0gqrz4ttDP3j50O7eLez1FQdXW3NzV3k71lht1eeLjtOVAE86CRAijx
 vrGJFc7Z
 RjJ5a7nNqvQxz1ZboE+ooUwpz+oJiZgGr96uGYSoqdDwU1TgGbnjV6dtql6Q06bgO7s5FJ+oYnw7C4iL697A0Dv415ZS4j1HUGpzhSFGm6XcmxiPKCADQbC6VnQO1GwKuZjAZFwye3jCuOOBRRwf7dARvyW+mdzO0U8jr6tRZYCE46DrdoOddaUD52raTs3nWM3+dGCjMB+e2SpGMReAEaDs5RiHO2hdmTGoncDwTySjXIi00sPA3mpK7DtPhFjybL3TMQD6wBUFSi4rid0OJo1PediQRRp0jTJsQk9GX6D5aJoRpdFrUXeuoS+1+zBd9NQnHdRru13bAAQ8f+Uxzikl9ZACFqrvI1mERVjvwBkIfso55biojXfM1M8f2EZNPKOTQSG6o1gbc1LaqeE/1tS61l3kj3UJ328xgsw7rj7t3LqctauMwvcnVIvoanfCMBp/MaWv6jU45U2dJKu8jSlWMoPuKX0OcJtIH/cCimMisDZSRPf4UAesZPs3rG/jlyLxue7uMydykrAJzWqz2w0EfbU3z+z0zXrrLcO8niu3Uq3Cdc4Qgd/H4JekGy4udQY9Bhh/UQLMGx4XSqaSSRfeRDB/c4DGkYuh9IXZGjC1qHdJ22nanK9hFl+tF9D0oZhmLQP/O5cX+/XSPGN16m8V4ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Reorder enum mod_mem_type so that MOD_TEXT appears right before
MOD_INIT_TEXT. This will result in MOD_INIT_TEXT being allocated right
after MOD_TEXT when the allocation logic iterates over the memory types
in enum declaration order.

In a subsequent patch, this will be taken advantage of, by allocating
.text and .init.text together, and freeing .init.text by truncating the
allocation. Doing so without this reordering would likely result in more
fragmentation, as the truncated .text allocation would be followed by
.rodata and .data/.bss of the same module.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/module.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 7566815fabbe..0336a46733dd 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -316,10 +316,10 @@ struct mod_tree_node {
 };
 
 enum mod_mem_type {
-	MOD_TEXT = 0,
-	MOD_DATA,
+	MOD_DATA = 0,
 	MOD_RODATA,
 	MOD_RO_AFTER_INIT,
+	MOD_TEXT,
 	MOD_INIT_TEXT,
 	MOD_INIT_DATA,
 	MOD_INIT_RODATA,
-- 
2.55.0.860.g4b6b3295ed-goog


