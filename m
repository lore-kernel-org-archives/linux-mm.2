Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880C5CE8D4D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37BB48E0027; Fri, 14 Nov 2025 10:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C1E8E000E; Fri, 14 Nov 2025 10:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21BCD8E0027; Fri, 14 Nov 2025 10:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC3048E000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACA0858BC6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:10 +0000 (UTC)
X-FDA: 84109659060.27.B4F8D10
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id CE3DE80003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V+vyvvmj;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCJEgobzRYn/tItBVhI3XMcNL4Ytkb3Xbpl8L0K4v8I=;
	b=lSjcQOwnJ6Ug6usUgwhL3AzERaPZ1BP6v6lqp9EpzQhndb/UUHQz6ib/qvY8GLKmCp0osO
	xyiRNa6mP9jLYE7/1dm2cUk4RlhjuqjaqvL9sG9g2gfvHUE0Lp9bqkvdV0+mRIIeT0u8vR
	Bd8ZgEJMRrfLgoU+AD1zGmDdPGSfCYs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V+vyvvmj;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135648; a=rsa-sha256;
	cv=none;
	b=TvVf0xJ6yhIKLi9BMynDL7682tSdEzrgSuIyA6o3Ha+pNGjXbrfsPULftIY/eLxjf1q8zV
	tApx/WaluujCMq1xNo4lr4+BIQtxk4x58KEnOt/69fyuS6oW5a57BX7rZiPLkwTVdydlWS
	HiQsZLHTy1M6yXEH+nWurtYpX8W1cAQ=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-640daf41b19so2702702d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135648; x=1763740448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nCJEgobzRYn/tItBVhI3XMcNL4Ytkb3Xbpl8L0K4v8I=;
        b=V+vyvvmjtjh+emZnqDqPSmf6SZ/Nd9lpx0iQEFQ6Eq6WQcHvKvYb1kSg/SzLN99Qn3
         Y99JBb690tGqC/wCfHvXNWHnKguFhUv+F9qIJV3MESPi7UDNL2IEfZS7VPIpA374Y3/S
         eCjL0G9Vk5wW/VWK3zgNv3b+9swDv5A7Cd1tUKZ6zgqNQ6WcDVZLtSqhTiONGRati3TG
         qXaIW4rFta3q2zp4/YJPE4+G17fl4kiupTkqDkF26U5wC2rSMHErcx6lTXDGOaB6k0Pq
         7TxheagqcqMS9PwpEIOw3/qDFpJdAiaX9V7oPRiRgBSqpY22QEicY60uhawmvP0sy68W
         d4GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135648; x=1763740448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nCJEgobzRYn/tItBVhI3XMcNL4Ytkb3Xbpl8L0K4v8I=;
        b=ZmTMAwLo10r8HDsvDllG/d+KVnkmdg2ePJS8qoNEwWHE2zklGhKrFNp4I6yqv5ZRCd
         Vurnh5ZA7wN5zDqC/mcvQ/42a2H6TagNDLlmzP+te4GLZkbf1G0bVG+9RYPQo8fKPSwM
         VgDMA7G2tmd2VUsjq/A5QuN2LXTwzg5BCCTeRvyMGldtGG/S95UmZy92vRgSOQ8R99I3
         wKDXeAcw8r8nj4UDIq8u9ggqbrqa7btKL4JmOGXddj54d2XCmIH6sbwufErEM/Kv6C57
         H2ucPuDOnWOVPmD6k2pz+r2KW+x9dpKpXwF2VlUPpux7Mu6GG+cy89DZ7nY0/axrcJV4
         21Sw==
X-Forwarded-Encrypted: i=1; AJvYcCVB7COyS673oe81+BThVNXcBiLijj3C6chDsN+sqJsHqJ5LQ39walfIiSRDCeNFCXV/dfIfghV29Q==@kvack.org
X-Gm-Message-State: AOJu0YzsHmOcbKJ4DpH+gIi4H0tV7QcwER/SHjNtqGzdPcBRxxFzP+jT
	uNtpwOoNrxzcDBzScW778FB8aQcATgaaxEIHg2i6C4bPcRQOwlMObQwjzkDXSEBVv8E=
X-Gm-Gg: ASbGncvbrdeM9/oNL5GKL6etaEbT6WoGS+6NG0Hcx6HWN9cWSpKIfAHiVlzNr1ybwjq
	OmAwOeHWGgAoX6Wg0VO9jc9GAW5x2ctbqSg2tnG1womAVekDr85vw/Ics+R2BFf7St/CH+v0Lve
	vRqLQpEYgSXJXlrg08FYwzOEvi2CBp7EfPsLLZq7kuT9kjnigucP0Wmaq+05uhDRwsExjk4moPJ
	hyR1ZLqr5xDTO3zZ+XkT4a7x1tQKgljbyFieGvM+PZO53bT5SFYZB61ImtmQI/p8Fro0Qv0O1RR
	hJDdKexRprJfh7lt007vEuRbyzi+XMTvIRbAW+ziznpxS5D6LYVe18s/6QGgIJQz45g0e8c5w08
	IwKZghVV/uGn1VtvWN5sv9C6nLbIlsrusF8giMdnm6UUAZI08OFXdDD0CAb4f+Jc4AsQyh7sqhg
	fMVAGiBtASm6hE8ZXZF1UnqZIfcQ0EQn+lOagchUyETvIHuPmTlhGaRtLI8EUxkd0TR+92
