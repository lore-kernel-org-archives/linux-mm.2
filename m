Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A73C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E388E0006; Thu,  7 Aug 2025 12:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFCB8E0001; Thu,  7 Aug 2025 12:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039378E0006; Thu,  7 Aug 2025 12:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E72328E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:07:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70B7916037E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:07:59 +0000 (UTC)
X-FDA: 83750442678.17.1F0E7BA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4462840018
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:07:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754582876; a=rsa-sha256;
	cv=none;
	b=w9zCa01W25eRDERe7shDw4l3QzptCW36V7LsmQppV4kyDoPbdfFtyKMR5GWF+u4pUjqFpo
	T7Pdc5Pbps+Bxk4LRFGkkpPbYoDfYnvP9anUkbp42MoHw2cjOB5z2iPQlYXoW6GUEHC3ZC
	sTBG9PPi7I/VU0W/Qm/fZ1MlXZcWuX4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754582876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVSOFdbay1u0grjbb1LUrKz3NBTjY4v98MFRYOh4cHM=;
	b=AbreTm6ezux+ZTfSiGXzCDX0McKpfSu7PAaFEO2EZyXATbQIZSIsGiUU72ABA7NrH7dfxX
	vmHazr1f8NpW7JOk46NDg6WlLdh4fAd++NG/6+hZ7ZGTkC7k1vE68dWAzAitWMQ+WAMjez
	5EV8c6N7cO4S5KcwPgH3t4nn9xrbBSw=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4byX894865z6DB6D;
	Fri,  8 Aug 2025 00:06:01 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5CAF11402EA;
	Fri,  8 Aug 2025 00:07:50 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 7 Aug
 2025 18:07:49 +0200
Date: Thu, 7 Aug 2025 17:07:47 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <dan.j.williams@intel.com>, <linuxarm@huawei.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, <james.morse@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, <gregkh@linuxfoundation.org>, Will Deacon
	<will@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Yicong Yang
	<yangyicong@huawei.com>, Yushan Wang <wangyushan12@huawei.com>, "Lorenzo
 Pieralisi" <lpieralisi@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, H Peter Anvin <hpa@zytor.com>, "Andy Lutomirski"
	<luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 2/8] generic: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Message-ID: <20250807170704.00002ff2@huawei.com>
In-Reply-To: <20250711125218.000050bf@huawei.com>
References: <20250624154805.66985-1-Jonathan.Cameron@huawei.com>
	<20250624154805.66985-3-Jonathan.Cameron@huawei.com>
	<686f565121ea5_1d3d100ee@dwillia2-xfh.jf.intel.com.notmuch>
	<20250711125218.000050bf@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.66]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4462840018
