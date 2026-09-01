Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D16C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CB26B00E1; Tue,  1 Sep 2026 12:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83EA96B028B; Tue,  1 Sep 2026 12:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CE06B028D; Tue,  1 Sep 2026 12:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8616B00E1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:06:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9C11A0463
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:06:20 +0000 (UTC)
X-FDA: 85165670520.19.7B283D9
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id DBC9AC000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:06:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=JbXfhSQN;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqCXc1d2wL50duIrdszOJfzq0EqANvFRgXietPv5nSU=;
	b=ff/1Lv8zIhmqdqf6oS9+FAoHzTaprG7bCsPGjMmqz0ZJtDN0+eMlkN10R+MJi7pT4pPnJW
	ujCR7gMFKDEYYViilOcnkxiaBZNPWkH4loMSQtEbirWBDj1CX9hpRArUzs9+VE8LuZ37yd
	4ChuwOzkh2exNyZCBMoOtAs4ys8eR3U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278778;
	b=uqglzpx1WyhKlK+0dzBFjppJesScG/CuXOLct00TSl0pYwnRYpU9vvQn4ObsQUxypI7MVa
	nMEVt7XNWWR1kEPT+SLnzTtbas/+x8pQNRaBvb8qceLXJn8NCVg0z8W2QPLUWxi+Q5AZV6
	+KadgbjOFd4rLxtoPb4cYDthsIDSktI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=JbXfhSQN;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92ea24a2dbfso10714485a.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788278778; x=1788883578; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wqCXc1d2wL50duIrdszOJfzq0EqANvFRgXietPv5nSU=;
        b=JbXfhSQN6wXI17AF2KmQAAwG2WZnQ9kGg0zLeYQWB4mctvWWOzJDR0Jv81oII6FnZP
         neis/nL/pWFQbNpaoeTbzmdjumbQF0eY/KaDsxQXdfHCCjImd1PKeOrwEIdUPHUDEFTa
         lfPSaeXtxwf/RwV8kqPHSWBddgDB3+RB4mBB+7HzauKKUVacTKXUmo2IQXGRUXs8OZfX
         viASvhEaThFMQohZ7WRb5APi7hldtpKSvjFHKruV6ljgv+rn5dzPNOwG/NGWSnGL4fAt
         +HtX5ulaCHhXC+qHippn8ntvz913nWX2HSJwFGzkgBGzIPVTbJuI2WR+9QvXgh9pcSVA
         zHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788278778; x=1788883578;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wqCXc1d2wL50duIrdszOJfzq0EqANvFRgXietPv5nSU=;
        b=qX9a78GfiEApksPsJYK7u4opPNv14CX+SqMtv/ifJZrZqYT3bR7+D8wRdHQkBWfP5f
         lbBRYKJNntB9Sj0he9Or469NmevWi5+PGJ2Ov5LAoO2QItbb0i7PcFkJBgUDHYWCC1ud
         FftTcHghCP0tIoP7uFKTcJrf4wp9YP3JNTEzAuuXMrNCs4B9aYd93K4csnj2M+AGL+hi
         N58cf1JWyLlEW6VMUEMbW9TNvkr0R4mefsqkmK1VlmsSjXQOdtm22CKVhar0B0GsXUTJ
         c+3Cl4u6uevVXrdSFeeM/WtcOyIfg4yQM4btMRXeXbxXxwac/KepawHLKnqRf1+kClxL
         lBTA==
X-Forwarded-Encrypted: i=1; AHgh+Rqmi5V1rFeOCLJsMF9THaFyosXG06c15BuAhidBtVnhVHkECJB4QhQinS0O5mR6D7kuO3Y7ly9m5A==@kvack.org
X-Gm-Message-State: AFuF++lUjGAUhlr7CSOBMlvF8ubJqvXxBqLS74zf4jRqPImIqHvqcIxp
	WeMjkKHgw5Ma2J//pMgNNCjSOwwOPdDPGj5e5y87w8Hf1U8KO8bOhkbbhpSrnA42n/s=
X-Gm-Gg: AR+sD12ak6FSViqMV3m7mM9czL1bjzNtNGJBX+aKZ/K+qyClYj2l0kuTdL3OxK+FMUa
	R8nPlCUmwRCj6QP/3ICvqHhv2ViuPRZF1bn/0EYSljhDH8RszXk8ML9ngNS38nvFqn8rMpRyx0h
	WT9RaPc69FFa533AoXuIL7qKN6LJyqP8lSu+J6TZ4YgTu4eYn5MBZDdT1QE8jy/XdT0AkpwNGeV
	ri7Cf5E7CfKlLy6oyGIoA8zzoXSUNW5q67Mc3jikxJDi1XEIES8GewQPlvZ20+CkLaAFVF0qnJp
	tfVKjIBUdJ2bTaMbBty5DqRQYV7zga4DUgOROD96DMXdj9mAx4D36JPOFNUnnXRB/UK8pU+RuBL
	upmdNWnlzbp4ivY79SZ+oIBtMhClRLpyqGnqFRg6rUKTKTIpty66Le/IyNzQBF6rzXIHJLXa9JM
	1vz1neLwg1r7YjcKnUccRbojuAWmxGmn3nvpRb6VnIcmr9WzMWprhh3v/fw0KlFjayMzc797tWd
	Cxkq1F1IIDtvnUsDA1jKXM5LKCioJJf77buTmbwWhdYDQ==
X-Received: by 2002:a05:620a:21d2:b0:936:ea0d:ffc3 with SMTP id af79cd13be357-939139002d3mr3178331885a.22.1788278777843;
        Tue, 01 Sep 2026 09:06:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93922e5278fsm886283685a.14.2026.09.01.09.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:06:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1R04-0000000BtB8-1Fgr;
	Tue, 01 Sep 2026 13:06:16 -0300