X-Google-Smtp-Source: AGHT+IGqvP0vwg6guTwhcdsa6bT4+I6iFV9vusGDhb+GF/sTNONxEyRk8zCeLELCWn/eYnZOTmVaMg==
X-Received: by 2002:a05:690e:1544:20b0:63e:3546:6fc5 with SMTP id 956f58d0204a3-6410d194f9fmr5217183d50.32.1763135647923;
        Fri, 14 Nov 2025 07:54:07 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:07 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 05/13] kho: Always expose output FDT in debugfs
Date: Fri, 14 Nov 2025 10:53:50 -0500
Message-ID: <20251114155358.2884014-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE3DE80003
X-Stat-Signature: jia8bscca96ogwu8wfn79oatdi5koto7
X-Rspam-User: 
X-HE-Tag: 1763135648-380049
X-HE-Meta: U2FsdGVkX18PzlrysKgIlceUylUaM3BXZYu/RSu1NN4kmOdFxBCt0PgNPJIHwZgLE1MEuOrkdPM8BKYN63P7HjjwLQch8XiSfrBcdOaU+UOqgwQCqdRcYYRr5T7y6Nqu3DWPD8OgTJPAng8GMDsHbEVoflwVB8caFvMaNX0h5wbICZfZ2QkHs5LmCigF0f/Xum4TKoBbl5lDaHPQXruWLyjZFxXhSucsfgBG4trs8z6LCqumKzPgBkqIAiq6kMZItq8YnWPFA4PMFYD14mLmOE06SfcYjJFxIQWMajHdEAQe2rzQxdWdOrwfCWNZprDbBRsmx/Jf86lgHlWfjR6hOis6ws6y5rQ+JVh+1M9Ktt89yGH8H+tkGKRhbNWZ4jjOU4iPk9mFPHKdDlNLn/cZITo7INUq/J7oswOghOV1Eg0CpLTyv2FEWMCNsVdOPo5L8my1YJ0C+Qs++7XEIrxFk7qVI9DwRA+GtjusNrHYPHTD+mv6K5EFBfZVlaj/U4kUCOIjVv9sumbdhOrH5TcW54UwL49mJQ5aeX/lq9OH62AFRoqhSyO1EdlPuPV9tZUicHHk4o2Q7/+TEgNFs7R9YGScXZCFOkteYzKIeE7bpoC72tiGOVyEwMUOvvcQGiiyCqZO7ZLFMmvBIUSIjYlqAgofKf0WZmIBnf+9orHdLQQhqd1WDHjwwQy4UYiRP1HL3hXo70YrUOzFT7z+i4d/6lhybFlX5F1a3Z/zF5I9I/tMJuNa07ZO/A5UFtPwW12NqI3T82tliHsizoj4v7cIRLYy2+o38dJwLeUaXIH46r7uniNO+kT9y3TgFgZVCVLuTDbZXfdAYsbYOivHPYICyg1L5qW3UEe2RDyS+oUqFz7pVDa19Tf2TaEOCq1NzKPvUJte2Tok7DrW5xzyy3XVCBqO78kHhhkcElZFDPldHcO/VCYhOT2N6O5GqGmuZSms0T/RbH5E7CZk9e6H9sA
 i6ouGXhn
 RdSH4Hmm1yDSjRvwCYwIKpUpPM4BK0ULt3Ozjau6KIdh+eD8RV5LFvcZUea5jEu+XTGcxAnLVrAsNj2k2hVHQAo0TnNg2VP8TeON9AqdzWK/EGnMWzquNjiQtBGi5RcSt23beqXGX7XVbm5+kJCKgi6JLX+NCL9zSQa5FxqFeJ1+OCmMipGa/guPHQZaioDNkEO50P/jveF0hbRsvGVcXcLZw9JFVgV52pQFOXUNbGv2AMjDFTsh7Rg5OwD2BXq+RqaznGHSIjiIGFT66zs9i34AB/adI5JK3z8IUB/zilU45yXBb7sBs+V0b9OQ0WAHXg2yUYwRrwMpn18w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the output FDT is added to debugfs only when KHO is
finalized and removed when aborted.

There is no need to hide the FDT based on the state. Always expose it
starting from initialization. This aids the transition toward removing
the explicit abort functionality and converting KHO to be fully
stateless.

Also, pre-zero the FDT tree so we do not expose random bits to the
user and to the next kernel.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 83aca3b4af15..cd8641725343 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1147,8 +1147,6 @@ int kho_abort(void)
 	__kho_abort();
 	kho_out.finalized = false;
 
-	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
-
 	return 0;
 }
 
@@ -1219,9 +1217,6 @@ int kho_finalize(void)
 
 	kho_out.finalized = true;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
-
 	return 0;
 }
 
@@ -1310,7 +1305,7 @@ static __init int kho_init(void)
 	if (!kho_enable)
 		return 0;
 
-	fdt_page = alloc_page(GFP_KERNEL);
+	fdt_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!fdt_page) {
 		err = -ENOMEM;
 		goto err_free_scratch;
@@ -1344,6 +1339,9 @@ static __init int kho_init(void)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
 	}
 
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
+					 kho_out.fdt, true));
+
 	return 0;
 
 err_free_fdt:
-- 
2.52.0.rc1.455.g30608eb744-goog


