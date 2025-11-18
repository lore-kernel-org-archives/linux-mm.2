Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27AC3CEDDA9
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E89C6B009E; Tue, 18 Nov 2025 10:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0276B009F; Tue, 18 Nov 2025 10:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D59A6B00A0; Tue, 18 Nov 2025 10:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B95F6B009E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:06:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D1721A056F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:06:48 +0000 (UTC)
X-FDA: 84124054896.07.5685633
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 446501C001C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:06:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gVqLXxCo;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763478406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWuQ1Gr1da/Ps4043tEOOHSlQCc+Eyc7OTDl03qriVs=;
	b=e3/4wm7929laUGJM/0qmXFzdPshSiMtwU/WFSB/KpueuYNNZTJnlovyP9cgqNgtyqa3Lli
	pUL2g32Ti0oy3TUUZYcHYs1M9XKsEXe8Ms8eoZ/TNo6LjlzgPpRJPT0GjTfQ/OEa2iCSbi
	LR4RWky11xqlt6be450w7drox55NVtg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763478406; a=rsa-sha256;
	cv=none;
	b=NdyscqbpFNhKGOTxuWq8CoIdfwwF2zYiyuiIhnqwBRTKl8flDp1Gt1oPTqKQQVdo3PY7Zv
	oRg3bD4HrGoGwBrTQCyevZecg7XSHTKDDoR+MCA7PUaYIu0w3GfzwNPpepF8pZQ9ioS+lR
	BV/xWC0D3bQyasEfOULkMVEla7HIcco=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gVqLXxCo;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E17264024C;
	Tue, 18 Nov 2025 15:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274F2C19421;
	Tue, 18 Nov 2025 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763478404;
	bh=76+2f+4hsDZ7pFzkCao+UBvMyvqOyAsPTXWZOrXZ64A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gVqLXxCoHubWmmYGMBSppHz6v+K6gOlZuSYxfANkq1RKW8ckeEAIrlml2vKMxAe5L
	 3C8zjm11dqTah0Vkmy2M8q3igXZkmU+HXuX48hcaI8METAODITZD7cxnwl2IMKPiXP
	 otr7qxYH6DGeVFsBC2ronbizF4drLwhTO4cKnQUZC7lBlo0I2qlELAAZm/qaFIqsjG
	 HfRaIi6Y5JnNl3ZWxHIr/R7/kiqKBhKBd1W+81GC9ZMcqhlXX4EWL9wpc7TXvC/n65
	 fdY1qa4EgfHtTIYbz0kzbq1HE98C977U9Rl1R9Gg51/HhI1YNVY1YoDlShCZkuqVyr
	 rOJgoCOWRfH0g==
Date: Tue, 18 Nov 2025 17:06:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com, hughd@google.com, skhawaja@google.com,
	chrisl@kernel.org
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
Message-ID: <aRyLbB8yoQwUJ3dh@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com>
 <aRnG8wDSSAtkEI_z@kernel.org>
 <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
 <aRoi-Pb8jnjaZp0X@kernel.org>
 <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
 <aRuODFfqP-qsxa-j@kernel.org>
 <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
 <aRxWvsdv1dQz8oZ4@kernel.org>
 <20251118140300.GK10864@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118140300.GK10864@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 446501C001C
