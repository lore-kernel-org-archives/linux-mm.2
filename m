Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B6D6CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA168E0010; Mon,  1 Sep 2025 05:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1C38E0002; Mon,  1 Sep 2025 05:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0598E0010; Mon,  1 Sep 2025 05:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 285ED8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:14:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A37555B428
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:14:55 +0000 (UTC)
X-FDA: 83840121750.23.29F6199
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 380568000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:14:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PEdCmu2e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g4HKswC2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PEdCmu2e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g4HKswC2;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TP2gZxqJ/BLSOVQu0B58s8cXLU6QhiNYYtE2iVrHlk=;
	b=odEgCM9Cx1TjsQ/ki317wJQ78H3AcCDFEkIn5PDx4HsTN3869yBFf2MsCOXLWY0zb6FaZ7
	A+G0ErnouT3sE1VPOdBaXHveUw0U5SCT08jvHBHnKl46l0DUjiA9cV1lR2ao9rLwEhSEWz
	BUuTgUqCwhxMCdQV5AhXjp87OZ8FA+c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PEdCmu2e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g4HKswC2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PEdCmu2e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g4HKswC2;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718093; a=rsa-sha256;
	cv=none;
	b=pu8Hce65kC3K9kHY4+1M/UtE41UdCgVDj8QsltN5iDbLQQYK64RSuZ8zoIAqFoQxcrDuCC
	e31QeJ5gGmYlDZzl8ntxZJLNqJeQnE4Eb22sVWm9kutG3UEhbjo29Aq8oA5GldBFW+WjSG
	y5pwMwQcQ3GBMGAVveeUyeAn6Rdsw4A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 53D491F387;
	Mon,  1 Sep 2025 09:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756718091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8TP2gZxqJ/BLSOVQu0B58s8cXLU6QhiNYYtE2iVrHlk=;
	b=PEdCmu2eIQCd02VJg0tf1TCfM0oVu7adEedBpBeDtqPe36XOQjvh8MkVKtvvlKMBUgplzb
	Ss7aK9xzMO0FIXV+oqnL7vSCCms1uiFhoCGDXS6/styj+auUTBgsEovhn0AEwJN+C/xLSc
	QbBU6AacrmG8cIw8H5n4qBQVNjkrH9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756718091;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8TP2gZxqJ/BLSOVQu0B58s8cXLU6QhiNYYtE2iVrHlk=;
	b=g4HKswC25V/TUTYSRdXhDN5BW9JbBpFxEYA5NFXEMTU6wPdxfsWU5vBYeyxjrD0Cpjis7Z
	X74XP6/Nq/iWcLBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756718091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8TP2gZxqJ/BLSOVQu0B58s8cXLU6QhiNYYtE2iVrHlk=;
	b=PEdCmu2eIQCd02VJg0tf1TCfM0oVu7adEedBpBeDtqPe36XOQjvh8MkVKtvvlKMBUgplzb
	Ss7aK9xzMO0FIXV+oqnL7vSCCms1uiFhoCGDXS6/styj+auUTBgsEovhn0AEwJN+C/xLSc
	QbBU6AacrmG8cIw8H5n4qBQVNjkrH9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756718091;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8TP2gZxqJ/BLSOVQu0B58s8cXLU6QhiNYYtE2iVrHlk=;
	b=g4HKswC25V/TUTYSRdXhDN5BW9JbBpFxEYA5NFXEMTU6wPdxfsWU5vBYeyxjrD0Cpjis7Z
	X74XP6/Nq/iWcLBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15EC91378C;
	Mon,  1 Sep 2025 09:14:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 493KAwtktWhvagAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 09:14:51 +0000
Message-ID: <df993304-d4f3-484a-81da-6aff3f14764f@suse.cz>
Date: Mon, 1 Sep 2025 11:14:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: slub: avoid wake up kswapd in set_track_prepare
Content-Language: en-US
To: yangshiguang <yangshiguang1011@163.com>
Cc: David Rientjes <rientjes@google.com>, harry.yoo@oracle.com,
 akpm@linux-foundation.org, cl@gentwo.org, roman.gushchin@linux.dev,
 glittao@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 yangshiguang <yangshiguang@xiaomi.com>, stable@vger.kernel.org
References: <20250830020946.1767573-1-yangshiguang1011@163.com>
 <c8f6933e-f733-4f86-c09d-8028ad862f33@google.com>
 <7f30ddd1-c6f7-4b2b-a2b9-875844092e28@suse.cz>
 <11922bd5.7fae.1990464d9c8.Coremail.yangshiguang1011@163.com>
 <c85034fe-d48e-4433-8c65-52bfb1d5d69b@suse.cz>
 <623a8fd2.8b7b.1990481f065.Coremail.yangshiguang1011@163.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <623a8fd2.8b7b.1990481f065.Coremail.yangshiguang1011@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cgxghxj19e9z9prz45zyrt8mc14q8n87
