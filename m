Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2435BCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A8B8E000A; Fri, 12 Sep 2025 06:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B3C8E0005; Fri, 12 Sep 2025 06:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568258E000A; Fri, 12 Sep 2025 06:10:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42F8D8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:10:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E582813BB25
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:10:27 +0000 (UTC)
X-FDA: 83880178494.04.2D63869
Received: from out203-205-221-155.mail.qq.com (out203-205-221-155.mail.qq.com [203.205.221.155])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2EA5E80003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:10:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=DgAPvXWP;
	spf=pass (imf02.hostedemail.com: domain of 920484857@qq.com designates 203.205.221.155 as permitted sender) smtp.mailfrom=920484857@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7d6nPhgsu42OQ/nG1elx4UhCIT4hBtFOXQ5i6Y/4Ii4=;
	b=dX83jYlvr7lViYQCPUwSv3JkVFS2NVO7nGggCfkcIdPdAuefDuNiSng8DMJTMqiYFXm0aq
	cwtmEcrr1vkrixFuVPglCxuTFUPokGR2Q3nKO928lDOMlNV7CEUc+dJ9hCw2riA5DDIogs
	NtjQa1VXWMiqqG7aRDxTngJehgTmYkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671826; a=rsa-sha256;
	cv=none;
	b=cx9gBXbEnNxn0snOgP5NOppNttJVxamONZQcemM1qIOX4+nqk/is4Rb64gs92cViL+UHXc
	BAG9HRP7pg9XvlYEBLVWHGzEbGfMb3U0M4nAUteALOmWUq8l588pPW6EWRqI+Rdrk1xLWD
	8/LUJCtHcfarKJhaiX7+/TIL485DUN0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=DgAPvXWP;
	spf=pass (imf02.hostedemail.com: domain of 920484857@qq.com designates 203.205.221.155 as permitted sender) smtp.mailfrom=920484857@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1757671815; bh=7d6nPhgsu42OQ/nG1elx4UhCIT4hBtFOXQ5i6Y/4Ii4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgAPvXWP2Pcmx3g8/bfmgIbhav96q1iTF1gr/xV4PMR6ywRLZYn/X0/qYHUWjp0cD
	 YXzbHMCu7WqJKEtCxlvdnqYDq3Y8mbT2Nl1EHR9kJ9nuV9HowRZAcqYDn2+5IcMSEs
	 iihHSY0DOCysK2FbOsOtMMSo2vvhotOzO9XVp0wc=
Received: from localhost.localdomain ([116.128.244.171])
	by newxmesmtplogicsvrszb20-1.qq.com (NewEsmtp) with SMTP
	id 28731C2C; Fri, 12 Sep 2025 18:10:07 +0800
X-QQ-mid: xmsmtpt1757671807t8ir1jn0w
Message-ID: <tencent_43768D3DB24034B62C249781C1DE7359C807@qq.com>
X-QQ-XMAILINFO: NY3HYYTs4gYSLjraKA0cvy+V5eHHSDp3c3cSlTTIdWJ8tEKnd72RcZdPrdHryB
	 z1E+nv8urYdwczLXbZDt0oaAJvHuoUg56eSW5gjSCdRLAagHinVGQeHfJsQkC+gthvRidb6j5llO
	 c93iG61cGynfhWo3BTgXtcaJEIBYpmBElsOAZMJ0STbc18AUq+WJ5d09h/8qTONpt1H+yHRUMbR9
	 KhewYMsCsljKip+Or1hhf/ufGfuI57MIU+Tp2mg+1XS59DeQKd+ytdxkSUa5Gsifs23SrwmEZkYD
	 l4udximR2n7lR20ggueqeKZfIF4UxAN5Dk2dQrjtel5muuxwNY/RJERqMzQLtq3MiLaXcabkQBYx
	 mmPE7Dcft5ZnFULTVPLv3wma5ZTJLjKtMAQmb4EPnwUES4n4VHE4YMqveVaZYzjPYXMuHGprmRbD
	 bhJM7TDS6PW/lze2nIz2wpKsRAhREwBMAN0zMCj8wflDzPQzChvrTwKGxNJ/IS7XT0MKjISw0tw4
	 ChZUMe5ssepYVl+ZSQvinsyV6M/w8dXjTSv3B7xXNtlJA2+98nKfMwqpRZ9QidB8jpiRSvxISMfp
	 CPqfz02OlrGJ03ZIfNYWjTF3ckNn7yZzYrkRekPeMBZpCX9D0IZXT8divmThDjHpULHp28GCAE4Y
	 86ujWPwHTYy3Fr80KSFuYR3yGtds9OgsUXEmIz0q9PFeJFrdW0t15XCsKRJBbKtptSJPi9VXYGC6
	 +l47rv0/IcHfyY6bA3RybC+QP7jAxXheS/0DMLyWrGz+p8gkKDpVNchoCkivZg85qb5A2fuVGqnj
	 /zkkAN6UGuYEVZHv7no24xawc7QvIn0Fc9rsBHCwlbIPPmeoSpTyYasVMTDuXCFIQvnVTtfcQmDZ
	 ISn3yXdWGvUzt7BhjYg4JTgNLQ4s8V1mX5l64tbdqtc5Xp6Bd/MLqJZT0HjbsmLfK+IaUAdPNIQz
	 MmIwz3eBwg5XVzsLQRC+W/eHiG/a7ewU4vOH/hcPUZJeiDFpKWqs40qou5YAbmhj0pcuzrYIHtWU
	 AERgm0xZLf7ipyv6a1pXjZEyGi/sE=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Haofeng Li <920484857@qq.com>
