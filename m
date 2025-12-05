Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C076FD2E00E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238DC6B00CB; Fri,  5 Dec 2025 02:05:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210D16B00CC; Fri,  5 Dec 2025 02:05:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DBF6B00CD; Fri,  5 Dec 2025 02:05:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 046356B00CB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:05:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C1B3C026E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:05:24 +0000 (UTC)
X-FDA: 84184531368.21.38CEFCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D016A1C0006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:05:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K3EFtiCP;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764918322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aifju/C9UIq1fsTT/dqP4jzKTcvZR3ZexRADB3JKvQ4=;
	b=2TDtm596+z/Chfd/iN0EKbMKMTCgZ61Nig2ZxxzeL9ZRSYsKencjRYteMUPL9DxH0ogr8Q
	KzYvX6UK1bn3lTxcNqezu3T4PV4DlQxtEMvwZtDkULwnlV62mY1H4VlUXt9lVmrhUMQL0/
	TCTrmwdnjX1WE9kUcuVLd/i2mmSVfW8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K3EFtiCP;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764918322; a=rsa-sha256;
	cv=none;
	b=ztGx5oBmgx8BjD+M4lDrLFV6DstlcwHAU4zho3mxBH2RIyc3jM07PF6MAToTXsHW5ndsdb
	sAZLGMe/84LOPhJvs0TBAHReokok7PemjydSzvZ0XhOQUfOY4QspfwR0Mvf4pxIwW3bLem
	GMZt9/8z7KpibdL/PO+v5BgcdAc+1ow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38EBA6000A;
	Fri,  5 Dec 2025 07:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6D7C4CEF1;
	Fri,  5 Dec 2025 07:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764918321;
	bh=pLFYJRb6YhaKELyTkQIdNWJE3/HJjwoQZjQuRwUY00w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K3EFtiCPH/gJxujbU4Cm+y7/bAey3QI9Olbp9MYwWGqC7Nmv8R/IjCikrcpGvkR+W
	 ahUS+ovOEboDaV6dvr6n+DYzDjqyq+goOcuPYIQPNztPcQ0qdsAPnc/EszXF/NRH1k
	 BScJhY6UnO97T36Uv92hUXAXhZzyfiFIPORS9dEO7uqHQyKbKV/ZR4g9SGV30lCKqP
	 qn/kmdHGZg3eIpG4Fa/IGcKA7LtGyxxdtF0K7sUXEOMvhfZ3fbnRcACcAWBBtxJMz7
	 0Znmvz69YxleWE8ugaLzl+EOQM+eebbFiMDO1OS3/2ni9BuY3eoU+QapHyPYLBKDk1
	 Ti0fvrzdzB2qg==
Message-ID: <dc22e2e2-a62b-4b9f-9fb0-f3a42a57b00f@kernel.org>
Date: Fri, 5 Dec 2025 08:05:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>, maddy@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, masahiroy@kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <20251204135746.6d291cc861b4507b1fe95aaa@linux-foundation.org>
 <aTKDRF2sMdM_5aRB@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aTKDRF2sMdM_5aRB@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D016A1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: cgtbwmsarcshjco9afsdwzqt5jigh7jp
