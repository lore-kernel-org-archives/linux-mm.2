Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF8D7D1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 09:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9706B0005; Tue,  9 Dec 2025 04:25:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD166B0007; Tue,  9 Dec 2025 04:25:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFF06B0008; Tue,  9 Dec 2025 04:25:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAC676B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:25:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67FA91342ED
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:25:01 +0000 (UTC)
X-FDA: 84199398402.03.827A106
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5922010000B
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:24:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765272299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rWEgDldFfPDlG3qNm9V415QJ+yZXsOryY6Fx7N7nkow=;
	b=ZQTDsv28LLJfCKmeMbeCwY/n4zagd9MCkgCTNCuQZ6nwF5mFCBaC5Q8Y+ZddpA6jHAhtrT
	o05GpyyMdWEoQikh7P2jPP9cmu4GI8PWp5bsenF0OTCW7vzYzQgY4HEdLveVLvM053eNe1
	/BbioTpuaGzIgVYegYzO1AUlP2X9kvQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765272299; a=rsa-sha256;
	cv=none;
	b=Z2CoQV+j43ws/jlbLT0jVlssDxjeF9Wo/+YnKU9CQaLSeMYfl4raXZWGgysDgSKZ8Eaa2H
	SgZ9g4ggW2yTN7jMXCoQyRS3IKWwZVnsd88DdJyOgpdWWSe0yIq/il7YpquyDBGzbvYpo5
	09ZzmByBo1Xu9bzDE1Ar3flw0GCKJLQ=
X-UUID: eab46aa8d4e011f0a38c85956e01ac42-20251209
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_MISS, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:cc9d4917-cb93-4c92-ba0b-6f42ec69972c,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:cc9d4917-cb93-4c92-ba0b-6f42ec69972c,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:a9312475a3097e25d83c3277e71310d7,BulkI
	D:2512091524078HSQS3BZ,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: eab46aa8d4e011f0a38c85956e01ac42-20251209
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 559780112; Tue, 09 Dec 2025 17:24:52 +0800
From: Enze Li <lienze@kylinos.cn>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org,  damon@lists.linux.dev,  linux-mm@kvack.org,
  enze.li@gmx.com, lienze@kylinos.cn
Subject: Re: [PATCH] mm/damon/core: delete damon_target when detected invalid
In-Reply-To: <20251209072146.42315-1-sj@kernel.org> (SeongJae Park's message
	of "Mon, 8 Dec 2025 23:21:45 -0800")
References: <20251209072146.42315-1-sj@kernel.org>
Date: Tue, 09 Dec 2025 17:24:49 +0800
Message-ID: <87v7igm2hq.fsf@>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 6ygaakssytm53kwz8e1p7zznqjuwgiy5
X-Rspamd-Queue-Id: 5922010000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765272297-291541
X-HE-Meta: U2FsdGVkX1+HYQ2eIFfVK+/SthzP9gC02w1pXbYsuUdbGdFzUDY0eX+c3z7d2muriTwxnzkWNd2QIpgh3yW49CtNOjURKD/TI1+bDJeMw6e2Fnfdld81J1KupLgEABtUrKecNxqFSZbXLeoaIX5CGur9aL26l8q//lBi4AFqslOjpeyVYukx2nLGK9PFwMyO/0KFYAkLZi03o9HTe+xlF2Jwh307xE8zABlF8t7nolZ+DJC6AIbLKTp7yc4T6aFSlQZl0Dnta6oDFvf4eW40mSAXuxjgSDfjX55jm/sZ/Zj9oZo71i8ukM1orImhphKBOkYLMZLFV/j1hOvO1Xeq1gUEEIzc/xbN0m9BFiSOxFKcKLjM2+ZnrkmiRgM2+38jk87oFjphhrh8aBRcacWjEofMKdv/GUTKUR7GiFbiECryjgTwuPs6MbwRf0ye8KCsucg/nAW3IpXVReMS5JATdD1hCd9EPQ3Lrlfd7hRNDFe68/gdAfzykZSGMKBRT3IOvFgDnPmSf0l3AInjrlehFNVmFYLur0G2bnTXC/mAVn1UnHOIOiFbz44ctA7HE6YW2U34brkzUwe0igO80s+KLQxTklq9KDxBSvoonyB+r+L8A/FVwll8o9BttXLDDKK7xaSPCyKBMF8Npbq7wmvhogPiy7yQJwaCrzj48G/17rwoLCyMDIkOhkyEVDMs52X15NjHFyFM5S8V/fGTUhnT3dKBDLR+DaYRHaYD9p21uLS1LA0varbd/59nbwOkaZfneN3ibx4kN8WNXFRoXmzp1+xDPGffeqKVOimsM9hoeWlVY9d5dcFo8fvU2OmjgJ/HqiolX4V93I0DtNfF4ubbKvdLK5h3T0BjhN6AX6JGHBns7HDdESEQST8wiiw+/YvJQNUF1FtDJ26VwF4aP6LVfZEsN8kHnuz+rp9vFBjsF15PyVfjVP1r7uUanVfz+s6ZmQ5njhjINvXadm3IFr0
 eo2KmDpZ
 mLiN6aqko6Ealo/p5bpoC/vSdxTMrPPiuI51W218OQ9XLzo+9sUec0Upy4mce7VZJULOdCxxjcgwkKqk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Mon, Dec 08 2025 at 11:21:45 PM -0800, SeongJae Park wrote:

> On Tue,  9 Dec 2025 13:57:13 +0800 Enze Li <lienze@kylinos.cn> wrote:
>
>> Currently, DAMON does not proactively clean up invalid monitoring
>> targets during its runtime.  When some monitored targets exit, DAMON
>> still makes the following unnecessary function calls,
>> 
>>   --damon_for_each_target--
>>   --damon_for_each_region--
>>       damon_do_apply_schemes
>>         damos_apply_scheme
>>           damon_va_apply_scheme
>>             damos_madvise
>>               damon_get_mm
>> 
>> and it is only in the damon_get_mm() that it may finally discover that
>> the monitoring target no longer exists.
>
> Thank you for finding this inefficiency, Enze!
>
>> 
>> To avoid wasting CPU resources, this patch modifies the
>> kdamond_need_stop() logic to proactively clean up monitoring targets
>> when they are found to be invalid.
>
> However, this could introduce an unexpected behavior change to DAMON sysfs
> users.  Let's consider a DAMON context having three target processes (a, b, c)
> is running.  The second process is terminated.  And the user updates the target
> with two existing processes and a new process (a, d, c) using the online commit
> feature.
>
> Before this change, 'a' and 'c' targets keep running with the old monitoring
> results.  The target for 'b' is replaced for 'd'.  After this change, the
> target for 'b' is removed from the list, and 'c' becomes the second target of
> the list.  Because the online commit feature works based on the indices of
> targets on the list, target for 'c' is updated for 'b', lose previous
> monitoring results.

Ah, I see.  I hadn't thought of that situation.

>
> Please let me know if I'm missing something.
>
>> 
>> Signed-off-by: Enze Li <lienze@kylinos.cn>
>> ---
>>  mm/damon/core.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>> 
>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>> index f9fc0375890a..eb5612bfd6bf 100644
>> --- a/mm/damon/core.c
>> +++ b/mm/damon/core.c
>> @@ -2462,7 +2462,8 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
>>   */
>>  static bool kdamond_need_stop(struct damon_ctx *ctx)
>>  {
>> -	struct damon_target *t;
>> +	struct damon_target *t, *next;
>> +	bool valid_target_exist = false;
>>  
>>  	if (kthread_should_stop())
>>  		return true;
>> @@ -2470,11 +2471,16 @@ static bool kdamond_need_stop(struct damon_ctx *ctx)
>>  	if (!ctx->ops.target_valid)
>>  		return false;
>>  
>> -	damon_for_each_target(t, ctx) {
>> +	damon_for_each_target_safe(t, next, ctx) {
>>  		if (ctx->ops.target_valid(t))
>> -			return false;
>> +			valid_target_exist = true;
>> +		else
>> +			damon_destroy_target(t, ctx);
>>  	}
>>  
>> +	if (valid_target_exist)
>> +		return false;
>> +
>>  	return true;
>>  }
>
> So, from the beginning part of the patch description, I understand your concern
> is the unnecessary function calls in kdamond_apply_schemes().  What about
> checking the target validness using ctx->ops.target_valid() and avoid going
> deeper if it is invalid?  Seems the damon_for_each_target() loop is a good
> point to do this.
>
> What do you think?

Excellent suggestion!  Moving the validity check to the
damon_for_each_target() loop via ctx->ops.target_valid() would indeed
prevent all unnecessary function calls, which is more efficient and
architecturally cleaner than my original approach. :)

I will implement this change shortly.

By the way, I'll add a "Suggested-by" tag to the commit message, if
that's okay with you.

Best Regards,
Enze

<...>

