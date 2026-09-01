Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3F1C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F036B0096; Mon, 31 Aug 2026 21:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46D16B0099; Mon, 31 Aug 2026 21:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983C76B009B; Mon, 31 Aug 2026 21:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7066A6B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:55:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D56F01A0282
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:55:22 +0000 (UTC)
X-FDA: 85163526084.17.A4C5A5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 410E1180003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:55:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QTvMOsLY;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788227721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbUFClJ4i3J7LjCwTB/35AHxIba4ym0JuMW7MLg9RkU=;
	b=LFGrG7QHK0nEiBk/fVYvrinTzRPfBupGEjC5bmpXlxuTmiiI2QY0ehz96IvngxRgX7Sn4C
	t7iW2oTLDvxeni2EH9JL8a5onaXKzOD++2RhNtLmWLrYWUip0EPhgk9PDNv4UP0NC0VJwE
	goDFSTC7MUVgvXUTi/HpSLePcX5FLKA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788227721;
	b=qqOZMtohzFcaXdx7zhqDG0jAJ4LJrcULDpnW+jCoTstCYkwMl7Jim4Ggbx/J/UlpvF/jei
	kbzGdj2wXO/zSWgseXxWLsIJ2n0pOntz/tdPcwlGsJFGSAFZ5zfKU3NcOB3HTvE46z0xdI
	wxGkcXc+gRVdaNRI5eRDxEKgptQgA0Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QTvMOsLY;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A24CC601DE;
	Tue,  1 Sep 2026 01:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FF81F000E9;
	Tue,  1 Sep 2026 01:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788227720;
	bh=CbUFClJ4i3J7LjCwTB/35AHxIba4ym0JuMW7MLg9RkU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QTvMOsLY/HyZChL07OeBST7evAmOyQDdqEsNG8IojIx94RZcYBwP8DgxztrD6FxPx
	 UxNXGzD1L06crgm/t6O7u1Azv9jZngQt1/ls6DYB8X15tavuE8dNV9b/ojCvXtSt3F
	 /qmxq+B/hEDiFvYVf1+pwfxpoT/BJ9uJYAxsblw0=
Date: Mon, 31 Aug 2026 18:55:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, samuel.holland@sifive.com, David Hildenbrand
 <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm: Drop pxd_ERROR()
Message-Id: <20260831185519.66c6e6e83ce62d0fd9aee945@linux-foundation.org>
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 410E1180003
X-Stat-Signature: r51oeodzyeozczehuhq8pdzmj6yr8j15
X-HE-Tag: 1788227721-560681
X-HE-Meta: U2FsdGVkX1+d49hFXwmtzh4WJMx7sErPg6oxfAp9AxAIyHdHnsNib+GqcVU4YC+oloNnv02WfnD0RkDLYLI98LLK+aQ8VfSF952RCGjwC3IbEWZANrKVF8MGC8H82Elo2nlYUmnM3QR/VM7l6Fq/KdWtqD2VLAtSEDI7uiEiR079jHwFcy4SeckRpTpQiRlKIzswAn8E4PSaoUgxfJkQIo1xE15gCUbqJ3ejU1uPHZbT/LOort64IgiDhWbTiE0C1Rsnz2m0J6fZ0Sz/gMdMGhQB+/Gt9L34CYQ5vOsCiy2UKloAhLynHrtzfb85U6uRwYjDvIXmMKNFvoaoUc2Iyo1ejO8dZ0JYFH4O84Oy3/H0MM90Kh5rSBD0MuKsUQopT5+i4XbLEJcmggsedBAVnfxmzq+Q7sZOR948fZqJkztWuHVu1kTh5ikA4XnfVTcUm/e7W8FcLnxtTpDOJQce/MUnxROLxU3rUSwRvN5icSd7VW4LSRT5oIUrUFwwqwevXe1tejdTAxnOzitRCBZGngDSJVpF7viu4HSEtwNHDe3QiWMJc9FRdKCGfJLAGBFRTRXiCT4VST8h2skFnha20tUaPKJBJ9yTo3RJ0JGuA5u+LagkQpljD4s200iMwjf0811qt/GU/AMTQMOYsgYnfrUZCSNrIRHSxNzNgV7JyS1rpQWOZ/EJjXHjngZQZvYD9DMhP8b555dOODtiZUNHIn+wjiB8vGB05WKPCKXOGi75F2JkUWMf4MxSMDl5zDumWvJjI6D6E3VhsWdOYI2V1OK/8zOrwDm5mlnZlvaF/eWMkyChHdU2uPAkHLfdylBs8DdmAx2zGiNi+HYmgRD+KF7swCXZ4FNKwvkcFYYaneJCESmNgZZkTUP/WoxqMXmbTCaD06QO++5N7yYrESzsZH8jtZ6dAyBj+8UwCD7Vz6WdHnOcQGlEUGNhk+P5U4OIC95el3W3PgLuGLwW82U
 c7KA6XW0
 mtQS/eRWhwPPc+nLNmITihqwCOB/6+m23Io3Ds+GcSoFWAh7euXsbQG6K8Hz0W8mIjv+ln5DlUDiN/1Am9+Q+Utyh/+x8CGRV0X7w8IOIH13x4yG8d1z+lRJcP2eHDLNFlOb1qOQ2olyeBpgLKQOA+dczf8ftceJdHYC7NSgfy6xay8PtHedK9LLhq/nnbhdS7B20Br7rt61SbCRpRzWTnUEPV3cR7mrLjI5AutWsjamXWGGp5gimoYMZTWkmVaoZ8pOEKmQcTDX0I9185T22BK6374pSHYg17K0z7hCe44pqCtrYkMGI2qLNzYdWUiFy7QLugEc9FFrCcEQVfdLUExRt7kSWh3BYebPWysGP9kyPJZUMMKYpOuJpaoIImfWaEY2O72d5PbgPG0rXtR6Q8DW0lG2QIx6ZXFswVeqNy2o3NKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 11:13:22 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> pxd_ERROR() macros have been provided by all platforms, which are very much
> identical and can be dropped off completely if these pgtable printing could
> be moved to callers in generic MM aka all pxd_clear_bad().
> 
> But first cleanups and re-organizations are required in some platforms that
> are using these macros internally. Afterwards [pte|pmd|pud|p4d|pgd]_ERROR()
> macros have been completely dropped from the entire tree.

All was going nicely until...

> This series is based on v7.3-rc1 after the following patch and has also been
> built tested on multiple platforms.

*what* following patch???

Oh well, I'll queue it all up and shall hope for the arch maintainer
acks to roll in.  Please.

