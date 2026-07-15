Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45DFC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 19:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671356B0088; Wed, 15 Jul 2026 15:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6225D6B0092; Wed, 15 Jul 2026 15:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAB36B0093; Wed, 15 Jul 2026 15:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28DA66B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:44:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EFB51202AF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:44:46 +0000 (UTC)
X-FDA: 84992038572.07.374DE76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AADF710000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:44:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OYsaolog;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784144685;
	b=Xddnh8l0+XbuVpAD/Nj4/FRyEMkYqjwln9zvysnw4B7yKa1cJjaZJxtjgEzo/L+Q6hcwgr
	mm5XU4+X/Q028362Laqtp2pTMwnRDJLOQLSQdi8IsXYDsFJitfgwoR24cV9zrvPMora9yq
	XxuGagZsnm4R2L9KHs/LLWe+6h/APEE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OYsaolog;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784144685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0/mafZbbBf1bJ13lpfhUPZQ1nxTKzlYGMmGA2owMTg=;
	b=aAneBQrKDoELRrFNDs0/nzc57SUysJps4lPAvmdDzYTLxGVMWM3TkBoGSYJBBIGMoLEw9I
	HYQGQ7SSjLu+tXV9+nBJmDa+662ju2mNk/WsR3oegLbeG8XSkfzlFYP58uUzmGy/4KDVO+
	4KJC8/Ra31cD37DMRoNxxUu3vdgnSB4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9610E4099C;
	Wed, 15 Jul 2026 19:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8C01F000E9;
	Wed, 15 Jul 2026 19:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784144683;
	bh=d0/mafZbbBf1bJ13lpfhUPZQ1nxTKzlYGMmGA2owMTg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OYsaologzZ08VSMxn//yceDjqqJF6UUIhiwojNlBVnBispIbn+6e/BssVgowDUCgw
	 QXx+9ssErGv1RVjm4ajg+AjS99MXyiQL2dCHU+ENWjavYiM2nlC4oUXB8XzjeewYav
	 55Ysd6gsNPSva3XMIeyD4uuKd2rZXHjxHeHA7YfA=
Date: Wed, 15 Jul 2026 12:44:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, mhocko@kernel.org, ljs@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: promote mapped executable folios after first
 usage
Message-Id: <20260715124442.6002198725f60b2ffece2d97@linux-foundation.org>
In-Reply-To: <0fdd8922-3087-4636-aa5d-27074462fa6d@linux.alibaba.com>
References: <4b921ed528c483e13c9e22d1ae44ba58b4a15b0b.1784096432.git.baolin.wang@linux.alibaba.com>
	<CAGsJ_4x560kU5Qd02rLHAhenx5nzyJ_3ZCWo1XgmWYe6BMrEqg@mail.gmail.com>
	<e62cdd47-4812-401d-8c69-51bd483b37ee@linux.alibaba.com>
	<CAGsJ_4wm=TOq4H3C__WhswDSXCytUt8XC-axnm-=C9DATrQ7kg@mail.gmail.com>
	<CAGsJ_4wvFAJ8efiBUdAVwU-L4iS_t2NsQDWnssmK0UbqbdnM+Q@mail.gmail.com>
	<0fdd8922-3087-4636-aa5d-27074462fa6d@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AADF710000D
X-Stat-Signature: ik8diysho11cedkhdgssd49h16jgjmg1
X-HE-Tag: 1784144684-673641
X-HE-Meta: U2FsdGVkX19GGY8cOLQCvSBbNy+Sh+2EsX2al1GOGdbf1UPk0/3ppsvLxvWc67yfwqrLYyX0HxivzWY9ASuRKxLEzggq0cfKPNIbATPlkjIyojhZvd4fIWnurK3IKCSzj4+AUc0Th2IqcX8IAdH/qwkew0sAB6UcB8HVr89of5hlyixdPbcwH+BDS5dQL1Xdn6toouUPmQo/wf/a1H8G3GzEoeV1EEoJ40aNZTh1xRFnO49TWlypgcS3by5llXZkDEYeJ5vklAGFDwmHnr+oMnQypajbszr4jvD/WWrBEXl5U3wTJIH8lbWoimoCXpLuq/jul0QRCsIXgWGGmZwz2M0X0VXtXuJfLWVfldo5rS2uY8CftQFOCXRHWjPcYlvMx5NZCjf+S5nXZLs3Xes91JmrZzK8j1JC9EI8mXMJzMo3UkxqaEUXNd3jzRt6mp/S/bOPw0iHtRFZHFgvJmtp7yiFKIGSsdq+8XePVIxlMbP8ZLRIsykaaAu4fsO5ocmhE8ui679PwkF01z9DMQ+lI+1xVboAx+Mg+sMAerpmHRNHoYXTJsVUSumdI5JNs1L7F8YqQNQ5poLb3QMTrWns4W+d8tRE95UvmteGIteXHvAZcZWYBh6mHbBiOnWLZEHxWs8TGPb1fXjLR+2LmGFozZr8dPBSErog54sLWuHf+xOjaCmb3+xFP+t4x6YiIYO+MKxEIKrggfzw+heMgkBeMMXCDXcc/h5FnjvemovtUmA03RGpviQqLUJde26KLfqCNhJZvP2wf1fJCrUr6J07/4tgH7pCjHUzvU9YPTCqXNizLUSlk1DCm2jOSe3bfHb+jOVLElpZtVdjUSYQJUuHs6WRhY40BpfKEnd8eG9zBqShMj6H3iSRWmLqwzTW089CfeDwhmKpaMM4ZXxp4zXp1FGVWt1YsBsnb659mGOf8719odzllMDTQKGOGo/SRXSlKt3t+TEt21Isu9BuXpd
 8JE+LvRy
 Lhoqu1/ZLqRilJy0LtrTWw4b7N2tly9byTQOpKr2WcAR10TCIiVkoc12INaAxZtWBmaXC2ZT4RU3bIZjBT4XUmEUEzEcQsXFJaED7n1jFYB7qBTngKxaftCWNmwI1DiAemyXlkuB7WOZPTucIeuOjC4J4li5GPA6djpSwlL0V5WSMsaJEjcv4MF4g4mxFZQqV0NKcwWXS6kx2rCHIPJ3/PMjdy+6K5Pc6OtHfqIX3aO3JGQS0zgyAItdJS7sMcGW4gS8a4Ol3FKMSzGomXx7iGGmARI7B5yTSA3/VOcHlVgWafTLjaRre1qy+OqSndPUyYxNczhC3knjDrjpRA2EzQjUiPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 17:00:19 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> I did a quick test with the same test case on my x86 machine, and I 
> still see an improvement in sys time.
> 
> base			patched
> 1152.249s		993.235s

Nice.  Sashiko asked a thing:
	https://sashiko.dev/#/patchset/4b921ed528c483e13c9e22d1ae44ba58b4a15b0b.1784096432.git.baolin.wang@linux.alibaba.com

