Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38E2C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6A096B009B; Fri, 18 Sep 2026 12:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B0B6B009D; Fri, 18 Sep 2026 12:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33B76B009E; Fri, 18 Sep 2026 12:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD17E6B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:56:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30BF880775
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:51 +0000 (UTC)
X-FDA: 85227487422.09.182A96C
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B28BC000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q7dYAzZP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789750609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N6h/sDBFqjd37ju771nN5V3MCd38OzMJDciAFS7M3bg=;
	b=pIwqsnCrP6yVxOEipBkFzNFkM/UtePfz4mxiqiP2r8g2mR5kKkYvxmJbhooT6OUlO0qFBM
	YeGeKvKKwbihNoFPSaWqvD4GOXMvXxrIOGKRLvwIyoLP3FPRNKm4HP6jYlKloLrcTYnNEG
	otXuapjV3woBIJ5rKPyIl3Zw+ran+Fs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789750609;
	b=hBSh31xTwonpjEVP3F2+ONfzFkf3PN3DhAvuZP6LMLJM3TkR8uhk0Kq2GfVn8dqaFvWbBc
	WcqtzH3nDboFbRgkvvG3fqrnTF9pCHLOfqvxEbWpty3/mQ6PifoVBcx40mLQw7RU9Nv4O6
	adbKptLJkhfxZ9/NysOwu+g0RIgLLIo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q7dYAzZP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so642379a12.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789750608; x=1790355408; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N6h/sDBFqjd37ju771nN5V3MCd38OzMJDciAFS7M3bg=;
        b=Q7dYAzZP6Sax0wYMvsE9cX/beUxZtfQdOKTnPnU4dP3aFEqZDAmMaKhlsx6UKKEoFm
         ATzg7WRmZ8uNEChZNfvYw+D3/Fw56dE99lwLiySb/Uy509Z/3CgmmtOqiOaBKoJuAMYV
         hrpgAzDeiylkOxj9wWnwz2lC/PczxE7svyJOF45dbdWrY67urndykSZMTFqG2C3lHWjw
         kyygbLH5RFWNRHAjJYF85mjIcEO8j6NTf8bOUydNm/A4gvtOtlXsze/TWLZrTHHSh1rl
         AoBvw8BDV7hESLz1574qpITLxx3l9ZqZh0RhKUzQIA04xzNrd5R8WEComz+KC+Phuy1+
         K7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750608; x=1790355408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N6h/sDBFqjd37ju771nN5V3MCd38OzMJDciAFS7M3bg=;
        b=D/4n/cnyXsx7bK+SoUgyGZIFhcZ+6ZsR1+ZOiul9iwLmmn47qEC5VMOZAih1IWvGfR
         c3Q8CDcCa09ELcdhQZIpBtkUTxc8o1IhCP2siY9Vugdez0TFEC5oMPxN8zKz3bAAec1i
         0qGO13gpTw8KfNVBMkDPK5p+kM2FIzEj6OZDOwZANjgxdtTAYIhPpgZVR2VJrQaDXxSF
         7EYLilFlLU/peCX4k2MLCF/8vkDDnUca60gaP6OrTcCmAekjcwmHueMssbfg3GBhs9o0
         B0LKfeHqpoimzbQLqz0Wxoef+Wjl0w5C1zTVyPGYAYNMUo/li3IwkEpUiQk0yhdt2hjP
         kITA==
X-Forwarded-Encrypted: i=1; AKwUvBy4bupE29CRZCUFjE7blYsrLDx/vMy52n4NDN9jk6xcXlHpW075/Erz5IXZ3+TLMuvhRmNqpLWdcg==@kvack.org
X-Gm-Message-State: AFuF++nN/Gh8PRmInCOETaXla5JuI37cTcBf7/2J1yF1/lsF6hRB+Zj7
	5JXg8CDh/CbxoQf94mvCNRUcerxdcY9ZxER8DzGvFj8dZEIQQLFDHkIn
X-Gm-Gg: AYBFou1mnNdREOUUq5R+SpKwkSw+1K09X3Sf1DvBg9L4vh6M+7jLXcFdbdY+LoxmOk8
	ALJOpt8tE69lAN2zxPjIwk68RqbT5Q+XUmdxKukbXhyevDEwg2oNoFTdSYQ7S7NPQ6BEDCOFRLy
	iqLtgTIB4KOFpMF7oj0ghgvO+v2AtWsBjq34G6sX2yN+oKlTHmc27ujfSX6Jdd1CsrdWOHFxz+Y
	cszOf+J+MLwtE9Qm50xroxo+6QNQ99JTj9r5eRiuCLlJE3js5oU2c5i1tEg2L2D/aODV4JDyj1P
	CyfbNp+TgNYRBpkerF5eRRSskKB/+IIzNBgtDhqVhrWSTTspNliLGwbnRUBArbrXQg6DiH9vK0Y
	vOPPNHRbI6EY4VFgPLcmNbuy039XUhhsUKQXczzF9w0EogKMVH/aGmYPp7FK+bixaAleRxQqVtu
	wTpmFbT8vZlEbJg8dmWLjz8Yk3xzHyulXKBbltq+1rixM7zpidwGOB6t5v/qzaqvXG
