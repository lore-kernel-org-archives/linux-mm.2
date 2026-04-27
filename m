Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BEBFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 06:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211BC6B0005; Mon, 27 Apr 2026 02:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19BB96B0088; Mon, 27 Apr 2026 02:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062A86B008A; Mon, 27 Apr 2026 02:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2F2D6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 02:21:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79E1340779
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:21:14 +0000 (UTC)
X-FDA: 84703338468.23.8FDF23E
Received: from smtp185.sjtu.edu.cn (smtp185.sjtu.edu.cn [202.120.2.185])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5350212000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:21:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=CSwgEdst;
	spf=pass (imf29.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.185 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777270872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNfIJn5Fhsfd+qfNeusdAWUQ+MjCC61ZkHvNLT24AfU=;
	b=08milbYYryrEUIgObQ9TlIU95ck6fbH+yCC7TmGcOb5i6glwdy8nSkQQ5bTwxX0RFz9Oqw
	aL52hUCIq/vHdtggedVgj7YSr8bWVubYJ15zpsrRw12PBxZYwpy+D9Q14csKvM+Ijgyazl
	1xMwn5kWYdasX9hZHv7rfngRafCK1PI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=CSwgEdst;
	spf=pass (imf29.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.185 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777270872; a=rsa-sha256;
	cv=none;
	b=elm4cxIBHy7fgywz9H/k8pciXmqS+sUDiBOEY3dVGuSLklorrmI7pZlcVPJBjRTfnqHGSJ
	Ms7ZpDvj9vyxvwNB9tcli99ocJLtj4sWdzvsUXNVVwW28fowa+e0HmDGBI2x2v20gh2wmg
	pk/6htIiqL+iA18MRmSE6fQGcxsaddo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sjtu.edu.cn;
	s=default; t=1777270866;
	bh=k7FXG2e/EV/GJJSCGDqsYjbBQrgk+18Y2MXRX65qSoU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=CSwgEdstly7B72IwKWTHhbDtU1N7meh5Pfl9ZqiNWq+Gic8lcBgwzyCxl726lhz/U
	 u9KVRBx7Tb0UHBRCJ6NcmpEuBjPSE3eAzP0ehQXZEVGD5vS2Wap/3ebIu0dB5R0deu
	 djA9gfE3NKxJ7DAja1D0htzIYLYuTXFKoqXDBTGC8pcMi1OW3Z3QRh+hZJPdyyoZic
	 zdMrsD20NEY9yXOodq3VF40T88eVRtp1eBIv0HUoTVy5TeeHTu6btQyD6j3zexqY1p
	 Lua4RdWxp/ahZev4oEC/BVGs+Ut3bzf2jaJqjIGtOTodk6OfHPEvFNUyC5tFU/BRzn
	 I+Ead7DoH3R7A==
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
	by smtp185.sjtu.edu.cn (Postfix) with ESMTPS id EC18E385A6E;
	Mon, 27 Apr 2026 06:21:05 +0000 (UTC)
Received: from mstore137.sjtu.edu.cn (unknown [10.118.0.137])
	by mta90.sjtu.edu.cn (Postfix) with ESMTP id B841737C878;
	Mon, 27 Apr 2026 14:21:05 +0800 (CST)
Date: Mon, 27 Apr 2026 14:21:05 +0800 (CST)
From: SUVONOV BUNYOD <b.suvonov@sjtu.edu.cn>
To: akpm <akpm@linux-foundation.org>, vbabka@kernel.org, 
	linux-mm <linux-mm@kvack.org>
Cc: rostedt <rostedt@goodmis.org>, mhiramat <mhiramat@kernel.org>, 
	mathieu desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes <hannes@cmpxchg.org>, 
	ziy@nvidia.com, david <david@kernel.org>, 
	vishal moola <vishal.moola@gmail.com>, corbet@lwn.net, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org
Message-ID: <222049437.2315342.1777270865090.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <20260427060142.131055-1-b.suvonov@sjtu.edu.cn>
References: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn> <20260427060142.131055-1-b.suvonov@sjtu.edu.cn>
Subject: Re: [PATCH v2] mm/page_alloc: trace PCP refills and PCP zone lock
 usage
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.122.86]
X-Mailer: Zimbra 10.0.18_GA_4835 (ZimbraWebClient - FF149 (Linux)/10.0.18_GA_4828)
Thread-Topic: mm/page_alloc: trace PCP refills and PCP zone lock usage
Thread-Index: cvNpGKS1fD456U+LMNaVmpa/8ckf2g==
X-Rspam-User: 
X-Rspamd-Queue-Id: 5350212000F
X-Rspamd-Server: rspam06
X-Stat-Signature: 59qbs69ktywbh1np1nsqicuq9f4tdw33
X-HE-Tag: 1777270870-642716
X-HE-Meta: U2FsdGVkX1/gK+mMxUaU95B3EhtvPP/8+cUZmWGUR8Wi00wgv8NSnAPGcN+wMZZHVCJs3Wz7id63W/NlHy4rqeAUbaprmlBKy+172kRN4iBiVqPxwuKr/OlU14Ns49ABUiKKAAqURDyAFeHlltLehTCyqiNduWJbpAvbKmTb0H32mmnGVLcGzf1lgflVI1LGYCzzem+xJD8vMt0eqPwV9uBIvQmenoFd2cF0ivCKH+peupK4xW7PzKvq9S5D4V4XHNFHUEboBQqx3xbkOCMOdCwcT1dF9qWhrzepr/T7vYV83+y+tECxkcShI/mjOZ+aod3GF11MSjN8nMiKwjop0XPRb3EZzsHMEcifTZ8x516rL+1DX1aq/WU9BgmJ5R3iUubOhti+VDq5VR7czZn4pe2W0iOw6EDaRJUz+vx8H7vfaBrFhJ8xVCC0tDfXT0ikUkdP/uKBjwu66Kys0v7kYb39ZFVvXG1xonCFc8k7AyRhWUKIVKERmWs1yAYyDr50qXtBJO3rJ/P2QzB4JIqKZWLb90GEdMr/fESy46oOnmqymvzBNNqSrx5y2VE2dtWnl996eAhfgxtPWkEZJ6H3nVGT/sgPWQnQZslCtDjta/tZ6jStJt4OD9G/1nUIDfAtOdmqHcIAnEOfJFAHlHFIah42dY/Y0uWE6VYMP8Skjj0mV2TA89srTKajJSorGHRLvuWxbc8NqSt/c+jtOE8OAZXWD6tqAylL/CejYciNWQNYI7Xdpzukol+l6PQiYJJy8MMgAgXsVbwUvo/k2szscU2nzQS8cNpllBxhXuzynnAD/gFhxkyWd10HjgSNbR6a5fqfCfOl2KhVpIqkVrRUVjjn7lxRhPj+mebxlnBZwnD2k51qp/e9L0/2RcfSW7ErzfgbXSYQMczO30fMxSdIMMIE8/5V72z6mGZVQPSlDFWdH4Hzk51XT6OmEDm2oVkJQDGFr9MHxsw9yvZvYZQ
 QXGdkOSv
 2TYxR8RF2Ni+TrdX12NCq7G/DD1/7uQ6GIVEM/ryoExp+aE4NagcYsbaAJm15ghbu6ZUGH8k3b782myyRYyeF7ySELafwVLMDw+a32dpRa2XGBpLKABYxGcANREfSSR/Lqr+S5DOyvJpwcpwTvz5DXqWa7XNr6BQIQQlwelwJOT2+CkKWZqZTrPVd6AB3m85Ym54U3eWm492eG/M05Ut32UWZ1s6H39zRKxhDwabxpChzhPd3D2rxHzBNI179ZC0P0fJCqzmUePrOqx1UjlZ5PA+6jrhckSKVej1AKkqZaHwRs0Zfqugrd9iwIUy2Q0zUNe+J4/4lpK6v5xTOJxv4ytWHo0GWCUeggf9jLdPSqfCng+/0tlqWhlg1K0xwH7FVJmm14CU2zXfsbxgFdHaK9zYvcXsWvY3wMNMyN2SWK1UBLhecpQAHRCR00bA8XSJ60pdw34pQ3B5lhsvcWbgcsaTdgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for reviewing v1 Vishal,

All of your concerns except for the last one should be covered in v2.

> If you're trying to trace all pages as they come onto the pcp lists,
> should you also account for the free_frozen_page_commit() path?
>
>>          }
>>          spin_unlock_irqrestore(&zone->lock, flags);

No, the intent is not to trace every insertion into PCP lists. This patch
is trying to make buddy <-> PCP traffic observable by adding a new
mm_page_pcpu_refill event symmetric with the existing mm_page_pcpu_drain
event.

I also added additional zone_locked tracepoints because my research is
focusing on analyzing which kernel mm subsystems and other parts are
under stress for a given workload. The best way to see it for PCP would
be to count zone lock acquirings as the whole purpose of PCP is to lower
number of zone lock acquiring in first place.

