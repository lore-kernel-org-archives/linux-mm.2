Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD465CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605748E0036; Wed, 20 Aug 2025 18:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6E48E0031; Wed, 20 Aug 2025 18:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CBD48E0036; Wed, 20 Aug 2025 18:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3864B8E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:45:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E20F9B6880
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:45:16 +0000 (UTC)
X-FDA: 83798618232.11.CE34984
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf29.hostedemail.com (Postfix) with ESMTP id 30307120016
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:45:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HV5VSKFw;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755729915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DXWWj4a5hAcoBW3C/vlPFTjK0POV17XOJOPajxQapM=;
	b=2AkMjgka0n33EXMXs/TPPTr46uQ4U/P1r3gaGJoaT9W/T/xP3MJYdyIxa69oJpEt07CArH
	tBxNRYgnm5SrpGxa5qLs5SybWDLIl2Ku966Ix9lSb17L7Sc2UEZ8QUodYsGuKUqfhYZ6Ym
	WI6H+9meOiAGTscu53O54bCovqxzMmM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HV5VSKFw;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755729915; a=rsa-sha256;
	cv=none;
	b=UBlH2oiVLWFggVrO2r8mu0daJrcf0TucjeQz/5L1aa8TeNC0IS3jDUX6Yy+xS1HP4CqNwp
	N+kUXNX4bBd4PgBylTBtI//b8AZR72NNtk+zMQonGwR/BAbAhZXV1zAM75iv9gQw2ZvQTp
	uVxAR+UnxTAfHLMS6Q2g4JUI1fajaUY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755729912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+DXWWj4a5hAcoBW3C/vlPFTjK0POV17XOJOPajxQapM=;
	b=HV5VSKFwPy8UA04gdJnWB5Yp0IuZOqSxs1cY/kYt/0LylCkkoID2MktjpiHSlPrUOq+ZEf
	2Wpg2bKI7PsH/H31yoyXyb5Rzg/kBwcNuuBbh5bRHLbgKmf6KIHBVvjnB4mXJi5jhWXPK2
	mAmtyY+8NWUGgmXhwyTdNcQ63KWd0XI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 05/14] mm: introduce bpf_get_root_mem_cgroup() bpf kfunc
In-Reply-To: <CAP01T772oh8t05Pth2eWFzfSGVWDuW6kujRVSYQEreqZy==nOQ@mail.gmail.com>
	(Kumar Kartikeya Dwivedi's message of "Wed, 20 Aug 2025 11:25:02
	+0200")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-6-roman.gushchin@linux.dev>
	<CAP01T772oh8t05Pth2eWFzfSGVWDuW6kujRVSYQEreqZy==nOQ@mail.gmail.com>
Date: Wed, 20 Aug 2025 15:45:07 -0700
Message-ID: <87ms7tobnw.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 30307120016
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7cga7no7tbeen1xj8a77n66i9mpzinao
X-HE-Tag: 1755729914-133820
X-HE-Meta: U2FsdGVkX18wgBjTC7o+qCOVddPK3x1OhqupG/FIGMrsU3/OsBEn6k7xeDnmXmJ6SI23LrKiNWK7od48zAj8SLCXV/hrJW42+RLBGIEB9Si7stIgWngSfLSc2IVlim0d2SRMI4bQAq2Ln/e/lpP+rToeht5n0jomAzghoHT5ksqAxCKwsfdOxMIc/nVk3Mg42a2aM7JHb5RQ6cuxjYsesutq3BwIOpC2N7o1qLf+eZH/eyXapVu2vSswW+UJPY1nXr/kTTfMBcFk2og9MmM2798GkZsKFXBuTCFPNwtEGZJBOxuDfFKN3vJ29kihEjYWrSIKHdlSfcSPbiir3qvomawzTvzdoal1atEY4tYp6mwPlOjaDMT0y/eZhPcgBmKsLhmaITxYMCUzQWd2mk1a5xjcTyl+ikh3to37yLixrd6RZhhjUxUloNincsXSt0QBhlpuvFNJ+Gr3Ijm5HHNncZQURB19asoxz0jo90PJ+mif/7DLCMIE12j1Ki6n/gEHy7XcFQ0KLb7bjgC+y4BXnHyxolH2/i7Hpi+gixO/nSHGjF+NXukoU4ACmxHBPdhNzmDq9rGoBPbbmlg8O6Y63ZOi2VIUz0/z+zWJjwjaFDOD0PCLUgYvY0jjrSG9raj7yv2vDltTf0MiMEWFOUkRK8jJCYBdK+TYirnM2iJDovQa8r3vwgN2fql4IJoXm3dZ+I4V3ju9AJD1NGzjrGz596QrRRMN1A0uUOkzGmg2owY1aVDwVEpwCvLiws12YVjRphSCqe0Elc6uOVSgvIHSH88UIDB7FglaWmq/pDdKpldNj8BLelrF4heDfmKY4zeBPM0YuE9J1uwxQi22GUf9lylG9tdvNgdyy2G6XVfd3GUPrLEQV0iQjjSGOj+mGnVqntglD3le5jaCgbWHiytH9PRlrkt17bmKp/+D6MdxBiRdAtxOjeJQO7bAmzbsCwunRn2O8UksXwnUc6gRkjz
 r3xBmuDg
 SKYOz1RnhxlIL+iiqnzMaD7A0Zrn1u5IXcXZ2STYoKGJ33F8g/SmSdpn7DUEplHhI99uze2WH1JPn89IEdCb2f6NXwyc4Q8lJChhn74LsQtKW/VGcg4GyZnLfZrc2jBDhxO05XC+ylgvPLNDNvLRTObwktl+X3THGubSSjsES8DEXqk/9uYF4VRNuqMI1qi6oXDFD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>>
>> Introduce a bpf kfunc to get a trusted pointer to the root memory
>> cgroup. It's very handy to traverse the full memcg tree, e.g.
>> for handling a system-wide OOM.
>>
>> It's possible to obtain this pointer by traversing the memcg tree
>> up from any known memcg, but it's sub-optimal and makes bpf programs
>> more complex and less efficient.
>>
>> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
>> however in reality it's not necessarily to bump the corresponding
>> reference counter - root memory cgroup is immortal, reference counting
>> is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
>> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
>> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  mm/bpf_memcontrol.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 66f2a359af7e..a8faa561bcba 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -10,6 +10,20 @@
>>
>>  __bpf_kfunc_start_defs();
>>
>> +/**
>> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
>> + *
>> + * The function has KF_ACQUIRE semantics, even though the root memory
>> + * cgroup is never destroyed after being created and doesn't require
>> + * reference counting. And it's perfectly safe to pass it to
>> + * bpf_put_mem_cgroup()
>> + */
>> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>> +{
>> +       /* css_get() is not needed */
>> +       return root_mem_cgroup;
>> +}
>> +
>>  /**
>>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>>   * @css: pointer to the css structure
>> @@ -122,6 +136,7 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>>  __bpf_kfunc_end_defs();
>>
>>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
>> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
>
> Same suggestion here (re: trusted args).

It's not really taking any arguments, so I don't think it's applicable:
	struct mem_cgroup *bpf_get_root_mem_cgroup(void)

