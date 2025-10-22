Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F993CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975868E000F; Wed, 22 Oct 2025 03:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF0E8E0002; Wed, 22 Oct 2025 03:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDE28E000F; Wed, 22 Oct 2025 03:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4418E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:40:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1728788950
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:40:56 +0000 (UTC)
X-FDA: 84024953712.06.7F6184C
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D40D40006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:40:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm2 header.b=S2CX+9xO;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="DU/wXHAj";
	spf=pass (imf27.hostedemail.com: domain of greg@kroah.com designates 103.168.172.151 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761118854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9u/6AOHdyJKLm2MAVj/gg3WnnXnpnA5iTO0PKfyo/5U=;
	b=skqFMF9CKWg0v4l2XI4RMc2qolSHcJpolLxhiNrJVlNU/nHQFqgClXSxsHt/rczKD5++bI
	qsYNEBQuckPTPMnTptHbqoobf/r+bWweTdC50KAq02RLcGdokBgRcNmCP6ElUncbkVERh6
	wWSuvmmX5HwrHcdBD3U4AHQxB0Hxuo8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761118854; a=rsa-sha256;
	cv=none;
	b=SwyE0T26q//IHUZzqglHmyZNd5jCVYVbCw9D0TVuzJQzP4u/rTFygwDy4g4D9YVymclcll
	klSILxSlLEHkJsmWZkGWKue9nUZTqkSB8ZGUVmTZtUIs81S/mq0IWgwqXSG6PKtszZY3AA
	qII3dkMDwlfEcFIsE1qWYKohnC9dbhU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm2 header.b=S2CX+9xO;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="DU/wXHAj";
	spf=pass (imf27.hostedemail.com: domain of greg@kroah.com designates 103.168.172.151 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 42678EC0183;
	Wed, 22 Oct 2025 03:40:53 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Wed, 22 Oct 2025 03:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1761118853; x=1761205253; bh=9u/6AOHdyJ
	KLm2MAVj/gg3WnnXnpnA5iTO0PKfyo/5U=; b=S2CX+9xO+lB5b8QIcajBhxlNP9
	B6S0lIMXmIEIHLe0mBNFn53EkW9n3eRhfYHhGyW6Q8HTO2V4HJKSYkXqUSGPpSOS
	mX7L0xZ+YAsYs6GU9T5KSu8wSHcB4zXguoOe+DpboeDuYh9qYO3Daznip60lTbyB
	pXe2flQNFYvMEEj2+YEd/OpC68yX2Ei8bG0LQueWg+93vvwZPmVv6rWKiZXjZJx1
	jb5aDkcBjo/8TSYZUAQv1BSxoYQ7P1l117xNRhFcTJzewh17ZIsCJC8zXBbD/c7J
	mkritEo8EsTxvYU7j+MXUwJt0AnWQPD7Rdz8tQPXX1lE2Db+QuvCZ8LGYjOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761118853; x=1761205253; bh=9u/6AOHdyJKLm2MAVj/gg3WnnXnpnA5iTO0
	PKfyo/5U=; b=DU/wXHAj0AuA/qtjvo2fDScseQKQ4OMji/CnkC7szRlxmbbDWCv
	rGNG16shMn0eboV1GejawCJ3DBb98pWeLiFmkfUyxOuG3L8XMcGd6WKwC5xoQxM/
	N89Dxj1/wOVspufdjh/9QFCP8Hs17ncM+JS8omOD8YATEfOXdBD9pHkJs4HhITAp
	nzdBxUPedvEersg9PedjWUqtfbqApJP8tyXeX0kE+0/nQTBTvN1M2zT8j9g1/8rW
	/2aZ/Dn1xSC9yFM4c8Xsa/QjGC9celo4R4dwI3rZ6d/5G9j0dDu1I04AGBfppGy4
	Fvp8WZ3ryPfGRX+A4sBCn3fmnGMi6vESRtg==
X-ME-Sender: <xms:hIr4aLlAkY4zwtHdoPYzDEThSSYDKiJbNeqGUBF3uWGWfisNuhE-tQ>
    <xme:hIr4aHlgs-mwtp1Qbf5F5Vbx43rgjXqeLQponxF18l-tPIyAk6l2KAXQQslts92Io
    Y8i2RWO00reWipJGVCjvMca-mJWS611MmQjkILGISo0w0VZmg>
X-ME-Received: <xmr:hIr4aAXpN9J0gX4tRVJFrMqBBVZeMpM2bqQwB9Uajdzv4o5A9N1MIWtK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeftddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvdevvd
    eljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhmpdhnsggprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheplhgvohhnrdhhfigrnhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepshhtrggslh
    gvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhig
    qdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrth
    drtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlrghntggvrdihrg
    hngheslhhinhhugidruggvvh
X-ME-Proxy: <xmx:hIr4aF9M30XQygfl7U-P6vIcPnB5h_FMk1MekPlYvg2aVh15tPH9og>
    <xmx:hIr4aNqd-8PMwOlgRSJEGQjZ-7PiXKIFBW3N7mIj5-3_hXb4R48Jjg>
    <xmx:hIr4aHnI4hZqJrIurvlLueaonGwfj55DByZl4_l256-hg_KTCc_0Fg>
    <xmx:hIr4aBYb3lFJsPbTSmNmiGw_1_Q0jffZuO2XT91gIVjladboH6cvqw>
    <xmx:hYr4aC1uwQoSH2P8BZR-2V4Ltoxt1wCMWv6d1hEpg4nNI-tMkewhJZof>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Oct 2025 03:40:52 -0400 (EDT)
Date: Wed, 22 Oct 2025 09:40:49 +0200
From: Greg KH <greg@kroah.com>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
Message-ID: <2025102230-scoured-levitator-a530@gregkh>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022055138.375042-1-leon.hwang@linux.dev>
X-Rspamd-Server: rspam05
X-Stat-Signature: 8yi77ocx93fuo6znne3drng6guc3qgy3
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D40D40006
X-HE-Tag: 1761118853-922985
X-HE-Meta: U2FsdGVkX18+6zxgvewc5pOS3+AnMQ7sp4T/sBnXzziYRE46PkdVZffViftbFMwkFB16eZmswtuFNuuER6KxqRFFr4WJw2UzEf8BwiPEwpHnQLD0esqhPGQSd3GSt17ony7VEZZib2bT35zUbGE7bFCXgFK3rMB2vjGuT/iJjnHWh3HjkhVC9qnPoxsHSCrCX+FKcu9vVnltO6CggpGOD1yLaOvnlyncqQlOMaMoO1HH6L5O692hKn/+OPllfzq7PXl7KUaf9LXnGQCyc0YrVG5c/31nfFcnOozibnfo4h5rvXPp4GwF9Hbmj480YkJSbmqNJa3tnwl+E6eStGC5EU+oCbZhOYoKMb15fsHoZ2WCe0IZ/lkCOeyYGRkJ+J6BMppe6EhlKNdDKi2xyEvm1Az+Toyi4n0Wr9KYTDnf1fc8sI+o3xVi9oJajFxe0v2m6BFzQsVmn1OQID4AVON14JAXvRrMo9KHqf/DIZ4lLqkPENFXe9XsE2WwLqEribeqnLn5AeiLjEyDmwGjRoSXp5tDlMHawJ2fs42a4b2uOcGP9IFXlJRKhoKJ5kmSfLn5B4rwUs3zM8+uuTYPYASJX94bHBw5g+IRp4nLfXqGu5OplyC+O/4+qEhWeUdAvAKpMJ86TRvrfFNIdyclkzyoag3gUfwMEksAeq7P7a8/5kaADHWNACdTs523qjj/MrFUY73qJhxQhPC2VHQm+WMC4zy3rOBG+pRJ5sZn0Ot3+8yk9wM+zys9FdLsUhe4Ojh2xLx2d+wy4CQr+HSqny0FXNUpeiUxTmo8Db9Ubm6/Hhp0/gZJ4yZM70ztxkkreKwBaxAXLfO6ZGfDdD9DOuq1Xs0WHUSwH6nNqgZGK3mO6BcoREkA+9B7kHjzurHHP+LAMEvjDonY2LMGde8z8eOS3IJ0aaTMpyTG2PthLISw21upn40AjFfEQ3/F1VeeuKQo8N/1S3cU4+NkS0OxNCz
 KPTsSAkZ
 S9A8D6+KyvNYfMsi4FzINtE7k8vbJyixtkRdElgUFI13r2BAhWBRetXqDkbS1ZRt7vShJA+97cp2RwecgJRDGicd4ena1SuFN15ntNjrP+16oz3X5R28e2K8I6C5XWho2vn9Yhvn/jJccFNckIklgMNgXua3O+hccjQjKJIrrG7Tt1EtGC3RjuCKvrXjoPHo0w5TA2nYCb3UfVRV6qFxkik+UXZJR75hBHSqkERaX3rsCvPxATo7DonqV/COcW4TzBxBkf5Czyu/EF623SQ8Vp0/BJnlSb0rIi1R+d7mx0ZH1BsPjOLdu5KZlPZO2vyhio3W1TT2iZm1GONnxeLsv7fzyFyQ48VGQNeqYJxXpwYnJO2aB2BSrsBt55QIjW8VpRYrSOlRSKKPy8k0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 01:51:38PM +0800, Leon Hwang wrote:
> Fix the build error:
> 
> map_hugetlb.c: In function 'main':
> map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
>    79 |         hugepage_size = default_huge_page_size();
>       |                         ^~~~~~~~~~~~~~~~~~~~~~
> /usr/bin/ld: /tmp/ccYOogvJ.o: in function 'main':
> map_hugetlb.c:(.text+0x114): undefined reference to 'default_huge_page_size'
> 
> According to the latest selftests, 'default_huge_page_size' has been
> moved to 'vm_util.c'. So fix the error by the same way.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---
>  tools/testing/selftests/vm/Makefile      |  1 +
>  tools/testing/selftests/vm/userfaultfd.c | 24 ------------------------
>  tools/testing/selftests/vm/vm_util.c     | 21 +++++++++++++++++++++
>  tools/testing/selftests/vm/vm_util.h     |  1 +
>  4 files changed, 23 insertions(+), 24 deletions(-)


What commit id does this fix?  And again, why not just take the original
commits instead?

thanks,

greg k-h

