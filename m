Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC82C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6467E6B00B3; Thu, 30 Jul 2026 10:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E296B00B4; Thu, 30 Jul 2026 10:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534256B00B5; Thu, 30 Jul 2026 10:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 320A56B00B3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:15:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A86A212018A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:15:32 +0000 (UTC)
X-FDA: 85045640904.18.B3577D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E51674000A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:15:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eN1lj5qO;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTgepQduWlkZ5ugvc4fI7nenGhhfC2SUKFbYbj1yI00=;
	b=zgxvkpPnve5b1L/jUCMej4pXspmMyXlPqaosysg8rY+0kFnlok0h1ju2ePjleSysxxSPeG
	8TNRHky7YbAEYvDTqXYbricA55CxFpCSuD+ll5TmSEp7djO9slntJXcQyrKzmkTkTBXIkg
	r/X5U/VknkuHLzOwPl41POa7t2KiwLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420930;
	b=23LH8fCDwOcgWeWcj403+xgVfOzUokC5/boqmEb1TmXhvdE2dW3L4We1woIZLgUgO0EPCE
	9JAX/GE6LI0+Yk19uJ1bjJSYDKmxdIGKH/lQ0UaQ2BJyPItU+ORzx58NFjeCtPtPETAiDC
	LTaQHvGbKb1JgKMhAu6nyodMIk7Jh+c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eN1lj5qO;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AD62600B0;
	Thu, 30 Jul 2026 14:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3661F000E9;
	Thu, 30 Jul 2026 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785420930;
	bh=WTgepQduWlkZ5ugvc4fI7nenGhhfC2SUKFbYbj1yI00=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eN1lj5qOb5fu9EekeSPmrWTJxEQfkM8wW3zTNJHj/Vv6cKTUnD5S1jnm78DMubUyK
	 s/ZcljVOmAQzh/i1NiYTQbwrmjxhyhCTWKTciw0i/lKBO421kKUa8z4C4OC4JitIdv
	 +qrL5lwnVFpp1jwQI9e3WM/rPG456maWGLFt4DcQP1wpihsBchKaw93MAz3YfkXTRV
	 z0w1J2HP7Rl5Pl0BxMG/50TKxMMFXbFVqkD1bQsux9y1PP99PjEefKStxS9NpcmmW7
	 xq5yv2KeN8lLQkfwDBpW5X59DigYTfawEerDvRtxWGAIxTRnF+xccwrrEs4EyjwwOF
	 aq006WL96a4eA==
Message-ID: <73d28cff-77f5-4cd6-888e-5dce5ebae459@kernel.org>
Date: Thu, 30 Jul 2026 16:15:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
 <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E51674000A
X-Stat-Signature: rm485rpqaobyewunzskrjf6d6hb13y6x
X-Rspam-User: 
X-HE-Tag: 1785420930-338379
X-HE-Meta: U2FsdGVkX19i9khdcvUe33Otztl1FQWmP7sz2lxKIwJLEupPue489NFUuM6XgDe2ob933DaXUqbyG3HDoP4XsN6YC5AbjPKHyOfhM/yB0pbgy3M3zjXI+V1kSs/mv2ktoi9NO4TtkQFRFCoT1tZUnqzys6OtPwSwxcDAUZOwSUJQesyLhDDhDvIhyGZU23esJlF3K4ptGH9IHvsTUIsdQNeEoxUpcFd+kvNkeFC+aPljeTfp3emCAazKno/PivnOPdR6ZxIY1NyqwKeJfyjeAD/W0kXmwk+/P+vaKf6q7Vq1+TjHqHu3yGCu5GVV9xTLjCa+i+TSutMi3fKLjqi+PikT+TbSQTw+vMHAHY8+lLB1qnTVws8ptxfxIOZucmDO3vZTagaF6t/H3rx1Fb0fkl/megEXUoTs3NxOvJnrs0U8OfS4aoeIvZHCV2dIggrYZ9ZcbPb/TUq7+EuqH24Dv745GxtqxCfcRQQvB7ZRexpoWZNnpRL/0LYLxOzCpxYLROLDbtHeFGPcrHGBsPrqmZ3veqeXmp7qUOipdDWqngwc7Dvrvg8iYos4UV9TWFpXfB2xGrK/p3VsP/I0y18BQFi2bIp8JcpI5Y1YcyNh5dBgzN4TIEPvDCqNVTzkjHK/1pgQ+3vLoXc4RmpvSvq+kYI8d7fWPFz3ONFFj00jw4T/Ern4O/xCTu5I0z2RJRk+bEAgBvaqvmPDqoWCd3LcyHnQccdrbH3ov36huHctfQ3SOJ2dhTZ8wAb0Odj1UPjRWlVLUdoFI3rVwHCPhxvD1mwdpua6Ls8JxTWrcqiayJ16AQkn12QukZoQhXmhpcFpWUPB0OgCSVBDc/dJj+SNiHfYCvEoZFqSuJUBbCwBEK5dvVPSNl+j/Z4d6xfPuDOR1tQrSAYhXw3Tqs4ScmPKNe7rNKksPBZiA/+2FboFj7gYItWWNKp84ySNtUHs0ZF6GxIs7nMN82+weCj8iKE
 CVh1ecMV
 zv2vJXCAAKzDsAeiZY4LFtykrsBNU8x0L50C6P5j8UkmOUWzUQEZGeNkDe/jNXDlDxJic/S7j7VCSVn7GHC2cXC7ZabOuGnc22Fe5DhIQ/t37hWoWmn6PeyAdCPWJTJMEzu/BEXmpDYhSroTyDoeZfg095dFjeApJdl4mR8hfWRPmprOpernA4Gh5WEJPi9s2myeuyKAL8J3yfIOxixGbZE2xqXA/u+fbFH5SCdIDv2kC9uYiXXw0HqsgXm4CHqGexU7nwUI6bT5B9QdkjoaSXZ8tEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 07:27, Harry Yoo wrote:
> 
> 
> On 7/25/26 10:28 PM, Alexey Dobriyan wrote:
>> Sysfs "ctor" file prints offset/length of the cache's ctor function
>> 
>> 	$ sudo cat /sys/kernel/slab/bdev_cache/ctor
>> 	init_once+0x0/0x10
>> 
>> This is not useful:
>> 
>> Offset will always be 0 because ctor is a function.
>> 
>> I'm not sure what ctor function size is doing here, it should be in
>> /proc/kallsyms
>> 
>> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>> ---
> 
> I'm not convinced that changing this (without strong justification)
> after exposing it to sysfs for 10+ years is worth the trouble.

Agreed. It's a pity this was exported in the first place. I can't see a
benefit for anyone knowing what the function is called. Should have been at
most a flag whether there's ctor or not.
But possibly a justification is not to leak the function size, which might
be theoretically (although unlikely) a hint to some attack.
Well at least if somebody complains about getting broken, it's trivial to
revert and we can hear about their usecase.
In-tree tools (slabinfo etc) were checked to work properly?

>>  mm/slub.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -9149,7 +9149,7 @@ static ssize_t ctor_show(struct kmem_cache *s, char *buf)
>>  {
>>  	if (!s->ctor)
>>  		return 0;
>> -	return sysfs_emit(buf, "%pS\n", s->ctor);
>> +	return sysfs_emit(buf, "%ps\n", s->ctor);
>>  }
>>  SLAB_ATTR_RO(ctor);
>>  
> 


