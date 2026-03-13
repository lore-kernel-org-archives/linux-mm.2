Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AFAF107BCE2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 20:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A701A6B0089; Fri, 13 Mar 2026 16:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D7A6B008A; Fri, 13 Mar 2026 16:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF146B008C; Fri, 13 Mar 2026 16:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 810BA6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:59:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2412C1C2D5
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:59:19 +0000 (UTC)
X-FDA: 84542255238.12.EFE83AB
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07F58A000A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:59:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="VJ4F/OW2";
	spf=pass (imf25.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773435557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTPibdSt4cFTmjVaH/wPcfOT83c1WtdF7A6cG2qap5k=;
	b=dUqFq6PkaT5p1mGlqCfjiXDx0y4jmyR+w0fuWZE2hidPowDlzjGtStFPfW8xbxxJEFtyr1
	oFSoNjRMuupZgvtzwYLUKob5nUToZ3rgBuMyTmz4gKeHQCmaYIAMc4J/HJRP42T6YSRO1+
	6KwlF9PdfK42vXqY2+49cn3vgG0qynA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="VJ4F/OW2";
	spf=pass (imf25.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773435557; a=rsa-sha256;
	cv=none;
	b=8JYGw6Mmx0zsT/l3hw/LhvwxNcQNmhkOR7au5Ri+Sh1pQ0chf0titV3K/IPBft7HmjPZsB
	XAk6/exTPlcVSLMd9uKqlTwG0fQhwLq+ilcto7Lj3WS+B0eVEfZz/6VvdUSrucRuOKzwS6
	nWiiwXKSRYI8t+4eGefZDFFzNqtYewc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MTPibdSt4cFTmjVaH/wPcfOT83c1WtdF7A6cG2qap5k=; b=VJ4F/OW2/PXEXkmbHm8/aDfZjW
	E1fQBQr3L0QaPFJGxZYUu8FoU+UWGJ5BrGgsECLVOiDDrkVkFFJg4kUs3CH5BpeSTbuY9Cd0n6a24
	rH2wr9+Q+cuwLLD/UnuNPpNYemcOuQDdefAQYYiGe8VpoJoCl80xHnt+3gruwoAa2Ds4+6qkK+8vp
	FlTEAefoCLaZFsLGbxCDCDGKgOmufZ3xgxhKYSQ8/0imPu9H4fNOA6qAWJsUtcRAyAA69NK6Mavm1
	IRiZ1x40byEPbRDdW1AFac2XieeZmfzq5xYKiEBRfCEcVhVI3GEqNH5NORWUQkoRCZkROJ4+Us1ms
	xX+gGaoA==;
Received: from [179.93.15.111] (helo=[192.168.1.54])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1w19bF-00FR99-3l; Fri, 13 Mar 2026 21:59:13 +0100
Message-ID: <3fe8232d-f563-7e02-ee83-3535e88e2f7a@igalia.com>
Date: Fri, 13 Mar 2026 17:59:09 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH V2 1/2] mm/memblock: Print out errors on reserve_mem
 parser
Content-Language: en-US
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, rppt@kernel.org, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, kernel@gpiccoli.net,
 Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260305011429.79193-1-sj@kernel.org>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20260305011429.79193-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1hmizrmhg51quizphyazxmph8xue5n3f
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 07F58A000A
X-HE-Tag: 1773435555-672140
X-HE-Meta: U2FsdGVkX199YNvFmhNLpvwc0DcANfseNFaolFMs3AaP1ejaodOYU9Lxm9J0OwPdyItF5je5V/FomdKV9YcNXrm4OqN46AqZYlPRUa0L2jes8T74PvdwXLr4knOmHMxAH5xVGAJDVmZDWsviJlYBeYr7X/pdA6YbFzZrt7dbdx/4hm2t8S5Sk06EIVC5N3KxcLTCDmcmZKVZATccEKB9Ai5EG/NnZ5Ijvj+UwzBCk5FERhiqhZQrOfetFIG6lrM99JdDYcebXqaez+RSmp5BqXQfTrSlM2HlaMI3iwh+7YwJa2pOpZXR0tkFqMdUaJToVpWbKipMhnEWkCobtLrxSdpm9EGdF3Op5cEWtwxQ6YMbCD4KPwNd6KPzYvypcxzz3SVOKMH98Xat6TSb4ASbP9PiBmB74kyJ9iLqK8a4zH+erYU4aTHQKnbU+MYxLr97Mvkbo74g0MXz6GKZ6nqjvJ0xFW4z8hAD7LukBJUOt09w75Aiyjw2H1q8RgjIq8/sdcYy0+NPjYnIzFCWndryII2fajjcpM81TzX7aUO8L1HgNpRtKelsNrIySd909Iq60YBDeWO5rEbyEHwiSiEYDhDSoz0u6RKkIqB5GlmISOJvGcqm56y8sP0cdPris6/waZBdhepcA1BU0PwjAHSDY4SjOLIk9u6hBgJVRDZSLV17soSCZ3W0kDAQRV91O1yLia0EcCq2LtMEyBfPvnMgzY1cDc7daW7cDAVDtJoj4Q+hgDlBlB/Huvg0O6Wl1q2pmefejrCy+rgTGguC2zSoDeeawWPgp6SzCIJKvJOS0Y/GmjpPCHIX5FFjhxAVbZTONcqkgKXZLRUcAHeB/aaFu83cLeOVOYh2qfe4F9MChOWGBTILo7M0xgul1zdjQiGIHk9SUnY5lE+Ea8D84CGHe6sDmsHyDIj0UIjNJNdbLgzw/TKvykyAlZ6EzFdc7tXARF83hjlV7/Sb+EwJRH8
 qOK8SkQg
 km4JE93FkUAfChD/4DIblq8IJUsinDoMOYCatf/SygX7JmcMwqfwZeHpXI3dBwaQObJQQLHkpULGaLjVkHeazKwNs8oS6YQTd+e+7Xffsr5Hi8uLzv9Q1ctapRNMHzm6BwDyM+oARrnkx/U/EKpzJ5ptdg++DtxcR+8MonIdvuJ66IktRNLkoncm2nJUWXboJm2j+Hbt63xY5FtX8Puqj2DBznNIoYoCyjvaqtpJnOJgThjFB/H0q5xZQykgN+sfvYo2uj71KtXlKSCJFuFwn0NAWt7nboaBklSprwXDzn8pGnxo0B3q54ufveKimFKiXV9LjyCIUuzyxgkyQoZvDwlNrs9w+D5HcAMd96QNUlOQgShJW6lZWDHoRLB91g8KLmAinT0GG6lBuOLJkZr6QuNgvBZqmf4NIkFYRe89rsiFhwzKJt5N5yD7+foKOmemY4ZwANnHx24Kyn/C9RH1MFc3pTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/03/2026 22:14, SeongJae Park wrote:
> On Wed,  4 Mar 2026 17:14:10 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:
> 
>> The parsing of kernel parameter "reserve_mem=" is subject to
>> multiple failures, like duplicate naming, malformed expression
>> or even lack of available memory. Right now, all of these fail
>> silently. Let's add some messages so the kernel log can provide
>> useful information in case of failures.
> 
> Makes sense to me.
> 
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 

Hi SJ! thanks a lot for the review, I'll resubmit with your tag and
fixing the unnecessary blank line.
Cheers,


Guilherme

