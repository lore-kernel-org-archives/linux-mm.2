Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926D2CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 09:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C3D6B008C; Tue, 19 May 2026 05:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CF56B0092; Tue, 19 May 2026 05:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A633A6B0093; Tue, 19 May 2026 05:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94EE16B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:49:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3301AA028C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:49:53 +0000 (UTC)
X-FDA: 84783697866.06.5A5184C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 307BF1C0004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:49:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fpkY4roh;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779184191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNnwDDOUJ1394AqcHybeA4vmOz66ffWjUzWugqQ/Rvk=;
	b=uAX+nmCxFlf0oC6cw/Mybllnmamb/1EGs80m9eqnFIC0plLXQpF3cVWH7SCNzJURrICnGl
	pe6jQwmCNV3FAeeL6knb8qWf0cHAx8ssTTetP6SadKf849dFZ32HzMi354yqx1Oog/cvXb
	vZ9FzYTxtl4baJJsU6cXE6P8EcBGmAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779184191; a=rsa-sha256;
	cv=none;
	b=nueoJUwMAlXwnuaVDHn8khToPDWok5ZN+vIJ95EFS3Uq9aoNzl8QE2pTDSl/UrW6RBHf7D
	CEaFRy5UbS+3ddLS25Nw+tYw8tTUyTVho8uWDG7N5jiQwd0TVuMgJMy24nLiKNRmry4fTZ
	+Xiiqnignd2iSLRX9/gI7RxxQ/iCEOI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fpkY4roh;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 097E740DB9;
	Tue, 19 May 2026 09:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE68C2BCB3;
	Tue, 19 May 2026 09:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779184189;
	bh=rX/Q8oXbMSySRNyC7+NzxKvhA/QggJj+c2IzhXKHseM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=fpkY4roh9gwMJQ/jVJi3hDMML+a3cbnvpqLaF97cSBRKOgbbXy+Y8WSlXZti3vTUB
	 Fn9CeEIFXwKnFGMEvBdNovTOsBxF7w8nHl5hrqkWxB9yWO3MJevoYnXFESyz1vQfUl
	 e/w3dIRwjxgFaaHxv7qVv72pXJO1k1rsXKYg2WsN4jh4lRjnjQMT5dLd7FThrViFLJ
	 b1M+b6UZh439sr1qotZte4TNpe10x6Vb5EsonDNamCXXoTNHqqaTCp0G3ctHQb3+4U
	 YcGcpn4r/3t1CUNcYq9kUP9R2cQHL1jhRAE66WWaNuHR8qoy3KBkXDj54mpgLkELUe
	 2pS6uOtblXl8A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 Pedro Falcato <pfalcato@suse.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>
In-Reply-To: <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <20260518-starten-messdaten-3b8aa670ec85@brauner>
 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
Date: Tue, 19 May 2026 11:49:44 +0200
Message-Id: <177918418452.771415.4371785688744608623.b4-reply@b4>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2611; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rX/Q8oXbMSySRNyC7+NzxKvhA/QggJj+c2IzhXKHseM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTxGFklVjj2q5u83cGqNCFNpGeZ+tsoozPNx7sMnYJOu
 TxQN0/uKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmAhvMCPDe7bXOz9ZvjF1ln8x
 o0FmwZbznJwWxiHl4qlCdTsPG5gaMzL8Pa58f5fkUXHb39d+yP34Ov11fFyW+OTZO8zU7+6VmfO
 CAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 307BF1C0004
