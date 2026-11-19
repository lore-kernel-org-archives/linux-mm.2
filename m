Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D9E606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j88J+/FV
Received: by kanga.kvack.org (Postfix)
	id 20B9A6B065A; Thu, 19 Nov 2026 08:44:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BDEA6B065B; Thu, 19 Nov 2026 08:44:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2CF6B065C; Thu, 19 Nov 2026 08:44:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D405D6B065A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:44:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3FCC80AAD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:44:46 +0000 (UTC)
X-FDA: 85451988972.02.E94A65D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 383D0100002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:44:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j88J+/FV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095885;
	b=CbVNRMhGVQyzZsgOUU49czvpdtOKjSvVZRWZxJjuUrFfMWinC3GfTAxanOZi36DX3cLcjF
	nbNcPsiGVufn4Itr6rxBH2Vdf39cY7g7PVU6ORAV04pJX+VpgSvt7lLKk8zUOwF2mZv8zT
	Yy6xkp2zBnUz7dX5CBtPHM5Qi45ExVk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095885;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8W+lbx6dVx3C2xSAd7XsiYYg14sFv3XMANsGUvj83ig=;
	b=JYErKxX2TbCLcG/jMi3axFDazv/OjBi7D8igfn/YCmd8AHXScag5FqTABIQNcFobkvSJMl
	XBoxkYnGRxNBtJfykr09Pu16C6rSCuSRRnM1/TfE+VT6Y1nJD23N7fYX4OUBrBo4OOwNWL
	Oqgr5x7cjoE4DO7jhCspkq4+x9MbdHg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j88J+/FV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84F8A41450;
	Thu, 19 Nov 2026 13:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF711F000C7;
	Thu, 19 Nov 2026 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795095884;
	bh=8W+lbx6dVx3C2xSAd7XsiYYg14sFv3XMANsGUvj83ig=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j88J+/FVLP1qlYvlkcWD1S6siR8+6oBAkz7qXkSzpVjyzQA8uGuJInKH27LUZRAjX
	 lmQEBDvcyPofl/JIAMkc1Sbnj5L0lWEgwuIBQxFfXsvqdwQI06WBYfCSeECX6xTMdi
	 Qa6ZfLKWUw4WVziNu6SI5xkJWBAbl5JtIMKfEy26+xYuWQEJ6Vta/3KIqnfvUhYg/3
	 j/b1tqERMkSMn6k7EDt5a8RjLB1Ly4vDa3BF4IDsr1+PQL15y8ZcWCa0FI+TE0hSma
	 icsV3RWGBALP+yO41k4ptSXjbr/aiahUTibQ4OXfFhJIxxlIa6zLHCCEsLKI+Hcyqy
	 CZhyIv3s7fP2g==
Message-ID: <sashiko-outbox-223201@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] pipe: Prefer mempolicy node for metadata allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrea Righi" <arighi@nvidia.com>, =?utf-8?b?Vmxhc3RpbWlsIEJhYmth?=
 =?utf-8?b?IChTVVNFKQ==?= <vbabka@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Quan Liu" <qualiu@nvidia.com>, "Lee Trager" <ltrager@nvidia.com>, "Seth
 Forshee" <sforshee@nvidia.com>, "Gregory Price" <gourry@gourry.net>, linux-mm@kvack.org, "Harry
 Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>
In-Reply-To: <av2rqSzkvZYQRgAA@gpd4>
References: <20261110065219.894219-1-arighi@nvidia.com>
 <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
 <avQP1aXhe7nQuzt9@gpd4> <3f761a27-74df-4e19-878b-323164da5a69@kernel.org>
 <av2rqSzkvZYQRgAA@gpd4>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 13:44:43 +0000
