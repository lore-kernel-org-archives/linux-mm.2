Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D81C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 04:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E686B00C2; Wed, 22 Jul 2026 00:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F7E6B00C9; Wed, 22 Jul 2026 00:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855796B00CB; Wed, 22 Jul 2026 00:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 61FB66B00C2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:15:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA1FFC0357
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:15:23 +0000 (UTC)
X-FDA: 85015098126.08.0FA25CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3DA7C40004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:15:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fm62kkMp;
	spf=pass (imf17.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784693722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjWoXeUsuihxAtS7FsL2okB6tKsuwtAGig0KCI2ANJc=;
	b=HRpsKuW4n5SZq/scrcDX05Cf75CenuZdABXX0fj9c6kdvLp+z6GSImX4WW4ZLEr4FJ1zmQ
	4bQhVfUfqZN7TTfpQFTsx3BRC5QBDXV5pAqDa0jmbS/metp/269wpBiqol3/CYsKI9kkpg
	KU0mkep9QNZUM9JcjgFHIEey70h5sUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784693722;
	b=TgntvR5z1kH671+w68/4O8nXQ+BlN28Qqp+WT6SQ7JhRdXDif3B3NlyRCnU5pD/Bk9jcpJ
	C5G2TPCWye/rrHFwRTmz45fbhTbh3ort4v5dlxaZ6eGL6v6a+/PCTsqeQN8Ym1kenRy6XS
	OKOIQFskokGWpfnOLUh96pm90E8TUlQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fm62kkMp;
	spf=pass (imf17.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 941AC601EC;
	Wed, 22 Jul 2026 04:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C870A1F000E9;
	Wed, 22 Jul 2026 04:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784693721;
	bh=sjWoXeUsuihxAtS7FsL2okB6tKsuwtAGig0KCI2ANJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fm62kkMp8EGXL0Bk2nd8liF0rcgGYvmNHL2xGKQfTLZL2kSPA8y1n/abjhkfNeM76
	 lX6Xsr8MYRgisl+17CNTa4FPyTHAcdfrDKI1ChOwvf3wOdKAPsY0n0lSl6TjtX7RTs
	 YnZCYrvJ8m/GVM4GdAwXhp0Z0X+WtVsPfSrvJo0eX8t4hwb2fnJwFdJysGk3XL6Pj4
	 BoqYQwXRBoUJSsH+EaCmkpYMFKzM+R0v/Avjz2UnnDS1EVVN8mf0Rp1KpvShzKxvlT
	 Ge0rZLZwY9SUMUTejgeT0I9HqBpG6z/HXFAgB5kK15w3Ez2nzYEwcv2LPuowLBy/wQ
	 XM0p4eY5PHmsg==
Date: Wed, 22 Jul 2026 13:15:18 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Dan Williams <djbw@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, linux-pci@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 1/2] mm: Add unmap_mapping_file() helper
Message-ID: <20260722030916.GA2513661@rocinante>
References: <20260721185252.1670958-1-kwilczynski@kernel.org>
 <20260721185252.1670958-2-kwilczynski@kernel.org>
 <5a43053d-8d08-4fda-82e3-bda10ca79c92@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a43053d-8d08-4fda-82e3-bda10ca79c92@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3DA7C40004
X-Stat-Signature: iqj14a5ao3cp7naj9xfsd4cz6pezafxi
X-HE-Tag: 1784693722-275323
X-HE-Meta: U2FsdGVkX1+Xw5IEe7KsZWi0Hf2rOkBFgwVdz288eZZqKryMVTvsil8WflMSPktSGqZ/wrdFFGjJShPQEV3UScEuQA/9g1dPBqQzSdRIQyvYuUpKUv7dClQvR5YY19tB27fMbjrU29NvoQmF/ynUDQU5SzLrZ+2cJNcfp4mUB3VyBJ8ksls+aADvdH7kOzeRfVS2Y10lYww4M1MH+U6clczI3WLzYAyvIqXs+161RG+tHyiHI1CDxrBMxZP6aNwCzs3UhXshxaQwH7oRhO//Qhh1B1aQdhTf3a/Ulhrbsu3TngF4GQl/iBv2tii8PJozMaaMttzgx+q2b7IReyPMy+Yld+menbBT0jQTZ+gSnluCDNFAaNoaG2zG6mHIvx9DmAXDeWxFKAoxErBUPZPArLTjWO7k6MvrS0y4K3PFzJYZrs2NWpImnDXZsd3CgvcwGIApUfBVE+sr+YO4IuCSFgsHitjyLO+LHcPkhGPZSsdjVSoKa35WY9nL/GxuYbwY9gRf2xUe1Ho+7Sk1/XV06ARqA3dLlfkEBi7l0ykzJQ5aZjv19BF6rX5sA2ujNqtBl0U8PYp3mGaX7/SWfrNG7UI2qVK8d3KaL1dqbaWkeMFfeuGqnaSlIFDYEN5jNW6Ez+7SRfb4Id3SEOhZ9r2/k+iPJuFrPH7AXcFCq58kPh8wNz2gde84a7MYqPSC0AgChbQOu6ABhsbCXcsP90Ibe485wuHynLugRJAlnGSOdQyiqorgboYJs1hig+b5LXzQyZeYDfqZLZr8Q62eqE4XKinOB6mVe+m6QYroYoldoZmze/2AXjHGfpLfR/+rgQRNnwiS9sy9Kx20ZENnPEH2h3vvi0iyCS8JqjWtoo0uT4Ahg/lcO2HWx29K/BYv6xfEJuCt6EUz3bIMgpZiaicWUYOmBgdxYWiAIB8TicFUmP5LdNieWcfHfWX6rvlVP8l+vVQkf4qje8bkIkATqGU
 7ejFG3OQ
 BsixTih0aqR+wg6Ww+tLNaQdJVUCzzATlJci0mOUNv6/AhOyEqY/h1fnI4TnXRxDMxOhUckQuchRlD5nthCNirpWvVtRH+KPQM9WspbNX6mgjMab6oXXLtx+yjDfEEZjkxMwgsCHdgvYPFl4w2kJ+/328tJindtV3cp3f/3+AAW19Nl9eJ22Bgun8HbBkM064+aGKx6gvXhTBMXC2saIQ2uGr2la7B2ukur+0+Y52YEvYWG0I5yzRzTbBNUwBaYmb6ni+eyrrFbZ1cs29zlS1s7FmADx9dnaazCf+R2qEi1TGBVM4o8iezIF+pmcoF/yzqX7K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

> > + * unmap_mapping_file() - Unmap all mmaps of an open file.
> > + * @file: The file to unmap.
> 
> We are unmapping pages/folios, not really mmaps.
> 
> "Unmap folio from all mmaps of a file." ?

Got it.  I will make sure that v2 has the wording improved.

> > + * space it is attached to.  This also covers files with f_mapping
> > + * swapped to a different address space at open time, since such VMAs
> > + * cannot be found through the file's own inode mapping.
> 
> God this is confusing :)

