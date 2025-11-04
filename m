Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3909DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863568E0104; Tue,  4 Nov 2025 04:05:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83AC78E00E7; Tue,  4 Nov 2025 04:05:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777F58E0104; Tue,  4 Nov 2025 04:05:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69B2C8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:05:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BE0958FA3
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:05:57 +0000 (UTC)
X-FDA: 84072342354.16.78ACF18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A92CC000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:05:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rq5JaumG;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5F6wGMbN1BzZrn/bIp7abTTk8JrSQUtv8N+CY0lD0E=;
	b=DIWcHnlfgFiW94aY0Hd6KC8u9nJ/xhk001Dw5sOy+hbEBlYwJII/RQtb8EnTSvUJOkMA8V
	L4i85ksocZZczIFjlU9Xd/hELq5EKNDnSAOjO8lDhnxFCohnJsfn6k0Bqlwv6w2LJjp3gE
	79SDyk748CLGCA/oZ9CRtCPchdedNIQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rq5JaumG;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247155; a=rsa-sha256;
	cv=none;
	b=d9SF6i3X2/UaOz04k+jhkQrq6JtuBt3ezD5/MMx6+dOrOB0Ygl6iNM+8XBMEcXC3S/NXCe
	vl+sTUhOsUijQ87ltwxp54aWHZP10vvceHsWQfpMEqj52VZ0ijkfmHYDUMKRvEXXS0TVlk
	Tdpg9+cDYx9z09bYqi1ObZ+FSl+RvX0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0A75601F2;
	Tue,  4 Nov 2025 09:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8502C116B1;
	Tue,  4 Nov 2025 09:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762247154;
	bh=m9/JvCn8q/7p+WCWUxBlbZGnT4m8wys2pFYJkZHtm0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rq5JaumGB7BN+qkpT02Mu8jRnRNPs0Pms3Ro+ETsVXKCORzbJcOz5W22PMYkC4Fwh
	 tes955rmkmZ42UdcEd2Uoem0SShFpBHRcksE3zgjRlnwSXWRvnbvueUrGw0ECSDO/s
	 MjY5LP+5Il2FKPwOSlqH1+nU4jq4qvmiBFpEGoKVEwmA3DZFRdTcImDIZ+YGbAN/AQ
	 yl7fPhiYtTcNOzHivBASxNnUzBIngsjPVrIicrrFNwCt+tGhwIYCQzkETHFycmRNUk
	 nItFYKOSGX6ExSOrdr6ZyyD6VJNWfAwAgZUz24OGOegr35sabdk33p4beRRAyv/bX6
	 3b6jjV9eiN9cA==
Message-ID: <e2c1f4c6-6573-4155-8da2-689678fec697@kernel.org>
Date: Tue, 4 Nov 2025 10:05:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <f0fa3ed5-9cc4-4bce-b22f-883db9135a84@kernel.org>
 <20251104004111.3h5uwrwhoifshss2@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251104004111.3h5uwrwhoifshss2@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7A92CC000B
X-Stat-Signature: xhihbwcebjdrm8htduuxqdjj93obycwb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762247155-315371
X-HE-Meta: U2FsdGVkX18ACUrYOIn+QrrOalvQKFodA1a3sjP46w6CK0/cpPFxnr4uTfBmqnGCuq+cEKejBa2w/wX8PmlnqurR9lzF8pxIUi857rXLlKIMJPopAbUua/FP0M+jwwB8zW+OYK11Ii+u/NtvVZKNZk0TpE7y+ykDhVJWH8g8q6Pjr0Q/qBEzguzuLtM/qaBXF7bGs3+ME0DCpCSsF+maaEifdlbTaYGgG7gaotl3wESRZ4D6OphiE/6FyjqGSVs37DWbbkRFxDg1Rch3KJEoMnewPKSnpg6rtqRAPGabfPxc2kWSZ+tSEVqSWvEYrLHRfQkugKx1KOaaxOHGzGi3JA1o3I/je29mFZd0zNBhoWA6c3K6WHShofOGRSbNbW6WUe/sDYcqhwULJx4dnhZRx3rApwginSmo8Of05zQfc2+K1xWNDDUq7SzBncxJV247BhDD2RdqFL4wP1kgK9L+X2wi4e5PkAQYliLifk1avkq8k0h7ikiwHKrDE3ZlDdC72OoaNndIXNEGagoizCExrzLyZV/LzPe8BwdEQFPF/dGB7URNGYqL5O6enXRY56drDrMIPCT8x9VY7++4mVWwEeGR8IJx/U57Codi2JAV1glUsWIaDM642lcS5biCEecYtzGZ99Mh20jV+klHM6yqQInZsR3kREnZCl1taffz2gQDYejPPerJVGEVXFdehCkk0XXxUTQDGzgbSM/Og/VqMUNZcv6Gjd2ibHZtAcsl9IZeCNHCk+pmx6myzAZYLjsz18/SoDuOey+hdfLfW2NmMn3FwcyWg2uQDx1Bzx3BwyLLGy8sTerqrGFU4WN3Noj/jzI1cHpT6+7QZKm5KcXCL1CkC3l8O1g3T99gDM7DJAc/FPondLq6n7Asq4gi4hETa8jgNMK1LyId1xEWe6dqlq42YCnSw3OIM1z86RlZ5GPVbZe07Tk3Kv3gRG83uVcgiwr1fsSSCuqq1enur6K
 tfzp+fpw
 oafD4c7UIh4DUIwIBl9ilbHso8uZga9PtAiRdTO+5GhF+LqRqJt9nDA8zclPd8Ax1cJfCHegyP/98Cd63KrbMTbjwhz5XlI43lK8KccVvAlrrHlqhsI66B6W6SbktXW9nmV59EjOjUx1XQ6umo0CUTN5xGtzksiVBFGnTPmVAaZRRn7QbVYmL5RCMPSGxWe0FuvmvHtEgzuapr0cnrBJAg5ByhU3Gq4PDr+vMgKWUUnmz2HZhrcrxEmAyMnPqncxnGzUnnxVUDcwVU2jPJqsQQaYOXYzS8vY/00v+OckS0urYgUhlYvXMgWKP34moflXeOrsRqNksbKZssuGgM/pMzUP82+GUsyi9WuI+wVa52s1i0RVSJ/tUfqh4wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Likely a simple
>>
>> enum split_type {
>> 	SPLIT_TYPE_UNIFORM,
>> 	SPLIT_TYPE_NON_UNIFORM, // or SPLIT_TYPE_BUDDY?
>> };
>>
>> Could make invocations easier to read.
>>
> 
> Hmm... if so we may need to change the caller too.

Probably worth a separate cleanup patch instead of doing it in this patch.

-- 
Cheers

David

