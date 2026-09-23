Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3425C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 03:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36AC6B0088; Tue, 22 Sep 2026 23:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F186B008A; Tue, 22 Sep 2026 23:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B9B6B008C; Tue, 22 Sep 2026 23:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8173A6B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:27:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7486E140662
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:27:31 +0000 (UTC)
X-FDA: 85243591902.14.C9E80EB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 680DB140004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:27:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UXE8XzkV;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790134049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0coISvzCzyEeDfIWNah8qszPtu5rvdziCkddj48Ry5s=;
	b=2EqLNUwayH3xSLI4uAqnqehr2+DZA49j4F/jwvuoXAfnHVsn33qd7jhRii1HQSRQJI82Yf
	Yl9aPwEblD8sKYylwv2EDI0FiGCzBG2Ss9NxxHgkH6w3t+HQ/jUhUtnY2OtgGIF1EPiNmz
	/iP4z1cLa6WzB5nH/c/+MnpCkvfJh7s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790134049;
	b=QaktcvEsB0vTVJl20utOCeb2r7mZW0z9WRmGFhER45eZMGyGj1tIpaJdtaMF3KkHP1Rqro
	cgRNBcC3T0jiCC20fX6LKnCmpBMA13ZIm+l5ZOkKPkTlyxG/50ZkIYTiwi6FrfsDRzTuk1
	Hbl4VFxytkv7jzi2cfFu5mVJhSN3NI4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UXE8XzkV;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 639A81576;
	Tue, 22 Sep 2026 20:27:24 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24DE53F632;
	Tue, 22 Sep 2026 20:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790134047; bh=2LhZwei9uVYV+fWtaQ+UuqK3676UgkdxnXCOys3UUUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UXE8XzkVvf3yIoiTHdAzHwgTw5QqdgILMiymmPuOEu4DA3OYvUXPgW6uQebZscGw6
	 w3wX7S5jWKD49txEUMuw6ny8fgbDt32gUaW2yySzymxAlLdnk2qLuam7IkiIyqpQpP
	 G/0Ai7X2QccdfHonMs1/BPLBqUejjFwNssIR2L5U=
Date: Wed, 23 Sep 2026 08:57:24 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Helge Deller <deller@gmx.de>, loongarch@lists.linux.dev, 
	linux-s390@vger.kernel.org, linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] arch/mm: Drop similar platform overrides for
 pxdp_get()
