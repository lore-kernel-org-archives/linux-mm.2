Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2E9EE57D6
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 07:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DDD36B0088; Wed, 31 Dec 2025 02:42:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861736B0089; Wed, 31 Dec 2025 02:42:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7394B6B008A; Wed, 31 Dec 2025 02:42:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 619036B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:42:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B24121405A1
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:42:06 +0000 (UTC)
X-FDA: 84278972652.15.66EBADB
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id DEA3980008
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:42:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HjwTxlhK;
	spf=pass (imf30.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767166925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBxwhR+DOUWySSn1nkmmHXTpgGimoEMqTlfeKUVI3Ic=;
	b=q7ujnD0GEQYe4SVrOMF99qW4hdikkWaAN//5jkp1jw0Kd8NbkeH4Qc9P8terOhLMkjH+nk
	oiAlD/ZfgxYDDdEPcpek/BcX2zfd3w+D+E1RrjD0sbJa6mvhK5cpJieNTgFFOvkokwgFBc
	9ow7yWsSsAz245rrM0SB7vDZ0Z8TWCA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HjwTxlhK;
	spf=pass (imf30.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767166925; a=rsa-sha256;
	cv=none;
	b=yEAdEh4dW4XI3YkzDZIMMdqxMcZE/uGf//sUNzT88RNDrr9o013hsPn1J7e/px7XR3zlqz
	Mq+bf6s4jaqg/TfgUQiwkDvcn268h604P0sUBirju9JfQXWmlpJC5ke50UYT+Sm0FBQN6Q
	hhiez6/PV1O/PVxJCg/B1RCwJ6TM4Ns=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b58553449so13138642a12.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767166923; x=1767771723; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sBxwhR+DOUWySSn1nkmmHXTpgGimoEMqTlfeKUVI3Ic=;
        b=HjwTxlhKnnycgXGiJnvhvur9ESXysJ86kjeM/vv7dSSW0nzMURnmlJYLiEDdVlkCpN
         ZIiGntfUFzJMY7rd8Hm0Mw410bRP8DMPR/U1f9nJMkYn0wNg1NS4bhX2PR/Ft9Qj1Imy
         vDYBbi8EAOVF+/5r2WQGZdsdx+UPZrOne6QGHc/TiD21dAfbjZjYKIxnKszK+j02tnYB
         W+jmFxYHarcFPRLkq/chAy1A5CrQ8h4MX8FjTpIzMpcV90odwpt2BJ7uojAbUt11JRN5
         keifiRjVTMl7YNZkpeC5jTIpKNBjrfJaY3cw0tuLm+CrBdvUJBVgCAAMXq0djOoO4udP
         9DMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767166923; x=1767771723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sBxwhR+DOUWySSn1nkmmHXTpgGimoEMqTlfeKUVI3Ic=;
        b=GzTOe1C3qH+I69zLKtErhVidVp0DVVMJ+FbjwpqxwOn5noEz5G3k0/B+lxKt08b+b7
         LaA/B8iM1eVjX54ktL3wmIHTSoTlswt9Pr2Q66iFtvsVH3UKuqekzB4ql6NO0/YxIdf0
         iNiP692mvN2FHtLDnxYmIJWGoiFdKBcOxBcG5zt2empBaARKvSSUQJKnf748vupF/2dj
         goEEG625xuX+7el6ovwGGlfqnE3GyKreQmYuHrlmkL0tzJ0RZtq0pfSwzzFNUm577MXd
         fSuPGmAW5RSiFfsH+4CBFoDo5p+h3D5UxiHJpeP9qCrRY9bdfNASWfvoAEeJTXb4p0rK
         3JEw==
X-Forwarded-Encrypted: i=1; AJvYcCXAyrZy7sQ7MKCrVIGhzv/Zagc46XBCikLG02NtN66QDMUi80dYoUCvMTBRSYxctYH1yAF0wZYU/g==@kvack.org
X-Gm-Message-State: AOJu0YyLu4CCaEanI+Ol7jXLh/Z5qCKbsgNRalcD47x9oJf5KwED+Hn9
	2369vg2X7+5vX85nddD4rEsZCcEnym9A3pIMRGdfNLXNHumqij5QAKOjXjqbk9LNtg==
X-Gm-Gg: AY/fxX5/hU0VworZ3PVdwT+LADObDAgJUk40N8Cpt7/oznv4Ikf1Fv4XfQ0bSrTKKIN
	cS3ZknYGoxsnZG5UI7kjizZMJ2krvDRe7nGfsipfy9dgYSX+lhwZqzFGRydhW4+hvSBz2nw14Me
	l5/LcUgJwnmwH72NPPuG+/Ua/VZcbp/c1526vB77G0mFZeXESRLcESyIf89OvnuoGuhcffdy6c0
	XyQEI4yMymW3rHpcEG0DXEjgXfKaLwNbfXtKgLj6IUpPFhgYdM8TUI8KEf6mnB1QntGmku55e6C
	zQ6kikacE/+Q+H4NSz4KMqVvvXpO17ra+FtAmy8M7bUOdVPNoqw7CZRDsuyGjZ1yC/85+I5I3zw
	vp7iVa8wK9/9Ol9fChjZ5IhMt6v4Odik5Dx15ntm2ehys5/k78l65SZTQ7sE25Kr9lnWiYQ3CFn
	+F48Y3m0DOHERpDfzMiGZT98JKyH2d9nkD8trAAs1oZ+Ee5AKRy5LXDQ==
X-Google-Smtp-Source: AGHT+IG1aRB+d3WsL8zwpg57El7FgfpDZaQb4jebLM9i908vaeSLRjskbvtS5lkEflNe6+T45D2gZg==
X-Received: by 2002:a05:6402:5188:b0:64b:83cb:d93e with SMTP id 4fb4d7f45d1cf-64b8eb6194bmr32320732a12.20.1767166922985;
        Tue, 30 Dec 2025 23:42:02 -0800 (PST)
Received: from google.com (14.59.147.34.bc.googleusercontent.com. [34.147.59.14])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b9ef904bcsm36693514a12.22.2025.12.30.23.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 23:42:01 -0800 (PST)
Date: Wed, 31 Dec 2025 07:41:58 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
Message-ID: <aVTTxjwgNgWMF-9Q@google.com>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <20251223044156.208250-4-roman.gushchin@linux.dev>
 <aVQ1zvBE9csQYffT@google.com>
 <7ia4ms2zwuqb.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ia4ms2zwuqb.fsf@castle.c.googlers.com>
X-Stat-Signature: st1c846ymmb9sy3hxzdiyzfbu6xx3cgs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DEA3980008
X-HE-Tag: 1767166924-274396
X-HE-Meta: U2FsdGVkX1+NfuJ2C2LqPEtzimp8FLuFiiZS705d6wluj+/V59x0jQIYQxCTyt0z09Jo2EFs3VNxc3bRxvCeW03bZUJ6pyHEXFachOB7e/U41mmGLQvVRmDbfHtzFDruLLv9jkHF8GtFqev2hTSY9NAi/Ll1jjPWtdZJ2zsLaFgcjXfFIishvb/RrGIhnX+zeAdHJhai2CnJdROL0bHeJ9fkVzcrcZM6P93LIKL0VMPb3h/jXS2Qhz/KNUxJH2Ia6TgBPag6AwTpcSr1bKWWYNkJWHAKoWXi6vyD432qqoewB0esNzaK70YLJTZm8zWMGkVS0b0m2k3gJDXcWTs4bMDnKwqAtAEArtz8OuQnYqqTiWcHaCHL7lhABTamJZhZfv/99XYyMuwo3fprLi93GN00Qg+XLLPauilVdcilcrXsiJ4os12j8aY98r92DslUPasYQrhhO3s2nAr/dfFAjdUuFnct70sy0prab/42PBlXbQD+pxRcpGsjnOFhZqukZZfenMnavW8RgoUWwfgElrLpF8QYJA0mQbJHFxi+tbSCu6lQ1p9wYjVsKGCZ/zm81VpT3bSyN7EnUoidwk2ycW3aaH/n0FbFbxycqmy6YjH4BpSe3JTzIhsceHuNy0jk5LARx+1L0AEPo5T8M+KEhxdAPfsC5QsFXeNE+ZlMrEuypukpkdlOy6NsCLmW18hnKtH8K0jtMgteUC4FqfyFMzljp3f3VlhEaK2nlCcT6an34i8c8n1P8Yz9A4sc/YRmYkG0BB5xIIJ8ZdzlIacQwebGHxnEUuuERjDY4YR2LoORyTTDo2wOJ0MIiwXxMQfAuaOsqHsg8jT8yFNvtz/00inGBb22tmXj13qilnZ3Ye2dsi8tFQ+e1gQHtu5cz0ZjXquI9DH0K3KsoX3qGukR7C+a1p2RkCMsbW57h1NwV6kjTZ8klQSf4XVXNqirQ8OmwdYCXwBbD+R5lm+H6Vh
 JIaxDupo
 MyX/4OJfW/LMLmb9AsKTD34b8jsox6U6L1rU85U82+Yt9ELFhwteXGBMpEYLhZwSiG8Pn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 09:00:28PM +0000, Roman Gushchin wrote:
> Matt Bobrowski <mattbobrowski@google.com> writes:
> 
> > On Mon, Dec 22, 2025 at 08:41:53PM -0800, Roman Gushchin wrote:
> >> Introduce a BPF kfunc to get a trusted pointer to the root memory
> >> cgroup. It's very handy to traverse the full memcg tree, e.g.
> >> for handling a system-wide OOM.
> >> 
> >> It's possible to obtain this pointer by traversing the memcg tree
> >> up from any known memcg, but it's sub-optimal and makes BPF programs
> >> more complex and less efficient.
> >> 
> >> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
> >> however in reality it's not necessary to bump the corresponding
> >> reference counter - root memory cgroup is immortal, reference counting
> >> is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
> >> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
> >> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
> >> 
> >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> >> ---
> >>  mm/bpf_memcontrol.c | 20 ++++++++++++++++++++
> >>  1 file changed, 20 insertions(+)
> >> 
> >> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> >> index 82eb95de77b7..187919eb2fe2 100644
> >> --- a/mm/bpf_memcontrol.c
> >> +++ b/mm/bpf_memcontrol.c
> >> @@ -10,6 +10,25 @@
> >>  
> >>  __bpf_kfunc_start_defs();
> >>  
> >> +/**
> >> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
> >> + *
> >> + * The function has KF_ACQUIRE semantics, even though the root memory
> >> + * cgroup is never destroyed after being created and doesn't require
> >> + * reference counting. And it's perfectly safe to pass it to
> >> + * bpf_put_mem_cgroup()
> >> + *
> >> + * Return: A pointer to the root memory cgroup.
> >> + */
> >> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
> >> +{
> >> +	if (mem_cgroup_disabled())
> >> +		return NULL;
> >> +
> >> +	/* css_get() is not needed */
> >> +	return root_mem_cgroup;
> >> +}
> >> +
> >>  /**
> >>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> >>   * @css: pointer to the css structure
> >> @@ -64,6 +83,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> >>  __bpf_kfunc_end_defs();
> >>  
> >>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> >> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
> >
> > I feel as though relying on KF_ACQUIRE semantics here is somewhat
> > odd. Users of this BPF kfunc will now be forced to call
> > bpf_put_mem_cgroup() on the returned root_mem_cgroup, despite it being
> > completely unnecessary.
> 
> A agree that it's annoying, but I doubt this extra call makes any
> difference in the real world.

Sure, that certainly holds true.

> Also, the corresponding kernel code designed to hide the special
> handling of the root cgroup. css_get()/css_put() are simple no-ops for
> the root cgroup, but are totally valid.

Yes, I do see that.

> So in most places the root cgroup is handled as any other, which
> simplifies the code. I guess the same will be true for many bpf
> programs.

I see, however the same might not necessarily hold for all other
global pointers which end up being handed out by a BPF kfunc (not
necessarily bpf_get_root_mem_cgroup()). This is why I was wondering
whether there's some sense to introducing another KF flag (or
something similar) which allows returned values from BPF kfuncs to be
implicitly treated as trusted.