X-Stat-Signature: 461n6wqus73f1t31tsyi44jxktwwt96d
X-Rspam-User:
X-Rspamd-Queue-Id: 383D0100002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795095885-149684
X-HE-Meta: U2FsdGVkX19YFJQTPXASdr96s2/yaAT3/+1AHInBizGlSMMSU1DwO8QzUA5qyY7eeAbfmEvMkSfQeseXBS6Y+0qlQlkaYZQNYQA8o6wuporURVsU8iOJnxoMn50RLFuOGn68V5HBqwtfAUXfXwhH0uARfLn9Or+8GH4QJn7yAZwBVr5o5SgS2EXO1oSTEVq1jnd1GogSwfkS1rnchyzc6N++18TtbvUM9xZhPTZj8cYhcbYdR5Bcf+PN3Qwpo/EIWHpradafkv7BHqPvnq2mYh7wQHgQhMAlwScveyVdfEn26aALtMGLFssjZXFuDV2Wl5U5Yj1Eg8xIj7rHABOaNVjZfQNNq/uqRU7zYPmMz52q8SbgKnle4oAmf8Yadi8DunDjIRa9cRPq/5WA5hEXPm75y/p2xV5ccLkcfH4dXMT87avE/QB9YGHjAidsSBaLgUJexeTGiN9iVHQ0ltZ7gVpD3JGRuT6EufkqnMhbeQJx6/cAAax6CRM8K/iO4zqDjZp4aE0sUjup3/UVHulXdsB601r0wQ7VBU0ycrWrLn0UUwxSKKwtcCxTJIwpLDeTFusJA0MYnDmfGVezwFWRyRuKN1dY4/QmL99JKJKNRdwxEbEA1gbnM+f1WnuMaFYeLZfe300CxVXJXPQSeYYDTmgLltpX4MxZUFDGsH7eJoWzLHG7O1mxlT1mmGlTbLFHZVEXGJocrnj/l5QbVR/vNB67gdMUVBs22RPtt3uV1ksusLsI+GWjRoAhc4PtjwNcJGjz+dmOAch2884FHTIzNF2U7RUMAtPjfMB1EUb0e5elIqd+z7uR5fyAFgbS9FyXh7fpIPC17TYYtTMQDzMOxH+6HRuSpi/6pd7hXgThdl0C3tJtdbH/oLpfX3qJYLjVOMxEoa6QO02wEHZWa+sJr+shdlmsdsep6Qdq+kDQ83iuDqVFTXLgEq/6dA4BPSnRdO/Nf/X1fLH7FpKhdO9
 0y5YPMup
 r9pAChIHQJ9E6izKf6OSJF5uFgtjyyu+t0RecoeQyh1z5PormcqbuDTnESz5qocDVVZI/m/zTQQv9IRRhDzVDTp2Tv9mQo6jWAQbPC4bV3p/1ZdBhEfJG0sBM53MPaU/JglhkQshQoGOkzwirDB31p8YusqpL9d1bWYKVjG7fIgJOtfc692YexrThR9VttgvTPTSom+Qucx4DdX3YeQSjE/yC3YROYEXV/fR7kQ82if2lGpoeRJLq4X4XEghRRR7gW5+ET12bhpfPYPODMBnjQcREmT90EM7eCYmEtD+JbPdn3nibkDuUjPfSA7w4RwBMNM2zKbDcTlltTw8BTKzDyQylUGcSo903APE06w8FxtadEXJtxUAMLdWpXsx7vD1Vrx/5b2vXjAbg2/JjsZyPNias46jhpcAuBrcr34k6aPdAx42S00QlKHvWJsGUw0wrQepkL6TgOALq94deh/TzM1vjNG0kZG5tRkl4XeNvj4jc+G3oT7PetmwyxNgdQeH1DTGmiinjt6PnBhHtvD8OSG5IF5gOnUYXINC2YUFGBKWFqVrKRxyMnwCGc1anRGZk3AwGJrx2XWiyLj+rt66E18+n9GAupTjb8333OvqPX3Pq7m0Yn1VrvVD4bK0T5p1MSmhRujZKxxkWrfcbnAKU5mW9fu/JC5wFREmNLF4NroRD2JhC19rcIuhkf/zNPInUIe2/tr90Bgi8Xnp+tZ2WS9UtxuyECdqn1e44Ek/bgCwyEOPXDOs4sVoTEK/RQUG/4F6l/M5j5alpsPepczJhec0ZKPoIjBW9vJowK1kopcY2GTcntPBxSdF5GcYYuojijXDyd/pXZQ97M3zo9yHbHevay1ciffBt3MAI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm/slub: missing Signed-off-by trailer and raw email reply
  commit message
- [Medium] mm/slub: missing apply_policy_zone() check in
  slab_bind_nodemask()
--

commit 6aeea84e9eb20e38913f9dde621595598b384258
Author: Andrea Righi <arighi@nvidia.com>

> pipe: Prefer mempolicy node for metadata allocations
>
> Hi Vlastimil,
>
> thanks for taking a look and sorry for the late reply. Comments below.
>
> On Wed, Nov 11, 2026 at 09:12:44AM +0100, Vlastimil Babka (SUSE) wrote:
> > On 11/11/26 07:48, Andrea Righi wrote:
> > > Hi Jan,
> > >
> > > On Tue, Nov 10, 2026 at 01:27:53PM +0100, Jan Kara wrote:
> > >> On Tue 10-11-26 07:52:19, Andrea Righi wrote:
> > >> > Generic slab allocations can reuse partial slabs from another NUMA=
 node,
