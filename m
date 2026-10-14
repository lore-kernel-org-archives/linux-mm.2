Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235CBCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DDC6B0092; Wed, 14 Oct 2026 13:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5C86B0095; Wed, 14 Oct 2026 13:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDAB6B0096; Wed, 14 Oct 2026 13:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E39A16B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:06:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 753D28066F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:06:11 +0000 (UTC)
X-FDA: 85321859742.15.9DC6373
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf14.hostedemail.com (Postfix) with ESMTP id CA867100011
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:06:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b="RPSK9/aq";
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf14.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3fKsgG5iY77xmqyrOhYqdFKE1+IVwYgz7kMxEgAwqs=;
	b=hBuwZdfVGnEByUAfwdN02zHGzFqMIXz2sLMpE6vBlSupjii7mSw64ZmWDDcuvYhqdrVEA3
	JFz7gNtiz7g4jQkaxBWY2vyzfmENPpZgQN/hz6QdGWOrxXfC/QKfsLf8vRbZ6bcvXUiAle
	Mj1WL4nQEfLutpDX0QH3asX/dwmXJ2w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b="RPSK9/aq";
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf14.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997569;
	b=hY4THq86xBBgY6ymvbXcMv69MXPsQWPdbMPI2qnV6Tozc00h1cT6aV4vXzloHPqSvaulhn
	9Pina6uy8NgMRLrgwCJ2ZsbpDEK168tL4iSGglRvT9sIsy/1ZupJJlA0W2hm11EMyAhhYz
	hagtEkcFDVuWdB8VEyODzOiNTgpcHlE=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C340E408FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1791997568; bh=V3fKsgG5iY77xmqyrOhYqdFKE1+IVwYgz7kMxEgAwqs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=RPSK9/aq9j8Nzg1fd4VMNPFzXRJmtZz24NMq81pTNQ4oD8XhbrfTHksEjTRmVBKB8
	 557XILwzG50Oz8UDOWwkBgeYiHXAan0Q865WIZKmrs9bu964/ODoHWuz4/FlVJjwDJ
	 2UbdSl4UatkM6WiQLAlU+GTucyPcrPwVSTO4QR8X7/fyvS97t/ytnRYjJ9mMT+6wRM
	 8eSEBTp3rhMeEsgr24NrHYxuI351L062M5Qf59IOcRLuRDTwVaN7yKeknzmD2I6AdX
	 C4BLoWEluIyJkFd7HFm58QAtifjQiXw9zq2XWCiFgx4H0rVd47QUV95CMvUh9H5ST5
	 FILQeN/lY1wAA==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id C340E408FF;
	Wed, 14 Oct 2026 17:06:07 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, Mike Rapoport
 <rppt@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] docs: kernel-parameters: adjust reserve_mem build option
