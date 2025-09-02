Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64134CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B048E0008; Tue,  2 Sep 2025 07:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2158E0001; Tue,  2 Sep 2025 07:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2EE58E0008; Tue,  2 Sep 2025 07:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91A9F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:44:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40FDA1A0C29
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:44:48 +0000 (UTC)
X-FDA: 83844128256.20.DC9563F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 85484C000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:44:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GcGkOYvo;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756813486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/dvqOus0XyjyhWt95La5h1ta2/lykd/DYGgkrxXOj0=;
	b=qUoU+BxDb0y1sHLGrqgrCpfjDcdUjhxs7Rjp3n49O8xJI9TjpCDAK9WtErtOFANOEQaVbH
	2bILGZIdsUk5cBt2+wB+xN0w0jqnwm3nT9PFOTz6nT7Lm615eVPRXhBdxZHyoYFuKqh3Zg
	DM7xSOTCi2m+8zaEV+lpqU2Q5m7vNdA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GcGkOYvo;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756813486; a=rsa-sha256;
	cv=none;
	b=gFgMbU0dR3XXEcq4vz4xVMjzFA3yUEyP2u2XKQvQoJfayYlj0tkM1oRTyz8enGMtL0U232
	rMkQ4tE8AgniJLJy1T+9fwdGxYlXfAyZqU+FGSaUeKDRVAKw+0a0j/bcFB26Q5SF3YKw3F
	eeMiR4ONq0L0tlMcRUgrebVU3dmE7RY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE96644ABE;
	Tue,  2 Sep 2025 11:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0680C4CEED;
	Tue,  2 Sep 2025 11:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756813484;
	bh=PsdWXEKScSpvyy0S+Dxl056IK+zdYsrlrpfYJKzyZ9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GcGkOYvoGCguKJ/jUPJf7VxrZdwrL4lVESQFTriaR2Al6lroyZ1GB6QAt5k5qWJf6
	 q3qN+YuCyjEj06tqOyAvFa6LmxWY+fkNRRvM2Fm/FaWZ47BrhQ57c5IkbTs+Kmjbxo
	 jYn3m/b2Qt+qEWFTfr7Motq5MlPMe1vWqQ2sCSESTGio/7/xhmbPYdOH4Q1OcuVHUj
	 0Qf6LRJj60aZatHetbId9ILp7QfUSrYcYBf+2DcIKerzqQP4jv1B+F4QtNdlONUyTb
	 oqSiFYIiLItMyOvFUFDVomGAq1PbDiyqYtk62VAgEE+tHDutp1f6++/ufGbmNlFvY7
	 geX873CKX7JcA==
Date: Tue, 2 Sep 2025 14:44:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <aLbYk30V2EEJJtAf@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250826162019.GD2130239@nvidia.com>
 <aLXIcUwt0HVzRpYW@kernel.org>
 <mafs0ldmyw1hp.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0ldmyw1hp.fsf@kernel.org>
X-Rspamd-Queue-Id: 85484C000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hkpiq3ppzytg4qugqbcu4xe8zpnw333f
X-HE-Tag: 1756813486-957327
X-HE-Meta: U2FsdGVkX19mduJDllQpT+sSlOY3p5FhLVO/gwGgDOt4dIf3moUIffahdHUh6egf35myxWxkk8VxDcj2d85Qk0P3Qy2+PAhI7uV0s+uRJmYShrClQU4qfnwHO/w2jgLvGA/8cmIsRUjou9wDJs7vw6kZEZra0lTDTB2EcL0GOa7ZfxY+RDgDGVAgaju36ao/4+POrDIoWNG7lC2Ps5q86S1JEY2kjWzBUKeKbMnc3AYO3DAt/p7RzLzYMnVcB/2MEW1TLeLRmo/hLPj9ezpJi1znPb5QKt2xNrsq5spVCQL/iE7n8bzm9YsJP0gGVuySSxi/EfzD2Hp7WwHDItBwW/HJG7vPkilqvVbkwWYNn476I3UnucUfXIansElghNscNPGnyaMMrjsgPCFbEH9uFYgvvRgg3jd2AWW47IKgg+YfKijf4Txi3k2LTKG4Q4feq/qr/ga56/X4rmIOd5kgWNoE6d3KAtRuqjJQGPN0V03OyLDlvz4wCFFNKHJwA9IwjsLQVz+UC8xvG3x/X7D8SV9PUFdNqTUXcXcD0UH+GBHI6jVfZ/P+lo0etu1SpXeIyZ3s7EUruf+5cy68fDAgbRT2xLWTYrx0mJwqFnkRj9nrNch1L9RdngDLgKteGz9/ZWAv/6rUXiyBjdqN+VBfHgAuWvzLQNY1l+HIznGNDabDLZ2YpbQj9W1ZREnhsS4/oxmRFGwKiT9QKFhtMxc4s2NRtb7ASF91sAgUMZX7lb4wkpWkyRHEJhjKrlLfx1HTxiuc0rsW+6s3/t0zMiUgCiAGHMIQWU0CcwgHQA+uJUPUV4ghOmFlC/kZsshBgMJH7u2VhONWKJf1pjsstHJG0D6RyvFGu+1VqaoR6lr/wPw9DMm56LQzxSESsfnn1J1/1ruytKMy6cFjt+QbTrHMn4Rfu/OHI06nWIGGK4gKzmsm5t4wkfexLqoPtRB6VRrXVwp7AHFElYOu0vLCk0D
 xs7i8L/5
 ePwtT3k3LFZC4pqTa0bc4n4hO/cdzpXEsI1u1YZyPOGsHkYg24OddLNs5yzpl59VKA7Cmn1eK6n7weRRT4s09FVuS/j9ADttQRRyUPwa60IoC2R1wNcKsNcB/v/+m7wchxbvXXXoaEfpM15rDm/gwm8MmboFgN+0GEC9OXCj642Jt9geGKQbqG6SIlxcqqXPAcZEk4rbeisi47EtRYEXYiVmP8nrHdP/CTnoxw4DbuRDWuSpTDIAw745KG4NplUst2BMJ8f+vJrl4mR9I6uImd83r7uQuBz2sLPa3gAkeBbJQu44Oa5y8HvaF8cKauWqqSBQX/lapetJCi0+0z2In7T2SQC+oLUuIJmku
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

