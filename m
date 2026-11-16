Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739E6606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=YN+UxTus
Received: by kanga.kvack.org (Postfix)
	id 973216B05B1; Mon, 16 Nov 2026 01:20:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924246B05B2; Mon, 16 Nov 2026 01:20:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839BA6B05B3; Mon, 16 Nov 2026 01:20:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F80C6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:20:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E101EA8625
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:20:29 +0000 (UTC)
X-FDA: 85439982978.26.7E8333A
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8019A1C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:20:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YN+UxTus;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794810028;
	b=yi2mcHerVuMaTND4lVZHDZGHEK9X8vUrzrUOy2l5evX6u5axQm/1y3CTVVB7ll2+zV474y
	DfVMQF8eChs5geDOxSJo8JYzaIVwvbk29ZtY/YFjuBBlUfFudeTuqG66Gqj/xhIwPKmkwQ
	KAZSKl/igfRablg6RvWGPkalMtUWvh8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YN+UxTus;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794810028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXwpyzmDetXMHPbJA1yBOUj/cgWMyZE8y7vvNj5MTqk=;
	b=f99/XQjvz9aLlIbn3rIvTOB4tznUP2abMYnbIZMMPtD2/QQZ/hcspVWnlETS/1YrrezxR5
	BN2y+GnbMgbZZhVqZoYMwTvNKOEGkaKtYAmgGoyJyYhr3r9IMB33S1gxtVSIWG8BQOora/
	YIwfl+zT4DtIEHsqiy1qSlEQfSs7hjo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794810022; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OXwpyzmDetXMHPbJA1yBOUj/cgWMyZE8y7vvNj5MTqk=;
	b=YN+UxTusbzIZhoTcnbBCGedZH0ri/mnFT7x6OHMpJAX5kBd30XGrDxOWVLANebU4pL+oBVKkJwYAjduUDdlDcgE9quKUIQR4w6tdNIN2xTJrBauHKxKhD2TNy+vzKO+BmmetbV1CEef3hw+6TXL89Y1Kz9imwfchD2AK7c4iIRg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEmta3P_1794810020;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEmta3P_1794810020 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Nov 2026 14:20:21 +0800
Message-ID: <df6c54d5-be85-4818-a95c-5cb6686ec336@linux.alibaba.com>
Date: Mon, 16 Nov 2026 14:20:20 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
To: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev,
 =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 Zi Yan <ziy@nvidia.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <sashiko-outbox-212974@kernel.org>
 <5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org>
 <20261113094954.942014a255165efc812fb2a5@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261113094954.942014a255165efc812fb2a5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8019A1C0004
X-Stat-Signature: 3ubckig8wn31phenfwx3dq4pz74c5861
X-Rspam-User: 
X-HE-Tag: 1794810026-808793
X-HE-Meta: U2FsdGVkX1+KG9CyS2Gll5XJzfyP37GZP9BjYvPi4UERhKCCms6CSA4Yy2ZeMoSznDTgC79m0AHI90+3JxUVeFM8HvRpSPccRJ4+PGc+Sy7uhM3oJjDRKYvkx5qnyftl/1nJl4XqLV8AJlN5/6ykGgO2arAfmxmlNsGlcSiHKo2nlJcxiqvKNcaAijY3LbTprTqNaHaP9dNj7G0+V43bR9gATQgO7c7Qz6G3fXpl955VmjQq2RtTF+CjJ/QlyKZ3iZL1hZ6tCxjA2ljtyV9ejjaEIhJpSmJsr26jkKXHiXu7ERie6CDx9fU8ZYA3z/QAvGyynbRJo7NVsDIip1UbSIR4XFIYMocp0f6mc5FCJ6y+NivvH7RrlmSc8AwRMimvhAIE1C+Go/hh1YNuHSA77r/O2u0bwTuJqFefgK7nVzz0xkO8mTLG5T0ka7WXNwLAyW8iShm8tZTerR093oeRdrmWR79k7/pLmq/lAnTC2plpyOXi3vriXtyyg+dnmCstjV3pqUhAndrEKLGB0pTIUYkn8ggA1j63nWJLw0gWVhfhW/dp+ko9mMzhgjeIa7BEccQT+8Y4nXd37pKv43Q8f/k/fmGiYZaoAJz1UgI90MV7wFyc7UMtZNWIrBM99GKi3K36Ctkvt9kh11+Bf39qUWo7XfUUEUrStkO6Xben7o0SNDcceyW2QQznJub+nvgC91O0QXjkyRPfGIRWqXAiYdlF9K9cOf33bkG2V9SzoF2oEaIkDnIHYgUlSGXDr1CCJmNTGY3Pz66ytN3PbJeDQAAGwvzpQ17WInJ8MY7K8BpkbSEM4c5FiFoLeV5hLkf3Vt5zwTVZIoI6wpvhp+UU2lmwU4AVp88mHtN7o0kD6PVGavMXF2OopUbjRpUSu6SL+ieaCB6rNfSfpj1vMGpa0RLq2QZK7/1zfrwrZlDezSWnqAjYO/H8AJsQhnBxuIyxTPbLQ3dIy8dzzrwgwj/
 nj4emCJO
 llrdkQ14a1+OLeh8WQdVy+/ZmOGYoswobIyU7cIqpKShOKA6Hb8ZyY85+4LtNsKLSatfEj30yNd6r8O6MBhEhQNeSUqAMHIQ7/2Ccl2C+cvqeVJD5x1ev/bKVBat78aELRo2MC+HjeFuyk0YGX/q0fW+ORIdVvKqD84CowLdM6naMSC/mnmLWTB+a44tEPYfxYP5O60+PVlVr3RMY1D3ElR2hh4nbA0iVgZ46LRF5Sr96HV0HZJznn2bKDLouUB7oS7sdip2QIh0FP14ZHi3k3ezs4khOjBEUWuXz4UrudbJdJslauYeHq6wlZIB7ceb4dAZOXqnK7+INmr6TgZqJCFF4IGAffK/cKRn0N/aZJGjSNu4TMhe4FBbOeDsKvRA2jFall2q6ZBEv3ZAKEi/M+Sm9me4avZWKZkb1hViRZfnQ8A3UdOPTHAORs/x7AaqZnXzIU3Yn8ejLY9wMJOD6POSwuMYWus0pAzIMPiefNM96oWn0oUmJ+2hDU++CbtPcRTs5rzc1qaubm8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/14/26 1:49 AM, Andrew Morton wrote:
> On Fri, 13 Nov 2026 15:56:50 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 11/13/26 15:25, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found no new issues
>>> in this patch, but noticed 1 related pre-existing issue it does not
>>> introduce:
>>> - [Medium] mm: xarray node memory leak in collapse_file() [1]
>> Ignore this shit from Sashiko.
> 
> There was some ball-dropping with this bug.  Shardul posted a fix last
> year:
> 
> https://lore.kernel.org/20251204142625.1763372-1-shardul.b@mpiricsoftware.com
> 
> various ackings happened, suggestions made, other fixes developed, etc.
> I guess Shardul gave up and went away, who could blame.
> 
> I'll add all this to my backlog pile and shall figure something out.

I think this issue is fixed by commit ee3f01125010 ("fs: Free any excess 
xarray nodes in clear_inode()").

