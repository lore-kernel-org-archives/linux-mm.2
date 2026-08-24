Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE263C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938D86B009B; Mon, 24 Aug 2026 10:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9108D6B009D; Mon, 24 Aug 2026 10:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8263A6B00A5; Mon, 24 Aug 2026 10:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 677166B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:44:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0592E4018B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:44:54 +0000 (UTC)
X-FDA: 85136434908.19.A9DD1EA
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 441C014000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:44:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hoPiTBYd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mZ5Gk4/1Pu5bK3S+WjW2BlP4j/qxWTHvLM7mSgUCfk=;
	b=GpIPFO+Dm/gkuQRBdPwbsmqZDwklWS8IZ2/GYQREk/bRwm6OeTSg9wuAm8I+gck2N9ihc9
	PzYPxRALGcDxVXehF2y/UXdebUhzeGs07JbSeIMgdsZL86IGz6pXalFjgifjGvQDDrgQ5I
	pwNoTBa8NkDxXZWoMR40faNPjavEllM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hoPiTBYd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582692;
	b=lEn6gzKV4L2qpBVgYt/okyEEkJl3NTMV9XVSNq6JBeDxQUll82UebCczTeVkdsMcC4atTQ
	wtoW9JpnrJzmi+pxG3GpI2tPKbx4VvrqsYWzgqvPyJr9j6050/s1DYF6YL0dVa9+AsbcgD
	cFm7fe+6BXopr3LtaHnjfs8ebnO4uso=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8200b55dc47so55161147b3.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787582691; x=1788187491; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0mZ5Gk4/1Pu5bK3S+WjW2BlP4j/qxWTHvLM7mSgUCfk=;
        b=hoPiTBYd+JiyvRT0QOuBCKIMOa8c5OWbVbwIrwF2hJRo9A6Qb2YN302ODrwWXBib7R
         +tZ2fp/CS4vQT8oOKjJx154O4f2Ddm8YJyEUkUdSIK5QZtQZ8nnaZdBRISSiSEtjzMrh
         PFCKf8uHsD/OlnibtXWTwP6JDCnWb6q/GgzG4kAIoRohGiO3TGioLhosE+tyh6CD9XjV
         /BAO0HKrODZkO788fLWyRARcpCwqljB4Hd3+0A9gfzwBmLnEqYELDX5H1BDtJdREVb65
         kZDHnHTHnbYLuNBSYN1nymAQ+yzSqu/pwVVjnzRDp7nwubwteVG103CQ8F8h60dErH8L
         yaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582691; x=1788187491;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0mZ5Gk4/1Pu5bK3S+WjW2BlP4j/qxWTHvLM7mSgUCfk=;
        b=nBH4LE8NIQCRqEYnDe8PX/Ewthpr5CbN9vxSEs5w3UE9BDH9/ucrvx8gkT729rNAV8
         qmL+vyRM5Mo6zegBXUb1xXhyhEQEbz3bxN4uRqzG42+dypGZUCQ/C+12LUr/SB0l5YbU
         UCTexLR165on+DeXjgWP0nTKZDcIZmC4P/sQ1rp/997RhgYXBsoEu5fzym+J5+LkvG8J
         uQs90A5Zf2kZweKurD9qSzqE2olpbLodbIUeb4psdadgT5kOdXhRRnz6j01lPbIaF1Fi
         pBXP71DcWJDARXc3G6MNmHFMyB2CfTiYllAKauPH7LxRQmXk9b37E0ckzi53RmLVyUXr
         nPIQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrjqa8GBKmH49kBt8/78dl1auQJCwKf4fgIueQNf3Wh2kftha7vOPjohZRXTGekpNsxIe1IVCSifw==@kvack.org
X-Gm-Message-State: AFuF++mMqUmdNYMB/jLk9bqHgWjewwdexeRWlGmwNTYIbnGoB+12brFx
	B2KIcF96+PA4SAiG3vANwintBoMV03pgTWcavXRnt9qFPl1iqB5k4qGQfDZ+sdFoxw==
X-Gm-Gg: AR+sD10eUlzYCousTfAqb71zcaqE5ECiC3ONrR2i36RNyugnf38V/jmJySobea9No58
	2cv7be4C+L8GUl+9Jy8hpfPISnKMl7rxOqCn5Cb7M/Ey4lGqIs3WC3PCKt7I2+XweDdE6ofnqi2
	1Afol4mUt2cLVWzJQQzH/16NMn4NdOY4kVVRPdVmqdnUU9//N+sosU7eJQYV9zflDCvdiCZayai
	L+mTT3yf35ZsHNZDR7hJSwhIJorRrJn9nlkDABfmMajPjuvIqIdhj7fMYwSGCUlbya6nLoQ3E0m
	gFwBAmrs+i9q0bXP3ALs9gx5yl58cu+S975yMT0WTfZKHhzgScblvQSDti1OlTc2E5ATa6SEJHM
	r0kSfUnRNw9qTsveXI9jPICq6NnRDycrQ9N3VhNzsxl6Wk5UJ4504jyPccGgAQPs3nAqSV6OqlF
	4RUR36aDvU7Mq9AYPq0DdqGonTrH9qOSEeSSNcrjl9sw/0NG4dV1T+jjXAze6IFppDTRZ0kJN+W
	B/nXfBTzyWMWONLEeEKnoWxwZpDEm/XdRmNbYmLgVLr3I5z
