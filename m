Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A245C61DD9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 15:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD866B0095; Sat, 29 Aug 2026 11:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF2E6B0096; Sat, 29 Aug 2026 11:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8D76B0098; Sat, 29 Aug 2026 11:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F35D26B0095
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:36:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 853E2C0182
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:36:55 +0000 (UTC)
X-FDA: 85154709990.08.FB79EDD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id C5A5316000B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:36:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Q0A3Nz6/";
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788017814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeRfXS7iZQ2FkEJ81T5RqxCWmbqtTOTFyVTa1mARMcU=;
	b=dzFBz9SCG+CDKMP5QGRz8FryoGRN2Gnw9t9Ao1aDVq91hEMlBKGPizJdP9N3uia0Ntd1xv
	6cpcXyfV+OwKOKHv9Pyqv89+Kbc1Ua3CbdkuvSUO07DoQvzjnJrtaPXiTOjnYdkWTewknR
	mzvPR3MmOktowqcwftWz/oOcSn1hhAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788017814;
	b=MPx0EB+pgIJcp1zZKe/iNP+YbQkjedZTRNj4AMjAMPsmJJzFyohEolSha0byXTfoBNLdB7
	VB/4Q6M0frJ5UaO1ZhahlkZ+iK92YcRJxOuu5NkbpiLw4MWBpmzIBKtuJu1c3CuDRkjP6n
	+6x4mD7BnCFnVs5zIUjcgE399BDj7+g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Q0A3Nz6/";
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jeRfXS7iZQ2FkEJ81T5RqxCWmbqtTOTFyVTa1mARMcU=; b=Q0A3Nz6/pla0TSuArKEcesDcHd
	k3WPi/TCrAlGRw64ZbL7aleMDC0Mu7RzDOXIr/sfMsifmDiM11KZD50aS5cximnLL9JJOxngFKG2T
	xhIrBV+ACbCBMsYZkKmipMXZFYQvRPLVwHJ7it7V9sK+vgOO4TEO5ybRBp/Z5ZVttUu9EpHknsEBq
	xKS2IXO+6QjjjghsTifG7dralwLJCCEtrK9kRZFsJMBz6kvsG/kTwU0hUTZYsCu9ryY8n43GKNuXY
	JCvDAP9UufKAEAJcXkT2sZD8VUEAL68ROAG7gNqHy5DKYfSk9dSyNSWVLara76zY8KxYUQnPbyPu9
	yWkShbSw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0L6v-0000000GhcR-3ihs;
	Sat, 29 Aug 2026 15:36:49 +0000
Date: Sat, 29 Aug 2026 16:36:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, riel@surriel.com,
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Message-ID: <apL8kdB0j561wl5G@casper.infradead.org>
References: <20260829100034.423064-1-trintaeoitogc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829100034.423064-1-trintaeoitogc@gmail.com>
X-Stat-Signature: snar985ehjtmjay13rymo71b839qghbg
X-Rspamd-Queue-Id: C5A5316000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788017813-316412
X-HE-Meta: U2FsdGVkX1/JPwTXqeW+IemvyyYuHebZeMliWWWpU7Iy65b1lgy5L6eN42nOOHRPn2wnF5xzZQk428wT1MhsBmVq/JcU6D4lzP5vqLPcx4RzbPXnyY9aZyh3b/lnBE9Tj9fmXuuJQUNZyxipSU7T5uMr17WjRBjzZVSbUEfFdRPQcjOPC1G2T+LzSmMR5SknpRta/zqDCXAkaHkFJH/PqE2xwFQ+YhgmpFLvm3t38MZDpo+V0syTNIEn9Zm7kqDIGimSNfmDIGP8V0ujfV846QuGSqvqO/NP2yPoizPZWoMNpN9L+nFHtbP/5ldSucopiojGQunwPpIaCMR3q0RrnQC3nB03NiZGVq+drAUngtAF2dBEA7z+cErv6GmiMukaDOcj4Uk/aiTgE3fg5semefk7JUHBsoddh+Mo978swBndiyfbxs9wTB6ej56kb79CMHWHQfCgHQYp7DOwtVfX+OIoTkqneWn2h6u6YDmJmDJN/qK8p1eUu1MsgBL7hIhY90Goo4GUpeOPwi0Bd0YlvtJDFu2Cha9Hxcf4awZj/8yNeVKGoIN4J2Cv74UiPhCeMZt0fDZZ1qOmWEcp/tWcvC2bp5apF31sV3F8RBqWIMCQcOEpLTgOVMrTtwjgzjck7R0O4HdDZjWL5+kP8Ew8mDn95BS3V9bVEHobTg4o+Yl3lhgf5lLqjRM4Ndk0CFjd8PbseCw2y+/yW+APNPK9lTFkPhsybKAr6II2UzOnB7+gwonFvSbcYfS1GlYYA3AByIILSRJjPhexjA/3i6rzb/bJVHV9U1J/RDbeobNCLc8mmt3wT3gfjYXZFgvm1avewkf2N3PPMF2rj2bbZ0zwlZOhslMban7g5k72f6RjgL746+k4+M4paQhZBnMK1/MC7EFTz7dkPJjX/Jv5iKcan53UocR5iEKtxBgVcjMcaHg8YzqWATuSigk4JOKn4hAsDw9L7PJoQ7/cAsEmUh/
 R7m64lDV
 X2gdHmzMY1d1LjMycN0XpwXONj0nK/GsYyGUZ1SA+YJotkdVlHu4JAYsEmgwqYJw28Iq0Hki4ZSDQAwGoT1rQnMJ7qEIaKXXEWOFW3E0iFfu75haTW9XfH4o91A1+N4v8dOLjmkB+GqtXN4Pj6ouacxw68VZ/o7syGjtfVWCCXiLwu2qHOJG/bXSTkBlpovvujYn8BxhDJ1gePXJkvKBtDftl4FZ1VE8F2pYsa5wcN427YXQXTTZd2swtZXDtPTfjsz+vNWNYdE/eXZX29whkXi/iAUTVcjlfAcTu6Fdclfwgmrn2RnPHqbRFqnYJ/b9NXtNsEqEbWgCnAWqlUctJXuHVgvAbDU5jM44QvCNqNx8NvYVPMnD9+m6dOiBzSYw50T7SOgCDQGSN7Plc+5P8RgCZ1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 07:00:34AM -0300, Guilherme Giacomo Simoes wrote:
> The race occurs because the reader (__vmf_anon_prepare()) checks
> `vma->anon->vma` without holding the mmap_lock and withou the
> READ_ONCE() macro. Since the writer (__anon_vma_prepare()) is holding the
> mmap_lock and updating the pointer, it creates a data race as the two
> access are not properly synchronized.

also this explanation is bogus.  i don't have time to fix it right now.

