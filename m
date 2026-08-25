Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C07C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3886B008C; Tue, 25 Aug 2026 10:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84F96B0099; Tue, 25 Aug 2026 10:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99AF66B009B; Tue, 25 Aug 2026 10:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 737496B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:14:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A214D14042E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:14:54 +0000 (UTC)
X-FDA: 85139988108.22.64C8E5C
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id CCC20160011
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:14:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YjLQOr32;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787667292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzWIh6DlqJMr1PTrDHYtnn99GHj3f6bDeC0zFfCY+Cw=;
	b=f39SuLnxiPm7gIs0cZGoUI99yxlDZ8b1xm9aq0DoHavkdmfdVHCE/0dNfRlUrzzXw3AKPl
	/ZknGma0Nqu6h1gTZN5hyLXHjEeY8HBsgupwsjgdLpuINp1jz4Gzs1/GNxspeXfvQBSnHk
	b5l098No5Tm6EBjl45ZfSHwdEvo3E+w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YjLQOr32;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787667292;
	b=mI1Ofe0OK4IrPJAjGpol+9pmJ+8q5DgroC5XoFFexLatAeaZ6pMf/HsVrXT7eMqecdMd34
	HhYPt8MUtHqchfTT4Cyif5Y8Pq4wvV4+Jadh9BwEw/rgJh9yKFlMz9KUL2rLiaTU7eXEO3
	O4lgI2NkDmWscilTpiZX8vYqbw98owA=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15e2dab83eso894818066b.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787667291; x=1788272091; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KzWIh6DlqJMr1PTrDHYtnn99GHj3f6bDeC0zFfCY+Cw=;
        b=YjLQOr32jG2qqQw6dElN/Tiw+FpglTvNjPyGMmUdbJF0tPw2SrOdQsU/UPP5PGNMlW
         bY/qQFLE+GyI4P66LEYHv+hEdoA1l4Nuve+X2EjSj01TD4/aMUvK8q8zys4pfrCLlUZy
         TfbJ8zxssAEPtHsOfZYTUUSP4WywhsxD+cZkltd0tvudxhCYPeAmL9Wxu8g7tgpDessI
         Q9dfawsapF3blfIIVVwAaC29V2r1ukTH+CzqIjCAzhxkb47YILm1qc4eVQSK61EECPgi
         RdfYrTHe4o3ToBHGfvj5Ay41nC2v8v71pjd9TKcMmaDsVQjkqubAx4vYGSPql7AM7JfO
         mXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787667291; x=1788272091;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KzWIh6DlqJMr1PTrDHYtnn99GHj3f6bDeC0zFfCY+Cw=;
        b=QXE1tJaE8AO9cEXeGytTtOsNTXvkYYgxA3Pg6kuHtEda4aUZIOC3VPOy6OJ7z3hosP
         RuQGjgPVhJSoMvFrmTZ3YJdUS1xgx8/FBC2Rn2zq84oBwgei1tqK1J+CKmz+HRwuZns+
         W6mdk0rWldVi1lI3kZGCZLzPpebNMgp7nz02pv4pR95K7qRsEhowWnPPQr3pFbVeEdG6
         ArIyVlDOAfHHDMNWTdP5JVfH6DIurbimqrn5UiHiIDoCCntSteNpZ8V0NSWt6RsIK4ow
         Ik0RLM9Cn73ssi/X2PceniW/QkxzC/bcl7wcjxz/fdsE/7Kzw6h4q5W5ql2MZFHrrIuD
         Ldig==
X-Forwarded-Encrypted: i=1; AHgh+Rq/0Fd4BkG8nCJ7ssa1ejgywajbmINWZJhyifkger84wOq6KVbeGd9M08HuVWUCpTQZwByLrX0A3g==@kvack.org
X-Gm-Message-State: AFuF++nYqozZ8ePKaAWin1rYZ31Itd+Zt6Q+KXi2oH3lMc9a+vSPB1Sw
	fnevz/6Q99Yke9uA2o/RD58EV0oz4+y9zLJl+poRmeYg+aL6TIJzufIc
