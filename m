Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD20CCA472
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02B08E0017; Fri,  3 Oct 2025 12:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9FE8E0005; Fri,  3 Oct 2025 12:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F00F8E0017; Fri,  3 Oct 2025 12:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2C48E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:56:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36E7087E61
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:56:52 +0000 (UTC)
X-FDA: 83957407464.17.6EC9E01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 49BFF40008
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:56:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iPsv2t/l";
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759510610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/lxrUW0n5wUW5B1tDAtUnKVX6UHfeSxxmaQJrLLe4k=;
	b=Rqr3IQszjXM1Z6Pi4A8hhaoG8EyU4pnk4MbZNtJXh9zfVnmJ6V5dOBb6EexhlPZ02r9nK4
	it2zuvEXNQA902iwpTksFtxhNwSdoR659VzLjBiJS2P7kbog+zV9uIqc0bD8nKFUg/vQ7p
	rOFkrS31jcItM+LAtNkZOItezT7jc94=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iPsv2t/l";
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759510610; a=rsa-sha256;
	cv=none;
	b=u30uKnygtwxOgQOWFaP0Gc6AxIH3N1Zpwaaj0glsqrk2mW10EUUHLie+VOLALHKuecA6su
	YSkYlfTaJa38HmysHM5vyN/zYb4/lYu+m+NZHDVwkc2k7deHw65PSCsFVJvJ4pc02JIypf
	WjMvab7covUP3BAu3+xPO7xkL2AkYFo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B7BF63D26;
	Fri,  3 Oct 2025 16:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E760C4CEF7;
	Fri,  3 Oct 2025 16:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759510609;
	bh=JV3UpCx5Xkf4WnYDKXQq5+YoXg9RglDY2VFNOWzZ3sE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iPsv2t/lOBILV84DJkEkxasJK9RmPc6DgbHdJkM5szfTaHyfm1vKo68P0wApmk+dQ
	 FXrTb5AvwQkIhwv12T/eSUb0fVBHHv+z4KUB3jBpxkWBqd1JJHYeQhYpILwcpJqBhW
	 NNEXNpnBWO/qIpxFgRfNZxb1ufpNDjtWtFgLKU3as/8nSTRiAx3eoih81Ef1y+X+/7
	 FA/4sdDhzcyTdffwUNQsAyRDbjiws7eWWXAhxppoQUIjBVeNEBdSMaY+PKGsMXHkIq
	 UrVTfvD2WzacOrhTDYZEpRGgFheZogC7HNEhK6x/72p22igrL7sJIQ9oyNPFYJ8Hhf
	 vZg9Gi/Q4rqzg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6FB2CF40066;
	Fri,  3 Oct 2025 12:56:47 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 03 Oct 2025 12:56:47 -0400
X-ME-Sender: <xms:TwDgaFlxUqzapmQZHn0PHbC8ptyLONHzP77fFPhx3m5xw4_bahlqow>
    <xme:TwDgaIksgsykPA-UJGwoR42X7ivZT7u1ZC7mJbk0dg9QKLHMLqi9OGgFZrl9s1VQ2
    WA0S7Vo84qmp_m-Ol3zKDG_W3OxOt25SVx5jTan6sPr8aAqgeL4WL4>
X-ME-Received: <xmr:TwDgaKMyLseSqZpgPPwZ74nAqOedbBSkXpt_lZlwqN73Qj9tD7G29FwjTMJHTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekleeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhieekteelledugefhffekfffgjedtveevgffgjeeffeegvdekteetudeggefgkeen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphht
    thhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphhtthhopehvsggrsg
    hkrgesshhushgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehmhhhotg
    hkohesshhushgvrdgtohhm
X-ME-Proxy: <xmx:TwDgaP4CAVLa8vmKSGL8lliQN1Pc5vTXs4CmYx14EsepnVmM8SAG0Q>
    <xmx:TwDgaHslB2UC6UlQCYocZTPwhw9-JVFyVn6xmEBxdSa9JsSQpxeepw>
    <xmx:TwDgaJOAjuiaDVGUeo8aIL7JTEPFk-giBcQqiFTQpRbmgLT2YC5SCg>
    <xmx:TwDgaDoAejs1PnA71FQLjfBHG_79VltNAwQhHhXagqXTcfEiRJ4elg>
    <xmx:TwDgaOHKPLYAKhYXsvdVNvTYraMDsRLij-Ypg_1jBYrAtYnAszsrwD-K>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Oct 2025 12:56:46 -0400 (EDT)
