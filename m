Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007A4F531C0
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA226B0089; Mon, 13 Apr 2026 14:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28ACC6B00A3; Mon, 13 Apr 2026 14:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1799D6B00A4; Mon, 13 Apr 2026 14:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06B946B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:35:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5B2257AC7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:35:14 +0000 (UTC)
X-FDA: 84654384948.15.156197A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0424240002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:35:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hSqxz1wq;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776105313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emS9h9SsHUsj8hR6Z4Z7761tXh2GMkn98Pw5sqBFMdk=;
	b=UWJXLiv/sSH6LehUxH6XBt2aCISmVZrlH2RJkSKbqxX/gxdsct/iELUv20KUjhdlxN4OCI
	0cOjgyJuN7UwYi0Soc2EneXWEOYo9HTv7oueG/djeG410ZnmErmtrjw6qlaDkJDGq6tsej
	t0fe9G180e2eVdY/X813nNmJdAHfEGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776105313; a=rsa-sha256;
	cv=none;
	b=8Z3OHSPozEPH77pGwUWkb020sCF/b65Y2WOKSNdmoWjHrl49LDoQm3ebbuBi4sdwwK65Bb
	Srx/uq/BZDliOfgxnuNtTzkuQpNG+H940Ws5syjJzWhsSJmQtaXX28CeDEMIRNW7G3SQ9K
	EnzqOTuvWiST33LY7p7amwOLaPfCdF8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hSqxz1wq;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6562B6183C;
	Mon, 13 Apr 2026 18:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90406C2BCAF;
	Mon, 13 Apr 2026 18:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776105312;
	bh=QlkC+Nb3eufRhvEx7dHbKvueJitX1g7CjlX7z9V2ABs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hSqxz1wqjzil05kMy/UZtG69pcoMl5JhqTFqv2BL6HlY42Gopl08qfZLvt7OIHZT5
	 jxGGq5iDz7HgHk4T4ssMVg6C4tlCDyWu9Q/fTjmfpXdGiXXkxkkDG8Rwnpzu92rEW/
	 wsIL4kt3XSvaMABjYTlARUO3gWB40dTSk7vyYoq05XMXg5WgJjgYgEDMVAo6Eizw/O
	 1TqrpsbRExmEIJP1Oi97IRLvGOsqoTo9BnJeLZZOYFbVx5I0s/0ra4112T34uzOnom
	 5ocYASrGBqDefYJy2Z293syYv5sVu9wyEXJWId5VPR2+i/igTHfY04gWAnDyqayqTJ
	 tWerozM0ER2Gw==
Message-ID: <2f092c37-95b3-4206-9866-f844273ed1bd@kernel.org>
Date: Mon, 13 Apr 2026 20:35:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on
 memory hotplug error
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-2-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260405125240.2558577-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ikj39ewc9wwp6mt4io5ppmmtjsik1ajt
X-Rspamd-Queue-Id: 0424240002
X-Rspam-User: 
X-HE-Tag: 1776105312-618886
X-HE-Meta: U2FsdGVkX19EftobRnYjBBM5vVZWfKozxepz63UlAEx7PdvUldM2tdnjwbHHQz1VGeYLtmpIDqt8VAQV99xdsuSFuWiNsNpOSHlkOR8qpBxdegek0H4jBL1rRSIif9RHZoCk7iRE6j5FqjD+REiVWi++JwyWFGUwNSIotDbx4ostfVMtHItiZAe5H+5LvhHodcBL/MyXtoHvQetcNP3RrGBDx8qyUJqbN+ND3Q2BBqKpN6qjsxEkNLxNXnlCd+RoRV68vvmBgaejR8OKZ5UJhmYV7yeeNyVHZ557FkRPO7oVUs7SIXzs1hriTe46uG3nAMjEm7X/w05mtdqW7eaLdSJYlJogertkdYWb9hTLTbP+ZqnJlR9FkJNqnfTaG9pTzO5pXcYGCO3o1BxupcLKGID8hqJjW3uXbwuk/VRRUSJyn8ycqMOEPHec0i9/yVRBCBZcbk2xAUB9fG9TkySoSwYEHEOnX7PqfNYtYpQxQx+/dZv4nVfR4UvAXcAZNfCVQnxWoOND1yWdMT7CJQsywGef1RYI81//lhUVChkQWFLbJP5lJXCUOdEeQDgABDVsu71lw+S80qFEaqw4kqaNhj8ZhsmXLgmepxcjEIpsYrG8YPGJU63AWIwQiog89YVmRCIOS4514X541FIt3A1Ac4sVzCDARqEHBg4l0XNRG1TrHpofTg3vy7rnSpkzWw/YBVJZmfMN+bvGuG0eFLlAH950Qw613KAQ7FxKiK4YsHJSieCLyyxQIcpGc0yftRmIquFN4+icISnZzje2yCsH7uyCUHgUXWn7nFOEv8ceI3BzXjxWI3tl6xBW+A7nmj4wqLo/Eqa89193fOscemdhrPsPC36gv3q44+8QnHsGny07jhAdp60Q0x5SWdHOextztbmHle1WkuB4FFBoHiaOZA0iaHu31/+HS9qxi/zCJlkMmExTbYz/PYETaiQylaZ7FkCOs7YstP81P79PTVu
 La1b1iOk
 ZogUBxkK5dRCr7lDVMMXdodGy7ZLSL71QEUStxp2Rv9Z4oKpdDBG+hyLlQYZZ6a9wQ201wDo0MPDgF3bQNlZWel5+RviyfLt899vDCFfEHo8ok01o0qzhv7Zij1zAxRrRLQrV0hhQHzl5UeLWat7+uQDDvq2RdcZ2yYfpskB9pTBPTxHDpkbsJyVLVMYJkCD0Py3xSRnEchJzvS+vwmyzpdbxvdWSvk/xvErofPVy2LiCjMnnurFvmoZf9OpmLdKOvURjzDpBqwKZwbA3bASWujo93g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/5/26 14:51, Muchun Song wrote:
> In section_activate(), if populate_section_memmap() fails, the error
> handling path calls section_deactivate() to roll back the state. This
> approach introduces an accounting imbalance.
> 
> Since the commit c3576889d87b ("mm: fix accounting of memmap pages"),
> memmap pages are accounted for only after populate_section_memmap()
> succeeds. However, section_deactivate() unconditionally decrements the
> vmemmap account. Consequently, a failure in populate_section_memmap()
> leads to a negative offset (underflow) in the system's vmemmap tracking.
> 
> We can fix this by ensuring that the vmemmap accounting is incremented
> immediately before checking for the success of populate_section_memmap().
> If populate_section_memmap() fails, the subsequent call to
> section_deactivate() will decrement the accounting, perfectly offsetting
> the increment and maintaining balance.
> 
> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Can you send the revised fix separately, please?

AI review flagged that recently on one of my series that touched the
code, thanks for taking it off my todo list :)

-- 
Cheers,

David

