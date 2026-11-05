Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC943606D802
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SckyjmOk
Received: by kanga.kvack.org (Postfix)
	id E836A6B05B1; Thu,  5 Nov 2026 05:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AEA6B05B4; Thu,  5 Nov 2026 05:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70DE6B05B5; Thu,  5 Nov 2026 05:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFB506B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:16:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF49D120951
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:16:35 +0000 (UTC)
X-FDA: 85400661150.29.7C21CFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4D70F20009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:16:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SckyjmOk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbDaZ3sw5+rDHF9XCX1pA/1HXOf4/tGA8FHG4g881lI=;
	b=KHY/urRjHpCfBVtws3qExpgJdD/E2mLOT8UOHhpIWamPKEc6oE0Ut0mgA7F6zEv1aMxajL
	MRQdHJfP3s/1TzebD51tkrrbTX2iAzDocXT3S8aKseA1ZxtfxSTPaXKi3+hocJAFNG1x9R
	9zsoDurYkydJT1305A7s5PWV+jYMU/U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SckyjmOk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873794;
	b=Pl3W3pYSEHJQC6wsMkgh5MTqywEW/KOjkdLBhe5mNmo0PoDklUsLOjc6Mf7GCxjcq6AYw2
	vvnPxKuUF/SSb/1S3SyYW43AV3PzCXxiqwDV5BahC2bHUOYptw2JHFqafkBlQ9QOvMNoOA
	71Ffhek5ydgqSDRfrHaLAdlsFsuWHFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BC3643700;
	Thu,  5 Nov 2026 10:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32FE1F000C1;
	Thu,  5 Nov 2026 10:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873793;
	bh=LbDaZ3sw5+rDHF9XCX1pA/1HXOf4/tGA8FHG4g881lI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SckyjmOk9+NrqAky5ti5dc0q+Evu8Jve+xxi3zsVHpIMk3zuNtbKVINXZOH0yMVlE
	 8wtyIlwsVzvujrpA9ymvq9O+f9Tf1/x2kF/2UJzi4PBCivqGnO4PomtugYl+fPZCCV
	 Xk9HDEH1QntitHj6u/vdJ6Jb5a3KhcL9O5CVXS5j/0QY0MY09xVixddIv7qngShN47
	 aylVHUu2aifxYlQ3vb4hBwLqCoYKeaA9Z1BVtT+bAByM5TMgJs4U+8p+z4pysuhNso
	 hxCrkOvMr32jSlR9i995wbOucyJmQx+2A0aBhGSsy26MHBaxGQuz5ksSCGny76IZCC
	 XVm+mvyr6tiug==
Message-ID: <3a77219e-39e5-4e98-8f88-6f90bccf69f0@kernel.org>
Date: Thu, 5 Nov 2026 11:16:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm: add and use mmap_read_lock[_killable]_nosteal()
 on contention
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yonghong Song <yonghong.song@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-4-a07ab16ac860@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261103-khugepaged-latency-fix-v1-4-a07ab16ac860@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D70F20009
X-Stat-Signature: qk4tppmdhoiyens3ip78o99a5y5jnd7p
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793873795-834192
X-HE-Meta: U2FsdGVkX18ymMJr+bXplgta/pS7CoH4Yfbw/Y5AI+T9xu2DsIkFzZ52odXI3NxigsnehYP5odtci2WK9w0ttLmhmFJcyI8eWEdOAcsnfXxH18Y/Oc5suIhQcsY0cSLSFaPQYd+TrDuFcvW/TFzZrI1UgG9KfsZKcZApaf/nLrhkGrMs4OSCUM9MmpT6HNrEyUUUMwFHkL/lBR4MIIcyEXkQtH/KhTwY2PRNLBRIhsPrcE+Gd+lBN9HrzfIndkSpzIIA6Thu8q3cavnpZ5ix/VmxQ7neXuQf3ZXCZ4X7UwMT6xU3l81IlxaeDjnwxc+4DahWuS3xKGXV9xdr/pMk1hA5YpV5sVEMKSUFDVKGIkTNiTr25C21t7NmEEFXLIsfr6kNqGosWzblPrxnSfSDH2Y77BBvVXT9+BBe+thNYjI9Cnfm7A1shQ8cwhpcOMZAT/uzWY3X0SLJ1IuMnvdlkuZl4C1n7s5nInvVYcIntDx+NHCvLoZTmqTbY9+Zw300jIGPH1Tcl26bC1DaAYkvw7ewxf8H4j2HxHjCZCR29P/U+FAjSggYnk7d8I2FK0EJzhohy0dJgmke45iGmdOurzSsQ8hDoUvNV9XCHkbINpkO3aoE4B4pII3rnjIwQDnA3eJUP2TP5JfpOl4mf8osbNQ829LPR5Pk6510SL0GvjHWG/t9YsXJnXt08pQfRqEgx3kSPWUTLnaB6BpUJ4HMHDlFudAq9VPXTfqqudp4yhVi4JpoKRS9OpnpSO9PBcz7wsc8UAwuk1I9uzm1aPWRvPF250b2KrCCrARvGN2605jmGcK5rTNaYSwZJcer+mi1vZIrbRd4Ux51UP5CLWjWmUAqMYNDKIJ93J2uoqL0naLfki3opqLe4DHBxvBVg7c9e6f/+Q9halt1glZB3oImheZmCyeTEI8Yygfh4eBtwmnI/O2zZT75urx6uRYwRZyjy6molzKzAjwjUM2UGdY
 mp4nETUM
 9XcxpnYMzfBT+HQ9LZWp0boRGbtC+9rmVHG1pshs6deM77LsTiHGqHFDlcCksj3v+sEDnSkrWpgrBBSHwwkdbBcujUmeQHNQM4Pz5jhbVGqns29/YC/EVZB9eirho7d3EK87hbxofVJ70mclpnFJ/P1BA8ajAcx9beW3TJv1pBZKAo0HJ/A9+cEUIXY/9bBHjDSqGnmxycyztbgI4fQ7tYPIqbIYIC3ErvYfnQemxzvtEQSMA94R50udUwMqLnxxhclDnWEn97GNQtNZHakKkV7OR9w8iMqCuTWJSGSeLmdIgsu/BCp00/X9NEP8uoxo7fdRvl8JS2VblJ0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 09:27, Lorenzo Stoakes (ARM) wrote:
> With down_read[_killable]_nosteal() available, it becomes possible to
> release the mmap read lock in such a way that a queued write lock always
> takes precedence.
> 
> Expose this to mm through two new wrappers - mmap_read_lock_nosteal() and
> mmap_read_lock_killable_nosteal().
> 
> Make use of this in scenarios where the mmap read lock is dropped
> explicitly for the purposes of relieving mmap_lock contention - the BPF
> task VMA iterator, and lock_next_vma_under_mmap_lock(), which is where
> /proc/$pid/smaps_rollup re-acquires the mmap lock after dropping it on
> contention and falling back from per-VMA locking.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/task_iter.c    |  2 +-


I'd appreciate an ack from BPF folks and a confirmation that I could take this
through my tree :)


-- 
Cheers,

David

