Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04B5CA5FA0
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B7D6B0449; Tue, 20 Jan 2026 11:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA9C6B044C; Tue, 20 Jan 2026 11:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F017B6B044A; Tue, 20 Jan 2026 11:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D48126B044B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:01:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CE3A8C186
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:01:03 +0000 (UTC)
X-FDA: 84352806006.06.DA9EEE0
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2BDD52001E;
	Tue, 20 Jan 2026 16:01:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=XBhw8vpH;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="a cDOnxa";
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768924860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfkVnVcFie+8lJSMwr+BM1cQg1+WZ1F7itYYKxiYDxA=;
	b=I23MVqAnygEUpg0yQXs8RTY3HqWAUXuWFiT8LouiB0vh8FOKT862WchB6ML2iLnFI0W5+q
	TZRaqZf8/jErMGwdY5VchCLKxffwz6REvVzlYkaJxYNqe+Y0HbdgqQtQHKWyq4f9iM5ev7
	PW19aeeQ08Cl0KooLHYLz3IOSBujP3Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=XBhw8vpH;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="a cDOnxa";
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768924860; a=rsa-sha256;
	cv=none;
	b=z+YXAIIWXjgXHwQCX2EPiss5cPEGeG35AXfolbUcPf0rQjrEzKT5C/lW9CZk3g59XtZ/Jn
	52udUl/6JEU91aiKgkY97a40RPqBwcPSvP1QFkP5j/I6cfc+lcHggotrwbyHG0NJn241Dn
	tl6YaZxC1K+okSi7GfgzHTi2eG06cl8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id C508B13012BB;
	Tue, 20 Jan 2026 11:00:56 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 20 Jan 2026 11:00:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1768924856;
	 x=1768932056; bh=KfkVnVcFie+8lJSMwr+BM1cQg1+WZ1F7itYYKxiYDxA=; b=
	XBhw8vpHs59r2+MkKlbmgatXGr8xLqKbWxhufnJzeeLO47XeomMsHnCDejbMNcPT
	DmjSqjiuJhruhFrns3dgPrHkPpKcnMuQAz7iP+r17hbOj77ftKyWytChV6FClGCT
	Pvl/4yudLD8n8LJL7yivzlVrOZi2qL3BRC24xY3T/mzzGLjDjK6OuWVx6xOySPZL
	lWIP0nR9ylLt+EvZvaSbUx5jtefih23aEo5Z29L90IXLTOdCSWIhTo7Uqt2RgYnx
	higMVU2odbu9iW2yHwV449kikyr9QfePdEKvqlZPfeXn37lErWypvndYOx3Zku9l
	YijSMyhTs7ttcT/Qr81XRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768924856; x=
	1768932056; bh=KfkVnVcFie+8lJSMwr+BM1cQg1+WZ1F7itYYKxiYDxA=; b=a
	cDOnxa/wuwTklLDdV+76bvdlidGbkS1Q6hZdBCssqKFukFk9rYZJK/G7eUMgR5yo
	fBjKAvpbI4YUhTWrHB8idcOnNaYD1gsSqeHgF671IEFy8tnsEoKZWIeIoAH3QO5P
	R35Bo32gHz5QVb+8SQB10yZSlftUbWlvvQ8PpESTifFYvBllJHq9cjPhMFHEUvmk
	A8bUI3RzqDDmM/2lgOYX7AioRxhbRem49RgAuOpN4P6zWsauy3wdSZIG2Y9i8Q02
	dBz7r1wtebiUHfNzghPp83oLeCNcPsCn2VXe4CZmm2pyAklTS3zdOv8twVxQRdQ9
	b+HGQ6RdNqfQZL/ZtARrg==
X-ME-Sender: <xms:tqZvadJBxlICSkZr0Che6MrFj_NSr0k6Tp-M2TMCWwPqG_zllW1CZw>
    <xme:tqZvaT-GswImnbpC3wrGN3KDBwnDUuAtfa0qqGcY52L0KtpN-aUHs1p70L5IFMSka
    y7MJo8TfnINfphDIOnMDC182unKqnXjEJ77KfniTdNRVXhEvNGFCRE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedtkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohephedtpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopegsrggsuhdrmh
    hoghgvrhesrghmugdrtghomhdprhgtphhtthhopegthhhrihhsthhirghnrdhkohgvnhhi
    ghesrghmugdrtghomhdprhgtphhtthhopehrrgihrdhhuhgrnhhgsegrmhgurdgtohhmpd
    hrtghpthhtohepuggrvhgvrdhmrghrthhinhesrghrmhdrtghomhdprhgtphhtthhopegu
    vghvrdhjrghinhesrghrmhdrtghomhdprhgtphhtthhopehjrghmvghsrdhmohhrshgvse
    grrhhmrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhm
    pdhrtghpthhtoheprgguihhlghgvrhdrkhgvrhhnvghlseguihhlghgvrhdrtggr
