Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AAB606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=aeK3Uqod
Received: by kanga.kvack.org (Postfix)
	id 2EBFE6B05B3; Wed, 11 Nov 2026 05:23:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CB86B05B4; Wed, 11 Nov 2026 05:23:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA8F6B05B5; Wed, 11 Nov 2026 05:23:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8F5E6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:23:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D8C4160282
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:23:21 +0000 (UTC)
X-FDA: 85422451002.10.15952E5
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99D54C000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:23:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=aeK3Uqod;
	spf=pass (imf22.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794392599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ULj0NXijTq3R1zAP8uyHKnM0ACD9LxvphraQmHtKkA=;
	b=JmvsTl/MYhT9OWJ0moLx27erlKZ97z/K4IhurJJpRd7Vr60Vqn+Nl6v+YwTZg9O4+rcFEY
	Arn86bnhDv3vAWwwSj02fznw5m+6DEPXtnxVQSmQ9cLYkUHBHtxKrJw3TxTKc26iuOWP/9
	sp/cCOaDftnqwAufMGmRiXZ4uHPLd4E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794392599;
	b=AX7DtwBUQVKdSOObL4bcf1AyOViWZ9IZt2BlcOuhiQH7O5YjyrmTgNzPmKW4FOPebMOCxE
	Ot6mX1Eew+h3MXYignSR5ca4GQWS0oHPcwvhx1CTJAUGzPPhg5eR+zEIUTWy5MusJWSv7o
	f2EVHMXMUiwu+wTV3O6lSMEaoXq4vMo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=aeK3Uqod;
	spf=pass (imf22.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4ULj0NXijTq3R1zAP8uyHKnM0ACD9LxvphraQmHtKkA=; b=aeK3UqodNlDWjBScGAVJ8KTmuy
	Cdsgqaz7P9Avj5eIOHiUlVFx1jai/GcydbFP8Lme3YNPd80i59nXuTrwAnZCoh2UpnUB7Ab0QFSb6
	BIwv7I13irUypCepClj8HBG8qoLa8ElVklAHKtygKB1scRfFjqKJR1sQODjuqVbbOW+Itf7sWqQES
	4VHlsEAfXSEC2aFEXu8zWClvKXtxHscqRVYyFct07Ng0+fKdPzikJO1Qw1ORI1IO3vgDSu1st2pSe
	Aqd8HRxQm15Q/TmeXKD9qUtvDSYkk9hBH8ljj2+H2+lcqjGTnOzjiyFeCyFSJTTneszC0+D/qMal+
	iSk6Bqcw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR5U3-000000091IT-1x2s;
	Wed, 11 Nov 2026 10:23:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 27E4B30025D; Wed, 11 Nov 2026 11:23:14 +0100 (CET)
Date: Wed, 11 Nov 2026 11:23:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Arnd Bergmann <arnd@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
	Andreas Grapentin <gra@linux.ibm.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH] [RFC] instrumented.h: mark instrument_write non-const
Message-ID: <20261111102314.GM1779021@noisy.programming.kicks-ass.net>
References: <20261111092231.2027735-1-arnd@kernel.org>
 <CANpmjNP5p-N6v=GiETYQMxgRMsOgKOdUjDCxSHj-6=pa4NkA8w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNP5p-N6v=GiETYQMxgRMsOgKOdUjDCxSHj-6=pa4NkA8w@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99D54C000C
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: y7oj4o3ypdz7odkzhzcc8tzg9nchx4hk
X-Rspam-User: 
X-HE-Tag: 1794392598-500967
X-HE-Meta: U2FsdGVkX18bwI43fEiuiZbKjh59vX6S9li8AMYXkUN801eHitIT8FdIvslYWfcdJMHN52S02ODjOpxC2N8Or2imJXku2fL5M5WqxcuR3hhg7snmtoImAMbYa+KxKSn9PygBgY7B3xXsgONYRZB2wSFVLwKk04USW+tO5AL+2CwRb4NBFPX34/bcddhtEBaTCQXJQkc9hvOHTYxKEyPNdNTEjGMxdHdc6zZbSwdomn2Ai6zFqK+Xn9aKQnZh3iWTIUXSkhnCiKUuS4DqQTBFJOveNouTt7o73PWCUmYF/j0SbabiXJw6QF/9acfIMGcutcTN3sj6SU+9xoES9tNFQ2cRVW5OYtB90qg1FEs297AZYmuwxGqQ1NMg7JCO33sse+Auo+T2r1h+YsnqIFKRAXZGVMNruR/6jobMi8OMedN2wFRFwZltBW1ES0oFpzLaxG89n34lvxVwOvwKdtjg/wqUOHvN4PahHTSxh0e+YHyWvG7UjbbSagOxSQLOu3d+OylFHNps/bD8MFzhB9Wp0Dbc+4OHmOUwjxO8FNcvneNIRvt0ZR+p8gz/3roFlmAVJVK+70zYvbOD+S8mh5cCLiM6QHpcLQPWbHzanmMR2CW+vLdx9C4UuymA2HKOrqAZv3VPwUAcl/kVHnrmUuULkiEMLpE2wIITu7moayXTFVh04Jf2gN9/l4S9Sqp5fQGJJHnODFT8OTQCrrp9RyMXbrGPIE7IuIOIZ3YomsfpcBCbTSwVquCy7Gyj7xKwTrM5AzSQZQCyVwUXSjKY65SKtMxBlKTVPCvgtdrQGoE0viGG9W59Mf2FZV9cen+BTQl23KYPOZXZpSKJAxIZjbyPFG1ud00APUbOiPfVNd+cC6DAEhUjm5ddbbtiJyxjZhsNSG9BFaXP69uiISwENyAV/5EhSwFiLzhq9quz0wot81h4FfKpVYXq7zRxn5PIlT9NGjqW42AbzfMotc+2Cf/
 30jgYDFb
 ZJf3yr3Sg1pJgGqo9cutzYWpHE2Lmxcyw7IYF/49G1lR56vrcXFTzpF60CkwpGQOe7reDGUEPyRBzp/vjMLRtoJKPtBt6m874slZjwLPu29bSchHwV8Ud8be72Lj656CTFdQhjX3/v6ScXskeHPj3F+yFR9MRYNAu1U9s3Kh4dPhpv3T0dl/b4p8VNWcK3tsPD6+cSMcITpFUMYkAHljgRGwfJfWuGhVKENe2CpG+qjdYCVqRB2UEn/irjUd+pRKjdu/Nc3iQlrFiBeQV2Pj8qWjPO0EsEWN2CZaCgfU1k5rUbdycLYvE3yXLcfmuAuKh53qeCOC6Zs6fxUfNmIpK5zVZne2XZWg0EcuGOtJr6FqEVTTEVG+P0hPYCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:59:51AM +0100, Marco Elver wrote:
> On Wed, 11 Nov 2026 at 10:22, Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > I got another instance of a -Wmaybe-uninitialized in ntfs, as this is
> > the only place that enables the warning:
> >
> > In file included from include/asm-generic/rwonce.h:26,
> >                  from fs/ntfs3/file.c:10:
> > In function 'instrument_copy_from_user_before',
> >     inlined from '_inline_copy_from_user' at include/linux/uaccess.h:184:2,
> >     inlined from 'copy_from_user' at include/linux/uaccess.h:222:9,
> >     inlined from 'ntfs_ioctl_fitrim' at fs/ntfs3/file.c:78:6,
> >     inlined from 'ntfs_ioctl' at fs/ntfs3/file.c:246:10:
> > include/linux/kasan-checks.h:38:27: error: 'range' may be used uninitialized [-Werror=maybe-uninitialized]
> >    38 | #define kasan_check_write __kasan_check_write
> > include/linux/instrumented.h:146:9: note: in expansion of macro 'kasan_check_write'
> >   146 |         kasan_check_write(to, n);
> >       |         ^~~~~~~~~~~~~~~~~
> > include/linux/kasan-checks.h: In function 'ntfs_ioctl':
> > include/linux/kasan-checks.h:20:6: note: by argument 1 of type 'const volatile void *' to '__kasan_check_write' declared here
> >    20 | bool __kasan_check_write(const volatile void *p, unsigned int size);
> >       |      ^~~~~~~~~~~~~~~~~~~
> > fs/ntfs3/file.c:66:29: note: 'range' declared here
> >    66 |         struct fstrim_range range;
> >       |                             ^~~~~
> >
> > The problem here is that copy_from_user() is called on an uninitialized
> > object, but the instrumentation passes the pointer into a function that
> > takes a const object. gcc deduces that any access to that object is
> > undefined behavior and warns about it.
> >
> > The only workaround I could come up with is to remove the 'const' keyword
> > from these annotations, which of course is not great either, as the
> > functions do not actually access the data at all.
> 
> Agree, but the code where a real 'write' happens ought to never pass
> in a const-qualified variable or pointer anyway, so I think it's fine.
> 
> > This also found incorrect 'const' annotations in
> > arch/s390/include/asm/fpu-insn.h, which writes to those pointers.
> 
> That looks like a bug. Maybe split it into a separate patch.
> 
> > Any ideas?
> >
> > Fixes: 33b75c1d884e ("instrumented.h: allow instrumenting both sides of copy_from_user()")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> If there are no warnings that appear because of this elsewhere, then:
> 
> Acked-by: Marco Elver <elver@google.com>

Yeah, this looks sane enough for me too. Shall I take this (after s390
acks it), or do we want to have it sit in a CI first?

