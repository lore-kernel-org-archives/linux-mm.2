Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D572D606D801
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=alKTGqUn
Received: by kanga.kvack.org (Postfix)
	id 01CC16B05B3; Wed,  4 Nov 2026 04:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37D66B05B7; Wed,  4 Nov 2026 04:28:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74446B05B9; Wed,  4 Nov 2026 04:28:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4EDF6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:28:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55E9812062B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:28:54 +0000 (UTC)
X-FDA: 85396912188.26.DC9DFA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9D51C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:28:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=alKTGqUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T01zQUJSjbZp4aJnpwJVQI9JvpnXX6u13mZcG0ZeyDQ=;
	b=UOji3wJxhEKaB5NukK1fTdsSs9MonOYIgMgmWaOssckqXAmICAVAPt+00o+A2NBi45Zit/
	QW2Fn30YdDmgKRePjrLcUQ3vE9zjQEY+Zkem2LFiR2ZAUXa59oftsTsxRXHi3QbzUSGJcw
	Ofpowtsx1JcJS+19ZE8JFIwq30nyXjA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=alKTGqUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784532;
	b=x+/50eTrl2PjOoQxti6FzPCq7GgNRYP0WVI/1Ym8WluHEZal3+/UCIecNOUYhVkJSxq1cy
	h0EZcX2Ch/P9LT2cPpR40JFZRl5EOARTnz+uIEUVT1zuYDGnjm4MaZ3DdU0zsz7n7vxiyf
	IoQtWRtrFDEj9pdf919iZpMRFxuckLY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 596F8605F0;
	Wed,  4 Nov 2026 09:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB561F000C1;
	Wed,  4 Nov 2026 09:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784532;
	bh=T01zQUJSjbZp4aJnpwJVQI9JvpnXX6u13mZcG0ZeyDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=alKTGqUnuzoexCqwA81KPAyGy0rneY6r5MbFqbvV697+Ik/bjfxk9LHef9GM+MQJQ
	 QlHwwMzWgTBR+V1EVZkBqvL2y+0fpSnZdIRpFx1eImmWwcDpXf+kwZoN+KfbPRIwjh
	 GLUEX2tS20NdiCJARKDNfWQpLYmSC9HacZQpjtFGF6DQjakJaImqqw+1NVIZp8Jkve
	 rhjW0cKAwa0rgro+T+KAxTAshgpXhyosdPn/BLM1fw2d0BZ8BRed4fxkWyQdPz2E0I
	 sRYd32Lzz24ZCjwV4++8ADyzClHdrBNXy/ODBoctV+0gtJXx39Cw7SDphwQ7RfGct5
	 fVZStrNkhDPHg==
Date: Wed, 4 Nov 2026 10:28:38 +0100
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
Subject: Re: [PATCH RFC 11/23] selftests/proc: check that a faulting writer
 doesn't hold up removal
Message-ID: <20261104-miterleben-erdaushub-insel-df331d74044d@brauner>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-11-a994bd4d3b1a@kernel.org>
 <sashiko-outbox-195591@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195591@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B9D51C0005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: gstpictfx7f1s3835adiw4wnchf6i7nj
X-HE-Tag: 1793784532-309889
X-HE-Meta: U2FsdGVkX1+AlKW+J7LHFGJ7dcn0ZtzsZey+iQ/9y+z2ZSJaFjJQzjtAxu1RvvZOgnt6ERPPQTEDVkhhhuDcJtWNVqvZvX93O5r9T9iSF80U3eH+ObF8Q6YfLKAJ4OAgxZLt0ZO94aLHSw+Gcjl5O8sFDkz8rGsQ5yvmSDgodIDNgFKB9V4GNc7RonEqDrHFXa5yHrcCPgybMnfBCanIF46jlchS8eY2jZjQj0FtgQUMoUgnn0SyLPh5KFZJC6teEmGCLj0VZm/b81u2TcMZjUW6/YbZfwUp/CxyZjwr0EOgQE16EHNZALTq236BGBHkSg6lMrJK3M5W9mDb6BjrMEHAeDd12aSSpMUDKAVhH/kJiTRcYMzSHBl4M0fu5A3YqBnXMWaUYq765Wlq4q9ol683kqVRdhh48o9w/YptM+J3/aorSOzzWd/MRRtjAKnvrnif5vcmFC9GkeRV3r+VzsdsvK+8t8jp2+DEQIP+WnUWog7mHdy+ddt2m5bHhLrFTfBDmFVDhR5v35DRRfwuG0QzTrnw/BH7gdPuqeODb+jEMydJE8A9G1eXeZPCrjhEm84grr5wtg2HdbkzEcLZ7SZ6wevHjgjSlsMaikSlqtli4xQ3B5HE3jmIVDd21O66IIntOXNix3o4ioaxzQym88B8HSiwrYwhuB/AVPpd5Xan0ZaM0PSw1IxRJjhmOW4d8TnsBqh1BAw3hewJBuKwNqL4yeEyT0VNv9Z7raBm6m6l/PvWpz8nc6y7CNhxl2pSnOI+hcREHBzvqxY9N56jc6Vf1PKhgEtQ9b5jjFHOcEaK8jSl0uzqwiZgDOhxOLE/5K2k/HE7ortK+L0TLeSNiHZGAtI4fQE7MwHSMh0RAfOFv6jgQRHpA2wgqpGtBDX2aq2QgeMO5py2eYtNSjV2ELxplh0Ks3XV0UwSBG1RZrnHcQrMcGMLAZnWN5vW/KSe7yAdD3SSZv5AzPxfbWi
 rzts2F11
 g0X/R00MC0FnYglEtM2ZqVlq3s97lDJHlpBN2fUdDCy/BKmW9Ihhok1C8k5U9WbSJdgT6JHOJOLCRkUaxfaybLpczBzKLRsNDFLFXvbsXCTIBmCNJpkSX/b8WLHrjrs+e2MRnFV/vONBNFYem2cQB9wwFO0lTP1YDbsLzaMi1hYdoGDZvy0kSJHlXqY0VxThbzIyHT9hBKWV7coAdqBFWmkdDLVF5/xRvqKil3mj70OHwfBS2h6JROFLnf8hA3CX9iMe79J8VcTi5P/G2KtaqURQxaSvzzQPNwvS9HbxWQCVpFjrIZ/wHlxXIM53OHbBHX1tAgpwo/1gj+JYgZ3g3eiSqXci318HZVYVuDhqsSmaB/SCH2du7pkMdhztzf/jEINAx82njdYwHqNUhOFdHxpbxElFSw/V7StSy8BB7mtjIVww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:18:48PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] selftests/proc: fail and leak scsi_debug host without CONFIG_SCSI_PROC_FS

Fixed.

