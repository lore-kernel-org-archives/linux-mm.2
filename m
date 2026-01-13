Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E1FD2F34D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 17:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27E16B0005; Tue, 13 Jan 2026 12:53:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5506B0089; Tue, 13 Jan 2026 12:53:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6F56B008A; Tue, 13 Jan 2026 12:53:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA7AC6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:53:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C0CD1A025F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:53:47 +0000 (UTC)
X-FDA: 84327688494.07.D839F91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3B519140002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:53:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JUvOp/ck";
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768326825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjVRTs2Qk6LHbSsd8nhz7MHM9jV8ARi1zEYFEw3N844=;
	b=l7VZ1XEeDotzK794g4hVO69gkXEQLH9vOLr3uEf5eR4ECFr4c8ZOdwsKm2Bi7BX7uziJ7F
	Qy2+tCDKmTE3Y5kdLvJw7136TE4JnUUyJ2MfnLLOJ7BjiRorYQkFx9dPkWcBnURBZ1CV+m
	Rtbw0Y7HZsR0cQ4AcXOLfsWaHFXJ+z0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768326825; a=rsa-sha256;
	cv=none;
	b=afhvafXYsvtKNaGQ0mg1g8+LI2muGu4jlfZrVJKrpirUGyfzdYZSF6y80O/foH8hiAxSRF
	MKz9zE3BgsqLLJZ+QgND19W7/4Y1R1Uqp1ie7k5XJ4zUrutwba+U9UpqMCRDzf0QadEZaD
	eWmn+AtpUT6OdvPlgLU+SzMJCGExslQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JUvOp/ck";
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CEC443A02;
	Tue, 13 Jan 2026 17:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7785DC116C6;
	Tue, 13 Jan 2026 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768326824;
	bh=TZLi4ME24WYwqZOOdhzNI1VhxAjc2a4f/YofFPJkMlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JUvOp/ckWt6mRHlnPWhKQVnrm9JwamA/VzvHERB9ZWe2mpg7WiFw94MU1fJ/9SEbT
	 ymd7DB18o0QoCrkBFtVvK3uRX5ZyZz3ZLU/D/Lq0wnVxM0d/jObtN5QvoOlxgndjQY
	 Ld+SNUYYnkQnDx0Gc/iWGkxFITuZQyXmuEoJMUhcfGl4EHMyI/sypiSf/+BvtnXdn4
	 WYkZV1pCZ3qTIpyIAwfX/8d2UJyvvvqHx3PyQkhLvW8psbGY3A6avA7A6VyNpxr6Hb
	 chXzh1BzVpbTVD2Dku3IJTjswAQLhLrH0M7wv0s9mDaxwXyEalzUo6QH5bL9wbXDF0
	 IjdnHw6A6ouBw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9B5F7F4006B;
	Tue, 13 Jan 2026 12:53:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 13 Jan 2026 12:53:42 -0500
X-ME-Sender: <xms:poZmadtyFWLt0MZUPIvzVRlgczQ8z1IuOjmQJJ9DjgbmuvQWoggZbw>
    <xme:poZmaXOyqRXhm9-TP_9AyGsoVTtCxiE7fU0hpuhS7gEWARlJynEo0TtpMkqvUNbSO
    59lqmXUVjhCs8X1h8HtCMDrkrhytWWbXt3tEiN1izOB1nrFFCr1_Q>
X-ME-Received: <xmr:poZmaZp8XRmADqNhsj3LlVtbio9seb7-WBw2Mw7qNODLgWgef1dI0ExsqiZZSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvddtleejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehprhhsrghmphgrthesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhngh
    hosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgt
    phhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:poZmacH_Vno9g_4DneJbjrrhcY7wmFrveme8nP0QYnu3oeBNC5txrA>
    <xmx:poZmadGNkD-Sa_E0mQp72F1Atg_UTVTfOLKPSKr26qonBY--6XPpVA>
    <xmx:poZmabKXtUEXMWeS1wQcjM4fvOhNaDdV5yGyCRpyaHQ8Yu6l-DlcMg>
    <xmx:poZmaWE9iFZfvP78fmKUwg4x36GSOUmPMhtrWD4uWvUkIPetpgSiQA>
    <xmx:poZmacp9Br2Ifd3R7tHXQae5hqWuqQoQySbOo-stogIZ2vOGVxhlvd4s>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Jan 2026 12:53:40 -0500 (EST)
Date: Tue, 13 Jan 2026 17:53:35 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: Add support to unaccept memory
 after hot-remove
Message-ID: <aWaGBandNCLT93Tm@thinkstation>
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-3-prsampat@amd.com>
 <aWYctexPTf-w7QT8@thinkstation>
 <af3bf2ef-0231-4e75-9a80-c2bd3a7e1bf1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3bf2ef-0231-4e75-9a80-c2bd3a7e1bf1@amd.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B519140002
