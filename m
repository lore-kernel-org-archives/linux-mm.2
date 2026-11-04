Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9CE606D80C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WsZRN4mS
Received: by kanga.kvack.org (Postfix)
	id 853BD6B05C5; Wed,  4 Nov 2026 04:24:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803F46B05C6; Wed,  4 Nov 2026 04:24:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC496B05C7; Wed,  4 Nov 2026 04:24:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48A906B05C5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:24:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D525E4067A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:24:50 +0000 (UTC)
X-FDA: 85396901940.18.B140211
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 53A0E1C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:24:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WsZRN4mS;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784289;
	b=M8o48jcqeaEadAQeMefcpbONzLqLKovj4LSUb3O/tY1doPyhZYfZiT5K5xogMKUIVQMD3i
	B7DOIvSlA0g8UezJvdnk24LI0h8DsUVvzEey53r6d+onHWXxwZ/Q6KqlAHmDMZKVrRdefK
	gb5cVxbPB9T2WCyZm9B6Vnam4+BXzqQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WsZRN4mS;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DU2HnGr13UrjNFDLaLn3EdWjpZutHhABvL9XsGqx5jQ=;
	b=xfCb6DiXU0XVALs9JW6c9SZc8WdYaasVV9vpnxillo1rO6pll/34RJ74towvzJdO2ae+Uf
	bZ5kL/d1FfzlakgIzq1Va/sQxblcz7JudfEqS7eJmT79FrvS5OTFZE4l/9wmA2ER7DQVUN
	xhtv51Lrpws6VyhTuoT1fp2mYBBaaY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D056360611;
	Wed,  4 Nov 2026 09:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6391F000C1;
	Wed,  4 Nov 2026 09:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784288;
	bh=DU2HnGr13UrjNFDLaLn3EdWjpZutHhABvL9XsGqx5jQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WsZRN4mSiXyNqyPQ2abkla1s08ffMgQM7KLDjLi06P+TT7ab4JbGTgUVRFTqM57p4
	 KtZN+GZbXH5rHBUm61AhQwhDhVpBREBAZXFUjjZwHt8GkhBIFsti2bgsNX4+XQ7hjQ
	 cXpndaUS1eroH/oJVNBJ+Sg56kvdzoMsNnB1THlx9+UhoGdloEsTqTqtrrUok0Vt/q
	 ruKuPDXwVqcZXMIny8nZN4Uca5yxXlYGPJItgjFJ5wO+ybOGurlQmQ1RBi6ccxL0qZ
	 AEyV8CG8Z7QBzwnTCkd8HDyv1seLZcOyLurYeXFpg9fCMOjPk9E0UUS16THupapVJJ
	 /V41KUFcG1/jw==
Date: Wed, 4 Nov 2026 10:24:36 +0100
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
Subject: Re: [PATCH RFC 08/16] selftests/proc: check that a faulting reader
 doesn't hold up removal
Message-ID: <20261104-aufsagen-unermesslich-kehrt-9fbdcf7932fe@brauner>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-8-75df35e4f8b8@kernel.org>
 <sashiko-outbox-195535@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195535@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 53A0E1C0004
X-Stat-Signature: 18ehiqfwotnjjrryhc35819usktp7ccc
X-Rspam-User: 
X-HE-Tag: 1793784289-43623
X-HE-Meta: U2FsdGVkX19Yve+AQiqVQo+dQT55wex7LPRgo1sz3pqCt0GpPIqjunj5CUKkoEetTjCkzYr+oTAaxWMQXWsNXvl2V1RInzs/2t2+WHRn8AyDMhBdaSdIpMKL63HwdG0I93XeUjaRfrJA8DUNjGMOPJzDJ7ymoB9xyv3e45iOFTPKRlfZ0w2eE7gQpwkTWjaGlPpwQ1ZjUKesum626yI1p9yZQMSq1T0jI43RV/m1aiSJU7rmuKHy9ly4z3DBzv7T/FfQeAjMpZu5pP4CKWJZGSmC9296fjRXxa79gEZyoJYXUyskAotdnywTBFn2K+08OiE6khLZEX/mHVuhhUVlK6LEWmRocJkov6OJpj8VxPjeOZ8MlmWHrhXSFT/vy0osH9X861uP/gNjRh+y+Ho5N+DxPjbm3sSftfyXWcr6R9Nvx37sS+YnzC3qOqJ62hm9dk1C65cRrGQvZ8DUOlmIU20ZCYR0D1P7SjGuCzT3SPfTJLUQWQVgVCQe4CN69NlyiB3D1pPCYM+689PIzGJxAvQ3r6Jqwo8K9r3/jyXd2O5+5fSPaA36OXWeFQ+1bbUCXUcdfDwCWEzxiT8EeCCAVnPdc0WH3Ju3yE3G/LuIZa1NH+iMRVDBitepSTPe2kEMLRSV+a7x6GbLDx3KdghPtbE6rb3ulYOqUzUxa8pSbi1ZYDgXyHbuB4ClSlTHGjYc32oAuW9mf7RcWq6bWVvMFABWdBacntxvbnDsMR3QNRSwuA8W/MkkiBadgbP9yVWfRGgsSC4HT6EmFJr1HX9i4JLiY9zls5oOOSYlSiYTkgyti3upJBxOsaM9VLUBd6OB22ELV61DrqtBXTDwhmC5LmUPlgDyIrKkb9FmtmKuENGYsexfYXX1c9t+Vr9/EHnu+bDgAijkVFVeLHN+9hjBqfCPOzR7hu80YWzbyavjwKxh1E3iDbjC6m0QwMZJaxbo/LQAwhw/DAxRY1geZHy
 YVCBrdyH
 4qnHlLcZ97o9yP1Bcu1+4qXqBRWrpj7Ws+ZCtQW6q4ZQowuBfsxl7ejOkvlfWMAJEd/+bBMDzEmSEEh3D6Bjf2qeh6v00Kj2XghRKnwF3No8HQJgR/K9Xr+N+jVzwr9uMaU4naJN/0OV+9QXo4SmxsODhdMaypjeEZQtDC5L+w1corutr/7/8BG0A4Tj3DGPH4VrPzYYiWPiU1gJoi/ixA6CSyH9jnB43xR3zGUx2UdflW3ZqPy5HitqPBJWupY2SlcYI+CzOAWaGyqyQvDzobH0tqpKiP8o8GNeDE/pFLWBjfT19X5y3FBzuiBFxioWdMdxo7fzAPzQDVz+uaohGIsZ3vEwiCICvv1y5qZ7LY+YcwAPdVf5tONNB8k+N9it8Bl9iBuJdQZXMxCn+Ennh3gJWbTQwh9LIdmqYRuzuTE/k54s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:01:17PM +0000, sashiko-bot@kernel.org wrote:
> - [Low] selftests/proc: Makefile and .gitignore entries in wrong commit

Fixed.

