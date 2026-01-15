Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C32D3CC9E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 01:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545566B0005; Wed, 14 Jan 2026 20:42:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2DE6B0089; Wed, 14 Jan 2026 20:42:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405726B008A; Wed, 14 Jan 2026 20:42:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 310C36B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:42:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9C155648B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:42:16 +0000 (UTC)
X-FDA: 84332497872.12.5ADBE80
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf15.hostedemail.com (Postfix) with ESMTP id B4DB6A0003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:42:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768441334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KDUg9V+e32mue4bpvU6EUm0sGQ0VEWHze86noZ+/sGM=;
	b=cqHOhyF0FM/6/9+jX6s9hfB92BUgjTm6ktNZRM1X3goufiSjPEHBkBDrD+EpukoveSV/0F
	ved6NXmR6nQFq8uUOYsgPW2ZigElkTXwyphAWOElAPrnCQEisEuD+WQAOnjO5+K+BZXtUa
	PhygtYkKYPzYKcFU3iKCzBhyGBKlT+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768441334; a=rsa-sha256;
	cv=none;
	b=WYr9RDA1io7SnrM0KypP5mGlOTvM0xDl/mQdj8xlkSNCr8ODLBv/xnYn3torh4h9JvOLbj
	IrR8VDlzFqfYY6puzkZZSJz3JXgXgHp1MLESZ9iZkBU5yo/5x2TE/VyQ+D6hRcN+9yMrj/
	xE2BQOe+swpPgQwY8j5LgHNGUNRkVSM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4ds5M61FSBz8Xs6v;
	Thu, 15 Jan 2026 09:42:10 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 60F1fvqu027662;
	Thu, 15 Jan 2026 09:41:57 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 15 Jan 2026 09:41:58 +0800 (CST)
X-Zmail-TransId: 2afa696845e6ce8-562ab
X-Mailer: Zmail v1.0
Message-ID: <20260115094158027CMmlQ9-DLqT6FPvCswVli@zte.com.cn>
In-Reply-To: <baef0334-02ea-4732-aa0f-029098879cbd@kernel.org>
References: 202601141040594302w9Pnbc3vzQLMkh8bQ80D@zte.com.cn,baef0334-02ea-4732-aa0f-029098879cbd@kernel.org
Date: Thu, 15 Jan 2026 09:41:58 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <hughd@google.com>, <wang.yaxin@zte.com.cn>, <yang.yang29@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <riel@surriel.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAyLzJdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 60F1fvqu027662
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 15 Jan 2026 09:42:10 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 696845F2.000/4ds5M61FSBz8Xs6v
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4DB6A0003
X-Rspam-User: 
X-Stat-Signature: qo1gk9te1izfko43jheojspqyawiw49d
X-HE-Tag: 1768441333-479403
X-HE-Meta: U2FsdGVkX192E45ZtpDyanjlpxkdJDjpenPytUFgKBZ2Omray465ZU8DA2oKmQGAK5BX3yyTTsFsFycgnVnMncC65AXYKs1gF7SCyAru0jzvPn9Dv8hR+wXsM1hUpZCLmf/FHsKf+vPbrrZ0zQQoqvr1Bg28SR6WbwWgTho0TrbHCycdNGKkIXF+dTmej+wSBmBcvPDwkanoD2zsgi6Kj1V5myhAUUiAhAREdOxbi6MSStDj+IkNM6TY98ud2q37gTUPGY1Gwu40pMaGBqK8yDGW9j1auP+NRDCD1HVpINcmvpLlhSejZN65CdlAbLS8mHHeTSJqtqkCf9R9KkaLMRfHQBCqtaMEmhf7/DMuxthum53wrBIf94S1McaqSFyv3wazt+OnbIRzOwzVqIaKvF7AsBdJCVScsUua3MKZedoYLj68bsgMgy35W3h6YVadvtC37UXC7p+ejh2ycB1S1xrbTBrkwMDOsY+Ibu+OLEneezsAJwqZc4JZaYYsWCQP4iCjpUr6rI9lilHZBeq81DnXaDnztWq/Ynzd6con9grL0c4f1H+8diL0lzC+S/HEg3ylJzv70F3ZF2eyeo3UNGbgwuxDTQyfHRdajJXzymeEfBVz4vMPY/fTcRl3L6gvSA69ciCCM9tjQJ4ZmQN0kvSPl/QEJ+pOM6EOUbNKoWxkuSDTtcyDtPoQWoqun0AX6WDrW0rYEi/5aHJmTlcc/UVAtMfm4GqDMhgTScvge6Pm9ZM8crHSJsWXto1dcN597ptbM+o4mGjmRufUIRTEO7tq/IfXXS/CEqTuKSHNpBTcQ9xfRWN7uAu0h0lCGQjqz5VauWcNPls9dXcwzr4Oc1G7/j/n1Wvgeac1m21zk5dN/lJhHCgpSn0b7KFZoswhiLS5YIV/hByaToIhS/YAyME/1mX5ThWr9Ui1w6/u2ZTIQWpfOTOmBR4vJZuNT0LA2SD6KRcvNu/PEmrg8p9
 W45/VslH
 66BJ0UGiOZeSb7dknLY0zfCJ2sjK7ZFA1FvkhQ2yiE8K/yo0e/ZUq13TUYTHQY7vG522mmtPk+2JTMJztR9WG94WrYH3+TNEJzOj8F/EUdb0YPSfKrdIkLJ8IlguT9WZ1CmZIATJQfrtiMEzrrN7AMC24PRw4PEnMLEBweULc/n/DoZCWU9z0SwWaqNUw2GzXVT+NQpgHRj0hdxE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >>> Solution
> >>> ========
> >>> In fact, we can significantly improve performance by passing a more precise
> >>> range based on the given addr. Since the original pages merged by KSM
> >>> correspond to anonymous VMAs, the page offset can be calculated as
> >>> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
> >>> defining:
> >>>
> >>> 	pgoff_start = rmap_item->address >> PAGE_SHIFT;
> >>> 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
> >>>
> >>> Performance
> >>> ===========
> >>> In our real embedded Linux environment, the measured metrcis were as follows:
> >>>
> >>> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> >>> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> >>> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
> >>>               and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> >>> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
> >>>               in a loop of anon_vma_interval_tree_foreach.
> >>>
> >>> The result is as follows:
> >>>
> >>>                    Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> >>> Before patched:  228.65       22169                 22168                    0
> >>> After pacthed:   0.396        3                     0                        2
> >>
> >> Nice improvement.
> >>
> >> Can you make your reproducer available?
> > 
> > I'll do my best to try it. The original test data was derived from real business scenarios,
> > but it's quite complex. I'll try to simplify this high-latency scenario into a more
> > understandable demo as a reproduction program.
> 
> Ah, I thought it was some benchmark ran on an embedded environment.
> 
> How did you end up measuring these numbers?
> 

That was done by inserting livepatch.ko to modify the rmap_walk_ksm().

