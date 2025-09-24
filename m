Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3885ACAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9BA8E0006; Wed, 24 Sep 2025 07:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1998E0001; Wed, 24 Sep 2025 07:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FECB8E0006; Wed, 24 Sep 2025 07:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658C88E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:46:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D9525B45C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:46:36 +0000 (UTC)
X-FDA: 83923966392.28.3F40420
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	by imf29.hostedemail.com (Postfix) with ESMTP id B59BC12000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:46:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.237 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=PDXXZ6Lzog08p/S9oIo4BFVy3Pbue7Ityo1mXpJ2aQ0=;
	b=VzaiAdQdkND/dWsqR4srLLeGP1D+ic8v/UbidF71CdAXWRsbig0NQ6l81VqgF9v4dc58Xc
	gnkLq3yHafMRZTv7YPPjdk6VRuDKFx0U8pTMuEBVr6bdq2rgWmtsxuSGNlk+k2caKS8g7w
	yAtfcg7W27Rm6sHFhTGMjqQW2VZjgQk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.237 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714394; a=rsa-sha256;
	cv=none;
	b=ot6kxUEMFqkHfIie45VCa2P9lBUQAnK7GxNM42Qf1T+2KvfYO3bTcp6O8788sF7xUUYRlx
	YoDnBMDNJI3HX5cJOe18t6k1ZPnRQ5CCt2C5XJFI/XqjDnXOyFw6hk3GrvhWaoNJgQAec5
	yHYS7W9aKjyFdCdnTapgsZnCvogKoOw=
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 97438813BD;
	Wed, 24 Sep 2025 19:46:28 +0800 (CST)
Received: from sjtu.edu.cn (unknown [202.120.40.84])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 8E9C73FC201;
	Wed, 24 Sep 2025 19:46:25 +0800 (CST)
From: Zhu Haoran <zhr1502@sjtu.edu.cn>
To: Ying Huang <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org
Subject: [Question] About memory.c: process_huge_page
Date: Wed, 24 Sep 2025 19:46:03 +0800
Message-ID: <20250924114619.2532-1-zhr1502@sjtu.edu.cn>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e5t3fjk3c6wes97oj6kdedm46cffb95n
X-Rspam-User: 
X-Rspamd-Queue-Id: B59BC12000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758714393-493977
X-HE-Meta: U2FsdGVkX19Gtqf712aOAS0bC/EOoaiwxWLApax+GaLwK/0Ehql5iDL1awYNwKEyTgTZx1SD69//bISnkFAF0KHmPpaJBT0w7oIDho3ufhk+SeEgjMiMgFJrDuDkNz9q1eA2Yal93nhcs2ICw8pyKsxVl86kF2WGGJmcBn49PQFzpTZF6CNK04p/G0+FLK3RRJkM4PisZkLNDbZ9lAub3497yafTdl01Ad6d7yTw3+0XDZBXKaUZdHnO8vfz4Dlf91n3iVZZkg0oc9z+Q6oVHZOl7Uqs3mHeXkhzOHoHdAOYQU50ku4AdbaGzN4shk5RX6cYfOFLkIPYd3fD9h9z42GXCs4w0Wx6sjtfFj51BtaJBfimmU75viBsa8Y6sa3gXJvNwXo+MHrvwMp0p/xP2oj/QLHtWCh/7VBernrgyDjXq9UA2cblGZ+Ua1oxqSsF/z0k6ysrZxbwZFitO62WmNhHitvAPv5G9puxcFekoUZVlvpErmsGBDq+Fn5CLkuJKG11xOB8e0KKIEFeFfdz9jvMtPZ3yoJOaSPr9lQWhge5efjsk6hFdS/L9QJctd50HVjqF/rErhpWqezrzJS7L244gWhOH3fs6hD1Vcbd1m0mVbbHo65LgwzkQVpXCK7Yb97n3fQdGO8aAHI9Eq9P5bELKVvapQi4Iv8JdJDdF4CaiDfQcPsXEOwq3UVpVq6mtDvUsD9pLqlfV792mKNC9kHK6nRM3kJxSi60YJ/5ggfekGQzIcdpafHYp2rEK0Xe6YUnw01mcxjD3qzr9yO1teLrl6GYRiCy5tOadXaf2HxXjn1DkZtpNZOdVduo0Qy3l4nhQZIP2FU4nVoh10AFqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

I recently noticed the process_huge_page function in memory.c, which was
intended to keep the cache hotness of target page after processing. I compared
the vm-scalability anon-cow-seq-hugetlb microbench using the default
process_huge_page and sequential processing (code posted below).

I ran test on epyc-7T83 with 36vCPUs and 64GB memory. Using default
process_huge_page, the avg bandwidth is 1148 mb/s. However sequential
processing yielded a better bandwidth of about 1255 mb/s and only
one-third cache-miss rate compared with default one.

The same test was run on epyc-9654 with 36vCPU and 64GB mem. The
bandwidth result was similar but the difference was smaller: 1170mb/s
for default and 1230 mb/s for sequential. Although we did find the cache
miss rate here did the reverse, since the sequential processing seen 3
times miss more than the default.

These result seem really inconsitent with the what described in your
patchset [1]. What factors might explain these behaviors?

Thanks for your time.

[1] https://lkml.org/lkml/2018/5/23/1072

---
Sincere,
Zhu Haoran

---

static int process_huge_page(
        unsigned long addr_hint, unsigned int nr_pages,
        int (*process_subpage)(unsigned long addr, int idx, void *arg),
        void *arg)
{
    int i, ret;
    unsigned long addr = addr_hint &
        ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);

    might_sleep();
    for (i = 0; i < nr_pages; i++) {
            cond_resched();
            ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
            if (ret)
                    return ret;
    }

    return 0;
}

