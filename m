Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00714CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57FED6B0029; Mon, 24 Nov 2025 09:18:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5306E6B002B; Mon, 24 Nov 2025 09:18:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41EBD6B002C; Mon, 24 Nov 2025 09:18:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF3B6B0029
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:18:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC7204ED21
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:18:17 +0000 (UTC)
X-FDA: 84145705434.09.5936277
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0BDCB4000F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:18:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jwY/4Czd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763993896; a=rsa-sha256;
	cv=none;
	b=v/i1A0iGD7a9p2lAxUdStuXxv20NG15iinOENt/wZcwxAZaihFo4/RitSnjngUlFc8Ymtl
	LYmJPpGmjVsZ4eovUs5IsISUb8fvFZhmB3U6/f1pt5k0j8+QgEbzOyuGktU93xeMbwKbrv
	JznctGnBi/GtkdYtIwf2mk3PhXOP7WY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jwY/4Czd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763993896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIVOeLlAMzSzkUicW6ueGU9frfBx2birDEczttcvHHE=;
	b=T9Gc1bou49iv9+ZZDYiMGbA/3Vb9+JfSlFCwkhjuo4T+rzDEyKvdhzGvVPRsbovmOoGATz
	mSnnKEkhlP9BHLBvaFH8wULAVZclV5IobKivw9rOIR5TRd9fPGWSIS7SkZ7I4doMorqJL7
	bKPZ1/drzZG2koxY17arrnImtz+Iu3Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1230D44070;
	Mon, 24 Nov 2025 14:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C2BC4CEF1;
	Mon, 24 Nov 2025 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763993894;
	bh=a/6C0mF2h1YMNLw+DoImoO4DgoQDEX8r5mtUDpbvJqc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jwY/4CzdWYY3yql3el0w+panwPS8eTjG7NM5YCf3L3YhAsy5JwYjh7Es6LPXbY89K
	 UzT72wJIiWxPTXvC40ejjtyyoevI1urf2RHf3q2IQUAdx3ePP+T4aUCoLSuGBW+5t9
	 AyiGGmZu06pHbDaUwcXprsC2/AOzkRIQV4P+9nx22kKeJxYI/6ZX91Ahx+H6MJ6otw
	 r5N1JbHHbfGXrrxqIl8Vle4agRInm92WILAzWl7GR78JqldJ+4Ahy0TaoQXDl+8qyU
	 P/r56C1XkT4MDr3u/nrxsHIOTWIbg9bUxLNNU6+mmG6IXjp3Uu9lJEaRSB+6XeQQRZ
	 piKMF1RKiWZwg==
Message-ID: <53a032d0-a394-4040-ba9b-79610ec4b791@kernel.org>
Date: Mon, 24 Nov 2025 15:18:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/12] x86/xen: use lazy_mmu_state when
 context-switching
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-13-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251124132228.622678-13-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0BDCB4000F
X-Stat-Signature: 9ddbqkttmt3kzf3kj9kwcjzchsoj7xxb
X-Rspam-User: 
X-HE-Tag: 1763993895-421354
X-HE-Meta: U2FsdGVkX1/XW3LLDoyEbyDHebSV9rgjn9mDqunKAPGJhLOfc3AdYX02nbttjZrfs3LBu6zlpam4yOSehNZEmMHcRkbPPc0GMfj18tAuHG3LIYiYSlWv/nHTx6SciPkWZWkoJF0KzMUDJGGWcCYkSeJi+jrxBOSmwzZGlRXIuBWvjVxyByzH/2g2LG1N+unixVMxcfVKXt84TvU+dka2DvvyVMwMtGKP5dSvtJ1oFOLgcxad2CQeXOPMyHT7RrW6agCX1x0G+GdvbMcGYOwmk5JgeChfjAOEi2XWy07FqTiXQ9THiE8MYbgRpfopPlrAGptRTWm/gYJhDVXmUINdg0+2guHmMMv8zoIAB2G3g+HddLDRAadM0wjJMHG7BHeOVp1n/H1eucp/9NYSruu6ncAfmiMSw9I157ZyGFdsWnb/x56O4UbIxznb1+gVi4vgMTw/SF8YGDPAq0+XSKhLPVOdxw7Ri5GiXvfiWPjhU7+cUI6ghNsrHW8rqDpixNVrLjrrcgYFPXL/JOXtYz/L0nyLdAg0vewbuH9GZ2tZpb9MUALUXySmIF7ysBlJZ+kRLSgfsMVeP19+/YLUw7jx//WHPywmxngZCYbj7/8RBxdenGz4Tc4yD4CQIpwS1na6AB7jApIM75euUB8+JzugJK+oj96x92CqThrPdRCO1WGkUmd5pA69g/OSECHUdD5i1YgKRnvnWFoG4NlOJE38mpmaGNDngxefYdJTuGarJjLNjoxmufyLSRkMtfvYJNjYYgvHVEM3z9N+ccozRfDg47tAE0J+boh1hTUvbNd4BzPrjqHXqOyIS1vuKddbSv9ueyJfc14HI1uGrRZeO9D2Cf1hckXncuUWtosxu3j4Th4OFPk6DRjOKOlgGdfb2UUPAwMhxk92PwqOImGxkfxCSoWXr+m5oVwy6PnXUvIPFwMRR8RvtVl9nzmd4RXvazfszm2p5KXxNpIrZ7kmz8E
 oVYLM99w
 /+H3IvF2Makx+eyNf8pKZVyxZq4utkwn5eLF9JAE1qhd8QIg9Jh57d5b3wmmAbxbNCL/3IpNspBE8LRNGdmZfPvp0NHChuq+1S0GRAC+vzZNRVWiecfyJrZij7ekj6zq+9W6oSiBKdEpLvjfZTKVOtnTYBoTeXWpOuyDUrDGeF2siwVcpDuWhC2fmJ51KDaBva/kcVCVbnKZQUZ8M9iJ4aUktEdkN7cjlFOu8CCyah3zQ94m2uHUdtXCVrefo2foZ2ZgpXAvEHRNDP2MBa0XVj2U8POeDgk/CO03mg5C4N0DhXygG6t0nkz4YVAxsURD5hPDLSgzG+pfzOrCbV11g/rF6b+F1pVt+tmG7MafnFpYGGo/5Heyy1NKfjS5e8XBLdnEo6BV3Sz36I8MgxjbYvzPeGOWESkBMo0RzmPuSzMr4R7LjGz0dAasG+i7x7IdS9ylB2qFJ+SC22I0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 14:22, Kevin Brodsky wrote:
> We currently set a TIF flag when scheduling out a task that is in
> lazy MMU mode, in order to restore it when the task is scheduled
> again.
> 
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode in task_struct::lazy_mmu_state. We can therefore check that
> state when switching to the new task, instead of using a separate
> TIF flag.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Nothing jumped at me, hoping for another pair of eyes from the XEN folks

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

