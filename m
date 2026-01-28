Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70829D35692
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 08:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D26F6B0088; Wed, 28 Jan 2026 03:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D2B6B0089; Wed, 28 Jan 2026 03:54:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD2B6B008A; Wed, 28 Jan 2026 03:54:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEB06B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:54:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20BA3B99F1
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:54:05 +0000 (UTC)
X-FDA: 84380760450.10.CAF00F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7AE70140008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:54:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=IiNsTsjt;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769590443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxcLHxE0h0tZrYY8m14TIbzP4neRX2cVHl04cabob+s=;
	b=oEPAAZkW7X5y5y/Clwz6nrDrDZYsaoOUHfwr77/KrWAhaB+nEAFbeGro7Yqm/VO2pIkG+V
	VXZ3upfH3xWh6CJKLu3Y/6FbqeGLqov6iWlC4i7k4Hww3PM1Y9J45RCXAsU8xMqMsitPwA
	RcXS/iPW1bq6Cmy1xOsVKYt2jMu02kE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=IiNsTsjt;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769590443; a=rsa-sha256;
	cv=none;
	b=gpyOUBdE7rtSaDeY4K6+qEZsVqFUaQ1HwL00WbOeWF+jj2W0SAQ+6SxsFiULJvxeyLJrN+
	zEXgTer+/nIuLagTizxbvKHMigAlw48KMh/fYDoYmRr3TVSis4L/yW1O6PVjCACB4x/NPY
	l8+kp53a3Kg0yuBDivG48FD8rvJjS4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68D5D60097;
	Wed, 28 Jan 2026 08:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B35C4CEF1;
	Wed, 28 Jan 2026 08:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769590442;
	bh=sp8ZzgKfLYBf6n5dvtaPV7JJtZoVmZtARJEfnOlvgnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IiNsTsjt7/JJEy7yHNve/JooAIlH0pnM87ZGvmgdHepEWko5EVz56NLPJSRbmXI8w
	 sxKEPaOCpGXqDtQ0OHpQYWN7Mt9VjqvMvARm+eLYaHLPTNohEerYQif5fI9Qezgjy+
	 G4XDfI/hst0WjbqQ1xzHMsJI6EzUETgPfOt5Yvr0=
Date: Wed, 28 Jan 2026 09:53:58 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Samuel Wu <wusamuel@google.com>, linux-fsdevel@vger.kernel.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com, selinux@vger.kernel.org,
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <2026012812-jurist-whoops-0ef5@gregkh>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh>
 <CAHk-=whME4fu2Gn+W7MPiFHqwn51VByhpttf-wHdhAqQAQXpqw@mail.gmail.com>
 <20260127201454.GQ3183987@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127201454.GQ3183987@ZenIV>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7AE70140008
X-Stat-Signature: 5jpanu9asysqo3ne9qxpkgagpeu7zsu8
X-Rspam-User: 
X-HE-Tag: 1769590443-594492
X-HE-Meta: U2FsdGVkX192oMe3yAleyYlddtpmfYDw0aqmTsWYCSd+zbEpDiPEx3f2QF+PGauoF6oI4cLnfRCdz94tDQlaSg9OfawTZr4cB2nf50n6PapSQfPOa6rYo1ED2BJIf2PedlQGphIKMx1txNk2Nc7GnoVQ4F3qWNhzu6xK3WBy1HjZVRjS9s4Yl0zlt5jh2pKvaWfVzfvnHKM/kcJqxBZROEsojR+SZ4N3bfSahDBHCUdn2tyx3enx900Eiz9MkE1eykVzUstkd2Pr1ixtq+mrUHP4e7GxyeUV5Rv9rWPCB0la+Dz1hKEWvwsuRdpOrY6lXeHgAIlDVhRydj9g+ucWGhxasUm6XI9c1Joz4FZwuIfmIqsxxc4KtlvhKWWnj0402s44Ijd40WEhMU7YDrwWgKVXT1IbFGyBXTSXVrUltf8hIOiZS1+zvUug9daWvLCF0Xm/LXM3Uql3cJUZ0ES3Xv/qWJxV+VMgIQSlMKS3yh5VswPXFAfUBi7zJoGeDtOEGZtUYydQ3n56ofO4a0yFg7vdwCct0t+vHQUyrnzfp/UNqxhrF6absOB87pz4PxwdZv+VZ8cDKYTuU2hfVljbqqTyHiYT+iR8sIx3/iI2x3QGW9iCqPzUJGy+7XUPuotKQIfACxzFPZ/zuGlo+rX0YDdIAjNA//m4O2m/b54+M1I/3T6MmYD9o1Q3g+4NVdllPdUO+NaJcWNr8qO9AfYPRYQNAnr3kiTWDW0B/kWNzhBC1nY1WsWoKr7RZ0LIkH6chUYP+bFhRtGkHIAUJPvp77DOukvkc9Fl2LLxsbJzkaNkCwoQuqaBGymacBFK0d1ZDGwMEwWfghE6PbasxLz3NG6k9kbn8CbE7PeCHI7YkATjx2Xa80N/Cj/GzxGfm1mLzMTPlgGkUm8lWzBZsAoI9qiS7slrQMdz7yApSF13TU05unZW96ysbdaKPWe35/UgxhzWsEfwHsONX0CU7dH
 VsX2YKYV
 SdI28XCPgoV6O2v6Z7sAIYQa+KWxTyDp62cBtPFeYVB9TrudjnIdClEcPb3jIrvtUm+OEvWA7ceLGfO9odzBIWrqtpKV1d7gfrue9DdDdE5YK5iAR9cp5iz0zXmZdo4vVgPu76BIQAEsvkeOaYrMHUlwU/WjwYVym4Ks5Ar5Dsnbo6DgH5WQiuem1+YB1cX6BW1doCmlgIfEVsDtfpUZzVGb/c0uIbx6dz6bA3jbJNQzyi8b4RvKAIQgpPkNAjoytZJsWyFNXcAVBz0h1lCgYUrTJhXnW+p7n15nf50dEPChKgeUnRV1PunbgTjVl3xrKxLqu/WeEYrXvL7+rEaYZn4ydIpvEW6TRRtyFvcWEJ1wSli0DCfGbUPsrEN/d7vo1E6ZT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 08:14:54PM +0000, Al Viro wrote:
> On Tue, Jan 27, 2026 at 10:39:04AM -0800, Linus Torvalds wrote:
> > On Mon, 26 Jan 2026 at 23:42, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > Note that I had to revert commit e5bf5ee26663 ("functionfs: fix the
> > > open/removal races") from the stable backports, as it was causing issues
> > > on the pixel devices it got backported to.  So perhaps look there?
> > 
> > Hmm. That commit is obviously still upstream, do we understand why it
> > caused problems in the backports?
> 
> This is all I've seen:
> 
> | It has been reported to cause test problems in Android devices.  As the
> | other functionfs changes were not also backported at the same time,
> | something is out of sync.  So just revert this one for now and it can
> | come back in the future as a patch series if it is tested.
> 
> My apologies for not following up on that one; Greg, could you give some
> references to those reports?

Sorry, all I got was a "this commit caused devices to fail" and was
found from bisection, on the 6.18.y tree.  Samuel has much more
information as to exactly what is happening here as he can see the test
results properly, I'll let him work through this, thanks!

greg k-h

