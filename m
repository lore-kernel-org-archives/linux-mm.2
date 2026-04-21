Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6730AF94CB5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCEF46B0088; Tue, 21 Apr 2026 19:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0356B0089; Tue, 21 Apr 2026 19:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5E16B008A; Tue, 21 Apr 2026 19:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAFB26B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:14:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 535B88D717
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:14:25 +0000 (UTC)
X-FDA: 84684118890.30.54BE7EE
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B8E240016
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:14:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k2hmt4sF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776813263; a=rsa-sha256;
	cv=pass;
	b=pP0HTyYs3ffzJZ6kJyzmaoNXw93QuNXG8Nk3eapUGsDTfRyKix4IJbIoxFJPqS28isF3lu
	fDrkukHWv1vXotsTo8CTEnHAaygFKUuHKr8TcBSQ7cCRy2UnIZcBgFhfd7Qq3dHnacv6C4
	TbZX/dOjIV8Hl7Z3LBByVf57hsRuFX8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k2hmt4sF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776813263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSiUAjPuNkXKxVnQ9DAy1K0IVEzKOiBtHeFUSRjnTQQ=;
	b=FFlfBjvv56agbE27z8QxaqtFCrWZBrhbatpohO7vb/CKRtd7xyTh5ccHGtlMi5j3Zxcs5u
	UJWoSDaQ8NML3U8D0/pBKrPTyYbgETjYj5aus9LON5ffOrniATin+tAywtRoBaEc9C5yny
	H/D1GyL4KdLyAmeMtISyni+nTIJKiGE=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d77f60944so3859044f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:14:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776813262; cv=none;
        d=google.com; s=arc-20240605;
        b=GIDoaFp3VskRKFD51FTKxLqrbC2Lk8i2yGPs50dwmDTZ6XzS7mOkKIWHoBxV8oMHFG
         AB5s2MI6N0lWyrglPWyK3zSbQUUXUxAjzLe53BVVfbiIJRAeet/O6KbYdJ1u4p2dwh4m
         ePkW6bRxabxfF/d0+KsSW/xrZl/xRbTN6GbenudoJOcNHMyf3FTuUTUauUxNEiEb3GJh
         JcHjXBRB8nVW3/q2VsG9gHX8lB6xcoHZ5YrcAXSWKwYIGXMaLkX9qg1BnbGKMhKgwb60
         jhYCNZZIws6FBlHy3Zl1yDd1x/O3pomo70vTPpz4BacDuAIuY+dsahM1V7jUx5nK57BM
         C6Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lSiUAjPuNkXKxVnQ9DAy1K0IVEzKOiBtHeFUSRjnTQQ=;
        fh=ex2SCpYBN10C87qBc8iAPqp07Yu0J1kj0AT3gUtwLWk=;
        b=EZNU23B76/GuHJU2FjKZeQ7h0t4DhBPuYtxfngL+Up34+dV9yVyEaOF0HTdlQAWCnD
         FwHSj6keK/m+TPySy9SWbyOFKBbhjCX54N0TL2qKOo5Yx9nqfhUU6Y9CyiNTiVQSOfnJ
         /gH++jiZSpphsGu2v4SD5zcXbdz9jM2bPFCGBAfrvkmsiAL/hsIpjrbT8jKpt11MApCl
         Dv2c5ZbsAcpze1dEghrj3feizFfK3YdwucUboc7KYnqYvmQlXnXmrgxpkzh++N3sBE4G
         Bi0+fBIb3hA1h+ulYpq91EHrEWc9EsJI4aquwRfnyGYxQC1mJ4fhiivmlee4OxRAhyM+
         WzDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776813262; x=1777418062; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSiUAjPuNkXKxVnQ9DAy1K0IVEzKOiBtHeFUSRjnTQQ=;
        b=k2hmt4sFVnVerYseUjT3gH2RD49mg/LuQXRdol0PB5uw/WvJjdLUnzvKhrjtW7aXlW
         yaAJe6jn25zvWs+tMvEl2mLCK7DRg7ZFazzMXXuvm3TYSkPmbEPIN+dx0BdcWNFGnAmi
         XznNw/2/Cco8T+sRAAsqU8YpzfpWejU4TlCnJv6bSpq88v4GMNVeHQi5hGEAjrakIf8M
         nRmxeR5PaE+fdMUJe0joYH6QYAJvsM1c3eIbdlnMLchnBtCgMVGa/g8hAvA3IF/PUuQI
         AwcueIqC/hznX9soBO7xnOss7DHImvkCVC0y9yOgbxUEdj3tT3wXeAnee44A6wo9i2QI
         2QuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776813262; x=1777418062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lSiUAjPuNkXKxVnQ9DAy1K0IVEzKOiBtHeFUSRjnTQQ=;
        b=W5gP4g2J9DFHc01v07cKWZDwqvv2liW4JBU/owJDVmmdYv65n+YSiF4QV1/wmbb5oP
         ajoDX1jmrlTuOnVCc2hHtM4jI/D4eCi6fXQJ8EKXt7fVax0ur+9Wh6uf1CQ4AUD3NvE0
         l+Z4KrB2kXUrkdo7buW3Q5ULFB3FW/UPick3JDHpHBAkKCCo8lWGZ+3BEpv1B8YDBjji
         fMmOHfdi8RXbkc2ujo+t7mnzTwuu6I+8D8sjSL6PijOUI1cAU3WVwK817Kp8zx4HhjTW
         RM5lVT0HXc5c6HiUxDpa5SYX2Tc53AcbK7q1YPtLCVUDv8yKx/sd44Arbyz0IIk1jeiV
         3vHg==
