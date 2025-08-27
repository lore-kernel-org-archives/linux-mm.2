Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AF8C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD488E012B; Wed, 27 Aug 2025 04:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD088E0105; Wed, 27 Aug 2025 04:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B38C8E012B; Wed, 27 Aug 2025 04:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CFD8B8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:04:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5F7E1A04EC
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:04:21 +0000 (UTC)
X-FDA: 83821799922.13.5741CEF
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id 296DA18000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:04:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3A7yuaAkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3A7yuaAkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756281860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=sxHVcr4q8V65jOks9gvpvjpFTK6bX/1oFkHWPN7MfB4=;
	b=QR1sPbibSwvDrUkqCpzV7WEwvE3VSg37vruZC8/3EnxDaThoEXhg2p7Arvxopsslo1eoqU
	+kvAK2bBAhGsBf8ED0i1JQ6/vSoFL1qJgOPmTYrXF4zP04rXrjplpIOuG0kOkxHkgHcATT
	5/PEdgCss2N59+6kjfExz4w71ZFJE0A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3A7yuaAkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3A7yuaAkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756281860; a=rsa-sha256;
	cv=none;
	b=lZT1uPtcLB+5Hi1Rr51swHWBDPI/fVWHvF61QzubdPvAScbliRIx7I3zk9PdHMGYB6MS19
	5DNDrerZ/pEceJMOC502rNsDUAEWIQFjb14DJWzdfHUYd8ePkx41wE7TwBOblvzW+Udq+9
	lP0ypdZf84WCeWGSs7dw64LcsEEmulM=
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3eeb3f81d74so18751505ab.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756281859; x=1756886659;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sxHVcr4q8V65jOks9gvpvjpFTK6bX/1oFkHWPN7MfB4=;
        b=aHvmghg5ggg42ZZVCZZTQDZmVEA/nzPbDhIahr8BvZ1pwBO7m4Rrq1OX3Rd+jItRM4
         Ue0CpIDtHNSb6/GA7tGXE7j9GNnr5OWxxsGKR62F0PBApwrfKzC2785eBm3c56S5iCwP
         XMAwBwsDsp+aLOrk1YbgehR32m3/lTC/ArpMd7hz9G7Ce8tgV2qkGChKC+gEhrN4OiBm
         VWaOGSilD2FyX0QEljWXGTouwE2HGMlJBYyvrcYF1+eLkO3enNRFm+Buzl5udQcYVtkm
         rehe/+epNM7ulTmUTNk009CpCi9qmQqcaKsaHQ9qXoGtXGdrBzhGXdVFz6RWW3ZViMe/
         wAng==
X-Forwarded-Encrypted: i=1; AJvYcCWGr5tyHrQ1RK9QC4y8EbEpotL2q1iyCRUbtqrnN6JI2aQCcUJfUm9LDbE1Cxabc1IYR+EV7gP2OQ==@kvack.org
X-Gm-Message-State: AOJu0Yx42c4QsxaGvV4FelZ4UTMIieOXAwnPInTlQETDWPzNAYMuDYGD
	ZFVJGwjTXc6gt2feAa2cIz4GCQyKpSGELHDjIstWxMcJvYPDIobrVQrgBb/nYfLG/8pvfx1nXqs
	2OF59JanLXM6ZbMma8gtRKvNiFr25/QwzzB57gvNgJBI/BlV+OFlnaDQpV4s=
X-Google-Smtp-Source: AGHT+IHhTwG0d4J0fjUNtwRBOjl7Sf7ZYgYFu75g0ggmHbkHH+IjWI0x0MYkDpsUbdwmXSGTZ8usiwut0uIHikTdLAQYfm8aZPmW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144b:b0:3ef:d9e7:70e3 with SMTP id
 e9e14a558f8ab-3efd9e77277mr25670685ab.29.1756281859240; Wed, 27 Aug 2025
 01:04:19 -0700 (PDT)
