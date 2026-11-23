Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C87E606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fOY3WO/a
Received: by kanga.kvack.org (Postfix)
	id 493296B05B0; Mon, 23 Nov 2026 01:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443F56B05B1; Mon, 23 Nov 2026 01:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333146B05B2; Mon, 23 Nov 2026 01:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF586B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:06:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64D6112078A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:06:04 +0000 (UTC)
X-FDA: 85465348248.30.6E619F9
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	by imf14.hostedemail.com (Postfix) with ESMTP id 40745100002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:06:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fOY3WO/a";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795413962;
	b=n70Z9AvMHDSH/nb2cHigQWMu6gAG0e1tw6fQtkT9R/gpbS5IH1TUg3tsQVbIVLPR+l2yHq
	5x0gIZ8/dQiibCmOwyfLelMhbxSOO6gWjl9Xlhwis1CRV8kSZb2inhBLfK+72vcH2ScXIV
	Vmhk33cGDI+LVhRt+/MrwENR/Pb7d0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795413962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PuORYyIRteJHQ11GLpV7a3611w1hxaJP4SNy0f1jBM=;
	b=mTUJ80FJnf1DAfhtys5SRoyGxXoimVsroJBNSlBDdB+ABfP7JwxrzEsiUBLLgp7gdfRqWp
	ktT7crxuFbT+MDwLwE4PjdwSydgyC/87gXIQgcRsVIoJcNfSQDV+3PN3eDegjwcDX3QckC
	pP2/Tg8S4VoR6x0EpN68oWz9xTvefDU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fOY3WO/a";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6VgZ8APOVsZATxmkMTLKbiBq2l/jRInYDz1+DuyOQ5g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795413959; v=1; x=1796018759;
 b=fOY3WO/a0soK8p+g8L6ox7ROdjzFom203CK50EmztSfjCy8r0eDGM4n2v4CioGRsEip99aUl
 0dP8zXe2iLIZN4C4qAUrhxSQEpoVQ+mPXcGZndI5e2v9Und3bLoczm/G6tQBPq/HDwByWjhd820
 3W1YJEmBU03UiJZMrTyEQEfE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a6b9e6724bc2b9ab;
	Mon, 23 Nov 2026 06:05:59 +0000
X-Mizu-Trace-ID: a6b9e6724bc2b9ab
X-Migadu-Flow: FLOW_OUT
Message-ID: <75bc217d-585c-40bb-954e-cf6df80e24f2@linux.dev>
Date: Mon, 23 Nov 2026 14:05:51 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shrinker: stop counting when the seq buffer overflows
To: Xuewen Wang <wangxuewen_ky@163.com>, akpm@linux-foundation.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Xuewen Wang <wangxuewen@kylinos.cn>
References: <20261120110538.3256962-1-wangxuewen_ky@163.com>
 <57ef6b0f-e9eb-4484-b07f-63c848ffde4e@linux.dev>
 <56dc7b93-604c-49bd-9e86-f519c7a90b97@163.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <56dc7b93-604c-49bd-9e86-f519c7a90b97@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40745100002
X-Stat-Signature: w6dj785s9csibfyinwk5pndk6hh6w7ud
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795413962-721854
X-HE-Meta: U2FsdGVkX19RR3LNcYCuVgRxjxf4JLb/JGXfRS5X4gsH3VOpDhd5VYzGg5g1ubGlek5Xj4qwW8yP0E1rR+wZM0X4phFfsh6JI8/KidjI70uVuAh8KipyHuSAvVFOzO5e9hVPf9WamIJov4Ii7ZJiD3c6uNXrnARc2ISUXbkxR6VRhqY+4AvEqETLNdhf+hGXmJKxi3yCuEqqJVtUIlsOS75JYDSfBQECy2Dv9MmlLszBLzjVvG3Nh7X/bOonnuiekp1H4JSyfQY5QOSfTiKfC81t9XoEFR9n3uRNSXq0EVu3/CmtBj/1uzvit5gVEb4ePZoJvMvs3/I+9caFUeSd3V0dntCHG2vMf3lUnWhWgq/TlbyAcLVEik8actr1qdMV/MwxTDNLizx6ob7t36/ywZzW3bvyOXQOOYIYBO4ALCRXR3yf6dZ6cG4R/5BHBjs6TyCW6iF5QpThulbF/+nIYygIA+KC2mgaplYVVxymLcW8wKZt4h99WTth1eFMYVZ5gTm8BYv5+Mv/eZzfjeDpane3qzVoRSIK5L3BU2Mcq6Ry9DYo2xzxtmp8VKBnFC0/Iz+vPWrmTLRZWK61xSztwP2HQegmQLKjaZbaTN+xKT2CeznJZSh7IlFccjqs2c58EjLjigX1CCBzJjaygkrQ/BC37RQUeOY3ufTLg8SNowTbbsn37UJfHv+tob1CGqt7JiXliqwi3DGB7fWDytokyI+3tPSL6dJDoqrVE0nO7+ADxgvHUK5AgMJa0WW94KXiX9e1oE3waQA+CrrdeAwuOm+hhHxXn9Vpk1n4hf93PbObvPYk3qr5leJ55QK67SkFm8AHjm/aSCMYomHWkii17gQGf2oNc6m5r63HcegaZa60hCNSWGizz2+1DKSyrPRGyV1SWYYF8LtA5YXU6u+rw0w1ZXYvJU0BVgpuE+VCGKSYNDDH7idyC4QJm0sWrgq/mRyO5C4Tt5vqxg4sEdm
 QfuPJ1ay
 V8MoJBAGYsG+tLM6gOhlE89UzEoBqpaxACJDAck+34uRSCrEwfDyJZxajbpa0jQ3YIliKu96KDrgySRX3kfct13QpOXaoVJWcrJsZSt+o4JV66yOh9TAqd5uHvmzCKQnbge60fOP3oSCKNCzTyXVLc9O+M/E/bNAjzOMXSf6snd506LZkUraNCJIYu2IS1lgOIrOvlZGJpH7n8uAxGTlTjQep1FzOmkt3qMvN+iEmlx6Yn776yDJACRI74pLyYWAySd2Qm1Rc1lP47xkBnD07P34hGV5l+qM3FJqDHf0QIAJcemnHwoGbb56U16/gvykZFbRBf1tSdEHlGkLlIgv5uu4xjNWqnuNAYnar0XSE8ttnSnEANmAlmuzEnoXZzwAQepxh4s412saK5+uH7F1MeCdZZtRfnXQtZ30fKrWz/+U3AMKG5a9eXUUxC6jBa1m9sryaIkW6bHdg/nd/b6BIYmuXS7Qaj4TGIDSVpTUxML6Ma7CozMAko5sPkGlt1WWzlIcv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/23/26 1:45 PM, Xuewen Wang wrote:
