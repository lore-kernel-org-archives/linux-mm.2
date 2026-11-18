Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBCE2606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NIUiK7Rv
Received: by kanga.kvack.org (Postfix)
	id 9659F6B05B1; Wed, 18 Nov 2026 09:24:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D646B05B4; Wed, 18 Nov 2026 09:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D126B05BC; Wed, 18 Nov 2026 09:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 575BB6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:24:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDDEF16079D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:24:10 +0000 (UTC)
X-FDA: 85448459460.03.72BB310
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1F640120008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:24:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIUiK7Rv;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795011849;
	b=L3EOmQGtZgGjQ0SPCvcVY15fz3emEll7wJkbdqTZO4rgMl9SfJ/S9I+RT/2t0ujcVmxr2f
	3aaNsxBLn0wRp+xMsEmIkEHBSFvJo765kCDUpW8ogrB4oW9HFg2fRKmhiJmL7Og2f9e5dX
	wEeJSvHKs01bntqCrfJkkE5B22iOG8I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIUiK7Rv;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795011849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZdzSCgsRvkNzRiNjPVo0o/oxE/zlObykDoHIoaUBhY=;
	b=41VzYXNMnkdUQIi9uZgqZIy+v/gmdINWOs89JwZ+HELDQB5qeCGAnEGTgAZ/kKpoLQktH9
	Y9bu8tOrSk7GoD4SG6toP9vQ9XOfHcnHcl3UmZMTzSiCgXL3U4zXhj0NkAVWlDdHAAnsVQ
	KhHMjJ0YN47SXT21i5Eb2y6hxLZXNNA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FC2143E3A;
	Wed, 18 Nov 2026 14:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426821F000C5;
	Wed, 18 Nov 2026 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795011848;
	bh=8ZdzSCgsRvkNzRiNjPVo0o/oxE/zlObykDoHIoaUBhY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NIUiK7RvQVr6i5MGDFzkFKDh20ILSZgmJrJEowRkhmrMSYvpe2tMOQl2taHixDS+y
	 Dqr1E84Oc/LnsE0VGboz5y8NFpCdl3vbRBz5TmMgengXKqPWI7mJSq0bBpZ28Qn6Lv
	 xPAcQum/HZG7tVfi63mmeSG2xc02AWCJ4zspbrENSvaTBjyXIdSm8Fgr2YuSMU1pji
	 G1al4zcNz/r70jJpCUssAzPSInRdq+MT9SZW5JEC5a2nC4A/odpSpm1/A+Zx/OSMGr
	 YqcPefStadbYuUvgJQ7ba3GfdLhXhub/1RkLkEXGzAVehQz4xarnjc7WEZC5G+LLCH
	 po8JTbBzmqVDw==
Message-ID: <eae20ada-01a0-4583-8c65-8f7b5c71cd0f@kernel.org>
Date: Wed, 18 Nov 2026 15:24:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] pipe: Prefer mempolicy node for metadata allocations
Content-Language: en-US
To: Andrea Righi <arighi@nvidia.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Quan Liu <qualiu@nvidia.com>,
 Lee Trager <ltrager@nvidia.com>, Seth Forshee <sforshee@nvidia.com>,
 Gregory Price <gourry@gourry.net>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>
References: <20261110065219.894219-1-arighi@nvidia.com>
 <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
 <avQP1aXhe7nQuzt9@gpd4> <3f761a27-74df-4e19-878b-323164da5a69@kernel.org>
 <av2rqSzkvZYQRgAA@gpd4>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <av2rqSzkvZYQRgAA@gpd4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F640120008
