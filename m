Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8A1CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 01:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52F38E0021; Wed, 20 Aug 2025 21:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCFF8E0002; Wed, 20 Aug 2025 21:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CBE18E0021; Wed, 20 Aug 2025 21:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7830A8E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:22:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2639D5751B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:22:58 +0000 (UTC)
X-FDA: 83799015636.27.F6C8912
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf19.hostedemail.com (Postfix) with ESMTP id 458891A000C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:22:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755739376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NH1fi/vyTlrzTSRKkuWKm/XIQu2VaSLxsIHdmJHtC/Q=;
	b=1d7/TI7bRjGdayR6sXRi8fgVo2hgmWHKiXuTtm7vAKgSmfEeHQCOYquKllg2WkeiQsm0iG
	j0Af0YcQ6vsyuJ+ZEfmfBAI43Zq3KJnF9LX94l+in/ojQAj/tTezCnFI4Cbn/ssXPvKncM
	1Sixqmh0KmEOE4DaNA3JWwM7og3cwxU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755739376; a=rsa-sha256;
	cv=none;
	b=Orq6jgF1RCXTheuQWf5c2uOuTs8mCb8KS7h2Vau+QOzg3h4EAMmf/J37ZUz3CUmw4H4j86
	QVJUGKUhDLxh6LMoEcuBBPV3owMCgitkxdje847kDZ7wod++A9xbY1r515V2PHgCeDAfH5
	LRbUTPAW1rRoBQ9kY0Akw4fpOnCHQ5U=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c6lnb4H4tz2CgDC;
	Thu, 21 Aug 2025 09:18:27 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id A2AC61400CA;
	Thu, 21 Aug 2025 09:22:50 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:22:49 +0800
Content-Type: multipart/alternative;
	boundary="------------Wj3orybyDPrt83dkodt2IcTe"
