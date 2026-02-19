Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98CE8C531E5
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 22:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B029E6B0088; Thu, 19 Feb 2026 17:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEDF56B0089; Thu, 19 Feb 2026 17:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB146B008A; Thu, 19 Feb 2026 17:14:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3F46B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:14:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DB731CBC1
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:14:30 +0000 (UTC)
X-FDA: 84462611100.24.C513A66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4411B4000B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:14:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RrR/Q2Et";
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771539268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROAbxhxVhE1AAoQIrD/mPhLbLNlbM7C3cinOzp2fOoM=;
	b=YpicpXkHpTblc0RMPifx+reigSvonLmrQRKeTOovVTihKmi9exlc1Q8Pvqq4DeR3zo6v6q
	yuGTLn2D7H04uiqZgKnmhnIU7ynGenAhXN5yB2zZckR4/x7sR9+y847UgDDl5ETEzYF8Wf
	6uLPTUJmiJ50lNiliZPMIrpfZ+2qt+U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RrR/Q2Et";
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771539268; a=rsa-sha256;
	cv=none;
	b=8r7sC1JLFljCaQi0NpOBh24KPBBsbm922kSmtAoI4AWOtPb1Fi1BwdjdrXOORGqPx6JKu/
	5uMIwIJsWJPlu6279esXlH+HrKzFh3eff11Kfzrnyq1np6yLXV1tFsd5OTip2aZ5Ho/Lrt
	UO+ODRmfdabu9BeA63HxnHnqf2Yc+9o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 788E060131;
	Thu, 19 Feb 2026 22:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C546C19423;
	Thu, 19 Feb 2026 22:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539267;
	bh=Vh6icvfHV2ATgzeZ6D4jLG24kTd7OyiZdBtMQB7ol/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RrR/Q2EtGlK8YrD+hFwZEeYIXTSoS1gViybI42xksLf0GgiFuAGwSXtRFtOB1agZs
	 rRaJ/4bvnZNva0IfVfH6I1ei+cE1is1xvppEFm+o/IWIVnepxFMV1tKbU+Q41OfXT2
	 v9koXDXChbNiUXgqWQLbDaS8NgeTzknWVicIocdw/9GATlCe984PzUKF4Lak1xw0NR
	 WAj+3IY2HAwInLync8ieBoSJDYgm99pBjRsejG+1VC45dLdehK1snXBiGSKO9RkaYD
	 LnLhA937wzd4Rb5exPUQ7vvTf/pJCFTmUtD3+d2YRCzlN48yVnYNAMfBxc/L3Hq1wz
	 Wre7R0+hwdN5A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7F47EF40068;
	Thu, 19 Feb 2026 17:14:25 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 19 Feb 2026 17:14:25 -0500
X-ME-Sender: <xms:QYuXaZIjWLYdmwbZbV1GMtur8MbdsVb_sCydMwFGEJEL2r-TegfUBA>
    <xme:QYuXaRnSox3WWZ2XZ8W169gMvUEynFAjXSOTY2dyZfUBX_2KL0YzhVvgKlk7VpYLO
    BH7but1qHj1oiwy0STHl9GaS8bE6IKlUuAh53Gxl-MWvZzZuEylLHs>
X-ME-Received: <xmr:QYuXaY81bTVO-v7XJ2fsPRGRW-vCUvqMnmqhJgN5njB11urLq3llt5_-zqIv2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdeijeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheplhhsfh
    dqphgtsehlihhsthhsrdhlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphht
    thhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopeigkeeisehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrth
    hiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgoh
    esrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:QYuXaQ5kx_xvZ6IEeBTXnmUD_E7JnisVNkXgXxjGAFZXMUo8Tr4dRg>
    <xmx:QYuXaQqTlXlOGxtOq6e3oF3llEea8e4ulZzApN6tZXZw1ZBO-GtiMw>
    <xmx:QYuXaUCOgrYz5LroekcGgw2ljFuHM9RzJNeYmGAmy1dyZDmkByvyag>
    <xmx:QYuXaRMGRnkhTM9RUit03wVklw2-dglKqAODBKCh3Vqf35Bx9KOAcw>
    <xmx:QYuXabkqlEFHIhVGH-DprkvdRFUf6dqanFO7LyeKW7ZJIacuAB0WT0gS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Feb 2026 17:14:23 -0500 (EST)
