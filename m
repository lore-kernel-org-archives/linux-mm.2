Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B75105D98C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 00:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C076B0088; Tue,  7 Apr 2026 20:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3B06B0089; Tue,  7 Apr 2026 20:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809AE6B008A; Tue,  7 Apr 2026 20:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4706B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:34:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BF2F1A09F3
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:34:02 +0000 (UTC)
X-FDA: 84633516324.09.AABA079
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4A297160003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:34:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Auw00iZQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3dqLVaQYKCGcXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3dqLVaQYKCGcXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775608440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDLo9VPnGDiQNlFQzI1xTSPzRXpWtFJbtAFYR59HS10=;
	b=yIOhS82TOOW28opGiRRUWvNo68ImCO6kjiC8KpWXDI+N5z4BfH6MhU7xHyhtaNiHcMPRdP
	E5sTh6CNFXU9z8unHW6mUZlILIxbElD5gDlXu+ZTrzrF7QO9jTjbEMasvEY/V9YA6L0gbM
	+ossij/6ytoqHzxPDbrnodSKFsANy8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775608440; a=rsa-sha256;
	cv=none;
	b=wlYVAJB6AoHjyYkUBqIASq8YbqTE4Qh8AoOs2eS+hGBIMUaHAd2TVtkb4eH6XNcJU1SukC
	pqkqSiOnw6ISlXcFoLlaIl/12PGCqntE18J0gioo6hvdfVDYRciKxLD9mquHbUFsAHslYW
	AOLbA3gu4AGKHDtLk89GxJTSuqrSuYg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Auw00iZQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3dqLVaQYKCGcXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3dqLVaQYKCGcXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82cf0130d17so3295464b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 17:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775608439; x=1776213239; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aDLo9VPnGDiQNlFQzI1xTSPzRXpWtFJbtAFYR59HS10=;
        b=Auw00iZQVwWYWV0YKFlqW/tIrrimOP+aj3iEF0WDFJUjLgytIZow/Z2+Qp+R0wdXIo
         ygk/66Gr5s2MMChab/C3bJ8dgdvMta87ghfewMNDEbz82Oh4mIVZfZ+D3jhpqBqA+8AK
         kKG1eg2xnL8EtXPnW3tFAHUXjLd4D4GQVc9lXqbizt0qgaV7Wa4//KFcztQb/Ktgqir7
         JlxyY3ue0gJrLUXwXKkZ55V4r9la/7z1aj6g0/+8LpuM2a6DwhIKTzTLWHuFS1atGRoO
         0vthcupbt31cqQw4ExUCyz4WHuSEpb1/O0uL49gnP6kCtxO9RcWdtfSODONwf2Omk8AU
         MorQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775608439; x=1776213239;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aDLo9VPnGDiQNlFQzI1xTSPzRXpWtFJbtAFYR59HS10=;
        b=cmqvbID/qwMQvy2f+RJ7zCxHnntUOcRlg0wCF8SMF74/nZ7Mv4uJqq9DemQagp2EYU
         cfWRwT3Fu5rCy3KfSg3gaLFQlCetf4a+M/5bkAnJX03ywidKSw2D05tMnRiGMp6+3ImI
         ZTzs9yJkut+9TrTu+JJcyNv5lETTUSt0bY1TAzFV5mS9POivozKg0oG8AWFoF31YIj7I
         KgWRvXkJb0B1yup7iUXj4rcg2bpm5+MNDdJRd1gIhQGz2npd/kgDXaWQx7O6nbu8psbg
         k4Q71vW4+8LBRu2p0Fnp9fgy9l6tR5kcR2EORRY9UykQmghwIq3QZ94NgNSLEsZzOf/i
         KIhw==
X-Forwarded-Encrypted: i=1; AJvYcCVZFhwFv9y+7BcDXEXPiChIvvA2slOsqaH3qB8gXuEWyeRizdnmv0+WKdrbQ7nffpKnR1ZD6Ugf9w==@kvack.org
X-Gm-Message-State: AOJu0YzI4y25S8/vulnvfLZNmXRR3/QG9jdZW4wo9H/Zz+KyeAuatmOT
	nMBZfezHyVHESF6fBwMi4njsZxPR/U4MD67OmV5CmDtBOQSYsoV8MQVw9jdZjbzFHKXMHcP3ZPA
	FDe5myQ==
