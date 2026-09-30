Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1652BCA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933A06B008C; Wed, 30 Sep 2026 08:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD1F6B0092; Wed, 30 Sep 2026 08:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784C06B0093; Wed, 30 Sep 2026 08:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49C1E6B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:32:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD6071C3872
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:32:25 +0000 (UTC)
X-FDA: 85270366650.04.9553AF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE3E74000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:32:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XjWA6lB2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790771544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkdKAjKGwNn6DMJuAhasr9LRZPwvdNi/86hFTFxKewI=;
	b=0LLp3aDPJWYc/bocb8toGf/WBzgLzoTxu66eEMrNVgr7WFZhNzOmCES5k4ZSj4zWoQbWCS
	emiWefRWznuA4th1OIjiCR5lkEuvSYVbOckaJnCJgk/Ca6ooegmAjcTNF6As3A+qFJZXZ/
	FAUltta6okFZM8usEF8sEO/s9m1ifCI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XjWA6lB2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790771544;
	b=qZEb4vmmkLdy8FiajrBVjLyNb2WG1jqVr9yZ1ZrkxSphyiELJz5oyJ3gFppvGoqu6geVwk
	c7aXAzNqF+EoMa1rhFd3K2OwbL35KWMyud1JTi9cMW6mko488+tIvGFp0yUpFvZFtSQXYZ
	l1tgWRxhGYya2zkcvcvV12Sm9V4VNls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 729FA601DE;
	Wed, 30 Sep 2026 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC791F000FF;
	Wed, 30 Sep 2026 12:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790771543;
	bh=xkdKAjKGwNn6DMJuAhasr9LRZPwvdNi/86hFTFxKewI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XjWA6lB2amgUGiMfljNCzv/PVdV60tHMW8zsKIi3779W4Pg+84t+OjJfdEvX50wMN
	 4sR+Xp0jiwp5cz2egjDedWUZ0u6mzlGUAWUH1QRDvotBU6iRUHj5qxVuv61CSOUZrK
	 i23R3EHv2zjLOuWJV9LkS+A7J6dk6NiRLkWA9ncHoax11F61+SGfqUGL8Z9cqjCxoA
	 +XPhD58/kEaXvkRqatKOgt1w5Lur8sy+b0IvXYM+lnZJzWgK9uHcmv6c00sgRcunqL
	 lUVkSUbyYDjYJ2ZbUVHmGb/79us9LsTZ0uSerae3jLftFKyoJEt8C9mf6+lx6Sasi0
	 MhP2LVfU/hf4g==
Message-ID: <ca35c989-9aa1-491f-a247-ed36724f10a0@kernel.org>
Date: Wed, 30 Sep 2026 14:32:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
To: Gregory Price <gourry@gourry.net>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, ziy@nvidia.com,
 joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260930072617.64665-1-lizhe.67@bytedance.com>
 <cfdcaaa3-a9e7-4352-ab01-4922ebb8e0c9@kernel.org>
 <arz56nVu8TzSjqlg@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arz56nVu8TzSjqlg@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE3E74000B
