Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFCCEC1EAF
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C386B0005; Thu,  5 Feb 2026 07:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B542E6B0092; Thu,  5 Feb 2026 07:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52A46B0093; Thu,  5 Feb 2026 07:44:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 937486B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:44:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58BCE8BA04
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:44:59 +0000 (UTC)
X-FDA: 84410372718.12.1CC0C57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8DBAA0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:44:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZIywxC8p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770295497; a=rsa-sha256;
	cv=none;
	b=wKAG7AzP/ClNJx/YpOcrNlrWzPRaWxt/Z4P5Mez/nju+YLbhvnQK1mo+1uUYyzHVZeBj5W
	6NWkYy3/Ly8j9RIAvFPismBxG4U3gtbeDrVLfjnWYurfY2AkciUnwIiub/UjeVLdYv8O+c
	/Kum9YQm9sM0sZlSOf0wmECQnFmlcFM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZIywxC8p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770295497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRNsr0ZhxCaezRK2jT/7jmYC74r3gKk48KKbo84A8Ng=;
	b=rTqMChoKEklyiAw0XiMy08ZJ2lwkNP4f2MLgbtqasxmbYCPaLVGm/UQJYQaB1g7XREiu2O
	X6ohvEgZ524H+fdvnEUFUntjeW2NR3dlRDPrTLseabpeOr8KcYuWyMdtVBhaJ3FPqsG0NP
	AEC3h75xFwyYQF3emPSwDq0m83705ew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1168E60122;
	Thu,  5 Feb 2026 12:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B778CC4CEF7;
	Thu,  5 Feb 2026 12:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770295496;
	bh=6z2viMV1SWDnhpxNnpYFLmnQ558uyJWcLNPSjVU+roA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZIywxC8poDqDIIOLSkRytX713fWQYNx3a/6YellyIDVWI19xW80TyLjafG6iLm+EK
	 i34BN7vzkBwKC25WnJ2mKf4WYGqHQpf1kVED24Bpp6reI5GZJBss7029BZudvDDw70
	 Q9p7oLmTnNxihUUngM0tatZwCUvFs+UmQQyDWq/CaZW5ryDMIQtyNg9GuWozPqcvEl
	 UWwgPPjayxHGcGPxWvZosNeymqXoFKyIqvapCPlY1PN2T2jHjWKpD++4uHoPG0/k/7
	 mLDtQ7OsDo7s3W8Xr7WjMC67jgoX/7XL41FrVGfqHRduuwif7/XV9pHUDmg565lo2c
	 kjsLnw56Rmubg==
Message-ID: <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
Date: Thu, 5 Feb 2026 13:44:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
 <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8DBAA0004
X-Stat-Signature: h7xz7ckiwhwqibo5wkt79u3zociyo1or
X-HE-Tag: 1770295497-275043
X-HE-Meta: U2FsdGVkX1/yTTYRlqygP4bKfKrxo90IyGJ3NSM17Co2HCjz+ax8m01wlDKXi2AivbV077f4ozqyPzF7rm3hZqyIkMTM/B7SzdXPrN/m5OjJJG6RPVtvat76DA1O06ILYouv0TOI5ieWuSCt/IXY6ZUZnLUZa0T6g5XBOKaFwE4Pwo6USAaTp2zXWoRCM79Drobuqr8PgYEEBWm0m7mDVmPxrZBj9zs/HvHSXcRDzOjh53+xsJQuhHxlCiessjsxRk8b9Drz1S8qiT1PwC4Gib4Iw5vI2gTAOUuiSNcUd6ALDNf6IugqDQXNRPEsQU4297lo5zo0y6ruuTDbAfxF/hk4W6tVNgOjcX8Dqjrfjn43lk7xBmI2RSweyrqUyuKAEIW2BFUXKgLjBH9Qrf+B1MxCU8yj4W0DCaHJzLCvJBCPptgIDtR1IS5aX2NHcV6/oLnBnnkpWYnsvIfPwgGeHSQW5UkABonyXhhtplOTbG6TpOwJnjMak1ns0FuZnA2ZfXxdJVykzea5XjWLHMBpAl0N7Qp75wFiXN+/DQE7yRI88jIoB4IT7Hc+NhBx8uz818y8P1w1aMVBulx5ZIyGbpWftbOTpHiasN2taLHXdUp+hja76Yl+7lBFQw6+X88aueWNkceMdJUhL0oRWMsnwVin2qU+n+XlJo8tT9p700OKXma1Tp9rrfQmgOdbnkBToE2rmunSGGNey7pn/MMcVbB2bPGzJJOmfv0YXWWYl+MzVn/PUUmT6DDNDd7rjhf1YZSUQU24EDdv2fiFccDtOStGCp1z73XyCpkgnx2b0biv3b7bXtUeuBJ6AlQ+5XPy0Et3hzyd6lT1PcbN+RZCqTu5f+PxtZ5yakGJU9LTMRcfBqj09qwwt0jnLY4u/lP7z5hLAuaN+szKckAP7yAkhcZI25g6L5shQ1XVbqRdSMDkAyYvtw7BmN3y/+MT+Fx5SM/GYnq4FPUuVyroyYD
 lUapsEcE
 rEy0ByTqx9dIT2to1dx9+fU+Lw5HHcfn3Qt1F/Dv6FYDkpstvvvxe6pLiwipGc2c1GIgB6/lK5Ham2xqARLajqtpdd2GkTn9jriCnoP9Tj2f3LLfuvf3kWQTjQzY6zjhvlNbEKEndm789aZYx6f1YcKfxNM2Bnq9MZ7N4OurQ/SDonz2J6d7zoaFzZeME85ytf4c+B/N678PEUVoEgYfcdhXXyKAzgsWw4AYPrnJji65iTVkiX7A25nK0fzKIljMXkbCMYigsqarsIKCy4QujA/4PRf4hgF3TrIX+yAdDtgA9bJ7BPsAC14Z2M6426wf1kYHLXm/bsmWalho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 23:50, Tytus Rogalewski wrote:
> Just had another crash and it is still happening in 6.18.8 . Here is 
> claude output this time as i am lazy :)

I'm lazy and ignore AI slop. :)

[...]

> 
>    Feb 04 21:42:16 pve12 kernel: BUG: unable to handle page fault for 
> address: ff164aee00000000
>    Feb 04 21:42:16 pve12 kernel: #PF: supervisor read access in kernel mode
>    Feb 04 21:42:16 pve12 kernel: #PF: error_code(0x0000) - not-present page
>    Feb 04 21:42:16 pve12 kernel: PGD 4602067 P4D 0
>    Feb 04 21:42:16 pve12 kernel: Oops: Oops: 0000 [#1] SMP NOPTI
>    Feb 04 21:42:16 pve12 kernel: CPU: 125 UID: 0 PID: 783442 Comm: qm 
> Not tainted 6.18.8-pbk #1 PREEMPT(voluntary)
>    Feb 04 21:42:16 pve12 kernel: Hardware name:  TURIN2D24G-2L+/500W/ 
> TURIN2D24G-2L+/500W, BIOS 10.12 11/14/2024
>    Feb 04 21:42:16 pve12 kernel: RIP: 0010:walk_pgd_range+0x6ff/0xbb0
>    Feb 04 21:42:16 pve12 kernel: Code: 08 49 39 dd 0f 84 8c 01 00 00 49 
> 89 de 49 8d 9e 00 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 
> 48 39 f0 49 0f 43 dd <49> f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 
> 45 c0 41 c7 47 20
>    Feb 04 21:42:16 pve12 kernel: RSP: 0018:ff643a4c403439a8 EFLAGS: 00010287
>    Feb 04 21:42:16 pve12 kernel: RAX: 000071afc01fffff RBX: 
> 000071afc0200000 RCX: 0000000000000000
>    Feb 04 21:42:16 pve12 kernel: RDX: 0000000000000000 RSI: 
> 000071afffffffff RDI: 80002fd0000002b7
>    Feb 04 21:42:16 pve12 kernel: RBP: ff643a4c40343a88 R08: 
> 0000000000000080 R09: 0000000000000000
>    Feb 04 21:42:16 pve12 kernel: R10: ffffffffb84588c0 R11: 
> 0000000000000000 R12: ff164aee00000000
>    Feb 04 21:42:16 pve12 kernel: R13: 000071b000000000 R14: 
> 000071afc0000000 R15: ff643a4c40343b08
>    Feb 04 21:42:16 pve12 kernel: FS:  0000767454f93b80(0000) 
> GS:ff161c21bdefe000(0000) knlGS:0000000000000000
>    Feb 04 21:42:16 pve12 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
> 0000000080050033
>    Feb 04 21:42:16 pve12 kernel: CR2: ff164aee00000000 CR3: 
> 00000080dff18005 CR4: 0000000000f71ef0
>    Feb 04 21:42:16 pve12 kernel: PKRU: 55555554
>    Feb 04 21:42:16 pve12 kernel: Call Trace:
>    Feb 04 21:42:16 pve12 kernel:  <TASK>
>    Feb 04 21:42:16 pve12 kernel:  __walk_page_range+0x8e/0x220
>    Feb 04 21:42:16 pve12 kernel:  walk_page_vma+0x92/0xe0
>    Feb 04 21:42:16 pve12 kernel:  smap_gather_stats.part.0+0x8c/0xd0
>    Feb 04 21:42:16 pve12 kernel:  show_smaps_rollup+0x258/0x420
>    Feb 04 21:42:16 pve12 kernel:  seq_read_iter+0x137/0x4c0
>    Feb 04 21:42:16 pve12 kernel:  seq_read+0xf5/0x140
>    Feb 04 21:42:16 pve12 kernel:  vfs_read+0xbb/0x350
>    Feb 04 21:42:16 pve12 kernel:  ksys_read+0x69/0xf0
>    Feb 04 21:42:16 pve12 kernel:  __x64_sys_read+0x19/0x30
>    Feb 04 21:42:16 pve12 kernel:  x64_sys_call+0x2180/0x25a0
>    Feb 04 21:42:16 pve12 kernel:  do_syscall_64+0x80/0xce0
>    Feb 04 21:42:16 pve12 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    Feb 04 21:42:16 pve12 kernel:  </TASK>
>    Feb 04 21:42:16 pve12 kernel: Modules linked in: sctp ip6_udp_tunnel 


Yeah, same thing again.

Can you retry without vfio passthrough to see whether it's triggered by 
that?

vfio recently gained support for installing huge mappings into user page 
tables. I wonder whether it is related to that.

-- 
Cheers,

David

