Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BDE606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V/7IqG9G
Received: by kanga.kvack.org (Postfix)
	id 0BA356B00EF; Fri, 20 Nov 2026 07:40:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06BB66B05B0; Fri, 20 Nov 2026 07:40:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3236B05B1; Fri, 20 Nov 2026 07:40:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7D3D6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:40:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44E6A120EC3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:40:50 +0000 (UTC)
X-FDA: 85455456660.06.28F5064
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9390240003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:40:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/7IqG9G";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795178448;
	b=t93We/8f9aLoiENRd5ljehwa9Tsm77sABDpAJyqyHlBedsSGw1qi/g8uBuql5s0CAIEXWq
	/Ay/hsFY0wSeYDjgzWz6gQvRaBlQkVXHXMtT9JugDO+HEoQIdW0s5vNlbkjzvXe0f4XZJY
	eiY/RFDsKXnnpzrJhiH9XVXGDo9OhRU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795178448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CwJfyBCLxLwL0PnTLvwM2o7XRXX/a3CQUs39Q4YTPY=;
	b=c43kPYm+XGIdc2masrGeCI9EAIHE8CUC1Kop0xGjzubzAEzs5pD5kzYXatq1Sb0NcnUxxV
	SFeYIihRKHDUsFl2y7VnB6EfwBthDPfo8tIPTxT9WSl7jUU2hTKPcGNHyjgQWxes+aXlRz
	UW/ZLUoDqFRv6XSYecUCGqWcDpAUiDk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/7IqG9G";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EC47403CA;
	Fri, 20 Nov 2026 12:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4F01F000CA;
	Fri, 20 Nov 2026 12:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795178447;
	bh=1CwJfyBCLxLwL0PnTLvwM2o7XRXX/a3CQUs39Q4YTPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V/7IqG9G1aidQOASPSvwPkH4jR5IteEbffKLBoJx7IYUuoYfE6R+NRwB0TMrsY2He
	 ly0RjzZpz3tFAnSo/S6kG/lMLdVxgc7kO5njSGvZqpjYJDMuRw5WDEFghTsdNDMSCK
	 A+9es7dmLcqJK7QGyGGMzuyIf75k6AKYJRTfZcvFa655K1nubrvLN3VkjkrOaeLabD
	 gdPG16XXJ7r8vbHsefZ258tJTKEhhM8Jkja8e1JiyzZPcW37XNDej/IvRShk42OCTc
	 ci4M8GWW9DGW6TNSJForFI6V+cW8ibPN6TAG0+xvwbJi2RfvbZGpcnw0mv8KYpPkkB
	 60pMEO+uDHqZw==
