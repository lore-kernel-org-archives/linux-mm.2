Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163C1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C514B6B0098; Tue, 14 Jul 2026 08:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29016B009B; Tue, 14 Jul 2026 08:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B197A6B009D; Tue, 14 Jul 2026 08:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87C966B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:17:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BE121603A9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:17:26 +0000 (UTC)
X-FDA: 84987282492.25.5F6F50F
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf18.hostedemail.com (Postfix) with ESMTP id 255AB1C0006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:17:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="0 6Cal4/";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=PUhIA20e;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ihQ95OjmEKT/BSLmlhjYTJrT0Ye20Wr9cB27N9s9Bk=;
	b=g4Mvi1F9T8IcjsR2gHJLtJdFyj9dYfWVQrSd0+4lP3yuf2Cj/0iQzjqGiKGANoscMsfRIf
	uf8yKvyr70yXk3WuZLLl6HxRNC2/kR3yzjJd/fWk6zUJO8PgX8O7p+1js/Lymts4OoIP9H
	bOigXL+prOlnMklYrell/wPMhvOHTM4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="0 6Cal4/";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=PUhIA20e;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031444;
	b=gwB0EA1XIp5h8ug/5CG7LD60STGHxYbV5E86Xc3XQ/S78kkO8r9F4F90OeLK8unGO4V5cf
	d9BR/wWByJv4YAgRJANyA1bpLPvEZPks+SE2xyiqbEhsZcdKQk2/xBOaWHm2J+u9U2Lfv0
	z4b3C8g20j1ZwVOaMx/wCjUBMHYgP0Y=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 46AAD7A00C8;
	Tue, 14 Jul 2026 08:17:23 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 14 Jul 2026 08:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784031443; x=
	1784117843; bh=1ihQ95OjmEKT/BSLmlhjYTJrT0Ye20Wr9cB27N9s9Bk=; b=0
	6Cal4/nesLwm6f4mE6byhD/laj3yYfNDmPPOa9oRgs/u2iLf+vvd9RRYQp+QVYmD
	TBtvTo1oLURTI8Y3NirZMchM2tsm01fBVpF33dabcJeHZ1zCMDvVvIbjyADncQH1
	dIDuYC75hnIUdqxzuetfpUKfQooixGaeI+A+FGOEnx8eMw4rcfj467Si9RtsVdmw
	DY4GVf3AjE8xCR+GAStTKCYaqZjz4yw5USOtF0srhoRLUG/+NRvnp1IuDIxopX9P
	h2VbINuLD7sErXZTnQoDPGL13dHtcDIenWOc5IR6pmxbIKvXkUvjgkGX31+uzjKq
	ypiodWU/J+vNtXxOl+w2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784031443; x=1784117843; bh=1ihQ95OjmEKT/BSLmlhjYTJrT0Ye20Wr9cB
	27N9s9Bk=; b=PUhIA20e8K7OeGxDxE9tB+kii0iiNthFS3tNWnYGWvF69vWrCHg
	nUqBzU2Talu06xr8VfK/XEIssnThAgrgl3h+gwHrS8nvc6nRIR1/VtPYoAndL3WL
	1NmRmnCu9+Y9BF+skcd3Sw1VzvIRpakPSppMZkqoRM0BtBZnBcm8gMlmWFIkXOdN
	FAdtXqwsJ1TCaa1LVBJY300Fb0f+bD4uotZVB7RsYYK4p7soOJ3kUj6kTi2zo+NI
	kQqfVm0kMByYkmEs32csXKloHxBHohv6HpxwnHoVCVk7DaYYMuzSqFQfuXNW93cb
	WhuAKdOzmQidOjeji/dD4ZSvBItYMkFfz2w==
X-ME-Sender: <xms:0ihWaowxuunsTuBeLYM64Y_pCVL57SH61_FLnKHXnOoz5ftNHAQhsQ>
    <xme:0ihWarf7pbGVtMthX8Z4dsQ7zBY2JlhewA4wzj3W8U7PHLbIT6Fp5NmwzY2u8y1ki
    mIuiXjgHr3q2ktye98mRJVmzKhpIktBP_lAPaU1G04G6b3sPG6YVbU>
