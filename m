Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5B2D2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 20:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9006B0005; Tue, 27 Jan 2026 15:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476756B0089; Tue, 27 Jan 2026 15:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DFD6B008A; Tue, 27 Jan 2026 15:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 22A7D6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:13:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE01114037D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:13:18 +0000 (UTC)
X-FDA: 84378843276.11.A347001
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id B533410000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:13:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HEJ8AHlZ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769544797; a=rsa-sha256;
	cv=none;
	b=cDHG8S49DVOrknlJh+GBRwWlpdauppze1C21KWGHqw5R5QcHZzUl35QuE7ML0Z8Ng5aHA5
	DREdQeZJ0/98RvW0IuAsad0dFQq03yQFItzgch2tjNIZs8YZPiCsSKGhAcCKgGQy4SvmyA
	UwFPFfbFBjbkOFl8m7UvrSwe43EhH4I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HEJ8AHlZ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769544797;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BThmTYQxvIJzQkA/L/WO0umKgcoH0NckbPSOFRkaDt4=;
	b=aEAlWjZO+CpDM3XLp4dPuHr5BEpXexJtSfp2JpowNfumzfpVyKMDcIkyGWDSfSXHM89Y/c
	dy9b7wLkgwVAPfPms8oKiDLvlliliCtgD5SXkhKxPqPMij3lA5LExvHO9fjdKmU2sLawIF
	qnuC5t9g/Zee0iogV7n185FpX+fvEO8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BThmTYQxvIJzQkA/L/WO0umKgcoH0NckbPSOFRkaDt4=; b=HEJ8AHlZg14JJPbg8QtNWS1ji2
	tJT/2Fs1T5x5ADAyCAF83hSNvt9o3z0K3RSxk2gUB8Da5/tSbaBFKwqw22nB9KSBEdLXuDL7FqPew
	7Y+0P4xYkRhvZjXTFdCSvNynNniJgE6ZN0ESEh44Vc7Ehkj50lCswNvXEYERPQvdfeH75yQduHjQN
	Pq05K/lmA3+K8RokHDK11A0sXSW/FfXFcjSMTd9/8b2Gfp8Iz6ORbZwkKjtp/91tEjK8DcKs1Smzh
	pMHt05iiq6RxHZG8nxYrYmxa8r2p827g4+Rly5OrSWZkh9CWcaNv1tRLRrbeWiJeWu+s2oV5wvc/f
	Bx+2nTwQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vkpSg-00000001D3Z-2Fqa;
	Tue, 27 Jan 2026 20:14:54 +0000
Date: Tue, 27 Jan 2026 20:14:54 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Samuel Wu <wusamuel@google.com>,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <20260127201454.GQ3183987@ZenIV>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh>
 <CAHk-=whME4fu2Gn+W7MPiFHqwn51VByhpttf-wHdhAqQAQXpqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whME4fu2Gn+W7MPiFHqwn51VByhpttf-wHdhAqQAQXpqw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B533410000B
X-Stat-Signature: yzqz63nnnaz1wy9ryrfx8fmnihpgs4pu
X-HE-Tag: 1769544796-996566
X-HE-Meta: U2FsdGVkX1+1fZWwuFeDycDEXTIOkC86CSXTsEZuGE8JbqoICyLiZTYjEt8u6vI+7Ukcs6fBtB+hx1NuOPZmI9/1+E9BTRVE0z8+DX8204JXzP+4rZ/yuhDN6qKYpvIIOO3OUdeNQ7IcFlcxSJKiRJT0ZA8zEHro3g+sQS47/b95fxCAxwcGNqeJjUfCHk/+m5nVNLDT86h520YUfvyOET7M2mNAMcM1LJQ8Q3c24RDFegD01La+T+7zUZEOskwqBdBRTnmcnpevoJcc4PrcxbUQZUX4azvUBDkgblhbiegYXJC+zEwSE5LNfDD4KC96kTdDBnbqMidBUyR17HAlh/KywuDiEYhorjskf8D72PiYcitWVrl4S+h0t6YIy1Q0X/xsrYjOmqu7Vz/+xWfNcg2JqnUrEZdpBh2477YsF0MDvrESzpt4GBe9sLBC3hIZ6Dtxd2+WpFfdj1QyJhC28fIiVGqsHeqgIhA323B2ge5Ea5gXub/08pglaxbenVGI6fNCN0kvxy7vjWRS1yar9gEkfUmNGh14OrCIrPehEIpYaX0Q8MGqoTgDlq/w2xasNkIQ/IvvI04SwED7/h7izP8uqjbPT7ds9z2//ffxEt9d5eJxfgyvP1OQtvlv0s065PRNdv4ZKTftKb+RpVe6XYzjPXjVx+5uT6+ZP/UUkZ8RoJVm4fkflUPOzktnaY+rBO714p/FPwB3Ci1BDE0faDiRwmoslM0tE/B4ZY1qcav6nKymsASHmmc8EJPRJV0EolxyP7rj6wV5S+b0M+Vyg5y5mqSzLZlH5zmlsAErC01L/96pYndkx/8h7XhOWALrk4sQYLIPd6XhPuaJgTgBKNEfr5oKzE8hJxjWQdp2z259902uS8YwYnroMy+FaI8AMg7NNOdlQlrRmlDFFUw7PaG+d8MHX/pHtKig0BmbRO5rhqoqyNvLLU2iFfdroG4z8FeaJWq30k3480eXsVj
 C7F1vsKQ
 CJWU7GZaIFyNSvWjju4zRGCNbWJ181EFArhKP9w4Eq3Fxi2e2FiZMFRfX0+HRDXoRgN40hebxBvGnMzhqgjNbBTtq4AFw6v/fy6RmiHiHPRdxbt1gGnFySIb9Eeze2LTa6IIPE1NYay6KHrzeaSnpA3BPfY3WWL9v6w9McA2EzvBTByX1826i9gxIfbBX2xFLJlhpDQVw9zb/KAfsfzJSnq56uOzOlUbkENTjfF0Q3SfFSvBOBoCVxgLEBKEx9Qr+3h+l1eyqEzPH2GmhfQbjSXVITEJ5xC5TtiiCaP4IxrMTAjY/Rame1l7GlqIHCLDMLw+I/SffPfBFmMHcP/Ci0uwGkAa7PIKdDmw8I3+u7gTTGGrcX8MVDr9sJj3AzPZdoYTBUcRQN/AJYjpAKp0jKzOsy0kNL7D1BmwowH95YmjUHSzkrZLEvQwE35pq/nIdiWcqehjIsPlu1Ctxv5pa01m49Hwyj1X5P2FUDMeo5RPT/Rxd85pojTDRnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 10:39:04AM -0800, Linus Torvalds wrote:
> On Mon, 26 Jan 2026 at 23:42, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Note that I had to revert commit e5bf5ee26663 ("functionfs: fix the
> > open/removal races") from the stable backports, as it was causing issues
> > on the pixel devices it got backported to.  So perhaps look there?
> 
> Hmm. That commit is obviously still upstream, do we understand why it
> caused problems in the backports?

This is all I've seen:

| It has been reported to cause test problems in Android devices.  As the
| other functionfs changes were not also backported at the same time,
| something is out of sync.  So just revert this one for now and it can
| come back in the future as a patch series if it is tested.

My apologies for not following up on that one; Greg, could you give some
references to those reports?

