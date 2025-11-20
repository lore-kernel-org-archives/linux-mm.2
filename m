Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BBCFCF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2AF6B009F; Thu, 20 Nov 2025 04:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53656B00A0; Thu, 20 Nov 2025 04:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69366B00A1; Thu, 20 Nov 2025 04:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 939F76B009F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:26:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB7B15B1C8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:26:33 +0000 (UTC)
X-FDA: 84130455066.20.E51D484
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A6D7140002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:26:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyE0zf7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630792; a=rsa-sha256;
	cv=none;
	b=d3M+J0b/CPVRy3GUP0ZV6wpnB7MA1OcFAuSUmNiCQHmPgikRAvIAMre+8d3FdcZ1CIWGlH
	K64/na/LM3TjSBi73P/Yi2GhnxZ+S0UJyTWuRKpuTX911TgNmZyJZA/R8L0TmhQa7NKFZB
	dbeNi95fHrb7vDLyywyankb0YOaf8GI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyE0zf7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTfZeiaXGWQ6vbYaGKegjGaFNQc9BuDEVM1zPEh/xbo=;
	b=mlJ6xFesVvAFevZ/S7qRXTfdqKPteldWyr+6pU2NunYrd1XbVBkY6jq8TC7dIln1P9cjPt
	p6ynPsESIrSPKu4y3H2clCFg8FVtdBPc7xu5owxm/E0N8gdL5aoIF57Jnr180nem3aCg7F
	zm2w6oyjxVTdj0o8l2EwH8ACBxoSRI8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2539E43E19;
	Thu, 20 Nov 2025 09:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F8EC19422;
	Thu, 20 Nov 2025 09:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630791;
	bh=O8ppzezBVngh9p2neSkJwi7IKljaPCF/ARYNeHVOvFg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nyE0zf7+Zm3qEjzxMy+D6jswoaBimOO39W356YHTZBNMo8zH0aeaxEbym99oYc6gy
	 wLqFIQc4dMFf7rbeeKyEhc5kdWQw6tC/hLcd70clP1tOj3ei8D7BJXc45z1RbBOV7s
	 BgCYKBFbX4iMq8jb/TvSO6gJbQc+Gg36FiHawDAe9k3i26hPvZb3W+gEHATFDqjSNL
	 LVgCVSqbUBOCrmwJdsk4jNUtHGgnlJZwZD0IyIm444iBFesnMNFlH6yCvSWC2f69jg
	 jLoMOC2QlXaBHleNVdIQyjCt+4aWkfdZr+aT4MGJrDmD+3IYR2LJIjQj7JZ0xWybEt
	 R7hLK7DWFIE/w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Mike
 Rapoport <rppt@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: free already restored pages when
 kho_restore_vmalloc() fails
In-Reply-To: <CA+CK2bAumctR3WyDW0b+NeeX22+OuCMkQ2VsGvnE1NxJwOVPEQ@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 18 Nov 2025 13:43:32 -0500")
References: <20251118181811.47336-1-pratyush@kernel.org>
	<CA+CK2bAumctR3WyDW0b+NeeX22+OuCMkQ2VsGvnE1NxJwOVPEQ@mail.gmail.com>
Date: Thu, 20 Nov 2025 10:26:28 +0100
Message-ID: <mafs0ikf52gxn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 0A6D7140002
X-Rspamd-Server: rspam07
X-Stat-Signature: eaygn717dttnjufg5ajnwdgykfcxb19d
X-Rspam-User: 
X-HE-Tag: 1763630791-669243
X-HE-Meta: U2FsdGVkX19L+LyYTh0CLPEnKDMShwf3kvLfKwlY3XE4pEquzHVu0POwH08iSuN6by6E7Gw2WH2ylR+ahy1wos+1jKwy59sKfqttWPeCCJP9LT6CIPfrYwxPciUGCV7h/tB5BFdOMmpwo3Lvk8aldc+Qj04bAueaGj5cSyFVZM28mALvSAR9NqmszwmK1lGjGz0krLIaMCcwGvizgpwFfvtCdwOQ42g9ENMvMAOy26ONkTo+ijRsvngKcpyLtRQYEm+hE1Gggrcgvb38ptAwQ0WoGqBkxTpxBQnzkzspJj3ZikVyQLVy92Gvz0U4EHQ/0VqXj5dfImGX3cA0aGUbWY1WZ/xamF0AXJ1HVRCMlDPtaT9qMeVsXLmMA2ZqWFEnnQJTXv0moszxNhZ1GIz4MRRgb2hq+zcHPZ2jU8YcP0uq8iNQsJVjQeNAI6BpoVi2Z3v2ajr53aFJBmjJ/SQphCBUQ673hqR8+oCkFPh29baRKR3nMKunUX9i50uvy13qtMyb3o5DC0ZxyZZdDhH+vOoKPtw157t2Mw3r38xOpu0bb7eDS12d5KHlQP4PG7vCes2/qtoMPUK3tr4a+sbf5ACWvdqbR+8ztC4RmR/69DFg43fn4gnia1eTMYYgbZkWqeJD3HsWh+JH1v/imVC/g5WOaTkj3CpWDrM5F/PM+krfc+V0euv4qRS+dmX29Viz+zNHRBJsTno3FW8fWigZ7B/gKAK03rxqEMOwfj//D6ei+mD3JAEiMgKCNQglM2pGdOdr/VNVNpT1Wnp7y2/76YNEWLgcjoteU+TN7nCKpfKVhIi29Z/wk9EpHSsIcVR/QVD9uN9dgItZ4wrXLX9YCtAAt+BUHpkxoihZ7H9Mtl0wWUvF+niFNyorlFN/UvXUkr+FviG9x1CqqUvr2QjLx/BHYWZ9GYb76CFWHQs+bvssO74ri6mFKjcZj0y/ykrcYuoZq6LJOiuTDvlEuIR
 R76cPCjt
 3uxF3lrTp1eti5zdwvHrZ0blYY4314k3bQg4EgcBxXZmE2Uat8TGMdxsbQf5DFdb1eAnY/m1MfHguJByWCAKmunLPrP9+rHUtYX/S4IqlGEoB1u6z0O5KFA/+5CSMcM7adMem7pC5oQvEHjZ2dH6pTLmm8bZOR2lmY1JNARlYCLeGWjM+m7s5nLyuNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18 2025, Pasha Tatashin wrote:

>> When kho_restore_vmalloc() fails, it frees up the pages array, but not
>> the pages it contains. These are the pages that were successfully
>> restored using kho_restore_pages(). If the failure happens when
>> restoring the pages, the ones successfully restored are leaked. If the
>> failure happens when allocating the vm_area or when mapping the pages,
>> all the pages of the preserved vmalloc buffer are leaked.
>
> Hm, I am not sure if KHO should be responsible for freeing the
> restored pages. We don't know the content of those pages, and what
> they are used for. They could be used by a hypervisor or a device.
> Therefore, it may be better to keep them leaked, and let the caller
> decide what to do next: i.e., boot into a maintenance mode, crash the
> kernel, or allow the leak until the next reboot.

Hmm, fair point. This patch can be ignored then.

-- 
Regards,
Pratyush Yadav

