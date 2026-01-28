Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CC5CD46BF8
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 20:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8276B0005; Wed, 28 Jan 2026 15:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A87F6B0089; Wed, 28 Jan 2026 15:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7D36B008A; Wed, 28 Jan 2026 15:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E99F66B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:22:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DA665B3CB
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:22:02 +0000 (UTC)
X-FDA: 84382494084.17.E5A0ED1
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 60F7B1C0010
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:22:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T5bvitWa;
	spf=pass (imf18.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769631720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOneaQwgm5r1vQWLDH+rGl4A5aPHuLzm9ueYQTD0ies=;
	b=Tu9XlEXxtBKmUZWYSHoe6udDwgl8MmPrRNdIcTDgKwDmNsPecQIIYBJYGBhrvByh//wkrR
	kcQV4elbWDu6GAIr3hzWrZGvMcqipVlFKiRXiwAnyi1qNXWrJvV5GmIcM/4nHQTOvZE/1R
	4+3mY1lhE4dg6NvjSeObulHru6YoR5s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T5bvitWa;
	spf=pass (imf18.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769631720; a=rsa-sha256;
	cv=none;
	b=beVFIS8pturPVi/U4s+SV2Q4+zWs4ZXyQtLrG/02D8WGYmqlNNnoJMeappyQr3KruRPBx5
	5ImIC4FspG8664pT50RC8tBMupXfEm3yxevtRIwKI+qaZK5swOBoBdWV8BpdKIHIqMkAcR
	POVy6oE+YcnktP5ejc8l7rm2fwLuVzg=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b883c8dfb00so65682866b.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769631719; x=1770236519; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MOneaQwgm5r1vQWLDH+rGl4A5aPHuLzm9ueYQTD0ies=;
        b=T5bvitWaQWmzXcln9zVdpLXFe0k58Sf0sntYAojPRbTneQEgLXz6jNGQdyNGnOTpav
         s0u8076LddsR0+QSbb0JSSdOL+NL6ZUi4jcN735dy6jREhgCHxorrc6RIoKQM3uLvQ3G
         Zjfc8DlG984oUmfUKLLCwrkJQoizxMvRrhY45tPWibuOD4YrMtzwlIsnye0yyJ3oTiSz
         QnbWat5+M56lgGqBDNO8Q1f0ZIlnBxDgKXLx8ednBiQoVK1PdzQtzxrsGbjFM3JCdtPB
         bCJdqIpnWOkxtjOOLodJ5twI34oArRKYF8QTm0R12LKzwSL9qulQC2VWliSRQXE46AFB
         X3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769631719; x=1770236519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOneaQwgm5r1vQWLDH+rGl4A5aPHuLzm9ueYQTD0ies=;
        b=GpzDbHTq4EgV5yxd7hKfcH3yNZEMoD0gVeZ8czz3VCdvRUeuUwN4gMzTjkhN1sWcDM
         n9HvddYXHhwoMEcRyrtgD96JVrrcgSocqyAp4vGwxBgnK8+rFrgTxp7qFXF7Cs9aN7aq
         641yq0+9e7zBBT8CpqpGESo/VFwNQ9T8J3pDXpV+zfvZxGMl0LBlCcXU80kiHM4zwd7q
         WYZ0q6fCrb1SYDk/ELyBA+4Rco0uIKqR75tq7bLYNCC1rcIvtCs/8d7zI381brJ7OE7W
         tsUsgQhUb0TVipNyKWsCjp2jMmOiipmVVshG6K2Trb72cvP4MfnVT8M3/0Lq2v/y2U6+
         LS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWcnPmuREZTVf9gBHx8u9JDZxxPwMm/OZwfBVfLwXtAy8celOuTBpJWyEKMyqq6aoQvydZTCvhHcg==@kvack.org
X-Gm-Message-State: AOJu0YxQAfKBOS9odod9TxMuBiwBS3ZhY0BwIb9E/9y1DcwUYCjvm9YV
	zjzkHiHIpxYO4OC4lm5wsbdMT/ywfYr3xcvC9m2htp+Ro9Lo2v1AYv2rjelVIjGS+g==
X-Gm-Gg: AZuq6aJYqCrfIbugZqg6R7FD3I5kbE0UJSSnKFoTU+kN+cVraaCPUJTYHp2yNJyaw2N
	6PeNE+Tm8HxQm6LFPFgwpBH/m6/gwuGU4GOric+2NzHZx0eaHt7TSqIpAzuD9iKZ33NBQgk7dlc
	W+Wy8lIG43V5w4odoFhw6dpCL4CoOxt00Fm2dIxcpY86XkswFq5Grg6lGyuX3Tc5twymyD5IrND
	G+JBT/bMVpAz+bI4F+p0qn+ykwZgYhGzOC7RgM9oiJMobYbbdoMuLoXvGcagT+xHv5g7sgCIqg5
	FZP9n0pgIloQ5/6GHvbDlT6jLHAemkAx3ZWStrSyhRmuir4M+eEx3OFXtIRmu5+cEQ3tKVwCdwb
	hzpbtf+fCfu+yyYTpfqNo/IYoI3ya9LUXm/MRDrh871/MENOG4HcOfgU62F11Tl3rfUx9xVwbbF
	3EzX2Ywndh9f/d1x7RWv+DsMw4ve79CaQHjCvox8DNTk0P6q0Ukl/7PCCT2oo1lg==
X-Received: by 2002:a17:907:7f8c:b0:b86:f558:ecc0 with SMTP id a640c23a62f3a-b8dab1c8bc7mr433016666b.29.1769631718213;
        Wed, 28 Jan 2026 12:21:58 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbef86deesm171812666b.3.2026.01.28.12.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 12:21:57 -0800 (PST)
Date: Wed, 28 Jan 2026 20:21:54 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 09/17] mm: introduce bpf_out_of_memory() BPF
 kfunc
Message-ID: <aXpv4r_3L0UWzAQn@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-10-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-10-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 60F7B1C0010
X-Stat-Signature: ocoewqft4u6moyxjh8gfidrktuokizaq
X-Rspam-User: 
X-HE-Tag: 1769631720-661439
X-HE-Meta: U2FsdGVkX19pZH+VYvDYpf6s90DEskUszcl+gFZm47HOeaVvC4HYaxQyKXvNR/gI5aGv8Rnc6BhZyOOTxg+gqhIZsB6VJX13fDdf+voql01G8VtJq9diavs7FULdUieZytXzJtt6Z1WgdFgK+LmQlJZAR4UeOf0hTtlU71E7ejsWUuI2em+UrTCqo0d7t6uHHnvZHzI7AqLp5QPn+drpnPQTq+kSeiFNpLcLegvHNnZF+QKs/OoWYHKf5Yf/QW7O2Q51NjFtIVBoRWj4dxl88O3LFTlB48ZD71bXiSaFhxfAkGmpUJbIrp4kU60vkbdhYX4a3v5+LYMMJ9MK1BCN8JYTPo4eNNip4sIbSf6YxcXn+WE+xTKo0i0/AqttytXHEqjXdhMkrOZskpnFObrTbwD5+mr4VhjXGYmit6vm1YIoFHLprZxEnXzrs81aV5ZTRSmfDa5XCKcMdpPiDclLWchKi/I2vUh50SLmtl/tQplE7YN5pMtG6tKVmeuVnfnNlDW1i0VOAYZv3Iunrr/h1QB5RhPjDHs04shdzFyBvSYds3sXwTdSeeluhlFTI5YoUFkGXAQE67VKNAO6SYZPfscOhERG/f1s8A74pLBrwA+MNLMvUirKLCI1KGUyyjZn8vi2k7Ig9EPfnJpuK/lxqlboKDbkQdaKnlZpFWzyeGd+oyYrqLLIptxKDOLgKKbD4OomF/JsdQJcOdfqKZR84tdRyeAcmVYJ0UJIo9K44StRghqhuE5OAAcNV+ByVAKv+wB3I6yZftqw9VFGe8dzSm/20dk2NUgoLFbFcHO/034T92nMNL9InzJzS6fZaMUsM54Aw5ztu2RV326lreS1wHTed36sDMlgdWT3P2RxC1pVnMQkNGW/6P16ATi20f+tv8fDxwVA8Oc+laAVUNoiaRO3UGy3c5VzPfev1niyEN04st6xnakqp3GvysHaStOYbtixb+hRoa/aBDyTMl+
 idE6/7Op
 uTGR+g+RxbVoIAzILqVYlfO5AOPFeGitIkWFhqoieP7AKxedyyETwXNQ8MoSHyFPcoKW+qDbzaOxXJHKLBm9fG6lTJHYoCKzjaAoP3MBQIikAwRlsT+tnI0Lk4s7MYc49KlIZaRa6fNQq1gREjKLsWZiNW5cPul80FXKv7h4wLLArSr2VydyVWYccVpa9WRkZdgRqdxhRGPjIDRPCXd1WoeIBVmEWO6kSm0ayvysxnx9Vf6DTTZYf4FFNiW1y2GHylVUyomvTvIsY6Jj/NCXwD2J4nJTHXCNoDdK2iu8gkM+xiiYkbSVCRb/xfpo62LhMekYAudOnwwaRdtaTPA/um+eI14onqyj05D7MH7omxXlyVlMubH43F6s20GeZaLoEsFYy930xVpIKh+EcpB3luvCGrYxUPbT2kdEN2y0+a0XztabtAbAQUd6ZttEJXSA8oanmj9WsjUOT1VgrydZ0JZyGA0UrFbNtEjNzs1APV4rNdBVFOX/iMVKx7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 06:44:12PM -0800, Roman Gushchin wrote:
> Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
> an out of memory events and trigger the corresponding kernel OOM
> handling mechanism.
> 
> It takes a trusted memcg pointer (or NULL for system-wide OOMs)
> as an argument, as well as the page order.
> 
> If the BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK flag is not set, only one OOM
> can be declared and handled in the system at once, so if the function
> is called in parallel to another OOM handling, it bails out with -EBUSY.
> This mode is suited for global OOM's: any concurrent OOMs will likely
> do the job and release some memory. In a blocking mode (which is
> suited for memcg OOMs) the execution will wait on the oom_lock mutex.
> 
> The function is declared as sleepable. It guarantees that it won't
> be called from an atomic context. It's required by the OOM handling
> code, which shouldn't be called from a non-blocking context.
> 
> Handling of a memcg OOM almost always requires taking of the
> css_set_lock spinlock. The fact that bpf_out_of_memory() is sleepable
> also guarantees that it can't be called with acquired css_set_lock,
> so the kernel can't deadlock on it.
> 
> To avoid deadlocks on the oom lock, the function is filtered out for
> bpf oom struct ops programs and all tracing programs.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  include/linux/oom.h |  5 +++
>  mm/oom_kill.c       | 85 +++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 88 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index c2dce336bcb4..851dba9287b5 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -21,6 +21,11 @@ enum oom_constraint {
>  	CONSTRAINT_MEMCG,
>  };
>  
> +enum bpf_oom_flags {
> +	BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK = 1 << 0,
> +	BPF_OOM_FLAGS_LAST = 1 << 1,
> +};
> +
>  /*
>   * Details of the page allocation that triggered the oom killer that are used to
>   * determine what should be killed.
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 09897597907f..8f63a370b8f5 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1334,6 +1334,53 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
>  	return 0;
>  }
>  
> +/**
> + * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
> + * @memcg__nullable: memcg or NULL for system-wide OOMs
> + * @order: order of page which wasn't allocated
> + * @flags: flags
> + *
> + * Declares the Out Of Memory state and invokes the OOM killer.
> + *
> + * OOM handlers are synchronized using the oom_lock mutex. If wait_on_oom_lock
> + * is true, the function will wait on it. Otherwise it bails out with -EBUSY
> + * if oom_lock is contended.
> + *
> + * Generally it's advised to pass wait_on_oom_lock=false for global OOMs
> + * and wait_on_oom_lock=true for memcg-scoped OOMs.
> + *
> + * Returns 1 if the forward progress was achieved and some memory was freed.
> + * Returns a negative value if an error occurred.
> + */
> +__bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
> +				  int order, u64 flags)
> +{
> +	struct oom_control oc = {
> +		.memcg = memcg__nullable,
> +		.gfp_mask = GFP_KERNEL,
> +		.order = order,
> +	};
> +	int ret;
> +
> +	if (flags & ~(BPF_OOM_FLAGS_LAST - 1))
> +		return -EINVAL;
> +
> +	if (oc.order < 0 || oc.order > MAX_PAGE_ORDER)
> +		return -EINVAL;
> +
> +	if (flags & BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK) {
> +		ret = mutex_lock_killable(&oom_lock);

If contended and we end up waiting here, some forward progress could
have been made in the interim. Enough such that this pending OOM event
initiated by the call into bpf_out_of_memory() may no longer even be
warranted. What do you think about adding an escape hatch here, which
could simply be in the form of a user-defined function callback?

> +		if (ret)
> +			return ret;
> +	} else if (!mutex_trylock(&oom_lock))
> +		return -EBUSY;
> +
> +	ret = out_of_memory(&oc);
> +
> +	mutex_unlock(&oom_lock);
> +	return ret;
> +}
> +
>  __bpf_kfunc_end_defs();
>  
>  BTF_KFUNCS_START(bpf_oom_kfuncs)
> @@ -1356,14 +1403,48 @@ static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
>  	.filter         = bpf_oom_kfunc_filter,
>  };
>  
> +BTF_KFUNCS_START(bpf_declare_oom_kfuncs)
> +BTF_ID_FLAGS(func, bpf_out_of_memory, KF_SLEEPABLE)
> +BTF_KFUNCS_END(bpf_declare_oom_kfuncs)
> +
> +static int bpf_declare_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
> +{
> +	if (!btf_id_set8_contains(&bpf_declare_oom_kfuncs, kfunc_id))
> +		return 0;
> +
> +	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS &&
> +	    prog->aux->attach_btf_id == bpf_oom_ops_ids[0])
> +		return -EACCES;
> +
> +	if (prog->type == BPF_PROG_TYPE_TRACING)
> +		return -EACCES;
> +
> +	return 0;
> +}
> +
> +static const struct btf_kfunc_id_set bpf_declare_oom_kfunc_set = {
> +	.owner          = THIS_MODULE,
> +	.set            = &bpf_declare_oom_kfuncs,
> +	.filter         = bpf_declare_oom_kfunc_filter,
> +};
> +
>  static int __init bpf_oom_init(void)
>  {
>  	int err;
>  
>  	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
>  					&bpf_oom_kfunc_set);
> -	if (err)
> -		pr_warn("error while registering bpf oom kfuncs: %d", err);
> +	if (err) {
> +		pr_warn("error while registering struct_ops bpf oom kfuncs: %d", err);
> +		return err;
> +	}
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
> +					&bpf_declare_oom_kfunc_set);
> +	if (err) {
> +		pr_warn("error while registering unspec bpf oom kfuncs: %d", err);
> +		return err;
> +	}
>  
>  	return err;
>  }
> -- 
> 2.52.0
> 

