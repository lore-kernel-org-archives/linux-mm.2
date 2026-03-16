Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B9EF506C4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 12:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C011C6B0255; Mon, 16 Mar 2026 08:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A3C6B0256; Mon, 16 Mar 2026 08:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86F36B0257; Mon, 16 Mar 2026 08:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 990B06B0255
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:52:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BDF914023F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:52:53 +0000 (UTC)
X-FDA: 84551915826.11.AEA5D61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 307D08000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:52:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vcrs3rGl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773665571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsCEz23UsqqpszCq2pWnYF5OJ0GpuQ+J5fuPRPJdx98=;
	b=pFdm2RgDiBL1N4vQqjKS25uJn8OvAGvLnmNCD0BnDBYxHrD1F6BSMx/wo16WZ3g2Pk+o1s
	MeUIeBcdH+J6lQqBlzbNkKVG5VH5MvqgcoDI9bPTKhaTxR7UfzKcOHkE+sodSx7GY+n4Yv
	vppiOE9zGMRDZukvPLKWRcC+o2pSbQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773665571; a=rsa-sha256;
	cv=none;
	b=jEj1YptsWWh/m6v9WAESdmjyU5/n86MK+ew698wXQYKFJdmJG1yM0+wThUDyPJdxeMQCcb
	zwqClp6mJxj9AX6BS1zG1VBitnie1jCBq0KJYXxUWN+RhbBxSiHuLePIP3hlaPFhoUOf8M
	hwCHRle4iziQGD918cs6x2jB5vAr4kg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vcrs3rGl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FE3F438D3;
	Mon, 16 Mar 2026 12:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF10C19421;
	Mon, 16 Mar 2026 12:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773665570;
	bh=QHJW/cOB7E5qVsa0OylJOtPEMwr5/JClrBXUOCd6HyA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vcrs3rGljtgz+6uRkKzzgi9YJ34eJGJE4UoneystBg4vw5b0PJYHMzT72NPoW2yTy
	 w6KMCYc0bUWJPnTDyGzx6HloHUKFI6q1wyOw5OPutqzgsV7OAoNIXvlT5VodIS4cGo
	 0NslFsaev/HKkmOSRGHbZZ2dMf1sJAWuUePVM3dozVuXVVlqP1bOK/UaMYdfTwSCmU
	 qw1G/b05Qd/Zg93M2MM9ROe7wUUrcaeme3UJCOb36J2kceXDRg06zivqlBznbeBn1k
	 vBvZPqyoIc0lI/KnuXgmNE+EXDZ/7O2sPRFjpakg166HBOLJUpm/R/c5svklMi+myy
	 MCA/ytOjIgWPw==
Message-ID: <5b0ba1fd-0c91-430b-b997-4f4e193cb449@kernel.org>
Date: Mon, 16 Mar 2026 13:52:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/mm: document Page Allocation
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Kit Dallege <xaum.io@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net,
 linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20260314152530.100357-1-xaum.io@gmail.com>
 <9b8a1636-ab8a-46ce-98d9-fc68d774e969@lucifer.local>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <9b8a1636-ab8a-46ce-98d9-fc68d774e969@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 307D08000B
X-Stat-Signature: qsya7o4hkk3fmhm56ebij8otjufzqoee
X-Rspam-User: 
X-HE-Tag: 1773665570-654177
X-HE-Meta: U2FsdGVkX1/BG+5opouudXaC9NY64mgFP4W4yG30j3U9c0S5rym72MnU4CHX4R5NjsfrpcJoxLvEZrrDtI+ku8dF88pLNyEItWCn5fmoGv1dw003DoOvcidywEP0IOQDIWMjfzw6d1GtmhKdLuUWSpCaYz1bxW5eJ6ogYJhqYHz0iHzkO4umxcKKjSjVF9qpUoh0qEKGPvFRZ9DbLuYIFhoTqIlq7Sbmc0ZZ4PBcoUK1GUrap7QIbz56SeMAeHhH0D22XoU490wIEiMjduz3P1XGHb+j0Y5fgawsIZkKLEelMoE6HXPXW303WhMjSfZv53Jn8pluLMMABoXY3t6fzgeriArgM/d5aQKAkUnhNlRbsrK3tI2fcwCyq3ObqB/UR8LhFfmoqJe4y4KBqum1+NNtOODKNgEkA1mUZ/hPmCcSMIBRaz8GMv+VhwkvjcI1xTdbYldpIGZ/eQFtdyPBRW90ZDvHIDPWZdPZIjUALN+cuemZK8TuvgICVdiVd1Xk/aXyP/Akfw1TY8w6kHlKKMRghB263dNs0l3HPHR0/HpIZ7DOGTqc63PEnwhcnkpJfepMzOnUbYPIA49BkzBW+HgFcjdJM1Zobzi+R3vtF/mq2sOBCsC+q6YQVWAAbYW0HR/Luv94+ZWUkzqkztisHLcpn1VrVQcYM1n2mW7vyzXoWpN40D6sKtAL4XdaT1cUi9McudUrI9KQUj8HEzEWBxtxYYN84hxGghq0aw1QkdSOxZAhq9sLhy0ADeWgl750N+giIZBjQgu8oY7fc9zOn8gFuPlQx53uggyBsIXKSitbtHwUow/vJaR2oA8EGI9mhhnXnzfWP2s0VuDCDZmhXLaiVdt80mO1K8n4L2KqFesz3TzQGdkkzE2/iA1ZUBs7GUOzcykR1tTSpmZhhjKHR8OAu1qisehu3NDzV8rKPR0UGNOIC/n++t+Ab30ToQIBNH/eiAAijh1utV/6kLR
 hKf9wGZR
 KE8RUVY2J62jlt/QtBNenx0B2jWnZIF44WA2Hh/t0ctLC8GYgMuEmYoAF9UcIQ/iaF7aFWte7zHVE4TXJ+absXJvTZtmu2qvgggT3MuC7sS6qLW/Nw4U6GJWj+niUk50SVYYnAUV/7DqRXjZv3Gyh6z9vEw61QNKG7vWgeYOoxrx1fd2ijHDcGpeJVyvlO5liOnGc1MzvgMMf6bbAKFqNqFpHCAy5iWgNl54DDwJLKEzxTkEtE+eSQ7ADNcpLDcvLvLxVF9YsymopwCuuQS9ChrEZDjUUt5pF3zzRysyVLgZHpYPW1QOOzvumjAe9wGgl7YWg5BloqlZ3eLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/15/26 21:36, Lorenzo Stoakes (Oracle) wrote:
> NAK.
> 
> Because AI slop obviously, please don't send this kind of stuff.
> 
> This time I will +cc the page alloc maintainer for you, who I am sure will
> be overjoyed by this...

Thanks, Lorenzo. Indeed I don't think this is useful addition and agree with
your NAK.



