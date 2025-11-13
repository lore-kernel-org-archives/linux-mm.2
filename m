Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99C9CD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2368E8E0019; Thu, 13 Nov 2025 14:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D6C8E0007; Thu, 13 Nov 2025 14:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B638E0019; Thu, 13 Nov 2025 14:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0394E8E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:42:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A88A1136EDC
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:42:10 +0000 (UTC)
X-FDA: 84106604820.22.4E3CE9C
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id D9834A000D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:42:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Syi10JMh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763062929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sr+mE/g9A7nLUx9cy3iGddinYybt/5wEHuhrAkq86kM=;
	b=1yK75F+05B8M3qmeuaxEMTR3sqWAeGknHc7zy9C4z+Ayj9vkWvBfln/sbRMRw0Dy9mPAMN
	WRQR+0HuTA6vqxJKKjS8KIfSzK38HM9L2GdO3iJs2y9uJSutnyYrXkvFYatc3uvZzbR1Np
	VAqzFkFoR39YsVmk0ADjwhGr7Hem/h8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763062929; a=rsa-sha256;
	cv=none;
	b=AtHtTyarPnH3YkFIR4GXhr5PcoaV2+amqQPLLSmSkUOLJvBp8CQyI/oGDr+lypMEmKUpcQ
	yb7nnEtxnl6MSUkb0M7AtveSAHf9tZ9z9EIBBYhzemJvXNSF/m8TioN07NMFoEim96Lsol
	aKiDVR8tg6PU/+3j/fEdj5xbtFnukXk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Syi10JMh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Thu, 13 Nov 2025 11:42:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763062926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sr+mE/g9A7nLUx9cy3iGddinYybt/5wEHuhrAkq86kM=;
	b=Syi10JMh/3pP9J2K8fisk3iwRdinsLLiZtkCbfgUsEu2LDgYB5sTFbxcKYmw7xS7oDpEuy
	5i9qHRz0S+E2gRTnqHtNhSWgythBX5oHLj5hiE6cQ30w2Si/LMHIAatTVb8uo6C2s5H1ld
	TcjPghaJzzR0/cGEifyoEMpcZ0VDwko=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Message-ID: <offnmou66hzgrlbb7owyya6n4onn2g5iuv7matbqfvsigg6wv3@3hlu55yai42z>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
 <20251113161424.GB3465062@cmpxchg.org>
 <45ea66a3-bf8b-4c12-89cd-d15ba26763fa@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ea66a3-bf8b-4c12-89cd-d15ba26763fa@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kjcs949147r4m99qitz7co8ufuncfbhx
X-Rspam-User: 
X-Rspamd-Queue-Id: D9834A000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763062928-536361
X-HE-Meta: U2FsdGVkX1840iFlx3BKHH3AfC4ypPT9sWznJQ4owYq9IdftgIESWPb8W0j6scJkIsnxh+VJMSjQIk7lexUwLawCsHz8WHUZnpI8H11ebcJKVCPxrMF0mQFkmY6YsAB3tSG1OFFt1RRW+oiJIRYAmRWLOPn+gcCcyyRrAbXRn4iI5U3MjmVn8WCKk1SRFqdTQgXxQihWlsMyf5+FdV1oZD5WJIwl4fjU+kmuKFVnvxsQ/vALDGGfOhruLONCcl4kK/QFrNy+sC1tTBYvgqfkD7grozYIHhEcbb0QdC7K20xxmAlzoSO7E29BeUMBlxiOdarPeEHYSBo7tUh7zNReH+ritnAiIVGO7EpaeBhGT9ld1bgLMITCTJJIsJDUxPU70GzaecFauID9vuUCHdjFHjmXr6KwycH9TS2a9HFc2gXsKOclNP0qbxcK1CSR9MmxnayVNQ59Qv+aRQVrkaOY0Q2oY88lFsOPlZs6t8fBCZozPlDkvIgRbbtMISXjZEhrjzJqSzCgXc1QhyKOFX8fj1jB6Nzeo/dvN7EXN/TWD58wXUFWcXqXmpotrSe1S8wpZRLJgFHqg747WLYLLRwq6o5OSQmNQZR98UPDjPfzG8vMrCtxgBvMqq3m4dEjHIO2lE0FUqVDIOFASo8cEfzbbBZKPk4u8Z2U0QZShXyFKEqRNRYtMmRYkE909s0y8WWhptUvnePAv+RprxupruonCrmuCTe1Vk5RZpDFijOBMlPZnjW154oftT9We0du+v6crWzTzlYl2MAMt9EADo2K2qVYPoxx2acQNjjR9r7WeXcwWMHX/S8hBqXc4s66tkTn5L0YtssDjfPtAGGKl7mCeOThIAat1gW2Unm4JvF1sYJSKUlxGZyBCGDgFTNxLUHDoYNUPm53Xku/zKM2JaYqCR1r+PjClzLZt19KCJi8ql8t/yAhlnRCgOYFkX+HeXmFclfPISTbM5h1Yd+gAID
 WcnOva+s
 qmiEXqxCZ+jFqn9UzQDWk5zW8gwf/nOYznOJn2Zguoly/MRLoRYLbm3R1KbhAbY7U0S1JTsuy+3QjuT4iSIprb3C5dNvqOML/klF/BMB3g6LpGh0eub4+nAFPPRFl3Q7HbixFkZLuA2aIqP9l++RE9K2FHxrW5MWnlJPtECTpcGhVqJ8UillvyFFxPfu57a1JMkljzwSqKnMqYPx4TJ1L9zZuY6/IIBMpzjWNGgDV8JKqKzBY80O74aQ6zlIMJ9JAFWw7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 05:28:59PM +0100, Vlastimil Babka wrote:
> > E.g. !vmap kernel stack pages -> mod_lruvec_kmem_state -> mem_cgroup_from_obj_slab
> > 
> > How about:
> > 
> > 	if ((slab = virt_to_slap(p)))
> > 		return mem_cgroup_from_obj_slab(slab, p);
> > 	return folio_memcg_check(virt_to_folio(p), p);
> 
> page_memcg_check() maybe instead? we shouldn't get a tail page here, no?

Do you mean page_memcg_check(virt_to_page(p), p)? But virt_to_page(p)
can return tail page, right?

