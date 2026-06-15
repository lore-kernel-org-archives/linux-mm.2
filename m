Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C24C9CD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 04:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BBF6B0005; Mon, 15 Jun 2026 00:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C8C6B008A; Mon, 15 Jun 2026 00:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14AD6B008C; Mon, 15 Jun 2026 00:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACB0B6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:40:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37A1D408DA
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:40:14 +0000 (UTC)
X-FDA: 84880895148.16.CD80FDE
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35E181C0003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:40:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ad3WWyeg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781498412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8wL7Pot9TPYI6OkBDqQJP6r/aDUyNWYD85ZHyLvnQ0=;
	b=YTFXsEciRlmA7CKM4edswn/DJMdRG3FlL/1Kwfj7oD+/iJKQWHrjtze8+EHx7kbAETLFB6
	qW3FoP59ruZTKJ5pQndpT+2UKXpAbjAQjBFvwj+yTAV1KZTD/k7Ncdt2cMKx3ZEdoFIOUU
	lb2L3KeC4R6ogbFDAPNwXwTXX0HUHDE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ad3WWyeg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781498412;
	b=GSa0FLf46+K3VuLpzz9A8Gfczla5bCw802HoHjLeT17NU2YGKhVChPpnuEi7y1ZISkxMRF
	mev3W1m7undDGrsCMK60v9k+giEQeP5QTskpiJJfJa4A589Duug5fYixVglYFtRRx7wsa+
	vjSWUcKNTYI312IJoiU5kzLyCZUmxNM=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51765531803so854781cf.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:40:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781498411; cv=none;
        d=google.com; s=arc-20240605;
        b=M+duht8uxFe9FLFP/gMRuZ0oV2jSNtqUkrnMkIAi4t05IAcUijRvvhXN06d7eaEQot
         gapl2UW9bovTfNRyTaL2078nfPEZ2uxfNslMXAptnmcUl7bmGIPuhM+YRTMPpOcEwbU4
         aoZM/D+ye56Le2NOmJcoRQb0gxO050/cHQvu4nA89zKra2OSyD53Y/qgxffrBOtxVxEE
         QxA2tuBTsyOndBY/EuFVCR53WCdrRLRaark5Llo/JviEHhJMSsb8K5WO2y6t6/b7wxh2
         SkQUwBQ3VrAVp8M/KrLIVTDp4uXvkyqnbcGZSXv5bjQazVONp34vKk8VWeIvS9iVmEWH
         V14w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N8wL7Pot9TPYI6OkBDqQJP6r/aDUyNWYD85ZHyLvnQ0=;
        fh=JycW1yq3f04y7jOCmErqgXTl9jGjDzjQ6p/vGEAv7uE=;
        b=WGVvuVLfPYGugY1F+2Z+/WCwWVcqpGAZjWD4O4161aV8fwk9ixV2Zq6zXj1SFRklWX
         kiXUWGfh62a794w6dCreHZhNqjU1YlmaLi+6TOZk04WGRAFH2wl/DY6WjL1RWUL30pVb
         wJsFt6/YnouAgRFKV0EGGIuZluBJF+VzRH3//iVt+ZFIKJzSnVacK7VCI1GH9M/DxLVg
         VaMoOIH+dhtJlMeIFFGb+wktEkLVvL9GucppK1XX+YNsqJRtHfe4l29SttJCawiqrr6O
         76aYSnN61pWDuID1PqnIbBS/CrDmS4ILMC/FUBzUDBnbppo8RJPHBRcS2KD6zwdqE+JU
         7LTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781498411; x=1782103211; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8wL7Pot9TPYI6OkBDqQJP6r/aDUyNWYD85ZHyLvnQ0=;
        b=ad3WWyeg2NUQmny7N1CuyIxkIjLXbsVz+9AblLLU3VegtN8Kc3c1jmXcyJyLvVpf4P
         impudDL4vuYYKsHZZGWQSYWK96dRkX07qMNL7WCQIOFu4q7P11DvW6W5BJFInMmV5zss
         RlMXA6oq0/uH81Js8FHK+XNxZNPo775i8bMtYKPHv5U2IMiBe0p3FRR9zcNur4QAhP9i
         agzE1IUBdpTLpDmtu9hEs6tV/cvKQRCSWiKzjfJZ626TAY1yLUgarcSPsQVYoUZdcRp0
         CBETBfDKgCBiCqCAk0GFZGUm2qhf8JAmmtZajAO5R7z90mYKNj6WAir92eziT0LpTkUh
         vXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781498411; x=1782103211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N8wL7Pot9TPYI6OkBDqQJP6r/aDUyNWYD85ZHyLvnQ0=;
        b=Gto3S63nWTjBaqQw2GzdYFSFCJHcmVGEDsZJgLPJ4zI7rYSEemYyrrGnC2+UYpFvxT
         JFiltsqCJ91oOnh70LoneURdXg+HsaDjmSAN72CSPMvNLYCLMCnmTjS06PZQYvEPWzsj
         41iDyCXskI0bB+sRTrDdrh+YR/ng0ZKsLrb7ktiRM/3Q6K3zOjuVIHCsFPkPebvKBvXm
         qKQWXS0byI5qPzA0n/ukDPf/BtkbOMJ8xjrD8SAJOks98qJ3XcWtIGRFW6nUcfS1heDq
         e+Mmw4YRdeiX1km2tyhrl364wUBrJgGCAumj1i51+DvhzGndmLVznHfvRV8AxHSZnF8C
         PkYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/N8GM7iS6ZoZ5aEE0uSQYmtOUztn8CFv+5g/9GB2m0YD81xCKzeMqrKXPSX/UcuzFC6GX1AVvmNg==@kvack.org