X-HE-Tag: 1764918322-986092
X-HE-Meta: U2FsdGVkX1+fGlTxPaUUiAJbb8FxrMfUg+JJnG95Gc6vW5og6yPGXkJ6FVDQdxPIa6AV3KT/2KeaKP7MDVewSslJT7ZQidepR8NroiPXYfqmOKGyxLugISEfvqe4M8L+3bwC7wH83+MLWsroPbtsx4PlTXlFnqZycCsITDfj8Yg7wyiHFAttvcPP2+nR0RSDgSLn7mxV2J/Jcd54kkqwBs7JHDXtV0x0U5WWwb0wyUp0DAE8IPme8eiqdZmi/MAdzV7HrB+5YG9UW3VLf/AnlvOSP4g84FsZu3spSQIrs4lSi5W1O39YhMTO49uaw9AY6KXCiELAztaX2PVivOk/74TAG0G1efjxKYY179TsrmAMUf9NFhwNtbGtVZEqZKmdpL6CcC6OGEzHSKgUO9l++fPqXR0/ddnSS3ZMxtfjgybAnePNBg3Yf+aU4UgyuqSKeWadbKYproUGh8s3BIZVcBrTiFhP7Btp2PP9o8BKyXr2xcJvhflq99Xf8gaa33Ck9LFggj4ki7sDX+1H4sJrIDfIXZKWh0H4a7pXy+Pdfc4nC0aQpkNvtO09kx34o7hbMTsuJS1FzegriOG3X3RwpBQctc2221F8VPgUz1Engrq3Uziw1DmE9HjnS6I61LGJAir/btk5463ZyhLb4VsCDo5BR9YBSosofqmV9m2xtp2uxvdlbmyXuEZFSGRXCr4f7aZQfj9BHI4B3AQ3rSkatyW6hcjLXR/B2FQrrY5S92wugt/M8YWDUduwlsNUHHpWATDZJqPzGwIGvAamE4vK5u/5BRH5fa9+UZslNzYA40SmfoM9FlBKQRSYbACHV146gF91wT/UUATOCCnR6BS6tYzQIHuC4WYEiHhQSyLhHWtS0YFX+ci3msRWMK8OGDCB11gEvfvJtNC9BVvXDzIGGEaFJ5gBKBDDZCPmFM+tutjKKs5T8ZgF+47PVfnW5Xv0bIpUR711ki1mX9nhLZo
 nx2EMcm9
 63Jy/OF2XLrkKGJNlABlT3Xc1D7z3mzySyeNIco1KFhl90hxEfor0iVh9qAZMqRkxcAoSNsx5YUgYoC0/YUsAR4uJx+e66eEr46PaePdKTrTi1LUWOoAv3dMEC1To+7jN5ZMsmaZa3R4WH21Yi7dWn1LKTs1w59Y4NFNbuSp5zZFyAzPPbksmX9epyE5m4XSTkmvpsfL/nGAIR1/FIliqTL9B7lUjEQ4Rz0LNRrWpnFVmFOhcs7SGsDHbahqCTVDej1eM4LsgRwImQ/OOa96cvc2ZtHHmsxck1s1DV+9dzpWWPGouBsYcYPdmuvPSJnFGzcDCrpHobrNS6it4oRMkkj3Xj09RKfygCxmSv2erGyJeAu4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> 39231e8d6ba7 simply shuffles ifdefs and Kconfig items, so I assume it
>> exposed a pre-existing bug.
>>
>> Reverting 39231e8d6ba7 will re-hide that bug.
> 
> Shuah confirmed that the bugs were on v6.18-rc6 and they were fixed in
> 6.18 [1].
> 
> I verified that reverting 39231e8d6ba7 from v6.18-rc6 does not solve
> anything, but applying 5bebe8de19264 does [2].
> 

Thanks!

> So reverting 39231e8d6ba7 does not change anything and there is no bug it
> hides. The bug was introduced by adfb6609c680 ("mm/huge_memory: initialise
> the tags of the huge zero folio"), was fixed by 5bebe8de1926
> ("mm/huge_memory: Fix initialization of huge zero folio") ...
> 
>> And that isn't a bad thing.  If we re-hide the bug in 6.18.x and in
>> mainline then that relieves the people who are hitting this and it
>> takes the pressure off David, Mike and yourself to get the underlying
>> bug fixed in a hurry.
>>
>> So I think I'll queue this as a hotfix, plan to send it Linuswards in a
>> couple of days.
>>
>> Or Linus may choose to apply it directly or to do a local revert of
>> 39231e8d6ba7.  But I don't see how a local revert will get communicated
>> to the 6.18.x maintainers.
>>
>> David, Linus, opinions please?
>>
>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>
>> Let's have a cc:stable here, just to be sure.
> 
> ... and we can skip all this hassle.

Yes.

Thinking about reverting arbitrary commits after Shuah clearly tested 
something wrong is completely unreasonable.

-- 
Cheers

David

