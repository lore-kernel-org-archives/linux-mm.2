Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5885ACCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 18:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BAB8E0024; Thu, 16 Oct 2025 14:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C658E0002; Thu, 16 Oct 2025 14:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB1C8E0024; Thu, 16 Oct 2025 14:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA348E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:22:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05D6A1DFFBA
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:22:56 +0000 (UTC)
X-FDA: 84004798752.29.8A951E6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE392180013
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:22:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Rzgp548D
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760638974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hYYv/LwA1GURrWhGh2MDAllNLGQ7zQ8O8L85h5N1Cg=;
	b=IK/w80wKv3hrwiUH6Snt5QB1uSah5mCAis9XtT1NfJ4ts3cs88k5vAIptGJSwq5FcdLTAE
	N5fFgKe2uNBLenQcNq0V178ZSRRB/8ozvCnpchISOWoRgmdRoLOmnoaDJKOfbgZ+kLCqnk
	IeM034kWD028ir3P3AuT/kGZYL232W8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Rzgp548D;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760638974; a=rsa-sha256;
	cv=none;
	b=m10IQ3GYdIDtRm3FtGBJIDx+0d5+X+rP/TZ9kaPZhzvnnL7Zw5/8JzTWjMFiwuB23sVqvW
	O0Azr2d4bEXEuxggtVhTIyvNYGkSYPLqKRmwLo2Bwtyo8bBcuBOxqZtsMROIBgLOKxRXId
	lrk8ffRkB9+FeiTsCObDBs+hMxKRtNs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0hYYv/LwA1GURrWhGh2MDAllNLGQ7zQ8O8L85h5N1Cg=; b=Rzgp548D+FBSB43kwyHxqonghH
	42O4W2Z8TY77zuQ9poKmtvJObgCWVNT3JfIjesTFpvm/ShNqIvGnHC77bY09mhQ87U2VKDQSIdHyZ
	78ZXZYduDtDxyQGi3hQOWhD/q8yqr4SnTUzqMJ07rdZLesOVAz2L6EU7tBO1cBuFHPa2qIP3MLqcu
	XJCMmNGPDaKSSYP8Rw0tfLh7qXFKQ82fuVLdJnSggVOhDZd0jGX+5/1BSjSHBI1TNe+gDY3cYhsNX
	O2G6GCXwBDfX7s/3sXay9XEas3Y4+p9GGp0hxcVEXUwmYI0sX/tHSk7nBMmD3rD+Vl/Su7AUjYLDq
	waLsZxnw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9ScS-00000009YoF-2lgw;
	Thu, 16 Oct 2025 18:22:32 +0000
Date: Thu, 16 Oct 2025 19:22:32 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	catalin.marinas@arm.com, will@kernel.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	anshuman.khandual@arm.com, yangyicong@hisilicon.com,
	ardb@kernel.org, apopple@nvidia.com, samuel.holland@sifive.com,
	luxu.kernel@bytedance.com, abrestic@rivosinc.com,
	yongxuan.wang@sifive.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, wangkefeng.wang@huawei.com,
	chenjun102@huawei.com
Subject: Re: [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for
 arm64 and riscv
Message-ID: <aPE36PlriswJWSKD@casper.infradead.org>
References: <20251016112704.179280-1-yintirui@huawei.com>
 <20251016112704.179280-2-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016112704.179280-2-yintirui@huawei.com>
X-Stat-Signature: jj5wo9dowh9at31tyt1cid4uoc3sc8jq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DE392180013
X-HE-Tag: 1760638973-492716
X-HE-Meta: U2FsdGVkX19xgxL/QT98m6/dNubpXIT6Bh9inN35agp6LpD2D8e99P0vGfdaettagYwM+zJTrKXVzsIoXP1lilNYXcjQ1XzOH4rdUnTm+vnnmShQCOEbAzy4x59JvoX7tLVCsQfrrTEpC+o94Y44H+9t3UG/13wUMlZHdQr/pS34q0c/aHoNJ07Dk46Kar7B3+QQgKL6Q0GuSk/LTpg+4Mt0Cop9HE3i8u5TW5CY6/Zkoseuu+QKr3PHIBQqwoVXTIwEEdCIgakmjMND7iF2gqY5qKZONz4CnZShVarm/TNZIuFV+eL8Vxgk5lwFN7Sia6yxShPFzUDEYK+0eqVackN+m3YS80pzwjGiPkZnDgy5g5KpEE99SlY4lQk9DeLNsD12RtowhFUP056bibcOqL88X1FDkPAJYzgXVDQ8AiHNVW5NpF+XVLmjwBepT34G4mr5UMy9gpfOFZE/sdTg64Gqb4wTQBR0NXNu73TVCjx+OAq88uPbkeIakfJXEXM7Fs7olBTJzvAHW3YQORD+LUeEQFvHMc4GIiJr7KmSzZKceLpENHRTj8NIVXXZa86Rux4ned/tPbBSJvxginADLQDWUvMx66bluXWZeT2AaQoLIOzn108XebPvuy28Otn69aZ9n0uMCplzKxVeIfOsWe7YdnAeKxUw3F7eIh3DUWRFLoJXPtsm5Rq1nGasLH0YolPKi+BGS5Mb0BmwGJ/22Dbp7pGbk1Cyk9WMIrx5vpSUgRZZn3yJCcUFpmqL48eS977NMpI3Mxo94P7HYvNo9Fi+osh/Cv2gjinn1MGy9oBYcshY6XowCQbWt+2zS2iylzlugkFJm8e/ShAGnIo3PlX3Zt9nWgovsg+du/eM7NqYktOOylfSzo1iZ7pBnB73b1QjmkTNv6TmU4NNnpB1ctQPm8Jugrk3BwUz13oBhXo8ahHdf2J3WbVTmqemQZNaaAXJVqNIeRZdseySk5+
 x6jBMEih
 r9kAp6y5bXoxhJp04JVLJV2xyEiiwJJJ0hbSolR7dJIbY40EtjF6vbcvZdtlbGUucp3KMqVWHZWUrxdyJuRX1y6605SCsyCX//wLwcgNUKfw/YmbM8LznOALSZnPeiUEGq82nPaHKj53JrVrnGW67cpNTE8CkX+7+qKSVD+7Aow33A6CJPvhoX3BxddICE9RFdk7eR/SE2DPJDIrbAKGg8O9FYtPevKJmtunc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 07:27:03PM +0800, Yin Tirui wrote:
> Add pte_clrhuge() helper function for architectures that enable
> ARCH_SUPPORTS_HUGE_PFNMAP to clear huge page attributes from PTE
> entries.

I really would prefer to see pte_clrhuge() removed first.  Otherwise
this just goes onto the long list of "somebody should clean this up some
day" and nobody ever will.

