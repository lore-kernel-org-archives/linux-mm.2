Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BB0C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF4D6B008A; Wed,  5 Aug 2026 21:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB0866B0092; Wed,  5 Aug 2026 21:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED016B00D8; Wed,  5 Aug 2026 21:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2D56B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:20:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A4E3140285
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:20:06 +0000 (UTC)
X-FDA: 85069088412.15.A2264A7
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7009B40008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:20:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EFycoMjV;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785979204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/+nTc6O0WG0Y1/xvBADeCeFrKXhbylrN/hsqGlgwtA=;
	b=lLAUka2Iql8f9qbos9KFZNmFYvLmfqJsA9MFav6DQX0dbGHOAmcNRiszv1BVcHr6xpRvAI
	tv1haF0TNi9vwRudgrVw6tnkU9Vu+Nvyy6xwU+fwZZBg/lKw/vYexLpFChxGwSfjkTjrDj
	TlTblk9UdR/mPcHCsR1vZWfnLEDxcCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785979204;
	b=8B9XFzQiFGFG7w5fTiQxQ90rFty5kgE8tiVel8SGsn0G5tkxjwQMy4cbVHXfW1rUGTBPwf
	787icjYcE7aG2/iFAhdoaW0mqB2kBUuq1Zm/FuF/OOJ2q7ZU6Uh5VU9QSb2MCdQ+XP5bv9
	458DHalIo8ZsiXYNWncIPhMy1Y1LNdA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EFycoMjV;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785979200; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=A/+nTc6O0WG0Y1/xvBADeCeFrKXhbylrN/hsqGlgwtA=;
	b=EFycoMjVPEzLImI9+y5IhieR6xTHIQEPk5oWvtiP27inBBbRK9lF/w827/q8QaShUxG65SwMGa0eJKFRDWKkaqLyb8ERAETBsAKv4kz8YHpbFZ8DGn+KG0+6WZWK6BSHCp0t9KAEuoek01UVz2YgcTrXClH8m3aQB7QgEPGi+Vo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8SKf9F_1785979198;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SKf9F_1785979198 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 09:19:59 +0800
Message-ID: <63d185fc-9bd0-4142-b6ef-c8f8cc401e06@linux.alibaba.com>
Date: Thu, 6 Aug 2026 09:19:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] add anon mTHP collapse test cases
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <anNTCO-mMa_y0AvA@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <anNTCO-mMa_y0AvA@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ctagazzdkkt1jqgj3rq8sey4u3f7skb5
X-Rspamd-Queue-Id: 7009B40008
X-HE-Tag: 1785979203-86024
X-HE-Meta: U2FsdGVkX19pmYZUphsjUyTPQGIBooftye9ZyYsYZLJN7heaNRfq+4C1IykMUs/wBFDQYxsw77aOyBQHwrO84/tPY1sIeZ8FoRYjIGb2y9TY9EaD9h3QTe6FlOdkpc0vLiZos3meJW2AiCSiaKDeoYLox5jsAI706dbCMyhffAl0lUPXBYznSzDAPit8fMImmJrCnCBkDNOFT26cvSy7g3qCAm7uyVzf9FUy7KkbD7ib6895KzgDnnrjaIeZzWUkDoYax5KtV/S+CmaXe89AL1oESuCjdAwdtvcsGdxGRgqeBmBvNL5X4Br44zgTDpisMkJy4XmtWxIwO8RqAhnU6HxrOMb2l7VgFoPIjBHBeE6RycfpJrne9v4SJVkceNDQXC1EMkZoy+LLIblLSI45uBQOwfk97KIFTP1XD9GBLK5uDWwQ4g9zn1bV9zFVStUom971JYdwFppCZr6xJDecOvq2hz1MZ37ft43v6M8HRIqEb6MDBvwm0tlraHTw8+xrmop1dHaLfN6bblX3VxU6eqkX9R5JFuoVqjfYXHHMN5wT4H1ZXGHW2wJ1gFMheI1MNYU81Nuyoy7FZtOBaWoGnxgsYpfrtW+vUq6NPf5ldJraMJNLHj7Gat24OHw0JXtZzLZibRr81w27QGWR231MXma1v5Xv96ASSSKrhJXvpMJueeo5QUiqva6FDKDlWBnN5dAJdmplIO8LCThTdyyQ//qf+a/fciJjoX2Kw4NAPtKzFNWvhofzsOaft1AjAnMLg9RXaW5mSWKlchjgdbIXPPyM9GOlmAFHS9BgyQO5cT0612/sQ1KRKB2hgkJR2jYXWekU/WalkgYj7O7jLPEJm9Ev+lFtVD5HPHgF3SE4or1sky1nkXPYqeQk1p6uuPruO61v5EbvKSm+eeqYI+vK0f0DXBre84JVw3QGUpvwbG2ASl21bXf+KISlORuEbVjl9O6PNeeT4u7mTY7Zc9k
 WgxfbjY3
 InjagNBU53uhMudPVuutt7AF5G6H0DsJ5gx7BbvoNGemQivddDojsb0+Ps3OZITVZ1Ns/tOx3Jz+xkxtsZpKhOurRY7/kcW0ZGtMPRwfEYPQfug0pk5ihlBtH3dfW3AknvDIErx95ktHAvGAQ02Bt7ags2bRvhdpNNXolsTI6OCPFdO5Y9a+Xgt+ZY2W4nGRrq6JdM/mlozC1FYyF9odvdtkmnG64T3lCvXvONcn4GDVbmqVC7yYrVFdDs32amWqou49VkgQbxT+S5MGZ/yW77G5xaH+Obp1fRnofHZ4NZKblDHAbDftOHzg4015AuTjqsGgJntAI231VrlKDyH6LcFbszg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/26 11:14 PM, Kiryl Shutsemau wrote:
> On Sat, Aug 01, 2026 at 02:26:34PM +0800, Baolin Wang wrote:
>> This patchset is split from the previous shmem mTHP collapse patchset[1],
>> which only adds anon mTHP collapse selftests. All khugepaged test cases
>> can pass.
> 
> The patchset looks good to me:
> 
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks Kiryl.


