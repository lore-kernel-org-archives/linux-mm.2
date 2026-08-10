Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB5CC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AE86B00AC; Mon, 10 Aug 2026 10:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362076B00AD; Mon, 10 Aug 2026 10:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29F2E6B00AE; Mon, 10 Aug 2026 10:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFC1C6B00AC
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:42:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52B4E801AE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:42:41 +0000 (UTC)
X-FDA: 85085626122.20.9079860
Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D489C000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:42:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=mkwJrvOu;
	spf=pass (imf10.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786372959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=2hiFBSdy7ThMtvj+ZlexYBwz4mqUTCW5FnQ3rSMFV4I=;
	b=ft8dL5PxwfvSJ5n91cmdoyuNYH8+AIy1nxHb98NBf//foeEPWUXkeOGBXFfcNb9oponh9a
	C3GgqnkHZGCwvqtbWWUXG7cYG8V7LChoxnfAq0YC9C4L10VMhaqvVyfVZn3VoMEAaMXDw1
	r4sqDje3BzZ5oBSWrTpWOLnaTWEbITQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=mkwJrvOu;
	spf=pass (imf10.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786372959;
	b=v3CrB2nC5ytLqgZKMma4t4/X0GgHDZlVGIShBHX6mfM+p4GtdzQSZ3uNChhGw/u4F0PcT4
	FieAivZwMMXILru5D9xHfqCIOjX3KJGgkU3ojRwVrHrkS5+84ebOwFd4+5rFDivusXmR5v
	X3AlZ1tNBpga4ZgSPG/LEVgRTfUKk2s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786372956;
	bh=2hiFBSdy7ThMtvj+ZlexYBwz4mqUTCW5FnQ3rSMFV4I=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=mkwJrvOuE026sm3XI6fTVDkbFjBBTw4UCP6T8ekTZkarPrh4i2aFXJGgOSkQj6Y3y
	 7L1kdQLU1kGa++AD7LFxRUT4+kHX2upbvYBa4Hbic3hyBi/M+KuRL968YXI9KwBRXK
	 CVrZSHvI3j3LrQfpTbdQZDLVLASZzdWi7CDM2gcw=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4hJct40J4Gz10tW;
	Mon, 10 Aug 2026 14:42:36 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4hJct3484tz10ss;
	Mon, 10 Aug 2026 14:42:35 +0000 (UTC)
Date: Mon, 10 Aug 2026 15:42:37 +0100
From: Bradley Morgan <include@grrlz.net>
To: leitao@debian.org
CC: akpm@linux-foundation.org, baoquan.he@linux.dev, david@kernel.org,
 kas@kernel.org, kernel-team@meta.com, kexec@lists.infradead.org,
 liam@infradead.org, linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, nao.horiguchi@gmail.com,
 pasha.tatashin@soleen.com, pratyush@kernel.org, riel@surriel.com,
 rmikey@meta.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5=5D_kexec=3A_keep_the_next?=
 =?US-ASCII?Q?_kernel_off_hardware-poisoned_pages?=
In-Reply-To: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
Message-ID: <59D6BB94-6379-46FA-9A54-C8CDE660CFF2@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D489C000B
X-Stat-Signature: p4bff7jfowdb3mgo4ur15zi6bndj47f5
X-HE-Tag: 1786372959-819580
X-HE-Meta: U2FsdGVkX189ovzXSck4HAUgqewMYhoBquAuXHWvqYDzK9Ol0LXBEcHZNnOSl9Rn6mZzjkmGTVy4wHNPC5v9StzSIguiQGUgnzgTPbpuwexK5vMQdeM6fVvaM+q9NBFYSNMk0ot2G2CXU5gs6AyEpH9GoXrwGQLskFRho/mqViCJhATf5sdV/zoxoK4tvhqB5K/FHFvS2UPEOnDpuIIb5MPSGFjt5ZW8amSJapSMADCQqpJyEqRB1mjlVgHUVKr98Y4pU+x/vx0RNXPat8sX/OKBXga9jDWHcZfmduWHsbGn/ekgtplNnWCVXNgGap2Fcw/pTuFOrNmczbP5rvkyIGNhQ3StnbCS1UPFvjhtqZYh4l8hF/5x3JHVuFaWVSAE25KcgS+BrPTwYFELwEvVrXMIMBTWIIv77DgpNoJ6w7WDw85L7vEiaB0SLDZUjinMWBx+VqapcQxvu11HjtV8eka64kGo0m+E0RQG7GWmZNga9oO836O12r/qSYdXPZPWM/5wsb+SJzO9p2zrFeVH5neIGMKFUvw/NE1UPZilqH/sevG1pOw0BRq2UsvdwUW0eXSTvZDrKDXhQjVkfW/Zaj6IfQsKqdtv4cgW0eS4Ey/hrHbeNRZCG0VEDudY/2gZN25/+8iK3axsopXlwKvQnGTX6Fe3v3anKNnHOVZL14DtC/SlnaXu/u0XVohkBgmygoPynWqhKXdsoRdvKKI6/Z7rXISbH0tFUyoDeysZNIFwbNOMm44hgEn+epjUlCozYyclQMMB8mCqZezi3BO7MK5AtSClULpZrrxa0/1U9xJM+dMSDg9IEdZhy/g+LuywGwum+lSVn4hwRIp0HRFvnvx9w7qkXsIhZlvLTYhOQObPEXnaaJBeKNztCTy/2Ge8n4Z506zTrmt1N9ytn9xJ908hekiaKW6KVb0pXOLZ9PEgBuonX1rXaoeVivhU41Kot3zScyeLvosQG9YU5PH
 m3ab7mYh
 7iIbvJDDb7I+c42kw8eOsr0a2aYytWpZ2gQuGi3Zx/UTpSoG0goLlBj9M1k43zmnC5GtgUJnm9Xmzno5FWHCe22oscbj+fJmFbLr2rG5pAgEGM1fPMlCdGTXm66/emHZw2aBXQ2lxQUIz4ysYMTIv41EAz1QSSYEe51HHIOD3qj1OZBPpsZroxYWAGQAod4nSR680Y9+i1NRJGgxfRKAR1O/l6w6HjIHJZyCisGZwCn3pBWyqdscLorc9/i5QteT7m9N0EwGrs2/4T9WtBQ9o2UYGexhLxDaIdq4PxHBY4ihBmWY3F2DEfRaCPyKAEr1wZCVNQlxwP/eKwzzsbEL/u5W73dnGP8fss9mLaQ1ehWRhlvW/PlZcMpdYQ5YpCyT9WlqrSfG58W2cv50DUudY7kra6PU9NQsSC6iIToEphEpF6J8PcfeT1tVx5/fiqvvYDFyvfpM807GZL1/iZdIxomJpg19GtQSKIDcYoPlQR06C+jrk85xyrYoNYTgyt5XmbqGa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, I feel this looks right to me.

Reviewed-by: Bradley Morgan <include@grrlz.net>


Thanks!

