Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F28CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E845E8E0005; Tue, 11 Nov 2025 15:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E508E0002; Tue, 11 Nov 2025 15:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD69B8E0005; Tue, 11 Nov 2025 15:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6A888E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:16:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55DC5139C4E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:16:42 +0000 (UTC)
X-FDA: 84099434244.03.DBED64E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 803A380019
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:16:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VjJixwN8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762892200; a=rsa-sha256;
	cv=none;
	b=y2giU5Nsei9odGcQ0zFib2YbaQ5ES+M7wpi2X95gkFl8+X5/91jQ3Kvcm0giYq85aegWjW
	+CmaxnC48UH1qIXG+f3CQaWMkgc53AqmiTnIMiCn3ql0/IDkbx1vMzY9CV7cHjACZWLYO2
	ay0CzUd5xsjKdvc1tVucm63zD3KRmRw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VjJixwN8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762892200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i70mtF7FdE4bd5Iqv/MLW0E2f8VezDpn/9YO1Y8pnOk=;
	b=g8TPk88MJWspPvObWWX1GeNEOuF5Zi3QTTKvCVioWNCbuad6q2F3KEjpiOnmcjSCpZWrh6
	KXE08YV2KWJY7fI5M0Z8WunMUxTrm8TKZ72L+JHvra8dRVeipPVmEJ9Nxrb+paw0LSfD0q
	6dav1P47L0uPq+LCZ/T/wQmfCsQSTaQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 893284097B;
	Tue, 11 Nov 2025 20:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ABBC19422;
	Tue, 11 Nov 2025 20:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762892197;
	bh=kr44aeOaJcNZMsy/DaB9H7WStxetNlT6LAhP4sVEKyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VjJixwN8jecm/9/GvO0cxbi0cA4i0/F3OOFxCavC3pfVCzcrM6xh13VhMpEBg5kpe
	 qiuJAxt2cyCU/0jERoj6B2P9NqwUAMGgXsf7vX3BaapxNU9Vr4rDdIXx0ZMToDMRC+
	 q2B4ACkjZ//xGa696u6Zxm90CDPdm5CozrFKbJAo5eWCnByKEUZSENG6DlQbwRdLFL
	 VYu3N7OdenMS80rJSV3omvMaWHhbGIxbTglpinTKoiVm3YmrXRExxzWiYeKgIkDpUh
	 gL91xa/fbHmGSAD2ArgPXjtdFar+4b+qMpwAz4qR8lMZv7Vl6EXq4/E0VDCh/a2DxC
	 UO2ZuVGEXjSWg==
Date: Tue, 11 Nov 2025 22:16:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aROZi043lxtegqWE@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com>
 <aRHiCxoJnEGmj17q@kernel.org>
 <CA+CK2bCHhbBtSJCx38gxjfR6DM1PjcfsOTD-Pqzqyez1_hXJ7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bCHhbBtSJCx38gxjfR6DM1PjcfsOTD-Pqzqyez1_hXJ7Q@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 803A380019