To: david@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>
Cc: 13266079573@163.com,
	920484857@qq.com,
	lihaofeng@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm: transhuge-stress: fix potential memory leak on realloc failure
Date: Fri, 12 Sep 2025 18:10:05 +0800
X-OQ-MSGID: <20250912101005.1980065-1-920484857@qq.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <b6f38984-5f89-4a9d-a905-ddcdbd7510a3@redhat.com> 
References: <b6f38984-5f89-4a9d-a905-ddcdbd7510a3@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2EA5E80003
X-Stat-Signature: 3zuchpc74c5pfq9nw3q7sz7h53p479oh
X-Rspam-User: 
X-HE-Tag: 1757671824-621756
X-HE-Meta: U2FsdGVkX1/4O8ZFUi3uhlD0uEz2By0WTWOT1KTAG/nZbTcMPGsxBL8aLshZSNJVEsbmlSXHqfrWY8G7KsSqJYM3Gwg0AVNziK0JFjZJ2Ja9Ri8QmqYX2ydep7nAyL8rR/bruXXhHh9RmaOHE6enfGMUejzs8JVX6Q5nPtyKLKSZMnqx932LHdXVSIlGuvJzBmQL2/8y4nr5oJT9K2GLGQF4qSgoFlCaLKZCTbryWmGAej2bDPF7xYDiOMwCtNU2DZuozUYocgxuOd9h25Eaz+9+ttUGm0VgyHJRdoN6QQBX3u07uF/mEye0MbSFNiFWpcPj26Q1QApy1EZOIKJgm+QEh9tZX0UdnXs04VDHCb57qJcjuHuQV1p8Boihl90A/v0mYdQQTLjCKG1A/m7y2qpEkwAcuZ6uRbNRbzlYm3PmW9nAlgpgkrb7UKMoDX+k0aDX/flOW7KlYo9enVsF6oVEtZdQc7EpFpan+6UKD6kSTejO3/IvOCfjXnOVwaCl05oAzerg5pTxaD9Wa/sNRUusAWH4ROWCKRK33arrNl6l1GHFPLpEVW+2GfVC8GDAZLB9/x2vVNYAmzqumj5AGnPgHOXe9G9ZfLYtfpLy/Nkrlbr2rln2INSr0fQ2ak+f5O2bWZqfly0XwgpPRV+jQ62rcy+Ejhlg4VxEsfjdDHJ/ATeY3aexGhMo3CzmqlGTp24wAt6BPvjQ/siuXcQrPnqRi1XxRqAGQvufpYSjnvCH44HXgfbFcIIu7oodrKmG2/txaiBfWHJFMzkqXt749XOWQ7f5ddyH5G/kwxYj7mkNd71NBJXpGnlsam/EJ1sIPPWPQqduQRaA/oE3o9EmdbzkiP/CKpo88q9u1K4Mxijvsqh/zY0ZUqChUfVALqqvia3FZnYN3zN5JjVfJf4x3rq04q65wr3wsgthMbQC4dU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>
>What do you think happens when a process exits? :)

>Correct! All memory ever allocated to that process gets freed, avoiding 
>any memory leaks.

Thanks for pointing this out. You are absolutely correct that the operating system will reclaim all allocated memory when a process exits, so there is no persistent memory leak in this specific scenario.

I opted to add explicit memory freeing in the error path primarily as a practice for better long-term maintainability:

It ensures correctness if the code structure changes in the future (e.g., becomes part of a longer-running routine).

It maintains consistency with other error paths in the codebase.

It prevents false positives from static analysis tools (like valgrind).

I'm happy to adjust it if you still think it's preferable to remove the free() in this context.

Best regards,
	Haofeng Li


