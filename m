Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A1DCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37E5900240; Fri, 15 Aug 2025 05:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8E98E01E3; Fri, 15 Aug 2025 05:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE338E0002; Fri, 15 Aug 2025 05:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B76208E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:16:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F76F1408DB
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:16:17 +0000 (UTC)
X-FDA: 83778435594.26.AD6F43B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id F356C20006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:16:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755249374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/7ya8INStVMqkmoMSO2oxJYj8QSnxMUfKWHQpCBE+ws=;
	b=TgW5cxaMR20kevSKWcbAuzuYxr9scKqMi5uHlCMUuIYfirSncURfsSezOa08iYrhWcgfhq
	dDxMXtK+YOmUZc4uw+C/m2M51YSAAXbtEazMfe6CfqUVpqDLu/ltV96JR/R+M+toq6YyRG
	wGxm2jC1s6oo+kiLUxQI5K7uTIHAzGs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755249374; a=rsa-sha256;
	cv=none;
	b=1Bg6Rt5F2oaW5o9IpeLdgHIKdkNOCgl4gGFc+UIq/ft8P0/6U7Mm0qmUxfPrGzk/u/G8y+
	/IJfo9z9d21IcZrub8/l25P2Fa2W8JQCHKXLHKbamF1wvPlUff9ttoEq9ktgVj7nDfdufq
	zD89VUY9PguESWKqCAZS50K7LwGZL2w=
X-UUID: 761695a079b811f0b29709d653e92f7d-20250815
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:f11915a3-68c4-4069-9eb1-1092cd56b60d,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.45,REQID:f11915a3-68c4-4069-9eb1-1092cd56b60d,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6493067,CLOUDID:638da975861fe3bbe853ae5512f271c7,BulkI
	D:250815002500R9UDT29E,BulkQuantity:1,Recheck:0,SF:17|19|24|44|64|66|78|80
	|81|82|83|102|841,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: 761695a079b811f0b29709d653e92f7d-20250815
X-User: lienze@kylinos.cn
Received: from kylin [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 380113571; Fri, 15 Aug 2025 17:16:01 +0800
From: Enze Li <lienze@kylinos.cn>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org,  damon@lists.linux.dev,  linux-mm@kvack.org,
  enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/Kconfig: enforce DAMON_STAT when
 DAMON_STAT_ENABLED_DEFAULT is selected
In-Reply-To: <20250814162446.69575-1-sj@kernel.org> (SeongJae Park's message
	of "Thu, 14 Aug 2025 09:24:46 -0700")
References: <20250814162446.69575-1-sj@kernel.org>
Date: Fri, 15 Aug 2025 17:15:54 +0800
Message-ID: <87a541c5dh.fsf@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: F356C20006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6s5n6wufqe9314j35di3zccici46ed33
X-HE-Tag: 1755249370-364414
X-HE-Meta: U2FsdGVkX19YzLo9P391twURdJdV9rFU8k1AcmxE/O78uHI2vWwPCAVLSdufQQi4X6+r805xUcnpT7vjXrkEeEqIzgy2IlKPCZsaHV7gyefZA63mJHlKoe1dWA4kKcZzd2XgvGbffFgF6ZjXRD2AawpIjRtBbG2ZPE+hAY679ujhDMTQUAKVmoHqEXuUKpILxuZHR1fvOL0f3qMut7+xtj8fVIGP75wVA+VLfJ1y9jzh43FkjNJ0ntQMRYLP0FkVWu9LdvMgKPdqyRW5nZYe1Y9asegCerEqGfzq9fzmJuL36H6zAm/sRkRaBbCX6FWDAN6aBvT6QuBM9JYlHIz5lHFb3FdceFgKUCEG3oFuoa+5x4mj4RLxtAwau6hU7PVt15W1qOeSDBxpruMqjVWUbWqERJZj92LWRgZSLsfK5+nDqMN6rTI69G5Z9AHn6vIbAuXuxeAjXV/q3EKhpkDDOymWezhnV6sdKeY7mVZAxjL6VKnzAMza8bD9kmLsYn/00lxACf4Kar4pRUFhmz0iWjWFRBtzIXDG2US/WF0ktdXDJ+H7siXI7iK7VzNBWXTHVTbIqzK/TKKZeE/7vGmWjp9/wjx1MKSBhKhr98ZqJNrJpXdXlgo0No5dqszbw1pxBVrUuKSUrdyMhApOlLOVt2Ki2e3s5qWjOOGhXHUCs5QCqYtwOKXt/syXNaNxWaxe+rtC/KraGGvQDC8dbi/Crd1NnhsIX+0YE/TAtdRfEB2GV4dwMO/s/umHGz88A1okexRs6tutrN1Znn4kJ3nYg+Hfu0VmqC8crwghJWDJl8moJuh/TdzItBhBlnl2+lzSq3iQFoT1h/s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Thu, Aug 14 2025 at 09:24:46 AM -0700, SeongJae Park wrote:

> Hi Enze,
>
> On Thu, 14 Aug 2025 20:17:03 +0800 Enze Li <lienze@kylinos.cn> wrote:
>
>> The DAMON_STAT_ENABLED_DEFAULT option is strongly tied to
>> DAMON_STAT -- enabling it alone is meaningless.
>
> Nice catch, thank you Enze!
>
>> This patch modifies the
>> logic to automatically enable DAMON_STAT whenever
>> DAMON_STAT_ENABLED_DEFAULT is selected, ensuring functional consistency.
>> 
>> Signed-off-by: Enze Li <lienze@kylinos.cn>
>> ---
>>  mm/damon/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
>> index b3171f9406c1..5bc71354e6f3 100644
>> --- a/mm/damon/Kconfig
>> +++ b/mm/damon/Kconfig
>> @@ -105,7 +105,7 @@ config DAMON_STAT
>>  config DAMON_STAT_ENABLED_DEFAULT
>>  	bool "Enable DAMON_STAT by default"
>>  	depends on DAMON_PADDR
>> -	default DAMON_STAT
>> +	select DAMON_STAT

Thanks for your review.  I've updated the patch addressing all your
comments below.  And I'll send the new version to the list shortly.

>
> I don't think we need to drop 'default DAMON_STAT', though.
>
> To me, it seems the problem is the wrong dependency.  What about making
> DAMON_STAT_ENABLED_DEFAULT depends on DAMON_STAT, like below?
>
> """
> diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
> index ecbdb3e2ae58..d5f8db812dd3 100644
> --- a/mm/damon/Kconfig
> +++ b/mm/damon/Kconfig
> @@ -104,7 +104,7 @@ config DAMON_STAT
>
>  config DAMON_STAT_ENABLED_DEFAULT
>         bool "Enable DAMON_STAT by default"
> -       depends on DAMON_PADDR
> +       depends on DAMON_STAT
>         default DAMON_STAT
>         help
>           Whether to enable DAMON_STAT by default.  Users can disable it in
> """
>
> Also, the subject sounds like a bit strong tone ("enforce").  How about
>
> "mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT depends on DAMON_STAT" ?
>

Best Regards,
Enze

