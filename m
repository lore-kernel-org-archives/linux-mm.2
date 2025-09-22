Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55FECAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A9B8E0001; Mon, 22 Sep 2025 04:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142658E0014; Mon, 22 Sep 2025 04:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060EF8E0001; Mon, 22 Sep 2025 04:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E853E8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:47:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E850BA154
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:47:13 +0000 (UTC)
X-FDA: 83916256746.14.2F8B74C
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2606140007
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:47:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758530831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHzyKmzufjHQ/1CbKy67U93TyoOgKjt5Maf2C2a8kVE=;
	b=X/hg14luhOyDM6nVTTQyx/gkv6JWLhOa8VVmHHbZKRb2FkMczfT/pf+tWCJILbm4ZRw+QH
	oQWA2VvHG4Qu3gcClpphNNU8qVDyhrqhZlchQKguEmvblCDTEm2u4CIEEUNhQJbZLwv2sf
	MY8RJa8i/bpvNyCvtNc33c7bTUCre0s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758530831; a=rsa-sha256;
	cv=none;
	b=T5PjmWLopuPv0dmY5s/udx5InxfGFhVc3NSjkABD56qCZeIaFwtVwkHcBRds2OjLEIMhKE
	pDJc+KVaZokompX7+vSvWwd6cMCbaTGhkNFdhj89S1Bb//H8Hf9El0g3RrVQTsuacINoMS
	GONMRNnetM2d9Rj/u5eEaUkYWfcfYAI=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cVc790n5szddJw;
	Mon, 22 Sep 2025 16:42:29 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id EEB591402DB;
	Mon, 22 Sep 2025 16:47:06 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.108.232) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Sep 2025 16:47:05 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@redhat.com>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <ardb@kernel.org>,
	<arnd@arndb.de>, <dave@vasilevsky.ca>, <ebiggers@kernel.org>,
	<kees@kernel.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linmiaohe@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux@armlinux.org.uk>, <lorenzo.stoakes@oracle.com>, <mhocko@suse.com>,
	<minchan@kernel.org>, <nao.horiguchi@gmail.com>, <nathan@kernel.org>,
	<peterz@infradead.org>, <rmk+kernel@armlinux.org.uk>, <rostedt@goodmis.org>,
	<rppt@kernel.org>, <surenb@google.com>, <vbabka@suse.cz>, <will@kernel.org>,
	<xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH 1/2] ARM: mm: support memory-failure
Date: Mon, 22 Sep 2025 16:47:01 +0800
Message-ID: <20250922084701.27811-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <91041fd5-ca37-4a6f-981c-74aa92bb2291@redhat.com>
References: <91041fd5-ca37-4a6f-981c-74aa92bb2291@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.108.232]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: F2606140007
X-Stat-Signature: 6egswc6akse48cnjs5p87rim4n5k14uz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758530830-764775
X-HE-Meta: U2FsdGVkX1/3Yt7mFNY9XlUkWOy8SnZdkKtFdQbXocQ7QGR3qcI7KSOFxYGkfWHKhUEIqx1pQ6ygk9g7HVF1u91poMx8mLzrDXtkuESrL54aatRdKBm0RbDNKHD8EpmXgzO40PrCtKxhJI1PP8rAOTd+DAtB//1JcPUhzCEf1sA9oYlJyAyH9K8b50FZVTJRD9cqSXIQkk4LsQOLw32X7mNLjtYCd6vU0QYNQr4Zhkmy5Pbu1WlUWKMx6T90tceSdVrO+Lb8pDuWVqOq5viMeUhiiNCk+PqlPUfGDrQ0mjp+64oUuYVvLc3xVPaEEHhRvjiwCmtXrIx2g4/ge50i9MSFuP8VfSEvsxSVW0do4c8i1h0nW4Lsxu3RhXA4W2gi3Kah8bs4xGGqRnzXTDy58SXpiIVq7qnaTwJeyoMpZaXfLpqkZ4zthchbPELOR58SlgUM1c3GKBwayFo0/r7AYIbeO4rQu8O0F/282uXgKIWlXH7Y2ltWqDEVIrWF+oLElRQ27ua+m9TleW7h8V/6MZ15vp24+omyvW68An+6yHZKjIykSmXkTRdpsYiTwfQLLnMZWAr1COky58kDyznBuG/ZTUeqzOZ2F8HjHb0NzEQZmFO7FGiaNVf0s19vPVg4sZDawLwV5W0Woc6V3/H8ZpMPB1UXtng8HlDpryS8QG5i81b523St+7R+fNbW9s2vJT3n7FpPLrUsRtP3TXZOKHVQwJId/pBP0iPRkMf8s+XhvgOL4eJzzI6hCWncJShSp3aFwN3rbhiys/xFNx1Thj0vPjQmstCGegab6anO+nv0tL0e608jTBuyop2fLJLCiYuKlEvlGQO01G0+LGdW1PyON2qotReTCDjaJHZXcHSx7X05okwQ7BG9PqDYGFJLlkPwKVcjZrdO2NHDADHzGe8xfYjWrWAuud6/Qj7gAxymhTk4Ctl4nSXftf5rHQIJ2RDtJup+pNXSFvQW85h
 6mBwS1wx
 D+79T/9T864usluuQ+E1HL2Tla/y+ySfQLXLcw0ZtPTfQVrytEpW2wUezKTqBuBuWJuTdczEEghd4Pp23cf/3k4lv3CyJlkLkXcZYqcf3VCLWJ2pJTz5ZyhFv6ph1FAw99cASgRsVPaXkP83qc8SCMsYD4Hk2XCwXoTz2gdW/s5HxWV44dzR57GxgNmLflaVvltH9CDV+hDM0wOEwXd+nRDAd++yD6vU+/x7VG+QbaQPQbHgp5YV17z7Atw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David/dhildenb wrote:
> Can you send a patch to remove the "select MEMORY_ISOLATION" independent 
> of any arm changes?

With pleasure, I will send a patch later.

Xie Yuanbin

