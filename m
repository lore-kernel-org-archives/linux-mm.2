Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B32C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15AC16B00A1; Mon, 31 Aug 2026 22:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9ED6B00A2; Mon, 31 Aug 2026 22:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEEDD6B00A3; Mon, 31 Aug 2026 22:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C48356B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:48:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B76AA0352
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:48:35 +0000 (UTC)
X-FDA: 85163660190.11.0E2AAAB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2DB2A100004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:48:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=usDt8rhj;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788230913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIPRUowfHI6K98aTZtO+bijz6IaH7fRlyyv5nHGo4e8=;
	b=qb1wZxJIm6Ak1gVqoGF7EYL3RueLZvv38zaS0ED06mf4okS2K6SR5AnFyf8Qa0SYd5rWH1
	0attWoCXJii/axL09LoZ/7LozmCvEGVmCx1pxCoq+0DWA642BRH9ZuCkrg9xkM2+kcoj1H
	b64sEDrOASEsmkCFEcOBW2tEOuY89lA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788230913;
	b=DlNDa6uqjknn2m8ZqbIv5HbUJLcDiwnkTyLZ/aM2c6xTOjL7tv2MrsKuHzpV7B2nLoJbjl
	CyFb6+CybwJdd4cG0gg/ZIgoPOf3PxLmdcYv6RlJlhb3d0ZPQYefEwaMz+27lb3kksK3QL
	Y75Mqamp/AwCX70AgcMS75CTm0C7Y1Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=usDt8rhj;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CD931692;
	Mon, 31 Aug 2026 19:48:28 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5150C3F882;
	Mon, 31 Aug 2026 19:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788230912; bh=it2TzzIDYTIEJor+n+hAx7Y9VTg7srHvqDHPINLC58w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=usDt8rhjPTPyhurOvXc8PdfuSoWH0nYsX72TOilRCeK51T4CARGkosyhwrLBvxyhc
	 l9WrmE/Q4V575jMJywI4lXro08Z3FihKyE+sAH5OZKnsGdk8N6U5ibobJVe6+qJK5R
	 M+KgzpkQ/xqu4+mMb5mvQGSArMljTWloMojjfQx4=
Date: Tue, 1 Sep 2026 08:18:28 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, samuel.holland@sifive.com, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm: Drop pxd_ERROR()
Message-ID: <44crgg3r7p2d26blmgq2ewqan3anfhdo73zxe52rvpcjsdhdvd@xztk7osntzhf>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
 <20260831185519.66c6e6e83ce62d0fd9aee945@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831185519.66c6e6e83ce62d0fd9aee945@linux-foundation.org>
X-Stat-Signature: ssz9ank11kb1zao59c9zu574ucsmjfyz
X-Rspamd-Queue-Id: 2DB2A100004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788230913-652260
X-HE-Meta: U2FsdGVkX1/2adxnyQ8SSIgmuSFaJIiJSZCbNElhzo0N5x9XtQDoOMGlAF/VFwtlSQ8AVyyOQtynOzc8Zf+FSC/1hP0BGqLwdJN/j5IwgaPFxAW+G3GY8Dajmfsqdxljf8IarESkTIKkumXQiIrcOht4TIQ2J6Ikro8/M3y+lBL4o/oUOeu1gjV2e5jRxlmzhAPSZJ4odSBCCJxiFqgHuGhh6KK5oRI2YoQY6snuvlMxyqddiVStLz7x1R7LwwQiTown+DkiH/z96/mcjQPx7BXsitqk/EU/eufS1WDjuLt1BCEfV7B219DyP8VlLmEVeTO3uR8893i+jRzEzqAgc2mQksZLhbzjQGtPEqb82EcEC5VDf1XhD67IRaoOti4PunTWYX6JSjuaTN6fJeLRSFKsCUNBbLPOtSyAgtsi94tRh+R8XJqYMl7Vs5yWG6zZsomvuLYn3or0zQc83whXmkJB/+qxx0o2EHk5KdSH8NYOB4LNcQZ0mAv+zYqlwaaQul6ShE07gS1BYbcyjHZYcjOkbmEU6x2A/XmEP9Mu+v9vykarX9W1MZbUl3Ignmyh8aertxchGYkOevvAhqJbGD3j3h5fDH4fMvEPfGXalxMyztsUYNijYWB/DkOfuRO0e6oRcFhjNeXOZrFoFKe6fuMuNd2oso9nLFDXzmatece+UrEdiKNa9AE0XNdThh/dlnMNefwlg1/0TClYTP8a0ZpH/r3E6vBNueG8tLlHUK8slGl3ao9pWlBhP1IvcrOtuDoY4R1bgvqYHyBR3jw4YCYDcsLqriE3zPpHVIXnn0PKsMnts0JrOD/PpEBkYufWEH2wDzFo29OJgHLP1mtDq/4FSRY7fEhtIYn+myOVA6ef/6QfUjPVIJmiCa39XCc94XzOLk42F9dLvIsQ2WLgF1mFPvW4UCv3Ql4RRi6WQ75e6GY3b5jeLQymRvZlR9PPmuUEghklXtE7Pr2zuXH
 UZKwRjpf
 0MeT/fDfQnAQoN+gOs9jHS/XnObo/I1ku93U3BFh9sCjRcKCDvXbtzeYp9GFjOX24GMo/zE44eS5QlKRDLDWDm5IU0IgNyO5Dt0xxZqGtCjyapyBNaQ8zXUsZQxMPRUNBIFYwKtwDHNkHHwTzLYG8vraI9YTt0M9SUnFUBxTI6OtBvvSqhHULs/dMSVSSRtNaN3sQF9WmUQHk/37xGUK5mCuewVJkbWGePC4CRkEiSl7Pi6jfGPAmuzwzf/lOZX9olSzs5Xj24h1ysP4jIW4m1QgF3Fam18c9rWhPnBDAexNY5FvD3AK0+ZWrd+sEyoctHdwdGz9gp8LQI2iSv1IgdutlzQEpdiUIG7aP6HDaoY1MAI9AHYUG5Zi457YNMQ/NXRPRotIgtWOlr6dnxUWlVNhb88/KS+aZ4ixQMfvGi/nQYRE9F0P5KKLj3Nsnu6dqLygxtSA/zWgnulM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 06:55:19PM -0700, Andrew Morton wrote:
> On Mon, 31 Aug 2026 11:13:22 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
> > pxd_ERROR() macros have been provided by all platforms, which are very much
> > identical and can be dropped off completely if these pgtable printing could
> > be moved to callers in generic MM aka all pxd_clear_bad().
> > 
> > But first cleanups and re-organizations are required in some platforms that
> > are using these macros internally. Afterwards [pte|pmd|pud|p4d|pgd]_ERROR()
> > macros have been completely dropped from the entire tree.
> 
> All was going nicely until...
> 
> > This series is based on v7.3-rc1 after the following patch and has also been
> > built tested on multiple platforms.
> 
> *what* following patch???

The dependency patch has already been merged upstream.

092836fedd82 (mm: standardize printing for pgtable entries)

Please ignore this.

> 
> Oh well, I'll queue it all up and shall hope for the arch maintainer
> acks to roll in.  Please.

Thanks !

