Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C19C54F4D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8A46B00B4; Tue, 28 Jul 2026 12:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278446B00B5; Tue, 28 Jul 2026 12:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1928A6B00B6; Tue, 28 Jul 2026 12:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E335E6B00B4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:07:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EB3F1C09D2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:07:40 +0000 (UTC)
X-FDA: 85038665880.12.00D7F05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCB7A2000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:07:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=do9Qf31f;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785254858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1d8NjVYJJn+wjjiK3UWZkRgmZ9sB7Xz8XibGwlAR4TU=;
	b=rhmMWpsuo/3IDS6Azq7K2/q0GB0JMLYfwSzE/f5KCnF6fDvCRJRf5svDQoQOwFU6K67DD+
	L8B7O+c4kdSLH01toluFSegs1/VU13eD9509gQXGlsh6wrHHBVUO/DOLTnuW4Yic4v60iE
	JOyoYjghxmzweJhHnWZnGpVvWzWaKJs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785254858;
	b=nycUl5um9mV6vD94M9xTDJWEje24WR4YNp1Uw/LEi68p5xojWFAKmweT3UlLdzUWPQcw+u
	QYFUyaTxK9dgahDwyVmY8XyE98G0S1va4/vZFw7crG9AJ7+HHpdrYlEuFlQz8kqnYxRgU6
	QSJFpdKP9H5Qw3624EqT/oCGMY5PyyE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=do9Qf31f;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07B2143C7B;
	Tue, 28 Jul 2026 16:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA8D1F000E9;
	Tue, 28 Jul 2026 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785254857;
	bh=1d8NjVYJJn+wjjiK3UWZkRgmZ9sB7Xz8XibGwlAR4TU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=do9Qf31f+8z39RaavaLnmBkTzfJzmuRlrk8+c6DfkV589EUCL9anWdb2KW+CMNtWO
	 nrtuVp3Rl2+Ob8SWcEcEgDQDmBmreziaWFdrI6Yya8u6sJo92w2Sj2eF6lkknMnbx5
	 GswKhL3Abrgsq6uXH23uuN3kfiyB2ZAqwbRqDM15Tnm2MV06pRD43C/kEUuTbiNpZ5
	 eFujT+vDCoUOvMALJ+z87C7KGHWB/GVtPB7tOshxTpI2jwQtcUuhT1mpVkEPKrdSYm
	 Ssw8TFKkcDDJ/UEBU1loEG+wuv0jrBPxS0Kxb0zv5waA+ONOdsvZbCu6gb2ZomxRa3
	 OW3+Vdr61M8/w==
Date: Tue, 28 Jul 2026 19:07:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/21] kho: make boot time huge page allocation work
 nicely with KHO
Message-ID: <amjTwoWWQBvFvz8N@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
 <amiwLSEi8cczamP1@kernel.org>
 <2vxzecgn89jt.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzecgn89jt.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CCB7A2000E
X-Stat-Signature: 1idor5ib3fgn86ri8gi5rojphh53xpbf
X-HE-Tag: 1785254858-914662
X-HE-Meta: U2FsdGVkX1/3b0451FDYxYHTX9k7OFe3F3EpTsxFgVwDUc2QMLydUjGNYHtTuAvltCQ4Q576co48FEIDavRYPgz20Y0KgzAN7IYHMhMjSxheeUJoOOcYIa/68H/0Iqn6y2gmfPCViFKUUdtaFjN8x+VXwpCK2aNW3ZPIKqLFqG5oeP5pYyLU9LMlG03dBtvzn18kPge447rbQIW1gG1VB7+OUB825evL9FoOqWCZATfsjbpl8xVJMkwkeT0S6zQ5zp2VdoVcHg0AOsa5lZOZTpVxpjPyeMVUKOr4LyEPwqG3FqtJgii6oLPHCJJpeEt0jBoWPBi0c7xpXgHYDg2asTZVLPqTtolJyrWctV4toRFYbwvBQ8/moGo17XkQNg46Sbki96ut2oJah86OFKHkXAVr36RZz3m8rSgrbOCAPkOL5YAkyKM65gSjmUPUkg6AGAW71C122pLmtYf94WNaKWoMrYbKnfdzYx54+29WVOwhxGzwOF/2Ck3Mr5YkDB2JUk/2v9OiYoss/gXc4hqd4v9y5UXi0Xm+9rPr9vAsiaxMaJnmXjrGtxvFwGgBH2XCmTFvAs6ycG94GMmn5O/qLdvsOWUfkb76E6HrjWL7B9Uc9Q5v9hsY71hPsJTgPNFmK3d8LGJkw7+viVSdVZamk/FTL/VrQX3ujlrcJxgRFtfWEAz2mu1NJ0h/XJ2jCH/rIVCGeHF5d/Lm9dqKqu5FEuWVg8dHkrHdMxdC8YioncFdDLdv+ajQ3MPvnc9Nmd1zZ0fiPfU1gsPG+j2jKSqyiPmHEG4yKCkgaqH02yW6MkWq6hq3zY9INiBqv7Q/52nabWlqpBCMKhxqrACdmXBzBdKR7goYVgXpooWrKgNqj+OhKJ4Lf0DVwWnDkAkWEOsm/rNZQLQfBzvBB90WRllR/rpFQ3JEF8GWcjO0zTnD9SZ0EhmUnr2Pgs/H7fGSjGyk67Cfd7MEDd9jIlK18Hz
 P/pbuSXJ
 xfu863bscnL0nMCyhoaEaZm9LeFF4ASQOG5nsmWLSizC1RTLb/cjYNEUgi8mmQq2fBhDjNtHEwr4YA91nILpFoV1B+Vz6dpebVDlFjdis+Vz+Wd7AHQAPuGCTHX6isUmrlKHisLGq+RtiKnjr1Uk1uwD1P3pXgYinppQDXuCPAtp1ULVYImzR6US0JMNoAEOZ28zIreD5lJKiAr5GXW0pWpK/eCidZqJL9snBdTJxZ2Kj9umZnQdN1+Sbo9tBdg1+HC2T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:37:26PM +0200, Pratyush Yadav wrote:
> On Tue, Jul 28 2026, Mike Rapoport wrote:
> >
> > Please take a look at Sashiko comments, we might need v5 if it has valid
> > (not pre-existing) points.
> 
> I took a quick look and the only valid points I can see are the ones on
> patch 19/21 "memblock: make HugeTLB bootmem allocation work with KHO".
> 
> All others are pre-existing problems.
> 
> Is it okay if I send a single follow up patch to fix 19/21? Or would you
> prefer a full respin?

I prefer a full respin please :)
 
> Also, general thing, but I should go and fix all the pre-existing
> problems too at some point. I sent a fix for a really simple one
> already, but Sashiko has found other problems too...

Yeah, that's true for any subsystem nowadays.
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