X-Gm-Message-State: AOJu0Yx28x963Px+5h79vWheXZopS9QMdZXslWIN6gfIiVunKTmvwA8W
	0jEWykF5LUGs4xPTzaz8F6u6z1BYrVy7k7LzR1N6Obhtj14FtA43yYYzGKi1AIpVEA93POmUnof
	Xxdzgxrp/ZNm3HYYKHS10DwRgUhFpqR8/hkakZXgz
X-Gm-Gg: Acq92OHxJ9lCGn0FNS4FNJsvfgYYwWblA31eO90jrprhArYG1kr/IWmUtd8qcVQlEzj
	3822LYx5VXkRrZMbNxcpZdH3zpApH8A6ZjENrX57zyNQu/gdV7c6gk7WZ00FS8HnlmM4AFEeD6j
	efYZCP0Ipfjk4Ip1VvlvLQ5YMWHEGpGAUvIDPfBR9p1zE2vkcvYcDJ584u0hSJsJSINoX9vlp/U
	viUkAVEwxZ6SHjOiOWxj3Dsr6DwM12CKOMhk6EX1gyL0sBMhEjxHp7+xUQHqG4JEd6276sE8eIa
	a70j0w==
X-Received: by 2002:ac8:5a14:0:b0:50f:be7b:923a with SMTP id
 d75a77b69052e-51955e93234mr11860351cf.9.1781498410717; Sun, 14 Jun 2026
 21:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-10-7190909db118@kernel.org> <aiuY1mDjpfCT94VY@fedora>
