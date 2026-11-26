Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A1F606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JCLoEJj5
Received: by kanga.kvack.org (Postfix)
	id 7F9746B05B4; Thu, 26 Nov 2026 04:13:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A95B6B05B5; Thu, 26 Nov 2026 04:13:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF356B05B6; Thu, 26 Nov 2026 04:13:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51EF76B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:13:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F11B1209F3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:13:25 +0000 (UTC)
X-FDA: 85476706770.11.2C006F4
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E1A61A000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:13:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JCLoEJj5;
	spf=pass (imf19.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795684403;
	b=GWNnaD1pHw5bg1nPLii6M6clt7Tl/jAVs2efGvV4++rOaRTrYw2xriAOA5zHCDk6i/0Zs6
	B8iRsuhBh1pFb9tA/HxiQDc2gF9koNWuuqsrbxB7iUSOciVMIu0guNdo8iegJInQgKYGkb
	l8/bLAIsGwuwGXz4evyWcBQKTJ6QMEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795684403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQGc1a0+VZ9GTDpXbNUPI4FqmxbVeu12fE6U8HXCQzo=;
	b=Icc5F7TuBYXGurzrSvCOC/UEp3LQqkz5ke+7ta00wCslNLT4VEbDt4ObYt3j5Gh6nOMljX
	lARuN1a7evGP5ahcoF2VnZWV2nG/X6XWvzAHyqEU40O/IFv+zODYEDJgas2A2XYhQn4r1W
	zQmhTW1czJb5GaHuj0jnohQKleQvx+s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JCLoEJj5;
	spf=pass (imf19.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z3IPMrDchrEr+rWsXU/F3Ni8IAcBIA2oFTs4vzXuIkU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795684394; v=1; x=1796289194;
 b=JCLoEJj5dsEHBby3T9anusjNrNjLlZctuz9ZfP8m/EyWuiL3onHDdLeaRB1/NAPQDg4h7eRL
 fYvUCKUCmyc1Gr6rfTw52SxzQKOX0QJZFEKY+KDd81BMnZVXmJe9pqZ1kLKJPdIEBlLedjcZFFl
 IPXd3PV5bDvsKhB0ps6JcS4k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c8a80f542e4f1fb7;
	Thu, 26 Nov 2026 09:13:14 +0000
X-Mizu-Trace-ID: c8a80f542e4f1fb7
X-Migadu-Flow: FLOW_OUT
Message-ID: <5e8c59f4-eb60-4b3f-a267-a87ef11ce6ca@linux.dev>
Date: Thu, 26 Nov 2026 17:13:11 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/27] mm/damon/sysfs: add producers/nr_producers file
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-7-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-7-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: 9E1A61A000A
X-Stat-Signature: wfsqimqfixfkxj9nh5kjdj4wiqdf6uxk
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795684400-133111
X-HE-Meta: U2FsdGVkX19vbBkPiJmk0xSk0vN3AoXxkriWFHNKIcSFdIOMB3NqnLiFZw5m4MzXuPBLfLVuk8e8FtRaCTnbm/0cjeRx3nQXpY6e+KEEQ/0qrJ9jVjINkK1AbIYkD9XKTxoC/xnTC0vUwB67aQjIITX7z+WoYUP6lAHv6BscXBC5Ma41OwrbubxWDx71RaTpC/k8Q5wzSgdQJAAePhha5oGH0bUrfIYeTwhqk3H2Ylzc4LXiaPHX2VDIwJkuziCfBOx8tzc34UqKPMaYy9ZG6OmgXUx7im13mHWTYZnGHhT8nXQmmSM+B9xmlOp2HL6FMC8uQg0uKe3Fv7ef6OaHmDsw1YGIqWX2RZhGfLUmtWpjIOqD3POmpHOZoUjEwo4Swdcmddk/zfDqTXRel3pVyaLnWsC+YjcUOCvdrwQ5TLK0gGTt6U2rtCPcgJI/8I1cvgVVpOUJ8ws1aeXm0hcrYwuEFQ3m69DMY2JVt11mdlaspIP+kLzocCb1N45N7JePtvyXQTVd9Q1iFQZo7T23gbX5RiKhhsb0qX2Tg6babIhPSITG0syGFVhKtGimdB4IF8WJjV+H4wSg78RV2ktWOgPVvxfstHxjnAg3aM3FNUWqi7u4ub2Bz9s/fz2yCKblLo9r2unMNi5C3jFdOHS6GrGvvtJI0v00pqmxX13ei5hwUoz2NY3KrJiukWp4piXkW+z302M4dlZcq2YJjFe81h3zTTky/jTEqK28QW7fbJwZ8p1pe7rJBBPT7goGjd+Ux5sDSIsn24fLDYTBGqWipzJAJB9e2VQa7BXBK/9oJRD3gvs4kkYIrQHEDTK+snOdPUxMeEuj4+ZZv2icThXvGG8bvMB147V961LUi0nftkF7Evx+PUV2ULGeNPefw5gU1eC6lVXZyJjxS2dYYxmamNtNg5XtlWvCUqgMnO0Tr0JS+8MT6pWZCKM64cdQckAskO0Wbd9lY4ouOjiBonY
 vwWGk/xf
 Vk7xNG43WOkhzq+ytrms/lqRXIg0lLrxrhwZwtfCzZF4yFdFYVgZZjJNUHs1ogldqjX/4xo2KmB7f+gVGtbdmrKqKrq8bxJ1Mm3jk5M7ggQHOoou3gwf0gWIRQqfrcDGouy+ASoujrdbIoL4GZkALTC4xFw96dOcKm3Nn/U/sYmynx5hDYKrnslchsSAZ1ywV/UMeH8ImI8Tfjg3RCMdS73nZ0CIYSFnx+5XM+BzumWL33BJtecdvxkwl3I1O0hJy5ARVkEX9ei5niY3i4a4ngzsdjjh3nxaskiRTOQzZ0daeaAciuxLjax0USdpw3gK3motmIa4KPzbtuL5CIO1F70OPk6ldO2D081xnDt4HWM1Evb/Gbmor+XGgBh5cwa09/mOrQfnjmq2qombCTlp4Hv55awH/4/I1nmK5ydEjMUD4gW/sJNMLRUlWmoKoCkhi59hbXGhx+tzBmL1vhiZuDRuai2JMHjHLE8LAPEjB430ELymJd5PHgNIG1iUDKEGubYxgVh1JRLG8n2XPyPLOIESMKgZ/4oM1NQkfQKDyLkN3pwAF7ZI/cfYhd1ZNbppHYYR92BZELGP7q2bjZvQLpGNnFvTLEB32xXMmylhKDUu8UptZohoZaaCu6kLKQ3UFqe4hs6nu/Q+OwG1Zdxio64YvoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Implement a new sysfs file, nr_producers, under the producers/
> directory.  The file will be used for generating directories for each
> report producer, in a manner that is similar to the nr_kdamonds file.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

