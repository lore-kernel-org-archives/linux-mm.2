Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11400606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4qb68Vh
Received: by kanga.kvack.org (Postfix)
	id C78716B05B3; Sat,  7 Nov 2026 14:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28886B05B4; Sat,  7 Nov 2026 14:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0A86B05B5; Sat,  7 Nov 2026 14:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8363D6B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:27:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 145FFC0217
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:27:11 +0000 (UTC)
X-FDA: 85409306262.30.E1EDE6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36B25120004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:27:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4qb68Vh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794079629;
	b=LFs7MlzKx7IG8bYqlwYlpsaH8n8QzHWxOgLjcAa1W+ZDgXqI0P1jd0eTdZmhVUpLq8bQDp
	x3xgARIp0ljuqQlbR6z0Z+yWzeawo6ycdLMKY5iLh2wI+kgYEWPwgfZZCvi828yZT2+emI
	mexPGhxdF3X9EP7Y+7ZyWOe0ydvtdBU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794079629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWUWmDtmMJj9uR+KdODad96y/2aPbtjqytw6K7FIvTo=;
	b=NerO8jMzYApoQr74uT9a37n4IdadaujJRmeu0FQ+RkO+zB6zJtzMusTwIwLG9WSAjpnKvD
	k/mQaMdlse/voPzUWKFjivEFuF75syyLsJgByvO2FHS7IqZj3c86OsQ+OJiLumaZNthrh5
	4CLzTgtc/sqUhKVrsx8OSwX8t7G/y0k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4qb68Vh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF30243E32;
	Sat,  7 Nov 2026 19:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5851F008A3;
	Sat,  7 Nov 2026 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794079627;
	bh=JWUWmDtmMJj9uR+KdODad96y/2aPbtjqytw6K7FIvTo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l4qb68Vh5+EpKxfkY8T2j1202etzw9CcaJfnA0gcKPSK2QHF/jdVbFeNxQcShSzl2
	 kGpXtGW2fD0YNMDmHCEE3KSCdbOQiaNyhgkt6IR9Mflf4BT8u9+mw5mx8X2EiIZj2J
	 W8W07b0n8ionghCXH/Pzs86IDhVnoJB0NTTVnrhSptFlIBu04i6fwkc33GYm5oDenJ
	 dpcADsDdrjz0nxyX8rqzWI9tfKG3Iau9FGoEwVkaWYXlv7gP2dIUmvZTJfklUnLWIc
	 8i4jWo0RR5wZfXr60bMXqdXmQ18dHss7MDPdDsIl+hGwk9ACyEf8QSb02+CeyhY9ai
	 zAA+05ycOtvEw==
Message-ID: <1c0b1368-a381-4b25-bba9-7a4f8e92b764@kernel.org>
Date: Sat, 7 Nov 2026 20:26:29 +0100
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au3r0-geuwtRYPiC@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 36B25120004
X-Rspamd-Server: rspam12
X-Stat-Signature: ig1doqdjkiro3gkznxp5ot65nahbq7c4
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794079629-662009
X-HE-Meta: U2FsdGVkX1/gaD3fjNvERS2uB1bYKHMey2E9W3OfjmFK5iXB/4fzhqI+zOvychNMwqvOJoSyxX+1bf5jAZcX3BPfrYqoCmi2QYMKVxYF1ynF0qe5q+yVsYPDEXTGJYbvQSeKKcVYX5zEvm144dBpUuIfUzaJlMtXtGkgLLnEVA/kxFaf01RcbDVrnOJ/liErTdCIhsjXiGB/yyyKoia8kZltX9o155iwoNbE1UihAX2kVPaRBxgmYA6310Kh6lw6Qo59AW5GmuRJitXsBpl5jQWzSnJR+jHM71iSBEHO9bFigsWDmIMUqG56hyXGMJ8jWKMmI7CPyGQhsdtx65+XjVbiNlsy1D3H99fNaprMzK0hMLR385rgymVP1WHHLeYa3wdM+qnPItu5pbikmjee6ovRiYiDZEorbIamENGcXUYEMclGHSTWG2sqKbL64hM/C4sbg3EGV4uoylrEVdCIzEoEKzt5c/4OWthb7C5gicg5TFNxHSc+89DHka/8TQ5uGEeeESxbT8c0rg99FRZt2kcKJQPBXWf0LREXC5hXHGz4Z9cI8zOg0uJ1EMxmilQia3MNXjNOBdFjFnm6EJP53DCs0jqou5bskQtTX8Lkxa/lGFFD4TAD/jkqY+S9E1lg/zUlYgs9Ey8YJdU5iLpSLzTUfvrbAbYdOHRk5RDZ838LGEDbDHXkYqNSx5qylF77bcanFC+W8fMKmiB8iSJavWBpkNAF+5PfMeu2ThLF78qzCOGguOfnR2WNxsZmmkggjgqWy9sRTUP390NjHgPZy4wCugHTYzomVqEcVFPoNmSIyIgCT5x7RNMwEAMzKC94fpdACpzLvyvzwJ9ok373dzg1vqZlECnXzTHeQW5pNieTypNhGVIk4az3r1rY5OFHOFSqsJzHoVtpLexIXQPTy2j4vxOFei9jntS2Mrj3PpFquOR+ZtDo+zO3kR9VVXht6NISDk/Rca+Ksdmv6m5
 DTiMzS6B
 XxaUIz87c8Sz0ltA33gbur2xzOoaucFTWx/jmCKVc7PfzHaHpatFhiTMV4oSNJjM/+UMsuzm5NDZnfYMpnm8m4HKbwZZPrHfo0RFSS5RRGcXBHUx+TGcIKNXg9VO4Eij23pln2SEMHLBM9n+r6JHPus5KgeyaF+zEMmz7VtTKBJKKzHQjVBGJ4RpUBP5mKgh9u0DkVJX3LIYaSODIjn+aJLZAtH0hrJuSlVhWzRMqPIdEUJen6f7Ta7Nc2Tn+wLcqcfhznbOdPaFO6G+IQiizAVs1OeZxb8wZGAsO+08mQuwrfxoq+decTyBwtHnwGcLtdN9TbdeOcdiAy2/ag4zp/b4e5UgKim2mCM5HD4oBM4hEWLhUA/q+cv8x4y621w3jR3U42voC00lvmaWXH2lwH9Jtetca/Jq2MkjCXPzJGy0EPc1U6fvoyX+M31elfq3lQ3ChG4g7TXGA7C3DQnkOKh5GNEYHZHEArnh0xGNyecqD3MGK8GEPKUTXTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 16:22, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 06, 2026 at 03:35:01PM +0100, David Hildenbrand (Arm) wrote:
>> I agree that this should be picked separately. For example, I will pick
>> everything that falls into my realm to reduce conflicts.
> 
> Hmm, generally tree-wide mechanical changes are the exception to that rule
> no?

I think it really depends. If changes are well standalone, I don't see why it
couldn't just cleanly go through separate trees.

Anything that is more involved (like the madvise change), there is not really a
way around.

Well, there is: stable topic branch and letting separate trees merge that ...

> 
> It's going to make the rest of the VMA flags/mmap_prepare conversion really
> quite difficult if I have to chase every single driver maintainer in the
> kernel (literally in both cases pretty much :).
> > And sometimes there are dependencies which mean you really can't split it
> across trees unless you establish functionality in one cycle and callers in
> another, but that seems a little silly.
> 
> I was thinking that once the VMA tree is separate I'd put mechanical
> changes like this through it. Is that not the way to go?

Maybe? We'll have to learn. Right now it immediately caused conflicts between
mine and Andrew's tree.

Because of [PATCH 05/13] mm: convert THP VMA flag tests to use vma_flags_t which
is THP-only, and feels like it could go straight through one of my trees,
avoiding conflicts with Andrew's tree. But maybe there is more to it that I am
missing.

I assume stable topic branches would fix that, but they are currently
unfortunately not on the table ... :)

> 
>>
>> Ideally, patches really only touch one component.
> 
> Right, but sometimes functions are declared in one place and called in
> others. It is impossible to change the signature of one without also touching
> the others.

Yes. Something like that is unavoidable. Or if you need new APIs/

> 
>>
>> [PATCH 07/13] mm/madvise: convert madvise_vma_behavior() to use vma_flags_t
>>
>> is all over the place :)
> 
> It's not really all over the place, it's converting vm_flags_t to
> vma_flags_t across madvise.c, which involves changing a few function
> signatures, whose callers must be updated.

Ah, yeah. What on earth does arch/powerpc/kvm/book3s_hv_uvmem.c do with madvise :(

> 
> I could split it up into 3 patches where 1 does internal-only, one changes 1
> function, and the next changes another, if that works?

No, these things really have to go in as one unit, no need to split that up.

-- 
Cheers,

David

