Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1AB510BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244F66B00B1; Fri, 27 Mar 2026 03:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C566B00B3; Fri, 27 Mar 2026 03:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1597C6B00B4; Fri, 27 Mar 2026 03:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03C4C6B00B1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:48:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0766E16A3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:48:05 +0000 (UTC)
X-FDA: 84591064530.24.2E8CE9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D94A180006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:48:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cwoVLdzC;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cwoVLdzC;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774597684; a=rsa-sha256;
	cv=none;
	b=AUjRjcZmm2xfRakSNIYOEfV0oXN/t7i5SwX8oOSX8vhuhQZ95wLa9nuFKov1wOF8x0Tst1
	xMqymtCAKJAA5o0/4kjd7xtNEy+34NOf97JITT9lJMszXYXiBGCxov+nzR8YhA8jFGRnOg
	oMAxbEtw6Z8DYVLkSQQtwvb5BHm0Jbw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWoRYwP86jyji7hwmSchLuM87mveeaS/EOBeUUAIEkc=;
	b=tysEIEks9blSv+MdvPI6s141ODui3SVbNqKhLTeewnRc9gE8fGwF9gyS2sLxhxlofkvdaq
	tK/CJ9NN0p0K6u2pmknsBA0JVy3zRwpowiC/V4qXBbcMqqF/6IGIAfCJlYGy7wPYCSAr2a
	vkWNITxjtKmIW7+yP9qlWf3rmKGmr3A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 95E9261338;
	Fri, 27 Mar 2026 07:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ECFC2BC9E;
	Fri, 27 Mar 2026 07:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774597683;
	bh=zWoRYwP86jyji7hwmSchLuM87mveeaS/EOBeUUAIEkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cwoVLdzCPT4pgBbS/UbME9pnxTNo/1fVlXw6ein4lFBN0RekDnCSnuJ9sq7qoHaM1
	 Z39G2BQUvlQEAzVuJw3A6IHd1WmyzEYI6g0vqAcPZZ/1EyKwP4sAyGxqPmb4gAlDly
	 p2NhaX29HwzinJODk/j1tI3kdqp6Nuh5Hu6FryLbm+9Dsdp/3iKjlVN6IzppB7xHgi
	 P62ecYtg/x9DfOfQs2+4564sAQ4+4NNL2pSWYdrcz9Aht6wua1I/CG8oqrUIuQF6Q3
	 //XuXY3gnkEjIY+rR3oiiBGwKwKP3dit1Iyc2J3xbdXrlD+9Ptlsb2h8Sgs+BCQIob
	 O1ZgH4kKK4Pjg==
Date: Fri, 27 Mar 2026 07:47:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
Message-ID: <ddb0f340-ede9-46cd-b10d-2a77ac4d6dd2@lucifer.local>
References: <20260326185629.355476-1-ljs@kernel.org>
 <0d4e27a2-e9ae-41ca-b327-82296cbb0cfb@kernel.org>
 <CAJuCfpFY311807PpEP==UKBLqXXDENA3WjXuNnXMpKaOE2JQtA@mail.gmail.com>
 <CAC_TJveJLkp8MJhphXA-xhyXCpC17p36Gf1OtKLT+oA8LwD0zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC_TJveJLkp8MJhphXA-xhyXCpC17p36Gf1OtKLT+oA8LwD0zA@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D94A180006
X-Stat-Signature: 6pnm4b1f47hwoqs63cszpzstn9cmetfu
X-Rspam-User: 
X-HE-Tag: 1774597684-337717
X-HE-Meta: U2FsdGVkX1/cF4jtcQ7x6+3yF7MSL5bgpNIcwJoZV/2n/4S3hrISXLFhrGxuD57PNq+2D3aDqnFrd3eJ9UJBBnOmCgIlMfMA7kqdj/0roRLQz0307c3sjzMrlGWkq5GRnencbQE918HOC9gSzBr2hiZK6X5X3n4aJ6hozmFFHzmCUDVBUp0cTAEFw24P6JMNGP7dorObYUndRTGRWCQEVxCALd+XQDmj3cFPUVG1LsLotp871FUvhcZNN/9aHIaB2HmUF86itr4BonsQWeNQqVYc6HJ9xw8NzIIegWYRz0BBNt6Xhg4WyBvxUEn456X4/ytPdbokXfgjRqxs/3eDJ3uebDN0ENKmkZX18eYZSO5Wyp9mDf09eM1Nl42ErcB4egw4RrBmZzYsrJ87CWbjCD9QToxOkEAvakJj2x4bVLqjJ2TmABb/k6u2V8QtNP9GgGi3iqmLvTsqUaElHL/i+9k+duElZoQo0YmIY59vTQJsDVFSU/13EZV+TOXgsitooi8/0RjWZiVYh8x5iZ9csKNpF8oBX06lKQtrQJhHi8+HDYuK5zYwM9T9Hjt0FBmc7ziIBXAU5Cbj8W2LYIccTygOje9UvRtlQRLJ67vefjVFaymQ0NmIdWHeOuQzipgf2k/rbJVgf89kv3cnMrtsyKCFMtxXnPHibNIP+w9XY9Yy2O2N1GEhhisz6HvhfivpAabdhMZX/A2NvUyQyCNvFdG/qKSPMAoUBg0dWude9Tq1zGskOkg53KITHDWTyBEbY5xJa4BmP4IkTMkl6XmW+i+ooE8ooNBxxYKRnrEeXg+Dgi8tyGj3azUpezV3ID+kBfEIoxLgv7MA9xD7fsk67AgnSBEF+ZU2xW/YI3a7oReGKLjB2zcUVSanluIiaLcXPCCnqc635pr0lahvdmROX/6QnhBDykLAy79sa30mCIuQb0ouFL7QdcHTK9klA/zjRM9/G2Q2w7YkC/ZZzR7
 5K5/ycge
 0erWTFBstA2FYgYm8nXpx7LNzQ03ikPTIuN5KbEenpvRRGSIoWWnq+m3lpk+Iw/2dYcJqOZH2GLYUXKCoiEYiual3IRtQ36xyeB/4GSaWTCZ7vPQaE+fIRtC+uscnG3MSJ1EcOhw2W7UiGouozmd9kw/sagOc7RYjICZ/+R2gQAGPuDzyqQw5eej9K4ih/C6+bo1oMsG4NUQPM/A3dwCX9hx/lojCIvvSxBUTz8SE0Ryl3V1eS3ZJ6/RKrPJJveAGJ31HEo8d2cZ3c7ayfT24NBv1mAULtQqipCVR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 05:26:10PM -0700, Kalesh Singh wrote:
> On Thu, Mar 26, 2026 at 4:47 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Thu, Mar 26, 2026 at 12:09 PM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> > >
> > > +Cc Suren as IIRC he mentioned some intent to look into this as well, in the
> > > mmap_lock call.
> >
> > Not myself but I asked Kalesh (CC'ed here) to get involved in upstream
> > reviews. Kalesh are you ready to be added as a Reviewer?
>
> Hi Suren,
>
> Thanks for looping me in. I plan to try my best to dedicate time MGLRU
> reviewss. Let's see how that goes practically, and we can look at
> updating the MAINTAINERS file later on if it makes sense.
>
> Thanks,
> Kalesh

I think let's wait for you to get involved first, then the road to R: should be
pretty quick. And we can see how things go from there :>)

Cheers, Lorenzo

