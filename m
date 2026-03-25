Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4944EFEA82E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1636B0005; Wed, 25 Mar 2026 03:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81A56B008A; Wed, 25 Mar 2026 03:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BEA56B008C; Wed, 25 Mar 2026 03:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8106B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:36:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2158AC29FC
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:36:36 +0000 (UTC)
X-FDA: 84583777992.19.25D6B19
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf21.hostedemail.com (Postfix) with ESMTP id 307DE1C000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:36:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=cAlP9RBE;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf21.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774424194; a=rsa-sha256;
	cv=pass;
	b=8LsuwxuuZvhxHcci69H1j7vcrWfS6LYxhJZarKvd8Bzozbr++weUN/KpPrM6hBRBTlq6+l
	bZMAGeRBJuOhUD8XOxE+J564OwOyJfbg92f6TC3FMWDAFxOB8lg7joVzEJ0dOZZfIdgV/H
	UjzHRVq1Xs5l48syIKTQZo8rcPMNqfM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774424194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtUKY5DO0st46tC4ZDWh2PAEENO7whJpWxG4Ec9CYhc=;
	b=B3XbRiFQuN3WGW6mFWu5hv84bjmsJMoiMNJ/NgNt84shuMUCbvMVbZs6g05oBI/HFUdhrk
	jql7DcS7LrSqIP5VOCBOv/BBiuhEooHT9TwtUIT9NccFmT2rKbYHw2LFOSUAxzehu03Y77
	yUu+K3FQ2DRqhr4SdjrvFrynRfheLJI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=cAlP9RBE;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf21.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774424182; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=eE4I+XSjwIxjR7xH/5s8KFOt7C5SlpQhkRkYW/fXSDTdRKDplD8d9CUvFTsEPB+B+nA+pC/f9CmlN7WMRYBXrchY0p3kseFBOf5UY0G8w9IXCGkBBTGy4Ihqm6B+zYMP0ox4kz8wtZWBkwdHIpPejX4aeqwPmKbryuMWeJ6U8Bo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774424182; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=VtUKY5DO0st46tC4ZDWh2PAEENO7whJpWxG4Ec9CYhc=; 
	b=LrP4Ewm6BQ6LVCsZ8n/Te6p9k3inhkKWIlttMiIMaVngiwFVqI40zRWJl3JTsvNfKKgTXsIS678CnvTQNKk+K46vg5wRhllqS8CL1MMbW0mpQnU5EX5lUKPewv1T7lBHS40fmmoLJSNegbBTzo9JXsusD2R3nyeS523CwqgwV9M=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774424182;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=VtUKY5DO0st46tC4ZDWh2PAEENO7whJpWxG4Ec9CYhc=;
	b=cAlP9RBEsJ1x7tezSY/N1Jaqo9Km/1RnS2SW0lq7ksRbiB1sLpgSoRpw2NQdg6av
	f2AsfY8dD0gRRjINrXlWn7d45LLLGM816iD8lIsCXnWdUre5qYismt+mVv9ybOcY3wM
	cWhQIay8ZRDM2E3xxRENtF85B88Wim9wJw7pfRWY=
Received: by mx.zoho.eu with SMTPS id 1774424179714678.2530095985786;
	Wed, 25 Mar 2026 08:36:19 +0100 (CET)
Date: Wed, 25 Mar 2026 07:36:20 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=28sashiko_review=29_=5BPATC?=
 =?US-ASCII?Q?H=5D_mm/damon/core=3A_eliminate?=
 =?US-ASCII?Q?_hot-path_integer_division?=
 =?US-ASCII?Q?_in_damon=5Fmax=5Fnr=5Faccesses=28=29?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260325011653.85502-1-sj@kernel.org>
