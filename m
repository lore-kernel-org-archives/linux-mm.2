Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CE3CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 08:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1586B0092; Fri,  9 Oct 2026 04:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8EA6B0093; Fri,  9 Oct 2026 04:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF6E6B0095; Fri,  9 Oct 2026 04:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4116B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:00:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B55F1A02A0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:00:48 +0000 (UTC)
X-FDA: 85302341376.07.EED5551
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id B335F4000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:00:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C2zyfPBO;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791532846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tD3nWl07/+Qda8ppzD+w4eeR0FzIMSaHVdIPgbXU21Y=;
	b=uFAP/6gE3kk6bAKRG/jdfH0+P3elcyNJWijt8Ew+Hvf9MUi7UtBZ6iLQHgdoi6LqSZiYgx
	SaWZjBD96U6hPjqboG8IL4KhnnliKyiKzxhSR9kMGsrzcN1xBxF6d4ol2gh8qOHAms9Car
	krjKoeBxVdFEnjiLzl3VSde0R4/WBkg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C2zyfPBO;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791532846;
	b=g2EtBelpkcRFAkSG9Cu4aqCBHST8MZQX3O/1rf5MZPCwk7fzQkYP/pHYsivDUHH0oMhRyU
	MfLmc7AzIpU6BImfYwiqIXmIu/Wjk0uADgQt7pOq5UYhBzEhdmCgDvQhphT+7AOf29CuR7
	lu7BLOvAzyRGT4qK9+ZPX9fqXbugT64=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a180fbeef5so25456375e9.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 01:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791532845; x=1792137645; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tD3nWl07/+Qda8ppzD+w4eeR0FzIMSaHVdIPgbXU21Y=;
        b=C2zyfPBOuuiP5nOcZxyY8wDs738NfN+97HXDxOsJmXPXRe8gd32l0RBXmVmKQ+Q/Zv
         9EE6hLhmHKepPwckYPWYklOjPVRHwpIbZhsSheE0o+V8NVwA0cJY6bP0bGw+j2iHgBNe
         ivMKABTL6BRCiuPXKcCtSuP+PWLxBlHmb1SG75FlMg0CAc43pXYyE4OEaCK2m1Nr16BV
         F0yiJh6XfQgVqPt5AmKZEub6p0WvT7bM1f+0TDS86lpasMFfKOjLqfRTOseEVDhaMb3v
         TyvQZyE537J5h0yTHlaKFIL8AnCyzxvfsl17mLvV4NtDxV90KxCRkRj8ap1NF8CcqRK6
         DvJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791532845; x=1792137645;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tD3nWl07/+Qda8ppzD+w4eeR0FzIMSaHVdIPgbXU21Y=;
        b=dpK013Wb+TCql3JZDDaYM22HhcTSwKJvi63kmjZR1sShLqeCycsHK5V7u1M9y9FOWE
         HoRLxV1yRuOzOBGS7SM/BVv7Rf7gpjbwCVYWWuKVRn5njxJXZZtDcWCOVrjXOBlkeXiF
         lTCG4csCPWIJP/HueKKrwu8rOlWkkTItLWeQIWFFcH2crDxtY+9Jnb/k2amDtjhlA6FQ
         L3zXoFB98gB6H0imT6s5pFT61TXmIs1YQvWQ0idkVjhrPsbSRAykoqoyCXNO/CATa8Ny
         GKgqh2F35wpW4/ii2TPh9uuI8ZjzLVI9ymkvA9oCF8acpefRw6g9Ed+P8bjw8TLNAZK4
         xQ5A==
X-Forwarded-Encrypted: i=1; AKwUvBxVV51xPrCwJHMKPmivhHmf8YQlEPHFY4ADT/D55DDktyTeZchkKVrS1Ya1OJRiNtcoRqDAvqw7+g==@kvack.org
X-Gm-Message-State: AFuF++lIXejr5XzZS9/OEwZplUiLqp3L87aEDkj5wp5SoB7/hCQF2sAP
	ehwGWReKZmzApgSfBm6qz4scz455w+PsX5Sasv7tGHuicigCCfhHVmZE
