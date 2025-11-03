Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96FCCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 23:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375F68E008D; Mon,  3 Nov 2025 18:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3271F8E0058; Mon,  3 Nov 2025 18:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C7E8E008D; Mon,  3 Nov 2025 18:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13E528E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:23:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB60758830
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:23:13 +0000 (UTC)
X-FDA: 84070873866.16.572142D
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01271180010
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:23:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=C7PZi8ou;
	spf=pass (imf24.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762212192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfeAfWg+IWTxPeqmknww3EatCKkRqqTiNS+SFy7zDy8=;
	b=4IVF2dr0+pcRWo9ql8ynFV8CdD2yTZTAn/jFGEgNUxCOQvpA+USz3pAihQ8kQR9/fzoSiF
	BqWXdmCAbzdNHs4x4MNzASJQjaCUVzmP1pKnNB2+rro+EMMQMW++NXzw+6cKbiVakHE6zI
	U70Mdje8wy7eSjaNFR+npA/702MpLDs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=C7PZi8ou;
	spf=pass (imf24.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762212192; a=rsa-sha256;
	cv=none;
	b=tIvglb1AJEUgwn9pCchT5PBf0FeE9pizET7gR2h0Nac0ifFr/8jVlxNcAom71eJC0zt+f0
	bHK/iUe4Ak9BiwaN65BcSTugaGtAVeTP1MdCfsK1fgvgRiQakqDtv/9YeFEKMOJIX6Q2px
	gpca++l2b1Q/n22BRICDP1P3rQxbzCU=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net F134A40AED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1762212190; bh=jfeAfWg+IWTxPeqmknww3EatCKkRqqTiNS+SFy7zDy8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=C7PZi8ouCV7iZa59u+XIrElecjYmTtEFsaisx0hWWOJo13R5FX9nYHvuJRn+d9m/3
	 G+u2qR2tbuu0nzKy7e/8cy9QLbwqviODfTpNYimSGyYBTVQc7TkTcvo7gkQ1rnmRj+
	 3FsTgsmzDNqCe+orVXZIDYgMQHa0/QauBGyXKnc8u0JpcIwybwl6Fo8Og49W8yxM2O
	 c1+39723JTDAD3p9VR7EIq3bX0NYXv7baxQsvwzu/8XpTQzmTJMKTC0ZvfGQN6aMeH
	 dQnO7JQlIVoaTQjXHW17da3+xsLlZYozde36YYcjTTssIGHtYiV5jHLamyMfOmktit
	 ULWemk3qQDBOg==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id F134A40AED;
	Mon,  3 Nov 2025 23:23:09 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Documentation
 <linux-doc@vger.kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Alex Shi <alexs@kernel.org>, Yanteng Si
 <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, Bagas Sanjaya
 <bagasdotme@gmail.com>, Christophe JAILLET
 <christophe.jaillet@wanadoo.fr>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Documentation: treewide: Replace marc.info links with lore
In-Reply-To: <20251031043358.23709-1-bagasdotme@gmail.com>
References: <20251031043358.23709-1-bagasdotme@gmail.com>
Date: Mon, 03 Nov 2025 16:23:09 -0700
Message-ID: <87o6pibt0i.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01271180010
X-Stat-Signature: 4n844weenn7ackgmdqghb4q75soo9m8b
X-Rspam-User: 
X-HE-Tag: 1762212191-328455
X-HE-Meta: U2FsdGVkX19u+78HN4joAhs9IOTWx93lLmbeNHMyhjyk6wX3+9fWj/2W75MNc0Wzx/shpCV+Xd6dM1UEcCiMOnFSowqXArNFD32/9jOsHDessPVR65apJanIcWmqD6Y4mXT/Bx/wB1rNoDbElJtFQbmBlTehfPwn0wY+LyTqzbKHGZZl4TXUlVxiertGv3uaVAOt1t89jwFWRj/p/joiXAfSj/wPJd8eRvqh1JTn92uOFAR3kANt1AFzE0Mt0qAvob3VZyvkO2rVxifBRdENyqgL9UIYZJbBe+aD4gJdXPde0Mk/3xyNBDuBS4Ax/FwZy0uQ+lW4aKt7YYJwHbr+VI6vhr1XC1o9gnh1vBWQFr93eBlt4rJNYLO3SApV5F8sBFogFuPdIfsq+tK1+5H3QsqeDbNMnX4KKSxCffNBGtvU64tYzwWKsrI5FrgrPeD0txNwTIvJw+KGmyb3jr7nn8+qIggDkLZYkcwCyx2XlUHHQ8tPAu3YM7RAfsMnLRXEBWiKt6yipYEgfqTqMZ/U9AW21mWhZcxlLmhzFfePTzD3M4xwMtmLTz1rcd86A5Cmw7F/jdOn5yU9xzyyOrOxFE5DnEqnWD0lzNxERHDV+de2x0awX3XzGWILRD3+GyzQ4nawgj9ksDcE08yDGpumb+4db2Uqen0oFRW5VVnWStE5bP+F7wGIxUY/uuX6WfKfd7UwNmyfn2dmF6hHz5iGWXmQgMsN3evMUfjHvCG6wKNi2HoeX7dBUeAtWQjPuRC9VVcnAQ0xdjPbGoyW987zL47FqKyJIlZBEllR4OLQSszeSBxZJx8kO0xQE4STIHC7cJzkJwq43AoNayJx8hEMj3pzQA0tuW4W0PEI8hJIe7ryj9lwicpfpiet8j5TnrslHpMuqRs1bNYn3a3cA/YV6gIFw+VNL2GNh6yEm7G7nANgOnMGOv31icme0aVpHHMipLFTlpn4IBJwSJCf61k
 v//A99pl
 Lm3zZnOy682+eQpEyoCX1u+UTuWHW2PuHSfqJNABtMFabFp/jaw57AOgFsNjGt01jJMicKKrMH0JjUPkKbxx5FcBMNCoqb9k06uskMhRaMcwN0294j+aHaOQW9ZEPAJdoHKNRU6SFuSTcmixzcBhXJ+xYJrJEjVoc0SV0FitP2ORu2C6811/SCgSwVvathYCe8OYY50R+3osAAbbKusl//8a/6gQj0/Ny7HTEhG4vdDZp2+Wc7c7t2uQZo27mwR+7rqAkSg+nqyDdxz4ETU8BvQUG4oGnSwrnXy8T/tQxZhwOVo0NTvMgFjDgy/y57eArjo4FbANVkHGL8C4RtJexC4sxbDn0hXd4H2mJUNO4t2HdI50WrPfNBUzpL6O8dzA+jZD1a5EE3R0XmV7m1FcUin7mqJeTL/U2k3BtnAaTlqKjCQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> In the past, people would link to third-party mailing list archives
> (like marc.info) for any kernel-related discussions. Now that there
> is lore archive under kernel.org infrastructure, replace these marc
> links
>
> Note that the only remaining marc link is "Re: Memory mapping on Cirrus
> EP9315" [1] since that thread is not available at lore [2].
>
> [1]: https://marc.info/?l=linux-arm-kernel&m=110061245502000&w=2
> [2]: https://lore.kernel.org/linux-arm-kernel/?q=b%3A%22Re%3A+Memory+mapping+on+Cirrus+EP9315%22
>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/driver-api/usb/writing_musb_glue_layer.rst | 2 +-
>  Documentation/mm/active_mm.rst                           | 2 +-
>  Documentation/translations/zh_CN/mm/active_mm.rst        | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

jon

