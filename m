Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 476EDC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 10:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428D86B008C; Mon, 24 Aug 2026 06:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B28E6B0092; Mon, 24 Aug 2026 06:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1C26B0095; Mon, 24 Aug 2026 06:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0F26B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:32:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 818EC1604B1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:32:45 +0000 (UTC)
X-FDA: 85135799490.08.D6CB86B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7FA22160002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:32:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWvJClqu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787567563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5frcXO7zyG1Iq+1oYF/eoeXxIiDw2PLXMirPuyU5Ds=;
	b=ncpNFRxf1+GX8Q9XMOwK3yQ84MEYVwsSs8CJNQjoNT6gy33Dk2aka/T9ux86F8mRO23+kS
	cfiwa6vY/qAISCJEV2rczkqXGuvUHfnd7SBMe6iFARegL4rn9PqGsdYDMSxumZUTjd0fRT
	utMyqYXyNQdyLDMBa20ZpUpNDUNlOIU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWvJClqu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787567563;
	b=jvftn3RS8hcsPtN61u+VBcjuEw2SB4E1CzVk6bt00Q2YiPAxzSxFOre9FraJwvKYN1ra0m
	AwrmYrgRvMbmOr4FsKD8sEN/qLVsHzhsU3vfoFl2S2/kAg1LTjL4hqLNYKlZT9f2PgLF+s
	aBCLEJA7GScSABfT8JZNcfa5quC03oI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07BCA600C8;
	Mon, 24 Aug 2026 10:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A433B1F00A3D;
	Mon, 24 Aug 2026 10:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787567562;
	bh=Q5frcXO7zyG1Iq+1oYF/eoeXxIiDw2PLXMirPuyU5Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MWvJClqu/WoX2vNp1HHpt69dELCdRP1LmQUOkfPsNqbmy3STXvgyGbQLTVIh4rxQ4
	 AhCvRa/b0IlPXt2+JpUiWfgOzBmksgA2DcMh9mUGOfMgoE772RS2gv7iqXIiiaGEDa
	 v5w4YC4pweJOnLyT3UOc0Vas+hbShvayjuVUhWuyE05V/ftQXM4tmgQTMteGA+hGk/
	 0Cmp9UMN6aXsJZvAKLXUk1d6B3/6wQMUz47lVATKLg9UENmhHNsICKsWZCr5/+KL+z
	 RvA3sNk0YxMmWGwqRFSmku8Hu9aF4SgeIhW3TSuk7QgDGg5zt9EjYfxO4MU5L4b+nx
	 jQZYNPbql0s9Q==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 340EB1980045;
	Mon, 24 Aug 2026 06:32:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 24 Aug 2026 06:32:40 -0400
X-ME-Sender: <xms:xR2Mat51Dq14Ifc99aUyb95-S5hDCrIQDHd4xnuOtiZsMKmRPdO-Jg>
    <xme:xR2MaoXpjywZrb2LVkDn3i2Rxre9MeflCMDt_JKDDb-twDqUsCbh2LPeDICEv0-pJ
    _z9Y6YzvOTpXK0RkxC4_E36RyIKYQzXlBMdZ4DqMDiH9sHOobBvoXcP>
