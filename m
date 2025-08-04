Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652CDC87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22FF6B00CB; Mon,  4 Aug 2025 11:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA5D6B00CC; Mon,  4 Aug 2025 11:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9F46B00CE; Mon,  4 Aug 2025 11:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC1606B00CB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:16:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A88301DCC5D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:16:35 +0000 (UTC)
X-FDA: 83739426750.18.D0AFF04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 328AB2000F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:16:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJPF9qoH;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754320594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N69BsH7+YQH/xbxCb+BZEU1vaLVDz22PPSz9x4s9X9A=;
	b=1nbp14/l9ovsBfp93jYNOXN8okMIN4EDnRCQEH78LZ6GhRCTs7BwVwmrNxud8dik3jMMu2
	CWlSzQ99SFIT16QFNh0ixeIHgCsWceKmC5u+CLGGQm+2BLPqr+y3OUFxZKaznaazhZB6Bu
	mlKgUmjIi371J7Yd42ZHgPFMk3FqNdA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJPF9qoH;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754320594; a=rsa-sha256;
	cv=none;
	b=Lew+f0h0K5FU0lvyLk65RFO5Vd88K1QV4FM2VBZ5D2stVDX6FqEdHgjQANRHdqCn9w8eA+
	NimoBz5CfgaA328X+heM04KQ2n+nwLBj0uEI0/i2oBBkbTvN7D2o8BOFm9UJOw8gBACZX3
	32fVLhtq2besILTMD8yAUhB7dH+FayU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E994443A92;
	Mon,  4 Aug 2025 15:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9703C4CEE7;
	Mon,  4 Aug 2025 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754320592;
	bh=b1eLgh7yG4oMhzhvJuweuxrjqjtqiYIHIQQU+AnX09M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qJPF9qoHMciO8J+woCu5kQC/XU2/L0sXv4oXO0o2gv4j+l8oJTZqfdYqwo76XwGhL
	 ubM4ydhODKhBsGVcvuJWx9lPLyvx/mmfpaNiB3XVjWhEvZnpqGHUnIVvGIpeX/KCpc
	 lByJSWA07tze2ckaSOBdwG/QLSp4653dZMz1MDrtzGZY3PotzsESF+M6Ons2IjUGNx
	 NcEPR8nfHWLCg5dO4LcHrp15Xi00fokWmVIR63Bny2h3ndjvmE9UdR+iL6xahkcYfZ
	 NaMPXz5d7JHK6S/ynZbe7EYCC3/vlK5xIR4V3JBR4t4ZPvzUugp8SJrHRJXWfouWdC
	 kTFE/opuVTJ1A==
Date: Mon, 4 Aug 2025 08:16:32 -0700
From: Kees Cook <kees@kernel.org>
To: Yin Fengwei <nh26223@aliyun.com>
Cc: Ismael Luceno <ismael@iodev.co.uk>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	zhourundong.zrd@linux.alibaba.com
Subject: Re: [PATCH] binfmt_elf: remove the 4k limitation of program header
 size
Message-ID: <202508040815.0BB8B41AD@keescook>
References: <xd6zp5ytq6iakxkqoqqtseomgu5oohau4ynj3xbo7ejohpv7dv@skp2v7awzab4>
 <aI2KQaWpPLSAqdXg@pirotess>
 <202508021029.7CC8B334@keescook>
 <aI7zDXb2VpuaHHYi@pirotess>
 <6653242a-5b08-48ff-a126-9e9367633420@linux.alibaba.com>
 <aJBfDKr1-7L7GGgH@pirotess>
 <b98058f0-79fd-4dc5-af7f-d37941eb5707@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b98058f0-79fd-4dc5-af7f-d37941eb5707@aliyun.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 328AB2000F
X-Rspamd-Server: rspam06
X-Stat-Signature: t1nzrz13fftrtnw1h74z68s8pgfk84uk
X-HE-Tag: 1754320594-371952
X-HE-Meta: U2FsdGVkX19qy4JHGDCBY9aqbpLaOmBqKs7sgeJBjxA6Qth+LXBfVE71QUay0beBqh4keCYZosTyf8SEhNpdBNQgxWX+pZjcZDSz2BHbghlYmqsM6BMFr9hWHprUanPz4ZdL44wskc8lU6Y4YkM/ZRWVhaYmOBfF8YDEVas3aUTzmipyyZ2V7wmpCNuFzx4zg/o7Ws4fDPol0K3wZoxiYyiMvbstEAivmQZ1iNvJnds47Zhbd6zx8IIfhz+hbVWa6VVvMwCwM9dzE4h7cp3uqw/ejHwoEkKOUWcQjr9bdx7FHgwmchBh80GW5TtOR4x6o0lKXAk2OqoYdanKbXoZci79TqRVbqsR56MPRw98nR27At4CleNtSqpU24+dZNu2wsnnNrp+9AKC7UVbzyFRFWkW+kI/KwmgNjGvyWCpj3jIpaFYs4mNy9ubIsZcmiPuk9thTkj8A0jAVfcS8TwKuNwY2KaMy5a9K1NcY1IsItKZLBoYv4YDm5R71Ia7mF4rSh3oPxFblt9vfBH3Lx7FXhORSTmITX2wt/kTdNn/JgYKDRMXxOa/mSWpVQuktBQBf76WM0hHM2rY9/4OVZb+KxU/NVECZVTU8qU+eYfCPVazwNzIWnQovQLoqLGmShXKal7xvEXD6m79cxqCNjPH/yR6954nkkOoOONuHcWfa3aLDRn6dMFMEwuaGMuO31GtorPloOJzQ41l2s2Hw4LlrF3pCPaxCCjbP9uXt0XrB7gUwyhNnaBxqsUzs+wudXITAH5C5NFb2ZAwCejdciTfWfWGYVNgb12MoR7UG3GUEpRihKXX7HO1Ik6Zk7dJann0qvrAxRjdQXMKPqIhC6BHn8VVITugmWYCGmyWkopjmDBBQznxNa0DskmBseyS4TkJgrrXhiAgWp+d54kVPhkw8+W+ax8U5QVp1cH55N/jUk6nACRj7agK8DtpVWZtDgnIK3HXDjwODjOr2Q0hfyo
 heOsF/E/
 KlUQa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000081, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 10:00:41PM +0800, Yin Fengwei wrote:
> If this is really a concern, we can add 4K restriction only for
> noMMU. Thanks.

My point is that the headers are loaded via elf_read()/kernel_read().
There is no direct mapping, etc, that would result in some single page;
it's already bounds checked, loaded into a distinct memory area, etc.

-- 
Kees Cook