X-Rspam-User: 
X-Stat-Signature: x7zsegrbjtco8u6xdeeban3sspgb3c3m
X-HE-Tag: 1790771543-899319
X-HE-Meta: U2FsdGVkX1/HYn4ZeXKCnz8ZaXz3q3u23dWRctfOa5xOEOFw2B+LjxF/+9I38nDZ/vz1ZiO/+1XT95g9qv5Pvz2WBZ4uobrnzUA6x3gWOKrqvm6F6oUVxHBnplQ9h/6fXUDQgI6ZA9JfwQKSMRlkkPGX7J1KESVy9p392Gwhk2o6hNQnqJIh/M8JqNdp9Gufxqz88Kwmn/uK7jWAFDWi9x58NAE72SGPfUg74iepa5nyDDI7HXoqQyEiO6dXgSWOms4iuG4LZXnIAL4Gafqj/FA9KyK/93LhGgM8LFlfcI6woacKLm9rlUIglq8uuGiLdMZKJtVSVozRmxaqO4zEAPMvW9nVKj6VFZiP3I62DqgJQk6PD1gVVaJiBMGQFTk9iWgMs3nE3lyiAzKuBn4bdgcPw3ZsI4lcBJCF44Rp/1RPeLwdThbDSl0sP8BVdsH/LLlAK7U3k1DQKm/ljeNRBqRxQVDUaWG7dZ8Y0ZP4KAXpA/QHILOuJe2zHcExo+j3ZcUWEFt6Lw8rUWC7R4WmyHN/on0J72cUts6zXiHHHuL2rU35kH9ApJyXNEE+6PI+SYs4UAvQdU52g6IMmf3O3o9m47X33twX+w0Zsc0NU5BELkXwoFyX9AoBJI0VmHyWS/nlde8s56+xcM97YmuQAfeQY/pKeZd/r35jRF/kqIMFMBi/JpRvAIfYc3i83UXV6K9GucDtCEHVz/1C3FlkITUUlDbWg5q+Srx4z4bVumwfXhW/ttrq2YpZ7SBqHu9TVX2pkTx75DPUQj4m2q3bbECyEEjAP8hb+QRWQdLTR1gFx5jnz4mwXcGoVjmk0XKfuyo+cYBJYIgKWBAXikv7U26KjVXiqJfzq44O0H+AkJ23DJk2nSCAyEGlflhUyylLen474RLuqWBbuSmrQLO5FiHzO182EcgIdPLzfn87HzYHXtjX5uCnDnHsztv2v4C45ZLHQbz9fLXI4xJepIA
 Q+a1Ch/W
 FJdp2xwojmwgInzBnt89f//+Y382XHjqWF1L3r6yI2er8Gwtod8LPTb1bmDPwe3V1tXoXIvuvS/4U7xBIp8SgUg3DyNnVDskhiWvOrflTkQX7KQZCeXXWbJRdxijaGrMZ8ftoP3czbuXlddymKH7YJLKqePCEXkz+qtswrGAYioyR5hGW1euOlPWaVaVZoTvAO36XZ+1sNWeDO4ftKyYIDTUjd3eUf/xjlCEwfBuahi3Tky6HcnzKuH7eoa7anbxE8vK2r4XOYIAmgwh6Du18/UdoJJ83nR7POSRIUaYDkVDnE2SSeyQ9H2etZVihLYlwxuNJnN6eLvGCb83qfSnCZygkQIgm7fE+O+givhz4SI0BwzOsDDt2mDzYrS7Ob3CzEahF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 14:03, Gregory Price wrote:
> On Wed, Sep 30, 2026 at 01:26:17PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Initial placement is only a starting point.  Pages initially allocated on
>>> fast memory are not necessarily the long-term hot pages, and pages
>>> initially allocated on slower memory may become hot as the workload's hot
>>> set changes.  The policy therefore needs to be able to combine weighted
>>> initial placement with memory tiering's NUMA fault based hot-page
>>> promotion.
>>
>> Ok, so memory allocation will respect the weights but balancing will ignore
>> them? That really sounds rather odd to me.
>>
>> And I assume that was the reason why we might have disallowed the combination:
>> it turns a weighted mechanism into an unweighted mechanism.
>>
>> So are we really sure these semantics that you would essentially set in stone
>> here are the semantics we want? (ignoring weights)
>>
> 
> Right, but you're requesting this configuration.  If you didn't set
> F_NUMA_BALANCING then you get the existing semantics.
> 
> In the existing semantics, if we're INTERLEAVE and WEIGHTED_INTERLEAVE
> we just always say "no tiering for you".
> 
> But as an opt-in option?  I don't quite see the argument for saying
> interleaved regions (or tasks) to be opted-out if the user asks for it -
> that just seems like an arbitrary limitation.

Just to be clear, what I am saying is: the proposed semantics are inconsistent
(weighted when mechanism A honors them and mechanism B doesn't honor them), but
once we set these semantics in stone like that, we cannot easily change them
later because some user might depend on that behavior.

So you'll need yet another flag to say "NUMA balancing really also honors the
weights". And that's where it all gets ugly.

-- 
Cheers,

David

