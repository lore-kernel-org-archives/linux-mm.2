Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F19D6C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 18:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894616B0088; Tue, 15 Sep 2026 14:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845C36B008C; Tue, 15 Sep 2026 14:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758F36B0092; Tue, 15 Sep 2026 14:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4939C6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:38:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A12BF140513
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:37:59 +0000 (UTC)
X-FDA: 85216855878.05.5C1B067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0224C40006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:37:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEoX88do;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789497478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E02YgiBpyTZKu+31wR0tLr5bMzt07hhGwsEwCkmANk=;
	b=5VqmMhKUis29eCEMMGRPVLn1hO2qdKP5trTFQsqS9yKN/119zJRdH0FJEFQruNlw+bxi29
	6xUu5gGtlM677f0XDT4FNjVYb+8x+r5vX4O0wRkg62F445HaGzCr11S42jXepOYTlpCvqA
	evyDW5uEU5G5AdfN0SOMsox13O5rOmA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789497478;
	b=RnUOFLl2PAEd/5BsdsGuu7gRhVp4t+SxLBdicveg6i/wpdNjbillZpLBZmv8uYVNOvbgu6
	MoWh+5cMoRdTnkMLFkEF2xSr7bnlU7+WkkdyIVxQRlzyQU67uFIPwzLWEF8a5yYKNooMOD
	E/Q+1kWmYA7Q2hrFmQzGkc87S4iN31s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEoX88do;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA84F43837;
	Tue, 15 Sep 2026 18:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E1E1F000FF;
	Tue, 15 Sep 2026 18:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789497476;
	bh=9E02YgiBpyTZKu+31wR0tLr5bMzt07hhGwsEwCkmANk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PEoX88doD61Dy5rzbllW/FcIDDbOq4DAALPWfQIeJTitzhFY2rnYcoTHy0BiUFznO
	 Nxxa6CD3mv9ZnfYYdheKxsLrCafA3LYDp3mvc9ybz1wpI8eydhTIYMP7+NyqkcqcMq
	 tlq6cyrx73qwfvRaHno0ByQ30zCqG1kzrSha6zZhqfg4qxQNPwvbWrEMvlZRt5Fzi0
	 a9dg7hqmHoQ1llyDSRfJ8ygnA9rOwuo9fqZrnVbkoDCr54PClhxn/7A6iXqSqbQXp9
	 jkQBtAoJI5gIWbbRBgeo6uFprzmZpvR8qW2vN4dkJosfY5Kh9OMnW9rNtpx0b0KihZ
	 6FKLJWX/Dn76Q==
Date: Tue, 15 Sep 2026 21:37:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/13] s390/cmf: Use kmalloc() for the CMB area
Message-ID: <aqmQf-H4yeSnE2Ko@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
 <20260910-s390-cio-ready-v2-6-e931086fdde1@kernel.org>
 <20260914175952.14910Fc6-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914175952.14910Fc6-hca@linux.ibm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0224C40006
