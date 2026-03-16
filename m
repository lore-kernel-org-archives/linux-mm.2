Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 309E9F506E1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9529D6B02CC; Mon, 16 Mar 2026 10:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9102D6B02CE; Mon, 16 Mar 2026 10:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853816B02CF; Mon, 16 Mar 2026 10:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72D896B02CC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:54:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CF36B7125
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:54:47 +0000 (UTC)
X-FDA: 84552223014.12.C35BFF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 89F9620002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:54:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IiVlA9K5;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773672885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Te0xii3h9Y5JOkI81G/oY5beQB8VLtmDVf2X0AXqiGY=;
	b=OZNB0TUH9Zxf0OdoMgVEgyMSf/fgY8mbwKHHfv90i5ZRlMH9jO9wE0pXbSD1sr/DsMvmn9
	A85cNM1Y9QJ2jjvr2IRjiOOhO//RVglKAgrsvGuoTQtNCxwYhMwp3HqG1qeWMt5QHZGcqV
	5RtwRG7TV5C15KM3sthzOnR8/TmvS1U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IiVlA9K5;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773672885; a=rsa-sha256;
	cv=none;
	b=DtaC0+soXSXtlkTcIht55Ho6wOblUYaYvGNC3dvvTqyNzIgn6KFMYPAoaWdtu8WX1FQALH
	sthJveaiZcz47QhjmdVOPDAF/+eBnk9WFP+c4bkXK70m7tI9T5E3R9tHEUuTTIKZuQGPVj
	xOmaMZ3Te0Q+FVJ2yOOkRD/EcYtiqt8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD8B860018;
	Mon, 16 Mar 2026 14:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6787C19421;
	Mon, 16 Mar 2026 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773672884;
	bh=151f3cWiR6axiSpyETGy2809glU/p+Thfrb+WhG7his=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IiVlA9K5MR2pm/vVWcjl3jHa1ZLppG/xkVDg4LYhSHBo7tILA3oKU7/VyDtSsg2Kg
	 kQqyeUnfpOlDxu6AfhX2DKeTc56qG3sgVr8cRvArcJDPpB7MtB8+8m/W1CGm4DXnWU
	 /IAV35ajExH6TG7ujNjLHJy8C1NUnuOmNHMTs/CZoSJyL1gIEFWKuYKmUapF57E+52
	 QtJhwAwyYFC0d6NKgO01Zvw7BDFPVjqf+FrFODQ4Cqwr/bAXtOkwM5wsRJqmso1ekz
	 dUhxuwzJMFbfz9arxSyuA8RSwOjRWaOSv5ZVSyJ0pPvwE3EtZ56ZowEAdLjTcvuW1x
	 yQ/B9jgOXn+mA==
Date: Mon, 16 Mar 2026 14:54:33 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 15/15] mm: add mmap_action_map_kernel_pages[_full]()
Message-ID: <b9474609-4c7e-4cbe-8e6c-d55baa689430@lucifer.local>
References: <cover.1773346620.git.ljs@kernel.org>
 <21d8899bb1f4db61203072fb3a56a6c98a61e23d.1773346620.git.ljs@kernel.org>
 <4fd15134-ae1e-4233-8d5a-9d1e0b9f94dc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fd15134-ae1e-4233-8d5a-9d1e0b9f94dc@infradead.org>
