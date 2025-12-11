Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1C5D41C3E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 14:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972EE6B0006; Thu, 11 Dec 2025 09:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94ACA6B0007; Thu, 11 Dec 2025 09:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8128A6B0008; Thu, 11 Dec 2025 09:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4ED6B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:15:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E791F139C3D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:15:20 +0000 (UTC)
X-FDA: 84207387600.29.8EBC043
Received: from mout.web.de (mout.web.de [212.227.17.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id 91AD5180013
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:15:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=HGKt4wuB;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf24.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765462519; a=rsa-sha256;
	cv=none;
	b=U+lT4ZeK+9O7J1W0QQRhgzxuy83Nyp3msBFv1SRTkb/6CWSsPXkrt19Op5rr7Z8YEW3wx4
	wdQ+XuSmlubZTR69icfFF0X6yufs1dVarrpQq7cEaJLJSM9NhsAfe3Wq2Z6NAtYhOT5yw4
	IbZhIJy7jybuIO6skW19HyJtLNME8zE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=HGKt4wuB;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf24.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765462519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXPsWGzqZNdQCafR+rn1ATjDdBIDY0Ma0kVhJ2NwlQM=;
	b=eILlZQwi9kcwTZN8LwZqn7cD5THfz12HYu/gneFLQ8aPsa9GVhHmNbpzDGbfnRSm/5ppHj
	DOq5DCbZDw2jHyv7gkB4pPIOUsBlFz0DyCKEegihSfFUV7OPjgi2bdxUxdUQ91pAOfM3t8
	0CRHKMXME6sHOpAge5A8HExZuB06v0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1765462516; x=1766067316; i=markus.elfring@web.de;
	bh=HXPsWGzqZNdQCafR+rn1ATjDdBIDY0Ma0kVhJ2NwlQM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=HGKt4wuBitpFeSvoH0/dw/c3/ZM7WUCiSGzQDjPWa4l4Tnb4CR3x1kZ+95diQzq1
	 YuPdAlew2E13mckZHDeNcmQYV3NUY2iYnchRWgmmPyTnAQYC3TN2WL32C/set4Kl5
	 K1BkOuqb77rsGx+gLsHLp/B0PLlvU152amR22ZfNcoeVUYB6BSmtVo+oxuZavBx/Q
	 JzECGfMPP/TW4PGX+p+Bl9oYLTxtRgLWkwXvftTJYqvLyov+q6afLpJyGh9kxyIkk
	 NA3/sNimV2q4rEh5xs/JKqPxNlzieNipiDh9OJqx6P6udqO2EeyT4xxnnqIN6ApCQ
	 S9520y85T+mxXYz21Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.1]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mc1ZN-1w1Om42sJj-00g0ku; Thu, 11
 Dec 2025 15:15:15 +0100
Message-ID: <22e31f45-55fc-43c6-bede-fee1c829aefc@web.de>
Date: Thu, 11 Dec 2025 15:15:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Kees Cook <kees@kernel.org>, cocci@inria.fr,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Vlastimil Babka <vbabka@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
 llvm@lists.linux.dev, Alexander Lobakin <aleksander.lobakin@intel.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bill Wendling <morbo@google.com>,
 Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Harry Yoo <harry.yoo@oracle.com>, Jakub Kicinski <kuba@kernel.org>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Justin Stitt <justinstitt@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Marco Elver <elver@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Pekka Enberg <penberg@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Randy Dunlap <rdunlap@infradead.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Sasha Levin <sashal@kernel.org>,
 Tony Ambardar <tony.ambardar@gmail.com>,
 Vegard Nossum <vegard.nossum@oracle.com>, Yafang Shao <laoar.shao@gmail.com>
References: <20251203233036.3212363-5-kees@kernel.org>
Subject: Re: [PATCH v6 5/5] coccinelle: Add kmalloc_objs conversion script
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251203233036.3212363-5-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:VtTnkvdHyx2N8zaT7+mVD3UDdwU4U/rdXNiikXVORMv6VYV8Ogj
 QO81oGcmk1PW1LR+HEFchod3sdWVxqB3i47bFm+BHhn6aEGGcS+/9M+wmeMWv5Mg8qMX/pw
 8FiNvrGdj2vCRWC8hS63XVG0EBqP1REZchF+gMueq0w2iygrZGK4/OQJCOo1091iqD1h0q4
 2gGabs7EbmLApY22t+/Ew==
UI-OutboundReport: notjunk:1;M01:P0:soOv9wERWaM=;YnN3t8FtRA8Bt6Lr38W/P8Eesha
 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
 AU7LMQ87Gjr0AixRxww4Gyvk3U0+5X9BIazYOg
X-Stat-Signature: npcep9nseoqrib4gmocou4zdj468jmxm
X-Rspam-User: 
X-Rspamd-Queue-Id: 91AD5180013
X-Rspamd-Server: rspam01
X-HE-Tag: 1765462518-449807
X-HE-Meta: U2FsdGVkX19M2AdMfFp0WKqQoqIxeGm2hYzWc9CgJL71fXrIEulzhioJ6PFJgzjFfbf5evJqbHdYoLd9Y1zGdCQvewvly/3Y7zGXwn66/iRQ9o6E/dxmCyy1fMsN4LcHo0u/tpF+GyEJiupJJg2GsnsxiAj7QQmR1HVQb/wsI27eaJ0EuejIPqB0gZp2slPORAfcfFfKPg1uicNOSIOIU1gomdjbZS1LxUz9i6LqCvWpng9D8f8Q1ohoH+u805nbe5lZycpaEKT9DcBrZ3OOCGSZN4wgZ3Feinau/wq3A1ZrAnkKTt0uLXxirMBGDhd2FXlVi/uzWdnDrl2M96CyU3JGy9ZLImiBvq+66inFYJdtvyNGOTaq7lqg6rVRLKYMX5rUuGiBEQksFsyJ9NKjBn03ftUC9oFBAZYTJOzN1oqAdFPlwb53DA9EV03H10HKuFdeIhpe+4k1cl1iOTCo3Xcangi1AWD+8ZPNPXzj30Xn9t3HQRScBmKkqsEc6Y1O1zUgZPehXTtPWdBkU2tYf9O57gr/gQm7cFRnvUzdavmdmIWP82O5pXdO1G2z4eraHQB/KagD1X6cPB+ORuKYsU7uzeNeX8hQIntivkzq19/s0Ex9w54Iu36Hb7fvkCcK682PqDHC1QwVf1J6zf5a3AiuFrxsgUNQTEGkQ/ZET7QCUdX2pEGi3V78gFhz8RWMOpZ5JqU/FCu2o37Hj4LhyvBdXGB44rKkIgM+MY3PfaNQah1I3+iyMqcoYIqZL6lMWE0ydulOp72c3+zMuMumzt65ycnhonRD+xkmE6y6lr85BE56D5CVBJfy4tlGg1p3hBJQRtoZfgtXLLc86bxIlVoI3Q7bcbyuuXHnkfRHe6AIeNcLQ/ByTECApCu8bubnvbdv8pMw6YmXS3Sy6Ncj+yx1NMMsMxxIF1Rl8nuWby5VnzJhJCW6uy2WXPqRGJA5HSehlxuMN+S7aGnNzzS
 oJfsZUUP
 gMG0Qt4tyTvBd5575G5UZSgiEOCBXbeZ+2CTrIQIzSxczvIt+I8i+UN8Twh3tFgwkrH9hs81LOLff/MtAtCQR9c9WUJYhcMeS9/FmVDyVj/u9U09/E6a2m1SlgrJRpGdskzui8Ef26nCeSaf0os0KvqubUy1I28NkLVbNJr5+xkHzQ+6OiqjCSDG5njP1ASXzKd6BKxS/XcDCrP7ym3OoiELAAkwpTKxC/iCSiBJT76duWpVzsPXMyRghR1d19Da68ZQK+f173p1yWDxvzgAO5NNr4v9xeCmcgMJ1TmjJpN1fyqAcSfI0bvSYxFJY8x6JTDUmQ7oPD0fl1GQu1u/5w+l8fwP+GldQHeJ4VXTMIqTqzNcGCvOvj8DyrABJFLj+g/nrF03oyyk2tOkj9/UZcEBaXQnMif2GEXDpBIaU8uBOUeEsq35cs5G2nLBjXCrY4RRJyuTGH860ctfKqHRVVGy85mXWZea0AP7Ck1o2cIyMoEMhzqXCLqJ7tUvh9qwqKv8eJKw5v43LsUa80b/PLb6JkWBmw33IogddzoJ5C3UZB9Y3iad+h+aQGwWU8T8AFH7wyTAV7OIudvwtjE06R75KEtaPeIyC8cOyEo9t2yCq1XwQAI/kvGtS+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Finds and converts sized kmalloc-family of allocations into the
> typed kmalloc_obj-family of allocations.

Can previous patch review concerns get more development attention anyhow?
https://lore.kernel.org/cocci/71d406fb-9fb1-44a9-912a-7a0d270b9577@web.de/
https://sympa.inria.fr/sympa/arc/cocci/2025-11/msg00066.html

Regards,
Markus

