Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18F4C98304
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 03:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB9E6B0089; Fri, 16 Jan 2026 22:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4791E6B008A; Fri, 16 Jan 2026 22:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351C26B008C; Fri, 16 Jan 2026 22:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 243846B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:25:55 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EDA9B78EA
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:25:54 +0000 (UTC)
X-FDA: 84340016628.18.D1DF2F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0173080004
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:25:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SlqLB0L7;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768620353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYyowbdjzZoVll+3a7/rFDS9wqbOFAg1oZ9Xd+2hfGA=;
	b=GqBd0MpEg61negZXGJbWTdryKNwsIKK3pEZioMzHf3UnkQ9CIRK/jAt3BZCdv20Zax8w1s
	YoZ2xQ+x4nhF6HRqBV8qY4Inxym2N2odYnWh/f/47Tp40Pk0q0kAaTDol/7qJwhLMGd44D
	DsYzlyAS2XDugsSEfEKrB9PnQkQzF4Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SlqLB0L7;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768620353; a=rsa-sha256;
	cv=none;
	b=gzjg7pwSlx5S3brScmjblkVQ472nVf6Rgvan2zE7T3wKxndHjFIw64nUEB2vj/djOe9NMx
	Sji9OZjfNebTg8cVcjz60nZ3MEM1UOwazY672jJeEFLGlMUkZ/CH98EKeuj6OxWTMzD5cx
	JhA84MA8rWH8TSpSCh/fUEuankRRXKg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4D9F440CE;
	Sat, 17 Jan 2026 03:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE28C4CEF7;
	Sat, 17 Jan 2026 03:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768620351;
	bh=7ae7fLInRW3PF4gX/7PThpzQFGun1slC2hqvJiPHk78=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SlqLB0L7dHRDimWhtUJAop2oLyN4oW1rAONvME0yhAz2TSP0cGxNJS9EiTDGwtIXh
	 VPbQNu7PygIY8+ALLOUnMo6fmJqqzEu84wcX7rsyv0jBfud8u2FC6Y6jjMsgkT/3Me
	 64pidhpf6L5odTdpFA3eU4UzpPFh6c7wJ3rqG5fs=
Date: Fri, 16 Jan 2026 19:25:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, kernel test robot <lkp@intel.com>,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, David Hildenbrand
 <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
 chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and
 vms_clear_ptes()
Message-Id: <20260116192550.b4c4f18eed80b11ce39a1351@linux-foundation.org>
In-Reply-To: <20260117010707.202128-1-sj@kernel.org>
References: <vcxnsoihqohhmgurdkbx2hvybuhaql7yruv45k63jwevlpkdod@4eugq6xubcug>
	<20260117010707.202128-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: s5ehtc14zcru3snnxxf7k89iy19xuyi1
X-Rspamd-Queue-Id: 0173080004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768620352-301760
X-HE-Meta: U2FsdGVkX18zrxNKvQd0YVwfVpQUbfpRTtxQUfZFuNlXcfgGKkUGvRFqqI/9wI7d+wOFbtWDatUNLKKjMJUWgACJ3FAblFlMgPyv761Lo2ryfYVPg6LDnWY/MYL7+HwPP0bV6I7694Brxsv8QP4Fqc8otCWlVeiiAn+RbuGOM+fyNV6RNNp8LG7Kx5jd69TqbeThGq+FXiwWoV/XgXf1vldOGVm1zmqQemv/XzwM04vzSzYA7PuIj36MkiI9gs9wVwHrgqSNkmYQ9qYcPVHgfHpai4QEi6edh3UJjfxhPadSfZYOoPDOzOMr3W2e1zXNPJdVGbzLa7Lo39MRb5NPIGMporX7l3qLGZngkpPdY+lQ1qNlAk+d3YiGyV7+Sztel8UUL8zy5+Jb5dFMwV7MamGhmapgBitMCEkbGNwLXCuu2DMHSYX52DMEl0EwPVJRiAoaNY3rimqEBuLO2X1tOtk8d4ofBDNDg/yD7VNAGp0UoOwA0xwctaSv9hmI9KF0fN2lx5sG91qm8fuS6o7zyIrG5d/mY0y324X09XZfo7Gh4dZg7S6/F1iZT3F2HalyoNb9GfIGCtoe7mAzbp1aGyKEEzsO1e42XnrXMxazGpkPdZIRjIasoETQYCIWz+Rr3/Po01Kih9/GVQdhSCOx/Nc82xfYMnnzZ1z080oZAKTRdMktsT9pWZ3gUWm0/aDwFEMms+UDkZYykSMn9f8APX4epe5K+nTuK+aaqASG1Dn+SG8HsgJbyw6D0CVEMK4exylsPDuHkpZKGSmXzocyWaPCBomo5VBYRUXnvCFQmx3ZRDn38dF7JgihAhZVecTexCfgqtJ8JXBytRB846LZJZwi+Stj0QPuRW9KWVim6GLJQ2zvKQ+NjMOYwhGsx65CdwG6kynkDDiguooCKgzkiEC7Y8DVHM+ccnfxZ0LbEPj5KO97rRJd3ZRW7s9jvcHDlw22wSz6Dw6ui+oBZoj
 Na9nwl9m
 533sHi+31gFSKXtIOn+MQJpLRYXv7JRSJwYjShF19OFfr4ck3RPwzFrzj2ayBXr4QE1AeIBOH/x5J+fkAzbKTHFbzZ028D1xmtS1MxWtjvh5d+FoM1eE7TRcdqIGYPWJFDxY8o1IdZWm3vnN+TvzymMJpslsEkL4OcIX1w7TFhQC8jrB8eDAqOSH1M1jUmKU7wrsHYw+LAO9DB+K5VBZMT9pytmei/KOjqVHZoY2PhmX8ddQkCvADWa9v9APYEjjMgNCIr9eRVZxfprtxaE364Hr4Y7zjs/7ISApWEzV9NoW5RREDunP3sc00Ut0OFGZcXzbi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 17:07:06 -0800 SeongJae Park <sj@kernel.org> wrote:

> > > Suspect you need to add:
> > > 
> > > #include <linux/pgtable.h>
> > > 
> > > to mm/vma_internal.h.
> > > 
> > > Some arches don't define it and that header has:
> > > 
> > > #ifndef USER_PGTABLES_CEILING
> > > #define USER_PGTABLES_CEILING	0UL
> > > #endif
> > > 
> > > ...
> > > 
> > > #ifndef FIRST_USER_ADDRESS
> > > #define FIRST_USER_ADDRESS	0UL
> > > #endif
> 
> But the macro definitions are enclosed by '#ifdef CONFIG_MMU'.  I have
> !CONFIG_MMU build test, which shows similar errors, even after Lorenzo's
> suggestion is applied.  Should we move the definitions out of the '#ifdef
> CONFIG_MMU', or implement another unmap_all_init() for !CONFIG_MMU case?
> 
> I confirmed a simple version of the first option (moving definitions out of
> CONFIG_MMU, in addition to including pgtable.h) like below works at least for
> my !CONFIG_MMU test.
> 

Worked for me, thanks.  I also unbreaks arm allnoconfig.  I usually run
that but I must have missed this time.

I understand that v3 is in the works.  Meanwhile I'll include your patch to
make mm-new a happier place.


