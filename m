Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AD8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 17:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654B76B00C9; Tue, 30 Jun 2026 13:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605FC6B00CF; Tue, 30 Jun 2026 13:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51BAC6B00D1; Tue, 30 Jun 2026 13:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 270986B00C9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:09:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD87F1405A5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:09:36 +0000 (UTC)
X-FDA: 84937215552.09.CB0E585
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3D8C160011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:09:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=lqMj+EEx;
	spf=pass (imf08.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782839375;
	b=c5vkjKZSA3PGvPH0eApXAVDwSB9YORK9FoX3BNtbBSeChNkSCn372nbbFjYICYGO+cDRaY
	rYNOJhfIjvsa9j5fe/uyD2XgBSmGmGXw5UD8AFe9NTgJOLZ3J7nkQ/A3q8pfTBtrJO3eGF
	YJ17s5Z8K9EXY+ZOayIAYCJ0SBjKUVw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782839375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5CJTk2TlD92UoezyHqsHilXeiTs4Pq4ZgYFgjk1fNM=;
	b=v3/p6oh/8Vzu34rXKkgy4KhrSoTfyxFA89lon1wvdF4uQc5e5LWQeShEvlsc4Ornz28oM/
	eAXU0qwmgLHYzzKR/WeNaT3TNz2yo7+hOYA3kU84FuPBDTRjQ9BcfAthOokORxp7VUxfzm
	NWoOmXteJrzM5OQoPGDmvNemKgtp6lI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=lqMj+EEx;
	spf=pass (imf08.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from thinkpad-p16sg1.corp.microsoft.com (unknown [20.236.11.42])
	by linux.microsoft.com (Postfix) with ESMTPSA id 606FD20B716C;
	Tue, 30 Jun 2026 10:09:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 606FD20B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1782839372;
	bh=B5CJTk2TlD92UoezyHqsHilXeiTs4Pq4ZgYFgjk1fNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqMj+EEx6yimT5SdLBxPpYjQVeixzMgWJxE3inL7BSg7A8SIwXJw9/SY3hMdm+e2F
	 B4YadK9ITH+eLe9c7LsalSb5FNRP8fJJGvoWAnL+APrr3XphmWzeBv2nRpYtGgU0/5
	 H4Po029v5P7HCLxZZkL5nAHTbp9PT+RnE384lSTY=
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: shyamsaini@linux.microsoft.com,
	ardb@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	will@kernel.org
Cc: akpm@linux-foundation.org,
	bboscaccy@linux.microsoft.com,
	bp@alien8.de,
	dapeng1.mi@linux.intel.com,
	ebiggers@kernel.org,
	elver@google.com,
	enelsonmoore@gmail.com,
	feng.tang@linux.alibaba.com,
	gpiccoli@igalia.com,
	kees@kernel.org,
	kuba@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lirongqing@baidu.com,
	peterz@infradead.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tgopinath@linux.microsoft.com,
	tony.luck@intel.com
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Date: Tue, 30 Jun 2026 10:09:11 -0700
Message-ID: <20260630170911.43521-1-shyamsaini@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aj6SqipC/dIN01iN@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <aj6SqipC/dIN01iN@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3D8C160011
X-Stat-Signature: wkri3fmwwru8aw5zefger47xc9tb8nru
X-HE-Tag: 1782839374-633392
X-HE-Meta: U2FsdGVkX1+ttoAbRR/2RN9wQjEU//2SL4TTWX1jeDqMRZoD2TmTNuielcDZIn4N1xEJG34rjrYTVu3EXximzZOeu3wbsK8UhSfgTksVMM+IX2LKB8p/CCiSz/lSursKgWPjugmtxYRutAlMBeskMbPu6po89AcP3xDO4A+QMh3P8Yv7Z6qhl+0OuKY8ziaFNsC0syY+0cI+2vqHmXCXLApoIS3cbvTqBHKKTcsE5xGU/s651Hx/n+JPK0USs5/WeM5jOiUGMlll7WSwxwE03my0ZM0+bkszyOGdfDIJkHFvAvfPZ+CeJaqSapnm3aCfNdktlLxZxFyy6PHfAPVWricv3HMCfrELuo6sqo6sa/fecGfC85cEc0ASUsyKTc/5rpPL9BTm+i4tcJQ3OMpKeYCdYZwca6DAIKX/aSmcfcOpa59Ui+tOCsh9aP29ZwFvj++OdBM3T1VOoAVVUkvzNmsPqh8Izwd+x1/BXjnunMrTN/mccOMPv8QBl8qcu1PS8lk7XWLT9EAvvAbKio4ruQfLkz08yau0YfET4NgE4KctgwNFl5MK8RzFT48KfTPFtRWxFQIuIuA+nirB7qOJtnL+9zmk0/6w/uYpO3af9vkoEd/BjtYTe6wYXHP1/j/Y2oMA2Yj1+Ylnge2BsBCY0HoTHdY0DQAnyXS9VFKVqHzNcJtUYyPiDEbv9/V6sdqEisc0pxXfhRRjZvQvtX6nG92I7lUDZQ+k4Au8Mnr+RpKd5jLmuYIcmDri392LOxBi8V8mwdtUat9QCT/UyMzUvN/bNK7c1J6nFQMV982OVvW/hxdxK0xhkjbFgIIFygKQbkct1jRzxNYuF2GaO5B6X+jTle7z0ouUEQLoVXghz1P3/Zes1BBJRfik9PyGLfqQyIJur2CM3+ivmKhmhrz6y0hER54+lNzGxPyuO/4gTOUM/thQO2gPDLiY4y0aJ/s1eJSrdg8C6LCJUEftsaw
 RUE6JClE
 l2fc8tkp7OFQAahhJnROWeTv4PgKPe6JcsCtulcC7TU3p9XeZI6tqXhi+miyAjOanKWK8/zClHFOQAyjT5Ox8hE3zjJhq6U32AQAcygZ5x8ry1esx7FRCzvZxSGui7GiwNM/I514210oYT33GHqE8j7IDolFwJODoCzxRcKvIqQrjfQghWTePP7jikwkifdhz2XJ3wZ67b/te0yzRuJA9Jau6Cmdd/szlI9Z0DZ528PR/AN/BfSTeYppCj9kDp5V06R9Bfn/zlVQG7LJY8/SleyGOSFSsWCkCeDcscpTVYqp/1Y4mhiIs1hjViEp4Xcoksiif9V6Qj1Z6GuCL0kLm3a1XdeuqC1nAVkYY0IoLruVKLtqwMBUkHjmUz3MilIc8PQoWlc7MZOu0vlU/jJhiJYItYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Everyone,

> On 25 Jun 2026 11:37, Mike Rapoport wrote:
> > Hi Shyam,
> > 
> > On Wed, Jun 24, 2026 at 06:22:33PM -0700, Shyam Saini wrote:
> > > On 21 Jun 2026 13:36, Mike Rapoport wrote:
> > > > On Thu, Jun 18, 2026 at 11:23:31PM -0700, Shyam Saini wrote:
> > > > > reserve_mem relies on dynamic memory allocation, this limits the
> > > > > usecase where memory is required to be preserved across the boots.
> > > > > Eg: ramoops memory reservation on ACPI platforms
> > > > >
> > > > > So add support to pass a pre-determined static address and reserve
> > > > > memory at a specified location. This enables use case like ramoops
> > > > > on ACPI platforms to reliably access ramoops region with previous
> > > > > boot logs.
> > > > > 
> > > > > Also skip the parsing of <align> when static address is passed.
> > > > > 
> > > > > Example syntax for static address
> > > > >  reserve_mem=4M@0x1E0000000:oops
> > > > 
> > > > reserve_mem is best effort by design because such hacks as well as memmap=
> > > > cannot guarantee this memory is actually free.
> > > > 
> > > > If you want to preserve ramoops reliably, use KHO with reserve_mem.
> > > > The first kernel will allocate memory, this memory will be preserved by KHO
> > > > and could be picked up by the second kernel.
> > > 
> > > ok, On ARM64 DTS systems, we can reserve ramoops memory in the device tree during
> > > the warm reboot.
> > 
> > The cc list actually implied x86 ;-)
> > Added arm64 folks now.
> 
> Thanks for adding ARM folks, I had just included whatever get_maintainer script
> suggested, sorry. 
> > > For an equivalent ARM64 ACPI platform, what is the recommended way to reserve
> > > and preserve that memory across the boots? 
> > 
> > I don't think it exists, but a command line option (be it memmap= or
> > reserve_mem=) does not seem the right way to me.
> > 
> > Most of the arguments that were made against adding memmap= to arm64 [1]
> > apply here.
> > 
> > If kexec is an option, KHO provides a reliable way to preserve memory
> > across boots.
> > 
> > If kexec is not an option, we should look for a generic way to specify
> > something like DT's reserved_mem for ACPI/EFI systems.
> > 
> > [1] https://lkml.kernel.org/lkml/20201118063314.22940-1-song.bao.hua@hisilicon.com/T/
> > 
> Well, kexec is one of the option for my use case, it also requires
> memory reservation during warm reboot, I think memory can be reserved in
> the firmware but this will create a dependency on firmware for Linux
> reservation.
> 
> It would be great to have a in kernel memory reservation mechanism for
> ARM64 ACPI platforms. I believe some other use cases like PMEM
> reservation would also benefit from this.
>

Following up on this, As Mike pointed that reserve_mem is best effort
reservation mechanism, so what is the recommended reliable Linux
mechanism, if any, to reserve a predetermined memory range during
early boot on ARM64/ACPI platforms for warm boot scenarios? KHO is
one option, but I'm specifically looking for a solution that preserves
the region across warm reboots.

Please let me know.

Thanks,
Shyam

