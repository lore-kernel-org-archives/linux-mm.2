Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D77EE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2D86B00BA; Sun, 21 Dec 2025 04:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FCF6B00BB; Sun, 21 Dec 2025 04:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A862C6B00BC; Sun, 21 Dec 2025 04:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 959C86B00BA
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:49:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CFE916071B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:49:25 +0000 (UTC)
X-FDA: 84243005490.03.0873587
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D7CFA000E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:49:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V04umGEW;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766310563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2YEnj+H8/D2wYlZ6pFvveq5LLMpDOkpHOgu9JgxHPc=;
	b=eNr9As+C/9tajoP+B6hkw4O6Ux3tMCsDbBPKXaUXXGXNHq1smulBV71F/ZldXMBsrVHZ0r
	73cH6VAJ8WuIkQXJLVzlwOSrQXxYuw/HG8f7nWhYFoc/cspiT/ztkACs53ju+4F+APncLu
	yO4jsHRfH81L/QKTcQvWxctigTIy0rE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V04umGEW;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766310563; a=rsa-sha256;
	cv=none;
	b=sCk0px7Fp5W7DA28bI5boBxnLCKbYk6zhoREkvvqw5XzDfkhY216AGRpKfla0TwyFnTnVN
	1tuKRFv8o33f7UhGT3cYppQeVF4yyOlO+GcRtA1i+AXFYK949kF0bXovH4P3TlpT+r4yCn
	Ax5ZtBD2w/CMdplpU0ZOy78oR0DGry0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F38CA60007;
	Sun, 21 Dec 2025 09:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AFDC4CEFB;
	Sun, 21 Dec 2025 09:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766310562;
	bh=tsj0Y9TsuBsyw04bXuGsZP/6xPjK8Tcxqhyw9abf304=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V04umGEWs1079s0RySfXElGgYq7u0L01Piv/Ll9FUuBkNTe7ru14oQDeU5DCCIUPo
	 f+x4HOb2YQMqzKHd8oFMA/sW/C88DbVa50alSOhF7TvRWcHFG7k5TGGhHfGe2uRe2p
	 R1ifo+skhV+wl3EMmFfKkp1i01b+NQM0gxZxHdUYIlfEUTZhUuqzLi+rcnjt+IIIwl
	 2/Ka5ruUdGsy/oiCbSQsTnMA8Pryp1Ek6Qi/WtzXg4ZqK8tt5uDemihfKlccNt4Vmy
	 HNj+Jy1tF1VQFWxd5H9bxyrLfrkUGgJQh3edbHXAUe38uJ4A91K4V4ekbcHSofJGms
	 5EggwqIO6gS7w==
