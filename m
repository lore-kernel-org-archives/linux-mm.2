Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E70CC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468EB6B00A6; Wed,  1 Jul 2026 07:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440D96B00A8; Wed,  1 Jul 2026 07:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331E06B00A9; Wed,  1 Jul 2026 07:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3BC6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:03:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7DC48A0315
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:03:47 +0000 (UTC)
X-FDA: 84939922494.28.8852F9A
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77B92A0012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:03:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yFxKMR0d;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782903825;
	b=4f7MjJUHck4wK+Wy2eJOyRHhR8/ZoBxeipGYfD7V4lsMGnVQzN9XR6In9VXExlq51Q3iaf
	bLuoawVXOTQrywrlRTrAAumEjoSyJy7UuSZnoZRoFkmt4/OTouPLl3QIzUx3tf5pnylYnz
	5yzKe4CYAAvrTRQmhbESL8AYLI6gTfI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782903825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiAQQLl8vVs83xuAeiGeNLD4wLKcdjLHTtoBRrCpg8E=;
	b=0VDLuF2mGMbaKyywpkQg97YWQN1qHwxvM8XdIAfpG363MNzyahmZ0ZdoZS+TKpiVpRijus
	67SbJPcking3oZAg3Q/ZFssaO+fkgTOZVmrlffMvw0SUrFb3cfAyFZ82iCrwoiADcE8/00
	QfgdJIkIKMrmjHQnQq4VJmhH5uQV9LI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yFxKMR0d;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782903817; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=BiAQQLl8vVs83xuAeiGeNLD4wLKcdjLHTtoBRrCpg8E=;
	b=yFxKMR0dYhvSC23dj6Enjel0Qdkv9wO4qVgyU33An9NDYrHBfSBF2BgrlU6klTJdXXYRa8tQiaIjWNdbvlvsGL5n3uw3mYJ/jOF9cDTDisyTDszR7Tc+Pvix947f6kfpYv16IlhBpHQ6Y3guPPicGLxIsmWfno/WsDuMfJSadxw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X67dyRL_1782903814;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X67dyRL_1782903814 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Jul 2026 19:03:35 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,  Zi
 Yan <ziy@nvidia.com>,  Matthew Brost <matthew.brost@intel.com>,  Joshua
 Hahn <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul
 Park <byungchul@sk.com>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Neha Gholkar
 <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
In-Reply-To: <akPg4ANRetbjSP_b@gourry-fedora-PF4VCD3F> (Gregory Price's
	message of "Tue, 30 Jun 2026 11:29:36 -0400")
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
	<akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
	<87h5mkz33h.fsf@DESKTOP-5N7EMDA>
	<akPg4ANRetbjSP_b@gourry-fedora-PF4VCD3F>
