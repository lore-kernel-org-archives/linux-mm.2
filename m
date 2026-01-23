Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF569D778AB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5A76B052D; Fri, 23 Jan 2026 13:15:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ADE56B052E; Fri, 23 Jan 2026 13:15:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1D56B052F; Fri, 23 Jan 2026 13:15:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCA4D6B052D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:15:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81E09D3525
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:15:51 +0000 (UTC)
X-FDA: 84364032102.04.696A174
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7166180009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:15:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MpC3AVM7;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769192149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2nG00qw2ruBawht6GJzw6X6qOS/2LLsPM2l8lgx1yM=;
	b=49YgdW+8hNgTM6gBdUgjvyY8mkhqBeX9xVIhz06KMV8Wtv2LjdcwQBf4FCcpQIjqo6r0I6
	DC7LwekDIb7VAjQ8v4Y7AZjvD31BK7CsES/gQ5dqMP7ax2aqYrzaLT/xuu9ama6xscbuOr
	IhKz7sX66xOAjTf5a9OLxWdTJMMMMYg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769192149; a=rsa-sha256;
	cv=pass;
	b=gAJdBaqw6Sbactj29EP5jezqMICb37QHoeNWHU5kq/zFf4Au5PCLqH4mM35rdZPu1HyZDc
	Y7n65mHjyysg78pYgTYXkKuFS/1WS6pzn09XJLmia0gAtCAAiQB53amHxYaTEpQ09/540u
	oSG3OYkM0+i7wN79ctHkErCa4GjG22w=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MpC3AVM7;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4327790c4e9so1618599f8f.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:15:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769192148; cv=none;
        d=google.com; s=arc-20240605;
        b=FQEbJkAs5DybYLaEoPK5IVaZDOeRzhzKGLxWzxQjXB0a6pXCkpeX0CUz8SoJNaAAxB
         2fKkcPZorWkmP4v8pIbtXCfr04WS0Uzv6P78Aat9Zv4q9/r4tbnrJOL9mptGvRoXu0R3
         KHsPRdXF8RLNa0bTLiWsDjUW/w/FyaKSVSDuZxrqG2jdERWWmPW4KKwd+gV2FWYDrfoI
         poxkfI7or8WYR5D3aReV0zQHb0aTKOAuSCDc24KSgh+Dyx3gvO+zJP7VqaYRevloS6IC
         R0KowIb47ImHGWjY5r0snxHVJ5d6BjsUeCS8J1AZ4F9SIFQl/vzyoEyG0/9ymtxRoUQz
         U5mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I2nG00qw2ruBawht6GJzw6X6qOS/2LLsPM2l8lgx1yM=;
        fh=jgibI6IzrYBMB8q9uaRjUaeKWBd1xHEXoqCcOUKc2ss=;
        b=IeF177BXTBgxy2WPMcQ5aejyklZ2P2X4lPmseDnP0Swccegn6FwsOGVIIRQVp0d2sB
         mYYiTSVvFkMe+MoGfHfGlGqrH2NJCCphXd4WAEOKxWuWNFC9jfyNv0cQ0jbzp65FE/7m
         jpzxgOXiLOD4Z5kstT57MepmLc4Xfd+hX9DSfgT168n2MxNMno31FVE93CqTz9cbFKwM
         J2U317HHlD2SWlepOpmE5EsIkeTGijf+YQfIzzS+zpmafeEt9wEONrPpqVSvwLJIWyzw
         GGk6jFKzWEJr4jKbSjIIRZOIziiEXIQqyh+eQfvOEVCuOuOMljXeWoFWmYj8S9qBgh7S
         Aq5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769192148; x=1769796948; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2nG00qw2ruBawht6GJzw6X6qOS/2LLsPM2l8lgx1yM=;
        b=MpC3AVM7jL8LyMj/pNMhlUII+lpL2ISxAcH6k/omxVTVnkA22kfhkQ7/4v/wMd76ic
         jTXvVo5cyVSa5UDXHwXXl4OjSvHAZGtrIycfhCkvOIL6pzM3yx6dm2zGdddhlBlAlZaX
         oLxdQ1nD14/qV0tm1OIfMDCBTuKPwgudJ0DkqW6OitJYpybW4iEzHKc9iENXltdkgQUx
         1bJJO7UxlhKCrTA44v+xnoDBRnAMNFJwgov1xKTcyufUWisNxo/pglLWEWDL9cMQ4bRw
         v4ZuCNKVTlOMJ0dEBsiuoANCeVt/Y/BjhzpRDCRRCW1XaafyQAypn0GUB8xdgyfecdDX
         awXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192148; x=1769796948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I2nG00qw2ruBawht6GJzw6X6qOS/2LLsPM2l8lgx1yM=;
        b=mIAX2iDYoPfkAYRf5oB/60RqDP3eSeIhOc1rtRNVj+kTpe0Aci59nPVeiWRqgd4z6i
         1g6y8dtCddwVqIltofmDyj536ewG+PIEJzwxI6+ct8eu6hZrQU/sToy4pyK2TL6D8J0O
         0r3XHYKoPJ0ol8hVUBu0vRMjEY1Yu2gC1VspbsVwtddYN6YgorLznImoCU3yku9y0JTQ
         7CNgYytEyHa2Uw1i1+SLI6gisRROu8uwYYbsYIuThzjshCrundXylmfMZWd26VIRh0Sl
         Zl89tFXETubnZtRMYgjTQC8hPX9gzQgGLNPbcvOx1ynMKxul6D/W21RjP/qGtrRiz69J
         pXDg==
