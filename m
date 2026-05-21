Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFB6CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609896B0088; Thu, 21 May 2026 00:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1EF6B00AC; Thu, 21 May 2026 00:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D01A6B00AF; Thu, 21 May 2026 00:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38C9A6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:08:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 087001A04CA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:08:35 +0000 (UTC)
X-FDA: 84790095390.16.15B16B4
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2FC041C0004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:08:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=KjoN3Mnz;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=emil@etsalapatis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynBnbM/NLUcVxU1YYBO1La/PNj07zsMaWyq2DVRegqU=;
	b=ycQIxZd6CXtzOF250Ozx48LRqSKdiqJTc083vmzFvER1DcFjEP1BInjrveb/683A2gSA1X
	MzLjIJ8tQvJdpDTW+daHWNv7YZm0Zf53lEvqtI83rjODI7sGd5YExruYO+7UgJEOKMLqyy
	kpQBoX/a/5ZcM/9t31AGoQuIEdnPADo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336513; a=rsa-sha256;
	cv=none;
	b=UbGFm1G6+X9RRq4Hb4U+oeb4uZpPvacJHIaOz+fBX3L7cS98hW4OQQ4XcBbsXHfySuBOhf
	2qvjlVC64AjgnbV2kq5rt8tfkVzjUN3gCN+nxHHKQGU0zIVjZwXfuQ8aixYqIo7LbYT0Cr
	VHerjh2oqqDo/VPj9mhTc2GNKGwZy0s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=KjoN3Mnz;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=emil@etsalapatis.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-838d0b7c950so3993477b3a.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 21:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1779336512; x=1779941312; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynBnbM/NLUcVxU1YYBO1La/PNj07zsMaWyq2DVRegqU=;
        b=KjoN3Mnzs5IvlGfh1t4enoa+gQ97YsgqZTY2SosOi3gM6cQV5NHpdkU3zrRgc2/kWF
         OuMRiWQ/BWMhxMj/R1J21NSFqU7/esdJvelqWIKScYgbzBENiZPK3VkUwR5t3muJBooJ
         KGdq1kfypYTcNme0x/MuI+IxrZ0/wq3mf+TxTRCBe9hPFCjXa4pk9c8XmV69dD166pLf
         38OjWB46uWvxb5lpunRpa307yC62LOkpVUQ2dUdwBD+5OrB9mbqz1lUbVPlcvZdgnMQP
         9pAtGILWOjK4uMSKvTZ+y3EvbHPKqYztLUYcUecnHeB1MCaCkqVZMXlFGVjMjnSIUnzs
         spFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779336512; x=1779941312;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ynBnbM/NLUcVxU1YYBO1La/PNj07zsMaWyq2DVRegqU=;
        b=CuL3fTok9VebadYLdebu46HnlvNiuHoDIYa3mQrZ49byuJYtsGSF6iCz9uvwcDZlLx
         d6FvY5/myPQHR62PjcwzE6xExZm8B/waVTJnH30ZmOJn62v4czMMjpJwmD/oPsl1223Q
         +lyQZkOCVYuOQkh+oDjgC4bk/lRYdAVoAa8Kqk0XnHmxCIhVRLh2Fa7bP+NEQUNMws/e
         uXjeZ3ybHJOxCTh0fsJCE8KWeX++EKpPyyAaN4veqYaldRGxLSScjozIa0Mf1or+M+x5
         53zJBHCokrFcXOQCWl/2Kh5D0t0xuY6VocREYpExCmJSKrpQtZlbJjgV7FVHXwKq0i1p
         V5zA==
X-Forwarded-Encrypted: i=1; AFNElJ+UBYnK7c+/4u8q12IYFNngufyklOjQL67aXLn+niuH6+C9GPrG/s3J6CEYSO8QyhGW3PpMHg4Qmw==@kvack.org
X-Gm-Message-State: AOJu0Yzr4caEx22/aKW8dpLMDSGmYagMj/oPLYcmQVRT1fQOKthhdphM
	LYOSlr6Yq2oVycEqTe0dYs7uE77+i+MYJCxdeOcygrwoARPL7OEjCONcxmuZytmbxD0=
