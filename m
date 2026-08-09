Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43C7C5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 14:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B456B0088; Sun,  9 Aug 2026 10:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602936B008A; Sun,  9 Aug 2026 10:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5187F6B008C; Sun,  9 Aug 2026 10:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31BC76B0088
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 10:26:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB2A614054C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:26:29 +0000 (UTC)
X-FDA: 85081956498.14.0A951A0
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4AC13C0002
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:26:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=S6DufPc2;
	spf=pass (imf22.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786285585;
	b=DYmt+qsmHzk804xcK+RfFYtigLNrfcOsAB64kz/WmPJreElI4vgRM1KwcllPjhKkXk013U
	4R3EuIezsvaU67hMyiwM4Z+AJMGffLADLFFEv/kmP6NsPZt48YwUw1BolciH6P+dEkRxoJ
	47bE5fWJbKIeT4DHKF7TqdgEG74aUWI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=S6DufPc2;
	spf=pass (imf22.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786285585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmfHFZFlRMH+AE36QnnPJkTyHKY6El3hxsPbGLP+Ls0=;
	b=QqsGARYMzEbHPbCuMlPSaHD6EEg4+t8HSRlOFR73L8XftKaX1duQ8wQd3+90uI+TuaowFU
	KkTkiRWueLLZjc49rQGCaAmPY0QoMgJkcQVjn6zI7F37bfemdRwsqgzf8RtbSDgetD2Vc8
	WqBDnPog354zIykugLG8kZnF9cwGuXM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=NmfHFZFlRMH+AE36QnnPJkTyHKY6El3hxsPbGLP+Ls0=;
	b=S6DufPc2O/YT32LMuSA/AdqWCyNQhAcJy23Bz2nopamNml4tVXCG++BHKSbkrB
	aGLyCWmzlVwaRavJjsLKVjh5RiMDqtjgOuE3pZC3ild5KoqysFbEnfYbIYX20b9j
	TZEzo0Y4XQ7fHG3IgqLdiCmAtvPc+23/ynCSx4FOX2zvQ=
Received: from [198.18.0.1] (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXFzX0jXhqGeCwLQ--.53195S2;
	Sun, 09 Aug 2026 22:26:00 +0800 (CST)
Message-ID: <d12a05ac-037b-470a-a91e-722d15ed712f@163.com>
Date: Sun, 9 Aug 2026 22:25:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/mm_init: compute hash mask with unsigned
 arithmetic
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
References: <20260809123119.3811851-1-xialonglong2025@163.com>
 <aniIuZa53OBqCMbB@kernel.org>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <aniIuZa53OBqCMbB@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXFzX0jXhqGeCwLQ--.53195S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFy5Cr15KFW5KrW7AryUAwb_yoW8XrWxpF
	W8t3W8KayDZFsFk3sFvFZxXrn8JaySyrsxGw4jyF4UZrn8CFn0qF4kK398ua9xtr48Wa1a
	9F4kXa4kXa1YkaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UczV8UUUUU=
X-Originating-IP: [240e:46c:1000:421:146d:94c1:77b6:b055]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3BhaU2p4jfhvtwAA3y
X-Rspamd-Queue-Id: 4AC13C0002
X-Stat-Signature: gnqh9k5huuwxmx6pcbb6b58wibd38x99
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786285583-196838
X-HE-Meta: U2FsdGVkX1/BOpIhzwa81T0sSwNQ3D01m1omQjQWaYSRpZE9NKE18aifqa7p5bxSz0LudmMqDBnoyGM7IGxNxKzkLkcT1XUJAqT4EIkBszzzOiNyOkb+D7lPNvn6gGrsISlXT6b3bT1vxCaCud6R4SjkB96oQs69UejZxry6rkF3AhGfRywuvEMcy7S0m30zifeqVlfm2gDDZmkScRue4tjlwrnmhCZLuHXgszlw02LGN88M58Ir3rGvZB8b7HrEHd/7fos7thmMjDDjUk5rokkFVfq/uMRiViRFDKRznIvgc9JJZ3RUm9ej2fqSpNxcnqv7NdaYtZ5L31WY3wENLZwibzjllPc0n51WzAZ2+nJuQuylzpc0ds/2ZoutoPjrvfzREUgOtPHZPx6niE9EBpkW0vjAr3CCegdXGSv+fUiyjHxmCwqS7fvgICC2MjVrgPnE7fxx2qT7ph4/pAr3e74Ot8jgbZZHrhnFbEHWJQRmz07hwJ2NimTybbS28FL6DE+wTgYnGlA1mFhCd/sy8Slm2wJSoJQDGdf2hCK5uaGuOowU493Gc/KxtmHhkhWYDaTlWSXM1RB/087zx0rC6nlyetApDOHc3CHc3x0JqgAevZUdNKfg5jo8Kwx9DLnKCPN0dQf+2tUb9geILyl/0ZLV1j/XbcYW5iiA+4XMoOUnFiJt1nOdZnBwk2Vy+M6WIz1lBt8yKfKptAWDvEt2wWAfDX7VfJKdEbbnNG8VQ0zSAwVvpcAql4S9Jd5e8z0PHY89/3jgpmJp7at/DoMYmtAWW7DzzHgmdWJPrMmmUbOgPLaajdJBuR0O3wNT8dFCN0FMM81+CRyNa0sy+dPf6fqDbcKA//s3Xo5noWMZMeFmbspKkIbP9ZwSAme+4ze5kyaE8YCoSDZSM6JxkxlgMDfyX9xtOUzxOMNuTVYyA1RHcyauSFOaChJEeiD9CFTVoUEIq2aSiHy1Th2dPBu
 Tl32VeRr
 Tgb56HueXfGEILmltmXhPhg/aZNHWsNExoaa6j3w4e2opVATv6fC5l+ATO7hqixlWMhNsB59wRVB3Gb/VvMdzj5BQdmkJC0H8AfTcOVAeeEz/RfOiLf++ilTyrpajjrlPM/6Fasp+A7Lc9iRqSL0kL4ywt+x4Wxk4kTqbvyX5sbuX762Ul+Xu5OzJj7vqg6FmWLOPxbKqG0oHPaoYldAoDcYyx4HGZZfDchMoldSGZWY3JoehLrET/16lH1uS1NrEo9m3UhM2G5D2Vu7B0ERXBobTVdSXjL1V4y+enzn0nGLhAg3qcrkc9J4VlHeP4BXce9FmDEhR1MGx+FAhjdPdGJWqHbAgNchQJnFlxBmPzMxJAdGk3a6LV7dac1LvA2jSwVq35g5fV7r3+4s4gx6WfXfSjd/XR6PDk6Qz+HiZo8SJDeFGnor61mmivg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/9 22:03, Mike Rapoport 写道:
> Hi,
>
> On Sun, Aug 09, 2026 at 08:31:19PM +0800, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> alloc_large_system_hash() allows up to 2^31 buckets, so log2qty can
>> reach 31. At that limit, the current expression relies on signed
>> integer wrapping to produce the unsigned hash mask.
>>
>> Use an unsigned literal so the mask is computed with unsigned
>> arithmetic. Supported compiler settings already produce the same
>> result, so this is a source-level cleanup with no functional change.
> If complier already takes care of this then why do we want this patch?
>   
Fair point. Since supported compilers already produce the intended 
result and this patch has no functional impact, the benefit is only 
making the unsigned arithmetic explicit. So please disregard this patch.

Thanks for the review.

Best regards,
Longlong

>> Assisted-by: Codex:gpt-5.6-sol
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> ---
>>   mm/mm_init.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 498d62c4ece3..1883fe923ffb 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2469,7 +2469,7 @@ void *__init alloc_large_system_hash(const char *tablename,
>>   	if (_hash_shift)
>>   		*_hash_shift = log2qty;
>>   	if (_hash_mask)
>> -		*_hash_mask = (1 << log2qty) - 1;
>> +		*_hash_mask = (1U << log2qty) - 1;
>>   
>>   	return table;
>>   }
>> -- 
>> 2.43.0
>>


