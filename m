Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50558E6400F
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 05:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E21D6B0088; Sun,  5 Apr 2026 01:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691A46B0089; Sun,  5 Apr 2026 01:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580206B008A; Sun,  5 Apr 2026 01:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43B926B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 01:28:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC6ED1A0A11
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 05:28:18 +0000 (UTC)
X-FDA: 84623371476.25.4977F98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 146E940006
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 05:28:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=bejAtE4V;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775366897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2UHsS7SqYYqTozJjfBj6V37VjS+eOmJpA6kFDwrClA=;
	b=7DqeEMhfdC5FcYwdzBa0fyYvu2RwOgpA5hQte+nDdfcMOgaupmSq5Z3lovuIjSMEp6SBf9
	bhOAZjkfYpRSqAp33bxPRGWMJEsQTagM+3mhanR9mNDgFuGKN/6dUVGDB3wlf4XzhwS+v5
	g/YZ9AAIRMYu2+tYPDMGCad2aRKxr88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775366897; a=rsa-sha256;
	cv=none;
	b=jKfhVZumur1V1CWoFkArLkxe7frOAmf0yD4/6vpBvaJTd4ScAwyaY12vnIXazkuTrb+vwh
	dBjhL8FhLBEe5NuQ5GXH9dXFS7lFdRQpqWYkYp9pSAvlMC7QcEnIGC2sdiJXfqCMoZa0to
	/1v+Qo8w89Pm5Hp7bc5UCbewqmmOJ1o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=bejAtE4V;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3662A4385A;
	Sun,  5 Apr 2026 05:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B7DC116C6;
	Sun,  5 Apr 2026 05:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775366895;
	bh=ophk+hp6kRAG0U/TAGAhUuOrKmitf0U0PYwWZuudius=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bejAtE4V1Hz3lTSKLlyBcIyR+JNRKDGMc/G8Z0GN4ZPNsCF585rejSzukgcFioxub
	 QUbiyQrTx+RcM6s1+Zu0oaI1vfJoHXTXgrhOUb/YXCMVVE2KZgd+scb35TQsQF7wMb
	 a7Wf9qe7CdkvcplKMPdPqmr9WcFeVQib8uJGDZ1Y=
Date: Sun, 5 Apr 2026 07:27:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Douglas Anderson <dianders@chromium.org>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Saravana Kannan <saravanak@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Eric Dumazet <edumazet@google.com>,
	Johan Hovold <johan@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>, Frank.Li@kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>, alex@ghiti.fr,
	alexander.stein@ew.tq-group.com, andre.przywara@arm.com,
	andrew@codeconstruct.com.au, andrew@lunn.ch,
	andriy.shevchenko@linux.intel.com, aou@eecs.berkeley.edu,
	ardb@kernel.org, bhelgaas@google.com, brgl@kernel.org,
	broonie@kernel.org, catalin.marinas@arm.com, chleroy@kernel.org,
	davem@davemloft.net, david@kernel.org, devicetree@vger.kernel.org,
	dmaengine@vger.kernel.org, driver-core@lists.linux.dev,
	gbatra@linux.ibm.com, gregory.clement@bootlin.com,
	hkallweit1@gmail.com, iommu@lists.linux.dev, jirislaby@kernel.org,
	joel@jms.id.au, joro@8bytes.org, kees@kernel.org,
	kevin.brodsky@arm.com, kuba@kernel.org, lenb@kernel.org,
	lgirdwood@gmail.com, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-serial@vger.kernel.org, linux-snps-arc@lists.infradead.org,
	linux-usb@vger.kernel.org, linux@armlinux.org.uk,
	linuxppc-dev@lists.ozlabs.org, m.szyprowski@samsung.com,
	maddy@linux.ibm.com, mani@kernel.org, maz@kernel.org,
	miko.lenczewski@arm.com, mpe@ellerman.id.au, netdev@vger.kernel.org,
	npiggin@gmail.com, osalvador@suse.de, oupton@kernel.org,
	pabeni@redhat.com, palmer@dabbelt.com, peter.ujfalusi@gmail.com,
	peterz@infradead.org, pjw@kernel.org, robh@kernel.org,
	sebastian.hesselbarth@gmail.com, tglx@kernel.org,
	tsbogend@alpha.franken.de, vgupta@kernel.org, vkoul@kernel.org,
	will@kernel.org, willy@infradead.org, yangyicong@hisilicon.com,
	yeoreum.yun@arm.com
