Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E775DCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D9E8E000C; Wed, 27 Aug 2025 16:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433F48E0001; Wed, 27 Aug 2025 16:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370DD8E000C; Wed, 27 Aug 2025 16:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2584E8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:50:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB023160843
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:50:29 +0000 (UTC)
X-FDA: 83823730578.20.5F923ED
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 32DDA14000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:50:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWaJ2uAL;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756327828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hU0YOlK0A/OqZMyBRHKhwszszuzq0q1K7KKT0zAgw28=;
	b=fDIKQNLoK5QNQ0sxB7l+KPh0uQY3lvw2Q08GpHuOAGsMtV3ICSPbLgjXQ/eBOW4TE6zgUR
	YheIzc3CDbSc5R25qnvWJG0W3F0wcQqMWJfiY0IVrmZ0KMoILfI6dl6ER6kKeVFq3MYFGj
	Bn5YkITLBANoIx6EPBjMoy7esk6FWE8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWaJ2uAL;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756327828; a=rsa-sha256;
	cv=none;
	b=hWUNJlr4JV7//6nFx12EPrsj3mUT0HDkKD04lLutJ29TXSQxIaH+Xn1DyjfQJ6CMfFrdyd
	XXHmjfEr7paNvHNjE49CfIFP53ah/dpZNvcoEqn8sUDRPSlLBSb2SOuXVVeSuTy+5xUL1L
	fyH4VrignLfvKwdrI9n4K3PMkiBygZ4=
Date: Wed, 27 Aug 2025 13:50:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756327825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hU0YOlK0A/OqZMyBRHKhwszszuzq0q1K7KKT0zAgw28=;
	b=SWaJ2uALZ8vtxrsSMGlZicuxcZtKzYLZ5zOq+nER83qcGJHzjsbJG+3kQZgTR8c9LRHw+Z
	qs6XzeEp5SNJCVsppiIRiZiDLXzV26Afzt5nnqbN7wJLlHvU/ZX0CUx21gwCn/1NM1kznV
	kc5Trl+1k8U4eGZCKdMgZ+cjawMI08g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	hannes@cmpxchg.org, usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v6 mm-new 02/10] mm: thp: add a new kfunc
 bpf_mm_get_mem_cgroup()
Message-ID: <3m6jhfndkoshnoj76wyjjgmqa55p4ij4desc45yz6g7gbpxnrd@xumacckayj4t>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
 <20250826071948.2618-3-laoar.shao@gmail.com>
 <299e12dc-259b-45c2-8662-2f3863479939@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <299e12dc-259b-45c2-8662-2f3863479939@lucifer.local>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 32DDA14000C
X-Stat-Signature: su161h5s9jxf5cintzpon89nkh3kz1gt
X-Rspam-User: 
X-HE-Tag: 1756327827-201842
X-HE-Meta: U2FsdGVkX18FsOz1kYar+kN6o3cLXqOOP8wqfr5JejO88Bdss1Nk5kc0EubAzhaiwuf9StM7NMH+PXMXOIRdAF86V03zxx/PSphyRSiTs1Crdv+EkTWr4q4kWf2Vek5qMXa8NXsJqOhTmtZtOTNpXafiUUehwUYOY9A+3DNC76EKs3p3MDXyUO65FvzHBA7jCVu/4ziUy8q7t259jXisrdejcszhd+lBHKXBKqv8GXfMa7t9nOm4nNIlwwJ9KCn1oQT8+/zGHT4PfeXcl7nSW3G+909EQML8F+E5RRPgHpXmnR3BGIm1NCBuqU/0TzeVxcEJD7B5EXt3SSybDFpUPnXRbe8Egw6ATWpBEgvBGN/0oQbdl/fcP2YHHVthKcz8A+IKGrkOwOjoJj4n61+hWs3boxtHEF3zqqxUKEq2tFnzegL/Cp7SdZXb9gyIOxtW9cNiL/nEgRHs/KDPq/rNqhr00EtPk1MDeLTUqRA+JY+/ijsxZPptrAI16G6pofmWoJU4RqVQpRFF0+ENMHkhGhbOnBLOr64z+6D5O0YFTlPl9/DhRvTWBYH7ODbpS/0VAF8Kw9NzNAEYgVv0N4k12nDTQ6VA7soJfy3wtV+nHXLwRnL2hRAdE7r35V3bbQjtBZWme4s5nH19wMmIxknULUzMsdQC7CEkLlObPW5qNBo/3+bPNigBc//Ya739ITGNs+One509lmpyjC3qVNcTF4vwhA/+iwI6FfonfQ2DUnrpnEFwgte7L9VskoNXoqYLAy8s3uqMkpggq+OWVWeNvUTmYRWdQkd8+xJTNn5h2LOFfTPKOQLiCqwL9ejU5n1V+MXmYk9G/Dop3NwbLHly2Oyw7/0PdieWUXEcQ9QNN606RdcJC3c44XG2VJpDsw8B5bgbeWWedBuu9+wJrQwdP1zDjOzaDok8pl+IJf+iZgvLnbL14FzwbmAsfqfTDXKnH1GzyIATCNn1zuuXClV
 6ic7LYbl
 ppIwf6vawaUa11U0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 04:34:48PM +0100, Lorenzo Stoakes wrote:
> > +__bpf_kfunc_start_defs();
> > +
> > +/**
> > + * bpf_mm_get_mem_cgroup - Get the memory cgroup associated with a mm_struct.
> > + * @mm: The mm_struct to query
> > + *
> > + * The obtained mem_cgroup must be released by calling bpf_put_mem_cgroup().
> > + *
> > + * Return: The associated mem_cgroup on success, or NULL on failure. Note that
> > + * this function depends on CONFIG_MEMCG being enabled - it will always return
> > + * NULL if CONFIG_MEMCG is not configured.
> 
> What kind of locking is assumed here?
> 
> Are we protected against mmdrop() clearing out the mm?

No locking is needed. Just the valid mm object or NULL. Usually the
underlying function (get_mem_cgroup_from_mm) is called in page fault
context where the current is holding mm. Here the only requirement is
that mm is valid either through explicit reference or the context.

> 
> > + */
> > +__bpf_kfunc struct mem_cgroup *bpf_mm_get_mem_cgroup(struct mm_struct *mm)
> > +{
> > +	return get_mem_cgroup_from_mm(mm);
> > +}
> > +
> > +/**
> > + * bpf_put_mem_cgroup - Release a memory cgroup obtained from bpf_mm_get_mem_cgroup()
> > + * @memcg: The memory cgroup to release
> > + */
> > +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> > +{
> > +#ifdef CONFIG_MEMCG
> > +	if (!memcg)
> > +		return;
> > +	css_put(&memcg->css);
> 
> Feels weird to have an ifdef here but not elsewhere, maybe the whole thing
> should be ifdef...?
> 
> Is there not a put equivalent for get_mem_cgroup_from_mm()? That is a bit weird.
> 
> Also do we now refrence the memcg global? That's pretty gross, could we not
> actually implement such a helper?
> 
> Is it valid to do this also? Maybe cgroup people can chime in.

There is mem_cgroup_put() which should handle !CONFIG_MEMCG configs.