X-Gm-Gg: AYBFou0lnTLyOKTpmd73TAvzrEG3oYbSJSYOX991gVgmyyPRX2dPNFlCxZ+4PFQMluW
	4GOE1AkmmPmd4oIE4bEszRil1PpFwbu1/JBrtOZqhXLq3IAmCE1miS4YQrJrpxlh1nCdxeGIGH/
	GVMKLnYw4eUbdNBDrXOOzvgUuiyOqq0AjWTKdVuIKVo3snId/C9oMzJCIppeFkYNulVGEacQAy+
	ml9MNy2jG4XbdCM8ICShQspnyU+DN+2wWRZQ8Rgj22TZAV4fZ14NguMGgUd7q/VDWikxfGax0F4
	qI8T87ZeiAoDvZwlwAKJdVzxPTGuET+rnc1Ld+YHX4qmhgjg+NDn80TZrRC7W4/96GcgqpWUruw
	GVLhXFNqcsPoMFbghU3JQ3ARaMDrbq/dwz/r3jkESU7Se053A9Zhg2RFSqp/3JKAq1nQPD0jr6j
	rn8AiI9/yDpuMEyyb9RU0+jLuVw2SpZJi+qsTKa2b8+s+dZ2TqdiE6yllKe8PwTyxj+jT734pHn
	0khU/vZX1x1aMYtYp8+2V2w8AqZuweBaWY=
X-Received: by 2002:a05:600c:19c8:b0:4a1:7bae:d80a with SMTP id 5b1f17b1804b1-4a18e47ad49mr20060925e9.9.1791532844985;
        Fri, 09 Oct 2026 01:00:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm38979805e9.6.2026.10.09.01.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:00:43 -0700 (PDT)
Date: Fri, 9 Oct 2026 09:00:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, Rik van Riel
 <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
 luizcap@redhat.com, pbonzini@redhat.com, Tal Zussman <tz2294@columbia.edu>,
 Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261009090042.39ba9c06@pumpkin>
In-Reply-To: <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
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
	<20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B335F4000A