Subject: Re: [PATCH v4 0/9] driver core: Fix some race conditions
Message-ID: <2026040539-sponge-publisher-2b42@gregkh>
References: <20260404000644.522677-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404000644.522677-1-dianders@chromium.org>
X-Rspamd-Queue-Id: 146E940006
X-Stat-Signature: mseq6w5zzg1pbnzyqeju5uq1eyttrimw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775366896-286254
X-HE-Meta: U2FsdGVkX1+vsB6skoBpmdKLE026vbdQxhoME7s3EVbD/l7RvmtopiIq/aFTTGiGPw7YRqIuRgRQFbULvyV4dVmMKhlq6/Bo6Pyss5tYAAl38DfxBPIahYmpj/cTLJWDFI5u1QNY7T12cDRCU4JzQTxW/EqxyrAbEdHJ3zbdT9oNEjtQGHZ5KU/BqpZfEddUEdpON6LdNEboB9L4xUFSmoH+BKAiBfwy95yJEMcul9gliKkhgeznotpaKTqWTuKvL1VToRBCgwmk9UNCuJv3eGSfLuE7w8Jb+TsfWc/VDNH70GYta0FA2Xk5zifZDZYeIeertXlpNKopkx9SVNNosGoj74C6MsVidUF51zB+/ihoO09lferP7DJdnBa+O/9+VCpAkNb/BjUtirKakRkxM+8p/6R63NoSrKNBcu5OX5nkqUy50MnFLS/4MKpaTXsu/c/dcpRDyFe0Bi3Q6Lp0sIC6+QUO2pML/inrxvq7YZ7UTAoNTAeuuPhte8hpCK20X8miIXv4cTYJhwWj1YZNaOjqekLkXO4qenM5KuGFmhG+I+lXaz6cRif6IocpmtoRnBnEq8V3niL+5dOf+ROdkQgGRAXrfS856wweSlHZNCUgcn29SZ8QJdOIhV7WZWqj9v2Nx6+vsb0C7vxzjBdPAADiorMcivUu4a6e7BYKvChlzhD+ThQK5Sch3MCguqN/CQiaFGSVnceY7jXMVgncsDpEvn5bUG1qJlRtSIIIyv65tt+hn0dvKwjtYoYr7Q92p8JoKatJ/v4yLT2mVMHeAUEk/B1zzD/91lj0Nfh5iInr8XKCCA5gla7ZUoDyHVWxlNneENLyBJqsx0lYpL8tnQbuEGz7AWGpZq2rsftsUZPLSb253oorth/TaS5hbbcAPwRIci5f1pmkQ/d+ZaWJFtOug//Ga7UumgwgzCuEj3rkaMBrC3ZJlgfra97wsRwDsxxTVxYgiakVmZkBLR3
 myx4rvB1
 4VFSEWMyZHv5IElTrOMaQLp0cp7irdbzd3H37H+o5UcCZwZ1KHHYMorlXd/LAwVF3FoVa6CMVhBbb9BDr5ewS3p2szIhYIfwWPNJ2AXUxaBv4pACIis2jnYIkA1QFX56kMTD/c6KCu8x/G+zt8XS4Xiur9oBdtu+meV2M1DWaqIYSvR/jiaWWmn/WLyZn6+iPlr0eNCnrbibz+Xxh9RqVLRkOZKzdeJkV2VFQyAWdLO+k7uoVXpdXhqwoI2cyIIbTyldSf2b6mdNMycgk3m7EhmEX4WTJt6kE5kaMwVdRMDqEFztAOXP1MC8zokF59zkERWA08jrQtgcfnihZdnFJb+98oeG5JM2tNhA+/4GR18BbExih3qsxKF7PPFrBEWwpZXuMemaMiy66Jo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 05:04:54PM -0700, Douglas Anderson wrote:
> NOTE: one potentially "controversial" choice I made in some patches
> was to always reserve a flag ID even if a flag is only used under
> certain CONFIG_ settings. This is a change from how things were
> before. Keeping the numbering consistent and allowing easy
> compile-testing of both CONFIG settings seemed worth it, especially
> since it won't take up any extra space until we've added a lot more
> flags.

Nah, this is fine, I don't see any problems with this as the original
code kind of was doing the same thing with the "hole" in the structure
if those options were not enabled.

> I only marked the first patch as a "Fix" since it is the only one
> fixing observed problems. Other patches could be considered fixes too
> if folks want.
> 
> I tested the first patch in the series backported to kernel 6.6 on the
> Pixel phone that was experiencing the race. I added extra printouts to
> make sure that the problem was hitting / addressed. The rest of the
> patches are tested with allmodconfig with arm32, arm64, ppc, and
> x86. I boot tested on an arm64 Chromebook running mainline.

I'm guessing your tests passed?  :)

Anyway, this looks great, unless there are any objections, other than
the "needs to be undefined", which a follow-on patch can handle, I'll
queue them up next week for 7.1-rc1.

thanks,

greg k-h

