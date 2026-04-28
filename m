Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69FD6FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF32C6B0088; Tue, 28 Apr 2026 10:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA876B008A; Tue, 28 Apr 2026 10:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07BB6B008C; Tue, 28 Apr 2026 10:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9377A6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:28:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 306681401BE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:28:06 +0000 (UTC)
X-FDA: 84708194172.01.3F8AAA7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 229A6120003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:28:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cBCToJLH;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777386484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PiEnJcTNbxsAumPO2OZH+Ow1oDrEEEtJ/EFaM5ozQlo=;
	b=6WevOxSgRg00Md8okRXwH8V80vAIJCdFX/l1EvewFHpYf7IL+S6/ex0RB80v7kFYI84Bh6
	phDQLN1QEq/gM+umx2Unt4rKC+Em2Vg2rGfN3PpqNfVHfSkIexHLQBOe8vzXNmo4aETINo
	DDfWgrPmxFQFBUWaT0ObWAwuqxyzebI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777386484; a=rsa-sha256;
	cv=none;
	b=jpYLmY4iPY8hdkotusyLDwakwAPpklxA95FkHHuUlcLzDPIe7l+dqqX9mzpQW57M8KaeSW
	2TRBUVFPmUinJji9DI1WOao6GMfzSf1rvoPxRF0jCRXT+XNing7WMwDPuSBqFdiDYZZEsn
	Byl81yDsLfxp7hBdr9VwDPYyWhqpVB0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cBCToJLH;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PiEnJcTNbxsAumPO2OZH+Ow1oDrEEEtJ/EFaM5ozQlo=; b=cBCToJLHGf/nayhl59IKWbgDCf
	UOpNDiFO37WIHMkTWckaGz23+qygbQenyzYOr2FLwhtlFQ3cjQ9Ub+TQrTrKujajH1ceyt2stZNH+
	JqhjVDdQ1MYxZ8IKPxRoDVtEllQkh8olSv+0PI6W4TczPwyi6Iei8ESjSCRow02YTVewPEn5wO93X
	XxiijRIujo2EA6wfaJdWvULuSWgu1Blktir7ieuZT0LLxlvec6r7a6QtSWnS54bthO1i74BGKgHFZ
	pCHkzewoFnLr0+aynOCB+A+bDYp40Tq9UmYYFCPQuFlFoduAYeaUVjiIFdkBO8N4RYflVcY3sURUs
	bQ5Hb50A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHjPt-00000003xHz-2C9B;
	Tue, 28 Apr 2026 14:28:01 +0000
Date: Tue, 28 Apr 2026 15:28:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [Lsf-pc] Large memory allocations at LSF/MM
Message-ID: <afDD8VYvPNepzadc@casper.infradead.org>
References: <aepANOFKoA4jn8NN@casper.infradead.org>
 <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
 <ae9AHWvXUTuoqlfA@thinkstation>
 <9cecea5d-9377-4d90-97c3-0cd8b2f77b35@linux.dev>
 <616cb4c1-ca1d-4e37-a92e-b8f6f675bd3c@suse.com>
 <ae9heafyGwN3ctUe@casper.infradead.org>
 <ecf66354-6ec4-42c7-9f08-a95f403b55a0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecf66354-6ec4-42c7-9f08-a95f403b55a0@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 229A6120003
X-Stat-Signature: bi9qzn7yw4fh3um6qabspuacg9bjm6ch
X-Rspam-User: 
X-HE-Tag: 1777386483-998589
X-HE-Meta: U2FsdGVkX1/QsTpTC/KQO7caypo2Fy7xwBXgNlXBF5R6J/bDIczFdH91lO6x817clIcAjV/QLI26UMb2GDIwi897kpcLoyXz/Nw2RY0c8CBN+a+hkrBHK5Jku8Mft3ld5AquH/ESfiOsh6LsO9kOIqpaAdSwsB3xsGOM6rU1NpGZMH4/3M6hDLK2e+JEWrqtp1SDTedqthP4MhBJqY29qkKG1292HGQsYzYrJt/MT6VqXSldSIv7QCriNqriP7Chzqpa4O5BkPjHDE2fluNAxyK3frar3Y39f8oT0IF2Y4smbHaz1ps2ahJEpxfYQf2E9v+lCNx2nTeh2acwTyvOBxoT9eLXghZBjEjRBaeLnVlWFJXFaDRJ1LciKjIb0iUAvjuDInrPVZyxgMeoCEUrvDZwwJ1jvoiT2nB6dg30+a6W5jN6mBmjdNqH7gVXlkUSz7X6Wp/HBQGYXxzYwLcnoI9gqLvpuzc9qNLX6ui7heJzXTS6iRHXoGozHgpVzHq8yfT7vhRA2/itJpxnOkI7xP2Wli+5w3eMcrie9VBrPWXYCEiqz8yWd9lNk8P7BQQ4+O619XBlOagH2YonC6P3AA+yzvEkhP6QriHMpdhd1EADYYTy4MIgLt1wtP4jqSVtqOJisJoOTBAIywGYgq6Yykl7KF+uijPn7k3nkVNjX08fVRScrNr34t3Cyjj+Kk2OV8xhoOHtAlmH2HLPB98Y+o7g5hXKzI+YVJpBtbWw4UyXmzWN3tLNac3FwNBh9tU45W8flGKHFmj2Ob/k+Gfgm2VZ1U01I6r21av8taSQ7Z3YnD1hYjzm7/CdhnzeVYu9QA1hlTG8l3UPzLKkLKRZkYJH3MkH/QaCh6P2Frq8uCzCOLBn+xtCmPuRaKZ3NtHxh6Mem6Z4n3fFI/qiHsulxijje5OaJFN9or2ao3sCRnrAV+iEumADEuCK1T1dgx3gxfRxWenCwpKiAfUWicR
 oFPbLRPF
 /ecmtduLjxOZQ3s1aqspqs6oMpeSAqErrviPjXfL5q+aN8XSZqYwss/jLTsZZNbN3/Av5myIg3AqZdMNkswNmH9R/qOsFONg8+WUsSHtOKUbSG1FFz78rRssntnsrElspcuLyMhq2ur56lLeZZuPkHwQDP+hpGoNYibvV36keTRYn5sjJLDAzfN0g2tLBTA7cR3uzh7ziUX3DsmNFuXOxvSPUQ+iks4D/vPXQorgOexa5qcUgdy0rIZnkTFragO6usfROGu6y/deWCbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 03:07:43PM +0100, Usama Arif wrote:
> On 27/04/2026 14:15, Matthew Wilcox wrote:
> > On Mon, Apr 27, 2026 at 02:35:45PM +0200, Vlastimil Babka wrote:
> >> Well meanwhile we managed to extend the session to 1:30 :)
> >>
> >> ICYMI:
> >> https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?usp=sharing
> > 
> > Sorry, I meant to follow up with the good news that we found some more
> > time.  If you guys want, I can split you apart into three separate
> > topics, or just leave it as a Hydra session.  It all feels pretty
> > connected to me, so maybe keep it all the way it is?
> 
> 
> For the 1G THP, I think might be good to keep it separate? I feel
> like there were many different paths proposed on how we can go forward
> and that work isn't applicable to the other proposals? That said, I am
> flexible either way, happy to go with whatever works best for the group!

I can split yours off into its own session and keep the other two
together for now.  I feel yours fits better after the other two, so
I'll give you 12:30-13:00 and leave the other two in 11:30 to 12:30 for
now.


