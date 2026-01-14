Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E411FD3900B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE106B0005; Wed, 14 Jan 2026 14:08:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4625F6B0089; Wed, 14 Jan 2026 14:08:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360366B008A; Wed, 14 Jan 2026 14:08:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 27DD26B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:08:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C058A140314
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:08:25 +0000 (UTC)
X-FDA: 84331505370.25.6C058FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 35E5E100003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:08:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PbyEkIU5;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768417704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONpShYkx4yde+rOSHm2uXRVSmGRuF3aUNB0l05in+RQ=;
	b=VUga2rdQ6gvL2OrgVPDn36G7TaZgVhubUigEtc5XPkvRFAV/TK6JKRCZ5fVyYxHQwvZHLx
	/ZtVSYmRROL/NWbUq7JHqui4JrPtmOAs8ANRJfIxZZYMMGvejFhj9g29+E7bTeTvZnF3hw
	d+ZMrErnaxyE6V16EZ9RAiaYLSUryYI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768417704; a=rsa-sha256;
	cv=none;
	b=BedrsAOlfU+K94oHG8qMtXGmHHWGd6nlpIZyE4J1HcXj1IXZCHuctsM8bnrHHuDjxjojf4
	1Tedy9wZ2cFPJYUMLg58Ti8C4KROLtJPoz4oxrpU0jh0lQGCooYmLFfGl2OQwySHz91hJz
	6gmpnE0xuCPJMibg0D4atu6FDuBhaCI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PbyEkIU5;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63ECC6001D;
	Wed, 14 Jan 2026 19:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7E0C4CEF7;
	Wed, 14 Jan 2026 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768417703;
	bh=rL1mKtzqQfzbgIbEAmKDaAOtTmTs/5Lg60KQErpr7tg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=PbyEkIU5tPZh9NXRoJ4l5vH2mFRF3E4ehAdw7jhsFC7QOhdS7yYmGZlmbSy7/hKbV
	 1OcecXFZpT1MofeCqmKlG0NLG4qA8cQBkWvHkWijm1nr5FqFEOYOCNqu8IvaaI06Ia
	 4gungsE66v0kv/gk9jMYpMRdvwnkzlu3zl7OED5FJ3E9iBJR9d4Iq5dGXe6RYNUxRa
	 pgxATN4mio0oo6PiHqQATGkatX4gwDtzcdyNZovSV1tKTT7+7RUugEuDUOk9T9duRq
	 4ZloYoCfiAnlfVVL0ZE08dAGMsROZasHnuiaXSMNpX8G6XvdG12M4JUNswd5+JYQl8
	 VYenKl2uMNqnA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] kexec: history: track previous kernel version