X-Gm-Gg: Acq92OGj4qPs/OQwOnIF64KVO/wZycgSDnEKPq/2CBnmh58nndjMhmTLR+3S1nOiwub
	/ucX5kG8jnbDrm6KXWpoyCuiBxCr3WEt/NDLcvBGksUbyAIFHBun8FnXrNjK9XOl3ZTY4enPVdv
	6LTFvu116+ztX3FlmJ04SqFWglUPl0+EzlktnSK6HddNCh5E7/VrqBMpRTQ5pZv2xOadTvm3tl1
	vHXx/eDqyiCXIRm6xfG0glG1VLWaNXWGefTlu72dSTV0T8y3LTkoT2sPLMx8/lQE/lrmCH8id5G
	wn7WrnYABaUODce16SRN+FuifcQqJ4rwhWrExSTYpXoAZy3x4z4IMhyn2PtEB0Mc5h4bt3qib4W
	4Ee08/cQRir4WgsS4JgWunlGFiewzMQ15JA4W28TMxNCx6oWhM1cq/PPjTrsLWgrjtOsgORimZG
	qHL6xRw2h0CBnistM84vaLwWjg
X-Received: by 2002:aa7:88c1:0:b0:82f:7b98:e499 with SMTP id d2e1a72fcca58-8414adf532amr1336929b3a.31.1779336511925;
        Wed, 20 May 2026 21:08:31 -0700 (PDT)