X-Rspam-User: 
X-Rspamd-Queue-Id: 380568000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756718092-602168
X-HE-Meta: U2FsdGVkX188qHwmD+9JwaQ/jHnBOW1jv41l3IOPgyXZpibzz8s+WoxGIclxL99B1B71xPu8FfctXaLsh5BlBJmvNAVxuEQwFUmTrmVtGZt1tKQXeQZmXsjFarFLvf1jH65f76TNWO/LnhVS7MvmOCg3Yb+e6OYZfB3leP3kmh6kzJcgJMT44Tx+knsIUCn9BLNzSn0iSuouhz+Ld4q5IReOb+2+TJ8M+9Qj/kRNQX8eHVNRoFCBTbz9bn+emUWs6W4x004anbLoChO0OS/X2F0VMtOlUcLcl+fTU+9SxfqMBxfI0xLrFKVTcRnG8HbyvGVKTQiQOK5PLQLUqSwij0cceJTJ7IQ95LlBxGD7kfYogaxQqzEVerpm/QPLvQZczwrcv7zC7yyxTLTYQZxV587NWnANJ7k3PlPQJZH6T0QFDxRb11gAD+ubfZVq1HA+58Zig0IPxzCEnAiihzUbNqLL+gy/5TKfESrdNl9UeNmfoltTZKJ66Dsgcsxs5ftdDTsKSdDDiRgZRen5XgcB4YFy5zbcOYVVqf2xLzN4M9cQqR5ifHaf6+af92ZJYXpA9JtJUIi4CWq48heM9abq7I+fXa9WW3ouH/JfvV77BOcRQ+HD7bCdP3seVNoBa5ixZJtyGhtpGV1E7KhRljyJ0fqtDWA0MfhuXiENq3mfhWWfYAQDZG1RmO+Dnp5RK72DZkwmHEFw8UEv7maRlqtefYl7XYCxkJJwqsN0JRicCpikVvWK7bIK8bm0YMVpB2RawuDZOhN4MZE5pjvNrkbYlLldWynwbJ2XPbzxaFpjhpqTsN4C++KSxFu8sIQ6buuNw8NbkO524YnNbC85rydDCfKe2/lPRL4GhFeY6a8IQTiaYbKcteaDatjpLlmZnxsGe/OywMEt5kaF4bNBt7aiDI96Ie6B2gGXrez+cDx8GC1DBgGO5qUt1oIvA2Dv8PKttOXKII+nTnJhbDvOgVt
 hQFWM7YQ
 99OejtitYDkn6mvHN3K+/7T3Gqj93hNE5ezc8yOkbSodY+r1y/IYCk+hKcsl7SftwcKt04U+c6RUhEpBGzjqaNldO2N8EXmWadlruRfvji7BlJ0VsSMG2ejmWIOf0cbOLMZ44iXnN1NBfxaaHg7Io1vlDjAo0tB6wJgvs+GWN1JjqsQ5JR8CrghB87He3LdZ0TLtj1O+8dPryCIC9SvNDgyWpCwd8m/3CHXRjTgl8ayg2mO0DmXGNUxDHiSFsHmkzgsIYYcf3WBILYOganFgcW0kyikgvi2nTOwGj/R315cDu0N/pXhTVov8y5ub27rrCaD8ZfO5PAitfylGFbUHpA4lUW/8lMLoRGWM4sEXwM5aLoR4jnVz12w4mgTuYQfkky6j/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 11:00, yangshiguang wrote:
> 
> 
> At 2025-09-01 16:46:13, "Vlastimil Babka" <vbabka@suse.cz> wrote:
>>On 9/1/25 10:29, yangshiguang wrote:
>>> 
>>> 
>>> At 2025-09-01 16:15:04, "Vlastimil Babka" <vbabka@suse.cz> wrote:
>>>>On 9/1/25 09:50, David Rientjes wrote:
>>>>> On Sat, 30 Aug 2025, yangshiguang1011@163.com wrote:
>>>>> 
>>>>>> From: yangshiguang <yangshiguang@xiaomi.com>
>>>>>> 
>>>>>> From: yangshiguang <yangshiguang@xiaomi.com>
>>>>>> 
>>>>> 
>>>>> Duplicate lines.
>>>>> 
>>>>>> set_track_prepare() can incur lock recursion.
>>>>>> The issue is that it is called from hrtimer_start_range_ns
>>>>>> holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
>>>>>> CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
>>>>>> and try to hold the per_cpu(hrtimer_bases)[n].lock.
>>>>>> 
>>>>>> Avoid deadlock caused by implicitly waking up kswapd by
>>>>>> passing in allocation flags. And the slab caller context has
>>>>>> preemption disabled, so __GFP_KSWAPD_RECLAIM must not appear in gfp_flags.
>>>>>> 
>>>>> 
>>>>> This mentions __GFP_KSWAPD_RECLAIM, but the patch actually masks off 
>>>>> __GFP_DIRECT_RECLAIM which would be a heavierweight operation.  Disabling 
>>>>> direct reclaim does not necessarily imply that kswapd will be disabled as 
>>>>> well.
>>>>
>>>>Yeah I think the changelog should say __GFP_DIRECT_RECLAIM.
>>>>
>>>>> Are you meaning to clear __GFP_RECLAIM in set_track_prepare()?
>>>>
>>>>No because if the context context (e.g. the hrtimers) can't support
>>>>__GFP_KSWAPD_RECLAIM it won't have it in gfp_flags and we now pass them to
>>> 
>>>>set_track_prepare() so it already won't be there.
>>> 
>>> 
>>> Sry. Should be __GFP_DIRECT_RECLAIM. I will resend the patch.
>>
>>I have adjusted it locally already. Also moved the masking of
>>__GFP_DIRECT_RECLAIM to ___slab_alloc itself as that's where
>>the preemption is disabled so it's more obvious.
>>
>>Does the result look good to you?
> 
> This looks good.
> Currently only ___slab_alloc disables preemption context calls to set_track. 
> In the future, not all callers will disable preemption. 

Great, added to slab/for-next-fixes. Thanks!


