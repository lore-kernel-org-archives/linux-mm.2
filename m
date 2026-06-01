Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B63CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6356B025D; Mon,  1 Jun 2026 01:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7FD56B025F; Mon,  1 Jun 2026 01:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47456B0260; Mon,  1 Jun 2026 01:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEA1C6B025D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:32:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B26F161B4A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:32:32 +0000 (UTC)
X-FDA: 84830223744.28.DA11F5A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57D0E18000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:32:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780291950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i89oVZarQ3g/a0TuHpcXUyoEZ4loKKH/VgQEjYZHb1w=;
	b=YfIbL6NcEG/RTBDheljvH+5SssKDMjuTllJiG5IRXpFlPsTv3h+wndXOJc6sDWHawPEvgS
	cgR8M2Edxvx9sShzNrNKHum0MJgLKqTkX1s/cn+NkFPPcS3HfgfHRNeQEHQdv8zhBwYz7W
	xyRKhcUHYaIGG+AMExERHw0IIIUnGPk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780291950; a=rsa-sha256;
	cv=none;
	b=w08kFLfiXO9hQIvmHMbaG2Yg/x0wVwjnjoKv+6Yi1xyUvFQuP25i4tS2tV4GJRzmN9NSCr
	rzMa5s1WLCdW0VOr/IQ7HTeyut63Chql4KqkcSrnwT9tDtqX0R9t6Y+/tSeJxolOJtZHDR
	AXz/ueG7SDSr/FKDoO4oAFF+jGuqo0Y=
X-UUID: 42bb7a5c5d7b11f1aa26b74ffac11d73-20260601
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:67b7feb0-d64a-495c-87ca-85a5ffcb6bb8,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:67b7feb0-d64a-495c-87ca-85a5ffcb6bb8,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:77c46c0f76eba2ad31f3af4e4c28aa77,BulkI
	D:260531223641LAAN3BV1,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|865|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:0,
	File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
	,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 42bb7a5c5d7b11f1aa26b74ffac11d73-20260601
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1581226732; Mon, 01 Jun 2026 13:32:20 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v4 3/4] selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Mon,  1 Jun 2026 13:32:30 +0800
Message-Id: <20260601053230.671606-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ahxHaQFr3Uer2GBP@kernel.org>
References: <ahxHaQFr3Uer2GBP@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 8rk3di9f8aeqydeuu13p87q5itpddoha
X-Rspam-User: 
X-Rspamd-Queue-Id: 57D0E18000B
X-HE-Tag: 1780291948-309623
X-HE-Meta: U2FsdGVkX1/iQFuJRwiwmjWyQz4qiMRTwyMc6gHstEQTi3ww/wMAacc5d7U9ct5PlqZ8WLxLLH+glRFJVkP8lOkZH+8M7QvHd58nTSv6Sc2HmdzgyfXywtv1FBNwiimjm4DWy7WhSDD0CskMu3LRmr2vE1XKv1Dnd8U3HjOmLRVOFPS81U37HpAVaP/BTdBZaCv1wraKdz/cNgEBBAZQLSpaTP1+WE3RbkLyQB4pCZGYHgzd0xDqfmm2574O4DBpl+77Q9bGj3YvLCDNewASiDZ9lfhLe3XphDxF/mflDncHJWlVoEgKtLo7l6uv4wkbKzBf5bzVOIuUp2PUsxCijxzijFDju+K+B8jZXEm26SCR/0H9H3HD+ahXTp9GfFwsOCg9qT0J/YiJUQar+iMmYhytCTlwBMLUwXLZn9yuCw/AyreMiA23S88uGYwxy4a6fzd0xa+saaQwSm/LWxz9CmXeCSzF0aYxFEpQbS0to6TUAZhhNQ0zlOhwiKVNn7GYBXffp4S39dDbqIDZ6O0ZY/uJOq+se/qGk/6QTnVL7a1y4nqwNKALOuc5ahCPNUKXgftAwaOwdq59k32xHbnEKriYD6FgzQ6LLqpyZmZSU5ttIWt+SDaY9OpdKOuDZGpoSxU6+9cZU5n+R9FuztSKeEHp3BKipr1aUa0lbhsn7rORLWxwW8tDjCIXEALAQ1JecnD/yvjeCEJvfDmHWoR0sAKsffLPG3uUuTbplkp6B6nf8dr3QiuaLuTnCJIDcXlQ5a1iR25ko/ecU3uJUmTWXJ8rhram/0IbBz5erwxvJWkPWOcw6PrxQc0i+C162WDfISHEsbYyuRmbu/O5laLKX50Rf7/l3bUesVfKILA/c+otqaWqPCVDBmP6KUka1QO1zrxqJovunyaeJqoYtx+cGdRTn4oNGCd4OK7M3vcSpYdVGmYqWLaRh0QkifSXGWkAQKXkkmx6kWxPZvascAE
 2Bw7DJ3s
 Wto+2BkcZ3ItgRsbL83BLh322UZsAIO8BKUUggYKOcbRtYhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> > Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.
> > The old path only printed an error and continued; the test now exits
> > via pkey_assert() on failure so it does not hang or proceed with an
> > invalid child.
> 
> Looks like clone() invocation changes in patch 2 belong here.
> But is there actually a need to change ret = clone_raw() to
> child_pid = clone_raw()?

You're right. This variable change seems pointless, and I'll revert
it in the next patch version.

