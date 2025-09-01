Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5FCCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7918E0006; Mon,  1 Sep 2025 03:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F5D8E0003; Mon,  1 Sep 2025 03:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BBB08E0006; Mon,  1 Sep 2025 03:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 093578E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:33:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A715885A83
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:33:46 +0000 (UTC)
X-FDA: 83839866852.04.672DC28
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf14.hostedemail.com (Postfix) with ESMTP id A712410000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:33:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="t 5K/FdX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=d9pH8I4e;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756712024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kipqqFjvNo4Y7cKqBGTxkuUKZhPOTVfUMxxW+rU6c9A=;
	b=kuazDuSYpk2AA8vFYxRnP28XC43U6SVAjhQV+JPmtbhWjEafq9ot4cabVxKxH5mE20tiBq
	itvbW+dU0AIQqKT+YF7ZAvKakx6tpHbf8Cfouh9MyOT6gJC4KEsXd1Do45Vx0cwQo7uZgP
	b6ug36MqyPKBIZ91S2krpJrw3Mg3QK0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="t 5K/FdX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=d9pH8I4e;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756712024; a=rsa-sha256;
	cv=none;
	b=LVZzRtX8gUovXNjS+QD26B/AeadNwEB3SoZ0LyEwxFJVjv+lPSHBFwdTuX0Oc4W1o5lKLc
	mX7JeVOaCbgdtzda+3mbkdVIVDug4kL67hvAq0qp3L0SkTiNsWj5PFtU8NYbg75R/B3SsO
	BweKyS02GIiWa6HzOOyry/z4oPZJDAc=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id DB6E41380899;
	Mon,  1 Sep 2025 03:33:43 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 01 Sep 2025 03:33:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1756712023; x=
	1756719223; bh=kipqqFjvNo4Y7cKqBGTxkuUKZhPOTVfUMxxW+rU6c9A=; b=t
	5K/FdXewrZ/2RM0ILP5bn/BSgfkppqHgUi3igvqnqeGA5aDPWPJsC/LdoVYaofkA
	sJ32mSKBRiJa8wEp8Pm6HwjCR7WJHIdCBFafpeUeZTDqwvs0XLoFm8Nx+WcTIR73
	HWg1Ct9+WQLc9Xf2uN4BqQOzmfuZx7XjslJnxWo/znyIhanaxEaDyc1JyasghSJU
	tOHiZjv30PsIGYfqjBDfObB0Xf686lH4t6T1jB89tlhNril0TX+vZBW950L/RIRJ
	tViNZSvTBph5SioKh8trP+mT2glGwhsuWv+0lIJqNdQsdnxMgQJ7g/brwLNKXg2A
	imc/wCaOCJtzOJNa9Dx3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1756712023; x=1756719223; bh=kipqqFjvNo4Y7cKqBGTxkuUKZhPOTVfUMxx
	W+rU6c9A=; b=d9pH8I4eJlpTVAKsPhcxy3QKdiHStJQ7QJdlktmIl4Kzsif8Inp
	PIWU8XuJavqBtq1c+/CvuAUaIvfLjsdVguBAmOYirGLEyn1ueUWf7w99pi/b+WTN
	54JMBGOmGUBB9NgsFYsEmlEK5QHz0JxsQOvVWkPFfIhtjks2OBa4cpF23fD3pRjy
	eOgg41MipZwrC9fRhUsr2k//nypy+asK58+6tNYD6aTOHhSlUS+MwkBi+FtlBFRE
	DpVFdqBdWqftW4ifDvUe9AjtFGAgr69HFNWQskc+iF5f8oqSkCu+gl1V/dmk8Rum
	/O1oQLXSkDHaOYDssQ6j9e3nVAEVq3tTPDA==
X-ME-Sender: <xms:V0y1aBr5HiwXCvRLQUdKYZUC84eaB_o-kdsUG2icLXzarDBxSvBTGg>
    <xme:V0y1aKkmys6-VIv-rPjYo7HZNXEeXy5W-jnSzSW_8mjrOrCPoeMZkMXEXPKUDOdhE
    fX4kt0KgHUqBNu8SaY>
