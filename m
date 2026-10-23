Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6CF3606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=cpys32/L
Received: by kanga.kvack.org (Postfix)
	id BF5896B0AFF; Fri, 23 Oct 2026 02:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC986B0B00; Fri, 23 Oct 2026 02:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE30D6B0B01; Fri, 23 Oct 2026 02:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89EA56B0AFF
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:44:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 049FB120333
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:44:28 +0000 (UTC)
X-FDA: 85352952258.10.B8858A7
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf01.hostedemail.com (Postfix) with ESMTP id 812A340008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:44:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="cpys32/L";
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRG6U99EKeZDnYNuky91yYiF/y3AS7tMgJRzNytuW38=;
	b=YIMEMl8E2XcNzmxrPQcZzsZPjhOpTvzELHotxZ+dGXqbXf5QC5zCEzRkUbdmRS3KvgxU4o
	EAVIizWnw+G0rribPTETqBuVP1vDC9SM2g9QihCWJXytyQaZX2giZcrSiaSGZcNiRIK9fh
	8fdmdNHXOae1k5oK6FuJ3hU6E1DWiYw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737867;
	b=vhpRQQqXYWO0R9ZQh6n8wK0Mz4clCLF+9jiAXoMTF5UqMq7wJ8LrHE3n8ZPEPE9jhlHV5p
	iGSACYIZH3y5cWADVH9Lzu7/4JKksnrN0gDkt+wJFVuLlJ7GB5c2T4sQ2JS2Qg5paGJDif
	gIld3AwBZhECyxtsDrh9yWljtYMrRxs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="cpys32/L";
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792737860; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=RRG6U99EKeZDnYNuky91yYiF/y3AS7tMgJRzNytuW38=;
 b=cpys32/LRolwEFjjMEMw/5ElImdKxW3aek0sC7tkC1CNPLkRKMJvICJUrECWh/hB0z30gw
 O2MP7SyffSrZ+log0mKJ8xHHnjE7ajfrF8OUXcg08jUoiNFS+ZBOVIzgir2eZ3QVBuLAwS
 Du83PYH0Bn1iHjxPqYpSOG1+8vnBVJmr08xntzi89e3Vd7dhZxBdkMQI7XwynjBqvxw/41
 62EhywzBgDtmsC6/YixqjbCOBGfR7DMX3zLMeUXX4V/SL6jFS6iWgT+g/sMtVuHugXjR7V
 4yLlBgQsZIKhr4Fi+HIGJ4tpRrUFlLtHI8NtZVASvZK4v9caO8Vq75AvaYG4uw==
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Date: Fri, 23 Oct 2026 14:43:57 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019141401.11927-1-lizhe.67@bytedance.com> <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F> <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com> <179264138036.2549665.17429111144570830454.b4-reply@b4> <9b715272-3ed9-42da-a6ae-467e8ae00c0b@bytedance.com> <atoZpXaCRc7etPW8@gourry-fedora-PF4VCD3F>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <ab7aa28c-ccf7-4bad-a871-4b05f7e9bfca@bytedance.com>
In-Reply-To: <atoZpXaCRc7etPW8@gourry-fedora-PF4VCD3F>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26adb0242+c91a74+kvack.org+lizhe.67@bytedance.com>
To: "Gregory Price" <gourry@gourry.net>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 812A340008
X-Stat-Signature: 8458fnndgz5hw173jxscbupo6mwjp844
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792737866-242989
X-HE-Meta: U2FsdGVkX1/5nQ4lvxACp+mWCgtt8mN+/fC99SZYUlXZQg8ncojuHFeHlUcz28i5Ivf3PMzl5wLZlCqMCLuB8kKigZyCB+igX9Lk1s1+HC74ejcgqbEIPLbXprOx6TXzH76Ae48dkNQbzuidHjgFDSlmgzzI3TjpENcspBiU8JWV4zfBiY+ocQrLM+r2lDgYyOZo8AIN9fJzGUf9y196bN55YvzRwV9mrFcB13Txj0c19lwiMKe/MIZ9nS9UZBNbbojTKljbQjEK6ZusxHU8mQqulUV4/69MsrpPl5aGnmH82UrNNTR4n0Ln0nyUZ7+8pIGUdzY+CmfYdOEhjsFRJ5o/i4KjAP85hgZs2mZS24Zhn0puGHdqay0LlFhLXDFBU9iA57HC+qwMrstcFtQODScRFuuS2muYQ4qQ0WHE6IHVvdTxumvL0Y3PXZdSo1BYMsVh6YfQaUKXalD1wQ/t8vRLmiv7SMpv7pJk8huh10L0W+Wnk83W+Rddig9BuK5oaWczwKXLsfYwCTb5P1XkV7p6EdT2ibzgOgZLp9ce3fzlqk3qiUbyfYpllF6Lans/8/I0Ts5dT5GUvcPTO3KEEE07G4xbdYQoydJ+lMhRUD0gacM0lMjM44OjMM3fH4XIC0FEfVltAHVYwRi8wrJXhqFkK+Qh6epgbjNCzi1hn6m0IRoyga65rO9kKGethh4SL3HIGOl3au2fVA4HhCUGnTWc1YG+I3wUkOhQZ9yHczxEXNzSF/3k56R4eyo4eZ6bFbWSEwLKBWxm++Y4CgXTqq9E5A+4XMvvhaksS79V/nxCBP0Yl/3iwK3kpe3BK78ZL8IAHGCYFKoXizU5we+gYA6MDrBGwr3BjuGsIrazabZHw6F0FAJFAvU7kI40FwiebG8ieixTP8pejt3JAUGc+N1oiJaWC4Et5BGQAaw6w7H8rinuGgyolbvxxTxcVGDyprlqNFR/6Md1Wz2mpm1
 caowY41T
 lvofB+mOHM4nW7TkEbmBsW0K35KMe32IbOrN8joJyFxgPEHFBtfQ7+jTGBcrmxFN6IHuAwvDqHtYSZc3FrIjBTpFzvhja97UQlKr47LAilNiaH3+ICstX6SYtbJYqZxFHoxsEJUW2hOW6nerXVliXVr61Ro7Rx9SpzxxA7/cqa76G8gop1dmRbtNnE0KxoxvYM5t7yOD2FYXXpjFTerfeaaOs1tI4B3SAVym50SBpGHSUXo1fveO57zbelI2yyIecD7nGPuFLlib9CQ8A1rYomT22FUncsBT6goq11a8yeLgwq4eaMlZC+V7qfcH6qbJKdhDz7N9H4WDh31nC3YjUO2zlbTL3oPybE0m8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 10:11 PM, Gregory Price wrote:
> On Thu, Oct 22, 2026 at 05:43:49PM +0800, Li Zhe wrote:
>> On 10/22/26 11:56 AM, Gregory Price (Meta) wrote:
>>
>> So userspace cannot rely on one write to memory.reclaim to produce a
>> final per-node distribution. The intended usage is a feedback loop: the
>> controller observes the memcg's resident distribution, chooses the source
>> nodes it wants to relieve, applies source-scoped reclaim pressure,
>> observes the new distribution, and iterates.
>>
> I think the critical question is what CAN userspace rely on?
>
> We can make a bunch of feedback loop interfaces, but there's no
> guarantee they'll actually be useful.

The reliable part I currently want to claim is narrow: userspace can ask
memory.reclaim to apply reclaim pressure to memcg memory resident on the
selected source nodes. It should not rely on a single write to produce a
final net per-node footprint. The existing memory.reclaim interface is
also a best-effort reclaim request rather than a deterministic placement
primitive; this patch only adds a way to select where that reclaim
pressure is applied.


>
>>> At the very least i think you need to add details in your cover that
>>> demonstrates the process of doing something like per-node resident
>>> ratios, and show that it works as you intend.
>> Agreed. I will update the cover letter to make this model clearer. I
>> will also make clear that source=nodes is not a final net per-node
>> footprint guarantee and does not change memory.reclaim completion
>> accounting.
>>
> To be clear, I think not just making it clearer, but if you can show
> some tests that demonstrate the reliable behavior of the interface
> extension under different scenarios - that would be compelling.


That makes sense. I will run more detailed tests across different
scenarios and include the results in v2.

Thanks,
Zhe

>
> ~Gregory

