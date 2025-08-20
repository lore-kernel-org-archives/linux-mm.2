Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAA3CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003CB8E004A; Wed, 20 Aug 2025 05:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6C06B0124; Wed, 20 Aug 2025 05:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CD78E004A; Wed, 20 Aug 2025 05:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCDB16B0123
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F74B1179D6
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:35:19 +0000 (UTC)
X-FDA: 83796627558.08.5A75C8A
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	by imf19.hostedemail.com (Postfix) with ESMTP id A9C061A0009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:35:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RWwQKJES;
	spf=pass (imf19.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755682517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNVeEm5XhdBpT7eUdLFg7DGJnmMc3Txy3EfKiydyTJk=;
	b=JgjjnX6R97R1qDwDPIID1tX5Y5p/OAUV3J1MuWtqFVzYnIvG/HMIyFasqj3Iie91n0xq+m
	SIu+fBb8Lsax0O/Zzn55IE3YlFf8sk6kKOnq/BJZvxIsdZw1DZiTLAMwduk4qkKkbW8CpH
	S6pa96todupyYx9jWSCN9chKMP9eHOU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RWwQKJES;
	spf=pass (imf19.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755682517; a=rsa-sha256;
	cv=none;
	b=b4Etb3lQj79dwXbs04uw1e0NiPkoQ5uhguVNiF1X31osglz/H9EVKCpJfsbPRp8CGIuCMy
	1jzwdU8ljyeqtEaHNhCvmAovaNYVAETX3euqgiT1+VIH0OphyrM/l1Ju3hsu2W+YB5m1hq
	l75AWfGhkW7ad/AKLblLv75Nks2DZEI=
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-61a2a5b0689so6324780a12.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755682516; x=1756287316; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wNVeEm5XhdBpT7eUdLFg7DGJnmMc3Txy3EfKiydyTJk=;
        b=RWwQKJES+i5iL+zIN6jekq7KBhQrootJJkdAlaqAZj69TQSEfG2tRe5BWi5DXnKV/A
         C2Pnhi493ZjN0QC2L0ciDtZCQG7K2pnaIMlThhHeSDUSncapqUSEX24L83e+RMQIw/H+
         K35ZJGW56OMtKM+1xXdkOYK5BXY0zY/YRnuv09z8HZQdCdi9AGEv1WvSVjnXr6c3Jahu
         cioUxN4Dd9P3aIDKbr+d6zEdQ7zAfQeTP3L6VKbvl4QjTK+12Gybu1uJiW3Q4Oll30FS
         NFiM6KpYIwOGD43IkODAsAKpuaNO95CWA67CpZ3k+8VOcJdOaOpPSt9AHrneNuEJJvMX
         XfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755682516; x=1756287316;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wNVeEm5XhdBpT7eUdLFg7DGJnmMc3Txy3EfKiydyTJk=;
        b=sci4187gRtiTIrfGp86jZ/4EcscXHuZZxCeOx1PU8EMjca6ZCH3EiREKyLM9bwIjSA
         bDExl2os7KU9llycdHmki3LnbeY682as6i5fjtRKzn69ZhgSUfsZWN3IKalxMsi3CN7u
         Yqx/AxNVbOZyZL5P/t071+2qAlH8MBdD/VTwSSmErMmRl/XtOzD0U1f4QgUbq6rZoV45
         RhIJTx3i/bodSyc+Lkrykk254ibDX6Sz2h+p0lY+drlKNvqrWOlNjTEHoRDCBoVgYJLQ
         iYO00LURKXJytdgx7T6EyTRLUTJyCl8pqEhn8pkWap8ko00Ez88uUkIif+eL0ednQdIO
         45gg==
X-Gm-Message-State: AOJu0Yy/13MKsbR3sJ6vTNoB9KXS9bxVb3LpluFPNNFq7xkFZ6EKQhYZ
	R6JokpIVcyDh5YcC8SUY4Dp/ByyHL7McVyZMkdiBrDUJuJ7dunfxltT81ZiV6s7wyNbbQXe8KTi
	RAX0xlvXpLLD8DYz8vU1V30HeDkVGkzw=
X-Gm-Gg: ASbGncvevFAT/zzGwHHdZoNYMvOfq40APSih2O8zHQH0XNlFH9JFGkGQZSQKkxm4+fI
	BJDIi3r6SxIHuy3tKYNlH9zeU5xXyv+T8RyJBL5uqgMJBc0LuPgJKdWoeLFBLr4gGR48aJ7sM9/
	9C6CGq5golM9WEgujrPoINykiNN5uP7f2qjR7rkEDDTaIir4FbKku2D3FU4RvkMMwSJ8a0TEx4y
	pZUlXmd2LhVI0VfOz7n
X-Google-Smtp-Source: AGHT+IHBth0y2AoBjyW+FSstnXpJk7GFg8YiBsBpirEqa2CurHSrua29TJ4cbd0mGJpW+ZWyp820YdytDUDw2fC5XFs=
X-Received: by 2002:a05:6402:524c:b0:615:274e:6509 with SMTP id
 4fb4d7f45d1cf-61a9754e59emr1633953a12.9.1755682516017; Wed, 20 Aug 2025
 02:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-7-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-7-roman.gushchin@linux.dev>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Wed, 20 Aug 2025 11:34:39 +0200
X-Gm-Features: Ac12FXxn2NcyTwhNtOzVYKNCNtBqfk-dMrPX2NDgw7posh_y0GfGmoA2HZDRcuA
Message-ID: <CAP01T777JF7wvHDaQ-Bz-Vp_dFM=NXvpAK0RY7kLjs2amEd85Q@mail.gmail.com>
Subject: Re: [PATCH v1 06/14] mm: introduce bpf_out_of_memory() bpf kfunc
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sxgndiitsm9brb8ypp5p94ndncjihgru
X-Rspam-User: 
X-Rspamd-Queue-Id: A9C061A0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755682517-931878
X-HE-Meta: U2FsdGVkX19AfE6SQp1zFxpDrAgf8eDhwyTD7rDW7bIk/9/dfgHrjqGVz+sHjnyeDG4JGbet+JDWJWZLR4i1ryDfgd94meWEO7/IoWvZpAva1gUR7GGBNeQ1oTV5VcdhGw7mfQpRgbSiJVUZt+MQNJjc2dzJQwKW7VSXlZ+QJIXSQE4EJsCc52LpHLPBteKwWiu8gyrWiMquhPJFH1NS3KaUhWj7HFIilhtaO8gkgBb8XUSRuHkMnh370QL1BbxTGouQMW6tY7Sq/NFtKnNyImfv2rV16XEId40IbOgDQ3C2IWdcGnS3+um9fUIGXn9Mi8nYj+Z9rF18Ww8ko3J3E4JwZOQY1j/ottO2tj78imUqYeV4WtBd51UuJsv+P40TZ6qJkNjirFuI66oerFTSttAFx4JTOZDZxBsBb0MLMqSlo9dvstCKde5AXreWtDlZ48cdhqVOQOdVhHm6LvFaConA2+p3bvIY6vOh0jNMKnx3FgfM9zA13UaC56T236O6GgbWUP8adKDFQTQNvwBylbKo8tCA4ReVgBIIpnqLnecpFpfz0M4giXP7T+eYA7KzwD8aJpwp2eBUh4mlmOSXOFt29gBTFGek8o/X5s5Ymm9ySojyR4vlNZDtkgdlDayba4MqZY0bzulUIwq+dzXhC5FABqXPP0AS5DmbrNRbQXrxv9+eao0aSe79qzPzIT9hBIDrugYp0eZYYk44puodFLNiAMhvWHRvfGs4hHr28z7UvrcbDKKMcnz0nlH4ck3U55tdhgjrWkzWte0py+74sbMXffFnqu2+hxrQ/Els65FWnWmaWz0cV3tdMU77BXAHgpglRbROSZjGDvNMz3Zz7BJYJQngY3MrBnnA0DYCsf8o3pyrvWYOQUKBoesuC3kdFG21iEcxeJ4CMOeb5N3JqwKVB68dwve7I80JJ1TCsH0oBypXVfbzSJCjeB6w2ITPvBfk5/AXCbQxtc2GGAo
 Rynhyx4M
 2hAzm+dBSYJWJZsixNnDIIyuo8NALVN33GNRcJFOSYYwPp/oJjtB8v8n8Onp2o2c8nUce1XzrI/yjevbeowGEFUPXt/PfmJ+bb2yc/X2Jyo67NhYRUVQK/lIYumw5z98LQj5jcm0A2SacmIPbRn1DLV7nxp/He5gdwMSFvqBqP1Y6AYn8y4tfozXi+gR1pfBkA+wXQlJawk2XWaIhjL48ORXTlY2BJi+oJUkeoZf6JHzUpfm7nb4X82j/Lc/DhravGNVvQEOi8zmRJxl2wU0fBOx0NKNT13eOyVUhu43tLA8Rdr1Yv+fyXFwVwvXuZ4zmq3RhKrgm7OVsqc1gA09z3gtiO5kY3KKrXBpJpHcK/y9jNwBZHx9rpjvLUD+lZEflHML+4esZ+ZVKioo9CRF1UN1X2DuYwyZ+ntAPX/mIyYqKYgXnJjO0Q5TmfCP0I9tpVNH+uwD9GjuMTNlUy1ssOYNCBRfCLSBpsySzorU4Gc4hZfWNULvcV6GbkW6ny3o0zAasLbgGhQN2E3c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
> an out of memory events and trigger the corresponding kernel OOM
> handling mechanism.
>
> It takes a trusted memcg pointer (or NULL for system-wide OOMs)
> as an argument, as well as the page order.
>
> If the wait_on_oom_lock argument is not set, only one OOM can be
> declared and handled in the system at once, so if the function is
> called in parallel to another OOM handling, it bails out with -EBUSY.
> This mode is suited for global OOM's: any concurrent OOMs will likely
> do the job and release some memory. In a blocking mode (which is
> suited for memcg OOMs) the execution will wait on the oom_lock mutex.
>
> The function is declared as sleepable. It guarantees that it won't
> be called from an atomic context. It's required by the OOM handling
> code, which is not guaranteed to work in a non-blocking context.
>
> Handling of a memcg OOM almost always requires taking of the
> css_set_lock spinlock. The fact that bpf_out_of_memory() is sleepable
> also guarantees that it can't be called with acquired css_set_lock,
> so the kernel can't deadlock on it.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/oom_kill.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25fc5e744e27..df409f0fac45 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1324,10 +1324,55 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
>         return 0;
>  }
>
> +/**
> + * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
> + * @memcg__nullable: memcg or NULL for system-wide OOMs
> + * @order: order of page which wasn't allocated
> + * @wait_on_oom_lock: if true, block on oom_lock
> + * @constraint_text__nullable: custom constraint description for the OOM report
> + *
> + * Declares the Out Of Memory state and invokes the OOM killer.
> + *
> + * OOM handlers are synchronized using the oom_lock mutex. If wait_on_oom_lock
> + * is true, the function will wait on it. Otherwise it bails out with -EBUSY
> + * if oom_lock is contended.
> + *
> + * Generally it's advised to pass wait_on_oom_lock=true for global OOMs
> + * and wait_on_oom_lock=false for memcg-scoped OOMs.
> + *
> + * Returns 1 if the forward progress was achieved and some memory was freed.
> + * Returns a negative value if an error has been occurred.
> + */
> +__bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
> +                                 int order, bool wait_on_oom_lock)

I think this bool should be a u64 flags instead, just to make it
easier to extend behavior in the future.

> +{
> +       struct oom_control oc = {
> +               .memcg = memcg__nullable,
> +               .order = order,
> +       };
> +       int ret;
> +
> +       if (oc.order < 0 || oc.order > MAX_PAGE_ORDER)
> +               return -EINVAL;
> +
> +       if (wait_on_oom_lock) {
> +               ret = mutex_lock_killable(&oom_lock);
> +               if (ret)
> +                       return ret;
> +       } else if (!mutex_trylock(&oom_lock))
> +               return -EBUSY;
> +
> +       ret = out_of_memory(&oc);
> +
> +       mutex_unlock(&oom_lock);
> +       return ret;
> +}
> +
>  __bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(bpf_oom_kfuncs)
>  BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE | KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_out_of_memory, KF_SLEEPABLE | KF_TRUSTED_ARGS)
>  BTF_KFUNCS_END(bpf_oom_kfuncs)
>
>  static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
> --
> 2.50.1
>