References:  <20260325011653.85502-1-sj@kernel.org>
Message-ID: <E4E214DB-E7C0-4B69-8DC2-2A9640BF5CC6@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 307DE1C000A
X-Stat-Signature: tz433xubo69ka6i6zk7an1wus4m71dcq
X-HE-Tag: 1774424193-21231
X-HE-Meta: U2FsdGVkX19L1LY9Rkph4eeIi0d42IGKSMfR0tb5CiR9++YnPr8Wd6x/HNb9Fx+GEAnug2EJd2tENjASm/7nfnRqlH7xJ/UNBsNmItZe6QLzfsyKvPB1xHEg3GQrnCWp+jd6bcUfuYh/PbdaU6UHOBn85yKqsV1VPy6U9t47l4HRo70EInY1dNfKi3DmOOI7fRhbjNsS4JZn7hqbUxK99rB7yzdVXCcraWcTU00VOyfOfXcB1zw+i4An6YfT91rm9tpkWVqRb3eiowSlE6quAf5hesRJg6yqF/7QaG1WfCcBxI7gGOMj/H0jqr4pvRXjQyqS4BpZHLeDshIoutbEUJDGmbDqOKG8b0aTMJYd7CpHHOgW9tQAco6KQ0yF0OkJCKubJjSIx3s67c3go8tzeOqLCfiEHz3g7AdRql1Y493CqdEz873EKTX2C+WYAgBVzdpRqkNVvIdU2FEqIWE5t242kW+Lvi1PMne0yoDIe3F7ugoP8Itg7KTa0BweRp7a8XCtw0hkT+uliIobwbC755gRRTLc9Ca6QJ7ncgFZFQHK3Nwd8eQ5wsbV9rOxN/+Lf84qzMEB4u+esnBDTUvkkSlrBIUADYpfbahUbAorOuc5ot6P0oY1AnFptVJPccXPURpk/Jo0ljUycFJMMrys31sbK9iQ93U2TOnVwPhfEfuIx1dk8RthGRIm21RYnd2QVZxqLH3sAr3kSxnpJOmXEkUN3LUtwntxUUNMwuyjT59KSCKMNBgcFhjFDA6HdOWF2wRq5mk1/OWRRGe7b5yo4Ri9vVkLdGJFQ/268kHnWzGY67xSe2twb7SEnlXCwtI4hMds5q+Hja2vfmOR9SMW4Nt5NXWcvgnQhGIAVs+xakeFD5hyuYA1J6siQkR1Eh7hEAINnolbP1hYmzIXL7fVrotu1Wwxu5kSMdb762h4xhTrlVT17ph1c3OyIQS2o0WuSEhVji3lQhrSgTbvDIO
 p/rYvsUV
 jjQ72XjHwWbotWpMrHV+R3ap7eDcJsqaBQvvzaoGiR9jocWA9eLBAubZkVdGie4ndtvEiCTjRQEPdnPRQupQyIGZlaeXxBtOZHMvMOJn8WZdRAcuenSHMA4ENoP9BPCzDoD7Nh6WEPhssNvMA+reyonOIcUjsxPgF8yKTPQyYNztpiJw4tbj63C8mpAK+OWQ2eWb3gTSRbcjRGGgQ6zog3cAejNMqRX8VVHwQ8SB6qRIaY5ISTWbeu73ya1POERPPdZaPLpKoPFv73NHWe4kUFxPZSt4S2Np3cNvAsMfPLkZNlTnPN0r/Q+7INoocVs4o0cY97f+BGW0pxsn1NqiwayWraI/ePy7WsR7SFCWNYysI3UVCK+YXds2vtqzJBxgYNOMAQ/+e8XxIebXg8zOtkJhuePN8oKPflK8IuAgnY4Yi7+Y3Ph7Q01rjVgw+FZWCaYpNOM7qnUC0xIXnBvYUMBxvDbgchfk0VAs5X74UQcis5+xGZW0dGQZZeIiQuWQG72SXaZdGjzqq6odCNc/EKdAMBs/3p8MiR1lfu3tFLAOx7ahgrpK7s2jPjU5D8v0P5HjIB0NWg0OTqDMsNvPE7D/RDvI82GaYKWYVx1Glw1CSUJ4jiuWCU4PhmjPqQIjdjK72/fy0sQcBAk82xzED8PSkJOwgNbQQm4gsp/axh98RI1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25 March 2026 01:16:52 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>Forwarding Sashiko review for doing discussions via mails=2E
