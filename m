Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60BECCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 19:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CB88E0006; Wed,  5 Nov 2025 14:25:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14358E0002; Wed,  5 Nov 2025 14:25:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A378E0006; Wed,  5 Nov 2025 14:25:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1AE68E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:25:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46F3A4B2F2
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:25:42 +0000 (UTC)
X-FDA: 84077532924.02.9C63CFE
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 49D2920005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:25:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iTmrCzz1;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762370740; a=rsa-sha256;
	cv=none;
	b=8D/Nt5SqGQfrW0UWkllNCA4HOh1p+yROBu99utAt1+kjlbz9iyLZwhat9UTZwmbfAQd/XO
	IqD725mGYIWjLxOqDDINQfDIaRU7l8GuZdLQpMs5L9J/d6boeQEQDYqOkEso3nIivKvtcI
	mNddDNRk1O9a+QPBiTOGzdCFBZpQLQI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iTmrCzz1;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762370740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3c7ISS42F3tYlBvNOZmQXpwFtE1e4tCRa3nMbV4lv0=;
	b=V1w2oR4PiADhzt+1lO3NlvNZYIYZwIm8WqO0kIjllwadnYsowJZxvmBdaG5ttNCX+lv7sO
	GueYwpp4L2F4L3X3LqPGPA0TcphRBqWo+G8AQ2vKVJ6WM7C8kx+AWzGzDCchq4VpSDSqc1
	qtvea87L6M0pp4ccrt4onkTRKNSkLbU=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b145496cc1so22096885a.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 11:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762370739; x=1762975539; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z3c7ISS42F3tYlBvNOZmQXpwFtE1e4tCRa3nMbV4lv0=;
        b=iTmrCzz1/wXNnPA6sJpWorma9YywmfLoJ/yGeJyQBicnsLHZTF/PTUwFeIFR6wu2IW
         pkENF8UcYrpviLCQ0xo95Qh84XE8N4mo2MZRTWM7kn+5rxDEgIXV+wi0muuM1AON6Zd2
         C9+F6s/eOJmrnxVfKKNVm0mYlgYalSXKn+00C2KeMm+QgkD7htc/X0z4G8/LO2P+H6KA
         /8puRjlQ3s3dio3jZfdZcdSkeTizyxMB3FZvYoS/BGKjJfUhE7RRCpFBDT5VEV+WTIdP
         x8X6Vc6dgyrwfwhnAgRl5svfPDAATsghWcEO5rzCNSBOLoktQnavDNoFq1F54jeA7GiI
         +TLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762370739; x=1762975539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z3c7ISS42F3tYlBvNOZmQXpwFtE1e4tCRa3nMbV4lv0=;
        b=MkuIqlp+7+vEnFv2eaqnsnK++ugYULpW/TLfhx3qo8TNh2WIDE5G0cMU0sKI06j35B
         9XgZP3q/qPiDaEodBMo439HjZQq2PVkSmdApuy/LKgxTFjFimQefvUHvToM6dl2U7igz
         Y9GARtMickkDWTuTnzyHZRHfpphbisAHFWxSTzyJ1FInMGkjvkkQrp4nxSd6AflJDuq9
         1uvanhrbq6aMoNtWwCkvZZoK6S0XcxmdJ5v9azkG54Asstq7QbyVZP1GA+/Pvq7y9mRm
         4/i3M7FCXvT5RFKSmHZVhvWpVh8KTB4wkZTqjJp25h9oSjBEfLAq6D5a2no1VUEs+VjY
         7grw==
X-Forwarded-Encrypted: i=1; AJvYcCX0smMfl8vyuV8RG0xvu0X2KKIE2AHmNej3ewzpxyz00FyiXefuATv1LZLDe67YaPV7GmZk3IzCBQ==@kvack.org
X-Gm-Message-State: AOJu0YyFgBXX2uRncwmg03NhiMgwsLCSqzuWK/nhHaj+8JE92CeN2azR
	jyVw4ZHeROdxCfb20jqVEgkv9Kgne54ecchNrD8cRQ7rbdeq1meuVnCdSZ1Moh6Vjvo=
X-Gm-Gg: ASbGncsBxWwviXaIcesHtrN/AVWcTOgXAXx/IAP8ej6xI59bhBbfXv1kwi5U3g5Owlf
	RS7s+cz651JPpLs2X6GD9ogtts+QmLZEKi1nfOClQkg4AkC8F5WUNg2Lg3SdOejn5c4XtwNJqFF
	36XFiVNtrln4/mdozxAk9jGOW84TpVmAIDbscUgvrvWdBjtOE1G5By99pnXV6oyxfTp4BPzGZwL
	czRqADQCIUhGD2BFo+x3NcEEBOBUBseF4Obc275tXEGKQfTBer5s7azL/SKRFxB86hKvwBMBGh2
	mwv+1sUxtISbHv/MRzJzCMfy9t5qX27o43kqT1y1WXz0mxMs70pXuaS9FL27ZNkM7Iyms+yrBgl
	x5gf0iqGgJn0yaCGDnBvbQLypnI25XP65svvpOoO3h1/hqxxO229orTZ2z267rgJjKSLS5hG9iF
	+U2jOMLukURcTYXl4yAoMCfIo9lX5rfTSdgaLTg5uM5UBxD9DfJTOVf5IFpOE=
