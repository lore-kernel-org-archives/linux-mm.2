Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E018CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 05:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E276B0022; Tue,  2 Dec 2025 00:38:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93EB56B0023; Tue,  2 Dec 2025 00:38:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854826B0024; Tue,  2 Dec 2025 00:38:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5446B0022
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 00:38:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23597C04A4
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:38:10 +0000 (UTC)
X-FDA: 84173425140.29.9281E58
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id E84DB40002
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:38:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LD4q5qmJ;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764653888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmlGapgAOn6oKILJUALF6nuonOKxFzrwkGnc3n/c30M=;
	b=ruvVSZeBV4LNx7MHvv1Xbvh4kzgh+RxD0CZI0fLXewrshvKB03s38XhT9h730SAK9BpegV
	qRPGaIpFegjmpqYngUmbdtmF7cJUDSGxhAtI05LBPNUi6PKbcLeo2ZwUzPVNytbg1DWc4q
	oqqgdGyvEaTt7v1Iotglhnmi88k4oUA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LD4q5qmJ;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764653888; a=rsa-sha256;
	cv=none;
	b=fGjoD7atZ5b12dyITyXahtgk21gQC76zZ1Vd9xeeOGnDw0iAd/CnLNcNWwAQMA+1LL67Om
	2E4XsSgteW4PPjabHmqP/b2cQeU0qOZzn0uWVkIuZH2jKMyGFWknd4Z1qOdyIJkP8ohhoc
	AG1bE6AiAsJJoUkMXMGuwPcveFFRBJI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764653882; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wmlGapgAOn6oKILJUALF6nuonOKxFzrwkGnc3n/c30M=;
	b=LD4q5qmJbxULP3L8SSU+9+jBLcdmrQL4BDcdZwANRvGiM63UIFdIjib5DbDTQv+iwRN+CmsveP7gKwBzTO1VPxkn+LwasBrLvNUG/JA8cKX38bOTJgYhMsnoE6YlNjLJhgh7vusyjpiyOea4ODRFtHLwfEt26pFciLSwrq7zDtg=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wtv94AB_1764653879 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 13:38:00 +0800
Message-ID: <a2b43faf-cf33-41e5-8997-e4a0471ec3ec@linux.alibaba.com>
Date: Tue, 2 Dec 2025 13:37:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] support batched checks of the references for large
 folios
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
 <341d1aed-13ad-41ee-ad30-487c5baec399@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <341d1aed-13ad-41ee-ad30-487c5baec399@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E84DB40002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mor5cpagk9b3hqir9qo15ukpcdpgt9js
X-HE-Tag: 1764653886-56006
X-HE-Meta: U2FsdGVkX19S+BGz6yVW+G4b63iJyq4YZFpvJV4wKlb5Q5t8FsAPOSfp+Ltl+EcybSZ8XkFWRmn3ieaCGuet7eV1+Y1zAvUeD2QlPCPKcujLVuyk4l7YQKzhawYdTGfkIcoToD3+jiJA+Au7DLzIGcXnxgNrOzzrlYnS32ZWT0wxYxZbL53NtYuq1VeeYzLswScQWSKaNQwU3BfDjktZ458ZidRAduBVfBKZAzgRohAmVGXHE05ESicCNhWGJ0lU1z2iLibTnWklaEgkhLbB+6O87QkPdgQzYm7ER27/kXDiu5TxkNJXnG72XjNLpnkDwMcQ0oYzSX5FrMhC5Kxih0U3e3L41v8upHHZQqNSMiA2eJ4kVWZD7BuGXwfodZ0lZ0GSkNOTBo5JnYixKI+24FOZKaLNzdfpCoNPFS/5YDkE4XBpC6hQhSIwm9LULwKOhzeZ73B1mBcGQ3DPy/WX1KVa+KYHrrU7+K3zCNKDYa6zOYOHBwm0tdnmBwUpKQHPC6/B7Ptp4Gv2HTF0Hirf6E68j7y2LSloHesF2OB94W2if1PkLho0iGW8I1HIb2hTb7H8OAM12L6oip8/ZCDbtu31A90TSJwdw92OFH3b4skghEojiSgG4Wlrwi/9RxvzavnNG8S+2P8EzZ6ev4cSMTnQFYQOWKmIj0g0BE4Xt5DwqNzQFTNC17PjMFuYmKVVDJWdQ51wZ9/Lxb1HglZX/82OR8Y5tc1R8bc4daHSPBu/xYG8XuvnjRCBrmGDuoAtd4dQqJS6Axzjb198FTUUVBCytm95hYHScvzJyVRzHENkUEfud1KaOgeezBwMQXU8qFaia8yICNOdp9/KNOtH1ywe1kDov4RDJR6Q0PNhwT0jYyU9DA20V6nxOWeHgWnnVe1QFIPVGKzPxbRgfTgLM+vT+RISNkA6Ko9RU6uYwV8KZLNnX7Uo+G5moSByiluzXUl4iQ28p8u/10J6JHn
 m+Iy3NLv
 NRy9xXC9Q7DUEfw+bNNbfYyqdH/EuuRLhQklCVnMvYOJDx7tPbdG7RrtlAWA7Cn5RXkqPRsZZMeMyWLz4+Cs0W3lzoncYmnuRC+cRGG/OdfLb4wKVGRXAc4VGkYy2s9PFkQK7kN5Jx2if9eNn9KrNzM8C2f7fABQplcblzTzSxbR26zt2HRRPCO+E7qQ5tLe4Yj5vdBR72EKLDLNTRs6A30UbSkDV3xazQi2JD/6fu1QfOoKpM53XKAiJeEsqEcaDghBygTgBTxDOe3B9GVpHuUMIzxgSn7ii/C4DhT11cmFV0dvfwEZhpQ4flwvApwpa51Ph
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/2 00:23, David Hildenbrand (Red Hat) wrote:
> On 11/25/25 01:56, Baolin Wang wrote:
>> Currently, folio_referenced_one() always checks the young flag for 
>> each PTE
>> sequentially, which is inefficient for large folios. This inefficiency is
>> especially noticeable when reclaiming clean file-backed large folios, 
>> where
>> folio_referenced() is observed as a significant performance hotspot.
>>
>> Moreover, on Arm architecture, which supports contiguous PTEs, there 
>> is already
>> an optimization to clear the young flags for PTEs within a contiguous 
>> range.
>> However, this is not sufficient. We can extend this to perform batched 
>> operations
>> for the entire large folio (which might exceed the contiguous range: 
>> CONT_PTE_SIZE).
>>
>> By supporting batched checking of the young flags and flushing TLB 
>> entries,
>> I observed a 33% performance improvement in my file-backed folios 
>> reclaim tests.
> 
> Can you point at the benchmark or briefly explain what it does? What 
> exactly are we measuring that improves by 33%?

Sorry for not being clear. I've described the performance test in patch 
2, and I should have copied it to the cover letter:

"
Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and 
try to reclaim 8G file-backed folios via the memory.reclaim interface. I 
can observe 33% performance improvement on my Arm64 32-core server (and 
10%+ improvement on my X86 machine). Meanwhile, the hotspot 
folio_check_references() dropped from approximately 35% to around 5%.

W/o patchset:
real	0m1.518s
user	0m0.000s
sys	0m1.518s

W/ patchset:
real	0m1.018s
user	0m0.000s
sys	0m1.018s
"

