Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CAA3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E366B00A0; Wed,  8 Jul 2026 05:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF8A6B00A4; Wed,  8 Jul 2026 05:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414B46B00A6; Wed,  8 Jul 2026 05:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D95A6B00A0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:16:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD1F61C3D38
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:16:19 +0000 (UTC)
X-FDA: 84965053278.19.6C9029F
Received: from r3-21.sinamail.sina.com.cn (r3-21.sinamail.sina.com.cn [202.108.3.21])
	by imf07.hostedemail.com (Postfix) with ESMTP id B3A9940002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:16:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=YMfn72DM;
	spf=pass (imf07.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.21 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783502178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXLtkRZzYzQAT/EVh7Pvcgm9E60jTN6ZHnsAjgB9LAY=;
	b=yweFd2oe708AsUg2YtIV8t0LWWM5QXKzxJnYx2rdpjWnPmDfUwGHbYkBG8hgZW5btc6Blc
	YwfpN47biI2kT+kzNaHE6B6cVK172QCvEGorHpH0T3yl/SYMOAsM/v2p77JAP7q+QRN+Uw
	camr9uzuIkbUGDFijcvjXJOMCcCGtfY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=YMfn72DM;
	spf=pass (imf07.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.21 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783502178;
	b=wGiSBWTtyY1okPWfBXDtnU51ElXhZkpHufx2Cx0L0X5gITprSksd4Frrjyz3h8GkOXZpqf
	zEgphlxzGSf5BR4JEEKabaPderiTYe+PhWsZeGjeisgw+ajtbKQzRVhwsB9I6M2W5pZXTp
	Zhk2o4+jQ38h/Ib4LpDzOI9jJkodbCk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1783502176;
	bh=QXLtkRZzYzQAT/EVh7Pvcgm9E60jTN6ZHnsAjgB9LAY=;
	h=From:Subject:Date:Message-ID;
	b=YMfn72DMwaiyscDI0Eg4xlFz/uW9KCnM+g3Uo97uv3VhGr4BXqwM/z7j9W7mdWprT
	 7PoYnjDiGpLPdpqqO2GIp7TQqpQ5j53u7W7YvNyRP0r3qH6lrzKre1YfLhV3hjgj8f
	 FWhqbf/nGesa017PgpsmqIcFdCgXVL7A7f1lS0xg=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.33) with ESMTP
	id 6A4E155700000FC0; Wed, 8 Jul 2026 17:16:11 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 3828746685332
X-SMAIL-UIID: 1D5BA4D9ED2C400BA61570F7063E5C39-20260708-171611-1
From: Hillf Danton <hdanton@sina.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: tao <tao.wangtao@honor.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove anon_vma_chain
Date: Wed,  8 Jul 2026 17:15:59 +0800
Message-ID: <20260708091600.440-1-hdanton@sina.com>
In-Reply-To: <7ee0eb5c-619c-4c3e-86d8-0c963d94df76@kernel.org>
References: <20260707063308.29176-1-tao.wangtao@honor.com> <20260708043751.421-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: azn8g1orepzpw7uow4kdgrg5f1kkkqru
X-Rspamd-Queue-Id: B3A9940002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783502175-432562
X-HE-Meta: U2FsdGVkX1+3nLSKKugtkojtrZXa5ps8QzQuiCeXbAIq3SzZoyz1a46Ey5tM8y4HhwhWgOXYcGxuF6n2koxZJhmlDsu9yIdSi6P8IYNUe1rChemjBmJbgN/84wUGEoXcY6NLbffvCsfRdieg63TRv2LQ00VYU32o5F9kXoIZabrzPD2OaLyDyN5JGX1Q88JnkIqpeCiUOC4QLymA596CWSgFMOmT+WKDCXvUkTmzHXG4nHdF5N5Qdc1/6N3diejhdaLu+u9IvOc2H5jYpYGvCyN9JDZBxIr59EDciESBgGS6x4qRNEz2h3U/1pio4M8PPhiv2WrCWGFDPIjpDnqMDOVUjTHpexPRgKAApI/Lli/hOdXWngnMniEmnz2agOomKn8XzVRe8BGIPWVaMnje0YAPlO1ajZ7pj9q/ee03dOENhtxy4mKbjjdBX/XG5nfoFMp/kDMuj2GFyeB/Ez98lDv25ihxgLMOXozXF/GD0V8XL61wiHo0MIV53wIsXrZ3rfgUR7fidcOjvT7vM+pp37VwJhKMBPn0T7yngtPdZsi6Zo+7JqrajitktaJPIzr296SX3HgmPh4Rw5JJVYKZd/s+IYs6Lvu4KpWyDfctz2PPG8DctBSg/RmQs9U8XU87vkn8+aLQRWHinWlW5XikgI6om1uVB82J6sxjnWxNdvX5z36z0Y043Zbp0ePnYM52iQrYbtC0oOJLtnkIC891OB1Mfm4iC0X1xeQ7BqhAriUH03jC7SILy0fNo8/7AuQaMaWV+wua9uZSc5unJnIPZyqAcJ3zcdCX92ya5kFjt7U68D3ILfMGdzsFjdHZNH4vEccG3nUYuYoAncx71qwe6Vw0P2Y33h0IC5v2Jp37NNIYsAnTyK38WBYKFhEF/5rOCgq/iYowGz1xUarHolhwLlcTTn8DJDMAVfjBaumys4Dy1qJCsU7saxH9rgKHJIRjDdxzIQ1q3rZNm4Fjw3F
 AOW57+vz
 FvO3wDV6Zz6G7nytr3QR7UeG2tRcArP/CFvQx5j7viQfL0KTf3GAx4GCG3XKyZZpgK6DSMStRg/m4tBARldIMu6p9OyL0BgdEnSUtpJmMst/ZBXyYVwntOkxnuBMNv2abEUSUyGIx93ZYQLbFTeQz9fHMgJlJKinTnhO1+7onzaajlkmGRIikpMA33jhZK2do8yUxlWwudNDhgxXpV9gJtPYSaCarG11j0Cyb7q3/xPfp5trgwzQD0m3CeXu+sKHKfYhDyb2M37oHhy0VBSsfAfW3Cn4sgl6v8zBKlrsDG55jFaWgIv4UiBWD8kN+vR4T+m3aVicM8qHtDwktRVZFwrieNT00WxV/BM9K5m80Uy/BUo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Jul 2026 09:45:00 +0200 "David Hildenbrand (Arm)" wrote:
>On 7/8/26 06:37, Hillf Danton wrote:
>> On Tue, 7 Jul 2026 09:01:04 +0200 "David Hildenbrand (Arm)" wrote:
>>> On 7/7/26 08:32, tao wrote:
>>>> Hi all,
>>>>
>>>> Since v1 was relatively complex and difficult to extend, this version
>>>> adopts a simpler anon_vma implementation approach.
>>>
>>> I really hate to repeat myself, but you seemed to have missed my main point [1]
>>>
>>> "Lorenzo has been hard at work exploring various design options (and I'm afraid
>>> he might be one of the 3 people on this planet that understand anon_vma in full
>>> detail), so I suggest we wait for a redesign proposal from him and see if that
>>> is doable?"
>>>
>> Given that no numabalance could land upstream without horse racing [2], what
>> prevents Lorenzo from becoming another (scarlet? raven black?) lipstick given mglru?
>
> Did you ever look at anon_vma, or are you just joining a discussion to say some
> words nobody understands, really? :)
>
I know this is lore, not a dump land for you, and like thp and kswapd for instance,
anon vma is a part of mm, nothing more. I just want to know if you are telling us
anything true.

BTW are you one of the 3 (legendary knowall) figures (with two heads on their shoulders)?

