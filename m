Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B94D5FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 23:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31D06B0005; Fri, 24 Apr 2026 19:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB726B008A; Fri, 24 Apr 2026 19:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82736B008C; Fri, 24 Apr 2026 19:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5126B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:06:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 446701B6B4B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:06:23 +0000 (UTC)
X-FDA: 84694985046.27.0F5AE00
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6A04940015
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:06:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Gl86QCqN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777071981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtoQqCQTkTrD0PDh6RrLNWtjJq5PmFm6VcLxe9y1JUE=;
	b=X9hffZtWaR8LHlFyUFCgVJcSoGaxmSArPlGFO0ncKy++sZsG2OF6onMPfuy0m+LMa5WxHY
	pvBnPHCT+27cqJT2I84aJHRpQK4+Ug6erUI//nn5+qhuMFdA5WHwvdE8Df5HuXMORIOxmf
	bVGL5WOqXdonF3puaG8cz2X5HKVC+ek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777071981; a=rsa-sha256;
	cv=none;
	b=vYijCwHjuvv3j36olRhRBRz880/LthVcXbvgmhiOxLqYCMU+PEnywmDTq8+oibreyttvwF
	Qmi7K9igEbk6NHDhE3zM0pDlC7fEHXLw6wrmB2EBPBZF3S3b/8QQDumqhPPlOEl0fEymCr
	dD82bXEf/enri6VwSwt5lMtSzZUsOH8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Gl86QCqN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8d560ede296so920828085a.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777071980; x=1777676780; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RtoQqCQTkTrD0PDh6RrLNWtjJq5PmFm6VcLxe9y1JUE=;
        b=Gl86QCqNsNhe3okh2ofMXW2peNVGHC3XWna3kmUtPbud6nCr9Jf7hgmQA6ntoebrwb
         A8XSlBMClTKA4XjAbIidhhU3p6jWQ04ZI0hK9+wRUvUX7HPudM/TSL7GnfBqpTXezjaf
         AvEZz5gIT7UCU5H+LwcN2Q30IP5ju2dDpgjNBjJY+Rte7kBANMg+RGDsZHROiHRAi3mT
         rRMNfXWPelpP8Jg20258AuyQVw4tmPwKZ2L7tTNOvmnXpsZEUaIhyCrPHQZCLZ8xfmcT
         Z5iv1TWs+Di8ozx6HfwI9I9erN/Yf7vHfaylDo2ljEE8uQk6BxIN+0CqL4r38d0vKVkd
         hIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777071980; x=1777676780;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RtoQqCQTkTrD0PDh6RrLNWtjJq5PmFm6VcLxe9y1JUE=;
        b=KzN6mN68CiArLGXRQTich7xSmdR6Qkmy9nGZlzwng5jUcCRH/+x/vc3VzjNA4vIIKd
         TOeFAc2Z3suOGrQ3IGnJduVYuSTpmXd48GYrMIdJk0QBNiiycCPbXORbM7/G4zYPoLrj
         h107cN+nNg9PfyQ3syq3IwlDS33Qiv3CV7pVcPDxMmeNH9/J2EOMUnrOFJhKslvdHN+e
         Nfz3S9tRsjBin+Zf1Iqc9Enq6dPAeclwltX2P9jc9yztDG9nqEuzDXut7ZaACWZ2Tsnu
         182ZfkiXrpwlbtiVb7v9BLYBl5vXysQ+auGSai04AquDsr9/zXXA58qOrlz2N1ypVNpp
         GXmA==
X-Forwarded-Encrypted: i=1; AFNElJ84IkJS4a4/NX+olkk4qFYSoJjuAhf9crhoYpq9JWUuzWzwj875ekMdSXDcUi+euUcZfnt4BszlqQ==@kvack.org
X-Gm-Message-State: AOJu0YyrgVO5sWdjo0Dp4z5ecaDIwQgnbVZijxBDYnFU3MNi9C9nuw/L
	FS83f9wTm9Y+rsWXfYihi5Hl99LoFKxutw4GoSHeT1UNtvVu/yCnG8fC5TZWio4tqvk=