X-Received: from pfbmt5.prod.google.com ([2002:a05:6a00:6e65:b0:82c:6e7c:ac61])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3011:b0:801:eee2:45b6
 with SMTP id d2e1a72fcca58-82d0dac592amr17920681b3a.24.1775608438815; Tue, 07
 Apr 2026 17:33:58 -0700 (PDT)
Date: Tue, 7 Apr 2026 17:33:57 -0700
In-Reply-To: <nmy5polcxfnn3hoircsiqarxmzlulwwq7w34okanccntp32v56@h2eac44agovv>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
 <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
 <yvfwexsub7nrogh67hzcsupbrkzer6a7kbeao5tlq4elrzc2iz@xrwdjd7p32pp>
 <CAGtprH-kgRByFvvCYeWMXtsvpb6qpaWAo8k-3PEnioyPg-LEvA@mail.gmail.com> <nmy5polcxfnn3hoircsiqarxmzlulwwq7w34okanccntp32v56@h2eac44agovv>
Message-ID: <adWidf8UgZeYctr1@google.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4A297160003
X-Stat-Signature: ew7iso6qzmdby8bczk4w6wuoko8646tg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775608440-989212
X-HE-Meta: U2FsdGVkX1+pkYnm3+LfZ/varwR9HoEoUQoo050cQM4KCQ4H31fZ0Si6XSwKu83dwoGVKxQLGQ0lO0kv9WwpibdgqpHaHqzGAxIhbqDG9B7+OaBSNAmjLzxFprQjCuM/mWNnocZ2wFjP9TyhsHt16xSZAfqR0kKXJdtqr5Z58UZFBfVsjlIW0WfKCE6UV803ZdjOi2SgI3TSd2EWRlyx0PdHCJz8pO86JZGGzbgcq1sf32/OjfxNIHFHnvzPiWH/LZueIjhMi5L/Q9Wdq7n3qD4pePGW9KnNNp090u/dNDFY7kE8HvA5qewPT3lpeeHegt4WSjp/Ad488qEpfWfmEcwIiENVyfJIvEbtx0ro6Kaup5numxkngOvkqeBucJgCs8MpgcwoDF3By32XA68FBTMWdJA7RXLnawnuTUztNMkp42kOjbqt8Rl0H8HnBI+CvtoTjue3nz1AV9niqNB9OHSWIIxtwGRrDSIedhFxcaur9gGpv9UqvyCj3N7fs3G6AGxmZ3XfA8rqHG03f36RItPkM9DirTMBoqZExYBSX7hpp4onMpfM2ofFudvc14AShcsgHvnLbZpOVyVh6BloL5f5csgThaKaHTFiZSyBWPZ5Xe7GYzvhSySxbX5LoiLs0tQ398ge0Lyub822cgeilB0jMnyQbAfkgPCh258zYWgeYwBokryfP+9My4y1i/+tZiMwA9Lipd9iJhhw/A1BpFj/L3hj7P2y04Q3pbb1ZEOO2/RyUoyjDH9lBOjQ2xQyVDu41jIaoiwKFqWOmoVj7fMdNJawdZqgHCWR0WpmQqeZX2uMh1n0Jra5jN+Z96vg417yVVwYmLbRAqhKRB//+ALbIM8f0wpoWKzSchm0fCh3MSyWTZclvduBghQ+T8l7aI+ACoFatMReaXgxCNoNDkX+yDE3XffrPPdNshuJ8Uw1xYatJduvWFj/xGXrAObyOqBmZlTJveLWzEJVxr9
 P2nSSfHN
 mALpHOqqL1nupIdYz7XOQFmDCR6DaG8r32307zoBtkrnLF4n//K9QIEsuGNrpFRULwBaTrNTXEGeYIj37wXKC61AkTXSh+tiZ/cpU3I9oQi5rJc5G+8dAYya5ljLfOrn+K3ZxHRlUvGdgSOOj+vCCe9BlmnbJJI8r0ilhiBeCODdIT62t/BPSBqTjIC0oMe2TC6GXh4HW/eEO34kxpWB56rszY16AgrRB2oyRUWLMz5/tspy24qlpGbEjdfu0LExcuY1QsVDaOjFV6Kb2PAMcLh9/84jsOxH39Y4WjjiW2n9herWir/lrEvSNStKuYd0p/LYgpGsRaHt3JOdU3e5bcL5btafmFbzw7ZCkyP1mVeVda6URtxM8e+8FKRUCxUcZLViBKzpsp8FXe2eCy7p2wNeQMpqG05ijkpMYT0puBlwPE8OOxEpGhuJ5ExSxFmsnjj76jEkZ60CuFjV3/ZATBkfv7nGLz/IrFrBSEWvoE9+Z42ZXUMybNoTIQ60zcZNuhJ5+EQHVYTQHLfuMoB3eViTrFAIy561lIEuP74dTLxZpVydR7EoA83mRH1yCJF2FTZDCcqmBS4NsbgjMbWekdwG+CLrH1wbhNDrsOww43UvUJOJl1mGhlVmYjlRe4DeCqJeirkDxarrNWiuAFyPeQXpZLn3WlFf9/e0VJDIzvkfQrboDKJqeMOp17VsH0uKlDHqSifiH6aritxFEnVacr/OrMilSlyTL1pE524y1it6I5KJXnjcmEcOPNTaBZ3c6m/eESSEbzP9V46h7XtubUffLOk2RL+izLMB7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026, Michael Roth wrote:
> On Tue, Apr 07, 2026 at 02:50:58PM -0700, Vishal Annapurve wrote:
> > On Tue, Apr 7, 2026 at 2:09=E2=80=AFPM Michael Roth <michael.roth@amd.c=
om> wrote:
> > >
> > > > TLDR:
> > > >
> > > > + Think of populate ioctls not as KVM touching memory, but platform
> > > >   handling population.
> > > > + KVM code (kvm_gmem_populate) still doesn't touch memory contents
> > > > + post_populate is platform-specific code that handles loading into
> > > >   private destination memory just to support legacy non-in-place
> > > >   conversion.
> > > > + Don't complicate populate ioctls by doing conversion just to supp=
ort
> > > >   legacy use-cases where platform-specific code has to do copying o=
n
> > > >   the host.
> > >
> > > That's a good point: these are only considerations in the context of
> > > actually copying from src->dst, but with in-place conversion the
> > > primary/more-performant approach will be for userspace to initial
> > > directly. I.e. if we enforced that, then gmem could right ascertain t=
hat
> > > it isn't even writing to private pages via these hooks and any
> > > manipulation of that memory is purely on the part of the trusted enti=
ty
> > > handling initial encryption/etc.
> > >
> > > I understand that we decided to keep the option of allowing separate
> > > src/dst even with in-place conversion, but it doesn't seem worthwhile=
 if
> > > that necessarily means we need to glue population+conversion together=
 in
> > > 1 clumsy interface that needs to handle partial return/error response=
s to
> > > userspace (or potentially get stuck forever in the conversion path).
> >=20
> > I think ARM needs userspace to specify separate source and destination
> > memory ranges for initial population as ARM doesn't support in-place
> > memory encryption. [1]
> >=20
> > [1] https://lore.kernel.org/kvm/20260318155413.793430-25-steven.price@a=
rm.com/
> >=20
> > >
> > > So I agree with Ackerley's proposal (which I guess is the same as wha=
t's
> > > in this series).
> > >
> > > However, 1 other alternative would be to do what was suggested on the
> > > call, but require userspace to subsequently handle the shared->privat=
e
> > > conversion. I think that would be workable too.
> >=20
> > IIUC, Converting memory ranges to private after it essentially is
> > treated as private by the KVM CC backend will expose the
> > implementation to the same risk of userspace being able to access
> > private memory and compromise host safety which guest_memfd was
> > invented to address.
>=20
> Doh, fair point. Doing conversion as part of the populate call would allo=
w
> us to use the filemap write-lock to avoid userspace being able to fault
> in private (as tracked by trusted entity) pages before they are
> transitioned to private (as tracked by KVM), so it's safer than having
> userspace drive it.
>=20
> But obviously I still think Ackerley's original proposal has more
> upsides than the alternatives mentioned so far.

I'm a bit lost.  What exactly is/was Ackerley's original proposal?  If the =
answer
is "convert pages from shared=3D>private when populating via in-place conve=
rsion",
then I agree, because AFAICT, that's the only sane option.