>
># review url: https://sashiko=2Edev/#/patchset/20260324154005=2E83651-1-o=
bjecting@objecting=2Eorg
># start of sashiko=2Edev inline review
>commit ff5e227a18cd69435749b0aae0dc2c762c4f0a47
>Author: Josh Law <objecting@objecting=2Eorg>
>
>mm/damon/core: eliminate hot-path integer division in damon_max_nr_access=
es()
>   =20
>Hardware integer division is slow=2E The function damon_max_nr_accesses()=
,
>which is called very frequently, performs an integer division=2E
>However, the struct damon_attrs already caches this exact ratio in the
>internal field aggr_samples=2E We can eliminate the hardware division in
>the hot path by simply returning aggr_samples=2E
>
>> diff --git a/include/linux/damon=2Eh b/include/linux/damon=2Eh
>> index d9a3babbafc1=2E=2E04c8a052fcfb 100644
>> --- a/include/linux/damon=2Eh
>> +++ b/include/linux/damon=2Eh
>> @@ -978,8 +978,7 @@ static inline bool damon_target_has_pid(const struc=
t damon_ctx *ctx)
>>  static inline unsigned int damon_max_nr_accesses(const struct damon_at=
trs *attrs)
>>  {
>>  	/* {aggr,sample}_interval are unsigned long, hence could overflow */
>> -	return min(attrs->aggr_interval / attrs->sample_interval,
>> -			(unsigned long)UINT_MAX);
>> +	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
>>  }
>
>If an administrator dynamically updates aggr_interval via sysfs and commi=
ts
>the inputs, will attrs->aggr_samples be correctly recalculated?
>
>If aggr_samples becomes stale, kdamond_fn() will compute the real aggrega=
tion
>loop count and allow r->nr_accesses to increment up to the new bounds (fo=
r
>example, 80 loops)=2E Meanwhile, damon_max_nr_accesses() will return the
>stale aggr_samples cache (for example, 20)=2E
>
>When evaluating schemes, damon_hot_score() normalizes r->nr_accesses agai=
nst
>this stale maximum, producing a freq_subscore that severely exceeds
>DAMON_MAX_SUBSCORE=2E This causes the calculated hotness to exceed
>DAMOS_MAX_SCORE=2E
>
>For DAMOS_PAGEOUT actions used by damon_reclaim, damon_cold_score() retur=
ns
>DAMOS_MAX_SCORE - hotness, yielding a highly negative score=2E
>
>Could this negative score cause an out-of-bounds write on the
>kernel heap when used as an array index?
>
>mm/damon/core=2Ec:damos_walk() {
>    =2E=2E=2E
>    c->regions_score_histogram[score] +=3D damon_sz_region(r);
>    =2E=2E=2E
>}
>
>> diff --git a/mm/damon/core=2Ec b/mm/damon/core=2Ec
>> index db6c67e52d2b=2E=2Eafb058f7da5c 100644
>> --- a/mm/damon/core=2Ec
>> +++ b/mm/damon/core=2Ec
>> @@ -587,6 +587,7 @@ struct damon_ctx *damon_new_ctx(void)
>>  	ctx->attrs=2Esample_interval =3D 5 * 1000;
>>  	ctx->attrs=2Eaggr_interval =3D 100 * 1000;
>>  	ctx->attrs=2Eops_update_interval =3D 60 * 1000 * 1000;
>> +	ctx->attrs=2Eaggr_samples =3D 20;
>
>Since this value is cached here, but not updated when intervals change, d=
oes
>it remain permanently stale during dynamic updates?
>
>
># end of sashiko=2Edev inline review
># review url: https://sashiko=2Edev/#/patchset/20260324154005=2E83651-1-o=
bjecting@objecting=2Eorg
>#
># hkml [1] generated a draft of this mail=2E  It can be regenerated
># using below command:
>#
>#     hkml patch sashiko_dev --for_forwarding \
>#             20260324154005=2E83651-1-objecting@objecting=2Eorg
>#
># [1] https://github=2Ecom/sjp38/hackermail
>
>Sent using hkml (https://github=2Ecom/sjp38/hackermail)



So it's nacked? Or is it just a review

V/R


Josh Law