X-Rspam-User: 
X-Stat-Signature: n3ftw7kmbepaxjbc9nzk9ct51yqirtbz
X-HE-Tag: 1768326825-389297
X-HE-Meta: U2FsdGVkX19nieSn2h7MCuDCBLpn7efdbkw9AAad1OaJozx8p4No1XIX5Rdadcz7/XaFZVh8Rt7xt5M40gWoi4KNPiGzY/jlPjaxf02pQ4Bzb93BrXzdIRqxaLAADYP/za9Jp2d8cJHgqAAUSDKB+5XS8DL+qRg4Iian41NibeOTu+X2nbPBjXSQm6WFAfsAI/+7pz+IMpdkdrYl4Z86fnqXdZO2jbEbmK2GzgalibTan5AHZdh9/TzsgoZiqTUmY9DWk7e4GiVtRFUMYt41oiB3bzJK8uX2K+JQWqIn5yNyApQxKJAAdcmR5ySakgnPKXNNr35U58UqnHhm94JPQzAK5O93lftw4/aCbe5GFA1UyX6Jv37NYlDE46T/+OfIGH4oIIWoXHejlmxImKw4EQauBH2Z9n9GswxRMivYf+TUYExmFW9YCJGuZQasY9T0SFoYdqLxk18hAou1+afCZZDv+P4hHt0M/cCwjs9Fs+VPkAliLSdbVu2EJqt2l/FIn2UqP9GcmGOsv4UX+MlHAuK1tXhYAawWdukHw/Pef5QyBAtXR7BNRXQmmcSz8HKMf46gH9+XFCQ1gBhmnle5Pizs1p8dSfBJIqqlfQYP3afdfB47FAcbUKWx0MIWZa4NXeH8oN6L8HRCKjxmp3Lcgh26xRY8yhRKXQlP820sfYPM3KvSk5+vybailik2AMUYMNf+s1eT7UuBSbjFsz/cOq5syPDFtyoK2UScE5cp0xH+n+f0T/1IWKt567eZmSySfuREr94N5ayo8GH7rM2Ctemh7ac7Rm8t5vsyA4w2BEP3gEL4EbxRxbfXet3HXhmImK5vHABHX0hAzpiA9Fh0q+C9UcAncE0EdDvlp9xSiyWtSnMJuvQinhUP3I3pKTVOPvpT9ffwyCPVLi2569GXaSudP7STzSM9zhfZCHKjqiZ+o3wmpDwxNPomRk4T3QfqvLSx6Wxs7QGMnusk9AW
 CtdvQN3e
 MCf3mcTmkv1mA0IzT2CVMSbv8/R0zrGjLm3ha7km5lvWRnYjIFFkoxplqaQgG4mh/oWP/GZFRqMf/WKWNvIwRvmQipJmF4VDEjStS/lNdFyoqtS3SE4rJ1nvhqiHMVcVzJz4l2mKEOvoYjzLDgYnfKU+DOsXF2M0zT3V5bceTY25vl2FJMDiaj689LxhJ8kU9W8BOGTKwV+YsU40Jy75Vs6pbVX+Nf+pmh92mwfPOqsSlIQrET8D/c9xBhtKqoGcWfvxZY7DdYYGZ/bwKFgYSPTsN9yqQ787VzjUWM61qnzw5XpC7lWtLDwIxkoNnd9vCj8/xTXBGQhLPUdE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 11:10:21AM -0600, Pratik R. Sampat wrote:
> 
> 
> On 1/13/2026 4:28 AM, Kiryl Shutsemau wrote:
> > On Mon, Jan 12, 2026 at 02:23:00PM -0600, Pratik R. Sampat wrote:
> > > Transition memory to the shared state during a hot-remove operation so
> > > that it can be re-used by the hypervisor. This also applies when memory
> > > is intended to be hotplugged back in later, as those pages will need to
> > > be re-accepted after crossing the trust boundary.
> > 
> > Hm. What happens when we hot-remove memory that was there at the boot
> > and there's bitmap space for it?
> > 
> 
> While hotplug ranges gotten from SRAT don't seem to overlap with the
> conventional ranges in the unaccepted table, EFI_MEMORY_HOT_PLUGGABLE
> attribute could indicate boot time memory that could be hot-removed. I
> could potentially unset the bitmap first, if the bit exists and then
> unaccept.
> 
> Similarly, I could also check if the bitmap is large enough to set the
> bit before I call arch_accept_memory() (This may not really be needed
> though).
> 
> > Also, I'm not sure why it is needed. At least in TDX case, VMM can pull
> > the memory from under guest at any time without a warning. Coverting
> > memory to shared shouldn't make a difference as along as re-adding the
> > same GPA range triggers accept.
> > 
> 
> That makes sense. The only scenario where we could run into trouble on
> SNP platforms is when we redo a qemu device_add after a device_del
> without first removing the memory object entirely since same-state
> transitions result in guest termination.
> 
> This means we must always follow a device_del with an object_del on
> removal. Otherwise, the onus would then be on the VMM to transition
> the memory back to shared before re-adding it to the guest.

This seems to be one-of-many possible ways of VMM to get guest terminated.
DoS is not in something confidential computing aims to prevent.

> However, if this flow is not a concern to begin with then I could
> probably just drop this patch?

Yes, please.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

