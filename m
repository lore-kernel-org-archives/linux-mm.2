Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4591CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9147D6B0093; Thu, 25 Jun 2026 10:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5B36B009F; Thu, 25 Jun 2026 10:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8030B6B00A3; Thu, 25 Jun 2026 10:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55F576B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:35:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C230614010A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:35:11 +0000 (UTC)
X-FDA: 84918682422.20.17D4F02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E872240011
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:35:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSkFo9kQ;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782398109;
	b=70ti0QAnWy9LFlAvAH/wZb9db4/Web9sfgJIfK3GwjN4DM7oMMOikDH3XLUy5QDi+g7guV
	zxbYkJk2XYegv9CAxteovEanVOCGdr9E1jRQ6KImmWgL7K5riS4pg2b/tyoLhPJ1S4ZZYT
	PHLYA6qy7ip30U6m8E01T/tddtgv9ts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782398109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wFD3Z4KVfOMxeGD6x7jzXk02QR7lT8SFbTHg6iLim4=;
	b=qVjG2H507nqqt44/iaTRQmw7mjxc0xMevWbk5CoUWjps0onvl6SAZdBktz+OEPlEUvx+He
	LNwKlHotzIFaOTUXi8+Fw5Mm8kOaI+5g3oMUAS46BzyYaJ350Dkp4kjZbELrH16KYYEG1c
	z4jEKedHp2fhFCHInJb4gHByB3Iwslw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSkFo9kQ;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B9C3600AE;
	Thu, 25 Jun 2026 14:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2141F000E9;
	Thu, 25 Jun 2026 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782398109;
	bh=+wFD3Z4KVfOMxeGD6x7jzXk02QR7lT8SFbTHg6iLim4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dSkFo9kQ3Duzy2coh3AZjrEanzktsml4PVsc7hhHjx1E46Ls/rB7T/4b1kY6c7yoj
	 7ZBQBzD53BnNlicytToBhMtxxPK5TYaZOHCcR9e9eukQP/Dl7ANuvxGn5RKTEfhZMx
	 z/GAedQVwFV/4/ehgROjCN1hEsZfs0/eizpu72Y2JVGQTVCpV2VHinDyHkqhO1xJMZ
	 jMuWmvBwYPvZcTQYD5XaawdgS7FVaBuCNI3sjw/sQH2L83/GgM2RkSA0V0a/iCG5di
	 HI6Ke0ZKefHf1ZVEL62tkz2IqQHRIUG7ZgLfOHlqotSCEBctcfI4bp4hOzCyBR9GUq
	 6yy2gcnTDKf9A==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  linux-pci@vger.kernel.org,  Adithya Jayachandran
 <ajayachandra@nvidia.com>,  Alexander Graf <graf@amazon.com>,  Alex
 Williamson <alex@shazbot.org>,  Bjorn Helgaas <bhelgaas@google.com>,
  Chris Li <chrisl@kernel.org>,  David Rientjes <rientjes@google.com>,
  Jacob Pan <jacob.pan@linux.microsoft.com>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Jonathan Corbet <corbet@lwn.net>,  Josh Hilke
 <jrhilke@google.com>,  Leon Romanovsky <leonro@nvidia.com>,  Lukas Wunner
 <lukas@wunner.de>,  Mike Rapoport <rppt@kernel.org>,  Parav Pandit
 <parav@nvidia.com>,  Pranjal Shrivastava <praan@google.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Saeed Mahameed <saeedm@nvidia.com>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Vipin Sharma <vipinsh@google.com>,  William
 Tu <witu@nvidia.com>,  Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