X-Stat-Signature: xpozf1nx5y6b9p8rf1ruxz3bhfxebecz
X-Rspam-User: 
X-HE-Tag: 1789497477-826905
X-HE-Meta: U2FsdGVkX19pFkmHS7GVwrrHWy2F9GLBOOpqY1LBiWALUz0N6XnFjqWoTbfzqY0PtmRz5QTlyA7uEQNN1EU6P8Kl93cROxs62IdNkEpYOND1Gf2c8xE+M0tsXJLdV815yXwUoce5K3BctLYcyo8MjdqWZZRFWtiDVjYfh1c+GMXDE8tt52gyNrYxLBvVMsDm1lXoqfA3MwsPtCAc9JOoCmTCv4MLRa9qKVN+c7K0jHF+s37huQNboPp5yFPxckft427itr2NTjyZX9xyj/FOaTnoIuVJjpniOdeYO4moUPikW78MrR+gzE+XeJD8M1Euak3SRrf7ez4icdsyG5oJ9gmbiYDLbVZcsaAfAIH9qNXu+Vu8RzyFsQoNdGShqprtfwsXCIZ0bGiPhf6FBBptdEsJr6BNHLIiZdE2LpC6lQxT0Cpal7Hqb++AHVGdt6GKN9tCCI9wOQX3evlNzJnqKTXGMpFhU4NjFAsUFqdmo9iiVrYZaIbRRbjSh1mCQu1Q34sK62bBWV56uQ6jijgEVxr6x9nLi7kE6zVoUBIKD/9ZouWF/ivsJVCnxqpe4EO0NdLxCzXNbeUW7PfnDn3aM0E2R7/F60r46AH6naxUCqCg8+2vWUZ40IBuJtuhLqecOfrt0mRUDYyjb3Cat0S1kNz1oyrfzFXh0tV7LgMEA+PzJ6m2I9QhqRN3gnOode9tB1Zn4kLdDCXYyqRFna0vDksXu3bZ3W1bkm9UYlmfKlruJqoRfF2pPB0EAbIOkRT345HZ6NsPjnF9afBO3dQgPwPA4qkku8JGiFpSmsUTWXKKC7aaxf2fcGHudanodTANRWmRevQOJQxRUiEqwZiYyAOe0NQz6h/Jdxbh5r6ZaqYM+JdvITovPxXBoyU4mh2lDGrVlnAnea40HVHM8qtsat5itkPRaN4KMvHET+ftIR+umnHxoeYv4ZkQfTap4gikL2sbcK7wYWc98heAdfr
 bWHA44dK
 LTd7/kcnHZdF4FdVCM4Ru9YI00+DdfxyL5Vin+GztkhgMRZcfZHbgTLBmjdzkE1ButjUaw8a0FJHDOkO2EDggJEfBudZo+oyuHapUTVfumI2EYSwnu3cbhEsG1XhPEdhgHREvwC45ZJMkhSG9XQwnsBiygFcePVxdBrQ5zJ5JfHYLPTtu8/GMUuYKYefu83bAoDzlmkgzEbV2tjVe24dnWN+nktkJVr3DneK3T/5/NKlSD5mSAHBOcjcpyNhoYkq68b4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 07:59:52PM +0200, Heiko Carstens wrote:
> On Thu, Sep 10, 2026 at 02:00:08PM +0300, Mike Rapoport (Microsoft) wrote:
> > alloc_cmb() allocates the channel measurement block area shared by
> > devices using the basic channel measurement format.
> ...
> > The measurement block origin must be 32-byte aligned. Each CMB is
> > 32 bytes, so kmalloc() provides the required alignment without rounding
> > the allocation to a power-of-two number of pages. Reject an empty area
> > before allocating it.
> > 
> > Replace use of __get_free_pages() with kmalloc() and free_pages() with
> > kfree().
> ...
> >  		spin_unlock(&cmb_area.lock);
> > -		mem = (void *)__get_free_pages(GFP_KERNEL, get_order(size));
> > +		mem = kmalloc(size, GFP_KERNEL);
> >  		spin_lock(&cmb_area.lock);
> >  
> >  		if (cmb_area.mem) {
> >  			/* ok, another thread was faster */
> > -			free_pages((unsigned long)mem, get_order(size));
> > +			kfree(mem);
> >  		} else if (!mem) {
> >  			/* no luck */
> >  			ret = -ENOMEM;
> 
> This is the only patch which made me raise an eyebrow, since the allocated
> area is smaller. But it looks all good according to the architecture.
> Since the allocation changed anyway, it might also make sense to switch to
> kzalloc() and get rid of the subsequent memset() (not in the context of the
> above diff).

I suppose separate alloc and memset() are there to save a couple of cycles
when another thread is the first to allocate, no idea how important this is
though :)

I can send a patch on top if you'd like.

> But... I doubt it is worth it to send yet another version just for this.
> 
> The whole series looks good to me. Vineeth, Peter, any thoughts?

-- 
Sincerely yours,
Mike.

