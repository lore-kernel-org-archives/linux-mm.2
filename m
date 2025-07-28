Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D841C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 11:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1036B0092; Mon, 28 Jul 2025 07:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9885D6B0093; Mon, 28 Jul 2025 07:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4F36B0095; Mon, 28 Jul 2025 07:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1BB6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:29:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EACA6111CDE
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:29:36 +0000 (UTC)
X-FDA: 83713453152.01.57F7D41
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98DAE12000B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:29:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=uCncNpE5;
	spf=pass (imf29.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753702175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJKiJr+tG3FAfmMlaEVSvdKXkB/PgPhRU4B/I5SDZaA=;
	b=Zxy7kSVSfAvkZD+FF09v9uLvQi4km8Z5JYnxQQvmvezALrVF8mCSAiRVWMW5fjCgbnbFMZ
	R5KfP8OAh0BP8ru9ubBNbfXOiDRXaakIwH8VggGGFwNgXlnSivrBXM07gK6bRg71sDL6iA
	JIavESEQNDDxgCc2a3h5prCkMPsZpxY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=uCncNpE5;
	spf=pass (imf29.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753702175; a=rsa-sha256;
	cv=none;
	b=C2Jqg9NkoYcS8zNxN6RV3E3Nol2XrZiBxAdTnMTMZExRilB6Vy1BG/Z/T/dD8wPvCitObI
	OMXaojL/IlI/Wl9NjXAQLEXo/FBmEeorxwz55sEe4dhvumIgOdPl1Vns1Y/7LVoX3nb2qV
	MGE601NmYZti1RyoZ/BNX1RHhDuWMUs=
DKIM-Signature: a=rsa-sha256; t=1753702172; x=1754306972; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=KJKiJr+tG3FAfmMlaEVSvdKXkB/PgPhRU4B/I5SDZaA=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=uCncNpE5DBkvi37xKEm0B4brCr3ocRD9YpR8NsqYGHOp/DWBSdq7t2hBLNOH7W045BZKntLrkz22QSN9BYkBQGTe6d0h8wRA/4MiZwz6nEJthP3FmCtMKvdu9+3Y0XxOadrVV7RoK+3GILChS2HiEuOo0FKmYAH2+Xzr8QnI6R0=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202507281329311901;
        Mon, 28 Jul 2025 13:29:31 +0200
Message-ID: <924a8a12-ed89-45e5-900d-6d937108ec3e@cdn77.com>
Date: Mon, 28 Jul 2025 13:29:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Tejun Heo <tj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
 <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
 <yruvlyxyy6gsrf2hhtyja5hqnxi2fmdqr63twzxpjrxgffov32@l7gqvdxijs5c>
 <878ca484-a045-4abb-a5bd-7d5ae82607de@cdn77.com>
 <irvyenjca4czrxfew4c7nc23luo5ybgdw3lquq7aoadmhmfu6h@h4mx532ls26h>
 <486bfabc-386c-4fdc-8903-d56ce207951f@cdn77.com>
 <aILTi2-iZ1ge3D8n@slm.duckdns.org>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <aILTi2-iZ1ge3D8n@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A002110.68875ED5.0034,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspam-User: 
X-Rspamd-Queue-Id: 98DAE12000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 1wxbesbzoiyh1skwh8ofyta85fnjhq4x
X-HE-Tag: 1753702174-534988
X-HE-Meta: U2FsdGVkX1/VZrOztgm/PHiKVXv4WuwpNWckFD8uX0k3ZcdaoewuPl+4NK9AF61NMgxUEu+9rsydiwhuy0Zxr7VwG299sWih23y028P07UUra382OuOaQNOLnLYeR9Ce3iejV4LkhqJU+JMa6D3TPdj42lkMk9Se7PQnAW+1K/dR4dtPgy5O6m5Zz7MVw5wF9kOJsaL59zOwqa8l6kw5kDUhZh9Yw8EW6D8EVZ5BHa/WXSGqnjIrxDgRRH4IhEXOe7bvcXFZx4kV+5OlMUgk0AShJcP8ug4tq7UTGpKg1+SFbeVBBohBVT0NhfMLOn0KAqbVBc1zfgBiBYxstY2uFQTl9/B9v43sQAtxuKhH86BE1DYSX+rklQRnjJOivOALoRfd/V4nq2er5H8QhJ6q+XdHl9a3Wvr5alpPX/qCB0n06nx+qdfzAwmHmxV6+ZsBMw86Amr6XRP0Aw48iM/n3LgFgg7JwsLx0RJPtVtdt6KwIHYuseYWw9ah0BUyfYf+dI6hsXIXs+mqTIODP7rNaBL/5fbdaTeR30ezYX0z7mk4tgjgnqy57rLW4qVfjetQ88M+QBbkukQXSOKpZkg3A3c7IF/6R26CxlDyfJKVXyDYE/FORMcKVqjyOqLRaFARBYw/PBLlTNgrGpL19cL0iWwdvhQGrZg+OlPJQ7NUb9GxggKrqHcQNXUdNI51x3d7e+zsKoCnXSG5wL61aEtSAU2/Q0QImy9y1obWVESde+N5+IP71XHQ7SsxzkIEarubGQA3mieQq7mRmf8TOUP8jPmVS6K1qGx6hlKk9eeUeG+O+n/ataAcXKCOAJQbNSbOnKAxrwhp7M9DrJBN94DnSg2akzLjWUZQEj7UJa9LBhLo7vMJJ8HqbjhXFQHr4A0gtMZ5IWXTgC5APLOkl+a4w+k+b5nClbxKnWsaTEeIm+BAN46wJju6KFCGM92Eh5+uHyYTveukSP5HDcUTfah
 wmvcX2+4
 6eXv1vR89nFzXRrI3CACHsRGCXvtH5XYZdViTR2CgFfeSFHX59T/m8YgeEpzQgQv7faKJURznaR5M4+7ihdSRnuj9diq6XPgFOwfBEW3Itfbi+8hcrKOVkRvWhbTScq1TliS92LYc/ZE4Rnep03NKrVpsgqNIN+kvUvpx775ob73T9yzPpGkaQk+y5LntBFQv6HvQ0lQO4ZdK5RbzAgqM0v3N/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/25 2:44 AM, Tejun Heo wrote:
> On Thu, Jul 24, 2025 at 10:43:27AM +0200, Daniel Sedlak wrote:
> ...
>> Currently, we know the following information:
>>
>> - we know when the pressure starts
>> - and we know when the pressure ends if not rearmed (start time + HZ)
>>
>>  From that, we should be able to calculate a similar triplet to the pressure
>> endpoints in the cgroups (cpu|io|memory|irq).pressure. That is, how much %
>> of time on average was spent under pressure for avg10, avg60, avg300 i.e.
>> average pressure over the past 10 seconds, 60 seconds, and 300 seconds,
>> respectively. (+ total time spent under pressure)
> 
> Let's just add the cumulative duration that socket pressure was present.
> 
> Thanks.
> 

Ok, I will send it as v4, if no other objections are made. In which 
units the duration should be? Milliseconds? It can also be microseconds, 
which are now used in (cpu|io|memory|irq).pressure files.

Thanks!
Daniel

