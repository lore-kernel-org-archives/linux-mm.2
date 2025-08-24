Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB5DCA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 12:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0786B00C0; Sun, 24 Aug 2025 08:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43AAA6B00C1; Sun, 24 Aug 2025 08:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301A26B00C2; Sun, 24 Aug 2025 08:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 138976B00C0
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:42:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6D71BBF26
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 12:42:34 +0000 (UTC)
X-FDA: 83811614628.25.636ECE8
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id 362B8C0008
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 12:42:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EyqoXjGA;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756039353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ejhr5/8XDnu9hR6psUfGP0Xt7e/UVRzIl8+hlrHs19o=;
	b=cjt8m4cvZuL+0HlJdaMYre/rqs8AstAhrQFu5XMvRGPyjAwoztBFCHGXg087L20Wv8Y+Kt
	w27MxJnQv5RjCElrOhPuhOyz+rKWA7DRmbNR7y9j+vOjPRHfxCL5ag5koLWkFR4lsObUw5
	/wXK0mTn4hg24OluFLCM5jeJZhlBvRg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EyqoXjGA;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756039353; a=rsa-sha256;
	cv=none;
	b=XeWphh8QIEyZIAWuWF+znH+4EjV5BSr+lcVhDuhVL9yAJDAZGm4I54L7dzGwM5MdvyAmvl
	3X5l8G8DiKI155bAGHqlHrVAHh+pRDLv89fByjBGTPOae937uN98riLuqUooAPcrsQqAPH
	Cj/A52wF2LohhTpvyZWStLBDytDZ/Ss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D94775C4732;
	Sun, 24 Aug 2025 12:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDDDC4CEEB;
	Sun, 24 Aug 2025 12:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756039340;
	bh=fgE9N+AYCjPOSPrePisRrj1q6mfYGGRAmhs42H4A6SA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EyqoXjGAqD7Ft2DTzF13ZUNQUS7p7ngkaULch92MqALZNzaXl2HYTjld3QG7MCa5Y
	 6Fokf1LN8QYy7rN93opIebIPDryYAtXagq7tMSonj6QETbaLmoXvnCMP/9RgWxkfNe
	 J+Ervf1uo8rhuATE7eudeoUatNmEQE9L6FD4/nV63eaDEtN4rYgo5PWfSMxCD5mPvu
	 WBpSpfz1lb6Xv0PDqfggAwK4DXHBJAjOt0Rj4Vp3ayPCKWa5NZFrb+UB+Sr7xgv9Pn
	 9atqld7wGCCme9dEfzhRSQBl1c46HiZjVoyB6WeYGaEGIMqgi1Fl+2RNycYdKqAng2
	 Hwt5j8L5H8Lew==
Date: Sun, 24 Aug 2025 15:41:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	Somasundaram A <somasundaram.a@hpe.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>,
	"gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>,
	"Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"kangkang.shen@futurewei.com" <kangkang.shen@futurewei.com>,
	wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v11 1/3] mm: Add support to retrieve physical address
 range of memory from the node ID
Message-ID: <aKsIlFTkBsAF5sqD@kernel.org>
References: <20250812142616.2330-1-shiju.jose@huawei.com>
 <20250812142616.2330-2-shiju.jose@huawei.com>
 <20250819175420.00007ce6@huawei.com>
 <aKV6dVkPiBPw595T@kernel.org>
 <20250820095413.00003bd7@huawei.com>
 <964fc2721fb7499daa5f49eddfed54ff@huawei.com>
 <aKX_rk0DasbDgJrS@kernel.org>
 <20250821100655.00003942@huawei.com>
 <DS7PR11MB6077843C9E2FFA811971BAA7FC32A@DS7PR11MB6077.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS7PR11MB6077843C9E2FFA811971BAA7FC32A@DS7PR11MB6077.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 362B8C0008