In-Reply-To: <ajBgj_aSuzMZG47e@google.com> (David Matlack's message of "Mon,
	15 Jun 2026 20:29:03 +0000")
References: <20260522202410.3104264-1-dmatlack@google.com>
	<20260522202410.3104264-4-dmatlack@google.com>
	<178144432039.1257322.9644414453415904478.b4-review@b4>
	<ajBgj_aSuzMZG47e@google.com>
Date: Thu, 25 Jun 2026 16:35:02 +0200
Message-ID: <2vxzechulmcp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: u9fqc5jagh5ayunum1r3jk8r9k8ftqfh
X-Rspam-User: 
X-Rspamd-Queue-Id: E872240011
X-Rspamd-Server: rspam02
X-HE-Tag: 1782398109-993377
X-HE-Meta: U2FsdGVkX1/ltqmjNK1mSiO74vUFtfL46ajzalwcwhKFVWrPAjVznU9kv03cjlpV/IpWBWV5Ro1uGeVaQSVDKIUlOgb7ZNjc5P0eElK6gFSuyZeAcdtdDbDJsx/6dtYl6AYNM/gdu3Jxb/9vIin89SzTmUbo2e8Lnd0HjiNJNGLxyXRm2fuPXerHqYgDKsjmWmKvIyMnkTVx09OQ8aep2yUP/svCXZZgMqrMavAdn+BLKqB8/IxrQBo1k1tGU57gbmMAczuh2yAylA9gTiE+MQ8iEsI5SPTqMGOtG2oNGyS2PLBpxIIvhARaUE5KLRh4xbR363blG7nA5GlJuCkBSeEOXEgPWC5ZCKHW3TYZ2Km6B37dhANk4dqotGK6oVyH6TnIh2pH6JlqO6cozvI7aYHQRc0ZffvMg0i8N93loJqGXDsaxriMX3pixj/AuBiTaCUkv4jfKbC8UDRi1Gz1TfQWwSQqSWK4f2G42oPmWjFk1roJ5yqGTfOaqEaHWetKVvEXPSqLFaRxttx6zZRes02FzAk/gsc6U7NhMbd0ao6ML3hErE6Xy5xknUy8ryif5YuIzFF1XgYHmXvgdAs8BMK9pr0f2AW1p/rOgvUYO78GBInwN49g14+jSTGHTHOLlPjvf6Daf3pvMyvWzvlJY8r1RNYzRAK8hnu+4NStbPVarhYMmpHEPEPZXntT/5Sr+DSTPVuT/KiVLFpGY1DqG3t4H4aRrgU/MP9lQFwWP3aVEn5Z2eZm8LnjRZmpA3mnooF1D96FpZ7vc9C/ljrtRBTCQKgcsGckSiSq9oL9NWtje184BrRyzZZJRfZVcVYWC1tQB2TULvQaWuk8gSFoD4BCDt34hDT3VA0PaJVB0LhbtsLzd8GWbvusW2aLH2aF7Fy3401a1hjAqbSldJpwWBs73TxCA75rHNIF5NuZk1R7+rB6tpRMMRFOg6LStkzM/+yTcyMlgOj2/Vj1Vr9
 QHiIcKGc
 WhXvXI0WiCxDhm9NkRM/9cfa9SuG2Saame7CTO8a0FBkrRGEzPkT4maPPbflRKZdYrM0dHYZkiLeeCwbe4biVm+cVeuedRr1AYNe3uBM1ggODztR/14KSV7m6p31Kau0DGZ2sk24PjrI2w3eKVrgYiHClNXbFmloCFY0rRAG5dNZF2RofGGe4qGcFMgzrI/KBNumGDosjCywlTbNc0QbKVhSEyNh4tAY4QgZ8HkNY2svgPT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Mon, Jun 15 2026, David Matlack wrote:

> On 2026-06-14 01:38 PM, Pasha Tatashin wrote:
>> On Fri, 22 May 2026 20:24:01 +0000, David Matlack <dmatlack@google.com> wrote:
[...]
>> > +	}
>> > +
>> > +	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
>> > +	dev->liveupdate.incoming = dev_ser;
>> > +
>> > +	/*
>> > +	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
>> > +	 * that dev->liveupdate.incoming does not get freed while it is in use.
>> > +	 */
>> 
>> How would that work? If finish is not called FLB stays around until the 
>> next reboot.
>
> True... I think if the PCI core trusts drivers to call
> pci_liveupdate_finish() then we don't need to hold onto the incoming
> reference here.

That was my point when I was arguing against refcounts on outgoing FLBs.
This is very easy to abuse, especially when we are talking about device
drivers. And this refcounting mechanism makes the FLB no longer
file-lifecycle-bound, since now it is entirely up to drivers to decide
the lifecycle of this data.

I have been thinking about this a bit more in the last couple days, and
I wonder if we are doing this right. Here's an idea I have been thinking
of.

We should make live update a first class citizen in PCI. Instead of
patching in liveupdate via the liveupdate.incoming field, and letting
drivers figure out when to use it, we should separate out probe and
retrieve paths entirely.

Probe and retrieve are fundamentally different operations. While they
may share some common initialization logic for the _software_ state, how
they interface with the hardware is completely different. I think mixing
the two will result in driver code being more spaghetti by having
liveupdate checks sprayed out all over.

This series doesn't add support for any drivers, but looking at some of
the code we have downstream, I see this problem. The liveupdate code is
all over the place in the driver and it is very hard to wrap one's head
around how the device is actually retrieved.

So I think PCI core should track preserved devices, and if the device is
preserved, it should skip the probe and wait for retrieve. Retrieve does
the full initialization of the device. This fits in with the LUO model
as well. You can make retrieve a callback of struct pci_driver and do
some wrappers to talk with LUO, so device drivers don't directly
interface with LUO at all.

We should do similar things on the shutdown path. Shutdown is a
fundamentally different operation from freeze, and so we should separate
them out as well.

This solves the lifetime problem as well. When PCI core is initializing,
it knows for sure that no retrievals are going to happen. That's because
none of the drivers have registered yet. So it can safely access the FLB
and initialize its state. After that, drivers can register themselves
and start accepting retrieve() calls. Once the last driver goes away,
the FLB is freed automatically.

I am sorry for suggesting a big refactor at v6, but the early versions
looked good to me at the time, and I only thought more deeply about this
when trying to figure out how we can make the lifetimes cleaner.

What do you think? Does this make sense?

-- 
Regards,
Pratyush Yadav