Sorry about that!  I am not very familiar with the inner workings of
mm/, so please bear with me here a little. :)

> Sorry for the stupid question, but why can't we call
> 
> 	unmap_mapping_range(file->f_mapping, 0, 0, 1);

Since commit 636b21b50152 ("PCI: Revoke mappings like devmem") the PCI
resource and legacy files swap their f_mapping to the shared iomem
address space returned by iomem_get_mapping(), so that revoke_iomem()
can zap existing mappings when a driver claims a region.

That address space holds the VMAs of every resourceN file of every PCI
device, the /proc/bus/pci mappings, and every /dev/mem mapping in the
system.

So, calling unmap_mapping_range(file->f_mapping, 0, 0, 1) from
kernfs_drain_open_files() would then zap all of them on any
single device removal as a side effect.  This is not ideal.

I have tried exactly that, to be sure: mmap resource0 of two different
devices, then remove one of them.  The mapping of the other device was
torn down as well, and the next access through it got SIGBUS, even
though that device was alive and bound.

Hence the new helper, especially since kernfs does not know which
physical range belongs to the file being removed.  Only the PCI side
does.  The struct file in vma->vm_file was the only thing I could
think of to use as a filter.

> What is a bit annoying is that you now do in the caller:
> 
> 	if (of->file->f_mapping != inode->i_mapping)
> 		unmap_mapping_file(of->file);
> 	else
> 		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
> 
> Shouldn't we just have one function that takes care of that internally ... so
> it's harder to get wrong?

The idea was to introduce as little change under mm/ as possible, keeping
things inside kernfs, which is the de facto consumer of the API from mm/,
so I wanted to make it obvious at the call site what needs to be done, so
to speak.

I will change it, such that in v2, kernfs will simply call
unmap_mapping_file(), and the helper will take care of both cases
internally.

Thank you for the review!

	Krzysztof