X-Stat-Signature: peiwhofrs6jequojaz7yg55r7eew3i3z
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795011848-854043
X-HE-Meta: U2FsdGVkX19Fh6a/XCt+tb8datSbbs7OX0qtQ3VE4qqDlCTlDCXfsv5hjf/zpzUubIa0j2VKw7qB5rEqWwQNm77HMgqBlhhnc0Ohk14C93Qb1r22cUeDp3pXaFwg1n6toP56QllY0IyP82FOCovlp5qpLcAFn5resjvJHm8IfyAcHW5AMvZX3UDqPKT/NA4HI5fggRGnCjRkK9xHQ9u1u7PNpd8i5RuVwKBk012NljIbhcakEXcQi8rBNodBoBdo8+GBm6RRR7XseMq2RC7Tlmp9WkM8c2uBdaGs75HjjyTsmK9emaBj4lEI8ec6xRDy9JTZtPZmUj90bjz6yoxWcm/eyIlE8S1TGpX473pTKjRNNOXy8qBbGLhf7uVdZrHkv1pRYz+8mS6raB7GEyVcXmlrHPXuKkbXAhiNEaeh1NBI7Qgk0bi4U6V4SD4w5x81q6AOsbUWS/dIJ5nAjizqoV83pHnB7KaMbhX4ml1YVPcyzCPvmfDBaVz/JownJzsiY+/DK3y9gFeZQxvHvqzvdCnb7igw9smLlrSaaTQby+5Rq7VkW547AX9j4GQPqSbK7GtK8eJSIA1JIq1Yugbf6f8STEAfavIom6ALwf+O8E3HDaN+kaIQYsR4XQlKGPgPAYi/UHt4pIZAGSFHS+GmqKnN25oyVuqfrO4CkgTac9WA6Rqtq8InTkPFnE1My/cmZpRG2Wf3j/ZgR9OcgkXjNH3e95h7F/97VCHPIOyEnMi+IL5jHj9Bq43sg3LMv6TFecxhVSTJFel2Zufz5lAQyy9WKeMDYR58mRHF4Fb4AryVxkEB3k5tfyWzu6/B9+Os3FU481MRFd2fR/x12bUzbhGTrKXZQ23KOMV72i9nHtLICqzKOE//+64KlPqhhhUlKwdA7CK6m/iwtfn7dYfiMQEHzkGQHSTMazpmYmqJ9cxufmtnUJ2uOcX1wHG751+kfWC7F9k4AKdGj2RndEW
 PJumk1HV
 gMpdpovrT3gc7xMb+OAGvU+/8ciq/o7qKl9T6uIfH7f3LL44APdlec0INZZrpTRvCkJL3HDypF1vL5PUbALdpbRQCXSbq83yZtNm3zyPfAlN8YZ2OTzkqmHNunVxR8xkzsRtPHirnqV2qPcZVxyDLihrrLyOoE2qJ3EnO/cc0U5bkeYrVEDQnlBjy9tft4bClUydWjNIyOX73mTP1l6oPoau2Aq1ybvH31/8p8Cj9hH40HQkCTc3gBVylOJQv9MYKnTNYpi65tttOvAMThfO1XmLMuynuxVeCPEzi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 14:44, Andrea Righi wrote:
> Hi Vlastimil,
> 
> thanks for taking a look and sorry for the late reply. Comments below.
> 
> On Wed, Nov 11, 2026 at 09:12:44AM +0100, Vlastimil Babka (SUSE) wrote:
>> On 11/11/26 07:48, Andrea Righi wrote:
>> > Hi Jan,
>> > 
>> > On Tue, Nov 10, 2026 at 01:27:53PM +0100, Jan Kara wrote:
>> >> On Tue 10-11-26 07:52:19, Andrea Righi wrote:
>> >> > Generic slab allocations can reuse partial slabs from another NUMA node,
>> >> > even when a pipe workload is bound to one node. Pipe metadata is shared
>> >> > between senders and receivers and accessed throughout the pipe lifetime.
>> >> > Reusing remote metadata can therefore make an IPC workload pay remote
>> >> > access and coherence costs on every exchange.
>> >> > 
>> >> > The target use case is a workload that binds its workers and memory to
>> >> > one NUMA node with numactl. The policy node is then a useful placement
>> >> > hint for shared pipe metadata.
>> >> > 
>> >> > Allocate pipe_inode_info and its descriptor array on the node selected
>> >> > by the caller's memory policy. Apply the same preference when replacing
>> >> > slab-sized descriptor arrays during ring resizing. An explicit node lets
>> >> > SLUB try local allocations before reusing remote partial slabs.
>> >> > 
>> >> > For descriptor arrays larger than KMALLOC_MAX_CACHE_SIZE, pass
>> >> > NUMA_NO_NODE to keep the policy-aware page allocation path. An explicit
>> >> > node would otherwise lose the MPOL_BIND nodemask on fallback. Select the
>> >> > policy node only for slab-sized arrays, avoiding an extra advance of an
>> >> > interleave policy for large allocations.
>> >> > 
>> >> > Moving a pipe's users to another node doesn't migrate its existing
>> >> > metadata, so migration can still result in remote accesses regardless of
>> >> > this change. Generic allocations may reuse remote partial slabs, making
>> >> > initial placement dependent on allocator state. In contrast, preferring
>> >> > the policy node leverages the workload's placement hint to improve
>> >> > locality when users remain on the intended node.
>> >> > 
>> >> > Testing has been performed on a dual-socket NVIDIA Vera system, covering
>> >> > hackbench, pipe transfers, pipe creation and resizing, pipe_bench, and
>> >> > targeted stress tests.
>> >> > 
>> >> > The primary hackbench reproducer is:
>> >> > 
>> >> >   $ numactl --physcpubind=0-87 --membind=0 \
>> >> >       hackbench -P -p -g 10 -f 20 -s 100 -l 100000
>> >> > 
>> >> > Results (over 10 measured runs per case):
>> >> > 
>> >> >               avg       stdev
>> >> >    before     9.811s    0.130s
>> >> >    after      5.770s    0.058s
>> >> > 
>> >> > Before this change, allocations could reuse remote pipe metadata. With
>> >> > this change, both pipe objects and descriptor arrays are allocated on
>> >> > the requested node, improving locality and reducing hackbench runtime by
>> >> > approximately 41%.
>> >> > 
>> >> > Reported-by: Quan Liu <qualiu@nvidia.com>
>> >> > Signed-off-by: Andrea Righi <arighi@nvidia.com>
>> >> 
>> >> To me this makes sense so feel free to add:
>> >> 
>> >> Acked-by: Jan Kara <jack@suse.cz>
>> >> 
>> >> But IMHO it deserves a look from MM guys since this is more of an MM thing
>> >> than a filesystem one... Added to CC.
>> > 
>> > Thanks for taking a look, and good point about getting MM feedback.
>> > 
>> > Vlastimil, Gregory, do you think this SLUB locality and mempolicy
>> > aspects makes sense here? In particular, does preferring the policy node
>> > for slab-sized pipe metadata, while retaining the policy-aware path for
>> > larger arrays, look reasonable?
>> 
>> It's not wrong, but feels a bit ad-hoc. If it's pipe metadata now, what's next?
> 
> Agreed, after looking deeper this isn't really a pipe problem, any slab
> user can hit it, so it should probably be addressed in slab.
> 
>> 
>> Slab will generally return objects from the cpu's local node even if it's
>> not specified. It's not guaranteed, but it's not guaranteed also when it's
>> specified by kmalloc_node() (unless __GFP_THISNODE forces it).
>> 
>> So the results above are surprising to me. Are they on recent kernels? Are
>> cpus 0-87 all local to node 0, or is membind 0 there to force a node that's
>> not local to some of them? If they are all local, I would expect the objects
>> to be from node 0 even without kmalloc_node(). So maybe we have some unknown
>> deficiency that should be investigated.
> 
> The results were collected on 7.4-rc1 and I've reproduced them in
> 7.4-rc2. CPUs 0-87 are all local to node 0 (node 0 has CPUs 0-87 and
> their SMT siblings 176-263, node 1 has 88-175 and 264-351).
> 
> I should have been clearer about the setup and the results I reported:
> numbers were collected after seeding the slab state to make the problem
> more reproducible. Before each run, a helper holds ~4K pipes created on

Yeah that important part of the setup should be always stated...

> a node 0 CPU, then it creates 1K pipes on a node 1 CPU and closes 7 out
> of 8 of them, leaving sparse partial slabs on node 1. Starting from a
> clean slab state, or with only the node 1 part, all objects are local
> and there's no difference, as you expected (100000 loops, 10 runs,
> placement traced with bpftrace):
> 
>                                          avg      stdev   remote objs/arrays
>   not seeded                             5.122s   0.027       0 / 0
>   seeded                                 9.730s   0.125    1606 / 1780
>   seeded, remote_node_defrag_ratio=0     5.101s   0.019       0 / 0
>   seeded, slab_strict_numa               9.889s   0.188    1624 / 1482
>   seeded, pipe patch                     5.112s   0.016       0 / 0
>   seeded, slab change below              5.106s   0.027       0 / 0
>   not seeded, slab change below          5.103s   0.036       0 / 0
> 
> When node 0 has no partial slabs, get_from_any_partial() and
> __refill_objects_any() take partial slabs from other nodes, and that
> scan only checks cpuset_zone_allowed(), not the task's MPOL_BIND
> nodemask.
> 
> The seeding is only there to make the problem deterministic, but it also
> happens without any artificial setup: right after a boot, without
> touching the caches, ~24% of the buffer arrays came from node 1 (7.30s
> vs 5.92s with remote_node_defrag_ratio=0).

I see.

> 
>> 
>> Also note that it's possible to force this behavior of respecting mempolicy
>> for all slab objects, usigng the slab_strict_numa boot parameter. AFAIK this
>> was added for systems where the interconnect makes remote accesses
>> especially costly.
> 
> I tried slab_strict_numa, but it doesn't seem to help in this case,
> because apply_strict_numa_policy() leaves the node as NUMA_NO_NODE when
> the policy is MPOL_BIND and the local node is in the mask, so the
> allocation still falls back to the remote partial scan.
> 
> A more generic fix could be to make the remote partial scan respect the
> bind nodemask. Do you think something like the following could be
> reasonable? (only tested with this workload so far)

Might be acceptable even without slab_strict_numa as it's a slowpath.
Perhaps mempolicy_slab_node() itself could set the nodemask if a non-NULL
"nodemask_t **" is passed.

> Thanks,
> -Andrea
> 
>  mm/slub.c | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index cd671b9347191..dd6f69cf2acdf 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3981,6 +3981,27 @@ static void *get_from_partial_node(struct kmem_cache *s,
>  	return object;
>  }
>  
> +#ifdef CONFIG_NUMA
> +/*
> + * Return the nodes allowed by the current task's bind policy, or NULL if
> + * the policy doesn't restrict them. Partial slabs on other nodes must not be
> + * used to satisfy an allocation that didn't request a specific node.
> + */
> +static nodemask_t *slab_bind_nodemask(void)
> +{
> +	struct mempolicy *mpol;
> +
> +	if (!in_task())
> +		return NULL;
> +
> +	mpol = current->mempolicy;
> +	if (mpol && mpol->mode == MPOL_BIND)
> +		return &mpol->nodes;
> +
> +	return NULL;
> +}
> +#endif
> +
>  /*
>   * Get an object from somewhere. Search in increasing NUMA distances.
>   */
> @@ -3994,6 +4015,7 @@ static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
>  	enum zone_type highest_zoneidx = gfp_zone(gfp_flags);
>  	unsigned int cpuset_mems_cookie;
>  	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
> +	nodemask_t *nodemask = slab_bind_nodemask();
>  
>  	/*
>  	 * The defrag ratio allows a configuration of the tradeoffs between
> @@ -4028,7 +4050,8 @@ static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
>  			cpuset_mems_cookie = read_mems_allowed_begin();
>  
>  		zonelist = node_zonelist(mempolicy_slab_node(), gfp_flags);
> -		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
> +		for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +						highest_zoneidx, nodemask) {
>  			struct kmem_cache_node *n;
>  
>  			n = get_node(s, zone_to_nid(zone));
> @@ -7466,6 +7489,7 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
>  	enum zone_type highest_zoneidx = gfp_zone(gfp);
>  	unsigned int cpuset_mems_cookie;
>  	unsigned int refilled = 0;
> +	nodemask_t *nodemask = slab_bind_nodemask();
>  
>  	/* see get_from_any_partial() for the defrag ratio description */
>  	if (!s->remote_node_defrag_ratio ||
> @@ -7475,7 +7499,8 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
>  	do {
>  		cpuset_mems_cookie = read_mems_allowed_begin();
>  		zonelist = node_zonelist(mempolicy_slab_node(), gfp);
> -		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
> +		for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +						highest_zoneidx, nodemask) {
>  			struct kmem_cache_node *n;
>  			unsigned int r;


