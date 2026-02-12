Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF12EEA84E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 20:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13CC6B0088; Thu, 12 Feb 2026 15:11:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC15F6B0089; Thu, 12 Feb 2026 15:11:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78D16B008A; Thu, 12 Feb 2026 15:11:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B58C66B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:11:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 414BD57CF1
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:11:46 +0000 (UTC)
X-FDA: 84436900212.17.D3E0945
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B5AB81C0016
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:11:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLgEkl3q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770927104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2N3X8p9VxAj7TjH96Mh2ELpzUQPlZjTl2PxEqwOCI3I=;
	b=I0JBbiyxGxXXqyxeQNJ7/6Eu1ajZxwB6BPQYx9lvtI+5oE/j/W6Ba10fzrdmyAzf81+ZWk
	4feqdjZdgYZJ7OFbJ5Hej4sdfmbIjW0ssFG6RXdn51HhO0T5Xdvl+aqKemi+D2qyIfBT57
	GUTN52rk567qYj4vXUhkWQqCxV46X90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770927104; a=rsa-sha256;
	cv=none;
	b=2Fi/RfdmKSUllxZgx/r4OiAkKPtxbkRKLDNpS95uFB30kCI9thYGQA0TgHqFOSSaSlemWr
	wglq09oQJGJY4dis6UXgkU2KR4tHq/df42PtjfSX62BeyFlnf1p3ZDFK1h9TGGYRObCqZp
	Wz7DNq+AjbMoZvnZgAsix/cDcIv63s0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLgEkl3q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA81C60018;
	Thu, 12 Feb 2026 20:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DA9C4CEF7;
	Thu, 12 Feb 2026 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770927103;
	bh=IK0IJJY+g3N4QvkWaeqbKCUCsjOumbBwKibhA3wujiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SLgEkl3qH1H9gvePXVgNN/M0OR9dEJENlFkGVLYWohrsWiBivqvy64ZgXdmrJ5/W7
	 wHziasqG2oFVk+dhxk9JD0jysxNh0OP+1k/UcEmA8gAhCFU7xztPHspsFjvY2037vz
	 S5BoF2r8xL/nU/KPvMhmliF+g3hrQFYdYZFzMF7yRtEOYiRW7Pl5ggRLP++cIVSxcM
	 CxXRwg/Re7Iiq+KLvE45bcRviD1LtBDkoe9sN/w+xWXz0AYd4fAvakG/Xq+O8Xgivs
	 xQZ3uswjxURZq/xxGb+7WVvlLSr7umaWBI+uiCj+Ma43D4cI33gAahLDALtigluRPI
	 laFvedRIaqZeQ==
Message-ID: <dbfff44a-1a05-43be-8583-8aa59d49b8a2@kernel.org>
Date: Thu, 12 Feb 2026 21:11:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
 hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 len.brown@intel.com, chengming.zhou@linux.dev, kasong@tencent.com,
 chrisl@kernel.org, huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
 shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk, baohua@kernel.org,
 bhe@redhat.com, osalvador@suse.de, lorenzo.stoakes@oracle.com,
 christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
 joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 rafael@kernel.org, jannh@google.com, pfalcato@suse.de,
 zhengqi.arch@bytedance.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 =?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 tglx@kernel.org, Peter Zijlstra <peterz@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, lenb@kernel.org,
 Zi Yan <ziy@nvidia.com>, dev.jain@arm.com, lance.yang@linux.dev,
 matthew.brost@intel.com, rakie.kim@sk.com, byungchul@sk.com,
 "Huang, Ying" <ying.huang@linux.alibaba.com>, apopple@nvidia.com,
 linux-doc@vger.kernel.org
References: <20260208215839.87595-1-nphamcs@gmail.com>
 <CAKEwX=OvuVPJzQsSQm8F+zsRgJFnbMmW2JMJbGebp=U8+jMRYA@mail.gmail.com>
 <13e3cada-60a3-4451-ab7e-16dfbab3c352@kernel.org>
 <CAKEwX=Pww3ZNw=VGZBa46NhKuvefRM7wnVuZy0aADoCoE1KSzA@mail.gmail.com>
 <CAKEwX=Oqn5vZrYnURqwoNBhBmA5xU9jy5-5ti8vzFs2DHDaWYg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKEwX=Oqn5vZrYnURqwoNBhBmA5xU9jy5-5ti8vzFs2DHDaWYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5AB81C0016
