Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28593C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 20:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25F06B0088; Mon, 14 Sep 2026 16:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED68C6B008C; Mon, 14 Sep 2026 16:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4E56B0092; Mon, 14 Sep 2026 16:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A55226B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:29:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B5111A0251
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:29:17 +0000 (UTC)
X-FDA: 85213507554.12.A72E849
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id B470640005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:29:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hnhX/uo8";
	spf=pass (imf01.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789417755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1RB04FVKilnMj3CUMQjbhrQYe/qiVYK3aULFxVnZe0=;
	b=Cq0zHqpKv7LY2Rvy8BOGlZZauCf6DjnznTwzQC+H3zjrRN3ok0PbbO34zl4Da45FfcFMVI
	WB/kT45ntCnPEye5NVT0MV1UeEezneX5HCx9eobe7E+MJmOSMm3LInguCzAINrk/P/Unfk
	3Q1Kv54uzVzLSWxv7oZkp0oKTfYuIiE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hnhX/uo8";
	spf=pass (imf01.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789417755;
	b=GO2iCuzAfE+RYdeCDGiIWcISS4Xf6QoH/4fXZObBcGey569zLNP40AOl/z1khv08nmD1TE
	lgDuZ/0+foViZKqx/Xn4AkMT22enDjiL+AO27UFtpHSMSlz6unMCZXVL6LvpnV9SLJVaiT
	aPKNKrYrkj4N1PzWfdoScS2Szz173ao=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db425c9050so195825ad.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789417754; x=1790022554; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M1RB04FVKilnMj3CUMQjbhrQYe/qiVYK3aULFxVnZe0=;
        b=hnhX/uo8/2sMBTGPzFAWmMy2OdLIuZc3MvQdRcKf1+v0CLU51cgdrs0NWaZmi2AOZy
         995/wPxeIE61t/UL1Kw7j7H+tGe5tpociboaqud0Vnm5COLbf2xu+xcPnMhlSc6araqQ
         yiagVjU+5oebbthAvpZoTxVWGMDUO+1UgXInBD+UBr31Im7I8JRNODrO/Pw87WFdNqa+
         iXpkqPiUuyxxlN68K9I+fulL0DpkFhP0v7ERwAhpzlTiOTpxX1hbdTfXV2OdPAcwn3/+
         MYtqP4IjyPMP4gQVJDNLmgpOPNoioLfoAkpbUoTTPTyL8Sn+W0pHFuQ0vm8d2VwfpT+w
         R71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789417754; x=1790022554;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=M1RB04FVKilnMj3CUMQjbhrQYe/qiVYK3aULFxVnZe0=;
        b=CVG3uPaPU7DAA1+jVyLIJgWhX/q6ueEV3A1WZbeGdgMdrE0/1sHFSaFXtfPKlS7uuO
         OsZe6sMDZD+II+Q881EWI+MQ5hiKP+04aUqB2BoxEaBD+iJ0CQsWfi3Cr0DMzDqXq75w
         35xtAi5K/jqHjq5qUQc6BKPwfsJ4ElOCkUyAI9KODZb9KoNPy3RvMR73zQRfZ/+gjAmX
         lfui1lnW3lIk6aHX0GvmioRNp17QJEGhGARa01WZG1/biHbowNs/QXJX+yzWWaQ/w56V
         +IcTz/VkcnoW3DHqG4xuQC5J4lxj6Pm54cgZarTfEEcMVC/zMm33fcQeT2A/pVGYOlOw
         bETg==
X-Forwarded-Encrypted: i=1; AKwUvBwhctIkn2sOlWSdFaeA4yYfte/YU4Em7iuBDrcWilly7Du7jnfE1LrFUX8ru5aVZw6rJKYQcMFOHw==@kvack.org
X-Gm-Message-State: AFuF++kTG76eawIYUyL8955u94r9fNLhr1rfYK7q9n1/lBr6BWSyV0gT
	YzePlOfju08D3n8B4JfM2inY31WD2ncllmqjzK7PMWGNp0CwhI/d2D/3m8xaz7MJKw==
X-Gm-Gg: AYBFou1wy62VrGPeM7iK0UV2+RUiuy4CBewCFmyCn7nUTanhCTdCtQnPVEK4IOyP6R2
	da/m0eyPrmBeI+Io8vY0/P6OzozojvGiNHMSSWzKQxxs8cTckdySH/QpBc9qPhQbVuZNAdpgdHs
	vR/VzlZ2/GBtI1AlDay1vxMA5HxrKVac7je3kxpUIkSZEIJ9tSwkLfgfBI5rO0cPqIpadJ7Cm/z
	Hlk3rej1/egHONfqfxpx07Tmz3GtsPaadcO29DNIwTdaDoUaZaaHZqEIkmOxStZll1+cZHr3g+z
	9uv/ehRb3qy+v02ECL8C7dTdGBoX9GrccBixCWlQ9+0zJYfhoH8+nhTu3EBZzRKxXtcBrKQBwSw
	tlbozmriuIwkhfII3G2REWW+tV+mfGfAT97HGYhxXfpD20Q7SiXoIB3U89N34bBxUtJT2iIrY2j
	UgPum2O/JQhkrHNqH9MdEkGTrCNA2Qov5w6hWSeMmtBNZwoEph5GSXQ+0mv8C4NuwqBPVNXkxMf
	OpeY1ZO93X2ta0dvopB94f1EnGHpbZxUiWQzg==
X-Received: by 2002:a17:903:1b63:b0:2d5:cad1:a2e8 with SMTP id d9443c01a7336-2dd76b014dcmr2269015ad.6.1789417754079;
        Mon, 14 Sep 2026 13:29:14 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:9e:b709:96a2:f1d6])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b348cbsm27582654c88.3.2026.09.14.13.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:29:12 -0700 (PDT)