In-Reply-To: <20261003213457.96408-1-rdunlap@infradead.org>
References: <20261003213457.96408-1-rdunlap@infradead.org>
Date: Wed, 14 Oct 2026 11:06:07 -0600
Message-ID: <877bjkw6tc.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: n3b4napbnbky3jxynzx1r9336n6hwz7x
X-Rspam-User: 
X-Rspamd-Queue-Id: CA867100011
X-Rspamd-Server: rspam08
X-HE-Tag: 1791997569-971536
X-HE-Meta: U2FsdGVkX1/o3s8c7WEiGzxHChlXeguSME52lW/ORVPfFokQLJI2iH2XVkOwcnJFfUOEZ1Nnpu89iBmI6IF6jEjSP3jX9TAOe0WG16yLI0taCKGZNzXzwuaVnGLigZxeWrJMMCZO1QCNRybD/9ftkPt/ad/sMsZdqazRJI1Lj968bFB+pM74EWwY5FmrXEkSMQ+QH6lBqCBvtSJxQzyK+9hdLVeI8KWXj1d4EKHq5iRgY/Xgy4qE0xf5/V1/p8Vex/cQLoHz2wWUcX1k6Wc+04UnfWJXPSnpR3MvyCiEwz6ji/2c6xEZ7Ip0YJQzSeIbcnZYoCnIs3SQu5oKTstjYH7tuS12rhDN7X5pYQmwOmD1YYLMguc/614eaA8oiq9R+6ghxWGpcjzbsTJLb87XxGppCzai94RSDxItyVhls7yVH7+MoU8hRpgkWP+XgOpJPp8TrYVzNmUKvETKQtgoyMEUpxRRSSjX2WPpljtPAvWUzd9rfTB7WdnEBvJYJ2dFH28d+F1YUtjnJImKXyf2f2ufBbxOnKp9yNB9tXF1xjiASYphPZSlXKOlNTFZH+Jg6pFAxlwtFvdYlcWfxQkc7vzFI5j0sbWSfZ07iaTGjk7avPnsHtdSzgNppL4I0ql+kmJcJLnzwmblDjPHxMFRnNTM7i2WhWUNsUQB/+a1wTRsAguNxZMQkJxRfIxPpxv/yN3G5SEB1waczaxluuiZzZPxBIwt7Pj48c64BQKNSeQ1EEkO5iSzvVN+w2QSvPCM7sac2/SYhgHmgs+HLP2jewRMEF4br0JrY++dYyh6FGawIkVPfDVBuRF3I+MaUMfxffQ+FK/LxL0cX3MvyOvKzjXOf3wJ71V+MqfCUyD41n4PzXPd74lqljfD45B7g7fctclrFl3ZiKlh/JSlv/LA3SeAMUYsnCc6C43qHf679OmKwznNkqfUBEqCOodm4cJusu58NGmbpiIXDESh/wd
 8q96z+Tr
 F+/Q3Vwy6plRJP0BrHwEiaDfi0Tigfhx9Uru0JnJtg9vVaJucnA8/aiE4kozFx78gocAdY3cUnNP3i1v7D1Orz/UK97Q3tNDuCTVfjZ2/t9lDSVpwUDlte/pRxUg6mUuEPUj52/Cf+rL9IUKHUhWvuc/gpdRIDrOg/CveigmTRZAWiBqgo1gjBgkIY5xwdmcU77FXyHRciYlrgUip6mPNTlf26m+zZliyFR8HTToEF/295GItigVML01gdWXnHd0QZrYZySvyVaJA1L6+C808FhVCoOye18gUdOSeKGvkRdu4ldmRZF2bQgtOhaZ7spaCh9XJSq6P/GQrAcQma86xYHgii7DQRNrNMCUs95FoLd0ty4puXMQwnNPtyB7sgtdzZ593LZDNx0H/DaF0aeHgZTIVraq7lgXLmQV355sINA7Erwt5MUZibzIawczGAi8r7W4PDe7picjt6k9Kn0vEMpevvC01UauxieW7jpqZwLoh91fUb1iCTadFr9TjJV3k7cfHjsXOnBn6+3N4bLC2ASjEhwcLqsU3SffMr4Myd3qshZgCtDa+hBrK6dHG/Gaj/9kOeyfeKA1pVN/6iuWllMOk+tsAL6KfdvxSz9I+yoKcly8UYV4K/p/2uDWq2RCCMhOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Randy Dunlap <rdunlap@infradead.org> writes:

> "[RAM]" means that the command line option is applicable when
> "RAM disk support is enabled." However, the reserve_mem command line
> option is not related to RAM disk support, so modify its build option
> relevance to "[MM]" instead.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
>
>  Documentation/admin-guide/kernel-parameters.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20261002.orig/Documentation/admin-guide/kernel-parameters.txt
> +++ linux-next-20261002/Documentation/admin-guide/kernel-parameters.txt
> @@ -6693,7 +6693,7 @@ Kernel parameters
>  			them.  If <base> is less than 0x10000, the region
>  			is assumed to be I/O ports; otherwise it is memory.
>  
> -	reserve_mem=	[RAM]
> +	reserve_mem=	[MM]
>  			Format: nn[KMG]:<align>:<label>
>  			Reserve physical memory and label it with a name that
>  			other subsystems can use to access it. This is typically

Applied, thanks.

jon

