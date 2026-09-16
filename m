Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 544C7C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B316B009D; Wed, 16 Sep 2026 09:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C8C6B009E; Wed, 16 Sep 2026 09:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543656B009F; Wed, 16 Sep 2026 09:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21BA96B009D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:34:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4A46A5A20
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:34:31 +0000 (UTC)
X-FDA: 85219719942.16.81A2302
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F19F5140012
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:34:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AK/o8eNs";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AK/o8eNs";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565670;
	b=WpHy/AKAJVJ75gCh1272xIrhdkWaMc+/EcoVJpz2sdoQMlrQUfHdNjioc25vEj7xC7Saia
	eFFQc3/1eJwCmBGRvy4VKbks93lyIm+wto3DG6P55JiFYYvrbvlJ4qIoHJCV1G2OHLSZeC
	xfMx71c6e1ZF7h5rdVEbXDKGEnPwRlM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0pwhDPf1ZcMsFXr2wFtOfi9zYP8FgQyGaMxEJBJLxLs=;
	b=RaSyPUlbR2a8F7DMsFsme6pN+KQhkUkWPa+GbIGgMWaWKa/1tepcc+GIAJ1L0bVd9EHGlt
	35sZm0yRzXN0ru5LBHQDWG19xAKZR0yZgAPyaA/BmE7XRToHv2WAI+8snSWtO/2l5r6KJg
	4RFcA6t+ki9vOyjez3NR0R1fZzqre9E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F7DD6057A;
	Wed, 16 Sep 2026 13:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0531F00899;
	Wed, 16 Sep 2026 13:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565669;
	bh=0pwhDPf1ZcMsFXr2wFtOfi9zYP8FgQyGaMxEJBJLxLs=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=AK/o8eNsta406tALZ4n9LY9LZcOKGvZzHbQFlv4LP5s4xN7btezfxtDaU9z81nya+
	 l6U8c5hPVqwXmGK/Kl0DYNG4ENW9dbQNIkJwlLwoiRsvbF2S7+CCFUKopJXF78x2wp
	 qtg8qNMIMIr8JhD+3m3EU4wdBXE1Vdh8nuk5QpIwFq+AJ/w0/372Fan5CtjG06xRDO
	 cZFRNtt/b06Dt6qADOU/M9gHizfEDHokFdaBR03wKLBw/+ZcKTW/5ZG0aWDVpccajh
	 NHNe4gIQm7cJHXhzEGDMJjNRiYJyXS/umqRLIBpjKwnB2O4sntJSe1exsXm+zqiRTL
	 T9FweJd2d5C/w==
Message-ID: <0deef591-d82a-4034-9514-abde0e73e5e5@kernel.org>
Date: Wed, 16 Sep 2026 15:34:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/17] arm64/mm: Convert READ_ONCE() as pmdp_get() while
 accessing PMD
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, Mark Rtland <mark.rtland@arm.com>,
 linx-arm-kernel@lists.infradead.org, linx-kernel@vger.kernel.org,
 kasan-dev@googlegrops.com
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
 <20260729122452.3797443-3-anshuman.khandual@arm.com>
 <dc0e039e-49ef-4692-a07b-2e4e4a067b3a@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dc0e039e-49ef-4692-a07b-2e4e4a067b3a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F19F5140012
