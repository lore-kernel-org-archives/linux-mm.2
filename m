Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AC4606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LKLewB+j
Received: by kanga.kvack.org (Postfix)
	id 02BD56B05BD; Wed, 11 Nov 2026 03:19:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9016B05BB; Wed, 11 Nov 2026 03:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F706B05BC; Wed, 11 Nov 2026 03:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B32356B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:19:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 868E180214
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:12:52 +0000 (UTC)
X-FDA: 85422122184.06.4586E98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9A97A0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:12:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKLewB+j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqYu+xo/RGd/fLeZ6KK9QI6PGDCPVZsf1WvEjBr3Jhs=;
	b=trWVJ4CGZMrZ0FIZ87UrtSl0fIyUuULBMi0QCXXpCikYYffsDIzyx9FwLI1sLOHNNEKh4e
	JiFXEXwvXOvRitlMj2/CbTLcRzDeGtKSmS+nLrhp5sumGZJzjaWUasqHxCi8enTSFAtPWo
	k+kFUQur1c3dJtHU9wcZSDhAqX79QG0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKLewB+j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384770;
	b=FLdR6XnHUprcdTeXBZyaSDzW7eWf45l61kKe9qC2GVTYwApO9q4fjxlOmDgGwXuCEHMiPX
	QxE4fs8KyvEk9nAVf7qMOMMf3DaqVkhWOfTnfEivNU3bwib1R8LRMY4HTiOUh891q08alX
	NwE+5tNH1blM4CxCfMbs+9UTpfb7E08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6DBD400D6;
	Wed, 11 Nov 2026 08:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4511F00A05;
	Wed, 11 Nov 2026 08:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384769;
	bh=QqYu+xo/RGd/fLeZ6KK9QI6PGDCPVZsf1WvEjBr3Jhs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LKLewB+jFjOgi49f2xKrvF7D8P0iWQtbBLAze1EBM2isZVVp+26Z1/lcrvLm+d5/o
	 jtFPL8EXgK9BU4HMO59P6H+yflloVKcsfqC6kdSttu5Kbf7sDy8h4jh14tU75lU7H9
	 aFeUVwMpFZ5Pk/es63ZNogDXe93CKhgsYAGx/+JZNF2faFpW84IkRs4JKbLFNocANP
	 sZwapAdEy4uANCFM/FCHDmG36MDostBXfW61L7EAPEfRCfH9vvl3oGmIq5WZVxcRCP
	 m8C73X10pt0u7GWfyEHW7282WvTTdv6sYpsM16sjMYy4q1zPwmujeUaSl/Lm27Bv/9
	 q/E6aoHbCZcjg==
Message-ID: <3f761a27-74df-4e19-878b-323164da5a69@kernel.org>
Date: Wed, 11 Nov 2026 09:12:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] pipe: Prefer mempolicy node for metadata allocations
To: Andrea Righi <arighi@nvidia.com>, Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Quan Liu <qualiu@nvidia.com>,
 Lee Trager <ltrager@nvidia.com>, Seth Forshee <sforshee@nvidia.com>,
 Gregory Price <gourry@gourry.net>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
References: <20261110065219.894219-1-arighi@nvidia.com>
 <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
 <avQP1aXhe7nQuzt9@gpd4>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <avQP1aXhe7nQuzt9@gpd4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9A97A0004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: uij9zc7gmfppkhma87juoc6eg9t3kkok