X-ME-Received: <xmr:xR2MakanAAB0IBgBEF-10p2bLsG49PZQud9x4elumks30x6zuROGkEo-rJ4>
X-ME-Proxy-Cause: dmFkZTEYnC3pImoohK99eGhBRTTR7KcVIkdV/ZQBL04BJxb8LYLYJ2gAtfA/2F8kCqKLMQ
    k2kZF/VDDj3pfDzPgVoz381cNo+3r3BSgIqYqZLNYbyqfTz/JHigmzZ8oniTQYrhneKQOf
    EEHdzcTrayFcRlmp5EAZRfT4AYlmPCJfm6md4UjrcbbZ8jHY/3Oc7j8plhP5euwZeuHfUH
    0XcDnrUwXLrzmSxfa75UA7uHzeedDIX9sbAlzTFvmKdd2UxrAiXttuU7y/lfP2onlgcWLy
    /w1CYl5XRSdFYLHkqIo2jI9ebN35arPjMv8Boufoa1sbgloqdErdGlNWkj+ra2OeT2armT
    tBl9hJZ9vFHo06r7FvUgNcpuCc32sIcvvCRfblb2WBG0fQykN0mA3H0z5SiN3rGl5ClKpb
    4oa2g3Z2zarUza7fKkdZgbq0RgGytdm6eufyf/DAf9QH26ndizuw2Z72G9c4d9oW8PXr+M
    HKnQ5UReYPUBTVtWSdDnoSU4Ud/jjbkyo5CQgy8tbbTLYa9QI0p5JTxgtdZN7B8uOzPIGL
    ggSC2cVugUf8xTN7KEYpG9kYBGLljA0/Tr0JydL4GAkn4pxf6s9bL5UWag99cUmOiGnrTQ
    9VjccRmOhi75HC8vqBM/wAxhlPl4O/tedw/d0EzARF8XI3FdGsyJ9WN2ZAVg
X-ME-Proxy: <xmx:xR2Many1XOn6sZW8o77T3GenwaWJ4pHxyfjwSxTuJUTiTwawNUGtMg>
    <xmx:xR2MahIGm6ijXwUWG82qSwyM1phY77W7TNMVWihsL8VRFApu3dOO7Q>
    <xmx:xR2Mamfzazfc8qC3_r-kjSsWlYO_Ze2Yige1nsM7A5LNSeVir119Nw>
    <xmx:xR2MahuWapSxqwL7_2IrnW8Z-9OUwQEZXdkOojC7sdt3PNwaCCBZvQ>
    <xmx:xR2MasGKMQO20ssgPzr_UTuR2xaJmtgHltL8NRTLhF7f9DAacfaBWZ__>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 06:32:37 -0400 (EDT)
Date: Mon, 24 Aug 2026 11:32:35 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aowcYuXEeqdfHmn6@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
 <aohldTtzE2GJ76md@thinkstation>
 <aoh-3XJw82O8SmsA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aoh-3XJw82O8SmsA@gmail.com>