X-Received: by 2002:a05:690c:5:b0:853:f007:7557 with SMTP id 00721157ae682-853f016ba69mr7002677b3.19.1787582690568;
        Mon, 24 Aug 2026 07:44:50 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cacac521asm34834717b3.48.2026.08.24.07.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:44:50 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:44:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 22/25] fs/fbatch: drop_caches invalidate_bh_lrus() not
 lru_add_drain_all()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <97a16bae-dfe8-b58b-f0c9-6eafb3881195@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 441C014000C
X-Rspamd-Server: rspam07
X-Stat-Signature: p5eddj14iyr9ipncpnqjntpu7tgij5ox
X-HE-Tag: 1787582692-748019
X-HE-Meta: U2FsdGVkX1+fwic+vN3BgxnAtjMyeKFxQD2D+CmvuctharmsF9/uRoT9F1UgO0mXZN7VuZoAVZqTJ8a0sD9gu7/WOeGP1Cfk9rQ0kpYpq0aiWFxP4R+mJXa4wWaBTtH5kzBbKkINU2sX5PWizA4+Su9Wep4R9tO+9Moe4i/6mzJfH5dsVZZIiHxe6xPRF3yZuPg9xbMbCkID6QG15yNDdmpLeRxSMgPQjdQAfTR5ACyMNBrlxVb+zPDQQmjHqB7QYqng4MRYMII/0Hs210PH0bsJiuq42oTNQ4daf1IGvQLCBENxe4eSLWC3P/hH7Fnkfmufl/1Yei4t/2yUVQhCol8T9glIzZK1QtloFqlYNrn8MAZpKkZ8XDcnxXYjU1WpgrOdw9yqWuHl6oxg7PemF1r5AfueXcIyXSGZyJg9FWUTrnd0cnLZ2vvYzEOThb/FEYXq5XCMyuYQMPk+ZFK8xPHw2PiM+O1UAieiZx3a343yhjrrowLr1C4kTnWgB8gECa2bKBeOzHZJIhkhVdIKlHMYn5i4bfUvj+f2y+nbV7MJwYHiIpnZWK1D6GG5lUsjJZnWoA5A2oJvrn+Co3SZT2AIloH1QNoqNjGkignPeLpubO6RIJJIdTQYPBOPSnamf4LsYOOUv3/8BrEI9S7tpkfP85PzqLGHhngJLN5V4J+y/aLnviz2UftT1p+WvQ4SyRVYzSABR2+Q0/AIv2jRqYnTkvi9dz4OrANB5acjtAh0J4IgWHoLUzlM9JXHBShA2oQM6QzoRO2+83FXaJD35zSL7KFrSfliokuXCXr5DaQwXo+Rwh2k/lF8MdZQWbhizwfx05KRywOuoefXTc31yIIWU+fg3K7dGlbXh9abGaVeHOcxHlL/GmszNKCVo8rwOlpOohyHKFqijZG7eSZYVxzvo2ppMLfxEa0nJIiAseA0zrHO6HLrIaXjyzu7c+EoaX+Zdq0bVUolhHq1mkT
 i7eaxnD2
 Igdl/BQdCvt3CzSwsnsQ6nkSY3m4V3Rr3MktV91zvdJO0kZWo8a79VNyUGNY4PCOzP4NSCR8RaxCsCHYdxC4w3KPvYt2BcrEgZtk7pdISiQZmMqTAxRbQLGAHSauayWQyxSo+VYz05eD008K6FHpp3xWEBtbaM58GEqVOtt/nXTdSZhGl5CDf9/1uyEpdiG3Q8052jeyB8U3ECaUtixFbu93mSDakbEAhzb5mG3h4oWiK/jhAK+CYis0pEkizZTG1b0Fp7TQhOnmAiLGbP0RouSXuBAmp+mK1NVM/vsgvpgNGV8ReV5Q+0DdSLRgUzxTfrBiiSULb4dXJayrRwGsJx2pDENK9ae8gaXY4Vv52RWyUdJUy8jfuzEZtO/s27lO10wpNBo5jP6g99EPp2ZNOXtU2gaf3h8fWT4DjY/njPXkODlnjIJUI2cimJaqvQ8F8aAX96O7ZCW7xp87nGdlNpMp7SyKKyJ8NIv2tiDER7EVzUB0i6knROfSs/FsrF39PwFde
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drop_caches has no good reason to lru_add_drain_all(), now that the
per-cpu fbatch references are gone; but it may have good reason to
do the invalidate_bh_lrus() part of it.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 fs/drop_caches.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 49f56a598ecb..054af78e6a2e 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -10,7 +10,7 @@
 #include <linux/writeback.h>
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
-#include <linux/swap.h>
+#include <linux/buffer_head.h>
 #include "internal.h"
 
 /* A global variable is a bit ugly, but it keeps the code simple */
@@ -60,7 +60,7 @@ static int drop_caches_sysctl_handler(const struct ctl_table *table, int write,
 		static int stfu;
 
 		if (sysctl_drop_caches & 1) {
-			lru_add_drain_all();
+			invalidate_bh_lrus();
 			iterate_supers(drop_pagecache_sb, NULL);
 			count_vm_event(DROP_PAGECACHE);
 		}
-- 
2.51.0


