Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC66606A337
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cMM7J4Vm
Received: by kanga.kvack.org (Postfix)
	id 205036B0A81; Wed, 25 Nov 2026 11:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5636B0A83; Wed, 25 Nov 2026 11:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0836B0A84; Wed, 25 Nov 2026 11:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF5AD6B0A81
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:44:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68AAC140F92
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:44:17 +0000 (UTC)
X-FDA: 85474214154.16.7288A47
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E95714000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:44:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cMM7J4Vm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795625055;
	b=4sT6a9voAiak53AVNz9kdIKW8qnWOzmOof3ODEQ4U9eBZqIcmOSucYkJnbhe9FGy5YJ2Qq
	7Zqsnnviqc44mr/KK2c4gdh9Bujz3rR44mBBdP1cpEW+S7Sm7/GhCKVGo8+PN/8u27Y1xp
	RSZIwo4qpay9h9w3Ooq85dkZLMHpSwo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795625055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
	b=HzvplXq6wcUi4IQNszLoNo+BnDIoLAmDMrTZfdD/lRTTKyKJjOYrFCxJbXMs1ZphTrCFct
	ADKM3tKbb2LOkpYfZatFyXQyzz+XPeSMLI3PvsWU7LoqMZDP6Z/x9ZmdURwwyJGJ+Kh5bI
	HnWyr5x2VsWQhdlmUYHiVF5q8AEL3xk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cMM7J4Vm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jthoughton@google.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c516a194350so84722566b.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795625054; cv=none;
        d=google.com; s=arc-20260327;
        b=M131Yn8DEvvkNe9i9CWsbmJXm4RLzzUnVEpXgPND4fuLeYgYZlatUWESeiYpslY9yB
         G6HOLCBqLKr8zeBGFRudUSxxF63bFg4DFDhK7zSpGdihygA9wgN3yFRPR9MnfOJRbYXs
         ODVrV15OSSWjpguix0y4K3h8aiS3O/SbS+TkLvZkGRzG6rWqAx7K3QHNl27TJQcSC1ZL
         w7eDCURZOnIHHSw+3C8IRLPNXetMyQ1VchCbhFocuLx14q2VmpOjpy3RvVRc5DC2yqXC
         p+Rcq231BVNYYQ6nyRhCwxVdfU5nimt+BcXUCY8njCoGKsi8+APJGzI9fckZ3KYFByHp
         lxKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        fh=191aYopQaVX5fArju1am0dll4gfKVPJAE3U4kFbQtEk=;
        b=AVV94Nm/0dTyE8wtARhC9TOzXF/SDjsB/BrxKZparHhAdSTDyVobnVu/tqgl18SMnX
         7FNPwzaYIGfzl+nL07A1u4q14cs4QJwOE+v35k06XHzKm0JUTZ+jM88D3C7l4VMHumpt
         yZwoWbq5I9dokLSTHcbCajdm8m8HjmRy0y02lW7I9WkujCwoPzqmQ+7QpSl/kM46LQhK
         AgtsncQGbvzciK6D73xETXZHxIKlvDfNmCT27I0yakjECy1lOoBqupWTK6rM6Th83WVe
         wkM2jrXy15CJByZ6oZbgi+TjzZBTg5pZH1Au0Rzs8FyZus1bKxsEIR3kY2f6UfLSqH+Y
         u+9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795625054; x=1796229854; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        b=cMM7J4VmtOxUdt0DQOXGVDcd5+Fok2sA/gnR5QDbyMeKHWFngaQSovMewt/YF2x8cJ
         c9HDeSy+Ie5XSIHMDRvyZ2MAAalyFXrIvpy/YxcCFEe8eIFBsZVmHsGAegHQkw/GRyTg
         dxqY6PL/H+wLXmPGYZXCg/nSe+6eUm6yB2MkeKSMyTC9wXta3BYJWD2iEWR8J+etstve
         kO0RtN7lbjHL002IIxOnWAYelPjpIyQjoqTWIlyzDXVkeALyso4u+vxVVBSQjRI0kW+d
         7GLpGM5EmlgcuoFObQApbsw0WPj+m4HOKAXTGT0q5Jq6242x/B52h/LvUGY/DWyE3nlc
         lDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795625054; x=1796229854;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        b=SQE/Y7TbXQiVWS0WVmpiCRy22HbWe/XEANpPHbWz2YIKpVlNLUYlU070M7DS5kXtbO
         EDTNJE0rTRhyrUHW+ugAKPRdsgtssQPKqi8U50kgL4C0KUQlENfQcOD0tPl8jXpfT/te
         V0yWAO7ZzuqwPTAnRfaHeSkqYONoAsKTa3VUmz0SZ5URRoBG9ax96j8Buvqk7hEQsef2
         hfEwP31VPxZ2cWobshsM7RRTJCD7C+cMXrGU/oGUCWTuGduryI34LGriBaD30WfqYZPZ
         W98AuOnQPIzuy8979uLuYxVTWdfrFfpsG1f8XvQ/cz71nY5pUKolh69BPR38LCyghJ4K
         iDzg==
