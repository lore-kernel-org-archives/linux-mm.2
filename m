Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2E6606A33D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GbC2K//K
Received: by kanga.kvack.org (Postfix)
	id 96E126B05B9; Tue,  3 Nov 2026 10:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F656B05BA; Tue,  3 Nov 2026 10:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835C56B05BD; Tue,  3 Nov 2026 10:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6205F6B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:14:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03C2940467
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:14:03 +0000 (UTC)
X-FDA: 85394153208.03.C53AED1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id C3BF21C000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:14:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GbC2K//K";
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718842;
	b=lvqgCJTYKkQjJ9m0u/xg5eBjfGwAs5OecxClV0W6j2NWP56t0vBMkviKWexjDOFAzeI8nt
	0IreRWk8sxEMDiHsOv0bq7Uyx3pv4+efV72X63PKtBXuYaNS/TiqK0zMRv3bcJHtgQ5eab
	m+kcKldgkMtZ/SHTGq5fRc4+3PBH6Pk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GbC2K//K";
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=In5hDuKiBdou1zv+joOPBenp7vdBADvUYuAlqVBsoTA=;
	b=s+3JZdgGifWTq1qBaqiYNA0dNoFiDTsJp3ab6L4Jv6mlOnWsZ3/Y5dySgeLOIamxV3POdJ
	yM9/Lyb1fJ2n+FCpbhlF5nrHLv4HrkTfU4RPKdB5iwS9DgWdJU1J/CZDRP8Vk8FdW6tuqA
	J75hJ7gU2PDWM0JzBMJvI5EoiucmXDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793718841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=In5hDuKiBdou1zv+joOPBenp7vdBADvUYuAlqVBsoTA=;
	b=GbC2K//K1lT6scurzeuOu76aHSkhwX7ccuTW+v5hh4/n9v6aOaaFbfuoj0tc0Ig8Za/Vrj
	Mh+pple2VROj06bl40WxTPw4b7rYacAHLleOQF82PYExGHgR7TNAJO8VxYt9hVlcEeStie
	CapbWLNWOdTgDlgu7EtJhpzngu5iHwo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-8_7V8QBKPBibu_MNcB0H3Q-1; Tue,
 03 Nov 2026 10:13:56 -0500
X-MC-Unique: 8_7V8QBKPBibu_MNcB0H3Q-1
X-Mimecast-MFC-AGG-ID: 8_7V8QBKPBibu_MNcB0H3Q_1793718826
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37FD5180065E;
	Tue,  3 Nov 2026 15:13:45 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF564195608C;
	Tue,  3 Nov 2026 15:13:39 +0000 (UTC)
