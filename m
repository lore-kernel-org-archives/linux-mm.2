Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 508A0D3ABE7
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 03:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A286B034B; Fri,  5 Dec 2025 22:12:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A614D6B034D; Fri,  5 Dec 2025 22:12:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EB46B034E; Fri,  5 Dec 2025 22:12:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870776B034B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:12:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B11B133A52
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:12:59 +0000 (UTC)
X-FDA: 84187574478.27.51E1390
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6EB1AC0009
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:12:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iTlcIo5A;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764990777; a=rsa-sha256;
	cv=none;
	b=YdzW2/qrvFqx0imXX7zfDZeTr/OJEKvUS+Av/wojOTBpoC+a6shmx/SCbhNoGV+MCWmbkN
	vMuhayJx0OXnZq9beTlPloVIz1tOaumQ29ExxN+DaqiAjmJElMnMIu0XMQKCOa33xqiT09
	L4Rb/z425FFDUA+BtK7HKuqCkgE6ABk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iTlcIo5A;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764990777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r0xWOI04btkf8CfXl7VnZlJgk5q6qnmfk/5+zubQG8=;
	b=mJeSnlIRyxDm3gNBAAEgA0QS37QS0fnphP75u7AJ4vJplqk/Ur3CzxyKmBl4pm1dtD6+gn
	cPBvsin9cb6qb5vO0fmzq1+k3OoRiSN6kTdiC9ysx2LhET6U54yQmWMfT+lxrc2mxV0M+W
	pdqOurLl6bmIOUq1ajuqtufXBR6610Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 958BE600CB;
	Sat,  6 Dec 2025 03:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB32BC4CEF1;
	Sat,  6 Dec 2025 03:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764990776;
	bh=Ond4FsQaolgVCGsRJYSEIPpQjsP6TpYyCVBBKlrYlkw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iTlcIo5A2CSxaOfsU/36rIuiZVE8XTtuN8cNug06D1JYu8K1UVaqVLH1Tji2J8Be3
	 1qq58LFe4uU5K0xARRmj/Uq+4aGluze/UdesMrNWCE9pvYt5z5WpgAS0kgy/Dtw5iM
	 JQ/UmcocYUbj2IlspcIRn49SlAHTD2z/eO9DGpQk=
Date: Fri, 5 Dec 2025 19:12:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-Id: <20251205191255.e6da75c8511d23159f44b59f@linux-foundation.org>
In-Reply-To: <20251206114034.24bdbf1f@canb.auug.org.au>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
	<20251205121501.bf47efd78d0a1a8f0370645c@linux-foundation.org>
	<20251206114034.24bdbf1f@canb.auug.org.au>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EB1AC0009
X-Rspamd-Server: rspam10
X-Stat-Signature: t4hyygqjk71ofmssozrjrqw8qgmg6mhy
X-HE-Tag: 1764990777-493283
X-HE-Meta: U2FsdGVkX19jRzdnKUD017VnU8X+3BE6Kp4VPwPJ0QM4EXhUoxGqaIcY61xHsUkfIv4AQ1LDwAWbsGHYMV0rCTFcdSb7pY8Y4GrmJOr/IT8TZiL6CI+gZ4KitlUP4eeer+gtN3PU6IqckGvOMYZA29XvWcdzQiJrbyKL30vv45hyP7Wd1QjT12X1P0sj6sOefX9OuU64gCfwg2zBAPHAgsR7S8hyqK1//cGIBVenAQe4pjDEyVSdj2T1U67o9wFp3uAt/SahyCf+F5wlMBrmwdZWnEc3mfHTWoI5rYRuGQtP+tXbflUv46rZHVTcVNcSmg4ZWcbwtqtXFDx1m0852agGBIGUOI6/GjEoB0s4AcbZRAaEePR30LZ+nnLeXGXewvFNIlwFKAbslHVJaCBvzyC2CMulAggBgekpuJYV/EJ5SyIjw3RfXxLwU7coB9ePuBNZK8SxBDraXdt9ZED0BQAUR1MA/YQOIed9sZVjrHSXAKBD9mWNcRpC0W2yGqhO2FuE0/REMQdPZvCwGIMzQ5M1suTbpPogSDcKDYqNzU9RhdjP1u0Gg+qG/0uaoasas/f8drpZ9rE2NBBWMswfLV0hJeLSjh0MU+CiKt1r/kUMqMt0wAWLtaK80Q7tBKY2YL7djOg8Cnbkxpxx9HTp4S2rq4QFgmOdcRnaknoIUXy08i1cocm2Wn2fPt0A38rF4C/aBLnwrUoBfr1a6cuE/ufhQ77c+XrAaQQn7gvlcVf0MY5s3fMpHaKlPfkriLZDg+M+pYvs3c0fgdKvvRUP0VB/Toxp3M04twWqhbhkFkh3NGxcXtxpB/h5skD4oZvOQFkwF2e8EuszjOn1sfatUuKkwmGd+Bkmaw16IIWs7/JqXO4TM6p/JuH6WOTX0DDmAERi32+xhsNnju0hiliKq1h9WgqqtuFZUegroCAIisWFRjf/uP4mb9LgEJynB5DOrrjWtwQ60ed8JoRkuax
 fGmHiA6m
 cbhNLjYXXlo7t6cYCMvF0ZloT+xrmlJb1IOVzXoVq4hg0ZrUDKHbLi2gLQhgjOyqW8++v8gEl8dXFKVAuz23guT1w4eeAjahIJG0+jc39DOUKFTgblqQMoaZTr0OtboBgbp9VruLVESFcQFhviBDoj+y92JOSfaQfSaIKtgnQe+GM3pl6RjOr4D1M/70Pw2ZHwwXUi4f8aT3poonHDvMbqdWLf1NXXcbSa+LAtLi/tOmzCHTtDnoTnXUGhdpxCV/xtDBhXwueD0poVC+x2O2Z6Ql6m4IOfRzqXfniVE8aa0sMfp/qyL3i9oZLSZ0dmxYCNwOM7Rh6uTbMQ/I5TpHnh8QedTLRVBpuk7XTds4hiNtHMDlpu4fluljR8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 6 Dec 2025 11:40:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Fri, 5 Dec 2025 12:15:01 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > I'm not really sure what's the best way to determine this.  I use
> > 
> > hp2:/usr/src/mm> git tag --contains 2b6a3f061f11  
> > mm-everything-2025-11-29-19-43
> > mm-everything-2025-12-01-19-02
> > mm-everything-2025-12-03-23-49
> > mm-everything-2025-12-05-00-55
> > mm-stable-2025-12-03-21-26
> > 
> 
> What does "git branch --contains 2b6a3f061f11" say in your tree?

hp2:/usr/src/mm> git branch --contains 2b6a3f061f11
* linus
  mm-everything
  mm-new
  mm-stable
  mm-unstable
hp2:/usr/src/mm> git branch -r --contains 2b6a3f061f11 
  linus/master
  origin/mm-everything
  origin/mm-new
  origin/mm-stable
  origin/mm-unstable

kinda random, but it tells me "that's in mm-stable", which is what counts.

> In my linux-next tree it says (I need the -r to check remote branches):
> 
> $ git branch -r --contains 2b6a3f061f11
>   mm-stable/mm-stable
>   mm-unstable/mm-unstable
> 
> but I don't export my remotes to my published tree.

