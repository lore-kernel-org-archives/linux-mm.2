Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62284C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC496B00B5; Tue,  1 Sep 2026 04:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D43E6B00B6; Tue,  1 Sep 2026 04:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C33A6B00B7; Tue,  1 Sep 2026 04:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05F3B6B00B5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:11:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DCE9140341
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:11:30 +0000 (UTC)
X-FDA: 85164473940.18.6871003
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CD2E4C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:11:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5iofLpm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788250288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRO50+DIeZsljZuDqKqgAEET3v+I4IRVdzWP9syTz0I=;
	b=smGV2nU809waEg3x0cKakraCyIxh8Txz6Dpn6uFCP8bak2J04bKnDjFM9q+kySxxr48YWX
	ILlRbOm5JKrekDs53S3fRUQkYjk0DhXQ4tfvLDy2hV+wVNCO5XgFU1oUTsEJ8ysHIqNF5k
	odflMM1ljxjMWrSHvnNayRZtCNqpWs0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5iofLpm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788250288;
	b=rTCStmZBlImPwDGFD/WaV8JbUiRqC5PSW4je3SjE7swTrLTDxPCCu1cF6rK9V9XGxIPnr8
	VLY4MY7TwmELobA1u0a72ld81JFp/5dPKaV00V9uiMt+lrt03wCabE1PGPtqoPdeQnKOEf
	6aw32Wjyy3ANiC7NLOzVDmWOoaGrSro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37DA960209;
	Tue,  1 Sep 2026 08:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7051F00A3D;
	Tue,  1 Sep 2026 08:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788250287;
	bh=wRO50+DIeZsljZuDqKqgAEET3v+I4IRVdzWP9syTz0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m5iofLpm80amO782ShFaFem4kHLHX4bdEWuvGzSjNE5DDDlO8S3l1HNwcHE6lZ2OC
	 T5OVcDmKwiQ8bfEaFcsFyYEzcOPkLO2xff0C5Cj0XAesJDyLLtpitqjBgTq2MBoadR
	 EVrRP99Hyl7/usP5MWsbaBuT79vS4S1VPNkMQ6IvKTjchODTZ6MiSqyJ2K84Rje5JJ
	 61LXit7jEEQRwSIUTwjdc+3nMlEewO5cp9snjuqCAdJU4wnFd2dGCUC1O+39luWvSz
	 Gf90RBl/5Mdl9ZJGJeHR1mzyUMCEehJORKDujY4z2EW0CqIPhhvmzdCXaIHurNkkvb
	 rRtq4+wGtE9+A==
Date: Tue, 1 Sep 2026 09:10:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup filtering
Message-ID: <apaG83-HCFTuASQ_@lucifer>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
 <apEx0wT_hWs1Q5Wp@gremlin>
 <20260828113654.d01abd8baed3f73e87506eb3@linux-foundation.org>
 <9fce3210-3548-4df3-ae00-730b666f5d57@easystack.cn>
 <apZ99NHTmNI_nIwz@gremlin>
 <ff7d838c-8ea7-4a91-86bc-f6899970cdcf@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff7d838c-8ea7-4a91-86bc-f6899970cdcf@easystack.cn>
