Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55162C88E59
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 17:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0BA96B0088; Sat, 12 Sep 2026 13:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBDAC6B008C; Sat, 12 Sep 2026 13:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB526B0092; Sat, 12 Sep 2026 13:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6BD6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 13:32:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC7BA160551
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 17:32:07 +0000 (UTC)
X-FDA: 85205803494.03.C34D54B
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id 10FFF1C0006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 17:32:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="RFqu6D/z";
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789234326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBslPyab51IM3cN1q+WywRAJYOzHWq5eKWBrdVKUM1w=;
	b=0z1J173weLcZrZfnRovasrysx/PYHwAg9yld/fZ+oBO9gz3Jpva9KOvJW5DJ1BE3UsNgpO
	Pml1V7nvHOkZBhD3WwglUnWRx5bSOsJfjn5Hqqnz0sXOXoZ6qW2T6XjaVVNyLMitAtviAn
	tMgmSINIiPP8PDDp6SS3KV5U1ftqW44=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="RFqu6D/z";
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789234326;
	b=03/3CcPWgqitOhdcqC3tA/D2UbecRSaVZditL5F24/rvWQbDq8Kh4vWVxe3y7rDGwCBASC
	tsi0Q1YP7JVFlZMruLgHYPat+WnPV7C3id5PpPw444ZxzMyr+56BuW2F4pu8aziF8bhRlo
	Q+GUpQ6CSd9kZoZPUZ3FBdPBPBRHYf0=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747ee1f9bso9079195ad.3
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 10:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789234325; x=1789839125; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pBslPyab51IM3cN1q+WywRAJYOzHWq5eKWBrdVKUM1w=;
        b=RFqu6D/zEvS01zh0Ybi9jokp89FBydnTJSNf6LlCwDtH4G4QlY4mKQ4eRxw/DduGKQ
         a4Oh7+pXWdPStRf2DY3kxmBwce7lKQcP102z/CsIip4c2Og6Z2n0azOzL2EPWipJnaTK
         4b+6Q0BubL3iyIlkjRzfJmZS27dvof0PEywOfc7SpbT2WX5TGGDeaAfJyjObtkr/ZlZ2
         aUkeXC+Yk88aX9mM7SaetZNrMUdoPAKs2391jxd+G8zULFxMR7hMfhlo2BQVuaJsJiJ+
         Kpp5R5rDiQwsQywe6LhO42P9V7gSB7VnDiUCskeeeA1KF1gRzHFzJsKityEo6pMdsiqE
         Pv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789234325; x=1789839125;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pBslPyab51IM3cN1q+WywRAJYOzHWq5eKWBrdVKUM1w=;
        b=SUqYnJZCrrv+wzP6vfOusK7abChkFPbrtkfU3RabrsPlebyVpGAM3uXRzf12ICM0su
         YWyVJapCqTt1FOi65y5TbmSUwBuFyrK2YoRZM/Jy2lv8tf8LmElOgTHlMXRJTcLl1Rlp
         96JQ/k4DQE7z6U3IysFGsEk62aI5Pc1v9GzsVuVc4SpxM5+raKS0A4H+Bmktl6LplOCX
         yocV64inZq+7TjEtSe4Yr2ySxFoi1WAQn/xQXNiP6JkYtqgg/QYsd9OriS9MeZKRAt2q
         zwTfEgQ3rTqsJ2qKAc2ArJAtqnaTf9VmeaWBmRqyvbIDdgurVi1SNLtGyS1vWWJgPXA0
         5l6Q==
X-Forwarded-Encrypted: i=1; AKwUvByqUUil4BuKkP/AgIXn+3+Kxnri6c2wVweuMnDEzFabgGQ9ReORY5zLNye4G9DpIAgMxdibiDePgQ==@kvack.org
X-Gm-Message-State: AFuF++laUkjurXoZX8c6GxaDWZSFR1JuVUncaHR+kfeOCWYJzRFRjksD
	xfyzJE+lOk7SGfawKf2/z6K1IRiWSBz9wExzi3Ih/1Pr1pEFOGR9GzhnaQfRVLIXTA==
X-Gm-Gg: AYBFou0NOV/MUYNjHvzWKuj51VWQbMUSa/2UvIcM5VI8olAkUd/glm7Jp2UT/P7oX0j
	5OidbkDTKIJUhYy2rhiEf9/0U9PPOHFFS09Cqz5c+pM2Pkq4CLhbnP6XcGQf5o+FjnjPLkn+jW7
	tqWuTe8tRHGXkptfCNO5i/ZEJaYDWX8iJ+JsPnXLkhIUeQd5vO+PyigK055F/5GXXYzRnCGDMsb
	nlk5t0nj5YncMQTvVIDNADv7PFT3GDrLV5CP3J6g+YgbVZ4BY4OOb7PNy8sbZVMzGGRkIxEF6d3
	7J61wBoS3yJg/dPaILW39QUeKpcKR7luHt+aFQuHEMKpIcoHqakLd3jTNw7L6VuOzvTMyoEKGyK
	ntSvIhQioymVB6S+GaNQTZzupzdSDx6ZUQ2z6jGkuXE7KVw/t/4I2I+zd5pVRY5pkRRBiMUjCR0
	MrmnZ/xISIxDWUJrWZ6uKGTkAF51Q58DVxKKlGtmmJdtariYoJaRTbse5G7wSUykA2YGYbUe0ti
	B17A2DkjF5s2AvBApSDbWdkFvZnXoGPUBn0MF71
