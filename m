Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A85C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2126B0095; Fri, 21 Aug 2026 13:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973666B009B; Fri, 21 Aug 2026 13:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8894F6B009D; Fri, 21 Aug 2026 13:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6BC6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:47:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5B75160137
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:47:12 +0000 (UTC)
X-FDA: 85126007904.09.CE535A3
Received: from outbound.qs.icloud.com (qs-2005i-snip4-1.eps.apple.com [57.103.86.212])
	by imf04.hostedemail.com (Postfix) with ESMTP id E9DA540005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:47:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=me.com header.s=1a1hai header.b=K2QragLL;
	spf=pass (imf04.hostedemail.com: domain of ferran.duarri@me.com designates 57.103.86.212 as permitted sender) smtp.mailfrom=ferran.duarri@me.com;
	dmarc=pass (policy=quarantine) header.from=me.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787334430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2VhmwRLA0/YxX20HSTYb9Y0dk3EhkRW40iJHBlC3MI=;
	b=rJZrws90wQ/yJ0vhPSrwgY7zt+ObMtqptcrsdmkRPqiLCxYeo2H0kJcLnrDQc/Z0rbgvcB
	uhlIvu7JMuEFMY+pyfNnUR9rIa7pT9p0+/YVQGU1x+ZIgdXeYIrEufjy+dViRpZZKyEpxQ
	Xq3/KNn73qDb+Ikb/IFCPH6WYHeBRKA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787334430;
	b=G1phN4dGxnGV+1WyC/g8ZGKP7UDn11VPpk0yQDUAdeXXnF3I8gw+srP3Jxue8Dnh5lnV1w
	NaiEX/sWwZTgQVwkn8q+NnLK+u5wXvZpcDXEfUeZl3oguRJpa5pyyB16sHpU8eUAFqgyva
	7zEQdpBZQvv0ByKSnypF15zDpVDtrCw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=me.com header.s=1a1hai header.b=K2QragLL;
	spf=pass (imf04.hostedemail.com: domain of ferran.duarri@me.com designates 57.103.86.212 as permitted sender) smtp.mailfrom=ferran.duarri@me.com;
	dmarc=pass (policy=quarantine) header.from=me.com
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-3 (Postfix) with ESMTPS id 1CAA018000BA;
	Fri, 21 Aug 2026 17:47:09 +0000 (UTC)
