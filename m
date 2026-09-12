Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 286CAC88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 00:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1506B0088; Fri, 11 Sep 2026 20:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150986B008C; Fri, 11 Sep 2026 20:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016316B0092; Fri, 11 Sep 2026 20:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B21276B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:05:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75079140343
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:05:10 +0000 (UTC)
X-FDA: 85203165180.10.0D48A27
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6A6AB40006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:05:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ALUtYkE9;
	spf=pass (imf01.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789171508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9T+DmYc+qxQrzaKN9l3RbSiFsILLsDPZCDFtVs2ENQ=;
	b=5SopJPSd6SmnGC6mU5grMC+tW7DWbS4BvgBxNTKS6OAg5eLJDn80Z8b5pU0stiXxgrK8wm
	+iSc0AGjvLJV3paNcQpT1RZX/iWKqFKaNzq6j7RGRYcjuPXTqyD2VXZKA+qINopl8pUj88
	qudeu6D8NOx2bnOSUJC1KC///hdRm4o=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ALUtYkE9;
	spf=pass (imf01.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789171508;
	b=v5Dw6Oq5hHJA82CEe7LRMcY4OZXfNBpPQo9sOx53+mmjUpM28iX+KrndPf4L5R0YaOBvVM
	kFXIZ8yC+h6ZRyGVd+A69oOAdGCGMaY+Y3Mk3WSsDsQzfY21SjXJCfUgChYliH2nINh8eH
	GIXBoKIgCWgidxjedKHjDd1bkXtPnHg=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso2177504a91.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:05:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789171507; cv=none;
        d=google.com; s=arc-20260327;
        b=bU6Gpwkj5c1MEOVz0+XBgFtzB0Tg74zKGtjI5AbEzVH83k8qJRSgNFBRnLjkBkjmg1
         2mbyPVC9u9guGRuW7+WAyFZhl1VRgKN/iVSGZA6P+7qTnDSQ3SlVBA0xJWCuykRlmsF/
         KKVlEdid9+WoPy3HdUMZVwhvUq46O+rScpD7WF77pLWMYJBPSr60yE9uyjViBpnN3lU5
         qkNZNJINqffSD489zyUW7MwhlsatfbdlyPP36TmVRv8KhTV64E3it9ze3uCCSdVKzQ2l
         itPyNYDTbQC32uNIapvKGN4H2SM4rWE14+hIGLmgYj1UQyr4f2tRDfHtzyY9767Xv2Ab
         L20Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S9T+DmYc+qxQrzaKN9l3RbSiFsILLsDPZCDFtVs2ENQ=;
        fh=rLYRahuHENXjdQiJuuDAEnLEYdDBSdFYpZF6DVw3gHc=;
        b=Q/GRN1CKwGEn+bZrU6FTH9JgEKQXygzbxIAmcTDPvI6iPVF4yZnJ8kQ8qQ9MzoSt9f
         p7S+Xj2ZgUXIj+VQo0fXXVjpuQSssrv4C9COcPOZ1b7Y7E4/xXjIANMceUVtMW2+hQ9/
         FxJ78UYTNkzr2s28ZcHxkzqTuuhBQeQF/gQ7vS0FnFprFU/wgbot70KS7DZgmYENSSQO
         SE+3kjGhZV93h3wnWeoQf0+6/+Ln84XzMlT4iTvUlAQzxvIlU1oU7AERVqBXLvUlLSSh
         NlhSyPJnAgToA/tHTFNVu1hZx8UWV+CjozVsdG5V/IE/MXhGlDPbHfr8LPqbwgiPAsGS
         HTJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789171507; x=1789776307; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S9T+DmYc+qxQrzaKN9l3RbSiFsILLsDPZCDFtVs2ENQ=;
        b=ALUtYkE9uq+eXsatmXQZqQDW15gyytbZPIlA84pnwuddaHhXW0h4YlbVEZtwbYKg6g
         uMezz1hWBeqWerRBLFNVhQgIOIP5RxMCMRxnmeozPpQg7wTJQdZrdtTCHFpk1WC6xb04
         zAXOYRcSatYFHfvkxOLFgt+P0raS8fBaLbjuIP9gsCgza9M7qfblSl4G2yti4uRNe6y6
         1V9g0+bljWHKQA3q+viI38To6uJ9RIC1AaTehV8uUwyEMRMc7Alr8diVsNA/Ij9bZ7vc
         6Ojhh2gyQYw39R7NMwgGaEG6vVZMpNtJGe0HYL1BFKFx4PfG8a0a3CaWPD/tqFwbNJip
         q2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789171507; x=1789776307;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S9T+DmYc+qxQrzaKN9l3RbSiFsILLsDPZCDFtVs2ENQ=;
        b=qtcBKe54W/Jen/VNyfqaLW7IxaBwAwtlZH44557sTOQQRp95d0zPzJUP8ndv3Xj2s1
         UjhOfeCqWNPEbOz92ZFVTSVGrOcIPuJpMVVwHRH4twKj7Hz8sB6lPZNlVpEaFBPmFCfE
         hlqxTTbOA7x95rg889kz7u+DLW8mfdKHBen0FsQa0+8zGziytPB94mtzSJTji+tJgna6
         T0qTfrOR7KyxlcnsXbtuoGNWRRI4g2QAF8IG0yVSBMF/T3lEa22tGyzFya+gVdyb5gXj
         df0CzyGFGNuC2O5gPC5F8exiidf9y2qkC1l2GxqB5psbMrvYrPHPiXeIAnQzphWKtlsG
         WbdA==
X-Forwarded-Encrypted: i=1; AKwUvByL3sQZ1uL2ejeFsGkJVyktY/UWdupoJnptUp6nRL8QHruEPwkvcKLN4WTNRyYVNaHYt+W8BlepfA==@kvack.org
X-Gm-Message-State: AFuF++mhmovwDK/tpEJlcCkKHNCCDMkd1fVWuCr1f5IO1OOE5b8VBEbz
	NXdigJLXBS7LMpqXHPAXVAXxNXJCtnqCX7fm5XjLUMyksr0Kgma8PS4YN6ZHnrBW4XjSnNZDXIR
	PeHAwKQ98V3c3MkSVMg9XcN0Rm2i6TDs=
X-Gm-Gg: AYBFou2rO2pBdWmhKQoCVnXE9SPsYg0g07N2chRdqj11AvFJGNYmkpjbhhXWC+REJSz
	3vR8FUc+emYlMpKiARJHvyvmomv7reECt3VkYWodGF/7YmqnI/liFeuisa7Jk4HwpugQEvL/d7W
	U2vEw6UbwpJREy54LF2E5Q0Q6pTjS8Rtgx02aru+1sELVJK5uvzK+2YMFrlYYu3PZ6PRuX/s00Z
	HHJRkwS4C4FNudEApy9OFikhm+TzaWSfpVfLloLba25Pn2WV17U0UBE4gIEb3Not8vgcUdi7E1t
	kcMwm9sj6HuB2xbqGMQGznMH/qICJ4mpihfbWyQcDEejz9pG9RhCZEmyYd0CM5zhIzKjHdKxHEv
	OLASQ+wL/U7iwxpicWUaR7Jkn6hemuIYreNqc
X-Received: by 2002:a17:90a:ec86:b0:38e:70d5:b12d with SMTP id
 98e67ed59e1d1-39d9bc67655mr11774219a91.6.1789171507258; Fri, 11 Sep 2026
 17:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260815091819.3651099-1-gaoxiang17@xiaomi.com>
 <04f3ce2f-67f5-4829-9551-a69b9df29854@kernel.org> <CAEf4BzbwZkoacX-iP1j4+p8YNbWsq0pc3eTermh2uT5ir66zbw@mail.gmail.com>
 <8d2e20842c24460296e4c83e6dc0dde3@xiaomi.com> <CAEf4BzYQvhSVN=Hggg5FHzFdkRr4UNBD6yXaBsOaAwbsRpXpsw@mail.gmail.com>
 <aqSNkbhIuaB5D0H0@google.com>
In-Reply-To: <aqSNkbhIuaB5D0H0@google.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 11 Sep 2026 17:04:55 -0700
X-Gm-Features: AcwNN1UEr63Wxp7MKqMET22sJl2gNoghCd52hruir0AgkgtHxzDzVIaVqxthCq8
Message-ID: <CAEf4BzbAOgwQqsRQnY4yxvubLtioQNL_BBHer4ExvNF7Rvvu4w@mail.gmail.com>
Subject: Re: [External Mail]Re: [RFC] bpf: account ring buffer backing pages
 separately from Lost RAM
To: Isaac Manjarres <isaacmanjarres@google.com>
Cc: =?UTF-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Xiang Gao <gxxa03070307@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrew Morton <akpm@linux-foundation.org>, 
	=?UTF-8?B?5Y2w6Zev?= <yinchuang1@xiaomi.com>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A6AB40006
X-Stat-Signature: mdeqiubxpxgybfiix61i7oopqajjtncp
X-Rspam-User: 
X-HE-Tag: 1789171508-382079
X-HE-Meta: U2FsdGVkX1/oR2LH5blOSqytylPf2yMuWAelBGspJ7g6zPVADWiQ3L1wO58yekI+kq+/EGlfmheHW6ddDKnjpfOWUmlk3zMPgz893fBdQfyEcN8OzOQBIn1WTIGD3381NhtzK0E0kbE4LQRu6JQw5eCcZARPayGCedHsmCnddYwqKPa/l28B+z0UxScH2TuByOLm2KSftrxTv1UUb+e58dQcWbz09mEgldqUVB9BewOY5KccGt9Ja1aVnSNqkjsZmUAdnWSpuTlW36i/bMf4vGdu2FKoZfxj7cI6ULnCddGHKB2rJ10O7o5gxhYRAD+KVra35E3R1igJCPyhdKyj2eXztH0qOKjgx21vIKnDU128tJ2w4llt/wd11zVXq9r6neT9iwxRViNaMKj65a0aaYMhqnhZBfw42XqImZFTBa7l5Ymx4JpDGw1eZHbZcQMJQmdE0fZYYb8vbZmdI6xIl5HKYynQqI2fnT6lhn1KfRoRtC2VmAdOb5ctkK6/Bk+781tpkEdsEpuzXjb/CCwYmJ/MPCAhTKvyCf77uVWdK8CfJ3doEhkr+zmDBre2mLJd8eH+pGVAClb25JAIXfNtfHnkKpADamOANMLuloWG4q+lpt4cM1Ex/JQiv21c6rB/q4/GluWaIYkXxQE6C0+Q8w4nBsrgSn+2L/vBWxdjzCdCy9CAIz0VhjfZdvaPASzCeCsWuZURzMO6t+XmGrU4GPab6pQqf0SPK90t+79afRTg/vQo0lczM4JcuACowUDMHl05zDVfC1LrV5aHusEjRUi0fsUdrjyPj5Im2WaZi9cGJ5ZAZGLloMzBKJMwzz5WHHvjLgy1mXfbnZyV6LqEyjnEWUB09NG3Q6cFaEYAOx6+roldiRuOohTzg3LbZ04MQVo+NPLvqaqtEwKaCPmnUnHP1PKgpcD4z77ALxJOMJ71ca3ULFMYQo9u2voDqr7EkdVdQUJoi4LhGnb3ipA
 Urr0Sgrf
 uJiTwHVQQNdthFBmFYQVvKyfh0QF5BZoZqa5muWxHZujUh74eObqOz1hobBqJrpaGYtteA+oLqMsg7PzFJ5Fn7aqybh/hgnKUNHlWQa7b90zCLGsabTIVlvW3vkGs0sY1M4cyXyZni2o1TqcHxXzfDxqVxptGeKc7hUu3wcbHumlI1B7Gg5V95adABQ3Yl2EbwG9EbF1UmS/fwBEmQ3OlnF4wlamIPAO0JTWohxYLesxbRLQs83CcQ1cvLN+lLilwCmEV8EBFGe9M9l1fIbTKRRQAbCd5xrfS+V6DrXiSRZ/Wi5uwKUqiHjXyjgl32xxX5Bncr7WgHopwtrwgGGlkmBoghaBgrfsDc/SirSvb9c/P04ZM3qQmKw4ESUSAJNNSHrELqCfuiI2H+n8z2hdw3Le/fRAkIT/DM6154He3bpAWTGbbh9JJBqMl8MXozknpNzxKqeMSKk58A6BCOcOvNivYnyUaimXUqNlGTDuzgY/TEBsXelQ5290hO94RQyjOLfTLDqLIn2ek+q2jNeNhMiBwCaGdahZU3XZjuzfRXLxia/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 4:24=E2=80=AFPM Isaac Manjarres
<isaacmanjarres@google.com> wrote:
>
> On Wed, Aug 19, 2026 at 10:24:28AM -0700, Andrii Nakryiko wrote:
> > On Tue, Aug 18, 2026 at 6:46=E2=80=AFAM =E9=AB=98=E7=BF=94 <gaoxiang17@=
xiaomi.com> wrote:
> > >
> > > Thanks for the pointer. Understood =E2=80=94 no new NR_* counter or
> > > /proc/meminfo entry.
> > >
> > >
> > > The remaining question is on the consumer side: Android's Lost RAM
> > > accounting would need to enumerate all live BPF ringbuf maps
> > > (BPF_MAP_GET_NEXT_ID) and read each map's fdinfo memlock to sum them.
> > >
> >
> > For BPF ringbufs specifically, you should be fine just iterating all
> > map with BPF_MAP_GET_NEXT_ID, getting its FD with
> > BPF_BTF_GET_FD_BY_ID, and then passing that fd to
> > BPF_OBJ_GET_INFO_BY_FD to get map's size.
> >
> Hi Andrii,
>
> Thanks for the suggestion on this! I did want to express a couple of
> concerns with this:
>
> Scalability
>
> I counted the number of maps on one of our devices, and there are 112
> maps, meaning that there will be between 224-336 syscalls with this
> approach. eBPF is becoming more popular, so I'm concerned about how well
> this will scale, if we have to invoke 2-3 syscalls per map.
>
> I had a test program that implemented your suggestion, and it took about
> 2 ms to identify 39/112 ringbufs. As the number of maps in the system
> grows, I'm concerned that the latency associated with computing the
> memory usage from ringbufs will become even more expensive. This is
> something we had an issue with before on Android, where we had to
> iterate through various sysfs files to gather wakeupsource metrics [1].
>
> To improve on this, I was wondering if we could expose the ringbuf
> memory usage and potentially other bpf stats through bpffs
> (/sys/fs/bpf/stats)? This counter could be a lightweight counter that is
> incremented/decremented on ringbuf allocation/freeing so that when it is
> read, there aren't any expensive computations.
>
> For this specific metric, we could just use a counter to track how much
> memory is being used by ringbufs and have userspace read that. That also
> brings me to my next point.
>

I just don't see a good enough reason to single out ringbuf maps
specifically. other map types also use memory, why would they be
excluded?

If you are worried about too many syscalls, look into map iterator
program types (grep for SEC("iter/bpf_map") in selftests). That will
be super fast and way more generic than what you propose. You can ping
such program in bpffs and that will be you custom /sys/fs/bpf/stats
implementation that you have full control and customizability of

> Correctness
>
> The max_entries value is the size of the data in the ringbufs.
> However, it doesn't capture the 3 metadata pages associated with each
> ringbuf, which leaves a gap of ~468 KB, and that gap can keep growing
> as the number of ringbufs increases. It's important to have as much
> information as to where memory is being allocated to, as there are
> devices with as little as 2 GB of memory that we need to be able to
> profile memory usage with.
>
> I think exposing the sum of ringbuf data + metadata pages through the
> node I proposed earlier would help achieve this.
>
> [1] https://lore.kernel.org/all/20260511174559.659782-1-wusamuel@google.c=
om/
>
> Thanks,
> Isaac

