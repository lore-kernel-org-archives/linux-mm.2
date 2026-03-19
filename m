Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA7E108E1E5
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64136B046B; Thu, 19 Mar 2026 06:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AF06B046C; Thu, 19 Mar 2026 06:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77C86B046D; Thu, 19 Mar 2026 06:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9552C6B046B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:53:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D33731604E0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:53:51 +0000 (UTC)
X-FDA: 84562502262.09.FBEB9F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 31A3C180002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:53:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LrycyGjI;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773917630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZBE03XLD2spncFSZ23D98+gs4Ndrmu13TJlOsoJuKA=;
	b=JHvuDK3hPJRsuGV5IIJOTuRoHcUI9KeTw6YQDedYGtctwOpzdOoXOUWhfYj8jOZ+kdIZE+
	G5K1kqFK/ty1g56HquQ7JRtU9BWAXK9/D6v3uvc+rqq9GJRuDEv7fdivDdCZiIAYYuLEAz
	AeScfq8MNYbmLjTZzSdLlUCY7LsIRO4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LrycyGjI;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773917630; a=rsa-sha256;
	cv=none;
	b=oAIHvWs9LbjRIlz81ilX8N6I31EQddRg0NMZup94jm5mWDBA1/IYx7LfPdfS/dMwC9Qo6r
	aUGCRpCi2Z2v/sTxjJlb6qkz5HykRAxNk/PabaYoQ9GXAA2pji1M+4qoFvFMnh2856mDgV
	L8OTzeKEflZp5+TMeqgYH0giqWwnFj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D962D41A6F;
	Thu, 19 Mar 2026 10:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE387C19424;
	Thu, 19 Mar 2026 10:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773917628;
	bh=DZBE03XLD2spncFSZ23D98+gs4Ndrmu13TJlOsoJuKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LrycyGjIrIXcGLNm/T8fl7Sm2eAY6n0zsZM03x18+ptT7Tj1pqAs6M1XkN7BJdwg8
	 sikW82Z2UYBMvm4LM3JSBnrnPeMi8YeYLY+CoFKTnBFA9btphS/KRTcKaNPJbBBMCz
	 yxICtZvdDPnacHXm7OS/wbduxp9+bLVg33syxwOMGTvlXzKvdJezNLJDmtL6tXoPLM
	 1aUGGYcKiv9n1h5I2mFDiC0iotbUYEKVhLs5dH94vNMGqmRtsxXpGHHkXzswa8L3KM
	 ODUB0calS3m01Go2GVeXy75N33tMH1idjeGVAZcID4TR0rfQ1f7ut44THWB9KcY+Oa
	 a2w5+xuMH+/0g==
Date: Thu, 19 Mar 2026 10:53:43 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, riel@surriel.com, sashal@kernel.org, vbabka@kernel.org
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
Message-ID: <999476e7-6a68-453f-95ca-7badae20b617@lucifer.local>
References: <390a3cfa-661d-495e-88ad-eeebf4bc39f7@lucifer.local>
 <20260319011633.1874-1-jiakaiPeanut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319011633.1874-1-jiakaiPeanut@gmail.com>
X-Rspamd-Queue-Id: 31A3C180002
X-Stat-Signature: 9xm5jy11uh9gfmbm1fje4jfacqso73m7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773917629-464622
X-HE-Meta: U2FsdGVkX19nD1JrnN9F6bi2GCLAVUGMIE0c0oMeQJ8YxStn3rGXORM2m81UlPzoRcqmyszutrFU2LVRYiGDpEua/C0NDnFJCYyOT67oJFv4QFeAKz0sY0AN3iKiov6pUyy+JfSfrS4EGMhkN8wtJWoGrfoOG6Jt436kWYLBN9rNxJKMOwkCHtDgVSCFE1IK5Batc5+pRaw9nmMPHvv7jEbf0gw6yv88331oxq8Id/Gdif0aGxt89LPvINVbnyZ3H6oRmHIykRyv+KhzNk1k1+dfTGUmaxE46Zwxhzs0W9W4lCI6Kbpgwop7ZZ/y7qkgmEnGYz67DoGi9rrX53lnVVJacyDFyWjRGc+B3jp1vvMFl2oZWPWKadYFYhR6+BiXouQoYtrUSshVyYyLWWHQcihQxuBE3p3E3eeu0/XeJQh7HJ1HJQBvgYqnA0rSKoXmjqHklMIjz6QBkOWJyMxjOBKWCwh4VlCFJnPI8uPDJBWbg8sPrkCPj2YnZJZ+crTpwERW1nhXsUP2Zoje6uxTWTRrRdwrJFjZOLoiC4lWUQdQ+IM/asvj2cxIgTLlsqoWh+Zn5ZxdN337SVuaXnAvz4Ixp8j7dvGzZp9MB+UzWlObj+r4HeCSTK1jwQpgIJSol6gPsbPMBU/asy+ctrCH//YkuSrHUlHHMtN53IB37hG4GesZFXsE4OvoLgD5A4UzJcMCbk2v2Booy7r4qTIgJmsw7UmJcML7qxDdqbq9D9ksAtcXmiEaRepVdIG6csgMUHMDLQiN65pTjKxlaauvQHmHcibsFULd1A2Vk1q4YpTqZgNk/MKfGCOZcgmIH0y0I22qHKbRNJaCUWktuPitrKkOI9NXfQdsBTepqZC6FquH17CafS/Ck4VkE/1araCV6UiKpJnpgsQwf+vy6uKSbTnIe8ICQhDlx38zCp8ldAIox6PA2EFygKpTqJ0y+/BQQTQ/+X8kUZa0tkclNka
 URTLWtwC
 sYIntkVT2IRzCILnBpRRUPN5lvMbYtcEtSyctVo6vbHMR6GAmbuZOquRXWGDXz8677+FlrHpnQOAhe9P2HC6vCCohTXKARjYyeH23ri2LIwWRsEmHZqODduPPkJX09/HLdYGhZMo9LdPGiO2TN9FhgTWUz/z82pCuG9O3OCOKhxB/GdS+2OXAKMaXx/iBZlnUG0MHCu7gJfR4Ej0nue6mIhXC5QC5AUXjc8N+GFGClQyG+bGeVbj36AJSHggPKGLAdDRcJ26XhO+eCK1J13J6uPMymoUKi8sRlCZZnZeHkqoh+Z2E6GfcD4HQQbjmp+V9foJxmi30PcDjh8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:16:33AM +0800, Jiakai Xu wrote:
> > Fix at
> > https://lore.kernel.org/linux-mm/20260318122632.63404-1-ljs@kernel.org/
>
> Thank you for the quick investigation and fix.
>
> >
> > We like to turn things around quick in mm ;)
> >
> > Could you check to make sure that fixes the issue? If so could you reply to
> > that email with:
> >
> > Tested-by: Jiakai Xu <jiakaipeanut@gmail.com>
>
> I tested the patch on my setup with the reproducer that originally
> triggered the WARNING in unlink_anon_vmas(), and the issue no longer
> reproduces.

Perfect, much appreciated! :)

Thanks again for submitting the bug, it's been very helpful in ensuring this
issue is addressed in an -rc rather than in a released kernel.

>
> Best regards,
> Jiakai

Thanks, Lorenzo