X-Stat-Signature: difa9p7jbfrcgqgg73q665bw8zw5efot
X-Rspam-User: 
X-HE-Tag: 1756039353-413104
X-HE-Meta: U2FsdGVkX194QBRPhZeEdOjgK5LyMqFcUN/n1k0q2Vhy0sfOls/QsKrVjVaHeSlrUWXkgO+tAHM1HuHGzrbRzkVvc9+ZjEIocfEH1nJT1w6x/k5IKatCKZjlrmy4hrwtAuMyMnMyfIxcSAf9dWq8OebIdle6400Djc0RTaW9YkUONC7VRkX3txfCyyClBpcYRSfDUqpmVmKPc5XWbJA/e4b3LSoJ7y0QDt/1JHvtv5DTcKxzmY6rkNHye0uDMp4zG9E3obFCEBvaAnXAYZuaxzca/fCzF6ZfU9saYHmAzb7JIau6Jazl04fXqLePeK3SQ2WfHyt3S0Qz7nfNJFyK2gyjg5TsvPLv8mDdXj5eZ1i28siFH4skgkcJLeFUgiHy/aFktI+CqcA1wn3s+S0Wx6g2ikQ8jxZkdFUjJdIHV2VElKgZsyUMMMQP7uDgn5+Lv2bRlGDyEJGDkQdWi4nUQmm2pMj1+VWc0GEcgx3BmecfGcb0Vb4JhDFS7wZQFyh4GVEuIb+mP827uTad1fUrHFSQl4PBgBDxQ6LZKlfVtedwZ8JbZLg6jycC7FR5hPBgI2tdoKu7fKYRFT7hPEi4SxtcKSdPBAmANe7gEgEGvFFby7RRbjEqqdvAyzXuVqwJkaKCVyD65/yTzyFQxhkv6OER4pd6EmKPOJJFzGbojPcFCLfgHyPy4zgtsBm4or2fl9qQDIzhHLp8BsB1roA2TFtRnoRXAovDtsbm6nwFxmaWXR6dLsVaqOPdC2ab27aTip+OM9fc7Besw4oDEAaH5IKnTIQG8f34vVNkQFDdEUzjrQCtjQNU5QfUxW12khg67XM61z/IQMJrMHN8VCWhBH0Vij9jyd0JB+SDc/dGiATc+uzrbPFDYXcmLE1M0LNB6kzxnmR/o6GiQP7ee+kEsIOZIVsOY0A624vU4AwYZzci7n4qNfA5sGYe4mXZ9Jx4rFM0uCGuz8KyZf4writ
 5b7cTILZ
 NWbGQ6Vt2IENwgDgJBDdbMChCVS7t/qyvfg4wbFKWKJfo2p82wo6zibMkM2g/tg86CvjuQY0X5RFm3cqFbSwkQJSd2f/T71WOXLD9lb3oZUzjW2i4ZePUxlyTA476n9/85oa98rBMFwfr/kneNQCf5H8CNS9Nf30HhX5yUe7nuIyIAN5oIvYzU0nz3xgZqLSlEyLB4b3DySQBMx+A7z8hdrlWs/Dtqe3Gww21MhvPVysvMSJOqAEfr1i9/2JSOdQ4jFO061gtTwU9jpBrLqY7fgSIkq2B1m7TeT0D8Fbcl1EvPS9xjWE81s56G+df+mZPJP+j1bKSgN7m9yHGtxpDlCK97GrFjYgDwB2NdSu4XFq4zz+lJczQzqh5SA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 04:16:02PM +0000, Luck, Tony wrote:
> > > I believe that's because on x86 the node 0 is really scrambled because of
> > > e820/efi reservations that never make it to memblock.
> >
> > Fun question of whether we should take any notice of those.
> > Would depend on whether anyone's scrub firmware gets confused if we scrub
> > them and they aren't backed by memory.  If they are we can rely on system
> > constraints refusing to scrub that stuff at an 'unsafe' level and if we
> > set it higher than it otherwise would be only possibility is we see earlier
> > error detections in those and have to deal with them.
> 
> Yes. On x86 the physical memory map below 4GB is a bunch of address
> ranges with varying properties:
> 
> 1) There's the "low" MMIO region (often 2G to very nearly 4G) where 32-bit
>    PCI devices have device BAR ranges mapped. Some of this isn't memory
>    at all. It's device registers that may have side effects when read. I don't think
>    the x86 patrol scrubbers can access this at all.
> 2) There's EFI allocated memory that is accessible to the OS (e.g. ACPI tables)
> 3) There's BIOS protected memory for use by SMI that the OS can't access at all
> 4) There are ranges listed in E820 or efi_memory_map that are usable by OS.

There is a slight problem here with getting the first contiguous range from
a node to seed the scrubber.
If we use PXM, the range for node 0 will usually cover the entire node
including types 1 and 3. And if we take it from memblock, it does not include
type 2, or anything reserved in e820/efi.
 
> What is the use case for OS control of the patrol scrubbers?
> 
> While you might want to specifically scrub some range to make sure there
> are no lurking problems before allocating to some important process/guest,
> I'd expect that you'd want to make sure that types 2 & 3 listed above still
> get a periodic scan to clean up single bit errors.
> 
> -Tony

-- 
Sincerely yours,
Mike.