X-Received: by 2002:a17:902:e881:b0:2d8:d4cc:be64 with SMTP id d9443c01a7336-2dd2a35a58cmr165076475ad.17.1789234324159;
        Sat, 12 Sep 2026 10:32:04 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfc5c7bsm25731245ad.51.2026.09.12.10.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 10:32:02 -0700 (PDT)
Date: Sat, 12 Sep 2026 17:31:58 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 05/12] PCI: liveupdate: Preserve bus numbers during
 Live Update
Message-ID: <aqWMjrea2MMMZHxr@google.com>
References: <20260728221007.2098560-6-dmatlack@google.com>
 <20260910235104.GA367522@bhelgaas>
 <aqRIJs1SdJwoV_cf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqRIJs1SdJwoV_cf@google.com>
X-Rspam-User: 
X-Stat-Signature: 6n1cxsmesigo7gbptfhbr8nodwnbmzkf
X-Rspamd-Queue-Id: 10FFF1C0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789234325-725221
X-HE-Meta: U2FsdGVkX1/bBPiJC80W+dMJRN6H9UadwU0A0tnQuTSTpMGD2mJahjFlpHmyUIB4u0dxUsPm2mwjzRby7yyuDnGvf3pt35liwkIHx5yYgqovo/FU7lA3OkWsTM0NEOPu2W7WKCreXbjYJW5ZgkC7tdSJA4X6g+gD7GviVrwawYj/H4JoyGUlM8VVaJ0nHvQZFPotxwy+1eFLBYSW2BktwN+WWRIYnbbpQIW75wjx+y+mccm+Iv5H/IRPjSV05mMSF4LJhXpsl/8/QJagklYCPG0xf5pVaRQOeQdzoFym9IllqXKUtA9CrY2t0jYPoLArWRfTOIvQWcs0nz53+uZzGMmMUHcZo0QGV+OUnjQ8A2GBMFZ8KY6wnhxBfUzMZzfCy56w+U6bw9zaBlI+Y/J2LYukX74ByKmavvuWAY7VnNcRMp4me9JSkYSGVCRDHuwc9nGb70CvdKKE3qqbhXKT9jMzkrH8/j7g7ONXu5XJkFVJVBotdwU5vAtmBiCRX9YQXITrwhFUL6Ol1SWksgo8PL7hXLCfDzpsEGeepueKOj4+okL95H6BnynOMg/MfrVRSqeBWXaWCIgq74jCiqRN1u/LwZBALFjXebbItfAEA5Ci0nBJX+Ocna7TdCZnKcmTA7+CnyjY246o+kbs0umrJErhVNo2eUq6dJtQjOQu3Kh1coGIExT/BhgkQ7uXznWES8fI5fCJiBo1fMLCPvLimCQSHd2JGqkr47hmwq6+GXGiagejMigS0nx2bv1JgW2eiYtTVbzMCNecZxOad/0FsKOsKi+lUpWVsa8TPNYxc7wdaUb62jAgmxxDysGF0ABMetM+OZqGBdoFTvJugMMGd4e7oBIZf6r0RYumM6kuTqszyRcxNq3pNYPYwm8xeBlHq34pqynkHReWMI7oo/1UafFMyHb9Iv+KOVrUaCzhkV0Ecur5IHlw309QDVxruxIkLAitoBUK8xXFlh72zSP
 9yDyM6F0
 Xxj1ULg/nMEe90dP+Bf795f49Qk18zQplHlzSAenm0WzF2O4XWbuSiLrNkhEP7NCjVXiclT3o3hv3pNqFz9bN5wlPQvUnRGL4ZJ+5OuW5ir0MZuOUZa7nEzRaRp8fPJx6XsgFqILv7CIO5yGOtZovwqColENlqToZSVXNE2I3m6pg2lpCpj5QOK4q2m+cV9KvagmMvMgJWJoQLFHv58iNniooeJqMTUUdTwU3Uzbs5uoeWXfs2ERkl9OcbboR8rcGNJDRvdH6ZFrIDUuzieh1NpzzZgJxdNnqyK/URMLHMHoUbSyI+PZn4NhqbxetErQzdUjYMvOyRE18fLZGEzrPvmOD0XwM3savHAnRO65tPIIMs38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-11 06:30 PM, David Matlack wrote:
> On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:
> > On Tue, Jul 28, 2026 at 10:09:59PM +0000, David Matlack wrote:

> > > +bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
> > > +{
> > > +	struct pci_dev *parent = bus->self;
> > > +
> > > +	if (dev->liveupdate.preserve_bus_numbers)
> > > +		return true;
> > > +
> > > +	if (parent && parent->liveupdate.preserve_bus_numbers) {
> > > +		/*
> > > +		 * Preserve bus numbers if the parent bridge is required to
> > > +		 * preserve bus numbers. Otherwise the PCI core could expand
> > > +		 * this bridge's reservation beyond its parent (which cannot
> > > +		 * expand).
> > > +		 */
> > > +		dev->liveupdate.preserve_bus_numbers = true;
> > > +	} else {
> > > +		/*
> > > +		 * Otherwise preserve bus numbers if there are any incoming
> > > +		 * preserved devices. This ensures that the PCI core does not
> > > +		 * allocate a bus number to a non-preserved device that
> > > +		 * conflicts with the bus number already assigned to a preserved
> > > +		 * device.
> > > +		 *
> > > +		 * This is slightly more restrictive than it needs to be. For
> > > +		 * example, each host bridges have their own range of bus
> > > +		 * numbers that won't conflict with other host bridges. But the
> > > +		 * previous kernel should have assigned a sane bus topology and
> > > +		 * it is simpler to just adopt that entire topology.
> > > +		 */
> > > +		dev->liveupdate.preserve_bus_numbers =
> > > +			pci_has_incoming_preserved_devices();
> > > +	}
> > > +
> > > +	return dev->liveupdate.preserve_bus_numbers;
> > 
> > I'm not sure why you don't just return
> > pci_has_incoming_preserved_devices() in all cases, which is what the
> > commit log suggests this patch does.  What's gained by all the logic
> > here?  It's not like devices will be hot-added during the kexec.
> 
> To protect against pci_has_incoming_preserved_devices() flipping from
> true to false while the PCI core is in the middle of a scan. It is not
> likely to ever happen given most host bridge scanning should happen
> during early boot, but theoretically possible with the way the PCI core
> code is structured. I did not see way to structurally ensure these 2
> things cannot race. A lot of the host bridge scanning happens without
> taking the rescan lock, for example.

After working on this more, I do see a way to simplify the logic in
pci_liveupdate_preserve_bus_numbers().

pci_liveupdate_preserve_bus_numbers() is used in 2 places during
scanning. First to decide if the PCI core should preserve bus numbers or
is free to allocate new ones, and second to decide if the PCI core is
allowed to assign bus numbers to bridges that are missing bus numbers.

The latter case should never happen during initial scanning unless a
bridge was somehow reset during the kexec, but could legitimately happen
if a bridge is later hot-plugged and I did not want Live Update to
unnecessarily break that scenario. But then that creates this problem
where pci_has_incoming_preserved_devices() can suddenly flip from true
to false at any time and I needed all the complex logic to keep it
consistent for a given scan.

Instead we can split the handling of these cases:

 1. When the PCI core needs to decide if it should preserve bus numbers
    due to Live Update, pci_liveupdate_preserve_bus_numbers() can return
    true forever if any device was preserved by the previous kernel,
    which simplifies the logic.

 2. Then to handle the case of a bridge is enumerated that does not have
    bus numbers assigned, we can handle that separately. If we reorder this
    with the next commit so the PCI core knows exactly which bridges have
    preserved downstream endpoints, then it is possible to determine if it
    is safe for the PCI core to allow bus numbers to be assigned to an
    unconfigured bridge.

After re-ordering, we can end up with something like this:

  bool pci_liveupdate_preserve_bus_numbers(void)
  {
  	return pci_liveupdate.had_incoming;
  }

  bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
  {
  	struct pci_dev *bridge;

  	for_each_pci_bridge(bridge, bus) {
  		if (!bridge->liveupdate.was_incoming || bridge->subordinate)
  			continue;

  		pci_err(dev, "Not assigning bus numbers, preserved bridge %s lost its bus number configuration\n",
  			pci_name(bridge));
  		return true;
  	}

  	return false;
  }

The net effect on pci_scan_bridge_extend() is:

  bool preserve_bus_numbers = !pcibios_assign_all_busses() ||
  			    pci_liveupdate_preserve_bus_numbers();
  ...
  	if (pci_liveupdate_refuse_bus_numbers(bus, dev))
  		goto out;

We could further scope pci_liveupdate_preserve_bus_numbers() to only
return true for host bridges with preserved endpoints downstream, but
that doesn't seem worth the extra complexity. It also seems nice to keep
the pci_liveupdate_preserve_bus_numbers() policy global to match how the
existing pcibios_assign_all_busses() policy is global.

Does that look reasonable?