X-Stat-Signature: mf65azyy154fqsnjam8dnncbg75r63oa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770927104-699997
X-HE-Meta: U2FsdGVkX1/rb6T08YcOhUJ0/RCSSxPoTS54hqhotNnRuXSrrUCiO4SvWK8pdBvOXU6qnExHHOwcEhk7W6lzeqDeZgkb1Yex8nFn2BQTnz1e+eUFNZhdedsYC5ViF/EzsS1XUJNZCA+78f1vF3jnLGfdF0k1zv8DcF/x8ZkdqLerh7yEjB1xWRDPlpz/4yXJx8CQCkI+PWFsLQtuSQ3nzhQEtTYb8fWnHfc0lNyNswby7jZlQb8Y2knB23JlegFfQR8l+Q/gMNin65G5EvSqtN/aodol+BoIriP9PO3NA4AWu+j439FSJP5rxrXPmgpVcEqJYP0EvR9h7yxK5D7xKXMVgZwRxZgfgYTuBbUtTKoPcYFkGlwHRhYlCEOQUp35Eo5GXtiWwcidM4xuzCaHnTAMFHBXz9ZiNko1bmlrLsQFEYoU4rHZXPTw+I4D1+yn2Ughfmb7afyOchKwuJFvsZxNwa0Wu0HThH/ewjoW0mIgXr+hxFAAK2QUXBdYEH+FvextEyCoizKRwbZ5ASQ85xADANoLVBRl1CYbZgVxfQMwKbwQphWwV1hORyGNpa7xV++AWRHG5sTK+7+r8CEGausXE4AycBokoUwYKtSqKUXIkWGaee/4E1CgqzYLg5WRMASf8DAwTOSchrLwWuG+n9lBarjRQhepeei53FoETSDbF+kw/Bp43YMldKHBJ+Ya2Sjm/lbJ/rjH7KUmyPC5pxfvG2oKegpX822eqiSWfkmnrZGWYMBlFxRDH/j9er7UG7/Nq8euOb/amsiHpmQmwUoOvumWfEjgvX6tkPahd7Z/sLRI8ekxu4uGCYg4lQUG1d0HgqCoXKFFswXqTnWK9o+VHBz4V5vN4pdxfr+qfqNhxoM/HzE4pwl5xd9tVYd48qcTfSP7JazOTDvyzyWVMIu3XZ29oliLt7zQi852u74yGzo69cHxEFGeH2kHRg2g5T9CCWSMygcfph92XZt
 lpDHFDlW
 bcntlDoFukkZKmxJs8epPxWZtIRV29yA3Fvck
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 18:39, Nhat Pham wrote:
> On Thu, Feb 12, 2026 at 9:29 AM Nhat Pham <nphamcs@gmail.com> wrote:
>>
>> On Thu, Feb 12, 2026 at 4:23 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>> Are you CCing all maintainers that get_maintainers.pl suggests you to cc?
>>>
>>> --
>>> Cheers,
>>>
>>> David
>>
>> I hope so... did I miss someone? If so, my apologies - I manually add
>> them one at a time to be completely honest. The list is huge...
>>
>> I'll probably use a script to convert that huge output next time into "--cc".
>>
> 
> Ok let's try... this :) Probably should have done it from the start,
> but better late than never...
> 

It's usually not as easy as copying the output to the cover letter via Cc:.

Sometimes you want to CC all maintainers+reviewers of some subsystem, 
sometimes only the maintainers (heads-up, mostly simplistic unrelated 
changes that don't need any real subsystem-specific review).

Fine line between flooding people with patches or annoying people with 
patches :)

> Not sure who was missing from the first run - my apologies if I did
> that.... I'll be more careful with huge cc list next time and just
> scriptify it.

No worries, I was just surprised to spot a v3 already!

-- 
Cheers,

David

