Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4628CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 10:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D736B008C; Mon, 18 May 2026 06:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DE36B0092; Mon, 18 May 2026 06:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B926B0093; Mon, 18 May 2026 06:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 090A76B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:25:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D18191A08B3
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:25:03 +0000 (UTC)
X-FDA: 84780157686.10.E9F43AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3340B40006
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:25:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QL40FalZ;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779099902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAqOsSLym+XBOYzLEvzowSCyylHb8xiDVGBdrHRUPUI=;
	b=FIrrtLjU8qmBpPY+z3uNCftKwiQMJ1tX6jNGZXtIQ/DxQ53fUDOEilUEU0XZ56QPg+V5mw
	AGdqMtezxrZKPvIdSKiBmbCpof+hE6A0skWrY03LOCbF/x9VTy7FA6wwmJ3szRAWwhzP6g
	AsUBPAI2HOkQkKzml46vTNz2Y7+Y5ik=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QL40FalZ;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779099902; a=rsa-sha256;
	cv=none;
	b=5kXNKFv2MKxTFh/n1GxoTBywsslqCBcmOgjXSH1u5Ekh4cVrJPoicXC7qItEPiL8iycHfH
	/XOTmHHKh70P9ro684LnXavoJwOxYvQf2rdnRmmbJ+1SAiOzETIIhR7vknggux4kGB8R3d
	27VIlaCuPUVlIsJUIH6i/x2ezqa1dp8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6367040600;
	Mon, 18 May 2026 10:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4ADC2BCB7;
	Mon, 18 May 2026 10:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779099901;
	bh=j7mf6Kdf6l70/4pk/tyJ3bKlLlrcFLC7yjtQUp3i91Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QL40FalZLXr4lz3Y73LUyCmjBdkdQEJ35L07VupPwwLQ2B+hSZQnxgOI8BSqO9bBg
	 5Bcm5lQdGAEnQ21+86M1VBVrCuzmetIYnR61ef0QY0u7J9BnaZ0YllvjGOG0lY4xZj
	 NaUii0rtNKjv8HLHPxk0U/GeC9/7UXGgBslpuLCblq2qSkJUTxp9AsnBbX26Z0hR+1
	 3yEuvmJxXd/cQoTYLRTPV/gg/gz2duZKXeB3D1ROPfyJhOnVlahAk2ubtqJ9bqG24U
	 UpnTUPnhoKZWxchJZmxsU4EKuG/XxPGTbJavDDCrnzfgnzau2ctHnWXnp4Jo16hAP3
	 adckkSFaijWMw==
Date: Mon, 18 May 2026 11:24:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Yury Norov <ynorov@nvidia.com>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Andy Shevchenko <andriy.shevchenko@intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
Message-ID: <agro2zaEwjWCYxAh@lucifer>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
 <20260517123428.1181981-5-thorsten.blum@linux.dev>
 <agnehRPd6SeoO9ie@yury>
 <20260518100933.6bfe5b8f@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518100933.6bfe5b8f@pumpkin>
