Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31091D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 19:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748386B0005; Sun, 28 Dec 2025 14:46:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FEB6B0089; Sun, 28 Dec 2025 14:46:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656616B008A; Sun, 28 Dec 2025 14:46:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55D416B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 14:46:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD37A13AFDD
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:46:26 +0000 (UTC)
X-FDA: 84269911572.09.3B0D8B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F71A4000D
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:46:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DAG6VbAI;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766951185; a=rsa-sha256;
	cv=none;
	b=qObanUJUKZhIcVhZbMjqiPwS1Q8A/UWVcjAN7rYl3/jjJtpBzfnqTv8fLy2JWmayCbTQFu
	M5iD/MHC3UdT7+jhvsqudaVbB/c8fEfBej37Cu+6nZ7TmnA5MgEo4OPR9fV4McA2llBnaH
	MOyqAum/aRgceJ5vNnGamSXNi2zYOl8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DAG6VbAI;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766951185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MU4OZ+8nT6anh4/48XvLTpxozvNlZ7pzlrFaPvlby/4=;
	b=JeOZB8o9tUepqX82d90Hf29e5FHyQ29FLPax2WMcDiGooUN8uz4MR22/OZH3FHH6j7acPc
	zZsU5RzVLJ9jdPfbvkJqkSkSQdRYgYmJaj2UV60KJm6x9BbxqS5uo6My4Ev/sUzpdc1Ah8
	JlCioIFquaDnQ4yUdRrJwPVRxmODoeo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4439D60010;
	Sun, 28 Dec 2025 19:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1ABC4CEFB;
	Sun, 28 Dec 2025 19:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766951184;
	bh=6nW1WENMXiAfbDMRimEemcFR9gxrqRUkvR2ijyJV1+M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DAG6VbAIZGPSVOYu1fPPxCzJ+Xowcq2MnBMEoDLf8nC/4Klx4BEbVH1XOClQjkWsW
	 qE/N3SrUD2x8eUhAGQnn9aIpXT33/xZUu0OYg8vgCeJUQ3rfrQEsZAIUKI3CBBB+Nw
	 vocqZwynw1OVsSp08FKHg13bHRD8IDYuy5tKrgek=
Date: Sun, 28 Dec 2025 11:46:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, Johannes
 Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal
 Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel
 Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-Id: <20251228114622.9a8534ede47866c42322b0b3@linux-foundation.org>
In-Reply-To: <20251226080042.291657-1-jiayuan.chen@linux.dev>
References: <20251226080042.291657-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F71A4000D
X-Stat-Signature: 5bc19hmyitpyhykqd7ssinzn4x84bda8
X-Rspam-User: 
X-HE-Tag: 1766951185-364418
X-HE-Meta: U2FsdGVkX18rbQH/u64hWOlZLyW4WeTg2q7DKC6ljbuoU01SsfxW4yCBGhfqOCZKdQts0/7qfycmY/mL0BmaTuWhOSllMRrmDOpiwpPTvKlluF7og997WalnjcFhKsq6pNBAdEuQANQIIpubGAUXF8rKFHafQTiUi5pTLJfG0cm/VGBuy/1oMbQk65Pef91v8X/empD89rolGEpNABGOdtlX6l0k/OAZEmDKFuVS+If90E/tMwdctbk5o9WTtZD1W9SbuNOpfjIJoVrWbcVptkWomop/4CHz33dH9gXtByIIiJ9BPHMLXvVCQ10ZdaAA9NXuf0RtfHXFyCFFtB2scFeItFqNjuWBecCIm58uJijnmdjLRAXBW8xkdFvhgOyiGyX0EhaecdUfhfLOSoq1Er0oU2Oq6ADTy8AfqdhhF+QkxiK7jbnCuKEbL/gLb5H8HU7+oUMyTUKQyjcwyxhQ2M8Jdkw6hnYPm6HDyShwKIR/I0wPSpxGKgo5PGwqRuBL6SL6RdV+fG38KNr7rwkm2ucDqtiRXXubbdqj+PiUjFCaRZVKeIjpyNswweel3ZwVPrEvXt4saXvSKGAbkLT+lFYwhaLKZTWSKBAI4wgf6NvBqBy/7PgZskuKCnPxFFac3lID2L715bNxFmtjxEVuG5gPFeZVdP8k8j45sEdZadLrnMZU4aMKiiKw9IHHhpS8aXyLApY7xpHqFtjfc/n9a5elhTbCOCeXfwiw50/re33+Jyq/5Vyj7A+vTP4DWKExyS1frAFayvQJ4/yFFT0jXl9+LEnVS++0e68EsV3pg3hmgUATfZY6C1bWFO2FNR8v+a3VT40+GSKdLzZlpLW1ZxqlaBDoBIa1hWAhyPgnPYnK5o8pn5nsImU1tS0GvfgSLMp4ZY05sgZSg6y4sCjYXD6fTwB+jolCG3fdfzPwdJC0fXWdi+yeFl/lyVcUELsdAq3qY7YSpaxAv2mSxDd
 cfTAIjnK
 JA8rW7Re/7uwQcQiPWTcMDT2+9WUzylIGqEcphsBrtZqUoCkedsAX9NnEfF13J0oxys9x9MvHq0Gv6GDgPkI1eKFB247UQ+71+g+8GbFsvTWPJeu89wALnSCbqLWUxZDk7I6JrP0/KWMl670FsXRPOwf7PFNbWMhXlYTEUFsgWCWXIMWjGFFVDktRqWpwSz68nvPjzHOpwL4oZ4f1pngI0xwphH1TS8Dq5hREonie4H2ZmPpDpLNtOvMwywuPZPoU35/Ob5gOFqOMrWjwKgEXGrgsSmlUIk7+InykA5rkQAjvPQ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 16:00:42 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> This is v2 of this patch series. For v1, see [1].

This isn't significantly different from v1.  You appear to be
mid-discussion with Shakeel on v1.

I guess I'll toss v2 into mm.git for some additional exposure but
please let's continue that discussion.



