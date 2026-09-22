Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D886C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA49F6B0098; Tue, 22 Sep 2026 07:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B826B009F; Tue, 22 Sep 2026 07:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB86F6B00A0; Tue, 22 Sep 2026 07:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCEE76B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:59:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59A08A5F8F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:59:12 +0000 (UTC)
X-FDA: 85241252544.29.FA8D93F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C9BC120004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:59:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XsS7whYV;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790078350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWV8VPdptiBeMeQOpQB0KZQcSjJ+YKNTLPJopvTQN40=;
	b=yC2fozFIbIbq/hr1f+gzKeRTAmydBV3uwCf2hXZKIGBnuEabCZUJrhM//wAg2Y00sC8uQC
	lKzaz0wFqiQ6MAUK1Y9/I/mWBQFXcIra6Y7ChjmlsBTR6xnJqAhpGSPz9CXfid36MzmACj
	kYnnVegGF4SROjRWdjFMfkI8l/bvPoo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790078350;
	b=Q0+kDS4GopwElAfxELEMYfWVJodYC+Kp0r0GI3jeO+sMyVwCnd3xHpZh6/s4GS4pWrxFh1
	AZw3Gshb9H4YmMEpE18M8VKaRZhfNrffQo/l68+8BHT3Ru9PnUenTRHwQfILRQ34PJzHh+
	OA/mB6X0yrCxCNuOFBYsBqss4ODY/FY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XsS7whYV;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B5EF601F7;
	Tue, 22 Sep 2026 11:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113A61F000FF;
	Tue, 22 Sep 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790078350;
	bh=HWV8VPdptiBeMeQOpQB0KZQcSjJ+YKNTLPJopvTQN40=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XsS7whYVEozZ3YLFpFFcGaoNfReDX1brkr/7JIBgcT0QIQ8ij5zLiLdifdCqZWgx9
	 +fRa5XDq62q/SW15wAwOBYAjGhvbHfwQywREwed5Sx+kvac45jdB2kxHFIR7JxfzXT
	 tOa9/Y/Nw4WNsnLHtfUUyu4pWxuosDRINvT50+v+EqY6h4R1x5iSxvhJ0khYZYnzSU
	 fLrkjRkXjLQrWAhCjcgzP2Xmv/NGzCLbCPLwPACHv1zadE8qCjp6ZbkT6HUOGe25JX
	 b6PPS1W3jk3LcbB/DzpTTQCjW60A8LKchRQoqL0NaHEf92rwUVU+3ciJu8lwYibVn/
	 VxqFN7FHjwnfQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Baoquan He
 <baoquan.he@linux.dev>,  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,  Dave
 Young <ruirui.yang@linux.dev>,  linux-mm@kvack.org,
  linux-s390@vger.kernel.org,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vmcore: convert mmap_vmcore_fault() to use folios
In-Reply-To: <20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu> (Tal
	Zussman's message of "Tue, 15 Sep 2026 19:42:15 -0400")
References: <20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu>
Date: Tue, 22 Sep 2026 13:59:06 +0200
Message-ID: <2vxzh5jh5wfp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: j1srncpz63jwt1onawtixdyar1n7t5za
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9BC120004
X-HE-Tag: 1790078350-70343
X-HE-Meta: U2FsdGVkX18U8iyHJkdF4Sv3kW+UGPjNx28yNmbhlsF2r0eD7//F2s09AgTetq2UzMcqx95G3mfkoun0JyY2Rd3e1DuBvefhAOyxqrq0uoIE2CQn6csDms0UDxnDlPp7/SySdSls6gChDSVMjFaOnE1GtuHIFSN5ncp+86GZN+UmC/V7wYaeMTFIpDC3baQEnzCNmmbB07vskvuznA7680gHqkXFLi9kyL2GBKp32FUOhZtjXafy8yM//hEdIRUukF0fyygUKeY8Q3iUqh71MFdlbWuJYjgbxx20pUSudllEnto1LmX4oRZFIcpyfDux9q3+gnNr7y4cmoJgzSwdVgFcpogmaUttCXDEiPVVDfamQmScSMzRxGM9OI2I0qDpUfkD5ekZMy1zIg1uMvgFcJ5E152g/G5TU6v5RbcqFkLy7GYSd51hTaawlv3N3HmV7YUVMKxZfpiZZUIBA55gKPoyfX96qhm40Jd+R8djUFnm7UQcCb6wAHzSG2MXuqFgPs86IawWsLI8DktOlmF3glxrUnxrUXsk2T9cPXxnepe7gDa7MRWjBY8KJ5tPAFV+z2CFBEu457woneGuam2dwrPslr9HM0SCx8GV3yeYoViJMIOaNjrFAuiVuN+s9SCrBAc8cR0u0ZShbY8OkyRr6313MAxhGz9jQTEjTMRWN3RUfdj8Y9wq7wk1NhjLz3IRpUa5jHM79tt/F0hwOifVMdlrWvCs3UqigyX1arRGM2kSgos6Arf3obsrGfP2ZihgQ4uYWXEKfTaYdlDCpiPT7+L8/zkt9F52n6XPG1GRwyyG7RkbzWTUjKy5/vFzu/422UeIlMXbFv2CLqw67zg522BoaJ7gJ36cu7K5zORKpSd/9VgEt80XlCWmXeA2qq77UdODs88LKTfL6JyC12UN3wEEAZsCZFDR1t7XxM9ztA5PxsDF/yYhKNP3C1dLqu+ATAYqTYjg2TnKEg1kCBa
 iTrbQRs/
 XTFRdEwhBhPveb5TtKqAZ7w1ZBBX4GJsjyfXqY5xURV/gZr58i+/VF3dCqYtBkJeznyeka83JcIHIeu73vwvWkdWGNRPuqy0aIdd4K0k0SflHHN38DjTlA2XGo4Ci1aNp584KfrVfR55BfrVmPKKtE7lMMw/VzMfugD4MU6mNGClGr4lCJhjNAHkPu3Qd/kcoLDKZtu0NUrEIptFfGBr7vlq0fR/K28j8OUYUP95QPsbAnYZrLyhhbzn8CSMNPp5KCuqcprh9W5+D3a+WCNXML3q9lGNSMkJQfDJa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15 2026, Tal Zussman wrote:

> Use a folio for the page cache page the s390 fault handler reads the
> old kernel's memory into. This removes four compound_head() calls and
> one of the last callers of find_or_create_page().
>
> The vmcore mapping only has order-0 folios, so the logic is unchanged.
>
> Compile tested for s390.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