Message-ID: <30a75bb5-7edd-42b1-9a94-8ffe017bdb0b@kernel.org>
Date: Sun, 21 Dec 2025 10:49:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm/charge_reserved_hugetlb: fix
 hugetlbfs mount size for large hugepages
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Waiman Long <longman@redhat.com>
References: <20251221085810.3163919-1-liwang@redhat.com>
 <20251221085810.3163919-4-liwang@redhat.com>
 <970fa015-9ec8-4903-8e2f-f3e847d550d1@kernel.org>
 <CAEemH2f67p=wqGrwYnoVCP1fR82xxwJv1xfbMmFrvNaP7LZJog@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAEemH2f67p=wqGrwYnoVCP1fR82xxwJv1xfbMmFrvNaP7LZJog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: majornfgh396qw5rw4itzrpx3wqgr9ka
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D7CFA000E
X-HE-Tag: 1766310563-58105
X-HE-Meta: U2FsdGVkX1+W5hAz6G+OeYxj10DpW9/eKOvJIsRxPd+WIKzZb/OYDSDXCaCNg/CaHknu3I20mvme6Aib24QmjZmuxH6FI1gyoqa3nKghXLcKSp1Yp2tO66cjbbkUzOiSzZyjmQ7V9F8a2J++tG325qb/Vw2k4cFKFMGomF5cSgtmRUclDTESQYyihQk+wREsuaXcrzMMeEMYPsQ/oe6b1XVf3NauN0hLLSROFjMGB3Rb1+5/+cYIAbiQ3u5P67/j8fS+XZByeS5qDyt4R0k4Rn0fDV+7bBl+cwELiMaRhgU9aT8lJFxe+87eyp9+l1zh/WLVBrZztp5fZISBGzZzFdcxO2mkscIMLKPoJnSUJVORPwi4BDfcWlgGIZ5oKLovi6J5MAHyEXcy04PXOTLdqFSyOhgv73nnGDz/beFCnJR8n7YhsKTHBaR31Z/PkvLvfP2+kpUPtoC6b6eT8wnmESkXxhrzJ/jTR51u6rYEB0spptn9U/i7sMmFgdNhbRnjLhUu3iQVeDBREXJfap5JEi5dqmDnPkdQ5xog3vvU1j2g1n2J6dMS4mx3uEjGOFzc4fzTtCirHGnrAFZDuv4ojFdHuv3O2BXpFm4qrSLRn5R5gff0weIIJKitq182uEf3zL1vYCwCc23Bp1IR3KnbGx8DOA8Oe0nKoshlSe3D8ZW8NsP04ptfKZc6CL9QUnM052gmrAtb6hRFWhR6yOKjf2pg9xNK6+EpVZMXG8NPAiw1FwPxVxJISHTonnxvRDq86jiaRqWDPO+NEU8a8RaSRmDSVma1rVED5JhbH9jO3CF+A1ObSz+IyY/1ufkcaVpZMeuu2EnelE1cNWO6cfhox69p8uxmH8TWXwjco21gJjZooZJX20en+8t9hLxrgaVLQoJ/9belyUu4DjQyMCPheWkXVtxR4W2CCPcc28UPUhyBpFhUqNHiFHaudnwztGX3XfrNBoVkMjqpoy0gYAh
 6pOf93MH
 WTkTM1oUU833+HRrbaONFwnU3S8tiVDwiY6DParvhrVsMfH/uaIVef9mla6lqW3TNCBhRTovqz3c32sCylw2fD+bGWC15p4QBYemFU5etRVbg1PFtEwKi+OY9QcM8Rh3S1avXWqWaMt/vedmV+YRTEaouamwmGdf0KInHyy5Qn4iVo1i6p49gPrV2kjyD29TvSPCi8ezCpHnjpKiQfj6j0fgtJpXx/+nGja2SllgrXSfri6PmMAfkvgI0gtBUZ0XjKOa9o34EyyjLa3gCkhvglfEbz/yiANvUgtRgSp56uEjiQsM1vfHeSJDZ5FPb8d+XYTOndO+tddOztcdtjl+RBPRvAZ+oSBQgZwJt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 10:44, Li Wang wrote:
> David Hildenbrand (Red Hat) <david@kernel.org> wrote:
>> On 12/21/25 09:58, Li Wang wrote:
>>> charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge with
>>> a fixed size of 256M. On systems with large base hugepages (e.g. 512MB),
>>> this is smaller than a single hugepage, so the hugetlbfs mount ends up
>>> with effectively zero capacity (often visible as size=0 in mount output).
>>>
>>> As a result, write_to_hugetlbfs fails with ENOMEM and the test can hang
>>> waiting for progress.
>>
>> I'm curious, what's the history of using "256MB" in the first place (or
>> specifying any size?).
> 
> Seems the script initializes it with "256MB" from:
> 
> commit 29750f71a9b4cfae57cdddfbd8ca287eddca5503
> Author: Mina Almasry <almasrymina@google.com>
> Date:   Wed Apr 1 21:11:38 2020 -0700
> 
>      hugetlb_cgroup: add hugetlb_cgroup reservation tests

What would happen if we don't specify a size at all?

-- 
Cheers

David