> 
> 
> 在 2026/11/21 19:10, Qi Zheng 写道:
>>
>>
>> On 11/20/26 7:05 PM, Xuewen Wang wrote:
>>> From: Xuewen Wang <wangxuewen@kylinos.cn>
>>>
>>> The shrinker debugfs count file uses single_open(), so all memcg rows
>>> belong to one seq_file record. When the buffer overflows, seq_file grows
>>> it and retries the entire record. Queries for subsequent memcgs in
>>> an overflowing pass cannot contribute to the final output.
>>>
>>> Stop the traversal once seq_has_overflowed() is true, using the existing
>>> mem_cgroup_iter_break() path to release the current memcg reference.
>>> Leave the overflow state intact and return zero so seq_file can retry.
>>>
>>> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
>>> ---
>>> In a single-node KVM guest with 1024 cgroups each caching 16 ordinary
>>> files on ext4, the 8865-byte output required three show attempts. Count
>>> callbacks fell from 3075 to 2472 (19.6%). With probes disabled, six 
>>> fresh
>>> guests per variant each performed 101 full reads. The median of guest
>>> medians fell from 128.2 us to 112.2 us (12.4%, about 16 us per read).
>>> Small and sparse outputs had unchanged callback counts. Complete output,
>>> small reads and seek-to-zero rereads matched; concurrent memcg deletion
>>> and signal interruption checks also passed.
>>>
>>> The successful pass still traverses the full list. Early exit skips
>>> count queries for subsequent memcgs in overflowing passes.
>>>
>>> When overflow coincides with a pending signal, the original code can
>>> return -EINTR in the current pass. With early exit, seq_file attempts to
>>> grow the buffer first. The retry can return -EINTR, or buffer allocation
>>> can fail first with -ENOMEM.
>>
>> Would something like the following work instead?
>>
>>           if (!memcg_aware) {
>>               mem_cgroup_iter_break(NULL, memcg);
>>               break;
>>           }
>>
>>           if (signal_pending(current)) {
>>               mem_cgroup_iter_break(NULL, memcg);
>>               ret = -EINTR;
>>               break;
>>           }
>>
>> +        if (seq_has_overflowed(m)) {
>> +            mem_cgroup_iter_break(NULL, memcg);
>> +            break;
>> +        }
>>       } while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>>
>> Thanks,
>> Qi
>>
> Hi Qi,
> Thanks for your review. I've modified and tested the patch following 
> your suggestions, and will send out v2 shortly.
> 
> Thanks,
> Xuewen
>>>
>>>   mm/shrinker_debug.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)

LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

>>>
>>> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
>>> index cafb566301326..3022d103b0b1e 100644
>>> --- a/mm/shrinker_debug.c
>>> +++ b/mm/shrinker_debug.c
>>> @@ -74,7 +74,7 @@ static int shrinker_debugfs_count_show(struct 
>>> seq_file *m, void *v)
>>>               seq_putc(m, '\n');
>>>           }
>>> -        if (!memcg_aware) {
>>> +        if (!memcg_aware || seq_has_overflowed(m)) {
>>>               mem_cgroup_iter_break(NULL, memcg);
>>>               break;
>>>           }
> 


