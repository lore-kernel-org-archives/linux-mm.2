Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A32CAC5AC
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E020E8E0013; Mon, 22 Sep 2025 19:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2CD8E0001; Mon, 22 Sep 2025 19:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1188E0013; Mon, 22 Sep 2025 19:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B62C68E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:58:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3565EB7BC8
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:58:06 +0000 (UTC)
X-FDA: 83918552172.08.BE7B34B
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 44790180007
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:58:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ecme15aA;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758585484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I249uCXjcrnPHCtWWPGaeLfw8fIgOsN3T+f7nWAqPeA=;
	b=0ipDWH2h4Ypyy0cvW1ap+UqK037cg3DTWFIsYLB/GHwb34yP5Tj2eSSneQvfbuMS8qbdbd
	T/o+b4POn05uSwHIx75X0hGdpMd4NjNLfRyv1s5MzO+crcGz5BOnaMTxDEbyUiyRklzpED
	3a/KqX0UUATGMwASsACX9ExjXvcapak=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ecme15aA;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758585484; a=rsa-sha256;
	cv=none;
	b=k1fFLsPUyBhLMA220+dhUdGo9o9Mxwm8ymkllT9Z7PMM84t+95ZF6RKTgLxkBz/pOxucBx
	BXSOxouKPn6jVh2LCFnj7Lx1/mbeUjtMo6pJcSSIYb96/0xGEpiFt1qIQpaq4p8QDOT20K
	u/wAhwbZnyBoi0Q7fVShzwj0jR83u4E=
Date: Mon, 22 Sep 2025 16:57:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758585481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I249uCXjcrnPHCtWWPGaeLfw8fIgOsN3T+f7nWAqPeA=;
	b=ecme15aA9EoMkti0fX8W5xi+YQF2qPW/Auxv/JqzE9bRN62asdRJojQPfo1ExGUkQXFQKW
	okzJ+30kHtIAkUNEOe4AsMdnTZWlnKrHcd3ZzlGHSvXqtp5bFW42IhOCXiCm2gnk+6Djdt
	z/HlYwYH8IdAegegKwcli+pIIkFqTQU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not
 allowed
Message-ID: <uvm7vru6ulfakmy4qb5slq2ee7dgiuis2aei3vdyu4nk4pyubh@noc2gep35huh>
References: <20250922220203.261714-1-shakeel.butt@linux.dev>
 <20250922160308.524be6ba4d418886095ab223@linux-foundation.org>
 <nzr2ztya3duztwfnpcnl2azzcdg74hjbwzzs3nxax67nsu6ffq@leycq6l5d5y2>
 <20250922164328.0d766c95f9c15330e99514bd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922164328.0d766c95f9c15330e99514bd@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 44790180007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qqpagjpatoparekhmkhpk3431dz39i3o
X-HE-Tag: 1758585484-930623
X-HE-Meta: U2FsdGVkX1/Fye5/A27HtWixktx3b9dGzeeOsNB/sQX+1xhS++TBX5K2khIpdWhU4uLwZh08S2WC1nd8oydhwUPoqW0WHEjhU8KYDc9/WwY6UPBT/zxtN/wtkKGJznACnq5CWdI0WlbrbUpBnckPey0OgEiavraQ2Zz4q5+tyh8T1Q7cnNVGFgMfjiLkB2VOxCVtFABKXeizyRJryghvofy6ne5PDnC04SMYqXjaGrZcUrvutSfYYzVnnFlWpg2CMdP7DmCOt+hxmILvFArIyAdV902LEdRuNiAxUA9vtNGjwW76QSD0dsCjlZW+KU8/C6essg9XcZFnet+LQF+TCLUW0i5pjjtFVaMPaxila2vMklKDPxj/3uy5cVkOejNw3X2qANL9RApLY+0SbZNBozjrwYtKwxFUWC6Ri4uKBgQr+VeuHoThHBIAVwozYgkNDDD/B1FdnxCXfeaD4u2aQgfIGwUZ+MF5Bz9Mq0Ld6rYlySSltSd8ZyntUuBvUCmaGIBFA4QqG/Ad9riFjCLgTN0dAkSSHtxykG7JiOvGE12ZcYSxpc4w7JGACts8pjWQHJ31DBhGjltea/TkvI+jRDNFMPDZJ4nEJTHb6gmuqzIzq1uLCpnYl3QMiajvwUFnKEdTxotFV7AKuLL9wuBmq4e1dyTfuR3bQU42Y9j+aJMi9oR5cAmCSeqzZdIH65HhB7KVGc3+tzL8lNegPuhZh2BBDpMeZ8TstZaA/Gn0/6IaTpMjsootOexeN1lbwMY7rykzhNkskmM9ZHKOfxX798N7RuNmyjhKiqNR3xWdrc98od5BvkkJpD7rBQ1egfhOikiXP2ba/zFawbKse+1mraCGlMkmrUBWENub7q/f8GSdhAlk3VoQPL8sui/Xkos1ponwUrE4ER6wDvgOyjRRH6zi528apAUNCZpAcFq2k5+nY6fVZgOxUnvz6+9/AuUyTa0KjDGCc2XJfVoqrIw
 Wc5thE8b
 abW+hrC4YbnO87I3HCjS3o5LsqangOeJq8/JvCIKI5b0TZvz88CfiJMJuEe62vfY3+ADn5GGfwB5MhTT+Lw+x1Af9gfFa/hg9AmfQTLCq0M4fiJZmJDAWPrfh0bdpzjLo7cKbpFnqhw5rvAvdG7B20CaMEx3SdEXoQG8/pKNNL+OMVGCPWZ9iRULQGxNo065cqCtkiYizIqyhB3VGRgYL5cOWCauREsd1ywhfJxEha5o6hNvgzxupe/jggTGIFCIc0+dWRuPUkS5naVjuFk54BnGzSXnbT2PY4nwVHyW7c4dh+wg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 04:43:28PM -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2025 16:22:57 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > > 
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2307,12 +2307,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > > >  	bool drained = false;
> > > >  	bool raised_max_event = false;
> > > >  	unsigned long pflags;
> > > > +	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> > > >  
> > > 
> > > Does this affect only the problematic call chain which you have
> > > identified, or might other callers be undesirably affected?
> > 
> > It will only affect the call chain which can not spin due to possibly
> > NMI context and at the moment only bpf programs can cause that.
> 
> "possibly" NMI context? 

NMI is one source which can cause recursive context but bpf programs
attached to specific call chains can also cause this recursion. For
example in [1], a bpf program related to sched_ext was called with
scheduler locks held and then that program made a memcg charged
allocation which can potentially call cgroup_file_notify(). The
notification call chain again tries to grab scheduler locks and
potentially causing deadlocks.

[1] https://lore.kernel.org/all/20250905061919.439648-1-yepeilin@google.com/

> Is it possible that a bpf caller which could
> have taken locks will now skip the notifications?  Or do the gfp_flags
> get propagated all the way through?

The bpf programs which might be called/triggerd in a context where
spinning on a lock might not be safe, will skip the notifications. The
gfp_flags are plugged through. Basically we have kmalloc_nolock()
interfaces coming up which will make sure the correct gfp flags are
passed through.