X-Forwarded-Encrypted: i=1; AJvYcCUi7o9LmB1b/QPAEkX5d7hLyUifeg4Sj6Vdp3u96oTloKE9VXsHdhHZS1DnsN1YZSR/T3NHdg9FTg==@kvack.org
X-Gm-Message-State: AOJu0YwS6aYMdvmtDnH21zbjT6CouEL6k/Keb0MsimwvNUK5m5O3lbeY
	6brwmFCIrqQGc7HHXH4VsHWJJ6Ku8qDY1kx2hZLL8OsDS4Er6OMtxSHkexG60m8PuRuO0ljYjlz
	OiqreoYiXUNVQZStABb+qtKm3QUiDFxQ=
X-Gm-Gg: AZuq6aK/phVbwLpyRpdkQPga1ZUL6IhN0LYVgH8eiY5exmANmCuQ0Vouoj3N0WPMgUf
	6mei64stXhM/qe68oh3p5PnmoNw/rPjW9IkdM0TRm3eyfVJR3fjsD9JqfyT8qYlpx64a4VBdrrJ
	sHdVtevAUCGhAlTJ3emT+PHpWp0UgU/Wacz+cLhVuOJRWU0JEHiZJN3XgJvOSCixvfYYLfCYBrw
	PRwJCRBTiF04JjdGwKqxf3entFTI5X1MntUhu6p+s0PL8VROCADJbtBWVYhfaIM3L3cVOU6PEq5
	3NzlsAPbxpT/1QL5uR4TJoqoROMDU9u4oJCliKwb2FNTYQMhruDKx6GCes6k+RKrofJ7IPme
X-Received: by 2002:a05:6000:607:b0:435:8f88:7226 with SMTP id
 ffacd0b85a97d-435b15fb134mr7443178f8f.40.1769192147696; Fri, 23 Jan 2026
 10:15:47 -0800 (PST)
MIME-Version: 1.0
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz> <20260123-sheaves-for-all-v4-13-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-13-041323d506f7@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 23 Jan 2026 10:15:35 -0800
X-Gm-Features: AZwV_QjgW82i1crlpndwrb8M8pt69fP2CoWaYroMilL8QIj30Jgt-nfZQ9Vffac
Message-ID: <CAADnVQLEupQB3O1RzFAPoVvg-frojmjFQhisAUcxTJOmkz02nw@mail.gmail.com>
Subject: Re: [PATCH v4 13/22] slab: remove the do_slab_free() fastpath
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>, bpf <bpf@vger.kernel.org>, 
	kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A7166180009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qu1cwb7mz67qmgzu8gyg3pyug66spj7g