X-Stat-Signature: no13om4ygsyaptopy6cxn4uukqkr7qt6
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD2E4C0007
X-Rspam-User: 
X-HE-Tag: 1788250288-821794
X-HE-Meta: U2FsdGVkX1+Mls1u+aqjM+6wkeFAl3iK1p8Hds+il0qIoMMUwGsAcGfrf4K89Hc4txXBQn9mzmLLeXe+Qh3r54Haf/yKxzgU0gXW0vP7famziPBcjWf4HLQpEWE9UEDr63Dt7fNeNXgP/U48+UpJNmT+8fPjwjKBfjqRJgjEpGTOaocQvowUtSK2P+im4OdPmVZE+jGxoXcKiJcLpNKdJGS7Yt5Emuy5b7YZoO6SDE3t1+PhJsDyDRqYtoaFiXxbLi25jNLmBMqly/UvNgbzouWDdnFaPYPa4IAwwrYlqbEwk9Q2c6yTXmCO4PDq+RkaXbeGnEnOFNirJxGbuFpUK0ou0dFcAdYc8x0baxEl+M3NRVDJBbf7fWiP9c6/4FX65qsfvBPMKZmTrZxICh4bvyLrdsdwbGxNoIdSzgNJvXFA+R5EV2srid+WuZNG4JzAm6JwShDxdcJ8dZyJdKOuWZO/1mz+g92UogJAcnLSmsDJ+0OdKKhp8SGbEsmY+uabta1jlHd3Og3hV/3tB0GwsG333xBmEhGPSOuFs0ABKW8bsMaXSO0mXa/AcqpiErtQNf3MLIeZOaSdxsjYhDzX2W6az8UVvO0EUOJnGYsOTX8NpRQRHT1BNXbXcNz+loupNJPknJwaeLd0isF1d5iSUuLVqmF4y3QRerbPZSVcHnQd0dlObdwMikCurFv/mS8NuCF5GLw2j/qse1dnE241jEtIFuZEuebkXfeuv+8y+/kgAmXJNFj8/hUeCbPQ8PqUIRKD719N+vK9pVmUjKCkLG6B7UL6Zl7xTPA+Gb2bbREZj2iG/nM+GsRAs2oRo5cStyKAySNN+S+f36R2EaNTwFrHI5qv8RucV2zz7rVnh0Hv68gRxRVQUI1+5ardxaxpvwf+QDLj1l7PqNo2Edgb5nwiukL5UAZ+6gzUEOVXxHWccpUsbj1mot41PLgfo3UGgiTduja+Bnb9ctS1DCt
 3AzmVDfJ
 eOee5bsuc/a8Li9bnT+RktsQp06/41+PfKA25xvo9DisiyB4t1q1mivUoKwfr3+iRPBP1UhJhu+SEugOJKDi7OqPpUv7FfmxOlDP+/k9YJgcAJpGGO4OdUVwnVIDGmwP5nyysOTK7876iUxBoVwUJtpf6P6yxPCj5U970p5fmYhorZ4OqMbi5lAU+XB5ritNca/VEBXMzak+dQ2P6mbgM0IzNyJpFTsQP5tvvdP1mDl+pXf4zG93u20qEULChincgvLpJeD0kxsjj85GlaSvxgkzo2nzftcDBe3gtH98JsmLViyGySjuE5TM/3tmmQD/0uB+qX1xgOx6MVHCjXkTvvaC0apcUEd4E9CDowG7SRvaGypnsRdXJ2laOQno9vEJIVJardkE/bCPy0oZT2RpeYwOp74++TPdoTW9xaq8XN5Sb/P2JFs6zq7GrEbmPRDciaomOcytQZwQz5yU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 04:01:20PM +0800, zhen.ni wrote:
>
>
> 在 2026/9/1 15:27, Lorenzo Stoakes (ARM) 写道:
> > On Tue, Sep 01, 2026 at 02:34:34PM +0800, zhen.ni wrote:
> > >
> > >
> > > 在 2026/8/29 02:36, Andrew Morton 写道:
> > > > On Fri, 28 Aug 2026 08:03:38 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > > >
> > > > > On Fri, Aug 28, 2026 at 11:13:31AM +0800, Zhen Ni wrote:
> > > > > > This patch series adds process and memory cgroup filtering support to
> > > > > > page_owner. Following the previous series that introduced print_mode and
> > > > > > NUMA node filters:
> > > > > >     https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
> > > > > >
> > > > > > This series adds filtering capabilities to page_owner, allowing users to
> > > > > > filter output by specific processes and memory cgroups. Users can now
> > > > > > filter page_owner output by PID, TGID, COMM (with wildcard support), and
> > > > > > memory cgroup path. This makes page_owner debugging more focused and
> > > > > > efficient for tracking memory allocations in specific contexts.
> > > > >
> > > > > The majority of this cover letter feels like it should have been
> > > > > documentation put somewhere :)
> > > >
> > > > yes please.
> > > >
> > > > The only thing longer than the cover letter is the Sashiko report ;)
> > > >
> > > > 	https://sashiko.dev/#/patchset/20260828031339.1270699-1-zhen.ni@easystack.cn
> > > >
> > > >
> > >
> > > Hi Andrew, Lorenzo,
> > >
> > > Thanks for the review.
> > >
> > > I have analyzed all the Sashiko report findings. Some will be fixed in
> > > the next version, and for the rest I propose not to fix them, with
> > > reasons below. If there are no objections I will send v2 accordingly.
> > >
> > > Will be fixed in the next version:
> > >
> > > - mm/page_owner.c: drop the kstrdup() copy in parse_pid_t_list(); the
> > >    token will be parsed in place. This also fixes a leak on the success
> > >    path and a kfree() of an advanced (interior) pointer on the error
> > >    path. cmp_int() will replace plain subtraction in cmp_pid_t(), and
> > >    pid values exceeding PID_MAX_LIMIT will be rejected.
> > > - mm/page_owner.c: PAGE_OWNER will select GLOB so glob_match() is
> > >    always linked in; parse_comm_list() will drop its kstrdup() copy the
> > >    same way.
> > > - mm/page_owner.c: the cgroup path buffer will be allocated once per
> > >    read() outside the page_ext RCU read-side critical section instead of
> > >    per page inside get_page_memcg_info() (GFP_KERNEL allocations must
> > >    not sleep there). The memcg= parsing branch will be guarded by
> > >    CONFIG_MEMCG so kernels built without memcg reject the command
> > >    instead of silently enabling a filter that never matches.
> > > - tools/mm/page_owner_filter.c: user-visible input errors (empty
> > >    -p/-t/-c/-g arguments) will print error messages instead of exiting
> > >    silently.
> > > - Documentation: the wildcard pattern in the -c example will be quoted
> > >    to prevent shell glob expansion.
> > >
> > > Proposed not to fix, by design:
> > >
> > > 1. Shared-fd concurrent read/write races (READ_ONCE around the pid
> > >     passed to bsearch, torn reads of pid/tgid lists, glob_match() racing
> > >     comm rewrites, concurrent write() leading to state->memcg_path
> > >     double-allocation): multi-threaded sharing of one page_owner fd is
> > >     not a designed use of this interface. The filters are per-fd state
> > >     meant to be configured once and then read, which is what the
> > >     page_owner_filter tool does. Adding locking to the read path would
> > >     put overhead into the per-page scan loop for no designed benefit.
> > >     This matches the semantics of the original filter introduction.
> > >
> > > 2. No "clear filter" support (empty pid=/tgid= lists partially clearing
> > >     proc filters, empty memcg=/nid= being rejected): write commands are
> > >     incremental -- "keep the unmentioned filters" -- and there is no
> > >     clear operation by design. To start over, close the fd and open a
> > >     fresh one; the page_owner_filter tool already works this way. This
> > >     also matches the semantics of the original filter introduction.
> > >
> > > 3. kcalloc() vs kmalloc_array() for new_comm_list: no consumer of the
> > >     list reads past strscpy()'s NUL terminator, so uninitialized bytes
> > >     are unreachable.
> > >
> > > 4. char cgroup_path[512] in validate_cgroup_path(): acknowledged that
> > >     the kernel side accepts paths up to PATH_MAX (4096). The userspace
> > >     check truncates an over-long path with snprintf() and then fails
> > >     access(), so it is rejected, never silently accepted. Bumping the
> > >     buffer to PATH_MAX would only serve pathological paths; realistic
> > >     cgroup paths are well under 100 bytes, so 512 wastes nothing in
> > >     practice.
> > >
> > > If this plan looks reasonable I will send v2.
> >
> > Sorry but this kind of 'summary', 'do you agree with the plan' email is not
> > acceptable.
> >
> > You have your feedback, reply to people like a human being directly to them,
> > thank you very much.
> >
> > At this point, based on past experience, I have to ask if you're using an LLM?
> > If so please disclose this as per kernel guidelines:
> >
> > https://docs.kernel.org/process/coding-assistants.html
> > https://docs.kernel.org/process/generated-content.html
> >
> > >
> > > Thanks,
> > > Zhen Ni
> >
> > --
> > Cheers, Lorenzo
> >
> >
> Hi, Lorenzo
>
> I honestly don't understand what is wrong here. I spent two full days
> going through every single finding in the Sashiko report one by one,
> checking each against the code. In fact I am already working on v2 and
> testing the corresponding changes. What I don't understand is what
> "this kind of 'summary' email is not acceptable" is supposed to mean.
>
> If you disagree with any specific item, name it and we can discuss it
> -- but rejecting the whole thing outright, with just two documentation
> links and no specifics, is not something I can act on.

Again you're failing to reply to kernel email in the usual style, and it's
on you to figure out how to do that, not me.

Reply, inline, to what people have said to you.

Do NOT ask them to read through your 'plan' document and give yet more of
their time to compensate for you not following basic kernel procedure.

I have done hundreds (>1,000?) hrs of review upstream and I have only seen
these kinds of 'summary - plan' emails since 2026.

I am only asking you to engage upstream as everybody else does.

Since you ignored it, I ask you again - have you used an LLM here? If so
follow kernel procedure as per the documentation I linked.

>
> Thanks,
> Zhen

--
Cheers, Lorenzo