X-Rspam-User: 
X-Stat-Signature: cpm5no9oo4k9eogqfqzxo15gnuf9h4qx
X-HE-Tag: 1779184191-447065
X-HE-Meta: U2FsdGVkX1+AktReK0lf487zJh69U/Hs0TLiCHJKtSAV0IpBnstw305BgZG9H3pTqMQeO8d8R+VQlNIczFPQYKYLgF+fiTogobD8w4++9hnBqSJSmG8h/S99Xx0/sSs8CPUw/icdUVhNqoqyZ943H5CxxD7b27I6EXZ/5U/edGh2DBmlxpFeeCKmFLH3sOJlc/OWz7uk0bFfFgq07nJJ03DSm84E5QjZE0XkpbJqNbEXwfBWedDfk4esBpoXRocWVTbKoTHu18nyBNaVlotub/IxiBL5k32NcN24GrdSmVA5X8cFAastVi+NB/qzWNyjElBQOyYcKUdkwM/8gIRlXls1JPhzZQDWaHXWDT1xNrynMADsURsNlxN7xWLP691oerT4opAqbhDHZzj2DF6m5ef/yqaeymigoCShMYMw8cJbbr5/Lo/AJ0BCjYbmUKksNS3X2qQxta9bfSIEH6ckh6mXc+GWaENhP21uIzXMbM6jmd46t+cIWmdlc+7aYVQeQj4GsLeT4rcxpX5MOOG9u4fbmZxHhq1R+4g7AdNs3NgytVlwo3/jyqjmmjEe2Zs3yArEgkYHYpJrAuYumfIYIc9DrwPiabGhDy8SE10HV7T4SDE9wayvDv0h/rPojmraZLMTyGNgRHZyjDkh9uMiuLCr8cf2B6ehxXzfwXKvBKcAg+joBjfB04bkNy9gH//1EdWkIhsHlg4lBaCQ57mIp1riry0w/mm+8SQSHQeCvvFOqki/A12tcUn5n43pBenHfVe0yvdBhfIG/XFxkUjrSHgDoMK9yF+KtzJo6QWufHEwrRgDIw8f6xxVZtzeSHbl+BroeCyNav7LFj4yHGdDEvUVn2OjjwdHM4T54p8ZHug3Q7V6tAThY1k9N/LADlCmQB4jYDXrwB8HEcGW1gJ7hcMRGFyjpG0h1Oh8p+CEQgCba6Isxhc162a8h8IVXl5TvqvnnQpnXVMbMMbp8Lf
 gMpp1Cuz
 c/wxnCPp0tc1noZTTbTau3MCnvaS28i5n7AeSo287l8A1gOAxIB4i4akQLZHlWI9E9bbiN9GmxzpxW7cpfuXanS7vyP6irFAZHmZIcNognPICAWbye5DCa60H2SRx8H3HpjWpb7Uc5+txYFuCydRyov78nPsAw49QFtYPUxdCdKH05jLcCTp8Lv1eXvXzvRrEE0c1PAkexXyGQRsJ5+3UidZ2wWivQV77+rhq2S7ppe42c2+mcQwxH3ZWeUiObcT4zo8Tzprz1S4EhBu65bB35pTqc0G2HMPhqz5x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-18 20:59 +0200, Jann Horn wrote:
> On Mon, May 18, 2026 at 2:30 PM Christian Brauner <brauner@kernel.org> wrote:
> > On Sat, May 16, 2026 at 07:21:26PM +0100, Pedro Falcato wrote:
> > > Since the advent of vulns like Dirty Pipe, Dirty Frag, Copy Fail
> > > and Fragnasia, splicing a read-only file is fundamentally unsafe.
> > >
> > > As such, as a mitigation, add a way for users to block splice() for
> > > files they cannot write to. This eliminates this whole class of exploits
> > > that use splice()+confusion in pipe/net/etc code to gain write-access to
> > > files they can only read.
> > >
> > > Users can simply toggle fs.splice_needs_write=1 and suddenly splice() will
> > > refuse perfectly legal splices() from files it can only read, but not write.
> [...]
> > At that point you can also just ENOSYS splice() and vmsplice() via
> > seccomp and force a fallback on non-splice codepaths that userspace has
> > to have anyway as splice() isn't supported unconditionally.
> >
> > It feels like a knee-jerk reaction to an exploit class originating in
> > buggy modules that we have little control over and we would extend an
> > API to users that is really difficult to use.
> >
> > What might make more sense is to add a splice specific security_*() hook
> > into the code so that an LSM can deny usage of splice in whatever way it
> > wants to - bpf lsm or in-tree lsm.
> 
> I feel like a sysctl for "disable all the splice-like interfaces and
> zerocopy TX" would be reasonable to have? Either by blocking such
> operations, or better, silently downgrading all such operations to
> normal copies.

I think blocking isn't going to be useful as it will make it harder for
distros to turn this on. So we should degrade.

> FWIW, vmsplice() and splice() are also weird in how much memory they
> can implicitly pin - if you call vmsplice() on a single byte in a 2M
> THP page, I believe you'll implicitly pin 2M of memory...

You don't have to convince me that it's a problematic api.

Let's discuss the other aggressive alternative: Can we try and
unconditionally degrade to copy. This would affect sendfile(), splice(),
and vmsplice(). Worst-case we would have to introduce the sysctl
retroactively.

Thoughts?

> By the way, another bug a few years ago of a similar shape was this
> one - also a bug in networking code that can lead to accidental writes
> into spliced pages:
> https://project-zero.issues.chromium.org/issues/42451650 ("ktls writes
> into spliced readonly pages")
> with fix: https://git.kernel.org/linus/c5a595000e26



