Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086B810706CC
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 11:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523BE6B0088; Sat, 14 Mar 2026 07:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505606B0089; Sat, 14 Mar 2026 07:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD436B008A; Sat, 14 Mar 2026 07:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CAC76B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:53:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9D37BBE6F
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:53:28 +0000 (UTC)
X-FDA: 84544508496.04.607F504
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CFA65C0006
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:53:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=OPyUbzFT;
	spf=pass (imf22.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773489207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4OkNnne5tKrJJEo7Fv9wxnd3g3GO6zLI8Uefef9k3A=;
	b=CCeSOHp34yAeVGJrygogEebnQh8kRp1+Pk3eDbYxNHO07ks1AI6PkeecRgkS/dhDT0BrFI
	PwNYTc6iaj0HW5yPNXFPJ+OVyl4i8pvyDTdImhDXzXRT4TLwOFpJnJtk57QaMvRFLxlrwf
	Tm3uarEhKYAXEOYsIDvUIeMhsYxmnPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773489207; a=rsa-sha256;
	cv=none;
	b=XBuWDKRxkgK0XkNE9jXvUGdCyP2kRDWjLk0/bFX2wKykqHoZPPTDLwAEiRgJGGzF3C1J7u
	ESfSTRX6N2Y5yC7Y7sybojWwyOFmlqskn1PKjZAgvlfABkHXkpATbuhbSTk5FqophzCUAL
	WRLXflCp4eLlpQTZAjGHBLsP+O03T00=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=OPyUbzFT;
	spf=pass (imf22.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0AA4401EC;
	Sat, 14 Mar 2026 11:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D60C116C6;
	Sat, 14 Mar 2026 11:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773489205;
	bh=impwRFcDkworY8zCZmfr/pzhhIFp1qkfw4v11OePyXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OPyUbzFTYoslL0P3QB9MBfwljyZslpNJOVMS9ZCSePNL1wdK8CBYrpW9E2gmT29a5
	 UpZVqYoJGdwSkQZsEmqZb+9M47K9Bu6m6pRwNneUh0NTPtg1EOV7iE5WOMfLUFVbaS
	 7QETJzTuQxufPloRfVYb7h3yyTx0SzXq4ib0fpWU=
Date: Sat, 14 Mar 2026 12:53:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Mark Brown <broonie@kernel.org>, rust-for-linux@vger.kernel.org,
	Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [linux-next:master 5585/5731] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
Message-ID: <2026031444-wriggle-tradition-245f@gregkh>
References: <202603121235.tpnRxFKO-lkp@intel.com>
 <20260313213638.GA147391@ax162>
 <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
 <2026031422-catsup-rectal-f886@gregkh>
 <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
 <abVG0JypVhDxx1Tt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abVG0JypVhDxx1Tt@google.com>
X-Stat-Signature: 917xhepzd9mdxg8js4fgaehpje851rdo
X-Rspam-User: 
X-Rspamd-Queue-Id: CFA65C0006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773489206-499707
X-HE-Meta: U2FsdGVkX18alCfPqPIkUopsA5brK3i863g1O9tvYJu8b7Tep0w3q55PBFvRd24ixA6AE55vctJHXRhhzgGZDDQmMofrw2NDxz/0RAbwajrEXEvDoo9tmELSf0fn2mPu9Q4WYRqRZl+CXEKVHedbDc+peYxvhkwJ542rDFz/DE6OYZ/fW8z5RypKrPbpzQ8qGD2U3gMP6uwYXJG32eDqSVSlmdgFvFZO5v3daSbKsAb/jsW5PXSuJ/6xP8BvPdOO5lQ+I1iA+Nn3MSJQ4IHDl4XprzBMina22nTZXpYHDffPGoctJNqx4sShtSh+t5DNdLW5k3jXZj/l3qD2oviXzHqDLdNHV8BDOi9WVJ4ukUN5I2YTTSgaJs8o9ma5wXIqQMJrlITmJTvMCpQUgza/Zft8reTjQtVqtSR3EsYLHyQLraphWMBJMgWom3y74eeUSBLDVJzk7q+IPhyzXFcQVFNFNBXmYN3kNJvdpZNxlyYkDkFGDvR4JjJLqWyY+tGmDpExVUjvxXiERMYofH/q/P+jiYP/zc5Hj3udl0/VOYLKJPrSVIivmSdG5JoTGioWO2znNrZ2Mg/D7/GrMcEfF//jKIoepqqkSrFpzUD6pDt3MOGqiM+YZqmjOJYySu5ZH3hR5LoJ1mHUIQVKX15nkiKbTejicmiLh39Awvsrl84dsAcq0ocMz6SHfAUtQmTG2dr5cPeFpLRj4iTWa61ZgdpFnubYQgDLeGhn4dK5Ds806Hfnzrn/lzFirfmHQjLGYrks0bWo2QBYLDJm2yejUnCWyWZXa+hfLEIu0OKuY9toTOjKl1lt/vAP+5Hc8fxHColgxsNm/zYOhSArlsbMo1muT6KY5nVr9UNLaKwzgkB0RKwJSv2T7SCnJxYbqqOCKV0jUqBvmPt+0ObRo+uK3VWF7oD7c/3Vi8GwaOLR5sFiYEeHDVF+qQo/xe/sHW4jc5St/E1O0dfUhCDPndf
 ntxztwvb
 mWdrMSbmuK7syBKVtgtc9MGJLSZw0CoqPpFZcEPIRuArMCeQbiCpoNPH91KDmulZGfoM0XnYdEVhseXVR6dwVJlh/H1HtMuYT0qRhwvWHADybPoqwdf/fx6CSwG4P38dV0I2KwnTO1tPav9OSYAR2mKHDBDAsyH9TwtPg4lyT9cCYXe680bqIsRYduLi270q1qoSWkGM1q2IYKwphWYY5sMk7ldvxvYqc9KxCbJKp84ULI7LQE3OAz0TSeyzJ+QeprEPq8oOQqGDBc5e1DeUWnXdS3YKslwTBQbDjC56Qm/TmPiM4KS7gBCEaHbA5sfqWQI9aRWMPnTwo2gMm30J3o/EbrvT9lwKgn9EsRUesE1Na6YhGBcE5kCB4N7tTywSN6T5/426VvqhWrivTu48BRXh6fzkcdfyUnDB40SIEgrlp3PmpOAbMd/VUgjd4cy8cNBTI6hvo7Frk4+DAeWrcIKMHe7Q370Zgu8UF1jbCVLcQNrItbjE+6hcztgsCe4KvX4yp0BpUCPVRABYMrrfN1LvvNeRuqXySKN5CUnVAb02HE3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 11:30:24AM +0000, Alice Ryhl wrote:
> On Sat, Mar 14, 2026 at 12:15:30PM +0100, Alice Ryhl wrote:
> > On Sat, Mar 14, 2026 at 12:13 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Mar 13, 2026 at 11:39:14PM +0100, Miguel Ojeda wrote:
> > > > On Fri, Mar 13, 2026 at 10:36 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > > >
> > > > > It looks like this is a conflict between Alice's "rust_binder: check ownership
> > > > > before using vma" [1] (currently in char-misc-linus [2]) and Mike's
> > > > > "userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-unstable [4]),
> > > > > hence why it was bisected to the -next merge commit.
> > > >
> > > > Thanks Nathan, yeah, adding a raw pointer (not function pointer) to
> > > > the struct makes the type `!Sync` in Rust.
> > > >
> > > > I assume this is best handled with a patch on top of char-misc-linus.
> > > > Perhaps creating a wrapper to assert it is `Sync`, since the
> > > > `BINDER_VM_OPS` contents are unused (so far).
> > > >
> > > > Cc'ing more folks related to the commit.
> > >
> > > char-misc-linus should get merged into Linus's tree "soon" and then we
> > > can fix up the mm-unstable change for this.
> > 
> > I'm working on the fix as we speak. It would be ideal if it went into
> > char-misc-linus, because the commit that is wrong is mine, not the one
> > in mm.
> 
> To clarify, to avoid breaking bisection, the commit needs to land
> somewhere that is on top of commit 8ef2c15aeae0 ("rust_binder: check
> ownership before using vma"), and before the mm commit. But I guess
> there are several options for how to do that other than landing it
> through char-misc-linus right now.

I've sent off a pull request for the char-misc-linus branch now, and
after -rc4 is out I'll queue this up on top of that to get merged for
-rc5 to make this all work out ok.

thanks,

greg k-h

