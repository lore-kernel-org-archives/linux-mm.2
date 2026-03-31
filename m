Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537D6109B461
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 12:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DA46B0092; Tue, 31 Mar 2026 08:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864D76B0095; Tue, 31 Mar 2026 08:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A18A6B0096; Tue, 31 Mar 2026 08:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69F336B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:59:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB80BB69EE
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:59:55 +0000 (UTC)
X-FDA: 84606365550.08.85BE754
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 347B1C000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:59:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=FpoQCRo8;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774961994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5JTDYY/pY/ra813cAm7EtuJ7AI2Ssmsvfj1fb45d4E=;
	b=ORsWoZBiXh1bt+ZnBRN3W8Sd0C/iaM9BDHDw2xG36vjiXE/cUQXJs+VLg5evmZqwhji0R1
	I+T7HcFVRnqfK/n0yccMhAtr4vd6PWCn9eJ3a6oQ7kjvOmnQo9Z2eUSqVGUFcsnZ1l/env
	m3vTsAG8ovD7MD77VYYdd2uYezZv8m4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=FpoQCRo8;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774961994; a=rsa-sha256;
	cv=none;
	b=Wl0hyhAkyxPvY958I3To47BhBHRxJvt5g/qoq09xzG++lM2EeItb6+TlqyH/fGTOvooalN
	S31jq61Y+OXwTH9Ts5ZmYlrhFMMgXNexgvfwL+/ig6mtEcIuStD8D42l+pi9uUAA6Rm+5X
	Ogr4wGzw4PCukZKhlH1tZo2chv5szqc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 578436057A;
	Tue, 31 Mar 2026 12:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E723C19423;
	Tue, 31 Mar 2026 12:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774961993;
	bh=ch3CiQ853BiWa9wkq1mpgzUpNpYNFJhT6U9aOLT+a6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FpoQCRo8z7qCiOBE7K8fjpZm8TVSjxvsTDLuMhujwhRvG70gwmzrQTMhH1OrEb1nc
	 GNkAe+96QnHKwT1YSMOjzygcwUCLgHCQwO5RF/bTCapcUHC7L/kEY6mXQlEjb+gF8N
	 3uzRojue+EtnNnzvENijuvvJjfK3PI0rgIxwAeDY=
Date: Tue, 31 Mar 2026 14:59:49 +0200
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
Message-ID: <2026033142-distinct-tanned-f749@gregkh>
References: <202603121235.tpnRxFKO-lkp@intel.com>
 <20260313213638.GA147391@ax162>
 <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
 <2026031422-catsup-rectal-f886@gregkh>
 <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
 <abVG0JypVhDxx1Tt@google.com>
 <2026031444-wriggle-tradition-245f@gregkh>
 <CAH5fLggMZM3kYWO3xqb4o-mQG27aCYOmiiODW67CKLTstkB-PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH5fLggMZM3kYWO3xqb4o-mQG27aCYOmiiODW67CKLTstkB-PQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: npr3bce4ydnt9gyporoa3hctgsfc8h4d
