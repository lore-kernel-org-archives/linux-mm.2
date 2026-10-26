Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C34606A332
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kdrhsCv8
Received: by kanga.kvack.org (Postfix)
	id 7E4C66B05B0; Mon, 26 Oct 2026 19:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795476B05B1; Mon, 26 Oct 2026 19:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683CB6B05B2; Mon, 26 Oct 2026 19:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 358286B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:52:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3CEAA091F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:52:11 +0000 (UTC)
X-FDA: 85366428462.18.1B19F30
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E6561A0008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:52:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kdrhsCv8;
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793058729;
	b=RlAVLJwkXAH64D1eBaXNb76XirT9mISEFXmHNv1t2CMn6jVrqQMxw/3aPfx+KwGm0g9Gj5
	mkNF1aV0THK6AhWivYmeD1KpglzuxoKuOApF1kUGc+IpZx3v2uFLmgVnd6oI8YO2Ap3GoU
	BQP15h86HXqoIAyAsyINWUXu5uFsmjU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kdrhsCv8;
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793058729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
	b=oKoi/GhKKXXWOYSW5GsBe/EZvnMMkGnDb54h7d7xq9GDFvk/uGzEF2Jdo9peBV3zHDb9WZ
	0+jtRBusSOHZ5/ZBY8PBLG/9PL2KOP9LyZC89ecEXKK+m2SkX6aYZaWPh742dg+eKDD3cN
	iSGW6vJBo3XNWm+Pu0Hp8Ux/XJs2o3o=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4322d310e7so528651866b.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793058728; cv=none;
        d=google.com; s=arc-20260327;
        b=eBHOUu+WjfRkFYlFWo56wLgMWfNv/Sp9AFy6MSirCKzA/SD0VjR5vQFRbrzfddkIMM
         I/By7VO48JLf9RWtJmWKsutdS3OKSeU0UKtTD3QTwaHd4tudKZC3DAvIsYx3kNjzTf5F
         kZ6VoNYCUkNgzCs62MWH+HL8nNbSwKHHqKPIlrbxmwlhbPmGELrXhKZjO03smlFN38IU
         vwygagnDxw75N1Hlc+QWmUXt8UHjt9H6Q/Lk/3LZKk4ylWpyq/X8vDBGP0n5fAWWqROF
         BmhDSeomCs50E0B5j6G7lM0/w2FKn6p0SEtCQtA4KCbi5nHSrUMLkt4VN1XjY0sInDPs
         87jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        fh=w5aLCRE2Zpp/oqi+zNXBBHNI1fPevFaUVHzagCt1DTM=;
        b=szJSfGVKPsg/chaIDziBbAjIthZk1I9zZkgHP+FfAXlICCt87RPI78CCuuKkIsrpUx
         0lbyThMGVjfwyuuCFEBTWrtxyMKodzVA/Bby9HeYQT3ibuOFwvsIThj7ZPC++VPf+Kew
         T7jbgTZDlISgT+l7ijRO0hDgo9T8pUG3b+PNLnH5IARfx0IBMS9/lSksHb4dD9ELODLf
         yTTKGDbJVsweZrQbWW9bqZ85+sYu52J2R0IgGrm1VaNc+bGtQ5vGc8S++2R4F92Ax3ml
         pdyiYjc5NJPVj7QfFkdBXLOwAFDOTZDmGr+2lR3Ga2x5iadGDa8fNplZ0BP/C8b2jm5m
         i8Fg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793058728; x=1793663528; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        b=kdrhsCv8lFEl3RI4Oukxcu32dgDOuPtrV9JMXv8JvANpBwDrQoJYMplwGc5I6ejgHy
         GWsXuLhWxzoxFpFaNkDoQdCZ+1NBDrfYthS9Rba1OUUM2cRkyMmHMx3mVyX/NDBe0bkt
         pyGZim4nhYZEVZvQ2fnu3P3ZKVkVlO6N1rvZo8X5+LoON6JN9IgMmP+L2PNneBDwagP+
         VP5C/JHy7IGNcp+RyDkHQonOMOrphqUfjetHVWD983mF5U8BUPcWdtkVH7lHWk9PuqVK
         l7OGp0RGKS176G08eznFalLsEBWu+5l2dDL1Ygt5BZbXeV7o4SW83poQFzT+173aBG6j
         YWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793058728; x=1793663528;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        b=SCPZ7P+e8L7OI+YZBKUMZ/SRLiOBwibBfXi6WOjdj7nBIGZWt4Zq+n4y6fpufkI0er
         JaxeTdSw8BA4KfbaXSdkWIj1HoCndNM66oCpInf3qsvaudpGr9S6he4OwXNOnX/UNKJM
         Ct8z8qOmAPEKdCGEaOCOhhnnvi4S3uG0xjC5sAiGiR2IQZnfiwVPqhJXvmaRtXCr+NLO
         zMug6AeklOhMStTeckkrkairCRRL/nPGggsfkCjE2S7BC6bKcHUl9lbgpfvcv7VBrQnY
         +LMWgOk/l7wVuYWpSA7bkB5jFTi/+txzBCsb0lD3WdGXzKWdTDdSwZc9zGjd3WYCnQu1
         Wcdw==
