Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7023E63F15
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 17:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553546B0088; Mon, 16 Feb 2026 12:18:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515206B0089; Mon, 16 Feb 2026 12:18:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409D66B008A; Mon, 16 Feb 2026 12:18:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7716B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:18:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDF04C41FA
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:18:15 +0000 (UTC)
X-FDA: 84450978150.16.2235845
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf09.hostedemail.com (Postfix) with ESMTP id DEE67140008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:18:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R j8DKOb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WFNIP4dW;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771262294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6H82OzAohnyN19364JGe1izIv70m/IuTOUlXgxlP2w=;
	b=V9kWT3RP1ixIwsyWu0qjcSrFZLn96TxC14BVvNVUzDZtog/fjzH90WbKYo0yNgNYkmOkxs
	1CI9jG06YcKINf0exbPvc4D2O3nhZipcoSSqMwbN4R03GnOKfgIJaDNKLvu420JvdG4d5q
	fMM4YMhxbbJODU/nIAmX8g4o71Q4+Aw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771262294; a=rsa-sha256;
	cv=none;
	b=dbTM7XVqxvQ5gtIA7tR/MsfsDVwcNAXsXTGJGcY2h7pqfwIXa0O/SCMC6fTlfrxTaYx1aT
	imy8CTO0aLPLWmogbWODKpQXt5ztfowrnQjag3zXeVWp20kF10lH3Ud98bP4GvwKRpexGn
	xayRW67S5O2OwXhmPSrHUSjLXUyLdHo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R j8DKOb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WFNIP4dW;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 5085C1300E27;
	Mon, 16 Feb 2026 12:18:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 16 Feb 2026 12:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1771262292; x=
	1771269492; bh=x6H82OzAohnyN19364JGe1izIv70m/IuTOUlXgxlP2w=; b=R
	j8DKObvjsHieiP3TuSVgCMU7uOimRLxKhFx1ppk7bFFhHdiXfwUJZX3u75dK1RHx
	tec4G+UVqeV0DLK6kMIovGXmDzQofipZDYsmI1LKCtRvp2mgtRU8HpO1suZsT0av
	d6WhRoAag5lhSxK44oBfXyA8OhIqHV7gZ8TvvewL+NZPv9KO2o/1dLHGEwasvaNt
	uKBtq20SqVci9Ef6ihthsUxYnXPWm0nlu3L8MoqOgEG0n1Oi3HUzt765gi5wHLfH
	kPtP1BHiTHRma/tXF+PSpMSxMAMbaoIb0XJR2Tii/pNNy2ayZapeVVEsh1Ep9CpW
	W6UtjVGWe6IQwLWyZkAdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771262292; x=1771269492; bh=x6H82OzAohnyN19364JGe1izIv70m/IuTOU
	lXgxlP2w=; b=WFNIP4dW4IVCOA3M01io30FMtICbVmGiJzeyDxFCrfzHwlQjmhe
	rRqdQZ+UrC4KpP/NMBEUwpCPM+75ObU4bjr3Gn/qQ9/gdJJv9ZgA6+b8FTZ5K2Ff
	+4vM9mOCDcJArlExxb1KVppDS+0bBcy7llqY+pWnNkhsEDADPvLosF3SwFaGYePX
	rlbA++cbHZfRo0i+0H3XmrfADWKDjo/D7L9BrAO2VBKffK0ZvtrlUyOPt92++gA/
	ucg6MG/SPxudiSDICUD8bAz8VN7WB+21KXWKmY8Oabxvl/K+5NX5n/2bcJV0IQ02
	3/jRwPeZUbH5WMV6kMbsm45++VveD4HkvRw==
X-ME-Sender: <xms:U1GTacTbrk0n9UX8CGhGg_XtM9Zo3NyBmZjqE5rUhbFZEbLch7Zh4w>
    <xme:U1GTaeqd5r-6JSUbPpPMnQ0-7Off0Uy_K8LvmIwd1_k4DR7W9MCGVfBJaqWxZH18R
    OQtRe5fEipmZ6hk8JOwH36qZqzVAMuuMumMTFioUcs6OwJWukYivtM>
X-ME-Received: <xmr:U1GTaXaJ9b4J7z4IfINIeJ3AJRi_Ab3HYXdO1zwNo2m8CP0WBkVmQlvUIkkj5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudejgeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopehhrghofigvnhgthhgrohdvvdesghhmrghilhdrtgho
    mhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkh
    hpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhorhgv
    nhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrd
    hhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhu
    shgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epshhurhgvnhgssehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:U1GTaSFbdgGEUJESjW7-neUpGsnJdm-icbauJeL1nvulpt4xHjD-cg>
    <xmx:U1GTaUrM-DF8LFFU15yI-mHKeeC0N_K5Prn64WnuzzOLOKqbS0eNCw>
    <xmx:U1GTaem-2xxaegCrCGofm9Ncaf74T1sKMi1ke2HpSrbqZdpMdOvOlg>
    <xmx:U1GTaRvfngwziyZ2SvZJuhVr17Sg3kTBCbTjIyKsoIH6OFOUEMYoag>
    <xmx:VFGTaZ_QtrCEWG40XRDo8YnyUtHU1VOcqMZU67t0_8TOdfCQb1X50RpR>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 12:18:09 -0500 (EST)
