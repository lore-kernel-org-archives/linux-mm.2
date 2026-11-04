Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A907606A33E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJoHVIVR
Received: by kanga.kvack.org (Postfix)
	id 30E396B05BA; Wed,  4 Nov 2026 13:40:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E32C6B05BB; Wed,  4 Nov 2026 13:40:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB696B05BC; Wed,  4 Nov 2026 13:40:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE4616B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:40:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EE801C4205
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:40:49 +0000 (UTC)
X-FDA: 85398303018.04.9E3017F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01A7E140009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:40:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJoHVIVR;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793817648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZrg0qNWaXbTo0/xGfjrSEZ0b4f34qk5jOb+FqN16uE=;
	b=TM3D173Jt487/8J9hD4Wx8cHJlzi9bYHcasEuvmwphqP0/xWBrO3r5xr3C/pDfeHLw5yh0
	WGA9IGCwmPonG2utKmIz8aK+kBznHPyCvLI+l/djSj6fICD0oxWW3qdT7XPNyzG+2TixYb
	ng8VJf2oYusPM8TYuqandXO/liwb5H8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793817648;
	b=ifC1QkpglGecLPnUse0Tc6JnpvAcZjJdSIajuIyfBlbOwwB3y6xuxZWdzNsa3XfjaLuf4C
	+UWL0MAVEH5VpDGbOiVYSsaGp+mSz/VWJKOXJ6LIVb6r2nOHjYzWYjjNhD9Cjm0suM6byr
	TKXfSiX9V+lmj4nT4hTwmDxIX3u9EPI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJoHVIVR;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E54560AA6;
	Wed,  4 Nov 2026 18:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B5D1F0093A;
	Wed,  4 Nov 2026 18:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817647;
	bh=QZrg0qNWaXbTo0/xGfjrSEZ0b4f34qk5jOb+FqN16uE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kJoHVIVRMDhMBnXEsnAe5u7zpLjzd7+MCZ16TzVPzknEMkH+SygeGbLr1cB1EuFHJ
	 xRsFziB7AYKd6Mhhpn+XaIqvh4Cx6oR0IF5YD5hTWVK9qdGzZGqDtB09vA04e4GNIh
	 gmvf+qmzc//ytZnlzvHO/6/uft/CaHdB0hsuAjqYwVhLfB3Ks7yJAR1O6zCQCoILM7
	 7FSNmR//3JsJPL/FoNc85lYWK2E4ao7D0Q2RNB19ZXpttBP2DbzKEnPZ+uDd2qb6Jz
	 UP+h4VZmlPCoaJVRtTyuBLxhzxSpg0j7ZPL1vwlCOQ73t7T4+hY/7Q5mBk/u31yY6C
	 vajKYZo3usCaQ==
Date: Wed, 4 Nov 2026 19:40:33 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	netdev@vger.kernel.org, ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Chuck Lever <chuck.lever@oracle.com>, Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org
Subject: Re: [PATCH v2 00/51] proc: fix a few old bugs in /proc handlers
 (Part 1/7)
Message-ID: <20261104-zermalmen-pechschwarz-hafen-b8a1cb79bac4@brauner>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01A7E140009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6u4d9k5uyhu9gcfaknn8z4uqgfh3iyps
X-Rspam-User: 
X-HE-Tag: 1793817647-909473
X-HE-Meta: U2FsdGVkX194ubM3FdtYd8oKWDvluOdTbTLeKi5zyfPpvKGzeBqw/kGlrUtn1X7ymabhi44Db4APXdoNoRCCAMfEQnLX+sKxx+K4VDHzDWZSUoy314UbSJ0L1575hveofs6S+25Q4tFMO9QXdMVuzge1/JiVLVcA1UZAXvW1myYxVj/SANkvs/sSRPwW+iCFyr5t5EOAyzAZb/uwwzzj1ms5keN2dHlwlNBqo2bdlybZPTOqp0s/OrRAlKJy49opkz7INp6B13V8KVzdkKbReQ9K6mkvH8ThgjZbQS9BzTphsmeNrmXD4efN/tosi3zehfDfibEEfb1Pru/YbVVmvYGsP7jSzw2RV6eBxsBeP8+rNHnkIJbenL1EM4ejIBpkJ7MT2nNQplqXX8VotYuelmzuooVJDj+QFMy98MAAOeTPbsCxeRMhsN4TQWSK26lUi7uZy3EP7TjLgy7Je6i65V/mLAoFamkrRIWnwOpIDWlhxWv7KvsBc7XaUznaNSAUd9BGRXBe1UXSRBRm6wGd3gqx1cAn1iea6nlNGsY6SuZV6Krxmwh01gIO5TWs5tfYfwn8d+q8NxFCFLztFCWS9EJxugdwxMhV3pay5OhL8hdDjv8ygduhr4TBiLBArzyrm41hYU5sdthcEvFynsYHDF4WhDAyHrtfLGGL34d/gnB6rJxwrzQLjL7wWESRDHvIRkr2rL2NtAGeC3udlLrFonP5nrwutRg+nOD8SoXc7mq8YUTrF5cVSx//1VmxZElT8URpLIBMaeyjLgfU9jgP7MPb/cnaZUKgl89JO1YkrmSUK9XT5nLo9Inw4D8vdLsgqzXSGKgeYk1x5UlnlUPLLIY8e11Mfn2uhKDkExT+dTQ7LdOHdKVLmIp4QqwAr3gy9AILs/Me5DyXNOfepvQYtOJ3FXt6S9TzweRyYfI6FD1xRWiWbUmkflxZ0EVG8Bi5GnbeKAHRJycDg2TwWct
 ecUTI7Oe
 2kdzxpnrO+F+SBuKKaykQNv0UQwnWdwujk/7Eaqy9brxGMROha1YVXe4IqSAUDoywsh+qcObib0B/R1e4mZMgCghsSJqJhjzZDN1m12LdGrlYRG/6GtGsZXh+TFSJ5oskIaFQ8hJ2NEabRjGQenb9BmMABpl52XHAKKFMXuUdKCUozDw49MrIrL+uNg/F/qTpKSQYzCg7XzXJq3jtmXT/EIO1z7KtQbFqLfLujIzSbMLG+npKIWuEVnn5Qc6LIupZiK6t5LFNpMq9tuqXKe4w9h+pbCbpgRXXMV1m+lT0k8vLcSkAyCQXd9RyYMQ6lKGRYvT0uYPEJpMafIznjHdNiVt1Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Please ignore this. Network dropped halfway through and the umbrella
went out under a broken message-id and so this doesn't reference the
actual complete series.

I'll resend.

-- 

