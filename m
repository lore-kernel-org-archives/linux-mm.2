Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55285CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 16:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B251D8E0033; Fri, 17 Oct 2025 12:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5968E001F; Fri, 17 Oct 2025 12:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12D58E0033; Fri, 17 Oct 2025 12:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9079B8E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:02:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 637291DEB15
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:02:44 +0000 (UTC)
X-FDA: 84008074248.02.5633805
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2B61C0003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:02:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FyrJXv5A;
	spf=pass (imf10.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760716962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ND5eB1QCFY6Skiz3g8KOlcxvtTH/lier+fk4n0rckNI=;
	b=UERSZeJ+uIH23hsp4FjalpKbrfYPx0LKAX2w6QP9rD6UKR3jjtK4TwywpXdy6VM7N4JBeZ
	awoyYrdwPnwrm1ZYqTwCi54zcJQ0A6gEdDM8txlWaQ0bnaNkJTX9wVRRK0bCWzjIpVFecI
	tXxhMAkXZOF22w9P7bVsfG/+zt/LRIs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FyrJXv5A;
	spf=pass (imf10.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760716962; a=rsa-sha256;
	cv=none;
	b=46bA4PRhzSk3i+uKGB4nWNC18nB9gnrmio4q5jySRGcdhhvjJTTGmowOPBHLwi9GJCoKfs
	ykya/anQdFos7dEpmCWG9JTGKzpHy78RhduqQLCKDqobLBNntQ/d45SgGf7iiRj44+aYhp
	b6ybd7diK123Te5YlH6WyTaqR3fW0s4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D6C964768;
	Fri, 17 Oct 2025 16:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8862C4CEFE;
	Fri, 17 Oct 2025 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760716961;
	bh=3mM1lWUTizz6VVL4elvU1BRGI2YzNN2VMRwTvXHMgBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FyrJXv5ACeinmvzHl5wHECEdtIt9rBJrFJ8bp6CJbsqurAL0J4hn2Bcdw9CoKoChJ
	 ZKhv45UwKPRDAAvkpA2sA3k0CZiyyl17HSISQODpwPBsowr8SlXYv81OwnTwNbWb39
	 Ild3/43ULgbZf4M4dH8yq128Zg0srGNIFqcECBRnz2l2tBP/GH7FMa9PDd40dCtgHt
	 AGswEEmu67omIZ2IjK0ppEM6s2efJAjWI2/XU6+R1COfUi3OCmLytLzj4UZSXGC2y8
	 MLk5zuXafk0BRFgdIOIMg+FPBevs50BmAhTwdGW/wLJxao2ty0oQDdcuQG1NzqNa45
	 JowDMc74vEM+A==
Date: Fri, 17 Oct 2025 09:02:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <willy@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>, Zorro Lang <zlang@redhat.com>,
	akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <20251017160241.GF6174@frogsfrogsfrogs>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
 <20251015175726.GC6188@frogsfrogsfrogs>
 <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
 <aPFyqwdv1prLXw5I@dread.disaster.area>
 <764hf2tqj56revschjgubi2vbqaewjjs5b6ht7v4et4if5irio@arwintd3pfaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <764hf2tqj56revschjgubi2vbqaewjjs5b6ht7v4et4if5irio@arwintd3pfaf>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2B61C0003
X-Stat-Signature: 3ky56g9yd5ygg1pcadifryz1ze5qrjh7
X-Rspam-User: 
X-HE-Tag: 1760716962-604628
X-HE-Meta: U2FsdGVkX1+aefVdOqz/9wM2nSaIvvwghuKFrrRPABsiPu00dkikHW0/5uIbeLCEq4uySDyeLgmANn2gz7qVHaoJWDPK2c6THKRAIqfPur8oTAW9QtrPQCvMUtNLW2zSKA+9Db/wr74/CN1PpAa7PvhvfIQP2RzNsjBax7RpCIf2Zmu+5aX/0glHI0hgUPIdD5oPD6L9L83nkdUfqhEAkmRWTo7azRknkPJj8Btds1VZWYxKi+UTdkIJ6l0Y8DtD1ozSwmE0nWyXgwGS71E4op5/uF5QwDnS+Y+sC+oBwgetvu6zNtbHckcBarUxfCOfz5xkcaZndh/1wDNrkl6Jb7l8LnxjU0nKgA6XgQu9rxdz+SK0j36VwrYu363uFGK9yfznOvpUzgyHGKkOhDaFpuFmuBlIsqxq9cybvjg2fpUgcOjiVdaqSpcwR86+8cdjw6OT+LNWBorVbNB/UcB6P4wLVxu29p+rSmaiDG/WhyQJd9CmNF30VlDsOC0CUTDUb6aWwF+Q/2ojS/1CmslWuPsLFJqNTWfKLIfsP0y3ia1+2r6aaScq3OOTtD48FRncEBVioYnJaWhVSn5pc7bZSQHdqsWX6BVCsLPGZnDk2nAu61uM28qtyHrJzTCiwmr2ytlHohs0FjKqv6m7DeFWuuTgEFhjbGClhmeK5HsEGEElIXnr9QBq7u7dBxSjgYjOW5/zQbM8y/PMB6coJH1aCICQyqjOII5RecarAWOwZIOc4myhiAhoat3PxdJcm4OUJKGEWSzeMLf94hfsxs2iv5OCwCDcW6auCVuE2Xe1tPWMvoJPfYmScc7Ou4/Rc9geZyUkbp8LbYtILs0oM4w7xJ5dEIB+5CBWfsoDettzON2fV85KEetPAHIes7y3q+ROJuJNHuu+ehKTwqNL+oZ72GicIWr/OkA7SmcJEUHM5DDupxwp2g7x/zEhb4oBu6C0/sEVRpW6xtNfRCFMdm+
 4LP3fn8+
 DHiGDF+AKaqX8dQKoGJo6KiX12x5jHssnzwrkWN+V30nhbl2Mq5oO8twV+hDyJic2EJrJYQAiMUBC+M/EsAlKcbBkV9+pJo0bY4D7e4PMwk5bln+W9aDuOrdwoUUvlyhpZFO3nxvBjY8SBSh9iLNcBB33yV0xa8TN3riEqrCTzPHSNgcVFMgeKYUSe76OTqUQrzb7EYoreBd9bIJGIe+tFmlL3HsyW9l8A8aECP3qD5mneUmgGw0idbYmMIpUtL5+XFoE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 03:28:32PM +0100, Kiryl Shutsemau wrote:
> On Fri, Oct 17, 2025 at 09:33:15AM +1100, Dave Chinner wrote:
> > On Thu, Oct 16, 2025 at 11:22:00AM +0100, Kiryl Shutsemau wrote:
> > > On Wed, Oct 15, 2025 at 10:57:26AM -0700, Darrick J. Wong wrote:
> > > > On Wed, Oct 15, 2025 at 04:59:03PM +0100, Kiryl Shutsemau wrote:
> > > > > On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> > > > > > Hi there,
> > > > > > 
> > > > > > On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> > > > > > with the following:
> > > > > > 
> > > > > > --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> > > > > > +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> > > > > > @@ -1,2 +1,10 @@
> > > > > >  QA output created by 749
> > > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > >  Silence is golden
> > > > > > 
> > > > > > This test creates small files of various sizes, maps the EOF block, and
> > > > > > checks that you can read and write to the mmap'd page up to (but not
> > > > > > beyond) the next page boundary.
> > > > > > 
> > > > > > For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> > > > > > folio to cache the entire fsblock containing EOF.  If EOF is in the
> > > > > > first 4096 bytes of that 8k fsblock, then it should be possible to do a
> > > > > > mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> > > > > > to the second 4096 bytes should produce a SIGBUS.
> > > > > 
> > > > > Does anybody actually relies on this behaviour (beyond xfstests)?
> > > > 
> > > > Beats me, but the mmap manpage says:
> > > ...
> > > > POSIX 2024 says:
> > > ...
> > > > From both I would surmise that it's a reasonable expectation that you
> > > > can't map basepages beyond EOF and have page faults on those pages
> > > > succeed.
> > > 
> > > <Added folks form the commit that introduced generic/749>
> > > 
> > > Modern kernel with large folios blurs the line of what is the page.
> > > 
> > > I don't want play spec lawyer. Let's look at real workloads.
> > 
> > Or, more importantly, consider the security-related implications of
> > the change....
> > 
> > > If there's anything that actually relies on this SIGBUS corner case,
> > > let's see how we can fix the kernel. But it will cost some CPU cycles.
> > > 
> > > If it only broke syntactic test case, I'm inclined to say WONTFIX.
> > > 
> > > Any opinions?
> > 
> > Mapping beyond EOF ranges into userspace address spaces is a
> > potential security risk. If there is ever a zeroing-beyond-EOF bug
> > related to large folios (history tells us we are *guaranteed* to
> > screw this up somewhere in future), then allowing mapping all the
> > way to the end of the large folio could expose a -lot more- stale
> > kernel data to userspace than just what the tail of a PAGE_SIZE
> > faulted region would expose.
> 
> Could you point me to the details on a zeroing-beyond-EOF bug?
> I don't have context here.

Create a file whose size is neither aligned to PAGE_SIZE nor the fs
block size.  The pagecache only maps full folios, so the last folio in
the pagecache will have EOF in the middle of it.

So what do you put in the folio beyond EOF?  Most Linux filesystems
write zeroes to the post-EOF bytes at some point before writing the
block out to disk so that we don't persist random stale kernel memory.

Now you want to mmap that EOF folio into a userspace process.  It was
stupid to allow that because the contents of the folio beyond EOF are
undefined.  But we're stuck with this stupid API.

So now we need to zero the post-EOF folio contents before taking the
first fault on the mmap region, because we don't want the userspace
program to be able to load random stale kernel memory.

We also don't want programs to be able to store information in the mmap
region beyond EOF to prevent abuse, so writeback has to zero the post
EOF contents before writing the pagecache to disk.

> But if it is, as you saying, *guaranteed* to happen again, maybe we
> should slap __GFP_ZERO on page cache allocations? It will address the
> problem at the root.

Weren't you complaining upthread about spending CPU cycles?  GFP_ZERO
on every page loaded into the pagecache isn't free either.

> Although, I think you are being dramatic about "*guaranteed*"...

He's not, post-EOF folio zeroing has broken in weird subtle ways every
1-2 years for the nearly 20 years I've worked in filesystems.

> If we solved problem of zeroing upto PAGE_SIZE border, I don't see
> why zeroing upto folio_size() border any conceptually different.
> Might require some bug squeezing, sure.

We already do that, but that's not the issue here.

The issue here is that you are *breaking* XFS behavior that is
documented in the mmap manpage.  This worked as documented in 6.17, and
now it doesn't work.

--D

> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov
> 