Received: from localhost ([2001:569:58a0:da00:a5c8:c4ce:f7c1:40c1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8413ac7b2b2sm3505781b3a.14.2026.05.20.21.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 21:08:31 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 May 2026 00:08:30 -0400
Message-Id: <DIO25GJPKAS6.1MJRN7AI18G4P@etsalapatis.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] bpf/arena: Add bpf_arena_map_kern_vm_start() and
 bpf_prog_arena()
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Tejun Heo" <tj@kernel.org>, "David Vernet" <void@manifault.com>,
 "Andrea Righi" <arighi@nvidia.com>, "Changwoo Min" <changwoo@igalia.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-6-tj@kernel.org>
In-Reply-To: <20260520235052.4180316-6-tj@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FC041C0004
X-Stat-Signature: rtjwhskj3gbbweknptfh6wy3ywmusu1c
X-Rspam-User: 
X-HE-Tag: 1779336513-531275
X-HE-Meta: U2FsdGVkX1+MImqh2tQofDtSA2WmctVxB+4lh/qfbxwG3HQrw0DeBIXwHMgK5nebGWundvUMr8IIHcLIn3UX5MOarhXTdHeZqCwvQbgl3QlE95Zj0VhNmYYktDVLG5pmqVNia1dbu/V9a7oM5ybjpWR8TPvoaFQDfqnGWHLUQxk23xC0f1I/VSPuXMmJVmwsU7WLe8tcfBZ3Z+Py3SqhaxUWz3jCry4G8aL8wUPosjYq3EG1SrsHhuzAZNFiJt4qmnQKrV+iZvuKvgkjsQbBCHeWqX+yqQXy2jt7HTW5+n6pmnc7APGvQUq4knJet6z1NNqACg0jUGzHUI5Pemml1Kaxg06twg2nHiDjd5uVMSeMuKvWgEHJJnu+3xozkC0vmvdfOmpUYG3OGSS7FeRmBZWmtKOp27I+dXhsGQa7dkRJbw2lZ/ahRTDbQ2Jzh+nO7n/iygCAaw8QZ+rz0x+mipZ4vQr33xoc+CQXXqLTw86oEvJEW4DtR1SI9vZm4kU5ygW4sefsLnJ7dHeHTRJckJ1gpfiwULs/D+WJ6S8eugQpi2VUyre6h78oTQs4gvyHYdCxvCs/C/iVTCZ7bWsyEfhg/a5D+X95va6DVGVw1FJ1c0etcooGbQXhRoZ38Xwjbe7mjznEoARRMnNGzoKPIejE//xoDQiWvjDYXz/Y7Lw2Q15cpG2j5oGe8swhw1UbcKgVIlnN7WDtQUgp0mNtoynVYe8fIw4A5k7CRpMYxmcZH6d5Qhvb4yMqcwsjBSgqkcTFnQ5zLEYQA3s3EII2pbNydKaPxiLYpzLlSb1EVnN9ON/LhY8Em00GjuZrGTpQpNPfOiepQj11UT/EkHF3LLjMH3q794H1lzfeaH3Yx0CWGIEvkqIlHwgVQX2z2LeXc9MOpJsxyrXRHYeGEWCIMW1ndyFyGYmdd7U1pOKYnB6R2TP+o1Ty7O0MQ7ftF3k17l3OclIMeZcDnpg7/fi
 3X630Y+F
 JSGJtKk1621VxtRHk+JmAy282W8/afOFVf8D3xcB0CebiHME3/bmr/GiH2fLE2BabHpa2Mw4Rp13BD8YbbIMsUL8BMxk6cEmAhODpN+dGkhk8UoRNDx3TzEWe9Bk+DwA2KTDjxJhYis1LI8pCBWRJNrs9ekut//qqQo2IGUXsXuE0xt54pE8dOy50PfDiV8BIa6tUQ7FDxg64YZgy9iLIip28DJZnA1ghUbcF65vGqHTbw6Z5kxCqsj7wegRnLehirTNWtxBJquPvHW6wKF+OQfUa40NFCfSQ6b3sw3T/k7B/kRbEyiIptQhneRKoyhUJjdW9PqkpPPtNoJxEO844802qPHLcp8KKbBJZjMDM0/vhi0sYr8qISu212YKYcVYpZkczOgx9jZlVYYif29dK0NFA93bWxInxGNvNnBk0XCg9BVMViW5B79+L92BC/X2fnvW963Lt+xM5QeFGHyWg6eDLKYlUwlFX3eNYU/TmsyIrZUi16vVNDWLIeWz8VoG/burJPoSmf1Ne5Rtbux5OvIkONgl/YyyJ16L8o5Q3oADxa5JGdqnYaZrQLcws2KRvzKDPWQ08jICJxtBdP4DJTElZiJ3OihS4l1IowXf0UwxE58kCFS1cn6WwOmoY4AUA978ReDJUUhxWyDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 20, 2026 at 7:50 PM EDT, Tejun Heo wrote:
> struct bpf_arena is opaque to callers outside arena.c. Add two helpers
> for struct_ops subsystems that need to reach into an arena:
>
>   bpf_arena_map_kern_vm_start(struct bpf_map *map)
>     returns @map's kern_vm_start. A sched_ext follow-up needs this
>     to translate kern_va <-> uaddr.
>
>   bpf_prog_arena(struct bpf_prog *prog)
>     returns the bpf_map of the arena referenced by @prog (NULL if
>     @prog references no arena). The verifier enforces at most one
>     arena per program. Used by struct_ops callers that auto-discover
>     an arena from a member prog and need to take a map reference.
>
> Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

> ---
>  include/linux/bpf.h |  2 ++
>  kernel/bpf/arena.c  | 26 ++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b99d786e98c..e1ba57c10aaa 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -618,6 +618,8 @@ void bpf_rb_root_free(const struct btf_field *field, =
void *rb_root,
>  		      struct bpf_spin_lock *spin_lock);
>  u64 bpf_arena_get_kern_vm_start(struct bpf_arena *arena);
>  u64 bpf_arena_get_user_vm_start(struct bpf_arena *arena);
> +u64 bpf_arena_map_kern_vm_start(struct bpf_map *map);
> +struct bpf_map *bpf_prog_arena(struct bpf_prog *prog);
>  int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
> =20
>  struct bpf_offload_dev;
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index a811cf6170fa..51b9ae36feb6 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -84,6 +84,32 @@ u64 bpf_arena_get_user_vm_start(struct bpf_arena *aren=
a)
>  	return arena ? arena->user_vm_start : 0;
>  }
> =20
> +/**
> + * bpf_arena_map_kern_vm_start - kern_vm_start lookup by struct bpf_map =
*
> + * @map: a BPF_MAP_TYPE_ARENA map
> + *
> + * Return @map's kern_vm_start.
> + */
> +u64 bpf_arena_map_kern_vm_start(struct bpf_map *map)
> +{
> +	return bpf_arena_get_kern_vm_start(container_of(map, struct bpf_arena, =
map));
> +}
> +
> +/**
> + * bpf_prog_arena - return the bpf_map of the arena referenced by @prog
> + * @prog: a loaded BPF program
> + *
> + * The verifier enforces at most one arena per program and stores it in
> + * prog->aux->arena. Return that arena's underlying bpf_map, or NULL if
> + * @prog does not reference an arena.
> + */
> +struct bpf_map *bpf_prog_arena(struct bpf_prog *prog)
> +{
> +	struct bpf_arena *arena =3D prog->aux->arena;
> +
> +	return arena ? &arena->map : NULL;
> +}
> +
>  static long arena_map_peek_elem(struct bpf_map *map, void *value)
>  {
>  	return -EOPNOTSUPP;