X-ME-Received: <xmr:0ihWatABuD9zJ6Bu6CZ_e9o_OUmJ34B8obfYy28j5eunXNjrSD8qHJ2U3Ek2Ug>
X-ME-Proxy-Cause: dmFkZTEsdwTDbwuIWMaB3+OXPGbxQuvxRaMxz2BOP1rFQ08rEyIz04CcI9S/WgIWw3VDyb
    r4P2apzfU0OMAfbqvacRmLSnfJbzGfTEEWb1kLxSzGi9CSZWww7f7fxiGKLyrwLzZ9cRtY
    Mi7ukQQ96JKmjFzvuZvEXKfy5SWBlp4NZ+4aUqnacz0SDWDJEu8taDd6kaDX6SZHmcnDQ7
    +FeTxdrFeppX8uwu3EYrS7/1PEAJ/7A/cmRcog8SWn9OVYoHIpy6DT+dSAEfDYj+bmVysd
    yHadjryjrUKxO5MX0AkZv9qRtGied6s/zaQRac10nfWloqGoYzpTNF9vTE/jJlRpYAViH8
    SR8QnHgh4wH2LQigWB5QEEKYJXjwWBTSf3wH7d2ovgxVvZ2b20RvqGcks7mBlLGTnuh7Zn
    QT3bw5Tz9rbkLUJsgbOd2IxXN3nIsbxQq4flRncvqsvtxawA+wjRAGhI03aWB0NqiuKq4a
    6Hp903DMQcumSBBNTUw0kShN4y7N7+f8O35aJyv23HEyog+z5Z5jTurks8/zJTP5IsJ6iY
    aNWMuln0wOVpx9Vc3qmYIIyl5cr+zisAgH7eF2dLJPL8N4vzV2bUh83j7IXxnGFGwfjLQj
    jt2YmvR2slHczMGvfPV5s+kwj6JJWCC5P+lPlWDZxo5n99fbE74cbm8NmwZQ
X-ME-Proxy: <xmx:0ihWav7eCkew19q3Tdo7e-Hy8Xd9FeW9sdeUl6puwRjiUDHG89HALA>
    <xmx:0ihWamdjzwwwo6txrrAazMA9N700615rehIpkUTqsX-9PcrKVvm1Ww>
    <xmx:0ihWaltzGgO40_9ByjsMesEAD5GEvrd0RY6TwUn1cnLTzCpPFCTbbQ>
    <xmx:0ihWammxyYIKuaO7aDTFrSZSqKJVTGPf8noe56jh2d3n9HJi7fSOxg>
    <xmx:0yhWalNWD7NJXKa_9z8QIUpLR6xTslJ8SLDCTclYyA6zsOWxBKWxrpxf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 08:17:22 -0400 (EDT)
Date: Tue, 14 Jul 2026 13:17:21 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Hao Zhang <hao_zhang_kdev@163.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Message-ID: <alYoARy80Vb-X_nj@thinkstation>
References: <20260710071344.GA106129@zh-pc>
 <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215>
 <alEg6ZPc-ao7s6o6@thinkstation>
 <DJXXKH4KOBVQ.2I9NU3EJL88HA@nvidia.com>
 <alYNlDNMQy0Fl2VB@thinkstation>
 <1fc81157-824c-4296-ac5f-e8965f64597e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fc81157-824c-4296-ac5f-e8965f64597e@kernel.org>
