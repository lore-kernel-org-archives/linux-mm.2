Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784D6CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 15:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90108E0008; Wed,  5 Nov 2025 10:23:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67388E0005; Wed,  5 Nov 2025 10:23:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4148E0008; Wed,  5 Nov 2025 10:23:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B83D38E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:23:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 536AA88817
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:23:49 +0000 (UTC)
X-FDA: 84076923378.21.DE60A52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A14B4A0016
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:23:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMrvcThp;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762356227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwXrGHR7YxtpuyFp/BXZocubvmjRwPrv7rU8FbTpQyw=;
	b=Mh5Kzt7TEbMPnIvuDSOQALcnGK8IMnr2oVlJOhrmqVBP9yG+/c5wFdHSk1JG2ls+297QRL
	iB852AXOsUyVXzdMt39WzMU/leo7aaeFQgaFj0t+aFIoQmCgtrx3VHT5uXz5mJzhiOIA7B
	zkRRtExi0wWdZyFeWsdnS9RMTCPDNPA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMrvcThp;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762356227; a=rsa-sha256;
	cv=none;
	b=8iC8VMi0s406DN0vZxAOeCdgMZiO/UHMWFz4h0KCxDo/rif1VL0WlB/4JK2sigY62sHWl8
	3m/9spz+FPBnD75UalrDhhAUwIlAxjaQtX4x1vjNGiql5cyh7R1CmISt5B7qaS9CyEnjQr
	iauL938woh0gzLoruu6n84mBAzfkxLA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EBE606021E;
	Wed,  5 Nov 2025 15:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE3FC4CEF5;
	Wed,  5 Nov 2025 15:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762356226;
	bh=kUs8Lv2NDX+HzCDICX2X7wBuseMdW6bT2eEf/zscT/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uMrvcThpY3YAAbWSY9xnzagjiDcwxd3DE9e20MpciQ0mHPg3Rf2Ci/61aau+E4mQM
	 8nZgzHXJSUUcSaMnT3I6e/kc2OTFqEOU8mhgloW70El8EVP4uFuINodUwyZYdb4wN6
	 1lFZyctatEB0Ly2mBkqqT1g1f5kszp3d1j2Gfcxbk6+UPzncHihdjKp/ahdU45prxY
	 rmgoXHjD8Oya/yhaU7KPl20KhLjgM4879Ne2XzlbiGqEnxwVLMRrnoxp2UrzmMsOXc
	 mmWDqocG56Gn6iM3/+Xaa3pHugJb+dKTjiXrnAV7pXWqqp81/F+Ra04o22uyDpfK++
	 osL5X75ZbKhQQ==
Date: Wed, 5 Nov 2025 16:23:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, jack@suse.cz, raven@themaw.net, 
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, borntraeger@linux.ibm.com, 
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251105-absatz-zehrt-8d1197f900c9@brauner>
References: <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
 <20251029193755.GU2441659@ZenIV>
 <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
 <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
 <423f5cc5352c54fc21e0570daeeddc4a58e74974.camel@HansenPartnership.com>
 <20251105-sohlen-fenster-e7c5af1204c4@brauner>
 <305ff01c159993d8124ae3125f7dacf6b61fa933.camel@HansenPartnership.com>
 <20251105-ausfiel-klopapier-599213591ad2@brauner>
 <ddc9e2efa25d59ae7f1989ac155b9a9043ca830b.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ddc9e2efa25d59ae7f1989ac155b9a9043ca830b.camel@HansenPartnership.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A14B4A0016