X-Stat-Signature: zufgktez5wweqnqcz57xpocbezsq5hwj
X-HE-Tag: 1763478406-488901
X-HE-Meta: U2FsdGVkX1+IVxWkZHp1wUtE8Tivrs4MUZqN5GYdm2w5chSmVrG8KjsNVbpZIAFzz/w9KoJSRSdYMF8FymLy4h2YL5AYTmrV9fULnGtJafKuQixFCpQtutxRYOQL5U5MR3MK3wYZvz9fhHXd1TNmn5zthsvFuqiSJprWUZqmOEXIZ1lv+eV1skdwPLwJfYov8xiN9bir3Lrca9VfSlU0USEJs3rbECZKO1FHl2m7SloOwJio7IhRtde0fjkcahCC78h/uGvE46T5JwZ0IDeivUYUtc4FCf+1u2TQ6o3KxVumr4hWxRLRRpXEzKtSUxMleoohQMa3jj2YfHwEr1RKBSDAEnDirWNln6oDB5B1Et6ODaFfXk0klDo5b/rUMioYM8/EimMN0somby9XUMJJ7lRx6LWube58z98ooRlCT7PV2r5CTf7WiNlLy5EOCAdsLpFg01Y68d3ejRkI2SZCqLcde3D3dhbwUBciXZzJVIH1B4B51/AVNKCfovkrNvzZPOcqfXM7Jm1wz2YumhO46Z8J1ygIQgsSv7IRy3trLlI1RPoa5u+5rWc/1l3zFQGmACVGHXMmFjlrlQEwefVDq0wpywuPlQ+hxM3VzieDRVtozqbUnPXDmt3AraJNNciS6yFNpe6oopXYV0dr4hbPFDde/daHf9mT+K6bqcOKTNIenye9g92lsmy+lgM+zq/MIZAKJBMZIV4cCllLkp56OnphHQaVWehMW1RwDat7rgrjd5MlYTcOHQYVe9LUZAlxn+fi2Xar1yAO4A9bKbHNm4kz57v72didrF3RCVUQZYuYfSHZJG4nq60Sw++dkPIGAS1tvBMKTvbviJQJNzgc4aOrCoNOFi6uxjgTQrCMOOW7BffwtL6flhCyG2rfhRvsbovk+7fWI6Kh/dWWqcbBtrrWfkiyxWkMJESbfFQK0M/IOm15Fp6JREW6ZDSdm+JKuUrFKOYFL52n9okgvh5
 pCW47xTO
 IDlFIj8TndoKUGb+nKXTR/K4kiuOcbxqvIHQ+Tm51Swe35XN2i23+KoWOI/zweGJ3ZpIPHPlP7eeLdL6j/crzTqRiV3HwunwzW3xR8UEIh4F9oUPvGPnTPp5PTN546WxZxM4HvXWGxReHrjdszduJPAlbDoPnP3KI5lz3BCWBVqI/+OE4ownofb1KOtkwqU3AdVyPQPzB6y1ugf3RCtuv9AgjC8DzqVwxS4WkVHjvIdFLkSO4vAEF3x6htxzuC0soPlbx1fk886ytjwndC6yv1+eUh0OYyYIIK4ym73JhA9Psq7gax7ITFtJ2hUhgLx/1/cDMuBx97Xs3zMfKESCyOCV/I6V6IXC905IdYZ2tVkHx17drIR8lqt9TWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:03:00AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 18, 2025 at 01:21:34PM +0200, Mike Rapoport wrote:
> > On Mon, Nov 17, 2025 at 11:22:54PM -0500, Pasha Tatashin wrote:
> > > > You can avoid that complexity if you register the device with a different
> > > > fops, but that's technicality.
> > > >
> > > > Your point about treating the incoming FDT as an underlying resource that
> > > > failed to initialize makes sense, but nevertheless userspace needs a
> > > > reliable way to detect it and parsing dmesg is not something we should rely
> > > > on.
> > > 
> > > I see two solutions:
> > > 
> > > 1. LUO fails to retrieve the preserved data, the user gets informed by
> > > not finding /dev/liveupdate, and studying the dmesg for what has
> > > happened (in reality in fleets version mismatches should not be
> > > happening, those should be detected in quals).
> > > 2. Create a zombie device to return some errno on open, and still
> > > study dmesg to understand what really happened.
> > 
> > User should not study dmesg. We need another solution.
> > What's wrong with e.g. ioctl()?
> 
> It seems very dangerous to even boot at all if the next kernel doesn't
> understand the serialization information..
> 
> IMHO I think we should not even be thinking about this, it is up to
> the predecessor environment to prevent it from happening. The ideas to
> use ELF metadata/etc to allow a pre-flight validation are the right
> solution.
> 
> If we get into the next kernel and it receives information it cannot
> process it should just BUG_ON and die, or some broad equivalent. 
> It is a catastrophic orchestration error, and we don't need some fine
> grain recovery or userspace visibility. Crash dump the system and
> reboot it.

I was under impression Pasha wanted to get up to the userspace no matter
what.

panic() in liveupdate_early_init() makes perfect sense to me. Parsing dmesg
does not.
 
> IOW, I would not invest time in this.
> 
> Jason

-- 
Sincerely yours,
Mike.

