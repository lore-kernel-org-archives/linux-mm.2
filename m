Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1BB9CA5FB2
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1DC6B0462; Tue, 20 Jan 2026 11:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19A66B0461; Tue, 20 Jan 2026 11:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3656B0461; Tue, 20 Jan 2026 11:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD636B0461
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:45:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D6DCBA9A9
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:45:09 +0000 (UTC)
X-FDA: 84352917138.27.CFFFC54
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf28.hostedemail.com (Postfix) with ESMTP id A7CBDC0008;
	Tue, 20 Jan 2026 16:45:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=JYzuEOUh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="f rzTFRD";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf28.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768927507; a=rsa-sha256;
	cv=none;
	b=pW1aUCyWnJASaenB9MMu7FKC2aHRntTRDbvWCm3aA8xipn3ekMK1NbC7kYEBdFAKEGZbnQ
	ppWE2tX+PusoRvN7DRNGXEq3TosUBMUXYD42K+VbSC/n7dpQMfutavxez1Ab/bcz7ebrOi
	osw0kumdRTne4FJyW8vCU7jZdfBjkWY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=JYzuEOUh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="f rzTFRD";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf28.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768927507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxbkJAISpw9hnpQ7/ITBBIUz+TKq+iocNACRaG8UpNs=;
	b=PS9SPOxFq8Mev3QUzOaw0QQ9q1/8zTrp88xgI8J+xTPANtI/3d3DRzooI4cMbDoPGdUV0A
	l3VxO3ZTK9EPnG6OBqeOc4OYf8pq6Bxxtnqx1eTDJL2J7kV5YTi7RBSxOSGZbKlJwjMkkT
	sUoUCtyFHkmat+AsmR78QkSbN9zYt8U=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id E24ED130057E;
	Tue, 20 Jan 2026 11:45:03 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 20 Jan 2026 11:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1768927503;
	 x=1768934703; bh=nxbkJAISpw9hnpQ7/ITBBIUz+TKq+iocNACRaG8UpNs=; b=
	JYzuEOUhs7BSA70yPbTmZhZKhTbH/ADMZi2ax5TqT7lcGAFriaSuyyaDaU5nTf3x
	+09vB87UXY+hZY3v2o/WNSAnVH6tsP10CRzaZCPNrhYvbpcXUcWUSveZnFax66Ch
	FtndQmJsOHFb09UzrT6vvomrG/IcJhm98nh/dMcgUWSSXfzb9bMoobNqWn5VgdSV
	1LdtIcIVNKTfqGnvx5zSI6Rz6PaQ7Y9dqGROLp4XXCgCdZ4YWCnnptCTWUrM+y1l
	YVBqiWDdvFjvDqhMhrmffdwpOy+zapkF3a8Vaei1MK7ki70qlGsbf67rJ4WfxMZ/
	XrM2F8JiTn9xlA2vCSA+eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768927503; x=
	1768934703; bh=nxbkJAISpw9hnpQ7/ITBBIUz+TKq+iocNACRaG8UpNs=; b=f
	rzTFRD98s4ML1kFz0ZuNaCEahk63ybh9i+skNv16i33sOy+VgGxiRFaEbZ2qBD2a
	l4oQkYXYskCApqJgd6z6hd/0DFnfK8w6veqI2OHLWdSGbRz5Ugw7Y0FxvRff/yKo
	9RC39yuhH+ETdSDjSbQXtLYFV7/M0B8ymqhu45pK9ozvJ/J+hY9M5pX/3jkVgo74
	72ULti4MBqcSSITPjoRqrm5qK/62mHK8ywjR3WicIcHbq5cZdrHZB+BiKEaizuLd
	nJ53i9QX8c3iGEM3GvsjEQ7aWEwYfLFKvpxgozxiQjs2zEHHzCrK2kweOyw9gUX4
	Ip5Qc7ftYKML2PUn7Ntww==
X-ME-Sender: <xms:DbFvad-y4_VjhVs77RBd7e2pY-ZcLLgasR1MY2LSmUBpz3A4UBLZSg>
    <xme:DbFvachWymeg3bJ7vBI1mdUu-D6J7mXN3BNx9S6ug7vEBtmrsuNtcwifre_gWKzY1
    poogfs_ABul0aFO1aDg9gy5-SDAiDJlqiYtFT0xBUxS0S9U_xJ7hDa0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedtledvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:DbFvadMiRgOINFK8wHyKXD8qi5kjKPO71t2BL90azCwJySDh_zsTHg>
    <xmx:DbFvaYXuB4JsBXLfovj2wYtVc-6pdCClTxiOZZ_C1RgIgb7G8251eg>
    <xmx:DbFvaWhSf1ci25yXTlxqnHAIzTBmyBDAOJgUEAooXdMFoa2aUgAbXA>
    <xmx:DbFvaeSP_uSeOgOJ08CGA-Z04k0eHpJXNKsL0rA5j3yQv3xRTJIfOg>
    <xmx:D7FvaezJleQUG4RpnrTn8YPiNMfKmP9ch-xJba_Ev6HQi64jxkfzWxEY>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 13CA1700069; Tue, 20 Jan 2026 11:45:01 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AWSx1lsrOtaB