X-Stat-Signature: 5hr4h1ictjik17c4ogbzigzzo7ojdt18
X-Rspam-User: 
X-HE-Tag: 1754582876-663551
X-HE-Meta: U2FsdGVkX19bnuXLf/rPgzFtRkV9yUu6PaI5qnx9GRi52iECu7yJEpNFdOTA85BIKGJHCWKxcNxEFk7gvEqg323nn5NzIX5vSfllm6N5TS2Wc2bb9WWm/RwLLz89jXsaxdyyIQ3GNFzn1A5DfR5XvScc7e8qbw7Klw8ndVw4EE+R/17zKh9+B2k+H1waJd+r6WY0WzaWlCR0EHuvOjvGMUl9XPVhn/1grUvRFNCO5GIlSFXL60V7kZKQI20MLpI3dUIm9C5ZBNRsLwvqGQgkMOMRiDbmza5F1B9fSi9wrJL3SfzMw5dbQFNJZZ27VMqinROf856ogzcPCAfTJg7b1G4Yd30tquuA1MoKn6+47YJRxPGqZ4tW6Ym/0lh9vmirD1BFN1JoaAFl0qBWhrdgqwF2WUxu4npfhToUIiOeRnFz74OUyjrGes4WARVaoFOxYYMYAg6IxkLEK+zTgnCWBT3rPPNIX/FBc/dxvxFmTru5OM0jv1hrYPizZGRpHhYb0+SGXSzAJuhxHE/9VuU1rqqZeIPuLHWHABsDazLFzUJA6WrJDKSN7hFCIPEEd4it5MhKX82gS/gILX7r4tY5HRBhbjrReNh+l9ZpNkze2znp+FQfAxP7X6ntDqB5zqVE5nI56t5tjOblZx8FyycHR1N3ExVMHKRj+k919lgrmjKoxGDUK68RD7jqc4OdTefFqSzcX0HMLJex1MWZN3fDTEHbiVRt/CJpQZ3QblMeLpPkRU89XlF5O3XWwQzPfkn9iwVrJocg4oOJq05/ySZNsVhxMQZJCSzSiqZs5CUufztdwOo+torheK0jCGkDvRfE6Ruu2HUo42HwbUVItXPdkm3ud2rll9JMjiqR8REdMD+aFGedZr+KZa1b+dFFEj44FJTkbNgIhGIbSPGKJe75VrRcbhPNXfpRrqfnOTx9QuhWgW+10FF6dOMSHnUXO5Elh7fQ/AvgQLFW6eUNwIz
 qrm2gK+G
 ITRBtIOoANpQXnzI725m6NPQ1SoXMY6h+WZBCBYEfmqPnjNkcF4yW+i/vPOiJ7hfr2p4o6KCn8QFgYzl/b3YI3k9cftqHkl6MsdDx/7RiJLXs7wRA1ictC3E5SjwpngmR5QMH60vLe4g+bhjvXkej/2J2EL8nPSAxXNNsJEYujvwrQLHWyF+tKgTJoI3H1fWI1WSf20//fBPcHfljPWGowWk0JDeLrwlODzywPKaf0MpZJr4B+5vIAXglSWZgxqTNHFJUZOJTr9gTikM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > +bool cpu_cache_has_invalidate_memregion(void)
> > > +{
> > > +	guard(spinlock_irqsave)(&scfm_lock);
> > > +	return !!scfm_data;    
> > 
> > Lock seems pointless here.
> > 
> > More concerning is this diverges from the original intent of this
> > function which was to disable physical address space manipulation from
> > virtual environments.  
> 
> Sure. We don't loose that - it just moved out to the registration framework
> for devices.  If a future VM actually wants to expose paravirt interfaces
> via device emulation then they can.
> 
> Maybe we can call from here to see if any device drivers actually registered.
> That's not a guarantee that all relevant ones did (yet) but it at least
> will result in warnings for the virtual machine case.
>
> > 
> > Now, different archs may have reason to diverge here but the fact that
> > the API requirements are non-obvious points at a minimum to missing
> > documentation if not missing cross-arch consensus.  
> 
> I'll see if I can figure out appropriate documentation for that.
> 

Hi Dan, 

I'm struggling a little for what these requirements should be (and hence the
documentation).  Do you think having the possibility for us to go from returning
that we have no support to later returning that we have support as additional
drivers arrive is acceptable? Potentially the opposite as well if someone is
unbinding the drivers.

So for x86 it's simple as you use an explicit cpu feature check on whether
it is in a hypervisor. For architectures using explicit 'drivers' (because
the interface is in MMIO or similar) there need be no difference between
the 'is it a VM' check and the 'do we have the hardware'.

If someone chooses to emulate (or pass through) the hardware interface then
they get to make it do something sane.

On a somewhat related note, I don't yet have a good answer for how, in
a complex system we know all the drivers have arrived and hence the
flush will be complete once they all acknowledge.

Could do an ACPI _DSM that returns a list of IDs and check drivers are
bound to them but would need to get that into some spec or other
which might take a while.

For now I'm taking the view that there are many ways to shoot yourself
in a the foot if you can control driver binding, so this isn't a blocker,
more of a nice to have.

I'll send out the new (simpler) code next week (so post rc1)

Jonathan

