Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6644FCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2A08E0008; Wed, 15 Oct 2025 03:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93798E0002; Wed, 15 Oct 2025 03:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8D18E0008; Wed, 15 Oct 2025 03:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7AA8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:40:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33FBFC0B84
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:40:18 +0000 (UTC)
X-FDA: 83999550516.11.C63F6A1
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1BB2F180003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:40:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=HeQj2jaf;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="u LbnibN";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760514016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhTvKNjDWORy40SOn/DpL+Jsth7I0286Q518PgEEowk=;
	b=HFU7fAEt+dVVNVBVGB1Me3oaYH4607ueB8vpqyfhvmlG3OeNELS0RVYdBYViVgFmDQ4I8n
	b5PLgw8X3avxyIvEuuwZFHVbtgkCqiZp2b4LB3tyZ48cPx1RITLzzz9M9jSRCiRRcCiWV+
	Qdr5daTLm7puSpre6voDOwn4n1glWQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760514016; a=rsa-sha256;
	cv=none;
	b=3Tfb+KUGIe3wA/SEMSJ4yigm4Ia47UJp96P3CQhfxtF4RcC8HD2m2tinua6J3uOLFjKk0r
	cdMDoctpZbDR6PaCA9Ugagbi79mm1Acjjw+sORjV2iekCfK0uYdv1lE1TIoaTeDeut0tX1
	BUjHd0b9yRSeQVZ2jw2KwgCr3CmSEX0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=HeQj2jaf;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="u LbnibN";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 231051D001CE;
	Wed, 15 Oct 2025 03:40:15 -0400 (EDT)
Received: from phl-imap-10 ([10.202.2.85])
  by phl-compute-04.internal (MEProxy); Wed, 15 Oct 2025 03:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1760514014; x=1760600414; bh=mhTvKNjDWORy40SOn/DpL+Jsth7I0286
	Q518PgEEowk=; b=HeQj2jafkF0vTfOTyfDFcbDCaAJv5ndMmHcjmcubECs792VI
	++8nFLzWgFy+p+7YBNFfama4/+iKAfI6WQkhXGmyuOgA9U+twL1peq3rCSUtbRia
	FzJb/y+xMV+x8wdrhwKL2BZzsaUYks2Pxy7u+VGcivpqLvX9NmKe+8bJ1KhkmoLS
	2SwBvfdVYNyKyF3kRhONNLTI4dHAQEPC7erbdCnpbFwQ45BPO1+tHH9UL/JDU1ms
	hqID6V6U8tGQG/2oYoBXYYRWiH1qdqRQlRx4wn4kBKK15poaKV8oupQTtxURcipJ
	gHk5WgYPpQ4f62jTcA4w0dRwtlSsIrX0ZrZEzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760514014; x=
	1760600414; bh=mhTvKNjDWORy40SOn/DpL+Jsth7I0286Q518PgEEowk=; b=u
	LbnibNegX1nlLwH+tYItt+hl0UMp6N1A18f5ba5ndZY4AICwwm4oGq7HWaJIuaSK
	O6DWsHeTkQ1xdsxjfLI3ge5pA015tVTAlL+M1ZdHs4cI07BXcUgAfpZTgEpbSalr
	8zuHwp0FJnhYTjJOHbEotaKMslP2gYFe6QMApFTLxlGgVtITSa1uGVbhZKJVb72D
	rhJYqyZDl2jTiK5AvLHROvly1M6lL+C6TlTKdHsa7LdHNOekkzvfO85bi6BLTgMK
	5f9T8oWRTi540muNaLXeeGofgsUiA08j6T5sU+Vx1uqEgACmjX9Me7qqCGoHNFw3
	OhmcrBBU8jjS/7G55g2Hg==
X-ME-Sender: <xms:3k_vaOCHSszB2XjJaNKKkzyTR3AyDqAMXn5feq4-D7KHkcLEJ0aaeA>
    <xme:3k_vaDXu3U8ADuZY4BwtSII_zcAIPgTupwyQSLfNUtGKQEyyjQ_aKqPoKcXjhtIA1
    juEboi_JLEr4R8f4C0X38xZx3A-At5dxI34Smqkqh6EN1zRsnvnV6U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvddvkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfmfhirhhi
    lhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrg
    hmvgeqnecuggftrfgrthhtvghrnhepgfevvddtvdegheekgeegvefhleevteeghfevieej
    hfejhefgtdehleffvdevtedvnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhes
    shhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepiedpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphht
    thhopegujhifohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmh
    hmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrh
    drkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:3k_vaED22WLve9jZiRv2Gjd-J-HYJYE8ydeBbvatr8ZxNmrjNBO6KA>
    <xmx:3k_vaBd4O_zaJtJpqgihPa4y-ceRwHSJXEjg7I1WzucCnxwVniWN-Q>
    <xmx:3k_vaGlCc4i_kAC05bIDWeuukZyctAy3gC5hLjaeEiQrwrYbGDvTmg>
    <xmx:3k_vaAGhV-z4d_pxOz7Zydve9MbRj-yvf0Bo_TirkVHQbzPF9tKpPA>
    <xmx:3k_vaAysEYc9reCf7lk8Sgxq4DeVmNi9WFy9hEjZ3Vkr_YpK6yMaMLpZ>