X-ICL-RepId: 01a0256f-099b-7d40-8c70-6743edddba17
X-ICL-Out-Info: HUtFAUMHWwJACUgBTUQeDx5WFlZNRAJCTQhABkMAWBxBDkkdXwVaEhVdRVUIRRlTHhccRgxFGVswVB0dDlgGEhZdRV4IGQhdHRkKUFAOS1oVVRcOAkIfUB9MFldDRhgcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKBldeWhdeTVoCVk0FT1JUBF8ERVpVUF4BXB9EDElQQA9cBRYUTQcODlsCFVhBAAhVK18VFxtcAAlLRglJHQ4EVAddBV0=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai; t=1787334430; x=1789926430; bh=g2VhmwRLA0/YxX20HSTYb9Y0dk3EhkRW40iJHBlC3MI=; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:x-icloud-hme; b=K2QragLLATRWupJORvIJYCQMFn7WAJLjBtG+KP35sDIjIFuZbFd1+2hJwbqTR7EzSZnxOWP/OFcScumSSDoBnd7ZLa+1WtSebrsHOqg8BRGOQ+HeRJfka0XwfdpvZjCcz29k15NxGj3p67d6pCM0phzSEGW+k5MGlBaSlpTDTJhRNdKDhN5PLiPPyPD60KX7dfF5CtETqhxxaoTdHWivKezftRQw2Sj/XAqCrfAB0mf/lVWcqBJz0eU3GyxWr312ONEve7Gja7gmpT9eI6CpoEygNVTsWV+uVUcJxaqTqtQiaqdb/3hZiIS2t45LYJPN5dPEhkKk73f3OYbGywpZgw==
Received: from [192.168.50.153] (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-3 (Postfix) with ESMTPSA id 6E03C1800168;
	Fri, 21 Aug 2026 17:47:07 +0000 (UTC)
Message-ID: <7a93465c-c367-451c-877f-54c900ea93eb@me.com>
Date: Fri, 21 Aug 2026 19:47:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: default defrag mode to defer+madvise
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260820190825.221308-1-ferran.duarri@me.com>
 <aoh_40ku6lQMOUQb@gremlin>
Content-Language: en-US
From: Ferran <ferran.duarri@me.com>
In-Reply-To: <aoh_40ku6lQMOUQb@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 9bh7okFU6yN6IziUWUC4uAxCmmvctR-D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDE0MCBTYWx0ZWRfX9HgkChW0hYTu
 ql8TvpRVTvVg+JssxR0ZNIxpmVl4vz4CFEJAlWP1al5oktHg3EzP1KU32lTeo7xbPopspiK5nMe
 Ko31xgdcFPJKgawc+S7pdW0f3pXy3a1nLgOAvmsorZzWr4QWWW8N6GGlxu1vgyEtYGjH2eF0q60
 mXoaq6hHhIC1L2YPSBfuohIIh9KBfYPcBHNHdiyfpponBWsN6aRjQM/IyYjAEZNJjQlMB705Gzm
 VRcj28dqAuJ3c9LcZqvVcpv/GXAV5452pJ3Wzw2iLj80uQBwmzEFQFjhGRk52ZlfJd6O0q/BV9D
 wus8pmXDoUYrAteX0vExmqC2T/tGdjW6+cX+P9KuYW4Xkvc8DWguX5E4pk5RcM=
X-Authority-Info-Out: v=2.4 cv=FPcWBuos c=1 sm=1 tr=0 ts=6a888f1d
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=x7bEGLp0ZPQA:10 a=B9nqV3Rn1-QA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jJrOw3FHAAAA:8 a=VwQbUJbxAAAA:8 a=HHGDD-5mAAAA:8 a=w1rv-UEn50ML3h1tmEAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 9bh7okFU6yN6IziUWUC4uAxCmmvctR-D
X-JNJ: AAAAAAAByu6cv+0p/fqH+/i1pxDKHxpxb+v0LoP3FO0KoOqNmLd3x7kPkUocLbS3QVrT4fJ83Zcd2BQo+NNtyEeCuRXn9cDoG2rSCqX2foI2/pohfNfGeawfw4HFBsurKyMQ89PQ3x7fsxtAG/I4r9DbkfKGxNu30zf55Jk6XxJeY7xSAy6cv2c0lS2RwqAjr2Yey65sohmsdZKGxdknUj+Myn8sC2FzjXSt38uIXrC5dl37+OmtbG8R4ln+MW+6lHn/n95gOKDvDBxn+0QS6T2JVq+vYLRITTcGX1f9vZSUQbwTiaF6wqZCGOM4uJZuH24YK3L6lLqnbdyycOmLRKU1hCwlShdwy7CFxhJBTNfUaYtfqs+UgiKjabFS+MKlPoedtwnzagodCw928Wu5aGSAPgNuivWrAxwML2jwo/C7VaP9myGmUINCL7YNRklR2j4AbXJ4CQgKAN3JrIhoilRkryvQT+SlkAoxcFGZufa7CNksC9UU5HrcRnKvkNghD8djW+Jedp1MKHiZ2mMUH5vBaot3BUYnjVT6+MEhuJz84L3a8gHmUQXPkicul2XgooIasVFJCuJtZbvY1ZND4WFgT1a9OIjGde0VfcF02nUyNwWVMAeXRid7jaM1sbRGT3w1At4Ah7Qm4D/RhUZcWrwivNifG9oSVnXAYpYMzeKI3qWwldP/sGrZVYazOeOV64q49uAfbOTnicSxQ1TSHI/sJVURA5RxpffSHrWnObYzQmSKlTO6LEt1uAcaQTi2gOpja8vLK45f/T+9hWGoQxLZ+wO+VrJB2wLlhE9E0oouXKhs8x7KvP4ea0lS3hLyzoG35aTiANwDh76HGTjGH0rRLeZAW0ibhh2rcFTNuRKNraaA979kzP8+HVyPscOK/U8HOSwKsy8e4O5y4zSl7BI0sYq6xl43vSUvq/ToIpo7GH8HR2Ubohj9rxE6juDkTpOx3s74YPikZwpNh00f0zb
 nuljusX7
 kv2v7XxXMUWrb4NLsg22P+VmH5nTXzEVa+NTHH2JpzZ9e4VnW0y4dHmxopPGrGecxFDm5VgL0V6xB7IsQL5QSFeF6L1oersr9t8wv44cfdhS7tC0WX30J0s6EFtgFLpKuY/tsDo7m+ratU7Ws02yNLImdSfxwno0s7eKNrDbcTHqFCAIMFgeAgCzoaWT/fIXiEzOmALAR9si573OPA0eLd43QBOxEiVQymAAAOQEcOOmvv8f+5HyD9lcY52tYP5o=
X-Rspam-User: 
X-Stat-Signature: c7438c6ttip3wa7mrhrzyd7ciq5acyf5
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9DA540005
X-HE-Tag: 1787334430-649901
X-HE-Meta: U2FsdGVkX19wHQITzqnIBlsHQd18teoXE1CqxihvfraLPucZ4q6oXxWRSwBfOb9PtkXpfG/CaDo+dxcaREfMHp7ZNBfgUPgH97TUctHIIqsfzj2BMnBnqDydXkHm/PAeTdq7TGdDW+uqDhnXTg9ucMnQMKo+zk0GjB56bslCijudH65l1hkX5j4ub2k0Xml5nCmD0VSnGBQ5J8HFhVC6mrvXMb2V9WKeQIVFI79R1DBmTjfuI7ZuV0Ui/sQKvYeqprxkMU3slv+JAkc4FfMXfL1uAmbbyTfId4sD7actLk0SdIt1EegKDSHOyKoQuHPfuG6PKqhRkuLCgSh4jdh12eG10T3FsYsAZ/iyTs1wOj0hYMju9pQZjKrHZSvSRqzR0NuayhySDc2CaBhSiKbXNNUxQUN5T6v/3o0V6PWUIILVCYp8keWfEXxyUmbDg/nDI9LnV/k/BA7ZxTA59qUWHAw0ultiNDSEaZBIfRcfjVb06VSjymGqNG481xFJksEcj2Od6mtqIx4VWaUiLpnO5jUVuUDAs9i81tWSwp2nZDdSAHjFEZsMzGyZEwsyUnRxG4h/fOjawXZW9XXiSf3CcEnmvvUW1qUbtS8iiUp6a/dBMDomdBWRWLcez6uXHdF1pgQXSljHdnaQ5tY+3Lx4fiYWy25SU9oF8pINH0EbZRGK952zC5UavZp+hODwh9RQS2FYks89TqyQvE8fNvZxHgYcsbeoMvYX2FtdebnQqA2D/g/dTgMMOVeQKdXfezOlW5XncjbY/EQqRfnui15ZKHCQ25i6B2wzOw/08bmfdp4fsRfIZ7uBhQDsLwanhQ9jFU96yOnbjH4ErcL5tF+047xGUpYC8s7RfA9BD18BIR5xRooEZsDtdKz+wr8pK822/zAhc2+31J/7sEpcHceWJFxBn/1mpc7nYN4VCzgdYJcUr6Nfz+wHmCLLD5MIDRui1Tn4d5AKjA/Fif/iett
 yZahQ00i
 0zZB4+yz1XEvr+d7K74womuNpV4Ylo9NrmxHxMbmGFnOJdNht8l/VXM3LKHkVd5fSSsF/GhBHU/xNvQ0Iax/TrqkMwJfm2EPTTZXgrrPtzWrB+DTwT8fkXyjuokNtvdjT5NHoHe2TblywvzqEz2z4iLBBRNnOOu1rkRceVKP5gP5hNxN3Jgu7Xt9Ex9I1b9SmiCR6cOuvu9tuXuVJwsCXTIoGh/tFl/weflJwHKMbK5NAzRRv5sR3W/cDOtMRZehDhgqL1gX/pvNzrOksTWkwkO+osVG367fndk9+GL6mntsBOG+B+o3b59xnZIrY1BDE/QzF9fml/baounE3udvvenoBjpklpoOQCEWIKSmtRd+yc/2yp5mhcCTqR67qirncfxnVYxOfAznbnhCqkh23oNYzZ/FKdl2K95OsAdLcy3n/jcQSKhq/scsaoLKjNBzxrwoX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bad computer. Go sit in the corner, and think about your life!

https://youtu.be/_8c58JZQ4Bs?si=mA66nH1swfK9eRML


have a nice weekend,

Ferran


On 8/21/26 6:53 PM, Lorenzo Stoakes (ARM) wrote:
> No. We don't randomly change core mm defaults like this especially not on the
> behest of AI schlop...
>
> On Thu, Aug 20, 2026 at 09:08:23PM +0200, Ferran Duarri wrote:
>> transparent_hugepage_flags unconditionally sets
>> TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, so the built-in defrag mode
>> is always "madvise" regardless of which of CONFIG_TRANSPARENT_HUGEPAGE_
>> ALWAYS or _MADVISE was selected. Those Kconfig options choose whether
>> THP is applied by default; they do not express a preference about how
>> hard the allocator should work to produce a huge page, yet the defrag
>> default is pinned as if they did.
> It's not pinned. Distros change these as they please.
>
> That's where any such change should be.
>
>> In "madvise" mode a fault on a MADV_HUGEPAGE region performs direct
>> compaction in the fault path. Paired with transparent_hugepage=madvise
>> that is a bounded cost, since only regions that asked for it are
> Not really that bounded in practice.
>
>> affected. Paired with transparent_hugepage=always every anonymous fault
>> becomes eligible, and under memory pressure the faulting thread can
>> stall in compaction.
> What? No?
>
>> "defer+madvise" keeps the same set of regions eligible for huge pages
>> and the same allocation attempt, but on failure it wakes kswapd and
>> khugepaged to compact in the background instead of doing it inline. The
> If we felt it was right to set this a default we would have...
>
>> fault proceeds with small pages and the region is collapsed later. This
>> is the configuration long recommended to users running THP=always with
>> large anonymous working sets, and it is a strictly weaker stall
>> guarantee to make the default.
>>
>> This changes only the compiled-in default;
>> /sys/kernel/mm/transparent_hugepage/defrag continues to accept every
>> existing mode, including the current "madvise" behaviour.
> None of this judstifies anything.
>
>> No stall measurement is offered with this patch. On the machine that
>> prompted it the fault path never reaches direct compaction at all:
>> thp_fault_alloc is 60682 against thp_fault_fallback 0, and compact_stall
>> is 0, because memory has stayed abundant enough that no huge-page
>> allocation has had to fall back. That makes the box unable to testify
>> either way, and a number gathered under those conditions would measure
>> nothing. The argument above is a correctness one about which knob the
>> Kconfig choice is entitled to set, and it should be judged on that.
> This sentence is truly ludicrious...!
>
> Made me laugh a bit though which is something at least.
>
>> Signed-off-by: Ferran Duarri <ferran.duarri@me.com>
> You:
>
> - Only started posting patches yesterday
> - Have posted patches all over the kernel
> - Post walls of text that read exactly like they are AI-generated
> - Are trying to change a fundamental default, not as an RFC, not citing any
>    actual workloads
>
> Go away and read:
>
> https://docs.kernel.org/process/coding-assistants.html
> https://docs.kernel.org/process/generated-content.html
>
> Then ideally just go away.
>
> We don't want AI slop patches from people who have no understanding of what
> they're changing, thanks!
>
>> ---
>>   mm/huge_memory.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index b118bcd392cb..749f669cca56 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -63,7 +63,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
>>   	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
>>   #endif
>> -	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
>> +	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG)|
>>   	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
>>   	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
>>
> --
> Cheers, Lorenzo

