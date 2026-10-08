Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1D4CA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 20:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D596B008A; Thu,  8 Oct 2026 16:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE3F6B008C; Thu,  8 Oct 2026 16:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314836B0092; Thu,  8 Oct 2026 16:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 099126B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 16:49:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DE2EA5327
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 20:49:25 +0000 (UTC)
X-FDA: 85300649490.01.1F1CFAC
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B16A1C000A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 20:49:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b="1Kq06F/s";
	spf=pass (imf18.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791492563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tgy7JHtkftQQHsCh5M1j6zKdCKO5xE0MW5AcTqqIuws=;
	b=R1PYymeOOFd0WQx+iHEjiGncDcwAbXMsknWmEyFe5hj5Fb088J2QYPPuMKzspfPS/mPLty
	P82D7tLpYZMZu3eytmcwBzNte8CiDpaL70kF+gCGawlKPbrsxbazME2KAI7CXqlWojr36K
	OP57bunA3J5jed6EIR119GPlnFp+Wos=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b="1Kq06F/s";
	spf=pass (imf18.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791492563;
	b=ZOPG0LkgHsV9U7lsvya71Ex2P1yAb3jt8ZZNkfJpPq6qfuVWuKMOEIGN2VBXPR9pBo4z5Q
	s0t+mQ1U9WXtG0/ldlGUvFnJhUn4yI9s0z+9kTFfOZg2V8BZQ3qBNB68wmLnotaBaEYkmT
	kHno9KpATyBbeatfvN3F1mDs53hXXdM=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 698KmrLM388540
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 8 Oct 2026 22:48:53 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 698KmrLM388540
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1791492534;
	bh=Tgy7JHtkftQQHsCh5M1j6zKdCKO5xE0MW5AcTqqIuws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1Kq06F/sYFjFDtOZMno+svrWGCL0fiB10fmGoC6qn+v4OqtweiWK8jSX5B3A1BQ+F
	 j6E7mLfWVOpCSMXshzm2/JigXZwMgOhJu01Mnr8hamVBjCd8oSp09Eapc0rtZhma+1
	 1l7BE9P1x27IBAHakZt+SS4Vdq5qTYjuaO567n7o=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 698KmqCx013982
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 8 Oct 2026 22:48:52 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 698Kmfxl2543877
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Oct 2026 22:48:48 +0200
Date: Thu, 8 Oct 2026 22:48:41 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: David Laight <david.laight.linux@gmail.com>,
        Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org, Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <asgBn1VadUOpWFpZ@pcnci.linuxbox.cz>
References: <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9B16A1C000A
X-Rspam-User: 
X-Stat-Signature: g1z5fkbw5w73ugiu3guo5ucsefmq78sx
X-HE-Tag: 1791492562-696598
X-HE-Meta: U2FsdGVkX19XdnJxbS5uAe/qu7WwDaZgg9IfhPdAvGqh7KGLA4NT8RYHdJ69f79cKFqEXeIxRgYj1oPnynRAoDpfdqmfClmf+AQM6IuQlo8nXBDKqC5gdarxsbz3NE19tTKF5ThFZrZGUfaKYkGilrnx5s/yMPbp3BHNenfeeDulu8ffm0eS4Ce+v7nbxp5huk1/engRTPMA5YmdeKkN5PScDWYTytmiHrvqek6VTZghK2oveL5lcou7/sbWvSPgVxxPcJXQgFM01PIIQJm3sKix9gW4v+eoaCP9g6ksWvoPr475d74+VB6FS74otOQ8Xdd4BSkhxT+FCFXPXYsQ7SQ8WLJZx2yEhxvD0PHBiqySmUgdAS73rkyVDhU1rdF1Q/sTJ9pizxz9wAeqUI/PrMQlnnPyznjSW536JhMNlkWzLtIMakYp2YJv6bhFrnyjVX55gV0rBAnUv/uAxLmBMx/qcKiQahJgnY1OifFE4Bo/oT2sQg4nI0cCLze23PTF+wSQhZ35RfLhEV74b+ZVUn48nR455GySz1tCwt9zDhF744yAJ4w0HG8p7Osv5Ul7tEmhBTw1cJVcvdi7TQb0eC7HCSoGUoEmJcmF4BvmkE3HrFPP/THqLl6o6McJXsw0D4pLg1s88EJ8q/xAONJWY7zLuMw+nshu7uZS7SwYlAogoQLTdn3x4BkCIKisFTGwH6St6VX+HR69HHNwUjm1wOLRNy2ajl2XDZv/p1G2lHDyUtrtjY+kh8yCZbpDClUcLBWUeWaK3r65gl/hFHE+Lw68LIq5nnaQsauVQq9RzzVHHmWLY8mYKkpJz39iP9KsMCwfXAzB95CA6dHbpGrXyK1tGU+d9kDJ4iUwJu6evA8hWu2y8PxXjh8RVprLwigA27gkVGG+w+gO1uT8ko/8zuZhX9gqnW+svHvzcsMHkxj9JVx00TQstzB/cUAvl9TF2D2GjUisOgFDe3MZ399
 V1/m7fvv
 CfiTnasT1I8AcTYpYJfOBEfEJ/hy7/x6M0s/FPXXZ4wqx7ky/wLHf+R87TQK5Bwm7gDyP+KJb17fHk7zfvFxxhYmLe+GmLB8N9Gc3ZFW9McdOqRJRMTjUw4AMmmaQOHC4dnYOe9T+k0oTQR+hLT3eiQNgxOAsRgrr4bwZnKfekhKvrX3k0Xsr4aNx4TDL8L97jHjIDEqN4CzsY2SGBKGcd40DG/ECjAksFFx3YYvLb0+WbLsGht5dbvnzY6GNlO8jkXuGjBE05YB69zjY4UmU+tzh6cKW4yUFOqeK5szhh/KU1Qdl9PqV+hSy+WLn/D4RwC+1n82+MpaYvqGmXeij+n0PJcWRnQ04AZ1gxoJam4xaXoadFmQhbTvPcaS0qwGOBVgCzz5Adwkce4RpTzuBOBopMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> What is that kernel?
> 
> 6.18.55lb9.01
basically it is vanilla 6.18 + 6.18.55 + few mostly insignificant patches.
if you're willing to take a look, I tried to upload all important stuff here:

https://storage.linuxbox.cz/index.php/s/6rcp8oWCGzAqPEY

sorry for not making this available sooner, it completely slipped my mind

description of files:

linux-6.18.55-lb9.01.tar.xz - patched sources tarball
patches.tar.gz - tarball of patches applied to source, including description txt
 (stable patch-6.18.55 is not included)
kernel-6.18.55-config - .config for this release
rpm/... - kernel, kernel-vmlinux etc binaries in RPM format, if this is OK for you

vmcore-dmesg.txt - kdump-dmesg, unfortunately the box got fenced before
being able to dump vmcore binary, I have to tweak this

lscpu.txt - lscpu output

if you prefer src.rpm, please let me know.

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
>   22:   48 8b 00                mov    (%rax),%rax
>   25:   48 85 c0                test   %rax,%rax
>   28:   74 78                   je     0xa2
>   2a:*  44 8b 58 fc             mov    -0x4(%rax),%r11d         <-- trapping instruction
>   2e:   48 39 78 10             cmp    %rdi,0x10(%rax)
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
despite every effort, I wasn't able to reproduce this in lab and I couldn't easily
just upgrade customer production boxes to latest mainline...

however since we got the crash today on our own cluster node, I guess I can upgrade
at least some nodes of it to 7.2.x (possibly even 7.3-rc6 if necessary). but telling
whether it is ok after doing that is quite hard - we have tens of boxes running various
6.18 releases for months without issue. so I'm afraid the only info I'll be able
to get from this will be the problem is not fixed yet in case I get crash with latest kernel


> 
> If so, you could share your crash core along with debug kernels yadda yadda so
> that I can poke at it.
> 
> And before you do, make sure you have the latest BIOS and microcode installed on
> that machine.
OK

> 
> Also, where can I find full dmesg and /proc/cpuinfo from those machines which
> trigger this?"
I'll collect this from those older crashes as well and upload.

> 
> But still nothing.
> 
> Imagine this issue has been fixed upstream but you don't have the fix in your
> kernels and we're basically chasing the same thing again...
I understand. That's why my initial question was whether this may be some known
problem for which the fixes just didn't get backported to LTS kernels yet.


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
if the uploaded sources etc are of any help to you, I'll be grateful if you look
at them as well.. what else comes to my mind, if the full vmcore from one of previous
crashes including sources, debuginfo etc would be interesting for anyone, I can
either make it available for download as well (which I'll do anyways), or I can
prepare debugging VM where it all will be prepared including crash tool / gdb / whatever
can be of any use and allow access to it (supposing I'll get public part of SSH key),
just let me know if this makes sense..

thanks

BR

nik
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 


