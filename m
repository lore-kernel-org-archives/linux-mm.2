Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C59606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N47QG1bj
Received: by kanga.kvack.org (Postfix)
	id 0E0B26B07C9; Wed, 21 Oct 2026 17:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08FC06B07CA; Wed, 21 Oct 2026 17:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0FAD6B07CB; Wed, 21 Oct 2026 17:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBD3E6B07C9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:48:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 486671606BE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:48:28 +0000 (UTC)
X-FDA: 85347972696.16.C1BEA94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D51D18000C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:48:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N47QG1bj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792619306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1UQ9FNkc8l5nyatttnspRCQVclcdetrGbMkAG+XPp4=;
	b=KR2ImPS/SpledipHShgf7qjoC5zkLSDjzq27HokIv4xmLPK7CniQB/CK+CVYBkGH57MEL2
	kzV0lTxyWLueJk0SkGgl/AvXIABZgEPDmJ/TIBS443EfY9vLBj7PMRzJYodzqBICtbYMR7
	lpflM2FCUFDXGZVo7pCvzITVvrep/ng=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N47QG1bj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792619306;
	b=hk5IaAOgXf2t0ZyEAtqaeHCXR7YWZTZ5t6yN4lg6meK/jTLWdMXqX2qszVhB06nc55K3BU
	KFj44eE511rGTEqsTIsDAjHLfHKX341Y8dSff6QtgXqskJnDgyLct+bLvaRBV/k19d+1JP
	EFJ9+YdDnbaWv52ijMdJARTuio9JNXE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DED7F409C1;
	Wed, 21 Oct 2026 21:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949B61F000C4;
	Wed, 21 Oct 2026 21:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792619305;
	bh=R1UQ9FNkc8l5nyatttnspRCQVclcdetrGbMkAG+XPp4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N47QG1bjuudhcobU3keo853c+bzAg5T+d+/lpJoagyVzzFNZEqk1sjb5MPt+yF90L
	 GXUBw8zE/7EmUjPZN2evYSV17aUp7PqJaJGLShWb7hXgAJpX3+Zlxmav4kanqnPCUl
	 5vC8mbRbn7YgHr6rHylcBcqgn8U1ZLCEdFTAiLt+gVJpMlvd6FhxP3rSnpuOjfTwsE
	 ikMk9w33nXjmCB5cG3aR7Cd2hBsqN1UYaHsAeSbZhhf63nqq5uQ0A9ad48TSDa8xpa
	 zSTG/x7BjBAgaAqepceMn5aozu30SmHatv/GE5Gy7DU3iIXFa1SiCcm+QcuwVXdc0g
	 oBNnFkSXt/EAA==
Date: Wed, 21 Oct 2026 11:48:24 -1000
Message-ID: <649966b83b39fcdd25e892fc3c6732a1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ian Kent <raven@themaw.net>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 driver-core@lists.linux.dev, autofs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs stores
In-Reply-To: <cover.1792577179.git.krystianmkaniewski@gmail.com>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
 <cover.1792577179.git.krystianmkaniewski@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8D51D18000C
X-Stat-Signature: mgr7i4n3jkwxuyiyzomk5zk181kxcjim
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792619306-42639
X-HE-Meta: U2FsdGVkX18AnVoJefW9WGIQ7SnlbKSbWntfNIakjBFwZvTT7xrphpaouqYj+hJQEppEpWGfhz4GxiXvNXUup99vawVURppMWOxsk5m1ksQ0QDwZRxOdTbDCP/KZifUYlAMibtKlSn2tBTv19x58MHD8jNF0q3eNoCP8h4yJ0EzRRh2Z4AC+QZbgpSOxFzClikSUVl0NQLR0rPHLnip5bK0hb489ukchg+/eNsU2etqfxnVWI2326RXoeo/dzNciOH8SiEdsM8Sf/nz/QYx8Ez1f2LChMiWLcJd0342R2TMDZ7KrShOR3M8K1G8YY1wMSmdsjQe2AZrWA1Rg17N03F00Zz8oTrXIPJH6bJ0ra1nfMJItPLVKLI5YvHmy1nAvn+6Bgc7oSWzRMqz3p6FQaFbpDRk3z1OHD8rZWNiKdof4iQ1l81zXrAHbKWeNmI9lTciQq3556mTlJgn5viq9GaL+qKs5alSRmLhkXdfBlMnwQIHYTIgwvXkLHfz8MGVJLhXYAqSJFGRiK0s6jCuCm28BbBZT7VPEavv6tftuhcbFgwqMdYRfOpB3rnob/1+LL8Zmg+BM18ghmz+L+Ugbk0JGuNwdpXaHVoRKY3gip0qV3h5RANQK2HkkdDjvFTdbneDuSwZSco+vpZTMVqXVQ691u50RB4rHIaH0GjZgnhXO0p7B5QRm0NLanla7Ska7JxTiSB/lzw9kTWEgmE5hJOff3j7nICb1V6ZicoGTMobAAZlJ5UIpCFIlDKK/UP028nY1M8H+8AahGJ6/HHEpyqRlXsW/u6kcj1Hmqu5xm03msfk5cs+26AwwRYqQMLKHmUo1p/9isDttcOxuLxSPx/0A6x3rmEd3LGWVXUZPjqSBYtStivN1+RfrTWUL2dnRonppcXKNaHuamqMgqIuWLss0x3DgYe5oUf8LB4WFSVSxHA1LNojynL5nd9ft8hSgtp1kbPUyvA4NP9JjWBu
 X0WMRHXc
 IO7I1cCEswrjcHNRr3VgTDlrdV+gBv4ekoU7V3K71nDREJjXAOHHfIJK7oml06DpYJ35FILZcSUaYdKAy2/RijmhpH1ipp1KM6p44qoYVY5mrlfkdBDvZiKSdnfsgeWcWN7CR8DBXIUret80DHBx1YzcN62u14WqyO1qz6RP73nz2PTX5aytPWDpftyqyA9ESgnHdlDCiI0769X5eAsYvYFZzSWJEN6xLD8hqdsZFUOTe1Iit0aNaF1NFTzDsBPrqZjRR16/Q5RBz99JpeFaIFVt3Z5OXXTY0kvjvrNYqJS+KVYRmOxP6MTuyzHLt/lSweZIFWkH7xrIIFB30q05do7VZwdRhaGz/DratrAn+OWgPdeEggZ5uR4uN71CvG2OZ+mVcQDqrXepnLdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Krystian.

On Wed, Oct 21, 2026 at 02:51:48PM +0200, Krystian Kaniewski wrote:
> syzbot reports a lockdep cycle &pipe->mutex --> &of->mutex -->
> &sbi->pipe_mutex. splice holds a pipe mutex while it calls the write or
> read handler of a kernfs file, kernfs takes of->mutex there, and a write
> to /sys/power/resume looks up a path that can make autofs write a request
> into its daemon pipe and wait for the daemon.

This is an extremely convoluted case that isn't going to happen in any
realistic scenario, and it doesn't make sense to change the locking scheme
for it. Can we just disallow splice on /sys/power/resume instead?

Thanks.

--
tejun