X-ME-Proxy: <xmx:tqZvaQPkwQELCWLxS0eGQnDPEVgalJQxOiakkPZt3eoZSVDUXRUZGw>
    <xmx:tqZvaePQC9dpWOrv7T_5dAz6ksS3i2WvKIe2oB8k-GAfqVIHGjyJjg>
    <xmx:tqZvab9h_277C18dTd_7qvM71APMqcEwztNudMLvcQ6IY8QJx4CIIQ>
    <xmx:tqZvaVYY_hv9CGGylWSKrdTnGIpAGF4sWfawPR3yNnLBUgSk1j7nLw>
    <xmx:uKZvaXzkTtmnoR-xrgldmbPzRvfWfcZESaXzSXDy4SbFbGOHKr4qtuUt>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A67DD70006A; Tue, 20 Jan 2026 11:00:54 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AWSx1lsrOtaB
Date: Tue, 20 Jan 2026 17:00:28 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Jarkko Sakkinen" <jarkko@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dan Williams" <dan.j.williams@intel.com>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Dave Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Jani Nikula" <jani.nikula@linux.intel.com>,
 "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
 "Rodrigo Vivi" <rodrigo.vivi@intel.com>,
 "Tvrtko Ursulin" <tursulin@ursulin.net>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 "Huang Rui" <ray.huang@amd.com>, "Matthew Auld" <matthew.auld@intel.com>,
 "Matthew Brost" <matthew.brost@intel.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Benjamin LaHaise" <bcrl@kvack.org>, "Gao Xiang" <xiang@kernel.org>,
 "Chao Yu" <chao@kernel.org>, "Yue Hu" <zbestahu@gmail.com>,
 "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <lihongbo22@huawei.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>,
 "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>,
 "Tony Luck" <tony.luck@intel.com>,
 "Reinette Chatre" <reinette.chatre@intel.com>,
 "Dave Martin" <Dave.Martin@arm.com>, "James Morse" <james.morse@arm.com>,
 "Babu Moger" <babu.moger@amd.com>, "Carlos Maiolino" <cem@kernel.org>,
 "Damien Le Moal" <dlemoal@kernel.org>,
 "Naohiro Aota" <naohiro.aota@wdc.com>,
 "Johannes Thumshirn" <jth@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Zi Yan" <ziy@nvidia.com>,
 "Nico Pache" <npache@redhat.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>,
 "Lance Yang" <lance.yang@linux.dev>, "Jann Horn" <jannh@google.com>,
 "Pedro Falcato" <pfalcato@suse.de>,
 "David Howells" <dhowells@redhat.com>,
 "Paul Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 "Yury Norov" <yury.norov@gmail.com>,
 "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-aio@kvack.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 devel@lists.orangefs.org, linux-xfs@vger.kernel.org,
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Message-Id: <1617ac60-6261-483d-aeb5-13aba5f477af@app.fastmail.com>
In-Reply-To: <488a0fd8-5d64-4907-873b-60cefee96979@lucifer.local>
References: <cover.1768857200.git.lorenzo.stoakes@oracle.com>
 <baac396f309264c6b3ff30465dba0fbd63f8479c.1768857200.git.lorenzo.stoakes@oracle.com>
 <20260119231403.GS1134360@nvidia.com>
 <36abc616-471b-4c7b-82f5-db87f324d708@lucifer.local>
 <20260120133619.GZ1134360@nvidia.com>
 <488a0fd8-5d64-4907-873b-60cefee96979@lucifer.local>