X-HE-Tag: 1794384770-31125
X-HE-Meta: U2FsdGVkX1+8jkpYgcYvyvLDcyuvXp8Gz9xVcXgNYmi8wrvjAlH0reW1JOmLMI/vxctRQoP0fNHkX5XmvqkvkTs2AWO/eWXreRkBa5+TZbNKU7mosCTlLHzUHlRtMxuq7RRORSgQSGeKXr+a6kyukdb6I4PWtu8d4rMFHseyyrO/RAmQDhzInNcmiYEnReP9OIr2OHJipVn3rYm0qNjYwhUnxgjcAqDXruZbjTUIha8Qv0ph1zGtHWdTSfxopLAgpebUMJttGAfHBxePgKR09mizhaV/cZdcZRwDXZFz/9/baRYO5e4eDmdPOcE/l+uYDEisr8pDWULY3bNVJfSHPlmbwbW2dEGhTCdHG5JHzckm5rWusFchAOrA2UJXzNofoWHrlZeJpm8eUUtQ9PQDiJwAdnD78FAXcTiOIVDxfpA9PzMmW64MXVKlzD/9OYssKtLFT9jPiYb+mKYM0dgG8YM478sQlUbEL0d0XklFPKbIu/Ghg9ulwWj1EViZreuCXMZZkQwJLDmV4T7a600HAONPCgLkj56IemHliJ3RLsMlsv2u+JK6PxA0/AwgqpDozQUqe15pB4/GKRlM0SGmglGVJj97HoeENAPjue8VzgNqIfiiSHHYTXrhnaBg/tP5J3xrur1+1p9Su40Rj/TTUNmwWqxG+XIyuYez9tJc9+0JJLW0lvq4L3+njiboRHlFacIePENbo0HLQXGhl7ZFDWmjgA8rG6pkcGOZnWIQDMt+uuIzYIkIN70G++fbSeX9WlU5WaJ4lDzsmpKN0+SsJD/nYwBRA/XI2jmq3U+BeY0d7ytyRrWTgMb6gP49dxohXgcM7jY7JKOZfLPNnnv1jEMcjmFvrVbUZ1ZIi98tmewaR0gCosJcHST1IoKmDHQPe4X9KDxRlM9z6RYJycHBxX4PB4JGINfdV3NA1oNt3t7Q8rCYmX+QlBY2BY50blXDw1GF9sI2a3S12ZtW22y
 dKoGaPyp
 frQiPeOUykU0v+MkZH/pIdcX/L+YRi6cRXsOP7tlx3p0s+azgv2z80Et/k8lm+tA43h/j+YLgqlXhx1R5j5SzpJuCMUUW+cOg3+JyHDAGabGdk1lmzdbO6oX2YFmORnkqFpLYeE8A418/gv5XjWhQvpngtB0m0vfWlUHQtu58XjLoZ7kk3RmiCQTzmMaxcb7z/B9LQVJJX6OfUshWfpHiZiixSQifubcPzBta+mZa2IclNkdvNGe5ezlfj+VxkMuAvMNtJ1FL8oIjU7wWz9HuL/4IFdFuQthB7fQmA8k1NMUoZxWoCrEM4eYBGL3HaoXYA7xvgzv8lUWleoj+z9JNwu5mZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 07:48, Andrea Righi wrote:
> Hi Jan,
> 
> On Tue, Nov 10, 2026 at 01:27:53PM +0100, Jan Kara wrote:
>> On Tue 10-11-26 07:52:19, Andrea Righi wrote:
>> > Generic slab allocations can reuse partial slabs from another NUMA node,
>> > even when a pipe workload is bound to one node. Pipe metadata is shared
>> > between senders and receivers and accessed throughout the pipe lifetime.
>> > Reusing remote metadata can therefore make an IPC workload pay remote
>> > access and coherence costs on every exchange.
>> > 
>> > The target use case is a workload that binds its workers and memory to
>> > one NUMA node with numactl. The policy node is then a useful placement
>> > hint for shared pipe metadata.
>> > 
>> > Allocate pipe_inode_info and its descriptor array on the node selected
>> > by the caller's memory policy. Apply the same preference when replacing
>> > slab-sized descriptor arrays during ring resizing. An explicit node lets
>> > SLUB try local allocations before reusing remote partial slabs.
>> > 
>> > For descriptor arrays larger than KMALLOC_MAX_CACHE_SIZE, pass
>> > NUMA_NO_NODE to keep the policy-aware page allocation path. An explicit
>> > node would otherwise lose the MPOL_BIND nodemask on fallback. Select the
>> > policy node only for slab-sized arrays, avoiding an extra advance of an
>> > interleave policy for large allocations.
>> > 
>> > Moving a pipe's users to another node doesn't migrate its existing
>> > metadata, so migration can still result in remote accesses regardless of
>> > this change. Generic allocations may reuse remote partial slabs, making
>> > initial placement dependent on allocator state. In contrast, preferring
>> > the policy node leverages the workload's placement hint to improve
>> > locality when users remain on the intended node.
>> > 
>> > Testing has been performed on a dual-socket NVIDIA Vera system, covering
>> > hackbench, pipe transfers, pipe creation and resizing, pipe_bench, and
>> > targeted stress tests.
>> > 
>> > The primary hackbench reproducer is:
>> > 
>> >   $ numactl --physcpubind=0-87 --membind=0 \
>> >       hackbench -P -p -g 10 -f 20 -s 100 -l 100000
>> > 
>> > Results (over 10 measured runs per case):
>> > 
>> >               avg       stdev
>> >    before     9.811s    0.130s
>> >    after      5.770s    0.058s
>> > 
>> > Before this change, allocations could reuse remote pipe metadata. With
>> > this change, both pipe objects and descriptor arrays are allocated on
>> > the requested node, improving locality and reducing hackbench runtime by
>> > approximately 41%.
>> > 
>> > Reported-by: Quan Liu <qualiu@nvidia.com>
>> > Signed-off-by: Andrea Righi <arighi@nvidia.com>
>> 
>> To me this makes sense so feel free to add:
>> 
>> Acked-by: Jan Kara <jack@suse.cz>
>> 
>> But IMHO it deserves a look from MM guys since this is more of an MM thing
>> than a filesystem one... Added to CC.
> 
> Thanks for taking a look, and good point about getting MM feedback.
> 
> Vlastimil, Gregory, do you think this SLUB locality and mempolicy
> aspects makes sense here? In particular, does preferring the policy node
> for slab-sized pipe metadata, while retaining the policy-aware path for
> larger arrays, look reasonable?

It's not wrong, but feels a bit ad-hoc. If it's pipe metadata now, what's next?

Slab will generally return objects from the cpu's local node even if it's
not specified. It's not guaranteed, but it's not guaranteed also when it's
specified by kmalloc_node() (unless __GFP_THISNODE forces it).

So the results above are surprising to me. Are they on recent kernels? Are
cpus 0-87 all local to node 0, or is membind 0 there to force a node that's
not local to some of them? If they are all local, I would expect the objects
to be from node 0 even without kmalloc_node(). So maybe we have some unknown
deficiency that should be investigated.

Also note that it's possible to force this behavior of respecting mempolicy
for all slab objects, usigng the slab_strict_numa boot parameter. AFAIK this
was added for systems where the interconnect makes remote accesses
especially costly.

> Thanks,
> -Andrea
> 
>> 
>> 								Honza
>> 
>> > ---
>> >  fs/pipe.c | 26 ++++++++++++++++++++++----
>> >  1 file changed, 22 insertions(+), 4 deletions(-)
>> > 
>> > diff --git a/fs/pipe.c b/fs/pipe.c
>> > index 4fa69192e6fba..2a8f9e9f70f84 100644
>> > --- a/fs/pipe.c
>> > +++ b/fs/pipe.c
>> > @@ -24,6 +24,7 @@
>> >  #include <linux/syscalls.h>
>> >  #include <linux/fcntl.h>
>> >  #include <linux/memcontrol.h>
>> > +#include <linux/mempolicy.h>
>> >  #include <linux/watch_queue.h>
>> >  #include <linux/sysctl.h>
>> >  #include <linux/sort.h>
>> > @@ -874,6 +875,16 @@ bool pipe_is_unprivileged_user(void)
>> >  	return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
>> >  }
>> >  
>> > +/* Prefer the policy node over remote partial slabs, retaining fallback. */
>> > +static int pipe_slab_node(void)
>> > +{
>> > +#ifdef CONFIG_NUMA
>> > +	return mempolicy_slab_node();
>> > +#else
>> > +	return NUMA_NO_NODE;
>> > +#endif
>> > +}
>> > +
>> >  struct pipe_inode_info *alloc_pipe_info(void)
>> >  {
>> >  	struct pipe_inode_info *pipe;
>> > @@ -881,8 +892,9 @@ struct pipe_inode_info *alloc_pipe_info(void)
>> >  	struct user_struct *user = get_current_user();
>> >  	unsigned long user_bufs;
>> >  	unsigned int max_size = READ_ONCE(pipe_max_size);
>> > +	int node = pipe_slab_node();
>> >  
>> > -	pipe = kzalloc_obj(struct pipe_inode_info, GFP_KERNEL_ACCOUNT);
>> > +	pipe = kzalloc_node(sizeof(*pipe), GFP_KERNEL_ACCOUNT, node);
>> >  	if (pipe == NULL)
>> >  		goto out_free_uid;
>> >  
>> > @@ -899,8 +911,8 @@ struct pipe_inode_info *alloc_pipe_info(void)
>> >  	if (too_many_pipe_buffers_hard(user_bufs) && pipe_is_unprivileged_user())
>> >  		goto out_revert_acct;
>> >  
>> > -	pipe->bufs = kzalloc_objs(struct pipe_buffer, pipe_bufs,
>> > -				  GFP_KERNEL_ACCOUNT);
>> > +	pipe->bufs = kcalloc_node(pipe_bufs, sizeof(*pipe->bufs),
>> > +				  GFP_KERNEL_ACCOUNT, node);
>> >  
>> >  	if (pipe->bufs) {
>> >  		init_waitqueue_head(&pipe->rd_wait);
>> > @@ -1375,12 +1387,18 @@ int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
>> >  {
>> >  	struct pipe_buffer *bufs;
>> >  	unsigned int head, tail, mask, n;
>> > +	int node = NUMA_NO_NODE;
>> >  
>> >  	/* nr_slots larger than limits of pipe->{head,tail} */
>> >  	if (unlikely(nr_slots > (pipe_index_t)-1u))
>> >  		return -EINVAL;
>> >  
>> > -	bufs = kzalloc_objs(*bufs, nr_slots, GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
>> > +	/* Keep the policy nodemask for allocations that bypass slab caches. */
>> > +	if (nr_slots <= KMALLOC_MAX_CACHE_SIZE / sizeof(*bufs))
>> > +		node = pipe_slab_node();
>> > +
>> > +	bufs = kcalloc_node(nr_slots, sizeof(*bufs),
>> > +			    GFP_KERNEL_ACCOUNT | __GFP_NOWARN, node);
>> >  	if (unlikely(!bufs))
>> >  		return -ENOMEM;
>> >  
>> > -- 
>> > 2.56.0
>> > 
>> -- 
>> Jan Kara <jack@suse.com>
>> SUSE Labs, CR
>> 