Date: Thu, 19 Feb 2026 22:14:17 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZeJP-GhoqeTtjRe@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <b0c7cac9-1c3b-478d-b274-c06f4e58f356@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0c7cac9-1c3b-478d-b274-c06f4e58f356@intel.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4411B4000B
X-Stat-Signature: xszpaue5w5bqszxr7pdoxxiymo5k4q58
X-Rspam-User: 
X-HE-Tag: 1771539268-983187
X-HE-Meta: U2FsdGVkX19POWwEDFCrqoEhPs2O3E4Q+nQayvv1NdSE7bQowvmrTSuz2EZGBw1vV5GqUO48TgGOcBMa83poovSJ6GJZKm9vhWe633SBDokFrEkCJg2Qn8m8o//IgsnfmNJRsgY7d9Avm2FY8cEECDYcXOH31TegnjITB/px0ChnhLFXg27B9A/1D4gpquYuIaY33/Xqw6LDY+YJryp3eIdk04X2GnCsso0X89b/LVXWthA+bmz1mGLn+Eqo+VH2geBNL4eCMC07OpOydTnav8ML3jF6I4UrXppxYycPtS0CCNOwbNpO/ZRFWnE8w1A7tvHfqkwTJQ3SPZ07nxbPSkyv7maheWTs2z53q6v9CgxZ1/AvPVp8Yc8XtlZk1r/tYbBGdSatkRO/RNzY29VUf9fHHHlP7MyofPjGHz4Wu9NeEqPyQT2zn6fv1110oZiGZy+2GGXYUeSP3uf1cqHlzNvtKjiKDDXFFv9TbbClgyYSSve+KvvqweyjTto/+TigNn39mgNdAIH24mSrloaiXJWDcGYd+pCJshN96h98KbYlToi1hQIhycpA2NNEPxV48qy19MX1AkgErUNRFMJMm/WYWSrOL152Y8A/+iYaZPaKToDwCD/RMeEKAdg1MRFlXNJCIHtQXhJsvTgid/uebNggR0qq6CkpTYcB4Kqlw4ToXtU8sb1U4E7dQbO6l1fhFCh+SgnbJtHUV1WCWxUNPw9fG15biS4v3lEz1tNkvSQoiStnB5+NmiRJtiSrwnCL2Qojkg2yKLFiWrRADW1q7Yt2w/p2joBqDbvw25LyqLbhWG/c8C5zPwXHA1M/gp22FQa1Wy7KGkH1iVeDN/kBv37ghtCrJesYK/Sh33ojjX4/phjLoQX3SLegydJHjWX8ADJ6hkhooVsksEEq5ARczoM7C9ARKFL7xiT2wC380rd/fnxSTvhCGULAzf58vyHccQ6aD6eU+Hk/H5EoU3I
 5k1LT/kF
 20uSDZDUPPxp2Hwd0hWb9puEETP7BTAyxv9FfgH6LIqdZtqkglYUCqXP9HzaB/2ZentLa06oLHj0KcHR91gSjShC0OCNMf4++K3jI3gAJamZkMM4V14BRX7SFsTvxSZxVXt2w69L5R66zROXNx+uqYbsGjxfU1fawj+Pqyf5OkSQqnYDtD9hYyhf5aVtaVI2Hz9+uSZ4BouZEHX20HVDTkJhz4iNy32Fh+22LtKkdfKJkkfWYAoqbU78r7SCTHYV3QF4vTM4ti7sLOjWUeC/DBgb/Tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 09:30:36AM -0800, Dave Hansen wrote:
> On 2/19/26 07:08, Kiryl Shutsemau wrote:
> ...
> > The patchset is large:
> > 
> >  378 files changed, 3348 insertions(+), 3102 deletions(-)
> 
> A few notes about the diffstats:
> 
> $ git diff v6.17..HEAD arch/x86 | diffstat | tail -1
>  105 files changed, 874 insertions(+), 843 deletions(-)
> $ git diff v6.17..HEAD mm | diffstat | tail -1
>  53 files changed, 1136 insertions(+), 1069 deletions(-)
> 
> The vast, vast majority of this seems to be the renames. Stuff like:
> 
> > -               new = round_down(new, PAGE_SIZE);
> > +               new = round_down(new, PTE_SIZE);
> 
> or even less worrying:
> 
> > -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> > +int set_direct_map_valid_noflush(struct page *page, unsigned numpages, bool valid);
> 
> That stuff obviously needs to be audited but it's far less concerning
> than the logic changes.
> 
> So just for review sanity, if you go forward with this, I'd very much
> appreciate a strong separation of the purely mechanical bits from any
> logic changes.

That's the plan. That's the only way I can keep myself sane :P

> > On x86, page tables are allocated from the buddy allocator and if PG_SIZE
> > is greater than 4 KB, we need a way to pack multiple page tables into a
> > single page. We could use the slab allocator for this, but it would
> > require relocating the page-table metadata out of struct page.
> 
> Others mentioned this, but I think this essentially gates what you are
> doing behind a full tree conversion over to ptdescs.

I have not followed ptdescs closely. Need to catch up.

For PoC, I will just waste full order-0 page for page table. Packing is
not required for correctness.

> The most useful thing we can do with this series is look at it and
> decide what _other_ things need to get done before the tree could
> possibly go in that direction, like ptdesc or a the disambiguation
> between PTE_SIZE and PG_SIZE that you've kicked off here.

Right.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

