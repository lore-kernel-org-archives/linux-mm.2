Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B54D2FEDF
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 21:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698CF6B0005; Tue, 27 Jan 2026 16:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C2F6B0089; Tue, 27 Jan 2026 16:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5286F6B008A; Tue, 27 Jan 2026 16:10:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9416B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:10:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D08D7D1EAA
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:10:14 +0000 (UTC)
X-FDA: 84378986748.19.B4D9BAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 32CC240007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:10:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0U5TKjCQ;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769548213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06zlAZa7hbk9CvagUK6jhYkK9NnVqMe4ifEML7jt2/8=;
	b=xOiPZNUL1HD7kH/TwbhbIMt+9atQ2mt4tvJTeD1dpTREzlxKnzWjsR2VHVKhaaf3X4hmyL
	a/7EKSGeHH049zkYEom5DukmQtH+PhXyWQv8c8pAK8qXlKASwScqIlvEnaXFp8C1GxAEed
	J+tZxz4MqOLxcMX8OzzJe7OSZdqOEZ8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0U5TKjCQ;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769548213; a=rsa-sha256;
	cv=none;
	b=NfY0pwC9kdklT+nf8pCHATdQk6H7RFJfZanocRShvWdB15LNHyTi0rNAGv6zFsXcAywRvu
	XNAxJw1zJIgscUHPu4ifR8FZWymTYJSVqvqfxgz2KOyhwMFkdPRnpm2a63x0gzHDhpIUzO
	EbyPNBtH93IS/6WxorzKGDArlLxBuzA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 793BC601E6;
	Tue, 27 Jan 2026 21:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20AFC116C6;
	Tue, 27 Jan 2026 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769548212;
	bh=bEhhEMYTusyoE3Pt2j/yJCfV/O/oj7aLwzklTeebDOk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0U5TKjCQFQYaM9JwOuHCeADxxD2gPIFZovPeFnK/yXYIMTVhEPaIO64M/LzyWCbJw
	 5vCSIMRHJRW8NyvmqLgzWB3vnL0UcUUeiObBVLyCWfFwbFO9/dTVJIZub47DgV7vSD
	 wa62q3FjRc6stXkFkGwjNybjSGYucV3utpJ6HcbY=
Date: Tue, 27 Jan 2026 13:10:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <zengheng4@huawei.com>, <ryan.roberts@arm.com>,
 <anshuman.khandual@arm.com>, <wangkefeng.wang@huawei.com>,
 <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-Id: <20260127131011.e33438112280b49a018c758c@linux-foundation.org>
In-Reply-To: <20260127090129.412084-1-tujinjiang@huawei.com>
References: <20260127090129.412084-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 32CC240007
X-Stat-Signature: 8aqyxah3itceskqc6wagqm3zmudjjhj3
X-Rspam-User: 
X-HE-Tag: 1769548213-245450
X-HE-Meta: U2FsdGVkX18GpVXlCrvs9i2Yid0+5iuzrJsrnDXrlSUZq9NcQGk5VhAFyDPlYUMMYpNvf21co5b3IzODY0gubdxPMWjmVDVA1S094ovL1ZJKbYPakvaMsyun0gNjbYshWkgKyY/pJKVWvY093QXY8qeHxCXEbjEp4SozHGOjHwOLyKRj2bwrc+uOuan4IGuixoELdZIKaoIgbQRTXutKjp3kdS1sizKPfAylIHOdFElJdSDF0LNUvPWNPvjRqbtRtC20Tyu68eL7w+M/n32Gvb4rtt2OSgwELIE2b2jh/iMFjPnq4CPYqihqM8piXh29hzMtu6OUpFVEkL8vFESXGT71QyAGo9zy3taP0an2Th7Xrg9SGKT1GchbIrgUkbRxTT2ZAPRwoGQ3VeFAvwSYK8n4xZkq83KxgyzrLP6GW1GKlLiio2Tyio8rghsfGqB++8dSOtPjvBG8HsNyhxD9PRQQl/qDEongpntKfelir2fMVua+xArX/pA9gBJazypShdRAybt3Rz1uj1rbeRvy4EVBtS1DjYlLRXg8N64YwdHpL4d0v+MWj8CpFucQDgXj8r4/gVVhfYAkJOIWO/isMjgvyqNc+OpuwxN2Sxp8kIwIEzmauhvKyBhE+5GlIVNXl8ouInuojuSQ0DSbiJPEmvKiQLiaH2LZIaOKLXVhGScRoQc57tndP3Pjtqg76OPrBnmrFKw3LR4ND39qx+DbtamDkvR9AbOPUIOlRdVFuoZKdlrT84z22Zp265q2HWSGbm0XhtCXCNbISetlX66STmH1L/N0C04cA01t50vSogwg6wtAWC90u1vSNYMnnlVbOS+Wg2ni/ZeC9v7m1vy6LFaMcVoRj/Andp+B2Y3xtu6u1Jtzt9dVZHl80abVCOvb+Lwlfs27xiJvTM7JGu699aTaoo/qenwoynqU8Q7JuFMzZYjc75hPcfU214bqj3r41wKTE9IcUBvompsni6a
 atW4DHiB
 WqUkc5QzS3AO23tkUZU+nxBEtAH/KHIa93apWGYGYCMuiF9u8FQ0j0cxdOFBAxLPQxMF+MMZ8JniraiB3W4CEoPxHD1PX3Y6JKYs3CX/oVjVQSqz2CCq83OFM74ummzruz7IgK+mhN++ZNKUmUdYyMlafUIpUIzz4UifOBClbaUUBSrVdoaQBBrckkmWo7aNh4aMNX7OuOJBWkbGBiFsqcWJDyiMVX/Q0PKEOLmkyLh9qOPHQb/rWkSFlPl/Pe5Z0SQsb9ei/LHw+hMlL3HmIcE6Ud1tXXY0YDG4pJOf2A/K9fRXTgfP9s16sgb9Evh3U7cRopPJOHt1Q5EldfTXvUx9MT8MEfeTfQEM5y8K7c+e0qs8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 27 Jan 2026 17:01:29 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> The root cause is that generic_access_phys() passes a user pte to
> ioremap_prot(), the user pte sets PTE_USER and PTE_NG bits.  Consequently,
> any subsequent kernel-mode access to the remapped address raises a fault.
> 
> To fix it, define arch_mk_kernel_prot() to convert user prot to kernel
> prot for arm64, and call arch_mk_kernel_prot() in generic_access_phys(),
> so that a user prot is passed to ioremap_prot().

MM changes are Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

Thanks.  I assume the arm maintainers will process this.

> Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")

huh, three years.