In-Reply-To: <aiuY1mDjpfCT94VY@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 21:39:59 -0700
X-Gm-Features: AVVi8Cf-uVQlgcYzn3DpB8ZEHMqqH72kWSMqcl7ovJhnnVzqopd4FHJddKgOOls
Message-ID: <CAJuCfpEKXTtfCFSx2kKN7T4dRNXg+7hMwQnrhSMey6DBH2fr7A@mail.gmail.com>
Subject: Re: [PATCH v2 10/16] mm/slab: replace slab_alloc_node() parameters
 with slab_alloc_context
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 35E181C0003
X-Stat-Signature: e6pocjbz9tjt9hgehx7oxheyj766nza6
X-HE-Tag: 1781498412-694380
X-HE-Meta: U2FsdGVkX1+2WZBO1ixfoCwxq2IqQhPhb9aZgK/xRmYpFdnwHPvqb9WVD3sJvlSohmJk5aqRYfN5iFc8aAgYdVx7FpheRERu+j9xAikXhtsTjm8rtk8xvW/z9hGvIayDgXzQ1gF7O7Kx12VtEoUN2RJ6Mcgb9NWF94VGTdGaGbFb8nzecOVTX7Rd288bgjaM3cNsbHHbm58/nm6QTx96Jr/1Il4NZGdxGjJwHWXxPVTR+STixfZ4pVg6LpvlMFFDdURHUMnTI0mCpoPKM8MBz57ZKU4rjlF82jpDg2C8+yzB2ZkBOLP6FJ4WQayDIvOKzIMwvcSdhX9OsalUjYYLh7Rtgwulo7gnusuLr5H+I4aHAU28b6u1a3ZG76gntnOt4DLyDHdDc+9yzHoQl8fX990CI/k38k+VV+wvNxwl1YuFB9XJhrXHV9FtNo8Czfa8ZKivOHW9SmLwF69AJ7TTC1m8Li+BBGw2RvPDulzVYaYA8DKahYeG8DUQwOqVB/8e58CN64rCn0c3frLfdY5lYJwLarmy61EcTfWACb9c/W+2jcaLWQS6FaHnPT+rY8IM0UWL9qLlcJs40HCo7bhsZmSdJ8Bigg6lFCthdF0/4V6F4Q0J4kIytRjzrkXA15+vez5DfD7afSNgpdl6s/oFKSA9S89BQk3oEoVEsNa8rCFaemhJh9zSeUk3XeOcrtZIhZQxzHSsZxkSLFzoigJHzidCvG6Exe/uNJ6rgNuJl7v1YCt1XjpKMWrvTDFKtc9RNge8XOpze978j6VXaIrr6OELyPXe2yKiYd3es4Utfxr96IX9SaJDVdjUIm0bgC5sbzYaasst3qW0aVGo5INOYRI5pR2LErQGCJpmImg7vREVJ9EowiIeJgz9NeIz+lcj8mGjtCLOZcEZe6s/bMPqS3PnKHNmkBOO9maJivQKJNNKAd2MIuyi+rFhNujZRGia6w75BcSDDzwf9H/Ze7y
 LxGtclA2
 QKZK0FLlWVrKeWzo9AKkjx+z1JrOYpogovGxciS+tVMjW2CPHAyjtE1F0f08drfhge1cwFYgsLDGNqZtNwsJ+U3y5Iqa82f08kQdZkoQHNAT9y7h6qj+jO9yG91GESnXh+HXpwxkIh6l0F3Bp6QNNJYlImTtnua9tmAYNGHNY+UH9ySywIjtqfpLt8rcn3CTOYO3oMB/1SUnW/NecU6RBg440YU33liRaS3Fj5hqsNkU7uMBa5sfzAVeVV5tXS342RBBae+O0JuQxJe1KDALUzRvi8m6CLPaLQWetLOBQZDIW2DMULOTGNlyWWde3V3PWMcrVGNeOQWegu6XoGcxc7SQzKxty9gYF4E9Dy+iaPzVesp3ouhaC9IRpztly/MyrWQUicrx1anLlwHvauTeOA5+zkxwXu9a4Rc/3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:29=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
>
> On Wed, Jun 10, 2026 at 05:40:12PM +0200, Vlastimil Babka (SUSE) wrote:
> > The function takes all the parameters that exist as fields in
> > slab_alloc_context, except alloc_flags. Replace them with a single
> > pointer.
> >
> > This moves slab_alloc_context initialization to a number of callers,
> > which is more verbose, but arguably also more clear than a long list of
> > parameters, and most do not use the 'lru' field.
> >
> > This will also allow kmalloc_nolock() to call slab_alloc_node() and
> > reduce the special open-coding it currently has.
> >
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao

