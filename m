Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9CCC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FE36B008A; Tue,  7 Jul 2026 11:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0166B00A1; Tue,  7 Jul 2026 11:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497F66B00A2; Tue,  7 Jul 2026 11:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2127E6B008A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:41:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A14011204C9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:41:34 +0000 (UTC)
X-FDA: 84962395308.20.FA013DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E4F7E180010
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:41:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIrRwsun;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1Kwud0dvJdx+NdcimkPz3yZCGnaN/yJ0h1aVkDOmMY=;
	b=riEO5ueNxqPvamXQ6bt+PwQ6feHe4BYTA4u0UL2h6jkoifhwpgy+atxXkRcRHvjgCgYVuP
	nY5MwOlGhyMUPdJYoQuoJz6eCr8Vh8eBIkLcIxQJbrElG4j2jXs6L+lxolwasf+6tC2y75
	2U7zgPKpBLY2N2YwNh5/rA5q3XGj98Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIrRwsun;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438893;
	b=b57U9WPlxQliCo2WhsS9S+zFn5kXX8wy3/DSWrI+rrt64O4l2rViwcoCnPuGiYTYi6g8RN
	sW2kEnrYc+CnT7V3A0/HdCSha2h/OU7FizJWzeXhvS4bCAOkXIJOl3zdhv/iHb6Qp02IZV
	KI5DkVQ7wy9u4GE1rwy3tUjxzXkxio8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C35F42B68;
	Tue,  7 Jul 2026 15:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CED1F000E9;
	Tue,  7 Jul 2026 15:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783438891;
	bh=Q1Kwud0dvJdx+NdcimkPz3yZCGnaN/yJ0h1aVkDOmMY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=cIrRwsunHV1lDrfE3muhzbxHCOAELWIUY4Y8Dr11AdxgevUodaWpzzfaQgziBJqFg
	 Z60VV1AYFgIGExsq+K4YD+E8mINg+UGjQjUucqjzcYkgvyChec5TQWT0r8JRcDzzsO
	 ajeOF6AnC3vYj9l0S8854nCl1kGiv6wC6OWjfR1j5vCDMbro8IHNrAuBnjzLg2/wuL
	 VqonITdE1JIZFFud4MWnWk9fVlfKdlXHpLspgt148IMfd9dcj7xTk/HgJ6AtxoGDq9
	 A1oZLgLvBqEPzV03Fl4gc3HqWQhBJod8ryZmA41BJag+VMtLxNAh6tIiEUqhF3XZp1
	 hBkNn203hcJFA==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  linux-pci@vger.kernel.org,  Adithya Jayachandran
 <ajayachandra@nvidia.com>,  Alexander Graf <graf@amazon.com>,  Alex
 Williamson <alex@shazbot.org>,  Bjorn Helgaas <bhelgaas@google.com>,
  Chris Li <chrisl@kernel.org>,  David Rientjes <rientjes@google.com>,
  Jacob Pan <jacob.pan@linux.microsoft.com>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Jonathan Corbet <corbet@lwn.net>,  Josh Hilke
 <jrhilke@google.com>,  Leon Romanovsky <leonro@nvidia.com>,  Lukas Wunner
 <lukas@wunner.de>,  Mike Rapoport <rppt@kernel.org>,  Parav Pandit
 <parav@nvidia.com>,  Pranjal Shrivastava <praan@google.com>,  Saeed
 Mahameed <saeedm@nvidia.com>,  Samiullah Khawaja <skhawaja@google.com>,
  Shuah Khan <skhan@linuxfoundation.org>,  Vipin Sharma
 <vipinsh@google.com>,  William Tu <witu@nvidia.com>,  Yi Liu
 <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
In-Reply-To: <CALzav=fN8m9+rso7RSLR35bozZpNKv6McOR3jv1-ngxApM1BCg@mail.gmail.com>
	(David Matlack's message of "Mon, 29 Jun 2026 11:48:55 -0700")
References: <20260522202410.3104264-1-dmatlack@google.com>
	<20260522202410.3104264-4-dmatlack@google.com>
	<178144432039.1257322.9644414453415904478.b4-review@b4>
	<ajBgj_aSuzMZG47e@google.com> <2vxzechulmcp.fsf@kernel.org>
	<CALzav=fN8m9+rso7RSLR35bozZpNKv6McOR3jv1-ngxApM1BCg@mail.gmail.com>
Date: Tue, 07 Jul 2026 17:41:25 +0200
Message-ID: <2vxzechen6xm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mns79yix7g1u4z3k81dfef176yqh4yxu
X-Rspamd-Queue-Id: E4F7E180010
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783438892-957787
X-HE-Meta: U2FsdGVkX18t94G/rj/zlipDH9myffGZSlzD4W2bCYlGulwuv+fY4CPhtEzL6mLYjCyrOiOluTUgyTLxb+H6Sm4taHeIEpLV/oPGXIuJgbRrE59FYba2leITE5/mk0giL3XAiFm+/k0CCtVY3ImVkCj1/loyZSB3qS3KgHRyIEzLh/m0cq1eP1VXNkOVTbzdPRJVAVivfQWdK0xW2/RE7rDxzbq/hi+h4bWC12zCA/rsUKYmD722ktxTp0YAV6tAPY2sQX7yUqjHoCaPFFIb3fRtR0a1XjNY76Nq9GqIDRp/gXOLKXvhAjHzUzSwG8+5Yh65sbGGbdmmBVT5j7yjA/ZKGcD+XP30o3r9AIHaVURvzIuOKnxamh0F1DE9ZIKrnz1isIlGu9Dg3oRRaVERQMP0nV3P3IJDOZYXXBf4oa/o1Fnl0eTM0dpX1yIe3030stvoJ+6++yatyE58k1Q6SQb5gMQmPX++0pzqRycL1w3mJ34YNgO5iSEFxahYrpbvnxcwacp1q8/SSA0C9GESStapHaxYrrIWxAwIwb4e2hn13inlCIcVktakgQOn94taId49vX6alXjCEcJbRVe2vJ1PVzwYK6VBya+K6jCLQaXVqXaJtQrfvT9cC3KMRp+WAmqKon15USA9PQHbZRjFHQ+6Nh9cV2II6hZySf8siJCFmUEe8KqBWmyVPEDh4urwPprvXiA6PmKzEChLFvcKbIjArRMynXcqpivUsqngKtxEQINzGdx85frH/lRbhcWFOL/YEZBt0OGkvlWsuW2YBVqTV28QcuBsAJgHZTiS+wFWOhxGOMveTAw4S9rhq/Zhsjn4p60gwWKxzl6/FfEoZd9/VsrKCZOde+dMsF5sN97a83ZfTyEZI5evWbJ3vWuuBR7t4CD0O2GqK2J+CY6FY5Gf9gqL1nQaZU1umia370wiTyOGhvo0Ldh+nM2zsbZDvpsf7grEjrOS0wAyb51
 6pkc0QQe
 0eLTMtu+Fyl4RyTgrebX0BWNX7a2YXgeRJCoad5NgjOkM3lDzKYiVr/pYCgWVc9p31XIo9Fdw37ZfGtrX0Tm66Zef3PiG+qVGIv+a7EptUpQ6t8LKxj4YPsx2E1mV4VSgUAsAEkzZiGTrPOUpIdjOIQMCVbhxux3cmNgWt+aDkJy0Xxz+fMi5ci2xcJwVjt2tS+E0EWZEOeCFoXf9rpBDnWCn+tmUHxmixQsEsOgPLxCO/8nN3tXVL45WDe41TTOEGXEn/2io4E5NPkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29 2026, David Matlack wrote:

> On Thu, Jun 25, 2026 at 7:35=E2=80=AFAM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>>
>> Hi David,
>>
>> On Mon, Jun 15 2026, David Matlack wrote:
>>
>> > On 2026-06-14 01:38 PM, Pasha Tatashin wrote:
>> >> On Fri, 22 May 2026 20:24:01 +0000, David Matlack <dmatlack@google.co=
m> wrote:
>> [...]
>> >> > +  }
>> >> > +
>> >> > +  pci_info(dev, "Device was preserved by previous kernel across Li=
ve Update\n");
>> >> > +  dev->liveupdate.incoming =3D dev_ser;
>> >> > +
>> >> > +  /*
>> >> > +   * Hold the ref on the incoming FLB until pci_liveupdate_finish(=
) so
>> >> > +   * that dev->liveupdate.incoming does not get freed while it is =
in use.
>> >> > +   */
>> >>
>> >> How would that work? If finish is not called FLB stays around until t=
he
>> >> next reboot.
>> >
>> > True... I think if the PCI core trusts drivers to call
>> > pci_liveupdate_finish() then we don't need to hold onto the incoming
>> > reference here.
>>
>> That was my point when I was arguing against refcounts on outgoing FLBs.
>> This is very easy to abuse, especially when we are talking about device
>> drivers. And this refcounting mechanism makes the FLB no longer
>> file-lifecycle-bound, since now it is entirely up to drivers to decide
>> the lifecycle of this data.
>
> The PCI core holds a reference to the incoming FLB for as long as it
> maintains a pointer to that FLB in struct pci_dev
> (dev->liveupdate.incoming). The lifetime of that pointer is aligned
> with the lifetime of the file as long as the driver calls
> pci_liveupdate_finish() in its file finish() callback.
>
> If there is a bug in the driver that causes it to not call
> pci_liveupdate_finish() then the FLB will leak past the file yes. But
> the alternative would be to leak a pointer to freed memory in
> dev->liveupdate.incoming, which could lead to UAF.
>
> Leaking the FLB seems safer than UAF, which is why I went for the
> refcounting approach.

Hmm, that does make sense. I still feel a bit odd doing this, but since
I don't have any better ideas, I think let's keep this as-is. If this
does turn out to be a real problem, we can fix it later. This is kernel
internal API anyway.

Also, I didn't know the plan was to do VFIO only. I thought at some
point in the near future we will get support for PF drivers. With only
VFIO, I think this is a lot simpler and problems will be a lot easier to
fix since there is only one user. I was mainly worried about random
drivers holding on to PCI/LUO core data structures.

>
> Another approach entirely would be to drop the
> dev->liveupdate.incoming and do the xarray lookup everytime instead.

But then you'd need to have a lifetime for the xarray, no?

>
>>
>> I have been thinking about this a bit more in the last couple days, and
>> I wonder if we are doing this right. Here's an idea I have been thinking
>> of.
>>
>> We should make live update a first class citizen in PCI. Instead of
>> patching in liveupdate via the liveupdate.incoming field, and letting
>> drivers figure out when to use it, we should separate out probe and
>> retrieve paths entirely.
>>
>> Probe and retrieve are fundamentally different operations. While they
>> may share some common initialization logic for the _software_ state, how
>> they interface with the hardware is completely different. I think mixing
>> the two will result in driver code being more spaghetti by having
>> liveupdate checks sprayed out all over.
>
> We are only planning on supporting Live Update for VFIO drivers for
> the forseeable future. The VFIO work during probe is almost entirely
> software state setup. The only hardware logic we need to "if" out in
> the vfio-pci driver's probe() is putting the device into a low-power
> mode via the runtime power manager. So I don't think we will get any
> benefit from this approach, and it would be a lot more intrusive to
> both the PCI core driver framework, and VFIO itself, to support this.
>
>> This series doesn't add support for any drivers, but looking at some of
>> the code we have downstream, I see this problem. The liveupdate code is
>> all over the place in the driver and it is very hard to wrap one's head
>> around how the device is actually retrieved.
>
> You can find the vfio-pci driver changes here:
>
>   https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/
>
> Let's keep the discussion focused on upstream VFIO drivers since that
> is all we are planning to support right now due to LUO's requirement
> of file-based preservation. The downstream driver changes we are
> carrying is not reflective of what we want to support upstream.
>
>> So I think PCI core should track preserved devices, and if the device is
>> preserved, it should skip the probe and wait for retrieve. Retrieve does
>> the full initialization of the device. This fits in with the LUO model
>> as well. You can make retrieve a callback of struct pci_driver and do
>> some wrappers to talk with LUO, so device drivers don't directly
>> interface with LUO at all.
>>
>> We should do similar things on the shutdown path. Shutdown is a
>> fundamentally different operation from freeze, and so we should separate
>> them out as well.
>
> This is speculative. In practice, we haven't needed to change VFIO's
> shutdown() or probe() functions so far. The only change I anticipate
> needing is skipping runtime power management "put" during probe() I
> mentioned above.
>
> If we actually made retrieve() a first-class callback and used that
> instead of probe(), VFIO would internally just call its probe()
> function because that would be the cleanest way to set up all the
> software state it needs to manage the device.

Right, for only VFIO this doesn't make much sense. I wrote this thinking
we will add PF preservation support at some point.

>
>> This solves the lifetime problem as well. When PCI core is initializing,
>> it knows for sure that no retrievals are going to happen. That's because
>> none of the drivers have registered yet. So it can safely access the FLB
>> and initialize its state. After that, drivers can register themselves
>> and start accepting retrieve() calls. Once the last driver goes away,
>> the FLB is freed automatically.
>
> It's not so simple. The PCI core does not really initialize itself.
> Scanning devices gets triggered externally, e.g. by ACPI, device
> trees, runtime hotplug events, etc., and that is when the PCI core
> gets notified about a device. None of this is synchronized with "when
> drivers have registered", which I assume you are referring to
> registering with LUO.
>
>>
>> I am sorry for suggesting a big refactor at v6, but the early versions
>> looked good to me at the time, and I only thought more deeply about this
>> when trying to figure out how we can make the lifetimes cleaner.

--=20
Regards,
Pratyush Yadav

