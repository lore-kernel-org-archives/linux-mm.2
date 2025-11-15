Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C19EBCE8D6B
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16858E0024; Fri, 14 Nov 2025 21:51:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7388E0005; Fri, 14 Nov 2025 21:51:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB68B8E0024; Fri, 14 Nov 2025 21:51:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8E298E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:51:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66B2616056B
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:51:15 +0000 (UTC)
X-FDA: 84111314910.08.F48FD8E
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 893B2C0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:51:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h95mMGL2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763175073; a=rsa-sha256;
	cv=none;
	b=Nv72eavdvTOmvXS7NnuZDbVFvCUNOZDh9stO7hiC4iGa6Si3I2HCFFZd/t/yfzP22jBVIj
	xxrOZYO7spNBBaMKYgSRjTdk8wx/ykc5XBowtYVS/2QdIl8eC3IeL8t0NkV4DVy1eDv1SM
	9wRIxGSfhisVacPWKaOWzjg3xhRzlHo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h95mMGL2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763175073;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Au18H467azZy+IfrgSEjSDC4r/H00yPg/dxvvmoSDI8=;
	b=qXdYhbOuhMAKfzK5Kl9gGmER0eLsiXcRVz+P3P4zkiNlJ1cO36VR2dXEAMf5Ls3Y/eUvbD
	2ggFLK4feY/3OSixVg85tMboWkOOWCGXzFFCXjfqu1gaT6Gvg2lAzGBuizYPavP1sRJk0z
	dB3G1L2myeLqxwff/fD+NBMSJhRFZEs=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so4034383a12.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763175072; x=1763779872; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Au18H467azZy+IfrgSEjSDC4r/H00yPg/dxvvmoSDI8=;
        b=h95mMGL2tR/H/UaX9l2CKNNxvlWJwqhiiylDhS/k/Dw2DsjDhmbsaB/S2pvf248Z9y
         BlzOVLhznmBxegmGHmUbAwewQMvqXcLdTQF+f7ZU5NQVWvw5ztlpFOxP/cunjuX+mb55
         QgPKaEXVLkRIBEPYEHQPa8I5MIaeAmxMvMGs/Q8m7jdICAbUUay7PX0OooAjbuu5+vl3
         6X3m3eow30RzMdpU3vbbgUjBolj7qlilZ6Qkfe0dz48HPU+u2WddMaj8Yw2C53wpMiXA
         lFzKRJUwXGapTkttvcDAAqfBNAgn503nfCbLCFe/GfLTYKvXUb52dmCdGwyfFcNA4qQP
         vUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763175072; x=1763779872;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Au18H467azZy+IfrgSEjSDC4r/H00yPg/dxvvmoSDI8=;
        b=rYH6nu/lqftWU3i+8lEXGFXySvXXsZuuQogeeEdlvbKtBHDZP04bBs7yucVo3TcZQu
         DpkigVnUGTXxLhs9/hAfqOrktTwtP+86410xdDMPNvkZalZ+y1hJwoXzDa5ylBzAKpF2
         QA/SPgeD1JlIuFBkcu3cCOu4fT2qEgPKvi5OYvhOEFZhDAAgZUGBVrt8aboK5vN86eRg
         9uOfzlrELJoJ96xQQl+5D60BxUL0ZcTvRMmf0rpsEfWHnFLFASi1L3TDpnSM5vXrlbvU
         lXgKcXDzhC6zRnnpTZtMmWyGc+RfgFRnqVQUw8o7SMV4/1pXXJfpyKeRlLkq0soB2uwe
         H4Nw==
X-Forwarded-Encrypted: i=1; AJvYcCUJhWFiN1cYJ/PY73qH0UB5xjuA9bFaDC0LO8kfo6yguwDUX6P/GpUTx2kk50nPJhcX4vgFzbic8Q==@kvack.org
X-Gm-Message-State: AOJu0YyVMCUVy089ejKB3u1jsCjg099GDSsL3C9BacX0PEM3uW4ikPxW
	8Ov/hkoNm4MoDL3t8bdLThNRAz9GYEeEu1O7is03eQ7xed32Z1djvGHD
X-Gm-Gg: ASbGncsZS9BruIR0RDPfoSLPm35yYBlUNUpy3nHGMJsr0C9KYEnK4+gWMkz8PJ+AvZe
	0cPEb+48yZ0mf6Q24byLvCgwZUvxEOdEQBsO1iOgl9MHlxGd2RQSUULvcx/EStqPMorjx1Tbsmp
	Rbu0ZSdN4hmuYRp1bXrBtCmFOdrrrWHs+WdCuJnc1ikI3aQv31umTR8mvZuU/LBcZ9cojwTHAx+
	quS0NnKEa4LvfSyMpz2CoknvEwZil2HyKsfTBCR1E4dvWi8cZoWVHjZrcdeMNc4lHvgRE1YIb1U
	flc+vkEuvHRAOFMuRX/7VCgdDPPrXed176HJ9KV8fCoN+RK/f/7axUxKZFO6iPtwewJivNd6rH3
	U91PfSko45Psj5pGMq3QdLHS5goXb/YoDkxtpF2ZhwvJo8W8lwepFs8qwPQEoxD1tQ/TSjemUQq
	3Njwq5d1zUgVy+93Q8daTISsr5
X-Google-Smtp-Source: AGHT+IFijYhBosLb31iiGAABudJFyw60Nhzb666Nl93sjFEpO/WA4uHbEpnOI80frPELz2vzKBG3QA==
X-Received: by 2002:a17:906:478c:b0:b72:dee9:88df with SMTP id a640c23a62f3a-b736793de88mr514948166b.46.1763175071623;
        Fri, 14 Nov 2025 18:51:11 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fdac50csm506960666b.61.2025.11.14.18.51.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Nov 2025 18:51:11 -0800 (PST)
