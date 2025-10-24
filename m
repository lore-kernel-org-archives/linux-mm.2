Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7268CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C61A8E0103; Fri, 24 Oct 2025 16:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276928E00C9; Fri, 24 Oct 2025 16:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1664A8E0103; Fri, 24 Oct 2025 16:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02ED88E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 867191A0F89
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:07 +0000 (UTC)
X-FDA: 84034184934.05.DA506E1
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 94B8B20008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vlal4+Mm;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338645; a=rsa-sha256;
	cv=none;
	b=CeShuflb7b1uWJr8z+7k2yyFtpluX0kPFcowQZV/BTlZyuC/K5LtZB/Yif0RNiRTvuH5v0
	tJIsZQWglMJTEzlcxf4AvbTbhgCNFRb8xQbyn1r0fgQFl05KVPngJijOiKuYuhJ+I6xXFh
	8PDIe4gGLniPUqXSSp4wERe5IeXmTVY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vlal4+Mm;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxHcVaFJP8LSAUbqjjuozojLxS3r7R2EKYoJfzV0av8=;
	b=yCr0arVn2hiNZKcLLB/vPgAMuLBosbW9zncw72IHgkq/l8qzXU0orWqlT7P7j6ZZ7+D0wK
	YHgSfpzJjKtqHDUNvDiYMXV2wE9csPJmjXNDk9FqfqxE0ZG8O2aHjDYqqhvy1AHvyicFMZ
	iDdprL0wfMe4Pia/v1YX+qV0UTf6lPc=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso2565206f8f.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761338644; x=1761943444; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxHcVaFJP8LSAUbqjjuozojLxS3r7R2EKYoJfzV0av8=;
        b=Vlal4+MmLDOBdva3a+oIx6M6Xunbfg/2O5LA3tyelZX9v7Y4FkhZWovnnY6psQxXdR
         167Ci7HGPFaprmQJN+Drbue107q2C1vlfpnQOrE0fmKZHyMDNUC8sGxGbSzgJG80BQj8
         rfj9HdLDHH2tve3Q4+TepIesXXA4TqLadHid5l3c6i1gN7N/9WnYV1AThFpPMT2NgYjN
         5e7p5zGKHBKj2HR6VDIS0cPsYM/Zs/NnMBjwj7ff2NhxOVKc9uH9nVCkQAzvoAL5HX24
         ENF2b3e06AVXP/WL4dFUX0BJwL6J45VjRd57bbPMCAGhQTR7weotYOd5KEklsOrVcM+U
         QLTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761338644; x=1761943444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxHcVaFJP8LSAUbqjjuozojLxS3r7R2EKYoJfzV0av8=;
        b=OsiE6w4exfQ8tluDUU6oCOCercMam3mauO3v25hbpB17Sz0RHmkZPaviidBETR4Cxl
         FT2pwIjTKm78G1rxqnkN08aH+Vs5mF+tHX7LcfyzbUuIUJnxQX5+3QRBl9Ag4INSVyqG
         s0MOi0qj6+6HZ8EOA1/WSkodJnHOkLw/NcXaqj8mWlGCTAOZaxISBkY+tk+SfFCo5h3H
         bt/SZA61lmEEc2CeqVjIv6vqROYuSSIkn/73gY8/hUgzXdIGgu2Dk6epPmbhxA+S5iix
         +z0RxGks0jF6k7DRRX3mPtMkIV6Td6Omkj8YiuT/p0BaS0ij7BoDQfsHwdgB/ZJvot+G
         OR/A==
X-Forwarded-Encrypted: i=1; AJvYcCXhq1kechM0xY3QIopRyd4JoCPMI6LxCMDW6GCkLrJ5drfXf6+PGDei3F3FhdQ32U7OS9cxeA3fDQ==@kvack.org
X-Gm-Message-State: AOJu0Yxyw9fGR4Em+vsU7IgG9RluNvqLsaq1V6ZNpRIhZSMXRySUyjdR
	EefLYXOWfh99rmEYMC1Iz4s0AVMaYsl54+P/ZRKDQkeciSbaCmf8kmPgd2++LdXQDUK3casYThA
	OZFzaKNNPsjib/K2Yleo28xgfNz+T0tQ=
X-Gm-Gg: ASbGncsQKlor0/eaXYXAd7/zIVCXkVVWdqPh0OzrP95dy1XTLcrxkLNuqh2f+Bn/Ar7
	m+qoYRJ8tHeFALPC/Y1Q7lK0vOFgm2/FupH6JryDe+6nl7EhenUXdw9NJ2FpN2/5Y7gix/+X+Pl
	XsY/BEr+8gpxCg6sLezpwar/ZbPI7xDwh7AGIvOFfluGWEZrEo8NiEUp+4mWq0iwCtVa6zK78rc
	lnYKOAH7ns3EWc/5XW+CpQAJXhrRk0xbXWG5ny8up2zNJvJ6IXF4eucLbsYlj/qGdhWoBKd6nvF
	6cF2fGB3EOD0EinHogCQiOYroK0X
X-Google-Smtp-Source: AGHT+IGLFt1YCHWbNyJyaEpr+22LPb9d3Q1kWYq7cFolvy1jDcRdvp0v3rx52ay4vxC3D1vRjgD3rmqs6Qx2J3gTPG4=
X-Received: by 2002:a05:6000:26d2:b0:429:8a81:3f4d with SMTP id
 ffacd0b85a97d-4299075ca93mr3213632f8f.63.1761338643874; Fri, 24 Oct 2025
 13:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz> <20251023-sheaves-for-all-v1-11-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-11-6ffa2c9941c0@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 Oct 2025 13:43:52 -0700
X-Gm-Features: AWmQ_bnqGo3VhvdnD4VDhLrtr6dWJQ16k-K7Ue44kfB0ODJ6fAEdUY4Nt58fKuE
Message-ID: <CAADnVQKBPF8g3JgbCrcGFx35Bujmta2vnJGM9pgpcLq1-wqLHg@mail.gmail.com>
Subject: Re: [PATCH RFC 11/19] slab: remove SLUB_CPU_PARTIAL
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: tk1o9m9949xupwmwp67459nh9pz1xj51
X-Rspamd-Queue-Id: 94B8B20008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761338645-462221
X-HE-Meta: U2FsdGVkX18HjOYWIpT89/+Jcaozg+Bl6xwnRwh6lwuPzmE/0sYQAPmTJMuGdi6u3+1iY9PIyuTIK1CaucF/KiRcJq8eXTGzdcPnN40ZxTyRXGfBQ1md9eK2c/y5Jophcv7oC20fKYHnKXRqfmNB8i3n7N/iwEbZSHsLK+X6JYqiY6DxjwdGqSc7XW9gz8hddURMnJXj4CAcG4JMOdJiEHo1KJ9+wTvis+5NpmVUImqmh2RarbiB5ZDahfnqKS0d0nBT+mfKxvIlgERQzYiGLjA71wfcQ85XVfBEe1QKO5ZJ0RfgALhFdWO6oMikB1iYcfGZMwEIkpl8OiHjH5tu3ex2DciXIqUwMq+JCBoWgy4DFLPNE1g0Ow7vTlJH7D7d/rqXtWmGR+/9qURRv6bjBhCRv2WqziZiUU9IqOJNEDU0U4AdBd+GXGs9OtzugFsmL2Sz3nkRoNRa+b4/2HNNtIk9sRKlqie7Zomq/Rg4cE3vyS/CmZFxouEoBVVU7GSrz/KmSZYdLWg9xwPibbOp03VTfyr+KWSzW3ybPG5AJ83Cu7g4lZyvIAhd0giv9rbaXKPBz1y8krS4IjWEBeXdaBNHKBGvbPqR9Y6/u3NGg1yn1+frWOb247lSqA1JJtheTkBEwp3Dlpr/ln2gEOlEk6He8mhWdXTuol2nMbfOIGzoPCXr1THiCscTyDCVgKyQq7pFJply+uvX0uUsKjjDusKjomw+PLqB6I2rm0ei0G/rLOy5ogy3pCbdPQyPbkVxNU0p57fS2Dnd0Q5tONnTkCTMcBhsnnPQABk2kNSxKyW31iMiV17Zh4VFpg+VDX4IaRLJhXfkddG9uY+gIPoSvgIvr/KOrMEusp0l73S1ViE0WfIiuaZUo+cs7A+p5TNx58eUwqjDdt+e5X4Waw2Hqz0+7yuFDLsm1Zw/tAXe6Eb5aXAXpQIWhOV2JjzF+C3cwSBUnDwfvuUB2lqJqo7
 cKnTc7SY
 87cHVzQBXYJ1cJg7CTTrVljxwzS58+WyG7MwXTYLNPCxuNz7J+QGcjUXBP2+7ymoI+VTKUUg5cP+JE7Trc+4IYiIXvGd9GD+EBxR1qKftURFJLdu89q7Tu80GVU5toIgFGwyxjWt9px7qZkfLz0Y6ZfNA1PXEuikrIfiiamP1k3guJirsU3F+fxswCKMJWZuxfdVR9q53rx0x/TstUAE/dER7gAUOwR2PJ6RakxubBMf4Kbiv/AZHkw5FoVyH2bTxYOIqY7zQ5t8Sr/GGfoaMu/GgBE0qY6+JDNEB0J2D/j03VW7ALyxLB171mZBQwDcNo8LMqIPtzQAw1A5JrLAK9VFjkgyWi+W02gyU6hIhRep08zwbH7jou3weewEo5qZcXKXPABklw/tbIPD53elDPjN5DE7nPbm1ShwWi3LMOvHGgP4LiCFGqqsLxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 6:53=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
>  static bool has_pcs_used(int cpu, struct kmem_cache *s)
> @@ -5599,21 +5429,18 @@ static void __slab_free(struct kmem_cache *s, str=
uct slab *slab,
>                 new.inuse -=3D cnt;
>                 if ((!new.inuse || !prior) && !was_frozen) {
>                         /* Needs to be taken off a list */
> -                       if (!kmem_cache_has_cpu_partial(s) || prior) {

I'm struggling to convince myself that it's correct.
Losing '|| prior' means that we will be grabbing
this "speculative" spin_lock much more often.
While before the change we need spin_lock only when
slab was partially empty
(assuming cpu_partial was on for caches where performance matters).

Also what about later check:
if (prior && !on_node_partial) {
       spin_unlock_irqrestore(&n->list_lock, flags);
       return;
}
and
if (unlikely(!prior)) {
                add_partial(n, slab, DEACTIVATE_TO_TAIL);

Say, new.inuse =3D=3D 0 then 'n' will be set,
do we lose the slab?
Because before the change it would be added to put_cpu_partial() ?

but... since AI didn't find any bugs here, I must be wrong :)