X-Forwarded-Encrypted: i=1; AL+hErEwA0/Pf8WNsjuoz/9R7sr0j3K99sBMiI+4mW1OK5EyQBPXW0Jeg4vb+rCXYQ8SEraNpkHSU4F6qg==@kvack.org
X-Gm-Message-State: APuU4Z82iQglHA/r/3xI9Hqv0/IdPUbXsZ4NADUz5zs1/TpqEuSIHxCv
	2l3hHgQm3A+v+t68bG4+gYpQZnOPMgAz6YFnpogdV28jhyOthqCezve/uT2GijeW6SaZQJ8KIvq
	fPv0KdwFr/MHSywMGkDpT7CtSXsUZiqV9PdhGsMEP
X-Gm-Gg: AZFdTZe8OuM11RzgxHbgITHq/ek6tjOf99Qnb7uG9isBaoScmknw4XzlDUBN9D4wv1i
	jOi3PXvPoXkMMwvq3hPWIx+hY6JpzwxwVFtKRWXEilGwwehanrNFAU4oosFudU1H/ESmuN6ypXx
	JEAXbD5XEvgWyrLarZ78n6l/HkYLuhLOonllGQrnMp4S4z+38ZiypkzlGXnjGRUSXFyUA7Lwk8C
	/aqPmCufDzgouXChdF68iVfP/+TwUjGvGIiLSN+Y7T+WD7y9NwxJHAiilbMfrT38tjA+Txsf/aL
	WmmPVRMKl9bQHk9veNJAgSgCF3UlEXHR8wDvFyLc+2vDvvDnVi43c5yR3Zd+aq6Pss3wxX9xNSv
	5Mfbe81ahs9nPvCmhOm0eGenMcfhhWmXg2mGO+68mVeUGdtusAzXAifMo3hoO0eJf8xLXRzVH1r
	ZDXnVXD9LpxsZTUkt7/VX094NJOZjwIjfkGN5H0uCCMVa9H1GVXKQ=
X-Received: by 2002:a17:907:6d22:b0:c51:40e:847a with SMTP id
 a640c23a62f3a-c513a1e6fdfmr1639688066b.0.1795625053094; Wed, 25 Nov 2026
 08:44:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
 <20261027231728.1466446-1-jthoughton@google.com> <32fad21b-5bad-4640-97df-ef0f638cd9e9@app.fastmail.com>
 <CADrL8HX5vb1PGDpWzp-eR0rNfsMCVUhFa9vp_WZZx2eJZ+dfXQ@mail.gmail.com> <1a99e5fc-129e-41e3-8420-101bcf04b366@app.fastmail.com>
