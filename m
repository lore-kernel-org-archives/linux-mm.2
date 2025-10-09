Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39067CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7835B8E00A9; Thu,  9 Oct 2025 15:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734778E0002; Thu,  9 Oct 2025 15:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6232D8E00A9; Thu,  9 Oct 2025 15:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCAC8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:23:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDA2211B2A9
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:23:44 +0000 (UTC)
X-FDA: 83979550368.20.4C42365
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3DD66C0011
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:23:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W+qzwOKD;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760037823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jp7RtX8QrWLsQRUW1xantQ7VQ3O2n8MHqV4fLYQadGs=;
	b=UKVVAKcagdoBWmm8weSYDxWLXjRfkBiKSwV8agDtO+6dkZf+R7Wyt/P2BL9nrvWXUbZnss
	cTpVYfuxJEgzPyAFZJvOhP/uokDtNBZNWf3gGu2ScaYSC7eOK3XWO93sisP1E/rphfwQD7
	VNKjFSBnYNRR6ilWbPfUMqPEQvA2PFM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W+qzwOKD;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760037823; a=rsa-sha256;
	cv=none;
	b=04ND5kX90VMgXH+jje7ABbUbKAOiwd2mJSq3XRrE/Yv6mA62QojFbEh3GpaKARWRJNC3V+
	dZAVE0HJlPT1vPgLhW4AEEQ35r7+HlnHa7cE1demgDn7vXyC6OSs0bAVdn1isL/uB6Zil9
	Kr9tPiTwwqZa6IF0V3ZXEWNAnJQEvdw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27CA243C76;
	Thu,  9 Oct 2025 19:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6511C4CEE7;
	Thu,  9 Oct 2025 19:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760037822;
	bh=kN26N6ZmdmvX5qUDg8eseKZvC9NjXY9htPd4izOs1eE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=W+qzwOKD7LRnjfSpXzUu6om7UswEqD8HLdCsM/+u/n8oO3rdwUyqIOEEAsn1wcTWQ
	 ux2WxjE2f+tixZ/NzFmZCgI+z8Vaq6eITcRyuiGr/sAh47UFRRDYEo/0C8RWvxFrRq
	 JtTFYlNRn9Fd75WeTsza0G11QZ27dDhBZn7xE/HU=
Date: Thu, 9 Oct 2025 12:23:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, Linux Memory
 Management List <linux-mm@kvack.org>, Miguel Ojeda <ojeda@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value
 `VM_READ` in crate `bindings`
Message-Id: <20251009122341.fc4a804c1893d987cec75567@linux-foundation.org>
In-Reply-To: <CANiq72kTPjukgmAxDfLg2s4JHdaKaw=bY4DLVjTr7-9bqv5D3A@mail.gmail.com>
References: <202510100127.yuqhg8uo-lkp@intel.com>
	<20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
	<CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
	<CANiq72kTPjukgmAxDfLg2s4JHdaKaw=bY4DLVjTr7-9bqv5D3A@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3DD66C0011
X-Stat-Signature: y88gkh1b87xnjwsp4k6ep6e7b43h5p84
X-Rspam-User: 
X-HE-Tag: 1760037823-490461
X-HE-Meta: U2FsdGVkX19EHoDG321OI7XD3OKkeoz986BzxTvr9I1F9i9ZZzwLIwr+3JZ+2ZviSadRLH3IkEyxv3ymTSYEjcUrDVXg6zLwkOcnfthD6kFHKHyHEpbWRvljqREyER2plbIVUGTO7VvmzKZ3pdlXMtNICMGmV2wTIHD1WTEtrj3oDj3yQh28mf1Sw404OwI2dzzK4yuGvaPAs5k45sM43QbU00FyF5ZzL29VLOWiO32ngd2GmEUX2V50Rl8FrfqyxYNRoP6rd8eM+/o2XsyprV5Dj8HDW+orHuIOO35UME5Ay4nVN4s1o2+/4DbYY05OQtJgmUf/UEnPPpw94syYyOItZnEDy83W/xxq3XDDL+mPK0M7zCHyNtIuZzD2keQwjTsbp4B7hP/GSYtCo/uwR4DYyhA6fxlLzdWWFvnDCwY1wyl4D0KtGoyTOLcxdAJ0vgC73MofZx74elXrbSWPt7S3QpSC71p68QP9WaZpH+aRmdM4/hkkcUH9UWIaXuVgOwuzAEM5uM2ZFVrY9TWfH40YZBqYWZxIjZOf+iBjv+5O6hhFxOxJPgncDxVQOmj7euz44HLGaD3HlPa7VCJLoFwcKCE76rNIp+BsAG+ixjQH/7DHvBJFHFL04Ki9s/StRXvT4JD/ARNnkYkA35YtwpyOFdwfWH3fsG2v/QlYd3HsQ/coL07hE3FXkN36mrBgJFBRmsd041fQ0EOw7t7a3wLeqKQTxTCGoqAnZewFZ+KSEcad/rUgyKTdB4XxQOHMJRuiVkdbMuDUqjTHfBX6bcKlMaTEHmNzPeF8AnE2jPmWxHH8spp+cj0L0JzHXkkTTKOZMxUMV5NHXr3xH7kt1vZPBbxjY7JcfVkdtTkiKdfS17rg6ZrgKAZu7NcT+gX3SOfyHXQ99y+AnIYQwAKrG3LhrErhI6csIeimYMmidWsh8KZ/aqHbxmT2i7MLtHdyrCcu4NG7OYIS+Kwrmnk
 R+POEKuJ
 p7cgHS7SRTLupf248tIz47WVrTSo77dp9tZkFTIkBkg825xNCthX8tQR/CBJh3nGsvzBLfNsrahUSW3u7lcwSj3+iuQeofVniaAz+bwGw24yNEfiG5fUUgWArgAUIbDvC5Vg/uxHSp4Yjh+kj55NsjOcrHOZWaY8E3fCOtnr9T9eb6A6tOQf3y9aBoqX9k/qD7LLTJ5VZCZaiTmDSe94uZip98Jo3o24WjKGlFzbRJyEkKgsyiHOl8qJJ1+63l1HuNhJ887PMDxgKdtrDd+nF/l7B/oZvGRy/Upa4CLX/zwSp2icB5psVu/HiQt12heUhbunxamVLjJtSu4j/n+RTURPbuGgpmNxafMKSdLqwD+bHBqUAjawJc4HU23pn91JHcfGZlqQ502cdoW45JgMXDE9RHc9Jy04NZN3Q8JcTdrEsVfToC3hl5DR5EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Oct 2025 20:15:06 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Thu, Oct 9, 2025 at 8:14 PM Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
> >
> > We can either define helper constants in
> > `rust/bindings/bindings_helper.h` for the ones that the Rust side is
> > already using (like last time) or use `enum`s on the C header.
> >
> > If you have it in a branch, I can prepare a quick diff for you to fold.
> 
> Should I test on
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new?
> 

Yes please.  That's the only place where this patch is hosted.

mm-new is for "new" material and is held out of linux-next until the
end of the merge window.


