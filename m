Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640B010706CD
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 11:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5439F6B0088; Sat, 14 Mar 2026 07:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7426B0089; Sat, 14 Mar 2026 07:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2EC6B008A; Sat, 14 Mar 2026 07:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2917C6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:13:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF72C1CB78
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:13:01 +0000 (UTC)
X-FDA: 84544406562.23.EBFD932
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0ABF080003
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:12:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ApPNi2Qr;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773486780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIPbxpplztJ98dmKf748os9rCMdBdXDDUYp1lJqg0xg=;
	b=bjWmzz7vozfkorq97b3CCS/1PsjD7gkupIpGYxR/VdCzoXTFgBqvmMWm0z0HXLDAxTbFU3
	CY2CDArH2wqBpulMYXx2X8HOP39rXEl2HtFNXbdtkxNoN/WHBYl8oQQKAHdA/eY2e9wP64
	UENmNEjpH4hca7yyQa0ec09psUZlMjU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ApPNi2Qr;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773486780; a=rsa-sha256;
	cv=none;
	b=4q3lT6/K48yMNIyw6H8HOwHHU47mHutqtERl5C5L/33TUT4KNGdGd7tsurrRXBoENjNBPi
	FE9mX9oKwUc1TGaCwPGfYgcsAdbCjTMOqGQgQ93gSjP1n6ezgQr3rPAO5MBe5SGIL24GGr
	YohBabiBhsIA6mRk/Wtr/75Msxgj3Uc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2471A60008;
	Sat, 14 Mar 2026 11:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443A0C116C6;
	Sat, 14 Mar 2026 11:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773486778;
	bh=bKZgkQ8etDggV80HuQ96NEUcvwYN6qN/KoeVQ755JQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ApPNi2Qrdc2RtulNHbM9QHU4+rTPcOudvlv+6vD/0EwmgrnVGYq6uVB0D7g5nzsOr
	 K/8bg1ZDpM/8LAbLglq99D29CnGwk5hlQCZ5I2wBVK6+JAdeoEoC+oCtH/100JjOav
	 4j96FOH/9Yd9FW1tPxWaJwWQU9YrS3KU33oQBnyA=
Date: Sat, 14 Mar 2026 12:12:53 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Mike Rapoport <rppt@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Mark Brown <broonie@kernel.org>, rust-for-linux@vger.kernel.org,
	Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [linux-next:master 5585/5731] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
Message-ID: <2026031422-catsup-rectal-f886@gregkh>
References: <202603121235.tpnRxFKO-lkp@intel.com>
 <20260313213638.GA147391@ax162>
 <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0ABF080003
X-Stat-Signature: 3g9tchcou66y1aabep95p987xhy7e38h
X-Rspam-User: 
X-HE-Tag: 1773486779-296497
X-HE-Meta: U2FsdGVkX19ptRPf7uR6HoRNUZwbwUaJgF2ORS69V9vdjYb6+7StA/zn8IptkD3mzS+rMDYmrTT/Vj3C0TkuIv1w21+Je2OH0cNfwVmv1nNF+nkDPPdlXWhyC/Ztdpq10LWGrMzMpN70jQzD2VFoz1WywxmqdXoFi7hDWuggEQvYelSOQBnNdMF2AWzqzFCMwEiGZjqFFdtEnfIhVkt2ISa2vo1lGsKsO4MMEwXAfpjqpVvQIXKNu/va4l7bza/Uk4ZVDQHQM3y9aKWfEvcsvxbPF/yaaisGX/4VYrEFuOSlqvvrigNqCIV3DR/L8rJXMz17MAkdtH3Ep8QVqc9AFzkfEqJ9lkhZ7CWFNN1Sw4q8KzvDgkx/fZj808UlxD+72QrCYuGFtZ6wSWgVfFVP0B+1iASe31trn/08GKyui594M/lc3XuaD1DN5v5DvNwMRU1vK25y6CfAV2JyknZtt5HMPeVb7QCfjdBfoDQa0vh7b3HVJW/ekSEjNbZfOQm/Hp6IYHjohhovWW6YQra8BWGkIiI/VHDMaovDm7JrtCg6Kc2HsiKcF/rNwAWWYQ5dQq6PVNDyac/OJeRbriE/5EtIHaznSN6w4fjdN7LuJLc928hJQ58gzkmZwLsnY3Irtsjj79I03L3r6V8P/nl32jrsENfiJi+rjaaDAkmMoumfAQx+9EdX4zcJJqrSHjhiV/ruMhP5uquzapH5UHnu76QaelVmdS1YdGKlUoHjLYV+sKQaH7bfiyFRZ1DMbtujvtA7XzvAJ0iOZ9xw0ICkAw01z6Nq2h4qmR3VqOfkaQCS3kOrlkCeaTrv78/snTiqBF1hy+c3Wfv/O6jADqt562efEq8yjAXHZynKK4PPNGTlYOmB7fcSqK1VIhPf7UP5/a4ODz72vSqYPSo0++hj+VFgZuV3/4VXe1Ar1Vsre53jnKdDOd6qRO2u/tHznRn1mmR6q5lC1NiC2QqIeIO
 P9Wx7TAa
 fXYHg+wHC/pEl4GLku0igZDEpHYIZvKo+14T/YzpXPhld0GKKMzQLOU6E4Tub9RXZXsAGF7RghRfCPuVcuBfJgagxlSclLAzdcckk/YrRCQ4y/lyLotUHisB61N2DoMvjJV5F+uxhIn/V4Xk6xzaeh39K/p1jVAxTvmhBeFYZ+ZKvAUwXBilnrYVAQm2zM3g/Uazv2XCn97WNv0GEpQjlGKY8JMU36yqMs6jn+bBhSA4xC8F1ySL8YaSvHM5MAQfwKmzX9Xuqmxke2Hri3EksDqsmUECZnixgKNi0xawVZ2FAyz1f3iR/xAJeHOq9TfExCxArtgByc3HDEh6wX/5gVG8YBA9SGGWjflWaSzf+kZ5mbiaVZTbIJQ7ZpBG6qYQntdYeocH2sMi86wi0RlFjMOtHX+NkanrgNhScloJxPowJypXceZ9Pp+bEGWoLZa++MKy9Jf0DzOODxN+vgi86l14jO83XQypTI7WH8KWq2bggt4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 11:39:14PM +0100, Miguel Ojeda wrote:
> On Fri, Mar 13, 2026 at 10:36 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > It looks like this is a conflict between Alice's "rust_binder: check ownership
> > before using vma" [1] (currently in char-misc-linus [2]) and Mike's
> > "userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-unstable [4]),
> > hence why it was bisected to the -next merge commit.
> 
> Thanks Nathan, yeah, adding a raw pointer (not function pointer) to
> the struct makes the type `!Sync` in Rust.
> 
> I assume this is best handled with a patch on top of char-misc-linus.
> Perhaps creating a wrapper to assert it is `Sync`, since the
> `BINDER_VM_OPS` contents are unused (so far).
> 
> Cc'ing more folks related to the commit.

char-misc-linus should get merged into Linus's tree "soon" and then we
can fix up the mm-unstable change for this.

thanks,

greg k-h