X-ME-Received: <xmr:V0y1aHKBDaeXz67Axu793x2bRGZSUbTJYEscAPZ-71awhVphpMEZ-xhJZg-0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduleduheeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeef
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhgrgidrkhgvlhhlvghrmhgrnh
    hnsehiohhnohhsrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprh
    gtphhtthhopegrgigvlhhrrghsmhhushhsvghnsehgohhoghhlvgdrtghomhdprhgtphht
    thhopeihuhgrnhgthhhusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihse
    hinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgt
    ohhmpdhrtghpthhtohepmhhhohgtkhhosehsuhhsvgdrtghomhdprhgtphhtthhopehlih
    hnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:V0y1aEuB8tB740d972UnXCn45IlKHzD42mDAtCYsahDqJ9tLrBW_fw>
    <xmx:V0y1aLJRG_CNTVDYmXinLvFryldEDJCWT6y7yCMnquXYmM1Te1Z9-g>
    <xmx:V0y1aPH1gHI2QNDi1NhCPg2FjwKx8asUSsXJ8pN60onRx4q0OOgobA>
    <xmx:V0y1aPRbDGazDrF3jETq-sSMS-9GHWFnRkBwkSwLzvw2MQY1OVH1Ig>
    <xmx:V0y1aMr7Kb1WDmz7LMq0yZ1qG7t19mc6H_PSdsnscLmn-4dWYOatGyWi>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Sep 2025 03:33:42 -0400 (EDT)
Date: Mon, 1 Sep 2025 08:33:39 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
Message-ID: <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250831093918.2815332-2-max.kellermann@ionos.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A712410000A
X-Stat-Signature: 4r3pfq69nqp4q41zx7fx33w8c6zrkkn6
X-Rspam-User: 
X-HE-Tag: 1756712024-302704
X-HE-Meta: U2FsdGVkX1/obEXFfhsxWdixQuR0IcL2vwZLQWw1NFYy8UtGiAt6xBnH4rF0pf513T8OffiDC3Sul/NqkQpX2o3truWZt3Cutut2bDlDFvhoKQ/H5cGTt07NSGtPD7bT319zd7hVn2ZuFK9/reLXdgJInSojHLoKpDnbsW9r20zgzG5iLyPdLG8mtq7EMFW30+BRjrfrW3FoqgzEMMUPcFWquaoZ9napC4lK5B/F54frPQcCrmKGNF5t+lqRB/j1FXf0K6BafSilNotLsOVxQ6ikeZMqZVAHrnvk3Abr0Kwb/pUrV/7uyNBkfNe0QMrGEqJGtUlUarfu5Xn0tliXt31XXRM8G4twOAVk0XtOgxsyEYVbT2eF8wmsLAkIwupISrlT6JJCJb+hrIbUQbQ98EIG837qbGdXvxAGY/ZFd5UAIae/w68ydaJL0oKe1xdJjvqWnrzO6IvFNw5D3T2qUJLHZ1EysbiTpMmoeaa394r69ziD6iuCTBGX9LbhieyjWC0dH7iZqBo9Can/WwmBezfTW9o1TWGUNq3hKLnywbSJMpXxKQkXlNuMLBvqSF/bNWARCDSLR6dG++V/hwg+7LY9fjOi20c1M0FleO852L67obZNKpDZmsfd51CYlPYawcQVJddT10QDpIZq9jE7DaKfKVwOxKPbcozKc+7afu2Hqje0Dc1vvpsZ1jYgkJZYRplCmgyymfdngSb2igPtnWOHR5Q6SUd3AwQsmzdsxR/kzWfqw39r37dVQ90L+VTPDLp+9l2epaSCOat/lF953DE4YR7V5pwnHsh8HlFrgq7ucGOhecKqrUvJ3GRQbytsD3wneJLVU2tw/ahWY8YfVRC9BH92LkNLhVOkz0efoJK/e8q9Yp+pgWuxtV/wyG6daDSvNTIatdUT6AfOZ8Bg9SHFVDhwDz+vIpjFW1FKmbEkcnEAl8aGhDFLafuImimXG1QKUFsgartMO2ORg6V
 kwTKqHgQ
 HW3jVUt4zGYE5Au1pPhtGzA+SKGBs6nT5GfeZh6hwvTXXiHdWuidHsV4V14wdWHv6My2VWqhaA1vonvzqw2neGyYdO/S50PzPDh/7qtTHhWq8lUh+lE//ohLZkZ/Y8AeMXet0PPuMTqiPwdisPTlSnzLoyNFd+NKInE/vnRsNpXXNtokrnFE8rU1mtGmaYYmP8Wwte64QT7f1F/HHLb9FwAalOxW+oThX2pM0NdeJpwEMYTDoGt4vNAScDwwQBQXJHMPVQgjkbBr3RF4VSL9usBglaVrg/AzgLlxOE1Rh9YZZAKiuUbFpLonB81K25DDFc9O0iVS5tJssJq0NstoNTnqsnpGG7Zn1hwiSvt8U2ONYziljgIuKziY3vFSdS3OPxjQ7Ey0ZfHqJqW5jWELbH7X9tV/QgHRIpfn3cX+1x1de60GqOl4/mQPyhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 11:39:07AM +0200, Max Kellermann wrote:
> For improved const-correctness.

It is not a proper commit message.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

