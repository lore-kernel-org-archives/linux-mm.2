Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649D5D74EE7
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5E16B0506; Fri, 23 Jan 2026 10:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7DD76B0508; Fri, 23 Jan 2026 10:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89A36B0509; Fri, 23 Jan 2026 10:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9930F6B0506
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:37:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D9B6D3048
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:37:42 +0000 (UTC)
X-FDA: 84363633564.12.AA23531
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9592A1A000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:37:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sWBgR98M;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769182660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kjw09E3Y4DxrDCasFPnw8kJMJ50QfuWLtnGERlUZ3z8=;
	b=0xUw8p5S/vSNOSfIxR0E1pNN+nLeAkklji1f68eUcKnUF9ymSzN6zu/h8jEqUaTA19T3sg
	5ALS6ohF0/srOnTgT0WL1mZno2iZVAStowxsTUI8mMp+lLeyc/jBz7twdSnLJjiiJePG6E
	3a9Vi4LsZ4Pj4H9vi3iXCBCKmgc2DVU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sWBgR98M;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769182660; a=rsa-sha256;
	cv=none;
	b=e1pFZDBYT0FtPlgvyvJ2vQzTcDBFpzLe148+8/M+7fiOHPAard7T3Dhp75ih3hBBj2Y5jj
	IhGNdHks6o+eIDpRhS4FUidcdC/QJSRXeWmXzdUUleYpO4YLv/vvGHIBOjif8I90gQEnp0
	/zpGsXXp6UmlL2oOQ7qjfke/az6E0e8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE953600C3;
	Fri, 23 Jan 2026 15:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18917C4CEF1;
	Fri, 23 Jan 2026 15:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769182659;
	bh=ALA8Iqxg2vHmVol5d2QOlDr2cJHk+iqHw1IwBAKQ4tQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sWBgR98MV3+VI1p/UnbuBRi0vAtcUaWfI0R3eBgDTMwbtxSMTNZeEpnaeC7uMIJjW
	 yhL0ESUS+hPY/SrwFnZ0swoL6+f4elJJtEr4Bipx8QrX4YT4Kd4mYWhjlzBwyp7zuY
	 wd36g3IJOYnKRHY790k+r3SQ/XCYJUTis1vnCw2g=
Date: Fri, 23 Jan 2026 07:37:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, David Hildenbrand <david@kernel.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH V3 2/5] mm/khugepaged: count small VMAs towards scan
 limit
Message-Id: <20260123073738.76b9e59521270e45eae70f88@linux-foundation.org>
In-Reply-To: <836669ac-473f-4c30-a368-c05bfa86c306@amd.com>
References: <20260118192253.9263-4-shivankg@amd.com>
	<20260118192253.9263-8-shivankg@amd.com>
	<829b62c8-e3eb-485f-8d7b-01419c841cc8@arm.com>
	<d9d569cc-127c-41f8-b16d-d6e11ba7b43a@linux.dev>
	<7193b89e-ac2d-47c9-8fa5-68e35c57d4b6@amd.com>
	<836669ac-473f-4c30-a368-c05bfa86c306@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nca79smoynh5neubi8ip7edkhke1eofh
X-Rspamd-Queue-Id: 9592A1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769182660-49196
X-HE-Meta: U2FsdGVkX1++pORLwl1IOiEO5gJOo6DEck8QoF/b51Dy8Z9TxGvxJFiNC8icdsLi9YIkaNB8vH9kzmUIigIlgvzBi4KI8crElkfjO3xd1U4k+MHm9QGHcwX+cNT40f/caM0PtBtiXj2uaITdCewyQIdCNJGyHdG3CLltVYbx5lUC02EOt6/yBhBQ7z1zxwkOM0BtVDCYlSkVFT194WlKKcR4GIUFF6lwREhbYEAscG3ZVluH7oOWIEhbWEMzcDAiH9mRD3VaZEWu7+1uctpJhSElNEFWfnScsOEBa4eOXagz4ezzumVb3Ddkop6+C8BZEqmVn4FuLR729gQ7MQfquUwdJ7eAHIRtxoRmKJHgscmyf/Dct+8UCQLoNTY/VmM4i0cIsGBzCu1pAg6bBWH2QWybVXYGNknVk2DIdemEBULs1s5EvkNiw2mubtiayKBHhzmWvNaezbLkDXQBX1qUlYLaxGaOQiB1acJpPTZA3+zw/ZU5OLYsBn4pkDyjVWh6E3uGNJL0Vi+dp69HH1RW+EKzTWHmZq+pFutOUFnEajEVkYpO6zSXUp3odHiko5wf38DzWO04UWC4K2hE35VLzd9dLkK/2mBzU088rAMuVgnqqDUqBaRR3CbZQ/W8DgyUF76rJG/Yh8fOQ1l4qZ3v/aSzH6TAkJ3WvtkIWldWVA6EugmgbVlIBkaZ56bSlujDBZO8W/KZ/mdg0pILnxgvzLeLjCf1wftkS5e2LxIPUS5R2eBfnY9oapjVc93F4EpR3SvjkCYGcS5EYPTdDqifRiFmTgvPQ+gL1WSd9dMeJKBJigVw1D69UaVFt1svyqDmsJ7755KMt7AaMGHy3fLCRdRwwjvH8Dk5sOxdn737etY5FZJm5pql+aqkAtsEr9Gw4s/hZtdLgSecG5zaPMuq+qebfdlcJq0srigwWjlJWUdz/IbVXEai+YcH9gGUkvNXhulEf6HimvZXpVFYm8c
 x18kN0Mo
 TdHRk0JegBQZDx55GkF11hRvXlrmXFCV0E0JMubPlmYDK2T/yqmgwVQ7nQHNduEg6rkHsTeKiMRciSu7IzvJ4/xcd47UZFGUa4V/6Vs2E6Q/0XegHFRsbscRzqw5tTbBp4Bpj2p4lLpbQnor+MQwdxAWoAMXoNB6FWurRz02bieX6dI+CItqL/UhCusYZj84SFmE0gn0txKDKFTSEF/qBBtMc6+nIvWK3Mo2dOCbg/CKkM6xvtdqOLHOmNfAeb9q4q5gNWc4JCcajI+7gMEbm4yoN/c/3CNgml2NKg221+iBuUyf2aJMsnC5hH5kCH9YsnYa+XW4TPfO+iljLxH0Ec2luks86SP8FZRUMOH/09PsdhoZ7RydIlr6Ln5Py5+Hafli4U7WStBKiy39v1LhREwkF3YBpnEHBdDJKYG9myPC1SJUSHNIG1FYkcE9HsPf2vo8sBScGIgORt3ydSpvSJG8eAbMOuUFmo6Qb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 23 Jan 2026 16:12:07 +0530 "Garg, Shivank" <shivankg@amd.com> wrote:

> >> I was worrying about a case that doesn't actually happen.
> >>
> > You're right, thp_vma_allowable_order() is taking care of this, making 
> > hend <= hstart check redundant.
> > 
> > Thank you for catching this.
> > 
> > I'll drop this change and send revision keeping only the unsigned int type 
> > change for 'progress'.
> > 
> 
> Hi Andrew,
> 
> Please drop this patch.

thud.

> As Dev and Lance noted that the hend <= hstart handling check is redundant.
> 
> The 'progress' variable to unsigned int is not critical either.

OK.

Were you thinking of adopting Dev's suggestion? 
https://lkml.kernel.org/r/6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com.

If so, let's defer until the next cycle, please.  Now is the time to be
focusing on stabilization, test, finishing up review, etc.