Message-ID: <c9b24dd9-8c6a-4d35-8f68-07274f06299d@redhat.com>
Date: Tue, 3 Nov 2026 10:13:38 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] kthread: Keep unbound kthreads off nohz_full CPUs
To: Frederic Weisbecker <frederic@kernel.org>,
 Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Caron Wills <caron.wills@pulsar.com>,
 Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 Jay Vosburgh <jay.vosburgh@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-3-matthew.ruffell@canonical.com>
 <aunpNqPV38FG94-f@localhost.localdomain>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <aunpNqPV38FG94-f@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: lsVoFtRjUs_wI0Xg5GK2XLomwSdKA6Vo5vYilfTI6LY_1793718826
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ncsqnqqssub318bsud6tnizobd6pb54z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3BF21C000D
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793718841-205797
X-HE-Meta: U2FsdGVkX1/n8mEkVsjBJovUnnO7tvjdGoEpkTCkLBqo8jZCrNRoUrnpBJRGfJC7eETlUpUYn0s7ZNiT6syHwboOmpU1mI1QVhMda+NVcC4JeCPKqo0801R6dtZp55MzcQjb75/Cu0aJqw/Iq/mzC1dNetleaNpIYzSjAwTEs5v/ykxRuG74DApg/3cjtdgQEzz3Fb3dN2oeDEJYa15pOTrZAYmpVMZ3tY+pLDHNFLA0xUbtSC+dAXVF/Gv/gEqD+J4ev+rWdsaJdpY3NUK86ofvPwHpx59ws0ZX8yRdqvGU/+kZTF7yf1sQshhhiELq1nJKLjfapwl8xGVjgBNQ34vK65GwhcwANL6oC0lp70RcXvMNrer5ozY5vozQdj6VSQEd69adSW7ywyRXdSIxd69pWECmvYntHFeSAHZ3WlyfqsLMj138w8bIQmoV6WeKZfEvTKujkGddPmsjEQFmZh3F/N9kXjlUqDNal0Rj4dPjsqrDFbsImAJU0J+ELA8KzP3GdR3BStRGN9Du5CJ+y3dE1wP9irOb4/7Wm2y+g5vSknUa76DJVYhAyZe4/Pti7Fq7s4UPc2BkshJ2/xyOk+8ynVYOY/Rspkpvaf0kEQGcy7q4w6PbBmDtlY4MWAFU17jYwjQBf9qaQGXy7kkfCXSKjad+X+W68maQ6p6gFnXxF4dEQrGbeVDlCgcRIdQD+U2L7lWiOTAuhAX42bQcEf+iVQV/l9jfkYHnZgMG/ZtrBkj0VzDzxrszshjynCQcrFTjC24NbEFIpm1K3bytnMNRfGjS9/ZovRnULD94uYaPRnrUPtJeNkQyO5aU/9GfeYNw3CusckikaoVD6AeBxKs4/t+sRtO5uq7q8RyZmkHPGrDeURlCdHngi5ed3LiWMYXpXzR2vgN77DYlXS0IIiUdHfcNBaFUDsglsQJmwBOFGkm2WW5lCBpr7leoNpdf6zwTn9EIj4IKc25+oy4
 XqcfY28R
 ihurB5ZtNFzH9jTcI9h6/h7XfFjUqNixfaEew9zTC1NtaE5pLog3Ee3vvh6nNTCezTcA5XEiW6x+IYyC1cQoWZHMMb4nLHuuP+bHnqOChag4C2lmElgBUAnO3AqgePTn53oP1vOBjhiuM0sIUfdPwViIBknHktFjNjJCBLBptnx0VZ8eGlU4lvQc1p8yxvgjX7pLD1F5qQ9Jz2qtXA0zsYjZuPpZPS2uoqWMqSBB9J1HsjbvvCoqlAI8vvTBltvF2M9AW5SYfiKn7v8iKybxsffmWmSHsij+V8hXTJD24kR/rL0eA83Ufje0G0VPCI5WrZPOOQuZlNX5S2XeiU0Tz83n0bQSImmLtChWuXn/pR1+FxJ1q97g8uAPC5RixU6RDLzF8/4Go75hb1JZH7DE5EWNz1eBVl11EuetsOCweYgbq7hvcAscghRtZ01qX6xv+ptQ+rl21cmZJf2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 9:01 AM, Frederic Weisbecker wrote:
> Le Tue, Nov 03, 2026 at 08:59:36PM +1300, Matthew Ruffell a écrit :
>> From: Caron Wills <caron.wills@pulsar.com>
>>
>> Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for
>> preferred affinity management") kthread_fetch_affinity() only removes
>> domain isolated CPUs from a kthread's affinity, assuming that nohz_full
>> CPUs are always domain isolated as well. Up to v6.13 every kthread
>> inherited kthreadd's affinity to housekeeping_cpumask(HK_TYPE_KTHREAD),
>> and from v6.14 the preferred affinity was filtered with HK_TYPE_KTHREAD,
>> so nohz_full CPUs were always excluded.
> This was done on purpose because on all setup we have met so far, it didn't
> make sense to run nohz_full with load balancing. After all the point is to
> run a pinned single task on a single CPU. We have seen too many misconfigured
> CPU isolation workloads due to that constraint not being enforced since the
> origins.
>
> I'm open to counter-arguments of course but you better have a good case.

I do see configurations where nohz_full/managed_irq CPUs are set at boot 
time without isolcpus=domain. But these nohz_full CPUs are there as a 
backup in case some latency critical workloads need a set of fully 
isolated CPUs to run on. Right now, isolcpus=domain can be set 
dynamically by using the cpuset isolated partition feature and they will 
be used when the need arises.

Matthew, is it possible for users to adapt their workloads to 
dynamically domain-isolated the CPUs before running RT tasks on them?

Cheers,
Longman