X-Rspamd-Queue-Id: 255AB1C0006
X-Stat-Signature: bsrj1yxiqige3x8xfbgit31ernobyeds
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784031443-724305
X-HE-Meta: U2FsdGVkX1+hW/06mtsomhifH0mHkzHa+OIVXNEWbLv34Bbv6G3+K1Fy0QOPriKeyWlVQIKLG1awZ90o/A5LVl+tNZN7Fl/S/tpcDIYuxXFdtckqVuwQ+dPVAvRdgNurpEycm9bJpbZe5b4hfzioHjMpdQIu9XLQCdcIKvSyR6lDZgG8Sh2NgidSDX6Ci07h8eXjWRVGm0fVpbS6AO9Yjug2z6vPlaE+zZIzNGTInbh6eKO97wFKGiPYrrvH1DQ4ACrCpairRh3ZSkeg1s5GqxdDXflVctxuN3qxMArYlg9eKM+R0LsqffZyiY0ozMP8AYTGwHi+0ew9UEfCIJryup+IhRTWfQ6GGXh0yJIWwM/9qmfosOW0b4HyTJnkxZ2CNeQlG6xrZwgA/JoJapy82x1YQEl2t7fV/Dl2k3IGvEzPffU0421mR8hQWL7XSjbjaspAQhi+8jpfwcfj0Cu6O7AT9vLDcQnGUPcxjR+Py3uJuAkKC3AxE9XGIaY1RGL3UPybP7oiMeKO/3Mub675Bsi0WJ5uysbddItNzwV6D3TRTEhv2OZN3Gx+tYP7Wuzri1TmdbZC04M7BDjvPa0vovSvoJyiTpk5c5f5+waHXk3fG/03q3zuKV1yIe705YQu4UC99pLBTHeVnfITHz8XtNkWk4+X4y3rVtPL6b0L+rEEdpGqbRK9g6LlJj68E26PTcsRcOHHY6ICvV601EnLpWjxPLUmc0KjJRt/cx+pcuPue2qhlThsww8YdOEf82QNkHgqubYIR0xtYoHTRYCeoyOIo6/12gcd7bpjR7dXxJZ41Msw1pnuM3LKfgvj8BM5VDbU7fIn3joODN6h8aZjT7xBCK6eL7BMyfZAkX1ZFn7dHo35F4bvyHM/fyDhvJbs1DzCGjtWjpP5cITUoAcVxnXpBqqcE5wPqceXq1uyNod3IEPg2kHOVPRbsDbqR1DkIj3Cp0SeA3ZkN3zm8V9
 NcV7ahSm
 TrShma12rrH1OGWuzJnu2d+Vbl1j+2d8TZj7ovnulqW/cJCCRDo6o9SkWmMlS2+LdcJmMFMc8qNxW+XBffV2dxWJHSREsliYAVZYNyWhpT1JlhgGidk18BpnoItLQjPZgKlABneThEF3D8AnrZi4bSjs2/sZ9KZb0nBxQhNNl/IXsQ1OZBPJ40j6iMrksf29J3NlCsgu/sxFT0HC+fRFq0xUHbTeEzjzvodKT0fc9x9zeT6lgJZ4C5MZuA2o+tshAnhtdezkFX3TwnceSkBNVWBHk5dXWo7Dpt7z4AXz4l4nTu4+n5Lmf0P8/JRcz/F17ErT38+wRFRGcOJ0uFntH0V1sw43HOHNxm2GH/bIaHFlAu5XypVop9SAqbkKrcyMthXxPnl8fCsfP7jwdKHtJHXN1b3kDAZHQIWaLN4SvGDRZ9S5xoemBbfBq4879AAZfhywwoGsMqH97FTRjHGunwoCaf37PepZTSv5IsMuOcjD7z0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 01:29:56PM +0200, David Hildenbrand (Arm) wrote:
> > Any opinions?
> 
> I guess a deferred iput through some workqueue is not an option?

Hm. This feels like a dirty hack to me.

> I'd prefer if we could keep folio splitting working even when the passed page is
> EOF.

Can you think of legitimate use-case?

I will get rid of hwpoison case. It has no good reason to lock tail page
in the first place.

The only other case I can see is race with truncate. Loosing to it
should be fine to split caller.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