X-Forwarded-Encrypted: i=1; AFNElJ+LYnKkK5EKCrTnyYUBux4WdddCP32mK3URQ2xax7gUykj3sDsQe06zJJwlG9xpEUmiOPoddVzCdg==@kvack.org
X-Gm-Message-State: AOJu0Yy8dMyFvNnjnpgpIfjX5oyGDTP71V7NT4mMYjftZa/jUCBgRW9y
	GzAi5IjQPsgehB47KiW3W1bfrWuQ92i7nXkGYe/+ZHtfpHIdVJlr8VsblUZ+Oo+Bhdkpj/2QIj+
	NsuHkYiMDT7ilOkYgX4QmAmCRrwPJJmM=
X-Gm-Gg: AeBDies5e3j3z9xAhyRyVEygDMnjuUgnPe4usX1zjmCCzXtnaVIfg+P9ILyYma+/lQu
	gNgddTyHkIhlYNl819x/nQZJi9wjIynDui//ggveJ5iq6ZcI8Q099IkFYb2AoRZnmyrST6uKHL1
	3t7iuVg90XGRWl1B6L7GCLJo158EXKGEsqgJfAPcNfNqb9FQLjEmQAT5G7UsyiHPLfygm3xsGjF
	HZ6cKJcWD7zysh1Rm8DlUWWxMEHO29Sfqd9NrXwPIh5cqXKSQWIURU01z2BzDnVx58soKejZR0A
	Lfmy0/prdpBcbcpNoX2vchrUNYFw0iLR5oCobGASEKlHQnvKOhkmKephFC4og+MhRc6QQtcxo1a
	2n9/HAjI7582Xh0kotc3vKcgZCJSHccqSbYFd
X-Received: by 2002:a05:6000:18a6:b0:43d:1c59:2dc with SMTP id
 ffacd0b85a97d-43fe3e0dafemr32331162f8f.28.1776813261540; Tue, 21 Apr 2026
 16:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260416091022.36823-1-harry@kernel.org> <20260416091022.36823-5-harry@kernel.org>
 <DHZ7543VMYIQ.1US6BY7G0AUJK@gmail.com> <805c33d7-3a7b-470c-bd9d-065717a3e3e2@paulmck-laptop>
