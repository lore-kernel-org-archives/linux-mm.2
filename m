Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896D3CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 02:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9389D8E0005; Mon, 15 Sep 2025 22:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FD58E0001; Mon, 15 Sep 2025 22:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C4A8E0005; Mon, 15 Sep 2025 22:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75A098E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:54:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C87CC115DC5
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:54:43 +0000 (UTC)
X-FDA: 83893595646.14.68B6CAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F31A160003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:54:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="gCV8RQ/Y";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757991282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hyRv6GvNN5E47xO6kev0uGq9pOvWqu+tilWAnb5EeTg=;
	b=VITcRWc2jju5H/XrKu6EDS7b2k1XXpbnAlSn0bN6S56rpLaGdRa/LcrNpHh5AhrmnDsnW3
	ZkX5zPCwo6z2O1ymB4/eAYx26/844sXUDAZzoZyVbRorieHctQ5qzWy51CPIfHDxZBxtZN
	A+3Afy3f7nyvqLf95EADjmYFlbVU+Ak=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="gCV8RQ/Y";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757991282; a=rsa-sha256;
	cv=none;
	b=L+f6LMjti+0ggieUoz9dTKOySloduTgoa8LTi5J14859Ft6lwVVUeiW9Gb8wmwIf0PzkfG
	BaHgwyRU6wx9SzDLZetPj1B3DrSA3lS0pdLs+yu4MwvZWvcR9N4V1gZCjZ3wGK9NBI900M
	l4E+u5wpo+bmsLnaZbJhJFEPUumc3S0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B88E60054;
	Tue, 16 Sep 2025 02:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75183C4CEF1;
	Tue, 16 Sep 2025 02:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757991280;
	bh=FSXamsz51GyhPZeRXCy10g3ECsbExx4flqf03FwCSJw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gCV8RQ/YFvjq4gwgXdRs5tHtMrlKZR1F12Wni3SnQxHcz6NXQQUai8J4rQW2WJD/K
	 /g9eftk7RH0teioVEnlOL4yYCa6ydmVpXO2YTb+LF2dZQX4Uxc3OfQ9DuKSpmT1ep6
	 hCLQIG/U2XbLcdc0ZX8s1o6Nb9Ki4Ggmzciqvpwo=
Date: Mon, 15 Sep 2025 19:54:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Donet Tom <donettom@linux.ibm.com>, David Hildenbrand
 <david@redhat.com>, Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Wei Yang
 <richard.weiyang@gmail.com>, Aboorva Devarajan <aboorvad@linux.ibm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Giorgi Tchankvetadze
 <giorgitchankvetadze1997@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
Message-Id: <20250915195439.fa6d52c3f3bbe6380ad65660@linux-foundation.org>
In-Reply-To: <8d7be334af3944f990b56c80a70b7691763c3af8.camel@perches.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
	<4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
	<20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
	<8d7be334af3944f990b56c80a70b7691763c3af8.camel@perches.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2F31A160003
X-Stat-Signature: 4u1jcbe79rfs1m5reuzob8utkuoopcmj
X-HE-Tag: 1757991282-228959
X-HE-Meta: U2FsdGVkX1+H+GSHQjjPCbXBhBkPxNSN+/VbRcoC9QtYaq+fflq2PBnHQ3TonT0O2KQ1k/E0nqTGd0L6cQBE4mfjPMKtvdI/Va+um7XXZiTc6Xfb45+owMfWCbU/DbMBgWSUMHJp2+etGOZZ+73q++8MWe10kacqzwqqokG20plAQeYB4tG8oyrB0Vifw7U7ydO3D4i6RLblpP1Z+76l0vOvvLtmzuc1EWxBgNtq52n5P2YvSwPWhxx0kVUE/XFP7c92lvI+Q6ylX1oD4Ng+iC0lBaZOsuKsfsof59uc99wtm9ibpf9jIhzl/9DLBvo6q+62bbUHT03bQeeouP51QLkFIjF0D5cOP0yly571JHmJWKO7CLaYNhMLh+30N5bUKK1+zSpv2HK6ywkG1JxhkZMxuef+ksapPHECQ7P5hJvBZv7xPCJn3SjUIdUrHGlcdf8tC3tgddUkWI0hUzT6U/qrYJvRq5zebmZO9JWsrDgtsqsSj0MNLi4CSVuhgNbVKFTJ9H78HZnTarWWi7mTEhWpn4BqeX/15WYAMkXFspQC4iFYwO/o0acoWmMSXE0Mb/o0eW3QXEdgVKmoiZzOycZPXbrHvdMFZlMLh9iacpoG1bIS+CYGw6WhAxvCZFezjvTZ62bj+6q+B8rkf42P1Zb6cO7WmPSinSFBsoWkwYzWqgCBEPB6ALmYCVBqy98f4jNaOBhi2NylsOpVyvpNo3WE2Oqa4fM8khkUcYPD8qPgWWe222QAX/CFJCV2dHGdpo4vxuGTm03PlfNSrq9fZAqFCBke8Z0B7SBFotAb8t02qtlQQF4yuXAfg9yZNswobcy7nLZ/hkLP1P1Rx43UGF2viXxAF1sWQJbbmkYmdoOgW2VH3KgQacAME6g8XEGdrGajBGW/0BGPvpxH2hZVB3dnQG+x7HSQB4FRe49sb+VkVxEHxNjGDRO2FXEhD+ybiTogcr8rsbAsdqsK4bK
 8ZrFKiod
 eCI50oYLClqnlw4NOUYvz51oAAGzqJxTZdlCsMTO9b6dkGbIOpwxu3/Aw+A8bp+NKBSUrF7mmOBf2Ulo5HHBzmjNGKA2fDqDVCYPFOfHqR4PtxLbG2i/4riahhfshhd++xwATS+D9Ip6LzdlUlgiB81KSZiVEZ3p/k2d0V3uNx7VdRIsGysD0bOZJ6HnWsUlguN1oETVRvUdUwPsmh5wup2VYx5aD9RwPvuCgKcV7qtamjicfyxbyEQ4hLKrompgB9KP9suy065+NIvrMgQ8RNUC/SPEOyOdgjrr92ObFbmkwb9DCh2I1ClzQ0NPkYPG5eSXnA8m/lwIvpoMFa+ZYQTj6V7BNoRcYvQiVrrBpo7vk/8cxYYbvS7KcyUj9ubVcU5XwgxL/XV5lGCCvndoR3o+qYLoU0DHtX+KGg7X5DkTF9T85DCa9G0ktySVI4mmj9XdRzJDF4M5DtcZHPTC7B0eCWlxsel7KT475
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 19:14:47 -0700 Joe Perches <joe@perches.com> wrote:

> On Mon, 2025-09-15 at 16:42 -0700, Andrew Morton wrote:
> > On Mon, 15 Sep 2025 20:33:04 +0530 Donet Tom <donettom@linux.ibm.com> wrote:
> []
> > > Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
> > 
> > Linux-v5.19
> > 
> > > Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each process")
> > 
> > Linux-v6.1
> > 
> > > Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
> > 
> > Linux-v6.10
> > 
> > > cc: stable@vger.kernel.org # v6.6
> > 
> > So how was Linux-v6.6 arrived at?
> []
> > (Cc Joe.  Should checkpatch say something about this)?
> 
> Probably not. Parsing variants of versions seems, umm, difficult.

I was thinking simpler.  If the Fixes: count exceeds one, ask
"wtf are you asking of the -stable maintainers"?