Date: Tue, 1 Sep 2026 13:06:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Russell King <linux@armlinux.org.uk>,
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
	Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <20260901160616.GD56830@ziepe.ca>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
 <apbcoMTVlL42G5tg@gremlin>
 <20260901142408.GA56830@ziepe.ca>
 <apbiB51hjm-9pRzf@gremlin>
 <apbuO_QveZNAz3ns@thinkstation>
 <kasi4mkjkt56wxsrmphm5o2qfg2lwsdxf3tlmzx5tq6t7uez74@kozleoavd6r2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kasi4mkjkt56wxsrmphm5o2qfg2lwsdxf3tlmzx5tq6t7uez74@kozleoavd6r2>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBC9AC000F
X-Stat-Signature: t976xeprstszr8g9imfs4hz3c1nfh8w9
X-HE-Tag: 1788278778-510562
X-HE-Meta: U2FsdGVkX1+DYmGBEN6D2lb83xegPVntUd0w6V93NDUUxI07YiPsa+lqvic6i2kZPPvbc84sK1XU+VDUtPtknCoOp5NzwrvEmG7LkLHuxyJM3vG9n9SsDJzJVGBOnQtURPWEux7ZmyWVoEvIkYU9E9iGrXgfYDZ9b5Kx5vGe+pfGrr6GWv9mJSgRa1sA5ZW8AjTlleaUiz4+90u0hbwcSDzJrQuSxZQl7FMy3emR0LWMMsDTbuaYjhkHdK5VZG8ZfM9gmyRRKybX6fHy2wjM2Lsyxhq4F9Qi1PqCMchpfutYKMdxgnpnxuudEUtqNDx9799sKE1cv24Rwm2iAYSV0kxbWUflY2AwkLIRcuRi6wpXeeFs1k19ivrSObcFWWMD2Ul7zXz7MUC5GNiroDY7n97t/SC7SVLrG+qDG+E9EmDyzjAeDXWtCy0OidkmObvnXk8SDqwyh2yu4793jhX0XXY+d4Jl0n5z6sQotm8DRKEUwEoO+E5g6B2pX1GHwwgAsF9+bKa8fj8Yt03K1hDq1KovTpHR9h+rkMNjZC/ELI7V9qH4NSQpWyDWzwmIDVNzTOQ4t6zOnK7vGOKyrlEw6lIHY0BdDXIkQZJfd1IbKujvbqDT3yHimfrKfoC+pCc8hJHzLOBufazaeihV8betlurgSW1AKJzkukKTFmBAblENU18z0L+MISbttEIASKw6CSKjofj2zBIhYcn0mZSiyWlMc7FY9TpGAiCHKY+9kfDTuejzc2socYxAGzj5cG94wmKlDOPA1HkmjlIkw+o1Fyl6YMM1pe9n+ys/pemAQ2eEVnlQr5p97aM1pERKqrMvub2JOQnQ9acodNCkeUs1j7+ziFXnMaPTdONABqx9XB62lnAtvl/nX2RAXo+/yRkx7tETy+ubbdLomGcc80R++QFOA0twLmQcCOlZdi7FNNtiJnagmG7ZR16TI45ojklO689FI3pu/JDoC54T/zH
 JLLnUJ4/
 KYdMmIvbJZaAdFcQOInin2C7S5z3mZBMGyYd+UhDRafYZR6sfUT+oZAulNVpB1XFE8sblx5piHBxGCrQ3BN+vv+emyd6Krx1RnWv/ah+BHf2skxtNxyCAURcRr5ujGgyDm/av/arbyCKLqUekKkyClkzn4n4nRmJaZOTupbYZA8vMru9WdgpHgADKLBJnCbft3O23sNcYJNYpU2eENMsX30bzGhA2aJWUcVGi0hzt44tOuD9jGZJJw9uprPJATUL9L4jGkYX959NC/KClt6PZlFKSCcEdHHaxNuB1T6lCEiPP3ywXFfw5gMKLAL936SgiRmu76xc1zh4a65u3V5jGfNIOXWdCLEiw1SuBx8dfEExVbakVIIVhPGiaRe+kABbPDlKaDECTHJulSr175fDjJxK7JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 11:54:47AM -0400, Liam R. Howlett wrote:
> On 26/09/01 04:28PM, Kiryl Shutsemau wrote:
> > On Tue, Sep 01, 2026 at 03:41:17PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Sep 01, 2026 at 11:24:08AM -0300, Jason Gunthorpe wrote:
> > > > On Tue, Sep 01, 2026 at 03:12:45PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > >
> > > > > It won't be costly at the time of the calls obviously as its deferred. Maybe
> > > > > increase some time spent in softirq but again is 512x that big of a deal?
> > > > >
> > > > > I'm not sure how you'd both defer the free and somehow utilise mmu_gather here
> > > > > either really, certainly not without it becoming extremely messy.
> > > >
> > > > The less costly version is to thread the page to be freed onto the
> > > > mmu_gather through a linked list in the struct page memory. This is
> > > > super cheap since it is just a singly linked list operation.
> > > >
> > > > Then when the mmu_gather is flushed it does a single call_rcu using
> > > > the rcu head of the struct page of the head of the list. The callback
> > > > clears the entire linked list of pages.
> 
> If you are going through the trouble of doing this on your side with a
> custom rcu callback, it might be better to pack the pointers in a way
> that does not need to pointer chase through a linked list.

Well, I have 8 bytes of memory in a struct page and can't allocate in
these paths, so IDK there is another option..

Jason

