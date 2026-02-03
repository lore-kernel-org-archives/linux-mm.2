Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C20C7E8305D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D136B0089; Tue,  3 Feb 2026 02:15:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3551A6B008A; Tue,  3 Feb 2026 02:15:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2824D6B008C; Tue,  3 Feb 2026 02:15:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11E886B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:15:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 772FF13AB70
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:15:50 +0000 (UTC)
X-FDA: 84402285660.13.8898ED4
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B463100009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:15:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ZHGnFYrs;
	spf=pass (imf05.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770102948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhDRh09aq7ene7b0Wx3I828jJ7FXb0oFahb4ybdLzdE=;
	b=Qi9XDM8aLv/skdTRj+LoBqoF4C+O4BfFLwRka3gkLo08fDaX8yfETfeY4DNrYomFiVP96K
	EjJ6gg0qrfUysg3iFsUD6f3omryjDrngKiGAVfpatEeAYXrC29moP3CTWsh1z96lfXlBeJ
	TXIASQCwV2DWigpAIdDqdDkYhgLSDZw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ZHGnFYrs;
	spf=pass (imf05.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770102948; a=rsa-sha256;
	cv=none;
	b=omT+d61100th/dixsRQAYRIrL+4EWk3aCS/DR3N1GeCx8TMlfsVCXWdGuDpNxZaZV8Tn7w
	yl81b1ar2Z8HS2BnvNLghj3x6taZWnZ+XATFmQQH92htJgrIsX6wNa43fWy+90nKMkzDQI
	KghmHdloMwSBOixgWzzBJ4jusSPElJU=
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260203071543epoutp01c124f5b425ad3208e163548516e0b25b~Qqz_cKhXG3255432554epoutp01F
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:15:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260203071543epoutp01c124f5b425ad3208e163548516e0b25b~Qqz_cKhXG3255432554epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770102943;
	bh=mhDRh09aq7ene7b0Wx3I828jJ7FXb0oFahb4ybdLzdE=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ZHGnFYrsEGHR5WEdM3oYqTBo+J7B82HitMUTi8WIwBcuUu/2n+wKFyM/+J/Vgez4B
	 66099rLstqCeg5/X2je/TT2w1g9Gk6Ia8sspLmCVeunpHeDP9W4rXzJLW8hz9peKgJ
	 2en0g7XO9jasqwnIEJ9osw+zD4IdJ0n47j1M+HK0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260203071542epcas5p16fdef2bcb44947af20950be109a442ad~Qqz91U7801323313233epcas5p10;
	Tue,  3 Feb 2026 07:15:42 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4f4vs858Wdz3hhTF; Tue,  3 Feb
	2026 07:15:40 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260203071540epcas5p39a0e65b6e769f43b7ab430d99a160e6c~Qqz7mf75Z0178601786epcas5p3a;
	Tue,  3 Feb 2026 07:15:40 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260203071535epsmtip1f2a061d1861720ddc1b1d166faad35eb~Qqz2_Weqx1731617316epsmtip1x;
	Tue,  3 Feb 2026 07:15:34 +0000 (GMT)
Message-ID: <4a795b10-95ed-4bba-90c8-9fee57454948@samsung.com>
Date: Tue, 3 Feb 2026 12:45:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] xfs: add helpers to pack AG prediction info for
 per-folio tracking
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
Content-Language: en-US
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260129004548.GB7712@frogsfrogsfrogs>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260203071540epcas5p39a0e65b6e769f43b7ab430d99a160e6c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7@epcas5p3.samsung.com>
	<20260116100818.7576-3-kundan.kumar@samsung.com>
	<20260129004548.GB7712@frogsfrogsfrogs>
X-Stat-Signature: hsp6k95bw6n1kwsc6ijt7o9i47ec7ndw
X-Rspamd-Queue-Id: 2B463100009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770102946-133632
X-HE-Meta: U2FsdGVkX19ozdvUrHfX63XcEKPXIczpBCoDcD1wO4MOHDDyNPRrHPnh6pwJh9LOKcwFBrrZm0gmUDztmvHSbd65DS6ZrETsj9t2B4HzRRBDw+4er9k2KVflpfqQdT8uzeJd/3PpVdCjk+RyZtjjbj49fFGuTwjb5VTmfPTWpDTIDfTYXVEnlyhrDpy/vmYKqD3OdFECXbia4R0NK9EdTEYuwdh1G8gxRo944Q30tRAzx5+uVN93wGNe3VBoRJ/w5IOk9WddclsNtt9QvOSiFEBqm4jn8C+3Jkc9PbIj7NNBAnq8SNkA6JDIzMgR1fXtt4XvosrFtlC79tYCbG1B7kL/RXQKxluRATNG1enhItuVQ7k/7lDekeED35fYeZ5ZRmdq5QXLrYmzjRNSEhFJuUVPBUbvKJ6i7d8fTcwVbVKO0PHwVtqa5BD7zS0R8xST9YTodeX6CcIsi1PSMCbx1+AwKNQLZsjeA4K2p1hxQX3h9Q4qYjIvjGBWyTwXEMlDKW7xwQI3hsKkO+OlXv3jSz6llUXE/0LtaRWKkMAJYdmsebsivryDbhnR0JSSrKAih1ZARHIoE8lKi9z9bLr0LcP4IEESt+c10OqGGSSezwQnXFyx7yjlycFQ9ziQ3lKyZvgCvoD76JhXLQehQSQaS/QHrKPcTEPd0z0QwJmiVoDBi+b/1j0DtVar0pY7UG2OQ1KIa/jYI68mK5stAqgu9gDJ+JhPqPfF5I3cJ+JJjtU8bXoWB3afJI1HiuBNYr+MIYjMy9w11hzIHt1jOrKu1pTBQNqQXYHW3/M07KMjwDXb3dJWF435mL/gWn6mjItnUGgN+Sqo+fzhLt0Dp+2Cb9wJYQuejPhiOwbbx5XdOPfR5gftwN7ciSeMJSkmrlCDoPYWNyIQbWHrOrOIfEFd0UwfAm5QeazFhZW6sFj/80jBJjt/tbeTzSRZUoOnjO7JwkjGem7fMi9uXD24Bln
 fxrxZA3x
 wprAtq9aXuu6FFUW06b/f8nbZ8atsNHWVkwOLax9xVbblcAAA1z2NNS6fXU69c7Y9qu+LQIDaaEKkPFENIfYYVLUyykgGy0ATvyFP114MvSIE96u0pDYa0ab0ocs19U3IFJ+MuYZXTYXTsP030RuWmn+V/K+WXaRgtMn7TmYN4A9zsd0jzr7dd2lDtVIEeBHOC5CM1S+wQCtKNXk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/2026 6:15 AM, Darrick J. Wong wrote:
> On Fri, Jan 16, 2026 at 03:38:14PM +0530, Kundan Kumar wrote:
>> Introduce helper routines to pack and unpack AG prediction metadata
>> for folios. This provides a compact and self-contained representation
>> for AG tracking.
>>
>> The packed layout uses:
>>   - bit 31	: valid
>>   - bit 24-30	: iomap type
>>   - bit 0-23	: AG number
> 
> There are only 5 iomap types, why do you need 7 bits for that?
> 
> Also, can you store more bits on a 64-bit system to avoid truncating the
> AG number?
> 
> --D

I’ll reduce the type field to 3 bits (8 values).

For the AG number, I can drop the artificial 24-bit cap by packing into 
an unsigned long and storing it via xa_mk_value(), which provides ~60 
bits on 64-bit systems and ~28 bits on 32-bit systems.

> 
>> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   fs/xfs/xfs_iomap.h | 31 +++++++++++++++++++++++++++++++
>>   1 file changed, 31 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
>> index ebcce7d49446..eaf4513f6759 100644
>> --- a/fs/xfs/xfs_iomap.h
>> +++ b/fs/xfs/xfs_iomap.h
>> @@ -12,6 +12,37 @@ struct xfs_inode;
>>   struct xfs_bmbt_irec;
>>   struct xfs_zone_alloc_ctx;
>>   
>> +/* pack prediction in a u32 stored in xarray */
>> +#define XFS_AGP_VALID_SHIFT 31
>> +#define XFS_AGP_TYPE_SHIFT 24
>> +#define XFS_AGP_TYPE_MASK 0x7fu
>> +#define XFS_AGP_AGNO_MASK 0x00ffffffu
>> +
>> +static inline u32 xfs_agp_pack(u32 agno, u8 iomap_type, bool valid)
>> +{
>> +	u32 v = agno & XFS_AGP_AGNO_MASK;
>> +
>> +	v |= ((u32)iomap_type & XFS_AGP_TYPE_MASK) << XFS_AGP_TYPE_SHIFT;
>> +	if (valid)
>> +		v |= (1u << XFS_AGP_VALID_SHIFT);
>> +	return v;
>> +}
>> +
>> +static inline bool xfs_agp_valid(u32 v)
>> +{
>> +	return v >> XFS_AGP_VALID_SHIFT;
>> +}
>> +
>> +static inline u32 xfs_agp_agno(u32 v)
>> +{
>> +	return v & XFS_AGP_AGNO_MASK;
>> +}
>> +
>> +static inline u8 xfs_agp_type(u32 v)
>> +{
>> +	return (u8)((v >> XFS_AGP_TYPE_SHIFT) & XFS_AGP_TYPE_MASK);
>> +}
>> +
>>   int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
>>   		xfs_fileoff_t count_fsb, unsigned int flags,
>>   		struct xfs_bmbt_irec *imap, u64 *sequence);
>> -- 
>> 2.25.1
>>
>>
> 


