Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80106CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 05:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6328D6B008C; Tue, 13 Oct 2026 01:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A706B0092; Tue, 13 Oct 2026 01:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521216B0095; Tue, 13 Oct 2026 01:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32AB46B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 01:13:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DFCCC0AB7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:13:18 +0000 (UTC)
X-FDA: 85316434476.20.CA6C3EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 935D320005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:13:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzCrDEQb;
	spf=pass (imf03.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791868396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJNXTxAKDlJNxNUfVhfSQZRthKiPsKwpUGRTdAWw5nk=;
	b=3PjQ4TY7ABBoWcWrEKPo1wQpb2cEjwTM7Ra0+5WGV+g8WME8xSmvAr57VbiK3sSJxhEkS6
	sTNdG+lriVo89bKO0ofVNwQ4wOx8g2ot+XY72QPd2i8onCduPOOlzpOhtDhX6Zw0ePzCn1
	xgqnxJeacVIIs0Q4wimsEh/rS0xUvFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791868396;
	b=nIHDkUzueS/Ryrg6TxKHRpRHQFZjTxTdZaxBEB9b9IvYy0NOIVhvu5Y4a0ovAJfxsHQ5B1
	7UtRkzwILsY6WH3IiIgiV067yi+PBBT7O3oqJqlrKHE7mfhQPvXGvm5AYE5AA6gyioZg5f
	XGm5Ud7acSfUysAUeorQtYQ/EVVRHAk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzCrDEQb;
	spf=pass (imf03.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAE90600D1;
	Tue, 13 Oct 2026 05:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E989C1F000FF;
	Tue, 13 Oct 2026 05:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791868395;
	bh=GJNXTxAKDlJNxNUfVhfSQZRthKiPsKwpUGRTdAWw5nk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VzCrDEQbQkLh3MKfOcrVWwIP8JEXomYf5WXOVtkxPNomqYwc62kenfaWt4EtjgLr1
	 56jB5oIiN8pzQZeIE3LFciZow2fKaUlTkUhbRzOM+dcbTemWxjNlaDACdigHCayE87
	 aOYeG7A0j8blwTWF/PhrjdF/yqcwVCBZgEXlTLggA50DrIt7DidbhXOeZDYqd2wlwf
	 5VM61psLu8x0NOTS6zsnpsRtNRWIIa6D/I6cZXFg4QLjCBQLZUYg8H0fnCR6pdxExb
	 Rlsmno4/IPgxywaV4sYkjL4r0KtaTtxGQIturB/lLm5ZpL/LuERHtKpU8HslKH1Kgj
	 Tp4Z6gqmgQAbg==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v8 02/14] mm: Zero memory during shared memory
 transitions
In-Reply-To: <arZkEugXwCtKHH64@thinkstation>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-3-aneesh.kumar@kernel.org>
 <arZkEugXwCtKHH64@thinkstation>
Date: Tue, 13 Oct 2026 10:42:58 +0530
Message-ID: <yq5azewiqj39.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 935D320005
X-Rspam-User: 
X-Stat-Signature: jgzyhiod5gzzdd9ax8iy719mu6tgduu4
X-HE-Tag: 1791868396-945288
X-HE-Meta: U2FsdGVkX1+2BMfcGT2qrL3nBfZmWRQgS4ll6Vl9S78vkC36f0QUqr+IcZmsjeuo6NXtH6pFWBCTdEunlFKkkuYcU32ZzZ4qzanAfZln8VEyljcQj3ZSwjuIfCklEdYgB3Sa7GX+AhujUkHRwMstJFBXGjHvHEc/tM44tbxNQg63wu9HABh4LyTC4U2Tb0QV+TPDtpxUkeCCgCkRrcGvGk38JXzqJr+/XdwrO1blXC3wQi6Urvo+qciO0wu4lMeDtG8EU6NjqNT/cEZC8GoqwWj3W7xBzVPohp+OO34UUvQZvtB09C5eyWBeifWOgbMa6JUMAQcjFqrz+oAOC00oeXPthjHAQsvLdxUaro1QeB74NuWVVyPfZoKsErLUs6cP1ZmFml2rEY4CIZJfOHi833dRYTcV1BG8abG9cmtQ4jGClmC9KcdHMG+4v7qTDc59jaOqx4n70JpkVfvWlr9EzTBOYamhCUlgYAqJ+t8AruzrjTTZMFO02Nx1QnqxfUXltg1uNHhwPcs2fPqAUv+G9N+2V7AH413zaOUmUhraMUyOEfTQBJ9ZBJ5Ckva/ej8kk9xVbLoPQa+EZt9kQIz3Kyg3yVkVJFVL02fu7pUHqdJX+/4pJcIBYC9gDXAT/6Osel6IkGi3qlkIuAx/5egFrRv4imIMJycHUAGeHAI5WBtbN2kNtQv6Dq8UTPwyQoh7Pui6hsTBHQgcwHfGmx5P2ssr8joyHhM3SBerS4E8KPszG8JKzg1lmrSHnoiHgNWEL4VpWJhnzdEzxPBesNJYhw3azOhXALop9ksvR+tsD46x9HUOz3GRu5eEJHLfCKMSLvPqyvP0o6VUYi5cIjrz/lYbI4uzPtXe+aI8iOqXbTTt7HFvLLN2QsU5uud5MPIObejq8pIzrdr9Fzezy6MEwazZ2Uua2eLmD0eQoTOLnSPIemAV2+mSCNeP5jiNukBeYivbLOvaUV4CuXUaqvv
 yFVS2m9q
 Afk7XODkFZyB6ehXn0QwjlQEwKOJS8lF9C53OG07ELDbUrBJ2wdPDTRgoDbZsBuluS8CeUjpeM5uaxkRhqLaSTEF87c7Rc0jGBTgumOIGcbix5ebzcEEm49Ac8Oh3qsf0pvFrZxBnbflHhmA3WenaNjclF1MknvA+MtA1dEwOhyyrwifUkb9VXP3H+Ww3eZgFpas2n8FCZUkomD0KYxnGFcrRiDeStUa9I69Tek+eO6GgafgEVLR1XkDoIgDv/Wk5spcQmq96MuRLbrXfbktWPbmcYUbuKKblgEgs/FZYc84l6Jf0avD4XxIt4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kiryl Shutsemau <kas@kernel.org> writes:

> On Thu, Sep 24, 2026 at 03:35:17PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
>> index f904a636d449..1f1f39082391 100644
>> --- a/arch/x86/coco/tdx/tdx.c
>> +++ b/arch/x86/coco/tdx/tdx.c
>> @@ -978,6 +978,9 @@ static bool tdx_enc_status_changed(unsigned long vaddr, int numpages, bool enc)
>>  static int tdx_enc_status_change_prepare(unsigned long vaddr, int numpages,
>>  					 bool enc)
>>  {
>> +	if (!enc)
>> +		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
>> +
>>  	/*
>>  	 * Only handle shared->private conversion here.
>>  	 * See the comment in tdx_early_init().
>
> This doesn't make sense to me.
>
> On TDX the memset zeroes a page that is about to be dropped.
> MapGPA(shared) makes the VMM back the GPA with different memory, and
> what the guest reads afterwards through the shared mapping is whatever
> the host has there.
>

Does TDX require the guest contents to be preserved when pages are
converted to shared?

The memset() is done here because CoCo shared-memory allocations now
ignore __GFP_ZERO and instead always zero the memory explicitly. For
CoCo architectures such as CCA, this must be done after the memory is
converted to shared because shared memory uses a different encryption
context.

The full patch avoids zeroing the memory twice. If __GFP_ZERO is used
for a CoCo shared-page allocation, the page is first zeroed during
allocation, then converted to shared, and must be zeroed again. I only
changed Arm CCA  in this series because I was unsure whether the other
architectures required similar changes. Therefore, every CoCo
architecture other than CCA currently performs the memset() before
conversion, while CCA performs it afterward.

If the host expects to see the guest contents from before the conversion
to shared, we will have to pass the allocation flags down to these
helpers and perform the memset() only when __GFP_ZERO was requested,
along the lines of:

https://lore.kernel.org/all/yq5aa4p82sqt.fsf@kernel.org

To keep the changes minimal, the current approach always performs the
memset() rather than passing down a flag.

-aneesh

