Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCBD5CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2196C6B0092; Fri, 12 Jun 2026 00:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA0D6B0093; Fri, 12 Jun 2026 00:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0B06B0096; Fri, 12 Jun 2026 00:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F059A6B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:48:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3263C28AD
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:48:34 +0000 (UTC)
X-FDA: 84870029748.12.5BAC8B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B16EAA000E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:48:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=llH8WmKT;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781239712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPEmMa3Dv5Ej20J6k8sFcuOzkcc2oCt3G4gIZGmy8o0=;
	b=mWTmMjS2gzfGbx5hLxQ54/KkLh1QPDQl9A3cQpyjnRz2rKQZtubt3bwF263iFEw5PtHHvS
	9U2OxxSWKgmkvhsZRjbyt8kQMV+dALRdTHqtAfVOk4fhl9fOxV20Hx0ScWoPKfVanyftx4
	GvDOiCujWumWGSHANLN43V05CC+zIWc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781239712;
	b=KbPD/wtEbwpkgy1P7BhZRRd3vHt5r/9ZV1kGhCp19pqgCb6jCf3EkBnbjVpRxltkpeJXUc
	qAiFs3iRjIx8gHdtsQ/z1D0Nraztmy9UJbhIXSVQ6f0TVH1GvmI+NmUQaiMBgYSpSs9Fr5
	hJPpxNV7KZFDxuol15pMRxUw7E+gSiA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=llH8WmKT;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A6FE44600
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1021F01559
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781239711;
	bh=WPEmMa3Dv5Ej20J6k8sFcuOzkcc2oCt3G4gIZGmy8o0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=llH8WmKTCTRGQsPfLLTgmaYephweLGTeJ0N3Ke3jX/ml9f0EE+658sPzkdXDGAR4x
	 EIHI4UjIo98ItMqFvaw4K2maCX8OzljWDuxxWDzeP3R7YKzwmUSQqDSa3nn55EoGqJ
	 oBOyY991FAhdsq3CMosbaHlRVrMQYR2Lz/TOfH1YuucbtHYbnSlKI+2/P4MP9rpHzR
	 qX1nHkeodo2HuKWUUkIjR0vNJP1sUVZODOR/s7tufsDLkOo7yqfi5xNO9SeJE7Jf55
	 CiiAps2Rpfx8Br5kUu+kgM9vK80coRUfEQ/QfnRQ2HhnkQ4wrkve580RmWxOzEClQk
	 zgotztdnu6fiw==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-91591f19c30so82691685a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:48:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8NO84swuYsJb3qlv1xY51P/CHJq2f8nw8TnjZtkWYfx+6PDH2a8dOBiRTuGTId7gZeTk3WrdxphQ==@kvack.org
X-Gm-Message-State: AOJu0YzvlqA6I3M9Ll3fwdKR5vxhCC17lY4b5w4FxB4GDmVqb1X/CsTy
	bbwT+A8BNAsQBIwfUT2LLbHLiEPQDJ7eLELQIjCxobltUdofcBMldk9+FJYJwwrVen/ZfytpssS
	xL74O90OYYS7diD+4/6SldZNE6X8TOSs=
X-Received: by 2002:a05:620a:3198:b0:8cf:e0fe:f217 with SMTP id
 af79cd13be357-9161bc59762mr162308885a.20.1781239710722; Thu, 11 Jun 2026
 21:48:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260611105124.98668-1-baohua@kernel.org> <20260611105124.98668-2-baohua@kernel.org>
 <air47cqcLUwI4D9X@linux.dev>
