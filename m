Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB4DCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8C56B008A; Wed, 20 May 2026 23:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB13F6B008C; Wed, 20 May 2026 23:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7F06B0092; Wed, 20 May 2026 23:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3586B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:17:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 576C4A04E1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:17:24 +0000 (UTC)
X-FDA: 84789966408.30.616B3E0
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 741AA40002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:17:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b="XLl/ENub";
	spf=pass (imf11.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779333442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnZgEvyl5JzulXJ71OevVX7wYBcNSF1YrTlDeDtAzPQ=;
	b=KjVqVVFd/6rG8QrSQvly0An0HgZLt/YRKbVGuT4sGCFfS9j64GIZhuH8WoTi8Dubx0YaqJ
	6xjs85U6dfHlRMJzIQ3wjmEIItcYMozti7KFUtGd00t2orwqDaNmovKmFqiz8X/+bz/uRf
	1qsyFGhYvut1kRv1LqT8pO1+6tlWTxA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b="XLl/ENub";
	spf=pass (imf11.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779333442; a=rsa-sha256;
	cv=none;
	b=b/U+96gVK+ntCKeA7BC77vmAefi/a0lA4jQyrV3dEpwGbPOJMpefi1sPmmvgPOF29VFyFf
	BoNarCVW+qPHcgkowE7Js8dhgsjVe5fuB/7cOFfR/XNF8dHEY7SMnqAUh/S7hWkxaCrYxN
	fYBjg5YBoGb4OvPriGM8tv5oTEMedxs=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3697f25d26eso2849810a91.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 20:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1779333441; x=1779938241; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnZgEvyl5JzulXJ71OevVX7wYBcNSF1YrTlDeDtAzPQ=;
        b=XLl/ENubusEqVGUyPhot8qeIn0hY9noB6UeUP3gh4DTjOOcbZWgfINbLEvYB+M2dFy
         Wg+WzVT6Pu18TCTkp5AUEDwKdjNMzwLbxGmzOBT32y8rg0mcYT4JFeUEeRsCDYTJ54+T
         V30Wi2LB+yvb44GuaR5sqtZB9RDETfJbapuLgFfNLFVLlr0yDrbDDJPC1w/rV+bqH/7S
         vtrj1qVSZzOPJP5vMU8Ew/6MkvM61QnKFPkc9F3bQNazATI6l0L+I9ntoY9NL3uANX+Z
         G3AFYa2A9TGrIqkQSB+N039t+CVtEQ/X2s8jfgdsFNxZyFHXQgSAqjpyO/wRBQ3mmNo1
         m4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779333441; x=1779938241;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WnZgEvyl5JzulXJ71OevVX7wYBcNSF1YrTlDeDtAzPQ=;
        b=UaCM4g9P0YXOQkKto3arL4HI4gi7qiaWf+aA3I78Lr5hqZOO0Joi6WLIHpWlDuFPSW
         AfN/6PvwiYbSwsCDw7F6XXryTFX0jcWD5U+WwQypxHi9f5rGTXTlH3UHSx99AWgebVWW
         uZwngQt7cV3uG+0P2rwnShcg8wHyZGqzPfeGeBklAk1hNyy0GX1MUCAbCBo9hXmcYaNP
         0Xf6YosiWBucoa8W693VISiW8tRndRRAMqoiyJlAZohGiNYZdF+vxWy9Mni5lflDMiwz
         ciAbQKfL7h0glfQdjlpnu00luzlq9nA7sA7JvzNU7GsX+MZObiOghKO+8QgmE+c7EZyN
         BGug==
X-Forwarded-Encrypted: i=1; AFNElJ8EgzHFjG0o125ovJbLHJfylHnYt2japeKwnfNghqPF2DG/vGLJQPohw1S0kpgoniAVoQ9CeB+Rvw==@kvack.org
X-Gm-Message-State: AOJu0YxOF4EudPr+bwUduIv87G28RJ+nygcASFF4TXN8CFWOhXQ2XApH
	FtidUSEP434cWD/VRhfLUPRJQFurRhZWWHHqpHnh9rdaZr9LTy7ZqpoTmQQ5Pp/Bygw=
X-Gm-Gg: Acq92OFGWQVIPRi3ISgq/P9uXa1NVegy+xe5046ReOX/gv/9kH04w785RRPtYYkEwQ2
	LZqXxbaFq5GRIPcIpuGeP5cy1uyKqWKnf7HVnvpYlWLQOiBjTnuKsnrqHAe9U+o6zAULmWWwPz6
	AR1iw+gVx5BHuU9D+jHIWr2AfXxyk+XndVZUDQxMSST21sp5u7NXTK6cdRluqrzpovMoW6LkJav
	MxrKzsj4dl2Veusp1Fa62yk7QnUc4XMDLojFbksaD7ENYbK/6DmxJhyVxiv6C+gMXV/JMmLBRgy
	WFjNV78g5UlMwXJTH+N0nLV5dLFGH21Hg28VTqy11soqAbg/WR3tnNKvR4ioeayN9PhDmV8oU6T
	rj2kJeRurR30AHJMGFpHGR6fDtwYEJQUROxm5DAsKOvJgXG8kxsmEWiHBlm8n/f5/SZ7m9Wog+H
	9VsxaQ0jL3gprdPXR6B85BIUm4
X-Received: by 2002:a17:90b:1fc3:b0:366:16d1:6a26 with SMTP id 98e67ed59e1d1-36a45139004mr1096386a91.5.1779333441193;
        Wed, 20 May 2026 20:17:21 -0700 (PDT)
Received: from localhost ([2001:569:58a0:da00:a5c8:c4ce:f7c1:40c1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a4560779csm222458a91.1.2026.05.20.20.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 20:17:20 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 May 2026 23:17:20 -0400
Message-Id: <DIO129TJQ1F9.20NON5EPGLHRO@etsalapatis.com>
To: "Tejun Heo" <tj@kernel.org>, "David Vernet" <void@manifault.com>,
 "Andrea Righi" <arighi@nvidia.com>, "Changwoo Min" <changwoo@igalia.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] bpf: Add sleepable variant of bpf_arena_alloc_pages
 for kernel callers
From: "Emil Tsalapatis" <emil@etsalapatis.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-4-tj@kernel.org>
In-Reply-To: <20260520235052.4180316-4-tj@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 741AA40002
X-Rspam-User: 
X-Stat-Signature: uhfcc5f1zzn8ios69ojs6k9he79qjf9k
X-HE-Tag: 1779333442-599611
X-HE-Meta: U2FsdGVkX18kgkpJb1soT4ZBJfdY3FI1cD6X1f7AQWIRjucb4uNNmGe+/owlnunSVRmB8yLcjqBvPrgBWJkRKDXtDIjuyatJthgT7E0aVADOT4z12ZuPJ63lsHtxHXOjcO1BOH3L80UIr1HgMSnBMjqp06h8i3i2klWuIwo+yAVtZo6KTomDnbfcUZPDT/PEV4X9wQSjttUp/Je53nwbjlhTAyLvBIy4E3ksrMC/S4Na2qCTl6alG1BLwzfykTIfrIyZh1Cfk4gDWRllAKeHjCvzOpy4q5RFwLbqSFWTulpMIKIK6lZSpI9i219e3rLOpFFgnkeb7qHGjNBgMgnEbSSJ1kYxmxp2KXNh/7j2Gps1tvB1FS0XwLl2U6HH58BwAt5k6u0rWx9rGmnBZS+k+1AVqndnujprwLyWKKme1GyGiRWqBGgOrMn9DwHeDRO+wCOFAsObNUNMPw/C90nYoFwBm3AhhtW1sSCWEk9gkLDygCLxwn6U/z2/M+k/zXFli4SLmHWPGEuY5YydpdfuJ6NXdWM7pvC1WAnWtY7wPqoo9Thv7pfXdF7T5s+NyG1ju1u0T/QP4jwZKZsAfNGQ18oRFKl9hOwnTGF7QucCTQBZ4Hq7iDKlCscaapKcuIRR6nK4RFiIpl3dJO/MxEetuE7ba2/0dDSpj9cZnFeagWUuOVMtkFUvJrpkFiNpQ02fuo24rb8Z5jpIxIZB56JwRVH5RXDp9uOFZGaUhK+uiRdISKHed12U2OQPQkGUvRo3eNBRe75kHozuanU3M9XIX1Fpy8qKCgDAt2OvzTVLHxsw2WJSCYloBt/VtlD5vy1/Xm6oWZTM3CloIZ/KQ4KtEYyE3hEcH/v5icCgHkbsks3OPD87vAKkvux0rFAxyALQqNGybZLTmAcm8TBXYx9h7hupTbTvY9WmNT8loD0bSuxXWDHAnWxNlD80aFJtUeFtIzpdaB/OV2+4BkCTPyP
 uyLf6ieO
 ragGu0zIHhAa6TI9yqKfCyThsAwm3GiMtNfr6VMQngF+JUhRElsUHAtFI+YatkoiucgJLCbSiW6AmnA9RW8YZ6fhFrHN+Gz/S28zL+vLTqwXdXCivmD6AqOiYyCTkVqWu8iUsV+JNY4dbVmEQyIBxRKq35xssBLcip7g+CZnog8ymrn2SIgif1y0juX8GbvXr+/111p/Uc6uw76xsD29bGvQ4oROcmY+th7zgf5ImJkzmV2fVQ8q3AJ6v+PowHKHk7mivEnfjSk1ZeaJJTJNCquoPO2g6SpSim0tCq92JLI076yp8N5CR2DqhUcVGWFeLgfPSGWLEjhHrVSbz775RfXe215R2/cm9sqY5Je4MJEOq6dOw1OVEtMX2u97TmfZM7+e7U2P7kn9eOV02byaq5AtStiRMKr7DA+1D3SEb66kAp80bqVT3772Lu6eHh4bk6nBlfHCqosM3AcBAcAb/MXG3A1uS4cMoFVSOJnufE4uCWReQVMRE0PU1vXS9qqWsUzpduAwmEXhbgYyHSM7emAv7ZIAF00AGWij7JtmjyyUTTnEI/Dlg0iPotQF0RMGhrAwmsQMsRuBvxo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 20, 2026 at 7:50 PM EDT, Tejun Heo wrote:
> The existing kernel-side export of bpf_arena_alloc_pages is _non_sleepabl=
e
> only - it's used by the verifier to inline the kfunc when the call site i=
s
> non-sleepable. There is no sleepable equivalent for kernel callers; the
> kfunc bpf_arena_alloc_pages itself is BPF-only.
>
> sched_ext needs sleepable kernel-side allocs for its arena pool init/grow
> paths. Add bpf_arena_alloc_pages_sleepable() mirroring the _non_sleepable
> wrapper but passing sleepable=3Dtrue to arena_alloc_pages().
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

> ---
>  include/linux/bpf.h |  8 ++++++++
>  kernel/bpf/arena.c  | 13 +++++++++++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 831996c411cf..64968ca6db51 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -679,6 +679,8 @@ int bpf_dynptr_from_file_sleepable(struct file *file,=
 u32 flags,
>  void *bpf_arena_alloc_pages_non_sleepable(void *p__map, void *addr__ign,=
 u32 page_cnt, int node_id,
>  					  u64 flags);
>  void bpf_arena_free_pages_non_sleepable(void *p__map, void *ptr__ign, u3=
2 page_cnt);
> +void *bpf_arena_alloc_pages_sleepable(void *p__map, void *addr__ign, u32=
 page_cnt, int node_id,
> +				      u64 flags);
>  #else
>  static inline void *bpf_arena_alloc_pages_non_sleepable(void *p__map, vo=
id *addr__ign, u32 page_cnt,
>  							int node_id, u64 flags)
> @@ -689,6 +691,12 @@ static inline void *bpf_arena_alloc_pages_non_sleepa=
ble(void *p__map, void *addr
>  static inline void bpf_arena_free_pages_non_sleepable(void *p__map, void=
 *ptr__ign, u32 page_cnt)
>  {
>  }
> +
> +static inline void *bpf_arena_alloc_pages_sleepable(void *p__map, void *=
addr__ign, u32 page_cnt,
> +						    int node_id, u64 flags)
> +{
> +	return NULL;
> +}
>  #endif
> =20
>  extern const struct bpf_map_ops bpf_map_offload_ops;
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 1c0b87ecc817..a811cf6170fa 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -934,6 +934,19 @@ void *bpf_arena_alloc_pages_non_sleepable(void *p__m=
ap, void *addr__ign, u32 pag
> =20
>  	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node=
_id, false);
>  }
> +
> +void *bpf_arena_alloc_pages_sleepable(void *p__map, void *addr__ign, u32=
 page_cnt,
> +				      int node_id, u64 flags)
> +{
> +	struct bpf_map *map =3D p__map;
> +	struct bpf_arena *arena =3D container_of(map, struct bpf_arena, map);
> +
> +	if (map->map_type !=3D BPF_MAP_TYPE_ARENA || flags || !page_cnt)
> +		return NULL;
> +
> +	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node=
_id, true);
> +}
> +
>  __bpf_kfunc void bpf_arena_free_pages(void *p__map, void *ptr__ign, u32 =
page_cnt)
>  {
>  	struct bpf_map *map =3D p__map;


