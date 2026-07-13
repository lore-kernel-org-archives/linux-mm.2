Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21476C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08CEF6B0005; Mon, 13 Jul 2026 03:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D896B0088; Mon, 13 Jul 2026 03:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94416B008A; Mon, 13 Jul 2026 03:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C41426B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:11:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F36016A0CB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:11:13 +0000 (UTC)
X-FDA: 84982882026.06.A05FDF9
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D3BC100002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:11:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=p8hAFoYl;
	spf=pass (imf14.hostedemail.com: domain of zhongling0719@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=zhongling0719@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783926671;
	b=XPU1RIYqjI3zbErhusbSF5HW7e3iWYveJh/ZAdR+jA8vjXLCOD+J0EJdR6rQzSx7pCKCDW
	AKFanI9mmpzqg/YytFth3tsVZ8TVQ0k7Wp8/5uORCAJrOc3JWkJcBtB8AJoKn38rllODF+
	L5K008NHFfgpvlSBXkDMXLkszM98DNE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=p8hAFoYl;
	spf=pass (imf14.hostedemail.com: domain of zhongling0719@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=zhongling0719@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783926671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvZfSiXg/aWlGMDrq0CQO4IHt7cZbR24Kxgf0OwSvCc=;
	b=JhMMDlNdwggvUIAkefl/X94EstwhMhVi/ya+bivH5foV3h80LRVihwhp6CfMuGYx0dCAV7
	Y0U/5cnkVNeJQS6yDSr4EvEa/N7Q67c6GdZX2CxNEhWMu09zM5GMa2BkVO34E5CXsniUtd
	qbHCzBAYmvQWIa3M1SPSaLQJKlF5vPU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=UvZfSiXg/aWlGMDrq0CQO4IHt7cZbR24Kxgf0OwSvCc=;
	b=p8hAFoYlLnc0dp0ifPJrUBEJp6BMytpbFdnacsBfKb4oCndxfWj56Gp03c3jcY
	D8BPPuzQYuATekWZoYulu+SgIGUWk21JfENSOLSiYzKJ8Z1nzhfWduWXZWtpLy6B
	qvk1jTwxz4ZCkpOSfupRJSaeVN6eQKGiG+R/DlaPiTTvY=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCkvCgDH72o2j1RqfOJeCA--.8775S2;
	Mon, 13 Jul 2026 15:09:43 +0800 (CST)
Message-ID: <6A548F23.4040800@126.com>
Date: Mon, 13 Jul 2026 15:09:23 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Harry Yoo <harry@kernel.org>, vbabka@kernel.org, 
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org, 
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com, 
 davej@fedoraproject.org
CC: Hongling Zeng <zenghongling@kylinos.cn>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: fix kobject leak in sysfs_slab_add error path
References: <20260713055829.127864-1-zenghongling@kylinos.cn> <bbadc488-e5b1-4868-9da8-26e2cecd93b2@kernel.org> <6A548241.8080802@126.com> <40902df6-373c-4e87-9ec7-4e72f9f0efa2@kernel.org>
In-Reply-To: <40902df6-373c-4e87-9ec7-4e72f9f0efa2@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCkvCgDH72o2j1RqfOJeCA--.8775S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw1xXrWDWFW7tF13XF18Xwb_yoW8Kw4fpr
	y3Jay7KFWDGF4IkwsIq3W8Ww1F9rZ5Ar45Zr4Fvw10kwn3uF18tF4xKr98uFyDCF48Ga17
	ZF4jy3sagF1UCF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4Hq7UUUUU=
X-Originating-IP: [112.64.161.44]
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoRegcWpUjzc9qgAA32
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D3BC100002
X-Stat-Signature: muwjjf9rjujp54rdoqnouimy8wnhfonb
X-HE-Tag: 1783926669-925291
X-HE-Meta: U2FsdGVkX1/XBm7Y7OwD40hm0Bpo1/0FaJ7gAsJqLj9kzcVj7Klq8z+WHSll1JHsjAqn5KGsfgenoZdiDmFu1h5qc1OYsEaSQ3d2672tF2o9boFsS6+uckW7RDvVJ0FypHFVsljjEhMbfelbcH7RPwc/ZfO2qfWNscEiOAjXa4NGu3o3Ri8RTWHN2VXBXMaczMtalHhZoxVwckoKqtp5dlZZeddwr2VLHq2wxf/LetDSC5QF3Ta+djaPgVa2iclF5RZ/1r8QTv07x13TvquO6hFVai7CUQjdBvJ0KHiskTWYx7BYBf15VCnfJkrk8l5338yd8nLJ/QmHeuVMH3APO0RF9wHJ2lr8/Jc5uEKWPaDmJG1h6YoVLBVPpfp25bJJR5Wm0raW+ISQ5L2eywgA3LXo/f4xw0j3zviEPiq2h87iK5gnoy4K+Kfw71aKUy2ESEvc0HywEIcT1qr9RiH/fGjLBMHbMDJ4sTImW79KsxPB1LITpM2WZxA7i3ll7W9KxIBSSa1KU4SgrIfgQjkbpmIZkyFMJiixFPJYCZY1n2JWd8pVtee9AwXRosgwcxNZMaZ2myLpxcZnP8W0rcb9xsu/44P/vZ4cHxzejJyyUc4duy+Uzu5+KDIE8aJlJ14kCj72bvLjtmWlzE/Lc5CH9KdW0r02g1BxlR/1o6FF/P/OIonJKk1IGSnUIetyBkQk2TbEgNIv9SVwOYm4wUAbwk+5SgoIBUKwqky2Q1G0TqAv/MJXp4EbmbjpJ5xPq5O1ugg1dLvihewzUmp5aQCEnuZrIBhio9qG97kBzJCd/Va2DqabRazqOU8s8Hc7RM3c2FwUVY/4SGJIJOH+o3tKqUsZox1VaygvwJ8TNbKUtQGFGhwMWWUZn5SXaMNR1bJFVTkzluAjXGyq7mvFNm3iBIfSF8jct8GlPD8lFLJ+c6y5xH40pgCsd3+FkntTspVOq1+D7czwpRWxCDefhmH
 Kp94UJ5F
 u9LBUkVIsCWzU3u0gbVhR/Non/yanZToCpS0kDLscAofdP5NBH/f0Rv9Gp6GKtFCHGVSs09BaHuyQS0HyYfTJ4AudpW49/nOap+ok0OgyJQ05vgTE9nfBmQeY/JwMps0wn3vLLE/5RMCqivWR639xO0RrNA7XdMUqUQMfwuPNUC00X+B2+NRCOdlbya4WruScSrozi4vPMEr83EqydIyNHpv6ecmM6l+qONUm1Ad6SlbAjaeANYkOgtDpkJlVG0ng9gMUt6F5ra8tGHrttci0DrQYIgNiriqpOFqBJY94xbHspf5nKknYeDhcqbnZ+n3X5soimM56Ze4p37ui/ptcPbwTKAzp/+u8EMbTSIUDoX5ETFkxVOdC58IdTmow4hxC2THd6qTs9yYyPmnu7DxGCqcVTyIhE8iqAsMIIIh18l3LDLMZq4KETG2dvTcqJCXDdrPXAqud/+R9WjRO2Yls8r6B4CeCgxTUGtj9Citdis4QA3o8HGavdiq9h8IyNe5vIC7pbCZxEgjCPxIwCvhgUlnFkgwOxSh7lo9/rzh4dRXTzpqKXxY32dPmkxrw7aP+Bxi8NsDmWj3e/KI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026年07月13日 14:27, Harry Yoo 写道:
>
> On 7/13/26 3:14 PM, Hongling Zeng wrote:
>> 在 2026年07月13日 14:07, Harry Yoo 写道:
>>> On 7/13/26 2:58 PM, Hongling Zeng wrote:
>>>> When kobject_init_and_add() fails in sysfs_slab_add(), the kobject
>>>> is not properly cleaned up, causing a memory leak.
>>>>
>>>> According to the kobject API documentation, when kobject_init_and_add()
>>>> returns an error, the caller must call kobject_put() to properly clean
>>>> up the memory associated with the object. The current code only frees
>>>> the 'name' string but forgets to release the kobject reference.
>>> This was intentional, please see commit 2420baa8e046 ("mm/slab: Allow
>>> cache creation to proceed even if sysfs registration fails").
>>    Thank you for the clarification. I see now that this was an intentional
>>    design choice to allow cache creation to proceed even when sysfs
>>    registration fails.
>>
>>>> Fix this by calling kobject_put() before jumping to the error label.
>>>>
>>>> Fixes: 54b6a731025f ("slub: fix leak of 'name' in sysfs_slab_add")
>>>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>>>> ---
>>> Uh, there was a similar attempt recently...
>>>
>>> https://lore.kernel.org/linux-mm/
>>> gimwkjjpvwu2sg5625b3eeatw2vhv7rs6enm3vepdduhcefbf5@xen5iec7sn3z
>>>
>>> Sounds like we need a comment saying it is intentional!
>>>
>>   Good idea. Would a patch adding a comment like this be useful?
>>
>>            err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s",
>> name);
>>    +       /*
>>    +        * Note: Intentionally not calling kobject_put() on error.
>>    +        *
>>    +        * The kobject release callback (slab_kmem_cache_release) would
>>    +        * free the entire kmem_cache structure. However, sysfs
>>    +        * registration failures are treated as non-fatal - the cache
>>    +        * continues to be used. See commit 2420baa8e046 ("mm/slab: Allow
>>    +        * cache creation to proceed even if sysfs registration fails").
>>    +        */
> Could we make it bit more concise please?
>
> Something like
>
> "Intentionally skip kobject_put(). See commit 2420baa8e046 ("mm/slab:
> Allow cache creation to proceed even if sysfs registration fails")"
>
>>            if (err)
>>                    goto out;
>>   
   Thank you for the suggestion. Here's the simplified version:

   [PATCH v1] mm/slub: add comment explaining intentional kobject handling
   in sysfs_slab_add

   Please review.

   Thanks!

   Best regards,
   Hongling Zeng