Date: Tue, 20 Jan 2026 17:44:29 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>
Cc: "Jason Gunthorpe" <jgg@nvidia.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
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
Message-Id: <9ff58468-a72d-4984-95f4-d0a60554705d@app.fastmail.com>
In-Reply-To: <44461883-a75c-466b-a278-97c4ab46b461@lucifer.local>
References: <cover.1768857200.git.lorenzo.stoakes@oracle.com>
 <baac396f309264c6b3ff30465dba0fbd63f8479c.1768857200.git.lorenzo.stoakes@oracle.com>
 <20260119231403.GS1134360@nvidia.com>
 <36abc616-471b-4c7b-82f5-db87f324d708@lucifer.local>
 <20260120133619.GZ1134360@nvidia.com>
 <488a0fd8-5d64-4907-873b-60cefee96979@lucifer.local>
 <1617ac60-6261-483d-aeb5-13aba5f477af@app.fastmail.com>
 <44461883-a75c-466b-a278-97c4ab46b461@lucifer.local>
Subject: Re: [PATCH RESEND 09/12] mm: make vm_area_desc utilise vma_flags_t only
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A7CBDC0008
X-Stat-Signature: dgcs7bi3xk8xjetsnx3omhrkwn7eobby
X-Rspam-User: 
X-HE-Tag: 1768927506-469579
X-HE-Meta: U2FsdGVkX1+vENRc3pn8f3GmVgziSMlraYKS2RNSn71JYBxTCXVi6fiPG+cncJyrgsmYvoNWjSHHEPqygPKqCfueK8sRzgOp6Bx+IxArOVXkE2BE6lYgy8Zkns75gvSS3ragi88EgnJmnd0kgBT+Qjk91483SAf6x46Bi9JuHllhUkcGuotyyiwK1TE5fh/XZE8ruh+yQH0+f/Pn0rp9HlGJ4joE8VwFX8Z5ZzquxeEWDthrXpWBE7dpWUlcu6zU/Hc/fh9Sk2tjvo7aiXHMXV+yiJ4rtc1tMBKYsrlp3hQQRbF+iKIeCKyIE+I5Nl4IhuynxCg4KQlfHUIrhDQjJpfiPXWjXxVDxCFahSeo4ATD21zeq3py6FTk8SiMyUs8/g2/0sDIWo07uitLVyUa5EW7c/1iQMQzKIjmgqtn/5CuM9zLd7dqvWacNM4FP/iPAzorLQDtsB+tH+/hekJ6y8MMfd7DZp5JOLdHktT3wcAl882kXUosLP3gGZ5iZHmRuyhoa6pZ2MuOw7sYqJfkoB4PqV/TnluOT9O50SlrnKKHLH5u/zCGG6mc14mrWakomt8sk879IbtoU3MsXKz6ElZP8qhiwMZaaWl8Mza0n27fxtcrdWtdr1tRvPoPpym03EIKf/HRbnedf8DVhtBdDZwA6m+A8amfn6dktF8Fh+9tvV5sKdauBGwkHCsqIV9lXivvc6J+x0YhoPqxsmgxHhtAsphlrTs/aJAIE2KsgSODZvSNA45GoxsKrQ5UabiUCj3bQQoIYAMiVBBJ4C+ZQ7OELc3cMSd1WmbUQWI+SAYMaFDU+XzBXi6nAAvTRxu+awVIeGF6ixMkVVlq23RLTO0sQPPX9lakHp49NPT5JYpPBMoPQ6KjfdhQKVVWVz0Vq5gAoyKzLD1nqwdi138Lc/gCOHBy1im6GrEsPJs2H8UrZ0wbiQldYQqdSQKhy1tBHSsXuRJxpfiJwxqt+OD
 LZPoveid
 o2DEqIAdIbfmOSFaCfukKzY7pQ5LC7KQGsKwv9poxheL3GyuUIRbqxHCcwrPzVcdOsKTFPFDFBDMuUOYZg0fU+nnthRhFauiaWooCAhRKjMxDIDM/v/+aEN9/0Y++NNK3Xl6pQKd95ahV49ErE88Q4VeJBWaA1Hj3N+ERED461/v+nO4HmoBdVh9L/DAibCVcbK8SKpxH5u5i3Hz2/M0ahl6yePQxWwWuO2bzfqg7ds6ZdrMwQoTGp5Yj5tO8mxUsPPQZqbvjpL7DEXV2yz85n6YqdABi0qaR6w8Kpkh3+32oxWO2NxTCaCkIrKgYQinh2+jcCB9nPFHHkeOuU9Net1MGAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026, at 17:22, Lorenzo Stoakes wrote:
> On Tue, Jan 20, 2026 at 05:00:28PM +0100, Arnd Bergmann wrote:
>> On Tue, Jan 20, 2026, at 16:10, Lorenzo Stoakes wrote:
>> >
>> > It strikes me that the key optimisation here is the inlining, now if the issue
>> > is that ye olde compiler might choose not to inline very small functions (seems
>> > unlikely) we could always throw in an __always_inline?
>>
>> I can think of three specific things going wrong with structures passed
>> by value:
>
> I mean now you seem to be talking about it _in general_ which, _in theory_,
> kills the whole concept of bitmap VMA flags _altogether_ really, or at
> least any workable version of them.

No, what I'm saying is "understand what the pitfalls are", not
"don't do it". I think that is what Jason was also getting at.

     Arnd