X-Forwarded-Encrypted: i=1; AKwUvBxA/q3kd2smO4EGgfVfADmB3mJ1C4z9LvQvy0JsI11Ud7fU2UtI2ZLJrtjqkQTVv8fcOCS5StP89A==@kvack.org
X-Gm-Message-State: AFq9FYLqkz6GT63BI8QKYnMh+xWpG7YNlxP143fZfKHiAmFk2TXAe1TB
	CMaj07OcYbLVK0MOmLD38gFojkCNIqFLNJDcgSFSvu22vFa9rwDVh2jmAFjsjPRTYdFdUAPgQCD
	ib2s3cAc+sqyxb/0rEWNwW5yyyzK/Rh1vaAQnbv6+
X-Gm-Gg: AYBFou3o4DSlz4p4CkEbbVv9ZpmeFzkwGFw7M6i6MxPf3Nx/YoF6lYOfeGuN4FiO7/m
	ifhvlny/J5c++SvcF6QlphsS7HlSqnlah1ibsnl2iynkiCvxVGAN9uYpWm8dfnj91crTWplkZTJ
	4IQcvh2wB+73QGKyujrOa/W9KLIvDxit7P6dsAwk26UzdEC5s9/8y9OilCHsvCLLam5hHdn2NyO
	fxWepd7lCzmTARGrtX54ZfknERP5RDrMcszKNc+fABJlnnTO4NGxcxPjtlLZjy7nyJsRb89QkVa
	/NNfH1tkszYk2GYjzqgo1S2ICosbR3oeli+R8jvexRspw+K52fMZhBNJFGPpvff3Z2fOZJICyP8
	MKCFYIxvqPSwVW3QWkN5AGFadGq+v1BNk6ajRiEIK1We0nGDXawVbuSKiT6ufX3kCQr/zQpDo8i
	qkdp+6R9l3dN0zkWUow07zkcvqWbh5wgpbRe8w4rLeRg/dAfTKkN7Imp2Zja5kl8XNDXXHkFRzD
	nm1G1bChQ==
X-Received: by 2002:a17:907:80c:b0:c46:6a50:40c2 with SMTP id
 a640c23a62f3a-c46bdee2675mr943075666b.39.1793058727681; Mon, 26 Oct 2026
 16:52:07 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-11-jthoughton@google.com> <3b0a8fc4-d140-4a90-b810-cbc1283fc083@app.fastmail.com>