Date: Mon, 16 Feb 2026 17:18:04 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Matthew Wilcox <willy@infradead.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZNPE1D2oj-AvO9a@thinkstation>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
 <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
 <aZNJZTiRt_vm7oKq@thinkstation>
 <aZNNf_OkH-4DXDR0@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZNNf_OkH-4DXDR0@casper.infradead.org>
X-Rspamd-Queue-Id: DEE67140008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qom5eim5yx9wkewxxyfj495rji6bxqta
X-HE-Tag: 1771262293-753920
X-HE-Meta: U2FsdGVkX1+5q3pxY7AzW+lLldcxTywoBL+dIoDEx0HbWAZrQN9JD8htl3s1uUK4yTCtyr7fP75zboV8DsmwMlRKGC/XW/g147fVV6w4ZOsldrrBWb/8mWLH5CvKG9TQ6cjny+CkfAgMH4VfC6GhSs3nVGcnVGj5z8usqizprkujHjfcGWoA5jBJb8n9JYq0s2XWa3xMzuSxb5lk7A7IgctHA2rqVJ8io2ZlrWcI7HV+LpBC7uFjMllyzKldwwiMNV6GULcYFXTCVaDpCCj84awF/PT8whIjrCDm7IsTu3QEWqB3jzUhT5mHV9fZTJBogy/zQS2KiJKX8mGnU8Sni6AAmuegFKVKrqI8vOVjxXgGC59eORoX4yzfom5HGhZlfsZFTZvC3fQDgmc4xwWzGzgD37aSAFYwj4EvqZzfqmiEns5yLBcdSCohYkdHxQaE3Pa1VWWFiuE6nO/+gOvhhs9TqfzV0BNI4wbCpMUIQ+58iAqwQvhgkcoO3O56I+lFs27pvlimyuwE5S0LZv1ZtJm45MiNbLxylWKRaQCsd64p/m0j3zSU0xPlsL4C9OqWT1+3x6JOjLlNUiHc8f1AvMsBgcqxVWxaA0Uhv2a5z3tBrnhkc4QsHMGoQ62EMXJbH1cE6xd9WnfvAIat2DO5bkd8reUBiI+7aNbK4Q6damOPhmaxQaJLc35TbTkErrrM0TcnYGQX8SEbWlDokfDhHy/nZ15xTFejWwRmLX2bM5pxq+nzkc4Myvi+YdlPVBOFHxQzuZI53Cekca7TxyMrmskvpeUQos3B6P95kb/ZcyLTIq9GR4dsbSkG+u1SfT90yBKoCL0sR0X87d4XquQ4JBdUbaFEPrgzjTFHOHJvYzAZ+e7hhV55WAxTvzdYWWWOJsql2es9XrJnSPfZkS8l9rfrEoPJf+o+NQs0U+dYEgcEM0W7/0o2BdbXrz7TDXoA0VF346u63RkFh+NGp4B
 zshzWmi0
 J3STTeHUkI+Xleiixk1kH1FOhOAuuKWGcuhpCALX1e2C9a5dwPZX+Y9yzl6fRTBr4hl+9Lq2WfBAOUou3VOO3fiKhTabUQ5hbtwdC4JoTGuySUfoGZarwE81VZk+m81h2+cv+CHoOow07PqCQlEMjArSTV9CQlPW+3gqrdFeb6bRXp3qL3whmOK31IB1odHvraDutsPDek5ousFcxh5BMzp8Eoo2CBOI+Pq9uLrllN3/CLVt8wlcQRD1hmYZZfvzNnin7OCRAxvs45nfgTxAQXTazoxkedrKF9rU0PXD9pw9steIU763ffpR1yrd69l+tq4tpNGF0ytBJZ3aBWSsCzmByu5nRaWVOnZ/eiVjPH7QcIM80hmdfwlcOFiltIEk5Zj0k9UBx41J3DhcgjhfhNTWIe1CkZkfhtguQjqfLXJPjYvP26jtADeHzapYubM7zL2Hn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 05:01:51PM +0000, Matthew Wilcox wrote:
> On Mon, Feb 16, 2026 at 04:54:05PM +0000, Kiryl Shutsemau wrote:
> > What I would like to see in the kernel is a syscall that return the
> > memory stats in binary form. Something like
> > 
> > size_t memstat(int pidfd, struct memstat memstatbuf[], size_t n,
> > 		unsigned long flags, unsigned long start, unsigned long end);
> > 
> > The syscall will fill up to n memstatbufs, one per-VMA. What exactly
> > filled there defined by flags. The return value is how many memstatbuf
> > is populated. The caller can call it multiple times to walk address
> > space it is interested in.
> > 
> > We also can have a flag that mirrors smaps_rollup behaviour and collect
> > all the data into a single memstatbuf.
> 
> But is that what we want?  Let's say a process allocates a 2MB THP, uses
> 12kB of it and then forks.  A lot.  Now all children that haven't called
> exec() see the wasted 2036kB.  Would we rather have something that scans
> (say) the LRU list looking for zero memory?

Are describing THP shrinker? :)

I don't particular care about original poster use-case. I want to see
more scalable way to access memory statistic information in general.
smaps is slow, because it collects information user doesn't care about.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