Date: Fri, 3 Oct 2025 17:56:44 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm/mmap: Fix fsnotify_mmap_perm() call in vm_mmap_pgoff()
Message-ID: <bqmxwfi4kohx744fa5ggoiovrhiwsoehqn57kptoni64lgflim@ibt5bjvcbhdx>
References: <20251003155804.1571242-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003155804.1571242-1-kirill@shutemov.name>
X-Rspamd-Queue-Id: 49BFF40008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: opp3n7wcrsgub3b9cww83h7abzass6f4
X-HE-Tag: 1759510610-21881
X-HE-Meta: U2FsdGVkX1+u1hfUGKTytdoDexgdBlDnfhsuwlbdrnjNSpOtXB/cC2rAi/voV1pJI1q26pxwCqtlFplrlobrU5ayF2UkvMpxZLyVuAyl3X1vn3sX6eVPjj1S7gmTWtAo4V2D5f7AoWFMYLbLBTfQ20mnGlYLd3u34ZDuhz/jsbtu1kS9AO2IEABlORCiFTHZrHDYu00wgFYFLvRGjOi8Rhb3vW8xg+lJIy/XltGGfct8IJVZ6w+Hlpzz/kuT4T97S56YBwOtEZGE8UeWv1ByxE0Nji7VHzWu3g/6pxwvbDiluhOyzLQuq3SU/w2LYSOJovO43hCqgjk2aohUOwrsx00Ym3Y4l4nGkHDguJzUaospvIjDX4BdrHCsUGo/p5MklerrAXy9Y5oi9870VUJyQHROu1sqoBO26Xv6OuGfQEn6g2htIJVdVKNLAGmSJ7dMlCIJqs+1E7TiQcNgVBZZriYIf3BvtST2VFQYQIubsnELeuZKV9T33kcCMUZj47QTnoJRsGqZJomD1xGXIGh3ZHOj/+73j1ice1IF8YW/QIxDa/zKK09Ngb8ei5139e10fzsrmANAdBsQZgl+6PQv6B7tlBsvgwL+ia8+fcxXEyyZcFS/rUttHA4A/0YqAnlDaNigvdgJ/1hsdpf7UkPb98yozywswcBqM8pDYT71GAb7/QTq790Q2WEJTQWCm+kQhadAKQJrTmHJ7PYJfQms79nbXxrwHARMgye0BZoXCRgNBYHViGxiaY/lVdRGDTFQ0d8bnERo3wfD7bNSkHuV2wVmlCe60N5/rzGrrP/GfY9xp1XWPwitPZVvi8U/45J1osXyyXw4JPjyV/Kz4PU1CJAEvbsoFu4LJZs7vkM1MQ9o6JBtvixsWhLfP9dAa7OhM/YAA7BLe+RM6Ux1yvPY+mKwmO6/e3w8B27MuD7V+uCoFAcPT2gapn5MOSzY/5KlHqyACdVXGGV5aU89bKB
 mYGy9lw/
 W/6nFaTEL5kDDCpOAgBP8JyQh6hRf0n08onG+O/Z47KntG4rTusckOIccjgezZtxhBPDDArZ4liPXxgSMx0813nH4l9L1z86gunTzV/+EVCUFnU8/6du0+6LCb5/9/+fqVbC7ZXq+DUoqYBvtwMXlP42aDHwS33WfXP5Bc+ey03Ugy/fd7A2b6qXEfAm3GQaL6ybymRQz9zds8KzU+mbDBWd2PcS1E+kIX6/8cJVsgvgGWxJpruld1La1AZnxHiOAX5xhUlTnRTujRUusLX+xyeNmQaAc3WKxfBMugVDrbh3bX3m0pO9R2Y6Euymq8WtqQEbkqr+YefIGTgUTSwrKGZSqKUqY536kpCkvNUARJ0KNvMwVau3vOr8pakLfB8iSwq5d+KPlIcfvJ0+9lzoSqZWaiNvCbmpBcDzcJTXxhjxTjOYGfRgOwMkKGT83uU5dUr/3doOD0upyenMl2KVrGxMbDKJwx6VnuSSSrUUztvgYiGc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 04:58:04PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> vm_mmap_pgoff() includes a fsnotify call that allows for pre-content
> hooks on mmap().
> 
> The fsnotify_mmap_perm() function takes, among other arguments, an
> offset in the file in the form of loff_t. However, vm_mmap_pgoff() has
> file offset in the form of pgoff. This offset needs to be converted
> before being passed to fsnotify_mmap_perm().
> 
> The conversion from pgoff to loff_t is incorrect. The pgoff value needs
> to be shifted left by PAGE_SHIFT to obtain loff_t, not right.
> 
> This issue was identified through code inspection.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
> Cc: stable@vger.kernel.org
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  mm/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index f814e6a59ab1..52a667157264 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -573,7 +573,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
>  
>  	ret = security_mmap_file(file, prot, flag);
>  	if (!ret)
> -		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
> +		ret = fsnotify_mmap_perm(file, prot, pgoff << PAGE_SHIFT, len);

It misses the case to (loff_t) and it broken for 32-bit machines.

Luckily, Ryan submitted another fix for the same bug at the almost the
same time. And he was more careful around types:

https://lore.kernel.org/all/20251003155238.2147410-1-ryan.roberts@arm.com

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