X-Gm-Gg: AR+sD10Yr4PoGDYYWXvaYDZzvFEwsK/ZAWaJhZnfgM+/UCi55sKryjLJQiosG+r+LkP
	USclbl+5bMXi5nI8v2m0zDkwo6w17z+kKnu1HuXMIP5NjGfU6U+cmk73Zm7hrSo6kIDKOeJjfF7
	tO3Hk9d75N3t4AYa49UXeilTN9+Dv+/9JcKeJOZPK0rNX+0SnSFyEemlcRy3pUiKDCIREHMQ4x5
	R/Z6/O880VZiDKlC0saCXd/uEmYJrmt4VLtrXTOxgUenkT6VMuqQN4cPrW69kahXtBUogKyITXs
	QDhhFxw8M9up0Deu0fL93McN66HgfocVZYKBO2FKJW3uwTk3UqN5RTQWlmhXmHV/xfcVrIOf8Uk
	BZqDzJGSNcKafn0RWdmmGkaMraWdrWn4y57QTaZs5NvL7Ny5p3a21dXoo+MR6JXliqxLBUGOYbW
	6+PAPb6zFNjKykGyebo3VgYA5xRw==
X-Received: by 2002:a17:907:c00d:b0:c16:242a:472f with SMTP id a640c23a62f3a-c24e6048e27mr956604666b.23.1787667291034;
        Tue, 25 Aug 2026 07:14:51 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249689fa97sm1629795566b.57.2026.08.25.07.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 07:14:50 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 25 Aug 2026 16:14:48 +0200
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, jianhuizzzzz@gmail.com
Subject: Re: [PATCH] mm/vmalloc: avoid false sharing with drain_vmap_work
Message-ID: <ao2jWHkn6mNJbtzf@milan>
References: <20260825104659.100134-1-jonaszhou-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825104659.100134-1-jonaszhou-oc@zhaoxin.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CCC20160011
X-Stat-Signature: x6h8ft87reshkdmxikrxdib78bqnr1y5
X-Rspam-User: 
X-HE-Tag: 1787667292-920919
X-HE-Meta: U2FsdGVkX18dn5YIQi4VeOVztNAD7S3bUT8No5+bFEHoBh3WqMSqvKefIGW7XqcMXkpORosK7Hm+gQWLaMTs1GmU0bRXVBmE21vLL8J+zVVcawgAUE898PMPZB/hZ87w3yDFVz6y2DRBezenBJYUeK0qCYbbb5CyF8Vy5dm7xVFQ5Vqb+yuxvh5qAEiU3oxZ8iQ760riUg7NgFtDn+MZYkU6W9q6eXq9qjuYMQc1hqX64DxbQ2mQkMWZZRN4CL/6WdJlg5W+HYCydyj8imb/5kuOnIC6mRfNZO2ZPh7fBCuyuel9BhF8pQ83PB7yzDsRrshbnZ+CubRCAm2vyybyo+rM6vac/4dzOzYBcq8BM1uY4yeFcnSJNVkXTF2g7IXtNrC/qnA/gVEIlQjKBp+tWlWPSrT1nFEYGsaKK3l+xQ7MgrVX7pEaeH1lvzGYVO8PRIfuPUn3JIKcySv8kiFRUl8k+X16CjBLzcuuxhqTxoZ+o8pYa9j7X1A7CpQc8Tmziepsx4JoAAn96/9l+nfYvFinTAJk0qaucQl+3MJpcqAw1VvbOaYKrmNhohsz9ozQnw98wnp6502pi8meNSWJTwgA3eYgSIxxJpSuHrlWe94W4vqj2WBRWptmdvcJ1G3aeYTyyzR9wQAnxukjwQXt93DdygTiICZw+dlquPSo7hDkB1z/xgiAcCy7VQXHTh99G8cEdFINdFO5cz9xFADDXLAh1ExU1paD4jTDTkIIQd8VC25RiaE7vHFyIFNoi+em++sCh1N3G58miEzN/xX55pYpLUPdotD166lhYt4qm+jeB6mvdtVzuVzbcjHr4yZlvWDCHzJmUN6cZA8J4Y8fcvSn9nhJ9R/TXuQXyeRU2WrlJW+jN8x0g1yikZR40JAr3R4zUnsDKPrLdPc4stOBU4LdYUz2Q5RzUxTlIlhZ2dNgZV4vE4Wd8FXdIEutLByuSanl+x6td9N5OEjg05z
 ojeh4tB0
 Kw2OFvuO84SY+is/FmPhByRzxxbt/NkvyUvhckXIuYME/xJMmIWfuW8AMbBa6GfoT9RbETZKAQpQ7L/KqCqZGQbyjtA6kpxzzy7sgrUYwccDfituXa5iguK50jbjGaIwV5XTk0oGPT8Mb8nqeZL70Z4QUak1QqJPEfpudsjZigBHsu2o0X+FlrB/J/TPP5O+duR54JxAVfwYdCWEtV838SCRSK8XQvKIcos7bcGx1hcUG3Z7ucC951FMoqhF7Ax/GMr0uvdZItTaobWPzeKrePXYDqkJ6z1TsAqg3jZahbh6EqDrju8MBXHDC1l1/Yx/aQl6L2TydTd2UkT/q/kXn4xY22YkYyKIbkIxDajwdbznPOcgviRE+zY0wUYwcITsZqeyo25xh/vGtB4yFQDr+X29OOEmIMjQbCPou4vpGecGOfDSiXyYCgsEhe5mldkgkXs7SthzZo4I6ZHVNl0ZgM6CJqJdoYrBTcVHfdOyhFTy1f4JX/50gqHgfL0yHe2wFALPVde1V6YiZGctgeeZ81duhq0uHqYL/mXSlGZIpHJvk3QYFf6k0zMGa+vJ8RI3zN/te
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 06:46:59PM +0800, JonasZhou-oc wrote:
> free_vmap_area_noflush() queues drain_vmap_work after the number of
> lazily freed pages exceeds lazy_max_pages(). Until the worker purges
> those pages, concurrent frees keep calling schedule_work(). Even if
> the work is already pending, queue_work_on() performs a locked
> test_and_set_bit() on the pending bit in the work item.
> 
> On the tested x86-64 build, drain_vmap_work and vmap_nodes occupy the
> same 64-byte cache line. The work item starts at offset 0 and the
> vmap_nodes pointer at offset 32. The latter is read by vmap allocation
> and free paths, so updates to the work item invalidate a cache line
> read by all CPUs.
> 
> Put drain_vmap_work in the cacheline-aligned data section. Tests were
> run on Linux 7.2.
> 
> On a two-socket Intel Xeon Silver 4208 system using 16 workers, the
> runtimes of vmalloc.fix_align, vmalloc.fix_size, and
> vmalloc.no_block_alloc decreased by 12.61%, 5.78%, and 6.87%,
> respectively. HITM samples for the affected cache line and total HITM
> samples decreased by 96.55% and 13.36%, respectively.
> 
> Signed-off-by: JonasZhou <jonaszhou-oc@zhaoxin.com>
> ---
>  mm/vmalloc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index f4fa227a8d7f..6b4b287e91f6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1088,7 +1088,12 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vmap_area_rb_augment_cb,
>  static void reclaim_and_purge_vmap_areas(void);
>  static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
>  static void drain_vmap_area_work(struct work_struct *work);
> -static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
> +/*
> + * Keep the work item, whose pending bit is updated by freeing CPUs,
> + * away from vmap metadata read by allocation and free paths.
> + */
> +static __cacheline_aligned_in_smp
> +DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
>  
>  static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
>  
> -- 
> 2.43.0
> 
> 
Makes sens to me.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

