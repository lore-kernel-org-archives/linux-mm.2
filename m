Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58DE2CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 07:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7886B000D; Tue,  2 Dec 2025 02:56:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF2C6B0010; Tue,  2 Dec 2025 02:56:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5446B0011; Tue,  2 Dec 2025 02:56:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78E4D6B000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:56:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 381575127A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:56:24 +0000 (UTC)
X-FDA: 84173773488.13.8445CD8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 584318000B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:56:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764662181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I8ihM0SF+tcv92+haohp6cGqhgZoS2q+NgmXg2PGgFM=;
	b=igM5OyjFtrAHNrM1NL0tBNX52ad14rbaTMOCnWHfiJCTjNhjHTGc6psq3e4wj9KBq6W9D3
	G6iWN+seZjpTcYqrfy0WNFG7Tns6zRRMSjzpmrZaWBzTzUu5QtYLLNyKpk8eaKvZ2vIbD5
	Pyuh1mce2OXyReuXBcUcEzE4tyE63H4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764662181; a=rsa-sha256;
	cv=none;
	b=nGfkX3QvdbhAFk5f73BWe5nIliXt1Ua/PinfK0EA1FJEgoIKcwORkkFc3E6z2k1NOyTUN6
	ykR3OgfrmDYJqWTZ5EjkSk+/l3RKDXIgjp4nCPh+W+HDUxE/LYJfVujA4eNaE4DqIL52r5
	ugjN2TK5Ec87zu00AlqEgyyeijpuxDk=
X-UUID: 5eabc5c4cf5411f0a38c85956e01ac42-20251202
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_MISS, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:d0dc6c50-65c7-4534-891d-652e90468ade,IP:20,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.3.6,REQID:d0dc6c50-65c7-4534-891d-652e90468ade,IP:20,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:a9d874c,CLOUDID:039194030dede998078eec01d89f9611,BulkI
	D:2512021031260E6B9Z8S,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5eabc5c4cf5411f0a38c85956e01ac42-20251202
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 147703907; Tue, 02 Dec 2025 15:56:12 +0800
From: Enze Li <lienze@kylinos.cn>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org,  damon@lists.linux.dev,  linux-mm@kvack.org,
  enze.li@gmx.com,  stable@vger.kernel.org,lienze@kylinos.cn
Subject: Re: [PATCH] mm/damon/core: support multiple damon_call_control
 requests
In-Reply-To: <20251202052956.987-1-sj@kernel.org> (SeongJae Park's message of
	"Mon, 1 Dec 2025 21:29:55 -0800")
References: <20251202052956.987-1-sj@kernel.org>
Date: Tue, 02 Dec 2025 15:55:56 +0800
Message-ID: <87bjkh71wz.fsf@>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 584318000B
X-Rspamd-Server: rspam11
X-Stat-Signature: 85f9z1oe17w1wudem5k9yr3afjzwyxy8
X-HE-Tag: 1764662179-976018
X-HE-Meta: U2FsdGVkX19G5yqJ+R3WsBOrhS97XWocOiSHUsBVLSS8cWHwgG0CRQbWvjiqk72QZZvGXnq/nJlylDTH8CjNcDKKyaY9T3vj4C+ZR5dD2SmZM/XOtpN/lY0Dkx+XnIA7VTnBI0e+y+fYF69q7FL4UuTcPuoytBrICVeFdqQIt6nXRfDMlVIyJ7nIKaeqTyrRmDyBkt/F/foQCY0+rFEGxYVCFT7mKW4wudvlZSr/mzYfOW6+etMrrKeMR7Jgm4dWphJNTvvo9McnerYsD/LMrvNCgr6dRwwQuKgvpd+48cyFhvJ6NSAWXAXPRNGXop71Xr+5dPlja+vUqt9z3/Zpgtyj8+5P6PYx9XHPONc5Od0ETl3j+TfSl7VAnfFLKJ/bKb3nvP99uj9PbX9mJDY35crAohjINExa11p2dDsLfGR6z+bV+f72UEFjNnhdNhDAOLD1jKUkVw1KuLzGSSAyFV5hZaeO4R3M5Na/51RfSycl01RI5ZVJmGzD7F29mmnPrumGVw+eoPHaivBDfQUvVI3Gdn8hoVtxjeO4vuA5FCnIz6gIlsUY0N0bvnmFyRvI/koaaBy213SLk3CgWPkTroXuQYggcNhjrOCy2gzxj0cdZTTzLt6rK2QgMhB8ikKOmueLFdXCzFg2Dz4hcUuyA8uJP+hQIr1i99+mL1iEE396S9i/WAOmvhf3IyiMT3hM/kTYkoPqi6r6abd2nuXTHFQ6oWTiGfq2Un4nOdEgkpZXuREBuH0ynA2fTzVEr/hfH7AwmEf66ALkQ2G7znxTt1igadU+Y44+6Qs3WXmsOd7GJVBfWug/8vZ4JQjMemldfWu1JzlHmS9dZtw3QUq0aEXxRRzuKu+whRnR/BlO7M9DLjs5PC5TxioUm700swW4Vr6CsRyHm/tGyA43FsFS3tQs7HFP/chE1oXTIrQyF69UL27H1+uHp1OsGdV/rPKyQ21WFDgyjuLwIwCCFZN
 IBvns04I
 j1Lac9wzR306M3gzj5H6cSTwc6DP3gcip9q5ry/gBUDobmgqqJzWpJi0uK4LO90R/t81b/WUjVVN1yNY/j7GZwBG37Zu5AG0seK0N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thanks for your review and quick reply!

