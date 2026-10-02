Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07DDECA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23CB6B0088; Fri,  2 Oct 2026 08:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE3F6B0093; Fri,  2 Oct 2026 08:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9BDB6B0095; Fri,  2 Oct 2026 08:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA2846B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:22:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3ED611C393D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:22:05 +0000 (UTC)
X-FDA: 85277598210.11.6C828CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80538C0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:22:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9dhGOCV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790943723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ce2a1myrX+E7TYohZBFJIjnt43b8Lx5Vo9Ht/zpkf40=;
	b=ruAM4Kl4tAGkK2oUFFGVZY/YoyWUGmAJD1idr2mwG8o5TC62iEgZOeINPYlFePMd+dpuNF
	7DgzuZYbDKJbIMHl98hJAu9zkPU/MkOgrHdMQSumdxGl3ayn04Rxxo17mQshi3/WU9uysj
	G8vhO92uKr5Ody1nQDaTEFlXlaKVtfI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9dhGOCV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790943723;
	b=fIodk2TSft6IkLmNMKgA0SUuKdy+6eo8hS313x9RXT7l/yi5O8xGZ69BWgChwmwuLLyMhg
	wSLiAgVX1EVB4k+7Cc43hNgnTkGrj9ShdTNPJCdyZP1Vbumhm8TK/+Rqlt4HrclLB76Hh7
	+WmG7iS+nGjx+VeaA+lAiRasYjfUQkQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E512F60A96;
	Fri,  2 Oct 2026 12:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8551F00893;
	Fri,  2 Oct 2026 12:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790943722;
	bh=Ce2a1myrX+E7TYohZBFJIjnt43b8Lx5Vo9Ht/zpkf40=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T9dhGOCVQdUIoH7uRpzRsVGY5F49qFVHEBrLBxqHFAGDuAIXoKS1xhlo9AHRPemjl
	 JRk6CHalHqos1q8v+ayc59QPqujmTYHK7JTUvE/BscPv4v+7psZocfv7PUyBkJA+qx
	 9Og9uFdzJPDh3aFL/5/0E2nXCZfiP+39kMF1YHtHFb6x9sLpsiNZalCl+TLegXyBij
	 6Ztord/uSDPf+I+yczyV9L2Jdg+/70XWz7dPoDn/FYJvGioJQ0fNoh/j3x0xS92tJe
	 y7rGK+iQFw8TvsNJDUYORs2W3V2P+QYCF4AG0AdWtUQD2Q6qhzcr6CGA37M3DTGvrm
	 iLTs4uxEsY/cA==
Message-ID: <d6ee0a8f-e7a8-4fa7-88b8-62fb44bfc863@kernel.org>
Date: Fri, 2 Oct 2026 14:21:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, johannes@sipsolutions.net,
 linux-mm@kvack.org, liam@infradead.org, rbm@suse.com,
 akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev,
 liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org,
 mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org,
 daniel@thingy.jp
References: <20260929235711.2287931-1-thehajime@gmail.com>
 <20260929235711.2287931-2-thehajime@gmail.com>
 <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org> <ar4br2vW7yZGd3gt@gremlin>
 <94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
 <m2se2o3jyc.wl-thehajime@gmail.com>
 <a65f4431-d225-4535-b921-00319ceeb2a2@kernel.org> <ar9ldn036SgT-bq1@gremlin>
 <CAMuHMdUKcUxHZKhTEF1gwWrU1o8O6jt6N3r90V5hynrLFdwY0A@mail.gmail.com>
 <ar-bIzYDdlOKUqla@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar-bIzYDdlOKUqla@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w3kqksxjzh54qcxjstasj8z83b7oksya
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80538C0006
X-HE-Tag: 1790943723-36021
X-HE-Meta: U2FsdGVkX1/+0VIMtnMcwt4XUWoR5VRH9KnvkO4muKv7i8Ynn8uNrEdTZ6Sb8CfuJv9wlMGnjg4akVcYFHlpd0kxFDaoyhXk4fwPliWwXsFPLcGMGS+6qP8w6UkPc5iWmUG/kbaOEeeIgxiqyPUHQXKuZ+TD/EhmazbU8ZZSQQapLisUUoBrXy0jYdV6wbIz0sueFllsMssTeeSHzayb0kJkC2TqqPZxLB/hyLk7HuucttFy/c2Hokawn5Cw3uauUT1QCwg55I9SWlgs8iC4xK919x7at5Mgmy9vF/r2BTk4vTBAwSjG7tD1VFL6M9BKTwkqNyk00wvFHX3dqCNHn1kBvsri0fgg4KgIND21LEutFOdMCrvEmZa5+7Y+w3UZ+lNKLTBB7cK1qZ/GriM2kpkLyes7APw4bgzp4FoyXKH2iJ3GI9qaVH7qYVGwiK89nv83rLqlLenrp06EubkawFvN/PLJQcpdW2ofoK3d9Ykw/4gtSAbChD66ppeaeTn87MAcZ/tbEgTaSsM0vE9zlkYN7MZl1OrAL3uz6affovLaQkWikWSCvkefBAAmrbP8KE6fD4TLsGwLnYV87UcerFK4q34kjAWbYaGq3xX1BO97XkXMZc9SuleWN4TQzx7mTvh8HoUMrC0NRnztcV2gFPlbMZ3Xa4/NURyWpQAfw37C+Tne+z1DfUrifsx0nALe9Q/Nb6vTmlMF8ewGVkVugj+p6MrlyOCGUAd/q+Bzr6Lp+fKji5osgZkxFWCmMI1nsNA8hQBWgkf6dUkMyxcKLVhp5tcHrPcsp9iE4a5bI9fmNuqe38m3Kj3p5CZM3Xj8+bFl+Tb7BIWzRSlZEvUCxQClb8d60r4UFhq8q075FCo8YUILI2KN+2ICRvSzOXEr4Fkrn6BAWdHDWKWB0/LvI5mTuwBzp7jT+aESjc4xsusbJDQIWDtubjFZ56ycvxR/BjqOef1Vc6wfUlT1a2e
 /jvJaRSG
 uzUGP9/jnp42WeOJZhT/lqH118D+SAlw2KWt6qebeevrcduocnXzxdCk4Jvc2Z2l349d9EEdP0JudC9Vo1GtoKXYh4wUlvqmR24UWwdrIKxIKBQwWjltqAPT/KiTiZP3yzVuMR6T/u00Kgw/H3oSUn0zCjegEO19N2c+s/5BV00YY5ZEiZEreb0Lm8FiRvjATgH+/k6p3Czq8/cYHt3GsclY0rw31KUUrlLkIS+eVT7ufA1/QwbpaW3yT2LBErd2ZlitBZrW92SIzPWOvLfxbR9Ar9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 13:53, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 02, 2026 at 01:38:31PM +0200, Geert Uytterhoeven wrote:
> 
>> On Fri, 2 Oct 2026 at 10:10, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> 
>>> But fork() -> -EINVAL or -ENOSYS = nommu, then just have the child quit and
>>> etc. should do it.
>>
>> fork() is not strictly an MMU-feature (you can implement fork on nommu
>> if all memory accesses are done relative to a base address register),
>> while I think mprotect() is an MMU-feature. Unless it can also be used
>> to change the protection using the one or two BARs most MCU haves?
>> Anything else that is a real MMU-feature? Non-identity mmap()?
> 
> Does any nommu arch implement fork() in linux?

I was about to say, that sounds a bit too theoretical for me. IIUC that is not
implemented, and if someone would propose it we would likely just nak it.

In the unlikely event that this would see the light of day, we could always
change our detection in the selftests.

-- 
Cheers,

David

