Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F613CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A1C8E0047; Mon, 13 Oct 2025 09:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051EE8E000F; Mon, 13 Oct 2025 09:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9FC8E0047; Mon, 13 Oct 2025 09:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3C0C8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:09:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9849A1DF33A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:09:52 +0000 (UTC)
X-FDA: 83993123424.14.A606FF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6A33E40011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:09:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TPJgrC5Q;
	spf=pass (imf07.hostedemail.com: domain of pauld@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pauld@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760360990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2sb9+tj/NdPdAHZt1L/fLKrYzPvINCloUN8HN7imzWw=;
	b=mDLj6EgiVVaZXcD0MrI+y7qZKs42XSN658s9ssSeOauUspoy/wqBD0lq+2nNYC7ClHBa6F
	RY5e/XcXVcFgVwZVNX8wWPfW0zJSJblcLGsZrHwPp5W6OEyhkm9ZcFamZgcRSpr8Q813lV
	0YblYUvXSl4s4e2L69WpmoCu7WVR5iE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TPJgrC5Q;
	spf=pass (imf07.hostedemail.com: domain of pauld@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pauld@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760360990; a=rsa-sha256;
	cv=none;
	b=5ojYsdMAS3thC8jjYGLnSYVmVxEOfv85eFvF/XKy50bsnbwVrg+m+NnuInnxKCDa6f/MvF
	/GkT+tUQTTFP/71i37K/In+xh8ZLOT9msiXI7aYWbqXDFZW1bhJD5c7qQsG9in94fY5oI7
	zzLOaD0QR/uh6D02+4wXa7IHTDQGgbk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760360989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2sb9+tj/NdPdAHZt1L/fLKrYzPvINCloUN8HN7imzWw=;
	b=TPJgrC5QSfP1jLq8cJB3CF1xvEyHDq0FpYgSWbJ6eGBf0MelAdAh/D7LBVfnvemAqFEOdU
	VJZM4h6QqwE4IAjU69PFpQxAZT6WYylQ7QZM31zGtElWRJxoGmlCIFGmSNSx3GqwQSygch
	+WGQJuS8fP6F9Fl+CC1jgK9lAWCoy4c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-gQ-1f6MuOCyQ2LC0MAcUlQ-1; Mon,
 13 Oct 2025 09:09:48 -0400
X-MC-Unique: gQ-1f6MuOCyQ2LC0MAcUlQ-1
X-Mimecast-MFC-AGG-ID: gQ-1f6MuOCyQ2LC0MAcUlQ_1760360986
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 799DC1800371;
	Mon, 13 Oct 2025 13:09:45 +0000 (UTC)
Received: from pauld.westford.csb (unknown [10.44.32.127])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15F3030002CE;
	Mon, 13 Oct 2025 13:09:41 +0000 (UTC)
Date: Mon, 13 Oct 2025 09:09:37 -0400
From: Phil Auld <pauld@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Christoph Lameter <cl@gentwo.org>
Subject: Re: Boot fails with 59faa4da7cd4 and 3accabda4da1
Message-ID: <20251013130937.GA488956@pauld.westford.csb>
References: <20251010151116.GA436967@pauld.westford.csb>
 <CAHk-=wg1xK+Br=FJ5QipVhzCvq7uQVPt5Prze6HDhQQ=QD_BcQ@mail.gmail.com>
 <e4f2a3e3-649a-423b-9696-6406ef56340f@suse.cz>
 <20251010184259.GB436967@pauld.westford.csb>
 <b63f1f40-a8f5-4b54-b025-d8d1daf78c9b@suse.cz>
 <20251011002902.GA479718@pauld.westford.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011002902.GA479718@pauld.westford.csb>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A33E40011
X-Stat-Signature: 6wtgyi63feq4z6twqudzaxep1z7emqyh
X-Rspam-User: 
X-HE-Tag: 1760360990-940095
X-HE-Meta: U2FsdGVkX1+s+Z3HHthIOq5cLwih8azpXP1LZuQ6dQIx9DvHBIIeNCTcj9lrJv5ufaX0gIwU0sqb4bZtwHfDQJ94PLTOdFyzJFy0Nt+G7CKqiMzR2cTsoryLfLVhr1BycJNbgKqVooaE+zI2mUnNWbV/b+agCyOu0G3nZVQZ+XmY1V6OanrgcGWRoDFB7wG4549UxyYcWi1HaZw2KrT5BGjTIQ7WUFiqxmShpOMmJeOwlZT4bGhgKBLV6VFH8F5sVwdNNg85Pl4YJm3UAXBbyitKkFtc5d+5AVWvc8ppbZxY14c5CY0sel8cYPCCIvICbRGKyP02OTh7jGTdFJiHzQlmAaTfb0S2kaLXIU84HkPHFf5q9rSoqzkHIBqcZI0y6eCKEVM+uvibuQpm1BkOS8Gz0LtqngvbxkdDqGXv/XEkuH6OU9OPnH2mTSXdPYcOJmOk53v1IL+BK7nionss7ODhM/B5rfZTGwBXIslTd2+tyG0lDyXxCWyATw6YOKbNcQypo/mHDNSEzYK4nEcNoNv26gXzQ1+iDtd4c2g9yAZ0dVFCsK82J718ikaMByKP6Zo3gQFXGEaXoYNp1eT/HWdzbeUWtDXmulIr/5MrM1TN3fjVG6xjdohPy96CZ1/81CMDp8YfqEDyExalwrl5JUAhwFknyQtAWnQ8+BZIxfrX8P67KvqQAj1ZwvJC8hc90V0d7NZtGzmQ+M1sCxoiLUtsUMLWN5oeUDsGdWqswkW4Ph8FfRsME3Asz41nJsa5lFm+TlEcYvZOs5hsv2KPhOrhE02QkpGJ6Em/m2F3IgIo2IKLWCdqfLU+RgfmG0YQbnnwnnYQTxPUOjugd9sy2kHjil4nckEVsf4EfoBpiz0aNrpYWIxFw1XcV193UKHtM75NQ5lCJl5UaesQujBOnc0WHzNhTv3DzY+WWHlfscnE3aV8gxmRBiHdpsp47KO5yszWF3pJXqtzxVdtr7o
 WLVZnxsI
 AzwJa/1BUJCLuysqoA80gJBJ+xl1bEnwaQx9EM5FmZLaHHyXeH2W7xPk9pby8fIf6R6lA11gAPNKt1GhIFPGpuAmAROsZsz8IeRJmhEBTcXH/PljmotFiJd7jcQyNm8sOWe2lXk1Grn2vBC8gaUzGKwOa6I9hv91afFyk77zML9rbECOtJ5RCbfc2wIKalJ3ze6syALdewMLt+olT45y/9W1TLmj1jTYvX0gYNUzPc3onzMhSkmUwdWdl7fvkDymtqlEBw5SDt7J5Rehq4w8ghDBS71HKM7udRxnUQfHLHO46zBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Oct 10, 2025 at 08:29:07PM -0400 Phil Auld wrote:
> Hi Vlastimil,
> 
> On Sat, Oct 11, 2025 at 12:22:39AM +0200 Vlastimil Babka wrote:
> > On 10/10/25 20:42, Phil Auld wrote:
> > > On Fri, Oct 10, 2025 at 08:27:30PM +0200 Vlastimil Babka wrote:
> > >> On 10/10/25 20:19, Linus Torvalds wrote:
> > >> > On Fri, 10 Oct 2025 at 08:11, Phil Auld <pauld@redhat.com> wrote:
> > >> >>
> > >> >> After several days of failed boots I've gotten it down to these two
> > >> >> commits.
> > >> >>
> > >> >> 59faa4da7cd4 maple_tree: use percpu sheaves for maple_node_cache
> > >> >> 3accabda4da1 mm, vma: use percpu sheaves for vm_area_struct cache
> > >> >>
> > >> >> The first is such an early failure it's silent. With just 3acca I
> > >> >> get :
> > >> >>
> > >> >> [    9.341152] BUG: kernel NULL pointer dereference, address: 0000000000000040
> > >> >> [    9.348115] #PF: supervisor read access in kernel mode
> > >> >> [    9.353264] #PF: error_code(0x0000) - not-present page
> > >> >> [    9.358413] PGD 0 P4D 0
> > >> >> [    9.360959] Oops: Oops: 0000 [#1] SMP NOPTI
> > >> >> [    9.365154] CPU: 21 UID: 0 PID: 818 Comm: kworker/u398:0 Not tainted 6.17.0-rc3.slab+ #5 PREEMPT(voluntary)
> > >> >> [    9.374982] Hardware name: Dell Inc. PowerEdge R7425/02MJ3T, BIOS 1.26.0 07/30/2025
> > >> >> [    9.382641] RIP: 0010:__pcs_replace_empty_main+0x44/0x1d0
> > >> >> [    9.388048] Code: ec 08 48 8b 46 10 48 8b 76 08 48 85 c0 74 0b 8b 48 18 85 c9 0f 85 e5 00 00 00 65 48 63 05 e4 ee 50 02 49 8b 84 c6 e0 00 00 00 <4c> 8b 68 40 4c 89 ef e8 b0 81 ff ff 48 89 c5 48 85 c0 74 1d 48 89
> > >> > 
> > >> > That decodes to
> > >> > 
> > >> >    0:           mov    0x10(%rsi),%rax
> > >> >    4:           mov    0x8(%rsi),%rsi
> > >> >    8:           test   %rax,%rax
> > >> >    b:           je     0x18
> > >> >    d:           mov    0x18(%rax),%ecx
> > >> >   10:           test   %ecx,%ecx
> > >> >   12:           jne    0xfd
> > >> >   18:           movslq %gs:0x250eee4(%rip),%rax
> > >> >   20:           mov    0xe0(%r14,%rax,8),%rax
> > >> >   28:*          mov    0x40(%rax),%r13          <-- trapping instruction
> > >> >   2c:           mov    %r13,%rdi
> > >> >   2f:           call   0xffffffffffff81e4
> > >> >   34:           mov    %rax,%rbp
> > >> >   37:           test   %rax,%rax
> > >> >   3a:           je     0x59
> > >> > 
> > >> > which is the code around that barn_replace_empty_sheaf() call.
> > >> > 
> > >> > In particular, the trapping instruction is from get_barn(), it's the "->barn" in
> > >> > 
> > >> >         return get_node(s, numa_mem_id())->barn;
> > >> > 
> > >> > so it looks like 'get_node()' is returning NULL here:
> > >> > 
> > >> >         return s->node[node];
> > >> > 
> > >> > That 0x250eee4(%rip) is from "get_node()" becoming
> > >> > 
> > >> >   18:           movslq  %gs:numa_node(%rip), %rax  # node
> > >> >   20:           mov    0xe0(%r14,%rax,8),%rax # ->node[node]
> > >> > 
> > >> > instruction, and then that ->barn dereference is the trapping
> > >> > instruction that tries to read node->barn:
> > >> > 
> > >> >   28:*          mov    0x40(%rax),%r13   # node->barn
> > >> > 
> > >> > but I did *not* look into why s->node[node] would be NULL.
> > >> > 
> > >> > Over to you Vlastimil,
> > >> 
> > >> Thanks, yeah will look ASAP. I suspect the "nodes with zero memory" is
> > >> something that might not be handled well in general on x86. I know powerpc
> > >> used to do these kind of setups first and they have some special handling,
> > >> so numa_mem_id() would give you the closest node with memory in there and I
> > >> suspect it's not happening here. CPU 21 is node 6 so it's one of those
> > >> without memory. I'll see if I can simulate this with QEMU and what's the
> > >> most sensible fix
> > >>
> > > 
> > > Thanks for taking a look.  I thought the NPS4 thing might be playing a role.
> > 
> > From what I quickly found I understood that NPS4 is supposed to create extra
> > numa nodes per socket (4 instead of 1) and interleave the memory between
> > them. So it seems weird to me it would assign everything to one node and
> > leave 3 others memoryless?
> >
> 
> That I don't know. Someone from AMD might be able to help there. This system
> has had its BIOS and other bits updated just a couple of months ago but
> this numa layout has been there since I've been using the system (several
> years now).
> 

Just to follow up here.  I think the issue is just that this machine
is somewhat underprovisioned in the memory department.  It's got 32
slots, with only 4 actually populated. I suspect if it was fully populated
there'd be memory in every node.

Thanks for the fix and getting it -rc1.


Cheers,
Phil



> > > I'm happy to take any test/fix code you have for a spin on this system. 
> >  
> > Thanks. Here's a candidate fix in case you can test. I'll finalize it
> > tomorrow. The slab performance won't be optimal on cpus on those memoryless
> > nodes, that's why I'd like to figure out if it's a BIOS bug or not. If
> > memoryless nodes are really intended we should look into initializing things
> > so that numa_mem_id() works as expected and points to nearest populated
> > node.
> 
> The below does the trick. It boots and I ran a suite of stress-ng tests
> for sanity. Any performance it's getting now is better than it was when it
> wouldn't boot :)
> 
> Tested-by: Phil Auld <pauld@redhat.com>
> 
> 
> Cheers,
> Phil
> 
> > 
> > ----8<----
> > From 097c6251882bf5537162d17b6726575288ba9715 Mon Sep 17 00:00:00 2001
> > From: Vlastimil Babka <vbabka@suse.cz>
> > Date: Sat, 11 Oct 2025 00:13:20 +0200
> > Subject: [PATCH] slab: fix NULL pointer when trying to access barn
> > 
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  mm/slub.c | 60 +++++++++++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 47 insertions(+), 13 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 135c408e0515..bd3c2821e6c3 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -507,7 +507,12 @@ static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
> >  /* Get the barn of the current cpu's memory node */
> >  static inline struct node_barn *get_barn(struct kmem_cache *s)
> >  {
> > -	return get_node(s, numa_mem_id())->barn;
> > +	struct kmem_cache_node *n = get_node(s, numa_mem_id());
> > +
> > +	if (!n)
> > +		return NULL;
> > +
> > +	return n->barn;
> >  }
> >  
> >  /*
> > @@ -4982,6 +4987,10 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> >  	}
> >  
> >  	barn = get_barn(s);
> > +	if (!barn) {
> > +		local_unlock(&s->cpu_sheaves->lock);
> > +		return NULL;
> > +	}
> >  
> >  	full = barn_replace_empty_sheaf(barn, pcs->main);
> >  
> > @@ -5153,13 +5162,20 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
> >  	if (unlikely(pcs->main->size == 0)) {
> >  
> >  		struct slab_sheaf *full;
> > +		struct node_barn *barn;
> >  
> >  		if (pcs->spare && pcs->spare->size > 0) {
> >  			swap(pcs->main, pcs->spare);
> >  			goto do_alloc;
> >  		}
> >  
> > -		full = barn_replace_empty_sheaf(get_barn(s), pcs->main);
> > +		barn = get_barn(s);
> > +		if (!barn) {
> > +			local_unlock(&s->cpu_sheaves->lock);
> > +			return allocated;
> > +		}
> > +
> > +		full = barn_replace_empty_sheaf(barn, pcs->main);
> >  
> >  		if (full) {
> >  			stat(s, BARN_GET);
> > @@ -5314,6 +5330,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> >  {
> >  	struct slub_percpu_sheaves *pcs;
> >  	struct slab_sheaf *sheaf = NULL;
> > +	struct node_barn *barn;
> >  
> >  	if (unlikely(size > s->sheaf_capacity)) {
> >  
> > @@ -5355,8 +5372,11 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> >  		pcs->spare = NULL;
> >  		stat(s, SHEAF_PREFILL_FAST);
> >  	} else {
> > +		barn = get_barn(s);
> > +
> >  		stat(s, SHEAF_PREFILL_SLOW);
> > -		sheaf = barn_get_full_or_empty_sheaf(get_barn(s));
> > +		if (barn)
> > +			sheaf = barn_get_full_or_empty_sheaf(barn);
> >  		if (sheaf && sheaf->size)
> >  			stat(s, BARN_GET);
> >  		else
> > @@ -5426,7 +5446,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> >  	 * If the barn has too many full sheaves or we fail to refill the sheaf,
> >  	 * simply flush and free it.
> >  	 */
> > -	if (data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
> > +	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
> >  	    refill_sheaf(s, sheaf, gfp)) {
> >  		sheaf_flush_unused(s, sheaf);
> >  		free_empty_sheaf(s, sheaf);
> > @@ -5943,10 +5963,9 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
> >   * put the full sheaf there.
> >   */
> >  static void __pcs_install_empty_sheaf(struct kmem_cache *s,
> > -		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty)
> > +		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
> > +		struct node_barn *barn)
> >  {
> > -	struct node_barn *barn;
> > -
> >  	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> >  
> >  	/* This is what we expect to find if nobody interrupted us. */
> > @@ -5956,8 +5975,6 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
> >  		return;
> >  	}
> >  
> > -	barn = get_barn(s);
> > -
> >  	/*
> >  	 * Unlikely because if the main sheaf had space, we would have just
> >  	 * freed to it. Get rid of our empty sheaf.
> > @@ -6002,6 +6019,11 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
> >  	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> >  
> >  	barn = get_barn(s);
> > +	if (!barn) {
> > +		local_unlock(&s->cpu_sheaves->lock);
> > +		return NULL;
> > +	}
> > +
> >  	put_fail = false;
> >  
> >  	if (!pcs->spare) {
> > @@ -6084,7 +6106,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
> >  	}
> >  
> >  	pcs = this_cpu_ptr(s->cpu_sheaves);
> > -	__pcs_install_empty_sheaf(s, pcs, empty);
> > +	__pcs_install_empty_sheaf(s, pcs, empty, barn);
> >  
> >  	return pcs;
> >  }
> > @@ -6121,8 +6143,9 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
> >  
> >  static void rcu_free_sheaf(struct rcu_head *head)
> >  {
> > +	struct kmem_cache_node *n;
> >  	struct slab_sheaf *sheaf;
> > -	struct node_barn *barn;
> > +	struct node_barn *barn = NULL;
> >  	struct kmem_cache *s;
> >  
> >  	sheaf = container_of(head, struct slab_sheaf, rcu_head);
> > @@ -6139,7 +6162,11 @@ static void rcu_free_sheaf(struct rcu_head *head)
> >  	 */
> >  	__rcu_free_sheaf_prepare(s, sheaf);
> >  
> > -	barn = get_node(s, sheaf->node)->barn;
> > +	n = get_node(s, sheaf->node);
> > +	if (!n)
> > +		goto flush;
> > +
> > +	barn = n->barn;
> >  
> >  	/* due to slab_free_hook() */
> >  	if (unlikely(sheaf->size == 0))
> > @@ -6157,11 +6184,12 @@ static void rcu_free_sheaf(struct rcu_head *head)
> >  		return;
> >  	}
> >  
> > +flush:
> >  	stat(s, BARN_PUT_FAIL);
> >  	sheaf_flush_unused(s, sheaf);
> >  
> >  empty:
> > -	if (data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
> > +	if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
> >  		barn_put_empty_sheaf(barn, sheaf);
> >  		return;
> >  	}
> > @@ -6191,6 +6219,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
> >  		}
> >  
> >  		barn = get_barn(s);
> > +		if (!barn) {
> > +			local_unlock(&s->cpu_sheaves->lock);
> > +			goto fail;
> > +		}
> >  
> >  		empty = barn_get_empty_sheaf(barn);
> >  
> > @@ -6304,6 +6336,8 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
> >  		goto do_free;
> >  
> >  	barn = get_barn(s);
> > +	if (!barn)
> > +		goto no_empty;
> >  
> >  	if (!pcs->spare) {
> >  		empty = barn_get_empty_sheaf(barn);
> > -- 
> > 2.51.0
> > 
> > 
> 
> -- 

-- 


