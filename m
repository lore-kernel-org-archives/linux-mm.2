Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B6F606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IaxxUP7L
Received: by kanga.kvack.org (Postfix)
	id 6BDC36B089E; Wed, 25 Nov 2026 09:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D9C6B0A43; Wed, 25 Nov 2026 09:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CF86B0A44; Wed, 25 Nov 2026 09:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 266EF6B0A41
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:43:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B70C01C3C1A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:43:57 +0000 (UTC)
X-FDA: 85473910914.26.B994BF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2301140006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:43:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IaxxUP7L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795617836;
	b=SW0eABxQIB4R/bTxP7IoPIA5/FEuv4QtkfzHoI8uPsuYDm88/U7LQJk91FGQtCki1YdLEm
	f+i0ROrRp90Ayl5bKMi57Nlta471pxoxlCE47lY7DHiv68FXcpfuHfZKVx+vVN2fx/2QCK
	XeTZnl/VkRWAZRhVbC2vxOrnQSW8zjA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795617836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSDBbrxDF7QE7mJ7cGh5psk8NDNsiMzdc0pE9t4TEt8=;
	b=wK3oXmk1VZCHvBh+WhF5pgI/CukVsoJxW3yfPhw82dZXaAz8F0JHppPWuH5FnF69i2Igas
	lCndrMas3qdGpxq+tcaZrCpjyO9En3nsFqM/Z9X3+FLIRerL1XVozjmR7DY9og5BHx7oFc
	byhKBULSsiED/R2epuYRPTOy5hW69O0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IaxxUP7L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9802761140;
	Wed, 25 Nov 2026 14:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3521F000C6;
	Wed, 25 Nov 2026 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795617835;
	bh=DSDBbrxDF7QE7mJ7cGh5psk8NDNsiMzdc0pE9t4TEt8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IaxxUP7LRnqywT22he7m+Fp7ezJgAfkpHSw5REph0tRYPRC/9tQDBnxNGaqFCUe0P
	 HC4OCPR1FvefXZR0jreOarx1/ItxF0Kd5XwRm18+njWXI6kfrP7K+QHWF1l9XvxXHk
	 Wb3T7KBp5sU8Uq3JjMSsDtDz2cQ1vDbxW6cRqzm0jkDQjr5S84bbH7Zbc/9r5XtFga
	 tXPaD+SS8GZvYPYpD187DBOSIhZ28zt4gF80M0lT+Uc0vOeuoEM5ntTj2myprO+Uo6
	 0KAYN/vccLRY3U4aBHQmotXHdObAadnDVOITnax/jMq8UASOsc7R09dQV9GiPujVaw
	 zu/OOYjuPVOYA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Matlack" <dmatlack@google.com>
Cc: "Pratyush Yadav" <pratyush@kernel.org>,  "Tarun Sahu"
 <tarunsahu@google.com>,  "Pasha Tatashin" <pasha.tatashin@soleen.com>,
  "Mike Rapoport" <rppt@kernel.org>,  <robin.murphy@arm.com>,
  <maz@kernel.org>,  <will@kernel.org>,  "Alexander Graf"
 <graf@amazon.com>,  <seanjc@google.com>,  <jgg@nvidia.com>,
  <loganodell@google.com>,  <arnd@arndb.de>,  <dwmw2@infradead.org>,
  <baolu.lu@linux.intel.com>,  "Bjorn Helgaas" <bhelgaas@google.com>,
  <oupton@kernel.org>,  <alex@shazbot.org>,  <gle.com@google.com>,
  <pbonzini@redhat.com>,  "Andrew Morton" <akpm@linux-foundation.org>,
  <kevin.tian@intel.com>,  <joro@8bytes.org>,  <kvmarm@lists.linux.dev>,
  <linux-pci@vger.kernel.org>,  <kexec@lists.infradead.org>,
  <kvm@vger.kernel.org>,  <iommu@lists.linux.dev>,
  <linux-arm-kernel@lists.infradead.org>,  <skhawaja@google.com>,
  <sagis@google.com>,  <linux-arch@vger.kernel.org>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
In-Reply-To: <DN3VG4JCILOO.YN40XHHSWRPH@google.com> (David Matlack's message
	of "Tue, 24 Nov 2026 16:39:52 -0800")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-4-tarunsahu@google.com>
	<2vxz4idb1i2w.fsf@kernel.org> <DN3VG4JCILOO.YN40XHHSWRPH@google.com>
