Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC126CA0EE8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 00:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F448E0002; Sun, 14 Sep 2025 20:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F8F8E0001; Sun, 14 Sep 2025 20:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7A58E0002; Sun, 14 Sep 2025 20:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D04288E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 20:11:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C83FC0385
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:11:57 +0000 (UTC)
X-FDA: 83889556674.28.CAC3553
Received: from mail3-163.sinamail.sina.com.cn (mail3-163.sinamail.sina.com.cn [202.108.3.163])
	by imf09.hostedemail.com (Postfix) with ESMTP id B1A47140002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:11:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="BQuu1/Ua";
	spf=pass (imf09.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.163 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757895115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wZeKHLWAwfFq1meT4JSzn5DJcnCf93wpV/LX6CmoEk=;
	b=IC+d3BcydbKEDSfJiIevrjw85uDPsbq1R6mLOTGZz8nicJlcHNoFoSyn45Uz79ZYyDKr9d
	gfb0Z06BcO8ARLV9ZTYoquzz7RPqS4NOB/9XR05A4Pzz9xUS76ej80ZlaHOfIJsaFP0xYe
	SaTeYbhZOZOp4XmVZC/ASIWqG5HeHrg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="BQuu1/Ua";
	spf=pass (imf09.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.163 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757895115; a=rsa-sha256;
	cv=none;
	b=P7DowQEsNbCqwtiR9VDYOW+mBXej0vLpZHYqk8UScPLBereeYGRScslTCXyqRLP8shf1+m
	RkXo9K6qSTlpym+nJLe4b6ciYeSWa5WfG5t6TpHm6l/Cd8I08j/kXAFmGcmY5+GRbv8kcf
	10DPhUno3WUvIUoKnsDWtkVbGm4UftI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1757895115;
	bh=5wZeKHLWAwfFq1meT4JSzn5DJcnCf93wpV/LX6CmoEk=;
	h=From:Subject:Date:Message-ID;
	b=BQuu1/UabooQLnyAvj4TYTz7H3M55vNFUL1wtbQwgWOlikrwaBzgG8fHsnJK16Q4J
	 b9x+jgSlPyIFoaxZ5tedG8FQry/eITYR83kTb/XWN8RpsuBAviqTMqN5o+c0xqSDJy
	 WfzUj9+wS0666T5TZoQBjDRq5WJ4oPvjsXdysq1w=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.34) with ESMTP
	id 68C759C500006D5A; Mon, 15 Sep 2025 08:11:50 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 9332576292041
X-SMAIL-UIID: 82896157B1B5426AAAB2321325B5AA6B-20250915-081150-1
From: Hillf Danton <hdanton@sina.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
Date: Mon, 15 Sep 2025 08:11:37 +0800
Message-ID: <20250915001139.7101-1-hdanton@sina.com>
In-Reply-To: <bbdb72e1-ada9-44e2-9ec1-53fd6ed92e84@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1A47140002
X-Stat-Signature: awiihes4ibykpn8w9a9th8tfihekxhmo
X-HE-Tag: 1757895114-670379
X-HE-Meta: U2FsdGVkX1+z5CL19h0wSZTiM2V/MpOvcapP8oVt3uL5dNuOpBUO2tWHJXhADuis24gkC6nTD/rqgF8piOHFQv8BXdUvRRmBmKDfIoQGiEpE7z3kF6w5tByXl7YmWriuz6za6cxpd26M7Mi/eVOuzJCWQlkJy0SK/M4RZiWQeXVXECjObbZhkAd8lQr+fLeviF5SfRs8jmYCQIGZF2kdCA08nNAnFpEf+tZKd0/WKY8b31lRLEEwfGrWiaH/t1SM817HFxRgfkqudwbZWlfc9+PuPjGPGnq/KHq41iWG+Ptna6dAkipXEn7o+57cw8X/2KIELp0EgLHLbf3wm2ccBrj09OgxT9A2BtsqrygHYr2ka3849MbWeb+WD6Nxay9F1V0TwKlCDUdt2sMDZqEZkNGfoYm87TxocgQQv3MbI7i1yzOVwWmr6sIPxbza0OFlzNMdhvDFUlvBuREj2P4vyd4jio5ETALwjkhVjaO85MlnarulbAi8qpB6e5I7EZ7JOhS8hyRYbxoeljmo0mWrpDp41RSB6wJ2V1W1HYIq53Dk/6jczhLh9E2uuySlh4cdQT3KlBxIwqD4ssD+HKMguHC/lKo5e4bOamqkK9wv7inuKQm3HFICSOSSCvNmO/i1q/OBUQGS0qZmf8PhRyFqDpMip3zt6DKvcTVuQ9hwKoHAMvcQ1haOosN1z9TqjqNmwU5FIfAl/JmeljJWNBe9ikYnE02vvu5BpvochiL8a/lZh9KNFDDULovBXjw6I4XHPUwtqnEn3xdhzvCmSWsT9LmZK1GZwyi6de+TRV6ydkbLvfTfHe96uxXOFzUYmMQk1D1Iaq5FfKF9pfj0DK+zwjnlYEPmzcddipS7bxZSFVrZx2JsdruGkoJQ9EIGlRXeQy1HTdEeVhhVJFLMCeo8BI5HwuPRP8X+gVJg4LMdyiokISlSIZUyDfvjaralNd2Dtd+W0uIhqEYXraD1K95
 GL6dbWVq
 Qrv0cSR9gJ2fE1C6ris+ayLAIu9zlcQRJtFofz+S1bdUyjmwd3/fBDTS1EqOIlJJ+leQkOXNW/eiy/vx9IRysFS5WmLWpZa4SN3p2tC7M76x+hBJrksmkGTa7cscBBydOqrpIyJWldjgveaApDLt8FUhaUnmIZu4ezm+K/2HDUY2s0JyigrQB9OFGwbJ/5r7z62v/Xdr4il/2Tp+51jvwAEN8WsKJPjxE0Ksdx8UzlW7CtMGSdwhtwufqsXRFEN3uw1/vq31V30WY6DGcH5ItTFdCGMeeM9Utnh0NAMvx7X2972ZMYxfsrI25hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Sep 2025 22:24:19 +0200 Vlastimil Babka wrote:
>On 9/14/25 04:22, Hillf Danton wrote:
>> On Wed, 23 Jul 2025 15:34:34 +0200 Vlastimil Babka wrote:
>>> +
>>> +/*
>>> + * Caller needs to make sure migration is disabled in order to fully flush
>>> + * single cpu's sheaves
>>> + *
>> This misguides, see below for a workqueue case.
>> 
>>> + * must not be called from an irq
>>> + *
>>> + * flushing operations are rare so let's keep it simple and flush to slabs
>>> + * directly, skipping the barn
>>> + */
>>> +static void pcs_flush_all(struct kmem_cache *s)
>>> +{
>>> +	struct slub_percpu_sheaves *pcs;
>>> +	struct slab_sheaf *spare;
>>> +
>>> +	local_lock(&s->cpu_sheaves->lock);
>>> +	pcs = this_cpu_ptr(s->cpu_sheaves);
>>> +
>>> +	spare = pcs->spare;
>>> +	pcs->spare = NULL;
>>> +
>>> +	local_unlock(&s->cpu_sheaves->lock);
>>> +
>>> +	if (spare) {
>>> +		sheaf_flush_unused(s, spare);
>>> +		free_empty_sheaf(s, spare);
>>> +	}
>>> +
>>> +	sheaf_flush_main(s);
>>> +}
>>> +
>>> @@ -3326,30 +3755,18 @@ struct slub_flush_work {
>>>  static void flush_cpu_slab(struct work_struct *w)
>>>  {
>>>  	struct kmem_cache *s;
>>> -	struct kmem_cache_cpu *c;
>>>  	struct slub_flush_work *sfw;
>>>  
>>>  	sfw = container_of(w, struct slub_flush_work, work);
>>>  
>>>  	s = sfw->s;
>>> -	c = this_cpu_ptr(s->cpu_slab);
>>>  
>>> -	if (c->slab)
>>> -		flush_slab(s, c);
>>> +	if (s->cpu_sheaves)
>>> +		pcs_flush_all(s);
>>>  
>> Migration is not disabled.
>
> Can you elaborate how it's not? There's a comment above the function saying
> "Called from CPU work handler with migration disabled." and we have relied
> on this before sheaves. queue_work_on() says it will run on the specific
> cpu. AFAIK the workqueue workers are bound which is effectively disabled
> migration (we hold the cpu hotplug lock).
>
CPU affinity and migration_disable() are two different things regardless of
queue_work_on(), no?
I think you are right in accident rather than by design in this case.