X-Received: by 2002:a17:90b:57d0:b0:39e:6c6a:2098 with SMTP id 98e67ed59e1d1-39e6c6a22cbmr334561a91.57.1789750608280;
        Fri, 18 Sep 2026 09:56:48 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cb3284asm253816a91.14.2026.09.18.09.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:56:47 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH] mm/swapops: remove unused is_hwpoison_entry()
Date: Sat, 19 Sep 2026 01:56:40 +0900
Message-ID: <20260918165642.1014988-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6B28BC000C
X-Stat-Signature: 5tzzwogue361g5cximd8oh3pibi6jtb6
X-HE-Tag: 1789750609-183676
X-HE-Meta: U2FsdGVkX19CujrClcdobS6q+gRvw9El42fhpbOq4JqtuGjdmNEYVUrB2X/9euGxi4ARVgbNZZC7C8yco+ubVMl2d9t8v5UwpDmbsiZdIA5UXDuiM/rmZiPZlXresWxGalVU6TjQkQTgJHwM2b+rCfZjsZs5Uhk9onVwPl9blAOocAo3dPrz0z8m0oCdoYB5rHEbxxl1xuli4sBPhTus4kk6gOQpdRqGZ6IYsWX8PU1dQnLGjQVeyI4hFIT2clbZ6RiSij45218ONj3g/iuenUScZzz9nUmhxf+bRNHWfhIekjCPz0sVyvf6R6+ImrzEZ7c0KrZbUjawsuDxCSV3T6rr3CYWEXDjgQC0ndY9nJfgnlkHqzmGIqwAFzT511gF0fL7FutAT7KbjbYAtKojDBQczcgS8xeWvoSKuS9vPzUlsP/RCbRNSFCMEBwyBkpPuL/WhFezpvXn2ycV7O3oJkw92Qs+UtGy7bDAOldlEUrNKYi4OJWLNpnWwX6A1VZYwxpClS/nlWFF7cBf3BHRzuiBsW9/SbMaEK4YArFrhuL9X0hhHv3bryI7AZF09Nb0CZFGR8oLtPTWB38UYiK4ml8NOV8ITNkPvCg0R7aU3j9bA6Juf64YuJusn9jCNwBxv/tURlKIb6oVjey4A39GtXpMGxzy+cu3eOlMXWfwpIvpyaddxKZ8/K/LHU8WtlvR8KJOLhC0aVM6xuPj3+3/ENkRNerCfWRwdk9bmfdek1l23+G6v8RppLt4+Oi5J+i2S+1fM98F4E1OQOboHqCkjIZpoIooh0C32eAak/REZA6i361rnf6QeBhahDtDdeJnblNRREvuz7FgOwqG80x7MN6Z3yXlRHUGDqvfnvGig2D/kGNF3uqAf1Pnu66hjyw6V3IY7QRBoxwirdQuUFcrSLf+f//XR+GvOhIFy3lUArEQcu9VU9K6r9crPUpDXtfXwD+pmQGGLe5miZ41phB
 2Wslio5e
 MthwNXyANLRBYKH0TxRJ42w2o36vhSULPO4kEXHnPMsbnBPbzG3ciMC+W6psDRJa7B6XOqMr1fbOfxDJ2GxSwQD++YVQlZLCGs/Wc5wT8ODvAcROLHh+J5ZM/BhmlJl8fEygsULbIwUn5UoDCyCAKiOi1Pov8xOzf/910BxtdEjt4vkqWnncxhyn+8SfTJenclZIKrUB/c/c+mhlr7GfhTXCGcEqhEHJBbdbtw3z9/qo1eGytktj7ECQkEzDmqdkql8Tg4VrZL5fAKVwT4wfkWrpJXLbtBRVF7SNEe8IOJK8SMLj3KsGsPr2RoBaii40l9NNDr+LN8gqJTzwUP2Jtuk7UjtLj1yo98r+HXcDPVmAIaRy/KXS7FKl+s8qzQoROEALikPh9tIZQIGpm3nBa75TIx0THRZ9tD8PysbRqaNMq590tRQeqFv342dV15bNGHFSkKtMsKJumw98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 93976a20345b ("mm: eliminate further swapops predicates"),
is_hwpoison_entry() has no callers.

So remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/swapops.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index e7d0d529f3e0..603f9e3f909c 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -261,11 +261,6 @@ static inline swp_entry_t make_hwpoison_entry(struct page *page)
 	return swp_entry(SWP_HWPOISON, page_to_pfn(page));
 }
 
-static inline int is_hwpoison_entry(swp_entry_t entry)
-{
-	return swp_type(entry) == SWP_HWPOISON;
-}
-
 #else
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
@@ -273,10 +268,6 @@ static inline swp_entry_t make_hwpoison_entry(struct page *page)
 	return swp_entry(0, 0);
 }
 
-static inline int is_hwpoison_entry(swp_entry_t swp)
-{
-	return 0;
-}
 #endif
 
 typedef unsigned long pte_marker;
-- 
2.43.0