X-Google-Smtp-Source: AGHT+IE93lZWq2OeBwVItF8pvYDXcfH6WZ0IIQ5p6JNn6wR82KcxAzEptz788KT3rDLJ0XOoUhNeCw==
X-Received: by 2002:a05:620a:4887:b0:8b1:a624:17b1 with SMTP id af79cd13be357-8b220b03a22mr560424085a.27.1762370739005;
        Wed, 05 Nov 2025 11:25:39 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2355e7208sm27162885a.18.2025.11.05.11.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 11:25:38 -0800 (PST)
Date: Wed, 5 Nov 2025 14:25:34 -0500
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
Message-ID: <aQukruJP6CyG7UNx@gourry-fedora-PF4VCD3F>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQugI-F_Jig41FR9@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQugI-F_Jig41FR9@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49D2920005
X-Stat-Signature: meefpnrq5cq99j7arjf1xriwysrxesfw
X-HE-Tag: 1762370740-631129
X-HE-Meta: U2FsdGVkX1/HWjktlHk82zch3aFjva/Uj/zC4lkFZ6ezHAtEKxDE6ShgpaOcOGn+qJoolLOwdSMr5CgrhJ4dW46SBBk5Nl4XCSXuKfhTUVCHjbNEQ9mKDUHLfoUQk3jZHXEupLyG7RHiiCM5Mre/cWvCoVRrIzXskZtggtBfIOpwUJmv5gmFNEeMfBhZ0nHKKmsp4hQ1+una0HQwb2ufVsDrMWVl0WJaAd4/AHVm/L7DlQS0J8PsHlfrGCiJkmXB//WI1SgEHaQYPUbWA66mpWIrufKSxKK1/aMhee5lgB3fhG9sTC76IdBM/s3oWNg3TG47Re9L1h46MU8I01Q64qqKdvacyOEbpEtOEBvvWfg5kp1xJ6lrXRfRrSVuX+02rW7/PqksZw4nG5JGPmlQ/foKyY0+rsgHQcDYk4k0Hy7DcB5FzTyyFi2gJJal1nWCOk4pmEjm8rHMgdZMdlCooOPlW6Mg6lCF3zksNz8fJSQMNVB+jsWDDKZIH3pc+V3FoG6x41NhcRUGqY8PqYsQfeUyK9ct2M+HY1mAGYpRlp64oOfy+brptHKprDv37f4QLd072qtnPgLi/bskh3Q+NAFksNEEIc4bj4YNrgQ+HoB8q3Ny6l2JTX16XVVJntYhLZz5Dmr/7U6QWXyKQqSgKYUAjZohnNsCRt1bhGGvCQIxEngX2/oEVR5ePuGc5Gun0cY3dmeaKBQG6OWP/1G1kYCqfPnnn8RkGR7rywUbR4I+LW+AJSmBN/TwZmgXIVksGFOXWJ0zeVV6A5Hkq+ZSi5hnw+WJv4682es5xb/jeWRHCv/U8GHvyd4mAA7LSSwgIEug9x/l8pYOOPrPuWLO0/N7ixRGhjGlwWSD1D0rWe2SejokVsNk7C5BRfJK6DRmDEHchaLxMPVRZ/I06eXhVJx+qubaTeXfaA5NCK7afF7P/okxZsU+Z3TbdXUGusJzUKsZ9wJdj5K7PJlIv75
 qLLcUWmS
 q8AQFE76I+NcVN7JcvDtc+tkfYr1OxjVvpibouS7U7ORAzEU5tfzAKBM0WCgte5n4nmDutXv+wMJ/bg/oMD+zWbnDdaiX3D7jzQLIHc0dpnWtSbpwWdP0LPFa5DKdEN4xrrM6VdDw+E97JvLhCR+T+RKoaU6s3cmyhMDc8FN9Q0KhZZ/q5Udp2r0uZotbZXTUwx1j6uhxexYcCf5Bk33hDDuRlZ4S8m7IddGM1KUgIK28fxbwD8O4tEDqHTVPcw4trhdXFAmUF8/aqKg7NsvOAgC4iY245gS4AASqVtcAp01sAyd4+A/bmNjZcyId41EAWBZTm5wpULdV8O441/DQtp6a+Ld1sTp7/3Lm43+KI0Tnz65ylTLCfXmRkWlZXiGJmeI8ik7n6meJyCzum6YhTyUbGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 07:06:11PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
> > The kernel maintains leaf page table entries which contain either:
> > 
> > - Nothing ('none' entries)
> > - Present entries (that is stuff the hardware can navigate without fault)
> > - Everything else that will cause a fault which the kernel handles
> 
> The problem is that we're already using 'pmd leaf entries' to mean "this
> is a pointer to a PMD entry rather than a table of PTEs".

Having not looked at the implications of this for leafent_t prototypes
...
Can't this be solved by just adding a leafent type "Pointer" which
implies there's exactly one leaf-ent type which won't cause faults?

is_present() => (table_ptr || leafent_ptr)
else():      => !leafent_ptr

if is_none()
	do the none-thing
if is_present()
	if is_leafent(ent)  (== is_leafent_ptr)
		do the pointer thing
	else
		do the table thing
else() 
	type = leafent_type(ent)
	switch(type)
		do the software things
		can't be a present entry (see above)


A leaf is a leaf :shrug:

~Gregory