> > >> > even when a pipe workload is bound to one node. Pipe metadata is s=
hared
> > >> > between senders and receivers and accessed throughout the pipe lif=
etime.
> > >> > Reusing remote metadata can therefore make an IPC workload pay rem=
ote
> > >> > access and coherence costs on every exchange.
> > >> >
> > >> > The target use case is a workload that binds its workers and memor=
y to
> > >> > one NUMA node with numactl. The policy node is then a useful place=
ment
> > >> > hint for shared pipe metadata.
> > >> >
> > >> > Allocate pipe_inode_info and its descriptor array on the node sele=
cted
> > >> > by the caller's memory policy. Apply the same preference when repl=
acing
> > >> > slab-sized descriptor arrays during ring resizing. An explicit nod=
e lets
> > >> > SLUB try local allocations before reusing remote partial slabs.
> > >> >
> > >> > For descriptor arrays larger than KMALLOC_MAX_CACHE_SIZE, pass
> > >> > NUMA_NO_NODE to keep the policy-aware page allocation path. An exp=
licit
> > >> > node would otherwise lose the MPOL_BIND nodemask on fallback. Sele=
ct the
> > >> > policy node only for slab-sized arrays, avoiding an extra advance =
of an
> > >> > interleave policy for large allocations.
> > >> >
> > >> > Moving a pipe's users to another node doesn't migrate its existing
> > >> > metadata, so migration can still result in remote accesses regardl=
ess of
> > >> > this change. Generic allocations may reuse remote partial slabs, m=
aking
> > >> > initial placement dependent on allocator state. In contrast, prefe=
rring
> > >> > the policy node leverages the workload's placement hint to improve
> > >> > locality when users remain on the intended node.
> > >> >
> > >> > Testing has been performed on a dual-socket NVIDIA Vera system, co=
vering
> > >> > hackbench, pipe transfers, pipe creation and resizing, pipe_bench,=
 and
> > >> > targeted stress tests.
> > >> >
> > >> > The primary hackbench reproducer is:
> > >> >
> > >> >   $ numactl --physcpubind=3D0-87 --membind=3D0 \
> > >> >       hackbench -P -p -g 10 -f 20 -s 100 -l 100000
> > >> >
> > >> > Results (over 10 measured runs per case):
> > >> >
> > >> >               avg       stdev
> > >> >    before     9.811s    0.130s
> > >> >    after      5.770s    0.058s
> > >> >
> > >> > Before this change, allocations could reuse remote pipe metadata. =
With
> > >> > this change, both pipe objects and descriptor arrays are allocated=
 on
> > >> > the requested node, improving locality and reducing hackbench runt=
ime by
> > >> > approximately 41%.
> > >> >
> > >> > Reported-by: Quan Liu <qualiu@nvidia.com>
> > >> > Signed-off-by: Andrea Righi <arighi@nvidia.com>
> > >>
> > >> To me this makes sense so feel free to add:
> > >>
> > >> Acked-by: Jan Kara <jack@suse.cz>
> > >>
> > >> But IMHO it deserves a look from MM guys since this is more of an MM=
 thing
> > >> than a filesystem one... Added to CC.
> > >
> > > Thanks for taking a look, and good point about getting MM feedback.
> > >
> > > Vlastimil, Gregory, do you think this SLUB locality and mempolicy
> > > aspects makes sense here? In particular, does preferring the policy n=
ode
> > > for slab-sized pipe metadata, while retaining the policy-aware path f=
or
> > > larger arrays, look reasonable?
> >
> > It's not wrong, but feels a bit ad-hoc. If it's pipe metadata now, what=
's next?
>
> Agreed, after looking deeper this isn't really a pipe problem, any slab
> user can hit it, so it should probably be addressed in slab.
>
> >
> > Slab will generally return objects from the cpu's local node even if it=
's
> > not specified. It's not guaranteed, but it's not guaranteed also when i=
t's
> > specified by kmalloc_node() (unless __GFP_THISNODE forces it).
> >
> > So the results above are surprising to me. Are they on recent kernels? =
Are
> > cpus 0-87 all local to node 0, or is membind 0 there to force a node th=
at's
> > not local to some of them? If they are all local, I would expect the ob=
jects
> > to be from node 0 even without kmalloc_node(). So maybe we have some un=
known
> > deficiency that should be investigated.
>
> The results were collected on 7.4-rc1 and I've reproduced them in
> 7.4-rc2. CPUs 0-87 are all local to node 0 (node 0 has CPUs 0-87 and
> their SMT siblings 176-263, node 1 has 88-175 and 264-351).
>
> I should have been clearer about the setup and the results I reported:
> numbers were collected after seeding the slab state to make the problem
> more reproducible. Before each run, a helper holds ~4K pipes created on
> a node 0 CPU, then it creates 1K pipes on a node 1 CPU and closes 7 out
> of 8 of them, leaving sparse partial slabs on node 1. Starting from a
> clean slab state, or with only the node 1 part, all objects are local
> and there's no difference, as you expected (100000 loops, 10 runs,
> placement traced with bpftrace):
>
>                                          avg      stdev   remote objs/arr=
ays
>   not seeded                             5.122s   0.027       0 / 0
>   seeded                                 9.730s   0.125    1606 / 1780
>   seeded, remote_node_defrag_ratio=3D0     5.101s   0.019       0 / 0
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
> vs 5.92s with remote_node_defrag_ratio=3D0).
>
> >
> > Also note that it's possible to force this behavior of respecting mempo=
licy
> > for all slab objects, usigng the slab_strict_numa boot parameter. AFAIK=
 this
