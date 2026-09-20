Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4BDC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 01:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E188D6B0088; Sat, 19 Sep 2026 21:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3826B008A; Sat, 19 Sep 2026 21:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44B96B008C; Sat, 19 Sep 2026 21:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 934256B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:07:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A09E8140358
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:07:47 +0000 (UTC)
X-FDA: 85232353374.13.B679114
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FFF720005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:07:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Pdc6Da b";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789866466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2GOIQfJ4bDeLmMopprtcZG7Nh8TrMUvDf5T9aGfuhg=;
	b=v+MFxzzhOWo61kCBNsDG7sMXbkOte9fmP391SRscp4i0Kp2dU0llcyobv9pqFi0Enw8IuI
	QMekBajSIgNi0w9pJ9t+qQSquNWXquSzsGtLhFlnRO/82BWLEqiCX73GQpHlOoOs8r/Gjr
	TjgwM2zgvxPTwRx0tljB+05Zpd/xBHg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Pdc6Da b";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789866466;
	b=5exlsLuL1ZamqSS/xBouGQ+JZsXbSZhSkewIdu29j8QhvM0+NZnPNRJ+5tBbcfGb1rNAo4
	0U9diraw3+GopCK7xOMhVJllC0jf7DpdQJIq4eWCcfURBMwJsmnouWrP8vEk7mhobPUeJ4
	vkAN9Rq/XXCARtvESRYfYP9+cmguZA4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=b2GOIQfJ4bDeLmMopprtcZG7Nh8TrMUvDf5T9aGfuhg=; b=Pdc6Da
	bRI5hQv74SAhUyEsQ7m6MJ6naENkUfD9RL4OJRa8leXWbar+hCtKi4zI+xiqCN99VDdDtf4Y8Hujp
	v5gBRlB/Se4g+ESvOWvaFrjb6wun/7fSGO4EnYXRkeIrEW2heUy2uKTZ+dgT5BIWoeXrRxZ9MdmqD
	adUenGybBOdlNOACzDIOnbgsN6xup/QBRqu7gg45bU16A6jc/JJkUL70s0P1nHKelJLSA3cnGulHO
	6CcdEEZBFDpdEQhxDEwmVtZt5cmvsux5xecBA3c4zKQUWdnpLNZd8kSa9D9amrPmtRfqoj70f1WnD
	bp0QhSLiU5zFSArPI8vsuEKZngdg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x8613-0000000CQGs-3lB1;
	Sun, 20 Sep 2026 01:06:49 +0000
Message-ID: <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Michal
 Hocko	 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt	 <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 David Hildenbrand	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi	 <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song	 <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>,
 Chengming Zhou	 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>,  "Liam R. Howlett"	 <liam@infradead.org>, "Vlastimil
 Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?= <surenb@google.com>, Qi Zheng	
 <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu
 Xie	 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price	
 <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet	
 <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>, Meta
 kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Sat, 19 Sep 2026 21:06:48 -0400
In-Reply-To: <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
	 <aqBT_35E-eSoN_zj@cmpxchg.org>
	 <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
	 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
	 <aqU81l1oqGItb-0C@cmpxchg.org>
	 <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5FFF720005
X-Stat-Signature: 8jfuepuyynw7bex7rcbca8udxwsnutpk
X-Rspam-User: 
X-HE-Tag: 1789866464-601711
X-HE-Meta: U2FsdGVkX1+w3tz6sPBA814R3va63snjNha46qiIm9BisWq/72AYFGPym4gjHV6pAmRgzDMyfEaC37gFIuvS3WKIFws1m7F/OlS9MM1Df3u13LF5rLgOCEvht/7eIjd8fhS6gMBmIJhl7BxOjlMqmuKIB0dvG1ZFUTxcmtl0FiipCTXaq79+kABPRrBTzCdLRNXlvq2ssA7MEJZMdmMuYWnTk96jJ9/2CQvgzcooi1hH/5oMwzBWD521aZY9P8HjMKKydsTLWP868qArxRupOC27AfdZJ36mFZPM2ESJCwNY267Q+M0hxc+gd0Ohho/EN3u67q7+eWBxjOZr2WsrT2EpUbT2MNhMAb77RZ5T27UorkUWU678atOrRFeWADtu2JPNgYYdbdDRo/C1t7LAosw6IlFEZlxgC5iYoqImlgQD3J7lPydIAo9H7U2uOCBTd2nXDUNeNoklwivaboICejQk8G9YfGEn9XXzXFGxfdC2r7gJ57cqvLD7TRpAoKOVJE4ERyUEEmUYFW3oJZ9qJDQNpKs3QHdxVkPIqrc+pnvr28qqLbJr4nA/Sldi4Q1DCJ3ZoVeXTBRRolAYb/cR0A2F1T7+5RjNiLc3AEOtR/xklTyWdSE9KE7jRB8nGxq+oazftnJFwKtOvGM9Sdd62GcjVdBdtUwjMOQHXCGws67rXROlvor9/y0192WRu8CPlrYTgSm6JsKk1NRk1/oqGglxFC9wA8VFD5nqFOKagxmMjXtujrdbT403yhc5sVmCkCVN5cyIiPbKyACT9zUHbw/n5GaBPiJ7UbeEN3JHmkyY7K9Z1C1Zj/p40OWISSueVpCgF276kJlJCbtTPqGPt5bnxaitPYf6EeRuAbgOSuT6HcfUNk+5WR90sEihXA8vWJMz6CrsVpVP+G0bhSksHQTmkkpSHfE/Uugx7gh+zm258HhXuKsd2HvMt8SZIiTHagm/lpPbXKbruupLpms
 hekpQSdA
 AjjJ6z9E5kkl6W1EBpHjkoqDjHjTcSi3Ss11uFeitkXnw5wbD4G/4tC0RB0U5VSaSKd8VpKXTpGkqEeKFnOAqrOgpBHG6HxPanJZeRaV5bCCbRK1oVxPwf3XXL6tKkCvl9mIphtL4fUbe82tYWgF+hIqVZ/50NMM92VTpfudm3WqZ6I1wByl1s5lrScmNLue3VDgWwsu8CFRtgYtIlwm+u04ThQV3av74x6utiDEqG39csDPSpN/fHDhYLuglTgQFnftIGVxK46US6L95frIt3TxAIzqYrZnzEg8tMzP6QDgAamu7mDSO1HPKkIEX8ICjg4DAadGbZ+b0rGhsvvkI8+k16915xG7hIDTkB+ZaBe6k1SoXBOa8/jHr0XrE1KeC2pIkmkD+4lAFo+WzvkB8SQ9VnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
> For our deployment, we only compress about 7-10% of the system memory
> before performance starts to suffer. The feedback loop will scale it
> back. I am very curious do you have actual work load to swap out 100%
> of the RAM.

One common workload is a web browser with idle tabs.

Those often compress pretty well, a ratio of 4:1 is
not unheard of, which makes it easy to fill up
1/3 of memory with 133% of memory's worth of compressed
memory.

--=20
All Rights Reversed.

