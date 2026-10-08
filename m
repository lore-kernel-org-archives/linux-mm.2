Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A386CA6011
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2786B008A; Thu,  8 Oct 2026 14:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3635F6B008C; Thu,  8 Oct 2026 14:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0F06B0092; Thu,  8 Oct 2026 14:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07BA16B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:24:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B858A7BB1
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:24:33 +0000 (UTC)
X-FDA: 85300284426.12.18BB981
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 757A3100005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:24:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=c+8EvEU1;
	spf=pass (imf14.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791483872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArtIe0J/YtHNeMIRmnR0Ro+s/jjV/sVKo94Bg+mHdOk=;
	b=bn2e4wx3KwNohhx7AvmuZdzlE19OlQHG50tmrHEahL9BRXv5Eq2HH4u1mZz7S1swEJUTdS
	/nVf0KieGLOsDrW7fonA+Lrq3TuRZjTQ/S/lGPvfitF/06A5Leb2f+I9XHK/0bFHs+iIU3
	PayXuEpbQfZnVSDMlbylGjYwZZI8b9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791483872;
	b=FezUrPDlyHNpBBAjEfCJBHCoQSMTHK26QksScW49sGH1gqR8RMy9GCMCbtR8ETjQ2l0FHf
	aZxa2+TdcagaeHYncmWlyrbRr1pT3Y3qrOEL0f4jaD22Rv39Z3Ph2uUIXir0hMs6OHSDWO
	2+cWZsrBHn3buR4MZ/6N2Qj4Vw5IFwY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=c+8EvEU1;
	spf=pass (imf14.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8D6C140E0481;
	Thu,  8 Oct 2026 18:24:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id sNt0bsNe_ZJp; Thu,  8 Oct 2026 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791483857; bh=ArtIe0J/YtHNeMIRmnR0Ro+s/jjV/sVKo94Bg+mHdOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c+8EvEU16YMPCeKQ5i/icXx+OWIj8TWokrJ8eVHCV6XOUBlfACj8OFY3JBO9mshE9
	 Yfsfs5t62zYmyTZJDIlwEm9OSjw04jQ6qivErFAHOhYSEpB/Kuzx6kACGa6wC/uoJk
	 1AjWyeRSPyiX+kpdmYC7xPhga4NIIOOZ0SmMA4zqT/ouVQbMA1gHvShwasx1UT0f+M
	 IrwsT2t5robKk71D4fkCYVUo+wSrfnz53+Grf6qAUkzFpnVAKTzSu43AlrMBNfLZlc
	 TMBBwupTqB1vGLUJqRmVdsP3X24OPxjwoGZ315q1MNNzYVazWO/h5+ZxOnOUd611eL
	 sTqq8hCpKWioAsUBJXyvNOh6SYPGhqgOAId+sXFW1dmMooVyqjcUykiM601ermDrMG
	 O5aDKek9U5xL/uo9LJv6I8Plu0h7Yzf161HIfaUoATjtpIA6RPoxnmHLgCYE6LhUAq
	 dn388REozKlRwmPhygPxvnIg5H0cbaPEX+6cr9w8OFrf81tlnlynAeuD1CYwohFkUU
	 XNkTIZB7doKd6lhK6DFVgNSHNmpSmBeMHofhQH15ItNDiijgTgjdE3/ULYidRt+HL5
	 7K9banhdUSv2r5zuc0kDqA16n+FzFzalHiKTq/juzAZfAWsizeYg5ymheA2CCC1uwt
	 PvhDM9ERmaye6SWnI5Radwwk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 364F540E00E5;
	Thu,  8 Oct 2026 18:24:01 +0000 (UTC)
Date: Thu, 8 Oct 2026 11:23:56 -0700
From: Borislav Petkov <bp@alien8.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: David Laight <david.laight.linux@gmail.com>,
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>,
	Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
References: <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
X-Rspamd-Queue-Id: 757A3100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: aqwtqjtzeogjdk578axng1oaa4ijk11u
X-HE-Tag: 1791483871-813774
X-HE-Meta: U2FsdGVkX1+R72BkV5hjGnagdPbeKB6bZT5aXFDW8B65pTTCKkMXJRNqXzmwyaaUc5K9VYEbATgyw1d6YB3PBHiAYvza6S2RxvC6F/X0hKQZoVzCm8m9QcmqcVstZZKB6HPatqUKr/ZxkVWD7KorEpwwU3IANvI5eoLiK2gnUfn6vG7Ss9HmvNq84hfEoErMFrTA12snQ4WcBKf2NCbmEflnMBFA/ukDbCK/tW6cV4sLuO/mNsbxCSB+tTtdgSQGx1Fc9TZIz05gFeyCoQyWEirnLgIEfEGWKOxVX4Py9VnzTv39R+pdjWnFWkTtmYljkE/tSWs3JWYvnOFuB9sq0L2t+mqii859851q1phoOlhwHTakkI9X3wVqrr++e9Xw9J7JNvgPEASMo4Zw/yjMeFNxe2D/iLbDrQ87BKMw+ddOg5QdCewrty9cylJJRDxgw7hHyfx7af/nM5rBOEzeSpK1FoVrLt2gTlqatpxMQVgkKka6rM93mrzZuW230lHFLW4vFs3zUu5NjiEeOe+w0sPNuKxNl0CfscnznTsXZ/Xc+Aw10VRptaEpkTsZ3BKQ7MqMTaN9hxOhbEcluyhuudfr+A3+xXJal9fOx3eKfMN4TD7N4V6FSz+EEPjZrSw6JD3g9F5hyJBKSCTGBjoUOKlF5+9U+OZkYyL31oRcmF0FhtQDzK7WxvqyKWONBVZwa08mQrzzXQX9qvJExeu2GOSndbxpEn4szh4PjKiDjRauu2fOwtDB9wLz23scd8HgwH4Sgus1XUgHdtppJB1OTapsBwE/aIAMyHatsk0MxvlJkFLMch3bQz4uudtLAvOJtfShlQNjMQQKnsIQVp0uacU6MkSw+k/Ph5dePMF7x8PChp8DO5PKayuvc3KcdCkvC8/UxuCHuVX6EQNN3Lspckc2aCpQarwKgY092BPDnZ/LnMQbvw/jpO94GMG0RyVgng+nfKxv7iCJDE2N+cw
 7Kl39NdA
 MBFVSrTX+doLqgXtoFFx/4T6TZrdRkSpXXFG6GB+7RPSghmoiSJnmUQWuw7dLo66tLZo5YtVvwfT2JMfi5e+drOZdUVHAXrdA98bP+R3nUfXN2mKEXFjSj9bnM5NQnAomNUwJqaDQrgTqTiWAd0ujM6+uOTdmjW2qcTBY53EsBj7Pc8By3wFxr+QyLC7UMDcxTZf1qBkRqjAgrug2GUVF3TzJld5mT57TqmcGsPjXUt14Ikv/ZVS7BDQ/3yOlD68wh0vnr0zV4/TbCNQmPBm5vDlPlKdIL56XOAudMIKyriYhERlbROkANqnz3xB367Cr+eveb2qUn2QrC+HRjCqIzwzMGlZiUGrZN929wTVz5u5dkNjLR45gueo2VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 02:29:36PM +0200, Nikola Ciprich wrote:
> [11402.940943] BUG: unable to handle page fault for address: ffffffff0c93001c
> [11402.942273] #PF: supervisor read access in kernel mode
> [11402.943629] #PF: error_code(0x0000) - not-present page
> [11402.945025] PGD 6d6f83a067 P4D 6d6f83b067 PUD 0
> [11402.946469] Oops: Oops: 0000 [#1] SMP NOPTI
> [11402.947950] CPU: 23 UID: 0 PID: 704950 Comm: servercare-moni Kdump: loaded Tainted: G            E       6.18.55lb9.01 #1 PREEMPT(voluntary)
> [11402.951254] Tainted: [E]=UNSIGNED_MODULE
> [11402.952913] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 1201 08/25/2023
> [11402.956569] RIP: 0010:__d_lookup_rcu+0x4d/0xe0
> [11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08

What is that kernel?

6.18.55lb9.01

The other machine has a 6.18.20lb9.03-something one.

How can I look at the vmlinux you're running and the sources?

rIP points to:

[11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08
All code
========
   0:   48 8d 04 c2             lea    (%rdx,%rax,8),%rax
   4:   f6 07 02                testb  $0x2,(%rdi)
   7:   0f 85 a0 00 00 00       jne    0xad
   d:   48 8b 10                mov    (%rax),%rdx
  10:   48 89 d0                mov    %rdx,%rax
  13:   48 83 e0 fe             and    $0xfffffffffffffffe,%rax
  17:   48 83 fa 01             cmp    $0x1,%rdx
  1b:   77 0d                   ja     0x2a
  1d:   e9 80 00 00 00          jmp    0xa2
  22:   48 8b 00                mov    (%rax),%rax
  25:   48 85 c0                test   %rax,%rax
  28:   74 78                   je     0xa2
  2a:*  44 8b 58 fc             mov    -0x4(%rax),%r11d         <-- trapping instruction
  2e:   48 39 78 10             cmp    %rdi,0x10(%rax)
  32:   75 ee                   jne    0x22
  34:   48                      rex.W
  35:   83                      .byte 0x83
  36:   78 08                   js     0x40

I need to be able to pinpoint it back to the source.

I asked the last time:

"Just to rule out any other issues which got fixed in the meantime, can you try
mainline Linux and see if you can reproduce your observation with it?

If so, you could share your crash core along with debug kernels yadda yadda so
that I can poke at it.

And before you do, make sure you have the latest BIOS and microcode installed on
that machine.

Also, where can I find full dmesg and /proc/cpuinfo from those machines which
trigger this?"

But still nothing.

Imagine this issue has been fixed upstream but you don't have the fix in your
kernels and we're basically chasing the same thing again...

Sorry, but I have lost my debugging crystal ball which can help me guess what
the machine does. :\

> so we now know this didn't fixed it. however I didn't have tlbi=ipi set, so I'll
> now try this.

That won't help either but if you wanna try it.

> any ideas on this new info?

Yes, see above.

Bottomline is: without sufficient debugging data and up-to-date hardware,
there's not a lot I can do.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