In-Reply-To: <805c33d7-3a7b-470c-bd9d-065717a3e3e2@paulmck-laptop>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 21 Apr 2026 16:14:10 -0700
X-Gm-Features: AQROBzCsiHo72T3ksF8bPj7_lkbDTn2EXriq67eSQ6XGFtwVUqizC07uHtJfjmM
Message-ID: <CAADnVQJCJsTWOaTWVVwtDZtd+UXMWz9SArTdYsAj7dyif5aJZw@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4B8E240016
X-Rspamd-Server: rspam12
X-Stat-Signature: urkdskpmybpkko8d1d8dietw6kxjtotg
X-Rspam-User: 
X-HE-Tag: 1776813263-537823
X-HE-Meta: U2FsdGVkX1+tKx+wLnJ8inhqxcLZVTNbCJ4FWUiu68NF73a5DZ+idfFwmbHFhMXBWSNHm76ZsGTyKWEmUpY+8/yKBNSSD2qaxFyE4v+GHZHrefnV0GUtAlV+YIDvJ+rlVoI/ZevZnibFzcu/LeO5z6AdDG9HYpx/m2+y141sHEg4sgkZm9DrEA4k2kVjQg65ptHr7LBEqi7QUAXqUV/iMtkYjMsNdVm3w7Xt1sr5u/6pxavvvKrvryYrGv6lQBFPIY7CR38Zv22fEJp/XrX4oiKeRp1aHWc7EgTLPFIkfj3fLMKgnLF94rs5vXf0U4qRhzDDYBKTlVxCUy9L96s0O8codAGjBMLwNlQs/lHhrbXYT0XYfdVg29jg+AEkxSX06GKq6KxMKYj8ibHyZrjV3EJMxLhzxMMu6PQ0C57Ew4CRxiO5dH6w8ENjhxfOYaUh8LGPAKqc/jrpVtX6tD0hGDV9EYKbFglNBb5BWSCYV34vLShYGa1yvQk3qOCPWMIPacwquudt/SE/dWUcZPzRwVAxeQaemNeXl/x7Mi8S50s5TagZ5s8PuZRJw9bal8TgPRb6DMCTVAPz5Iw2g2s5WeUEuNdCijE0bgFj+iIcVURH7UoXy6xo0EdBUhpLYZVfB8dsKgf59v/AxPW2FIXpA4DlJQU+oUTAFcJZyX3SA6VnqxnBy1f9GLBP/9hMt+1tb6KTz415uA67o+QP3EIyHyWin6l7Ady+CrdIy5+EksIFtEWmisF6/aIygkVcbOX7+5WKBXu4K4eSyvhzJkTN7rb5gYUS9PIiMQ3Sv2SUBSZ7hTSB3LBL5uvo5lAEnps3rsiYsqZFGO8ErVFF9FLc1d7kBzjFN63nS3ROqSrhUZuR8LdtIruNkVX4uvcEQozHbVjRuN0ODeLlAEQmGqCtf9jVboeEO2WJwjIp0zsyKUacWdRbjSxT50KuPw+2zBHbewxj73hC6uaOuxraiIB
 z8Q+9+Hc
 TwNl8XxYPzZgAWADwcpbRpDwnBbddfjuDo8hr0M1hy2iZtoe0gdjLdHbjGn7X7L0ayVT6riS0dqr3FuEjEEmXqAY2VUwtS8aPrL1/HY2B9e5FLdg8z7QvkvYC1E86BW7KgpCSh/IvjnwwT40S5lXlmNFnwNRGQRtATdhNklFSr2ZUtuh0ZVlt3E5mWGeKyatmBmpuR7hPXGxSz0dxs0feqbSaFI7uwtfmKomw2H0192axVQXE+zhCT+dmg4FqrbHqG2EjDz2YRXObVzZi2giz0LeYZVXsW1I+J9ohT2Ca1KhUzlPnp+AAndItmkLJP35lEl93O0IFA0VSlGumDqtB+HsknNCEoeqN+X8pAejOM0Z9AlJxQztzmfE293tuOiwf8pTaAZ3yBtk7gNAqLh+pFxjiiIxk6Q7SuBmF6NyKeK+shS6Cm6ohE77yqrq3pS9fYUGDr1Qlin09dgyNqTs1VmvfggEZ2NSm1rKe1saWuuwL6xZumfoOb363sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 4:10=E2=80=AFPM Paul E. McKenney <paulmck@kernel.or=
g> wrote:
>
> On Tue, Apr 21, 2026 at 03:46:30PM -0700, Alexei Starovoitov wrote:
> > On Thu Apr 16, 2026 at 2:10 AM PDT, Harry Yoo (Oracle) wrote:
> > >  struct kfree_rcu_cpu {
> > > +   // Objects queued on a lockless linked list, used to free objects
> > > +   // in unknown contexts when trylock fails.
> > > +   struct llist_head defer_head;
> > > +
> > > +   struct irq_work defer_free;
> > > +   struct irq_work sched_delayed_monitor;
> > > +   struct irq_work run_page_cache_worker;
> > > +
> > >     // Objects queued on a linked list
> > >     struct rcu_ptr *head;
> > >     unsigned long head_gp_snap;
> > > @@ -1333,12 +1341,99 @@ struct kfree_rcu_cpu {
> > >     struct llist_head bkvcache;
> > >     int nr_bkv_objs;
> > >  };
> > > +
> > > +static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
> > > +static void sched_delayed_monitor_irq_work_fn(struct irq_work *work)=
;
> > > +static void run_page_cache_worker_irq_work_fn(struct irq_work *work)=
;
> > > +
> > > +static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) =3D {
> > > +   .lock =3D __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
> > > +   .defer_head =3D LLIST_HEAD_INIT(defer_head),
> > > +   .defer_free =3D IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
> > > +   .sched_delayed_monitor =3D
> > > +           IRQ_WORK_INIT_LAZY(sched_delayed_monitor_irq_work_fn),
> > > +   .run_page_cache_worker =3D
> > > +           IRQ_WORK_INIT_LAZY(run_page_cache_worker_irq_work_fn),
> > > +};
> >
> > I think kfree_rcu_cpu doesn't need to be per-cpu.
> > It can be global llist with single irq_work for them all.
>
> I would be quite nervous about that, but you might well be right, given
> that this is a trylock-acquisition failure path.  Give or take people
> and/or machines analyzing the code for potential denial-of-service
> attacks.  :-/
>
> > Not sure about sched_delayed_monitor/run_page_cache_worker.
> > Do they have to be per-cpu ? Can all 3 share single irq_work?
>
> On the other hand, if all CPUs are doing kfree_rcu() in even a semi-tight
> loop, having them all unconditionally use global state is not going to
> make for a fun time on large systems.  And there already are situations
> where user code can make all CPUs to call_rcu() in a semi-tight loop,
> so even if that is not yet the case for kfree_rcu(), past experience
> indicates that it soon will be.

My understanding is that defer_head/defer_free will be used
when per-cpu trylock fails, so it should be rare.
Hence the suggestion to optimize for memory.

