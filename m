Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04998C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0978C6B008C; Mon, 28 Sep 2026 06:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F526B0092; Mon, 28 Sep 2026 06:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE486B0093; Mon, 28 Sep 2026 06:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1DAF6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:47:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51807A0166
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:47:28 +0000 (UTC)
X-FDA: 85262844576.07.65A1AE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BAB4BC0006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:47:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcWfISmX;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790592446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+3YGhIQVuikjEH9Od/2nlarFIyWr94t0RF73DpWKTk=;
	b=GgIzfGuBvRv8wQzzlqoeJ+ipS4OLoyVjKsE3/EafQpSQpI9vUtAu1QPqV9hepXSZQKLM/X
	FXRPccP9H21rZ40AITdYG6mNTH3T3UMSif7TLfdMFDB3WheW9mbPVGmBC7a4NMVo1rIe5S
	GH2T3MO0rm9vqeXqi1K3Un/po20/hlY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790592446;
	b=4Z/d0xVZzvEmXSYLRH1/trvYPvrbbNLmsv9T4798GwnaGFyxJQ8MsiRMi0MBJWnvwKWJju
	Yg79O2ry453c2uuxjTJgJnyqAY2MOUfjGP8A/RPtUETZPtCyPOji4gOYaRzjyO7vhsPpKw
	XYHpmzqtF7Qs8iuahMP/8xTOkp/z/d0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcWfISmX;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E87860052;
	Mon, 28 Sep 2026 10:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BDE1F000FF;
	Mon, 28 Sep 2026 10:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790592445;
	bh=N+3YGhIQVuikjEH9Od/2nlarFIyWr94t0RF73DpWKTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dcWfISmXrUEC34CHJtUG268tGTaBmUg7RjiPPaT9yNIHownVE9Y8Zc+m8R91JP3wR
	 /+crlSXdh970zzraM+GQ0kgNqkaRu51M0SdYPzcEFONLuut3jAfVTtZVi3d365QBCH
	 d3Uu/tzl9St+6ODsx0yRoswGrHaT4dtPGt7FiCidzPcfH2WxKYf9w8zrF8BIf2Yw4s
	 LvPmL0nNgk9Sb9228wVg+e7qJoiqvHKbGU+m0wx3mSADSObtAamMLFsgA60PIYzhXf
	 I1I5i9PXfQx/6ZyM6879ZhAj3h+H8eGdUDvGezz8yNDRK0GK02zfRDoOM1MwCygZOa
	 SQuIZivFL6Zog==
Date: Mon, 28 Sep 2026 11:47:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP
 self-merge
Message-ID: <arpFclevdjhgJGtL@gremlin>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <20260920-fix-dontunmap-partial-self-merge-v1-1-6ffb556f8f8b@kernel.org>
 <arpEHIwTy8QxUjI2@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arpEHIwTy8QxUjI2@thinkstation>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAB4BC0006
