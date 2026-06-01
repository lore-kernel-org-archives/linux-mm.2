Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06AE8CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B0F6B02C3; Mon,  1 Jun 2026 04:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C806B02C5; Mon,  1 Jun 2026 04:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160FD6B02C6; Mon,  1 Jun 2026 04:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05C966B02C3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:34:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A10EF1C0A51
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:34:07 +0000 (UTC)
X-FDA: 84830681334.24.06CF1F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0593A8000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:34:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXftPvFa;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780302846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wiTClsOVSwfu9VvftExmoMrZ2cWgx+kZ+kOPgJ/Qv/c=;
	b=LS9zDckcV6RQT2dR8DGR/akZ7ayZKLeHwPwvjv98eVOSTcVGOqobwww+ZIv2DdY9w7IRDL
	+uiaYLRT7ylTUqSQUlwtY3QuPzWlqghylewILwc6oCp7XtTVNW6MeYBr+wATs0aTIEhJ+w
	4IVf7nTvhujdT21aFDN7MSTD1G6a7yM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780302846; a=rsa-sha256;
	cv=none;
	b=6iA50oLuuweA7z2NiUq3kPoSzXK2tNxQ4qsrlDwjcllRql9xNvftFRi5mv7ZM6pO0NcOJ8
	nKt7MHws36dY/Zg21F9KDhENMguG3WDMXTSzC2Y39WvLDeUfDWtrPn6/NtV8GLuXIFsOpV
	soutPZUeDqyBcv3zqeMV1wLyGFBhcT8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXftPvFa;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25147401FF;
	Mon,  1 Jun 2026 08:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F9D1F00893;
	Mon,  1 Jun 2026 08:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780302845;
	bh=wiTClsOVSwfu9VvftExmoMrZ2cWgx+kZ+kOPgJ/Qv/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CXftPvFaiZwnbZbbHShsnTN4L0B5W4IrTBJ29qVbhhvlXdQM6DLVoBZUGyjRLfuQd
	 Ufoc9yi6e/6XFngBSfsUC+B1mrc82WduoFl+JqsRZUrBBDPTO6MjTXk/WnkL2SgbPX
	 wH7Tp07EIw5F35piYK82HmjuQC3enpLjZj2bM1KMpF/3tVk28mRpCiRRpUFSsNsEtm
	 zMTiKSKdEVIuu7SyE0jfQgMhUJvUgIMQgR7ygEZBXIG21d0Zz2XSDdrAdY3wZ1JTw8
	 8MjE+g98tl0vvyAu8dRBSDj/HCsuSlMiGiXWSq0ZDJZhrnDNz15yLBRVfLmNVw/3N/
	 mBhCJ2F+swj0A==
Date: Mon, 1 Jun 2026 09:33:57 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, jgg@ziepe.ca, 
	leon@kernel.org, david@kernel.org, shuah@kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, balbirs@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-kselftest@vger.kernel.org, 
	usama.arif@linux.dev, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v2 0/2] mm/hmm: A fix and a selftest
Message-ID: <ah1D1Qs4fPnO5sH2@lucifer>
References: <20260530085413.1270139-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530085413.1270139-1-dev.jain@arm.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 5s94hp1pdpzpt86mfszbetoar4kacdpy
X-Rspamd-Queue-Id: 0593A8000B
X-Rspam-User: 
X-HE-Tag: 1780302845-120589
X-HE-Meta: U2FsdGVkX1+DI7NayYfdFQmhnirv85uyrt8wNZWvljTz4r9A6ZydCFkQemFMdrlWJHDLkL0N1AdXHKe/Fx5HnEGkrsfpeJsV6Tv5Wcet7xklhClcu/2QHW1ghsdTiJFrCGrPBAx4TIvyCB3Li/7qk3y4vxpXrHC92xz5orZPVMFUDwb0SrDVgU0VAU7s5mlOmblQbFseYOytTPW7NfQtMQbx2fX3uq3/XfXopgoxl53AJPj3xvOD84wV7/akxfEpGSoPKRu0I36P1jrgwnu1cLGHjyuwCn+Zr9xmNQ9qPNVZwma0MRzMQXK3O2Wd4YlpsEX+MK/8issEF+lV3Ql7CoVumVgwREzfeMKpWsxsbr93hS9Ot7BOhtMicqijP1TlQ9xc2lCtOqQgMRLYWjMXop78buCThi7FERJAE4UFeD67hsK8VRRkoaQsbAkDTE5SvobRKblfxj21v3sk6eLHJl/A7/aCyVLm4l3GvchnQwQ0xwmZHcnGproj+9HTYE18uH+3mnP9kusWF7KdQVmVY3bocmw0OQyn24kbEKACLNWONZHO9LA8KxEob9hIk3UxjFufcOUGBqeZ+QnvRQOWhaeLMdhzAj0YUPbpgDUb8FFKxn0tMC68EmfrPXZk0R/uURj6G7HRTUWSbVuVshob/Ny5iLV1M4r2ErS2AiiuWOOrYw1OeZkrKqxPTn0fnsDzBTCcM1B9SptTZRCdj4j6Ss6j5O/HR2TZwvKYq0ZwoEksQ+UCQDcmmXmt/qwFPsINMve79ahYHdd8287mTn6anpB871vJikXYc7uW4XIiZUOpfwLjyQTGS6CZrcnOHP5DEQ1y86Qz9uho/Ava5LLestRwNeNu3/IICmn/tuURfQlEZkMliML6OKGbaGlUb8F9S/BFsDu6SvXTqhW2OS5j3Jr/zqO+gWFd9kWHY3E6weQwGUmrxvKSJwFrQELhl/ROS86kV2hWkphPR37eePq
 us1BWVXY
 5ByMNlXlgbN+ecJGBxJJOVLZ5KZ4iFLRnwx5M+czPaTJIiJoiB3zzNZOCj0rtfKriNLi4X+xjJ82/CB7ilYoEvk3PWtvSCzNEzQ/+Bt1plK1GjVuSaJ/DPNOkm0c9j7hLSZ4Z8G8x8Gnt434itETAAHvFF5Q4TjeeaYibxlNpGrXEzVkYs3A0dkFcp4YyIkHh0PQhOUmXBQSK1kuLAvvj4Q6gsvutsxvDrSQc6g3cuuYz04iBWyBcODeLVprcqI6wWbvqgJfRrxp0I0RnHW2KBQ5m/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 08:54:10AM +0000, Dev Jain wrote:
> Patch 1 fixes a stale warning present from the time when only migration
> softleaf entries were supported at the PMD level.
>
> Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
> for PMD device-private entries.

Thanks!

FYI running the HMM tests locally I ran into a nasty issue that I sent a patch
for [0]!

[0]: https://lore.kernel.org/linux-mm/20260601083044.57132-1-ljs@kernel.org/

Cheers, Lorenzo

>
> ---
> Applies on mm-unstable (404fb4f38e8f).
>
> Dev Jain (2):
>   fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
>   selftests/mm/hmm-tests: test pagemap reads of PMD device-private
>     entries
>
>  fs/proc/task_mmu.c                     |  1 -
>  tools/testing/selftests/mm/hmm-tests.c | 29 ++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> --
> 2.43.0
>

