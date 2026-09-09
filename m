Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B757C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A0C6B0093; Wed,  9 Sep 2026 06:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BA36B0098; Wed,  9 Sep 2026 06:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8E06B009F; Wed,  9 Sep 2026 06:10:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F56C6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:10:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E9A140167
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:10:27 +0000 (UTC)
X-FDA: 85193804094.05.CBE6D11
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C15F1C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:10:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ZRV4p0j/";
	spf=pass (imf21.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsHaeoqxnMhy2GB3rUAu2bzr8hj8izpjrzp8bJJzBnk=;
	b=kLc4b7vZRR32aJepPkKa4RKY758u9aCJ0lN7/bkUn+rlYs5VbDUNj1qfDuygZebtYhBROI
	xqci5b7F9ctJfGjOy43z2XACCg1ZSMiCC0unoN8j01kYTbKmt67yyIte2JFtKFEL5rd2WB
	EiXBRGma55N+eGSHcbJt59zTe6xZ+kw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948625;
	b=httySzQFDsjPwwtXfKzqhZTspOlko2J2raBPLZKFGFxRYtiBc2O8xRE0ae0lU7rcipuBwV
	lc9ws+ww10wKEmG83jVQuv40KU2RoWlp8FGO1Tfd01TVa41AZy/whT9xMsBgQ7LTn9FJyg
	LrOpjZEjUyItti4BsoLqdv3A28RQ/JM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ZRV4p0j/";
	spf=pass (imf21.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66fb8a78ad2so6947910d50.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788948625; x=1789553425; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lsHaeoqxnMhy2GB3rUAu2bzr8hj8izpjrzp8bJJzBnk=;
        b=ZRV4p0j/peYPRPDzBnBBTl2lJ1MQlvXh4qClfESDmqmHg8oQLShFk97fTcZ4DV/198
         PNzEMWxkPPmuaAUZMqn5749+QyCrfT1PQKNam0xcHGD3aMSNKTDfMxAollUcJfoZM9eU
         qPnsfYdvVclWQ+6ZKsZCGNzhMjeOmsrlhZM7MSir3gvZ9wYViUSP9rE6bIEFBaqn9jX2
         S4wZvfJ/Uvn12T8tjEnfHUs2b6m2l1LuiQttIKbuzQK5xiKQ2G+ddS2EUyZz71Md1oq7
         Sc8wLtQVeR7Zuw9fMUne1yJOF3hPNJNmckh+hxLcBBgqW3biDNGhnTcQOS1gUjs6AhxV
         MTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948625; x=1789553425;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lsHaeoqxnMhy2GB3rUAu2bzr8hj8izpjrzp8bJJzBnk=;
        b=my2q1emrLliQ5OVCLmQa6Anl60mceRhe1ujsGbFWp91jZo8REbnkZlF16j0fkhTKNW
         XMqpoCEFDl3k/2kPd1BNwUHch6y4wYB+d7lXGdmb89civoJGxcbbDBQ8OBqsA9fAnSk1
         nLWZqNJus9/h59q60qBcHL96Q6M1zZDjOTcg35W8Vo0NLZGlY5KYlpC/igRWtaqy1/eD
         4JkspGVJWj2e6vp6b2dYMARTFmW+VkQPB3+YrEscv8CHHDy/fcE5FTmb6NMQVNtNmJh/
         JdidAXRUKt1ycZG0pR6fDA8RLvIwv2eDtiZPWBVhxLoZ845Yuchi2TTnHYlka3MAK2GO
         bgxg==
X-Forwarded-Encrypted: i=1; AKwUvBydT/7oy4Mf36rpYFGOzo/xe7oM+jlKBLcxkh63iipOv22V84nihspmbu/XC9uJCvL/QLQgcf+hrw==@kvack.org
X-Gm-Message-State: AFuF++kbgTy4axRHpZ1rXKvICoV1i/haMFtux0/WuQKBr9WFyDqs40oB
	AlP8Z6sgMPjdV80EUXqC6tsXKtaJjLE2w8+E8Boel2klb7rM4kRZCVW7tyuLd8CWJA==
X-Gm-Gg: AYBFou1/DE6OiXVKcssK/3gIZWt4izKgAJGdPViJsV9UJ3fsPCliH0niWDC/UjINcW5
	RfCnFBVSG+4XVls8phoaXi+E34/xvtI3USVBEsIuT5PmXbk73BA2NOv+c3i0KFSi2Q+IIdEeNG3
	Zy50f2pAZJ4xL1MsicRPKCu/AlC2BkbXwSPm47Hsk8R2JLjdOOvHzZEW3VFosmDFKUqnW/GPjq6
	q1cVZhBNbSZv3yJpEGHMexjLYCckYE/sWbhl+VGE6UKLg9GFXNPpZS/sHMhfuVQ55o9P+vTJkg1
	+mfRf3Jl/HR8TrsE4Uzw+e1IMQdrsWS60CkaCPK6k/qMoUQdak3H+mF2CXrwsojyBfInw1huo0k
	lda9kDzC3dmK6LwL1CFU+2V4YHZZ9jKu0uI58YQJYXu2QT0/QaaPPpRLEWeaNeN3RorKmczT9DP
	rEF9eEo0q1UYt3hcs3hnsqeFBhRwmFxsZrXBpHjS00UM6gh6s1MtO8C0axfWGt/EVwmce/5c7X1
	ACh+1cDWodZetawFEBVw7PpCUGHS32JhWeiNPT+ApfTkmjeq/07cfXg8hg=
X-Received: by 2002:a53:ad49:0:b0:66f:c1bc:4095 with SMTP id 956f58d0204a3-66fc1bc4852mr7414444d50.88.1788948624105;
        Wed, 09 Sep 2026 03:10:24 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb48b374bsm12096623d50.3.2026.09.09.03.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:10:22 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:10:17 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
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
Subject: [PATCH v2 14/26] mm/fbatch: no lru_add_drain() nor _all() for
 memfd_wait_for_pins()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <5b393933-b097-9d70-be09-2d00c8d62f6b@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: m1wcsbyuf9nw5oarmzk4c5ypxmt1sbe6
X-Rspamd-Queue-Id: 9C15F1C0002
X-HE-Tag: 1788948625-855660
X-HE-Meta: U2FsdGVkX1/j9fYinIAtgXDrLxl5joq2fgDLCpmZmke4fbBdAs8IEHr7w6gfDbMEMHiHl2Oy7AEbhzFgzEZj1QvRvtFN0XP5tiEpQ4qGAfW0ZG5yciBoIoCBLrGyxJFokmTDlPpstzpgd5ffmnr1c2yvdi+AJvTvOr05c4LHpNcvwrOLw5UA2Q+HffmsqSNpbrijerYE5cY/WbAOAKAk5UVLHo4ke3BKPAzS2m/OHq3f8k/9VUUICGYZRyuywS+Sur0QtWe8qAsfPv2A9FCmNsNoEbr4vvnQmpmz4QXAMLMABE19k7ybcTleAWlEu1iB95CJ4jFtAR8JU+YMkFn4YCbyAaVfi3nqKfvFPLdFVDT4rkkPSieP4kDnKFMO5iNisJkm4Vs7ttpqOvh12C1qqN7APEBeB+REq+btXijdGgVijfe2tQvtseFJEpX74fLw8xqdc6d/kS/a2eWqE0rv9Kz58QTxKXZk/pMNjwhM2/D6lg6s6euIkIo63QyEoTEW1ikQ9IZKZMv9aNi1MOtQOTrjMob5pmXbJdBb2CqisvzkH4YYxOceUmyoibubW9xVo+WwKVMZ2gJHSG9eaIA+Wqp2UD2O1jneY5cim9qYIqYIesdyfawKi1p0GXbtHaP9DC57D8gbnKaJhRyxiPv2SANhPM6bxhZzXQ/zNJhWzy293atsNp4eTywIwfSQEiEeNuq4in3BOjDVtAu9P4s7JKQJ5fCTUnbfPZLDfBfQ/b2KHBfS8MzTzD2KL/YGA6oiqGtsuz3SptAmsljiuCZWv7XPZu102J5vJvIX/ls51XyGo+t60YH1tqE2nXLrXE/uXP1ZceKisUr2qGqIJTRfHwxSuzZkEzW2w5FsKbSAlfRh2F7jxyI6fjShCNH4gYPcI8VYH/HxUv+qFEWhIHwXdnFKDJYYuYOf+ZeXOsbI6/Ss4adO7+xTXxLR5Eb6XPbdVXt3V+8+nvElpOG7x1k
 OPgy+L4N
 YPtkOYTXrGDAoVbMR/I9Uhad+sYh5uNyykKkxYn364Bed95guTrOU1y2T8ckWMmknHdmDM9OLVDGziN4+wpS7mzelfVw1Hd0aQKCjVYn4F+tqrN9N0tY7dcU1m2gi038HFEic59+frN32L2ibPwYljRsa383jUWqOqE5fiPqgfI4jY0xWSOkvc39nPB3/hsA0ERjTjGnujs5HJlhCQqUHNqsuBZUy02nv6vwCMN4h8bS9CTgIX82CnZOQJZHHKAdtJ+sclAIUiLSPEnjpcf5FbJaHg9FtESS6gOKXMrD7tm7gZaCZ6BGoDD8vpqOfOcpUzg1V2KHu1qs8ztVmAKsC7+WMGEDCUDO+PkRqoB3UjWOJjfCb9JHDJoSXSYhFT6+RvCmEguZS8x9jn85+3MBIYU/E3YP80IrIqNVMAVgSwjUX46Xj7LS97h0nK5hA/Uu7mVFOtJKbzImopDl+MnLU+YvlRphWoNh5hkqs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_tag_pins() used lru_add_drain(), memfd_wait_for_pins() then used
lru_add_drain_all(): remove those calls, no longer useful now that the
per-cpu fbatch references are gone.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/memfd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index c708d92533f4..064f24dcddaa 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -40,8 +40,6 @@ static void memfd_tag_pins(struct xa_state *xas)
 	struct folio *folio;
 	int latency = 0;
 
-	lru_add_drain();
-
 	xas_lock_irq(xas);
 	xas_for_each(xas, folio, ULONG_MAX) {
 		if (!xa_is_value(folio) && memfd_folio_has_extra_refs(folio))
@@ -168,9 +166,7 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 		if (!xas_marked(&xas, MEMFD_TAG_PINNED))
 			break;
 
-		if (!scan)
-			lru_add_drain_all();
-		else if (schedule_timeout_killable((HZ << scan) / 200))
+		if (scan && schedule_timeout_killable((HZ << scan) / 200))
 			scan = LAST_SCAN;
 
 		xas_set(&xas, 0);
-- 
2.51.0


