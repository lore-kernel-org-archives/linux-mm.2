Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B51CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 01:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B426B0005; Mon,  8 Jun 2026 21:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C6F6B0088; Mon,  8 Jun 2026 21:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFAEF6B008A; Mon,  8 Jun 2026 21:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFC436B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:14:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34DEEC179E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:14:58 +0000 (UTC)
X-FDA: 84858605076.12.5256DFC
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 512F640004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:14:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hxJdyFkG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780967696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgWc+GbcdT1TE4KoGHerpUiSmy6CQo1tAeSFDOuPHPo=;
	b=Wbs6nHSPNeuIwrkYpQ+Dt79t6QB+zbhe5p7PZqCUj3JXGuNThSu4b8jRmlHt5UK08Kfsps
	aVpwOllDKM5mKQlwo1T9jfMEBOLSFu5eevkbzjFrUarMSr7ITOthfd6jT78GCZUyUaJ3LF
	AFqxLqEFXZmSAsfb/EXWA8OwHCjOIFM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hxJdyFkG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780967696;
	b=nr+w1FKOB9aXfE1PhJLBF6HsN2KvJ88iBpNMevjj0WIRy/pisdKOwLzcfJdWNcST53e/1b
	xSztQoDQMM9C7CLRv1jdG0ZyvFPpOrjLvX8P2g2DijEMSS/PLBDVq0Uhu9+rvpPA//OpbL
	3qgw2No2gCA1YE680IcK9K4V9p54bSs=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-915c36e32abso192460185a.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 18:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780967695; x=1781572495; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sgWc+GbcdT1TE4KoGHerpUiSmy6CQo1tAeSFDOuPHPo=;
        b=hxJdyFkGOMTK600DbnykHsxDYHUkXtkmuFXIOZpiAOclAeHm4ShopwkGMgnoicyS8b
         OpfpAymqwk8TLwbdBekMQMgkTiuYWyFUcBuTd1OwJJfVOZrhOWloF7I6M8v8YFccQZCU
         EcxblL1fQ4vAOcdUEy6U/ToHgen+GWGfEh8nMQEOQL9XGgIU8s8vpeMoIL+wA/fvJZ0K
         g1rZ6Lz2uh6pkftkU8hGwYttXFksCwZzCCycYRlWh7DLJxusWszm3aU6pzT5fEdt2TTt
         jhO52zTRU9gotAClkXL2bCARZKu9Sq/y1y6Z7EOJg2+i7bV2DHhzY0PBzCsgAXxMMpzy
         2o3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780967695; x=1781572495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgWc+GbcdT1TE4KoGHerpUiSmy6CQo1tAeSFDOuPHPo=;
        b=Hw9guroT8eVXGtt9l0DpCBZsW6icl+kyx3TWugO78UGArTFXd+xr2sKArHKlhZbYpa
         bx4f91tI2LsXKF0h9bkRGhOjHrJtMHod7hHCF+FoQdDMhAgnAnayW5BHREJBUk56k3TM
         ssOmM79/4CvfBF5h+c/LwK7lNc0w0JSO/8Dx/6jFjwIJMS5lSWrEMIyffWzkoGEHOGMB
         9I/azM/uLFeq2GlStiXqUGQjY9UjT0iQntKBrboox2L+JL7A+2ft66wh/PHKZpCSpagO
         VksWPXNnE33GvyNnsLywjb7b2HH3jen6qTEfev7hQQH5s6GkEBruRsXwtS+Q3XcpuB9G
         Wz1A==
X-Forwarded-Encrypted: i=1; AFNElJ8XNDtnmrSf6gEzs2lgCdki5q/U24p+3NoBisp8fEGHgdi7qR03JUzYgAFKgEm24aX5NlY/KQJQSA==@kvack.org
X-Gm-Message-State: AOJu0YxYnxQ1NB6ILVaoDupAs4f16DAT6NNKS8PVv/2S7VNM6CkhqJoR
	BBJS+U6U3Mz6ZG7eipBMmebjHRQQLQ+vHL2yJq6WXFNacvOHb/PDBEe2oxLVCZJef+g=
X-Gm-Gg: Acq92OGROMjQQGaCHIq0Hj+yQ8/Nd1LyKgD/rqMnW5glL59DpnyyK3S5uEPjtADDsbW
	+HZulSYsy4+B9t2ZYUmG7T9PR8IOyIsz/hoQ7JxyFIPSqwzvm0Sm0t6SCzOWWfRp0muGne5ppJK
	ATxRvVl+YzLhzaIFnt9ZtoADi9YW7jsffl9x6heasUPjk7tqJYJFs+rOBO9Zt9FuFQzYBh4Ad/C
	v2ChWJHHhDT0oZ5MBoDCmtrxPkyFPy0h4QOB6lqHZmIGmjVCYC3lxL+KpWnLLdbVN3tG/X7Md2y
	uM8uN21lIx9757iNUAvbsZo+Z8J+y7L4jlNRyRCBQlS1p9WuLplLhEDNpHtVuGKHmZrYyYyTKpD
	W1NjhYETa0Zm+IZ4DeaNb8VVs/XA08Bq25+dHjHJPfVTOJTJkjivsBQ0dmztFZzdE9alKemlcG9
	zM/pSYLDNmqjKuutSb/YtseAOUWNYjNOQXthj9LeXdy96jKQUCRd7lw0aPFormAw==
X-Received: by 2002:a05:620a:1b8d:b0:914:c0ab:f1ee with SMTP id af79cd13be357-915a9d93f2fmr2862027885a.44.1780967695361;
        Mon, 08 Jun 2026 18:14:55 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a009fe7sm1902384885a.8.2026.06.08.18.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 18:14:54 -0700 (PDT)
Date: Tue, 9 Jun 2026 01:14:53 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, jasonmiu@google.com, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
	kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
Subject: Re: [RFC v1 0/9] kho: granular compatibility and header decoupling
Message-ID: <aidnjw5pH_z45gJT@plex>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <178083348872.1648214.17778188633648887952.b4-review@b4>
 <aiVp5RlbWRz5VnPB@plex>
 <178091437240.1648214.10761111570005003901.b4-reply@b4>
 <aibYJvzQQnpoN6YW@plex>
 <aicF5Sa11B4ujfSa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aicF5Sa11B4ujfSa@kernel.org>
X-Rspamd-Queue-Id: 512F640004
X-Rspam-User: 
X-Stat-Signature: njxk6jzpzjwy1agxp1tk3o3sprxj4ndc
X-Rspamd-Server: rspam09
X-HE-Tag: 1780967696-242957
X-HE-Meta: U2FsdGVkX19I7omvYHSijh5MGsVaXa5ynVciYPimr05qcN8tCqELXgqQbqYsBQomelDkyMUcy8+6ilB4SIzqlvHKh3eGz5Hxzvs2ZyqqHqoZGoHD+3NH0MAHfu0TcNwdWs6FbY/AIOOEli41RsF1iPOUuzLaEIJJEGVLd4YmK+rthB2LGDpcpM8pVecvdMmNSIG8dbj+BZYpAsdHhfZoQ0Yu/GCUOYmSMNZ5KeJiD6rC/dJZHECcWYGzFheJGD++8wUKvrkqWwU/ZnAoKfK0q6U9l/NIWUud0zIh/cbw+9mIvm8EcniuoVS725T6vjBKNAAXmhyK0vsO0x9U8tNqcMNFYvVQ4+RA8LOZHE+xhMc5eygo+2SBqExaX1Fc6y4ZGXD0OndK8KwP8g4Pu5nNrJ66/5TzASRaPirblen30UDMEwrj+PheOZRHmuXPZvzBr7gbLw0+CgPDzpDUXdmsx0S3rjsN0l3/ZiiCNnSuKd9n2dpv8JDYAu88XsRoLEC58YNfHuCY+rjPaloh7EAD+rRAjO3A0GbDmJtJmZ9g5YvrJHNqkt0FgiCUUECUjnvasEU5IkapFfuOQbHEDZaOiXZmpuq85QRM2AFy0mvuiWXEjn5LonnTcf00re97/Q2hY817WOoN//B0wwDChvUZJ/DjtcHabmBF0ZvclusdM0HiSfmSl+KQuMhcwsPbBk64TotMhdmZWgS72+sRIrLE0R24otUxeoDdklq6jG8EGv6AJL+28tQ7OPeFpVr6xXKva9KsPKUab6fIVnZImWhDJeGewHGRam+w8UoHbcdgK+3xc9CllMVvhKrbnJpeV6tJtpOELO2bL5C4O10F/0/iQvn9ZWU6m+yilD4sBWj2ZBwBp32o/eu2pFyQLLNNxhz2fvbzxy+rqzeHJahdQIXnsojOPxAS4ilxTpSyZWul1TI68TVg1ExW06R8Q+kw8UdXC6WD3VMJ1n6yPu5nIgK
 MXXUPyX3
 dIHLR/U9UqHHMujrgJXyZ6zT2ei/+reMAb0v/YRnxbAZ6l6fuVk8/x1fCPzOSNPm7w4L+9wElA1nBIIb8Q7gVrgFMVIH6ovflkXA4lN+mZpfDRqlm6uS5pXqvSlMwqns3engFYZa2vCFE8kBvNplY/ouNAn/fQUJfv7edkU0W4lPIhOKk+1yVpOaqDFw2dqEUmlMkF+fWAK7zWBmpOPHxJSWeLpzsHcIhDQvOFN0xBkRczxfEm/fg2hLju3Gxzx1QY8nsDln4KZDEXpLjACnAzxBbCjxqmYOOeWZ6azugKTkQ0RI673Vry+OcQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-08 21:11, Mike Rapoport wrote:
> On Mon, Jun 08, 2026 at 04:12:56PM +0000, Pasha Tatashin wrote:
> > On 06-08 13:26, Mike Rapoport wrote:
> > > On 2026-06-07 13:43:09+00:00, Pasha Tatashin wrote:
> >
> > Keeping all of that in a single KHO file is the wrong approach and goes 
> > against how other logically separated subsystems in Linux are organized 
> > (e.g., mm/vmap.c, mm/vmalloc.c, etc.). Yes, there are some messier 
> > places in the kernel as well, but keeping this in its own dedicated 
> > kho_vmalloc.c file makes complete sense to me.
> 
> Either I hallucinated or b4 ate a paragraph from my reply ;)
> 
> Regarding the code movement
> - splitting radix tree makes perfect sense to me, just the documentation
>   part needs more care than mechanical move

Agreed. I'll also pay closer attention to the documentation.

> - I'm fine with abi/vmalloc.h, presuming KHOSER_PTR() is not part of it

Yes, I will move KHOSER_PTR() to the shared compat.h in v2 so it's not 
tied to vmalloc.

> - I can live with kho_vmalloc.c although I still consider it unnecessary
>   churn

Appreciate it.

> - I'm against moving vmalloc APIs from kexec_handover.h because they are
>   very close in nature to folio and pages. I don't see core KHO as
>   responsible for preserving physically contiguous ranges but rather as
>   preserving allocations. Not sure we'll ever support kmalloc(), but still.

That is a very reasonable compromise. I am fine with keeping the 
consumer-facing function declarations in kexec_handover.h so they remain 
grouped  with folios and pages.

> > However, overall enforcing the use of KHOSER is unrelated to this work. 
> > I have my own thoughts on this, and perhaps with proper versioning, 
> > using KHOSER_PTR everywhere would be appropriate, but let's keep that as 
> > a separate work.
> 
> This is a separate work, indeed. But regardless of the versioning it's
> already better than plain u64 because it provides type safety.

Agreed.

Thanks!
Pasha

