Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8AD606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bk9tlQV3
Received: by kanga.kvack.org (Postfix)
	id C69726B05BA; Mon,  9 Nov 2026 08:41:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41D36B05BB; Mon,  9 Nov 2026 08:41:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B311C6B05BC; Mon,  9 Nov 2026 08:41:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87DC36B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:41:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CAAA140684
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:41:15 +0000 (UTC)
X-FDA: 85415692110.12.BCEB86A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4BCA914000D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:41:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bk9tlQV3;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794231673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXnN4wP7YrRqcl/kzLqC3ibVyCYH5Vwpm+s2u3nE+fM=;
	b=CmZxzBbMYwPfb0pL0+U+jxNGQ1R9XjJr5i5Rxhbw+2GbBfBVpUwgEqe8M2sYdpClDjL+T2
	cCXliu+a9Khq3DokM1LU2xofzoaPOqFbnNDYDwfmnOlYENH8Gq1iol/U4Eki689vH/Beqr
	aINJmd4a7isYVmpidNbuuLqEOimXP+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794231673;
	b=3rkQB3FXM/AeaoDvk5GVC2p2jUH+dwZHu8YvtQtvznpEkQLbPObJgm6HDDtAa6cXhW5L3y
	gYcIsLIkzqF4l2nRnzViDLGT/79ikAMuSSnxLPHyeHwzgNUM1Sxyic8MNUf1UegBVwwo1P
	vZNQyndmrKyBE3Rc8gM62otVeekj3Qc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bk9tlQV3;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E03245973;
	Mon,  9 Nov 2026 13:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686A01F008A7;
	Mon,  9 Nov 2026 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794231672;
	bh=vXnN4wP7YrRqcl/kzLqC3ibVyCYH5Vwpm+s2u3nE+fM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bk9tlQV3JmFD9uT+BBoFG0Y2WscnfjTaEiPgkxT5GhrocFAfv9ZeQD1n0cBbBuRDD
	 UvCJlkW+8VKOAZty6EKE1cUNirPOPuGRa+XgB8OZ8sGJDyfxug+ZyO05kgjatX20tT
	 qGntVXE1JDp2J8VcnZTRCvGoC7wOupjpNOt7UVEaDBdIdwYVw6UYEIHcm2TlaZEX/Z
	 v4NVV8K6Bn/X8aVHuF5ian/BFE4kbCHIAF6YgOGLuXJAVdTtBWVaLxshIRZNd554lM
	 3PBoA/jda9ss8181UzzC4N0lg9o5iZKdeCq+m6QaCVehjcyruhpjKnKWYughz+93qL
	 5rIHrNEXZKRUQ==
Message-ID: <93fef824-9f60-4940-9ee6-80c9c8e3f945@kernel.org>
Date: Mon, 9 Nov 2026 14:40:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] mm: continue vma_flags_t conversion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>,
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
 David Rientjes <rientjes@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, John Johansen
 <john.johansen@canonical.com>, Georgia Garcia
 <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, damon@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <d0ea7929-7c12-4245-ba3f-6dd5c0269e6b@kernel.org> <au3r0-geuwtRYPiC@gremlin>
 <1c0b1368-a381-4b25-bba9-7a4f8e92b764@kernel.org> <au-DXpEi4wHwsz0r@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au-DXpEi4wHwsz0r@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4BCA914000D
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 1jdok7biugbmf155cyog7nksatiibznm
X-Rspam-User: 
X-HE-Tag: 1794231673-279353
X-HE-Meta: U2FsdGVkX19ku+ljNLkhVAAn4QwVbk5j2CHNWACVKWItFXMaIZbHVSuQdfkRtCDSlI1Mpxsye910RghM2DZN0IHMuEVG++ORUV7x8oRCWjc130qelrQfzcu+5IPHiQ3Mip7jJvunsXnGXREGkFkBOaRG6jhpOMFy0mJofLje/umdI7N6mDlBI5wTYKuNyaR24ms5qrPnOgsiy1aoHfFgIU8B6AkCYCrB68j9jNrtHY4uhZYZDB2LvWzNuhjyMbwQOQTiMNkbzfxdseBhuo9ciM9o0tK7ltQyJetXit9AXlGTPdeBCC/SKy6TkX7eVBNwcGSka9MNLJvVO5dvwZIzbc6UPkaGcDGUvMa3H1IzrnOSYrGMLI/aa6sJnVI1JpynX/JgD257FEy+6vuHUmrNw/yrlmPei0pQVWl2wjDaRygo9iaxhDu1g3ofypRlXJDpnXQzPPKDb6uB/QBuK2kOTI9ghr8JSO3+vSzds/4RVcHKSS51UVjeLrfng4/7hwgrPWmeDCjCsWoYl41JuQwGMo1Ufu78cqGas9jRUDsW01Vz1doHVTXQXjJx0Zyc0S+gCyskvYRFX4BzMVNThBr/vro+gnihmvIy3ooFfw2BTy85vEvqm4Kt6B2RKLKbhTIhtDmOGzD+qUfEnwRggEFA5M6z/6kMqXH2DaYmhiluoTXzAnPBCQhBO8tXXmys4sH2fmV3UMaheXEERFyfjCwOyxGPRi6Kzc+NPIiwJjBf41Igea3Ftewigruqtsn88lDiPeHnmMEm32QlGL3zZEQYBQoOVcDWvXlSgJa6Cv0GxzFIf8qUFFTQiywlPGP6hEWNmdZ2c7QZU76ZdCYCL6K7zoqa/PlenZbG/OaZc9lIGX3tGoNIUvZ4KbC4+0KfIqI4RCo/3q/1hTZ6se53hxXJ/fNcc6J8FapKCLo/J4CRVGbBXHcy6Bv4cUm2MYqBxhen5JIkEtf+uA0H2eeuMLv
 /cVqGIc5
 EsDY2gCE4pfjkYswo+B5rfs6EkoZxjpo2yw5b8H0K0L+rdXXxRNhWp8zSPM7Miz+p4WppyDmfmn664V+eBH/VhbT47/3C/Hr1TiHYl4WvsU71ej7MsjQBKJ7YfQ0pxcBvTfpULMZuIswcDgh45lZ8E29u/8qp0zqVoIrJAahcRUTO+PCwMGjaV9AQb65reBZgdj5Mmjkx5CB+zu+LvWCVv0DhaNd8vk2F1r4KpCP3bN7qbnMALH3E+F5Vz4+gbAlOsFDouPO1Z6eNatconoNvkzdVS42fjbtEDKHLfdCBjRn6OzPYk8tSmrjj1YbBz3TA6+WrFmcwot0R/QrD64QgeDqbeIEGaBVHQa9LuZGuHLcPvAxKR8EXksZ5bBGmSRXflql9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 21:09, Lorenzo Stoakes (ARM) wrote:
> I think we're slightly talking across purposes, so to be clear - I am totally
> fine with you taking any of this through your tree or whatever works for you and
> Andrew to avoid merge pain :)
> 
> I was just talking more generally about how to merge series that touch a lot of
> subsystems and maintainers-who-may-never-reply, etc.
> 
> These are the edge cases that make things... fun :)
> 
> Anyway, I guess easiest resolution here is for you to take the bits that belong
> to your trees and Andrew takes the bits that belong elsewhere?

Yes, that's what I did now, applying #1,#3,#4,#5,#6

7+8 touches some of my components, but the chance for conflicts are hopefully small.

> 
> I don't think anything here has an inter-dependency.
> 

Yeah that makes it a lot easier.

> 
> On Sat, Nov 07, 2026 at 08:26:29PM +0100, David Hildenbrand (Arm) wrote:
> [ ... ]
>>
>> Because of [PATCH 05/13] mm: convert THP VMA flag tests to use vma_flags_t which
>> is THP-only, and feels like it could go straight through one of my trees,
>> avoiding conflicts with Andrew's tree. But maybe there is more to it that I am
>> missing.
> 
> Sorry about that! Please take that through your tree.
> 

Not your fault, I guess we'll have to get used to merging stuff through separate
trees, and dealing with conflicts that cannot be avoided :)

>>
>> I assume stable topic branches would fix that, but they are currently
>> unfortunately not on the table ... :)
> 
> I guess we need everybody-on-git for this!
> 
> I guess when Liam and & I have the VMA tree we can do that at least for stuff
> that goes there :)

Ack!

> 
>>
>>>
>>>
>>> Right, but sometimes functions are declared in one place and called in
>>> others. It is impossible to change the signature of one without also touching
>>> the others.
>>
>> Yes. Something like that is unavoidable. Or if you need new APIs/
> 
> Yes.
> 
>>
>>>
>>>
>>> It's not really all over the place, it's converting vm_flags_t to
>>> vma_flags_t across madvise.c, which involves changing a few function
>>> signatures, whose callers must be updated.
>>
>> Ah, yeah. What on earth does arch/powerpc/kvm/book3s_hv_uvmem.c do with madvise :(
> 
> Yeah it's quite worrying that... :)
> 
>>
>>>
>>> I could split it up into 3 patches where 1 does internal-only, one changes 1
>>> function, and the next changes another, if that works?
>>
>> No, these things really have to go in as one unit, no need to split that up.
> 
> Thanks, yeah, it's a pain I know but eventually 'one fine day' (probably in
> 2028) everything will be converted to vma_flags_t/mmap_prepare and we won't have
> to think about this :P

Right! :)

-- 
Cheers,

David

