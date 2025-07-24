Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02921C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841126B0124; Thu, 24 Jul 2025 04:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F12A6B0128; Thu, 24 Jul 2025 04:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706D26B012C; Thu, 24 Jul 2025 04:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FFA26B0124
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:43:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E7FF140291
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:43:37 +0000 (UTC)
X-FDA: 83698519674.11.A8F4952
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf22.hostedemail.com (Postfix) with ESMTP id B819DC0007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:43:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=GwYRcO66;
	spf=pass (imf22.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geAcx1eFOfV1oq+qHzGfEHmoIVgBNQw8Y2UCNcB7q8Y=;
	b=AktDhoCNS8a/sRstlthc4r3bPrqNOxuEZQoSVSFhL0JhvdxlbiZUyrFLgmfIeFm3FU65vA
	tsNmsPAI0GNOUPKooOJAO9ouJLLZV/SfZCXmT5951sI//o0AFAFwAsm041iwxRE7ZHXWSn
	UsJqojbyo95eqQXILnuGDiPWfAKpW0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753346615; a=rsa-sha256;
	cv=none;
	b=j9nTbdgrkTxQxFhIGH8OGLg8g37Vpmd8mqQw6oR+F87EXLEO0BdpP0UdjV2NpiHdGnUgMT
	Uetzr6gkJSt3j5/jcmxDTS3+G37NEeG5NQFq+RXFFn/tpwPlG92lsi67+NUBr8zi3V/J+V
	CrfCm7PmdyY08tdy/JQArIb/GKh4xqU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=GwYRcO66;
	spf=pass (imf22.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
DKIM-Signature: a=rsa-sha256; t=1753346609; x=1753951409; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=geAcx1eFOfV1oq+qHzGfEHmoIVgBNQw8Y2UCNcB7q8Y=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=GwYRcO66cYM17QJ4JfNy0O/lJ4eIaR1dF/xVS4Df72l/0VV5LUIGJ67WQAn4K897TWePZsM5FjR8godG4FWcl/J//z+Y7632b7H/0WFzwpcPYDHs1c6Jr7gmqwEz45lZdBxIvkBDBUoycdVmzZgdcTTou7SkJE7AqA484NoN33Q=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202507241043284798;
        Thu, 24 Jul 2025 10:43:28 +0200
Message-ID: <486bfabc-386c-4fdc-8903-d56ce207951f@cdn77.com>
Date: Thu, 24 Jul 2025 10:43:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
 <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
 <yruvlyxyy6gsrf2hhtyja5hqnxi2fmdqr63twzxpjrxgffov32@l7gqvdxijs5c>
 <878ca484-a045-4abb-a5bd-7d5ae82607de@cdn77.com>
 <irvyenjca4czrxfew4c7nc23luo5ybgdw3lquq7aoadmhmfu6h@h4mx532ls26h>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <irvyenjca4czrxfew4c7nc23luo5ybgdw3lquq7aoadmhmfu6h@h4mx532ls26h>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A00210E.6881F1B5.00A4,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B819DC0007
X-Stat-Signature: af89pcqrm9596wwpduj9iw7siaobh1gp
X-Rspam-User: 
X-HE-Tag: 1753346614-116413
X-HE-Meta: U2FsdGVkX1+IDp9AGgJUecoaCUPqCnE9NW4pBOgzU79QT4J9KPLNvaKZgsMtaiTz/eGMBslU3JDks4soImvU+Gt8Vf/0fGIJM/LEfjJqBZoyBo1tJ8qxEg+6lFtC7fTE6KFRBhzqjkzMfKwrP40Omd9QvsXnYZX5eOgrgyw2ME7dIjTy3Uv4M6Zi6p77Z+jLo3RB+CMsfWJ8+OLa276WloavQbd6+Sqdz/5VPL1VicGHacBRpbv0xFmbgZel46Bq8KAwlH3YGW0uhdHrS190SXUdofa/tJ6aK4minNoyKhQSx56GeYHZQdKjeUrW9IS3IuF8NXVwN3MsYjRAuVrstiLZaGctgACk/Uf70WODblZ0flmoa1sfR+Ow8yH1xkJDuXt4Doje1VTPpWmgt+XgV6OfRYPFoa5CFM54Ylcm955KCox58r0o5m5Poxb38DyytxZKj9w+e1IAnHuCmLyVJI2qvdwSAQUS9EKgjcm8i5Y4Ls81vBj8aQxzwoNovQbMylRLR9Ip0ohpfF6gemFVqYn/ewViDcNuQoK6NXrYWN6K19Ipd7TmbL9rZPZTLj+K+SLO2o2IGV9IksLK9lCTRrjb83PJ7VUI4ZILiSWwj4nVc/yfFoB69PbiTithKMriVDWMGKfM7mwDalMb096n2hza/lZQkD3NeeFhGJh1VER/ed6jE247wtOVq3+eL53GLjlkKFoxlfpB5FFjcV4hdcrids3xnrCrHvwUk4yRcY0wzVwNDyUjq/PWFuqMGU2oMfiISLtyw0CZnyfI1h03AUt2pHIKT5kMNmpP8HD8SveFAO8vB7STRiGIZnIEiERVKNv4+TJIRWTk//f7aQGnDXz9rsp2SpRU3b5UOjcyg372zn9TIdpIUqDpYS1ojGreVnOT7/QVb4EpG6jtYvh28it36iPxB4kBllmd439eeJSRHlUNSDVGaofGtUGnGT7s74UbItz9JrDGfZ36hvt
 8uvL2Nc3
 cnpnREVeRSwXET0QqrKj5Rycqr4a/L0FyXqBvWRYSk7DRly8UabUWpE0nULswwy9E4qsHNVskkk+UtK25N6C97hUAN7ZQS6icDnZZGisCdjqRIyf5stmijfmm7XKM/Zx1JTZga3C5YkzQGpY7dGssYPAcCeB+0sutp9dNXjOdLyWjpr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 7:54 PM, Shakeel Butt wrote:
>>
>> To me, introducing the new PSI for sockets (like for CPU, IO, memory), would
>> be slightly better than cumulative counter because PSI can have the timing
>> information without frequent periodic scrapes. So it may help with live
>> debugs.
> 
> How would this PSI for sockets work? What would be the entry and exit
> points?
> 
Currently, we know the following information:

- we know when the pressure starts
- and we know when the pressure ends if not rearmed (start time + HZ)

 From that, we should be able to calculate a similar triplet to the 
pressure endpoints in the cgroups (cpu|io|memory|irq).pressure. That is, 
how much % of time on average was spent under pressure for avg10, avg60, 
avg300 i.e. average pressure over the past 10 seconds, 60 seconds, and 
300 seconds, respectively. (+ total time spent under pressure)

For example, if we had pressure for 5 seconds straight, then the output 
of socket.pressure could be:

	full avg10=50.00 avg60=8.33 avg300=1.66 total=77777

Do you think this would be feasible? If so, I can try to send it as v4.

Thanks!
Daniel