X-Rspamd-Queue-Id: 347B1C000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774961994-164803
X-HE-Meta: U2FsdGVkX18vorE87FeYI/WyzxBALAdrmZcWaRs0E7rELrBUo2YS7Z6/oaSAdYJWj7GX0cPN9DLyZIEtqT0y7gGfzPz1v57PeBeo4NB7lf9o+z13OwJmYffcalpOk5uHkphwmx6fW+SN/Pe5OUqPWO9QyNClBWIjlqhB0hQOzKpc3q8kpKOcm4QAeM+c06gD5jRXJ6Z0ENvXRSVa/SeIk93QNkmb1Bt3PZ08Cqex9ED5pFTheWOsleuFbH1s1r2R9vWve7eV6+4LqxwyFru6FcfJL1gvYudNWMnuLHkkqV74tgNzMQx3mRI6oOFYJE5XAm2cJNH4cKmgJ+HgKx15oTP2ZXBYhs6LdAuH1Mumx1rE6akWY+CZKb1X59untR6mnzxeC4FwaGf0e/pkzuNjXEgHwWijxd+KCUjpfgZkXP8GxaeKlAcNTgDh2BnqGKS3Whqgtb2F8JxjSroNRn1F9kDom7+vJrofQuSFvKk0RcDxspLcxX0ffJHHB8dDxI2/DRmBo8JIyexW/DwWGHoBzEz1a5nSX4IHmA58aQYaTiLhkBOXXz9CfItJyHeGxHCGKH403OOclD7p6zBKhJDvm+StOIm00aZCaM8lPYEXzO+LNspa7QDfkhH6LMuMzh87a8F8YSQjIO8RdKrYspYEHKfVSg6vk5wZDlGzEKUNLAXvV7KCRH+YFJpUz2M9a0z6V/aw3fGaHwZ3QQj3VlEMDsx+mvUrAr7rL5Q+QHLOIpH+JNUCeh9wIcG8LoqVxb7rbM1PIP7mr8usX1VgBpUT8z15/nY60dcv6eoL/lhXQma/0ljvGdZj2Ni7fOBtdA0rU/DJC6nt9ieo2qNACSRgEzi5pPU4+PBwXFz0RRMAs4tJ/erL1e1z8l0i7shjnx3T4j+6uE56FG5P6DEtqEiAJ8isIp6i19gr/8uymmVHQt4ZA/rw1tLP9bbAj71ofV9TwWtAHvRNNZD7zrWivu8
 GIsdAziy
 QA+NlifR6oNQNTy6MMbDU+GJ/0z1pV7ayE9xJD+aFrSgFBvmoa2ZUQri+lxUvLjhc6+agrV7rN/61l+ZCA9ELNL+zShCeZ9tYT4pTIWp3bpde7PW3FDwrRRsBUqC9apsWGWXguupiM7diVis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 01:32:03PM +0200, Alice Ryhl wrote:
> On Sat, Mar 14, 2026 at 12:53 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Mar 14, 2026 at 11:30:24AM +0000, Alice Ryhl wrote:
> > > On Sat, Mar 14, 2026 at 12:15:30PM +0100, Alice Ryhl wrote:
> > > > On Sat, Mar 14, 2026 at 12:13 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Fri, Mar 13, 2026 at 11:39:14PM +0100, Miguel Ojeda wrote:
> > > > > > On Fri, Mar 13, 2026 at 10:36 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > > > > >
> > > > > > > It looks like this is a conflict between Alice's "rust_binder: check ownership
> > > > > > > before using vma" [1] (currently in char-misc-linus [2]) and Mike's
> > > > > > > "userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-unstable [4]),
> > > > > > > hence why it was bisected to the -next merge commit.
> > > > > >
> > > > > > Thanks Nathan, yeah, adding a raw pointer (not function pointer) to
> > > > > > the struct makes the type `!Sync` in Rust.
> > > > > >
> > > > > > I assume this is best handled with a patch on top of char-misc-linus.
> > > > > > Perhaps creating a wrapper to assert it is `Sync`, since the
> > > > > > `BINDER_VM_OPS` contents are unused (so far).
> > > > > >
> > > > > > Cc'ing more folks related to the commit.
> > > > >
> > > > > char-misc-linus should get merged into Linus's tree "soon" and then we
> > > > > can fix up the mm-unstable change for this.
> > > >
> > > > I'm working on the fix as we speak. It would be ideal if it went into
> > > > char-misc-linus, because the commit that is wrong is mine, not the one
> > > > in mm.
> > >
> > > To clarify, to avoid breaking bisection, the commit needs to land
> > > somewhere that is on top of commit 8ef2c15aeae0 ("rust_binder: check
> > > ownership before using vma"), and before the mm commit. But I guess
> > > there are several options for how to do that other than landing it
> > > through char-misc-linus right now.
> >
> > I've sent off a pull request for the char-misc-linus branch now, and
> > after -rc4 is out I'll queue this up on top of that to get merged for
> > -rc5 to make this all work out ok.
> 
> Friendly ping on this. I don't see this applied yet.

Sorry for the delay, now queued up.

greg k-h