In-Reply-To: <1a99e5fc-129e-41e3-8420-101bcf04b366@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Nov 2026 11:43:36 -0500
X-Gm-Features: Aa3M54qTCDON0Zo2YJDXp5pBtwrXjTcYjv8NoqDjQS_XV_tl8JrBb-LQVlKEL3Q
Message-ID: <CADrL8HUOZs-vWRyM9p+Na-=arRU+Gx_cWMLbxHmUYnho4fAUXg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pavel Begunkov <asml.silence@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, David Sterba <dsterba@suse.com>, io-uring@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, kvm@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Mike Rapoport <rppt@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5guiwfi6tr9dngsqsa5m9am11om7ui6e
X-Rspamd-Queue-Id: 6E95714000E
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795625055-379843
X-HE-Meta: U2FsdGVkX19AMw3OchvojIdkBHx0gFHDAYczho/P9UxkXFwbGSHa9OewCF/eLehDUQLbcbM8SebEY6brtGXvjlRX5ku/6JGGWR3ZA/VyA1YC0rXwee60hltcKBfWSq9IbT8SSOAIkvDiyeFfbxtB9SIqqXm/PRaYG1ViIrGR+BRR+lf7sQigUyKao7mCT7YXLL/LuTfz7i4eg9iQawBd0U64yE7mjEh43TuZYod489jH4DhO8/16jK1gj0IUYo+36WK7gXaaGVlxSvXwHcBVd2C190I5ovKM4u54wrXTUGKEhEE4pIb0gf42dYGGWdwRG2Fi2QNqUqUBSE8gsPQobPv325zejqwZIY59n/0RkjwAT12PUoXJ6XERV6C0cWyhwUzNLVtRp2xs4z9oYDB/opQO8vcENCrWHUSjdVQ8lUHoNs67cZoyiyWQv+OEzxwnXsWiOvggn79eT/bGdSHzI4pi/uxEeAEd9F6HBQU9j/FmGn3rhs44K6Om7XBXij0xhRHMupafkjip/ajilHDNVuO3Ye10W7dMlGYxCkM/BPvCumbutAepEDbCEoHvJOl3+ZWMGWKjEV0P0RsDo5xFAU8w6yuQhgfkmw0EnfErLUR72vZQ+J3DuRXVCHTYioHzNS33oml6W/B75tlEO4OjP5UWH0b6ijJq8g5OJMm7/MEoqv4lhNC2vlZSCzPLCmn8YJ4D5VlTptNzfHesMZOgS5Hb1SQ1aF1ruxFn/Mhec9L/JRggHcvamhRVDqEjNjAOZHE0lRRaMoxmG9JRke2Un/GtPNznB3WLCJV0GrEG/jdgWF51QUIP4f2hO947V9yV6458sTsmSQoa71xeRN0Qgkaa3YFzwFy/Z+adGFTWiczc9n7aqMafAvPvJ4i36y/SRM+CIuR79XJHfDJ+B/+JZYzqVYaQWsrU8+PizIjOdMMBolwatHvhM42keNgJXTNIeHpnJMF3UpJQwdcR0So
 23diFhxA
 TMJxODB2vNHCsdpzDr8vGI1i6aNhx1D7vXB66tI+T6FV2whb+criCZU7QqvuH9VBw0j0cLkijMkh9Xj2uZWW0O4MuPayuXlOTgpx/x2lgCrCrHkqGm/itCH92O/+cGbIS6RBgUWQjU1wL8phKAcPajXrVN1nGCUmzQzBITPVbbg1hf01heO/oTzO6HqJuG2GTpaf5Vu935ig0Y37lgcGeA1qwgs3BF13kU92IwlD399FQHAMOSwUvaYW2+GTOTUMzGRnPkh0Dc+1bqzMnquEiCgdJu7EUXGggxjh+snmz9pTka4wOoBGrvWI+jzD4yE48Z8O3xnS1d4iA3UFhgSdN7z4byAqveFAUG3bPYO5RG661n+bDllKekPM9dKKsPiyO+DW53zi+n8ew+UfEi7tcg4taqq1WBIR4PSfjAsTAW1djjOyLChqTSNwQsalqEMb9A1WKWBjbAWBrBHXeQosh1FDajhPaTljlMwlUxRfCH/ORSxTdByN7RH1HNo3a06WMb88SFHjgtccU1ePDk2xuHiNu2lpaYGiCNtGhdVA8OjHEVAOXRP07UhahzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 5:02=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Tue, Nov 24, 2026, at 22:10, James Houghton wrote:
> > On Wed, Oct 28, 2026 at 7:14=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> w=
rote:
> >> On Wed, Oct 28, 2026, at 00:17, James Houghton wrote:
>
> > So now in v2, the _nofault() helpers themselves do not check current->m=
m.
> >
> > I've uploaded a draft version of v2 here, in case you want to take a lo=
ok:
> >   https://github.com/48ca/linux uaccess-v2-wip
>
> I read through this now and it all looks good to me so far.

Wow you looked at that really quickly, thank you so much!

> >> Since in principle every user access should go through both
> >> access_ok/mask_user_address and current->mm check at some point,
> >> so combining the two as much as possible should help long-term
> >> maintainability.
> >
> > You're right, and v2 has been restructured like this.
> >
> > - The check is in access_ok() itself: the generic version, plus the
> > arm64 and riscv versions. __access_ok() remains a plain range check.
> > - The callers of mask_user_address()/masked_user_*_access_begin()
> > check current->mm explicitly. There are about a dozen such callers.
> > - The unchecked accessors, __copy_{from,to}_user()
> > and__copy_{from,to}_user_inatomic() (and arm64's
> > copy_from_user_flushcache(), which also relies on an earlier
> > access_ok()), keep an explicit check for now. Once their users are
> > converted to the checked versions, those checks can be dropped.
>
> Ok, sounds all good. If we get more than handful of mask_user_address()
> and masked_user_*_access_begin(), we can always revisit that interface
> to make sure the check can't be skipped, but for now this seems
> like a good tradeoff.

Great!

> > Compared to v1, this also covers get_user()/put_user()/clear_user() on
> > arm64, powerpc, riscv and the asm-generic architectures, and arch code
> > like signal frame setup that uses access_ok() followed by __put_user()
> > or unsafe_*(). user_access_begin() no longer needs its own check.
> >
> > What's still not covered: x86's get_user()/put_user(), which do their
> > own range check in asm, a few architecture-specific paths that call
> > __access_ok() directly (e.g. on alpha and sparc32), and arch code that
> > calls __get_user()/__put_user() without access_ok(), mostly trap
> > handlers for user-mode faults. Probably best tackled later.
>
> ok
>
> >> There are probably few enough of these that we could address them
> >> by either adding current->mm checks or converting them to use
> >> the full versions instead where that is an obvious change like
> >> that usb gadget driver.
> >
> > Sounds good. I'll send a separate series converting the obvious ones,
> > starting with the usb gadget driver. I think that will be useful.
> > Let's see how far I can get; hopefully I can drop
> > __copy_{from,to}_user() completely.
>
> Ok, perfect!

Thanks, Arnd! FWIW, there have been no syzkaller issues so far with
this WIP v2. :)

