Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1768FC88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 19:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E713A6B0088; Tue, 15 Sep 2026 15:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22926B008C; Tue, 15 Sep 2026 15:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA566B0092; Tue, 15 Sep 2026 15:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 933C36B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:52:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12A8B14055D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:52:44 +0000 (UTC)
X-FDA: 85217044248.20.88DB172
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54FA316000F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:52:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QKK/XRQj";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789501962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3jb+b49XGq0bJzXygOq2o2CoMYGiIAWWOQSEgUGAqU=;
	b=Xyc/dqVU3r1pvyb6ZKQrryHUCXlA1FZxio6x6XA7K5AgZHd7+rleDAMOzgE5vHV3I/YrRb
	GY6D15oUZq0fDjvmmtpuvPM+Adj7yrAkdsSzu2vLnNkoIxOM6F9VUB198qk5x/k/m1wi1q
	akzbmO0D3IiuPiCaoVVsjCPgUd2Q75Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QKK/XRQj";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789501962;
	b=kU14ZjxpRETKmrYVBJHuYl1dosJiCgmpnFbrbcmDwhRQwC6YFNRhUV4s0PsoYgKgpsbZSu
	pCZaeC/dH2iTm21NeRTYF0J7wbOQhMy7C43SpidPV3sKN1XBGz/gQ1/BkT+d6+wHcQ5Vhc
	wRZAlXdePjVN8NDFm46anUTuiEujbSg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2568602C2;
	Tue, 15 Sep 2026 19:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2151F000FF;
	Tue, 15 Sep 2026 19:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501961;
	bh=Z3jb+b49XGq0bJzXygOq2o2CoMYGiIAWWOQSEgUGAqU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=QKK/XRQjep+1aojlMKgKnt9+50g4VNDYyrq9fYrtrU61kM+iKL/R6AaPWw1rQRvnb
	 QXwq6HLSE8neJNNIWcoIa+MKHtTWsYrCopVkPXXPZHjf4VOJwEdqg+I+Ft9+qBZpLo
	 mrS1zjX81XhhMedh+Ip/Jwaiyf5YHPYBi7fa9itU1Pr6XFMxgoithdGemi8v2M0Vic
	 FrxAXFkvnktatrquG/5oO/7NHfQsTAFKakOso+gy3dtZhGxcl03Qyrje/pJTtQ3U8R
	 eKoalf3CovzoBT6LPhtVBT+Mi5VKKfEoB+pgB/LXzPcYLXXYmiuE3eA2pkniyMh3mq
	 7g68BxDp0GaRQ==
Message-ID: <16f9ea47-99c0-4483-a12f-190047c1411f@kernel.org>
Date: Tue, 15 Sep 2026 21:52:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>,
 ljs@kernel.org, xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, usamaarif642@gmail.com, yuzhao@google.com,
 aarcange@redhat.com, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
 <20260609172719.803537-1-usama.arif@linux.dev>
 <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
 <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org>
 <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
 <0b268070-95d2-45bd-aea3-56cefe01dc8c@kernel.org>
 <CAA1CXcCp0z0kw9pQtj55qNGOBJOpfDsrf1GJ+EhGZCfA+dhbKQ@mail.gmail.com>
 <004bdc87-8c8e-44f8-93c3-1ae0a47051a9@kernel.org>
 <CAA1CXcA50Lfeo+JkhhRc5b8TNzBETj8+z6iMVuqwUSJhyo2G8w@mail.gmail.com>
 <1da189ad-a7f6-42fa-a1ff-a26cc5e5c563@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1da189ad-a7f6-42fa-a1ff-a26cc5e5c563@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54FA316000F