X-Stat-Signature: sby3iuheccz8uce95feh9nc5rzj7rurd
X-Rspam-User: 
X-HE-Tag: 1762356227-572795
X-HE-Meta: U2FsdGVkX19K+0EC4HsX+pXyBpCHODeC4iK9IviO+JP3j2CPbf6/vmbq67cyEgoSoxwXWHLwIZsaaQxay0QMCUkBjQMxs3oRSYJdFL65mXKvTftqVy6O2h5QbuihRcGjKk0sGBGYVonZIdBNvqBOzRMeUfNScE5VOpFyH4qwuFi46b6YL60yA1cMlw9zoEZF/0Fjm/b0Po4xJVTGURHur2AuPUuk5ko/78aO6/o76GddKDYhrPxk/Y4PUmvx/mhYJKI9SmZwMcypCVdS45Pj1Cx7XXkGu94tWH/s61WK1VCqmuQoU5Y9wUIjh2BaR78kpCVbRXfL1/PECEsH++eVY4v+mvhI+Os2HLIHcrcyqzKnpDEBpQCxYhO0AuefXbyyM0SEAbe9QCRg8Z67zTvm4657QZgdNo9Oz7MjOX+2NgLxHxGifKILtmeIwy6e46+wQWUOONO2k3wau2/TXH5dPUTteopKMtiVjUJ9it72c4BIBAPqih0x+Q0Iy1X8eMaM/RXNLT+enIZlWgFCau9mA+zREm/lRBMNcjLMZz0I3mvlYvTsl/As4yD19mLabOEhWntjMV6vq73ZlvJgO5Eg0+XysN/EC9HB3jKhDjO7rKWkhqD5tGVnZRf24nRfjEM7H0qjUJlCx5Spqct4P+RMV/QjEhY68BvXiNd9lGqpdfZK9R6j09EVk2DwFvlDB5L6q6T71yAb3gGeuVc5gAgwBgpw2rR6j4S1ArMeS1NzSCtqdNx2jSwEEn64OtJR7JBwo8QmEuAyuLEJGzmGYhDYrZHgGZ5HeaOU+56BQXhSmpv3VXMr00BCnMTh/EXhK6dsLB05B8i/7AEzvvvgQopkEhZhzsEKMSakEtQJldiGTT9ok1a9WM18zg7YqU5SSD9LF9N/5L+GbxXk0R+lb8OgEFINQsWcB142oY4SXmGUzZZZXAGrOLYbEmNNFcCDuz4zF/wH0wukbnQHk8pnJoE
 W2h3bE7y
 /haoPZcCn0JmcEjkR0kSKIvRyfIFTodVT74QSDpuNHncvL2V8MMU6y9Eygng0K1OsOHAvPKPvlLMFyfhX+MIGitpjm6mhT0hsNHy0zztx2G/h6HadWnVtELu4DZKuoQkM8B8Z56a2HvBSk7U7++EdPxrK16JqFprsHFLcdl59Fi+KZJgtyTMRbjV3eqrPURdXs6813FZaZLmUnjTG18dtCW6/T0IsndnIbiWzENwQBEEP+7MbwfTr/nIHIagjSIs3BfZ9JVIhxkdn5K+Uly3RUhfMDoq9UZ+xkRcHZ3W9zVebSoE59pG6Eb1hGxeaSqduXxQrsl8dW5dp1Vo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 09:01:59AM -0500, James Bottomley wrote:
> On Wed, 2025-11-05 at 14:46 +0100, Christian Brauner wrote:
> > On Wed, Nov 05, 2025 at 08:33:10AM -0500, James Bottomley wrote:
> > > On Wed, 2025-11-05 at 14:16 +0100, Christian Brauner wrote:
> > > > On Wed, Nov 05, 2025 at 08:09:03AM -0500, James Bottomley wrote:
> > > > > On Wed, 2025-11-05 at 12:47 +0100, Christian Brauner wrote:
> > > [...]
> > > > > > And suspend/resume works just fine with freeze/thaw. See
> > > > > > commit
> > > > > > eacfbf74196f ("power: freeze filesystems during
> > > > > > suspend/resume") which implements exactly that.
> > > > > > 
> > > > > > The reason this didn't work for you is very likely:
> > > > > > 
> > > > > > cat /sys/power/freeze_filesystems
> > > > > > 0
> > > > > > 
> > > > > > which you must set to 1.
> > > > > 
> > > > > Actually, no, that's not correct.  The efivarfs freeze/thaw
> > > > > logic must run unconditionally regardless of this setting to
> > > > > fix the systemd bug, so all the variable resyncing is done in
> > > > > the thaw call, which isn't conditioned on the above (or at
> > > > > least it shouldn't be).
> > > > 
> > > > It is conditioned on the above currently but we can certainly fix
> > > > it easily to not be.
> > > 
> > > It still seems to be unconditional in upstream 6.18-rc4
> > > kernel/power/hibernate.c with only freeze being conditioned on the
> > 
> > I'm honestly not sure how efivarfs would be frozen if
> > filesystems_freeze() isn't called... Maybe I missed that memo though.
> > In any case I just sent you...
> 
> We don't need to be frozen: our freeze_fs method is empty, we just need
> thaw_fs calling.

No, you need to call freeze so the power subsystem can mark the
filesystem as being exclusively frozen by it because that specific
freeze must not be undone by anyone else e.g., userspace or some other
internal unfreeze due to some filesystem (for other filesystems this is
very relevant) internal freeze for say scrub or whatever.

If filesystem_thaw() doesn't find efivarfs frozen - and exclusively
frozen by the power subsyste - it obviously won't call the actual
efivarfs thaw method. It's all working in order. My patch should fix
your issue and will ensure efivarfs always runs. We wouldn't even need
an SB_I_* flag for this. We could equally well just match superblock but
other filesystems might need or want to opt into this too.

Don't implement thaw_super() yourself, please.

> 
> Is the trouble that there's now freeze/thaw accounting, so thaw won't
> be called based on that if freeze wasn't?  In which case might it not
> be better for us to implement thaw_super, which is called
> unconditionally and leaves the accounting up to the filesystem?
> 
> > > setting of the filesystem_freeze variable but I haven't checked -
> > > next.
> > > 
> > > However, if there's anything in the works to change that we would
> > > need an exception for efivarfs, please ... we can't have a bug fix
> > > conditioned on a user setting.
> > 
> > ... a patch in another mail.
> > 
> > Sorry in case I misunderstood that you _always_ wanted that sync
> > regardless of userspace enabling it.
> 
> We need the thaw method called to get the variable resync to happen. 
> That fixes a bug on hibernate with systemd (and also accounts for an
> other efi variable changes the user may have made between hibernate and
> resume), yes.  And we need that to happen unconditionally to fix the
> systemd bug.
> 
> Regards,
> 
> James
> 