Subject: Re: [PATCH RESEND 09/12] mm: make vm_area_desc utilise vma_flags_t only
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2BDD52001E
X-Stat-Signature: jwoqss83tdhmsysdskf1gjw5cwho46b5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768924860-915694
X-HE-Meta: U2FsdGVkX19JXF8NX+N9y6dMf0rOvTDbqW8SdigvcGd6ThWbzs7nS+h4zhbwyGdrQeX+pj6oWH7SW88tWgOPO2YBjh/mLg2rrIeG8QNzX/HvYBxqNPX0qPuWK2BVMxPNME2lcl2DCkligL2OXMKt+g6fz1aq8F9MSbti3tpCqhKFGOpZzhzQ2+Ktm3tRiPYvNbj4bdQ+jk2ZMe9NWEyohKeFE78xvWPVr/QiZs6iLBP+GoEb6LS1DomBp5VD8Anvk5mZEbcpNneTv4Utn092A9eiKq0HFbD2LiPHAodqGASNeBxorlJz43P0mHks4rS9Cijt9vpE2I0YLLhPOh2TnByZ1T+zN8Iydjj9+pPFC2TUXyUqTSzZmjy9/A+q1kFtYytQe70/abNHjUMmRFafLmTIYG4lTTYrCHMYijhP+FWQwiZ0uIQZHRe4dzHT16Nc5sGgvgJC4vjdwaUeBSAkAHHt10mDEReZp4s7pGq/otvt9WaZNfq3cWjGNQ14KmmdZWwPLjXHcFq8X+Krxyi1dbw8BUBWRWanwAtz2Jf3sxlJqPsrVbREymOsnCruBDv4ma8gSFfFeBG4oxKhe7d6zlCHhqvhTHLaVQj60q7HlYvjxlsteifR6TRrpXPpDMxFsEi5tbScyVFvAVAKnslETN9BMhckAwErf9qGrtL6leZJRAJ2U88Vpwlb16vIEUbSJPr3dTBQMHABvJSPY6Joyu9RJfygTIYajWT0bINLChp1+f7zkmGigAHpMzSmRGs16BNdMYtJWY84zrmt7otR0YZRzd1CB9V6V0qWc9Yn56kTwsV42eZvQIhZ7Bw3Bp5FE5GH4GixqdMRb754Np2Z5P5VSNfml2dbbqNQFmOj6Q8uaVHiSa1gDLW4Cu6DmJdSlLSenTr4TS/A9bOz6SLQtk7SmTXbNqNrevlZ463D8tNLm0VvVLGAnHFU0eOS2XOz4tgQRvz8KPPZjIZGChQ
 GeSNVrdu
 MDFAieWpryWD1KiayY2FjdLDvZUFrf8mM8kwt1rpHXmqnewEzQZYb+zk7vIcpw19z8CURNxxhD8RcykDlkV45vHI25UPp1XJHHsEWHQdK1Ub/t5y7v2QR5UbOuP+wYt3RGs8t9hPiv+mTJSDz1oBF0Wq9/XJGyO2JYIk20sF7rLYIcj3nqceVCA3Ujl8bIOyTd0LbJKtAakPniAEa3E3keooomzwp31aTfzl8UgY5r51IGmCuq7dRQPzWRw0uBcPz7ooPyF/f2GTRM/zWRZRXImm/oGttgDNXxVM8AEWabhwGtiKD5Z5kRYM38yxVb8jtXOt5aIlNuGqX8OY0031CtXdo4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026, at 16:10, Lorenzo Stoakes wrote:
> On Tue, Jan 20, 2026 at 09:36:19AM -0400, Jason Gunthorpe wrote:
>
> I am not sure about this 'idiomatic kernel style' thing either, it feels rather
> conjured. Yes you wouldn't ordinarily pass something larger than a register size
> by-value, but here the intent is for it to be inlined anyway right?
>
> It strikes me that the key optimisation here is the inlining, now if the issue
> is that ye olde compiler might choose not to inline very small functions (seems
> unlikely) we could always throw in an __always_inline?

I can think of three specific things going wrong with structures passed
by value:

- functions that cannot be inlined are bound by the ELF ABI, and
  several of them require structs to be passed on the stack regardless
  of the size. Most of the popular architectures seem fine here, but
  mips and powerpc look like they are affected.

- The larger the struct is, the more architectures are affected.
  Parts of the amdgpu driver and the bcachefs file system ran into this
  with 64-bit structures passed by value on 32-bit architectures
  causing horrible codegen even with inlining. I think it's
  usually fine up to a single register size.

- clang's inlining algorithm works the other way round from gcc's:
  inlining into the root caller first and sometimes leaving tiny
  leaf function out of line unless you add __always_inline.

      Arnd