In-Reply-To: <josgeh3zd55a5sjmclidj53v7hoekzvb63ah45aocvgwh6ajxk@rnzjabyqkojz>
	(Breno Leitao's message of "Mon, 5 Jan 2026 02:47:39 -0800")
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
	<20260102-kho-v2-1-1747b1a3a1d6@debian.org> <86secn7ors.fsf@kernel.org>
	<josgeh3zd55a5sjmclidj53v7hoekzvb63ah45aocvgwh6ajxk@rnzjabyqkojz>
Date: Wed, 14 Jan 2026 19:08:19 +0000
Message-ID: <2vxz5x94hv18.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35E5E100003
X-Rspam-User: 
X-Stat-Signature: 3msfsrtzmnnw74k56c9e3zjay3z8b9dz
X-HE-Tag: 1768417704-9555
X-HE-Meta: U2FsdGVkX19VAR5F7R9XlZmKESKhCoEG8YYOG0txyg+nKZbIzj4CwALZyHyJInxHjY9Lnq+s2OZsp2j/yorcauFXxPNIWkuNCfO2L75bJUOMOS3A7TyIADcbPumxhZxIkQMFWmm6WxCg15AXmZ2OOOiAxanjK0gNM9UiFWK00kCTPM8IBL0pH3bMExYRfycapbNUNVPgPjcvMVwjdemOznkK2yVBKqhFOFLXHj6yF55AkG/h04fmJuyQjGyqgq0Yqvhr7qaNlxiPYPnZY+CK4RWN7hTv1gK0tfBuyGtv2Gjvi3jYSFxOTjiAi5+9qaqj1nk6XjnUR0juRNnrYBBDp0wDxJeKodcfsqFkob6eeV3tZO2Xzgw0pxFJUlckLImaTTDCS6f9u2Bz0ZZUVzmrd0K3UX37E2R0GVmQL8G7WFkm2qGHOyVCwugtnogWo405+I91+hs1w0PCi8Uh6orFCcKQjfUlFpksaCNptsqQbcEZFWXgUKg+T1uCQfByCihXA1zvcxt28ZJNPiqnkZ6lW0Ncbg90bu/JLg4Ncy9tGXt8b5isTD4+9YqEeocBCoD6QFkFESeXSF9B1liqTbA/Wvyr3DiiW/zZ5PkWOYL6zFXLL+MVWv/HjqeSBRN4hiv9coQqFXqCwoR0/zCx1mXX2/dftVZrL4i63m/cRWgx+YxwYXdlKlf81Iy/jywFrnZZzOdooeKZ9BLPvegPFJtqQ70vUkfiIpHHZ+6t9e9430YTvOpEZpT/FsCYHv/ruj6mKICWCGBTp59YGPyG4Dk3Xv+wxbI1Iabo5/GugcX2yySk98kwUOCJ1rdMj1muzpL24e40vfkHDr1DOmaL29JsW3KXQW5jeJD62E6Acg/lStFLj12rY/Rn+mEEhY5UOhdhVCSeMNolOAbstk97PkCpPg1kqdApo0zrIfmteIy4jTqv2gQSfxJYtuobkYoGT5Emb3fMDsbxFCmSvvFcX0M
 FXsHF5dx
 bffyJEDSBfFcesmxX/1i2gl3j3xCMBU4YI/2f8uBmznCOatbvpIaJ5Fj3OcKRMF7FRvcOu2+kuEL7jx+47OOwGnTGxvZt642o7y6nHjYZYcC9ZD1tmAiWQjciUfjsqx0OqNmJesee40OoqnE9fCw/8NZwHcyiOav6mznoKhNfx82NoPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05 2026, Breno Leitao wrote:

> Hello Pratyush,
>
> On Fri, Jan 02, 2026 at 09:17:27PM +0100, Pratyush Yadav wrote:
>> > Subject: [PATCH v2 1/2] kexec: history: track previous kernel version
>> 
>> Nit: please use the prefix "kho: " for KHO patches.
>
> ack.
>
>> On Fri, Jan 02 2026, Breno Leitao wrote:
>> > Add CONFIG_KEXEC_HISTORY to store and display the kernel version from
>> > the previous kexec boot.
>> >
>> > When enabled, the current kernel's release string is saved to the
>> > "previous-release" property in the KHO device tree before kexec. On
>> > the next boot, if this property exists, the previous kernel version
>> > is retrieved and printed during early boot.
>> >
>> > This helps diagnose bugs that only manifest when kexecing from
>> > specific kernel versions, making it easier to correlate crashes with
>> > the kernel that initiated the kexec.
>> 
>> Why can't you use journalctl to figure out which kernel was running
>> previously?
>
> This is a good question, this is why this doesn't work for me:
>
> 1) in some cases you cannot rely on systemd infrastructure.
>    - This is very common when you have linux as the boot loader, which
>      basically boot linux (UEFI -> Bootloader/linux -> kexec -> target linux)
>    - In these cases, the bootloader doesn't have write access to the
>      filesyste/journal
>    - This is becoming more and more common. For instance, at Meta, Linux
>      is the default bootloader.
>
> 2) in some of the bugs I've listed earlier, the machine doesn't even get
>    to userspace before the crash. For instance, in the bug fixed by
>    commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
>    log to avoid corruption"), the kernel was not reach userspace/init,
>    thus, it would not be possible to run journalctl.

Ideally, you should have external ways to track the kernel history of
each machine in your fleet.

But I can see that it might not always exist so I can understand the use
case.

I have some comments on the implementation though. I'll reply on the
latest posting.

-- 
Regards,
Pratyush Yadav

