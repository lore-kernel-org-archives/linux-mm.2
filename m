Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F34CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B53B6B000E; Tue,  2 Dec 2025 05:53:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C9E6B0089; Tue,  2 Dec 2025 05:53:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9966B008A; Tue,  2 Dec 2025 05:53:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2336B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:53:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35C7513B20B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:53:07 +0000 (UTC)
X-FDA: 84174218814.17.F17CB72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87E2314000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:53:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nYZG/0Sd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764672785; a=rsa-sha256;
	cv=none;
	b=l3AxzWMDAy1DjVHxV4bo+X7KLEv1CZmnn0q5W7GcPTgfjZYR4G4tE3ezl0x4Q1CAfr32aP
	h6+ZQlZGYLmC/q3zIs2OZHxnLl1Vj9oWiTjttUbOt19v3x6wfBroicpaZdGnSlIUJPSHNv
	owYVDMkfcHQIPmp97yMYDxODcDE23TM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nYZG/0Sd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764672785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCxkLAzQCxKetEngEUEFqYG0f+0zvtH1hYUzPlJ6gds=;
	b=oAaTaXjzi+SrQ9K19ar2f179xq35VYS6iQqLO5wTr331MlLdQo+pW6wFDSaD1lu3pRmMc7
	1gy07o3DYPK/2tUkEfu9QPbYmcKvESNu1YULIKec+zS1oJaAQKcXBUiHFPUt8syXwnw7O3
	F8QDXdL9j/xPvjJLHeuw5+kbFpFU3rk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB83760017;
	Tue,  2 Dec 2025 10:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4148BC4CEF1;
	Tue,  2 Dec 2025 10:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764672784;
	bh=OmPhH3HhvCNMCbQikthtJxXqV7Wt3ktwIhlSZKtLviA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nYZG/0SdCZRgG4uvlJTsEuJyC8NWpZfbvUW3z/YFwXvUys51Bx9c7OgkM+0kusk7k
	 /GWeRZ+yI+FOE5EB3F8xFCX/87WBRT5HIfVwPQ8AWHk61CXT6esZdCsCGy1Kh77xG+
	 U/vpxtbecXmK9aNP58mwCMEGtjHpRu9nR5g0g3QIaFD/EvOZbM2p4RWKdLAlR6pqux
	 9/SgFYLeVpOqTA7DJnW72h6EHMhHTUEBOwuRsA5Yzn2pwA6+MA0k0X2llYnjzmFg4N
	 728cDxeb7oy7V7DgbMKPurjKeeu4Flj+/WjKhCqo7G7ewWFWxNMU+h+gD1Ij0V9p6G
	 +xTMUhlPnIscw==
Message-ID: <3fcce19e-ed78-4b83-bbdd-e925a74091b2@kernel.org>
Date: Tue, 2 Dec 2025 11:53:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 07/10] treewide: rename has_transparent_hugepage() to
 arch_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <9b56da53df2f0da40be68de9a7208d527b144afa.1762464515.git.luizcap@redhat.com>
 <a64e9422-5474-46cf-9058-73aa29b7906e@kernel.org>
 <65b0c614-e6a9-4535-9d30-bd2be7a72149@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <65b0c614-e6a9-4535-9d30-bd2be7a72149@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 87E2314000A