Message-ID: <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
Date: Thu, 21 Aug 2025 09:22:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
To: Matthew Wilcox <willy@infradead.org>
CC: <fengwei.yin@intel.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aKXCz0QOlE8QkPIn@casper.infradead.org>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 458891A000C
X-Stat-Signature: k98d47pk8qfhpnbq79ia4zxshmpnj1xx
X-Rspam-User: 
X-HE-Tag: 1755739374-517463
X-HE-Meta: U2FsdGVkX1/AiOUJ2JQCQw6ZaWfjOG4Kuxl5j60Zqszz7YUX1XUR5vMsnltyfURXoZWH6rl3ItulFl4uNUkCToB+6HT9pIcPEhVcGLuVWdlIRF0NqW4XkSsqSh9D2pmW9N+jm8wnIYrQwPxXzFcPutQ+T0ZzE/9bMnipuofA116iOUv3vaNqD55UhxWPW2E/HqfIbOJyS+rtXFYruXFVRDv1j7oECIx26SRmaP/IO0HSVKYkPRJZQlTzJKP0Z8xoGXIaRCl7lVxyH0k0DpXucG3negRjnEM+q7cSEG6cJCW/hwBFkrfJaTAsRpKYmxiMoM864Ojp5fd2U0LXdDmVrRhaCaTDxbANngbBXgxIOMVjZLhhHU0x6TvoiTsm82EKDUb2FbXVXuVhKC2JWPeturdN/HiJ7hYm2geBq/0NspyumPUTrCnitvEnbly+jnYsEujAPf9rew9e481xDqco5OxNA8J4n5hZJVHZnwnL6copcumfBFlkjyYO3k70Q8J4XwsWTaBxuvRrMLwx6FUD+YU0ny9B/gdiG2G77GUMbGSXTu3tBKWkpGJUEs0Fqgk9hR2qivFy7HhP/owdtn1oevltxvgmZav7Pjtj9teKWXa+uaMRnZnbd4+wkYl4cGAtHKxUwTJis8kWiibcTg7hyenj4Fkl+mPvi5rpJC/mnDs+g9yVGpHlbzOJlEneAE0iDnHcgBINN8SwE42n/vV9J1WUm8YZzzD2VZ1M80GAkAUnikbjXxW5nbLUkUVQKI/+uz8OKa47umPoqeqpsIJEff0O75TwhMexc08xBTMmwlQ7CvFlAPR/jY6iEGsjJCvAV2Q+NDrbzmNVdS4MXF8e4+84UVyMS5eXrjw8vZ8Q76B4OpCVGptJ6UAc6xijvohtgN87FtzimxTMjt8FL8CUVoZZ0OsGYoj1qbOE7PLl45vpJ9oGQI3qUHHu83y5FnAiKfd6Kfu9UhCm+U9fDJQ
 10pWlJ5c
 JIGAx/NJHObEV5anZHWqvJCnaXWUHBF+QbbrQfsTEY6mcyKICMl6MLGjsrKEkhWuwo7r5knOHRPI9zHyLPdSB09KqnhbIFisQsdLFobZ+144VfVl+amVHjCgVHPYKeT9ORatYt6GFtck5D04iDIo+azqQleyB6MWDgfhajwa0H6dr5BJ9lhPqXE6tPAPfNCz02LRmKLJcfTEU1/+vISTZkYARYkQL6sGrbTfqexjQ/xGAB+tTamDMD/tHwq9K0qrDkzNChRbSLKf12Jtn7RcxEye+kcC/CS0bcPLfDIpNLo2Thq8RLG+C7vwDJ/hd/Z/U1Gd7iBjoVzvPpr86GafaXScKAi+oGoJ1RDU1wk32OvWCBhVg8iIvnxJSxA5lugejUpdx5G/xLqonMeNf7z8AQ4wtGA3v7hxAsOoHou2d1nI77vcPN9nhOnWqvqC+YIZfX73G7yUiIVi6AII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------Wj3orybyDPrt83dkodt2IcTe
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/20 20:42, Matthew Wilcox 写道:
> On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
>> 在 2025/8/19 23:52, Matthew Wilcox 写道:
>>> On Tue, Aug 19, 2025 at 10:06:53PM +0800, Jinjiang Tu wrote:
>>>> There are two meaningless folio refcount update for order0 folio in
>>>> filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
>>>> after the folio is mapped to pte. And then, filemap_map_pages() drops a
>>>> refcount grabbed by next_uptodate_folio(). We could remain the refcount
>>>> unchanged in this case.
>>>>
>>>> With this patch, we can get 8% performance gain for lmbench testcase
>>>> 'lat_pagefault -P 1 file', the size of file is 512M.
>>> You don't explain why you move the folio_unlock() call
>> We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
>> if we doesn't set folio into pte, we should unlock and put folio.
> I agree that folio_unlock() needs to be called before folio_put().
> What I don't understand is why we need to delay folio_unlock() until
> right before folio_put().  Can't we leave folio_unlock() where it
> currently is and only move the folio_put()?

In filemap_map_order0_folio(), assuming the page is hwpoisoned, we skip set_pte_range(),
the folio should be unlocked and put. If we only move folio_put() to filemap_map_order0_folio(),
the folio is unlocked when filemap_map_pages() doesn't hold any folio refcount.

--------------Wj3orybyDPrt83dkodt2IcTe
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/8/20 20:42, Matthew Wilcox 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:aKXCz0QOlE8QkPIn@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
在 2025/8/19 23:52, Matthew Wilcox 写道:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">On Tue, Aug 19, 2025 at 10:06:53PM +0800, Jinjiang Tu wrote:
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">There are two meaningless folio refcount update for order0 folio in
filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
after the folio is mapped to pte. And then, filemap_map_pages() drops a
refcount grabbed by next_uptodate_folio(). We could remain the refcount
unchanged in this case.

With this patch, we can get 8% performance gain for lmbench testcase
'lat_pagefault -P 1 file', the size of file is 512M.
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">You don't explain why you move the folio_unlock() call
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
if we doesn't set folio into pte, we should unlock and put folio.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
I agree that folio_unlock() needs to be called before folio_put().
What I don't understand is why we need to delay folio_unlock() until
right before folio_put().  Can't we leave folio_unlock() where it
currently is and only move the folio_put()?
</pre>
    </blockquote>
    <pre>In filemap_map_order0_folio(), assuming the page is hwpoisoned, we skip set_pte_range(),
the folio should be unlocked and put. If we only move folio_put() to filemap_map_order0_folio(),
the folio is unlocked when filemap_map_pages() doesn't hold any folio refcount.</pre>
    <blockquote type="cite"
      cite="mid:aKXCz0QOlE8QkPIn@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------Wj3orybyDPrt83dkodt2IcTe--