In-Reply-To: <3b0a8fc4-d140-4a90-b810-cbc1283fc083@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 16:51:31 -0700
X-Gm-Features: AclHuK-Nhf6TYTDNWSq0v6hReecRKBdo5ExoV8oZWGVCIO9BK-126Jv082Kq0QQ
Message-ID: <CADrL8HUZ3t8RdMEeBPfqsy1_1rN0Ty9B2c4iP6OzNS12te6vOg@mail.gmail.com>
Subject: Re: [RFC PATCH 10/10] uaccess: Move the NULL mm warning out of line
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E6561A0008
X-Stat-Signature: xrfaxgxeat9w9d48p6gxn9hz1wdbnsbq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793058729-382639
X-HE-Meta: U2FsdGVkX1+KG81VEe7b6cDRkJCY9w41526nzw7J0Z8I6rz3gu9x4ZxwaauqETs7V7rNG/OymyE3c9bsQUWLPWdFLkCdONAZoxt38j5fHcVEUQhmq+vNE6+GIkySbEABMQJY1Nb5uKYf2ARsK1ygd+GkEC7sIDOya8V2l9yCZSRgN8094RtPNe8xjzp64FDkqHZVk92hMv/EF0QWU+4KskX+jPLTxmKZYbWsD9dQe7i3o2IbxWKdnHz/f/+oHfWy1ZG7SvTTRCYwfnrPKSAt19HKkFnpUD+LrTcKfn+ooo+BOQq8QjBvVFaxMGR/ED4oSSxesPs5ChLqKkpvt5EcggTk5NN+HyZg7svAca8v9zzo0AABfLbJD8UVxBE8z+RZkOSgBs1mcOAc0fx9Q6ZXu35Eeejyf0FsQes4VdWtVBJ8RD3okJc6X6U4NcXZUgbuF2Y2gKWCaOXspPNhQl+KANKfTPHUjpi5ejF/hmbkvL6VQS5/ehYcNB7+SVBe9rd6Fov3U6UVMoLRqXqTpICMPUaI99jysBplO8uHktNlMM2YMrq50k1HmPiKxXa2ang8wk4p3xPnFn8VNE+npWtnnDw1DUH8HesO6euvwAPNuexkqIAYGjQPf4YFwbLmWF9KjH6C15AsaO0usxeEPoegSzaGSe1zxrHe3xKZS/qsjBXfwTJW84GTH5C73zRX6uli9ThE7n7ixGFFZiYO6mWH9sQReOmrUHNADCXAPefe9SZoGQ51X9+maVLiXToqXcQd6u9mrYVfiQR1hPNrhHlYngaQwZ6Vhvhwfv96/Cw6ilL/5bUeLZA1HiP0ttign1zr/2MfC+o/bQ/jmFJp3G9axSgT5tboOKuJePUCnzddoPBjZ0xgtSZi+sjRKVIae/l82bsXdUGm6dkTBaEsKH2rRmdTdIog+nV20O5ZxRTcnAabF6ZPDQizU3Vmr3RPSnLyEYZNzFp/U00QVgYkGVY
 G+sz1bz6
 TQ9VmW1gsVwujmQvPdvtjjEvf3g/qDTWFWm/vXTBL/5ajuC4wLiV3doVaFTFI5fZFiQceXv0KH/eCkGNpQF5ICLdt6VX1gnn55LgyFfJ4jK/w0kar00saCEG5O/gyGSnVNP+Li7eaT0ePUVAi1lvznloLDGBFoy46wIm3otdzXoqROWLtevg/qGo2LReefKE4z5W7iaGgLFWUUNQhFwg+kMZJR1pv/xtWs6sf1KGhppERiQ6q+AaYIxtVNAGYWMQr3KLdC9dExa1HOVe67kq34HBsS0XIzMXlcBTGSEauF2uzSMQhgLaRxMfBcXPK0cIthlevIXX4fKdrOEwAYpavxmS28w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 4:03=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
> > uaccess_without_mm() is inlined into every user copy, including every
> > copy_{to,from}_user() call site on architectures that define
> > INLINE_COPY_USER, such as arm64. Each inlined WARN_ON_ONCE() adds its
> > own __bug_table entry.
> >
> > Keep the NULL current->mm check inline, but move the warning into a
> > single out-of-line, __cold function, uaccess_warn_without_mm().
> >
> > The trade-off is that only the first offending access in the system
> > warns, rather than the first one from each call site. The stack trace
> > still identifies the caller, and the access is refused either way.
> >
> > Compared to the base of this series, with defconfig + KVM:
> >
> >                      inline WARN_ON_ONCE()    out-of-line warning
> >   x86_64 total       +5,884 B (+0.014%)       +9,714 B (+0.023%)
> >   arm64  total      +40,948 B (+0.10%)       +24,609 B (+0.06%)
> >
> > On arm64, this removes the ~16 KB of __bug_table growth, while text
> > size is unchanged, as a call is the same size as the inline brk. On
> > x86_64, the call is larger than the inline ud2 and causes more .cold
> > splitting, so this is a slight regression.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > NOTE: This patch is included for reference only, to show the cost of th=
e
> >       inline warning.
>
> I would suspect that the growth is larger on architectures that
> don't implement __WARN_FLAGS() but rely on the generic WARN_ON().
>
> This would mainly affect 32-bit arm and mips machines, some of which
> are very memory limited, most of the 64-bit architectures have it.

Thanks, Arnd! I ran some build tests on 32-bit arm and mips:

arm (multi_v7_defconfig):
 - base: 31,913,726 B
 - patches 1-9: +64,816 B (+0.20%)
 - patches 1-10: +23,193 B (+0.07%)

mips (malta_defconfig):
 - base: 11,830,177 B
 - patches 1-9: +61,168 B (+0.52%)
 - patches 1-10: +25,881 B (+0.22%)

I think it makes sense to include patch 10 with these results; cutting
>50% of the size increase for arm and mips seems worth the trade-off
of only WARNing on the violating callstack. Let me know what you
think.

Is the increase even with patch 10 too much for mips or arm? I can add
a Kconfig in that case.

