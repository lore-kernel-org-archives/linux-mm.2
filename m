Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C05EF94CB6
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6586B0093; Tue, 21 Apr 2026 18:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9671A6B0096; Tue, 21 Apr 2026 18:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598CA6B0098; Tue, 21 Apr 2026 18:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4510E6B0093
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:46:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44EE18E751
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:46:35 +0000 (UTC)
X-FDA: 84684048750.04.C0E44ED
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 674C9180003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:46:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JwYbqYk+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776811593; a=rsa-sha256;
	cv=none;
	b=NnJWj6Z+gzMj/M507fkKZeEWaBRG+CUpyr3o2cgCMm9vBxoi5UBVnUFe2LkFBl4++YfpCE
	8x3enX4lW9stGpnfArIw0NAGOPSDIHK0nrYqFaKpJeNRknF1nPKGdmadhuPJa1gE6+pe4w
	ojvwY4NQzDBcGoHXEyo3pq6p/YdmjGo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JwYbqYk+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776811593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5d5I8BPQjRssZ1l0ozTg/ouvrTUnVMAjILN1cW7pQjc=;
	b=K7Uv7YwiV2NOYLFgNHWP0OViL5WE8C/816tssMeAAh5orJyI1/U9jQo47hTCJrwgS5s02h
	bXyWktMeTedVHYDsHJrXf7bPqbZvZRS2kUjBNKpGDzZtN58D7lrzReZ8JHsiQvNcqaZxdm
	QRvohGWs/9rkr+1kOjzWvrM1DenRpNo=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-673ee2a98b1so2634795eaf.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776811592; x=1777416392; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5d5I8BPQjRssZ1l0ozTg/ouvrTUnVMAjILN1cW7pQjc=;
        b=JwYbqYk+zYgBReWTpdVtyfsA2GNl+HwlGQdKHYw/sfYq7e3zuATYNzk8rpok7eS5gt
         qXhSi3T4Grcw+3MPMR4sHpkWvoMJTmjl3zFkKgfaW31TKh2cqeA15zqkf35Cu6mtJJib
         e+PdydS0gLeGcZln8X9LMF42q0JMbmpgb4ecFLCLxTBR9mgAoQ2c9OfCj+M1DAWYl8LQ
         MvVrQIxfvSC4EPiBBE3+3Ag/3/8ZYg1hK1Tj5x5JIjXtqqAdX4M8BeAM+VW3COHezxFv
         t1Zajg0c2eXXUnggXgWaVU46XzFZ5r7H2D5x8tZmud07wzMk3CcgnJ3hkhkIGzBTxbJA
         TvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811592; x=1777416392;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5d5I8BPQjRssZ1l0ozTg/ouvrTUnVMAjILN1cW7pQjc=;
        b=Wa8OSDyKH8q5Pcf0Jpdeag92oAgE+0+CqlUgw1Q2wc7+952svc76cdR4+BESb+KU4g
         hagUmUDR0lMN+Ko/SxpBgPUzo0flUkaGEkXQCTQXJO99SsEx2I6B2NoY3siOqJyyNey7
         s2ftwcAU11jGIIOZYDEEwTaKlPPDJMx4fyb9cCHMi6gLpCi0bFdgU/LUH+XCzDscYj+F
         42KmIjI8HneqY35dfT3wknD3SyEdvcL3/ZuYAEhsVBvO1F/ECkIo8zbYBEiJLqNT9k06
         RZdeWAALwWL0a1t1DBPlOCvy2zdLLrIw58PwzjFaEOkUbpou0MHAjEQuUXq1jB/O45kH
         Pyrw==
X-Forwarded-Encrypted: i=1; AFNElJ9Emrs09gJS2VIiSTu4IhQta7MdCI1aV7W6o+6YvQvjzKNn2B/T4E295zOwAkk6deyGhh9doBihGw==@kvack.org
X-Gm-Message-State: AOJu0YzNfy63zkd0JqkU2frE8lSWZzOrmEFKB03ZBHlOGWkUKDz3mqso
	cgMU0O6j5pMStsko/6LuVh4uPdzL36dAHbVXqkjp3ELfx/fTBV225SHx