X-Stat-Signature: ycn1mzmxdxk55ng9hfyizw9qjzjyexje
X-Rspam-User: 
X-HE-Tag: 1764672785-72220
X-HE-Meta: U2FsdGVkX1+Bzo35Fhh+M6uUPq6wxYiOhLX47EPrrWseTA80YPM/rMrXufUGE0vMP/Fn2qRU8yluBfM6gsoxJsX+9EY+IKM5hy9O+Z649Hr6n5Mvx2rqcqg0x9XmsKULlaUXMYf3hZsx5nFJKIyZaNlUOcchXGBHRAtlhi0kqt5Gxetyp0yGe3i4yxj0ueXz69VAdWLGmECmyciG2Nhd1pxmk1Fj3GkM9LIsjUo+kmOpETnShU+frmg1cbRc8qlK2/hNHDWJ3LorNg8gxg0KE0b0HDPE5s/vZTJyUFlGdFpB+44ScvV+gOKfoyjJFuE5ZpiTp3sPpDW6bfEvTDIyt/MBpRK1WqZxPYGZjxgvAmK4Ogms+EO31+ONHAttpBPZyGGKPAq23DJKyeGig8dU2Gcb0IOUfYLA4Ce7nezdkNmdzWr4kTOUaJSkL2A7k3DXTr38J1LzMI4bejRJxlJcHul9j+w6cJQjMmLU9/IW5wGIgYKCZipCInH+DWPIJQ+T6p/Mi2GAO5uTQr+vokA95PyuMZZGgsbvz2oeSZ1aGgOlAgH/sLbfEBrqgMDY8MWcR6JYjyHm8kX319+bG28fGx/W16CefKqNVrUEjh5AXIGO4DA/0rmyxhWTL2c0UxABRtoY7eMeRDCHjMfYxyRrENt1cQYiNiMP/TbltDlDjyIgu+vuL1dsWve3Q5Q/sgA0kKkF1Y1Xkqww9zqIvqjurGyTfSjMK6PmECwZRoY7WXFi5rWXxaCfoLWEyz5GimvgOZstASC8xO8Iv/l3LgOD/vTrBb7v0b9hBu3QDyUV3hA1LCkoi/byDtcxfjp9dLFyAJemlxp+7CnTSYeAV0jqnbYz94IP3q16N3XSCtN7tFqPjaDCeGVIAbb+Q5yJwNAyl8SxsJElgWFq5p2t7owCBoZpnnukmqFxamEjx8ViWahvTcAyYUzoNfml5Tg4DJi/bJFk1x+muukN8D1Qscm
 iIjIbY4L
 inBQDZFDAsWjJIf2B74wl/Jt8g+zrAV+JfSm1lNnk5yFcxMfYj3ASaS653MQeK3ZeyaJJkD5Mq9vnJCypJd8TSWL5syLT6kFpB1iekD0raPQEf0lLjcqb+VRHgc8E682yu6zAQ+teX6OyPsU8O7Mrtt9H4yOkHHL7lxq2n4ox4CP9a7Gety1eDJoWQkljA3D7UFVbo2fYfxAVx8ib+9w/MCj0LK1RgAlhEm8VjwjqawdrpUeDFHzuxPU089dSBxGxJVc4CbWYATwKZcQxClL0A1vBl60Vlu5pDtEAHLXqSyHxpoiiFItp2Fl/Nk5djMMDusCr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/17/25 20:01, Luiz Capitulino wrote:
> On 2025-11-17 12:45, David Hildenbrand (Red Hat) wrote:
>> On 06.11.25 22:28, Luiz Capitulino wrote:
>>> Now that the majority of has_transparent_hugepage() callers have been
>>> converted to pgtable_has_pmd_leaves(), rename has_transparent_hugepage()
>>> to arch_has_pmd_leaves() since that's what the helper checks for.
>>>
>>> arch_has_pmd_leaves() is supposed to be called only by
>>> init_arch_has_pmd_leaves(), except for two exeptions:
>>>
>>> 1. shmem: shmem code runs very early during boot so it can't use
>>>      pgtable_has_pmd_leaves()
>>
>> Can't we just initialize pgtable_has_pmd_leaves() earlier then?
> 
> I can look into doing that. When I worked on this RFC I wondered if
> arch_has_pmd_leaves() (when implemented by the arch) could run so early
> given that some (all?) archs check feature bits so they must be
> available this early as well. But I'll check this, having
> pgtable_has_pmd_leaves() being available as early as possible is
> probably the right thing to do.
> 
>>> 2. hugepage_init(): just a temporary exception, this function will be
>>>      converted in a future commit
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>
>>
>> [...]
>>
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index e4c5f70b0a01..02a2772ec548 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -2026,8 +2026,8 @@ static inline bool pgtable_has_pmd_leaves(void)
>>>    #endif
>>>    #endif
>>> -#ifndef has_transparent_hugepage
>>> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>>> +#ifndef arch_has_pmd_leaves
>>> +#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>>>    #endif
>>
>> Ah, so it stays for now only set with CONFIG_TRANSPARENT_HUGEPAGE. I guess that's something to sort out later :)
> 
> I suggested something we could do in this series. Also, I skipped
> commenting on all the cases you spotted as I think they refer to the
> same issue (please, do point out if you think I'm wrong).

Right. If we keep PMD-leave support glue to CONFIG_TRANSPARENT_HUGEPAGE 
in this series, could we also simplify patch #2, to have it reside in 
mm/huge_memory.c ?

Then, it's clearer that it is still glued to CONFIG_TRANSPARENT_HUGEPAGE.

-- 
Cheers

David

