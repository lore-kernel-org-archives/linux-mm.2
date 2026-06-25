Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E33CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7A76B00D6; Thu, 25 Jun 2026 03:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F356B00D8; Thu, 25 Jun 2026 03:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D810C6B00D9; Thu, 25 Jun 2026 03:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE0BF6B00D6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:22:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28207C2046
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:22:52 +0000 (UTC)
X-FDA: 84917592984.25.BA32E0D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id EABA5180008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:22:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782372170;
	b=NJ5LcdlKuiQem8kIaL5tFUzKUEf1gA/95TcnfJpsWEyeiEQVYqpQlmsF/DEjzXb0qu8vgC
	PXzkQ8bwdxWPy2wj5OM1IbShwTPDl3L2IP/q13yuaF2kzdm8OdTglQO4fOgBDuLwc+ab1d
	byA5MHOJPQteF87lzM7lydow6chfogs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782372170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbffOdO5wrCVWJw7fueYyW02jsmfD2OaFdt8gpgX19c=;
	b=tn+ibFUyMQnG4EcgXpTqnIUVpaUVrOArvnmI/bTNdhJ1AfrOg+9Bu7FRH8fndg4Q5DYESq
	RUk+kRWoChmt6QJdwUQ2PQTI2foTOFWK+YMtCE5Mv4HLGTbzSiH10vC5dvttvMmVRVoEJR
	l/SI2xvEvqlUc7wM1GucjvNpCElxwYM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
X-UUID: a6ada5dc706611f1aa26b74ffac11d73-20260625
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:3ca0d9f9-5d02-49d5-b644-8d4b2df7f031,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:3ca0d9f9-5d02-49d5-b644-8d4b2df7f031,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:a98d19fdf128406f6b84af0f6212bf82,BulkI
	D:2606242154552XWL5CDE,BulkQuantity:4,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a6ada5dc706611f1aa26b74ffac11d73-20260625