X-Gm-Gg: AeBDiesZcB6tyZpSMFbp9/f43TAN8J8qHBIMlgtSnvP1L+JA2ZS7P1Jme+a7fNa4Dfg
	6RT/bjsEZmuJgVoAUkMgpI0U+oHxmXxNfIlS9BM0yVhWiqgbqQr5MUm7nlgZCfyxoxiILH0XxUK
	B0AQncstWWBBEanDMep+I9sWa6cPxjcMPwf4gW/bmkqqx6hHJrkJyW9K9KTAZXpyKQaXpbG9PTR
	+UMhQ7npjqBCLBVhBXctv9mdihjELWdzpSa/PbrLz5lYrwoYHMgd2DJz9+95WrPVnVzzWaUmhHP
	GX6rN3188rRU8DS877A5T1WvX2cHaOz0yfJL4XN3jjxEMHc+SJcR9Zr9iDzWC1ABnObvaLgiL7y
	DSaCTvqwEctlqcExuzhNwoIZch1tlew6CqCk7NYzyQ4EyktrOCEdHxuc3iH1t/N9N+kUbF62Hyt
	npKsV1JkrfOP+czlFzEwUtKvgF2vyj56kVjCSEGws/CkO62EYW3aTB4oE7/cTYw+t0mVybCzNgK
	kX9Ja/gwUReCp1lBqP4cly3rN8d
X-Received: by 2002:a05:6820:16a9:b0:694:8646:9933 with SMTP id 006d021491bc7-69486469ecbmr5499437eaf.9.1776811592345;
        Tue, 21 Apr 2026 15:46:32 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-694984114f5sm2023411eaf.7.2026.04.21.15.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 15:46:31 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Apr 2026 15:46:30 -0700
Message-Id: <DHZ7543VMYIQ.1US6BY7G0AUJK@gmail.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
Cc: "Christoph Lameter" <cl@gentwo.org>, "David Rientjes"
 <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Alexei Starovoitov" <ast@kernel.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Paul E . McKenney" <paulmck@kernel.org>,
 "Frederic Weisbecker" <frederic@kernel.org>, "Neeraj Upadhyay"
 <neeraj.upadhyay@kernel.org>, "Joel Fernandes" <joelagnelf@nvidia.com>,
 "Josh Triplett" <josh@joshtriplett.org>, "Boqun Feng" <boqun@kernel.org>,
 "Zqiang" <qiang.zhang@linux.dev>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Lai Jiangshan"
 <jiangshanlai@gmail.com>, <rcu@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
