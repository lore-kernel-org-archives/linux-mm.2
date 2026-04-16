Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F7CF8A140
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BC06B0005; Thu, 16 Apr 2026 04:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43556B0089; Thu, 16 Apr 2026 04:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80BB6B008A; Thu, 16 Apr 2026 04:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE286B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:18:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FCD5C259C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:18:30 +0000 (UTC)
X-FDA: 84663717180.19.01B81EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9C7C81A0003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:18:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=izFIxPGh;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776327508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Po19zhKkln4dzwbhuDJQbEdfXdgMEBwZerY2XSQv9n0=;
	b=hYNH6PD41W/TfR5wcF/A9q2ttriV3wcM7BJRZXbLr+e2uLTdfbysa/21832YwRFKhI8yym
	JNBkRzsL9dHrTji1y8FYeVZZSBWUe2ndd5CMvY7U8Sxh5In+7mrzbes+A/FHs71bg9hDno
	EVcGxN7RCIqhpFK7pUdMgwqZ9LMx8dg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=izFIxPGh;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776327508; a=rsa-sha256;
	cv=none;
	b=zQ9WbApBo6waQFpiqd8hx3ESM8ARbFY+++H1G/kWn6eGE4qlRzHmW+mtJcA9Q7WZQRPysW
	pR/O8E1G1E6yMgOw+IMyTCT25bH/H/gY3O44fi2PgiFytEp+2HR1FGa7oVLjDwRFGyo9ZG
	Z5E7EZfUg9ZUaZTK8Me0IpeKMHXeTAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F138060126;
	Thu, 16 Apr 2026 08:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30D3C2BCAF;
	Thu, 16 Apr 2026 08:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776327507;
	bh=vzK7Ux6f7SdteP95AP1eGRKFQyII4TRioIjRMsY61og=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=izFIxPGhNLGqsJFGqQ2h8cfN+svaNWqqz/B1V7eX86ZhIG/MOass6mtkKeVFNcrAJ
	 oH4SkP9cNEhTv39Splp2bB4xtbfH1/GDL5u8tsIkoOyfmB/jUFnt5mXAC7wvPbYW9F
	 FDmbR9hYTXNII0TEe7IjF4NZaVGdQn+Vozu9QTV8=
Date: Thu, 16 Apr 2026 01:18:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org, Konstantin Ryabitsev
 <konstantin@linuxfoundation.org>
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
Message-Id: <20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
In-Reply-To: <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
	<CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C7C81A0003
X-Stat-Signature: f78af9ri8eg13ayp5gsys4n3ma8okst9
X-Rspam-User: 
X-HE-Tag: 1776327508-14561
X-HE-Meta: U2FsdGVkX1/7PD19wWgw/g0pMbnb9BqRYYo9AJ3zIoxhad3sGhUTPYlTnofSs9pKRYqBYGsEr6Y3XaCNmindQZlb4yh2dBkzDfrPxft6saSz/kK1WvJlAtJCbTV43af3jd7q8JIEtWMHC1cYjiVXcAjnq7tsoKCvtTj2cmm0RtmbSqTdWEgFX6gb3C9Hc68WpC0vszT04Uf3Jxy20OGEbhhHCSZso0qhrLOPhy5d7PQMMt/uUMhBgBv6JFFPOAdXq1mQ7OqnTshODutNLiZWlc5mzRI8V32cIZtJ0jUIWfNo2vkYj690K4PWb5+SaPf20CEcFsaRQCtn+Pq3AC8by+hPndPZIPyiRU30jALZb70chCzpZ6Gdb8rmn7/rhyTR0SLMa0kNFjhZ+lYEO5In3eA+vSEOf7w1SfosfgU/YZnm8dUaQ4Z/ZWVAFNT0zO8WK4DjYOg5JDVPxW8XWtB97+TYi9Lih9e9xFFb8YMmQVSTxKnXMs12vMfVXxs8fdTLEX17HeFrHbKlZvcioVNHvYECV+0zGZMGvhWExrj5RlnLITJnx106hKDus7yvIibgsNxktOTjeZLufLSIOni4VtVpnNT0SCP43KoTzfDVxIEifYh08FGPDmTMd+yJ2UqSTmybXJR4HaPhUOUWljjIuISUpzSso+KM0+EWD0HCDLS+iG3EpDWfKI8Z3+rKTWv41/9KqIVDAt51QeEXlvA8hhL5C6yHJNoAv8y99P5SCHiInk4Ik45rHP8eOA6LK7pqXeXwm+LfSGOsJd2TNSt1plq4m7mO+4LTy2eJcxOf5s3x9yivkCoha5NJBuvwsxBapbtvTMJyvskUHJGjeotCP3TW5WGRrAd++E0a+SauGoRlyjRXtbRJ0wYtj4Mbok7qA50wzI1HdH//PRi+a1+R0OlX5/+VfXg4igThwOF3CAg280FwMJlQLuq3lJy7NeV+zb//L26eMJ6dMk2ogOZ
 xyACSqX2
 fk7fSg5u5he0B7+ve8UMmzC9HwBp8/Ydgu/NlxaWPvQv3w9ISYgLYnofx64fGK1qnX90bl+1YS2h8B9DX/te+AeP0ao7K5gMrNbk36guxcTULT17vKjWPmS0giaqePYVfEha50Mw2LKu7C97vklQJu6Sk5KiRSoQmdLmPNgfB3BlhIH/D6mT7BzUtrWidZPZiCgEDGhOsndiYbfuGHH8/kXew0wfWB0U5eNQY9XxsATck3JRDR1BTakWR9yqC6iDfxlKD4+ALS7qhry57sZr066V9ibvfARmDBp79flPTvvUQmsOztLSwodV//nxCu+KiXI0+wWDzA9A0E7wjO6Pxuo9z9LfVNx3bWV5ByP0X9C3MA5qgqsjN3yxqqmItQaNCDPB1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 13:20:23 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 13 Apr 2026 at 21:50, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > include/net/netmem.h, vs net tree:
> >         https://lkml.kernel.org/r/aaGiDINfnUexT9Px@sirena.org.uk
> 
> None of your links work for me, all resulting in "403 Forbidden"
> 
> The proper format would seem to be
> 
>     https://lore.kernel.org/all/aaGiDINfnUexT9Px@sirena.org.uk/
> 
> (or "lkml" instead of "all" if you want to be more specific).
> 
> Maybe something changed recently, or maybe your scripting for this is
> just broken?
> 

Something changed recently.  Maybe Konstantin knows.

Is https://lore.kernel.org/all/MSGID/ indeed the official recipe?

I've always used https://lkml.kernel.org/r/MSGID.  So at present there
are many thousands of broken links in the kernel tree.



