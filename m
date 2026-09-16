Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2843BC982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 07:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5D36B0095; Wed, 16 Sep 2026 03:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCE16B0096; Wed, 16 Sep 2026 03:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4596B0098; Wed, 16 Sep 2026 03:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38D406B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:09:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8CFDC0622
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:09:55 +0000 (UTC)
X-FDA: 85218750750.01.B56B78D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CF2D1C0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:09:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7SwAZ5T;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789542594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2gx8+1v2YG2nXZ5rZ43ZGOVbgNWYwB+4lHcBSPfXX4=;
	b=19+csjKA5hSDRybM2Gh0sb6SbSLMegkZzIj8PlvR1sreK8C5ColPFcS89IG6wD6G7gFmyY
	F3s9VrZhH5SZPpBz0WZVAryxZnHgfutO3CepwJoX6cQmelsg82OBybx79ZBukEeDX9XRWm
	YxKzGZZJyA/AELT/uiGxUMJZFS+/iFo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7SwAZ5T;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789542594;
	b=olZc8hX10thEnq58oIQp9BvqTrGjiVmmqsIYMm9G7LbfwMEXQ1+7WF1Q3WS9izG0VWZ88U
	eqm0TJD4uExNBVH1yl7ABRUYzg/a76NBPYbOQ9yiXus5C5cDMzjG0r35GuSwkpSbaMXOuX
	sanm/i+FVxOo4+1AXvtkNsDZHzSo9R4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADAFF6053A;
	Wed, 16 Sep 2026 07:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165081F000FF;
	Wed, 16 Sep 2026 07:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789542593;
	bh=p2gx8+1v2YG2nXZ5rZ43ZGOVbgNWYwB+4lHcBSPfXX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K7SwAZ5TQox94KhnzDZgdWak9JeascnEJT6tgsdFitx13oH/yvHVurs3emFIQIidi
	 xcR0gIE20GLza50nMYtjBg//0e7WD22sTKu3OHciVTO0Egw6dpfNvS97BoC4LpWgvN
	 ZD0aZmUahuws0zfu0FGKie6dskhpn2wDFZH1gLvxR0Y/XLP3PDKD59Q3XEFPNj3iGd
	 l3nMpo+kKycUGKylVUc5DFObZlUBNTgMifgw32kRkszA3iFJ9ppTn7CES9cJYrH1JE
	 XD/gyr3hXov/6xjsaqqL1FGY+8ZmWmmW0Gqlh80XrHJbwZzvXyNf+hmB3sQ+DilGUR
	 S0XyD3cx8I3Gw==
Date: Wed, 16 Sep 2026 09:09:41 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
	Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
	io-uring@vger.kernel.org, netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, kexec@lists.infradead.org, 
	linux-hyperv@vger.kernel.org
Subject: Re: [PATCH RFC POC 00/50] file: handle files on syscall exit
Message-ID: <20260916-seilbahn-heimvorteil-edelmut-bad3637b3a95@brauner>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <CAHk-=wjeamU=_RYT9cR3dZJ2N-Teo-N1+aYh7jwhrB=iWXD0cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjeamU=_RYT9cR3dZJ2N-Teo-N1+aYh7jwhrB=iWXD0cg@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 9eepndwg38ran1j54qbi8jghpmb5kdos
X-Rspamd-Queue-Id: 1CF2D1C0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789542593-957335
X-HE-Meta: U2FsdGVkX189N+2361jB68OIdpyKU2LJUvx7dN5g7PR/7f/YMGLN9DumVWBvJW8V6JMv1ueMKWOVq9n2ZiaVCN5gIBbEBCNL98sr7DWFsG5jwxdHMuUste21TOCn1vSs3ac8zj1ICtU95V88neCw/vcLe5fo/poLR0mhyI8Fe4haRnO2pBosiXdKfWHI+4QGi9J9A619uHk18+q80BXSQUyovbGCNrdgI9LttaR6ViLojdRGsPahOmJx60R/7FpgzdeYn9oecx0J5/ww9Q0G/vfPq4kOmQIb8YE5pA32tYpnICqVYaMZGWvmGuebTMVMeFIiuVNCTXRgMEF5TukP4k2vbMLiz3FUUbp15q7aL1Guv4TP9dG2gNHeFPDyHms/0fiqNtJXivWfaoKGAVg8/fx9DAeGjEbYEml5nLOxUhEYajFw4SVFttVPKYvmS0XUjDs5bA0nuhZdZBuHVCb4VLUiJVrfeltgr7ChoQEKsNRx940vWRLTFYNIUaPrMfR+G64YCf2QKZxgYFFln0jOnXsBpqAw/ltSRat7u/ioqq1bq3DmhhCkr3mVG9E3MYhjUm6eeYnOjYdmwPgeU5mBHQN/ET/8ZBoAsn4J5DWrSCgCMxlKV5jOKvpCjff6d8djsQTUkWFID4os0FEAkEO4S5k+u9UkYn3r6xIDtozHT7J/bCiUm3XFyPeOWaB+q6ClTeANoV6iGoeAfGtfbHKvzWTWPI61cy6DjBfSbiJe0RFAQU5Jgg0a2ROO3rTrC+I7f44V+oSVX2PvyJ4uMM5mSpgYeoirgNQZDvuDdWDgvsca616/J2KhdQzdvwAD0AECFuzjPyYjzMXhDFIJN3hdz8tT3nIQy60IkuLtPZrXhBj63me6UcZGVBYsiuDnf577J/UktzV+EMcadDtsC5EEDm6wN4ZbBI9uKfNpfTB27q5h9yYOi2YEdFNLlydR+0NB/DcsSrmjmByy64dylza
 5W1htnyt
 MeFCyQ7dl3jY+LpExzsD0w7C9fPudLQNrxYNRxhehCSOWDg9Y2ZJKwAn5S4i2BwWeXkomyMpvNc2eTYWo2KEIkGXAgdzlF3oNDPywn0uYJRfIupY6GdSrxjgIgo2Xs7cAdXTX4lkTbOWtoEL+/I75O8YQvMxIs1fY+3g5gZ6HMnkNQBAzJoHk1H0+WZ/dD4nrQze6mYopVQjN9DMpvQgpAxd9U+XFVTwYeFjF+buBmfnJPmcKlr8/m/vZl9mgKhFjKKIAvGY5j+ZOJThwKReyOgK1DzRPWB7q/ETitUhMidxubHP0zy59h6L0vOGTn9gxbmxO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 09:02:31AM -0700, Linus Torvalds wrote:
> On Tue, 15 Sept 2026 at 04:31, Christian Brauner <brauner@kernel.org> wrote:
> >
> > TL;DR, this lets arch code handle fd install and cleanup. fd_prepare()
> > allocates a descriptor like get_unused_fd_flags() does and records it in
> > a slot on the task. fd_stage() attaches the file to that slot and
> > returns the number.
> 
> Honestly, I am *not* a fan. At all.

I'm really glad that you don't like it! I hate it too.

To quote back from the cover letter:

> The idea in this series is old-ish and really never let go of me and so
> I wanted to at least dump it onto the list once even if it's just for
> illustrative purposes.

I think the cleanup-based solution we've added a couple of releases ago
is the better appraoch. Which is why I chose it over this.

But this install-on-the-way-out idea has been brought up quite a few
times as the "better approach". I never really believed it would work
nicely. Now we have an implementation on the list that we can point to
and we can move on from this.