Date: Sat, 15 Nov 2025 02:51:09 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, willy@infradead.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <20251115025109.yerb7gbty4h7h63s@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
 <20251114150310.eua55tcgxl4mgdnp@master>
 <64b43302-e8cc-4259-9fa1-e27721c0d193@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64b43302-e8cc-4259-9fa1-e27721c0d193@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 893B2C0005
X-Stat-Signature: wdok9cai64a1omsdqfzicc6iotjsjxmb
X-Rspam-User: 
X-HE-Tag: 1763175073-493623
X-HE-Meta: U2FsdGVkX19w7CT/JWEtQ/HkTFB1iQthGqTh3ZfjiMn5UHIHS7cKjeypOBkg7vLFktMh0D2WyJG9DXSnjLTYPzeq+XHXgtAlHd3MAXTDBg08wcFniqnS0gdtuWiKVrNmhNKjM7XgGZtzad7/CHnNvWsMl4dtpNKgJjo1UclPFHDOdZPAvFTTsU/iDoURR6GdcoE3n1xHlIIt5uB73HW05jLUEPmiXSqhY4SFxYCc9BRW3nZhZrQxWCcsy948bVwbdrBhNZpyAaOM3/yljlfF6RT/QstsQgHpbu9WdFDAJpa8gI2gtNTiDnbmFnv356VTz6a7bSoH6AEY57Dje54cC2tIKKIz+BL0ljyNXw/howxIdpZMcmiCv/hKweW1Bo/NUp7zmy1t8cHJbVYabin8lwWOVH5w/YD+OP2NvdMke3Cstv9W79f0eRGTtUmhtu+CP6qSC2noDMlLXYjZT4DnDOlnjgB5/KFuKNhItjkq2XtqKuHUW0/grvZMS9cZnLhgBaq8AjhR+CP8Ez4bwYlaIJf72xVvq5IeA2gONhe6YRwXw8qBpowcRWFNBhDd8H+GMvx3aY73FrM9mLbanRcydG83WGZjUekk2s6kPJ7jbiIrkR0JTLu/TjmHwGs+9Gd/3/plrPyXIgc/KIwey7Bbvt/2hDvAlPXBE/u/WWVQZ26GTb1VpkeCkX6l2fKxJ4+WLCR9BGMDTEAnwGjArEhk4+FlranWwZHFbBsr3Ro7ufBSnGHzIcnpooIRjbKLCxr0oQZXq2CiZDwqzPnueqYOpJs3o/NYHJunUjNBbMUf9z4OJuwuJ+0AiygjjxoU2m5hlta1wKuiUOeKzAaLxwKG3ZnEFtAlFeCIy+TG+40cb+T2s1mxsdmpWIwn8K96qV1I2I4rL+ns9ai2y7Vi95SnfBWuQT3MXumzt35maJcBIxZN3oKchBmyeS/aBDgHi1q+HaXblcGy3NsrM0IB9Gx
 zyPfc/zc
 B4FGXwtrbyOCBp2UQQOl0XjhQ2S3rm81hlMSjoVXa7Q/tk0UkKeYlL8yQCz3VXoqz5VqCcCqGClrM29tqxTCSGu/tp4sJ6yoBhAp4ddTkJvO+TC1XS57OWhXpvkN3rimem7vQu6CamGRd5QeBRWBtquGfhO0TgFcTyLiqOi4G08Dc7TwUe+IPlUxoJVQvbZmq0Rq6NSPIczro+l2wKXHE6Mhh8MAGTg7SWYqYSP4v2cjw2dERm1OOFe0wi5foLcodaCjEcnGVVtEVh3Izv4pkJGHRqP/QRwxN18xboNV9qlaCn3eqm2gONQSM4wG23jO/Cl5m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 08:36:20PM +0100, David Hildenbrand (Red Hat) wrote:
>On 14.11.25 16:03, Wei Yang wrote:
>> On Fri, Nov 14, 2025 at 09:49:34AM +0100, David Hildenbrand (Red Hat) wrote:
>> > On 14.11.25 08:57, Wei Yang wrote:
>> > > The primary goal of the folio_split_supported() function is to validate
>> > > whether a folio is suitable for splitting and to bail out early if it is
>> > > not.
>> > > 
>> > > Currently, some order-related checks are scattered throughout the
>> > > calling code rather than being centralized in folio_split_supported().
>> > > 
>> > > This commit moves all remaining order-related validation logic into
>> > > folio_split_supported(). This consolidation ensures that the function
>> > > serves its intended purpose as a single point of failure and improves
>> > > the clarity and maintainability of the surrounding code.
>> > 
>> > Combining the EINVAL handling sounds reasonable.
>> > 
>> 
>> You mean:
>> 
>> This commit combines the EINVAL handling logic into folio_split_supported().
>> This consolidation ... ?
>
>It was not a suggestion to change, it was rather only a comment from my side
>:)
>
>[...]
>
>> > 
>> > The mapping_max_folio_order() check is new now. What is the default value of that? Is it always initialized properly?
>> > 
>> 
>> Not sure "is new now" means what?
>> 
>> Original check use mapping_large_folio_support() which calls
>> mapping_max_folio_order(). It looks not new to me.
>
>Right, but we did not actually care about the exact value.
>
>IOW, we didn't check for order <= mapping_max_folio_order() before.
>
>SO I'm just curious if that is universally fine.
>

Thanks, I got your point.

I am not 100% for sure. While if we trust it returns 0 if folio doesn't
support large folio, I am afraid we can trust it returns correct value it
supports. Or that would be the issue to related file system.

To be honest, I am lack of the capability to investigate all file system to
make sure this value is properly setup.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

