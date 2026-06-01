Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F86DCD6E61
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 18:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35506B0498; Mon,  1 Jun 2026 14:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CF86B0499; Mon,  1 Jun 2026 14:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A326B049A; Mon,  1 Jun 2026 14:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86D506B0498
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:00:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A9B51C1FEC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:00:44 +0000 (UTC)
X-FDA: 84832109208.12.8E6140B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76157140008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:00:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BP8rvdKJ;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780336842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GiO+rw//gwST3S8z0fflupggAAITCQ2zd32W71wKvY=;
	b=TCzjZGahZ0sJznC40+oehFXnKmleMRy4r8zQo5Q2xI5lyXLQhVMv5BM9WUb2Rw5o7HnBcI
	RMTWtdBKKPmW0fjAoESpQKYrfMHsazIL0dW/zXqceZREGs0T95j5AMSPHRaGgbgDUc8Maj
	3tqCMQcDm40C3JtB7obKie4+Ztpr8eQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BP8rvdKJ;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780336842;
	b=vg8BMNIRHqUBvX8nT34hujTC5bxB9sUkvFfhyflwbzFewHe7QXD0UiskfYgPdwkerQdjgi
	9403hYpL5lWQn5jkAUrwaYxFXZb3QorA57yJYExHdSV8kHqBhK+OKUYLLAkF3bkqS9dl8p
	ZPAZ/Bh77yeSVpwVy+ETjDp76JRs41A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D70F40440;
	Mon,  1 Jun 2026 18:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9801F00893;
	Mon,  1 Jun 2026 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780336841;
	bh=2GiO+rw//gwST3S8z0fflupggAAITCQ2zd32W71wKvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BP8rvdKJPXH9RmlnVdk/08Rel1FtZo5IPta6dYgGI2tomLnnSixvZVV5GiU0i5n7u
	 n9a1aGPosYM99iJvUtWj4DBJiy/4YddMqefRgmFyd5KLyo9MVza0RESWf9UsFbN7Sv
	 5PEPHAjSixgahFqu54jD+su4/43f35UJILGyHxHdpo9jigt3C/Yd3abPqLGO9b31g+
	 VVsKiL1KnmpFLjfh0vlsG1v/n/OTYAH/6RARYUHT1QcOkWAAfNZtrVjWzEURtTZ0xK
	 kZVrRMogXElyiVY/0VrUsA0BNS7B34pnLLA4TTDSiwJommtxlGHI/XOvYGw1rkP3U/
	 5e/CWsAOiaeYA==
Date: Mon, 1 Jun 2026 19:00:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, stable@vger.kernel.org, 
	Sashiko AI review <sashiko-bot@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/6] fs/proc/task_mmu: fix make_uffd_wp_huge_pte()
 prot-update race
Message-ID: <ah3IrXG3aFVgXRpd@lucifer>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-2-kas@kernel.org>
 <ah3EQvQ_Ja6AJqzF@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah3EQvQ_Ja6AJqzF@lucifer>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 76157140008
X-Stat-Signature: 8kryf1tx13s1qi9yxs8bhtsqrohs4nbo
X-Rspam-User: 
X-HE-Tag: 1780336842-90935
X-HE-Meta: U2FsdGVkX1+y+bVJAMiPTDwpdVaQJ6DJUrJ+bL4FLl+OGhqCg48/Q0BBovs9NV0IgY3b3FIK36TA3fb7sblI8/ccTw/SdixKe/iT+C7O9wrE5SmWhZz2YYvMwgzXZD0RRMbaE6bYfbByBJUPTbSfOXUWC+BRztYvA1ZObShiQk+oGQtjt9WqJrLDFlpy10Ffzj44yZIJIV0+vvFl3MXa8BBV4YwTEKwv06vexLZ16zpw5mRqzHPINmFbvG0ilBU11og6cyWqZFLouSBvZP8aCdYJZcpzR/e6xVDPXps2M/0FC63wnes8PKgcd09oDSpXayiTJ8YMmvmnb5PUAtIWL+oBs2elJwlAswiNe6NvQMgagBO9LQCMCIOiZKYW8OcB4o8yULHSeVNWDvQ1xwZnJ85zeJfBXg3ycokT0/LBsy501ehDvc94IQpLWp+HDTXCa2YtB1rlIM/XlNuqOR4bKY6qETuI9npt/m5evgj/yD/zJHZUXYGMI6sd3XmEfo+2tUUoYLRc7fhsCsOocs2YSYxsjZ3IS3QwoUDinx9Yf88Rmmk7xcqAK1zz02DStsU+sG5as1Oy0mo6U2ici2RnVLpG/JmsffNw0KynjHp6MbrxQhpK+sHQ8oY59tG2Cd6+Y5aeqWHDFYiTi6mz2ZVMhmYKXdPb4liaJRBb/D9yinvPDTu3hFGtoFQwM1Tgz+P7fHtqig5RJLLLl2JMmu+wVU5Au7pOHc65DLONZ0DRXpf72lu/sA1psE0y70CF/XEC5Y7q34j5ieIFvSMGbiGbHJUN2kFNyBLWooc/B4nH8Efo2HWtHl7h8nmV6w64WofjYQnhMZSLkp2dH6hkuEXwoXzxfOFI7+uAN6XQ9wvFea3yFdLTdqldgk2GwzZPI2f/8W7wvj8+3Xlj23gBeSq3wvReXDoVL1cD+6goRr63ULvSaxtrKDr/Osj1/78EaqVxo4Hk1XGa7vgBBBINFEI
 yqhd+7Cw
 iLDhikfde8vUtjuh+fW/bwfYjRbBKJYN92+sZ+jNEVFK0VQfEBzHOn74hM63KZ37iKxKriSbH4W+TLa6fE/B+yCPMXbwpntLItinKgYkFEvuvl3SvfvYi889ltBSvOjkpnYQYRctEHTMGPYtHxGrflbWVTYpGfOdbAjZE+8X4lBwqUE2zAiQzbnno+R8dFbr1SPxlvTLCWVSEdLc01y7sgJWJIDQOzMFoCL/H5xxDmzVseR4LPSJjL8JfW/fCJOESms6i5vDsv2UQUCW3WwJCNH1hOrZk5KSMUIFPf+MdNYznqus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 06:55:43PM +0100, Lorenzo Stoakes wrote:
> On Fri, May 29, 2026 at 06:23:25PM +0100, Kiryl Shutsemau (Meta) wrote:
> > Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
>
> I wonder if better as a separate patch? Not sure what Andrew thinks about
> it, I do recall him complaining about separate-hotfixes-as-part-of-a-series :>)

Ahhh it's a series of Fixes: :) ok ignore this then!

Cheers, Lorenzo