X-Stat-Signature: bs8i8a9mqcji8rsofbodbom1q1f98xtq
X-HE-Tag: 1791532846-988942
X-HE-Meta: U2FsdGVkX18H7Ntd1Rrltm49sW01fil2lnR7Ay8nKHMStGfcyyBTmxltL2BYn3Imens5i0RC5/T4EB97cDecgSEiW/rSA4LFe/1Yksg/iD6bVPALa/h4CwalVsMVqH/rnBHjt8fDknJuCJMT8l4SJprPJzmWgkMFHLUl58qMDnEAE3y+5njqXxa2Lf+JtOJoLFwXKEEgpZfwVb5QLUoGkc3dMZISnOKu4NF201woFLWYzNwjgNwvllBeyNa0eOaH/E1csbH6JA5U+83APmY5Y/Davoi8zzoAz8TD10BiHrfxl9RKcOq1d1vQY+BTSpQ+Nbi9TMA8hAIH8hSyQnzWxJesF2Di0WZoAr7oJSiA1ecB1bP2Wr2GFyA/NYMVTyaFfGfW/sw+VNP7tD3HM7MEgR4g6+20oEMXCN1NKJj2a9aapKN7BsZSFzHk573MtLjDMJIpFKXMqLMhK7HKkFTE7NCOLWIZ99BQXkq4UYr7ockQniL1zagxmVp2TAyqqGc3SzT12Yp3j5xsBMFqdA31IezWe9sfPzKzWkXb18BGmNpApO3BgKpaGWyMAYSjpJXvVNZTqzfF9jnaOnd+3J8E1zzoraE+mbnEZbTQpOZPeF8H9q1WUpJJDBI/uVB9t5ZtEGOg6CqegLEZ7VMiFzwEo/PJvvwqN+NZnoVtMgeqdF5ZHBkuHji4ag+7gOlTbXfU/g4H4orCNiYjXbpfgD+gPJXtRCBgP3+mHWndoJekXSZ7C4lBq0VBh14qVGFALCSDQZECSHd79qkbi70eFkciF1ZGV0/na2yoH0siFyQ6i8KPq6ts+xF9Bd1CX/dHy8VJrhwOmgxNrWv7+Op779p+Xu6tg3KygqSzKIyOBMsMFc78CTgTmEFOgoO+yU8AudyP+9vAoLTBQputtjdhaK4mZ7trF6Ese3cAoFU2yg5IOw2Og3WQ8L4sQTDCX7nXaZzia7szEkHOvrNaeCKSXaK
 GvNfNkqj
 N6hqgC82nQcJJIeP/+6iMAp4Dycmp/BRRmIz1L/IZ65CC+fHpAEh6eOWykXQthgSrSut+HovnxjV66tpi65o66XfhHA3r7JTb3IhYF1gwn/VvJ3MuX/S0TK3b4zjZdt3Y7U+3CFU/AanoGFGepzQPmh41hAcQqJmI4qpr6gWsz54yqP+ZFgDBf8vCBB8eEHWwjILaBy3tsm3fdYa4HIifVyd2l3XjgqrHzEtMjC301AiYOLmInZAKR5HQK8kfpJHk0eZrIu63qY/CrfuxFDn+Pq3WBjD1M6Vbg7nhcXbxZ+OFBbPUD3tplUWzf7R0JlfXCBlWrRXU3QGVIahffFSYgw577ixXpJ/wlyjasb/UhOA+XVXPDD9LZhOHdbbi80sgnM/hr1CkwOs1b0EfMngYWbkwjdIYTEqLFI4JIOpI8jpzFUNPC+HeicpF9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 8 Oct 2026 11:23:56 -0700
Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Oct 08, 2026 at 02:29:36PM +0200, Nikola Ciprich wrote:
> > [11402.940943] BUG: unable to handle page fault for address: ffffffff0c93001c
> > [11402.942273] #PF: supervisor read access in kernel mode
> > [11402.943629] #PF: error_code(0x0000) - not-present page
> > [11402.945025] PGD 6d6f83a067 P4D 6d6f83b067 PUD 0
> > [11402.946469] Oops: Oops: 0000 [#1] SMP NOPTI
> > [11402.947950] CPU: 23 UID: 0 PID: 704950 Comm: servercare-moni Kdump: loaded Tainted: G            E       6.18.55lb9.01 #1 PREEMPT(voluntary)
> > [11402.951254] Tainted: [E]=UNSIGNED_MODULE
> > [11402.952913] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 1201 08/25/2023
> > [11402.956569] RIP: 0010:__d_lookup_rcu+0x4d/0xe0
> > [11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08  
> 
> What is that kernel?
> 
> 6.18.55lb9.01
> 
> The other machine has a 6.18.20lb9.03-something one.
> 
> How can I look at the vmlinux you're running and the sources?
> 
> rIP points to:
> 
> [11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08
> All code
> ========
>    0:   48 8d 04 c2             lea    (%rdx,%rax,8),%rax
>    4:   f6 07 02                testb  $0x2,(%rdi)
>    7:   0f 85 a0 00 00 00       jne    0xad
>    d:   48 8b 10                mov    (%rax),%rdx
>   10:   48 89 d0                mov    %rdx,%rax
>   13:   48 83 e0 fe             and    $0xfffffffffffffffe,%rax
>   17:   48 83 fa 01             cmp    $0x1,%rdx
>   1b:   77 0d                   ja     0x2a
>   1d:   e9 80 00 00 00          jmp    0xa2

That looks like the same hlist loop top as in the other failure.
IIRC the fault has the error address in both %rax and %rdx which
means the invalid value cane from the top of the hash list, not
from following the linked list.

>   22:   48 8b 00                mov    (%rax),%rax
>   25:   48 85 c0                test   %rax,%rax
>   28:   74 78                   je     0xa2
>   2a:*  44 8b 58 fc             mov    -0x4(%rax),%r11d         <-- trapping instruction
>   2e:   48 39 78 10             cmp    %rdi,0x10(%rax)

That is the hash compare instruction (that fails in the other function).
Not sure why it reads offset -4 first though - the compiler will have
reordered it from after a condition (just to slow the code down!).
I'd guess there is a container_of() lurking.

David

>   32:   75 ee                   jne    0x22
>   34:   48                      rex.W
>   35:   83                      .byte 0x83
>   36:   78 08                   js     0x40
> 
> I need to be able to pinpoint it back to the source.
> 
> I asked the last time:
> 
> "Just to rule out any other issues which got fixed in the meantime, can you try
> mainline Linux and see if you can reproduce your observation with it?
> 
> If so, you could share your crash core along with debug kernels yadda yadda so
> that I can poke at it.
> 
> And before you do, make sure you have the latest BIOS and microcode installed on
> that machine.
> 
> Also, where can I find full dmesg and /proc/cpuinfo from those machines which
> trigger this?"
> 
> But still nothing.
> 
> Imagine this issue has been fixed upstream but you don't have the fix in your
> kernels and we're basically chasing the same thing again...
> 
> Sorry, but I have lost my debugging crystal ball which can help me guess what
> the machine does. :\
> 
> > so we now know this didn't fixed it. however I didn't have tlbi=ipi set, so I'll
> > now try this.  
> 
> That won't help either but if you wanna try it.
> 
> > any ideas on this new info?  
> 
> Yes, see above.
> 
> Bottomline is: without sufficient debugging data and up-to-date hardware,
> there's not a lot I can do.
> 
> Thx.
> 


