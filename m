Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 222DDC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23916B0092; Wed, 23 Sep 2026 04:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC056B009B; Wed, 23 Sep 2026 04:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11BC6B009D; Wed, 23 Sep 2026 04:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C66CA6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A72FA6A60
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:32:43 +0000 (UTC)
X-FDA: 85244361006.13.5CE6ECC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B706C140007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:32:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RS3N/efX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790152361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moOLRtl3B7HRHlFtZpcGMhBGtQIVrDlmkD6QtGKrT/g=;
	b=5RJWP8LaCzIrFP71oEr5hzguGp6Y0LNiKXMWsmzr/lrDcz5oy1rmzNWWVHDiZqrJbAQaJE
	MkdpFIVmvM3riGP/pKCYSI+AjqNrR2OK9SXuJoxShP2Qwx7FX+OHHGd12+A0KUuJKFOg/M
	RrxHx7vRBoqnwZnxguOMHV+6FwnWGP8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RS3N/efX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790152361;
	b=uroTYI7cB8IoucLmjJiTMziBg7xu9Wrh/cO6ShwonZDVZq4gN9pMQuI2Ve9etlcliM/i6p
	cngUCte+aOgqb0HQjqiR2hJmkhoBux7sxXz+GnbPOKHF40LNflEb19Lfn+0OlzhYjs7LPf
	U5J7XBHJjzR4WU1g+qRPjPHBQb7WdaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 316DF60200;
	Wed, 23 Sep 2026 08:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B501F000FF;
	Wed, 23 Sep 2026 08:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790152360;
	bh=moOLRtl3B7HRHlFtZpcGMhBGtQIVrDlmkD6QtGKrT/g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RS3N/efXIphFUEtBFsza67Ka1RwMr4BLxzOiJOdBGwr+rjJ5oDOXrPT0on7sTmLx3
	 JyhOwCb33yYBvYRbUQ5PLQCKXU3jd53OjIGNCFMNuouzBC9DaX4bbWLJ3lJ/uZDxg8
	 MMM3rhmaiFkgIz4Dxh006YZUNjXJiRcDZit047rpIbXt4IZGBuzWpa+aPmOkKwnsXe
	 ooKtmh12qMBFhPlEqo+a1tG2pddPoc+TTdTiu04cbk4s+AFqE9jzH4eWs8KcaCuAUV
	 gVqxn0Z3erPq5J+5aeyUtucbtJ3ofv4HU7U1z+vpHmAuvb/WcDVz2kvYICHYEHRAjs
	 CTjSmBCM1IcjA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 12/13] dma-buf: system_heap: Allocate shared
 buffers using CoCo shared memory allocator
In-Reply-To: <arKvKME-_wNeW7ea@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-13-aneesh.kumar@kernel.org>
 <arKvKME-_wNeW7ea@arm.com>
Date: Wed, 23 Sep 2026 14:02:31 +0530
Message-ID: <yq5acxu42wrk.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: tre6w9epeez85fq9r1enc4urfowcyqhq
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B706C140007
X-HE-Tag: 1790152361-894387
X-HE-Meta: U2FsdGVkX192Pi1/B7qoLgaz/ysJPlRiMm4B8DbQYG/LL4Fuqgvh2TiIXUH9eGkPNyOunwRlUnQY7ETAa/VgF0aLhHnGuT2hvzbDJI78C+YhRLjd82Crw0/5R6/Ryrl5eF74lNPWrXU4RTck+NzhCHosaYH++vR+rNoN+WniLOn3FZ+LqOMh4tne5ifOmPVPbzKEqDtsGiBaok0HInHzIK9b+bQuPio5sKyxYlcLu6ndXbMPIgEfAn+I/tZXeXIqMs90fpWFuerYvLExJ5WCQDZgzWhvex79+RF+PNN/7sASrwhqsULChSMvKwnk7aqfSFhMLwWAo7e/3hdtjXcMAnC9o8wi9bZSCL9bEXFHKS2lSsInWX9JtWYVVkKc2/3cZBUTINs6whMk7+6P4whsJVEfgr6snCrivM3aXE7mp8wMSGckH1uufa/GNyQ/I0CDIHIHlky7jkik+nynPjyCqhIx3ZTzOoFOy52G6HtrDKVQlzemt9PJcg6hGl5iUNtTPUCOD8ne7gOmf5yf99hKqWu8Qe96AcamE5yRorwJEDAJTrApIiidGnj/CqHzQ1X48tVbybv7HLWCAY+KKf/lKDgMWP8OyOErqX7Vv7/GqUCSzbe+7dlZ1S+dKxuOqGqXORpBqWWt3TOiLIswy6Zt1ObUzCwoOabrfF90D0FVZ+3iVSe0yZGnVq7RuIlBfdYepSai63RoCbhYkQBUvs42XefJBsU5tCeATPPpKREcK93t6SZDqlY0H/HeRj2Mv9xSH0tywavUbyBa8L1bCCY95Gk3COJiIgM8m/5rLxASBCMgaCX8XL+rJnvB+DKNWedE8fKoX+jBiVuPyeNRpe4rm3k5/YZdLk1BroVUrMI9Slt0qmjWwq/Zwqp3ZFrsDrl+ZCeWkmtJ3SdkBTxU0ZYHIIyZjN+1r+6mfb7cmOhs6nwX5esIs0uxVQJOGnZgCNQWLnqAGi/Nw6ryc6G7RGK
 uhLXzc/m
 j9X5D6TpnoOoMCxQbmRua3Lw9Tmj27NMo7WGz/pAnOV91kiKP5XDy6Ne/jFYzUEWKhkIeiQAatqCofm0uMoF/ZiPHPTXXhv+9mNAhGugxg75QXuQjfekKiY1IBiOA2l87envjYGRjjP+8Sjx2+UggYkwc35+wP1lZDDjmf3PUlNBjS/6NKBnNImQRwFxyenDy7t6oNEX9JIxiZYvC47wTcVHDL8PKENw3mv8ZymNMqDvY5X43t0HKjgYOBe1b8ZJaQa4yGdLbmcNfb//14ikoBA2rTwsGFCFc7kpUwmnHFLD3UooVHP8zpIk1jL4gXxfDAfarVVj3aNOilMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Sep 21, 2026 at 08:18:46PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> @@ -405,6 +396,7 @@ static struct dma_buf *system_heap_allocate(struct d=
ma_heap *heap,
>>  {
>>  	struct system_heap_buffer *buffer;
>>  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>> +	struct cc_shared_layout layout;
>>  	unsigned long size_remaining =3D len;
>>  	unsigned long sg_remaining =3D len;
>>  	unsigned int max_order =3D orders[0];
>> @@ -417,6 +409,14 @@ static struct dma_buf *system_heap_allocate(struct =
dma_heap *heap,
>>  	struct page *page, *tmp_page;
>>  	int i, ret =3D -ENOMEM;
>>=20=20
>> +	if (cc_shared) {
>> +		ret =3D cc_shared_calc_layout(len, &layout);
>
> You should not override 'ret' here, it was set to -ENOMEM for a reason.
> cc_shared_calc_layout() succeeds resetting 'ret' and some further down
> allocation failure, goto free will return ERR_PTR(0).


Agreed. I=E2=80=99ll fix this in the next revision.

-aneesh

