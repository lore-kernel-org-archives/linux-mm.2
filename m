Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352A5CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBF16B008A; Thu, 25 Jun 2026 08:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2C86B0093; Thu, 25 Jun 2026 08:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0C16B0095; Thu, 25 Jun 2026 08:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2A3B6B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:53:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25A121A0672
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:53:25 +0000 (UTC)
X-FDA: 84918425970.07.BB8802B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD21040005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:53:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BfTacltp;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782392003;
	b=Waf1Gu8p7XbhlHyw7OanzlNF0HeKuQMHfa0+vGJYGQ9BmMNDSQsKEFPdL+SnWAQ75TsSBb
	jhZ5+pbJ5S7G18LPBTJd7ZvzG6VMluyLH18Uvi8qn5SzkV+KERgnOFGs/S6Ss8OseHW4yb
	9dB8pzre1ofYn4UjU+hCS1D26CgQZgs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782392003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZDw2s9zWCThga9eYDfaH2QZEXuAsHn0UQSlAmnIq8U=;
	b=yQd8gisuHqorsS58OK4VI5YcfOtyBg7VC8Ze2I/e8TbWfuZQ8BZy6UrqsMLptRrt4g2/RP
	f0b3GIKFQhuFt+76ETF6n6yAcl+aMxmr9YVqs0vQIrvrRlx75I//RXEiMDU1crrNC9I1M9
	2g/6A/dpwJAe9p8BYvAhOXpZW/jRGRY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BfTacltp;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZZDw2s9zWCThga9eYDfaH2QZEXuAsHn0UQSlAmnIq8U=; b=BfTacltpBMagNVXRF/YTZVepiI
	EavhoY9X0cCWU1/Ern/Te8gkPdpP+fPcwzA4UWpCp0kGH3Vkvpg6sfAOwMU6wVF68ZP3IeFbwVdq6
	T/yvy+eYqEvt+t5bGGHuvREHF3FdEWV0fgxFHruRvO1tcb8uRJv6JM+luAG5l61/JrVSZjVocjsTc
	XXVkjOKCmNWlCxEU9aEfJLTJi0qcwqMBMDooDovRcR6A00yO4qn3aH4+gk8Epa+DIpd8kQ5X6lbro
	KZJgcp3JxrEx/nNvlyzGth65EEQVG0yk7aIpeSqwGO/S4Qu0DqUshLPfCg2pw97blOUZA3bnyse0o
	SXs1WN6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcjZz-00000009uyF-1S8Y;
	Thu, 25 Jun 2026 12:53:15 +0000
Date: Thu, 25 Jun 2026 13:53:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
Message-ID: <aj0ku26XNT7Xc8x9@casper.infradead.org>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
 <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
 <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com>
 <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
 <CAKEwX=MedyK8aDM=oe=Hbzo77mJOEp0Pmo0u8N4HhvikosVbSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=MedyK8aDM=oe=Hbzo77mJOEp0Pmo0u8N4HhvikosVbSw@mail.gmail.com>
X-Stat-Signature: hk9jgid6kfzq7x7trfbf8kpi9ixokczr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD21040005
X-HE-Tag: 1782392002-398206
X-HE-Meta: U2FsdGVkX1+M3SB7gZerMB87Td0fj+gnIIHLMXINM4NG+1d1INyr2h4F+7OWpIgoFx9KXgXNPiuVAX76wNu2bxk4oa0EmY1MIv+34sFP4q2jkTkeuh0Ec4IqhF0TCGlAPZWLcZx71qZ5okI2dcbNQPCQ8YahzmV98c72YrPiqZLlGof6eoYDXvXP1FCWiv41gVOUcpQEbxoxyuj23oeRjagtRuFw203dx8rTSmyi4sm+dVbFWz1jzq8lpOOi3iuBO7PUo7Vk+50sfGjNkZXaqqg+TbrCZZIywdXrcUXV7ASYGsxMbJNhNVSBDTm92Va3K0ma6m+N2zo/uHmJXE4vYdTdq2e/asqCHwHmnS/Ol3soxOEXOQUfN9PNiIU2OjBA8AznIYjhODN2VYgH9WTCkBUuysDeZY+HUxhA7VQ9JnHPCb7vTZbBrJgwjkSpeM+m2RlVrnMbPe5j7z3lOoCHV3LtkO+08Qg+nganWEtBoxCUvryKdg0y3NhIugutzCN42N5dXP3wXjxDfkDtnSm82uYuW5pAI4Zqf5bWk2U/J8CAj6IXVZgA8mDxKe6MzW6phZmSi1rX5xrBqv4qR/Ee0JLfqefleMZNnJzYH4ZYg1cULRCrFoJnExKhGJMetO/FmohIfvHUxOoG9roQJvx9mFbxNea5iGvoLuwksk8Drcgvwc1uDg1uqN/xrCF4XpldZXQGLnTswsXsw4Ll9Wq8NNHggdkp3WUFFYrB0b9Y+Lx5UK8ont1cfxgOAL33edDF8wXIY5vMM4jvlpRPgxJR+KtBHFsYDx2CIdvYMBw8xEfkmFgsNeLDVgpSMqQKARpJO6bttpHsfvxkKM4BMcdjZ47Im18p0OEKFh1dviHB03fw0+HwarBY0CszHMrJvW41N6kEf7U+sS60hj6ikj080ddwfDlTE7U8JFcM3vwi2qCagSwncrFdFNiEFWh3Js4CAix007HU0J1d1NTcRiq
 6yR/33D6
 D+M+Hk7RYGf/nJTN9LkKhZ7OCif93XJwJySA8POMIlOWINESvce5wIS6R4Thx3DHvzhozTv12TP63Sen4+WJyRKf6Mvj9uH+92kTyXUGpdKJNrzMGKT9D/IWW85VAhcLrATb/t48oCDNf529M/HmA8ZUSdM14r6cyoi48zBGwpFmMBD29MaRv+8nJRbGUDLm94a/ks7F1JUFsJigSi3WDWQLlhzZSEtEM8jKnRJUEaHkrAt8yfMy+RUDsKSV1YmjoZM0qr2OhxUsDzauBpTLgn7Waow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 12:06:54PM -0700, Nhat Pham wrote:
> I'm more concerned with undocumented/unexpected behavior (error type
> in this case). -EIO was an example that I saw in ovl_real_file()
> itself, but I'm not familiar enough with overlayfs to know if that's
> the extent of it.
> 
> But I'm OK with just updating the documentation with a simple note
> that other error maybe propagated from the underlying fs, if no one
> else thinks it's a problem :)

That's ALWAYS true.  POSIX even says so explicitly in section 2.3:

  Implementations may support additional errors not included in this list,
  may generate errors included in this list under circumstances other
  than those described here, or may contain extensions or limitations
  that prevent some errors from occurring.

We don't generally bother to document that pretty much every syscall may
return -ENOMEM if it can't allocate memory.  That's just ... expected.
open(2) documents the possibility, but read(2) doesn't.  I think it's
the same for EIO.  Any operation which accesses storage can return -EIO.