Date: Wed, 01 Jul 2026 19:03:32 +0800
Message-ID: <877bnfynsr.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: 9annur6k6hsn9wdo814jezqb7aajee8d
X-Rspamd-Queue-Id: 77B92A0012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782903820-816204
X-HE-Meta: U2FsdGVkX19walupu3fcVj3YgsZQ+5AE1wY/oizoMkqBthBuVja3kpIQOANxJfCwN3UzTV5LZauSYC8uRmHC4TsHtR18axJopoWN6PYnH3zOKPM7O/H07Rm6vhzz8x3MN/Xbn4H1LHf+JkQN7yIJzfDBWMOvaUyyqDDsp1REIOjmOPnTHCuzmUuq/NUnMGpMzo5VKpvixzvy01nX2yyT7XdtG9c8z8fb5A0T5BPPYHGA0gy2g3dmr9+2Ptksrf5c01MJUbOf1Y0UttoxBWDfNRayGh4YvYEPjYPUchi3sEGSY7RJikeJANfzT6hxIKlWndO2QpiL07YAgthtPnzgCwlVrjLd8Dvzj1nPzwTZJ8oJ7V3yEKOSy8rr85vDsoAl+OFqV2jG5O2+t+O9FMndl7GSjzRnWaXxFckgYV6QQ7Y8HCRHqWomfIV6Z2+UqmGgY1RpRkkt4h9HagBj33ZLPxVqIoAjgxJSVpIW8XkJhzKiS9HjY6MmEIZXz1UNOWLHcaCQ/zmNCzT171bfokWCUFPkKYHWf/VAAZH/UD7ICzEYJuqk8s07yEXtAG8naMYnh45V4fLnVLoKx+hODgwVW1SN2TcRn9gjG921e30U70RYO+DjrMKHuAQrclnYB85DPXT+++cdqekTPs9yXTglQKAcP4fydSS8Qcbc6EU+BoyX1zrIJ9rJ1+mJK8r2tK12IsqOcm4w/YTwdCrTW8qvH1KVt/oRXezy3ZCQFPTjWCgaXAS+kR0uvFM6AJJNRxFyySqidX7GIjsAFZq4HQ+x3+nBdcD1YXseUCVmgg9cCC3I4A0AqEPtHb9injxw6VWzjbA5BTYO4S8w4dq0MbBxYdQ8Y5pHI40ebwwMRkDiSaFDVQgjcx+roHphSBzL69ZjCk8pFc7/TDwCtpUuvH771YJANLw/WCKjkDCeqowMRnlDhBz6kjVVFiZ4Bzwvfi+3XnT6rXD3WgaX5vS9Feg
 XVnVqnQ7
 cuEwPyPkRdpv9ZU1ZKxVilsZoB2rKWUMOIKr+cd3tVKUX90LUKqnNG7+vSWaIY2IF+VtRqvocR+LW733elO4wXrHRVFmsoKdIEBUJT8Bx7vGgr6zTm9OrBFbcPfFRwo4R/iJsdtMBZuSeO5h2g7G9yBI3pZXXQGtJMDKjJfl0NVeNof3vTsh6G8UkKVYL0V/ZtKmUHIR+ZK063eFpLCy82cO+hUfoYPWKq7F+8GRdx3Htw8yvTXfcmXJPVJ7+krwst2iN22iMgr5myveQph0+DiOB8UZBoMhsTjQLExAkiV4r1i7T9YhpDDe+fVoTO3Z2rmN0ZHf3CUhiMEQo/shkFO/YirtEzXDTQkZXxMfkc+Va9gwkUo40YMwCywMsqoe0PcvzHnTYkvBBpWo9u7JF9HastA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> On Tue, Jun 30, 2026 at 07:20:50PM +0800, Huang, Ying wrote:
>> Gregory Price <gourry@gourry.net> writes:
>> 
>> [snip]
>> 
>> > Demotions don't care about mempolicy, so opting shmem out of NUMA
>> > balancing and mbind'ing on a tiered system is just full sadness.
>> >
>> > This is all just more evidence that demotion needs to be completely
>> > redone, it's creating a mess of undefined behavior for memory placement.
>> 
>> It's hard to respect mempolicy during demotion in the current
>> implementation.  Do you have any ideas on how to improve this?
>> 
>
> I think it's feasible we could respect per-vma mempolicies, but not
> per-task.  That would at least make this particular interaction less
> painful and mbind() would do what you'd expect.  It is a bit racy,
> but with MPOL_MF_MOVE_ALL the user can get what they actually want.

Yes.  Per-vma mempolicy support is possible.

> I think task-wide mempolicy is problematic and generally a bad idea
> on tiered systems, maybe it's ok if we simply document task policies
> are not respected on tiered systems?

Anyway, it's convenient to use numactl to manage mempolicy.

Is it possible to enable NUMA_BALANCING_MEMORY_TIERING for non-default
VMAs?  If we don't enable NUMA_BALANCING_NORMAL, the overhead should be
OK because the page table entries are changed to PROTN_ONE only for
pages on the slow tier.

Additionally, we may need to consider cpusets.

---
Best Regards,
Huang, Ying