X-Stat-Signature: eqkkw78kythzfccmfk3oxt9u6med1gjm
X-Rspamd-Queue-Id: 7FA22160002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787567563-964136
X-HE-Meta: U2FsdGVkX19hbq91hk6sKox5ZdYZMmNZf6rzDKDnkR8iZEayH6IIN07IsoeZ4kytt74aHcT85/vKUSk7eGBZqpigGN2+3hgRfkjiqb4F6tXQh9c6SWW3y4f4+uE1IGVuWKt1vArA9eEtmogx5HQujwuxuhjvefCot5twC/ieSupdNotIXJFGW2ujnitMS/eN0tqv0NbNsuL2OBwZUuAZT87x6tTZCYUf4SF5K5PnLt3oIQGibycEskqfQ4dW/fO3On8roZcF9NEVn8mwl1Toivs8UxW4aQ4mp+JsoPLFj46e47PxwD+yRp5G2rSt5u7q9s88N3KAKdLYhkS2HmK/UxvyNE9ccTzzloIQ//zJw9uBPXQI2ks3aLgepoB/WHupLC7ZRGH2c2k5djbhemZXlw/Zc+1BUvugmDri+ThQ0ZF/XvM6PcvshlJSqlqPuWNYznD299EP6qOSz/fcFqePHmn6NhB7FcEODuH9ulwUe+kc1ls82H2LPtkBsf+h+jILRW8DWpCU/qxs9hrDx+NeBH+7KIKsrmp0EYt+Z5qld2lZgR3TUpMyYdpBzb4za27e4XMQmSG7oQp2NNsGhrbPq6Vy8oQtPiY17V7L9C/d3F6yAITPN+kepDeNdnY9xSf0ZD1xH7UszswGEv3PgbVhLmL9YRZnQlsjUx186xZnRo+9qh6RwOqQ6/Spub0TOXRLf4oGOqMEtWDlCrNIKKo0TKYf15NYHHvwvwV4D8lkwIPcYIi++4HUnrtec/9/VqeqjjnsMjIC3eIDs2lyeZgRO/43mVyIpsaVvMsAiL5+vkWgsDbRmN5AkplZnJUHzeYHB2qCXVMeU4V1HNdIWvJUFvx9sQmBlo37x6bEUsON3zlRlRNqZQf912Wj5lEjENpDfNOj2jdKO10tKnm6eF1Hv/YFoAFgRMbn45LVqQ+dixcja3FBo2HdFvxQ3dDC0IBgKUGGyk0tOdAIsXi9F1H
 64G2x+tQ
 iXy9g+MjAPLXIHjppcyrsY019MzuYICKHf1goUknUFJLiqsab4KGKjwuVwUHLC8KY/5FOoqd/garLQBPERrAzz4EGbHieuLU72cUwhirZR8bvw1Iit2J/5vwqRG6fMDHW+E2bT/4Xa1xAPxA3AFZMOw+ZAzFVhUHdltPI4ngNEYdvWgt4KlpuD9InuJPv5SNHFIpARp9M/l3MrJvil3mELVM//iMC6PK9qqjDg7skPwSslix9HZghFFrnSXMbHOO8Y3zWEmDqaXJvFiwEAmASAcz9pwSyBupMbUAcWprv7l3um5Lb40u02JZ7rkeaIdEKz/+syhFHDBNSmhWL9r9TOh4qUG+PV+FtDmdD5F1AYWPlDwSt8cVzv7EckN2dkAxnwgxrXE3bbw3EnYz+OmyI680oEo+axgKmEmceKnETHs/ntFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 09:43:37AM -0700, Breno Leitao wrote:
> On Fri, Aug 21, 2026 at 03:53:32PM +0100, Kiryl Shutsemau wrote:
> > On Fri, Aug 21, 2026 at 07:03:06AM -0700, Breno Leitao wrote:
> > > On Fri, Aug 21, 2026 at 01:13:55PM +0100, Kiryl Shutsemau wrote:
> > > > On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> > > > > +	/* Reserve the table itself so it survives a further kexec. */
> > > > > +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> > > > > +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> > > > > +			 PAGE_ALIGN_DOWN(ppm));
> > > > 
> > > > Hm. I don't think it is enough.
> > > > 
> > > > On x86, kernel doesn't keep memblock around after boot (see
> > > > CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
> > > > from page allocator. But kexec can place the image there.
> > > 
> > > You mean the third kexec?
> > > 
> > > 1) Kernel A hits an ECC error and marks page X poisoned.
> > > 2) Kernel A kexecs into kernel B, which won't use that page since
> > >    it's in EFI_POISONED_PAGE and memblock-reserved.
> > > 3) Kernel B kexecs into kernel C, which doesn't respect
> > >    EFI_POISONED_PAGE.
> > > 
> > > Is this the scenario you mean?
> > 
> > No. I think nothing prevents kernel B from putting kernel C image into
> > the reserved space in !CONFIG_ARCH_KEEP_MEMBLOCK case.
> > 
> > Kernel B excludes poisoned memory from buddy allocator, but kexec
> > doesn't care about this when look for placement for the next image.
> 
> Right, that is exactly the case I meant above — sorry for not being
> clearer.
> 
> Agreed, this is a gap.
> 
> Can we keep it separate for now and address it as a follow-up?

I wounder if the fix would be to make page allocator consume the table
and not do memblock_reserve() here? So we would allocate struct pages
for the memory and poison them on init. And your fix by the link below
would do the rest.

> Similar
> to the one covered the initial issue [1] first.
> 
> Link: https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/ [1]

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