Date: Wed, 27 Aug 2025 01:04:19 -0700
In-Reply-To: <20250827021121.13645-1-richard.weiyang@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68aebc03.a70a0220.3cafd4.0012.GAE@google.com>
Subject: [syzbot ci] Re: mm/pageblock: improve readability of some pageblock handling
From: syzbot ci <syzbot+ci5d256d8b5e60a751@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, richard.weiyang@gmail.com, vbabka@suse.cz, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 296DA18000B
X-Stat-Signature: ssd6yrjrpbfpqzhnj34abpdkbjerjyne
X-Rspam-User: 
X-HE-Tag: 1756281859-521797
X-HE-Meta: U2FsdGVkX1+ctkAllpFkzpNiecnWRNQUuYF4JFe+9MrXxvzIJXZBkR7A6ZT/0UJLnagx1BDYmBkEogTWnvofn9udXpJP6IKTx3JQDgReQ10oe0soFco14QWnvX4HIQm42cVNaPUJb9j0ZTuqaFwIi728kMMgR5btQk5EIGWorOOLfB8ylMxEQEr92/0nGuXzlUSE71zJk15QjmweIEA/oMbPLwzBryucDdN1HUBWixWYncUOHkXCexR20C5Tt4GyqajgqwL9dHrrYlUAXwU7ZPSgBLFwi1AWp+aX2nhNTC2X4eyYPgNlt7PdET940ITmyiTTYLZziZwOYdvKXkOdx0TUdjn+LdJdL2yuoyRdhVSLN0vfhoERzaunUNMwDuhpRQrPNKXoNb08js/lLarpg8TdkqK8INgj/LrEFkBCRiKvoMJNGIJfg3UtLiZBkAw0C1EEldhX8GZfqy+cNmTRgTH2Nr8Ldg5DndYxBoXIwaFjSY2k8s7gAs5UuhlbZl3O76XiFhFKAHh03wayNczxyMDjT+cg0/ECXfn7CvXYjxIuflurSq88+KemiBHHS1zFPROk45fmg5uYV7KM0qviRX85B8us2SMe1TBJdR8klayzTrcAAIfLUnxBaSIuJbBpQRR1XXkfjxbkGuEovWek+bDYXY0B8csFjphJdBahCrpoXeZvvtlEfGkJvsr0HpKb1MiLn7W8AxKHC625IotT520DTAPzgdPnqbgHk9U7K3U44aQOSty7+/fA4snzbsvRNZSZPyVysRgyxzh98+xqLiP8Zu7Uo2lDprjHmFVTL6aoiyRmMHGBpUIVhJU1ZhbD1kRF6MUp/RliFdoYqvw+ctd0vJO6gxtO7WTM1xfKgPcMRprLOmsqiIAyv7Ime0bDv1IJ404TFftMeFc9IUZ+ZDRu/fAf6Bxq5ASJ/719vKGK+xcJr7/MnermfxNxsxUegQSQzNa6RmPVXfaAVWB
 uRa+UyXc
 0HXyAAcagTZnzESHXZRyGjUwVQX0hrbr/kHB2hpg80Z0c/Hco8um3pRNLBBISuvcw8Q3iOInlv1LBtw9r+hDvSNZOtbsIPOse5G+ijDB7P/AacUaHMnMLqEXAiJ5BmH6pMaoO+2xl+mW9jNBaFYU4nsbnfkE1I61JI+ai0M0Ltl4gYD+ivXxKXx/JXW1zktuQOieFSXZMMpHqeixzK197HnBQsgt7fxgxmhLBH0yWHgJ+/juwRagPBl43PdGh28hK+siDr9YY4HJ23QpLup0IBS/DWwllyDljI1pjm9a2ai1DNW3x19j934woAsqkmc1NCIGEzWKxbo5duniUoGz9zqe/e+OUw9VHf30hZ5/fZ5RxTYloInWXOOpDk0A+n5ZOIFuz43P8Al/v2OWZWM8yAi2qoOkZmuYqFdFTDZhA8CWrYBS0LGZN1Tzjjs6PbphgPXadp+Fx45j96G5rIcyHl0sOuQZbC32XDH2ZqJXLIFPA1u1K291d+GcbZTLBuy3rWKqOc43l2fYXM+YCKJ/u3sOQXiei6FzzkInvFeuNheAEKVgUwBnpDqoPovuNrNAsu+sAFQbhRUbUEsnpJtCXKuLJACXdLC2j5n78ZzGMJegRgjZOAgMw5iGbLWEC93PTLqw1CUI/21R4OMSmDGPgetRMsWZxlQcwrNoZXTB/DKAw2YR9Scg/5DaALs8mPhegJDxXrgJffb3upntSHKVooBemgN8kgwl4C24BFnZmORDVLRDLrSDmBmnwfqPLr/KRJSY8wduOeoSLornWkxaMtXyC/DStuU25wmorgqoYncyXNjeHnqrpeaPAfwQuDQLY+KlSYoLUpjGd0wU05dWkMqoGNV9eGY8coIxDzpI6MmoZc1wdYdFo+OxoIQrP9o+K3QayxnChRb5Xeikf6hA5Fztckh/VbI95BWXxRJdwaosY6qlak93R58D+FgXuQR/gnxdEpjg/4WKaTEZLsp/ojFDe8e3l
 V4n3RChO
 1uNhS3lQhCQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm/pageblock: improve readability of some pageblock handling
https://lore.kernel.org/all/20250827021121.13645-1-richard.weiyang@gmail.com
* [Patch v2 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better reading
* [Patch v2 2/2] mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/51db4b94-ae73-4ea0-8cf3-4ea5b7715cf1

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      fab1beda7597fac1cecc01707d55eadb6bbe773c
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/49ee15fe-3add-4064-a3a9-1461fbba8c85/config

mm/page_alloc.c:373:2: error: call to '__compiletime_assert_1636' declared with 'error' attribute: BUILD_BUG_ON failed: __MIGRATE_TYPE_END > MIGRATETYPE_MASK

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

