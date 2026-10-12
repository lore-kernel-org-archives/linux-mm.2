Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBE2CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E16C6B008A; Mon, 12 Oct 2026 07:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391A26B008C; Mon, 12 Oct 2026 07:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7DD6B0092; Mon, 12 Oct 2026 07:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F14466B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:44:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88BA780BED
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:44:18 +0000 (UTC)
X-FDA: 85313790996.10.AD38698
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf03.hostedemail.com (Postfix) with ESMTP id E449F20006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:44:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=Mis9rF25;
	spf=pass (imf03.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791805456;
	b=hLKkG6cR29USA87ht6i6Rpsnlhdc2bW/pc/5Fcl3nFQY/fVcnj6Y5N1DSSHFgEnmSOdF6p
	3PmgtQwDxxHWMNocDdKp6HywNUD40V86VsdBh7CxOM13aKS8X3zk0u/lD5HgYBjLJiMS90
	s4oQbqfSn6ExW6sXmB07NVEZoNqz1BM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=Mis9rF25;
	spf=pass (imf03.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791805456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pB40mqfqJVnrOjih4vzreHDbbNCWB9anzRndgxLYqM4=;
	b=sccyCk+gA0IZMCjSTiG4BPPZLSXT5zjlmUxz6cBkLFMYlvpB3yktophVVl7+Gza5YgjZ62
	m/UUGBW7p2ziQ6lkgO/A53Gvq4n9Ly4gTZQlUYXfXJr/2FkhmFHVtwALohfOCISbvBUncZ
	hRhrm0/NMP2dU/IQkWe3ZND3VYR3+6o=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 69CBhbXJ266419
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 12 Oct 2026 13:43:37 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 69CBhbXJ266419
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1791805418;
	bh=pB40mqfqJVnrOjih4vzreHDbbNCWB9anzRndgxLYqM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mis9rF25pZtsufSRCWCXxpLH+5P3h+KaEJXfwd/CCwEjUQZOzk3HREGNvXRjy8IIa
	 5/4B9B+prpExc6jR1QAshYRfYCh0SCbtWfS0C4dUbd0tvlPiQyaEJJdoXRiDIMBmhy
	 IzZ80/aFtF7SUV/QGzO7v832mxPgcErSVqsH2HMs=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 69CBha8Q040600
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 12 Oct 2026 13:43:36 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 69CBhUjG2765366
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 13:43:34 +0200
Date: Mon, 12 Oct 2026 13:43:30 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: David Laight <david.laight.linux@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@surriel.com>,
        ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
References: <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261009090042.39ba9c06@pumpkin>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E449F20006
X-Stat-Signature: 7hdpqew9nijp57wdbqbsf56ikzi7ee4z
X-HE-Tag: 1791805455-732120
X-HE-Meta: U2FsdGVkX1/L7bKp/gPtO7AyL6YY9WaUnmXm7NU+xANmX3O0KHzwbXSCGXbGa5+8iaBTe7RAM8Pr9Xv3sKnBjMmiTYUjkqw0Sv40LKO1N+r+1LPZY4VEF08Q3YOsaAkT1Ffm+DHZAYoYGtgE9QZZLJd0YpdWe4gngGE7m/GxMFQStaIsW4kqyHsHn+0BbBYfdKGGU5YIaKxEPdSh4eTWflCI8V3FpOHpkDRRGwhVEXKUKgH4C52tCRSXHYrQrPVIEWj3RVN9sBqRtRKPToVEvTSNPezBXRV1GPEAJQDdXatehrFRh5SOgMDVER0EWajVQx4mkNxWevkNXWZxwsALDNg/2wLtQhmxHls9aJFSbIshI/kyvTHNITD4OsSV3KHh1xlY9Nsbm7H4h8Vp7yUR40lpL1B4OmACfADfFLk9PUDr4yz0HLMMKpEhi6lJScnK4xDYxRO1abp5jkT3YxXi42TQ7Fl5RlDAV+Q38iqaU9i8RuD6+KBQAwBM+quA0ejs5oH25jvA3gwJZ2XdnF3yc7RsE/NvhnFlO871EN5jLkivVHJ/DxmxdVBmrxOW8WZxFmSt/b3le4V8uMq5i9Q+QegRAO6Z2bjbqMr9o343glJ2M6FOv7GKzY+2K61j1H+Ebql52UuhWkan4ZNGLiXRTRbqx7zCLVNEOuR5B4osBRx09ZKnSlL+h8zxvyyplz3xn09U+yFurM1KXOtnZnsc1Ms+QblcbsFShISyZgXNCPTeveblR9Dt4yTunNkdphN11s2QMhHBoxGKXdT1JawBRypBUQ6zj/Yi8rq5KUHZB7iGqPiaMWzvpdYtTOMfODj5QqwRkiia9MzMo2Ts0xbgpMbFmVAtvvOTMNHVVCuHaknCv4XTng7IFUl2MIowWd9wRKMICpnuSw/IE65oecATSVoqs5n1UsHX5j1mZpIAxYEcQKsOrW9Rn2du8CChit08VkCisxAbdxKJuodU1mD
 GeErx98M
 M8X8dEc8cxztsoFml5PLye2Rm2Oy/yg2RvkqKzjXq/Pk5XM2bFjmrNw9y8xEq3tb7eY/3bbpTQWaDVPhAoF7VQttroX34IafgG8hNL1QgoJy9izGlAsVB/neXPFotULofLPo4U7XYmJ0Wx/3VqPn6tEPI7l0s237i/NlnGwUPyz5T8C0xxQgX5piCa2KgMrVfVRAWcG2EC5CxxodowRl2O+P83t6Z4BqVI1QGfGguz4AlwQCor9Z4At4jGu76AqA6slTgE3Hq7rwgPIjSwQiijbDK/VjSdmt+djmMtOTjzXVCW93YfoLNz4yJbijZkcCS+DS5ZGiRAJzDXyvSVf4R/UfN6ObEnFsbguGfDk4G9dWoqa8Ptmi6zRaP5voRN6jKyBpNGaNnglBClNZUAc5m8D1Euw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some more news.

In the meantime, we’ve had the same crash on another of our own
cluster nodes. This time it was booted with tlbi=ipi, so that
didn’t help either, exactly as Borislav said.

(Just a side note: it seems quite hard to check which TLB
invalidation mechanism is in use. There is no message in dmesg,
and invlpgb is deliberately not displayed in the /proc/cpuinfo flags,
so apart from measuring with perf, I simply have to trust that
the kernel parameter does what it should for my kernel release.)

So if I understand it correctly, we can now completely rule out
an AMD firmware bug, right?

Since I didn’t have anything else to try, and we started having
crashes on our own cluster nodes, where I can be a bit bolder,
I built 7.3-rc6, deployed it on two problematic AMD nodes, and
started a migration torture loop.

Over the weekend, there were ~70 migrations of ~160 VMs between
those two nodes without a single issue.

Today I upgraded both boxes to rc7 and started the migrations again.

I can’t be sure yet, but it really seems the problems are gone in 7.3.

The question is: what now? (I still think bisecting would be unreliable.)

For those interested, I’ve tidied up the shared files a little and
added some more content to https://storage.linuxbox.cz/index.php/s/6rcp8oWCGzAqPEY:

6.18.55-lb9.01 – 6.18.55 patched source, patches and binaries
yyyymmdd-xxxxx – collected crash data for various occurrences
kernel-6.18.x-problems.xlsx – problems overview

Maybe it will be of some help.

BR

nik


On Fri, Oct 09, 2026 at 09:00:42AM +0100, David Laight wrote:
> On Thu, 8 Oct 2026 11:23:56 -0700
> Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Thu, Oct 08, 2026 at 02:29:36PM +0200, Nikola Ciprich wrote:
> > > [11402.940943] BUG: unable to handle page fault for address: ffffffff0c93001c
> > > [11402.942273] #PF: supervisor read access in kernel mode
> > > [11402.943629] #PF: error_code(0x0000) - not-present page
> > > [11402.945025] PGD 6d6f83a067 P4D 6d6f83b067 PUD 0
> > > [11402.946469] Oops: Oops: 0000 [#1] SMP NOPTI
> > > [11402.947950] CPU: 23 UID: 0 PID: 704950 Comm: servercare-moni Kdump: loaded Tainted: G            E       6.18.55lb9.01 #1 PREEMPT(voluntary)
> > > [11402.951254] Tainted: [E]=UNSIGNED_MODULE
> > > [11402.952913] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 1201 08/25/2023
> > > [11402.956569] RIP: 0010:__d_lookup_rcu+0x4d/0xe0
> > > [11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08  
> > 
> > What is that kernel?
> > 
> > 6.18.55lb9.01
> > 
> > The other machine has a 6.18.20lb9.03-something one.
> > 
> > How can I look at the vmlinux you're running and the sources?
> > 
> > rIP points to:
> > 
> > [11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08
> > All code
> > ========
> >    0:   48 8d 04 c2             lea    (%rdx,%rax,8),%rax
> >    4:   f6 07 02                testb  $0x2,(%rdi)
> >    7:   0f 85 a0 00 00 00       jne    0xad
> >    d:   48 8b 10                mov    (%rax),%rdx
> >   10:   48 89 d0                mov    %rdx,%rax
> >   13:   48 83 e0 fe             and    $0xfffffffffffffffe,%rax
> >   17:   48 83 fa 01             cmp    $0x1,%rdx
> >   1b:   77 0d                   ja     0x2a
> >   1d:   e9 80 00 00 00          jmp    0xa2
> 
> That looks like the same hlist loop top as in the other failure.
> IIRC the fault has the error address in both %rax and %rdx which
> means the invalid value cane from the top of the hash list, not
> from following the linked list.
> 
> >   22:   48 8b 00                mov    (%rax),%rax
> >   25:   48 85 c0                test   %rax,%rax
> >   28:   74 78                   je     0xa2
> >   2a:*  44 8b 58 fc             mov    -0x4(%rax),%r11d         <-- trapping instruction
> >   2e:   48 39 78 10             cmp    %rdi,0x10(%rax)
> 
> That is the hash compare instruction (that fails in the other function).
> Not sure why it reads offset -4 first though - the compiler will have
> reordered it from after a condition (just to slow the code down!).
> I'd guess there is a container_of() lurking.
> 
> David
> 
> >   32:   75 ee                   jne    0x22
> >   34:   48                      rex.W
> >   35:   83                      .byte 0x83
> >   36:   78 08                   js     0x40
> > 
> > I need to be able to pinpoint it back to the source.
> > 
> > I asked the last time:
> > 
> > "Just to rule out any other issues which got fixed in the meantime, can you try
> > mainline Linux and see if you can reproduce your observation with it?
> > 
> > If so, you could share your crash core along with debug kernels yadda yadda so
> > that I can poke at it.
> > 
> > And before you do, make sure you have the latest BIOS and microcode installed on
> > that machine.
> > 
> > Also, where can I find full dmesg and /proc/cpuinfo from those machines which
> > trigger this?"
> > 
> > But still nothing.
> > 
> > Imagine this issue has been fixed upstream but you don't have the fix in your
> > kernels and we're basically chasing the same thing again...
> > 
> > Sorry, but I have lost my debugging crystal ball which can help me guess what
> > the machine does. :\
> > 
> > > so we now know this didn't fixed it. however I didn't have tlbi=ipi set, so I'll
> > > now try this.  
> > 
> > That won't help either but if you wanna try it.
> > 
> > > any ideas on this new info?  
> > 
> > Yes, see above.
> > 
> > Bottomline is: without sufficient debugging data and up-to-date hardware,
> > there's not a lot I can do.
> > 
> > Thx.
> > 
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

