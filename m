Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C911CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 00:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0136B008A; Mon, 11 May 2026 20:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570DD6B008C; Mon, 11 May 2026 20:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486966B0092; Mon, 11 May 2026 20:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 374C66B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:55:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C231FA02F2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:55:13 +0000 (UTC)
X-FDA: 84756948906.05.A5B96D9
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6CCE11C0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:55:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZW8KviKf;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778547312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/KLe3Yts3q+6w5dMQr/xNmnwmQSv/P07HQ1TqjvMRk=;
	b=sqWtb2asyCiZdStY4suXChKESNyXILSvUMB/xeA2pU/RYcolBDftEOlIyMUxX6PK7FfmPP
	seGTpkEXxxt0uaYOrPIm50axCXzo4Eydyc7qxbPvAM7viRgCyKDI447z4CTQb8bz/iGi8t
	ldlXMcDgb9AQaB1PU62Dt8QjF5A/YNM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZW8KviKf;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778547312; a=rsa-sha256;
	cv=none;
	b=kTBIpBYNBoTStmIU9drgjsvdwfBlU2LrHCjh0W6C1BZ88/KXvvIW/CiyhfTfh+r//xbEI2
	JkrGEy0AYWSgFl2Jpulk4CAG58vytcntLcxLv7dH3BaoWiV/STeZCcRkwDIxirwP2QWWln
	Ac0bxsnx+lk5C/Dv/GBWbXcyHMjJqS4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778547307; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=N/KLe3Yts3q+6w5dMQr/xNmnwmQSv/P07HQ1TqjvMRk=;
	b=ZW8KviKfjOnyITR+EQcp9LZpjvSkVJf9PlzxM0Z7FmQ8PtBb85D3+UA/XMEud1pmtRvF9MCnoeop8/LZxcKJfr6GyptZpV4ZAn6vy0koWA0n9Ub9VJXyQK3Aeeq9wuwMCgszlsocChOu7MoLiok0Vg/0KGzkxMVUFW1CXH4wEGA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X2oYab._1778547305;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2oYab._1778547305 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 08:55:05 +0800
Message-ID: <b1302558-e5a0-4963-b9ed-533d35dea802@linux.alibaba.com>
Date: Tue, 12 May 2026 08:55:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not
 supported"
To: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: hughd@google.com, willy@infradead.org, ziy@nvidia.com, david@kernel.org,
 lance.yang@linux.dev, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
 <afnKLEIaUd5A22ls@lucifer> <afnKpTo4cwh9LtPU@lucifer>
 <b496c241-006f-41ea-a398-0e0b7c7e8472@linux.alibaba.com>
 <agHFZkeeCx5OEAu-@lucifer>
 <20260511150158.921c0ac72b31a6fa0a125ab8@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260511150158.921c0ac72b31a6fa0a125ab8@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CCE11C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: prp7z43dwej35ojtigozuzmujmfq8nz4