X-Gm-Gg: AeBDiev/MdvGKL178PsolQ7EJciIinmmsiQxbEXfsVG3tpa9xNp/ReAgE6s8FA2tmFK
	AhLjOOlZIqX5QPMGLlidUNO4qVrurVoEsEP9xJXtig+RPrA9whkWO9tyLygIQZl2k34x2U/RJl0
	bs3VjqPQwO+XHGXxPz2laPUIXobP96EmAGzACHNMd7ORSqwO0hQbyioMc4K+QCjomGq2Ac7TL7E
	F4vxXzKXJf4bUSGAEK/y6cOy+ZihKHVnZBSC2J7bF3cB2giDxBVtSUa9eFm7KtVD79/01+Jemky
	69ENZABZ7YICEDRDgn0CWy43IBPkwbDqAm7+OEB8TAFcyq9AsLI2UNFV1EH2C3KGbI/xSs70Cfz
	5UigNgaE1unSCBlxSQ3gWzdf8mdx5zSm0qTf1ovMDzcDvAO0t1NUjlQijZDHiQrS+9a1ldjjGGg
	Q6i2/bJ7Czg2QjsINMry97wTSUPAruD+BlDwuOdGfM++rX8Hrune+ZlHNtzw8m1g==
X-Received: by 2002:a05:620a:460f:b0:8cf:c106:faca with SMTP id af79cd13be357-8e791f755f5mr4775333385a.36.1777071980394;
        Fri, 24 Apr 2026 16:06:20 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8eb3aa60b99sm1843237685a.42.2026.04.24.16.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 16:06:20 -0700 (PDT)
Date: Fri, 24 Apr 2026 23:06:18 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Dave Hansen <dave.hansen@intel.com>, David Stevens <stevensd@google.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, 
	Quentin Perret <qperret@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <aevzYQ8HxmDKj-1_@plex>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <aevhw9xqz1pWA2Ow@plex>
 <20260424232637.054f15dd@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260424232637.054f15dd@pumpkin>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A04940015
X-Stat-Signature: 1ufqa9hsw611hh3na4h5gtx4g5qzhsz6
X-Rspam-User: 
X-HE-Tag: 1777071981-474541
X-HE-Meta: U2FsdGVkX1//4rNeiAlaOHr/mxtA4t49eUR1Oa9vui3Or79QaDoZLynxeNmxF/hyFe7txemz/FyVm+FRrXhaC08VyzczaXKYNu/JNxPDohGjs926x6RcW9ZtOIJM7JEEppK9HEO/LYhaNbjjH4p0dfOSmiiAm91/pi3EL+sSEKyfhSlvkxz8yfDCCosSB237eTOSNb97aFF+2D/BtSXC5w8Zdt690tbNvR5mvjkZlsOrxPKF67PzQ61OXCSLEiAT7RRLLYHuYp8UZy090KIGQbzKQMqxHcIv8hEKpZ+L0KnMRzg29hDIGi253ap6jajPnlsqJtH5vni4ouEph7vSmrS5hllFUXXfqoArdi1LXyiHidF+GTBMy7D0L9SMZQeio5qtsn2vUvYHFyilpbjMoqfdqNkJA2Z2i36Sk0Ing3PK7hZZYcoZM7jamDeL6LOTeXcgIolEOwY9nhRUJkXrAn7dmz6GYwjsYddm/SkOQEKLISKcthBKY6Vt0MIQP8Mt5XE0T6qlAouFcghzum7vtABO9No2x0MFcDT4c64Ub8N2ciY64E//6HaOe8iBYmXC5He+B/0se4jJm3NHDGZYgy5e6KESJBpb27B24dlIJjpRWL70MXMPC2QnjWxhEYgSYwoQilX2w+hxBq8Q3OVjM4eJS6RUPaEkQyg1IG5le3nsi4bKyvbpbE5bJlIz3MC3pC8FDYsdjvG1NuNvIx/4h3U6JXnbO1A9UUq4D8Bv1vuWRIBGHDjZ5+KUjFYF7TTJktrKQAZCmjD5yEAmuIRE+4gO8T8K/3YrQ5LSVlUho/ulBVkbGacGdNA/Ja+CzqKhVjR6sHq/xWMLgrXHONEpqeTpsadkjLqlJzaj9iRKak6utzZB3HWfejtLAhvHy5H98F1oYVM75OlObzZnrt7LLIB1xn8/VS3TA/d0btpDU+a/aguczGkCbLf7c6eKVP6ZGGAWQCQgXe2/u1GBTtV
 TQnJ4Peh
 yEbWTXWkqr4cSDEoauYfFLEbk8+KQQkOekvQQsNyGPaXZzTAIY6BaMvF64bF9OiSLDZCEKit5Fz6X8w4+sx2Kpv9lg45kcyFvCruG3e+eyR2KEHUxKABn3ZxxR921k0he9YLtr7Elhf0TFnV2uvQ2BDGChu4k5APflKdX+b0qWVED5n9UrtaUtpR+pjqOQpawOSgjHWwlUFzA/OlC8mT1brGbV2pE0DV1DFlOZQ597j+wvXR4w3t4CMD0yKvngMIq+Sobgg/lTq79sAo8KzD3SMRmqYrd6C0VRY2vFD0k3xu/znnde0FoPohmjbTuzOBTqIfA5CaZg3EsRfTwcQWt3KmuPG2ny18etGrL8FRRQRMbD46EdOCF150FtVMzAdN/iD43Yl0xE2G8WNDGm4YLmHud+JEoPRRB9VU3t6Q0+2SYvVzjSpxN1kQhGCY+jaORqWMMTYUVGjLFU3LWJbQ/qoFXZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-24 23:26, David Laight wrote:
> On Fri, 24 Apr 2026 21:35:20 +0000
> Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> 
> > On 04-24 12:41, Dave Hansen wrote:
> > > On 4/24/26 12:14, David Stevens wrote:  
> > > > The question is then: is this approach something that is fundamentally
> > > > untenable in the kernel  
> > > 
> > > Yes. Fundamentally untenable.
> > > 
> > > Not allowing stack faults has been a wonderful simplification. It's one
> > > of those things that just plain makes the kernel easier to maintain.
> > > Saving low single digits of system memory is not exactly making me eager
> > > to go back to the harder-to-maintain days.
> > > 
> > > I seriously doubt that this 1% is the lowest hanging fruit for memory
> > > bloat on these systems. ;)  
> > 
> > This true until, in a fleet of millions of machines, you encounter a 
> > one-in-a-billion chance of a stack overflow. You are then forced to 
> > double the statically allocated kernel stacks on every machine, paying a 
> > memory tax even though 99.999..% of threads never exceed 4K. This 
> > overhead accumulates to petabytes of wasted capacity.
> 
> And then you hit a stack fault in some path where you can't sleep and
> there isn't any available kernel memory.

Well, at least if we hit this rare case, we can simply double a buffer 
of pre-reserved stack memory per CPU. This still saves significant 
memory compared to wasting it on every single thread.

> An alternative idea is to arrange for some system calls to sleep in
> userspace, so when the thread is woken it re-executes the system call.
> It then makes sense to assign the kernel stack to the process when
> it enters the kernel.
> That might mean that you don't need a kernel stack for all the threads
> sleeping in futex() - it might even be possible to do the retry in
> userspace saving the second kernel entry most of the time.
> It is all 'hard and difficult' though.

I was thinking about a similar approach as well—sort of multiplexing the 
kernel stacks. But honestly, when trying to cover all the edge cases, I 
didn't find it to be any better or easier than just using dynamic kernel 
stacks.

An alternative approach, which was proposed at LSFMM by Willy, is to add 
an explicit deep stack calls. When we enter a path that we know is 
exceptionally deep, only then do we extend the stack, keeping the 
default (say, 8K) everywhere else.

> The easier solution is to rewrite the system code so it doesn't have
> 1000s of threads :-)

That ship sailed in the early 90s of the previous millennium.  Nowadays, 
we have high end workstations with almost 200 hardware threads. 
Rewriting system code to reduce thread counts simply isn't an option for 
our storage machines, which have millions of threads per unit.

+CC Matthew Wilcox