Message-ID: <qg52wppwfjfv6s7dxmeefuadraz2hxp3wp3nqs6nxf7pflrtrv@5embd4fiz2k6>
References: <20260919101343.1959572-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260919101343.1959572-1-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 680DB140004
X-Stat-Signature: 6xbquzschsedwywb148i4yyi3peotzsy
X-Rspam-User: 
X-HE-Tag: 1790134049-891961
X-HE-Meta: U2FsdGVkX1/8BdqutBLg24AxYI/ej1CclSUg9rSy6s2xuRqq3YMCxlUB1VWhLvi/6Rf8MNJvAX49SIq2Hzs/oowJe0trSfbOlox2QPkFaLDYBgGN7/UyNTKSZ/4gOOnToT5FFpvBClxSaOM/neBBNAAUb9xi9UQpEG9puZZbE6qH4BUWzkM9q0pO8CbJgtqZa6oRQ4TtkDT6lx9agSln0bf7crnFoUCFbf3FeModhlJcAxiXkMaX1BHAq9kiJq/RS6gLWijbLt9bGyU/fY/8qgWPahv5CWJ6zmYKgHSPX95q+qC/rkdlrPvCl/+Wt6i6UIbecFuU9pmp5bbZe9Cek1ZFfQhiEPqwQP92sPAXKR4/dxPkDSq4Pd3Mb+LirbIzYsN0rOQISCeJ8THbtiXX/xG5ss6BZmwzS/1A4cUpq87Zu3JiFuZMd5JjOct2xESMGh0tNBPGD8clu25ayC1oG0DFTBNygRE1KHwv6n653LEBNFXshsBHm/gjLkmnxcypLTQjdWDGuz+ZKtz32Zsrsg/eJoxqX3rIQcS8UB4SYk4DhxFCwQxf0xZMYWHFPurgkFP+91O2jsPr4r55GxcFz3SG5zPHABKspf7CjnjUtx+mRBhEAoPINA3LaJMtXxuVTU1A7dNDZLr8iepLtJS6nMRL+ol88qhQ6hFTl+wtoRskYxaWFBTobF1utdQm9++79J5Yf/J03wu7GLqDt51xVJh8dfF9QdLBjet2nEFMC/C36JcT4q0NG++cadV7uDv4EpYIXqgtr5elEMfIMPp9qA4/Pmxxt7MoQigT62egtMw2VRb6ZROl8GRFTmzDjgWndPr0poO49iv/Os1BlZ1HnLoJvaONqylECgPSH1ygHrNyyBVCnn7x36qmsaTQCTf+hnRFp1ZBJ8WO11tYbJf/HE8422rXO94TuaEtZ3BBlHOXx5dr3E20Y0qd1GVqZ/C8MOyhw68W3UFeamsNxDY
 7T+GRjnh
 EIrkjaDCOnrqimVQnF3PeCJ8yDPL9MBC+Gs8DnSbToZ1U8z5fW8+pbgkUROlIYSMcwiR2tXsSTWgDIMu76VtLGzwyQs+8+ab9MJwVxhlr1wt3EL5RXsJf/h/xOUCoJPRDRC584TyOmNga33LQ6XOaN8RB+11Ho1z/yV1XYUPfJLY4ETae2yuB90vRL4peLBm3v50S2wo/XouKsJMcoFuc2qSz7QVDDK1vF53UnYKvegwXfFNPV7Jz8OEN0w28potbfUiihXcwURCkm2yzcknvlO/ZdljWEQDaagExf+temZkFTTsfgmwvFTuKY1TXzv4yItwp3sfthneeLgsl3ZYRPRWvRSlfujy2zivW3kDH6Q7XaWOklO4vMwb/6mIFPjMFBre7t3a78vtKc9dEy4FCdhW+gT5MZXlt1KCX8TAbAzjGJ4AwHIqMrnDxxqw5d9F3wN4/AjaY7PTOIl6dN5f2O9vh9wDXJvUWE9SKaNmBWwXqCH5YIHrWnAY26exY5xE89+dlATmIgEGJOiQxrvbpK+p0YdwV/5BDXLAAw/J0fPaqQrepnLRCNUT6MKwKZPWtHXe0g1KP4ZfEf1wms/kco1GlzNcDAr03/QDGwc354qM2x2/0UDQYkXHHxEe4tdXwrVSn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 03:43:38PM +0530, Anshuman Khandual wrote:
> There are many platforms with similar pxpd_get() overrides like the generic
> memory default helpers which use READ_ONCE() for reading page table entries
> These overrides could be dropped safely letting their platforms fallback on
> the defaults instead. Although it requires some code movement from platform
> headers to avoid build failures.
> 
> This series based on v7.2-rc3 after the following patch.

This has been based on wrong tag, will resend. Please ignore this series.

> 
> https://lore.kernel.org/linux-mm/20260918064928.793742-1-anshuman.khandual@arm.com/
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: “James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: linux-mm@kvack.org
> Cc: loongarch@lists.linux.dev
> Cc: linux-s390@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Anshuman Khandual (3):
>   s390/mm: Drop all pxdp_get()
>   loongarch/mm: Drop all pxdp_get()
>   parisc/mm: Drop all pxdp_get()
> 
>  arch/loongarch/include/asm/pgtable.h | 20 ++--------------
>  arch/loongarch/mm/init.c             | 19 +++++++++++++++
>  arch/parisc/include/asm/pgtable.h    | 20 +---------------
>  arch/parisc/mm/init.c                | 13 +++++++++++
>  arch/s390/include/asm/pgtable.h      | 35 ++++------------------------
>  5 files changed, 40 insertions(+), 67 deletions(-)
> 
> -- 
> 2.43.0
> 

