Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C34606A336
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X1jgy3lG
Received: by kanga.kvack.org (Postfix)
	id 831D56B05BE; Wed,  4 Nov 2026 04:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3116B05C1; Wed,  4 Nov 2026 04:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB0B6B05C7; Wed,  4 Nov 2026 04:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 454926B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:28:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D70EB140661
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:28:09 +0000 (UTC)
X-FDA: 85396910298.24.30D9691
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4876D40009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:28:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1jgy3lG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr7svhS/YSc9d7laFr7PXJQ2SsJ994DEnu6A9NyzDrI=;
	b=tpVjiajP7TT2EZWDioxGSnWCCNkQDpFKjv8YbRmtlC7ExbELqVoqlwB419KNHNNmp2utR6
	s0RQXO9aUD3PTTr4FJThoz3A/yvYE9ycU4o5KdhDjF+5/sEnvZ2BSLFDDJypPYkZesuX41
	4s8BAkqUZJO5tcmGDpoE1/JoFWzyiGk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1jgy3lG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784488;
	b=jxcCGBqmY62X2S1F9UQfpdxyeEI2xRNy3KU0SNaQSfLenfZVq7A9zsLa+M/0EC450NiaCN
	hr2ZLp53hY0rFbLBa4hD+cYaz9Teou5MmO+m4Nzq2N1LyU9zgkfak40uezX276mp7kR4kC
	vaLx69N4WcnzCjGSglkx2aYyA3iDhVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C108060098;
	Wed,  4 Nov 2026 09:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4001F00A17;
	Wed,  4 Nov 2026 09:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784487;
	bh=Gr7svhS/YSc9d7laFr7PXJQ2SsJ994DEnu6A9NyzDrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X1jgy3lGK+B8wHnMJmPUlW00+DythG+u8ZdEslw9l+mYGsCluF0yALGaeLj7ksrDg
	 EcNjCUMoKMdxcyD0WsxPb4Cp4iKUAxNR9okqjQhF+09x5q+3kuYpexwXQlXsHIw+os
	 TkFeMF2FhQ5UjzAqNfBp6xMNGmn825VDWt1gtK+nxiDDItHSDAD0XUEkYDsawNyiA7
	 /4Xh7LGcOgeD7u3hApqggi+GDOh8nhBNcBO0pFhjuZykmUExXJEtisP76hRDnMqyNT
	 NxfQEUBzADkSfaq0PsDOx4woXNhrClwQtQmsRawkfviLN+SXF+cZMarB1vamQDxvXp
	 LI66cNBmM2ktw==
Date: Wed, 4 Nov 2026 10:27:55 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 15/16] proc: let procfs copy ioctl arguments in and
 out
Message-ID: <20261104-muskel-filmabend-parklandschaft-f02c910a4fb4@brauner>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-15-75df35e4f8b8@kernel.org>
 <sashiko-outbox-195542@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195542@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4876D40009
X-Stat-Signature: eoh1ecbyztf16bqia197papdrhqccwtg
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793784488-75420
X-HE-Meta: U2FsdGVkX1+XIwGKoSCk4+dN3FB7cYJE3U0uIYclGL1SUiKoNk5icH58HSQ4Yi3kYc95OTZu5phJFsn5mLu7SRK9EoGLRJiBYRdiHDDUr8rHeEGZSvwwNeRfo4uJl3cmHMZyTuptYqeG9n/9rIybEVA51S4DrD7irY5iJNfxmNkn3tNaXmmZi2SF/rRX4NlNohf8cMK8/AaleppMNgcpKJ7F19tKqQyvMT3ecWY4jpbmlPCaYvaNLL3lbHkYPoU6tZtHdp1MWDw3Pys0kchbDNGwNP6W+CnFQ955V4//cZSKRRnS9cjo7TKsbbxQhI0QhEfhRx+n2MHOtHZyThDRPdVyWm4bFSVEsiBfGzrOVehFLsv5kOk31vpee0g+LuuI9QrVCDicL3f4NEXRLHqLjbkr1qhBQnUMWzK/3/STeUBpCrD49P08Pymzobl6AzbgqF8iWm5Fm3TvpVKb0kz8cWBis9R55aeIZSbrGh5bpyxX63VIi4KdlUNaPwcPPkKdBOoodzX8Eu9Ou/t/HjmuHjIcpwbvheSBNl4ltXzmmc8e15VvbvXiHBknQ700utxM3sv7cKIUeq//Y0+S1X+86o1fETcaQ4nNbJIjT0FDaDS7kNn2Gp22OCELtyUaQ8OGt8MBGJ8GfPsXZXB8cPUjte65yi9nszKMLwwTVkdkJW+c1Yh+6QnzbzssM7a0RoWn7Q9+rErHuQwuEE/lErJEXWGhLtwChiiY4BtsDdkl9czLa2ncaqspT7rNwokPplQyyVq+u4AvFtPKsl4NnfOwPgsSHGghHYj4xvFImndy7Ts41ugPEHuCSULSDuyXOMmQInutjksQKsJzD62R4n2RI/5b4Y94dYEr7yYTV4xIiEvk0DgNBZOAp9qDFuLHvFXx7aGL1jgO2jLVib/7dBaiJtEOf73hikF55H/eLoqxBiPja92pw5y8CWD9SnyYjKoO/mEyrUNBOYtGOJ+gFsB
 JZwtpMY5
 9Pyea7B72fmjVV3aJTDMrwnaQW/zTBRpOJHMR79hzJlN+c+1zz6xWQZ+Dsmp8UnpN3JBBmO5FGxvqt9z+OldHSg5qgm+10XNmR4oCO19y/SncB8zJNZrQ32ThaUgPoM+wSf/jYcJBvXrPP5UPiXRUCkK4mfldGuAubhfZ1c0KJrrZl0QeK7btUhs744ksfNt2KLiee1e8rzgMeGH5Jvj/nNY3xbLNRBG4VjyuXyfjGjB/+AyDOMUOAHo5wl85NHsVSJX0lmPNuKaA+zNWoNEkMwzkmrOqWCiU/FIx0snr/+vh5Z7LOLgD6J1tNxyCve4MHzIs2C1lHueWdrigNseMM+WjZOUyOC/0oC7Znn7OSrQfUCvzoi9RBmbqX94myjrD8yvW5TVyOvbjqoA6pwyqNfElxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:01:36PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] proc: unguarded zero-length user copies in pde_ioctl_buf()

Hm, a zero-length copy isn't a nop on every arch. Adventurous. It's
skipped now.

> - [Low] proc: split declaration and initialization of __free() variable in pde_ioctl_buf()

Intentional.

-- 

