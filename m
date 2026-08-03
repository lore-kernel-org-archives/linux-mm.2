Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95097C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C5B6B0099; Mon,  3 Aug 2026 09:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934AC6B00A3; Mon,  3 Aug 2026 09:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823746B00AC; Mon,  3 Aug 2026 09:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50F1B6B0099
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:12:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5F964061F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:23:38 +0000 (UTC)
X-FDA: 85059269316.29.71CBC3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 14ADE180007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:23:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIa4FNQo;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785745417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr1XBpbnk0zX9E9Hf9+XaMO/o0eQfNbPl/6JAmkYcuQ=;
	b=XlPWP0ByDNgCtSXe7nzJAImvGSsi23UtbxcC8XkEb7bJw60BZ2M8HW31Lv/4U0L5Ef1Vza
	2r5I+9XHKzdy2xzhx8ovZ5d4q0xE5HRHK5lIkg62fHNCpPBmjcqXO69CnPmqPH0JDJeh/W
	xLAry3OFAglzeqbYlUUDP+5kpOj92lM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIa4FNQo;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785745417;
	b=ZS+aWR4JXV9AFFdFKggRx2olaSF98WWXiIb/aUwrgW65DN919Pd/7vbmhpfQ13pK2poOaI
	8qTaNGXQWyoRHqTTcWr4ouBqoZqdQIHPYD+yK6tD4avPItBktLkSzYdqi5ARQsa5d3Fs6c
	r79DWR2OaJqAvEDazdwLb7mXCqKWJZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFF0C4172E;
	Mon,  3 Aug 2026 08:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C411F000E9;
	Mon,  3 Aug 2026 08:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785745414;
	bh=Gr1XBpbnk0zX9E9Hf9+XaMO/o0eQfNbPl/6JAmkYcuQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kIa4FNQoZ10ntwIac2bANO5VbZGe8hJzsApKeARQeHnL1gzrhSOnIYU71zqqvoEpx
	 cZ7+KVZRof25vvxshmLw4I96b9lYdzNm36vIBmRScJkd0l3gezBunlfChOJHpr6S4D
	 PNGRaeTNk+2GQVQkLZDCE1XHSGJ7RmiUdE8/rc7oBYyKllzvrtAl9cBmtxgCZF0ZeC
	 e9VlOnhahZzLEC5lpkUo5pzKcKVk4SQ1Qt4N0UFQuYtIvoX8VFuFKIbaWeTgNY0TNk
	 OIGBsuMR+1eTKxuLh7I4eIRoC6+vRZYXfVjeyM6Hhp7UwqJxTl1MPb3tZDU/hHkSCU
	 SB2HFNKUf5BDQ==
Message-ID: <7b687665-765a-486c-8a30-3bdd4f28f902@kernel.org>
Date: Mon, 3 Aug 2026 10:23:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] tools/mm/page_owner_sort: add module name
 sort/cull/filter support
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>
Cc: Ye Liu <liuye@kylinos.cn>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260803062056.1518070-1-ye.liu@linux.dev>
 <20260803062056.1518070-3-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260803062056.1518070-3-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 14ADE180007
X-Stat-Signature: k9zwqzigtdp7yhfhbtnqhps75skkqex3
X-HE-Tag: 1785745416-205595
X-HE-Meta: U2FsdGVkX1/hbshCrotZaLEcHepXEWuq3jVVUzFVwPwakKVJ0PScqcqxJIvoK287cRYESrEf2c4+j6AByc25dAOgC7KtyJt08WrjvYA3ojgL42Vxj1lcK7T+Qtvr/4GX78GNoQ53H4IxtdXxaPZxyGgxaLslCiG49W4SShF4FGyeXnKaqkMjRBMv70epkghFSPm2TZJPa9d90DtBFbVtDTU0VHtrVX9OJW2SPYtdVvLRnnSQEkC6JEfaPGO/SF+GPQoXJj5q79hRkIHP7KqSDesvfvrCLeORdS1UMQ2+OP94Rvyp4SKcmemVWPq+UI59jvktSnwCQIs7uPxnAQcqP8Rb4nWgQUmkU+GwZZRCJm9vKOBuZbEjJ3Q9ArnZiklCnaLgyhOtM/oPkc1OirjvcSCBadjnTFULGv0GqavA64XH6g5naVIRif9m/SLs3YQMVZPa55hTVYYFUb6gZtQRXG6TTyESy8jjtrigaShW1EVhGA5Xyqfp1w7m1FxPEVqiOdh/kFTPoGkoSYnKoe+fg9UF0TS0P+hFQV/GVWWobJwq+t8bs44okcWKVKbsFyTHvGi6ae6wHzp0V6hSZraA1zoLW5ko2k1xN6obC7Jk6EzWgnpvT9JhKAaaonWoKQgE5McHWywr5jacA47ugcjMEYZwfItlqCmjB+J4wQnYkZuCluhwYDqY+tClSqjs58a8FunmtxOiHIB9k3NnL9JFBUG+6Vw4Po+RcCfaJvKNWchVYp/mv8/6fZ40e27lekvC5XM8vSYvC/1yERJGo5rYjtfRpvTMCJUe5eenFG5FVYdZ+nsfLHuLml2xtcbijKkP1ZB+h7BfSDfdAFAFAZ++Z6DDEraAfSeY3cAI1TybDTFu4ZHBHAOFNuiA5cltw5eP/T7USX6AM2L1Uwd874N/anunUVJ37IFzoXFsPu0HMXWdZEZqrgTVfo3oORne5xKBFl7aJmjEJJE7VyUqLMm
 U8E0+d4S
 rthjR2QGNQobBG8LE+2slZ9Zhibe16Unld9drc/3NffJm50lSO6D7i1n7OapFYd0tFLj6SCiDREgFdutRdrVaLGZMPz5hzJ9k7e8xvbQF0i5sPNgfoyibjjRQXFtQPJzAgIn+TglNn3P5WUCzjrj+blmgHwJMXq0qILgLfN5DouG3Os5sjz9EbivyxvDwTpcmix8FYExXEuZGBF2IDd8APE8uQOTecy/4WOpFvaZsIHHxRXrqHWPoC+yvPst86mhs6akpl0oSvHqODnnj0duYInimIr8ounnqgQDv+o4jkluWMdM0VBAlA4ekFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 08:20, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Page owner stack traces already contain kernel module names in the
> "function+0xNN/0xNN [module]" format produced by %pS, but page_owner_sort
> has no way to sort, cull, or filter by module.
> 
> Extract the first module name from each record's stack trace using an
> anchored regex that matches the stack trace frame format
> "+0x[0-9a-f]+/0x[0-9a-f]+\\s*\\[([a-zA-Z0-9_-]+)\\]".
> 
> The regex is anchored to the stack trace frame to avoid false matches on
> kernel thread comm names such as [khugepaged] that appear in the record
> header.  The character class includes '-' so modules with hyphens
> (e.g. aa-bb-cc) are correctly matched.
> 
> Records whose stack traces contain no module frames are assigned "vmlinux".
> 
> New options:
>   -M                  Sort by module name
>   --sort=mod          Sort by module name (supports +/- prefix)
>   --cull=mod          Cull (aggregate) by module name
>   --module <modlist>  Filter to records matching the given module(s)
> 
> The module field is also printed in cull output when relevant.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

Nothing jumped at me when skimming over it.

-- 
Cheers,

David