X-Stat-Signature: jk1p8x8qwt74egnhtf5jo7bwetnus978
X-Rspam-User: 
X-HE-Tag: 1762892200-242860
X-HE-Meta: U2FsdGVkX1/02zzIgAraJgEHPotuK9uwL3NS1BXSxTPGSLUpp5yvCKd1k9j3r4sBMHVkgiyT15qN5+bKoJ/4MayQt+5T60yWd5KprIIPPep1LMkJiuk5vJUNQqJcJKoV7XCrJcq/h3K7barTYumrlepH0VNTQ7M+qutqjURvrt+O4HKRTvUXu+9a0MhwfN3OaX/HHJH4NWl66JpAzkqGzkZtbXfIDOIfgEbRBEddTontNn8EQGo6zLcLcbLLpEIX54LRDh0JFBZ5O1IYiAHnUMzYTTWh44AHUrfnVAE/Vx5CF8PPNXpOvkofXVwS3TQo4D/9oCkekyCb2MvJQxHQtPVeqmrO5mkkZdM9Lc/10/5JxpyJ4dvkJkTZjZ540NtKwGg94Os18NYYGJGEbWzBfIfC0ntxWx6DdUgvH8XB5NOjkNrTxdFOJt0ddUGkS1HrKNfQifJnyRZjJz/Jpog2tZIzF3Xl3AQk9MUe2RKTcq69pwFGp/fTVy8Ta05g/XsXUPHB5+yjXCo3c1lDcwq5d7a2/LjGEGyXKMnqm7TxrM5mdTi8YnpPYvOzD/wsICT7nCvhdIVYNLlvZB8xPn7+KIP86s9Ceo+bQbtV17vQsdJJ6llN8Z+YXfKlify67phzFTLLrvLPlbBkIHJEN2yDk01HKSfpnq6psYwrPHzzIzdm5eTIIyaOydHfqekCUSJPQWdpTEPSvsqvd4gLLF9IBu6zJw4O645WHmXm92Wgp0L74mwUxT/zt4UeWL0qaRsqjWEBXtZAxenhq4liqQV+OPlA2KrYzkVRL7Ua9vtYsZSUL3jBJ9gzsfMKFK18W0H7f9ZoQ6tn2yidF35yYAjUU/Wv47X2ePo33kL0HgiOiftF7KSp4hfDZP2W3XnyyRGyilmxf0WqOMHCgz2kmRz5WweDabhE5JfbN6VJsd15qY8jsVP6CpVByjaXerh8rj34uvud02pd6M4cg25BrxT
 9zkKXhVx
 mfGowZEIQmJ527lg3pq9jxcWIOKdBGoT9cfuLcwelRDtCABsliqILuwzw7hUbyx6/nUnh6febycU8t6BjyXUAIz8mR5aU6TzrprvUhe+CecW6vN9Nw353XbZqvk7bciF7GDk6TuH4gz7PV3d/U81O9XgemjIIKvEdLi01QmM/2wHqklbVU5Qd9wQ9IU5jPIc7TumtbkoxSZVHFOhb59Z6LmFdGZRC1zKFEoAoosJdgnC1EMG3kMNANqK6qiD1ml0Z1ZNSZNKUy6lxDIE5x2uEG2Oj0qTVAPXJVRodZsycYMSOQJ4Z+uIW1HQsPbgBdcMyulD7pmpcBgsxJc7o89Ch0iZ86hsqeunBxLyhElFwJrEzQssd+G9BVXQqpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 10:43:43AM -0500, Pasha Tatashin wrote:
> >
> > kho_finalize() should be really called from kernel_kexec().
> >
> > We avoided it because of the concern that memory allocations that late in
> > reboot could be an issue. But I looked at hibernate() and it does
> > allocations on reboot->hibernate path, so adding kho_finalize() as the
> > first step of kernel_kexec() seems fine.
> 
> This isn't a regular reboot; it's a live update. The
> liveupdate_reboot() is designed to be reversible and allows us to
> return an error, undoing the freeze() operations via unfreeze() in
> case of failure.
> 
> This is why this call is placed first in reboot(), before any
> irreversible reboot notifiers or shutdown callbacks are performed. If
> an allocation problem occurs in KHO, the error is simply reported back
> to userspace, and the live update update is safely aborted.

This is fine. But what I don't like is that we can't use kho without
liveupdate. We are making debugfs optional, we have a way to call
kho_finalize() on the reboot path and it does not seem an issue to do it
even without liveupdate. But then we force kho_finalize() into
liveupdate_reboot() allowing weird configurations where kho is there but
it's unusable.

What I'd like to see is that we can finalize KHO on kexec reboot path even
when liveupdate is not compiled and until then the patch that makes KHO
debugfs optional should not go further IMO.

Another thing I didn't check in this series yet is how finalization driven
from debugfs interacts with liveupdate internal handling?
 
> > And if we prioritize stateless memory tracking in KHO, it won't be a
> > concern at all.
> 
> We are prioritizing stateless KHO work ;-) +Jason Miu
> Once KHO is stateless, the kho_finalize() is going to be removed.

There's still fdt_finish(), but it can't fail in practice. 

-- 
Sincerely yours,
Mike.

