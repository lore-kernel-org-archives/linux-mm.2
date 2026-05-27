Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6198ACD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351986B0005; Tue, 26 May 2026 21:15:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA7D6B008A; Tue, 26 May 2026 21:15:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A55F6B008C; Tue, 26 May 2026 21:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F26006B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:15:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38563161589
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:15:41 +0000 (UTC)
X-FDA: 84811432482.07.3E9745D
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4BA6616000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:15:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=4dszTYjT;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf08.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779844539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQ76c0ZKyPhJJ/YX2rWxuedO/ZUKDUPRSCpouDt6Lvk=;
	b=J0jZ/PnnQ61MQEb8pU8hbkti6xPM3YfvEJ5OvMdIYjA86iG37gqbZmVkCiL9DaLiYOg/08
	JN1q88jjnxnqVkpNpOJZ6m6X/ZeycuT5DaXCBujmc4dHLrghiPkbxqBw/7bqyf7TrpM+GL
	3LMSJm2nAenb0ZfeaPqN7Rfn/ELerlU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=4dszTYjT;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf08.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779844539; a=rsa-sha256;
	cv=none;
	b=FLnmZnGM4lZ86JkxVfy86zc43AjOMqBHqBCfxPsUpUdumNcm9nEzY0Y6/CYN6VT1SWyj7f
	gDwPtXZwU25kg1zhS/n2TnVkhj0xoVExfPUENr6MXpHoHf2eQ+Q98o9tEEkEZ+DXjxtlP0
	SwXmoUIFvkrkIHIzWy2U7+xOTlKC9ms=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gQBWX66T0z1XM6JN;
	Wed, 27 May 2026 01:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779844532; x=1782436533; bh=JQ76c0ZKyPhJJ/YX2rWxuedO
	/ZUKDUPRSCpouDt6Lvk=; b=4dszTYjTwYxVzsK3EmW9I1eIh8cJav0Zmg4Fqfhk
	n7ad5S6m0qtboA6aELUUHk0Bmf9+W+j9opNIKiyfk+bC8Qb3Lc/nlkD6vyRe7wbU
	fXwsGcFzjzm5rIS+FgdgCByEX5IkJjGK/eM5WbcxqUIPjply4pF982/b8uKeH2Sh
	NtvGWCfKMItmhtUqIWNcJA9I0Oqq8n24Tdfm5M21Bq8fdB0ib+LQ4dubSg1na0/N
	PjQDFLtOr//BL6iWNAADp4KO4TYgmtmUVYssbrqlz0ZhMD/NL85WOqkHPRnKa3i8
	1QaFn9ew0mcDMHLGW25DZQucxmLe2nKCKbCEQFJaJYlaTw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MBCftocQcW0H; Wed, 27 May 2026 01:15:32 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gQBWM5yz8z1XM5jn;
	Wed, 27 May 2026 01:15:27 +0000 (UTC)
Message-ID: <426a9687-c39e-4ac8-a406-d5e2198f01b0@acm.org>
Date: Tue, 26 May 2026 18:15:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
To: Theodore Tso <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>,
 linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig
 <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Akilesh Kailash <akailash@google.com>,
 Christian Brauner <christian@brauner.io>
References: <ad30g9xMs9wNJhFb@infradead.org> <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org> <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan> <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan> <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan> <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4BA6616000F
X-Stat-Signature: c5dstyyn3bzwaej8xmmzibbokez99n3b
X-Rspam-User: 
X-HE-Tag: 1779844539-44057
X-HE-Meta: U2FsdGVkX1+uvHkSbiny2pppf+3EDe4649rv13DVZfEy/k0Wv05DG1+Dbe8gDq26Y7BA2j94N+yrjiVSInPuH/8Rh+voetrClEnqeN4Hkl/X3V3mGfOwlofCSegfvcagiuM5qabr6iCJI6tswJyLqcuimYtBHjJv2AUdaOFsGcLFBtd+rUTm1sV5KvQRedy9kwZSxwhrg3n1MYzHX/urXHlURI1WmFpna1Eid4mJuJorgXihhLUqtR/NR7M1nrMMgjPvNazojcq3cKRm/z5H7S+Hb7KVSaGys/+2Uo/Yp6LWy17n2HKnYaPIKSDE/8iQyPOOMbLR42cU+scdJeU3U7ldb9WBWBJKGxejZvdizDcHxfjLzOn6DntV/C8i7U+w15aVcxwad3ofXb93pFEOdGCjnMnBsmk489EO+c8vwqSYiUTTNM8nYNP40kgQ1vVa69P2Zl2GJd/w8Lp/MjFWsb8D6nvVYbTys22fRofevR8cmlVOT+7C4Oz5Y4Jqs/fUFussrFa6oGV006DiiJlXsp5BpsC/QcEwuceKdS4dPru4BivLc9qG2xoCjZGlXqpXYSMvCqy1xNBoB+oyBnEyTHGYHCECl6Whmi1jxRsBJ9xs0jW1qAhXPvGMWV0cqczRbwMqLIJ9x/nsJF8paALqpgpg1W4WZRSvCcg79fEBR3IBA+7ppUQlxUho936a1/9rcAQhcMoRA3soXmsoGhUtPiTRcWHyHgF9/2EKNCKZgoyeTgF8PvQ8ujFBvolJe4te620aLQER8uOdWEWtCMlJjRLEY8ezjTHU77idnpDJaSxNF4DJHgle0NvM4QXKD7KQbPQMmQyodiQhJ7GnlbYf2DfClU51ak8oPAlDF1B7qWLNW25LuvNVyC3w2vpHBelvrAQpiISVGCSpE7XhNQMcTs+urARg8PVH7qTe6eVwn9cRVNGqg+rHHmc0LhXmrH2VeOjRP5XA07ey2B6a5XE
 Db9/+fUu
 94DhLY/xTruFCwH2Uo4t1dUJYZEfPCio2WBWEEJv8o7HP71o9Nx2CUFVRV7qfquYZAXwNI43V6VcTOrFOl+x71uAOHQzvCH24FAEBrDgjFkn1lBL9frCBwDo3CEYhIfwWIHveuT5o82FTKGUWe6bnXywxACKdmfWINwZUckMu6LitYi08oDZK00lqJRfFkbc7bYjhl6Dp8/HpoH3TvE/AWrt06Rb5pPk56HHGcUzJkDXSu2ZZCDQJvadjBbRWJi3C8iuD9VnVx3pv/PmdATr0xcrc4AMNEH+NPTqG9Qi2qkfgyuHCPi1xrzxltg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 6:42 AM, Theodore Tso wrote:
>      2. Host Controller Hardware Limits (UFSHCI)
>      
> 	Transfer Queue Depth: A UFS controller supports a predefined
> 	    number of outstanding task request entries. This is often
> 	    hard-capped at 32 concurrent transfer requests (slots) by the
> 	    doorbell register array.

The above information comes from the UFSHCI 3 standard. Jaegeuk's test
setup has an UFSHCI 4.0 controller that supports one submission queue
per CPU and also one completion queue per CPU. This is an architecture
that is very similar but not identical to NVMe. Jaegeuk, please correct
me if I got anything wrong.

Bart.

