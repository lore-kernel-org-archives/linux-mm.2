Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32BCD35177
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577466B0089; Wed,  1 Apr 2026 07:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5282D6B008A; Wed,  1 Apr 2026 07:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417706B0092; Wed,  1 Apr 2026 07:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0C16B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:54:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF82213B6B1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:54:26 +0000 (UTC)
X-FDA: 84609829332.27.542B8A3
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0909320008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:54:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FA3xorRu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775044465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Od0KGdAt79Hlpl+RQqHGd+sZXqx3QxXuL8MZO01WLhE=;
	b=FgTpexO1G+cazSkrnLhPfpXAcLL/Xpe2O0CvwS1oc9PDKW+C47jI9n/auK8fmCCy7dyo7R
	FTafryRAGlM5LXyE7GxRb+14wm8579q4cGg6fkCN+e5JosJU/qiyi9kiQugQco3whuCCwe
	epQBbSjB/usfZcR4SM11/LcmwsXiRik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775044465; a=rsa-sha256;
	cv=none;
	b=D0eHZZk74Ouxc4/Mp/1CXIRvT3rbzsny6LOhzYFfi5aoW7L60hxZGSCPJglVLh9UX5VnxV
	CFRiLFnJrUvUl8dV3t39c8wrUETy+bIdRL6fpUUdLDrwl0YgZCwMl/jjODHCyKv7fJdN6g
	zRMBxNVdlp48lmh2CqjP8A4cnHtsOLs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FA3xorRu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <87a48c70-b6fd-48f6-9ec0-7eb2dc6cc3d1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775044463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Od0KGdAt79Hlpl+RQqHGd+sZXqx3QxXuL8MZO01WLhE=;
	b=FA3xorRuCN1CkX5XsCTYNerU5KwqOVywN0vQvF43TelYLJ3CQvxT0s//W7+9bD9Tk6yhib
	jJxP3b7CR5X6ngcP1kG4DVpYnqzurWCl+gOykGo72rU+ahThqH07aH8XlkzXU9wXKon0BI
	auoqb25HQUO00BzqhhzT+QklpElPf9U=
Date: Wed, 1 Apr 2026 19:54:14 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kartikey406@gmail.com, usama.arif@linux.dev, Liam.Howlett@oracle.com,
 ziy@nvidia.com, syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com
References: <38a347dc-8a1c-4d04-926d-7a6318e93ca2@kernel.org>
 <20260401113434.29369-1-lance.yang@linux.dev>
 <cc8a2d06-c774-48d4-af8a-905126dbd588@kernel.org>
 <7176f8a2-8830-4fe9-b00e-fae67e2ac81d@linux.dev>
 <70576b00-6210-4eec-aeb8-69a74cca27d1@kernel.org>
 <c5d01704-9035-482a-b562-ef5a0c163d4d@linux.dev>
In-Reply-To: <c5d01704-9035-482a-b562-ef5a0c163d4d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0909320008
X-Stat-Signature: cwroyipjt5hgwwn1fmgebjzcptmqfi15
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775044464-659362
X-HE-Meta: U2FsdGVkX1/XutmtP6elpRCfKdlEUgaVfLbhKJEyNJD0CaEs4CS/nWB4CjtULaSh9uXYCfcoMDNNiDSRmg5ydQRUysnQhOlRIWkRI0CSB4fupWONSX7lZYdd95PjPLchCqQo3agrLZo0I56Y2vBuQZ76pnavV6p+PfNZzVVkmBC2SvazNrqGq24sXuv9v5pEMSftjjOmsMCwZiPsFC13+UmlHwx3deRV/gRz57/uu09rDY9GEohKGDjIJ9v4m0PzNiOI0pDgHAnNUw0lm8GjiVtUTjgmfT1m4eb9CTHoLeKn0PpNtMtRgmiU/Nxp2L9u6oSPo6qQJJ+QQaptQ4MArm+Gl8LhIxBLNE9KpF0n+I3GJwOUc0BuCzktu+ZzpwipKNjqfc2uqRgAVxWZSRXzqH6sxWXNDUoG9J0wnEUfT5fGP8JZaGY90AkFWe8nqClvpJtttdbEn6LqyvpnP+42X7gdNbE2+K5CBvl1xzQnN0IsDtInEyh6cqj6STMq9/irtAqfXUdxEyuPzId/UaGNgxP1WXWhD3y+nOC0p+zBTGvvTVdckKPAXcbs5urUIfj17flZ4J7kZtYcG/TIKbDuDIG5fBl5AdUSI2cHL28SC/c7jcWjdXIW3x82DdtkbIFmGMLiktLbG2MUnWotBfuPsXwobPvaqWIYQSZJ6WQ7DjVJVom1aNdwyp5NefWy839kuzUjReou5CK6Bv4sANLoPjZaDoaaSqjjpKaK97EsFfbfG44cBnqSUroPfCGIo+Vl/GJNlqQnf8DX/lM/soRjbuj9KhhqLR0uD07HddvTjTumey7ZUXMxf3rrDvAAjdl0vC1jynAEarVCDmuR84SojcGxmpRd4HI8WRRWgOcq2bDKxqTUq83+0IX1f3XjzwlO50ienvTDAXvbCAOkGAnHQNgT2C9EL5liQ0z/FIWiYyZskypQac4aLtO15pT4goJGRsr2/iT9YEt+6l6aLNt
 n/ryQQGo
 9u10zU6/DuFUuDZywldFy7HphpM61QT5g3UrZ9otHhnW2T9nWsCKvT7aUSnJh6oSM6tFrP+46xt2hGIXy9I4sH9Mvrzf/2xnycOPg83Sd/dH4D8AU9QFRTiJ103v+i9huVZbBpT1AdwnnhuLBzL1dQ/2wyUenrLZkNCdtLQUeWe2Os7z0DIErQT4BMjiKJPFyqulcNDaye5P5cXI/ep4h15p7bn5Op/fqcb4HT3iUU/KU2ZCPI9YLuos7rRvY3l4WOgvo3ud0wfWBUHOhavrPsiQdBrkX4X98jPYqEoCp0Pj8P2/VNjFQB4fEnBWay7l/IJd/TrsQTIgf/daDgYzF6Y0pVPJXlFaX+RYN/hNBMPN9wLPa98jth8D4KO4KblKxtwggSdPmB3aQssOtAsVq7T5oqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/1 19:51, Lance Yang wrote:
> 
> 
> On 2026/4/1 19:44, David Hildenbrand (Arm) wrote:
>> On 4/1/26 13:41, Lance Yang wrote:
>>>
>>>
>>> On 2026/4/1 19:38, David Hildenbrand (Arm) wrote:
>>>> On 4/1/26 13:34, Lance Yang wrote:
>>>>>
>>>>>
>>>>> ACK.
>>>>>
>>>>>
>>>>> certainly, will do! But commit[1] ("mm: migrate: requeue destination
>>>>> folio on deferred split queue") is only in mm-stable now, not yet
>>>>> upstream/stable ...
>>>>
>>>> It's tricky. The original commit will be backported to stable kernels,
>>>> so we want also the fix to be backported to the same stable kernels.
>>>>
>>>> The commit id in mm-stable is "stable" now.
>>>
>>> Emm... Not a big deal, I guess. We can always submit a stable backport
>>> once that fix gets merged into stable :D
>>
>> What's the problem with tagging the commit right way as Cc: stable?
> 
> Sure, that makes sense. I'll add "Cc: stable" to the fix as well, so
> it can follow 8a8ca142a488 into stable ;)

8a8ca142a488 refers to commit "mm: migrate: requeue destination folio on 
deferred split queue".