> > was added for systems where the interconnect makes remote accesses
> > especially costly.
>
> I tried slab_strict_numa, but it doesn't seem to help in this case,
> because apply_strict_numa_policy() leaves the node as NUMA_NO_NODE when
> the policy is MPOL_BIND and the local node is in the mask, so the
> allocation still falls back to the remote partial scan.
>
> A more generic fix could be to make the remote partial scan respect the
> bind nodemask. Do you think something like the following could be
> reasonable? (only tested with this workload so far)
>
> Thanks,
> -Andrea

[Severity: High]
The commit message is a raw mailing-list reply with the subject of an
earlier fs/pipe.c patch ("pipe: Prefer mempolicy node for metadata
allocations") and lacks a non-quoted Signed-off-by: trailer.  If this
mm/slub.c change is intended to be applied, it needs a proper commit
subject, changelog, and Signed-off-by: tag.

> diff --git a/mm/slub.c b/mm/slub.c
> index a151268b97263..3cb18596aa3f3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3983,6 +3983,27 @@ static void *get_from_partial_node(struct kmem_cac=
he *s,
>  	return object;
>  }
> =20
> +#ifdef CONFIG_NUMA
> +/*
> + * Return the nodes allowed by the current task's bind policy, or NULL if
> + * the policy doesn't restrict them. Partial slabs on other nodes must n=
ot be
> + * used to satisfy an allocation that didn't request a specific node.
> + */
> +static nodemask_t *slab_bind_nodemask(void)
> +{
> +	struct mempolicy *mpol;
> +
> +	if (!in_task())
> +		return NULL;
> +
> +	mpol =3D current->mempolicy;
> +	if (mpol && mpol->mode =3D=3D MPOL_BIND)
> +		return &mpol->nodes;
> +
> +	return NULL;
> +}
> +#endif
> +
>  /*
>   * Get an object from somewhere. Search in increasing NUMA distances.
>   */
> @@ -3996,6 +4017,7 @@ static void *get_from_any_partial(struct kmem_cache=
 *s, gfp_t gfp_flags,
>  	enum zone_type highest_zoneidx =3D gfp_zone(gfp_flags);
>  	unsigned int cpuset_mems_cookie;
>  	bool allow_spin =3D alloc_flags_allow_spinning(ac->alloc_flags);
> +	nodemask_t *nodemask =3D slab_bind_nodemask();

[Severity: Medium]
Should slab_bind_nodemask() check apply_policy_zone(mpol, highest_zoneidx)
before returning &mpol->nodes, matching policy_nodemask() in
mm/mempolicy.c?

When a task is bound via MPOL_BIND to a node that has only ZONE_NORMAL
(such as node 1 on standard x86_64/arm64 systems where ZONE_DMA and
ZONE_DMA32 exist only on node 0) and allocates from a GFP_DMA or
GFP_DMA32 slab cache, policy_nodemask() ignores MPOL_BIND because
apply_policy_zone() is false, so new_slab() allocates the slab on node 0
and places the remaining partial slab on node 0's partial list.  Because
slab_bind_nodemask() returns &mpol->nodes without checking
apply_policy_zone(), for_each_zone_zonelist_nodemask() in
get_from_any_partial() and __refill_objects_any() filters out node 0 and
can never reuse those partial slabs, forcing a new slab page allocation on
node 0 each time.  The same mismatch occurs when a task is bound to a
ZONE_MOVABLE-only node, where apply_policy_zone() is false for all slab
allocations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/av2rqSzkvZYQRgAA@gp=
d4?part=3D1

