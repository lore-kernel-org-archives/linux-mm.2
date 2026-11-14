Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3CF606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 05:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF70F6B05B1; Sat, 14 Nov 2026 00:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3C96B05B2; Sat, 14 Nov 2026 00:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4456B05B3; Sat, 14 Nov 2026 00:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A54B36B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:48:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 833B5160369
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:48:28 +0000 (UTC)
X-FDA: 85432644696.04.09C39BF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7CAF91C0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:48:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794635305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1JziK7ad7JakdJUGDOUwA3/eXHhGnc7ibWdPj1NA5o=;
	b=xaUib+JBjrSQJKiliyD6kZDMlh070bhh6ZvlZ/6fXAYhlTHUyevRHhOTNzoBsjZoaA9xNK
	hZ9tT5xib/dTw0HfVs4Gp3g9IPj8F0cIwCJ84Z+mLQena4fXoh6ivMsu3ITZX77RilqnK9
	SWoZQEbdeK4DInWxYgiG3Aw8W1b6hjs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794635305;
	b=POkPmCUjIlbGvbGjDHUYE9KQtm91jRx6PVinw/nv5jbEjWF/ELrKEyHgHPeDyDtMKhf1/m
	bpwoYGYMSY3CaPKnH88MVOODgvNywyfMFSkS3ybMj/3BooOdiamF7zjPwsD0Txhm9yrI5H
	kXu8yzzq8DJJUcwkReqCFGAad6vLc5E=
X-UUID: f8d7ab08dfee11f19a56ed5b684f684d-20261114
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:099a3f3b-6a9c-44de-9035-2448c1010fe7,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:099a3f3b-6a9c-44de-9035-2448c1010fe7,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:33db5c30de269d32af48f6cebb00f1d9,BulkI
	D:261113175444ZD0JE9K2,BulkQuantity:4,SF:17|19|64|66|78|80|81|82|83|102|12
	7|136|153|841|865|898,TC:nil,Content:0|15|50|99|100|101|118,EDM:-3|-100,IP
	:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LE
	S:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f8d7ab08dfee11f19a56ed5b684f684d-20261114
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 196277102; Sat, 14 Nov 2026 13:48:09 +0800
Message-ID: <223604f3-2938-49cf-b5a1-7403444e2f3e@kylinos.cn>
Date: Sat, 14 Nov 2026 13:48:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] Docs/mm/damon/design: update for
 DAMON_FILTER_TYPE_ACTIVE
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261113144314.97829-1-sj@kernel.org>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20261113144314.97829-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CAF91C0002
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j8k3t6xnxtygkueq8x9aogffc3fbyyey
X-HE-Tag: 1794635304-307610
X-HE-Meta: U2FsdGVkX1+yDXQ4fEHU8Z1s138orNACZRZnlo+oK5UovpJzw5yNQOU1Vki5HuQRLJy+2A1DJIOC8FFdawaPL/Kqi5zskxe/cskvW+t38YBfcAa5zHCq1VN95xQIuByganxEhENs8IGLNvjWqhBKHq1Uv4zC6r08fg7sLGZ8bWYLYhe7GF7jax4AQUp2THFnchAvIM10GXpXd84n0wjmdbfkN9WKPPjUCnwocEH+CXSz5sM7jrW0ZdQKfkK6SLPpGH9ob+m3Nz04fX7CJpGuGB1VNeMZMzCWDIa08PwMeI0ebQTosMwpno5ln0eP8lrCqbCa5//85Q4TTH+8SMxGRfdf3FLFVUuSuI3c6xc+s93oKhuU7iNTbmrAc8937NgobJGoH7LbbDiSqNmBMfLC5NVQ57c1247GMgX2y7j7ARdMKsZTlGxvmNgisAww5dcUrK+eQkb8JGxUd4oTZKBCghG+TTOYzcXdGv4ISJFNfVBnPkoEThSzXdizOzO+tr/Ieh/OSLkxID+WM4UPrk/nLccYThf9EfwsFwhislV0IyM7qTbNOyIM8ctRxleIrbJyAim6cbqJ4P18Bv253p/lUKgVd1BgsC857hL2mnPl6GkBJFjbKrs4Ghog8qasZblFOSMgDXXykd1XequAPj9YOymyf+plF3mzmVa+tMyBp5e+cRKRMqG115vSarMErBPT65t1A3K1cn4NZwzfSYqDYuBxrL/ArPnvkA+NedWINR9Nx3KQrVakJKobThnKBQAOxka4tdwSq5elc+vq4DpyJRDkSV8YOFeCXFSkJMwMavtTdabe/efvoQ5uRnK1NUKmVzZtTmb7hGXk8HDNYE/No4WHq8GQ59AwiTAYV+xjwnPszzZBwTnTI2PJIiWCwVAHZ9U+7u/fOPOOjzUqFEyW9SbXk2i+BiZNA49OJiB6Mlp8T9N5mskT7pGllyPhCC0I/aebzfX0wo9jvZqb4qR
 TQQaxepM
 g6ylVQdgMh7pRaLe+cf+6d5YYmgZNrXIYyuzQob7r6jf3bVZpRCGnIvE/9/ItJEPPjbC4W7gvTUE8MStntULk0VbfWlZHxky7MDjR3beLlDbuwOLaTkUa9yqt5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/13 22:43, SJ Park wrote:
> On Fri, 13 Nov 2026 17:54:37 +0800 Enze Li <lienze@kylinos.cn> wrote:
> 
>> Hi SJ,
>>
>> On 11/13/26 1:17 PM, SJ Park wrote:
>>> Update DAMON design document for the newly added LRU-activeness DAMON
>>> filter type.
>>>
>>> Signed-off-by: SJ Park <sj@kernel.org>
>>> ---
>>>  Documentation/mm/damon/design.rst | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
>>> index 8440c4954090e..b676be6971589 100644
>>> --- a/Documentation/mm/damon/design.rst
>>> +++ b/Documentation/mm/damon/design.rst
>>> @@ -302,6 +302,7 @@ filter types.  Currently below filter types are supported.
>>>  - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
>>>  - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
>>>    of a given size range.
>>> +- ``active``: Same to that for DAMOS filters.
>>
>> This reads a bit awkward to me.  How about:
>>
>>   "Same as that for DAMOS filters."
>>
>> The ``anon`` and ``memcg`` entries above use the same wording, so
>> it would be nice to fix those at the same time.
>>
>> WDYT?
> 
> Makes sense to me, thank you for sharing the finding, Enze!  I also find more
> "same to" usages in the doc.  Would you like to send a patch for fixing those
> at once?

Sure, I'd be happy to.  I'll send a follow-up patch fixing all six
"same to" usages in design.rst, on top of mm-new.

Best regards,
Enze

<...>