X-Stat-Signature: 3s4oarx9bnqdsnnyugiu7a86jdapspzf
X-Rspam-User: 
X-HE-Tag: 1790592446-287564
X-HE-Meta: U2FsdGVkX1/UwaJN4Vu+opPrlfErBvd9L3FJNGvJXcJcSa/3jDO5izcl6bXqm/9DygUXEN7bD10mrt2TPYuWh/mxjIKSl0kgm8YX0DqSAY0JQbLq8Edp3sHUpG/gNpAiRies4cI8G9Jsqqe3OWzUh6zci4nN5olqw62WQG9DGrz5jqly8IyikY76r2cBYDsEku9M/swiLvrFeRffTXIRJuuNXV9qBj+AwjxamglIi3a62yA+mudeNB82KyhL2ULiSx71i17cWU9mFPHkr7nUkyyGJ/AzIy/ns87vceLYb5RnOQp/7Cer1Fl92hpi0/rQCs4D/E4vP2kXCijO2koZLUwSnqPE1seorDRA9QpIPj0Kjr9Tr+ZUrba3dVKsJLsZqtWbakRSpexPEkWfkwMlCLx7ZdOv6f3/ZazTRWaLLxe8tbOH3NX70m2osMfesXcmUaE5KCh7FRrW/Mz3ib0vPNxY+FQ1eAAmlZSZVrRMSDX09aid4U2frlsrC1ZUus6Ioz0YXfDGhoDsQkQTdy9ZnmZ17hifyNF/KjzCP6dU407xXiJg9TM5bTAfUuZEkYGZTywkpSwu5CxMDnqrKWLwFEYTBXisXX/FJaOwpIVYDxAS23PSGCxbepFZQpcuofqQUKSAL2e/BCKwoiPBVYeD3ZT5sL02benMNn60o8riPwzX9kstr3qsOxJVR16IDTtfo9Exp714kIfcSQs7+ljRGzh2lv7uKvzSqbGxRUwfphxzCdKllllW22HY3mGyUeJ3w0qex8vSvw83IVPf2+As60e31+kisc9Sh5DJlh1wLXv/nm+4n2IMyy/BTrTbkRiWfvt6M1MW9OuEH0nJnWFennkDKgsIqj3xkE81jU1vDNnohmA2bmLwLwu68tX1c6AFooNvV9uRpNow7ve66wq1nu7jeA76WsBbY0chBz23WEokI9cjoJn+vHiGpWWLl4WP0lDTXy6gqyR4tA8AB3d
 vIBayN2x
 /90wa++THE5B/aNJrbejdtHJOG4QbtVeMb2J6uGuSR6T9zq+Pp5JECM4P09Zj30NTyW6GX2NB9/bF6WOILfw12GwEgk6e1ASdIPJPnCfni7kI80/dDl8oFG1eZaNtBP1YJZCbZTorUwo8etYCYxNfYBfuPFVT8st4uY1h3jm+/52EOdhvY13lAnTdYhP4TZClSkqoHvG0iuwTumxGl4OENEVSPj6r0vcOlCmA1N1kjFOI//C71KGseCZtDYmEtrZtTRt2JeKyMqkNdZ6i3sVSB8N++ymeVwyPgysqGMONxQfczIceSecEXofC8+6w23Mdn5mK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 11:45:21AM +0100, Kiryl Shutsemau wrote:
> On Sun, Sep 20, 2026 at 03:13:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> > The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> > operations that keep the original VMA in place.
> >
> > Historically this has led to a lot of bugs where non-obvious interactions
> > occur between existing mremap() operations and the original VMA.
> >
> > Fix another of these - self-merge.
> >
> > Self-merge occurs when a VMA is moved in front of or behind itself and the
> > attributes of the VMA permit such a merge.
> >
> > Practically this can only happen for unfaulted anonymous VMAs due to the
> > page offset equality requirement for merge:
> >
> >                            |------------|
> >                            |            |
> >                            |            v
> >         |...........||-----------||...........|
> >         |           || unfaulted ||           |
> >         |...........||-----------||...........|
> >               ^            |
> >               |            |
> >               |------------|
> >
> > This becomes problematic if the VMA is configured by the user to
> > mlock-on-fault, i.e. the VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT VMA flags are
> > set.
> >
> > MREMAP_DONTUNMAP clears mlock flags for the source VMA and maintains them
> > for the destination VMA.
> >
> > Self-merge makes this impossible (there is only one VMA) and incorrectly
> > clears the destination VMA's mlock flags.
> >
> > This causes a leak in mm->locked_vm as clearing this flag does not
> > decrement the counter and the VMA no longer has VMA_LOCKED_BIT set so it
> > is not decremented on unmap.
> >
> > Resolve this by simply disallowing a self-merge in this case - the source
> > and destination VMAs are kept distinct and then are able to have distinct
> > mlock() flags.
> >
> > Update dontunmap_complete() to make the now-redundant self-merge check a
> > VM_WARN_ON_ONCE() instead to guard against future regressions.
> >
> > Also update the VMA userland tests to reflect the change.
> >
> > Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks!

>
> One thing: mlock semantics of MREMAP_DONTUNMAP are not documented in the
> man pages, only in the commit that added the flag. It can be surprising
> that the source gets munlocked. I am not even sure it is the right thing
> to do.

It's unavoidable as the source no longer has anything mapped (page tables moved)
and it's not correct for it to be marked as mlock()'d in that case.

Ack on man page update, I'll add to my TODO!

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