Date: Mon, 14 Sep 2026 13:29:06 -0700
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: =?utf-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Xiang Gao <gxxa03070307@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?utf-8?B?5Y2w6Zev?= <yinchuang1@xiaomi.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [External Mail]Re: [RFC] bpf: account ring buffer backing pages
 separately from Lost RAM
Message-ID: <aqhZEuQTu394hYB6@google.com>
References: <20260815091819.3651099-1-gaoxiang17@xiaomi.com>
 <04f3ce2f-67f5-4829-9551-a69b9df29854@kernel.org>
 <CAEf4BzbwZkoacX-iP1j4+p8YNbWsq0pc3eTermh2uT5ir66zbw@mail.gmail.com>
 <8d2e20842c24460296e4c83e6dc0dde3@xiaomi.com>
 <CAEf4BzYQvhSVN=Hggg5FHzFdkRr4UNBD6yXaBsOaAwbsRpXpsw@mail.gmail.com>
 <aqSNkbhIuaB5D0H0@google.com>
 <CAEf4BzbAOgwQqsRQnY4yxvubLtioQNL_BBHer4ExvNF7Rvvu4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzbAOgwQqsRQnY4yxvubLtioQNL_BBHer4ExvNF7Rvvu4w@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B470640005
X-Stat-Signature: 4bsj38ji881b3wbhj5hd4qy64abkbynt
X-Rspam-User: 
X-HE-Tag: 1789417755-504508
X-HE-Meta: U2FsdGVkX18s846j5TdHgY7ch+lRaaQnKoUhcj+Y83i4tCW3zucQRkT9lePcPXR+t8fJ1KwcyKdA7w4ak7BHF3sfCc4F+WrCFu8XPQ/5bAPETpnEfbknKocIecZeuBXL2J0fymB6k0xo/mg4ggkfXUe2G1Hx2gtb3cmxHIlbNiXeGFn81O4MidVpZ7FIcIS66Uko47A/w/GO3m5siFxU42qKFf4bfr+uR52pa+5v0K7oSZ/U5JJUFJN56nyIjMPF52Ig3pTzO5QKCtxh5+PhTcL3XsICSLVwCFXc/C1FlUf/AE+lDwuZiStWkAwVYXRz7wx809+sNXVl9tvVn2kGQJNZ3eV70YVcujQaFeixF4tfjO9sJqOE0qTIpWCE22N3pbgq00rebkFqn7veUZOzp01arAALl/MDCbUguY6/3xxLO+CISpYQu8li4HBllKHAX9Zs8GucTD6p7t9rt5Ntrp1ohrYt45F/R6BAY2v5Ih9qySdui/aPR4vQp4Nxbx/0toA7wboAoPbj7KmVyqnsyBr0BLcuRcPfK00okc0oOisskEGbIN/yfz21DUKh7puK2G16Qu47wuFfagZ4yrhct5c74YqkAUJ+NbsKlqYffl87fvo7fF3IWgZ6VMEjPGa+G46GxpjGP2No6xLZUeP9JBh7TDJ0daCjSNUuNeVDvhEcKlJNj11I/346LRP0OBz/QgE3fdbR0B1qGQUllHQ2b0wdR9cdnS/KoJ0PIsXx10J6MMcZieCloWVFNeq5A5/V7xHlQASGWO2ZbdiEPnZPEH9vzP/ZW5QaRYtyZln1QaJN/S36EhGQFBBc4464Yi0B3Navu1Mm/AYnz7RKH0Dj+OaEK107LnGCoe9awDCvZH1Giu4Dm9kNXnejlT4X8d3DhtYv5Kdcl+IZSMk8ac6MZOXpAMcCIwJnQq1PFjUCLzm3DaaDCvvoXR1JMoy0L0XJIp5WrzDB3cLHCviUDv0
 8ubRRfVM
 kR6LM/tyJT/oCQH6fDKFBEDj+qXR2JtcWScOfWeYL8yhyWW4gKyE+1Lg7pkEee3VA163o4wo+8MFlv4P7KkRfwcqjwrMxpEfKAXBBMsa/tQZKV0zD4xqGrMje9zIqiXhCqYP4ELVq5K5/Z9Vv0m31BVVS7FZv91D0UrrEUr1mqyYxKgheUwS+zQ5X0OMxAXo3Jsk+siBzFaMkrAlKPfaOC45Gim7BlZryLgi5QvCwyPCG+nAgzJrHtdN6tdYJvmbdqii3yPq896xhWl23UjpNdy+oHNFo9KBk/kHCjehfTpyTcnWfiaVhBhjvQO/UwA74xR5R2zu6CQjyuMCdpYvFtk+VLeN027UzYX29ThetQV/nSeM9Y67gXx8+VWpnqM6SrLc20eiUaTfGkckG4rfm2IkIWW4ty5XBkBAICLV4ZmhPSD/hHcZF4i59I2Oj6zTtHSo45kQlZTKNOieu+T0tgYcl+cVdA73B+dT+XvHf7/mrPm7Re28oQ2IUONwEfw0mqbck26Xo/9T08oQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 05:04:55PM -0700, Andrii Nakryiko wrote:
> On Fri, Sep 11, 2026 at 4:24 PM Isaac Manjarres
> <isaacmanjarres@google.com> wrote:
> >
> > On Wed, Aug 19, 2026 at 10:24:28AM -0700, Andrii Nakryiko wrote:
> > > On Tue, Aug 18, 2026 at 6:46 AM 高翔 <gaoxiang17@xiaomi.com> wrote:
> > > >
> > > > Thanks for the pointer. Understood — no new NR_* counter or
> > > > /proc/meminfo entry.
> > > >
> > > >
> > > > The remaining question is on the consumer side: Android's Lost RAM
> > > > accounting would need to enumerate all live BPF ringbuf maps
> > > > (BPF_MAP_GET_NEXT_ID) and read each map's fdinfo memlock to sum them.
> > > >
> > >
> > > For BPF ringbufs specifically, you should be fine just iterating all
> > > map with BPF_MAP_GET_NEXT_ID, getting its FD with
> > > BPF_BTF_GET_FD_BY_ID, and then passing that fd to
> > > BPF_OBJ_GET_INFO_BY_FD to get map's size.
> > >
> > Hi Andrii,
> >
> > Thanks for the suggestion on this! I did want to express a couple of
> > concerns with this:
> >
> > Scalability
> >
> > I counted the number of maps on one of our devices, and there are 112
> > maps, meaning that there will be between 224-336 syscalls with this
> > approach. eBPF is becoming more popular, so I'm concerned about how well
> > this will scale, if we have to invoke 2-3 syscalls per map.
> >
> > I had a test program that implemented your suggestion, and it took about
> > 2 ms to identify 39/112 ringbufs. As the number of maps in the system
> > grows, I'm concerned that the latency associated with computing the
> > memory usage from ringbufs will become even more expensive. This is
> > something we had an issue with before on Android, where we had to
> > iterate through various sysfs files to gather wakeupsource metrics [1].
> >
> > To improve on this, I was wondering if we could expose the ringbuf
> > memory usage and potentially other bpf stats through bpffs
> > (/sys/fs/bpf/stats)? This counter could be a lightweight counter that is
> > incremented/decremented on ringbuf allocation/freeing so that when it is
> > read, there aren't any expensive computations.
> >
> > For this specific metric, we could just use a counter to track how much
> > memory is being used by ringbufs and have userspace read that. That also
> > brings me to my next point.
> >
> 
> I just don't see a good enough reason to single out ringbuf maps
> specifically. other map types also use memory, why would they be
> excluded?

I was looking at ringbuf maps specifically because they allocate memory
for the ringbuf via alloc_pages() and aren't attributed to any counter
that is exposed to userspace. The other maps use either the slab
allocator or vmalloc() to allocate memory, and those entries are visible
via /proc/meminfo.

> If you are worried about too many syscalls, look into map iterator
> program types (grep for SEC("iter/bpf_map") in selftests). That will
> be super fast and way more generic than what you propose. You can ping
> such program in bpffs and that will be you custom /sys/fs/bpf/stats
> implementation that you have full control and customizability of
> 

Thanks for the suggestion; I'll look into this and let you know if I
have any questions!

--Isaac