X-Rspamd-Queue-Id: 89F9620002
X-Rspamd-Server: rspam07
X-Stat-Signature: 4xyi3p7r81kts5og64x4sabiax4zd3my
X-Rspam-User: 
X-HE-Tag: 1773672885-707101
X-HE-Meta: U2FsdGVkX19M+fOPUbMcuHL5pAT51SPW8pWtxAGl3O/6qrG8JWLiXeqxXJz0MFkvIxpYC5A7ghb4hNIWOXGTRT8w92mwIlWZajXHfhQJXqW8HgBl6fYzDnvCjKZ3R1QKwb3LDcqER+L41DEELdP+PdbHMsSDOuajr8rtcVXVDeaD4DHHDtY2xasu3Fkc8+TGvbZyEvV8SzkX3esQ+J/jTygQB8TccjpGIAOzDx/tDEo9CfPdxI7kf0Jgg4CJtUwY/X6fTAnksj0oNRQk3LSEkH5sN587KPp4YlfUfScBrBcjLzUqwxyYrlpdfHcqN/EnmyrJFP5Q5EroZ8bSD7TXl2lZLUQt65QoOoR6Ei+sHqQgHhobZuBkrPBGcjxgKMbXQ6Nt2CntuZ0GTiaTtaESsqhmyQisH4n/ktkDHWviOZ36U799LKmXb9Dxl1Xhkf8YKufYP6+u5vBjuWqOLWDXURNhyOeQFoE1ktvzxRkX2Ww/hsGQ5N4TeeXKgZPR05RGhY+Xafrqld89A36xKPYJDgZxP/6gVDGbDh8AcWC2UmkgbYRBtFvhpPE1WRsn3FhK0ofJUiCIYY22qHq81M6IcTgYTGeIAZz+0W3XTyKLdAt9F+HsfYGifdGu7VtCs72cunNlp+Wm8gHD8TmYVibfc1mItoL7a0qy3sAU+Q6VHNDTOOruFYqThVkrM0A4mxmIy8+El1N2+YjbqkBr830tJ57yK8pMMzfoWDzQXsQB6k2qZ2hw6a2Kk/JDTdTHdDyCBx8LcGEVmgyMNOp50mPBNxil57d0ZmtMbQd/VgQ+Uv2/KVGeKZB6AA7QPuVREuxshVq06JfEGg0cuQDSeOWLMTKsaxVT3Hq7dgq+OqtYc3SE9lphLDJp3vz0uuNJchmLZOKSoV1q2yewC6f35luhqPv1xnCGaS2Dizl6pmJXfYLGJUrbHoq5pT8yXV8FBTEishQZET7n+YP9DixgJIo
 hJ7I5xBu
 teJUnOJdyxgCiO/taImAqWbv4Ur71Mcmytodw2PjyS8csqrGzVRaAbmz37x1cSDLGcOAMkw7wO8YZO7ZSFv/GZIm6VcriglmgLlO91iZgzOR0JwCV5XuvX2Gp4wNRBYvl9x99MMqVjUOLbbu08PPjYrgofyGrUlIzJfu0KdsTIwBqFwJWpe/cMWz4QgDD/2mFIVSfhhFWj0PF47e7osO2gNobZQufBFzJglCXwGy6ICSrDCxmQ7mjAdLcXXDonhP/zoljvaFe3mm3CH4CErui7O67bMQVY/YD5hzY6xaaoKM719Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 04:15:26PM -0700, Randy Dunlap wrote:
>
> On 3/12/26 1:27 PM, Lorenzo Stoakes (Oracle) wrote:
>
> > Finally, we update the VMA tests accordingly to reflect the changes.
>
> IMO we could omit the word "we" 5 times above.
> (but no change is required)
>
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 88f42faeb377..88ad5649c02d 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
>
> > +/**
> > + * range_is_subset - Is the specified inner range a subset of the outer range?
> > + * @outer_start: The start of the outer range.
> > + * @outer_end: The exclusive end of the outer range.
> > + * @inner_start: The start of the inner range.
> > + * @inner_end: The exclusive end of the inner range.
> > + *
> > + * Returns %true if [inner_start, inner_end) is a subset of [outer_start,
>
>     * Returns:
> (for kernel-doc)

Ack

>
> > + * outer_end), otherwise %false.
> > + */
> > +static inline bool range_is_subset(unsigned long outer_start,
> > +				   unsigned long outer_end,
> > +				   unsigned long inner_start,
> > +				   unsigned long inner_end)
> > +{
> > +	return outer_start <= inner_start && inner_end <= outer_end;
> > +}
> > +
> > +/**
> > + * range_in_vma - is the specified [@start, @end) range a subset of the VMA?
> > + * @vma: The VMA against which we want to check [@start, @end).
> > + * @start: The start of the range we wish to check.
> > + * @end: The exclusive end of the range we wish to check.
> > + *
> > + * Returns %true if [@start, @end) is a subset of [@vma->vm_start,
>
>     * Returns:

Ack

>
> > + * @vma->vm_end), %false otherwise.
> > + */
> >  static inline bool range_in_vma(const struct vm_area_struct *vma,
> >  				unsigned long start, unsigned long end)
> >  {
> > -	return (vma && vma->vm_start <= start && end <= vma->vm_end);
> > +	if (!vma)
> > +		return false;
> > +
> > +	return range_is_subset(vma->vm_start, vma->vm_end, start, end);
> > +}
> > +
> > +/**
> > + * range_in_vma_desc - is the specified [@start, @end) range a subset of the VMA
> > + * described by @desc, a VMA descriptor?
> > + * @desc: The VMA descriptor against which we want to check [@start, @end).
> > + * @start: The start of the range we wish to check.
> > + * @end: The exclusive end of the range we wish to check.
> > + *
> > + * Returns %true if [@start, @end) is a subset of [@desc->start, @desc->end),
>
>     * Returns:

Ack, I think in general I've seen (or believe I've seen :) other cases without
the colon, so was kinda imitating, but I may also be imagining that ;)

>
> > + * %false otherwise.
> > + */
> > +static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
> > +				     unsigned long start, unsigned long end)
> > +{
> > +	if (!desc)
> > +		return false;
> > +
> > +	return range_is_subset(desc->start, desc->end, start, end);
> >  }
>
> --
> ~Randy
>

Will also fold these changes into the respin!

Cheers, Lorenzo

