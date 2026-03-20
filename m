Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31E61098783
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA4F6B008C; Fri, 20 Mar 2026 09:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AAE36B0092; Fri, 20 Mar 2026 09:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A1B6B0093; Fri, 20 Mar 2026 09:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 081346B008C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:21:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0285139C6F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:21:05 +0000 (UTC)
X-FDA: 84566502090.15.AE9E8DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8C049A0013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:21:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XoytTdBx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774012863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwD2H1blMerUvhMy/76G3McoXreULE4NsdLlLVu3Q6U=;
	b=OMnloC2DGBmTsYAkExcjf5mYYucue1Ew3iR7oM8QqBBTUUNPIRPnnhL7JYBqSUtGMVAkM5
	sHU7Ac9G7ZkUm7aHevkmncdpfbJKird9Kil+iNPqWtISyVrdNfNuGc4ltsBn42MI4lYooV
	mCaWVX5BvSan+1q/rOJH4NE557C6NbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774012863; a=rsa-sha256;
	cv=none;
	b=VDNgJzZKKiE8JRXamXUOnqc9bmZe+fYXHhXS4DKb/zPfiiwIGN65DeV4qnEFv87ly/X+Ov
	xd0ODGXJOuYY5xBUxPPocUi96MWb3bmP0n/Ro5/gQA0UTmNu7K91+nVAna4BnBtWksvOmi
	CZ0JurmqMh5sXM8EXVu1dXcJtVacjTY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XoytTdBx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774012862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwD2H1blMerUvhMy/76G3McoXreULE4NsdLlLVu3Q6U=;
	b=XoytTdBx+a7wBMrCamoK6pWQ/3EEj4ALjcFXsKWeeuKArHO29DCKkOL+V0lUbhA+3l55fR
	imLHC9zqIYxY03QLvXr7bdwtU7uLj9H6tM8cQ6dFPIe9I2bF0szmK/bu5RM1563/GDFaz1
	g29bK6b/4sC0+A23JLmGgJazt8+7cSE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-ly8YZw-uNNerG81pJWhkkw-1; Fri,
 20 Mar 2026 09:20:57 -0400
X-MC-Unique: ly8YZw-uNNerG81pJWhkkw-1
X-Mimecast-MFC-AGG-ID: ly8YZw-uNNerG81pJWhkkw_1774012855
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 740061956048;
	Fri, 20 Mar 2026 13:20:54 +0000 (UTC)
Received: from [10.22.65.139] (unknown [10.22.65.139])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C025430002DF;
	Fri, 20 Mar 2026 13:20:50 +0000 (UTC)
Message-ID: <46d79476-39ea-4f0a-9739-56970d0cc2a2@redhat.com>
Date: Fri, 20 Mar 2026 09:20:49 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] memcg: Scale down MEMCG_CHARGE_BATCH with increase in
 PAGE_SIZE