Date: Fri, 20 Nov 2026 13:40:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Ethan <yangyizhen3198@phytium.com.cn>, Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] block: long udev open waits during cache teardown
Message-ID: <20261120-hassliebe-arena-kaufvertrag-3ac58fd0483a@brauner>
References: <20261117105107.14236-1-yangyizhen3198@phytium.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261117105107.14236-1-yangyizhen3198@phytium.com.cn>
X-Rspam-User:
X-Rspamd-Queue-Id: 9390240003
X-Stat-Signature: gc4p44egeahm57qabtz3km9r4eo5y4rm
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795178448-665392
X-HE-Meta: U2FsdGVkX19bGU+mQBWBSv54SgsGwe20MOwUTSm5P4kPgRtxurUtQswF1NJQuUHUz+3UTzedWl9jA2Lq9PyLu+HbInhQEztTvOBijjpmz1aSwQ62IhA8nCQ/LnufkHsCKIlSbI3qr/W7cjxCmFNh4VNb8q4bUBQ/6niYcGjfhQ902U4OXxc7f/707hovvB5nQg9enYdWxIOqmHSgx0oD0rwOBYZ8f6rScDx8X4EIElEDbrC2cm+6juOIUM8FIB36ek1hMrsyBAX3C19nUeQtMCU3VzJWL7lhswXq2g9QBAu0Ca932j7LgRx8S/jlwQZH7XxerDIrfy2Y3GI0KSNlsNctn5SfSsCVk0DE+Zg2VS05jq7H+GlfuupYqi9OyUeTyqhP/vGso2ySQs+joUVygvYSndszHrybIfikCpqUO1D9JNz56cjsL7BqW3dQ9enIRbtiFl4mL7g4pwLp3OwhGXPDBCTxAc81c94D9rVxge2Y7kI1Q8xwKTM1wVEeSVESZvMKZRZ4zo0KGeiWCDrJVMOGK2AGLkP6s5Gt2WBUnpROePkmcITsmbEN1W974jXpFeT8k/LUWrPrW60vY5qxNg2GCyuBDXnevJiQS3FIyv2G4ZDjbVHS99TbZEQKGdwCdM2huw5r9+DkjexGxN4ohEIufbQyrYt1hh1WfrCpElaxxGGjCMMFMwykEPYCXT8d29OU+DsaKJavbUR+gZ/0wiw3V+wheTVwUlqxmAUHGYQ+jc/so2Q7s8gBBLgjAUdu1koq8o0x82jB5ZPXuH++Eo4BM2hqn+/OAr+dWpIu1NfT568XgFUiQJZF5ytlRkmryhm4jonzUIdGDzfYrUucCyF/ORiNWh7zrQdHNAtOfShfkYk/ALB78lWJWP0S1NIpFmrmF+Zu4jYA/VqcUb4139Yn5jeEMkORjmZKoW5CrpJAiY1WU5obaRAbHCGpP46sExujhmV5d/2xPfouo3Y
 0Z3oYEwA
 DHXFpImxgMjlD0UdDTLzTWo8uP6tHAiRJ6xMYIS38zJponITtOa9DfMQOApj4UdgBhKbwmtCWckF6nxJ3EKvyVO6nyfSyqU6ZyhReV3+E89ngeCXy8Z9bTPsrWsOWfWgy2QByj5fXaBkPUgYDHa19AdeftorqELud/4qPj9jLum+GvtHtM/N33XQYTddYYNuA0OwU5lSDrqaggTC/DYPOjjjRIvWTN1pUHjErmOgmmqU/u30khrpqUyx8bpt/iov3RboctfVpSgLcmNsw0EraOfFNRRMg0S/rjdkRo6z5gt4AHT9Z12u/Z4L/ulelGhS6zZFlF/jqYhclHC5e8EivB2tSw29jKiIwqPXHT0AogBAn+U3nVlR7FerITa29Pnb6/Lj+1wrO5pFzZRtB/0C6WFK4vS8cfSp+zYMr4fyNs00nk2iQVZ7JVBFm/Bl1cpWmqNy9kplXkXmlbH4ZIX/RG0fwrf93ucY1INU4JIF/MTW29NAqBODjGiiZGRv5YuRkBgBg2anGkmDduxsfXz8vSv9iRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 06:51:06PM +0800, Ethan wrote:
> The main questions are whether __fput is an acceptable hook, whether
> this should instead remain an explicit userspace action, and whether
> a different block close locking design would better address the issue.

No, __fput() is very wrong for this. It runs for the final fput of
every block device file. So every close of any block device fd would
fsync the whole device and throw away its page cache, including the
cache of everyone else who has it open. udev opens and closes block
devices all the time. That makes the common case a lot worse.

Mainline already syncs before taking open_mutex when it looks like the
last opener is going away. Exactly to avoid multi-minute syncs under the
mutex, look at bdev_release().

What's left under open_mutex is the kill_bdev() in
blkdev_flush_mapping() and going by your numbers that's the truncate
you're waiting on. If that still reproduces on mainline it's a question
about the bdev release locking. It absolutely isn't something to hook
into the generic file release path.

And mkfs can just fsync() and POSIX_FADV_DONTNEED the device itself
before it closes it.