X-User: wangxuewen@kylinos.cn
Received: from [10.211.134.243] [(223.160.131.156)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 614373274; Thu, 25 Jun 2026 15:22:41 +0800
Message-ID: <b21d7d5c-5cce-4ddc-9974-a8731da788cf@kylinos.cn>
Date: Thu, 25 Jun 2026 15:22:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: fix data-race in folio_batch_count()
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
 <ajvkK-vcVzgll2Tm@lucifer>
From: Xuewen Wang <wangxuewen@kylinos.cn>
In-Reply-To: <ajvkK-vcVzgll2Tm@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EABA5180008
X-Stat-Signature: zngb436g7ymcyqhmwj87ne8hqbsk4cyx
X-HE-Tag: 1782372168-734518
X-HE-Meta: U2FsdGVkX1804ytkk2C9xLnX8ztkxIkQ2pafSMwWdEwt2/3yduu7t0Go4wFFZcwpx7voA1d8VCbaz4P5Kxlxhuu8OI2AFio9jmkGXRfAfvH/GfRiMmcWZegOT/C2oMFSPjvpHbSHpYQj86lGMBXjWIO/knGC0+06wOEWSkIESHX97XlML9aW39hmJZVUDQFL0YJXeGSBRR5nd3OsYRv92qv+m+DOvtrBS+Kz7Rmib/6kqvUIf4Esd7YXdqfTxLUyZV3bL/C69EsB6s+brpAVMicfP+jXzrkRluRsehXEHO+13BZ9C6Q3ytik3pEKYQi2/4wUsU3Ol+YLeRqJpCZD7OB7MJFew5Kxe+A8UKCdqpPoTe/KbPiOaOgxhRFIhYHQfWGP3NRyKwe1uHj2nihcWYpbgRYNSB0hocNbqSVnUsd09j/qMVvlFRp5zfISPKGr6/MokeW6GAtGNjqAdVtdfrBk2ENgGcqrSjcGk6h6xKVNoxOZ7+YjgqxvpyCmCsKNIs8M1ZvMqf2hwZ00BR1kI9g19hV97jcxln1tVXDFLGbpLbRWKMJd6byeY727suTbJxrEVxOJJ7h5dXNVeye8JNZD5kfxBksYVZh3BFCAYOJLkbvUlMS4F76VSDT/Ms99fLSsMVsvNruwaYhlJJ4OAquMYL4DyrE9+pBu574ZCc9AkN+cLOJnBjeLREORSp5LwVrwsb6VXj9OO6GfPjeGetgdL4zYk2SeDfHIRtloKFeENALXwXz5xseKLgAMDzLT5SH7e1gbc/g0UXITMsZhu+uoFGCETxIKMHS3ZLQ8IwADNFuVoYFM5lY+it2IR3QFjK+htYyqz3Y04KSnxQWgiRDR1ho6R0zBBc82nzgcOWSGCvZJ29Cxt+WLyI88NJ1hcvoWE4SzLHSxEkfHfG6DUhhcdOqKDj+2d3kp4wSoXtoGVEoSRM6819w36iJJGOwMlUZ/6eFYawPlZ37Fgap
 7hlXmy4i
 vUEP9Z8DXLPZnNssa7wxVUr+qYkzU0PQsPFfq0ji5/vyU+IlqBqe1Re3GgmcawXPsUk/3UsKWNhbWDMacPleI2y/ZcjzYqZNoqfl+7VRlGFC5m0euqWaV3iSwsMulQKsrWIPg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thanks for the review.

This was not reported by syzbot. We found it via internal KCSAN
fuzzing on our downstream v6.6.89 kernel.

I will send v2 shortly with the following changes:

- Use data_race() instead of READ_ONCE() in folio_batch_count(),
  as you suggested. READ_ONCE() is unnecessary for a single-byte
  read and would impose overhead on all callers.
- Move the annotation from folio_batch_count() to the actual call
  sites (cpu_needs_drain() and need_mlock_drain()) where the
  cross-CPU race occurs, rather than affecting all callers.
- Also add data_race() to need_mlock_drain() which has the same
  cross-CPU race.
- Add comments explaining why the data race is safe.

Looking forward to your review and suggestions on v2.

Regards,
Xuewen Wang

在 2026/6/24 22:23, Lorenzo Stoakes 写道:
> On Wed, Jun 24, 2026 at 05:26:06PM +0800, Xuewen Wang wrote:
>> KCSAN reports:
>>
>> BUG: KCSAN: data-race in __lru_add_drain_all / folio_batch_add_and_move
> 
> Where? A syzbot report? A local run? Please specify.
> 
>>
>> write to 0xffff98fe74c015f8 of 1 bytes by task 45153 on cpu 2:
>>   folio_batch_add+0x30/0xe0
>>
>> read to 0xffff98fe74c015f8 of 1 bytes by task 45175 on cpu 0:
>>   folio_batch_count+0x0/0x10
>>   cpu_needs_drain+0x253/0x430
>>
>> The write side is a per-cpu local operation (folio_batch_add on the
>> CPU that owns the per-cpu batch), while cpu_needs_drain() reads
>> another CPU's per-cpu batch without locking. Reading a slightly stale
>> value is harmless -- it only determines whether to schedule a drain,
> 
> Then why are we adding a READ_ONCE() in such a core helper?
> 
>> and a subsequent check will catch it.
> 
> Where? Which check? Be specific.
> 
>>
>> Use READ_ONCE() to annotate the read and prevent load tearing, which
>> also suppresses the KCSAN warning.
> 
> Tearing on a single byte? Which architecture tears a single byte?
> 
> I think you're actually more concerned about the value being optimised out on
> assumption of it not being updated elsewhere right?
> 
> But acutally you're not, because everybody else uses a stack variable or _their
> own_ per-CPU value?
> 
> Only cpu_needs_drain() is the odd one out right?
> 
>>
>> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
>> ---
>>  include/linux/folio_batch.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
>> index b45946adc50b..1e31e058e19d 100644
>> --- a/include/linux/folio_batch.h
>> +++ b/include/linux/folio_batch.h
>> @@ -53,7 +53,7 @@ static inline void folio_batch_reinit(struct folio_batch *fbatch)
>>
>>  static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
>>  {
>> -	return fbatch->nr;
>> +	return READ_ONCE(fbatch->nr);
> 
> This isn't free, you're breaking optimisations here by doing that...
> 
> It feels like the wrong level of abstraction, but actually I think every other
> case is either stack or per-CPU _on its own CPU_ (please check), in which case
> we _can_ suppress the check here but I think best done with data_race().
> 
> And see the kernel bug bot report, you need to add:
> 
> #include <linux/compiler.h>
> 
> Too for that.
> 
>>  }
>>
>>  static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
>> --
>> 2.25.1
>>
> 
> Thanks, Lorenzo


