Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FF9CFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 02:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168D46B002E; Mon, 24 Nov 2025 21:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119B46B002F; Mon, 24 Nov 2025 21:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056F26B0031; Mon, 24 Nov 2025 21:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EACE36B002E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:47:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B190213B683
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:47:34 +0000 (UTC)
X-FDA: 84147593628.11.3AE54BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 29E801A0004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:47:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HplQ5l70;
	spf=pass (imf19.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764038853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnSTdSp1Gs/2mPj6MUBO+b5EW/Ccr8hmJDH6A2dLkSs=;
	b=Mq1vkLU5k+VlhQqhA8VtPBw3RrYPxuE0Wyw14CoWqfLKpMFciTYKO5WTSeC7dZH5KOgKSW
	GWBGzOQ/021G9aZpevx+DJGQGVlqBrCiCJavNEzPP9o1vgsHcpTOwM1Gdtw57KUQv+Roly
	SrVkwuOZsGis0Sye1OYCDuLm4HHD1e8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HplQ5l70;
	spf=pass (imf19.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764038853; a=rsa-sha256;
	cv=none;
	b=ih9y+cF29uvJcido/asUEDz7ZIujjNZQFdYN3FwCvz1AodB7s8GR4/WeKBVfS3kB+KR+Pq
	Q7s5QpPoqnNeA0673AGvkawEPb8Ro93HHTuco9pvoOuhLXIwNkM4WfVz/7eQBFFv6Pk1ZE
	fsTjT9SLsWm9uY3jBnnMZb5qFd8prGc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D24E60010;
	Tue, 25 Nov 2025 02:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2F4C4CEF1;
	Tue, 25 Nov 2025 02:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764038851;
	bh=7Ws/PbUNVl0lL6lS4g6QyFe+ZcfmM3/1TNjllqxL5NU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HplQ5l70hjnVJ1gxxUIdSHwiqclcKmNTSunj+ZcPl2/2vICsQPKb7N/1chWROdcDf
	 tABFBPI4Lt3J0UQ+6/+1pC4M5k8FLyxjfafychqIDnttVlyNnzZi3Otyu4sPckGR+E
	 KkLEZGv4Qmj4ke4OyyHv+SgM6mK9OzUJoDAPqt+597B+9ZEvIr9S84SAvfKHEukQLI
	 n1y+mkkPwz/GdHKomZsEY3pUfhzlYy6ctIWJ1ITxbKiUue2z+C/fr75VajdtRwc+63
	 rc07z8XxIVwme/Zhfmyhulo054XUBQC4cXcvOtREMewGHafokF78sfwpmUqfF8qEDw
	 1si6Q74vahNpQ==
Date: Mon, 24 Nov 2025 18:47:29 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 ziy@nvidia.com, willy@infradead.org, toke@redhat.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 asml.silence@gmail.com, axboe@kernel.dk, ncardwell@google.com,
 kuniyu@google.com, dsahern@kernel.org, almasrymina@google.com,
 sdf@fomichev.me, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com,
 shivajikant@google.com, io-uring@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] netmem, devmem, tcp: access pp fields
 through @desc in net_iov
Message-ID: <20251124184729.7e365941@kernel.org>
In-Reply-To: <20251121040047.71921-2-byungchul@sk.com>
References: <20251121040047.71921-1-byungchul@sk.com>
	<20251121040047.71921-2-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 29E801A0004
X-Stat-Signature: bfqg83srth6qzx5pk3yefb95357hdujm
X-Rspam-User: 
X-HE-Tag: 1764038852-838990
X-HE-Meta: U2FsdGVkX18TflpkSwIDKiPBymIxJjchzyc8gNagcxQ+ERIUbzaNMnKnMU0vGAWuUiTNaduNhsgDltZeA2Eg61j/abbD8A+ZkES3lOnfgtOfnvdeNF8rpKVODii/8pf20s4lI9J9JFznUIJf1gtLZpbqKbAGvYLFedQqj5HD/htGjrKQewn357U0jXjOFx0RLRIEd5hGjAA55Crxfzu5XMPd9vd7sC2kOl/830OnmG+fRLhTvWhpWxDPT4lWORWk9sg8YTZgrNToP2L/Beq4WYzATeOPV6R7DhBOQHwdqtL6ywBvXj7mUqVHnzHdVIHU671WNCfVnTJF2JD8xc8Mn36pIE3NGJxreAREgjMaGzIYM5cgjze53qcsusAfwy2Cn4mBY8Kvl2SbYwSkVexz+gLLwxliz01xUQ0SHS2GqChmlGm2BP1IlYoNsdmeuAg5GoZXvQqGHd/YlNqQGAe6a3oHrDhzhqn5S0Y0AWR5q8WW2PLfeg0f8/QWciq8J5VUzZLaDhDRKVtlKTGHQrD+t5e3uDVzu40o4KRzYCS3/oAyuQm6OjKCZhreRY5J9ouDm8OWglBrZP0axIXPBMnEqBymu00NNKMeWZ5en56aaMOP1tEy5lVAaTFO3xqFDHbf2GjxMWHOg00OMNYM/DZXUFn4AygKan97xFHBQdVhFoEwDfqCrEjY4t3KbldsidIrzfGeUAspsLiwdpeNa11f3KqgEGhWNnQzNTQm1W5xA8SSJ9CyBa6I8RYaGGpBTY/XrH1Xr7Y3ewJlgATF5e7on5uOcE2MvPLMsLUUmlVC37KKI0AsQtjERUf0LimbO7VlOhBjwmfgHTl8m/YL0v/4eCrI33rcqxOpjCZL4MXtLTKJbAkCF/GxLDiDg5owHc1qNsDWgNqnySozhd7fTQRL/mgrq4FZygniE/F1vHe2CbautotNY5ijSJj8loMvwjczRVbpzgiHMXM7C+DpohF
 ++atubc1
 +yjFJdPpWLhafqfOeRfGHYaFTO71AVq8NQJ0ltSd5m7dOwksujOO0ruWFuEq9i4vJ+QTqAn2VS5q9j5EKiYb6EidOq7lk4Oy8To8IVMkm+Bh4Rn56mbCKPqQtWhheNN/AMd8twbmnBZEUtW/JoIviLd+U+LU/xKFKciZTBfF6wa+7mPT4kM2A8z3Ut+WA3JhyeSD9iz6pWp/BPvpXjOySXXkuBrKuof6Nbbs8Dm9qvGju7RN58xLjJXMXYaH++oqEvYRUA9sTqhtWsxrzEEXSDMxKOul+L2aCi3ICCbx4H5saTNV9e7tiry1aD8cQib5Tbc7aFaKAVW46VrSrsCYuDmHIzLt6FnMpOAQ/M3XdVXnCz1RvuzM1XI2ZJsR2Qrau5r7TXR/NPI+SWvNJ8TI922+p2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 13:00:46 +0900 Byungchul Park wrote:
> Convert all the legacy code directly accessing the pp fields in net_iov
> to access them through @desc in net_iov.

Please repost just this patch. The last one needs to come after the
merge window, when io-uring and net core changes converge in one tree.
-- 
pw-bot: cr