X-Stat-Signature: hzpi5khzaj3gkwus75qecfc6z4q3fq5r
X-Rspamd-Server: rspam01
X-HE-Tag: 1789565669-782254
X-HE-Meta: U2FsdGVkX1+2Kz6d7k4Vrxd+fzXSEIZMSKRlf2kJY9DzaIw2HzyOy2DgwXO24EtjX7RBkICXVqzQWYTAeFURuWa54lxNTXEGvoKsIiXLZgUQYIrLgn5UxzLhLge64btyqnb5/+EqUPV4wvO1xiik0j+NWRCUsWQALm9RfCWte68PITaMN22vr3pmfTzEaESY+TIsYIZb3sr9kT839/2KfF+oWTSqzRs3laF35qBeAOLrzppCrtxJ/uZYUK3UPitWzOiQbMMkQVVANAcxePPMUC9QMsu2PPsT6xdW/3I5aclHK1BbADsrHwhnVdTUA2uIqMXzgJsi8l2LFdTSzfiLoHhltn6soz41kAZ5jJ9cFe4zHdqK/uawM2D9QqvPQNcErsGV1uRPcG/8/leLk7J7xryuCLQeihc92YpGqt5jTyvlk+SpiSegDHNMPVKcoAG14C+BuvFhoIaPhhFw37Ifw1t/j7dMrtt0PXdVGaLiL1PeyQcY5vGZYAqhxEXWyw51eF6tcIL+3kVhqCBON1dIhfgtK+onnUvn96rVbDk2IPBiaZ/SaMb2ihnT6J/eUuIZ7XFbPl6PRTD6qbP2oNmNWwUsgGVSnXBTG3r4ULV6ln38MAIB0GY2AKezh+i6eZGmlBL7dfRitQJj7A98R8pVMVOhtZ4ghSArndc037a6urpR8edzcXDVFET0buNVzgRhBAq/q8hXR5l2Hkm50sgumuKUM0oCa0y7zg7idOE5ULivEevW9TTQQPKqZOKCKdMRaenJjZjCdapTisDBEsYc2rOE1pqxZV8SzKSUz990Z7jGP6swsGAgC+Tbfdn9/J6XLYYqmqNtqYjsE7+RxaJng3G7bEMayDaTOpsdPJiYEFgPhOlcyBAFwa1T0335W/vd3EZuJCnD4j7c0Lf2lFB7gqVaHKxR6GTFpQWBtjtj1COKLgdKQDr2CskEAvB8GxvRtwnrklDmk6ItjGHnSmZ
 f0gQ6J6o
 MjdKQtA1vhHWxKy6qDMmW3EVaJmfKbgt8ZNfX/5k2XNoYvL3P1RYy/1D/q7PFRh2cfwYukf0ZGswTTkZJFM6GpXVOCiMG0LZe3f3lDkELPyAqOfoXxxaDEDeIX4/yOjWRoEluRQfpPD2a3AXptELQ0qsVGj/vTL5Nhq4GQD1KIgcRXlGXwnPs/rmUlMGCANXES4OtLwsAZ5pqnwrPPd3Hv89WZ1URNwzI+TBQjTA79yBQ3Mvcd8I99YzFZ4dAgUslVJswcpHiMihiViUP1UVYC5E4tKgO6o3VNm8dpNVuBSy1RmURYNSeJKeBiLjOlxGphLVqVigrPMriQ0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 15:32, David Hildenbrand (Arm) wrote:
> On 7/29/26 14:24, Anshuman Khandual wrote:
>> Convert all READ_ONCE() based PMD accesses as pmdp_get() instead which will
>> support both D64 and D128 translation regime going forward. That is because
>> READ_ONCE() would need 128 bit single copy atomic guarantees, while reading
>> 128 bit page table entries which is currently not supported on arm64. Build
>> fails for READ_ONCE() while accessing beyond 64 bits.
>>
>> Load Pair/Store Pair (ldp/stp) are only single copy atomic if FEAT_LSE128
>> is supported (which is required when FEAT_D128 is supported). Currently 128
>> bit pgtables is a compile time decision - so we could have chosen to extend
>> READ_ONCE()/WRITE_ONCE() to allow 128 bit for this configuration. But then
>> it's a general purpose API and we were concerned that other users might
>> eventually creep in that expect 128 and then fail to compile in the other
>> configs.
>>
>> But worse, we are considering eventually making D128 a boot time option, at
>> which point we'd have to make READ_ONCE() always allow 128 bit at compile
>> time but then it might silently tear at runtime.
>>
>> So our preference is to standardize on these existing helpers, which we can
>> override in arm64 to give the 128 bit single copy guarantee when required.
>>
> 
> Best to mention here that no functional change is expect because the common-cde
> pmdp_get() etc helpers do exactly that.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Whops, accidentally stumbled into v1 in my inbox after starting to look at v2 :D

-- 
Cheers,

David