In-Reply-To: <air47cqcLUwI4D9X@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 12 Jun 2026 12:48:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yCeAmpfo_8ef4MrRyRD_UtV-xGm6F4GpSjvLVPQsbiEg@mail.gmail.com>
X-Gm-Features: AVVi8Cf5OfwTVZizFhNRcFh925vCY0A09IKkonR3dpG77uFAry5JN5O8eLju2dc
Message-ID: <CAGsJ_4yCeAmpfo_8ef4MrRyRD_UtV-xGm6F4GpSjvLVPQsbiEg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B16EAA000E
X-Rspam-User: 
X-Stat-Signature: sif8tyuwdscikmkttumgkima5z8krhu8
X-Rspamd-Server: rspam08
X-HE-Tag: 1781239712-652531
X-HE-Meta: U2FsdGVkX1/kS2uStAZ3YtN67TWaDJKYeZpWX8e3fu/76UdnMj19R+h6yoOBvQSu6DYyyW6z8qGak0qWpcvPF9/ckHZswbn3BbniF70p4H5RQ7u3Efm+kVs25CgxWr9XJ9I560bKjDEAOOzA3Z+1enOY0dEkbRY6oUUE7qH2SFoYtIEbb40fHcSBcmVrwYzmYB5vbUCjijhUQpVdl6bPS6NNjflwXr1sWgFF233PnkW6xe409k5D2tlFdiRpc1l4lx1JAbSOvCcWpwpu3l76fvPZoSHssMIPBmly5RCbR8KjEcGCd+w/GCLRnhpEP5NrvDDxkH82yr6CQKe8+BI1E22o3alaVQyGegZnZPnSvLSBiI9bltmG5GA0tdjIgks+EJHuxl7YdIO51DkT+P89bIo57u9H3KXCosRy2oqBd1oViLXSqqT+gVPyPgoaEJ6YqTv7ut/+02ngmTj1NDahSxaGBQmPeaUzwvCLveDH4MQXCAMcWQlai6u9NYuFgFKYNP7wwcBVTY1an2Ekv07BadyWxN5rXgUMs5ZKrxxZms3Vc/QOCGPc0HTC+2bgcWhrS9qw+3bJJH2HkNDaN/dvmvliWeR2H4sr/zHcaiJi4ov/2Je/8yi9xJWY9EguXnmCUDz+SDMtP/HFTsSgTTABaO8NTBLTheLkeocs0zVKXasadCPJFTFkHJMiPTd2J/R1CM9M32tZJTi9J4X0XdYF709WybSNqwdI3kH1qoa7+9hfi2db6SUxV4aMiWmdSXqakvh46cPrNlE0BtGmLjp0zzmEVIbp8HSRfP1uSjKzb13XMlx3cTAdomfsf/zBFdG2JinxQeRew9hq38f2HngaOU/CjyDMw1Q7f+kkpWvcedh/3Y9Fr1EjCTJNqFM3ayq7QTVztityCbans72qUqlp3lHmeQLn3hdZNdWEx4vqPQLVCsMdbYf5Ai9b9nLT4P6kra+F/xkmj+Fz/M7xgOn
 Bi7KUrXI
 +aI8IpbZ3fhNOsaZcuj2fRQb1Ov00xwehffItfChqkNxktkgI18yNClCMa13Vsx6oA3D/Oaf6XygDdLYVRVR5KB4BEZDgxSr2CG9sVFEIkvs6VakVVxhTmWIzL4X2Rct+whdAawqMb8zmzQ3I7AmP9OOiymVjn66k37CUd50jXfre7HT1IrUXdXF3BCs+iWa816Ym5V0PyxespKLMQKAIXZWSa6JEN2f1NNiI0KFZy05Sayl04yyB9IEbJU9UBDNe8T5WWXHKQWUiDUaHRs5AftTnnDAC/lUwD4Tfy8V3Pwx6obFOxfaykiOaJmtg7H4M20mO0bixR2O20Ljv3nsXEK+sUg8O7Su/gOoI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 2:10=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> > We always unconditionally drain the LRU before retrying anon folio
> > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> > are in lru_cache, and use the refcount to avoid many unnecessary LRU
> > drains.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/memory.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 56be920c56d7..487a34377a7b 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct foli=
o *folio,
> >        */
> >       if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> >               return false;
> > -     if (!folio_test_lru(folio))
> > +     if (!folio_test_lru(folio)) {
> > +             /*
> > +              * Assume folio is on lru_cache and holds a cache referen=
ce.
> > +              */
> > +             if (folio_ref_count(folio) > 2 + folio_test_swapcache(fol=
io))
> > +                     return false;
>
> In your experiments, how much amount of drains were reduced due to this s=
pecific
> check?

This is a very good question. I booted the system into Ubuntu, and after
boot completed I observed:

wp_reuse_skipped_drain: 5542
do_swap_skipped_drain: 0

Then I built the kernel in a 1GB memcg using zRAM swap, and observed:

wp_reuse_skipped_drain: 25017
do_swap_skipped_drain: 43595

So in summary, even without swap-in we can save a significant number of
drains in wp_can_reuse_anon_folio(). With heavy swap-in workloads, most
of the savings come from avoiding drains in do_swap_page(), while we
still see a substantial number of skipped drains in wp_can_reuse_anon_folio=
().

Best Regards
Barry

