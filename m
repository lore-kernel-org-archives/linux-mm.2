Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24CEC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4757D8E0002; Thu,  7 Aug 2025 15:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424A68E0001; Thu,  7 Aug 2025 15:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A498E0002; Thu,  7 Aug 2025 15:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286108E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:51:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E31221A0C00
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:51:11 +0000 (UTC)
X-FDA: 83751005142.12.56FAFDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 52F5D4000F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:51:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tZsfzoeH;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754596270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxLijN10hZcIN/wNykeGDwEBCrh6TDStkv5AlX5xono=;
	b=ZiXIqmm8sWEw24dAIKZVBMkwZbA/3Wh/TSdoyoSzqgvSNh7NdSLrr8WJcnNems0pqdRN9x
	6WQjx8/H87JTJaDaUi1wBEL77YwrRunqCstL0a01oRZDGtxs2dQzavbzS25v/37H6xijtu
	h34GoHdO2kka1snTJ4rMgWheiSS66lk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754596270; a=rsa-sha256;
	cv=none;
	b=hCJ7GsYpJtd3HS0wlBWkqq5azdYMik/RdWLJ8QOJxgJstmJSQ4K1slL52I2UQAsSZqIllN
	cX+prVdm6Ia1ifHhn6ALgbvC6orwOY63gr/KHrVtYwoKHX/dRb2dQ+VNXkDzPLWnQMjDUe
	viRuKqg166drCkYFsXLoxDPhSDCeBew=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tZsfzoeH;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B35E600B0;
	Thu,  7 Aug 2025 19:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79747C4CEEB;
	Thu,  7 Aug 2025 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754596268;
	bh=smOPrnKQVzz1Nb6jzpFDay11u+YhZ6AU1L30Dn5yflY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tZsfzoeHrQSWBcuqqrRByFUrNh3Q527uhDK+tAixACbLioF69+YAmEYtzyXu268jG
	 GxpKVLgwWJ6zShg8FRJl6fxfAL2IHFCd3O9ANMQd0A6CYD8QqB8lbV6FEwG8gZuWny
	 giqu6Yk2RykWnp+uUOAxt41yDhxfxznVYtkt+lcUGjDNltZQaIHDQ8kwtzShOUQ/i7
	 XRjzvoITgXHQVAtbvtGa9aZcwqcgUyW8fOaVtqSlZUJgq7dcF/ko/DiseMvp+DFYtv
	 Gwyo8gVFcGqb95QM3n6Jgqaj2TkKcz3dFJCwMskGnSbvqg2TQbvLeoAFKSS9UwLkDT
	 6md7AvIf7WLUw==
Date: Thu, 7 Aug 2025 15:51:06 -0400
From: Sasha Levin <sashal@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
	aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
Message-ID: <aJUDqqjCycGDn1Wg@lappy>
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com>
 <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com>
 <aItjffoR7molh3QF@lappy>
 <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com>
 <aIzAj9xUOPCsmZEG@lappy>
 <593b222e-1a62-475c-9502-76e128d3625d@redhat.com>
 <aIzPPWTaf_88i8-a@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aIzPPWTaf_88i8-a@lappy>
X-Rspamd-Queue-Id: 52F5D4000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: shbhn5u6prcry3i37jpddpnski3egrtg
X-HE-Tag: 1754596270-43077
X-HE-Meta: U2FsdGVkX1/0kgMFgJt1/nca9wc+lycxdCnlxca5K/2xMxctQ7QIeOxs4ueheluPT9O9lQgVGLayhQryd1Tr42/UURp0o971Sq9X41n2XgN/HntLMvDKfiD+HzY4l6TXJDuxWoxdB0LRtxT8flfT1r3Am51y9gKuhJz821Su/YlbeMEjv1wSOAw4ePSIwdUHvNklYKTlTRnuS8GQl0BqA2YKIr+fjHhzvF5NdWCYNhhlTCjl9XFrvSW9O4PqwS7EfJwR7JjECRh2mmbuu06w5Z0vKYOltEeLXhtMgl4V3OpLLOB31xJnPBIf7SgEQQXYrbw4784HldBPVfroVnoPMaX/5+b8AMlW1XlA0iXX43KozFIP5CwlDtN0g3RQnPzLD3IjZiUd0BCbodbcXdubpc8HiOlOqCnZC0WpmldQ81CLNu+M8F+RLDsHRHgGDLR2y22Kw9tISI3Cza5a6PgHe/Fa2jnIB7IonmnMoRSZi2Zb3fmfyJtcLict/zTDf87fiTM8tjw2lWgcK6qrggCljNTOg/VYiJgXz++sB24iOmVGNe8DLEx1CYLmbBmI+fH6XnNX5L0SwCrkdZ/AiHpQLMvjl6EzEaFtdxT3O2DKhUAv7AvmSWsi1VqdHnD+XiJSVupXYAmhqx2w9hquYJBrNXvoJODG4KQucCwmgfWSR90Zhe23N0Uvr6XxlYYqJC8rDXRjNSck1wAcvWnivPCVa3jcf+6qBhUAW/a+S35K3U+QKNJwTGqGelqX4bze03etdEE1qbJSTC8GUmy5sGc1uPe21DCExfqUZI/nLRVTqGbtOYCK/SwGqQu6O1pOSopgiZF4KRoX+3tlfFC6ZTPV0Yygk1rQLz9WSgZVu2/494ZOL8s+UXsA/Psw2f+8rkWVRJFvjC3vL0gBy0KQKpCKOfnEX8PckdQUg7pxzP1hDrm43bo3xPslybEJZliNwF/9OUVrHaRLmN/zkUZ0REQ
 +vIjN/Vm
 0F/Y4GXSSIbCMjDGyO6BgZYtVY5HmGY+PHgIdPCmGHiN4vtJeU6VA1cAycx3MsXneFbTWnWxKZuT086abWdWzKL9rPHQZQs0lCfyJocQnZuIQxEfegHYAj6jaoDfqjn90WeSDUnmYW/FccdoGXZ1dsNUDKk7FaanZHZL4i5GP20Y6WcDKX52ks+Nui3MjhTWxBtBhwEe0MYOi1x6+/vWH2xYXTyLQKP9Vnf1a3u7GWRHk9f9Ah2WM3Jja0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 10:29:17AM -0400, Sasha Levin wrote:
>On Fri, Aug 01, 2025 at 04:06:14PM +0200, David Hildenbrand wrote:
>>Sure, if it's prechecked by you no problem.
>
>Yup. Though I definitely learned a thing or two about Coccinelle patches
>during this experiment.

Appologies if it isn't the case, but the two patches were attached to
the previous mail and I suspect they might have been missed :)

-- 
Thanks,
Sasha