To: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 Sebastian Chlad <sebastianchlad@gmail.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
 <20260319173752.1472864-3-longman@redhat.com> <ab0u0XCi9xBefrhJ@redhat.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <ab0u0XCi9xBefrhJ@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: nxlwX54XBJ-h499ubXA5DZBhZsh5D2ivTYAz7Kibf5A_1774012855
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C049A0013
X-Stat-Signature: ywwx6kphnbuf3mocib8rcos55zrz7dq4
X-Rspam-User: 
X-HE-Tag: 1774012863-738427
X-HE-Meta: U2FsdGVkX18vC5nzqtFGxl3AamrI77fKLtBqCMlGW+e0h7tJmCXZdXmbvySDTYnukzQn0zbxXPW7qaib2JdroU2dPOsOPLKuO4E7300eKQwL42UpsSCB7iN9gPezDDtCaVKdfqh+ZjHWlcKpQ28K4ALjGHqOiKRQWmjZlzQgEaB4KuKpHpYJOoNW3QSLg185pRtrqgjSgJAhjUSZZh3GV58ZmTZPeidPPAXkyqQ63XeEwMi/L5ZSAPK0JOZNLIO32u1B+N8Dok1B0+dri2ur3g44zLK9IoabHkMl1msFmOgsA/D+trpwxxxLHQ7cwXEL0jzC9CgaEsSdWV3mt4uK5R5s4RR8eN9nx3wlGM6bXlKKazLr/ajWPfV00VU3oHVDINEBmEhPmyOXXjR/g0iqjwboModASMpxwv1w+oySkicCfthlI5azWGid3Y3k/kncMRwuOqBPiS3vY0kkhcGDrMow53yw9G4QgelZMkkQVt6SfX31BpK+gbwZTWrwJv6zUPY3tQPFjVzm/8f3D+1Tng293VWYMTOcSWT2gSrG0wsxKwJOzXZMWX8gzDz2lTAohSIj+dlcOM6V9Hf2Cmk5TDKepH//bBP8pdDuTJeFGH5213kY2qjse35kcwoUaXU0xrb55/p/rCiMTeROSx72HfeRffIulgNls5hXlXTBfxW5NRdQTYRToGewMGp4pVjzSPtsZ5Eh7mjKo/c7wRhnEEPz/XNw34+b2U6MzrrR12uxnmzR/fctIk2fJAQr2dJqWpHT3301UUpHI0mECFlPPJxn2ujWLqdb1d+rrheclk771mYZUx7XRC8EQ8s5RRyLhKdnJyf4HrQVb6z+dO8HyRISVlvxScqRPnKwQm/v1FED5Oda/7JIerMEmmtNa2gUDsLKaPmDtsnL5TYusCtzigEWWBDC4NV8pojm3JrlPPRttV406ax9FmGKGrCkqCPX2GiN2tVMHGO1TtdY8Vw
 nECYExeV
 fzqh4jOaoUX/0Lkugg+msiW1h9vgNqpkcuU8udxDDNAv9LqdEcz6JIxIqSoHXOSvBYYwgLiPlPYmD8kBXrpc6jmSwVrnysvZXiDkxSOVUSzDTLaI+lsJOLpaRH7Tx35Z6euPZZkk585wDED62Z4PEaHuKbSwVrBobimK7T/8rigXiYoNnHQIMXirWfLivgy9xXrDEUPvnSGJWkNe1zVMnTtAFhxoKxv9Rh+/GQJO9dB82poUyk2yyycpjqdIxbEiZZt/7nJqqmbalFDwLFF929HvdmRxPl5XzTEtuI18zaVsFcbgFJMU+1+2hhDCU9U7YpJSzI768e3RYNVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 7:26 AM, Li Wang wrote:
> Waiman Long wrote:
>
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -328,8 +328,14 @@ struct mem_cgroup {
>>    * size of first charge trial.
>>    * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
>>    * workload.
>> + *
>> + * There are 3 common base page sizes - 4k, 16k & 64k. In order to limit the
>> + * amount of memory that can be hidden in each percpu memcg_stock for a given
>> + * memcg, we scale down MEMCG_CHARGE_BATCH by 2 for 16k and 4 for 64k.
>>    */
>> -#define MEMCG_CHARGE_BATCH 64U
>> +#define MEMCG_CHARGE_BATCH_BASE  64U
>> +#define MEMCG_CHARGE_BATCH_SHIFT ((PAGE_SHIFT <= 16) ? (PAGE_SHIFT - 12)/2 : 2)
>> +#define MEMCG_CHARGE_BATCH	 (MEMCG_CHARGE_BATCH_BASE >> MEMCG_CHARGE_BATCH_SHIFT)
> This is a good complement to the first patch. With this change,
> I got a chart to compare the three methods (linear, log2, sqrt)
> in the count threshold:
>
> 4k page size (BATCH=64):
>    
>    CPUs    linear    log2     sqrt
>    --------------------------------
>    1       256KB     256KB    256KB
>    8       2MB       1MB      512KB
>    128     32MB      2MB      2.75MB
>    1024    256MB     2.75MB   8MB
> 	
> 64k page size (BATCH=16):
>
>    CPUs    linear    log2     sqrt
>    -------------------------------
>    1       1MB       1MB      1MB
>    8       8MB       4MB      2MB
>    128     128MB     8MB      11MB
>    1024    1GB       11MB     32MB
>
>
> Both are huge improvements.
>
> log2 flushes more aggressively on large systems, which gives more accurate
> stats but at the cost of more frequent synchronous flushes.
>
> sqrt is more conservative, still a massive reduction from linear but gives
> more breathing room on large systems, which may be better for performance.
>
> I would leave this choice to you, Waiman, and the data is for reference.
>
I think it is a good idea to use the int_sqrt() function and I will use 
it in the next version.

Cheers,
Longman


