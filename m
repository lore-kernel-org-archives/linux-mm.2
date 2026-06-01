Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7D4CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68596B03CD; Mon,  1 Jun 2026 10:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F356B03CF; Mon,  1 Jun 2026 10:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CBE6B03D0; Mon,  1 Jun 2026 10:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 968E66B03CD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:28:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 348D340682
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:28:59 +0000 (UTC)
X-FDA: 84831575598.07.22F3CD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 97F0B1C0006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:28:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFBQ3wnU;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324137; a=rsa-sha256;
	cv=none;
	b=TGiltTeS3TMU9ofEOdkYIVnzBfG63WK4Z189m7GuQ6Lar0k3Fv2lsVc4LuSDNlbH1GTHjG
	928b4k2NChvSLTbfy6NptztOsOz9iV+2PmEhYKEsCbSAfLBaYetq5dKzX8xtT/u8qXO/S5
	VZlep1AWBUhhcn839mvO0dN1jyffJQo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFBQ3wnU;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcytDXYzPwKDUDdHT+N4i8ojI54d4gwtkmZUP60KdkM=;
	b=DODbf8uKlGtQkg6HNgdjWzTPbsek2ucgjhkyJTtAXSZeV+9MScWKX+w5+HEQEEcpE+eEyx
	2tiRyHoP84g3yeiiMfnn2Q0U8DfvAvcLdPDEoizDXn5owr+ppj2usUjNbn1GfAA6pyyR1s
	uWpTdZYl/M4GaTVCzhxVN6hwEsmj/Ms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D9FA600AA;
	Mon,  1 Jun 2026 14:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6321F00893;
	Mon,  1 Jun 2026 14:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780324136;
	bh=QcytDXYzPwKDUDdHT+N4i8ojI54d4gwtkmZUP60KdkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MFBQ3wnUVZEzgVXBP7n6BLHSXSE0qD9Bm7vwoXNVZtdHWBlM9NTq0i+K9RQXuhWw9
	 mBZioXbaFvlvWuL3ExgLdSna7SwlLK2S8Qy1eI6fmf7bFYCb2kPhK2H7MGPfkRbcWk
	 R1q8n30NM6cuQZA09wD2pSFpVduh/yZgcmHrKV7JBRTpa+YrDoE/bKJ2AOHrTpFQYT
	 dFsQTkYS0tr4YjM0Ge0bCWiaErT/4amvCgJjqwaNBn6asSlXPArhxDM1uDzTAst/Pz
	 u7c9uwrYL4zA9u3HHEHZGX29EjtDsaOPQmZxaR8BcGfuodvdzymTg8ObRVJENl1as/
	 6sORXGX2T0SjA==
Date: Mon, 1 Jun 2026 17:28:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org,
	peterx@redhat.com, david@kernel.org, surenb@google.com,
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com,
	corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com,
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com,
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH v5 04/18] mm: skip out-of-range bits in mk_vma_flags()
Message-ID: <ah2XHd4SQOj6iG8Y@kernel.org>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-5-kirill@shutemov.name>
 <ahmQvfNk7S4F0LBj@lucifer>
 <ahsVyQZ5UXhJLct2@kernel.org>
 <ah2SL2c0nMj0KBtP@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah2SL2c0nMj0KBtP@thinkstation>
X-Rspam-User: 
X-Rspamd-Queue-Id: 97F0B1C0006
X-Rspamd-Server: rspam03
X-Stat-Signature: hepy74uddq5szu1d6xtkporqgaedzdhp
X-HE-Tag: 1780324137-929568
X-HE-Meta: U2FsdGVkX18sUWTIQ9Pdy8GsHXdh05yv8OFl/GGEJccFSV26jmp1sf1Ic8aIVH5l11mowFfrpm3Et6hld6PgxscXgKCsQdO/AD1jEJk7414/xt7wVRCwRaLtLVKvCMfQ7ryxfe9Tnla9WSoJPvVWobEoLG+d/VlBP4GgCLcD2tS7x6gcjHfGqCjiVshIDnab0EB0vYW2LL0pdBMVRBwg84efojnL168c9WaQTJ+lbgZOi6QDoL+SuChWDS6/e5w0miLLQRalwkWgg3sLoH9siX5YtsZeryU9pa4Btj4Wk6D1kApdxwtjbGaCv2OuP3kjTCzvCBh8MDEWE6buHqod47agRJCPqTeaUKQ5N3jMT+FzjaNBaN1P2pON+hhHC3zmkfcw3e6TJ3tYM4rKinCh1DulqM6BrsPZFmkd1M9T4KoiUcKX5303nTSqbyophrAYsQxr8fGYDkNudzoKNpR+lEC/rVmxDeUXVIYJ45th1HvR+JH/Twbs2k7VjJpT058ennFzsnrPhlJtqqG+YvBEXLQtGk1J7eFfeP3bah2zVVtZAhL2BZselRMXBbxH4CXRhiKp1ExzPaTZqOfadO7IljLEzyPJZysTsbhuNuEJ/sQTgQvDg82HmqAGWzuX5Prjtbj19+lo9cIKIi7V7lTv/W+J6qQfwFO4Kr3RG+xQEsTDOQrZgLRkQq5lJKr0b+n0PoMrZy2r/xobI6AEGRzXLaiXuNHXXknPqobB9iPQEuwc4JsEWe13+zeixPiwpXR8Zu3jouvlVREZxdq5mt1oyBnHZPe3r903D2sQb+g/hACBq5Pn0+pbpL3/FTady8ewU/3Gq+nDtx6ljSPNLwAto1t3+OuaDPpiriRk3Gz5P6AYQxgsG9reERe4PvkMaVPAKVpHUiroqheiMYzyCubDW4ZDydbEbKVtHDlCuT0pAbqyt/VYOrILIKnLtb6whYFKX7OnK6vcXv21hFM3QxH
 mwxfejNV
 EXEa13zztYH9x/6/WNMyccmBpK+aACr+s42WKIYyuKWV/GreKebd5EdPxq4gdNhnF4GuaQbu9uBpMfTu0UfinXJBSJf+nAaZKPfs1f7Dc4ZKac+YFFGKFnbRq60SHbL+8rHbLrQ5dRrDXsQhQ4WT8NqoRsofL4QLGU0gMVg1MiL9Fg1YUK/X4mg8LBRds5/hQPtozgh7Xrzvjxu9oEOsSxrftec+Hg9wcFsGya15azO+K4uiTFQBPt9VvXl32HRgToadJSLQXXOhg2K/cThf5AQvoBIrN/sBh/fT7ZLxdJ4VEGBiANKLG2G5mRXIzDH1f1/F2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 03:08:19PM +0100, Kiryl Shutsemau wrote:
> On Sat, May 30, 2026 at 07:52:25PM +0300, Mike Rapoport wrote:
> > I have a PoC of yet another alternative:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=uffd/vm-flags
> > 
> > The idea there is to keep a single VMA flag, VMA_UFFD_BIT/VM_UFFD and move
> > all the rest into what's now struct vm_userfaultfd_ctx.
> 
> Nice!
> 
> I assume it can go on top what I did, right?

Yes, it's already on top of a previous version of RWP.
 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.