On Mon, Sep 01, 2025 at 07:01:38PM +0200, Pratyush Yadav wrote:
> Hi Mike,
> 
> On Mon, Sep 01 2025, Mike Rapoport wrote:
> 
> > On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
> >> On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
> >> 
> >> > +	/*
> >> > +	 * Most of the space should be taken by preserved folios. So take its
> >> > +	 * size, plus a page for other properties.
> >> > +	 */
> >> > +	fdt = memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_SIZE);
> >> > +	if (!fdt) {
> >> > +		err = -ENOMEM;
> >> > +		goto err_unpin;
> >> > +	}
> >> 
> >> This doesn't seem to have any versioning scheme, it really should..
> >> 
> >> > +	err = fdt_property_placeholder(fdt, "folios", preserved_size,
> >> > +				       (void **)&preserved_folios);
> >> > +	if (err) {
> >> > +		pr_err("Failed to reserve folios property in FDT: %s\n",
> >> > +		       fdt_strerror(err));
> >> > +		err = -ENOMEM;
> >> > +		goto err_free_fdt;
> >> > +	}
> >> 
> >> Yuk.
> >> 
> >> This really wants some luo helper
> >> 
> >> 'luo alloc array'
> >> 'luo restore array'
> >> 'luo free array'
> >
> > We can just add kho_{preserve,restore}_vmalloc(). I've drafted it here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/vmalloc/v1
> >
> > Will wait for kbuild and then send proper patches.
> 
> I have been working on something similar, but in a more generic way.
> 
> I have implemented a sparse KHO-preservable array (called kho_array)
> with xarray like properties. It can take in 4-byte aligned pointers and
> supports saving non-pointer values similar to xa_mk_value(). For now it
> doesn't support multi-index entries, but if needed the data format can
> be extended to support it as well.
> 
> The structure is very similar to what you have implemented. It uses a
> linked list of pages with some metadata at the head of each page.
> 
> I have used it for memfd preservation, and I think it is quite
> versatile. For example, your kho_preserve_vmalloc() can be very easily
> built on top of this kho_array by simply saving each physical page
> address at consecutive indices in the array.

I've started to work on something similar to your kho_array for memfd case
and then I thought that since we know the size of the array we can simply
vmalloc it and preserve vmalloc, and that lead me to implementing
preservation of vmalloc :)

I like the idea to have kho_array for cases when we don't know the amount
of data to preserve in advance, but for memfd as it's currently
implemented I think that allocating and preserving vmalloc is simpler.

As for porting kho_preserve_vmalloc() to kho_array, I also feel that it
would just make kho_preserve_vmalloc() more complex and I'd rather simplify
it even more, e.g. with preallocating all the pages that preserve indices
in advance.
 
> The code is still WIP and currently a bit hacky, but I will clean it up
> in a couple days and I think it should be ready for posting. You can
> find the current version at [0][1]. Would be good to hear your thoughts,
> and if you agree with the approach, I can also port
> kho_preserve_vmalloc() to work on top of kho_array as well.
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/commit/?h=kho-array&id=cf4c04c1e9ac854e3297018ad6dada17c54a59af
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/commit/?h=kho-array&id=5eb0d7316274a9c87acaeedd86941979fc4baf96
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