X-HE-Tag: 1769192149-900549
X-HE-Meta: U2FsdGVkX1+Tw4rzfJqLE0FIQCsE6Nk7cBaXvBeWVWqRuV85yqsD5Xp5AGjnikUiUrW2xE6ah5N0+gD9ai+AbmSkUMFXhqtKrhAok64ABtr2acYlOkQ8v5jWNe/lY7bFeKgZ9pFkZGzJAh9GIf+IlcDqWqwPf3CaR7CN2F+fR39vGUBMl+hPAf9COPyYAREY/WC6QkPuZO3pxoUOGvf9WmE8hOn+zps4OAEtZXfPhRX9OZ196z4dhzm7Or59xSzPojQADLo8YL5vRQSnbYrAN424jsBJ/jqzBa0WjD/DzaEhJND14yFihgzpWpzzQBdKERrlrx029Jw5hBkNYCjuWX+eJLT4oEq6JGSoDFEDMACWHeUzTJdC2u/LmCLYNWLomCkfO9FAzqK42SIPEYieA6CAQVgju3WDpKs1s0/p255ZPQ3vr6dg+x2O1V89TV9lXCCxus2q2oFV4Nydj/xU2hyzixusf/MGBrQTnUURDagZZf5oVcfqTMTVkEN/OmPp6EhHc7kf4+ETc9gm83Mk0BqqaxKioVZ2TZgV96/3IHZgs+RDVfBCXuLTMN1hf+oaNELSGPs9Nc1079aiVYGPMwprXmHDhsd349Z1B9pN4BVVOC9aOJR6pVhEhlRRY5QsV0usqj4HqGFjuAUH0gDjxCxQ7jmP5Cj/7O5CjqnVcHB+QFAQDZ5jtCnKgyBFGahACYGM5i0f5dTyGzaTnUEfiu1p5ZigcouHYtE4B1MEH69ytFeQveQIHowdRJNtcpWQXJe+zNMlpkWyIOd39c0ik72ZBml2LKlZ55JOpK645ELqtOBcaMAHcinGUPjEW1X21JRVTSgI3Y1o/4jJOcfufKYfzNN00Z4hIJTsYqNwgcM1P3mu00wmiyK0QKykgm2WdfWLeVT+vQCkzJByUBc2idexCcMoEsS4wOYtTJj0vjcKeVvA8gXaxzSIgWdeOp4vc+pRuo8CES0CTeBgPj8
 6IntBZh7
 e+BLGak11/lHqP7tX3p9xZfwWagJxxMIRA48DRZmkbPpLtnfyR+rd6U4MKanR/7p+XTOaKPveM1qu8ncrHb9661Nw3f8ElwIEZWxR8gho42wDLGYBAcOftKtRllavSW5rXkzQuy/mdRNUdig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:53=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> We have removed cpu slab usage from allocation paths. Now remove
> do_slab_free() which was freeing objects to the cpu slab when
> the object belonged to it. Instead call __slab_free() directly,
> which was previously the fallback.
>
> This simplifies kfree_nolock() - when freeing to percpu sheaf
> fails, we can call defer_free() directly.
>
> Also remove functions that became unused.
>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

...

> @@ -6557,7 +6429,12 @@ void kfree_nolock(const void *object)
>                         return;
>         }
>
> -       do_slab_free(s, slab, x, x, 0, _RET_IP_);
> +       /*
> +        * __slab_free() can locklessly cmpxchg16 into a slab, but then i=
t might
> +        * need to take spin_lock for further processing.
> +        * Avoid the complexity and simply add to a deferred list.
> +        */
> +       defer_free(s, x);

We'll re-benchmark this when it lands.
The current defer_free() path due to slab !=3D c->slab is causing
spikes in some of the workloads.
I think with sheaves
slab_nid(slab) =3D=3D numa_mem_id() -> free_to_pcs()
path should be exercised a lot more often and fall back to defer_free()
should be rare.
Just leaving a mental note.

Acked-by: Alexei Starovoitov <ast@kernel.org>