Date: Wed, 25 Nov 2026 14:43:47 +0000
Message-ID: <2vxzld6hx97g.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 2301140006
X-Stat-Signature: pzrwympofiemakk4x3dhybzw87uzqx4w
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795617835-312836
X-HE-Meta: U2FsdGVkX183tdInt9BHW2NFF6mO/MO4/FSq28y0C7E9BViKRfz68LizivjuW5FlX0+08i3owFiQbFYsLxHZFHGdWSGgTPQ+qi1prm8IJdRiR7/oQuP88zG5/yy8/OIZtJ5rQTHEH3GB/R+kpPWt5o4KwojfRtXqzsUXuUo1RFAzAmIIWCHSxApS/l5aF83H+mj77OYOcV5SL3AGF06ch4wIdUiDv0DsAgk27oXBt9iT3UfXw2+8wynoGa7FbkXgRTpwhKyy0nk9bCbELzYGGriuuP+02peUqLth/SAHBOpDoqVMp8s25QKNIJCyJwEJIAePttgHrab0sK2KPdyvG0NC2mdmM8lkXcqZoYg9BOMZ6VXiFpbh7sHF2iXuhK2YAluaOCG4MMO7sWbFJnwXIZLG576+aHb02dS/PdrQn+ZKBPdoFlB/7lETknYxyP2Fqs0sdqg8w/Q9v3jVlgGGlMkRnzqe7EBehEbvYdc5tly0wOswB8gCn7/lKtexJy4BlXygC1hcN1uFsyJvBDFwgY6YG2IXCrLkhYx/T/ajlynzVke4suTD4ONVQcvYs2gRwkTPM1MOvllJJ1wF5hbOVbNd809oT8gVzZ6KIPxWecSOtgWgTJkXg6zzrpK0Qxa13QZR2FfdMI6oC0Fb8eOSVapPpQYvsZhGWaARA/YoIQXQKzELts9OCC4m3tOyfgSA5dtQp/zGbSa7xFpVG9zqvNFp5gQ6g+XgxeJB4U/HmVBlkhHmmwbJSJN6V+JYhIjzt4bdX6XUQVm4cg9dGyZeQoJfJJGgjtT5oAv2Ryee7xiHxI1oNKNRv3Nhct9lhJWlm0YqgaSO8EH6IOzWmogVQlGoyDs6X0lVxvjbJGtTtuMHw7VX/7rwTk1hQATjzY9JlAkvfFem5n76pesvpwUx/lK/DtknquH0HEBA5JS2vOIrbFP3z8m/rpxMlcS/cAtgAbO3yAZ8LxJ2fUs+VeI
 RDNOWQpQ
 hXsFvlWhsmgi0UGGh/vxSqHIXoqo0ghXtoTjBFZiopmMR08MwQYXlGBZHOnxsfChwkmLuZcdRf6pHCkMse0q6e20yetnOKqr5/dftD9LycWgXDjK8V+IUi4d4DTU9npwirgLlLhpBR3fKqGQeL2hJAbA9P6uQJfxIABxs8QlPsI9XZB9RHAE2MBNVPOPqbRuHm0kO5b5MEGKtQlS/GLL2n8mDSgGld4rHSg+MoBxKz6PSmjzbdZRaGuHVEF9sKcahXvB2xytow73BY32Wue6iOg+5bvBvOQQyDq47QCrBcPp35SvLbFmRGcJkksB3sZ0rlDo9bdiy1loUYusw46Z9VyOCyrYV425U+NGagmzHnu0+hyNyCfZSQ43r+noufM/Oya3RkNC1VY3o2gaoS3X/2NTo2zGhApzpRxeMWdhMRqoC8OlwO2L6ExPt/XTuTc4RlVepIYTaKrSlgoF/xv0FBfhoIKJsmWdBRNfoqdjym2xfSxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24 2026, David Matlack wrote:

> On Fri Nov 20, 2026 at 10:19 AM PST, Pratyush Yadav wrote:
> [...]
>
>>> +static size_t memfd_luo_ser_size(void)
>>> +{
>>> +	return sizeof(struct memfd_luo_ser) + sizeof(struct kho_vmalloc);
>>> +}
>>> +
>>> +static struct memfd_luo_ser *memfd_luo_ser_init(void *mem)
>>> +{
>>> +	struct kho_vmalloc *kho_vmalloc = mem + sizeof(struct memfd_luo_ser);
>>> +	struct memfd_luo_ser *ser = mem;
>>> +
>>> +	KHOSER_STORE_PTR(ser->folios, kho_vmalloc);
>>> +	return ser;
>>> +}
>>> +
>>
>> Hmm, I am not a huge fan of this. This makes doing such allocations
>> quite annoying, and I reckon we will be seeing a fair bit of them in
>> many places.
>>
>> The key observation here is that most file handlers need to allocate a
>> bunch of preserved memory, but they usually can free it all at once. So
>> we can get away with a very simple allocator that hands out memory
>> linearly.
>>
>> I have sketched out some code for this, take a look at the patch below.
>> Note that it is only compile tested.
>>
>> Perhaps give it a try and see if it does the job better.
>
> I agree the manual packing in memfd_luo_ser_init() isn't great, but I'm
> not sure we need an arena. This seems like something KHO slab support
> will solve properly, and since kho_alloc_preserve() already takes a
> size, KHO slab can be dropped in underneath it later without changing
> any callers.

While it would be nice to have, I peeked at what we need for slab
support and it sounds overkill. For one, a slab cache is for fixed size
objects. So you'd need a bucket of slabs for different sizes, similar to
what kmalloc() does. You probably don't want to preserve objects spread
around in kmalloc's buckets, so you would need a set of buckets
dedicated for LUO/KHO.

For another, slab cache is great when you are allocating and freeing a
bunch of objects of varying sizes. But that isn't really the workload
preservation has. Each preservation hook needs to allocate a handful of
objects, and then hold them until unpreserve. This arena style allocator
does the job pretty well.

And finally, the object layout within a page/slab of the cache can
change based on configs or kernel versions. See SLAB_RED_ZONE or KASAN
for example. We would need to standardize the layout without
compromising the non-KHO slab users. We can probably solve these
problems, but I don't expect it to be easy.

So I wouldn't want to support slab until we have file handlers that
churn through a lot of preserved objects.

>
> Until then, maybe we should just allocate struct kho_vmalloc separately
> with kho_alloc_preserve() and accept wasting a folio per object. For
> memfd that's one extra page per preserved file.

Yeah, that is fine too I suppose, at least until we start to run into
problems with the memory overhead. I think the arena style allocator is
fairly straightforward and makes the memory savings easy so to me it
sounds promising.

-- 
Regards,
Pratyush Yadav