X-HE-Tag: 1778547310-598116
X-HE-Meta: U2FsdGVkX1+kYbLSvaRbqspAFxf2FvHWjWjCjoHW+gDlRnDhCR6rtq0CD1O4ScKzlBlbG04lFtnZDUy6GvMcXfRIfFcf/M1hum5NFVDaURWodtiw5jqnDJ4GR+MJSc4AnCHyo4/KvhQvThZjQHWd6Z3WbRFH0NM9U9CzAQcw1B6hVJcNaoMpW/0mapD7bkhlORGohQ6PSj2cRs7nQNJBSRaJj/2Ou5as00uSihQ5m15EnYEoxzaghjPD9sy5CP5lJSq5gLHIfjjamF/4P0yxWlGatN4Yl3rlADlhSIrLdgXCNEbQ76s6yRpqAfj562GVP1yHN4wo6N+8XP71zk6NdnVfstRutlNbn/iW9eXqkrR/3a5FWu9JeGBp2r8Yh7vs0TBnW9CZf/O++lOwYpnwZfr19rB7xlGenmNLtFwHxNlQ/AibDHvKXFRzRVkGbpvcd09wkzHRBdsWgWFPDHIR9+FTIv5vgElFRZcRcraZiRtj/GEMMG8wKaMAQgtkhCTC8rRiGsmTfJWKQeTkTVgPaVxW4i4+PI6fdAvMeAuUYg0/29085OvnWc4MTCYNubq69OktKiMZZbBOrrTc0o7kEth5uGtJk7Ne2MUHEWithKaTRiK6uQSz9Grkxv9Jp04kNMkewzcH1PmVzvQqD+M5fSO3ywKToq5NTPe9cKU7PnxSc75zmP1C1UOxl0vlenKTyjqDia90vodch9sS/jJ2DzRfE0CRJd0cOwwtt5OcaUZZLigWDG7z7faz8nCMXHDqEMmihStch2q2u/XaXWc7GEoSZ27pxaJNeTyv66Tc1UpJaMJJod2b7ajcTmx+U0S6MOCIARiUqvo70fIHuyXWhHZnpsPw3+glAz6YEh7+oJf/1V324LxcJseFejYUaKkX3RTUYGFQ8mYopbs6r3afrHoSS/CdEttLk84XHqWYHA5lqs62QZ2a/NOVwTSCRu3Fb7MP+dzCYJvx8eufojs
 4JLwzHYH
 uF53cbnexbBl6vJlIyuUYj/XJPlYN4jmzTO37TH9EIBP2bG8il7dw47BkrSe6IAT6Qc8437rVF+lNDCulgDUXG5iRTX++L/XR66/u7qtj1uj4ty+usG1Z2XbSscAm9N2rBgxBkqq16m/B2oRWjsWdVzYj2Ythv5ltMLhyyzea5cBycnXYCfOVZR+P0qaVMckfF6IlY434Fx4eanHwoYM+fASVD5Xyuad/HMT+JyePvIWDPofagCGaARsPJydeD/imJIO3nvkOgu6tbZvlIdVrqmJKNnT8T3pgsJyBJxQZp1TNRSq5ZuMYGVNlu9lgSitmEzRcnd8ydIF0IPhPrecA3OajKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/26 6:01 AM, Andrew Morton wrote:
> On Mon, 11 May 2026 13:03:04 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> 
>> On Wed, May 06, 2026 at 04:58:20PM +0800, Baolin Wang wrote:
>>>
>>>
>>> On 5/5/26 6:47 PM, Lorenzo Stoakes wrote:
>>>> On Tue, May 05, 2026 at 11:46:11AM +0100, Lorenzo Stoakes wrote:
>>>>> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
>>>>>
>>>>> As David asked, should we have a Fixes tag? What about cc: stable?
>>>
>>> Sure. But this fix tag depends on the commit 665575cff098b, so the fixes tag
>>> should be:
>>>
>>> Fixes: 5a90c155defa ("tmpfs: don't enable large folios if not supported")
>>> Depends-on: 665575cff098b ("filemap: move prefaulting out of hot write
>>> path").
>>
>> Oh is Depends-on a tag? Wasn't aware of it :>)
> 
> It is not.
> 
> hp2:/usr/src/25> grep -ri Depends-on Documentation | wc -l
> 0
> 
> But it is!
> 
> hp2:/usr/src/25> grep -ri Depends-on ../gitlog | wc -l
> 156
> 
> I actually removed it because a) various tools whine at me and b) we
> didn't cc:stable anyway.

Okay, I remember I've seen that tag :)

> 
> Please let's not add new metadata without having told others what that
> metadata means?
> 
> "Fixes:" should be sufficient.  I interpret Fixes: as "apply this to any
> kernel which contains <that>".  Is more needed?

My concern is that if someone backports this patch to an older kernel 
version without also backporting commit 665575cff098b, it would cause a 
performance regression.

Is there a good way to mark this kind of dependency on another patch? 
But I've already described this potential dependency in the commit 
message, so I'm fine with just adding the "Fixes:" tag.

