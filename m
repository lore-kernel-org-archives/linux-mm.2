Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F215CCEACFB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 23:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027748E0009; Fri, 14 Nov 2025 18:10:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF39C8E0005; Fri, 14 Nov 2025 18:10:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB8A8E0009; Fri, 14 Nov 2025 18:10:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6D8D8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:10:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4993413B4C2
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 23:10:07 +0000 (UTC)
X-FDA: 84110757654.17.CFBB22A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 861951C0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 23:10:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9KMTt6r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vgupta@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vgupta@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763161805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cle4/vff5SB1IWD4HNItwK0bPh/1KZ1BFPh6rOzhPmI=;
	b=kDWKIfxdJeVwjFZHZ4dRDRe8QGrKElDDZVfXcln7P3n0EC0Hy1ISc5tmgcruJsj2/IOIkm
	46A2e9KCEsSsGod103i4sOZt1RZNzx+pFLpw5I8u/xJZWKS9LHWBR8eNPVlMZ/yCWhrvXC
	Qwih5KUbmUE1PAmV71QXHrJZSrkXPc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763161805; a=rsa-sha256;
	cv=none;
	b=aq+Ao+e8NmSj+lwmul51lMgUX03Ap5oLgGWxFCYe80JHkYerB6MUo9fgIoY86WsYO1KvWi
	Go47QTxE1zH0S6X/J7KP3vBnjStI5FumGL+ZYSyAGsnNWVdkUDFM7EGb9l8trqY3ICcK67
	rM0lVKTotTTcGV+sTcO7eL2cSTdJB7U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9KMTt6r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vgupta@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vgupta@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED0676022B;
	Fri, 14 Nov 2025 23:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FC2C4CEF5;
	Fri, 14 Nov 2025 23:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763161804;
	bh=Cle4/vff5SB1IWD4HNItwK0bPh/1KZ1BFPh6rOzhPmI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I9KMTt6rN59cZwQZpJIKV4NcU+T4pQVdUxYGYDSFDoq7S5hRKvRZDbqdzueDrp/2D
	 QnsIdVuF0CyJUp98esb2rOB3xt20JSx5c0+UvujPCDuRpfeGcXI4HLpJG9QHtg9Hha
	 kvbE3L7wMltT6S63DUUofMNuw3uQxX+UwDdNoZOH/px2oXTMrbWdSHaAhdoc/5tUux
	 m9uiBlPSPcXa5xCffROA/hh7TIjTSNpmFmGOwzAgLGNXGj1zG9v9zbpOnBca44bXoP
	 ByQEpbj+AReGYeuDeLb3RpcJj2vRBfaG0zsHCZKGPdmCjpiMthlrU5NxNtxLBPuNxp
	 AiwGco9rLD9GA==
Message-ID: <4e120357-6fa3-436a-8474-b07b473381b6@kernel.org>
Date: Fri, 14 Nov 2025 15:10:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] arc: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, david@redhat.com, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Vineet Gupta <vgupta@kernel.org>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <6a4192f5cef3049f123f08cb04ef5cd0179c3281.1763117269.git.zhengqi.arch@bytedance.com>
 <5199c367-aabb-43e7-951e-452657dcdddc@linux.dev>
From: Vineet Gupta <vgupta@kernel.org>
Content-Language: en-US
In-Reply-To: <5199c367-aabb-43e7-951e-452657dcdddc@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3uwx3udijp5jzzb8acgdcjwhszuo39ff
X-Rspam-User: 
X-Rspamd-Queue-Id: 861951C0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763161805-27551
X-HE-Meta: U2FsdGVkX19pqQCV+MR2yt5yDXyE4c7lfYveBhnDrQ6m6YX69jK3bfglYRObnA1VZqXvvOCyTQwAqGODEsZ4khN/0JtiXA2NBaVo17m0G6hguqH6rJkpZOmS7ipMgLgNvtwT+nrkZkmFT3BZC6rLpiqvIu1U5LahnsXNBdsRRnwUqY8ui43hIIycJxzX0L4cBGoqRaZTSCp4coKOgOBBRIyhR3vjIn2Odj7wfbOjhMbxyK8JoLHm5//9ubK/pIuJLCa/F2/oqvjjRdNYi4xGvHzYf/YhH+fPOwXDXKTEerR+XNBFRbR3YHHFni3VJEljZzkWv1MCjQODxX5hSy8+Lu/0ByoJw/eMu7jHs5rOVzQ4fkaCodQ+SOzu9nyuykn8kcT/smC4+qekPU3IrgVVZmq0ApQCTsBAbUZQW3YwgErCUW7Og0ainnsbqVdIxaO67I8LBh4W7se1eAUiUhbIgcZ22D6A+PrSB4dWICQYtRQQf0Id81cq0/ProCW0cJh7tyWMX9OMdMcDmPoSrRtnGReuvuxq6DFUjv1bfF1vj5ONkN5fYloAXMXqRUnH4BntyMaOisHCGSChvJy5LbIxmnmTRL6aB7oegklhe6DD7f345wvW0sKq8eeCrEeKeFT0M5yJiqI5oaf3iGYfcM7M3bT2Ue9RNCol0Gr8KRTYKJEGQigm9/O7pSOqlIr/5wk5HDp7MYbYkkJOYKuh8OyxdVI2e5SE5Je4kNoVXhQz2FVjlYWOOKCI0Gth7tKiBoCy5+CQ5iQbwdkpjvnfQWz8L2xHC6NR17wzY1/kVzw3hbkJB3ecv3PQ4C7U2a0SI2ghxG+C4oc8OmsBOF6IvIE5pJwANC+SLKrHq/pfP6DeXJKU+xrK+FnO/984UId33XMXnXWbcN2ptZCb7qlGo2MoL17HHngF+qVP1xjcJwBfqvhMIIb1+uUUTbqaTuH1rsdRFyh7LcAgVc3Lqg/9Ath
 ypnt+iGY
 WxiqK00nrfiP+LqeqMtO93xbOUdlgEo4hJvyYmiFto9O0hHQMx2rZVwxnxYAbs8hqjVjZzrQMA+wfzw8JUBMo+CQ7n+/Q5dtpYWX07ldt9NfDrVKXqKgr0ObSYNfcyDKy+y7XoFNJa10lrTRGq+Hrctg7SwLv3BK4rWHVg/lO5XnJqHcMDu3+ZhJdoQFJpm5qXU+pTqZtc1B2BON5+EBwdPUBhPnlbD/CxeYLjO6rgVnqfq12mDPyq4jX3Srnmh3LiN4fGUvUOW0sXeLVR3x/EX8xO2c5IF7FgqFmBnjlbLVTDdNJP5PonBnpvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/14/25 03:20, Qi Zheng wrote:
> Strangely, it seems that only ARC does not define CONFIG_64BIT?
>
> Does the ARC architecture support 64-bit? Did I miss something?

ARC is 32-bit only !

-Vineet

