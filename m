Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C46606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Iu4jOaTB
Received: by kanga.kvack.org (Postfix)
	id 070D66B0624; Thu, 19 Nov 2026 08:54:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0215A6B066B; Thu, 19 Nov 2026 08:54:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA12C6B066C; Thu, 19 Nov 2026 08:54:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7E816B063A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:54:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58F1C160ABE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:54:36 +0000 (UTC)
X-FDA: 85452013752.23.F70D5A2
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2D14C20003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:54:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Iu4jOaTB;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096474;
	b=za4+OaMHxpnvHpCq2ml33DWzLYMl2vPIifqayYYXL+IfcEtSee14Scq7FC1JAfuJDGfTKc
	xz9lZ3n0sYf69X2OVNG7omNjzkMWb22t6k3ZSC1DbctoL4lUV08dFdzP4ZZPEZ3RlbztvL
	PlqyV+5vdjD28z76CCW1cx20bfMJWFE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOukUK4oe4P6hD9p5P/3nNz1L1pFRQVDmOQBqd7VKxM=;
	b=yClCSHLVg8hpaZKaxfq1OVktdS2FoBQ7TqQaaazcz+YHpWKbuWfPx4aEurhCI70Rc0C635
	9HzyFmGyGXM+TtHWoqirHaxtbWUWbPgkDbJZXROJm/5X6HyL6setJ4Dskm1JgfhqTJjEMB
	PHMGsJtaEd8tWZRG/V6aVqWxFapN+e4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Iu4jOaTB;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uJ8rfb0SM/vo99rca+dn8yGnIvKF5792lx39OCI3xyA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795096472; v=1; x=1795701272;
 b=Iu4jOaTB1A4xddG62fo5+NouTLjYiPLIJL8B37Le9UxPKvlngNn3RWHFdaaYQGnL3YjSqgl4
 tG5A6P+luFRLzt74zmVq3aaJxE9WRFpNiTiAshXHA5Z5diKUU8hDzTZenuk2RlPFRdQmQDE6K+e
 rn4oo4P7qBWdmX1ekEPRnD20=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4b92a17b81ba35af;
	Thu, 19 Nov 2026 13:54:32 +0000
X-Mizu-Trace-ID: 4b92a17b81ba35af
X-Migadu-Flow: FLOW_OUT
Message-ID: <86b1d730-a5cd-4a26-b0ba-f6776dc9d1ad@linux.dev>
Date: Thu, 19 Nov 2026 21:54:21 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: hmm: give migrate_remap_fault a longer
 timeout
To: linux-mm@kvack.org
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 mhocko@suse.com
References: <20261119133955.54001-1-zenghui.yu@linux.dev>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20261119133955.54001-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wyhbuq934hidysjcbqh8gfhhtqf3jibu
X-Rspamd-Queue-Id: 2D14C20003
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795096473-480003
X-HE-Meta: U2FsdGVkX18nw2RNJ27WUjWJQxA+0/b2KpBMWVA/RGs6gc7mSiY1lS2IRUc8k0aN5myxoQAhCZ6XciCzl7MsUv9VOVhpH11ChYZ7WLv2cfVcy4/ZNBFHRCI6S6j6IIjvpiieo9A7+gYsEuXRJE8oPL+GPx6n/LuLsxAYmDlR2uuYIP5eVZlZBUCKEgz1C6K4mX7SLtc3lKs/hofooi6TiFbMnQQ/BKpnLHKbOL2QdVXqnxbS498wHjVT3O8wK1CR+G4S9L66/s/8Ce0989tKG6xVRS9fp1G1soVTNI2jWQL8EFbEbTu0A+wlz+P+B8Bk5ASIDQb1EsHQqj9cPL1wEBZbl881QHa/vmynnwhpq5XM9xs3lSTX/x2PXZS6HMG5ObHsgwbqBg4bzTou/3Yl/xN6BO16CTVLd07HMofiPR+5DGeaYz6yAHbLR8soZRdXAnrw5BHpjIXRLqnfITbugFwgW0ctQ6mrfRuxbNNwkcscQHau8jgeV2/hMzSWdBfYa2m3GJ6MEvT3Aesm8aOZ+LkobCAOJX4Z5q8kTGnY4uF9ObTU3sBiyLf7hXiA9/GmvFmTNunRLYTHB+D85TAJ2+5N66BmR2bzy865OGYvrbaKCJBGYeqFhfG/V6J43mOI5Yxr+bjVsHK1kq3MRkcqNYhaeLIuKqdN0W70OggHA725QRr08e7ok5HPx+MwlvD0d2msq9T3DE1dLxjFMdrlp0UPLjj2QhXGkZNB+yLLuXysCXkELJy0DfiTlKZY6R/4c/OdHEFMfLxkdLjbNWG+jGOAfTwqv5WJ1b+RRs5BtDSksjyUZQyxYrJUHrU2BRgebTZ3fYGaX9OjiwMQHW9Lejy4ZyD5igCpaKJMuPltyh0FJn5Hg5gul51phE6R78v2SkLdoEcctb64QrvJisyfgmazvvyRJWq1QG8UGN4gifQQ34vMuz56uJ3VT+/oOHWwtQfAUml9kESX4XMxwra
 cqR2B/3C
 TRE9KlT9aryTA5vm8CXrvHfqMnVfVM+uBFLD/smsB5I+fEfFJnuqSkyP+N4nwUX4aiRbCrM6N5bqEGv7Os+5n6LeFc8zcDatqst4W/4+NSnwSdZDYwFh24Q3vCZqnDQF9aAH7+OOCRzV40DhPGkgsG/3+hrjT8DImu9PHXYqx0hkHis8yAwNQKwTFedPYdZK5WJ9HFkbXgE6vJzF+YkZCrRASkDudrKT0T2gKg3c0QgFZtdUDCC0CR9Ed25/emeEg1AYlZB4QzMHPXCuuJuLjnnZerVCm2Da8Di4nwxkdOTpMax3zli1Pmc4bdptd4/RHLmJOw2bxEQvzS1ChnObztjPknn50V6KtSo/EZjIOuXF/yEuutAleMk6Wxe47f+601bTkkywbiIpygF3T4WXw3hpK5SzW7z/z6vsuY+jWSFwa4ZziVl1vwFIgzSk6V9LppwdNpntoq+XnEDA1mp/eJnDyrkdI7cIejBij+rmUHEDFBAX6Lux4309elTf/tKJN9gpMeHXvhTx1+HAJkmFYabf1ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 9:39 PM, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> migrate_remap_fault sizes its working set from the PMD page size and runs
> 24 combinations of migration/mremap parameters.  On arm64 with 64K base
> pages the PMD size is 512MB, so the test churns through tens of gigabytes
> of memory and takes ~32 seconds on my test machine.  This just exceeds the
> kselftest harness's 30s default per-test timeout (TEST_TIMEOUT_DEFAULT),
> and the test gets killed with "Test terminated by timeout" even though it
> is making steady progress.

This (and any) failure of the hmm-tests binary is silently reported as PASS
by the kselftest framework because test_hmm.sh always exits with 0, which
needs to be fixed separately.

Thanks,
Zenghui