X-Mailer: aerc
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
In-Reply-To: <20260416091022.36823-5-harry@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: 348psfh3eap1qec7e55c9pha54uep1cb
X-Rspam-User: 
X-Rspamd-Queue-Id: 674C9180003
X-HE-Tag: 1776811593-664296
X-HE-Meta: U2FsdGVkX1+X29FvAp6J0ms1SfsZBPFTkUCNHRcUaC/YpfQMPSzEljimHT9h9Xg+b0iaBPOBz1CjZAns8CtB1743hJz2WJPC/EW+LNM3HbA71IGMiB+5mKyO53hI3pJjRQOUOhT6Eg9nv1dlNzmkWJmmExba0gE0OK3U9atio1KlcnxbNe4u+irwVvM0MkHaGQMQAieE27fqdV5gi5b4x0NMtPHgzvrpZrjwgOtt6aZ2auWXHS7imsS5nYRp/dYfHBnCPjqhls+kYodhot8SXy/BjH9GbXCH20von7Z9wtyYs5+61NAgh+kUcSinWLouqvSpv82gBhQasRe9zAu9bOySy7RlBxZ98Bn2fU95ajUM67jh+b8rhG1nUqyKKi2Bnj+2UakAkynDSiGsmq7xXliYQ2dpCBGNxi/7k6L9+7lsRSfFWe3nlANk7sm6bwtt/OfKQ8upeZ9rImFuHBX0Ca7PRCZZfPJt5ax6RiIEPoLpvrTTqdYhxkwx09vV59OFmr4BwK6ETi+8oAR/LMmJYHVXQq4VJNdN4zJoNHWrTMuivkHKhOM4jWtRP+IHaTgwnEODoH7biRZOzAaPLU5iesWg6BZy75MT/56vnBKvpX4r8yBLazNcGx6Zl4/Du/yH7fBEoV8ovRBwdUe+JC2KprF6afs0hC3/08KuEqCNeOyZ3N6bgamJ/mIkFzemdVTFu5flozu6f+6Fw+P5VHU60YF2jgxW13KuHLuaeMiVMWTuVCBdvrrRlMdFlQjTEGsvUtT3yTx7ACtNiZqT+C+7b1Fe8HPFU2H5Rd/9bSwT6oUU/B1URD0IUZb2hyVmVcDYLxWSB+XX92Gg+7le1TQOzn4CtYx4qD3qr1OarCz12d18nnL6ukgeee6XXDuIMFDokfv2sLKGLom37f6uUMuqAiKjKjD+s374XuZb2LjxFLZakSZqnuwmFli5PxYkhgWQfyhe7LQslS5XquRk+zr
 8PNunwne
 9DoyWPJehhcRiDSTVpZgojDO7wFZRThGBwIzgOcYIGXrkaUkGzHDAxAwRCHAQPHG8lS18cveC9voNyS+3tvcMfv1++wPnj7UcXfniRFdzExKIib/fW/veGHOGsZCpSCZr1cCWhdG74asfMrXv7dGiR0rmhGmbQhz+W3XaqMj0e197/xIp6pG1c3VQXKRtFcOwHnKO66lfjFvtxoqElpTY5gDjAKGCN8Mdu46auVk3UUQtNImda92rODPllkBMKxzgRTsRF5LHj6upkMvBHLGyU9rcvFstheTb0Z/RkpreJ8VI2UQGbvmGWctmUNTWb6H4x4VsTYynMJKiAV3jAUXsmaOslbXLXGXdVoWEZQttByyBm2xEs2GxGjQLQV5GTzv7ikzO4X2Hih7mKOUVSb3vA5/lw90p4/lwqZZRXjeLAu4ZYsZSVR+4W009fFvgQCCqO7debcJtvt0b8LQ4idEqFNTjpA1zziZstW6mJVLy9O2SpcVIbdbUD/Fnwfz56VoL+it0IN9q2cHt7BPvTYGtBfGCeh6mFUzKxKMLQhxijDunhbH2QJFmUM+3rdth4TFfgM2SusZmelSzDpFU61uRaqFKIL7FtOdWuBhULJ87V++NbTPQt3oanfRO3TsjZ5fJqIeU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Apr 16, 2026 at 2:10 AM PDT, Harry Yoo (Oracle) wrote:
>  struct kfree_rcu_cpu {
> +	// Objects queued on a lockless linked list, used to free objects
> +	// in unknown contexts when trylock fails.
> +	struct llist_head defer_head;
> +
> +	struct irq_work defer_free;
> +	struct irq_work sched_delayed_monitor;
> +	struct irq_work run_page_cache_worker;
> +
>  	// Objects queued on a linked list
>  	struct rcu_ptr *head;
>  	unsigned long head_gp_snap;
> @@ -1333,12 +1341,99 @@ struct kfree_rcu_cpu {
>  	struct llist_head bkvcache;
>  	int nr_bkv_objs;
>  };
> +
> +static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
> +static void sched_delayed_monitor_irq_work_fn(struct irq_work *work);
> +static void run_page_cache_worker_irq_work_fn(struct irq_work *work);
> +
> +static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) =3D {
> +	.lock =3D __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
> +	.defer_head =3D LLIST_HEAD_INIT(defer_head),
> +	.defer_free =3D IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
> +	.sched_delayed_monitor =3D
> +		IRQ_WORK_INIT_LAZY(sched_delayed_monitor_irq_work_fn),
> +	.run_page_cache_worker =3D
> +		IRQ_WORK_INIT_LAZY(run_page_cache_worker_irq_work_fn),
> +};

I think kfree_rcu_cpu doesn't need to be per-cpu.
It can be global llist with single irq_work for them all.
Not sure about sched_delayed_monitor/run_page_cache_worker.
Do they have to be per-cpu ? Can all 3 share single irq_work?