On Mon, Dec 01 2025 at 09:29:55 PM -0800, SeongJae Park wrote:

<...>

> On Tue,  2 Dec 2025 10:14:07 +0800 Enze Li <lienze@kylinos.cn> wrote:
>
>> The current implementation only supports repeated calls to a single
>> damon_call_control request per context.
>
> I understand "repeated calls to a single damon_call_control" means "single
> damon_call_control object having ->repeat set as true".  Let me call it "repeat
> mode damon_call_control object".
>
> This is not an intentionally designed limitation but a bug.  damon_call()
> allows callers adding multiple repeat mode damon_call_control objects per
> context.  Technically, it adds any requested damon_call_control object to the
> per-context linked list, regardless of the number of repeat mode objects on the
> list.  But, the consumer of the damon_call_control objects list,
> kdamond_call(), moves the repeat mode objects from the per-context list to a
> temporal list (repeat_controls), and then move only the first repeat mode entry
> from the temporal list to the per-context list.
>
> If there were multiple repeat mode objects in the per-context list, what
> happens to the remaining repeat mode damon_call_control objects on the temporal
> list?  Nothing.  As a result, the memory for the objects are leaked.
> Definitely this is a bug.

Thank you for the detailed explanation -- it really clarified the design
for me.

>
> Luckily there is no such multiple repeat mode damon_call() requests, so no
> upstream kernel user is exposed to the memory leak bug in real.  But the bug is
> a bug.  We should fix this.
>
>> This limitation introduces
>> inefficiencies for scenarios that require registering multiple deferred
>> operations.
>
> I'm not very convinced with the above reasoning because 1. it is not a matter
> of inefficiency but a clear memory leak bug.  2. there is no damon_call()
> callers that want to have multiple deferred operations with high efficiency, at
> the moment.  In my opinion, the above sentence is better to be just dropped.
>

Agreed.  I will rework the patch description for the next revision.

>> 
>> This patch modifies the implementation of kdamond_call() to support
>> repeated calls to multiple damon_call_control requests.
>
> This change is rquired for fixing the bug, though.
>

<...>

>
> Assuming we agree on the fact this is a fix of the bug, I think we should add
> below tags.
>
> Fixes: 43df7676e550 ("mm/damon/core: introduce repeat mode damon_call()")
> Cc: <stable@vger.kernel.org> # 6.17.x
>
>> ---
>>  mm/damon/core.c | 20 +++++++++++++-------
>>  1 file changed, 13 insertions(+), 7 deletions(-)
>> 
>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>> index 109b050c795a..66b5bae44f22 100644
>> --- a/mm/damon/core.c
>> +++ b/mm/damon/core.c
>> @@ -2526,13 +2526,19 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
>>  			list_add(&control->list, &repeat_controls);
>>  		}
>>  	}
>> -	control = list_first_entry_or_null(&repeat_controls,
>> -			struct damon_call_control, list);
>> -	if (!control || cancel)
>> -		return;
>> -	mutex_lock(&ctx->call_controls_lock);
>> -	list_add_tail(&control->list, &ctx->call_controls);
>> -	mutex_unlock(&ctx->call_controls_lock);
>> +	while (true) {
>> +		control = list_first_entry_or_null(&repeat_controls,
>> +				struct damon_call_control, list);
>> +		if (!control)
>> +			break;
>> +		/* Unlink from the repeate_controls list. */
>> +		list_del(&control->list);
>> +		if (cancel)
>> +			continue;
>> +		mutex_lock(&ctx->call_controls_lock);
>> +		list_add(&control->list, &ctx->call_controls);
>> +		mutex_unlock(&ctx->call_controls_lock);
>> +	}
>
> This looks good enough to fix the bug.
>
> Could you please resend this patch after rewording the commit message as
> appripriate for the bug fix, adding points I listed above?

Okay, I'll resend this patch shortly.

Best Regards,
Enze

<...>