X-Stat-Signature: nm1t1gg553oyo41fwua5pgjqr1zah4gb
X-Rspam-User: 
X-HE-Tag: 1789501962-404793
X-HE-Meta: U2FsdGVkX1/QLCXeubdRDMAApprGfVU3kgFzvWNHVl/iJ8j7Mbdr8Eb0L/tb6/eg4EQWDVfuDsSasRCBY5t2P8KYvcoZ3+Qjr5Ag7RU8is5uFYcaqps49Zt9ekYwYMx9mnSrKjMsYmluDlPUDsQKM0OuyKVJn5KxZxEztmaxPdW/tRYqtQswfl7IiJm4MIFW/8sF6bIzyqSV9vr/jTW+X55OyKr5HVLxAuxhI3PoyA56O+Dn2NELQ4X2Ui4WwPOKGEGgj4x2VhZZuKhVhTrKub+RzrYXPcNEFnjM7tCyWdpokZMSNHhXCB/5XJAWoIpmlrcupF99KLx37HE8jCs/KdeDBUqpqZpotOX/tmV//R6nvXnQP/9Rv8S1Jx9o8oJu0pSwT3VqTNsjhrkeic8PJcA0Bvh8VS1VqVeo0Po2VtEzX6lrisldaw4u+sg975T+5zbKshNTfblgvdiK1bpnzMJm9u9vFTe4BfrqIbXOFJiF52++nasrbS4OW+LDfftjCzz+bMTsARt2UPpHh6cloMejQklP4XKtd2dQG/PcG13WByNkuZ7bP8aNScemm9ELwdrqfE9x8/NdHn3o0kZ0fmvZdSIuRV7T53Aha/50L8N7eIUmYn7i5AGgdlpFCGnPCbmEwjr0m7YXZLfN546Nw8b2iFn41sx1twASHG4862xQxSgqo4ZlJev9Re+ARQXXtUEFeKTUXlGnhlq1I7PB8Cx0rvA51Ba/9HRjh/Hs9mogVxf3XfitGXWNXouz84bOcZcY6mgbNftgYRVRxkeTS4rOB8KYJggidvWuPlBKy7UH9LFsMa8uALpNNbMB0pG8kIgZK4dzCv8nGh2tFOAWvB6wTGb5WKlLXH4po0l7V5oUXjHwixfuga34f3Bs1slgAOSX/BwD/CJq8LpfP45eZFr4SiGjzTmnVFB/d4gxkaoCT5Fw6V8C8keG0c/k0kYXI3hdxikwop8URi2XS3t
 k+yaziSt
 Qv54h+DANYMdcgxQs82baSDbCC31Srs+JJvzZ1wULMGMaCVjc297fqtFV8kKVCQE9NFrD6Sa42lqEk7RFHA8JlnP492H2nf7Yn6GD+ucL0MugV+6jBHNzJHUKmY9EAWy/VBDjv2elyZ8LSMeotFSyUE9+IytJ6npKCWRM14j72kScv1eBWHm75ZVlQZysQ/S31N3YfMuzOlvD4anhHdQtC8rSDa1ecszjsqGcncX7jt4L/I/pEYHlSsALZxE8oHEbLFSCpUt5y3XQxj6cGLQGLgJtnlQrV4Tx3YK2LbnMmO3xF8pT5ue32205VSIIa4oHWYeYda/XFJOPsfURXOHO+lk3bMSa/JzbGGaAxJbnc6Pm5cRvXVYvZyKCsZb5W1X8dtje
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 19:34, David Hildenbrand (Arm) wrote:
> On 8/5/26 18:27, Nico Pache wrote:
>> On Thu, Jul 30, 2026 at 2:34 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>>
>>> Because KSM takes care of it?
>>
>> KSM only takes care of it in the case of 'use_zero_pages' being set.
>> If we stop KSM splits from reclaiming, we regain the intended sysctl
>> behavior; otherwise, KSM splits and reclaims indiscriminately. The
>> secondary effect is that if we don't have this toggle set, the split
>> would still reclaim these pages. KSM then has to process those pages
>> (despite them already being freed), wasting cycles.
>>
>> Your proposed solution works too, I just think its a more aggressive
>> approach (stop all VM_MERGEABLEs from split-reclaiming, not just those
>> that are currently being operated on by KSM).
> 
> I think we should really just stop two mechanisms to compete entirely: if A is
> active for a region, B is disabled.
> 
> Not trying to follow "who split what" and operate based on that.
> 

I took another look and there is just no perfect solution.


Option A: don't let mechanisms interfere - if KSM is enabled, don't remap to the
          shared zeropage

Positive: same KSM behavior even if some other mechanism decides to split.
Negative: reclaim cannot free up these pages immediately (waits for KSM), and
          having the deferred shrinker split to then not reclaim any actual
          memory is stupid.

Given that the second KSM run would already deduplicate these pages, I am not
sure how much reclaim actually matters.

But taming the deferred shrinker is a bit complicated (no VMA available). In
configurations where the deferred shrinker will never trigger a split that's not
a problem, but with lower max_ptes_none it would be possible to trigger.


Option B: don't let KSM splits remap to the shared zeropage

Positive: Fix isolated to the actual problematic part we observed.
Negative: Different KSM behavior depending on who split a THP first.


Assume KSM scanned the range first, and then the deferred shrinker split many
THP in that area and creates shared zeropage. On the next KSM run, we'd have a
very similar behavior. If KSM runs first, you either get zeropages or
deduplication to a zero-filled page.


I would not go down a path where we would let KSM skip THPs entirely.

Maybe one could teach KSM about "the deferred shrinker is active, don't split a
THP if we are to deduplciate the shared zeropage"? But then, whether the
deferred shrinker will actually split depends on the max_ptes_non toggle.


Gahhh so complicated.

-- 
Cheers,

David

