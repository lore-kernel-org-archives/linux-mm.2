Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC282606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQ1mHGE8
Received: by kanga.kvack.org (Postfix)
	id E22566B00EF; Tue, 10 Nov 2026 11:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9CF6B05B0; Tue, 10 Nov 2026 11:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37546B05B1; Tue, 10 Nov 2026 11:52:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC8BA6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:52:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE0C2C0965
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:52:20 +0000 (UTC)
X-FDA: 85419802440.12.88B8C74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27F8680003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:52:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KQ1mHGE8;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329539;
	b=PpbFxmBK5V9urjoJQmpM0mCIJiHMbmyIhRetMRG0TmvSprA5A6x5kKRosW3ZtF18Irgb/N
	0O5FY6Z2XBFS2Anz/k/0xSmFdP7D2CeIEjmk47T48i+R57iiziLp6hrxPBHHnA3k20mdej
	yTiw8aNMJTObJFODkvdePtV60ugsWRQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KQ1mHGE8;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwKYe1FZ8TSRCRSLvx8CKLmwrOieUAZJ4xTeOLFE+8c=;
	b=zdHkhh8/Qa068YZcv5M92MAfUURdXzZnfrVAntmhIEiEuLHxg/XuWIDt9h+7Q04JufvkuO
	H8Czau+rWaCxdPsg4NAAUeedAQussQ6iu/p/9q4vjU/bAxgJA0a7gJJPgjZ/BCA4TNIwb+
	pOh/J7AXXhziXj/2k/Ca/E0XHf1yFmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 536AA408D4;
	Tue, 10 Nov 2026 16:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168DC1F008A1;
	Tue, 10 Nov 2026 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329538;
	bh=RwKYe1FZ8TSRCRSLvx8CKLmwrOieUAZJ4xTeOLFE+8c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=KQ1mHGE8yDsko9wqUMNuJqUyMQU4njRf7yvHVhukpRSCc6PfyquBs5m7hxr5sSArv
	 Tz8v81Y+mNybeIkmWrNBMgDD9oQ10c/9DglWEo/UyBsKq6CBzKGGuoTcSIsqaaE3QR
	 gVzEFTQlk6hiVis6FVdj/oDJDlYfn5eWHLkvd8qT1JfzgN47Pw+nI4hgwwz12QLrhx
	 qS9fzK0IwYyzeuJLa1vs0fum+PP8qXejEMm2XhWTfYuirC0gKU49ervzU1QbDPfflC
	 3b+22qhaH+s1qqA4SNiPRV9k0uOtKXH2ZOvAWqhCJ5Ddns6r6RDq7kEEJwT7QHNe6o
	 Wo8L2+30e0TbQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,  George
 Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,  Sourabh
 Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] kho: walk bootmem areas in address order
In-Reply-To: <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org> (Mike
	Rapoport's message of "Wed, 04 Nov 2026 18:50:09 +0200")
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
	<20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
Date: Tue, 10 Nov 2026 17:52:14 +0100
Message-ID: <2vxz7bikiq81.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 6mm74a4bf8o77a6hgrenpu9ym7u13z6e
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 27F8680003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794329538-299197
X-HE-Meta: U2FsdGVkX191gbYHDWTIKeof23zn8dWIaJwDZKYSSNTrr/2x478VhmI7PTS1a2M5A71B01yqxcIc9mCoEQ7DInOUoK5F7UjCLTR66ZDYXfRso6UYBMpylPsOouL89K0dq1ua/1E5RNC23B7klxtslwPluqUvekzsc8jE00FNue+oZzArC9DpRe6aehrYrY2+FhVzyK1ZoDnabHxPr/UOTw7nApAawKw6C40U17VpgGid7Q+9dt4a5Zf36i2mI1ckXRG/2oki5tkmKAw2iAgxjcUgHTtaYKNnHOZNzwTXbKD4Y4U0E80KpymJgYpeAI6LINGwzDyR6V2yobCQBvS+eAsrAbvpamRrB0YtkXTVGfW2DNqTMHrszYO9aAoM7qCwC7bjkDtdpdz1LJ2HPFHUMpvsAQ7faMoWU9QSBBf5IEwjbyl/1Fq5R5c7x5XHxvCI+lhImJvwfvMpFHqqTHuZYtL6O37l6xJz4NT+hlnvOIxNKEndDcG9MxaQMLhx4CSOvarLRycjeq4zrL7HnriLX9mJiJzEr1OpnQ+S/p4kyzVU28LeOgPNRBruwgLBlBRCIFIjoteuxgk+7nlEWpNpModZJsMgSBd01rwKZvKkhV3uwM8xhgTLN2KyhL/4pkT24SJSz1yOPUK51X9pldiuzGATANOdDiDkuHvgxWtcTf17Rzf/EDuuXAzXf7sempPw0YBoLkIrQVF+d98UuXuGJP19gWmxPm6KniaUdP7pLA5zjia9OHnC5nUrVpeVOn07NFQ6mXcAlLP0AWvKJapjybERWoXnqVbS5zYuuWbwpDjMR1zqxwPqCcoQ4FETbh8vIWB8b70jgQD1goHrIlvdgNAC+w0ZlSjsMPJoT7Utx8pH43XNYHBsDOQsP/8WwGRyBTY+42opvYBaYQtqY6lZ/gy4EdLn5ummLKirLUeOjyQiZLJviCETaDiCuFyyox8zKQXAaXM+PQ6R5hwqBau
 DKNqnqnQ
 SnhY+T6YPfpwONpnFL9R6hQa/cwDrYmTfW441UFit8xmp3cDIritY2mSzkTsKmqt2EQZ88KUts53+whkmOUiQwX2kT5xrEoIt9ULSfdp8XL2aQ6YJ8n3grS6CukreV0IscP9tVGAj8hFZqZZ1PJsIqgc72Spm+a1uLefKH9x0UY/TGmQMdpXvWfgSQWYRkZW2CxVQT8nJx6jlGD10Dbqxr8Wj+xCiRtvKVo1c/cCAW/pr68o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, Mike Rapoport (Microsoft) wrote:

> kexec_add_buffer() users may depend on the order in which memory holes are
> searched. For instance, arm64 places the kernel bottom-up and then
> requires the DTB to be above the kernel.
>
> kho_walk_bootmem() walks the bootmem areas in the order they were
> reserved, so if the kernel lands in a small area at the top of the memory
> there is no room left for the DTB and kexec fails. For example, on an
> arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
> reserved first at the top of the memory, the kernel image takes most of
> it and kexec fails with
>
>   kexec_file(Image): Could not find any suitable kernel location!
>
> Sort the bootmem areas by address and walk them in ascending order, or in
> descending order for top-down searches, like kexec_walk_resources() does.
>
> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