Feedback-ID: ie3994620:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 53EBF2160065; Wed, 15 Oct 2025 03:40:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: APftQYjyEKps
Date: Wed, 15 Oct 2025 08:39:53 +0100
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Darrick J. Wong" <djwong@kernel.org>, akpm@linux-foundation.org
Cc: linux-mm <linux-mm@kvack.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 xfs <linux-xfs@vger.kernel.org>, "Matthew Wilcox" <willy@infradead.org>
Message-Id: <d2b367ae-b339-429b-a5e7-1d179cfa0695@app.fastmail.com>
In-Reply-To: <20251014175214.GW6188@frogsfrogsfrogs>
References: <20251014175214.GW6188@frogsfrogsfrogs>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BB2F180003
X-Rspamd-Server: rspam02
X-Stat-Signature: jjpu1me5cboy46reg9fkmpi6ckjk87tx
X-HE-Tag: 1760514015-590561
X-HE-Meta: U2FsdGVkX18qKuRj9xhaWpZJTpS7403E8KAKqjYH1tTrszXVXx/1ZFS3602sHSySw9HU39U/L7d4BzEoawGhwIepI+k12HN0H2bCabShXZ7+cTKIUbGUS04V086pPtyg1eIvKu5s1zibk7Y+hICtweLZK1/g00fsV+W9XeWeGf8L18e2AtPKkzFuJgqR01kCnzqWcEOVhbVpqW7/qM3ds95WwUykfJ2nmPNZI5E+BI/HZJ/fOIDrSwU8qDrFXZ/vcuAgfr96YvQ8rKcZrSqglDcRMmedGhuAtuOcX2+1YevgPoQ0V/z8ezL6BVRF5l92i2kxV4V/7fVmCG7AqY79bQMmcb44JozNjCrqJ+0d27zNuDKr5RVb0h8kmj97vsR/vIcYRhMln+wvi4LAOw4usYLG7yZ7RnYUns0zVtC/aBfL3WtajMZFfyRDZYxFbmX0irbVbqQ5K+wzfdWKWWLuIs2bYs/kWmadEHdW36bAeyfVaKEpqetLh/e2lsna51ygZGdhsGvCCd50jwh3aFJEo6jHW8RbJq3QFq4RI73bXqKSt9vbPfSzb797PWt3f4dRuHwb+0l0yLnBp3Sm4d48WxJIaHn33gceXVI4rXnpddH7ENMZWYUFYCCEDpQGcUfz2zZlN7iw0RhxRR/IHS3AOxG8TcXOo9RdMn1BNAOfNtenTKzdeMCouud7TQ8W7Ojg+ZMmgf8+/LuLv+rMslov6UGfUyC7R1F9rPdajDecAHbI6yW1VvN/7OOMIJmNp5rB4oVADJnt2M3KZJSZa/B2YbygGFbW5FC4Iz/ux16txI+XsSktCW615DDPUiwcc9QjzTslAhJGATB8IoBZi8q+sKU2WXLxZUzh0dxOW5OKGVXsp/0RK2ig7Sen9Ufj0icju3abzdsu3k2oCcOmdiTd2jNqiB6X9qLZ+dYPb6H0DWFwv+kRSbcqUuJJhRTfWp4BZTNH7cUB/Qa7zerlxTQ
 i02lACYB
 8A5t2TMu1fHJSXSk/+FVp8AAXRVchDDt2rLvlCwBEFUXKES5ArteFxKdbuFXodHtWZ0LxqG2XgAxKe3dpfr09PKPh92hZ597hdETHZF6wh2SnS0wMQ31K9tWo27nPmDJ3M5qJWJZ14Jd8bZ78kLqCZrBDPDLOn8GD7N6NpSnuLlwNz8JAIYHV5VNA1s97o1+Lr1SY8Ta9HxUjvYQkNn1CHVWB/il0zBptEyeptTcE+ZFYGAUqeCh1kUa2HELyME8P9TbvhPPCiZgkiLan6DnC6SPB6j/OZzCDq2/bgXeFfYyuOzCkQKcpce03w6tpL/aRFgG5Xj667NdjNLD51zbzIAAksQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025, at 18:52, Darrick J. Wong wrote:
> Did your testing also demonstrate this regression?

I have not reproduced the issue yet.

Could you check if this patch makes a difference:

https://gist.github.com/kiryl/a2c71057bec332240216cc425aca791a

-- 
Kiryl Shutsemau / Kirill A. Shutemov