X-Stat-Signature: ezms3nwsmx5j879781mntaxdsqtiboi8
X-Rspamd-Queue-Id: 3340B40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779099901-582948
X-HE-Meta: U2FsdGVkX1+U2Z7RmofnvEmhiISISTe6ZMyNUwuAYmSCFzzEFJj4QS0Ar/I08sm1uaDbMfUNkzwHXwzmdkcLkcxU4GtwA/pmbhEqsSIPFAAsGqY31BBKKs4yOR9ZLEtraoPDGkVhuIfICT6Eq16P4024zG7VfLB6MxzSak1MTTEHT3WvPh7qxokQm+HE4bNq/OWpZOSbam/0UcxWs0Hnm8Jzm4gPKA0HGlL0ywxXE0VcyPuXZ/pe6dNToWFouxd0SbfAytimi81mMJuT4XSQIPISONj6qTc68sDbPZa9NEYpyCAsbLij6e0UnCflWmq9ShwSmu7A1VdN7MLgJzb02pg1pjZXQiY2RAALyB+aCXaCh3PgoRY5QNWaWZVien8uN+gwMl/kaMB22TiJkQKAYqUW9GaFNW75f/+8NWaGG8VjuP4bz647/6osEu6MxLIuV6VFvbYu5DvmV//508k7tmXTB48CP5hAlmNPw4KELFwoWKvR97EN4EcxJNFdbSaDHGTP26gsKsQiVy9EdO6AKUGaE+M3Y9rGvY2jn/LoA2sSfnrdC9fWewUi7I5esReBDnvST2PKqCbbHFEsSmycgK4QlmCPVSu1QBKByhDpjGEJBM9Kqq7l32zrKFcPrsa8AsAexyvjKkDsSFSOOgdzZzyFZlulpPILvDHdurE1J9JuV7lDvVjfYdpn2E2ESVZsQ8rJU4ulIt6KKpf1pz+Dw94AxIHvoJ2IXU9OYcd0CAQg7QMcwH8JPfjUPpZeNBqGTdBL2IyDfBEg29kARcMV3txDEsC1GFUpXI7ehGKe/Y/+PMgYJxDPtZsjJ1/EV+BaxxEfQtfhtpHAUl1jZj+QXmbQOb3gli1iYo0Bj5CnEgtzvFI3BMgt193OkIJrQ1pfFlva3HXYbKL/MPI9ciRUuCQXjUHuuCp4jA47myZq3pAGBXts0sNjNZtWGRtY/svn4dztxFTa36YNlRIyx8a
 Ni7UKTUN
 1zqR+zrjjcz9l5GCCMfeZmx+cc6Wa+3gfl4KYKRtgFXJuCb6nOL3xw4Jv9bYboB2ZZdhJE/WKFb7jg5fB+zJIiH3Jxv3jWILoHRPxNurWr/LfoSuAvMOLoK3yxfRkvb0YrtBLFEH+HTJY5QKQIryCrow/9iq8aH81a/YZxyevCGl4h2pMsMmr37rgRmtinAefTKw8bSB6nZG3zmcpy1jghQWgZ67e22ljYbiZRKbvbfK+8FHXNwEN6V9+2b6Iho0K2PXEQyxS4e2b8bXRbZbgew+OkZGl2L4L+it6GhVmoy6bkCO+DMltEKT/cnP2Az0nKLQbBWrmFHs8DQ3TlkZaTNzz6u/+KHZz31g/d6Meui5Nvy+J7ge8Os4dpfpfBKPboyIt+wsHky8HwQwaM3Ju7TcS9OOKKRfWu8PVI1f5h2MbspJ+t/Rf1FXi/B2a3lTveOuN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 10:09:33AM +0100, David Laight wrote:
> On Sun, 17 May 2026 11:28:05 -0400
> Yury Norov <ynorov@nvidia.com> wrote:
>
> > On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:
> > > Add bytes_to_page_end() for the common PAGE_SIZE - offset_in_page()
> > > calculation.
> > >
> > > Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> > > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > > ---
> > >  include/linux/page_helpers.h | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/include/linux/page_helpers.h b/include/linux/page_helpers.h
> > > index 102a4f3c3868..981731faa1fc 100644
> > > --- a/include/linux/page_helpers.h
> > > +++ b/include/linux/page_helpers.h
> > > @@ -6,5 +6,6 @@
> > >  #include <asm/page.h>
> > >
> > >  #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> > > +#define bytes_to_page_end(p)	(PAGE_SIZE - offset_in_page(p))
> > >
> > >  #endif /* _LINUX_PAGE_HELPERS_H */
> >
> > I've got a series for this
> >
> > https://lore.kernel.org/all/20260303182845.250bb2de@kernel.org/
> >
> > The feedback is surprisingly negative. Please add people from that
> > thread. Maybe you'll be more successful convincing them.
>
> I don't think you need a another new header.
> There is already vdso/page.h which is where PAGE_MASK comes from.

Yeah please don't, that's already a weird situation I don't really love the idea
of extending that.

mm_types.h seems the more appropriate place.

>
> -- David
>
> >
> > Thanks,
> > Yury
> >
>

Thanks, Lorenzo

