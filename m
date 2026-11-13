Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239CC606A8B3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SNQpPHIp
Received: by kanga.kvack.org (Postfix)
	id E51926B05B6; Fri, 13 Nov 2026 11:26:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00B46B05C1; Fri, 13 Nov 2026 11:26:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D178C6B05C2; Fri, 13 Nov 2026 11:26:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7456B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28046160228
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:29 +0000 (UTC)
X-FDA: 85430623698.22.560C3B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50A58A000D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNQpPHIp;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794587187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvDP+281worAxT8lGhm0OCKdQjYY32SaMFYw4aXzxxs=;
	b=UPk9RNdyK0zcEbaHTrA4XTxrrDGFE/wERRlpxWHEKplySRPgp43nkxQPAEwS8oDTd6WsYq
	nuTO2gXYsr2VEFx6aSsEwyS8dqti78lv8gEPIyI0LGyre48AsGpsYukYZGCFJ301MZDupF
	+zO1e3XVmYAynzvJW2jYLX5w5u03YHs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNQpPHIp;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794587187;
	b=3/UFgvwdxRjAFaogc1vg+GVXmmOfEm5GwX1h/5dvrueKV6FcaQD4XI8TR7C89O7gTupYsg
	6BTEEFbDPCrfKmgOKIZZORzaHvZ99/8d6jGxt5B0SveAkdMkjsCcZL9Gkvleg76A+4pbiY
	MysSkYQ6ZnJ6iw3SuPb1KufRJub2n5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3681D43286;
	Fri, 13 Nov 2026 16:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D121F000C6;
	Fri, 13 Nov 2026 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794587186;
	bh=fvDP+281worAxT8lGhm0OCKdQjYY32SaMFYw4aXzxxs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SNQpPHIp09p+4z18rWC07xgnK8/0jNl2vTLRyXB91o0usMBXppqpTTgKdfh5JJojQ
	 LDqeaXr7S9Z69O9vT5bjamyLIca7trv96CMC+CS4P8Yq9vcjYwHukyMtkto3H1kV/N
	 TYLAgD7Voanq9DwzU66CGACxuP5ZCbWpVkB8FbGnqXotLG7wjZvm8RSunpRcjljxfK
	 My0YYOMy7EtKcGe0zEv2AiI7UwAJ/UIJyrKzdFHzEnhOB1q//o5rsAzDs4JxcX0JYS
	 6UwyHlQ/Z7rKwbqmjCmKl4fJ9BJ+XtnlJH4/d4eN5bvvD2LOP4ihY4WDArXCj+YgC5
	 rPI1zBgDh086w==
Message-ID: <9f98dc84-a11b-4885-b414-d751c0ed68cb@kernel.org>
Date: Fri, 13 Nov 2026 17:26:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm/huge_memory: don't warn when a page table
 blocks a huge pfn insert
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Eliav Farber <farbere@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, William Kucharski <william.kucharski@linux.dev>,
 Vishal Moola <vishal.moola@gmail.com>, Alex Williamson <alex@shazbot.org>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261112051440.16140-1-farbere@amazon.com>
 <20261112051440.16140-4-farbere@amazon.com> <avcsfhWktvKxQlkW@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avcsfhWktvKxQlkW@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5xum3uwedeggo8e5wkw9fg1zt5mak9ni
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 50A58A000D
X-HE-Tag: 1794587187-451197
X-HE-Meta: U2FsdGVkX1/jZ3aOf+moR+uuwAi3S9XIMLCyXSfCqcEFL1VUQ9UjnVBMh4QBh6UMU5M7qFdVMlU32HQ34CASQ/E53rg76mIrYHFJxXy/jP9N5epqDHU0ecKnQ+KlVRSmrp/Xr4KmadBTxHkCkUL2FZseTSVZYhE87v8Qjdagqc4vDE3znkFEhJk0lewIxyyPtbX6kNY051tXwKDriVWjZV6MVe2RhO++85KTiQfNsFMeiPBXpp9wmexgkTwoNyZBa9YM2lIPC6sZQOFu8tfshVoFC4F/LK83ZYH67ZuEDFYa/r2bnFUd7uQSsNU3o25mS40sjuzSlVs7KXVuxl+yVxOHPOTWYg2LmDSG3bzJEZLzHlrfxDke3NPwUmRlUI93o1J7zdh7Xq7UKOKM3dDPSpB58Ddp22e6dnQXy0ri/lkMrA1Pkx+T9Vs1EWEucTpquqlmDxbOo1mMOeymDsZ+zGU+JS+7Vd7VRop4YRaO+WCxrn4EvYHGbtnwUz0i1+9zBPnoG1bWu8ReLzryHYhGguNgsl/jeg1AF4TQ11+nsc6AXtekvZlEwv9pBbHBsUPSlpDpJzACyD+pmiBvu6QHsYYLrnciwsDyBm4xuFd4+FNpt3FNJTqJP7AkOY9XxVOdQM9D9kF0Ox+CUNl/S/TDF81BRMI24aslpzE2RkinP/BTPIXEazMDkMLdlV7fAD1ECiAKhWAT66smQpVsipey+KYadhCWFlvhsuIcV27N8/5SF6PeOXWsyNQ1JVr6EmjhMNq6tec6mCX6N8wzJNGLeO5wVjHkwzLsc1EKmrOB0WHkEaiqn88DXi8l1SwtbJayPKOt7cr0PIUXXYanm7F15sNdi/yBgjPQlZTDhgznqin2rGDD1jwwEJRvn6SGpt4KuVLaBaT/yHefhiSEpk4NfLHKLQCDs/asgyVhpiDy1faOmA7xGHxqhqgy/npkM7P+fj6SdRGDGbcGbkPXH9u
 ZcSiln0p
 RZAk8FoAVWxjWqbntpP3JoAEcpwFR0CSGXlwY1l0y6J8c9PMRvHCE0lL/qFnFzcc3KY6dELirdCdCzRUafga4NL4yJmt/LyiF3bIdiG8aAdLcja8k3JSjxLD9XiHh/8NTkDa74Lpywh/nA6qBCqHV38xixLNsNlt5EP6lc26XJkPuE4bIeVSt2Yi7N7BmBiV8xswzEbZNewlCceMQsAOSBkyTKhUBdKODGVvUXkUr1LWfIFjXdLnr2TFTqZ/Ptaz0e6D/DvCvYgwbFtpwMIx0Q0T3w1+bZHxJpdylaa+ELp7HwBfNQZmv1ippqEhbQFh32484FBKPY/HVgh2NTYpIIA9mfJ9P6qu1MaEuEXixS1JR0M4LgaRHnoT/Hu7dSDlJ5Ulu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


> I also don't get why an existing unexpected entry is totally fine if !write
> let's not check anything...
> 
> It feels like the real fix is something more substantial.
> 
> Maybe better for me to take this over...

Please take over the entire series.

-- 
Cheers,

David

